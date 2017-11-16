# UndeadBread Server
A RESTful API written in Swift using the Perfect framework

## Building


### Ubuntu 16.04

1. Install Swift 4 dependencies

`sudo apt-get install clang libicu-dev`


2. Get the latest Swift 4 snapshot

`wget https://swift.org/builds/swift-4.0-release/ubuntu1604/swift-4.0-RELEASE/swift-4.0-RELEASE-ubuntu16.04.tar.gz`

3. Import swift GPG keys

`wget -q -O - https://swift.org/keys/all-keys.asc |   gpg --import -`

4. Unzip the Swift bundle you downloaded above and add the contained `/usr/bin` folder do your PATH

```
tar xzf swift-4.0-RELEASE-ubuntu16.04.tar.gz
export PATH=/absolute/path/to/swift-4.0-RELEASE-ubuntu16.04/usr/bin:"${PATH}"
```

5. Install dependencies

`sudo apt-get install libpython2.7 libcurl3 libmysqlclient-dev libssl-dev uuid-dev`

6. Clone the repo and build

```
git clone https://github.com/ciauri/undeadbread.git
cd undeadbread/undeadbreadAPI
swift build
```

7. The binary will be built and reside in the .build/debug folder and be named `undeadbreadAPI`

### macOS

*One of the crypto libraries in this project requires OpenSSL. Unfortunately, Apple has forked OpenSSL and included their own, incompatible implementation of it in the OS. This means that you must install the open source version of the library. I used Homebrew, but you can use whatever you like.*

1. Build the project and explicitly link OpenSSL to wherever it is on your filesystem. I left my filesystem's homebrew location here as an example, but be sure that you put the correct path for your own environment.

`swift build -Xswiftc -I/usr/local/opt/openssl/include -Xlinker -L/usr/local/opt/openssl/lib`

2. Generate the xcodeproj (and still manually link OpenSSL) because who doesn't love a good Xcode project?

`swift package -Xswiftc -I/usr/local/opt/openssl/include -Xlinker -L/usr/local/opt/openssl/lib generate-xcodeproj`


## Running
1. Modify the `config_sample.plist` to your specifications.
2. Use the command line argument `-config` to point to the desired config plist.
3. `./undeadbreadAPI -config /path/to/your/plist`
4. That's it!

- If you're using Xcode for development, make sure you Edit Scheme -> Arguments -> add the `-config /path/to/config.plist` as a command line argument
