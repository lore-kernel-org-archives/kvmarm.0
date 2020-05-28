Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDA1C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:10:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 107DA2063A
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 12:10:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ht9aeBKO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 107DA2063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4564B20E;
	Thu, 28 May 2020 08:10:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KV7mo2-MNxGM; Thu, 28 May 2020 08:10:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 385F54B235;
	Thu, 28 May 2020 08:10:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 064CA4B20C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IR8HyZSIieVE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 08:10:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D16504B20D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 08:10:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A250C2063A;
 Thu, 28 May 2020 12:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590667824;
 bh=d+BX6Yu8bblCkc+YNytpyy6IyNc3spMni5yB2tDpCBo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Ht9aeBKOOs2qT1O/Jvk9zPAOcwXArR2X6BqtFlTRNkhygdQL6r7LWzmyaWb1t3W8h
 UqL6mOfc0/m5+zw2y/OBxfwIasqR7K5PEpKjOHGYp4+m2sY25Oc9jSCCDK8KjpZOvF
 ib1gW6SFhgUu7PfBzWBFDbczaL8jB4B44mtPq0fU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jeHMd-00Fyr7-3o; Thu, 28 May 2020 13:10:23 +0100
MIME-Version: 1.0
Date: Thu, 28 May 2020 13:10:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
In-Reply-To: <09dca8e9-c548-43fd-a95b-747a77f19e02@arm.com>
References: <20200526161834.29165-1-james.morse@arm.com>
 <20200526161834.29165-2-james.morse@arm.com>
 <4be0c0b654f7d7c1efe9f52efb856bd8@kernel.org>
 <09dca8e9-c548-43fd-a95b-747a77f19e02@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <705687e37c5d5339a6baafa9e31675cb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0wNS0yOCAxMjo1OSwgSmFtZXMgTW9yc2Ugd3JvdGU6Cj4gSGkgTWFyYywKPiAKPiBP
biAyOC8wNS8yMDIwIDA5OjU3LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjAtMDUtMjYg
MTc6MTgsIEphbWVzIE1vcnNlIHdyb3RlOgo+Pj4gYWNjZXNzX2Nzc2VscigpIHVzZXMgdGhlIDMy
Yml0IHItPnJlZyB2YWx1ZSB0byBhY2Nlc3MgdGhlIDY0Yml0IAo+Pj4gYXJyYXksCj4+PiBzbyBy
ZWFkcyBhbmQgd3JpdGUgdGhlIHdyb25nIHZhbHVlLiBzeXNfcmVnc1s0XSwgaXMgQUNUTFJfRUwx
LCB3aGljaAo+Pj4gaXMgc3Vic2VxdWVudGx5IHNhdmUvcmVzdG9yZWQgd2hlbiB3ZSBlbnRlciB0
aGUgZ3Vlc3QuCj4gCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBi
L2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4+IGluZGV4IDUxZGI5MzQ3MDJiNi4uMmVkYTUz
OWYzMjgxIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gKysr
IGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gQEAgLTIwNjAsNyArMjA2MCw3IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjIGNwMTVfcmVnc1tdID0gCj4+PiB7Cj4+PiAK
Pj4+IMKgwqDCoMKgIHsgT3AxKDEpLCBDUm4oIDApLCBDUm0oIDApLCBPcDIoMCksIGFjY2Vzc19j
Y3NpZHIgfSwKPj4+IMKgwqDCoMKgIHsgT3AxKDEpLCBDUm4oIDApLCBDUm0oIDApLCBPcDIoMSks
IGFjY2Vzc19jbGlkciB9LAo+Pj4gLcKgwqDCoCB7IE9wMSgyKSwgQ1JuKCAwKSwgQ1JtKCAwKSwg
T3AyKDApLCBhY2Nlc3NfY3NzZWxyLCBOVUxMLCAKPj4+IGMwX0NTU0VMUiB9LAo+Pj4gK8KgwqDC
oCB7IE9wMSgyKSwgQ1JuKCAwKSwgQ1JtKCAwKSwgT3AyKDApLCBhY2Nlc3NfY3NzZWxyX2VsMSwg
TlVMTCwgCj4+PiBDU1NFTFJfRUwxIH0sCj4+PiDCoH07Cj4gCj4+IFRoaXMgaXMgYSBkZXBhcnR1
cmUgZnJvbSB0aGUgd2F5IHdlIGRlYWwgd2l0aCAzMmJpdCBDUDE1IHJlZ2lzdGVycy4KPj4gV2Ug
ZGVhbCB3aXRoIHRoaXMgZXhhY3QgaXNzdWUgaW4gYSB2ZXJ5IGRpZmZlcmVudCB3YXkgZm9yIG90
aGVyCj4+IENQMTUgcmVncywgYnkgYWRqdXN0aW5nIHRoZSBpbmRleCBpbiB0aGUgc3lzX3JlZ3Mg
YXJyYXkgKHNlZSB0aGUKPj4gd2F5IHdlIGhhbmRsZSB0aGUgVk0gcmVncykuCj4+IAo+PiBIb3cg
YWJvdXQgc29tZXRoaW5nIGxpa2UgdGhpcyAodW50ZXN0ZWQpOgo+IAo+IFtsaWtlIGFjY2Vzc192
bV9yZWcoKSBkb2VzXQo+IAo+IFN1cmUsIEknbGwgZ2l2ZSB0aGF0IGEgdGVzdCBhbmQgcmUtcG9z
dCBpdC4KClRoYW5rcyEKCj4gCj4gCj4+IElkZWFsbHksIEknZCBsaWtlIHRoZSBjb3JlIHN5c19y
ZWcgY29kZSB0byBkZWFsIHdpdGggdGhpcyBzb3J0Cj4+IG9mIGZ1bm5pZXMsIGJ1dCBJJ20gdHJ5
aW5nIHRvIGtlZXAgdGhlIGNoYW5nZSBtaW5pbWFsLi4uCj4gCj4gUm9sbCB0aGlzICcvMicgYW5k
IHVwcGVyL2xvd2VyIGJpdHMgc3R1ZmYgaW50byBhIHZjcHVfd3JpdGVfY3AxNV9yZWcoKQo+IHRo
YXQgY2FsbHMKPiB2Y3B1X3dyaXRlX3N5c19yZWcoKT8gKC9tZSBodW50cyBvdXQgdGhlIHRvZG8g
bGlzdCkKCkkgd2FzIHRoaW5raW5nIG9mIGhpZGluZyBpdCBkaWZmZXJlbnRseTogaW4gZW11bGF0
ZV9jcCwgc3Vic3RpdHV0ZSB0aGUKc3lzX3JlZ19kZXNjIHN0cnVjdHVyZSBmb3IgYSB0ZW1wb3Jh
cnkgb25lIHRoYXQgcmVwcmVzZW50cyB0aGUgNjRiaXQKdmVyc2lvbiwgYW5kIG1ha2UgaXQgY29t
cGxldGVseSB0cmFuc3BhcmVudC4KCkknbSBzdXJlIHRoZXJlIGlzIGEgY291cGxlIG9mIG5pdHMg
YXJvdW5kIHRoYXQgdGhvdWdoLi4uCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4g
SXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
