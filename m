Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12DE32D44E
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 14:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178504; cv=none; b=Amlz6LDUv1HIUFcmvd6oWp4QdrcF3SOgh9bBOgzv+VQReUQky5L64RZaRXz26i+HdTGusDy/TD2Zr+RuagLnQmx/ddm4qAzp0vZdhblnIRS8Y7S0OjO+P1K2Q6LpfLnbcDod1JWMuEcaVfb0pb3xF4JJezRIxmdtRS0dOommQxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178504; c=relaxed/simple;
	bh=bb+XBpULIKxHk5zQmPBWU98wAJkz6KkhOxQEMs7acXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkImt9UUINQNZUEkvLzd2rOGh8DGMno9Uu9WjygbrXe7Dbi94fLAZhRMQlywnvGlB1SOeFuXA+Uay4QvvjjOfqN4rpnwalgFcnFh71FKAp9WJPT0kP0pnn0M47nXPpBLWsd6/RRF30rY1WQxO73jLThaW6+xOwk88hOFg13tNN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB3B71515;
	Fri, 23 Jan 2026 06:28:15 -0800 (PST)
Received: from e134369.cambridge.arm.com (e134369.arm.com [10.1.34.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E67DE3F740;
	Fri, 23 Jan 2026 06:28:20 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH kvmtool v5 6/7] arm64: Generate HYP timer interrupt specifiers
Date: Fri, 23 Jan 2026 14:27:28 +0000
Message-ID: <20260123142729.604737-7-andre.przywara@arm.com>
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

From: Marc Zyngier <maz@kernel.org>

FEAT_VHE introduced a non-secure EL2 virtual timer, along with its
interrupt line. Consequently the arch timer DT binding introduced a fifth
interrupt to communicate this interrupt number.

Refactor the interrupts property generation code to deal with a variable
number of interrupts, and forward five interrupts instead of four in case
nested virt is enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/arm-cpu.c           |  4 +---
 arm64/include/kvm/timer.h |  2 +-
 arm64/timer.c             | 29 ++++++++++++-----------------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index 0843ac05..5b5484d8 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -12,10 +12,8 @@
 
 static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
-	int timer_interrupts[4] = {13, 14, 11, 10};
-
 	gic__generate_fdt_nodes(fdt, kvm);
-	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
+	timer__generate_fdt_nodes(fdt, kvm);
 	pmu__generate_fdt_nodes(fdt, kvm);
 }
 
diff --git a/arm64/include/kvm/timer.h b/arm64/include/kvm/timer.h
index 928e9ea7..81e093e4 100644
--- a/arm64/include/kvm/timer.h
+++ b/arm64/include/kvm/timer.h
@@ -1,6 +1,6 @@
 #ifndef ARM_COMMON__TIMER_H
 #define ARM_COMMON__TIMER_H
 
-void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs);
+void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 
 #endif /* ARM_COMMON__TIMER_H */
diff --git a/arm64/timer.c b/arm64/timer.c
index 861f2d99..2ac6144f 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -5,31 +5,26 @@
 #include "kvm/timer.h"
 #include "kvm/util.h"
 
-void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm, int *irqs)
+void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-timer\0arm,armv7-timer";
 	u32 cpu_mask = gic__get_fdt_irq_cpumask(kvm);
-	u32 irq_prop[] = {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[0]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
+	int irqs[5] = {13, 14, 11, 10, 12};
+	int nr = ARRAY_SIZE(irqs);
+	u32 irq_prop[nr * 3];
 
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[1]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
+	if (!kvm->cfg.arch.nested_virt)
+		nr--;
 
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[2]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
-
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irqs[3]),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW),
-	};
+	for (int i = 0; i < nr; i++) {
+		irq_prop[i * 3 + 0] = cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
+		irq_prop[i * 3 + 1] = cpu_to_fdt32(irqs[i]);
+		irq_prop[i * 3 + 2] = cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
+	}
 
 	_FDT(fdt_begin_node(fdt, "timer"));
 	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
-	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, nr * 3 * sizeof(irq_prop[0])));
 	_FDT(fdt_property(fdt, "always-on", NULL, 0));
 	if (kvm->cfg.arch.force_cntfrq > 0)
 		_FDT(fdt_property_cell(fdt, "clock-frequency", kvm->cfg.arch.force_cntfrq));
-- 
2.43.0

