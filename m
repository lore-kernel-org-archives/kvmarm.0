Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2B6318140
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 16:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774456460; cv=none; b=q0EzIfEmESgo7YPqQY2QUcwA8WeyPVrQp4DF5/cp02vwyhpsjztk1MSsQsFRnTZ8tDYZ+Cs6QZcMhUnuWB9IYeSsK0SYUhlFsD4FdNcJ9tMSTVX2GPb8uvLEp4IndhAuOFADdfFCFfJ+XyI8GgpJEJSiKgGK9BqdiEt39tI7akA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774456460; c=relaxed/simple;
	bh=Uzh2VRzviP7yTPZpv9Thn4meE6ETj/ysuIr/VejhzOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SMO3mn5ZTggM+sIGPaDtxVK8hmyZdnJEcDCrkfx2TxtdDEPVpzFedFDH/3D41xE32OouSsnOC/opyH2sHg/s+EHiTNo9P9ZC82XEx68Sv9WYgC6TamTdyZ0ym6B5VETGDYWaYAAN5VW9DESa7VrRs1+9AeFFJc6xd4uDGdH4ug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=veRuyfiN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="veRuyfiN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F9C71F02;
	Wed, 25 Mar 2026 09:34:02 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4F923F915;
	Wed, 25 Mar 2026 09:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774456448; bh=Uzh2VRzviP7yTPZpv9Thn4meE6ETj/ysuIr/VejhzOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=veRuyfiNHKtiJfNHSrxSI0R4IJgwC7Rpr3qLlHzXYbTxAkJM7dF4ySwn/3AlT1Q8M
	 UyjGD63OXuacn+Xn10VVWof9ySUcrelMANe07EuqguASnXKa5wpprVkdO7esea0gRo
	 fCI0ggXcu/dmKP4759MGhcSi4F6WIdoboFm7WYLU=
Date: Wed, 25 Mar 2026 16:34:02 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Yabin Cui <yabinc@google.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Disable SPE Profiling Buffer when
 running in guest context
Message-ID: <acQOekvkIUxj3jYU@raptor>
References: <20260227212136.7660-1-will@kernel.org>
 <20260227212136.7660-3-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227212136.7660-3-will@kernel.org>

Hi Will,

The patch looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Also tested the series for about 24h on an Orion O6 board with SPE enabled by
profiling two host processes spread across all CPUs with SPE, and at the same
time profiling a virtual machine with the VCPUs simiarly spread across the CPUs
with SPE:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Fri, Feb 27, 2026 at 09:21:34PM +0000, Will Deacon wrote:
> The nVHE world-switch code relies on zeroing PMSCR_EL1 to disable
> profiling data generation in guest context when SPE is in use by the
> host.
> 
> Unfortunately, this may leave PMBLIMITR_EL1.E set and consequently we
> can end up running in guest/hypervisor context with the Profiling Buffer
> enabled. The current "known issues" document for Rev M.a of the Arm ARM
> states that this can lead to speculative, out-of-context translations:
> 
>   | 2.18 D23136:
>   |
>   | When the Profiling Buffer is enabled, profiling is not stopped, and
>   | Discard mode is not enabled, the Statistical Profiling Unit might
>   | cause speculative translations for the owning translation regime,
>   | including when the owning translation regime is out-of-context.
> 
> In a similar fashion to TRBE, ensure that the Profiling Buffer is
> disabled during the nVHE world switch before we start messing with the
> stage-2 MMU and trap configuration.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Fixes: f85279b4bd48 ("arm64: KVM: Save/restore the host SPE state when entering/leaving a VM")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h  |  1 +
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 33 ++++++++++++++++++++----------
>  arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
>  3 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1532ad2b2ec2..d527c77977dd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -768,6 +768,7 @@ struct kvm_host_data {
>  		struct kvm_guest_debug_arch regs;
>  		/* Statistical profiling extension */
>  		u64 pmscr_el1;
> +		u64 pmblimitr_el1;
>  		/* Self-hosted trace */
>  		u64 trfcr_el1;
>  		u64 trblimitr_el1;
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 3dbdee1148d3..75158a9cd06a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -14,20 +14,20 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> -static void __debug_save_spe(u64 *pmscr_el1)
> +static void __debug_save_spe(void)
>  {
> -	u64 reg;
> +	u64 *pmscr_el1, *pmblimitr_el1;
>  
> -	/* Clear pmscr in case of early return */
> -	*pmscr_el1 = 0;
> +	pmscr_el1 = host_data_ptr(host_debug_state.pmscr_el1);
> +	pmblimitr_el1 = host_data_ptr(host_debug_state.pmblimitr_el1);
>  
>  	/*
>  	 * At this point, we know that this CPU implements
>  	 * SPE and is available to the host.
>  	 * Check if the host is actually using it ?
>  	 */
> -	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
> -	if (!(reg & BIT(PMBLIMITR_EL1_E_SHIFT)))
> +	*pmblimitr_el1 = read_sysreg_s(SYS_PMBLIMITR_EL1);
> +	if (!(*pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
>  		return;
>  
>  	/* Yes; save the control register and disable data generation */
> @@ -37,18 +37,29 @@ static void __debug_save_spe(u64 *pmscr_el1)
>  
>  	/* Now drain all buffered data to memory */
>  	psb_csync();
> +	dsb(nsh);
> +
> +	/* And disable the profiling buffer */
> +	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> +	isb();
>  }
>  
> -static void __debug_restore_spe(u64 pmscr_el1)
> +static void __debug_restore_spe(void)
>  {
> -	if (!pmscr_el1)
> +	u64 pmblimitr_el1 = *host_data_ptr(host_debug_state.pmblimitr_el1);
> +
> +	if (!(pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
>  		return;
>  
>  	/* The host page table is installed, but not yet synchronised */
>  	isb();
>  
> +	/* Re-enable the profiling buffer. */
> +	write_sysreg_s(pmblimitr_el1, SYS_PMBLIMITR_EL1);
> +	isb();
> +
>  	/* Re-enable data generation */
> -	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
> +	write_sysreg_el1(*host_data_ptr(host_debug_state.pmscr_el1), SYS_PMSCR);
>  }
>  
>  static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
> @@ -177,7 +188,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	/* Disable and flush SPE data generation */
>  	if (host_data_test_flag(HAS_SPE))
> -		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
> +		__debug_save_spe();
>  
>  	/* Disable BRBE branch records */
>  	if (host_data_test_flag(HAS_BRBE))
> @@ -195,7 +206,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>  void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	if (host_data_test_flag(HAS_SPE))
> -		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
> +		__debug_restore_spe();
>  	if (host_data_test_flag(HAS_BRBE))
>  		__debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
>  	if (__trace_needs_switch())
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f00688e69d88..9b6e87dac3b9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -278,7 +278,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * We're about to restore some new MMU state. Make sure
>  	 * ongoing page-table walks that have started before we
>  	 * trapped to EL2 have completed. This also synchronises the
> -	 * above disabling of BRBE and SPE.
> +	 * above disabling of BRBE.
>  	 *
>  	 * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
>  	 * rule R_LFHQG and subsequent information statements.
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 
