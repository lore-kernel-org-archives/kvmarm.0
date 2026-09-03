Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E184CA785
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451654; cv=none; b=mW8n/M7Tin70KQZ5M+akhZkizbqbhT4jafexwVGxtlndMjStiYmMHcMiIGabVhGMqAXKsdzUTx8O/w9cjfojKGud6Sh66m/TM9n2zIkntVszxCButKhhRVe1yyLtjDjhvo9fgAFd3+53n4qSt6gnYl4oMICUyjvHW0ytCu8sHjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451654; c=relaxed/simple;
	bh=PK5crTw8zKz3/t5phMfei5GslsZNl9FLUzgfhq/0CrQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lmkn2i4ccV60/y9W4wTCZVTlXQ3LYpBL7CDtlyz9aY1JDTqgXK+rI7ybqXp0Uo6jhYiIeXfeudcJ/vx+Y8v/4qCi0FtYLhwTaAIEjhC9Sh5NLn98l+xbntXoW4F12+ZzSi7pwlYXgStKf+Wy4lWfIrK6F6itxu1QhOosolLZflw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=u3qR9/qb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="u3qR9/qb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 054C01650;
	Thu,  3 Sep 2026 09:07:26 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2BFF3F673;
	Thu,  3 Sep 2026 09:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451649; bh=PK5crTw8zKz3/t5phMfei5GslsZNl9FLUzgfhq/0CrQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=u3qR9/qbvovkMevqzb6sBLXQI8Eof/hbGj6C9mL1kd1qN6Ej2IIn5eSfIhaPpUtKV
	 I2RWEL3Uu6XJsKhxhFHUE8mSpYiX11J68GShmL5GhjjCIAh82vidPka/99EXDENGsf
	 tp2KRbxAlnx5ONmRLatKxxT4unNZPvXLxfwu7etU=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 26/28] KVM: arm64: Map memory on a SPE stage 2 fault
Date: Thu,  3 Sep 2026 17:06:21 +0100
Message-ID: <20260903160623.315525-27-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure SPE in a guest can make progress even if something goes terribly
wrong in KVM by mapping the memory on stage 2 fault SPE buffer management
event.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/arm.c              |  4 +-
 arch/arm64/kvm/mmu.c              | 53 ++++++++++++++++++
 arch/arm64/kvm/spe.c              | 93 ++++++++++++++++++++++++++++++-
 4 files changed, 148 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 81abfb705aeb..31be131c8486 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1464,6 +1464,8 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val);
 #define kvm_guest_owns_debug_regs(vcpu)		\
 	((vcpu)->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED)
 
+int kvm_map_gpa(struct kvm_vcpu *vcpu, u64 gpa, u8 fsc, bool s1ptw);
+
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 689fa175f5f4..7c7d0616db53 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1421,8 +1421,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_sync_hwstate(vcpu);
 
