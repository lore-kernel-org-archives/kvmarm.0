Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8690388E42
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364692; cv=none; b=gTO/oRV5eYxV1vVjLOVptg6U1xLYUUfk5ebQW1gvubSPB8fABfOvbeGHCmNkQ+TxTutwDbfwtoLXAkfDp3XT66zMWCN4XANVRRLlH5YcBImgdk50r8MBUTNBds8JyWyfYAFZq97TqT1uP9WdmCVLGwsQj8TCVOVLcchwK+FQKt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364692; c=relaxed/simple;
	bh=/q7/DOdRcIgLUOwElaAh60iOkN0zJyM0+KPJc+V+gtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dg+CQoazjgN/WDLrHYIlcBq0QEyL8Xq1keB35ex895yO5fjObFsMBe7NHVcvLag7ynFoEvZyTqozNo+xYS3S14QorPUg7g8wux3pRmKi5oxXCKOFqMwk6antiD9EmNElXjBsHkA/tcmFXp9HAKiIqlHs53SJgUR9lZoOMOccQI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ocNj+9Or; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ocNj+9Or"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CE4714BF;
	Tue, 24 Mar 2026 08:04:42 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DBC053F836;
	Tue, 24 Mar 2026 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774364688; bh=/q7/DOdRcIgLUOwElaAh60iOkN0zJyM0+KPJc+V+gtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ocNj+9OreCdoUz85gNTct75fS0Lv1c08eC7SN/5nLLw7jdbIAriixaysDPEipAqsY
	 o5QsB38r1en3dRrZp7n+tPOWe96MlW2gK5OP+mnACN7oBb0k6tLQ3qcnluaoU8mBYz
	 U2h91sqSaEAVMAT+P2mub0paVoehCiRg1rShCkik=
Date: Tue, 24 Mar 2026 15:04:41 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 2/3] lib: arm64: Add bare-metal guest
 execution framework
Message-ID: <20260324150441.GA456067@e124191.cambridge.arm.com>
References: <20260316224349.2360482-1-jingzhangos@google.com>
 <20260316224349.2360482-3-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316224349.2360482-3-jingzhangos@google.com>

Hi,

Just some preliminary comments.

On Mon, Mar 16, 2026 at 03:43:48PM -0700, Jing Zhang wrote:
> To test advanced KVM features such as nested virtualization (NV) and
> GICv4 direct interrupt injection, kvm-unit-tests needs the ability to
> act as an L1 hypervisor running at EL2 and manage its own L2 guests.
> 
> Introduce a lightweight guest management library that provides the
> infrastructure to create, configure, and execute nested guests.
> 
> This framework includes:
> - Guest lifecycle management: `guest_create()` and `guest_destroy()`
>   APIs to allocate guest context and setup Stage-2 identity mappings
>   for code and stack using the s2mmu library.
> - Context switching: The `guest_run()` assembly routine handles
>   saving the host (L1) callee-saved registers and loading the guest
>   (L2) GPRs and EL1 system registers.
> - VM-Exit handling: Installs an EL2 trap handler (`guest_hyp_vectors`)
>   to intercept guest exits and route them to `guest_c_exception_handler`
>   to determine whether to return to the host test logic or resume.
> - Guest-internal exceptions: Provides `guest_el1_vectors` to catch
>   Sync, IRQ, FIQ, and SError exceptions occurring entirely within the
>   guest (EL1) without trapping to the host.

Might be helpful if this patch could be split into 2-3 commits.

> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arm/Makefile.arm64     |   2 +
>  lib/arm64/asm/guest.h  | 156 ++++++++++++++++++++++++
>  lib/arm64/guest.c      | 197 ++++++++++++++++++++++++++++++
>  lib/arm64/guest_arch.S | 263 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 618 insertions(+)
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
> diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
> new file mode 100644
> index 00000000..1d70873d
> --- /dev/null
> +++ b/lib/arm64/asm/guest.h
> @@ -0,0 +1,156 @@
> +/*
> + * Copyright (C) 2026, Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#ifndef _ASMARM64_GUEST_H_
> +#define _ASMARM64_GUEST_H_
> +
> +/* Offsets for assembly (Must match struct guest) */
> +#define GUEST_X_OFFSET			0
> +#define GUEST_ELR_OFFSET		248
> +#define GUEST_SPSR_OFFSET		256
> +#define GUEST_HCR_OFFSET		264
> +#define GUEST_VTTBR_OFFSET		272
> +#define GUEST_SCTLR_OFFSET		280
> +#define GUEST_VBAR_OFFSET		288
> +#define GUEST_SP_EL1_OFFSET		296
> +#define GUEST_ESR_OFFSET		304
> +#define GUEST_FAR_OFFSET		312
> +#define GUEST_HPFAR_OFFSET		320
> +#define GUEST_EXIT_CODE_OFFSET		328
> +#define GUEST_TPIDR_EL1_OFFSET		336
> +#define GUEST_ICH_VMCR_EL2_OFFSET	344

