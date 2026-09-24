Received: from mta1.migadu.com (out-229.mta1.migadu.com [95.215.58.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E6938424F
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790268817; cv=none; b=UGn3QpLZ7V0hlbSlVh8CiIgwbHB1YT5oqN63CpGUjrGzq3B2+Oj6jd0IiAqN958GaDugpmhvZaC2b3LBJPJDmZ6gU6GFqKnJjStIlGibqd226WdNkBYV+nvN7+5YoUq7Hap2zN3SoJC0pczkevwaAh+/4k+xbu5SUdCuqtviRGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790268817; c=relaxed/simple;
	bh=sTkfV67kIp5uBT8Ri+KeF3tgtgkH8GrCjUJD4r1bRyY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LAacJ1NKI+8fdoOavriu+KmioJHHQxc/Eu++uUJx3+MYrbFhu7+79ddYtN7sxk1hJT+lGxNII+zOJCjwSZdp1zLOLFDyUz9fwJ24NmI2UzkfaWGThcNKekYucQ7ieqc1uJRt+XmDTQefCt144D18aKJftcwZVFI7tOv2QgeAgVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gAwEko12; arc=none smtp.client-ip=95.215.58.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gAwEko12"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sTkfV67kIp5uBT8Ri+KeF3tgtgkH8GrCjUJD4r1bRyY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790268812; v=1; x=1790873612;
 b=gAwEko12ns2zdsqAf3PMpRHTH0wDCwQTvV0XLjMJ/ODZdW8yas/l0ynTWXZ5G1kiK/pF8718
 sLmUN/iDprqBcB0TpWUvHkOK6X6Sfa86I45Qbfg3Eu8i4+WhVexWvEcOMtDOjSVfbmzQU89cbbe
 ZfJejZiH8MIUxZt6rMTQuXmI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6c5f37816937d026;
	Thu, 24 Sep 2026 16:53:32 +0000
X-Mizu-Trace-ID: 6c5f37816937d026
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
Subject: [PATCH v4] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
Date: Thu, 24 Sep 2026 17:53:29 +0100
Message-Id: <20260924165329.1684155-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

finalise_el2_state() clears the EL2 MPAM traps on every CPU whose ID
registers, with the arm64.nompam override applied, advertise MPAM.
KVM sets the traps again on guest entry, but only when the ARM64_MPAM
capability is set, and that capability also requires
MPAM1_EL1.MPAMEN. MPAMEN is writable only at the highest implemented
exception level. Without EL3 that is MPAM2_EL2.MPAMEN, which the
kernel does not set, so ARM64_MPAM is never set either and the traps
stay clear. A guest on such a machine can access MPAM0_EL1,
MPAM1_EL1, MPAMSM_EL1 and MPAMIDR_EL1 while its ID_AA64PFR0_EL1.MPAM
reads 0.

Set the traps under the condition finalise_el2_state() clears them:
record per CPU whether its ID registers, with the override applied,
advertise MPAM, and whether MPAMIDR_EL1.HAS_HCR is set, since
MPAMHCR_EL2 is UNDEFINED without it. MPAMEN does not appear in the
conditions that trap an MPAM register access to EL2, so the traps
take effect whether or not it is set.

Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v3:
     - MPAMIDR_EL1.HAS_HCR probed once at CPU init into a second flag,
       HAS_MPAM_HCR, instead of read on every guest entry and exit (Marc).
     - A comment on why the ID registers are read through
       __read_sysreg_by_encoding() (Marc).
     - Commit message reworded around MPAMEN being writable only at the
       highest implemented exception level (Ben).
     - Ben's Reviewed-by dropped, since the MPAMHCR_EL2 test changed.
    
    Based on Linux 7.3-rc1 (cee9395acd80).
    
    v3: https://lore.kernel.org/all/20260911104715.307500-1-fuad.tabba@linux.dev/
    v2: https://lore.kernel.org/all/20260908145651.2828597-1-fuad.tabba@linux.dev/
    v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/

 arch/arm64/include/asm/kvm_host.h       |  2 ++
 arch/arm64/kvm/arm.c                    | 13 +++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7a..3f5b347093fe8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -755,6 +755,8 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
 #define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
 #define KVM_HOST_DATA_FLAG_HAS_BRBE			6
+#define KVM_HOST_DATA_FLAG_HAS_MPAM			7
+#define KVM_HOST_DATA_FLAG_HAS_MPAM_HCR			8
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..9677d234e17b1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2281,9 +2281,22 @@ static void cpu_set_hyp_vector(void)
 
 static void cpu_hyp_init_context(void)
 {
+	u64 pfr0 = __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
+	u64 pfr1 = __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
+
 	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
 	kvm_init_host_debug_data();
 
+	/*
+	 * The ID registers are read above with the arm64.nompam override
+	 * applied, as finalise_el2_state() reads them.
+	 */
+	if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1)) {
+		host_data_set_flag(HAS_MPAM);
+		if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR)
+			host_data_set_flag(HAS_MPAM_HCR);
+	}
+
 	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1ce7130e25490..c7adf8c206d84 100644
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
+	if (host_data_test_flag(HAS_MPAM_HCR)) {
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
+	if (host_data_test_flag(HAS_MPAM_HCR))
 		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
 }
 

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.39.5

