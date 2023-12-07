Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACDB4437C
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 017DD139F;
	Thu,  7 Dec 2023 07:09:15 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.197.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15A7E3F762;
	Thu,  7 Dec 2023 07:08:27 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v2 4/4] KVM: arm64: Disable MPAM visibility by default, and handle traps
Date: Thu,  7 Dec 2023 15:08:04 +0000
Message-Id: <20231207150804.3425468-5-james.morse@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207150804.3425468-1-james.morse@arm.com>
References: <20231207150804.3425468-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently KVM only allows certain writeable ID registers to be
downgraded from their reset value.

commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
but didn't add trap handling. A previous patch supplied the missing trap
handling.

Existing VMs that have the MPAM field of AA64PFR0_EL1 need to be
migratable, but there is little point enabling the MPAM CPU interface
on new VMs until there is something a guest can do with it.

Clear the MPAM field from the guest's AA64PFR0_EL1 by default, but
allow user-space to set it again if the host supports MPAM. Add a
helper to return the maximum permitted value for an ID register.
For most this is the reset value. To allow the MPAM field to be
written as supported, check if the host sanitised value is '1'
and allow an upgrade from the reset value.

Finally, change the trap handling to inject an undef if MPAM was
not advertised to the guest.

Full support will depend on an psuedo-device being created that
describes the virt->phys PARTID mapping the VMM expects. Migration
would be expected to fail if this psuedo-device can't be created
on the remote end. This ID bit isn't needed to block migration.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 75 +++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 15fb9f54e308..055a72643aed 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -411,21 +411,29 @@ static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool workaround_bad_mpam_abi(struct kvm_vcpu *vcpu,
-				    struct sys_reg_params *p,
-				    const struct sys_reg_desc *r)
+static bool trap_mpam(struct kvm_vcpu *vcpu,
+		      struct sys_reg_params *p,
+		      const struct sys_reg_desc *r)
 {
+	u64 aa64pfr0_el1 = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
+
 	/*
-	 * The ID register can't be removed without breaking migration,
-	 * but MPAMIDR_EL1 can advertise all-zeroes, indicating there are zero
-	 * PARTID/PMG supported by the CPU, allowing the other two trapped
-	 * registers (MPAM1_EL1 and MPAM0_EL1) to be treated as RAZ/WI.
+	 * What did we expose to the guest?
+	 * Earlier guests may have seen the ID bits, which can't be removed
+	 * without breaking migration, but MPAMIDR_EL1 can advertise all-zeroes,
+	 * indicating there are zero PARTID/PMG supported by the CPU, allowing
+	 * the other two trapped registers (MPAM1_EL1 and MPAM0_EL1) to be
+	 * treated as RAZ/WI.
 	 * Emulating MPAM1_EL1 as RAZ/WI means the guest sees the MPAMEN bit
 	 * as clear, and realises MPAM isn't usable on this CPU.
 	 */
-	p->regval = 0;
+	if (FIELD_GET(ID_AA64PFR0_EL1_MPAM_MASK, aa64pfr0_el1)) {
+		p->regval = 0;
+		return true;
+	}
 
-	return true;
+	kvm_inject_undefined(vcpu);
+	return false;
 }
 
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
@@ -1326,6 +1334,36 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 	return arm64_ftr_safe_value(&kvm_ftr, new, cur);
 }
 
+static u64 kvm_arm64_ftr_max(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_desc *rd)
+{
+	u64 pfr0, val = rd->reset(vcpu, rd);
+	u32 field, id = reg_to_encoding(rd);
+
+	/*
+	 * Some values may reset to a lower value than can be supported,
+	 * get the maximum feature value.
+	 */
+	switch (id) {
+	case SYS_ID_AA64PFR0_EL1:
+		pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+		/*
+		 * MPAM resets to 0, but migration of MPAM=1 guests is needed.
+		 * See trap_mpam() for more.
+		 */
+		field = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_MPAM_SHIFT);
+		if (field == ID_AA64PFR0_EL1_MPAM_1) {
+			val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
+			val |= FIELD_PREP(ID_AA64PFR0_EL1_MPAM_MASK, ID_AA64PFR0_EL1_MPAM_1);
+		}
+
+		break;
+	}
+
+	return val;
+}
+
 /*
  * arm64_check_features() - Check if a feature register value constitutes
  * a subset of features indicated by the idreg's KVM sanitised limit.
@@ -1346,8 +1384,7 @@ static int arm64_check_features(struct kvm_vcpu *vcpu,
 	const struct arm64_ftr_bits *ftrp = NULL;
 	u32 id = reg_to_encoding(rd);
 	u64 writable_mask = rd->val;
-	u64 limit = rd->reset(vcpu, rd);
-	u64 mask = 0;
+	u64 limit, mask = 0;
 
 	/*
 	 * Hidden and unallocated ID registers may not have a corresponding
@@ -1361,6 +1398,7 @@ static int arm64_check_features(struct kvm_vcpu *vcpu,
 	if (!ftr_reg)
 		return -EINVAL;
 
+	limit = kvm_arm64_ftr_max(vcpu, rd);
 	ftrp = ftr_reg->ftr_bits;
 
 	for (; ftrp && ftrp->width; ftrp++) {
@@ -1570,6 +1608,14 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 
 	val &= ~ID_AA64PFR0_EL1_AMU_MASK;
 
+	/*
+	 * MPAM is disabled by default as KVM also needs a set of PARTID to
+	 * program the MPAMVPMx_EL2 PARTID remapping registers with. But some
+	 * older kernels let the guest see the ID bit. Turning it on causes
+	 * the registers to be emulated as RAZ/WI. See trap_mpam() for more.
+	 */
+	val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
+
 	return val;
 }
 
@@ -2149,7 +2195,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
 	  .val = ~(ID_AA64PFR0_EL1_AMU |
-		   ID_AA64PFR0_EL1_MPAM |
 		   ID_AA64PFR0_EL1_SVE |
 		   ID_AA64PFR0_EL1_RAS |
 		   ID_AA64PFR0_EL1_GIC |
@@ -2292,11 +2337,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_LOREA_EL1), trap_loregion },
 	{ SYS_DESC(SYS_LORN_EL1), trap_loregion },
 	{ SYS_DESC(SYS_LORC_EL1), trap_loregion },
-	{ SYS_DESC(SYS_MPAMIDR_EL1), workaround_bad_mpam_abi },
+	{ SYS_DESC(SYS_MPAMIDR_EL1), trap_mpam },
 	{ SYS_DESC(SYS_LORID_EL1), trap_loregion },
 
-	{ SYS_DESC(SYS_MPAM1_EL1), workaround_bad_mpam_abi },
-	{ SYS_DESC(SYS_MPAM0_EL1), workaround_bad_mpam_abi },
+	{ SYS_DESC(SYS_MPAM1_EL1), trap_mpam },
+	{ SYS_DESC(SYS_MPAM0_EL1), trap_mpam },
 	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
 	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
-- 
2.39.2

