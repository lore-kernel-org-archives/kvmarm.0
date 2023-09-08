Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3360CB64D
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:29:57 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d80256afb63so2240859276.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212197; x=1694816997; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mp0XJC4R62BtJjjX6cjHP8swHT4GNhM1P2WJh4sej8=;
        b=ECua4zZE3S7yNQK8Acl4CUPzOJ/e8McSspDnrH+Eq/W49RpFF2v9prdaa8XKhtrKRw
         s0tQJUY4XBqVhRW1Wd8Lvr7L26FRBhnsermcCzk486RNNMloMTuzPAk6wO4g1JmOtqz/
         P/qv9UfPma84ljJ9Kh+8FVT2vhw2kSjm1v8DgT/1pfRbdpNbKW3hdCXRAlpn0sfeFrLC
         jqEoCSHJ+icVji5N3W01nxEZ5vuFHgCgI2/Hk5eOhmVVziGi6tusFIsRQiItHsnjOfdc
         5vSyLWPw6fz6vvKJx0ebrOGaO1Vakayukn/u7n/eGVJSFY6csoetbTAHwN5Ox7LlCHyK
         cQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212197; x=1694816997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mp0XJC4R62BtJjjX6cjHP8swHT4GNhM1P2WJh4sej8=;
        b=qVqUt7EhjcB9Gb/2WSj8WmxFrSY7519UlGo/DNfDIfDSYf2UL/Kq4wSGJVaZ79r7fW
         tZvso0ozooj2tOsRR1Bay0SV4jBQA8ZWV5vjrv+tGICyPEHyISnna0D2NEJ6nfuHvtJm
         W03A6RAco+C5MQrntOMzIZiu9u9y/Uziq3MOOk+eLPhq5018iJlJWO31AGN2RePx5qev
         sUpTbV6vUwxiXbiQXf3hVMU6xsYRXG92hhCJWxFntD4Qy66i0FSYHF8g12njE7WPR7oO
         YDy6H1Slbg3KQOLOAwN8yCvodB79EPDpZfCOuLuaee4duppZBZPI+ofMVJXI6ZSfMZp/
         JOMQ==
X-Gm-Message-State: AOJu0Yw88x9TxSmurxTfoXYJQXa6x9Qbbnb3kWT4wQMpokNd+9XHOkyP
	z3A96FHMZkmvhXvICFHYqhM+ysLlXpqadQ==
X-Google-Smtp-Source: AGHT+IFC72Q+0iEWcEgGkc+m7VbWdSgk0sXS3HD6u9epEqsTQfW84aC06nmxfOKJ/0XL5ODQBpPtQAmA6G8Tmg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1024:b0:d7e:c4af:22d2 with SMTP
 id x4-20020a056902102400b00d7ec4af22d2mr225355ybt.4.1694212197218; Fri, 08
 Sep 2023 15:29:57 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:56 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-10-amoorthy@google.com>
Subject: [PATCH v5 09/17] KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING without implementation
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Add documentation, memslot flags, useful helper functions, and the
definition of the capability. Implementation is provided in a subsequent
commit.

Memory fault exits on absent mappings are particularly useful for
userfaultfd-based postcopy live migration, where contention within uffd
can lead to slowness When many vCPUs fault on a single uffd/vma.
Bypassing the uffd entirely by returning information directly to the
vCPU via an exit avoids contention and can greatly improves the fault
rate.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 28 +++++++++++++++++++++++++---
 include/linux/kvm_host.h       |  9 +++++++++
 include/uapi/linux/kvm.h       |  2 ++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  3 +++
 virt/kvm/kvm_main.c            |  5 +++++
 6 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 92fd3faa6bab..c2eaacb6dc63 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
   /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_USERFAULT_ON_MISSING  (1UL << 2)
 
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
+3.  KVM_MEM_USERFAULT_ON_MISSING: see KVM_CAP_USERFAULT_ON_MISSING for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -7781,6 +7785,24 @@ Note: Userspaces which attempt to resolve memory faults so that they can retry
 KVM_RUN are encouraged to guard against repeatedly receiving the same
 error/annotated fault.
 
+7.35 KVM_CAP_USERFAULT_ON_MISSING
+---------------------------------
+
+:Architectures: None
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that userspace may set the
+KVM_MEM_USERFAULT_ON_MISSING on memslots (via KVM_SET_USER_MEMORY_REGION). Said
+flag will cause KVM_RUN to fail (-EFAULT) in response to guest-context memory
+accesses which would require KVM to page fault on the userspace mapping.
+
+The range of guest physical memory causing the fault is advertised to userspace
+through KVM_CAP_MEMORY_FAULT_INFO. Userspace should determine how best to make
+the mapping present, take appropriate action, then return to KVM_RUN to retry
+the access.
+
+Attempts to enable this capability directly will fail.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9206ac944d31..db5c3eae58fe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2353,4 +2353,13 @@ static inline void kvm_handle_guest_uaccess_fault(struct kvm_vcpu *vcpu,
 	vcpu->run->memory_fault.flags = flags;
 }
 
+/*
+ * Whether non-atomic accesses to the userspace mapping of the memslot should
+ * be upgraded when possible.
+ */
+static inline bool kvm_is_slot_userfault_on_missing(const struct kvm_memory_slot *slot)
+{
+	return slot && slot->flags & KVM_MEM_USERFAULT_ON_MISSING;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b2e4ac83b5a8..a21921e4ee2a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_USERFAULT_ON_MISSING	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1220,6 +1221,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 #define KVM_CAP_MEMORY_FAULT_INFO 230
+#define KVM_CAP_USERFAULT_ON_MISSING 231
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index d19aa7965392..188be8549070 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_USERFAULT_ON_MISSING (1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 484d0873061c..906878438687 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -92,3 +92,6 @@ config HAVE_KVM_PM_NOTIFIER
 
 config KVM_GENERIC_HARDWARE_ENABLING
        bool
+
+config HAVE_KVM_USERFAULT_ON_MISSING
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a7e6320dd7f0..aa81e41b1488 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1553,6 +1553,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT_ON_MISSING))
+		valid_flags |= KVM_MEM_USERFAULT_ON_MISSING;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -4588,6 +4591,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 		return 1;
+	case KVM_CAP_USERFAULT_ON_MISSING:
+		return IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT_ON_MISSING);
 	default:
 		break;
 	}
-- 
2.42.0.283.g2d96d420d3-goog

