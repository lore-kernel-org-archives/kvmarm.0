Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897522;
	b=PpHXfQ/noBG/8ICZHAUs2WmADeRo4iFB83bWLEsRpz6n/IZZpQmAiHfUnCWysjN57hsa
	 z6n9hp/FVTpvBu4I3OC3LEqrD4kYsm9s4B2ZlS2KBSEnBoTXtouiecVnHXNSPj/mqi6rr
	 mchtcyU4jTU9NAA4xNI9UwsUA4jfSSU+tDVg6kjQVCh4/280ogWP/UtDWVNVyZs/HSWIa
	 5/i15TX3klGp750r9o+AdCDEGgzW6QMabJ8jS033JHwDumsGKuvbUrsIcfZQ/n4l1M6bx
	 4S4wJVzZuAgEmT2Tbg6OIt/ie1qBqkrWY5UBjuHucNJRvnnf79bx1mLCsqLp0mUZ/hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897522;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3dCADcgaA1jIVzURXy3sRrPfhp4fyMV+LhaMMwvBEQw=;
	b=EJ8cbZIPdNXDdMKMfs0jC9dSMLsdZDij67x1HmzMEauJKC9pcD48wWQ+ua4WgYjzTJL+
	 uT3uKa+0szzunyd9V1t6HsqSvVb5bkXFyequYNrRA3v8EgnaHGAQ/unPqnMGjTHMV3+TT
	 ioxThyOSYwdMed1KOOdLSezPiW6OI2AaJLVL6Xkbb7NUtXMSp3I1KJtcQfrkLqorIOo9h
	 iFaT5JUgFZobmlnd9BfUlMIaitR8w8Cwel4eAW/ZOWrZv9h13jjVOMjGRoUMut9FgFPXO
	 ngLlz7DfSFuo2+HkyQ7RuQc5Ojtzsvq7q8HqtUcQpu4oMoO0KpOG+T2J0uSckfSaEBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NqfhD32d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0D7606A328;
	Thu,  5 Nov 2026 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NqfhD32d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87761F000C1;
	Thu,  5 Nov 2026 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897521;
	bh=3dCADcgaA1jIVzURXy3sRrPfhp4fyMV+LhaMMwvBEQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NqfhD32dCFfrw2csPCJ6yGKDGHdP+sCPkT6q1r/bS6MIIgVQMKkHfW4300nYbI382
	 CYBZ0u/fxhLo00Y7apBct++/jVWc3TTPnu3+EkPFd+tKxdWZcK24Ap/J+QDLfkgyiH
	 BrjeKHwIcN+lutEnp7Xpw5YHdP46PbCpaiF/tqZ2cVWbCQCToM+5mn/uoQ8b8aS+Xe
	 wiU4UfZ8fqYQAl79bN3QP7DOz+NiMQ5OVan5MaC8LTyjQ22SCrzmZ5VuTutHOTEfSu
	 K+y7784JvFi0ARKfu7S8eTt+fEzvaaFB9joWyJ5skwnSjvxorj7L8QpLTW2EyNvBtl
	 BWwD0oF9eD3fA==
Date: Thu, 5 Nov 2026 16:51:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 24/28] arm64: errata: Don't enable guest buffer if
 misprogrammed
Message-ID: <auypUBq_eddze2zu@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-25-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-25-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:19PM +0100, Alexandru Elisei wrote:
> When PMBPTR_EL1 is programmed to be equal to or greater than
> PMBLIMITR_EL1.Limit, SPE is enabled and PMBSR_EL1.S is zero, the CPU might
> deadlock.
>
> This doesn't affect correctly written software, like the SPE driver, but a
> buggy KVM guest might trigger the erratum. The workaround for KVM is not to
> enable the hardware buffer, and, as a consequence, profiling. According
> to ARM DDI0487M.c, rule R_PGGHS, this is one of the acceptable
> behaviours when the buffer is misprogrammed.

What about buffer management events? Will the guest not see anything + then
not know why?

Maybe worth raising an event for that, though perhaps reasonable not to,
worth saying here what the trade-off is though.

