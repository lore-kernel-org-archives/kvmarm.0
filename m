Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ED62BF3D7;
	Thu,  3 Sep 2026 23:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788477392; cv=none; b=h/817D6Z7mZ8leDDjS/OTIXuCBVHEbagiwLuBjJeI3aWp+/ejcNErlF1DnfA9dVL+niJ6m4bWzVeJEvoaw2j8L7ntQt7VQvCYwWq5pkFJQDLO7Ugl6kzqg2qpfg8R7Pv3fUSxi8R58QaZNzk+mf7Z2JgoYnUlm0TEUcrasWk7AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788477392; c=relaxed/simple;
	bh=auU/64QYK97UJ+W8d5NRmp7HuSu6f7a4bUmrsCK67sI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fpw0Xr9rAdcPtEiJDx+OD1kEznRTCqRWrDWOmOa6En5BdkxVFxgpttx3UZfGwko29IGqBpe5LBB1ABbF1KppjjB4q1fdf6Y+0+tcYKxhFhrD8cytaqnk0phNHSPF+NJMpHQrTOOFSJdd9PojNEvhj8J7xjjghhP2auXyVIO856A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0sOiIJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0sOiIJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4961F00ACA;
	Thu,  3 Sep 2026 23:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788477390;
	bh=1eCbjHGbmxY/nyhCGTf6AjBb73myEnvNrgKOPddYfLc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V0sOiIJl+Q4WYRSLBHQQCYXNXd1mkSUq1Ai4YFDLpQQE3qRaBMjwFlDrR1ykfcMPL
	 l9JbcetfjVDOkH8WzBWYL7WaenYjhGj7k2GSD1nYngreBruQfMZya5KbFpxYUr2u+n
	 md+E8+kj1pvQcb8+MF6GqzRy4jvvdwu4Yn3iQPofHPQNhc1N28DLD6ZdAvKx6qMbMY
	 MOF6amkqk+WbsZaZdlRDZ6ZN7PDKyIUT9Y+9XeMz4HMaDblb2z1c/ynkd034bqdQk5
	 JWDw5yxjC7+wPQINwiKJmoTk7ZM69cXbrWi1CVKaKq/+gbVLpmVu/3yxnL0UiHYO3v
	 FQ8b87VLOlpWQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Sep 2026 00:14:42 +0100
Subject: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
In-Reply-To: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6525; i=broonie@kernel.org;
 h=from:subject:message-id; bh=auU/64QYK97UJ+W8d5NRmp7HuSu6f7a4bUmrsCK67sI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqmf/DAb6imbGe0CtFU8o5PlrQ8qR72YyrstXxr
 DOvUqh80kaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapn/wwAKCRAk1otyXVSH
 0BzSB/0Q1kNJ7CX3D5G+qsEnycMEw+tYeFqnMe+/JJknVwiIynh6vJXOlxzCCDRuM7JP/U083UJ
 DckcW4IdjP83iUebosR89QqFikUKBJKJZIIZkRmEyvS22C41pL3QrfYJyDdGa3v1sryhu721Y9c
 aVEYER3PLZP3DEdrjqcg1gwh7Z/UtRkhIzsNAVvoZ4TJf/2hXgOowZtD0EyUhCDoQIqRrBi/OiV
 6Puo+f5NXhCy7X0X+b95v+2RDgx52kiMBgG+t/dvxHRY5YxXr7vJCIB1IopR90StUEZ1bDoma19
 l0PUzRwhKcDalJby8in5HYg0uUE9v9kuP3KG6CR9tNdgHsN2
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When FEAT_S1PIE (stage 1 permission indirection) is supported we
currently enable and use it in the hypervisor when running in VHE mode
but not when running in nVHE or hVHE mode.  While systems with
FEAT_S1PIE would normally use VHE users can configure them for nVHE or
hVHE, for example in order to run protected guests.  Enable FEAT_S1PIE
with nVHE and hVHE.

AP[1] is one of the bits used to encode the indirected permissions.
Since for hVHE this is always 0 and for nVHE it is always 1 we only
configure the subset of indirected permissions that the system is
expected to use.

With permission indirection read only permissions must be encoded in the
bits used by PIE, set DBM for read only mappings.  Only do this when
using S1PIE, the hypervisor does not otherwise use DBM and if we were
actually using DBM it would be for writable mappings.

