Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C68017D2
	for <kvmarm@lists.linux.dev>; Mon,  6 Apr 2026 07:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775460776; cv=none; b=dHIVlD1R4hjQr+jfF6212kgogostORlUvPQsmNwDynzGdnqsf0ieEgZCUVQTNYPvVKiyY1bX6H4/xbORyMNcE8/avHgUd95BOccfqzGljNlv/4TvNlyDzsqgrzsFHDLrhjHEgwdFukE/ci9BPUIFZDtwJCTRYQCZivFIzlvs0NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775460776; c=relaxed/simple;
	bh=tFc2zLl3pskbe3FC0+yZdcjLpUXA/C9dZ7kzSWxtKJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKmBoffgL3JLehaRa1/ymTUq4VD0XPsq7Xc9ye1yJlC7QyDIra04af9GQpchqM+Ybg5h8u9vpt2uvJ7RngiFINHH3ZrrbQExS6re9lSXaiLXNkXUGt7cARZsfCtk6GNrLnPBpSJa8+fv168kG8AO8UPEGtlK/eAdvb9Tc1mQrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkYMxxpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkYMxxpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F321DC4CEF7;
	Mon,  6 Apr 2026 07:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775460776;
	bh=tFc2zLl3pskbe3FC0+yZdcjLpUXA/C9dZ7kzSWxtKJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkYMxxpgXc0u/JzR1P59+gpwjGqbDRTkIouFQhLlUaskNSAcU+KbdNoYpodmTn674
	 mAi6Xm4zSSBlb6pXoyuzIggzeZ4X1P8uLIIUsfPdo1doLi1Dp5XE0qhXgK/WFhjjWZ
	 ZODEUyYszoMvviPXSh5NXqfgNLzEWXmkuIzqrvs2g2C1PBcJIZc6yFZ0P77QUdNd5q
	 1b6Y9KjrHNvGGyFJrk+mPrgInKxMwP3n0T1u+j6xizfQtNaKFE0vXMU8k4oaEWGAyF
	 UdjadVyd+5E8Sv95odTSevN4t+JaDqXl63zsSfAd0NB0jfPOtM9g3zz0D0Mc6Ecyu5
	 3v7HqQnYME9cQ==
Date: Mon, 6 Apr 2026 00:32:51 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR2_EL1.GCIE
Message-ID: <20260406073251.GA2366413@ax162>
References: <20260401170017.369529-1-maz@kernel.org>
 <20260404181330.GA3987102@ax162>
 <874ilqcu3c.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ilqcu3c.wl-maz@kernel.org>

On Sat, Apr 04, 2026 at 10:07:51PM +0100, Marc Zyngier wrote:
> Gah. No idea how I managed to miss that: the register fields must be
> strictly ordered, and I placed the field in the wrong spot. The
> following hack fixes it for me:
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 5bca6e064ca72..1bfaa96881dab 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -325,9 +325,9 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
>  
>  static const struct arm64_ftr_bits ftr_id_aa64pfr2[] = {
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_FPMR_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_GCIE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_MTEFAR_SHIFT, 4, ID_AA64PFR2_EL1_MTEFAR_NI),
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_MTESTOREONLY_SHIFT, 4, ID_AA64PFR2_EL1_MTESTOREONLY_NI),
> -	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_GCIE_SHIFT, 4, ID_AA64PFR2_EL1_GCIE_NI),
>  	ARM64_FTR_END,
>  };
>  
> If that works for you, I'll fold that into the original patch...

Can confirm.

> Thanks for pointing this out!

Thanks for the quick fix!

Cheers,
Nathan
