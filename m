Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE17257845
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178499; cv=none; b=asO3GQoaWdKUBMSERhc3HyVqg5L6fQsYNZ5ISAJnrrzladEerNbJpufpjiICPGeO2EsR7R5ZDkq3uYMFUdsh2x5+pTo+B5D0Zx1M40qS1keG/oddl1SY/UAzlG96cnoACiak77Ywmk8Qp9Kc+HIWqf3wbkQvlgANbiJFeWpcEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178499; c=relaxed/simple;
	bh=z6HTjawywTD6vdbs1P8ofC7/cpoJNPkCov0zGxfMyXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inV8LvZR+uiSS0pYx1gzVhyWZkoa4bz6517G9PgeGm3AR3MNzepew4UMcUV4S6NJu9xmDKem4aO0tOwzvQecZuAQkyiaSuOIFs8UqIE9RffwFu9p2DtiuPPSsML5QcOV23Lp9635PiGjPuzJcj/JunawHi1gwl261gEqnsYeWmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F4E81515;
	Fri, 23 Jan 2026 06:28:10 -0800 (PST)
Received: from e134369.cambridge.arm.com (e134369.arm.com [10.1.34.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 104663F740;
	Fri, 23 Jan 2026 06:28:14 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH kvmtool v5 3/7] arm64: nested: Add support for setting maintenance IRQ
Date: Fri, 23 Jan 2026 14:27:25 +0000
Message-ID: <20260123142729.604737-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123142729.604737-1-andre.przywara@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Uses the new VGIC KVM device attribute to set the maintenance IRQ.
This is fixed to use PPI 9, as a platform decision made by kvmtool,
matching the SBSA recommendation.
Use the opportunity to pass the kvm pointer to gic__generate_fdt_nodes(),
as this simplifies the call and allows us access to the nested_virt
config variable on the way.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/arm-cpu.c         |  2 +-
 arm64/gic.c             | 29 +++++++++++++++++++++++++++--
 arm64/include/kvm/gic.h |  2 +-
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index 69bb2cb2..0843ac05 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -14,7 +14,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
 
-	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
+	gic__generate_fdt_nodes(fdt, kvm);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 	pmu__generate_fdt_nodes(fdt, kvm);
 }
diff --git a/arm64/gic.c b/arm64/gic.c
index b0d3a1ab..2a595184 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -11,6 +11,8 @@
 
 #define IRQCHIP_GIC 0
 
+#define GIC_MAINT_IRQ	9
+
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
@@ -302,10 +304,15 @@ static int gic__init_gic(struct kvm *kvm)
 
 	int lines = irq__get_nr_allocated_lines();
 	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
+	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
 	struct kvm_device_attr nr_irqs_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 		.addr	= (u64)(unsigned long)&nr_irqs,
 	};
+	struct kvm_device_attr maint_irq_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ,
+		.addr	= (u64)(unsigned long)&maint_irq,
+	};
 	struct kvm_device_attr vgic_init_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
 		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
@@ -325,6 +332,16 @@ static int gic__init_gic(struct kvm *kvm)
 			return ret;
 	}
 
+	if (kvm->cfg.arch.nested_virt) {
+		ret = ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &maint_irq_attr);
+		if (!ret)
+			ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &maint_irq_attr);
+		if (ret) {
+			pr_err("could not set maintenance IRQ\n");
+			return ret;
+		}
+	}
+
 	irq__routing_init(kvm);
 
 	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
@@ -342,7 +359,7 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
 
-void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
+void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char *compatible, *msi_compatible = NULL;
 	u64 msi_prop[2];
@@ -350,8 +367,12 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
 		0, 0,				/* to be filled */
 	};
+	u32 maint_irq[] = {
+		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI), cpu_to_fdt32(GIC_MAINT_IRQ),
+		gic__get_fdt_irq_cpumask(kvm) | IRQ_TYPE_LEVEL_HIGH
+	};
 
-	switch (type) {
+	switch (kvm->cfg.arch.irqchip) {
 	case IRQCHIP_GICV2M:
 		msi_compatible = "arm,gic-v2m-frame";
 		/* fall-through */
@@ -377,6 +398,10 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
 	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
+	if (kvm->cfg.arch.nested_virt) {
+		_FDT(fdt_property(fdt, "interrupts", maint_irq,
+				  sizeof(maint_irq)));
+	}
 	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
 	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index ad8bcbf2..8490cca6 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -36,7 +36,7 @@ struct kvm;
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
-void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type);
+void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 u32 gic__get_fdt_irq_cpumask(struct kvm *kvm);
 
 int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
-- 
2.43.0

