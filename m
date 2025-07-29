Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2D5299A84
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 18:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753813437; cv=none; b=IbqP5mcAPPr0d+TGszS92aQ1ZcYL5vq7m1cQ/Yqy9aUSaZn1iNAxjpOILPjD5+dqTaVKxAd6wXYxTpqWC5kRjoZ9wvV4+LQttJMGmWj5mRawQCX7Wi31+GYauIpQrV5c+DDU/E52QxhQ36WC+mDO/A43+v3iS3kIkASLsOMhUBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753813437; c=relaxed/simple;
	bh=k7uqR5IEv1N0Hln+gIdzderMaHdc+1Z+NR2wRvG/u/A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b0oIZyocMZG8HsiufXpFT2hray1iFykj0RfwO88ura06qGgoCjGQPB68gHNyMYBlpUWerMPlA1fD/YVIVPjtnbST/YmQQoeQCFdDY2aB1+e0wvU9cLiRGxDYV0qbxAjpnWUCRHFSqwnMqnUhWWENYm6CMb3/fD2oEyPqQWB0y2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VdQmBBdR; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VdQmBBdR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753813432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=131sPbbc8zPbyfVWSJh6vp4OIcM62Hi2I/b66LFxmZs=;
	b=VdQmBBdRDq6guq+xz85vUcyTpqhCOMfnihY7DlWSzOa5/Av1BsdL4zQWF3SORQPaHkuyAH
	x1mKy19JPXrMUleQ1WtPuvlBD58h5HLm8rdQ56iDoxM47oUVsU0FlU56htk3ymxohDFiGp
	zA3Yqm5F55Of9+GixB4IiRRQIrjCgL4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH] KVM: arm64: nv: Handle SEAs due to VNCR redirection
Date: Tue, 29 Jul 2025 11:23:42 -0700
Message-Id: <20250729182342.3281742-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

System register accesses redirected to the VNCR page can also generate
external aborts just like any other form of memory access. Route to
kvm_handle_guest_sea() for potential APEI handling, falling back to a
vSError if the kernel didn't handle the abort.

Take the opportunity to throw out the useless kvm_ras.h which provided a
helper with a single callsite...

Cc: Jiaqi Yan <jiaqiyan@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/include/asm/kvm_ras.h | 25 -------------------------
 arch/arm64/kvm/mmu.c             | 29 +++++++++++++++++------------
 arch/arm64/kvm/nested.c          |  3 +++
 4 files changed, 21 insertions(+), 37 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_ras.h

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ae563ebd6aee..e4069f2ce642 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -180,6 +180,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
 
+int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
deleted file mode 100644
index 9398ade632aa..000000000000
--- a/arch/arm64/include/asm/kvm_ras.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2018 - Arm Ltd */
-
-#ifndef __ARM64_KVM_RAS_H__
-#define __ARM64_KVM_RAS_H__
-
-#include <linux/acpi.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-
-#include <asm/acpi.h>
-
-/*
- * Was this synchronous external abort a RAS notification?
- * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
- */
-static inline int kvm_handle_guest_sea(void)
-{
-	/* apei_claim_sea(NULL) expects to mask interrupts itself */
-	lockdep_assert_irqs_enabled();
-
-	return apei_claim_sea(NULL);
-}
-
-#endif /* __ARM64_KVM_RAS_H__ */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1c78864767c5..9a45daf817bf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -4,19 +4,20 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/acpi.h>
 #include <linux/mman.h>
 #include <linux/kvm_host.h>
 #include <linux/io.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/signal.h>
 #include <trace/events/kvm.h>
+#include <asm/acpi.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/kvm_pkvm.h>
-#include <asm/kvm_ras.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/virt.h>
@@ -1811,6 +1812,19 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
+int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Give APEI the opportunity to claim the abort before handling it
+	 * within KVM. apei_claim_sea() expects to be called with IRQs enabled.
+	 */
+	lockdep_assert_irqs_enabled();
+	if (apei_claim_sea(NULL) == 0)
+		return 1;
+
+	return kvm_inject_serror(vcpu);
+}
+
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
@@ -1834,17 +1848,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int ret, idx;
 
-	/* Synchronous External Abort? */
-	if (kvm_vcpu_abt_issea(vcpu)) {
-		/*
-		 * For RAS the host kernel may handle this abort.
-		 * There is no need to pass the error into the guest.
-		 */
-		if (kvm_handle_guest_sea())
-			return kvm_inject_serror(vcpu);
-
-		return 1;
-	}
+	if (kvm_vcpu_abt_issea(vcpu))
+		return kvm_handle_guest_sea(vcpu);
 
 	esr = kvm_vcpu_get_esr(vcpu);
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index efb37aad11ec..4f741ba24b48 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1289,6 +1289,9 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 
 	BUG_ON(!(esr & ESR_ELx_VNCR_SHIFT));
 
+	if (kvm_vcpu_abt_issea(vcpu))
+		return kvm_handle_guest_sea(vcpu);
+
 	if (esr_fsc_is_permission_fault(esr)) {
 		inject_vncr_perm(vcpu);
 	} else if (esr_fsc_is_translation_fault(esr)) {

base-commit: 18ec25dd0e97653cdb576bb1750c31acf2513ea7
-- 
2.39.5

