Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D957139023C
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 03:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789011596; cv=none; b=RchOPo0qZb3KGUx7pnJll24K+pLacaykQZzGiEjm1mMwEP93JEC5xy9IRvhek8VNXCREuRBu1IQSG+zX5NEnOLanRdZesU769hLajuxNY9FQiMk2RkD1gChHCl6x1CwOgPrTYlAOG8E1t4BASCxKWWle3GqvThYCpylhfI5vzlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789011596; c=relaxed/simple;
	bh=focBHjviQ8M1TBPFAliwj2P5aU3X0nM6mqhHF/eu8mM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXm6sy4d7mZB9VHVA2LssN3v7cBVc3WWjZtyyEtaNOlv77kvQ9ClXyQyNNONP7Hct/Clpwo5rDd8IE8oUO0a0RK+2s4pwD+HiWW9DPsF4U/1zw+sQC22irzgl/wmmrM+Hd6DRH9vKODG8qZrsJIvrvlvcyC17PY2TndX+hh6O8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vggpw/+s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vggpw/+s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789011591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Abwf0alfy8lmdT9uf0Uv5Evj+p5aY96/emuc9X9I3es=;
	b=Vggpw/+sVBYVI9b1dE8Zz4C1YwZPeVt6BcE1x8KU6gcsPG/WHtQLlfCnZsdmE3wiAgud5r
	DS1QWjrQYa9yeogInG7wGS7t0k/ZyYeky7+xqLOd75Cz1mqWSgkS9ukVypTIFNC/i0jIFL
	HZ1q1nh4+6tl0bzDbISmiGRSkyk01A8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-K5OI0bsIM9Gp-OF5NalLnA-1; Wed, 09 Sep 2026 23:39:50 -0400
X-MC-Unique: K5OI0bsIM9Gp-OF5NalLnA-1
X-Mimecast-MFC-AGG-ID: K5OI0bsIM9Gp-OF5NalLnA_1789011589
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so8834907a91.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 20:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789011589; x=1789616389;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Abwf0alfy8lmdT9uf0Uv5Evj+p5aY96/emuc9X9I3es=;
        b=MICmuXJc+UR06NOFoELXd4097YP0De0HxDIekr04J6bf3WUmefIfJ4+yYN4HP98SMT
         RxdRV9nnHvukTIZjrh5+d0s3PcH2HwGY3nrgwafwvutRY2zS9ILZy2IqoYkeRVUc15E1
         VXMVnXbdNMa73hanFzFbuuhQpFCUzSOnxZ5jcwqWGwjJfD+ESo7jlvhw3IKZU7JePjey
         f+ay9ZGPecYa7exQKx7tVrbxvImZSizUK79vZG5i1Qawi/E6h2Td6MDjVevMtyXY2W1p
         Nrrg2g/7fC+UJsYcQf+7bQj/1laePguFxoEBcTsFtr/wivRZ7+2Rr6nEp0gO8qE5nM+Q
         D2VQ==
X-Forwarded-Encrypted: i=1; AKwUvBxkc8UqrwS7dN/AV15IpOYT3hKtWoyt0dNqFgrbtrjkCPSR0OLAroc921olBhZIWFS3TqOAa0M=@lists.linux.dev
X-Gm-Message-State: AFuF++nPgg16qiAYA1Dmo6Bx4flTcpothdDXQmHyp7MWxDvru6ejkI6C
	wnD1lCbpBS0XNyPkQ3bM/MWNKF+jJp0MTbAp/DtjwLqAJkBxrWE4haBIgqF2ZMztKZKfcHR3gnW
	bmTUjIk+0UDKy2jrQWxpmBJwYkefCA9pCfQzk41mZRZc8ZgGqyFtISBMA5g==
