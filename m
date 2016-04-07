From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 05/12] KVM: arm64: introduce ITS emulation file with
 stub functions
Date: Thu, 7 Apr 2016 16:19:27 +0100
Message-ID: <57067A7F.80403@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-6-git-send-email-andre.przywara@arm.com>
 <57066907.2020103@arm.com> <570669E3.3070907@linaro.org>
 <57067356.40508@arm.com> <5706783F.4040906@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B55B40BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 11:18:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lhKO1ltUg4-x for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2016 11:18:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EEA840B58
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 11:18:06 -0400 (EDT)
In-Reply-To: <5706783F.4040906@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/04/16 16:09, Eric Auger wrote:
> On 04/07/2016 04:48 PM, Marc Zyngier wrote:
>> Hi Eric,
>>
>> On 07/04/16 15:08, Eric Auger wrote:
>>> Hi Marc,
>>> On 04/07/2016 04:04 PM, Marc Zyngier wrote:
>>>> On 26/03/16 02:14, Andre Przywara wrote:
>>>>> The ARM GICv3 ITS emulation code goes into a separate file, but
>>>>> needs to be connected to the GICv3 emulation, of which it is an
>>>>> option.
>>>>> Introduce the skeleton with function stubs to be filled later.
>>>>> Introduce the basic ITS data structure and initialize it, but don't
>>>>> return any success yet, as we are not yet ready for the show.
>>>>>
>>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>>> ---
>>>>>  arch/arm64/kvm/Makefile            |  1 +
>>>>>  include/kvm/vgic/vgic.h            |  6 +++
>>>>>  include/linux/irqchip/arm-gic-v3.h |  1 +
>>>>>  virt/kvm/arm/vgic/its-emul.c       | 84 ++++++++++++++++++++++++++++++++++++++
>>>>>  virt/kvm/arm/vgic/vgic.h           | 14 +++++++
>>>>>  virt/kvm/arm/vgic/vgic_init.c      |  6 +++
>>>>>  virt/kvm/arm/vgic/vgic_mmio.c      | 18 ++++++--
>>>>>  7 files changed, 126 insertions(+), 4 deletions(-)
>>>>>  create mode 100644 virt/kvm/arm/vgic/its-emul.c
>>>>>
>>>>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>>>>> index 2f5d431..3bec10e 100644
>>>>> --- a/arch/arm64/kvm/Makefile
>>>>> +++ b/arch/arm64/kvm/Makefile
>>>>> @@ -28,6 +28,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
>>>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
>>>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_mmio.o
>>>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_kvm_device.o
>>>>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/its-emul.o
>>>>>  else
>>>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
>>>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
>>>>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>>>>> index 8ea5dd7..c79bed5 100644
>>>>> --- a/include/kvm/vgic/vgic.h
>>>>> +++ b/include/kvm/vgic/vgic.h
>>>>> @@ -112,6 +112,11 @@ struct vgic_io_device {
>>>>>  	struct kvm_io_device dev;
>>>>>  };
>>>>>  
>>>>> +struct vgic_its {
>>>>> +	bool			enabled;
>>>>> +	spinlock_t		lock;
>>>>> +};
>>>>> +
>>>>>  struct vgic_dist {
>>>>>  	bool			in_kernel;
>>>>>  	bool			ready;
>>>>> @@ -153,6 +158,7 @@ struct vgic_dist {
>>>>>  	u64			*pendbaser;
>>>>>  
>>>>>  	bool			lpis_enabled;
>>>>> +	struct vgic_its		its;
>>>>>  };
>>>>>  
>>>>>  struct vgic_v2_cpu_if {
>>>>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>>>>> index d5d798b..a813c3e 100644
>>>>> --- a/include/linux/irqchip/arm-gic-v3.h
>>>>> +++ b/include/linux/irqchip/arm-gic-v3.h
>>>>> @@ -177,6 +177,7 @@
>>>>>  #define GITS_CWRITER			0x0088
>>>>>  #define GITS_CREADR			0x0090
>>>>>  #define GITS_BASER			0x0100
>>>>> +#define GITS_IDREGS_BASE		0xffd0
>>>>>  #define GITS_PIDR2			GICR_PIDR2
>>>>>  
>>>>>  #define GITS_TRANSLATER			0x10040
>>>>> diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
>>>>> new file mode 100644
>>>>> index 0000000..49dd5e4
>>>>> --- /dev/null
>>>>> +++ b/virt/kvm/arm/vgic/its-emul.c
>>>>> @@ -0,0 +1,84 @@
>>>>> +/*
>>>>> + * GICv3 ITS emulation
>>>>> + *
>>>>> + * Copyright (C) 2015 ARM Ltd.
>>>>> + * Author: Andre Przywara <andre.przywara@arm.com>
>>>>> + *
>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>> + * published by the Free Software Foundation.
>>>>> + *
>>>>> + * This program is distributed in the hope that it will be useful,
>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>> + * GNU General Public License for more details.
>>>>> + *
>>>>> + * You should have received a copy of the GNU General Public License
>>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>>> + */
>>>>> +
>>>>> +#include <linux/cpu.h>
>>>>> +#include <linux/kvm.h>
>>>>> +#include <linux/kvm_host.h>
>>>>> +#include <linux/interrupt.h>
>>>>> +
>>>>> +#include <linux/irqchip/arm-gic-v3.h>
>>>>> +
>>>>> +#include <asm/kvm_emulate.h>
>>>>> +#include <asm/kvm_arm.h>
>>>>> +#include <asm/kvm_mmu.h>
>>>>> +
>>>>> +#include "vgic.h"
>>>>> +#include "vgic_mmio.h"
>>>>> +
>>>>> +struct vgic_register_region its_registers[] = {
>>>>> +	REGISTER_DESC_WITH_LENGTH(GITS_CTLR,
>>>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>>>>> +	REGISTER_DESC_WITH_LENGTH(GITS_IIDR,
>>>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>>>>> +	REGISTER_DESC_WITH_LENGTH(GITS_TYPER,
>>>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>>>>
>>>> GITS_TYPER is a 64bit register with plenty of things in the upper bits.
>>> In practice I think the 32 upper bits are reserved.
>>
>> Not quite. Only bits [63:38] are reserved. See 8.19.8 in the
>> Architecture Specification (IHI 0069B).
> 
> Ah OK. Was using an older arch spec(PRD03-GENC-010745 22.0) Now switched
> to the indicated one and indeed it's different !;-)

Ouch! Please burn that one, it is horribly outdated. The internal
revision of that document is now 35.1, but we're phasing it out in
favour of the public Architecture Specification.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