Look at lib/arm64/asm-offsets.c for how to generate theses.

> +
> +#ifndef __ASSEMBLY__
> +
> +#include <libcflat.h>
> +#include <asm/stage2_mmu.h>
> +
> +/* HCR_EL2 Definitions */
> +#define HCR_VM		(1UL << 0)	/* Virtualization Enable */
> +#define HCR_FMO		(1UL << 3)	/* Physical FIQ Routing */
> +#define HCR_IMO		(1UL << 4)	/* Physical IRQ Routing */
> +#define HCR_AMO		(1UL << 5)	/* Physical SError Interrupt Routing */
> +#define HCR_RW		(1UL << 31)	/* Execution State: AArch64 */
> +#define HCR_DC		(1UL << 12)	/* Default Cacheable */
> +#define HCR_E2H		(1UL << 34)	/* EL2 Host */
> +

Should be in lib/arm64/asm/sysreg.h

> +#define HCR_GUEST_FLAGS (HCR_VM | HCR_FMO | HCR_IMO | HCR_AMO | HCR_RW | \
> +			 HCR_DC | HCR_E2H)
> +
> +/* ICH_VMCR_EL2 bit definition */
> +#define ICH_VMCR_PMR_SHIFT	24
> +#define ICH_VMCR_PMR_MASK	(0xffUL << ICH_VMCR_PMR_SHIFT)
> +#define ICH_VMCR_ENG0_SHIFT	0
> +#define ICH_VMCR_ENG0_MASK	(1 << ICH_VMCR_ENG0_SHIFT)
> +#define ICH_VMCR_ENG1_SHIFT	1
> +#define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
> +
> +/* Guest stack size */
> +#define GUEST_STACK_SIZE		SZ_64K
> +
> +/*
> + * Result from Handler:
> + * RESUME: Keep guest running (ERET immediately)
> + * EXIT:   Return to Host C caller
> + */
> +enum guest_handler_result {
> +	GUEST_ACTION_RESUME,
> +	GUEST_ACTION_EXIT
> +};
> +
> +struct guest;
> +typedef enum guest_handler_result (*guest_handler_t)(struct guest *guest);
> +
> +/* EL1 (Guest-internal) Exception Vector */
> +enum guest_el1_vector {
> +	GUEST_EL1_SYNC,
> +	GUEST_EL1_IRQ,
> +	GUEST_EL1_FIQ,
> +	GUEST_EL1_SERROR,
> +	GUEST_EL1_MAX
> +};
> +

There's a similar vector enum in lib/arm64/asm/processor.h, is there a specific
need to have a separate guest_el1 version?

> +/*
> + * Guest EL1 Exception Frame (pushed to guest stack by asm stub)
> + * We use a simplified frame: x0-x30, elr, spsr. size = 33*8
> + */
> +struct guest_el1_regs {
> +	unsigned long regs[31];
> +	unsigned long elr;
> +	unsigned long spsr;
> +};

What about SP?

> +
> +typedef void (*guest_el1_handler_t)(struct guest_el1_regs *regs, unsigned int esr);
> +
> +/* Exceptions from the Guest (Lower EL using AArch64) */
> +enum guest_vector {
> +	GUEST_VECTOR_SYNC,
> +	GUEST_VECTOR_IRQ,
> +	GUEST_VECTOR_FIQ,
> +	GUEST_VECTOR_SERROR,
> +	GUEST_VECTOR_MAX
> +};

Same comment about vector.

