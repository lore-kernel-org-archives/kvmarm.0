Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCBC61FEB;
	Mon,  2 Sep 2024 10:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725272243; cv=none; b=K9umvDm/wXBGSCGFVK036zDpdHzwMRxc2S/1auY1laIkjIKWD/mLTPqL6dJ3ICiNHAKFpZ+SR+VZ1Q55fbPk4tyTHivYr3xCJP9z6MNkm1my6AXC8tTjdcncA9Qvi6oumk2HGiz7yDZfgQ7YS7scXl0BVpsKSrlTLu2fJn9/dSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725272243; c=relaxed/simple;
	bh=WUfaW6gunklyLKsITQ/73SFW4fLHi5OKuof3I1yiLPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H62kgTV1tuqJdWf0SMPcJoSfgPdp8T0pd1GpZLZkbyNyR4hWrGPdassZCQB8M0LERxR4/gfQUDloPS9Z2c6crMbkPcH8E6kX9/MdzFtZH7fVDBhoW6uQiGypXdih7bh8c9oV2oaZKkhyWyf1fuN4JB4RQ53fR28jR8bjqMY5Gk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71BE5FEC;
	Mon,  2 Sep 2024 03:17:46 -0700 (PDT)
Received: from [10.57.74.147] (unknown [10.57.74.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F6A63F66E;
	Mon,  2 Sep 2024 03:17:15 -0700 (PDT)
Message-ID: <fe5626ef-3930-4ad1-b41e-3734ac16b562@arm.com>
Date: Mon, 2 Sep 2024 11:17:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 43/43] KVM: arm64: Allow activating realms
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-44-steven.price@arm.com> <yq5afrqieiyg.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5afrqieiyg.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/09/2024 06:13, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> Add the ioctl to activate a realm and set the static branch to enable
>> access to the realm functionality if the RMM is detected.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/kvm/rme.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 9f415411d3b5..1eeef9e15d1c 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -1194,6 +1194,20 @@ static int kvm_init_ipa_range_realm(struct kvm *kvm,
>>  	return realm_init_ipa_state(realm, addr, end);
>>  }
>>  
>> +static int kvm_activate_realm(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +
>> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +		return -EINVAL;
>> +
>> +	if (rmi_realm_activate(virt_to_phys(realm->rd)))
>> +		return -ENXIO;
>> +
>> +	WRITE_ONCE(realm->state, REALM_STATE_ACTIVE);
>> +	return 0;
>> +}
>> +
>>  /* Protects access to rme_vmid_bitmap */
>>  static DEFINE_SPINLOCK(rme_vmid_lock);
>>  static unsigned long *rme_vmid_bitmap;
>> @@ -1343,6 +1357,9 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>  		r = kvm_populate_realm(kvm, &args);
>>  		break;
>>  	}
>> +	case KVM_CAP_ARM_RME_ACTIVATE_REALM:
>> +		r = kvm_activate_realm(kvm);
>> +		break;
>>  	default:
>>  		r = -EINVAL;
>>  		break;
>> @@ -1599,5 +1616,5 @@ void kvm_init_rme(void)
>>  	if (rme_vmid_init())
>>  		return;
>>  
>> -	/* Future patch will enable static branch kvm_rme_is_available */
>> +	static_branch_enable(&kvm_rme_is_available);
>>
> 
> like rsi_present, we might want to use this outside kvm, ex: for TIO.

I'm struggling to think why rme_is_available would be needed outside KVM
- what is "TIO"?

> Can we move this outside module init so that we can have a helper
> like is_rme_supported()

It's obviously possible, but I'm not sure where in the code it would go
- if there is an actual use case outside of KVM then presumably it would
need to move completely outside of the KVM code.

Can you elaborate on why you think it might be useful?

Steve

