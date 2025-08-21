Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147622EBB9E
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810063; cv=none; b=TGV1urBVA/yU2HaVcLTMzT4jWbsT91CVtZLQFkgYk4wVHltPOBs9i+pSNI10hfmcRaS1zSN/QUHaZZh9GAc9UmPR7NvbJZB54B0Bb3sVfd+iXpCa2ushaOZwJBxA3QXFWmyZ6uMO0A/AeXxNg2XOBXNdpMYtpiHHcfv7ATwxQuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810063; c=relaxed/simple;
	bh=0R29yrVz5jzSSmRWFh2gn4ID37EkSuIqGvyigwjoDgA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aX8R4IPCfOkEDZ1T2f9+4xaM7G3AVH/aVp5/+k2rKu9EodZ446fCjg30+x00WJjoc6TLyuA5R++NwUBQCqvzCOZwfneRd5XPpjh0p2TlIA+MTMyJTywBl+yXFSX+1T3Vc/Itar3Ecckpd6DoN7eyGKISjWNKV7j2jay96YY2Hhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lWnRkncD; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lWnRkncD"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2e60c3e7so2691588b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810061; x=1756414861; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nw5kiI6YvAO2RXGdtpyjseVagbE32KnshmO9YLBiZhk=;
        b=lWnRkncD8+VjQGeJPGLJKri5Um98Qmj1pzJpwFzzad0fB+FLerouzqiXJfHlXxXs/M
         slPpaOCusGFw+GpE76KRszmWOUvPD2H6pTnI0zB768A2z/eWJ+qS9qGLeEAu0v7xCwQ2
         LgkxvvUmueXI4m5Jfid83QHpez2p7GAKYIvcCswQ22kpnRXDQmc5ayttPR0Nozarx4e/
         mPxaqpRETgYdhbQo5GV1oOKnQ/xBeUz0XQ+htjFUvF4Sunjag0DpO0Zb0P4jbxFt4jpp
         p9wd8T025k0/0aQkxz+xyIU/8Tb1IogKJR5lQlCsldulZZqXRoel19nTrF4NPYfLj5vl
         zrlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810061; x=1756414861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nw5kiI6YvAO2RXGdtpyjseVagbE32KnshmO9YLBiZhk=;
        b=Wrp/BLLMm6SDMouhTDj5a2P9ZJr5cccfLRyHer5QUsOHN+WEjCR/wD9PUEDyFqsJAU
         UQgkyA67L011x0VODt5G03RDxGu2TQnKrg4S+HFPEBkpTb9DYaBH5kekvSAdiJV52Isi
         iK2/X0N38grusit1s15wwUUhI7r3pW5LUvK8M/NUMgzpB5ZRiZXWL34Gfg2ooFGL883b
         aRPk7xDNttk7HF2hM8FsH4hyHsr6mtnSblpdnh6AwzL6RgUG1rHbKyYY4fNKiviIZE6g
         SE0q6IG6TbSeRLnRLcCrltNTzjSQz05CK2mGzlV+kEDT7+icAyTYYc3i68hoHD6QCVxz
         ALhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy3z09mMZEVkvwxqSAJQt4ymM+x89G70s7Qd0j1dyM2G8Eu+kiFKZlNOconHZYlCj+qRfaDlM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCr5OKq/0hCYiCxeIZDbEMKFp3b9ZZ2gyDj5FxSjJ3d1WINecY
	4M5TurxNT4KhVcKjo/vWhrYCWLouNR1Geqp71HcdZT92I88PuRUA9pAofMxBrg7tUb/rjeRk/0Z
	prltY9Q==
X-Google-Smtp-Source: AGHT+IGle6xFEs66cx8IStkT7ygYTzBQ/CVc9BMQ/qOuDjmd3FaQf765ZcadOYjVlZz3dCJkQZna0ErFQAI=
X-Received: from pgww17.prod.google.com ([2002:a05:6a02:2c91:b0:b42:189a:ccf8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1582:b0:240:9126:2bde
 with SMTP id adf61e73a8af0-24340d5e4cemr792496637.46.1755810061454; Thu, 21
 Aug 2025 14:01:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:35 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-10-seanjc@google.com>
Subject: [RFC PATCH 09/16] KVM: arm64: Track perm fault granule in "struct kvm_page_fault"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add permission fault granule information to "struct kvm_page_fault", to
help capture that the granule is a property of the fault, and to make the
information readily available, e.g. without needing to be explicitly
passed if it's needed by a helper.

Opportunistically drop kvm_vcpu_trap_get_perm_fault_granule() and simply
grab the granule from the passed-in ESR.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  9 ---------
 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/kvm/mmu.c                 | 13 ++++++-------
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 8065f54927cb..93e7a0bad0fb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -449,15 +449,6 @@ bool kvm_vcpu_trap_is_translation_fault(const struct kvm_vcpu *vcpu)
 	return esr_fsc_is_translation_fault(kvm_vcpu_get_esr(vcpu));
 }
 
-static inline
-u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
-{
-	unsigned long esr = kvm_vcpu_get_esr(vcpu);
-
-	BUG_ON(!esr_fsc_is_permission_fault(esr));
-	return esr_fsc_perm_fault_granule(esr);
-}
-
 static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
 {
 	switch (kvm_vcpu_trap_get_fault(vcpu)) {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4623cbc1edf4..ec6473007fb9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -418,6 +418,7 @@ struct kvm_page_fault {
 	const bool exec;
 	const bool write;
 	const bool is_perm;
+	const u64  granule;
 
 	phys_addr_t fault_ipa; /* The address we faulted on */
 	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c6aadd8baa18..10c73494d505 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1483,14 +1483,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	short vma_shift;
 	void *memcache;
 	bool logging_active = memslot_is_logging(fault->slot);
-	long vma_pagesize, fault_granule;
+	long vma_pagesize;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	vm_flags_t vm_flags;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
-	if (fault->is_perm)
-		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
 	VM_BUG_ON(fault->write && fault->exec);
 
 	if (fault->is_perm && !fault->write && !fault->exec) {
@@ -1715,8 +1713,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * backed by a THP and thus use block mapping if possible.
 	 */
 	if (vma_pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
-		if (fault->is_perm && fault_granule > PAGE_SIZE)
-			vma_pagesize = fault_granule;
+		if (fault->is_perm && fault->granule > PAGE_SIZE)
+			vma_pagesize = fault->granule;
 		else
 			vma_pagesize = transparent_hugepage_adjust(kvm, fault);
 
@@ -1754,10 +1752,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
+	 * permissions only if vma_pagesize equals fault->granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault->is_perm && vma_pagesize == fault_granule) {
+	if (fault->is_perm && vma_pagesize == fault->granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
@@ -1806,6 +1804,7 @@ static int __kvm_handle_guest_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa
 		.write = kvm_is_write_fault(vcpu),
 		.exec  = kvm_vcpu_trap_is_exec_fault(vcpu),
 		.is_perm = esr_fsc_is_permission_fault(esr),
+		.granule = esr_fsc_is_permission_fault(esr) ? esr_fsc_perm_fault_granule(esr) : 0,
 	};
 	struct kvm_s2_trans nested_trans;
 	bool writable;
-- 
2.51.0.261.g7ce5a0a67e-goog

