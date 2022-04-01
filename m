Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3A3C43219
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7624B266;
	Fri,  1 Apr 2022 14:21:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9F9pZvarpf32; Fri,  1 Apr 2022 14:21:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71AE64B2DD;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF1A4B25B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jRQsBy4UAeeX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:20 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9F0A410DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:19 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 b7-20020a633407000000b0038413d39ca9so2019032pga.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=W+wK5vxPR/QvP8f06+LL6qG83douEveyqaG4cfdgLaY=;
 b=UlIX32ER5ckYEDHWAIcjYr1jnfgt+txi+GTB7aQ575YuSQEhVBgxyCUID6hNAgokFE
 i76MKrGhcCti1IAqqtc8kmHq8LqNd7RHGUdhQj5N55jui7o41Er8H+t8k78BKld1GGlF
 1VOlV5WFmwGA6KgQUp2Zp1tMkKdYXozagaTpFsbpYSaFotNIcx7eaEFtAXC+ZnpCROYq
 ABsmzYy5wYQds//B5QF75M7rFYH+fy/3noPiqdzNNeN7P/vT017vKaxWsaHrKZktu0mv
 qnRJyh8yDxMicnr56dYAjntxpQ2hWjBPYb0U8saUvcnyua7EEZ2oOdLzLWIpXm5jfysP
 Is+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=W+wK5vxPR/QvP8f06+LL6qG83douEveyqaG4cfdgLaY=;
 b=Jy+4n3WtoW/bhjhzqkzwFyFAGJ7rx8ncguEY5d+veEmZrvXF7z3P3QioGLz/gjMZyS
 tiiHzFiEA0NR6ywHTbtljsX12pDUm346nE7LiFC/6kJukksDeTdrl2llCUu+3trB1ZcJ
 Q4NQv/ziD8yFCR9vriivCoKjaeLgJGZdeq8+F7IdexAErJaes8iirUCf6O9/LhbddkWq
 56PxGIulP1H9gauJOqhqEqH8DFeeBwmsCWbkS5lZUJ6cv2Z+a9/VXwDtf8WRRugnpHrR
 wcYHPeRZJrV6nFwFKFJAXghJ1UlxMgysBJba6lHBZSv2VNmECGdQOMl/XIP8CoKRyPvh
 NWcQ==
X-Gm-Message-State: AOAM531QpghVJSXwlTWIHElq89/aqDSgKJdymwuiNeB0CanD+adHFS+M
 sIGibfWYuIvlDm1PkPLdo4EMpfEUQPV0PQ==
X-Google-Smtp-Source: ABdhPJxYuSmgflitVWDuHEX61iCJV7QQcSTVJ1SS0S3w86E/w3yONDjqYny6QBsz2LrR6va1k+Ws4RIi9FnL+w==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4c84:b0:1c7:7769:3cc7 with SMTP
 id my4-20020a17090b4c8400b001c777693cc7mr13054532pjb.73.1648835779185; Fri,
 01 Apr 2022 10:56:19 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:42 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 11/23] KVM: x86/mmu: Use common code to allocate shadow
 pages from vCPU caches
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

Now that allocating shadow pages is isolated to a helper function, use
it in the TDP MMU as well. Keep tdp_mmu_alloc_sp() to avoid hard-coding
direct=true in multiple places.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 27996fdb0e7e..37385835c399 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1704,8 +1704,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
-						      bool direct)
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5f91e4d07a95..d4e2de5f2a6d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -173,6 +173,7 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
 
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct);
 void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8b00c868405b..f6201b89045b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -269,13 +269,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
-
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	return sp;
+	return kvm_mmu_alloc_shadow_page(vcpu, true);
 }
 
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
