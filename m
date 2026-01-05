Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEE33074B1
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628257; cv=none; b=V+FbDvX3fbY92xM4/eqiylEMSpWvOzvMEjZPrzqDQnc+DjNJ3r3W2T3wVrZfQhfx6t9W381jU0JBoJiz/v3YmySZQytEF9gf25eVLI7ntboBbbEgPBRnv3c0avE7GEN3AXpYcl7AH9utwP4yPEBjSrdgrNwZ5H03GqHj5PMuMwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628257; c=relaxed/simple;
	bh=EpzLnQBXn8mrjL7opGuG4rLr8XkES6NfQqysWJd4Q5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOqYnq7yvTv1P92i8KYCkS2Wa1uJ6DKy/TwGmG/y7ihSrY/JrREMCUu0eqvDwbku8KzjR1xB/ha83+p06TR9dAZgA0M8+fY17hvCC5ZkkSIpiO3wMlQHFHovNbfqmZjv2JIhbvAzhl836EAPwbfgF6x6t4BYJi/XViQZLvbykPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWyh+2Wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWyh+2Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A96C19422;
	Mon,  5 Jan 2026 15:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628255;
	bh=EpzLnQBXn8mrjL7opGuG4rLr8XkES6NfQqysWJd4Q5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWyh+2WxW1HOlaOPWsrAdZGs3Y5DmMID9N5Xo12zgMxhdKsk4NtOePnDVVWkwHXBR
	 T7A8Teq0oMDx8qsLw/hLMNkESZeko20oppSb6leBjQp9RssAZBJ4Jm+1DXkZ0TbLv8
	 v2EhXkJZbMNyXiOggHtcxHGPzTtzwiSg4kVGEoYtU2CvAEywyGquPdA4dgP5DxXLfw
	 z+/j61fxuyjuyq2ISYrtg3HuXcT8enb6uFyzicM5i24sW7KCdT70w8Jg28/oyVqT7W
	 20+8SZQDnGBgbwY36bYxcL0pCsOLIH+BH+LNchq6WE4itAW9YQizBF2aHQUC8QYUOT
	 YTHTxaXyL24KQ==
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
Subject: [PATCH 21/30] KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
Date: Mon,  5 Jan 2026 15:49:29 +0000
Message-ID: <20260105154939.11041-22-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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
2.52.0.351.gbe84eed79e-goog

