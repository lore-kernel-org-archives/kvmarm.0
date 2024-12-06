Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1E71F63F0
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733505215; cv=none; b=rWI8MITgg0CgPoA1tTl42bvye+okTq2JRcx62bE51z8A9yvbkuzQ29OUUfBQsdtpoKrhoaA63m8DQQTpLncIy518ALe5wtkGWQ8bjoImmnotT3NOgxrEqYf6sUDiJLDba3YUjR8bZpweuAxIMrLJen3tULvHNaVSoIPxaAAii9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733505215; c=relaxed/simple;
	bh=2GqrMCxVgYezdfXr2MXVETgnYPZBKFmEEjf3YBMuN/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxJa8OHkgwC1jrT7iGAmnX7VEDUA4I2TP2F7QffqqilLTb1cqHz+GIf0AvOvfIYg6DzBDLuyC+4V4UQ0Mm+9vnurRuyWPnTYTKXGOfUGAlNFnkYPixJUlsUq4cSyCrNJMcaB65iG1JkSM7vgaSCMba20vuf7Eo8lvav8OEIiuO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LjPy84aX; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LjPy84aX"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa5f1909d6fso452571966b.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Dec 2024 09:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733505212; x=1734110012; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V52SU6z4mUrPNmuBCYnRZyOhqwTT/IVAD2aAkFpoqNM=;
        b=LjPy84aXowQhOazITzLBnRzdGpRLi2DbXXcWW6AeKU6ZWPLwRilcX+Sj33+7e6k8dc
         VDfHZICY5Zdql7iQTscdX6ANunVmlTJi9d07PuFirAgJDH4s3SvMUQgiZn7RatVmFNUQ
         FWynv6Gw17/9GuReII7KMYd23GBZfw5KWGiY6wo0C62De3eIo4m1inSYu6CsrDqo2cQh
         14MbpTNWKq7SGsd/q0TGLed/HvcW4uT6wP3saWCfNtccugvXkuc+2Djj99LJdBb4fDTI
         IEeKFT6ow9Q8RS1DWEL6ukQ9KObEqF9jMl4dxuK2fCELA9M7e0j7mtO8i45aAQWRf0c5
         Iq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733505212; x=1734110012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V52SU6z4mUrPNmuBCYnRZyOhqwTT/IVAD2aAkFpoqNM=;
        b=lpzJU099eYpK7HxvQSkBn37y+5sYYSuvqgenLQVNMsFbstmMp/7GZcTmVLS102yZWf
         +y7ZXSilhFA4qq0oeRZYxaVcrYK0r/hElWJbYMyhGGOcXT6NP8/B9rvj6an742sVByo8
         JTBmFqjhZGmfSkoYyLlgyIAaLKZbpbLPqQqLmRWyoBUXWdF7rjwaVRxgdhEX0cDKpj1o
         MsFCxIOoSOH0+QWeN90jNYhqyDTDRvzUhWBhkvrqJ1D1yhQL+ar2cVT5/N88RA3cAChI
         OisloHkW+AT9RjDPlNSvWFvrx8MgYXYikdzPw2D67vlFtGSVZyvkHUeu05gE4n95+iXV
         q4Zg==
X-Gm-Message-State: AOJu0Ywhl7DxiVqBBLTHULB16RrsrRlvbMJNC7OWyQ3i9H2gPcCSGW7D
	mPa6h2260xl0qAA89YnW25kMeAiV1YWqb0OY+WWifG4rdkOCIznV6pYnvDzkYw==
X-Gm-Gg: ASbGncvW4mMWHHwV8scVpbLRYLrb5Mk/bvn/ICSrFHb5FWv+rr/5rdW7mBdPYF7FF93
	eNdmk+Nnb1meLwZrfa3fuW2UDe+iDprTwnq7G2clmI/FIZFXIWYX4NfdJkU+KAbfv07Rh5t2fvk
	yb29iYCgUzrMuBMtD/mW5obMNzBmhb1AvNYA70PRCXv/viP3nOuZyCSxKiCn7gRgwlFtkUDJ9Pm
	6KTPI+PGFEvmkKktAbLNW8BTy6AbBea7DJwylUfXqxyOJXubg0PUZSe6FFBfbJ8b7749YUZKZ+7
	5NTi0Z3M
X-Google-Smtp-Source: AGHT+IGVVuQrI2gV96PYQZo2nUQh6IhmbK76llKwDGJgy/lGFOBBWjh4tjYfJ2SWh7aGoxZm5SPXtA==
X-Received: by 2002:a17:906:23ea:b0:aa6:2755:c185 with SMTP id a640c23a62f3a-aa63a0a676amr353073866b.31.1733505212192;
        Fri, 06 Dec 2024 09:13:32 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa62601b62esm269659966b.104.2024.12.06.09.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 09:13:32 -0800 (PST)
Date: Fri, 6 Dec 2024 17:13:29 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 05/14] KVM: arm64: Initialize feature id registers for
 protected VMs
Message-ID: <Z1MwuSh6jc94cem0@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-6-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:32 (+0000), Fuad Tabba wrote:
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 59fb2f056177..1261da6a2861 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -204,8 +204,7 @@ static u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
>  	return id_aa64mmfr2_el1_sys_val & PVM_ID_AA64MMFR2_ALLOW;
>  }
>  
> -/* Read a sanitized cpufeature ID register by its encoding */
> -u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> +static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -240,10 +239,25 @@ u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  	}
>  }
>  
> +/* Read a sanitized cpufeature ID register by its encoding */
> +u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> +{
> +	return pvm_calc_id_reg(vcpu, id);
> +}

That wrapper doesn't look particularly useful, perhaps we could drop it?
