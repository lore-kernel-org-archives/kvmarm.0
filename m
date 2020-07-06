Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3AAC433DF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:17:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D58D20739
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CgttgXoa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D58D20739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAAD34B3E0;
	Mon,  6 Jul 2020 08:17:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B2ocM7AZu2+x; Mon,  6 Jul 2020 08:17:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5BE4B392;
	Mon,  6 Jul 2020 08:17:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A8B4B2B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:17:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SqVtCs9wKi21 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 08:17:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CC144B29A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:17:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 49A3F2070C;
 Mon,  6 Jul 2020 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594037853;
 bh=KuxlYi/WPeTd60f/cMp3naUg3QZOGwvNaBWXU66jIVE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=CgttgXoal5cvnNee8/vDQpHse3xCG5b9UzDhFHkcuTafKGilaGK2bDf0F0nsTECi5
 vpQnUWxcleiB4DOEcoQ90TVvF1AYQEUmfZZ9243cL4JvJa3nfLQKAwtpRj1M2ncV/r
 GU0xUFi+YHrWj9cX8fvPCLkse+RK0KbdaUylhHyE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jsQ3v-009Rdk-KW; Mon, 06 Jul 2020 13:17:31 +0100
MIME-Version: 1.0
Date: Mon, 06 Jul 2020 13:17:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
In-Reply-To: <d3804b25-4ce4-b263-c087-d8e563f939ed@arm.com>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
 <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
 <9c0044564885d3356f76b55f35426987@kernel.org>
 <d3804b25-4ce4-b263-c087-d8e563f939ed@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <b3f34d53dfe8bc3c2b0838187fe12538@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, mark.rutland@arm.com,
 kernel-team@android.com, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 jintack@cs.columbia.edu, andre.przywara@arm.com, christoffer.dall@arm.com,
 kvmarm@lists.cs.columbia.edu, gcherian@marvell.com, james.morse@arm.com,
 ascull@google.com, prime.zeng@hisilicon.com, catalin.marinas@arm.com,
 julien.thierry.kdev@gmail.com, will@kernel.org, Dave.Martin@arm.com,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
 Dave Martin <Dave.Martin@arm.com>
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

