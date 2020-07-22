Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0F9C433F2
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B001F22BEF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="O+j9vJMx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B001F22BEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 670AA4B26F;
	Wed, 22 Jul 2020 12:45:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PizDil5SPKYF; Wed, 22 Jul 2020 12:45:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 110C54B2BD;
	Wed, 22 Jul 2020 12:45:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 909144B2B7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ocmc59xrLale for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:45:14 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46FB14B28F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:14 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id w3so2619637wmi.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 09:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=V96ak4i8UKYW1530XCTpq7OSsFZ4sEMYY/vy7g+OwDs=;
 b=O+j9vJMxDWg4Y7iNQtrBdo/PaCRmPCN0IrEKu0IAOXYNS4QWENM1txkn/akKPubHQt
 2Q9bO5sSIjnp7XX8FPY3pwRcbHoMqdMJkGzXaT88liZXeU7cj6sVsFUDq1KO/ckOzlAz
 QczOXDyjtOBABv852W5Tzx6/2+oXjm/PTaAoZQsN+a7dWEbseiKUqyXAyZZWizDvGnjU
 1FZUbG1JADmor77thW2lzkIlb3rOoNPKVh6tb9aPE4gepPFwYQCfH9Zb86Pby+wMTA/O
 NAZylWO739DSTe2kT8txIfBsXMeHOQKFBra06R5Omocjlvxtbruuk8RbcoziaI81HyVd
 QAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=V96ak4i8UKYW1530XCTpq7OSsFZ4sEMYY/vy7g+OwDs=;
 b=T5VZF6Z3QzqsceiO+5gUoXusUgShSxqEwISfmwnxzv0L3sb8jaiPR8Ea8ZJxB+nqR6
 3FF0Ctwk/20wxD2k31QkKWApiZ5MtAuodIEeosY9w72WMzs0AuO+boqGbYp+EHpG/f3q
 n1ZqY4bOb6QmG3oVXAu3e0quHo7jT+zedbVYryKoB//DRZ+tUjXEwp/wynwoCCJuWBMC
 sXtaQ/ii4zPF+wnDC68O6rX028QEWdfd9+hMmEXRzcRuCmRrkBH/r4QcBI0E4lpGae1a
 fP4kkCJ/3VT+3M6BhGmiWywbFO83owhX+y9Qu6X5UjBGl0EE+NpiDItGdIAFQHLntTmP
 Gd/A==
X-Gm-Message-State: AOAM532Wu5aMiMYSCo26Q1NkRfmAI8qGmb8vPRO/ooFxChvC6zwHK7r0
 0q0MlEZI+QtoRvwSgYLCPEHaVw==
X-Google-Smtp-Source: ABdhPJzzu8w3H0zHy13NXlQtb/DWOK/nCH71MNq45VhKumCJJVIQ8gvuKohqxVj5jKeuYtcbVRZ2Vg==
X-Received: by 2002:a1c:2045:: with SMTP id g66mr452060wmg.184.1595436313169; 
 Wed, 22 Jul 2020 09:45:13 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:b0ee:900a:e004:b9d0])
 by smtp.gmail.com with ESMTPSA id h5sm521647wrc.97.2020.07.22.09.45.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jul 2020 09:45:12 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 8/9] kvm: arm64: Set up hyp percpu data for nVHE
Date: Wed, 22 Jul 2020 17:44:23 +0100
Message-Id: <20200722164424.42225-9-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200722164424.42225-1-dbrazdil@google.com>
References: <20200722164424.42225-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
init time, and create corresponding hyp mappings.

The base addresses of hyp percpu regions are kept in a dynamically allocated
array in the kernel.

Add NULL checks in PMU event-reset code as it may run before KVM memory is
initialized.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 19 +++++++++--
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++
 arch/arm64/kvm/arm.c              | 55 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/Makefile  |  2 ++
 arch/arm64/kvm/pmu.c              |  5 ++-
 6 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 3d69cab873e4..22e63e651702 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -72,8 +72,23 @@
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
index 6827da7f3aa5..c678615ccd6d 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -16,6 +16,9 @@
 
 #include "image.h"
 
