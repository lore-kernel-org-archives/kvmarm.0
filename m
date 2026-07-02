Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2850C353A95
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 19:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783019083; cv=none; b=rRm03G2GDO0r5LeniTAXrjwhYOKNv1167/oPWJPpc2ChuAbRqkI/yayxXu+HMt40REVrOp9xUUCsB6aqdxcpJNR15FN8hhPN7R2QqYEDYQqxJufXyFv4OHw4G0isxyr6iGCllJ8Az9BWVMgLhgRIU7RJ/EoNo6u6KD0b09oaZ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783019083; c=relaxed/simple;
	bh=xKTdiG29T+uXRKOkBpxusspuq3LArWPo6sKTpahkQZk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2ldtjWPF/C0pCCeoNU/MnSlDWl9VPMGUHhN5wLX3pFK6hnQ70JbaeFtjDa87qxzE00zW1sKuZGyR5j+ex59oK9w+KYa/rFlP/oxC6UJCffx1ATlTGvB0rVnRu0+Yt21nJ72eUN7Gvt1nqFnlGl+V3xeaxSRFULiSGfxSoGjHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZAsSZ0kS; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZAsSZ0kS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1783019082; x=1814555082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2pe7QGosUd6pYukAZkp7UoQqhXM2BPwlkxGc7CrlhlE=;
  b=ZAsSZ0kSqPDpxta4W1hy4gOcACe2MWxL+vgUYO39B5Fbw6TQIitpxPMf
   7elOKRGsW4A2ltbj4fD/AtNv+Jce1Swu5LQk523cM9azHLP7KvzsXa2aZ
   XVxNyza9Kt74vahjP3IkR0Bh7xl93upzIEife3ZzREUV+DrY+kYuPtXmh
   tVQJDZOXtyCeIUuD9msxVQVv01LSNd0IuUMXDvhKKn4dSoudcJWUwq+Rw
   PcQYWozqioMrIlYxNcWEMdP0SX7t6ne653uMOl/bu9aEtbFhyr4jHfanO
   gNEYNXgEa+JnppSSR6bYxV4KPnd3QlLMgBgJ9vE5zOTVEkj1TZJOx8llO
   w==;
X-CSE-ConnectionGUID: KnK3/dG4SAiAG74xMu7Rww==
X-CSE-MsgGUID: fxhspPhJRbCWRBy+suXonQ==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22959825"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 19:04:41 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:21211]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.237:2525] with esmtp (Farcaster)
 id 7c09ebf7-9e63-4c84-ad0d-86b36d4e71af; Thu, 2 Jul 2026 19:04:41 +0000 (UTC)
X-Farcaster-Flow-ID: 7c09ebf7-9e63-4c84-ad0d-86b36d4e71af
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 19:04:41 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 19:04:40 +0000
From: Congkai Tan <congkai@amazon.com>
To: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Haris Okanovic <harisokn@amazon.com>, Geoff Blake
	<blakgeof@amazon.com>, Stanislav Spassov <stanspas@amazon.de>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] KVM: arm64: Expose PMMIR_EL1.SLOTS under strict PMUv3 UAPI
Date: Thu, 2 Jul 2026 19:04:20 +0000
Message-ID: <20260702190421.420992-3-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260702190421.420992-1-congkai@amazon.com>
References: <20260702190421.420992-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Introduce a new field pmmir_slots in struct kvm_arch to store
PMMIR_EL1.SLOTS. It only saves the actual hardware PMU value when
the VMM explicitly selects a PMU under KVM_ARM_VCPU_PMU_V3_STRICT.
Otherwise, it stays 0 after allocation.

Use this field to implement guest access, userspace get, and userspace
set for PMMIR_EL1:
- access_pmmir(): uses the value in kvm->arch.pmmir_slots directly. If
  the VMM selected a PMU and KVM_ARM_VCPU_PMU_V3_STRICT is set, the guest
  can correctly read the underlying core's SLOTS. Otherwise, it continues
  to read 0 since the true SLOTS value can be nondeterministic.
- get_pmmir(): same as access_pmmir().
- set_pmmir(): only the SLOTS field is writable; a value setting any
  other bit is rejected with -EINVAL, since get_pmmir() returns SLOTS
  zero-extended. A value of 0 resets kvm->arch.pmmir_slots to 0 for
  backward compatibility, as the register is RAZ in older KVM, a value
  matching the current SLOTS is accepted as a no-op, and anything else is
  rejected with -EINVAL. Once the VM has run PMMIR_EL1 is immutable, so a
  mismatching write then returns -EBUSY.

The register is now exposed via KVM_GET_REG_LIST for PMUv3 vCPUs, so add
it to the get-reg-list selftest's PMU register list.

