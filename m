Received: from mta1.migadu.com (out-49.mta1.migadu.com [95.215.58.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391D051C328
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863128; cv=none; b=a1sKpx+YD9L7xDn5LyBfyFR31f/LmeIKrs/szpgTdy3LSWPgrxYp0wNwUUB3IjoTJwqQoyRJDjK22vyOUKIAo8r49gC8j9aoJSapDjzdvx4KoFyYbPGfauCBLzqxF8p7Upj3xi5NNiTJSVefjYT5fH8PIOymCa//vGwU+jf/DE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863128; c=relaxed/simple;
	bh=XWE8MuJsJ9e7UfacDyXUgTl5aLh076wgSHsAAG8fiBg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nUc8Lo4DZpiKrNpQljff4KMOQYprHTUU/Wz7r/DCb0OfbL0HnUvxzQOeV7A4hcVhCPN3aH+lVMM3SGrJES8jzK7OWqL/iBHwIdcz0FYmNGnL8Y1zGjO9J1qdp3aEQUxcUvxBAk4BzGSNeXyO/2zVavlkqsaqojHFmqqZUW7bY9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wO0132zn; arc=none smtp.client-ip=95.215.58.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wO0132zn"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XWE8MuJsJ9e7UfacDyXUgTl5aLh076wgSHsAAG8fiBg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863124; v=1; x=1791467924;
 b=wO0132znEVl5PGgdLJy3DxeQ2O499Gl6s0UmmcpDneo+O89+r0XHteavdzOR3o9DpxZFJfHP
 watxgdiT0MJPu93WtW2CDJMUnw4ggGhEKkceZI6ZKTimows8Fla+4N4vMRIVaUpVXDOPgriUL46
 iVJ0FKERa86+730zKOin9gPU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 87ed9d2d75c0e355;
	Thu, 01 Oct 2026 13:58:44 +0000
X-Mizu-Trace-ID: 87ed9d2d75c0e355
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 11/18] KVM: arm64: Restrict KVM_ARM_VCPU_INIT and PSCI version for protected VMs
Date: Thu,  1 Oct 2026 14:57:04 +0100
Message-Id: <20261001135711.1640520-12-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 masks a protected VM's vCPU features down to the set pKVM allows,
so a KVM_ARM_VCPU_INIT that requests more succeeds and produces a
guest without them. Reject such an init with -EINVAL. The host and
EL2 both take the allowed set from kvm_pkvm_vcpu_allowed_features().

EL2 returns 1.1 for a protected guest's PSCI_VERSION whatever the
host is configured for, and forwards the platform calls to the host.
Require KVM_ARM_VCPU_PSCI_0_2: without it the host dispatches the
forwarded calls as PSCI 0.1. Reject a KVM_REG_ARM_PSCI_VERSION write
below 1.1: below it the host rejects the SYSTEM_RESET2 that EL2
advertises.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/arm.c              | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 17 ++---------------
 arch/arm64/kvm/hypercalls.c       |  7 +++++++
 4 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index beea00e693a0a..fbea052fa3e16 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -53,6 +53,30 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	}
 }
 
+/*
+ * The vCPU features a protected VM may use: checked by the host at
+ * KVM_ARM_VCPU_INIT, applied by EL2 when the hyp VM is created.
+ */
+static inline void kvm_pkvm_vcpu_allowed_features(struct kvm *kvm,
+						  unsigned long *allowed)
+{
+	bitmap_zero(allowed, KVM_VCPU_MAX_FEATURES);
+
+	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed);
+
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PMU_V3))
+		set_bit(KVM_ARM_VCPU_PMU_V3, allowed);
+
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS))
+		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed);
+
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
+		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed);
+
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE))
+		set_bit(KVM_ARM_VCPU_SVE, allowed);
+}
+
 /*
  * Check whether the KVM VM IOCTL is allowed in pKVM.
  *
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cceeeee266902..ca6e109b3e5d6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1620,6 +1620,19 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (features & ~system_supported_vcpu_features())
 		return -EINVAL;
 
+	/* Reject features EL2 would drop when it creates the hyp VM. */
+	if (vcpu_is_protected(vcpu)) {
+		DECLARE_BITMAP(allowed, KVM_VCPU_MAX_FEATURES);
+
+		kvm_pkvm_vcpu_allowed_features(vcpu->kvm, allowed);
+		if (!bitmap_subset(&features, allowed, KVM_VCPU_MAX_FEATURES))
+			return -EINVAL;
+
+		/* EL2 implements PSCI 1.1; the host must not dispatch as 0.1. */
+		if (!test_bit(KVM_ARM_VCPU_PSCI_0_2, &features))
+			return -EINVAL;
+	}
+
 	/*
 	 * For now make sure that both address/generic pointer authentication
 	 * features are requested by the userspace together.
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index dcc1db6201f14..696f999996b13 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -410,23 +410,10 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE))
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
 
-	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
+	kvm_pkvm_vcpu_allowed_features(kvm, allowed_features);
 
-	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PMU_V3))
-		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS))
-		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
-		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE)) {
-		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE))
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
-	}
 
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b11b8821c9fbc..e43ed13c82bec 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -580,6 +580,13 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		wants_02 = vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2);
 
+		/*
+		 * EL2 advertises PSCI 1.1; the host handles the forwarded calls
+		 * by this version.
+		 */
+		if (vcpu_is_protected(vcpu) && val < KVM_ARM_PSCI_1_1)
+			return -EINVAL;
+
 		switch (val) {
 		case KVM_ARM_PSCI_0_1:
 			if (wants_02)
-- 
2.39.5

