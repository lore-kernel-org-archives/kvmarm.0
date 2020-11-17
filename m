Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5FAC5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDE3B221FD
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Y46xsWr+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDE3B221FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2C74B8F2;
	Tue, 17 Nov 2020 13:17:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lGeNpBqCfY4Z; Tue, 17 Nov 2020 13:17:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E48654B7DC;
	Tue, 17 Nov 2020 13:17:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5720E4B8D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y8qNlNpM+xzw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:17:23 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976BC4B79D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:22 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id g5so11884568wrp.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=UnISW/7ysLvEOA4M0KYS2DiSYKHuk/dOZvBw6jTbu2M=;
 b=Y46xsWr+fpscULTkv6wJmNLh4Rny8VDfXImWw0g4FGuDGcH5Dj65BmOnRZesT6ZFth
 nzmvzgrCAMT35AMiTIAi2DFYOrh/Aq6nY55zm/m6DPUxjPGsHta+ja7jqxqUfCU4FnQb
 MHtfB5aoKisNqH6shJKNLDU/NzfYKajoHo+mIn3KhtSthuEGflYJZp2bEpYphw8Ro2WW
 /CkJ+W+rUFgkwTPjM8pjl1ZQjOacdVnCazJPTUwiatafcU5KRWPDo1VSlIpvGL2urLm2
 2XqyygWV30YhIq8Z5vT4EcO3G69skl7KBQjf4G1HIF/tPT4vHuT52snzhwlVedT2HSLA
 53Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UnISW/7ysLvEOA4M0KYS2DiSYKHuk/dOZvBw6jTbu2M=;
 b=MkEWDjItyHmXdGVtaKMywpbuozt+QAqTfXdL5Lwk5ut8dVPpombL0LXdkaiS+BRCuK
 qOeGqy3xqbrNpUNlQUJ46hBAE0th7VGdSlxHUo529DYOpHTN3pROwXLipg4qDvLc0TYS
 SgjD1YW9pvVktdxrtsDZyS6KPkPFu+mueJHVpLZ5Zv5j16jqAg+8iBlQwPfYfQlAwMUA
 KSrR6xJnVqNdLQXwEdXULDxnR0KF/wipzCOEVL+Yuskci+m04H/AFpjoak4oRq+pBMRx
 aKindzoEoZn0ZYwBdg3SrZ3BRPMHske402ma1feoKOmzXBDUJ3sQzyzefp1KJpnE8KpE
 FHqw==
X-Gm-Message-State: AOAM533IW8obWqidR/MkJ2nIwOwhQN6/IlxGjYBFpkiQCJzOYpzaetyc
 oHpk1H7uES0wD2t86BHR4XdABLCh81G1
X-Google-Smtp-Source: ABdhPJxB+DSZR+N3pyG/NRrgmrD0zn/VZQ6upGsPUcqxEFyzBuPz5gz5FQIvepAWoMo779y7fqqxMM7WrNUQ
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a1c:9ad3:: with SMTP id
 c202mr346589wme.43.1605637041767; Tue, 17 Nov 2020 10:17:21 -0800 (PST)
Date: Tue, 17 Nov 2020 18:16:07 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-28-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 27/27] KVM: arm64: Wrap the host with a stage 2
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   6 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 191 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   6 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |   7 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
 9 files changed, 247 insertions(+), 7 deletions(-)
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
index f2d43e6cd86d..e2652278dd63 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -137,6 +137,9 @@ KVM_NVHE_ALIAS(__hyp_data_ro_after_init_end);
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
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a0bfe0d26da6..5d0cb17e03a1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
@@ -234,6 +235,11 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
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
index b73e6b08cfba..3e079027e608 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -12,6 +12,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 
 struct hyp_pool hpool;
@@ -161,6 +162,11 @@ void __noreturn __kvm_hyp_protect_finalise(void)
 	if (ret)
 		goto out;
 
+	/* Wrap the host with a stage 2 */
+	ret = kvm_host_prepare_stage2(host_s2_mem_pgt_base, host_s2_dev_pgt_base);
+	if (ret)
+		goto out;
+
 	hyp_pgtable_mm_ops.zalloc_page = hyp_zalloc_hyp_page;
 	hyp_pgtable_mm_ops.phys_to_virt = hyp_phys_to_virt;
 	hyp_pgtable_mm_ops.virt_to_phys = hyp_virt_to_phys;
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
