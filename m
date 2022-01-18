Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA8EC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 01:57:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABFA749E46;
	Mon, 17 Jan 2022 20:57:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G0ddAxa6jAzN; Mon, 17 Jan 2022 20:57:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBEEF49EC5;
	Mon, 17 Jan 2022 20:57:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B26BC49E46
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d2T7VIpIWd87 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 20:57:09 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AEB549E1A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:09 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 d11-20020a17090a498b00b001b3fb4f070bso946579pjh.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 17:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kNn8CYLhEqc3+fS1C1muCti5DqMgFmeI9zA8ty3/McY=;
 b=JV0gxik4s7iG+F0pSgHW0H9GeVHuaJERHWeD5rrsV/yKUt/BaTg2CiG2he++8GvoYC
 84JN4Zrv8nIJeq1ncnvlf4zzaaiMHqimhl1RUX5btMrpbpCEXez5L5govdO0DtTFqXpe
 1qPMkYaSFrVGF9sTTPek/Yk5NSU+E/ZxX0RFf1rgGkqu3OWzQq/ZdEEbdFFCLPkNCOl0
 NGkvA4KFzjr5oNr3/O/17Tb0WYE19NC5lcb/CCnwtUS5v1X7fxIFKoDu+7dcG7n+SqbM
 wR5A23QbyzxvjKbfdGwOWHu+//Q1DHPt7cDO3VuZzFjs5wXb3ijuEPn+T1aQMImt2j2r
 ZYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kNn8CYLhEqc3+fS1C1muCti5DqMgFmeI9zA8ty3/McY=;
 b=dq8QNLeoAnwT7LprT6pQZshHx98K9IA/G04Gx/QPXSY2VPT/FoDb2X96x6uoobiwpl
 PCRMY/YQ9OSALA6JRFprcjlbTitABpoijOBntXYUO6oYhGUxdyzwvFo9yzP0kbWz9r2s
 nlXWsZG+Up6ZVNeCAV79buqgEGU9MwsGnWr9mxNPALKYe57j2nmUVu9JfcFpPeGnp4X7
 /8f7b2Fq/iNf600NZ2fBqxTwfP+dzB/xT3SkWOlhBm8cA83IQa9aPsZnPpfNvJtpZtVY
 O0b1KQk7nZoMCWkcD9cymlNd//l3b1PsC7sTt4wBr4QnyXpQGWopP2mHjSOSqdZ/y1+U
 oFwA==
X-Gm-Message-State: AOAM531wBRW5QIgMuUfY1IbKgfWmhRKvQkQIbtFqjzJFW7a8UajXvDHF
 w7oo1+605xpfB9+/oEWtYqjUx3RfN8uJeiDsTQ==
X-Google-Smtp-Source: ABdhPJwW5s1OUDoCrjyIaYH31QlroY8rIzcRgns4gmRHP+WHtSBr34woEKWFDWZu2+t0SN6I/FBVtYLD/diOGUPEOg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:902:d2c8:b0:14a:55fb:cfe5 with
 SMTP id n8-20020a170902d2c800b0014a55fbcfe5mr25322479plc.51.1642471028683;
 Mon, 17 Jan 2022 17:57:08 -0800 (PST)
Date: Tue, 18 Jan 2022 01:57:01 +0000
In-Reply-To: <20220118015703.3630552-1-jingzhangos@google.com>
Message-Id: <20220118015703.3630552-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 1/3] KVM: arm64: Use read/write spin lock for MMU protection
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Raghavendra Rao Ananta <rananta@google.com>
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

Replace MMU spinlock with rwlock and update all instances of the lock
being acquired with a write lock acquisition.
Future commit will add a fast path for permission relaxation during
dirty logging under a read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 36 +++++++++++++++----------------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3b44ea17af88..6c99c0335bae 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -50,6 +50,8 @@
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
 
+#define KVM_HAVE_MMU_RWLOCK
+
 /*
  * Mode of operation configurable with kvm-arm.mode early param.
  * See Documentation/admin-guide/kernel-parameters.txt for more information.
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bc2aba953299..cafd5813c949 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -58,7 +58,7 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 			break;
 
 		if (resched && next != end)
-			cond_resched_lock(&kvm->mmu_lock);
+			cond_resched_rwlock_write(&kvm->mmu_lock);
 	} while (addr = next, addr != end);
 
 	return ret;
@@ -179,7 +179,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	phys_addr_t end = start + size;
 
-	assert_spin_locked(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
 	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
 				   may_block));
@@ -213,13 +213,13 @@ static void stage2_flush_vm(struct kvm *kvm)
 	int idx, bkt;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_flush_memslot(kvm, memslot);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -720,13 +720,13 @@ void stage2_unmap_vm(struct kvm *kvm)
 
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	mmap_read_unlock(current->mm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -736,14 +736,14 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
 	if (pgt) {
 		mmu->pgd_phys = 0;
 		mmu->pgt = NULL;
 		free_percpu(mmu->last_vcpu_ran);
 	}
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
 		kvm_pgtable_stage2_destroy(pgt);
@@ -783,10 +783,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (ret)
 			break;
 
-		spin_lock(&kvm->mmu_lock);
+		write_lock(&kvm->mmu_lock);
 		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
 					     &cache);
-		spin_unlock(&kvm->mmu_lock);
+		write_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
 
@@ -834,9 +834,9 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	start = memslot->base_gfn << PAGE_SHIFT;
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
 
@@ -1212,7 +1212,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1271,7 +1271,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
@@ -1286,10 +1286,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	trace_kvm_access_fault(fault_ipa);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
 	kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 
 	pte = __pte(kpte);
 	if (pte_valid(pte))
@@ -1692,9 +1692,9 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 /*
-- 
2.34.1.703.g22d0c6ccf7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
