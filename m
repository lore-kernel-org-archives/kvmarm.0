Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71702E8B81
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875615; cv=none; b=HjF/qtUjO80+24qGWwU+YJ6xNq6+g5eI2yuO6A2okfnqj7HQHXr2pQojh/INPJouF6+e1FAAFWo2JCtp164cWP9REUYwCgkEmS8YFw28akUwAW3bg4gmdgyrG2903JOfTUAzRntFad1Hp7ROQOsB/mR7cVJjMR8Q+mDaQFyMty8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875615; c=relaxed/simple;
	bh=kIJ3OTE/TJBBjVh5kQhDaopE0g5tY1zzMTVwgd6leoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kmm19X1fgHLz1s33qVZz3lziY6jsKgSbhSgfD/INykYHqjXmSJU65f1gA3PVsekkZe4YYzaSIj9MSjFdyKBxHQZPpgW9oO2kbX02MJYuSgD9Ix+j5ZO/uI3L6mEyUo8mbac6Gj0P0kehCWOVFwW83qWmcsa56N5aogrnBySy12Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Db6x7Yhz; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Db6x7Yhz"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so343995966b.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781875612; x=1782480412; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/xtJLMfFE0UEqJ7Wmjx1QUTy4olzjIaKVy5B7F/r2gI=;
        b=Db6x7YhzALOWhpGsqp7I2SQ6WtFnf9jZOqRgRMxZGJ6wi01gbgiC7SPfx+INPQfp2S
         K2p6bwPHbQTxhMuVwDVOymaWcPBEhIOPMwg1z7heON6p5J8+s+aB7NfXD3AwwuJp+sAP
         XUvSfpaOBhaoFiJGstlM5UqBwqXPbd4cMX2xzvMXcZeaEoJh5zxUbXzHiwlBxsu5ezzP
         +HGFiVX6ajhjQNmOPB7ud9gpnAOeRaLEMw/g1naEo3J0VcgfJwR/SOWHYZ6wed2zaW/A
         gRC/7D6ZRQds6mn/yuCNhITLaraYgfcpCdwC0UEUvELBpjcNy3urIFREJMD6f5xpUHHI
         yuvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875612; x=1782480412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xtJLMfFE0UEqJ7Wmjx1QUTy4olzjIaKVy5B7F/r2gI=;
        b=UBzdujF73cr01pK5xAOACgySjAKxYDNOd2Xc2GsZzyQmpLEToVbytYDVLXHtPenXP7
         Fn28FxXcaX+OwZx2/4sRYa6Qek2m1HHb6WqjIuKUbyzm01jmxfNC+rSEM8VAMhY8KL+A
         oTK+UWlPT2CZbmqzKEilJzF1EI3QXtGT8pKDBu/xwxigh5PVMSEXh67zBtiHjC106lrW
         Kv9Vbf+Sz+NQafAVWrcrA4G+yrEvhjdymKnwF9ZxFS4d1T5qKZ/Sr8mT2c5pI4qAS0UP
         DKjnQcLeHljx6rAWLorRVDxIo4PkDQyOJ89wIQCn7O8g/ijluP5FPZ3fndNCsvaKCi7r
         x75Q==
X-Forwarded-Encrypted: i=1; AFNElJ96anUzISPDIYgkyfK+RavkK+gt8hedAwVxNrPev3Pw+si4/Fj+URkTEf9/KnGCNHJpy95JWWs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCe+86h3JvGMHFM265bYvfllahI97Hg7MS7fQJZFoSTiWQ1Ey4
	mR3+SuOxm0cKbednm7akxL766QKHKrdWvfljlkjkYTdmBRROhG5nG1qaTtII7C8lsAhlyHY2A3Q
	soVowVA==
X-Gm-Gg: AfdE7clPE+1yhxxDuIhgM53PPPbQbzMT9pNwopUTbmMk3HEqgP1klzxIyM1vSG1iOUc
	qOdbGCrjnUCp8Lxu8PASnKH3ZpaMmhQdCP7Eja80O2JfAfHrp6KBnHyzEsiXon/kfK9dOV77MoU
	kfboEKRhl1aXSppKxgC79jhzR2SFBQZ96GVxHHhrIbFqVsslX1DYRDGJ/w36Iv12DhMbLJQgEvb
	Qt+oVO69StponHakrTprFsQPapm7jP/v308/hOLrSFsv3feGAKjksiIPnLeWk6L8yOJnmYBaPaO
	CbxhQIPIbqaIqVmtMpHOjjeCSYpH4SwFSspe4qmVkUOrP6V4oAmK3j8B75DhOqOq0OdWs+g+YiJ
	ctOJaUAp0ymoI7A6mtn4b1n40fnhbqkrLACYzDy2n/s7rAHAnfxXLazLyQAeNPewspT+23rT3pK
	xvWJ8WMc5qle2akaxo8POgqYNS6YdD7aC7yDDjuRt/+KCHcmB/sZl/es7D
