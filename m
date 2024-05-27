Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B718C381C7
	for <kvmarm@lists.linux.dev>; Mon, 27 May 2024 08:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796928; cv=none; b=mlWh9bLLWYlbU8d4fkxQJchm/bron+uVtdU3PCRK9lZxRNctgZQRbkwDdRK9znaq8qWzni4NqGJcohg1Q//bJWp+yvukS1M8ao30q+hDXRTYuh2H+8PkLWy9Lab5ef3ySq1RaUXdz243uxHPxJQAVfkdEPuwo06o97HznuEqIgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796928; c=relaxed/simple;
	bh=/5dCFk8NJutKLk8sOq8BBO8b9omPKKTT2EVYTUJuQSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5ECRKUSxO00i4AiqSsVlhuLdkubBh9VeStEzyypilDrSXhXwf6aqbnYFbIbUwmRXK7hV5acsr3EO2OzYphsnnQ0qx9d4RgxwJp4rBZJKMTDJ2Sy8ysCq8mjZUyCiK5O4MayWMz0StKKKzlc+3A28SqrUcUSztGewhi6B3oT3Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QAIo8Et3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QAIo8Et3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716796925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uvfwrl6p2lQsgl+KleP9a2wnuX8rEgYeIsrgIbVtEzc=;
	b=QAIo8Et3gpJUDk/bYQKD6rhchrzytqt3hyxVcOu9RkP2FJPXex2MQLoRpixukUC1uS115h
	2V0m31MFYOPO81G3hAp9v5CWKttNQQyVP5ZR/CE70akfQiy/2UhDBu5+HBPsPdxIJX6sec
	S7Dh7Y16kEPmSBV+HRJSXoci+8COqfA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-YJ_1LOTNP4KZHuVzAwB8Zg-1; Mon, 27 May 2024 04:02:02 -0400
X-MC-Unique: YJ_1LOTNP4KZHuVzAwB8Zg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1f350d64bddso6341675ad.0
        for <kvmarm@lists.linux.dev>; Mon, 27 May 2024 01:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716796920; x=1717401720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uvfwrl6p2lQsgl+KleP9a2wnuX8rEgYeIsrgIbVtEzc=;
        b=EIGsvP7uiy2NrWWocjZmj2oIu63n6P2o21B5dV56CkeNkjZ6LZwehttlk0sAmAmLPi
         zjNo+/zMoc1PourBkCZqS8yTdWImX4naUeXhvnUoQUwie7koOxEUhfaqdyv2tabLfi3a
         m/z4OYiFw4socJJHwu83Y5yIXT/lvIm9LWCAwiP+sdZEI7lx0UlSwLcIf46Vm7E8XNzG
         Q04uddylQEuZHtzNaCDUKThjEksfDIdTyPVL6p6TFE8fOUzCeiFE3Iz9tqsMZx0O370y
         BDARqp08fmEdHpNGHp0vrkCFnT66sQfpDhNMV6wgZvnvIT8SFUCGxcEjHLlQycbpjqdU
         vECg==
X-Forwarded-Encrypted: i=1; AJvYcCX1UlFQSvwvZWtIXCW3wc7u24RbfBW1LZHMVMaeaMsUpzo/cKxIVpxfbXK9b25nffphzn7bYUCgxKWZulCHzpF30dis3e7J
X-Gm-Message-State: AOJu0YwwUj6/pV4k1ylu90MyRtwZxAkj8jk2L0G48O/fqu1DjgLBlFac
	jbuw3sppcbYFSAyQT+0DhcFALQbSFgyyPdMMI4QNf5vsPD52IuJCjy8WW5tIhLeP499pVMxFTvC
	nLUVjJOHxyY0qvls5tvzqoipyOMrp5/eRvdH1JMxjHowO98p/veF0rw==
X-Received: by 2002:a17:902:f686:b0:1f3:3d5a:e864 with SMTP id d9443c01a7336-1f4494f3db4mr104388835ad.3.1716796920505;
        Mon, 27 May 2024 01:02:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHF3rE4zknZaL/MbeTcB4O+dg0lxcgIOI7m687W5ZMfoqZe5Kp8mqpHr49c8XbjyjPX1Jyg4A==
X-Received: by 2002:a17:902:f686:b0:1f3:3d5a:e864 with SMTP id d9443c01a7336-1f4494f3db4mr104388545ad.3.1716796919968;
        Mon, 27 May 2024 01:01:59 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f478a651f6sm29980435ad.101.2024.05.27.01.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 May 2024 01:01:59 -0700 (PDT)
Message-ID: <080b8820-d665-40d6-9cf2-35e47086d01e@redhat.com>
Date: Mon, 27 May 2024 16:01:56 +0800
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
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240514072252.5657-2-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 5/14/24 15:22, Sebastian Ott wrote:
> There are 2 functions to calculate traps via HCR_EL2:
> * kvm_init_sysreg() called via KVM_RUN (before the 1st run or when
>    the pid changes)
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
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 40 +++++++---------------------
>   arch/arm64/include/asm/kvm_host.h    |  2 +-
>   arch/arm64/kvm/arm.c                 |  2 +-
>   arch/arm64/kvm/sys_regs.c            | 34 +++++++++++++++++++++--
>   4 files changed, 43 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 501e3e019c93..84dc3fac9711 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -69,39 +69,17 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>   
>   static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>   {
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

Could you give more explaination in your comments about why we still 
keep the non-FWB handling in vcpu_reset_hcr()? That would be better for 
understanding the special case.

Thanks,
Shaoqin

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
>   		vcpu->arch.hcr_el2 |= HCR_TVM;
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
>   }
>   
>   static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8170c04fde91..212ae77eefaf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1122,7 +1122,7 @@ int __init populate_nv_trap_config(void);
>   bool lock_all_vcpus(struct kvm *kvm);
>   void unlock_all_vcpus(struct kvm *kvm);
>   
> -void kvm_init_sysreg(struct kvm_vcpu *);
> +void kvm_calculate_traps(struct kvm_vcpu *);
>   
>   /* MMIO helpers */
>   void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9996a989b52e..6b217afb4e8e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -797,7 +797,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>   	 * This needs to happen after NV has imposed its own restrictions on
>   	 * the feature set
>   	 */
> -	kvm_init_sysreg(vcpu);
> +	kvm_calculate_traps(vcpu);
>   
>   	ret = kvm_timer_enable(vcpu);
>   	if (ret)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 22b45a15d068..41741bf4d2b2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4041,11 +4041,33 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
>   	return 0;
>   }
>   
> -void kvm_init_sysreg(struct kvm_vcpu *vcpu)
> +static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm *kvm = vcpu->kvm;
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
>   	/*
>   	 * In the absence of FGT, we cannot independently trap TLBI
> @@ -4054,6 +4076,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>   	 */
>   	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
>   		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
> +}
> +
> +void kvm_calculate_traps(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +	vcpu_set_hcr(vcpu);
>   
>   	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
>   		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;

-- 
Shaoqin

