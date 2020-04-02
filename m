Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB2FC43331
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:53:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 993C02074D
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVxaC5cJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 993C02074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D104B16C;
	Thu,  2 Apr 2020 10:53:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ibOI-YKTJrSU; Thu,  2 Apr 2020 10:53:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 398474B102;
	Thu,  2 Apr 2020 10:53:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AB0F4B102
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:53:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IYOECfF9nu3C for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 10:53:19 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ECAB4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:53:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585839199;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Zl9FDtxwOI/FksilYChFV1G9aFjsIXI5j5prCQSwE+w=;
 b=EVxaC5cJQCvk2i+AunRroMS0JQvgvYAfr5aUMmwdXKBNgyO4kp7tqiGAt2PyWJMfbppUor
 0MQ5LTXyQhZvOULsD4n+rEt4eY8GgaKPjobXklsfkOCwN9J6qq3sSSX+QdLIDXaME6j6bH
 cgRhnGFHp4kIIUbRA272DYavyP9E3AU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-VHbW30qwMDCk_O8UzByfdQ-1; Thu, 02 Apr 2020 10:53:15 -0400
X-MC-Unique: VHbW30qwMDCk_O8UzByfdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B84E101FC68;
 Thu,  2 Apr 2020 14:53:13 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 660955D9CD;
 Thu,  2 Apr 2020 14:53:10 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v8 05/13] arm/arm64: gicv3: Set the LPI config
 and pending tables
Date: Thu,  2 Apr 2020 16:52:19 +0200
Message-Id: <20200402145227.20109-6-eric.auger@redhat.com>
In-Reply-To: <20200402145227.20109-1-eric.auger@redhat.com>
References: <20200402145227.20109-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Also introduce a helper routine that allows to set the pending
table bit for a given LPI and macros to set/get its configuration.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

---

v5 -> v6:
- fix the assert()
- remove GICR_PROPBASER_IDBITS_MASK
- remove gicv3_lpi_set_config and gicv3_lpi_get_config declarations
  and move macros in this patch

v4 -> v5:
- Moved some reformattings previously done in
  "arm/arm64: ITS: its_enable_defaults", in this patch
- added assert(!gicv3_redist_base()) in gicv3_lpi_alloc_tables()
- revert for_each_present_cpu() change

v2 -> v3:
- Move the helpers in lib/arm/gic-v3.c and prefix them with "gicv3_"
  and add _lpi prefix too

v1 -> v2:
- remove memory attributes
---
 lib/arm/asm/gic-v3.h | 17 ++++++++++++++
 lib/arm/gic-v3.c     | 53 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 47df051..fedffa8 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -50,6 +50,13 @@
 #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
 	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
 
+#define GICR_PENDBASER_PTZ		BIT_ULL(62)
+
+#define LPI_PROP_GROUP1			(1 << 1)
+#define LPI_PROP_ENABLED		(1 << 0)
+#define LPI_PROP_DEFAULT_PRIO		0xa0
+#define LPI_PROP_DEFAULT		(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | LPI_PROP_ENABLED)
+
 #include <asm/arch_gicv3.h>
 
 #ifndef __ASSEMBLY__
@@ -66,6 +73,8 @@ struct gicv3_data {
 	void *dist_base;
 	void *redist_bases[GICV3_NR_REDISTS];
 	void *redist_base[NR_CPUS];
+	u8 *lpi_prop;
+	void *lpi_pend[NR_CPUS];
 	unsigned int irq_nr;
 };
 extern struct gicv3_data gicv3_data;
@@ -82,6 +91,8 @@ extern void gicv3_write_eoir(u32 irqstat);
 extern void gicv3_ipi_send_single(int irq, int cpu);
 extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
 extern void gicv3_set_redist_base(size_t stride);
+extern void gicv3_lpi_set_clr_pending(int rdist, int n, bool set);
+extern void gicv3_lpi_alloc_tables(void);
 
 static inline void gicv3_do_wait_for_rwp(void *base)
 {
@@ -127,5 +138,11 @@ static inline u64 mpidr_uncompress(u32 compressed)
 	return mpidr;
 }
 
+#define gicv3_lpi_set_config(intid, value) ({		\
+	gicv3_data.lpi_prop[LPI_OFFSET(intid)] = value;	\
+})
+
+#define gicv3_lpi_get_config(intid) (gicv3_data.lpi_prop[LPI_OFFSET(intid)])
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_H_ */
diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index feecb5e..6cf1d1d 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -5,6 +5,7 @@
  */
 #include <asm/gic.h>
 #include <asm/io.h>
+#include <alloc_page.h>
 
 void gicv3_set_redist_base(size_t stride)
 {
@@ -147,3 +148,55 @@ void gicv3_ipi_send_single(int irq, int cpu)
 	cpumask_set_cpu(cpu, &dest);
 	gicv3_ipi_send_mask(irq, &dest);
 }
+
+#if defined(__aarch64__)
+
+/*
+ * alloc_lpi_tables - Allocate LPI config and pending tables
+ * and set PROPBASER (shared by all rdistributors) and per
+ * redistributor PENDBASER.
+ *
+ * gicv3_set_redist_base() must be called before
+ */
+void gicv3_lpi_alloc_tables(void)
+{
+	unsigned long n = SZ_64K >> PAGE_SHIFT;
+	unsigned long order = fls(n);
+	u64 prop_val;
+	int cpu;
+
+	assert(gicv3_redist_base());
+
+	gicv3_data.lpi_prop = alloc_pages(order);
+
+	/* ID bits = 13, ie. up to 14b LPI INTID */
+	prop_val = (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
+
+	for_each_present_cpu(cpu) {
+		u64 pend_val;
+		void *ptr;
+
+		ptr = gicv3_data.redist_base[cpu];
+
+		writeq(prop_val, ptr + GICR_PROPBASER);
+
+		gicv3_data.lpi_pend[cpu] = alloc_pages(order);
+		pend_val = (u64)(virt_to_phys(gicv3_data.lpi_pend[cpu]));
+		writeq(pend_val, ptr + GICR_PENDBASER);
+	}
+}
+
+void gicv3_lpi_set_clr_pending(int rdist, int n, bool set)
+{
+	u8 *ptr = gicv3_data.lpi_pend[rdist];
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
+#endif /* __aarch64__ */
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