X-Gm-Gg: AYBFou2M6+jO2rv3OIGxDmWRbASMVG5yvc3LG4zIoUq/JrmObfwgvOV0zVzj61dKF4L
	YogFzJvk6LHNsd/uAhXy2OMMKg4K7uasJAeEnfPNvgYogRqlI4KW0D4/t2xslu+UYIYMR7qhbwg
	AXMNsdXWeHNg7KDbF+7HjEsgy/KrYW/I+eA7x5cXxjERN4Klw+Ip22P0CgCmW4IFp0m5y7JLjMv
	qTPYRuPSkHLLNgsnL9DEWqtlbFQvwagsFBLwy590yTCyGofmDFOWMm+10+o88NfN/+eUWiFeSmm
	RZprM1CPk0O7sPLc0oMLaHumVaxm5ChDQf4+3RyZHQFHgc48WufQyclBcRxZ5ZYGFaKPOcKAnw8
	cYX0HIN7c7/KSrvgIQq+Hz/vFS0zOasPTbClPJ9MshQ==
X-Received: by 2002:a17:90b:3852:b0:38e:9ef9:eb97 with SMTP id 98e67ed59e1d1-39b26272d69mr58682607a91.16.1789011588764;
        Wed, 09 Sep 2026 20:39:48 -0700 (PDT)
X-Received: by 2002:a17:90b:3852:b0:38e:9ef9:eb97 with SMTP id 98e67ed59e1d1-39b26272d69mr58682526a91.16.1789011588237;
        Wed, 09 Sep 2026 20:39:48 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e77498csm1527727a91.3.2026.09.09.20.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 20:39:47 -0700 (PDT)
Message-ID: <3cd34b9c-7500-4993-86ff-c1ee9a86b601@redhat.com>
Date: Thu, 10 Sep 2026 13:39:36 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 03/20] KVM: arm64: Track the type of VM in kvm_arch
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-4-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260908162223.1683432-4-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OE8d88gaf208ACvXG4cq94EKRiRJfEHj3xelYYD9yvQ_1789011589
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Suzuki,

On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
> KVM arm64 has different types of VMs with all the different modes in which the
> hypervisor code can be run. e.g., VHE, nVHE, PKVM etc. Then there is protected
> VM and normal VMs with PKVM. We might soon add other types, e.g., Arm CCA Realm.
> So in an effort to make the handling of these different types of VMs a bit more
> friendlier to the eyes, add a VM flavor to the kvm_arch and we could then add
> handlers for different operations based on the VM type.
> 
> Keep the flavor initialisation at the beginning to allow for the detection
> early enough and fail out on any unsupported requests. (e.g., protected on !PKVM)
> 
> With that, use the vm_flavor to detect if a VM is protected VM on PKVM.
> 
> Based on a patch by Marc Zyngier
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 12 ++++++++++--
>   arch/arm64/kvm/arm.c              | 27 ++++++++++++++++++++++++---
>   arch/arm64/kvm/hyp/nvhe/pkvm.c    |  2 +-
>   arch/arm64/kvm/pkvm.c             |  1 -
>   4 files changed, 35 insertions(+), 7 deletions(-)
> 

