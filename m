Return-Path: <SRS0=68gc=DW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937B4C43457
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 10:20:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A622D22249
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 10:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vfk4vVOP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A622D22249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17EFE4B2A4;
	Thu, 15 Oct 2020 06:20:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UoNaRJZ5583t; Thu, 15 Oct 2020 06:20:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 071E34B2A9;
	Thu, 15 Oct 2020 06:20:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D9984B2A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 06:19:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uQD0a-gZ-RhM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2020 06:19:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 014CB4B2DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 06:19:57 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7F51820BED;
 Thu, 15 Oct 2020 10:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1602757196;
 bh=gtTafKXnUWUwuBM2IlH8kZC3U5UdmZisqVzbrRgzPqc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Vfk4vVOP1tXrbrSQBBgMoMBOhzoQhMApoNie+DbRcWaKJueSJIrXZV3vJJOjZfJym
 aqU+Q9cY4jjAK7UAKk7vauue4eKTfujm44s+qlhR+FteU6UxSc9e07pUYzepJ7ESXA
 L6Xxf/mgnnkF7WKUhi847yGsEvkpKSWWKnu9KVF0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kT0MU-001M4h-Dc; Thu, 15 Oct 2020 11:19:54 +0100
MIME-Version: 1.0
Date: Thu, 15 Oct 2020 11:19:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: Roja malarvathi <reswara1@binghamton.edu>
Subject: Re: Regarding Timer Interrupt Latency - ARM64 Guest
In-Reply-To: <56798E8F-A2D0-45CE-ABEF-6EF716103B15@hxcore.ol>
References: <56798E8F-A2D0-45CE-ABEF-6EF716103B15@hxcore.ol>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <e24dbc621756b07af01bc07b6bef6d80@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reswara1@binghamton.edu, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

Um9qYSwKCk9uIDIwMjAtMTAtMTUgMDQ6MjYsIFJvamEgbWFsYXJ2YXRoaSB3cm90ZToKPiBIZWxs
bywKPiAKPiBGaXJzdCBvZiBhbGwsIFRoYW5rIHlvdSBzbyBtdWNoIGZvciB0aGUgaGVscCBpbiBh
ZHZhbmNlLgo+IAo+IFdlIHdyb3RlIG91ciBvd24gS2VybmVsIExldmVsIFRpbWVyIEludGVycnVw
dCBMYXRlbmN5IHRlc3QgYW5kIHJhbiBvbgo+IEFSTTguMi4gVGhlIE1lZGlhbiBsYXRlbmN5IHZh
bHVlLCB3aGVuIHJhbiBvbiBndWVzdHMgaXMgYXJvdW5kIDMwIOKAkwo+IDM1IHVzLgo+IAo+IEd1
ZXN0IEtlcm5lbC1WZXJzaW9uOiA1Ljkgd2l0aCBWSEUgZW5hYmxlZCBvbiBIb3N0Lgo+IAo+IENh
biBhbnlvbmUgbGV0IG1lIGtub3cgd2hhdCBzaG91bGQgYmUgYW4gZXhwZWN0ZWQgdGltZXIgaW50
ZXJydXB0Cj4gbGF0ZW5jeSByYW5nZSBmb3IgR3Vlc3Q/CgpXaXRob3V0IHlvdSBzaGFyaW5nIHNo
YXJpbmcgdGhlIHRlc3QgaGFybmVzcywgbm9yIGRpc2Nsb3NpbmcgdGhlCmV4YWN0IEhXIHRoaXMg
cnVucywgdGhlIGhvc3QgY29uZmlndXJhdGlvbiBhbmQgd2hhdCBydW5zIG9uIHRoZQpzeXN0ZW0g
YXQgdGhlIHNhbWUgdGltZSwgaXQgaXMgcHJldHR5IGhhcmQgdG8gZ3Vlc3Mgd2hhdCBjb25zdGl0
dXRlCmFuICJleHBlY3RlZCIgbGF0ZW5jeS4KCkEgbXVjaCBtb3JlIGludGVyZXN0aW5nIG1ldHJp
YyBpcyB0aGUgb3ZlcmhlYWQgb2YgdmlydHVhbGl6YXRpb24sCndoaWNoIHlvdSBjYW4gZGVyaXZl
IGJ5IHJ1bm5pbmcgdGhlIHNhbWUgdGVzdCBvbiB0aGUgaG9zdC4KCiAgICAgICAgIE0uCi0tIApK
YXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
