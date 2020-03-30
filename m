Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB20C43331
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:07:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06548206E6
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:07:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wClKUSSv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06548206E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C24A4B266;
	Mon, 30 Mar 2020 06:07:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OHdeghp+OfSO; Mon, 30 Mar 2020 06:07:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8313E4B267;
	Mon, 30 Mar 2020 06:07:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 980B14B265
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:07:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lSbdrK4Ouh67 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 06:07:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 972C74B264
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:07:03 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 880C8206E6;
 Mon, 30 Mar 2020 10:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585562822;
 bh=h4qbQIcArDQKLVxSHZ660Oqw2KCSJQGGsVkBmaTHQ0w=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=wClKUSSvJbnHpHTob7e+OhS/k//P7QjJb9xKePMT40YYhG574py/O52JUYdQvR984
 RSJN8QUIHaKKoim4NhZYQDRLFD4HIs9josgwBffZlnB6RcWswVrtoIudL01kGsVnk+
 sxtNFsgaGmxH2qyRyIjpx9mjJ/v1jdfmerySiUaA=
Date: Mon, 30 Mar 2020 11:06:57 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH] arm64: unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
Message-ID: <20200330100656.GA8365@willie-the-truck>
References: <20200327143941.195626-1-ascull@google.com>
 <1705907b-234c-6f56-1360-f598c8047d1d@arm.com>
 <20200327174838.GD178422@google.com>
 <e280f3f31bd5edc9db55757fcfa4ec62@kernel.org>
 <20200327180913.GA10454@willie-the-truck>
 <20200328112351.53f800ed@why>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200328112351.53f800ed@why>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: qwandor@google.com, tabba@google.com, Steven Price <steven.price@arm.com>,
 wedsonaf@google.com, dbrazdil@google.com, kernel-team@android.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sat, Mar 28, 2020 at 11:23:51AM +0000, Marc Zyngier wrote:
> On Fri, 27 Mar 2020 18:09:14 +0000
> Will Deacon <will@kernel.org> wrote:
> 
> > On Fri, Mar 27, 2020 at 05:52:59PM +0000, Marc Zyngier wrote:
> > > On 2020-03-27 17:48, Andrew Scull wrote:  
> > > > Thanks, Steven. Could we look into the EPD* caching microarch details
> > > > Marc was referring to for these A55 and A76 cores?  
> > > 
> > > Only the folks that have access to the RTL can tell you, unfortunately.
> > > 
> > > Thankfully, there is a bunch of people on Cc that should be able to ping
> > > the relevant teams and report back...  
> > 
> > Yup, otherwise I guess we can throw in the TLB invalidation after setting
> > the EPDx bits until we have clarity from Arm. We wouldn't need to broadcast
> > it, so it might not be too bad on performance. If it is, I suppose we could
> > switch to a reserved VMID?
> 
> I'd like to avoid the reserved VMID if at all possible -- we already
> have one for the host on nVHE, and I bet your patches are going to
> create some interesting havoc^Wchanges in that area, as the host is now
> a guest from the mm perspective. It isn't clear either whether a
> reserved VMID really solves the problem either, as you could still
> end-up with speculative PTWs. Can it be harmful to create conflicting
> TLB entries if you never hit them?

I think you'd have to ensure that the reserved VMID is only ever used when
the EPDx bits are set, which is easy to say but harder to enforce!

> But if we bring in TLB invalidation, I wonder whether the problem can
> be mitigated solely with just that on the affected CPUs, and what the
> impact would be.

It seems as though this erratum is quietly cropping up for other CPUs (e.g.
A53 and A77) as well, so I'd be inclined to add the local TLBI and then
Arm can do the uarch work to disable it if it's worth it. Interestingly,
I think you only need the invalidation on the __deactivate_traps_nvhe()
path, because the CPU is only permitted to cache those bits when they are
0 (strange but true!).

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
