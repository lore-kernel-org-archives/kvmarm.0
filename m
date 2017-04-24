From: David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] arm64: Add workaround for Cavium Thunder erratum 30115
Date: Mon, 24 Apr 2017 11:42:50 -0700
Message-ID: <20170424184250.667-3-david.daney@cavium.com>
References: <20170424184250.667-1-david.daney@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170424184250.667-1-david.daney@cavium.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>, David Daney <david.daney@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Some Cavium Thunder CPUs suffer a problem where a KVM guest may
inadvertently cause the host kernel to quit receiving interrupts.

The workaround is to toggle the group-1 interrupt enable on each exit
from the guest.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 11 +++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 21 +++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c            |  9 +++++++++
 5 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 10f2ddd..f5f93dc 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -62,6 +62,7 @@ stable kernels.
 | Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154        |
 | Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456        |
 | Cavium         | ThunderX SMMUv2 | #27704          | N/A                         |
+| Cavium         | ThunderX Core   | #30115          | CAVIUM_ERRATUM_30115        |
 |                |                 |                 |                             |
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 |                |                 |                 |                             |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e7f043e..fe29277 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -480,6 +480,17 @@ config CAVIUM_ERRATUM_27456
 
 	  If unsure, say Y.
 
+config CAVIUM_ERRATUM_30115
+	bool "Cavium erratum 30115: Guest may disable interrupts in host"
+	default y
+	help
+	  On ThunderX T88 pass 1.x through 2.2, T81 pass 1.0 through
+	  1.2, and T83 Pass 1.0, KVM guest execution may disable
+	  interrupts in host.  The fix is to reenable group 1
+	  interrupts when returning to host mode.
+
+	  If unsure, say Y.
+
 config QCOM_FALKOR_ERRATUM_1003
 	bool "Falkor E1003: Incorrect translation due to ASID change"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index b3aab8a..8d2272c 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -38,7 +38,8 @@
 #define ARM64_WORKAROUND_REPEAT_TLBI		17
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
 #define ARM64_WORKAROUND_858921			19
+#define ARM64_WORKAROUND_CAVIUM_30115		20
 
-#define ARM64_NCAPS				20
+#define ARM64_NCAPS				21
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 2ed2a76..0e27f86 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -133,6 +133,27 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_RANGE(MIDR_THUNDERX_81XX, 0x00, 0x00),
 	},
 #endif
+#ifdef CONFIG_CAVIUM_ERRATUM_30115
+	{
+	/* Cavium ThunderX, T88 pass 1.x - 2.2 */
+		.desc = "Cavium erratum 30115",
+		.capability = ARM64_WORKAROUND_CAVIUM_30115,
+		MIDR_RANGE(MIDR_THUNDERX, 0x00,
+			   (1 << MIDR_VARIANT_SHIFT) | 2),
+	},
+	{
+	/* Cavium ThunderX, T81 pass 1.0 - 1.2 */
+		.desc = "Cavium erratum 30115",
+		.capability = ARM64_WORKAROUND_CAVIUM_30115,
+		MIDR_RANGE(MIDR_THUNDERX_81XX, 0x00, 0x02),
+	},
+	{
+	/* Cavium ThunderX, T83 pass 1.0 */
+		.desc = "Cavium erratum 30115",
+		.capability = ARM64_WORKAROUND_CAVIUM_30115,
+		MIDR_RANGE(MIDR_THUNDERX_83XX, 0x00, 0x00),
+	},
+#endif
 	{
 		.desc = "Mismatched cache line size",
 		.capability = ARM64_MISMATCHED_CACHE_LINE_SIZE,
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index aede165..c174b5f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -17,11 +17,13 @@
 
 #include <linux/types.h>
 #include <linux/jump_label.h>
+#include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/fpsimd.h>
+#include <asm/cpufeature.h>
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
 {
@@ -166,6 +168,13 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 		__vgic_v2_save_state(vcpu);
 
 	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
+
+#ifdef CONFIG_CAVIUM_ERRATUM_30115
+	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_30115)) {
+		gic_write_grpen1(0);
+		gic_write_grpen1(1);
+	}
+#endif
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
-- 
2.7.4

