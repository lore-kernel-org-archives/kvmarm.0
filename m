Return-Path: <SRS0=9EBG=ZF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F71C43331
	for <kvmarm@archiver.kernel.org>; Wed, 13 Nov 2019 14:29:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9C9E222D0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Nov 2019 14:29:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9C9E222D0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E69F4B06F;
	Wed, 13 Nov 2019 09:29:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jzDlbQmnXxRt; Wed, 13 Nov 2019 09:29:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E92D4B07D;
	Wed, 13 Nov 2019 09:29:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DB74B067
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Nov 2019 09:29:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 57OO5FqAnQng for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Nov 2019 09:29:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7671F4B062
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Nov 2019 09:29:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8BD27A7;
 Wed, 13 Nov 2019 06:29:08 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4EF33F6C4;
 Wed, 13 Nov 2019 06:29:07 -0800 (PST)
Subject: Re: [PATCH v2 1/2] arm64: Combine workarounds for speculative AT
 errata
To: Marc Zyngier <maz@kernel.org>
References: <20191113114118.2427-1-steven.price@arm.com>
 <20191113114118.2427-2-steven.price@arm.com>
 <566ecd45c8bf07b3cb5d75a10c9413a8@www.loen.fr>
From: Steven Price <steven.price@arm.com>
Message-ID: <d66a3b7f-0338-ca70-7a98-b95aba64221a@arm.com>
Date: Wed, 13 Nov 2019 14:29:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <566ecd45c8bf07b3cb5d75a10c9413a8@www.loen.fr>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

T24gMTMvMTEvMjAxOSAxMjo0NCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMTktMTEtMTMg
MTI6NTAsIFN0ZXZlbiBQcmljZSB3cm90ZToKPj4gQ29ydGV4LUE1Ny9BNzIgaGF2ZSBhIHNpbWls
YXIgZXJyYXRhIHRvIENvcnRleC1BNzYgcmVnYXJkaW5nIHNwZWN1bGF0aW9uCj4+IG9mIHRoZSBB
VCBpbnN0cnVjdGlvbi4gU2luY2UgdGhlIHdvcmthcm91bmQgZm9yIEE1Ny9BNzIgZG9lc24ndCBy
ZXF1aXJlCj4+IFZIRSwgdGhlIHJlc3RyaWN0aW9uIGVuZm9yY2luZyBWSEUgZm9yIEE3NiBjYW4g
YmUgcmVtb3ZlZCBieSBjb21iaW5pbmcKPj4gdGhlIHdvcmthcm91bmQgZmxhZyBmb3IgYm90aCBl
cnJhdGEuCj4gCj4gQXJlIHdlIHN1cmUgdGhhdCBBNzYgYmVoYXZlcyB0aGUgc2FtZSBhcyBBNTcv
QTcyIHdoZW4gaXQgY29tZXMgdG8gbm90Cj4gY2FjaGluZyBhbnkgb2YgdGhlIEVQRCogYml0cyBp
biB0aGUgVExCPyBCZWNhdXNlIHRoZSAxMzE5MzY3IHdvcmthcm91bmQKPiBoYXMgYSBsb3Qgb2Yg
dGhlIEE3MiBtaWNyb2FyY2ggaW1wbGljaXQgdG8gaXQsIGFuZCBJJ20gbm90IHN1cmUgdGhpcwo+
IHdvcmtzIGFzIGlzIG9uIEE3NiBvciBBNTUuLi4KCkhtbSwgd2VsbCBJIHdhcyBnb2luZyBwdXJl
bHkgb24gdGhlIGVycmF0YSBkb2N1bWVudHMgd2hpY2ggaGF2ZQpiYXNpY2FsbHkgdGhlIHNhbWUg
dGV4dCBmb3IgYWxsIHRoZSBlcnJhdGEuIEkgaGF2ZSB0byBhZG1pdCBJIGRvIG5vdAp1bmRlcnN0
YW5kIHRoZSBtaWNyb2FyY2ggZGV0YWlscyBoZXJlLiBQZXJoYXBzIGl0IHdvdWxkIGJlIGJldHRl
ciB0bwpsZWF2ZSB0aGUgVkhFIGFuZCBOVkhFIGNhc2VzIHNlcGFyYXRlZCB0aGVuPwoKU3RldmVu
Cgo+IFRoZSBwYXRjaCBpdHNlbGYgbG9va3MgT0ssIGJ1dCBJJ2QgbGlrZSBzb21lIHJlYXNzdXJh
bmNlIGFib3V0IHRoZQo+IGFib3ZlLgo+IAo+IMKgwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
