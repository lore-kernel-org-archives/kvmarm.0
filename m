Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3FFC4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 02:04:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14E5920835
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 02:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14E5920835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 798F84A752;
	Thu, 26 Sep 2019 22:04:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W1-x8yE5ZoBl; Thu, 26 Sep 2019 22:04:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 595674A75A;
	Thu, 26 Sep 2019 22:04:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 519724A74F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 22:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ax57bMBh-gdy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Sep 2019 22:04:01 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77C884A73F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 22:04:01 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 089539B626AC6B8ABFFF;
 Fri, 27 Sep 2019 10:03:58 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 27 Sep 2019
 10:03:48 +0800
Subject: Re: [PATCH 10/35] irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER)
 allocation
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-11-maz@kernel.org>
 <155660c2-7f30-e188-ca8d-c37fabea6d97@huawei.com>
 <6f4ccdfd-4b63-04cb-e7c0-f069e620127f@kernel.org>
 <14111988-74c9-12c3-1322-1580ff6ba11f@huawei.com>
 <c4d63ccd-b5b2-007f-6174-1a9d20f3669d@kernel.org>
 <5d915f55-785b-72f5-498b-8c17148dd3a9@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <99e561dc-fe3c-ff8f-7e28-8fc4b66d1209@huawei.com>
Date: Fri, 27 Sep 2019 10:01:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <5d915f55-785b-72f5-498b-8c17148dd3a9@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
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

On 2019/9/27 0:27, Marc Zyngier wrote:
> On 26/09/2019 16:57, Marc Zyngier wrote:
>> On 26/09/2019 16:19, Zenghui Yu wrote:
>>> Hi Marc,
>>>
>>> Two more questions below.
>>>
>>> On 2019/9/25 22:41, Marc Zyngier wrote:
>>>> On 25/09/2019 14:04, Zenghui Yu wrote:
>>>>> Hi Marc,
>>>>>
>>>>> Some questions about this patch, mostly to confirm that I would
>>>>> understand things here correctly.
>>>>>
>>>>> On 2019/9/24 2:25, Marc Zyngier wrote:
>>>>>> GICv4.1 defines a new VPE table that is potentially shared between
>>>>>> both the ITSs and the redistributors, following complicated affinity
>>>>>> rules.
>>>>>>
>>>>>> To make things more confusing, the programming of this table at
>>>>>> the redistributor level is reusing the GICv4.0 GICR_VPROPBASER register
>>>>>> for something completely different.
>>>>>>
>>>>>> The code flow is somewhat complexified by the need to respect the
>>>>>> affinities required by the HW, meaning that tables can either be
>>>>>> inherited from a previously discovered ITS or redistributor.
>>>>>>
>>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>>> ---
>>>>>
>>>>> [...]
>>>>>
>>>>>> @@ -1962,6 +1965,65 @@ static bool its_parse_indirect_baser(struct its_node *its,
>>>>>>     	return indirect;
>>>>>>     }
>>>>>>     
>>>>>> +static u32 compute_common_aff(u64 val)
>>>>>> +{
>>>>>> +	u32 aff, clpiaff;
>>>>>> +
>>>>>> +	aff = FIELD_GET(GICR_TYPER_AFFINITY, val);
>>>>>> +	clpiaff = FIELD_GET(GICR_TYPER_COMMON_LPI_AFF, val);
>>>>>> +
>>>>>> +	return aff & ~(GENMASK(31, 0) >> (clpiaff * 8));
>>>>>> +}
>>>>>> +
>>>>>> +static u32 compute_its_aff(struct its_node *its)
>>>>>> +{
>>>>>> +	u64 val;
>>>>>> +	u32 svpet;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Reencode the ITS SVPET and MPIDR as a GICR_TYPER, and compute
>>>>>> +	 * the resulting affinity. We then use that to see if this match
>>>>>> +	 * our own affinity.
>>>>>> +	 */
>>>>>> +	svpet = FIELD_GET(GITS_TYPER_SVPET, its->typer);
>>>
>>> The spec says, ITS does not share vPE table with Redistributors when
>>> SVPET==0.  It seems that we miss this rule and simply regard SVPET as
>>> GICR_TYPER_COMMON_LPI_AFF here.  Am I wrong?
>>
>> Correct. I missed the case where the ITS doesn't share anything. That's
>> pretty unlikely though (you loose all the benefit of v4.1, and I don't
>> really see how you'd make it work reliably).
> 
> Actually, this is already handled...
> 
>>
>>>
>>>>>> +	val  = FIELD_PREP(GICR_TYPER_COMMON_LPI_AFF, svpet);
>>>>>> +	val |= FIELD_PREP(GICR_TYPER_AFFINITY, its->mpidr);
>>>>>> +	return compute_common_aff(val);
>>>>>> +}
>>>>>> +
>>>>>> +static struct its_node *find_sibbling_its(struct its_node *cur_its)
>>>>>> +{
>>>>>> +	struct its_node *its;
>>>>>> +	u32 aff;
>>>>>> +
>>>>>> +	if (!FIELD_GET(GITS_TYPER_SVPET, cur_its->typer))
>>>>>> +		return NULL;
> 
> ... here. If SVPET is 0, there is no sibling, and we'll allocate a VPE
> table as usual.

Yes, I see.  So we can safely encode the non-zero SVPET as
COMMON_LPI_AFF in a GICR_TYPER when computing the affinity.


Thanks,
zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
