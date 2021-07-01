Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50494C11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:08:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C74FD60C3F
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C74FD60C3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FE4407F1;
	Thu,  1 Jul 2021 10:08:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XtnqQX1Kg8ZF; Thu,  1 Jul 2021 10:08:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A90C4A4A0;
	Thu,  1 Jul 2021 10:08:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3DB54086A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:08:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l6ghndO3y+s0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 10:08:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86CAA407F1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:08:29 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D0760C3F;
 Thu,  1 Jul 2021 14:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625148507;
 bh=W2O2HBHukE33uMewYGpE7LxhKSgNZJIn7NkYzwJ7ikg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MO+grJJKr0XxaJkjyEfZ/BDWdVlpLG5EBsSlytYRjEe5fVdBr6Z772606mcaxTMVB
 PP6y28MY9woGBGGurYkrHvwwsvYW3YkddFhYqMTkeBafQALsNQF19sC70RLDtKWMGS
 6hXXO1WsQ3RGLa5kj3R6quVptIEj+o+4PQucqepNgrK1bLn+GqlrB3jUO5VCQUJBWu
 ybhKh7wk0N/udlR1YAO0TM25NPa2SXNnKfh/X3W9lh6SSAsyC6XYfl1NmW7gDjOT5l
 TyGYzCFOVQmR+WWfvU8Ob9JzR9EbdXsaU+wB3Nbt4rHi1DbLr0acfRuk8gGMnLG4nn
 4aWzq0PJFyj7g==
Date: Thu, 1 Jul 2021 15:08:22 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 09/13] KVM: arm64: Add trap handlers for protected VMs
Message-ID: <20210701140821.GI9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-10-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-10-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Jun 15, 2021 at 02:39:46PM +0100, Fuad Tabba wrote:
> Add trap handlers for protected VMs. These are mainly for Sys64
> and debug traps.

I think one big thing missing from this patch is some rationale around
which features are advertised and which are not. Further, when traps
are enabled later on, there doesn't seem to be one place which drives the
logic, so it's quite hard to reason about.

So I think we need both some documentation to describe the architectural
environment provided to protected VMs, but also a way to couple the logic
which says "We hide this feature from the ID registers because of foo"
with the logic that says "And here is the control bit to trap this feature".

Otherwise, it's very hard to ensure that this is (and remains) consistent.
It would also make it easier to review :)

> No functional change intended as these are not hooked in yet.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h   |   3 +
>  arch/arm64/kvm/arm.c               |   3 +
>  arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 475 +++++++++++++++++++++++++++++
>  4 files changed, 482 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 9d60b3006efc..7e81e42107e1 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -115,7 +115,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
>  void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
>  #endif
>  
> +extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
> +extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
>  extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
>  extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
> +extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
>  
>  #endif /* __ARM64_KVM_HYP_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d71da6089822..363493395eba 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1751,8 +1751,11 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
>  	void *addr = phys_to_virt(hyp_mem_base);
>  	int ret;
>  
> +	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
>  	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
>  	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
>  
>  	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
>  	if (ret)
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 5df6193fc430..a23f417a0c20 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
>  
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>  	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
> -	 cache.o setup.o mm.o mem_protect.o
> +	 cache.o setup.o mm.o mem_protect.o sys_regs.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
>  obj-y += $(lib-objs)
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> new file mode 100644
> index 000000000000..ab09ccc64fea
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -0,0 +1,475 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021 Google LLC
> + * Author: Fuad Tabba <tabba@google.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
> +
> +#include <hyp/adjust_pc.h>
> +
> +#include "../../sys_regs.h"
> +
> +/*
> + * Copies of the host's CPU features registers holding sanitized values.
> + */
> +u64 id_aa64pfr0_el1_sys_val;
> +u64 id_aa64pfr1_el1_sys_val;
> +u64 id_aa64mmfr2_el1_sys_val;
> +
> +/*
> + * Inject an undefined exception to the guest.
> + */
> +static void inject_undef(struct kvm_vcpu *vcpu)
> +{
> +	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
> +
> +	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1 |
> +			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
> +			     KVM_ARM64_PENDING_EXCEPTION);

Has vcpu_cpsr(vcpu) been populated as part of the trap? I couldn't spot
that, but __kvm_adjust_pc(vcpu) goes and reads that information.

> +	__kvm_adjust_pc(vcpu);
> +
> +	write_sysreg_el1(esr, SYS_ESR);
> +	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> +	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> +	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
