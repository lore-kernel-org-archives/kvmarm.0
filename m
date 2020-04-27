Return-Path: <SRS0=evlJ=6L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74038C54FCB
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 16:49:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F40312080C
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 16:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOIirCPK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F40312080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 917C64B09E;
	Mon, 27 Apr 2020 12:49:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T3CLVO0iTH3l; Mon, 27 Apr 2020 12:49:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D904B117;
	Mon, 27 Apr 2020 12:49:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CA3C4B114
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 12:49:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hCPycC5XODC4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2020 12:49:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 346E54B09E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2020 12:49:52 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 07B742078E;
 Mon, 27 Apr 2020 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588006191;
 bh=jQ0KWWZhLYMByhegFoIiVPOZdGk0Lzl4q7rMMcBmaew=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=mOIirCPKrFvI4awGm7xtERC/1d+1IFdK9FBuJhvAwXVySQ6LtQOVV3941dL88nHln
 oPon4b0PTqtO0zEbbez/LxcvR5zQJZEss/YQkxoUjDL4VVdWlJ5sHqC5/9CyDhSBvL
 AY2QX+K9rJ4UMv2Vu2x1pstXgUgGx3aJduDVdEj8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jT6x3-006mzt-Ds; Mon, 27 Apr 2020 17:49:49 +0100
MIME-Version: 1.0
Date: Mon, 27 Apr 2020 17:49:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH][kvmtool] kvm: Request VM specific limits instead of
 system-wide ones
In-Reply-To: <c36c30b1-6017-9c75-e0e9-e643eb348641@arm.com>
References: <20200427141738.285217-1-maz@kernel.org>
 <c36c30b1-6017-9c75-e0e9-e643eb348641@arm.com>
Message-ID: <3886cae6b5e7e1fc9ab821f1d734036f@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, will@kernel.org, ardb@kernel.org,
 Alexandru.Elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

T24gMjAyMC0wNC0yNyAxNjozNywgQW5kcsOpIFByenl3YXJhIHdyb3RlOgo+IE9uIDI3LzA0LzIw
MjAgMTU6MTcsIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSwKPiAKPj4gT24gYXJtNjQsIHRoZSBt
YXhpbXVtIG51bWJlciBvZiB2Y3B1cyBpcyBjb25zdHJhaW5lZCBieSB0aGUgdHlwZQo+PiBvZiBp
bnRlcnJ1cHQgY29udHJvbGxlciB0aGF0IGhhcyBiZWVuIHNlbGVjdGVkIChHSUN2MiBpbXBvc2Vz
IGEKPj4gbGltaXQgb2YgOCB2Y3B1cywgd2hpbGUgR0lDdjMgY3VycmVudGx5IGhhcyBhIGxpbWl0
IG9mIDUxMikuCj4+IAo+PiBJdCBpcyB0aHVzIGltcG9ydGFudCB0byByZXF1ZXN0IHRoaXMgbGlt
aXQgb24gdGhlIFZNIGZpbGUgZGVzY3JpcHRvcgo+PiByYXRoZXIgdGhhbiBvbiB0aGUgb25lIHRo
YXQgY29ycmVzcG9uZHMgdG8gL2Rldi9rdm0sIGFzIHRoZSBsYXR0ZXIKPj4gaXMgbGlrZWx5IHRv
IHJldHVybiBzb21ldGhpbmcgdGhhdCBkb2Vzbid0IHRha2UgdGhlIGNvbnN0cmFpbnRzIGludG8K
Pj4gYWNjb3VudC4KPiAKPiBUaGF0IHNvdW5kcyByZWFzb25hYmxlLCBidXQgSSBmYWlsIHRvIGZp
bmQgYW55IGRpc3RpbmN0aW9uIGluIHRoZSAKPiBrZXJuZWwKPiBjb2RlLiBXZSBkb24ndCBtYWtl
IGFueSBkaWZmZXJlbmNlIGJldHdlZW4gdGhlIFZNIG9yIHRoZSBzeXN0ZW0gRkQgaW4KPiB0aGUg
aW9jdGwgaGFuZGxlciBmb3IgdGhvc2UgdHdvIGV4dGVuc2lvbnMuIEZvciBhcm02NCB3ZSBhbHdh
eXMgcmV0dXJuCj4gbWF4LiA1MTIgKG1heCBWQ1BVcyBvbiBHSUN2MyksIGFuZCBudW1iZXIgb2Yg
b25saW5lIGhvc3QgY29yZXMgZm9yIHRoZQo+IHJlY29tbWVuZGVkIHZhbHVlLiBGb3IgYXJtIHRo
ZXJlIHdhcyBhIGRpc3RpbmN0aW9uIGJldHdlZW4gR0lDdjMgCj4gc3VwcG9ydAo+IGNvbXBpbGVk
IGluIG9yIG5vdCwgYnV0IG90aGVyd2lzZSB0aGUgc2FtZSBjb25zdGFudCB2YWx1ZXMgcmV0dXJu
ZWQuCj4gUXVpY2tseSB0ZXN0ZWQgb24gSnVubyBhbmQgTjFTRFAsIHRoZSBpb2N0bHMgcmV0dXJu
IHRoZSBzYW1lIGV4cGVjdGVkCj4gdmFsdWVzLCByZWdhcmRsZXNzIG9mIHN5c19mZCB2cyB2bV9m
ZC4KPiAKPiBTbyB3aGF0IGFtIEkgbWlzc2luZyBoZXJlPyBJcyB0aGlzIGZvciBzb21lIG9sZGVy
IG9yIGV2ZW4gbmV3ZXIgCj4ga2VybmVscz8KCllvdSdyZSBtaXNzaW5nIHRoaXM6CgpodHRwczov
L2xvcmUua2VybmVsLm9yZy9rdm0vMjAyMDA0MjcxNDE1MDcuMjg0OTg1LTEtbWF6QGtlcm5lbC5v
cmcvCgp3aGljaCBhZGRzIHRoZSBtaXNzaW5nIGJpdHMgdG8gdGhlIGtlcm5lbC4KClRoYW5rcywK
CiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4u
LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
