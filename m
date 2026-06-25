Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DD9361650;
	Thu, 25 Jun 2026 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782407465; cv=none; b=OLKwMGpsLQurnwWDi6nldZb0zCyOGf/oE0KuTqFCP2gp6uUxWpEdMjPgHS4eTOunXHAnbg+ZRX26I5nHWW2SmXSAPzIghV7PCylKsg9ZMJsl5SNcOywNezneC90oMURQjVRl2vzpN39zqWNd4WtKhDI6No+X5dL/bMGP0QmBWnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782407465; c=relaxed/simple;
	bh=vS5WUcE+HNJk8xIWquHv1ABVUTZBGJpFWaUurFk6op8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuTbkl3JtrmsuBQmJM1G72xVh9rMH7N+fe/Br8yMbz0J3fCFfmCmE/IIIPdkbUvA4xrdvgJ/bp0KT/6cU9Qs5OFrSa9mWSZ2Fn/9QbbAyhWINYJYLhQf7gK/kaukLn4eH29v97v+wtb9fQVyR4afUJV80zMsnGdvzjfN1VVGf4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnmwXhIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnmwXhIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6381F00A3A;
	Thu, 25 Jun 2026 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782407464;
	bh=UiojHg/Xe39SNWNqXE/NkwltevEEWb5yupUBRz4QOw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnmwXhIzOkB22TiO3F/6fICpPOFwuVkuSPmauX2azZ3Mo8bMZ4vUKXc8BIHNXAU3i
	 UT9w84hP6a7XgIm62clqjZIbmTq/OhRut6QzmjyVmoE26c3nx5Ea8Kq/6fo6SCdB89
	 ze8chDUPq3VWc3+4nQtQnTjD6No4TifXmnMchWmn2k5ahmH5fQYP3eKXSXii4ZK9qQ
	 L9D+lv/8JPyugzrtVF/XqdcBYIpM7lN7qtQ960iNOnpt6b4P/7EmAJZ/CbNUc+//iL
	 zx9vltNCKyMN1WLYj/PopBcaEs35FJOJcOE2KdsUriCHugW7g9qUBfbBzfudATGVMt
	 jjTeSKdyuOM6A==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH v2 kvmtool 4/4] arm64: Add support for protected VMs
Date: Thu, 25 Jun 2026 18:10:45 +0100
Message-ID: <20260625171046.4482-5-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625171046.4482-1-will@kernel.org>
References: <20260625171046.4482-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new '--protected' parameter which requests the creation of
a protected VM type from the kernel. In addition, a reserved DMA region
is advertised in the device-tree and VIRTIO_F_ACCESS_PLATFORM is
advertised so that virtio transfers can be bounced through a shared
memory window.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arm64/fdt.c                         | 37 +++++++++++++++++++++++++++--
 arm64/include/kvm/fdt-arch.h        | 10 +++++++-
 arm64/include/kvm/kvm-arch.h        |  2 ++
 arm64/include/kvm/kvm-config-arch.h |  5 +++-
 arm64/kvm.c                         | 28 ++++++++++++++++++++--
 arm64/pci.c                         |  2 ++
 6 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/arm64/fdt.c b/arm64/fdt.c
index 98f1dd9..3cbd36e 100644
--- a/arm64/fdt.c
+++ b/arm64/fdt.c
@@ -71,6 +71,19 @@ static void generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
 }
 
