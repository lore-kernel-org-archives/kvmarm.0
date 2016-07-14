From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 10/17] KVM: arm64: introduce new KVM ITS device
Date: Thu, 14 Jul 2016 13:57:22 +0100
Message-ID: <57878C32.4030601@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-11-andre.przywara@arm.com> <57874F1E.3000202@arm.com>
 <3ec7d294-1799-f866-db5e-891552ba3196@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <3ec7d294-1799-f866-db5e-891552ba3196@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/16 12:11, Andre Przywara wrote:
> Hi,
> 
> On 14/07/16 09:36, Marc Zyngier wrote:
>> On 13/07/16 02:59, Andre Przywara wrote:
>>> Introduce a new KVM device that represents an ARM Interrupt Translation
>>> Service (ITS) controller. Since there can be multiple of this per guest,
>>> we can't piggy back on the existing GICv3 distributor device, but create
>>> a new type of KVM device.
>>> On the KVM_CREATE_DEVICE ioctl we allocate and initialize the ITS data
>>> structure and store the pointer in the kvm_device data.
>>> Upon an explicit init ioctl from userland (after having setup the MMIO
>>> address) we register the handlers with the kvm_io_bus framework.
>>> Any reference to an ITS thus has to go via this interface.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  Documentation/virtual/kvm/devices/arm-vgic.txt |  25 +++--
>>>  arch/arm/kvm/arm.c                             |   1 +
>>>  arch/arm64/include/uapi/asm/kvm.h              |   2 +
>>>  include/kvm/arm_vgic.h                         |   3 +
>>>  include/uapi/linux/kvm.h                       |   2 +
>>>  virt/kvm/arm/vgic/vgic-its.c                   | 144 ++++++++++++++++++++++++-
>>>  virt/kvm/arm/vgic/vgic-kvm-device.c            |   7 +-
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c               |   2 +-
>>>  virt/kvm/arm/vgic/vgic.h                       |   8 ++
>>>  9 files changed, 183 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
>>> index 59541d4..89182f8 100644
>>> --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
>>> +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
>>> @@ -4,16 +4,22 @@ ARM Virtual Generic Interrupt Controller (VGIC)
>>>  Device types supported:
>>>    KVM_DEV_TYPE_ARM_VGIC_V2     ARM Generic Interrupt Controller v2.0
>>>    KVM_DEV_TYPE_ARM_VGIC_V3     ARM Generic Interrupt Controller v3.0
>>> +  KVM_DEV_TYPE_ARM_VGIC_ITS    ARM Interrupt Translation Service Controller
>>>  
>>> -Only one VGIC instance may be instantiated through either this API or the
>>> -legacy KVM_CREATE_IRQCHIP api.  The created VGIC will act as the VM interrupt
>>> -controller, requiring emulated user-space devices to inject interrupts to the
>>> -VGIC instead of directly to CPUs.
>>> +Only one VGIC instance of the V2/V3 types above may be instantiated through
>>> +either this API or the legacy KVM_CREATE_IRQCHIP api.  The created VGIC will
>>> +act as the VM interrupt controller, requiring emulated user-space devices to
>>> +inject interrupts to the VGIC instead of directly to CPUs.
>>>  
>>>  Creating a guest GICv3 device requires a host GICv3 as well.
>>>  GICv3 implementations with hardware compatibility support allow a guest GICv2
>>>  as well.
>>>  
>>> +Creating a virtual ITS controller requires a host GICv3 (but does not depend
>>> +on having physical ITS controllers).
>>> +There can be multiple ITS controllers per guest, each of them has to have
>>> +a separate, non-overlapping MMIO region.
>>> +
>>>  Groups:
>>>    KVM_DEV_ARM_VGIC_GRP_ADDR
>>>    Attributes:
>>> @@ -39,6 +45,13 @@ Groups:
>>>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>>>        This address needs to be 64K aligned.
>>>  
>>> +    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
>>> +      Base address in the guest physical address space of the GICv3 ITS
>>> +      control register frame. The ITS allows MSI(-X) interrupts to be
>>> +      injected into guests. This extension is optional. If the kernel
>>> +      does not support the ITS, the call returns -ENODEV.
>>> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_ITS.
>>> +      This address needs to be 64K aligned and the region covers 128K.
>>>  
>>>    KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>>>    Attributes:
>>> @@ -109,8 +122,8 @@ Groups:
>>>    KVM_DEV_ARM_VGIC_GRP_CTRL
>>>    Attributes:
>>>      KVM_DEV_ARM_VGIC_CTRL_INIT
>>> -      request the initialization of the VGIC, no additional parameter in
>>> -      kvm_device_attr.addr.
>>> +      request the initialization of the VGIC or ITS, no additional parameter
>>> +      in kvm_device_attr.addr.
>>>    Errors:
>>>      -ENXIO: VGIC not properly configured as required prior to calling
>>>       this attribute
>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>> index 557e390..0d5c255 100644
>>> --- a/arch/arm/kvm/arm.c
>>> +++ b/arch/arm/kvm/arm.c
>>> @@ -20,6 +20,7 @@
>>>  #include <linux/errno.h>
>>>  #include <linux/err.h>
>>>  #include <linux/kvm_host.h>
>>> +#include <linux/list.h>
>>>  #include <linux/module.h>
>>>  #include <linux/vmalloc.h>
>>>  #include <linux/fs.h>
>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>>> index f209ea1..3051f86 100644
>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>> @@ -87,9 +87,11 @@ struct kvm_regs {
>>>  /* Supported VGICv3 address types  */
>>>  #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
>>>  #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
>>> +#define KVM_VGIC_ITS_ADDR_TYPE		4
>>>  
>>>  #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
>>>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
>>> +#define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
>>>  
>>>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>>>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index 685f339..8609fac 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -134,6 +134,7 @@ struct vgic_its {
>>>  	gpa_t			vgic_its_base;
>>>  
>>>  	bool			enabled;
>>> +	bool			initialized;
>>>  	struct vgic_io_device	iodev;
>>>  };
>>>  
>>> @@ -167,6 +168,8 @@ struct vgic_dist {
>>>  
>>>  	struct vgic_io_device	dist_iodev;
>>>  
>>> +	bool			has_its;
>>> +
>>>  	/*
>>>  	 * Contains the attributes and gpa of the LPI configuration table.
>>>  	 * Since we report GICR_TYPER.CommonLPIAff as 0b00, we can share
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 7de96f5..d8c4c32 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1077,6 +1077,8 @@ enum kvm_device_type {
>>>  #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
>>>  	KVM_DEV_TYPE_ARM_VGIC_V3,
>>>  #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
>>> +	KVM_DEV_TYPE_ARM_VGIC_ITS,
>>> +#define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>>>  	KVM_DEV_TYPE_MAX,
>>>  };
>>>  
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 06ad94d..393ad3a 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -21,6 +21,7 @@
>>>  #include <linux/kvm.h>
>>>  #include <linux/kvm_host.h>
>>>  #include <linux/interrupt.h>
>>> +#include <linux/uaccess.h>
>>>  
>>>  #include <linux/irqchip/arm-gic-v3.h>
>>>  
>>> @@ -79,7 +80,7 @@ static struct vgic_register_region its_registers[] = {
>>>  		VGIC_ACCESS_32bit),
>>>  };
>>>  
>>> -int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
>>> +static int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
>>
>> Please move this hunk to the previous patch...
> 
> Doing this provokes a compilation warning about an unused function in
> the previous patch then.
> I tried forth and back to fix this (and a couple of other occasions),
> but it was either hideous, invoked rewriting stuff needlessly, do a
> massive reordering or squashing some patches together, all of which does
> not help review.
> So this was the least problematic solution I could come up with.

OK.

> I just looked at deferring the addition of vgic-its.c to the Makefile
> into the very last patch and get rid of all those lines then.
> This seems to require only very small changes.
> 
> Would that be an acceptable solution?

Yes, that'd be fine.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
