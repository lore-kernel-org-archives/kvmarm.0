Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47268182D0
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 00:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742343988; cv=none; b=GJ+d3ZQdCMhKmXKKmPLpvH6h4MdMRwcjDEe34bw5aIzZa0lmidBdqlqdSSN8900REFKF8e0eubDwOnTZ8VBNbQAIE/H2vn2oWGHjILlqG+VG6cKulxYn4fecRprbIArYfCmSGHh3aOQaBLN2XOqEqupKcvJqxjnp4+wlJ401Beg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742343988; c=relaxed/simple;
	bh=MzPvjTYC06NQPBeFA+7ORTd+gRsCDYRTAL86Hl46cMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FGLa835GZfOqX7by39KWEJ3cSLKzp+fmIpVrb/pVuXgzedVlb7es47L2znCn8khECPIRVpNybN7vTxt3YBTTGPytqMm7mqFAjzBRfYAzCiCAz1EJlr9kDWig1bmwvn50Gt90AMShDV5cyw+cK1LASZQ6ZOlYLfJFacpSsSNnPn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BKDEEven; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKDEEven"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742343985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dcyfpPUqLHcmXEYYEMoAoUCuMRUkHggn/cuf/nj3QHo=;
	b=BKDEEvenzohFUOrllKLS6W4/gAgTFhPYsnfPxkaFiJVcr1x123XZE+tIBTRVfyJ08B6gtu
	L2+Wr+furp13TdffOYZY3GsrWEZWM8st0chv5Qi88QBBZl6h22sC39oEjA5+NxnlEttUB8
	AJuIpg4xfmrnAeizMN0VrterUTYvr7M=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-fpmP9x9ROYq1zNGFNZmAPw-1; Tue, 18 Mar 2025 20:26:23 -0400
X-MC-Unique: fpmP9x9ROYq1zNGFNZmAPw-1
X-Mimecast-MFC-AGG-ID: fpmP9x9ROYq1zNGFNZmAPw_1742343982
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-223a2770b75so116074595ad.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 17:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742343982; x=1742948782;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dcyfpPUqLHcmXEYYEMoAoUCuMRUkHggn/cuf/nj3QHo=;
        b=tBNi+ocbGpQdV6839hAtVdePpUIwWjpxAq7fEdeHvY1GwhsHw87TXd12VrkfwgRcbA
         aEiaJWCQyuwWpxT/bEnTSP6ICZGp5YEKtaG6NDGkjfYmSbi77bZ/VnmE4Ad/eVeme7+j
         SdrXfO1obEv6+0XrN3xt4mVBpfiuQB5uxGbEOaBFLTpDfFdb8mo/O1qyJyO6ZB/vVw84
         FTxaH/l3f9yig/SIJOzckwtrgxLOMclL0jPEp0V8yrE6WlSXffyGZXz6BQ0Omf6FMeEF
         Ufm03vDX98I3DLZidh8UXux2VweTKPkFH+Djw8xMDSu9KUj3FsmhFiMfch3MGrKo5gI2
         IYjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdJZLH4kS+UIzp+L6wl3ksyoP7ifvTQWiMoGDASHpzToJhewM0EYAU1IMd0k5r0/G9By+iTeY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYNPmQffUu6S1P0l7841msyHA5Bz5gBopGJdKv8ooQ3mEZTBqW
	f4omuqQkvPtCJhQOY+f0hN8A17kL9uvIjly28Q/X7qLoZ9C7TIlT+H4nDybOadNvLKzrewy6V0w
	Y3GfJIw8xZsHgqQcA7feEHuH24NMfAQEnKpqJspdwHccTjvcptpNYvQ==
X-Gm-Gg: ASbGncvoifqhmlI6FsS5JitDq/CjpbDSrxrvDnhzsym3GNWOrDy9mT4XnqSLZm+2KEE
	ox7PqW/jQrIxamAdM8rAmtEjO+nBo+84V8ap4tu3wNFwSFP9rTF5Mlef4WnbohrqErTd6Y+4zZB
	r7Ecw3cUj2N7zMDWcG6hOSbBSDCFZIrxLPBa8gL3+Up8i/iVT/X1u90s5tCiaVoFItwaM8upc3H
	W9OnF2N116ogzqn3BGzafpgrhagK5oZtdVvs/Udao9OKQ5ViCamKdgjYTaqYjgJRPkBPYRw8Jnt
	2m0qdg8std/DedlMzA==
X-Received: by 2002:a17:902:d2c6:b0:21f:bd66:cafa with SMTP id d9443c01a7336-226499365cbmr9077825ad.17.1742343982229;
        Tue, 18 Mar 2025 17:26:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFM1JeJlzG9hcTXu6MosOqDs29giW5SOPOo+RoLQCTNH0YvRQ0etfbZb8zUKi40Yd9vIUSDww==
