Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B498A35C691;
	Sun, 20 Sep 2026 22:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789943069; cv=none; b=m0HjCOeROS5803Uj7rzXEATVz4S3UBk/6a9na98gWkxUwODFW782wHeQJym7QftdrLxCp7xe1C0QQmuvGJ3Or1LjOhVDhGwDIW/CVoTDKu7nMKFzhbDmOd8SYKtGdJVJ7hc1IdlN7zP9LQKmEOrBd5mMtW25tszzAV2+k9ZEMak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789943069; c=relaxed/simple;
	bh=1ZS7e05FbYh7KMoROmspJnYoQ1J9lqld6iIIZSlFfwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nsmi5/dzvmlxaq4IVNq6hrPJxQKNsn8RhBlat0ouxdRQUOoxYmSu2u/zsnhz1BeVNRH25DX7bf7IZy3aaxOv9IOEKn4FceoLooaEJH9V5PlRKzq5ZMhLHyKkXQhq1b8+EG7zJQuQ38BpqYcCyGbwUvoIKN3CN1b7WrwOuQjFw/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MGtCYWsS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MGtCYWsS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 706431596;
	Sun, 20 Sep 2026 15:24:23 -0700 (PDT)
Received: from [10.57.7.79] (unknown [10.57.7.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3ED8D3F86F;
	Sun, 20 Sep 2026 15:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789943067; bh=1ZS7e05FbYh7KMoROmspJnYoQ1J9lqld6iIIZSlFfwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MGtCYWsSEdW8LBPB3kQPNubq15/L2DS0DwwFbRepXaYcbkQjWvsY+9LAFT7/4yRNP
	 DA3n68lXTvTunOwr+Sw+y3zrA7VmnvRKVD1lft5QAKaGuYoxO2zzNn3z8iLLY4rPVn
	 2Rmqe5o110+HerOEaoHXN8+FTjg89BdrvnS9cSPo=
Message-ID: <a955032c-3e49-4b51-bf93-dd9718bed16a@arm.com>
Date: Sun, 20 Sep 2026 23:24:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 02/20] KVM: arm64: Disable Steal time accounting for
 protected guests
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-3-suzuki.poulose@arm.com>
 <20260920214421.D84B81F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260920214421.D84B81F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/09/2026 22:44, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] arm64: kvm: contradictory SMCCC advertisement for PV_TIME on protected VMs
> --
> 
> commit db2c057e4ceefd58162587d4fd417788a4db3dbc
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
>      KVM: arm64: Disable Steal time accounting for protected guests
>      
>      PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
>      account the kvm instance. Even with that, a VMM could skip the CAP check
>      and proceed to configure the PVTIME as we don't do further check on the
>      DEVICE_CTRL. Tighten this up by passing the KVM instance around wherever
>      possible and catch things early.
> 
>> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
>> index 4ceabaa4c30bd..579e0a4720ad2 100644
>> --- a/arch/arm64/kvm/pvtime.c
>> +++ b/arch/arm64/kvm/pvtime.c
>> @@ -67,9 +67,9 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>>   	return base;
>>   }
>>   
>> -bool kvm_arm_pvtime_supported(void)
>> +bool kvm_arm_pvtime_supported(struct kvm *kvm)
>>   {
>> -	return !!sched_info_on();
>> +	return !!sched_info_on() && (!kvm || !kvm_vm_is_protected(kvm));
>>   }
> 
> [Severity: Medium]
> Does this create a contradictory SMCCC advertisement for protected VMs?
> 
> A protected guest querying ARM_SMCCC_ARCH_FEATURES_FUNC_ID for
> ARM_SMCCC_HV_PV_TIME_FEATURES in kvm_smccc_call_handler() will receive
> SMCCC_RET_SUCCESS because the KVM_REG_ARM_STD_HYP_BIT_PV_TIME bit is
> still set in std_hyp_bmap:

This looks like an existing issue in the code. I have something
like this to fix this :

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b11b8821c9fbc..6fabcd8aaacb9 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -402,6 +402,9 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)

         smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
         smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
+       /* Clear PV_TIME support for protected VMs */
+       if (kvm_vm_is_protected(kvm))
+               clear_bit(KVM_REG_ARM_STD_HYP_BIT_PV_TIME, 
&smccc_feat->std_hyp_bmap);
         smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;

         mt_init(&kvm->arch.smccc_filter);
@@ -532,6 +535,9 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu 
*vcpu, u64 reg_id, u64 val)
         case KVM_REG_ARM_STD_HYP_BMAP:
                 fw_reg_bmap = &smccc_feat->std_hyp_bmap;
                 fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
+               /* PV_TIME is not supported for protected VMs */
+               if (vcpu_is_protected(vcpu))
+                       clear_bit(KVM_REG_ARM_STD_HYP_BIT_PV_TIME, 
&fw_reg_features);
                 break;
         case KVM_REG_ARM_VENDOR_HYP_BMAP:
                 fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;

Suzuki

> 
> arch/arm64/kvm/hypercalls.c:kvm_smccc_call_handler() {
> 	...
> 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> 		if (test_bit(KVM_REG_ARM_STD_HYP_BIT_PV_TIME,
> 			     &smccc_feat->std_hyp_bmap))
> 			val[0] = SMCCC_RET_SUCCESS;
> 		break;
> 	...
> }
> 
> However, when the guest actually invokes the feature,
> kvm_hypercall_pv_features() returns SMCCC_RET_NOT_SUPPORTED because
> the IPA is unconfigured:
> 
> arch/arm64/kvm/pvtime.c:kvm_hypercall_pv_features() {
> 	...
> 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> 	case ARM_SMCCC_HV_PV_TIME_ST:
> 		if (vcpu->arch.steal.base != INVALID_GPA)
> 			val = SMCCC_RET_SUCCESS;
> 		break;
> 	...
> }
> 
> This violates the SMCCC ABI by advertising ARM_SMCCC_HV_PV_TIME_FEATURES
> as supported but returning NOT_SUPPORTED when it is invoked. Should the
> KVM_REG_ARM_STD_HYP_BIT_PV_TIME bit be cleared for protected VMs?
> 

