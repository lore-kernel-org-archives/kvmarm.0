Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8FD17755
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689082217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4embjR8yHEs1N6hH60Rckk7FTcDnPGGpJd8CK6UGxfU=;
	b=DAOR/3yikuCrfmw6MY/fgFBaLWmScpn6RK9MyvlAyOzlaty+WSUAsXk1VgWaQGEvHPST5x
	vaGfDeQNcjIj4GGuM2xsI6/aiv3L9qa02LaLxY3VRZtdQwX6uEj0mGGPjNd9oXP8TAIkRq
	SLUoYqGCdsEK1nij/2gSFapTfWdSMc0=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-y7yWv2YkOPCRVm0oVEtz6A-1; Tue, 11 Jul 2023 09:30:15 -0400
X-MC-Unique: y7yWv2YkOPCRVm0oVEtz6A-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-785d6b1c8ccso46289739f.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 06:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689082214; x=1691674214;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4embjR8yHEs1N6hH60Rckk7FTcDnPGGpJd8CK6UGxfU=;
        b=Rei90ALJMi9oo9P8Gi4LDLjxUyVTUQDj4GCvIXZbrfKCFDvuWwEO5ojMIOPgoaVFWZ
         zO0JXVGpDQPt4mDGWnKKgHVWbFvF6fc+V1qVvwPC8mCVcou6n0WBmemNihJkADA9RGJz
         7/sCIOs0VR3Sw8vI+G6UmE1g5IbZjkVPPmGvNFG1aDnh7jSJ379dpkRi+vl6Waxp59yO
         BdfeAeUuaALo9D+Qvbv8e6eu1pD2axTfCNLBvtW5aGZ0D12b1um3xzZmAcq1v+XppiBC
         jIUV0a63O5mdjlAY9ZmAYZcROdQok9dXivj32wZSj0LqTKcbmb+Cop4bWDBElrC89M8d
         3DBw==
X-Gm-Message-State: ABy/qLbNSiwXhsHGvV/ObmxB7HtuDQP/4yGxKSi9vHi+urqZqf/8KyI9
	RkrVfT+ZES4quXFztZhlKZd2eKtJsz1NOG/9t03KcIVNGCcWPRhttgfW0xT5C2+c4E7mqIHsqo9
	wo4oIEfmwsl4aZjU9
X-Received: by 2002:a92:c688:0:b0:346:3173:2374 with SMTP id o8-20020a92c688000000b0034631732374mr15400097ilg.0.1689082214457;
        Tue, 11 Jul 2023 06:30:14 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF0rhT0sBw2g1YQccz1f6XDguNfmRFr7qqZbIIIodJDGga2C3bv5AjugZlQ7enmmmtyaNlJ2A==
X-Received: by 2002:a92:c688:0:b0:346:3173:2374 with SMTP id o8-20020a92c688000000b0034631732374mr15400073ilg.0.1689082214155;
        Tue, 11 Jul 2023 06:30:14 -0700 (PDT)
Received: from [10.72.12.150] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a23-20020a637f17000000b0055b3af821d5sm1606826pgd.25.2023.07.11.06.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 06:30:13 -0700 (PDT)
Message-ID: <3f7a74af-5450-d01c-6469-fd8a1391d183@redhat.com>
Date: Tue, 11 Jul 2023 21:30:04 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/4] KVM: arm64: Replace vCPU target with a
 configuration flag
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
 <20230710193140.1706399-4-oliver.upton@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230710193140.1706399-4-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/11/23 03:31, Oliver Upton wrote:
> The value of kvm_vcpu_arch::target has been used to determine if a vCPU
> has actually been initialized. Storing this as an integer is needless at
> this point, as KVM doesn't do any microarch-specific emulation in the
> first place. Instead, all we care about is whether or not the vCPU has
> been initialized.
> 
> Delete the field in favor of a vCPU configuration flag indicating if
> KVM_ARM_VCPU_INIT has completed for the vCPU.
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  5 +++--
>   arch/arm64/kvm/arm.c              | 12 +++++-------
>   arch/arm64/kvm/hyp/nvhe/switch.c  |  2 +-
>   3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8b6096753740..b53105bccff9 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -567,8 +567,7 @@ struct kvm_vcpu_arch {
>   	/* Cache some mmu pages needed inside spinlock regions */
>   	struct kvm_mmu_memory_cache mmu_page_cache;
>   
> -	/* Target CPU and feature flags */
> -	int target;
> +	/* feature flags */
>   	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
>   
>   	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
> @@ -669,6 +668,8 @@ struct kvm_vcpu_arch {
>   #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
>   /* PTRAUTH exposed to guest */
>   #define GUEST_HAS_PTRAUTH	__vcpu_single_flag(cflags, BIT(2))
> +/* KVM_ARM_VCPU_INIT completed */
> +#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(3))
>   
>   /* Exception pending */
>   #define PENDING_EXCEPTION	__vcpu_single_flag(iflags, BIT(0))
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3f844934b9f3..13f1bde0bc2d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -360,7 +360,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   #endif
>   
>   	/* Force users to call KVM_ARM_VCPU_INIT */
> -	vcpu->arch.target = -1;
> +	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>   	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>   
>   	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> @@ -569,7 +569,7 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
>   
>   static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
>   {
> -	return vcpu->arch.target >= 0;
> +	return vcpu_get_flag(vcpu, VCPU_INITIALIZED);
>   }
>   
>   /*
> @@ -1051,7 +1051,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   			 * invalid. The VMM can try and fix it by issuing  a
>   			 * KVM_ARM_VCPU_INIT if it really wants to.
>   			 */
> -			vcpu->arch.target = -1;
> +			vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>   			ret = ARM_EXCEPTION_IL;
>   		}
>   
> @@ -1228,20 +1228,18 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>   	    !bitmap_equal(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES))
>   		goto out_unlock;
>   
> -	vcpu->arch.target = init->target;
>   	bitmap_copy(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
>   
>   	/* Now we know what it is, we can reset it. */
>   	ret = kvm_reset_vcpu(vcpu);
>   	if (ret) {
> -		vcpu->arch.target = -1;
>   		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>   		goto out_unlock;
>   	}
>   
>   	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
>   	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags);
> -
> +	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
>   out_unlock:
>   	mutex_unlock(&kvm->arch.config_lock);
>   	return ret;
> @@ -1259,7 +1257,7 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>   	if (ret)
>   		return ret;
>   
> -	if (vcpu->arch.target == -1)
> +	if (!kvm_vcpu_initialized(vcpu))
>   		return __kvm_vcpu_set_target(vcpu, init);
>   
>   	if (kvm_vcpu_init_changed(vcpu, init))
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 0a6271052def..b9caac3e7b1d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -236,7 +236,7 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
>   		 * KVM_ARM_VCPU_INIT, however, this is likely not possible for
>   		 * protected VMs.
>   		 */
> -		vcpu->arch.target = -1;
> +		vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>   		*exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
>   		*exit_code |= ARM_EXCEPTION_IL;
>   	}

-- 
Shaoqin