T24gMjAyMC0wNi0yNSAxMzoxOSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPiBIaSBNYXJjLAo+
IAo+IE9uIDYvMTYvMjAgNToxOCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBIaSBBbGV4YW5k
cnUsCj4+IFsuLl0KPj4+PiBbLi5dCj4+Pj4gCj4+Pj4gwqAvKioKPj4+PiAtICoga3ZtX2FsbG9j
X3N0YWdlMl9wZ2QgLSBhbGxvY2F0ZSBsZXZlbC0xIHRhYmxlIGZvciBzdGFnZS0yIAo+Pj4+IHRy
YW5zbGF0aW9uLgo+Pj4+IC0gKiBAa3ZtOsKgwqDCoCBUaGUgS1ZNIHN0cnVjdCBwb2ludGVyIGZv
ciB0aGUgVk0uCj4+Pj4gKyAqIGt2bV9pbml0X3N0YWdlMl9tbXUgLSBJbml0aWFsaXNlIGEgUzIg
TU1VIHN0cnVjcnVyZQo+Pj4+ICsgKiBAa3ZtOsKgwqDCoCBUaGUgcG9pbnRlciB0byB0aGUgS1ZN
IHN0cnVjdHVyZQo+Pj4+ICsgKiBAbW11OsKgwqDCoCBUaGUgcG9pbnRlciB0byB0aGUgczIgTU1V
IHN0cnVjdHVyZQo+Pj4+IMKgICoKPj4+PiDCoCAqIEFsbG9jYXRlcyBvbmx5IHRoZSBzdGFnZS0y
IEhXIFBHRCBsZXZlbCB0YWJsZShzKSBvZiBzaXplIGRlZmluZWQgCj4+Pj4gYnkKPj4+PiAtICog
c3RhZ2UyX3BnZF9zaXplKGt2bSkuCj4+Pj4gKyAqIHN0YWdlMl9wZ2Rfc2l6ZShtbXUtPmt2bSku
Cj4+Pj4gwqAgKgo+Pj4+IMKgICogTm90ZSB3ZSBkb24ndCBuZWVkIGxvY2tpbmcgaGVyZSBhcyB0
aGlzIGlzIG9ubHkgY2FsbGVkIHdoZW4gdGhlIAo+Pj4+IFZNIGlzCj4+Pj4gwqAgKiBjcmVhdGVk
LCB3aGljaCBjYW4gb25seSBiZSBkb25lIG9uY2UuCj4+Pj4gwqAgKi8KPj4+PiAtaW50IGt2bV9h
bGxvY19zdGFnZTJfcGdkKHN0cnVjdCBrdm0gKmt2bSkKPj4+PiAraW50IGt2bV9pbml0X3N0YWdl
Ml9tbXUoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3MyX21tdSAqbW11KQo+Pj4+IMKgewo+
Pj4+IMKgwqDCoMKgIHBoeXNfYWRkcl90IHBnZF9waHlzOwo+Pj4+IMKgwqDCoMKgIHBnZF90ICpw
Z2Q7Cj4+Pj4gK8KgwqDCoCBpbnQgY3B1Owo+Pj4+IAo+Pj4+IC3CoMKgwqAgaWYgKGt2bS0+YXJj
aC5wZ2QgIT0gTlVMTCkgewo+Pj4+ICvCoMKgwqAgaWYgKG1tdS0+cGdkICE9IE5VTEwpIHsKPj4+
PiDCoMKgwqDCoMKgwqDCoMKgIGt2bV9lcnIoImt2bV9hcmNoIGFscmVhZHkgaW5pdGlhbGl6ZWQ/
XG4iKTsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+Pj4+IMKgwqDCoMKg
IH0KPj4+PiBAQCAtMTAyNCw4ICsxMDQwLDIwIEBAIGludCBrdm1fYWxsb2Nfc3RhZ2UyX3BnZChz
dHJ1Y3Qga3ZtICprdm0pCj4+Pj4gwqDCoMKgwqAgaWYgKFdBUk5fT04ocGdkX3BoeXMgJiB+a3Zt
X3Z0dGJyX2JhZGRyX21hc2soa3ZtKSkpCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJ
TlZBTDsKPj4+IAo+Pj4gV2UgZG9uJ3QgZnJlZSB0aGUgcGdkIGlmIHdlIGdldCB0aGUgZXJyb3Ig
YWJvdmUsIGJ1dCB3ZSBkbyBmcmVlIGl0IAo+Pj4gYmVsb3csIGlmCj4+PiBhbGxvY2F0aW5nIGxh
c3RfdmNwdV9yYW4gZmFpbHMuIFNob3VsZG4ndCB3ZSBmcmVlIGl0IGluIGJvdGggY2FzZXM/Cj4+
IAo+PiBXb3J0aCBpbnZlc3RpZ2F0aW5nLiBUaGlzIGNvZGUgZ2V0cyBtYWpvcmx5IHJldmFtcGVk
IGluIHRoZSBOViBzZXJpZXMsIAo+PiBzbyBpdCBpcwo+PiBsaWtlbHkgdGhhdCBJIG1pc3NlZCBz
b21ldGhpbmcgaW4gdGhlIG1pZGRsZS4KPiAKPiBZb3UgZGlkbid0IG1pc3MgYW55dGhpbmcsIEkg
Y2hlY2tlZCBhbmQgaXQncyB0aGUgc2FtZSBpbiB0aGUgdXBzdHJlYW0KPiB2ZXJzaW9uIG9mIEtW
TS4KPiAKPiBrdm1fYXJjaF9pbml0X3ZtKCkgcmV0dXJucyB3aXRoIGFuIGVycm9yIGlmIHRoaXMg
ZnVuY3Rpb25zIGZhaWxzLCBzbyAKPiBpdCdzIHVwIHRvCj4gdGhlIGZ1bmN0aW9uIHRvIGRvIHRo
ZSBjbGVhbiB1cC4ga3ZtX2FsbG9jX3BhZ2VzX2V4YWN0KCkgcmV0dXJucyBOVUxMCj4gb24gZXJy
b3IsIHNvCj4gYXQgdGhpcyBwb2ludCB3ZSBoYXZlIGEgdmFsaWQgYWxsb2NhdGlvbiBvZiBwaHlz
aWNhbCBjb250aWd1b3VzIHBhZ2VzLgo+IEZhaWxpbmcgdG8KPiBjcmVhdGUgYSBWTSBpcyBub3Qg
YSBmYXRhbCBlcnJvciBmb3IgdGhlIHN5c3RlbSwgc28gSSdtIHRoaW5raW5nIHRoYXQgCj4gbWF5
YmUgd2UKPiBzaG91bGQgZnJlZSB0aG9zZSBwYWdlcyBmb3IgdGhlIHJlc3Qgb2YgdGhlIHN5c3Rl
bSB0byB1c2UuIEhvd2V2ZXIsIAo+IHRoaXMgaXMgYQo+IG1pbm9yIGlzc3VlLCBhbmQgdGhlIHBh
dGNoIGlzbid0IHN1cHBvc2VkIHRvIG1ha2UgYW55IGZ1bmN0aW9uYWwgCj4gY2hhbmdlcywgc28g
aXQKPiBjYW4gYmUgcHJvYmFibHkgYmUgbGVmdCBmb3IgYW5vdGhlciBwYXRjaCBhbmQgbm90IGFk
ZCBtb3JlIHRvIGFuCj4gYWxyZWFkeSBiaWcgc2VyaWVzLgoKQ29vbC4gV2lsbCB5b3UgYmUgcG9z
dGluZyBzdWNoIHBhdGNoPwoKVGhhbmtzLAoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRl
YWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
