Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8A03FE37C
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 14:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774361208; cv=none; b=tfLusKZXjB8pgiJhFdOQ7cZOYFobCU1cVeZ6Ps2JiePsx1MYv/gcl3W2vGAIpKwOSYQ8eOOQ3AaTC/dGQZKWwPWgTvu9wj6tt4HZAezT8J+HzK9D6H0FhCDkwiQhPG0LGbcXDulTI4EeVIue/Bpmj4Bg6URssLFp2MPCC/YDprI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774361208; c=relaxed/simple;
	bh=gGYNd38Qv86SUn+18xnjHcYSHOfC/E/g8AWXLty8jiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyUXXNral6m4Ra1zB2NUcME0YtZFt+Fl6FkmorYBTVHAz55bvNWogNtMTxWFFYGPuM+XjkRIFhzKC45llIZdPZ+T353cyDXBS10CHwstvd9qTD0aOlEbt7ehBDQ6XcpVqCaf8+aC4lLdoE4jv7L0K/n2Qomc/OHoLpn3wZDEjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J9HukorH; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J9HukorH"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43b40fb7f95so1301890f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 07:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774361204; x=1774966004; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Cv1GxwGjsnJyKeumjJielENFU1WPaGfL15dJDHDpzM=;
        b=J9HukorHXzGyxp29xUhc53/iu6OGRba+y4dpkQmw67QBx9dJpbHuIxBL7UUHYTLfrU
         vUflK5LmAUdWmwSjqNaMxzVQB/9WcT061pjzFFKjjFGjcMd4HZRueuWrcQS/+ZUBHVhu
         Y0PbBBK7Wn+Fu7G+ItFUssmW8r6mrFJ5p50yZKRufcidD7Mlsqu+3L8/7WEULJ5WrNgw
         rA/RXxR2nr4B7OaGwUuDa2l+tJ2P+jr4YK9CXKTJrctMhJ4KrYOWZ6V1tPsL5IJGy+3c
         3wQz+BOMmmooVGpXsI18I5NdvXDktZs3D6iIFQBpjnbrteqvrcc/fSNY1hmkqQ4lFUCh
         Ortw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774361204; x=1774966004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Cv1GxwGjsnJyKeumjJielENFU1WPaGfL15dJDHDpzM=;
        b=ErTnnOIZ/hOdzL6jhLgZ7AG3zEJryQ+TlRBUQWdgyZoA40fPLrgy9wlcnOpjEZT+26
         cE6iUY7/ShzjiRuPfZMdfvDrHrAGivslqmSAyALDxg9Ho3lroAMytDGAICwydexwurJK
         UfrVbOpGZDLbZ4Ubtz+7mHDiUf/u+Qvvbps/Y5NkysBuM9LgyzxqOLAurl2wQFolSNzy
         Y4uNhSwLT5u+TMR34NAwoQT5ZU2dH0N+J8p2ew7izeofSrGFydSIN5hHmlLlmAhw2bsg
         c/gLBMwUNfKwEKW5ieCPWz/qX1qpOHadcz0x0wZ+pWAftCRG4HBEYj/C9i3bDz8VY6jy
         hwfA==
X-Gm-Message-State: AOJu0YwtCHuyEM4vAl/nzhdio46VjgxCLMpfI5Hpnz58ifkW20aPJiZU
	xXKavdguuHC/GTZU2U+FlphJsCLrelV41oFvgX/tlr1idOFYyxdTsnn/BeOA9A+OIg==
X-Gm-Gg: ATEYQzwjgK5LHIOUauSJUUkCzGl4eUvQ+MLquQcLCkDUAAwr6rjvX+lzJNNurGslz/B
	mEsrzKNUWsZlDABJRdkiNUbNQgpAIjHwnGH+m0TjIhqvUvya/a6J6V/yKy/rVDmbdQolHmpuZ1V
	YBubQn0oUfpq3pXt+JcN2SdXDFU97MpaEFcra89kvBk2mRWcJIKkkqD8a4yad7FBTda/yr03OC4
	w8X2khJPzMkKvZAekG+H79DPCl62+bZbZ/JLuatezQkDloryWuYfAXBlbmf6zt8YJriTStyTSfK
	z3c+idj6K3MrrDcUTN0SBAfdwRZBbcE7iZrJ4wM0v4zEzAsRMs/jI3yvoW6NNuCJyzy7uwR7szr
	UTD2KLdQ2goXadr6msN4AuqoAf9lEtwLbF4Dln7WVzM4v6aO/dfZKDAhAQ7nZuZEVzmWbwzBV3m
	IX0xeps3Q9hx2K1S7qz7B9t3fCUCHGr48Qyz5XXFTnEyZB0msQqcTu2Suwgiufl7FdahJepRNZv
	f26Rw==
X-Received: by 2002:a05:6000:240d:b0:439:b7c9:2ef1 with SMTP id ffacd0b85a97d-43b6423bc2dmr25256797f8f.20.1774361204032;
        Tue, 24 Mar 2026 07:06:44 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64703c27sm38308646f8f.18.2026.03.24.07.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 07:06:43 -0700 (PDT)
Date: Tue, 24 Mar 2026 14:06:40 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
Message-ID: <acKacAd6aV32624m@google.com>
References: <20260324135728.3532400-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324135728.3532400-1-sebastianene@google.com>

On Tue, Mar 24, 2026 at 01:57:28PM +0000, Sebastian Ene wrote:
> The ARM Service Calling Convention (SMCCC) specifies that the function
> identifier and parameters should be passed in registers, leaving the
> 16-bit immediate field of the SMC instruction un-handled.
> Currently, our pKVM handler ignores the immediate value, which could lead
> to non-compliant software relying on implementation-defined behavior.
> Enforce the host kernel running under pKVM to use an immediate value
> of 0 by decoding the ISS from the ESR_EL2 and inject an undefined
> instruction exception back to the caller.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index e7790097db93..ff6a90a4a4c7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -756,13 +756,18 @@ static bool handle_host_mte(u64 esr)
>  void handle_trap(struct kvm_cpu_context *host_ctxt)
>  {
>  	u64 esr = read_sysreg_el2(SYS_ESR);
> +	u16 imm16;
>  
>  	switch (ESR_ELx_EC(esr)) {
>  	case ESR_ELx_EC_HVC64:
>  		handle_host_hcall(host_ctxt);
>  		break;
>  	case ESR_ELx_EC_SMC64:
> -		handle_host_smc(host_ctxt);
> +		imm16 = esr & U16_MAX;
> +		if (!imm16)

if (ESR_ELx_xVC_IMM_MASK(esr)) ?

Also, I can't find void inject_undef64(void); I think you need a vcpu for that?

> +			handle_host_smc(host_ctxt);
> +		else
> +			inject_undef64();
>  		break;
>  	case ESR_ELx_EC_IABT_LOW:
>  	case ESR_ELx_EC_DABT_LOW:
> -- 
> 2.53.0.983.g0bb29b3bc5-goog
> 
