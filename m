Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324FE4A4406
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788361525; cv=none; b=FS9pMYBsWDR85RhyqvAJ6HseaF5kTzvmdsuPUjvqq+trNnRW0VR2WT+iJu8/HSZ2hSm/x4Zjv20f1qKN92dHtc5oKztjN4eMPQVcBHbgRsFGvYsgR9U2cyUc9I13OIzTszHS/uBkZatIcQC/6fQAqhvRevzEvWMDfmW4hUS8HZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788361525; c=relaxed/simple;
	bh=2/YfSi5N9pOc6yZaIdsRfSoS1HN0gJB2ci1jIQiGiqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDY/8fr/P7RwOZdvKWwui/eDMTSo2rnCg3Fq7TCmLIWk9qL1SBI785A15AP/T/GIHKpGBHZvmFkEPcRcl49C8Mk5kf0/CozonkZO7DXvkEtyadRlvZx5vy9CCJq0wSZzE71fZ4jt+ee0qcgH9ChGNhtIAxpxAot1Zho++J1YUdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oaheGheR; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oaheGheR"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-484415c8bf2so931724f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 08:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788361521; x=1788966321; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x+YGRuTP0DFkwY53W+VAP0dMbCx4iIs4U3Fk1KxNIFU=;
        b=oaheGheR+u75uEGKNKdbHKACshfI9772cLY+no3WpAqWneqPOk8rmjUxUrKLjQIjsI
         /olVG4k7yrFSc8XSU7LBKjMV1oM8vqV/21jMgd2OhbL2O76kGS0Zjkc+WXdMse/jwaTS
         oRJ5GQk/KBZJ4Hbx2HhuBuSPuAqzLmUOHjjI2IjONH5DYRXkqwL6uxTIcBOa+xOzzqvi
         PLpkRac+Cdry0r6Dk+9kEthkZNohTFHMzhBHGbedtv9XtW9GUpr7inj8AsytC6ulFDoY
         CM9SBgw/gKFdr3IR91Tw1daeBMHEXbfJB2X+FIlmBHqZcNucjAzWB2jHVs1SDaiUb7Ix
         dchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788361521; x=1788966321;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x+YGRuTP0DFkwY53W+VAP0dMbCx4iIs4U3Fk1KxNIFU=;
        b=BKv6FjjZqxBNTcl0bV+HSzw0zl1Qh/5JDPAxOB0EszOfljKICY2zTtG6PM/ckX/BJN
         tOpKxVEWgn/gLF7g85lMpYqfO5qSA91cA12cMxPFgQiOzzsn5NxskKkupGZIa883bPSo
         xR2rBML6MXg32KBO2b7/XwpxFGBTq1q4vQCfah2OkJmci+FQJ/GXqAT1qagLa2rLCjDc
         ukl1tWKUqbCE/W0cFdAfAS3dUX2W7dN2+Z5KUDY8xpxWrU6Kb6bGrw67/khHqi3mGPqh
         cJvEh4EeLjrBfctP+0ePm/gxFAQHbkPxU1WNXxCskWcoQub+tnNEIn7Rb2INBn+g4a8j
         b9gg==
X-Forwarded-Encrypted: i=1; AHgh+RoR4J5HpmdrD8dtfcC4FJ8OMWWmbrfuGpRLRGTNN7FPqdFseQnAFIqXNDya1RHhE1jY7kFUXSs=@lists.linux.dev
X-Gm-Message-State: AFuF++luM363Vgs7+B8yEsYQITZ68BL2+kimGVwKZcto2q6rYUhXIsef
	8YTERe36CKw23EIhn0BT3GqLPsyNIYn57Qbs4IyommoCTniI1/B1Yuo0EkxwaDqpvA==
X-Gm-Gg: AR+sD13Rdn7KPySF87BKBw6xL+ZXc59iDM3xddtCm5sNqL1DequhuodsPrAvU+Kr26Y
	lcJEKlQOmgGHL/X5LaN9TzIHx3atjSKRYJfqyz466cD9FPw52ZxpM7WpcYgqVvyPQQjx+IR7t45
	AoTln+RLwISpoExcAaAJWr6zNdP0ZtTwVnOxY4TnW7gbvzqmnJXzPTSLwL4GjIvAsNtUx90T03j
	jU6Z5pdDowgK1zYVBKdA/brekgLH7zWOmmFn0639CkXfZarl1wKG3ijEKvZVKsTWbzAb3hRaq9c
	SR5mIXKj1F7rX0D4wgC8isppEEQ1sVC7vDJwbZCKult4nm3HcDuYVqafBahFZjnDdOIFJgG/Frw
	JZATC6Vi0XAkywqqJamAcaFCyqeVtDoCWFIl4mbnGvcQIe2Vk4YB9XCj08BYS4lgJCvgWhEu+78
	aabsJicyRXNLF94qW9cNge88NdemMAp4xrqvZBa98QKgpIlE5Mif8pQo6Hnp9TbQ==
