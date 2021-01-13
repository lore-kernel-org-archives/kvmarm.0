Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBE6C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 11:33:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1E7D233F6
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 11:33:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1E7D233F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06B2B4B1F5;
	Wed, 13 Jan 2021 06:33:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T5x2mh7yFUQ4; Wed, 13 Jan 2021 06:33:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9814B1EA;
	Wed, 13 Jan 2021 06:33:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A48BD4B1EA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 06:33:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dStAvcy6FNnZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 06:33:17 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F5684B0F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 06:33:17 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DA900233EF;
 Wed, 13 Jan 2021 11:33:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kzeOn-007Epc-Ma; Wed, 13 Jan 2021 11:33:13 +0000
MIME-Version: 1.0
Date: Wed, 13 Jan 2021 11:33:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 13/26] KVM: arm64: Enable access to sanitized CPU
 features at EL2
In-Reply-To: <20210108121524.656872-14-qperret@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-14-qperret@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <d55643ea391f73a2297f499f3219ba8a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, catalin.marinas@arm.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 robh+dt@kernel.org, frowand.list@gmail.com, devicetree@vger.kernel.org,
 android-kvm@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 tabba@google.com, mark.rutland@arm.com, dbrazdil@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: devicetree@vger.kernel.org, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

Hi Quentin,

On 2021-01-08 12:15, Quentin Perret wrote:
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
>  arch/arm64/include/asm/kvm_cpufeature.h | 17 ++++++++++++++
>  arch/arm64/kernel/cpufeature.c          | 12 ++++++++++
>  arch/arm64/kvm/arm.c                    | 31 +++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/cpufeature.c    |  8 +++++++
>  7 files changed, 84 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_cpufeature.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cpufeature.c
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h
> b/arch/arm64/include/asm/cpufeature.h
> index 16063c813dcd..742e9bcc051b 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -600,6 +600,7 @@ void __init setup_cpu_features(void);
>  void check_local_cpu_capabilities(void);
> 
>  u64 read_sanitised_ftr_reg(u32 id);
> +int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst);
> 
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/include/asm/kvm_cpufeature.h
> b/arch/arm64/include/asm/kvm_cpufeature.h
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
> +#define KVM_HYP_CPU_FTR_REG(id, name) extern struct arm64_ftr_reg 
> name;
> +#else
> +#define KVM_HYP_CPU_FTR_REG(id, name) DECLARE_KVM_NVHE_SYM(name);
> +#endif
> +#endif
> +
> +KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0)
> diff --git a/arch/arm64/kernel/cpufeature.c 
> b/arch/arm64/kernel/cpufeature.c
> index bc3549663957..c2019aaaadc3 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1113,6 +1113,18 @@ u64 read_sanitised_ftr_reg(u32 id)
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
> +
> +	return 0;
> +}
> +
>  #define read_sysreg_case(r)	\
>  	case r:		return read_sysreg_s(r)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 51b53ca36dc5..9fd769349e9e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -34,6 +34,7 @@
>  #include <asm/virt.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_cpufeature.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
> @@ -1697,6 +1698,29 @@ static void teardown_hyp_mode(void)
>  	}
>  }
> 
> +#undef KVM_HYP_CPU_FTR_REG
> +#define KVM_HYP_CPU_FTR_REG(id, name) \
> +	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) },
> +static const struct __ftr_reg_copy_entry {
> +	u32			sys_id;
> +	struct arm64_ftr_reg	*dst;

Why do we need the whole data structure? Can't we just live with 
sys_val?

> +} hyp_ftr_regs[] = {
> +	#include <asm/kvm_cpufeature.h>
> +};

Can't this be made __initdata?

> +
> +static int copy_cpu_ftr_regs(void)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(hyp_ftr_regs); i++) {
> +		ret = copy_ftr_reg(hyp_ftr_regs[i].sys_id, hyp_ftr_regs[i].dst);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * Inits Hyp-mode on all online CPUs
>   */
> @@ -1705,6 +1729,13 @@ static int init_hyp_mode(void)
>  	int cpu;
>  	int err = 0;
> 
> +	/*
> +	 * Copy the required CPU feature register in their EL2 counterpart
> +	 */
> +	err = copy_cpu_ftr_regs();
> +	if (err)
> +		return err;
> +

Just to keep things together, please move any sysreg manipulation into
sys_regs.c, most probably into kvm_sys_reg_table_init().

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
