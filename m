Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACAD411FA7
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764457; cv=none; b=fYk7ppFiFASTx2GLFSAA7cg0H3Es4dUTb6zZeEZyzH+115LFFdHdnoedAJuslQBJYzKriY2xoJupBv/x9uoo2whiNGeY2GhqNoqu6xSDAl+usRL4+ReJV428RWkj1AEChqOmB7locXwwj8ASySnQi1BuKIvc2Fbtl9xQBQndI50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764457; c=relaxed/simple;
	bh=byzrIzXiIto5vqIivIvQsXBpKzK08ekgpobIyjg0Z2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=blpYtB37hOaBZ5z/W72KtaDMqrYxo1269ewk8ANR5OsemVmkYDe5RhYNE33x0E3jZGoDGiglrjN0FHjn8gOyWTDc5o8W1N2XfPElShc6uAXexq9DEiqCbMfGyw1gp3mBLTpBZ5UodIE5ZMTHky3skcRioooLYIujhz6FlmLfPBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hOYxwo/g; arc=none smtp.client-ip=95.215.58.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hOYxwo/g"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=byzrIzXiIto5vqIivIvQsXBpKzK08ekgpobIyjg0Z2w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764451; v=1; x=1789369251;
 b=hOYxwo/g8QE8rVGryq5bPShOg1ua6Rr4sB0uPra1ry0MqY6e0WSSoh+etzatrbIFgwDG6ozq
 sHFO64aNm4/69u1301H5O5v0mhfZdenMiQK47qxjuIMr4+pAotU40Wgcm18XDo/RnwFHG0X6zPi
 kn2yBl2RvSz4jTtwssxd/944=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 24c7a88dbdd550de;
	Mon, 07 Sep 2026 07:00:51 +0000
X-Mizu-Trace-ID: 24c7a88dbdd550de
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 07/17] KVM: arm64: Implement HVC handling for protected guests at EL2
Date: Mon,  7 Sep 2026 07:59:52 +0100
Message-Id: <20260907070002.3333525-8-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend kvm_handle_pvm_hvc64() to handle SMCCC_VERSION,
SMCCC_ARCH_FEATURES and the vendor hypervisor call UID at EL2, so
these queries don't reach the host. ARCH_FEATURES is mandatory from
SMCCC 1.1, the version EL2 reports: it returns SUCCESS for itself and
for SMCCC_VERSION, NOT_SUPPORTED for anything else, and handles the
ARCH_WORKAROUND_1/2/3 queries as the host does, from a copy of the
host's mitigation state taken at init with the sanitised ID registers.
The workaround calls themselves are already handled on hyp entry.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h |  4 ++
 arch/arm64/kvm/arm.c             |  4 ++
 arch/arm64/kvm/hyp/nvhe/pkvm.c   | 70 ++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4974492744cc8..7609c78c68f34 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -10,6 +10,7 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 #include <asm/alternative.h>
+#include <asm/spectre.h>
 #include <asm/sysreg.h>
 
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
@@ -150,6 +151,9 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
+extern enum mitigation_state kvm_nvhe_sym(spectre_v2_state);
+extern enum mitigation_state kvm_nvhe_sym(spectre_v4_state);
+extern enum mitigation_state kvm_nvhe_sym(spectre_bhb_state);
 extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
 extern unsigned long kvm_nvhe_sym(hyp_nr_cpus);
 extern unsigned int kvm_nvhe_sym(hyp_gicv3_nr_lr);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..dbe2b6c9670a9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2622,6 +2622,10 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 
+	kvm_nvhe_sym(spectre_v2_state) = arm64_get_spectre_v2_state();
+	kvm_nvhe_sym(spectre_v4_state) = arm64_get_spectre_v4_state();
+	kvm_nvhe_sym(spectre_bhb_state) = arm64_get_spectre_bhb_state();
+
 	/* Propagate the FGT state to the nVHE side */
 	kvm_nvhe_sym(hfgrtr_masks)  = hfgrtr_masks;
 	kvm_nvhe_sym(hfgwtr_masks)  = hfgwtr_masks;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index af334318d0a03..69f13362b7ab0 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -16,6 +16,11 @@
 #include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
+/* The host's Spectre mitigation state, for SMCCC_ARCH_FEATURES. */
+enum mitigation_state spectre_v2_state;
+enum mitigation_state spectre_v4_state;
+enum mitigation_state spectre_bhb_state;
+
 /* Used by icache_is_aliasing(). */
 unsigned long __icache_flags;
 
@@ -1144,8 +1149,73 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
 	bool handled = true;
+	u32 feature;
+	uuid_t uuid;
 
 	switch (smccc_get_function(vcpu)) {
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		/* Nothing to be handled by the host. Go back to the guest. */
+		val[0] = ARM_SMCCC_VERSION_1_1;
+		val[1] = 0;
+		val[2] = 0;
+		val[3] = 0;
+		break;
+	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+		/* The workaround calls themselves are handled on hyp entry. */
+		val[0] = SMCCC_RET_NOT_SUPPORTED;
+		feature = smccc_get_arg1(vcpu);
+		switch (feature) {
+		case ARM_SMCCC_VERSION_FUNC_ID:
+		case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+			val[0] = SMCCC_RET_SUCCESS;
+			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_1:
+			switch (spectre_v2_state) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				val[0] = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_UNAFFECTED:
+				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				break;
+			}
+			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_2:
+			switch (spectre_v4_state) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				/* With SSBS advertised the guest's default is safe. */
+				if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SSBS, IMP))
+					break;
+				fallthrough;
+			case SPECTRE_UNAFFECTED:
+				val[0] = SMCCC_RET_NOT_REQUIRED;
+				break;
+			}
+			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			switch (spectre_bhb_state) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				val[0] = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_UNAFFECTED:
+				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				break;
+			}
+			break;
+		}
+		break;
+	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
+		uuid = ARM_SMCCC_VENDOR_HYP_UID_KVM;
+		val[0] = smccc_uuid_to_reg(&uuid, 0);
+		val[1] = smccc_uuid_to_reg(&uuid, 1);
+		val[2] = smccc_uuid_to_reg(&uuid, 2);
+		val[3] = smccc_uuid_to_reg(&uuid, 3);
+		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
-- 
2.39.5

