Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0043C342D;
	Thu, 10 Sep 2026 08:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029663; cv=none; b=GHNp04KWxPy9sgjYeAnJ3PT/SXWlSnKhWtBjS6WBJaAx8j8+1unIUlMoYtw/ux1OkqtMbW+gel50YXT3DB3dDi6SXxaRyNdrygxNomu5QbwzIJsH5SbMc8Y88Lgn2MVYoewSeTT1q9/qmVN03z7zjGi8Fv/U1XjB7rmw/3mbDpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029663; c=relaxed/simple;
	bh=pUx4XouHWYESXemkI76Ps33KgVnihThvJRf6HxpJWrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ue/l1BPonlxgZBF6BvOF3WbGOs/8+oJtdRIhDE+6kth6sYT8jIf0f3J5nrbfdEUDhT9PUjnRl6gP9j1lFe5fTmH582imKnWA3nL9cyh55BmFt2Rh33lRp9Wa9KkV7evHRCB69OIiyghUFmOwdFt95QasyuMqpVGv+5avJZgXnww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mBK9qm53; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mBK9qm53"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70BD715A1;
	Thu, 10 Sep 2026 01:40:57 -0700 (PDT)
Received: from [10.0.129.245] (unknown [10.0.129.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7E5F3F7B4;
	Thu, 10 Sep 2026 01:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789029661; bh=pUx4XouHWYESXemkI76Ps33KgVnihThvJRf6HxpJWrc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mBK9qm53pB00eTsmHk6y7JPEZrVx4dh4mqxt++d3n8MvUVQ0eeB2plEswWhCUeJEf
	 njukunSrzJCIkygqJGuQU26k5lvOzDDiaIfC4tO3Q4fZF4k/WWaP+qIcYwG46JH6oR
	 RIoX8Cwyllf/YGnFC1WcbtAro16LsstpEiyV2Zxs=
Message-ID: <665c6498-f215-4acc-8e2c-6a7064e787fc@arm.com>
Date: Thu, 10 Sep 2026 09:40:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 05/20] KVM: arm64: Add vcpu load/put call backs for
 flavors
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-6-suzuki.poulose@arm.com>
 <09f1d245-2104-4ca2-93af-a004c44b4161@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <09f1d245-2104-4ca2-93af-a004c44b4161@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin

On 10/09/2026 06:33, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
>> Add VM flavor specific handlers for VCPU load/put, in an effort to 
>> make it
>> easier to follow the code.
>>
>> Based on a patch by Marc Zyngier
>>
>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h |   6 ++
>>   arch/arm64/kvm/arm.c              | 156 ++++++++++++++++++++++--------
>>   2 files changed, 123 insertions(+), 39 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ 
>> asm/kvm_host.h
>> index d0dccc9ad6aa8..b2e99c5cb1cd3 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -150,6 +150,11 @@ struct kvm_vmid {
>>       atomic64_t id;
>>   };
>> +struct kvm_vcpu_ops {
>> +    void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
>> +    void (*vcpu_put)(struct kvm_vcpu *vcpu);
>> +};
>> +
> 
> struct kvm_vcpu::cpu has been set to 'cpu' before vcpu_load() is called in
> kvm_arch_vcpu_load(), so we needn't explicitly pass @cpu to vcpu_load()?

Ack

> 
>>   struct kvm_s2_mmu {
>>       struct kvm_vmid vmid;
>> @@ -854,6 +859,7 @@ struct vncr_tlb;
>>   struct kvm_vcpu_arch {
>>       struct kvm_cpu_context ctxt;
>> +    const struct kvm_vcpu_ops *vcpu_ops;
> 
> I think this would be a field of 'struct kvm_arch' if all vCPUs inside a VM
> have same vCPU operations.

This was done to avoid the long list of pointer chasing :

vcpu->kvm->arch.vcpu_ops->

Given this is vcpu specific ops and a single pointer per vcpu, we can 
make that easier to read.


> 
>>       /*
>>        * Guest floating point state
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 51fc651267157..9af3bbb2f8c24 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -74,6 +74,8 @@ struct kvm_ioctl_cap_map {
>>       long ext;
>>   };
>> +static const struct kvm_vcpu_ops *arm64_vcpu_ops[VM_FLAVOR_MAX];
>> +
>>   /* Make KVM_CAP_NR_VCPUS the reference for features we always 
>> supported */
>>   #define KVM_CAP_ARM_BASIC    KVM_CAP_NR_VCPUS
>> @@ -569,6 +571,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>       mutex_unlock(&vcpu->mutex);
>>   #endif
>> +    vcpu->arch.vcpu_ops = arm64_vcpu_ops[vcpu->kvm->arch.vm_flavor];
>> +
>>       /* Force users to call KVM_ARM_VCPU_INIT */
>>       vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>> @@ -738,36 +742,72 @@ static void vcpu_load_pvtime(struct kvm_vcpu *vcpu)
>>           kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>>   }
>> +static void vhe_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +    vcpu_prepare_mmu(vcpu);
>> +    /*
>> +     * The timer must be loaded before the vgic to correctly set up 
>> physical
>> +     * interrupt deactivation in nested state (e.g. timer interrupt).
>> +     */
>> +    kvm_timer_vcpu_load(vcpu);
>> +    kvm_vgic_load(vcpu);
>> +    kvm_vcpu_load_debug(vcpu);
>> +    kvm_vcpu_load_fgt(vcpu);
>> +    kvm_vcpu_load_vhe(vcpu);
>> +    kvm_arch_vcpu_load_fp(vcpu);
>> +    kvm_vcpu_pmu_restore_guest(vcpu);
>> +
>> +    vcpu_load_pvtime(vcpu);
>> +    vcpu_set_wfx_traps(vcpu);
>> +    vcpu_set_pauth_traps(vcpu);
>> +}
>> +
>> +static void nvhe_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +    vcpu_prepare_mmu(vcpu);
>> +    /*
>> +     * The timer must be loaded before the vgic to correctly set up 
>> physical
>> +     * interrupt deactivation in nested state (e.g. timer interrupt).
>> +     */
>> +    kvm_timer_vcpu_load(vcpu);
>> +    kvm_vgic_load(vcpu);
>> +    kvm_vcpu_load_debug(vcpu);
>> +    kvm_vcpu_load_fgt(vcpu);
>> +    kvm_arch_vcpu_load_fp(vcpu);
>> +    kvm_vcpu_pmu_restore_guest(vcpu);
>> +
>> +    vcpu_load_pvtime(vcpu);
>> +    vcpu_set_wfx_traps(vcpu);
>> +    vcpu_set_pauth_traps(vcpu);
>> +}
>> +
>> +static void pkvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +    /*
>> +     * The timer must be loaded before the vgic to correctly set up 
>> physical
>> +     * interrupt deactivation in nested state (e.g. timer interrupt).
>> +     */
>> +    kvm_timer_vcpu_load(vcpu);
>> +    kvm_vgic_load(vcpu);
>> +    kvm_vcpu_load_debug(vcpu);
>> +    kvm_vcpu_load_fgt(vcpu);
>> +    kvm_arch_vcpu_load_fp(vcpu);
>> +    kvm_vcpu_pmu_restore_guest(vcpu);
>> +
>> +    vcpu_load_pvtime(vcpu);
>> +    vcpu_set_wfx_traps(vcpu);
> 
> It seems vcpu_set_pauth_traps(vcpu) has been missed here?

