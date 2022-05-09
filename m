Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0BCC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 20:21:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 035D54B25F;
	Mon,  9 May 2022 16:21:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ymKMnbjLhU4M; Mon,  9 May 2022 16:21:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3C624B26E;
	Mon,  9 May 2022 16:21:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FD874B25F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 16:21:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hcnrLjqE1Yx9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 16:21:51 -0400 (EDT)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
 [209.85.166.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EAE44B150
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 16:21:51 -0400 (EDT)
Received: by mail-il1-f175.google.com with SMTP id i22so10092211ila.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 13:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UcREA7BXivHZcoO141I3GT0yFqoEx7+7587siIxHTCs=;
 b=rzQHujXFmtG4GrbKAcEdZerC8MZayevox98SlYiOKBpHgZxI+MCs2qpXt81KogHQCi
 woMfL4FpqxFQeEzAVtm+qCLrPiYDMOkMX63WlVY1h9QFkVLSVtY9bdeoMx6iy01ZeZEh
 TtnRiBmNdZk7vPJamrjc+CMxxX46FGt/6gq45NewOxi6Sgigx92NRYjFw5MwAIXu2IVc
 EY8gVGhAy/r3j2RxjE1RWpYnXcaZAMiuU3RLP46ZGEXF/wcPyxtLHoGPEhDqUyk9fHi3
 DZYdhxpIkrY7SaFj2A64PbThu/aFwWfBnuhD4pzkGNtEOV5dMhAgWO0D8tG5jx25qSol
 TiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UcREA7BXivHZcoO141I3GT0yFqoEx7+7587siIxHTCs=;
 b=S541z/VoSl9Ffk2PsvZm1CVS0zKJQzZoCrSmZtvtUBssgR3B4BD7CPaH9PuwNmG94L
 02aR3zQ4YCQ7XXwtxc9voj04DBnuwdDiENLgcuwiUytfwntUja3nfoI+m8FATGrzNz5U
 3dVEvL7aynJZppByECcODH6tLloz7zT9R6Cs9jh4klwWV7OTnTk6WW/9X/p0ZIl9bRqe
 vc5B1Cn8kVFIhRdQhkO5RAx6T3qUQFgx38hO+BgXNHutgelCoM9JEIAEZoCQjLtUiXVM
 pVwBj0e68FqHS0AqsTWyXEOeVt+8EZYwcfBsTEk+gH2v8dT37Vz/aCtZOg4f4FVqaF2U
 MLgQ==
X-Gm-Message-State: AOAM532QTSqCz4kEtY3BTphQk7zPAVXMVy6BwDdP/yde1rIy3SWy/KP0
 orMlJJIwhBlAUTlDkW6N1asGeQ==
X-Google-Smtp-Source: ABdhPJzIg6TeygVAyYQlxXmyGBsqJKP8u8DBZXPknVy3rSzaza12eWCngsZhp+TCGq0KZEmun4BLzg==
X-Received: by 2002:a05:6e02:1bce:b0:2cf:7adc:7a99 with SMTP id
 x14-20020a056e021bce00b002cf7adc7a99mr7382010ilv.166.1652127710063; 
 Mon, 09 May 2022 13:21:50 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 m19-20020a023c13000000b0032b3a781781sm3794035jaa.69.2022.05.09.13.21.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 13:21:49 -0700 (PDT)
Date: Mon, 9 May 2022 20:21:45 +0000
From: Oliver Upton <oupton@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
Message-ID: <Ynl32cU6hkuXRQuZ@google.com>
References: <20220509120330.3043773-1-tabba@google.com>
 <20220509120330.3043773-4-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220509120330.3043773-4-tabba@google.com>
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, May 09, 2022 at 12:03:29PM +0000, Fuad Tabba wrote:
> Instead of the host accessing hyp data directly, pass the pmu
> events of the current cpu to hyp via the vcpu.
> 
> This adds 64 bits (in two fields) to the vcpu that need to be
> synced before every vcpu run in nvhe and protected modes.
> However, it isolates the hypervisor from the host, which allows
> us to use pmu in protected mode in a subsequent patch.
> 
> No visible side effects in behavior intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  8 ++------
>  arch/arm64/kvm/arm.c              | 15 +++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
>  arch/arm64/kvm/pmu.c              | 12 ++++--------
>  include/kvm/arm_pmu.h             |  6 ++++++
>  5 files changed, 33 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index dfd360404dd8..90476e713643 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -273,14 +273,8 @@ struct kvm_cpu_context {
>  	struct kvm_vcpu *__hyp_running_vcpu;
>  };
>  
> -struct kvm_pmu_events {
> -	u32 events_host;
> -	u32 events_guest;
> -};
> -

Looks like you're moving this to arm_pmu.h as well. Probably a better
home for it, but unclear why it is done in this patch.

>  struct kvm_host_data {
>  	struct kvm_cpu_context host_ctxt;
> -	struct kvm_pmu_events pmu_events;
>  };
>  

Are we going to need this struct any more since it now has a single
member?

>  struct kvm_host_psci_config {
> @@ -763,6 +757,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>  
>  DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
> +DECLARE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);

Why do you need this declaration? I don't see the percpu data being
accessed outside of pmu.c.

>  static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
>  {
> @@ -821,6 +816,7 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
>  void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
>  void kvm_clr_pmu_events(u32 clr);
>  
> +struct kvm_pmu_events *kvm_get_pmu_events(void);
>  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  #else
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2adb5832a756..86bcdb2a23a8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -817,6 +817,19 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +/*
> + * Updates the vcpu's view of the pmu events for this cpu.
> + * Must be called before every vcpu run after disabling interrupts, to ensure
> + * that an interrupt cannot fire and update the structure.
> + */
> +static void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu)
> +{
> +	if (has_vhe() || !kvm_vcpu_has_pmu(vcpu))
> +		return;
> +
> +	vcpu->arch.pmu.events = *kvm_get_pmu_events();
> +}
> +
>  /**
>   * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
>   * @vcpu:	The VCPU pointer
> @@ -882,6 +895,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  
>  		kvm_vgic_flush_hwstate(vcpu);
>  
> +		kvm_pmu_update_vcpu_events(vcpu);
> +
>  		/*
>  		 * Ensure we set mode to IN_GUEST_MODE after we disable
>  		 * interrupts and before the final VCPU requests check.
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 0716163313d6..c61120ec8d1a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -153,13 +153,9 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
>  /*
>   * Disable host events, enable guest events
>   */
> -static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> +static bool __pmu_switch_to_guest(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_host_data *host;
> -	struct kvm_pmu_events *pmu;
> -
> -	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> -	pmu = &host->pmu_events;
> +	struct kvm_pmu_events *pmu = &vcpu->arch.pmu.events;
>  
>  	if (pmu->events_host)
>  		write_sysreg(pmu->events_host, pmcntenclr_el0);
> @@ -173,13 +169,9 @@ static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
>  /*
>   * Disable guest events, enable host events
>   */
> -static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> +static void __pmu_switch_to_host(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_host_data *host;
> -	struct kvm_pmu_events *pmu;
> -
> -	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> -	pmu = &host->pmu_events;
> +	struct kvm_pmu_events *pmu = &vcpu->arch.pmu.events;
>  
>  	if (pmu->events_guest)
>  		write_sysreg(pmu->events_guest, pmcntenclr_el0);
> @@ -304,7 +296,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> -	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
> +	pmu_switch_needed = __pmu_switch_to_guest(vcpu);
>  
>  	__sysreg_save_state_nvhe(host_ctxt);
>  	/*
> @@ -366,7 +358,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	__debug_restore_host_buffers_nvhe(vcpu);
>  
>  	if (pmu_switch_needed)
> -		__pmu_switch_to_host(host_ctxt);
> +		__pmu_switch_to_host(vcpu);
>  
>  	/* Returning to host will clear PSR.I, remask PMR if needed */
>  	if (system_uses_irq_prio_masking())
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 4bd38ff34221..c19bf6e4969e 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -5,7 +5,8 @@
>   */
>  #include <linux/kvm_host.h>
>  #include <linux/perf_event.h>
> -#include <asm/kvm_hyp.h>
> +
> +DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
>  
>  /*
>   * Given the perf event attributes and system type, determine
> @@ -25,14 +26,9 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
>  	return (attr->exclude_host != attr->exclude_guest);
>  }
>  
> -static struct kvm_pmu_events *kvm_get_pmu_events(void)
> +struct kvm_pmu_events *kvm_get_pmu_events(void)

Why not make this function visible in patch 1? It seems benign even
though there are no other users at that moment outside of the
compilation unit.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
