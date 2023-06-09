Received: from out-27.mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA318C34
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:30 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nFU1uOIXyrlBIcCvtG+L+TWgzCcSRnag9g6IKs4AUHI=;
	b=ftnqiVFR+q2Uz76WQeLAWRReCUNIQfjVPI7y+9QMdWnrbMp43szRTkwAS99fk8taqF3Jdf
	t95P9r6I0ko7ZHRMkgnFcZbmC0pjuaLyeFkbYf/qfFiGy4IZQgUZNMYoJPVHSuid+wcesB
	NACodoSndkiQunrcsOWuJVtwzOLP/uw=
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
Subject: [PATCH v12 09/11] KVM: arm64: Use generic sanitisation for ID_AA64PFR0_EL1
Date: Fri,  9 Jun 2023 19:00:52 +0000
Message-ID: <20230609190054.1542113-10-oliver.upton@linux.dev>
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

KVM allows userspace to write to the CSV2 and CSV3 fields of
ID_AA64PFR0_EL1 so long as it doesn't over-promise on the
Spectre/Meltdown mitigation state. Switch over to the new way of the
world for screening user writes. Leave the old plumbing in place until
we actually start handling ID register reads from the VM-wide values.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
[Oliver: split from monster patch, added commit description]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 66 ++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index feefa2454620..6f2ce6619993 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1470,34 +1470,54 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	if (!vcpu_has_sve(vcpu))
+		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
+
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ID_AA64PFR0_EL1_CSV2_MASK;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, CSV2, IMP);
+	}
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ID_AA64PFR0_EL1_CSV3_MASK;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, CSV3, IMP);
+	}
+
+	if (kvm_vgic_global_state.type == VGIC_V3) {
+		val &= ~ID_AA64PFR0_EL1_GIC_MASK;
+		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
+	}
+
+	val &= ~ID_AA64PFR0_EL1_AMU_MASK;
+
+	return val;
+}
+
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
 	u8 csv2, csv3;
+	int r;
 
-	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
-	 */
 	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* Same thing for CSV3 */
 	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
 
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
+	r = set_id_reg(vcpu, rd, val);
+	if (r)
+		return r;
 
 	vcpu->kvm->arch.pfr0_csv2 = csv2;
 	vcpu->kvm->arch.pfr0_csv3 = csv3;
@@ -2031,8 +2051,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_aa64pfr0_el1,
+	  .reset = read_sanitised_id_aa64pfr0_el1,
+	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.162.gfafddb0af9-goog

