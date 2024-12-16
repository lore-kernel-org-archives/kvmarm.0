Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A724200109;
	Mon, 16 Dec 2024 08:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734339010; cv=none; b=vA0tRrDr37hZSOnOBqMviIC1EBcbPpHn1QRShXofs6/4yyaxsTMZNUd66HnYZn2M/IYZ/L3q5pXWWrO+m6aD7yfHm2msBov08QzAzQpGgqTyKO5rX9fz4Y9Ltg/uJGv5H76nlf18jAC0FCOLoJEzxP/hEDB2UhIIMRH3Z8kBTWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734339010; c=relaxed/simple;
	bh=vdrWJOtTDm+yVnAiy8BwHagv1PFQ6X8i7m4IWpl2rvM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jM+HVij4ICL2wLs4+QiV04lr3oaLW7S9WyVY8dgxQGgS2GijWg5sGPOw+A92lpg6UHhe3cnNaFnwzcvPkT7IU+cBEeDjybrQQN+kYJomPil5FiqTcG5C3ATW4REwO8sxzEa5RgO8xwWJCZklCEqIU8r11odBP4UF/3yzzh/PNC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCFNP+6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCFNP+6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB924C4CED0;
	Mon, 16 Dec 2024 08:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734339009;
	bh=vdrWJOtTDm+yVnAiy8BwHagv1PFQ6X8i7m4IWpl2rvM=;
	h=From:To:Cc:Subject:Date:From;
	b=TCFNP+6bVH8BZFSrXBW35x0yD50E0rrBvNy4an5ihgL/TQ1d9g+tXqFbG9bXxr+9l
	 xZbuhQsmBjWLVWHZCW+4T//ZtRcNLTY3v3FBi6eM+AlUAGGBBPJ/es9ibfFhbDTfiJ
	 fUmtggU/seELb8AaWTVeG1MxySGLvjuDN3bwxCMISQti0Ez4cAoOPzuPHE/WHodJyY
	 8yMMMOk2wQnkLbldA3g6vl12UWzD0VKF7zdkFDIq9fePqFakMYFbdyfc4StLD9zalN
	 983yx7cxnlnsnFfpigx/M+mvusfeg+keOzZJTVfeO5zCTWUdQo0GiqlVG2POXn2NnM
	 BF0w00BMwEv1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tN6nn-0046Jl-Ge;
	Mon, 16 Dec 2024 08:50:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH v6.12] KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
Date: Mon, 16 Dec 2024 08:50:02 +0000
Message-Id: <20241216085002.334880-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.morse@arm.com, gshan@redhat.com, shameerali.kolothum.thodi@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: James Morse <james.morse@arm.com>

commit 6685f5d572c22e1003e7c0d089afe1c64340ab1f upstream.

commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
but didn't add trap handling. A previous patch supplied the missing trap
handling.

Existing VMs that have the MPAM field of ID_AA64PFR0_EL1 set need to
be migratable, but there is little point enabling the MPAM CPU
interface on new VMs until there is something a guest can do with it.

Clear the MPAM field from the guest's ID_AA64PFR0_EL1 and on hardware
that supports MPAM, politely ignore the VMMs attempts to set this bit.

Guests exposed to this bug have the sanitised value of the MPAM field,
so only the correct value needs to be ignored. This means the field
can continue to be used to block migration to incompatible hardware
(between MPAM=1 and MPAM=5), and the VMM can't rely on the field
being ignored.

Signed-off-by: James Morse <james.morse@arm.com>
Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241030160317.2528209-7-joey.gouly@arm.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
[maz: adapted to lack of ID_FILTERED()]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/sys_regs.c | 55 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ff8c4e1b847ed..fbed433283c9b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1535,6 +1535,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTEX);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_DF2);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_PFAR);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
 		/* We only expose FPMR */
@@ -1724,6 +1725,13 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 
 	val &= ~ID_AA64PFR0_EL1_AMU_MASK;
 
+	/*
+	 * MPAM is disabled by default as KVM also needs a set of PARTID to
+	 * program the MPAMVPMx_EL2 PARTID remapping registers with. But some
+	 * older kernels let the guest see the ID bit.
+	 */
+	val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
+
 	return val;
 }
 
@@ -1834,6 +1842,42 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return set_id_reg(vcpu, rd, val);
 }
 
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	u64 mpam_mask = ID_AA64PFR0_EL1_MPAM_MASK;
+
+	/*
+	 * Commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits
+	 * in ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to
+	 * guests, but didn't add trap handling. KVM doesn't support MPAM and
+	 * always returns an UNDEF for these registers. The guest must see 0
+	 * for this field.
+	 *
+	 * But KVM must also accept values from user-space that were provided
+	 * by KVM. On CPUs that support MPAM, permit user-space to write
+	 * the sanitizied value to ID_AA64PFR0_EL1.MPAM, but ignore this field.
+	 */
+	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
+		user_val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
+static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	u64 hw_val = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
+	u64 mpam_mask = ID_AA64PFR1_EL1_MPAM_frac_MASK;
+
+	/* See set_id_aa64pfr0_el1 for comment about MPAM */
+	if ((hw_val & mpam_mask) == (user_val & mpam_mask))
+		user_val &= ~ID_AA64PFR1_EL1_MPAM_frac_MASK;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2377,7 +2421,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
-	  .set_user = set_id_reg,
+	  .set_user = set_id_aa64pfr0_el1,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
 	  .val = ~(ID_AA64PFR0_EL1_AMU |
 		   ID_AA64PFR0_EL1_MPAM |
@@ -2385,7 +2429,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_RAS |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
-	ID_WRITABLE(ID_AA64PFR1_EL1, ~(ID_AA64PFR1_EL1_PFAR |
+	{ SYS_DESC(SYS_ID_AA64PFR1_EL1),
+	  .access	= access_id_reg,
+	  .get_user	= get_id_reg,
+	  .set_user	= set_id_aa64pfr1_el1,
+	  .reset	= kvm_read_sanitised_id_reg,
+	  .val		=	     ~(ID_AA64PFR1_EL1_PFAR |
 				       ID_AA64PFR1_EL1_DF2 |
 				       ID_AA64PFR1_EL1_MTEX |
 				       ID_AA64PFR1_EL1_THE |
@@ -2397,7 +2446,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_RAS_frac |
-				       ID_AA64PFR1_EL1_MTE)),
+				       ID_AA64PFR1_EL1_MTE), },
 	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
-- 
2.39.2

