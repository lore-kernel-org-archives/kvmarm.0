From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH 4/4] arm/arm64: GICv3: add TYPER test
Date: Thu, 17 Nov 2016 17:57:52 +0000
Message-ID: <20161117175752.16475-5-andre.przywara@arm.com>
References: <20161117175752.16475-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EA94404BA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:56:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SDrr-oyzuOEP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 12:56:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5300B404EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 12:56:50 -0500 (EST)
In-Reply-To: <20161117175752.16475-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add a simple test for the GICv3 TYPER test, which does only one basic
check to ensure we have actually enough interrupt IDs if we support
LPIs.
Allow a GICv3 guest to do the common MMIO checks as well, where the
register semantics are shared with a GICv2.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c         | 34 +++++++++++++++++++++++++++++++---
 arm/unittests.cfg |  6 ++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 02b1be1..7de0e47 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -327,6 +327,30 @@ static bool test_typer_v2(uint32_t reg)
 	return true;
 }
 
+static bool test_typer_v3(uint32_t reg)
+{
+	int nr_intids;
+
+	report("GIC emulation %ssupport%s MBIs", 1,
+	       reg & BIT(16) ? "" : "does not ",
+	       reg & BIT(16) ? "s" : "");
+	report("GIC emulation %ssupport%s LPIs", 1,
+	       reg & BIT(17) ? "" : "does not ",
+	       reg & BIT(17) ? "s" : "");
+	report("GIC emulation %ssupport%s Aff3", 1,
+	       reg & BIT(24) ? "" : "does not ",
+	       reg & BIT(24) ? "s" : "");
+
+	nr_intids = BIT(((reg >> 19) & 0x1f) + 1);
+	report("%d interrupt IDs implemented", 1, nr_intids);
+
+	if (reg & BIT(17))
+		report("%d LPIs supported", nr_intids > 8192,
+		       nr_intids > 8192 ? nr_intids - 8192 : 0);
+
+	return true;
+}
+
 #define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
 #define REPLACE_BYTE(reg32, byte, new) (((reg32) & ~(0xff << ((byte) * 8))) |\
 					((new) << ((byte) * 8)))
@@ -460,8 +484,9 @@ static int gic_test_mmio(int gic_version)
 		idreg = gic_dist_base + 0xfe8;
 		break;
 	case 0x3:
-		report_abort("GICv3 MMIO tests NYI");
-		return -1;
+		gic_dist_base = gicv3_dist_base();
+		idreg = gic_dist_base + 0xffe8;
+		break;
 	default:
 		report_abort("GIC version %d not supported", gic_version);
 		return 0;
@@ -471,7 +496,10 @@ static int gic_test_mmio(int gic_version)
 	nr_irqs = 32 * ((reg & 0x1f) + 1);
 	report("number of implemented SPIs: %d", 1, nr_irqs - 32);
 
-	test_typer_v2(reg);
+	if (gic_version == 2)
+		test_typer_v2(reg);
+	else
+		test_typer_v3(reg);
 
 	report("IIDR: 0x%x", 1, readl(gic_dist_base + GICD_IIDR));
 
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 0162e5a..b432346 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -78,3 +78,9 @@ file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'ipi'
 groups = gic
+
+[gicv3-mmio]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'mmio'
+groups = gic
-- 
2.9.0
