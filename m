Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9CE1468EF
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041260; cv=none; b=r0PT1S2ToXv/CH0vpco5GmRDKT1guTE8BsFegIxeBQEs5DBk5ggtgOuMoQ0MQYnSYtIEfgIAf0fqeWtM7edUGJk2lLyM1usmgzVwqSUHOB/ylR/6efsaPBWtmKxgzSPA4crgY09dhEz63cqiHo/LO0jlPII8kIP6lWkduHo0NGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041260; c=relaxed/simple;
	bh=SiM4xWXwUgH8LHEU5tPvjdfJ67jD/ky4OB4FJ6Uv42A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BK0YtK6gN6GNEiiJQqfV0mnqQVEo6B4lT1kKKeAoCcvFDbRs2koQJ1L/9IUup9f2ePE8OCJnkuPUBtO5a/gEpwUbPr++YUXfm3X6jvnNM/47RJ5ov9lhPfXoZ7WFlcDBp6DHm60GZuteJ27Q/XDvS36o6pfdfnKJQydLEtOHMmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wdTy2yoN; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wdTy2yoN"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60665b5fabcso21937187b3.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041257; x=1708646057; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAJxKBXqL+4n0kIk41piMFkW8X85Amto6kELtwrWAcE=;
        b=wdTy2yoNnMvtkQXM3F859mgHC6bsQCDvHob8wyk2qv3tdqQFYXgb6TdNWMr7vsHCs0
         ihJRxi5+GMHf0T0nwZNLRTu2Ir4OVPbRltFEnsHv2Nqh0qyOmD4gMA7o6KSkUSz0HKGm
         i/7MIyqGUW4vqlrZlaTaBmwyub/xnBBqG1bpxpvf9+UjtoWmrA6CMNQmElQ/go+81qIX
         T+PPaS60VkAJgaQctiAKD7jKUo8fcqcvekuur7CFIyFjpwTB52FAVEWyP6CWC8bAecGD
         qSXzIN1AuMebLws3bo3tG0SOhf20+LH6jZco0ioIxoMpW0GYISlZlM12LX/qXH2CW9Lt
         d/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041257; x=1708646057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WAJxKBXqL+4n0kIk41piMFkW8X85Amto6kELtwrWAcE=;
        b=qxJEKBODhr7CaOr4twhE15J873rGVAaowUmevIZLnLRLbY4nDOL4zZ2NfBCb04iAwG
         WL+/oZxNl1UwvdPxX1TZMz2if7Dvx6VpV6tY5nI2ShmeESdxYJpR3vm3pPzwCh92fLe+
         LuosXIB4HaF219iK/A2cmt7F3XLt6v2QMcIk47W+A/h8A4l3HG+3Wn+t1vBQefXAmcK+
         F/vtouWK3LZ8ALQ6DvraHgLVKI4b0YacoFhMxyqyKnPTd/6M8X46D/nJFFvET1I7Efzj
         GKjrp4OeyeHIL85j/8cZHQMXu0EjJzZy13Vr+x3807Qb/6bp+rTHWWKKog5UhLYvTz+h
         mbdA==
X-Forwarded-Encrypted: i=1; AJvYcCWvpFwIWh/RST5BE488gIXoB9epuuSV4BlCz8EEEXIcoxVGe0IWwQFn4SuArnyH4ft0Ulk4xp79jbqnvUe8LA2+03KYADRd
X-Gm-Message-State: AOJu0Yxd3583QE0UpxLR5PlPL4+fdmpFmm34/5OC03mypr6uHVzdJgoC
	841QMVk4R/ICWuEtkBWTV1UQPhdDnJY7XaTYZjRs2KjuuDhNu/ucRhjl20qMAqLekumVfdazMS6
	Ulr+jaAOkGg==
X-Google-Smtp-Source: AGHT+IHuZ+cGSAfo5UbiyCXCmX5lx9/UGynmyEuSN81yBH4E8SXDV9tAecXhS2EWPac9/g2KZv1J6mjRjtTShw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:24e:b0:607:9e9a:cba6 with SMTP
 id ba14-20020a05690c024e00b006079e9acba6mr558060ywb.8.1708041257497; Thu, 15
 Feb 2024 15:54:17 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:57 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-7-amoorthy@google.com>
Subject: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an exit
 on missing hva mappings
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Allowing KVM to fault in pages during vcpu-context guest memory accesses
can be undesirable: during userfaultfd-based postcopy, it can cause
significant performance issues due to vCPUs contending for
userfaultfd-internal locks.

Add a new memslot flag (KVM_MEM_EXIT_ON_MISSING) through which userspace
can indicate that KVM_RUN should exit instead of faulting in pages
during vcpu-context guest memory accesses. The unfaulted pages are
reported by the accompanying KVM_EXIT_MEMORY_FAULT_INFO, allowing
userspace to determine and take appropriate action.

The basic implementation strategy is to check the memslot flag from
within __gfn_to_pfn_memslot() and override the caller-provided arguments
accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
out of this behavior, and do so by passing can_exit_on_missing=false.

