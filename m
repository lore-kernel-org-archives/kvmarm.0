Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAF7C432C2
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 14:41:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A0BB2146E
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 14:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A0BB2146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 949194A524;
	Wed, 25 Sep 2019 10:41:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wtpVMMdwbZUz; Wed, 25 Sep 2019 10:41:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF4E4A66F;
	Wed, 25 Sep 2019 10:41:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9698C4A524
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 10:41:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qr7b0+3bBya7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 10:41:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E8844A511
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 10:41:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BD351000;
 Wed, 25 Sep 2019 07:41:47 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 00F963F59C; Wed, 25 Sep 2019 07:41:45 -0700 (PDT)
Subject: Re: [PATCH 10/35] irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER)
 allocation
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-11-maz@kernel.org>
 <155660c2-7f30-e188-ca8d-c37fabea6d97@huawei.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <6f4ccdfd-4b63-04cb-e7c0-f069e620127f@kernel.org>
Date: Wed, 25 Sep 2019 15:41:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <155660c2-7f30-e188-ca8d-c37fabea6d97@huawei.com>
Content-Language: en-US
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>
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

On 25/09/2019 14:04, Zenghui Yu wrote:
> Hi Marc,
> 
> Some questions about this patch, mostly to confirm that I would
> understand things here correctly.
> 
> On 2019/9/24 2:25, Marc Zyngier wrote:
>> GICv4.1 defines a new VPE table that is potentially shared between
>> both the ITSs and the redistributors, following complicated affinity
>> rules.
>>
>> To make things more confusing, the programming of this table at
>> the redistributor level is reusing the GICv4.0 GICR_VPROPBASER register
>> for something completely different.
>>
>> The code flow is somewhat complexified by the need to respect the
>> affinities required by the HW, meaning that tables can either be
>> inherited from a previously discovered ITS or redistributor.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
> 
> [...]
> 
>> @@ -1962,6 +1965,65 @@ static bool its_parse_indirect_baser(struct its_node *its,
>>   	return indirect;
>>   }
>>   
>> +static u32 compute_common_aff(u64 val)
>> +{
>> +	u32 aff, clpiaff;
>> +
>> +	aff = FIELD_GET(GICR_TYPER_AFFINITY, val);
>> +	clpiaff = FIELD_GET(GICR_TYPER_COMMON_LPI_AFF, val);
>> +
>> +	return aff & ~(GENMASK(31, 0) >> (clpiaff * 8));
>> +}
>> +
>> +static u32 compute_its_aff(struct its_node *its)
>> +{
>> +	u64 val;
>> +	u32 svpet;
>> +
>> +	/*
>> +	 * Reencode the ITS SVPET and MPIDR as a GICR_TYPER, and compute
>> +	 * the resulting affinity. We then use that to see if this match
>> +	 * our own affinity.
>> +	 */
>> +	svpet = FIELD_GET(GITS_TYPER_SVPET, its->typer);
>> +	val  = FIELD_PREP(GICR_TYPER_COMMON_LPI_AFF, svpet);
>> +	val |= FIELD_PREP(GICR_TYPER_AFFINITY, its->mpidr);
>> +	return compute_common_aff(val);
>> +}
>> +
>> +static struct its_node *find_sibbling_its(struct its_node *cur_its)
>> +{
>> +	struct its_node *its;
>> +	u32 aff;
>> +
>> +	if (!FIELD_GET(GITS_TYPER_SVPET, cur_its->typer))
>> +		return NULL;
>> +
>> +	aff = compute_its_aff(cur_its);
>> +
>> +	list_for_each_entry(its, &its_nodes, entry) {
>> +		u64 baser;
>> +
>> +		if (!is_v4_1(its) || its == cur_its)
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
>> +		return its;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>   static void its_free_tables(struct its_node *its)
>>   {
>>   	int i;
>> @@ -2004,6 +2066,15 @@ static int its_alloc_tables(struct its_node *its)
>>   			break;
>>   
>>   		case GITS_BASER_TYPE_VCPU:
>> +			if (is_v4_1(its)) {
>> +				struct its_node *sibbling;
>> +
>> +				if ((sibbling = find_sibbling_its(its))) {
>> +					its->tables[2] = sibbling->tables[2];
> 
> This means thst the vPE table is shared between ITSs which are under the
> same affinity group?

That's indeed what this is trying to do...

> Don't we need to set GITS_BASER (by its_setup_baser()) here to tell this
> ITS where the vPE table lacates?

Absolutely. This is a bug. I didn't spot it as my model only has a
single ITS.

> 
>> +					continue;
>> +				}
>> +			}
>> +
>>   			indirect = its_parse_indirect_baser(its, baser,
>>   							    psz, &order,
>>   							    ITS_MAX_VPEID_BITS);
>> @@ -2025,6 +2096,212 @@ static int its_alloc_tables(struct its_node *its)
>>   	return 0;
>>   }
>>   
>> +static u64 inherit_vpe_l1_table_from_its(void)
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
> I remember the spec says,
> GITS_BASER2 "points to" the ITS *vPE table*, which provides mappings
> from the vPEID to target Redistributor and associated vpt address.
> In GICv4.1 GICR_VPROPBASER "points to" the *vPE Configuration table*,
> which stores the locations of each vPE's LPI configuration and pending
> table.
> 
> And the code here says, if we can find an ITS (which is under the same
> CommonLPIAff group with this Redistributor) has already been probed and
> allocated an vPE table, then use this vPE table as this Redist's vPE
> Configuration table.
> So I infer that in GICv4.1, *vPE table* and *vPE Configuration table*
> are actually the same concept?  And this table is shared between ITSs
> and Redists which are under the same affinity group?
> Please fix me if I have any misunderstanding.

Indeed. The whole idea is that ITSs and RDs can share a vPE table if
they are in the same affinity group (such as a socket, for example).
This is what is missing from v4.0 where the ITS knows about vPEs, but
doesn't know about residency. With that in place, the HW is able to do a
lot more for us.

> 
>> +		val |= FIELD_PREP(GICR_VPROPBASER_SHAREABILITY_MASK,
>> +				  FIELD_GET(GITS_BASER_SHAREABILITY_MASK, baser));
>> +		val |= FIELD_PREP(GICR_VPROPBASER_INNER_CACHEABILITY_MASK,
>> +				  FIELD_GET(GITS_BASER_INNER_CACHEABILITY_MASK, baser));
>> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_SIZE, GITS_BASER_NR_PAGES(baser) - 1);
>> +
>> +		return val;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static u64 inherit_vpe_l1_table_from_rd(cpumask_t **mask)
>> +{
>> +	u32 aff;
>> +	u64 val;
>> +	int cpu;
>> +
>> +	val = gic_read_typer(gic_data_rdist_rd_base() + GICR_TYPER);
>> +	aff = compute_common_aff(val);
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		void __iomem *base = gic_data_rdist_cpu(cpu)->rd_base;
>> +		u32 tmp;
>> +
>> +		if (!base || cpu == smp_processor_id())
>> +			continue;
>> +
>> +		val = gic_read_typer(base + GICR_TYPER);
>> +		tmp = compute_common_aff(val);
>> +		if (tmp != aff)
>> +			continue;
>> +
>> +		/*
>> +		 * At this point, we have a victim. This particular CPU
>> +		 * has already booted, and has an affinity that matches
>> +		 * ours wrt CommonLPIAff. Let's use its own VPROPBASER.
>> +		 * Make sure we don't write the Z bit in that case.
>> +		 */
>> +		val = gits_read_vpropbaser(base + SZ_128K + GICR_VPROPBASER);
>> +		val &= ~GICR_VPROPBASER_4_1_Z;
>> +
>> +		*mask = gic_data_rdist_cpu(cpu)->vpe_table_mask;
>> +
>> +		return val;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int allocate_vpe_l1_table(void)
>> +{
>> +	void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
>> +	u64 val, esz, gpsz, npg, pa;
>> +	unsigned int psz = SZ_64K;
>> +	unsigned int np, epp;
>> +	struct page *page;
>> +
>> +	if (!gic_rdists->has_rvpeid)
>> +		return 0;
>> +
>> +	/*
>> +	 * if VPENDBASER.Valid is set, disable any previously programmed
>> +	 * VPE by setting PendingLast while clearing Valid. This has the
>> +	 * effect of making sure no doorbell will be generated and we can
>> +	 * then safely clear VPROPBASER.Valid.
>> +	 */
>> +	if (gits_read_vpendbaser(vlpi_base + GICR_VPENDBASER) & GICR_VPENDBASER_Valid)
>> +		gits_write_vpendbaser(GICR_VPENDBASER_PendingLast,
>> +				      vlpi_base + GICR_VPENDBASER);
>> +
>> +	/*
>> +	 * If we can inherit the configuration from another RD, let's do
>> +	 * so. Otherwise, we have to go through the allocation process. We
>> +	 * assume that all RDs have the exact same requirements, as
>> +	 * nothing will work otherwise.
>> +	 */
>> +	val = inherit_vpe_l1_table_from_rd(&gic_data_rdist()->vpe_table_mask);
>> +	if (val & GICR_VPROPBASER_4_1_VALID)
>> +		goto out;
>> +
>> +	gic_data_rdist()->vpe_table_mask = kzalloc(sizeof(cpumask_t), GFP_KERNEL);
> 
> I think we should check the allocation failure here.

Sure.

> 
>> +
>> +	val = inherit_vpe_l1_table_from_its();
>> +	if (val & GICR_VPROPBASER_4_1_VALID)
>> +		goto out;
>> +
>> +	/* First probe the page size */
>> +	val = FIELD_PREP(GICR_VPROPBASER_4_1_PAGE_SIZE, GIC_PAGE_SIZE_64K);
>> +	gits_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
>> +	val = gits_read_vpropbaser(vlpi_base + GICR_VPROPBASER);
>> +	gpsz = FIELD_GET(GICR_VPROPBASER_4_1_PAGE_SIZE, val);
>> +
>> +	switch (gpsz) {
>> +	default:
>> +		gpsz = GIC_PAGE_SIZE_4K;
>> +		/* fall through */
>> +	case GIC_PAGE_SIZE_4K:
>> +		psz = SZ_4K;
>> +		break;
>> +	case GIC_PAGE_SIZE_16K:
>> +		psz = SZ_16K;
>> +		break;
>> +	case GIC_PAGE_SIZE_64K:
>> +		psz = SZ_64K;
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * Start populating the register from scratch, including RO fields
>> +	 * (which we want to print in debug cases...)
>> +	 */
>> +	val = 0;
>> +	val |= FIELD_PREP(GICR_VPROPBASER_4_1_PAGE_SIZE, gpsz);
>> +	esz = FIELD_GET(GICR_VPROPBASER_4_1_ENTRY_SIZE, val);
>> +	val |= FIELD_PREP(GICR_VPROPBASER_4_1_ENTRY_SIZE, esz);
> 
> 'esz' seems always be 0 here?

Yup, that's broken. Not sure what I had in mind here. esz (element size)
should be extracted before resetting val, and ORed back in the register
copy for debug purposes.

> 
>> +
>> +	/* How many entries per GIC page? */
>> +	esz++;
>> +	epp = psz / (esz * SZ_8);
>> +
>> +	/*
>> +	 * If we need more than just a single L1 page, flag the table
>> +	 * as indirect and compute the number of required L1 pages.
>> +	 */
>> +	if (epp < ITS_MAX_VPEID) {
>> +		int nl2;
>> +
>> +		gic_rdists->flags |= RDIST_FLAGS_VPE_INDIRECT;
>> +		val |= GICR_VPROPBASER_4_1_INDIRECT;
>> +
>> +		/* Number of L2 pages required to cover the VPEID space */
>> +		nl2 = DIV_ROUND_UP(ITS_MAX_VPEID, epp);
>> +
>> +		/* Number of L1 pages to point to the L2 pages */
>> +		npg = DIV_ROUND_UP(nl2 * SZ_8, psz);
>> +	} else {
>> +		npg = 1;
>> +	}
>> +
>> +	val |= FIELD_PREP(GICR_VPROPBASER_4_1_SIZE, npg);
>> +
>> +	/* Right, that's the number of CPU pages we need for L1 */
>> +	np = DIV_ROUND_UP(npg * psz, PAGE_SIZE);
>> +
>> +	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %lld\n",
>> +		 np, npg, psz, epp, esz);
>> +	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(np * PAGE_SIZE));
>> +	if (!page)
>> +		return -ENOMEM;
>> +
>> +	gic_data_rdist()->vpe_l1_page = page;
>> +	pa = virt_to_phys(page_address(page));
>> +	WARN_ON(!IS_ALIGNED(pa, psz));
>> +
>> +	val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR, pa >> 12);
>> +	val |= GICR_VPROPBASER_RaWb;
>> +	val |= GICR_VPROPBASER_InnerShareable;
>> +	val |= GICR_VPROPBASER_4_1_Z;
>> +	val |= GICR_VPROPBASER_4_1_VALID;
>> +
>> +out:
>> +	gits_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
>> +	cpumask_set_cpu(smp_processor_id(), gic_data_rdist()->vpe_table_mask);
>> +
>> +	pr_debug("CPU%d: VPROPBASER = %llx %*pbl\n",
>> +		 smp_processor_id(), val,
>> +		 cpumask_pr_args(gic_data_rdist()->vpe_table_mask));
>> +
>> +	return 0;
>> +}
>> +
>>   static int its_alloc_collections(struct its_node *its)
>>   {
>>   	int i;
>> @@ -2224,7 +2501,7 @@ static void its_cpu_init_lpis(void)
>>   	val |= GICR_CTLR_ENABLE_LPIS;
>>   	writel_relaxed(val, rbase + GICR_CTLR);
>>   
>> -	if (gic_rdists->has_vlpis) {
>> +	if (gic_rdists->has_vlpis && !gic_rdists->has_rvpeid) {
>>   		void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
>>   
>>   		/*
>> @@ -2248,6 +2525,16 @@ static void its_cpu_init_lpis(void)
>>   		WARN_ON(val & GICR_VPENDBASER_Dirty);
>>   	}
>>   
>> +	if (allocate_vpe_l1_table()) {
>> +		/*
>> +		 * If the allocation has failed, we're in massive trouble.
>> +		 * Disable direct injection, and pray that no VM was
>> +		 * already running...
>> +		 */
>> +		gic_rdists->has_rvpeid = false;
>> +		gic_rdists->has_vlpis = false;
>> +	}
>> +
>>   	/* Make sure the GIC has seen the above */
>>   	dsb(sy);
>>   out:

Thanks for having had a look!

        M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
