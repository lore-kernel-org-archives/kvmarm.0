Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41268C5517A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 13:18:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 715E82074B
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 13:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kswMQ0HC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 715E82074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B64454B93E;
	Wed, 11 Nov 2020 08:18:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DLVyBcTdQnfh; Wed, 11 Nov 2020 08:18:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 637E54B687;
	Wed, 11 Nov 2020 08:18:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B88244B687
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 08:18:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tpLighG13ZrK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 08:18:36 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44E284B66F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 08:18:36 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BE975206CA;
 Wed, 11 Nov 2020 13:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605100714;
 bh=2UjjwH5biuFlA50cCFnf82KlU1eXrzuyTr+6/ZrA9eU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=kswMQ0HCpUJxy8M8bcxw4/NcKntRa1348ErHx3OUNO+Ips8QtfBPgIdbOwulX37D4
 j0Feoeuw7hV9UWdH+Tu3Lsru9fZuorX1RzbBnwthDjFLulnha+r5ryib8OlEoJVsbt
 HNCIT9zMXs8AUs1LpCcbRdd3t3oUTZp9Bgiyls60=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcq1A-009lkV-Hr; Wed, 11 Nov 2020 13:18:32 +0000
MIME-Version: 1.0
Date: Wed, 11 Nov 2020 13:18:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 15/24] kvm: arm64: Bootstrap PSCI SMC handler in nVHE
 EL2
In-Reply-To: <20201109113233.9012-16-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-16-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <46c6df6087535d61146db7553a7b1e44@kernel.org>
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
> Add a handler of PSCI SMCs in nVHE hyp code. The handler is initialized
> with the version used by the host's PSCI driver and the function IDs it
> was configured with. If the SMC function ID matches one of the
> configured PSCI calls (for v0.1) or falls into the PSCI function ID
> range (for v0.2+), the SMC is handled by the PSCI handler. For now, all
> SMCs return PSCI_RET_NOT_SUPPORTED.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h   |   4 ++
>  arch/arm64/kvm/arm.c               |  13 ++++
>  arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |   4 ++
>  arch/arm64/kvm/hyp/nvhe/psci.c     | 102 +++++++++++++++++++++++++++++
>  include/uapi/linux/psci.h          |   1 +
>  6 files changed, 125 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/psci.c
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h 
> b/arch/arm64/include/asm/kvm_hyp.h
> index a3289071f3d8..95a2bbbcc7e1 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -96,6 +96,10 @@ void deactivate_traps_vhe_put(void);
> 
>  u64 __guest_enter(struct kvm_vcpu *vcpu);
> 
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
> +#endif
> +
>  void __noreturn hyp_panic(void);
>  #ifdef __KVM_NVHE_HYPERVISOR__
>  void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, 
> u64 par);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1a57b6025937..28e3bc056225 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -19,6 +19,7 @@
>  #include <linux/kvm_irqfd.h>
>  #include <linux/irqbypass.h>
>  #include <linux/sched/stat.h>
> +#include <linux/psci.h>
>  #include <trace/events/kvm.h>
> 
>  #define CREATE_TRACE_POINTS
> @@ -1498,6 +1499,17 @@ static void init_cpu_logical_map(void)
>  		CHOOSE_NVHE_SYM(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
>  }
> 
> +static void init_psci(void)

nit: init_psci_relay?

> +{
> +	extern u32 kvm_nvhe_sym(kvm_host_psci_version);
> +	extern u32 kvm_nvhe_sym(kvm_host_psci_function_id)[PSCI_FN_MAX];
> +	int i;
> +
> +	CHOOSE_NVHE_SYM(kvm_host_psci_version) = psci_driver_version();
> +	for (i = 0; i < PSCI_FN_MAX; ++i)
> +		CHOOSE_NVHE_SYM(kvm_host_psci_function_id)[i] = 
> psci_get_function_id(i);
> +}
> +
>  static int init_common_resources(void)
>  {
>  	return kvm_set_ipa_limit();
> @@ -1677,6 +1689,7 @@ static int init_hyp_mode(void)
>  	}
> 
>  	init_cpu_logical_map();
> +	init_psci();
> 
>  	return 0;
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile 
> b/arch/arm64/kvm/hyp/nvhe/Makefile
> index c45f440cce51..647b63337a51 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -7,7 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
> 
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o 
> host.o \
> -	 hyp-main.o percpu.o
> +	 hyp-main.o percpu.o psci.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o 
> ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 8661bc7deaa9..69f34d4f2773 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -134,6 +134,10 @@ static void handle_host_smc(struct
> kvm_cpu_context *host_ctxt)
>  	 */
>  	skip_host_instruction();
> 
> +	/* Try to handle host's PSCI SMCs. */
> +	if (kvm_host_psci_handler(host_ctxt))
> +		return;
> +
>  	/* Forward SMC not handled in EL2 to EL3. */
>  	forward_host_smc(host_ctxt);
>  }
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c 
> b/arch/arm64/kvm/hyp/nvhe/psci.c
> new file mode 100644
> index 000000000000..82d3b2c89658
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/psci.c

