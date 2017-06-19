From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 01/33] irqchip/gic-v3: Add redistributor iterator
Date: Mon, 19 Jun 2017 16:26:54 +0100
Message-ID: <7c317604-3161-3650-f736-8638f4ff1a5a@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-2-git-send-email-marc.zyngier@arm.com>
 <22a9cb20-f5f0-20e7-e34c-f14847a35e5e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8264C40A69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:22:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Aaqnxk+Xsjlg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jun 2017 11:22:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1851D40A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:22:27 -0400 (EDT)
In-Reply-To: <22a9cb20-f5f0-20e7-e34c-f14847a35e5e@redhat.com>
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

On 16/02/17 12:47, Auger Eric wrote:
> Hi Marc,
> 
> On 17/01/2017 11:20, Marc Zyngier wrote:
>> In order to discover the VLPI properties, we need to iterate over
>> the redistributor regions. As we already have code that does this,
>> let's factor it out and make it slightly more generic.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic-v3.c | 77 ++++++++++++++++++++++++++++++++------------
>>  1 file changed, 56 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index c132f29..5cadec0 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c
>> @@ -421,24 +421,15 @@ static void __init gic_dist_init(void)
>>  		gic_write_irouter(affinity, base + GICD_IROUTER + i * 8);
>>  }
>>  
>> -static int gic_populate_rdist(void)
>> +static int gic_scan_rdist_properties(int (*fn)(struct redist_region *,
>> +					       void __iomem *))
>>  {
>> -	unsigned long mpidr = cpu_logical_map(smp_processor_id());
>> -	u64 typer;
>> -	u32 aff;
>> +	int ret = 0;
> in case
> if (reg != GIC_PIDR2_ARCH_GICv3 &&
> 		    reg != GIC_PIDR2_ARCH_GICv4) is true you now return 0. Don' you
> want to return -ENODEV as before?
> 
> 
>>  	int i;
>>  
>> -	/*
>> -	 * Convert affinity to a 32bit value that can be matched to
>> -	 * GICR_TYPER bits [63:32].
>> -	 */
>> -	aff = (MPIDR_AFFINITY_LEVEL(mpidr, 3) << 24 |
>> -	       MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16 |
>> -	       MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8 |
>> -	       MPIDR_AFFINITY_LEVEL(mpidr, 0));
>> -
>>  	for (i = 0; i < gic_data.nr_redist_regions; i++) {
>>  		void __iomem *ptr = gic_data.redist_regions[i].redist_base;
>> +		u64 typer;
>>  		u32 reg;
>>  
>>  		reg = readl_relaxed(ptr + GICR_PIDR2) & GIC_PIDR2_ARCH_MASK;
>> @@ -450,14 +441,14 @@ static int gic_populate_rdist(void)
>>  
>>  		do {
>>  			typer = gic_read_typer(ptr + GICR_TYPER);
>> -			if ((typer >> 32) == aff) {
>> -				u64 offset = ptr - gic_data.redist_regions[i].redist_base;
>> -				gic_data_rdist_rd_base() = ptr;
>> -				gic_data_rdist()->phys_base = gic_data.redist_regions[i].phys_base + offset;
>> -				pr_info("CPU%d: found redistributor %lx region %d:%pa\n",
>> -					smp_processor_id(), mpidr, i,
>> -					&gic_data_rdist()->phys_base);
>> +			ret = fn(gic_data.redist_regions + i, ptr);
>> +			switch (ret) {
>> +			case 0:
>>  				return 0;
>> +			case -1:
>> +				break;
>> +			default:
>> +				ret = 0;
>>  			}
>>  
>>  			if (gic_data.redist_regions[i].single_redist)
>> @@ -473,9 +464,53 @@ static int gic_populate_rdist(void)
>>  		} while (!(typer & GICR_TYPER_LAST));
>>  	}
> Assuming you don't find the TYPER that matches the cpu (I don't know if
> it is possible), last fn() call will return 1 and the function will
> return 0. Before it returned -ENODEV I think.

Yeah, the whole thing was quite messy. I've (hopefully) fixed it now.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
