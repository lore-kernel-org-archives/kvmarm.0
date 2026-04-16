Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BCD233723
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 16:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776356212; cv=none; b=dqfQwPO8kvKRSz66lbouHuFmeVyIjAraHFE0aJs7CYDDNJRq0Sr+GrhboBMlqydESJ9+GwPwYGYmGg0VdmpObAlZcWiHNYONT6jFJjWd6kZlviubXTo2iQEmIJnErIZQHZhYTj2dAMk7zap/95tcpfPVnLhN7Q4VQr682tL3LQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776356212; c=relaxed/simple;
	bh=yvhH8OxsHLUDaxARkg1XTfEfs4wPv5MxzlacM/ruBc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlunDeFHl98I3FJZOP9eb4wmJ4Gbv1Gnx6/lQ48Rfhf0vjO5RELNJK2wu6helHWg4LGT/qWR9f8A9rz5AFrtmUBCl8ab8wO9Wy0kz2RzkDkWuJO4J1obogIXsjuBnloIKKiwfUjAHCGYyDVi9LNNCak4HduGHxMsziEmzFfZzaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BV0LL6CE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BV0LL6CE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A0CB165C;
	Thu, 16 Apr 2026 09:16:43 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B592F3FAF5;
	Thu, 16 Apr 2026 09:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776356208; bh=yvhH8OxsHLUDaxARkg1XTfEfs4wPv5MxzlacM/ruBc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BV0LL6CEDS+DifX2QJhI4sHQ/iRbq5A6/EvIaVyKICqeHOEhdC0MbjStn1DswksZ2
	 zOgUqL6lkqu4qNmeyQjioJbBsgPdTcjbN8ZTKPdWRAtIRp9UriyLJLXM+xjqnC/5Hb
	 Cp7tC3K2kV5ok7cYVgk4bSWvO+Bm9hm9wKSq7RPc=
Date: Thu, 16 Apr 2026 17:16:43 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mingwei Zhang <mizhang@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib: arm64: Add foundational guest
 execution framework
Message-ID: <20260416161643.GC3142999@e124191.cambridge.arm.com>
References: <20260413204630.1149038-1-jingzhangos@google.com>
 <20260413204630.1149038-5-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204630.1149038-5-jingzhangos@google.com>

Hi,

First-look comments below,

