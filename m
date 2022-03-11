Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2846C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C66D49EAC;
	Fri, 11 Mar 2022 03:48:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sFADKd91hvkG; Fri, 11 Mar 2022 03:48:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51BA449F31;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2566B41173
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XrEgQwfV8ZCy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:44 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F070340FAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:43 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 p21-20020a631e55000000b00372d919267cso3800625pgm.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PR1rQAV6XpL1OAtut/tZohbNM2n5NWW4hR39uHFMmHs=;
 b=JREOgPoLzDDtiHf1IB99ZCsJV+z9ufBWFVMkpURvetyp3jEyGAs2o6YEPskH74BNqH
 7WmF26FHEoNxVCox407leSficGgH5ww6LB5K5LSaGEZcVddfv47Z0KQDZ2OSEncfuw9m
 92v7Hbt/vGHys2QQB1nnUcKUyOrNd0rhX+hL0MUHBikUFb4TL3LThU4aUj+pbscZTx8A
 rpGIRCeOg8KXOwzgrp+EQFNMUn9ArnU47X2XXyWsaFCppowp5wxUCU5HIdt94UO5U9vW
 OZslnV1bvhlKMGwicyF96n8kXJdz/1GSq5xk81YxfldwUaudK35H+Jy/D7nJlNcxqF1P
 gXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PR1rQAV6XpL1OAtut/tZohbNM2n5NWW4hR39uHFMmHs=;
 b=kilTUCj+MpD7cvej4zOmxXMTLJ/b98dsBWAfl//vVfzbLGgvUDScoDQef/Uv3spFlZ
 9/8FxDzMC0SyNlLcBKgO9nq9qmPOEQfgc36xgdYl5xV/tnzeomYioE4TFNJki32Y0myD
 QDn39A/ufEsf8KYiW+3DWuRump+4bd0rwbKoncMacG9aMaAcBHmxcj4x0VFMRGyda8kB
 ovlF00YzkkplfAX/twiTvMrkin/kdemmloH/+BxJ7b125CuEz3Is6v/GI3uw5OIo0lsw
 6+/hWeRBeOv9XRxp5RrPWKlZ/6yI6tFIzekTC3ewkxstvMPVluiYHeuI1UCoX5DPYx04
 +COg==
X-Gm-Message-State: AOAM533+RWzmcOPkRyBZ+aASbP+UvFTCZrkLUhw9aQ72c1+wiFE2IJyl
 iYP2nXDnMtE2bqIghMOqFyzOETOflxWUMQ==
X-Google-Smtp-Source: ABdhPJy72cfT+ItACidnNCLuDyWXf6ABkTliWSk/elCD++cwKTACMZ9AqHdEBI5pX6/vwsZztFdxcxA1tFgWPw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:d486:b0:151:8e66:621c with SMTP
 id c6-20020a170902d48600b001518e66621cmr7683225plg.141.1646958343059; Thu, 10
 Mar 2022 16:25:43 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:09 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 07/26] KVM: x86/mmu: Separate shadow MMU sp allocation from
 initialization
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:41 -0500
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

Separate the code that allocates a new shadow page from the vCPU caches
from the code that initializes it. This is in preparation for creating
new shadow pages from VM ioctls for eager page splitting, where we do
not have access to the vCPU caches.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 519910938478..e866e05c4ba5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1716,16 +1716,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	/*
-	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
-	 * depends on valid pages being added to the head of the list.  See
-	 * comments in kvm_zap_obsolete_pages().
-	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
 
@@ -2127,27 +2120,31 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
-						    struct kvm_memory_slot *slot,
-						    gfn_t gfn,
-						    union kvm_mmu_page_role role)
+static void init_shadow_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			     struct kvm_memory_slot *slot, gfn_t gfn,
+			     union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_page *sp;
 	struct hlist_head *sp_list;
 
-	++vcpu->kvm->stat.mmu_cache_miss;
+	++kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, 1);
+
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
 
 	if (!role.direct)
-		account_shadowed(vcpu->kvm, slot, sp);
-
-	return sp;
+		account_shadowed(kvm, slot, sp);
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
@@ -2164,7 +2161,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 
 	created = true;
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	sp = kvm_mmu_new_shadow_page(vcpu, slot, gfn, role);
+	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
+	init_shadow_page(vcpu->kvm, sp, slot, gfn, role);
 
 out:
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
