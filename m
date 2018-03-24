From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH v2 03/15] khwasan: add CONFIG_KASAN_CLASSIC and
 CONFIG_KASAN_TAGS
Date: Sat, 24 Mar 2018 09:43:32 +0100
Message-ID: <20180324084332.u6qik7lkdbenqbb2@gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <1fb0a050a84d49f5c3b2210337339412475d1688.1521828273.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E564A006
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 04:36:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QJot9DbC5kDV for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Mar 2018 04:35:39 -0400 (EDT)
Received: from mail-wr0-f195.google.com (mail-wr0-f195.google.com
 [209.85.128.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2289D4A005
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 04:35:38 -0400 (EDT)
Received: by mail-wr0-f195.google.com with SMTP id s18so14229982wrg.9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 01:43:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1fb0a050a84d49f5c3b2210337339412475d1688.1521828273.git.andreyknvl@google.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev@googlegroups.com, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, linux-arm-kernel@lists.infradead.org, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ramana
List-Id: kvmarm@lists.cs.columbia.edu

CiogQW5kcmV5IEtvbm92YWxvdiA8YW5kcmV5a252bEBnb29nbGUuY29tPiB3cm90ZToKCj4gVGhp
cyBjb21taXQgc3BsaXRzIHRoZSBjdXJyZW50IENPTkZJR19LQVNBTiBjb25maWcgb3B0aW9uIGlu
dG8gdHdvOgo+IDEuIENPTkZJR19LQVNBTl9DTEFTU0lDLCB0aGF0IGVuYWJsZXMgdGhlIGNsYXNz
aWMgS0FTQU4gdmVyc2lvbiAodGhlIG9uZQo+ICAgIHRoYXQgZXhpc3RzIG5vdyk7Cj4gMi4gQ09O
RklHX0tBU0FOX1RBR1MsIHRoYXQgZW5hYmxlcyBLSFdBU0FOLgoKU29ycnksIGJ1dCB0aGlzIGlz
IHByZXR0eSBvYnNjdXJlIG5hbWluZyBzY2hlbWUgdGhhdCBkb2Vzbid0IGV4cGxhaW4gdGhlIHBy
aW1hcnkgCmRpZmZlcmVuY2UgYmV0d2VlbiB0aGVzZSBLQVNBTiBtb2RlbHMgdG8gdXNlcnM6IHRo
YXQgdGhlIGZpcnN0IG9uZSBpcyBhIHB1cmUgCnNvZnR3YXJlIGltcGxlbWVudGF0aW9uIGFuZCB0
aGUgb3RoZXIgaXMgaGFyZHdhcmUtYXNzaXN0ZWQuCgpSZW1pbmRzIG1lIG9mIHRoZSB0cmFuc3Bh
cmVuY3kgb2YgZ2FsYWN0aWMgYnVlcm9jcmFjeSBpbiAiVGhlIEhpdGNoaGlrZXIncyBHdWlkZSAK
dG8gdGhlIEdhbGF4eSI6CgogIOKAnEJ1dCBsb29rLCB5b3UgZm91bmQgdGhlIG5vdGljZSwgZGlk
buKAmXQgeW91P+KAnQogIOKAnFllcyzigJ0gc2FpZCBBcnRodXIsIOKAnHllcyBJIGRpZC4gSXQg
d2FzIG9uIGRpc3BsYXkgaW4gdGhlIGJvdHRvbSBvZiBhIGxvY2tlZCBmaWxpbmcgCiAgIGNhYmlu
ZXQgc3R1Y2sgaW4gYSBkaXN1c2VkIGxhdmF0b3J5IHdpdGggYSBzaWduIG9uIHRoZSBkb29yIHNh
eWluZyDigJhCZXdhcmUgb2YgdGhlIAogICBMZW9wYXJkLuKAnSAKCkknZCBzdWdnZXN0IHNvbWV0
aGluZyBtb3JlIGV4cHJlc3NpdmUsIHN1Y2ggYXM6CgoJQ09ORklHX0tBU0FOCgkgIENPTkZJR19L
QVNBTl9HRU5FUklDCgkgIENPTkZJR19LQVNBTl9IV19BU1NJU1QKCm9yIHNvPwoKVGhlICdnZW5l
cmljJyB2YXJpYW50IHdpbGwgYmFzaWNhbGx5IHJ1biBvbiBhbnkgQ1BVLiBUaGUgJ2hhcmR3YXJl
IGFzc2lzdGVkJyBvbmUgCm5lZWRzIHN1cHBvcnQgZnJvbSB0aGUgQ1BVLgoKVGhlIGZvbGxvd2lu
ZyBvbmVzIG1pZ2h0IGFsc28gd29yazoKCiAgIENPTkZJR19LQVNBTl9IV0FTU0lTVAogICBDT05G
SUdfS0FTQU5fSFdfVEFHUwogICBDT05GSUdfS0FTQU5fSFdUQUdTCgouLi4gb3Igc2ltcGx5IENP
TkZJR19LQVNBTl9TVy9DT05GSUdfS0FTQU5fSFcuCgpJZiBvdGhlciB0eXBlcyBvZiBLQVNBTiBo
YXJkd2FyZSBhY2NlbGVyYXRpb24gYXJlIGltcGxlbWVudGVkIGluIHRoZSBmdXR1cmUgdGhlbiAK
dGhlIENPTkZJR19LQVNBTl9IVyBuYW1lc3BhY2UgY2FuIGJlIGV4dGVuZGVkOgoKCUNPTkZJR19L
QVNBTl9IV19UQUdTCglDT05GSUdfS0FTQU5fSFdfS0VZUwoJZXRjLgoKPiBCb3RoIENPTkZJR19L
QVNBTl9DTEFTU0lDIGFuZCBDT05GSUdfS0FTQU5fQ0xBU1NJQyBzdXBwb3J0IGJvdGgKPiBDT05G
SUdfS0FTQU5fSU5MSU5FIGFuZCBDT05GSUdfS0FTQU5fT1VUTElORSBpbnN0cnVtZW50YXRpb24g
bW9kZXMuCgpJdCB3b3VsZCBiZSB2ZXJ5IHN1cnByaXNpbmcgaWYgdGhhdCB3YXNuJ3Qgc28hCgpP
ciBkaWQgeW91IG1lYW4gJ0JvdGggQ09ORklHX0tBU0FOX0NMQVNTSUMgYW5kIENPTkZJR19LQVNB
Tl9UQUdTJyEgOy0pCgpUaGFua3MsCgoJSW5nbwpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
