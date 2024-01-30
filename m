Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12EE71B5C
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647551; cv=none; b=ZpfF29vWez1OK9h/84HsKBSMI4e67plxTzvGlMo6hnbWz//sTkQFgnz5LoKBF/WiSw2/LqRu1Z7Nr2x5g0fiUlbDPd8KS89xH8u7BRuLphefV5hl1D+0mlyVHxtji0kenXUnXwBxhPtSlov4HLoJcQlybLc4+7JdzGWwEdOT8IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647551; c=relaxed/simple;
	bh=P9aY9RTe8Jv15BRsJ1yTkgB9wXEsDQbbKKhHC7/BF+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mK/Y9hNu+RaLNio/RgstgQGL6rbAC1fclv2ZfPA/onVYyyKPQf4/Zl3k/W2zlOT7BKkgi5bINnpzCp40wyOdSZ7CWII/vec+y1JeV4/GmKl9zVDri3ROW5mujIefkP0YwugGu/gtAAdLbjf3Bta12SUyVfBrhS4FDfIOUCdLv4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHqYWd/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHqYWd/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65DBC433F1;
	Tue, 30 Jan 2024 20:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647551;
	bh=P9aY9RTe8Jv15BRsJ1yTkgB9wXEsDQbbKKhHC7/BF+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHqYWd/Ip/89KSxmEJgaph9YfZoWvjckdx32P7B3hPuOBkWJSg9zw2MGOh6zXZkrZ
	 b/PWpR+7FGEwbnebQ5bf56jXtzwFwGL1wndQ6aUmWzy+DvcDUxxCGNbPNqiCw3ec2g
	 ia/rC617/mcTiaNnV1VzNUHPrDG9kAr1NJrjqLoRVFk8Th0p268YxSAe2WR6JlK7zS
	 SJv9aiTZdiTZcFnArzGN53G3vzDKvI4pCKR0BSYamncXaINBVIzYofpexy9P2yp+4o
	 YG/qbcXKVA9CxHYlR6aQ+tOHmccyGKo0dLxsz3e/+DfQp7aktxDIYuTfY6ZDHTWBSm
	 y1GB52pQ2xtCA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzN-00GNsE-Mz;
	Tue, 30 Jan 2024 20:45:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 24/25] KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest
Date: Tue, 30 Jan 2024 20:45:31 +0000
Message-Id: <20240130204533.693853-25-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We unconditionally enable FEAT_MOPS, which is obviously wrong.

So let's only do that when it is advertised to the guest.
Which means we need to rely on a per-vcpu HCRX_EL2 shadow register.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h        | 4 +---
 arch/arm64/include/asm/kvm_host.h       | 1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/sys_regs.c               | 7 +++++++
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3c6f8ba1e479..a1769e415d72 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -102,9 +102,7 @@
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-#define HCRX_GUEST_FLAGS \
-	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
-	 (cpus_have_final_cap(ARM64_HAS_MOPS) ? (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0))
+#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index eff894d59590..50a122d42587 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -584,6 +584,7 @@ struct kvm_vcpu_arch {
 
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
+	u64 hcrx_el2;
 	u64 mdcr_el2;
 	u64 cptr_el2;
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 2d5891518006..e3fcf8c4d5b4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -236,7 +236,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
-		u64 hcrx = HCRX_GUEST_FLAGS;
+		u64 hcrx = vcpu->arch.hcrx_el2;
 		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
 			u64 clr = 0, set = 0;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 38ed47bd29db..2cb69efac1dc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3956,6 +3956,13 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
 
+	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
+		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
+			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
+	}
+
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
 
-- 
2.39.2

