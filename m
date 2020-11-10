Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F495C388F7
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 15:09:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4413020825
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 15:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUctPFeB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4413020825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B15E64BA02;
	Tue, 10 Nov 2020 10:09:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xB8QOCK2uvTX; Tue, 10 Nov 2020 10:08:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD6804BA07;
	Tue, 10 Nov 2020 10:08:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5481A4B9FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 10:08:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XGrJR0PGSaBI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 10:08:58 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D27F4B9E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 10:08:58 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BB1F5207D3;
 Tue, 10 Nov 2020 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605020936;
 bh=CPiYtm+F0PANfE4kt6eHA760IlM+FG8ncMfDp1SQZhE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=kUctPFeBbk6qRT8XhV4xsPWX6VjAMNmYFFA7gj47eHtq/4GPeXccydN0GL2VE3lIa
 GY1uZippUCabAH40dyYYpq72OTRUI5zg1FwLjV+TKkKovKqNnD6XpCBehvkWHHvFUR
 2LNet+aXc6xr04+8kz/EWe67veC8a9gTZBSpvjX8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcVGQ-009TzB-Qc; Tue, 10 Nov 2020 15:08:54 +0000
MIME-Version: 1.0
Date: Tue, 10 Nov 2020 15:08:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 06/24] kvm: arm64: Support per_cpu_ptr in nVHE hyp code
In-Reply-To: <20201109113233.9012-7-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-7-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <f28c9a67759cb04157e888b3a71b2ce2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-09 11:32, David Brazdil wrote:
> When compiling with __KVM_NVHE_HYPERVISOR__ redefine per_cpu_offset() 
> to
> __hyp_per_cpu_offset() which looks up the base of the nVHE per-CPU
> region of the given cpu and computes its offset from the
> .hyp.data..percpu section.
> 
> This enables use of per_cpu_ptr() helpers in nVHE hyp code. Until now
> only this_cpu_ptr() was supported by setting TPIDR_EL2.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/percpu.h  |  6 ++++++
>  arch/arm64/kernel/image-vars.h   |  3 +++
>  arch/arm64/kvm/hyp/nvhe/Makefile |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/percpu.c | 22 ++++++++++++++++++++++
>  4 files changed, 33 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/percpu.c
> 
> diff --git a/arch/arm64/include/asm/percpu.h 
> b/arch/arm64/include/asm/percpu.h
> index 1599e17379d8..8f1661603b78 100644
> --- a/arch/arm64/include/asm/percpu.h
> +++ b/arch/arm64/include/asm/percpu.h
> @@ -239,6 +239,12 @@ PERCPU_RET_OP(add, add, ldadd)
>  #define this_cpu_cmpxchg_8(pcp, o, n)	\
>  	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> 
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);
> +#define __per_cpu_offset
> +#define per_cpu_offset(cpu)	__hyp_per_cpu_offset((cpu))
> +#endif
> +
>  #include <asm-generic/percpu.h>
> 
>  /* Redefine macros for nVHE hyp under DEBUG_PREEMPT to avoid its
> dependencies. */
> diff --git a/arch/arm64/kernel/image-vars.h 
> b/arch/arm64/kernel/image-vars.h
> index c615b285ff5b..78a42a7cdb72 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -103,6 +103,9 @@ KVM_NVHE_ALIAS(gic_nonsecure_priorities);
>  KVM_NVHE_ALIAS(__start___kvm_ex_table);
>  KVM_NVHE_ALIAS(__stop___kvm_ex_table);
> 
> +/* Array containing bases of nVHE per-CPU memory regions. */
> +KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
> +
>  #endif /* CONFIG_KVM */
> 
>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile 
> b/arch/arm64/kvm/hyp/nvhe/Makefile
> index ddde15fe85f2..c45f440cce51 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -6,7 +6,8 @@
>  asflags-y := -D__KVM_NVHE_HYPERVISOR__
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
> 
> -obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
> host.o hyp-main.o
> +obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o 
> host.o \
> +	 hyp-main.o percpu.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o 
> ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/percpu.c 
> b/arch/arm64/kvm/hyp/nvhe/percpu.c
> new file mode 100644
> index 000000000000..5fd0c5696907
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/percpu.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 - Google LLC
> + * Author: David Brazdil <dbrazdil@google.com>
> + */
> +
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>
> +
> +unsigned long __hyp_per_cpu_offset(unsigned int cpu)
> +{
> +	unsigned long *cpu_base_array;
> +	unsigned long this_cpu_base;
> +
> +	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
> +		hyp_panic();
> +
> +	cpu_base_array = kern_hyp_va(&kvm_arm_hyp_percpu_base[0]);

There is no guarantee that this will not generate a PC relative
addressing, resulting in kern_hyp_va() being applied twice.

Consider using hyp_symbol_addr() instead, which always does the right
by forcing a PC relative addressing and not subsequently mangling
the address.

> +	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
> +	return this_cpu_base - (unsigned long)&__per_cpu_start;

And this is the opposite case: if the compiler generates an absolute
address, you're toast. Yes, this is just as unlikely, but hey...
Same remedy should apply.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
