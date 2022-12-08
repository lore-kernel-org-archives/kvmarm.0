Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2C5C10F1B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B0BE4BA1D;
	Thu,  8 Dec 2022 14:39:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ipMbgsnlelUj; Thu,  8 Dec 2022 14:39:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A06D54BA66;
	Thu,  8 Dec 2022 14:39:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B22D94B9B2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r1T73ZFcl3Gs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:40 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E8864BA12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:39 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 i19-20020a63e913000000b004705d1506a6so1627549pgh.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=z1OT4qzC8agmu6kAkGnJ2Z35e3wCX96lD5z5dcXDmZ8=;
 b=mYob1xjdrgICrvdwJ/y+dLEYrXUw8yHkANGFMt6kNW2zwoh86yOA5IqdKm5On/HK71
 rCr+r9ZI6b6AUTyVpRLi2HPUhb4KBRes2A7dYxEjzKSFKujmjFxrPF/BYUNv2Dy6Czkl
 f0L60qH/T+Z7MgC6YZCM/qFdYGB6ww2JwcmxKxWSiQbNX520z0l4UVo1vs6DH+jCVtRB
 Ica965ONYXFaPKJ0DJgySM/ZwSZbyoeXM3nEtFV/eijoma5iS8BYP7SnArJIeoWtwwAs
 /dEWQtSRXEmOgV2EdezDQjp58v5mEPq257Ptg1IsS9acpYvYjSy/WRIyS1Ye2wh2Jdug
 JTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=z1OT4qzC8agmu6kAkGnJ2Z35e3wCX96lD5z5dcXDmZ8=;
 b=RzYH+jmsH70tue2OVZm6clO61xKsbmTcF6XX7FP5g6db1oxNW1Y00TJS/OqbyOKXHR
 wbli4+LbXRlLC/GtsdL3OUZSgRtK3Pao1XmsoMyOSkCt5+mT6RBXI3B058sC4fVk7jAA
 sG1NXtYs4giOgirjIZcJ54c5kqDBBfiYlRuTT3voAb3jY16LtM3wFevooaP52W9nkUse
 R0vfIokufJo2U95aA1b3kAXdPHWHqJkW6ewDPqQVTcIPOHo3a9i+YzLSvu7z6FNLO2zh
 efTd8sOYEjwQdUlYoKD5Fw+envb0bklTPZ5CNQNewUJhmkKSwnvrctLe9oAmbljS0CaT
 vUEQ==
X-Gm-Message-State: ANoB5pnDtsseolYwqNC4/qdHgx+552o0GZwsNJmhcTEsKntWxFFbeFzq
 Owv2WaL26rMNOtMqKO6BaovdUo7+Qd4PwQ==
X-Google-Smtp-Source: AA0mqf4wDINWYdyDuh5bcErKdq4AXe0SreaRGxGTgiHfTgQy11e7AFp7261AXIzWuvopVOIy1EidXNtJ/FLxDQ==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:a78c:b0:219:ef00:9ffe with SMTP
 id f12-20020a17090aa78c00b00219ef009ffemr14658083pjq.106.1670528378506; Thu,
 08 Dec 2022 11:39:38 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:39 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-20-dmatlack@google.com>
Subject: [RFC PATCH 19/37] KVM: x86/mmu: Add arch hooks for NX Huge Pages
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

Abstract away the handling for NX Huge Pages down to arch-specific
hooks. This will be used in a future commit to move the TDP MMU to
common code despite NX Huge Pages, which is x86-specific.

NX Huge Pages is by far the most disruptive feature in terms of needing
the most arch hooks in the TDP MMU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c     | 57 +++++++++++++++++++---------------
 arch/x86/kvm/mmu/tdp_pgtable.c | 52 +++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0172b0e44817..7670fbd8e72d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -269,17 +269,21 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 	return sp;
 }
 
+__weak void tdp_mmu_arch_init_sp(struct kvm_mmu_page *sp)
+{
+}
+
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 			    gfn_t gfn, union kvm_mmu_page_role role)
 {
-	INIT_LIST_HEAD(&sp->arch.possible_nx_huge_page_link);
-
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role = role;
 	sp->gfn = gfn;
 	sp->ptep = sptep;
 
+	tdp_mmu_arch_init_sp(sp);
+
 	trace_kvm_mmu_get_page(sp, true);
 }
 
