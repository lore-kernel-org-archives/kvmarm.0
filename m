Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34954AA00A
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451612; cv=none; b=S+2m4td9MXjYO9RN69q3AuVKmZmXSPKm8b1bcE0VQ9uOPSVbSzzvQTtLx+XfYozr2pk6OJgFf1IZStfWZLN9QQXRQrze3ZyLAY+u3JMN8riD3PgbxADSfbKcEmJ8b/547l9agaPAfza1U8vNGCcWlP9CzkHgHc0PxkUjGJrV6ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451612; c=relaxed/simple;
	bh=+xEDb1hGKeI2CDY9plNiDwqL5XW3TEtAF0AeP5IGjgE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVpOZPFuNoxVtFKhtPzBLtbn9pDEapSQNJ2+VbnQ0U/mXXXjyeqYcTc91FNIVWFQ+cg/MFm5ZEnCsZ+u2mHtHOE11dDhUCuOyHypvZi+NNswQzDy9mRioNwyNXdQUounlqeRmZE0XNbJS3yjUr2Zl1clSFHotvNqqEuJf4KKSGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UdnnISgS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UdnnISgS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B3861596;
	Thu,  3 Sep 2026 09:06:46 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 341FD3F673;
	Thu,  3 Sep 2026 09:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451610; bh=+xEDb1hGKeI2CDY9plNiDwqL5XW3TEtAF0AeP5IGjgE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UdnnISgS+gVauOkZZq7in3rQtpwKnNkRDWMY2ArbvpO3FnXvU7cLEvXTAGwKcVOUA
	 YsYaemPTLso2h0hcbekRDJZq8sBqcFFqP9VJ03ZTeLAxRrtB4ytziPIh5bRs+P6Ihd
	 CX67ijnv19Gh+ntu0IZzTsm42dmHVHgg6rLocsGQ=
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
Subject: [RFC PATCH v7 07/28] KVM: arm64: Add KVM_ARM_VCPU_SPE VCPU feature
Date: Thu,  3 Sep 2026 17:06:02 +0100
Message-ID: <20260903160623.315525-8-alexandru.elisei@arm.com>
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

Add a new VCPU feature that enables SPE virtualization when set by
userspace. KVM_VCPU_MAX_FEATURE will be bumped and the feature will
become selectable by userspace once SPE support in KVM is implemented.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst    | 2 ++
 arch/arm64/include/asm/kvm_spe.h  | 5 +++++
 arch/arm64/include/uapi/asm/kvm.h | 1 +
 arch/arm64/kvm/arm.c              | 7 +++++++
 4 files changed, 15 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1ed5c389c7a4..654736fac78c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3591,6 +3591,8 @@ Possible features:
 	  Depends on KVM_CAP_ARM_EL2_E2H0.
 	  KVM_ARM_VCPU_HAS_EL2 must also be set.
 
+        - KVM_ARM_VCPU_SPE: Enable SPE for the CPU. Depends on KVM_CAP_ARM_SPE.
+
 4.83 KVM_ARM_PREFERRED_TARGET
 -----------------------------
 
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index f05e6d3f5705..e452da82666d 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -8,11 +8,16 @@
 
 #ifdef CONFIG_KVM_ARM_SPE
 bool kvm_supports_spe(void);
+
+#define vcpu_has_spe(vcpu)					\
+	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
 #else
 static __always_inline bool kvm_supports_spe(void)
 {
 	return false;
 }
+
+#define vcpu_has_spe(vcpu)	false
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 019e5e3d892e..f7f751c00e6f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -107,6 +107,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
 #define KVM_ARM_VCPU_PMU_V3_STRICT	9 /* No default PMU creation */
+#define KVM_ARM_VCPU_SPE		10 /* Support SPE in guest */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index eca1184ef9dd..b9cee4cf293d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1604,6 +1604,9 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
 
+	if (!kvm_supports_spe())
+		clear_bit(KVM_ARM_VCPU_SPE, &features);
+
 	return features;
 }
 
@@ -1648,6 +1651,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
 		return -EINVAL;
 
+	/* SPE is incompatible with AArch32 */
+	if (test_bit(KVM_ARM_VCPU_SPE, &features))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.43.0

