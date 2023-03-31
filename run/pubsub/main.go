// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// [START cloudrun_pubsub_server]
// [START run_pubsub_server]

// Sample run-pubsub is a Cloud Run service which handles Pub/Sub messages.
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", HelloPubSub)
	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("Defaulting to port %s", port)
	}
	// Start HTTP server.
	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

// [END run_pubsub_server]
// [END cloudrun_pubsub_server]

// [START cloudrun_pubsub_handler]
// [START run_pubsub_handler]

// PubSubMessage is the payload of a Pub/Sub event.
// See the documentation for more details:
// https://cloud.google.com/pubsub/docs/reference/rest/v1/PubsubMessage
type PubSubMessage struct {
	Message struct {
		Data []byte `json:"data,omitempty"`
		ID   string `json:"id"`
	} `json:"message"`
	Subscription string `json:"subscription"`
}

type BQMessage struct {
	State  string `json:"state"`
	Params struct {
		DestinationTableNameTemplate string `json:"destination_table_name_template"`
	} `json:"params"`
	ErrorStatus struct {
		Code    int    `json:"code"`
		Message string `json:"message"`
	} `json:"errorStatus"`
}

// HelloPubSub receives and processes a Pub/Sub push message.
func HelloPubSub(w http.ResponseWriter, r *http.Request) {
	var m PubSubMessage
	var n BQMessage
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Printf("ioutil.ReadAll: %v", err)
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}
	// byte slice unmarshalling handles base64 decoding.
	if err := json.Unmarshal(body, &m); err != nil {
		log.Printf("json.Unmarshal: %v", err)
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	if err := json.Unmarshal(m.Message.Data, &n); err != nil {
		log.Printf("json.Unmarshal: %v", err)
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	url := os.Getenv("SLACK_WEBHOOK_URL")
	if url == "" {
		m := "Error: slack not configured"
		log.Print(m)
		http.Error(w, m, http.StatusInternalServerError)
		return
	}

	msg := ""
	if n.State == "SUCCEEDED" {
		msg = fmt.Sprintf("%s: %s", n.State, n.Params.DestinationTableNameTemplate)
	} else {
		msg = fmt.Sprintf("%s: %s: %d: %s", n.State, n.Params.DestinationTableNameTemplate, n.ErrorStatus.Code, n.ErrorStatus.Message)
	}

	postBody, err := json.Marshal(map[string]string{"text": msg})
	if err != nil {
		m := fmt.Sprintf("Error: building slack message: %v", err)
		log.Print(m)
		http.Error(w, m, http.StatusInternalServerError)
		return
	}

	resp, err := http.Post(url, "application/json", bytes.NewBuffer(postBody))
	if err != nil {
		m := fmt.Sprintf("Error: sending slack message: %v", err)
		log.Print(m)
		http.Error(w, m, http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		b, _ := ioutil.ReadAll(resp.Body)
		m := fmt.Sprintf("Error: sending slack message: %d: %s", resp.StatusCode, string(b))
		log.Print(m)
		http.Error(w, m, http.StatusInternalServerError)
		return
	}
}

// [END run_pubsub_handler]
// [END cloudrun_pubsub_handler]
