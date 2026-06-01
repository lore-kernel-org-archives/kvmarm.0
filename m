Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3F337C0E3
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 19:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342811; cv=none; b=IsM9d4tzeJEjlcM5Omvl50j1PX/JiEGtSxnOSk+gxpOkNsbjRDLXTzOtBrbeb40tQ1EScs9XVvJ/4ubmr3TosMdkhmhNbMjYBaDVQI2TAnHxXwRWpXnzpc43U31yKNx4jmqm0CN0+xSfQd+u1D4TtWFJEdk6EKAFFSHjZ6MAJfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342811; c=relaxed/simple;
	bh=+AZwzpsOwdn1AdnoewXEVF102clXYpAHjNhKZRFdWes=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ruLP298V1CinN+Eyi2PD7iW9ZhT1qG6rA6RupFsDkFs8XBMVqgH7CtIYxg8R8bLgL9KeVMtRoaexiZsO8IkHsoQIu+Ynh4MEquPWsr7lvp3NMO5JmggT0gzRhjkB95TaG32/kke5KmD/YRz2ljdJlJvgdTcT+2STA4ikJ3UKJyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=NLqewbli; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="NLqewbli"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780342809; x=1811878809;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CEV8mTgiEkV3pKTwbj9JmWq0S+SCs1B/j92LF4+Bo+k=;
  b=NLqewbliYIZRptd8JfLj2f2xJb6ZcI6DyJwpsLOiQVjyzMCbrTj5yaPR
   Qxq+gH04uC2v7Bbvm6+ZlsdVOCfpaNWcDPy0s9w8zCMK6e9Y9LuwrzARi
   lY8TVL8NwNGDeYAn7eMP1ou0mKbw85pVxWEr32MoCeI4wMsOM2ABZb214
   HDlh5CMmDeLiiH2By4XEv0SxDZaPmUyDDCExgM4YcAFiy86pG6cTcQZ12
   KOTuMc0eSiSDSV7dBORSBQALhDTaDjwrIx/ZPpCm8HyQMhKK/gwgBiaBA
   Rv4Rt0Df4Q9bAXVegmvwh9GT/SP4ki26wCegfXxeXMMQpd5UVlqmRAWNv
   Q==;
X-CSE-ConnectionGUID: Uok1d9SkSIedDsFn8SIMMw==
X-CSE-MsgGUID: k/bi1f2+SuyGnTpK0Rc8eQ==
X-IronPort-AV: E=Sophos;i="6.24,181,1774310400"; 
   d="scan'208";a="20896261"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 19:40:09 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:12267]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.88:2525] with esmtp (Farcaster)
 id 80c07004-3a76-4dfb-b7ae-c4c08f0e1e85; Mon, 1 Jun 2026 19:40:09 +0000 (UTC)
X-Farcaster-Flow-ID: 80c07004-3a76-4dfb-b7ae-c4c08f0e1e85
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 1 Jun 2026 19:40:08 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 1 Jun 2026
 19:40:07 +0000
From: Congkai Tan <congkai@amazon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Haris Okanovic <harisokn@amazon.com>, Geoff Blake
	<blakgeof@amazon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Date: Mon, 1 Jun 2026 19:39:54 +0000
Message-ID: <20260601193954.2103455-1-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWA003.ant.amazon.com (10.13.139.86) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Commit 46081078feb4 ("KVM: arm64: Upgrade PMU support to ARMv8.4")
trapped PMMIR_EL1 as RAZ/WI and masked STALL_SLOT* from PMCEID1 to
discourage guests from relying on a register they could not read.

Forward the SLOTS field of PMMIR_EL1 so that the perf userspace tool
can read the correct value from
/sys/bus/event_source/devices/armv8_pmuv3_0/caps/slots. Today, perf
stat fails with message "Failure to read '#slots'" because it can
only read 0x0 from the sysfs location, causing the parsing failure
of the default metrics.

Fix this by:
1. Adding an access_pmmir() handler that reads arm_pmu->reg_pmmir
   and returns a masked value containing only the SLOTS field [7:0]
   to the guest. Other PMMIR_EL1 fields are kept as RAZ to limit
   the extra information that this change exposes; individual
   fields can be unmasked as KVM gains support for each feature.
2. Removing the STALL_SLOT, STALL_SLOT_FRONTEND and STALL_SLOT_BACKEND
   mask in PMCEID1. The mask existed to hide these events under the
   sysfs events/ directory when PMMIR_EL1 was RAZ; with SLOTS now
   readable they should be correctly exposed.

Tested on Graviton 2 (Neoverse N1, pre-PMUv3p4), Graviton 3
(Neoverse V1) and Graviton 4 (Neoverse V2) metal hosts with QEMU:
caps/slots reads 0x00000008 in guests on Graviton 3/4 and 0x00000000
on Graviton 2 (correct for pre-PMUv3p4). perf stat correctly
evaluates the default metrics.

Fixes: 46081078feb4 ("KVM: arm64: Upgrade PMU support to ARMv8.4")
Cc: stable@vger.kernel.org
Signed-off-by: Congkai Tan <congkai@amazon.com>
Reviewed-by: Haris Okanovic <harisokn@amazon.com>
Reviewed-by: Geoff Blake <blakgeof@amazon.com>
---
 arch/arm64/kvm/pmu-emul.c | 11 +----------
 arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e1860acae641..bafd5a258927 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -864,16 +864,7 @@ static u64 compute_pmceid0(struct arm_pmu *pmu)
 
 static u64 compute_pmceid1(struct arm_pmu *pmu)
 {
-	u64 val = __compute_pmceid(pmu, 1);
-
-	/*
-	 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
-	 * as RAZ
-	 */
-	val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
-		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
-		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
-	return val;
+	return __compute_pmceid(pmu, 1);
 }
 
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea8..7da7566dfd9f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -18,6 +18,7 @@
 #include <linux/printk.h>
 #include <linux/uaccess.h>
 #include <linux/irqchip/arm-gic-v3.h>
+#include <linux/perf/arm_pmu.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cacheflush.h>
@@ -1370,6 +1371,27 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+/*
+ * Expose only PMMIR_EL1.SLOTS to the guest, which is consumed by perf in its
+ * topdown default metric group. Other PMMIR_EL1 fields remain RAZ. Future
+ * patches can extend the exposed mask incrementally as KVM gains support for
+ * those features.
+ */
+static bool access_pmmir(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	struct arm_pmu *cpu_pmu = vcpu->kvm->arch.arm_pmu;
+
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	if (check_pmu_access_disabled(vcpu, 0))
+		return false;
+
+	p->regval = cpu_pmu->reg_pmmir & ARMV8_PMU_SLOTS;
+	return true;
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -3456,7 +3478,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMINTENCLR_EL1),
 	  .access = access_pminten, .reg = PMINTENSET_EL1,
 	  .get_user = get_pmreg, .set_user = set_pmreg },
-	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
+	{ PMU_SYS_REG(PMMIR_EL1), .access = access_pmmir, .reset = NULL },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1,
@@ -4600,7 +4622,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ CP15_PMU_SYS_REG(HI,     0, 9, 14, 4), .access = access_pmceid },
 	{ CP15_PMU_SYS_REG(HI,     0, 9, 14, 5), .access = access_pmceid },
 	/* PMMIR */
-	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 6), .access = trap_raz_wi },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 6), .access = access_pmmir },
 
 	/* PRRR/MAIR0 */
 	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },

base-commit: 1702da76e017ae0fbe1a92b07bc332972c293e89
-- 
2.50.1