On Mon, Apr 13, 2026 at 01:46:27PM -0700, Jing Zhang wrote:
> Introduce the infrastructure to manage and execute guest when running
> at EL2. This provides the basis for testing advanced features like
> nested virtualization and GICv4 direct interrupt injection.
> 
> The framework includes:
> - 'struct guest': Encapsulates vCPU state (GPRs, EL1/EL2 sysregs) and
>   Stage-2 MMU context.
> - guest_create() / guest_destroy(): Handle lifecycle management and
>   Stage-2 MMU setup, including identity mappings for guest code,
>   stack, and UART.
> - guest_run(): Assembly entry point that saves host callee-saved
>   registers, caches the guest context pointer in TPIDR_EL2, and
>   performs the exception return (ERET) to the guest.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arm/Makefile.arm64      |  2 +
>  lib/arm64/asm-offsets.c | 13 ++++++
>  lib/arm64/asm/guest.h   | 46 +++++++++++++++++++++
>  lib/arm64/asm/sysreg.h  |  6 +++
>  lib/arm64/guest.c       | 89 +++++++++++++++++++++++++++++++++++++++++
>  lib/arm64/guest_arch.S  | 59 +++++++++++++++++++++++++++
>  6 files changed, 215 insertions(+)
>  create mode 100644 lib/arm64/asm/guest.h
>  create mode 100644 lib/arm64/guest.c
>  create mode 100644 lib/arm64/guest_arch.S
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 5e50f5ba..9026fd71 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -41,6 +41,8 @@ cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
>  cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
>  cflatobjs += lib/arm64/stage2_mmu.o
> +cflatobjs += lib/arm64/guest.o
> +cflatobjs += lib/arm64/guest_arch.o
>  
>  ifeq ($(CONFIG_EFI),y)
>  cflatobjs += lib/acpi.o
> diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
> index 80de023c..ceeecce5 100644
> --- a/lib/arm64/asm-offsets.c
> +++ b/lib/arm64/asm-offsets.c
> @@ -8,6 +8,7 @@
>  #include <libcflat.h>
>  #include <kbuild.h>
>  #include <asm/ptrace.h>
> +#include <asm/guest.h>
>  
>  int main(void)
>  {
> @@ -30,5 +31,17 @@ int main(void)
>  	DEFINE(S_FP, sizeof(struct pt_regs));
>  	DEFINE(S_FRAME_SIZE, (sizeof(struct pt_regs) + 16));
>  
> +	OFFSET(GUEST_X_OFFSET, guest, x);
> +	OFFSET(GUEST_ELR_OFFSET, guest, elr_el2);
> +	OFFSET(GUEST_SPSR_OFFSET, guest, spsr_el2);
> +	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
> +	OFFSET(GUEST_VTTBR_OFFSET, guest, vttbr_el2);
> +	OFFSET(GUEST_SCTLR_OFFSET, guest, sctlr_el1);
> +	OFFSET(GUEST_SP_EL1_OFFSET, guest, sp_el1);
> +	OFFSET(GUEST_ESR_OFFSET, guest, esr_el2);
> +	OFFSET(GUEST_FAR_OFFSET, guest, far_el2);
> +	OFFSET(GUEST_HPFAR_OFFSET, guest, hpfar_el2);
> +	OFFSET(GUEST_EXIT_CODE_OFFSET, guest, exit_code);
> +
>  	return 0;
>  }
> diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
> new file mode 100644
> index 00000000..826c44f8
> --- /dev/null
> +++ b/lib/arm64/asm/guest.h
> @@ -0,0 +1,46 @@
> +/*
> + * Copyright (C) 2026, Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#ifndef _ASMARM64_GUEST_H_
> +#define _ASMARM64_GUEST_H_
> +
> +#include <libcflat.h>
> +#include <asm/processor.h>
> +#include <asm/stage2_mmu.h>
> +
> +#define HCR_GUEST_FLAGS (HCR_EL2_VM | HCR_EL2_FMO | HCR_EL2_IMO | \
> +			 HCR_EL2_AMO | HCR_EL2_RW | HCR_EL2_E2H)
> +/* Guest stack size */
> +#define GUEST_STACK_SIZE		SZ_64K
> +
> +struct guest {
> +	/* General Purpose Registers */
> +	unsigned long x[31]; /* x0..x30 */
> +
> +	/* Execution State */
> +	unsigned long elr_el2;
> +	unsigned long spsr_el2;
> +
> +	/* Control Registers */
> +	unsigned long hcr_el2;
> +	unsigned long vttbr_el2;
> +	unsigned long sctlr_el1;
> +	unsigned long sp_el1;
> +
> +	/* Exit Information */
> +	unsigned long esr_el2;
> +	unsigned long far_el2;
> +	unsigned long hpfar_el2;
> +	unsigned long exit_code;
> +
> +	struct s2_mmu *s2mmu;
> +};
> +
> +struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2_granule granule);
> +void guest_destroy(struct guest *guest);
> +void guest_run(struct guest *guest);
> +
> +#endif /* _ASMARM64_GUEST_H_ */
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index f2d05018..857bee98 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -118,6 +118,10 @@ asm(
>  #define SCTLR_EL1_TCF0_SHIFT	38
>  #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
>  
> +#define HCR_EL2_VM		_BITULL(0)
> +#define HCR_EL2_FMO		_BITULL(3)
> +#define HCR_EL2_IMO		_BITULL(4)
> +#define HCR_EL2_AMO		_BITULL(5)
>  #define HCR_EL2_TGE		_BITULL(27)
>  #define HCR_EL2_RW		_BITULL(31)
>  #define HCR_EL2_E2H		_BITULL(34)
> @@ -132,6 +136,8 @@ asm(
>  #define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
>  #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
>  
> +#define SYS_SCTLR_EL1		sys_reg(3, 5, 1, 0, 0)

This isn't needed, the asm below can use `msr sctlr_el1` directly.

> +
>  #define INIT_SCTLR_EL1_MMU_OFF	\
>  			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
>  			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
> diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
> new file mode 100644
> index 00000000..68dd449d
> --- /dev/null
> +++ b/lib/arm64/guest.c
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright (C) 2026, Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#include <libcflat.h>
> +#include <asm/guest.h>
> +#include <asm/io.h>
> +#include <asm/sysreg.h>
> +#include <asm/barrier.h>
> +#include <alloc_page.h>
> +#include <alloc.h>
> +
> +static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
> +{
> +	struct guest *guest = calloc(1, sizeof(struct guest));

Missing check if `guest` is NULL.

> +
> +	guest->elr_el2 = (unsigned long)entry_point;
> +	guest->spsr_el2 = 0x3C5; /* M=EL1h, DAIF=Masked */

Check lib/arm64/asm/ptrace.h, we can build this with macros, PSR_MODE_EL1h etc.

> +	guest->hcr_el2 = HCR_GUEST_FLAGS;
> +
> +	if (s2_ctx) {
> +		guest->vttbr_el2 = virt_to_phys(s2_ctx->pgd);
> +		guest->vttbr_el2 |= ((unsigned long)s2_ctx->vmid << 48);

Maybe this should be extracted into a helper in stage2_mmu, to build vttbr.

> +	} else {
> +		printf("Stage 2 MMU context missing!");
> +	}

Can probably just assert(s2_ctx) instead of this conditional, don't think you
can use the guest without one?

> +
> +	guest->sctlr_el1 = read_sysreg(sctlr_el1);
> +	/* Disable guest stage 1 translation */
> +	guest->sctlr_el1 &= ~(SCTLR_EL1_M | SCTLR_EL1_C);
> +	guest->sctlr_el1 |= SCTLR_EL1_I;
> +
> +	guest->s2mmu = s2_ctx;
> +
> +	return guest;
> +}
> +
> +struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2_granule granule)
> +{
> +	unsigned long guest_pa, code_base, stack_pa;
> +	unsigned long *stack_page;
> +	struct guest *guest;
> +	struct s2_mmu *ctx;
> +
> +	ctx = s2mmu_init(vmid, granule, true);
> +	/*
> +	 * Map the Host's code segment Identity Mapped (IPA=PA).
> +	 * To be safe, we map a large chunk (e.g., 2MB) around the function
> +	 * to capture any helper functions the compiler might generate calls to.
> +	 */
> +	guest_pa = virt_to_phys((void *)guest_func);
> +	code_base = guest_pa & ~(SZ_2M - 1);
> +	s2mmu_map(ctx, code_base, code_base, SZ_2M, S2_MAP_RW);
> +
> +	/*
> +	 * Map Stack
> +	 * Allocate 16 pages (64K) in Host, get its PA, and map it for Guest.

It's not always 16 pages (depends on PAGE_SIZE), can just reword to say
`Allocate pages in Host..`

> +	 */
> +	stack_page = alloc_pages(get_order(GUEST_STACK_SIZE >> PAGE_SHIFT));
> +	stack_pa = virt_to_phys(stack_page);
> +	/* Identity Map it (IPA = PA) */
> +	s2mmu_map(ctx, stack_pa, stack_pa, GUEST_STACK_SIZE, S2_MAP_RW);
> +
> +	s2mmu_enable(ctx);
> +
> +	/* Create Guest */
> +	/* Entry point is the PA of the function (Identity Mapped) */
> +	guest = __guest_create(ctx, (void *)guest_pa);
> +
> +	/*
> +	 * Setup Guest Stack Pointer
> +	 * Must match where we mapped the stack + Offset
> +	 */
> +	guest->sp_el1 = stack_pa + GUEST_STACK_SIZE;
> +
> +	/* Map UART identity mapped, printf() available to guest */
> +	s2mmu_map(ctx, 0x09000000, 0x09000000, PAGE_SIZE, S2_MAP_DEVICE);

This is not portable.

> +
> +	return guest;
> +}

I'm actually not sure what I think of this function as a whole, maybe it does
too much and the caller should be expected to map stuff in. Different types of
tests could have different specific guest_create helpers.

> +
> +void guest_destroy(struct guest *guest)
> +{
> +	s2mmu_disable(guest->s2mmu);
> +	s2mmu_destroy(guest->s2mmu);
> +	free(guest);
> +}
> diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
> new file mode 100644
> index 00000000..70c19507
> --- /dev/null
> +++ b/lib/arm64/guest_arch.S
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright (C) 2026, Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#define __ASSEMBLY__
> +#include <asm/asm-offsets.h>
> +#include <asm/sysreg.h>
> +
> +.global guest_run
> +guest_run:
> +	/* x0 = struct guest pointer */
> +
> +	/* Save Host Callee-Saved Regs */
> +	stp	x29, x30, [sp, #-16]!
> +	stp	x27, x28, [sp, #-16]!
> +	stp	x25, x26, [sp, #-16]!
> +	stp	x23, x24, [sp, #-16]!
> +	stp	x21, x22, [sp, #-16]!
> +	stp	x19, x20, [sp, #-16]!
> +
> +	/* Cache Guest Pointer in TPIDR_EL2 */
> +	msr	tpidr_el2, x0
> +
> +	/* Load Guest System Registers */
> +	ldr	x1, [x0, #GUEST_ELR_OFFSET]
> +	msr	elr_el2, x1
> +	ldr	x1, [x0, #GUEST_SPSR_OFFSET]
> +	msr	spsr_el2, x1
> +	ldr	x1, [x0, #GUEST_HCR_OFFSET]
> +	msr	hcr_el2, x1
> +	ldr	x1, [x0, #GUEST_VTTBR_OFFSET]
> +	msr	vttbr_el2, x1
> +	ldr	x1, [x0, #GUEST_SCTLR_OFFSET]
> +	msr_s	SYS_SCTLR_EL1, x1

This part, can use `msr sctlr_el1`.

> +	ldr	x1, [x0, #GUEST_SP_EL1_OFFSET]
> +	msr	sp_el1, x1
> +
> +	/* Load Guest GPRs */
> +	ldp	x1, x2, [x0, #8]
> +	ldp	x3, x4, [x0, #24]
> +	ldp	x5, x6, [x0, #40]
> +	ldp	x7, x8, [x0, #56]
> +	ldp	x9, x10, [x0, #72]
> +	ldp	x11, x12, [x0, #88]
> +	ldp	x13, x14, [x0, #104]
> +	ldp	x15, x16, [x0, #120]
> +	ldp	x17, x18, [x0, #136]
> +	ldp	x19, x20, [x0, #152]
> +	ldp	x21, x22, [x0, #168]
> +	ldp	x23, x24, [x0, #184]
> +	ldp	x25, x26, [x0, #200]
> +	ldp	x27, x28, [x0, #216]
> +	ldp	x29, x30, [x0, #232]
> +	ldr	x0, [x0, #0]
> +
> +	isb
> +	eret
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 

Thanks,
Joey
