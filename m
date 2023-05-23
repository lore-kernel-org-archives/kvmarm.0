Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA8E1D2BF
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 08:23:38 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28F36139F;
	Tue, 23 May 2023 01:24:23 -0700 (PDT)
Received: from [10.162.42.7] (unknown [10.162.42.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 202113F762;
	Tue, 23 May 2023 01:23:34 -0700 (PDT)
Message-ID: <742672ff-bb53-46e9-048c-a2201cb0be2f@arm.com>
Date: Tue, 23 May 2023 13:53:32 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 2/5] arm64/sysreg: Convert MDCCINT_EL1 to automatic
 register generation
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-2-936cd769cb9e@kernel.org>
Content-Language: en-US
In-Reply-To: <20230419-arm64-syreg-gen-v1-2-936cd769cb9e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/22/23 21:52, Mark Brown wrote:
> Convert MDCCINT_EL1 to automatic register generation as per DDI0616
> 2023-03. No functional change.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/include/asm/sysreg.h | 1 -
>  arch/arm64/tools/sysreg         | 7 +++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 6505665624d4..4e48bb4dca6a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,7 +134,6 @@
>  #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>  #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>  
> -#define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
>  #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
>  #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
>  #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index dd5a9c7e310f..1699e87bc0b4 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -48,6 +48,13 @@
>  # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
>  # item ACCDATA) though it may be more taseful to do something else.
>  
> +Sysreg	MDCCINT_EL1	2	0	0	2	0
> +Res0	63:31
> +Field	30	RX
> +Field	29	TX
> +Res0	28:0
> +EndSysreg
> +
>  Sysreg ID_PFR0_EL1	3	0	0	1	0
>  Res0	63:32
>  UnsignedEnum	31:28	RAS
> 
