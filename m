Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414002CCDB;
	Fri, 21 Mar 2025 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516298; cv=none; b=asfFDCBqmAm6qK3iQjhDuQGrbpKyyxuLODCb3A/yxljdaaP/az3Pe3R9XIJnmHS7ioFvTQGbl7U5w3KHrD42vPyfk0YRJlQlAe9i4n43R3xUVbi2/LwdvLVRaz9MHNVaeyTyYmtPElB7jiIw/bYgCiRZTU/rDhF3GQdZG7J31JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516298; c=relaxed/simple;
	bh=IkZsuY+kAaVDLrs8HWKvRFz6/h6ZoxMySJFddJZVVGc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S2aLGcgp9i1UVGYVR0HnHHUHGB/EHDyyPc7s0rlJ1IGMHkVTrDsuC4k+yyHJaGoVnUkPdXGnNmjv9FoI7Uga3UPnhdd8NnVZbM2PQtysFPwK5KWJqVUszrRy87bbwVUPXlnN3Z/tIvdHoWeb1CwWDVP3VzLdHYdZXhYBWQB+Zk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhiNkYVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhiNkYVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463FBC4CEEC;
	Fri, 21 Mar 2025 00:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516295;
	bh=IkZsuY+kAaVDLrs8HWKvRFz6/h6ZoxMySJFddJZVVGc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HhiNkYVWAeRC2RvW4BcuNKDTM0/B1aYTF44nGEDLsHSDrUrA7ZG+hVEcZr0lS/MjA
	 4Iposz+TZ0CJDhh0QdEkaN00tWs+59OLc7gm39AkX4mi0RIuE6ip6g737Ka4uR6Bxc
	 LWgJizA6e77UTwRXIAQ7z+NjcgkpUczT5thvI83r9zIkT3x1SNKxBUkIN2MhPeAIZQ
	 bYqJYBvsqZ3uoRS/EiZL1xSpjuhz/ZhJUF1CrKIXrRld+I4LAsZRh58bjXElPsMnov
	 51hIC6rvsx1bnMbWOe+rD9X7+in6nXTdIBX5qWAfw7umppC+nSv8jEvouZtK7FFhYY
	 XhE9A12SgFlRg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:16:01 +0000
Subject: [PATCH 6.6 1/8] KVM: arm64: Calculate cptr_el2 traps on activating
 traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250321-stable-sve-6-6-v1-1-0b3a6a14ea53@kernel.org>
References: <20250321-stable-sve-6-6-v1-0-0b3a6a14ea53@kernel.org>
In-Reply-To: <20250321-stable-sve-6-6-v1-0-0b3a6a14ea53@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Fuad Tabba <tabba@google.com>, 
 James Clark <james.clark@linaro.org>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=7504; i=broonie@kernel.org;
 h=from:subject:message-id; bh=JSYgABijzaBEeRBZ792dyLFvcMocImtFap9K59dqIIQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3LA6vxysY9lgminsnLplSF2R0v15vrkadze3SGzB
 yuP0ohiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9ywOgAKCRAk1otyXVSH0J7FCA
 CFlv5e6TtLoZ19s1IAM8KyYVpP+nV5rks+ZA/9P/T6jpVPAA6DFB32VLwPiny2NiYudGUVM6Rb7fYS
 JByJxHEHvTU0Mkwgji6LHDUo/QpKF0I8QkON8T1XuhJ8X0mo/HGpieVUlkPQrWcnrR3tOASVui7USq
 R3jzdDKrolhqYygtPhgOPexLccf92NQJKjKgZxraShlV8HBFxscw6qvzSj2q1M0oAtdZcGJ2g0YbXR
 EyZnVwxIJd2hkionDQlrlYslt3ffevg8frgUpvqn+/t1ud7V4En51+3/MAMlVGvgOXaIj4cgbZnnZN
 pqiJS5XzEF9xGda/OlXekt3DPMuTAa
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Fuad Tabba <tabba@google.com>

[ Upstream commit 2fd5b4b0e7b440602455b79977bfa64dea101e6c ]

Similar to VHE, calculate the value of cptr_el2 from scratch on
activate traps. This removes the need to store cptr_el2 in every
vcpu structure. Moreover, some traps, such as whether the guest
owns the fp registers, need to be set on every vcpu run.

