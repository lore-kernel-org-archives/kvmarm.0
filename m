From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 8/8] arm: use new irqchip parameter to create different vGIC types
Date: Fri,  5 Jun 2015 09:37:53 +0100
Message-ID: <1433493473-4002-9-git-send-email-andre.przywara@arm.com>
References: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com, penberg@kernel.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we unconditionally create a virtual GICv2 in the guest.
Add a --irqchip= parameter to let the user specify a different GIC
type for the guest.
For now we the only other supported type is GICv3.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch64/arm-cpu.c                    |  2 +-
 arm/gic.c                                | 21 +++++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h |  9 ++++++++-
 arm/kvm-cpu.c                            |  6 ++++++
 arm/kvm.c                                |  4 +++-
 5 files changed, 39 insertions(+), 3 deletions(-)

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
index c50d662..ab0f594 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -21,6 +21,23 @@
 static int gic_fd = -1;
 static int nr_redists;
 
+int irqchip_parser(const struct option *opt, const char *arg, int unset)
+{
+	enum irqchip_type *type = opt->value;
+
+	*type = IRQCHIP_DEFAULT;
+	if (!strcmp(arg, "gicv2")) {
+		*type = IRQCHIP_GICV2;
+	} else if (!strcmp(arg, "gicv3")) {
+		*type = IRQCHIP_GICV3;
+	} else if (strcmp(arg, "default")) {
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
@@ -121,6 +138,10 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV2:
 		max_cpus = GIC_MAX_CPUS;
 		break;
+	case IRQCHIP_GICV3:
+		nr_redists = kvm->cfg.nrcpus;
+		max_cpus = 255;
+		break;
 	default:
 		return -ENODEV;
 	}
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index a8ebd94..ae4e89b 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -8,8 +8,11 @@ struct kvm_config_arch {
 	unsigned int	force_cntfrq;
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
+	int		irqchip;
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
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index a3344fa..aacc172 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -144,6 +144,12 @@ bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
 {
 	int nr_redists = 0;
 
+	switch (vcpu->kvm->cfg.arch.irqchip) {
+	case IRQCHIP_GICV3:
+		nr_redists = vcpu->kvm->nrcpus;
+		break;
+	}
+
 	if (arm_addr_in_virtio_mmio_region(nr_redists, phys_addr)) {
 		return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
 	} else if (arm_addr_in_ioport_region(phys_addr)) {
diff --git a/arm/kvm.c b/arm/kvm.c
index f9685c2..2628d31 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -82,6 +82,8 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 		MADV_MERGEABLE | MADV_HUGEPAGE);
 
 	/* Create the virtual GIC. */
-	if (gic__create(kvm, IRQCHIP_GICV2))
+	if (kvm->cfg.arch.irqchip == IRQCHIP_DEFAULT)
+		kvm->cfg.arch.irqchip = IRQCHIP_GICV2;
+	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
 }
-- 
2.3.5

