From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
Subject: Re: [PATCH 3/7] Disable instrumentation for some code
Date: Sat, 24 Mar 2018 11:39:15 +0000
Message-ID: <B8AC3E80E903784988AB3003E3E97330C007748D@dggemm510-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "aryabinin@virtuozzo.com" <aryabinin@virtuozzo.com>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "afzal.mohd.ma@gmail.com" <afzal.mohd.ma@gmail.com>, "alexander.levin@verizon.com" <alexander.levin@verizon.com>
Cc: "glider@google.com" <glider@google.com>, "dvyukov@google.com" <dvyukov@google.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "vladimir.murzin@arm.com" <vladimir.murzin@arm.com>, "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "thgarnie@google.com" <thgarnie@google.com>, "dhowells@redhat.com" <dhowells@redhat.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "geert@linux-m68k.org" <geert@linux-m68k.org>, "tixy@linaro.org" <tixy@linaro.org>, mark.
List-Id: kvmarm@lists.cs.columbia.edu

T24gMTkvMDMvMjAxOCAxNjozOCwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPllvdSBuZWVkIHRvIGV4
dGVuZCB0aGlzIGF0IGxlYXN0IHRvIGFyY2gvYXJtL2t2bS9oeXAvTWFrZWZpbGUsIGFzIHRoZQ0K
PktBU0FOIHNoYWRvdyByZWdpb24gd29uJ3QgYmUgbWFwcGVkIGluIEhZUC4gU2VlIGNvbW1pdCBh
NmNkZjFjMDhjYmZlIGZvcg0KPm1vcmUgZGV0YWlscyAoYWxsIHRoZSBhcm02NCBjb21tZW50cyBp
biB0aGlzIHBhdGNoIGFwcGx5IHRvIDMyYml0IGFzIHdlbGwpLg0KVGhhbmtzIGZvciB5b3VyIHJl
dmlldy4NCkkgd2lsbCBkaXNhYmxlIHRoZSBpbnN0cnVtZW50YXRpb24gb2YgYXJjaC9hcm0va3Zt
L2h5cCBpbiB0aGUgbmV4dCB2ZXJzaW9uLiANCkp1c3QgbGlrZSB0aGlzOg0KbGl1d2VubGlhbmdA
bGludXg6L2hvbWUvc29mdF9kaXNrL3lvY3RvL2xpbnV4LWdpdC9saW51eD4gZ2l0IGRpZmYNCmRp
ZmYgLS1naXQgYS9hcmNoL2FybS9rdm0vaHlwL01ha2VmaWxlIGIvYXJjaC9hcm0va3ZtL2h5cC9N
YWtlZmlsZQ0KaW5kZXggNjNkNmI0MC4uMGE4YjUwMCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL2t2
bS9oeXAvTWFrZWZpbGUNCisrKyBiL2FyY2gvYXJtL2t2bS9oeXAvTWFrZWZpbGUNCkBAIC0yNCwz
ICsyNCw3IEBAIG9iai0kKENPTkZJR19LVk1fQVJNX0hPU1QpICs9IGh5cC1lbnRyeS5vDQogb2Jq
LSQoQ09ORklHX0tWTV9BUk1fSE9TVCkgKz0gc3dpdGNoLm8NCiBDRkxBR1Nfc3dpdGNoLm8gICAg
ICAgICAgICAgICAgICAgKz0gJChDRkxBR1NfQVJNVjdWRSkNCiBvYmotJChDT05GSUdfS1ZNX0FS
TV9IT1NUKSArPSBzMi1zZXR1cC5vDQorDQorR0NPVl9QUk9GSUxFCTo9IG4NCitLQVNBTl9TQU5J
VElaRQk6PSBuDQorVUJTQU5fU0FOSVRJWkUJOj0gbg0K
