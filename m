Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A54838DD6
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 18:19:49 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59f7d109926so92284437b3.2
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 11:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695752388; x=1696357188; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7evrq3PKBiHzaLA4DGci/aYqgw5Y4nsW4sL/8l2Nq7I=;
        b=CezcnnsylZVm97py/n04YSn5O1nnZVKPijYXOOMibS2Yc1GxctMYgaoiN24mLra6bx
         HWENSNtsDiB8h7QmH0GobsXPQNMZwlIrIXK2aXC6B4WqoNS90WYPWsj4WyHoFIcPDNut
         11Q+VJSeSowxtB26UIwiONorvhC8L4OQNwcMNQLndNvbYd1z+0EN6Mc/0HV14KXo82bd
         4CLr8xMH5EetnBbh5QOs8d37+E6IjPof3dYBRAPwnqSWzZftLteTdmaPg2cfrwK2TeGE
         Cyhyv4Ua97UwPmnXah0dpDmT2faH4Kuj+M06nfEByaYoS7Y3FS1/aMoXqk3jXox1hdon
         JWog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695752388; x=1696357188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7evrq3PKBiHzaLA4DGci/aYqgw5Y4nsW4sL/8l2Nq7I=;
        b=u52U8UDWgCm+qMRssHjEXqjj3hzEbsLorA5Ww+k06uqpeysLVPWlyxuSWRIdzxq7nB
         Za5O6LaVImfrvRwP2t7jixCi9UacBirWMKl9ezaDaudmxFs/xXz23gjytZV27Yrurb53
         rWYRFVhRlDDyIpVQSb/WMdaejGIHtm/UvIgP9c1yHmkkb2sPZqCBkphbF4LWICRvklS8
         TEbKntrKO5LUkpF2kf3/te8kIx9zmHKAho919SN2zHFW8a+1ek9gKZXgsHaqiZsgwa34
         Sn4Ki0MNWyQHuSH2e+Huom3PpqjgP2lwxFNXCuWbQyxEZayWOEXLk0tKuGYGyPdsJ9qj
         dGYQ==
X-Gm-Message-State: AOJu0YyeImgmw5EP6DORHRHuax4PGtek4DZqpIqfxqDWzQIqqzALKnY3
	lSW0YL+0T4e6e9Etbwa4S7xoWVOS16Syuv7e
X-Google-Smtp-Source: AGHT+IFsBLgs3gQ7K5g/UspJwVgIViCv0ygjK5w+Pz4KI1o7o1An2/fTMUVh8EL5Mm2ZDlEZ0xrd5xxhWPj51vn2
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a0d:ec10:0:b0:59b:e1db:562c with SMTP
 id q16-20020a0dec10000000b0059be1db562cmr140768ywn.5.1695752388237; Tue, 26
 Sep 2023 11:19:48 -0700 (PDT)
Date: Tue, 26 Sep 2023 19:19:32 +0100
In-Reply-To: <20230926181932.1650692-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926181932.1650692-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230926181932.1650692-3-vdonnefort@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: Use folio for THP adjustment
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, willy@infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Now transparent huge pages use folios, we can check efficiently if a
page is mapped by a block by checking the folio size. This is saving a
page table walk.

It is safe to read the folio in this path. We've just increased its
refcount (GUP from __gfn_to_pfn_memslot()). This will prevent attempts
of splitting the huge page.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index de5e5148ef5d..69fcbcc7aca5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -791,51 +791,6 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 	return 0;
 }
 
-static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
-	/* We shouldn't need any other callback to walk the PT */
-	.phys_to_virt		= kvm_host_va,
-};
-
-static int get_user_mapping_size(struct kvm *kvm, u64 addr)
-{
-	struct kvm_pgtable pgt = {
-		.pgd		= (kvm_pteref_t)kvm->mm->pgd,
-		.ia_bits	= vabits_actual,
-		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
-				   CONFIG_PGTABLE_LEVELS),
-		.mm_ops		= &kvm_user_mm_ops,
-	};
-	unsigned long flags;
-	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
-	u32 level = ~0;
-	int ret;
-
-	/*
-	 * Disable IRQs so that we hazard against a concurrent
-	 * teardown of the userspace page tables (which relies on
-	 * IPI-ing threads).
-	 */
-	local_irq_save(flags);
-	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
-	local_irq_restore(flags);
-
-	if (ret)
-		return ret;
-
-	/*
-	 * Not seeing an error, but not updating level? Something went
-	 * deeply wrong...
-	 */
-	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
-		return -EFAULT;
-
-	/* Oops, the userspace PTs are gone... Replay the fault */
-	if (!kvm_pte_valid(pte))
-		return -EAGAIN;
-
-	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
-}
-
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
@@ -1274,7 +1229,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  *
  * Returns the size of the mapping.
  */
-static long
+static unsigned long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
 			    phys_addr_t *ipap)
@@ -1287,10 +1242,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * block map is contained within the memslot.
 	 */
 	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		int sz = get_user_mapping_size(kvm, hva);
-
-		if (sz < 0)
-			return sz;
+		size_t sz = folio_size(pfn_folio(pfn));
 
 		if (sz < PMD_SIZE)
 			return PAGE_SIZE;
@@ -1385,7 +1337,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
-	long vma_pagesize, fault_granule;
+	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
@@ -1530,11 +1482,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
 								   hva, &pfn,
 								   &fault_ipa);
-
-		if (vma_pagesize < 0) {
-			ret = vma_pagesize;
-			goto out_unlock;
-		}
 	}
 
 	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {
-- 
2.42.0.515.g380fc7ccd1-goog

