From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH 3/4] kvm: arm/arm64: vgic: Implement the vGICv2 GICC_APRn
 uaccess interface.
Date: Wed, 5 Jul 2017 19:23:28 +0800
Message-ID: <1499253809-17584-4-git-send-email-wanghaibin.wang@huawei.com>
References: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C101540D8B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 07:23:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pnVYrvVCQi9E for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jul 2017 07:23:54 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64AF240D44
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 07:23:52 -0400 (EDT)
In-Reply-To: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
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

Access GICV_APRn hardware register, SPEC says:

When System register access is disabled for EL2, these registers access GICH_APR<n>,
and all active priorities for virtual machines are held in GICH_APR<n> regardless of
interrupt group.
When System register access is enabled for EL2, these registers access ICH_AP1R<n>_EL2,
and all active priorities for virtual machines are held in ICH_AP1R<n>_EL2 regardless
of interrupt group.

Accordingly, the following two cases are implemented:
(1) GICv2 on GICv2, uaccess GICC_APRn info from GICH_APRn, and,
(2) GICv2 on GICv3, uaccess GICC_APRn info from ICH_AP1Rn.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 ++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 28 ++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  3 +++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 63e0bbd..176b93f 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -303,6 +303,23 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	vgic_set_vmcr(vcpu, &vmcr);
 }
 
+static unsigned long vgic_v2_uaccess_read_activeprio(struct kvm_vcpu *vcpu,
+						     gpa_t addr, unsigned int len)
+{
+	u32 idx = (addr & 0x0c) / sizeof(u32);
+
+	return vgic_get_apr(vcpu, 0, idx);
+}
+
+static void vgic_v2_uaccess_write_activeprio(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len,
+					     unsigned long val)
+{
+       u32 idx = (addr & 0x0c) / sizeof(u32);
+
+       return vgic_set_apr(vcpu, 0, idx, val);
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
@@ -361,8 +378,9 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ALIAS_BINPOINT,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GIC_CPU_ACTIVEPRIO,
+		vgic_mmio_read_raz, vgic_mmio_write_wi,
+		vgic_v2_uaccess_read_activeprio, vgic_v2_uaccess_write_activeprio, 16,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 1c17b2a..42fe00d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -454,6 +454,34 @@ static int match_region(const void *key, const void *elt)
 		       sizeof(regions[0]), match_region);
 }
 
+void vgic_set_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx, u32 val)
+{
+	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
+
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_apr(vcpu, idx, val);
+	else {
+		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+			vgic_v3_set_apr(vcpu, 1, idx, val);
+		else
+			vgic_v3_set_apr(vcpu, apr, idx, val);
+	}
+}
+
+u32 vgic_get_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx)
+{
+	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
+
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		return vgic_v2_get_apr(vcpu, idx);
+	else {
+		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+			return vgic_v3_get_apr(vcpu, 1, idx);
+		else
+			return vgic_v3_get_apr(vcpu, apr, idx);
+	}
+}
+
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 91d66ec..3cdc448 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -213,6 +213,9 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
 int kvm_register_vgic_device(unsigned long type);
+
+void vgic_set_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx, u32 val);
+u32 vgic_get_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx);
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_lazy_init(struct kvm *kvm);
-- 
1.8.3.1
