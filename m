From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH v3 3/4] kvm: arm/arm64: vgic-v3: add ICH_AP[01]Rn accessors
 for GICv3
Date: Wed, 23 Aug 2017 09:05:25 +0800
Message-ID: <1503450326-10624-4-git-send-email-wanghaibin.wang@huawei.com>
References: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF13249C40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 21:03:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S2Repd9rKJe1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Aug 2017 21:03:46 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F13E440D17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 21:03:45 -0400 (EDT)
In-Reply-To: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cdall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch is used for GICv2 on GICv3.

About GICV_APRn hardware register access,the SPEC says:
When System register access is enabled for EL2, these registers access
ICH_AP1Rn_EL2, and all active priorities for virtual machines are held
in ICH_AP1Rn_EL2 regardless of interrupt group.

For GICv3 hardware, we access the active priorities from ICH_AP1Rn_EL2
in this scene.

Aiming at the userspace access the undefined APR registers which the
hardwate doesn't implement, it will be treates ad raz/wi.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 16 +++++++++++++--
 virt/kvm/arm/vgic/vgic-v3.c   | 48 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h      |  2 ++
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 80261b7..738d800 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -494,14 +494,26 @@ static int match_region(const void *key, const void *elt)
 
 void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
 {
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
+
+	if (kvm_vgic_global_state.type == VGIC_V2) {
 		vgic_v2_set_apr(vcpu, idx, val);
+	} else {
+		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+			vgic_v3_set_apr(vcpu, 1, idx, val);
+	}
 }
 
 u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx)
 {
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
+
+	if (kvm_vgic_global_state.type == VGIC_V2) {
 		return vgic_v2_get_apr(vcpu, idx);
+	} else {
+		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+			return vgic_v3_get_apr(vcpu, 1, idx);
+	}
 
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 96ea597..2625dfd 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -160,6 +160,54 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
 }
 
+static bool vgic_v3_apr_access_valid(struct kvm_vcpu *vcpu, u32 idx)
+{
+	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
+
+	if (idx > 3)
+		return false;
+
+	switch (vgic_v3_cpu->num_pri_bits) {
+	case 7:
+		return true;
+	case 6:
+		if (idx > 1)
+			return false;
+		break;
+	default:
+		if (idx > 0)
+			return false;
+	}
+
+	return true;
+}
+
+void vgic_v3_set_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx, u32 val)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (!vgic_v3_apr_access_valid(vcpu, idx))
+		return;
+
+	if (group)
+		cpu_if->vgic_ap1r[idx] = val;
+	else
+		cpu_if->vgic_ap0r[idx] = val;
+}
+
+u32 vgic_v3_get_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (!vgic_v3_apr_access_valid(vcpu, idx))
+		return 0;
+
+	if (group)
+		return cpu_if->vgic_ap1r[idx];
+	else
+		return cpu_if->vgic_ap0r[idx];
+}
+
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 441ded7..19b0f8b 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -181,6 +181,8 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v3_set_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx, u32 val);
+u32 vgic_v3_get_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
-- 
1.8.3.1
