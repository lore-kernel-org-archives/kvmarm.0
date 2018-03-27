From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH v2 03/15] khwasan: add CONFIG_KASAN_CLASSIC and
 CONFIG_KASAN_TAGS
Date: Tue, 27 Mar 2018 22:02:23 +0200
Message-ID: <20180327200223.5ku2eqkppi7z3sd2@gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <1fb0a050a84d49f5c3b2210337339412475d1688.1521828273.git.andreyknvl@google.com>
 <20180324084332.u6qik7lkdbenqbb2@gmail.com>
 <CAAeHK+za1Zg2+1_CFrQbdn_Hwa9o_nZkHuMLaekV18W380jAoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FE9149FC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 15:54:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AkBh7gJaADi1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Mar 2018 15:54:26 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CB6B49DC8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 15:54:20 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id b127so101993wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 13:02:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAAeHK+za1Zg2+1_CFrQbdn_Hwa9o_nZkHuMLaekV18W380jAoQ@mail.gmail.com>
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
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>
List-Id: kvmarm@lists.cs.columbia.edu

CiogQW5kcmV5IEtvbm92YWxvdiA8YW5kcmV5a252bEBnb29nbGUuY29tPiB3cm90ZToKCj4gT24g
U2F0LCBNYXIgMjQsIDIwMTggYXQgOTo0MyBBTSwgSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5v
cmc+IHdyb3RlOgo+ID4KPiA+ICogQW5kcmV5IEtvbm92YWxvdiA8YW5kcmV5a252bEBnb29nbGUu
Y29tPiB3cm90ZToKPiA+Cj4gPj4gVGhpcyBjb21taXQgc3BsaXRzIHRoZSBjdXJyZW50IENPTkZJ
R19LQVNBTiBjb25maWcgb3B0aW9uIGludG8gdHdvOgo+ID4+IDEuIENPTkZJR19LQVNBTl9DTEFT
U0lDLCB0aGF0IGVuYWJsZXMgdGhlIGNsYXNzaWMgS0FTQU4gdmVyc2lvbiAodGhlIG9uZQo+ID4+
ICAgIHRoYXQgZXhpc3RzIG5vdyk7Cj4gPj4gMi4gQ09ORklHX0tBU0FOX1RBR1MsIHRoYXQgZW5h
YmxlcyBLSFdBU0FOLgo+ID4KPiA+IFNvcnJ5LCBidXQgdGhpcyBpcyBwcmV0dHkgb2JzY3VyZSBu
YW1pbmcgc2NoZW1lIHRoYXQgZG9lc24ndCBleHBsYWluIHRoZSBwcmltYXJ5Cj4gPiBkaWZmZXJl
bmNlIGJldHdlZW4gdGhlc2UgS0FTQU4gbW9kZWxzIHRvIHVzZXJzOiB0aGF0IHRoZSBmaXJzdCBv
bmUgaXMgYSBwdXJlCj4gPiBzb2Z0d2FyZSBpbXBsZW1lbnRhdGlvbiBhbmQgdGhlIG90aGVyIGlz
IGhhcmR3YXJlLWFzc2lzdGVkLgo+ID4KPiA+IFJlbWluZHMgbWUgb2YgdGhlIHRyYW5zcGFyZW5j
eSBvZiBnYWxhY3RpYyBidWVyb2NyYWN5IGluICJUaGUgSGl0Y2hoaWtlcidzIEd1aWRlCj4gPiB0
byB0aGUgR2FsYXh5IjoKPiA+Cj4gPiAgIOKAnEJ1dCBsb29rLCB5b3UgZm91bmQgdGhlIG5vdGlj
ZSwgZGlkbuKAmXQgeW91P+KAnQo+ID4gICDigJxZZXMs4oCdIHNhaWQgQXJ0aHVyLCDigJx5ZXMg
SSBkaWQuIEl0IHdhcyBvbiBkaXNwbGF5IGluIHRoZSBib3R0b20gb2YgYSBsb2NrZWQgZmlsaW5n
Cj4gPiAgICBjYWJpbmV0IHN0dWNrIGluIGEgZGlzdXNlZCBsYXZhdG9yeSB3aXRoIGEgc2lnbiBv
biB0aGUgZG9vciBzYXlpbmcg4oCYQmV3YXJlIG9mIHRoZQo+ID4gICAgTGVvcGFyZC7igJ0KPiA+
Cj4gPiBJJ2Qgc3VnZ2VzdCBzb21ldGhpbmcgbW9yZSBleHByZXNzaXZlLCBzdWNoIGFzOgo+ID4K
PiA+ICAgICAgICAgQ09ORklHX0tBU0FOCj4gPiAgICAgICAgICAgQ09ORklHX0tBU0FOX0dFTkVS
SUMKPiA+ICAgICAgICAgICBDT05GSUdfS0FTQU5fSFdfQVNTSVNUCj4gPgo+ID4gb3Igc28/Cj4g
Pgo+ID4gVGhlICdnZW5lcmljJyB2YXJpYW50IHdpbGwgYmFzaWNhbGx5IHJ1biBvbiBhbnkgQ1BV
LiBUaGUgJ2hhcmR3YXJlIGFzc2lzdGVkJyBvbmUKPiA+IG5lZWRzIHN1cHBvcnQgZnJvbSB0aGUg
Q1BVLgo+ID4KPiA+IFRoZSBmb2xsb3dpbmcgb25lcyBtaWdodCBhbHNvIHdvcms6Cj4gPgo+ID4g
ICAgQ09ORklHX0tBU0FOX0hXQVNTSVNUCj4gPiAgICBDT05GSUdfS0FTQU5fSFdfVEFHUwo+ID4g
ICAgQ09ORklHX0tBU0FOX0hXVEFHUwo+ID4KPiA+IC4uLiBvciBzaW1wbHkgQ09ORklHX0tBU0FO
X1NXL0NPTkZJR19LQVNBTl9IVy4KPiA+Cj4gPiBJZiBvdGhlciB0eXBlcyBvZiBLQVNBTiBoYXJk
d2FyZSBhY2NlbGVyYXRpb24gYXJlIGltcGxlbWVudGVkIGluIHRoZSBmdXR1cmUgdGhlbgo+ID4g
dGhlIENPTkZJR19LQVNBTl9IVyBuYW1lc3BhY2UgY2FuIGJlIGV4dGVuZGVkOgo+ID4KPiA+ICAg
ICAgICAgQ09ORklHX0tBU0FOX0hXX1RBR1MKPiA+ICAgICAgICAgQ09ORklHX0tBU0FOX0hXX0tF
WVMKPiA+ICAgICAgICAgZXRjLgo+IAo+IEhvdyBhYm91dCB0aGVzZSB0d286Cj4gCj4gQ09ORklH
X0tBU0FOX0dFTkVSSUMKPiBDT05GSUdfS0FTQU5fSFcKPiAKPiA/Cj4gCj4gU2hvcnRlciBjb25m
aWcgbmFtZSBsb29rcyBiZXR0ZXIgdG8gbWUgYW5kIEkgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdG8K
PiBuYW1lIHRoZSBuZXcgY29uZmlnIGp1c3QgSFcsIGFzIHRoZXJlJ3Mgb25seSBvbmUgSFcgaW1w
bGVtZW50YXRpb24KPiByaWdodCBub3cuIFdoZW4gKGFuZCBpZikgdGhlcmUgYXJlIG1vcmUsIHdl
IGNhbiBleHBhbmQgdGhlIGNvbmZpZyBuYW1lCj4gYXMgeW91IHN1Z2dlc3RlZCAoQ09ORklHX0tB
U0FOX0hXX1RBR1MsIENPTkZJR19LQVNBTl9IV19LRVlTLCBldGMpLgoKU3VyZSwgc291bmRzIGdv
b2QgdG8gbWUhCgpUaGFua3MsCgoJSW5nbwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
