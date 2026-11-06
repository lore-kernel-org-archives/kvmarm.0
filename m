Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793987511;
	b=wWbXAL66CbDtJbp/l7MWUy5BMOCQAtfPVoqTtJ3nF1txKvHjN6RiHVb8G9Ferqh6HZo6
	 QuINPBi+BdO9dgc3QN8K+KvOwnGZussVN+UqgaLV1SohnnCClcv/zxO5TnRHsCABfsrql
	 bHsVGOxZnmjI4vu7+aLbiTbPCNIkLgxx9Iz9wm+WdX//eFWek6Ah0T4cF6kmS+hdXEotg
	 aCDmun9rrvxUkSUWYylnHxhGFFHuTkKzKvKK7SbuwM+Y+F1oZpZVTFwftIkovFa0P8hr5
	 09URREdZoDHz0x5IsAGs1b9yD1NKpBMcKWBLL3kqk34CLBqGGdnZ5Z2psAoDXnt00XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793987511;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=6WEB/QmqGNShWN2WfpdxFDs5dt086xZeyrUN/pg7o0I=;
	b=4+X8OORt64SGzU3WyUIj/0IjkvVl8nYX3qrurehb88RJwDJgJrzhCsjWWq84DG2iKFuz
	 Q8lT1K4WlHTfOH013uV6bPgoz989+t0SoiUl6iRQ662D8LrxDSwU2tLYmtE8Z0ovFRu74
	 ihuI3552klvE/l9E7xzdXuQsYzVE/ClPn3IieYjRfkbdaGsc5TgkL6EAIjoXdedvDMn67
	 GbTIuxio8zNm/gSMjlIqfjh6zgsV6OujbZWf6HsRnpwRkS42JjB8FRu/Gc41gFA3a55YP
	 /9S02eawLJbdYku4Hl2Ig1m17yOSZxlh1H80hpJALjF9EbXTutbiLwD/2czL2lzi8Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZCZvSazI;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D43606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 17:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20D43606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZCZvSazI
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a215e64962so10758755e9.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793987509; x=1794592309; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6WEB/QmqGNShWN2WfpdxFDs5dt086xZeyrUN/pg7o0I=;
        b=ZCZvSazIt7kr5pUEM2S9/0skq39RU8Q8JT6FZvHvpBeAV/9REfumF5CA44Pwfv3J9U
         8pZ/G6ofKjKtB5+I7CJQWWNkCFFBCCy++Hi1jUkamD6h7/2Ga7O6FGhr6ipISjsLPhN+
         xt8b8myXjHQzRv5nPCRIBX7VAJCnCSgfCQIi9dVYxso2unTi5RhLFDW5juXmTfirCltE
         EPsfghmnMlC7MgQcM4rFoLv6gRbKXiJlU9CTUWyPurwCzX7Vtj/4793boWcJ4NiKEX+D
         zg+ue+cakr8MwKK1lRExaZqqs2mXewHdF8SSs9QhVf35LM+Y1gfo5IG+U/G4GC19qJw0
         J+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793987509; x=1794592309;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6WEB/QmqGNShWN2WfpdxFDs5dt086xZeyrUN/pg7o0I=;
        b=MVNxSyzcHDfjyGmOkiHWrKchHEBBKdc4qQ7lCJQ06y9GLOSRompb1tbMTvItcjDY6i
         aT6lalkGu+1vkot9SWAuvpljHCEGCDOux3N+nontHa+IY1mhhSuR9Kik3GB9cmCV08Rj
         OpOj7zOzH3dNH/3lJuD3azwK7xZRLzkANq7v2jzZpyOlWN1ZgufSkUjqYyeT1y/In7Im
         tDBWy3fXPYHEtSkf/hilD2fUd19GIz3M5uwLbS7+kZckjqS5RAJ3LrvW+1bbThVvgN2n
         s3OMvLxelbIOjvvADhn/hdM3xKlweEPeFwdzXcjiirqCeB+MHwLtSJZ7Qx0cXGlDgPpI
         /5nQ==
