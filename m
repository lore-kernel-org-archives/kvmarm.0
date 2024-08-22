Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA1185955
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 11:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724324409; cv=none; b=ndbS8Qeg2qBBvPoAStkvliHTmDsvMpw/Uhn7iLYe9X2WSHdaY6H+8+fHtPwwqAxW5AwG+c0c8Vay26t5pNvdyGT2kfkV0XAvvx49K8Z/KrLNn2C3ZdcoPCFE//KxwTsUCKii/WoZpXVBe8C/2f2oo3yKE4+MgnVWeGezfQVuC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724324409; c=relaxed/simple;
	bh=9JiGXSYYncNkXYemDiaONkeVDgFPCKHf2/W8KFs7ujg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Y576zaajsY30vBO5C0fljjiYk97ycLLramrnIFDDz8xydHR4TYiPaulXW1SyNhxk3fk0bj5PcV2U0yVdgVJj3CY21xLr7eI+AAm61X6uoBnEs6uMOEbU9EZpkJtC261RnLQPwiYbPZ0alwfb9fOdFPb9auV8H7u7ZprVpuCmHyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WqKwC2LjgzyR3C;
	Thu, 22 Aug 2024 18:59:39 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FD8918009B;
	Thu, 22 Aug 2024 19:00:03 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 22 Aug 2024 19:00:01 +0800
Subject: Re: [bug report] GICv4.1: multiple vpus execute vgic_v4_load at the
 same time will greatly increase the time consumption
To: Marc Zyngier <maz@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Oliver Upton
	<oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, "open list:IRQ
 SUBSYSTEM" <linux-kernel@vger.kernel.org>, "moderated list:ARM SMMU DRIVERS"
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	"wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
	<nizhiqiang1@huawei.com>, "tangnianyao@huawei.com" <tangnianyao@huawei.com>,
	<wangzhou1@hisilicon.com>
References: <a7fc58e4-64c2-77fc-c1dc-f5eb78dbbb01@huawei.com>
 <86msl6xhu2.wl-maz@kernel.org>
 <f1574274-efd8-eb56-436b-5a1dd7620f2c@huawei.com>
 <867cc9x8si.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <bd3c3103-a6d7-a91b-911d-5bc5f2382dae@huawei.com>
Date: Thu, 22 Aug 2024 18:59:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <867cc9x8si.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/8/22 16:26, Marc Zyngier wrote:
>>>> According to analysis, this problem is due to the execution of vgic_v4_load.
>>>> vcpu_load or kvm_sched_in
>>>>       kvm_arch_vcpu_load
>>>>       ...
>>>>           vgic_v4_load
>>>>               irq_set_affinity
>>>>               ...
>>>>                   irq_do_set_affinity
>>>>                       raw_spin_lock(&tmp_mask_lock)
>>>>                       chip->irq_set_affinity
>>>>                       ...
>>>>                         its_vpe_set_affinity
>>>>
>>>> The tmp_mask_lock is the key. This is a global lock. I don't quite
>>>> understand
>>>> why tmp_mask_lock is needed here. I think there are two possible
>>>> solutions here:
>>>> 1. Remove this tmp_mask_lock
>>>
>>> Maybe you could have a look at 33de0aa4bae98 (and 11ea68f553e24)? It
>>> would allow you to understand the nature of the problem.
>>>
>>> This can probably be replaced with a per-CPU cpumask, which would
>>> avoid the locking, but potentially result in a larger memory usage.
>>
>> Thanks, I will try it.
> 
> A simple alternative would be this:
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index dd53298ef1a5..0d11b74af38c 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -224,15 +224,12 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>   	struct irq_desc *desc = irq_data_to_desc(data);
>   	struct irq_chip *chip = irq_data_get_irq_chip(data);
>   	const struct cpumask  *prog_mask;
> +	struct cpumask tmp_mask = {};
>   	int ret;
>   
> -	static DEFINE_RAW_SPINLOCK(tmp_mask_lock);
> -	static struct cpumask tmp_mask;
> -
>   	if (!chip || !chip->irq_set_affinity)
>   		return -EINVAL;
>   
> -	raw_spin_lock(&tmp_mask_lock);
>   	/*
>   	 * If this is a managed interrupt and housekeeping is enabled on
>   	 * it check whether the requested affinity mask intersects with
> @@ -280,8 +277,6 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>   	else
>   		ret = -EINVAL;
>   
> -	raw_spin_unlock(&tmp_mask_lock);
> -
>   	switch (ret) {
>   	case IRQ_SET_MASK_OK:
>   	case IRQ_SET_MASK_OK_DONE:
> 
> but that will eat a significant portion of your stack if your kernel is
> configured for a large number of CPUs.
>

Currently CONFIG_NR_CPUS=4096,each `struct cpumask` occupies 512 bytes.

>>
>>>> 2. Modify the gicv4 driver,do not perfrom VMOVP via
>>>> irq_set_affinity.
>>>
>>> Sure. You could also not use KVM at all if don't care about interrupts
>>> being delivered to your VM. We do not send a VMOVP just for fun. We
>>> send it because your vcpu has moved to a different CPU, and the ITS
>>> needs to know about that.
>>
>> When a vcpu is moved to a different CPU, of course VMOVP has to be sent.
>> I mean is it possible to call its_vpe_set_affinity() to send VMOVP by
>> other means (instead of by calling the irq_set_affinity() API). So we
>> can bypass this tmp_mask_lock.
> 
> The whole point of this infrastructure is that the VPE doorbell is the
> control point for the VPE. If the VPE moves, then the change of
> affinity *must* be done using irq_set_affinity(). All the locking is
> constructed around that. Please read the abundant documentation that
> exists in both the GIC code and KVM describing why this is done like
> that.
> 

OK. Thank you for your guidance.

>>
>>>
>>> You seem to be misunderstanding the use case for GICv4: a partitioned
>>> system, without any over-subscription, no vcpu migration between CPUs.
>>> If that's not your setup, then GICv4 will always be a net loss
>>> compared to SW injection with GICv3 (additional HW interaction,
>>> doorbell interrupts).
>>
>> Thanks for the explanation. The key to the problem is not vcpu migration
>> between CPUs. The key point is that many vcpus execute vgic_v4_load() at
>> the same time. Even if it is not migrated to another CPU, there may be a
>> large number of vcpus executing vgic_v4_load() at the same time. For
>> example, the service running in VMs has a large number of MMIO accesses
>> and need to return to userspace for emulation. Due to the competition of
>> tmp_mask_lock, performance will deteriorate.
> 
> That's only a symptom. And that doesn't affect only pathological VM
> workloads, but all interrupts being moved around for any reason.
> 

Yes.

>>
>> When the target CPU is the same CPU as the last run, there seems to be
>> no need to call irq_set_affinity() in this case. I did a test and it was
>> indeed able to alleviate the problem described above.
> 
> The premise is that irq_set_affinity() should be cheap when there
> isn't much to do, and you are papering over the problem.
> 
>>
>> I feel it might be better to remove tmp_mask_lock or call
>> its_vpe_set_affinity() in another way. So I mentioned these two ideas
>> above.
> 
> The removal of this global lock is the only option in my opinion.
> Either the cpumask becomes a stack variable, or it becomes a static
> per-CPU variable. Both have drawbacks, but they are not a bottleneck
> anymore.

I also prefer to remove the global lock. Which variable do you think is
better?

Thanks,
Kunkun Jiang
