Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45A4CA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 11:24:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C1AE20679
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 11:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C1AE20679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9417F4A9A7;
	Mon, 21 Oct 2019 07:24:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3h+K0B7++1uC; Mon, 21 Oct 2019 07:24:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6652D4A9B0;
	Mon, 21 Oct 2019 07:24:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 206744A9A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 07:24:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KcTEm7bJBQBy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 07:24:43 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08FED4A98E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 07:24:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82EBEEBD;
 Mon, 21 Oct 2019 04:24:22 -0700 (PDT)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1F893F718;
 Mon, 21 Oct 2019 04:24:20 -0700 (PDT)
Subject: Re: [PATCH v6 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To: Marc Zyngier <maz@kernel.org>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-6-steven.price@arm.com> <86eez9yoog.wl-maz@kernel.org>
 <1bb10eb5-0fe8-57c9-3b67-9b3661a73d29@arm.com>
 <cc639f743d621198ef02f880089bb54d@www.loen.fr>
From: Steven Price <steven.price@arm.com>
Message-ID: <89a8002f-a9b0-1864-a568-36285eb2c485@arm.com>
Date: Mon, 21 Oct 2019 12:24:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <cc639f743d621198ef02f880089bb54d@www.loen.fr>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

T24gMjEvMTAvMjAxOSAxMTo0MCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMTktMTAtMjEg
MTE6MjEsIFN0ZXZlbiBQcmljZSB3cm90ZToKPj4gT24gMTkvMTAvMjAxOSAxMjoxMiwgTWFyYyBa
eW5naWVyIHdyb3RlOgo+Pj4gT24gRnJpLCAxMSBPY3QgMjAxOSAxMzo1OToyNSArMDEwMCwKPj4+
IFN0ZXZlbiBQcmljZSA8c3RldmVuLnByaWNlQGFybS5jb20+IHdyb3RlOgo+Pj4+Cj4+Pj4gSW1w
bGVtZW50IHRoZSBzZXJ2aWNlIGNhbGwgZm9yIGNvbmZpZ3VyaW5nIGEgc2hhcmVkIHN0cnVjdHVy
ZSBiZXR3ZWVuIGEKPj4+PiBWQ1BVIGFuZCB0aGUgaHlwZXJ2aXNvciBpbiB3aGljaCB0aGUgaHlw
ZXJ2aXNvciBjYW4gd3JpdGUgdGhlIHRpbWUKPj4+PiBzdG9sZW4gZnJvbSB0aGUgVkNQVSdzIGV4
ZWN1dGlvbiB0aW1lIGJ5IG90aGVyIHRhc2tzIG9uIHRoZSBob3N0Lgo+Pj4+Cj4+Pj4gVXNlciBz
cGFjZSBhbGxvY2F0ZXMgbWVtb3J5IHdoaWNoIGlzIHBsYWNlZCBhdCBhbiBJUEEgYWxzbyBjaG9z
ZW4gYnkKPj4+PiB1c2VyCj4+Pj4gc3BhY2UuIFRoZSBoeXBlcnZpc29yIHRoZW4gdXBkYXRlcyB0
aGUgc2hhcmVkIHN0cnVjdHVyZSB1c2luZwo+Pj4+IGt2bV9wdXRfZ3Vlc3QoKSB0byBlbnN1cmUg
c2luZ2xlIGNvcHkgYXRvbWljaXR5IG9mIHRoZSA2NC1iaXQgdmFsdWUKPj4+PiByZXBvcnRpbmcg
dGhlIHN0b2xlbiB0aW1lIGluIG5hbm9zZWNvbmRzLgo+Pj4+Cj4+Pj4gV2hlbmV2ZXIgc3RvbGVu
IHRpbWUgaXMgZW5hYmxlZCBieSB0aGUgZ3Vlc3QsIHRoZSBzdG9sZW4gdGltZQo+Pj4+IGNvdW50
ZXIgaXMKPj4+PiByZXNldC4KPj4+Pgo+Pj4+IFRoZSBzdG9sZW4gdGltZSBpdHNlbGYgaXMgcmV0
cmlldmVkIGZyb20gdGhlIHNjaGVkX2luZm8gc3RydWN0dXJlCj4+Pj4gbWFpbnRhaW5lZCBieSB0
aGUgTGludXggc2NoZWR1bGVyIGNvZGUuIFdlIGVuYWJsZSBTQ0hFRFNUQVRTIHdoZW4KPj4+PiBz
ZWxlY3RpbmcgS1ZNIEtjb25maWcgdG8gZW5zdXJlIHRoaXMgdmFsdWUgaXMgbWVhbmluZ2Z1bC4K
Pj4+Pgo+Pj4+IFNpZ25lZC1vZmYtYnk6IFN0ZXZlbiBQcmljZSA8c3RldmVuLnByaWNlQGFybS5j
b20+Cj4+Pj4gLS0tCj4+Pj4gwqBhcmNoL2FybS9pbmNsdWRlL2FzbS9rdm1faG9zdC5owqDCoCB8
IDIwICsrKysrKysrKysrCj4+Pj4gwqBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0Lmgg
fCAyMSArKysrKysrKysrKy0KPj4+PiDCoGFyY2gvYXJtNjQva3ZtL0tjb25maWfCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHzCoCAxICsKPj4+PiDCoGluY2x1ZGUvbGludXgva3ZtX3R5cGVzLmjCoMKg
wqDCoMKgwqDCoMKgIHzCoCAyICsrCj4+Pj4gwqB2aXJ0L2t2bS9hcm0vYXJtLmPCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAxMSArKysrKysKPj4+PiDCoHZpcnQva3ZtL2FybS9oeXBl
cmNhbGxzLmPCoMKgwqDCoMKgwqDCoMKgIHzCoCAzICsrCj4+Pj4gwqB2aXJ0L2t2bS9hcm0vcHZ0
aW1lLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA1NiArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrCj4+Pj4gwqA3IGZpbGVzIGNoYW5nZWQsIDExMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCj4gCj4gWy4uLl0KPiAKPj4+PiArbG9uZyBrdm1faHlwZXJjYWxsX3N0b2xlbl90
aW1lKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+Cj4+PiBXaHkgbG9uZz8gSWYgdGhhdCdzIGEg
YmFzZSBhZGRyZXNzLCB0aGVuIGl0IGlzIGVpdGhlciBhIHBoeXNfYWRkcl90IG9yCj4+PiBhIGdw
YV90LiBJJ2Qgc3VnZ2VzdCB5b3UgbW92ZSB0aGUgZXJyb3IgY2hlY2sgdG8gdGhlIGNhbGxlci4K
Pj4KPj4gVGhpcyBpcyBhIGJpdCBtb3JlIHRyaWNreS4gSXQncyBhIGxvbmcgYmVjYXVzZSB0aGF0
J3MgdGhlIGRlY2xhcmVkIHR5cGUKPj4gb2YgdGhlIFNNQ0NDIHJldHVybiBpbiBrdm1faHZjX2Nh
bGxfaGFuZGxlcigpLiBJIGNhbid0IChlYXNpbHkpIG1vdmUgdGhlCj4+IGNvZGUgaW50byBrdm1f
aHZjX2NhbGxfaGFuZGxlcigpIGJlY2F1c2UgdGhhdCBpcyBjb21waWxlZCBmb3IgYXJtIChhcwo+
PiB3ZWxsIGFzIGFybTY0KSBhbmQgd2UgZG9uJ3QgaGF2ZSB0aGUgZGVmaW5pdGlvbnMgZm9yIHN0
b2xlbiB0aW1lIHRoZXJlLgo+PiBUaGUgYmVzdCBvcHRpb24gSSBjb3VsZCBjb21lIHVwIHdpdGgg
aXMgdG8gaGF2ZSBhIGR1bW15IHN0dWIgZm9yIGFybSBhbmQKPj4gdXNlIGdlbmVyaWMgdHlwZXMg
Zm9yIHRoaXMgZnVuY3Rpb24uCj4+Cj4+IFRoaXMgbWVhbnMgd2UgbmVlZCBhIHR5cGUgd2hpY2gg
Y2FuIGNvbnRhaW4gYm90aCBhIGdwYV90IGFuZCB0aGUKPj4gU01DQ0NfUkVUX05PVF9TVVBQT1JU
RUQgZXJyb3IgY29kZS4KPj4KPj4gSSdtIG9wZW4gdG8gYWx0ZXJuYXRpdmUgc3VnZ2VzdGlvbnMg
b24gaG93IHRvIG1ha2UgdGhpcyB3b3JrLgo+IAo+IE15IHN1Z2dlc3Rpb24gd291bGQgYmUgdG8g
YWx3YXlzIHJldHVybiBhIGdwYV90IGZyb20gdGhpcyBmdW5jdGlvbiwgYW5kCj4gY2hhbmdlIHRo
ZSAzMmJpdCBzdHViIGZvciBrdm1faHlwZXJjYWxsX3N0b2xlbl90aW1lKCkgdG8gYWx3YXlzIHJl
dHVybgo+IEdQQV9JTlZBTElELgoKT2ssIGZhaXIgZW5vdWdoLiBBbHRob3VnaCBpdCBlbmRzIHVw
IHdpdGggdGhpcyBzdHJhbmdlIGxvb2tpbmcgZnJhZ21lbnQKaW4ga3ZtX2h2Y19jYWxsX2hhbmRs
ZXIoKToKCgljYXNlIEFSTV9TTUNDQ19IVl9QVl9USU1FX1NUOgoJCWdwYSA9IGt2bV9pbml0X3N0
b2xlbl90aW1lKHZjcHUpOwoJCWlmIChncGEgIT0gR1BBX0lOVkFMSUQpCgkJCXZhbCA9IGdwYTsK
CQlicmVhazsKCkJ1dCBJIGFncmVlIHRoZSBncGFfdCByZXR1cm4gdHlwZSBpcyBjbGVhcmVyLgoK
VGhhbmtzLAoKU3RldmUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
