Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A33DC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C552206FA
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C552206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8B014B1B9;
	Fri,  5 Jun 2020 17:39:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sMAX-n7nGkPk; Fri,  5 Jun 2020 17:39:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61CE24B1E7;
	Fri,  5 Jun 2020 17:39:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2368F4B1D2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SKIEDPpPvV9I for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 17:39:20 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86DCE4B154
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:15 -0400 (EDT)
IronPort-SDR: kDrbk7lGD5fQv55ITGA1MN6FpXFbzw9Ql21nBy4Cu0dt+KzRXfC78tHG7WlKal5e9avBDuiCP2
 bC7rTGBYLJGw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jun 2020 14:39:09 -0700
IronPort-SDR: i7adhaepK8ME1pSI2ECuoi5eKdTlo5J8cLg95rKXIMokAOoUD9wAcpYWu91uttwijh6UkSD6/I
 AU8/iwhnP7Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; d="scan'208";a="287860908"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:08 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 14/21] KVM: Move x86's version of struct kvm_mmu_memory_cache
 to common code
Date: Fri,  5 Jun 2020 14:38:46 -0700
Message-Id: <20200605213853.14959-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Ben Gardon <bgardon@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Joerg Roedel <joro@8bytes.org>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>
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

Move x86's 'struct kvm_mmu_memory_cache' to common code in anticipation
of moving the entire x86 implementation code to common KVM and reusing
it for arm64 and MIPS.  Add a new architecture specific asm/kvm_types.h
to control the existence and parameters of the struct.  The new header
is needed to avoid a chicken-and-egg problem with asm/kvm_host.h as all
architectures define instances of the struct in their vCPU structs.

Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm64/include/asm/kvm_types.h   |  6 ++++++
 arch/mips/include/asm/kvm_types.h    |  5 +++++
 arch/powerpc/include/asm/kvm_types.h |  5 +++++
 arch/s390/include/asm/kvm_types.h    |  5 +++++
 arch/x86/include/asm/kvm_host.h      | 13 -------------
 arch/x86/include/asm/kvm_types.h     |  7 +++++++
 include/linux/kvm_types.h            | 19 +++++++++++++++++++
 7 files changed, 47 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_types.h
 create mode 100644 arch/mips/include/asm/kvm_types.h
 create mode 100644 arch/powerpc/include/asm/kvm_types.h
 create mode 100644 arch/s390/include/asm/kvm_types.h
 create mode 100644 arch/x86/include/asm/kvm_types.h

diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
new file mode 100644
index 000000000000..d0987007d581
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_KVM_TYPES_H
+#define _ASM_ARM64_KVM_TYPES_H
+
+#endif /* _ASM_ARM64_KVM_TYPES_H */
+
diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
new file mode 100644
index 000000000000..5efeb32a5926
--- /dev/null
+++ b/arch/mips/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_MIPS_KVM_TYPES_H
+#define _ASM_MIPS_KVM_TYPES_H
+
+#endif /* _ASM_MIPS_KVM_TYPES_H */
diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
new file mode 100644
index 000000000000..f627eceaa314
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_KVM_TYPES_H
+#define _ASM_POWERPC_KVM_TYPES_H
+
+#endif /* _ASM_POWERPC_KVM_TYPES_H */
diff --git a/arch/s390/include/asm/kvm_types.h b/arch/s390/include/asm/kvm_types.h
new file mode 100644
index 000000000000..b66a81f8a354
--- /dev/null
+++ b/arch/s390/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_S390_KVM_TYPES_H
+#define _ASM_S390_KVM_TYPES_H
+
+#endif /* _ASM_S390_KVM_TYPES_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb99e6776e27..8e8fea13b6c7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -193,8 +193,6 @@ struct x86_exception;
 enum x86_intercept;
 enum x86_intercept_stage;
 
-#define KVM_NR_MEM_OBJS 40
-
 #define KVM_NR_DB_REGS	4
 
 #define DR6_BD		(1 << 13)
@@ -245,17 +243,6 @@ enum x86_intercept_stage;
 
 struct kvm_kernel_irq_routing_entry;
 
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
-struct kvm_mmu_memory_cache {
-	int nobjs;
-	gfp_t gfp_zero;
-	struct kmem_cache *kmem_cache;
-	void *objects[KVM_NR_MEM_OBJS];
-};
-
 /*
  * the pages used as guest page table on soft mmu are tracked by
  * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
new file mode 100644
index 000000000000..08f1b57d3b62
--- /dev/null
+++ b/arch/x86/include/asm/kvm_types.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_KVM_TYPES_H
+#define _ASM_X86_KVM_TYPES_H
+
+#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
+
+#endif /* _ASM_X86_KVM_TYPES_H */
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 68e84cf42a3f..a7580f69dda0 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -20,6 +20,8 @@ enum kvm_mr_change;
 
 #include <linux/types.h>
 
+#include <asm/kvm_types.h>
+
 /*
  * Address types:
  *
@@ -58,4 +60,21 @@ struct gfn_to_pfn_cache {
 	bool dirty;
 };
 
+#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
+/*
+ * Memory caches are used to preallocate memory ahead of various MMU flows,
+ * e.g. page fault handlers.  Gracefully handling allocation failures deep in
+ * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
+ * holding MMU locks.  Note, these caches act more like prefetch buffers than
+ * classical caches, i.e. objects are not returned to the cache on being freed.
+ */
+struct kvm_mmu_memory_cache {
+	int nobjs;
+	gfp_t gfp_zero;
+	struct kmem_cache *kmem_cache;
+	void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
+};
+#endif
+
+
 #endif /* __KVM_TYPES_H__ */
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
