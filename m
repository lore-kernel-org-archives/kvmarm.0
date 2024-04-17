Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C723613C829;
	Wed, 17 Apr 2024 10:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713349238; cv=none; b=rC4pXZEy1mHeo6QkSNjOG5AUoHQ1oxaME2RDH5xB/2RwBdZAkTGXYIRkDtaRocIyv1pBF/yPQfeYEanesT9PXwXzWxm0g2p+guxX2/sHucVkKAg43lgmVk/3sN3RtXqVgT8oyufH+qqnyfQxB0BSzSSqT5+7vKDPDzJxO/lrziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713349238; c=relaxed/simple;
	bh=kvpTxfMFvPgem01ruuxJKhDVMFpsajEnyI7JrOnz7sY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZaIiFrhitZeRgkEvrepwoDzER8+tVd4KDvptmDpUrSnaLc2p48EaEk20d5COFfQ99nJPKsXAelkYmkRAuEkDcs+t9yCTmrnfUCCBtN/gFE2jMd1cgunIaJt0vGcJI4K77B395AUcDe6OQiSXuGn2VZ5+xiaoZ435V5C8Lb1X62o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 221B1339;
	Wed, 17 Apr 2024 03:21:04 -0700 (PDT)
Received: from [10.1.39.28] (FVFF763DQ05P.cambridge.arm.com [10.1.39.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34BC53F64C;
	Wed, 17 Apr 2024 03:20:33 -0700 (PDT)
Message-ID: <711484c0-efae-45ff-8373-69d45dd88832@arm.com>
Date: Wed, 17 Apr 2024 11:20:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/43] arm64: kvm: Allow passing machine type in KVM
 creation
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-12-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-12-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2024 09:42, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c     | 17 +++++++++++++++++
>   arch/arm64/kvm/mmu.c     |  3 ---
>   include/uapi/linux/kvm.h | 19 +++++++++++++++----
>   3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 22da6493912a..c5a6139d5454 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -173,6 +173,23 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	mutex_unlock(&kvm->lock);
>   #endif
>   
> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +		return -EINVAL;
> +
> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
> +	case KVM_VM_TYPE_ARM_NORMAL:
> +		break;
> +	case KVM_VM_TYPE_ARM_REALM:
> +		kvm->arch.is_realm = true;
> +		if (!kvm_is_realm(kvm)) {
> +			/* Realm support unavailable */
> +			return -EINVAL;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>   	ret = kvm_share_hyp(kvm, kvm + 1);
>   	if (ret)
>   		return ret;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index aae365647b62..af4564f3add5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -877,9 +877,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	if (kvm_is_realm(kvm))
>   		ipa_limit = kvm_realm_ipa_limit();
>   
> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -		return -EINVAL;
> -
>   	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>   	if (is_protected_kvm_enabled()) {
>   		phys_shift = kvm_ipa_limit;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a1147036d1bd..5153c837c8c7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -635,14 +635,25 @@ struct kvm_enable_cap {
>   #define KVM_S390_SIE_PAGE_OFFSET 1
>   
>   /*
> - * On arm64, machine type can be used to request the physical
> - * address size for the VM. Bits[7-0] are reserved for the guest
> - * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
> - * value 0 implies the default IPA size, 40bits.
> + * On arm64, machine type can be used to request both the machine type and
> + * the physical address size for the VM.
> + *
> + * Bits[11-8] are reserved for the ARM specific machine type.
> + *
> + * Bits[7-0] are reserved for the guest PA size shift (i.e, log2(PA_Size)).
> + * For backward compatibility, value 0 implies the default IPA size, 40bits.
>    */
> +#define KVM_VM_TYPE_ARM_SHIFT		8
> +#define KVM_VM_TYPE_ARM_MASK		(0xfULL << KVM_VM_TYPE_ARM_SHIFT)
> +#define KVM_VM_TYPE_ARM(_type)		\
> +	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
> +#define KVM_VM_TYPE_ARM_NORMAL		KVM_VM_TYPE_ARM(0)
> +#define KVM_VM_TYPE_ARM_REALM		KVM_VM_TYPE_ARM(1)
> +
>   #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
>   #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
>   	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +
>   /*
>    * ioctls for /dev/kvm fds:
>    */


Looks good to me.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

