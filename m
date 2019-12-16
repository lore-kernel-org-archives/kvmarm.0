Return-Path: <SRS0=GAmw=2G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F8FC43603
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:04:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A30020684
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GmSkT6+p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A30020684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12CDD4A5A6;
	Mon, 16 Dec 2019 09:04:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WAk-L1zmzK0l; Mon, 16 Dec 2019 09:04:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C35A64A5A8;
	Mon, 16 Dec 2019 09:04:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 083864A319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:04:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TdBOunT9RU7U for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Dec 2019 09:04:06 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E654A5A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:04:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576505046;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=J4yj3ipSn03wddNlzO5ReaAlW0xImmllc7BWwVZtIu4=;
 b=GmSkT6+piM9hFNuV9f9tDD6sAKvK4gMPVi0B+vava7JOSErORkMp1TppqLccjV1mjzJuVB
 TdHqzj3nEmQpiLaDuBXdBfVTVy2aR+/8AERW1MgalYx7c58AKCAq+syo5+d3ib5auo4N4z
 Pi87qmXz4SA5r6mZ0X2UJW4EpejVomQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-AMQbqdvGO9uyh3GUAy7FKQ-1; Mon, 16 Dec 2019 09:04:05 -0500
X-MC-Unique: AMQbqdvGO9uyh3GUAy7FKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92B8B100728B;
 Mon, 16 Dec 2019 14:04:03 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3D0E6675B8;
 Mon, 16 Dec 2019 14:03:58 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH 07/16] arm/arm64: ITS: Set the LPI config and
 pending tables
Date: Mon, 16 Dec 2019 15:02:26 +0100
Message-Id: <20191216140235.10751-8-eric.auger@redhat.com>
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

Allocate the LPI configuration and per re-distributor pending table.
Set redistributor's PROPBASER and PENDBASER. The LPIs are enabled
by default in the config table.

Also introduce a helper routine that allows to set the pending table
bit for a given LPI.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 lib/arm/asm/gic-v3-its.h |  3 ++
 lib/arm/asm/gic-v3.h     | 79 ++++++++++++++++++++++++++++++++++++++++
 lib/arm/gic-v3-its.c     | 65 +++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 0c0178d..0d11aed 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -128,6 +128,9 @@ extern void its_init(void);
 extern int its_parse_baser(int i, struct its_baser *baser);
 extern void its_setup_baser(int i, struct its_baser *baser);
 extern struct its_baser *its_lookup_baser(int type);
+extern void set_lpi_config(int n, u8 val);
+extern u8 get_lpi_config(int n);
+extern void set_pending_table_bit(int rdist, int n, bool set);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index d02f4a4..5bf9a92 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -47,6 +47,83 @@
 #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
 	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
 
+#define GIC_BASER_CACHE_nCnB            0ULL
+#define GIC_BASER_CACHE_SameAsInner     0ULL
+#define GIC_BASER_CACHE_nC              1ULL
+#define GIC_BASER_CACHE_RaWt            2ULL
+#define GIC_BASER_CACHE_RaWb            3ULL
+#define GIC_BASER_CACHE_WaWt            4ULL
+#define GIC_BASER_CACHE_WaWb            5ULL
+#define GIC_BASER_CACHE_RaWaWt          6ULL
+#define GIC_BASER_CACHE_RaWaWb          7ULL
+#define GIC_BASER_CACHE_MASK            7ULL
+#define GIC_BASER_NonShareable          0ULL
+#define GIC_BASER_InnerShareable        1ULL
+#define GIC_BASER_OuterShareable        2ULL
+#define GIC_BASER_SHAREABILITY_MASK     3ULL
+
+#define GIC_BASER_CACHEABILITY(reg, inner_outer, type)                  \
+	(GIC_BASER_CACHE_##type << reg##_##inner_outer##_CACHEABILITY_SHIFT)
+
+#define GIC_BASER_SHAREABILITY(reg, type)                               \
+	(GIC_BASER_##type << reg##_SHAREABILITY_SHIFT)
+
+#define GICR_PROPBASER_SHAREABILITY_SHIFT               (10)
+#define GICR_PROPBASER_INNER_CACHEABILITY_SHIFT         (7)
+#define GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT         (56)
+#define GICR_PROPBASER_SHAREABILITY_MASK                                \
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, SHAREABILITY_MASK)
+#define GICR_PROPBASER_INNER_CACHEABILITY_MASK                          \
+	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, MASK)
+#define GICR_PROPBASER_OUTER_CACHEABILITY_MASK                          \
+	GIC_BASER_CACHEABILITY(GICR_PROPBASER, OUTER, MASK)
+#define GICR_PROPBASER_CACHEABILITY_MASK GICR_PROPBASER_INNER_CACHEABILITY_MASK
+
+#define GICR_PROPBASER_InnerShareable                                   \
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable)
+
+#define GICR_PROPBASER_nCnB     GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nCnB)
+#define GICR_PROPBASER_nC       GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nC)
+#define GICR_PROPBASER_RaWt     GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWt)
+#define GICR_PROPBASER_RaWb     GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWt)
+#define GICR_PROPBASER_WaWt     GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWt)
+#define GICR_PROPBASER_WaWb     GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWb)
+#define GICR_PROPBASER_RaWaWt   GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWt)
+#define GICR_PROPBASER_RaWaWb   GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWb)
+
+#define GICR_PROPBASER_IDBITS_MASK                      (0x1f)
+
+#define GICR_PENDBASER_SHAREABILITY_SHIFT               (10)
+#define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT         (7)
+#define GICR_PENDBASER_OUTER_CACHEABILITY_SHIFT         (56)
+#define GICR_PENDBASER_SHAREABILITY_MASK                                \
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, SHAREABILITY_MASK)
+#define GICR_PENDBASER_INNER_CACHEABILITY_MASK                          \
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, MASK)
+#define GICR_PENDBASER_OUTER_CACHEABILITY_MASK                          \
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, OUTER, MASK)
+#define GICR_PENDBASER_CACHEABILITY_MASK GICR_PENDBASER_INNER_CACHEABILITY_MASK
+
+#define GICR_PENDBASER_InnerShareable                                   \
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable)
+
+#define GICR_PENDBASER_nCnB     GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nCnB)
+#define GICR_PENDBASER_nC       GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nC)
+#define GICR_PENDBASER_RaWt     GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWt)
+#define GICR_PENDBASER_RaWb     GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWt)
+#define GICR_PENDBASER_WaWt     GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWt)
+#define GICR_PENDBASER_WaWb     GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWb)
+#define GICR_PENDBASER_RaWaWt   GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWt)
+#define GICR_PENDBASER_RaWaWb   GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWb)
+
+#define GICR_PENDBASER_PTZ                              BIT_ULL(62)
+
+#define LPI_PROP_GROUP1		(1 << 1)
+#define LPI_PROP_ENABLED	(1 << 0)
+#define LPI_PROP_DEFAULT_PRIO   0xa0
+#define LPI_PROP_DEFAULT	(LPI_PROP_DEFAULT_PRIO |			\
+				LPI_PROP_GROUP1 | LPI_PROP_ENABLED)
+
 #include <asm/arch_gicv3.h>
 
 #ifndef __ASSEMBLY__