> +
> +/*
> + * Guest Context Structure
> + * This will be pointed to by TPIDR_EL1 while the guest is running.
> + */
> +struct guest_context {
> +	guest_el1_handler_t handlers[GUEST_EL1_MAX];
> +};
> +
> +struct guest {
> +	/* 0x000: General Purpose Registers */
> +	unsigned long x[31]; /* x0..x30 */
> +
> +	/* 0x0F8: Execution State */
> +	unsigned long elr_el2;
> +	unsigned long spsr_el2;
> +
> +	/* 0x108: Control Registers */
> +	unsigned long hcr_el2;
> +	unsigned long vttbr_el2;
> +	unsigned long sctlr_el1;
> +	unsigned long vbar_el1;
> +	unsigned long sp_el1;
> +
> +	/* 0x130: Exit Information */
> +	unsigned long esr_el2;
> +	unsigned long far_el2;
> +	unsigned long hpfar_el2;
> +	unsigned long exit_code; /* enum guest_vector */
> +	unsigned long tpidr_el1;
> +
> +	/* 0x158: GIC Registers */
> +	unsigned long ich_vmcr_el2;
> +
> +	/* 0x160: Exception Handlers */
> +	guest_handler_t handlers[GUEST_VECTOR_MAX];
> +	struct guest_context *guest_context;
> +
> +	struct s2_mmu *s2mmu;
> +};
> +
> +/* API */
> +struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2_granule granule);
> +void guest_destroy(struct guest *guest);
> +
> +/* Configuration */
> +void guest_set_vector(struct guest *guest, void *vector_table);
> +void guest_set_stack(struct guest *guest, void *stack_top);
> +void guest_install_handler(struct guest *guest, enum guest_vector v, guest_handler_t handler);
> +
> +/* Install handler for exceptions INSIDE EL1 */
> +void guest_install_el1_handler(struct guest *guest, enum guest_el1_vector v, guest_el1_handler_t handler);
> +
> +unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vector_offset);
> +void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vector);
> +
> +/* Core Run Loop */
> +void guest_run(struct guest *guest);
> +
> +#endif /* __ASSEMBLY__ */
> +#endif /* _ASMARM64_GUEST_H_ */
> diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
> new file mode 100644
> index 00000000..6c256c11
> --- /dev/null
> +++ b/lib/arm64/guest.c
> @@ -0,0 +1,197 @@
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
> +/* Compile-time checks to ensure Assembly macros match C Struct */
> +_Static_assert(offsetof(struct guest, x) == GUEST_X_OFFSET,
> +	       "GUEST_X_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, elr_el2) == GUEST_ELR_OFFSET,
> +	       "GUEST_ELR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, spsr_el2) == GUEST_SPSR_OFFSET,
> +	       "GUEST_SPSR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, hcr_el2) == GUEST_HCR_OFFSET,
> +	       "GUEST_HCR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, vttbr_el2) == GUEST_VTTBR_OFFSET,
> +	       "GUEST_VTTBR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, sctlr_el1) == GUEST_SCTLR_OFFSET,
> +	       "GUEST_SCTLR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, vbar_el1) == GUEST_VBAR_OFFSET,
> +	       "GUEST_VBAR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, sp_el1) == GUEST_SP_EL1_OFFSET,
> +	       "GUEST_SP_EL1_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, esr_el2) == GUEST_ESR_OFFSET,
> +	       "GUEST_ESR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, far_el2) == GUEST_FAR_OFFSET,
> +	       "GUEST_FAR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, hpfar_el2) == GUEST_HPFAR_OFFSET,
> +	       "GUEST_HPFAR_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, exit_code) == GUEST_EXIT_CODE_OFFSET,
> +	       "GUEST_EXIT_CODE_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, tpidr_el1) == GUEST_TPIDR_EL1_OFFSET,
> +		"GUEST_TPIDR_EL1_OFFSET mismatch");
> +_Static_assert(offsetof(struct guest, ich_vmcr_el2) == GUEST_ICH_VMCR_EL2_OFFSET,
> +		"GUEST_ICH_VMCR_EL2_OFFSET mismatch");
> +
> +/*
> + * C-Entry for Exception Handling
> + * Returns 0 to Resume Guest, 1 to Exit to Host Caller
> + */
> +unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vector_offset)
> +{
> +	enum guest_vector vector = (enum guest_vector)guest->exit_code;
> +
> +	/* Save Trap Info */
> +	guest->esr_el2 = read_sysreg(esr_el2);
> +	guest->far_el2 = read_sysreg(far_el2);
> +	guest->hpfar_el2 = read_sysreg(hpfar_el2);
> +
> +	/* Invoke Handler if registered */
> +	if (guest->handlers[vector]) {
> +		if (guest->handlers[vector](guest) == GUEST_ACTION_RESUME) {
> +			return 0; /* ASM stub will restore and ERET */
> +		}
> +	}
> +
> +	/* Default: Exit to caller */
> +	return 1;
> +}
> +
> +/* --- EL1 (Guest-Internal) Vector Handling --- */
> +
> +void guest_install_el1_handler(struct guest *guest, enum guest_el1_vector v, guest_el1_handler_t handler)
> +{
> +	if (guest && guest->guest_context && v < GUEST_EL1_MAX)
> +		guest->guest_context->handlers[v] = handler;
> +}
> +
> +void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vector)
> +{
> +	struct guest_context *ctx = (struct guest_context *)read_sysreg(tpidr_el1);
> +	unsigned int esr = read_sysreg(esr_el1);
> +
> +	if (ctx && vector < GUEST_EL1_MAX && ctx->handlers[vector]) {
> +		ctx->handlers[vector](regs, esr);
> +	} else {
> +		printf("Guest: Unhandled Exception Vector %d, ESR=0x%x\n", vector, esr);
> +		asm volatile("hvc #0xFFFF");
> +	}
> +}
> +
> +extern void guest_el1_vectors(void);
> +
> +static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
> +{
> +	struct guest *guest = calloc(1, sizeof(struct guest));
> +	struct guest_context *guest_ctx;
> +	unsigned long guest_ctx_pa;
> +
> +	/* Allocate the internal context table */
> +	guest_ctx = (void *)alloc_page();
> +	memset(guest_ctx, 0, PAGE_SIZE);
> +	guest->guest_context = guest_ctx;
> +
> +	guest_ctx_pa = virt_to_phys(guest_ctx);
> +	if (s2_ctx)
> +		s2mmu_map(s2_ctx, guest_ctx_pa, guest_ctx_pa, PAGE_SIZE, S2_MAP_RW);
> +
> +	guest->tpidr_el1 = guest_ctx_pa;;
> +
> +	guest->elr_el2 = (unsigned long)entry_point;
> +	guest->spsr_el2 = 0x3C5; /* M=EL1h, DAIF=Masked */
> +	guest->hcr_el2 = HCR_GUEST_FLAGS;
> +
> +	if (s2_ctx) {
> +		guest->vttbr_el2 = virt_to_phys(s2_ctx->pgd);
> +		guest->vttbr_el2 |= ((unsigned long)s2_ctx->vmid << 48);
> +	}
> +
> +	guest->sctlr_el1 = read_sysreg(sctlr_el1);
> +	guest->sctlr_el1 |= SCTLR_EL1_C | SCTLR_EL1_I | SCTLR_EL1_M;
> +
> +	guest->ich_vmcr_el2 = read_sysreg(ich_vmcr_el2);
> +	guest->ich_vmcr_el2 |= (0xFFUL << ICH_VMCR_PMR_SHIFT) | (1UL << ICH_VMCR_ENG1_SHIFT);
> +
> +	guest->vbar_el1 = (unsigned long)guest_el1_vectors;
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
> +	guest_set_stack(guest, (void *)(stack_pa + GUEST_STACK_SIZE));
> +
> +	/* Map UART identity mapped, printf() available to guest */
> +	s2mmu_map(ctx, 0x09000000, 0x09000000, PAGE_SIZE, S2_MAP_DEVICE);
> +
> +	return guest;
> +}
> +
> +void guest_destroy(struct guest *guest)
> +{
> +	s2mmu_disable(guest->s2mmu);
> +	s2mmu_destroy(guest->s2mmu);
> +	if (guest->guest_context)
> +		free_page(guest->guest_context);
> +	free(guest);
> +}
> +
> +void guest_set_vector(struct guest *guest, void *vector_table)
> +{
> +	guest->vbar_el1 = (unsigned long)vector_table;
> +}
> +
> +void guest_set_stack(struct guest *guest, void *stack_top)
> +{
> +	guest->sp_el1 = (unsigned long)stack_top;
> +}
> +
> +void guest_install_handler(struct guest *guest, enum guest_vector v, guest_handler_t handler)
> +{
> +	if (v < GUEST_VECTOR_MAX)
> +		guest->handlers[v] = handler;
> +}
> diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
> new file mode 100644
> index 00000000..cb7074d7
> --- /dev/null
> +++ b/lib/arm64/guest_arch.S
> @@ -0,0 +1,263 @@
> +/*
> + * Copyright (C) 2026, Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#define __ASSEMBLY__
> +#include <asm/guest.h>
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
> +	/* Configure ICC_SRE_EL2 to allow EL1 access to SysRegs */
> +	/* Bit 3 (Enable) = 1, Bit 0 (SRE) = 1 */
> +	mrs	x1, icc_sre_el2
> +	orr	x1, x1, #1
> +	orr	x1, x1, #(1 << 3)
> +	msr	icc_sre_el2, x1
> +	isb
> +
> +	/* Enable virtual CPU interface */
> +	mrs	x1, ich_hcr_el2
> +	orr	x1, x1, #1
> +	msr	ich_hcr_el2, x1
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
> +	msr	S3_5_c1_c0_0, x1
> +	ldr	x1, [x0, #GUEST_VBAR_OFFSET]
> +	msr	S3_5_c12_c0_0, x1

Need to add these registers to the sysreg.h file, so don't need the raw encoding.

> +	ldr	x1, [x0, #GUEST_SP_EL1_OFFSET]
> +	msr	sp_el1, x1
> +	ldr	x1, [x0, #GUEST_TPIDR_EL1_OFFSET]
> +	msr	tpidr_el1, x1
> +	ldr	x1, [x0, #GUEST_ICH_VMCR_EL2_OFFSET]
> +	msr	ich_vmcr_el2, x1
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
> +	/* Install Trap Handler */
> +	adrp	x29, guest_hyp_vectors
> +	add	x29, x29, :lo12:guest_hyp_vectors
> +	msr	vbar_el2, x29
> +
> +	/* Restore x29 from struct (via tpidr_el2) */
> +	mrs	x29, tpidr_el2
> +	ldr	x29, [x29, #232]
> +
> +	isb
> +	eret
> +
> +	.align 11
> +guest_hyp_vectors:
> +	.skip 0x400
> +
> +guest_exit_sync:
> +	stp	x0, x1, [sp, #-16]!
> +	mrs	x0, tpidr_el2
> +	mov	x1, #0
> +	str	x1, [x0, #GUEST_EXIT_CODE_OFFSET]
> +	b	guest_common_exit
> +
> +	.balign 0x80
> +
> +guest_exit_irq:
> +	stp	x0, x1, [sp, #-16]!
> +	mrs	x0, tpidr_el2
> +	mov	x1, #1
> +	str	x1, [x0, #GUEST_EXIT_CODE_OFFSET]
> +	b	guest_common_exit
> +
> +guest_common_exit:
> +	stp	x2, x3, [x0, #16]
> +	stp	x4, x5, [x0, #32]
> +	stp	x6, x7, [x0, #48]
> +	stp	x8, x9, [x0, #64]
> +	stp	x10, x11, [x0, #80]
> +	stp	x12, x13, [x0, #96]
> +	stp	x14, x15, [x0, #112]
> +	stp	x16, x17, [x0, #128]
> +	stp	x18, x19, [x0, #144]
> +	stp	x20, x21, [x0, #160]
> +	stp	x22, x23, [x0, #176]
> +	stp	x24, x25, [x0, #192]
> +	stp	x26, x27, [x0, #208]
> +	stp	x28, x29, [x0, #224]
> +	str	x30, [x0, #240]
> +
> +	ldp	x2, x3, [sp], #16
> +	stp	x2, x3, [x0, #0]
> +
> +	mrs	x1, elr_el2
> +	str	x1, [x0, #GUEST_ELR_OFFSET]
> +	mrs	x1, spsr_el2
> +	str	x1, [x0, #GUEST_SPSR_OFFSET]
> +	mrs	x1, esr_el2
> +	str	x1, [x0, #GUEST_ESR_OFFSET]
> +	mrs	x1, far_el2
> +	str	x1, [x0, #GUEST_FAR_OFFSET]
> +	mrs	x1, hpfar_el2
> +	str	x1, [x0, #GUEST_HPFAR_OFFSET]
> +	mrs	x1, sp_el1
> +	str	x1, [x0, #GUEST_SP_EL1_OFFSET]

Missing VBAR_EL1?

> +	mrs	x1, ich_vmcr_el2
> +	str	x1, [x0, #GUEST_ICH_VMCR_EL2_OFFSET]
> +
> +	/* x29 contains vector offset from entry */
> +	mov	x1, x29
> +	bl	guest_c_exception_handler
> +	cbz	x0, guest_resume_guest
> +
> +	/* EXIT */
> +	/* Restore Host Callee-Saved Regs */
> +	ldp	x19, x20, [sp], #16
> +	ldp	x21, x22, [sp], #16
> +	ldp	x23, x24, [sp], #16
> +	ldp	x25, x26, [sp], #16
> +	ldp	x27, x28, [sp], #16
> +	ldp	x29, x30, [sp], #16
> +	ret
> +
> +	/* RESUME */
> +guest_resume_guest:
> +	mrs	x0, tpidr_el2
> +	ldr	x1, [x0, #GUEST_ELR_OFFSET]
> +	msr	elr_el2, x1
> +	ldr	x1, [x0, #GUEST_SPSR_OFFSET]
> +	msr	spsr_el2, x1
> +	ldr	x1, [x0, #GUEST_SP_EL1_OFFSET]
> +	msr	sp_el1, x1
> +
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
> +	eret
> +
> +/* EL1 Vector Table */
> +.align 11
> +.global guest_el1_vectors
> +guest_el1_vectors:
> +	/* Sync (0x000) */
> +	.skip 0x200
> +	/* Sync (0x200) */
> +	stp	x29, x30, [sp, #-16]!
> +	mov	x29, #0
> +	b	guest_el1_common
> +	.skip 0x80 - 12
> +	/* IRQ (0x280) */
> +	stp	x29, x30, [sp, #-16]!
> +	mov	x29, #1
> +	b	guest_el1_common
> +	.skip 0x80 - 12
> +	/* FIQ (0x300) */
> +	stp	x29, x30, [sp, #-16]!
> +	mov	x29, #2
> +	b	guest_el1_common
> +	.skip 0x80 - 12
> +	/* SError (0x380) */
> +	stp	x29, x30, [sp, #-16]!
> +	mov	x29, #3
> +	b	guest_el1_common
> +	.skip 0x400
> +
> +guest_el1_common:
> +	sub	sp, sp, #264
> +	stp	x0, x1, [sp, #0]
> +	stp	x2, x3, [sp, #16]
> +	stp	x4, x5, [sp, #32]
> +	stp	x6, x7, [sp, #48]
> +	stp	x8, x9, [sp, #64]
> +	stp	x10, x11, [sp, #80]
> +	stp	x12, x13, [sp, #96]
> +	stp	x14, x15, [sp, #112]
> +	stp	x16, x17, [sp, #128]
> +	stp	x18, x19, [sp, #144]
> +	stp	x20, x21, [sp, #160]
> +	stp	x22, x23, [sp, #176]
> +	stp	x24, x25, [sp, #192]
> +	stp	x26, x27, [sp, #208]
> +	stp	x28, x30, [sp, #224]
> +
> +	mrs	x0, elr_el1
> +	str	x0, [sp, #248]
> +	mrs	x0, spsr_el1
> +	str	x0, [sp, #256]
> +
> +	mov	x0, sp
> +	mov	x1, x29
> +	bl	guest_el1_c_handler
> +
> +	ldr	x0, [sp, #248]
> +	msr	elr_el1, x0
> +	ldr	x0, [sp, #256]
> +	msr	spsr_el1, x0
> +
> +	ldp	x0, x1, [sp, #0]
> +	ldp	x2, x3, [sp, #16]
> +	ldp	x4, x5, [sp, #32]
> +	ldp	x6, x7, [sp, #48]
> +	ldp	x8, x9, [sp, #64]
> +	ldp	x10, x11, [sp, #80]
> +	ldp	x12, x13, [sp, #96]
> +	ldp	x14, x15, [sp, #112]
> +	ldp	x16, x17, [sp, #128]
> +	ldp	x18, x19, [sp, #144]
> +	ldp	x20, x21, [sp, #160]
> +	ldp	x22, x23, [sp, #176]
> +	ldp	x24, x25, [sp, #192]
> +	ldp	x26, x27, [sp, #208]
> +	ldp	x28, x30, [sp, #224]
> +
> +	add	sp, sp, #264
> +	ldp	x29, x30, [sp], #16
> +	eret
> -- 

Thanks,
Joey
