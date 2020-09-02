Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299DCC433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 13:58:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA38020767
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 13:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA38020767
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA2B4B2A5;
	Wed,  2 Sep 2020 09:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z80KSid+sxaJ; Wed,  2 Sep 2020 09:58:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2FB4B2B2;
	Wed,  2 Sep 2020 09:58:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B6D4B2A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 09:58:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7mEDmnCLNu+0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 09:58:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E864B298
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 09:58:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED6EF31B;
 Wed,  2 Sep 2020 06:58:01 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4087E3F71F;
 Wed,  2 Sep 2020 06:58:01 -0700 (PDT)
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
To: Marc Zyngier <maz@kernel.org>
References: <20200822024444.28132-1-gshan@redhat.com>
 <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
 <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
 <772ab66f-1e17-275f-f65d-08d8f67a90f9@arm.com>
 <4fb3f8e03e1fb3bb93113037fa62fceb@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <058dda6c-61d7-c16a-60ac-82b67496c8dd@arm.com>
Date: Wed, 2 Sep 2020 14:58:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4fb3f8e03e1fb3bb93113037fa62fceb@kernel.org>
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

SGkgTWFyYywKCk9uIDkvMi8yMCAxOjA0IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAy
MC0wOS0wMiAxMjo1MywgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gSGkgTWFyYywKPj4KPj4g
T24gOS8yLzIwIDEyOjEwIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBPbiAyMDIwLTA5LTAy
IDExOjU5LCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+Pj4+IEhpLAo+Pj4+Cj4+Pj4gT24gOC8y
Mi8yMCAzOjQ0IEFNLCBHYXZpbiBTaGFuIHdyb3RlOgo+Pj4+PiBEZXBlbmRpbmcgb24gdGhlIGtl
cm5lbCBjb25maWd1cmF0aW9uLCBQVURfU0laRSBjb3VsZCBiZSBlcXVhbCB0bwo+Pj4+PiBQTURf
U0laRS4gRm9yIGV4YW1wbGUsIGJvdGggb2YgdGhlbSBhcmUgNTEyTUIgd2l0aCB0aGUgZm9sbG93
aW5nCj4+Pj4+IGtlcm5lbCBjb25maWd1cmF0aW9uLiBJbiB0aGlzIGNhc2UsIGJvdGggUFVEIGFu
ZCBQTUQgYXJlIGZvbGRlZAo+Pj4+PiB0byBQR0QuCj4+Pj4+Cj4+Pj4+IMKgwqAgQ09ORklHX0FS
TTY0XzY0S19QQUdFU8KgwqAgeQo+Pj4+PiDCoMKgIENPTkZJR19BUk02NF9WQV9CSVRTwqDCoMKg
wqAgNDIKPj4+Pj4gwqDCoCBDT05GSUdfUEdUQUJMRV9MRVZFTFPCoMKgwqAgMgo+Pj4+Pgo+Pj4+
PiBXaXRoIHRoZSBhYm92ZSBjb25maWd1cmF0aW9uLCB0aGUgc3RhZ2UyIFBVRCBpcyB1c2VkIHRv
IGJhY2t1cCB0aGUKPj4+Pj4gNTEyTUIgaHVnZSBwYWdlIHdoZW4gdGhlIHN0YWdlMiBtYXBwaW5n
IGlzIGJ1aWx0LiBEdXJpbmcgdGhlIG1hcHBpbmcsCj4+Pj4+IHRoZSBQVUQgYW5kIGl0cyBzdWJv
cmRpbmF0ZSBsZXZlbHMgb2YgcGFnZSB0YWJsZSBlbnRyaWVzIGFyZSB1bm1hcHBlZAo+Pj4+PiBp
ZiB0aGUgUFVEIGlzIHByZXNlbnQgYW5kIG5vdCBodWdlIHBhZ2Ugc2Vuc2l0aXZlIGluIHN0YWdl
Ml9zZXRfcHVkX2h1Z2UoKS4KPj4+Pj4gVW5mb3JuYXRlbHksIHRoZSBAYWRkciBpc24ndCBhbGln
bmVkIHRvIFMyX1BVRF9TSVpFIGFuZCB3cm9uZyBwYWdlIHRhYmxlCj4+Pj4+IGVudHJpZXMgYXJl
IHphcHBlZC4gSXQgZXZlbnR1YWxseSBsZWFkcyB0byBQVUQncyBwcmVzZW50IGJpdCBjYW4ndCBi
ZQo+Pj4+PiBjbGVhcmVkIHN1Y2Nlc3NmdWxseSBhbmQgaW5maW5pdGUgbG9vcCBpbiBzdGFnZTJf
c2V0X3B1ZF9odWdlKCkuCj4+Pj4+Cj4+Pj4+IFRoaXMgZml4ZXMgdGhlIGlzc3VlIGJ5IGNoZWNr
aW5nIHdpdGggUzJfe1BVRCwgUE1EfV9TSVpFIGluc3RlYWQgb2YKPj4+Pj4ge1BVRCwgUE1EfV9T
SVpFIHRvIGRldGVybWluZSBpZiBzdGFnZTIgUFVEIG9yIFBNRCBpcyB1c2VkIHRvIGJhY2sgdGhl
Cj4+Pj4+IGh1Z2UgcGFnZS4gRm9yIHRoaXMgcGFydGljdWxhciBjYXNlLCB0aGUgc3RhZ2UyIFBN
RCBlbnRyeSBzaG91bGQgYmUKPj4+Pj4gdXNlZCB0byBiYWNrdXAgdGhlIDUxMk1CIGh1Z2UgcGFn
ZSB3aXRoIHN0YWdlMl9zZXRfcG1kX2h1Z2UoKS4KPj4+Pgo+Pj4+IEkgY2FuIHJlcHJvZHVjZSB0
aGlzIG9uIG15IHJvY2twcm82NCB1c2luZyBrdm10b29sLgo+Pj4+Cj4+Pj4gSSBzZWUgdHdvIGlz
c3VlcyBoZXJlOiBmaXJzdCwgUFVEX1NJWkUgPSA1MTJNQiwgYnV0IFMyX1BVRF9TSVpFID0gNFRC
IChjaGVja2VkCj4+Pj4gdXNpbmcgcHJpbnRrKSwgYW5kIHNlY29uZCwgc3RhZ2UyX3NldF9wdWRf
aHVnZSgpIGhhbmdzLiBJJ20gd29ya2luZyBvbgo+Pj4+IGRlYnVnZ2luZyB0aGVtLgo+Pj4KPj4+
IEkgaGF2ZSB0aGlzIGFzIGFuIGltbWVkaWF0ZSBmaXggZm9yIHRoZSBzZXRfcHVkX2h1Z2UgaGFu
ZywgdGVzdGVkCj4+PiBvbiBTZWF0dGxlIHdpdGggNjRrLzQyYml0cy4KPj4+Cj4+PiBJIGNhbid0
IHdhaXQgdG8gc2VlIHRoZSBiYWNrIG9mIHRoaXMgY29kZS4uLgo+Pgo+PiBUaGUgcHJvYmxlbSBp
cyBpbiBzdGFnZTJfc2V0X3B1ZF9odWdlKCksIGJlY2F1c2Uga3ZtX3N0YWdlMl9oYXNfcG1kKCkg
cmV0dXJucwo+PiBmYWxzZSAoQ09ORklHX1BHVEFCTEVfTEVWRUxTID0gMik6Cj4+Cj4+IMKgwqDC
oCBwdWRwID0gc3RhZ2UyX2dldF9wdWQobW11LCBjYWNoZSwgYWRkcik7Cj4+IMKgwqDCoCBWTV9C
VUdfT04oIXB1ZHApOwo+Pgo+PiDCoMKgwqAgb2xkX3B1ZCA9ICpwdWRwOwo+Pgo+PiDCoMKgwqAg
Wy4uXQo+Pgo+PiDCoMKgwqAgLy8gUmV0dXJucyAxIGJlY2F1c2UgIWt2bV9zdGFnZTJfaGFzX3Bt
ZCgpCj4+IMKgwqDCoCBpZiAoc3RhZ2UyX3B1ZF9wcmVzZW50KGt2bSwgb2xkX3B1ZCkpIHsKPj4g
wqDCoMKgIMKgwqDCoCAvKgo+PiDCoMKgwqAgwqDCoMKgIMKgKiBJZiB3ZSBhbHJlYWR5IGhhdmUg
dGFibGUgbGV2ZWwgbWFwcGluZyBmb3IgdGhpcyBibG9jaywgdW5tYXAKPj4gwqDCoMKgIMKgwqDC
oCDCoCogdGhlIHJhbmdlIGZvciB0aGlzIGJsb2NrIGFuZCByZXRyeS4KPj4gwqDCoMKgIMKgwqDC
oCDCoCovCj4+IMKgwqDCoCDCoMKgwqAgaWYgKCFzdGFnZTJfcHVkX2h1Z2Uoa3ZtLCBvbGRfcHVk
KSkgeyAvLyBBbHdheXMgdHJ1ZSBiZWNhdXNlCj4+ICFrdm1fc3RhZ2UyX2hhc19wbWQoKQo+PiDC
oMKgwqAgwqDCoMKgIMKgwqDCoCB1bm1hcF9zdGFnZTJfcmFuZ2UobW11LCBhZGRyICYgUzJfUFVE
X01BU0ssIFMyX1BVRF9TSVpFKTsKPj4gwqDCoMKgIMKgwqDCoCDCoMKgwqAgZ290byByZXRyeTsK
Pj4gwqDCoMKgIMKgwqDCoCB9Cj4+Cj4+IEFuZCB3ZSBlbmQgdXAganVtcGluZyBiYWNrIHRvIHJl
dHJ5IGZvcmV2ZXIuIElNTywgaW4gdXNlcl9tZW1fYWJvcnQoKSwKPj4gaWYgUFVEX1NJWkUKPj4g
PT0gUE1EX1NJWkUsIHdlIHNob3VsZCB0cnkgdG8gbWFwIFBNRF9TSVpFIGluc3RlYWQgb2YgUFVE
X1NJWkUuIE1heWJlIHNvbWV0aGluZwo+PiBsaWtlIHRoaXM/Cj4KPiBFcnIuLi4gSWYgUFVEX1NJ
WkUgPT0gUE1EX1NJWkUsIHdoYXQgZGlmZmVyZW5jZSBkb2VzIGl0IG1ha2UgdG8gbWFwCj4gb25l
IG9yIHRoZSBvdGhlcj8KPgo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vbW11LmMg
Yi9hcmNoL2FybTY0L2t2bS9tbXUuYwo+PiBpbmRleCBiYTAwYmNjMGM4ODQuLjE3ODI2N2RlYzUx
MSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vbW11LmMKPj4gKysrIGIvYXJjaC9hcm02
NC9rdm0vbW11LmMKPj4gQEAgLTE4ODYsOCArMTg4NiwxMCBAQCBzdGF0aWMgaW50IHVzZXJfbWVt
X2Fib3J0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gcGh5c19hZGRyX3QgZmF1bHRfaXBhLAo+
PiDCoMKgwqDCoMKgwqDCoMKgICogQXMgZm9yIFBVRCBodWdlIG1hcHMsIHdlIG11c3QgbWFrZSBz
dXJlIHRoYXQgd2UgaGF2ZSBhdCBsZWFzdAo+PiDCoMKgwqDCoMKgwqDCoMKgICogMyBsZXZlbHMs
IGkuZSwgUE1EIGlzIG5vdCBmb2xkZWQuCj4+IMKgwqDCoMKgwqDCoMKgwqAgKi8KPj4gLcKgwqDC
oMKgwqDCoCBpZiAodm1hX3BhZ2VzaXplID09IFBNRF9TSVpFIHx8Cj4+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoCAodm1hX3BhZ2VzaXplID09IFBVRF9TSVpFICYmIGt2bV9zdGFnZTJfaGFzX3BtZChr
dm0pKSkKPj4gK8KgwqDCoMKgwqDCoCBpZiAodm1hX3BhZ2VzaXplID09IFBVRF9TSVpFICYmICFr
dm1fc3RhZ2UyX2hhc19wbWQoa3ZtKSkKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
dm1hX3BhZ2VzaXplID0gUE1EX1NJWkU7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoCBpZiAodm1hX3Bh
Z2VzaXplID09IFBVRF9TSVpFIHx8IHZtYV9wYWdlc2l6ZSA9PSBQVURfU0laRSkKPj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdmbiA9IChmYXVsdF9pcGEgJiBodWdlX3BhZ2VfbWFz
ayhoc3RhdGVfdm1hKHZtYSkpKSA+Pgo+PiBQQUdFX1NISUZUOwo+PiDCoMKgwqDCoMKgwqDCoCBt
bWFwX3JlYWRfdW5sb2NrKGN1cnJlbnQtPm1tKTsKPgo+IEkgZG9uJ3QgdGhpbmsgdGhpcyBzb2x2
ZXMgYW55dGhpbmcgaW4gdGhlIDIgbGV2ZWwgY2FzZS4gVGhlIGdpc3Qgb2YKPiB0aGUgaXNzdWUg
aXMgdGhhdCBpZiB3ZSBnbyBvbiB0aGUgUFVEIHBhdGgsIHdlIGVuZC11cCBjb21wdXRpbmcgdGhl
Cj4gd3Jvbmcgb2Zmc2V0IGZvciB0aGUgZW50cnkgYW5kIGVpdGhlciBsb29wIG9yIGRvIHNvbWV0
aGluZyBzaWxseS4KPiBJbiBlaXRoZXIgY2FzZSwgd2UgcmVhZC93cml0ZSBzb21ldGhpbmcgd2Ug
aGF2ZSBubyBidXNpbmVzcyB0b3VjaGluZy4KCkluIG15IHRlc3RpbmcsIEkgc2VlbSB0byBiZSBn
ZXR0aW5nIHRoZSByaWdodCBvZmZzZXQuIEZvciBmYXVsdF9pcGEgMHg4MDAwIDAwMDAsCmluIHN0
YWdlMl9zZXRfcHVkX2h1Z2UgSSBnZXQgcHVkcCA9IG1tdS0+cGdkICsgMHgyMCwgd2hpY2ggbG9v
a3MgbGlrZSB0aGUgY29ycmVjdAphZGRyZXNzIGZvciB0aGUgdGFibGUgZW50cnkgKElQQVs0MToy
OV0gPSA0KS4gVGhhdCBhZGRyZXNzIGlzIHZhbGlkIGJlY2F1c2UgaW4Ka3ZtX2luaXRfc3RhZ2Uy
X21tdSB3ZSBhbGxvY2F0ZSBzdGFnZTJfcGdkX3NpemUgPSAxNksgKDQwIGJpdHMgSVBBIHNvIHdl
IG9ubHkgbmVlZAp0byBtYXAgYml0cyBbMzk6MjldIGluIHRoZSBsZXZlbCAyIHRhYmxlKS4KClRo
ZSByZWFzb24gd2h5IEkgYW0gc2VlaW5nIHRoZSBoYW5nIGlzIHdoYXQgSSB0cmllZCB0byBleHBs
YWluZWQgYWJvdmU6Cmlua3ZtX3N0YWdlMl9oYXNfcG1kKCkgaXMgYWx3YXlzIGZhbHNlLCB3aGlj
aCBtZWFucyB0aGF0IGluIHN0YWdlMl9zZXRfcHVkX2h1Z2UsCnN0YWdlMl9wdWRfcHJlc2VudCBp
cyBhbHdheXMgdHJ1ZSBhbmQgc3RhZ2UyX3B1ZF9odWdlIGlzIGFsd2F5cyBmYWxzZSwgd2hpY2gg
bGVhZHMKdG8ganVtcGluZyB0byB0aGUgcmV0cnkgbGFiZWwgaW4gYW4gaW5maW5pdGUgbG9vcC4K
Cj4KPiBHYXZpbiBzaWRlc3RlcHMgdGhlIHByb2JsZW0gYnkgdXNpbmcgYSBmYW50YXN5IFBVRCBz
aXplLCB3aGlsZSBJCj4gY2F0Y2ggaXQgYnkgZXhwbGljaXRseSBjaGVja2luZyBmb3IgdGhlIFBN
RCA9PSBQVUQgY2FzZS4KCk15IG1pc3Rha2UsIEkgc2hvdWxkbid0IGhhdmUgcG9zdGVkIGEgZGlm
ZiB3aXRob3V0IHRlc3RpbmcgaXQuIFlvdSdyZSByaWdodCwgbXkKY2hhbmdlIGZpeGVzIG5vdGhp
bmcgYmVjYXVzZSB2bWFfcGFnZXNpemUgc3RpbGwgZXF1YWxzIFBVRF9TSVpFID09IFBNRF9TSVpF
LgoKSSB0ZXN0ZWQgeW91ciBwYXRjaCBhbmQgdGhlIGhhbmcgZ29lcyBhd2F5LiBJZiB5b3UgZGVj
aWRlIHRvIGtlZXAgeW91ciBwYXRjaCBhcy1pczoKClRlc3RlZC1ieTogQWxleGFuZHJ1IEVsaXNl
aSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgoKUmV2aWV3ZWQtYnk6IEFsZXhhbmRydSBFbGlz
ZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4KCkFzIGFuIGFzaWRlLCBhIGNvbW1lbnQgZXhw
bGFpbmluZyB3aHkgdGhlIGNoZWNrIGZvciBQVURfU0laRSAhPSBQTURfU0laRSBjb3VsZAptYWtl
IGl0IGVhc2llciBmb3Igb3RoZXIgcGVvcGxlIHRvIHVuZGVyc3RhbmQgd2hhdCBpcyBnb2luZyBv
bi4KClRoYW5rcywKQWxleApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
