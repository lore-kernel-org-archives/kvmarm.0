Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FD73624B8
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784026357; cv=none; b=MR4xL7AFPgr7x9U6aN7/qh9BLQ8yUe4kpjnh34vBn+ko8dNK6PNE4+6xZHwBN652jKOOLY5PUStlpTeS5oGVRmbYPINf/oHs9Fr5DwAjn72drFQ4M4eeBPt8wdjJfLXIy27mSsCv+5UU8RNgbGzZX+t5tiuqfwFlZEam1JJdQ48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784026357; c=relaxed/simple;
	bh=Vexbi8LbNZ0QS4cLb6yv6aYgRBpT1oIXj8aRsQVtfE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdX+aAd7rGFlEO4Hvp79PRHXiFKGpgheihpCc/+iXOf5pURHT3E+kL8BoqGDTJljipYSnp1FHCwE2HCy5ayg5aklleZmsz8cdMrep5jJsvOmAToQG3BHOqFR1BHV9Zo0wv/Ddx+DfY8YOuhBkNzPH5EPrQhmFSMdAyJl8NE1ypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rl0rq6L/; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rl0rq6L/"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4728c12ba97so1828590f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 03:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784026354; x=1784631154; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xDprwvx784Xc9BQVIPmW148jZZm4pST3tRcwvdQJB8o=;
        b=Rl0rq6L/IIbowz224ubdrw+P6yOVtNesT7Or4ncvgUr7BX/nI/sL/mG2WKTGXo1quP
         +6hz8od4XOxqvUTwefzfBVCD0Xs8znWrDsqb+2OgeiNGxqCe2Giq/8t2daby9xoSstvL
         9bmEDlqUlH8ycvRHPBO7WwxHOhoM0LE2cH7lOAN0h8mSomKp6u+qhEeO/B2Iith7HZry
         7fAKoFve4s4s9UzajYNv8VMcH7SmJstBowHxhS9KmIKL0enRsBkLd+WF/G+LUA2ZJmpM
         Qpsmu0M+Oh/dvr4J+MYQkItamoQxOXaYOC9DkqdGSQLE7iNT6KAce6XiRxcMdyTTam/f
         Fy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784026354; x=1784631154;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xDprwvx784Xc9BQVIPmW148jZZm4pST3tRcwvdQJB8o=;
        b=gl6l1AekB0ZBmo7Op95PdEzsxw0hjIfZ82opqKc2zYF2nnIM7AL/yAK1BNz7JAdBhT
         a/tgoHd/bjlzzZWNSjYExT1iS8cqL/G6lRCFfVyEgXJMYtyTKp3qPF9Hk0fkH1IWN/b6
         nDlx6O7TpTM3A1JuBzyBpucb5L+6DdKpgYhxtsgw0WYSvKaC2PZv+S+ZCGoFQSaHQOYW
         DfX6LLHiZ4IjNCxCL0TYzI+pwPXKT2gU3pZ/VDieCLqljniPlYFp2PRjsY2E0KXXPjbe
         31sZDhaF02WzZK71MGHU2BoYZOBcna8irtEUr8HZeqTmZFbb+Sy+smFSmSWFgfScY6ro
         MEiQ==
X-Forwarded-Encrypted: i=1; AHgh+RovJVfxcFJiOc6czXsFdIJTBJT5XnXPzW7twKoO6XL1XbR5iVOWJYjaTL48ZCj51DvpHaDWxWI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7yha+hIWBpjfTZ3CB50VCW1tatqNoQYWsqrwgNADRobfHmSSU
	n8WeBZf5VuPZcxZGn1pSTm+lsIU24mn9tkW2DOLTJRlhU7W9nAOG2r59A7FXn+QQ0Q==
X-Gm-Gg: AfdE7cnoAf/17qcoJoFDjnqgyAiim9oeCUyJLmr9crKOQ+Kyfs6+tB4NrLmP+iQOOyS
	Y/ZeHssTqUIYHMdNpRIe9TPkRdmu/JhbvZXApPaarYF9VZCtW3+lB1I6FMJXVDRH3C3FDx9DZjE
	78d1qPkRcEd/M/AeO2MY8krukOSQax7z+zlRuxenYiyxttZcPH7JYoL68xGMeX2ANdKYQxIVG3y
	E4DBrcSF9oKUE1vKKvCQ9pIfdiYWns38ps9qH2AhiAHcugWUpLgIvrPpJxpGZqqKxzxy6O+JGPE
	kjYvQWGas9eYw9AC9gycIQ4aWidgXPa9+uMU6lMFAVbPJTKxGUNVue8+Ilww5IgyjF+S2i+P7no
	BrbtCNYBsMhCtmG8aFkT1nMXxXB5bH5fo+MAh9wu+DI1tJB2ErOyNe1qXMZBm7xveV5Il+saW0x
	FwOqp56X+ZXUgEpc8QCztKhma+Oxub9pAvW6OjP0xLaPk4eXKLgXso98soMWMmLg==
