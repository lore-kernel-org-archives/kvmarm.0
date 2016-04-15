From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 13/45] KVM: arm/arm64: vgic-new: Export register access
 interface
Date: Fri, 15 Apr 2016 18:11:24 +0100
Message-ID: <1460740316-8755-14-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC4749BEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gMoi6q5366lv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F2849C32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:21 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Userland can access the emulated GIC to save and restore its state
for initialization or migration purposes.
The kvm_io_bus API requires an absolute gpa, which does not fit the
KVM_DEV_ARM_VGIC_GRP_DIST_REGS user API, that only provides relative
offsets. So we explicitly iterate our register list to connect
userland to the VGIC.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic/vgic.h      |  2 ++
 virt/kvm/arm/vgic/vgic_mmio.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 0c92cda..8f5d50a 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -28,6 +28,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
+int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
+			int offset, int len, void *val);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index b70a274..21c78a7 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -178,6 +178,36 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu,
 	return region->ops.write(vcpu, dev, addr, len, val);
 }
 
+/*
+ * When userland tries to access the VGIC register handlers, we need to
+ * create a usable struct vgic_io_device to be passed to the handlers.
+ */
+static int vgic_device_mmio_access(struct kvm_vcpu *vcpu,
+				   struct vgic_register_region *regions,
+				   int nr_regions, bool is_write,
+				   int offset, int len, void *val)
+{
+	struct vgic_io_device dev = {
+		.base_addr = 0,
+		.redist_vcpu = vcpu,
+	};
+
+	if (is_write)
+		return dispatch_mmio_write(vcpu, regions, nr_regions,
+					   &dev.dev, offset, len, val);
+	else
+		return dispatch_mmio_read(vcpu, regions, nr_regions,
+					  &dev.dev, offset, len, val);
+}
+
+int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
+			int offset, int len, void *val)
+{
+	return vgic_device_mmio_access(vcpu, vgic_v2_dist_registers,
+				       ARRAY_SIZE(vgic_v2_dist_registers),
+				       is_write, offset, len, val);
+}
+
 int vgic_mmio_read_v2dist(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			  gpa_t addr, int len, void *val)
 {
-- 
2.7.3
