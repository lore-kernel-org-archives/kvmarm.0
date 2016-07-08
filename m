From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH v8 09/17] KVM: arm64: introduce ITS emulation file with
 MMIO framework
Date: Fri, 8 Jul 2016 15:04:32 +0100
Message-ID: <dbe1dcbe-c1b1-6ea2-4354-bd9a164b8fc9@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-10-andre.przywara@arm.com> <577FABF2.30302@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <577FABF2.30302@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/16 14:34, Marc Zyngier wrote:
> On 05/07/16 12:23, Andre Przywara wrote:
>> The ARM GICv3 ITS emulation code goes into a separate file, but needs
>> to be connected to the GICv3 emulation, of which it is an option.
>> The ITS MMIO handlers require the respective ITS pointer to be passed in,
>> so we amend the existing VGIC MMIO framework to let it cope with that.
>> Also we introduce the basic ITS data structure and initialize it, but
>> don't return any success yet, as we are not yet ready for the show.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arch/arm64/kvm/Makefile          |   1 +
>>  include/kvm/arm_vgic.h           |  14 +++++-
>>  virt/kvm/arm/vgic/vgic-its.c     | 100 +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  40 +++++++--------
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 104 ++++++++++++++++++++++++++-------------
>>  virt/kvm/arm/vgic/vgic-mmio.c    |  36 +++++++++++---
>>  virt/kvm/arm/vgic/vgic-mmio.h    |  31 +++++++++---
>>  virt/kvm/arm/vgic/vgic.h         |   7 +++
>>  8 files changed, 266 insertions(+), 67 deletions(-)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-its.c
>>
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index f00b2cd..a5b9664 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -29,5 +29,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index f6f860d..f606641 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -108,15 +108,27 @@ struct vgic_irq {
>>  };
>>  
>>  struct vgic_register_region;
>> +struct vgic_its;
>>  
>>  struct vgic_io_device {
>>  	gpa_t base_addr;
>> -	struct kvm_vcpu *redist_vcpu;
>> +	union {
>> +		struct kvm_vcpu *redist_vcpu;
>> +		struct vgic_its *its;
>> +	};
> 
> The only question that springs to mind is...
> 
>>  	const struct vgic_register_region *regions;
>>  	int nr_regions;
>>  	struct kvm_io_device dev;
>>  };
>>  
>> +struct vgic_its {
>> +	/* The base address of the ITS control register frame */
>> +	gpa_t			vgic_its_base;
>> +
>> +	bool			enabled;
>> +	struct vgic_io_device	iodev;
>> +};
>> +
>>  struct vgic_dist {
>>  	bool			in_kernel;
>>  	bool			ready;
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> new file mode 100644
>> index 0000000..ab8d244
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -0,0 +1,100 @@
>> +/*
>> + * GICv3 ITS emulation
>> + *
>> + * Copyright (C) 2015,2016 ARM Ltd.
>> + * Author: Andre Przywara <andre.przywara@arm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/cpu.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/interrupt.h>
>> +
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_arm.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +#include "vgic.h"
>> +#include "vgic-mmio.h"
>> +
>> +#define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
>> +{								\
>> +	.reg_offset = off,					\
>> +	.len = length,						\
>> +	.access_flags = acc,					\
>> +	.iodev_type = IODEV_ITS,				\
> 
> ... why isn't this at the device level? It doesn't make much sense to
> have it at the register level (we never access a register in isolation,
> we always access it relatively to a device).
> 
> And given that the *only* time you actually evaluate this flag is in
> dispatch_mmio_read/write, there is zero benefit in duplicating it all
> over the place.
> 
> Smaller structures, smaller patch. Am I missing something?

Looks possible. I think I tried something like this in the beginning and
hit some wall - possibly the one in my head ;-). Also I found it saner
to have the type associated with the declaration instead of adjusting
this in the registration function.
But looking again it seems indeed better to do it your way (TM).

Cheers,
Andre

