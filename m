Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63987C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 18DD8610FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 18DD8610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE634B208;
	Mon, 13 Sep 2021 16:50:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GnBLzwlET10O; Mon, 13 Sep 2021 16:50:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88BDA4B1F3;
	Mon, 13 Sep 2021 16:50:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3829D4B1C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:50:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fy+0rBmbXBAa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 16:50:08 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB0AE4B1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:50:08 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 w2-20020a3794020000b02903b54f40b442so42490779qkd.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=D/6PftlxTmApNoxNsVxp9BwFV4pwm0ZWJgzuk/z7BfM=;
 b=KNwlpdt1adID3z4KWOnSPO0Lh/1OXiZzBHODthTRlwWgWFjEGEx0o1lQEsFzgG7TDK
 yq1QWLoZmyTykqsmWMEGHPdXyM+bvnCWk/hcpvd/RxI0EZrOPgLQokBqLD/ngHSt9zkz
 MWsRKSZApFXPD1JPXlq/kddLVBFC9NpostjLr5bI72gXSH4dkLYGOIDXE5/9Ti5aVa4P
 KAIqIoLKWWIJe2+/Hr79BMq2dBT39hRAaoEPM7LsDCuvINCa1xM+cb4JzErWUPqD+/sK
 xreML77YlwlCPJ5F8W+AuW0vF07zr0qsHGDXl+LPTZstbyvE1qGApKx0y+kYkcT915gz
 l8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=D/6PftlxTmApNoxNsVxp9BwFV4pwm0ZWJgzuk/z7BfM=;
 b=8KAdc7KQU6rkYBb3PoIfRMCTz/i/AXKnmnwY9x9oPe75FLnTubv8qLh4WRyZaBok0O
 llvpsfSRPpsvBQJFBF0mmYy8m4roAReU7UM4L2+u1kaMxOABmVUSo9fnXuygedgXTe1+
 rC7u28FKZQGnYtHPREj/j2OkFnnUwlG8stb7CzsSgJtpnyMotnxXU3k6ePJTcc2AoR9F
 0xB7ftAAy+rn/yVrW+KVSB0lzfLxpddQ4dN3Olvg37E6D2ewuIzvDnRYKe2xGtT0zJYp
 K/TnAjvLV5ECBjeBreGxwW2OmH0tVTd3ylwRwcKzTruEgVifxaX4SDOVPCpuZ1VdWyw4
 VoXQ==
X-Gm-Message-State: AOAM531AwszZoS5E9PYeC2GhY06miwTcZakIKaiN9XChV/0s8ZvVmgL/
 1LVz0d/wRXf2VmdplQ44WyhvDA1AcHsY
X-Google-Smtp-Source: ABdhPJwLb2w8nw2BWYeQsT4/cLUstQBrlooaWLPbgL8q5ulqnQz17QulW0jDMZt61Nu7CN/l127qonBTdaKc
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:1271:: with SMTP id
 r17mr1569310qvv.48.1631566208334; Mon, 13 Sep 2021 13:50:08 -0700 (PDT)
Date: Mon, 13 Sep 2021 20:49:27 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-12-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 11/14] KVM: arm64: selftests: Add basic GICv3 support
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add basic support for ARM Generic Interrupt Controller v3.
The support provides guests to setup interrupts.

The work is inspired from kvm-unit-tests and the kernel's
GIC driver (drivers/irqchip/irq-gic-v3.c).

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/include/aarch64/gic.h       |  21 ++
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  95 +++++++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  21 ++
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 ++++++++++++++++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++++
 6 files changed, 448 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 61f0d376af99..5476a8ddef60 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -35,7 +35,7 @@ endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
