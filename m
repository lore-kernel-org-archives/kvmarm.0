Return-Path: <SRS0=1Ej7=XV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0BBC4360C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 15:57:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 284D9222C6
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 15:57:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 284D9222C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DFB64A738;
	Thu, 26 Sep 2019 11:57:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SOxsB-cAmErS; Thu, 26 Sep 2019 11:57:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A1B4A73A;
	Thu, 26 Sep 2019 11:57:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 446184A736
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 11:57:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zrIRnjGPDrOx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Sep 2019 11:57:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE5E4A734
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 11:57:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4889828;
 Thu, 26 Sep 2019 08:57:35 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 79F5E3F534; Thu, 26 Sep 2019 08:57:34 -0700 (PDT)
Subject: Re: [PATCH 10/35] irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER)
 allocation
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-11-maz@kernel.org>
 <155660c2-7f30-e188-ca8d-c37fabea6d97@huawei.com>
 <6f4ccdfd-4b63-04cb-e7c0-f069e620127f@kernel.org>
 <14111988-74c9-12c3-1322-1580ff6ba11f@huawei.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <c4d63ccd-b5b2-007f-6174-1a9d20f3669d@kernel.org>
Date: Thu, 26 Sep 2019 16:57:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <14111988-74c9-12c3-1322-1580ff6ba11f@huawei.com>
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

