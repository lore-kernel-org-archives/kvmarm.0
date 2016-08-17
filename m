From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 06/12] KVM: arm64: check for ITS device on MSI injection
Date: Wed, 17 Aug 2016 21:38:53 +0200
Message-ID: <20160817193859.15726-7-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

When userspace provides the doorbell address for an MSI to be
injected into the guest, we find a KVM device which feels responsible.
Lets check that this device is really an emulated ITS before we make
real use of the container_of-ed pointer.

  [ Moved NULL-pointer check to caller of static function
    - Christoffer ]

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1cf9f59..9533080 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -471,6 +471,21 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+static struct vgic_io_device *vgic_get_its_iodev(struct kvm_io_device *dev)
+{
+	struct vgic_io_device *iodev;
+
+	if (dev->ops != &kvm_io_gic_ops)
+		return NULL;
+
+	iodev = container_of(dev, struct vgic_io_device, dev);
+
+	if (iodev->iodev_type != IODEV_ITS)
+		return NULL;
+
+	return iodev;
+}
+
 /*
  * Queries the KVM IO bus framework to get the ITS pointer from the given
  * doorbell address.
@@ -494,9 +509,11 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 
 	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
 	if (!kvm_io_dev)
-		return -ENODEV;
+		return -EINVAL;
 
-	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
+	iodev = vgic_get_its_iodev(kvm_io_dev);
+	if (!iodev)
+		return -EINVAL;
 
 	mutex_lock(&iodev->its->its_lock);
 	ret = vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
-- 
2.9.0

