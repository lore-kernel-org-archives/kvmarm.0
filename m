From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 27/38] KVM: arm64: Add EL2 registers defined in ARMv8.1
 to vcpu context
Date: Tue, 18 Jul 2017 11:58:53 -0500
Message-ID: <1500397144-16232-28-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1F649C0F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PPJHu5AMR3+W for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:34 -0400 (EDT)
Received: from mail-it0-f43.google.com (mail-it0-f43.google.com
 [209.85.214.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0A8149BFB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:34 -0400 (EDT)
Received: by mail-it0-f43.google.com with SMTP id v127so6949419itd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:23 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

ARMv8.1 added more EL2 registers: TTBR1_EL2, CONTEXTIDR_EL2, and three
EL2 virtual timer registers. Add the first two registers to vcpu context
and set their handlers. The timer registers and their handlers will be
added in a separate patch.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/include/asm/sysreg.h   | 2 ++
 arch/arm64/kvm/sys_regs.c         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 53b0b33..373235c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -151,6 +151,7 @@ enum vcpu_sysreg {
 	HSTR_EL2,	/* Hypervisor System Trap Register */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
+	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
 	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
 	VTCR_EL2,	/* Virtualization Translation Control Register */
@@ -164,6 +165,7 @@ enum vcpu_sysreg {
 	VBAR_EL2,	/* Vector Base Address Register (EL2) */
 	RVBAR_EL2,	/* Reset Vector Base Address Register */
 	RMR_EL2,	/* Reset Management Register */
+	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
 	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTVOFF_EL2,	/* Counter-timer Virtual Offset register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6373d3d..b01c608 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -264,6 +264,7 @@
 #define SYS_HACR_EL2			sys_reg(3, 4, 1, 1, 7)
 
 #define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
+#define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
 #define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
@@ -331,6 +332,7 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+#define SYS_CONTEXTIDR_EL2		sys_reg(3, 4, 13, 0, 1)
 #define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
 
 #define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dbf5022..b3e0cb8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1168,6 +1168,7 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 	{ SYS_DESC(SYS_HACR_EL2), trap_el2_regs, reset_val, HACR_EL2, 0 },
 
 	{ SYS_DESC(SYS_TTBR0_EL2), trap_el2_regs, reset_val, TTBR0_EL2, 0 },
+	{ SYS_DESC(SYS_TTBR1_EL2), trap_el2_regs, reset_val, TTBR1_EL2, 0 },
 	{ SYS_DESC(SYS_TCR_EL2), trap_el2_regs, reset_val, TCR_EL2, 0 },
 	{ SYS_DESC(SYS_VTTBR_EL2), trap_el2_regs, reset_val, VTTBR_EL2, 0 },
 	{ SYS_DESC(SYS_VTCR_EL2), trap_el2_regs, reset_val, VTCR_EL2, 0 },
@@ -1194,6 +1195,7 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 	{ SYS_DESC(SYS_RVBAR_EL2), trap_el2_regs, reset_val, RVBAR_EL2, 0 },
 	{ SYS_DESC(SYS_RMR_EL2), trap_el2_regs, reset_val, RMR_EL2, 0 },
 
+	{ SYS_DESC(SYS_CONTEXTIDR_EL2), trap_el2_regs, reset_val, CONTEXTIDR_EL2, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL2), trap_el2_regs, reset_val, TPIDR_EL2, 0 },
 
 	{ SYS_DESC(SYS_CNTVOFF_EL2), trap_el2_regs, reset_val, CNTVOFF_EL2, 0 },
-- 
1.9.1
