Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17A146426
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088073; cv=none; b=GzmVk3DBJPbQQVFCJKSYbZx2u3E+19iMDOblSAmaBr80fKQt6X3PPc0oySfc/wIPyg2cLOJIc1ALYo659RN7qrkYG/BCeOAj+hey/RUifSI4u/LQncyzbMnKptn5ck829nW7InQfHdqih5qVHxb1akK1J59ioRh6BqIAVlkCSEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088073; c=relaxed/simple;
	bh=7QBBdc2gEBL0gQR+6v66Er2YlxfWZgsfdu8zbdBsWcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDTSiZ7wXKkqJLvB5Keu51EWsxSWqz3A0NZ4D1kmbxWc6X3ZRu8TmOVLnnXPYepCwnd08rjFRl3+pgnGCoPAD7xMwQ94iS0j6hM3G7S9u/se7P5dko3cnaBliHhNnh9zppnMZD7IeDYszAOVDGr2g1tFfwD2Is6+iP4mYrRcnKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=acEm+MoT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acEm+MoT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=68Kurr4BfZ1gyKcBEcfRtfQBSGTTMRg2Hw69vW65Lfg=;
	b=acEm+MoTtLvhoxgfyuY5qbHzjr4H+I3nmLLpF17xn/eLhebk6+IBsr4t6jjJagcS4IwjK7
	ZrH/vm4LquuyOBtpg57nA8nST/EddziB2LyUbo1m17oCDRFMDU9UjoOmqjAxzeSdpYr9QR
	611Q/GtUvgg5S04OOdSjMfHYwbMCa5k=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-990dBtxwNs6cYuR5MlKuvg-1; Thu, 30 May 2024 12:54:28 -0400
X-MC-Unique: 990dBtxwNs6cYuR5MlKuvg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2e95a1fae88so8595341fa.0
        for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 09:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717088066; x=1717692866;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68Kurr4BfZ1gyKcBEcfRtfQBSGTTMRg2Hw69vW65Lfg=;
        b=TJIkc+QJG7ZMDW6L0pfrGQEQK5X+m6sucy+xKT1dX7GhUzpYqIFXwQ1vdosczvnEg7
         XQXndaUkNkYA7BwByr2EirF+ie9HwvNe/bGQflfGmYZJug10/9VjaxuxtZB3Ofyp3B5P
         ZycmmhFPueO8Oo/0B6hFfFcjXqnPFa1DoMm1ISJGYw3o7lsDg19ccvYj0j1MiPXmnZUU
         ipwJmX2oB2RCWWRVsK3qFndBOui0iRH61VK2n8SLMApl2j5/M9TKE1FSztB9xsQw4hQt
         OZp7SnwClhKZIKAbqgEojTyC05Hxp4P951YGzrWEmmdlTJq83IZNnG0WGCDtQ8WuR2ig
         txjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYEEWNr1PT1TGqTfaTe94Rx8pzBPQRYBuNI4kGQg3gS7zUebb/hhueYBbe6DB+FLLQ18QqynDMd+uWlsvNQpvBiwoY+yp8
X-Gm-Message-State: AOJu0YwSvJXeVBaDLnPKGLOvsXZKUt8Mq83gziSgb+QQRdopnvH7fC1W
	7UkNd9e+1eoBEnhQ16phMs18SaE9CuUG7M+GEb1ekpUeqK9tN/5XHAYig48tEA/PHJYxKf7ImjF
	nhFapvnhSE9n3P8wzi5BzDGY6SMi+HABHztgkujbRFBG1pX3XvYsyiA==
X-Received: by 2002:a2e:a318:0:b0:2d9:eb66:6d39 with SMTP id 38308e7fff4ca-2ea8479eb34mr16312961fa.19.1717088066228;
        Thu, 30 May 2024 09:54:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCtFrOcPal8gAxUzgThmctkJuMxxVUPJIUlJQceyvgsmxOQyKiZljTKA1Z03FHpKV6NGPlpw==
X-Received: by 2002:a2e:a318:0:b0:2d9:eb66:6d39 with SMTP id 38308e7fff4ca-2ea8479eb34mr16312801fa.19.1717088065773;
        Thu, 30 May 2024 09:54:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212b83d4e2sm531185e9.2.2024.05.30.09.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 09:54:25 -0700 (PDT)
