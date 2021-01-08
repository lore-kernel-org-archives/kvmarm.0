Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11B3C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DE21238E4
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DE21238E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 112BC4B3DF;
	Fri,  8 Jan 2021 07:16:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M2-63xXYA8AV; Fri,  8 Jan 2021 07:16:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 855694B457;
	Fri,  8 Jan 2021 07:16:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2D84B25F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2qVkuCmZMmrr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:16:23 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14C6D4B333
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:23 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id k12so8098766qth.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Lrlj1zDpp+shrrwmzbQl9mYOjw6ZCNar4qli7UVIZg8=;
 b=QYBd4WEQOF4REiQLDjhfFLKTSA4R+NFLQg2B9Erk2dzayOKXXWBgd3qanm8CvF9O6J
 Dj+uCbnNKDFXnYnwn4+Xm8ijA/E495hdew2v/ZPC72mevkxaL2ciGTNCFbeW9grImfI0
 78aW9PAWZckzh8gSBG9r8R7njJgk/4bj4nIpggBODLnxQc1pgv/I/bpGkj1wAdP5Mq/o
 RUjCsP159LZoa4NZE3yw7vylLW6Fi5vjJwtAc30L3gIzdKOEl2q4BBVHkH0fHqZyJlJx
 sn6M3xQBYc7fCDnQ1I65JGs7sYpKM3fVCAvCjj4PmjMmnt9grfV66Dy3LHpzSb/IEfiD
 QDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Lrlj1zDpp+shrrwmzbQl9mYOjw6ZCNar4qli7UVIZg8=;
 b=kkrbLb0HzCxNqGpo4d+qGNNN2e9Ed0VGLzquakOEFBgTJeZb1VbXmZt/zZNMaDn+Bq
 vVjnG74llzrtoy0VfW+f6SpbcGCcqTkD8ZYk7a5NO0QorPuYxJ/JWCjlzK7Wsjude5L5
 p/AJ7n4IkSdC6Uan2lv3EsFtjM6hDqtBJ6CYn8zXv1ynLpGwDwc9NkNvymWpqymHo/5M
 ooIWiccp7ZAuyeklxIbSZ1ELeQFvTaN9zILqRdEqYDdPTXJUwt6QC04ORjf3m7D3YvRK
 c966fI5lmvmkjsK+RG65gCxFb//2a8RFNp5wfMK/nn/IzFLTcx2vWC3ztz7xCHP+RLsp
 U/ew==
X-Gm-Message-State: AOAM533pSlu/FJFUQ4d1LRcZ/NkZa27vXyRQhGhS9zAlrJacJWVGEorA
 yyDSI6JxmwwtjiwbIDkHQ2lcrcf8wQTA
X-Google-Smtp-Source: ABdhPJwWb0+XWZHJHqQdj0HxGhIlVOl0nrUOGKnqucLq/KGZtWR5BTrNZ4VLQrIi7/M7Gz3+vkyldnyYXjU8
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:9ccb:: with SMTP id
 j11mr6363177qvf.44.1610108182674; Fri, 08 Jan 2021 04:16:22 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:24 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-27-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 26/26] KVM: arm64: Wrap the host with a stage 2
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

When KVM runs in protected nVHE mode, make use of a stage 2 page-table
to give the hypervisor some control over the host memory accesses. At
the moment all memory aborts from the host will be instantly idmapped
RWX at stage 2 in a lazy fashion. Later patches will make use of that
infrastructure to implement access control restrictions to e.g. protect
guest memory from the host.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_cpufeature.h       |   2 +
 arch/arm64/kernel/image-vars.h                |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  33 +++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   6 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 191 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   6 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |   7 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
 10 files changed, 248 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c

diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
index d34f85cba358..74043a149322 100644
--- a/arch/arm64/include/asm/kvm_cpufeature.h
+++ b/arch/arm64/include/asm/kvm_cpufeature.h
@@ -15,3 +15,5 @@
 #endif
 
 KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0)
+KVM_HYP_CPU_FTR_REG(SYS_ID_AA64MMFR0_EL1, arm64_ftr_reg_id_aa64mmfr0_el1)
+KVM_HYP_CPU_FTR_REG(SYS_ID_AA64MMFR1_EL1, arm64_ftr_reg_id_aa64mmfr1_el1)
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 366d837f0d39..e4e4f30ac251 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -132,6 +132,9 @@ KVM_NVHE_ALIAS(__hyp_data_ro_after_init_end);
 KVM_NVHE_ALIAS(__hyp_bss_start);
 KVM_NVHE_ALIAS(__hyp_bss_end);
 
