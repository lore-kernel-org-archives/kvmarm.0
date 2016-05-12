From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 13/55] KVM: arm/arm64: vgic-new: Add data structure
 definitions
Date: Thu, 12 May 2016 13:17:38 +0100
Message-ID: <57347462.1020504@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-14-git-send-email-andre.przywara@arm.com>
 <20160512121258.GG27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2A7249B3C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:14:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OnFjWkvpTfck for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 08:14:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18E3049B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:14:40 -0400 (EDT)
In-Reply-To: <20160512121258.GG27623@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/05/16 13:12, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:45:26AM +0100, Andre Przywara wrote:
>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> Add a new header file for the new and improved GIC implementation.
>> The big change is that we now have a struct vgic_irq per IRQ instead
>> of spreading all the information over various bitmaps.
>>
>> We include this new header conditionally from within the old header
>> file for the time being to avoid touching all the users.
>>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changes RFC .. v1:
>> - adapt to 4.6-rc (adding live_lrs member)
>> - elaborate on ap_list usage
>>
>> Changes v1 .. v2:
>> - change data type of dist->enabled to bool
>>
>>  include/kvm/arm_vgic.h  |   5 ++
>>  include/kvm/vgic/vgic.h | 201 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 206 insertions(+)
>>  create mode 100644 include/kvm/vgic/vgic.h
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index c14ff77..d406f8e 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -19,6 +19,10 @@
>>  #ifndef __ASM_ARM_KVM_VGIC_H
>>  #define __ASM_ARM_KVM_VGIC_H
>>  
>> +#ifdef CONFIG_KVM_NEW_VGIC
>> +#include <kvm/vgic/vgic.h>
>> +#else
>> +
>>  #include <linux/kernel.h>
>>  #include <linux/kvm.h>
>>  #include <linux/irqreturn.h>
>> @@ -366,4 +370,5 @@ static inline int vgic_v3_probe(struct device_node *vgic_node,
>>  }
>>  #endif
>>  
>> +#endif	/* old VGIC include */
>>  #endif
>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>> new file mode 100644
>> index 0000000..39933ee
>> --- /dev/null
>> +++ b/include/kvm/vgic/vgic.h
>> @@ -0,0 +1,201 @@
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
>> +#ifndef __ASM_ARM_KVM_VGIC_VGIC_H
>> +#define __ASM_ARM_KVM_VGIC_VGIC_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/kvm.h>
>> +#include <linux/irqreturn.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/types.h>
>> +#include <kvm/iodev.h>
>> +
>> +#define VGIC_V3_MAX_CPUS	255
>> +#define VGIC_V2_MAX_CPUS	8
>> +#define VGIC_NR_IRQS_LEGACY     256
>> +#define VGIC_NR_SGIS		16
>> +#define VGIC_NR_PPIS		16
>> +#define VGIC_NR_PRIVATE_IRQS	(VGIC_NR_SGIS + VGIC_NR_PPIS)
>> +#define VGIC_MAX_PRIVATE	(VGIC_NR_PRIVATE_IRQS - 1)
>> +#define VGIC_MAX_SPI		1019
>> +#define VGIC_MAX_RESERVED	1023
>> +#define VGIC_MIN_LPI		8192
>> +
>> +enum vgic_type {
>> +	VGIC_V2,		/* Good ol' GICv2 */
>> +	VGIC_V3,		/* New fancy GICv3 */
>> +};
>> +
>> +/* same for all guests, as depending only on the _host's_ GIC model */
>> +struct vgic_global {
>> +	/* type of the host GIC */
>> +	enum vgic_type		type;
>> +
>> +	/* Physical address of vgic virtual cpu interface */
>> +	phys_addr_t		vcpu_base;
>> +
>> +	/* virtual control interface mapping */
>> +	void __iomem		*vctrl_base;
>> +
>> +	/* Number of implemented list registers */
>> +	int			nr_lr;
>> +
>> +	/* Maintenance IRQ number */
> 
> nit: this is the physial INTID, right?
> 
>> +	unsigned int		maint_irq;

No, this is the actual Linux IRQ number.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
