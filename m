From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 3/3] KVM: arm64: Optimise FPSIMD handling to
 reduce guest/host thrashing
Date: Mon, 9 Apr 2018 11:55:08 +0100
Message-ID: <20180409105507.GU16308@e103592.cambridge.arm.com>
References: <1523026864-15413-1-git-send-email-Dave.Martin@arm.com>
 <1523026864-15413-4-git-send-email-Dave.Martin@arm.com>
 <86tvsnqr3l.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE364A03B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Apr 2018 06:46:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vhSjhH0AqKzq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Apr 2018 06:46:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F6D4A095
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Apr 2018 06:46:30 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <86tvsnqr3l.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Apr 07, 2018 at 10:54:22AM +0100, Marc Zyngier wrote:
> On Fri, 06 Apr 2018 16:01:04 +0100,
> Dave Martin wrote:
> 
> Hi Dave,
> 
> > 
> > This patch refactors KVM to align the host and guest FPSIMD
> > save/restore logic with each other for arm64.  This reduces the
> > number of redundant save/restore operations that must occur, and
> > reduces the common-case IRQ blackout time during guest exit storms
> > by saving the host state lazily and optimising away the need to
> > restore the host state before returning to the run loop.
> > 
> > Four hooks are defined in order to enable this:
> > 
> >  * kvm_arch_vcpu_run_map_fp():
> >    Called on PID change to map necessary bits of current to Hyp.
> > 
> >  * kvm_arch_vcpu_load_fp():
> >    Set up FP/SIMD for entering the KVM run loop (parse as
> >    "vcpu_load fp").
> > 
> >  * kvm_arch_vcpu_park_fp():
> >    Get FP/SIMD into a safe state for re-enabling interrupts after a
> >    guest exit back to the run loop.
> 
> It would be good if you could outline what this hook does, and what
> "safe state" means in this context.

[...]

> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index d3af3f4..cf0f457 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -362,10 +362,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  	kvm_arm_set_running_vcpu(vcpu);
> >  	kvm_vgic_load(vcpu);
> >  	kvm_timer_vcpu_load(vcpu);
> > +	kvm_arch_vcpu_load_fp(vcpu);
> 
> Can't find this function.

[...]

> > @@ -772,6 +774,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		if (static_branch_unlikely(&userspace_irqchip_in_use))
> >  			kvm_timer_sync_hwstate(vcpu);
> >  
> > +		kvm_arch_vcpu_park_fp(vcpu);
> 
> This isn't defined either. I have the feeling that you've missed a
> "git add" at some point.
> 
> > +
> >  		/*
> >  		 * We may have taken a host interrupt in HYP mode (ie
> >  		 * while executing the guest). This interrupt is still
> > @@ -816,16 +820,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  	return ret;
> >  }

[...]

> The structure seems quite sensible, and I'm looking forward to seeing
> the missing bits. Also, it looks like this was done on top of
> 4.16. I'm afraid 4.17 is going to bring a number of conflicts, but
> nothing that should have any material impact.

Hmmm, looks like I dropped an added file when flattening my draft series.

See separate repost -- sorry about that.


I've kept it on v4.16 just while things stabilise.

Cheers
---Dave
