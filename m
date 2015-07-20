From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 11/14] arm64: enable GICv3-ITS emulation
Date: Mon, 20 Jul 2015 14:02:13 +0100
Message-ID: <1437397336-21385-12-git-send-email-andre.przywara@arm.com>
References: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>
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
index d1cffa5..187fe46 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -35,6 +35,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 		*type = IRQCHIP_GICV2;
 	} else if (!strcmp(arg, "gicv3")) {
 		*type = IRQCHIP_GICV3;
+	} else if (!strcmp(arg, "gicv3-its")) {
+		*type = IRQCHIP_GICV3_ITS;
 	} else {
 		pr_err("irqchip: unknown type \"%s\"\n", arg);
 		return -1;
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index f9c5942..6951ba6 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -26,7 +26,7 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
 		    "Force virtio devices to use PCI as their default "		\
 		    "transport"),						\
         OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
-		     "[gicv2|gicv3]",					\
+		     "[gicv2|gicv3|gicv3-its]",					\
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),
 
-- 
2.3.5

