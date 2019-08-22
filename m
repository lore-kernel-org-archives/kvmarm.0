Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B5AC3A59D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:23:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01B49233A2
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01B49233A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D1A4A5AA;
	Thu, 22 Aug 2019 06:23:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a06lp2H5CSWy; Thu, 22 Aug 2019 06:23:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 492F34A590;
	Thu, 22 Aug 2019 06:23:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FCEF4A58D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 06:23:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D+EP8SgvffsI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 06:23:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D69034A563
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 06:23:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71380337;
 Thu, 22 Aug 2019 03:23:08 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 41E723F246; Thu, 22 Aug 2019 03:23:06 -0700 (PDT)
Subject: Re: Can we boot a 512U kvm guest?
To: Auger Eric <eric.auger@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.cs.columbia.edu, qemu-arm@nongnu.org
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
 <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
 <fbeb47df-7ea2-04ce-5fe3-a6a6a4751b8b@kernel.org>
 <681f59e8-a193-6d3e-0bcc-5e52f4203868@redhat.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <dc78b8af-e761-dc87-982e-1885cfb98100@kernel.org>
Date: Thu, 22 Aug 2019 11:23:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <681f59e8-a193-6d3e-0bcc-5e52f4203868@redhat.com>
Content-Language: en-US
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org
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

