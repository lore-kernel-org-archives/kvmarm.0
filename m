From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH] KVM: arm/arm64: fix vGICv2 KVM_DEV_ARM_VGIC_GRP_CPU/DIST_REGS
Date: Mon, 18 Jul 2016 10:57:36 +0000
Message-ID: <1468839456-2448-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF24C412A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:51:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BowF3DHOSeC7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 06:51:41 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76BF1411E3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:51:41 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

For VGICv2 save and restore the CPU interface registers
are accessed. Restore the modality which has been altered.
Also explicitly set the iodev_type for both the DIST and CPU
interface.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 2 ++
 virt/kvm/arm/vgic/vgic-mmio.c    | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 4152348..b44b359 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -437,6 +437,7 @@ int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 	struct vgic_io_device dev = {
 		.regions = vgic_v2_cpu_registers,
 		.nr_regions = ARRAY_SIZE(vgic_v2_cpu_registers),
+		.iodev_type = IODEV_CPUIF,
 	};
 
 	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
@@ -448,6 +449,7 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 	struct vgic_io_device dev = {
 		.regions = vgic_v2_dist_registers,
 		.nr_regions = ARRAY_SIZE(vgic_v2_dist_registers),
+		.iodev_type = IODEV_DIST,
 	};
 
 	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 26be827..3bad3c5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -484,7 +484,8 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	switch (iodev->iodev_type) {
 	case IODEV_CPUIF:
-		return 1;
+		data = region->read(vcpu, addr, len);
+		break;
 	case IODEV_DIST:
 		data = region->read(vcpu, addr, len);
 		break;
@@ -517,6 +518,7 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	switch (iodev->iodev_type) {
 	case IODEV_CPUIF:
+		region->write(vcpu, addr, len, data);
 		break;
 	case IODEV_DIST:
 		region->write(vcpu, addr, len, data);
-- 
1.9.1
