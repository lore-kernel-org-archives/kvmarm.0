Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8A52135A4
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745933891; cv=none; b=lK/gMYbOjAWaEHcvrzPCJAV5m01gOWxAKxfV5GDxCG7uizC2Tu+G/PWq6pUAl9FDMcCLVgUhL2CgnpUlXdPINkQcu7+iVaSV79zNpUl1j/b5jGSlcwDCP0/0ijLeR9r5ObNSsr8bLOEBGsN6Bw0l1mRgPleTUQUtx15exyt83Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745933891; c=relaxed/simple;
	bh=wB70FRP/aSmlCkRecgc26yX2ofUavoiKG/fAqHKjKFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFvGMUbN3GM7FI1POnT1J6WTJPLUGswX2tBzRsFwtUA8aK+Lme4KbyjbMCz1/EtgVHctVnvqMoqmnDpM1SankRgVsvRMvGsavpx9R9U5B3oJiskRpxFKuLLfugS0GOB9r2kVgKZC3g6fkO42M9ZDxadnj5bdfKU6VSeSm58VfbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD6D81515;
	Tue, 29 Apr 2025 06:38:01 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 916F93F673;
	Tue, 29 Apr 2025 06:38:06 -0700 (PDT)
Date: Tue, 29 Apr 2025 14:38:03 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 02/42] arm64: sysreg: Update ID_AA64MMFR4_EL1
 description
Message-ID: <20250429133803.GB1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-3-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:27:56PM +0100, Marc Zyngier wrote:
> Resync the ID_AA64MMFR4_EL1 with the architectue description.
> 
> This results in:
> 
> - the new PoPS field
> - the new NV2P1 value for the NV_frac field
> - the new RMEGDI field
> - the new SRMASK field
> 
> These fields have been generated from the reference JSON file.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index e5da8848b66b5..fce8328c7c00b 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1946,12 +1946,21 @@ EndEnum
>  EndSysreg
>  
>  Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
> -Res0	63:40
> +Res0	63:48
> +UnsignedEnum	47:44	SRMASK
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +Res0	43:40
>  UnsignedEnum	39:36	E3DSE
>  	0b0000	NI
>  	0b0001	IMP
>  EndEnum
> -Res0	35:28
> +Res0	35:32
> +UnsignedEnum	31:28	RMEGDI
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
>  SignedEnum	27:24	E2H0
>  	0b0000	IMP
>  	0b1110	NI_NV1
> @@ -1960,6 +1969,7 @@ EndEnum
>  UnsignedEnum	23:20	NV_frac
>  	0b0000	NV_NV2
>  	0b0001	NV2_ONLY
> +	0b0010	NV2P1
>  EndEnum
>  UnsignedEnum	19:16	FGWTE3
>  	0b0000	NI
> @@ -1979,7 +1989,10 @@ SignedEnum	7:4	EIESB
>  	0b0010	ToELx
>  	0b1111	ANY
>  EndEnum
> -Res0	3:0
> +UnsignedEnum	3:0	PoPS
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
>  EndSysreg
>  
>  Sysreg	SCTLR_EL1	3	0	1	0	0

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
