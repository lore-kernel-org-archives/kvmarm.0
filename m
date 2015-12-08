From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 21/21] KVM: ARM64: Add a new kvm ARM PMU device
Date: Tue, 08 Dec 2015 17:43:42 +0000
Message-ID: <566716CE.5080405@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
 <1449578860-15808-22-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CACF9410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 12:41:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S6tGFi7-kvYT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 12:41:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD82C407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 12:41:54 -0500 (EST)
In-Reply-To: <1449578860-15808-22-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 12:47, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
> the kvm_device_ops for it.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  Documentation/virtual/kvm/devices/arm-pmu.txt | 16 +++++
>  arch/arm64/include/uapi/asm/kvm.h             |  3 +
>  include/linux/kvm_host.h                      |  1 +
>  include/uapi/linux/kvm.h                      |  2 +
>  virt/kvm/arm/pmu.c                            | 93 +++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c                           |  4 ++
>  6 files changed, 119 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-pmu.txt b/Documentation/virtual/kvm/devices/arm-pmu.txt
> new file mode 100644
> index 0000000..5121f1f
> --- /dev/null
> +++ b/Documentation/virtual/kvm/devices/arm-pmu.txt
> @@ -0,0 +1,16 @@
> +ARM Virtual Performance Monitor Unit (vPMU)
> +===========================================
> +
> +Device types supported:
> +  KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
> +
> +Instantiate one PMU instance for per VCPU through this API.
> +
> +Groups:
> +  KVM_DEV_ARM_PMU_GRP_IRQ
> +  Attributes:
> +    A value describing the interrupt number of PMU overflow interrupt. This
> +    interrupt should be a PPI.
> +
> +  Errors:
> +    -EINVAL: Value set is out of the expected range (from 16 to 31)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 2d4ca4b..568afa2 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -204,6 +204,9 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>  
> +/* Device Control API: ARM PMU */
> +#define KVM_DEV_ARM_PMU_GRP_IRQ		0
> +
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
>  #define KVM_ARM_IRQ_TYPE_MASK		0xff
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c923350..608dea6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1161,6 +1161,7 @@ extern struct kvm_device_ops kvm_mpic_ops;
>  extern struct kvm_device_ops kvm_xics_ops;
>  extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
>  extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
> +extern struct kvm_device_ops kvm_arm_pmu_ops;
>  
>  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 03f3618..4ba6fdd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1032,6 +1032,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
>  	KVM_DEV_TYPE_ARM_VGIC_V3,
>  #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
> +	KVM_DEV_TYPE_ARM_PMU_V3,
> +#define	KVM_DEV_TYPE_ARM_PMU_V3		KVM_DEV_TYPE_ARM_PMU_V3
>  	KVM_DEV_TYPE_MAX,
>  };
>  
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index f8007c7..a84a4d7 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -19,10 +19,13 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/perf_event.h>
> +#include <linux/uaccess.h>
>  #include <asm/kvm_emulate.h>
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_vgic.h>
>  
> +#include "vgic.h"
> +
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -438,3 +441,93 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  
>  	pmc->perf_event = event;
>  }
> +
> +static inline bool kvm_arm_pmu_initialized(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.pmu.irq_num != -1;
> +}
> +
> +static int kvm_arm_pmu_set_irq(struct kvm *kvm, int irq)
> +{
> +	int j;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(j, vcpu, kvm) {
> +		struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +		if (!kvm_arm_pmu_initialized(vcpu))
> +			kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
> +			pmu->irq_num = irq;

Missing braces? Also, you should consider returning an error if it has
been initialized twice.

> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_arm_pmu_create(struct kvm_device *dev, u32 type)
> +{
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm *kvm = dev->kvm;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +		memset(pmu, 0, sizeof(*pmu));
> +		kvm_pmu_vcpu_reset(vcpu);
> +		pmu->irq_num = -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void kvm_arm_pmu_destroy(struct kvm_device *dev)
> +{
> +	kfree(dev);
> +}
> +
> +static int kvm_arm_pmu_set_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PMU_GRP_IRQ: {
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		int reg;
> +
> +		if (get_user(reg, uaddr))
> +			return -EFAULT;
> +
> +		if (reg < VGIC_NR_SGIS || reg >= VGIC_NR_PRIVATE_IRQS)
> +			return -EINVAL;
> +
> +		return kvm_arm_pmu_set_irq(dev->kvm, reg);
> +	}
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +static int kvm_arm_pmu_get_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{

Shouldn't you be able to retrieve the configured interrupt?

> +	return 0;
> +}
> +
> +static int kvm_arm_pmu_has_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PMU_GRP_IRQ:
> +		return 0;
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +struct kvm_device_ops kvm_arm_pmu_ops = {
> +	.name = "kvm-arm-pmu",
> +	.create = kvm_arm_pmu_create,
> +	.destroy = kvm_arm_pmu_destroy,
> +	.set_attr = kvm_arm_pmu_set_attr,
> +	.get_attr = kvm_arm_pmu_get_attr,
> +	.has_attr = kvm_arm_pmu_has_attr,
> +};
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 484079e..81a42cc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2647,6 +2647,10 @@ static struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
>  #ifdef CONFIG_KVM_XICS
>  	[KVM_DEV_TYPE_XICS]		= &kvm_xics_ops,
>  #endif
> +
> +#ifdef CONFIG_KVM_ARM_PMU
> +	[KVM_DEV_TYPE_ARM_PMU_V3]	= &kvm_arm_pmu_ops,
> +#endif
>  };
>  
>  int kvm_register_device_ops(struct kvm_device_ops *ops, u32 type)
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
