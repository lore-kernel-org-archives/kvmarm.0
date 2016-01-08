From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Fri, 8 Jan 2016 10:53:03 +0800
Message-ID: <568F248F.7020602@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com> <20160107201859.GI6199@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160107201859.GI6199@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/8 4:18, Andrew Jones wrote:
> On Tue, Dec 22, 2015 at 04:08:15PM +0800, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
>> the kvm_device_ops for it.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  Documentation/virtual/kvm/devices/arm-pmu.txt |  24 +++++
>>  arch/arm64/include/uapi/asm/kvm.h             |   4 +
>>  include/linux/kvm_host.h                      |   1 +
>>  include/uapi/linux/kvm.h                      |   2 +
>>  virt/kvm/arm/pmu.c                            | 128 ++++++++++++++++++++++++++
>>  virt/kvm/kvm_main.c                           |   4 +
>>  6 files changed, 163 insertions(+)
>>  create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
>>
>> diff --git a/Documentation/virtual/kvm/devices/arm-pmu.txt b/Documentation/virtual/kvm/devices/arm-pmu.txt
>> new file mode 100644
>> index 0000000..dda864e
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/devices/arm-pmu.txt
>> @@ -0,0 +1,24 @@
>> +ARM Virtual Performance Monitor Unit (vPMU)
>> +===========================================
>> +
>> +Device types supported:
>> +  KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
>> +
>> +Instantiate one PMU instance for per VCPU through this API.
>                                 ^^ don't need this 'for' here
> 
>> +
>> +Groups:
>> +  KVM_DEV_ARM_PMU_GRP_IRQ
>> +  Attributes:
>> +    The attr field of kvm_device_attr encodes one value:
>> +    bits:     | 63 .... 32 | 31 ....  0 |
>> +    values:   |  reserved  | vcpu_index |
> 
> Everywhere else in kvm documentation a vcpu_index is 8 bits. I'm not
> saying that that's good, but expanding it to 32 bits here is
> inconsistent. 
Expand it to 32 bits just in case it needs to support more than 256
vcpus in the future. If you think this is not good, I'll change it to 8
bits.

(A side note is that I think we should s/vcpu_index/vcpu_id/
> in order to keep the parameter name consistent with what's used by
> KVM_CREATE_VCPU)
> 
Eh, I make it consistent with vGIC which is a kvm device that's also
created via KVM_CREATE_DEVICE API. So they are different names but
express same thing.

>> +    A value describing the PMU overflow interrupt number for the specified
>> +    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
>> +    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
>> +    same for all vcpus, while as a SPI it must be different for each vcpu.
>> +
>> +  Errors:
>> +    -ENXIO: Unsupported attribute group
> 
> Do we need to specify ENXIO here? It's already specified in
> Documentation/virtual/kvm/api.txt for SET/GET_DEVICE_ATTR
> 
But specifying it here is not bad, right? If you insist on this, I'll
drop it.

