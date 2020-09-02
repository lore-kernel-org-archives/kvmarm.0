Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0EBC433E2
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:55:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99155206A5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:55:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99155206A5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C7BA4B292;
	Wed,  2 Sep 2020 07:55:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sAzFXHOdedmj; Wed,  2 Sep 2020 07:55:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3804A4B294;
	Wed,  2 Sep 2020 07:55:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D900C4B28C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:55:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mq3tO39Hq2MV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:55:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF0BC4B208
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:55:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B3B6D6E;
 Wed,  2 Sep 2020 04:55:45 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9AD43F66F;
 Wed,  2 Sep 2020 04:55:44 -0700 (PDT)
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
References: <20200822024444.28132-1-gshan@redhat.com>
 <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
 <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
 <772ab66f-1e17-275f-f65d-08d8f67a90f9@arm.com>
Message-ID: <af71b748-d28b-138c-9acf-fdba3408e0e8@arm.com>
Date: Wed, 2 Sep 2020 12:56:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <772ab66f-1e17-275f-f65d-08d8f67a90f9@arm.com>
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

SGksCgpPbiA5LzIvMjAgMTI6NTMgUE0sIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4gWy4uXQo+
IEFuZCB3ZSBlbmQgdXAganVtcGluZyBiYWNrIHRvIHJldHJ5IGZvcmV2ZXIuIElNTywgaW4gdXNl
cl9tZW1fYWJvcnQoKSwgaWYgUFVEX1NJWkUKPiA9PSBQTURfU0laRSwgd2Ugc2hvdWxkIHRyeSB0
byBtYXAgUE1EX1NJWkUgaW5zdGVhZCBvZiBQVURfU0laRS4gTWF5YmUgc29tZXRoaW5nCj4gbGlr
ZSB0aGlzPwo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL21tdS5jIGIvYXJjaC9hcm02
NC9rdm0vbW11LmMKPiBpbmRleCBiYTAwYmNjMGM4ODQuLjE3ODI2N2RlYzUxMSAxMDA2NDQKPiAt
LS0gYS9hcmNoL2FybTY0L2t2bS9tbXUuYwo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4g
QEAgLTE4ODYsOCArMTg4NiwxMCBAQCBzdGF0aWMgaW50IHVzZXJfbWVtX2Fib3J0KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwKPiBwaHlzX2FkZHJfdCBmYXVsdF9pcGEsCj4gwqDCoMKgwqDCoMKgwqDC
oCAqIEFzIGZvciBQVUQgaHVnZSBtYXBzLCB3ZSBtdXN0IG1ha2Ugc3VyZSB0aGF0IHdlIGhhdmUg
YXQgbGVhc3QKPiDCoMKgwqDCoMKgwqDCoMKgICogMyBsZXZlbHMsIGkuZSwgUE1EIGlzIG5vdCBm
b2xkZWQuCj4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKgwqDCoMKgwqAgaWYgKHZtYV9wYWdl
c2l6ZSA9PSBQTURfU0laRSB8fAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoCAodm1hX3BhZ2VzaXpl
ID09IFBVRF9TSVpFICYmIGt2bV9zdGFnZTJfaGFzX3BtZChrdm0pKSkKPiArwqDCoMKgwqDCoMKg
IGlmICh2bWFfcGFnZXNpemUgPT0gUFVEX1NJWkUgJiYgIWt2bV9zdGFnZTJfaGFzX3BtZChrdm0p
KQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZtYV9wYWdlc2l6ZSA9IFBNRF9TSVpF
Owo+ICsKPiArwqDCoMKgwqDCoMKgIGlmICh2bWFfcGFnZXNpemUgPT0gUFVEX1NJWkUgfHwgdm1h
X3BhZ2VzaXplID09IFBVRF9TSVpFKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBn
Zm4gPSAoZmF1bHRfaXBhICYgaHVnZV9wYWdlX21hc2soaHN0YXRlX3ZtYSh2bWEpKSkgPj4gUEFH
RV9TSElGVDsKPiDCoMKgwqDCoMKgwqDCoCBtbWFwX3JlYWRfdW5sb2NrKGN1cnJlbnQtPm1tKTsK
CkVybS4uLiBnb2VzIHdpdGhvdXQgc2F5aW5nLCBjb21wbGV0ZWx5IHVudGVzdGVkIGFuZCB0aGUg
Y2hlY2sgc2hvdWxkIGhhdmUgYmVlbjoKCivCoMKgwqDCoMKgwqAgaWYgKHZtYV9wYWdlc2l6ZSA9
PSBQVURfU0laRSB8fCB2bWFfcGFnZXNpemUgPT0gUE1EX1NJWkUpCgpUaGFua3MsCgpBbGV4Cgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
