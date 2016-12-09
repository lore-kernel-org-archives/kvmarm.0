From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/6] KVM: arm64: vgic-its: Fix compatibility with 32-bit
Date: Fri,  9 Dec 2016 15:53:26 +0000
Message-ID: <1481298811-30798-2-git-send-email-marc.zyngier@arm.com>
References: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Andre Przywara <andre.przywara@arm.com>, Longpeng <longpeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

Evaluate GITS_BASER_ENTRY_SIZE once as an int data (GITS_BASER<n>'s
Entry Size is 5-bit wide only), so when used as divider no reference
to __aeabi_uldivmod is generated when build for AArch32.

Use unsigned long long for GITS_BASER_PAGE_SIZE_* since they are
used in conjunction with 64-bit data.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |  8 ++++----
 virt/kvm/arm/vgic/vgic-its.c       | 11 ++++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index b7e3431..0deea34 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -295,10 +295,10 @@
 #define GITS_BASER_InnerShareable					\
 	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
 #define GITS_BASER_PAGE_SIZE_SHIFT	(8)
-#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
-#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
-#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
-#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_4K		(0ULL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_16K	(1ULL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_64K	(2ULL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_MASK	(3ULL << GITS_BASER_PAGE_SIZE_SHIFT)
 #define GITS_BASER_PAGES_MAX		256
 #define GITS_BASER_PAGES_SHIFT		(0)
 #define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4660a7d..8c2b3cd 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -632,21 +632,22 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
 	int index;
 	u64 indirect_ptr;
 	gfn_t gfn;
+	int esz = GITS_BASER_ENTRY_SIZE(baser);
 
 	if (!(baser & GITS_BASER_INDIRECT)) {
 		phys_addr_t addr;
 
-		if (id >= (l1_tbl_size / GITS_BASER_ENTRY_SIZE(baser)))
+		if (id >= (l1_tbl_size / esz))
 			return false;
 
-		addr = BASER_ADDRESS(baser) + id * GITS_BASER_ENTRY_SIZE(baser);
+		addr = BASER_ADDRESS(baser) + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
 		return kvm_is_visible_gfn(its->dev->kvm, gfn);
 	}
 
 	/* calculate and check the index into the 1st level */
-	index = id / (SZ_64K / GITS_BASER_ENTRY_SIZE(baser));
+	index = id / (SZ_64K / esz);
 	if (index >= (l1_tbl_size / sizeof(u64)))
 		return false;
 
@@ -670,8 +671,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
 	indirect_ptr &= GENMASK_ULL(51, 16);
 
 	/* Find the address of the actual entry */
-	index = id % (SZ_64K / GITS_BASER_ENTRY_SIZE(baser));
-	indirect_ptr += index * GITS_BASER_ENTRY_SIZE(baser);
+	index = id % (SZ_64K / esz);
+	indirect_ptr += index * esz;
 	gfn = indirect_ptr >> PAGE_SHIFT;
 
 	return kvm_is_visible_gfn(its->dev->kvm, gfn);
-- 
2.1.4

