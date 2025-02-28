Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1B52594B7
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736580; cv=none; b=JGEWWAjC081mlJmPHnqIjIIrSJYUcd+xb0R0QfR7J0DwABZrUJgO/O+PmgQJg5APnp18+bpcStCe5BCIhv8OWWXOzumMCbTFws2Husj4v1TTC7oeszkiGhpyo1y0QrXi5XzRgpJAFeiZRJeFZhl5Ii+zaQcIu7o/SQTSHw/1qlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736580; c=relaxed/simple;
	bh=sxEMEK/fLAyGnNxuTuhzNWuMZmb8rbboe40TJW456hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qh/HPlHyu0j9L2yxW1Rrg0CgAcaw+8RTZXHvtSqXOKafRsvBWpSeVwtJLNxgcAkbh3ajJuLDKTj31aHOyS4TaKUukokvLMdJwbsEc4Uf4hl0X9axF6W+IvCNZR5hipNbsdtBXaOFokzhCnzrQOeaK45nycmtzQP2UDS6ZQTUc2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43BE11515;
	Fri, 28 Feb 2025 01:56:33 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98CA03F6A8;
	Fri, 28 Feb 2025 01:56:17 -0800 (PST)
Date: Fri, 28 Feb 2025 09:56:13 +0000
From: Leo Yan <leo.yan@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ahmed.genidi@arm.com,
	ben.horgan@arm.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Initialize SCTLR_EL1 in
 __kvm_hyp_init_cpu()
Message-ID: <20250228095613.GD2157064@e132581.arm.com>
References: <20250227180526.1204723-1-mark.rutland@arm.com>
 <20250227180526.1204723-3-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227180526.1204723-3-mark.rutland@arm.com>

On Thu, Feb 27, 2025 at 06:05:26PM +0000, Mark Rutland wrote:
> From: Ahmed Genidi <ahmed.genidi@arm.com>
> 
> When KVM is in protected mode, host calls to PSCI are proxied via EL2,
> and cold entries from CPU_ON, CPU_SUSPEND, and SYSTEM_SUSPEND bounce
> through __kvm_hyp_init_cpu() at EL2 before entering the host kernel's
> entry point at EL1. While __kvm_hyp_init_cpu() initializes SPSR_EL2 for
> the exception return to EL1, it does not initialize SCTLR_EL1.
> 
> Due to this, it's possible to enter EL1 with SCTLR_EL1 in an UNKNOWN
> state. In practice this has been seen to result in kernel crashes after
> CPU_ON as a result of SCTLR_EL1.M being 1 in violation of the initial
> core configuration specified by PSCI.
> 
> Fix this by initializing SCTLR_EL1 for cold entry to the host kernel.
> As it's necessary to write to SCTLR_EL12 in VHE mode, this
> initialization is moved into __kvm_host_psci_cpu_entry() where we can
> use write_sysreg_el1().
> 
> The remnants of the '__init_el2_nvhe_prepare_eret' macro are folded into
> its only caller, as this is clearer than having the macro.
> 
> Fixes: cdf367192766ad11 ("KVM: arm64: Intercept host's CPU_ON SMCs")
> Reported-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: Ahmed Genidi <ahmed.genidi@arm.com>
> [ Mark: clarify commit message, handle E2H, move to C, remove macro ]
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>

Reviewed-by: Leo Yan <leo.yan@arm.com>

> Cc: Ahmed Genidi <ahmed.genidi@arm.com>
> Cc: Ben Horgan <ben.horgan@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/el2_setup.h   | 5 -----
>  arch/arm64/kernel/head.S             | 3 ++-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 2 --
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c | 3 +++
>  4 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index bc8ebd55788ac..7774aec91027e 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -270,11 +270,6 @@
>  .Lskip_gcs_\@:
>  .endm
>  
> -.macro __init_el2_nvhe_prepare_eret
> -	mov	x0, #INIT_PSTATE_EL1
> -	msr	spsr_el2, x0
> -.endm
> -
>  .macro __init_el2_mpam
>  	/* Memory Partitioning And Monitoring: disable EL2 traps */
>  	mrs	x1, id_aa64pfr0_el1
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 2d56459d6c94c..2ce73525de2c9 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -322,7 +322,8 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
>  	msr	sctlr_el1, x1
>  	mov	x2, xzr
>  3:
> -	__init_el2_nvhe_prepare_eret
> +	mov	x0, #INIT_PSTATE_EL1
> +	msr	spsr_el2, x0
>  
>  	mov	w0, #BOOT_CPU_MODE_EL2
>  	orr	x0, x0, x2
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 3fb5504a7d7fc..f8af11189572f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -214,8 +214,6 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
>  
>  	bl	__kvm_init_el2_state
>  
> -	__init_el2_nvhe_prepare_eret
> -
>  	/* Enable MMU, set vectors and stack. */
>  	mov	x0, x28
>  	bl	___kvm_hyp_init			// Clobbers x0..x2
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> index 9c2ce1e0e99a5..c3e196fb8b18f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> +++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
> @@ -218,6 +218,9 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
>  	if (is_cpu_on)
>  		release_boot_args(boot_args);
>  
> +	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
> +	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
> +
>  	__host_enter(host_ctxt);
>  }
>  
> -- 
> 2.30.2
> 