+static bool emit_dma_regions;
+void generate_dma_region_prop(void *fdt)
+{
+	if (emit_dma_regions)
+		_FDT(fdt_property_cell(fdt, "memory-region", PHANDLE_DMA));
+}
+
+static void generate_aux_props(void *fdt, u8 irq, enum irq_type irq_type)
+{
+	generate_irq_prop(fdt, irq, irq_type);
+	generate_dma_region_prop(fdt);
+}
+
 struct psci_fns {
 	u32 cpu_suspend;
 	u32 cpu_off;
@@ -103,7 +116,7 @@ static int setup_fdt(struct kvm *kvm)
 {
 	struct device_header *dev_hdr;
 	u8 staging_fdt[FDT_MAX_SIZE];
-	u64 mem_reg_prop[]	= {
+	u64 resv_mem_prop, mem_reg_prop[] = {
 		cpu_to_fdt64(kvm->arch.memory_guest_start),
 		cpu_to_fdt64(kvm->ram_size),
 	};
@@ -116,6 +129,9 @@ static int setup_fdt(struct kvm *kvm)
 	void (*generate_cpu_peripheral_fdt_nodes)(void *, struct kvm *)
 					= kvm->cpus[0]->generate_fdt_nodes;
 
+	/* Generate DMA regions for bouncing in protected VMs */
+	emit_dma_regions = kvm->cfg.arch.protected;
+
 	/* Create new tree without a reserve map */
 	_FDT(fdt_create(fdt, FDT_MAX_SIZE));
 	_FDT(fdt_finish_reservemap(fdt));
@@ -162,6 +178,23 @@ static int setup_fdt(struct kvm *kvm)
 	_FDT(fdt_property(fdt, "reg", mem_reg_prop, sizeof(mem_reg_prop)));
 	_FDT(fdt_end_node(fdt));
 
+	/* Reserved memory (restricted DMA pool) */
+	if (emit_dma_regions) {
+		_FDT(fdt_begin_node(fdt, "reserved-memory"));
+		_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
+		_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+		_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+		_FDT(fdt_begin_node(fdt, "restricted_dma_reserved"));
+		_FDT(fdt_property_string(fdt, "compatible", "restricted-dma-pool"));
+		resv_mem_prop = cpu_to_fdt64(DMA_MEM_REGION_SIZE);
+		_FDT(fdt_property(fdt, "size", &resv_mem_prop, sizeof(resv_mem_prop)));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_DMA));
+		_FDT(fdt_end_node(fdt));
+
+		_FDT(fdt_end_node(fdt));
+	}
+
 	/* CPU and peripherals (interrupt controller, timers, etc) */
 	generate_cpu_nodes(fdt, kvm);
 	if (generate_cpu_peripheral_fdt_nodes)
@@ -172,7 +205,7 @@ static int setup_fdt(struct kvm *kvm)
 	while (dev_hdr) {
 		generate_mmio_fdt_nodes = dev_hdr->data;
 		if (generate_mmio_fdt_nodes) {
-			generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
+			generate_mmio_fdt_nodes(fdt, dev_hdr, generate_aux_props);
 		} else {
 			pr_debug("Missing FDT node generator for MMIO device %d",
 				 dev_hdr->dev_num);
diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
index 60c2d40..8a0a460 100644
--- a/arm64/include/kvm/fdt-arch.h
+++ b/arm64/include/kvm/fdt-arch.h
@@ -1,6 +1,14 @@
 #ifndef ARM__FDT_H
 #define ARM__FDT_H
 
-enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_MAX};
+enum phandles {
+	PHANDLE_RESERVED = 0,
+	PHANDLE_GIC,
+	PHANDLE_MSI,
+	PHANDLE_DMA,
+	PHANDLES_MAX
+};
+
+void generate_dma_region_prop(void *fdt);
 
 #endif /* ARM__FDT_H */
diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index a50e6a4..e7dd526 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -87,6 +87,8 @@
 
 #define MAX_PAGE_SIZE	SZ_64K
 
+/* Size of DMA region for bouncing when running a protected guest */
+#define DMA_MEM_REGION_SIZE	SZ_32M
 
 static inline bool arm_addr_in_ioport_region(u64 phys_addr)
 {
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index d321b77..c2702d5 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -19,6 +19,7 @@ struct kvm_config_arch {
 	unsigned int	sve_max_vq;
 	bool		no_pvtime;
 	bool		psci;
+	bool		protected;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
@@ -70,6 +71,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
 		    "Start VCPUs in EL2 (for nested virt)"),			\
 	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
-		    "Create guest without VHE support"),
+		    "Create guest without VHE support"),			\
+	OPT_BOOLEAN('\0', "protected", &(cfg)->protected,			\
+			"Create a protected VM when pKVM is enabled"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm.c b/arm64/kvm.c
index c8570ce..fb0b98d 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -6,6 +6,7 @@
 #include "kvm/fdt.h"
 #include "kvm/gic.h"
 #include "kvm/kvm-cpu.h"
+#include "kvm/virtio.h"
 
 #include "asm/smccc.h"
 
@@ -147,6 +148,9 @@ void kvm__arch_init(struct kvm *kvm)
 	kvm__arch_enable_mte(kvm);
 	kvm__setup_smccc(kvm);
 	kvm__arch_set_counter_offset(kvm);
+
+	if (kvm->cfg.arch.protected)
+		virtio_modern_enable_feat_access_platform();
 }
 
 
@@ -463,6 +467,22 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
 
 	if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
 		pr_warning("--e2h0 requires --nested, ignoring");
+
+	if (kvm->cfg.arch.protected) {
+		if (kvm->cfg.ram_size &&
+		    kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
+			die("RAM size (0x%llx) smaller than DMA bounce region (0x%x)",
+			    kvm->cfg.ram_size, DMA_MEM_REGION_SIZE);
+		}
+
+		if (kvm->cfg.virtio_transport == VIRTIO_MMIO_LEGACY ||
+		    kvm->cfg.virtio_transport == VIRTIO_PCI_LEGACY) {
+			die("Protected VMs require a modern virtio transport");
+		}
+
+		if (kvm->cfg.balloon)
+			die("Ballooning not supported with protected VMs");
+	}
 }
 
 u64 kvm__arch_default_ram_address(void)
@@ -485,11 +505,15 @@ int kvm__get_vm_type(struct kvm *kvm)
 {
 	unsigned int ipa_bits, max_ipa_bits;
 	unsigned long max_ipa;
+	int type = 0;
+
+	if (kvm->cfg.arch.protected)
+		type |= KVM_VM_TYPE_ARM_PROTECTED;
 
 	/* If we're running on an old kernel, use 0 as the VM type */
 	max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
 	if (!max_ipa_bits)
-		return 0;
+		return type;
 
 	/* Otherwise, compute the minimal required IPA size */
 	max_ipa = kvm->cfg.ram_addr + kvm->cfg.ram_size - 1;
@@ -500,7 +524,7 @@ int kvm__get_vm_type(struct kvm *kvm)
 	if (ipa_bits > max_ipa_bits)
 		die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
 
-	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
+	return type | KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
 }
 
 static int kvm__arch_free_kernel_header(struct kvm *kvm)
diff --git a/arm64/pci.c b/arm64/pci.c
index 0366783..db87db8 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -73,6 +73,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
 		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
 
+	generate_dma_region_prop(fdt);
+
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
 	while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
-- 
2.55.0.rc0.799.gd6f94ed593-goog

