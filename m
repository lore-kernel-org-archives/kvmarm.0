Received: from out-26.mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6102B1EA8B
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 21:39:19 +0000 (UTC)
Date: Thu, 25 May 2023 21:39:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685050757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+VwLV0iEPlynwi1LSTqGxgNADCv+g+kF4twYCaw1HI=;
	b=Hh/9PSeJIJyO2wP2Dx8GQ2aYt07ldwJNuqorWUj9m6abnDMvq0iJX4oM6iadR/GfTLFlYg
	Vgc7aLrOCotbyRiXeASo+Towwwl42xyDagWgrOEUrsA1SIbG7BmPBrUf5SBOTMoyQElNHB
	KuiZno9COc9Nehu73qxC4VqQ1lIvDp4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v2 2/7] arm64/sysreg: Convert MDSCR_EL1 to automatic
 register generation
Message-ID: <ZG/VgDIbmEg7IiDe@linux.dev>
References: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
 <20230419-arm64-syreg-gen-v2-2-4c6add1f6257@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419-arm64-syreg-gen-v2-2-4c6add1f6257@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, May 23, 2023 at 07:37:00PM +0100, Mark Brown wrote:
> Convert MDSCR_EL1 to automatic register generation as per DDI0616 2023-03.
> No functional change.
> 
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h |  1 -
>  arch/arm64/tools/sysreg         | 28 ++++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 3d69bda0e608..95de1aaee0e9 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -135,7 +135,6 @@
>  #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>  
>  #define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
> -#define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
>  #define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
>  #define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
>  #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index df7a7ba97b43..601cc8024734 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -55,6 +55,34 @@ Field	29	TX
>  Res0	28:0
>  EndSysreg
>  
> +Sysreg	MDSCR_EL1	2	0	0	2	2
> +Res0	63:36
> +Field	35	EHBWE
> +Field	34	EnSPM
> +Field	33	TTA
> +Field	32	EMBWE
> +Field	31	TFO
> +Field	30	RXfull
> +Field	29	TXfull
> +Res0	28
> +Field	27	RXO
> +Field	26	TXU
> +Res0	25:24
> +Field	23:22	INTdis
> +Field	21	TDA
> +Res0	20
> +Field	19	SC2
> +Res0	18:16

These bits are actually RAZ/WI. I know that doesn't amount to much right
now, but eventually getting a mask of RAZ/WI bits for registers would be
helpful for KVM sysreg emulation.

> +Field	15	MDE
> +Field	14	HDE
> +Field	13	KDE
> +Field	12	TDCC
> +Res0	11:7
> +Field	6	ERR
> +Res0	5:1
> +Field	0	SS
> +EndSysreg
> +
>  Sysreg ID_PFR0_EL1	3	0	0	1	0
>  Res0	63:32
>  UnsignedEnum	31:28	RAS
> 
> -- 
> 2.30.2
> 

-- 
Thanks,
Oliver
