Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C49930C0E0;
	Wed, 17 Sep 2025 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758122904; cv=none; b=Xvoy5DG7hL0JrTsOH5/Lnr0xdGnCrUv18aJTg7D+caxiMAE9Tz1DcvaookLfd7S+EwVAwqosgmSM79YfRGABxExq67gYwaKBPJBc9hVmQrQdiRzbctaV0dovJEopnGwmso/UXP5N2JL2KaGbDl3CLYJekaotN1fcEUl6FRXtRzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758122904; c=relaxed/simple;
	bh=tCpYKYOs1RRFEZTeEQBT6Jf93AtipOf9WVQbNEp0FSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRzVP8ogROkmhiUeE6UGsRepz769vj6zci9O6Y62NCysnhfyxe0j274H5cGQM5Nye7nqAQj6Qycx+xtuHw017VsU10EncJrTa55vWpTcvfK9vOdH0iRChPsQmvYmwLf3ACoRW5GeIDva8JsFeIdSsbEPQ7re4C7mb9h6VVnj8mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlsKh/KO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlsKh/KO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB7CC4CEE7;
	Wed, 17 Sep 2025 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758122903;
	bh=tCpYKYOs1RRFEZTeEQBT6Jf93AtipOf9WVQbNEp0FSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KlsKh/KOWTz9EJsOhxbcsQD1AonOuNxGcDYCaLEvof0go8Kii2EdkTTE3cwzPY4+x
	 pezqfTuKvi9Fyq8mgaea4SqDfa9UD6PRx+EjdXTuYIXRZBRf44v2XLveKJsGGoCqRP
	 602qHH66J3aZQttpSl5FEe7O1QIUSnuUChjwlwFkG9xvRbSnJopQl9bpq+fWTNqDWl
	 PXwste2mqnB34TEm4tS16177xoqY7yOlcrmkPIyBm5rty+gYZd+0D1YEz9+J4mt7UX
	 2uF+bsk4wVK8zl+k1Sax14G72QagFZhjpimL4OyCtSA/RpByUaOKLlD3Lr0gs92s6v
	 hUbwmgbk6ZzcA==
Date: Wed, 17 Sep 2025 16:28:16 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, broonie@kernel.org, oliver.upton@linux.dev,
	anshuman.khandual@arm.com, robh@kernel.org, james.morse@arm.com,
	mark.rutland@arm.com, joey.gouly@arm.com, Dave.Martin@arm.com,
	ahmed.genidi@arm.com, kevin.brodsky@arm.com,
	scott@os.amperecomputing.com, mbenes@suse.cz,
	james.clark@linaro.org, frederic@kernel.org, rafael@kernel.org,
	pavel@kernel.org, ryan.roberts@arm.com, suzuki.poulose@arm.com,
	maz@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 0/6] initialize SCTRL2_ELx
Message-ID: <aMrTkLhLOhas8Viy@willie-the-truck>
References: <20250917145618.1232329-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917145618.1232329-1-yeoreum.yun@arm.com>

On Wed, Sep 17, 2025 at 03:56:12PM +0100, Yeoreum Yun wrote:
> This series introduces initial support for the SCTLR2_ELx registers in Linux.
> The feature is optional starting from ARMv8.8/ARMv9.3,
> and becomes mandatory from ARMv8.9/ARMv9.4.
> 
> Currently, Linux has no strict need to modify SCTLR2_ELx--
> at least assuming that firmware initializes
> these registers to reasonable defaults.
> 
> However, several upcoming architectural features will require configuring
> control bits in these registers.
> Notable examples include FEAT_PAuth_LR and FEAT_CPA2.
> 
> Patch History
> ==============
> from v4 to v5:
>   - using .ifc in set_sctlr2_elx
>   - change (re)initialise position after SCTLR_ELx
>   - add docs for SCTRL2_ELx
>   - rebase to v6.17-rc6
>   - https://lore.kernel.org/all/20250821172408.2101870-1-yeoreum.yun@arm.com/

Sorry, this is a really pedantic nit, but please can you fix the typo in
the subject if/when you next post this?

More importantly, as Dave says, I don't see the point in merging this
until we have a use for the register. At that point, your patches can
hopefully be a prefix of the series that uses it.

Will
