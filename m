Return-Path: <SRS0=uwID=3F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443E1C33CB1
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 10:48:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF16B205F4
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 10:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="y36CublJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF16B205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4634B11B;
	Thu, 16 Jan 2020 05:48:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id llUO7wMb2oFh; Thu, 16 Jan 2020 05:47:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A984B120;
	Thu, 16 Jan 2020 05:47:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B46D4B118
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 05:47:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RTXbW6NFHQQ0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jan 2020 05:47:52 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 440DB4B0F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 05:47:52 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0B05E205F4;
 Thu, 16 Jan 2020 10:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579171671;
 bh=UdGMbdry9FO+CwnA8duoUtdCiqKW74vOro3QldKWGEI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=y36CublJYdb+gAUpr1THN6gtFzA+rYFet1+/+lybPdjg6sLMXpBBL6D3u6KwwNEyM
 Ty1MZot+GXFlhVjv0StXKTYDaTI0MCSBXpgiY25epD02ZX4JtS46YkvuFR1CDQSq84
 Ev3zkc60gd+jqw8BGBDcuH7pHwVmB8/64mcreyL0=
Date: Thu, 16 Jan 2020 10:47:46 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 0/3] arm64: Workaround for Cortex-A55 erratum 1530923
Message-ID: <20200116104746.GB14761@willie-the-truck>
References: <20191216115631.17804-1-steven.price@arm.com>
 <20200114164543.GD2579@willie-the-truck>
 <3292551ef07b2c5354d48faedad849ff@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3292551ef07b2c5354d48faedad849ff@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Steven Price <steven.price@arm.com>
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

On Thu, Jan 16, 2020 at 07:28:49AM +0000, Marc Zyngier wrote:
> On 2020-01-14 16:45, Will Deacon wrote:
> > On Mon, Dec 16, 2019 at 11:56:28AM +0000, Steven Price wrote:
> > > Version 5 is a rebasing of version 4 (no changes).
> > > 
> > > This series enables a workaround for Cortex-A55 erratum 1530923. The
> > > erratum potentially allows TLB entries to be allocated as a result
> > > of a
> > > speculative AT instruction. This may happen in the middle of a guest
> > > world switch while the relevant VMSA configuration is in an
> > > inconsistent
> > > state, leading to erroneous content being allocated into TLBs.
> > > 
> > > There are existing workarounds for similar issues, 1165522 is
> > > effectively the same, and 1319367/1319537 is similar but without VHE
> > > support.  Rather than add to the selection of errata, the first patch
> > > renames 1165522 to WORKAROUND_SPECULATIVE_AT which can be reused (in
> > > the
> > > final patch) for 1530923.
> > > 
> > > The workaround for errata 1319367 and 1319537 although similar cannot
> > > use VHE (not available on those CPUs) so cannot share the workaround.
> > > However, to keep some sense of symmetry the workaround is renamed to
> > > SPECULATIVE_AT_NVHE.
> > > 
> > > Changes since v4:
> > >  * Rebased to v5.5-rc1
> > 
> > Looks fine to me. Marc, are you ok with me queueing this via arm64
> > (that's
> > where the existing workarounds came from), or would you prefer to take
> > them
> > via kvm-arm?
> 
> Please go ahead and take it (with my ack) via the arm64 tree.

Will do, thanks!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