Message-ID: <cea5b9e9-99c1-47cb-bb2f-cdb922f4d349@redhat.com>
Date: Thu, 30 May 2024 18:54:23 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] KVM: arm64: unify code to prepare traps
To: Sebastian Ott <sebott@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-2-sebott@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240514072252.5657-2-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 5/14/24 09:22, Sebastian Ott wrote:
> There are 2 functions to calculate traps via HCR_EL2:
> * kvm_init_sysreg() called via KVM_RUN (before the 1st run or when
>   the pid changes)
> * vcpu_reset_hcr() called via KVM_ARM_VCPU_INIT
> 
> To unify these 2 and to support traps that are dependent on the
> ID register configuration, move the code from vcpu_reset_hcr()
> to sys_regs.c and call it via kvm_init_sysreg().
> 
> We still have to keep the non-FWB handling stuff in vcpu_reset_hcr().
> Also the initialization with HCR_GUEST_FLAGS is kept there but guarded
> by !vcpu_has_run_once() to ensure that previous calculated values
> don't get overwritten.
> 
> While at it rename kvm_init_sysreg() to kvm_calculate_traps() to
> better reflect what it's doing.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>

Looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arch/arm64/include/asm/kvm_emulate.h | 40 +++++++---------------------
>  arch/arm64/include/asm/kvm_host.h    |  2 +-
>  arch/arm64/kvm/arm.c                 |  2 +-
>  arch/arm64/kvm/sys_regs.c            | 34 +++++++++++++++++++++--
>  4 files changed, 43 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 501e3e019c93..84dc3fac9711 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -69,39 +69,17 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>  
>  static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  {
> -	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
> -	if (has_vhe() || has_hvhe())
> -		vcpu->arch.hcr_el2 |= HCR_E2H;
> -	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
> -		/* route synchronous external abort exceptions to EL2 */
> -		vcpu->arch.hcr_el2 |= HCR_TEA;
> -		/* trap error record accesses */
> -		vcpu->arch.hcr_el2 |= HCR_TERR;
> -	}
> +	if (!vcpu_has_run_once(vcpu))
> +		vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>  
> -	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
> -		vcpu->arch.hcr_el2 |= HCR_FWB;
> -	} else {
> -		/*
> -		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
> -		 * get set in SCTLR_EL1 such that we can detect when the guest
> -		 * MMU gets turned on and do the necessary cache maintenance
> -		 * then.
> -		 */
> +	/*
> +	 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
> +	 * get set in SCTLR_EL1 such that we can detect when the guest
> +	 * MMU gets turned on and do the necessary cache maintenance
> +	 * then.
> +	 */
> +	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
>  		vcpu->arch.hcr_el2 |= HCR_TVM;
> -	}
> -
> -	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
> -	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
> -		vcpu->arch.hcr_el2 |= HCR_TID4;
> -	else
> -		vcpu->arch.hcr_el2 |= HCR_TID2;
> -
> -	if (vcpu_el1_is_32bit(vcpu))
> -		vcpu->arch.hcr_el2 &= ~HCR_RW;
> -
> -	if (kvm_has_mte(vcpu->kvm))
> -		vcpu->arch.hcr_el2 |= HCR_ATA;
>  }
>  
>  static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8170c04fde91..212ae77eefaf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1122,7 +1122,7 @@ int __init populate_nv_trap_config(void);
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
>  
> -void kvm_init_sysreg(struct kvm_vcpu *);
> +void kvm_calculate_traps(struct kvm_vcpu *);
>  
>  /* MMIO helpers */
>  void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9996a989b52e..6b217afb4e8e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -797,7 +797,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  	 * This needs to happen after NV has imposed its own restrictions on
>  	 * the feature set
>  	 */
> -	kvm_init_sysreg(vcpu);
> +	kvm_calculate_traps(vcpu);
>  
>  	ret = kvm_timer_enable(vcpu);
>  	if (ret)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 22b45a15d068..41741bf4d2b2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4041,11 +4041,33 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
>  	return 0;
>  }
>  
> -void kvm_init_sysreg(struct kvm_vcpu *vcpu)
> +static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  
> -	mutex_lock(&kvm->arch.config_lock);
> +	if (has_vhe() || has_hvhe())
> +		vcpu->arch.hcr_el2 |= HCR_E2H;
> +	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
> +		/* route synchronous external abort exceptions to EL2 */
> +		vcpu->arch.hcr_el2 |= HCR_TEA;
> +		/* trap error record accesses */
> +		vcpu->arch.hcr_el2 |= HCR_TERR;
> +	}
> +
> +	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +		vcpu->arch.hcr_el2 |= HCR_FWB;
> +
> +	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
> +	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
> +		vcpu->arch.hcr_el2 |= HCR_TID4;
> +	else
> +		vcpu->arch.hcr_el2 |= HCR_TID2;
> +
> +	if (vcpu_el1_is_32bit(vcpu))
> +		vcpu->arch.hcr_el2 &= ~HCR_RW;
> +
> +	if (kvm_has_mte(vcpu->kvm))
> +		vcpu->arch.hcr_el2 |= HCR_ATA;
>  
>  	/*
>  	 * In the absence of FGT, we cannot independently trap TLBI
> @@ -4054,6 +4076,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  	 */
>  	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
>  		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
> +}
> +
> +void kvm_calculate_traps(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +	vcpu_set_hcr(vcpu);
>  
>  	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
>  		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;

