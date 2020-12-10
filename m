Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9373C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 12:22:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2A8A23C82
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 12:22:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2A8A23C82
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 509374B1E6;
	Thu, 10 Dec 2020 07:22:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cjvu665S3rgj; Thu, 10 Dec 2020 07:22:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 014EF4B1D5;
	Thu, 10 Dec 2020 07:22:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66D604B175
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 07:22:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BQDLwbC3lFqD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 07:22:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5BB4B134
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 07:22:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 417721FB;
 Thu, 10 Dec 2020 04:22:28 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 540F93F718;
 Thu, 10 Dec 2020 04:22:27 -0800 (PST)
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
To: Marc Zyngier <maz@kernel.org>
References: <20201210083059.1277162-1-maz@kernel.org>
 <41fab19e-1e6d-f39b-c0a8-d4a1e54fc9b9@arm.com>
 <ce2301d5ca78e35cd05aca54b14e141a@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1b138aa9-0ea4-1a27-d2f1-81ff5baacd7c@arm.com>
Date: Thu, 10 Dec 2020 12:22:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <ce2301d5ca78e35cd05aca54b14e141a@kernel.org>
Content-Language: en-US
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywKCk9uIDEyLzEwLzIwIDExOjE2IEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkg
QWxleCwKPgo+IFRoYW5rcyBmb3IgbG9va2luZyBhdCB0aGlzLgo+Cj4gT24gMjAyMC0xMi0xMCAx
MDoxMiwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gSGkgTWFyYywKPj4KPj4gT24gMTIvMTAv
MjAgODozMCBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gV2UgcmVzZXQgdGhlIGd1ZXN0J3Mg
dmlldyBvZiBQTUNSX0VMMCB1bmNvbmRpdGlvbmFsbHksIGJhc2VkIG9uCj4+PiB0aGUgaG9zdCdz
IHZpZXcgb2YgdGhpcyByZWdpc3Rlci4gSXQgaXMgaG93ZXZlciBsZWdhbCBmb3IgYW4KPj4+IGlt
bnBsZW1lbnRhdGlvbiBub3QgdG8gcHJvdmlkZSBhbnkgUE1VLCByZXN1bHRpbmcgaW4gYW4gVU5E
RUYuCgpzL2ltbnBsZW1lbnRhdGlvbi9pbXBsZW1lbnRhdGlvbgoKPj4+Cj4+PiBUaGUgb2J2aW91
cyBmaXggaXMgdG8gc2tpcCB0aGUgcmVzZXQgb2YgdGhpcyBzaGFkb3cgcmVnaXN0ZXIKPj4+IHdo
ZW4gbm8gUE1VIGlzIGF2YWlsYWJsZSwgc2lkZXN0ZXBwaW5nIHRoZSBpc3N1ZSBlbnRpcmVseS4K
Pj4+IElmIG5vIFBNVSBpcyBhdmFpbGFibGUsIHRoZSBndWVzdCBpcyBub3QgYWJsZSB0byByZXF1
ZXN0Cj4+PiBhIHZpcnR1YWwgUE1VIGFueXdheSwgc28gbm90IGRvaW5nIG5vdGhpbmcgaXMgdGhl
IHJpZ2h0IHRoaW5nCj4+PiB0byBkbyEKPj4+Cj4+PiBJdCBpcyB1bmxpa2VseSB0aGF0IHRoaXMg
YnVnIGNhbiBoaXQgYW55IEhXIGltcGxlbWVudGF0aW9uCj4+PiB0aG91Z2gsIGFzIHRoZXkgYWxs
IHByb3ZpZGUgYSBQTVUuIEl0IGhhcyBiZWVuIGZvdW5kIHVzaW5nIG5lc3RlZAo+Pj4gdmlydCB3
aXRoIHRoZSBob3N0IEtWTSBub3QgaW1wbGVtZW50aW5nIHRoZSBQTVUgaXRzZWxmLgo+Pj4KPj4+
IEZpeGVzOiBhYjk0NjgzNDBkMmJjICgiYXJtNjQ6IEtWTTogQWRkIGFjY2VzcyBoYW5kbGVyIGZv
ciBQTUNSIHJlZ2lzdGVyIikKPj4+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtl
cm5lbC5vcmc+Cj4+PiAtLS0KPj4+IMKgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyB8IDQgKysr
Kwo+Pj4gwqAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCj4+Pgo+Pj4gZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5j
Cj4+PiBpbmRleCBiYzE1MjQ2Nzc1ZDAuLjZjNjRkMDEwMTAyYiAxMDA2NDQKPj4+IC0tLSBhL2Fy
Y2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdz
LmMKPj4+IEBAIC05MjMsNiArOTIzLDEwIEBAIHN0YXRpYyB2b2lkIHJlc2V0X3BtY3Ioc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBjb25zdAo+Pj4gc3RydWN0IHN5c19yZWdfZGVzYyAqcikKPj4+IMKg
ewo+Pj4gwqDCoMKgwqAgdTY0IHBtY3IsIHZhbDsKPj4+Cj4+PiArwqDCoMKgIC8qIE5vIFBNVSBh
dmFpbGFibGUsIFBNQ1JfRUwwIG1heSBVTkRFRi4uLiAqLwo+Pj4gK8KgwqDCoCBpZiAoIWt2bV9h
cm1fc3VwcG9ydF9wbXVfdjMoKSkKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm47Cj4+PiArCj4+
Cj4+IHJlc2V0X3BtY3IoKSBpcyBjYWxsZWQgZnJvbSBrdm1fcmVzZXRfdmNwdSgpLT5rdm1fcmVz
ZXRfc3lzX3JlZ3MoKS4KPj4gQmVmb3JlIGNhbGxpbmcga3ZtX3Jlc2V0X3N5c19yZWdzKCksIGt2
bV9yZXNldF92Y3B1KCkgcmV0dXJucyAtRUlOVkFMCj4+IGlmIHRoZSBWQ1BVIGhhcyB0aGUgUE1V
djMgZmVhdHVyZSBidXQgdGhlIGhvc3QgZG9lc24ndCBoYXZlIGEgUE1VLgo+Pgo+PiBJdCBsb29r
cyB0byBtZSBsaWtlIHRoZSB1bmRlZiBjYW4gaGFwcGVuIG9ubHkgd2hlbiB0aGUgVkNQVSBmZWF0
dXJlCj4+IGlzbid0IHNldCBhbmQgdGhlIGhhcmR3YXJlIGRvZXNuJ3QgaGF2ZSBhIFBNVS4KPgo+
IFdoaWNoIGlzIGV4YWN0bHkgd2hhdCBJIGRlc2NyaWJlIGluIHRoZSBjb21taXQgbWVzc2FnZSAo
TlYgd2l0aG91dCBQTVUpLgoKWWVzLCBJIHdhcyBsb29raW5nIGF0IHRoZSBjb2RlIHRyeWluZyB0
byB1bmRlcnN0YW5kIGhvdyB0aGUgdW5kZWYgY2FuIGhhcHBlbi4KCj4KPj4gSG93IGFib3V0IHdl
IGNoYW5nZQo+PiB0aGUgdGVzdCB0byBjaGVjayBmb3Iga3ZtX3ZjcHVfaGFzX3BtdSgpIHRvIGF2
b2lkIGV4ZWN1dGluZyB0aGUgZXh0cmEKPj4gaW5zdHJ1Y3Rpb25zLCB3aGljaCBhcmUgbm90IG5l
ZWRlZCBiZWNhdXNlIHRoZSBWTSB3b24ndCBoYXZlIGEgUE1VPwo+Cj4gSSB3ZW50IGRvd24gdGhh
dCByb2FkIGluaXRpYWxseSwgYW5kIHRoZW4gcmVhbGlzZWQgdGhhdCB3ZSBuZWVkIHRvCj4gYmFj
a3BvcnQgdGhpcyBhcyBmYXIgYmFjayBhcyA0LjkgKHRoZSBjb2RlIHdhcyBtZXJnZWQgaW4gNC42
KS4KPiBJIGRvbid0IGZhbmN5IGJhY2twb3J0aW5nIGt2bV92Y3B1X2hhc19wbXUoKSBhbmQgY28u
Li4KCk1ha2VzIHNlbnNlLCBhbmQgSSBkbyBjb25zaWRlciB0aGlzIGFwcHJvYWNoIHRvIGJlIGNv
bnNpc3RlbnQgd2l0aCBob3cgd2UgaGFuZGxlClBNVSByZXNldC4gVGhlIHBhdGNoIGxvb2tzIGFs
cmlnaHQgdG8gbWU6CgpSZXZpZXdlZC1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVs
aXNlaUBhcm0uY29tPgoKVGhhbmtzLApBbGV4Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
