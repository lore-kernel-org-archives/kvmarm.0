Received: from mta0.migadu.com (out-77.mta0.migadu.com [91.218.175.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B60549EC61
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194084; cv=none; b=bpStlZSio2d7ehQkYeQ3dmct7M04gIss4o14ZyF7Wyh3cLywALJXyfsjT93YwfBblmoKNxtqq9a/KcoptbNz3QFMNQIDWV9ZGxYFLminzKu3/2vqlntb8/ebI0N4XRAqOkpfoCo4ocCnwBCKGvy92MKs9E9PJThjTXP3miKPfis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194084; c=relaxed/simple;
	bh=TP9YFxHVxzGhaAK0s14OTjuoNcODgFEjsneHKuYE33M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mtO5AkSFvX5En70QYD/ngzAA4fgTLz2YJWLjvzyWsfT6ulSCrI/oTP7wLiulXPIejhoS3lQtsHMgKi3Q0Bp8zb8mlMxgIjtI+M4YxjQ3GO4K+uPTXp5Ufrmc8MUvCvFSaCjHala/JrzEt5rGtZHPe5bQgLeqU0bV2XDlSM/tA/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V5kx+hW0; arc=none smtp.client-ip=91.218.175.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V5kx+hW0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=TP9YFxHVxzGhaAK0s14OTjuoNcODgFEjsneHKuYE33M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194080; v=1; x=1788798880;
 b=V5kx+hW0Dw+k0vYD5Nx0GTmRBXm9eLLVUnXfWG4NezrRnza2kLBV7AFM41pJog/fDM8D9mSm
 83GUZqSVscvrNnTOnVytWC7Nuk81we4Zf3Vaz79ej1O9ZM6Fu31+u2Y0EpEQ86yzpzxwHCxf/vT
 n/wNA7mL2KeQadW/ApUZS9ho=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 88521c3de77b7f74;
	Mon, 31 Aug 2026 16:34:40 +0000
X-Mizu-Trace-ID: 88521c3de77b7f74
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 05/17] KVM: arm64: Skip fixed-feature state flush for protected vCPUs
Date: Mon, 31 Aug 2026 17:34:09 +0100
Message-Id: <20260831163421.272420-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies the host's mdcr_el2, TWI/TWE and debug state
into the hyp vCPU on every entry, so for a protected vCPU the host's
trap configuration overrides the one pkvm_vcpu_init_traps() computed
at EL2. Move those copies into the non-protected branch, and sync the
debug state back for non-protected vCPUs only: a protected guest's
debug registers are hypervisor-owned, and it takes the host's TWI/TWE
at vCPU load. MDCR_EL2.TDA traps only the guest's own accesses; it
does not stop the world switch from loading host-supplied breakpoints
and MDSCR_EL1.

EL2's mdcr_el2 starts from 0, and HPMN == 0 is reserved without
FEAT_HPMN0. Set HPMN to the CPU's event counter count at vCPU load,
the value the host's copy carried; a protected guest's PMU accesses
trap regardless.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 31 +++++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ca7122b0bccdd..14e847b122abf 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -231,7 +231,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	u8 esr_ec;
 
 	fpsimd_sve_flush();
-	flush_debug_state(hyp_vcpu);
 
 	/*
 	 * If we deal with a non-protected guest and the state is potentially
@@ -241,7 +240,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
 			flush_hyp_vcpu_state(hyp_vcpu);
+
+		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
+		hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
+							 (HCR_TWI | HCR_TWE);
+
+		hyp_vcpu->vcpu.arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
 		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
+		flush_debug_state(hyp_vcpu);
 	} else {
 		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
 	}
@@ -249,17 +255,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	/* __hyp_running_vcpu must be NULL in a guest context. */
 	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
 
-	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	/*
-	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
-	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
-	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
+	 * A host-injected vSError is masked by the guest's own PSTATE.A, so it
+	 * applies to protected guests too.
 	 */
-	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
-	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
-						 (HCR_TWI | HCR_TWE | HCR_VSE);
-
-	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
+	hyp_vcpu->vcpu.arch.hcr_el2 &= ~HCR_VSE;
+	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) & HCR_VSE;
+	hyp_vcpu->vcpu.arch.vsesr_el2 = host_vcpu->arch.vsesr_el2;
 
 	flush_hyp_vgic_state(hyp_vcpu);
 
@@ -288,7 +290,8 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
-	sync_debug_state(hyp_vcpu);
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		sync_debug_state(hyp_vcpu);
 
 	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
@@ -329,6 +332,12 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 		/* Propagate WFx trapping flags */
 		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
 		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
+
+		/* HPMN == 0 is reserved without FEAT_HPMN0. */
+		if (system_supports_pmuv3())
+			u64p_replace_bits(&hyp_vcpu->vcpu.arch.mdcr_el2,
+					  FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0)),
+					  MDCR_EL2_HPMN);
 	} else {
 		memcpy(&hyp_vcpu->vcpu.arch.fgt, hyp_vcpu->host_vcpu->arch.fgt,
 		       sizeof(hyp_vcpu->vcpu.arch.fgt));
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..e85f13233da08 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -102,7 +102,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP)) {
 		val |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
-		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME | MDCR_EL2_HPMN_MASK);
+		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME);
 	}
 
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
-- 
2.39.5

