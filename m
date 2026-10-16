Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CDC4508E9
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 11:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151436; cv=none; b=lxWZ1XlOPiGPl6082hyAAkDl9RrB/IeLVoL0cZw0So0RJRzsLEnIzoCuYKbY6X9Tv6jKvt6IEcmD7uOVFViRXQP3D7YltECWKBn3NHUYnK6aqn+76QXdIIwhYkPA6KKh2K7w6Swjw8l0pLipkleP6AA/NzkwjEMeTjEpyHDFFQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151436; c=relaxed/simple;
	bh=7eDJICq300beGRALQlJrXpadKotDns99R6Gkf0Dn3K0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZq9/piyD4MgyYL6viz/QDqQNlfawIelf/W2xSqOqBf2QINBC8ldL4He1Sb/XYzYAfH1G3323DMfB0KExBSMUrqb1uu7LHPFy/4R5H0hEjgE+BksrxT6uQ0wsW6e7d8qsr8jB8eR3qhGiD5Zd/Nmnc57xmG1koN0YZK/PnV8g9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b6aCiRzy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b6aCiRzy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 143D814BF;
	Fri, 16 Oct 2026 04:50:27 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11CB43F673;
	Fri, 16 Oct 2026 04:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792151430; bh=7eDJICq300beGRALQlJrXpadKotDns99R6Gkf0Dn3K0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b6aCiRzyo8Ricc4Cu/UQrCIx5RdmoRJA/N8urMfg+lfcww7o1ATQzA3vnzny9Vd/i
	 hrA3iQrIfOQolHhNl9JwGaP9OkclDKp64NhP5DggjXbIY6GSq+HFlhxbrD9Q3AHUjU
	 9sPBj8fWR3ig8Cr3FOOmD7yCEQUB1lrFmjLZrJ+E=
Date: Fri, 16 Oct 2026 12:50:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>,
	Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Kohei Enju <enju.kohei@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for
 FUJITSU-MONAKA Erratum E#030001
Message-ID: <atIPeT7SLSLjQIcl@J2N7QTR9R3.cambridge.arm.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>

On Fri, Oct 16, 2026 at 07:00:46PM +0900, Tomohiro Misono wrote:
> FUJITSU-MONAKA Erratum E#030001 affects FUJITSU-MONAKA CPU
> when using TLBI range operations.
> 
> On affected FUJITSU-MONAKA CPUs, range-based TLBI operations
> targeting a VA or IPA may fail to invalidate TLB entries when
> addr[34:29] == all 1 && addr[28:0] == 0 for 512MB mappings.
> The affected instructions are:
>   RVA[L]E{1,2,3}*, RVAA[L]E1*, and RIPAS2[L]E1*.
> 
> Work around the erratum by issuing additional non-range
> TLBI instructions corresponding to the affected VA or IPA
> range-based TLBI operations.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>

As Will and I suggested last time, we'd prefer to disable range
operations on these parts (and ensure that the relevant ID field is
hidden from KVM guests).

