Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6933A101F0
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 11:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9CDC433C8;
	Wed, 19 Jul 2023 11:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689765428;
	bh=s10haHY3LNvD/Y22CilZKnaX6pnYVkTKlOB8Dg4W/5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JEadQFd2LQ54mq21scJ8Q6fS/fXZMyUHwv/mC49dSB7Dj/mSqN/P1lx3Ok6k61xwi
	 8TCy2X4R22B9WQLcZoj3kNTFfPovQF1pIUtMLbjpvt5Z9qt/viWvkkwRfC8WVpgJML
	 rIZplVSDlpV0fsh/H5bvGMfDDl2F3FmNyc153Od+4lxL//k8aN6roquxl6IwfRYrAh
	 mqD0rzdNdBWYKwt53f0ELYa08SRLVNvkPgZySIDpcJcnIo2deoE+ePZJmKdIh1LjtB
	 aAc1eGQldHH9s1jeblZRedztvIH2Am9oLgRV6f/zQSlI/H85LR+Q7bg7TW+9W62Cb0
	 s+qd3jv0W5GqA==
Date: Wed, 19 Jul 2023 12:17:04 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH] KVM: arm64: Allow pKVM on v1.0 compatible FF-A
 implementations
Message-ID: <20230719111703.GA10069@willie-the-truck>
References: <20230718184537.3220867-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718184537.3220867-1-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 18, 2023 at 06:45:37PM +0000, Oliver Upton wrote:
> pKVM initialization fails on systems with v1.1+ FF-A implementations, as
> the hyp does a strict match on the returned version from FFA_VERSION.
> This is a stronger assertion than required by the specification, which
> requires minor revisions be backwards compatible with earlier revisions
> of the same major version.
> 
> Relax the check in hyp_ffa_init() to only test the returned major
> version. Even though v1.1 broke ABI, the expectation is that firmware
> incapable of using the v1.0 ABI return NOT_SUPPORTED instead of a valid
> version.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 58dcd92bf346..ab4f5d160c58 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -705,7 +705,20 @@ int hyp_ffa_init(void *pages)
>  	if (res.a0 == FFA_RET_NOT_SUPPORTED)
>  		return 0;
>  
> -	if (res.a0 != FFA_VERSION_1_0)
> +	/*
> +	 * Firmware returns the maximum supported version of the FF-A
> +	 * implementation. Check that the returned version is
> +	 * backwards-compatible with the hyp according to the rules in DEN0077A
> +	 * v1.1 REL0 13.2.1.
> +	 *
> +	 * Of course, things are never simple when dealing with firmware. v1.1
> +	 * broke ABI with v1.0 on several structures, which is itself
> +	 * incompatible with the aforementioned versioning scheme. The
> +	 * expectation is that v1.x implementations that do not support the v1.0
> +	 * ABI return NOT_SUPPORTED rather than a version number, according to
> +	 * DEN0077A v1.1 REL0 18.6.4.
> +	 */
> +	if (FFA_MAJOR_VERSION(res.a0) != 1)
>  		return -EOPNOTSUPP;
>  
>  	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);

Hopefully firmware gets this right!

Acked-by: Will Deacon <will@kernel.org>

Will
