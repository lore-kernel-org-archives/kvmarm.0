Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F2946D2CF
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 09:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789464292; cv=none; b=HCSSvF5CVVppenRytaZPSOSkmLMOwVdZk3OliWRCgRrklB5P0X7ZW5uoYirVlppPKTpuquI3K1N5tfxam0P7J2R7/4m617sBZOPedpTqdXa8CEmRGEC5fC/TZj+uH4dWzxO6h423lFzWWVTR1vfSULxEmZ0RGgSNFL0vbES43oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789464292; c=relaxed/simple;
	bh=qg3NBK8u+1F0WZmTIldEJuKzcYBTL/HhVtkSXxJJ3mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKOxpraqmd3BvDczSPqHjQKWHt+wmimpcv9hiun2M5c2qinPMtB5Q//OJEy2rCxis0nlZk5dXFyW5eI8MSJRjsbwVS/jOhtGr/EnuExrGyafucj0YlKfrRtWTeLYrbXnR6WlKY+9dnIRFPlhvnaKRrLFNOpD7w9XdL00tNifIHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxnVUbkG; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxnVUbkG"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c3ea1f6so1358066f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 02:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789464287; x=1790069087; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CWWWXqBxdZQwhQ7CkoKnQwmEOD4rQL0kmNBKNRws0Ls=;
        b=KxnVUbkGAu65Vnl/cPJzKBiySaB7InufzYjqJbCUxxY2KPg0SRqNUOBsLLDzTYZTVE
         2qJR1Nc08Np+LIn472iLksGJ2xZheXs5zJPlAgp2fiCiy7s+Zd+4nTgsS6vA0ArD+5yw
         hDpwi8af9algBBU3Szz9BlXarOeqBpq5JDrO7BmOrVnzgolOsJCA4PZq9nrEEmJKy5RB
         sbRonW6tfL5LlgEnR8W9g7I+cYqhu92zXl6Kqi8pt5JEsPs3XBOLCbN9Qc8I3gg31gUP
         Gkr9NvRuBgT7A5Kuiu9/1N9iQLTJCwk6TBxE71mv7q/IAU/iAe8bO3tT1uz4IEffFVMI
         Y21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789464287; x=1790069087;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CWWWXqBxdZQwhQ7CkoKnQwmEOD4rQL0kmNBKNRws0Ls=;
        b=aomTSPMgSe0bg+CNH0aSfygrnrp861wAk93COKt7qoLGse0WRfNMD1gaHq5hnlRyOh
         fgEu/fq5Mprt0/WSPLXaVd2xTSgqgQHswWubO8UbOkQ8TAkV7b+U0oz4o66/ESoJvjrr
         JjAkMJnnzFKtPbe4mho0HL1DDULCwf55fujPud2nF0nmWhoRNUNK+f5q/jvteR5oNll5
         wlvyHJ72+3zCz/jFzUNbd6rNg/iCkUIvTt5qiJ86n7pThMH4I2s2yxlnbMGYFNdkvcRV
         jSE7xoAfuxTwtLvr+KILlukwf6NSrNTqw3uzrGP/lRbX/Dm4IjMYadwBEvxwCmO1DkZc
         OLag==
X-Forwarded-Encrypted: i=1; AKwUvByZf4yCmuQWeGRa/qNke0znPQwdkzC/V0Q9s1ch1WY/eJi6ZSSetSVLv470tpRwOvzeyuTgJ0o=@lists.linux.dev
X-Gm-Message-State: AFuF++kPC8YzHI1a8uxpx/osFnrHEzGu4VUeKw8YDX4a1IwEExuGdzQR
	IiElluSqCHb73dRP4iOFjWyxO71AInb8Jb91zrPWF8f4rfXJWsH8yowNwGMMxsek8g==
