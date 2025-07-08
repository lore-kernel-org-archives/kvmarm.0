Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FA019E97B
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751976342; cv=none; b=ngo2jnAzIa3gB5U86J7tKEryyn1aen9hi7gsZz/Sxlb9gBkv5yj8qRGjAMZlSc9p8GMX/0WqD/42ZaXvg0RzXo0ZJPnC10zeKOBHeMmxn3d4pWOIRRe2R+sWLzG+DppbxWYIeqBXl+obtOsg/L0EEvs9aZtlSDc0wcqqpv9a6x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751976342; c=relaxed/simple;
	bh=56YyvzmPRlxghptg1hyNWJ28hcc4S/Zg0HMiRSZObfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rhudWtIrmyeIJsIHr5arJ1mxJiIjo4gQziEcbeixvtZSbf039rh/5z8kFA9+KwHo2Qo/cG6t2rhaAfa8XptJ2v4bGln6TGgqMKFjb/pLJiqv190+1BkE0yS46O6hRf0LUa65/UC38MjRYrTdtNY8Tx38DqqHiGmJg0Kjo76A5oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bc0BP0xBZz2FbNl;
	Tue,  8 Jul 2025 20:03:41 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id CCFE3140275;
	Tue,  8 Jul 2025 20:05:34 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Jul 2025 20:05:34 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Jul 2025 20:05:34 +0800
Message-ID: <73ee91b8-ba15-2534-ab76-f64e59261b1e@hisilicon.com>
Date: Tue, 8 Jul 2025 20:05:24 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] ARM64: errata: Add workaround for HIP10/HIP10C erratum
 162200803
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<tangnianyao@huawei.com>, <wangwudi@hisilicon.com>
References: <20250626124142.2035110-1-wangzhou1@hisilicon.com>
 <86wm8ybpk5.wl-maz@kernel.org>
 <0b54db94-8a6f-cea0-a6f7-dbe8650d66dd@hisilicon.com>
 <86h5zwba5i.wl-maz@kernel.org>
 <ffd3fccc-af4a-6667-3cf6-a55e866f3057@hisilicon.com>
 <864ivtbll0.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <864ivtbll0.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/7/3 18:44, Marc Zyngier wrote:
