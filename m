Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D082C3AFB09
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 08:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781081523; cv=none; b=sgCNtvPxOQODOO4rVEqt4dI8OMjnoYNs3xGuLQ3DnhBpaJlKLRQ5hERdQ97OlewIz8HtXckxoXiSjMfJ84wF278S9as7Lbf3mRj0L1rhjiH6EpwLClecP3C0B3QyhivIn4UDz2l7GifYpLUY8J3QCvuKfY/LFrRliWHRICCugR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781081523; c=relaxed/simple;
	bh=xacY7bSKC3x0+lJqPd5MYeCu8HWXilL7GjU7vsfpDS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D87y0Eet9PmlbOddDyEabKdEqCQQpBruQYgsHtFMiP8ch4FPvGHjAHcMtKjt1UpuU7rgglXVx/zM6ExLGF7tqdKFLcqbPJoGzsneHg0RIsl1vPZLa3A+tkhM9zlU2PSycOhPO2lwCoWSWVjSSd0IomoPEmQVW/3jPpfffJcWXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KC0uB0Uy; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KC0uB0Uy"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bed2195323cso967184366b.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 01:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781081520; x=1781686320; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lcrtc5H86cWPh0Did9l6A+KNce8iS/2PQzso7zvGK7g=;
        b=KC0uB0UyAVni9l+YrnjNw3CJaKax9V/Wq6+qCXNlGazwKRx8QtU867XIn0nkvh9Y3u
         iWuk510Lv4VUWrC5Cl/GfrwHhfn/imvv33fikQfm2/tyXhPvxWi8beyJazV/7MB7LPEz
         XKgP6shLgeyiYV2c9XalJsQhD6gq59cBdk8VBk3CzkiiM1v0FoIkzRbg7XS5sncMu1R3
         2bs0Mlck+WTj0lgR/orl5edm41/FeUKIEk0J329NpHPd1E5vWEn31Pfa2rzpUfqspaqY
         NlzlCCcQl8gpNJ43s1oFNN9DvJA63V2oPu9/ExgD7X6nhaQrD/JJo6fVNNA5AnPvlOtA
         uFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781081520; x=1781686320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lcrtc5H86cWPh0Did9l6A+KNce8iS/2PQzso7zvGK7g=;
        b=H6NbyBXGKKfiLzxeupqORxRLsu8BamrhHWdUj3Q77DMu3b1VsnxC2QlcHZrkgyRTTu
         kc+hAqTjLluVxw9+qjMtOSG9b5Hx63vhNL97cdkb/4PhhVCFKw7YnA4XNFUCPLjLUdRu
         ioOwBIrBPfaNBxqhXscjhVMR8g87s8rF14rPQro4mIJMYWxCXnJJB24tG7xGIsF9DCGO
         r+CCn4fcvz6NPjBcD36Vjv28aUKTlIrnhSZfUpLhx6TNU4lFf5QTd4clhgEYmuXy7OjM
         F7SKUKvtSXLTO8wuMJ1CpHle90MYYKA7osKmyYop5WbVaWloWGc8QuqHHKCZMqBOMQce
         TVnQ==
X-Forwarded-Encrypted: i=1; AFNElJ9XzfRZzU5MeSbNwqWhvLGTxYDZoOyFzggbk4jocDu6PfE+5OPcc3D3WEzh3ZEv3FuL4K3IqNE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyr+odd//8GFi5noAT4UKY2Xgviht0u6bHrCLe7Ns5klXDOYykd
	g5UHjMnIv6fe+WJHIyf9/BsDDPkgvLVtR8d5NU7kVhafvwROd/tnfKc6Su7u1wKexQ==
X-Gm-Gg: Acq92OFS0hP+ckcunChvoSbTXpPXfWPNm1N0E6BYHmZ0K4KFqBZmh6MT03nNGbK8HuP
	Sq1zsf6gJhEtX/op/9qnSquYRFIwFmKYc5vidCFD3yrxFfk79Ldg6D75sG5VH2yFGbMZEcDVHfa
	+W71lo7jQYyyUzB9apdj3vb7zlmafnIxq4vw5yuvMetJ9hd/+Q2s6n9QsM/lloMJBsT8OB/Prtt
	4UGU6oYAtPEF18ujjYmK3id4MrPPXQRSE9jGHzSDBlUb18Kndu21yLSMSSn7Cg2e1JlhN/XYJFu
	07oQh4RP2Oz91Z3U7VpluZDpvWEloxa9iLNKsZvpTPOViJjdHLUQTKBaUuFOfP2E37hwtezcOr6
	RgIoIkMjX8+dj1Tr/yNUzmIjKhHH+Zyok/8lUWHVwv58DmcbxHsiUkT0HxhPd9MmlQ5uuijs4ie
	LbPBQ8mpwaa8/PCP9HKD9byaX8gvHa5G5+WIgkPcfJP2IuOq8qctQUnwLdPWCH4pgwY6XFRdXSf
	O1bsw==
X-Received: by 2002:a17:907:6e94:b0:bf0:550:d9f with SMTP id a640c23a62f3a-bf372159fe1mr1255552166b.31.1781081519868;
        Wed, 10 Jun 2026 01:51:59 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e6585154dsm9549446a12.15.2026.06.10.01.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 01:51:59 -0700 (PDT)
Date: Wed, 10 Jun 2026 09:51:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 1/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_CREATE in host handler
Message-ID: <aiklq5QvztNk8FZR@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <20260608165549.1479409-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608165549.1479409-2-sebastianene@google.com>

Hi Seb,

On Mon, Jun 08, 2026 at 04:55:43PM +0000, Sebastian Ene wrote:
> Allow FF-A notification bitmap creation messages to be forwarded to
> Trustzone from the host and introduce a helper to check for SBZ
> register fields.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 36 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..c20d45191085 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
>  
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> +{
> +	int reg;
> +
> +	for (reg = first_reg; reg < 17; reg++) {

The upper limit should probably be something like ARRAY_SIZE(ctx->regs.regs) - first_reg?

> +		if (cpu_reg(ctxt, reg))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
>  {
>  	*res = (struct arm_smccc_1_2_regs) {
> @@ -676,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BITMAP_CREATE:
>  	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
> @@ -862,6 +873,26 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_notif_bitmap_create(struct arm_smccc_1_2_regs *res,
> +				       struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, vmid, ctxt, 1);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 3)) {

Is that expected we start at 3 but only read 0 and 1?

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (vmid != HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args = (void *)&ctxt->regs.regs[0];
> +	arm_smccc_1_2_smc(args, res);

Should be hyp_smccc_1_2_smc()

> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -920,6 +951,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_BITMAP_CREATE:
> +		do_ffa_notif_bitmap_create(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1064.gd145956f57-goog
> 
