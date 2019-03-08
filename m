From: "Zhang, Lei" <zhang.lei@jp.fujitsu.com>
Subject: RE: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Fri, 8 Mar 2019 07:06:54 +0000
Message-ID: <8898674D84E3B24BA3A2D289B872026A6A33E3BC@G01JPEXMBKW03>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <8898674D84E3B24BA3A2D289B872026A6A33657E@G01JPEXMBKW03>
 <20190305094747.GJ3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59AE04A49E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Mar 2019 02:07:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zpo5l399fnN6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Mar 2019 02:07:03 -0500 (EST)
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A74954A495
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Mar 2019 02:07:02 -0500 (EST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5E96CAC00F2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Mar 2019 16:06:57 +0900 (JST)
In-Reply-To: <20190305094747.GJ3567@e103592.cambridge.arm.com>
Content-Language: ja-JP
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Dave Martin' <Dave.Martin@arm.com>
Cc: "Okamoto, Takayuki" <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Julien Grall <julien.grall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

SGkgRGF2ZSwNCg0KcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2ZSBNYXJ0aW4gPERh
dmUuTWFydGluQGFybS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDA1LCAyMDE5IDY6NDgg
UE0NCj4gVG86IFpoYW5nLCBMZWkv5by1IOmbtyA8emhhbmcubGVpQGpwLmZ1aml0c3UuY29tPg0K
PiBDYzoga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdTsgUGV0ZXIgTWF5ZGVsbA0KPiA8cGV0
ZXIubWF5ZGVsbEBsaW5hcm8ub3JnPjsgT2thbW90bywgVGFrYXl1a2kv5bKh5pysIOmrmOW5uA0K
PiA8dG9rYW1vdG9AanAuZnVqaXRzdS5jb20+OyBDaHJpc3RvZmZlciBEYWxsIDxjZGFsbEBrZXJu
ZWwub3JnPjsgQXJkDQo+IEJpZXNoZXV2ZWwgPGFyZC5iaWVzaGV1dmVsQGxpbmFyby5vcmc+OyBN
YXJjIFp5bmdpZXINCj4gPG1hcmMuenluZ2llckBhcm0uY29tPjsgQ2F0YWxpbiBNYXJpbmFzIDxj
YXRhbGluLm1hcmluYXNAYXJtLmNvbT47IFdpbGwNCj4gRGVhY29uIDx3aWxsLmRlYWNvbkBhcm0u
Y29tPjsgSnVsaWVuIEdyYWxsIDxqdWxpZW4uZ3JhbGxAYXJtLmNvbT47IEFsZXgNCj4gQmVubsOp
ZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz47IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFk
ZWFkLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY1IDAwLzI2XSBLVk06IGFybTY0OiBTVkUg
Z3Vlc3Qgc3VwcG9ydA0KPiANCj4gT24gU3VuLCBNYXIgMDMsIDIwMTkgYXQgMDI6NDA6NTdBTSAr
MDAwMCwgWmhhbmcsIExlaSB3cm90ZToNCj4gPiBIaSBEYXZlLA0KPiA+DQo+ID4gPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogbGludXgtYXJtLWtlcm5lbA0KPiA+ID4g
PGxpbnV4LWFybS1rZXJuZWwtYm91bmNlc0BsaXN0cy5pbmZyYWRlYWQub3JnPiBPbiBCZWhhbGYg
T2YgRGF2ZQ0KPiA+ID4gTWFydGluDQo+ID4gPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxOSwg
MjAxOSA0OjUyIEFNDQo+ID4gPiBUbzoga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQ0KPiA+
ID4gQ2M6IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz47IE9rYW1vdG8s
IFRha2F5dWtpL+WyoeacrA0KPiA+ID4g6auY5bm4DQo+ID4gPiA8dG9rYW1vdG9AanAuZnVqaXRz
dS5jb20+OyBDaHJpc3RvZmZlciBEYWxsIDxjZGFsbEBrZXJuZWwub3JnPjsgQXJkDQo+ID4gPiBC
aWVzaGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPjsgTWFyYyBaeW5naWVyDQo+ID4g
PiA8bWFyYy56eW5naWVyQGFybS5jb20+OyBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4ubWFyaW5h
c0Bhcm0uY29tPjsNCj4gPiA+IFdpbGwgRGVhY29uIDx3aWxsLmRlYWNvbkBhcm0uY29tPjsgWmhh
bmcsIExlaS/lvLUg6Zu3DQo+ID4gPiA8emhhbmcubGVpQGpwLmZ1aml0c3UuY29tPjsgSnVsaWVu
IEdyYWxsIDxqdWxpZW4uZ3JhbGxAYXJtLmNvbT47DQo+ID4gPiBBbGV4IEJlbm7DqWUgPGFsZXgu
YmVubmVlQGxpbmFyby5vcmc+Ow0KPiA+ID4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRl
YWQub3JnDQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0ggdjUgMDAvMjZdIEtWTTogYXJtNjQ6IFNWRSBn
dWVzdCBzdXBwb3J0DQo+ID4gPg0KPiA+ID4gVGhpcyBzZXJpZXMgaW1wbGVtZW50cyBzdXBwb3J0
IGZvciBhbGxvd2luZyBLVk0gZ3Vlc3RzIHRvIHVzZSB0aGUNCj4gPiA+IEFybSBTY2FsYWJsZSBW
ZWN0b3IgRXh0ZW5zaW9uIChTVkUpLCBzdXBlcnNlZGluZyB0aGUgcHJldmlvdXMgdjQgc2VyaWVz
DQo+IFsxXS4NCj4gPiA+DQo+ID4gPiBUaGUgcGF0Y2hlcyBhcmUgYWxzbyBhdmFpbGFibGUgb24g
YSBicmFuY2ggZm9yIHJldmlld2VyIGNvbnZlbmllbmNlLg0KPiA+ID4gWzJdDQo+ID4gPg0KPiA+
ID4gVGhlIHBhdGNoZXMgYXJlIGJhc2VkIG9uIHY1LjAtcmM2Lg0KPiA+ID4NCj4gPiA+IFRoZXkg
ZGVwZW5kIG9uIGFub3RoZXIgc21hbGwgc2VyaWVzIGN1cnJlbnRseSB1bmRlciByZXZpZXcgWzNd
IHRoYXQNCj4gPiA+IGRvZXMgYSBiaXQgb2YgcmVsZXZhbnQgcmVmYWN0b3JpbmcgKGFzIHdlbGwg
YXMgZml4aW5nIGFuIGFub21hbHkgbm90DQo+ID4gPiBkaXJlY3RseSByZWxhdGVkIHRvIHRoaXMg
c2VyaWVzKS4gIEEgYmFzZSBicmFuY2ggWzRdIGlzIHByb3ZpZGVkIHNvDQo+ID4gPiB0aGF0IHJl
dmlld2VycyBkb24ndCBuZWVkIHRvIGh1bnQgZG93biBib3RoIHNlcmllcyBpbmRlcGVuZGVudGx5
Lg0KPiA+IFs+XQ0KPiA+IEkgdGVzdGVkIHRoZSBwYXRjaCBvbiBBNjRGWCBjaGlwIHdoaWNoIFNW
RSBmZWF0dXJlIGhhZCBiZWVuIGltcGxlbWVudGVkLg0KPiA+IEFsbCBvZiB0ZXN0cyBoYXZlIGJl
ZW4gcGFzc2VkLg0KPiA+IFBsZWFzZSBhZGQgZm9sbG93cyA6DQo+ID4gVGVzdGVkLWJ5OiB6aGFu
Zy5sZWkgPHpoYW5nLmxlaUBqcC5mdWppdHN1LmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgdGhpcyEN
Cj4gDQo+IFRoZXJlIHdpbGwgYmUgYXQgbGVhc3Qgb25lIG1vcmUgaXRlcmF0aW9uIG9mIHRoaXMg
c2VyaWVzIGJlZm9yZSBpdCBpcyBmaW5hbCwgc28gaXQNCj4gd291bGQgYmUgZ29vZCBpZiB5b3Ug
Y2FuIHRlc3QgYWdhaW4gd2hlbiBJIHJlcG9zdC4NCls+XSANCk9mIGNvdXJzZSBJIHdpbGwgZG8g
dGhlIHRlc3Qgb24gQTY0RlgsIHdoZW4geW91IHJlcG9zdCBwYXRjaC4NCg0KQmVzdCBSZWFnYXJk
cywNClpoYW5nIExlaQ0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
