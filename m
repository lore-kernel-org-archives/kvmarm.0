Return-Path: <SRS0=w/1t=MB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7D4C11F68
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D18F2613E3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D18F2613E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dme.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CC7C4A4A3;
	Fri,  9 Jul 2021 05:25:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@messagingengine.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ws2HTsnf7Kh7; Fri,  9 Jul 2021 05:25:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82C84A126;
	Fri,  9 Jul 2021 05:25:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9BA04A00B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 03:39:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8y1TybG0ykkR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jul 2021 03:39:33 -0400 (EDT)
Received: from wforward3-smtp.messagingengine.com
 (wforward3-smtp.messagingengine.com [64.147.123.22])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2428D4A003
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 03:39:33 -0400 (EDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailforward.west.internal (Postfix) with ESMTP id D094C1AC0BB7;
 Fri,  9 Jul 2021 03:39:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute1.internal (MEProxy); Fri, 09 Jul 2021 03:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:content-type:date:from:in-reply-to
 :message-id:mime-version:references:subject:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MmHFnw
 D/vmxcyGTiVsUB3xcr0vIvVuonBri13Nc/hoQ=; b=dm42RkXa9CJmEzzkU8nqBu
 tNmNCcqCxT7yDVOKm0rew1blS/qzmArSFBYihxyR8jY6xHecfphzeTr1BWoUvP27
 vvdpcxWgnzvfdq6C6n7rlCEIZ045x5Ia/p8dijh9lwLdQuAB+E0NUKjgqMPB56nf
 jUN3izzXUx0iQkW7g4akBMBaMXSHmm4rbTaJ8mYkg2kP0sB4jcYMDM35gEJjwMql
 4Gv5QcBCEMa8PoSPH7vo1tciAaAkcMO1chF2J2dfJCl29FnWlVVoLNVQiyBCa7xC
 Sse7KZbVp1CdUxbAM1DpyzxGb6fFswBwFlujO1LXbQsrMiglpBB95YT9sjMl14rA
 ==
X-ME-Sender: <xms:L_3nYH6pJYCdu9DukapH1cxQaMXD3kTQ_pFlbw8GSsR9lKr878lUqQ>
 <xme:L_3nYM56bjKLvJI9cJtYzz2uwMgwnA6QHHtcbwV43U0N7d4RKem6W6M8BGpG-FTsW
 ciSROlYoA5w0906Acw>
X-ME-Received: <xmr:L_3nYOe1p4wuFn4JqZsWJFF3uRJTQFOpSr4ixsms3_AsmzofkzP2lg4Br1aMnKRDJjYjM2IlGd_85CAE72Me5Z71BFdxSSzfN5sE6mqgVYY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdehgdelgecutefuodetggdotefrodftvf
 curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
 uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
 fjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfg
 ughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnheptd
 dtgedttefhfeeugefffffffedvueekgfduhfevueehvdekveeitdelledvteetnecuffho
 mhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
 grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:L_3nYIJprdiY3kq9jVwTHx8V_1TBkGyYhljf8ZgCjSTM1eNEBZHkeQ>
 <xmx:L_3nYLJ8vEpEsKA1fCYLtWg5-igtzJ_LQetwgrU-SNE9UiMH0r06xg>
 <xmx:L_3nYBygR_vZJKqlI2JaXJLlqiupxa4T36xIioyf__gEekqS9IXL-w>
 <xmx:MP3nYICf40OXZZ1Knph_CH3Y3cMmrkMrtBsZkpwdHCLhHVLppHbrnncJi-c>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Jul 2021 03:39:26 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
 by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 58528b94;
 Fri, 9 Jul 2021 07:39:25 +0000 (UTC)
To: Sergey Senozhatsky <senozhatsky@chromium.org>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCHv2 2/4] arm64: add guest pvstate support
In-Reply-To: <20210709043713.887098-3-senozhatsky@chromium.org>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-3-senozhatsky@chromium.org>
X-HGTTG: heart-of-gold
From: David Edmondson <dme@dme.org>
Date: Fri, 09 Jul 2021 08:39:25 +0100
Message-ID: <m2v95k2axe.fsf@dme.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 09 Jul 2021 05:25:42 -0400
Cc: Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Friday, 2021-07-09 at 13:37:11 +09, Sergey Senozhatsky wrote:

