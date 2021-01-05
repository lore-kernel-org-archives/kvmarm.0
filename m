Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AF7C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 14:46:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7182522B4E
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 14:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7182522B4E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA214B30A;
	Tue,  5 Jan 2021 09:46:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XZKa3OZCoAmB; Tue,  5 Jan 2021 09:46:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EE294B30B;
	Tue,  5 Jan 2021 09:46:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7D84B30B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 09:46:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H2MrcZF2C7TT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 09:46:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A9C4B30A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 09:46:32 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 444341063;
 Tue,  5 Jan 2021 06:46:32 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C1483F70D;
 Tue,  5 Jan 2021 06:46:31 -0800 (PST)
Subject: Re: [PATCH] KVM: arm64: Remove spurious semicolon in reg_to_encoding()
To: Marc Zyngier <maz@kernel.org>
References: <20201231150936.4013764-1-maz@kernel.org>
 <7a5b86e3-a470-a2e0-71b9-177c6c15ecfd@arm.com>
 <a65b85fc0531f37263d16b3d67d1b2c4@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e3153e02-782a-a4e4-0194-85f064e977c0@arm.com>
Date: Tue, 5 Jan 2021 14:46:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a65b85fc0531f37263d16b3d67d1b2c4@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

SGkgTWFyYywKCk9uIDEvNS8yMSAyOjA0IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAy
MS0wMS0wNSAxMzo1NCwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gSGkgTWFyYywKPj4KPj4g
T24gMTIvMzEvMjAgMzowOSBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gQWx0aG91Z2ggbm90
IGEgcHJvYmxlbSByaWdodCBub3csIGl0IGZsYXJlZCB1cCB3aGlsZSB3b3JraW5nCj4+PiBvbiBz
b21lIG90aGVyIGFzcGVjdHMgb2YgdGhlIGNvZGUtYmFzZS4gUmVtb3ZlIHRoZSB1c2VsZXNzCj4+
PiBzZW1pY29sb24uCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2Vy
bmVsLm9yZz4KPj4+IC0tLQo+Pj4gwqBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgMiArLQo+
Pj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKPj4+Cj4+
PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBiL2FyY2gvYXJtNjQva3Zt
L3N5c19yZWdzLmMKPj4+IGluZGV4IGQ0NmU3ZjcwNmNiMC4uNDJjY2MyN2ZiNjg0IDEwMDY0NAo+
Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9r
dm0vc3lzX3JlZ3MuYwo+Pj4gQEAgLTkyMyw3ICs5MjMsNyBAQCBzdGF0aWMgYm9vbCBhY2Nlc3Nf
cG11c2VyZW5yKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0Cj4+PiBzeXNfcmVnX3BhcmFt
cyAqcCwKPj4+Cj4+PiDCoCNkZWZpbmUgcmVnX3RvX2VuY29kaW5nKHgpwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4+PiDCoMKgwqDCoCBzeXNfcmVnKCh1
MzIpKHgpLT5PcDAsICh1MzIpKHgpLT5PcDEswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IFwKPj4+IC3CoMKgwqDCoMKgwqDCoCAodTMyKSh4KS0+Q1JuLCAodTMyKSh4KS0+Q1JtLCAodTMy
KSh4KS0+T3AyKTsKPj4+ICvCoMKgwqDCoMKgwqDCoCAodTMyKSh4KS0+Q1JuLCAodTMyKSh4KS0+
Q1JtLCAodTMyKSh4KS0+T3AyKQo+Pgo+PiBNYWNybydzIHNob3VsZG4ndCByZWFsbHkgZW5kIHdp
dGggYSBzZW1pY29sb24sIG90aGVyd2lzZSBjb2RlIG1pZ2h0IGJyZWFrCj4+IHVuZXhwZWN0ZWRs
eToKPj4KPj4gUmV2aWV3ZWQtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlA
YXJtLmNvbT4KPj4KPj4gSSBza2ltbWVkIG92ZXIgdGhlIGNvZGUgYW5kIHRoZSBtYWNybyBpcyB1
c2VkIGxpa2UgYSBmdW5jdGlvbi4gRG8geW91IHRoaW5rIGl0J3MKPj4gd29ydGggdHVybmluZyBp
dCBpbnRvIGEgZnVuY3Rpb24gdG8gZ2FpbiB0eXBlIGNoZWNraW5nIGZvciB0aGUKPj4gYXJndW1l
bnQgKHdoaWNoIGlzCj4+IGV4cGVjdGVkIHRvIGJlIHN5c19yZWdfZGVzYykgYW5kIGZvciB0aGUg
cmV0dXJuIHZhbHVlPwo+Cj4gTm90IHF1aXRlLgo+Cj4gVGhpcyBtYWNybyB0YWtlcyBpbmRpZmZl
cmVudGx5IGEgc3lzX3JlZ19kZXNjIG9yIGEgc3lzX3JlZ19wYXJhbXMsCgpSaWdodCwgZmluZF9y
ZWcoKSBjYWxscyByZWdfdG9fZW5jb2RpbmcoKSB3aXRoIGEgc3RydWN0IHN5c19yZWdfcGFyYW1z
IGFyZ3VtZW50LCBJCm1pc3NlZCB0aGF0LgoKRm91bmQgYSBmZXcgaW5zdGFuY2VzIHdoZXJlIHN5
c19yZWcoKSBjYWxscyBjYW4gYmUgcmVwbGFjZWQgd2l0aApyZWdfdG9fZW5jb2RpbmcoKSwgd2ls
bCBzZW5kIGEgdHJpdmlhbCBwYXRjaCBmb3IgdGhhdC4KClRoYW5rcywKQWxleAo+IG1ha2luZyBp
dCBpbXBvc3NpYmxlIHRvIHR1cm4gaW50byBhIGZ1bmN0aW9uLiBJcyBpdCBkaXNndXN0aW5nIGFu
ZAo+IG1ha2VzIHlvdSB3YW50IHRvIHB1bGwgeW91ciBleWVzIG91dD8gWWVzLgo+Cj4gVGhlIHdo
b2xlIHBhcmFtcy9kZXNjIGR1YWxpdHkgZGF0ZXMgYmFjayB0byB0aGUgZWFybHkgMzJiaXQgY29k
ZSwKPiBhbmQgSSBibGFtZSBSdXN0eSBSdXNzZWxsIGZvciBpdC4gSnVzdCBzYXlpbmcuLi4gOy0p
Cj4KPiBUaGF0J3Mgb25lIG9mIHRoaW5ncyBJIGFsd2F5cyB3YW50ZWQgdG8gcmVmYWN0b3IuLi4K
Pgo+IFRoYW5rcywKPgo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
