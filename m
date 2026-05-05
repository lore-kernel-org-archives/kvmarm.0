Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33F6481FB7
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 16:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777999936; cv=none; b=MiSC8BKDEt9cKHG5o92t46wSwSaYot048Nn9fYSFkCmvvB1gC/3NP5Ocd3eMO8zg/4W/wie0RIQP+LhqOMBo0MZic9M2dljaUV9e88l5rGQ6OXC506MnE3W0orhD9NnZRz5arn0ScV6h6HdOku9YJcxe1fBwe96/C2vW6zgknhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777999936; c=relaxed/simple;
	bh=b41gOPJccKQ2XvbpWLLXPCndsyCfjOA3lCPUVfPm2mI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mvZ72ECDqoZJBMMXswWtcXf73ucNnk6aeIcnDWEdxfC4MVTdQDpQQ60O9AM03N/e+Qu7NZQ44MQqF3SeFaWwLf+X93+Q6JN8vhWc5D7s4xjYUVWHnHIMJoIhncy+objMCVf6RqvC0PViJDguUel5+Gr99ZftHFXXez2EoHUfYvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S6yw9DOm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S6yw9DOm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5601D1570;
	Tue,  5 May 2026 09:52:07 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B7AC3F763;
	Tue,  5 May 2026 09:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777999932; bh=b41gOPJccKQ2XvbpWLLXPCndsyCfjOA3lCPUVfPm2mI=;
	h=From:To:Cc:Subject:Date:From;
	b=S6yw9DOmzdueBNvorKPjTsX0M/vMrXpTFi8rsiwAzsCsRv471MIU1YhaLzz1aPNOn
	 tUAzNpQPHA9uBcTTGSeEAneh0JRFbl6QVGDwXl/BeCeoJuN6MXGPtYBCrTmngw9BeR
	 fokHN2uwjl1mvanoD30OsTFQ3jBPluvzyL6ZjcOU=
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: [PATCH v2] KVM: arm64: Work around C1-Pro erratum 4193714 for protected guests
Date: Tue,  5 May 2026 17:52:03 +0100
Message-ID: <20260505165205.2690919-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
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
affected CPUs. The implication is that pages cannot be unmapped from the
host Stage 2 and then provided to a protected guest or to the
hypervisor. Host SME accesses may still complete after this point.

This erratum breaks pKVM's guarantees, and the workaround is hard to
implement as EL2 and EL1 share a security state meaning EL1 can mask
IPIs sent by EL2, leading to interrupt blackouts.

Instead, do this in EL3. This has the advantage of a separate security
state, meaning lower EL cannot mask the IPI. It is also simpler for EL3
to know about CPUs that are off or in PSCI's CPU_SUSPEND.

Add the needed hook to host_stage2_set_owner_metadata_locked(). This
covers the cases where the host loses access to a page:

  __pkvm_host_donate_guest()
  __pkvm_guest_unshare_host()
  host_stage2_set_owner_locked() when owner_id == PKVM_ID_HYP

Since pKVM relies on the firmware call for correctness, check for the
firmware counterpart during protected KVM initialisation and fail the
pKVM initialisation if it is missing.

Signed-off-by: James Morse <james.morse@arm.com>
Co-developed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Sudeep Holla <sudeep.holla@kernel.org>
---

Added the kvm-arm list this time, missed it in v1.

Changelog below but it's only probing if the firmware counterpart is
present and disable the hypervisor. If that's too harsh, we can leave it
as a warning and maybe add a static label/flag to avoid the unnecessary
SMC call on page donation.

Changes:

v2:

(v1: https://lore.kernel.org/r/20260430155911.628402-1-catalin.marinas@arm.com)

- Add a check in init_hyp_mode() if KVM is running in protected mode and
  refuse initialising the hypervisor if the firmware does not provide
  the workaround counterpart
- Add 'Co-developed-by: me'

v1:

(pre-7.1-rc: https://lore.kernel.org/r/20260323162408.4163113-6-catalin.marinas@arm.com)

- Move the hook to host_stage2_set_owner_metadata_locked()
- Use hyp_smccc_1_1_smc()

 arch/arm64/kvm/arm.c                  | 21 +++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 24 +++++++++++++++++++++++-
 include/linux/arm-smccc.h             |  6 ++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 176cbe8baad3..51b6db45a54f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -4,6 +4,7 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/bug.h>
 #include <linux/cpu_pm.h>
 #include <linux/errno.h>
@@ -2634,6 +2635,22 @@ static int init_pkvm_host_sve_state(void)
 	return 0;
 }
 
+static int pkvm_check_sme_dvmsync_fw_call(void)
+{
+	struct arm_smccc_res res;
+
+	if (!cpus_have_final_cap(ARM64_WORKAROUND_4193714))
+		return 0;
+
+	arm_smccc_1_1_smc(ARM_SMCCC_CPU_WORKAROUND_4193714, &res);
+	if (res.a0) {
+		kvm_err("pKVM requires firmware support for C1-Pro erratum 4193714\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 /*
  * Finalizes the initialization of hyp mode, once everything else is initialized
  * and the initialziation process cannot fail.
@@ -2834,6 +2851,10 @@ static int __init init_hyp_mode(void)
 		if (err)
 			goto out_err;
 
+		err = pkvm_check_sme_dvmsync_fw_call();
+		if (err)
+			goto out_err;
+
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 28a471d1927c..7d59faa99fee 100644
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
@@ -14,6 +16,7 @@
 
 #include <hyp/fault.h>
 
+#include <nvhe/arm-smccc.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
@@ -29,6 +32,19 @@ static struct hyp_pool host_s2_pool;
 static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
 #define current_vm (*this_cpu_ptr(&__current_vm))
 
+static void pkvm_sme_dvmsync_fw_call(void)
+{
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714)) {
+		struct arm_smccc_res res;
+
+		/*
+		 * Ignore the return value. Probing for the workaround
+		 * availability took place in init_hyp_mode().
+		 */
+		hyp_smccc_1_1_smc(ARM_SMCCC_CPU_WORKAROUND_4193714, &res);
+	}
+}
+
 static void guest_lock_component(struct pkvm_hyp_vm *vm)
 {
 	hyp_spin_lock(&vm->lock);
@@ -574,8 +590,14 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
 	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
 			      addr, size, &host_s2_pool,
 			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
-	if (!ret)
+	if (!ret) {
+		/*
+		 * After stage2 maintenance has happened, but before the page
+		 * owner has changed.
+		 */
+		pkvm_sme_dvmsync_fw_call();
 		__host_update_page_state(addr, size, PKVM_NOPAGE);
+	}
 
 	return ret;
 }
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
