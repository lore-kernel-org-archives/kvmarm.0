From: Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests RFC 10/15] arm/arm64: ITS: its_enable_defaults
Date: Mon,  5 Dec 2016 22:46:41 +0100
Message-ID: <1480974406-29345-11-git-send-email-eric.auger@redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CEEB40296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ynLyA84NZc-C for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 16:46:44 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 821AF402A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 16:46:44 -0500 (EST)
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

its_enable_defaults() is the top init function that allocates all
the requested tables (device, collection, lpi config and pending
tables), enable LPIs at distributor level and ITS level.

gicv3_enable_defaults must be called before.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h | 10 ++++++++++
 lib/arm/gic-v3-its.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 353db6f..b73736c 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -33,6 +33,7 @@
 #define GICR_PROPBASER_InnerShareable                                   \
 	GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable)
 
+#define GITS_CTLR                       0x0000
 #define GITS_TYPER                      0x0008
 #define GITS_CBASER                     0x0080
 #define GITS_CWRITER                    0x0088
@@ -46,6 +47,8 @@
 #define GITS_TYPER_PTA                  (1UL << 19)
 #define GITS_TYPER_HWCOLLCNT_SHIFT      24
 
+#define GITS_CTLR_ENABLE                (1U << 0)
+
 #define GITS_CBASER_VALID                       (1UL << 63)
 #define GITS_CBASER_SHAREABILITY_SHIFT          (10)
 #define GITS_CBASER_INNER_CACHEABILITY_SHIFT    (59)
@@ -151,6 +154,11 @@ struct its_typer {
 	bool virt_lpi;
 };
 
+struct its_collection {
+	u64 target_address;
+	u16 col_id;
+};
+
 struct its_data {
 	void *base;
 	struct its_cmd_block *cmd_base;
@@ -158,6 +166,7 @@ struct its_data {
 	struct its_cmd_block *cmd_readr;
 	struct its_baser baser[GITS_BASER_NR_REGS];
 	struct its_typer typer;
+	struct its_collection *collections;
 	u64 flags;
 };
 
@@ -169,6 +178,7 @@ extern void its_parse_typer(void);
 extern int its_parse_baser(int i, struct its_baser *baser);
 extern void its_setup_baser(int i, struct its_baser *baser);
 extern void enable_lpi(u32 redist);
+extern void its_enable_defaults(void);
 
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index c8ffa53..ecb8f98 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -212,3 +212,49 @@ void enable_lpi(u32 redist)
 	val |= GICR_CTLR_ENABLE_LPIS;
 	writel(val,  ptr + GICR_CTLR);
 }
+
+void its_enable_defaults(void)
+{
+	unsigned int i;
+
+	its_parse_typer();
+
+	/* Allocate BASER tables (device and collection tables) */
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		struct its_baser *baser = &its_data.baser[i];
+		int ret;
+
+		ret = its_parse_baser(i, baser);
+		if (ret)
+			continue;
+
+		switch (baser->type) {
+		case GITS_BASER_TYPE_DEVICE:
+			if (baser->valid)
+				continue;
+			baser->cache = GITS_BASER_nCnB;
+			its_setup_baser(i, baser);
+			break;
+		case GITS_BASER_TYPE_COLLECTION:
+			if (baser->valid)
+				continue;
+			its_setup_baser(i, baser);
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* Allocate LPI config and pending tables */
+	alloc_lpi_tables();
+
+	its_data.collections = malloc(gicv3_data.cpu_count *
+			       sizeof(struct its_collection));
+
+	init_cmd_queue();
+
+	for (i = 0; i < gicv3_data.cpu_count; i++)
+		enable_lpi(i);
+
+	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
+}
-- 
2.5.5
