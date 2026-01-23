Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E1E330640
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178507; cv=none; b=PoONMzvID7wpiO3FEshcqtVqdcQirxHfy6m7Y3lqcDAUW07ju/zoVPabLKvkTFaHsU8otjElCKpl6ukwGzE3+xHh9aqgA0lLQj1KDiu/ZErtuJq/eyDlKL9eMDnGQaUbQb6EwG6wtoA/m3FYKkupXweQeJxEsczOATX9wBjpht8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178507; c=relaxed/simple;
	bh=eq1t1+g9UJ3juuwCMJmc7estKsJWG6W1oyB8JBKlOW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDMdRWFuhOR1DZFYaftBqv0l1cFIL3ooM0JaYApDR2byQu5X9YsDv3ZW+sPGJfFkNFYYocEQo77eUM+Gl1H5vCD4+6EX/UKcVCNI610Qg/Usg7RMgyYqXyHkw280cswsrK/OD2tDXNnlDXE4pJiIXA1NW52R9uFIzrccrrehb6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C05E61476;
	Fri, 23 Jan 2026 06:28:17 -0800 (PST)
Received: from e134369.cambridge.arm.com (e134369.arm.com [10.1.34.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B656E3F740;
	Fri, 23 Jan 2026 06:28:22 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH kvmtool v5 7/7] arm64: Handle virtio endianness reset when running nested
Date: Fri, 23 Jan 2026 14:27:29 +0000
Message-ID: <20260123142729.604737-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123142729.604737-1-andre.przywara@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

When running an EL2 guest, we need to make sure we don't sample
SCTLR_EL1 to work out the virtio endianness, as this is likely
to be a bit random.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h |  5 ++--
 arm64/kvm-cpu.c                  | 47 +++++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index 1af394aa..85646ad4 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -10,8 +10,9 @@
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
-#define ARM_CPU_CTRL		3, 0, 1, 0
-#define ARM_CPU_CTRL_SCTLR_EL1	0
+#define SYS_SCTLR_EL1		3, 4, 1, 0, 0
+#define SYS_SCTLR_EL2		3, 4, 1, 0, 0
+#define SYS_HCR_EL2		3, 4, 1, 1, 0
 
 struct kvm_cpu {
 	pthread_t	thread;
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 5e4f3a7d..35e1c639 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -12,6 +12,7 @@
 
 #define SCTLR_EL1_E0E_MASK	(1 << 24)
 #define SCTLR_EL1_EE_MASK	(1 << 25)
+#define HCR_EL2_TGE		(1 << 27)
 
 static int debug_fd;
 
@@ -408,7 +409,8 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 {
 	struct kvm_one_reg reg;
 	u64 psr;
-	u64 sctlr;
+	u64 sctlr, bit;
+	u64 hcr = 0;
 
 	/*
 	 * Quoting the definition given by Peter Maydell:
@@ -419,8 +421,9 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 	 * We first check for an AArch32 guest: its endianness can
 	 * change when using SETEND, which affects the CPSR.E bit.
 	 *
-	 * If we're AArch64, use SCTLR_EL1.E0E if access comes from
-	 * EL0, and SCTLR_EL1.EE if access comes from EL1.
+	 * If we're AArch64, determine which SCTLR register to use,
+	 * depending on NV being used or not. Then use either the E0E
+	 * bit for EL0, or the EE bit for EL1/EL2.
 	 */
 	reg.id = ARM64_CORE_REG(regs.pstate);
 	reg.addr = (u64)&psr;
@@ -430,16 +433,40 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 	if (psr & PSR_MODE32_BIT)
 		return (psr & COMPAT_PSR_E_BIT) ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
 
-	reg.id = ARM64_SYS_REG(ARM_CPU_CTRL, ARM_CPU_CTRL_SCTLR_EL1);
+	if (vcpu->kvm->cfg.arch.nested_virt) {
+		reg.id = ARM64_SYS_REG(SYS_HCR_EL2);
+		reg.addr = (u64)&hcr;
+		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+			die("KVM_GET_ONE_REG failed (HCR_EL2)");
+	}
+
+	switch (psr & PSR_MODE_MASK) {
+	case PSR_MODE_EL0t:
+		if (hcr & HCR_EL2_TGE)
+			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL2);
+		else
+			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL1);
+		bit = SCTLR_EL1_E0E_MASK;
+		break;
+	case PSR_MODE_EL1t:
+	case PSR_MODE_EL1h:
+		reg.id = ARM64_SYS_REG(SYS_SCTLR_EL1);
+		bit = SCTLR_EL1_EE_MASK;
+		break;
+	case PSR_MODE_EL2t:
+	case PSR_MODE_EL2h:
+		reg.id = ARM64_SYS_REG(SYS_SCTLR_EL2);
+		bit = SCTLR_EL1_EE_MASK;
+		break;
+	default:
+		die("What's that mode???\n");
+	}
+
 	reg.addr = (u64)&sctlr;
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
-		die("KVM_GET_ONE_REG failed (SCTLR_EL1)");
+		die("KVM_GET_ONE_REG failed (SCTLR_ELx)");
 
-	if ((psr & PSR_MODE_MASK) == PSR_MODE_EL0t)
-		sctlr &= SCTLR_EL1_E0E_MASK;
-	else
-		sctlr &= SCTLR_EL1_EE_MASK;
-	return sctlr ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
+	return (sctlr & bit) ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
 }
 
 void kvm_cpu__show_code(struct kvm_cpu *vcpu)
-- 
2.43.0

