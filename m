Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8899A8F4E
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 23:55:06 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id t25-20020a252d19000000b00b341ad1b626so9322575ybt.19
        for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 16:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678751705;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VkWifiOZWCx17ERcyP19NDXhRCR0dMhnRj+TI/ZHeGo=;
        b=TvtrIUPpjdjaDwJjo0RLO8idek0XTrVD7IZA/D948AdJ3jGlgi/aukHv2H5ZQrvcNi
         sqwDPOSZz6YAq81yFy3t2f1qqT7jy2AwT9Hu/5KS8d16kRwuw23dVG8oWDJxI0KBTaCJ
         vyLw1eOB98JSEDZShI1PAomu+7Elob5kgvuxrPE7zcYhTU5XHw84sD/yvD5qtDc4+RMV
         UObr0/d6yqwZHdIqlDWZE/LL+MS594vZv4Bdv01Rz0gFLKcYgQc+RjTU9JGeqsmPMoiO
         dDiFcxX2s1RzOdnthCa8owr3U0eA7usc4jf0wuVCVfmRLo3ME6ACxG++CZeSH56tt1da
         6UbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678751705;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VkWifiOZWCx17ERcyP19NDXhRCR0dMhnRj+TI/ZHeGo=;
        b=fPA6jF5APUN/4lYIpxYVHOBxRo6bZEJ88QonFmyjKX2V7yJpg3lAAia3rHq43HEFpq
         m/b4KuRUK1f+aDHExHUa0cEQswUc9iNjcrco+fO57EIK7Ji21NgThLDYoS+EB/9l6i4C
         8H7oPGI/t8dSe2OhgGFUb1LIKjP1X8mGXu9IQQI5V4+l8Jlv1B0rYCPvXCwE0J7ck1Db
         2l19XO++t8glwcfZZc4ElrBsok5+1XRBuZJT5wVpDgKxqSQf2sdpJRA92EHBbiXX5eVM
         OueVZL5vk6Qmxd9Muik/PPkJ8dYhbdZWQp1V3UJTlhS22nLcWovmoc1x8C86DZiY45Az
         y15A==
X-Gm-Message-State: AO0yUKV3o8xR/8utNIB4/LX/ZSuQ8xY2Z1KNGnQ9OSInGPcKbJm6sdtR
	vfM+qfS/p+H7ZTkggEkkdWEKOJ0t5MZfBg==
X-Google-Smtp-Source: AK7set8Xx7Y7NTWYub347kzpK+eiVQUCaW6+mGeLKEFajo2Yu1VarpuWrgufy6NQGbwmwy3O5aaGj1ZoCFy5+A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:f03:0:b0:a74:87b0:4090 with SMTP id
 x3-20020a5b0f03000000b00a7487b04090mr15188970ybr.3.1678751705474; Mon, 13 Mar
 2023 16:55:05 -0700 (PDT)
Date: Mon, 13 Mar 2023 16:54:54 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313235454.2964067-1-dmatlack@google.com>
Subject: [PATCH] KVM: arm64: Retry fault if vma_lookup() results become invalid
From: David Matlack <dmatlack@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Will Deacon <will@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Christoffer Dall <c.dall@virtualopensystems.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, David Matlack <dmatlack@google.com>, stable@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
detect if the results of vma_lookup() (e.g. vma_shift) become stale
before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
VMA could be changed by userspace after vma_lookup() and before KVM
reads the mmu_invalidate_seq, causing KVM to install page table entries
based on a (possibly) no-longer-valid vma_shift.

Re-order the MMU cache top-up to earlier in user_mem_abort() so that it
is not done after KVM has read mmu_invalidate_seq (i.e. so as to avoid
inducing spurious fault retries).

This bug has existed since KVM/ARM's inception. It's unlikely that any
sane userspace currently modifies VMAs in such a way as to trigger this
race. And even with directed testing I was unable to reproduce it. But a
sufficiently motivated host userspace might be able to exploit this
race.

Fixes: 94f8e6418d39 ("KVM: ARM: Handle guest faults in KVM")
Cc: stable@vger.kernel.org
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/arm64/kvm/mmu.c | 48 +++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..f54408355d1d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1217,6 +1217,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	/*
+	 * Permission faults just need to update the existing leaf entry,
+	 * and so normally don't require allocations from the memcache. The
+	 * only exception to this is when dirty logging is enabled at runtime
+	 * and a write fault needs to collapse a block entry into a table.
+	 */
+	if (fault_status != ESR_ELx_FSC_PERM ||
+	    (logging_active && write_fault)) {
+		ret = kvm_mmu_topup_memory_cache(memcache,
+						 kvm_mmu_cache_min_pages(kvm));
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
@@ -1269,37 +1283,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		fault_ipa &= ~(vma_pagesize - 1);
 
 	gfn = fault_ipa >> PAGE_SHIFT;
-	mmap_read_unlock(current->mm);
-
-	/*
-	 * Permission faults just need to update the existing leaf entry,
-	 * and so normally don't require allocations from the memcache. The
-	 * only exception to this is when dirty logging is enabled at runtime
-	 * and a write fault needs to collapse a block entry into a table.
-	 */
-	if (fault_status != ESR_ELx_FSC_PERM ||
-	    (logging_active && write_fault)) {
-		ret = kvm_mmu_topup_memory_cache(memcache,
-						 kvm_mmu_cache_min_pages(kvm));
-		if (ret)
-			return ret;
-	}
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	/*
-	 * Ensure the read of mmu_invalidate_seq happens before we call
-	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
-	 * the page we just got a reference to gets unmapped before we have a
-	 * chance to grab the mmu_lock, which ensure that if the page gets
-	 * unmapped afterwards, the call to kvm_unmap_gfn will take it away
-	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
-	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
+	 * Read mmu_invalidate_seq so that KVM can detect if the results of
+	 * vma_lookup() or __gfn_to_pfn_memslot() become stale prior to
+	 * acquiring kvm->mmu_lock.
 	 *
-	 * Besides, __gfn_to_pfn_memslot() instead of gfn_to_pfn_prot() is
-	 * used to avoid unnecessary overhead introduced to locate the memory
-	 * slot because it's always fixed even @gfn is adjusted for huge pages.
+	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
+	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
-	smp_rmb();
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
 				   write_fault, &writable, NULL);

base-commit: 96a4627dbbd48144a65af936b321701c70876026
-- 
2.40.0.rc1.284.g88254d51c5-goog

