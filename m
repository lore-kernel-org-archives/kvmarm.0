Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB434C433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 12:04:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36CD32078B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 12:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0SSr1Dkb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36CD32078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3F514B2A9;
	Wed,  2 Sep 2020 08:04:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FF2YOmeMZfiX; Wed,  2 Sep 2020 08:04:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E0014B2A2;
	Wed,  2 Sep 2020 08:04:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B43E340152
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 08:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GVhHdXX5aDwR for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 08:04:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 784DD4B299
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 08:04:03 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6095E2078B;
 Wed,  2 Sep 2020 12:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599048242;
 bh=0X/UMIMOWUDaTHSd7+AtcRDOy5C28ix2vjoS3omKofA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=0SSr1Dkb8jM4FroIP36t8jIl4PO7P4hs7R4IpOe933TE0yR35FjRrXTAlyVyEdiAO
 MuoJXxJ4jXXd0evtI44ETBgsajrufXKGXwi3lsPA0Dcwuag1h22/Xax5Bhugm6EG0N
 MC93q0t8vfbLQdNtFKF4YbesDx+ajAoA6TRFzWGg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDRUe-008ZOZ-W1; Wed, 02 Sep 2020 13:04:01 +0100
MIME-Version: 1.0
Date: Wed, 02 Sep 2020 13:04:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
In-Reply-To: <772ab66f-1e17-275f-f65d-08d8f67a90f9@arm.com>
References: <20200822024444.28132-1-gshan@redhat.com>
 <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
 <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
 <772ab66f-1e17-275f-f65d-08d8f67a90f9@arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <4fb3f8e03e1fb3bb93113037fa62fceb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, gshan@redhat.com,
 kvmarm@lists.cs.columbia.edu, shan.gavin@gmail.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0wOS0wMiAxMjo1MywgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPiBIaSBNYXJjLAo+
