#include "detect.h"

Napi::Object Init(Napi::Env env, Napi::Object exports) { return Napi::Function::New(env, detect); }

NODE_API_MODULE(addon, Init)
