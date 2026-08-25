Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF206318EEE;
	Tue, 25 Aug 2026 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673681; cv=none; b=KA+y8RHMdgUfuoo8zuB33hQBA2yOrAo867JDzlRDjXtaKVHW4rqiA8Ig+yTzQm0Em2J+8LHIEm3rm7duCL1nX/mljj/A4Ba22eCWX3WAk7Mi/jKFsWPSQ6oWY5qZYRAyYp5rAioyfbF7nyjpCXxHlhhOv/dpYaimO58HSXQV/kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673681; c=relaxed/simple;
	bh=btC+NUubidig9Ed/d2ywLChFedyhilKG2Dr7V4xBm7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D6gkozWkfTgErNjXnfuv1s81QPNiYumGDc0zhvDZD30ZVc+ZYMMdwFhUK3AiInrQWsqXET3QEH9A6aR0mDo0xPUp8JxF5FkypCy5cDkTtb7IGCisrNxCvFGkyiYAIXQnlwDveZnvJ3Md4igq3qXfHzCn2UOf1u3oHXV0mM6XBr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyGw1Fw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyGw1Fw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C359A1F00A3A;
	Tue, 25 Aug 2026 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673679;
	bh=RCpZ6I8gJKC84YSYpuYu+qK0qlSMETmmTK2jYvJjU/M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fyGw1Fw3VY1oc8Q/kFgwnp4YgxP5B8a521/LXjnvvkbQDm5Zxx5mCzZwqNefHTn2j
	 jJ3NeLgzsmLkFQdX2ZhB2X7iCy6B4YFFG7o9ca6yKN3EpnBwbgjb/Am6bjEAtYA5ct
	 rDaJSCPSKTMgYhpbsyBEnQyr50HN3EfE3lkGWbK3KRgHC5QhCvJZKGaRnNjHnUnhV2
	 G1iGYchCDv3g5fii58hD4i8YL5W0nIt0p20HIL3UoArG3ZAjnl51xwtnPsfRsgPWzr
	 J2RMIXfAzf3FK2TgtaATJO/a02CVo1u6xEPZ0Gpwc4ApVW47R4I+U0KPEs+7UTGCD1
	 /FLss+AplflKQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 25 Aug 2026 17:00:35 +0100
Subject: [PATCH 1/8] KVM: arm64: Propagate and use esr in s2fd when
 handling guest aborts
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-kvm-arm-prefault-v1-1-befe8947702e@kernel.org>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
In-Reply-To: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=19029; i=ljs@kernel.org;
 h=from:subject:message-id; bh=btC+NUubidig9Ed/d2ywLChFedyhilKG2Dr7V4xBm7s=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ69zg1NgamZcllhrX3rGYxFnPY+vGy55QfCzkzjVOTZ
 k48wLC2o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPR4mRkWL5v/oZJzyyuVt87
 79BYwP4gd7FBvp1F7Pav999UB03ff4Phr+Tb9Ym6exN6fz35c+9rtNyuCv5Zi665ad2/1l3sFLt
 OlQsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

kvm_handle_guest_abort() establishes a kvm_s2_fault_desc data structure,
s2fd, to store and propagate state to either pkvm_mem_abort(), gmem_abort()
or user_mem_abort() handlers.

Each of these, however, examines the Exception Syndrome Register (ESR) via
s2fd->vcpu.

Introduce an s2fd->esr field to abstract this and propagate it to callers.

The value of this (beyond refactoring) is to be able to later generate
faults with a synthetic esr, specifically to implement stage 2 page table
pre-faulting.

Abstract esr-specific predicates and helpers to the esr.h header and either
have vcpu wrappers call these, or eliminate them if they are not used
elsewhere.

Provide kvm_s2_fault_is_[write,exec,perm]() helpers for convenience.

Since kvm_s2_fault_map() either sets perm_fault_granule to the permission
fault granule or 0 if not a permission fault, implement
kvm_s2_perm_fault_granule() to do this directly.

Abort handlers which use kvm_s2_fault_desc - gmem_abort() and
user_mem_abort() - now only reference s2fd->esr and do not look it up in
any other way, which makes it safe to pass a synthetic s2fd->esr value to
these functions.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/include/asm/esr.h         | 129 +++++++++++++++++++++++++----------
 arch/arm64/include/asm/kvm_emulate.h |  52 ++++----------
 arch/arm64/kvm/mmu.c                 |  80 +++++++++++++---------
 3 files changed, 156 insertions(+), 105 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index f816f5d77f1a..162e90c832e9 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -437,6 +437,32 @@
 #ifndef __ASSEMBLER__
 #include <asm/types.h>
 
