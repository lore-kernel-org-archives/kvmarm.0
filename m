Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2215DC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:56:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F839206F1
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:55:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F839206F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 163CF4B238;
	Thu, 28 May 2020 08:55:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K2av7PC98ebS; Thu, 28 May 2020 08:55:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBF034B21C;
	Thu, 28 May 2020 08:55:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EF0E4B1C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:55:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p1e8pAy09tkI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 08:55:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A6B4B199
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:55:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5792AD6E;
 Thu, 28 May 2020 05:55:55 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FE503F52E;
 Thu, 28 May 2020 05:55:54 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: arm64: Stop save/restoring ACTLR_EL1
To: Marc Zyngier <maz@kernel.org>
References: <20200526161834.29165-1-james.morse@arm.com>
 <20200526161834.29165-3-james.morse@arm.com>
 <4d42a5db0b573c7a184aea654829a06c@kernel.org>
 <07d09551c456c6be326473e003def3ab@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <6ddbc8b4-1ed9-33a7-1f86-21edadad5aec@arm.com>
Date: Thu, 28 May 2020 13:55:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <07d09551c456c6be326473e003def3ab@kernel.org>
Content-Language: en-GB
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

SGkgTWFyYywKCk9uIDI4LzA1LzIwMjAgMTM6MzgsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDIwLTA1LTI4IDEzOjM2LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjAtMDUtMjYgMTc6
MTgsIEphbWVzIE1vcnNlIHdyb3RlOgo+Pj4gS1ZNIHNldHMgSENSX0VMMi5UQUNSICh3aGljaCBp
dCBjYWxscyBIQ1JfVEFDKSB2aWEgSENSX0dVRVNUX0ZMQUdTLgo+Pj4gVGhpcyBtZWFucyBBQ1RM
UiogYWNjZXNzZXMgZnJvbSB0aGUgZ3Vlc3QgYXJlIGFsd2F5cyB0cmFwcGVkLCBhbmQKPj4+IGFs
d2F5cyByZXR1cm4gdGhlIHZhbHVlIGluIHRoZSBzeXNfcmVncyBhcnJheS4KPj4+Cj4+PiBUaGUg
Z3Vlc3QgY2FuJ3QgY2hhbmdlIHRoZSB2YWx1ZSBvZiB0aGVzZSByZWdpc3RlcnMsIHNvIHdlIGFy
ZQo+Pj4gc2F2ZSByZXN0b3JpbmcgdGhlIHJlc2V0IHZhbHVlLCB3aGljaCBjYW1lIGZyb20gdGhl
IGhvc3QuCj4+Pgo+Pj4gU3RvcCBzYXZlL3Jlc3RvcmluZyB0aGlzIHJlZ2lzdGVyLgo+Pj4KPj4+
IFRoaXMgYWxzbyBzdG9wcyB0aGlzIHJlZ2lzdGVyIGJlaW5nIGFmZmVjdGVkIGJ5IHN5c3JlZ3Nf
bG9hZGVkX29uX2NwdSwKPj4+IHNvIHdlIGNhbiBwcm92aWRlIDMyIGJpdCBhY2Nlc3NvcnMgdGhh
dCBhbHdheXMgdXNlIHRoZSBpbi1tZW1vcnkgY29weS4KCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vaHlwL3N5c3JlZy1zci5jIGIvYXJjaC9hcm02NC9rdm0vaHlwL3N5c3JlZy1zci5j
Cj4+PiBpbmRleCA3NWIxOTI1NzYzZjEuLjU3MTE2Y2YzYTFhNSAxMDA2NDQKPj4+IC0tLSBhL2Fy
Y2gvYXJtNjQva3ZtL2h5cC9zeXNyZWctc3IuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vaHlw
L3N5c3JlZy1zci5jCgo+Pj4gQEAgLTEzMyw3ICsxMzIsNiBAQCBzdGF0aWMgdm9pZCBfX2h5cF90
ZXh0Cj4+PiBfX3N5c3JlZ19yZXN0b3JlX2VsMV9zdGF0ZShzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0
ICpjdHh0KQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCBpc2IoKTsKPj4+IMKgwqDCoMKgIH0KPj4+Cj4+
PiAtwqDCoMKgIHdyaXRlX3N5c3JlZyhjdHh0LT5zeXNfcmVnc1tBQ1RMUl9FTDFdLMKgwqDCoMKg
wqDCoMKgIGFjdGxyX2VsMSk7Cj4+Cj4+IElmIHdlIGRvbid0IG5lZWQgdG8gc2F2ZS9yZXN0b3Jl
IGl0LCB3ZSBjYW4gYWxzbyBkcm9wIGl0cyBwcmVzZW5jZQo+PiBpbiB0aGUgc3lzX3JlZ3MgYXJy
YXkuCgpTbyBldmVuIHVzZXItc3BhY2UgYWNjZXNzZXMgcmVhZCBmcm9tIHRoZSBoYXJkd2FyZSBy
ZWdpc3Rlcj8gRmluZSBieSBtZS4KCgo+PiBJdCBzdHJpa2VzIG1lIHRoYXQgd2UgZG9uJ3QgZXZl
biBoYXZlIGEgdHJhcCBoYW5kbGVyIGZvciB0aGlzIHN5c3JlZywKPj4gd2hldGhlciBpdCBpcyAz
MiBvciA2NGJpdC4uLiBUaGF0J3MgYSBiaXQgdW5mb3J0dW5hdGUsIHRvIHNheSB0aGUKPj4gbGVh
c3QuLi4KPiAKPiBBaCwgbm8uIHRoZSBzdWNrZXIgaXMgaGlkZGVuIGF3YXkgaW4gImdlbmVyaWNf
djgiLi4uCgpUaGF0IHRoaW5nIGlzIEE3L0ExNSAoYW5kIHRoZW4gdXNlci1BQkkpIGxlZ2FjeSBy
aWdodD8KCkkgd2FzIGxvb2tpbmcgYXQgcmlwcGluZyBhbGwgdGhhdCBvdXQgd2hlbiBJIHJhbiBv
dmVyIHRoZXNlLiBSRkMgZ3JhZGUsIGtub3duIG5vdCB0byBiaXNlY3Q6Cmh0dHA6Ly93d3cubGlu
dXgtYXJtLm9yZy9naXQ/cD1saW51eC1qbS5naXQ7YT1zaG9ydGxvZztoPXJlZnMvaGVhZHMva3Zt
X2tpbGxfdGFyZ2V0X3RhYmxlL3YwCgoKVGhhbmtzLAoKSmFtZXMKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
