From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 15/33] irqchip/gic-v4: Add management structure
 definitions
Date: Mon, 19 Jun 2017 16:48:55 +0100
Message-ID: <829aa384-f6cc-4906-27a2-7d4c3c42726a@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-16-git-send-email-marc.zyngier@arm.com>
 <d5ebd612-96f0-943e-df01-28251c77c327@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CCA140A69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:44:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r1fYoOihubow for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jun 2017 11:44:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC82140A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:44:28 -0400 (EDT)
In-Reply-To: <d5ebd612-96f0-943e-df01-28251c77c327@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/03/17 08:58, Auger Eric wrote:
> Hi,
> 
> On 17/01/2017 11:20, Marc Zyngier wrote:
>> Add a bunch of GICv4-specific data structures that will get used in
>> subsequent patches.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  include/linux/irqchip/arm-gic-v4.h | 92 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 92 insertions(+)
>>  create mode 100644 include/linux/irqchip/arm-gic-v4.h
>>
>> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
>> new file mode 100644
>> index 0000000..6e9c2b3
>> --- /dev/null
>> +++ b/include/linux/irqchip/arm-gic-v4.h
>> @@ -0,0 +1,92 @@
>> +/*
>> + * Copyright (C) 2016 ARM Limited, All Rights Reserved.
>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
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
>> +#ifndef __LINUX_IRQCHIP_ARM_GIC_V4_H
>> +#define __LINUX_IRQCHIP_ARM_GIC_V4_H
>> +
>> +/* Embedded in kvm.arch */
>> +struct its_vm {
>> +	struct irq_domain	*domain;
>> +	struct page		*vprop_page;
>> +	irq_hw_number_t		db_lpi_base;
>> +	unsigned long		*db_bitmap;
>> +	int			nr_db_lpis;
>> +};
>> +
>> +/* Embedded in kvm_vcpu.arch */
>> +struct its_vpe {
>> +	struct page 		*vpt_page;
>> +	struct its_vm		*its_vm;
>> +	irq_hw_number_t		vpe_db_lpi;
>> +	u16			col_idx;
> the role of the collection id remains obscure to me. Are collections
> still used for VLPIs? On VMAPTI the vPE is directly provided whereas on
> MAPTI we used the collection indirection to the actual PE, right? So
> what is it used for?

Nothing to do with VMAPTI. With VMAPP, you need to provide the target
address (either the processor number or the redist base address). Since
I don't really want to expose these gory details, I've settled on using
the collection id as an identifier for the target address (see how VMAPP
is implemented).

>> +	u16			vpe_id;
>> +	bool			idai;
>> +	bool			pending_last;
> where is it used?

That's to be used in the hypervisor to indicate that an interrupt is
actually pending when scheduling the vPE out. This can also be updated
by KVM itself when receiving a doorbell interrupt.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
