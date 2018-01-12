From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 07/41] KVM: arm/arm64: Add kvm_vcpu_load_sysregs and
 kvm_vcpu_put_sysregs
Date: Fri, 12 Jan 2018 13:07:13 +0100
Message-ID: <20180112120747.27999-8-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6146549DCF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LaFJbf6D803 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:12 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68D7C49D66
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:12 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id g75so11735673wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:03 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to move a bunch of save/restore logic for VHE kernels to
the load and put functions, we need some infrastructure to do this.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/hyp/sysreg-sr.c    | 30 ++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                |  2 ++
 4 files changed, 38 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 7f96b3541939..793b3bc5a56c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -300,4 +300,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 /* All host FP/SIMD state is restored on guest exit, so nothing to save: */
 static inline void kvm_fpsimd_flush_cpu_state(void) {}
 
+static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 59150c75f9a5..0e9e7291a7e6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -412,4 +412,7 @@ static inline void kvm_fpsimd_flush_cpu_state(void)
 		sve_flush_cpu_state();
 }
 
+void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index e19d89cabf2a..cbbcd6f410a8 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -184,6 +184,36 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
 }
 
+/**
+ * kvm_vcpu_load_sysregs - Load guest system registers to the physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * Load system registers that do not affect the host's execution, for
+ * example EL1 system registers on a VHE system where the host kernel
+ * runs at EL2.  This function is called from KVM's vcpu_load() function
+ * and loading system register state early avoids having to load them on
+ * every entry to the VM.
+ */
+void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
+{
+}
+
+/**
+ * kvm_vcpu_put_sysregs - Restore host system registers to the physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * Save guest system registers that do not affect the host's execution, for
+ * example EL1 system registers on a VHE system where the host kernel
+ * runs at EL2.  This function is called from KVM's vcpu_put() function
+ * and deferring saving system register state until we're no longer running the
+ * VCPU avoids having to save them on every exit from the VM.
+ */
+void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
+{
+}
+
 void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
 {
 	asm("msr tpidr_el2, %0": : "r" (tpidr_el2));
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 46c125f1da56..5b1487bd91e8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -361,10 +361,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_vcpu_load_sysregs(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_vcpu_put_sysregs(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 
-- 
2.14.2
