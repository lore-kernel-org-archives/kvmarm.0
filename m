From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm64: its: Fix missing dynamic allocation check in scan_its_table
Date: Fri, 13 Oct 2017 12:52:59 +0200
Message-ID: <20171013105259.9728-1-christoffer.dall@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently allocate an entry dynamically, but we never check if the
allocation actually succeeded.  We actually don't need a dynamic
allocation, because we know the maximum size of an ITS table entry, so
we can simply use an allocation on the stack.

Cc: <stable@vger.kernel.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f51c1e1..555f42f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -176,6 +176,7 @@ static const struct vgic_its_abi its_table_abi_versions[] = {
 };
 
 #define NR_ITS_ABIS	ARRAY_SIZE(its_table_abi_versions)
+#define MAX_ENTRY_SIZE	8	/* Max Entry size across all ABI versions */
 
 inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
 {
@@ -1801,37 +1802,33 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
 static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 			  int start_id, entry_fn_t fn, void *opaque)
 {
-	void *entry = kzalloc(esz, GFP_KERNEL);
 	struct kvm *kvm = its->dev->kvm;
 	unsigned long len = size;
 	int id = start_id;
 	gpa_t gpa = base;
+	char entry[MAX_ENTRY_SIZE];
 	int ret;
 
+	memset(entry, 0, MAX_ENTRY_SIZE);
+
 	while (len > 0) {
 		int next_offset;
 		size_t byte_offset;
 
 		ret = kvm_read_guest(kvm, gpa, entry, esz);
 		if (ret)
-			goto out;
+			return ret;
 
 		next_offset = fn(its, id, entry, opaque);
-		if (next_offset <= 0) {
-			ret = next_offset;
-			goto out;
-		}
+		if (next_offset <= 0)
+			return next_offset;
 
 		byte_offset = next_offset * esz;
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;
 	}
-	ret =  1;
-
-out:
-	kfree(entry);
-	return ret;
+	return 1;
 }
 
 /**
-- 
2.9.0