+static inline u8 esr_trap_get_class(unsigned long esr)
+{
+	return ESR_ELx_EC(esr);
+}
+
+static inline bool esr_trap_is_iabt(unsigned long esr)
+{
+	return esr_trap_get_class(esr) == ESR_ELx_EC_IABT_LOW;
+}
+
+static inline bool esr_abt_is_s1ptw(unsigned long esr)
+{
+	return esr & ESR_ELx_S1PTW;
+}
+
+/* Always check for S1PTW *before* using this. */
+static inline bool esr_dabt_is_write(unsigned long esr)
+{
+	return esr & ESR_ELx_WNR;
+}
+
+static inline bool esr_dabt_is_cm(unsigned long esr)
+{
+	return esr & ESR_ELx_CM;
+}
+
 static inline unsigned long esr_brk_comment(unsigned long esr)
 {
 	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
@@ -460,75 +486,104 @@ static inline bool esr_is_ubsan_brk(unsigned long esr)
 	return (esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM;
 }
 
+static inline u8 esr_fsc_get_fault(unsigned long esr)
+{
+	return esr & ESR_ELx_FSC;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
-	esr = esr & ESR_ELx_FSC;
+	const u8 fault = esr_fsc_get_fault(esr);
 
-	return (esr == ESR_ELx_FSC_FAULT_L(3)) ||
-	       (esr == ESR_ELx_FSC_FAULT_L(2)) ||
-	       (esr == ESR_ELx_FSC_FAULT_L(1)) ||
-	       (esr == ESR_ELx_FSC_FAULT_L(0)) ||
-	       (esr == ESR_ELx_FSC_FAULT_L(-1));
+	return (fault == ESR_ELx_FSC_FAULT_L(3)) ||
+	       (fault == ESR_ELx_FSC_FAULT_L(2)) ||
+	       (fault == ESR_ELx_FSC_FAULT_L(1)) ||
+	       (fault == ESR_ELx_FSC_FAULT_L(0)) ||
+	       (fault == ESR_ELx_FSC_FAULT_L(-1));
 }
 
 static inline bool esr_fsc_is_permission_fault(unsigned long esr)
 {
-	esr = esr & ESR_ELx_FSC;
+	const u8 fault = esr_fsc_get_fault(esr);
 
-	return (esr == ESR_ELx_FSC_PERM_L(3)) ||
-	       (esr == ESR_ELx_FSC_PERM_L(2)) ||
-	       (esr == ESR_ELx_FSC_PERM_L(1)) ||
-	       (esr == ESR_ELx_FSC_PERM_L(0));
+	return (fault == ESR_ELx_FSC_PERM_L(3)) ||
+	       (fault == ESR_ELx_FSC_PERM_L(2)) ||
+	       (fault == ESR_ELx_FSC_PERM_L(1)) ||
+	       (fault == ESR_ELx_FSC_PERM_L(0));
 }
 
 static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
 {
-	esr = esr & ESR_ELx_FSC;
+	const u8 fault = esr_fsc_get_fault(esr);
 
-	return (esr == ESR_ELx_FSC_ACCESS_L(3)) ||
-	       (esr == ESR_ELx_FSC_ACCESS_L(2)) ||
-	       (esr == ESR_ELx_FSC_ACCESS_L(1)) ||
-	       (esr == ESR_ELx_FSC_ACCESS_L(0));
+	return (fault == ESR_ELx_FSC_ACCESS_L(3)) ||
+	       (fault == ESR_ELx_FSC_ACCESS_L(2)) ||
+	       (fault == ESR_ELx_FSC_ACCESS_L(1)) ||
+	       (fault == ESR_ELx_FSC_ACCESS_L(0));
 }
 
 static inline bool esr_fsc_is_excl_atomic_fault(unsigned long esr)
 {
-	esr = esr & ESR_ELx_FSC;
-
-	return esr == ESR_ELx_FSC_EXCL_ATOMIC;
+	return esr_fsc_get_fault(esr) == ESR_ELx_FSC_EXCL_ATOMIC;
 }
 
 static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
 {
-	esr &= ESR_ELx_FSC;
+	const u8 fault = esr_fsc_get_fault(esr);
+
+	return (fault == ESR_ELx_FSC_ADDRSZ_L(3)) ||
+	       (fault == ESR_ELx_FSC_ADDRSZ_L(2)) ||
+	       (fault == ESR_ELx_FSC_ADDRSZ_L(1)) ||
+	       (fault == ESR_ELx_FSC_ADDRSZ_L(0)) ||
+	       (fault == ESR_ELx_FSC_ADDRSZ_L(-1));
+}
+
+static inline bool esr_abt_is_exec_fault(unsigned long esr)
+{
+	return esr_trap_is_iabt(esr) && !esr_abt_is_s1ptw(esr);
+}
 
-	return (esr == ESR_ELx_FSC_ADDRSZ_L(3))	||
-	       (esr == ESR_ELx_FSC_ADDRSZ_L(2))	||
-	       (esr == ESR_ELx_FSC_ADDRSZ_L(1)) ||
-	       (esr == ESR_ELx_FSC_ADDRSZ_L(0))	||
-	       (esr == ESR_ELx_FSC_ADDRSZ_L(-1));
+static inline bool esr_abt_is_sea(unsigned long esr)
+{
+	const u8 fault = esr_fsc_get_fault(esr);
+
+	switch (fault) {
+	case ESR_ELx_FSC_EXTABT:
+	case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
+	case ESR_ELx_FSC_SECC:
+	case ESR_ELx_FSC_SECC_TTW(-1) ... ESR_ELx_FSC_SECC_TTW(3):
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* Not valid for negative levels. */
+static inline u64 esr_fsc_get_level(unsigned long esr)
+{
+	return esr & ESR_ELx_FSC_LEVEL;
 }
 
 static inline bool esr_fsc_is_sea_ttw(unsigned long esr)
 {
-	esr = esr & ESR_ELx_FSC;
+	const u8 fault = esr_fsc_get_fault(esr);
 
-	return (esr == ESR_ELx_FSC_SEA_TTW(3)) ||
-	       (esr == ESR_ELx_FSC_SEA_TTW(2)) ||
-	       (esr == ESR_ELx_FSC_SEA_TTW(1)) ||
-	       (esr == ESR_ELx_FSC_SEA_TTW(0)) ||
-	       (esr == ESR_ELx_FSC_SEA_TTW(-1));
+	return (fault == ESR_ELx_FSC_SEA_TTW(3)) ||
+	       (fault == ESR_ELx_FSC_SEA_TTW(2)) ||
+	       (fault == ESR_ELx_FSC_SEA_TTW(1)) ||
+	       (fault == ESR_ELx_FSC_SEA_TTW(0)) ||
+	       (fault == ESR_ELx_FSC_SEA_TTW(-1));
 }
 
 static inline bool esr_fsc_is_secc_ttw(unsigned long esr)
 {
-	esr = esr & ESR_ELx_FSC;
+	const u8 fault = esr_fsc_get_fault(esr);
 
-	return (esr == ESR_ELx_FSC_SECC_TTW(3)) ||
-	       (esr == ESR_ELx_FSC_SECC_TTW(2)) ||
-	       (esr == ESR_ELx_FSC_SECC_TTW(1)) ||
-	       (esr == ESR_ELx_FSC_SECC_TTW(0)) ||
-	       (esr == ESR_ELx_FSC_SECC_TTW(-1));
+	return (fault == ESR_ELx_FSC_SECC_TTW(3)) ||
+	       (fault == ESR_ELx_FSC_SECC_TTW(2)) ||
+	       (fault == ESR_ELx_FSC_SECC_TTW(1)) ||
+	       (fault == ESR_ELx_FSC_SECC_TTW(0)) ||
+	       (fault == ESR_ELx_FSC_SECC_TTW(-1));
 }
 
 /* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a3c1928bdf74..811d7a68a9f9 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -411,18 +411,13 @@ static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
 
 static __always_inline bool kvm_vcpu_abt_iss1tw(const struct kvm_vcpu *vcpu)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
+	return esr_abt_is_s1ptw(kvm_vcpu_get_esr(vcpu));
 }
 
 /* Always check for S1PTW *before* using this. */
 static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR;
-}
-
-static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
-{
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_CM);
+	return esr_dabt_is_write(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
@@ -438,17 +433,12 @@ static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu
 
 static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
 {
-	return ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
+	return esr_trap_get_class(kvm_vcpu_get_esr(vcpu));
 }
 
 static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
-}
-
-static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
-{
-	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
+	return esr_trap_is_iabt(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
@@ -468,26 +458,9 @@ bool kvm_vcpu_trap_is_translation_fault(const struct kvm_vcpu *vcpu)
 	return esr_fsc_is_translation_fault(kvm_vcpu_get_esr(vcpu));
 }
 
-static inline
-u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
-{
-	unsigned long esr = kvm_vcpu_get_esr(vcpu);
-
-	BUG_ON(!esr_fsc_is_permission_fault(esr));
-	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
-}
-
 static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
 {
-	switch (kvm_vcpu_trap_get_fault(vcpu)) {
-	case ESR_ELx_FSC_EXTABT:
-	case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
-	case ESR_ELx_FSC_SECC:
-	case ESR_ELx_FSC_SECC_TTW(-1) ... ESR_ELx_FSC_SECC_TTW(3):
-		return true;
-	default:
-		return false;
-	}
+	return esr_abt_is_sea(kvm_vcpu_get_esr(vcpu));
 }
 
 static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
@@ -496,9 +469,9 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 	return ESR_ELx_SYS64_ISS_RT(esr);
 }
 
-static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
+static inline bool esr_abt_is_write_fault(unsigned long esr)
 {
-	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+	if (esr_abt_is_s1ptw(esr)) {
 		/*
 		 * Only a permission fault on a S1PTW should be
 		 * considered as a write. Otherwise, page tables baked
@@ -511,13 +484,18 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 		 * first), then a permission fault to allow the flags
 		 * to be set.
 		 */
-		return kvm_vcpu_trap_is_permission_fault(vcpu);
+		return esr_fsc_is_permission_fault(esr);
 	}
 
-	if (kvm_vcpu_trap_is_iabt(vcpu))
+	if (esr_trap_is_iabt(esr))
 		return false;
 
-	return kvm_vcpu_dabt_iswrite(vcpu);
+	return esr_dabt_is_write(esr);
+}
+
+static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
+{
+	return esr_abt_is_write_fault(kvm_vcpu_get_esr(vcpu));
 }
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 74e7e7f7564c..30d605e87b01 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1603,12 +1603,38 @@ struct kvm_s2_fault_desc {
 	struct kvm_s2_trans	*nested;
 	struct kvm_memory_slot	*memslot;
 	unsigned long		hva;
+	unsigned long		esr;
 };
 
+static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
+{
+	return esr_fsc_is_permission_fault(s2fd->esr);
+}
+
+static bool kvm_s2_fault_is_exec(const struct kvm_s2_fault_desc *s2fd)
+{
+	return esr_abt_is_exec_fault(s2fd->esr);
+}
+
+static bool kvm_s2_fault_is_write(const struct kvm_s2_fault_desc *s2fd)
+{
+	return esr_abt_is_write_fault(s2fd->esr);
+}
+
+static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
+{
+	u64 level;
+
+	if (!kvm_s2_fault_is_perm(s2fd))
+		return 0;
+	level = esr_fsc_get_level(s2fd->esr);
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
+}
+
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool write_fault, exec_fault;
-	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
+	const bool perm_fault = kvm_s2_fault_is_perm(s2fd);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
@@ -1632,8 +1658,8 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	else
 		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
 
-	write_fault = kvm_is_write_fault(s2fd->vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
+	write_fault = kvm_s2_fault_is_write(s2fd);
+	exec_fault = kvm_s2_fault_is_exec(s2fd);
 
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
@@ -1840,11 +1866,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 	return vma_shift;
 }
 
-static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
-{
-	return kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
-}
-
 static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 				     struct kvm_s2_fault_vma_info *s2vi)
 {
@@ -1910,7 +1931,7 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 		return ret;
 
 	s2vi->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
-				      kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
+				      kvm_s2_fault_is_write(s2fd) ? FOLL_WRITE : 0,
 				      &s2vi->map_writable, &s2vi->page);
 	if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
 		if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
@@ -1968,7 +1989,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
 
-	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && s2vi->map_non_cacheable)
+	if (kvm_s2_fault_is_exec(s2fd) && s2vi->map_non_cacheable)
 		return -ENOEXEC;
 
 	/*
@@ -1977,7 +1998,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	 * and trigger the exception here. Since the memslot is valid, inject
 	 * the fault back to the guest.
 	 */