> PV-vcpu-state is a per-CPU struct, which, for the time being,
> holds boolean `preempted' vCPU state. During the startup,
> given that host supports PV-state, each guest vCPU sends
> a pointer to its per-CPU variable to the host as a payload
> with the SMCCC HV call, so that host can update vCPU state
> when it puts or loads vCPU.
>
> This has impact on the guest's scheduler:
>
> [..]
>   wake_up_process()
>    try_to_wake_up()
>     select_task_rq_fair()
>      available_idle_cpu()
>       vcpu_is_preempted()
>
> Some sched benchmarks data is available on the github page [0].
>
> [0] https://github.com/sergey-senozhatsky/arm64-vcpu_is_preempted
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  arch/arm64/include/asm/paravirt.h | 19 +++++++
>  arch/arm64/kernel/paravirt.c      | 94 +++++++++++++++++++++++++++++++
>  arch/arm64/kernel/smp.c           |  4 ++
>  3 files changed, 117 insertions(+)
>
> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
> index 9aa193e0e8f2..a3f7665dff38 100644
> --- a/arch/arm64/include/asm/paravirt.h
> +++ b/arch/arm64/include/asm/paravirt.h
> @@ -2,6 +2,11 @@
>  #ifndef _ASM_ARM64_PARAVIRT_H
>  #define _ASM_ARM64_PARAVIRT_H
>  
> +struct vcpu_state {
> +	bool	preempted;
> +	u8	reserved[63];
> +};
> +
>  #ifdef CONFIG_PARAVIRT
>  #include <linux/static_call_types.h>
>  
> @@ -20,8 +25,22 @@ static inline u64 paravirt_steal_clock(int cpu)
>  
>  int __init pv_time_init(void);
>  
> +bool dummy_vcpu_is_preempted(unsigned int cpu);
> +
> +extern struct static_key pv_vcpu_is_preempted_enabled;
> +DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
> +
> +static inline bool paravirt_vcpu_is_preempted(unsigned int cpu)
> +{
> +	return static_call(pv_vcpu_is_preempted)(cpu);
> +}
> +
> +int __init pv_vcpu_state_init(void);
> +
>  #else
>  
> +#define pv_vcpu_state_init() do {} while (0)
> +
>  #define pv_time_init() do {} while (0)
>  
>  #endif // CONFIG_PARAVIRT
> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> index 75fed4460407..d8fc46795d94 100644
> --- a/arch/arm64/kernel/paravirt.c
> +++ b/arch/arm64/kernel/paravirt.c
> @@ -40,6 +40,11 @@ struct pv_time_stolen_time_region {
>  
>  static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
>  
> +static DEFINE_PER_CPU(struct vcpu_state, vcpus_states);
> +struct static_key pv_vcpu_is_preempted_enabled;
> +
> +DEFINE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
> +
>  static bool steal_acc = true;
>  static int __init parse_no_stealacc(char *arg)
>  {
> @@ -165,3 +170,92 @@ int __init pv_time_init(void)
>  
>  	return 0;
>  }
> +
> +bool dummy_vcpu_is_preempted(unsigned int cpu)
> +{
> +	return false;
> +}
> +
> +static bool __vcpu_is_preempted(unsigned int cpu)
> +{
> +	struct vcpu_state *st;
> +
> +	st = &per_cpu(vcpus_states, cpu);
> +	return READ_ONCE(st->preempted);
> +}
> +
> +static bool has_pv_vcpu_state(void)
> +{
> +	struct arm_smccc_res res;
> +
> +	/* To detect the presence of PV time support we require SMCCC 1.1+ */

"PV VCPU state support" rather than "PV time support".

> +	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
> +		return false;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> +			     ARM_SMCCC_HV_PV_VCPU_STATE_FEATURES,
> +			     &res);
> +
> +	if (res.a0 != SMCCC_RET_SUCCESS)
> +		return false;
> +	return true;
> +}
> +
> +static int __pv_vcpu_state_hook(unsigned int cpu, int event)
> +{
> +	struct arm_smccc_res res;
> +	struct vcpu_state *st;
> +
> +	st = &per_cpu(vcpus_states, cpu);
> +	arm_smccc_1_1_invoke(event, virt_to_phys(st), &res);
> +	if (res.a0 != SMCCC_RET_SUCCESS)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int vcpu_state_init(unsigned int cpu)
> +{
> +	int ret = __pv_vcpu_state_hook(cpu, ARM_SMCCC_HV_PV_VCPU_STATE_INIT);
> +
> +	if (ret)
> +		pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_INIT\n");
> +	return ret;
> +}
> +
> +static int vcpu_state_release(unsigned int cpu)
> +{
> +	int ret = __pv_vcpu_state_hook(cpu, ARM_SMCCC_HV_PV_VCPU_STATE_RELEASE);
> +
> +	if (ret)
> +		pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_RELEASE\n");
> +	return ret;
> +}
> +
> +static int pv_vcpu_state_register_hooks(void)
> +{
> +	int ret;
> +
> +	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
> +				"hypervisor/arm/pvstate:starting",
> +				vcpu_state_init,
> +				vcpu_state_release);
> +	if (ret < 0)
> +		pr_warn("Failed to register CPU hooks\n");

Include that it's PV VCPU state hooks?

> +	return 0;
> +}
> +
> +int __init pv_vcpu_state_init(void)
> +{
> +	int ret;
> +
> +	if (!has_pv_vcpu_state())
> +		return 0;
> +
> +	ret = pv_vcpu_state_register_hooks();
> +	if (ret)
> +		return ret;
> +
> +	static_call_update(pv_vcpu_is_preempted, __vcpu_is_preempted);
> +	static_key_slow_inc(&pv_vcpu_is_preempted_enabled);
> +	return 0;
> +}
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 6f6ff072acbd..20d42e0f2a99 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -50,6 +50,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/ptrace.h>
>  #include <asm/virt.h>
> +#include <asm/paravirt.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ipi.h>
> @@ -756,6 +757,9 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>  	numa_store_cpu_info(this_cpu);
>  	numa_add_cpu(this_cpu);
>  
> +	/* Init paravirt CPU state */
> +	pv_vcpu_state_init();
> +
>  	/*
>  	 * If UP is mandated by "nosmp" (which implies "maxcpus=0"), don't set
>  	 * secondary CPUs present.
> -- 
> 2.32.0.93.g670b81a890-goog

dme.
-- 
If I could buy my reasoning, I'd pay to lose.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
