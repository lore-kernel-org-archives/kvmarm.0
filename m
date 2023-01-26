Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017784C92
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 18:40:52 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id a14-20020a5b0ace000000b007bf99065fcbso2792779ybr.2
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 10:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DFwDpgciw1L+9CePK1aCqtbrcF7o70D43LBFxCliFpo=;
        b=Of6oboIjKidJhm/1JTxVzKpazvnvGb4LvwhSsoRRH0ltf06rTMnWd7KywS+VJiunOF
         8Z6xG5YLHPOod6gChpn2bTqVrp5Dux/9RQDVbnQduKQPOKv/Rk03+vhOsVsJNo7rV1md
         YrTKZVMZS8mQPmPFJ9cI+1VHDwYwi7Xg0vyyNYnD1BEn+mkmDTUow4zJv+Uxh7QhRBUL
         qLznQb/GyoTlrCgNVGq9MT3CgpQdXh9N8i0EGugBztVijTxKO3CmUGf3vj1g/oBkFqiN
         3NardPzuofU5DODe4snE5Ps7GeUA2mjYjf8qZUP3Y1vcIJKO5ABMkjh8UQ/CC1eRKt1u
         ulUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFwDpgciw1L+9CePK1aCqtbrcF7o70D43LBFxCliFpo=;
        b=rISEu1AQFWVmVWNbZ1O160bI7dhy4mXFUQPSGEPpQbaC79/myYhAU1LFzjXqzRhrxS
         o26EPFkT5v1y1r/x2dAmiclud/d/tjJ+opZtfzRMIlSEBFF0/zl6v4+w3mdda+HI3t9O
         puNQ7hVgG6Pky5w384Vrvdjnhk/UEY1BrY4h54DI1ObPaZSl8ZLNCTNiDyz2iXucBIYf
         Ke45IVtsbf/i5tOtz1eEG+iDUdaAV+z1oripYwlvlWxJviRXNJtsSUNOHsTSUkyoZRN+
         N+jEhf+Xgv1VNSY/bSygrfMFoGVRc0wcYkV5R2r66+EA/RFSGciSPliYBXhWY7rgPErb
         K42A==
X-Gm-Message-State: AO0yUKUBkp+3z765xM7CixqLRaDP1FcThR67XlVIXmrcCIRKeMSpIjsK
	0jt/mnlWDC39SkN2G0EMS4XVMFsUuzeKRw==
X-Google-Smtp-Source: AK7set9XTfWS3zNHEtIz17Wp4X2tBUAb9e+3EIBo/ZJ11ztSvIuqhBLn/0bD/LNuwkfTjpc47d88KktnKtkacw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:7316:0:b0:80b:7c7c:b21c with SMTP id
 o22-20020a257316000000b0080b7c7cb21cmr1088188ybc.338.1674758451976; Thu, 26
 Jan 2023 10:40:51 -0800 (PST)
Date: Thu, 26 Jan 2023 10:40:25 -0800
In-Reply-To: <20230126184025.2294823-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126184025.2294823-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126184025.2294823-8-dmatlack@google.com>
Subject: [PATCH v2 7/7] KVM: Move kvm_arch_flush_remote_tlbs_memslot() to
 common code
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
"arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
range-based TLB invalidation where the range is defined by the memslot.
Now that kvm_flush_remote_tlbs_range() can be called from common code we
can just use that and drop a bunch of duplicate code from the arch
directories.

Note this adds a lockdep assertion for slots_lock being held when
calling kvm_flush_remote_tlbs_memslot(), which was previously only
asserted on x86. MIPS has calls to kvm_flush_remote_tlbs_memslot(),
but they all hold the slots_lock, so the lockdep assertion continues to
hold true.

Also drop the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT ifdef gating
kvm_flush_remote_tlbs_memslot(), since it is no longer necessary.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/arm64/kvm/arm.c     |  6 ------
 arch/mips/kvm/mips.c     | 10 ++--------
 arch/riscv/kvm/mmu.c     |  6 ------
 arch/x86/kvm/mmu/mmu.c   | 16 +---------------
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h |  7 +++----
 virt/kvm/kvm_main.c      | 18 ++++++++++++++++--
 7 files changed, 23 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 698787ed87e9..54d5d0733b98 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1420,12 +1420,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	kvm_flush_remote_tlbs(kvm);
-}
-
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 					struct kvm_arm_device_addr *dev_addr)
 {
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 2e54e5fd8daa..9f9a7ba7eb2b 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -199,7 +199,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	/* Flush slot from GPA */
 	kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
 			      slot->base_gfn + slot->npages - 1);
-	kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+	kvm_flush_remote_tlbs_memslot(kvm, slot);
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -235,7 +235,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
 					new->base_gfn + new->npages - 1);
 		if (needs_flush)
-			kvm_arch_flush_remote_tlbs_memslot(kvm, new);
+			kvm_flush_remote_tlbs_memslot(kvm, new);
 		spin_unlock(&kvm->mmu_lock);
 	}
 }
@@ -987,12 +987,6 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 1;
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	kvm_flush_remote_tlbs(kvm);
-}
-
 long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	long r;
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 66ef19676fe4..87f30487f59f 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -406,12 +406,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	kvm_flush_remote_tlbs(kvm);
-}
-
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
 {
 }
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 284c812db63b..37bfbb592051 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6539,7 +6539,7 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 	 */
 	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
 			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_flush_remote_tlbs_memslot(kvm, slot);
 }
 
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
@@ -6558,20 +6558,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	}
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	/*
-	 * All current use cases for flushing the TLBs for a specific memslot
-	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
-	 * The interaction between the various operations on memslot must be
-	 * serialized by slots_locks to ensure the TLB flush from one operation
-	 * is observed by any other operation on the same memslot.
-	 */
-	lockdep_assert_held(&kvm->slots_lock);
-	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
-}
-
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b0bfe37390b..4b74a855765f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12617,7 +12617,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		 * See is_writable_pte() for more details (the case involving
 		 * access-tracked SPTEs is particularly relevant).
 		 */
-		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
+		kvm_flush_remote_tlbs_memslot(kvm, new);
 	}
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 276187f084c8..b3e759ea2c0f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1357,6 +1357,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
+void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1385,10 +1387,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					unsigned long mask);
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
-#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot);
-#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
+#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
 int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 		      int *is_dirty, struct kvm_memory_slot **memslot);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c9fc693a39d9..9c10cd191a71 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -381,6 +381,20 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages)
 	kvm_flush_remote_tlbs(kvm);
 }
 
+void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot)
+{
+	/*
+	 * All current use cases for flushing the TLBs for a specific memslot
+	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
+	 * The interaction between the various operations on memslot must be
+	 * serialized by slots_locks to ensure the TLB flush from one operation
+	 * is observed by any other operation on the same memslot.
+	 */
+	lockdep_assert_held(&kvm->slots_lock);
+	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
+}
+
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_arch_flush_shadow_all(kvm);
@@ -2188,7 +2202,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	}
 
 	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
+		kvm_flush_remote_tlbs_memslot(kvm, memslot);
 
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
 		return -EFAULT;
@@ -2305,7 +2319,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
+		kvm_flush_remote_tlbs_memslot(kvm, memslot);
 
 	return 0;
 }
-- 
2.39.1.456.gfc5497dd1b-goog

