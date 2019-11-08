Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184E5FC6195
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:42:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAD94214DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAD94214DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E284ACA4;
	Fri,  8 Nov 2019 09:42:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xM2pjgw3rSZF; Fri,  8 Nov 2019 09:42:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CEE04AECC;
	Fri,  8 Nov 2019 09:42:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B09DA4AECA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:42:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7yOlFEHd-lP1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:42:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D7884ACEC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:42:52 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D80CD7A7;
 Fri,  8 Nov 2019 06:42:51 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAD8A3F719;
 Fri,  8 Nov 2019 06:42:50 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 01/17] arm: gic: Enable GIC MMIO tests for
 GICv3 as well
Date: Fri,  8 Nov 2019 14:42:24 +0000
Message-Id: <20191108144240.204202-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
machines tend to have a GICv3-only GIC, so can't run those tests.
It turns out that most GIC distributor registers we test in the unit
tests are actually the same in GICv3, so we can just enable those tests
for GICv3 guests as well.
The only exception is the CPU number in the TYPER register, which is
only valid in the GICv2 compat mode (ARE=0), which KVM does not support.
So we protect this test against running on a GICv3 guest.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c            | 13 +++++++++++--
 arm/unittests.cfg    | 26 ++++++++++++++++++++++----
 lib/arm/asm/gic-v3.h |  2 ++
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index adb6aa4..04b3337 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -6,6 +6,7 @@
  *   + MMIO access tests
  * GICv3
  *   + test sending/receiving IPIs
+ *   + MMIO access tests
  *
  * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
@@ -496,7 +497,14 @@ static void gic_test_mmio(void)
 		idreg = gic_dist_base + GICD_ICPIDR2;
 		break;
 	case 0x3:
-		report_abort("GICv3 MMIO tests NYI");
+		/*
+		 * We only test generic registers or those affecting
+		 * SPIs, so don't need to consider the SGI base in
+		 * the redistributor here.
+		 */
+		gic_dist_base = gicv3_dist_base();
+		idreg = gic_dist_base + GICD_PIDR2;
+		break;
 	default:
 		report_abort("GIC version %d not supported", gic_version());
 	}
@@ -505,7 +513,8 @@ static void gic_test_mmio(void)
 	nr_irqs = GICD_TYPER_IRQS(reg);
 	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
 
-	test_typer_v2(reg);
+	if (gic_version() == 0x2)
+		test_typer_v2(reg);
 
 	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
 
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a0..12ac142 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -86,28 +86,46 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'ipi'
 groups = gic
 
-[gicv2-mmio]
+[gicv3-ipi]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'ipi'
+groups = gic
+
+[gicv2-max-mmio]
 file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
+[gicv3-max-mmio]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'mmio'
+groups = gic
+
 [gicv2-mmio-up]
 file = gic.flat
 smp = 1
 extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
+[gicv3-mmio-up]
+file = gic.flat
+smp = 1
+extra_params = -machine gic-version=3 -append 'mmio'
+groups = gic
+
 [gicv2-mmio-3p]
 file = gic.flat
 smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
 extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
-[gicv3-ipi]
+[gicv3-mmio-3p]
 file = gic.flat
-smp = $MAX_SMP
-extra_params = -machine gic-version=3 -append 'ipi'
+smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
+extra_params = -machine gic-version=2 -append 'mmio'
 groups = gic
 
 [gicv2-active]
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 347be2f..ed6a5ad 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -23,6 +23,8 @@
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_PIDR2			0xffe8
+
 /* Re-Distributor registers, offsets from RD_base */
 #define GICR_TYPER			0x0008
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
