Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8D3C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:29:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1C0261417
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1C0261417
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 233AE4B22E;
	Wed, 28 Apr 2021 06:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gRKQ+2uHHjAz; Wed, 28 Apr 2021 06:29:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1063C4B22A;
	Wed, 28 Apr 2021 06:29:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C724B1EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:29:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YPNn6YkvV4Pn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 06:29:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 831D14B226
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:29:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3FE02613F4;
 Wed, 28 Apr 2021 10:29:28 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lbhRd-009q8t-Vn; Wed, 28 Apr 2021 11:29:26 +0100
MIME-Version: 1.0
Date: Wed, 28 Apr 2021 11:29:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test into
 KVM and TCG variants
In-Reply-To: <20210428101844.22656-2-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <eaed3c63988513fe2849c2d6f22937af@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org,
 shashi.mallela@linaro.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
 qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMjAyMS0wNC0yOCAxMToxOCwgQWxleCBCZW5uw6llIHdyb3RlOgo+IEEgZmV3IG9mIHRoZSBp
dHMtdHJpZ2dlciB0ZXN0cyByZWx5IG9uIElNUERFRiBiZWhhdmlvdXIgd2hlcmUgY2FjaGVzCj4g
YXJlbid0IGZsdXNoZWQgYmVmb3JlIGludmFsbCBldmVudHMuIEhvd2V2ZXIgVENHIGVtdWxhdGlv
biBkb2Vzbid0Cj4gbW9kZWwgYW55IGludmFsbCBiZWhhdmlvdXIgYW5kIGFzIHdlIGNhbid0IHBy
b2JlIGZvciBpdCB3ZSBuZWVkIHRvIGJlCj4gdG9sZC4gU3BsaXQgdGhlIHRlc3QgaW50byBhIEtW
TSBhbmQgVENHIHZhcmlhbnQgYW5kIHNraXAgdGhlIGludmFsbAo+IHRlc3RzIHdoZW4gdW5kZXIg
VENHLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4KPiBDYzogU2hhc2hpIE1hbGxlbGEgPHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Cj4g
LS0tCj4gIGFybS9naWMuYyAgICAgICAgIHwgNjAgKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgYXJtL3VuaXR0ZXN0cy5jZmcgfCAxMSArKysrKysrKy0K
PiAgMiBmaWxlcyBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlvbnMoLSkKPiAK
PiBkaWZmIC0tZ2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCj4gaW5kZXggOTgxMzVlZi4uOTZh
MzI5ZCAxMDA2NDQKPiAtLS0gYS9hcm0vZ2ljLmMKPiArKysgYi9hcm0vZ2ljLmMKPiBAQCAtMzYs
NiArMzYsNyBAQCBzdGF0aWMgc3RydWN0IGdpYyAqZ2ljOwo+ICBzdGF0aWMgaW50IGFja2VkW05S
X0NQVVNdLCBzcHVyaW91c1tOUl9DUFVTXTsKPiAgc3RhdGljIGludCBpcnFfc2VuZGVyW05SX0NQ
VVNdLCBpcnFfbnVtYmVyW05SX0NQVVNdOwo+ICBzdGF0aWMgY3B1bWFza190IHJlYWR5Owo+ICtz
dGF0aWMgYm9vbCB1bmRlcl90Y2c7Cj4gCj4gIHN0YXRpYyB2b2lkIG5yX2NwdV9jaGVjayhpbnQg
bnIpCj4gIHsKPiBAQCAtNzM0LDMyICs3MzUsMzggQEAgc3RhdGljIHZvaWQgdGVzdF9pdHNfdHJp
Z2dlcih2b2lkKQo+ICAJLyoKPiAgCSAqIHJlLWVuYWJsZSB0aGUgTFBJIGJ1dCB3aWxsaW5nbHkg
ZG8gbm90IGNhbGwgaW52YWxsCj4gIAkgKiBzbyB0aGUgY2hhbmdlIGluIGNvbmZpZyBpcyBub3Qg
dGFrZW4gaW50byBhY2NvdW50Lgo+IC0JICogVGhlIExQSSBzaG91bGQgbm90IGhpdAo+ICsJICog
VGhlIExQSSBzaG91bGQgbm90IGhpdC4gVGhpcyBkb2VzIGhvd2V2ZXIgZGVwZW5kIG9uCj4gKwkg
KiBpbXBsZW1lbnRhdGlvbiBkZWZpbmVkIGJlaGF2aW91ciAtIHVuZGVyIFFFTVUgVENHIGVtdWxh
dGlvbgo+ICsJICogaXQgY2FuIHF1aXRlIGNvcnJlY3RseSBwcm9jZXNzIHRoZSBldmVudCBkaXJl
Y3RseS4KCkl0IGxvb2tzIHRvIG1lIHRoYXQgeW91IGFyZSB1c2luZyBhbiBJTVBERUYgYmVoYXZp
b3VyIG9mICpUQ0cqCmhlcmUuIFRoZSBwcm9ncmFtbWluZyBtb2RlbCBtYW5kYXRlcyB0aGF0IHRo
ZXJlIGlzIGFuIGludmFsaWRhdGlvbgppZiB5b3UgY2hhbmdlIHRoZSBjb25maWd1cmF0aW9uIG9m
IHRoZSBMUEkuCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVs
bHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
