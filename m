Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48526219A89;
	Tue, 29 Apr 2025 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745938038; cv=none; b=VTksXo/nCwxr8T2iHEEj/x4TatNQPS5YTHNOWowMzf6StJw6rjRCkYF1xgkAy2mbyp+R/X8HkqBx03f0O0B/jeuEL2+H+Sd1/I8SYQYSbtY+99oQ2cNDPtBfgwcauVQvipXrxJvrkRXdaqYH5eoFjKfLRaJEk1YhtFmDX4H7UcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745938038; c=relaxed/simple;
	bh=YrCTaP+tcbajXC6/b7SoFDFq5t/KwEus2QAmCVIBrgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQXBzOfoLe8rrRPJ298VQYEVYCjm4AFtP8l7ZquHMRpFJWe/6ZtFTxK8rda1iF+Borwxbvf3dI12bruMK7s+DU/KTLjji48x0dQoumW3g6mqoqaAG0hOUcYxgweX98ImwJf5DSWvXXdL5AI4iFtttWvLu4htymbUhj3Lk0S7ZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbR1oFYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbR1oFYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EDDC4CEE3;
	Tue, 29 Apr 2025 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745938037;
	bh=YrCTaP+tcbajXC6/b7SoFDFq5t/KwEus2QAmCVIBrgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hbR1oFYPepr21AnMku8sxgvGJfsYYvl+fDZNSEjow+OM+SmnawdmzUYE6W503cQt8
	 XZjoDeTObvh5TG7hYoRM1I4oxZUxAxaTjfJA1NwXoiMeZJwrf/fC8leQincBNcved7
	 yP3NDUoYMLwFAh5F3o0o/MmxYtdPTDBBlEL8y7zs5hklYuV8BGzfckSbcG6qogpMVa
	 iHNbiGVS1X/EN75MQp6WlLOtNog52OasZ3jLYJwKOIQwiFOyOzy6I+tG5h5xKDRO4X
	 McRfIe8Isa3OaUzcWQOArxt0gUukeKzFVYMnyDILtjyd401Es3kKvyAzdQPPtMEkqS
	 cP6smDLj3VjUA==
Date: Tue, 29 Apr 2025 15:47:10 +0100
From: Will Deacon <will@kernel.org>
To: Yicong Yang <yangyicong@huawei.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	corbet@lwn.net, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, shuah@kernel.org,
	jonathan.cameron@huawei.com, shameerali.kolothum.thodi@huawei.com,
	linuxarm@huawei.com, prime.zeng@hisilicon.com, xuwei5@huawei.com,
	yangyicong@hisilicon.com, tangchengchang@huawei.com,
	broonie@kernel.org
Subject: Re: [PATCH v2 1/6] arm64: Provide basic EL2 setup for FEAT_{LS64,
 LS64_V} usage at EL0/1
Message-ID: <20250429144710.GA26174@willie-the-truck>
References: <20250331094320.35226-1-yangyicong@huawei.com>
 <20250331094320.35226-2-yangyicong@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331094320.35226-2-yangyicong@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 31, 2025 at 05:43:15PM +0800, Yicong Yang wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
> 
> Instructions introduced by FEAT_{LS64, LS64_V} is controlled by
> HCRX_EL2.{EnALS, EnASR}. Configure all of these to allow usage
> at EL0/1.
> 
> This doesn't mean these instructions are always available in
> EL0/1 if provided. The hypervisor still have the control at
> runtime.
> 
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> ---
>  arch/arm64/include/asm/el2_setup.h | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index ebceaae3c749..0259941602c4 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -57,9 +57,19 @@
>          /* Enable GCS if supported */
>  	mrs_s	x1, SYS_ID_AA64PFR1_EL1
>  	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
> -	cbz	x1, .Lset_hcrx_\@
> +	cbz	x1, .Lskip_gcs_hcrx_\@
>  	orr	x0, x0, #HCRX_EL2_GCSEn
>  
> +.Lskip_gcs_hcrx_\@:
> +	/* Enable LS64, LS64_V if supported */
> +	mrs_s	x1, SYS_ID_AA64ISAR1_EL1
> +	ubfx	x1, x1, #ID_AA64ISAR1_EL1_LS64_SHIFT, #4
> +	cbz	x1, .Lset_hcrx_\@
> +	orr	x0, x0, #HCRX_EL2_EnALS
> +	cmp	x1, #ID_AA64ISAR1_EL1_LS64_LS64_V
> +	b.lt	.Lset_hcrx_\@
> +	orr	x0, x0, #HCRX_EL2_EnASR

How do these HCRX settings survive a world-switch to and from a KVM
guest? AFAICT, the trap deactivation path there restores HCRX_HOST_FLAGS
when returning to the host. That would mean that the GCS code is broken
too, unless I'm missing something :/

Will
