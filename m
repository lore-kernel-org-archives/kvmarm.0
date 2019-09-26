Return-Path: <SRS0=1Ej7=XV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617F9C4360C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 16:27:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E45FF222C9
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 16:27:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E45FF222C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 521AE4A6EC;
	Thu, 26 Sep 2019 12:27:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B-9BHFIIfU4R; Thu, 26 Sep 2019 12:27:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39BCD4A710;
	Thu, 26 Sep 2019 12:27:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9BAC4A6EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 12:27:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VIUc6gsrMgKD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Sep 2019 12:27:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD544A663
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 12:27:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DAF628;
 Thu, 26 Sep 2019 09:27:23 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 1D09E3F534; Thu, 26 Sep 2019 09:27:21 -0700 (PDT)
Subject: Re: [PATCH 10/35] irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER)
 allocation
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-11-maz@kernel.org>
 <155660c2-7f30-e188-ca8d-c37fabea6d97@huawei.com>
 <6f4ccdfd-4b63-04cb-e7c0-f069e620127f@kernel.org>
 <14111988-74c9-12c3-1322-1580ff6ba11f@huawei.com>
 <c4d63ccd-b5b2-007f-6174-1a9d20f3669d@kernel.org>
Openpgp: preference=signencrypt
Autocrypt: addr=maz@kernel.org; prefer-encrypt=mutual; keydata=
 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
 2Y3aFlL+gnr1zUMjlFzD
Organization: Approximate
Message-ID: <5d915f55-785b-72f5-498b-8c17148dd3a9@kernel.org>
Date: Thu, 26 Sep 2019 17:27:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c4d63ccd-b5b2-007f-6174-1a9d20f3669d@kernel.org>
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

On 26/09/2019 16:57, Marc Zyngier wrote:
> On 26/09/2019 16:19, Zenghui Yu wrote:
>> Hi Marc,
>>
>> Two more questions below.
>>
>> On 2019/9/25 22:41, Marc Zyngier wrote:
>>> On 25/09/2019 14:04, Zenghui Yu wrote:
>>>> Hi Marc,
>>>>
>>>> Some questions about this patch, mostly to confirm that I would
>>>> understand things here correctly.
>>>>
>>>> On 2019/9/24 2:25, Marc Zyngier wrote:
>>>>> GICv4.1 defines a new VPE table that is potentially shared between
>>>>> both the ITSs and the redistributors, following complicated affinity
>>>>> rules.
>>>>>
>>>>> To make things more confusing, the programming of this table at
>>>>> the redistributor level is reusing the GICv4.0 GICR_VPROPBASER register
>>>>> for something completely different.
>>>>>
>>>>> The code flow is somewhat complexified by the need to respect the
>>>>> affinities required by the HW, meaning that tables can either be
>>>>> inherited from a previously discovered ITS or redistributor.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>
>>>> [...]
>>>>
>>>>> @@ -1962,6 +1965,65 @@ static bool its_parse_indirect_baser(struct its_node *its,
>>>>>    	return indirect;
>>>>>    }
>>>>>    
>>>>> +static u32 compute_common_aff(u64 val)
>>>>> +{
>>>>> +	u32 aff, clpiaff;
>>>>> +
>>>>> +	aff = FIELD_GET(GICR_TYPER_AFFINITY, val);
>>>>> +	clpiaff = FIELD_GET(GICR_TYPER_COMMON_LPI_AFF, val);
>>>>> +
>>>>> +	return aff & ~(GENMASK(31, 0) >> (clpiaff * 8));
>>>>> +}
>>>>> +
>>>>> +static u32 compute_its_aff(struct its_node *its)
>>>>> +{
>>>>> +	u64 val;
>>>>> +	u32 svpet;
>>>>> +
>>>>> +	/*
>>>>> +	 * Reencode the ITS SVPET and MPIDR as a GICR_TYPER, and compute
>>>>> +	 * the resulting affinity. We then use that to see if this match
>>>>> +	 * our own affinity.
>>>>> +	 */
>>>>> +	svpet = FIELD_GET(GITS_TYPER_SVPET, its->typer);
>>
>> The spec says, ITS does not share vPE table with Redistributors when
>> SVPET==0.  It seems that we miss this rule and simply regard SVPET as
>> GICR_TYPER_COMMON_LPI_AFF here.  Am I wrong?
> 
> Correct. I missed the case where the ITS doesn't share anything. That's
> pretty unlikely though (you loose all the benefit of v4.1, and I don't
> really see how you'd make it work reliably).

Actually, this is already handled...

> 
>>
>>>>> +	val  = FIELD_PREP(GICR_TYPER_COMMON_LPI_AFF, svpet);
>>>>> +	val |= FIELD_PREP(GICR_TYPER_AFFINITY, its->mpidr);
>>>>> +	return compute_common_aff(val);
>>>>> +}
>>>>> +
>>>>> +static struct its_node *find_sibbling_its(struct its_node *cur_its)
>>>>> +{
>>>>> +	struct its_node *its;
>>>>> +	u32 aff;
>>>>> +
>>>>> +	if (!FIELD_GET(GITS_TYPER_SVPET, cur_its->typer))
>>>>> +		return NULL;

... here. If SVPET is 0, there is no sibling, and we'll allocate a VPE
table as usual.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