> On Wed, 02 Jul 2025 10:57:13 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> On 2025/7/1 16:14, Marc Zyngier wrote:
>>> On Fri, 27 Jun 2025 07:36:31 +0100,
>>> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>>>
>>>> On 2025/6/26 21:27, Marc Zyngier wrote:
>>>>> On Thu, 26 Jun 2025 13:41:42 +0100,
>>>>> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>>>>>
>>>>>> For GICv4.0 of Hip10 and Hip10C, it has a SoC bug with vPE schedule:
>>>>>> when multiple vPEs are sending vpe schedule/deschedule commands
>>>>>> concurrently and repeatedly, some vPE schedule command may not be
>>>>>> scheduled, and it will cause the command timeout.
>>>>>>
>>>>>> The hardware implementation is that there is one GIC hardware in one CPU die,
>>>>>> which handles all vPE schedule operations one by one in all CPUs of this die.
>>>>>> The bug is that if the number of queued vPE schedule operations is more
>>>>>> than a certain value, the last vPE schedule operation will be lost.
>>>>>>
>>>>>> One possible way to solve this problem is to limit the number of vLPIs, so
>>>>>> the hardware could spend less time to scan virtual pending table when it
>>>>>> handles the vPE schedule operations, so the queued vPE schedule operations
>>>>>> will never be more than above certain value.
>>>>>>
>>>>>> Given the number of CPUs of die, and imagine there is 100 vPE schedule
>>>>>> operations per second one CPU, it can be calculated that we can limit
>>>>>> the number of vLPI to 4096 for virtual machine to avoid the issue.
>>>>>>
>>>>>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>>>>>> ---
>>>>>>  Documentation/arch/arm64/silicon-errata.rst |  2 ++
>>>>>>  arch/arm64/Kconfig                          | 12 ++++++++++++
>>>>>>  arch/arm64/include/asm/cputype.h            |  4 ++++
>>>>>>  arch/arm64/kernel/cpu_errata.c              | 15 +++++++++++++++
>>>>>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c          |  5 +++++
>>>>>>  arch/arm64/tools/cpucaps                    |  1 +
>>>>>>  include/linux/irqchip/arm-gic-v3.h          |  1 +
>>>>>>  7 files changed, 40 insertions(+)
>>>>>>
>>>>>
>>>>> [...]
>>>>>
>>>>>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>>>>> index ae4c0593d114..495a56e9dc4b 100644
>>>>>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>>>>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>>>>>> @@ -81,6 +81,11 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>>>>>  		if (vgic_has_its(vcpu->kvm)) {
>>>>>>  			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
>>>>>>  			value |= GICD_TYPER_LPIS;
>>>>>> +			/* Limit the number of vlpis to 4096 */
>>>>>> +			if (cpus_have_final_cap(ARM64_WORKAROUND_HISI_162200803) &&
>>>>>> +			    kvm_vgic_global_state.has_gicv4 &&
>>>>>> +			    !kvm_vgic_global_state.has_gicv4_1)
>>>>>> +				value |= 11 << GICD_TYPER_NUM_LPIS_SHIFT;
>>>>>
>>>>> This really doesn't solve your problem. Yes, the guest *may* honor
>>>>> this limit. But KVM doesn't care and will happily allocate 2^16 vLPIs
>>>>> if the guest asks -- there is no code enforcing this limit.
>>>>
>>>> Hi Marc,
>>>>
>>>> I am not sure if there is any other place guest can ask vLPI over
>>>> the limitation except for MAPTI/MAPT below?
>>>>
>>>>> And even if we did. What would we do on a MAPTI command that tries to
>>>>> map a vLPI outside of the allowed range? Do we need to tell the guest
>>>>> it has screwed up?
>>>>
>>>> Thanks for pointing this. Yes, we miss the lpi_nr checking in vgic_its_cmd_handle_mapi.
>>>> In fact, the fix of this errata introduces the usage of GICD.num_LPI,
>>>> so we need make related logic right as well.
>>>
>>> Exactly.
>>>
>>>>
>>>> I am not sure that if we could add related checking for lpi_nr in MAPTI/MAPI
>>>> as part of this errata fix, or we should add the basic support for
>>>> GICD.num_LPI before adding this errata?
>>>
>>> You definitely need to handle that before allowing such limit to be
>>> enforced. Which also means allowing the limit to be saved/restored
>>> from userspace in order to support migration.
>>
>> Seems that in KVM we do not consider GICD_TYPER in migration.
> 
> What do you mean by that?
> 
> Today, we don't support anything being written to GICD_TYPER, just
> like on a HW implementation. If you want it to be writable from
> userspace (and I think you do), then it needs to be added.

Many thanks, I got your idea.

> 
>> How about making GICD_TYPER.num_LPIs as a default configuration,
>> when KVM version is same between source and destination during
>> migration, the logic is still right.
> 
> The default configuration should be that GICD_TYPERR.num_LPIs is 0,
> indicating that the hypervisor doesn't limit anything at all.
> 
>>
>> Something like:
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>> index eb1205654ac8..2071b1445b22 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -385,6 +385,7 @@ int vgic_init(struct kvm *kvm)
>>  	/* freeze the number of spis */
>>  	if (!dist->nr_spis)
>>  		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
>> +	dist->nr_lpis = 2 ^ (INTERRUPT_NUM_LPIS + 1);
> 
> No, this really should default to 0, and 0 being treated as "no limit
> other than the architectural one", as per the architecture spec.
> 
>>
>>  	ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
>>  	if (ret)
>> @@ -433,6 +434,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>>  	kfree(dist->spis);
>>  	dist->spis = NULL;
>>  	dist->nr_spis = 0;
>> +	dist->nr_lpis = 0;
>>  	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
>>
>>  	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index 534049c7c94b..c770eadc5188 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -1047,7 +1047,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>>  	else
>>  		lpi_nr = event_id;
>>  	if (lpi_nr < GIC_LPI_OFFSET ||
>> -	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
>> +	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser) ||
>> +	    lpi_nr >= GIC_LPI_OFFSET + kvm->arch.vgic.nr_lpis)
>>  		return E_ITS_MAPTI_PHYSICALID_OOR;
>>
>>  	/* If there is an existing mapping, behavior is UNPREDICTABLE. */
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index ae4c0593d114..224d0d88c823 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -81,6 +81,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>  		if (vgic_has_its(vcpu->kvm)) {
>>  			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
>>  			value |= GICD_TYPER_LPIS;
>> +			value |= (ilog2(vgic->nr_lpis) - 1) << 11;
>>  		} else {
>>  			value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
>>  		}
>> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
>> index 4349084cb9a6..e11792dafcdf 100644
>> --- a/arch/arm64/kvm/vgic/vgic.h
>> +++ b/arch/arm64/kvm/vgic/vgic.h
>> @@ -16,6 +16,7 @@
>>
>>  #define INTERRUPT_ID_BITS_SPIS	10
>>  #define INTERRUPT_ID_BITS_ITS	16
>> +#define INTERRUPT_NUM_LPIS	14
>>  #define VGIC_LPI_MAX_INTID	((1 << INTERRUPT_ID_BITS_ITS) - 1)
>>  #define VGIC_PRI_BITS		5
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 4a34f7f0a864..b637dc9460d9 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -296,6 +296,7 @@ struct vgic_dist {
>>  	 * else.
>>  	 */
>>  	struct its_vm		its_vm;
>> +	int			nr_lpis;
>>  };
>>
>> However，migration between different KVMs will be broken :(
>> I am not sure that should we consider this case as well?
> 
> This isn't optional. You cannot break migration on existing systems,
> and the only case that *must* break is to restore a VM that hasn't
> seen this limitation on a HW that enforces it.

So the whole story is that we should let GICD_TYPE.num_LPIs as a
writable field, and set this field from VMM(e.g. QEMU). And it will
be failed if doing migration between VMs with different num_LPI
configurations. After above done, this errata could be added.

Not sure my thought above is right? I will try to prepare a num_LPIs
writable patch if the direction is right.

Thanks,
Zhou

> 
> Thanks,
> 
> 	M.
> 
