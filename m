From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v3 3/3] kvm: arm64: handle single-step of userspace mmio
 instructions
Date: Thu, 16 Nov 2017 17:44:02 +0000
Message-ID: <91f89786-5fb9-ce5d-a7c2-2addb1ab4983@arm.com>
References: <20171116153921.21991-1-alex.bennee@linaro.org>
 <20171116153921.21991-4-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5677740EA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:41:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c1CN5yS11yea for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 12:41:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6D4406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:41:46 -0500 (EST)
In-Reply-To: <20171116153921.21991-4-alex.bennee@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAxNi8xMS8xNyAxNTozOSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IFRoZSBzeXN0ZW0gc3Rh
dGUgb2YgS1ZNIHdoZW4gdXNpbmcgdXNlcnNwYWNlIGVtdWxhdGlvbiBpcyBub3QgY29tcGxldGUK
PiB1bnRpbCB3ZSByZXR1cm4gaW50byBLVk1fUlVOLiBUbyBoYW5kbGUgbW1pbyByZWxhdGVkIHVw
ZGF0ZXMgd2Ugd2FpdAo+IHVudGlsIHRoZXkgaGF2ZSBiZWVuIGNvbW1pdHRlZCBhbmQgdGhlbiBz
Y2hlZHVsZSBvdXIgS1ZNX0VYSVRfREVCVUcuCj4gCj4gVGhlIGt2bV9hcm1faGFuZGxlX3N0ZXBf
ZGVidWcoKSBoZWxwZXIgdGVsbHMgdXMgaWYgd2UgbmVlZCB0byByZXR1cm4KPiBhbmQgc2V0cyB1
cCB0aGUgZXhpdF9yZWFzb24gZm9yIHVzLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOp
ZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPiAKClJldmlld2VkLWJ5OiBKdWxpZW4gVGhpZXJy
eSA8anVsaWVuLnRoaWVycnlAYXJtLmNvbT4KCj4gLS0tCj4gdjIKPiAgICAtIGNhbGwgaGVscGVy
IGRpcmVjdGx5IGZyb20ga3ZtX2FyY2hfdmNwdV9pb2N0bF9ydW4KPiB2Mwo+ICAgIC0gcmV0dXJu
IDAgKGlvY3RsIHN1Y2Nlc3MpIGluc3RlYWQgb2YgMQo+IC0tLQo+ICAgdmlydC9rdm0vYXJtL2Fy
bS5jIHwgMyArKysKPiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKPiAKPiBkaWZm
IC0tZ2l0IGEvdmlydC9rdm0vYXJtL2FybS5jIGIvdmlydC9rdm0vYXJtL2FybS5jCj4gaW5kZXgg
OTVjYmEwNzk5ODI4Li5iNDA0NDBkZWZjYTEgMTAwNjQ0Cj4gLS0tIGEvdmlydC9rdm0vYXJtL2Fy
bS5jCj4gKysrIGIvdmlydC9rdm0vYXJtL2FybS5jCj4gQEAgLTYyNSw2ICs2MjUsOSBAQCBpbnQg
a3ZtX2FyY2hfdmNwdV9pb2N0bF9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3Zt
X3J1biAqcnVuKQo+ICAgCQlyZXQgPSBrdm1faGFuZGxlX21taW9fcmV0dXJuKHZjcHUsIHZjcHUt
PnJ1bik7Cj4gICAJCWlmIChyZXQpCj4gICAJCQlyZXR1cm4gcmV0Owo+ICsJCWlmIChrdm1fYXJt
X2hhbmRsZV9zdGVwX2RlYnVnKHZjcHUsIHZjcHUtPnJ1bikpCj4gKwkJCXJldHVybiAwOwo+ICsK
PiAgIAl9Cj4gICAKPiAgIAlpZiAocnVuLT5pbW1lZGlhdGVfZXhpdCkKPiAKCi0tIApKdWxpZW4g
VGhpZXJyeQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
