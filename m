Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F37A93A
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 21:35:30 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id u188-20020a2560c5000000b00b8f15f2111dso8231224ybb.4
        for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 14:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335330; x=1683927330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IWH4ZRYVMjQ/mFRBZ49V9jlN8+sDpTIhwIJQUsNqRO4=;
        b=a0WlNccitJbMxtr99iHu5o5qhkB8GZPfinmSqjqpd26vcPKVaA0f8FWlEXKgCaCozq
         lZcKVgjiloiKSP+94bh2Asa7Rzt96bF9dgcd7xvBR9IN2QY3eGcsL5+7G0vaHw7y+FCU
         YgnCKxCxaH1bVVo0XNIEPCMbmMyjUJbRPv+T/soClb8P7YAtwnOZugsxGgf8KiCyzHuL
         h/ds/bxsBNMyYc7iboS3PftQei5tre/9z7VYV0idgPUC9U9r2QqY5lg+8y0PAlsDn/wn
         KFRtSyB7hPb4UnfDKhIcEXaAML6W3xbjI47GD83yBNOdQOBq53dlKy9GgKj/qJPSYue4
         vLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335330; x=1683927330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IWH4ZRYVMjQ/mFRBZ49V9jlN8+sDpTIhwIJQUsNqRO4=;
        b=KueVZ71Nx0TjricpWXhQUuhHHg/hrQGlp3OnSGj6lkKZ/fOWu7czW0+fMxb801RlcR
         MoffOo6sBp6AyRS9/d6JajRGdQ7InQKf5YdF8HZZmQy8e0Wdcs9Tg7GqzKf7NAKa0wmF
         UDW/KetGf9E89gmaqni7n4jdOhvnUNzq9aFm9bRtXwMg8Cp9emnG4h9EkVHrhTLCcSkv
         6Lp4iRGDC4mTYEp5rj/FEkSCazFYxs7f+JfW0Ea9rZwMPtOHK1ETC5+SoHJX9D2pHp3E
         DfWVICO+YnqNlqDPDSsd9zDI+tBmDOmgcZgffVtLjw9YQHuasVvlaIgDpE/AIsquT305
         He0A==
X-Gm-Message-State: AAQBX9esW9VZv9UjgEjHCdm2eipEmdGnQ0rFYCjomA5WMcXMRNUrw7jx
	+mPm5x8lmzZ/WLhesyeMLBWwgUQC10ZKyQ==
X-Google-Smtp-Source: AKy350ar/HxRwT7YIUsCVGv0rPiDiH7lT+T3hSEZTIraxERXKIZKg70zugZhlLgV06/iho9mUA0D+Oe1xt+ZXA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:cc07:0:b0:b8b:fe5f:2eaa with SMTP id
 l7-20020a25cc07000000b00b8bfe5f2eaamr15871ybf.2.1681335330526; Wed, 12 Apr
 2023 14:35:30 -0700 (PDT)
Date: Wed, 12 Apr 2023 21:35:05 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-18-amoorthy@google.com>
Subject: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT without implementation
From: Anish Moorthy <amoorthy@google.com>
To: pbonzini@redhat.com, maz@kernel.org
Cc: oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com, 
	amoorthy@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add documentation, memslot flags, useful helper functions, and the
actual new capability itself.

Memory fault exits on absent mappings are particularly useful for
userfaultfd-based postcopy live migration. When many vCPUs fault on a
single userfaultfd the faults can take a while to surface to userspace
due to having to contend for uffd wait queue locks. Bypassing the uffd
entirely by returning information directly to the vCPU exit avoids this
contention and improves the fault rate.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 31 ++++++++++++++++++++++++++++---
 include/linux/kvm_host.h       |  7 +++++++
 include/uapi/linux/kvm.h       |  2 ++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/kvm_main.c            |  3 +++
 5 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f174f43c38d45..7967b9909e28b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
   /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1342,12 +1343,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
+The flags field supports three flags
+
+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
+use it.
+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
+3.  KVM_MEM_ABSENT_MAPPING_FAULT: see KVM_CAP_ABSENT_MAPPING_FAULT for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -7705,6 +7709,27 @@ userspace may receive "bare" EFAULTs (i.e. exit reason !=
 KVM_EXIT_MEMORY_FAULT) from KVM_RUN. These should be considered bugs and
 reported to the maintainers.
 
+7.35 KVM_CAP_ABSENT_MAPPING_FAULT
+---------------------------------
+
+:Architectures: None
+:Returns: -EINVAL.
+
+The presence of this capability indicates that userspace may pass the
+KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
+to fail (-EFAULT) in response to page faults for which the userspace page tables
+do not contain present mappings. Attempting to enable the capability directly
+will fail.
+
+The range of guest physical memory causing the fault is advertised to userspace
+through KVM_CAP_MEMORY_FAULT_INFO (if it is enabled).
+
+Userspace should determine how best to make the mapping present, then take
+appropriate action. For instance, in the case of absent mappings this might
+involve establishing the mapping for the first time via UFFDIO_COPY/CONTINUE or
+faulting the mapping in using MADV_POPULATE_READ/WRITE. After establishing the
+mapping, userspace can return to KVM to retry the previous memory access.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 776f9713f3921..2407fc1e52ab8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2289,4 +2289,11 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
  */
 inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
 					uint64_t gpa, uint64_t len);
+
+static inline bool kvm_slot_fault_on_absent_mapping(
+							const struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_ABSENT_MAPPING_FAULT;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bc73e8381a2bb..21df449e74648 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_ABSENT_MAPPING_FAULT	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1196,6 +1197,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_MEMORY_FAULT_INFO 227
+#define KVM_CAP_ABSENT_MAPPING_FAULT 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 5c57796364d65..59219da95634c 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f3be5aa49829a..7cd0ad94726df 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1525,6 +1525,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (kvm_vm_ioctl_check_extension(NULL, KVM_CAP_ABSENT_MAPPING_FAULT))
+		valid_flags |= KVM_MEM_ABSENT_MAPPING_FAULT;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.40.0.577.gac1e443424-goog

