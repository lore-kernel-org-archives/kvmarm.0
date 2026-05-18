Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB1443C060
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108375; cv=none; b=sgIcMTAEPF4uN/D/7AZszSFxwIOLVxKKcagBi5mDyicF2XaVpAa8WjZ0KXxpJ83PZC2hHl+lbjG6FB9D2+fVaQ0vFsxv2y1QQ4j0cXAvy90EtvOs66wvnpIREDKbFG7wollE5/VLeMEPAzu7XqlC8wbXkPBX+J2wSd75Zbpdves=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108375; c=relaxed/simple;
	bh=lf9bSvJ4KtEk9GbWlRSpmfWhDzhpluktjgpUR6LFA+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5hc/6KoyRZNaNUoRU4gqvoYsWpWOGk1fyiZBUBSejNvNwdSWV2DihmeomP8CMI0cxndmtmgnl4DUvle8wzugx/XtXjvGtAJGsPjy/yK+JVCEr1/vbCPNyYI6QW4b+pp1criz97BGLHUoBbbuGd/18x3UIqXHUh2SK9mtrwGE0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IBjYbwH3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IBjYbwH3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C66945BF;
	Mon, 18 May 2026 05:46:08 -0700 (PDT)
Received: from e142021.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 110873F632;
	Mon, 18 May 2026 05:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779108373; bh=lf9bSvJ4KtEk9GbWlRSpmfWhDzhpluktjgpUR6LFA+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBjYbwH375euFlnzKU9R2lYtc2WqqnS1N4VzF2Hua3J5N1Jpc0YINMHIV84iHRJfd
	 MOgten3zPv168IJtrabxp8BCQMAhvdqdbEpigLHxbOYEBSdG2j0OUgoMvlHqG5c72o
	 PlyZ9jV+ooY23/pcOHwI7bId7jArSf9nSH17g6mY=
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v8 6/6] arm64: Handle virtio endianness reset when running nested
Date: Mon, 18 May 2026 14:45:56 +0200
Message-ID: <20260518124556.164739-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260518124556.164739-1-andre.przywara@arm.com>
References: <20260518124556.164739-1-andre.przywara@arm.com>
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
 arm64/include/kvm/kvm-cpu-arch.h |  5 +--
 arm64/kvm-cpu.c                  | 58 ++++++++++++++++++++++++++------
 2 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index d9eb5f0e..91d761fc 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -9,8 +9,9 @@
 
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
-#define ARM_CPU_CTRL		3, 0, 1, 0
-#define ARM_CPU_CTRL_SCTLR_EL1	0
+#define SYS_SCTLR_EL1		3, 0, 1, 0, 0
+#define SYS_SCTLR_EL2		3, 4, 1, 0, 0
+#define SYS_HCR_EL2		3, 4, 1, 1, 0
 
 struct kvm_cpu {
 	pthread_t	thread;
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 204a80d0..ae5a6eb7 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -13,6 +13,8 @@
 
 #define SCTLR_EL1_E0E_MASK	(1 << 24)
 #define SCTLR_EL1_EE_MASK	(1 << 25)
+#define HCR_EL2_TGE		(1UL << 27)
+#define HCR_EL2_E2H		(1UL << 34)
 
 static int debug_fd;
 
@@ -394,7 +396,8 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 {
 	struct kvm_one_reg reg;
 	u64 psr;
-	u64 sctlr;
+	u64 sctlr, bit;
+	u64 hcr = 0;
 
 	/*
 	 * Quoting the definition given by Peter Maydell:
@@ -405,8 +408,9 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
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
@@ -416,16 +420,50 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
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
+		switch (hcr & (HCR_EL2_E2H | HCR_EL2_TGE)) {
+		case HCR_EL2_E2H | HCR_EL2_TGE: /* EL2&0 */
+			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL2);
+			bit = SCTLR_EL1_E0E_MASK;
+			break;
+		case HCR_EL2_TGE:		/* EL2 */
+			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL2);
+			bit = SCTLR_EL1_EE_MASK;
+			break;
+		case HCR_EL2_E2H:		/* EL1&0 (VHE) */
+		default:			/* EL1&0 (!VHE) */
+			reg.id = ARM64_SYS_REG(SYS_SCTLR_EL1);
+			bit = SCTLR_EL1_E0E_MASK;
+			break;
+		}
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

