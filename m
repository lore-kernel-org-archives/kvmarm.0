Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BE87EA
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 00:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B3CttyUl"
Date: Thu, 16 Nov 2023 16:56:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700182611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0fkuxnbdYW25Ttqk3TZq2xjlT9j7u45ZxdRPegBk1nc=;
	b=B3CttyUlvMewr2QCXhIT1Q9CjzccwGX43KO4LIQ5urb6rWu0syJZ1cWZbDUB2DU58FLxRW
	fb1am80CHDLINuxDIfQoZ8bcM7sgIPgCYKAWMe113cqWMSJ6wZ8IDbzEVIrN5dQJaD0thQ
	WPoYiHr8WwQ/Hp0ijLE6bFxzhNGxV14=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 05/12] arm64: cpufeature: Detect E2H0 not being
 implemented
Message-ID: <ZVa6RIOT8Eixqy6l@thinky-boi>
References: <20231113174244.3026520-1-maz@kernel.org>
 <20231113174244.3026520-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174244.3026520-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 13, 2023 at 05:42:37PM +0000, Marc Zyngier wrote:
> FEAT_E2H0 is a new feature that indicates whether or not HCR_EL2.E2H
> can be set to 0. Amusingly, this feature is set to 0 when implemented,
> and otherwise negative.
> 
> Add a new capability and detection infrastructure to detect the
> absence of FEAT_E2H0.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kernel/cpufeature.c | 7 +++++++
>  arch/arm64/tools/cpucaps       | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 41db7f993eef..e0d64e8b4851 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2787,6 +2787,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
>  	},
> +	{
> +		.desc = "FEAT_E2H0 not implemented",
> +		.capability = ARM64_HCR_E2H_RES1,

I did read this a couple times before the neurons that interpret "0 not
implemented" and "RES1" fired together, heh.

--
Thanks,
Oliver
