From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 07/40] KVM: arm/arm64: Add kvm_vcpu_load_sysregs and
 kvm_vcpu_put_sysregs
Date: Tue, 27 Feb 2018 12:33:56 +0100
Message-ID: <20180227113429.637-8-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

As we are about to move a bunch of save/restore logic for VHE kernels to
the load and put functions, we need some infrastructure to do this.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Reworded comments as suggested by Drew

 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/hyp/sysreg-sr.c    | 30 ++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                |  2 ++
 4 files changed, 38 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 6137195ab815..c6a749568dd6 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -312,4 +312,7 @@ static inline bool kvm_arm_harden_branch_predictor(void)
 	return false;
 }
 
+static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b027a7f025d4..c30fc96992df 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -435,4 +435,7 @@ static inline bool kvm_arm_harden_branch_predictor(void)
 	return cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR);
 }
 
+void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 43b7dd65e3e6..434f0fc9cfb3 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -190,6 +190,36 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
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
index 49d13510e9c2..2062d9357971 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -362,10 +362,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
