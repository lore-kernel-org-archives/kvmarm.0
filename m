Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B92EC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:18:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04CC923976
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04CC923976
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F6B4B23A;
	Fri, 15 Jan 2021 12:18:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XJC9djdx2FZh; Fri, 15 Jan 2021 12:18:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31AD24B171;
	Fri, 15 Jan 2021 12:18:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3765E4B171
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l79OC4tlWXAz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:18:54 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 743C24B239
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:53 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id v7so4400296wra.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=wpyFyG+eiUEEzv+tQsWiZF8Zwyi/AUhtPNl+Hm4opV0=;
 b=AVX8GMiwg8WGPq/0z1Xu/+8sHMtoa1UmPJmR+MWeyXW+plQYVosR0fyg4o8wlpDgOw
 QjPzW0UWKvmgwasdpRbk9MikLFU76zKwTU+tTKgoJ7Ymnmac+PR50ruUreezWPWjV8vr
 05lE4k6H+IWKBmPiKPw6iKstlOBMhz1mUhoZA33ZSvM8bfkZ2uRsLQ8K8LcSDbO+fS3I
 6KAvW57ucA/LGTJc06YuwJ0JUvit0/g+YgIY0nYq8/AHye9zXf+7pLH/rZWORZoZH5db
 Efrx87of5p43yR8RKLCseZeqG5E1HhSIkWUnGMOoEDjDsktoOydT4bvFNaaw8Thjs4EL
 SOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wpyFyG+eiUEEzv+tQsWiZF8Zwyi/AUhtPNl+Hm4opV0=;
 b=R55jW0nWlFiOP/MpO7SQtc/hHPTHX6sLBksH8xJYWQANdQOFUvWTamI2PNBcuuw5vC
 907WPiKzUEAy9VdsdYSiQd9XKiJd6YAUHGzVgItMLpBYBrCArZe6mgDcOjVHE7Hz5HxC
 ymsDT4QIPW3uul7vap0ApPPyeM2W+ylw0s2NI1rW7pS5k/mNuJp3YR5i3KrAhNGdoDIn
 tnQw6F+tWlO4irh8SHNnVKjL4XG1d5RZWk1H/G0PmKg8uxRTxAu8uqEG4p5uIalc/ZVS
 QfVNpWzOtqKEPf9LxhGUVlXC76rfVrMAE6jKXnt6a3H0/NZ2+/CdOghEGIsG9zYUoacj
 0L6g==
X-Gm-Message-State: AOAM530G4FjGWJxI6NCbgScxP7HuhRlIMFjSeR0d6DkeJqEgdbloDdWe
 xzuJKxrzxN8BNYggtUFYNIjWzNqEDdfADgIXe8Rc4wn/hoB019zLeq3DALW4367JL+DaQ7Scv6R
 /f8aVM7JFJgyIpmntDYMvCN51n02IdjfTWfS4Ss/MwPh2YerpIzBTb6Jn9a2owMnNo+NBrpa/
X-Google-Smtp-Source: ABdhPJzvrzsTdtlxSx/5Xbk5Hjx8CpoAqp+Evo8nGH5OJ/3gmNHv8fDdcA1kL5ClgTjN24/CEgxK5Z4ds2LP
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a1c:1bcc:: with SMTP id
 b195mr9757461wmb.131.1610731132351; Fri, 15 Jan 2021 09:18:52 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:23 +0000
In-Reply-To: <20210115171830.3602110-1-lenaptr@google.com>
Message-Id: <20210115171830.3602110-3-lenaptr@google.com>
Mime-Version: 1.0
References: <20210115171830.3602110-1-lenaptr@google.com>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 2/9] KVM: arm64: Add a buffer that can pass UBSan data from
 hyp/nVHE to kernel
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: George Popescu <georgepope@google.com>, Elena Petrova <lenaptr@google.com>,
 Marc Zyngier <maz@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

From: George Popescu <georgepope@google.com>

Share a buffer between the kernel and the hyp/nVHE code by using the
macros from kvm_debug_buffer.h.
The hyp/nVHE code requires a write index which counts how many elements
have been writtens inside the buffer and the kernel requires a read
index which counts how many elements have been read from the buffer.
The write index and the buffer are shared with the kernel in read-only.