This should have no practical impact other than causing any unexpected
encodings to map to no permissions instead of their default meanings.
It will mean that the configuration is closer to that in VHE mode, and
will be required for future work enabling features like D128 and GCS
which are only available via indirection.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h     |  1 +
 arch/arm64/include/asm/kvm_pgtable.h | 26 ++++++++++++++++++++++++++
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kvm/arm.c                 |  8 ++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  6 ++++++
 arch/arm64/kvm/hyp/pgtable.c         |  7 +++++++
 6 files changed, 49 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index eb796436d6eb..bc587be33703 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -207,6 +207,7 @@ extern void *__vhe_undefined_symbol;
 
 struct kvm_nvhe_init_params {
 	unsigned long mair_el2;
+	unsigned long pir_el2;
 	unsigned long tcr_el2;
 	unsigned long tcr2_el2;
 	unsigned long tpidr_el2;
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..7c5c87c6745e 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -93,6 +93,7 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
 
+#define KVM_PTE_LEAF_ATTR_HI_S1_DBM	BIT(51)
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
@@ -297,6 +298,31 @@ enum kvm_pgtable_prot {
 #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
 #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
 
+/*
+ * Permission indirection configuration for the nVHE hypervisor when we
+ * have FEAT_S1PIE. Like the host kernel we configure a mapping
+ * equivalent to the non-PIE meanings of the bits so the page table
+ * manipulation code does not need to account for PIE.
+ *
+ * Since nVHE and hVHE fix AP[1] as 1 or 0 respectively we define
+ * separate PIE mappings for each. These mappings are minimal with
+ * only things used from the hypervisor. Write permission is
+ * controlled via DBM.
+ */
+
+#define KVM_HYP_PIR_IDX(uxn, pxn, dbm, ap1) (((uxn) << 3) | ((pxn) << 2) | \
+					     ((dbm) << 1) | (ap1))
+
+#define KVM_NVHE_PIR_EL2        (					\
+       PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(0, 0, 0, 1), PIE_RX)	|	\
+       PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(1, 0, 0, 1), PIE_RW)	|	\
+       PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(1, 0, 1, 1), PIE_R))
+
+#define KVM_HVHE_PIR_EL2        (					\
+       PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(0, 0, 0, 0), PIE_RX)	|	\
+       PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(1, 1, 1, 0), PIE_R)	|	\
+       PIRx_ELx_PERM_PREP(KVM_HYP_PIR_IDX(1, 1, 0, 0), PIE_RW))
+
 typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
 					   enum kvm_pgtable_prot prot);
 
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index baffe58015d6..fab949435aae 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -117,6 +117,7 @@ int main(void)
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
   DEFINE(NVHE_INIT_MAIR_EL2,	offsetof(struct kvm_nvhe_init_params, mair_el2));
+  DEFINE(NVHE_INIT_PIR_EL2,	offsetof(struct kvm_nvhe_init_params, pir_el2));
   DEFINE(NVHE_INIT_TCR_EL2,	offsetof(struct kvm_nvhe_init_params, tcr_el2));
   DEFINE(NVHE_INIT_TCR2_EL2,	offsetof(struct kvm_nvhe_init_params, tcr2_el2));
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 88eb0459ad4b..9232b4581723 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2187,6 +2187,14 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	params->tcr_el2 = tcr;
 
 	tcr2 = 0;
+	if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+		if (cpus_have_final_cap(ARM64_KVM_HVHE))
+			params->pir_el2 = KVM_HVHE_PIR_EL2;
+		else
+			params->pir_el2 = KVM_NVHE_PIR_EL2;
+
+		tcr2 |= TCR2_EL2_PIE;
+	}
 	params->tcr2_el2 = tcr2;
 
 	params->pgd_pa = kvm_mmu_get_httbr();
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index a39de9c20d27..20f926276688 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -140,6 +140,12 @@ alternative_else_nop_endif
 	ldr	x1, [x0, #NVHE_INIT_TCR_EL2]
 	msr	tcr_el2, x1
 
+alternative_if ARM64_HAS_S1PIE
+	ldr	x1, [x0, #NVHE_INIT_PIR_EL2]
+	msr	REG_PIR_EL2, x1
+	msr	REG_PIRE0_EL2, xzr
+alternative_else_nop_endif
+
 alternative_if ARM64_HAS_TCR2
 	ldr	x1, [x0, #NVHE_INIT_TCR2_EL2]
 	msr	REG_TCR2_EL2, x1
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..fd6854913549 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -349,6 +349,13 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 
 		if (system_supports_bti_kernel())
 			attr |= KVM_PTE_LEAF_ATTR_HI_S1_GP;
+	} else if (cpus_have_final_cap(ARM64_HAS_S1PIE) &&
+		   !(prot & KVM_PGTABLE_PROT_W)) {
+		/*
+		 * When using S1PIE for nVHE set DBM for read only
+		 * mappings since AP[2] is ineffective.
+		 */
+		attr |= KVM_PTE_LEAF_ATTR_HI_S1_DBM;
 	}
 
 	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {

-- 
2.47.3