@@ -63,6 +140,8 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_bases[GICV3_NR_REDISTS];
 	void *redist_base[NR_CPUS];
+	void *lpi_prop;
+	void *lpi_pend[NR_CPUS];
 	unsigned int irq_nr;
 };
 extern struct gicv3_data gicv3_data;
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 303022f..0b5a700 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -123,3 +123,68 @@ void its_setup_baser(int i, struct its_baser *baser)
 	writeq(val, gicv3_its_base() + GITS_BASER + i * 8);
 }
 
+inline void set_lpi_config(int n, u8 value)
+{
+	u8 *entry = (u8 *)(gicv3_data.lpi_prop + (n - 8192));
+	*entry = value;
+}
+
+inline u8 get_lpi_config(int n)
+{
+	u8 *entry = (u8 *)(gicv3_data.lpi_prop + (n - 8192));
+	return *entry;
+}
+
+/* alloc_lpi_tables: Allocate LPI config and pending tables */
+void alloc_lpi_tables(void);
+void alloc_lpi_tables(void)
+{
+	unsigned long n = SZ_64K >> PAGE_SHIFT;
+	unsigned long order = fls(n);
+	u64 prop_val;
+	int cpu;
+
+	gicv3_data.lpi_prop = (void *)virt_to_phys(alloc_pages(order));
+
+	/* ID bits = 13, ie. up to 14b LPI INTID */
+	prop_val = ((u64)gicv3_data.lpi_prop |
+			GICR_PROPBASER_InnerShareable |
+			GICR_PROPBASER_WaWb |
+			(13 & GICR_PROPBASER_IDBITS_MASK));
+
+	/*
+	 * Allocate pending tables for each redistributor
+	 * and set PROPBASER and PENDBASER
+	 */
+	for_each_present_cpu(cpu) {
+		u64 pend_val;
+		void *ptr;
+
+		ptr = gicv3_data.redist_base[cpu];
+
+		writeq(prop_val, ptr + GICR_PROPBASER);
+
+		gicv3_data.lpi_pend[cpu] =
+			(void *)virt_to_phys(alloc_pages(order));
+
+		pend_val = ((u64)gicv3_data.lpi_pend[cpu] |
+			GICR_PENDBASER_InnerShareable |
+			GICR_PENDBASER_WaWb);
+
+		writeq(pend_val, ptr + GICR_PENDBASER);
+	}
+}
+
+void set_pending_table_bit(int rdist, int n, bool set)
+{
+	u8 *ptr = phys_to_virt((phys_addr_t)gicv3_data.lpi_pend[rdist]);
+	u8 mask = 1 << (n % 8), byte;
+
+	ptr += (n / 8);
+	byte = *ptr;
+	if (set)
+		byte |=  mask;
+	else
+		byte &= ~mask;
+	*ptr = byte;
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
