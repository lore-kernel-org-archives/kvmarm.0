Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DBE3B6366;
	Thu, 15 Oct 2026 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792073727; cv=none; b=kDwJ106uN1amiP7GsSwY6sEP3YKF0uu6mLIFJq72gZjdjSED8PL1xCC9I5/d2ZEEejT66SVJabfvtwtJFrZ21Q0N3IdPepulhoEIFfO6BaBOwxmjNtJYusatCCssyY1bkqf7m7BqPth85jnpOJ6PwAdQlHmGedmomo/XCSOhjfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792073727; c=relaxed/simple;
	bh=RYbrulCqMy6C+PL5BosdihUElVmnBxRoDEQa4rkaPrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3FHsI/VN9kBKJfwLZ61KnXq6lyj3CrpF6Z3qo19eRxrY7B18R8WfBiwb3lXHr1h0kNG+M3pfmzj4o9/eIx9tbU4kX/+PdSbdyMdWeDVJyLGI7n8ZieM4v/G3d24NLUsbIERrMJUkWiP+nHWp6EpOmTUKMIOYZUgTGgoqBUhWXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4imKHXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4imKHXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5F61F000C4;
	Thu, 15 Oct 2026 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792073726;
	bh=hQDHOplHUGv77hfd0oQ4n9tB9YO6bJ+Eq2WryDRF/Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X4imKHXQU3mX+G+97i7d9YoI/2vFiBhh0JQYSQKFsOwO2eicg91lXDJH8PiED+5er
	 limSY8Ce5fa1JofCh0RSo/iBQlHhnJL210tZ2mEedz5IdhT554maeW0L8YVY7YK0iJ
	 RVwkA5/IuVdekUztByKBWESMPgDPpX62VXUZaMVV4GtMai4jpWCFrXmYuZ5u1EVQOq
	 zvcV2RJRV+GE9Yz/PxxQ6Wae449E+F1AeUGPQg+0S01CihYkNPiqaaIwBZABKxeWz0
	 kIiUxZ6Q97Y4HpfZFr+qHYEvNTU4+RZ7XwQkCUfFo53Qy12FzR8zl9W6D2lp0iyrEn
	 +FCQpqL0l6xRg==
Date: Thu, 15 Oct 2026 15:15:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 03/28] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
Message-ID: <atDa-BSF3RMzJSdE@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-4-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-4-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:05:58PM +0100, Alexandru Elisei wrote:
> Add a new configuration option that will be used for KVM SPE emulation.
> CONFIG_KVM_ARM_SPE depends on the SPE driver being loaded because:
>
> 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
>    and that will be used by KVM to emulate SPE on heterogeneous systems.

I guess e.g. big.LITTLE?

>
> 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
>    level.
>
> The option will become user selectable after SPE support in KVM is
> implemented.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

With nit addressed the redundant dependency removed (both noted below),
LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/kvm/Kconfig | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 449154f9a485..fece4c02b97c 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -103,5 +103,14 @@ config PKVM_STACKTRACE
>  	  If unsure, or not using protected nVHE (pKVM), say N.
>
>  endif # NVHE_EL2_DEBUG
> +
> +config KVM_ARM_SPE

NIT: Nothing else in the file has the _ARM_ prefix, so is that redundant
here?

> +	bool
> +	depends on KVM && ARM_SPE_PMU

I think KVM should be removed here, this is within an 'if KVM' block
already, and nothing else here depends on it either so not a convention.

> +	default n
> +	help
> +	  Adds support for Statistical Profiling Extension (SPE) in virtual
> +	  machines.
> +
>  endif # KVM
>  endif # VIRTUALIZATION
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
