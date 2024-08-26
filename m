Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF9F3399B
	for <kvmarm@lists.linux.dev>; Mon, 26 Aug 2024 03:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724641848; cv=none; b=AnFzn5RqA2C1e82bzuwRayec6z0bO6TfD+Cw6N2/rSP+Ydfuf2Ax41SUHNZH9NsKq3zBLfYnUIyqe0q9Qh2uNt7tBgwCh7Etzb16PD08zy1Tz69vHhj60jahtFGgvfXK2kA0XGssZBOxjjC9tjTdlMj9uhH7v34YMxnAbbHvCZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724641848; c=relaxed/simple;
	bh=NFlGkAiJ6w1ZyVhCWlgiQ7MjgZHsF2ng0pWYghBVkM0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Vs2oKdFpkRwfXel/0fZMiPZZ02vWR74wYzBsiX6gEyoxM5rkegzGKOa6Lit0IqUqiU6ji+j8iL0gcLpsMOJPWdlz/tUAxLZ82tv4OjaVI3xzZ+8QLdMLe/9E4uIdNZrPMI+FqEPp3UrZ7OnQF3MoIp6c0cxstXUV6/ixMzvmW7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WsbHL5ZzzzpTF8;
	Mon, 26 Aug 2024 11:09:02 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 45C041402CA;
	Mon, 26 Aug 2024 11:10:41 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 26 Aug 2024 11:10:39 +0800
Subject: Re: [bug report] GICv4.1: multiple vpus execute vgic_v4_load at the
 same time will greatly increase the time consumption
To: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	"open list:IRQ SUBSYSTEM" <linux-kernel@vger.kernel.org>, "moderated list:ARM
 SMMU DRIVERS" <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, "wanghaibin.wang@huawei.com"
	<wanghaibin.wang@huawei.com>, <nizhiqiang1@huawei.com>,
	"tangnianyao@huawei.com" <tangnianyao@huawei.com>, <wangzhou1@hisilicon.com>
References: <a7fc58e4-64c2-77fc-c1dc-f5eb78dbbb01@huawei.com>
 <86msl6xhu2.wl-maz@kernel.org>
 <f1574274-efd8-eb56-436b-5a1dd7620f2c@huawei.com>
 <867cc9x8si.wl-maz@kernel.org>
 <bd3c3103-a6d7-a91b-911d-5bc5f2382dae@huawei.com>
 <864j7cybay.wl-maz@kernel.org> <87o75kgspg.ffs@tglx>
 <86zfp3wrmy.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <86655b79-a334-9d4a-464f-0fc83d5cf86a@huawei.com>
Date: Mon, 26 Aug 2024 11:10:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86zfp3wrmy.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/8/23 16:49, Marc Zyngier wrote:
> On Thu, 22 Aug 2024 22:20:43 +0100,
> Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> On Thu, Aug 22 2024 at 13:47, Marc Zyngier wrote:
>>> On Thu, 22 Aug 2024 11:59:50 +0100,
>>> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>>>>> but that will eat a significant portion of your stack if your kernel is
>>>>> configured for a large number of CPUs.
>>>>>
>>>>
>>>> Currently CONFIG_NR_CPUS=4096,each `struct cpumask` occupies 512 bytes.
>>>
>>> This seems crazy. Why would you build a kernel with something *that*
>>> big, specially considering that you have a lot less than 1k CPUs?
>>
>> That's why CONFIG_CPUMASK_OFFSTACK exists, but that does not help in
>> that context. :)
>>
>>>>> The removal of this global lock is the only option in my opinion.
>>>>> Either the cpumask becomes a stack variable, or it becomes a static
>>>>> per-CPU variable. Both have drawbacks, but they are not a bottleneck
>>>>> anymore.
>>>>
>>>> I also prefer to remove the global lock. Which variable do you think is
>>>> better?
>>>
>>> Given the number of CPUs your system is configured for, there is no
>>> good answer. An on-stack variable is dangerously large, and a per-CPU
>>> cpumask results in 2MB being allocated, which I find insane.
>>
>> Only if there are actually 4096 CPUs enumerated. The per CPU magic is
>> smart enough to limit the damage to the actual number of possible CPUs
>> which are enumerated at boot time. It still will over-allocate due to
>> NR_CPUS being insanely large but on a 4 CPU machine this boils down to
>> 2k of memory waste unless Aaarg64 is stupid enough to allocate for
>> NR_CPUS instead of num_possible_cpus()...
> 
> No difference between arm64 and xyz85.999 here.
> 
>>
>> That said, on a real 4k CPU system 2M of memory should be the least of
>> your worries.
> 
> Don't underestimate the general level of insanity!
> 
>>
>>> You'll have to pick your own poison and convince Thomas of the
>>> validity of your approach.
>>
>> As this is an operation which is really not suitable for on demand
>> or large stack allocations the per CPU approach makes sense.
> 
> Right, so let's shoot for that. Kunkun, can you please give the
> following hack a go with your workload?

I tested my workload based on the patch below. It solved my problem.
Thank you very much.

Thanks,
Kunkun Jiang

> 
> Thanks,
> 
> 	M.
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index dd53298ef1a5..b6aa259ac749 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -224,15 +224,16 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>   	struct irq_desc *desc = irq_data_to_desc(data);
>   	struct irq_chip *chip = irq_data_get_irq_chip(data);
>   	const struct cpumask  *prog_mask;
> +	struct cpumask *tmp_mask;
>   	int ret;
>   
> -	static DEFINE_RAW_SPINLOCK(tmp_mask_lock);
> -	static struct cpumask tmp_mask;
> +	static DEFINE_PER_CPU(struct cpumask, __tmp_mask);
>   
>   	if (!chip || !chip->irq_set_affinity)
>   		return -EINVAL;
>   
> -	raw_spin_lock(&tmp_mask_lock);
> +	tmp_mask = this_cpu_ptr(&__tmp_mask);
> +
>   	/*
>   	 * If this is a managed interrupt and housekeeping is enabled on
>   	 * it check whether the requested affinity mask intersects with
> @@ -258,11 +259,11 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>   
>   		hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
>   
> -		cpumask_and(&tmp_mask, mask, hk_mask);
> -		if (!cpumask_intersects(&tmp_mask, cpu_online_mask))
> +		cpumask_and(tmp_mask, mask, hk_mask);
> +		if (!cpumask_intersects(tmp_mask, cpu_online_mask))
>   			prog_mask = mask;
>   		else
> -			prog_mask = &tmp_mask;
> +			prog_mask = tmp_mask;
>   	} else {
>   		prog_mask = mask;
>   	}
> @@ -272,16 +273,14 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>   	 * unless we are being asked to force the affinity (in which
>   	 * case we do as we are told).
>   	 */
> -	cpumask_and(&tmp_mask, prog_mask, cpu_online_mask);
> -	if (!force && !cpumask_empty(&tmp_mask))
> -		ret = chip->irq_set_affinity(data, &tmp_mask, force);
> +	cpumask_and(tmp_mask, prog_mask, cpu_online_mask);
> +	if (!force && !cpumask_empty(tmp_mask))
> +		ret = chip->irq_set_affinity(data, tmp_mask, force);
>   	else if (force)
>   		ret = chip->irq_set_affinity(data, mask, force);
>   	else
>   		ret = -EINVAL;
>   
> -	raw_spin_unlock(&tmp_mask_lock);
> -
>   	switch (ret) {
>   	case IRQ_SET_MASK_OK:
>   	case IRQ_SET_MASK_OK_DONE:
>
