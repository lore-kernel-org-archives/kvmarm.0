Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838BF17E473;
	Wed, 21 Aug 2024 23:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724283390; cv=none; b=SlbX6K/blxnfBzjgPYRl4BXREv4CIvD5ReiEMmMo1hFq3L+ahtGWsxrAMj/ad3nufynMMXsxB6vwn0v7WyaU9m+wr7k63zWB9+G4UDb8Yh++j/iLIlZP5QQtv4e3ztysmVZjzFyHzdZ+MXngf5yLuQnT5ZNO2a1FMpunOg0E2mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724283390; c=relaxed/simple;
	bh=hrfESbx6SkEicUVkwX2/zXlc1PgEJHcuOvyuBXTbqns=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UMjoZxbpgsoHusqsMMszF/rq0CnukecRV5fEVTYLo0sHDtUDsOWGeW3k5HYzPJY38bybgyjdBDMkOO0QjeLEj8L0hX/HZrn2B6jc4tYsfD0nzmRWvHLEc/jeBsNQDMnyXfX4dQXAaDAB0u5FJDgq5M5QD14dNQaf3+wSZQ+tldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtsAA30F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtsAA30F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C51C4AF0E;
	Wed, 21 Aug 2024 23:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724283390;
	bh=hrfESbx6SkEicUVkwX2/zXlc1PgEJHcuOvyuBXTbqns=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RtsAA30Fb5hUcmkl6vaRLL6JfpTZ4oxBv9ZRSOXd9Q/22dLSbo+Ng42w9u7KlSPgK
	 m/2ECNCrgqn11FtjuCQp/vKjU9HoldjRkPIDPMUciS49LPfTCgHR3uDeGheakfSUy2
	 ql6CJA1eLFb383PkuPItxH/mVQs0VkWVb96fPN01ivSXyijmBdJZPWzpz1m/dJJMYI
	 CnkKBGa0YLiBkRscVYruuZtxSmX/nhqFD5n5LRo/hAS0zLmJGp9kE1nReX3MigRnTo
	 EfpXISzVHJ0TrjgHtnWBkK9SHUkUiFYNmETAxjW+1vkVsS3Ea1R5Sp+JEYM9oSPlA5
	 vuyK1M4BGWWpA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 22 Aug 2024 00:35:38 +0100
Subject: [PATCH v2 3/3] KVM: arm64: Hide S1PIE registers from userspace
 when disabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240822-kvm-arm64-hide-pie-regs-v2-3-376624fa829c@kernel.org>
References: <20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org>
In-Reply-To: <20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 20240813144738.2048302-1-maz@kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=3441; i=broonie@kernel.org;
 h=from:subject:message-id; bh=hrfESbx6SkEicUVkwX2/zXlc1PgEJHcuOvyuBXTbqns=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmxnnr4SLnC2qdqcIFy0dcExaXyAtGP2eCtQUx0+0V
 EfdofO+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZsZ56wAKCRAk1otyXVSH0BQhB/
 wJ4EWrWwY5XI4ekGdtftXyjg/WcA3FSzbzlQUBnH4HUM4e6SBk1DSnj8dqLGUKlfkVsDlPmcHbb7pq
 FpE2qX52OUS2mNpxh/iDws1fykHpQPKhnrdS4tT1R3JVWuFvGkoWb8G/4hILabNUqHtHDZlg0z8He7
 qHHBxNg6NpPxX+UXpnLmNm+l1NfO10dYyMWfugIWqlRfS3kYRz1B0Oq/3LaG/nr2YhUj7BiSU3ag7g
 JUtg8XXdJhyphrZ84pedIgNFkvKGBz2Dx5e9xVEXwGQJeh4XqeP4P1oYRObsWm4yiqMD6mf5zDb8TY
 Pmsc5xr/9b+X/oT3azrQU9ueGzH3jF
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When the guest does not support S1PIE we should not allow any access
to the system registers it adds in order to ensure that we do not create
spurious issues with guest migration. Add a visibility operation for these
registers.

Fixes: 86f9de9db178 ("KVM: arm64: Save/restore PIE registers")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7889e5f4009f..fd161d41df52 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1479,4 +1479,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_tcr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
 
+#define kvm_has_s1pie(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6d5f43781042..3824f6d13bf6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2340,6 +2340,27 @@ static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
 	return tcr2_visibility(vcpu, rd);
 }
 
+static unsigned int s1pie_visibility(const struct kvm_vcpu *vcpu,
+				     const struct sys_reg_desc *rd)
+{
+	if (kvm_has_s1pie(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static unsigned int s1pie_el2_visibility(const struct kvm_vcpu *vcpu,
+					 const struct sys_reg_desc *rd)
+{
+	unsigned int r;
+
+	r = el2_visibility(vcpu, rd);
+	if (r)
+		return r;
+
+	return s1pie_visibility(vcpu, rd);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2577,8 +2598,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
-	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1 },
-	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1 },
+	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1,
+	  .visibility = s1pie_visibility },
+	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1,
+	  .visibility = s1pie_visibility },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
 	{ SYS_DESC(SYS_LORSA_EL1), trap_loregion },
@@ -2875,8 +2898,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
-	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
-	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
+	EL2_REG_FILTERED(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0,
+			 s1pie_el2_visibility),
+	EL2_REG_FILTERED(PIR_EL2, check_s1pie_access_rw, reset_val, 0,
+			 s1pie_el2_visibility),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
@@ -4691,7 +4716,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+	if (!kvm_has_s1pie(kvm))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
 

-- 
2.39.2