-		kvm_spe_sync_hwstate(vcpu);
-
 		/*
 		 * Sync the vgic state before syncing the timer state because
 		 * the timer code needs to know if the virtual timer
@@ -1472,6 +1470,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		preempt_enable();
 
+		kvm_spe_sync_hwstate(vcpu);
+
 		/*
 		 * The ARMv8 architecture doesn't give the hypervisor
 		 * a mechanism to prevent a guest from dropping to AArch32 EL0
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..d7e7365c5c5a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2796,3 +2796,56 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+int kvm_map_gpa(struct kvm_vcpu *vcpu, u64 gpa, u8 fsc, bool s1ptw)
+{
+	struct kvm_vcpu_fault_info *fault_info = &vcpu->arch.fault;
+	struct kvm_vcpu_fault_info fault_backup = *fault_info;
+	struct kvm_s2_fault_desc s2fd = {
+		.vcpu		= vcpu,
+		.fault_ipa	= gpa,
+	};
+	struct kvm_memory_slot *memslot;
+	struct kvm *kvm = vcpu->kvm;
+	gfn_t gfn;
+	hva_t hva;
+	int ret;
+
+	lockdep_assert(srcu_read_lock_held(&kvm->srcu));
+
+	if (WARN_ON_ONCE(is_protected_kvm_enabled() || vcpu_has_nv(vcpu)))
+		return -EOPNOTSUPP;
+
+	if (esr_fsc_is_access_flag_fault(fsc)) {
+		handle_access_fault(vcpu, gpa);
+		return 0;
+	}
+
+	gfn = gpa_to_gfn(gpa);
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (!memslot)
+		return -ENOENT;
+	hva = gfn_to_hva_memslot(memslot, gfn);
+	if (kvm_is_error_hva(hva))
+		return -EFAULT;
+
+	s2fd.memslot = memslot;
+	s2fd.hva = hva;
+
+	fault_info->esr_el2 = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_DABT_LOW) |
+			      ESR_ELx_IL | FIELD_PREP(ESR_ELx_FSC, fsc);
+	if (s1ptw)
+		fault_info->esr_el2 |= ESR_ELx_S1PTW;
+	else
+		fault_info->esr_el2 |= ESR_ELx_WNR;
+	fault_info->hpfar_el2 = FIELD_PREP(HPFAR_EL2_FIPA, gpa >> 12);
+
+	if (kvm_slot_has_gmem(memslot))
+		ret = gmem_abort(&s2fd);
+	else
+		ret = user_mem_abort(&s2fd);
+
+	*fault_info = fault_backup;
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index ef138562f939..e5f3d0dea7c5 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -10,6 +10,7 @@
 #include <linux/perf_event.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_spe.h>
 #include <asm/sysreg.h>
 
@@ -242,17 +243,105 @@ static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level)
 		vcpu_spe->irq_level = level;
 }
 
+static bool kvm_spe_should_handle_fault(struct kvm_vcpu *vcpu)
+{
+	u64 pmbsr = vcpu->arch.vcpu_spe.hw_pmbsr_el1;
+	u64 pmbsr_ec = FIELD_GET(PMBSR_EL1_EC, pmbsr);
+
+	if (pmbsr_ec != PMBSR_EL1_EC_FAULT_S2)
+		return false;
+
+	if (FIELD_GET(PMBSR_EL1_EA, pmbsr))
+		return false;
+
+	if (esr_fsc_is_translation_fault(pmbsr) ||
+	    esr_fsc_is_permission_fault(pmbsr) ||
+	    esr_fsc_is_access_flag_fault(pmbsr))
+		return true;
+
+	return false;
+}
+
+static int kvm_spe_read_s1_desc(struct kvm_vcpu *vcpu, u64 gpa, u64 *desc,
+				struct s1_walk_info *wi)
+{
+	u64 pmbsr = vcpu->arch.vcpu_spe.hw_pmbsr_el1;
+	int ret;
+
+	ret = kvm_vcpu_read_s1_desc(vcpu, gpa, desc, wi);
+	if (ret)
+		return ret;
+
+	/* TODO: this should be a hardware capability check */
+	if (kvm_has_feat(vcpu->kvm, ID_AA64DFR2_EL1, SPE_EXC, IMP) &&
+	    !(FIELD_GET(ESR_ELx_S1PTW, pmbsr)))
+		return 0;
+
+	/*
+	 * No choice but to assume that the s2 fault happened on a s1 table
+	 * walk.
+	 */
+	return kvm_map_gpa(vcpu, gpa, FIELD_GET(ESR_ELx_FSC, pmbsr), true);
+}
+
+static int kvm_handle_spe_fault(struct kvm_vcpu *vcpu)
+{
+	struct s1_walk_info wi = {
+		.read_s1_desc	= kvm_spe_read_s1_desc,
+		.regime		= TR_EL10,
+		.as_el0		= false,
+		.pan		= false,
+	};
+	struct s1_walk_result wr = {};
+	u64 pmbptr = __vcpu_sys_reg(vcpu, PMBPTR_EL1);
+	u64 pmbsr = vcpu->arch.vcpu_spe.hw_pmbsr_el1;
+	int ret;
+
+	guard(srcu)(&vcpu->kvm->srcu);
+
+	ret = __kvm_translate_va(vcpu, &wi, &wr, pmbptr);
+	if (ret == -EAGAIN)
+		return 0;
+	if (ret)
+		return ret;
+
+	/* Stage 2 fault on a table walk was handled during the translation. */
+	/* TODO: this should be a hardware capability check */
+	if (kvm_has_feat(vcpu->kvm, ID_AA64DFR2_EL1, SPE_EXC, IMP) &&
+	    FIELD_GET(ESR_ELx_S1PTW, pmbsr))
+		return 0;
+
+	return kvm_map_gpa(vcpu, wr.pa, FIELD_GET(ESR_ELx_FSC, pmbsr), false);
+}
+
 void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+	u64 hw_pmbsr_el1;
+	int ret;
 
 	if (!vcpu_has_spe(vcpu))
 		return;
 
-	if (!FIELD_GET(PMBSR_EL1_S, vcpu_spe->hw_pmbsr_el1))
+	hw_pmbsr_el1 = vcpu_spe->hw_pmbsr_el1;
+	if (!FIELD_GET(PMBSR_EL1_S, hw_pmbsr_el1))
 		return;
 
-	__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, vcpu_spe->hw_pmbsr_el1);
+	if (kvm_spe_should_handle_fault(vcpu)) {
+		pr_debug("SPE stage 2 fault PMBSR_EL1=0x%llx PMBPTR_EL1=0x%llx",
+			 hw_pmbsr_el1, __vcpu_sys_reg(vcpu, PMBPTR_EL1));
+		ret = kvm_handle_spe_fault(vcpu);
+		if (ret)
+			goto reinject;
+		/* Let the guest know about the partial record. */
+		if (FIELD_GET(PMBSR_EL1_DL, hw_pmbsr_el1))
+			goto reinject;
+		vcpu_spe->hw_pmbsr_el1 = 0;
+		return;
+	}
+
+reinject:
+	__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, hw_pmbsr_el1);
 	vcpu_spe->hw_pmbsr_el1 = 0;
 	kvm_spe_update_irq_level(vcpu, true);
 }
-- 
2.43.0