-	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
+	if (esr_fsc_is_excl_atomic_fault(s2fd->esr)) {
 		kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
 		return 1;
 	}
@@ -1986,13 +2007,13 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 
 	if (s2vi->map_writable && (s2vi->device ||
 				   !memslot_is_logging(s2fd->memslot) ||
-				   kvm_is_write_fault(s2fd->vcpu)))
+				   kvm_s2_fault_is_write(s2fd)))
 		*prot |= KVM_PGTABLE_PROT_W;
 
 	if (s2fd->nested)
 		*prot = adjust_nested_fault_perms(s2fd->nested, *prot);
 
-	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
+	if (kvm_s2_fault_is_exec(s2fd))
 		*prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2vi->map_non_cacheable)
@@ -2034,8 +2055,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	if (mmu_invalidate_retry(kvm, s2vi->mmu_seq))
 		goto out_unlock;
 
-	perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
-			      kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
+	perm_fault_granule = kvm_s2_perm_fault_granule(s2fd);
 	mapping_size = s2vi->vma_pagesize;
 	pfn = s2vi->pfn;
 	gfn = s2vi->gfn;
@@ -2103,7 +2123,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 
 static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
-	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
+	const bool perm_fault = kvm_s2_fault_is_perm(s2fd);
 	struct kvm_s2_fault_vma_info s2vi = {};
 	enum kvm_pgtable_prot prot;
 	void *memcache;
