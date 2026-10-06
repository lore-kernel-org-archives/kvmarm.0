Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286FA349CDD;
	Tue,  6 Oct 2026 05:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791266257; cv=none; b=XOCN9i2bkCFSjvukMnc+rTqjIPIurid6r0f+jtqShSID75T9dTBGIbUPtZtvM60xwg2ZkGI9kciA86pbMcbaxpeYhEsRSX2P+zgIjhiYPKQzyY5cHfY6zEF0m3cy5iCuxXFF/vVe+DcRRDSD29m5et4hU1ew7crjL7J6gGefKEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791266257; c=relaxed/simple;
	bh=mY5dNyqjj3br9SOO3XZOQmiarMlcRMC/CJGcY/zLdVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ziw0vGzAa+VjwlXFvsWi8FB7eYpJdplwxGZbTdv907pjQ4gWrE0rD5fpskrbAYJfzzGGIBKuItOQAPecniO/t7pLD2PMUv855WVvEbiXM2GoPgpFTAg5wMk94njIJIY916c9Mqim3PqkhNEwc+wBvAEQAN73KqUGA2LMtqU6sMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SUBLZgBN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SUBLZgBN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0858A1595;
	Mon,  5 Oct 2026 22:57:31 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69C1D3F763;
	Mon,  5 Oct 2026 22:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791266254; bh=mY5dNyqjj3br9SOO3XZOQmiarMlcRMC/CJGcY/zLdVk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SUBLZgBNGh9cG49hV544gkFDVzImp+/Bo8EO4Tc4cw/6lo4+DpOmv9+FKW8EFOaXn
	 S9oF/tyki6HGE3MWROWnATyny7c/gDLLZsN9nrlguXxhQtNYcHyKtXyWdsJCzVT/nO
	 EICoNlRRCYq62u9exRhacXu/QzuN9Z0xoxnNb2r8=
Message-ID: <8f2d69ba-b66f-46ab-8ba2-96e4e618e284@arm.com>
Date: Tue, 6 Oct 2026 07:57:28 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 22/23] KVM: arm64: CCA: Expose SVE VL register before
 VCPU finalization
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-23-suzuki.poulose@arm.com>
 <d330fe17-d9a4-4c6c-9d6c-f47162bbfd14@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <d330fe17-d9a4-4c6c-9d6c-f47162bbfd14@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 06:35, Gavin Shan wrote:
> On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> Userspace must configure the SVE vector length before the Realm is 
>> created
>> (as it is part of the parameter for Realm creation), but the Realm VCPUs
>> cannot be finalized until after the Realm Descriptor has been created.
>>
>> KVM_GET_REG_LIST currently rejects the unfinalized VCPUs, which prevents
>> the userspace from discovering and configuring the VLs for  the Realm.
>>
>> Allow KVM_GET_REG_LIST for unfinalized RECs and make the SVE register
>> enumeration handle the unfinalized case explicitly. i.e., only expose
>> KVM_REG_ARM64_SVE_VLS before SVE is finalized.
>>
>> One adverse side effect of this change is that a KVM_GET_REG_LIST call 
>> that
>> only probes for the array size will now succeed even if SVE is not
>> finalized, but that seems harmless since the following KVM_GET_REG_LIST
>> with the full array will fail.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c   | 15 ++++++++++++++-
>>   arch/arm64/kvm/guest.c | 10 +++++-----
>>   2 files changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index fe707a0c47308..d99e7818f5894 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2004,6 +2004,19 @@ static int kvm_arm_vcpu_set_events(struct 
>> kvm_vcpu *vcpu,
>>       return __kvm_arm_vcpu_set_events(vcpu, events);
>>   }
>> +/*
>> + * Realm VCPUs can be finalized only after the Realm descriptor is 
>> created.
>> + * But in order to seal the SVE VL, we need to allow the userspace to 
>> read/write
>> + * to the SVE_VL, before everything is finalized.
>> + * Allow the register list for RECs before the VCPUs are finalized.
>> + */
>> +static bool kvm_arm_vcpu_reg_list_allowed(struct kvm_vcpu *vcpu)
>> +{
>> +    if (kvm_arm_vcpu_is_finalized(vcpu))
>> +        return true;
>> +    return vcpu_is_rec(vcpu);
>> +}
>> +
> 
> Needn't to keep this helper, and the code can be integrated to 
> kvm_arch_vcpu_ioctl(),
> see below.
> 
>>   long kvm_arch_vcpu_ioctl(struct file *filp,
>>                unsigned int ioctl, unsigned long arg)
>>   {
>> @@ -2059,7 +2072,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>               break;
>>           r = -EPERM;
>> -        if (!kvm_arm_vcpu_is_finalized(vcpu))
>> +        if (!kvm_arm_vcpu_reg_list_allowed(vcpu))
>>               break;
> 
> Needn't to keep the helper kvm_arm_vcpu_reg_list_allowed() after its 
> logic is
> combined to kvm_arch_vcpu_ioctl().
> 
>          /*
>           * Realm vCPUs can be finalized only after the Realm descriptor 
> is created.
>           * We need to allow access KVM_REG_ARM64_SVE_VLS before that so 
> that the
>           * register can be sealed.
>           */
>          if (!(vcpu_is_rec(vcpu) || kvm_arm_vcpu_is_finalized(vcpu))
>              break;


Wanted to keep the ioctl handling section cleaner and easier to read.
Hence the wrapper. The name is intuitive enough and compiler can do
away with inlining.

> 
>>           r = -EFAULT;
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index b01d6622b8720..c3ca369882273 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -598,8 +598,8 @@ static unsigned long num_sve_regs(const struct 
>> kvm_vcpu *vcpu)
>>       if (!vcpu_has_sve(vcpu))
>>           return 0;
>> -    /* Policed by KVM_GET_REG_LIST: */
>> -    WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
>> +    if (!kvm_arm_vcpu_sve_finalized(vcpu))
>> +        return 1; /* KVM_REG_ARM64_SVE_VLS */
> 
> Question: After a (Rec) vCPU is finalized, the returned number of 
> registers won't
> be 1. Is this expected? Otherwise, we need to use vcpu_is_rec() here.
> 
>      /*
>       * KVM_REG_ARM64_SVE_VLS is visible for realm vCPUs no matter if
>       * they have been finalized.
>       */
>      if (vcpu_is_rec(vcpu))
>          return 1;

This is addressed in the next patch.

Cheers
Suzuki

