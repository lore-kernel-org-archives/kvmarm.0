From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 23/33] irqchip/gic-v3-its: Add VPENDBASER/VPROPBASER
 accessors
Date: Mon, 19 Jun 2017 16:03:36 +0100
Message-ID: <cdcdfc76-a914-49f2-3744-c711710ee868@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-24-git-send-email-marc.zyngier@arm.com>
 <29ab17b1-40c3-205b-cb6a-ea6fdbc96ac9@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC01040A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 10:59:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X9KKLcyQRHn9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jun 2017 10:59:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A779D40190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 10:59:09 -0400 (EDT)
In-Reply-To: <29ab17b1-40c3-205b-cb6a-ea6fdbc96ac9@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: shankerd@codeaurora.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 13/02/17 23:39, Shanker Donthineni wrote:
> Hi Marc,
> 
> 
> On 01/17/2017 04:20 AM, Marc Zyngier wrote:
>> V{PEND,PROP}BASER being 64bit registers, they need some ad-hoc
>> accessors on 32bit, specially given that VPENDBASER contains
>> a Valid bit, making the access a bit convoluted.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   arch/arm/include/asm/arch_gicv3.h   | 28 ++++++++++++++++++++++++++++
>>   arch/arm64/include/asm/arch_gicv3.h |  5 +++++
>>   2 files changed, 33 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/arch_gicv3.h
>> b/arch/arm/include/asm/arch_gicv3.h
>> index 2747590..3f18832 100644
>> --- a/arch/arm/include/asm/arch_gicv3.h
>> +++ b/arch/arm/include/asm/arch_gicv3.h
>> @@ -291,5 +291,33 @@ static inline u64 __gic_readq_nonatomic(const
>> volatile void __iomem *addr)
>>    */
>>   #define gits_write_cwriter(v, c)	__gic_writeq_nonatomic(v, c)
>>   
>> +/*
>> + * GITS_VPROPBASER - hi and lo bits may be accessed independently.
>> + */
>> +#define gits_write_vpropbaser(v, c)	__gic_writeq_nonatomic(v, c)
>> +
>> +/*
>> + * GITS_VPENDBASER - the Valid bit must be cleared before changing
>> + * anything else.
>> + */
>> +static inline void gits_write_vpendbaser(u64 val, void * __iomem addr)
>> +{
>> +	u32 tmp;
>> +
>> +	tmp = readl_relaxed(addr + 4);
>> +	if (tmp & GICR_PENDBASER_Valid) {
>> +		tmp &= ~GICR_PENDBASER_Valid;
>> +		writel_relaxed(tmp, addr + 4);
>> +	}
>> +
>> +	/*
>> +	 * Use the fact that __gic_writeq_nonatomic writes the second
>> +	 * half of the 64bit quantity after the first.
>> +	 */
>> +	__gic_writeq_nonatomic(val, addr);
> I'm not sure whether software has to check a register write pending bit 
> GICR_CTLR.RWP or not. GICv3 spec says, the effect of a write to 
> GICR_VPENDBASER register is not guaranteed to be visible throughout the 
> affinity hierarchy,as indicated by GICR_CTLR.RWP == 0.

Yeah, that's a bit odd, and I've raised this internally. GICR_CTLR.RWP
doesn't mention anything about GICR_VPENDBASER at all, and this makes me
think that it could be a leftover from an earlier spec...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
