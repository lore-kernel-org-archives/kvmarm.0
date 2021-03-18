Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A2BC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 16:59:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 155F464F1C
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 16:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 155F464F1C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E9E4B764;
	Thu, 18 Mar 2021 12:59:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jXsc-jjPLUnG; Thu, 18 Mar 2021 12:59:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 222114B729;
	Thu, 18 Mar 2021 12:59:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF7B4B4D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 12:59:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nTdQ-Lp5NwuG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 12:59:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04F9A4B3CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 12:59:52 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 668DA64DD8;
 Thu, 18 Mar 2021 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616086791;
 bh=0jYxchQ01Fn/pbWrdYIupIf1qb7I/Dp4lPdXO4xchl4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=iFdvdoHxG5vJ1xb4IqFLgpyiuLWduzFhgIRYiT9AfUjW/Dl3f4TUZhES6kzbTPTLq
 K0OppUqI8uf8ZR22XfCACK2+7rbsIRRJEYKjWf+diUHEDgPc7TEClp6C4INEGRlEit
 r6IJqXMP2bp5cm/ZtTnhaSISk4JHQ0KoU1yu9SfrlYYcneb3wOhxR0kuax7wHG/qBv
 HpEtYGL+zznBbA8/z3wMUJROUwK4NSMFY95gx4x6b6kqW8Hs/5gXZ3OoGTNFkrHX9/
 6Ji86GK3w8UdXbBiay7yXeZM4sca4fQGSA+KlazyYQ/IugdRV2r5eMGftGPF3t7VVx
 Ldh0wsMLH8a0A==
Date: Thu, 18 Mar 2021 16:59:47 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: Log source when panicking from nVHE hyp
Message-ID: <20210318165946.GA7656@willie-the-truck>
References: <20210318143311.839894-1-ascull@google.com>
 <20210318143311.839894-6-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318143311.839894-6-ascull@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: catalin.marinas@arm.com, maz@kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Mar 18, 2021 at 02:33:11PM +0000, Andrew Scull wrote:
> To aid with debugging, add details of the source of a panic from nVHE
> hyp. This is done by having nVHE hyp exit to nvhe_hyp_panic_handler()
> rather than directly to panic(). The handler will then add the extra
> details for debugging before panicking the kernel.
> 
> If the panic was due to a BUG(), look up the metadata to log the file
> and line, if available, otherwise log an address that can be looked up
> in vmlinux. The hyp offset is also logged to allow other hyp VAs to be
> converted, similar to how the kernel offset is logged during a panic.
> 
> __hyp_panic_string is now inlined since it no longer needs to be
> referenced as a symbol and the message is free to diverge between VHE
> and nVHE.
> 
> The following is an example of the logs generated by a BUG in nVHE hyp.
> 
> [   46.754840] kvm [307]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/switch.c:242!
> [   46.755357] kvm [307]: Hyp Offset: 0xfffea6c58e1e0000
> [   46.755824] Kernel panic - not syncing: HYP panic:
> [   46.755824] PS:400003c9 PC:0000d93a82c705ac ESR:f2000800
> [   46.755824] FAR:0000000080080000 HPFAR:0000000000800800 PAR:0000000000000000
> [   46.755824] VCPU:0000d93a880d0000
> [   46.756960] CPU: 3 PID: 307 Comm: kvm-vcpu-0 Not tainted 5.12.0-rc3-00005-gc572b99cf65b-dirty #133
> [   46.757459] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
> [   46.758366] Call trace:
> [   46.758601]  dump_backtrace+0x0/0x1b0
> [   46.758856]  show_stack+0x18/0x70
> [   46.759057]  dump_stack+0xd0/0x12c
> [   46.759236]  panic+0x16c/0x334
> [   46.759426]  arm64_kernel_unmapped_at_el0+0x0/0x30
> [   46.759661]  kvm_arch_vcpu_ioctl_run+0x134/0x750
> [   46.759936]  kvm_vcpu_ioctl+0x2f0/0x970
> [   46.760156]  __arm64_sys_ioctl+0xa8/0xec
> [   46.760379]  el0_svc_common.constprop.0+0x60/0x120
> [   46.760627]  do_el0_svc+0x24/0x90
> [   46.760766]  el0_svc+0x2c/0x54
> [   46.760915]  el0_sync_handler+0x1a4/0x1b0
> [   46.761146]  el0_sync+0x170/0x180
> [   46.761889] SMP: stopping secondary CPUs
> [   46.762786] Kernel Offset: 0x3e1cd2820000 from 0xffff800010000000
> [   46.763142] PHYS_OFFSET: 0xffffa9f680000000
> [   46.763359] CPU features: 0x00240022,61806008
> [   46.763651] Memory Limit: none

Nice!

> [   46.813867] ---[ end Kernel panic - not syncing: HYP panic:
> [   46.813867] PS:400003c9 PC:0000d93a82c705ac ESR:f2000800
> [   46.813867] FAR:0000000080080000 HPFAR:0000000000800800 PAR:0000000000000000
> [   46.813867] VCPU:0000d93a880d0000 ]---

