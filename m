Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68421386DA;
	Tue, 25 Mar 2025 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742902220; cv=none; b=bRrWL1tn7Rgk9J1EdAtJgH8HiKyxSgaqVeYcZ60vugAodoQ6b5WxPonqIAOrNcnTeX/IgJyoMgDvNf4NaAlqHkmEGT/HuvXwmz2XrYXpirjOZA8IUP4zLymmIHJR+yU2TefwtdRDqsgADLZmCWkUdyoSqVm2RG9Dx5d1dPjXi3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742902220; c=relaxed/simple;
	bh=fXNgrSGtp7PL2jj2I/VhD/82GSlZPge7S1XzKqSV1uI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=j5c9YGunedABpEyIfvs00eJroQcgm/1nX93T5aDVrIjp6/1C21sgxKM/r/EfKwZ1OHTzpEsK46VOxbu+FvV1OT4JeJkrMcXMhyRvtW7p4pqtO+n4Ww0ag0kF7g2dXRq8K8gAgflAYhy8tddB8OnzTXUIsuGZpQXKuIXvKntQKOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCROdQ9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCROdQ9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3707BC4CEE4;
	Tue, 25 Mar 2025 11:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742902218;
	bh=fXNgrSGtp7PL2jj2I/VhD/82GSlZPge7S1XzKqSV1uI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=QCROdQ9M+xVEL5PdAf1R9Sgmgyx3CaF9EPKwBQb8eW4UzZwrvf5nMDdBZIhzb2Zfy
	 zWXV4AS2dMtzt5m8GtqATwNWdypwNiC2adD6wY/5+aMbuMU7xL6Q341jXwXQyJ2afJ
	 CsHRXTxzE1VtMWNkVXdfYIMuTrNZm70Znj9kbt2g=
Subject: Patch "KVM: arm64: Calculate cptr_el2 traps on activating traps" has been added to the 6.6-stable tree
To: broonie@kernel.org,catalin.marinas@arm.com,gregkh@linuxfoundation.org,james.clark@linaro.org,james.morse@arm.com,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,maz@kernel.org,oliver.upton@linux.dev,suzuki.poulose@arm.com,tabba@google.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 25 Mar 2025 07:28:55 -0400
In-Reply-To: <20250321-stable-sve-6-6-v1-1-0b3a6a14ea53@kernel.org>
Message-ID: <2025032555-stingy-unwed-db94@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    KVM: arm64: Calculate cptr_el2 traps on activating traps

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-125719-greg=kroah.com@vger.kernel.org Thu Mar 20 20:19:30 2025
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:16:01 +0000
Subject: KVM: arm64: Calculate cptr_el2 traps on activating traps
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,  James Morse <james.morse@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,  Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,  linux-kernel@vger.kernel.org, stable@vger.kernel.org,  Mark Brown <broonie@kernel.org>, Fuad Tabba <tabba@google.com>,  James Clark <james.clark@linaro.org>
Message-ID: <20250321-stable-sve-6-6-v1-1-0b3a6a14ea53@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h  |    1 
 arch/arm64/kvm/arm.c               |    1 
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |    2 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |   27 -------------------
 arch/arm64/kvm/hyp/nvhe/switch.c   |   52 ++++++++++++++++++++++---------------
 5 files changed, 32 insertions(+), 51 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -486,7 +486,6 @@ struct kvm_vcpu_arch {
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
-	u64 cptr_el2;
 
 	/* Values of trap registers for the host before guest entry. */
 	u64 mdcr_el2_host;
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1309,7 +1309,6 @@ static int kvm_arch_vcpu_ioctl_vcpu_init
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 
 	/*
 	 * Handle the "start in power-off" case.
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -36,7 +36,6 @@ static void flush_hyp_vcpu(struct pkvm_h
 
 	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
-	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
@@ -59,7 +58,6 @@ static void sync_hyp_vcpu(struct pkvm_hy
 	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
 
 	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
-	host_vcpu->arch.cptr_el2	= hyp_vcpu->vcpu.arch.cptr_el2;
 
 	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
 
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -26,8 +26,6 @@ static void pvm_init_traps_aa64pfr0(stru
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 	u64 hcr_set = HCR_RW;
 	u64 hcr_clear = 0;
-	u64 cptr_set = 0;
-	u64 cptr_clear = 0;
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
@@ -57,21 +55,10 @@ static void pvm_init_traps_aa64pfr0(stru
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
@@ -101,7 +88,6 @@ static void pvm_init_traps_aa64dfr0(stru
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
 	u64 mdcr_set = 0;
 	u64 mdcr_clear = 0;
-	u64 cptr_set = 0;
 
 	/* Trap/constrain PMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
@@ -128,17 +114,8 @@ static void pvm_init_traps_aa64dfr0(stru
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
@@ -189,10 +166,6 @@ static void pvm_init_trap_regs(struct kv
 	/* Clear res0 and set res1 bits to trap potential new features. */
 	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
 	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	if (!has_hvhe()) {
-		vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-		vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
-	}
 }
 
 /*
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -36,34 +36,46 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_ve
 
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
+
+		/*
+		 * Always trap SME since it's not supported in KVM.
+		 * TSM is RES1 if SME isn't implemented.
+		 */
+		val |= CPTR_EL2_TSM;
 
-	if (!guest_owns_fp_regs(vcpu)) {
-		if (has_hvhe())
-			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
-				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
-		else
-			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
+		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs(vcpu))
+			val |= CPTR_EL2_TZ;
 
-		__activate_traps_fpsimd32(vcpu);
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


Patches currently in stable-queue which might be from broonie@kernel.org are

queue-6.6/kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
queue-6.6/regulator-check-that-dummy-regulator-has-been-probed-before-using-it.patch
queue-6.6/kvm-arm64-eagerly-switch-zcr_el-1-2.patch
queue-6.6/kvm-arm64-mark-some-header-functions-as-inline.patch
queue-6.6/kvm-arm64-remove-host-fpsimd-saving-for-non-protected-kvm.patch
queue-6.6/regulator-dummy-force-synchronous-probing.patch
queue-6.6/kvm-arm64-refactor-exit-handlers.patch
queue-6.6/kvm-arm64-unconditionally-save-flush-host-fpsimd-sve-sme-state.patch
queue-6.6/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.smen.patch
queue-6.6/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.zen.patch