Regardless of whether eventually accept the approach you propose here,
we first need something simple to backport to stable trees (as I assume
you'll want to run standard Linux distributions on this hardware). The
TLB invalidation code has changed a lot over time, and I don't think
it's practical or sensible to backport this patch.

As a first step, I think we should simply disable the use of range
operations on these parts, and ensure that KVM hides the relevant ID
field. After that, we can consider optimizing the workaround, as you
propose here.

Marc, does that align with your expectations? Is there an existing
pattern to follow for hiding the ID field?

Mark.

> 
> ---
> Changes in v2:
>  - remove page size restrictions as this errata affects both S1 and S2 tables
>  - use __always_inline instead of inline
>  - call workaround from NV TLBI operations too (comment by sashiko)
>   - TODO: test using NV
> ---
> ---
>  Documentation/arch/arm64/silicon-errata.rst |  2 ++
>  arch/arm64/Kconfig                          | 19 +++++++++++++
>  arch/arm64/include/asm/cpucaps.h            |  2 ++
>  arch/arm64/include/asm/tlbflush.h           | 35 +++++++++++++++++++++++
>  arch/arm64/kernel/cpu_errata.c              | 10 +++++++
>  arch/arm64/kvm/hyp/vhe/tlb.c                | 44 +++++++++++++++++++++++++++++
>  arch/arm64/tools/cpucaps                    |  1 +
>  7 files changed, 113 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index 99a1eb4b833dd..527af20b26468 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -375,6 +375,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| Fujitsu        | MONAKA          | E#030001        | FUJITSU_ERRATUM_030001      |
> ++----------------+-----------------+-----------------+-----------------------------+
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ASR            | ASR8601         | #8601001        | N/A                         |
>  +----------------+-----------------+-----------------+-----------------------------+
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index cab741a695f52..5d1a17ab0f593 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1342,6 +1342,25 @@ config FUJITSU_ERRATUM_010001
>  
>  	  If unsure, say Y.
>  
> +config FUJITSU_ERRATUM_030001
> +	bool "FUJITSU-MONAKA erratum E#030001: Range TLBI may fail to invalidate some entries"
> +	default y
> +	help
> +	  This option adds a workaround for FUJITSU-MONAKA erratum E#030001.
> +	  On affected FUJITSU-MONAKA CPUs, range-based TLBI operation
> +	  targeting a VA or IPA may fail to invalidate some TLB entries
> +	  when hugepage is used in a certain condition. The affected
> +	  instructions are RVA[L]E{1,2,3}*, RVAA[L]E1*, and RIPAS2[L]E1*
> +	  and this affects on both S1 and S2 tables.
> +
> +	  Work around the erratum by issuing additional non-range TLBI
> +	  instructions corresponding to the affected VA or IPA range-based
> +	  TLBI operations.
> +
> +	  The erratum only affects the FUJITSU-MONAKA.
> +
> +	  If unsure, say Y.
> +
>  config HISILICON_ERRATUM_161600802
>  	bool "Hip07 161600802: Erroneous redistributor VLPI base"
>  	default y
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 76350b38f0d7a..9220b917ec207 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -66,6 +66,8 @@ cpucap_is_possible(const unsigned int cap)
>  		return IS_ENABLED(CONFIG_ARM64_ERRATUM_3194386);
>  	case ARM64_WORKAROUND_4193714:
>  		return IS_ENABLED(CONFIG_ARM64_ERRATUM_4193714);
> +	case ARM64_WORKAROUND_FUJITSU_030001:
> +		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030001);
>  	case ARM64_MPAM:
>  		/*
>  		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 14a78ac0f8009..2636c273b8111 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -487,6 +487,39 @@ static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
>  	op(arg);
>  }
>  
> +#ifdef CONFIG_FUJITSU_ERRATUM_030001
> +static __always_inline void fujitsu_erratum_wa(tlbi_op lop, u64 start, u64 end, u16 asid)
> +{
> +	u64 addr;
> +
> +	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_FUJITSU_030001))
> +		return;
> +
> +	/*
> +	 * The erratum fails to invalidate TLBI entries in the range when
> +	 * addr[34:29] == all 1 && addr[28:0] == all 0 for 512M hugepage.
> +	 * This affects both on S1 and S2 tables and 4k guest may be affected
> +	 * if host uses 64k page size. Therefore it cannot be determined
> +	 * reliably if the target entry is affected or not here. So, always
> +	 * assume hugepage is used.
> +	 * The workaround is to issue extra non-range TLBI ops corresponding
> +	 * to the affected VA or IPA range-based ops in the range.
> +	 */
> +	addr = (start & GENMASK_ULL(63, 35)) | GENMASK_ULL(34, 29);
> +	while (addr < end) {
> +		__tlbi_level_asid(lop, addr, TLBI_TTL_UNKNOWN, asid);
> +		if (addr + BIT_ULL(35) < addr)
> +			/* overflow */
> +			break;
> +		addr += BIT_ULL(35);
> +	}
> +}
> +#else
> +static __always_inline void fujitsu_erratum_wa(tlbi_op lop, u64 start, u64 end, u16 asid)
> +{
> +}
> +#endif /* CONFIG_FUJITSU_ERRATUM_030001 */
> +
>  static __always_inline void __flush_tlb_range_op(tlbi_op lop, tlbi_op rop,
>  						 u64 start, size_t pages,
>  						 u64 stride, u16 asid,
> @@ -518,6 +551,8 @@ static __always_inline void __flush_tlb_range_op(tlbi_op lop, tlbi_op rop,
>  		__tlbi_level_asid(lop, addr, level, asid);
>  		addr += stride;
>  	}
> +
> +	fujitsu_erratum_wa(lop, start, end, asid);
>  }
>  
>  #define __flush_s1_tlb_range_op(op, start, pages, stride, asid, tlb_level) \
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index e0c09402540ce..a11135f83e858 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -1039,6 +1039,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		.matches = has_impdef_pmuv3,
>  		.cpu_enable = cpu_enable_impdef_pmuv3_traps,
>  	},
> +#ifdef CONFIG_FUJITSU_ERRATUM_030001
> +	{
> +		.desc = "FUJITSU-MONAKA Erratum E#030001",
> +		.capability = ARM64_WORKAROUND_FUJITSU_030001,
> +		ERRATA_MIDR_RANGE_LIST(((const struct midr_range[]) {
> +					MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
> +					{}
> +				})),
> +	},
> +#endif
>  	{
>  		.desc = "Known broken GICv3 SEIS implementation",
>  		.capability = ARM64_WORKAROUND_GICv3_BROKEN_SEIS,
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index c386d9f1c1016..2f1a7fab5eb97 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -8,6 +8,7 @@
>  
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/tlbflush.h>
>  
>  struct tlb_inv_context {
> @@ -218,6 +219,45 @@ void __kvm_flush_vm_context(void)
>  	__tlbi_sync_s1ish_hyp();
>  }
>  
> +#ifdef CONFIG_FUJITSU_ERRATUM_030001
> +static __always_inline void __vae1is(u64 arg)
> +{
> +	__tlbi(vae1is, arg);
> +}
> +static __always_inline void __vale1is(u64 arg)
> +{
> +	__tlbi(vale1is, arg);
> +}
> +static __always_inline void __vaae1is(u64 arg)
> +{
> +	__tlbi(vaae1is, arg);
> +}
> +static __always_inline void __fujitsu_erratum_wa(tlbi_op op, u64 va)
> +{
> +	u64 start, size;
> +	u16 asid;
> +
> +	if (!alternative_has_cap_unlikely(ARM64_WORKAROUND_FUJITSU_030001))
> +		return;
> +
> +	start = decode_range_tlbi(va, &size, &asid);
> +	fujitsu_erratum_wa(op, start, start + size, asid);
> +}
> +#else
> +static __always_inline void __vae1is(u64 arg)
> +{
> +}
> +static __always_inline void __vale1is(u64 arg)
> +{
> +}
> +static __always_inline void __vaae1is(u64 arg)
> +{
> +}
> +static __always_inline void __fujitsu_erratum_wa(tlbi_op op, u64 va)
> +{
> +}
> +#endif
> +
>  /*
>   * TLB invalidation emulation for NV. For any given instruction, we
>   * perform the following transformtions:
> @@ -322,6 +362,7 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
>  	case OP_TLBI_RVAE1ISNXS:
>  	case OP_TLBI_RVAE1OSNXS:
>  		__tlbi(rvae1is, va);
> +		__fujitsu_erratum_wa(__vae1is, va);
>  		break;
>  	case OP_TLBI_RVALE2:
>  	case OP_TLBI_RVALE2IS:
> @@ -336,6 +377,7 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
>  	case OP_TLBI_RVALE1ISNXS:
>  	case OP_TLBI_RVALE1OSNXS:
>  		__tlbi(rvale1is, va);
> +		__fujitsu_erratum_wa(__vale1is, va);
>  		break;
>  	case OP_TLBI_RVAAE1:
>  	case OP_TLBI_RVAAE1IS:
> @@ -344,6 +386,7 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
>  	case OP_TLBI_RVAAE1ISNXS:
>  	case OP_TLBI_RVAAE1OSNXS:
>  		__tlbi(rvaae1is, va);
> +		__fujitsu_erratum_wa(__vaae1is, va);
>  		break;
>  	case OP_TLBI_RVAALE1:
>  	case OP_TLBI_RVAALE1IS:
> @@ -352,6 +395,7 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
>  	case OP_TLBI_RVAALE1ISNXS:
>  	case OP_TLBI_RVAALE1OSNXS:
>  		__tlbi(rvaale1is, va);
> +		__fujitsu_erratum_wa(vaale1is, va);
>  		break;
>  	default:
>  		ret = -EINVAL;
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 58b6c084f9f25..1e57a0105395b 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -132,3 +132,4 @@ WORKAROUND_SPECULATIVE_AT
>  WORKAROUND_SPECULATIVE_SSBS
>  WORKAROUND_SPECULATIVE_UNPRIV_LOAD
>  WORKAROUND_BROKEN_AMU_CONSTCNT
> +WORKAROUND_FUJITSU_030001
> 
> -- 
> 2.43.0
> 