No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING or
passes can_exit_on_missing=true to __gfn_to_pfn_memslot().

Suggested-by: James Houghton <jthoughton@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst         | 23 +++++++++++++++++-
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 |  4 ++--
 include/linux/kvm_host.h               | 12 +++++++++-
 include/uapi/linux/kvm.h               |  2 ++
 virt/kvm/Kconfig                       |  3 +++
 virt/kvm/kvm_main.c                    | 32 ++++++++++++++++++++++----
 9 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f5d45c49e36..bf7bc21d56ac 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
   #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
+  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1383,7 +1384,7 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports three flags
+The flags field supports four flags
 
 1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
@@ -1393,6 +1394,7 @@ to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
 3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
 incompatible with KVM_SET_USER_MEMORY_REGION.
+4.  KVM_MEM_EXIT_ON_MISSING: see KVM_CAP_EXIT_ON_MISSING for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -1408,6 +1410,9 @@ Instead, an abort (data abort if the cause of the page-table update
 was a load or a store, instruction abort if it was an instruction
 fetch) is injected in the guest.
 
+Note: KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING are currently mutually
+exclusive.
+
 4.36 KVM_SET_TSS_ADDR
 ---------------------
 
@@ -8044,6 +8049,22 @@ error/annotated fault.
 
 See KVM_EXIT_MEMORY_FAULT for more information.
 
+7.35 KVM_CAP_EXIT_ON_MISSING
+----------------------------
+
+:Architectures: None
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that userspace may set the
+KVM_MEM_EXIT_ON_MISSING flag on memslots. Said flag will cause KVM_RUN to fail
+(-EFAULT) in response to guest-context memory accesses which would require KVM
+to page fault on the userspace mapping.
+
+The range of guest physical memory causing the fault is advertised to userspace
+through KVM_CAP_MEMORY_FAULT_INFO. Userspace should take appropriate action.
+This could mean, for instance, checking that the fault is resolvable, faulting
+in the relevant userspace mapping, then retrying KVM_RUN.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d14504821b79..dfe0cbb5937c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1487,7 +1487,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+				   write_fault, &writable, false, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 2b1f0cdd8c18..31ebfe4fe8e1 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -614,7 +614,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, &write_ok, NULL);
+					   writing, &write_ok, false, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 4a1abb9f7c05..03b0f1c4a0d8 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -853,7 +853,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, upgrade_p, NULL);
+					   writing, upgrade_p, false, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d6cdeab1f8a..b89a9518f6de 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4371,7 +4371,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  false, &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4393,7 +4393,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  false, &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32cbe5c3a9d1..210e07c4c2eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1216,7 +1216,8 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva);
+			       bool write_fault, bool *writable,
+			       bool can_exit_on_missing, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
@@ -2394,4 +2395,13 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+/*
+ * Whether vCPUs should exit upon trying to access memory for which the
+ * userspace mappings are missing.
+ */
+static inline bool kvm_is_slot_exit_on_missing(const struct kvm_memory_slot *slot)
+{
+	return slot && slot->flags & KVM_MEM_EXIT_ON_MISSING;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 36a51b162a71..e9f33ae93dee 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_EXIT_ON_MISSING	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -920,6 +921,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_EXIT_ON_MISSING 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 29b73eedfe74..c7bdde127af4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,3 +109,6 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_KVM_EXIT_ON_MISSING
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ca580a18c5..469b99898be8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1600,7 +1600,7 @@ static void kvm_replace_memslot(struct kvm *kvm,
  * only allows these.
  */
 #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
-	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
+	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY | KVM_MEM_EXIT_ON_MISSING)
 
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
@@ -1618,8 +1618,14 @@ static int check_memory_region_flags(struct kvm *kvm,
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_EXIT_ON_MISSING))
+		valid_flags |= KVM_MEM_EXIT_ON_MISSING;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
+	else if ((mem->flags & KVM_MEM_READONLY) &&
+		 (mem->flags & KVM_MEM_EXIT_ON_MISSING))
+		return -EINVAL;
 
 	return 0;
 }
@@ -3024,7 +3030,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva)
+			       bool write_fault, bool *writable,
+			       bool can_exit_on_missing, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -3047,6 +3054,19 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
+	/* When the slot is exit-on-missing (and when we should respect that)
+	 * set atomic=true to prevent GUP from faulting in the userspace
+	 * mappings.
+	 */
+	if (!atomic && can_exit_on_missing &&
+	    kvm_is_slot_exit_on_missing(slot)) {
+		atomic = true;
+		if (async) {
+			*async = false;
+			async = NULL;
+		}
+	}
+
 	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
 			  writable);
 }
@@ -3056,21 +3076,21 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+				    NULL, write_fault, writable, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+				    NULL, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
+				    NULL, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
@@ -4877,6 +4897,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
+	case KVM_CAP_EXIT_ON_MISSING:
+		return IS_ENABLED(CONFIG_HAVE_KVM_EXIT_ON_MISSING);
 	default:
 		break;
 	}
-- 
2.44.0.rc0.258.g7320e95886-goog

