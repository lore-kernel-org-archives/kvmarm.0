Return-Path: <SRS0=GiKq=ED=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F34C388F7
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 18:28:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D92224805
	for <kvmarm@archiver.kernel.org>; Wed, 28 Oct 2020 18:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D92224805
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C74D4B432;
	Wed, 28 Oct 2020 14:28:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9rYl6oZoBTpr; Wed, 28 Oct 2020 14:28:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF05C4B422;
	Wed, 28 Oct 2020 14:28:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A9A34B425
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 14:28:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MPaWKl2SZG+i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2020 14:28:43 -0400 (EDT)
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com
 [209.85.161.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 967CB4B3F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 14:28:43 -0400 (EDT)
Received: by mail-oo1-f51.google.com with SMTP id n2so103225ooo.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2020 11:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=G/1nXOEqeBOXQFZcBI+vE5qgf14eZgrrtqNXJmeSsuQ=;
 b=Zy5ampHcPcFdHaqdop/PokavPeWG0vgnB2uXqBpAW8PjOktjiOQlaxV90JVZnRwF4U
 DIRnDemqTeHAx1aOVsZCWLm/LRfTGnDmckJIGbavNeoYPPqefYQUyLQd8C1e9/C3Lg9k
 9S5PkAW2Qtrd8LxNWsu3onIH4EfEtHqYz/k5TkHq2AeVhgVxsHQS6QJ/pUnuEBEmHeVl
 AmH/4+kB3NxXRLNYsRnARm0mJG4sdtf2HbAUTgJS+2F/wbvjzOIb+31tpQf2p3g40/8e
 VtH4QTKvCNRGwmSCnFEhfHDN2O+s+5ueWAOBoAieGxper//2PbH/ZHgoPY8r51jCu6X+
 9T2Q==
X-Gm-Message-State: AOAM531zvrdW9qlaoD8T8befF4a0QdCbFQanP/7/PLroLGCMm67ZdOae
 oKjq3Z9tu8vQSwnZ78k0qA==
X-Google-Smtp-Source: ABdhPJytn7pHpptXP1UdjBH3Yja8HznPE9bisCxkXbGw5WIVkBlkjxyBYK1yluE/kW1gRDyNUrY0lQ==
X-Received: by 2002:a4a:b209:: with SMTP id d9mr205347ooo.70.1603909722962;
 Wed, 28 Oct 2020 11:28:42 -0700 (PDT)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net.
 [24.155.109.49])
 by smtp.googlemail.com with ESMTPSA id a16sm77241otk.39.2020.10.28.11.28.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Oct 2020 11:28:42 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v7 2/2] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Date: Wed, 28 Oct 2020 13:28:39 -0500
Message-Id: <20201028182839.166037-2-robh@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201028182839.166037-1-robh@kernel.org>
References: <20201028182839.166037-1-robh@kernel.org>
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

The workaround requires a DMB SY before and after a PAR_EL1 register
read. In addition, it's possible an interrupt (doing a device read) or
KVM guest exit could be taken between the DMB and PAR read, so we
also need a DMB before returning from interrupt and before returning to
a guest.

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
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v7:
- Rebase on 5.10-rc1

v6:
- Do dmb on kernel_exit rather than disabling interrupts around PAR read

v5:
- Rebase on v5.9-rc3
- Disable interrupts around PAR reads
- Add DMB on return to guest

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
 Documentation/arm64/silicon-errata.rst     |  2 ++
 arch/arm64/Kconfig                         | 20 ++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h           |  3 ++-
 arch/arm64/include/asm/sysreg.h            |  9 +++++++++
 arch/arm64/kernel/cpu_errata.c             | 10 ++++++++++
 arch/arm64/kernel/entry.S                  |  3 +++
 arch/arm64/kvm/arm.c                       |  3 ++-
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 21 +++++++++++++--------
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |  2 +-
 arch/arm64/kvm/sys_regs.c                  |  2 +-
 arch/arm64/mm/fault.c                      |  2 +-
 13 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index d3587805de64..719510247292 100644
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
index f858c352f72a..1d466addb078 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -636,6 +636,26 @@ config ARM64_ERRATUM_1542419
 
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
index 42868dbd29fd..e7d98997c09c 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -65,7 +65,8 @@
 #define ARM64_HAS_ARMv8_4_TTL			55
 #define ARM64_HAS_TLB_RANGE			56
 #define ARM64_MTE				57