>
> Several parts are affected:
>
> * ARM Neoverse-N1 (MP050), SDEN v35, erratum 1978083
>   https://support.arm.com/documentation/SDEN-885747/35-0
> * ARM Neoverse-V1 (MP076), SDEN v23, erratum 1978082
>   https://support.arm.com/documentation/SDEN-1401781/23-0
> * ARM Cortex-X1 (MP077), SDEN v25, erratum 2004055
>   https://support.arm.com/documentation/SDEN-1401782/25-0
> * ARM Cortex-X1C (MP136), SDEN v20, erratum 2004056
>   https://support.arm.com/documentation/SDEN-1707914/20-0
> * ARM Cortex-A78 (MP102), SDEN v25, erratum 2004055
>   https://support.arm.com/documentation/SDEN-1401784/25-0
> * ARM Cortex-A78AE (MP105), SDEN v22, erratum 2004059
>   https://support.arm.com/documentation/SDEN-1707912/22-0
> * ARM Cortex-A78C (MP138), SDEN v20, erratum 2004056
>   https://support.arm.com/documentation/SDEN-1707916/20-0
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

In general I think we can radically simplify the code + remove the
arm_spe_pmu->has_workaround_2004055 and kvm_vcpu_spe->buffer_misprogrammed
fields, and just figure this out programatically:

	static bool __kvm_spe_buffer_misprogrammed(u64 pmblimitr, u64 pmbptr)
	{
		if (!cpus_have_final_cap(ARM64_WORKAROUND_2004055))
			return false;

		return pmbptr >= (pmblimitr & PMBLIMITR_EL1_LIMIT);
	}


Then call this from __kvm_spe_profiling_buffer_enabled(), like:

static bool __kvm_spe_profiling_buffer_enabled(u64 pmblimitr, u64 pmbsr,
					       u64 pmbptr)
{
	if (!FIELD_GET(PMBLIMITR_EL1_E, pmblimitr) ||
	    FIELD_GET(PMBSR_EL1_S, pmbsr))
		return false;

	return !__kvm_spe_buffer_misprogrammed(pmblimitr, pmbptr);
}

With pmbptr passed as ctxt_sys_reg(guest_ctxt, PMBPTR_EL1).

> ---
>  Documentation/arch/arm64/silicon-errata.rst | 14 +++++++++++
>  arch/arm64/Kconfig                          | 25 ++++++++++++++++++++
>  arch/arm64/include/asm/kvm_spe.h            |  1 +
>  arch/arm64/kernel/cpu_errata.c              | 26 +++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/spe-sr.c             |  6 +++--
>  arch/arm64/kvm/spe.c                        | 22 +++++++++++++++++
>  arch/arm64/tools/cpucaps                    |  1 +
>  drivers/perf/arm_spe_pmu.c                  |  3 +++
>  include/linux/perf/arm_spe_pmu.h            |  1 +
>  9 files changed, 97 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index a29f8fbc16a8..a5477cae7d70 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -151,10 +151,14 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A78      | #3031174        | ARM64_ERRATUM_3023823       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A78      | #2004055        | ARM64_ERRATUM_2004055       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A78AE    | #4193793        | ARM64_ERRATUM_4118414       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A78AE    | #3031175        | ARM64_ERRATUM_3023823       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A78AE    | #2004059        | ARM64_ERRATUM_2004055       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A78C     | #3324346,       | ARM64_ERRATUM_3194386       |
>  |                |                 | #3324347        |                             |
>  +----------------+-----------------+-----------------+-----------------------------+
> @@ -163,6 +167,8 @@ stable kernels.
>  | ARM            | Cortex-A78C     | #3031176,       | ARM64_ERRATUM_3023823       |
>  |                |                 | #3031177        |                             |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A78C     | #2004056        | ARM64_ERRATUM_2004055       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
> @@ -189,12 +195,16 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-X1       | #3031174        | ARM64_ERRATUM_3023823       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-X1       | #2004055        | ARM64_ERRATUM_2004055       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-X1C      | #3324346        | ARM64_ERRATUM_3194386       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-X1C      | #4193792        | ARM64_ERRATUM_4118414       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-X1C      | #3031176        | ARM64_ERRATUM_3023823       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-X1C      | #2004056        | ARM64_ERRATUM_2004055       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-X2       | #2119858        | ARM64_ERRATUM_2119858       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-X2       | #2224489        | ARM64_ERRATUM_2224489       |
> @@ -233,6 +243,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N1     | #3023823        | ARM64_ERRATUM_3023823       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Neoverse-N1     | #1978083        | ARM64_ERRATUM_2004055       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N2     | #2139208        | ARM64_ERRATUM_2139208       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N2     | #2067961        | ARM64_ERRATUM_2067961       |
> @@ -255,6 +267,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-V1     | #3028884        | ARM64_ERRATUM_3023823       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Neoverse-V1     | #1978082        | ARM64_ERRATUM_2004055       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-V2     | #3324336        | ARM64_ERRATUM_3194386       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-V2     | #4193787        | ARM64_ERRATUM_4118414       |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index ca6759d16d27..d9b27ee90ab5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1494,6 +1494,31 @@ config ARM64_ERRATUM_3023823
>
>  	  If unsure, say Y.
>
> +config ARM64_ERRATUM_2004055
> +	bool "Incorrect programming of PMBPTR_EL1 might result in a deadlock"
> +	depends on KVM_ARM_SPE
> +	default y
> +	help
> +	  This option adds a workaround for the following errata:
> +
> +	  * ARM Neoverse-N1 erratum 1978083
> +	  * ARM Neoverse-V1 erratum 1978082
> +	  * ARM Cortex-X1 erratum 2004055
> +	  * ARM Cortex-X1C erratum 2004056
> +	  * ARM Cortex-A78 erratum 2004055
> +	  * ARM Cortex-A78AE erratum 2004059
> +	  * ARM Cortex-A78C errata 2004056

