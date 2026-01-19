Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27CC35FF55
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826890; cv=none; b=ne7OIy2TcHWc6N0dxGkbvIIOcVCEUsMsXRHXo1boGsXN+ldEOvWvG0VOj67G5KR2DHZsPByqDI39vGpUIoagJ36yyRCerUrTcNSb/Sc3lExn+zwSH+DZzExgd+ZvQe7xNe1MdOhpqM0d8SCuwv8KMDz1iazGQA8+JgWwpO+ISXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826890; c=relaxed/simple;
	bh=eBPe3irIgFQzZeiJ/hcXb69SVpuZxRIfYJxRGW/nywE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3RuDa6bnwA0SiEuRKwFgHVHHaAStm2TDsvDAulJ/pJCqa4MO0Ic/rDquXnYLg/1kUgdLuTGychP8aNteeREE9fMTSA9BYguhKV4BkX//hQm4zCuKBvi1NudrJ9Kw92IWEBjwc5J7iaEemyqhIZ5ntkc34sYuQbpADxkHkZd+o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WI+yY+XK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WI+yY+XK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CBEC116C6;
	Mon, 19 Jan 2026 12:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826890;
	bh=eBPe3irIgFQzZeiJ/hcXb69SVpuZxRIfYJxRGW/nywE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WI+yY+XKe231b3ZUriObbCV72KfvpmRkVu7FGB0+OKlHgNL58w7cp4IMZGKgy5Tcd
	 77LRIsKY+1aF4hBr46luHPKX9S4+/rdlXst7unOEdfJCbETtNedoEDMzsKceIDzEpQ
	 rqHsXDiylvJpWHopYXJEEB/fpIrYZT0gc5epw1h40+VXogwxoKSCwM5hC+7bIof3gI
	 n3gQSiGh3WTILvBEX+YFWJn6sm3LDah2gxqP9wD9u8kdHi1O9pyDoAgm3EL8N8xMgI
	 J4EGtZlhuroe6OgDesRixV3Rs8tPF52JNcZCF7XIhB4jhA99HYa/Pg3g1yTiDYjiJH
	 j2dlt3Z65bEWw==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 25/35] KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
Date: Mon, 19 Jan 2026 12:46:18 +0000
Message-ID: <20260119124629.2563-26-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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
 arch/arm64/include/asm/virt.h |  6 ++++++
 arch/arm64/kvm/pkvm.c         |  7 +++++++
 arch/arm64/mm/fault.c         | 15 +++++++++------
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b51ab6840f9c..e80addc923a4 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -94,6 +94,12 @@ static inline bool is_pkvm_initialized(void)
 	       static_branch_likely(&kvm_protected_mode_initialized);
 }
 
+#ifdef CONFIG_KVM
+bool pkvm_reclaim_guest_page(phys_addr_t phys);
+#else
+static inline bool pkvm_reclaim_guest_page(phys_addr_t phys) { return false; }
+#endif
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8be91051699e..d1926cb08c76 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -563,3 +563,10 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	WARN_ON_ONCE(1);
 	return -EINVAL;
 }
+
+bool pkvm_reclaim_guest_page(phys_addr_t phys)
+{
+	int ret = kvm_call_hyp_nvhe(__pkvm_force_reclaim_guest_page, phys);
+
+	return !ret || ret == -EAGAIN;
+}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2294f2061866..5d62abee5262 100644
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
@@ -302,8 +299,12 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
 	 * If we now have a valid translation, treat the translation fault as
 	 * spurious.
 	 */
-	if (!(par & SYS_PAR_EL1_F))
+	if (!(par & SYS_PAR_EL1_F)) {
+		if (is_pkvm_stage2_abort(esr))
+			return pkvm_reclaim_guest_page(par & SYS_PAR_EL1_PA);
+
 		return true;
+	}
 
 	/*
 	 * If we got a different type of fault from the AT instruction,
@@ -389,9 +390,11 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
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
2.52.0.457.g6b5491de43-goog