+#define ARM64_WORKAROUND_1508412		58
 
-#define ARM64_NCAPS				58
+#define ARM64_NCAPS				59
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d52c1b3ce589..174817ba119c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1007,6 +1007,7 @@
 
 #include <linux/build_bug.h>
 #include <linux/types.h>
+#include <asm/alternative.h>
 
 #define __DEFINE_MRS_MSR_S_REGNUM				\
 "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n" \
@@ -1095,6 +1096,14 @@
 		write_sysreg_s(__scs_new, sysreg);			\
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
index 24d75af344b1..61314fd70f13 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -522,6 +522,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f30007dff35f..b295fb912b12 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -365,6 +365,9 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	br	x30
 #endif
 	.else
+	/* Ensure any device/NC reads complete */
+	alternative_insn nop, "dmb sy", ARM64_WORKAROUND_1508412
+
 	eret
 	.endif
 	sb
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f56122eedffc..8f8fca47abfc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1719,7 +1719,8 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
+	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
+	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
 			 "Only trusted guests should be used on this system.\n");
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 313a8fa3c721..1f875a8f20c4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -140,9 +140,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	 * We do need to save/restore PAR_EL1 though, as we haven't
 	 * saved the guest context yet, and we may return early...
 	 */
-	par = read_sysreg(par_el1);
+	par = read_sysreg_par();
 	if (!__kvm_at("s1e1r", far))
-		tmp = read_sysreg(par_el1);
+		tmp = read_sysreg_par();
 	else
 		tmp = SYS_PAR_EL1_F; /* back to the guest */
 	write_sysreg(par, par_el1);
@@ -421,7 +421,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
 	    handle_tx2_tvm(vcpu))
-		return true;
+		goto guest;
 
 	/*
 	 * We trap the first access to the FP/SIMD to save the host context
@@ -431,13 +431,13 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Similarly for trapped SVE accesses.
 	 */
 	if (__hyp_handle_fpsimd(vcpu))
-		return true;
+		goto guest;
 
 	if (__hyp_handle_ptrauth(vcpu))
-		return true;
+		goto guest;
 
 	if (!__populate_fault_info(vcpu))
-		return true;
+		goto guest;
 
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		bool valid;
@@ -452,7 +452,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			int ret = __vgic_v2_perform_cpuif_access(vcpu);
 
 			if (ret == 1)
-				return true;
+				goto guest;
 
 			/* Promote an illegal access to an SError.*/
 			if (ret == -1)
@@ -468,12 +468,17 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 		int ret = __vgic_v3_perform_cpuif_access(vcpu);
 
 		if (ret == 1)
-			return true;
+			goto guest;
 	}
 
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
+
+guest:
+	/* Re-enter the guest */
+	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));
+	return true;
 }
 
 static inline void __kvm_unexpected_el2_exception(void)
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 7a986030145f..cce43bfe158f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -43,7 +43,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
 	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
-	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg(par_el1);
+	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg_par();
 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
 
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a457a0306e03..8ae8160bc93a 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -250,7 +250,7 @@ void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
-	u64 par = read_sysreg(par_el1);
+	u64 par = read_sysreg_par();
 	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index fe69de16dadc..62546e20b251 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -215,7 +215,7 @@ void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
-	u64 par = read_sysreg(par_el1);
+	u64 par = read_sysreg_par();
 
 	__hyp_call_panic(spsr, elr, par);
 	unreachable();
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d9117bc56237..41348a7781d9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -95,7 +95,7 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
 	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
-	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
+	case PAR_EL1:		*val = read_sysreg_par();		break;
 	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
 	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 94c99c1c19e3..1ee94002801f 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -262,7 +262,7 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
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
