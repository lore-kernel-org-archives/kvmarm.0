From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 15/16] arm64: enable GICv3-ITS emulation
Date: Fri,  4 Nov 2016 17:32:02 +0000
Message-ID: <20161104173203.21168-16-andre.przywara@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161104173203.21168-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Vladimir Murzin <vladimir.murzin@arm.com>
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
index c422e36..cd4f518 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -43,6 +43,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
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