No, if you see the vcpu_set_pauth_traps(), we do nothing for 
is_protected_kvm_enabled(). So skipped that explicitly here.
I didn't remove that condition from vcpu_set_pauth_traps()
just to keep it safer.

> 
>> +
>> +    kvm_call_hyp_nvhe(__pkvm_vcpu_load,
>> +              vcpu->kvm->arch.pkvm.handle,
>> +              vcpu->vcpu_idx, vcpu->arch.hcr_el2);
>> +    kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
>> +             &vcpu->arch.vgic_cpu.vgic_v3);
>> +}
>> +

...

>> +static const struct kvm_vcpu_ops vhe_vcpu_ops = {
>> +    .vcpu_load = vhe_vcpu_load,
>> +    .vcpu_put = vhe_vcpu_put,
>> +};
>> +
>> +static const struct kvm_vcpu_ops nvhe_vcpu_ops = {
>> +    .vcpu_load = nvhe_vcpu_load,
>> +    .vcpu_put = nvhe_vcpu_put,
>> +};
>> +
>> +static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
>> +    .vcpu_load = pkvm_vcpu_load,
>> +    .vcpu_put = pkvm_vcpu_put,
>> +};
>> +
>> +static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
>> +    [VM_VHE] = &vhe_vcpu_ops,
>> +    [VM_NVHE] = &nvhe_vcpu_ops,
>> +    [VM_PKVM] = &pkvm_vcpu_ops,
>> +    [VM_PROTECTED_PKVM] = &pkvm_vcpu_ops,
>> +};
>> +
> 
> We may avoid the variables {vhe, nvhe, pkvm}_vcpu_ops which are used for 
> once:
> 
> static const struct kvm_vcpu_ops kvm_vcpu_ops[] = {
>      [VM_VHE]            = { vhe_vcpu_load,  vhe_vcpu_put  },
>      [VM_NVHE]           = { nvhe_vcpu_load, nvhe_vcpu_put },
>      [VM_PKVM]           = { pkvm_vcpu_load, pkvm_vcpu_put },
>      [VM_PROTECTED_PKVM] = { pkvm_vcpu_load, pkvm_vcpu_put },
> };

The structure might grow in the future (I have a vcpu_run callback in 
testing). So it does make sense to use the variables to keep it tidy.

I will add checks to make sure that the fields are initialised properly.


Cheers
Suzuki

> 
>>   static unsigned long nvhe_percpu_size(void)
>>   {
>>       return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -
> 
> Thanks,
> Gavin
> 

