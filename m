Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCD2C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6C0E4B2CC;
	Fri,  1 Apr 2022 14:20:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vz8UU-Q5ll8h; Fri,  1 Apr 2022 14:20:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AC1E4B2DA;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0894B20F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0TEx5t+BcIO8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:18 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F404410DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:18 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 rm11-20020a17090b3ecb00b001c713925e58so4348710pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9irR3brB5K4k6kskWzWAbqG40+EEbVRaPIvCDPrQqZc=;
 b=TTHccN07Kc2+dKX/CQM4O229WOCMUEIEZjrDqAkCum2pWRxXyep/RtD21aVHTzWJ0u
 5Ur/7qOrscd0hKtzG7s1EiErU9Vn5N7nHtLcCGMtzTi3YMoFLmHW94dw6Gq8G0YshxYY
 MXs/f+M/+N5rlpf0p71rU9X8qWgGkVAjsH0i1IRyHKq8aV01lhAROqIUxZdIBEdQ6Fn7
 o/5H/YoPwviW5zcmK5mwsLjoCqpLLJwdhb4vCxGtiGEedukX7RGb51wslmYlEJfKZvrb
 xua3zBzP8zwd6jU0yexNhL/1HTixfROGNf25yDDwoHh2EgdS6uv8nRoFcKEn2F6VBDv0
 gMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9irR3brB5K4k6kskWzWAbqG40+EEbVRaPIvCDPrQqZc=;
 b=hRrNaTmRVhoABgl6Z0IdRUMUIdigWG5Doba+w8wtn9j5DSbNhgJdavoasd4dvpMcOF
 jDypvH6PfwiVvmDat0yLCmJVSVug19RiYNCxxlMij3wVUnMccDKCTNcbfsOHek+P2K17
 bwGsZUOoN02IFViydXmsPP3OZfUc8v5f4sKk7ieVDPYyGJxBMV1nP5IfzqB9KA57PFRk
 V961PLU5GpfQiVT6WTytb6jD+Eet8G6YRKGJixk6qgglW8si9+S7+SZ3TwwW0smSgT4V
 bMzICK3M+UnMzHBp6MuDr4FtruftuctMQR2WUFmTA/8jh33qZbt0otrs1dKNQzL0Kj/4
 KBDw==
X-Gm-Message-State: AOAM530Ld/1wI3/GjN8YSUkknJAIwe85KP/x+Bc5+Kw0aPTqkC5eSvbs
 pmDM7vnP8mIlNCfR5cIlA+amO1uFEJFQ5Q==
X-Google-Smtp-Source: ABdhPJxg+/Q/17NTgwHdrbJN0RELEFI4TA91YpU0RNqlmFBBNYRSy1Zgxz7Lu9EEyB4Z0QtTYObcl0Q0cVZDDA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:118c:b0:1ca:307:9b50 with SMTP id
 gk12-20020a17090b118c00b001ca03079b50mr13195653pjb.26.1648835777771; Fri, 01
 Apr 2022 10:56:17 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:41 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 10/23] KVM: x86/mmu: Use common code to free kvm_mmu_page
 structs
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
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
page splitting. Keep tdp_mmu_free_sp() as a wrapper to mirror
tdp_mmu_alloc_sp().

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 +--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 657c2a906c12..27996fdb0e7e 100644
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
@@ -2518,6 +2515,9 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
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
index 34e581bcaaf6..8b00c868405b 100644
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
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
