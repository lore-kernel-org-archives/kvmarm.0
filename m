Return-Path: <SRS0=Utlv=43=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155C2C18E5B
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 14:54:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4A6421D56
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 14:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H++iVz6i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4A6421D56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FD674A94D;
	Tue, 10 Mar 2020 10:54:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eG7bKUI2q-Fx; Tue, 10 Mar 2020 10:54:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C953A4A4A9;
	Tue, 10 Mar 2020 10:54:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 053C94A4A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2020 10:54:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HjNjCuGNrlUQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Mar 2020 10:54:53 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F1F4A49C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2020 10:54:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583852093;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iQBKhcavu8aBWU8FXyWV8KDa4Aw3KY5gn5DJvcdt0Ic=;
 b=H++iVz6iP/q23cloFN2dG6Dtby/AUNscjNlEOk3aNvZ8nyIB8+ObULdtTToSrJiE5n3H8W
 xn7tIurnYadv8mZ/ECxi/3DejbJfk0AvkFUjdJ122Vdg738juh4cWog5qp5cbd3zNRB5a/
 dXetCbWD348j228H82/3RfXDe7h0V8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-BXGRu4b3OF-WlUNWzu-n8A-1; Tue, 10 Mar 2020 10:54:52 -0400
X-MC-Unique: BXGRu4b3OF-WlUNWzu-n8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C2A119067E1;
 Tue, 10 Mar 2020 14:54:50 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-85.ams2.redhat.com [10.36.117.85])
 by smtp.corp.redhat.com (Postfix) with ESMTP id DE5D560BF3;
 Tue, 10 Mar 2020 14:54:45 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v5 06/13] arm/arm64: ITS: Introspection tests
Date: Tue, 10 Mar 2020 15:54:03 +0100
Message-Id: <20200310145410.26308-7-eric.auger@redhat.com>
In-Reply-To: <20200310145410.26308-1-eric.auger@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
Parse the BASER registers. As part of the init sequence we
also init all the requested tables.

This is our first ITS test, belonging to a new "its" group.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5:
- Moved test_its_introspection() stub from
  lib/arm/asm/gic-v3-its.h back to arm/gic.c
- 32b its_init does report_abort()
- remove kerneldoc style comment
- remove alloc_lpi_tables from its_init()

v3 -> v4:
- fixed some typos, refine trace msgs
- move its files to lib/arm64 instead of lib/arm
- create lib/arm/asm/gic-v3-its.h containing stubs
- rework gic_get_dt_bases
- rework baser parsing
- move table allocation to init routine
- use get_order()

v2 -> v3:
- updated dates and changed author
- squash "arm/arm64: ITS: Test BASER" into this patch but
  removes setup_baser which will be introduced later.
- only compile on aarch64
- restrict the new test to aarch64

v1 -> v2:
- clean GITS_TYPER macros and unused fields in typer struct
- remove memory attribute related macros
- remove everything related to memory attributes
- s/dev_baser/coll_baser/ in report_info
- add extra line
- removed index filed in its_baser
---
 arm/Makefile.arm64         |  1 +
 arm/gic.c                  | 48 ++++++++++++++++++
 arm/unittests.cfg          |  7 +++
 lib/arm/asm/gic-v3-its.h   | 22 +++++++++
 lib/arm/gic.c              | 34 +++++++++++--
 lib/arm64/asm/gic-v3-its.h | 92 +++++++++++++++++++++++++++++++++++
 lib/arm64/gic-v3-its.c     | 99 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 298 insertions(+), 5 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm64/asm/gic-v3-its.h
 create mode 100644 lib/arm64/gic-v3-its.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 6d3dc2c..60182ae 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -19,6 +19,7 @@ endef
 cstart.o = $(TEST_DIR)/cstart64.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
+cflatobjs += lib/arm64/gic-v3-its.o
 
 OBJDIRS += lib/arm64
 
diff --git a/arm/gic.c b/arm/gic.c
index 2f904b0..649ed81 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -16,6 +16,7 @@
 #include <asm/processor.h>
 #include <asm/delay.h>
 #include <asm/gic.h>
+#include <asm/gic-v3-its.h>
 #include <asm/smp.h>
 #include <asm/barrier.h>
 #include <asm/io.h>
@@ -517,6 +518,49 @@ static void gic_test_mmio(void)
 		test_targets(nr_irqs);
 }
 
+#if defined(__arm__)
+
+static void test_its_introspection(void) {}
+
+#else /* __aarch64__ */
+
+static void test_its_introspection(void)
+{
+	struct its_baser *dev_baser = &its_data.device_baser;
+	struct its_baser *coll_baser = &its_data.coll_baser;
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
+	report_info("Target address format %s",
+			typer->pta ? "Redist base address" : "PE #");
+
+	report(dev_baser && coll_baser, "detect device and collection BASER");
+	report_info("device table entry_size = 0x%x", dev_baser->esz);
+	report_info("collection table entry_size = 0x%x", coll_baser->esz);
+}
+
+#endif
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -548,6 +592,10 @@ int main(int argc, char **argv)
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
index 017958d..23d378e 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -122,6 +122,13 @@ smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'active'
 groups = gic
 
