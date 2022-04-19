Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DD8C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 14:59:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEEFA4B24A;
	Tue, 19 Apr 2022 10:59:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 694pc0Lg6pKg; Tue, 19 Apr 2022 10:59:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B9314B1DB;
	Tue, 19 Apr 2022 10:59:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1423C4B162
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 10:59:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cw4yjgMeNCVU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 10:59:52 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D60754B14D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 10:59:52 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E4DAA61584;
 Tue, 19 Apr 2022 14:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DE6C385A5;
 Tue, 19 Apr 2022 14:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650380391;
 bh=zbiEyCDABEq7gEALFHsGMai8bbRwuTs+uaqAyXi/mmk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=n5sUX9M0Lk7mcLME99wlKT3C5TET634hL0AKqxJbK5+AxrhPiTzK14s4DrNyIwUWl
 Kf1HC2hYsRlsgQUdZc/HojmosTleaaCmEdHaZj0MS59WdvDrvHuL7WHrlGDA2YTzZI
 QPB8yHQBgSYGe+OU9fDWFNZxyaFqOhi+Cb+OoqAwTQmyWC6zgAXV5FT1+AAkOVrujp
 Hn9SY1c8XpbYzyS0ezWgvPsL7iP5V6ua5mn9Dovc0TuclAGEIQehgkceay5zGUJcqm
 5ZHrCazuF1VX5CxZpS27H9uunkRcC0OUrToxVFlrhDTgTSgocV0DWY3bDkXkwLUQeu
 r0LIS+myz6YGw==
Date: Tue, 19 Apr 2022 15:59:46 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <20220419145945.GC6186@willie-the-truck>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yl7KewpTj+7NSonf@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yl7KewpTj+7NSonf@monolith.localdoman>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, Apr 19, 2022 at 03:44:02PM +0100, Alexandru Elisei wrote:
> On Tue, Apr 19, 2022 at 03:10:13PM +0100, Will Deacon wrote:
> > On Tue, Apr 19, 2022 at 02:51:05PM +0100, Alexandru Elisei wrote:
> > > 2. The stage 2 fault is reported asynchronously via an interrupt, which
> > > means there will be a window where profiling is stopped from the moment SPE
> > > triggers the fault and when the PE taks the interrupt. This blackout window
> > > is obviously not present when running on bare metal, as there is no second
> > > stage of address translation being performed.
> > 
> > Are these faults actually recoverable? My memory is a bit hazy here, but I
> > thought SPE buffer data could be written out in whacky ways such that even
> > a bog-standard page fault could result in uncoverable data loss (i.e. DL=1),
> > and so pinning is the only game in town.
> 
> Ah, I forgot about that, I think you're right (ARM DDI 0487H.a, page
> D10-5177):
> 
> "The architecture does not require that a sample record is written
> sequentially by the SPU, only that:
> [..]
> - On a Profiling Buffer management interrupt, PMBSR_EL1.DL indicates
>   whether PMBPTR_EL1 points to the first byte after the last complete
>   sample record.
> - On an MMU fault or synchronous External abort, PMBPTR_EL1 serves as a
>   Fault Address Register."
> 
> and (page D10-5179):
> 
> "If a write to the Profiling Buffer generates a fault and PMBSR_EL1.S is 0,
> then a Profiling Buffer management event is generated:
> [..]
> - If PMBPTR_EL1 is not the address of the first byte after the last
>   complete sample record written by the SPU, then PMBSR_EL1.DL is set to 1.
>   Otherwise, PMBSR_EL1.DL is unchanged."
> 
> Since there is no way to know the record size (well, unless
> PMSIDR_EL1.MaxSize == PMBIDR_EL1.Align, but that's not an architectural
> requirement), it means that KVM cannot restore the write pointer to the
> address of the last complete record + 1, to allow the guest to resume
> profiling without corrupted records.
> 
> > 
> > A funkier approach might be to defer pinning of the buffer until the SPE is
> > enabled and avoid pinning all of VM memory that way, although I can't
> > immediately tell how flexible the architecture is in allowing you to cache
> > the base/limit values.
> 
> A guest can use this to pin the VM memory (or a significant part of it),
> either by doing it on purpose, or by allocating new buffers as they get
> full. This will probably result in KVM killing the VM if the pinned memory
> is larger than ulimit's max locked memory, which I believe is going to be a
> bad experience for the user caught unaware. Unless we don't want KVM to
> take ulimit into account when pinning the memory, which as far as I can
> goes against KVM's approach so far.

Yeah, it gets pretty messy and ulimit definitely needs to be taken into
account, as it is today.

That said, we could just continue if the pinning fails and the guest gets to
keep the pieces if we get a stage-2 fault -- putting the device into an
error state and re-injecting the interrupt should cause the perf session in
the guest to fail gracefully. I don't think the complexity is necessarily
worth it, but pinning all of guest memory is really crap so it's worth
thinking about alternatives.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
