Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F22CC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 14:48:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B29D23372
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 14:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B29D23372
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 583054B239;
	Mon,  7 Dec 2020 09:48:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id slzXFsDWyluf; Mon,  7 Dec 2020 09:48:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 304E94B238;
	Mon,  7 Dec 2020 09:48:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 754EA4B235
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 09:48:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SdLCz8idDs0l for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 09:48:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 234874B190
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 09:48:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 943EE1042;
 Mon,  7 Dec 2020 06:48:23 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F328B3F68F;
 Mon,  7 Dec 2020 06:48:20 -0800 (PST)
Subject: Re: [PATCH v6 1/2] arm64: kvm: Save/restore MTE registers
To: Marc Zyngier <maz@kernel.org>
References: <20201127152113.13099-1-steven.price@arm.com>
 <20201127152113.13099-2-steven.price@arm.com>
 <946b1e7b06c4d286a78cf61408e0fc8d@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <03566358-21b0-11d9-c4f6-d07d137a1009@arm.com>
Date: Mon, 7 Dec 2020 14:48:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <946b1e7b06c4d286a78cf61408e0fc8d@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

T24gMDMvMTIvMjAyMCAxNzowNywgTWFyYyBaeW5naWVyIHdyb3RlOgo+IAo+PiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCAKPj4gYi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL3N5c3JlZy5oCj4+IGluZGV4IGUyZWY0YzJlZGYwNi4uYjY2NjhmZmEwNGQ5IDEwMDY0
NAo+PiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+ICsrKyBiL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmgKPj4gQEAgLTU2OSw3ICs1NjksOCBAQAo+PiDCoCNk
ZWZpbmUgU0NUTFJfRUx4X03CoMKgwqAgKEJJVCgwKSkKPj4KPj4gwqAjZGVmaW5lIFNDVExSX0VM
eF9GTEFHU8KgwqDCoCAoU0NUTFJfRUx4X03CoCB8IFNDVExSX0VMeF9BIHwgU0NUTFJfRUx4X0Mg
fCBcCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgU0NUTFJfRUx4X1NBIHwgU0NUTFJfRUx4
X0kgfCBTQ1RMUl9FTHhfSUVTQikKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBTQ1RMUl9F
THhfU0EgfCBTQ1RMUl9FTHhfSSB8IFNDVExSX0VMeF9JRVNCIHwgXAo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIFNDVExSX0VMeF9JVEZTQikKPj4KPj4gwqAvKiBTQ1RMUl9FTDIgc3BlY2lm
aWMgZmxhZ3MuICovCj4+IMKgI2RlZmluZSBTQ1RMUl9FTDJfUkVTMcKgwqDCoCAoKEJJVCg0KSnC
oCB8IChCSVQoNSkpwqAgfCAoQklUKDExKSkgfCAKPj4gKEJJVCgxNikpIHwgXAo+PiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N5c3JlZy1zci5oCj4+IGIvYXJj
aC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N5c3JlZy1zci5oCj4+IGluZGV4IGNjZTQzYmZl
MTU4Zi4uNDUyNTViYTYwMTUyIDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9oeXAvaW5j
bHVkZS9oeXAvc3lzcmVnLXNyLmgKPj4gKysrIGIvYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUv
aHlwL3N5c3JlZy1zci5oCj4+IEBAIC0xOCw2ICsxOCwxMSBAQAo+PiDCoHN0YXRpYyBpbmxpbmUg
dm9pZCBfX3N5c3JlZ19zYXZlX2NvbW1vbl9zdGF0ZShzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0IAo+
PiAqY3R4dCkKPj4gwqB7Cj4+IMKgwqDCoMKgIGN0eHRfc3lzX3JlZyhjdHh0LCBNRFNDUl9FTDEp
wqDCoMKgID0gcmVhZF9zeXNyZWcobWRzY3JfZWwxKTsKPj4gK8KgwqDCoCBpZiAoc3lzdGVtX3N1
cHBvcnRzX210ZSgpKSB7Cj4gCj4gUGxlYXNlIG1vdmUgdGhlIHBlci1WTSBwcmVkaWNhdGUgdG8g
dGhpcyBwYXRjaCBzbyB0aGF0IGl0IGNhbiBiZSB1c2VkCj4gbm90IHRvIHNhdmUvcmVzdG9yZSB0
aGUgTVRFIHJlZ2lzdGVycyBpZiB3ZSBkb24ndCBuZWVkIHRvLgoKVGhlcmUgaXNuJ3QgYSB2YWxp
ZCBzdHJ1Y3Qga3ZtX3ZjcHUgb3Igc3RydWN0IGt2bSBoZXJlLiBJIGtub3cgdGhlcmUncyAKY3R4
LT5fX2h5cF9ydW5uaW5nX3ZjcHUgYnV0IEFGQUlDVCB0aGF0IGlzIG9ubHkgdmFsaWQgd2l0aCB0
aGUgaG9zdCBjb250ZXh0LgoKPiAKPj4gK8KgwqDCoMKgwqDCoMKgIGN0eHRfc3lzX3JlZyhjdHh0
LCBSR1NSX0VMMSnCoMKgwqAgPSByZWFkX3N5c3JlZ19zKFNZU19SR1NSX0VMMSk7Cj4+ICvCoMKg
wqDCoMKgwqDCoCBjdHh0X3N5c19yZWcoY3R4dCwgR0NSX0VMMSnCoMKgwqAgPSByZWFkX3N5c3Jl
Z19zKFNZU19HQ1JfRUwxKTsKPj4gK8KgwqDCoMKgwqDCoMKgIGN0eHRfc3lzX3JlZyhjdHh0LCBU
RlNSRTBfRUwxKcKgwqDCoCA9IAo+PiByZWFkX3N5c3JlZ19zKFNZU19URlNSRTBfRUwxKTsKPj4g
K8KgwqDCoCB9Cj4gCj4gT3ZlcmFsbCwgSSBzdGlsbCBkb24ndCB1bmRlcnN0YW5kIGhvdyB0aGlz
IGlzIGdvaW5nIHRvIHdvcmsgb25jZQo+IHdlIGhhdmUgTVRFIGluIHRoZSBrZXJuZWwuIFlvdSBt
ZW50aW9uZWQgaGF2aW5nIHRoZSBhYmlsaXR5IHRvCj4gY3JlYXRlIHR1cm4gb2ZmIHRoZSB0YWcg
Y2hlY2tzIGF0IHRpbWVzLCBidXQgSSBkb24ndCBzZWUgdGhhdAo+IGluIHRoaXMgcGF0Y2ggKGFu
ZCBJJ20gbm90IHN1cmUgd2Ugd2FudCB0aGF0IGVpdGhlcikuCgpHaXZlbiB0aGF0IHRoaXMgaXMg
bm93IGhpZ2hseSB1bmxpa2VseSB0byBiZSBtZXJnZWQgZm9yIHY1LjExLCBJJ2xsIApyZWJhc2Ug
b250byBvZiB0aGUgS0FTQU4gTVRFIHNlcmllcyBhbmQgZG91YmxlIGNoZWNrIGV4YWN0bHkgd2hh
dCAKaGFwcGVucy4gTXkgdGhvdWdodCB3YXMgdGhhdCBpdCBzaG91bGQgYmUgYXMgc2ltcGxlIGFz
IHNldHRpbmcgVENPLCBidXQgCnlvdXIgcHJldmlvdXMgY29tbWVudCBhYm91dCBtb3ZpbmcgdGhl
IHNhdmUvcmVzdG9yZSBpbnRvIGFzc2VtYmxlciBtaWdodCAKYmUgd2lzZSBpbiBjYXNlIHRoZSBj
b21waWxlciBzdGFydHMgcGxheWluZyB3aXRoIFRDTyBpdHNlbGYuCgpTdGV2ZQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
