Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2C93F54DD
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779288718; cv=none; b=JTK3DtBWCEiy8tRVujPJbCyNc+oKc6WSleyg1D0QUUQR8sFRrh6MyvCeZFY9Bpkiosw5yJPXZaYX3zKdFKRa260DhhsGkVi++n9dwWTXbuGyToONjWOvDRub3Ix7O08JggTPxTpQ24vPPH0h6TNpF5hrrE7BdY2IzubgjtwHnvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779288718; c=relaxed/simple;
	bh=6zYOthT1ybEaUy69JRMzLfF5XGzCBtUdPg9X5KNL+ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvaQpjaOHC51ZxtHoJ7eujMcU4+HinnqS4V2U9/ZIbthF+ZWzerWiz/du26RGELz461Q2sYoi/jhhWblCeQEbHdq8Y1syu3kn4dlhvgRudKcwq2/GRSBxoT5nFNqHpYBZ2CfND9YdESkqWm+8bi4Zq19kXbBUlIngFMqNuYeXm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=o+bcNZBk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="o+bcNZBk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B3A62910;
	Wed, 20 May 2026 07:51:50 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C0D13F85F;
	Wed, 20 May 2026 07:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779288715; bh=6zYOthT1ybEaUy69JRMzLfF5XGzCBtUdPg9X5KNL+ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o+bcNZBkLcPpULa4g2MJB2Uo5FZ/MCKcllKd0dVkH786cDkftGrpgTQitAnpUYH0B
	 +TszE6HS5refO9ltL6EnAeM/PIwVtaMt27W6EoVqpArQBR2TPD8x5vrtD17a2zAvn2
	 ktEJDac0lzpsBbL2+1TsLCPMgA7a3tm1RDjdjm3Q=
Date: Wed, 20 May 2026 15:51:46 +0100
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
Subject: Re: [kvm-unit-tests PATCH v2 6/7] lib: arm64: Add guest-internal
 exception handling (EL1)
Message-ID: <20260520145146.GA4037194@e124191.cambridge.arm.com>
References: <20260413204630.1149038-1-jingzhangos@google.com>
 <20260413204630.1149038-7-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204630.1149038-7-jingzhangos@google.com>

