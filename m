Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830A0C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AC6B4B0FB;
	Fri, 15 Apr 2022 17:59:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aiDeqTp6zEZW; Fri, 15 Apr 2022 17:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18FCD4B10C;
	Fri, 15 Apr 2022 17:59:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3E94A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UqhzrTrmA7Ns for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:29 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 163E049F24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:24 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 x16-20020a6bfe10000000b006409f03e39eso5459036ioh.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=we5tUcZWUFX29TKi0tS/Yi5sEjxnPk5PaYrhMJdNw1U=;
 b=O1SErvMM/5NizynFN7dxIWF/wAOfb8Mq9ZfTSGeW0QBIGQpcAPGMZiYPK5b+AIE+yj
 08zA/OxjxYQfyzgWCjGX98P8LIEuoV19f+IbszwnCQUQtevPI3XYw1re2k4fZZe6/vAf
 Qpexkx6ehQQAsh1RxGlFf+N5b4EPHjVdZkItOeRiv/yIkybMfQ6rKCCTjah2MjXE8ysA
 UfJUeFHEmDdjsqYhKAbeH01CdWClTD/JQdzWn2NRgu/MbALmGjnCzElEQCYlDtSQfUul
 EPbBWfGohELG4mrVx0BVrh06dZ/wmMGcdkJN6MSYmZEdZM8jKw5KOVWNj7WfK3JyNrde
 ComQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=we5tUcZWUFX29TKi0tS/Yi5sEjxnPk5PaYrhMJdNw1U=;
 b=a23Y0YNbrgh15/E2jSNgnWxxdWC2njA2irMvWwVWzpQzmuTg1sPKX2jSsWptItNgsS
 Bsp2gXFms6B2Qrgb7CrjbX8BTWkga8x7X2+5GiJUTyaY6SZIyrhh2vz5d3ITZmTr0dAf
 VhVASHCP7aFDQ0Hrx+4PgkVAANlbnrjhJQR6ww8KSobU+SlqOeW64khrjNmZMi1t0H3f
 pv4ads3qq9VQezARpFf75lj8xXo4qKJ4OvRblc6cdiuYeF2w9Bty6lRYSlckdNQa5Z1d
 4uQQNkb+6rCO7P4IRQROrjGp2SIBS1GRlcJzYKmXHWKljPkNaR8Lx6EBLQCZTUxj0ufH
 BZlA==
X-Gm-Message-State: AOAM531c6SDVbdGKExv7vAuaBUYI81Hi7Zi4vibmoV+FuSnhwy3b8i8x
 MRFPW4FHBenkBX65rlFmBPk16BQsRcJYFojyhwEMZQrEm75DthCLuOege/+OOW4CGAtb8Ei0ZAd
 e0H8w4OR1LMXJp/v6CmIpBOpjc6ZSq0dryh2VwkI8xYmhXE0CXslAupPZmBoEzLqkpINwhg==
X-Google-Smtp-Source: ABdhPJzFhPu6MxIliWrYx7BlAqWDvC1LTp6uI8FxSJyQJeYO+JKxmOQwyxXOX0XwY8FpVX7WQSGMEYCJYH0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1807:b0:2ca:4b88:1a42
 with SMTP id
 a7-20020a056e02180700b002ca4b881a42mr312136ilv.258.1650059963514; Fri, 15 Apr
 2022 14:59:23 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:59:00 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-17-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Voila! Since the map walkers are able to work in parallel there is no
need to take the write lock on a stage 2 memory abort. Relax locking
on map operations and cross fingers we got it right.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/mmu.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 63cf18cdb978..2881051c3743 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool use_read_lock = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
-		use_read_lock = (fault_status == FSC_PERM && write_fault &&
-				 fault_granule == PAGE_SIZE);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	/*
-	 * To reduce MMU contentions and enhance concurrency during dirty
-	 * logging dirty logging, only acquire read lock for permission
-	 * relaxation.
-	 */
-	if (use_read_lock)
-		read_lock(&kvm->mmu_lock);
-	else
-		write_lock(&kvm->mmu_lock);
+	read_lock(&kvm->mmu_lock);
+
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1322,8 +1312,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
 	} else {
-		WARN_ONCE(use_read_lock, "Attempted stage-2 map outside of write lock\n");
-
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     mmu_caches, true);
@@ -1336,10 +1324,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	if (use_read_lock)
-		read_unlock(&kvm->mmu_lock);
-	else
-		write_unlock(&kvm->mmu_lock);
+	read_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
