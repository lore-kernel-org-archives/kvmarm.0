Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3EDC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3D58619EE
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A3D58619EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560384B1CC;
	Mon,  8 Nov 2021 21:39:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mYLFqfpvZKtf; Mon,  8 Nov 2021 21:39:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7774B1B3;
	Mon,  8 Nov 2021 21:39:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5D34B1BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 46eeijIV1DqH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:16 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE2384B11E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:16 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 w4-20020a1709029a8400b00138e222b06aso7685846plp.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=loxMeAeqhpiKSvyXoOE21nDz6NxFuQUOOaGjcUtPr9Y=;
 b=MPBHIzvwhMn3f4yNpS714cQcUrKXhSzFKQhJJsxLnKNQ270GW+osyzjO9GvjzIpyiD
 1k0VBUDy5gEAe3BwH7vYKZniPHXtHs+f/a0jCvHUhVjKAiP177Xu5skV1xi3ytJ/uN8X
 u6bYt4Rlu2bZdGlg96xUNOoV2Y8TRV9XyavcoV4jmXmxVX36aXl4qYBWpn2myOO1AyuN
 kRxAJ3Gmdw9vMQhilsQlfH4ZYhBkMILM0tzSqgcQQpDkvXom+HrTVCRKYGIuZBLDMyhV
 V6ylEC7dCxpE3ShHS0oQyddi7Xnswq2xD1iSxLiCNJY7G5zBYQ13b9tztn6kzb6vQ5i4
 pdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=loxMeAeqhpiKSvyXoOE21nDz6NxFuQUOOaGjcUtPr9Y=;
 b=oo16HfTnQNyCWxpZHE1cI5vthGdq1xLhM4Jj7k0WNADv5zv26YyAhWJD+EBzS7kuH7
 Fk9lYgdbPm2Ei5/smU3go7dJ+zPu4Dfrpswo2O1g9DbZNQ0v6FXyIrIPj0mmMHFV4hyX
 GNFckAasXUw0unDEoyH9GGwtfTDDbze3mpxQv052QdLzvLGvrGWNl6IFsocgESio7nmY
 2yJnBxs+1fQdbUVKo4YrikTfvx7SX9krrup8nKOoL1yZTPMpn79bSG+llgNYB7lEAp7l
 WexqXmFLprUIk3jv2qyD9916TMJZ72yFyn01J0BLERXAN3mob4G65yj3AJfTb+UcwHoR
 Kmug==
X-Gm-Message-State: AOAM532US+pZdwHQ3DpGMLQ0EC+4hK86eB9hhi8yJwKomIyqxV3sFnAw
 dxcydXQdieahX0SV4DP+GAkpa+l91Yw1wg==
X-Google-Smtp-Source: ABdhPJx4by6npC6Bw0eZYMhu8Sm094t2D7pgKDmPKyanQSa9LkHub+gt4LWj8jhp7QyGQhSy5iSsdpoTBcdQ8w==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:9197:0:b0:44d:a2e9:72cf with SMTP id
 x23-20020aa79197000000b0044da2e972cfmr4519442pfa.38.1636425555973; Mon, 08
 Nov 2021 18:39:15 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:51 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 02/17] KVM: selftests: aarch64: add function for accessing
 GICv3 dist and redist registers
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add a generic library function for reading and writing GICv3 distributor
and redistributor registers. Then adapt some functions to use it; more
will come and use it in the next commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 124 ++++++++++++++----
 1 file changed, 101 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 2dbf3339b62e..00e944fd8148 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -19,7 +19,8 @@ struct gicv3_data {
 	unsigned int nr_spis;
 };
 
-#define sgi_base_from_redist(redist_base) (redist_base + SZ_64K)
+#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
+#define DIST_BIT				(1U << 31)
 
 enum gicv3_intid_range {
 	SGI_RANGE,
@@ -50,6 +51,14 @@ static void gicv3_gicr_wait_for_rwp(void *redist_base)
 	}
 }
 
