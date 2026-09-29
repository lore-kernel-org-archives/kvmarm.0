Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394C852842F;
	Tue, 29 Sep 2026 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688332; cv=none; b=Z+sPn1Pzy+SAoKKTvYE5d2fQxMobFZ7UBuelmtZLKbicc1imjk4+y4TZnLoSpO1Wt6zfTZFfeUHrhfm0nJUdsRhcd9H7yuzXZB7EDDFN0wNpVcFK4NKOI01MBqUcAPpXNh9fBNzIkIdJKYl0lGxdYtCkF/jTcpeOHY9ireJztK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688332; c=relaxed/simple;
	bh=O5C1v4iBpZaSuH+5H0Sd7SeYRTm4i1+4/GL6VjUykRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sY9LkaoR+rT/FBG0eo8xT4b3zZzW4+wF1nGmHJq2ZiDzRf3gIZRoDOTPdfl4QB75emgj6qU3Zd2WG2Zt+5+EDMUD+OdjuTK5p8JHpC92VD+++95c5SSbVpjVYSUVmCgpB9VEXbqKQH8yzAAeI/y5Cu3zvrQamALCOuG2z/3hiYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MrT9z+p8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MrT9z+p8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 094ED143D;
	Tue, 29 Sep 2026 06:25:25 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2CA13F85F;
	Tue, 29 Sep 2026 06:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790688328; bh=O5C1v4iBpZaSuH+5H0Sd7SeYRTm4i1+4/GL6VjUykRk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MrT9z+p8zmAFBUn0ld4/oGHhwhhOXenZRoKpql1JLlZ63gFyuHEBqeuzAxatvor8L
	 pqcAaD7s/2+uvHN6JiqmzleATCBcXs3Rj5WVzf+iJurLtwiiCAfKemk9eJ/xXsXqdY
	 CHSCm8UOIrKtX4eYlcM9Vhe2ST1dSINnR3KPHQDU=
Message-ID: <a3bf2c32-88d9-4fdd-bed5-cb2be108de53@arm.com>
Date: Tue, 29 Sep 2026 14:25:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 18/22] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
 <20260924160504.853911-19-suzuki.poulose@arm.com>
 <20260924162557.766101F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260924162557.766101F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/2026 17:25, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kvm: arm64: CCA: Realm VCPU features bypass capability allowlist
> --
> 
> commit e303d487e75069060645d8d27a0d2607328fb9fc
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests
> 
> Limit the capabilities that are allowed for Realm VMs. Similarly block
> the vm_ioctls backed by the capabilities.
> 
> Repurpose the kvm_pkvm_ioctl_allowed() to support both pKVM and Realm
> ioctls. Rename the helper to kvm_vm_ioctl_allowed() and move it
> into arch/arm64/kvm/arm.c. Also add a generic kvm_vm_ext_allowed()
> to handle pKVM and Realm capability filtering and route them accordingly.
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 0e77f59ded6d9..106b52e556e20 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
> [ ... ]
>> @@ -136,6 +136,49 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>>   	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>>   }
>>   
>> +static inline bool kvm_vm_ext_allowed(struct kvm *kvm, long ext)
>> +{
>> +	/*
>> +	 * We could be called with kvm as NULL, so can't use kvm_vm_* for pKVM
>> +	 * flavors
>> +	 */
>> +	if (is_protected_kvm_enabled())
>> +		return kvm_pkvm_ext_allowed(kvm, ext);
>> +	else if (kvm && kvm_vm_is_realm(kvm))
>> +		return kvm_realm_ext_allowed(ext);
>> +	else
>> +		return true;
>> +}
> 
> [Severity: High]
> While this patch correctly limits VM-level capabilities and ioctls for Realm
> VMs, does it miss restricting VCPU-level features during initialization?
> 
> Looking at kvm_vcpu_init_check_features() in arch/arm64/kvm/arm.c:
> 
> static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
> 					const struct kvm_vcpu_init *init)
> {
> 	unsigned long features = init->features[0];
> 	...
> 	if (features & ~system_supported_vcpu_features())
> 		return -EINVAL;
> 
> Since system_supported_vcpu_features() only checks global host capabilities,
> can a malicious userspace process managing the VM enable restricted VCPU
> features (such as KVM_ARM_VCPU_PMU_V3 or KVM_ARM_VCPU_EL1_32BIT) on a Realm
> VCPU?
> 
> If userspace creates a Realm VM and VCPU, then invokes the KVM_ARM_VCPU_INIT
> ioctl with restricted features set in init.features[0], this could activate
> host KVM emulation logic for a Realm. Would this break the intended isolation
> boundary and lead to inconsistent state or host/RMM crashes when KVM attempts
> to emulate hardware for a Realm managed by the RMM?

The host doesn't get to emulate any of this as the RMM can correctly
handle the Realm VCPU exits. That said, I could restrict the VCPU
features to the ones that are supported for Realms.

--8>--


KVM: arm64: Prevent unsupported vcpu features for VM types

Prevent unsupported VCPU features for the protected VCPUs.
Realms and pVM do not support 32bit EL1 or NV.
pKVM doesn't rely on the host vcpu features, but still
block the vcpu init if we detect incompatible features.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fbd5784e481b6..2e153b4fc8f62 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1727,11 +1727,12 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, 
struct kvm_irq_level *irq_level,
         return -EINVAL;
  }

-static unsigned long system_supported_vcpu_features(void)
+static unsigned long system_supported_vcpu_features(struct kvm_vcpu *vcpu)
  {
         unsigned long features = KVM_VCPU_VALID_FEATURES;

-       if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
+       if (vcpu_is_protected(vcpu) ||
+           !cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
                 clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);

         if (!kvm_supports_guest_pmuv3()) {
@@ -1747,7 +1748,8 @@ static unsigned long 
system_supported_vcpu_features(void)
                 clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
         }

-       if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
+       if (vcpu_is_protected(vcpu) ||
+           !cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
                 clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);

         return features;
@@ -1767,7 +1769,7 @@ static int kvm_vcpu_init_check_features(struct 
kvm_vcpu *vcpu,
                         return -ENOENT;
         }

-       if (features & ~system_supported_vcpu_features())
+       if (features & ~system_supported_vcpu_features(vcpu))
                 return -EINVAL;


Suzuki

> 

