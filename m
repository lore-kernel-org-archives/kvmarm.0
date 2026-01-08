Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD5DAD24;
	Thu,  8 Jan 2026 15:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767887267; cv=none; b=bNNpHpK5yifJ5+9iuVnFd53gNDvlSITTeBF4U+C2UUIe3szeFMPiJO3TwGoKT5EfFUAZjSmeSPkL8yUJ6txJM+Eyl8pxQdatYQr7smJItT0ByO4B9nykHIWjqFMJ8w3scuZFLCGZ/2tr4/66CVvO4Ij1NjASq1j09ivJOBiESw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767887267; c=relaxed/simple;
	bh=fr3E84aj7B+gE6veuJ80O6qST6dcQKX3lD+YFac8hH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQsIfSeYBofjOBixWPPnLEx8pZvqS4V5u23UeUVwYjG8PGx7uptspUchg77fvJtFw4B1+wexjkdoGmBJ5KAa2qwu0YY7yO5Wfr8pooMsqBjXGvCccBf8ivIxMsWIJaA3jQpflORlhM6iJ5NZyWaD7a0QNcQ5KoEyuFAhZcWUXYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9V4aTUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9V4aTUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6270FC116C6;
	Thu,  8 Jan 2026 15:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767887267;
	bh=fr3E84aj7B+gE6veuJ80O6qST6dcQKX3lD+YFac8hH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q9V4aTUJZbHWalr7acoj1bQHQOmRuXMNb6/ST+NbGW8D/Pt8CLXonuydQWaFiBPoc
	 q1NnBQNjoxs8JELfc9J/AXH427WBkyHAFEU9H/VHNkNPYEcGnn6VhocGJG0o9qVxhA
	 aFLvRri3YtD7A4jAV5oEi67MbwIJPk1tBvzGBk5umsK4KTZrTA97Az2CLacnHIzn9y
	 LjSN4d0h7MrirD00NPtm5ghaPbIVCxY5CF9IdJlI2lOmfgCZTnui7K5At3N9Iqwxib
	 cJQqoD5e38JER8xsdXA4B8pFm1GukMcBNC69fCvvM3J6YJTEj342Bo3pQuHw1H43+3
	 sHus0QqQAhU2A==
Date: Thu, 8 Jan 2026 15:47:41 +0000
From: Will Deacon <will@kernel.org>
To: Kornel =?utf-8?Q?Dul=C4=99ba?= <korneld@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bartlomiej Grzesik <bgrzesik@google.com>,
	Tomasz Nowicki <tnowicki@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix error checking for FFA_VERSION
Message-ID: <aV_RnY1v2We1ajFM@willie-the-truck>
References: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com>

On Fri, Nov 14, 2025 at 11:11:53AM +0000, Kornel Dulęba wrote:
> According to section 13.2 of the DEN0077 FF-A specification, when
> firmware does not support the requested version, it should reply with
> FFA_RET_NOT_SUPPORTED(-1). Table 13.6 specifies the type of the error
> code as int32.
> Currently, the error checking logic compares the unsigned long return
> value it got from the SMC layer, against a "-1" literal. This fails due
> to a type mismatch: the literal is extended to 64 bits, whereas the
> register contains only 32 bits of ones(0x00000000ffffffff).
> Consequently, hyp_ffa_init misinterprets the "-1" return value as an
> invalid FF-A version. This prevents pKVM initialization on devices where
> FF-A is not supported in firmware.
> Fix this by explicitly casting res.a0 to s32.
> 
> Signed-off-by: Kornel Dulęba <korneld@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 58b7d0c477d7fce235fc70d089d175c7879861b5..ab1e53bd4ceeea431fc30a875482ed1523b01ab5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -792,7 +792,7 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
>  			.a0 = FFA_VERSION,
>  			.a1 = ffa_req_version,
>  		}, res);
> -		if (res->a0 == FFA_RET_NOT_SUPPORTED)
> +		if ((s32)res->a0 == FFA_RET_NOT_SUPPORTED)
>  			goto unlock;
>  
>  		hyp_ffa_version = ffa_req_version;
> @@ -943,7 +943,7 @@ int hyp_ffa_init(void *pages)
>  		.a0 = FFA_VERSION,
>  		.a1 = FFA_VERSION_1_2,
>  	}, &res);
> -	if (res.a0 == FFA_RET_NOT_SUPPORTED)
> +	if ((s32)res.a0 == FFA_RET_NOT_SUPPORTED)
>  		return 0;
>  
>  	/*

Acked-by: Will Deacon <will@kernel.org>

Will
