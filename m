Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7087281503
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136471; cv=none; b=sObHfdCeHurOtnAD3wAOueB13BBHB1tLqKALg6W8TlZp4uL2DjYzvhYuxKGZQGr09lDpJy37R3TgW14mNOhmF6cZsswcDtdeZ1qw55vEw3xdEjOeQ9dWcYHuPUq500Vp1Vh8JTUujq0S6WUoP5yHLyMDLySzHjYaUpdMDcsnems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136471; c=relaxed/simple;
	bh=0lkgCcZ13b/4UkRfU+NKdz4vsVOhpvQipM/+2TbX9Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLJMYiB/QQKJgNSf1r7H8uO52Tmt26KYCKMgYk2rdaTMrWmw2M6aHYfzVjn6j4f4ddJJQXVhuGIYgGIa7bxp/ARnMSWqsA7LgmhklgAenmmibagpxCtO7tCkbBz7FS1RRpSaoIoLFWBgyfU6ItrU2bKfFdSc/VvLmOI+JA2aTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5514106F;
	Fri, 14 Nov 2025 08:07:41 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 332F13F5A1;
	Fri, 14 Nov 2025 08:07:47 -0800 (PST)
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
Subject: [RFC PATCH v6 06/35] KVM: arm64: Add KVM_ARM_VCPU_SPE VCPU feature
Date: Fri, 14 Nov 2025 16:06:47 +0000
Message-ID: <20251114160717.163230-7-alexandru.elisei@arm.com>
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

Add a new VCPU feature that enables SPE virtualization when set by
userspace.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h  | 4 ++++
 arch/arm64/include/uapi/asm/kvm.h | 1 +
 arch/arm64/kvm/arm.c              | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 6572384531e2..8e8a5c6f7971 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -13,8 +13,12 @@ static __always_inline bool kvm_supports_spe(void)
 {
 	return static_branch_likely(&kvm_spe_available);
 }
+
+#define vcpu_has_spe(vcpu)					\
+	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
 #else
 #define kvm_supports_spe()	false
+#define vcpu_has_spe(vcpu)	false
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c..5bdfe1f6d565 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
+#define KVM_ARM_VCPU_SPE		9 /* Support SPE in guest */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ee230cb34215..1e4449d96d62 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1459,6 +1459,9 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
 
+	if (!kvm_supports_spe())
+		clear_bit(KVM_ARM_VCPU_SPE, &features);
+
 	return features;
 }
 
@@ -1498,6 +1501,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
 		return -EINVAL;
 
+	/* SPE is incompatible with AArch32 */
+	if (test_bit(KVM_ARM_VCPU_SPE, &features))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.51.2

