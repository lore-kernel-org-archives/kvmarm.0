Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31E17AB7
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 17:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DA5C433D2;
	Mon, 12 Jun 2023 17:16:20 +0000 (UTC)
Date: Mon, 12 Jun 2023 18:16:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 03/17] arm64: Turn kaslr_feature_override into a
 generic SW feature override
Message-ID: <ZIdS4o1H6ePRLaKp@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-4-maz@kernel.org>

On Fri, Jun 09, 2023 at 05:21:46PM +0100, Marc Zyngier wrote:
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 370ab84fd06e..8c93b6198bf5 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -138,15 +138,11 @@ static const struct ftr_set_desc smfr0 __initconst = {
>  	},
>  };
>  
> -extern struct arm64_ftr_override kaslr_feature_override;
> -
> -static const struct ftr_set_desc kaslr __initconst = {
> -	.name		= "kaslr",
> -#ifdef CONFIG_RANDOMIZE_BASE
> -	.override	= &kaslr_feature_override,
> -#endif
> +static const struct ftr_set_desc sw_features __initconst = {
> +	.name		= "arm64_sw",
> +	.override	= &arm64_sw_feature_override,
>  	.fields		= {
> -		FIELD("disabled", 0, NULL),
> +		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
>  		{}
>  	},
>  };
> @@ -158,7 +154,7 @@ static const struct ftr_set_desc * const regs[] __initconst = {
>  	&isar1,
>  	&isar2,
>  	&smfr0,
> -	&kaslr,
> +	&sw_features,
>  };
>  
>  static const struct {
> @@ -175,7 +171,7 @@ static const struct {
>  	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "
>  	  "id_aa64isar2.gpa3=0 id_aa64isar2.apa3=0"	   },
>  	{ "arm64.nomte",		"id_aa64pfr1.mte=0" },
> -	{ "nokaslr",			"kaslr.disabled=1" },
> +	{ "nokaslr",			"arm64_sw.nokaslr=1" },
>  };

I think structuring it as a sw feature makes more sense and I don't
think it breaks anything (as long as people only used "nokaslr").

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

As a side note, I was wondering if we should add a SW_FIELD macro to
define width of 1 for such fields (and probably the field extraction
functions need some tweaking) so that we define
ARM64_SW_FEATURE_OVERRIDE_* in increments of 1 rather than 4. Anyway,
that's something to worry if we get too many such software features.

-- 
Catalin
