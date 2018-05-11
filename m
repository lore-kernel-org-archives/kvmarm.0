From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 3/4] KVM: arm/arm64: VGIC/ITS: protect kvm_read_guest() calls with SRCU lock
Date: Fri, 11 May 2018 15:20:14 +0100
Message-ID: <20180511142015.21953-4-andre.przywara@arm.com>
References: <20180511142015.21953-1-andre.przywara@arm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180511142015.21953-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stable <stable@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

kvm_read_guest() will eventually look up in kvm_memslots(), which requires
either to hold the kvm->slots_lock or to be inside a kvm->srcu critical
section.
In contrast to x86 and s390 we don't take the SRCU lock on every guest
exit, so we have to do it individually for each kvm_read_guest() call.

Provide a wrapper which does that and use that everywhere.

Note that ending the SRCU critical section before returning from the
kvm_read_guest() wrapper is safe, because the data has been *copied*, so
we don't need to rely on valid references to the memslot anymore.

Cc: Stable <stable@vger.kernel.org> # 4.8+
Reported-by: Jan Glauber <jan.glauber@caviumnetworks.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 16 ++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic-its.c     | 15 ++++++++-------
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 707a1f06dc5d..f675162663f0 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -309,6 +309,22 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return 8;
 }
 
+/*
+ * We are not in the kvm->srcu critical section most of the time, so we take
+ * the SRCU read lock here. Since we copy the data from the user page, we
+ * can immediately drop the lock again.
+ */
+static inline int kvm_read_guest_lock(struct kvm *kvm,
+				      gpa_t gpa, void *data, unsigned long len)
+{
+	int srcu_idx = srcu_read_lock(&kvm->srcu);
+	int ret = kvm_read_guest(kvm, gpa, data, len);
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	return ret;
+}
+
 static inline void *kvm_get_hyp_vector(void)
 {
 	return kvm_ksym_ref(__kvm_hyp_vector);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 082110993647..6128992c2ded 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -360,6 +360,22 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
+/*
+ * We are not in the kvm->srcu critical section most of the time, so we take
+ * the SRCU read lock here. Since we copy the data from the user page, we
+ * can immediately drop the lock again.
+ */
+static inline int kvm_read_guest_lock(struct kvm *kvm,
+				      gpa_t gpa, void *data, unsigned long len)
+{
+	int srcu_idx = srcu_read_lock(&kvm->srcu);
+	int ret = kvm_read_guest(kvm, gpa, data, len);
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	return ret;
+}
+
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 /*
  * EL2 vectors can be mapped and rerouted in a number of ways,
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 51a80b600632..7cb060e01a76 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -281,8 +281,8 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	int ret;
 	unsigned long flags;
 
-	ret = kvm_read_guest(kvm, propbase + irq->intid - GIC_LPI_OFFSET,
-			     &prop, 1);
+	ret = kvm_read_guest_lock(kvm, propbase + irq->intid - GIC_LPI_OFFSET,
+				  &prop, 1);
 
 	if (ret)
 		return ret;
@@ -444,8 +444,9 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 		 * this very same byte in the last iteration. Reuse that.
 		 */
 		if (byte_offset != last_byte_offset) {
-			ret = kvm_read_guest(vcpu->kvm, pendbase + byte_offset,
-					     &pendmask, 1);
+			ret = kvm_read_guest_lock(vcpu->kvm,
+						  pendbase + byte_offset,
+						  &pendmask, 1);
 			if (ret) {
 				kfree(intids);
 				return ret;
@@ -789,7 +790,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 		return false;
 
 	/* Each 1st level entry is represented by a 64-bit value. */
-	if (kvm_read_guest(its->dev->kvm,
+	if (kvm_read_guest_lock(its->dev->kvm,
 			   BASER_ADDRESS(baser) + index * sizeof(indirect_ptr),
 			   &indirect_ptr, sizeof(indirect_ptr)))
 		return false;
@@ -1370,8 +1371,8 @@ static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
 	cbaser = CBASER_ADDRESS(its->cbaser);
 
 	while (its->cwriter != its->creadr) {
-		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
-					 cmd_buf, ITS_CMD_SIZE);
+		int ret = kvm_read_guest_lock(kvm, cbaser + its->creadr,
+					      cmd_buf, ITS_CMD_SIZE);
 		/*
 		 * If kvm_read_guest() fails, this could be due to the guest
 		 * programming a bogus value in CBASER or something else going
-- 
2.14.1
