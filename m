Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B1544A3F9
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451628; cv=none; b=JVEcggR6udDjGgz1cTm0VmU6H2Y00fsmgxrqO3Ll9sOOZP7tw5ITPkeX7PUHf4w0nsPf47jn0scrMafSSaz/1/NeSzbZjvm2P3aTWICSNqDLq3odoLUs3uUuOemGL4TL/1ynFxH7q2nDrwPsDFG4KeWzdpDz2/Pr9aYt3MXddz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451628; c=relaxed/simple;
	bh=S4HD9+Ke4sw7LBfkgVxbyFDReWqLVnICY+GtDEoF53c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foBhlssVq0Z1TuzjBE8jNp0kyrUlyp0VCV4BNbYkc6qAqUhMp9trqXCYnSji7kV2pieLnucJn0hZsdk+D3VdJa6iCqIfA3R6kLoX7sZfalUQXCISZ494rM0rU5UwrkkVT2pxX57DK1lKUMZB5zryrYfppDCENAJ2oScCfuWVUdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vX1U75rc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vX1U75rc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3350C1650;
	Thu,  3 Sep 2026 09:07:03 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AA6D3F673;
	Thu,  3 Sep 2026 09:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451626; bh=S4HD9+Ke4sw7LBfkgVxbyFDReWqLVnICY+GtDEoF53c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vX1U75rckJdFR/4pIMUvvaBctaV+frznxzELmzDhFlAxKmk05ZTO9mE5cci3Ndusm
	 wr1KV0wmC0NHjKHNEwypwBMV0NM1Wa5IUI0nAH90LUZCpO2XpzCl0u9HRpViLiEacp
	 nP4LV6ylOfuSAQfa4oY0cRR3pdNXrSe6gQkakla8=
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
Subject: [RFC PATCH v7 15/28] KVM: arm64: Use PMSVer from the assigned SPE instance
Date: Thu,  3 Sep 2026 17:06:10 +0100
Message-ID: <20260903160623.315525-16-alexandru.elisei@arm.com>
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

KVM allows SPE to be virtualized on heterogeneous system, where hardware
can implement multiple SPE instances for different CPUs, or where SPE
might even be missing on some of the physical CPUs.

KVM resets the VCPU ID registers following a KVM_ARM_VCPU_INIT ioctl.
Using the value for ID_AA64DFR0_EL1.PMSVer on the physical CPU where the
ioctl is executing is unreliable, since userspace might want to later
assign a different SPE instance, with a different PMSVer value. Worse yet,
it is be possible that the VCPU reset is being performed on a physical CPU
without SPE. Be consistent and use PMSVer for the SPE instance assigned to
the VM to initialize ID_AA64DFR0_EL1.PMSVer.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h | 10 ++++++++++
 arch/arm64/kvm/spe.c             | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        |  8 +++++++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index a6999709b298..4bae3e6b05c8 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -29,11 +29,14 @@ bool kvm_supports_spe(void);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 void kvm_spe_destroy_vm(struct kvm *kvm);
 
+void kvm_spe_finalize_idregs(struct kvm *kvm);
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
 bool kvm_spe_pmu_set(struct kvm *kvm);
+u8 kvm_spe_get_pmsver(struct kvm *kvm);
 #else
 struct kvm_spe {
 };
@@ -55,6 +58,9 @@ static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 static inline void kvm_spe_destroy_vm(struct kvm *kvm)
 {
 }
+static inline void kvm_spe_finalize_idregs(struct kvm *kvm)
+{
+}
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	return -ENXIO;
@@ -71,6 +77,10 @@ static inline bool kvm_spe_pmu_set(struct kvm *kvm)
 {
 	return false;
 }
+static inline u8 kvm_spe_get_pmsver(struct kvm *kvm)
+{
+	return 0;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index fa87d224c8af..4426d614a9e0 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -87,6 +87,30 @@ bool kvm_spe_pmu_set(struct kvm *kvm)
 	return !!kvm->arch.kvm_spe.spe_pmu;
 }
 
+void kvm_spe_finalize_idregs(struct kvm *kvm)
+{
+	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;
+	u64 reg;
+
+	if (!spe_pmu)
+		return;
+
+	reg = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
+	reg &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
+	reg |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer, spe_pmu->pmsver);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, reg);
+}
+
+u8 kvm_spe_get_pmsver(struct kvm *kvm)
+{
+	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;
+
+	if (!spe_pmu)
+		return 0;
+
+	return spe_pmu->pmsver;
+}
+
 static int kvm_spe_update_supported_cpus(struct kvm *kvm, cpumask_t *spe_cpus)
 {
 	return kvm_update_supported_cpus(kvm, NULL, spe_cpus);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..a6bb6884b965 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2220,8 +2220,11 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMUVer,
 				      kvm_arm_pmu_get_pmuver_limit());
 
-	/* Hide SPE from guests */
+	/* Only initialize the SPE version if the vCPU has the feature. */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
+	if (vcpu_has_spe(vcpu))
+		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer,
+				      kvm_spe_get_pmsver(vcpu->kvm));
 
 	/* Hide BRBE from guests */
 	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
@@ -5928,6 +5931,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 		kvm_vgic_finalize_idregs(kvm);
 	}
 
+	if (vcpu_has_spe(vcpu))
+		kvm_spe_finalize_idregs(kvm);
+
 	return 0;
 }
 
-- 
2.43.0

