From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 4/4] KVM: arm/arm64: VGIC/ITS save/restore: protect kvm_read_guest() calls
Date: Fri, 11 May 2018 15:20:15 +0100
Message-ID: <20180511142015.21953-5-andre.przywara@arm.com>
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
Use the newly introduced wrapper for that.

Cc: Stable <stable@vger.kernel.org> # 4.12+
Reported-by: Jan Glauber <jan.glauber@caviumnetworks.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++--
 virt/kvm/arm/vgic/vgic-v3.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 7cb060e01a76..4ed79c939fb4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1897,7 +1897,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 		int next_offset;
 		size_t byte_offset;
 
-		ret = kvm_read_guest(kvm, gpa, entry, esz);
+		ret = kvm_read_guest_lock(kvm, gpa, entry, esz);
 		if (ret)
 			return ret;
 
@@ -2267,7 +2267,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	int ret;
 
 	BUG_ON(esz > sizeof(val));
-	ret = kvm_read_guest(kvm, gpa, &val, esz);
+	ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
 	if (ret)
 		return ret;
 	val = le64_to_cpu(val);
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index c7423f3768e5..bdcf8e7a6161 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -344,7 +344,7 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	bit_nr = irq->intid % BITS_PER_BYTE;
 	ptr = pendbase + byte_offset;
 
-	ret = kvm_read_guest(kvm, ptr, &val, 1);
+	ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
 	if (ret)
 		return ret;
 
@@ -397,7 +397,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		ptr = pendbase + byte_offset;
 
 		if (byte_offset != last_byte_offset) {
-			ret = kvm_read_guest(kvm, ptr, &val, 1);
+			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
 			if (ret)
 				return ret;
 			last_byte_offset = byte_offset;
-- 
2.14.1