NIT: errata -> erratum :)

> +
> +	  When PMBPTR_EL1 is programmed to be equal to or greater than
> +	  PMBLIMITR_EL1.Limit, SPE is enabled and PMBSR_EL1.S is zero, the CPU
> +	  might deadlock.
> +
> +	  The work around is for KVM to behave as if profiling is disabled when
> +	  the buffer is enabled, PMSBSR_EL1.S is zero and
> +	  PMBPTR_EL1.PTR >= PMBLIMITR_EL1.Limit.
> +
> +	  If unsure, say Y.
> +
>  endmenu # "ARM errata workarounds via the alternatives framework"
>
>  choice
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 385b1157e578..88f8b1bb6864 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -23,6 +23,7 @@ struct kvm_vcpu_spe {
>  	int irq_num;		/* Buffer management interrupt number */
>  	bool initialized;	/* SPE initialized for the VCPU */
>  	bool irq_level;		/* Virtual buffer management interrupt level */
> +	bool buffer_misprogrammed;

Obviously with the simplification this can be removed.

>  };
>
>  bool kvm_supports_spe(void);
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index ab0558fbd5b2..0b9620893763 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -648,6 +648,25 @@ static const struct midr_range erratum_3023823_list[] = {
>  };
>  #endif
>
> +#ifdef CONFIG_ARM64_ERRATUM_2004055
> +static const struct midr_range erratum_2004055_list[] = {
> +	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
> +	/* Neoverse-V1 r0p0 to r1p1 */
> +	MIDR_RANGE(MIDR_NEOVERSE_V1, 0, 0, 1, 1),
> +	/* Cortex-X1 r0p0 to r1p1 */
> +	MIDR_RANGE(MIDR_CORTEX_X1, 0, 0, 1, 1),
> +	/* Cortex-X1 r0p0 */

NIT: shouldn't this be Cortex-X1C?

> +	MIDR_REV(MIDR_CORTEX_X1C, 0, 0),
> +	/* Cortex-A78 r0p0 to r1p1 */
> +	MIDR_RANGE(MIDR_CORTEX_A78, 0, 0, 1, 1),
> +	/* Cortex-A78 r0p0 to r1p1 */

Also here should be A78AE I think?

> +	MIDR_RANGE(MIDR_CORTEX_A78AE, 0, 0, 0, 1),
> +	/* Cortex-A78C r0p0 */
> +	MIDR_REV(MIDR_CORTEX_A78C, 0, 0),
> +	{},
> +};
> +#endif
> +
>  #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
>  static const struct midr_range erratum_ac03_cpu_38_list[] = {
>  	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
> @@ -1012,6 +1031,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		ERRATA_MIDR_RANGE_LIST(erratum_3023823_list),
>  	},
>  #endif
> +#ifdef CONFIG_ARM64_ERRATUM_2004055
> +	{
> +		.desc = "Incorrect programming of PMBPTR_EL1 leads to deadlock",

The other entries are of the form 'ARM erratum xxx', shouldn't this follow
that convention?

> +		.capability = ARM64_WORKAROUND_2004055,
> +		ERRATA_MIDR_RANGE_LIST(erratum_2004055_list),
> +	},
> +#endif
>  #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
>  	{
>  		.desc = "ARM errata 2966298, 3117295",
> diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> index df35025db19a..ec991f4cc348 100644
> --- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> @@ -112,7 +112,8 @@ void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_con
>
>  	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
>  	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
> -	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr) &&
> +	    !vcpu->arch.vcpu_spe.buffer_misprogrammed) {

With the simplification this can go also.

>  		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
>  		isb();
>  		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
> @@ -150,7 +151,8 @@ void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_contex
>  	 * Update PMBPTR_EL1 and PMBSR_EL1 only if profiling was enabled
>  	 * when the guest state was resumed.
>  	 */
> -	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr) &&
> +	    !vcpu->arch.vcpu_spe.buffer_misprogrammed) {

With the simplification this can go also.

>  		psb_csync();
>  		dsb(nsh);
>  		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 3e82edc8be85..ef138562f939 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -170,6 +170,25 @@ u64 kvm_spe_reset_sysreg(struct kvm_vcpu *vcpu, int reg)
>  	return 0;
>  }
>
> +static void kvm_spe_apply_workaround_2004055(struct kvm_vcpu *vcpu)
> +{
> +	u64 pmblimitr_el1 = __vcpu_sys_reg(vcpu, PMBLIMITR_EL1);
> +	u64 pmbsr_el1 = __vcpu_sys_reg(vcpu, PMBSR_EL1);
> +	u64 ptr, limit;
> +
> +	if (FIELD_GET(PMBSR_EL1_S, pmbsr_el1) ||
> +	    !FIELD_GET(PMBLIMITR_EL1_E, pmblimitr_el1))
> +		return;
> +
> +	ptr = FIELD_GET(PMBPTR_EL1_PTR, __vcpu_sys_reg(vcpu, PMBPTR_EL1));
> +	limit = FIELD_GET(PMBLIMITR_EL1_LIMIT, pmblimitr_el1) << 12;
> +
> +	if (ptr >= limit)
> +		vcpu->arch.vcpu_spe.buffer_misprogrammed = true;
> +	else
> +		vcpu->arch.vcpu_spe.buffer_misprogrammed = false;
> +}

