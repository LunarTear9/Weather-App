'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "b699000f9512c8612c151bd96b21013d",
"assets/AssetManifest.bin.json": "d9633b6c48314902e88abb18eaedcb84",
"assets/AssetManifest.json": "0e50635722b6092f2f25759637ba999f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "fa68c6a05d3622662af1d903c5eb10d4",
"assets/lib/assets/25231.png": "ec3a60c8c6539a07eb70b52f6737ea6e",
"assets/lib/assets/athens-transport-background.jpg": "9a48065f14b0af4cfab1f3a0d951a66c",
"assets/lib/assets/background.png": "638db0364b196cd42190889a87067e88",
"assets/lib/assets/c413.png": "15b366f3c23153e2925a59a4e30a61ac",
"assets/lib/assets/cloud.png": "701248db6322134341ea9363b193c06f",
"assets/lib/assets/cloud2.png": "12c9adb3d01209d3e3fe4edff17bac90",
"assets/lib/assets/clouddisplay.png": "93b4f669890c892a3ead019b76a821d9",
"assets/lib/assets/heavy-rain.png": "82760089d66627f5b329ab0b5735e8b5",
"assets/lib/assets/heavy-rain2.png": "527e76cc1756bc6d4846407a34078e44",
"assets/lib/assets/heavy-rain3.png": "351046e5f53a0c5ef40e23373e967538",
"assets/lib/assets/sky.jpg": "a8f29a9dd54039a459a312b6fda2728f",
"assets/lib/assets/sky1.jpg": "30aba21afe2ddd160ed7cf627b9b1a61",
"assets/lib/assets/splash.png": "27e3703c45be41f303831018eba4e83b",
"assets/lib/assets/sun%2520(1).png": "5760fc83f8af8529ce0b1532a8dd8c82",
"assets/lib/assets/sun%2520(2).png": "476249666a5d0fd39d4239627ec8fb27",
"assets/lib/assets/sun.png": "e54666e665438f6249f36062b93807af",
"assets/lib/assets/temperature.png": "3cff9b9bd08e3ff6afd82707ccff1ec3",
"assets/lib/assets/water.png": "64492c9e70ab283eea5b3932a337fadf",
"assets/lib/assets/water2.png": "54c8864fb5f9700e34d62f60858c6288",
"assets/lib/assets/wind.png": "29baec976118e58a2fd53ef26fb10d2d",
"assets/NOTICES": "02bb5161a439e68bf601aa368fe124fe",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "1e849163f8c073324698731a2caf2eef",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "3a78b757d1f35817b03b6bed5166480a",
"/": "3a78b757d1f35817b03b6bed5166480a",
"main.dart.js": "073ee05137178676926beaae08b9e2ff",
"manifest.json": "f4f9a2c031137f64a763d50636a20d53",
"splash/img/dark-1x.png": "6bc1e3869c12393ea83b83b4975e817f",
"splash/img/dark-2x.png": "2038d02d2b6af3e2125193e4e0dc1ce5",
"splash/img/dark-3x.png": "9eb39964f1968fcfe6edf1ea259664c9",
"splash/img/dark-4x.png": "7568c216d5947b45be0861a34ade8305",
"splash/img/light-1x.png": "6bc1e3869c12393ea83b83b4975e817f",
"splash/img/light-2x.png": "2038d02d2b6af3e2125193e4e0dc1ce5",
"splash/img/light-3x.png": "9eb39964f1968fcfe6edf1ea259664c9",
"splash/img/light-4x.png": "7568c216d5947b45be0861a34ade8305",
"version.json": "c82a96a267490cbb773d7ec2303b346e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}