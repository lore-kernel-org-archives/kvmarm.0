Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ABA32C302
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616429; cv=none; b=QIHMG6x9jkCL9JiI8h7pkZ1cSS8a078Ssw7KLJelSNiBhjOQBIgdXA4e5Zazb/FxAGWfx6a1slhzwp0cF98S6DRISrPl/CZnKcU5opN7fFaoHQYsOZh09yKMqJ/qTZ7GcBbMVJbJSDobO3tjsCz98mXypseXvW9YUBFMz8M2pOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616429; c=relaxed/simple;
	bh=nCGZq1Y/w9q0pTP9FjapDpvlqsG0F51qx/wH2o1R7Ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3jD2nkZPx5DD6O4mFuoSjV066oQs3H6mx3T/9/xBqjT7693i2UcV8adEmP9fKfR35U/jqdneuP4UzXyNG7mlqNesZYWTqW9lXrOIw7WFOeLX55c7LliBGXjGx4CfE8KceNjqDFro1vJxaPnrTVTVXcLzxPAvtv+mdyzJL/iz/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GUEaUWzJ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GUEaUWzJ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69532288224so114146a12.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 06:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781616425; x=1782221225; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YK1mdYovXCET+aePqJYcxlz0Er7guRuMQroVpfBxRaQ=;
        b=GUEaUWzJBE8pXaVbqPbDmKddg+kF30USuApL0hZficw96c/Pl1L05LFqUktLp7Hsby
         xXylVYyTbqZYbZsFyYg+Qmi6E6/JGB+yITWtjxr5YS8xy5m2de3QHXP2SX/TE4su5/83
         KbNoF2eRriqYE5cMwFk5X4385fg3kXpTKJq7P8HeGkAokZfwhTSlp26vD/2ZbHyYgPF5
         R2a5lA90gDT8jughbmDmLMDMwgiFFmOxVdW0DTvgf/HbGiMtf+Ho13nT16B2Lo9IsQs3
         AXFRYC6C0VDe+qxtdwECfStiJPUy1fphO+FIse3q0eBX+RTK6rN7T3kwXS2iHArNVksn
         zuyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781616425; x=1782221225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YK1mdYovXCET+aePqJYcxlz0Er7guRuMQroVpfBxRaQ=;
        b=S7GrmMFOjLqNSjSAqwZ/gIyClIyOyTiS46UccLcS+PFdhBNZVGFNkYoN9V6ELHaXev
         yp8MIYH+cdjw+rynGBV7jv4D4/RCZj1AgRmVhVauKq0306BJnD73YmI6DpfRf5CCG4qw
         WpHw4S6F++5zZdz6CSdRs+y5DktpdExLmuL7nkYeZzjYV+054gIJbv6yqD9lYWgmePQ9
         +uy8vlX6JmG6m3jJGssGwX9OmQE1WIt22BcJb+QQkVI7vLM6HsMJqN+dQgLX2+cJrZGg
         G97sq2a8Q8RkRuoNA9I32EvI7pAdsMhiLWcRQNqFP+SzjunkXpXtDrfXwyBQk9aq3tYS
         gWxQ==
X-Forwarded-Encrypted: i=1; AFNElJ/r7xNLtlMs5pQ204W868Fnr4jjnVNPDyoEckuvM+TfUDeRbPTO9xCgF2bk7Yr1TzPAnWhETO4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRjykrwyMbGALdXEErauOj5amCDq/pJQylEPqTV7GoH4zdOVMs
	E+dHn+VSoYRrJ4pVEww/tSVoshyP/Fnaf/8SNLRDmwQ/JNqDHHUqKkyoGfu/PZIb8g==
X-Gm-Gg: Acq92OH8QeVh7xJKErUy93ttdbIhVm4fOQg/3FToCfj7TL3QQxz8KiGK59LFgKCJoxo
	fgW1eZptCajjLB8BQthhocyTQ79KfPh/1+ZJxx3y6lIu2eZ1ljeu1aZjFcVzaZ6aqFrXwL4kPy7
	9K1cyZGEnMdli/zSIOBr1V9CIoOTcVVV8vSGughi6XJyhMdkkdAOsyjPhGDF5kk+iPfq6fuGuC4
	y8aaUzaGHoGo2Ycv23IIO3ydVG3/EbxVI3vzPP/2AB2UENVU3SPlFZ4Rrg/Pf0hnykjXFvB1rZn
	IC/eZsvivX+A/DHCaP6zSrjyroASvSFU2vWkW2GPzQ+kjatRLML86I9E6IugA+R9zF/DHFfLc0s
	FZZ5C402FEgzacRLfPNWr24lso0zAA4T9KepvAOdwNJn2Q7RBCJMOUstN1tu663Yw8brF96BZec
	w3Jn1EQ8GOGMuRyEEIgGXyt4u1fs6S0xeBrV1nA7fde2wVxw4yq/A0zHLdoEmotdUoncU=
X-Received: by 2002:a05:6402:5d0:b0:691:706b:183a with SMTP id 4fb4d7f45d1cf-693788fb0c2mr9398945a12.6.1781616424703;
        Tue, 16 Jun 2026 06:27:04 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6937938a524sm5111182a12.18.2026.06.16.06.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 06:27:03 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:26:58 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 6/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host
 handler
Message-ID: <ajFPIhMGsjqAbtN7@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-9-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616105417.2578670-9-sebastianene@google.com>

On Tue, Jun 16, 2026 at 10:54:15AM +0000, Sebastian Ene wrote:
> Allow FF-A notification GET messages to be proxied from the pKVM
> hypervisor to Trustzone and enforce MBZ/SBZ fields.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index fcfaa441770d..549250ff8f82 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -715,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_GET:
>  	case FFA_NOTIFICATION_INFO_GET:
>  	/* Optional interfaces added in FF-A 1.2 */
>  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> @@ -1001,6 +1000,26 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
>  	arm_smccc_1_2_smc(args, res);
>  }
>  
> +static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
> +			     struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 3)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

Shall we check that the endpoint ID is HOST_FFA_ID here?

> +
> +	if (flags & GENMASK(31, 4)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args = (void *)&ctxt->regs.regs[0];
> +	arm_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -1072,6 +1091,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_NOTIFICATION_SET:
>  		do_ffa_notif_set(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_GET:
> +		do_ffa_notif_get(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
