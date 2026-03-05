Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BC3368AA
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721937; cv=none; b=hOx2+tlIxO9Xl8X5kQClmPuRmQBHqGmUEHspFLgSDlsUc6BLksgbmwZw0ntPSaT4Ij62i8bv+8S3njoZ1f5V/m10GVZqsOiBfuVgKwrQ9vHSfhuJzsUTTqr8DsksMPmckk6P8gEQ8Y7xCDB9OQGWvWe0Q/fIiK9/yN0IrJ4rkkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721937; c=relaxed/simple;
	bh=V30WlUk8mfg0VCDcjV2AKi5OckRP+zWpOChynXeFjiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7VfLqFl22YdCu/GEm6DdGqNdchbTtbi2jF0V6X7G5N4UWy0yh2fQaT5Qh1iEmnIuPJAXYrWZVgxjNB78YLylj+UqC5jlMRivwQ5l2X1htK9b0pkaZNgfGx6ovZK5A3eMAy5h77ke2Z1jsXRltcEDVEb3JgxUN1lsCwOsqPqgMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pWr3Onuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pWr3Onuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF291C19423;
	Thu,  5 Mar 2026 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721937;
	bh=V30WlUk8mfg0VCDcjV2AKi5OckRP+zWpOChynXeFjiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWr3OnufuKjfYgzQyReme5g5EsWKfYeoKnt8b82SvGcBzpVef+ykKtv+cu/6GXXUT
	 bwjXhV9dvxeVQK7U61kHMF0E/PXTt9t9EEviJT4MoXoBfvlWVcn0Op7XGp/rHunPg7
	 0wfgLegwoR6VGbojSpnQV7aPt6vsFEQt+aeBMQVAk5razou6DeVvyxvZ/R/eDFMHZU
	 5x8gI10CrW/wx8u5vLqu5pVzednqfEIzoHKVSzyVr9XmGyR7M3OLRP9QjwyrTw7YEd
	 JteKy3BKF3kHCdBZN1Mbs2TPf+jMy0aLkpiLyKFA+og1JLLVMpq3Tpe5p+XRp1j6x6
	 e2uenunZIr98A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 25/36] KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
Date: Thu,  5 Mar 2026 14:43:38 +0000
Message-ID: <20260305144351.17071-26-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Host kernel accesses to pages that are inaccessible at stage-2 result in
the injection of a translation fault, which is fatal unless an exception
table fixup is registered for the faulting PC (e.g. for user access
routines). This is undesirable, since a get_user_pages() call could be
used to obtain a reference to a donated page and then a subsequent
access via a kernel mapping would lead to a panic().

Rework the spurious fault handler so that stage-2 faults injected back
into the host result in the target page being forcefully reclaimed when
no exception table fixup handler is registered.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/virt.h |  9 +++++++++
 arch/arm64/kvm/pkvm.c         | 12 ++++++++++++
 arch/arm64/mm/fault.c         | 17 +++++++++++------
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b51ab6840f9c..b546703c3ab9 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -94,6 +94,15 @@ static inline bool is_pkvm_initialized(void)
 	       static_branch_likely(&kvm_protected_mode_initialized);
 }
 
+#ifdef CONFIG_KVM
+bool pkvm_force_reclaim_guest_page(phys_addr_t phys);
+#else
+static inline bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
+{
+	return false;
+}
+#endif
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8be91051699e..32294bd21dde 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -563,3 +563,15 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	WARN_ON_ONCE(1);
 	return -EINVAL;
 }
+
+/*
+ * Forcefully reclaim a page from the guest, zeroing its contents and
+ * poisoning the stage-2 pte so that pages can no longer be mapped at
+ * the same IPA. The page remains pinned until the guest is destroyed.
+ */
+bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
+{
+	int ret = kvm_call_hyp_nvhe(__pkvm_force_reclaim_guest_page, phys);
+
+	return !ret || ret == -EAGAIN;
+}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 3abfc7272d63..7eacc7b45c1f 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -289,9 +289,6 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	if (!is_el1_data_abort(esr) || !esr_fsc_is_translation_fault(esr))
 		return false;
 
-	if (is_pkvm_stage2_abort(esr))
-		return false;
-
 	local_irq_save(flags);
 	asm volatile("at s1e1r, %0" :: "r" (addr));
 	isb();
@@ -302,8 +299,14 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	 * If we now have a valid translation, treat the translation fault as
 	 * spurious.
 	 */
-	if (!(par & SYS_PAR_EL1_F))
+	if (!(par & SYS_PAR_EL1_F)) {
+		if (is_pkvm_stage2_abort(esr)) {
+			par &= SYS_PAR_EL1_PA;
+			return pkvm_force_reclaim_guest_page(par);
+		}
+
 		return true;
+	}
 
 	/*
 	 * If we got a different type of fault from the AT instruction,
@@ -389,9 +392,11 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
 	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
 		return;
 
-	if (WARN_RATELIMIT(is_spurious_el1_translation_fault(addr, esr, regs),
-	    "Ignoring spurious kernel translation fault at virtual address %016lx\n", addr))
+	if (is_spurious_el1_translation_fault(addr, esr, regs)) {
+		WARN_RATELIMIT(!is_pkvm_stage2_abort(esr),
+			"Ignoring spurious kernel translation fault at virtual address %016lx\n", addr);
 		return;
+	}
 
 	if (is_el1_mte_sync_tag_check_fault(esr)) {
 		do_tag_recovery(addr, esr, regs);
-- 
2.53.0.473.g4a7958ca14-goog

