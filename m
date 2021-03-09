Return-Path: <SRS0=aIiX=IH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095C7C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 11:40:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63CBE6525F
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 11:40:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63CBE6525F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDDB24B438;
	Tue,  9 Mar 2021 06:40:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iep6yXo1qv5n; Tue,  9 Mar 2021 06:40:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E8BE4B39F;
	Tue,  9 Mar 2021 06:40:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 111BA4B39F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 06:40:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cf86+Y7My+95 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 06:40:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EC394B392
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 06:40:39 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED6365256;
 Tue,  9 Mar 2021 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615290037;
 bh=Nzz2M6AplgH6sqJ1uLdq6POaRuNHG79f8esG/LsBO9g=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hwbDJ2WeE/PHt7yIerwSzElvCp50W3J8vS2zCZtNk15TNQvVP0ZDtJJnJ5oWXWhW2
 JtGfriFDyGa/xtB62mO3JJzb4xYt11oifKHWKIuDqKwhR5WQoIJJnjvi/P945aFGR6
 etxXfxuHYUMRiua/Uuo9n5C2fg1zrQXqGrirgx8us8DI6cPmWBOwsWTHFCaSssNyYK
 7DuRwnIOgLOgAfJ0JOJUhdK5/oJwpU2LuKC4mBNzrSlYDfpQEAR7tbLVWndIdFalol
 TtpVZPiSeF3YlgOD4TkAplAup7ifA/q/3VueGfo6vfBwawW9lXxSDlmFPTwh96QmGb
 1VTVO67ksG89g==
Date: Tue, 9 Mar 2021 11:40:32 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
Message-ID: <20210309114031.GA28091@willie-the-truck>
References: <20210308174643.761100-1-maz@kernel.org>
 <20210309112658.GA28025@willie-the-truck>
 <87o8fsy2xx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87o8fsy2xx.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 09, 2021 at 11:35:54AM +0000, Marc Zyngier wrote:
> On Tue, 09 Mar 2021 11:26:59 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Mon, Mar 08, 2021 at 05:46:43PM +0000, Marc Zyngier wrote:
> > > KVM/arm64 has forever used a 40bit default IPA space, partially
> > > due to its 32bit heritage (where the only choice is 40bit).
> > > 
> > > However, there are implementations in the wild that have a *cough*
> > > much smaller *cough* IPA space, which leads to a misprogramming of
> > > VTCR_EL2, and a guest that is stuck on its first memory access
> > > if userspace dares to ask for the default IPA setting (which most
> > > VMMs do).
> > > 
> > > Instead, cap the default IPA size to what the host can actually
> > > do, and spit out a one-off message on the console. The boot warning
> > > is turned into a more meaningfull message, and the new behaviour
> > > is also documented.
> > > 
> > > Although this is a userspace ABI change, it doesn't really change
> > > much for userspace:
> > > 
> > > - the guest couldn't run before this change, while it now has
> > >   a chance to if the memory range fits the reduced IPA space
> > > 
> > > - a memory slot that was accepted because it did fit the default
> > >   IPA space but didn't fit the HW constraints is now properly
> > >   rejected
> > > 
> > > The other thing that's left doing is to convince userspace to
> > > actually use the IPA space setting instead of relying on the
> > > antiquated default.
> > 
> > Is there a way for userspace to discover the default IPA size, or does
> > it have to try setting values until it finds one that sticks?
> 
> Yes, since 233a7cb23531 ("kvm: arm64: Allow tuning the physical
> address size for VM").
> 
> The VMM can issue a KVM_CAP_ARM_VM_IPA_SIZE ioctl(), and get in return
> the maximum IPA size (I have a patch for kvmtool that does this).

Great, thanks -- that's exactly what I was thinking about when I asked the
question!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
