Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E17C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 850994B137;
	Sat, 14 May 2022 06:09:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mz9SfXJkcnT9; Sat, 14 May 2022 06:09:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D61F14B231;
	Sat, 14 May 2022 06:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B5AF49EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1bjvL7fsyMto for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:46 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 559424B137
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:46 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 g5-20020a62e305000000b0050d2dba0c5dso4469049pfh.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q2iE0Cxpa01PZtydAP3+0EHT9/ovzFKtM4CTxOqopNo=;
 b=kBtgOZb6L01L9Scbsk0n3b6QXUjGTLwW6lXEIWk5vM2VilLkNRKTThEc67CyICmcwF
 vcTVppd0iFdeeb7Mmnohtzf86ll0NLPKIcb7HUv41efPtdWaC1ZEjj4ncSlKRpTNQnpT
 IuzmjMIAHKXiE33XdF3CkiVjrjYuKO5/cEELlNw3aYcqjBupe4yRnxeO+cS9LVBdF/hc
 V4ThqGXHdwel8AZNGb+m+R0GgCp0iEuSIz5bzLEtilh6UiTkOKdKCw1qHh5j+KPoBR2Q
 sL1eCqMeYRkaY5jCFp8Dfe8PAjC3dwvlrjkPo8fMjPM2zM96H1fjPXQyAwNdAKOdvh6T
 fLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q2iE0Cxpa01PZtydAP3+0EHT9/ovzFKtM4CTxOqopNo=;
 b=j+hVU3fzR2KSC9z/wlbvJIYpcXbTOJawR33uk0kdXrCHBF6LRtiSvX5sg7GPdDDvmI
 5DgoRl6YBvmSmg8SOpWPsJMtRO2E2CWrKVOObGeTm6RJmWPjymbIMFfLp3AZzVnYKyrF
 l+K4FBr3ZHz6hEGoCR8tnUQi9MzvvWRjk0zHtkCi3isBXCBhDxjN24Nm0hMJ1AE/ydvM
 EvzuSHjjm36UBVQQWqrTZY2uIGHANK9h/X0JcDmKa88qELdye4AB2fKiAW/lWJcJ0em4
 XdzFizQR2w3x7T1U4F1+j3rufbst/WMNpo8gx/mC5h74K+j9R6Fl2nguWFt4n5Pk3HPt
 kxuA==
X-Gm-Message-State: AOAM530wKys0cgnGEW+wT/sIKDxQZAGHmbCOCknhpd+LcKPyMI8i7Ba+
 IfCLKhNEbtD2tyeYB7eEKDC4OIa531b/CQ==
X-Google-Smtp-Source: ABdhPJwh6exFnjxzxfjImvwwYdeFhG/KUqrwnYKnvqBxa4wxH/fbyWqIfWK/ivcZQfvxLjg8cRc5PB46PP8o3w==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:3b46:b0:1dc:b314:52e6 with SMTP
 id ot6-20020a17090b3b4600b001dcb31452e6mr6594921pjb.134.1652473725945; Fri,
 13 May 2022 13:28:45 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:07 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 09/21] KVM: x86/mmu: Pass memory caches to allocate SPs
 separately
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
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

Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
will allocate the various pieces of memory for shadow pages as a
parameter, rather than deriving them from the vcpu pointer. This will be
useful in a future commit where shadow pages are allocated during VM
ioctls for eager page splitting, and thus will use a different set of
caches.

Preemptively pull the caches out all the way to
kvm_mmu_get_shadow_page() since eager page splitting will not be calling
kvm_mmu_alloc_shadow_page() directly.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 16001b019e1a..44431c0b797f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2075,17 +2075,25 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+/* Caches used when allocating a new shadow page. */
+struct shadow_page_caches {
+	struct kvm_mmu_memory_cache *page_header_cache;
+	struct kvm_mmu_memory_cache *shadow_page_cache;
+	struct kvm_mmu_memory_cache *gfn_array_cache;
+};
+
 static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      struct hlist_head *sp_list,
 						      union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
 	if (!role.direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->gfns = kvm_mmu_memory_cache_alloc(caches->gfn_array_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -2107,9 +2115,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
-						    gfn_t gfn,
-						    union kvm_mmu_page_role role)
+static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						      struct shadow_page_caches *caches,
+						      gfn_t gfn,
+						      union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
@@ -2120,13 +2129,26 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
+{
+	struct shadow_page_caches caches = {
+		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
+		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
+		.gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
+	};
+
+	return __kvm_mmu_get_shadow_page(vcpu, &caches, gfn, role);
+}
+
 static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
 {
 	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
