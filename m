From: Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC 04/15] arm/arm64: ITS: BASER parsing and setup
Date: Mon,  5 Dec 2016 22:46:35 +0100
Message-ID: <1480974406-29345-5-git-send-email-eric.auger@redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0BB405A8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sIjhuyfhCOnh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 16:46:20 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 453D040421
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:20 -0500 (EST)
In-Reply-To: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Add helper routines to parse BASER registers and set them up

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h | 72 +++++++++++++++++++++++++++++++++++++++++++
 lib/arm/gic-v3-its.c     | 79 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 2044565..2fdc042 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -10,13 +10,85 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/setup.h>
+#include <asm/io.h>
+
+#define GITS_BASER                      0x0100
+
+#define GITS_BASER_NR_REGS              8
+
+#define GITS_BASER_VALID                        (1UL << 63)
+#define GITS_BASER_INDIRECT                     (1ULL << 62)
+
+#define GITS_BASER_INNER_CACHEABILITY_SHIFT     (59)
+#define GITS_BASER_OUTER_CACHEABILITY_SHIFT     (53)
+#define GITS_BASER_INNER_CACHEABILITY_MASK                              \
+	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, MASK)
+#define GITS_BASER_CACHEABILITY_MASK            GITS_BASER_INNER_CACHEABILITY_MASK
+#define GITS_BASER_OUTER_CACHEABILITY_MASK                              \
+	GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, MASK)
+#define GITS_BASER_SHAREABILITY_MASK                                    \
+	GIC_BASER_SHAREABILITY(GITS_BASER, SHAREABILITY_MASK)
+
+#define GITS_BASER_nCnB         GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nCnB)
+#define GITS_BASER_nC           GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nC)
+#define GITS_BASER_RaWt         GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWt)
+#define GITS_BASER_RaWb         GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWt)
+#define GITS_BASER_WaWt         GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWt)
+#define GITS_BASER_WaWb         GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWb)
+#define GITS_BASER_RaWaWt       GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWt)
+#define GITS_BASER_RaWaWb       GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWb)
+
+#define GITS_BASER_TYPE_SHIFT                   (56)
+#define GITS_BASER_TYPE(r)              (((r) >> GITS_BASER_TYPE_SHIFT) & 7)
+#define GITS_BASER_ENTRY_SIZE_SHIFT             (48)
+#define GITS_BASER_ENTRY_SIZE(r)        ((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
+#define GITS_BASER_SHAREABILITY_SHIFT   (10)
+#define GITS_BASER_InnerShareable                                       \
+	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
+#define GITS_BASER_PAGE_SIZE_SHIFT      (8)
+#define GITS_BASER_PAGE_SIZE_4K         (0UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_16K        (1UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_64K        (2UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_MASK       (3UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGES_MAX            256
+#define GITS_BASER_PAGES_SHIFT          (0)
+#define GITS_BASER_NR_PAGES(r)          (((r) & 0xff) + 1)
+
+#define GITS_BASER_TYPE_NONE            0
+#define GITS_BASER_TYPE_DEVICE          1
+#define GITS_BASER_TYPE_VCPU            2
+#define GITS_BASER_TYPE_CPU             3
+#define GITS_BASER_TYPE_COLLECTION      4
+#define GITS_BASER_TYPE_RESERVED5       5
+#define GITS_BASER_TYPE_RESERVED6       6
+#define GITS_BASER_TYPE_RESERVED7       7
+
+struct its_baser {
+	unsigned int index;
+	int type;
+	u64 cache;
+	int shr;
+	size_t psz;
+	int nr_pages;
+	bool indirect;
+	phys_addr_t table_addr;
+	bool valid;
+	int esz;
+};
+
 struct its_data {
 	void *base;
+	struct its_baser baser[GITS_BASER_NR_REGS];
 };
 
 extern struct its_data its_data;
 
 #define gicv3_its_base()		(its_data.base)
 
+extern int its_parse_baser(int i, struct its_baser *baser);
+extern void its_setup_baser(int i, struct its_baser *baser);
+
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index e382b80..225a72e 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -7,3 +7,82 @@
 
 struct its_data its_data;
 
+static const char * const its_base_type_string[] = {
+	[GITS_BASER_TYPE_DEVICE]        = "Devices",
+	[GITS_BASER_TYPE_VCPU]          = "Virtual CPUs",
+	[GITS_BASER_TYPE_CPU]           = "Physical CPUs",
+	[GITS_BASER_TYPE_COLLECTION]    = "Interrupt Collections",
+	[GITS_BASER_TYPE_RESERVED5]     = "Reserved (5)",
+	[GITS_BASER_TYPE_RESERVED6]     = "Reserved (6)",
+	[GITS_BASER_TYPE_RESERVED7]     = "Reserved (7)",
+};
+
+int its_parse_baser(int i, struct its_baser *baser)
+{
+	void *reg_addr = gicv3_its_base() + GITS_BASER + i * 8;
+	u64 val = readq(reg_addr);
+	int inner_cache;
+
+	if (!val) {
+		memset(baser, 0, sizeof(*baser));
+		return -1;
+	}
+
+	baser->valid = val & GITS_BASER_VALID;
+	baser->indirect = val & GITS_BASER_INDIRECT;
+	baser->type = GITS_BASER_TYPE(val);
+	baser->esz = GITS_BASER_ENTRY_SIZE(val);
+	baser->nr_pages = GITS_BASER_NR_PAGES(val);
+	baser->table_addr = (val >> 12) & 36;
+	inner_cache = (val >> 59) & 0x7;
+	baser->cache = inner_cache;
+	switch (val & GITS_BASER_PAGE_SIZE_MASK) {
+	case GITS_BASER_PAGE_SIZE_4K:
+		baser->psz = SZ_4K;
+		break;
+	case GITS_BASER_PAGE_SIZE_16K:
+		baser->psz = SZ_16K;
+		break;
+	case GITS_BASER_PAGE_SIZE_64K:
+		baser->psz = SZ_64K;
+		break;
+	default:
+		baser->psz = SZ_64K;
+	}
+	baser->shr = (val >> 10) & 0x3;
+
+	return 0;
+}
+
+void its_setup_baser(int i, struct its_baser *baser)
+{
+	void *reg_addr = gicv3_its_base() + GITS_BASER + i * 8;
+	u64 val = readq(reg_addr);
+
+	baser->table_addr =
+		(u64)phys_zalloc(baser->psz * baser->nr_pages);
+
+	val = ((u64)baser->table_addr					|
+		((u64)baser->type << GITS_BASER_TYPE_SHIFT)		|
+		((u64)(baser->esz - 1) << GITS_BASER_ENTRY_SIZE_SHIFT)	|
+		((baser->nr_pages - 1) << GITS_BASER_PAGES_SHIFT)	|
+		baser->cache						|
+		baser->shr						|
+		GITS_BASER_VALID);
+
+	val |=  baser->indirect ? GITS_BASER_INDIRECT : 0x0;
+	switch (baser->psz) {
+	case SZ_4K:
+		val |= GITS_BASER_PAGE_SIZE_4K;
+		break;
+	case SZ_16K:
+		val |= GITS_BASER_PAGE_SIZE_16K;
+		break;
+	case SZ_64K:
+		val |= GITS_BASER_PAGE_SIZE_64K;
+		break;
+	}
+
+	writeq(val, reg_addr);
+}
+
-- 
2.5.5
