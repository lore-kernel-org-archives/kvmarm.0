Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5792F4A0C
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781082231; cv=none; b=iDOSx+w4/yqpI/FdCk5xCg6G1LSlwpG+DsbZqbhyWgHq0bfPz78vGhHE1/6ZsH4zPBnz0bkT+QnAaEKg2ZTCcfnq6ZvSNd42V+6knMHDblDWydCvOeCpNFjaDM7FS+OR4peQr3qMXeCZCypEXQUB05bHXcPK1A9aF3Khy7LfS3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781082231; c=relaxed/simple;
	bh=ayMvJgQMsXguQp3a0NEL3PtdJpMC+4QnOu019qlEDkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHI7q9A5xXJqGFF9y1wjGX8kCg5Ytd35+nMPOZGxzypRXgvN3vftj0R192U4w/o5fJSbEVtc9LoHXUZL643+i7HfkUH/Z5WrROwR/A2YHJLPskLuzE+XYMpw1dDWfvpHDMbEn/hyqTvpAotgvMY6a+l0mcuHsQdRkstouD6SmhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WgUIAOBc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WgUIAOBc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490b7866869so71785585e9.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 02:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781082228; x=1781687028; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fzwKzXJwppFYu28O2GOVJSLTLDQbIld8hQ+mf0ErcfI=;
        b=WgUIAOBcNAliFy+HgS4Tbwbu0xvcf8FbcMRNpjuNwCfXLRmLUZCd6PBeStZ4cXBkOX
         jJ+pBcuIB/ylIAC3sSMXw/ikDZXJbzf2VQp0MUfdjRD1iTyl1eemFZ2w0qfMSrxm0zbG
         cFc3DGlqx7zvwh6bj0Ya/Ub5azeaKlGv53KBTzfD/LTzqd1WxoKmjZG+U91s3957tZWZ
         Gt4hcO+tJOSdhH5VmW8acB8xz2F7Mq8v7FI2uY+mJPeFcFcveIcqsAg4x8vGISxBp72r
         VuKX3h4MtXNHuIpzuNXLZVfjLzEvGs5dM6I4HOTsXRKjONeudH2E2GraseBmSUlmRHir
         La4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781082228; x=1781687028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzwKzXJwppFYu28O2GOVJSLTLDQbIld8hQ+mf0ErcfI=;
        b=ZWrUwtij8i2QvaDrXWZeIQ7BEvXhmP2wgjtW9AUFDeAbN/AHr1a2HyT1kOJC4eFjCN
         sXaUprW0WzlsZsnfT2zMj5PGtNd9mwVspnFnpbnbkDUT+m8KeXMPSoETiTlHEpfK5wQN
         yemorkE1xAAJOqiBTgyzq5hQtmbtOot8CshuwMrO0cNkWiENUZRSdF+bBTyBmFBJd5a4
         XgLoFeVA7J5e63l430OOejESAaBQhOr0AGDK6CKZJQV/0BzCyTu2OnBnTgqsYMEeo2m5
         LEiBlbbopQrXuhSWX1pFUICkBNzxNX0Lm9wmJXWDTok9gCwXA2bWLi5yJuEOLqx8I8Sz
         TMyQ==
X-Forwarded-Encrypted: i=1; AFNElJ83Py6ATq+lQpZtd6cCWARB8dvLKeYiy/FfTwiSF0KMOZYFe5kLb3s56UoFiWxJg/njUOQLST0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLA1C1tsId8xtErxvi84lQGykwUkpBFDMUorgYtVQul31rLMUN
	Mz5TtPuIIPjeY8Rvh+MoXH5ShmkQpcEgxO/GhEW2q6++6dk7S/qZkBsoZCLBscTZTg==
X-Gm-Gg: Acq92OF/ky74Jx9bRK8IVlIa6LBNqHaOHdsyAvriwkm8KkZ2xrGAVuTDJCf18N74oMM
	jkdfrbH4eHMjkTau1lFxL7RmSSR6B4gHDjelrSlP5RhJJ4hgFBC5PB2ttGrI104xKJIV/gQfEDk
	Pf1pGpoVRT6p7Hd2NSwV8HfjNpBo4Z0h4vqqXdAP5MJobjsv5OusgOLYPjuhNTQ7acmgvy0jBbb
	Kd5LKaSxGKTJHxQjUi3aoJ40yH2yIDd35FWXGvLxbPM9IEYPeKLmKQgVdL8iktcpuhQrGxZId+6
	Y92vY6JMkFEN6M+zB3lW41994ikdbj1y+J3D/oaxPDnEckoFqdRAYxW51Bp4UcCQ6y5EpvEH5TX
	oz/3e7H/w/8zjXcj5vUIQ85+hRgftugUXQszxenMeyHqi8MNz8csE3/TM/w3QrQ+/F1cx5yVk5S
	ELGmFXEbThBYlTaRObmd46ZU4M522q7lAXjCHkDsN4pZ9pL5+nHp0LvdFoiSr6uUiaNVMKBzF86
	nu1dA==
X-Received: by 2002:a05:600c:3107:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-490c264cc2emr399213575e9.33.1781082228081;
        Wed, 10 Jun 2026 02:03:48 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2eadefsm72447165f8f.11.2026.06.10.02.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 02:03:47 -0700 (PDT)
Date: Wed, 10 Jun 2026 10:03:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host
 handler
Message-ID: <aikobxnyWj_G2iPT@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <20260608165549.1479409-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608165549.1479409-4-sebastianene@google.com>

On Mon, Jun 08, 2026 at 04:55:45PM +0000, Sebastian Ene wrote:
> Verify the arguments of the FF-A notification bind call and forward the
> message to Trustzone.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 91e89d889c44..eedb01955a45 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -42,6 +42,8 @@
>   */
>  #define HOST_FFA_ID	0
>  
> +#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)

Could we move the MASK definitions form arm_ffa to include/linux/arm_ffa.h?

> +
>  /*
>   * A buffer to hold the maximum descriptor size we can see from the host,
>   * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
> @@ -688,7 +690,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
>  	case FFA_NOTIFICATION_SET:
>  	case FFA_NOTIFICATION_GET:
> @@ -912,6 +913,32 @@ static void do_ffa_notif_bitmap_destroy(struct arm_smccc_1_2_regs *res,
>  	arm_smccc_1_2_smc(args, res);
>  }
>  
> +static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, endp_id, ctxt, 1);
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 5)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (flags & GENMASK(31, 1)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

	if (flags > 1) ?

> +
> +	args = (void *)&ctxt->regs.regs[0];
> +	arm_smccc_1_2_smc(args, res);

And of course just like all the other functions, it should use
the hyp_ prefix.

> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -976,6 +1003,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  		do_ffa_notif_bitmap_destroy(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_BIND:
> +		do_ffa_notif_bind(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1064.gd145956f57-goog
> 
