Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA3979F0
	for <kvmarm@lists.linux.dev>; Wed, 24 Jul 2024 01:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783615; cv=none; b=K/G59EQ5VTJxbk4ePM26XZaEYI0eKdGI9CHh0P+oeFivgn0YAOj4l5zYxkMx/M92THpNmmDmNe8lO1ivoOxyxRI0zPVmu/6SOmUafQyDDnpbx1NBrcLv0jUr15ZAfOEpqEgCtt2gb3HuNzRRd0jdzf3mal+Kxm6aVluHQQgcsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783615; c=relaxed/simple;
	bh=80F5/mvdOoU0DZ/ovoR6d5ECFxd7w/YJPhKB4rqGRR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jClzvHfyCCFQ6G0AO+5915A0a53O/NZmyaW2sgdZ0zTce+o+QxQ2WmVFULr/PlTYp73q6HITbxuzxO3YmcWGVu8GnC/RSxtu50/Ff4M2Z/MzJMxvaHUywZVnj5nEsWVfrnyPorGKhzJGY3/3Zb9Xyg6uAFcas634IX+aAiyEgSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WTGHC4LcrzxTwR;
	Wed, 24 Jul 2024 09:13:27 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D2CD1800A2;
	Wed, 24 Jul 2024 09:13:29 +0800 (CST)
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemd200012.china.huawei.com (7.221.188.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 24 Jul 2024 09:13:28 +0800
Message-ID: <b4c0db4e-4899-25e2-6141-35e57760c450@hisilicon.com>
Date: Wed, 24 Jul 2024 09:13:27 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/3] irqchip/gic-v4: Make sure a VPE is locked when VMAPP
 is issued
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Nianyao
 Tang <tangnianyao@huawei.com>
References: <20240705093155.871070-1-maz@kernel.org>
 <20240705093155.871070-4-maz@kernel.org>
 <2c9489cc-d276-7c52-5d52-7f234fdc726e@hisilicon.com>
 <86h6cl39ff.wl-maz@kernel.org>
 <4b05e4fe-0906-102f-5697-eec7ee222bef@hisilicon.com>
 <86bk2o2drs.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <86bk2o2drs.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200012.china.huawei.com (7.221.188.145)

