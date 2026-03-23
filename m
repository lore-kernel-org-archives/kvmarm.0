Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814A93B8959
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283064; cv=none; b=bl2utNl2Z1Dj2U2+oCW3YPDiss3G+ifrICGIDYm1xpiA7kwSLfrPXDxqRKF2vfNslSHk1sAwon+XbAxgxP2rlqAiy6/QBUjoLSD8gW+Nz7p6xo73a9x1Uc57C2WyYrrdv3oWoQuq+lNJTjv2XQHXZTLRF/NAgAnuIeNXa0wh0TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283064; c=relaxed/simple;
	bh=B/WtuJwcNR6/VlYgVeIG7xjV1XFoYIxMLrfxekR66jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNtgrMMC2AMxQJeDbdpC0W2qrmZ46w98mfQ4scXWSvq3+UB1jSavLLD04Qfwnj7GfN3zc1eoXgSqH6jqhmJOCsEiq8TBG8lp3LhOSLRfe0XexA2B6Se8GDgu3bTztQufI/ExE9VPZTQS7uy19PdLSjBRxEEqw6y7z4+/GWMgqxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4D35169E;
	Mon, 23 Mar 2026 09:24:16 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 351623F73B;
	Mon, 23 Mar 2026 09:24:21 -0700 (PDT)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: [PATCH v3 5/5] KVM: arm64: Add SMC hook for SME dvmsync erratum
Date: Mon, 23 Mar 2026 16:24:05 +0000
Message-ID: <20260323162408.4163113-6-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323162408.4163113-1-catalin.marinas@arm.com>
References: <20260323162408.4163113-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

C1-Pro cores with SME have an erratum where TLBI+DSB does not complete
all outstanding SME accesses. Instead a DSB needs to be executed on the
affecteed CPUs. The implication is pages cannot be unmapped from the
host stage2 then provided to the guest. Host SME accesses may occur
after this point.

This erratum breaks pKVM's guarantees, and the workaround is hard to
implement as EL2 and EL1 share a security state meaning EL1 can mask
IPI sent by EL2, leading to interrupt blackouts.

Instead, do this in EL3. This has the advantage of a separate security
state, meaning lower EL cannot mask the IPI. It is also simpler for EL3
to know about CPUs that are off or in PSCI's CPU_SUSPEND.

Add the needed hook.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Sudeep Holla <sudeep.holla@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 17 +++++++++++++++++
 include/linux/arm-smccc.h             |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 38f66a56a766..ef8afbdd421b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -5,6 +5,8 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/arm-smccc.h>
+
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
@@ -28,6 +30,15 @@ static struct hyp_pool host_s2_pool;
 static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
 #define current_vm (*this_cpu_ptr(&__current_vm))
 
+static void pkvm_sme_dvmsync_fw_call(void)
+{
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714)) {
+		struct arm_smccc_res res;
+
+		arm_smccc_1_1_smc(ARM_SMCCC_CPU_WORKAROUND_4193714, &res);
+	}
+}
+
 static void guest_lock_component(struct pkvm_hyp_vm *vm)
 {
 	hyp_spin_lock(&vm->lock);
@@ -553,6 +564,12 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 	if (ret)
 		return ret;
 
+	/*
+	 * After stage2 maintenance has happened, but before the page owner has
+	 * changed.
+	 */
+	pkvm_sme_dvmsync_fw_call();
+
 	/* Don't forget to update the vmemmap tracking for the host */
 	if (owner_id == PKVM_ID_HOST)
 		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 50b47eba7d01..e7195750d21b 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -105,6 +105,12 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x3fff)
 
+/* C1-Pro erratum 4193714: SME DVMSync early acknowledgement */
+#define ARM_SMCCC_CPU_WORKAROUND_4193714				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_CPU, 0x10)
+
 #define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
 			   ARM_SMCCC_SMC_32,				\
