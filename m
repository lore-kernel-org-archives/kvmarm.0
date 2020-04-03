Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970E0C43331
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 08:44:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FF0520787
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 08:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AmL/uAJJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FF0520787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD6D4B166;
	Fri,  3 Apr 2020 04:44:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t1QWuv2S7llM; Fri,  3 Apr 2020 04:44:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC594B125;
	Fri,  3 Apr 2020 04:44:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 185234B125
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 04:44:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NX4+KlG4DzXE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 04:44:45 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C45AF4B0CF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 04:44:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585903485;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uf9wKHGw2CHCijLZ/Myf9ROWae1a3BjiAkVTXxyMyH8=;
 b=AmL/uAJJ8vrjF/OhrLrEzIPuzZQ4xj6veYwdAnjEJcKKR4IvIw7BXibPQu3EJr1/qEcanC
 T364iIjA7gEe1CC6iZlYgf93Hk6hq0xT11YMjFBWRwm2xDNHR3zes4K5KGwVJ93MP21ssK
 H1yve8/BGOKiOYCUaiiy6UdUZspLdtE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-zPUkWU-FO0SX7DK2Z8SNCw-1; Fri, 03 Apr 2020 04:44:42 -0400
X-MC-Unique: zPUkWU-FO0SX7DK2Z8SNCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62F428018A1;
 Fri,  3 Apr 2020 08:44:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.142])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70A7B6EF97;
 Fri,  3 Apr 2020 08:44:38 +0000 (UTC)
Date: Fri, 3 Apr 2020 10:44:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Beata Michalska <beata.michalska@linaro.org>
Subject: Re: [PATCH v4 2/2] target/arm: kvm: Handle potential issue with dabt
 injection
Message-ID: <20200403084435.zvfewiivn7orsnll@kamzik.brq.redhat.com>
References: <20200323113227.3169-1-beata.michalska@linaro.org>
 <20200323113227.3169-3-beata.michalska@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20200323113227.3169-3-beata.michalska@linaro.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com,
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

On Mon, Mar 23, 2020 at 11:32:27AM +0000, Beata Michalska wrote:
> Injecting external data abort through KVM might trigger
> an issue on kernels that do not get updated to include the KVM fix.
> For those and aarch32 guests, the injected abort gets misconfigured
> to be an implementation defined exception. This leads to the guest
> repeatedly re-running the faulting instruction.
> 
> Add support for handling that case.
> [
>   Fixed-by: 018f22f95e8a
> 	('KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests')
>   Fixed-by: 21aecdbd7f3a
> 	('KVM: arm: Make inject_abt32() inject an external abort instead')
> ]
> 
> Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> ---
>  target/arm/cpu.h     |  1 +
>  target/arm/kvm.c     | 30 +++++++++++++++++++++++++++++-
>  target/arm/kvm32.c   | 25 +++++++++++++++++++++++++
>  target/arm/kvm64.c   | 34 ++++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h | 10 ++++++++++
>  5 files changed, 99 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 4f834c1..868afc6 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -561,6 +561,7 @@ typedef struct CPUARMState {
>      } serror;
>  
>      uint8_t ext_dabt_pending; /* Request for injecting ext DABT */
> +    uint8_t ext_dabt_raised; /* Tracking/verifying injection of ext DABT */
>  
>      /* State of our input IRQ/FIQ/VIRQ/VFIQ lines */
>      uint32_t irq_line_state;
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index c088589..58ad734 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -721,7 +721,12 @@ int kvm_put_vcpu_events(ARMCPU *cpu)
>      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_VCPU_EVENTS, &events);
>      if (ret) {
>          error_report("failed to put vcpu events");
> -    } else {
> +    } else if (env->ext_dabt_pending) {
> +        /*
> +         * Mark that the external DABT has been injected,
> +         * if one has been requested
> +         */
> +        env->ext_dabt_raised = env->ext_dabt_pending;
>          /* Clear instantly if the call was successful */
>          env->ext_dabt_pending = 0;
>      }
> @@ -755,6 +760,29 @@ int kvm_get_vcpu_events(ARMCPU *cpu)
>  
>  void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
>  {
> +    ARMCPU *cpu = ARM_CPU(cs);
> +    CPUARMState *env = &cpu->env;
> +
> +    if (unlikely(env->ext_dabt_raised)) {
> +        /*
> +         * Verifying that the ext DABT has been properly injected,
> +         * otherwise risking indefinitely re-running the faulting instruction
> +         * Covering a very narrow case for kernels 5.5..5.5.4
> +         * when injected abort was misconfigured to be
> +         * an IMPLEMENTATION DEFINED exception (for 32-bit EL1)
> +         */
> +        if (!arm_feature(env, ARM_FEATURE_AARCH64) &&
> +            unlikely(!kvm_arm_verify_ext_dabt_pending(cs))) {
> +
> +            error_report("Data abort exception with no valid ISS generated by "
> +                   "guest memory access. KVM unable to emulate faulting "
> +                   "instruction. Failed to inject an external data abort "
> +                   "into the guest.");
> +            abort();
> +       }
> +       /* Clear the status */
> +       env->ext_dabt_raised = 0;
> +    }
>  }
>  
>  MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
> diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
> index f271181..86c4fe7 100644
> --- a/target/arm/kvm32.c
> +++ b/target/arm/kvm32.c
> @@ -564,3 +564,28 @@ void kvm_arm_pmu_init(CPUState *cs)
>  {
>      qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
>  }
> +
> +#define ARM_REG_DFSR  ARM_CP15_REG32(0, 5, 0, 0)
> +#define ARM_REG_TTBCR ARM_CP15_REG32(0, 2, 0, 2)
> +
> +#define DFSR_FSC(v)   (((v) >> 6 | (v)) & 0x1F)
> +#define DFSC_EXTABT(lpae) (lpae) ? 0x10 : 0x08

