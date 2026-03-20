Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECB93DEFE7;
	Fri, 20 Mar 2026 16:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774025152; cv=none; b=cIYjlHkCziHvQMGXx60Gpn2ZEPiNesR+KZiXdn7jLxxP/Ius4vjkXNXE+4I/tacblXLQAq+kM5LVgf0xyZjXWj+f93feG7T8v1Do6WqDHQ6gwmOKdeFLmbu1FBPdYkG0GhrVX6QyoB5QYJHl8I1iQSH/FAHG58XK6x9cb/ey6uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774025152; c=relaxed/simple;
	bh=wSTJyq7SJedh76KDbDAq/uCbLAx5ABhYEcwjfiSoOyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqF8K6zGdmfvqOXrSz/AuWdqdsIc3a7MLNdFuaBwWleMsAmM9A9dv6gEZPzhAWngJArhirmYe6M0i+ntYyllX5HPqQ8uhjs5jOWqbzyi0sUMkDV1zq5WOCOzyUlXVIE0XonDhM8ASv/J5GJvXMIdyRAIbgWO8XoFqWdFTKG3q+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD5A6165C;
	Fri, 20 Mar 2026 09:45:43 -0700 (PDT)
Received: from [10.1.29.20] (e122027.cambridge.arm.com [10.1.29.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B9053F7BD;
	Fri, 20 Mar 2026 09:45:44 -0700 (PDT)
Message-ID: <362fada6-2b5d-4360-9f5e-7ffadeb66d47@arm.com>
Date: Fri, 20 Mar 2026 16:45:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 45/48] arm64: RMI: Provide accurate register list
To: Wei-Lin Chang <weilin.chang@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-46-steven.price@arm.com>
 <iiyaphsgpo2f3wrrywggsten6c6lb4gxhiztah6jurtt25xepf@gpzdhw77oa4a>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <iiyaphsgpo2f3wrrywggsten6c6lb4gxhiztah6jurtt25xepf@gpzdhw77oa4a>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/03/2026 18:53, Wei-Lin Chang wrote:
> On Wed, Mar 18, 2026 at 03:54:09PM +0000, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> Userspace can set a few registers with KVM_SET_ONE_REG (9 GP registers
>> at runtime, and 3 system registers during initialization). Update the
>> register list returned by KVM_GET_REG_LIST.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v11:
>>  * Reworked due to upstream changes.
>> Changes since v8:
>>  * Minor type changes following review.
>> Changes since v7:
>>  * Reworked on upstream changes.
>> ---
>>  arch/arm64/kvm/guest.c      |  6 ++++++
>>  arch/arm64/kvm/hypercalls.c |  4 ++--
>>  arch/arm64/kvm/sys_regs.c   | 29 +++++++++++++++++++++++------
>>  3 files changed, 31 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 2c4db2d1a6ca..23fdb2ee8a61 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -620,6 +620,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>>  	if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>  		return 1; /* KVM_REG_ARM64_SVE_VLS */
>>  
>> +	if (kvm_is_realm(vcpu->kvm))
>> +		return 1; /* KVM_REG_ARM64_SVE_VLS */
>> +
>>  	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
>>  		+ 1; /* KVM_REG_ARM64_SVE_VLS */
>>  }
>> @@ -647,6 +650,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>>  	if (!kvm_arm_vcpu_sve_finalized(vcpu))
>>  		return num_regs;
>>  
>> +	if (kvm_is_realm(vcpu->kvm))
>> +		return num_regs;
>> +
>>  	for (i = 0; i < slices; i++) {
>>  		for (n = 0; n < SVE_NUM_ZREGS; n++) {
>>  			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>> index 58c5fe7d7572..70ac7971416c 100644
>> --- a/arch/arm64/kvm/hypercalls.c
>> +++ b/arch/arm64/kvm/hypercalls.c
>> @@ -414,14 +414,14 @@ void kvm_arm_teardown_hypercalls(struct kvm *kvm)
>>  
>>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>>  {
>> -	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
>> +	return kvm_is_realm(vcpu->kvm) ? 0 : ARRAY_SIZE(kvm_arm_fw_reg_ids);
>>  }
>>  
>>  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>>  {
>>  	int i;
>>  
>> -	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
>> +	for (i = 0; i < kvm_arm_get_fw_num_regs(vcpu); i++) {
>>  		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
>>  			return -EFAULT;
>>  	}
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index ebb428b861f5..088d900b9c3a 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -5436,18 +5436,18 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>>  				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
>>  }
>>  
>> -static unsigned int num_demux_regs(void)
>> +static inline unsigned int num_demux_regs(struct kvm_vcpu *vcpu)
>>  {
>> -	return CSSELR_MAX;
>> +	return kvm_is_realm(vcpu->kvm) ? 0 : CSSELR_MAX;
>>  }
>>  
>> -static int write_demux_regids(u64 __user *uindices)
>> +static int write_demux_regids(struct kvm_vcpu *vcpu, u64 __user *uindices)
>>  {
>>  	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
>>  	unsigned int i;
>>  
>>  	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
>> -	for (i = 0; i < CSSELR_MAX; i++) {
>> +	for (i = 0; i < num_demux_regs(vcpu); i++) {
>>  		if (put_user(val | i, uindices))
>>  			return -EFAULT;
>>  		uindices++;
>> @@ -5491,11 +5491,28 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
>>  	return true;
>>  }
>>  
>> +static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu,
>> +						 u64 reg)
>> +{
>> +	if (!kvm_is_realm(vcpu->kvm))
>> +		return false;
>> +
>> +	switch (reg) {
>> +	case SYS_ID_AA64DFR0_EL1:
>> +	case SYS_PMCR_EL0:
>> +		return false;
>> +	}
>> +	return true;
>> +}
>> +
>>  static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
>>  			    const struct sys_reg_desc *rd,
>>  			    u64 __user **uind,
>>  			    unsigned int *total)
>>  {
>> +	if (kvm_realm_sys_reg_hidden_user(vcpu, reg_to_encoding(rd)))
> 
> Hi,
> 
> Same as my comment for patch 39, I would suggest moving the
> kvm_is_realm() check out of this function.

Sure, although at least this time the functions were right next to each
other ;)

Thanks,
Steve

> Thanks,
> Wei-Lin Chang
> 
>> +		return 0;
>> +
>>  	/*
>>  	 * Ignore registers we trap but don't save,
>>  	 * and for which no custom user accessor is provided.
>> @@ -5533,7 +5550,7 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>>  
>>  unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
>>  {
>> -	return num_demux_regs()
>> +	return num_demux_regs(vcpu)
>>  		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
>>  }
>>  
>> @@ -5546,7 +5563,7 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>>  		return err;
>>  	uindices += err;
>>  
>> -	return write_demux_regids(uindices);
>> +	return write_demux_regids(vcpu, uindices);
>>  }
>>  
>>  #define KVM_ARM_FEATURE_ID_RANGE_INDEX(r)			\
>> -- 
>> 2.43.0
>>

