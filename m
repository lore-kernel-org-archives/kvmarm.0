Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650FBC4727E
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E63C62371F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="azQ6vvRE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E63C62371F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 930B04B20F;
	Tue, 22 Sep 2020 16:49:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hvc5DWwMpffg; Tue, 22 Sep 2020 16:49:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B59164B31A;
	Tue, 22 Sep 2020 16:49:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 535564A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T2-NeMCpsoEZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:29 -0400 (EDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E03F64B2EA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:28 -0400 (EDT)
Received: by mail-wr1-f49.google.com with SMTP id c18so18567893wrm.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=f1GdIOWvJZ8YlHGGMuhVEFDO/Kt84MDgjn8Ofz2/F8Y=;
 b=azQ6vvREaJe8Do0qZN6GQzBVklyNx5Fr7I0RCit7+LNk9Nu6hIJ5iajNxgnG6vC3Lf
 XIStyls3mFQ8JYHAUPb7MK5pGzQPzPgOMnmOyGBphdffl/MfRYNKvvvCC0JJoVIt9CWq
 ghrAUDM7lWkEqH3SzKqCkKGk8myCkYcxJjqIpb1Xly3MKqsa7k8046Vsp8mghugAIUsT
 gInExqmUg5URhoHAEDicXjj3NAYeP7d0o0jZHKYlJ+e+wWxDVJ7EcaBnZN3MBPwJ8HVn
 GmPJStXW4fiNEtVDFAbhwti4jlE3Rv7JDjXNVsH4fKh2gyMtIra0IGklIUUNkT0eP8d8
 jsUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=f1GdIOWvJZ8YlHGGMuhVEFDO/Kt84MDgjn8Ofz2/F8Y=;
 b=i4cIN7KyLLyWWtE7clUaMUylWpYpgrpSQOVtsEt/iKw2lJuSrbj+q8zT1B1hO88z9j
 0O5x5SNl8XmrtW+dIezMofmbHVllPnFEXnblJBc+AbiFfBFuqvR+YSmrygxLjY6cFsJ+
 CTAcHrNJCitGyXfCH9/uoJ6MeB+NQ2Dd4h6J8htlFPj0TlT9CGHZquSpJpJoMzIcOjAq
 FGQUuQHMXUbb31tkV8qdHjvPpw5tImJ2fDaWZo2SNoyWgLcZKjHY8agrl2tWeMJeRcdF
 9QwAWK3o1izPINaG22e3DVIH0Z4WIbCNpBt+jsN+1cc7R3jNqsjRYk5PRwif5Ap+j0jD
 QEqQ==
X-Gm-Message-State: AOAM532ndDBv0LDsscEv437w/piEIoFgE3uknSICfJ79tjFVJu5N48J5
 AVRXH+C75DXbD2MKG8VYNvsa4wq4GHes3CnW
X-Google-Smtp-Source: ABdhPJzAVCI8XgY8zMXDXMyLMYGebhemAOYVzv8iTLVceOpS4x3HeU5X736mpWygTAtBBIyX18em7Q==
X-Received: by 2002:adf:ef45:: with SMTP id c5mr7278188wrp.384.1600807767566; 
 Tue, 22 Sep 2020 13:49:27 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id s12sm5916222wmd.20.2020.09.22.13.49.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:26 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 09/10] kvm: arm64: Set up hyp percpu data for nVHE
Date: Tue, 22 Sep 2020 21:49:09 +0100
Message-Id: <20200922204910.7265-10-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
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
 arch/arm64/kernel/vmlinux.lds.S   |  8 +++++
 arch/arm64/kvm/arm.c              | 55 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  6 ++++
 arch/arm64/kvm/pmu.c              |  5 ++-
 5 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 911d91787fa0..863f669d4dc8 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -66,8 +66,19 @@
 #define CHOOSE_VHE_SYM(sym)	sym
 #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
 
