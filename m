Return-Path: <SRS0=KyyX=BN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6E0C433DF
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 19:31:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 178D122B45
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 19:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 178D122B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7E84B6A5;
	Mon,  3 Aug 2020 15:31:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q5qTi+g7dbHh; Mon,  3 Aug 2020 15:31:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34B894B6BD;
	Mon,  3 Aug 2020 15:31:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA5DA4B6A6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 15:31:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yLfUtTdPl+vl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2020 15:31:34 -0400 (EDT)
Received: from mail-io1-f65.google.com (mail-io1-f65.google.com
 [209.85.166.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75D734B6A8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 15:31:33 -0400 (EDT)
Received: by mail-io1-f65.google.com with SMTP id g14so2243949iom.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2020 12:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=sFnwf6O2YfARt4XKUBMrgYWlikZs4kyl/GSLFVncqVc=;
 b=nskaHEGF4KJsTOzloD37jtwqb4tP5qXPEHUcPc3lvsQGkZQedTovf3c8qDf7ZmdhAw
 r/qIr4v1iYJuaPIGgxPndDfJPWgH1N043tRj+0sKxR5xhD0ug1gY7pAWcRWKxKmwUikM
 Hx2rtqA1MH5vZhgN7nfinb5V06kf9OYcYBH/NsHPpC1OKn/3uUnIwhNw4lJQSfihMdyu
 kAfe6VZ9vlqEZ0XxL23D1ohTDKK7/E6i+OuMYA4NGuvvmyCC/fdI5NZxk4wFf0A5aqPG
 BDRuYw/qH76nGL9IWwfZ+TiV7B9RV+2BXhf7QRBOxl/lOG6hk/r5NdfyP+5ZSfuKQnRu
 aFlA==
X-Gm-Message-State: AOAM530ci87oVfjUcRTGMfi1uQAG2U2YCaxCVxWjy2hZgGQUpx4JlgJ1
 D7RU1jaXsUdWEVm8NVtm+w==
X-Google-Smtp-Source: ABdhPJxUmjyhbnwsXXm1Gw7kgLI+ayax1WakozracwFSQMTEgWHoYiK+TUeHQ13Wqeeeq104XccXfw==
X-Received: by 2002:a05:6638:594:: with SMTP id
 a20mr1412907jar.127.1596483092945; 
 Mon, 03 Aug 2020 12:31:32 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.252])
 by smtp.googlemail.com with ESMTPSA id j79sm11254738ilg.42.2020.08.03.12.31.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 03 Aug 2020 12:31:32 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v4 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Date: Mon,  3 Aug 2020 13:31:27 -0600
Message-Id: <20200803193127.3012242-4-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803193127.3012242-1-robh@kernel.org>
References: <20200803193127.3012242-1-robh@kernel.org>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device load
and a store exclusive or PAR_EL1 read can cause a deadlock.

The workaround requires a DMB SY before and after a PAR_EL1 register read.
A deadlock is still possible with the workaround as KVM guests must also
have the workaround. IOW, a malicious guest can deadlock an affected
systems.

This workaround also depends on a firmware counterpart to enable the h/w
to insert DMB SY after load and store exclusive instructions. See the
errata document SDEN-1152370 v10 [1] for more information.

[1] https://static.docs.arm.com/101992/0010/Arm_Cortex_A77_MP074_Software_Developer_Errata_Notice_v10.pdf

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Rob Herring <robh@kernel.org>
---
v4:
- Move read_sysreg_par out of KVM code to sysreg.h to share
- Also use read_sysreg_par in fault.c and kvm/sys_regs.c
- Use alternative f/w for dmbs around PAR read
- Use cpus_have_final_cap instead of cpus_have_const_cap
- Add note about speculation of PAR read

v3:
- Add dmbs around PAR reads in KVM code
- Clean-up 'work-around' and 'errata'

v2:
- Don't disable KVM, just print warning
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 20 ++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/sysreg.h        |  9 +++++++++
 arch/arm64/kernel/cpu_errata.c         | 10 ++++++++++
 arch/arm64/kvm/arm.c                   |  3 ++-
 arch/arm64/kvm/hyp/switch.c            |  7 ++++---
 arch/arm64/kvm/hyp/sysreg-sr.c         |  2 +-
 arch/arm64/kvm/sys_regs.c              |  2 +-
 arch/arm64/mm/fault.c                  |  2 +-
 10 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 936cf2a59ca4..716b279e3b33 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -90,6 +90,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a4a094bedcb2..53dc281fd1eb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -626,6 +626,26 @@ config ARM64_ERRATUM_1542419

 	  If unsure, say Y.

