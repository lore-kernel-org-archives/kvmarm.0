From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v6 1/6] arm/arm64: KVM: Introduce armv7 fp/simd vcpu fields and
 helpers
Date: Sat, 26 Dec 2015 13:54:55 -0800
Message-ID: <1451166900-3711-2-git-send-email-m.smarduch@samsung.com>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DCF8410D7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ti0nnPGwcmTN for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Dec 2015 16:52:22 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E57B407A6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:21 -0500 (EST)
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZZ00CQUJK91T20@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 26 Dec 2015 16:55:21 -0500 (EST)
In-reply-to: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add helper functions to enable access to fp/smid on guest entry and save host
fpexc on vcpu put, check if fp/simd registers are dirty and add new vcpu
fields.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_emulate.h   | 42 ++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_host.h      |  6 ++++++
 arch/arm64/include/asm/kvm_emulate.h |  8 +++++++
 3 files changed, 56 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 3095df0..d4d9da1 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -24,6 +24,8 @@
 #include <asm/kvm_mmio.h>
 #include <asm/kvm_arm.h>
 #include <asm/cputype.h>
+#include <asm/vfp.h>
+#include "../vfp/vfpinstr.h"
 
 unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
 unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu);
@@ -255,4 +257,44 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	}
 }
 
+#ifdef CONFIG_VFPv3
+/* Called from vcpu_load - save fpexc and enable guest access to fp/simd unit */
+static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
+{
+	u32 fpexc;
+
+	/* Save host fpexc, and enable guest access to fp unit */
+	fpexc = fmrx(FPEXC);
+	vcpu->arch.host_fpexc = fpexc;
+	fpexc |= FPEXC_EN;
+	fmxr(FPEXC, fpexc);
+
+	/* Configure HCPTR to trap on tracing and fp/simd access */
+	vcpu->arch.hcptr = HCPTR_TTA | HCPTR_TCP(10)  | HCPTR_TCP(11);
+}
+
+/* Called from vcpu_put - restore host fpexc */
+static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu)
+{
+	fmxr(FPEXC, vcpu->arch.host_fpexc);
+}
+
+/* If trap bits are reset then fp/simd registers are dirty */
+static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
+{
+	return !(vcpu->arch.hcptr & (HCPTR_TCP(10) | HCPTR_TCP(11)));
+}
+#else
+static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcptr = HCPTR_TTA;
+}
+
+static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
+static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+#endif
+
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index f9f2779..d3ef58a 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -105,6 +105,12 @@ struct kvm_vcpu_arch {
 	/* HYP trapping configuration */
 	u32 hcr;
 
+	/* HYP Co-processor fp/simd and trace trapping configuration */
+	u32 hcptr;
+
+	/* Save host FPEXC register to later restore on vcpu put */
+	u32 host_fpexc;
+
 	/* Interrupt related fields */
 	u32 irq_lines;		/* IRQ and FIQ levels */
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3066328..ffe8ccf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -299,4 +299,12 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
+static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu) {}
+static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
+
+static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
-- 
1.9.1
