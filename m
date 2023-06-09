Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EB118C34
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4nIgOz3LTxxT+yyK3YFCL27lV4sCWQlvepV/PBWNpb8=;
	b=iVftcYIMMgyQP1w7izcIUPRYmRbkgmPWy91tPr6dKSvioaoWk3M1aP1FTPaySt51So8+bP
	O9eJq8z25+W2mfrWCqZFBORKgzsjXCBfSRTyt0kafADgt192mrL7rvrCnY2+ILMsYZOvEw
	3otqjBIjHoB5tHowB8/wwHABn6BmUVE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 08/11] KVM: arm64: Use generic sanitisation for ID_(AA64)DFR0_EL1
Date: Fri,  9 Jun 2023 19:00:51 +0000
Message-ID: <20230609190054.1542113-9-oliver.upton@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jing Zhang <jingzhangos@google.com>

KVM allows userspace to specify a PMU version for the guest by writing
to the corresponding ID registers. Currently the validation of these
writes is done manuallly, but there's no reason we can't switch over to
the generic sanitisation infrastructure.

Start screening user writes through arm64_check_features() to prevent
userspace from over-promising in terms of vPMU support. Leave the old
masking in place for now, as we aren't completely ready to serve reads
from the VM-wide values.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
[Oliver: split off from monster patch, cleaned up handling of NI vPMU
 values, wrote commit description]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 106 ++++++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0fbdb6ef68e4..feefa2454620 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -42,6 +42,8 @@
  */
 
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
+static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		      u64 val);
 
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
@@ -1503,15 +1505,35 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+
+	/* Limit debug to ARMv8.0 */
+	val &= ~ID_AA64DFR0_EL1_DebugVer_MASK;
+	val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DebugVer, IMP);
+
+	/*
+	 * Only initialize the PMU version if the vCPU was configured with one.
+	 */
+	val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+	if (kvm_vcpu_has_pmu(vcpu))
+		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMUVer,
+				      kvm_arm_pmu_get_pmuver_limit());
+
+	/* Hide SPE from guests */
+	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
+
+	return val;
+}
+
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
-	bool valid_pmu;
-
-	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
-	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
+	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
+	int r;
 
 	/*
 	 * Prior to commit 3d0dba5764b9 ("KVM: arm64: PMU: Move the
@@ -1532,38 +1554,33 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 		pmuver = 0;
 	}
 
-	/*
-	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
-	 * as it doesn't promise more than what the HW gives us.
-	 */
-	if (pmuver > host_pmuver)
-		return -EINVAL;
+	r = set_id_reg(vcpu, rd, val);
+	if (r)
+		return r;
 
-	valid_pmu = pmuver;
+	vcpu->kvm->arch.dfr0_pmuver = pmuver;
+	return 0;
+}
 
-	/* Make sure view register and PMU support do match */
-	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
-		return -EINVAL;
+static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *rd)
+{
+	u8 perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+	u64 val = read_sanitised_ftr_reg(SYS_ID_DFR0_EL1);
 
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
+	val &= ~ID_DFR0_EL1_PerfMon_MASK;
+	if (kvm_vcpu_has_pmu(vcpu))
+		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
-	vcpu->kvm->arch.dfr0_pmuver = pmuver;
-	return 0;
+	return val;
 }
 
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *rd,
 			   u64 val)
 {
-	u8 perfmon, host_perfmon;
-	bool valid_pmu;
-
-	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
-	perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	int r;
 
 	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
@@ -1576,21 +1593,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	 * AArch64 side (as everything is emulated with that), and
 	 * that this is a PMUv3.
 	 */
-	if (perfmon > host_perfmon ||
-	    (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3))
-		return -EINVAL;
-
-	valid_pmu = perfmon;
-
-	/* Make sure view register and PMU support do match */
-	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
+	if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
 		return -EINVAL;
 
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
+	r = set_id_reg(vcpu, rd, val);
+	if (r)
+		return r;
 
 	vcpu->kvm->arch.dfr0_pmuver = perfmon_to_pmuver(perfmon);
 	return 0;
@@ -1988,9 +1996,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility, },
+	{ SYS_DESC(SYS_ID_DFR0_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_dfr0_el1,
+	  .visibility = aa32_id_visibility,
+	  .reset = read_sanitised_id_dfr0_el1,
+	  .val = ID_DFR0_EL1_PerfMon_MASK, },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2030,8 +2042,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_aa64dfr0_el1,
+	  .reset = read_sanitised_id_aa64dfr0_el1,
+	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.162.gfafddb0af9-goog

