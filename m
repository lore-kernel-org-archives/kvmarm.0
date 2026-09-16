Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DD6443E43;
	Wed, 16 Sep 2026 08:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547274; cv=none; b=RBGD/byg2pYa17GvxVFkCrp02V3TfNY+31uV2T+N5XQscBh3hGf1M5TNBBxD670jVBJvR5nokEajhXarX1L2gGBziGj+1FzSuDC7vT05Fa22ejfSXIgw0n7Lw4aQs9RJkEmk+uDrquMl9ogo9eUxmOMT8WBcf2xd8xzTf1wCzZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547274; c=relaxed/simple;
	bh=SC9sfcMnJ/PEFobWZVnmMbUTIFBvDkYTVdafgFGlQM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qtJR6dt6k6SevpxiEayYTiqQSwFw2KisXlWGR+7b3hhNPtJ1T+FduVPVQEkSkd1Zfs2l+4I/66UZ3d4l+7vE4BXJvxWcMogwqcIU4H4qDvwtp+EBbmhmCqHj1GI0C4/dJ7MsMdm9HgZ5NHtZ1hzcpTKeQxT1piuzAtIhXCT3jNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cZLOlYqd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cZLOlYqd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8033152B;
	Wed, 16 Sep 2026 01:27:48 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A97B3F882;
	Wed, 16 Sep 2026 01:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789547272; bh=SC9sfcMnJ/PEFobWZVnmMbUTIFBvDkYTVdafgFGlQM4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cZLOlYqdunxqc5S8b7CsUOJR8q77ehv8styLLAf+uYgcAzeNJ/oXYr8R0jA/Ycd0U
	 KN2fN/br8WnzGMNA7hcXsuDr0ExCzIwtWprwMg3biLx/h0ryGDAIcjyuTEq/eM/wDt
	 IEbppHN1ZOW6OEyEnesegpbr7fdkusEc4UKbYE3M=
Message-ID: <5c4a9d72-2f46-4121-8e9f-ae85f28eff1f@arm.com>
Date: Wed, 16 Sep 2026 09:27:47 +0100
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
 <86o6dy5uob.wl-maz@kernel.org> <7c26c860-0543-459e-974b-72c59af261f9@arm.com>
 <a4e7e6c3-d325-4f35-a17c-e02791cca326@arm.com> <86ik45626u.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86ik45626u.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/09/2026 09:16, Marc Zyngier wrote:
> On Tue, 15 Sep 2026 22:20:36 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> This is how it looks like now, reworked.
>>
>>
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index 6ac3321f4c575..1c8fac222a643 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -1110,8 +1110,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>                  timer_context_init(vcpu, i);
>>
>>          /* Synchronize offsets across timers of a VM if not already
>> provided */
>> -       if (!vcpu_is_protected(vcpu) &&
>> -           !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
>> &vcpu->kvm->arch.flags)) {
>> +       if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
>> &vcpu->kvm->arch.flags)) {
>>                  timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>>                  timer_set_offset(vcpu_ptimer(vcpu), 0);
>>          }
>> @@ -1133,6 +1132,15 @@ void kvm_timer_init_vm(struct kvm *kvm)
>>           */
>>          for (int i = 0; i < NR_KVM_TIMERS; i++)
>>                  kvm->arch.timer_data.ppi[i] = get_vgic_ppi(kvm,
>> default_ppi[i]);
>> +
>> +       /*
>> +        * For the protected VMs, fix the counter offset to 0 by marking the
>> +        * KVM_ARCH_FLAG_VM_COUNTER_OFFSET. This would also prevent
>> userspace
>> +        * writes to CNTVCT_ELO & CNTPCT_EL0.
>> +        * The user can't set the offset via vm ioctl
>> KVM_ARM_SET_COUNTER_OFFSET.
>> +        */
> 
> This is a bit wordy. Something like:
> 
> 	Protected VMs don't allow any offset being set from userspace,
> 	either set via writes to the counters or using the dedicated
> 	ioctl. Pretend the offset has already been set and rely on the
> 	default offset being 0.
> 
>> +       if (kvm_vm_is_protected(kvm))
>> +               set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
>>   }
>>
>>   void kvm_timer_cpu_up(void)
> 
> Otherwise LGTM.

Thanks,

Cheers
Suzuki

> 
> 	M.
> 

