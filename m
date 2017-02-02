From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 15/15] arm64: enable GICv3-ITS emulation
Date: Thu,  2 Feb 2017 16:32:23 +0000
Message-ID: <20170202163223.15372-16-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0289040A7C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:31:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zmYvbLQIwC2E for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 11:31:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F20340BCC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:31:09 -0500 (EST)
In-Reply-To: <20170202163223.15372-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With everything in place for the ITS emulation add a new option to the
--irqchip parameter to allow the user to specify --irqchip=gicv3-its
to enable the ITS emulation.
This will trigger creating the FDT node and an ITS register frame to
tell the kernel we want ITS emulation in the guest.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                                | 2 ++
 arm/include/arm-common/kvm-config-arch.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arm/gic.c b/arm/gic.c
index 5e5a227..54fd8fc 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -26,6 +26,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 		*type = IRQCHIP_GICV2;
 	} else if (!strcmp(arg, "gicv3")) {
 		*type = IRQCHIP_GICV3;
+	} else if (!strcmp(arg, "gicv3-its")) {
+		*type = IRQCHIP_GICV3_ITS;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index ed626b5..b48e720 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -27,7 +27,7 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
 		    "Force virtio devices to use PCI as their default "		\
 		    "transport"),						\
         OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
-		     "[gicv2|gicv3]",					\
+		     "[gicv2|gicv3|gicv3-its]",					\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),
 
-- 
2.9.0