We should put () around the whole ?: expression when it's in a macro

> +
> +bool kvm_arm_verify_ext_dabt_pending(CPUState *cs)
> +{
> +    uint32_t dfsr_val;
> +
> +    if (!kvm_get_one_reg(cs, ARM_REG_DFSR, &dfsr_val)) {
> +        ARMCPU *cpu = ARM_CPU(cs);
> +        CPUARMState *env = &cpu->env;
> +        uint32_t ttbcr;
> +        int lpae = 0;
> +
> +        if (!kvm_get_one_reg(cs, ARM_REG_TTBCR, &ttbcr)) {
> +            lpae = arm_feature(env, ARM_FEATURE_LPAE) && (ttbcr & TTBCR_EAE);
> +        }
> +        return !(DFSR_FSC(dfsr_val) != DFSC_EXTABT(lpae));

 !(a != b) is a convoluted way to write a == b

> +    }
> +    return false;
> +}
> +
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index be5b31c..18594e9 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -1430,3 +1430,37 @@ bool kvm_arm_handle_debug(CPUState *cs, struct kvm_debug_exit_arch *debug_exit)
>  
>      return false;
>  }
> +
> +#define ARM64_REG_ESR_EL1 ARM64_SYS_REG(3, 0, 5, 2, 0)
> +#define ARM64_REG_TCR_EL1 ARM64_SYS_REG(3, 0, 2, 0, 2)
> +
> +#define ESR_DFSC(aarch64, v)    \
> +    ((aarch64) ? ((v) & 0x3F)   \
> +               : (((v) >> 6 | (v)) & 0x1F))
> +
> +#define ESR_DFSC_EXTABT(aarch64, lpae) \
> +    ((aarch64) ? 0x10 : (lpae) ? 0x10 : 0x8)
> +
> +bool kvm_arm_verify_ext_dabt_pending(CPUState *cs)
> +{
> +    uint64_t dfsr_val;
> +
> +    if (!kvm_get_one_reg(cs, ARM64_REG_ESR_EL1, &dfsr_val)) {
> +        ARMCPU *cpu = ARM_CPU(cs);
> +        CPUARMState *env = &cpu->env;
> +        int aarch64_mode = arm_feature(env, ARM_FEATURE_AARCH64);
> +        int lpae = 0;
> +
> +        if (!aarch64_mode) {
> +            uint64_t ttbcr;
> +
> +            if (!kvm_get_one_reg(cs, ARM64_REG_TCR_EL1, &ttbcr)) {
> +                lpae = arm_feature(env, ARM_FEATURE_LPAE)
> +                        && (ttbcr & TTBCR_EAE);
> +            }
> +        }
> +        return !(ESR_DFSC(aarch64_mode, dfsr_val) !=
> +                ESR_DFSC_EXTABT(aarch64_mode, lpae));

a == b, please

> +    }
> +    return false;
> +}
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 39472d5..f2dc6a2 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -461,6 +461,16 @@ void kvm_arm_copy_hw_debug_data(struct kvm_guest_debug_arch *ptr);
>  int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
>                               uint64_t fault_ipa);
>  /**
> + * kvm_arm_verify_ext_dabt_pending:
> + * @cs: CPUState
> + *
> + * Verify the fault status code wrt the Ext DABT injection
> + *
> + * Returns: true if the fault status code is as expected, false otherwise
> + */
> +bool kvm_arm_verify_ext_dabt_pending(CPUState *cs);
> +
> +/**
>   * its_class_name:
>   *
>   * Return the ITS class name to use depending on whether KVM acceleration
> -- 
> 2.7.4
> 
>

I'll leave the decision to take this KVM bug workaround patch at all to Peter,
and I didn't actually review whether or not kvm_arm_verify_ext_dabt_pending
is doing what it claims it's doing, so I'm reluctant to give an r-b on
this patch. But, as far as the code goes, besides the comments above, it
looks fine to me.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
