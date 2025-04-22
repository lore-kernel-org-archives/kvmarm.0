Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B586622B5B8;
	Tue, 22 Apr 2025 06:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745304265; cv=none; b=JtsvWRrXJhZrZGvVmqxUPmdbUoP4k+MAc1cH8YqMFN74022ka5cwW4dBed/FwZpyQIenUe5qGo9bXMusupyHqi2TvIg5EM+C9hTmd0AIIXV2MvEf0w9FzDDJ80MkANvLYCrsGpoIRaPRiTv4bPrIIhjSkCXq589da4jfTekFbII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745304265; c=relaxed/simple;
	bh=nd8adeAHJRvCvLmVHt1BYFikRiii/P3JsB1696vNgFg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=RVOViWSzypT50Tv8WcyDsBU2bXh6xXAYTVRm1rADCxn/O0ncSQZz8o2SwK5+hkkCmcyh66ZNmZMjSzsprfaMFKuAF0QOxbEPs/YBwTuvUu4NK+r7mGx43OVKG8UbJD+ua4Hr89w46QezIzW9UIFToVU7RtDlEbii/SjmtwRRkQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H67XYZOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H67XYZOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F68C4CEE9;
	Tue, 22 Apr 2025 06:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745304265;
	bh=nd8adeAHJRvCvLmVHt1BYFikRiii/P3JsB1696vNgFg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=H67XYZOaOErnQ/olzJgv27GF91vbD2KuZ0Us6xRC7WRMgu04AmmPF8FHFdrs7mGyF
	 VwKYPPy74Niz+qE2mYT3Up5eWlzTFbWSoe9Ue3uBKMFkAR0gnri2lJPdZxqeXNLUF7
	 EdMbxxJ7RG7sf7N+XiaXjFLCkD8YDLCr37A8t/qg=
Subject: Patch "KVM: arm64: Calculate cptr_el2 traps on activating traps" has been added to the 6.1-stable tree
To: broonie@kernel.org,catalin.marinas@arm.com,gregkh@linuxfoundation.org,james.clark@linaro.org,james.morse@arm.com,kvmarm@lists.cs.columbia.edu,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,maz@kernel.org,oleg@redhat.com,oliver.upton@linux.dev,suzuki.poulose@arm.com,tabba@google.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 22 Apr 2025 08:43:54 +0200
In-Reply-To: <20250404-stable-sve-6-1-v1-11-cd5c9eb52d49@kernel.org>
Message-ID: <2025042254-travesty-reprint-cba2@gregkh>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From broonie@kernel.org Fri Apr  4 15:28:05 2025
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:44 +0100
Subject: KVM: arm64: Calculate cptr_el2 traps on activating traps
To: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,  James Morse <james.morse@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,  Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,  kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,  Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,  Fuad Tabba <tabba@google.com>, James Clark <james.clark@linaro.org>
Message-ID: <20250404-stable-sve-6-1-v1-11-cd5c9eb52d49@kernel.org>

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
 arch/arm64/include/asm/kvm_host.h |    1 -
 arch/arm64/kvm/arm.c              |    1 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |   15 ---------------
 arch/arm64/kvm/hyp/nvhe/switch.c  |   38 +++++++++++++++++++++++++++-----------
 4 files changed, 27 insertions(+), 28 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -330,7 +330,6 @@ struct kvm_vcpu_arch {
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
-	u64 cptr_el2;
 
 	/* Values of trap registers for the host before guest entry. */
 	u64 mdcr_el2_host;
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1234,7 +1234,6 @@ static int kvm_arch_vcpu_ioctl_vcpu_init
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
 
 	/*
 	 * Handle the "start in power-off" case.
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -17,7 +17,6 @@ static void pvm_init_traps_aa64pfr0(stru
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 	u64 hcr_set = HCR_RW;
 	u64 hcr_clear = 0;
-	u64 cptr_set = 0;
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
@@ -44,16 +43,10 @@ static void pvm_init_traps_aa64pfr0(stru
 	/* Trap AMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), feature_ids)) {
 		hcr_clear |= HCR_AMVOFFEN;
-		cptr_set |= CPTR_EL2_TAM;
 	}
 
-	/* Trap SVE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids))
-		cptr_set |= CPTR_EL2_TZ;
-
 	vcpu->arch.hcr_el2 |= hcr_set;
 	vcpu->arch.hcr_el2 &= ~hcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
 }
 
 /*
@@ -83,7 +76,6 @@ static void pvm_init_traps_aa64dfr0(stru
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
 	u64 mdcr_set = 0;
 	u64 mdcr_clear = 0;
-	u64 cptr_set = 0;
 
 	/* Trap/constrain PMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
@@ -110,13 +102,8 @@ static void pvm_init_traps_aa64dfr0(stru
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), feature_ids))
 		mdcr_set |= MDCR_EL2_TTRF;
 
-	/* Trap Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids))
-		cptr_set |= CPTR_EL2_TTA;
-
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
 }
 
 /*
@@ -167,8 +154,6 @@ static void pvm_init_trap_regs(struct kv
 	/* Clear res0 and set res1 bits to trap potential new features. */
 	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
 	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-	vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
 }
 
 /*
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -36,23 +36,39 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_ve
 
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val = CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
 
-	___activate_traps(vcpu);
-	__activate_traps_common(vcpu);
+	/* !hVHE case upstream */
+	if (1) {
+		val |= CPTR_EL2_TTA | CPTR_NVHE_EL2_RES1;
+
+		/*
+		 * Always trap SME since it's not supported in KVM.
+		 * TSM is RES1 if SME isn't implemented.
+		 */
+		val |= CPTR_EL2_TSM;
 
-	val = vcpu->arch.cptr_el2;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
-	if (!guest_owns_fp_regs(vcpu)) {
-		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
-		__activate_traps_fpsimd32(vcpu);
+		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs(vcpu))
+			val |= CPTR_EL2_TZ;
+
+		if (!guest_owns_fp_regs(vcpu))
+			val |= CPTR_EL2_TFP;
 	}