T24gMjIvMDgvMjAxOSAxMDo1MCwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBNYXJjLAo+IAo+IE9u
IDgvMjIvMTkgMTE6MjkgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkgRXJpYywKPj4KPj4g
T24gMjIvMDgvMjAxOSAxMDowOCwgQXVnZXIgRXJpYyB3cm90ZToKPj4+IEhpIFplbmdodWksCj4+
Pgo+Pj4gT24gOC8xMy8xOSAxMDo1MCBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4+PiBIaSBmb2xr
cywKPj4+Pgo+Pj4+IFNpbmNlIGNvbW1pdCBlMjUwMjhjOGRlZDAgKCJLVk06IGFybS9hcm02NDog
QnVtcCBWR0lDX1YzX01BWF9DUFVTIHRvCj4+Pj4gNTEyIiksIHdlIHNlZW1lZCB0byBiZSBhbGxv
d2VkIHRvIGJvb3QgYSA1MTJVIGd1ZXN0LsKgIEJ1dCBJIGZhaWxlZCB0bwo+Pj4+IHN0YXJ0IGl0
IHVwIHdpdGggdGhlIGxhdGVzdCBRRU1VLsKgIEkgZ3Vlc3MgdGhlcmUgYXJlIGF0IGxlYXN0ICp0
d28qCj4+Pj4gcmVhc29ucyAobGltaXRhdGlvbnMpLgo+Pj4+Cj4+Pj4gRmlyc3QgSSBnb3QgYSBR
RU1VIGFib3J0Ogo+Pj4+IMKgwqDCoMKgImt2bV9zZXRfaXJxOiBJbnZhbGlkIGFyZ3VtZW50Igo+
Pj4+Cj4+Pj4gRW5hYmxlIHRoZSB0cmFjZV9rdm1faXJxX2xpbmUoKSB1bmRlciBkZWJ1Z2ZzLCB3
aGVuIGl0IGNvbWVkIHdpdGgKPj4+PiB2Y3B1LTI1NiwgSSBnb3Q6Cj4+Pj4gwqDCoMKgwqAiSW5q
ZWN0IFVOS05PV04gaW50ZXJydXB0ICgzKSwgdmNwdS0+aWR4OiAwLCBudW06IDIzLCBsZXZlbDog
MCIKPj4+PiBhbmQga3ZtX3ZtX2lvY3RsX2lycV9saW5lKCkgcmV0dXJucyAtRUlOVkFMIHRvIHVz
ZXItc3BhY2UuLi4KPj4+Pgo+Pj4+IFNvIHRoZSB0aGluZyBpcyB0aGF0IHdlIG9ubHkgaGF2ZSA4
IGJpdHMgZm9yIHZjcHVfaW5kZXggZmllbGQgKFsyMzoxNl0pCj4+Pj4gaW4gS1ZNX0lSUV9MSU5F
IGlvY3RsLsKgIGlycV90eXBlIGZpZWxkIHdpbGwgYmUgY29ycnVwdGVkIGlmIHdlIGluamVjdCBh
Cj4+Pj4gUFBJIHRvIHZjcHUtMjU2LCB3aG9zZSB2Y3B1X2luZGV4IHdpbGwgdGFrZSA5IGJpdHMu
Cj4+Pj4KPj4+PiBJIHRlbXBvcmFyaWx5IHBhdGNoZWQgdGhlIEtWTSBhbmQgUUVNVSB3aXRoIHRo
ZSBmb2xsb3dpbmcgZGlmZjoKPj4+Pgo+Pj4+IC0tLTg8LS0tCj4+Pj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaAo+Pj4+IGIvYXJjaC9hcm02NC9pbmNsdWRl
L3VhcGkvYXNtL2t2bS5oCj4+Pj4gaW5kZXggOTU1MTZhNC4uMzlhMGZiMSAxMDA2NDQKPj4+PiAt
LS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPj4+PiArKysgYi9hcmNoL2Fy
bTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPj4+PiBAQCAtMzI1LDEwICszMjUsMTAgQEAgc3Ry
dWN0IGt2bV92Y3B1X2V2ZW50cyB7Cj4+Pj4gwqAjZGVmaW5lwqDCoCBLVk1fQVJNX1ZDUFVfVElN
RVJfSVJRX1BUSU1FUsKgwqDCoMKgwqDCoMKgIDEKPj4+Pgo+Pj4+IMKgLyogS1ZNX0lSUV9MSU5F
IGlycSBmaWVsZCBpbmRleCB2YWx1ZXMgKi8KPj4+PiAtI2RlZmluZSBLVk1fQVJNX0lSUV9UWVBF
X1NISUZUwqDCoMKgwqDCoMKgwqAgMjQKPj4+PiAtI2RlZmluZSBLVk1fQVJNX0lSUV9UWVBFX01B
U0vCoMKgwqDCoMKgwqDCoCAweGZmCj4+Pj4gKyNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9TSElG
VMKgwqDCoMKgwqDCoMKgIDI4Cj4+Pj4gKyNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9NQVNLwqDC
oMKgwqDCoMKgwqAgMHhmCj4+Pj4gwqAjZGVmaW5lIEtWTV9BUk1fSVJRX1ZDUFVfU0hJRlTCoMKg
wqDCoMKgwqDCoCAxNgo+Pj4+IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1ZDUFVfTUFTS8KgwqDCoMKg
wqDCoMKgIDB4ZmYKPj4+PiArI2RlZmluZSBLVk1fQVJNX0lSUV9WQ1BVX01BU0vCoMKgwqDCoMKg
wqDCoCAweGZmZgo+Pj4+IMKgI2RlZmluZSBLVk1fQVJNX0lSUV9OVU1fU0hJRlTCoMKgwqDCoMKg
wqDCoCAwCj4+Pj4gwqAjZGVmaW5lIEtWTV9BUk1fSVJRX05VTV9NQVNLwqDCoMKgwqDCoMKgwqAg
MHhmZmZmCj4+Pj4KPj4+PiAtLS04PC0tLQo+Pj4+Cj4+Pj4gSXQgbWFrZXMgdGhpbmdzIGEgYml0
IGJldHRlciwgaXQgYWxzbyBpbW1lZGlhdGVseSBCUkVBS3MgdGhlIGFwaSB3aXRoCj4+Pj4gb2xk
IHZlcnNpb25zLgo+Pj4+Cj4+Pj4KPj4+PiBOZXh0IGNvbWVzIG9uZSBtb3JlIFFFTVUgYWJvcnQg
KHdpdGggdGhlICJmaXgiIGFib3ZlKToKPj4+PiDCoMKgwqDCoCJGYWlsZWQgdG8gc2V0IGRldmlj
ZSBhZGRyZXNzOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZSIKPj4+Pgo+Pj4+IFdlIHJlZ2lzdGVy
IHR3byBpbyBkZXZpY2VzIChyZF9kZXYgYW5kIHNnaV9kZXYpIG9uIEtWTV9NTUlPX0JVUyBmb3IK
Pj4+PiBlYWNoIHJlZGlzdHJpYnV0b3IuIDUxMiB2Y3B1cyB0YWtlIDEwMjQgaW8gZGV2aWNlcywg
d2hpY2ggaXMgYmV5b25kIHRoZQo+Pj4+IG1heGltdW0gbGltaXRhdGlvbiBvZiB0aGUgY3VycmVu
dCBrZXJuZWwgLSBOUl9JT0JVU19ERVZTICgxMDAwKS4KPj4+PiBTbyB3ZSBnZXQgYSBFTk9TUEMg
ZXJyb3IgaGVyZS4KPj4+Cj4+PiBEbyB5b3UgcGxhbiB0byBzZW5kIGEgcGF0Y2ggZm9yIGluY3Jl
YXNpbmcgdGhlIE5SX0lPQlVTX0RFVlM/IE90aGVyd2lzZQo+Pj4gSSBjYW4gZG8gaXQuCj4+Cj4+
IEkgcmVhbGx5IHdvbmRlciB3aGV0aGVyIHRoYXQncyBhIHNlbnNpYmxlIHRoaW5nIHRvIGRvIG9u
IGl0cyBvd24uCj4+Cj4+IExvb2tpbmcgYXQgdGhlIGltcGxlbWVudGF0aW9uIG9mIGt2bV9pb19i
dXNfcmVnaXN0ZXJfZGV2ICh3aGljaCBjb3BpZXMKPj4gdGhlIHdob2xlIGFycmF5IGVhY2ggdGlt
ZSB3ZSBpbnNlcnQgYSBkZXZpY2UpLCB3ZSBoYXZlIGFuIG9idmlvdXMgaXNzdWUKPj4gd2l0aCBz
eXN0ZW1zIHRoYXQgY3JlYXRlIGEgbGFyZ2UgbnVtYmVyIG9mIGRldmljZSBzdHJ1Y3R1cmVzLCBs
ZWFkaW5nIHRvCj4+IGxhcmdlIHRyYW5zaWVudCBtZW1vcnkgdXNhZ2UgYW5kIHNsb3cgZ3Vlc3Qg
c3RhcnQuCj4+Cj4+IFdlIGNvdWxkIGFsc28gdHJ5IGFuZCByZWR1Y2UgdGhlIG51bWJlciBvZiBk
ZXZpY2VzIHdlIGluc2VydCBieSBtYWtpbmcKPj4gdGhlIHJlZGlzdHJpYnV0b3IgYSBzaW5nbGUg
ZGV2aWNlICh3aGljaCBpdCBpcyBpbiByZWFsaXR5KS4gSXQgcHJvYmFibHkKPj4gbWVhbnMgd2Ug
bmVlZCB0byBtYWtlIHRoZSBNTUlPIGRlY29kaW5nIG1vcmUgZmxleGlibGUuCj4gCj4gWWVzIGl0
IG1ha2VzIHNlbnNlLiBJZiBubyBvYmplY3Rpb24sIEkgY2FuIHdvcmsgb24gdGhpcyBhcyBJIGFt
IHRoZQo+IHNvdXJjZSBvZiB0aGUgbWVzcyA7LSkKClN1cmUsIGlmIHlvdSBoYXZlIHNvbWUgc3Bh
cmUgYmFuZHdpZHRoLCBmZWVsIGZyZWUgdG8gZ2l2ZSBpdCBhIGdvLiBJJ2QKY2VydGFpbmx5IGxp
a2UgdG8gc2VlIHRoZSB1c2Vyc3BhY2UgY291bnRlcnBhcnQgdG8gbXkgZWFybGllciBwYXRjaCwg
YW5kCnNvbWUgYWdyZWVtZW50IG9uIHRoZSBBQkkgY2hhbmdlLgoKVGhhbmtzLAoKCU0uCi0tIApK
YXp6IGlzIG5vdCBkZWFkLCBpdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