Reported-by: James Clark <james.clark@linaro.org>
Fixes: 5294afdbf45a ("KVM: arm64: Exclude FP ownership from kvm_vcpu_arch")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://lore.kernel.org/r/20241216105057.579031-13-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  |  1 -
 arch/arm64/kvm/arm.c               |  1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 --
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 27 --------------------
 arch/arm64/kvm/hyp/nvhe/switch.c   | 52 +++++++++++++++++++++++---------------
 5 files changed, 32 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b84ed3ad91a9eba3a30a6081371f2ec98963de06..6a165ec5d3b74ece3e98e7bf45f3ea94cc30e6ec 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -486,7 +486,6 @@ struct kvm_vcpu_arch {
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
-	u64 cptr_el2;
 
 	/* Values of trap registers for the host before guest entry. */
 	u64 mdcr_el2_host;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ffdc2c4d07ee83dbeb78b76d93f700f53af35be6..9818cde948ca9c7028220322aea4ff3706542c93 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1309,7 +1309,6 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2385fd03ed87c6c0450a1c2dbe830e95ce235ecc..67cc07283e642ab07e1c98c5745e2c6a2dd4f36e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -36,7 +36,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
-	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
@@ -59,7 +58,6 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
 
 	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
-	host_vcpu->arch.cptr_el2	= hyp_vcpu->vcpu.arch.cptr_el2;
 
 	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8033ef353a5da406dba355ab73854dfa39e93c27..9e7612343ad66d3dc13b8ee858a4e61e917901c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -26,8 +26,6 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 	u64 hcr_set = HCR_RW;
 	u64 hcr_clear = 0;
-	u64 cptr_set = 0;
-	u64 cptr_clear = 0;
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
@@ -57,21 +55,10 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	/* Trap AMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), feature_ids)) {
 		hcr_clear |= HCR_AMVOFFEN;
-		cptr_set |= CPTR_EL2_TAM;
-	}
-
-	/* Trap SVE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids)) {
-		if (has_hvhe())
-			cptr_clear |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
-		else
-			cptr_set |= CPTR_EL2_TZ;
 	}
 
 	vcpu->arch.hcr_el2 |= hcr_set;
 	vcpu->arch.hcr_el2 &= ~hcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
-	vcpu->arch.cptr_el2 &= ~cptr_clear;
 }
 
 /*
@@ -101,7 +88,6 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
 	u64 mdcr_set = 0;
 	u64 mdcr_clear = 0;
-	u64 cptr_set = 0;
 
 	/* Trap/constrain PMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
@@ -128,17 +114,8 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), feature_ids))
 		mdcr_set |= MDCR_EL2_TTRF;
 
-	/* Trap Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids)) {
-		if (has_hvhe())
-			cptr_set |= CPACR_EL1_TTA;
-		else
-			cptr_set |= CPTR_EL2_TTA;
-	}
-
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
 }
 
 /*
@@ -189,10 +166,6 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	/* Clear res0 and set res1 bits to trap potential new features. */
 	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
 	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	if (!has_hvhe()) {
-		vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-		vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
-	}
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c353a06ee7e6d624b41997021379b7b4cf77453d..1026be1964d9664b8b6de19e048aba91ee6463b0 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -36,34 +36,46 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val = CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
 
-	___activate_traps(vcpu);
-	__activate_traps_common(vcpu);
+	if (has_hvhe()) {
+		val |= CPACR_ELx_TTA;
 
-	val = vcpu->arch.cptr_el2;
-	val |= CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
-	val |= has_hvhe() ? CPACR_EL1_TTA : CPTR_EL2_TTA;
-	if (cpus_have_final_cap(ARM64_SME)) {
-		if (has_hvhe())
-			val &= ~(CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN);
-		else
-			val |= CPTR_EL2_TSM;
-	}
+		if (guest_owns_fp_regs(vcpu)) {
+			val |= CPACR_ELx_FPEN;
+			if (vcpu_has_sve(vcpu))
+				val |= CPACR_ELx_ZEN;
+		}
+	} else {
+		val |= CPTR_EL2_TTA | CPTR_NVHE_EL2_RES1;
 
-	if (!guest_owns_fp_regs(vcpu)) {
-		if (has_hvhe())
-			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
-				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
-		else
-			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
+		/*
+		 * Always trap SME since it's not supported in KVM.
+		 * TSM is RES1 if SME isn't implemented.
+		 */
+		val |= CPTR_EL2_TSM;
 
-		__activate_traps_fpsimd32(vcpu);
+		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs(vcpu))
+			val |= CPTR_EL2_TZ;
+
+		if (!guest_owns_fp_regs(vcpu))
+			val |= CPTR_EL2_TFP;
 	}
 
+	if (!guest_owns_fp_regs(vcpu))
+		__activate_traps_fpsimd32(vcpu);
+
 	kvm_write_cptr_el2(val);
+}
+
+static void __activate_traps(struct kvm_vcpu *vcpu)
+{
+	___activate_traps(vcpu);
+	__activate_traps_common(vcpu);
+	__activate_cptr_traps(vcpu);
+
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {

-- 
2.39.5