nit: can we please name this psci-relay.c, or psci-proxy.c?
We already have a psci.c in the tree, and having the same file name 
messes
with my editor... ;-)

> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 - Google LLC
> + * Author: David Brazdil <dbrazdil@google.com>
> + */
> +
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>
> +#include <kvm/arm_hypercalls.h>
> +#include <linux/arm-smccc.h>
> +#include <linux/psci.h>
> +#include <kvm/arm_psci.h>
> +#include <uapi/linux/psci.h>
> +
> +/* Config options set by the host. */
> +u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
> +u32 kvm_host_psci_function_id[PSCI_FN_MAX];
> +
> +static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
> +{
> +	return host_ctxt->regs.regs[0];
> +}
> +
> +static bool is_psci_0_1_call(u64 func_id)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(kvm_host_psci_function_id); ++i) {
> +		if (func_id == kvm_host_psci_function_id[i])
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static bool is_psci_0_2_fn_call(u64 func_id)
> +{
> +	u64 base = func_id & ~PSCI_0_2_FN_ID_MASK;
> +
> +	return base == PSCI_0_2_FN_BASE || base == PSCI_0_2_FN64_BASE;

I couldn't spot in the spec where PSCI reserves 16bit worth of IDs in
each range.

> +}
> +
> +static bool is_psci_call(u64 func_id)
> +{
> +	if (kvm_host_psci_version == PSCI_VERSION(0, 0))
> +		return false;
> +	else if (kvm_host_psci_version == PSCI_VERSION(0, 1))
> +		return is_psci_0_1_call(func_id);
> +	else
> +		return is_psci_0_2_fn_call(func_id);

Consider using switch/case constructs for readability.

> +}
> +
> +static unsigned long psci_0_1_handler(u64 func_id, struct
> kvm_cpu_context *host_ctxt)
> +{
> +	return PSCI_RET_NOT_SUPPORTED;
> +}
> +
> +static unsigned long psci_0_2_handler(u64 func_id, struct
> kvm_cpu_context *host_ctxt)
> +{
> +	switch (func_id) {
> +	default:
> +		return PSCI_RET_NOT_SUPPORTED;
> +	}
> +}
> +
> +static unsigned long psci_1_0_handler(u64 func_id, struct
> kvm_cpu_context *host_ctxt)
> +{
> +	int ret;
> +
> +	ret = psci_0_2_handler(func_id, host_ctxt);
> +	if (ret != PSCI_RET_NOT_SUPPORTED)
> +		return ret;
> +
> +	switch (func_id) {
> +	default:
> +		return PSCI_RET_NOT_SUPPORTED;
> +	}

It would probably help to adopt the same structure as we have in the
KVM PSCI implementation:

	switch(psci_fn) {
	case PSCI_0_2_FN_PSCI_VERSION:
		val = KVM_ARM_PSCI_1_0;
		break;

         [...]
	default:
		return kvm_psci_0_2_call(vcpu);

which allows 1.0 to override some 0.2 functions, and otherwise leave
it to the 0.2 backend.

> +}
> +
> +bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt)
> +{
> +	u64 func_id = get_psci_func_id(host_ctxt);
> +	unsigned long ret;
> +
> +	if (!is_psci_call(func_id))
> +		return false;
> +
> +	if (kvm_host_psci_version == PSCI_VERSION(0, 1))
> +		ret = psci_0_1_handler(func_id, host_ctxt);
> +	else if (kvm_host_psci_version == PSCI_VERSION(0, 2))
> +		ret = psci_0_2_handler(func_id, host_ctxt);
> +	else if (PSCI_VERSION_MAJOR(kvm_host_psci_version) >= 1)
> +		ret = psci_1_0_handler(func_id, host_ctxt);
> +	else
> +		ret = PSCI_RET_NOT_SUPPORTED;

Same remark about the use of switch/case.

> +
> +	host_ctxt->regs.regs[0] = ret;
> +	host_ctxt->regs.regs[1] = 0;
> +	host_ctxt->regs.regs[2] = 0;
> +	host_ctxt->regs.regs[3] = 0;
> +	return true;
> +}
> diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
> index 2fcad1dd0b0e..0d52b8dbe8c2 100644
> --- a/include/uapi/linux/psci.h
> +++ b/include/uapi/linux/psci.h
> @@ -29,6 +29,7 @@
>  #define PSCI_0_2_FN64_BASE			\
>  					(PSCI_0_2_FN_BASE + PSCI_0_2_64BIT)
>  #define PSCI_0_2_FN64(n)			(PSCI_0_2_FN64_BASE + (n))
> +#define PSCI_0_2_FN_ID_MASK			0xffff
> 
>  #define PSCI_0_2_FN_PSCI_VERSION		PSCI_0_2_FN(0)
>  #define PSCI_0_2_FN_CPU_SUSPEND			PSCI_0_2_FN(1)

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