new file mode 100644
index 000000000000..85dd1e53048e
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Interrupt Controller (GIC) specific defines
+ */
+
+#ifndef SELFTEST_KVM_GIC_H
+#define SELFTEST_KVM_GIC_H
+
+enum gic_type {
+	GIC_V3,
+	GIC_TYPE_MAX,
+};
+
+void gic_init(enum gic_type type, unsigned int nr_cpus,
+		void *dist_base, void *redist_base);
+void gic_irq_enable(unsigned int intid);
+void gic_irq_disable(unsigned int intid);
+unsigned int gic_get_and_ack_irq(void);
+void gic_set_eoi(unsigned int intid);
+
+#endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
new file mode 100644
index 000000000000..fff4fc27504d
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM Generic Interrupt Controller (GIC) support
+ */
+
+#include <errno.h>
+#include <linux/bits.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+
+#include <gic.h>
+#include "gic_private.h"
+#include "processor.h"
+#include "spinlock.h"
+
+static const struct gic_common_ops *gic_common_ops;
+static struct spinlock gic_lock;
+
+static void gic_cpu_init(unsigned int cpu, void *redist_base)
+{
+	gic_common_ops->gic_cpu_init(cpu, redist_base);
+}
+
+static void
+gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
+{
+	const struct gic_common_ops *gic_ops = NULL;
+
+	spin_lock(&gic_lock);
+
+	/* Distributor initialization is needed only once per VM */
+	if (gic_common_ops) {
+		spin_unlock(&gic_lock);
+		return;
+	}
+
+	if (type == GIC_V3)
+		gic_ops = &gicv3_ops;
+
+	GUEST_ASSERT(gic_ops);
+
+	gic_ops->gic_init(nr_cpus, dist_base);
+	gic_common_ops = gic_ops;
+
+	/* Make sure that the initialized data is visible to all the vCPUs */
+	dsb(sy);
+
+	spin_unlock(&gic_lock);
+}
+
+void gic_init(enum gic_type type, unsigned int nr_cpus,
+		void *dist_base, void *redist_base)
+{
+	uint32_t cpu = guest_get_vcpuid();
+
+	GUEST_ASSERT(type < GIC_TYPE_MAX);
+	GUEST_ASSERT(dist_base);
+	GUEST_ASSERT(redist_base);
+	GUEST_ASSERT(nr_cpus);
+
+	gic_dist_init(type, nr_cpus, dist_base);
+	gic_cpu_init(cpu, redist_base);
+}
+
+void gic_irq_enable(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_enable(intid);
+}
+
+void gic_irq_disable(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_disable(intid);
+}
+
+unsigned int gic_get_and_ack_irq(void)
+{
+	uint64_t irqstat;
+	unsigned int intid;
+
+	GUEST_ASSERT(gic_common_ops);
+
+	irqstat = gic_common_ops->gic_read_iar();
+	intid = irqstat & GENMASK(23, 0);
+
+	return intid;
+}
+
+void gic_set_eoi(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_write_eoir(intid);
+}
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_private.h b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
new file mode 100644
index 000000000000..d81d739433dc
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Interrupt Controller (GIC) private defines that's only
+ * shared among the GIC library code.
+ */
+
+#ifndef SELFTEST_KVM_GIC_PRIVATE_H
+#define SELFTEST_KVM_GIC_PRIVATE_H
+
+struct gic_common_ops {
+	void (*gic_init)(unsigned int nr_cpus, void *dist_base);
+	void (*gic_cpu_init)(unsigned int cpu, void *redist_base);
+	void (*gic_irq_enable)(unsigned int intid);
+	void (*gic_irq_disable)(unsigned int intid);
+	uint64_t (*gic_read_iar)(void);
+	void (*gic_write_eoir)(uint32_t irq);
+};
+
+extern const struct gic_common_ops gicv3_ops;
+
+#endif /* SELFTEST_KVM_GIC_PRIVATE_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
new file mode 100644
index 000000000000..973742285b9f
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM Generic Interrupt Controller (GIC) v3 support
+ */
+
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "delay.h"
+
+#include "gic_v3.h"
+#include "gic_private.h"
+
+struct gicv3_data {
+	void *dist_base;
+	void *redist_base[GICV3_MAX_CPUS];
+	unsigned int nr_cpus;
+	unsigned int nr_spis;
+};
+
+#define sgi_base_from_redist(redist_base) (redist_base + SZ_64K)
+
+enum gicv3_intid_range {
+	SGI_RANGE,
+	PPI_RANGE,
+	SPI_RANGE,
+	INVALID_RANGE,
+};
+
+static struct gicv3_data gicv3_data;
+
+static void gicv3_gicd_wait_for_rwp(void)
+{
+	unsigned int count = 100000; /* 1s */
+
+	while (readl(gicv3_data.dist_base + GICD_CTLR) & GICD_CTLR_RWP) {
+		GUEST_ASSERT(count--);
+		udelay(10);
+	}
+}
+
+static void gicv3_gicr_wait_for_rwp(void *redist_base)
+{
+	unsigned int count = 100000; /* 1s */
+
+	while (readl(redist_base + GICR_CTLR) & GICR_CTLR_RWP) {
+		GUEST_ASSERT(count--);
+		udelay(10);
+	}
+}
+
+static enum gicv3_intid_range get_intid_range(unsigned int intid)
+{
+	switch (intid) {
+	case 0 ... 15:
+		return SGI_RANGE;
+	case 16 ... 31:
+		return PPI_RANGE;
+	case 32 ... 1019:
+		return SPI_RANGE;
+	}
+
+	/* We should not be reaching here */
+	GUEST_ASSERT(0);
+
+	return INVALID_RANGE;
+}
+
+static uint64_t gicv3_read_iar(void)
+{
+	uint64_t irqstat = read_sysreg_s(SYS_ICC_IAR1_EL1);
+
+	dsb(sy);
+	return irqstat;
+}
+
+static void gicv3_write_eoir(uint32_t irq)
+{
+	write_sysreg_s(SYS_ICC_EOIR1_EL1, irq);
+	isb();
+}
+
+static void
+gicv3_config_irq(unsigned int intid, unsigned int offset)
+{
+	uint32_t cpu = guest_get_vcpuid();
+	uint32_t mask = 1 << (intid % 32);
+	enum gicv3_intid_range intid_range = get_intid_range(intid);
+	void *reg;
+
+	/* We care about 'cpu' only for SGIs or PPIs */
+	if (intid_range == SGI_RANGE || intid_range == PPI_RANGE) {
+		GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
+
+		reg = sgi_base_from_redist(gicv3_data.redist_base[cpu]) +
+			offset;
+		writel(mask, reg);
+		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu]);
+	} else if (intid_range == SPI_RANGE) {
+		reg = gicv3_data.dist_base + offset + (intid / 32) * 4;
+		writel(mask, reg);
+		gicv3_gicd_wait_for_rwp();
+	} else {
+		GUEST_ASSERT(0);
+	}
+}
+
+static void gicv3_irq_enable(unsigned int intid)
+{
+	gicv3_config_irq(intid, GICD_ISENABLER);
+}
+
+static void gicv3_irq_disable(unsigned int intid)
+{
+	gicv3_config_irq(intid, GICD_ICENABLER);
+}
+
+static void gicv3_enable_redist(void *redist_base)
+{
+	uint32_t val = readl(redist_base + GICR_WAKER);
+	unsigned int count = 100000; /* 1s */
+
+	val &= ~GICR_WAKER_ProcessorSleep;
+	writel(val, redist_base + GICR_WAKER);
+
+	/* Wait until the processor is 'active' */
+	while (readl(redist_base + GICR_WAKER) & GICR_WAKER_ChildrenAsleep) {
+		GUEST_ASSERT(count--);
+		udelay(10);
+	}
+}
+
+static inline void *gicr_base_gpa_cpu(void *redist_base, uint32_t cpu)
+{
+	/* Align all the redistributors sequentially */
+	return redist_base + cpu * SZ_64K * 2;
+}
+
+static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
+{
+	void *sgi_base;
+	unsigned int i;
+	void *redist_base_cpu;
+
+	GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
+
+	redist_base_cpu = gicr_base_gpa_cpu(redist_base, cpu);
+	sgi_base = sgi_base_from_redist(redist_base_cpu);
+
+	gicv3_enable_redist(redist_base_cpu);
+
+	/*
+	 * Mark all the SGI and PPI interrupts as non-secure Group-1.
+	 * Also, deactivate and disable them.
+	 */
+	writel(~0, sgi_base + GICR_IGROUPR0);
+	writel(~0, sgi_base + GICR_ICACTIVER0);
+	writel(~0, sgi_base + GICR_ICENABLER0);
+
+	/* Set a default priority for all the SGIs and PPIs */
+	for (i = 0; i < 32; i += 4)
+		writel(GICD_INT_DEF_PRI_X4,
+				sgi_base + GICR_IPRIORITYR0 + i);
+
+	gicv3_gicr_wait_for_rwp(redist_base_cpu);
+
+	/* Enable the GIC system register (ICC_*) access */
+	write_sysreg_s(SYS_ICC_SRE_EL1,
+			read_sysreg_s(SYS_ICC_SRE_EL1) | ICC_SRE_EL1_SRE);
+
+	/* Set a default priority threshold */
+	write_sysreg_s(SYS_ICC_PMR_EL1, ICC_PMR_DEF_PRIO);
+
+	/* Enable non-secure Group-1 interrupts */
+	write_sysreg_s(SYS_ICC_GRPEN1_EL1, ICC_IGRPEN1_EL1_ENABLE);
+
+	gicv3_data.redist_base[cpu] = redist_base_cpu;
+}
+
+static void gicv3_dist_init(void)
+{
+	void *dist_base = gicv3_data.dist_base;
+	unsigned int i;
+
+	/* Disable the distributor until we set things up */
+	writel(0, dist_base + GICD_CTLR);
+	gicv3_gicd_wait_for_rwp();
+
+	/*
+	 * Mark all the SPI interrupts as non-secure Group-1.
+	 * Also, deactivate and disable them.
+	 */
+	for (i = 32; i < gicv3_data.nr_spis; i += 32) {
+		writel(~0, dist_base + GICD_IGROUPR + i / 8);
+		writel(~0, dist_base + GICD_ICACTIVER + i / 8);
+		writel(~0, dist_base + GICD_ICENABLER + i / 8);
+	}
+
+	/* Set a default priority for all the SPIs */
+	for (i = 32; i < gicv3_data.nr_spis; i += 4)
+		writel(GICD_INT_DEF_PRI_X4,
+				dist_base + GICD_IPRIORITYR + i);
+
+	/* Wait for the settings to sync-in */
+	gicv3_gicd_wait_for_rwp();
+
+	/* Finally, enable the distributor globally with ARE */
+	writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A |
+			GICD_CTLR_ENABLE_G1, dist_base + GICD_CTLR);
+	gicv3_gicd_wait_for_rwp();
+}
+
+static void gicv3_init(unsigned int nr_cpus, void *dist_base)
+{
+	GUEST_ASSERT(nr_cpus <= GICV3_MAX_CPUS);
+
+	gicv3_data.nr_cpus = nr_cpus;
+	gicv3_data.dist_base = dist_base;
+	gicv3_data.nr_spis = GICD_TYPER_SPIS(
+				readl(gicv3_data.dist_base + GICD_TYPER));
+	if (gicv3_data.nr_spis > 1020)
+		gicv3_data.nr_spis = 1020;
+
+	/*
+	 * Initialize only the distributor for now.
+	 * The redistributor and CPU interfaces are initialized
+	 * later for every PE.
+	 */
+	gicv3_dist_init();
+}
+
+const struct gic_common_ops gicv3_ops = {
+	.gic_init = gicv3_init,
+	.gic_cpu_init = gicv3_cpu_init,
+	.gic_irq_enable = gicv3_irq_enable,
+	.gic_irq_disable = gicv3_irq_disable,
+	.gic_read_iar = gicv3_read_iar,
+	.gic_write_eoir = gicv3_write_eoir,
+};
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
new file mode 100644
index 000000000000..b51536d469a6
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Interrupt Controller (GIC) v3 specific defines
+ */
+
+#ifndef SELFTEST_KVM_GICV3_H
+#define SELFTEST_KVM_GICV3_H
+
+#include <asm/sysreg.h>
+
+/*
+ * Distributor registers
+ */
+#define GICD_CTLR			0x0000
+#define GICD_TYPER			0x0004
+#define GICD_IGROUPR			0x0080
+#define GICD_ISENABLER			0x0100
+#define GICD_ICENABLER			0x0180
+#define GICD_ICACTIVER			0x0380
+#define GICD_IPRIORITYR			0x0400
+
+/*
+ * The assumption is that the guest runs in a non-secure mode.
+ * The following bits of GICD_CTLR are defined accordingly.
+ */
+#define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_nASSGIreq		(1U << 8)
+#define GICD_CTLR_ARE_NS		(1U << 4)
+#define GICD_CTLR_ENABLE_G1A		(1U << 1)
+#define GICD_CTLR_ENABLE_G1		(1U << 0)
+
+#define GICD_TYPER_SPIS(typer)		((((typer) & 0x1f) + 1) * 32)
+#define GICD_INT_DEF_PRI_X4		0xa0a0a0a0
+
+/*
+ * Redistributor registers
+ */
+#define GICR_CTLR			0x000
+#define GICR_WAKER			0x014
+
+#define GICR_CTLR_RWP			(1U << 3)
+
+#define GICR_WAKER_ProcessorSleep	(1U << 1)
+#define GICR_WAKER_ChildrenAsleep	(1U << 2)
+
+/*
+ * Redistributor registers, offsets from SGI base
+ */
+#define GICR_IGROUPR0			GICD_IGROUPR
+#define GICR_ISENABLER0			GICD_ISENABLER
+#define GICR_ICENABLER0			GICD_ICENABLER
+#define GICR_ICACTIVER0			GICD_ICACTIVER
+#define GICR_IPRIORITYR0		GICD_IPRIORITYR
+
+/* CPU interface registers */
+#define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
+#define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
+#define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
+#define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
+#define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
+
+#define ICC_PMR_DEF_PRIO		0xf0
+
+#define ICC_SRE_EL1_SRE			(1U << 0)
+
+#define ICC_IGRPEN1_EL1_ENABLE		(1U << 0)
+
+#define GICV3_MAX_CPUS			512
+
+#endif /* SELFTEST_KVM_GICV3_H */
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