On Mon, Apr 13, 2026 at 01:46:29PM -0700, Jing Zhang wrote:
> Implement the infrastructure for managed guests to handle their own
> exceptions at EL1. This allows guests to manage internal traps
> independently of the EL2 host.
> 
> Changes include:
> - 'guest_el1_vectors': A dedicated EL1 vector table for guests,
>   supporting synchronous exceptions, IRQs, FIQs, and SErrors.
> - 'guest_context': A per-guest metadata structure tracked via
>   TPIDR_EL1, containing a dispatch table for guest-internal handlers.
> - 'guest_el1_c_handler': C-level dispatcher that executes registered
>   guest handlers or triggers an HVC trap back to the host for unhandled
>   exceptions.
> - Integrated setup: guest_create() now allocates and maps the guest
>   context, while the context switch logic ensures VBAR_EL1 and
>   TPIDR_EL1 are correctly saved and restored.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  lib/arm64/asm-offsets.c |  2 ++
>  lib/arm64/asm/guest.h   | 26 ++++++++++++++
>  lib/arm64/asm/sysreg.h  |  1 +
>  lib/arm64/guest.c       | 39 +++++++++++++++++++++
>  lib/arm64/guest_arch.S  | 78 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 146 insertions(+)
> 
> diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
> index ceeecce5..fc9f28fb 100644
> --- a/lib/arm64/asm-offsets.c
> +++ b/lib/arm64/asm-offsets.c
> @@ -37,11 +37,13 @@ int main(void)
>  	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
>  	OFFSET(GUEST_VTTBR_OFFSET, guest, vttbr_el2);
>  	OFFSET(GUEST_SCTLR_OFFSET, guest, sctlr_el1);
> +	OFFSET(GUEST_VBAR_OFFSET, guest, vbar_el1);
>  	OFFSET(GUEST_SP_EL1_OFFSET, guest, sp_el1);
>  	OFFSET(GUEST_ESR_OFFSET, guest, esr_el2);
>  	OFFSET(GUEST_FAR_OFFSET, guest, far_el2);
>  	OFFSET(GUEST_HPFAR_OFFSET, guest, hpfar_el2);
>  	OFFSET(GUEST_EXIT_CODE_OFFSET, guest, exit_code);
> +	OFFSET(GUEST_TPIDR_EL1_OFFSET, guest, tpidr_el1);
>  
>  	return 0;
>  }
> diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
> index b99641ef..8b40f3a5 100644
> --- a/lib/arm64/asm/guest.h
> +++ b/lib/arm64/asm/guest.h
> @@ -29,6 +29,26 @@ enum guest_handler_result {
>  struct guest;
>  typedef enum guest_handler_result (*guest_handler_t)(struct guest *guest);
>  
> +/*
> + * Guest EL1 Exception Frame (pushed to guest stack by asm stub)
> + * We use a simplified frame: x0-x30, elr, spsr. size = 33*8
> + */
> +struct guest_el1_regs {
> +	unsigned long regs[31];
> +	unsigned long elr;
> +	unsigned long spsr;
> +};
> +
> +typedef void (*guest_el1_handler_t)(struct guest_el1_regs *regs, unsigned int esr);
> +
> +/*
> + * Guest Context Structure
> + * This will be pointed to by TPIDR_EL1 while the guest is running.
> + */
> +struct guest_context {
> +	guest_el1_handler_t handlers[VECTOR_MAX];
> +};
> +
>  struct guest {
>  	/* General Purpose Registers */
>  	unsigned long x[31]; /* x0..x30 */
> @@ -42,15 +62,18 @@ struct guest {
>  	unsigned long vttbr_el2;
>  	unsigned long sctlr_el1;
>  	unsigned long sp_el1;
> +	unsigned long vbar_el1;
>  
>  	/* Exit Information */
>  	unsigned long esr_el2;
>  	unsigned long far_el2;
>  	unsigned long hpfar_el2;
>  	unsigned long exit_code;
> +	unsigned long tpidr_el1;
>  
>  	/* Exception Handlers in EL2 */
>  	guest_handler_t handlers[VECTOR_MAX];
> +	struct guest_context *guest_context;
>  
>  	struct s2_mmu *s2mmu;
>  };
> @@ -62,4 +85,7 @@ void guest_run(struct guest *guest);
>  unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vector_offset);
>  void guest_install_handler(struct guest *guest, enum vector v, guest_handler_t handler);
>  
> +void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vector);
> +void guest_install_el1_handler(struct guest *guest, enum vector v, guest_el1_handler_t handler);
> +
>  #endif /* _ASMARM64_GUEST_H_ */
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 857bee98..a298ceff 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -137,6 +137,7 @@ asm(
>  #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
>  
>  #define SYS_SCTLR_EL1		sys_reg(3, 5, 1, 0, 0)
> +#define SYS_VBAR_EL1		sys_reg(3, 5, 12, 0, 0)

SYS_VBAR_EL12 as I mentioned in the other e-mail.

>  
>  #define INIT_SCTLR_EL1_MMU_OFF	\
>  			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
> diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
> index dd42ccd6..54c8b429 100644
> --- a/lib/arm64/guest.c
> +++ b/lib/arm64/guest.c
> @@ -36,9 +36,45 @@ unsigned long guest_c_exception_handler(struct guest *guest, unsigned long vecto
>  	return 1;
>  }
>  
> +/* --- EL1 (Guest-Internal) Vector Handling --- */
> +
> +void guest_install_el1_handler(struct guest *guest, enum vector v, guest_el1_handler_t handler)
> +{
> +	if (guest && guest->guest_context && v < VECTOR_MAX)
> +		guest->guest_context->handlers[v] = handler;
> +}
> +
> +void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vector)
> +{
> +	struct guest_context *ctx = (struct guest_context *)read_sysreg(tpidr_el1);
> +	unsigned int esr = read_sysreg(esr_el1);
> +
> +	if (ctx && vector < VECTOR_MAX && ctx->handlers[vector]) {
> +		ctx->handlers[vector](regs, esr);
> +	} else {
> +		printf("Guest: Unhandled Exception Vector %d, ESR=0x%x\n", vector, esr);
> +		asm volatile("hvc #0xFFFF");
> +	}
> +}
> +
> +extern void guest_el1_vectors(void);
> +
>  static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
>  {
>  	struct guest *guest = calloc(1, sizeof(struct guest));
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
> +	guest->tpidr_el1 = guest_ctx_pa;
>  
>  	guest->elr_el2 = (unsigned long)entry_point;
>  	guest->spsr_el2 = 0x3C5; /* M=EL1h, DAIF=Masked */
> @@ -56,6 +92,7 @@ static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry_point)
>  	guest->sctlr_el1 &= ~(SCTLR_EL1_M | SCTLR_EL1_C);
>  	guest->sctlr_el1 |= SCTLR_EL1_I;
>  
> +	guest->vbar_el1 = (unsigned long)guest_el1_vectors;
>  	guest->s2mmu = s2_ctx;
>  
>  	return guest;
> @@ -109,6 +146,8 @@ void guest_destroy(struct guest *guest)
>  {
>  	s2mmu_disable(guest->s2mmu);
>  	s2mmu_destroy(guest->s2mmu);
> +	if (guest->guest_context)
> +		free_page(guest->guest_context);
>  	free(guest);
>  }
>  
> diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
> index 81874fd0..32d640e6 100644
> --- a/lib/arm64/guest_arch.S
> +++ b/lib/arm64/guest_arch.S
> @@ -34,8 +34,12 @@ guest_run:
>  	msr	vttbr_el2, x1
>  	ldr	x1, [x0, #GUEST_SCTLR_OFFSET]
>  	msr_s	SYS_SCTLR_EL1, x1
> +	ldr	x1, [x0, #GUEST_VBAR_OFFSET]
> +	msr_s	SYS_VBAR_EL1, x1
>  	ldr	x1, [x0, #GUEST_SP_EL1_OFFSET]
>  	msr	sp_el1, x1
> +	ldr	x1, [x0, #GUEST_TPIDR_EL1_OFFSET]
> +	msr	tpidr_el1, x1
>  
>  	/* Load Guest GPRs */
>  	ldp	x1, x2, [x0, #8]
> @@ -125,6 +129,8 @@ guest_common_exit:
>  	str	x1, [x0, #GUEST_HPFAR_OFFSET]
>  	mrs	x1, sp_el1
>  	str	x1, [x0, #GUEST_SP_EL1_OFFSET]
> +	mrs_s	x1, SYS_VBAR_EL1
> +	str	x1, [x0, #GUEST_VBAR_OFFSET]
>  
>  	/* x29 contains vector offset from entry */
>  	mov	x1, x29
> @@ -168,3 +174,75 @@ guest_resume_guest:
>  	ldp	x29, x30, [x0, #232]
>  	ldr	x0, [x0, #0]
>  	eret
> +
> +/* EL1 Vector Table */
> +.macro guest_el1_vector, vector_num
> +	.align 7
> +	stp     x29, x30, [sp, #-16]!
> +	mov	x29, \vector_num
> +	b       guest_el1_common
> +.endm
> +
> +.align 11
> +.global guest_el1_vectors
> +guest_el1_vectors:
> +	.skip 0x200
> +
> +	guest_el1_vector #4	/* Sync */
> +	guest_el1_vector #5	/* IRQ */
> +	guest_el1_vector #6	/* FIQ */
> +	guest_el1_vector #7	/* SError */
> +

While prototyping EL0 testing, I noticed this only handles EL1h exceptions, you
should just cover the full range of 16 vectors.

> +	.align 11
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

Thanks,
Joey