@@ -2250,7 +2270,7 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s2_trans nested_trans, *nested = NULL;
-	unsigned long esr;
+	const unsigned long esr = kvm_vcpu_get_esr(vcpu);
 	phys_addr_t fault_ipa; /* The address we faulted on */
 	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
@@ -2259,11 +2279,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int ret, idx;
 
-	if (kvm_vcpu_abt_issea(vcpu))
+	if (esr_abt_is_sea(esr))
 		return kvm_handle_guest_sea(vcpu);
 
-	esr = kvm_vcpu_get_esr(vcpu);
-
 	/*
 	 * The fault IPA should be reliable at this point as we're not dealing
 	 * with an SEA.
@@ -2272,7 +2290,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	if (KVM_BUG_ON(ipa == INVALID_GPA, vcpu->kvm))
 		return -EFAULT;
 
-	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
+	is_iabt = esr_trap_is_iabt(esr);
 
 	if (esr_fsc_is_translation_fault(esr)) {
 		/* Beyond sanitised PARange (which is the IPA limit) */
@@ -2289,7 +2307,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
+	trace_kvm_guest_fault(*vcpu_pc(vcpu), esr,
 			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
 	/* Check the stage-2 fault is trans. fault or write fault */
@@ -2298,9 +2316,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	    !esr_fsc_is_access_flag_fault(esr) &&
 	    !esr_fsc_is_excl_atomic_fault(esr)) {
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
-			kvm_vcpu_trap_get_class(vcpu),
-			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
-			(unsigned long)kvm_vcpu_get_esr(vcpu));
+			esr_trap_get_class(esr),
+			(unsigned long)esr_fsc_get_fault(esr),
+			(unsigned long)esr);
 		return -EFAULT;
 	}
 
