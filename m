Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C303B14DA
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 08:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781081613; cv=none; b=U47fwLnCYLk7R23FRWiYqySQje9b3TmX02N+SYK5Masj936Rn9JCveR9ov35j67IV8Jim1w3QelMM0/n8lCEC1DGPX/8Fy+x/fWxwtALV5JOu8XPvraJkVv2sw3Q+x5woZitUvv/NyVxKM7sUr6txX2k02AFXeNKPyPeo8StTAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781081613; c=relaxed/simple;
	bh=5L9xLoN6772geBFt3Kjxn2zs2N6kNqKg+GZZ1XJXXRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXVoEQ4O12Y95GtH7f99mvTmnWatMxXykjSqAmX/nP6lWwoD30tPXjbq7ItkjE6E1pITgUPXElCZnj+L1j2RFLlh8CfHdg90Nn2bJb5w6ATwuCZSnDjYtDHsLiYH8NPiAIjeBQbki0i94y2axT7UHdfSiH3bnLKcXq/VeMsJGM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QiCgj2nM; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QiCgj2nM"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bebb72b845aso1015077566b.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 01:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781081609; x=1781686409; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=69R1izJHdq6eU+4kabS2mn4P5ih6+n31cQPINhDIjLU=;
        b=QiCgj2nMLS7p2ulnPXsFA7red2pNgj69CVyCoip46gFK3B8d8SlqmjIy5hmIQ/EMjl
         fbxFdm3nXiV/RlajrzVQF1g8RnPCIZwkofCDQM7OH1KJie7D4F9zyxEwAFLAbHJdi246
         5H43tyrXUZwZai6UVHX0ViWbxBaD2tYuMRvr0BJM/fLqts2p0rIuAXFOgpDjakKiDILi
         hUmpYw/X1Lm0bpEeDHumNkvVP2qgrsvQpu998UEep6NZB+DHli0FhqEXHhnTrFvJ+if6
         rgfMyq0jMmkImsGxPW/9B8xtdv6fDLziw8OKC+kCsFdKz4+QgYWEjIb6bInsq4w/6OiS
         WpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781081609; x=1781686409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69R1izJHdq6eU+4kabS2mn4P5ih6+n31cQPINhDIjLU=;
        b=D/z7jvM42S+q651ySttNgZtuJht8vgnM+1TD7AeLbpU7k0F6EWdKGe6ADoJcfL9Uuo
         fLUz991HTOtFYiwqHV+QLqY7tSD5W9BuA92vp0CqSFWAkRpaKbpxJm4+rk0q2khNdysI
         mMgVl8C0cp2VTs11SAMfisB+RRSmZ3ZVpZYJvFQxHs7sETR2nxYGjWw9gq81hBZATW4U
         Wd3aPOyx4Ezu5H5djr86kGM7277KNCkgN5MGIShtMdUXZKqaGrhCws17rVu26gnSYlK8
         Q2B244wqoPISHHn51D2eVXEEUvq9NVY1olrpZMZWRxoEwTenTXpp2z/u36bBk+jV+ouK
         6smQ==
X-Forwarded-Encrypted: i=1; AFNElJ9mOy40I9EiHaT/3WZhvLXkNRK0BXm+VGfEQ1G9OyltIBSlAky+879Fu8a4qI9QFO2RkaGPzaU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSUhNbHG2ByV8SDbcW7QyXAUj9Ga0q3Mx91Z6AoqSeUkQCdH+p
	TQA38WWVZHvqSNk/04YLqTtvuU8hrYTryz1XCxzGFRgydQl1EQiPsymk9BWDflgZ8g==
X-Gm-Gg: Acq92OE/Brah9wO8zQLRjF/YVvb5PHsVJsd0t5r/V5K9Ppeq0AQEf9Qv40z80ctNYSW
	PyiSWQ4t3I3Sc0V3HmIEhvXv+4kVzQvlPmXx/wFlnj5VnZIi7YByx24E4Tq2YYDi5UiNZ0mjPXy
	EWl7zb01gn1V+NxVvWw3ep8+0/9gSrUDpK+yrLY5/clQ+7Vhxfy8z0HzC1elz94789JCMpTim/3
	7pau8iWFkEKHgx+sSS2WIQ0knfAhk6zc+WXSNdv/6EVCHJUntYHAunjBTxezQt+v2x49+pwVNLZ
	qiJPJQWvdueol2MCoYrqg6oKbtf3HSbOQlmSCKv2pag2X/z3yI93rfNsu1f2z3ipQeWrtSL4pBt
	6C3oItnvzhGpm8vWud+mus9FRXOWqYYBzVS9CdOG6LrTBLtOE0brN4bbG5jR7Q5grPUlfUn+dJa
	H8PHPGtRIlzPSRyMyGIXY1plxPanqoTYXFi7qJjduMk+HdAFzrYOVAJJr2Yfv+OerRJzobPlz7a
	vPGENqwAbBN3Yxs
X-Received: by 2002:a17:906:4fcd:b0:bec:436f:1857 with SMTP id a640c23a62f3a-bf3702817e4mr1205610366b.7.1781081608995;
        Wed, 10 Jun 2026 01:53:28 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0553040a7sm1153912066b.50.2026.06.10.01.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 01:53:28 -0700 (PDT)
Date: Wed, 10 Jun 2026 09:53:24 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 2/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_DESTROY in host handler
Message-ID: <aikmBBHEUfolXrHC@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <20260608165549.1479409-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608165549.1479409-3-sebastianene@google.com>

On Mon, Jun 08, 2026 at 04:55:44PM +0000, Sebastian Ene wrote:
> Allow FF-A notification bitmap destruction messages to be forwarded to
> Trustzone from the host.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index c20d45191085..91e89d889c44 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -688,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
>         /* Optional notification interfaces added in FF-A 1.1 */
> -	case FFA_NOTIFICATION_BITMAP_DESTROY:
>  	case FFA_NOTIFICATION_BIND:
>  	case FFA_NOTIFICATION_UNBIND:
>  	case FFA_NOTIFICATION_SET:
> @@ -893,6 +892,26 @@ static void do_ffa_notif_bitmap_create(struct arm_smccc_1_2_regs *res,
>  	arm_smccc_1_2_smc(args, res);
>  }
>  
> +static void do_ffa_notif_bitmap_destroy(struct arm_smccc_1_2_regs *res,
> +					struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, vmid, ctxt, 1);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 2)) {
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
> +}

Sounds exactly like do_ffa_notif_bitmap_create. Could we use a single one
"do_ffa_notif_bitmap" ? 

> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -954,6 +973,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_NOTIFICATION_BITMAP_CREATE:
>  		do_ffa_notif_bitmap_create(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_NOTIFICATION_BITMAP_DESTROY:
> +		do_ffa_notif_bitmap_destroy(&res, host_ctxt);
> +		goto out_handled;
>  	}
>  
>  	if (ffa_call_supported(func_id))
> -- 
> 2.54.0.1064.gd145956f57-goog
> 
