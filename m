From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 21/21] KVM: ARM64: Add a new kvm ARM PMU device
Date: Mon, 07 Dec 2015 13:56:57 +0000
Message-ID: <56659029.7040102@arm.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com> <1449123091-20252-22-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449123091-20252-22-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/15 06:11, Shannon Zhao wrote:
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
>  virt/kvm/arm/pmu.c                            | 87 +++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c                           |  4 ++
>  6 files changed, 113 insertions(+)
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
> index bd2fece..82b90e8 100644
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
> @@ -436,3 +439,87 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  
>  	pmc->perf_event = event;
>  }
> +
> +static int kvm_arm_pmu_set_irq(struct kvm *kvm, int irq)
> +{
> +	int j;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(j, vcpu, kvm) {
> +		struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +		kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
> +		pmu->irq_num = irq;
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

What prevents the IRQ to be changed while the VM is already running?
This should probably be a one-shot thing (change it once, be denied
other changes).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