+#define __CONCAT3(x, y, z) x ## y ## z
+#define CONCAT3(x, y, z) __CONCAT3(x, y, z)
+
 OUTPUT_ARCH(aarch64)
 ENTRY(_text)
 
@@ -187,6 +190,13 @@ SECTIONS
 
 	PERCPU_SECTION(L1_CACHE_BYTES)
 
+	/* KVM nVHE per-cpu section */
+	#undef PERCPU_SECTION_NAME
+	#undef PERCPU_SYMBOL_NAME
+	#define PERCPU_SECTION_NAME(suffix)	CONCAT3(.hyp, PERCPU_SECTION_BASE_NAME, suffix)
+	#define PERCPU_SYMBOL_NAME(name)	__kvm_nvhe_ ## name
+	PERCPU_SECTION(L1_CACHE_BYTES)
+
 	.rela.dyn : ALIGN(8) {
 		*(.rela .rela*)
 	}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index dc557b380c87..bbbc5c1519a9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
 #endif
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+unsigned long *kvm_arm_hyp_percpu_base;
 
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
@@ -1253,6 +1254,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 }
 
+#define kvm_hyp_percpu_base(cpu)	((unsigned long)per_cpu_ptr_nvhe(__per_cpu_start, cpu))
+#define kvm_hyp_percpu_array_size	(nr_cpu_ids * sizeof(*kvm_arm_hyp_percpu_base))
+#define kvm_hyp_percpu_array_order	(get_order(kvm_hyp_percpu_array_size))
+#define kvm_hyp_percpu_begin		CHOOSE_NVHE_SYM(__per_cpu_start)
+#define kvm_hyp_percpu_size		((unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) - \
+					 (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_start))
+#define kvm_hyp_percpu_order		(kvm_hyp_percpu_size \
+						? get_order(kvm_hyp_percpu_size) : 0)
+
 static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
@@ -1268,8 +1278,8 @@ static void cpu_init_hyp_mode(void)
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	tpidr_el2 = ((unsigned long)this_cpu_ptr(&kvm_host_data) -
-		     (unsigned long)kvm_ksym_ref(&kvm_host_data));
+	tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe(__per_cpu_start) -
+		    (unsigned long)kvm_ksym_ref(kvm_hyp_percpu_begin);
 
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
@@ -1501,8 +1511,11 @@ static void teardown_hyp_mode(void)
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
@@ -1535,6 +1548,28 @@ static int init_hyp_mode(void)
 		per_cpu(kvm_arm_hyp_stack_page, cpu) = stack_page;
 	}
 
+	/*
+	 * Allocate and initialize pages for Hypervisor-mode percpu regions.
+	 */
+	kvm_arm_hyp_percpu_base = (unsigned long*)alloc_hyp_pages(
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
+		memcpy((void*)percpu_base, kvm_hyp_percpu_begin, kvm_hyp_percpu_size);
+		kvm_arm_hyp_percpu_base[cpu] = percpu_base;
+	}
+
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
@@ -1579,6 +1614,20 @@ static int init_hyp_mode(void)
 		}
 	}
 
+	/*
+	 * Map Hyp percpu pages
+	 */
+	for_each_possible_cpu(cpu) {
+		char *percpu_begin = (char *)kvm_arm_hyp_percpu_base[cpu];
+		char *percpu_end = percpu_begin + PAGE_ALIGN(kvm_hyp_percpu_size);
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
 
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0b34414557d6..1d415698e60e 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -23,6 +23,8 @@ $(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
 quiet_cmd_hypcopy = HYPCOPY $@
       cmd_hypcopy = $(OBJCOPY)	--prefix-symbols=__kvm_nvhe_		\
 				--rename-section=.text=.hyp.text	\
+				--rename-section=.data..percpu=.hyp.data..percpu \
+				--rename-section=.data..percpu..read_mostly=.hyp.data..percpu..read_mostly \
 				$< $@
 
 # Remove ftrace and Shadow Call Stack CFLAGS.
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 717941910723..b4c8302f0798 100644
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
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
