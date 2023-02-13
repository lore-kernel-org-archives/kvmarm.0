Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAAD399;
	Mon, 13 Feb 2023 16:35:37 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id y7so4647691iob.6;
        Mon, 13 Feb 2023 08:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676306136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rlnKFgrRUm8Uq6241EeorSyjCYr9c9HFlGFvXdOyL8=;
        b=pwEvTbpuPD909QsbFce8wQK8GLxAqY/YRJ8l5yTI2LF1etbDxBJyppNy1pw3sccpMT
         V/hOgCwIYM24FniVQ3CFzjUAQczUHEZS/y/O/cG6gtnPs5aSOCNiUnpISn6jHLMt3av8
         UACyMYfr25ionq5s0vVIHsFkKSb/5mxhx/FDrQClY4po/ISPFHwrr+7VpWuXkDmRfg8E
         Kl+bVUQ9A5mxRhQveagrtS9J5Xexml9HYe3uEVQFQUUos0sJFLWTtBUa6H4qkml0YroF
         prnTaAGzt9AKzQcMQbv++KTD7xkPmuNIK5G/pKJIhAlOPXRSY5Rgj9YAL+D9MCyNHQ1o
         WvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676306136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rlnKFgrRUm8Uq6241EeorSyjCYr9c9HFlGFvXdOyL8=;
        b=YiGoYJ2sjBBr4+9NJoypl+jtwidznHE321WDDAhEd3Hk17iSHQb6Tk3a10F1icPaMM
         4jYqjMRtbhkiVDR3eQbgkoABK+ep29w4SnzXq1goCBj9zSnQacdp/9rqRXJGlBqSnN0X
         dIqz6OSj2d6mYCTaKTRV7Jq3FbRJiktCyhafACqXbh9qYqvpE3fpWzImpAoUuMacEoPA
         h1IMzYrfS61pqwOucu3+nQ6tdke8wn7nJ15YMdGsh7d2HyZ4E0JDLm0/mHfO6rC48b2Q
         p8b3yPJrHOJ94lod09fPPAQT6pinPakRAsRDMGVfScgSuQYC24MydYLDdO49UQWcDc08
         W3pA==
X-Gm-Message-State: AO0yUKXFgC5bivJtPMF7ZVRgk+hTgE7HvfBiRYtWUNIJu/ZxhvPhc0lh
	vUAQQt//61Otej4c5GWfKVKXoqhx1zXJ5A==
X-Google-Smtp-Source: AK7set8mRhRxVIVEf9OHVXJ6AT7dvTcgh2wGFkhbQuyPdTKuJ72bGM96bYuK7fsFHHVXsPTbWCfkQA==
X-Received: by 2002:a6b:7d4c:0:b0:715:f031:a7f5 with SMTP id d12-20020a6b7d4c000000b00715f031a7f5mr16953693ioq.1.1676306136640;
        Mon, 13 Feb 2023 08:35:36 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id g5-20020a02c545000000b0038a6ae38ceasm4206262jaj.26.2023.02.13.08.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:35:36 -0800 (PST)
Date: Mon, 13 Feb 2023 18:35:30 +0200
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
 <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
 <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 07/28] arm64: kvm: Allow passing machine type in KVM
 creation
Message-ID: <20230213183530.00006d35@gmail.com>
In-Reply-To: <20230127112932.38045-8-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
	<20230127112932.38045-1-steven.price@arm.com>
	<20230127112932.38045-8-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Jan 2023 11:29:11 +0000
Steven Price <steven.price@arm.com> wrote:

> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/arm.c     | 13 +++++++++++++
>  arch/arm64/kvm/mmu.c     |  3 ---
>  arch/arm64/kvm/reset.c   |  3 ---
>  include/uapi/linux/kvm.h | 19 +++++++++++++++----
>  4 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50f54a63732a..badd775547b8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -147,6 +147,19 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>  	int ret;
>  
> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +		return -EINVAL;
> +
> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
> +	case KVM_VM_TYPE_ARM_NORMAL:
> +		break;
> +	case KVM_VM_TYPE_ARM_REALM:
> +		kvm->arch.is_realm = true;

It is better to let this call fail when !kvm_rme_is_available? It is
strange to be able to create a VM with REALM type in a system doesn't
support RME.

> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>  	ret = kvm_share_hyp(kvm, kvm + 1);
>  	if (ret)
>  		return ret;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d0f707767d05..22c00274884a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -709,9 +709,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  	u64 mmfr0, mmfr1;
>  	u32 phys_shift;
>  
> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -		return -EINVAL;
> -
>  	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>  	if (is_protected_kvm_enabled()) {
>  		phys_shift = kvm_ipa_limit;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index c165df174737..9e71d69e051f 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -405,9 +405,6 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
>  	if (kvm_is_realm(kvm))
>  		ipa_limit = kvm_realm_ipa_limit();
>  
> -	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -		return -EINVAL;
> -
>  	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>  	if (phys_shift) {
>  		if (phys_shift > ipa_limit ||
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index fec1909e8b73..bcfc4d58dc19 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -898,14 +898,25 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_S390_SIE_PAGE_OFFSET 1
>  
>  /*
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
>   */
> +#define KVM_VM_TYPE_ARM_SHIFT		8
> +#define KVM_VM_TYPE_ARM_MASK		(0xfULL << KVM_VM_TYPE_ARM_SHIFT)
> +#define KVM_VM_TYPE_ARM(_type)		\
> +	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
> +#define KVM_VM_TYPE_ARM_NORMAL		KVM_VM_TYPE_ARM(0)
> +#define KVM_VM_TYPE_ARM_REALM		KVM_VM_TYPE_ARM(1)
> +
>  #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
>  #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
>  	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +
>  /*
>   * ioctls for /dev/kvm fds:
>   */