-	if (cpus_have_final_cap(ARM64_SME))
-		val |= CPTR_EL2_TSM;
+
+	if (!guest_owns_fp_regs(vcpu))
+		__activate_traps_fpsimd32(vcpu);
 
 	write_sysreg(val, cptr_el2);
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

queue-6.1/kvm-arm64-remove-host-fpsimd-saving-for-non-protected-kvm.patch
queue-6.1/spi-cadence-qspi-fix-probe-on-am62a-lp-sk.patch
queue-6.1/asoc-qdsp6-q6asm-dai-fix-q6asm_dai_compr_set_params-error-path.patch
queue-6.1/asoc-qdsp6-q6apm-dai-fix-capture-pipeline-overruns.patch
queue-6.1/kvm-arm64-mark-some-header-functions-as-inline.patch
queue-6.1/kvm-arm64-eagerly-switch-zcr_el-1-2.patch
queue-6.1/kvm-arm64-unconditionally-save-flush-host-fpsimd-sve-sme-state.patch
queue-6.1/asoc-amd-add-dmi-quirk-for-acp6x-mic-support.patch
queue-6.1/kvm-arm64-refactor-exit-handlers.patch
queue-6.1/asoc-qdsp6-q6apm-dai-set-10-ms-period-and-buffer-alignment.patch
queue-6.1/asoc-codecs-lpass-wsa-macro-fix-vi-feedback-rate.patch
queue-6.1/arm64-fpsimd-track-the-saved-fpsimd-state-type-separately-to-tif_sve.patch
queue-6.1/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.zen.patch
queue-6.1/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.smen.patch
queue-6.1/asoc-fsl_audmix-register-card-device-depends-on-dais.patch
queue-6.1/arm64-fpsimd-have-kvm-explicitly-say-which-fp-registers-to-save.patch
queue-6.1/kvm-arm64-discard-any-sve-state-when-entering-kvm-guests.patch
queue-6.1/arm64-fpsimd-stop-using-tif_sve-to-manage-register-saving-in-kvm.patch
queue-6.1/asoc-codecs-lpass-wsa-macro-fix-logic-of-enabling-vi-channels.patch
queue-6.1/kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
