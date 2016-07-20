From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 11/15] PCI: inject PCI device ID on MSI injection
Date: Wed, 20 Jul 2016 18:04:31 +0100
Message-ID: <20160720170435.28090-12-andre.przywara@arm.com>
References: <20160720170435.28090-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EF2649B53
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 12:57:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 34hBwz-OhjF4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 12:57:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB3D949B3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 12:57:52 -0400 (EDT)
In-Reply-To: <20160720170435.28090-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ITS emulation requires a unique device ID to be passed along the
MSI payload when kvmtool wants to trigger an MSI in the guest.
According to the proposed changes to the interface add the PCI
bus/device/function triple to the structure passed with the ioctl.
Check the respective capability before actually adding the device ID
to the kvm_msi struct.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virtio/pci.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 604b9ec..e9f81f7 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -318,14 +318,28 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 		update_msix_map(vpci, table, (addr - offset) / 16);
 }
 
-static void virtio_pci__signal_msi(struct kvm *kvm, struct virtio_pci *vpci, int vec)
+static void virtio_pci__signal_msi(struct kvm *kvm, struct virtio_pci *vpci,
+				   int vec)
 {
+	static int needs_devid = 0;
 	struct kvm_msi msi = {
 		.address_lo = vpci->msix_table[vec].msg.address_lo,
 		.address_hi = vpci->msix_table[vec].msg.address_hi,
 		.data = vpci->msix_table[vec].msg.data,
 	};
 
+	if (needs_devid == 0) {
+		if (kvm__supports_vm_extension(kvm, KVM_CAP_MSI_DEVID))
+			needs_devid = 1;
+		else
+			needs_devid = -1;
+	}
+
+	if (needs_devid > 0) {
+		msi.flags = KVM_MSI_VALID_DEVID;
+		msi.devid = vpci->dev_hdr.dev_num << 3;
+	}
+
 	ioctl(kvm->vm_fd, KVM_SIGNAL_MSI, &msi);
 }
 
-- 
2.9.0