On 26/09/2019 16:19, Zenghui Yu wrote:
> Hi Marc,
> 
> Two more questions below.
> 
> On 2019/9/25 22:41, Marc Zyngier wrote:
>> On 25/09/2019 14:04, Zenghui Yu wrote:
>>> Hi Marc,
>>>
>>> Some questions about this patch, mostly to confirm that I would
>>> understand things here correctly.
>>>
>>> On 2019/9/24 2:25, Marc Zyngier wrote:
>>>> GICv4.1 defines a new VPE table that is potentially shared between
>>>> both the ITSs and the redistributors, following complicated affinity
>>>> rules.
>>>>
>>>> To make things more confusing, the programming of this table at
>>>> the redistributor level is reusing the GICv4.0 GICR_VPROPBASER register
>>>> for something completely different.
>>>>
>>>> The code flow is somewhat complexified by the need to respect the
>>>> affinities required by the HW, meaning that tables can either be
>>>> inherited from a previously discovered ITS or redistributor.
>>>>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>
>>> [...]
>>>
>>>> @@ -1962,6 +1965,65 @@ static bool its_parse_indirect_baser(struct its_node *its,
>>>>    	return indirect;
>>>>    }
>>>>    
>>>> +static u32 compute_common_aff(u64 val)
>>>> +{
>>>> +	u32 aff, clpiaff;
>>>> +
>>>> +	aff = FIELD_GET(GICR_TYPER_AFFINITY, val);
>>>> +	clpiaff = FIELD_GET(GICR_TYPER_COMMON_LPI_AFF, val);
>>>> +
>>>> +	return aff & ~(GENMASK(31, 0) >> (clpiaff * 8));
>>>> +}
>>>> +
>>>> +static u32 compute_its_aff(struct its_node *its)
>>>> +{
>>>> +	u64 val;
>>>> +	u32 svpet;
>>>> +
>>>> +	/*
>>>> +	 * Reencode the ITS SVPET and MPIDR as a GICR_TYPER, and compute
>>>> +	 * the resulting affinity. We then use that to see if this match
>>>> +	 * our own affinity.
>>>> +	 */
>>>> +	svpet = FIELD_GET(GITS_TYPER_SVPET, its->typer);
> 
> The spec says, ITS does not share vPE table with Redistributors when
> SVPET==0.  It seems that we miss this rule and simply regard SVPET as
> GICR_TYPER_COMMON_LPI_AFF here.  Am I wrong?

Correct. I missed the case where the ITS doesn't share anything. That's
pretty unlikely though (you loose all the benefit of v4.1, and I don't
really see how you'd make it work reliably).

> 
>>>> +	val  = FIELD_PREP(GICR_TYPER_COMMON_LPI_AFF, svpet);
>>>> +	val |= FIELD_PREP(GICR_TYPER_AFFINITY, its->mpidr);
>>>> +	return compute_common_aff(val);
>>>> +}
>>>> +
>>>> +static struct its_node *find_sibbling_its(struct its_node *cur_its)
>>>> +{
>>>> +	struct its_node *its;
>>>> +	u32 aff;
>>>> +
>>>> +	if (!FIELD_GET(GITS_TYPER_SVPET, cur_its->typer))
>>>> +		return NULL;
>>>> +
>>>> +	aff = compute_its_aff(cur_its);
>>>> +
>>>> +	list_for_each_entry(its, &its_nodes, entry) {
>>>> +		u64 baser;
>>>> +
>>>> +		if (!is_v4_1(its) || its == cur_its)
>>>> +			continue;
>>>> +
>>>> +		if (!FIELD_GET(GITS_TYPER_SVPET, its->typer))
>>>> +			continue;
>>>> +
>>>> +		if (aff != compute_its_aff(its))
>>>> +			continue;
>>>> +
>>>> +		/* GICv4.1 guarantees that the vPE table is GITS_BASER2 */
>>>> +		baser = its->tables[2].val;
>>>> +		if (!(baser & GITS_BASER_VALID))
>>>> +			continue;
>>>> +
>>>> +		return its;
>>>> +	}
>>>> +
>>>> +	return NULL;
>>>> +}
>>>> +
>>>>    static void its_free_tables(struct its_node *its)
>>>>    {
>>>>    	int i;
>>>> @@ -2004,6 +2066,15 @@ static int its_alloc_tables(struct its_node *its)
>>>>    			break;
>>>>    
>>>>    		case GITS_BASER_TYPE_VCPU:
>>>> +			if (is_v4_1(its)) {
>>>> +				struct its_node *sibbling;
>>>> +
>>>> +				if ((sibbling = find_sibbling_its(its))) {
>>>> +					its->tables[2] = sibbling->tables[2];
>>>
>>> This means thst the vPE table is shared between ITSs which are under the
>>> same affinity group?
>>
>> That's indeed what this is trying to do...
>>
>>> Don't we need to set GITS_BASER (by its_setup_baser()) here to tell this
>>> ITS where the vPE table lacates?
>>
>> Absolutely. This is a bug. I didn't spot it as my model only has a
>> single ITS.
>>
>>>
>>>> +					continue;
>>>> +				}
>>>> +			}
>>>> +
>>>>    			indirect = its_parse_indirect_baser(its, baser,
>>>>    							    psz, &order,
>>>>    							    ITS_MAX_VPEID_BITS);
>>>> @@ -2025,6 +2096,212 @@ static int its_alloc_tables(struct its_node *its)
>>>>    	return 0;
>>>>    }
>>>>    
>>>> +static u64 inherit_vpe_l1_table_from_its(void)
>>>> +{
>>>> +	struct its_node *its;
>>>> +	u64 val;
>>>> +	u32 aff;
>>>> +
>>>> +	val = gic_read_typer(gic_data_rdist_rd_base() + GICR_TYPER);
>>>> +	aff = compute_common_aff(val);
>>>> +
>>>> +	list_for_each_entry(its, &its_nodes, entry) {
>>>> +		u64 baser;
>>>> +
>>>> +		if (!is_v4_1(its))
>>>> +			continue;
>>>> +
>>>> +		if (!FIELD_GET(GITS_TYPER_SVPET, its->typer))
>>>> +			continue;
>>>> +
>>>> +		if (aff != compute_its_aff(its))
>>>> +			continue;
>>>> +
>>>> +		/* GICv4.1 guarantees that the vPE table is GITS_BASER2 */
>>>> +		baser = its->tables[2].val;
>>>> +		if (!(baser & GITS_BASER_VALID))
>>>> +			continue;
>>>> +
>>>> +		/* We have a winner! */
>>>> +		val  = GICR_VPROPBASER_4_1_VALID;
>>>> +		if (baser & GITS_BASER_INDIRECT)
>>>> +			val |= GICR_VPROPBASER_4_1_INDIRECT;
>>>> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_PAGE_SIZE,
>>>> +				  FIELD_GET(GITS_BASER_PAGE_SIZE_MASK, baser));
>>>> +		val |= FIELD_PREP(GICR_VPROPBASER_4_1_ADDR,
>>>> +				  GITS_BASER_ADDR_48_to_52(baser) >> 12);
>>>
>>> I remember the spec says,
>>> GITS_BASER2 "points to" the ITS *vPE table*, which provides mappings
>>> from the vPEID to target Redistributor and associated vpt address.
>>> In GICv4.1 GICR_VPROPBASER "points to" the *vPE Configuration table*,
>>> which stores the locations of each vPE's LPI configuration and pending
>>> table.
>>>
>>> And the code here says, if we can find an ITS (which is under the same
>>> CommonLPIAff group with this Redistributor) has already been probed and
>>> allocated an vPE table, then use this vPE table as this Redist's vPE
>>> Configuration table.
>>> So I infer that in GICv4.1, *vPE table* and *vPE Configuration table*
>>> are actually the same concept?  And this table is shared between ITSs
>>> and Redists which are under the same affinity group?
>>> Please fix me if I have any misunderstanding.
>>
>> Indeed. The whole idea is that ITSs and RDs can share a vPE table if
>> they are in the same affinity group (such as a socket, for example).
>> This is what is missing from v4.0 where the ITS knows about vPEs, but
>> doesn't know about residency. With that in place, the HW is able to do a
>> lot more for us.
> 
> Thanks for your education!
> 
> I really want to know *how* does GICv4.1 ITS know about the vPE
> residency (in hardware level)?

Hey, I'm a SW guy, I don't design the hardware! ;-)

> I can understand that Redistributor can easily achieve it by
> VPENDBASER's Valid and vPEID field.  And it's necessary for ITS to
> know the residency so that it can determine whether it's appropriate
> to trigger default doorbell for vPE.  But I have no knowledge about
> how can it be achieved in hardware details.

My take is that the RD and the ITS can communicate over the shared
table, hence my remark above about SVPET==0. But as I said, I'm not a HW
guy.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
