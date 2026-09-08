Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901BA47C104;
	Tue,  8 Sep 2026 20:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788898672; cv=none; b=oHaBEsqbLf3uHJWO8q5XuYxES4lO8g/2oe0LHRgLwmp3Xa/79lJyf0Q60FrIYKeUKxoQavozxX8xUWTA7hLRloz36+06b4raVKpONyu60QMddp0j2jsyJ8nrYpkD1kabNWPPbwLgsxsDhCVbhFlw28BVUKevAxizRIVuDu7XKvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788898672; c=relaxed/simple;
	bh=qMBkUez8hztn0ks5VgH4TTTqjnIQ9qDmO/pkcIsPwHk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=rCzn9YEBBSbBc157Cq01AOhGs4YNS9n+T2DDHei61lBwCwnfJiIJ9FfDqu7aej5mjRUFJJ7lJnaL09Svzn5MCVPJpT8GvErh0vt0wNJ2Bwunvu4UlNcDBnHEuVSLhNpG6bH7YsUE0kifFC68tTPzzc6INl6Z+vJQqWlkZUinZ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7awn6Fw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7awn6Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8567F1F00A3D;
	Tue,  8 Sep 2026 20:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898671;
	bh=z2KY5C4orcd0mQrMryfM2xss3Kray3gzMwxttwoOE1A=;
	h=From:Date:Subject:To:Cc;
	b=i7awn6FwPRCgiWafJFbk7O6fcN3u+EDxtpKKewpjGlY6uKv8EJ6UC5v0Yu0vOhiHR
	 kfApNqFvjb48p+XJAt5RKj6jh25XA7mIyWN9prfNXPjEykR8ryfv9kRb6piR8aVqWu
	 yBzra1ZP9KayOAK1f1Kyw0cwKv8Fp7PLtulKGyLFhh/Z+KvxcBw/wTwV3h8qn27XEd
	 j4W7VmIvd2lISwYAx981VyO2XMXv5nWMc3sbWJPbrguTkQyvtoJ9Zn/28K92sEwped
	 42XHvzJAVJ/Uy0eYM/c3GZ2MF/+6WlNi0lOXJ/HJuimeR4qfKc8P482d73rp/qme78
	 szFTjOZq+/TKw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 08 Sep 2026 20:40:47 +0100
Subject: [PATCH v2] KVM: arm64: Enable S1PIE for hVHE
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-kvm-arm64-nvhe-pie-v2-1-79e42d28cc08@kernel.org>
X-B4-Tracking: v=1; b=H4sIAL9koGoC/22Nyw6CMBBFf8XM2jGlKZW68j8MCygDjEghLTYaw
 r/LY+vyJPeeM0MgzxTgdprBU+TAg1tBnk9g28I1hFytDFJILTKZYRd7LHyvFbrYEo5MaMtMW5V
 ca0MFrMfRU82fXfrIDw7v8kl22kzbouUwDf67V2Oy7Y6AEepfICYoUJoqNbVUKWl778g7el0G3
 0C+LMsPf2yyaMcAAAA=
X-Change-ID: 20260828-kvm-arm64-nvhe-pie-cb86c417f9ea
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8094; i=broonie@kernel.org;
 h=from:subject:message-id; bh=qMBkUez8hztn0ks5VgH4TTTqjnIQ9qDmO/pkcIsPwHk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqoG1qIUjE01MVMbpNQqYOVjv7gzWO0WTP8Q0Jr
 ijdU+t50rWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaqBtagAKCRAk1otyXVSH
 0FIQB/4oBpL5I3vz0E2YU16VP1u6oqwDritmIZM6Sv2Q6+27GZIFQFPp9ODI8Ohbhgn2WC4TYZb
 sNz18RxKwEjuSgqwuc9UUMtSIMh9rRcNPU4WMVsXrjY+yyPgbWmNYKS8LDIGqQQ9Z+cVmYdK0pf
 J8rP38CEdznSijWJBijVOr9vA/bozwIedki0PhFjdllG79gJWky4m/75Ogbb6dY8qg8ZL5sxp0L
 mXAWUilgcf9l1hWcmwcTlBOR5rQBr6EJN4yyPm44nEuyl38GJVHqLYs59UHF3XmVc89fCjzSK/5
 5TBNfrnXs5toer5S6OTUfwa+VF1GQ3NRG526i3NY52a/w8jM
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When FEAT_S1PIE (stage 1 permission indirection) is supported we
currently enable and use it in the hypervisor when running in VHE mode
but not when running in nVHE or hVHE mode.  While systems with
FEAT_S1PIE would normally use VHE users can configure them for nVHE or
hVHE.  Enable FEAT_S1PIE with hVHE only, hVHE is used for protected VMs
but there is no real use case for nVHE mode on hardware with this
feature.

AP[1] is one of the bits used to encode the indirected permissions.
Since for hVHE this is always 0 we only configure the subset of
indirected permissions that the system is expected to use.

With permission indirection read and write permissions must be encoded
in the bits used by S1PIE, set DBM for writable mappings.  Only do this
when using S1PIE, the hypervisor does not otherwise use DBM so no
existing hypervisor code sets that bit.  Since the meaning is assigned
via S1PIE this does not actually enable DBM, the mappings we configure
just grant write permission.

In order to enable S1PIE we also need to configure TCR2_EL2 which is
currently only done in __finalise_el2 which is VHE only, do so when the
register is present.  When running in nVHE we leave TCR2_EL2.PIE
disabled.  This ensures we have an explicit configuration for TCR2_EL2
when it is present in the system.

For simplicity we unconditionally initialise PIR_EL2 and PIRE0_EL2 if
FEAT_S1PIE is present, this will have no effect in nVHE mode since we
set TCR2_EL2.PIE to 0.

