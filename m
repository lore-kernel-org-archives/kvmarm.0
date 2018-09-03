From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests] arm/arm64: gicv3: support two redistributor
 regions
Date: Mon,  3 Sep 2018 18:45:07 +0200
Message-ID: <20180903164507.24544-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A02424A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 12:45:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f-p0tj-asvGu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 12:45:11 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE1DE49F94
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 12:45:11 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

We need to support two redistributor regions in order to support
more than 123 vcpus. Also bump NR_CPUS to 512, since that's what
KVM currently supports.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---

So far only regression tested on TCG.


 lib/arm/asm/gic-v3.h | 20 +++++++++++++++++---
 lib/arm/asm/setup.h  |  2 +-
 lib/arm/gic-v3.c     | 39 +++++++++++++++++++++++++++++----------
 lib/arm/gic.c        | 16 +++++++++++++---
 4 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 1dceb9541f62..a04e58bd438b 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -49,16 +49,30 @@
 #include <asm/smp.h>
 #include <asm/io.h>
 
+#define GICV3_REDIST0_NR_CPUS 123
+
 struct gicv3_data {
 	void *dist_base;
-	void *redist_base[NR_CPUS];
+	void *redist_base[GICV3_REDIST0_NR_CPUS];
+	void *redist2_base[NR_CPUS - GICV3_REDIST0_NR_CPUS];
 	unsigned int irq_nr;
 };
 extern struct gicv3_data gicv3_data;
 
+#define gicv3_redist_base()								\
+({											\
+	int __cpu = smp_processor_id();							\
+	void *__base;									\
+											\
+	if (__cpu < GICV3_REDIST0_NR_CPUS)						\
+		__base = gicv3_data.redist_base[__cpu];					\
+	else										\
+		__base = gicv3_data.redist2_base[__cpu - GICV3_REDIST0_NR_CPUS];	\
+											\
+	__base;										\
+})
 #define gicv3_dist_base()		(gicv3_data.dist_base)
-#define gicv3_redist_base()		(gicv3_data.redist_base[smp_processor_id()])
-#define gicv3_sgi_base()		(gicv3_data.redist_base[smp_processor_id()] + SZ_64K)
+#define gicv3_sgi_base()		(gicv3_redist_base() + SZ_64K)
 
 extern int gicv3_init(void);
 extern void gicv3_enable_defaults(void);
diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index b57ea13b9dd2..3215814603e4 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -9,7 +9,7 @@
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
 
-#define NR_CPUS			255
+#define NR_CPUS			512
 extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
 extern int nr_cpus;
 
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index 9b3fa5730478..e7a48c988cab 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -6,20 +6,39 @@
 #include <asm/gic.h>
 #include <asm/io.h>
 
+static void __gicv3_set_redist_base(void *ptr)
+{
+	int cpu = smp_processor_id();
+
+	if (cpu < GICV3_REDIST0_NR_CPUS)
+		gicv3_data.redist_base[cpu] = ptr;
+	else
+		gicv3_data.redist2_base[cpu - GICV3_REDIST0_NR_CPUS] = ptr;
+}
+
 void gicv3_set_redist_base(size_t stride)
 {
 	u32 aff = mpidr_compress(get_mpidr());
-	void *ptr = gicv3_data.redist_base[0];
+	void *redist_base[] =  {
+		gicv3_data.redist_base[0],
+		gicv3_data.redist2_base[0],
+	};
+	void *ptr;
 	u64 typer;
-
-	do {
-		typer = gicv3_read_typer(ptr + GICR_TYPER);
-		if ((typer >> 32) == aff) {
-			gicv3_redist_base() = ptr;
-			return;
-		}
-		ptr += stride; /* skip RD_base, SGI_base, etc. */
-	} while (!(typer & GICR_TYPER_LAST));
+	int i = 0;
+
+	while (redist_base[i]) {
+		ptr = redist_base[i];
+		do {
+			typer = gicv3_read_typer(ptr + GICR_TYPER);
+			if ((typer >> 32) == aff) {
+				__gicv3_set_redist_base(ptr);
+				return;
+			}
+			ptr += stride; /* skip RD_base, SGI_base, etc. */
+		} while (!(typer & GICR_TYPER_LAST));
+		++i;
+	}
 
 	/* should never reach here */
 	assert(0);
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 59273b1716d6..81973c47d487 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -44,7 +44,7 @@ static const struct gic_common_ops gicv3_common_ops = {
  * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
  */
 static bool
-gic_get_dt_bases(const char *compatible, void **base1, void **base2)
+gic_get_dt_bases(const char *compatible, void **base1, void **base2, void **base3)
 {
 	struct dt_pbus_reg reg;
 	struct dt_device gic;
@@ -70,19 +70,29 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
 	assert(ret == 0);
 	*base2 = ioremap(reg.addr, reg.size);
 
+	if (base3) {
+		ret = dt_pbus_translate(&gic, 2, &reg);
+		if (ret != -FDT_ERR_NOTFOUND) {
+			assert(ret == 0);
+			*base3 = ioremap(reg.addr, reg.size);
+		} else {
+			*base3 = NULL;
+		}
+	}
+
 	return true;
 }
 
 int gicv2_init(void)
 {
 	return gic_get_dt_bases("arm,cortex-a15-gic",
-			&gicv2_data.dist_base, &gicv2_data.cpu_base);
+			&gicv2_data.dist_base, &gicv2_data.cpu_base, NULL);
 }
 
 int gicv3_init(void)
 {
 	return gic_get_dt_bases("arm,gic-v3", &gicv3_data.dist_base,
-			&gicv3_data.redist_base[0]);
+			&gicv3_data.redist_base[0], &gicv3_data.redist2_base[0]);
 }
 
 int gic_version(void)
-- 
2.17.1
