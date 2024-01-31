Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93801849
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 01:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706664599; cv=none; b=Lj4wBYuGpOAgOH14quh3TDHLWHxfHHdkD7xT+II3UECw65l3eU7xiOujYnmJu0Fsm5/x/LwE7S6cN00FHp6dpzAcDUngUe1ihfsNDjh/G41V4BdiKMdfqyyvtyTombXTlhoMXPOjhLRXA8wnfyWd/Ry17lMprnLlDgnCQm/iFSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706664599; c=relaxed/simple;
	bh=NQ53MrC5bP1n2tQkWuU9ia0njPHTk4Zl3ImPZNlbQuI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=leyw9DHgGzWczzmeCRHXd11NhOpaZImmk4fUtjQIw5nqdoHPsHUz3LqNR+V2uLPT7tEPWkHQtIinLtbrQsKm8HXSPAxUCtPbiA3tJ/xNnIU0aZgLpNeZ5dhX0CAFQSBKB1itZHVufqnS4Tm/n0vfdcz4tpop2nNuKwRsinntcNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TPkvp20vHz1xmsS;
	Wed, 31 Jan 2024 09:28:54 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id C8B3A1A016B;
	Wed, 31 Jan 2024 09:29:53 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 31 Jan 2024 09:29:52 +0800
Subject: Re: [PATCH v2 1/2] irqchip/gic-v4.1: Fix GICv4.1 doorbell affinity
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <wanghaibin.wang@huawei.com>
References: <20240126103012.1020-1-jiangkunkun@huawei.com>
 <20240126103012.1020-2-jiangkunkun@huawei.com> <86ttn074ev.wl-maz@kernel.org>
 <44051a41-f82e-57d9-001a-d4d195d59f2e@huawei.com>
 <86r0i17fkf.wl-maz@kernel.org>
 <ecda5c79-9296-b4c6-0f09-7cb80ee3c91b@huawei.com>
 <86plxj6i3o.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <72090b1b-21ab-6247-6231-1be2e11a2e4d@huawei.com>
Date: Wed, 31 Jan 2024 09:29:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86plxj6i3o.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/1/30 21:55, Marc Zyngier wrote:
> On Tue, 30 Jan 2024 13:32:24 +0000,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> Hi Marc,
>>
>> On 2024/1/28 21:28, Marc Zyngier wrote:
>>> On Sat, 27 Jan 2024 02:41:55 +0000,
>>> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>>>>> At this stage, I think the VMOVP optimisation is wrong and that we
>>>>> should drop it.
>>>> This is the last resort. Maybe we can think of another way.
>>> I think the only other way is to never elide the VMOVP from
>>> set_affinity, but to only call into set_affinity when strictly
>>> necessary:
>>>
>>> - when making the VPE resident on a CPU that isn't part of the same
>>>     affinity group (VPE migration outside of the affinity group)
>>>
>>> - when making the VPE non-resident on a CPU that isn't the doorbell
>>>     delivery CPU *AND* that there is a need for a doorbell (VPE
>>>     migration inside the affinity group)
>>>
>>> Which means it is the responsibility of the upper layers of the stack
>>> to make these decisions, and that we can keep the low-level driver as
>>> simple as possible.
>>>
>>> In the meantime, here's the patch I'm proposing to merge ASAP. Please
>>> let me know if that works for you.
>> This patch works. But I still have some questions, which I will
>> write down below.
>>> 	M.
>>>
>>> >From 00c338e91d3b6600f402f56cdb64c9d370f911c8 Mon Sep 17 00:00:00 2001
>>> From: Marc Zyngier <maz@kernel.org>
>>> Date: Sun, 28 Jan 2024 13:05:24 +0000
>>> Subject: [PATCH] irqchip/gic-v3-its: Fix GICv4.1 VPE affinity update
>>>
>>> When updating the affinity of a VPE, we currently skip the VMOVP
>>> command if the two CPUs are part of the same VPE affinity.
>>>
>>> But this is wrong, as the doorbell corresponding to this VPE
>>> is still delivered on the 'old' CPU, which screws up the balancing.
>>> Furthermore, offlining that 'old' CPU results in doorbell interrupts
>>> generated for this VPE being discarded.
>>>
>>> The harsh reality is that we cannot easily elide VMOVP when
>>> a set_affinity request occurs. It needs to be obeyed, and if
>>> an optimisation is to be made, it is at the point where the affinity
>>> change request is made (such as in KVM).
>>>
>>> Drop the VMOVP elision altogether, and only use the vpe_table_mask
>>> to try and stay within the same ITS affinity group if at all possible.
>>>
>>> Fixes: dd3f050a216e (irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP)
>>> Reported-by: Kunkun Jiang <jiangkunkun@huawei.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>    drivers/irqchip/irq-gic-v3-its.c | 22 +++++++++++++---------
>>>    1 file changed, 13 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>>> index 250b4562f308..78aece62bff5 100644
>>> --- a/drivers/irqchip/irq-gic-v3-its.c
>>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>>> @@ -3826,8 +3826,9 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>>    				bool force)
>>>    {
>>>    	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>>> -	int from, cpu = cpumask_first(mask_val);
>>> +	struct cpumask common;
>>>    	unsigned long flags;
>>> +	int from, cpu;
>>>      	/*
>>>    	 * Changing affinity is mega expensive, so let's be as lazy as
>>> @@ -3843,19 +3844,22 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>>    	 * taken on any vLPI handling path that evaluates vpe->col_idx.
>>>    	 */
>>>    	from = vpe_to_cpuid_lock(vpe, &flags);
>>> -	if (from == cpu)
>>> -		goto out;
>>> -
>>> -	vpe->col_idx = cpu;
>>>      	/*
>>> -	 * GICv4.1 allows us to skip VMOVP if moving to a cpu whose RD
>>> -	 * is sharing its VPE table with the current one.
>>> +	 * If we are offered another CPU in the same GICv4.1 ITS
>>> +	 * affinity, pick this one. Otherwise, any CPU will do.
>>>    	 */
>>> -	if (gic_data_rdist_cpu(cpu)->vpe_table_mask &&
>>> -	    cpumask_test_cpu(from, gic_data_rdist_cpu(cpu)->vpe_table_mask))
>>> +	if (gic_data_rdist_cpu(from)->vpe_table_mask &&
>>> +	    cpumask_and(&common, mask_val, gic_data_rdist_cpu(from)->vpe_table_mask))
>>> +		cpu = cpumask_first(&common);
>>> +	else
>>> +		cpu = cpumask_first(mask_val);
>>> +
>>> +	if (from == cpu)
>>>    		goto out;
>> The meaning here should be that VMOVP will be skipped
>> only if from and target are the same. Then why do we
>> still to judge whether they are in the same GICv4.1
>> ITS affinity?
> Having the same ITS affinity is a performance optimisation, as this
> minimises traffic between ITSs and keep cache locality. If the
> proposed affinity contains CPUs that are in the same affinity as
> current one, then it makes sense to stay there if possible in order to
> keep the benefit of the warm translation caches.
Ok, I see. In another case, is it possible to skip VMOVP?
The from belongs to common, but it is not the first one.

Kunkun Jiang
