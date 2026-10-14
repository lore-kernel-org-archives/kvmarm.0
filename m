Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C26B51D539;
	Wed, 14 Oct 2026 15:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992851; cv=none; b=KM5tgNoZfIRKoK/XgScK4KrvAhNefsQsHwZWlA/ED2Eoer3qv/2oUyoGsVHbxUm/FflfSROILA17B1oovp/aZdvEueL5RY9UzbPr0eb80bKzve1VtLVoW1wyAZupCiQt8J7BnwM3hXoNkMdaUf3QOoOEPlZUoe7VqsLEQ0WRzoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992851; c=relaxed/simple;
	bh=6otGIeKfClWjbQUXS/YyaNpFrgvGvcQY03U9FnQykwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkQN5ZVIAJqX6UQeJTMsB9OERin1dWYAAJZT50OAxavW3NNth14GBIz4H9XN2TClFd+D1/5toE5xb2vs7henP0Z8bFkheXolyPEtlj6oUYtw6ISKFO4YhOeCvxLZmDrkgCvLywDHo9ip3TFQr7PseYPi1TVDpF0dtO/n1RIMFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqfG4WfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqfG4WfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164EA1F000C4;
	Wed, 14 Oct 2026 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992849;
	bh=rbTaxtGNsGO6dgPReDaWD0CM9kndZbKd1uV53a/NSu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dqfG4WfFMKJxZ9jShdl7o7hbScb8EXezBJoZoHAJjMY2QTexCj+pstW54eXAMefef
	 BSVJN+lUooUHBK45XcGSqxC8+gBs3YCZQ92pDIzpDYCor00KsGZ+4IvBNV4Z3WGLt7
	 IHcxFy9I+aWxO4XI8VFjoxlM89KAywkvlNJIl98I5ruCdg1QAskpAgdvTGjmxhN4nI
	 ObTi0HuPUkkmLi3dAB8FWD3vYG7MRvb9xCkjz+UUI7J1B+eXAwPZN7/UALyAKl38wB
	 XQuFsrlqIy5YaU9BOo7SHmJrNCQYxpsSLRpk0YsWZ1G7sl5keIuMcC+RZfF61CN+/2
	 Ieqc9taOqzpFw==
Date: Wed, 14 Oct 2026 16:47:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with S1PIE
 or S1POE but not TCR2
Message-ID: <as-f1JfUy38Xt9QA@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
 <86fqyn2che.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fqyn2che.wl-maz@kernel.org>

On Sat, Oct 03, 2026 at 01:30:05PM +0100, Marc Zyngier wrote:
> This *absolutely* needs to be data driven, and we're not going back to
> over two years ago. We already have most of what is needed in
> config.c, and it is only a matter of making sure that S1PxE is only
> enabled for the guest if TCR2 and ATS1A are also present. If that
> means additional sanitisation of the idregs when finalised, so be it.
>
> If userspace decides to expose crap in the ID registers, that's its
> own problem, and we're not in the business of enforcing idiotic
> configurations. The only thing that matters is that the state that KVM
> deals with is consistent.

As I understand it: don't return an error for a configuration that doesn't
make sense, enforce RES0 instead.

So I'm guessing something like the below against the series (+ obviously
adjusting tests to reflect that)?

Cheers, Lorenzo

----8<----
From b10625d0147f74504141da1f0c837b3b2bdd3d37 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 14 Oct 2026 16:31:13 +0100
Subject: [PATCH] tmp

---
 arch/arm64/include/asm/kvm_host.h |  7 ++++++-
 arch/arm64/kvm/config.c           | 35 ++++++++++++++++++++++---------
 arch/arm64/kvm/sys_regs.c         | 24 ---------------------
 3 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0eee9845324b..d5ba9867927f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1626,10 +1626,14 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))

 #define kvm_has_s1pie(k)				\
-	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
+	(kvm_has_tcr2(k) &&				\
+	 kvm_has_feat((k), ID_AA64ISAR2_EL1, ATS1A, IMP) &&	\
+	 kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))

 #define kvm_has_s1poe(k)				\
 	(system_supports_poe() &&			\
+	 kvm_has_tcr2(k) &&				\
+	 kvm_has_feat((k), ID_AA64ISAR2_EL1, ATS1A, IMP) &&	\
 	 kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))

 #define kvm_has_ras(k)					\
@@ -1640,6 +1644,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);

 #define kvm_has_gcs(k)					\
 	(system_supports_gcs() &&			\
+	 kvm_has_s1pie(k) &&				\
 	 kvm_has_feat((k), ID_AA64PFR1_EL1, GCS, IMP))

 static inline bool kvm_arch_has_irq_bypass(void)
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551af..58dab9cb2c04 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -232,6 +232,21 @@ static bool not_feat_aa64el3(struct kvm *kvm)
 	return !kvm_has_feat(kvm, FEAT_AA64EL3);
 }

