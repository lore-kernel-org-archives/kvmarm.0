From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 3/3] KVM: arm64: Introduce default dummy save/restore
 functions
Date: Tue, 14 Jul 2015 15:06:05 +0300
Message-ID: <248fcfc798e243b618c5275eef8aa333253fd4da.1436874248.git.p.fedin@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1436874248.git.p.fedin@samsung.com>
In-reply-to: <cover.1436874248.git.p.fedin@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Necessary for KVM without irqchip to function on ARM64. Allows to use
software GICv2 emulation where hardware acceleration is not available.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/include/asm/kvm_host.h   | 5 +++++
 arch/arm64/include/asm/kvm_asm.h  | 1 +
 arch/arm64/include/asm/kvm_host.h | 8 ++++++++
 arch/arm64/kvm/vgic-v2-switch.S   | 5 +++++
 virt/kvm/arm/vgic.c               | 2 ++
 5 files changed, 21 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d71607c..c469c95 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -218,6 +218,11 @@ static inline int kvm_arch_dev_ioctl_check_extension(long ext)
 	return 0;
 }
 
+static inline void vgic_arch_pre_setup(void)
+{
+
+}
+
 static inline void vgic_arch_setup(const struct vgic_params *vgic)
 {
 	BUG_ON(vgic->type != VGIC_V2);
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4f7310f..933a442 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -132,6 +132,7 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
 
+extern char __dummy_vgic_save_restore[];
 extern char __save_vgic_v2_state[];
 extern char __restore_vgic_v2_state[];
 extern char __save_vgic_v3_state[];
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f0f58c9..b322895 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -221,6 +221,14 @@ struct vgic_sr_vectors {
 	void	*restore_vgic;
 };
 
+static inline void vgic_arch_pre_setup(void)
+{
+	extern struct vgic_sr_vectors __vgic_sr_vectors;
+
+	__vgic_sr_vectors.save_vgic	= __dummy_vgic_save_restore;
+	__vgic_sr_vectors.restore_vgic	= __dummy_vgic_save_restore;
+}
+
 static inline void vgic_arch_setup(const struct vgic_params *vgic)
 {
 	extern struct vgic_sr_vectors __vgic_sr_vectors;
diff --git a/arch/arm64/kvm/vgic-v2-switch.S b/arch/arm64/kvm/vgic-v2-switch.S
index f002fe1..f9280f9 100644
--- a/arch/arm64/kvm/vgic-v2-switch.S
+++ b/arch/arm64/kvm/vgic-v2-switch.S
@@ -134,4 +134,9 @@ CPU_BE(	rev	w5, w5 )
 	ret
 ENDPROC(__restore_vgic_v2_state)
 
+ENTRY(__dummy_vgic_save_restore)
+__dummy_vgic_save_restore:
+	ret
+ENDPROC(__dummy_vgic_save_restore)
+
 	.popsection
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 950064a..e3f9fae 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2103,6 +2103,8 @@ int kvm_vgic_hyp_init(void)
 	struct device_node *vgic_node;
 	int ret;
 
+	vgic_arch_pre_setup();
+
 	vgic_node = of_find_matching_node_and_match(NULL,
 						    vgic_ids, &matched_id);
 	if (!vgic_node) {
-- 
2.4.4

