Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542624FD795;
	Thu, 17 Sep 2026 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664807; cv=none; b=A8yShHpQ2B9EjDrPcX8QfUcaGMHco0Q32gnRuEgraFBKijyfM1a1Fd8EhpHgJWpUw6ktYBuO3o5OuKj20uz1C7MQaJNfRlZzf+rWm2AOB0k2W5NR04R9Xu78xSigm+n4PvTsHKgtbdgF2sD7EMcsl+w7IX8Ffq3cNmkbtunUvUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664807; c=relaxed/simple;
	bh=xBQBpGmS5H6+MF+EvG/bUTp6vl9EzHg61YvBRsg6TLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HGeTyCdLxeHnqnupTt+K1DD1JbKSnq0CAGE3ClNgxFucRl7fI0xcHGUBk39ssubJbTKQPTd/P6rGQPNyZmwib+LY8HwlWb/vOHIaPTyoL2DVnl7+FZpj+MKqP5Yp5AogCqUDn4MeFa5czjDD5ENJ18NbC6ws8zZqNIkq9e32qF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e4s95459; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e4s95459"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B5FB143D;
	Thu, 17 Sep 2026 10:06:41 -0700 (PDT)
Received: from [10.57.6.197] (unknown [10.57.6.197])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99A9F3F7B4;
	Thu, 17 Sep 2026 10:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789664804; bh=xBQBpGmS5H6+MF+EvG/bUTp6vl9EzHg61YvBRsg6TLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e4s95459WLZ2gmCkD5mOtCaYCTAiUjwdIdAGe6Kjx6WPpwpiNfe5HJLwYOtd2ewqj
	 4XBgTCiC6wXridMPn70qDNChGX/o94y3YAO3qKDhHGvgkDO7vWXYvHa6uhPjcyka+h
	 bfYSLlIvhj10KknkHpEnmyAuyrAN0RoYjqDNGBsA=
Message-ID: <eac603c7-bcab-4c6c-a2ed-bf831d609a2e@arm.com>
Date: Thu, 17 Sep 2026 18:06:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 12/23] KVM: arm64: Widen the scope of "protected" VMs
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-13-suzuki.poulose@arm.com>
 <8633v85ch1.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <8633v85ch1.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/09/2026 12:44, Marc Zyngier wrote:
> On Tue, 15 Sep 2026 17:01:30 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On arm64 we have "protected" VMs that run on PKVM as a confidential compute
>> guest. Given we already have the construct of "kvm_vm_is_protected" in the core
>> KVM code, use that for all confidential compute guests including Realms that
>> we are about to add.
>>
>> Use the VM flavor to detect the "protected" VMs by introducing a marker.
>> Add explicit helper to detect if a given VM is a "protected" VM under PKVM.
>> Change the existing users that precisely want to check the VM type. These
>> include :
>>    - kvm_arch_prepare_memory_region - For preventing memslot changes after pVM
>>      creation.
>>
>> All the others are retained as a wider check for confidential guest VMs.
>> These are:
>>   - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset configuration
>>   - io_mem_abort for dabt handling without valid syndrome information
>>
>> Both of which are true for Realms too.
>>
>> Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
>> checks in the pkvm hyp specific code doesn't need to change, as the only
>> protected guests it deals with is "protected PKVM" guests.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 4 +++-
>>   arch/arm64/kvm/mmu.c              | 2 +-
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 7ce46d853c47e..1bb43c57fb0f0 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -329,6 +329,7 @@ enum kvm_arm_vm_flavor {
>>   	VM_NVHE,
>>   	VM_VHE,
>>   	VM_PKVM,		/* Normal guests on pKVM */
>> +	MARKER(__VM_PROTECTED),
>>   	VM_PROTECTED_PKVM,	/* Protected VM */
>>   	VM_FLAVOR_MAX,
>>   };
>> @@ -1535,7 +1536,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>>   
>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>>   
>> -#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
>> +#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>> +#define kvm_vm_is_protected_pkvm(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
>>   #define kvm_vm_is_unprotected_pkvm(kvm)	((kvm)->arch.vm_flavor == VM_PKVM)
>>
> 
> This really should be added from where you introduce the enumeration,
> as my original patch did. Otherwise, this is pure churn for no benefit.

Ack, the idea was to introduce this, after converting the existing
code with the new wrappers. I will fold that change here.

Cheers
Suzuki

> 
> Thanks,
> 
> 	M.
> 

