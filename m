Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFFDC432C1
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 11:01:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEEF12054F
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 11:01:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEEF12054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77AF54A64E;
	Tue, 24 Sep 2019 07:01:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jp8FhTgeEveG; Tue, 24 Sep 2019 07:01:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8F44A650;
	Tue, 24 Sep 2019 07:01:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E434A609
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 07:01:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZC1cnyYgut4R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 07:01:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C35F4A5CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 07:01:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E1D3142F;
 Tue, 24 Sep 2019 04:01:00 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 97E563F67D; Tue, 24 Sep 2019 04:00:58 -0700 (PDT)
Subject: Re: [PATCH 05/35] irqchip/gic-v3: Add GICv4.1 VPEID size discovery
To: Andrew Murray <andrew.murray@arm.com>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-6-maz@kernel.org>
 <20190924104903.GO9720@e119886-lin.cambridge.arm.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <846924ff-e3ab-5f21-ea52-a44b1548b7ca@kernel.org>
Date: Tue, 24 Sep 2019 12:00:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190924104903.GO9720@e119886-lin.cambridge.arm.com>
Content-Language: en-US
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 24/09/2019 11:49, Andrew Murray wrote:
> On Mon, Sep 23, 2019 at 07:25:36PM +0100, Marc Zyngier wrote:
>> While GICv4.0 mandates 16 bit worth of VPEIDs, GICv4.1 allows smaller
> 
> s/VPEIDs/vPEIDs/
> 
>> implementations to be built. Add the required glue to dynamically
>> compute the limit.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c   | 11 ++++++++++-
>>  drivers/irqchip/irq-gic-v3.c       |  3 +++
>>  include/linux/irqchip/arm-gic-v3.h |  5 +++++
>>  3 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index c94eb287393b..17b77a0b9d97 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -119,7 +119,16 @@ struct its_node {
>>  #define ITS_ITT_ALIGN		SZ_256
>>  
>>  /* The maximum number of VPEID bits supported by VLPI commands */
>> -#define ITS_MAX_VPEID_BITS	(16)
>> +#define ITS_MAX_VPEID_BITS						\
>> +	({								\
>> +		int nvpeid = 16;					\
>> +		if (gic_rdists->has_rvpeid &&				\
> 
> We use rvpeid as a way of determining if this is a GICv4.1, are there any
> other means of determining this? If we use it in this way, is there any
> benefit to having a has_gicv4_1 type of flag instead?

RVPEID *is* the way to discover a GICv4.1. To be clear, if we adopted
the ARM ARM nomenclature to describe extensions, GICv4.1 would be called
GIC-RVPEID, and that'd be it.

> Also for 'insane' configurations we set has_rvpeid to false, thus preventing
> this feature. Does it make sense to do that?

It makes perfect sense. RVPEID *and* VLPI are set to false, and we don't
do *any* direct injection, because it simply cannot work.

> GICD_TYPER2 is reserved in GICv4, however I understand this reads as RES0,
> can we just rely on that instead? (We read it below anyway).

Yes. In general for the GIC, any RESERVED register is RAZ/WI.

> 
>> +		    gic_rdists->gicd_typer2 & GICD_TYPER2_VIL)		\
>> +			nvpeid = 1 + (gic_rdists->gicd_typer2 &		\
>> +				      GICD_TYPER2_VID);			\
>> +									\
>> +		nvpeid;							\
>> +	})
>>  #define ITS_MAX_VPEID		(1 << (ITS_MAX_VPEID_BITS))
>>  
>>  /* Convert page order to size in bytes */
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index 0b545e2c3498..fb6360161d6c 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c
>> @@ -1556,6 +1556,9 @@ static int __init gic_init_bases(void __iomem *dist_base,
>>  
>>  	pr_info("%d SPIs implemented\n", GIC_LINE_NR - 32);
>>  	pr_info("%d Extended SPIs implemented\n", GIC_ESPI_NR);
>> +
>> +	gic_data.rdists.gicd_typer2 = readl_relaxed(gic_data.dist_base + GICD_TYPER2);
>> +
>>  	gic_data.domain = irq_domain_create_tree(handle, &gic_irq_domain_ops,
>>  						 &gic_data);
>>  	irq_domain_update_bus_token(gic_data.domain, DOMAIN_BUS_WIRED);
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index b34e0c113697..71730b9def0c 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -13,6 +13,7 @@
>>  #define GICD_CTLR			0x0000
>>  #define GICD_TYPER			0x0004
>>  #define GICD_IIDR			0x0008
>> +#define GICD_TYPER2			0x000C
>>  #define GICD_STATUSR			0x0010
>>  #define GICD_SETSPI_NSR			0x0040
>>  #define GICD_CLRSPI_NSR			0x0048
>> @@ -89,6 +90,9 @@
>>  #define GICD_TYPER_ESPIS(typer)						\
>>  	(((typer) & GICD_TYPER_ESPI) ? GICD_TYPER_SPIS((typer) >> 27) : 0)
>>  
>> +#define GICD_TYPER2_VIL			(1U << 7)
>> +#define GICD_TYPER2_VID			GENMASK(4, 0)
> 
> Given that the 4th bit is reserved for future expansion and values greater
> than 0xF are reserved, is there value in changing this to GENMASK(3, 0)?

No, I'd rather leave the field to match the specification, and discard
values that go beyond 16 in the ITS_MAX_VPEID_BITS macro.

Thanks,
	
	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
