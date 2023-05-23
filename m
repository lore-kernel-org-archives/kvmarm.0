Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810861D2BF
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 08:23:19 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8998139F;
	Tue, 23 May 2023 01:24:03 -0700 (PDT)
Received: from [10.162.42.7] (unknown [10.162.42.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF7893F762;
	Tue, 23 May 2023 01:23:15 -0700 (PDT)
Message-ID: <6fc450c6-98cb-5c14-8580-3f1a6b8ef10f@arm.com>
Date: Tue, 23 May 2023 13:53:12 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 1/5] arm64/sysreg: Remove some unused sysreg definitions
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-1-936cd769cb9e@kernel.org>
Content-Language: en-US
In-Reply-To: <20230419-arm64-syreg-gen-v1-1-936cd769cb9e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/22/23 21:52, Mark Brown wrote:
> Since there are no references to OSDTRRX_EL1 or OSECCR_EL1 in the code
> just remove the definitions rather than converting to automatic
> generation.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/include/asm/sysreg.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9e3ecba3c4e6..6505665624d4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,11 +134,8 @@
>  #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>  #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>  
> -#define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
>  #define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
>  #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
> -#define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
> -#define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
>  #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
>  #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
>  #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
> 
