Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3008CC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1BAA49EE2;
	Fri, 11 Mar 2022 03:48:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VH1sFg1-Nwwp; Fri, 11 Mar 2022 03:48:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B4949F56;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 422C740FAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ey4kHCTd2NYv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:54 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FC1040BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:54 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 lt6-20020a17090b354600b001bf5a121802so4179162pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=v7qCsbgsr/gR22mozQcF+sQ2jUkkViok2U86H9+3SCg=;
 b=sxbiv6bxYZKji+KMkwgFhZgmKilK+x7JKaeklm0aaY/0tPHo6PqSDrSP8HWopQYwNb
 nYjE55/Ylu41BjN1Wr8tR6Vj6dzqCF34FD3W/C18qtOwHO8+ZBiBG1Y+12IK5ZU+3UoP
 CC+BQNMbs5hN4UK+uFlYFs4kOqkifWM+N5qlJK7DTJ7axe2fdbrrMPmRjJrIVbzuWq0r
 3k81g/OAwBL5gKGcgy6IkuE3EHezxxR9kafqxsj1rgsGhwauVhdI2uyKyMeYKz8leCWX
 I4Bqze8qQcKReoPNBhoTBprcMm2NQA/bx4Z1RgJ2wXF5sWAbMswIfJlKoVg2OV4VMNvY
 kgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=v7qCsbgsr/gR22mozQcF+sQ2jUkkViok2U86H9+3SCg=;
 b=bqd4Vt0z5cA7KAX89uDkYZDz7xaE9HqeXHzqcs5yv2T+TNEA/AM/X1jMzcZLjzVqpB
 Fnt5Jk6Ra8c+MO8GPbgf9P0Xlh5LfJUc+Pn3P3zqlaq1nJ6GXdNtpX1J5CUtjyhlYUgH
 Kn1raxuzjArLOV/rWhox+qkvHiXQjR/ifcwKyvHXgKXK+LTIRKOYG6sZZnI6UDL74d2M
 Rx9SQMnO6aChyyuedv2tLegfrDYvT3uJQ7CmK/kj4X0Badu/gB2tYXLTaf+WFWc8Ln7q
 g5BK18yTj/hotQWazlIVKGZ9Vtsg7eetx9M36cAp1KxIVd8FQNaxeUVcuZpx8+a+2/HN
 aYwg==
X-Gm-Message-State: AOAM532oedKCovwgZQbkPLqD4z1fRbZM583w1Zyk/A2zpJmsejzNrsOw
 C0gW09QbrzHDyIl8wTjYSsVjXBQ7QYGfRg==
X-Google-Smtp-Source: ABdhPJzvjuqM/MeknIQuH530q9QhRKE8ELO29h5EvZaK896mLaUdORuS4wDYPcFM+SuVielHfBcrazhJK1uDSA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:be18:b0:153:2444:9c1a with SMTP
 id r24-20020a170902be1800b0015324449c1amr4691462pls.152.1646958353220; Thu,
 10 Mar 2022 16:25:53 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:15 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 13/26] KVM: x86/mmu: Pass const memslot to
 init_shadow_page() and descendants
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

Use a const pointer so that init_shadow_page() can be called from
contexts where we have a const pointer.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/mmu/mmu.c                | 6 +++---
 arch/x86/kvm/mmu/mmu_internal.h       | 2 +-
 arch/x86/kvm/mmu/page_track.c         | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c            | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.h            | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index eb186bc57f6a..3a2dc183ae9a 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -58,7 +58,7 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const struct kvm_memory_slot *slot, gfn_t gfn,
 				  enum kvm_page_track_mode mode);
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 23c0a36ac93f..d7ad71be6c52 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -794,7 +794,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
 }
 
 static void account_shadowed(struct kvm *kvm,
-			     struct kvm_memory_slot *slot,
+			     const struct kvm_memory_slot *slot,
 			     struct kvm_mmu_page *sp)
 {
 	gfn_t gfn;
@@ -1373,7 +1373,7 @@ int kvm_cpu_dirty_log_size(void)
 }
 
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn,
+				    const struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level)
 {
 	struct kvm_rmap_head *rmap_head;
@@ -2151,7 +2151,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 }
 
 static void init_shadow_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			     struct kvm_memory_slot *slot, gfn_t gfn,
+			     const struct kvm_memory_slot *slot, gfn_t gfn,
 			     union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d4e2de5f2a6d..b6e22ba9c654 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -134,7 +134,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn,
+				    const struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 2e09d1b6249f..3e7901294573 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -84,7 +84,7 @@ int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
 	return 0;
 }
 
-static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
+static void update_gfn_track(const struct kvm_memory_slot *slot, gfn_t gfn,
 			     enum kvm_page_track_mode mode, short count)
 {
 	int index, val;
@@ -112,7 +112,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @mode: tracking mode, currently only write track is supported.
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const struct kvm_memory_slot *slot, gfn_t gfn,
 				  enum kvm_page_track_mode mode)
 {
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f285fd76717b..85b7bc333302 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1768,7 +1768,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level)
 {
 	struct kvm_mmu_page *root;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 54bc8118c40a..8308bfa4126b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -42,7 +42,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
 void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
