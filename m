Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBCE477E51
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 09:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327186; cv=none; b=IPkYCJuA7sBINeYlAih6ll7/xMpZtMDdjADiCNT06TYVwOTWIzW9UhEzbovaBtevyou+hcuAidjPl4JNwapBuASFvLpxwuJOzH4Le7uAtr9h5c3lFxuYFPDVNxxey9cZ/2hms95VgvnSG1QuWcxoo6uFILrkn6QpINWrOBk04dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327186; c=relaxed/simple;
	bh=Y9ZAnxNOH2lrJRb3LRr5HWYioWfcGxX3qidODsECads=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=klmGIk4Qq/lzmifQA145ZVCMJVYQqXF6mYf+8C31IgC0LLkk2f2Ys+6ySOcSmCXTuAd2XuYt85sQFLxcLj6j4/NCBhC3fNzA0y9AcPcEzv3dw4+4w1h0JAlBPooF+xYW1VVuezR7Cldyieu2Z5FR76eNSaJWXtEVow7xsD3TO6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=crUleeVm; arc=none smtp.client-ip=95.215.58.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="crUleeVm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Y9ZAnxNOH2lrJRb3LRr5HWYioWfcGxX3qidODsECads=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790327182; v=1; x=1790931982;
 b=crUleeVmfIlutHO5eNR+jLwnRRv15dZpW06mzdKd0s1X+7Xg9ol/yHJECz796zSqWriZdPZ9
 oydZmhpyPrGj8yXBIIlbXI4yFXUrEgo8EDrcNq1YL0pFmqwbQB7NtMRwK7sAkDpBGNhG9aQjag/
 JUC7v+ekj9W3v82/sOK3xW1E=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 09c974e8f8fc8fd1;
	Fri, 25 Sep 2026 09:06:21 +0000
X-Mizu-Trace-ID: 09c974e8f8fc8fd1
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/4] KVM: arm64: Use the host's HCR_EL2 for non-protected VMs in pKVM
Date: Fri, 25 Sep 2026 10:06:18 +0100
Message-Id: <20260925090619.852995-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260925090619.852995-1-fuad.tabba@linux.dev>
References: <20260925090619.852995-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In pKVM, a non-protected VM gets only TWI, TWE and VSE from the HCR_EL2
the host computes for it. EL2 sets the rest in pkvm_vcpu_reset_hcr(),
which covers only part of vcpu_set_hcr(). On a CPU with MTE the VM can
then read GMID_EL1, on one without FGT it can execute a TLBI OS its ID
registers hide, and it never gets the host's TVM, VI or VF.

Use the host's HCR_EL2 on every entry instead, except for the bits EL2
owns. The other bits only control what the VM's own execution traps on
and which virtual exceptions are pending for it. The host computes them
from the vCPU's features, ID registers and flags, which EL2 already
takes from the host for a non-protected VM, as it takes MDCR_EL2,
HCRX_EL2 and the fine-grained traps.

ATA, an owned bit, stays clear, as pKVM doesn't support MTE for any
guest. TID2 and TID4 move to pvm_init_traps_hcr(), since EL2 now sets
them only for a protected VM. A protected VM's HCR_EL2 is unchanged.

Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_arm.h       |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  7 ++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 18 ++++++++----------
 4 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4bfbd827c5aa7..8d187650e463e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -30,6 +30,7 @@
 #define HCR_AMVOFFEN	__HCR(AMVOFFEN)
 #define HCR_TICAB	__HCR(TICAB)
 #define HCR_TID4	__HCR(TID4)
+#define HCR_GPF		__HCR(GPF)
 #define HCR_FIEN	__HCR(FIEN)
 #define HCR_FWB		__HCR(FWB)
 #define HCR_NV2		__HCR(NV2)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c904647d2f760..75b1122db4c91 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -12,6 +12,19 @@
 #include <nvhe/gfp.h>
 #include <nvhe/spinlock.h>
 
+/*
+ * HCR_EL2 bits EL2 owns for a non-protected VM, whatever the host sets: those
+ * that restrict the guest, configure EL2 or what it switches (E2H, RW), or
+ * enable state EL2 doesn't switch or support. RES0 is included, so a bit comes
+ * from the host only once arch/arm64/tools/sysreg describes it.
+ */
+#define PKVM_HCR_EL2_OWNED	((HCR_GUEST_FLAGS & ~(HCR_TWI | HCR_TWE)) | HCR_BSU |	\
+				 HCR_E2H | HCR_TGE | HCR_TEA | HCR_GPF | HCR_TERR |	\
+				 HCR_FWB | HCR_DC | HCR_ID | HCR_CD | HCR_NV |		\
+				 HCR_NV1 | HCR_NV2 | HCR_API | HCR_APK | HCR_ATA |	\
+				 HCR_DCT | HCR_FIEN | HCR_AMVOFFEN | HCR_ENSCXT |	\
+				 HCR_EL2_RES0)
+
 /*
  * Holds the relevant data for maintaining the vcpu state completely at hyp.
  */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626adb..dec99d5bbee78 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -216,6 +216,7 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	u64 host_hcr_mask = HCR_TWI | HCR_TWE | HCR_VSE;
 
 	fpsimd_sve_flush();
 	flush_debug_state(hyp_vcpu);
@@ -228,6 +229,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
 			flush_hyp_vcpu_state(hyp_vcpu);
+		host_hcr_mask = ~PKVM_HCR_EL2_OWNED;
 	} else {
 		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
 	}
@@ -241,9 +243,8 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
 	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
 	 */
-	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
-	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
-						 (HCR_TWI | HCR_TWE | HCR_VSE);
+	hyp_vcpu->vcpu.arch.hcr_el2 &= ~host_hcr_mask;
+	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) & host_hcr_mask;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index affc9595fda20..2cf704036871b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -30,6 +30,7 @@ unsigned int kvm_host_sve_max_vl;
  */
 static DEFINE_PER_CPU(struct pkvm_hyp_vcpu *, loaded_hyp_vcpu);
 
+/* A non-protected VM keeps only the PKVM_HCR_EL2_OWNED bits of the HCR_EL2 set here. */
 static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
@@ -47,13 +48,6 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		vcpu->arch.hcr_el2 |= HCR_FWB;
 
-	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
-	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE) &&
-	    kvm_read_vm_id_reg(vcpu->kvm, SYS_CTR_EL0) == read_cpuid(CTR_EL0))
-		vcpu->arch.hcr_el2 |= HCR_TID4;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TID2;
-
 	/*
 	 * At EL2, vcpu_el1_is_32bit() reads HCR_EL2.RW, and EL2 switches the
 	 * *32_EL2 registers when it returns true; they're UNDEFINED without AArch32 EL1.
@@ -64,9 +58,6 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
-
-	if (kvm_has_mte(vcpu->kvm))
-		vcpu->arch.hcr_el2 |= HCR_ATA;
 }
 
 static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
@@ -84,6 +75,13 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	 */
 	val |= HCR_TACR | HCR_TIDCP | HCR_TID3 | HCR_TID1;
 
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE) &&
+	    kvm_read_vm_id_reg(kvm, SYS_CTR_EL0) == read_cpuid(CTR_EL0))
+		val |= HCR_TID4;
+	else
+		val |= HCR_TID2;
+
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
 		val |= HCR_TERR | HCR_TEA;
 		val &= ~(HCR_FIEN);
-- 
2.39.5

