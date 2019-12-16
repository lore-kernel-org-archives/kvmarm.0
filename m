Return-Path: <SRS0=GAmw=2G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847E0C2D0C3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:04:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D5D120684
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZQwGiDgW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D5D120684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E90384A586;
	Mon, 16 Dec 2019 09:04:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dC0svtH5YEM2; Mon, 16 Dec 2019 09:04:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FE474A4C0;
	Mon, 16 Dec 2019 09:04:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF10A4A535
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:03:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ib0iTYb4RXBg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Dec 2019 09:03:58 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB844ACBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:03:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576505037;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VTbMEgV9QnedN5K97l8ttQss70ssTQM1tBlGgU23A1E=;
 b=ZQwGiDgW1glxOyha+t7LoDAYviNK3hxJiVUddsq14WAvcdKWpsYwqQdFWlwDhhyqwbE7Fw
 e/M105lTbyfcYKj5BTavwiQaTgB/UFKqvKXaADocPM9RlbVyJwvy+ObjpvgdzocRlwCbdD
 UJgDYj57qLi89hPdkOkd+vNtAAtzXVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-y-TEE1S-M12pskfSJZ9Uhg-1; Mon, 16 Dec 2019 09:03:56 -0500
X-MC-Unique: y-TEE1S-M12pskfSJZ9Uhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C92D1007288;
 Mon, 16 Dec 2019 14:03:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B2C05675B8;
 Mon, 16 Dec 2019 14:03:51 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH 05/16] arm/arm64: ITS: Introspection tests
Date: Mon, 16 Dec 2019 15:02:24 +0100
Message-Id: <20191216140235.10751-6-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: andre.przywara@arm.com, thuth@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Detect the presence of an ITS as part of the GICv3 init
routine, initialize its base address and read few registers
the IIDR, the TYPER to store its dimensioning parameters.

This is our first ITS test, belonging to a new "its" group.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/Makefile.common        |   1 +
 arm/gic.c                  |  34 +++++++++++
 arm/unittests.cfg          |   6 ++
 lib/arm/asm/gic-v3-its.h   | 116 +++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h          |   1 +
 lib/arm/gic-v3-its.c       |  41 +++++++++++++
 lib/arm/gic.c              |  31 ++++++++--
 lib/arm64/asm/gic-v3-its.h |   1 +
 8 files changed, 226 insertions(+), 5 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm/gic-v3-its.c
 create mode 100644 lib/arm64/asm/gic-v3-its.h

diff --git a/arm/Makefile.common b/arm/Makefile.common
index b8988f2..1aae5a3 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -52,6 +52,7 @@ cflatobjs += lib/arm/psci.o
 cflatobjs += lib/arm/smp.o
 cflatobjs += lib/arm/delay.o
 cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
+cflatobjs += lib/arm/gic-v3-its.o
 
 OBJDIRS += lib/arm
 
diff --git a/arm/gic.c b/arm/gic.c
index ba43ae5..adeb981 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -506,6 +506,36 @@ static void gic_test_mmio(void)
 		test_targets(nr_irqs);
 }
 