X-Gm-Gg: AYBFou3620t+eaM3rF0HBe/EeDAcrQQRcjN6EEkzgGGUlyy2AGvyIaLD5cpvfKjnKwv
	ISyvXsij+dH67j6HKdSORtLdXEIXIGLa1FJuPhWtsd9mdyT7GeD7zgiI49z9pHczuamzK6/ihGY
	QBLsNW3hxSvseLkWyh6IQIc1/L//rzNZM4Qs9g5YxqEVY5o8JrUj3lsYun3tqiLuQm4hRV6KE4c
	KdY0dzT3+wHkzOyMen8N8fYGyWIegezlgDtfvhqZT6u1yIbNHQUnWa+AH0YOdi2QtqlR4MY7P8V
	vT+8bpU+l8V3iwM7DGjTtMV9GPEizjUCUHYqPFgvufHVqv/ROjHcskshHRe0TRSfKKQdw/otQpZ
	Q2HL3mz9nXH0VbOKEZJpmP/NGy0CPgLZ2y+ywfprMexH34Hksy/AArD+vY9WHy63c7bsIA5ekvO
	/SbSrB75niE/lZBHHHWRHolYfJEVYgvL1qEUXj7luQkIFYpe2xqjbnKYFbziKmX1hWGxvc9xLw/
	xUFrfpQo97srypQ6r7od3ffNuVcMdw+/pEUz17PH1GhwwxEytSSUA==
X-Received: by 2002:a05:6000:1785:b0:485:8a46:b3c4 with SMTP id ffacd0b85a97d-48702b5e64bmr7485672f8f.44.1789464286268;
        Tue, 15 Sep 2026 02:24:46 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33e020sm34764203f8f.18.2026.09.15.02.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:24:45 -0700 (PDT)
Date: Tue, 15 Sep 2026 10:24:41 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
	Ben Horgan <ben.horgan@arm.com>, Oliver Upton <oupton@kernel.org>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v7 2/3] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
Message-ID: <aqkO2eVkF4bdS41U@google.com>
References: <20260830-host-direct-messages-v7-0-45f6e6db72c2@google.com>
 <20260830-host-direct-messages-v7-2-45f6e6db72c2@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830-host-direct-messages-v7-2-45f6e6db72c2@google.com>

On Sun, Aug 30, 2026 at 11:08:14PM +0000, Per Larsen via B4 Relay wrote:
> From: Sebastian Ene <sebastianene@google.com>
> 
> Allow direct messages to be forwarded from the host. The host should
> not be sending framework messages so they are filtered out.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 27 +++++++++++++++++++++++++++
>  include/linux/arm_ffa.h       |  2 ++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 9e8bb95e8845..96cf6be969de 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -880,6 +880,29 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u64, endp, ctxt, 1);
> +	DECLARE_REG(u64, flags, ctxt, 2);
> +
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];


For a next version, ffa_check_unused_args_sbz() has just been merged. [1]

[1] https://lore.kernel.org/all/20260907171930.4037166-8-sebastianene@google.com/

-- 
Vincent

> +
> +	if (upper_32_bits(endp) ||
> +	    FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != HOST_FFA_ID) {
> +		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	/* filter out framework messages and validate SBZ/MBZ bits */
> +	if (flags) {
> +		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	hyp_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res = {0};
> @@ -938,6 +961,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_MSG_SEND_DIRECT_REQ:
> +	case FFA_FN64_MSG_SEND_DIRECT_REQ:
> +		do_ffa_direct_msg(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index e71d83ee0aef..a3f44e7c08de 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -269,6 +269,8 @@ bool ffa_partition_check_property(struct ffa_device *dev, u32 property)
>  	(ffa_partition_check_property(dev, FFA_PARTITION_DIRECT_REQ2_RECV) && \
>  	 !dev->mode_32bit)
>  
> +#define FFA_SRC_ENDPOINT_MASK	GENMASK(31, 16)
> +
>  /* For use with FFA_MSG_SEND_DIRECT_{REQ,RESP} which pass data via registers */
>  struct ffa_send_direct_data {
>  	unsigned long data0; /* w3/x3 */
> 
> -- 
> 2.55.0.897.gb25b4bd76c-goog
> 
> 
> 
