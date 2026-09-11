Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C624644064E
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123643; cv=none; b=C/iy75nEzJNa3I/l2mWum2Uv7xHTzMAI6zBl9QHDBWFNG/2fqLv7DP5P4WyFBVo8F8To87L2Gx5cl5txGRJ0/Nz5CcF9GaO/O7hQ138XqAXqb3nT+2AGjbsFAY5GBfvRIknhCQHuNKOH3EEu7/GxyddhzX1uLxU8nVt9L/1s5x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123643; c=relaxed/simple;
	bh=dkhfGV+88SNfWO4ebCENMzleUHxrNuWw9bZFV9PXTVk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rKiS4LKu3eAg0I+kRFoF0gxa7ZuPZGDf0H6aIXz52JrOP2npLRBMyxkSwe1T4pgiiPvrB9cQ7bkR0ckgWy3dvwbec8z6hnZ342J+uicPJtrnDtxokA4nL0+Sm7b2hKJuXHovkrNp+ew2DE1TDFJ8hgiXTCQoO9Rj7jNhkFyDEZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pxdEiFsy; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pxdEiFsy"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dkhfGV+88SNfWO4ebCENMzleUHxrNuWw9bZFV9PXTVk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789123636; v=1; x=1789728436;
 b=pxdEiFsy8vteH70dXcVDd1rLPnmBNZq2NDf1nsaUqTVLPZe8UONUhXfdm0r+RlveLPoQ8FQh
 8+U+B/WlT24hter1ZxQIfpbXsol8lsNjVt/Pzy7pLCaF2yULsUU2ByadXajL77KGE9nn4Dwnkb6
 F3rxP5hJeL7Se31cB+eQZJmo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 363523a64c1086f8;
	Fri, 11 Sep 2026 10:47:16 +0000
X-Mizu-Trace-ID: 363523a64c1086f8
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Gavin Shan <gshan@redhat.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
Date: Fri, 11 Sep 2026 11:47:15 +0100
Message-Id: <20260911104715.307500-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

finalise_el2_state() clears the EL2 MPAM traps whenever the ID
registers advertise MPAM, while KVM sets them only under ARM64_MPAM,
which also requires MPAMEN. Without EL3 nothing sets that enable, so a
guest reaches the MPAM registers while ID_AA64PFR0_EL1.MPAM reads 0
for it.

Gate on what finalise_el2_state() tests instead: this CPU's ID
registers with the arm64.nompam override applied, and its
MPAMIDR_EL1.HAS_HCR before writing MPAMHCR_EL2, which is UNDEFINED
without it. MPAMEN isn't a term in any MPAM accessor, so the traps
take effect without it.

Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v2:
     - A per-CPU flag in kvm_host_data, set at KVM's CPU init from the ID
       registers with the override applied, instead of a third cpucap
       (Will). The probe checks presence only, since MPAM3_EL3.TRAPLOWER
       can't be read at EL2.
     - The MPAMHCR_EL2 branch reads this CPU's MPAMIDR_EL1 rather than the
       sanitised ARM64_MPAM_HCR, which would otherwise have been the one
       system-wide test left in a per-CPU function.
     - Fixes: names the KVM commit that left this case open, rather than
       the head.S commit that cleared the traps.
     - Yuan's Reviewed-by dropped, since the mechanism changed.
    
    v2: https://lore.kernel.org/all/20260908145651.2828597-1-fuad.tabba@linux.dev/
    v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/

 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/kvm/arm.c                    |  7 +++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++++++-----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7a..98ca2d9b9e18d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -755,6 +755,7 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
 #define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
 #define KVM_HOST_DATA_FLAG_HAS_BRBE			6
+#define KVM_HOST_DATA_FLAG_HAS_MPAM			7
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..fde75a63cf045 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2281,9 +2281,16 @@ static void cpu_set_hyp_vector(void)
 
 static void cpu_hyp_init_context(void)
 {
+	u64 pfr0 = __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
+	u64 pfr1 = __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
+
 	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
 	kvm_init_host_debug_data();
 
+	/* The traps take effect without MPAMEN, which ARM64_MPAM requires. */
+	if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1))
+		host_data_set_flag(HAS_MPAM);
+
 	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1ce7130e25490..2cb611e2bd69b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -298,14 +298,17 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 	u64 clr = MPAM2_EL2_EnMPAMSM;
 	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
 
-	if (!system_supports_mpam())
+	if (!host_data_test_flag(HAS_MPAM))
 		return;
 
 	/* trap guest access to MPAMIDR_EL1 */
-	if (system_supports_mpam_hcr()) {
+	if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR) {
 		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
 	} else {
-		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
+		/*
+		 * TIDR is RES0 without MPAMIDR_EL1.HAS_TIDR, which MPAM v1.0
+		 * prohibits: such a PE without HAS_HCR can't trap MPAMIDR_EL1.
+		 */
 		set |= MPAM2_EL2_TIDR;
 	}
 
@@ -317,12 +320,12 @@ static inline void __deactivate_traps_mpam(void)
 	u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
 	u64 set = MPAM2_EL2_EnMPAMSM;
 
-	if (!system_supports_mpam())
+	if (!host_data_test_flag(HAS_MPAM))
 		return;
 
 	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
 
-	if (system_supports_mpam_hcr())
+	if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR)
 		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
 }
 
-- 
2.39.5

