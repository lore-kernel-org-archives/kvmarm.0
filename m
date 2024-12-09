Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C90E35953
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733752773; cv=none; b=hR3irfrzkY+78NmFSoL6XgOYp9SdbPzoCoSvvPIqWkYsS/BHTQt4ay0q5UD+5z+4w+IVrCmdOXFh4BcP0+auHx0X44QEprl4CNPGddOqbMJ4lcqukrH4jLv3gaSuCHhauSpjXkcimgYJG/UCyvHhaH3e15kKflN76GlMaXsNVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733752773; c=relaxed/simple;
	bh=csaGlLrQG3nnhpMXZ022fwORHnAyvJ4UbI/1KEaQHi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwUT4yuQJGolbRO1MJfAna7gtNQEUecNIR2pPm9A3q4jRXsl6bOtsQGjWAMKsT8+Ym/7IUQJt2vkU3n16ny9oKM7xlRiBZUm1suo4iwFvbUaWQMlOGvqs5bbAo5RSE5xXbVza8hSBWghH/9aDve/+5jNp6XjxFpdaDnh36LWSIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4DC2113E;
	Mon,  9 Dec 2024 05:59:58 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C0BE3F720;
	Mon,  9 Dec 2024 05:59:29 -0800 (PST)
Date: Mon, 9 Dec 2024 13:59:27 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 3/4] arm64/sysreg: Convert *_EL12 accessors to Mapping
Message-ID: <Z1b3v3NvMK28NqTt@J2N7QTR9R3.cambridge.arm.com>
References: <20241207190740.2607673-1-maz@kernel.org>
 <20241207190740.2607673-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241207190740.2607673-4-maz@kernel.org>

On Sat, Dec 07, 2024 at 07:07:39PM +0000, Marc Zyngier wrote:
> Perform a bulk convert of the remaining EL12 accessors to use the
> Mapping qualifier, which meakes things a bit clearer.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I haven't looked at the code in detail, but conceptually this makes
sense to me, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/tools/sysreg | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 19d137d9c50ed..ad2f6265f7948 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2954,23 +2954,23 @@ Field	63:0	PhysicalOffset
>  EndSysreg
>  
>  Sysreg	CPACR_EL12	3	5	1	0	2
> -Fields	CPACR_ELx
> +Mapping	CPACR_EL1
>  EndSysreg
>  
>  Sysreg	ZCR_EL12	3	5	1	2	0
> -Fields	ZCR_ELx
> +Mapping	ZCR_EL1
>  EndSysreg
>  
>  Sysreg	SMCR_EL12	3	5	1	2	6
> -Fields	SMCR_ELx
> +Mapping	SMCR_EL1
>  EndSysreg
>  
>  Sysreg	GCSCR_EL12	3	5	2	5	0
> -Fields	GCSCR_ELx
> +Mapping	GCSCR_EL1
>  EndSysreg
>  
>  Sysreg	GCSPR_EL12	3	5	2	5	1
> -Fields	GCSPR_ELx
> +Mapping	GCSPR_EL1
>  EndSysreg
>  
>  Sysreg	FAR_EL12	3	5	6	0	0
> @@ -2982,7 +2982,7 @@ Fields	MPAM1_ELx
>  EndSysreg
>  
>  Sysreg	CONTEXTIDR_EL12	3	5	13	0	1
> -Fields	CONTEXTIDR_ELx
> +Mapping	CONTEXTIDR_EL1
>  EndSysreg
>  
>  SysregFields TTBRx_EL1
> @@ -3087,7 +3087,7 @@ Fields	PIRx_ELx
>  EndSysreg
>  
>  Sysreg	PIRE0_EL12	3	5	10	2	2
> -Fields	PIRx_ELx
> +Mapping	PIRE0_EL1
>  EndSysreg
>  
>  Sysreg	PIRE0_EL2	3	4	10	2	2
> @@ -3099,7 +3099,7 @@ Fields	PIRx_ELx
>  EndSysreg
>  
>  Sysreg	PIR_EL12	3	5	10	2	3
> -Fields	PIRx_ELx
> +Mapping	PIR_EL1
>  EndSysreg
>  
>  Sysreg	PIR_EL2		3	4	10	2	3
> @@ -3119,7 +3119,7 @@ Fields	PIRx_ELx
>  EndSysreg
>  
>  Sysreg	POR_EL12	3	5	10	2	4
> -Fields	PIRx_ELx
> +Mapping	POR_EL1
>  EndSysreg
>  
>  Sysreg	S2POR_EL1	3	0	10	2	5
> -- 
> 2.39.2
> 
