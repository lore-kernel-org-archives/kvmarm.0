From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 19/19] KVM: ARM64: Add a new kvm ARM PMU device
Date: Tue, 15 Dec 2015 21:47:39 +0100
Message-ID: <20151215204739.GK4120@cbox>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-20-git-send-email-zhaoshenglong@huawei.com>
 <567032AD.8000206@arm.com>
 <567036DE.80605@linaro.org>
 <567038E3.3010102@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <567038E3.3010102@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 15, 2015 at 03:59:31PM +0000, Marc Zyngier wrote:
> On 15/12/15 15:50, Shannon Zhao wrote:
> > 
> > 
> > On 2015/12/15 23:33, Marc Zyngier wrote:
> >> On 15/12/15 08:49, Shannon Zhao wrote:
> >>>> From: Shannon Zhao<shannon.zhao@linaro.org>
> >>>>
> >>>> Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
> >>>> the kvm_device_ops for it.
> >>>>
> >>>> Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
> >>>> ---
> >>>>  Documentation/virtual/kvm/devices/arm-pmu.txt |  16 ++++
> >>>>  arch/arm64/include/uapi/asm/kvm.h             |   3 +
> >>>>  include/linux/kvm_host.h                      |   1 +
> >>>>  include/uapi/linux/kvm.h                      |   2 +
> >>>>  virt/kvm/arm/pmu.c                            | 115 ++++++++++++++++++++++++++
> >>>>  virt/kvm/kvm_main.c                           |   4 +
> >>>>  6 files changed, 141 insertions(+)
> >>>>  create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
> >>>>
> >>>> diff --git a/Documentation/virtual/kvm/devices/arm-pmu.txt b/Documentation/virtual/kvm/devices/arm-pmu.txt
> >>>> new file mode 100644
> >>>> index 0000000..5121f1f
> >>>> --- /dev/null
> >>>> +++ b/Documentation/virtual/kvm/devices/arm-pmu.txt
> >>>> @@ -0,0 +1,16 @@
> >>>> +ARM Virtual Performance Monitor Unit (vPMU)
> >>>> +===========================================
> >>>> +
> >>>> +Device types supported:
> >>>> +  KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
> >>>> +
> >>>> +Instantiate one PMU instance for per VCPU through this API.
> >>>> +
> >>>> +Groups:
> >>>> +  KVM_DEV_ARM_PMU_GRP_IRQ
> >>>> +  Attributes:
> >>>> +    A value describing the interrupt number of PMU overflow interrupt. This
> >>>> +    interrupt should be a PPI.
> >>>> +
> >>>> +  Errors:
> >>>> +    -EINVAL: Value set is out of the expected range (from 16 to 31)
> >>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >>>> index 2d4ca4b..568afa2 100644
> >>>> --- a/arch/arm64/include/uapi/asm/kvm.h
> >>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >>>> @@ -204,6 +204,9 @@ struct kvm_arch_memory_slot {
> >>>>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
> >>>>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
> >>>>
> >>>> +/* Device Control API: ARM PMU */
> >>>> +#define KVM_DEV_ARM_PMU_GRP_IRQ		0
> >>>> +
> >>>>  /* KVM_IRQ_LINE irq field index values */
> >>>>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> >>>>  #define KVM_ARM_IRQ_TYPE_MASK		0xff
> >>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >>>> index c923350..608dea6 100644
> >>>> --- a/include/linux/kvm_host.h
> >>>> +++ b/include/linux/kvm_host.h
> >>>> @@ -1161,6 +1161,7 @@ extern struct kvm_device_ops kvm_mpic_ops;
> >>>>  extern struct kvm_device_ops kvm_xics_ops;
> >>>>  extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
> >>>>  extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
> >>>> +extern struct kvm_device_ops kvm_arm_pmu_ops;
> >>>>
> >>>>  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> >>>>
> >>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >>>> index 03f3618..4ba6fdd 100644
> >>>> --- a/include/uapi/linux/kvm.h
> >>>> +++ b/include/uapi/linux/kvm.h
> >>>> @@ -1032,6 +1032,8 @@ enum kvm_device_type {
> >>>>  #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
> >>>>  	KVM_DEV_TYPE_ARM_VGIC_V3,
> >>>>  #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
> >>>> +	KVM_DEV_TYPE_ARM_PMU_V3,
> >>>> +#define	KVM_DEV_TYPE_ARM_PMU_V3		KVM_DEV_TYPE_ARM_PMU_V3
> >>>>  	KVM_DEV_TYPE_MAX,
> >>>>  };
> >>>>
> >>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> >>>> index d113ee4..1965d0d 100644
> >>>> --- a/virt/kvm/arm/pmu.c
> >>>> +++ b/virt/kvm/arm/pmu.c
> >>>> @@ -19,6 +19,7 @@
> >>>>  #include <linux/kvm.h>
> >>>>  #include <linux/kvm_host.h>
> >>>>  #include <linux/perf_event.h>
> >>>> +#include <linux/uaccess.h>
> >>>>  #include <asm/kvm_emulate.h>
> >>>>  #include <kvm/arm_pmu.h>
> >>>>  #include <kvm/arm_vgic.h>
> >>>> @@ -357,3 +358,117 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> >>>>
> >>>>  	pmc->perf_event = event;
> >>>>  }
> >>>> +
> >>>> +static inline bool kvm_arm_pmu_initialized(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +	return vcpu->arch.pmu.irq_num != -1;
> >>>> +}
> >>>> +
> >>>> +static int kvm_arm_pmu_irq_access(struct kvm *kvm, int *irq, bool is_set)
> >>>> +{
> >>>> +	int j;
> >>>> +	struct kvm_vcpu *vcpu;
> >>>> +
> >>>> +	kvm_for_each_vcpu(j, vcpu, kvm) {
> >>>> +		struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >>>> +
> >>>> +		if (!is_set) {
> >>>> +			if (!kvm_arm_pmu_initialized(vcpu))
> >>>> +				return -EBUSY;
> >> Returning -EBUSY is a bit odd. Maybe -EINVAL? But this seems weird
> >> anyway. Actually, why would you return an error in this case?
> >>
> > While this is a unexpected operation from user space and it's already 
> > initialized and working, so I think it should return an error to user 
> > and tell user that it's already initialized and working (this should 
> > mean "busy" ?).
> 
> But in this case, you're returning an error if it is *not* initialized.
> I understand that in that case you cannot return an interrupt number (-1
> would be weird), but returning -EBUSY feels even more weird.
> 
> I'd settle for -ENOXIO, or something similar. Anyone having a better idea?
> 
ENXIO or ENODEV would be my choice too, and add that to the
Documentation clearly describing when this error code is used.

By the way, why do you loop over all VCPUS to set the same value when
you can't do anything per VCPU anyway?  It seems to me it's either a
per-VM property (that you can store on the VM data structure) or it's a
true per-VCPU property?

-Christoffer