+static bool feat_s1pie(struct kvm *kvm)
+{
+	return kvm_has_s1pie(kvm);
+}
+
+static bool feat_s1poe(struct kvm *kvm)
+{
+	return kvm_has_s1poe(kvm);
+}
+
+static bool feat_gcs(struct kvm *kvm)
+{
+	return kvm_has_gcs(kvm);
+}
+
 static bool feat_nv2(struct kvm *kvm)
 {
 	return ((kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY) &&
@@ -393,17 +408,17 @@ static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
 	NEEDS_FEAT(HFGRTR_EL2_nS2POR_EL1, FEAT_S2POE),
 	NEEDS_FEAT(HFGRTR_EL2_nPOR_EL1		|
 		   HFGRTR_EL2_nPOR_EL0,
-		   FEAT_S1POE),
+		   feat_s1poe),
 	NEEDS_FEAT(HFGRTR_EL2_nPIR_EL1		|
 		   HFGRTR_EL2_nPIRE0_EL1,
-		   FEAT_S1PIE),
+		   feat_s1pie),
 	NEEDS_FEAT(HFGRTR_EL2_nRCWMASK_EL1, FEAT_THE),
 	NEEDS_FEAT(HFGRTR_EL2_nTPIDR2_EL0	|
 		   HFGRTR_EL2_nSMPRI_EL1,
 		   FEAT_SME),
 	NEEDS_FEAT(HFGRTR_EL2_nGCS_EL1		|
 		   HFGRTR_EL2_nGCS_EL0,
-		   FEAT_GCS),
+		   feat_gcs),
 	NEEDS_FEAT(HFGRTR_EL2_nACCDATA_EL1, FEAT_LS64_ACCDATA),
 	NEEDS_FEAT(HFGRTR_EL2_ERXADDR_EL1	|
 		   HFGRTR_EL2_ERXMISCn_EL1	|
@@ -474,17 +489,17 @@ static const struct reg_bits_to_feat_map hfgwtr_feat_map[] = {
 	NEEDS_FEAT(HFGWTR_EL2_nS2POR_EL1, FEAT_S2POE),
 	NEEDS_FEAT(HFGWTR_EL2_nPOR_EL1		|
 		   HFGWTR_EL2_nPOR_EL0,
-		   FEAT_S1POE),
+		   feat_s1poe),
 	NEEDS_FEAT(HFGWTR_EL2_nPIR_EL1		|
 		   HFGWTR_EL2_nPIRE0_EL1,
-		   FEAT_S1PIE),
+		   feat_s1pie),
 	NEEDS_FEAT(HFGWTR_EL2_nRCWMASK_EL1, FEAT_THE),
 	NEEDS_FEAT(HFGWTR_EL2_nTPIDR2_EL0	|
 		   HFGWTR_EL2_nSMPRI_EL1,
 		   FEAT_SME),
 	NEEDS_FEAT(HFGWTR_EL2_nGCS_EL1		|
 		   HFGWTR_EL2_nGCS_EL0,
-		   FEAT_GCS),
+		   feat_gcs),
 	NEEDS_FEAT(HFGWTR_EL2_nACCDATA_EL1, FEAT_LS64_ACCDATA),
 	NEEDS_FEAT(HFGWTR_EL2_ERXADDR_EL1	|
 		   HFGWTR_EL2_ERXMISCn_EL1	|
@@ -674,7 +689,7 @@ static const struct reg_bits_to_feat_map hfgitr_feat_map[] = {
 	NEEDS_FEAT(HFGITR_EL2_nGCSEPP		|
 		   HFGITR_EL2_nGCSSTR_EL1	|
 		   HFGITR_EL2_nGCSPUSHM_EL1,
-		   FEAT_GCS),
+		   feat_gcs),
 	NEEDS_FEAT(HFGITR_EL2_nBRBIALL		|
 		   HFGITR_EL2_nBRBINJ,
 		   FEAT_BRBE),
@@ -913,7 +928,7 @@ static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
 	NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),
 	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
 	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
-	NEEDS_FEAT(HCRX_EL2_GCSEn, FEAT_GCS),
+	NEEDS_FEAT(HCRX_EL2_GCSEn, feat_gcs),
 	NEEDS_FEAT(HCRX_EL2_EnIDCP128, FEAT_SYSREG128),
 	NEEDS_FEAT(HCRX_EL2_EnSDERR, feat_aderr),
 	NEEDS_FEAT(HCRX_EL2_TMEA, FEAT_DoubleFault2),
@@ -1062,8 +1077,8 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 	NEEDS_FEAT(TCR2_EL2_AIE, FEAT_AIE),
 	NEEDS_FEAT(TCR2_EL2_POE		|
 		   TCR2_EL2_E0POE,
-		   FEAT_S1POE),
-	NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
+		   feat_s1poe),
+	NEEDS_FEAT(TCR2_EL2_PIE, feat_s1pie),
 	FORCE_RES0(TCR2_EL2_RES0),
 	FORCE_RES1(TCR2_EL2_RES1),
 };
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3e016ac40427..de48d2d1d761 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5938,27 +5938,6 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	mutex_unlock(&kvm->arch.config_lock);
 }

-/*
- * Some optimisations in fast paths would be broken by architecturally
- * invalid feature combinations, reject those.
- *
- * This should share code with the host kernel cpufeature code, and
- * make use of the MRS to generate dependencies.
- */
-static bool kvm_validate_id_regs(struct kvm *kvm)
-{
-	if (kvm_has_s1pie(kvm) && !kvm_has_tcr2(kvm))
-		return false;
-
-	if (kvm_has_s1poe(kvm) && !kvm_has_tcr2(kvm))
-		return false;
-
-	if (kvm_has_gcs(kvm) && !kvm_has_s1pie(kvm))
-		return false;
-
-	return true;
-}
-
 /*
  * Perform last adjustments to the ID registers that are implied by the
  * configuration outside of the ID regs themselves, as well as any
@@ -6027,9 +6006,6 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 		kvm_vgic_finalize_idregs(kvm);
 	}

-	if (!kvm_validate_id_regs(vcpu->kvm))
-		return -EINVAL;
-
 	return 0;
 }

--
2.56.0
