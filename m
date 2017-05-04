From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: Allow setting the timer IRQ numbers
 from userspace
Date: Thu, 4 May 2017 10:34:32 +0100
Message-ID: <b08c50b4-6aba-1a59-80f4-343cd906f1fa@arm.com>
References: <20170503183300.4618-1-cdall@linaro.org>
 <20170503183300.4618-6-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4834840BBC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 05:31:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qxvWk2tcBM-R for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 05:31:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8852540190
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 05:31:29 -0400 (EDT)
In-Reply-To: <20170503183300.4618-6-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/05/17 19:33, Christoffer Dall wrote:
> First we define an ABI using the vcpu devices that lets userspace set
> the interrupt numbers for the various timers on both the 32-bit and
> 64-bit KVM/ARM implementations.
> 
> Second, we add the definitions for the groups and attributes introduced
> by the above ABI.  (We add the PMU define on the 32-bit side as well for
> symmetry and it may get used some day.)
> 
> Third, we set up the arch-specific vcpu device operation handlers to
> call into the timer code for anything related to the
> KVM_ARM_VCPU_TIMER_CTRL group.
> 
> Fourth, we implement support for getting and setting the timer interrupt
> numbers using the above defined ABI in the arch timer code.
> 
> Fifth, we introduce error checking upon enabling the arch timer (which
> is called when first running a VCPU) to check that all VCPUs are
> configured to use the same PPI for the timer (as mandated by the
> architecture) and that the virtual and physical timers are not
> configured to use the same IRQ number.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  Documentation/virtual/kvm/devices/vcpu.txt |  25 +++++++
>  arch/arm/include/uapi/asm/kvm.h            |   8 +++
>  arch/arm/kvm/guest.c                       |   9 +++
>  arch/arm64/include/uapi/asm/kvm.h          |   3 +
>  arch/arm64/kvm/guest.c                     |   9 +++
>  include/kvm/arm_arch_timer.h               |   4 ++
>  virt/kvm/arm/arch_timer.c                  | 104 +++++++++++++++++++++++++++++
>  7 files changed, 162 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
> index 352af6e..013e3f1 100644
> --- a/Documentation/virtual/kvm/devices/vcpu.txt
> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
> @@ -35,3 +35,28 @@ Returns: -ENODEV: PMUv3 not supported or GIC not initialized
>  Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
>  virtual GIC implementation, this must be done after initializing the in-kernel
>  irqchip.
> +
> +
> +2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
> +Architectures: ARM,ARM64
> +
> +2.1. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_VTIMER
> +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_PTIMER
> +Parameters: in kvm_device_attr.addr the address for the timer interrupt is a
> +            pointer to an int
> +Returns: -EINVAL: Invalid timer interrupt number
> +         -EBUSY:  One or more VCPUs has already run
> +
> +A value describing the architected timer interrupt number when connected to an
> +in-kernel virtual GIC.  These must be a PPI (16 <= intid < 32).  If an
> +attribute is not set, a default value is applied (see below).
> +
> +KVM_ARM_VCPU_TIMER_IRQ_VTIMER: The EL1 virtual timer intid (default: 27)
> +KVM_ARM_VCPU_TIMER_IRQ_PTIMER: The EL1 physical timer intid (default: 30)

uber nit: my reading of the code is that the default is set at VCPU
creation time. So setting the attribute overrides the default, not that
the default is applied if no attribute is set (i.e. there is always a
valid value).

