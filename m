Return-Path: <SRS0=dXrF=MC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277D0C07E95
	for <kvmarm@archiver.kernel.org>; Sat, 10 Jul 2021 10:18:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B5EC613C3
	for <kvmarm@archiver.kernel.org>; Sat, 10 Jul 2021 10:18:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B5EC613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3C0F4086D;
	Sat, 10 Jul 2021 06:18:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MH26xMhkm18Q; Sat, 10 Jul 2021 06:18:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99CB240C88;
	Sat, 10 Jul 2021 06:18:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EC7940870
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 14:58:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qsxO6u5+Nrl4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jul 2021 14:58:24 -0400 (EDT)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com
 [209.85.222.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 474774086F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 14:58:24 -0400 (EDT)
Received: by mail-qk1-f181.google.com with SMTP id i125so10313399qke.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Jul 2021 11:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1Rq09e4FzKVmC8coozmBf2Y4P9tsiDVwZ27Wjq/A92M=;
 b=DXZ7xOOrb+im+tg33i8mbTwsKlZOJPAfSLVS1lRsLDqp2+R0vdcuS+0zSmf1hozWid
 h8N38TsVQ1QPBClHpe5emLu45mi3w5tBd5vkYjiI6beSJjrXTQS9Lis5m+m60gBYrsC3
 Jtaz1JParBBvM4YHj99L6tC2DD0jJWHj3QIQZ+3nIZDUcW68SbAYvmvI8sPsQ8rrBf9m
 DIbU5xPKHNZtJodbP2/6ps301q+e0hoyKM6Fse04usXf1IDGbmbscr/M14PPeovJ8vNW
 Z0jX0S9BplBgXLHzIJNTXSkc81ZwJBu7AYVTyYRZxK2MfH9BfbKUzQx/G8a7Ik/pB8aU
 o1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1Rq09e4FzKVmC8coozmBf2Y4P9tsiDVwZ27Wjq/A92M=;
 b=R45zziUmKp6FEdWkHyztizaOHK9K8gaTKzbtp9Gb9DNpHeDKY98CXWOa5z9NjzPLpC
 rz6xjyXxcWcEmEC6F8aexvCH9et5ntYOJ625AWYyHO+c/ZJHlc4EcQvgWee9bVctksUV
 5SntL4FXz9nygzsGWW8ytIN8w+AazGCzp7IqaxpYjOOfnZP2fCtWshTKLWU+hhlwr1zw
 AUfU6SfNEUNOjqov4YR9p0quZokuxw5fuAxYMbEMgxzJ+H1ysHn1CqOaQ2lZVnKcLug7
 FmLw6pmVdLCVuTtdGm3CU9+f7n0pDMaruWPj4U/KmAVWmxtlOQ/CIl3lyOjgsSbbBOUr
 gO8g==
X-Gm-Message-State: AOAM531962O1rRu/DlIApjX7zKgPH/cJ/UMr437e/MdtPspAsfQiz2sY
 n8jfYeaW9Q/sM8ZX2ok7qy5ka/D9FvaKBzo9+Li3jg==
X-Google-Smtp-Source: ABdhPJx38EbV1FTTGhhuDjA8CTzpk9q6mzakZBUDCGz1zQ1TzLXHZcfuZU3Lo65MlCEwO1gJjRbol4iuazm9D4flAsc=
X-Received: by 2002:ae9:dd43:: with SMTP id r64mr38651885qkf.216.1625857103581; 
 Fri, 09 Jul 2021 11:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-3-senozhatsky@chromium.org>
In-Reply-To: <20210709043713.887098-3-senozhatsky@chromium.org>
From: Joel Fernandes <joelaf@google.com>
Date: Fri, 9 Jul 2021 14:58:11 -0400
Message-ID: <CAJWu+opFedsq6CdgUYErnxsv3-Pr7MHi0vz9=hhpMCujFPp8+A@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] arm64: add guest pvstate support
To: Sergey Senozhatsky <senozhatsky@chromium.org>
X-Mailman-Approved-At: Sat, 10 Jul 2021 06:18:40 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi, Just few nits, patch itself LGTM:

