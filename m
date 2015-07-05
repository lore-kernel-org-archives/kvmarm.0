From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] arm: KVM: Add VFP lazy switch hooks in Host KVM
Date: Sun, 5 Jul 2015 21:37:45 +0200
Message-ID: <20150705193745.GC3869@cbox>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
 <1435203028-23142-4-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38B3757A32
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 15:26:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jnWDHVba7SKe for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2015 15:26:21 -0400 (EDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A16657A2F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 15:26:20 -0400 (EDT)
Received: by lagh6 with SMTP id h6so132068983lag.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Jul 2015 12:37:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1435203028-23142-4-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 24, 2015 at 08:30:28PM -0700, Mario Smarduch wrote:
> This patch implements host KVM interface to Hyp mode VFP function to 
> switch out guest and switch in host.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/kvm/arm.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d9631ec..77b41f5 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -105,6 +105,17 @@ void kvm_arch_check_processor_compat(void *rtn)
>  	*(int *)rtn = 0;
>  }
>  
> +/**
> + * kvm_switch_vp_regs() - switch guest/host VFP registers
> + * @vcpu:	pointer to vcpu structure.
> + *
> + * HYP interface functions to save guest and restore host VFP registers

Not sure I understand what you mean to say with this line, how about:

Calls an assembly routine in HYP mode to actually perform the state
save/restore.

However, why do we actually need to do this in hyp mode?  Can't we just
as well do this in SVC mode or are we changing some trap settings here?

> + */
> +static void kvm_switch_fp_regs(struct kvm_vcpu *vcpu)

should probalby be called kvm_vcpu_put_fp_regs

> +{
> +	if (vcpu->arch.vfp_guest_saved == 1)
> +		kvm_call_hyp(__kvm_restore_host_vfp_state, vcpu);
> +}
>  
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
> @@ -292,6 +303,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +
> +	/* Check if Guest accessed VFP registers */
> +	kvm_switch_fp_regs(vcpu);
> +
>  	/*
>  	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
>  	 * if the vcpu is no longer assigned to a cpu.  This is used for the
> -- 
> 1.7.9.5

How are we sure that the kernel never touches VFP registers between VCPU
exit and kvm_arch_vcpu_put?  Can a kernel-side memcpy implementation use
the FP regs or something like that?

Thanks,
-Christoffer
