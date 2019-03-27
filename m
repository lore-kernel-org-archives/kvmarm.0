From: "Zhang, Lei" <zhang.lei@jp.fujitsu.com>
Subject: RE: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Wed, 27 Mar 2019 05:51:45 +0000
Message-ID: <8898674D84E3B24BA3A2D289B872026A6A3671AC@G01JPEXMBKW03>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <20190319175834.GO3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3783033323955541053=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDF174A418
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 01:51:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NX55rMlKBDr5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Mar 2019 01:51:53 -0400 (EDT)
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1DF24A2E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 01:51:52 -0400 (EDT)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local
 (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 6CD5EAC00A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 14:51:47 +0900 (JST)
In-Reply-To: <20190319175834.GO3567@e103592.cambridge.arm.com>
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
To: 'Dave Martin' <Dave.Martin@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "Matsuyama, Yoshihiro" <y.matsu@jp.fujitsu.com>, "Okamoto,
 Takayuki" <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "Zhang, Lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

--===============3783033323955541053==
Content-Language: ja-JP
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGkgZ3V5cywNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
IEZyb206IGxpbnV4LWFybS1rZXJuZWwgPGxpbnV4LWFybS1rZXJuZWwtYm91
bmNlc0BsaXN0cy5pbmZyYWRlYWQub3JnPiBPbg0KPiBCZWhhbGYgT2YgRGF2
ZSBNYXJ0aW4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAyMCwgMjAxOSAy
OjU5IEFNDQo+IFRvOiBrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1DQo+
IENjOiBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+
OyBPa2Ftb3RvLCBUYWtheXVraS+M+bG+ILjf0NINCj4gPHRva2Ftb3RvQGpw
LmZ1aml0c3UuY29tPjsgQ2hyaXN0b2ZmZXIgRGFsbCA8Y2RhbGxAa2VybmVs
Lm9yZz47IEFyZA0KPiBCaWVzaGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5h
cm8ub3JnPjsgTWFyYyBaeW5naWVyDQo+IDxtYXJjLnp5bmdpZXJAYXJtLmNv
bT47IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+
OyBXaWxsDQo+IERlYWNvbiA8d2lsbC5kZWFjb25AYXJtLmNvbT47IFpoYW5n
LCBMZWkvj4ggwNcNCj4gPHpoYW5nLmxlaUBqcC5mdWppdHN1LmNvbT47IEp1
bGllbiBHcmFsbCA8anVsaWVuLmdyYWxsQGFybS5jb20+OyBBbGV4DQo+IEJl
bm6opmUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+OyBsaW51eC1hcm0ta2Vy
bmVsQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRD
SCB2NSAwMC8yNl0gS1ZNOiBhcm02NDogU1ZFIGd1ZXN0IHN1cHBvcnQNCj4g
DQo+IE9uIFR1ZSwgTWFyIDE5LCAyMDE5IGF0IDA1OjUxOjUxUE0gKzAwMDAs
IERhdmUgTWFydGluIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gDQo+IFllcywg
SSBtZXNzZWQgdXAgdGhlIHN1YmplY3QgbGluZSBpbiB0aGUgY292ZXIgbGV0
dGVyIDpQDQo+IA0KPiBUaGUgcHJlZml4IHNob3VsZCByZWFkICJbUEFUQ0gg
djYgMDAvMjddIg0KDQpbPl0gDQpJIGhhdmUgdGVzdGVkIHBhdGNoIHY2IG9u
IEZ1aml0c3UgQTY0RlggY2hpcCB3aGljaCBTVkUgZmVhdHVyZSBoYWQgYmVl
biBpbXBsZW1lbnRlZC4NCkFsbCBvZiB0ZXN0cyBoYXZlIGJlZW4gcGFzc2Vk
Lg0KUGxlYXNlIGFkZCBmb2xsb3dzOg0KVGVzdGVkLWJ5OiB6aGFuZy5sZWkg
PHpoYW5nLmxlaUBqcC5mdWppdHN1LmNvbT4NCg0KDQpCZXN0IFJlZ2FyZHMs
DQpaaGFuZyBMZWkNCg==

--===============3783033323955541053==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3783033323955541053==--