+/* pKVM static key */
+KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
new file mode 100644
index 000000000000..a22ef118a610
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#ifndef __KVM_NVHE_MEM_PROTECT__
+#define __KVM_NVHE_MEM_PROTECT__
+#include <linux/kvm_host.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/virt.h>
+#include <nvhe/spinlock.h>
+
+struct host_kvm {
+	struct kvm_arch arch;
+	struct kvm_pgtable pgt;
+	struct kvm_pgtable_mm_ops mm_ops;
+	hyp_spinlock_t lock;
+};
+extern struct host_kvm host_kvm;
+
+int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool);
+void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
+
+static __always_inline void __load_host_stage2(void)
+{
+	if (static_branch_likely(&kvm_protected_mode_initialized))
+		__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
+	else
+		write_sysreg(0, vttbr_el2);
+}
+#endif /* __KVM_NVHE_MEM_PROTECT__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index d7381a503182..c3e2f98555c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -11,7 +11,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
-	 cache.o cpufeature.o setup.o mm.o
+	 cache.o cpufeature.o setup.o mm.o mem_protect.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index b1341bb4b453..32591db76c75 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -129,6 +129,7 @@ alternative_else_nop_endif
 
 	/* Invalidate the stale TLBs from Bootloader */
 	tlbi	alle2
+	tlbi	vmalls12e1
 	dsb	sy
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3075f117651c..93699600bc22 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/trap_handler.h>
 
@@ -222,6 +223,11 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_SMC64:
 		handle_host_smc(host_ctxt);
 		break;
