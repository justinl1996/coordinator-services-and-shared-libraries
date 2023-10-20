/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.scp.shared.aws.gateway.serialization;

/** Exposes a facade for common json serialization operations. */
public interface SerializerFacade {

  /**
   * Serializes an object to json.
   *
   * @return {@code String} that is json serialized object
   * @throws SerializerFacadeException if serialization failed
   */
  String serialize(Object toSerialize) throws SerializerFacadeException;

  /**
   * Deserializes an object from json.
   *
   * @return {@code T} tha is deserialized oject
   * @throws SerializerFacadeException if deserialization failed
   */
  <T> T deserialize(String json, Class<T> valueType) throws SerializerFacadeException;
}
