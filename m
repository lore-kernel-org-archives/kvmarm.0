Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE46CC2BB55
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 12:29:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B93C2076C
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 12:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gq2BveZD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B93C2076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D19B94B10A;
	Wed, 15 Apr 2020 08:29:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U8EkHqS2fQ2O; Wed, 15 Apr 2020 08:29:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90D474B116;
	Wed, 15 Apr 2020 08:29:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E864B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 08:29:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aCkWHmDO90Rv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 08:29:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B38624B10A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 08:29:32 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E55AF2074F;
 Wed, 15 Apr 2020 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586953771;
 bh=gHxluNrZU2tTOHcwpOtq2n46qQQhnsi8V7TZgKMK1Ec=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=gq2BveZDD/Gb/fhWrNYUmp9bkKiMRoVR76H1UymoeIJDTW1qzZMFZ4KqJGQiYlRI4
 3LemfZ0UNyfbRFuW4qThg5ia3zMNOvmcfBva2pDMq/CazF1sPRXR9Usvu0d2D0D1Dx
 frs/d28k4Qrk6T3zmCS1b5T9p+dqmMeKPL4aXXJs=
Date: Wed, 15 Apr 2020 13:29:26 +0100
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 7/8] arm64: cpufeature: Relax checks for AArch32 support
 at EL[0-2]
Message-ID: <20200415122926.GA17095@willie-the-truck>
References: <20200414213114.2378-1-will@kernel.org>
 <20200414213114.2378-8-will@kernel.org>
 <714f124c-7eb7-b750-e98c-63da64ddae75@arm.com>
 <20200415105843.GE12621@willie-the-truck>
 <d1f538ec-e956-c136-d0f8-54e7351a28a9@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d1f538ec-e956-c136-d0f8-54e7351a28a9@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: saiprakash.ranjan@codeaurora.org, anshuman.khandual@arm.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, dianders@chromium.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Apr 15, 2020 at 12:37:31PM +0100, Suzuki K Poulose wrote:
> On 04/15/2020 11:58 AM, Will Deacon wrote:
> > On Wed, Apr 15, 2020 at 11:50:58AM +0100, Suzuki K Poulose wrote:
> > > On 04/14/2020 10:31 PM, Will Deacon wrote:
> > > > We don't need to be quite as strict about mismatched AArch32 support,
> > > > which is good because the friendly hardware folks have been busy
> > > > mismatching this to their hearts' content.
> > > > 
> > > >     * We don't care about EL2 or EL3 (there are silly comments concerning
> > > >       the latter, so remove those)
> > > > 
> > > >     * EL1 support is gated by the ARM64_HAS_32BIT_EL1 capability and handled
> > > >       gracefully when a mismatch occurs
> > > > 
> > > >     * EL1 support is gated by the ARM64_HAS_32BIT_EL0 capability and handled
> > > 
> > > s/EL1/EL0
> > > 
> > > >       gracefully when a mismatch occurs
> > > > 
> > > > Relax the AArch32 checks to FTR_NONSTRICT.
> > > 
> > > Agreed. We should do something similar for the features exposed by the
> > > ELF_HWCAP, of course in a separate series.
> > 
> > Hmm, I didn't think we needed to touch the HWCAPs, as they're derived from
> > the sanitised feature register values. What am I missing?
> 
> sorry, that was cryptic. I was suggesting to relax the ftr fields to
> NONSTRICT for the fields covered by ELF HWCAPs (and other CPU hwcaps).

Ah, gotcha. Given that the HWCAPs usually describe EL0 features, I say we
can punt this down the road until people give us hardware with mismatched
AArch32 at EL0.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