+static void gicv3_wait_for_rwp(uint32_t cpu_or_dist)
+{
+	if (cpu_or_dist & DIST_BIT)
+		gicv3_gicd_wait_for_rwp();
+	else
+		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu_or_dist]);
+}
+
 static enum gicv3_intid_range get_intid_range(unsigned int intid)
 {
 	switch (intid) {
@@ -81,39 +90,108 @@ static void gicv3_write_eoir(uint32_t irq)
 	isb();
 }
 
-static void
-gicv3_config_irq(unsigned int intid, unsigned int offset)
+uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, uint64_t offset)
+{
+	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
+		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
+	return readl(base + offset);
+}
+
+void gicv3_reg_writel(uint32_t cpu_or_dist, uint64_t offset, uint32_t reg_val)
+{
+	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
+		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
+	writel(reg_val, base + offset);
+}
+
+uint32_t gicv3_getl_fields(uint32_t cpu_or_dist, uint64_t offset, uint32_t mask)
+{
+	return gicv3_reg_readl(cpu_or_dist, offset) & mask;
+}
+
+void gicv3_setl_fields(uint32_t cpu_or_dist, uint64_t offset,
+		uint32_t mask, uint32_t reg_val)
+{
+	uint32_t tmp = gicv3_reg_readl(cpu_or_dist, offset) & ~mask;
+
+	tmp |= (reg_val & mask);
+	gicv3_reg_writel(cpu_or_dist, offset, tmp);
+}
+
+/*
+ * We use a single offset for the distributor and redistributor maps as they
+ * have the same value in both. The only exceptions are registers that only
+ * exist in one and not the other, like GICR_WAKER that doesn't exist in the
+ * distributor map. Such registers are conveniently marked as reserved in the
+ * map that doesn't implement it; like GICR_WAKER's offset of 0x0014 being
+ * marked as "Reserved" in the Distributor map.
+ */
+static void gicv3_access_reg(uint32_t intid, uint64_t offset,
+		uint32_t reg_bits, uint32_t bits_per_field,
+		bool write, uint32_t *val)
 {
 	uint32_t cpu = guest_get_vcpuid();
-	uint32_t mask = 1 << (intid % 32);
 	enum gicv3_intid_range intid_range = get_intid_range(intid);
-	void *reg;
-
-	/* We care about 'cpu' only for SGIs or PPIs */
-	if (intid_range == SGI_RANGE || intid_range == PPI_RANGE) {
-		GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
-
-		reg = sgi_base_from_redist(gicv3_data.redist_base[cpu]) +
-			offset;
-		writel(mask, reg);
-		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu]);
-	} else if (intid_range == SPI_RANGE) {
-		reg = gicv3_data.dist_base + offset + (intid / 32) * 4;
-		writel(mask, reg);
-		gicv3_gicd_wait_for_rwp();
-	} else {
-		GUEST_ASSERT(0);
-	}
+	uint32_t fields_per_reg, index, mask, shift;
+	uint32_t cpu_or_dist;
+
+	GUEST_ASSERT(bits_per_field <= reg_bits);
+	GUEST_ASSERT(*val < (1U << bits_per_field));
+	/* Some registers like IROUTER are 64 bit long. Those are currently not
+	 * supported by readl nor writel, so just asserting here until then.
+	 */
+	GUEST_ASSERT(reg_bits == 32);
+
+	fields_per_reg = reg_bits / bits_per_field;
+	index = intid % fields_per_reg;
+	shift = index * bits_per_field;
+	mask = ((1U << bits_per_field) - 1) << shift;
+
+	/* Set offset to the actual register holding intid's config. */
+	offset += (intid / fields_per_reg) * (reg_bits / 8);
+
+	cpu_or_dist = (intid_range == SPI_RANGE) ? DIST_BIT : cpu;
+
+	if (write)
+		gicv3_setl_fields(cpu_or_dist, offset, mask, *val << shift);
+	*val = gicv3_getl_fields(cpu_or_dist, offset, mask) >> shift;
+}
+
+static void gicv3_write_reg(uint32_t intid, uint64_t offset,
+		uint32_t reg_bits, uint32_t bits_per_field, uint32_t val)
+{
+	gicv3_access_reg(intid, offset, reg_bits,
+			bits_per_field, true, &val);
+}
+
+static uint32_t gicv3_read_reg(uint32_t intid, uint64_t offset,
+		uint32_t reg_bits, uint32_t bits_per_field)
+{
+	uint32_t val;
+
+	gicv3_access_reg(intid, offset, reg_bits,
+			bits_per_field, false, &val);
+	return val;
 }
 
 static void gicv3_irq_enable(unsigned int intid)
 {
-	gicv3_config_irq(intid, GICD_ISENABLER);
+	bool is_spi = get_intid_range(intid) == SPI_RANGE;
+	unsigned int val = 1;
+	uint32_t cpu = guest_get_vcpuid();
+
+	gicv3_write_reg(intid, GICD_ISENABLER, 32, 1, val);
+	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
 static void gicv3_irq_disable(unsigned int intid)
 {
-	gicv3_config_irq(intid, GICD_ICENABLER);
+	bool is_spi = get_intid_range(intid) == SPI_RANGE;
+	uint32_t val = 1;
+	uint32_t cpu = guest_get_vcpuid();
+
+	gicv3_write_reg(intid, GICD_ICENABLER, 32, 1, val);
+	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
 static void gicv3_enable_redist(void *redist_base)
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
