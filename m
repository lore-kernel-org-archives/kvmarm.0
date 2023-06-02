Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187D21C759
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:34 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-53425d37fefso973842a12.3
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722174; x=1688314174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XlXfZDaqwtQ8jb+NBFxxHmMdNa0dhVq7sf+3J9mNCvc=;
        b=Cav0E0cCrA4YixnMBQKMfIUVj88wiap2lnIB8ag1Iz/8mWp6WkXueCvYRCBiVgJMpL
         yz6b5GmGWPhdoaqfWLr4eMh+mes1ArSi+nNH2aSvBuPWl2X06K+1JFMN+UK2I8zKDZ+Y
         An4/Ccw/5HBcgWIwlUsNKHK+GBxiwi6UrW0Rt5OfBwhcgGTE2dlnkWyH08h03FWRL/+p
         PpYax2iQC4+/Q7s8QR0zA1oOFG5toYWxuVQyxHq17uCmAv8sJvsjFT497G95S2n7vNCo
         An7ffox8QUfjjPO3WBaFb5yO8HO3WOQ44El3H8raJwdkFn/AASepix+It/ssVM4Hws1C
         WsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722174; x=1688314174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlXfZDaqwtQ8jb+NBFxxHmMdNa0dhVq7sf+3J9mNCvc=;
        b=aGE50azoy02XfJZBKo0I77Xivlj7VMOGkuwVcmyufbGua9ccI6kge/NlHO/m+ZxMF3
         pc+YJDiGk6aP514qyDTBVpjen2lyGwE3LkYdgIuipWVcfiSvDvj785AOvtIpZLWpxgbH
         DQ9Q000teoZUh6ybqxi4bERiQJWiJA673nSjMwDEbgx0fCYZWL//uCx80+64kVx9zeXx
         DGfs32o1wYRP62V5TpRi5it5xpUCjXIYISkkYisjemeWRUtTI74O2kc6VmTHPJ571IqG
         UasXsli4vRwZFkAvo/p6vMeFiAD4T3VFQJqSMD22WLxKVAVT94c0MSy/U2YGnut826em
         PvHw==
X-Gm-Message-State: AC+VfDx+oQS2JpwJQj5NXHNOxsf5+C7m5HGF5Xvagc4D6cMsiV0MItyF
	YFUq/LV8ZOTauC9OIfEq2q4vxnYrl/Q1
X-Google-Smtp-Source: ACHHUZ63/E8GjVgWNJSqqa8vS+/kUt+EPMZ2lBAM1R4WdW2tBWK9Y4EulGJYzAllZOblN3IVUjTbhEd8OzIe
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:385:0:b0:530:70cb:6da9 with SMTP id
 127-20020a630385000000b0053070cb6da9mr2521810pgd.10.1685722173764; Fri, 02
 Jun 2023 09:09:33 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:05 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-8-vipinsh@google.com>
Subject: [PATCH v2 07/16] KVM: mmu: Move mmu lock/unlock to arch code for
 clear dirty log
From: Vipin Sharma <vipinsh@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Move mmu_lock lock and unlock calls from common code in
kvm_clear_dirty_log_protect() to arch specific code in
kvm_arch_mmu_enable_log_dirty_pt_masked(). None of the other code inside
the for loop of kvm_arch_mmu_enable_log_dirty_pt_masked() needs mmu_lock
exclusivity apart from the arch specific API call.

Future commits will change clear dirty log operations under mmu read
lock instead of write lock for ARM and, potentially, x86 architectures.

No functional changes intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/mmu.c   | 2 ++
 arch/mips/kvm/mmu.c    | 2 ++
 arch/riscv/kvm/mmu.c   | 2 ++
 arch/x86/kvm/mmu/mmu.c | 3 +++
 virt/kvm/dirty_ring.c  | 2 --
 virt/kvm/kvm_main.c    | 4 ----
 6 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6db9ef288ec3..0c2c2c0846f1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1125,6 +1125,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
+	write_lock(&kvm->mmu_lock);
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
@@ -1139,6 +1140,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	 */
 	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 		kvm_mmu_split_huge_pages(kvm, start, end);
+	write_unlock(&kvm->mmu_lock);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index e8c08988ed37..33c5af333ff9 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -419,7 +419,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	gfn_t start = base_gfn +  __ffs(mask);
 	gfn_t end = base_gfn + __fls(mask);
 
+	spin_lock(&kvm->mmu_lock);
 	kvm_mips_mkclean_gpa_pt(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 /*
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f2eb47925806..fe026ff5eb65 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -399,7 +399,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
+	spin_lock(&kvm->mmu_lock);
 	gstage_wp_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..6fff4228e31c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1382,6 +1382,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
+	write_lock(&kvm->mmu_lock);
 	/*
 	 * Huge pages are NOT write protected when we start dirty logging in
 	 * initially-all-set mode; must write protect them here so that they
@@ -1412,6 +1413,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
 	else
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+
+	write_unlock(&kvm->mmu_lock);
 }
 
 int kvm_cpu_dirty_log_size(void)
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index c1cd7dfe4a90..d894c58d2152 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -66,9 +66,7 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
 		return;
 
-	KVM_MMU_LOCK(kvm);
 	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
-	KVM_MMU_UNLOCK(kvm);
 }
 
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13aed654111a..747bfa2f1dd3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2160,7 +2160,6 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 		memset(dirty_bitmap_buffer, 0, n);
 
-		KVM_MMU_LOCK(kvm);
 		for (i = 0; i < n / sizeof(long); i++) {
 			unsigned long mask;
 			gfn_t offset;
@@ -2176,7 +2175,6 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
-		KVM_MMU_UNLOCK(kvm);
 	}
 
 	if (flush)
@@ -2271,7 +2269,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	KVM_MMU_LOCK(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -2294,7 +2291,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 								offset, mask);
 		}
 	}
-	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-- 
2.41.0.rc0.172.g3f132b7071-goog

