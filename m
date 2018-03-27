From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [RFC PATCH v2 03/15] khwasan: add CONFIG_KASAN_CLASSIC and
 CONFIG_KASAN_TAGS
Date: Tue, 27 Mar 2018 18:23:27 +0200
Message-ID: <CAAeHK+za1Zg2+1_CFrQbdn_Hwa9o_nZkHuMLaekV18W380jAoQ@mail.gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <1fb0a050a84d49f5c3b2210337339412475d1688.1521828273.git.andreyknvl@google.com>
 <20180324084332.u6qik7lkdbenqbb2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1865B402B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 12:15:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lFAotr+I83Jv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Mar 2018 12:15:35 -0400 (EDT)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com
 [209.85.214.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20549402AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 12:15:21 -0400 (EDT)
Received: by mail-it0-f52.google.com with SMTP id v194-v6so16022620itb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 09:23:29 -0700 (PDT)
In-Reply-To: <20180324084332.u6qik7lkdbenqbb2@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ingo Molnar <mingo@kernel.org>
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>
List-Id: kvmarm@lists.cs.columbia.edu

T24gU2F0LCBNYXIgMjQsIDIwMTggYXQgOTo0MyBBTSwgSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5l
bC5vcmc+IHdyb3RlOgo+Cj4gKiBBbmRyZXkgS29ub3ZhbG92IDxhbmRyZXlrbnZsQGdvb2dsZS5j
b20+IHdyb3RlOgo+Cj4+IFRoaXMgY29tbWl0IHNwbGl0cyB0aGUgY3VycmVudCBDT05GSUdfS0FT
QU4gY29uZmlnIG9wdGlvbiBpbnRvIHR3bzoKPj4gMS4gQ09ORklHX0tBU0FOX0NMQVNTSUMsIHRo
YXQgZW5hYmxlcyB0aGUgY2xhc3NpYyBLQVNBTiB2ZXJzaW9uICh0aGUgb25lCj4+ICAgIHRoYXQg
ZXhpc3RzIG5vdyk7Cj4+IDIuIENPTkZJR19LQVNBTl9UQUdTLCB0aGF0IGVuYWJsZXMgS0hXQVNB
Ti4KPgo+IFNvcnJ5LCBidXQgdGhpcyBpcyBwcmV0dHkgb2JzY3VyZSBuYW1pbmcgc2NoZW1lIHRo
YXQgZG9lc24ndCBleHBsYWluIHRoZSBwcmltYXJ5Cj4gZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZXNl
IEtBU0FOIG1vZGVscyB0byB1c2VyczogdGhhdCB0aGUgZmlyc3Qgb25lIGlzIGEgcHVyZQo+IHNv
ZnR3YXJlIGltcGxlbWVudGF0aW9uIGFuZCB0aGUgb3RoZXIgaXMgaGFyZHdhcmUtYXNzaXN0ZWQu
Cj4KPiBSZW1pbmRzIG1lIG9mIHRoZSB0cmFuc3BhcmVuY3kgb2YgZ2FsYWN0aWMgYnVlcm9jcmFj
eSBpbiAiVGhlIEhpdGNoaGlrZXIncyBHdWlkZQo+IHRvIHRoZSBHYWxheHkiOgo+Cj4gICDigJxC
dXQgbG9vaywgeW91IGZvdW5kIHRoZSBub3RpY2UsIGRpZG7igJl0IHlvdT/igJ0KPiAgIOKAnFll
cyzigJ0gc2FpZCBBcnRodXIsIOKAnHllcyBJIGRpZC4gSXQgd2FzIG9uIGRpc3BsYXkgaW4gdGhl
IGJvdHRvbSBvZiBhIGxvY2tlZCBmaWxpbmcKPiAgICBjYWJpbmV0IHN0dWNrIGluIGEgZGlzdXNl
ZCBsYXZhdG9yeSB3aXRoIGEgc2lnbiBvbiB0aGUgZG9vciBzYXlpbmcg4oCYQmV3YXJlIG9mIHRo
ZQo+ICAgIExlb3BhcmQu4oCdCj4KPiBJJ2Qgc3VnZ2VzdCBzb21ldGhpbmcgbW9yZSBleHByZXNz
aXZlLCBzdWNoIGFzOgo+Cj4gICAgICAgICBDT05GSUdfS0FTQU4KPiAgICAgICAgICAgQ09ORklH
X0tBU0FOX0dFTkVSSUMKPiAgICAgICAgICAgQ09ORklHX0tBU0FOX0hXX0FTU0lTVAo+Cj4gb3Ig
c28/Cj4KPiBUaGUgJ2dlbmVyaWMnIHZhcmlhbnQgd2lsbCBiYXNpY2FsbHkgcnVuIG9uIGFueSBD
UFUuIFRoZSAnaGFyZHdhcmUgYXNzaXN0ZWQnIG9uZQo+IG5lZWRzIHN1cHBvcnQgZnJvbSB0aGUg
Q1BVLgo+Cj4gVGhlIGZvbGxvd2luZyBvbmVzIG1pZ2h0IGFsc28gd29yazoKPgo+ICAgIENPTkZJ
R19LQVNBTl9IV0FTU0lTVAo+ICAgIENPTkZJR19LQVNBTl9IV19UQUdTCj4gICAgQ09ORklHX0tB
U0FOX0hXVEFHUwo+Cj4gLi4uIG9yIHNpbXBseSBDT05GSUdfS0FTQU5fU1cvQ09ORklHX0tBU0FO
X0hXLgo+Cj4gSWYgb3RoZXIgdHlwZXMgb2YgS0FTQU4gaGFyZHdhcmUgYWNjZWxlcmF0aW9uIGFy
ZSBpbXBsZW1lbnRlZCBpbiB0aGUgZnV0dXJlIHRoZW4KPiB0aGUgQ09ORklHX0tBU0FOX0hXIG5h
bWVzcGFjZSBjYW4gYmUgZXh0ZW5kZWQ6Cj4KPiAgICAgICAgIENPTkZJR19LQVNBTl9IV19UQUdT
Cj4gICAgICAgICBDT05GSUdfS0FTQU5fSFdfS0VZUwo+ICAgICAgICAgZXRjLgoKSG93IGFib3V0
IHRoZXNlIHR3bzoKCkNPTkZJR19LQVNBTl9HRU5FUklDCkNPTkZJR19LQVNBTl9IVwoKPwoKU2hv
cnRlciBjb25maWcgbmFtZSBsb29rcyBiZXR0ZXIgdG8gbWUgYW5kIEkgdGhpbmsgaXQgbWFrZXMg
c2Vuc2UgdG8KbmFtZSB0aGUgbmV3IGNvbmZpZyBqdXN0IEhXLCBhcyB0aGVyZSdzIG9ubHkgb25l
IEhXIGltcGxlbWVudGF0aW9uCnJpZ2h0IG5vdy4gV2hlbiAoYW5kIGlmKSB0aGVyZSBhcmUgbW9y
ZSwgd2UgY2FuIGV4cGFuZCB0aGUgY29uZmlnIG5hbWUKYXMgeW91IHN1Z2dlc3RlZCAoQ09ORklH
X0tBU0FOX0hXX1RBR1MsIENPTkZJR19LQVNBTl9IV19LRVlTLCBldGMpLgoKPgo+PiBCb3RoIENP
TkZJR19LQVNBTl9DTEFTU0lDIGFuZCBDT05GSUdfS0FTQU5fQ0xBU1NJQyBzdXBwb3J0IGJvdGgK
Pj4gQ09ORklHX0tBU0FOX0lOTElORSBhbmQgQ09ORklHX0tBU0FOX09VVExJTkUgaW5zdHJ1bWVu
dGF0aW9uIG1vZGVzLgo+Cj4gSXQgd291bGQgYmUgdmVyeSBzdXJwcmlzaW5nIGlmIHRoYXQgd2Fz
bid0IHNvIQo+Cj4gT3IgZGlkIHlvdSBtZWFuICdCb3RoIENPTkZJR19LQVNBTl9DTEFTU0lDIGFu
ZCBDT05GSUdfS0FTQU5fVEFHUychIDstKQo+Cj4gVGhhbmtzLAo+Cj4gICAgICAgICBJbmdvCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
