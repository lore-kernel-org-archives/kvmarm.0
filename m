From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 10/10] arm: use new irqchip parameter to create different
 vGIC types
Date: Fri,  3 Jul 2015 12:26:38 +0100
Message-ID: <1435922798-14375-11-git-send-email-andre.przywara@arm.com>
References: <1435922798-14375-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EA0F5794B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 07:15:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v5uwxT+ReEgh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 07:15:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F5765793D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 07:15:41 -0400 (EDT)
In-Reply-To: <1435922798-14375-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we unconditionally create a virtual GICv2 in the guest.
Add a --irqchip= parameter to let the user specify a different GIC
type for the guest, when omitting this parameter it still defaults to
--irqchip=gicv2.
For now the only other supported type is --irqchip=gicv3

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch64/arm-cpu.c                    |  2 +-
 arm/gic.c                                | 16 ++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h |  9 ++++++++-
 arm/kvm.c                                |  2 +-
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index f702b9e..3dc8ea3 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -12,7 +12,7 @@
 static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
-	gic__generate_fdt_nodes(fdt, gic_phandle, IRQCHIP_GICV2);
+	gic__generate_fdt_nodes(fdt, gic_phandle, kvm->cfg.arch.irqchip);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 }
 
diff --git a/arm/gic.c b/arm/gic.c
index efe4b42..1b63074 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -22,6 +22,22 @@ static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
 
+int irqchip_parser(const struct option *opt, const char *arg, int unset)
+{
+	enum irqchip_type *type = opt->value;
+
+	if (!strcmp(arg, "gicv2")) {
+		*type = IRQCHIP_GICV2;
+	} else if (!strcmp(arg, "gicv3")) {
+		*type = IRQCHIP_GICV3;
+	} else {
+		fprintf(stderr, "irqchip: unknown type \"%s\"\n", arg);
+		return -1;
+	}
+
+	return 0;
+}
+
 static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index a8ebd94..9529881 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -8,8 +8,11 @@ struct kvm_config_arch {
 	unsigned int	force_cntfrq;
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
+	enum irqchip_type irqchip;
 };
 
+int irqchip_parser(const struct option *opt, const char *arg, int unset);
+
 #define OPT_ARCH_RUN(pfx, cfg)							\
 	pfx,									\
 	ARM_OPT_ARCH_RUN(cfg)							\
@@ -21,6 +24,10 @@ struct kvm_config_arch {
 		     "updated to program CNTFRQ correctly*"),			\
 	OPT_BOOLEAN('\0', "force-pci", &(cfg)->virtio_trans_pci,		\
 		    "Force virtio devices to use PCI as their default "		\
-		    "transport"),
+		    "transport"),						\
+        OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
+		     "[gicv2|gicv3]",					\
+		     "type of interrupt controller to emulate in the guest",	\
+		     irqchip_parser, NULL),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index f9685c2..d0e4a20 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -82,6 +82,6 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 		MADV_MERGEABLE | MADV_HUGEPAGE);
 
 	/* Create the virtual GIC. */
-	if (gic__create(kvm, IRQCHIP_GICV2))
+	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
 }
-- 
2.3.5
