Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41321755E
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129291; cv=none; b=OwZ6lA6PFFestyAIbEeJfq6Y8/duev9QuWIwtcCGRkjAQuR4XpulTEO91898+ruGr3eUdS2jVsp/tz5vUaB4YmNdwEc0yHqwE7oPK+hJ1dGIC8C6hIbdBt50AgMLZT6peklAGmpnK/dbLeY/BX/nWyVVYCKoGLzc/Gijiva6v3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129291; c=relaxed/simple;
	bh=tpnzjbaBSixEtleIiKRUI9e9c3KhM2pJgrn2J+/zS94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Igl3OkWTWW+B9Zkm8BvxggfkiahcwsM968L0SYD0CHZ9cOGhTemeDxRBEkZg4aacVhjcMqvOZcgJXHyNf3hxwo9FXN6pOeeRGhAaY9H3izFOF33328GF45QjCSqUqCeFqreAsOi4wP0xrJNnJbds5tyarZbrF75SF5s6kvgixvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQ+nTz82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQ+nTz82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7ACC433B1;
	Mon,  5 Feb 2024 10:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129291;
	bh=tpnzjbaBSixEtleIiKRUI9e9c3KhM2pJgrn2J+/zS94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQ+nTz82nImr1Q1pzOI75NyNYxwzqmWUffAVISZfDwzCgRtNHfwRxOneJ5AV445pX
	 0C8dfAjxy7L5J3LLOe7cIRskIxlXkbML/3V7JfnltZDqKe881cK5HR8YfSyHWG93QM
	 M4itXYp+5y75fJHvU42efABW+aryi+HkqrfrZAOGmdXtKoZDiF37e5P2qKfOgn86PS
	 kqd+HM8woSRL3vbCcOwzElD2aGI20BpqtPXEVGlpABp3me0F5QICeiZNtFZIdK+Y7u
	 k0toBYGJ43A2EfProdsmpPV2tEN3AKuJAAwxoGa5MjnIp/ZpZXarB2K7wm2t1UGYWN
	 NHsvWvVNym9Rg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJN-000Nc3-Qw;
	Mon, 05 Feb 2024 10:34:49 +0000
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
Subject: [PATCH v3 24/26] KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest
Date: Mon,  5 Feb 2024 10:34:29 +0000
Message-Id: <20240205103431.1104133-25-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
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
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
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
index 968a997b3f02..3feabde9c926 100644
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

