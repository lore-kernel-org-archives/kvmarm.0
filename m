Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B068D1AF0AB
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999584; cv=none; b=bU0UTPyfoIxPcu6XdMeknJ8H0F/TvwD+BtSiPwHazRn5a+zN+gzj+73qbBbfyU6+iu+LvzpNM/G/WEqnWf1aYeRHq6wmnMNVp1hPuZQBUvyRcv9ZgZYm0agh0LTfmnvRIeZNEbkCENvaT4PTctEgtTClxyNeWAtqRTNRm9e1+1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999584; c=relaxed/simple;
	bh=Ulp8aBZ2nqbpB/kFpZ4O3UJVrihfjJdnYi+9Bc1GL7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KvED8g+u16p3NMtQy931Vq+lbRSDicLy0LiuIwjRF6Wn/CwBacEiPrV7o7fXEQzZOFW74RCfHRnhUH4W1A2CZhHQQ/acF6kKs5zPvOLM+Qnk6rVoNCVHxvN7LsfXVel/1X9hhLvli/smK8iVX57htDSTEkpbXc8kHX//PRXoU00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C10DCFEC;
	Tue, 15 Oct 2024 06:40:11 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4468D3F51B;
	Tue, 15 Oct 2024 06:39:40 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 5/7] KVM: arm64: Add a macro for creating filtered sys_reg_descs entries
Date: Tue, 15 Oct 2024 14:39:21 +0100
Message-Id: <20241015133923.3910916-6-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241015133923.3910916-1-joey.gouly@arm.com>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

The sys_reg_descs array holds function pointers and reset value for
managing the user-space and guest view of system registers. These
are mostly created by a set of macro's as only some combinations
of behaviour are needed.

If a register needs special treatment, its sys_reg_descs entry is
open-coded. This is true of some id registers where the value provided
by user-space is validated by some helpers.

Before adding another one of these, add a helper that covers the
existing special cases. 'ID_FILTERED' expects helpers to set the
user-space value, and retrieve the modified reset value.

Like ID_WRITABLE() this uses id_visibility(), which should have no functional
change for the registers converted to use ID_FILTERED().

read_sanitised_id_aa64dfr0_el1() and read_sanitised_id_aa64pfr0_el1() have been
refactored to be called kvm_read_sanitised_id_reg(), to try be consistent with
ID_WRITABLE().

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 62 +++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c21840042785..2e859f566b63 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1509,6 +1509,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
+static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 				       const struct sys_reg_desc *r)
@@ -1522,6 +1525,12 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 	val = read_sanitised_ftr_reg(id);
 
 	switch (id) {
+	case SYS_ID_AA64DFR0_EL1:
+		val = sanitise_id_aa64dfr0_el1(vcpu, val);
+		break;
+	case SYS_ID_AA64PFR0_EL1:
+		val = sanitise_id_aa64pfr0_el1(vcpu, val);
+		break;
 	case SYS_ID_AA64PFR1_EL1:
 		if (!kvm_has_mte(vcpu->kvm))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
@@ -1683,11 +1692,8 @@ static unsigned int fp8_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-					  const struct sys_reg_desc *rd)
+static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
-
 	if (!vcpu_has_sve(vcpu))
 		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
 
@@ -1728,11 +1734,8 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	(val);								       \
 })
 
-static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
-					  const struct sys_reg_desc *rd)
+static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-
 	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
 	/*
@@ -1825,6 +1828,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, val);
 }
 
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 val)
+{
+	return set_id_reg(vcpu, rd, val);
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2141,6 +2150,15 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = mask,				\
 }
 
+/* sys_reg_desc initialiser for cpufeature ID registers that need filtering */
+#define ID_FILTERED(sysreg, name, mask) {	\
+	ID_DESC(sysreg),				\
+	.set_user = set_##name,				\
+	.visibility = id_visibility,			\
+	.reset = kvm_read_sanitised_id_reg,		\
+	.val = (mask),					\
+}
+
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
@@ -2365,17 +2383,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
-	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ~(ID_AA64PFR0_EL1_AMU |
-		   ID_AA64PFR0_EL1_MPAM |
-		   ID_AA64PFR0_EL1_SVE |
-		   ID_AA64PFR0_EL1_RAS |
-		   ID_AA64PFR0_EL1_AdvSIMD |
-		   ID_AA64PFR0_EL1_FP), },
+	ID_FILTERED(ID_AA64PFR0_EL1, id_aa64pfr0_el1,
+		    ~(ID_AA64PFR0_EL1_AMU |
+		      ID_AA64PFR0_EL1_MPAM |
+		      ID_AA64PFR0_EL1_SVE |
+		      ID_AA64PFR0_EL1_RAS |
+		      ID_AA64PFR0_EL1_AdvSIMD |
+		      ID_AA64PFR0_EL1_FP)),
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
 	ID_UNALLOCATED(4,3),
@@ -2385,13 +2399,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_aa64dfr0_el1,
-	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
-		 ID_AA64DFR0_EL1_DebugVer_MASK, },
+	ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1,
+		    ID_AA64DFR0_EL1_PMUVer_MASK |
+		    ID_AA64DFR0_EL1_DebugVer_MASK),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.25.1