@@ -373,6 +377,11 @@ static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	atomic64_dec(&kvm->arch.tdp_mmu_pages);
 }
 
+__weak void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
+				   bool shared)
+{
+}
+
 /**
  * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
  *
@@ -386,20 +395,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
 	tdp_unaccount_mmu_page(kvm, sp);
-
-	if (!sp->arch.nx_huge_page_disallowed)
-		return;
-
-	if (shared)
-		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	else
-		lockdep_assert_held_write(&kvm->mmu_lock);
-
-	sp->arch.nx_huge_page_disallowed = false;
-	untrack_possible_nx_huge_page(kvm, sp);
-
-	if (shared)
-		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	tdp_mmu_arch_unlink_sp(kvm, sp, shared);
 }
 
 /**
@@ -1129,6 +1125,23 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
+__weak void tdp_mmu_arch_adjust_map_level(struct kvm_page_fault *fault,
+					  struct tdp_iter *iter)
+{
+}
+
+__weak void tdp_mmu_arch_pre_link_sp(struct kvm *kvm,
+				     struct kvm_mmu_page *sp,
+				     struct kvm_page_fault *fault)
+{
+}
+
+__weak void tdp_mmu_arch_post_link_sp(struct kvm *kvm,
+				      struct kvm_mmu_page *sp,
+				      struct kvm_page_fault *fault)
+{
+}
+
 static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 				   struct kvm_mmu_page *sp, bool shared);
 
@@ -1153,8 +1166,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	for_each_tdp_pte(iter, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
-		if (fault->arch.nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
+		tdp_mmu_arch_adjust_map_level(fault, &iter);
 
 		if (iter.level == fault->goal_level)
 			break;
@@ -1178,7 +1190,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		sp = tdp_mmu_alloc_sp(vcpu);
 		tdp_mmu_init_child_sp(sp, &iter);
 
-		sp->arch.nx_huge_page_disallowed = fault->arch.huge_page_disallowed;
+		tdp_mmu_arch_pre_link_sp(kvm, sp, fault);
 
 		if (tdp_pte_is_present(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
@@ -1194,12 +1206,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			goto retry;
 		}
 
-		if (fault->arch.huge_page_disallowed &&
-		    fault->req_level >= iter.level) {
-			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-			track_possible_nx_huge_page(kvm, sp);
-			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-		}
+		tdp_mmu_arch_post_link_sp(kvm, sp, fault);
 	}
 
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index e036ba0c6bee..b07ed99b4ab1 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -111,3 +111,55 @@ u64 tdp_mmu_make_huge_page_split_pte(struct kvm *kvm, u64 huge_spte,
 {
 	return make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
 }
+
+void tdp_mmu_arch_adjust_map_level(struct kvm_page_fault *fault,
+				   struct tdp_iter *iter)
+{
+	if (fault->arch.nx_huge_page_workaround_enabled)
+		disallowed_hugepage_adjust(fault, iter->old_spte, iter->level);
+}
+
+void tdp_mmu_arch_init_sp(struct kvm_mmu_page *sp)
+{
+	INIT_LIST_HEAD(&sp->arch.possible_nx_huge_page_link);
+}
+
+void tdp_mmu_arch_pre_link_sp(struct kvm *kvm,
+			      struct kvm_mmu_page *sp,
+			      struct kvm_page_fault *fault)
+{
+	sp->arch.nx_huge_page_disallowed = fault->arch.huge_page_disallowed;
+}
+
+void tdp_mmu_arch_post_link_sp(struct kvm *kvm,
+			       struct kvm_mmu_page *sp,
+			       struct kvm_page_fault *fault)
+{
+	if (!fault->arch.huge_page_disallowed)
+		return;
+
+	if (fault->req_level < sp->role.level)
+		return;
+
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	track_possible_nx_huge_page(kvm, sp);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+}
+
+void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
+			    bool shared)
+{
+	if (!sp->arch.nx_huge_page_disallowed)
+		return;
+
+	if (shared)
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
+
+	sp->arch.nx_huge_page_disallowed = false;
+	untrack_possible_nx_huge_page(kvm, sp);
+
+	if (shared)
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
