Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47B21DDF3
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 08:13:06 +0000 (UTC)
Date: Tue, 23 May 2023 08:13:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684829584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lo+8u5rwataPck7mvk/JQ6bPb50N+x5IthJ2AVYj7TE=;
	b=T5pEjF+rE92i+/I/aK5r3XFh/21/ovkhnZi11b8TR+6H0j1dSUORt9wRBEWHqUDnRiD6Z6
	mpYeaJNiFi+aqKaOpLxZX5SWooZ0yiOPOZXr3wKe5SVOr3vHoFfRRkHS4jLX0qkvdiiuOX
	zve6banWIftcCrPi7Jf4gPt2hb1A1gY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 5/5] arm64/sysreg: Convert OSLAR_EL1 to automatic
 generation
Message-ID: <ZGx1jT4nQ9HEVWSE@linux.dev>
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-5-936cd769cb9e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419-arm64-syreg-gen-v1-5-936cd769cb9e@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, May 22, 2023 at 05:22:44PM +0100, Mark Brown wrote:
> Convert OSLAR_EL1 to automatic generation as per DDI0601 2023-03. No
> functional change.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 3 ---
>  arch/arm64/tools/sysreg         | 5 +++++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 09de958e79ed..3b51e532caa9 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -140,9 +140,6 @@
>  #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
>  #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
>  
> -#define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
> -#define OSLAR_EL1_OSLK			BIT(0)
> -
>  #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
>  #define OSLSR_EL1_OSLM_MASK		(BIT(3) | BIT(0))
>  #define OSLSR_EL1_OSLM_NI		0

Should the OSLSR_EL1 definitions be rolled over to the generated scheme
as well?

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a5ae0e19fc9f..84df0b7feb45 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -83,6 +83,11 @@ Res0	5:1
>  Field	0	SS
>  EndSysreg
>  
> +Sysreg	OSLAR_EL1	2	0	1	0	4
> +Res0	63:1
> +Field	0	OSLK
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