-#define this_cpu_ptr_nvhe_sym(sym)	this_cpu_ptr(&kvm_nvhe_sym(sym))
-#define per_cpu_ptr_nvhe_sym(sym, cpu)	per_cpu_ptr(&kvm_nvhe_sym(sym), cpu)
+/*
+ * Compute pointer to a symbol defined in nVHE percpu region.
+ * Returns NULL if percpu memory has not been allocated yet.
+ */
+#define this_cpu_ptr_nvhe_sym(sym)	per_cpu_ptr_nvhe_sym(sym, smp_processor_id())
+#define per_cpu_ptr_nvhe_sym(sym, cpu)						\
+	({									\
+		unsigned long base, off;					\
+		base = kvm_arm_hyp_percpu_base[cpu];				\
+		off = (unsigned long)&CHOOSE_NVHE_SYM(sym) -			\
+		      (unsigned long)&CHOOSE_NVHE_SYM(__per_cpu_start);		\
+		base ? (typeof(CHOOSE_NVHE_SYM(sym))*)(base + off) : NULL;	\
+	})
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 /*
@@ -117,6 +128,10 @@ DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
 
+extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
+DECLARE_KVM_NVHE_SYM(__per_cpu_start);
+DECLARE_KVM_NVHE_SYM(__per_cpu_end);
+
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 extern atomic_t arm64_el2_vector_last_slot;
 DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index d14166012e51..d52e6b5dbfd3 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -28,8 +28,15 @@ jiffies = jiffies_64;
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
@@ -195,6 +202,7 @@ SECTIONS
 	}
 
 	PERCPU_SECTION(L1_CACHE_BYTES)
+	HYPERVISOR_PERCPU_SECTION
 
 	.rela.dyn : ALIGN(8) {
 		*(.rela .rela*)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0424667c4c0a..cd5293e55fec 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
@@ -1258,6 +1259,19 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 }
 
+static unsigned long nvhe_percpu_size(void)
+{
+	return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -
+		(unsigned long)CHOOSE_NVHE_SYM(__per_cpu_start);
+}
+
+static unsigned long nvhe_percpu_order(void)
+{
+	unsigned long size = nvhe_percpu_size();
+
+	return size ? get_order(size) : 0;
+}
+
 static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
@@ -1273,8 +1287,8 @@ static void cpu_init_hyp_mode(void)
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	tpidr_el2 = ((unsigned long)this_cpu_ptr(&kvm_host_data) -
-		     (unsigned long)kvm_ksym_ref(&kvm_host_data));
+	tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
+		    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
@@ -1464,8 +1478,10 @@ static void teardown_hyp_mode(void)
 	int cpu;
 
 	free_hyp_pgds();
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+		free_pages(kvm_arm_hyp_percpu_base[cpu], nvhe_percpu_order());
+	}
 }
 
 /**
@@ -1498,6 +1514,24 @@ static int init_hyp_mode(void)
 		per_cpu(kvm_arm_hyp_stack_page, cpu) = stack_page;
 	}
 
+	/*
+	 * Allocate and initialize pages for Hypervisor-mode percpu regions.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct page *page;
+		void *page_addr;
+
+		page = alloc_pages(GFP_KERNEL, nvhe_percpu_order());
+		if (!page) {
+			err = -ENOMEM;
+			goto out_err;
+		}
+
+		page_addr = page_address(page);
+		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
+		kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
+	}
+
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
@@ -1542,6 +1576,21 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	/*
+	 * Map Hyp percpu pages
+	 */
+	for_each_possible_cpu(cpu) {
+		char *percpu_begin = (char *)kvm_arm_hyp_percpu_base[cpu];
+		char *percpu_end = percpu_begin + nvhe_percpu_size();
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
index c869c851d2dd..faf32a44ba04 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -33,7 +33,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
 	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
 
-	if (!kvm_pmu_switch_needed(attr))
+	if (!ctx || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -49,6 +49,9 @@ void kvm_clr_pmu_events(u32 clr)
 {
 	struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
 
+	if (!ctx)
+		return;
+
 	ctx->pmu_events.events_host &= ~clr;
 	ctx->pmu_events.events_guest &= ~clr;
 }
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