+static void test_its_introspection(void)
+{
+	struct its_typer *typer = &its_data.typer;
+
+	if (!gicv3_its_base()) {
+		report_skip("No ITS, skip ...");
+		return;
+	}
+
+	/* IIDR */
+	report(test_readonly_32(gicv3_its_base() + GITS_IIDR, false),
+	       "GITS_IIDR is read-only"),
+
+	/* TYPER */
+	report(test_readonly_32(gicv3_its_base() + GITS_TYPER, false),
+	       "GITS_TYPER is read-only");
+
+	report(typer->phys_lpi, "ITS supports physical LPIs");
+	report_info("vLPI support: %s", typer->virt_lpi ? "yes" : "no");
+	report_info("ITT entry size = 0x%x", typer->ite_size);
+	report_info("Bit Count: EventID=%d DeviceId=%d CollId=%d",
+		    typer->eventid_bits, typer->deviceid_bits,
+		    typer->collid_bits);
+	report(typer->eventid_bits && typer->deviceid_bits &&
+	       typer->collid_bits, "ID spaces");
+	report(!typer->hw_collections, "collections only in ext memory");
+	report_info("Target address format %s",
+			typer->pta ? "Redist basse address" : "PE #");
+}
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -537,6 +567,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		gic_test_mmio();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "its-introspection") == 0) {
+		report_prefix_push(argv[1]);
+		test_its_introspection();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a0..bd20460 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -122,6 +122,12 @@ smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'active'
 groups = gic
 
+[its-introspection]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'its-introspection'
+groups = its
+
 # Test PSCI emulation
 [psci]
 file = psci.flat
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
new file mode 100644
index 0000000..2ce483e
--- /dev/null
+++ b/lib/arm/asm/gic-v3-its.h
@@ -0,0 +1,116 @@
+/*
+ * All ITS* defines are lifted from include/linux/irqchip/arm-gic-v3.h
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_GIC_V3_ITS_H_
+#define _ASMARM_GIC_V3_ITS_H_
+
+#ifndef __ASSEMBLY__
+
+#define GITS_CTLR			0x0000
+#define GITS_IIDR			0x0004
+#define GITS_TYPER			0x0008
+#define GITS_CBASER			0x0080
+#define GITS_CWRITER			0x0088
+#define GITS_CREADR			0x0090
+#define GITS_BASER			0x0100
+
+#define GITS_TYPER_PLPIS                (1UL << 0)
+#define GITS_TYPER_IDBITS_SHIFT         8
+#define GITS_TYPER_DEVBITS_SHIFT        13
+#define GITS_TYPER_DEVBITS(r)           ((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
+#define GITS_TYPER_PTA                  (1UL << 19)
+#define GITS_TYPER_HWCOLLCNT_SHIFT      24
+
+#define GITS_CTLR_ENABLE                (1U << 0)
+
+#define GITS_CBASER_VALID                       (1UL << 63)
+#define GITS_CBASER_SHAREABILITY_SHIFT          (10)
+#define GITS_CBASER_INNER_CACHEABILITY_SHIFT    (59)
+#define GITS_CBASER_OUTER_CACHEABILITY_SHIFT    (53)
+#define GITS_CBASER_SHAREABILITY_MASK                                   \
+	GIC_BASER_SHAREABILITY(GITS_CBASER, SHAREABILITY_MASK)
+#define GITS_CBASER_INNER_CACHEABILITY_MASK                             \
+	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, MASK)
+#define GITS_CBASER_OUTER_CACHEABILITY_MASK                             \
+	GIC_BASER_CACHEABILITY(GITS_CBASER, OUTER, MASK)
+#define GITS_CBASER_CACHEABILITY_MASK GITS_CBASER_INNER_CACHEABILITY_MASK
+
+#define GITS_CBASER_InnerShareable                                      \
+	GIC_BASER_SHAREABILITY(GITS_CBASER, InnerShareable)
+
+#define GITS_CBASER_nCnB        GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nCnB)
+#define GITS_CBASER_nC          GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nC)
+#define GITS_CBASER_RaWt        GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWt)
+#define GITS_CBASER_RaWb        GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWt)
+#define GITS_CBASER_WaWt        GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWt)
+#define GITS_CBASER_WaWb        GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
+#define GITS_CBASER_RaWaWt      GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
+#define GITS_CBASER_RaWaWb      GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
+
+#define GITS_BASER_NR_REGS              8
+
+#define GITS_BASER_VALID                        (1UL << 63)
+#define GITS_BASER_INDIRECT                     (1ULL << 62)
+
+#define GITS_BASER_INNER_CACHEABILITY_SHIFT     (59)
+#define GITS_BASER_OUTER_CACHEABILITY_SHIFT     (53)
+#define GITS_BASER_CACHEABILITY_MASK		0x7
+
+#define GITS_BASER_nCnB         GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nCnB)
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
+#define GITS_BASER_PHYS_ADDR_MASK	0xFFFFFFFFF000
+
+#define GITS_BASER_TYPE_NONE            0
+#define GITS_BASER_TYPE_DEVICE          1
+#define GITS_BASER_TYPE_VCPU            2
+#define GITS_BASER_TYPE_CPU             3
+#define GITS_BASER_TYPE_COLLECTION      4
+
+#define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
+
+struct its_typer {
+	unsigned int ite_size;
+	unsigned int eventid_bits;
+	unsigned int deviceid_bits;
+	unsigned int collid_bits;
+	unsigned int hw_collections;
+	bool pta;
+	bool cil;
+	bool cct;
+	bool phys_lpi;
+	bool virt_lpi;
+};
+
+struct its_data {
+	void *base;
+	struct its_typer typer;
+};
+
+extern struct its_data its_data;
+
+#define gicv3_its_base()		(its_data.base)
+
+extern void its_parse_typer(void);
+extern void its_init(void);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 55dd84b..b44da9c 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -40,6 +40,7 @@
 
 #include <asm/gic-v2.h>
 #include <asm/gic-v3.h>
+#include <asm/gic-v3-its.h>
 
 #define PPI(irq)			((irq) + 16)
 #define SPI(irq)			((irq) + GIC_FIRST_SPI)
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
new file mode 100644
index 0000000..34f4d0e
--- /dev/null
+++ b/lib/arm/gic-v3-its.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2016, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/gic.h>
+
+struct its_data its_data;
+
+void its_parse_typer(void)
+{
+	u64 typer = readq(gicv3_its_base() + GITS_TYPER);
+
+	its_data.typer.ite_size = ((typer >> 4) & 0xf) + 1;
+	its_data.typer.pta = typer & GITS_TYPER_PTA;
+	its_data.typer.eventid_bits =
+		((typer >> GITS_TYPER_IDBITS_SHIFT) & 0x1f) + 1;
+	its_data.typer.deviceid_bits = GITS_TYPER_DEVBITS(typer) + 1;
+
+	its_data.typer.cil = (typer >> 36) & 0x1;
+	if (its_data.typer.cil)
+		its_data.typer.collid_bits = ((typer >> 32) & 0xf) + 1;
+	else
+		its_data.typer.collid_bits = 16;
+
+	its_data.typer.hw_collections =
+		(typer >> GITS_TYPER_HWCOLLCNT_SHIFT) & 0xff;
+
+	its_data.typer.cct = typer & 0x4;
+	its_data.typer.virt_lpi = typer & 0x2;
+	its_data.typer.phys_lpi = typer & GITS_TYPER_PLPIS;
+}
+
+void its_init(void)
+{
+	if (!its_data.base)
+		return;
+
+	its_parse_typer();
+}
+
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 8416dde..f9a6f57 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -6,6 +6,7 @@
 #include <devicetree.h>
 #include <asm/gic.h>
 #include <asm/io.h>
+#include <asm/gic-v3-its.h>
 
 struct gicv2_data gicv2_data;
 struct gicv3_data gicv3_data;
@@ -44,12 +45,14 @@ static const struct gic_common_ops gicv3_common_ops = {
  * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
  */
 static bool
-gic_get_dt_bases(const char *compatible, void **base1, void **base2)
+gic_get_dt_bases(const char *compatible, void **base1, void **base2,
+		 void **base3)
 {
 	struct dt_pbus_reg reg;
-	struct dt_device gic;
+	struct dt_device gic, its;
 	struct dt_bus bus;
-	int node, ret, i;
+	int node, subnode, ret, i, len;
+	const void *fdt = dt_fdt();
 
 	dt_bus_init_defaults(&bus);
 	dt_device_init(&gic, &bus, NULL);
@@ -74,19 +77,36 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
 		base2[i] = ioremap(reg.addr, reg.size);
 	}
 
+	if (base3 && !strcmp(compatible, "arm,gic-v3")) {
+		dt_for_each_subnode(node, subnode) {
+			const struct fdt_property *prop;
+
+			prop = fdt_get_property(fdt, subnode,
+						"compatible", &len);
+			if (!strcmp((char *)prop->data, "arm,gic-v3-its")) {
+				dt_device_bind_node(&its, subnode);
+				ret = dt_pbus_translate(&its, 0, &reg);
+				assert(ret == 0);
+				*base3 = ioremap(reg.addr, reg.size);
+				break;
+			}
+		}
+
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
-			&gicv3_data.redist_bases[0]);
+			&gicv3_data.redist_bases[0], &its_data.base);
 }
 
 int gic_version(void)
@@ -104,6 +124,7 @@ int gic_init(void)
 		gic_common_ops = &gicv2_common_ops;
 	else if (gicv3_init())
 		gic_common_ops = &gicv3_common_ops;
+	its_init();
 	return gic_version();
 }
 
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
new file mode 100644
index 0000000..083cba4
--- /dev/null
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -0,0 +1 @@
+#include "../../arm/asm/gic-v3-its.h"
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
