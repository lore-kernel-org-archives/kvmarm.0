Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AED3264CF
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882217; cv=none; b=U5qypoHB8EwVE9j9wu3TQcFCxXY9El8fp25p3VQ5lyF8W2Lmf4rCqRLni+bgmujMJQcGja/TrzF8CtXkTj4DUY8OeT/C2UKsxqWb467QtjMf1L6b5ZFD7jsXxlQEGLAZJmnBGSW3OXjKSG1Yza1mrK/79IUNlsrH+IWu66P3gvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882217; c=relaxed/simple;
	bh=Iq0PZUuil4H4+BJ0X07x7gMKesNA1AW1mGvkoi2ty4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/dYqj4cicesscFbXy8f5bXuI0fTETqRvPdrMKe2/AyTGT2Y5Bd3J409KJD6GLpCYXJRMo/+Ztb9Ca6vPD2bSg0xE60eLureCXYAUvyPfC3w88Fe4cpxWTbVaGvqcCW8D9k3/Ih7/Mv3cTMLJJ/cXZmU03ibqRn5uPdViKIzY8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8wkuJ2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8wkuJ2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A159BC4CEF7;
	Mon, 30 Mar 2026 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882217;
	bh=Iq0PZUuil4H4+BJ0X07x7gMKesNA1AW1mGvkoi2ty4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8wkuJ2BXvY32osqG3bZtySfodpId/qjQKKjqzXkCZtxnYokFnUbazoiqwFugO45B
	 qByRG+Bir7TsHzklSJtROV2NXhlFgk7MQrxtoYzVSTaDx/fdoBDysaFX/i5G3DjLbE
	 QRTu+Y7p7+cy6HNrgIURlkHR6cZ5MvgLTpOBt/RbnhFABSKiK0R0mW9e5gtshsVZDr
	 xalaTVQDHkou2SDjeoP6QKdPgKx7TMPPSuFv7hJz9yKuC6Xjk4N3yDwl01Ir8Dkv0Z
	 Zn2eRrlwwxDvhDEI8SJUtLnZfVj4dAPNPsURmffNGn+8wDDcfE/Iv42AqlNsbEeLkP
	 VzdEPMstghlKw==
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
Subject: [PATCH v5 26/38] KVM: arm64: Reclaim faulting page from pKVM in spurious fault handler
Date: Mon, 30 Mar 2026 15:48:27 +0100
Message-ID: <20260330144841.26181-27-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
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

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
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
index 3cf23496f225..10edd4965936 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -569,3 +569,15 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
2.53.0.1018.g2bb0e51243-goog

