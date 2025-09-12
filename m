Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A3428DC4;
	Fri, 12 Sep 2025 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694256; cv=none; b=CFy8nwClFJ428zKzYfUGvKQw3OTiWu3bypqbW1RS28hw0dLCEf+SssR7J2Co4/+AJmvIzOQR/shlyRyGGRnTWAsddA5tBc4cE7AUvx5Go3lNKD4Lw09ECRITV1ioQZimkUAzsSduzEfMmhtLGrARdbD4oI6vHV8m3Y7DaQ5ohIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694256; c=relaxed/simple;
	bh=1Lf0z7iqXiGoVgTprlyWI3nAB+PJ61PbGg/qSNp3X3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EeGOaBKH77m4ug5jDGu9P3VrJXJBbpdCYJUroEIfuZaXAsbWuZPVQzvPSbbI9fvZSP78Pli6oax15pOP9knz30BPRCX/RY2DtYWO6PgVYmYUAuM0rtO84u+L5IHpDaiD23zALD1bddzHdMi++kiDny7KP7FelbuBTrkQ1vW3KjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D026BC4CEF1;
	Fri, 12 Sep 2025 16:24:13 +0000 (UTC)
Date: Fri, 12 Sep 2025 17:24:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 3/6] arm64: Kconfig: add LSUI Kconfig
Message-ID: <aMRJK3x-K0HktAPA@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-4-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-4-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:26PM +0100, Yeoreum Yun wrote:
> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
> It's enough to add CONFIG_AS_HAS_LSUI only because the code for LSUI uses
> individual `.arch_extension` entries.

The subject could be improved slightly: Detect toolchain support for
LSUI.

> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/Kconfig | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e9bbfacc35a6..c474de3dce02 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2239,6 +2239,11 @@ config ARM64_GCS
> 
>  endmenu # "v9.4 architectural features"
> 
> +config AS_HAS_LSUI
> +	def_bool $(as-instr,.arch_extension lsui)
> +	help
> +	 Supported by LLVM 20 and later, not yet supported by GNU AS.

binutils 2.45 added support for LSUI.

Nitpick: we tend to add a two-space indentation from "help".

Otherwise it looks fine:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
