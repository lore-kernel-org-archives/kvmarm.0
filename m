Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32904C34047
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 11:51:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB2BB24654
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 11:51:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB2BB24654
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 377B74AF02;
	Wed, 19 Feb 2020 06:51:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id utk4BXw0RRND; Wed, 19 Feb 2020 06:51:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24984AF1D;
	Wed, 19 Feb 2020 06:51:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7250F4AF1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 06:51:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12cxdzFBAeSf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 06:51:01 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A41F94AF02
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 06:50:59 -0500 (EST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 79B762677E22060FC49B;
 Wed, 19 Feb 2020 19:50:54 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 19:50:47 +0800
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To: Marc Zyngier <maz@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8db95a86-0981-710b-6c82-be7f7f844151@huawei.com>
Date: Wed, 19 Feb 2020 19:50:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert
 Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On 2020/2/18 23:31, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 2020-02-18 09:27, Marc Zyngier wrote:
>> Hi Zenghui,
>>
>> On 2020-02-18 07:00, Zenghui Yu wrote:
>>> Hi Marc,
> 
> [...]
> 
>>> There might be a race on reading the 'vpe->col_idx' against a concurrent
>>> vPE schedule (col_idx will be modified in its_vpe_set_affinity)? Will we
>>> end up accessing the GICR_VSGI* registers of the old redistributor,
>>> while the vPE is now resident on the new one? Or is it harmful?
>>
>> Very well spotted. There is a potential problem if old and new RDs are 
>> not part
>> of the same CommonLPIAff group.
>>
>>> The same question for direct_lpi_inv(), where 'vpe->col_idx' will be
>>> used in irq_to_cpuid().
>>
>> Same problem indeed. We need to ensure that no VMOVP operation can 
>> occur whilst
>> we use col_idx to access a redistributor. This means a vPE lock of 
>> some sort
>> that will protect the affinity.

Yeah, I had the same view here, a vPE level lock might help.

>> But I think there is a slightly more general problem here, which we 
>> failed to
>> see initially: the same issue exists for physical LPIs, as col_map[] 
>> can be
>> updated (its_set_affinity()) in parallel with a direct invalidate.
>>
>> The good old invalidation through the ITS does guarantee that the two 
>> operation
>> don't overlap, but direct invalidation breaks it.

Agreed!

>> Let me have a think about it.
> 
> So I've thought about it, wrote a patch, and I don't really like the 
> look of it.
> This is pretty invasive, and we end-up serializing a lot more than we 
> used to
> (the repurposing of vlpi_lock to a general "lpi mapping lock" is 
> probably too
> coarse).
> 
> It of course needs splitting over at least three patches, but it'd be 
> good if
> you could have a look (applies on top of the whole series).

So the first thing is that

1. there're races on choosing the RD against a concurrent LPI/vPE
affinity changing.

And sure, I will have a look on the following patch! But I'd first
talk about some other issues I've seen today...

2. Another potential race is on accessing the same RD by different
CPUs, which gets more obvious after introducing the GICv4.1.
We can as least take two registers for example:

  - GICR_VSGIR:
    Let's assume that vPE0 is just descheduled from CPU0 and then vPE1
    is scheduled on. CPU0 is writing its GICR_VSGIR with vpeid1 to serve
    vPE1's GICR_ISPENDR0 read trap, whilst userspace is getting vSGI's
    pending state of vPE0 (i.e., by a debugfs read) thus another CPU
    will try to write the same GICR_VSGIR with vpeid0... without waiting
    GICR_VSGIPENDR.Busy reads as 0.
    This is a CONSTRAINED UNPREDICTABLE behavior from the spec and at
    least one of the queries will fail.
  - GICR_INV{LPI,ALL}R:
    Multiple LPIs can be targeted to the same RD, thus multiple writes to
    the same GICR_INVLPIR (with different INITID, even with different V)
    can happen concurrently...

Above comes from the fact that the same redistributor can be accessed
(concurrently) by multiple CPUs but we don't have a mechanism to ensure
some extent of serialization. I also had a look at how KVM will handle
this kind of access, but

3. it looks like KVM makes the assumption that the per-RD MMIO region
will only be accessed by the associated VCPU?  But I think this's not
restricted by the architecture, we can do it better.  Or I've just
missed some important points here.


I will look at the following patch asap but may need some time to
think about all above, and do some fix if possible :-)

> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index 7656b353a95f..0ed286dba827 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c

[...]


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