On 2024/7/24 1:56, Marc Zyngier wrote:
> On Tue, 23 Jul 2024 02:51:32 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> On 2024/7/19 19:31, Marc Zyngier wrote:
>>> On Fri, 19 Jul 2024 10:42:02 +0100,
>>> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>>>
>>>> On 2024/7/5 17:31, Marc Zyngier wrote:
>>>>> In order to make sure that vpe->col_idx is correctly sampled
>>>>> when a VMAPP command is issued, we must hold the lock for the
>>>>> VPE. This is now possible since the introduction of the per-VM
>>>>> vmapp_lock, which can be taken before vpe_lock in the locking
>>>>> order.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>>  drivers/irqchip/irq-gic-v3-its.c | 8 ++++++--
>>>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>>>>> index b52d60097cad5..951ec140bcea2 100644
>>>>> --- a/drivers/irqchip/irq-gic-v3-its.c
>>>>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>>>>> @@ -1810,7 +1810,9 @@ static void its_map_vm(struct its_node *its, struct its_vm *vm)
>>>>>  		for (i = 0; i < vm->nr_vpes; i++) {
>>>>>  			struct its_vpe *vpe = vm->vpes[i];
>>>>>  
>>>>> -			its_send_vmapp(its, vpe, true);
>>>>> +			scoped_guard(raw_spinlock, &vpe->vpe_lock)
>>>>> +				its_send_vmapp(its, vpe, true);
>>>>> +
>>>>>  			its_send_vinvall(its, vpe);
>>>>>  		}
>>>>>  	}
>>>>> @@ -1827,8 +1829,10 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
>>>>>  	if (!--vm->vlpi_count[its->list_nr]) {
>>>>>  		int i;
>>>>>  
>>>>> -		for (i = 0; i < vm->nr_vpes; i++)
>>>>> +		for (i = 0; i < vm->nr_vpes; i++) {
>>>>> +			guard(raw_spinlock)(&vm->vpes[i]->vpe_lock);
>>>>>  			its_send_vmapp(its, vm->vpes[i], false);
>>>>> +		}
>>>>>  	}
>>>>>  }
>>>>>  
>>>>
>>>> Hi Marc,
>>>>
>>>> It looks like there is ABBA deadlock after applying this series:
>>>>
>>>> In its_map_vm: vmapp_lock -> vpe_lock
>>>> In its_vpe_set_affinity: vpe_to_cpuid_lock(vpe_lock) -> its_send_vmovp(vmapp_lock)
>>>>
>>>> Any idea about this?
>>>
>>> Hmmm, well spotted. That's an annoying one.
>>>
>>> Can you give the below hack a go? I've only lightly tested it, as my
>>> D05 box is on its last leg (it is literally falling apart) and I don't
>>> have any other GICv4.x box to test on.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>>> index 951ec140bcea2..b88c6011c8771 100644
>>> --- a/drivers/irqchip/irq-gic-v3-its.c
>>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>>> @@ -1328,12 +1328,6 @@ static void its_send_vmovp(struct its_vpe *vpe)
>>>  		return;
>>>  	}
>>>  
>>> -	/*
>>> -	 * Protect against concurrent updates of the mapping state on
>>> -	 * individual VMs.
>>> -	 */
>>> -	guard(raw_spinlock_irqsave)(&vpe->its_vm->vmapp_lock);
>>> -
>>>  	/*
>>>  	 * Yet another marvel of the architecture. If using the
>>>  	 * its_list "feature", we need to make sure that all ITSs
>>> @@ -3808,7 +3802,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>>  	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>>>  	unsigned int from, cpu = nr_cpu_ids;
>>>  	struct cpumask *table_mask;
>>> -	unsigned long flags;
>>> +	unsigned long flags, vmapp_flags;
>>>  
>>>  	/*
>>>  	 * Changing affinity is mega expensive, so let's be as lazy as
>>> @@ -3822,7 +3816,14 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>>  	 * protect us, and that we must ensure nobody samples vpe->col_idx
>>>  	 * during the update, hence the lock below which must also be
>>>  	 * taken on any vLPI handling path that evaluates vpe->col_idx.
>>> +	 *
>>> +	 * Finally, we must protect ourselves against concurrent
>>> +	 * updates of the mapping state on this VM should the ITS list
>>> +	 * be in use.
>>>  	 */
>>> +	if (its_list_map)
>>> +		raw_spin_lock_irqsave(&vpe->its_vm->vmapp_lock, vmapp_flags);
>>> +
>>>  	from = vpe_to_cpuid_lock(vpe, &flags);
>>>  	table_mask = gic_data_rdist_cpu(from)->vpe_table_mask;
>>>  
>>> @@ -3852,6 +3853,9 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>>  	irq_data_update_effective_affinity(d, cpumask_of(cpu));
>>>  	vpe_to_cpuid_unlock(vpe, flags);
>>>  
>>> +	if (its_list_map)
>>> +		raw_spin_unlock_irqrestore(&vpe->its_vm->vmapp_lock, vmapp_flags);
>>> +
>>>  	return IRQ_SET_MASK_OK_DONE;
>>>  }
>>>
>>
>> Hi Marc，
>>
>> We add above code to do test again. Now it is OK.
> 
> Great, thanks for giving it a go. I have just posted an actual patch
> (with the exact same change) at [1]. It would be good if you could
> give it a Tested-by: tag.

Sure, I will give it a Tested-by.

Thanks,
Zhou

> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20240723175203.3193882-1-maz@kernel.org
> 
