Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C91D6A2
	for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 12:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+xKdp1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E470AC433C8;
	Mon, 11 Dec 2023 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702298563;
	bh=DGxFcwoVc1jGmbCBgGp2995pjUWmNd+1rYuxuaxGUlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D+xKdp1aioEd0SlTFqUaLoOltR8hOuuVGWVcP/ofISEsD/IweqOZzydD7ONzHrtZI
	 75VGvqKYBb+SGxb97Re2kZCDMwVkay8/s8YBY7X7rIZQtf2Ee8pVz+38N4hs6kDJtc
	 i07l/5eNj0ScLWWGaWxgqwpKmybzHW2FXG+LpV0uGHmuCofdvawGQyOnz61+0nFSEN
	 iE54SI05OHPFZxTpnHDbQyohiCNl+da0VvHMg/JMVABJbv9C9wd/PfWi+sxxwyto/X
	 Ob86/1RJipKtflT/0NJz+UNPHzEqFcIVr5beHozKEs2vd7v4iAeqW7hkMz07rCh5Ft
	 d3H1qJme7/lEQ==
Date: Mon, 11 Dec 2023 12:42:38 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 06/13] arm64: cpufeature: Detect E2H0 not being
 implemented
Message-ID: <20231211124238.GB25277@willie-the-truck>
References: <20231127114559.990314-1-maz@kernel.org>
 <20231127114559.990314-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127114559.990314-7-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Nov 27, 2023 at 11:45:52AM +0000, Marc Zyngier wrote:
> FEAT_E2H0 is a new feature that indicates whether or not HCR_EL2.E2H
> can be set to 0. Amusingly, this feature is set to 0 when implemented,
> and otherwise negative.
> 
> Add a new capability and detection infrastructure to detect the
> absence of FEAT_E2H0.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 7 +++++++
>  arch/arm64/tools/cpucaps       | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 4a72fb26daec..6ef9811f7bb7 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2786,6 +2786,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
>  	},
> +	{
> +		.desc = "FEAT_E2H0 not implemented",
> +		.capability = ARM64_HCR_E2H_RES1,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,

Is ARM64_CPUCAP_SYSTEM_FEATURE the right thing to use here? For example,
if the boot CPUs have this feature but a late CPU doesn't, then I think
we should be ok as long as we're using VHE, but I don't think the above
takes that into account.

Maybe we shouldn't be adding new capabilities for this at all, and instead
just look at the sanitised register value when we need to?

Will