> +
> +Setting the same PPI for different timers will prevent the VCPUs from running.
> +Setting the interrupt number on a VCPU configures all VCPUs created at that
> +time to use the number provided for a given timer, overwriting any previously
> +configured values on other VCPUs.  Userspace should configure the interrupt
> +numbers on at least one VCPU after creating all VCPUs and before running any
> +VCPUs.
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index a5838d6..6a75ec4 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -200,6 +200,14 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
>  #define VGIC_LEVEL_INFO_LINE_LEVEL	0
>  
> +/* Device Control API on vcpu fd */
> +#define KVM_ARM_VCPU_PMU_V3_CTRL	0
> +#define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> +#define   KVM_ARM_VCPU_PMU_V3_INIT	1
> +#define KVM_ARM_VCPU_TIMER_CTRL		1
> +#define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
> +#define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> +
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
>  
>  /* KVM_IRQ_LINE irq field index values */
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index acea05e..1e0784e 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -308,6 +308,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  	int ret;
>  
>  	switch (attr->group) {
> +	case KVM_ARM_VCPU_TIMER_CTRL:
> +		ret = kvm_arm_timer_set_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -322,6 +325,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>  	int ret;
>  
>  	switch (attr->group) {
> +	case KVM_ARM_VCPU_TIMER_CTRL:
> +		ret = kvm_arm_timer_get_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -336,6 +342,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  	int ret;
>  
>  	switch (attr->group) {
> +	case KVM_ARM_VCPU_TIMER_CTRL:
> +		ret = kvm_arm_timer_has_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index cd6bea4..fc64518 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -226,6 +226,9 @@ struct kvm_arch_memory_slot {
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>  #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
>  #define   KVM_ARM_VCPU_PMU_V3_INIT	1
> +#define KVM_ARM_VCPU_TIMER_CTRL		1
> +#define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
> +#define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
>  
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index b37446a..5c7f657 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -390,6 +390,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  	case KVM_ARM_VCPU_PMU_V3_CTRL:
>  		ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
>  		break;
> +	case KVM_ARM_VCPU_TIMER_CTRL:
> +		ret = kvm_arm_timer_set_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -407,6 +410,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>  	case KVM_ARM_VCPU_PMU_V3_CTRL:
>  		ret = kvm_arm_pmu_v3_get_attr(vcpu, attr);
>  		break;
> +	case KVM_ARM_VCPU_TIMER_CTRL:
> +		ret = kvm_arm_timer_get_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> @@ -424,6 +430,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  	case KVM_ARM_VCPU_PMU_V3_CTRL:
>  		ret = kvm_arm_pmu_v3_has_attr(vcpu, attr);
>  		break;
> +	case KVM_ARM_VCPU_TIMER_CTRL:
> +		ret = kvm_arm_timer_has_attr(vcpu, attr);
> +		break;
>  	default:
>  		ret = -ENXIO;
>  		break;
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index f1c967a..f0053f8 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -68,6 +68,10 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
>  u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
>  int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
>  
> +int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> +int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> +int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> +
>  bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
>  void kvm_timer_schedule(struct kvm_vcpu *vcpu);
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 6c5a064..d3d1dce 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -21,6 +21,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
> +#include <linux/uaccess.h>
>  
>  #include <clocksource/arm_arch_timer.h>
>  #include <asm/arch_timer.h>
> @@ -617,6 +618,28 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
>  	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
>  }
>  
> +static bool timer_irqs_are_valid(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int vtimer_irq, ptimer_irq;
> +	int i;
> +
> +	vcpu = kvm_get_vcpu(kvm, 0);
> +	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
> +	ptimer_irq = vcpu_ptimer(vcpu)->irq.irq;
> +
> +	if (vtimer_irq == ptimer_irq)
> +		return false;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu_vtimer(vcpu)->irq.irq != vtimer_irq ||
> +		    vcpu_ptimer(vcpu)->irq.irq != ptimer_irq)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> @@ -636,6 +659,11 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	if (!vgic_initialized(vcpu->kvm))
>  		return -ENODEV;
>  
> +	if (!timer_irqs_are_valid(vcpu->kvm)) {
> +		kvm_debug("incorrectly configured timer irqs\n");
> +		return -EINVAL;
> +	}
> +
>  	/*
>  	 * Find the physical IRQ number corresponding to the host_vtimer_irq
>  	 */
> @@ -685,3 +713,79 @@ void kvm_timer_init_vhe(void)
>  	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
>  	write_sysreg(val, cnthctl_el2);
>  }
> +
> +static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
> +		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
> +	}
> +}
> +
> +int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	int __user *uaddr = (int __user *)(long)attr->addr;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +	int irq;
> +
> +	if (!irqchip_in_kernel(vcpu->kvm))
> +		return -EINVAL;
> +
> +	if (get_user(irq, uaddr))
> +		return -EFAULT;
> +
> +	if (!(irq_is_ppi(irq)))
> +		return -EINVAL;
> +
> +	if (vcpu->arch.timer_cpu.enabled)
> +		return -EBUSY;
> +
> +	switch (attr->attr) {
> +	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +		set_timer_irqs(vcpu->kvm, irq, ptimer->irq.irq);

Could we move the (vtimer_irq == ptimer_irq) check here? It is probably
better to fail early than to wait until the first run to discover that
something was wrong... Or does that clash horribly with the default values?

Another issue that just popped in my head: how do we ensure that we
don't clash between the PMU and the timers? Yes, that's a foolish thing
to do, but that's no different from avoiding the same interrupt on the
timers...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
