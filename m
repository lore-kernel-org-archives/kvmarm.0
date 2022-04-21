Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665EFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 15:22:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8C34B296;
	Thu, 21 Apr 2022 11:22:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A4n65v36-mdP; Thu, 21 Apr 2022 11:22:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84B864B20B;
	Thu, 21 Apr 2022 11:22:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0794B206
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 11:22:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VWMtMLxDOA2A for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 11:22:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E19E74B10C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 11:22:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EBCC1516;
 Thu, 21 Apr 2022 08:22:06 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEBFF3F73B;
 Thu, 21 Apr 2022 08:22:04 -0700 (PDT)
Date: Thu, 21 Apr 2022 16:22:00 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: uapi: Add kvm_debug_exit_arch.hsr_high
Message-ID: <YmF2mCJaEWFKS3xR@monolith.localdoman>
References: <20220421100547.873761-1-alexandru.elisei@arm.com>
 <20220421100547.873761-6-alexandru.elisei@arm.com>
 <87ee1qa8z7.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ee1qa8z7.wl-maz@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi,

On Thu, Apr 21, 2022 at 01:58:52PM +0100, Marc Zyngier wrote:
> On Thu, 21 Apr 2022 11:05:47 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 93d92130d36c..fd5b6773e3a2 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -121,6 +121,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
> >  
> >  	run->exit_reason = KVM_EXIT_DEBUG;
> >  	run->debug.arch.hsr = lower_32_bits(esr);
> > +	run->debug.arch.hsr_high = upper_32_bits(esr);
> > +	run->flags |= KVM_DEBUG_ARCH_HSR_HIGH_VALID;
> 
> Who will eventually clear this flag? I'm concerned that it could be
> misinterpreted by other userspace paths, as once you get a debug exit
> on this vcpu, it will always be set.
> 
> Probably only a matter of clearing flags on all the other exit paths.

I missed this part, I was under the impression that kvm_run->flags was
already cleared on every exit (that's why it's bitwise OR'ed with the
flag).

kvm_arch_vcpu_ioctl_run() always sets exit_reason = KVM_EXIT_UNKNOWN, so I
guess if we want to be consistent, kvm_run->flags should be cleared at the
same time. Unless you want KVM to clear flags for all exit reasons *except*
KVM_EXIT_UNKNOWN.

I prefer clearing flags in kvm_arch_vcpu_ioctl_run() as that looks to me
like the least error prone way to do it, and if in the future an exit
reason wants to preserve flags across KVM_RUN ioctls we can add a check for
that particular situation.

> 
> Also, please document the flag in the API file (only a couple of x86
> flags are there so far).

Sure thing, will do.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
