Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7B023BE
	for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 06:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727677537; cv=none; b=nzohGphbf6TsvizU7jGWvabyc7RX4LpO/m9NDy45kUfXbH364kBbJCWycDfAbq0piq/DgzFjGSDMnB1NSdaOMbrWwx+tJwYDBb48PnaH2JG/7yScF6BF+cI4TUjORF9jeMCZzNoK2kSfH05+uU3u2CjQXRnelEg2VXmwDGXY0uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727677537; c=relaxed/simple;
	bh=vxa6/GzBqggdm9voabSd2iU3X6sjrcgcpppJvZqkP14=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cevFbumWFaFvyWWRO1PgTo71nNMhvnbdHrYK2vH2vGgQKppEHtmr4xogs6KRFjktCMkhPWloWbB3pzRQVDxSGviAlEdoyJN61smuQGc2MTb+kN85DBxNbiRoJLI8dmkWf4HtD0+87MjhgonmixHd2MvvWvu6GtOMJec4V1W4ldM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XH9y62l5mzlXq6;
	Mon, 30 Sep 2024 14:23:58 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id EB770180AE8;
	Mon, 30 Sep 2024 14:25:29 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 30 Sep 2024 14:25:28 +0800
Subject: Re: [bug report] KVM: arm64: vgic-v4: Occasionally issue VMOVP to an
 unmapped VPE on GICv4.1
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, <tangnianyao@huawei.com>,
	<wangzhou1@hisilicon.com>
References: <c182ece6-2ba0-ce4f-3404-dba7a3ab6c52@huawei.com>
 <87ttdyvklx.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <5ea32d67-f429-acfb-c6d4-06c7860146e2@huawei.com>
Date: Mon, 30 Sep 2024 14:25:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87ttdyvklx.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/9/29 18:07, Marc Zyngier wrote:
> On Sun, 29 Sep 2024 08:18:41 +0100,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>>
>> Hi all,
>>
>> I found a problem with occasionally issuing VMOVP to an unmapped VPE
>> on GICv4.1. In my test environment, operating an unmapped VPE will
>> generate RAS, so I found this problem. The detailed analysis is as
>> follows.
>>
>> The vgic_v4_teardown() will be executed when VM is destroyed to free
>> the GICv4 data structures. The code is as follows:
>>> /**
>>>   * vgic_v4_teardown - Free the GICv4 data structures
>>>   * @kvm:        Pointer to the VM being destroyed
>>>   */
>>> void vgic_v4_teardown(struct kvm *kvm)
>>> {
>>>          struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
>>>          int i;
>>>
>>>          lockdep_assert_held(&kvm->arch.config_lock);
>>>
>>>          if (!its_vm->vpes)
>>>                  return;
>>>
>>>          for (i = 0; i < its_vm->nr_vpes; i++) {
>>>                  struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
>>>                  int irq = its_vm->vpes[i]->irq;
>>>
>>>                  irq_clear_status_flags(irq, DB_IRQ_FLAGS);
>>>                  free_irq(irq, vcpu);
>>>          }
>>>
>>>          its_free_vcpu_irqs(its_vm);
>>>          kfree(its_vm->vpes);
>>>          its_vm->nr_vpes = 0;
>>>          its_vm->vpes = NULL;
>>> }
>>
>> [1] In irq_clear_status_flags(irq, DB_IRQ_FLAGS), the status flags of
>> a doorbell are cleared. DB_IRQ_FLAGS contains IRQ_NO_BALANCING. So
>> after this,the irqbalance.service can schedule the doorbell.
>> [2] In free_irq(), the VPE is unmaped.
>> [3] In its_free_vcpu_irqs(its_vm), unregister_irq_proc() is called to
>> delete the contents in /proc/irq/xx/ of the doorbell.
>>
>> For VPEs in large-scale VM, there is a centain time window between [2]
>> and [3]. The irqbalance.service got a chance to schedule the
>> doorbell. Therefore, the VMOVP is issued to an unmapped VPE.
>>
>> I tried not clearing IRQ_NO_BALANCING and the problem was solved. But
>> it's not clear if there's any other problem with doing so.
> 
> I don't think that's a good idea, because whoever request the same
> interrupt number again for a different purpose will have the flag set
> and will experience odd behaviours.
> 
> I'd rather fix it for good, given that we have all the necessary
> tracking in place already. Something like the patch below, as usual
> untested.

After testing, the patch below fixes my problem.

Thanks,
Kunkun Jiang

> 
> Thanks,
> 
> 	M.
> 
>>From c0fe216c50651458fdf1ebb6b3a1e4ffe2bcc6c2 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sun, 29 Sep 2024 10:58:19 +0100
> Subject: [PATCH] irqchip/gic-v4: Don't allow a VMOVP on a dying VPE
> 
> Kunkun Jiang reports that there is a small window of opportunity for
> userspace to force a change of affinity for a VPE while the VPE has
> already been unmapped, but the corresponding doorbell interrupt still
> visible in /proc/irq/.
> 
> Plug the race by checking the value of vmapp_count, which tracks whether
> the VPE is mapped ot not, and returning an error in this case.
> 
> Reported-by: Kunkun Jiang <jiangkunkun@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/c182ece6-2ba0-ce4f-3404-dba7a3ab6c52@huawei.com
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index fdec478ba5e7..ba9734d1a41f 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3806,6 +3806,13 @@ static int its_vpe_set_affinity(struct irq_data *d,
>   	struct cpumask *table_mask;
>   	unsigned long flags;
>   
> +	/*
> +	 * Check if we're racing against a VPE being destroyed, for
> +	 * which we don't want to allow a VMOVP.
> +	 */
> +	if (!atomic_read(&vpe->vmapp_count))
> +		return -EINVAL;
> +
>   	/*
>   	 * Changing affinity is mega expensive, so let's be as lazy as
>   	 * we can and only do it if we really have to. Also, if mapped
> 