+config ARM64_ERRATUM_1508412
+	bool "Cortex-A77: 1508412: workaround deadlock on sequence of NC/Device load and store exclusive or PAR read"
+	default y
+	help
+	  This option adds a workaround for Arm Cortex-A77 erratum 1508412.
+
+	  Affected Cortex-A77 cores (r0p0, r1p0) could deadlock on a sequence
+	  of a store-exclusive or read of PAR_EL1 and a load with device or
+	  non-cacheable memory attributes. The workaround depends on a firmware
+	  counterpart.
+
+	  KVM guests must also have the workaround implemented or they can
+	  deadlock the system.
+
+	  Work around the issue by inserting DMB SY barriers around PAR_EL1
+	  register reads and warning KVM users. The DMB barrier is sufficient
+	  to prevent a speculative PAR_EL1 read.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index d7b3bb0cb180..2a2cdb4ced8b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -62,7 +62,8 @@
 #define ARM64_HAS_GENERIC_AUTH			52
 #define ARM64_HAS_32BIT_EL1			53
 #define ARM64_BTI				54
+#define ARM64_WORKAROUND_1508412		55

-#define ARM64_NCAPS				55
+#define ARM64_NCAPS				56

 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 463175f80341..17c80d701ae4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -898,6 +898,7 @@

 #include <linux/build_bug.h>
 #include <linux/types.h>
+#include <asm/alternative.h>

 #define __DEFINE_MRS_MSR_S_REGNUM				\
 "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n" \
@@ -979,6 +980,14 @@
 		write_sysreg(__scs_new, sysreg);			\
 } while (0)

+#define read_sysreg_par() ({						\
+	u64 par;							\
+	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
+	par = read_sysreg(par_el1);					\
+	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
+	par;								\
+})
+
 #endif

 #endif	/* __ASM_SYSREG_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ad06d6802d2e..5eee8a75540c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -938,6 +938,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_neoverse_n1_erratum_1542419,
 		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1508412
+	{
+		/* we depend on the firmware portion for correctness */
+		.desc = "ARM erratum 1508412 (kernel portion)",
+		.capability = ARM64_WORKAROUND_1508412,
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A77,
+				  0, 0,
+				  1, 0),
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cbc8365307f2..28715032bc28 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1653,7 +1653,8 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}

-	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
+	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
+	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
 			 "Only trusted guests should be used on this system.\n");

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index db1c4487d95d..d76b6638b705 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -298,11 +298,12 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	 * We do need to save/restore PAR_EL1 though, as we haven't
 	 * saved the guest context yet, and we may return early...
 	 */
-	par = read_sysreg(par_el1);
+	par = read_sysreg_par();
+
 	asm volatile("at s1e1r, %0" : : "r" (far));
 	isb();

-	tmp = read_sysreg(par_el1);
+	tmp = read_sysreg_par();
 	write_sysreg(par, par_el1);

 	if (unlikely(tmp & SYS_PAR_EL1_F))
@@ -925,7 +926,7 @@ void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
-	u64 par = read_sysreg(par_el1);
+	u64 par = read_sysreg_par();

 	if (!has_vhe())
 		__hyp_call_panic_nvhe(spsr, elr, par, host_ctxt);
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index cc7e957f5b2c..f522cbff291d 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -52,7 +52,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(SYS_CONTEXTIDR);
 	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(SYS_AMAIR);
 	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(SYS_CNTKCTL);
-	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
+	ctxt->sys_regs[PAR_EL1]		= read_sysreg_par();
 	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);

 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index baf5ce9225ce..4e0af4e9fe92 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -94,7 +94,7 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
 	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
-	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
+	case PAR_EL1:		*val = read_sysreg_par();		break;
 	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 8afb238ff335..cf008a1d554b 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -260,7 +260,7 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	local_irq_save(flags);
 	asm volatile("at s1e1r, %0" :: "r" (addr));
 	isb();
-	par = read_sysreg(par_el1);
+	par = read_sysreg_par();
 	local_irq_restore(flags);

 	/*
--
2.25.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