+[its-introspection]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'its-introspection'
+groups = its
+arch = arm64
+
 # Test PSCI emulation
 [psci]
 file = psci.flat
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
new file mode 100644
index 0000000..2167099
--- /dev/null
+++ b/lib/arm/asm/gic-v3-its.h
@@ -0,0 +1,22 @@
+/*
+ * ITS 32-bit stubs
+ *
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+
+#ifndef _ASMARM_GIC_V3_ITS_H_
+#define _ASMARM_GIC_V3_ITS_H_
+
+/* dummy its_data struct to allow gic_get_dt_bases() call */
+struct its_data {
+	void *base;
+};
+
+static inline void its_init(void)
+{
+	report_abort("not supported on 32-bit");
+}
+
+#endif /* _ASMARM_GICv3_ITS_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index c3c5f6b..4f6f15b 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -6,9 +6,11 @@
 #include <devicetree.h>
 #include <asm/gic.h>
 #include <asm/io.h>
+#include <asm/gic-v3-its.h>
 
 struct gicv2_data gicv2_data;
 struct gicv3_data gicv3_data;
+struct its_data its_data;
 
 struct gic_common_ops {
 	void (*enable_defaults)(void);
@@ -44,12 +46,13 @@ static const struct gic_common_ops gicv3_common_ops = {
  * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
  */
 static bool
-gic_get_dt_bases(const char *compatible, void **base1, void **base2)
+gic_get_dt_bases(const char *compatible, void **base1, void **base2, void **base3)
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
@@ -74,19 +77,39 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
 		base2[i] = ioremap(reg.addr, reg.size);
 	}
 
+	if (!base3) {
+		assert(!strcmp(compatible, "arm,cortex-a15-gic"));
+		return true;
+	}
+
+	assert(!strcmp(compatible, "arm,gic-v3"));
+
+	dt_for_each_subnode(node, subnode) {
+		const struct fdt_property *prop;
+
+		prop = fdt_get_property(fdt, subnode, "compatible", &len);
+		if (!strcmp((char *)prop->data, "arm,gic-v3-its")) {
+			dt_device_bind_node(&its, subnode);
+			ret = dt_pbus_translate(&its, 0, &reg);
+			assert(ret == 0);
+			*base3 = ioremap(reg.addr, reg.size);
+			break;
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
-			&gicv3_data.redist_bases[0]);
+			&gicv3_data.redist_bases[0], &its_data.base);
 }
 
 int gic_version(void)
@@ -104,6 +127,7 @@ int gic_init(void)
 		gic_common_ops = &gicv2_common_ops;
 	else if (gicv3_init())
 		gic_common_ops = &gicv3_common_ops;