@@ -2349,7 +2367,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	gfn = ipa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
-	write_fault = kvm_is_write_fault(vcpu);
+	write_fault = esr_abt_is_write_fault(esr);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
 		/*
 		 * The guest has put either its instructions or its page-tables
@@ -2362,7 +2380,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		if (esr_abt_is_s1ptw(esr)) {
 			ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 			goto out_unlock;
 		}
@@ -2377,7 +2395,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * So let's assume that the guest is just being
 		 * cautious, and skip the instruction.
 		 */
-		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
+		if (kvm_is_error_hva(hva) && esr_dabt_is_cm(esr)) {
 			kvm_incr_pc(vcpu);
 			ret = 1;
 			goto out_unlock;
@@ -2409,14 +2427,14 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		.nested		= nested,
 		.memslot	= memslot,
 		.hva		= hva,
+		.esr		= esr,
 	};
 
 	if (kvm_vm_is_protected(vcpu->kvm)) {
 		ret = pkvm_mem_abort(&s2fd);
 	} else {
-		VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
-				!write_fault &&
-				!kvm_vcpu_trap_is_exec_fault(vcpu));
+		VM_WARN_ON_ONCE(kvm_s2_fault_is_perm(&s2fd) && !write_fault &&
+				!kvm_s2_fault_is_exec(&s2fd));
 
 		if (kvm_slot_has_gmem(memslot))
 			ret = gmem_abort(&s2fd);

-- 
2.55.0

