/*
 * Copyright (C) 2016-2021 Lightbend Inc. <https://www.lightbend.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package helloworld

import cloudflow.flink.FlinkStreamlet
import org.apache.flink.streaming.api.scala._
import cloudflow.streamlets.{StreamletShape, StringConfigParameter}
import cloudflow.flink._
import org.apache.flink.streaming.api.functions.source.datagen.{DataGeneratorSource, SequenceGenerator}

class HelloWorldShape extends FlinkStreamlet {
  val shape = StreamletShape.empty

  def createLogic() = new FlinkStreamletLogic {
    override def buildExecutionGraph: Unit = {
      context
        .env
        .fromCollection(new Iterator[Int] with Serializable {
          @transient var last: Int = 0

          def hasNext(): Boolean = true
          def next(): Int = {
            Thread.sleep(1000)
            last = last + 1
            last
          }
        })
        .map{x => s"number: $x" }
        .addSink(x => println(x))
    }
  }

}
