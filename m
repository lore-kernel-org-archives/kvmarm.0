Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F80AC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D83A49EB5;
	Fri, 11 Mar 2022 03:48:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vH42113H1T8Q; Fri, 11 Mar 2022 03:48:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 636D449EF1;
	Fri, 11 Mar 2022 03:48:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B20A40C1B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9vAVNpOcrfKD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:01 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0761A40CF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:01 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 r64-20020a17090a43c600b001bf8e05847eso6140530pjg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cgeEs8BEwlCwQg4uwdq2WGFHwIysPh6phqJCR0F6k5E=;
 b=rYx7Jqj6Gy3597TptoRhJdrqs/Hp8iKZ54PUtCCP1XWegMJL6/XfhmdhJT9uBJQiWH
 ZE5h7nYGSmoHWR3jekHywiWqVqzYnIn3iMjZLs1yTffpVYvhuqxw7VtoRdHcmknboDZV
 JaGspNzGf5/qUKHlZtXWJwiljrvD4FR+upssqyDkEZueUr53Bv3WvwOj/zzr8mYfrJiq
 k7f2lf8q256HKL3Wuv3+j022awWEg8sSZdUIR/trB9Yyd6Z8krtbJm0h2i+oQ8aXL1QH
 3OLc2hD77uQGQ4LMYuHeQex2C+6qz2UP8W2rChJhSKxk3mMJLVkbpnGVBmgnfN6VoZen
 sB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cgeEs8BEwlCwQg4uwdq2WGFHwIysPh6phqJCR0F6k5E=;
 b=YYMWEWf7gf6XiqXZaSvPMi8/IaYOBYD+W+iqdh0/FN9be5dgfTtLwbV6g2iC7uYKQF
 pegZoKot8lRMorz99vK/leaZANZ4sEnGRlUSAqoh69fNVEpiurZqe+M7CrsifiZRsyJU
 fOOm8jPsBdbwCjDzd0LKL3iKbXy6yXJ0vKmz5OEVCw66WQUkHsYBekPJkoq+5Bjkbkgr
 vU9lbjDK5tqNVh4azecsM26T3uWZgMITGQt+camZy5hNPGQfoKaZfL5KaxGAgVFliqGp
 FMT5u9XVpUcuFZ+QzrxDDH3fyBHC1N9jfsHfYOi8OCutg6XZn3DIcTXCy/fxXlxrVlhX
 67tQ==
X-Gm-Message-State: AOAM53102pxPXZzQ6vaUfpINc1GIy4T0G14tofvxCsneplWA9SGaadu0
 g1ykF+SLIRygkmwTpEpBe1UeAtADtyjjwg==
X-Google-Smtp-Source: ABdhPJy4jPXZbommb1140O0m7nX/f+s6PPe4tO5XvxEJ5QF7X5XtVfhvTF/UqH4vCyBIyTH3kSFZezPw37Zl0Q==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP
 id pg16-20020a17090b1e1000b001bf6c7854a9mr321715pjb.1.1646958359778; Thu, 10
 Mar 2022 16:25:59 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:19 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 17/26] KVM: x86/mmu: Pass access information to
 make_huge_page_split_spte()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU. Huge pages
mapped by the shadow MMU may be shadowing huge pages that the guest has
disallowed execute permissions.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c    | 5 +++--
 arch/x86/kvm/mmu/spte.h    | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d10189d9c877..7294f95464a7 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -216,7 +216,8 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
+			      unsigned int access)
 {
 	u64 child_spte;
 	int child_level;
@@ -244,7 +245,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		 * When splitting to a 4K page, mark the page executable as the
 		 * NX hugepage mitigation no longer applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (is_nx_huge_page_enabled() && (access & ACC_EXEC_MASK))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..c7ccdd5c440d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
+			      unsigned int access);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 85b7bc333302..541b145b2df2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1430,7 +1430,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
