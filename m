Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642F3AFAEF
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672482; cv=none; b=C9BQfKc+PqDyM8CS9ZbzJra+hKOSVCbIiZbh7YlhWHop/5gTqySFfjY3SE/sJDXlnZmbNklM4fq7ptgIEzQYo8u8SDUh/Qdcowfb7mMMl10Bompu0ZPPIiK8Ku8KxkQAzhTIwGiflxKaDT/7+uG41dbScP2zP2rVEKk4tASwcgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672482; c=relaxed/simple;
	bh=K0ZekEDjY5VG7aCtWBzRLRTbCI3fC9nROB+rmBb3umg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hh191roKbEyTmbsEeHRZN1hDPxN+hcSnI6CyypI3xfkvHejrHsgjR11PmObUIDl9anVzF2V5yoFNN7Z+5DO4T9ErhZknOQiqbekZGqegeBw/Wufd+o/EucvNda+jfUauuUx13XtrFUncQGpMntlGR4wSQHgHC1ZrtKfZQvx0Qas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WPZkTAFy; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WPZkTAFy"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=K0ZekEDjY5VG7aCtWBzRLRTbCI3fC9nROB+rmBb3umg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790672478; v=1; x=1791277278;
 b=WPZkTAFyD8gE7PaFuIcsKkInVw0wvzMEiAaMRTbFqHUjIN0uQ+Tu9oPeNWoYXtIKjVSEziLY
 qkNRWY06MeCWVYnwrrDujUmZJEdpGxPltlUbG9RswifEwd2j50zvG82ruYMqrpMVCISLjLXQh+E
 +jkvI6y952yyZZzUHg9Z0g6s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id eacd41c09129df34;
	Tue, 29 Sep 2026 09:01:18 +0000
X-Mizu-Trace-ID: eacd41c09129df34
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: arm64: Use the host's HCR_EL2 for non-protected VMs in pKVM
Date: Tue, 29 Sep 2026 10:00:30 +0100
Message-Id: <20260929090031.3829185-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260929090031.3829185-1-fuad.tabba@linux.dev>
References: <20260929090031.3829185-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For each vCPU, pKVM's EL2 builds its own HCR_EL2 and takes only TWI, TWE
and VSE from the host's value on each entry. For a non-protected VM it
has fallen behind the host's: on a CPU with MTE the guest can read
GMID_EL1, on one with FEAT_EVT2 but no FGT it can execute a TLBI OS its
ID registers hide, an interrupt injected without a vGIC (VI, VF) never
arrives, and set/way emulation loses the TVM trap it relies on.

For a non-protected VM, also take the bits the host varies with the VM's
configuration or at runtime: VI, VF, TVM, TID2, TID4, TID5 and TTLBOS.
They only pend interrupts for, or add traps to, a VM the host controls.
The traps exit to the host, which handles them as it does without pKVM.
The bits that change what EL2 does on entry and exit (E2H, RW, API/APK)
or depend only on the CPU (TEA, TERR, FWB) stay EL2's. A protected VM
still takes only TWI, TWE and VSE.

EL2 now sets TID2 or TID4 only for a protected VM, and never sets ATA,
as the host rejects KVM_CAP_ARM_MTE in pKVM.

Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  7 ++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 18 ++++++++----------
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c904647d2f760..5c050f21066ab 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -12,6 +12,15 @@
 #include <nvhe/gfp.h>
 #include <nvhe/spinlock.h>
 
+/*
+ * HCR_EL2 bits EL2 takes from the host on each entry, per VM type. The rest
+ * are EL2's own and nothing the host sets there reaches the guest.
+ */
+#define PKVM_HCR_EL2_HOST_PVM	(HCR_EL2_TWI | HCR_EL2_TWE | HCR_EL2_VSE)
+#define PKVM_HCR_EL2_HOST_NPVM	(PKVM_HCR_EL2_HOST_PVM | HCR_EL2_VI | HCR_EL2_VF |	\
+				 HCR_EL2_TVM | HCR_EL2_TID2 | HCR_EL2_TID4 |		\
+				 HCR_EL2_TID5 | HCR_EL2_TTLBOS)
+
 /*
  * Holds the relevant data for maintaining the vcpu state completely at hyp.
  */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626adb..ac64a036b0a95 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -216,6 +216,7 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	u64 host_hcr_mask = PKVM_HCR_EL2_HOST_PVM;
 
 	fpsimd_sve_flush();
 	flush_debug_state(hyp_vcpu);
@@ -228,6 +229,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
 			flush_hyp_vcpu_state(hyp_vcpu);
+		host_hcr_mask = PKVM_HCR_EL2_HOST_NPVM;
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
index 62d432144d44c..7ef09867f2802 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -30,6 +30,7 @@ unsigned int kvm_host_sve_max_vl;
  */
 static DEFINE_PER_CPU(struct pkvm_hyp_vcpu *, loaded_hyp_vcpu);
 
+/* The PKVM_HCR_EL2_HOST_{PVM,NPVM} bits of this value come from the host on each entry. */
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
 	 * Without AArch32 EL1, leave RW set and let the entry fail with an
 	 * illegal exception return: the *32_EL2 registers EL2 would otherwise
@@ -65,9 +59,6 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
-
-	if (kvm_has_mte(vcpu->kvm))
-		vcpu->arch.hcr_el2 |= HCR_ATA;
 }
 
 static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
@@ -85,6 +76,13 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	 */
 	val |= HCR_TACR | HCR_TIDCP | HCR_TID3 | HCR_TID1;
 
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE) &&
+	    kvm_read_vm_id_reg(kvm, SYS_CTR_EL0) == read_cpuid(CTR_EL0))
+		val |= HCR_EL2_TID4;
+	else
+		val |= HCR_EL2_TID2;
+
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
 		val |= HCR_TERR | HCR_TEA;
 		val &= ~(HCR_FIEN);
-- 
2.39.5

