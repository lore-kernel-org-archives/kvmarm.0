Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38A1518128
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863090; cv=none; b=BcwIBAni/QOLweZrOsyj5ECR8egJcaXhGbp3UVswc9o9avrpB8Is8cttVodFAnU5Xn3HoHePgjTjd5gNEkli3ZCB+9KzL2WAwAGfeb5BUGMCZF/E+j4dzt9NfRAHwYQVlpKAmuNzlTrjM5nmOexA4KgCuz7MQSZ2M+F+jhFIZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863090; c=relaxed/simple;
	bh=Cw9s/b5IB4JlA/D2CXvucZW6/QX42fpYEYaXMoF6ixw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KNL5pQwPkhZ29EqebEh7vejvSNAvD3G8tMukJ59x2T1pH/od0x6Nbe/7NNzQGzB7RkHtS7xQcu5PPCGRofwbsF3yu9jaWKjPfVaSJFoTd8Rv6tBN/IHeU16zdaALsx0euCTxVa+FzXrojuxEdjIHAiT4bVQmNLghU8Eit7z75T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I9I7Hj4a; arc=none smtp.client-ip=95.215.58.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I9I7Hj4a"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Cw9s/b5IB4JlA/D2CXvucZW6/QX42fpYEYaXMoF6ixw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863081; v=1; x=1791467881;
 b=I9I7Hj4a4FQik0b+YSkWCUC6vZ9k3Whx1uGpGh6nhPB/OhU8KeiyqYucRTXl1uOhPZynXjoa
 GheyTPIHfCZQlqweNprjyom/n2yGBn0SmGwU8T2IVHAw5Sy5dK9XirLSdANX260/JHrs/RNJghD
 FKKs6acFg8ceFTYacyRbHt5U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 42d821f70d7a79a6;
	Thu, 01 Oct 2026 13:58:01 +0000
X-Mizu-Trace-ID: 42d821f70d7a79a6
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 06/18] KVM: arm64: Skip fixed-feature state flush for protected vCPUs
Date: Thu,  1 Oct 2026 14:56:59 +0100
Message-Id: <20261001135711.1640520-7-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
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
at EL2. Move the mdcr_el2 and TWI/TWE copies into the non-protected
branch, and return early from flush_debug_state() and
sync_debug_state() for a protected vCPU: its debug registers are
hypervisor-owned, and it takes the host's TWI/TWE at vCPU load.
MDCR_EL2.TDA traps only the guest's own accesses; it doesn't stop the
world switch from loading host-supplied breakpoints and MDSCR_EL1.

EL2's mdcr_el2 starts from 0, and HPMN == 0 is reserved without
FEAT_HPMN0. Set HPMN at vCPU load to PMCR_EL0.N on a PE whose
ID_AA64DFR0_EL1 implements PMUv3, the value the host's copy carried,
read as kvm_init_host_debug_data() reads it: the PMUv3 cpucap is
system-wide and off without CONFIG_HW_PERF_EVENTS. A protected guest's
PMU accesses trap regardless.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 34 ++++++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e3f4bbb623492..b7b9f5afb673b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -200,6 +200,9 @@ static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return;
+
 	hyp_vcpu->vcpu.arch.debug_owner = host_vcpu->arch.debug_owner;
 
 	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu)) {
@@ -218,6 +221,9 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return;
+
 	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
 		host_vcpu->arch.vcpu_debug_state = hyp_vcpu->vcpu.arch.vcpu_debug_state;
 	else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu))
@@ -241,6 +247,12 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
 	} else {
 		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
@@ -249,17 +261,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
 
@@ -326,9 +334,17 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 		return;
 
 	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+
 		/* Propagate WFx trapping flags */
 		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
 		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
+
+		/* HPMN == 0 is reserved without FEAT_HPMN0. */
+		if (pmuv3_implemented(SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0)))
+			u64p_replace_bits(&hyp_vcpu->vcpu.arch.mdcr_el2,
+					  FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0)),
+					  MDCR_EL2_HPMN);
 	} else {
 		memcpy(&hyp_vcpu->vcpu.arch.fgt, hyp_vcpu->host_vcpu->arch.fgt,
 		       sizeof(hyp_vcpu->vcpu.arch.fgt));
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 0e90de74778cf..8f3d9c293d186 100644
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

