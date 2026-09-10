Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257414854FD;
	Thu, 10 Sep 2026 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789042527; cv=none; b=pgJ4Ooqtl9KxCL9sJ3yjOJFNkQnXufApHupwSzyP2iv1EPnlj8Vf8yrOjLlSHMw85Pp8ZAB9/gJ0GEu0IHzdHBcGuZg0VNRZfQECK1XQ/d1VltabJP509VcPSMN3SWUJDfcXXkQl1emsBHP/WV9ANPp7kyos+DzBus5t34y3OGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789042527; c=relaxed/simple;
	bh=BZ0bwMpbUYl98imC/LnUVp6ZHT8Fs8NKL7+q1FyBfSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zdf3LWoX1mOzZLQiDFj3R4rQu6HYTOd+fcJE2OOnHpJIfaahLlhKH+C7zxExU+oaJ2qR7NfJYupuBxjnzyBtiRAUxxw+cXYwH8rH9zgIUrZqGfh2KhFih2dOdtCOhsCC+gKfFbo3CH9UV3Q4NqqBcrLu76/dDtml3VCWkNobiZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PpA+OU85; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PpA+OU85"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E82191477;
	Thu, 10 Sep 2026 05:15:15 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D917A3F7B4;
	Thu, 10 Sep 2026 05:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789042519; bh=BZ0bwMpbUYl98imC/LnUVp6ZHT8Fs8NKL7+q1FyBfSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PpA+OU85ezlPJhcvRzyltlc3sLmspSNcp8IEN0cEDoAnP+F1N1IDKhOgoPmLbO4JF
	 U7Q34Pyudz1F3oWJlZSQ6rkvqndYy+RFn5eEJ4slRwLLzN96Mhk0NdorXHJQkzMAyj
	 55niiOxvp21t4Gu2gjbiMPdHv+OUeNlTRNL4ABEY=
Message-ID: <881e6686-7320-49fb-a673-5f1a4d336b36@arm.com>
Date: Thu, 10 Sep 2026 13:15:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 16/20] KVM: arm64: CCA: Provide register list for
 unfinalized RECs
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-17-suzuki.poulose@arm.com>
 <20260908165709.2799B1F00A3D@smtp.kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260908165709.2799B1F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 17:57, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Mismatch between KVM_GET_REG_LIST implementation for RECs and its commit message / comment.
> --
> 
> commit ce52f6b2727531d94e14139ee2966392538b6218
> Author: Jean-Philippe Brucker <jpb@kernel.org>
> 
> KVM: arm64: CCA: Provide register list for unfinalized RECs
> 
> This commit modifies the KVM_GET_REG_LIST ioctl handler to allow fetching
> the register list for Realm Execution Contexts (RECs) before the VCPUs are
> fully finalized, provided SVE is finalized. It adjusts the size probing and
> array copying logic to prevent -EPERM errors during late REC finalization.
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
> [ ... ]
>> @@ -1980,6 +1980,18 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>>   	return __kvm_arm_vcpu_set_events(vcpu, events);
>>   }
>>   
>> +/*
>> + * Realm VCPUs can be finalized after the Realm descriptor is created.
>> + * Allow the register list for RECs before the VCPUs are finalized, but
>> + * after the SVE is finalized.
>> + */
>> +static bool kvm_arm_vcpu_reg_list_allowed(struct kvm_vcpu *vcpu)
>> +{
>> +	if (kvm_arm_vcpu_is_finalized(vcpu))
>> +		return true;
>> +	return vcpu_is_rec(vcpu);
>> +}
> 
> [Severity: Medium]
> Does this logic in kvm_arm_vcpu_reg_list_allowed() unconditionally allow
> RECs, bypassing the SVE finalization check? The comment explicitly states
> "but after the SVE is finalized," yet if the VCPU is a REC, this path
> returns true regardless of the SVE finalization status.

I have fixed the commit description as below to make it clear.

> 
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
> [ ... ]
>> @@ -616,9 +616,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>>   	if (!vcpu_has_sve(vcpu))
>>   		return 0;
>>   
>> -	/* Policed by KVM_GET_REG_LIST: */
>> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
>> -
>>   	/*
>>   	 * Enumerate this first, so that userspace can save/restore in
>>   	 * the order reported by KVM_GET_REG_LIST:
>> @@ -628,6 +625,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>>   		return -EFAULT;
>>   	++num_regs;
>>   
>> +	if (!kvm_arm_vcpu_sve_finalized(vcpu))
>> +		return num_regs;
>> +
> 
> [Severity: Medium]
> Does this return a positive success code (num_regs) rather than an error?
> 
> The commit message states that "a KVM_GET_REG_LIST call that only probes
> for the array size will now succeed even if SVE is not finalized, but that
> seems harmless since the following KVM_GET_REG_LIST with the full array
> will fail."
> 
> Returning a positive number of registers here in copy_sve_reg_indices()
> causes the full array fetch to succeed silently instead of failing as the
> commit message claims.

I have massaged the commit description as below, as the current one
looks so outdated and vague.

---8>---

KVM: arm64: CCA: Expose SVE VL register before REC finalization 


Userspace must configure the SVE vector length before the Realm is 
created (as it is part of the parameter for Realm creation), but the
Realm VCPUs cannot be finalized until after the Realm Descriptor has
been created.

KVM_GET_REG_LIST currently rejects the unfinalized VCPUs, which prevents
the userspace from discovering and configuring the VLs for  the Realm.

Allow KVM_GET_REG_LIST for unfinalized RECs and make the SVE register 

enumeration handle the unfinalized case explicitly. i.e., only expose
KVM_REG_ARM64_SVE_VLS before SVE is finalized.

One adverse side effect of this change is that a KVM_GET_REG_LIST call
that only probes for the array size will now succeed even if SVE is not
finalized, but that seems harmless since the following KVM_GET_REG_LIST
with the full array will fail.


Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com> 

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>



Suzuki

> 
>>   	for (i = 0; i < slices; i++) {
>>   		for (n = 0; n < SVE_NUM_ZREGS; n++) {
>>   			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
> 

