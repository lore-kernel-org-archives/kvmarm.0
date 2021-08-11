Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC566C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 05:34:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A31F60FC3
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 05:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4A31F60FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B57DE4A1A5;
	Wed, 11 Aug 2021 01:34:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XoNXPwRRQaQQ; Wed, 11 Aug 2021 01:34:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 468764064F;
	Wed, 11 Aug 2021 01:34:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8535D4064F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 01:34:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e38hjePlwLhG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 01:33:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 038CF40623
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 01:33:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DD671FB;
 Tue, 10 Aug 2021 22:33:56 -0700 (PDT)
Received: from [10.163.67.241] (unknown [10.163.67.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12A223F718;
 Tue, 10 Aug 2021 22:33:53 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Drop direct PAGE_[SHIFT|SIZE] usage as
 page size
To: Marc Zyngier <maz@kernel.org>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
 <25ee7799069492f2501003faec7f9732@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <0b47c654-7e9b-a7ca-bdf4-f9607062200e@arm.com>
Date: Wed, 11 Aug 2021 11:04:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <25ee7799069492f2501003faec7f9732@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

CgpPbiA4LzEwLzIxIDc6MDMgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIxLTA4LTEw
IDA4OjAyLCBBbnNodW1hbiBLaGFuZHVhbCB3cm90ZToKPj4gQWxsIGluc3RhbmNlcyBoZXJlIGNv
dWxkIGp1c3QgZGlyZWN0bHkgdGVzdCBhZ2FpbnN0IENPTkZJR19BUk02NF9YWEtfUEFHRVMKPj4g
aW5zdGVhZCBvZiBldmFsdWF0aW5nIHZpYSBQQUdFX1NISUZUIG9yIFBBR0VfU0laRS4gV2l0aCB0
aGlzIGNoYW5nZSwgdGhlcmUKPj4gd2lsbCBiZSBubyBzdWNoIHVzYWdlIGxlZnQuCj4+Cj4+IENj
OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+PiBDYzogSmFtZXMgTW9yc2UgPGphbWVz
Lm1vcnNlQGFybS5jb20+Cj4+IENjOiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5kcnUuZWxpc2Vp
QGFybS5jb20+Cj4+IENjOiBTdXp1a2kgSyBQb3Vsb3NlIDxzdXp1a2kucG91bG9zZUBhcm0uY29t
Pgo+PiBDYzogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4KPj4gQ2M6
IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+Cj4+IENjOiBsaW51eC1hcm0ta2VybmVsQGxp
c3RzLmluZnJhZGVhZC5vcmcKPj4gQ2M6IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKPj4g
Q2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKPj4gU2lnbmVkLW9mZi1ieTogQW5zaHVt
YW4gS2hhbmR1YWwgPGFuc2h1bWFuLmtoYW5kdWFsQGFybS5jb20+Cj4+IC0tLQo+PiDCoGFyY2gv
YXJtNjQva3ZtL2h5cC9wZ3RhYmxlLmMgfCA2ICsrKy0tLQo+PiDCoGFyY2gvYXJtNjQvbW0vbW11
LmPCoMKgwqDCoMKgwqDCoMKgwqAgfCAyICstCj4+IMKgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2Vy
dGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2
bS9oeXAvcGd0YWJsZS5jIGIvYXJjaC9hcm02NC9rdm0vaHlwL3BndGFibGUuYwo+PiBpbmRleCAw
NTMyMWY0MTY1ZTMuLmE2MTEyYjZkNmVmNiAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9rdm0v
aHlwL3BndGFibGUuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS9oeXAvcGd0YWJsZS5jCj4+IEBA
IC04NSw3ICs4NSw3IEBAIHN0YXRpYyBib29sIGt2bV9sZXZlbF9zdXBwb3J0c19ibG9ja19tYXBw
aW5nKHUzMiBsZXZlbCkKPj4gwqDCoMKgwqDCoCAqIFJlamVjdCBpbnZhbGlkIGJsb2NrIG1hcHBp
bmdzIGFuZCBkb24ndCBib3RoZXIgd2l0aCA0VEIgbWFwcGluZ3MgZm9yCj4+IMKgwqDCoMKgwqAg
KiA1Mi1iaXQgUEFzLgo+PiDCoMKgwqDCoMKgICovCj4+IC3CoMKgwqAgcmV0dXJuICEobGV2ZWwg
PT0gMCB8fCAoUEFHRV9TSVpFICE9IFNaXzRLICYmIGxldmVsID09IDEpKTsKPj4gK8KgwqDCoCBy
ZXR1cm4gIShsZXZlbCA9PSAwIHx8ICghSVNfRU5BQkxFRChDT05GSUdfQVJNNjRfNEtfUEFHRVMp
ICYmIGxldmVsID09IDEpKTsKPj4gwqB9Cj4+Cj4+IMKgc3RhdGljIGJvb2wga3ZtX2Jsb2NrX21h
cHBpbmdfc3VwcG9ydGVkKHU2NCBhZGRyLCB1NjQgZW5kLCB1NjQgcGh5cywgdTMyIGxldmVsKQo+
PiBAQCAtMTU1LDcgKzE1NSw3IEBAIHN0YXRpYyB1NjQga3ZtX3B0ZV90b19waHlzKGt2bV9wdGVf
dCBwdGUpCj4+IMKgewo+PiDCoMKgwqDCoCB1NjQgcGEgPSBwdGUgJiBLVk1fUFRFX0FERFJfTUFT
SzsKPj4KPj4gLcKgwqDCoCBpZiAoUEFHRV9TSElGVCA9PSAxNikKPj4gK8KgwqDCoCBpZiAoSVNf
RU5BQkxFRChDT05GSUdfQVJNNjRfNjRLX1BBR0VTKSkKPj4gwqDCoMKgwqDCoMKgwqDCoCBwYSB8
PSBGSUVMRF9HRVQoS1ZNX1BURV9BRERSXzUxXzQ4LCBwdGUpIDw8IDQ4Owo+Pgo+PiDCoMKgwqDC
oCByZXR1cm4gcGE7Cj4+IEBAIC0xNjUsNyArMTY1LDcgQEAgc3RhdGljIGt2bV9wdGVfdCBrdm1f
cGh5c190b19wdGUodTY0IHBhKQo+PiDCoHsKPj4gwqDCoMKgwqAga3ZtX3B0ZV90IHB0ZSA9IHBh
ICYgS1ZNX1BURV9BRERSX01BU0s7Cj4+Cj4+IC3CoMKgwqAgaWYgKFBBR0VfU0hJRlQgPT0gMTYp
Cj4+ICvCoMKgwqAgaWYgKElTX0VOQUJMRUQoQ09ORklHX0FSTTY0XzY0S19QQUdFUykpCj4+IMKg
wqDCoMKgwqDCoMKgwqAgcHRlIHw9IEZJRUxEX1BSRVAoS1ZNX1BURV9BRERSXzUxXzQ4LCBwYSA+
PiA0OCk7Cj4+Cj4+IMKgwqDCoMKgIHJldHVybiBwdGU7Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L21tL21tdS5jIGIvYXJjaC9hcm02NC9tbS9tbXUuYwo+PiBpbmRleCA5ZmYwZGUxYjJiOTMu
LjhmZGZjYTE3OTgxNSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9tbS9tbXUuYwo+PiArKysg
Yi9hcmNoL2FybTY0L21tL21tdS5jCj4+IEBAIC0yOTYsNyArMjk2LDcgQEAgc3RhdGljIHZvaWQg
YWxsb2NfaW5pdF9jb250X3BtZChwdWRfdCAqcHVkcCwKPj4gdW5zaWduZWQgbG9uZyBhZGRyLAo+
PiDCoHN0YXRpYyBpbmxpbmUgYm9vbCB1c2VfMUdfYmxvY2sodW5zaWduZWQgbG9uZyBhZGRyLCB1
bnNpZ25lZCBsb25nIG5leHQsCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBs
b25nIHBoeXMpCj4+IMKgewo+PiAtwqDCoMKgIGlmIChQQUdFX1NISUZUICE9IDEyKQo+PiArwqDC
oMKgIGlmICghSVNfRU5BQkxFRChDT05GSUdfQVJNNjRfNEtfUEFHRVMpKQo+PiDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiBmYWxzZTsKPj4KPj4gwqDCoMKgwqAgaWYgKCgoYWRkciB8IG5leHQgfCBw
aHlzKSAmIH5QVURfTUFTSykgIT0gMCkKPiAKPiBJIHBlcnNvbmFsbHkgZmluZCBpdCBhIGxvdCBs
ZXNzIHJlYWRhYmxlLgo+IAo+IEFsc28sIHRoZXJlIGlzIG5vIGV2YWx1YXRpb24gd2hhdHNvZXZl
ci4gQWxsIHRoZSBjb2RlIGd1YXJkZWQKPiBieSBhIFBBR0VfU0laRS9QQUdFX1NISUZUIHRoYXQg
ZG9lc24ndCBtYXRjaCB0aGUgY29uZmlndXJhdGlvbgo+IGlzIGRyb3BwZWQgYXQgY29tcGlsZSB0
aW1lLgoKVGhlIHByaW1hcnkgaWRlYSBoZXJlIGlzIHRvIHVuaWZ5IGFyb3VuZCBJU19FTkFCTEVE
KENPTkZJR19BUk02NF9YWEtfUEFHRVMpCnVzYWdlIGluIGFybTY0LCByYXRoZXIgdGhhbiBoYXZp
bmcgbXVsdGlwbGUgbWV0aG9kcyB0byB0ZXN0IHBhZ2Ugc2l6ZSB3aGVuCmV2ZXIgcmVxdWlyZWQu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