Why did these last three lines get printed twice?

> Signed-off-by: Andrew Scull <ascull@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h        |  2 ++
>  arch/arm64/kernel/image-vars.h          |  3 +-
>  arch/arm64/kvm/handle_exit.c            | 45 +++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 --
>  arch/arm64/kvm/hyp/nvhe/host.S          | 18 ++++------
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c    |  2 --
>  arch/arm64/kvm/hyp/vhe/switch.c         |  4 +--
>  7 files changed, 56 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 90873851f677..7c17a67d2291 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -121,6 +121,8 @@ void kvm_update_va_mask(struct alt_instr *alt,
>  void kvm_compute_layout(void);
>  void kvm_apply_hyp_relocations(void);
>  
> +#define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)

Just a heads up: but Quentin's series moves this same macro, but to a
different header (arch/arm64/kvm/hyp/include/nvhe/memory.h)

>  static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>  {
>  	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 5aa9ed1e9ec6..5ff2b6909387 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -70,8 +70,7 @@ KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
>  KVM_NVHE_ALIAS(kvm_vgic_global_state);
>  
>  /* Kernel symbols used to call panic() from nVHE hyp code (via ERET). */
> -KVM_NVHE_ALIAS(__hyp_panic_string);
> -KVM_NVHE_ALIAS(panic);
> +KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
>  
>  /* Vectors installed by hyp-init on reset HVC. */
>  KVM_NVHE_ALIAS(__hyp_stub_vectors);
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index cebe39f3b1b6..6f48336b1d86 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -291,3 +291,48 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  	if (exception_index == ARM_EXCEPTION_EL1_SERROR)
>  		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
>  }
> +
> +void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
> +					      u64 par, uintptr_t vcpu,
> +					      u64 far, u64 hpfar) {

Interesting, I don't think I've seen __cold used in arch/arm64 before. Does
it make any difference to the generated code?

> +	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
> +	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr;
> +	u64 mode = spsr & PSR_MODE_MASK;
> +
> +	/*
> +	 * The nVHE hyp symbols are not included by kallsyms to avoid issues
> +	 * with aliasing. That means that the symbols cannot be printed with the
> +	 * "%pS" format specifier, so fall back to the vmlinux address if
> +	 * there's no better option.
> +	 */
> +	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
> +		kvm_err("Invalid host exception to nVHE hyp!\n");
> +	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
> +		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
> +		struct bug_entry *bug = find_bug(elr_in_kimg);
> +		const char *file = NULL;
> +		unsigned int line = 0;
> +
> +		/* All hyp bugs, including warnings, are treated as fatal. */
> +		if (bug)
> +			bug_get_file_line(bug, &file, &line);
> +
> +		if (file)
> +			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
> +		else
> +			kvm_err("nVHE hyp BUG at: %016llx!\n", elr + hyp_offset);
> +	} else {
> +		kvm_err("nVHE hyp panic at: %016llx!\n", elr + hyp_offset);
> +	}
> +
> +	/*
> +	 * Hyp has panicked and we're going to handle that by panicking the
> +	 * kernel. The kernel offset will be revealed in the panic so we're
> +	 * also safe to reveal the hyp offset as a debugging aid for translating
> +	 * hyp VAs to vmlinux addresses.
> +	 */
> +	kvm_err("Hyp Offset: 0x%llx\n", hyp_offset);
> +
> +	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
> +	      spsr, elr, esr, far, hpfar, par, vcpu);

Is %016lx the right conversion specifier for uintptr_t?

> +}
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 6c1f51f25eb3..32d0c036c050 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -30,8 +30,6 @@
>  #include <asm/processor.h>
>  #include <asm/thread_info.h>
>  
> -extern const char __hyp_panic_string[];
> -
>  extern struct exception_table_entry __start___kvm_ex_table;
>  extern struct exception_table_entry __stop___kvm_ex_table;
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 5d94584840cc..2b23400e0fb3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -79,22 +79,18 @@ SYM_FUNC_START(__hyp_do_panic)
>  	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
>  		      PSR_MODE_EL1h)
>  	msr	spsr_el2, lr
> -	ldr	lr, =panic
> +	ldr	lr, =nvhe_hyp_panic_handler
>  	hyp_kimg_va lr, x6
>  	msr	elr_el2, lr
>  
>  	mov	x29, x0
>  
> -	/* Load the format string into x0 and arguments into x1-7 */
> -	ldr	x0, =__hyp_panic_string
> -	hyp_kimg_va x0, x6
> -
> -	/* Load the format arguments into x1-7. */
> -	mov	x6, x3
> -	get_vcpu_ptr x7, x3
> -	mrs	x3, esr_el2
> -	mrs	x4, far_el2
> -	mrs	x5, hpfar_el2
> +	/* Load the panic arguments into x0-7 */
> +	mrs	x0, esr_el2
> +	get_vcpu_ptr x4, x5
> +	mrs	x5, far_el2
> +	mrs	x6, hpfar_el2
> +	mov	x7, xzr			// Unused argument

Why do you need to clear x7 if it's unused?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
