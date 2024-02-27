Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD5655783
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073813; cv=none; b=J0i2uNGcEfXSHhcfyfyZm7OEGvpuNp5woqZ225YQY+O3TkXq5L1fYZ5kEGJdFv82nCElupXgHweSLsm1h+MR8x8AOZD89lSvDY2BTp8xTsmHoEMhIa40UpNOBrIkfBzRACSwx0ieoReW8U4XudK6BGG1e5eMARp5Gm1Otr1q4Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073813; c=relaxed/simple;
	bh=44UfppR1g+s+4pZkqxJbI3okaGpCW6NXNPBAR+Ccp48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCURCkFW5dxeFYwyACBe2+AGlINgsvuiNo3LJwYlbpPkjEQH6Tao1HQvqLDkLfbyjsm8S2gzBFGOg23MJV119tFx4B5/TEq3BYIHoH9ENs0mM8wbZx+VkMF4b0pnGpiRUSK8rcSDynJ3kuuuqCpwYl4UCJ46uWhETioGIATLOMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lziu2iff; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lziu2iff"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccbCI5k+i6zOMbjfGnjf3Mq3RpSm87vBtzco7KOImnQ=;
	b=Lziu2iffTRJ4VqEwvExiQpTYy9Bak/p37vPeoFBTFj1qotah+nsjUof+76Tn0xdAg5GP2/
	bz89BLvZuuP4kzOTp/YkzjHKufUHWRgDVQRjA1euPoLXH71wlojPQ5SohZod07L/16DzjX
	ytb7do0TUA1WMWxdIU7kewVJL+XLi70=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 17/20] KVM: selftests: Add helper for enabling LPIs on a redistributor
Date: Tue, 27 Feb 2024 22:42:46 +0000
Message-ID: <20240227224249.2209194-18-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
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
index 62243ba12f23..db9bf4987b02 100644
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
2.44.0.rc1.240.g4c46232300-goog

