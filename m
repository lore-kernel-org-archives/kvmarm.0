Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF011DC1AB
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136516; cv=none; b=b7WuupbLeuQFtKvdPXOGaauSMFgt9NuGs8D6XKmukTl1Jxad86d39IYqh9Rw0mJVDCuQEH41YhmI2tebUvSaPyzKnkcA9zgueqYf56OoM3/0rHKqt6gQ/tJ3qjyFam21+kBd2wm5BBPeYfNe5XV38jtO5cYBguPyK7GrnFI8eTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136516; c=relaxed/simple;
	bh=ZWFIsLNMFVmMMlc+3POf2YFLYG8U57xa5IziWHDgKH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YriZKGc7aAFJbYJvbEqSW1w1IaafctblziIbb9lfeGsclf0DdYukYSzqQVTVofJoOOd8xhoz/yHRec1eKChkAs4mpIxfUGlTpwbBWpjApuLZUhqtaINaYAYAVaChERpWgO4xiGFY7nsPLAVO627NW2zq1It/ELqH8NkdafLZq2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E2031BCB;
	Fri, 14 Nov 2025 08:08:27 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6A833F5A1;
	Fri, 14 Nov 2025 08:08:32 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 24/35] KVM: arm64: Handle SPE hardware maintenance interrupts
Date: Fri, 14 Nov 2025 16:07:05 +0000
Message-ID: <20251114160717.163230-25-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Re-inject all maintenance interrupts raised by SPE while the guest was
running.

Save the value of the hardware PMBSR_EL1 register in a separate variable,
instead of updating the VCPU sysreg directly, to detect when the SPU
asserted the interrupt, as opposed to the guest writing 1 to the
PMBSR_EL1.S bit.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h |  7 +++++++
 arch/arm64/kvm/arm.c             |  2 ++
 arch/arm64/kvm/hyp/vhe/spe-sr.c  |  2 +-
 arch/arm64/kvm/spe.c             | 27 +++++++++++++++++++++++++++
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index a61c1c1de76f..7d8becf76314 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -17,9 +17,11 @@ struct kvm_spe {
 };
 
 struct kvm_vcpu_spe {
+	u64 hw_pmbsr_el1;	/* Updated on hardware management event */
 	u64 host_pmscr_el2;	/* Host PMSCR_EL2 register, context switched. */
 	int irq_num;		/* Buffer management interrupt number */
 	bool initialized;	/* SPE initialized for the VCPU */
+	bool irq_level;		/* Virtual buffer management interrupt level */
 };
 
 DECLARE_STATIC_KEY_FALSE(kvm_spe_available);
@@ -56,6 +58,8 @@ bool kvm_spe_has_feat_spe_fds(struct kvm *kvm);
 
 void kvm_vcpu_spe_load(struct kvm_vcpu *vcpu);
 void kvm_vcpu_spe_put(struct kvm_vcpu *vcpu);
+
+void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
 #else
 struct kvm_spe {
 };
@@ -111,6 +115,9 @@ static inline void kvm_vcpu_spe_load(struct kvm_vcpu *vcpu)
 static inline void kvm_vcpu_spe_put(struct kvm_vcpu *vcpu)
 {
 }
+static inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c5f5d5dbd695..a2c97daece24 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1272,6 +1272,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_sync_hwstate(vcpu);
 
+		kvm_spe_sync_hwstate(vcpu);
+
 		/*
 		 * Sync the vgic state before syncing the timer state because
 		 * the timer code needs to know if the virtual timer
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
index fb8614435069..0fb625eadfa1 100644
--- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -75,6 +75,6 @@ void __kvm_spe_save_guest_buffer(struct kvm_vcpu *vcpu, struct kvm_cpu_context *
 	write_sysreg_s(0, SYS_PMBSR_EL1);
 	isb();
 	/* PMBSR_EL1 changed while the VCPU was running, save it */
-	ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = pmbsr_el1;
+	vcpu->arch.vcpu_spe.hw_pmbsr_el1 = pmbsr_el1;
 }
 NOKPROBE_SYMBOL(__kvm_spe_save_guest_buffer);
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 85a1ac8bb57f..d163ddfdd8e2 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -178,6 +178,33 @@ u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding)
 	return val;
 }
 
+static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level)
+{
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+	int ret;
+
+	if (vcpu_spe->irq_level == level)
+		return;
+
+	vcpu_spe->irq_level = level;
+	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu, vcpu_spe->irq_num, level, vcpu_spe);
+	WARN_ONCE(ret, "kvm_vgic_inject_irq");
+}
+
+void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+
+	if (!vcpu_has_spe(vcpu))
+		return;
+
+	if (FIELD_GET(PMBSR_EL1_S, vcpu_spe->hw_pmbsr_el1)) {
+		__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, vcpu_spe->hw_pmbsr_el1);
+		vcpu_spe->hw_pmbsr_el1 = 0;
+		kvm_spe_update_irq_level(vcpu, true);
+	}
+}
+
 static void kvm_spe_save_sampling_regs(struct kvm_vcpu *vcpu, struct kvm_cpu_context *ctxt)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.51.2

