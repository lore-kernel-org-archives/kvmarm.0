Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271DDC433C1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 10:47:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67EEA6198F
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 10:47:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67EEA6198F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D70A44B43E;
	Wed, 31 Mar 2021 06:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dKQlGMWM8kau; Wed, 31 Mar 2021 06:47:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A3EE4B438;
	Wed, 31 Mar 2021 06:47:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B17F4B42F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 06:47:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BdtYNBHzOAii for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 06:47:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C604B4B433
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 06:47:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CDB411FB;
 Wed, 31 Mar 2021 03:47:44 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C22223F719;
 Wed, 31 Mar 2021 03:47:43 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Initialize VCPU mdcr_el2 before loading it
To: Marc Zyngier <maz@kernel.org>
References: <20210323180057.263356-1-alexandru.elisei@arm.com>
 <87sg4dq83r.wl-maz@kernel.org> <5cfd4870-db31-cd7d-699f-bd70a1ab90fe@arm.com>
 <5c90a3b2-c9a8-640b-fb6a-7a09d397ba7f@arm.com> <87lfa4fm8u.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <83750329-bbdc-54fe-2613-c07143d546a7@arm.com>
Date: Wed, 31 Mar 2021 11:48:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <87lfa4fm8u.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDMvMzAvMjEgODo1NyBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIFR1
ZSwgMzAgTWFyIDIwMjEgMTg6NDk6NTQgKzAxMDAsCj4gQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFu
ZHJ1LmVsaXNlaUBhcm0uY29tPiB3cm90ZToKPj4gSGkgTWFyYywKPj4KPj4gT24gMy8zMC8yMSA2
OjEzIFBNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+Pj4gWy4uXQo+Pj4+PiArfQo+Pj4+PiAr
Cj4+Pj4+ICAvKioKPj4+Pj4gICAqIGt2bV9hcm1fcmVzZXRfZGVidWdfcHRyIC0gcmVzZXQgdGhl
IGRlYnVnIHB0ciB0byBwb2ludCB0byB0aGUgdmNwdSBzdGF0ZQo+Pj4+PiAgICovCj4+Pj4+IEBA
IC04MywxMiArMTM3LDcgQEAgdm9pZCBrdm1fYXJtX3Jlc2V0X2RlYnVnX3B0cihzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpCj4+Pj4+ICAgKiBAdmNwdToJdGhlIHZjcHUgcG9pbnRlcgo+Pj4+PiAgICoK
Pj4+Pj4gICAqIFRoaXMgaXMgY2FsbGVkIGJlZm9yZSBlYWNoIGVudHJ5IGludG8gdGhlIGh5cGVy
dmlzb3IgdG8gc2V0dXAgYW55Cj4+Pj4+IC0gKiBkZWJ1ZyByZWxhdGVkIHJlZ2lzdGVycy4gQ3Vy
cmVudGx5IHRoaXMganVzdCBlbnN1cmVzIHdlIHdpbGwgdHJhcAo+Pj4+PiAtICogYWNjZXNzIHRv
Ogo+Pj4+PiAtICogIC0gUGVyZm9ybWFuY2UgbW9uaXRvcnMgKE1EQ1JfRUwyX1RQTS9NRENSX0VM
Ml9UUE1DUikKPj4+Pj4gLSAqICAtIERlYnVnIFJPTSBBZGRyZXNzIChNRENSX0VMMl9URFJBKQo+
Pj4+PiAtICogIC0gT1MgcmVsYXRlZCByZWdpc3RlcnMgKE1EQ1JfRUwyX1RET1NBKQo+Pj4+PiAt
ICogIC0gU3RhdGlzdGljYWwgcHJvZmlsZXIgKE1EQ1JfRUwyX1RQTVMvTURDUl9FTDJfRTJQQikK
Pj4+Pj4gKyAqIGRlYnVnIHJlbGF0ZWQgcmVnaXN0ZXJzLgo+Pj4+PiAgICoKPj4+Pj4gICAqIEFk
ZGl0aW9uYWxseSwgS1ZNIG9ubHkgdHJhcHMgZ3Vlc3QgYWNjZXNzZXMgdG8gdGhlIGRlYnVnIHJl
Z2lzdGVycyBpZgo+Pj4+PiAgICogdGhlIGd1ZXN0IGlzIG5vdCBhY3RpdmVseSB1c2luZyB0aGVt
IChzZWUgdGhlIEtWTV9BUk02NF9ERUJVR19ESVJUWQo+Pj4+PiBAQCAtMTAwLDI3ICsxNDksMTQg
QEAgdm9pZCBrdm1fYXJtX3Jlc2V0X2RlYnVnX3B0cihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+
Pj4+ICAKPj4+Pj4gIHZvaWQga3ZtX2FybV9zZXR1cF9kZWJ1ZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpCj4+Pj4+ICB7Cj4+Pj4+IC0JYm9vbCB0cmFwX2RlYnVnID0gISh2Y3B1LT5hcmNoLmZsYWdz
ICYgS1ZNX0FSTTY0X0RFQlVHX0RJUlRZKTsKPj4+Pj4gIAl1bnNpZ25lZCBsb25nIG1kc2NyLCBv
cmlnX21kY3JfZWwyID0gdmNwdS0+YXJjaC5tZGNyX2VsMjsKPj4+Pj4gIAo+Pj4+PiAgCXRyYWNl
X2t2bV9hcm1fc2V0dXBfZGVidWcodmNwdSwgdmNwdS0+Z3Vlc3RfZGVidWcpOwo+Pj4+PiAgCj4+
Pj4+IC0JLyoKPj4+Pj4gLQkgKiBUaGlzIGFsc28gY2xlYXJzIE1EQ1JfRUwyX0UyUEJfTUFTSyB0
byBkaXNhYmxlIGd1ZXN0IGFjY2Vzcwo+Pj4+PiAtCSAqIHRvIHRoZSBwcm9maWxpbmcgYnVmZmVy
Lgo+Pj4+PiAtCSAqLwo+Pj4+PiAtCXZjcHUtPmFyY2gubWRjcl9lbDIgPSBfX3RoaXNfY3B1X3Jl
YWQobWRjcl9lbDIpICYgTURDUl9FTDJfSFBNTl9NQVNLOwo+Pj4+PiAtCXZjcHUtPmFyY2gubWRj
cl9lbDIgfD0gKE1EQ1JfRUwyX1RQTSB8Cj4+Pj4+IC0JCQkJTURDUl9FTDJfVFBNUyB8Cj4+Pj4+
IC0JCQkJTURDUl9FTDJfVFBNQ1IgfAo+Pj4+PiAtCQkJCU1EQ1JfRUwyX1REUkEgfAo+Pj4+PiAt
CQkJCU1EQ1JfRUwyX1RET1NBKTsKPj4+Pj4gKwlrdm1fYXJtX3NldHVwX21kY3JfZWwyKHZjcHUs
IF9fdGhpc19jcHVfcmVhZChtZGNyX2VsMikpOwo+Pj4+PiAgCj4+Pj4+ICAJLyogSXMgR3Vlc3Qg
ZGVidWdnaW5nIGluIGVmZmVjdD8gKi8KPj4+Pj4gIAlpZiAodmNwdS0+Z3Vlc3RfZGVidWcpIHsK
Pj4+Pj4gLQkJLyogUm91dGUgYWxsIHNvZnR3YXJlIGRlYnVnIGV4Y2VwdGlvbnMgdG8gRUwyICov
Cj4+Pj4+IC0JCXZjcHUtPmFyY2gubWRjcl9lbDIgfD0gTURDUl9FTDJfVERFOwo+Pj4+PiAtCj4+
Pj4+ICAJCS8qIFNhdmUgZ3Vlc3QgZGVidWcgc3RhdGUgKi8KPj4+Pj4gIAkJc2F2ZV9ndWVzdF9k
ZWJ1Z19yZWdzKHZjcHUpOwo+Pj4+PiAgCj4+Pj4+IEBAIC0xNzQsNyArMjEwLDYgQEAgdm9pZCBr
dm1fYXJtX3NldHVwX2RlYnVnKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+Pj4gIAo+Pj4+PiAg
CQkJdmNwdS0+YXJjaC5kZWJ1Z19wdHIgPSAmdmNwdS0+YXJjaC5leHRlcm5hbF9kZWJ1Z19zdGF0
ZTsKPj4+Pj4gIAkJCXZjcHUtPmFyY2guZmxhZ3MgfD0gS1ZNX0FSTTY0X0RFQlVHX0RJUlRZOwo+
Pj4+PiAtCQkJdHJhcF9kZWJ1ZyA9IHRydWU7Cj4+Pj4gVGhlcmUgaXMgc29tZXRoaW5nIHRoYXQg
c2xpZ2h0bHkgd29ycmllcyBtZSBoZXJlOiB0aGVyZSBpcyBub3cgYQo+Pj4+IGRpc2Nvbm5lY3Qg
YmV0d2VlbiBmbGFnZ2luZyBkZWJ1ZyBhcyBkaXJ0eSBhbmQgc2V0dGluZyB0aGUKPj4+PiB0cmFw
cGluZy4gQW5kIGFjdHVhbGx5LCB5b3Ugbm93IGNoZWNrIGZvciBLVk1fQVJNNjRfREVCVUdfRElS
VFkgYW5kCj4+Pj4gc2V0IHRoZSB0cmFwIGJpdHMgKmJlZm9yZSogc2V0dGluZyB0aGUgZGlydHkg
Yml0IGl0c2VsZi4KPj4+Pgo+Pj4+IEhlcmUsIEkgYmVsaWV2ZSB5b3UgZW5kIHVwIHdpdGggZ3Vl
c3QvaG9zdCBjb25mdXNpb24gb2YgYnJlYWtwb2ludHMsCj4+Pj4gd2hpY2ggaXNuJ3QgZ3JlYXQu
IE9yIGRpZCBJIG1pc3Mgc29tZXRoaW5nPwo+Pj4gSSdtIHNvcnJ5LCBidXQgSSBkb24ndCB1bmRl
cnN0YW5kIHdoYXQgeW91IG1lYW4uIFRoaXMgaXMgbXkgdW5kZXJzdGFuZGluZyBvZiB3aGF0Cj4+
PiBpcyBoYXBwZW5pbmcuCj4+Pgo+Pj4gV2l0aG91dCB0aGlzIHBhdGNoLCB0cmFwX2RlYnVnIGlz
IHNldCB0byB0cnVlIGFuZCB0aGUgS1ZNX0FSTTY0X0RFQlVHX0RJUlRZIGZsYWcKPj4+IGlzIHNl
dCBpZiB2Y3B1LT5ndWVzdF9kZWJ1ZyAmIEtWTV9HVUVTVERCR19VU0VfSFcuIEZ1cnRoZXIgZG93
biwgdHJhcCBkZWJ1ZyBpcwo+Pj4gb25seSB1c2VkIHdoZW4gY29tcHV0aW5nIG1kY3JfZWwyLgo+
Pj4KPj4+IFdpdGggdGhpcyBwYXRjaCwgdHJhcF9kZWJ1ZyBpcyBzZXQgdG8gdHJ1ZSBpZiB2Y3B1
LT5ndWVzdF9kZWJ1ZyAmCj4+PiBLVk1fR1VFU1REQkdfVVNFX0hXIGFuZCBpdCdzIGFsc28gdXNl
ZCBmb3IgY29tcHV0aW5nIG1kY3JfZWwyLCBidXQgdGhpcyBoYXBwZW5zIGluCj4+PiBrdm1fYXJt
X3NldHVwX21kY3JfZWwyKCksIHdoaWNoIGlzIGNhbGxlZCBhdCB0aGUgc3RhcnQgb2Yga3ZtX2Fy
bV9zZXR1cF9kZWJ1ZygpLgo+Pj4gVGhlIEtWTV9BUk1fREVCVUdfRElSVFkgZmxhZ3MgaXMgc3Rp
bGwgc2V0IGluIGt2bV9hcm1fc2V0dXBfZGVidWcoKSBpZgo+Pj4gdmNwdS0+Z3Vlc3RfZGVidWcg
JiBLVk1fR1VFU1REQkdfVVNFX0hXLCBsaWtlIGJlZm9yZS4KPj4+Cj4+PiBUaGUgZ3Vlc3QgbmV2
ZXIgcnVucyB3aXRoIHRoZSB2YWx1ZSBjb21wdXRlZCBpbiBrdm1fdmNwdV9maXJzdF9ydW5faW5p
dCgpIHVubGVzcwo+Pj4gaXQncyBpZGVudGljYWwgd2l0aCB0aGUgdmFsdWUgcmVjb21wdXRlZCBp
biBrdm1fYXJtX3NldHVwX2RlYnVnKCkuCj4+Pgo+Pj4gVGhlIG9ubHkgZGlmZmVyZW5jZSBJIHNl
ZSBpcyB0aGF0IG1kY3JfZWwyIGlzIGNvbXB1dGVkIGF0IHRoZSBzdGFydCBvZgo+Pj4ga3ZtX2Fy
bV9zZXR1cF9kZWJ1ZygpLiBJIGdldCB0aGUgZmVlbGluZyBJJ20gYWxzbyBtaXNzaW5nIHNvbWV0
aGluZy4KPj4gSSB0aGluayBJIHVuZGVyc3RhbmQgd2hhdCB5b3UgbWVhbiwgeW91IGFyZSB3b3Jy
aWVkIHRoYXQgd2Ugd29uJ3QKPj4gc2V0IHRoZSBiaXQgaW4gbWRjcl9lbDIgdG8gdHJhcCBkZWJ1
ZyBpbiB0aGUgc2FtZSBwbGFjZSB3aGVyZSB3ZSBzZXQKPj4gdGhlIGRlYnVnIGRpcnR5IGZsYWcu
Cj4gWWVzLCB0aGF0J3Mgd2hhdCBJIG1lYW4uIFRoZSBjb2RlIGlzIGNvbmNlcHR1YWxseSBhcyBz
dWNoIEFUTToKPgo+IAlkZWJ1Z190cmFwID0gKHNvbWV0aGluZyBiYXNlZCBvbiB2Y3B1LT5mbGFn
cyk7Cj4gCWlmIChzb21ldGhpbmcgZWxzZSkgewo+IAkJY2hlY2sgc3R1ZmY7Cj4gCQl2Y3B1LT5m
bGFncyB8PSBzdHVmZjsKPiAJCWRlYnVnX3RyYXAgPSB0cnVlOwo+IAl9Cj4KPiAJaWYgKGRlYnVn
X3RyYXApCj4gCQlzZXQgdHJhcCBjb25kaXRpb25zOwo+Cj4gWW91IGFyZSB0dXJuaW5nIHRoaXMg
aW50bzoKPgo+IAlkZWJ1Z190cmFwID0gKHNvbWV0aGluZyBiYXNlZCBvbiB2Y3B1LT5mbGFncyk7
Cj4gCWlmIChkZWJ1Z190cmFwKSB7Cj4gCQlzZXQgdHJhcCBjb25kaXRpb25zOwo+IAl9Cj4gCWlm
IChzb21ldGhpbmcgZWxzZSkgewo+IAkJY2hlY2sgc3R1ZmY7Cj4gCQl2Y3B1LT5mbGFncyB8PSBz
dHVmZjsKPiAJfQo+Cj4gd2hpY2ggaXNuJ3QgdGhlIHNhbWUgdGhpbmcuIEluIHlvdXIgY2FzZSwg
aXQgcHJvYmFibHkgd29ya3MgYmVjYXVzZSBvZgo+IEtWTV9HVUVTVERCR19VU0VfSFcsIGJ1dCB0
aGF0J3MgcmVhbGx5IGhhcmQgdG8gZm9sbG93LCBhbmQgd2UgaGF2ZSBoYWQKPiBzbyBtYW55IGJ1
Z3MgaW4gdGhlIGRlYnVnIGNvZGUgdGhhdCBpdCByZWFsbHkgbmVlZHMgdG8gYmUga2VwdCBhcwo+
IHN0dXBpZCBhcyBwb3NzaWJsZS4KPgo+PiBJZiB0aGF0J3MgdGhlIGNhc2UsIHRoZW4gSSBjYW4g
bW92ZSBrdm1fYXJtX3NldHVwX21kY3JfZWwyIHJpZ2h0Cj4+IGFmdGVyIHRoZSBCVUdfT04oKSBh
bmQgcmVtb3ZlIHRoZSBLVk1fR1VFU1REQkdfVVNFX0hXIGNoZWNrIGJlY2F1c2UKPj4gdGhlIEtW
TV9BUk1fREVCVUdfRElSVFkgd291bGQgYmUgYWxyZWFkeSBzZXQuCj4gWWVzLCBJIHRoaW5rIHRo
YXQnZCBiZSBiZXR0ZXIuCgpPaywgSSdsbCBkbyB0aGF0IHRoZW4uCgo+Cj4+IFF1ZXN0aW9uIHRo
b3VnaCwgaWYgbWRjcl9lbDIgaXMgdGllZCB0byB0aGUgZGVidWcgZGlydHkgZmxhZywgd2UKPj4g
aWdub3JlIHRoZSBmbGFnIGhlcmUgKGNvZGUgd2l0aG91dCB0aGlzIHBhdGNoKToKPj4KPj4gwqDC
oMKgIEJVR19PTighdmNwdS0+Z3Vlc3RfZGVidWcgJiYKPj4gwqDCoMKgIMKgwqDCoCB2Y3B1LT5h
cmNoLmRlYnVnX3B0ciAhPSAmdmNwdS0+YXJjaC52Y3B1X2RlYnVnX3N0YXRlKTsKPj4KPj4gwqDC
oMKgIC8qIFRyYXAgZGVidWcgcmVnaXN0ZXIgYWNjZXNzICovCj4+IMKgwqDCoCBpZiAodHJhcF9k
ZWJ1ZykKPj4gwqDCoMKgIMKgwqDCoCB2Y3B1LT5hcmNoLm1kY3JfZWwyIHw9IE1EQ1JfRUwyX1RE
QTsKPj4KPj4gwqDCoMKgIC8qIElmIEtERSBvciBNREUgYXJlIHNldCwgcGVyZm9ybSBhIGZ1bGwg
c2F2ZS9yZXN0b3JlIGN5Y2xlLiAqLwo+PiDCoMKgwqAgaWYgKHZjcHVfcmVhZF9zeXNfcmVnKHZj
cHUsIE1EU0NSX0VMMSkgJiAoREJHX01EU0NSX0tERSB8IERCR19NRFNDUl9NREUpKQo+PiDCoMKg
wqAgwqDCoMKgIHZjcHUtPmFyY2guZmxhZ3MgfD0gS1ZNX0FSTTY0X0RFQlVHX0RJUlRZOwo+Pgo+
PiBJIHN1cHBvc2UgdGhlcmUncyBzb21ldGhpbmcgSSBkb24ndCB1bmRlcnN0YW5kIHlldCBhYm91
dCBob3cgdGhpcyBpcwo+PiBzdXBwb3NlZCB0byB3b3JrLgo+IFRoZSBpZGVhIChJSVJDKSBpcyB0
aGF0IGlmIE1EU0NSX0VMMS5LREUgb3IgTURTQ1JfRUwxLk1ERSBhcmUgc2V0LAo+IHRoYXQncyBi
ZWNhdXNlIHRoZSBndWVzdCBpcyBjdXJyZW50bHkgZGVidWdnaW5nLCBhbmQgdGhhdCB3ZSBhcmUK
PiBiZXR0ZXIgb2ZmIHNheWluZyB0aGF0IHRoZSBkZWJ1ZyBzdGF0ZSBpcyBkaXJ0eSwgZm9yY2lu
ZyBhCj4gc2F2ZS9yZXN0b3JlIGN5Y2xlIG9uIGVudHJ5LgoKVGhhdCBtYWRlIHRoaW5ncyBhIGJp
dCBjbGVhcmVyLCB0aGFua3MuCgpUaGFua3MsCgpBbGV4Cgo+Cj4gWW91IG1heSB3YW50IHRvIGRp
ZyBpbnRvIHRoZSBnaXQgaGlzdG9yeSBmb3IgbW9yZSBhY2N1cmF0ZQo+IGluZm9ybWF0aW9uLi4u
Cj4KPiBIb3BlIHRoaXMgaGVscHMsCj4KPiAJTS4KPgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
