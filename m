Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5464A3DD875
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 09:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404907; cv=none; b=NeyG+afBzQQq13ON9arkOT5Cd2xhhiAo3yoMaIus9+oBNExtyuzLxSftLlrHD8fMw0oHl3SuihSocgVARWyv1qFpfotRX8fQ6JSH7WJOS6PZqJ59KnUQulXN6iCxD0rwv7JKGGQ3XTm4rXF3XguLHXvItqkUyhnWcNSvxHSK8fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404907; c=relaxed/simple;
	bh=WCcxbt8cWBw/MJSGNEPdezkYv++GEzKPaSoAjrPupk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FECKXPLsJhJDclFEbyyh2Wc93h0aAwln8JcYSOXEx1+4oOpAmV+zRwqSyle7/xFQ6YU81hjO6b0EEoQ4zfw4EO3BmJvWkXX3KAmTKxprR5/rJa+UIW9bEJYT/eLbhTYW+LkA9vVBKG7qgvTfIgv/XqkfqKlI7UuVX6PYIQVTOak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cwYOr1jn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cwYOr1jn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E74B204C;
	Thu, 30 Jul 2026 02:48:21 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 161AD3F763;
	Thu, 30 Jul 2026 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404905; bh=WCcxbt8cWBw/MJSGNEPdezkYv++GEzKPaSoAjrPupk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cwYOr1jnOBPVfZTPnducbeuKK2szQun0nSD4EDU+IHwfVsIRVbWnQ312YR0lUWGRT
	 6viI67IWtdTKwM7PVQ8UbNa0kit2vIFfCZ1j7LaTuFMuSx/GXawF2SnOF8jlawnYpH
	 OiBZQPRdV3o3SJMBvoVzcVxx7wQej3+oGhI08Hzo=
Date: Thu, 30 Jul 2026 10:48:21 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v4 02/29] arm64: Update ID_AA64MMFR4_EL1 description to
 2026-03 JSON release
Message-ID: <amsd5YfcjfMcBnLy@e143914.arm.com>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730071022.296811-3-maz@kernel.org>

On Thu, Jul 30, 2026 at 08:09:55AM +0100, Marc Zyngier wrote:
> ID_AA64MMFR4_EL1 has gained a few fields and enum values in the past
> few months, so resync its definition with the 2026-03 JSON release.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Checked the values.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/tools/sysreg | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 7cb61aca3797f..3171c87eb2447 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2386,17 +2386,40 @@ EndEnum
>  EndSysreg
>  
>  Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
> -Res0	63:48
> -UnsignedEnum	47:44	SRMASK
> +UnsignedEnum	63:60	MTEFGT
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +UnsignedEnum	59:56	SCRX
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +UnsignedEnum	55:52	TEV
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +UnsignedEnum	51:48	TPS
> +	0b0000	VAL_0000
> +	0b0001	VAL_0001
> +	0b0010	VAL_0010
> +EndEnum
> +UnsignedEnum	47:44	SRMASK
> +	0b0000	NI
> +	0b0001	IMP
> +	0b0010	SRMASK2
> +EndEnum
> +UnsignedEnum	43:40	TLBID
>  	0b0000	NI
>  	0b0001	IMP
>  EndEnum
> -Res0	43:40
>  UnsignedEnum	39:36	E3DSE
>  	0b0000	NI
>  	0b0001	IMP
>  EndEnum
> -Res0	35:32
> +UnsignedEnum	35:32	EAESR
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
>  UnsignedEnum	31:28	RMEGDI
>  	0b0000	NI
>  	0b0001	IMP
> @@ -2410,6 +2433,7 @@ UnsignedEnum	23:20	NV_frac
>  	0b0000	NV_NV2
>  	0b0001	NV2_ONLY
>  	0b0010	NV2P1
> +	0b0011	NV3
>  EndEnum
>  UnsignedEnum	19:16	FGWTE3
>  	0b0000	NI
> -- 
> 2.47.3
> 