With the suggestion above, this can be removed.

> +
>  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  {
>  	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
> @@ -186,6 +205,9 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  		WARN_ON_ONCE("unexpected trap");
>  	}
>
> +	if (unlikely(kvm_spe->spe_pmu->has_workaround_2004055))
> +		kvm_spe_apply_workaround_2004055(vcpu);

Similarly this too :)

> +
>  	if (reg == PMBSR_EL1) {
>  		val = __vcpu_sys_reg(vcpu, PMBSR_EL1);
>  		kvm_spe_update_irq_level(vcpu, FIELD_GET(PMBSR_EL1_S, val));
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 5f997851b6d7..e001a6ea5564 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -133,3 +133,4 @@ WORKAROUND_SPECULATIVE_AT
>  WORKAROUND_SPECULATIVE_SSBS
>  WORKAROUND_SPECULATIVE_UNPRIV_LOAD
>  WORKAROUND_3023823
> +WORKAROUND_2004055

This is out of order with surrounding entries.

> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index 928ea94f2ed6..bca8cd3bca16 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -1201,6 +1201,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
>  	if (this_cpu_has_cap(ARM64_WORKAROUND_3023823))
>  		spe_pmu->has_workaround_3023823 = true;
>
> +	if (this_cpu_has_cap(ARM64_WORKAROUND_2004055))
> +		spe_pmu->has_workaround_2004055 = true;
> +

Obviously this can be removed with the simplification...

>  	dev_info(dev,
>  		 "probed SPEv1.%d for CPUs %*pbl [max_record_sz %u, align %u, features 0x%llx]\n",
>  		 spe_pmu->pmsver - 1, cpumask_pr_args(&spe_pmu->supported_cpus),
> diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> index edf58c51fb94..d5c510ebf785 100644
> --- a/include/linux/perf/arm_spe_pmu.h
> +++ b/include/linux/perf/arm_spe_pmu.h
> @@ -46,6 +46,7 @@ struct arm_spe_pmu {
>  	u16					align;
>  	struct perf_output_handle __percpu	*handle;
>  	bool					has_workaround_3023823;
> +	bool					has_workaround_2004055;

...and this :)

>  };
>
>  #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
