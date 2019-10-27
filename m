Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2EECA9EBD
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:44:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15D8F222C2
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIJk+TyT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15D8F222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2DC04A800;
	Sun, 27 Oct 2019 10:44:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vo7Eq5bQ+4-c; Sun, 27 Oct 2019 10:44:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAF554A529;
	Sun, 27 Oct 2019 10:44:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A02D64AC6C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:44:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MbLi11L9H2Kr for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:44:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 832594A54B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:44:12 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EC6F121850;
 Sun, 27 Oct 2019 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187451;
 bh=Tw+W2dqiEbHAk2Y8nXQgYWeBFeF2/xf9eLQe/xxbgNE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SIJk+TyTWMmfCn8DLezIx4XZLWgWCmYF28sUs2wBI5vcPqc0lBGP3MPiZMyyL7oQM
 k+KU+cqLtQEkWrwaNwVqscKBn0SURaVEozOB2Xwv+OZT5knafyioD70cuffBneL7DE
 SqhNZfcLhRc3tYwS5NdxVuQZe43wviuvS94i/6rc=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/36] irqchip/gic-v3: Workaround Cavium TX1 erratum when
 reading GICD_TYPER2
Date: Sun, 27 Oct 2019 14:42:08 +0000
Message-Id: <20191027144234.8395-11-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027144234.8395-1-maz@kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Jayachandran C <jnair@marvell.com>, Thomas Gleixner <tglx@linutronix.de>
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

Despite the architecture spec being extremely clear about the fact
that reserved registers in the GIC distributor memory map are RES0
(and thus are not allowed to generate an exception), the Cavium
ThunderX (aka TX1) SoC explodes as such:

[    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
[    0.000000] GICv3: 128 SPIs implemented
[    0.000000] GICv3: 0 Extended SPIs implemented
[    0.000000] Internal error: synchronous external abort: 96000210 [#1] SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-rc4-00035-g3cf6a3d5725f #7956
[    0.000000] Hardware name: cavium,thunder-88xx (DT)
[    0.000000] pstate: 60000085 (nZCv daIf -PAN -UAO)
[    0.000000] pc : __raw_readl+0x0/0x8
[    0.000000] lr : gic_init_bases+0x110/0x560
[    0.000000] sp : ffff800011243d90
[    0.000000] x29: ffff800011243d90 x28: 0000000000000000
[    0.000000] x27: 0000000000000018 x26: 0000000000000002
[    0.000000] x25: ffff8000116f0000 x24: ffff000fbe6a2c80
[    0.000000] x23: 0000000000000000 x22: ffff010fdc322b68
[    0.000000] x21: ffff800010a7a208 x20: 00000000009b0404
[    0.000000] x19: ffff80001124dad0 x18: 0000000000000010
[    0.000000] x17: 000000004d8d492b x16: 00000000f67eb9af
[    0.000000] x15: ffffffffffffffff x14: ffff800011249908
[    0.000000] x13: ffff800091243ae7 x12: ffff800011243af4
[    0.000000] x11: ffff80001126e000 x10: ffff800011243a70
[    0.000000] x9 : 00000000ffffffd0 x8 : ffff80001069c828
[    0.000000] x7 : 0000000000000059 x6 : ffff8000113fb4d1
[    0.000000] x5 : 0000000000000001 x4 : 0000000000000000
[    0.000000] x3 : 0000000000000000 x2 : 0000000000000000
[    0.000000] x1 : 0000000000000000 x0 : ffff8000116f000c
[    0.000000] Call trace:
[    0.000000]  __raw_readl+0x0/0x8
[    0.000000]  gic_of_init+0x188/0x224
[    0.000000]  of_irq_init+0x200/0x3cc
[    0.000000]  irqchip_init+0x1c/0x40
[    0.000000]  init_IRQ+0x160/0x1d0
[    0.000000]  start_kernel+0x2ec/0x4b8
[    0.000000] Code: a8c47bfd d65f03c0 d538d080 d65f03c0 (b9400000)

when reading the GICv4.1 GICD_TYPER2 register, which is unexpected...

Work around it by adding a new quirk flagging all the A1 revisions
of the distributor, but it remains unknown whether this could affect
other revisions of this SoC (or even other SoCs from the same silicon
vendor).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 50538709bd49..f0d33ac64a99 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -34,6 +34,7 @@
 #define GICD_INT_NMI_PRI	(GICD_INT_DEF_PRI & ~0x80)
 
 #define FLAGS_WORKAROUND_GICR_WAKER_MSM8996	(1ULL << 0)
+#define FLAGS_WORKAROUND_GICD_TYPER2_TX1	(1ULL << 1)
 
 struct redist_region {
 	void __iomem		*redist_base;
@@ -1455,6 +1456,15 @@ static bool gic_enable_quirk_msm8996(void *data)
 	return true;
 }
 
+static bool gic_enable_quirk_tx1(void *data)
+{
+	struct gic_chip_data *d = data;
+
+	d->flags |= FLAGS_WORKAROUND_GICD_TYPER2_TX1;
+
+	return true;
+}
+
 static bool gic_enable_quirk_hip06_07(void *data)
 {
 	struct gic_chip_data *d = data;
@@ -1493,6 +1503,12 @@ static const struct gic_quirk gic_quirks[] = {
 		.mask	= 0xffffffff,
 		.init	= gic_enable_quirk_hip06_07,
 	},
+	{
+		.desc	= "GICv3: Cavium TX1 GICD_TYPER2 erratum",
+		.iidr	= 0xa100034c,
+		.mask	= 0xfff00fff,
+		.init	= gic_enable_quirk_tx1,
+	},
 	{
 	}
 };
@@ -1557,7 +1573,12 @@ static int __init gic_init_bases(void __iomem *dist_base,
 	pr_info("%d SPIs implemented\n", GIC_LINE_NR - 32);
 	pr_info("%d Extended SPIs implemented\n", GIC_ESPI_NR);
 
-	gic_data.rdists.gicd_typer2 = readl_relaxed(gic_data.dist_base + GICD_TYPER2);
+	/*
+	 * ThunderX1 explodes on reading GICD_TYPER2, in total violation
+	 * of the spec (which says that reserved addresses are RES0).
+	 */
+	if (!(gic_data.flags & FLAGS_WORKAROUND_GICD_TYPER2_TX1))
+		gic_data.rdists.gicd_typer2 = readl_relaxed(gic_data.dist_base + GICD_TYPER2);
 
 	gic_data.domain = irq_domain_create_tree(handle, &gic_irq_domain_ops,
 						 &gic_data);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
