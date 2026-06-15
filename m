Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FACE1494A8
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529093; cv=none; b=FpN2doSrPdwkLALHo5JfP2PIPDmDzojFPoK1rIxWk0ddYarYaOzFurrgsT9NHSG7QM1sUyKYyuEeZPk791G/aoC2Boi4c6c6JcbAhenaPjwmTIhef6uWpK2X/pQi709gACNjWpWNfJDe+WOUSHM5ROGDxV3rycXATXU0f3Atacg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529093; c=relaxed/simple;
	bh=cI6CZJti5/aPMIs+HJPMCqFkUJo9NlZ3x9Oc3FXQpMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMmoPg6vyfUAWICq5venFv7GDI12TI9Y7tJOSiU/H0oD5emCBAifb/EV0uq0z4xyTaBxNXfLKQ15DR+SpFUUbdNOO2/4PN4bQ7so8hrOj3r3R5Brcx7g7BJ2ckT2FKAdOs3dYjdczCcrhFvV2eL6Ih4MyAIRmi8+Xhl5FPbp2ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UKXpXURV; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UKXpXURV"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490b3637b90so25266605e9.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781529090; x=1782133890; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OUgsqjBTFZvdCdtQA3mADF26jeRTv++PPR68ymFBShw=;
        b=UKXpXURVIneJ2vwtZewnr3np/jBLhCR8QZ0HLQYyEIXYirhCq3JDJuGs7FypGqeeFi
         oPvnyvlnEsZLae8OQfi+QmCVRF4s8CSvoOUMq9hfLLsY5GOQSF97YTD1Pc4tmalZeH1K
         0AxmGG29Je9KH9gSZ1dERcrdoWtIhMT6oWUj0gs2H6D8WH5QGdoMfJoJZFEv1SXs9iBj
         I9rrNiQInGag0FxSA/wFa5mpwInJvYSwrVOIU4wgiUWHgty4JvaIm6BMKoi9ZqUIBT/j
         WbcZCKgXnZ17L58OnjiXUYyTmPNrMOJjDzSWZAEnE+QTZCEDIkwYv/VT6kB4NyhtEwB9
         4ETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529090; x=1782133890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OUgsqjBTFZvdCdtQA3mADF26jeRTv++PPR68ymFBShw=;
        b=hW9M8NvkLLEWjEUBH5Jzl94jK1sSC/U3UGvrzh6Sbres00ASm9/i4zNOw9iPEgFlbp
         VwWflgUcqDMzatvT4oMbDkY0AzrzpkgZWRNJjnlBpYNJxXGEdt1sVYRJWOgfaNnmoMzq
         eh/iQequG++rtebzL+gqsP5Rjik4TsYd7bdN9vZtftHPyz6Elhdn5LilnMQdDzKfhgSc
         8sQ/ZPLeav+nfkzmGNj+d260KHWWG90jM/gif7lUWF5uyPjNvZb8C/+CvP4XS0J+SIyb
         sR7cSDcpbIMzAy3MR7YXrn7rWaoNx0zp0JKOKm2YiL//GMcH2M4trFu8eUUl6MpR6lRN
         oiGw==
X-Forwarded-Encrypted: i=1; AFNElJ99mdejbbwYT6CJzNXWj/YRqS1YnIbd8efnYFOOrfhgcfLI2T24CRgy+LfXrgVJ7lNjzoQaZjo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeLrKG80e09xgy50boMlWWVOmfCC5vuInCRrnNBaBWPHPCYobp
	NK4d1rKoHNH2qwjtO3Uupg3eTmE6ARepj13YnWlxadB5O4EyJkwKtrL+ClfNWbGFHQ==
X-Gm-Gg: Acq92OEShnWIebIRXcXLZjSRP6K16CFqhRvVEgeOYRDFg37k4EcZa6naUaX6W8sa8xr
	Ky8n+EE039Qouxo358mTMBcaRnUF3kmxa9abaVS0ju+zuvyjIzBq038uz5nr8pOBg9w+8CM/1Rh
	25+DWsZku/P+2UcmN9GrLdZlbqCuoluXKXVXM2H+DsTaHIxV7GIrYrsrw4hB3QQ/H2LF3sjNJrv
	1pdNlgxfZx1BxZoZytOGijfzCfAGTPqJbDpEukdNqW18+9AC5WCEXwjG0ylEeIjEybeDT7Rhz3i
	9slrUJ908ONo3U8u4uhRA6BIlDLR2JyaQC5hY3MfdO51MOu/cxvgzwGoQM4FX+PmLqN2s9QR1Zo
	s8iBC3r+Jg9geU54qO0pmHKOs5lJr5w+AMrP/93sRF4hEdGliPpLwpbOAaE89Yeuxgz0TJl5zYL
	0E8fobr7k2uq5eJNGtlq+Q532Ux89tMiQUkbH0DXSQNMeKsypuw7DAhh3MY9PO5fAu1RA=
X-Received: by 2002:a05:600c:628f:b0:492:1e36:85dc with SMTP id 5b1f17b1804b1-4922017b005mr126783175e9.36.1781529088951;
        Mon, 15 Jun 2026 06:11:28 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95b274sm341373985e9.1.2026.06.15.06.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 06:11:28 -0700 (PDT)
Date: Mon, 15 Jun 2026 14:11:24 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: tabba@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Per Larsen <perlarsen@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 05/11] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Message-ID: <ai_5_CoRm-LdoVMm@google.com>
References: <20260612065925.755562-1-tabba@google.com>
 <20260612065925.755562-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612065925.755562-6-tabba@google.com>

On Fri, Jun 12, 2026 at 07:59:19AM +0100, tabba@google.com wrote:
> The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
> built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
> shared with hyp code. Add _vcpu_read_sys_reg()/_vcpu_write_sys_reg()
> inlines in kvm_emulate.h that dispatch on is_nvhe_hyp_code() to the
> host- or hyp-side accessor. A follow-up series uses this to share that
> emulation code at EL2.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 5bf3d7e1d92c..aed9fc0b717b 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>  	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
>  
> +static inline u64 _vcpu_read_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)

I am not sure a single underscore is widely used in the kernel.

Why not move __vcpu_read_sys_reg() and __vcpu_write_sys_reg() from exception.c
to kvm_emulate.h? especially this already checks has_vhe().

> +{
> +	if (!is_nvhe_hyp_code())
> +		return vcpu_read_sys_reg(vcpu, reg);
> +
> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void _vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
> +{
> +	if (!is_nvhe_hyp_code())
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
> +		sctlr = _vcpu_read_sys_reg(vcpu, r);
>  		sctlr |= SCTLR_ELx_EE;
> -		vcpu_write_sys_reg(vcpu, sctlr, r);
> +		_vcpu_write_sys_reg(vcpu, sctlr, r);
>  	}
>  }
>  
> @@ -533,7 +549,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
>  	r = is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
>  	bit = vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
>  
> -	return vcpu_read_sys_reg(vcpu, r) & bit;
> +	return _vcpu_read_sys_reg(vcpu, r) & bit;
>  }
>  
>  static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
