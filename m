Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C62C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2AE043479;
	Fri, 11 Mar 2022 03:48:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D9dUXWRVNxno; Fri, 11 Mar 2022 03:48:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94F5149F4A;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 898C240C31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zD8KobM0H2sq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:49 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 469E540CF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:49 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 c70-20020a624e49000000b004f69bac03d0so4169174pfb.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JTpQf7sMt9NLwDv0fAUwU2EA32MsJpiLJgXJ8737nsg=;
 b=nI8x0dteBcJQ0AeW7ZZZnCVKrEe68X0+npmVLf8lMk0Ag9nRT1msQlKpIkRULGuUI8
 06ikZLRTCzLiUgNamd32eHHL90zFaZpJJSGCSIacLRIE5rwK5rwhE8gGl2fH/Qt7GyLM
 /hZTGRxO3Wm0LkCdC3D4JXrM3t3pqzYXHTarQbY0zLTLvXKJmLBwqD/zni0OcJqToo/c
 RxVg35KKH4nykhIefrkxNUzy6WjfNJ9TJUpctMWnzuDPi+ofAgYSLz+nuyuKLxJRSet2
 nsIPDOHgYBYLQkkCzl53A3Lm+IRStEgvTXKbpKSxs0K+5Fi2pGo9vjO4eXKe0nSvQ0cZ
 Wq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JTpQf7sMt9NLwDv0fAUwU2EA32MsJpiLJgXJ8737nsg=;
 b=deBlWazCOSCUujFBOBcmq1Y+fos5N4kxExGlK5HCtC8lE2tewzSF7PFl16ZmBebd2o
 6BsNlXsd/DWSWdXPsln0C9s4xVcujJhsIzLVGH1i1sS2f9YwDdwj8wLHT8ovgJ3ZNj1t
 zqR4/7PTbddD/O6tMB2rdHnUz9LPlFDgotofJkdt6Ho+bCEH7GgAjiblT4BM5VDi5IM/
 QSCLfLk3E76TTCYVBTC9DuBNkB78cTXRXo4stfdat/G1jEBFouvwqJyCIXwXz4E/oG4z
 bOlSndggwHpJErCXXGqU8yCyENaefxnNZTfTV+PsFuU3rbSWkKj+nJvAUqJkt9nh/C7e
 kk9A==
X-Gm-Message-State: AOAM532g9qbAqyOHhYdgPHUtuh7QpoUZ3MTFyHH63NUXBW5Mn6mXqzp+
 SdsdE6SVysjxBOj24ywAKL6Ly6vICZkEkQ==
X-Google-Smtp-Source: ABdhPJx0jVLYy5OgA1/trFkRvNs31FrB39hnDd/rYlVAUt8N2QRI9jD4iGvKLypSffqncxLl/Lr39n8gAymcHg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:7296:b0:14f:2a67:b400 with SMTP
 id d22-20020a170902729600b0014f2a67b400mr7633127pll.172.1646958348502; Thu,
 10 Mar 2022 16:25:48 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:12 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 10/26] KVM: x86/mmu: Use common code to free kvm_mmu_page
 structs
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

Use a common function to free kvm_mmu_page structs in the TDP MMU and
the shadow MMU. This reduces the amount of duplicate code and is needed
in subsequent commits that allocate and free kvm_mmu_pages for eager
page splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 +--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c12d5016f6dc..2dcafbef5ffc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1669,11 +1669,8 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
+void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
-	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
-	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
@@ -2521,6 +2518,9 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
+		MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
+		hlist_del(&sp->hash_link);
+		list_del(&sp->link);
 		kvm_mmu_free_shadow_page(sp);
 	}
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index a0648e7ddd33..5f91e4d07a95 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -173,4 +173,6 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
 
+void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1a43f908d508..184874a82a1b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -64,8 +64,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	free_page((unsigned long)sp->spt);
-	kmem_cache_free(mmu_page_header_cache, sp);
+	kvm_mmu_free_shadow_page(sp);
 }
 
 /*
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
