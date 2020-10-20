Return-Path: <SRS0=HfRh=D3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555CCC4363A
	for <kvmarm@archiver.kernel.org>; Tue, 20 Oct 2020 14:41:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9592F2224B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Oct 2020 14:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="unEdcrt/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9592F2224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D19574B432;
	Tue, 20 Oct 2020 10:41:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u7+YS76QvW0o; Tue, 20 Oct 2020 10:41:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 450834B435;
	Tue, 20 Oct 2020 10:41:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F27FC4B427
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2020 10:41:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WE7suB-29bxR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Oct 2020 10:41:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 390144B425
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2020 10:41:10 -0400 (EDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E296F21534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2020 14:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603204869;
 bh=7J3iBN9/JdfQR4LForSs3qI+YYA030zuJ1sERezm+BI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=unEdcrt/BLGerxzRy1at7GRJ65KrRqcRDg8KiTmgDIF++PY8xLwIzirMhRaCaBX5t
 DCIwihWQ+U2DvkxNtxvKzyUu6ByxyNkO78kSmzf8SVlqvSE5TlehhquJqPU4zy7JQA
 Nj9FBzJrcA0Eak2zAWWG1oZ6IECZu+Uj09Lpf1N4=
Received: by mail-ot1-f47.google.com with SMTP id f37so1879462otf.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2020 07:41:08 -0700 (PDT)
X-Gm-Message-State: AOAM533HM/vnsv2O2vvogus65G2KppePzRIziIL8bSqCvK/yz7wbePeC
 8IWebgLxCUm45qu3hUAEHzw64VR9rZXxfaQMVg==
X-Google-Smtp-Source: ABdhPJz3G2bmqzN6bXZfjwDOm/7ir5ggK2TrlBgeDJMHGh5rdS8tNFVdQubNJuW/2YJVwOpWopuR6/dIWrKjWlJhKT8=
X-Received: by 2002:a9d:1c90:: with SMTP id l16mr2006085ota.192.1603204868046; 
 Tue, 20 Oct 2020 07:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200924134853.2696503-1-robh@kernel.org>
 <20200924134853.2696503-2-robh@kernel.org>
In-Reply-To: <20200924134853.2696503-2-robh@kernel.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 20 Oct 2020 09:40:56 -0500
X-Gmail-Original-Message-ID: <CAL_JsqL02nHO=Mk7HJeBVr69AZ449wb5PpsNuaW3+SYP4HQn8g@mail.gmail.com>
Message-ID: <CAL_JsqL02nHO=Mk7HJeBVr69AZ449wb5PpsNuaW3+SYP4HQn8g@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
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

On Thu, Sep 24, 2020 at 8:48 AM Rob Herring <robh@kernel.org> wrote:
>
> On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device load
> and a store exclusive or PAR_EL1 read can cause a deadlock.
>
> The workaround requires a DMB SY before and after a PAR_EL1 register
> read. In addition, it's possible an interrupt (doing a device read) or
> KVM guest exit could be taken between the DMB and PAR read, so we
> also need a DMB before returning from interrupt and before returning to
> a guest.
>
> A deadlock is still possible with the workaround as KVM guests must also
> have the workaround. IOW, a malicious guest can deadlock an affected
> systems.
>
> This workaround also depends on a firmware counterpart to enable the h/w
> to insert DMB SY after load and store exclusive instructions. See the
> errata document SDEN-1152370 v10 [1] for more information.
>
> [1] https://static.docs.arm.com/101992/0010/Arm_Cortex_A77_MP074_Software_Developer_Errata_Notice_v10.pdf
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v6:
> - Do dmb on kernel_exit rather than disabling interrupts around PAR read
> v5:
> - Rebase on v5.9-rc3
> - Disable interrupts around PAR reads
> - Add DMB on return to guest
>
> v4:
> - Move read_sysreg_par out of KVM code to sysreg.h to share
> - Also use read_sysreg_par in fault.c and kvm/sys_regs.c
> - Use alternative f/w for dmbs around PAR read
> - Use cpus_have_final_cap instead of cpus_have_const_cap
> - Add note about speculation of PAR read
>
> v3:
> - Add dmbs around PAR reads in KVM code
> - Clean-up 'work-around' and 'errata'
>
> v2:
> - Don't disable KVM, just print warning
> ---
>  Documentation/arm64/silicon-errata.rst     |  2 ++
>  arch/arm64/Kconfig                         | 20 ++++++++++++++++++++
>  arch/arm64/include/asm/cpucaps.h           |  3 ++-
>  arch/arm64/include/asm/sysreg.h            |  9 +++++++++
>  arch/arm64/kernel/cpu_errata.c             | 10 ++++++++++
>  arch/arm64/kernel/entry.S                  |  3 +++
>  arch/arm64/kvm/arm.c                       |  3 ++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h    | 21 +++++++++++++--------
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c           |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c            |  2 +-
>  arch/arm64/kvm/sys_regs.c                  |  2 +-
>  arch/arm64/mm/fault.c                      |  2 +-
>  13 files changed, 66 insertions(+), 15 deletions(-)

Marc, Can I get an ack for KVM on this? Will is waiting for one before applying.

Rob

>
> diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
> index d3587805de64..719510247292 100644
> --- a/Documentation/arm64/silicon-errata.rst
> +++ b/Documentation/arm64/silicon-errata.rst
> @@ -90,6 +90,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N1     | #1349291        | N/A                         |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 6d232837cbee..9ba14ff06cd6 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -626,6 +626,26 @@ config ARM64_ERRATUM_1542419
>
>           If unsure, say Y.
>
> +config ARM64_ERRATUM_1508412
> +       bool "Cortex-A77: 1508412: workaround deadlock on sequence of NC/Device load and store exclusive or PAR read"
> +       default y
> +       help
> +         This option adds a workaround for Arm Cortex-A77 erratum 1508412.
> +
> +         Affected Cortex-A77 cores (r0p0, r1p0) could deadlock on a sequence
> +         of a store-exclusive or read of PAR_EL1 and a load with device or
> +         non-cacheable memory attributes. The workaround depends on a firmware
> +         counterpart.
> +
> +         KVM guests must also have the workaround implemented or they can
> +         deadlock the system.
> +
> +         Work around the issue by inserting DMB SY barriers around PAR_EL1
> +         register reads and warning KVM users. The DMB barrier is sufficient
> +         to prevent a speculative PAR_EL1 read.
> +
> +         If unsure, say Y.
> +
>  config CAVIUM_ERRATUM_22375
>         bool "Cavium erratum 22375, 24313"
>         default y
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 07b643a70710..f184142b6e5a 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -64,7 +64,8 @@
>  #define ARM64_BTI                              54
>  #define ARM64_HAS_ARMv8_4_TTL                  55
>  #define ARM64_HAS_TLB_RANGE                    56
> +#define ARM64_WORKAROUND_1508412               57
>
> -#define ARM64_NCAPS                            57
> +#define ARM64_NCAPS                            58
>
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 554a7e8ecb07..d8a48d572c68 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -943,6 +943,7 @@
>
>  #include <linux/build_bug.h>
>  #include <linux/types.h>
> +#include <asm/alternative.h>
>
>  #define __DEFINE_MRS_MSR_S_REGNUM                              \
>  "      .irp    num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n" \
> @@ -1024,6 +1025,14 @@
>                 write_sysreg(__scs_new, sysreg);                        \
>  } while (0)
>
> +#define read_sysreg_par() ({                                           \
> +       u64 par;                                                        \
> +       asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));    \
> +       par = read_sysreg(par_el1);                                     \
> +       asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));    \
> +       par;                                                            \
> +})
> +
>  #endif
>
>  #endif /* __ASM_SYSREG_H */
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index c332d49780dc..b8ac7d1b2182 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -952,6 +952,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>                 .matches = has_neoverse_n1_erratum_1542419,
>                 .cpu_enable = cpu_enable_trap_ctr_access,
>         },
> +#endif
> +#ifdef CONFIG_ARM64_ERRATUM_1508412
> +       {
> +               /* we depend on the firmware portion for correctness */
> +               .desc = "ARM erratum 1508412 (kernel portion)",
> +               .capability = ARM64_WORKAROUND_1508412,
> +               ERRATA_MIDR_RANGE(MIDR_CORTEX_A77,
> +                                 0, 0,
> +                                 1, 0),
> +       },
>  #endif
>         {
>         }
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 55af8b504b65..52232ee40634 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -332,6 +332,9 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
>         br      x30
>  #endif
>         .else
> +       /* Ensure any device/NC reads complete */
> +       alternative_insn nop, "dmb sy", ARM64_WORKAROUND_1508412
> +
>         eret
>         .endif
>         sb
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 46dc3d75cf13..79ead5c510ab 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1640,7 +1640,8 @@ int kvm_arch_init(void *opaque)
>                 return -ENODEV;
>         }
>
> -       if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
> +       if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
> +           cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>                 kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
>                          "Only trusted guests should be used on this system.\n");
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 5b6b8fa00f0a..c48f4c59e933 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -145,9 +145,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
>          * We do need to save/restore PAR_EL1 though, as we haven't
>          * saved the guest context yet, and we may return early...
>          */
> -       par = read_sysreg(par_el1);
> +       par = read_sysreg_par();
>         if (!__kvm_at("s1e1r", far))
> -               tmp = read_sysreg(par_el1);
> +               tmp = read_sysreg_par();
>         else
>                 tmp = SYS_PAR_EL1_F; /* back to the guest */
>         write_sysreg(par, par_el1);
> @@ -424,7 +424,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>         if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
>             kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
>             handle_tx2_tvm(vcpu))
> -               return true;
> +               goto guest;
>
>         /*
>          * We trap the first access to the FP/SIMD to save the host context
> @@ -434,13 +434,13 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>          * Similarly for trapped SVE accesses.
>          */
>         if (__hyp_handle_fpsimd(vcpu))
> -               return true;
> +               goto guest;
>
>         if (__hyp_handle_ptrauth(vcpu))
> -               return true;
> +               goto guest;
>
>         if (!__populate_fault_info(vcpu))
> -               return true;
> +               goto guest;
>
>         if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
>                 bool valid;
> @@ -455,7 +455,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>                         int ret = __vgic_v2_perform_cpuif_access(vcpu);
>
>                         if (ret == 1)
> -                               return true;
> +                               goto guest;
>
>                         /* Promote an illegal access to an SError.*/
>                         if (ret == -1)
> @@ -471,12 +471,17 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>                 int ret = __vgic_v3_perform_cpuif_access(vcpu);
>
>                 if (ret == 1)
> -                       return true;
> +                       goto guest;
>         }
>
>  exit:
>         /* Return to the host kernel and handle the exit */
>         return false;
> +
> +guest:
> +       /* Re-enter the guest */
> +       asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));
> +       return true;
>  }
>
>  static inline bool __needs_ssbd_off(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 7a986030145f..cce43bfe158f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -43,7 +43,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>         ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
>         ctxt_sys_reg(ctxt, AMAIR_EL1)   = read_sysreg_el1(SYS_AMAIR);
>         ctxt_sys_reg(ctxt, CNTKCTL_EL1) = read_sysreg_el1(SYS_CNTKCTL);
> -       ctxt_sys_reg(ctxt, PAR_EL1)     = read_sysreg(par_el1);
> +       ctxt_sys_reg(ctxt, PAR_EL1)     = read_sysreg_par();
>         ctxt_sys_reg(ctxt, TPIDR_EL1)   = read_sysreg(tpidr_el1);
>
>         ctxt_sys_reg(ctxt, SP_EL1)      = read_sysreg(sp_el1);
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 0970442d2dbc..f4233cccf60b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -246,7 +246,7 @@ void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
>  {
>         u64 spsr = read_sysreg_el2(SYS_SPSR);
>         u64 elr = read_sysreg_el2(SYS_ELR);
> -       u64 par = read_sysreg(par_el1);
> +       u64 par = read_sysreg_par();
>         struct kvm_vcpu *vcpu = host_ctxt->__hyp_running_vcpu;
>         unsigned long str_va;
>
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index c1da4f86ccac..c2cb27e57318 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -212,7 +212,7 @@ void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
>  {
>         u64 spsr = read_sysreg_el2(SYS_SPSR);
>         u64 elr = read_sysreg_el2(SYS_ELR);
> -       u64 par = read_sysreg(par_el1);
> +       u64 par = read_sysreg_par();
>
>         __hyp_call_panic(spsr, elr, par, host_ctxt);
>         unreachable();
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 077293b5115f..8d8d77794cc4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -95,7 +95,7 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
>         case AMAIR_EL1:         *val = read_sysreg_s(SYS_AMAIR_EL12);   break;
>         case CNTKCTL_EL1:       *val = read_sysreg_s(SYS_CNTKCTL_EL12); break;
>         case ELR_EL1:           *val = read_sysreg_s(SYS_ELR_EL12);     break;
> -       case PAR_EL1:           *val = read_sysreg_s(SYS_PAR_EL1);      break;
> +       case PAR_EL1:           *val = read_sysreg_par();               break;
>         case DACR32_EL2:        *val = read_sysreg_s(SYS_DACR32_EL2);   break;
>         case IFSR32_EL2:        *val = read_sysreg_s(SYS_IFSR32_EL2);   break;
>         case DBGVCR32_EL2:      *val = read_sysreg_s(SYS_DBGVCR32_EL2); break;
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index f07333e86c2f..2dbd1d9aa3c7 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -260,7 +260,7 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
>         local_irq_save(flags);
>         asm volatile("at s1e1r, %0" :: "r" (addr));
>         isb();
> -       par = read_sysreg(par_el1);
> +       par = read_sysreg_par();
>         local_irq_restore(flags);
>
>         /*
> --
> 2.25.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
