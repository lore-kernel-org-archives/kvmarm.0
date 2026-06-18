Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01B52F8EA3
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797844; cv=none; b=SoMQ5CsR0Bu5RzfQbo0jZEaEDlatzE04kasjiFPXr8gr1qCD0G/jHtY7vWZj8I8UbN06cYlgaLYd9oWYx+trOz6+eQIEDe0eIKeYimMa4QMPI+OYi4zHYKqSi3OkR3u64+SdJzvwzYlh0fTWLeTPG2aEKvR15+p4GuFIx5tfCa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797844; c=relaxed/simple;
	bh=BZrnvb+e+D1AKBEDPNGOe+Da6qi61H0n0AapNH7rhm4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbwxxyiJOmCBwGrK7djdriGHoBPmQgj2d3HtHUlcgtxML7S3grNcnmt7lrGATLbqzaLnnAAZ+v//XCGSA0Orq+cGyXVg62Q52yONa02VqcTDcpcD+xZPFGVfnKopLy5iUOgBLttYfVpzzJQTkDXfaggAYd/YiSpOEjOvQ5WLa8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k4EQQ6A8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k4EQQ6A8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54DF248FF;
	Thu, 18 Jun 2026 08:50:37 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A2B13F62B;
	Thu, 18 Jun 2026 08:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781797842; bh=BZrnvb+e+D1AKBEDPNGOe+Da6qi61H0n0AapNH7rhm4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=k4EQQ6A8WE/LEhNIkEyZFR/xPgQZ3aoFj51a7RAKI0846zddLKpsoIROxDqaT2n9n
	 osDGxaerAFsQ1tv4x4jkGAj3SCFCidKYl5GJiisPUWLlcEvMphqLVUhHcsxB1tq3KC
	 F54tOlauieebzc0Sd3qBvSOgd8w8JZH/6sOTfY4o=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oupton@kernel.org,
	jean-philippe.brucker@arm.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool v2 4/7] arm64: Initialise the PMU after the GIC
Date: Thu, 18 Jun 2026 16:49:58 +0100
Message-ID: <20260618155001.226266-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618155001.226266-1-alexandru.elisei@arm.com>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PMU initialisation is done in:

setup_fdt()
  vcpu->generate_fdt_nodes()
    pmu__generate_fdt_nodes()

The PMU ioctl KVM_ARM_VCPU_PMU_V3_INIT requires that the GIC has been
initialised, which is done in gic__init_gic().

gic__init_gic() and setup_fdt() are part of the same initialisation list.
The relative order on the list depends on the order of compilation: gic.c
is compiled after fdt.c and this places gic__init_gic() first on the
initialisation list.

If the compilation order changes and gic.c is compiled *before* fdt.c,
gic__init_gic() will be executed *after* setup_fdt() and PMU initialisation
will fail with an error message:

PMU KVM_SET_DEVICE_ATTR: No such device

This is fragile and hard to debug. Improve the situation by having
gic__init_gic() explicitely initialize the PMU.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/gic.c             |  9 ++++++++-
 arm64/include/asm/pmu.h |  3 +++
 arm64/pmu.c             | 28 ++++++++++++++++++----------
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index b0be9e5766df..1e4009625595 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -9,6 +9,8 @@
 #include <linux/kvm.h>
 #include <linux/sizes.h>
 
+#include <asm/pmu.h>
+
 #define IRQCHIP_GIC 0
 
 #define GIC_MAINT_IRQ	9
@@ -355,7 +357,12 @@ static int gic__init_gic(struct kvm *kvm)
 
 	vgic_is_init = true;
 
-	return irq__setup_irqfd_lines(kvm);
+	ret = irq__setup_irqfd_lines(kvm);
+	if (ret)
+		return ret;
+
+	/* The PMU requires that the GIC has been initialized. */
+	return pmu__init(kvm);
 }
 late_init(gic__init_gic)
 
diff --git a/arm64/include/asm/pmu.h b/arm64/include/asm/pmu.h
index 38e3154b11b7..74566943f355 100644
--- a/arm64/include/asm/pmu.h
+++ b/arm64/include/asm/pmu.h
@@ -3,6 +3,9 @@
 
 #define KVM_ARM_PMUv3_PPI			23
 
+struct kvm;
+
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm);
+int pmu__init(struct kvm *kvm);
 
 #endif /* __ARM_PMU_H__ */
diff --git a/arm64/pmu.c b/arm64/pmu.c
index 5f31d6b6f346..92cacd62479e 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -193,21 +193,32 @@ static int find_pmu(struct kvm *kvm)
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-pmuv3";
-	int irq = KVM_ARM_PMUv3_PPI;
-	struct kvm_cpu *vcpu;
-	int pmu_id = -ENXIO;
-	int i;
-
 	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
 	u32 irq_prop[] = {
 		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irq - 16),
+		cpu_to_fdt32(KVM_ARM_PMUv3_PPI - 16),
 		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
 	};
 
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
 
+	_FDT(fdt_begin_node(fdt, "pmu"));
+	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+	_FDT(fdt_end_node(fdt));
+}
+
+int pmu__init(struct kvm *kvm)
+{
+	int irq = KVM_ARM_PMUv3_PPI;
+	struct kvm_cpu *vcpu;
+	int pmu_id = -ENXIO;
+	int i;
+
+	if (!kvm->cfg.arch.has_pmuv3)
+		return 0;
+
 	if (pmu_has_attr(kvm->cpus[0], KVM_ARM_VCPU_PMU_V3_SET_PMU)) {
 		pmu_id = find_pmu(kvm);
 		if (pmu_id < 0) {
@@ -228,8 +239,5 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		set_pmu_attr(vcpu, NULL, KVM_ARM_VCPU_PMU_V3_INIT);
 	}
 
-	_FDT(fdt_begin_node(fdt, "pmu"));
-	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
-	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
-	_FDT(fdt_end_node(fdt));
+	return 0;
 }
-- 
2.54.0

