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
