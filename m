From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: Ensure LRs are clear when they should be
Date: Sat, 18 Mar 2017 14:07:47 +0000
Message-ID: <874lyqsmoc.fsf@on-the-bus.cambridge.arm.com>
References: <20170318125656.16523-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB2040BBC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Mar 2017 10:06:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OfvE0TouDdaa for <kvmarm@lists.cs.columbia.edu>;
 Sat, 18 Mar 2017 10:06:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 170A340A95
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Mar 2017 10:06:14 -0400 (EDT)
In-Reply-To: <20170318125656.16523-1-cdall@linaro.org> (Christoffer Dall's
 message of "Sat, 18 Mar 2017 13:56:56 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 18 2017 at 12:56:56 pm GMT, Christoffer Dall <cdall@linaro.org> wrote:

Hi Christoffer,

> From: Christoffer Dall <christoffer.dall@linaro.org>
>
> We currently have some code to clear the list registers on GICv3, but we
> never call this code, because the caller got nuked when removing the old
> vgic.  We also used to have a similar GICv2 part, but that got lost in
> the process too.
>
> Let's reintroduce the logic for GICv2 and call the logic when we
> initialize the use of hypervisors on the CPU, for example when first
> loading KVM or when exiting a low power state.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Marc, Eric, Andre,
>
> I'm unable to convince myself that the LRs should already be clear via
> the reset of the hardware, and for any power management scenario I
> suppose it's possible for secure-side firmware to have messed with the
> LRs behind our backs; plus we used to have this functionality and it got
> dropped for the new vgic.  Am I forgetting some discussion where we
> decided it wasn't needed anymore?

No, that's definitely something we overlooked while transitioning from
one implementation to another. Thanks for noticing it!

>
> Thanks,
> -Christoffer
>
>  arch/arm/kvm/arm.c            |  3 +++
>  include/kvm/arm_vgic.h        |  1 +
>  virt/kvm/arm/vgic/vgic-init.c | 19 +++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v2.c   | 15 +++++++++++++++
>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>  5 files changed, 40 insertions(+)
>
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index c9a2103..d775aac 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -1121,6 +1121,9 @@ static void cpu_hyp_reinit(void)
>  		if (__hyp_get_vectors() == hyp_default_vectors)
>  			cpu_init_hyp_mode(NULL);
>  	}
> +
> +	if (vgic_present)
> +		kvm_vgic_init_cpu_hardware();

We didn't have this before, but that's certainly an improvement. It is
not so much that secure could have messed with the LRs themselves, but
that the LRs reset value is UNDEF out of reset.

>  }
>  
>  static void cpu_hyp_reset(void)
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index b72dd2a..c0b3d99 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -295,6 +295,7 @@ void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
>  void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
>  int kvm_vgic_map_resources(struct kvm *kvm);
>  int kvm_vgic_hyp_init(void);
> +void kvm_vgic_init_cpu_hardware(void);
>  
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 276139a..702f810 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -392,6 +392,25 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
>  }
>  
>  /**
> + * kvm_vgic_init_cpu_hardware - initialize the GIC VE hardware
> + *
> + * For a specific CPU, initialize the GIC VE hardware.
> + */
> +void kvm_vgic_init_cpu_hardware(void)
> +{
> +	BUG_ON(preemptible());
> +
> +	/*
> +	 * We want to make sure the list registers start out clear so that we
> +	 * only have the program the used registers.
> +	 */
> +	if (kvm_vgic_global_state.type == VGIC_V2)
> +		vgic_v2_init_lrs();
> +	else
> +		kvm_call_hyp(__vgic_v3_init_lrs);
> +}
> +
> +/**
>   * kvm_vgic_hyp_init: populates the kvm_vgic_global_state variable
>   * according to the host GIC model. Accordingly calls either
>   * vgic_v2/v3_probe which registers the KVM_DEVICE that can be
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index b834ecd..94cf4b9 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -36,6 +36,21 @@ static unsigned long *u64_to_bitmask(u64 *val)
>  	return (unsigned long *)val;
>  }
>  
> +static inline void vgic_v2_write_lr(int lr, u32 val)
> +{
> +	void __iomem *base = kvm_vgic_global_state.vctrl_base;
> +
> +	writel_relaxed(val, base + GICH_LR0 + (lr * 4));
> +}
> +
> +void vgic_v2_init_lrs(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++)
> +		vgic_v2_write_lr(i, 0);
> +}

Nit: do you need to have two functions here? Or is that something that
you're going to reuse in the near future?

> +
>  void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index db28f7c..91566f5 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -130,6 +130,8 @@ int vgic_v2_map_resources(struct kvm *kvm);
>  int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
>  			     enum vgic_type);
>  
> +void vgic_v2_init_lrs(void);
> +
>  static inline void vgic_get_irq_kref(struct vgic_irq *irq)
>  {
>  	if (irq->intid < VGIC_MIN_LPI)

Looks good to me!

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
