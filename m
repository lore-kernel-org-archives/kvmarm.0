From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 07/37] KVM: arm/arm64: Add kvm_vcpu_load_sysregs and
 kvm_vcpu_put_sysregs
Date: Thu, 12 Oct 2017 12:41:11 +0200
Message-ID: <20171012104141.26902-8-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F2E49D96
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NFAP9KGYOeCy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:09 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CCC649D87
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:08 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id m72so11976983wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:41:52 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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

As we are about to move a buch of save/restore logic for VHE kernels to
the load and put functions, we need some infrastructure to do this.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/hyp/sysreg-sr.c    | 27 +++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                |  2 ++
 4 files changed, 35 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 1100170..13f8165 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -290,4 +290,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
+static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27305e7..7d3bfa7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -383,4 +383,7 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index c54cc2a..b7438c8 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -183,3 +183,30 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
 }
+
+/**
+ * kvm_vcpu_load_sysregs - Load guest system register to physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * If the kernel runs in EL2 then load the system register state for the VCPU
+ * for EL1 onto the physical CPU so that we can go back and foward between the
+ * VM and the hypervisor without switching all this state around.
+ */
+void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
+{
+}
+
+/**
+ * kvm_vcpu_put_sysregs - Restore host system register state to physical CPU
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * If the kernel runs in EL2 and the physical register state belongs to the
+ * VCPU, then restore the system register state for the host for EL1 onto the
+ * physical CPU so that we can run userspace and other threads on this
+ * physical CPU.
+ */
+void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
+{
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index d495453..cf121b2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -358,6 +358,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
+	kvm_vcpu_load_sysregs(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -365,6 +366,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (vcpu->ioctl != KVM_RUN)
 		return;
 
+	kvm_vcpu_put_sysregs(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 
-- 
2.9.0