The kvm_debug_buffer_ind returns the reading and writing points of the
circular buffer and updates the reading index.

Data collected from UBSan handlers inside hyp/nVHE is stored in the
kvm_ubsan_buffer.
This buffer stores only UBSan data because it should not be preoccupied
by other mechanisms data structures and functionalities.

Also, for the moment the buffer is mapped inside .bss, where both the kernel
and the hyp/nVHE code have Read/Write rights, but in the future this will change
and the kernel will not be able to acess hyp/nVHE's .bss. At that point the buffer
will only need to be mapped in order for this patch to work.

Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/include/asm/assembler.h        | 11 +++++++
 arch/arm64/include/asm/kvm_debug_buffer.h | 36 ++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h         |  8 ++++-
 arch/arm64/include/asm/kvm_ubsan.h        | 14 ++++++++
 arch/arm64/kvm/Makefile                   |  2 ++
 arch/arm64/kvm/arm.c                      |  9 +++++
 arch/arm64/kvm/hyp/nvhe/host.S            |  4 +++
 arch/arm64/kvm/hyp/nvhe/ubsan.c           | 23 +++++++++++++
 arch/arm64/kvm/kvm_ubsan_buffer.c         | 40 +++++++++++++++++++++++
 9 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kvm_debug_buffer.h
 create mode 100644 arch/arm64/include/asm/kvm_ubsan.h
 create mode 100644 arch/arm64/kvm/kvm_ubsan_buffer.c

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index bf125c591116..ebc18a8a0e1f 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -258,6 +258,17 @@ alternative_endif
 	ldr	\dst, [\dst, \tmp]
 	.endm
 
+	/*
+         * @sym: The name of the per-cpu variable
+         * @reg: value to store
+         * @tmp1: scratch register
+         * @tmp2: scratch register
+         */
+        .macro str_this_cpu sym, reg, tmp1, tmp2
+        adr_this_cpu \tmp1, \sym, \tmp2
+        str \reg, [\tmp1]
+        .endm
+
 /*
  * vma_vm_mm - get mm pointer from vma pointer (vma->vm_mm)
  */
diff --git a/arch/arm64/include/asm/kvm_debug_buffer.h b/arch/arm64/include/asm/kvm_debug_buffer.h
new file mode 100644
index 000000000000..e5375c2cff1a
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_debug_buffer.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2020 Google LLC
+ * Author: George Popescu <georgepope@google.com>
+ */
+
+#include <linux/percpu-defs.h>
+
+
+#define KVM_DEBUG_BUFFER_SIZE 1000
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define DEFINE_KVM_DEBUG_BUFFER(type_name, buffer_name, write_ind, size)\
+	DEFINE_PER_CPU(type_name, buffer_name)[size];			\
+	DEFINE_PER_CPU(unsigned long, write_ind) = 0;
+
+#define DECLARE_KVM_DEBUG_BUFFER(type_name, buffer_name, write_ind, size)\
+	DECLARE_PER_CPU(type_name, buffer_name)[size];			\
+	DECLARE_PER_CPU(unsigned long, write_ind);
+#else
+#define DECLARE_KVM_DEBUG_BUFFER(type_name, buffer_name, write_ind, size)\
+	DECLARE_KVM_NVHE_PER_CPU(type_name, buffer_name)[size]; 	\
+        DECLARE_KVM_NVHE_PER_CPU(unsigned long, write_ind);
+#endif //__KVM_NVHE_HYPERVISOR__
+
+#ifdef __ASSEMBLY__
+#include <asm/assembler.h>
+
+.macro clear_buffer tmp1, tmp2, tmp3
+        mov \tmp1, 0
+#ifdef CONFIG_UBSAN
+        str_this_cpu kvm_ubsan_buff_wr_ind, \tmp1, \tmp2, \tmp3
+#endif //CONFIG_UBSAN
+.endm
+
+#endif
\ No newline at end of file
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8fcfab0c2567..905ca0d7c52c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -592,6 +592,12 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+
+#ifdef CONFIG_UBSAN
+extern void __kvm_check_ubsan_buffer(void);
+#else
+static inline void __kvm_check_ubsan_buffer(void) {}
+#endif /* CONFIG_UBSAN */
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
 		struct arm_smccc_res res;				\
@@ -599,7 +605,7 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
 				  ##__VA_ARGS__, &res);			\
 		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
