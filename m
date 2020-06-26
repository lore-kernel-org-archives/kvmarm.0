Return-Path: <SRS0=8LgP=AH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14323C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 09:12:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BB1B20675
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 09:12:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e9/wlt0r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BB1B20675
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B30484B15D;
	Fri, 26 Jun 2020 05:12:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vht7yQ7KeY5w; Fri, 26 Jun 2020 05:12:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B22A4B151;
	Fri, 26 Jun 2020 05:12:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A5D4B13E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 05:12:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G2xWJOipFim6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2020 05:12:46 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3AD4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 05:12:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593162765;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7GW55amjyBmxVBVEYFyP6NXXU1860Jsa3d+2sKVvSRw=;
 b=e9/wlt0rctKoad7jp9ZXRZUp/1K7+n4FmCJDUREOg/xoudv3agDsHShxRj6n/KpsRWTeHG
 j4bhd27swZjXBSeIY4fkn+jrxs8L4avn3G0vlS8+NC2kyhTDcqAs/p9gNC6tepquFhX4qI
 3py76bRmux4q4pTqKtIYc1/a2XomTOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-ZjoLR9f9N8OKR8w5bhGJRg-1; Fri, 26 Jun 2020 05:12:44 -0400
X-MC-Unique: ZjoLR9f9N8OKR8w5bhGJRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B27A818585A4;
 Fri, 26 Jun 2020 09:12:42 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0D0510246E1;
 Fri, 26 Jun 2020 09:12:40 +0000 (UTC)
Date: Fri, 26 Jun 2020 11:12:38 +0200
From: Andrew Jones <drjones@redhat.com>
To: Beata Michalska <beata.michalska@linaro.org>
Subject: Re: [PATCH v6 2/2] target/arm: kvm: Handle misconfigured dabt
 injection
Message-ID: <20200626091238.xvpi5qtqummcl7qt@kamzik.brq.redhat.com>
References: <20200625220336.10186-1-beata.michalska@linaro.org>
 <20200625220336.10186-3-beata.michalska@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20200625220336.10186-3-beata.michalska@linaro.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

On Thu, Jun 25, 2020 at 11:03:36PM +0100, Beata Michalska wrote:
> Injecting external data abort through KVM might trigger
> an issue on kernels that do not get updated to include the KVM fix.
> For those and aarch32 guests, the injected abort gets misconfigured
> to be an implementation defined exception. This leads to the guest
> repeatedly re-running the faulting instruction.
> 
> Add support for handling that case.
> 
> [
>   Fixed-by: 018f22f95e8a
> 	('KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests')
>   Fixed-by: 21aecdbd7f3a
> 	('KVM: arm: Make inject_abt32() inject an external abort instead')
> ]
> 
> Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> ---
>  target/arm/cpu.h     |  2 ++
>  target/arm/kvm.c     | 30 +++++++++++++++++++++++++++++-
>  target/arm/kvm32.c   | 34 ++++++++++++++++++++++++++++++++++
>  target/arm/kvm64.c   | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  target/arm/kvm_arm.h | 10 ++++++++++
>  5 files changed, 124 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 677584e..ed0ff09 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -570,6 +570,8 @@ typedef struct CPUARMState {
>          uint64_t esr;
>      } serror;
>  
> +    uint8_t ext_dabt_raised; /* Tracking/verifying injection of ext DABT */
> +
>      /* State of our input IRQ/FIQ/VIRQ/VFIQ lines */
>      uint32_t irq_line_state;
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 265c4b8..85a09ea 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -749,6 +749,29 @@ int kvm_get_vcpu_events(ARMCPU *cpu)
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
> @@ -833,6 +856,8 @@ void kvm_arm_vm_state_change(void *opaque, int running, RunState state)
>  static int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
>                               uint64_t fault_ipa)
>  {
> +    ARMCPU *cpu = ARM_CPU(cs);
> +    CPUARMState *env = &cpu->env;
>      /*
>       * Request KVM to inject the external data abort into the guest
>       */
> @@ -852,7 +877,10 @@ static int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
>           */
>          events.exception.ext_dabt_pending = 1;
>  
> -        return kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
> +        if (!kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events)) {
> +            env->ext_dabt_raised = 1;
> +            return 0;
> +        }
>      } else {
>          error_report("Data abort exception triggered by guest memory access "
>                       "at physical address: 0x"  TARGET_FMT_lx,
> diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
> index 7b3a19e..0af46b4 100644
> --- a/target/arm/kvm32.c
> +++ b/target/arm/kvm32.c
> @@ -559,3 +559,37 @@ void kvm_arm_pmu_init(CPUState *cs)
>  {
>      qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
>  }
> +
> +#define ARM_REG_DFSR  ARM_CP15_REG32(0, 5, 0, 0)
> +#define ARM_REG_TTBCR ARM_CP15_REG32(0, 2, 0, 2)
> +/*
> + *DFSR:
> + *      TTBCR.EAE == 0
> + *          FS[4]   - DFSR[10]
> + *          FS[3:0] - DFSR[3:0]
> + *      TTBCR.EAE == 1
> + *          FS, bits [5:0]
> + */
> +#define DFSR_FSC(lpae, v) \
> +    ((lpae) ? ((v) & 0x3F) : (((v) >> 6) | ((v) & 0x1F)))
> +
> +#define DFSC_EXTABT(lpae) ((lpae) ? 0x10 : 0x08)
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
> +        /* The verification is based on FS filed of the DFSR reg only*/
> +        return (DFSR_FSC(lpae, dfsr_val) == DFSC_EXTABT(lpae));
> +    }
> +    return false;
> +}
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index f09ed9f..88cf10c 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -1497,3 +1497,52 @@ bool kvm_arm_handle_debug(CPUState *cs, struct kvm_debug_exit_arch *debug_exit)
>  
>      return false;
>  }
> +
> +#define ARM64_REG_ESR_EL1 ARM64_SYS_REG(3, 0, 5, 2, 0)
> +#define ARM64_REG_TCR_EL1 ARM64_SYS_REG(3, 0, 2, 0, 2)
> +
> +/*
> + * ESR_EL1
> + * ISS encoding
> + * AARCH64: DFSC,   bits [5:0]
> + * AARCH32:
> + *      TTBCR.EAE == 0
> + *          FS[4]   - DFSR[10]
> + *          FS[3:0] - DFSR[3:0]
> + *      TTBCR.EAE == 1
> + *          FS, bits [5:0]
> + */
> +#define ESR_DFSC(aarch64, lpae, v)        \
> +    ((aarch64 || (lpae)) ? ((v) & 0x3F)   \
> +               : (((v) >> 6) | ((v) & 0x1F)))
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
> +        /*
> +         * The verification here is based on the DFSC bits
> +         * of the ESR_EL1 reg only
> +         */
> +         return (ESR_DFSC(aarch64_mode, lpae, dfsr_val) ==
> +                ESR_DFSC_EXTABT(aarch64_mode, lpae));
> +    }
> +    return false;
> +}
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 48bf5e1..471ddd1 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -453,6 +453,16 @@ struct kvm_guest_debug_arch;
>  void kvm_arm_copy_hw_debug_data(struct kvm_guest_debug_arch *ptr);
>  
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

I didn't try to review kvm_arm_verify_ext_dabt_pending() to be sure it's
doing what it says it's doing, but the approach to the code looks good to
me, so

Acked-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