X-Received: by 2002:a17:902:d2c6:b0:21f:bd66:cafa with SMTP id d9443c01a7336-226499365cbmr9077535ad.17.1742343981868;
        Tue, 18 Mar 2025 17:26:21 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22647996c7asm3545705ad.20.2025.03.18.17.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 17:26:20 -0700 (PDT)
Message-ID: <019afc2d-b047-4e33-971c-7debbbaec84d@redhat.com>
Date: Wed, 19 Mar 2025 10:26:14 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 8/8] KVM: arm64: Eagerly switch ZCR_EL{1,2}
To: Mark Brown <broonie@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
 <20250314-stable-sve-6-12-v1-8-ddc16609d9ba@kernel.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250314-stable-sve-6-12-v1-8-ddc16609d9ba@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dtDETOk60Ae12htLdllekE4i1uONZbXNXY-qim040u4_1742343982
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mark,

On 3/14/25 10:35 AM, Mark Brown wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> [ Upstream commit 59419f10045bc955d2229819c7cf7a8b0b9c5b59 ]
> 
> In non-protected KVM modes, while the guest FPSIMD/SVE/SME state is live on the
> CPU, the host's active SVE VL may differ from the guest's maximum SVE VL:
> 
> * For VHE hosts, when a VM uses NV, ZCR_EL2 contains a value constrained
>    by the guest hypervisor, which may be less than or equal to that
>    guest's maximum VL.
> 
>    Note: in this case the value of ZCR_EL1 is immaterial due to E2H.
> 
> * For nVHE/hVHE hosts, ZCR_EL1 contains a value written by the guest,
>    which may be less than or greater than the guest's maximum VL.
> 
>    Note: in this case hyp code traps host SVE usage and lazily restores
>    ZCR_EL2 to the host's maximum VL, which may be greater than the
>    guest's maximum VL.
> 
> This can be the case between exiting a guest and kvm_arch_vcpu_put_fp().
> If a softirq is taken during this period and the softirq handler tries
> to use kernel-mode NEON, then the kernel will fail to save the guest's
> FPSIMD/SVE state, and will pend a SIGKILL for the current thread.
> 
> This happens because kvm_arch_vcpu_ctxsync_fp() binds the guest's live
> FPSIMD/SVE state with the guest's maximum SVE VL, and
> fpsimd_save_user_state() verifies that the live SVE VL is as expected
> before attempting to save the register state:
> 
> | if (WARN_ON(sve_get_vl() != vl)) {
> |         force_signal_inject(SIGKILL, SI_KERNEL, 0, 0);
> |         return;
> | }
> 
> Fix this and make this a bit easier to reason about by always eagerly
> switching ZCR_EL{1,2} at hyp during guest<->host transitions. With this
> happening, there's no need to trap host SVE usage, and the nVHE/nVHE
> __deactivate_cptr_traps() logic can be simplified to enable host access
> to all present FPSIMD/SVE/SME features.
> 
> In protected nVHE/hVHE modes, the host's state is always saved/restored
> by hyp, and the guest's state is saved prior to exit to the host, so
> from the host's PoV the guest never has live FPSIMD/SVE/SME state, and
> the host's ZCR_EL1 is never clobbered by hyp.
> 
> Fixes: 8c8010d69c132273 ("KVM: arm64: Save/restore SVE state for nVHE")
> Fixes: 2e3cf82063a00ea0 ("KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state")
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Tested-by: Mark Brown <broonie@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Link: https://lore.kernel.org/r/20250210195226.1215254-9-mark.rutland@arm.com
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   arch/arm64/kvm/fpsimd.c                 | 30 -----------------
>   arch/arm64/kvm/hyp/entry.S              |  5 +++
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 59 +++++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 13 ++++----
>   arch/arm64/kvm/hyp/nvhe/switch.c        | 33 +++++++++++++++---
>   arch/arm64/kvm/hyp/vhe/switch.c         |  4 +++
>   6 files changed, 103 insertions(+), 41 deletions(-)
> 

