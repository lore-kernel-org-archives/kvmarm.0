Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDADC2139D4
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736529986; cv=none; b=qH3k4bjki7F/mv926q09/I/6MTRij0V7yChoqTdYZwCdM4CL8+rqmBTSRs7x3TxkDcXKrtVVrJT6ZkwV68hxG/DngVzhujqDWTrly5ost+eAprQJ1NhIz+gIq1qoBwmJyvD0sPb1SlQC1p3o4pWO6Wi+PsdRWMElOyMyZZEJbjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736529986; c=relaxed/simple;
	bh=IpyaYRNHV0lX6mQVKbr9brqKKZyszPyi08Z/mcESk48=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RwCrEbmUALSJJnmTGBavbWoAo8s8JXcNrvrwvXZbLckOD7/oIADqUHmiaOPln42j9uz4OXJdiZUXVXnEfCL9dCHBe2Mm0DfzxaVtr6L8Q/L0hzX8w4akIEVNVEEyOGDYXOeV5eYKGvLKnwWBv6/G0GhkbcJSJfd09Fux33aBnIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2E031477;
	Fri, 10 Jan 2025 09:26:52 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.2.80.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 436643F66E;
	Fri, 10 Jan 2025 09:26:22 -0800 (PST)
From: =?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	james.morse@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Cc: =?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>
Subject: [PATCH v1] arm64: Add TLB Conflict Abort Exception handler to KVM
Date: Fri, 10 Jan 2025 17:24:07 +0000
Message-ID: <20250110172411.39845-3-miko.lenczewski@arm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently, KVM does not handle the case of a stage 2 TLB conflict abort
exception. This can legitimately occurs when the guest is eliding full
BBM semantics as permitted by BBM level 2. In this case it is possible
for a confclit abort to be delivered to EL2. We handle that by
invalidating the full TLB.

The Arm ARM specifies that the worst-case invalidation is either a
`tlbi vmalls12e1` or a `tlbi alle1` (as per DDI0487K section D8.16.3).
We implement `tlbi alle1` by extending the existing
__kvm_flush_vm_context() helper to allow for differentiating between
inner-shareable and cpu-local invalidations.

This commit applies on top of v6.13-rc2 (fac04efc5c79).

Signed-off-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
---
 arch/arm64/include/asm/esr.h       |  8 ++++++++
 arch/arm64/include/asm/kvm_asm.h   |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  9 +++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c       |  9 +++++++--
 arch/arm64/kvm/mmu.c               | 13 +++++++++++++
 arch/arm64/kvm/vmid.c              |  2 +-
 7 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d1b1a33f9a8b..8a66f81ca291 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -121,6 +121,7 @@
 #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
 #define ESR_ELx_FSC_SECC	(0x18)
 #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
+#define ESR_ELx_FSC_TLBABT	(0x30)
 
 /* Status codes for individual page table levels */
 #define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + (n))
@@ -464,6 +465,13 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 	       (esr == ESR_ELx_FSC_ACCESS_L(0));
 }
 
+static inline bool esr_fsc_is_tlb_conflict_abort(unsigned long esr)
+{
+	esr = esr & ESR_ELx_FSC;
+
+	return esr == ESR_ELx_FSC_TLBABT;
+}
+
 /* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
 static inline bool esr_iss_is_eretax(unsigned long esr)
 {
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ca2590344313..095872af764a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -222,7 +222,7 @@ DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
-extern void __kvm_flush_vm_context(void);
+extern void __kvm_flush_vm_context(bool cpu_local);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6aa0b13d86e5..f44a7550f4a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -195,7 +195,7 @@ static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
 {
-	__kvm_flush_vm_context();
+	__kvm_flush_vm_context(false);
 }
 
 static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 48da9ca9763f..97f749ad63cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -261,10 +261,15 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	exit_vmid_context(&cxt);
 }
 
-void __kvm_flush_vm_context(void)
+void __kvm_flush_vm_context(bool cpu_local)
 {
 	/* Same remark as in enter_vmid_context() */
 	dsb(ish);
-	__tlbi(alle1is);
+
+	if (cpu_local)
+		__tlbi(alle1);
+	else
+		__tlbi(alle1is);
+
 	dsb(ish);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 3d50a1bd2bdb..564602fa4d62 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -213,10 +213,15 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	exit_vmid_context(&cxt);
 }
 
-void __kvm_flush_vm_context(void)
+void __kvm_flush_vm_context(bool cpu_local)
 {
 	dsb(ishst);
-	__tlbi(alle1is);
+
+	if (cpu_local)
+		__tlbi(alle1);
+	else
+		__tlbi(alle1is);
+
 	dsb(ish);
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..7c0d97449d23 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1756,6 +1756,19 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
+	if (esr_fsc_is_tlb_conflict_abort(esr)) {
+
+		/* Architecturely, at this stage 2 tlb conflict abort, we must
+		 * either perform a `tlbi vmalls12e1`, or a `tlbi alle1`. Due
+		 * to nesting of VMs, we would have to iterate all flattened
+		 * VMIDs to clean out a single guest, so we perform a `tlbi alle1`
+		 * instead to save time.
+		 */
+		__kvm_flush_vm_context(true);
+
+		return 1;
+	}
+
 	if (esr_fsc_is_translation_fault(esr)) {
 		/* Beyond sanitised PARange (which is the IPA limit) */
 		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 806223b7022a..d558428fcfed 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -66,7 +66,7 @@ static void flush_context(void)
 	 * the next context-switch, we broadcast TLB flush + I-cache
 	 * invalidation over the inner shareable domain on rollover.
 	 */
-	kvm_call_hyp(__kvm_flush_vm_context);
+	kvm_call_hyp(__kvm_flush_vm_context, false);
 }
 
 static bool check_update_reserved_vmid(u64 vmid, u64 newvmid)
-- 
2.45.2