IAo+IE9uIDkvMi8yMCAxMjoxMCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIwLTA5
LTAyIDExOjU5LCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+Pj4gSGksCj4+PiAKPj4+IE9uIDgv
MjIvMjAgMzo0NCBBTSwgR2F2aW4gU2hhbiB3cm90ZToKPj4+PiBEZXBlbmRpbmcgb24gdGhlIGtl
cm5lbCBjb25maWd1cmF0aW9uLCBQVURfU0laRSBjb3VsZCBiZSBlcXVhbCB0bwo+Pj4+IFBNRF9T
SVpFLiBGb3IgZXhhbXBsZSwgYm90aCBvZiB0aGVtIGFyZSA1MTJNQiB3aXRoIHRoZSBmb2xsb3dp
bmcKPj4+PiBrZXJuZWwgY29uZmlndXJhdGlvbi4gSW4gdGhpcyBjYXNlLCBib3RoIFBVRCBhbmQg
UE1EIGFyZSBmb2xkZWQKPj4+PiB0byBQR0QuCj4+Pj4gCj4+Pj4gwqDCoCBDT05GSUdfQVJNNjRf
NjRLX1BBR0VTwqDCoCB5Cj4+Pj4gwqDCoCBDT05GSUdfQVJNNjRfVkFfQklUU8KgwqDCoMKgIDQy
Cj4+Pj4gwqDCoCBDT05GSUdfUEdUQUJMRV9MRVZFTFPCoMKgwqAgMgo+Pj4+IAo+Pj4+IFdpdGgg
dGhlIGFib3ZlIGNvbmZpZ3VyYXRpb24sIHRoZSBzdGFnZTIgUFVEIGlzIHVzZWQgdG8gYmFja3Vw
IHRoZQo+Pj4+IDUxMk1CIGh1Z2UgcGFnZSB3aGVuIHRoZSBzdGFnZTIgbWFwcGluZyBpcyBidWls
dC4gRHVyaW5nIHRoZSAKPj4+PiBtYXBwaW5nLAo+Pj4+IHRoZSBQVUQgYW5kIGl0cyBzdWJvcmRp
bmF0ZSBsZXZlbHMgb2YgcGFnZSB0YWJsZSBlbnRyaWVzIGFyZSAKPj4+PiB1bm1hcHBlZAo+Pj4+
IGlmIHRoZSBQVUQgaXMgcHJlc2VudCBhbmQgbm90IGh1Z2UgcGFnZSBzZW5zaXRpdmUgaW4gCj4+
Pj4gc3RhZ2UyX3NldF9wdWRfaHVnZSgpLgo+Pj4+IFVuZm9ybmF0ZWx5LCB0aGUgQGFkZHIgaXNu
J3QgYWxpZ25lZCB0byBTMl9QVURfU0laRSBhbmQgd3JvbmcgcGFnZSAKPj4+PiB0YWJsZQo+Pj4+
IGVudHJpZXMgYXJlIHphcHBlZC4gSXQgZXZlbnR1YWxseSBsZWFkcyB0byBQVUQncyBwcmVzZW50
IGJpdCBjYW4ndCAKPj4+PiBiZQo+Pj4+IGNsZWFyZWQgc3VjY2Vzc2Z1bGx5IGFuZCBpbmZpbml0
ZSBsb29wIGluIHN0YWdlMl9zZXRfcHVkX2h1Z2UoKS4KPj4+PiAKPj4+PiBUaGlzIGZpeGVzIHRo
ZSBpc3N1ZSBieSBjaGVja2luZyB3aXRoIFMyX3tQVUQsIFBNRH1fU0laRSBpbnN0ZWFkIG9mCj4+
Pj4ge1BVRCwgUE1EfV9TSVpFIHRvIGRldGVybWluZSBpZiBzdGFnZTIgUFVEIG9yIFBNRCBpcyB1
c2VkIHRvIGJhY2sgCj4+Pj4gdGhlCj4+Pj4gaHVnZSBwYWdlLiBGb3IgdGhpcyBwYXJ0aWN1bGFy
IGNhc2UsIHRoZSBzdGFnZTIgUE1EIGVudHJ5IHNob3VsZCBiZQo+Pj4+IHVzZWQgdG8gYmFja3Vw
IHRoZSA1MTJNQiBodWdlIHBhZ2Ugd2l0aCBzdGFnZTJfc2V0X3BtZF9odWdlKCkuCj4+PiAKPj4+
IEkgY2FuIHJlcHJvZHVjZSB0aGlzIG9uIG15IHJvY2twcm82NCB1c2luZyBrdm10b29sLgo+Pj4g
Cj4+PiBJIHNlZSB0d28gaXNzdWVzIGhlcmU6IGZpcnN0LCBQVURfU0laRSA9IDUxMk1CLCBidXQg
UzJfUFVEX1NJWkUgPSA0VEIgCj4+PiAoY2hlY2tlZAo+Pj4gdXNpbmcgcHJpbnRrKSwgYW5kIHNl
Y29uZCwgc3RhZ2UyX3NldF9wdWRfaHVnZSgpIGhhbmdzLiBJJ20gd29ya2luZyAKPj4+IG9uCj4+
PiBkZWJ1Z2dpbmcgdGhlbS4KPj4gCj4+IEkgaGF2ZSB0aGlzIGFzIGFuIGltbWVkaWF0ZSBmaXgg
Zm9yIHRoZSBzZXRfcHVkX2h1Z2UgaGFuZywgdGVzdGVkCj4+IG9uIFNlYXR0bGUgd2l0aCA2NGsv
NDJiaXRzLgo+PiAKPj4gSSBjYW4ndCB3YWl0IHRvIHNlZSB0aGUgYmFjayBvZiB0aGlzIGNvZGUu
Li4KPiAKPiBUaGUgcHJvYmxlbSBpcyBpbiBzdGFnZTJfc2V0X3B1ZF9odWdlKCksIGJlY2F1c2Ug
a3ZtX3N0YWdlMl9oYXNfcG1kKCkgCj4gcmV0dXJucwo+IGZhbHNlIChDT05GSUdfUEdUQUJMRV9M
RVZFTFMgPSAyKToKPiAKPiDCoMKgwqAgcHVkcCA9IHN0YWdlMl9nZXRfcHVkKG1tdSwgY2FjaGUs
IGFkZHIpOwo+IMKgwqDCoCBWTV9CVUdfT04oIXB1ZHApOwo+IAo+IMKgwqDCoCBvbGRfcHVkID0g
KnB1ZHA7Cj4gCj4gwqDCoMKgIFsuLl0KPiAKPiDCoMKgwqAgLy8gUmV0dXJucyAxIGJlY2F1c2Ug
IWt2bV9zdGFnZTJfaGFzX3BtZCgpCj4gwqDCoMKgIGlmIChzdGFnZTJfcHVkX3ByZXNlbnQoa3Zt
LCBvbGRfcHVkKSkgewo+IMKgwqDCoCDCoMKgwqAgLyoKPiDCoMKgwqAgwqDCoMKgIMKgKiBJZiB3
ZSBhbHJlYWR5IGhhdmUgdGFibGUgbGV2ZWwgbWFwcGluZyBmb3IgdGhpcyBibG9jaywgdW5tYXAK
PiDCoMKgwqAgwqDCoMKgIMKgKiB0aGUgcmFuZ2UgZm9yIHRoaXMgYmxvY2sgYW5kIHJldHJ5Lgo+
IMKgwqDCoCDCoMKgwqAgwqAqLwo+IMKgwqDCoCDCoMKgwqAgaWYgKCFzdGFnZTJfcHVkX2h1Z2Uo
a3ZtLCBvbGRfcHVkKSkgeyAvLyBBbHdheXMgdHJ1ZSBiZWNhdXNlCj4gIWt2bV9zdGFnZTJfaGFz
X3BtZCgpCj4gwqDCoMKgIMKgwqDCoCDCoMKgwqAgdW5tYXBfc3RhZ2UyX3JhbmdlKG1tdSwgYWRk
ciAmIFMyX1BVRF9NQVNLLCBTMl9QVURfU0laRSk7Cj4gwqDCoMKgIMKgwqDCoCDCoMKgwqAgZ290
byByZXRyeTsKPiDCoMKgwqAgwqDCoMKgIH0KPiAKPiBBbmQgd2UgZW5kIHVwIGp1bXBpbmcgYmFj
ayB0byByZXRyeSBmb3JldmVyLiBJTU8sIGluIHVzZXJfbWVtX2Fib3J0KCksCj4gaWYgUFVEX1NJ
WkUKPiA9PSBQTURfU0laRSwgd2Ugc2hvdWxkIHRyeSB0byBtYXAgUE1EX1NJWkUgaW5zdGVhZCBv
ZiBQVURfU0laRS4gTWF5YmUgCj4gc29tZXRoaW5nCj4gbGlrZSB0aGlzPwoKRXJyLi4uIElmIFBV
RF9TSVpFID09IFBNRF9TSVpFLCB3aGF0IGRpZmZlcmVuY2UgZG9lcyBpdCBtYWtlIHRvIG1hcApv
bmUgb3IgdGhlIG90aGVyPwoKPiAKPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vbW11LmMg
Yi9hcmNoL2FybTY0L2t2bS9tbXUuYwo+IGluZGV4IGJhMDBiY2MwYzg4NC4uMTc4MjY3ZGVjNTEx
IDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4gKysrIGIvYXJjaC9hcm02NC9r
dm0vbW11LmMKPiBAQCAtMTg4Niw4ICsxODg2LDEwIEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJv
cnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+IHBoeXNfYWRkcl90IGZhdWx0X2lwYSwKPiDCoMKg
wqDCoMKgwqDCoMKgICogQXMgZm9yIFBVRCBodWdlIG1hcHMsIHdlIG11c3QgbWFrZSBzdXJlIHRo
YXQgd2UgaGF2ZSBhdCAKPiBsZWFzdAo+IMKgwqDCoMKgwqDCoMKgwqAgKiAzIGxldmVscywgaS5l
LCBQTUQgaXMgbm90IGZvbGRlZC4KPiDCoMKgwqDCoMKgwqDCoMKgICovCj4gLcKgwqDCoMKgwqDC
oCBpZiAodm1hX3BhZ2VzaXplID09IFBNRF9TSVpFIHx8Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
ICh2bWFfcGFnZXNpemUgPT0gUFVEX1NJWkUgJiYga3ZtX3N0YWdlMl9oYXNfcG1kKGt2bSkpKQo+
ICvCoMKgwqDCoMKgwqAgaWYgKHZtYV9wYWdlc2l6ZSA9PSBQVURfU0laRSAmJiAha3ZtX3N0YWdl
Ml9oYXNfcG1kKGt2bSkpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm1hX3BhZ2Vz
aXplID0gUE1EX1NJWkU7Cj4gKwo+ICvCoMKgwqDCoMKgwqAgaWYgKHZtYV9wYWdlc2l6ZSA9PSBQ
VURfU0laRSB8fCB2bWFfcGFnZXNpemUgPT0gUFVEX1NJWkUpCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGdmbiA9IChmYXVsdF9pcGEgJiBodWdlX3BhZ2VfbWFzayhoc3RhdGVfdm1h
KHZtYSkpKSA+Pgo+IFBBR0VfU0hJRlQ7Cj4gwqDCoMKgwqDCoMKgwqAgbW1hcF9yZWFkX3VubG9j
ayhjdXJyZW50LT5tbSk7CgpJIGRvbid0IHRoaW5rIHRoaXMgc29sdmVzIGFueXRoaW5nIGluIHRo
ZSAyIGxldmVsIGNhc2UuIFRoZSBnaXN0IG9mCnRoZSBpc3N1ZSBpcyB0aGF0IGlmIHdlIGdvIG9u
IHRoZSBQVUQgcGF0aCwgd2UgZW5kLXVwIGNvbXB1dGluZyB0aGUKd3Jvbmcgb2Zmc2V0IGZvciB0
aGUgZW50cnkgYW5kIGVpdGhlciBsb29wIG9yIGRvIHNvbWV0aGluZyBzaWxseS4KSW4gZWl0aGVy
IGNhc2UsIHdlIHJlYWQvd3JpdGUgc29tZXRoaW5nIHdlIGhhdmUgbm8gYnVzaW5lc3MgdG91Y2hp
bmcuCgpHYXZpbiBzaWRlc3RlcHMgdGhlIHByb2JsZW0gYnkgdXNpbmcgYSBmYW50YXN5IFBVRCBz
aXplLCB3aGlsZSBJCmNhdGNoIGl0IGJ5IGV4cGxpY2l0bHkgY2hlY2tpbmcgZm9yIHRoZSBQTUQg
PT0gUFVEIGNhc2UuCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBz
bWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
