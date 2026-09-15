Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DCC3DA5B7;
	Tue, 15 Sep 2026 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494547; cv=none; b=aGWlmQGVXpRBUm+KsHzbB+Kl30liaHhH9ANWrUeg6x6ODZK7+dyHARss13ArucbhuzCn2JlHpcO9jQSL6dt0ba64W3udTD+re7J6qqkqNCLQzeuGhcJnVEEnOraA6GCrlCoun4NqpkhzRi+qHTINzVULyflgp7w1dLo1ml7AQhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494547; c=relaxed/simple;
	bh=tIOnU1MTP6xV2VV7knVj8q85l9UIZ6omydtjOabHinE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZsFflS9OsnI8kVn43F1e3Fe9udhYSc+94IGdwTHSnvwbRleaVilcw0iEJQVnovUFn6t02jF2fxusugaBbYGC6hpu0U0D9dxq57D2ZXhwJmSFJ1XVpnFjpwL3LfsuljdYZjRSEBcoz/PfR0iR9tbkwm1dpBSLo3FLu/mAXb9p+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SyvaDvlC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SyvaDvlC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A110153B;
	Tue, 15 Sep 2026 10:49:00 -0700 (PDT)
Received: from [192.168.1.148] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 670C93F7B4;
	Tue, 15 Sep 2026 10:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789494544; bh=tIOnU1MTP6xV2VV7knVj8q85l9UIZ6omydtjOabHinE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SyvaDvlCTGucSv4noTWyrNiGQg0jG1bM+Y2Y7PhfKXtEkzoXn90D3+laJXePekIDT
	 80C+vbRqd6Q+vXRTqBb1FBtZuus221dG620E7nvSnz71bPOZlSgLh6+klMZj03Lule
	 0pOBtHK0ECS4SdvNQMgx0sGW+rVyXmEcpW0IGJqE=
Message-ID: <7c26c860-0543-459e-974b-72c59af261f9@arm.com>
Date: Tue, 15 Sep 2026 18:48:59 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 01/23] KVM: arm64: protected VM: Handle set_one_reg
 CNTVCT_EL0/CNTPCT_EL0
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 Marc Zyngier <maz@krenel.org>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-2-suzuki.poulose@arm.com>
 <86o6dy5uob.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86o6dy5uob.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/09/2026 17:46, Marc Zyngier wrote:
