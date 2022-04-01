Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453C8C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:20:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA054B296;
	Fri,  1 Apr 2022 14:20:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lFbDXbVXMIeC; Fri,  1 Apr 2022 14:20:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4CFD4B2CE;
	Fri,  1 Apr 2022 14:20:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C604B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pf7MiUD0X8Vv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:10 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25E664B25D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:10 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 c6-20020a621c06000000b004fa7307e2e0so2006064pfc.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5zXRbPH5UCC0MzIPY39weUiVp/chM0xOMHiRWD4la3c=;
 b=judHef9BAzgj4FgeW1vRm9YBTxJbUYxIamY2hI0NMvlM3cr5VrZONZvMzgzY7mB5fc
 Et/RNC+awLN7YqYwnnpHGoSFIrpJq2iHlgSKmbY1a8X8r6AEMzIShNB2vOGVmDUH236e
 bLg+ZXy5E+OlhsYteEkCa49jGpzhz/nHN1WgF+BBZ9kL6bi5bSvI0HyGYah0G90zn0E7
 eWj9EUCrQC63YZptaVS06Wg5k6oo7X0VSsM4lBcYI4RQ3zm+9gffX0txYBDSpgOjhiIG
 tQBtKSlr0ySXNad11oRT+rju3gtUZm+AEg6oBd7n7RsnJLiJaciztvxcMN5HPBhVNkqD
 LwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5zXRbPH5UCC0MzIPY39weUiVp/chM0xOMHiRWD4la3c=;
 b=f/Az9A1M26ayOXy+UUdNdXasyVBCD8K6JH7gjguE8Uw8EsyKVF6M2ue8+Z1tmyRbA9
 cbIzqjOVGAOo1XFSD9kRS9U8SePtyA9ecFM9DiNS7WT1vPaqTeIDOOWYrdJYzPwjOc+b
 otabEUnOKMPGubKKtKKBV8L5gitIx0xcLoH+IBAvQmv2M/nymN6aqgL0hJxYXrIFF/mx
 UljA3XoA5o1VzpRYYYQ5+LZGZz/Qb73BIx2N5BUDj5N9SavcvSFCbsDUxlabqvyu1473
 fcAUURZNzkDSaqNdmUTmDWnM9VQnSxEBuEXXNFPHw2RAd2++3DQTZCxdy88jeGZnxKju
 R53w==
X-Gm-Message-State: AOAM530Z5r2x8301mLVnOuSdNquuiUFIfwEU3cUGG+E6vi8v3w3qE2yQ
 eTyERberpxi8JlvOhfsp+Wr9p0kVnVyN9Q==
X-Google-Smtp-Source: ABdhPJyefj5gqr540fQC5ORDWM5/+t3TXsB4vdSmUL266n9Vg0IBeJqnGewfNN7AZaQki9m2eBNaBN075pqkiQ==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e8d1:b0:156:5651:777 with SMTP id
 v17-20020a170902e8d100b0015656510777mr9260591plg.65.1648835769357; Fri, 01
 Apr 2022 10:56:09 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:36 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 05/23] KVM: x86/mmu: Rename shadow MMU functions that deal
 with shadow pages
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

Rename 3 functions:

  kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
  kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
  kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()

This change makes it clear that these functions deal with shadow pages
rather than struct pages. Prefer "shadow_page" over the shorter "sp"
since these are core routines.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8fdddd25029d..dc1825de0752 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1668,7 +1668,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1706,7 +1706,8 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2130,7 +2131,7 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, role.direct);
+	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
 
@@ -2146,8 +2147,9 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 	bool created = false;
@@ -2204,7 +2206,7 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 
 	role = kvm_mmu_child_role(sptep, direct, access);
-	return kvm_mmu_get_page(vcpu, gfn, role);
+	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
@@ -2480,7 +2482,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_shadow_page(sp);
 	}
 }
 
@@ -3407,7 +3409,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	if (role.has_4_byte_gpte)
 		role.quadrant = quadrant;
 
-	sp = kvm_mmu_get_page(vcpu, gfn, role);
+	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
