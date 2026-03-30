Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D313DE44D
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880670; cv=none; b=OzT3VJfqJoDsGTq7YMD20eBmpiojqLwg1uL1bOfc/dRujuYDYt0lkMlZ98TY/Vja2Qni+EKdq0tb4gbFxS0uj16Ailp6iisy7DUZBv7EkMULMKeWUhUfLQt/hMTUwnRvTSrGIg4lqcUeKQHMHmOM1IwOylITmMVj6b9eo8XktRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880670; c=relaxed/simple;
	bh=BJTh6DKRdNRnnZiU+awboJjKpWQvo2Ulr87xVd5p0Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3qA7NntE+OhkoKG8Y9yM2bvv3bN56AaemsaWHoMI+akOADF5NRoD4k5HxeqS9E0QOzrs+H+akNzXVa3eUxJFDz+X8jf7zcVXGcOwU5GzZJ7bowNFoHq5aazl+dZTd1A45wG9zS8vxHoTIf1KeGBASbK67/5F2gkq/5d+6+QJCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=op6uGJcs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="op6uGJcs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 781271D15;
	Mon, 30 Mar 2026 07:24:22 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B65CE3F915;
	Mon, 30 Mar 2026 07:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880668; bh=BJTh6DKRdNRnnZiU+awboJjKpWQvo2Ulr87xVd5p0Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=op6uGJcsCoC+oexn5V0m+uTLCRQqw7yP4VUkBkN6C1vnxaNIQUcBWnb506UyTS6bZ
	 WnhkcrYS7SvZofhPBZafYlt3scuHrxnwCLPeqVRthhLMGMp1Qd2OFTOA9b7WAGFRGW
	 lZ+AOTEg7blf6tzP9ItgmKOBTpHbp/TLSevtiNbo=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 09/17] arm64: Expose ARM64_CORE_REG() for general use
Date: Mon, 30 Mar 2026 15:23:26 +0100
Message-ID: <20260330142334.3309961-10-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
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