> On Tue, 15 Sep 2026 17:01:19 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> Protected VMs doesn't allow setting offsets for virtual and phyiscal
>> counters, as the offset is always fixed to 0. The VM ioclt is filtered
>> out based on the cap. However we don't prevent the userspace from trying
>> to write to the CNTVCT/CNTPCT registers. This would lead to KVM triggering
>> a WARN() in timer_set_offset() as the vm_offset pointer is set to NULL.
>>
>> Fix this by always "fixing" the timer offsets to 0 and marking that the
>> timer offset is set in the kvm->arch.flags at pKVM init time. The
>> userspace cannot use the KVM_ARM_SET_COUNTER_OFFSET, as it is blocked for a
>> protected VM.
>>
>> A userspace writing to the SYS_CNT*CT would observe success, without
>> any real effect. This was chosen over preventing the writes to these
>> registers and returning -EPERM.
>>
>> With that, we always have a valid vm_offset pointer, remove the checks for
>> vm_offset == NULL.
>>
>> Reported by Sashiko here
>> https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.org
>>
>> Fixes: f7d05ee84a6a ("KVM: arm64: Prevent host from managing timer offsets for protected VMs")
>> Suggested-by: Marc Zyngier <maz@krenel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/kvm/arch_timer.c    | 15 +++++----------
>>   arch/arm64/kvm/arm.c           | 15 +++++++++++++++
>>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 26 +++++++++++++-------------
>>   include/kvm/arm_arch_timer.h   |  3 +--
>>   4 files changed, 34 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index 6ac3321f4c575..dda020da4c9c7 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -1079,14 +1079,10 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>>   
>>   	ctxt->timer_id = timerid;
>>   
>> -	if (!kvm_vm_is_protected(vcpu->kvm)) {
>> -		if (timerid == TIMER_VTIMER)
>> -			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
>> -		else
>> -			ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
>> -	} else {
>> -		ctxt->offset.vm_offset = NULL;
>> -	}
>> +	if (timerid == TIMER_VTIMER)
>> +		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
>> +	else
>> +		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
>>   
>>   	hrtimer_setup(&ctxt->hrtimer, kvm_hrtimer_expire, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
>>   
>> @@ -1110,8 +1106,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>   		timer_context_init(vcpu, i);
>>   
>>   	/* Synchronize offsets across timers of a VM if not already provided */
>> -	if (!vcpu_is_protected(vcpu) &&
>> -	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
>> +	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
>>   		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>>   		timer_set_offset(vcpu_ptimer(vcpu), 0);
>>   	}
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 8b080804bc90b..7c88508cac8a1 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -214,6 +214,20 @@ static int kvm_arm_default_max_vcpus(void)
>>   	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>>   }
>>   
>> +/*
>> + * Fix the counter offset to 0 for Protected VMs and mark the
>> + * offset flag. The user can't set the offset via KVM_ARM_SET_COUNTER_OFFSET.
>> + */
>> +static void kvm_arch_fix_timer_offsets(struct kvm *kvm)
>> +{
>> +	if (!kvm_vm_is_protected(kvm))
>> +		return;
>> +
>> +	/* Fix the counter offset to 0 and mark the offset initialised */
>> +	kvm->arch.timer_data.poffset = kvm->arch.timer_data.voffset = 0;
>> +	set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
>> +}
>> +
>>   /**
>>    * kvm_arch_init_vm - initializes a VM data structure
>>    * @kvm:	pointer to the KVM struct
>> @@ -267,6 +281,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   
>>   	kvm_vgic_early_init(kvm);
>>   
>> +	kvm_arch_fix_timer_offsets(kvm);
>>   	kvm_timer_init_vm(kvm);
> 
> This should all be moved to the timer code.
> 
>>   
>>   	/* The maximum number of VCPUs is limited by the host's GIC model */
>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> index 459bd9eb7e4bc..e7b38eff63bd1 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> @@ -528,19 +528,19 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
>>   	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
>>   	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
>>   
>> -	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>> -		/*
>> -		 * Timer offsets are pointing to the untrusted KVM copy,
>> -		 * which is pinned in __pkvm_init_vm() for the VM life time.
>> -		 * It is worth noting that hyp_vm->host_kvm points to an EL2
>> -		 * linear map address and timer_get_offset() will use
>> -		 * kern_hyp_va() which is safe as it is idempotent.
>> -		 */
>> -		vcpu_vtimer(&hyp_vcpu->vcpu)->offset.vm_offset =
>> -			&hyp_vm->host_kvm->arch.timer_data.voffset;
>> -		vcpu_ptimer(&hyp_vcpu->vcpu)->offset.vm_offset =
>> -			&hyp_vm->host_kvm->arch.timer_data.poffset;
>> -	}
>> +	/*
>> +	 * Timer offsets are pointing to the untrusted KVM copy,
>> +	 * which is pinned in __pkvm_init_vm() for the VM life time.
>> +	 * It is worth noting that hyp_vm->host_kvm points to an EL2
>> +	 * linear map address and timer_get_offset() will use
>> +	 * kern_hyp_va() which is safe as it is idempotent.
>> +	 * Also for protected VMs the offset is fixed to 0 and is prevented
>> +	 * from changing.
>> +	 */
>> +	vcpu_vtimer(&hyp_vcpu->vcpu)->offset.vm_offset =
>> +		&hyp_vm->host_kvm->arch.timer_data.voffset;
>> +	vcpu_ptimer(&hyp_vcpu->vcpu)->offset.vm_offset =
>> +		&hyp_vm->host_kvm->arch.timer_data.poffset;
> 
> I don't think this is right. Protected guests have no offset, and this
> needs to be ensured by the hypervisor. Here, the host can change the
> offset any time it wants, and that's not acceptable.

Ah, you're right. :facepalm:

> 
>>   
>>   	ret = pkvm_vcpu_init_sysregs(hyp_vcpu);
>>   	if (ret)
>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>> index bc6f2fdd7ad33..4f0aa3bb69f45 100644
>> --- a/include/kvm/arm_arch_timer.h
>> +++ b/include/kvm/arm_arch_timer.h
>> @@ -176,8 +176,7 @@ static inline bool has_cntpoff(void)
>>   		if (__ctxt) {						\
>>   			struct arch_timer_offset *ato = &__ctxt->offset;\
>>   									\
>> -			if (ato->vm_offset)				\
>> -				off += *KERN_HYP_VA(ato->vm_offset);	\
>> +			off += *KERN_HYP_VA(ato->vm_offset);		\
>>   			if (ato->vcpu_offset)				\
>>   				off += *KERN_HYP_VA(ato->vcpu_offset);	\
>>   		}							\
> 
> And as you drop the previous hunk, this also needs to be restored to
> its original state.

Ack.

Suzuki


> 
> 	M.
> 

