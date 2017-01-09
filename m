From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 19/55] KVM: arm64: Trap CPACR_EL1 access in virtual EL2
Date: Mon,  9 Jan 2017 01:24:15 -0500
Message-ID: <1483943091-1364-20-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C2B40296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gTTUI3IGDTzz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:18 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5638D40697
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:16 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096O7Qx005079
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:58 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id EA5A285
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:57 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id C0B3F85
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:57 -0500 (EST)
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com
 [209.85.220.197])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PvSQ004898
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:57 -0500
Received: by mail-qk0-f197.google.com with SMTP id x64so109015277qkb.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:57 -0800 (PST)
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

For the same reason we trap virtual memory register accesses in virtual
EL2, we trap CPACR_EL1 access too. Basically, we don't want the guest
hypervisor to access the real CPACR_EL1, which is used to emulate
virtual EL2. Instead, we want it to access virtual CPACR_EL1 which is
used to run software in EL0/EL1 from the guest hypervisor's perspective.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/hyp/switch.c | 10 +++++++---
 arch/arm64/kvm/sys_regs.c   | 10 +++++++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c05c48f..b7c8c30 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -41,7 +41,8 @@ bool __hyp_text __fpsimd_enabled(void)
 	return __fpsimd_is_enabled()();
 }
 
-static void __hyp_text __activate_traps_vhe(void)
+static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
+
 {
 	u64 val;
 
@@ -53,12 +54,15 @@ static void __hyp_text __activate_traps_vhe(void)
 	write_sysreg(__kvm_hyp_vector, vbar_el1);
 }
 
-static void __hyp_text __activate_traps_nvhe(void)
+static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
+
 {
 	u64 val;
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TFP;
+	if (vcpu_mode_el2(vcpu))
+		val |= CPTR_EL2_TCPAC;
 	write_sysreg(val, cptr_el2);
 }
 
@@ -90,7 +94,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	/* Make sure we trap PMU access from EL0 to EL2 */
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
-	__activate_traps_arch()();
+	__activate_traps_arch()(vcpu);
 }
 
 static void __hyp_text __deactivate_traps_vhe(void)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 59f9cc6..321ecbc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -947,6 +947,14 @@ static bool access_vbar(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_cpacr(struct kvm_vcpu *vcpu,
+		struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
+	return true;
+}
+
 static bool trap_el2_reg(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -1051,7 +1059,7 @@ static bool trap_el2_reg(struct kvm_vcpu *vcpu,
 	  access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	/* CPACR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b010),
-	  NULL, reset_val, CPACR_EL1, 0 },
+	  access_cpacr, reset_val, CPACR_EL1, 0 },
 	/* TTBR0_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b000),
 	  access_vm_reg, reset_unknown, TTBR0_EL1 },
-- 
1.9.1
