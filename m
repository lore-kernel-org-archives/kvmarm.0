Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC86C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 10:31:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B76D82075A
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 10:31:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zOnWcLJT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B76D82075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E5714B9F8;
	Mon, 27 Jul 2020 06:31:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mUQY-2FEb3Gr; Mon, 27 Jul 2020 06:31:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E14D4B9C8;
	Mon, 27 Jul 2020 06:31:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A9B4B9BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 06:31:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3CMtyOCgW78V for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 06:31:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC8324B993
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 06:31:04 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A27192075A;
 Mon, 27 Jul 2020 10:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595845863;
 bh=kCduUPmhmWHrdYHdz4LJj1ElV3O2YJPq+2s+xYu2b2I=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=zOnWcLJTCikTxHLjNWz/REwKd5Q5A2WZ/YUYyV9k5mTkg9z8We49yfNclrRdybrUx
 YK1o2hRF8zVdHaSnePD7V6fxYVxATEX3gNXWVcWgFniuer8L7QhYV2UnjWs5FszJT/
 aBxpLeVVvla2b7JwpqsUah+FI/SmYB4PGYEfm17E=
Date: Mon, 27 Jul 2020 11:30:59 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/7] KVM: arm64: Update comment when skipping guest MMIO
 access instruction
Message-ID: <20200727103059.GC20194@willie-the-truck>
References: <20200724143506.17772-1-will@kernel.org>
 <20200724143506.17772-2-will@kernel.org>
 <87v9iawn2r.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87v9iawn2r.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Sun, Jul 26, 2020 at 12:08:28PM +0100, Marc Zyngier wrote:
> On Fri, 24 Jul 2020 15:35:00 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > If a 32-bit guest accesses MMIO using a 16-bit Thumb-2 instruction that
> > is reported to the hypervisor without a valid syndrom (for example,
> > because of the addressing mode), then we may hand off the fault to
> > userspace. When resuming the guest, we unconditionally advance the PC
> > by 4 bytes, since ESR_EL2.IL is always 1 for data aborts generated without
> > a valid syndrome. This is a bit rubbish, but it's also difficult to see
> > how we can fix it without potentially introducing regressions in userspace
> > MMIO fault handling.
> 
> Not quite, see below.
> 
> > 
> > Update the comment when skipping a guest MMIO access instruction so that
> > this corner case is at least written down.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/mmio.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> > index 4e0366759726..b54ea5aa6c06 100644
> > --- a/arch/arm64/kvm/mmio.c
> > +++ b/arch/arm64/kvm/mmio.c
> > @@ -113,6 +113,13 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  	/*
> >  	 * The MMIO instruction is emulated and should not be re-executed
> >  	 * in the guest.
> > +	 *
> > +	 * Note: If user space handled the emulation because the abort
> > +	 * symdrome information was not valid (ISV set in the ESR), then
> 
> nits: syndrome, ISV *clear*.

Duh, thanks.

> > +	 * this will assume that the faulting instruction was 32-bit.
> > +	 * If the faulting instruction was a 16-bit Thumb instruction,
> > +	 * then userspace would need to rewind the PC by 2 bytes prior to
> > +	 * resuming the vCPU (yuck!).
> >  	 */
> >  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> >  
> 
> That's not how I read it. On ESR_EL2.ISV being clear, and in the
> absence of KVM_CAP_ARM_NISV_TO_USER being set, we return a -ENOSYS from
> io_mem_abort(), exiting back to userspace *without* advertising a MMIO
> access. The VMM is free to do whatever it can to handle it (i.e. not
> much), but crucially we don't go via kvm_handle_mmio_return() on
> resuming the vcpu (unless the VMM sets run->exit_reason to
> KVM_EXIT_MMIO, but that's clearly its own decision).
> 
> Instead, the expectation is that userspace willing to handle an exit
> resulting in ESR_EL2.ISV being clear would instead request a
> KVM_EXIT_ARM_NISV exit type (by enabling KVM_CAP_ARM_NISV_TO_USER),
> getting extra information in the process such as as the fault
> IPA). KVM_EXIT_ARM_NISV clearly states in the documentation:
> 
>   "Note that KVM does not skip the faulting instruction as it does for
>    KVM_EXIT_MMIO, but userspace has to emulate any change to the
>    processing state if it decides to decode and emulate the instruction."

Thanks, I think you're right. I _thought_ we always reported EXIT_MMIO
for write faults on read-only memslots (as per the documented behaviour),
but actually that goes down the io_mem_abort() path too and so the
skipping only ever occurs when the syndrome is valid.

I'll drop this patch.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
