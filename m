Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3913176AA5
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717176354; cv=none; b=PKMAx4rUNscgZdo8JK8ajRw62VNDyewZcizreBDzIOk9E+mr3ny9RzZ4vbIJft6wtkP0W2KnLelLyPP+BtUHW3S+PMqaNO7Ppx6Dzgt5/A6P2YJh8qeDRCllTZ3jldKicWGvKyZpe5MlWZTuhUTjkWsDrHV8jbcTwu0gG/vDzHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717176354; c=relaxed/simple;
	bh=IM6+BdxW4RCqRwU8EighCtoesvQbrtR7Y9wsm/lICAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qe5Ouh6Tll+2tQNPHdxlagGQm1AfEMABFVDsLNfrLj8korAEGEdPw9vxWw2IDCgvOgq+fiaO4hUbe/fS6Q5nCdQ4J6t2/SNGah3MNXuSA2gz5E8uSC0gfWuMXvlm6ECf9aKeScRaLtojeLXr3fXTI8igPro3QyQgLJr7QNXQsjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SRnptsw7; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SRnptsw7"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ea9afcb22aso6743561fa.1
        for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 10:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717176351; x=1717781151; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D4Vf/r8pzEnd/o9AQIT/jZRY6M1pLsApEezlnWmF7w4=;
        b=SRnptsw7q4yQlt2EJmbW44bQr/rt9jzJ4bxzglMclcXz6hT3DlxxvQFyZBcyi3kNjq
         FgyTunXUQTc8TGAGC86VWGZoetrqCUVw6S8EwH+6ALl7mHR6ZBlTseRiLXqZc5knlzcG
         12Prl7hM8P/2fcu0KaQVOftRAEekJjY271g6THd9uwMBBQnNydeKGzoTtTztRxm760Ax
         8xDBL7/zLqaNpFeixD0zKMZbgSs4x+uJirqDE+jcRWJPNYWKJ5PAMohovAa0IGiDmpUQ
         owjZkFaWyzye4uPHIPrtCc8Y5enN17smEgEFqvOi6ufdvDJOg+G5jQS0WEesKurUU28e
         q7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717176351; x=1717781151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4Vf/r8pzEnd/o9AQIT/jZRY6M1pLsApEezlnWmF7w4=;
        b=saga/eymPy57ue4QI+zmA9PvYzSsDYAL4V006x2ewK3lBZ1B6B75wKN8nyslQbiNpu
         bFvKw1SYikFX0B9Ymnf95ORq+h1mwtr62HLvKY9JLL3QZDy7lffAlpd2MRXzM6OYdT7W
         zLfFR7v1Sizlhiizd0YEXrDhQ2j7tdPNgPX3YFbO2EXyVl7WQEFx8KzFq6SWW3W6BJFZ
         B+VnBH8VX0uCIDjbf4exLNLhqA9WlczyzNRXs/TDfwKQpfaENcp2CPW2D2dT1/RIUiCy
         xr2QOFDyERfVgsOeRZruV3fEiPJjH1Aa8jvNPYIsYBLB+LDDcHWDTZQDISZzcn5yhAxJ
         dxhg==
X-Forwarded-Encrypted: i=1; AJvYcCUX4Rf7Fl1ZmgLz860BuH0x9D2uGmRrjYllfe4ZnZCpnmxYtQsR56byZ0Ps1wp7Hd9sX4g/54KH7mfRe9DQNdlErm09N0Zl
X-Gm-Message-State: AOJu0YyFa97Kd6e6x5ik6XtfmTxcNBYDUsJH6yOB/ZGk6bV+7uvtDecc
	FwJIDu+o5JJ65u7TWIS/HA0/gUy4xkY72TsViLhrEA3CipUrvAgHNqCZx+nXPw==
