Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560B4C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3B9A22453
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="NIFkj+RZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3B9A22453
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95CC54B51C;
	Wed, 16 Sep 2020 13:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L5cw-9klJdyx; Wed, 16 Sep 2020 13:35:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 368004B4F2;
	Wed, 16 Sep 2020 13:35:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4E844B494
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:35:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V5xebO6cnq4q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:35:06 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62CD24B513
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:35:06 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id e16so7805602wrm.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Q9UVQQ6DTZHcZFVRtOaPO3UPD1d1Bnoz5yW15JNPfiI=;
 b=NIFkj+RZcBLfM9uT1KnlW/OhjhMvYayd0/LMbIbIjjbzTiq3iRjUJZDL65n21p4Pvb
 gmXNhHqPQ+M971nXvZ6jXGdzwFYXNz7M+G2mgbNYqvyhhDqq72Gj8i3nbHkUQ20Qesfx
 NbC9V/DmTgepxr0SC62j5IN6XHQoNR1C1ww7GnkuwRPPid9feWdOWJmPnhD3wi4hd7rT
 RBlCtU8A32m6x3kyS9OkzWCpqeMyWB+vGXZ0Qyc6Gx7NYXQpjaGdcLI2lYKAs0D8Bq6Y
 mqMSaLEYxfWh5BJLQYS7Cv/LkEpqaUCoWZ2hQJskzYleDUAZ+q6UUan4U0WLvKjGf1ND
 qj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Q9UVQQ6DTZHcZFVRtOaPO3UPD1d1Bnoz5yW15JNPfiI=;
 b=asv6WzBdqDrZABpflZEaxZ378IOphQrgRIjCul4cCRMX0rKDgYAC3IfGdJ1hsnJwVr
 EjECXTnmtcCDOE2ep/c2mUR6izzBU6toz7z8xp1MlBCJAC+dWkfJhJ15bJvkzYHtt1sq
 Ccy/hUz/9DbT+9VarAdCF+CH9jN5tY1vQxb8qgQm2Y//D8Kef+nCRLAz7oAsl7JH7BWJ
 3O1znw9gXEipwq4Oot5oORzNuOTr3nXHqsYY3hu0/HRrR/dV3mYyE82EEI/Ko+TmuQmL
 ftz0acFZFv3kHCyBKHr8cZr2y1q/mrPneHk5pDEq7SWfbIA+0E3fS94i0ZClU1CQ/my2
 hJKA==
X-Gm-Message-State: AOAM531BMzW47sY1Zsc4heC624Tce6aA4CbRy2/zoF+/f9i2rHACstcF
 7f1WcH0sOOac77SrP5lsxrbyuD4lb5Y24Z6l
X-Google-Smtp-Source: ABdhPJwG1ZOQDzJ0OTA1ogwbtAlSeqzm/T0AT+4qFHXsUmYbr+tGahu6Qso1FQ/U45prv0lKr8VFHA==
X-Received: by 2002:a5d:6407:: with SMTP id z7mr27645027wru.65.1600277704925; 
 Wed, 16 Sep 2020 10:35:04 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id 8sm35215401wrl.7.2020.09.16.10.35.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:35:03 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 10/11] kvm: arm64: Set up hyp percpu data for nVHE
Date: Wed, 16 Sep 2020 18:34:38 +0100
Message-Id: <20200916173439.32265-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916173439.32265-1-dbrazdil@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Add hyp percpu section to linker script and rename the corresponding ELF
sections of hyp/nvhe object files. This moves all nVHE-specific percpu
variables to the new hyp percpu section.

Allocate sufficient amount of memory for all percpu hyp regions at global KVM
init time and create corresponding hyp mappings.

The base addresses of hyp percpu regions are kept in a dynamically allocated
array in the kernel.

Add NULL checks in PMU event-reset code as it may run before KVM memory is
initialized.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 19 +++++++++--
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   |  9 +++++
 arch/arm64/kvm/arm.c              | 56 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  6 ++++
 arch/arm64/kvm/pmu.c              |  5 ++-
 6 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index abc03f386b40..e0e1e404f6eb 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -66,8 +66,23 @@
 #define CHOOSE_VHE_SYM(sym)	sym
 #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
 
-#define this_cpu_ptr_nvhe(sym)		this_cpu_ptr(&kvm_nvhe_sym(sym))
-#define per_cpu_ptr_nvhe(sym, cpu)	per_cpu_ptr(&kvm_nvhe_sym(sym), cpu)
+/* Array of percpu base addresses. Length of the array is nr_cpu_ids. */
+extern unsigned long *kvm_arm_hyp_percpu_base;
+
+/*
+ * Compute pointer to a symbol defined in nVHE percpu region.
+ * Returns NULL if percpu memory has not been allocated yet.
+ */
+#define this_cpu_ptr_nvhe(sym)	per_cpu_ptr_nvhe(sym, smp_processor_id())
+#define per_cpu_ptr_nvhe(sym, cpu)					\
+	({								\
+		unsigned long base, off;				\
+		base = kvm_arm_hyp_percpu_base				\
+			? kvm_arm_hyp_percpu_base[cpu] : 0;		\
+		off = (unsigned long)&kvm_nvhe_sym(sym) -		\
+		      (unsigned long)&kvm_nvhe_sym(__per_cpu_start);	\
+		base ? (typeof(kvm_nvhe_sym(sym))*)(base + off) : NULL;	\
+	})
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 /*
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 3994169985ef..5062553a6847 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -18,5 +18,6 @@ extern char __exittext_begin[], __exittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
+extern char __kvm_nvhe___per_cpu_start[], __kvm_nvhe___per_cpu_end[];
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 0d543570e811..d52e6b5dbfd3 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -9,6 +9,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
+#include <asm/hyp_image.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
 #include <asm/page.h>
@@ -27,8 +28,15 @@ jiffies = jiffies_64;
 	__start___kvm_ex_table = .;				\
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
+
+#define HYPERVISOR_PERCPU_SECTION				\
+	. = ALIGN(PAGE_SIZE);					\
+	HYP_SECTION_NAME(.data..percpu) : {			\
+		*(HYP_SECTION_NAME(.data..percpu))		\
+	}
 #else /* CONFIG_KVM */
 #define HYPERVISOR_EXTABLE
