Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BD946EC6D;
	Wed, 29 Jul 2026 10:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322034; cv=none; b=NqrfUFGiQn/d+ugfHfqi9YR65AyqYvVLgnWFKKNB3FXOfwp9Nr84ksG+YyYL/E3+BvqWb25dBhaofDbh1YEd1pecp7qBSzUDqIxrwKkUgq7qGgqxQJSb7v+ngyy8Ea65SZgZY94Y10veYI9CoL+3W1nNUepDFI+/0JtHRgErJWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322034; c=relaxed/simple;
	bh=5VaYd+Kc1ISM/tP6HGmRXCrgxAtNh+AtZ1rbjw9GISE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fm4Vqu/kPv/li1hFSwlaRjjN7fggTuHsaKxaRZpqj/chSQl1NskjSaK0ZVPgiH5Ve9HRtm1yZjpn3A093+xPD61I5+I2Q/SnsU+3Hmp99XKpYcEBSoEmZNVeMKr7a1iGSP2uoKuIE7IAGTrIVgoUrHq5pAs4P5ukwuSeDhILYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JkYXGEdx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JkYXGEdx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5925C168F;
	Wed, 29 Jul 2026 03:47:07 -0700 (PDT)
Received: from [10.57.87.210] (unknown [10.57.87.210])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 768863F86F;
	Wed, 29 Jul 2026 03:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785322031; bh=5VaYd+Kc1ISM/tP6HGmRXCrgxAtNh+AtZ1rbjw9GISE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JkYXGEdxZ2UuUIOBoJpG7QvdrgMaqvXu2dIP7QokFuk7DD+oyJW4qvlbVBEUGOm4Z
	 3wQhhDUzxjsLFwx5XsEneUCcOE+Iv+9PlwvkE4p18AAt95ZuhE3KJHfJRks+32l2nY
	 PdOLe0NMFvSoCL7elkz2CPZ1/lX82kZ+tZ3o9Aec=
Message-ID: <dff2eee7-09cf-4f85-8dec-c7c243f3ba0f@arm.com>
Date: Wed, 29 Jul 2026 11:47:03 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/37] KVM: arm64: CCA: Support timers in realm RECs
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-14-steven.price@arm.com> <861pcoeqk5.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <861pcoeqk5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/07/2026 10:21, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:15 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The RMM keeps track of the timer while the realm REC is running, but on
>> exit to the normal world KVM is responsible for handling the timers.
>>
>> A later patch adds the support for propagating the timer values from the
>> exit data structure and calling kvm_realm_timers_update().
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v14:
>>  * Special case in kvm_timer_vcpu_load()/kvm_timer_vcpu_put() the timer
>>    handling.
>> Changes since v12:
>>  * Adapt to upstream changes.
>> Changes since v11:
>>  * Drop the kvm_is_realm() check from timer_set_offset(). We already
>>    ensure that the offset is 0 when calling the function.
>> Changes since v10:
>>  * KVM_CAP_COUNTER_OFFSET is now already hidden by a previous patch.
>> Changes since v9:
>>  * No need to move the call to kvm_timer_unblocking() in
>>    kvm_timer_vcpu_load().
>> Changes since v7:
>>  * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
>> ---
>>  arch/arm64/kvm/arch_timer.c  | 38 +++++++++++++++++++++++++++++++++---
>>  include/kvm/arm_arch_timer.h |  2 ++
>>  2 files changed, 37 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index 4155fe89b58a..fdd68f1f5b7b 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -482,6 +482,20 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>>  			    timer_ctx);
>>  }
>>  
>> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
>> +	int i;
>> +
>> +	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
>> +		struct arch_timer_context *timer = &arch_timer->timers[i];
>> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
>> +		bool level = kvm_timer_enabled(timer) && status;
>> +
>> +		kvm_timer_update_irq(vcpu, level, timer);
>> +	}
>> +}
>> +
> 
> Why do we need this? What is so special about CCA that it cannot use
> the existing timer flow?

CCA is a little special because the timer context is owned by the RMM
while the realm is executing. It's the RMM which actually loads/saves
the timer registers not KVM.

The RMM returns some of the timer state on every exit, and the host is
responsible for updating the interrupt status (as the host controls the
GIC emulation).

>>  /* Only called for a fully emulated timer */
>>  static void timer_emulate(struct arch_timer_context *ctx)
>>  {
>> @@ -888,6 +902,11 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>>  	if (unlikely(!timer->enabled))
>>  		return;
>>  
>> +	if (vcpu_is_rec(vcpu)) {
>> +		kvm_timer_unblocking(vcpu);
>> +		return;
>> +	}
>> +
>>  	get_timer_map(vcpu, &map);
>>  
>>  	if (static_branch_likely(&has_gic_active_state)) {
>> @@ -923,6 +942,12 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>>  	if (unlikely(!timer->enabled))
>>  		return;
>>  
>> +	if (vcpu_is_rec(vcpu)) {
>> +		if (kvm_vcpu_is_blocking(vcpu))
>> +			kvm_timer_blocking(vcpu);
>> +		return;
>> +	}
>> +
>>  	get_timer_map(vcpu, &map);
>>  
>>  	timer_save_state(map.direct_vtimer);
>> @@ -1073,7 +1098,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>>  
>>  	ctxt->timer_id = timerid;
>>  
>> -	if (!kvm_vm_is_protected(vcpu->kvm)) {
>> +	if (!kvm_vm_is_protected(vcpu->kvm) && !vcpu_is_rec(vcpu)) {
>>  		if (timerid == TIMER_VTIMER)
>>  			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
>>  		else
>> @@ -1104,7 +1129,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>  		timer_context_init(vcpu, i);
>>  
>>  	/* Synchronize offsets across timers of a VM if not already provided */
>> -	if (!vcpu_is_protected(vcpu) &&
>> +	if (!vcpu_is_protected(vcpu) && !vcpu_is_rec(vcpu) &&
>>  	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
>>  		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>>  		timer_set_offset(vcpu_ptimer(vcpu), 0);
>> @@ -1600,6 +1625,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>  		return -EINVAL;
>>  	}
>>  
>> +	/*
>> +	 * We don't use mapped IRQs for Realms because the RMI doesn't allow
>> +	 * us setting the LR.HW bit in the VGIC.
>> +	 */
>> +	if (vcpu_is_rec(vcpu))
>> +		return 0;
>> +
> 
> If you can't set the HW bit, then use the existing infrastructure for
> similarly challenged systems. But I find this restriction hard to
> swallow. What is so special about the HW bit?

The spec provides this justification for not being able to set the bit:

XDMSDZ: The GICv3 architecture states that, if HW == '1' then the
virtual interrupt must be linked to a physical interrupt whose state is
Active, otherwise behavior is undefined. The RMM is unable to validate
that invariant, so it imposes the constraint that HW == '0'.

> As it stands, I don't think this is acceptable, and I really want to
> know why you need to special-case the timer code.

You're right, there's no need for this early return. Instead I should be
able to implement an 'ops' for the realm guests which returns the
VGIC_IRQ_SW_RESAMPLE flag.

Thanks,
Steve
