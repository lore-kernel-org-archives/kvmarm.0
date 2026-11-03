Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735362;
	b=NFzvr3YbzBN2r56uxnnlhPgtB3Or58sBYMiv9Fbc1zW82v980bEInPjkEl4Cv6ncyGu/
	 f8gtz/HeOPo73V8EVdhUxoKiQgZxVsszbFRSOQ0by0XoFwKivdf/1PbRnptRy11yAQ9f5
	 bQdhbOiB7GgLpiDkpQF8oPwFSkUzEvxFN+Di6V+x4lgA7macNK5GkH4IbFYrcfufXOnWo
	 7DN68kamMl2mIuMWIP2rbJIlOyti4FVdkJkj3dau+J+cHn+7y6AMeGM3GZlbcq42nTwQO
	 49iGD8ozf7RY5+hXepEPtlGyFq63ipvDxbykDC5dP/68ot+cvuAJyuSjwlMDOX4v4MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735362;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Q2/0Ue4giscDhogkms2MC+1BsK89qH5iUzgGUX6LCP4=;
	b=XyQ7ol5xi1EhfnYvJMKy1oB18DQEvk2cSzSnZle1CEiW9ogoiSWQPqNihutctqiSh/gV
	 JUx0t1lqfgURpkqiV0gv6YnPi0lVLhzwGvaUPMT/ype4/eGUirbSw2lmGsRx7JGr4lJbw
	 +5iFC1kDuTeC+s1z2ipXOVSFeGNMD2/n2hVWehC1sKOw/3uDcbsr/Z+QV34NrWHtaG43j
	 cLNEitozjg9hG+np2zrrhhxC2EIYqdt9npZYQvXXRXejdljaeF9OpisU0qBNyPN6yLelI
	 Xka+QmP2+OdVMegMwTmhXEFAd13g7lsK1A+2sOqPJKtesEsD232NqeuFRceoVuZE2Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="E3I/DCEn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E072D606A31B;
	Tue,  3 Nov 2026 19:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E3I/DCEn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D0F1F000C1;
	Tue,  3 Nov 2026 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793735361;
	bh=Q2/0Ue4giscDhogkms2MC+1BsK89qH5iUzgGUX6LCP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E3I/DCEnrwPBdTLhmdhtRbobh8XCmW7eI1pmKX4vsycqGAl3VuRlOf/lFWEGwGiSL
	 1ApzhVa9GY37LM73HbE00ZgvQ41RqHvQnPSEct+oPkpEcLAMHNe1kA6wnpbL0sPJ+b
	 TGAOEKI/a0f0wGrp/uP0h/JxWWM11V5eE8zsvEQFmK2rl/or75XVxurBa6wVqwpMsO
	 ZYuFX0d3U5aVVP0E9moW+jgmTVCFom4VE1px9AeiUZKtMeA7WHjH8eFZLCzrwYyY2h
	 CS3suGhVCLEThspTJ5pDS56e81ynODEJAdioHWksQk6xYOabN1gdxR+UJ4R67TMeam
	 edwtbeK5lzE7Q==
Date: Tue, 3 Nov 2026 19:49:14 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 28/28] KVM: arm64: Allow the creation of a SPE
 enabled VM
Message-ID: <auo4Zc5luDXD1Zei@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-29-alexandru.elisei@arm.com>
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
In-Reply-To: <20260903160623.315525-29-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:23PM +0100, Alexandru Elisei wrote:
> Everything is in place, allow userspace to enable SPE for a virtual
> machine.

I guess I've become fairly predictable :P but I think you should say more in
this commit message.

Explain what's being enabled, that you've laid the foundations, why you're
default =y, the dependency on the PMU, etc.

Also worth mentioning that you're bumping KVM_VCPU_MAX_FEATURES to make SPE
actually available to users when before it wasn't (and that you were doing the
work incrementally and only enabling once all in place for e.g.).

>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Agree on your response to Sashiko.

> ---
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/kvm/Kconfig            | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ff77f6ac3adf..32b30ffdcf77 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -40,7 +40,7 @@
>
>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>
> -#define KVM_VCPU_MAX_FEATURES 10
> +#define KVM_VCPU_MAX_FEATURES 11
>  #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
>
>  #define KVM_REQ_SLEEP \
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 2bc8e34c538d..a285b18eb1cc 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -106,9 +106,9 @@ endif # NVHE_EL2_DEBUG
>
>
>  config KVM_ARM_SPE
> -	bool
> +	bool "Support SPE in guest"

I think this description could have been there all along?

>  	depends on KVM && ARM_SPE_PMU
> -	default n
> +	default y

Definitely need to justify this for a new feature :) Especially as there are
erratum.

I guess the argument is that it depends on ARM_SPE_PMU and somebody setting that
would by implication want KVM_ARM_SPE.

If you go that way probably better to just make it explicit so the user can't
have a weird setup with 1 but not the other?

Something like:

config KVM_ARM_SPE
-	bool
+	def_bool y
 	depends on KVM && ARM_SPE_PMU
-	default n

Maybe?


>  	help
>  	  Adds support for Statistical Profiling Extension (SPE) in virtual
>  	  machines.
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
