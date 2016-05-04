From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 18/54] KVM: arm/arm64: vgic-new: Add GICv3 world switch
 backend
Date: Wed, 4 May 2016 14:30:34 +0100
Message-ID: <5729F97A.1090909@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-19-git-send-email-andre.przywara@arm.com>
 <5728CEDC.9080308@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE2B449B3D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2016 09:27:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CVe8v7kLzJ3B for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2016 09:27:28 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D8849B32
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2016 09:27:27 -0400 (EDT)
In-Reply-To: <5728CEDC.9080308@arm.com>
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

On 03/05/16 17:16, Marc Zyngier wrote:
> On 28/04/16 17:45, Andre Przywara wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> As the GICv3 virtual interface registers differ from their GICv2
>> siblings, we need different handlers for processing maintenance
>> interrupts and reading/writing to the LRs.
>> Implement the respective handler functions and connect them to
>> existing code to be called if the host is using a GICv3.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - remove outdated comment about the dist_lock
>> - add WARN_ON about LR_STATE not being 0 in maintenance interrupts
>>
>> Changelog v1 .. v2:
>> - inject the IRQ priority into the list register
>>
>>  include/linux/irqchip/arm-gic-v3.h |   1 +
>>  virt/kvm/arm/vgic/vgic-v3.c        | 169 +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.c           |  25 ++++--
>>  virt/kvm/arm/vgic/vgic.h           |  29 +++++++
>>  4 files changed, 219 insertions(+), 5 deletions(-)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index d5d798b..56fd2c5 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -275,6 +275,7 @@
>>  #define ICH_LR_ACTIVE_BIT		(1ULL << 63)
>>  #define ICH_LR_PHYS_ID_SHIFT		32
>>  #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
>> +#define ICH_LR_PRIORITY_SHIFT		48
>>  
>>  #define ICH_MISR_EOI			(1 << 0)
>>  #define ICH_MISR_U			(1 << 1)
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> new file mode 100644
>> index 0000000..461229b
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -0,0 +1,169 @@
>> +/*
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
>> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/irqchip/arm-gic.h>
> 
> This last line is definitely a (copy-paste) bug. We should never include
> both GIC headers in the same file. Can you please drop that line and
> have the following hunk instead?
> 
> +/* These are for GICv2 emulation only */
> +#define GICH_LR_VIRTUALID		(0x3ffUL << 0)
> +#define GICH_LR_PHYSID_CPUID_SHIFT	(10)
> +#define GICH_LR_PHYSID_CPUID		(7UL << GICH_LR_PHYSID_CPUID_SHIFT)
> +#define ICH_LR_VIRTUALID_MASK		(BIT_ULL(32) - 1)
> +

What about including those lines (except the last one) in arm-gic-v3.h
then? In fact they describe a property of an _GICv3_ LR, even if it is
only a compatibility feature.
That would be cleaner IMHO than repeating the definitions here in a .c
file and we would automatically get the right definitions by just
including arm-gic-v3.h.

This just compiled fine for me for both the old and new VGIC.
I can send the patch (needs to be a separate patch because it touches
the old VGIC as well) if you agree on that idea.

Cheers,
Andre.

> 
> which is similar to what we have in the old implementation, for the
> exact same reason.
> 
> Thanks,
> 
> 	M.
> 
