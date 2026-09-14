Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3182E43F8DB
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385708; cv=none; b=uBOlV1OYk7+24UggosMYILhW0KUxXfUKAURsLf/oA486oHg7QJ73Ky8IOqD0lAzOG53WC72IGlKQFBF1tQtCD38SfNht0QomGY5xCNre/u/k9qwmNsFjcHT5vSFonoOHH3NMtGVEZKDnrpJAwLLr/YR5QAmriOM9gQJteios0Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385708; c=relaxed/simple;
	bh=2wNaRZ40XGcnfoIkGaM2V+sQy41BPJkxofiOYCo/jkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SXQGYc9zj9LHvXumRmuct1/li6qDotMbA+wjvQPW/O0z4ajAuJQFaOMQaVHPEl9cxBMoX7eCzRxUkXWy0hU+5QextSjbKhhG86ymbgFxrR+xFRHlDy/JXxydc0v7zJ598PrX30kCupPWkFOl7epONgjmXzDR9Nrp2zzZZyBe8Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=da833WdA; arc=none smtp.client-ip=91.218.175.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="da833WdA"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2wNaRZ40XGcnfoIkGaM2V+sQy41BPJkxofiOYCo/jkg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789385704; v=1; x=1789990504;
 b=da833WdAltvjuLLXQBaqJs/bUiZJg2aMNHJTkQtaTh7J4XafOjsS7/7mKvJxuavVLETC1X4P
 go72RPLZE4BSASU3/6feSkIXsLM4zy8xQGJuUlyqF/g9MYVceDJYtXGtc8q6QqwqF1oAKB2EYdg
 d5OMaqz4E1ZZvZk6ioc/jUJs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ded816237a450b71;
	Mon, 14 Sep 2026 11:35:04 +0000
X-Mizu-Trace-ID: ded816237a450b71
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
Subject: [PATCH v3 11/18] KVM: arm64: Restrict KVM_ARM_VCPU_INIT and PSCI version for protected VMs
Date: Mon, 14 Sep 2026 12:33:31 +0100
Message-Id: <20260914113338.159227-12-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260914113338.159227-1-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
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
index d970cba12ca47..8e6c2e70913c5 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -412,23 +412,10 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
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