X-Received: by 2002:a05:600c:3f18:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-49240a34529mr47337995e9.11.1781875601104;
        Fri, 19 Jun 2026 06:26:41 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49240f054e3sm57555245e9.2.2026.06.19.06.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 06:26:38 -0700 (PDT)
Date: Fri, 19 Jun 2026 14:26:34 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH v2 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Message-ID: <ajVDijsleEVAV-ss@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619070719.812227-3-tabba@google.com>

On Fri, Jun 19, 2026 at 08:07:13AM +0100, Fuad Tabba wrote:
> The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
> built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
> shared with hyp code. exception.c already wraps them in
> __vcpu_{read,write}_sys_reg(), which pick the host- or hyp-side accessor
> via has_vhe() and so are valid in any context.
> 
> Move those wrappers to kvm_emulate.h as kvm_vcpu_{read,write}_sys_reg()
> and switch the callers over, so a follow-up series can share that
> emulation code at EL2.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++---
>  arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
>  2 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c..80b30fead3d1 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
>  
> +static inline u64 kvm_vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	if (has_vhe())
> +		return vcpu_read_sys_reg(vcpu, reg);
> +
> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void kvm_vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> +{
> +	if (has_vhe())
> +		vcpu_write_sys_reg(vcpu, val, reg);
> +	else
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +}
> +
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_mode_is_32bit(vcpu)) {
> @@ -516,9 +532,9 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>  
>  		r = vcpu_has_nv(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
>  
> -		sctlr = vcpu_read_sys_reg(vcpu, r);
> +		sctlr = kvm_vcpu_read_sys_reg(vcpu, r);
>  		sctlr |= SCTLR_ELx_EE;
> -		vcpu_write_sys_reg(vcpu, sctlr, r);
> +		kvm_vcpu_write_sys_reg(vcpu, sctlr, r);
>  	}
>  }
>  
> @@ -533,7 +549,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
>  	r = is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
>  	bit = vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
>  
> -	return vcpu_read_sys_reg(vcpu, r) & bit;
> +	return kvm_vcpu_read_sys_reg(vcpu, r) & bit;
>  }
>  
>  static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index bef40ddb16db..2cb68dc7d441 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -20,22 +20,6 @@
>  #error Hypervisor code only!
>  #endif
>  
> -static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> -{
> -	if (has_vhe())
> -		return vcpu_read_sys_reg(vcpu, reg);
> -
> -	return __vcpu_sys_reg(vcpu, reg);
> -}
> -
> -static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> -{
> -	if (has_vhe())
> -		vcpu_write_sys_reg(vcpu, val, reg);
> -	else
> -		__vcpu_assign_sys_reg(vcpu, reg, val);
> -}
> -
>  static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  			      u64 val)
>  {
> @@ -101,14 +85,14 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  
>  	switch (target_mode) {
>  	case PSR_MODE_EL1h:
> -		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
> -		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> -		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
> +		vbar = kvm_vcpu_read_sys_reg(vcpu, VBAR_EL1);
> +		sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		kvm_vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
>  		break;
>  	case PSR_MODE_EL2h:
> -		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
> -		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> -		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
> +		vbar = kvm_vcpu_read_sys_reg(vcpu, VBAR_EL2);
> +		sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +		kvm_vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
>  		break;
>  	default:
>  		/* Don't do that */
> @@ -185,7 +169,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>   */
>  static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
>  {
> -	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +	u32 sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>  	unsigned long old, new;
>  
>  	old = *vcpu_cpsr(vcpu);
> @@ -281,7 +265,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>  {
>  	unsigned long spsr = *vcpu_cpsr(vcpu);
>  	bool is_thumb = (spsr & PSR_AA32_T_BIT);
> -	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +	u32 sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>  	u32 return_address;
>  
>  	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
> @@ -305,7 +289,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>  	if (sctlr & (1 << 13))
>  		vect_offset += 0xffff0000;
>  	else /* always have security exceptions */
> -		vect_offset += __vcpu_read_sys_reg(vcpu, VBAR_EL1);
> +		vect_offset += kvm_vcpu_read_sys_reg(vcpu, VBAR_EL1);
>  
>  	*vcpu_pc(vcpu) = vect_offset;
>  }
> -- 
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
> 
