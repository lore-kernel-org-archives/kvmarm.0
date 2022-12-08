Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBBCC001B2
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A9824BA13;
	Thu,  8 Dec 2022 14:39:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sgVwLQbkVBcY; Thu,  8 Dec 2022 14:39:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49ABB4BA3A;
	Thu,  8 Dec 2022 14:39:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A474BA3A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3XsFcCcKc7RD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:38 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8A6B4BA13
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:33 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 t9-20020a5b03c9000000b006cff5077dc9so2552185ybp.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=Pg1Nq3rulqWxdtA2fJcZW38Nt6WCEHzRUfCCpYS2KV0=;
 b=aDqf6pXxZybLQuV+ns7MyujXZ7TaXxPsXCkY1cBCTnm7Z1Pk34Q2WxafDnw6pX7BHN
 lhEXYUvCnQrmxi67UqIabYRYVsFr1VmRYMnDgU/nCVe0vfpF9o0e/pk5kPNnjxwaoCkb
 6UzjVRaqPFUO0UrFxoxAA1OT7EuOIecZ2ihew0iHfezGa4aHmagqVFYtCzqCsOXcoWMG
 1BSI0f3h3n0sV4Xz4NHwLOJuYaVAHIAoL3P08pyo0Lb7cFRQm3wK50yoCvEQji2rKMPw
 TJvkYFZnHosx8g6qnVV89WiLKgj9ZlDUDj9dOxU8qckP9jmYepoaBePV4tvKaqieAvx3
 Iqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Pg1Nq3rulqWxdtA2fJcZW38Nt6WCEHzRUfCCpYS2KV0=;
 b=pPQo56XzVi6P392N5f7Dg62uOIv9oHZACQp0RG3gtMq4vbeIafaA8HyvxIPheM2BpJ
 TX5L72lHLPXFvW9yc1IXF8PShhpebkqtwXj44lC2AgX9eeeId7wKjMmUO3ipUGO5UP6A
 BjhleUEiEmiH6MrZkxn24+avQ1X5P4ZUcp3LZwXLl3EZ9hQtuE/y7tktRvOWaa7CJKMk
 9PBZRQo85cbtUHMWxQu++Bdy8qSSuThKlClER38uxkJfQySKYoxk6z1+MabD9by9VJMn
 ysa3ul/kcPf00MzzC/E0frxcCu1PwkTHEAxJx+2D2oIC823yLQLZdGoC9ULrRhvQ85Nu
 ZEbA==
X-Gm-Message-State: ANoB5pmhkpg62Bx9tTM0tIq0ICoYpFXCOMcJofcIogSqrqrTVFlVzm0P
 8spovw/3RGQpfBCMOoK2FhNQA2oNEZnb/Q==
X-Google-Smtp-Source: AA0mqf7iyktvhKElr4AnSOjLzx6ehM+nhpfhEwE2rLq/JpjuQYZLUjwLo76vc17Zh1ckOWCNKP3vo6QzYulWTQ==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:25cf:0:b0:704:9d40:ecce with SMTP id
 l198-20020a2525cf000000b007049d40eccemr9539756ybl.316.1670528373481; Thu, 08
 Dec 2022 11:39:33 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:36 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-17-dmatlack@google.com>
Subject: [RFC PATCH 16/37] KVM: x86/mmu: Abstract away TDP MMU root lookup
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Abstract the code that looks up the TDP MMU root from vcpu->arch.mmu
behind a function, tdp_mmu_root(). This will be used in a future commit
to allow the TDP MMU to be moved to common code, where vcpu->arch.mmu
cannot be accessed directly.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm/tdp_pgtable.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c             | 17 +++++++----------
 arch/x86/kvm/mmu/tdp_pgtable.c         |  5 +++++
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm/tdp_pgtable.h b/arch/x86/include/asm/kvm/tdp_pgtable.h
index cebc4bc44b49..c5c4e4cab24a 100644
--- a/arch/x86/include/asm/kvm/tdp_pgtable.h
+++ b/arch/x86/include/asm/kvm/tdp_pgtable.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 
+struct kvm_mmu_page *tdp_mmu_root(struct kvm_vcpu *vcpu);
+
 /*
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
  * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fea42bbac984..8155a9e79203 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -788,9 +788,6 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
-
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
  * to the scheduler.
@@ -1145,7 +1142,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm_mmu_page *root = tdp_mmu_root(vcpu);
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
@@ -1157,7 +1154,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	for_each_tdp_pte(iter, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->arch.nx_huge_page_workaround_enabled)
@@ -1826,14 +1823,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level)
 {
+	struct kvm_mmu_page *root = tdp_mmu_root(vcpu);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->root_role.level;
+	*root_level = root->role.level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	for_each_tdp_pte(iter, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1855,12 +1852,12 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte)
 {
+	struct kvm_mmu_page *root = tdp_mmu_root(vcpu);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	for_each_tdp_pte(iter, root, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index cf3b692d8e21..97cc900e8818 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -13,6 +13,11 @@ static_assert(TDP_PTE_WRITABLE_MASK == PT_WRITABLE_MASK);
 static_assert(TDP_PTE_HUGE_PAGE_MASK == PT_PAGE_SIZE_MASK);
 static_assert(TDP_PTE_PRESENT_MASK == SPTE_MMU_PRESENT_MASK);
 
+struct kvm_mmu_page *tdp_mmu_root(struct kvm_vcpu *vcpu)
+{
+	return to_shadow_page(vcpu->arch.mmu->root.hpa);
+}
+
 bool tdp_pte_is_accessed(u64 pte)
 {
 	return is_accessed_spte(pte);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