-									\
+		__kvm_check_ubsan_buffer();				\
 		res.a1;							\
 	})
 
diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
new file mode 100644
index 000000000000..fb32c7fd65d4
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_ubsan.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2020 Google LLC
+ * Author: George Popescu <georgepope@google.com>
+ */
+
+#include <ubsan.h>
+
+#define UBSAN_MAX_TYPE 6
+#define KVM_UBSAN_BUFFER_SIZE 1000
+
+struct kvm_ubsan_info {
+	int type;
+};
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 13b017284bf9..ab3a9c402550 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -4,6 +4,7 @@
 #
 
 ccflags-y += -I $(srctree)/$(src)
+CFLAGS_kvm_ubsan_buffer.o += -I $(srctree)/lib/
 
 KVM=../../../virt/kvm
 
@@ -25,3 +26,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
+kvm-$(CONFIG_UBSAN) += kvm_ubsan_buffer.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04c44853b103..63f0495550b8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1784,6 +1784,15 @@ static int init_hyp_mode(void)
 			goto out_err;
 		}
 	}
+#ifdef CONFIG_UBSAN
+	/* required by ubsan to access the handlers structures fields */
+	err = create_hyp_mappings(kvm_ksym_ref(_data),
+				  kvm_ksym_ref(__end_once), PAGE_HYP_RO);
+	if (err) {
+		kvm_err("Cannot map data section\n");
+		goto out_err;
+	}
+#endif
 
 	/*
 	 * Map Hyp percpu pages
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index a820dfdc9c25..0967906265d3 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -8,6 +8,7 @@
 
 #include <asm/assembler.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_debug_buffer.h>
 #include <asm/kvm_mmu.h>
 
 	.text
@@ -34,6 +35,9 @@ SYM_FUNC_START(__host_exit)
 	/* Store the host regs x18-x29, lr */
 	save_callee_saved_regs x0
 
+	/* when entering the host clear the buffers */
+   	clear_buffer    x4, x5, x6  
+
 	/* Save the host context pointer in x29 across the function call */
 	mov	x29, x0
 	bl	handle_trap
diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
index a5db6b61ceb2..8a194fb1f6cf 100644
--- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
+++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
@@ -3,10 +3,33 @@
  * Copyright 2020 Google LLC
  * Author: George Popescu <georgepope@google.com>
  */
+#include <linux/bitops.h>
 #include <linux/ctype.h>
 #include <linux/types.h>
+#include <linux/percpu-defs.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_ubsan.h>
+#include <asm/kvm_debug_buffer.h>
+#include <kvm/arm_pmu.h>
 #include <ubsan.h>
 
+DEFINE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
+                kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
+
+static inline struct kvm_ubsan_info *kvm_ubsan_buffer_next_slot(void)
+{
+	struct kvm_ubsan_info *res = NULL;
+	unsigned long write_ind = __this_cpu_read(kvm_ubsan_buff_wr_ind);
+	if (write_ind < KVM_UBSAN_BUFFER_SIZE) {
+		res = this_cpu_ptr(&kvm_ubsan_buffer[write_ind]);
+		++write_ind;
+		__this_cpu_write(kvm_ubsan_buff_wr_ind, write_ind);
+	}
+	return res;
+}
+
 void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
 
 void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
new file mode 100644
index 000000000000..4a1959ba9f68
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2020 Google LLC
+ * Author: George Popescu <georgepope@google.com>
+ */
+
+#include <linux/ctype.h>
+#include <linux/types.h>
+#include <asm/kvm_debug_buffer.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+#include <kvm/arm_pmu.h>
+
+#include <ubsan.h>
+#include <asm/kvm_ubsan.h>
+
+DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
+		kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
+
+
+void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
+{
+	unsigned long i;
+	struct kvm_ubsan_info *slot;
+
+	slot = (struct kvm_ubsan_info *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buffer);
+	for (i = left; i < right; ++i) {
+		/* check ubsan data */
+		slot[i].type = 0;
+	}
+}
+
+void __kvm_check_ubsan_buffer(void)
+{
+	unsigned long *write_ind;
+
+	write_ind = (unsigned long *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buff_wr_ind);
+	iterate_kvm_ubsan_buffer(0, *write_ind);
+}
+
-- 
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
