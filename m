From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Mon, 20 Mar 2017 15:55:34 +0800
Message-ID: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, rkrcmar@redhat.com, suzuki.poulose@arm.com, andre.przywara@arm.com, mark.rutland@arm.com, vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wuquanming@huawei.com, wangxiongfeng2@huawei.com, xiexiuqi@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

In the RAS implementation, hardware pass the virtual SEI
syndrome information through the VSESR_EL2, so set the virtual
SEI syndrome using physical SEI syndrome el2_elr to pass to
the guest OS

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Quanming wu <wuquanming@huawei.com>
---
 arch/arm64/Kconfig                   |  8 ++++++++
 arch/arm64/include/asm/esr.h         |  1 +
 arch/arm64/include/asm/kvm_emulate.h | 12 ++++++++++++
 arch/arm64/include/asm/kvm_host.h    |  4 ++++
 arch/arm64/kvm/hyp/switch.c          | 15 ++++++++++++++-
 arch/arm64/kvm/inject_fault.c        | 10 ++++++++++
 6 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8c7c244247b6..ea62170a3b75 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -908,6 +908,14 @@ endmenu
 
 menu "ARMv8.2 architectural features"
 
+config HAS_RAS_EXTENSION
+	bool "Support arm64 RAS extension"
+	default n
+	help
+	  Reliability, Availability, Serviceability(RAS; part of the ARMv8.2 Extensions).
+
+	  Selecting this option OS will try to recover the error that RAS hardware node detected.
+
 config ARM64_UAO
 	bool "Enable support for User Access Override (UAO)"
 	default y
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d14c478976d0..e38d32b2bdad 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -111,6 +111,7 @@
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
+#define VSESR_ELx_IDS_ISS_MASK    ((1UL << 25) - 1)
 
 /* ESR value templates for specific events */
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f5ea0ba70f07..20d4da7f5dce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -148,6 +148,18 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
+#ifdef CONFIG_HAS_RAS_EXTENSION
+static inline u32 kvm_vcpu_get_vsesr(const struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.fault.vsesr_el2;
+}
+
+static inline void kvm_vcpu_set_vsesr(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	vcpu->arch.fault.vsesr_el2 = val;
+}
+#endif
+
 static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
 	u32 esr = kvm_vcpu_get_hsr(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e7705e7bb07b..f9e3bb57c461 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -83,6 +83,10 @@ struct kvm_mmu_memory_cache {
 };
 
 struct kvm_vcpu_fault_info {
+#ifdef CONFIG_HAS_RAS_EXTENSION
+	/* Virtual SError Exception Syndrome Register */
+	u32 vsesr_el2;
+#endif
 	u32 esr_el2;		/* Hyp Syndrom Register */
 	u64 far_el2;		/* Hyp Fault Address Register */
 	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index aede1658aeda..770a153fb6ba 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -86,6 +86,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 	write_sysreg(val, hcr_el2);
+#ifdef CONFIG_HAS_RAS_EXTENSION
+	/* If virtual System Error or Asynchronous Abort is pending. set
+	 * the virtual exception syndrome information
+	 */
+	if (vcpu->arch.hcr_el2 & HCR_VSE)
+		write_sysreg(vcpu->arch.fault.vsesr_el2, vsesr_el2);
+#endif
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	/*
@@ -139,8 +146,14 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_VSE)
+	if (vcpu->arch.hcr_el2 & HCR_VSE) {
 		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
+#ifdef CONFIG_HAS_RAS_EXTENSION
+		/* set vsesr_el2[24:0] with esr_el2[24:0] */
+		kvm_vcpu_set_vsesr(vcpu, read_sysreg_el2(esr)
+					& VSESR_ELx_IDS_ISS_MASK);
+#endif
+	}
 
 	__deactivate_traps_arch()();
 	write_sysreg(0, hstr_el2);
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index da6a8cfa54a0..08a13dfe28a8 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -242,4 +242,14 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
 	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+#ifdef CONFIG_HAS_RAS_EXTENSION
+	/* If virtual System Error or Asynchronous Abort is set. set
+	 * the virtual exception syndrome information
+	 */
+	kvm_vcpu_set_vsesr(vcpu, ((kvm_vcpu_get_vsesr(vcpu)
+				& (~VSESR_ELx_IDS_ISS_MASK))
+				| (kvm_vcpu_get_hsr(vcpu)
+				& VSESR_ELx_IDS_ISS_MASK)));
+#endif
+
 }
-- 
2.11.0
