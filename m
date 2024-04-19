Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9EB84FCE
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566381; cv=none; b=say4Q6KHLYyvqZKhOSZLmKt12vAquHxz7r1PQmyFNutr66woXNAzWMG45dUGxdOGfM64gQhnbyrJjGz8b3ZJrfPm13t4f2tBD9dqzltFmx0av7Y2y5D0nabm+K1SH5kr07UORL3iUXC2YORnm0oKd3c961k9WxUuV89G++WZTpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566381; c=relaxed/simple;
	bh=wJZ7DW4qRQZS/6pM79B33QEZG+sA+diqf7yBczhVEC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyNdWVwzJtaxiox8osXrbPic//6N5bplUedVBS/qVzq9XxWWqVfrcX2ybZVp2XZMlZgQdBTIrcgMGFUOZa1jP0MHVe3PPQwdTamuSb1FuEvpNTLiIp+PniwvANh3MofUdf4YVmMvLn6Y9qUaduMcnBKVlu15yLfHBAy/FW9JcYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PXPishu+; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PXPishu+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nhnp3uWaD4aJFeFGI/XmtL06tlTKY/BOmAF29V3Wh+w=;
	b=PXPishu+glz/X9MGCM8iC4Nvmz/2hZmFMm26i8O3y2KGx+lFicrnId5pqTQHagodLbW91V
	AArjwSwFGyv17X1pV6X93MXyPtWMec7Ta2IOwl/X8OFului605qKQPmAAL1/BCnYhJdZbX
	R2CHtQxc3Z1cI1EYJXJP2de2EFQp5zU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 17/19] KVM: selftests: Add helper for enabling LPIs on a redistributor
Date: Fri, 19 Apr 2024 22:38:40 +0000
Message-ID: <20240419223842.951452-18-oliver.upton@linux.dev>
In-Reply-To: <20240419223842.951452-1-oliver.upton@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The selftests GIC library presently does not support LPIs. Add a
userspace helper for configuring a redistributor for LPIs, installing
an LPI configuration table and LPI pending table.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/aarch64/gic.h       |  3 +++
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 24 +++++++++++++++++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 6d03188435e4..baeb3c859389 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -58,4 +58,7 @@ void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
 
+void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
+			   vm_paddr_t pend_table);
+
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 515335179045..66d05506f78b 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -401,3 +401,27 @@ const struct gic_common_ops gicv3_ops = {
 	.gic_irq_get_pending = gicv3_irq_get_pending,
 	.gic_irq_set_config = gicv3_irq_set_config,
 };
+
+void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
+			   vm_paddr_t pend_table)
+{
+	volatile void *rdist_base = gicr_base_cpu(guest_get_vcpuid());
+
+	u32 ctlr;
+	u64 val;
+
+	val = (cfg_table |
+	       GICR_PROPBASER_InnerShareable |
+	       GICR_PROPBASER_RaWaWb |
+	       ((ilog2(cfg_table_size) - 1) & GICR_PROPBASER_IDBITS_MASK));
+	writeq_relaxed(val, rdist_base + GICR_PROPBASER);
+
+	val = (pend_table |
+	       GICR_PENDBASER_InnerShareable |
+	       GICR_PENDBASER_RaWaWb);
+	writeq_relaxed(val, rdist_base + GICR_PENDBASER);
+
+	ctlr = readl_relaxed(rdist_base + GICR_CTLR);
+	ctlr |= GICR_CTLR_ENABLE_LPIS;
+	writel_relaxed(ctlr, rdist_base + GICR_CTLR);
+}
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 5e8f0d5382c2..4427f43f73ea 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -3,8 +3,10 @@
  * ARM Generic Interrupt Controller (GIC) v3 host support
  */
 
+#include <linux/kernel.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
+#include <asm/cputype.h>
 #include <asm/kvm_para.h>
 #include <asm/kvm.h>
 
-- 
2.44.0.769.g3c40516874-goog

