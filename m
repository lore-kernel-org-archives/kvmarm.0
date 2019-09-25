Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D662C432C2
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 17:14:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A98262146E
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 17:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A98262146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E29B34A663;
	Wed, 25 Sep 2019 13:14:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R1lqgZKRbxtq; Wed, 25 Sep 2019 13:14:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1BF94A679;
	Wed, 25 Sep 2019 13:14:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3C24A663
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 13:14:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fcQ3UC9jvuSi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 13:14:50 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CFFC4A64D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 13:14:50 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iDAsI-0000yZ-Iz; Wed, 25 Sep 2019 19:14:46 +0200
To: Zenghui Yu <yuzenghui@huawei.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/35] irqchip/gic-v4.1: VPE table (aka
 =?UTF-8?Q?GICR=5FVPROPBASER=29=20allocation?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 25 Sep 2019 18:14:46 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <6f4ccdfd-4b63-04cb-e7c0-f069e620127f@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-11-maz@kernel.org>
 <155660c2-7f30-e188-ca8d-c37fabea6d97@huawei.com>
 <6f4ccdfd-4b63-04cb-e7c0-f069e620127f@kernel.org>
Message-ID: <e64126d2adf7ea5fe5c75bd4bcdce6e0@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, lorenzo.pieralisi@arm.com,
 jason@lakedaemon.net
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-09-25 15:41, Marc Zyngier wrote:
> On 25/09/2019 14:04, Zenghui Yu wrote:
>> Hi Marc,
>>
>> Some questions about this patch, mostly to confirm that I would
>> understand things here correctly.
>>
>> On 2019/9/24 2:25, Marc Zyngier wrote:
>>> GICv4.1 defines a new VPE table that is potentially shared between
>>> both the ITSs and the redistributors, following complicated 
>>> affinity
>>> rules.
>>>
>>> To make things more confusing, the programming of this table at
>>> the redistributor level is reusing the GICv4.0 GICR_VPROPBASER 
>>> register
>>> for something completely different.
>>>
>>> The code flow is somewhat complexified by the need to respect the
>>> affinities required by the HW, meaning that tables can either be
>>> inherited from a previously discovered ITS or redistributor.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>
>> [...]
>>
>>> @@ -1962,6 +1965,65 @@ static bool its_parse_indirect_baser(struct 
>>> its_node *its,
>>>   	return indirect;
>>>   }
>>>
>>> +static u32 compute_common_aff(u64 val)
>>> +{
>>> +	u32 aff, clpiaff;
>>> +
>>> +	aff = FIELD_GET(GICR_TYPER_AFFINITY, val);
>>> +	clpiaff = FIELD_GET(GICR_TYPER_COMMON_LPI_AFF, val);
>>> +
>>> +	return aff & ~(GENMASK(31, 0) >> (clpiaff * 8));
>>> +}
>>> +
>>> +static u32 compute_its_aff(struct its_node *its)
>>> +{
>>> +	u64 val;
>>> +	u32 svpet;
>>> +
>>> +	/*
>>> +	 * Reencode the ITS SVPET and MPIDR as a GICR_TYPER, and compute
>>> +	 * the resulting affinity. We then use that to see if this match
>>> +	 * our own affinity.
>>> +	 */
>>> +	svpet = FIELD_GET(GITS_TYPER_SVPET, its->typer);
>>> +	val  = FIELD_PREP(GICR_TYPER_COMMON_LPI_AFF, svpet);
>>> +	val |= FIELD_PREP(GICR_TYPER_AFFINITY, its->mpidr);
>>> +	return compute_common_aff(val);
>>> +}
>>> +
>>> +static struct its_node *find_sibbling_its(struct its_node 
>>> *cur_its)
>>> +{
>>> +	struct its_node *its;
>>> +	u32 aff;
>>> +
>>> +	if (!FIELD_GET(GITS_TYPER_SVPET, cur_its->typer))
>>> +		return NULL;
>>> +
>>> +	aff = compute_its_aff(cur_its);
>>> +
>>> +	list_for_each_entry(its, &its_nodes, entry) {
>>> +		u64 baser;
>>> +
>>> +		if (!is_v4_1(its) || its == cur_its)
>>> +			continue;
>>> +
>>> +		if (!FIELD_GET(GITS_TYPER_SVPET, its->typer))
>>> +			continue;
>>> +
>>> +		if (aff != compute_its_aff(its))
>>> +			continue;
>>> +
>>> +		/* GICv4.1 guarantees that the vPE table is GITS_BASER2 */
>>> +		baser = its->tables[2].val;
>>> +		if (!(baser & GITS_BASER_VALID))
>>> +			continue;
>>> +
>>> +		return its;
>>> +	}
>>> +
>>> +	return NULL;
>>> +}
>>> +
>>>   static void its_free_tables(struct its_node *its)
>>>   {
>>>   	int i;
>>> @@ -2004,6 +2066,15 @@ static int its_alloc_tables(struct its_node 
>>> *its)
>>>   			break;
>>>
>>>   		case GITS_BASER_TYPE_VCPU:
>>> +			if (is_v4_1(its)) {
>>> +				struct its_node *sibbling;
>>> +
>>> +				if ((sibbling = find_sibbling_its(its))) {
>>> +					its->tables[2] = sibbling->tables[2];
>>
>> This means thst the vPE table is shared between ITSs which are under 
>> the
>> same affinity group?
>
> That's indeed what this is trying to do...
>
>> Don't we need to set GITS_BASER (by its_setup_baser()) here to tell 
>> this
>> ITS where the vPE table lacates?
>
> Absolutely. This is a bug. I didn't spot it as my model only has a
> single ITS.

FWIW, I've pushed out an updated branch with this fixed as well as the 
rest of the comments you had.

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