X-Received: by 2002:a05:600c:a086:b0:495:48d7:f178 with SMTP id 5b1f17b1804b1-49ce5815dddmr111164645e9.11.1788361518474;
        Wed, 02 Sep 2026 08:05:18 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce551bf7asm40161205e9.2.2026.09.02.08.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 08:05:16 -0700 (PDT)
Date: Wed, 2 Sep 2026 16:05:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 05/17] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
Message-ID: <apg7KNpamnpYi-kl@google.com>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-6-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163421.272420-6-fuad.tabba@linux.dev>

On Mon, Aug 31, 2026 at 05:34:09PM +0100, Fuad Tabba wrote:
> flush_hyp_vcpu() copies the host's mdcr_el2, TWI/TWE and debug state
> into the hyp vCPU on every entry, so for a protected vCPU the host's
> trap configuration overrides the one pkvm_vcpu_init_traps() computed
> at EL2. Move those copies into the non-protected branch, and sync the
> debug state back for non-protected vCPUs only: a protected guest's
> debug registers are hypervisor-owned, and it takes the host's TWI/TWE
> at vCPU load. MDCR_EL2.TDA traps only the guest's own accesses; it
> does not stop the world switch from loading host-supplied breakpoints
> and MDSCR_EL1.
> 
> EL2's mdcr_el2 starts from 0, and HPMN == 0 is reserved without
> FEAT_HPMN0. Set HPMN to the CPU's event counter count at vCPU load,
> the value the host's copy carried; a protected guest's PMU accesses
> trap regardless.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 31 +++++++++++++++++++-----------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index ca7122b0bccdd..14e847b122abf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -231,7 +231,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	u8 esr_ec;
>  
>  	fpsimd_sve_flush();
> -	flush_debug_state(hyp_vcpu);
>  
>  	/*
>  	 * If we deal with a non-protected guest and the state is potentially
> @@ -241,7 +240,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
>  			flush_hyp_vcpu_state(hyp_vcpu);
> +
> +		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> +		hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> +							 (HCR_TWI | HCR_TWE);
> +
> +		hyp_vcpu->vcpu.arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
>  		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
> +		flush_debug_state(hyp_vcpu);
>  	} else {
>  		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
>  	}
> @@ -249,17 +255,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	/* __hyp_running_vcpu must be NULL in a guest context. */
>  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
>  
> -	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
>  	/*
> -	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
> -	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
> -	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
> +	 * A host-injected vSError is masked by the guest's own PSTATE.A, so it
> +	 * applies to protected guests too.
>  	 */
> -	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
> -	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> -						 (HCR_TWI | HCR_TWE | HCR_VSE);
> -
> -	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
> +	hyp_vcpu->vcpu.arch.hcr_el2 &= ~HCR_VSE;
> +	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) & HCR_VSE;
> +	hyp_vcpu->vcpu.arch.vsesr_el2 = host_vcpu->arch.vsesr_el2;
>  
>  	flush_hyp_vgic_state(hyp_vcpu);
>  
> @@ -288,7 +290,8 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
>  	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
>  
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
> -	sync_debug_state(hyp_vcpu);
> +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		sync_debug_state(hyp_vcpu);

nit: We can't use the else arm below?

>  
>  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
> @@ -329,6 +332,12 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
>  		/* Propagate WFx trapping flags */
>  		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
>  		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
> +
> +		/* HPMN == 0 is reserved without FEAT_HPMN0. */
> +		if (system_supports_pmuv3())
> +			u64p_replace_bits(&hyp_vcpu->vcpu.arch.mdcr_el2,
> +					  FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0)),
> +					  MDCR_EL2_HPMN);
>  	} else {
>  		memcpy(&hyp_vcpu->vcpu.arch.fgt, hyp_vcpu->host_vcpu->arch.fgt,
>  		       sizeof(hyp_vcpu->vcpu.arch.fgt));
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 459bd9eb7e4bc..e85f13233da08 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -102,7 +102,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>  
>  	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP)) {
>  		val |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
> -		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME | MDCR_EL2_HPMN_MASK);
> +		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME);
>  	}
>  
>  	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
> -- 
> 2.39.5
> 
