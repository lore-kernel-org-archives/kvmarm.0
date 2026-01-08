Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6092EB862
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895154; cv=none; b=p87o0fxC6pCKp4q/cZKkUtn+b4pqzMD8iGNqlyzo4H0o2tK1BkNNkFeBSAvZxbXtr+s+iFX86kUkHIOODIfOahfCw6o1lAwXaa6cFokHI9nGIAdralqS/y1+Gp+f2uyYLn20kCnRzdoo0ipLhNhkoYiShMr+rC8aN2OgV0hbO8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895154; c=relaxed/simple;
	bh=BJTh6DKRdNRnnZiU+awboJjKpWQvo2Ulr87xVd5p0Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaMDYCn6AcFm7t/vBpzWc2wT3GTlMzXJ2rNo1Ef+RnNJ2sIAYEeXc6ebVc1TfYhBljTuvWlwh79f2e+NYnCSujJNgYuNZOWSkyynCg4nr9ITep2KMX14JEmEdXv/RMmWD5AVtJeAw+H+jd7weo9bNtC+bxOf53660UBEW3feT5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA1131688;
	Thu,  8 Jan 2026 09:59:01 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B03AE3F5A1;
	Thu,  8 Jan 2026 09:59:05 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 07/15] arm64: Expose ARM64_CORE_REG() for general use
Date: Thu,  8 Jan 2026 17:57:45 +0000
Message-ID: <20260108175753.1292097-8-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Expose the macro such that it may be used to get SMCCC arguments in a
future change.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h | 16 ++++++++++++++++
 arm64/kvm-cpu.c                  | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index 2f189abc..dbd90647 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -67,4 +67,20 @@ unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu);
 int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
 int kvm_cpu__teardown_pvtime(struct kvm *kvm);
 
+static inline __u64 __core_reg_id(__u64 offset)
+{
+	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
+
+	if (offset < KVM_REG_ARM_CORE_REG(fp_regs))
+		id |= KVM_REG_SIZE_U64;
+	else if (offset < KVM_REG_ARM_CORE_REG(fp_regs.fpsr))
+		id |= KVM_REG_SIZE_U128;
+	else
+		id |= KVM_REG_SIZE_U32;
+
+	return id;
+}
+
+#define ARM64_CORE_REG(x) __core_reg_id(KVM_REG_ARM_CORE_REG(x))
+
 #endif /* ARM_COMMON__KVM_CPU_ARCH_H */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index c7286484..f8e08b5d 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -238,22 +238,6 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 }
 
-static __u64 __core_reg_id(__u64 offset)
-{
-	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
-
-	if (offset < KVM_REG_ARM_CORE_REG(fp_regs))
-		id |= KVM_REG_SIZE_U64;
-	else if (offset < KVM_REG_ARM_CORE_REG(fp_regs.fpsr))
-		id |= KVM_REG_SIZE_U128;
-	else
-		id |= KVM_REG_SIZE_U32;
-
-	return id;
-}
-
-#define ARM64_CORE_REG(x) __core_reg_id(KVM_REG_ARM_CORE_REG(x))
-
 unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu)
 {
 	struct kvm_one_reg reg;
-- 
2.43.0

