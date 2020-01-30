Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F852C33C9E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:26:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7ED6206D3
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:26:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRaayDIZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7ED6206D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A202F4A598;
	Thu, 30 Jan 2020 06:26:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZoeAKrP0+0ei; Thu, 30 Jan 2020 06:26:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1FA4A5C6;
	Thu, 30 Jan 2020 06:26:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0DB4A597
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I45EQVLaMyn4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 06:26:18 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2BA4AEB2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:26:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580383578;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xlSr73pKSiopKdILGn5ZrLva3IOgBSdl74YTmPimHio=;
 b=PRaayDIZfj7m2sJLh6lfWU1Ev6vgd5VpL098R8bMuJqUTVBgvKBEcvRhos0nkyRA239Xyf
 vYjJhn9b/w6QDxUjit314YZsbhME/+F6uOE5o768ZABbE8O44xlJIyyH+zRCNJKC/osYsB
 7FhmVBM0v/4XQGgGn5ECKYOd/ppmm/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-jz5A5r2LO1mGfIqljQT66A-1; Thu, 30 Jan 2020 06:26:16 -0500
X-MC-Unique: jz5A5r2LO1mGfIqljQT66A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C35FA800D4E;
 Thu, 30 Jan 2020 11:26:14 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D73E71001B05;
 Thu, 30 Jan 2020 11:26:07 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v2 8/9] arm: gic: Provide per-IRQ helper
 functions
Date: Thu, 30 Jan 2020 12:25:09 +0100
Message-Id: <20200130112510.15154-9-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: andrew.murray@arm.com, andre.przywara@arm.com
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

From: Andre Przywara <andre.przywara@arm.com>

A common theme when accessing per-IRQ parameters in the GIC distributor
is to set fields of a certain bit width in a range of MMIO registers.
Examples are the enabled status (one bit per IRQ), the level/edge
configuration (2 bits per IRQ) or the priority (8 bits per IRQ).

Add a generic helper function which is able to mask and set the
respective number of bits, given the IRQ number and the MMIO offset.
Provide wrappers using this function to easily allow configuring an IRQ.

For now assume that private IRQ numbers always refer to the current CPU.
In a GICv2 accessing the "other" private IRQs is not easily doable (the
registers are banked per CPU on the same MMIO address), so we impose the
same limitation on GICv3, even though those registers are not banked
there anymore.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

---

initialize reg
---
 lib/arm/asm/gic-v3.h |  2 +
 lib/arm/asm/gic.h    |  9 +++++
 lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 347be2f..4a445a5 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -23,6 +23,8 @@
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_IROUTER			0x6000
+
 /* Re-Distributor registers, offsets from RD_base */
 #define GICR_TYPER			0x0008
 
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 1fc10a0..21cdb58 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -15,6 +15,7 @@
 #define GICD_IIDR			0x0008
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
+#define GICD_ICENABLER			0x0180
 #define GICD_ISPENDR			0x0200
 #define GICD_ICPENDR			0x0280
 #define GICD_ISACTIVER			0x0300
@@ -73,5 +74,13 @@ extern void gic_write_eoir(u32 irqstat);
 extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
 
+void gic_set_irq_bit(int irq, int offset);
+void gic_enable_irq(int irq);
+void gic_disable_irq(int irq);
+void gic_set_irq_priority(int irq, u8 prio);
+void gic_set_irq_target(int irq, int cpu);
+void gic_set_irq_group(int irq, int group);
+int gic_get_irq_group(int irq);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 9430116..aa9cb86 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -146,3 +146,93 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
 	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
 	gic_common_ops->ipi_send_mask(irq, dest);
 }
+
+enum gic_bit_access {
+	ACCESS_READ,
+	ACCESS_SET,
+	ACCESS_RMW
+};
+
+static u8 gic_masked_irq_bits(int irq, int offset, int bits, u8 value,
+			      enum gic_bit_access access)
+{
+	void *base;
+	int split = 32 / bits;
+	int shift = (irq % split) * bits;
+	u32 reg = 0, mask = ((1U << bits) - 1) << shift;
+
+	switch (gic_version()) {
+	case 2:
+		base = gicv2_dist_base();
+		break;
+	case 3:
+		if (irq < 32)
+			base = gicv3_sgi_base();
+		else
+			base = gicv3_dist_base();
+		break;
+	default:
+		return 0;
+	}
+	base += offset + (irq / split) * 4;
+
+	switch (access) {
+	case ACCESS_READ:
+		return (readl(base) & mask) >> shift;
+	case ACCESS_SET:
+		reg = 0;
+		break;
+	case ACCESS_RMW:
+		reg = readl(base) & ~mask;
+		break;
+	}
+
+	writel(reg | ((u32)value << shift), base);
+
+	return 0;
+}
+
+void gic_set_irq_bit(int irq, int offset)
+{
+	gic_masked_irq_bits(irq, offset, 1, 1, ACCESS_SET);
+}
+
+void gic_enable_irq(int irq)
+{
+	gic_set_irq_bit(irq, GICD_ISENABLER);
+}
+
+void gic_disable_irq(int irq)
+{
+	gic_set_irq_bit(irq, GICD_ICENABLER);
+}
+
+void gic_set_irq_priority(int irq, u8 prio)
+{
+	gic_masked_irq_bits(irq, GICD_IPRIORITYR, 8, prio, ACCESS_RMW);
+}
+
+void gic_set_irq_target(int irq, int cpu)
+{
+	if (irq < 32)
+		return;
+
+	if (gic_version() == 2) {
+		gic_masked_irq_bits(irq, GICD_ITARGETSR, 8, 1U << cpu,
+				    ACCESS_RMW);
+
+		return;
+	}
+
+	writeq(cpus[cpu], gicv3_dist_base() + GICD_IROUTER + irq * 8);
+}
+
+void gic_set_irq_group(int irq, int group)
+{
+	gic_masked_irq_bits(irq, GICD_IGROUPR, 1, group, ACCESS_RMW);
+}
+
+int gic_get_irq_group(int irq)
+{
+	return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