Some nitpicks below. In either way:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..d0dccc9ad6aa8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -257,7 +257,6 @@ struct kvm_protected_vm {
>   	pkvm_handle_t handle;
>   	struct kvm_hyp_memcache teardown_mc;
>   	struct kvm_hyp_memcache stage2_teardown_mc;
> -	bool is_protected;
>   	bool is_created;
>   
>   	/*
> @@ -306,9 +305,18 @@ enum fgt_group_id {
>   	__NR_FGT_GROUP_IDS__
>   };
>   
> +enum kvm_arm_vm_flavor {
> +	VM_NVHE,
> +	VM_VHE,
> +	VM_PKVM,		/* Normal guests on PKVM */
> +	VM_PROTECTED_PKVM,	/* Protected VM */
> +	VM_FLAVOR_MAX,
> +};
> +
>   struct kvm_arch {
>   	struct kvm_s2_mmu mmu;
>   
> +	enum kvm_arm_vm_flavor vm_flavor;
>   	/*
>   	 * Fine-Grained UNDEF, mimicking the FGT layout defined by the
>   	 * architecture. We track them globally, as we present the
> @@ -1504,7 +1512,7 @@ struct kvm *kvm_arch_alloc_vm(void);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>   
> -#define kvm_vm_is_protected(kvm)	(is_protected_kvm_enabled() && (kvm)->arch.pkvm.is_protected)
> +#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
>   

Here we may introduce one more helper for generic use cases. It's going to
be used in kvm_arch_init_vm().

#define kvm_vm_flavor_eq(kvm, flavor)	((kvm)->arch.vm_flaor == (flavor))
#define kvm_vm_is_protected(kvm)	kvm_vm_flavor_eq(kvm, VM_PROTECTED_PKVM)

>   #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..67f1ff9bc4fbe 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -214,6 +214,26 @@ static int kvm_arm_default_max_vcpus(void)
>   	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>   }
>   
> +static int kvm_init_vm_flavor(struct kvm *kvm, unsigned long type)
> +{
> +	bool protected = type & KVM_VM_TYPE_ARM_PROTECTED;
> +
> +	if (is_protected_kvm_enabled()) {
> +		if (protected)
> +			kvm->arch.vm_flavor = VM_PROTECTED_PKVM;
> +		else
> +			kvm->arch.vm_flavor = VM_PKVM;
> +	} else if (protected) {
> +		return -EINVAL;
> +	} else if (has_vhe()) {
> +		kvm->arch.vm_flavor = VM_VHE;
> +	} else {
> +		kvm->arch.vm_flavor = VM_NVHE;
> +	}
> +
> +	return 0;
> +}
> +
>   /**
>    * kvm_arch_init_vm - initializes a VM data structure
>    * @kvm:	pointer to the KVM struct
> @@ -236,6 +256,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	mutex_unlock(&kvm->lock);
>   #endif
>   
> +	ret = kvm_init_vm_flavor(kvm, type);
> +	if (ret)
> +		return ret;
> +
>   	kvm_init_nested(kvm);
>   
>   	ret = kvm_share_hyp(kvm, kvm + 1);
> @@ -260,9 +284,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   		ret = pkvm_init_host_vm(kvm, type);
>   		if (ret)
>   			goto err_uninit_mmu;
> -	} else if (type & KVM_VM_TYPE_ARM_PROTECTED) {
> -		ret = -EINVAL;
> -		goto err_uninit_mmu;
>   	}
>   
>   	kvm_vgic_early_init(kvm);

We needn't depend on is_protected_kvm_enabled() to call pkvm_init_host_vm() because
the output of is_protected_kvm_enabled() has been updated to kvm->arch.vm_flavor
by previous call kvm_init_vm_flavor().

	if (kvm_vm_is_protected(kvm) || kvm_vm_flavor_eq(kvm, VM_PKVM)) {
		ret = pkvm_init_host_vm(kvm, type);
		if (ret)
			goto err_unit_mmu;
	}

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 459bd9eb7e4bc..09961c0056f2b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -432,7 +432,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>   
>   	hyp_vm->host_kvm = host_kvm;
>   	hyp_vm->kvm.created_vcpus = nr_vcpus;
> -	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
> +	hyp_vm->kvm.arch.vm_flavor = READ_ONCE(host_kvm->arch.vm_flavor);
>   	hyp_vm->kvm.arch.flags = 0;
>   	pkvm_init_features_from_host(hyp_vm, host_kvm);
>   
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8e4c6e4bec123..3948fa46f4d75 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -240,7 +240,6 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
>   		return ret;
>   
>   	kvm->arch.pkvm.handle = ret;
> -	kvm->arch.pkvm.is_protected = protected;
>   	if (protected) {
>   		pr_warn_once("kvm: protected VMs are experimental and for development only, tainting kernel\n");
>   		add_taint(TAINT_USER, LOCKDEP_STILL_OK);

In pkvm_init_host_vm(), the local variable 'protected' is used for once
and can be removed by:

	if (kvm_vm_is_protected(kvm)) {
		pr_warn_once(...);
		add_taint(...);
	}

Thanks,
Gavin

