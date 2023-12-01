Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19C16FC4
	for <kvmarm@lists.linux.dev>; Fri,  1 Dec 2023 05:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 792131042;
	Thu, 30 Nov 2023 21:40:37 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.41.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 67C4B3F73F;
	Thu, 30 Nov 2023 21:39:45 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Clark <james.clark@arm.com>,
	Rob Herring <robh@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Suzuki Poulose <suzuki.poulose@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-perf-users@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH V15 5/8] KVM: arm64: nvhe: Disable branch generation in nVHE guests
Date: Fri,  1 Dec 2023 11:09:03 +0530
Message-Id: <20231201053906.1261704-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231201053906.1261704-1-anshuman.khandual@arm.com>
References: <20231201053906.1261704-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Disable the BRBE before we enter the guest, saving the status and enable it
back once we get out of the guest. This is just to avoid capturing records
in the guest kernel/userspace, which would be confusing the samples.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V15:

- Dropped runtime BRBE enable for setting DEBUG_STATE_SAVE_BRBE
- Dropped BRBFCR_EL1 from __debug_save_brbe()/__debug_restore_brbe()
- Always save the live SYS_BRBCR_EL1 in host context and then check if
  BRBE was enabled before resetting SYS_BRBCR_EL1 for the host

 arch/arm64/include/asm/kvm_host.h  |  4 ++++
 arch/arm64/kvm/debug.c             |  5 +++++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 33 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 68421c74283a..1faa0430d8dd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -449,6 +449,8 @@ enum vcpu_sysreg {
 	CNTHV_CVAL_EL2,
 	PMSCR_EL1,	/* Statistical profiling extension */
 	TRFCR_EL1,	/* Self-hosted trace filters */
+	BRBCR_EL1,	/* Branch Record Buffer Control Register */
+	BRBFCR_EL1,	/* Branch Record Buffer Function Control Register */
 
 	NR_SYS_REGS	/* Nothing after this line! */
 };
@@ -753,6 +755,8 @@ struct kvm_vcpu_arch {
 #define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
 /* Save trace filter controls */
 #define DEBUG_STATE_SAVE_TRFCR	__vcpu_single_flag(iflags, BIT(8))
+/* Save BRBE context if active  */
+#define DEBUG_STATE_SAVE_BRBE	__vcpu_single_flag(iflags, BIT(9))
 
 /* SVE enabled for host EL0 */
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 2ab41b954512..fa46a70a9503 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -354,6 +354,10 @@ void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
 		    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
 			vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
 	}
+
+	/* Check if we have BRBE implemented and available at the host */
+	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT))
+		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_BRBE);
 }
 
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
@@ -361,6 +365,7 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
 	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRFCR);
+	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_BRBE);
 }
 
 void kvm_etm_set_guest_trfcr(u64 trfcr_guest)
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 6174f710948e..1994fc48b57c 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -93,6 +93,33 @@ static void __debug_restore_trace(struct kvm_cpu_context *host_ctxt,
 		write_sysreg_s(ctxt_sys_reg(host_ctxt, TRFCR_EL1), SYS_TRFCR_EL1);
 }
 
+static void __debug_save_brbe(struct kvm_cpu_context *host_ctxt)
+{
+	ctxt_sys_reg(host_ctxt, BRBCR_EL1) = read_sysreg_s(SYS_BRBCR_EL1);
+
+	/* Check if the BRBE is enabled */
+	if (!(ctxt_sys_reg(host_ctxt, BRBCR_EL1) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
+		return;
+
+	/*
+	 * Prohibit branch record generation while we are in guest.
+	 * Since access to BRBCR_EL1 is trapped, the guest can't
+	 * modify the filtering set by the host.
+	 */
+	write_sysreg_s(0, SYS_BRBCR_EL1);
+	isb();
+}
+
+static void __debug_restore_brbe(struct kvm_cpu_context *host_ctxt)
+{
+	if (!ctxt_sys_reg(host_ctxt, BRBCR_EL1))
+		return;
+
+	/* Restore BRBE controls */
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, BRBCR_EL1), SYS_BRBCR_EL1);
+	isb();
+}
+
 void __debug_save_host_buffers_nvhe(struct kvm_cpu_context *host_ctxt,
 				    struct kvm_cpu_context *guest_ctxt)
 {
@@ -102,6 +129,10 @@ void __debug_save_host_buffers_nvhe(struct kvm_cpu_context *host_ctxt,
 
 	if (vcpu_get_flag(host_ctxt->__hyp_running_vcpu, DEBUG_STATE_SAVE_TRFCR))
 		__debug_save_trace(host_ctxt, guest_ctxt);
+
+	/* Disable BRBE branch records */
+	if (vcpu_get_flag(host_ctxt->__hyp_running_vcpu, DEBUG_STATE_SAVE_BRBE))
+		__debug_save_brbe(host_ctxt);
 }
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -116,6 +147,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_cpu_context *host_ctxt,
 		__debug_restore_spe(host_ctxt);
 	if (vcpu_get_flag(host_ctxt->__hyp_running_vcpu, DEBUG_STATE_SAVE_TRFCR))
 		__debug_restore_trace(host_ctxt, guest_ctxt);
+	if (vcpu_get_flag(host_ctxt->__hyp_running_vcpu, DEBUG_STATE_SAVE_BRBE))
+		__debug_restore_brbe(host_ctxt);
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
-- 
2.25.1

