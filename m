From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 25/45] KVM: arm/arm64: vgic-new: Add GICv3 redistributor TYPER handler
Date: Fri, 25 Mar 2016 02:04:48 +0000
Message-ID: <1458871508-17279-26-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The redistributor TYPER tells the OS about the associated MPIDR,
also the LAST bit is crucial.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic_mmio.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 13e101f..6d74b00 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -652,6 +652,22 @@ static int vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * We use a compressed version of the MPIDR (all 32 bits in one 32-bit word)
+ * when we store the target MPIDR written by the guest.
+ */
+static u32 compress_mpidr(unsigned long mpidr)
+{
+	u32 ret;
+
+	ret = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+	ret |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8;
+	ret |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16;
+	ret |= MPIDR_AFFINITY_LEVEL(mpidr, 3) << 24;
+
+	return ret;
+}
+
 static int vgic_mmio_read_v3r_misc(struct kvm_vcpu *vcpu,
 				   struct kvm_io_device *this,
 				   gpa_t addr, int len, void *val)
@@ -672,6 +688,9 @@ static int vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 				   struct kvm_io_device *this,
 				   gpa_t addr, int len, void *val)
 {
+	write_mask32((PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0),
+		     addr & 3, len, val);
+
 	return 0;
 }
 
@@ -679,7 +698,18 @@ static int vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 				    struct kvm_io_device *this,
 				    gpa_t addr, int len, void *val)
 {
-	/* TODO: implement */
+	struct vgic_io_device *iodev = container_of(this,
+						    struct vgic_io_device, dev);
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(iodev->redist_vcpu);
+	int target_vcpu_id = iodev->redist_vcpu->vcpu_id;
+	u64 value;
+
+	value = (u64)compress_mpidr(mpidr) << 32;
+	value |= ((target_vcpu_id & 0xffff) << 8);
+	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
+		value |= GICR_TYPER_LAST;
+
+	write_mask64(value, addr & 7, len, val);
 	return 0;
 }
 
-- 
2.7.3

