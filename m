From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 09/55] KVM: arm64: Set shadow EL1 registers for virtual EL2
 execution
Date: Mon,  9 Jan 2017 01:24:05 -0500
Message-ID: <1483943091-1364-10-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0B74025C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uH5yhswXEnuQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:01 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7833E407F4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:01 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096P4dQ017232
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:43 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 132C381
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:43 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id DFF4C85
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:42 -0500 (EST)
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com
 [209.85.220.197])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Pgut040633
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:42 -0500
Received: by mail-qk0-f197.google.com with SMTP id c69so110039442qkg.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:42 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When entering virtual EL2, we need to reflect virtual EL2 register
states to corresponding shadow EL1 registers. We can simply copy them if
their formats are identical.  Otherwise, we need to convert EL2 register
state to EL1 register state.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/context.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index acb4b1e..2e9e386 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -17,6 +17,76 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/esr.h>
+
+struct el1_el2_map {
+	enum vcpu_sysreg	el1;
+	enum el2_regs		el2;
+};
+
+/*
+ * List of EL2 registers which can be directly applied to EL1 registers to
+ * emulate running EL2 in EL1.  The EL1 registers here must either be trapped
+ * or paravirtualized in EL1.
+ */
+static const struct el1_el2_map el1_el2_map[] = {
+	{ AMAIR_EL1, AMAIR_EL2 },
+	{ MAIR_EL1, MAIR_EL2 },
+	{ TTBR0_EL1, TTBR0_EL2 },
+	{ ACTLR_EL1, ACTLR_EL2 },
+	{ AFSR0_EL1, AFSR0_EL2 },
+	{ AFSR1_EL1, AFSR1_EL2 },
+	{ SCTLR_EL1, SCTLR_EL2 },
+	{ VBAR_EL1, VBAR_EL2 },
+};
+
+static inline u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
+{
+	return ((tcr_el2 & TCR_EL2_PS_MASK) >> TCR_EL2_PS_SHIFT)
+		<< TCR_IPS_SHIFT;
+}
+
+static inline u64 cptr_el2_to_cpacr_el1(u64 cptr_el2)
+{
+	u64 cpacr_el1 = 0;
+
+	if (!(cptr_el2 & CPTR_EL2_TFP))
+		cpacr_el1 |= CPACR_EL1_FPEN;
+	if (cptr_el2 & CPTR_EL2_TTA)
+		cpacr_el1 |= CPACR_EL1_TTA;
+
+	return cpacr_el1;
+}
+
+static void create_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
+{
+	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
+	u64 *el2_regs = vcpu->arch.ctxt.el2_regs;
+	u64 tcr_el2;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(el1_el2_map); i++) {
+		const struct el1_el2_map *map = &el1_el2_map[i];
+
+		s_sys_regs[map->el1] = el2_regs[map->el2];
+	}
+
+	tcr_el2 = el2_regs[TCR_EL2];
+	s_sys_regs[TCR_EL1] =
+		TCR_EPD1 |	/* disable TTBR1_EL1 */
+		((tcr_el2 & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
+		tcr_el2_ips_to_tcr_el1_ps(tcr_el2) |
+		(tcr_el2 & TCR_EL2_TG0_MASK) |
+		(tcr_el2 & TCR_EL2_ORGN0_MASK) |
+		(tcr_el2 & TCR_EL2_IRGN0_MASK) |
+		(tcr_el2 & TCR_EL2_T0SZ_MASK);
+
+	/* Rely on separate VMID for VA context, always use ASID 0 */
+	s_sys_regs[TTBR0_EL1] &= ~GENMASK_ULL(63, 48);
+	s_sys_regs[TTBR1_EL1] = 0;
+
+	s_sys_regs[CPACR_EL1] = cptr_el2_to_cpacr_el1(el2_regs[CPTR_EL2]);
+}
 
 /**
  * kvm_arm_setup_shadow_state -- prepare shadow state based on emulated mode
@@ -37,6 +107,7 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 		else
 			ctxt->hw_pstate |= PSR_MODE_EL1t;
 
+		create_shadow_el1_sysregs(vcpu);
 		ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
 		ctxt->hw_sp_el1 = ctxt->el2_regs[SP_EL2];
 	} else {
-- 
1.9.1