[...]

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 4e757a77322c9efc59cdff501745f7c80d452358..1c8e2ad32e8c396fc4b11d5fec2e86728f2829d9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -5,6 +5,7 @@
>    */
>   
>   #include <hyp/adjust_pc.h>
> +#include <hyp/switch.h>
>   
>   #include <asm/pgtable-types.h>
>   #include <asm/kvm_asm.h>
> @@ -176,8 +177,12 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
>   		sync_hyp_vcpu(hyp_vcpu);
>   		pkvm_put_hyp_vcpu(hyp_vcpu);
>   	} else {
> +		struct kvm_vcpu *vcpu = kern_hyp_va(host_vcpu);
> +
>   		/* The host is fully trusted, run its vCPU directly. */
> -		ret = __kvm_vcpu_run(host_vcpu);
> +		fpsimd_lazy_switch_to_guest(vcpu);
> +		ret = __kvm_vcpu_run(vcpu);
> +		fpsimd_lazy_switch_to_host(vcpu);
>   	}
>   

@host_vcpu should have been hypervisor's linear mapping address in v6.12. It looks
incorrect to assume it's a kernel's linear mapping address and convert it (@host_vcpu)
to the hypervisor's linear address agin, if I don't miss anything.

https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/arch/arm64/kvm/hyp/nvhe/hyp-main.c?h=linux-6.12.y

Thanks,
Gavin

>   out:
> @@ -486,12 +491,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
>   	case ESR_ELx_EC_SMC64:
>   		handle_host_smc(host_ctxt);
>   		break;
> -	case ESR_ELx_EC_SVE:
> -		cpacr_clear_set(0, CPACR_ELx_ZEN);
> -		isb();
> -		sve_cond_update_zcr_vq(sve_vq_from_vl(kvm_host_sve_max_vl) - 1,
> -				       SYS_ZCR_EL2);
> -		break;
>   	case ESR_ELx_EC_IABT_LOW:
>   	case ESR_ELx_EC_DABT_LOW:
>   		handle_host_mem_abort(host_ctxt);
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index ee74006c47bc44ca1d9bdf1ce7d4d8a41cf8e494..a1245fa838319544f3770a05a58eeed5233f0324 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -40,6 +40,9 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
>   {
>   	u64 val = CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
>   
> +	if (!guest_owns_fp_regs())
> +		__activate_traps_fpsimd32(vcpu);
> +
>   	if (has_hvhe()) {
>   		val |= CPACR_ELx_TTA;
>   
> @@ -48,6 +51,8 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
>   			if (vcpu_has_sve(vcpu))
>   				val |= CPACR_ELx_ZEN;
>   		}
> +
> +		write_sysreg(val, cpacr_el1);
>   	} else {
>   		val |= CPTR_EL2_TTA | CPTR_NVHE_EL2_RES1;
>   
> @@ -62,12 +67,32 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
>   
>   		if (!guest_owns_fp_regs())
>   			val |= CPTR_EL2_TFP;
> +
> +		write_sysreg(val, cptr_el2);
>   	}
> +}
>   
> -	if (!guest_owns_fp_regs())
> -		__activate_traps_fpsimd32(vcpu);
> +static void __deactivate_cptr_traps(struct kvm_vcpu *vcpu)
> +{
> +	if (has_hvhe()) {
> +		u64 val = CPACR_ELx_FPEN;
> +
> +		if (cpus_have_final_cap(ARM64_SVE))
> +			val |= CPACR_ELx_ZEN;
> +		if (cpus_have_final_cap(ARM64_SME))
> +			val |= CPACR_ELx_SMEN;
> +
> +		write_sysreg(val, cpacr_el1);
> +	} else {
> +		u64 val = CPTR_NVHE_EL2_RES1;
> +
> +		if (!cpus_have_final_cap(ARM64_SVE))
> +			val |= CPTR_EL2_TZ;
> +		if (!cpus_have_final_cap(ARM64_SME))
> +			val |= CPTR_EL2_TSM;
>   
> -	kvm_write_cptr_el2(val);
> +		write_sysreg(val, cptr_el2);
> +	}
>   }
>   
>   static void __activate_traps(struct kvm_vcpu *vcpu)
> @@ -120,7 +145,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>   
>   	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
>   
> -	kvm_reset_cptr_el2(vcpu);
> +	__deactivate_cptr_traps(vcpu);
>   	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
>   }
>   
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 46c1f5caf007331cdbbc806a184e9b4721042fc0..496abfd3646b9858e95e06a79edec11eee3a5893 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -462,6 +462,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>   
>   	sysreg_save_host_state_vhe(host_ctxt);
>   
> +	fpsimd_lazy_switch_to_guest(vcpu);
> +
>   	/*
>   	 * Note that ARM erratum 1165522 requires us to configure both stage 1
>   	 * and stage 2 translation for the guest context before we clear
> @@ -486,6 +488,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>   
>   	__deactivate_traps(vcpu);
>   
> +	fpsimd_lazy_switch_to_host(vcpu);
> +
>   	sysreg_restore_host_state_vhe(host_ctxt);
>   
>   	if (guest_owns_fp_regs())
> 

