From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 14/55] KVM: arm/arm64: vgic-new: Add acccessor to new
 struct vgic_irq instance
Date: Wed, 11 May 2016 10:20:05 +0100
Message-ID: <5732F945.1080203@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-15-git-send-email-andre.przywara@arm.com>
 <5731A864.5000109@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B2F749B78
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 05:16:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qPXTFXaXsCje for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 05:16:39 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9B349B6B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 05:16:38 -0400 (EDT)
In-Reply-To: <5731A864.5000109@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 10/05/16 10:22, Marc Zyngier wrote:
> On 06/05/16 11:45, Andre Przywara wrote:
>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> The new VGIC implementation centers around a struct vgic_irq instance
>> per virtual IRQ.
>> Provide a function to retrieve the right instance for a given IRQ
>> number and (in case of private interrupts) the right VCPU.
>>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h | 22 ++++++++++++++++++++++
>>  2 files changed, 63 insertions(+)
>>  create mode 100644 virt/kvm/arm/vgic/vgic.c
>>  create mode 100644 virt/kvm/arm/vgic/vgic.h
>>
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> new file mode 100644
>> index 0000000..fb45537
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -0,0 +1,41 @@
>> +/*
>> + * Copyright (C) 2015, 2016 ARM Ltd.
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
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include "vgic.h"
>> +
>> +struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
> 
> nit: this structure isn't referenced anywhere yet.

I see it actually been used in the previous patch, but we only introduce
the header file here. This is one example of why we decided to not
enable compilation early. If you don't mind, I keep it in here.

Thanks for the ACK.

Cheers,
Andre.

>> +
>> +struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>> +			      u32 intid)
>> +{
>> +	/* SGIs and PPIs */
>> +	if (intid <= VGIC_MAX_PRIVATE)
>> +		return &vcpu->arch.vgic_cpu.private_irqs[intid];
>> +
>> +	/* SPIs */
>> +	if (intid <= VGIC_MAX_SPI)
>> +		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
>> +
>> +	/* LPIs are not yet covered */
>> +	if (intid >= VGIC_MIN_LPI)
>> +		return NULL;
>> +
>> +	WARN(1, "Looking up struct vgic_irq for reserved INTID");
>> +	return NULL;
>> +}
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> new file mode 100644
>> index 0000000..61b8d22
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -0,0 +1,22 @@
>> +/*
>> + * Copyright (C) 2015, 2016 ARM Ltd.
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
>> +#ifndef __KVM_ARM_VGIC_NEW_H__
>> +#define __KVM_ARM_VGIC_NEW_H__
>> +
>> +struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>> +			      u32 intid);
>> +
>> +#endif
>>
> 
> Otherwise:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> 	M.
> 