X-Forwarded-Encrypted: i=1; AKwUvBz0sfNZrg7ebwhmBaAZS2ICmY3DIq/n2HfCWgvCen+VIRGyXpz9JF7q9pwqlkIfbiNb2YyGmkg=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ftkLKCMKzJpT/U54lf7YjA3+CcbZ3epxmAsIA84EKYAxYZFY1
	Lw0xw9AkGv9vNCvJWbK1baFyQPUFkTDF9gE9Ic6X9e8gIKcsihmrpxHKOYdt1dehvg==
X-Gm-Gg: AYBFou3Uv123zhY8tU8lfRAUHDjR4qu9otU7lJq+M0u6ZfbyJHIEBYBdKpxMw8qawYE
	+EvBW0pRMcB2YgKXq84lQcM82UTWtA3kGmgim2wNvU0W1ZaIMYdcbf6VYwo9M/riBvD8Ewt3xX2
	dzsja9L6T2pdVIaEnMGUqsMLHkuoBvxkNOlJW7o3yvp8QtU+C5ARZXaW/6LnhjyWud8ldL5QiM8
	wnAgVByd8hYxx/rrytPkEcModVuTDu8tl9J1rfiIbC/+yLZDTApaGFfjMc8UFKfSN7RB8UbV0f4
	cqogi0TW+ja2XurEZLGlwFjbYhGFkb0anZEArt5FFfeaD5dVBhjre2rUpgJsz308YgKXdoWk/FP
	UkHoSeL03RG+TXrmf3TtraF0qw2DqHBxNDwxH1pJiC4G4zXTI/0IKrXQCrW9f85HY5yGXWz+GWk
	Drx1pazsbHIr/kwHOoCmLEben1HnuP/51PJrCxRBTh3ru0IwzH/V/P4PKNIr8sosG3IZ7cUtB75
	/4VmmHgg87FpB06vRYgsM/LrSlKfnwzTCuuIgP90Be/os5LdVIB2uU/c/aPqO3rd9xMIM3gxEtT
	rbmjksRf0g0K9DGEwiPayyjF/uC0EeJwR6UNSs2vxuAJcfzyn8XHMBDvbr+fZen/kyZSSa5DI69
	wz2/muJeC2Q==
X-Received: by 2002:a05:600c:620c:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4b6dea6881fmr58086205e9.11.1793987509034;
        Fri, 06 Nov 2026 09:51:49 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b76cbd082dsm7811725e9.1.2026.11.06.09.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 09:51:48 -0800 (PST)
Date: Fri, 6 Nov 2026 17:51:44 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Allocate a protected vCPU's SVE state at
 EL2
Message-ID: <au4TsO50x7BcFYpi@google.com>
References: <20261105130456.1617185-1-fuad.tabba@linux.dev>
 <20261105130456.1617185-3-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105130456.1617185-3-fuad.tabba@linux.dev>

> @@ -1243,6 +1253,9 @@ int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  			    PSCI_0_2_AFFINITY_LEVEL_ON) != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING)
>  		return -ECANCELED;
>  
> +	if (vcpu_has_sve(&hyp_vcpu->vcpu))
> +		memset(hyp_vcpu->vcpu.arch.sve_state, 0, vcpu_sve_state_size(&hyp_vcpu->vcpu));
> +

Why wasn't this line around before?

>  	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
>  	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 32e82653ebf7e..06ea91415ad8b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -570,6 +570,7 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
>  	RESET_UNKNOWN(MAIR_EL1),
>  	RESET_ZERO(AMAIR_EL1),
>  	RESET_ZERO(MDSCR_EL1),
> +	RESET_ZERO(ZCR_EL1),
>  	RESET_ZERO(CNTV_CTL_EL0),
>  	RESET_UNKNOWN(TTBR0_EL1),
>  	RESET_UNKNOWN(TTBR1_EL1),
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 10eb7249aa9e8..aaaa1b8634ba4 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -52,6 +52,8 @@ int __init kvm_arm_init_sve(void)
>  		if (WARN_ON(kvm_sve_max_vl > VL_ARCH_MAX))
>  			kvm_sve_max_vl = VL_ARCH_MAX;
>  
> +		kvm_nvhe_sym(kvm_sve_max_vl) = kvm_sve_max_vl;
> +
>  		/*
>  		 * Don't even try to make use of vector lengths that
>  		 * aren't available on all CPUs, for now:
> -- 
> 2.47.3
> 

-- 
Vincent
