Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703EE446053;
	Sat,  3 Oct 2026 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791041420; cv=none; b=gE71rCgVq9AuPP1p797gC5v5a7GU9sW1nFurvNwHOJtK7TbP1x9ia4sopwPsLZiztARNFt6frEDj62n3t7HrQ2+3ShM4QGHqdvTpPJ/08iyhfoz0/BBYWQSgl3+Ag+azg8HG58lxRo0hUCqOmZMv9YO+xazD9LSXhY59Bl1Nezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791041420; c=relaxed/simple;
	bh=DqNzmiLqSRpWo/O9PN56Vgk4zOzq2vzIekil+azxtfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uy5Yxc/lwZ/pjCmubg+TUsyIp7deFUJgm+mZR8FulutT/3pHN1LLsoQZn3DPWpn4bFOWKbbIeESfMa5bmbgPo6f6+HDzRSW4weuTMbVJEokd64o3XQEWh5eqU6KEfsdF/PAbXZu/CDljophegGn+6HWMg7ozEl1Nhdre1TG2uoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VsluF5b6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VsluF5b6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B511143D;
	Sat,  3 Oct 2026 08:30:08 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78A283F86F;
	Sat,  3 Oct 2026 08:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791041411; bh=DqNzmiLqSRpWo/O9PN56Vgk4zOzq2vzIekil+azxtfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VsluF5b6kSrZ+AUV4dej8J3hVAA0bso9VTPuE066QFBnPImM3oadyvBD4Og9UtP29
	 50yVKbbIbWEUm/fpCMSMFhuU/77J7B7JoUuvUqrzDggYJQOP30hz3/M2LO4o+uEVYK
	 m0MI8bfOukYnTKVm+bkg7o+Z0KqJJtqTlD7KGh4M=
Message-ID: <9873fb9d-6f32-46f6-bcac-6a52e293d011@arm.com>
Date: Sat, 3 Oct 2026 16:30:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 10/23] KVM: arm64: Add VM specific callback for S2 MMU
 operations
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
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-11-suzuki.poulose@arm.com>
 <86ik3j2m5v.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86ik3j2m5v.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/10/2026 10:01, Marc Zyngier wrote:
> On Thu, 01 Oct 2026 22:06:50 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> Add VM type specific S2 MMU operation backends which can be initialized per
>> VM flavor, to keep the handling cleaner.
>>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v19:
>>   - Add a blank line in kvm_arch_flush_remote_tlbs()


>>   struct kvm_s2_mmu {
>>   	struct kvm_vmid vmid;
>>   
>> @@ -332,6 +345,8 @@ struct kvm_arch {
>>   	 */
>>   	u64 fgu[__NR_FGT_GROUP_IDS__];
>>   
>> +	const struct kvm_vm_s2_ops *vm_s2_ops;
>> +
> 
> If you're touching this patch, can you please move this pointer next
> to the vcpu_ops pointer?

Sure, I will do that.

>> +
>> +static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
>> +	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
>> +	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
>> +	/*
>> +	 * Not supported for Protected VMs under pKVM
>> +	 * .vm_age_gfn
>> +	 * .vm_test_age_gfn
>> +	 * .vm_stage2_unmap_range
>> +	 */
> 
> I really think we should have *something* here that returns
> "unsupported", and avoid NULL-checks in the dispatchers.

Ack

> 
>> +};
>> +
>> +static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
>> +	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
>> +	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
>> +	.vm_age_gfn			= kvm_vm_age_gfn,
>> +	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
>> +	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
> 
> and since we have this: can we get rid of the KVM_PGT_FN() hack?

Ack, I will give it a go.


>> +#define KVM_VM_S2_OPS(flavor, ops)		\
>> +		[flavor] = ops
>> +static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
>> +	KVM_VM_S2_OPS(VM_VHE, &kvm_default_vm_s2_ops),
>> +	KVM_VM_S2_OPS(VM_NVHE, &kvm_default_vm_s2_ops),
>> +	KVM_VM_S2_OPS(VM_PKVM, &pkvm_vm_s2_ops),
>> +	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, &protected_pkvm_vm_s2_ops),
> 
> nit: move the '&' into the macro.

Ack.

Suzuki