X-Google-Smtp-Source: AGHT+IEsiMXlDAxu6o0vW5tB+2UJaDrPXl+WD89XXcT688cmRfysvtEXYImSQr++1OCyDO92JKWYAQ==
X-Received: by 2002:a05:651c:b07:b0:2e4:45a6:cdcf with SMTP id 38308e7fff4ca-2ea951d251fmr19261491fa.43.1717176350681;
        Fri, 31 May 2024 10:25:50 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421270ad6bfsm60963615e9.46.2024.05.31.10.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 May 2024 10:25:50 -0700 (PDT)
Date: Fri, 31 May 2024 18:25:46 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, sudeep.holla@arm.com
Cc: sebastianene@google.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: FFA: Release hyp rx buffer
Message-ID: <ZloIGlEuEiEy3_0v@google.com>
References: <20240530131734.2724454-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530131734.2724454-1-vdonnefort@google.com>

Hi Sudeep,

On Thu, May 30, 2024 at 02:17:34PM +0100, Vincent Donnefort wrote:
> According to the FF-A spec (1.2 BET0 7.2.2.4.2), after a producer has
> written into a buffer, it is "full" and now owned by the consumer until
> it is read and "empty". This must be signaled by the consumer with the
> RX_RELEASE invocation.
> 
> It is clear from the spec (7.2.2.4.2), that MEM_RETRIEVE_RESP is
> transferring the ownership from producer (in our case SPM) to consumer
> (hypervisor). We must then subsequently invoke RX_RELEASE to transfer
> back the ownership (i.e. to let SPM mark the buffer as "empty").
> 
> It is less clear though what is happening with MEM_FRAG_TX. But this
> invocation, as a response to MEM_FRAG_RX writes into the same hypervisor
> RX buffer. Also this is matching the TF-A implementation where the RX
> buffer is marked "full" during a MEM_FRAG_RX.

Perhaps a change is needed here in the FF-A spec? Not only it seems strange that
there are no mention about MEM_FRAG_RX in the buffer ownership paragraph but
also this seems strange to have to RX_RELEASE: If one invoke MEM_FRAG_RX, that's
probably because the Rx buffer is ready to be read anyway?

> 
> Release the RX hypervisor buffer in those two cases. This will unblock
> later invocations using this buffer which would otherwise fail.
> (RETRIEVE_REQ, MEM_FRAG_RX and PARTITION_INFO_GET).
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> index 02746f9d0980..efb053af331c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -177,6 +177,14 @@ static void ffa_retrieve_req(struct arm_smccc_res *res, u32 len)
>  			  res);
>  }
>  
> +static void ffa_rx_release(struct arm_smccc_res *res)
> +{
> +	arm_smccc_1_1_smc(FFA_RX_RELEASE,
> +			  0, 0,
> +			  0, 0, 0, 0, 0,
> +			  res);
> +}
> +
>  static void do_ffa_rxtx_map(struct arm_smccc_res *res,
>  			    struct kvm_cpu_context *ctxt)
>  {
> @@ -543,16 +551,19 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
>  	if (WARN_ON(offset > len ||
>  		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
>  		ret = FFA_RET_ABORTED;
> +		ffa_rx_release(res);
>  		goto out_unlock;
>  	}
>  
>  	if (len > ffa_desc_buf.len) {
>  		ret = FFA_RET_NO_MEMORY;
> +		ffa_rx_release(res);
>  		goto out_unlock;
>  	}
>  
>  	buf = ffa_desc_buf.buf;
>  	memcpy(buf, hyp_buffers.rx, fraglen);
> +	ffa_rx_release(res);
>  
>  	for (fragoff = fraglen; fragoff < len; fragoff += fraglen) {
>  		ffa_mem_frag_rx(res, handle_lo, handle_hi, fragoff);
> @@ -563,6 +574,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
>  
>  		fraglen = res->a3;
>  		memcpy((void *)buf + fragoff, hyp_buffers.rx, fraglen);
> +		ffa_rx_release(res);
>  	}
>  
>  	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
> 
> base-commit: 6d69b6c12fce479fde7bc06f686212451688a102
> -- 
> 2.45.1.288.g0e0cd299f1-goog
> 
