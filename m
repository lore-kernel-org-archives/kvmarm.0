Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7EBC48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 15:38:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFB4361040
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 15:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFB4361040
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1DB49FE6;
	Tue, 22 Jun 2021 11:38:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H77xTMU8RDQP; Tue, 22 Jun 2021 11:38:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A149240874;
	Tue, 22 Jun 2021 11:38:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7E3C407D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 11:38:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O5OMChHX8-1u for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 11:38:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE21406DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 11:38:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2EDA31B;
 Tue, 22 Jun 2021 08:38:21 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A5BC3F718;
 Tue, 22 Jun 2021 08:38:20 -0700 (PDT)
Subject: Re: [PATCH v4 0/9] KVM: arm64: Initial host support for the Apple M1
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210601104005.81332-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9bc0923c-5c3b-eeac-86ee-c3234c486955@arm.com>
Date: Tue, 22 Jun 2021 16:39:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-1-maz@kernel.org>
Content-Language: en-US
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywKCk9uIDYvMS8yMSAxMTozOSBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IFRoaXMg
aXMgYSBuZXcgdmVyc2lvbiBvZiB0aGUgc2VyaWVzIHByZXZpb3VzbHkgcG9zdGVkIGF0IFszXSwg
cmV3b3JraW5nCj4gdGhlIHZHSUMgYW5kIHRpbWVyIGNvZGUgdG8gY29wZSB3aXRoIHRoZSBNMSBi
cmFpbmRlYWReV2FtdXNpbmcgbmF0dXJlLgo+Cj4gSGFyZGx5IGFueSBjaGFuZ2UgdGhpcyB0aW1l
IGFyb3VuZCwgbW9zdGx5IHJlYmFzZWQgb24gdG9wIG9mIHVwc3RyZWFtCj4gbm93IHRoYXQgdGhl
IGRlcGVuZGVuY2llcyBoYXZlIG1hZGUgaXQgaW4uCj4KPiBUZXN0ZWQgd2l0aCBtdWx0aXBsZSBj
b25jdXJyZW50IFZNcyBydW5uaW5nIGZyb20gYW4gaW5pdHJhbWZzLgo+Cj4gVW50aWwgc29tZW9u
ZSBzaG91dHMgbG91ZGx5IG5vdywgSSdsbCB0YWtlIHRoaXMgaW50byA1LjE0IChhbmQgaW4KPiAt
bmV4dCBmcm9tIHRvbW9ycm93KS4KCkkgYW0gbm90IGZhbWlsaWFyIHdpdGggaXJxZG9tYWlucyBv
ciB3aXRoIHRoZSBpcnFjaGlwIGluZnJhc3RydWN0dXJlLCBzbyBJIGNhbid0CnJlYWxseSBjb21t
ZW50IG9uIHBhdGNoICM4LgoKSSB0cmllZCB0ZXN0aW5nIHRoaXMgd2l0aCBhIEdJQ3YzIGJ5IG1v
ZGlmeWluZyB0aGUgZHJpdmVyIHRvIHNldApub19od19kZWFjdGl2YXRpb24gYW5kIG5vX21haW50
X2lycV9tYXNrOgoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMg
Yi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jCmluZGV4IDM0MGM1MWQ4NzY3Ny4uZDBj
NmY4MDhkN2Y0IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jCisr
KyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMKQEAgLTU2NSw4ICs1NjUsMTAgQEAg
aW50IGt2bV92Z2ljX2h5cF9pbml0KHZvaWQpCsKgwqDCoMKgwqDCoMKgIGlmIChyZXQpCsKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0OwrCoAorwqDCoMKgwqDCoMKgIC8q
CsKgwqDCoMKgwqDCoMKgIGlmICghaGFzX21hc2spCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gMDsKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KwqAKwqDCoMKg
wqDCoMKgwqAgcmV0ID0gcmVxdWVzdF9wZXJjcHVfaXJxKGt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5t
YWludF9pcnEsCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgdmdpY19tYWludGVuYW5jZV9oYW5kbGVyLApkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMuYyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYz
LmMKaW5kZXggNDUzZmM0MjVlZWRlLi45Y2U0ZGVlMjA2NTUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
aXJxY2hpcC9pcnEtZ2ljLXYzLmMKKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMuYwpA
QCAtMTg1MCw2ICsxODUwLDEyIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBnaWNfb2Zfc2V0dXBfa3Zt
X2luZm8oc3RydWN0IGRldmljZV9ub2RlCipub2RlKQrCoMKgwqDCoMKgwqDCoCBpZiAoIXJldCkK
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdpY192M19rdm1faW5mby52Y3B1ID0gcjsK
wqAKK8KgwqDCoMKgwqDCoCBnaWNfdjNfa3ZtX2luZm8ubm9faHdfZGVhY3RpdmF0aW9uID0gdHJ1
ZTsKK8KgwqDCoMKgwqDCoCBnaWNfdjNfa3ZtX2luZm8ubm9fbWFpbnRfaXJxX21hc2sgPSB0cnVl
OworCivCoMKgwqDCoMKgwqAgdmdpY19zZXRfa3ZtX2luZm8oJmdpY192M19rdm1faW5mbyk7CivC
oMKgwqDCoMKgwqAgcmV0dXJuOworCsKgwqDCoMKgwqDCoMKgIGdpY192M19rdm1faW5mby5oYXNf
djQgPSBnaWNfZGF0YS5yZGlzdHMuaGFzX3ZscGlzOwrCoMKgwqDCoMKgwqDCoCBnaWNfdjNfa3Zt
X2luZm8uaGFzX3Y0XzEgPSBnaWNfZGF0YS5yZGlzdHMuaGFzX3J2cGVpZDsKwqDCoMKgwqDCoMKg
wqAgdmdpY19zZXRfa3ZtX2luZm8oJmdpY192M19rdm1faW5mbyk7CgpLZXB0IHRoZSBtYWludGVu
YW5jZSBpcnEgSUQgc28gdGhlIElSUSBnZXRzIGVuYWJsZWQgYXQgdGhlIFJlZGlzdHJpYnV0b3Ig
bGV2ZWwuIEkKZG9uJ3Qga25vdyBpZiBJIG1hbmFnZWQgdG8gYnJlYWsgc29tZXRoaW5nIHdpdGgg
dGhvc2UgY2hhbmdlcywgYnV0IHdoZW4gdGVzdGluZyBvbgp0aGUgbW9kZWwgYW5kIG9uIGEgcm9j
a3BybzY0ICh3aXRoIHRoZSBwYXRjaGVzIGNoZXJyeS1waWNrZWQgb24gdG9wIG9mIHY1LjEzLXJj
NykKSSBrZXB0IHNlZWluZyByY3Ugc3RhbGxzLiBJIGFzc3VtZSBJIGRpZCBzb21ldGhpbmcgd3Jv
bmcuCgpUaGFua3MsCgpBbGV4Cgo+Cj4gKiBGcm9tIHYzIFszXToKPiAgIC0gUmViYXNlZCBvbiA1
LjEzLXJjNCB0byBtYXRjaCB0aGUga3ZtYXJtL25leHQgYmFzZQo+ICAgLSBNb3ZlZCBzdHVmZiBm
cm9tIHBhdGNoICM3IHRvIGl0cyBsb2dpY2FsIHNwb3QgaW4gcGF0Y2ggIzgKPiAgIC0gQ2hhbmdl
ZCB0aGUgaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS12Z2ljLWluZm8uaCBndWFyZAo+ICAgLSBD
b2xsZWN0ZWQgUkJzIGZyb20gQWxleCwgd2l0aCB0aGFua3MKPgo+ICogRnJvbSB2MiBbMl06Cj4g
ICAtIFJlYmFzZWQgb24gNS4xMy1yYzEKPiAgIC0gRml4ZWQgYSBjb3VwbGUgb2Ygbml0cyBpbiB0
aGUgR0lDIHJlZ2lzdHJhdGlvbiBjb2RlCj4KPiAqIEZyb20gdjEgWzFdOgo+ICAgLSBSZWJhc2Vk
IG9uIEhlY3RvcidzIHY0IHBvc3RpbmdbMF0KPiAgIC0gRHJvcHBlZCBhIGNvdXBsZSBvZiBwYXRj
aGVzIHRoYXQgaGF2ZSBiZWVuIG1lcmdlZCBpbiB0aGUgYWJvdmUgc2VyaWVzCj4gICAtIEZpeGVk
IGlycV9hY2sgY2FsbGJhY2sgb24gdGhlIHRpbWVyIHBhdGgKPgo+IFswXSBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9yLzIwMjEwNDAyMDkwNTQyLjEzMTE5NC0xLW1hcmNhbkBtYXJjYW4uc3QKPiBb
MV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIxMDMxNjE3NDYxNy4xNzMwMzMtMS1tYXpA
a2VybmVsLm9yZwo+IFsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjEwNDAzMTEyOTMx
LjEwNDM0NTItMS1tYXpAa2VybmVsLm9yZwo+IFszXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9y
LzIwMjEwNTEwMTM0ODI0LjE5MTAzOTktMS1tYXpAa2VybmVsLm9yZwo+Cj4gTWFyYyBaeW5naWVy
ICg5KToKPiAgIGlycWNoaXAvZ2ljOiBTcGxpdCB2R0lDIHByb2JpbmcgaW5mb3JtYXRpb24gZnJv
bSB0aGUgR0lDIGNvZGUKPiAgIEtWTTogYXJtNjQ6IEhhbmRsZSBwaHlzaWNhbCBGSVEgYXMgYW4g
SVJRIHdoaWxlIHJ1bm5pbmcgYSBndWVzdAo+ICAgS1ZNOiBhcm02NDogdmdpYzogQmUgdG9sZXJh
bnQgdG8gdGhlIGxhY2sgb2YgbWFpbnRlbmFuY2UgaW50ZXJydXB0Cj4gICAgIG1hc2tpbmcKPiAg
IEtWTTogYXJtNjQ6IHZnaWM6IExldCBhbiBpbnRlcnJ1cHQgY29udHJvbGxlciBhZHZlcnRpc2Ug
bGFjayBvZiBIVwo+ICAgICBkZWFjdGl2YXRpb24KPiAgIEtWTTogYXJtNjQ6IHZnaWM6IG1vdmUg
aXJxLT5nZXRfaW5wdXRfbGV2ZWwgaW50byBhbiBvcHMgc3RydWN0dXJlCj4gICBLVk06IGFybTY0
OiB2Z2ljOiBJbXBsZW1lbnQgU1ctZHJpdmVuIGRlYWN0aXZhdGlvbgo+ICAgS1ZNOiBhcm02NDog
dGltZXI6IFJlZmFjdG9yIElSUSBjb25maWd1cmF0aW9uCj4gICBLVk06IGFybTY0OiB0aW1lcjog
QWRkIHN1cHBvcnQgZm9yIFNXLWJhc2VkIGRlYWN0aXZhdGlvbgo+ICAgaXJxY2hpcC9hcHBsZS1h
aWM6IEFkdmVydGlzZSBzb21lIGxldmVsIG9mIHZHSUN2MyBjb21wYXRpYmlsaXR5Cj4KPiAgYXJj
aC9hcm02NC9rdm0vYXJjaF90aW1lci5jICAgICAgICAgICAgfCAxNjIgKysrKysrKysrKysrKysr
KysrKysrLS0tLQo+ICBhcmNoL2FybTY0L2t2bS9oeXAvaHlwLWVudHJ5LlMgICAgICAgICB8ICAg
NiArLQo+ICBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jICAgICAgICB8ICAzNiArKysr
Ky0KPiAgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYyLmMgICAgICAgICAgfCAgMTkgKystCj4g
IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jICAgICAgICAgIHwgIDE5ICsrLQo+ICBhcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMuYyAgICAgICAgICAgICB8ICAxNCArLS0KPiAgZHJpdmVycy9p
cnFjaGlwL2lycS1hcHBsZS1haWMuYyAgICAgICAgfCAgIDkgKysKPiAgZHJpdmVycy9pcnFjaGlw
L2lycS1naWMtY29tbW9uLmMgICAgICAgfCAgMTMgLS0KPiAgZHJpdmVycy9pcnFjaGlwL2lycS1n
aWMtY29tbW9uLmggICAgICAgfCAgIDIgLQo+ICBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My5j
ICAgICAgICAgICB8ICAgNiArLQo+ICBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy5jICAgICAgICAg
ICAgICB8ICAgNiArLQo+ICBpbmNsdWRlL2t2bS9hcm1fdmdpYy5oICAgICAgICAgICAgICAgICB8
ICA0MSArKysrKy0tCj4gIGluY2x1ZGUvbGludXgvaXJxY2hpcC9hcm0tZ2ljLWNvbW1vbi5oIHwg
IDI1ICstLS0KPiAgaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS12Z2ljLWluZm8uaCAgfCAgNDUg
KysrKysrKwo+ICAxNCBmaWxlcyBjaGFuZ2VkLCAyOTkgaW5zZXJ0aW9ucygrKSwgMTA0IGRlbGV0
aW9ucygtKQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS12
Z2ljLWluZm8uaAo+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