+#define HYPERVISOR_PERCPU_SECTION
 #endif
 
 #define HYPERVISOR_TEXT					\
@@ -194,6 +202,7 @@ SECTIONS
 	}
 
 	PERCPU_SECTION(L1_CACHE_BYTES)
+	HYPERVISOR_PERCPU_SECTION
 
 	.rela.dyn : ALIGN(8) {
 		*(.rela .rela*)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 58d7d614519b..8293319a32e7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+unsigned long *kvm_arm_hyp_percpu_base;
 
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
@@ -1258,6 +1259,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 }
 
+#define kvm_hyp_percpu_base(cpu)	((unsigned long)per_cpu_ptr_nvhe(__per_cpu_start, cpu))
+#define kvm_hyp_percpu_array_size	(nr_cpu_ids * sizeof(*kvm_arm_hyp_percpu_base))
+#define kvm_hyp_percpu_array_order	(get_order(kvm_hyp_percpu_array_size))
+#define kvm_hyp_percpu_start		(CHOOSE_NVHE_SYM(__per_cpu_start))
+#define kvm_hyp_percpu_end		(CHOOSE_NVHE_SYM(__per_cpu_end))
+#define kvm_hyp_percpu_size		((unsigned long)kvm_hyp_percpu_end - \
+					 (unsigned long)kvm_hyp_percpu_start)
+#define kvm_hyp_percpu_order		(kvm_hyp_percpu_size ? get_order(kvm_hyp_percpu_size) : 0)
+
 static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
@@ -1273,8 +1283,8 @@ static void cpu_init_hyp_mode(void)
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	tpidr_el2 = ((unsigned long)this_cpu_ptr(&kvm_host_data) -
-		     (unsigned long)kvm_ksym_ref(&kvm_host_data));
+	tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe(__per_cpu_start) -
+		    (unsigned long)kvm_ksym_ref(kvm_hyp_percpu_start);
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
@@ -1506,8 +1516,11 @@ static void teardown_hyp_mode(void)
 	int cpu;
 
 	free_hyp_pgds();
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		free_hyp_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+		free_hyp_pages(kvm_hyp_percpu_base(cpu), kvm_hyp_percpu_order);
+	}
+	free_hyp_pages((unsigned long)kvm_arm_hyp_percpu_base, kvm_hyp_percpu_array_order);
 }
 
 /**
@@ -1540,6 +1553,28 @@ static int init_hyp_mode(void)
 		per_cpu(kvm_arm_hyp_stack_page, cpu) = stack_page;
 	}
 
+	/*
+	 * Allocate and initialize pages for Hypervisor-mode percpu regions.
+	 */
+	kvm_arm_hyp_percpu_base = (unsigned long *)alloc_hyp_pages(
+			GFP_KERNEL | __GFP_ZERO, kvm_hyp_percpu_array_order);
+	if (!kvm_arm_hyp_percpu_base) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+	for_each_possible_cpu(cpu) {
+		unsigned long percpu_base;
+
+		percpu_base = alloc_hyp_pages(GFP_KERNEL, kvm_hyp_percpu_order);
+		if (!percpu_base) {
+			err = -ENOMEM;
+			goto out_err;
+		}
+
+		memcpy((void *)percpu_base, kvm_hyp_percpu_start, kvm_hyp_percpu_size);
+		kvm_arm_hyp_percpu_base[cpu] = percpu_base;
+	}
+
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
@@ -1584,6 +1619,21 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	/*
+	 * Map Hyp percpu pages
+	 */
+	for_each_possible_cpu(cpu) {
+		char *percpu_begin = (char *)kvm_arm_hyp_percpu_base[cpu];
+		char *percpu_end = percpu_begin + PAGE_ALIGN(kvm_hyp_percpu_size);
+
+		err = create_hyp_mappings(percpu_begin, percpu_end, PAGE_HYP);
+
+		if (err) {
+			kvm_err("Cannot map hyp percpu region\n");
+			goto out_err;
+		}
+	}
+
 	for_each_possible_cpu(cpu) {
 		kvm_host_data_t *cpu_data;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index 3b13d1c7cd1a..bb2d986ff696 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -7,7 +7,13 @@
  */
 
 #include <asm/hyp_image.h>
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/cache.h>
+#include <asm/memory.h>
 
 SECTIONS {
 	HYP_SECTION(.text)
+	HYP_SECTION_NAME(.data..percpu) : {
+		PERCPU_INPUT(L1_CACHE_BYTES)
+	}
 }
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 6d80ffe1ebfc..cd653091f213 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -33,7 +33,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
 	struct kvm_host_data *ctx = this_cpu_ptr_hyp(kvm_host_data);
 
-	if (!kvm_pmu_switch_needed(attr))
+	if (!ctx || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -49,6 +49,9 @@ void kvm_clr_pmu_events(u32 clr)
 {
 	struct kvm_host_data *ctx = this_cpu_ptr_hyp(kvm_host_data);
 
+	if (!ctx)
+		return;
+
 	ctx->pmu_events.events_host &= ~clr;
 	ctx->pmu_events.events_guest &= ~clr;
 }
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
