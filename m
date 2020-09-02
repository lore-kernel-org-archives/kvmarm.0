Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C198C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:52:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36F052078B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:52:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36F052078B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEFC64B2B2;
	Wed,  2 Sep 2020 07:52:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p8UTgBb0b09e; Wed,  2 Sep 2020 07:52:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A08414B226;
	Wed,  2 Sep 2020 07:52:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A38E4B208
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:52:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tts0pwFIJPnp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:52:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A094B088
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:52:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4103CD6E;
 Wed,  2 Sep 2020 04:52:31 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CA3A3F66F;
 Wed,  2 Sep 2020 04:52:30 -0700 (PDT)
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
To: Marc Zyngier <maz@kernel.org>
References: <20200822024444.28132-1-gshan@redhat.com>
 <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
 <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <772ab66f-1e17-275f-f65d-08d8f67a90f9@arm.com>
Date: Wed, 2 Sep 2020 12:53:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, shan.gavin@gmail.com
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

SGkgTWFyYywKCk9uIDkvMi8yMCAxMjoxMCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MjAtMDktMDIgMTE6NTksIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IEhpLAo+Pgo+PiBPbiA4
LzIyLzIwIDM6NDQgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4+PiBEZXBlbmRpbmcgb24gdGhlIGtl
cm5lbCBjb25maWd1cmF0aW9uLCBQVURfU0laRSBjb3VsZCBiZSBlcXVhbCB0bwo+Pj4gUE1EX1NJ
WkUuIEZvciBleGFtcGxlLCBib3RoIG9mIHRoZW0gYXJlIDUxMk1CIHdpdGggdGhlIGZvbGxvd2lu
Zwo+Pj4ga2VybmVsIGNvbmZpZ3VyYXRpb24uIEluIHRoaXMgY2FzZSwgYm90aCBQVUQgYW5kIFBN
RCBhcmUgZm9sZGVkCj4+PiB0byBQR0QuCj4+Pgo+Pj4gwqDCoCBDT05GSUdfQVJNNjRfNjRLX1BB
R0VTwqDCoCB5Cj4+PiDCoMKgIENPTkZJR19BUk02NF9WQV9CSVRTwqDCoMKgwqAgNDIKPj4+IMKg
wqAgQ09ORklHX1BHVEFCTEVfTEVWRUxTwqDCoMKgIDIKPj4+Cj4+PiBXaXRoIHRoZSBhYm92ZSBj
b25maWd1cmF0aW9uLCB0aGUgc3RhZ2UyIFBVRCBpcyB1c2VkIHRvIGJhY2t1cCB0aGUKPj4+IDUx
Mk1CIGh1Z2UgcGFnZSB3aGVuIHRoZSBzdGFnZTIgbWFwcGluZyBpcyBidWlsdC4gRHVyaW5nIHRo
ZSBtYXBwaW5nLAo+Pj4gdGhlIFBVRCBhbmQgaXRzIHN1Ym9yZGluYXRlIGxldmVscyBvZiBwYWdl
IHRhYmxlIGVudHJpZXMgYXJlIHVubWFwcGVkCj4+PiBpZiB0aGUgUFVEIGlzIHByZXNlbnQgYW5k
IG5vdCBodWdlIHBhZ2Ugc2Vuc2l0aXZlIGluIHN0YWdlMl9zZXRfcHVkX2h1Z2UoKS4KPj4+IFVu
Zm9ybmF0ZWx5LCB0aGUgQGFkZHIgaXNuJ3QgYWxpZ25lZCB0byBTMl9QVURfU0laRSBhbmQgd3Jv
bmcgcGFnZSB0YWJsZQo+Pj4gZW50cmllcyBhcmUgemFwcGVkLiBJdCBldmVudHVhbGx5IGxlYWRz
IHRvIFBVRCdzIHByZXNlbnQgYml0IGNhbid0IGJlCj4+PiBjbGVhcmVkIHN1Y2Nlc3NmdWxseSBh
bmQgaW5maW5pdGUgbG9vcCBpbiBzdGFnZTJfc2V0X3B1ZF9odWdlKCkuCj4+Pgo+Pj4gVGhpcyBm
aXhlcyB0aGUgaXNzdWUgYnkgY2hlY2tpbmcgd2l0aCBTMl97UFVELCBQTUR9X1NJWkUgaW5zdGVh
ZCBvZgo+Pj4ge1BVRCwgUE1EfV9TSVpFIHRvIGRldGVybWluZSBpZiBzdGFnZTIgUFVEIG9yIFBN
RCBpcyB1c2VkIHRvIGJhY2sgdGhlCj4+PiBodWdlIHBhZ2UuIEZvciB0aGlzIHBhcnRpY3VsYXIg
Y2FzZSwgdGhlIHN0YWdlMiBQTUQgZW50cnkgc2hvdWxkIGJlCj4+PiB1c2VkIHRvIGJhY2t1cCB0
aGUgNTEyTUIgaHVnZSBwYWdlIHdpdGggc3RhZ2UyX3NldF9wbWRfaHVnZSgpLgo+Pgo+PiBJIGNh
biByZXByb2R1Y2UgdGhpcyBvbiBteSByb2NrcHJvNjQgdXNpbmcga3ZtdG9vbC4KPj4KPj4gSSBz
ZWUgdHdvIGlzc3VlcyBoZXJlOiBmaXJzdCwgUFVEX1NJWkUgPSA1MTJNQiwgYnV0IFMyX1BVRF9T
SVpFID0gNFRCIChjaGVja2VkCj4+IHVzaW5nIHByaW50ayksIGFuZCBzZWNvbmQsIHN0YWdlMl9z
ZXRfcHVkX2h1Z2UoKSBoYW5ncy4gSSdtIHdvcmtpbmcgb24KPj4gZGVidWdnaW5nIHRoZW0uCj4K
PiBJIGhhdmUgdGhpcyBhcyBhbiBpbW1lZGlhdGUgZml4IGZvciB0aGUgc2V0X3B1ZF9odWdlIGhh
bmcsIHRlc3RlZAo+IG9uIFNlYXR0bGUgd2l0aCA2NGsvNDJiaXRzLgo+Cj4gSSBjYW4ndCB3YWl0
IHRvIHNlZSB0aGUgYmFjayBvZiB0aGlzIGNvZGUuLi4KClRoZSBwcm9ibGVtIGlzIGluIHN0YWdl
Ml9zZXRfcHVkX2h1Z2UoKSwgYmVjYXVzZSBrdm1fc3RhZ2UyX2hhc19wbWQoKSByZXR1cm5zCmZh
bHNlIChDT05GSUdfUEdUQUJMRV9MRVZFTFMgPSAyKToKCsKgwqDCoCBwdWRwID0gc3RhZ2UyX2dl
dF9wdWQobW11LCBjYWNoZSwgYWRkcik7CsKgwqDCoCBWTV9CVUdfT04oIXB1ZHApOwoKwqDCoMKg
IG9sZF9wdWQgPSAqcHVkcDsKCsKgwqDCoCBbLi5dCgrCoMKgwqAgLy8gUmV0dXJucyAxIGJlY2F1
c2UgIWt2bV9zdGFnZTJfaGFzX3BtZCgpCsKgwqDCoCBpZiAoc3RhZ2UyX3B1ZF9wcmVzZW50KGt2
bSwgb2xkX3B1ZCkpIHsKwqDCoMKgIMKgwqDCoCAvKgrCoMKgwqAgwqDCoMKgIMKgKiBJZiB3ZSBh
bHJlYWR5IGhhdmUgdGFibGUgbGV2ZWwgbWFwcGluZyBmb3IgdGhpcyBibG9jaywgdW5tYXAKwqDC
oMKgIMKgwqDCoCDCoCogdGhlIHJhbmdlIGZvciB0aGlzIGJsb2NrIGFuZCByZXRyeS4KwqDCoMKg
IMKgwqDCoCDCoCovCsKgwqDCoCDCoMKgwqAgaWYgKCFzdGFnZTJfcHVkX2h1Z2Uoa3ZtLCBvbGRf
cHVkKSkgeyAvLyBBbHdheXMgdHJ1ZSBiZWNhdXNlCiFrdm1fc3RhZ2UyX2hhc19wbWQoKQrCoMKg
wqAgwqDCoMKgIMKgwqDCoCB1bm1hcF9zdGFnZTJfcmFuZ2UobW11LCBhZGRyICYgUzJfUFVEX01B
U0ssIFMyX1BVRF9TSVpFKTsKwqDCoMKgIMKgwqDCoCDCoMKgwqAgZ290byByZXRyeTsKwqDCoMKg
IMKgwqDCoCB9CgpBbmQgd2UgZW5kIHVwIGp1bXBpbmcgYmFjayB0byByZXRyeSBmb3JldmVyLiBJ
TU8sIGluIHVzZXJfbWVtX2Fib3J0KCksIGlmIFBVRF9TSVpFCj09IFBNRF9TSVpFLCB3ZSBzaG91
bGQgdHJ5IHRvIG1hcCBQTURfU0laRSBpbnN0ZWFkIG9mIFBVRF9TSVpFLiBNYXliZSBzb21ldGhp
bmcKbGlrZSB0aGlzPwoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL21tdS5jIGIvYXJjaC9h
cm02NC9rdm0vbW11LmMKaW5kZXggYmEwMGJjYzBjODg0Li4xNzgyNjdkZWM1MTEgMTAwNjQ0Ci0t
LSBhL2FyY2gvYXJtNjQva3ZtL21tdS5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCkBAIC0x
ODg2LDggKzE4ODYsMTAgQEAgc3RhdGljIGludCB1c2VyX21lbV9hYm9ydChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsCnBoeXNfYWRkcl90IGZhdWx0X2lwYSwKwqDCoMKgwqDCoMKgwqDCoCAqIEFzIGZv
ciBQVUQgaHVnZSBtYXBzLCB3ZSBtdXN0IG1ha2Ugc3VyZSB0aGF0IHdlIGhhdmUgYXQgbGVhc3QK
wqDCoMKgwqDCoMKgwqDCoCAqIDMgbGV2ZWxzLCBpLmUsIFBNRCBpcyBub3QgZm9sZGVkLgrCoMKg
wqDCoMKgwqDCoMKgICovCi3CoMKgwqDCoMKgwqAgaWYgKHZtYV9wYWdlc2l6ZSA9PSBQTURfU0la
RSB8fAotwqDCoMKgwqDCoMKgwqDCoMKgwqAgKHZtYV9wYWdlc2l6ZSA9PSBQVURfU0laRSAmJiBr
dm1fc3RhZ2UyX2hhc19wbWQoa3ZtKSkpCivCoMKgwqDCoMKgwqAgaWYgKHZtYV9wYWdlc2l6ZSA9
PSBQVURfU0laRSAmJiAha3ZtX3N0YWdlMl9oYXNfcG1kKGt2bSkpCivCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHZtYV9wYWdlc2l6ZSA9IFBNRF9TSVpFOworCivCoMKgwqDCoMKgwqAgaWYg
KHZtYV9wYWdlc2l6ZSA9PSBQVURfU0laRSB8fCB2bWFfcGFnZXNpemUgPT0gUFVEX1NJWkUpCsKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnZm4gPSAoZmF1bHRfaXBhICYgaHVnZV9wYWdl
X21hc2soaHN0YXRlX3ZtYSh2bWEpKSkgPj4gUEFHRV9TSElGVDsKwqDCoMKgwqDCoMKgwqAgbW1h
cF9yZWFkX3VubG9jayhjdXJyZW50LT5tbSk7CsKgClRoYW5rcywKCkFsZXgKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