X-Received: by 2002:a05:6000:2388:b0:47d:ec60:657e with SMTP id ffacd0b85a97d-47f2dcecd20mr15005977f8f.39.1784026353902;
        Tue, 14 Jul 2026 03:52:33 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464b7e22sm7262049f8f.25.2026.07.14.03.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:52:33 -0700 (PDT)
Date: Tue, 14 Jul 2026 11:52:29 +0100
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
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v5 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Message-ID: <alYU7ScC3AI1_bi7@google.com>
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714101601.4142645-3-fuad.tabba@linux.dev>

On Tue, Jul 14, 2026 at 11:15:55AM +0100, Fuad Tabba wrote:
> The vcpu_{read,write}_sys_reg() accessors are only valid on a VHE host,
> so helpers built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be()
> cannot be shared with hyp code. exception.c already wraps them in local
> helpers that pick the host- or hyp-side accessor via has_vhe().
> 
> Rename the host-only implementations to __vcpu_{read,write}_sysreg_vhe()
> and turn vcpu_{read,write}_sys_reg() into the context-dispatching
> wrappers, so every caller gets the version valid in any context and a
> follow-up series can share that emulation code at EL2.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
> v5:
>   - Named the wrappers vcpu_{read,write}_sys_reg() and renamed the
>     host-only implementations to __vcpu_{read,write}_sysreg_vhe(), rather
>     than introducing a kvm_vcpu_ prefix. (Oliver)
>   - Dropped Vincent's Reviewed-by since the patch changed materially.
> 
>  arch/arm64/include/asm/kvm_emulate.h | 20 ++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h    |  4 ++--
>  arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
>  arch/arm64/kvm/sys_regs.c            |  4 ++--
>  4 files changed, 33 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c7..429bda6f48d94 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -506,6 +506,26 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
>  
> +/*
> + * __vcpu_*_sysreg_vhe() are only valid on a VHE host; wrap them so the same
> + * call site also works at EL2 under nVHE.
> + */
> +static inline u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
> +{
> +	if (has_vhe())
> +		return __vcpu_read_sysreg_vhe(vcpu, reg);
> +
> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
> +{
> +	if (has_vhe())
> +		__vcpu_write_sysreg_vhe(vcpu, val, reg);
> +	else
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +}
> +
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_mode_is_32bit(vcpu)) {
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5c..f3c3c86b3d7fb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1215,8 +1215,8 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
>  		__v;							\
>  	})
>  
> -u64 vcpu_read_sys_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
> -void vcpu_write_sys_reg(struct kvm_vcpu *, u64, enum vcpu_sysreg);
> +u64 __vcpu_read_sysreg_vhe(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg);
> +void __vcpu_write_sysreg_vhe(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg);
>  
>  struct kvm_vm_stat {
>  	struct kvm_vm_stat_generic generic;
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index bef40ddb16dbc..754e2dc1df54a 100644
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
> +		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
> +		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
>  		break;
>  	case PSR_MODE_EL2h:
> -		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
> -		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> -		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
> +		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL2);
> +		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
>  		break;
>  	default:
>  		/* Don't do that */
> @@ -185,7 +169,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>   */
>  static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
>  {
> -	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +	u32 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>  	unsigned long old, new;
>  
>  	old = *vcpu_cpsr(vcpu);
> @@ -281,7 +265,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>  {
>  	unsigned long spsr = *vcpu_cpsr(vcpu);
>  	bool is_thumb = (spsr & PSR_AA32_T_BIT);
> -	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +	u32 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>  	u32 return_address;
>  
>  	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
> @@ -305,7 +289,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>  	if (sctlr & (1 << 13))
>  		vect_offset += 0xffff0000;
>  	else /* always have security exceptions */
> -		vect_offset += __vcpu_read_sys_reg(vcpu, VBAR_EL1);
> +		vect_offset += vcpu_read_sys_reg(vcpu, VBAR_EL1);
>  
>  	*vcpu_pc(vcpu) = vect_offset;
>  }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 08ba882799d48..c6a416974a61f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -291,7 +291,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
>  	}
>  }
>  
> -u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
> +u64 __vcpu_read_sysreg_vhe(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
>  {
>  	struct sr_loc loc = {};
>  
> @@ -338,7 +338,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
>  	return __vcpu_sys_reg(vcpu, reg);
>  }
>  
> -void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
> +void __vcpu_write_sysreg_vhe(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
>  {
>  	struct sr_loc loc = {};
>  
> -- 
> 2.39.5
> 