>> +    -EBUSY: The PMU overflow interrupt is already set
>> +    -ENODEV: Getting the PMU overflow interrupt number while it's not set
>> +    -EINVAL: Invalid vcpu_index or PMU overflow interrupt number supplied
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 2d4ca4b..cbb9022 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -204,6 +204,10 @@ struct kvm_arch_memory_slot {
>>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>>  
>> +/* Device Control API: ARM PMU */
>> +#define KVM_DEV_ARM_PMU_GRP_IRQ		0
>> +#define   KVM_DEV_ARM_PMU_CPUID_MASK	0xffffffffULL
> 
> I don't think we should need a mask like this, at least not in the uapi.
> The documentation says to use a vcpu-index [really a vcpu-id], and users
> should know how to convert their vcpu handle (whatever that may be) to
> a vcpu-id using whatever transformation is necessary. They may already
> have a "vcpu id mask" defined (this is one reason why I don't think we
> should use a 32-bit vcpu-index here, instead of the 8-bit vcpu-index used
> everywhere else). Likewise, kvm should know how to do it's transformation.
> Maybe, to aid in the attr field construction, we should supply a shift,
> allowing both sides to do something like
> 
> int pmu_attr_extract_vcpu_id(u64 attr)
> {
>     return (attr >> KVM_DEV_ARM_PMU_VCPUID_SHIFT) & VCPU_ID_MASK;
So what's the value of the VCPU_ID_MASK? I didn't see any definitions
about it. It looks like KVM_DEV_ARM_PMU_CPUID_MASK(just has a difference
between 32 bits and 8 bits)

> }
> 
> u64 pmu_attr_create(int vcpu_id)
> {
>     return vcpu_id << KVM_DEV_ARM_PMU_VCPUID_SHIFT;
> }
> 
> But, in this case the shift is zero, so it's not really necessary. In
> any case, please add the 'V' for VCPU.
> 
>> +
>>  /* KVM_IRQ_LINE irq field index values */
>>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
>>  #define KVM_ARM_IRQ_TYPE_MASK		0xff
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index c923350..608dea6 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -1161,6 +1161,7 @@ extern struct kvm_device_ops kvm_mpic_ops;
>>  extern struct kvm_device_ops kvm_xics_ops;
>>  extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
>>  extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
>> +extern struct kvm_device_ops kvm_arm_pmu_ops;
>>  
>>  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>>  
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 03f3618..4ba6fdd 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1032,6 +1032,8 @@ enum kvm_device_type {
>>  #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
>>  	KVM_DEV_TYPE_ARM_VGIC_V3,
>>  #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
>> +	KVM_DEV_TYPE_ARM_PMU_V3,
>> +#define	KVM_DEV_TYPE_ARM_PMU_V3		KVM_DEV_TYPE_ARM_PMU_V3
>>  	KVM_DEV_TYPE_MAX,
>>  };
>>  
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index 3ec3cdd..5518308 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  #include <linux/perf_event.h>
>> +#include <linux/uaccess.h>
>>  #include <asm/kvm_emulate.h>
>>  #include <kvm/arm_pmu.h>
>>  #include <kvm/arm_vgic.h>
>> @@ -374,3 +375,130 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>>  
>>  	pmc->perf_event = event;
>>  }
>> +
>> +static inline bool kvm_arm_pmu_initialized(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.pmu.irq_num != -1;
>> +}
>> +
>> +static int kvm_arm_pmu_irq_access(struct kvm *kvm, struct kvm_device_attr *attr,
>> +				  int *irq, bool is_set)
>> +{
>> +	int cpuid;
> 
> please call this vcpu_id
> 
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_pmu *pmu;
>> +
>> +	cpuid = attr->attr & KVM_DEV_ARM_PMU_CPUID_MASK;
>> +	if (cpuid >= atomic_read(&kvm->online_vcpus))
>> +		return -EINVAL;
>> +
>> +	vcpu = kvm_get_vcpu(kvm, cpuid);
>> +	if (!vcpu)
>> +		return -EINVAL;
>> +
>> +	pmu = &vcpu->arch.pmu;
>> +	if (!is_set) {
>> +		if (!kvm_arm_pmu_initialized(vcpu))
>> +			return -ENODEV;
>> +
>> +		*irq = pmu->irq_num;
>> +	} else {
>> +		if (kvm_arm_pmu_initialized(vcpu))
>> +			return -EBUSY;
>> +
>> +		kvm_debug("Set kvm ARM PMU irq: %d\n", *irq);
>> +		pmu->irq_num = *irq;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int kvm_arm_pmu_create(struct kvm_device *dev, u32 type)
>> +{
>> +	int i;
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm *kvm = dev->kvm;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +
>> +		memset(pmu, 0, sizeof(*pmu));
> 
> I don't think we want this memset. If we can only create the pmu
> once, then it's unnecessary (we zalloc vcpus). And, if we can
> recreate pmus with this call, then it'll create a memory leak, as
> we'll be zero-ing out all the perf_event pointers, and then won't
> be able to free them on the call to kvm_pmu_vcpu_reset. Naturally
> we need to make sure we're NULL-ing them after each free instead.
> 
Ok, will drop this.

>> +		kvm_pmu_vcpu_reset(vcpu);
>> +		pmu->irq_num = -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void kvm_arm_pmu_destroy(struct kvm_device *dev)
>> +{
>> +	kfree(dev);
>> +}
>> +
>> +static int kvm_arm_pmu_set_attr(struct kvm_device *dev,
>> +				struct kvm_device_attr *attr)
>> +{
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_PMU_GRP_IRQ: {
>> +		int __user *uaddr = (int __user *)(long)attr->addr;
>> +		int reg;
>> +
>> +		if (get_user(reg, uaddr))
>> +			return -EFAULT;
>> +
>> +		/*
>> +		 * The PMU overflow interrupt could be a PPI or SPI, but for one
>> +		 * VM the interrupt type must be same for each vcpu. As a PPI,
>> +		 * the interrupt number is same for all vcpus, while as a SPI it
>> +		 * must be different for each vcpu.
>> +		 */
>> +		if (reg < VGIC_NR_SGIS || reg >= dev->kvm->arch.vgic.nr_irqs)
>> +			return -EINVAL;
>> +
>> +		return kvm_arm_pmu_irq_access(dev->kvm, attr, &reg, true);
>> +	}
>> +	}
>> +
>> +	return -ENXIO;
>> +}
>> +
>> +static int kvm_arm_pmu_get_attr(struct kvm_device *dev,
>> +				struct kvm_device_attr *attr)
>> +{
>> +	int ret;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_PMU_GRP_IRQ: {
>> +		int __user *uaddr = (int __user *)(long)attr->addr;
>> +		int reg = -1;
>> +
>> +
>> +		ret = kvm_arm_pmu_irq_access(dev->kvm, attr, &reg, false);
>> +		if (ret)
>> +			return ret;
>> +		return put_user(reg, uaddr);
>> +	}
>> +	}
>> +
>> +	return -ENXIO;
>> +}
>> +
>> +static int kvm_arm_pmu_has_attr(struct kvm_device *dev,
>> +				struct kvm_device_attr *attr)
>> +{
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_PMU_GRP_IRQ:
>> +		return 0;
>> +	}
>> +
>> +	return -ENXIO;
>> +}
>> +
>> +struct kvm_device_ops kvm_arm_pmu_ops = {
>> +	.name = "kvm-arm-pmu",
>> +	.create = kvm_arm_pmu_create,
>> +	.destroy = kvm_arm_pmu_destroy,
>> +	.set_attr = kvm_arm_pmu_set_attr,
>> +	.get_attr = kvm_arm_pmu_get_attr,
>> +	.has_attr = kvm_arm_pmu_has_attr,
>> +};
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 484079e..81a42cc 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2647,6 +2647,10 @@ static struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
>>  #ifdef CONFIG_KVM_XICS
>>  	[KVM_DEV_TYPE_XICS]		= &kvm_xics_ops,
>>  #endif
>> +
>> +#ifdef CONFIG_KVM_ARM_PMU
>> +	[KVM_DEV_TYPE_ARM_PMU_V3]	= &kvm_arm_pmu_ops,
> 
> Shouldn't we specify 'v3' in the kvm_arm_pmu_ops name, as we do with the
> device type name?
> 
Sure, will add.

>> +#endif
>>  };
>>  
>>  int kvm_register_device_ops(struct kvm_device_ops *ops, u32 type)
>> -- 
>> 2.0.4
>>
> 
> Thanks,
> drew
> 
> .
> 

-- 
Shannon