+	case ESR_ELx_EC_IABT_LOW:
+		fallthrough;
+	case ESR_ELx_EC_DABT_LOW:
+		handle_host_mem_abort(host_ctxt);
+		break;
 	default:
 		hyp_panic();
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
new file mode 100644
index 000000000000..0cd3eb178f3b
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_cpufeature.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/stage2_pgtable.h>
+
+#include <hyp/switch.h>
+
+#include <nvhe/gfp.h>
+#include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/mm.h>
+
+extern unsigned long hyp_nr_cpus;
+struct host_kvm host_kvm;
+
+struct hyp_pool host_s2_mem;
+struct hyp_pool host_s2_dev;
+
+static void *host_s2_zalloc_pages_exact(size_t size)
+{
+	return hyp_alloc_pages(&host_s2_mem, HYP_GFP_ZERO, get_order(size));
+}
+
+static void *host_s2_zalloc_page(void *pool)
+{
+	return hyp_alloc_pages(pool, HYP_GFP_ZERO, 0);
+}
+
+static int prepare_s2_pools(void *mem_pgt_pool, void *dev_pgt_pool)
+{
+	unsigned long nr_pages;
+	int ret;
+
+	nr_pages = host_s2_mem_pgtable_size() >> PAGE_SHIFT;
+	ret = hyp_pool_init(&host_s2_mem, __hyp_pa(mem_pgt_pool), nr_pages, 0);
+	if (ret)
+		return ret;
+
+	nr_pages = host_s2_dev_pgtable_size() >> PAGE_SHIFT;
+	ret = hyp_pool_init(&host_s2_dev, __hyp_pa(dev_pgt_pool), nr_pages, 0);
+	if (ret)
+		return ret;
+
+	host_kvm.mm_ops.zalloc_pages_exact = host_s2_zalloc_pages_exact;
+	host_kvm.mm_ops.zalloc_page = host_s2_zalloc_page;
+	host_kvm.mm_ops.phys_to_virt = hyp_phys_to_virt;
+	host_kvm.mm_ops.virt_to_phys = hyp_virt_to_phys;
+	host_kvm.mm_ops.page_count = hyp_page_count;
+	host_kvm.mm_ops.get_page = hyp_get_page;
+	host_kvm.mm_ops.put_page = hyp_put_page;
+
+	return 0;
+}
+
+static void prepare_host_vtcr(void)
+{
+	u32 parange, phys_shift;
+	u64 mmfr0, mmfr1;
+
+	mmfr0 = arm64_ftr_reg_id_aa64mmfr0_el1.sys_val;
+	mmfr1 = arm64_ftr_reg_id_aa64mmfr1_el1.sys_val;
+
+	/* The host stage 2 is id-mapped, so use parange for T0SZ */
+	parange = kvm_get_parange(mmfr0);
+	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
+
+	host_kvm.arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
+}
+
+int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
+{
+	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
+	struct kvm_nvhe_init_params *params;
+	int ret, i;
+
+	prepare_host_vtcr();
+	hyp_spin_lock_init(&host_kvm.lock);
+
+	ret = prepare_s2_pools(mem_pgt_pool, dev_pgt_pool);
+	if (ret)
+		return ret;
+
+	ret = kvm_pgtable_stage2_init(&host_kvm.pgt, &host_kvm.arch,
+				      &host_kvm.mm_ops);
+	if (ret)
+		return ret;
+
+	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
+	mmu->arch = &host_kvm.arch;
+	mmu->pgt = &host_kvm.pgt;
+	mmu->vmid.vmid_gen = 0;
+	mmu->vmid.vmid = 0;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		params = per_cpu_ptr(&kvm_init_params, i);
+		params->vttbr = kvm_get_vttbr(mmu);
+		params->vtcr = host_kvm.arch.vtcr;
+		params->hcr_el2 |= HCR_VM;
+		__flush_dcache_area(params, sizeof(*params));
+	}
+
+	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
+	__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
+
+	return 0;
+}
+
+static void host_stage2_unmap_dev_all(void)
+{
+	struct kvm_pgtable *pgt = &host_kvm.pgt;
+	struct hyp_memblock_region *reg;
+	u64 addr = 0;
+	int i;
+
+	/* Unmap all non-memory regions to recycle the pages */
+	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->end) {
+		reg = &hyp_memory[i];
+		kvm_pgtable_stage2_unmap(pgt, addr, reg->start - addr);
+	}
+	kvm_pgtable_stage2_unmap(pgt, addr, ULONG_MAX);
+}
+
+static bool ipa_is_memory(u64 ipa)
+{
+	int cur, left = 0, right = hyp_memblock_nr;
+	struct hyp_memblock_region *reg;
+
+	/* The list of memblock regions is sorted, binary search it */
+	while (left < right) {
+		cur = (left + right) >> 1;
+		reg = &hyp_memory[cur];
+		if (ipa < reg->start)
+			right = cur;
+		else if (ipa >= reg->end)
+			left = cur + 1;
+		else
+			return true;
+	}
+
+	return false;
+}
+
+static int __host_stage2_map(u64 ipa, u64 size, enum kvm_pgtable_prot prot,
+			     struct hyp_pool *p)
+{
+	return kvm_pgtable_stage2_map(&host_kvm.pgt, ipa, size, ipa, prot, p);
+}
+
+static int host_stage2_map(u64 ipa, u64 size, enum kvm_pgtable_prot prot)
+{
+	int ret, is_memory = ipa_is_memory(ipa);
+	struct hyp_pool *pool;
+
+	pool = is_memory ? &host_s2_mem : &host_s2_dev;
+
+	hyp_spin_lock(&host_kvm.lock);
+	ret = __host_stage2_map(ipa, size, prot, pool);
+	if (ret == -ENOMEM && !is_memory) {
+		host_stage2_unmap_dev_all();
+		ret = __host_stage2_map(ipa, size, prot, pool);
+	}
+	hyp_spin_unlock(&host_kvm.lock);
+
+	return ret;
+}
+
+void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
+{
+	enum kvm_pgtable_prot prot;
+	u64 far, hpfar, esr, ipa;
+	int ret;
+
+	esr = read_sysreg_el2(SYS_ESR);
+	if (!__get_fault_info(esr, &far, &hpfar))
+		hyp_panic();
+
+	prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_X;
+	ipa = (hpfar & HPFAR_MASK) << 8;
+	ret = host_stage2_map(ipa, PAGE_SIZE, prot);
+	if (ret)
+		hyp_panic();
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 79b697df01e2..f6d3318e92fa 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -12,6 +12,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 
 struct hyp_pool hpool;
@@ -161,6 +162,11 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	/* Wrap the host with a stage 2 */
+	ret = kvm_host_prepare_stage2(host_s2_mem_pgt_base, host_s2_dev_pgt_base);
+	if (ret)
+		goto out;
+
 	pkvm_pgtable_mm_ops.zalloc_page = hyp_zalloc_hyp_page;
 	pkvm_pgtable_mm_ops.phys_to_virt = hyp_phys_to_virt;
 	pkvm_pgtable_mm_ops.virt_to_phys = hyp_virt_to_phys;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 979a76cdf9fb..31bc1a843bf8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -28,6 +28,8 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+#include <nvhe/mem_protect.h>
+
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
@@ -102,11 +104,6 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
-static void __load_host_stage2(void)
-{
-	write_sysreg(0, vttbr_el2);
-}
-
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index fbde89a2c6e8..255a23a1b2db 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -8,6 +8,8 @@
 #include <asm/kvm_mmu.h>
 #include <asm/tlbflush.h>
 
+#include <nvhe/mem_protect.h>
+
 struct tlb_inv_context {
 	u64		tcr;
 };
@@ -43,7 +45,7 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 
 static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 {
-	write_sysreg(0, vttbr_el2);
+	__load_host_stage2();
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Ensure write of the host VMID */
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
