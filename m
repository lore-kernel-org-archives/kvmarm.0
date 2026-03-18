Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6AF28850E
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 19:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861572; cv=none; b=QYIKftp+eX1a2+e6B3Sma+HUVfJZymhdBVisEE/KwAIWx55OsiKhPi3ioFVFpfexVfl90E7NstdpE/C+yh+/BZ7m0u9GQc7UqsCmN98nuA0YzGj5aGFn+2PpLxcqX8/JfRDd2+dTJvgySjzw4ZNv89J4e0cpQHm6XzY5VO9pzew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861572; c=relaxed/simple;
	bh=c2RyoPOP7+nW41YbNgwMjgHcwLGT2OO2tBTtqwfwBok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itxUuSyWfQq6fCYzD45yieJ+fZ4EIOcs+sgop9Jsz8NKRdI4MoVrJJUasKAadMMfFpopJ1BYthwOlh4uslxyOsaofmbCpqB57oY02KKNXrD8JN/WmyIIVINL/2O3jbIzHp7cPegdB5j1b75DMLy70rFR+0ycFlCLdw/z2ZeMPfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A6011BF7;
	Wed, 18 Mar 2026 12:19:23 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02E5F3F73B;
	Wed, 18 Mar 2026 12:19:27 -0700 (PDT)
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
Subject: [PATCH v2 4/4] KVM: arm64: Add SMC hook for SME dvmsync erratum
Date: Wed, 18 Mar 2026 19:19:16 +0000
Message-ID: <20260318191918.2653160-5-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318191918.2653160-1-catalin.marinas@arm.com>
References: <20260318191918.2653160-1-catalin.marinas@arm.com>
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
 include/linux/arm-smccc.h             |  5 +++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 38f66a56a766..b0afbb488d4d 100644
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
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC)) {
+		struct arm_smccc_res res;
+
+		arm_smccc_1_1_smc(ARM_SMCCC_CPU_SME_DVMSYNC_WORKAROUND, &res);
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
index 50b47eba7d01..3489db78b0bd 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -105,6 +105,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x3fff)
 
+#define ARM_SMCCC_CPU_SME_DVMSYNC_WORKAROUND				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_CPU, 0x10)
+
 #define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
 			   ARM_SMCCC_SMC_32,				\