Signed-off-by: Congkai Tan <congkai@amazon.com>
Reviewed-by: Geoff Blake <blakgeof@amazon.com>
Reviewed-by: Haris Okanovic <harisokn@amazon.com>
Reviewed-by: Stanislav Spassov <stanspas@amazon.de>
---
 arch/arm64/include/asm/kvm_host.h             |  3 +
 arch/arm64/kvm/pmu-emul.c                     | 11 ++++
 arch/arm64/kvm/sys_regs.c                     | 63 ++++++++++++++++++-
 .../selftests/kvm/arm64/get-reg-list.c        |  1 +
 4 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a6e33aaf400d..b896d6eef822 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -387,6 +387,9 @@ struct kvm_arch {
 	/* Maximum number of counters for the guest */
 	u8 nr_pmu_counters;
 
+	/* PMMIR_EL1.SLOTS value exposed to the guest. */
+	u8 pmmir_slots;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 1f24169505a9..9595bce6519f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1117,6 +1117,17 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 
 			kvm_arm_set_pmu(kvm, arm_pmu);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
+
+			/*
+			 * Since a specific PMU is explicitly selected,
+			 * PMMIR_EL1.SLOTS is deterministic to the guest.
+			 * If KVM_ARM_VCPU_PMU_V3_STRICT is set, snapshot
+			 * the value to allow the guest to read it.
+			 */
+			if (kvm_vcpu_has_pmuv3_strict(vcpu))
+				kvm->arch.pmmir_slots =
+					FIELD_GET(ARMV8_PMU_SLOTS,
+						  arm_pmu->reg_pmmir);
 			ret = 0;
 			break;
 		}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea8..edfbb8de1528 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1370,6 +1370,64 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_pmmir(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	/*
+	 * If KVM_ARM_VCPU_PMU_V3_STRICT is set and PMU was explicitly
+	 * selected, the underlying hardware SLOTS value was read into this
+	 * field. Otherwise, it stays 0. All other PMMIR_EL1 fields are RAZ.
+	 */
+	p->regval = FIELD_PREP(ARMV8_PMU_SLOTS, vcpu->kvm->arch.pmmir_slots);
+	return true;
+}
+
+static int get_pmmir(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		     u64 *val)
+{
+	*val = FIELD_PREP(ARMV8_PMU_SLOTS, vcpu->kvm->arch.pmmir_slots);
+	return 0;
+}
+
+static int set_pmmir(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		     u64 val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u8 slots = FIELD_GET(ARMV8_PMU_SLOTS, val);
+
+	/*
+	 * Only the SLOTS field is exposed (get_pmmir returns just that field),
+	 * so reject a write that sets any other bit rather than silently
+	 * masking it.
+	 */
+	if (val & ~(u64)ARMV8_PMU_SLOTS)
+		return -EINVAL;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	/*
+	 * Once the VM has started PMMIR_EL1 is immutable. Reject any write
+	 * that does not match the current value.
+	 */
+	if (kvm_vm_has_ran_once(kvm))
+		return slots == kvm->arch.pmmir_slots ? 0 : -EBUSY;
+
+	/*
+	 * Only SLOTS = 0 is honored for backwards compatibility with the
+	 * old RAZ behavior. Reject any non-zero write that does not match
+	 * the current value.
+	 */
+	if (!slots)
+		kvm->arch.pmmir_slots = 0;
+	else if (slots != kvm->arch.pmmir_slots)
+		return -EINVAL;
+
+	return 0;
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -3456,7 +3514,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMINTENCLR_EL1),
 	  .access = access_pminten, .reg = PMINTENSET_EL1,
 	  .get_user = get_pmreg, .set_user = set_pmreg },
-	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
+	{ PMU_SYS_REG(PMMIR_EL1), .access = access_pmmir, .reset = NULL,
+	  .get_user = get_pmmir, .set_user = set_pmmir },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1,
@@ -4600,7 +4659,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ CP15_PMU_SYS_REG(HI,     0, 9, 14, 4), .access = access_pmceid },
 	{ CP15_PMU_SYS_REG(HI,     0, 9, 14, 5), .access = access_pmceid },
 	/* PMMIR */
-	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 6), .access = trap_raz_wi },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 6), .access = access_pmmir },
 
 	/* PRRR/MAIR0 */
 	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 0a3a94c4cca1..cfa99979d57c 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -532,6 +532,7 @@ static __u64 base_regs[] = {
 static __u64 pmu_regs[] = {
 	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
 	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
+	ARM64_SYS_REG(3, 0, 9, 14, 6),	/* PMMIR_EL1 */
 	ARM64_SYS_REG(3, 3, 9, 12, 0),	/* PMCR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 1),	/* PMCNTENSET_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 2),	/* PMCNTENCLR_EL0 */
-- 
2.50.1