This should have no practical impact other than causing any unexpected
encodings to map to no permissions instead of their default meanings.
It will mean that the configuration is closer to that in VHE mode, and
will be required for future work enabling features like D128 and GCS
which are only available via indirection.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v2:
- Rebase onto v7.3-rc2.
- Don't bother cleaning up TCR2_EL2 on hypervisor exit, and squash the
  handling into the S1PIE patch.
- Remove support for nVHE mode.
- Link to v1: https://patch.msgid.link/20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org
---
 arch/arm64/include/asm/kvm_arm.h     | 19 +++++++++++++++++++
 arch/arm64/include/asm/kvm_asm.h     |  1 +
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kvm/arm.c                 |  8 +++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 16 ++++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c         |  8 ++++++++
 7 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4bfbd827c5aa..eecac91d41e4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -345,4 +345,23 @@
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
+/*
+ * Permission indirection configuration for the hVHE hypervisor when
+ * we have FEAT_S1PIE. Like the host kernel we configure a mapping
+ * mostly equivalent to the non-PIE meanings of the bits so the
+ * page table manipulation code needs minimal updates for PIE.
+ *
+ * These mappings are minimal with only things used from the
+ * hVHE hypervisor, nVHE is not supported.  Write permission is
+ * controlled via DBM.
+ */
+
+#define KVM_HYP_PIR_IDX(uxn, pxn, dbm, ap1) (((uxn) << 3) | ((pxn) << 2) | \
+					     ((dbm) << 1) | (ap1))
+
+#define KVM_HVHE_PIR_EL2 (						\
+	PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(0, 0, 0, 0), PIE_RX)	|	\
+	PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(1, 1, 0, 0), PIE_R)	|	\
+	PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(1, 1, 1, 0), PIE_RW))
+
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69..eb796436d6eb 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -208,6 +208,7 @@ extern void *__vhe_undefined_symbol;
 struct kvm_nvhe_init_params {
 	unsigned long mair_el2;
 	unsigned long tcr_el2;
+	unsigned long tcr2_el2;
 	unsigned long tpidr_el2;
 	unsigned long stack_hyp_va;
 	unsigned long stack_pa;
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..7b1b7ab3e88e 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -93,6 +93,7 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
 
+#define KVM_PTE_LEAF_ATTR_HI_S1_DBM	BIT(51)
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 9c853ed3ceab..baffe58015d6 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -118,6 +118,7 @@ int main(void)
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
   DEFINE(NVHE_INIT_MAIR_EL2,	offsetof(struct kvm_nvhe_init_params, mair_el2));
   DEFINE(NVHE_INIT_TCR_EL2,	offsetof(struct kvm_nvhe_init_params, tcr_el2));
+  DEFINE(NVHE_INIT_TCR2_EL2,	offsetof(struct kvm_nvhe_init_params, tcr2_el2));
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
   DEFINE(NVHE_INIT_STACK_HYP_VA,	offsetof(struct kvm_nvhe_init_params, stack_hyp_va));
   DEFINE(NVHE_INIT_PGD_PA,	offsetof(struct kvm_nvhe_init_params, pgd_pa));
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..607a6f808b1c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2158,7 +2158,7 @@ static int kvm_init_vector_slots(void)
 static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
-	unsigned long tcr;
+	unsigned long tcr, tcr2;
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
@@ -2186,6 +2186,12 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	tcr |= TCR_T0SZ(hyp_va_bits);
 	params->tcr_el2 = tcr;
 
+	tcr2 = 0;
+	if (cpus_have_final_cap(ARM64_HAS_S1PIE) &&
+	    cpus_have_final_cap(ARM64_KVM_HVHE))
+		tcr2 |= TCR2_EL2_PIE;
+	params->tcr2_el2 = tcr2;
+
 	params->pgd_pa = kvm_mmu_get_httbr();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 0b3e0b28dfc7..cd5b75c8776f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -137,8 +137,20 @@ alternative_if ARM64_HAS_CNP
 alternative_else_nop_endif
 	msr	ttbr0_el2, x2
 
-	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
-	msr	tcr_el2, x0
+	ldr	x1, [x0, #NVHE_INIT_TCR_EL2]
+	msr	tcr_el2, x1
+
+alternative_if ARM64_HAS_S1PIE
+	/* S1PIE is only enabled with TCR2_EL2.PIE if we are running hVHE */
+	mov_q	x1, KVM_HVHE_PIR_EL2
+	msr	REG_PIR_EL2, x1
+	msr	REG_PIRE0_EL2, xzr
+alternative_else_nop_endif
+
+alternative_if ARM64_HAS_TCR2
+	ldr	x1, [x0, #NVHE_INIT_TCR2_EL2]
+	msr	REG_TCR2_EL2, x1
+alternative_else_nop_endif
 
 	isb
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..5276c2874fe0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -349,6 +349,14 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 
 		if (system_supports_bti_kernel())
 			attr |= KVM_PTE_LEAF_ATTR_HI_S1_GP;
+	} else if (cpus_have_final_cap(ARM64_HAS_S1PIE) &&
+		   cpus_have_final_cap(ARM64_KVM_HVHE) &&
+		   (prot & KVM_PGTABLE_PROT_W)) {
+		/*
+		 * When using S1PIE for hVHE set DBM for writable
+		 * mappings since AP[2] is ineffective.
+		 */
+		attr |= KVM_PTE_LEAF_ATTR_HI_S1_DBM;
 	}
 
 	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {

---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20260828-kvm-arm64-nvhe-pie-cb86c417f9ea

Best regards,
--  
Mark Brown <broonie@kernel.org>

