Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF03125A3
	for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 07:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB14F1FB;
	Tue, 28 Nov 2023 23:26:00 -0800 (PST)
Received: from [10.163.33.248] (unknown [10.163.33.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 132213F6C4;
	Tue, 28 Nov 2023 23:25:09 -0800 (PST)
Message-ID: <6d26f433-d176-4017-8f87-a1def77c468a@arm.com>
Date: Wed, 29 Nov 2023 12:55:08 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] arm64: Kill detection of VPIPT i-cache policy
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231127172613.1490283-1-maz@kernel.org>
 <20231127172613.1490283-3-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20231127172613.1490283-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/27/23 22:56, Marc Zyngier wrote:
> Since the kernel will never run on a system with the VPIPT i-cache
> policy, drop the detection code altogether.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/include/asm/cache.h | 6 ------
>  arch/arm64/kernel/cpuinfo.c    | 5 -----
>  2 files changed, 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
> index ceb368d33bf4..06a4670bdb0b 100644
> --- a/arch/arm64/include/asm/cache.h
> +++ b/arch/arm64/include/asm/cache.h
> @@ -58,7 +58,6 @@ static inline unsigned int arch_slab_minalign(void)
>  #define CTR_L1IP(ctr)		SYS_FIELD_GET(CTR_EL0, L1Ip, ctr)
>  
>  #define ICACHEF_ALIASING	0
> -#define ICACHEF_VPIPT		1
>  extern unsigned long __icache_flags;
>  
>  /*
> @@ -70,11 +69,6 @@ static inline int icache_is_aliasing(void)
>  	return test_bit(ICACHEF_ALIASING, &__icache_flags);
>  }
>  
> -static __always_inline int icache_is_vpipt(void)
> -{
> -	return test_bit(ICACHEF_VPIPT, &__icache_flags);
> -}
> -
>  static inline u32 cache_type_cwg(void)
>  {
>  	return SYS_FIELD_GET(CTR_EL0, CWG, read_cpuid_cachetype());
> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> index a257da7b56fe..47043c0d95ec 100644
> --- a/arch/arm64/kernel/cpuinfo.c
> +++ b/arch/arm64/kernel/cpuinfo.c
> @@ -36,8 +36,6 @@ static struct cpuinfo_arm64 boot_cpu_data;
>  static inline const char *icache_policy_str(int l1ip)
>  {
>  	switch (l1ip) {
> -	case CTR_EL0_L1Ip_VPIPT:
> -		return "VPIPT";
>  	case CTR_EL0_L1Ip_VIPT:
>  		return "VIPT";
>  	case CTR_EL0_L1Ip_PIPT:
> @@ -388,9 +386,6 @@ static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
>  	switch (l1ip) {
>  	case CTR_EL0_L1Ip_PIPT:
>  		break;
> -	case CTR_EL0_L1Ip_VPIPT:
> -		set_bit(ICACHEF_VPIPT, &__icache_flags);
> -		break;
>  	case CTR_EL0_L1Ip_VIPT:
>  	default:
>  		/* Assume aliasing */
