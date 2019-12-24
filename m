Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D93C2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 09:19:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7988720722
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 09:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7988720722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBB244AF4E;
	Tue, 24 Dec 2019 04:19:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 40FE-ow0-GW4; Tue, 24 Dec 2019 04:19:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C47984AF58;
	Tue, 24 Dec 2019 04:19:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B70AA4AF49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 04:19:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2lER7aga5cnH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 04:19:04 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ED184AF19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 04:19:04 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ijgLE-0007yh-OI; Tue, 24 Dec 2019 10:19:00 +0100
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 11/36] irqchip/gic-v4.1: VPE table (aka
 =?UTF-8?Q?GICR=5FVPROPBASER=29=20allocation?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Tue, 24 Dec 2019 09:19:00 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <61526052-aa00-0769-d5bb-3524161c5650@huawei.com>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-12-maz@kernel.org>
 <61526052-aa00-0769-d5bb-3524161c5650@huawei.com>
Message-ID: <7eb71594ac3617e1a2b58b7537cf3d64@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, eric.auger@redhat.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, tglx@linutronix.de,
 jason@lakedaemon.net, lorenzo.pieralisi@arm.com, andrew.murray@arm.com,
 jnair@marvell.com, rrichter@marvell.com, tangnianyao@huawei.com,
 wangwudi@hisilicon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, wangwudi@hisilicon.com,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Jayachandran C <jnair@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Zenghui,

On 2019-12-24 07:10, Zenghui Yu wrote:
> Hi Marc,
>
> [ +Wudi and Nianyao. As they spotted the following issue but
>  I forgot to send it out. ]
>
> On 2019/10/27 22:42, Marc Zyngier wrote:
>> GICv4.1 defines a new VPE table that is potentially shared between
>> both the ITSs and the redistributors, following complicated affinity
>> rules.
>> To make things more confusing, the programming of this table at
>> the redistributor level is reusing the GICv4.0 GICR_VPROPBASER 
>> register
>> for something completely different.
>> The code flow is somewhat complexified by the need to respect the
>> affinities required by the HW, meaning that tables can either be
>> inherited from a previously discovered ITS or redistributor.
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---[...]
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 40912b3fb0e1..478d3678850c 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
> [...]
>> @@ -2025,6 +2098,214 @@ static int its_alloc_tables(struct its_node 
>> *its)
>>   	return 0;
>>   }
>>   +static u64 inherit_vpe_l1_table_from_its(void)
>> +{
>> +	struct its_node *its;
>> +	u64 val;
>> +	u32 aff;
>> +
>> +	val = gic_read_typer(gic_data_rdist_rd_base() + GICR_TYPER);
>> +	aff = compute_common_aff(val);
>> +
>> +	list_for_each_entry(its, &its_nodes, entry) {
>> +		u64 baser;
>> +
>> +		if (!is_v4_1(its))
>> +			continue;
>> +
>> +		if (!FIELD_GET(GITS_TYPER_SVPET, its->typer))
>> +			continue;
>> +
>> +		if (aff != compute_its_aff(its))
>> +			continue;
>> +
>> +		/* GICv4.1 guarantees that the vPE table is GITS_BASER2 */
>> +		baser = its->tables[2].val;
>> +		if (!(baser & GITS_BASER_VALID))
>> +			continue;
>> +
>> +		/* We have a winner! */
>> +		val  = GICR_VPROPBASER_4_1_VALID;
>> +		if (baser & GITS_BASER_INDIRECT)
>> +			val |= GICR_VPROPBASER_4_1_INDIRECT;
>> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_PAGE_SIZE,
>> +				  FIELD_GET(GITS_BASER_PAGE_SIZE_MASK, baser));
>> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR,
>> +				  GITS_BASER_ADDR_48_to_52(baser) >> 12);
>
> We've used GITS_BASER_ADDR_48_to_52() only in the KVM code where the
> pagesize of ITS table is fixed to 64K.
> It may not work when the pagesize is 4K or 16K?

You're absolutely right, we shouldn't mess with the 52bit macros when
PZ isn't set to 64k. I'm adding the following fix to this patch:

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index e1f8d5f9a0e3..3234bb9fbdbe 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2433,7 +2433,7 @@ static u64 inherit_vpe_l1_table_from_its(void)
  	aff = compute_common_aff(val);

  	list_for_each_entry(its, &its_nodes, entry) {
-		u64 baser;
+		u64 baser, addr;

  		if (!is_v4_1(its))
  			continue;
@@ -2455,8 +2455,15 @@ static u64 inherit_vpe_l1_table_from_its(void)
  			val |= GICR_VPROPBASER_4_1_INDIRECT;
  		val |= FIELD_PREP(GICR_VPROPBASER_4_1_PAGE_SIZE,
  				  FIELD_GET(GITS_BASER_PAGE_SIZE_MASK, baser));
-		val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR,
-				  GITS_BASER_ADDR_48_to_52(baser) >> 12);
+		switch (FIELD_GET(GITS_BASER_PAGE_SIZE_MASK, baser)) {
+		case GIC_PAGE_SIZE_64K:
+			addr = GITS_BASER_ADDR_48_to_52(baser);
+			break;
+		default:
+			addr = baser & GENMASK_ULL(47, 12);
+			break;
+		}
+		val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR, addr >> 12);
  		val |= FIELD_PREP(GICR_VPROPBASER_SHAREABILITY_MASK,
  				  FIELD_GET(GITS_BASER_SHAREABILITY_MASK, baser));
  		val |= FIELD_PREP(GICR_VPROPBASER_INNER_CACHEABILITY_MASK,


Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
