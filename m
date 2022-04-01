Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6BBC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7934B291;
	Fri,  1 Apr 2022 14:21:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yXw8Z+zpzoaO; Fri,  1 Apr 2022 14:21:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E584B293;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D2C4B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jBZ1fAMQpK-t for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:23 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F00A94B25B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:22 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 r17-20020a170902ea5100b00153f493fa9aso1797236plg.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=98QuPuIamNZ4VXhVyk60fd3jtdaNhZOSrUDoLns0RNg=;
 b=aUeZagy6oSm/W0IESWczDjmWRTSG4Npvh1AoFSuKwIbezAKth9hVIv88sZ1PVSs54P
 QuQzvJ5uvlUy4BZeBvhbx8V7VTbmtyOFBlVK6TO1Y5OqSJrdAWIzlesY9Y7Ef0+ulNiw
 etoPUBWitef9pf0CbOSZCO7DfbbKKlk5tLH4vpNPAoXH3otLyid9PS7TlLRXA2o/s6Zx
 14w18b1jE0xK/QCtfi7eO05rYdM47uPTnLEBVIcuO8jOAe+Yt04t1s8B7z6YuNT78vLP
 UhF/qof2Hy5JcUFWeN8ucBOI/LTmnlgblwP0QMCgT702dp28RE7ENQrHUu79Ry4+dba8
 IV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=98QuPuIamNZ4VXhVyk60fd3jtdaNhZOSrUDoLns0RNg=;
 b=RuReVZOhjTH9gAS31mCIHdNT025mGrKNNCLCHNHhw78Fr5URhIZ2tGyd53Hh3rWVS5
 JRaboJhP9PDZs3+App9BmgZuWCCMqekdhqjPTYPS+BBXa0qaWPLHrla2tuJCMydqjAjN
 bpclTjuatKtpluBsDi1RKdAq1p29T08sbf9PTgy3njGBUxv3teRR6nzA6GVSWpq0vA+k
 C41FzoQkrbGjETyL/YXafDb1ODkvhFCnSxdQXTefLyw8CRy7T67U/0//1dC526r4PLgq
 RUdKynTSHZvpNrQy6+90CQcosFwMGefGsDPooBJnpS4IAUx1UDV1fQifOz1qaU1w8NcR
 fQIw==
X-Gm-Message-State: AOAM5300tCQx2O0xNxjV9HErLNviMfx3gute06Fp3dLqb7PGHDqZse0O
 5dyOXo3T2Wfkr3ffTC2en6KQU+wVsVH7yA==
X-Google-Smtp-Source: ABdhPJz698nbKbYgL2dF565iPEoR7WzCc+Wp0S/qIabLKC8pciUWRSwlWFExH/GdxxtVuQGJTVkUd+56ESvveA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1acb:b0:4fb:358f:fe87 with SMTP
 id f11-20020a056a001acb00b004fb358ffe87mr12183610pfv.75.1648835782098; Fri,
 01 Apr 2022 10:56:22 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:44 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 13/23] KVM: x86/mmu: Pass const memslot to
 init_shadow_page() and descendants
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
index 1efe161f9c02..39d9cccbdc7e 100644
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
@@ -2150,7 +2150,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
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
index f6201b89045b..a04262bc34e2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1793,7 +1793,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level)
 {
 	struct kvm_mmu_page *root;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5e5ef2576c81..c139635d4209 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -48,7 +48,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
 void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
