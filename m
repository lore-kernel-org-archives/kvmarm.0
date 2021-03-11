Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D90C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 19:36:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8B3464F70
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 19:36:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8B3464F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C57B4B49A;
	Thu, 11 Mar 2021 14:36:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G2ZsaNtie-cX; Thu, 11 Mar 2021 14:36:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D60F94B4B6;
	Thu, 11 Mar 2021 14:36:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E344B49A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 14:36:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zCURyPkSGGlJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 14:36:49 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06D9D4B470
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 14:36:48 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A466864F6A;
 Thu, 11 Mar 2021 19:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615491406;
 bh=63tmpZ5mQVPPLqeqb+wmvXJ9fc25KQP2XqeO4yS0/jY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=HZ4y5yX6mn85uBntb/Oq3wAGEJJCLmygUsHwJIFJt8aZbeHP68kV0RI1X2JsB6N5o
 49c1rXqLbxLQbmSX6swwoqbCyZRSPEB5XKf5xgNmJ6QVeVgIQ8qggREs7IaM4rtLzD
 0fbE0klrepnYrK7cXPJw2tPS5DMQwNll52VB1fVyq6/XUzfKJMX2GObPRra9MlA7O0
 +JipwV5Hd8BT5aiYHcUAin6pzlh6ulg+4b0xPV5IkdeNIFgVkwhQnryfq+z1Te5snW
 Wx+cY5oxlLYgXErbxu+iZmd0dn7QWDy6A4dcYHxYH6VLg5VbmVxb1GmhR1B6ykzYxu
 weHYTYT+NbqLQ==
Date: Thu, 11 Mar 2021 19:36:39 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 13/34] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <20210311193638.GE31586@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-14-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310175751.3320106-14-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 10, 2021 at 05:57:30PM +0000, Quentin Perret wrote:
> Introduce the infrastructure in KVM enabling to copy CPU feature
> registers into EL2-owned data-structures, to allow reading sanitised
> values directly at EL2 in nVHE.
> 
> Given that only a subset of these features are being read by the
> hypervisor, the ones that need to be copied are to be listed under
> <asm/kvm_cpufeature.h> together with the name of the nVHE variable that
> will hold the copy.
> 
> While at it, introduce the first user of this infrastructure by
> implementing __flush_dcache_area at EL2, which needs
> arm64_ftr_reg_ctrel0.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h     |  1 +
>  arch/arm64/include/asm/kvm_cpufeature.h | 17 +++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h       |  4 ++++
>  arch/arm64/kernel/cpufeature.c          | 13 +++++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++++
>  arch/arm64/kvm/hyp/nvhe/cpufeature.c    |  8 ++++++++
>  arch/arm64/kvm/sys_regs.c               | 21 +++++++++++++++++++++
>  8 files changed, 79 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_cpufeature.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cpufeature.c
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 61177bac49fa..a85cea2cac57 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -607,6 +607,7 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  u64 __read_sysreg_by_encoding(u32 sys_id);
> +int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst);
>  
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
> new file mode 100644
> index 000000000000..d34f85cba358
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_cpufeature.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2020 - Google LLC
> + * Author: Quentin Perret <qperret@google.com>
> + */
> +
> +#include <asm/cpufeature.h>
> +
> +#ifndef KVM_HYP_CPU_FTR_REG
> +#if defined(__KVM_NVHE_HYPERVISOR__)
> +#define KVM_HYP_CPU_FTR_REG(id, name) extern struct arm64_ftr_reg name;
> +#else
> +#define KVM_HYP_CPU_FTR_REG(id, name) DECLARE_KVM_NVHE_SYM(name);
> +#endif
> +#endif
> +
> +KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 06ca4828005f..459ee557f87c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -751,9 +751,13 @@ void kvm_clr_pmu_events(u32 clr);
>  
>  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> +
> +void setup_kvm_el2_caps(void);
>  #else
>  static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
>  static inline void kvm_clr_pmu_events(u32 clr) {}
> +
> +static inline void setup_kvm_el2_caps(void) {}
>  #endif
>  
>  void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 066030717a4c..f2d8b479ff74 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1154,6 +1154,18 @@ u64 read_sanitised_ftr_reg(u32 id)
>  }
>  EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
>  
> +int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst)
> +{
> +	struct arm64_ftr_reg *regp = get_arm64_ftr_reg(id);
> +
> +	if (!regp)
> +		return -EINVAL;
> +
> +	memcpy(dst, regp, sizeof(*regp));

Can you not just use struct assignment here?

> diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
> new file mode 100644
> index 000000000000..36cef6915428
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/cache.S
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Code copied from arch/arm64/mm/cache.S.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +#include <asm/alternative.h>
> +
> +SYM_FUNC_START_PI(__flush_dcache_area)
> +	dcache_by_line_op civac, sy, x0, x1, x2, x3
> +	ret
> +SYM_FUNC_END_PI(__flush_dcache_area)

Separate patch for this? (or fold it into that one really near the start
that introduces some other PI helpers).

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4f2f1e3145de..84be93df52fa 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -21,6 +21,7 @@
>  #include <asm/debug-monitors.h>
>  #include <asm/esr.h>
>  #include <asm/kvm_arm.h>
> +#include <asm/kvm_cpufeature.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> @@ -2775,3 +2776,23 @@ void kvm_sys_reg_table_init(void)
>  	/* Clear all higher bits. */
>  	cache_levels &= (1 << (i*3))-1;
>  }
> +
> +#undef KVM_HYP_CPU_FTR_REG
> +#define KVM_HYP_CPU_FTR_REG(id, name) \
> +	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) },
> +struct __ftr_reg_copy_entry {
> +	u32			sys_id;
> +	struct arm64_ftr_reg	*dst;
> +} hyp_ftr_regs[] __initdata = {
> +	#include <asm/kvm_cpufeature.h>
> +};

This looks a bit elaborate to me. Why can't you just spell things out here
like:

#define KVM_HYP_CPU_FTR_REG(id, name) \
	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) }

struct __ftr_reg_copy_entry {
	u32			sys_id;
	struct arm64_ftr_reg	*dst;
} hyp_ftr_regs[] __initdata = {
	KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0),
	...
};

and then have the header file be a normal, guarded header which just
declares these things? The id parameter to the macro isn't used there.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
