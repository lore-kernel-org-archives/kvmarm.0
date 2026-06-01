Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279AB3358C4
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 20:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780345499; cv=none; b=qB2PxUFdgcr5yQeuDvQ+2igRebvbfAL1Rdn3hEjMpif6vdYt3RlzMvrrKcz9sJLL5JXMTEV/d8M5lCWSViGyA8ZZyHMktHWrojyq3CPFyue6iRVtVoPFvjCncGbc2O0dnWERjtD/nzRKhzF4h0rhpvOAszmHilx87BNFt3vEZn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780345499; c=relaxed/simple;
	bh=BC3VoBt2yDZ3P68pEMO3J5cw13HevDLbIEPmhV0i7Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lwe0WrY/WW5PajoBL6n2lWjKbkLGZK9EJunO2WnFfhdq3dk1LNhFdnSkZ/kuEUll6eLrvclVxHMMOFIVGOChUAJm/mfJIP2CNBQsof2gLXR8yM5EPFpD6BHgeahAznlIPkNsfmkt+nWyAUhgo3/4+K3/bFJcpX9hn0QF9pNI1tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKHsF67V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKHsF67V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9CC1F00893;
	Mon,  1 Jun 2026 20:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780345497;
	bh=+mPXMpPRLDQZMr1SnqTibajkKlGbQ7R+URnRSnjCVXQ=;
	h=From:To:Cc:Subject:Date;
	b=fKHsF67Va1vsRj1WaRFGmJgrAuxRP4h199LBoQyZkaDm6/0hSuiAZKSG1oWEL9UL7
	 YOiHmkALyPPYBke9fR2XZbwW/PK3q4k/iv3S5wcn+c91CoL7Y+I0Lb0tC+q1+DyPrT
	 m7AN74ptfw2PmT6at1s7pZ5rIqCtRsba+833U1+A/KzXAoMtQx3ecMWL9fUz/Xw9XH
	 AxG3SYFdS6ME5Yw/yRTgYyujdEu/qRy7q93KLNMhuenfoPV9dMEcensqKUgHOTgMre
	 GG5n2xkhw5cx+W8dAkG09q0+uYt73uYEkKI3hkKlVm4Vx9aJ4g1e8qQFEQdhTwGmW1
	 E2uYH0swNFHDg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Congkai Tan <congkai@amazon.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH] KVM: arm64: Drop pointless check for EL0 access to PMINTEN*_EL1
Date: Mon,  1 Jun 2026 13:24:56 -0700
Message-ID: <20260601202456.14513-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PMINTEN*_EL1 registers are UNDEF at EL0, meaning that KVM should
never take a trap from guest EL0. Get rid of the pointless check and
rephrase the vaguely-named helper in terms of PMUSERENR.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea8..51154d8b607c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1070,35 +1070,36 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
+static bool __check_pmuserenr(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
-	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
-	if (!enabled)
-		kvm_inject_undefined(vcpu);
+	/* As the name implies, PMUSERENR_EL0 only applies to accesses from EL0. */
+	if (vcpu_mode_priv(vcpu) || (reg & flags))
+		return false;
 
-	return !enabled;
+	kvm_inject_undefined(vcpu);
+	return true;
 }
 
 static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_EN);
+	return __check_pmuserenr(vcpu, ARMV8_PMU_USERENR_EN);
 }
 
 static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN);
+	return __check_pmuserenr(vcpu, ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN);
 }
 
 static bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN);
+	return __check_pmuserenr(vcpu, ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN);
 }
 
 static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN);
+	return __check_pmuserenr(vcpu, ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN);
 }
 
 static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
@@ -1351,9 +1352,6 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
-	if (check_pmu_access_disabled(vcpu, 0))
-		return false;
-
 	if (p->is_write) {
 		u64 val = p->regval & mask;
 

base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.47.3