+	its_init();
 	return gic_version();
 }
 
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
new file mode 100644
index 0000000..331ba0e
--- /dev/null
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -0,0 +1,92 @@
+/*
+ * All ITS* defines are lifted from include/linux/irqchip/arm-gic-v3.h
+ *
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM64_GIC_V3_ITS_H_
+#define _ASMARM64_GIC_V3_ITS_H_
+
+struct its_typer {
+	unsigned int ite_size;
+	unsigned int eventid_bits;
+	unsigned int deviceid_bits;
+	unsigned int collid_bits;
+	bool pta;
+	bool phys_lpi;
+	bool virt_lpi;
+};
+
+struct its_baser {
+	int index;
+	size_t psz;
+	int esz;
+	bool indirect;
+	phys_addr_t table_addr;
+};
+
+#define GITS_BASER_NR_REGS              8
+
+struct its_data {
+	void *base;
+	struct its_typer typer;
+	struct its_baser device_baser;
+	struct its_baser coll_baser;
+	struct its_cmd_block *cmd_base;
+	struct its_cmd_block *cmd_write;
+};
+
+extern struct its_data its_data;
+
+#define gicv3_its_base()		(its_data.base)
+
+#define GITS_CTLR			0x0000
+#define GITS_IIDR			0x0004
+#define GITS_TYPER			0x0008
+#define GITS_CBASER			0x0080
+#define GITS_CWRITER			0x0088
+#define GITS_CREADR			0x0090
+#define GITS_BASER			0x0100
+
+#define GITS_TYPER_PLPIS                BIT(0)
+#define GITS_TYPER_VLPIS		BIT(1)
+#define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
+#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
+#define GITS_TYPER_IDBITS		GENMASK_ULL(8, 12)
+#define GITS_TYPER_IDBITS_SHIFT         8
+#define GITS_TYPER_DEVBITS		GENMASK_ULL(13, 17)
+#define GITS_TYPER_DEVBITS_SHIFT        13
+#define GITS_TYPER_PTA                  BIT(19)
+#define GITS_TYPER_CIDBITS		GENMASK_ULL(32, 35)
+#define GITS_TYPER_CIDBITS_SHIFT	32
+#define GITS_TYPER_CIL			BIT(36)
+
+#define GITS_CTLR_ENABLE		(1U << 0)
+
+#define GITS_CBASER_VALID		(1UL << 63)
+
+#define GITS_BASER_VALID		BIT(63)
+#define GITS_BASER_INDIRECT		BIT(62)
+#define GITS_BASER_TYPE_SHIFT		(56)
+#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
+#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
+#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
+#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
+#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGES_MAX		256
+#define GITS_BASER_PAGES_SHIFT		(0)
+#define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
+#define GITS_BASER_PHYS_ADDR_MASK	0xFFFFFFFFF000
+#define GITS_BASER_TYPE_NONE		0
+#define GITS_BASER_TYPE_DEVICE		1
+#define GITS_BASER_TYPE_COLLECTION	4
+
+extern void its_parse_typer(void);
+extern void its_init(void);
+extern int its_baser_lookup(int i, struct its_baser *baser);
+
+#endif /* _ASMARM64_GIC_V3_ITS_H_ */
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
new file mode 100644
index 0000000..4c9c0db
--- /dev/null
+++ b/lib/arm64/gic-v3-its.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/gic.h>
+#include <alloc_page.h>
+#include <asm/gic-v3-its.h>
+
+void its_parse_typer(void)
+{
+	u64 typer = readq(gicv3_its_base() + GITS_TYPER);
+	struct its_typer *t = &its_data.typer;
+
+	t->ite_size = ((typer & GITS_TYPER_ITT_ENTRY_SIZE) >> GITS_TYPER_ITT_ENTRY_SIZE_SHIFT) + 1;
+	t->pta = typer & GITS_TYPER_PTA;
+	t->eventid_bits = ((typer & GITS_TYPER_IDBITS) >> GITS_TYPER_IDBITS_SHIFT) + 1;
+	t->deviceid_bits = ((typer & GITS_TYPER_DEVBITS) >> GITS_TYPER_DEVBITS_SHIFT) + 1;
+
+	if (typer & GITS_TYPER_CIL)
+		t->collid_bits = ((typer & GITS_TYPER_CIDBITS) >> GITS_TYPER_CIDBITS_SHIFT) + 1;
+	else
+		t->collid_bits = 16;
+
+	t->virt_lpi = typer & GITS_TYPER_VLPIS;
+	t->phys_lpi = typer & GITS_TYPER_PLPIS;
+}
+
+int its_baser_lookup(int type, struct its_baser *baser)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		void *reg_addr = gicv3_its_base() + GITS_BASER + i * 8;
+		u64 val = readq(reg_addr);
+
+		if (GITS_BASER_TYPE(val) == type) {
+			assert((val & GITS_BASER_PAGE_SIZE_MASK) == GITS_BASER_PAGE_SIZE_64K);
+			baser->esz = GITS_BASER_ENTRY_SIZE(val);
+			baser->indirect = val & GITS_BASER_INDIRECT;
+			baser->index = i;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+/*
+ * Allocate the BASER table (a single page of size @baser->psz)
+ * and set the BASER valid
+ */
+static void its_baser_alloc_table(struct its_baser *baser, size_t size)
+{
+	unsigned long order = get_order(size >> PAGE_SHIFT);
+	void *reg_addr = gicv3_its_base() + GITS_BASER + baser->index * 8;
+	u64 val = readq(reg_addr);
+
+	baser->table_addr = (u64)virt_to_phys(alloc_pages(order));
+
+	val |= (u64)baser->table_addr | GITS_BASER_VALID;
+
+	writeq(val, reg_addr);
+}
+
+/*
+ * init_cmd_queue - Allocate the command queue and initialize
+ * CBASER, CWRITER
+ */
+static void its_cmd_queue_init(void)
+{
+	unsigned long order = get_order(SZ_64K >> PAGE_SHIFT);
+	u64 cbaser;
+
+	its_data.cmd_base = (void *)virt_to_phys(alloc_pages(order));
+
+	cbaser = ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)	| GITS_CBASER_VALID);
+
+	writeq(cbaser, its_data.base + GITS_CBASER);
+
+	its_data.cmd_write = its_data.cmd_base;
+	writeq(0, its_data.base + GITS_CWRITER);
+}
+
+void its_init(void)
+{
+	if (!its_data.base)
+		return;
+
+	its_parse_typer();
+
+	assert(!its_baser_lookup(GITS_BASER_TYPE_DEVICE, &its_data.device_baser));
+	assert(!its_baser_lookup(GITS_BASER_TYPE_COLLECTION, &its_data.coll_baser));
+
+	its_baser_alloc_table(&its_data.device_baser, SZ_64K);
+	its_baser_alloc_table(&its_data.coll_baser, SZ_64K);
+
+	its_cmd_queue_init();
+}
+
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