On Fri, Jul 9, 2021 at 12:37 AM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
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
> +       bool    preempted;
> +       u8      reserved[63];
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
> +extern struct static_key pv_vcpu_is_preempted_enabled;.

pv_vcpu_is_preempted_enabled static_key is not used in any patch.
Maybe it is stale?

> +DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
> +
> +static inline bool paravirt_vcpu_is_preempted(unsigned int cpu)
> +{
> +       return static_call(pv_vcpu_is_preempted)(cpu);
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

Could we use DEFINE_STATIC_CALL_NULL and get rid of the dummy
function? I believe that makes the function trampoline as return
instruction, till it is updated.

> +
>  static bool steal_acc = true;
>  static int __init parse_no_stealacc(char *arg)
>  {
> @@ -165,3 +170,92 @@ int __init pv_time_init(void)
>
>         return 0;
>  }
> +
> +bool dummy_vcpu_is_preempted(unsigned int cpu)
> +{
> +       return false;
> +}
> +
> +static bool __vcpu_is_preempted(unsigned int cpu)
> +{
> +       struct vcpu_state *st;
> +
> +       st = &per_cpu(vcpus_states, cpu);
> +       return READ_ONCE(st->preempted);

I guess you could just do:
{
  return READ_ONCE(per_cpu(vcpus_states, cpu).preempted);
}

> +}
> +
> +static bool has_pv_vcpu_state(void)
> +{
> +       struct arm_smccc_res res;
> +
> +       /* To detect the presence of PV time support we require SMCCC 1.1+ */
> +       if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
> +               return false;
> +
> +       arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> +                            ARM_SMCCC_HV_PV_VCPU_STATE_FEATURES,
> +                            &res);
> +
> +       if (res.a0 != SMCCC_RET_SUCCESS)
> +               return false;
> +       return true;
> +}
> +
> +static int __pv_vcpu_state_hook(unsigned int cpu, int event)
> +{
> +       struct arm_smccc_res res;
> +       struct vcpu_state *st;
> +
> +       st = &per_cpu(vcpus_states, cpu);
> +       arm_smccc_1_1_invoke(event, virt_to_phys(st), &res);
> +       if (res.a0 != SMCCC_RET_SUCCESS)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int vcpu_state_init(unsigned int cpu)
> +{
> +       int ret = __pv_vcpu_state_hook(cpu, ARM_SMCCC_HV_PV_VCPU_STATE_INIT);
> +
> +       if (ret)
> +               pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_INIT\n");
> +       return ret;
> +}
> +
> +static int vcpu_state_release(unsigned int cpu)
> +{
> +       int ret = __pv_vcpu_state_hook(cpu, ARM_SMCCC_HV_PV_VCPU_STATE_RELEASE);
> +
> +       if (ret)
> +               pr_warn("Unable to ARM_SMCCC_HV_PV_STATE_RELEASE\n");
> +       return ret;
> +}
> +
> +static int pv_vcpu_state_register_hooks(void)
> +{
> +       int ret;
> +
> +       ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
> +                               "hypervisor/arm/pvstate:starting",
> +                               vcpu_state_init,
> +                               vcpu_state_release);
> +       if (ret < 0)
> +               pr_warn("Failed to register CPU hooks\n");
> +       return 0;
> +}
> +
> +int __init pv_vcpu_state_init(void)
> +{
> +       int ret;
> +
> +       if (!has_pv_vcpu_state())
> +               return 0;
> +
> +       ret = pv_vcpu_state_register_hooks();
> +       if (ret)
> +               return ret;
> +
> +       static_call_update(pv_vcpu_is_preempted, __vcpu_is_preempted);
> +       static_key_slow_inc(&pv_vcpu_is_preempted_enabled);

I think this static key inc is also stale.

thanks,

-Joel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
