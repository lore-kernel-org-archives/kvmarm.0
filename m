Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1532A145A17
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040053; cv=none; b=Zn3bn7bIYTlx8qTzCKxNzK0Yws3bCPDKgioVNDMHN49WzVmPYnftu/yvWKeUlM2rTUbRTWHCc21mcLbXYa1Z6/7boHk79DLdXYphOAOw7b0tJUerCxM4NZj4nVT8c/AV6MYZXuefpNTvKL7BWVVP7Gl0RVdTOpXGUotf1zntp5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040053; c=relaxed/simple;
	bh=N6YREnUsh6IOOUK4KQtv0Bak6oFcbmyXoae6xQUV4RE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rV9ju41eIc4tic6aUoU8Ri8ytY48FIxU7/Y9jj/iospOrXyxSUIFkGuuh6akGYPwchfVW+Gjf2GxMdOiUjkMx+X7i+XH4PPPd3EYdg+Y9xqe4XQfwAvrwsbt69LZMpewSwIkG0hhexlXizr8vSNFsSx0bGREbjlA8f70+KD1dnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37336339;
	Fri,  4 Oct 2024 04:08:01 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 161CD3F640;
	Fri,  4 Oct 2024 04:07:29 -0700 (PDT)
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
Subject: [PATCH v4 5/7] KVM: arm64: Add a macro for creating filtered sys_reg_descs entries
Date: Fri,  4 Oct 2024 12:07:12 +0100
Message-Id: <20241004110714.2051604-6-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241004110714.2051604-1-joey.gouly@arm.com>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
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

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 54 ++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8b1a6cedc49e..1fd08f12f2bb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1833,6 +1833,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -2131,6 +2137,15 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = 0,				\
 }
 
+/* sys_reg_desc initialiser for cpufeature ID registers that need filtering */
+#define ID_FILTERED(sysreg, name, filtered_fields) {	\
+	ID_DESC(sysreg),				\
+	.set_user = set_##name,				\
+	.visibility = id_visibility,			\
+	.reset = read_sanitised_##name,			\
+	.val = (filtered_fields),			\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
 	ID_DESC(name),				\
@@ -2337,14 +2352,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1),
-	  .access = access_id_reg,
-	  .get_user = get_id_reg,
-	  .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility,
-	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK |
-		 ID_DFR0_EL1_CopDbg_MASK, },
+	ID_FILTERED(ID_DFR0_EL1, id_dfr0_el1,
+		    ID_DFR0_EL1_PerfMon_MASK |
+		    ID_DFR0_EL1_CopDbg_MASK),
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2373,17 +2383,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
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
@@ -2393,13 +2399,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

