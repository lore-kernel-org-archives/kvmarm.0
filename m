Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB571C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 14:59:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7698A21744
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 14:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJ30eHlk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7698A21744
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01DCF4B72F;
	Tue,  4 Aug 2020 10:59:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HknEyD7L8QVD; Tue,  4 Aug 2020 10:59:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E7334B720;
	Tue,  4 Aug 2020 10:59:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02D104B6F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 10:59:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aEZ+Azqg94kX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 10:59:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B26B4B6F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 10:59:23 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0D07021744;
 Tue,  4 Aug 2020 14:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596553162;
 bh=hDrp69Ge8duBMkXKlFgRT0K7orfs6BfaN5WSuwsDUB4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=nJ30eHlkodMyfOaGw2JuN5oUUBfc8+g3uBJTnq6VlqKGfg4aRAeDP+MX+u10Dp3WF
 Am5DQhU6IR8I7b9M5/v90ZeFupsb76Fv0q70F2ITw2+2grexrARMo5wfJWkR41ZDjp
 xpDUI8XrlHmNucGch9ee8Fn3voT6Cr482Dx6NSrE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k2yPQ-00HPuB-Jj; Tue, 04 Aug 2020 15:59:20 +0100
MIME-Version: 1.0
Date: Tue, 04 Aug 2020 15:59:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-Reply-To: <87r1smmpw5.fsf@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
 <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org> <87r1smmpw5.fsf@linaro.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <b78f8715bbaec8fc728a85d614b00688@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

T24gMjAyMC0wOC0wNCAxNTo0NCwgQWxleCBCZW5uw6llIHdyb3RlOgo+IE1hcmMgWnluZ2llciA8
bWF6QGtlcm5lbC5vcmc+IHdyaXRlczoKPiAKPj4gT24gMjAyMC0wOC0wNCAxMzo0NCwgQWxleCBC
ZW5uw6llIHdyb3RlOgo+Pj4gVGhlIFZJUlRJT19QQ0kgc3VwcG9ydCBpcyBhbiBpZGVhbGlzZWQg
UENJIGJ1cywgd2UgZG9uJ3QgbmVlZCBhIGJ1bmNoCj4+PiBvZiBibG9hdCBmb3IgcmVhbCB3b3Js
ZCBoYXJkd2FyZSBmb3IgYSBWaXJ0SU8gZ3Vlc3QuCj4+IAo+PiBXaG8gc2F5cyB0aGlzIGd1ZXN0
IHdpbGwgb25seSBoYXZlIHZpcnRpbyBkZXZpY2VzPwo+IAo+IFRoaXMgaXMgdHJ1ZSAtIGFsdGhv
dWdoIHdoYXQgaXMgdGhlIHBvaW50IG9mIGt2bV9ndWVzdC5jb25maWc/IFdlCj4gY2VydGFpbmx5
IHR1cm4gb24gYSB3aG9sZSBidW5jaCBvZiB2aXJ0IG9wdGltaXNlZCBwYXRod2F5cyB3aXRoIAo+
IFBBUkFWSVJUCj4gYW5kIEhZUEVSVklTT1JfR1VFU1QgYWxvbmcgd2l0aCB0aGUgcmVzdCBvZiBW
aXJ0SU8uCgpNb3N0IG9mIHdoaWNoIGFjdHVhbGx5IHF1YWxpZmllcyBhcyBibG9hdCBpdHNlbGYg
YXMgZmFyIGFzIEtWTS9hcm02NAppcyBjb25jZXJuZWQuLi4KCiAgICAgICAgICBNLgotLSAKSmF6
eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
