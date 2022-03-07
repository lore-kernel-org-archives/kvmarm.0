Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C31C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 18:51:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DFD44B0C5;
	Mon,  7 Mar 2022 13:51:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cY9R71DwlVCK; Mon,  7 Mar 2022 13:51:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1723E49F01;
	Mon,  7 Mar 2022 13:51:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C73F49F01
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:51:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LYiY7aHHfGpI for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 13:51:21 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2913149EFB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:51:21 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2dcfa6bab2aso7978727b3.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 10:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=PouKLLR1qtfDqJBB+NkFAo5RJJpYZHlkNUkobibAveQ=;
 b=aJTRdfEPXajjtz7jpjusbLUwZHazPtaAdcjDseH62JaWa29UuajDbAb71dvJHhmKqT
 qDiEGjeGQ4zUeX1iZ3TO4pqzbbBPJSr65U+uI9jgrHLjrzrHfOacA3jGMrixx0OKeWw/
 RZREPe+YYXjsHh9sKXqWOuy0autI6OXkU0BqTNyuCWB5XU9T49hoGPRmWqE8UgfejZQd
 lcIGj6FSH3p02df0kKhGSZ5izAjpIfMfx0+LzeUc2uxAhgEI3OyQrNk/sYfnaMqBZH8s
 Sy1AAqCHZortJ4WqKOZ77ZdIBVlnzmrr8Fhl/QsWQxE7Bl7ms2oB3fxyn9Va3qqO4cB7
 ukcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=PouKLLR1qtfDqJBB+NkFAo5RJJpYZHlkNUkobibAveQ=;
 b=3cemf2FiQoasLe4NORRJwy7UCMy1hETC8rWy9XfJzdx/2TlaZ2kNVephHH3h0+1oyn
 a7YKhKIzOHp6KvtL5RaneTxUg3INazrN5bR42H9vig8n1DBLzEGqrBmOmUv/MfI7gjTW
 JCPNQUvh/JaEmkyLFzTFqawE7z7xxwjw65qxNjiuA5XejAl2oFBK9sLGNNb6yUgjK1IN
 yq0BsfEU9Dw9okk2LAGscNm1oZw3JOn42NhGa0l8kKbi8tveHnPiPgn2OTV5fiwupGVX
 8d7TXHowjwALn0QiCEqqZ4hbYLzPMO5v4iOvaWVuGGwha6KEAtEz43e1I5f2uTyy7tWo
 6uUw==
X-Gm-Message-State: AOAM530uN0lupJuHgsFXNkFacLpHw4K9sAZ/VrYv80hBAQU92VZ2Y92m
 wVQuOQKUMY4yDQGEwSMt4n6lBpomcQUTFQDCuQ==
X-Google-Smtp-Source: ABdhPJzwweEi/4c/qw4x+iRcu1VtA4JV/mfDwmW4TcHLmFds7IQbOIZRF8CIqoQFlW80Oc/0DwqmAr/yYYmQ7dz5NQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dd66:1e7d:1858:4587])
 (user=kaleshsingh job=sendgmr) by 2002:a25:8c10:0:b0:61d:b17e:703d with SMTP
 id k16-20020a258c10000000b0061db17e703dmr8988845ybl.154.1646679080527; Mon,
 07 Mar 2022 10:51:20 -0800 (PST)
Date: Mon,  7 Mar 2022 10:49:01 -0800
In-Reply-To: <20220307184935.1704614-1-kaleshsingh@google.com>
Message-Id: <20220307184935.1704614-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v5 3/8] KVM: arm64: Add guard pages for KVM nVHE hypervisor
 stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Walbran <qwandor@google.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com,
 kvmarm@lists.cs.columbia.edu
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

Map the stack pages in the flexible private VA range and allocate
guard pages below the stack as unbacked VA space. The stack is aligned
so that any valid stack address has PAGE_SHIFT bit as 1 - this is used
for overflow detection (implemented in a subsequent patch in the series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Use a single allocation for stack and guard pages to ensure they
    are contiguous, per Marc

Changes in v4:
  - Replace IS_ERR_OR_NULL check with IS_ERR check now that
    hyp_alloc_private_va_range() returns an error for null
    pointer, per Fuad
  - Format comments to < 80 cols, per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark


 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/include/asm/kvm_mmu.h |  3 +++
 arch/arm64/kvm/arm.c             | 40 +++++++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c             |  4 ++--
 4 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d5b0386ef765..2e277f2ed671 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -169,6 +169,7 @@ struct kvm_nvhe_init_params {
 	unsigned long tcr_el2;
 	unsigned long tpidr_el2;
 	unsigned long stack_hyp_va;
+	unsigned long stack_pa;
 	phys_addr_t pgd_pa;
 	unsigned long hcr_el2;
 	unsigned long vttbr;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 514cfee76597..fe40cebe2be2 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -116,6 +116,9 @@ alternative_cb_end
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 
+extern struct kvm_pgtable *hyp_pgtable;
+extern struct mutex kvm_hyp_pgd_mutex;
+
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_layout(void);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..cc712e421c5a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1541,7 +1541,6 @@ static void cpu_prepare_hyp_mode(int cpu)
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
 
-	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
 	params->pgd_pa = kvm_mmu_get_httbr();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
@@ -1990,14 +1989,49 @@ static int init_hyp_mode(void)
 	 * Map the Hyp stack pages
 	 */
 	for_each_possible_cpu(cpu) {
+		struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 		char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
-		err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE,
-					  PAGE_HYP);
+		unsigned long hyp_addr;
 
+		/*
+		 * Allocate a contiguous HYP private VA range for the stack
+		 * and guard page. The allocation is also aligned based on
+		 * the order of its size.
+		 */
+		hyp_addr = hyp_alloc_private_va_range(PAGE_SIZE * 2);
+		if (IS_ERR((void *)hyp_addr)) {
+			err = PTR_ERR((void *)hyp_addr);
+			kvm_err("Cannot allocate hyp stack guard page\n");
+			goto out_err;
+		}
+
+		/*
+		 * Since the stack grows downwards, map the stack to the page
+		 * at the higher address and leave the lower guard page
+		 * unbacked.
+		 *
+		 * Any valid stack address now has the PAGE_SHIFT bit as 1
+		 * and addresses corresponding to the guard page have the
+		 * PAGE_SHIFT bit as 0 - this is used for overflow detection.
+		 */
+		mutex_lock(&kvm_hyp_pgd_mutex);
+		err = kvm_pgtable_hyp_map(hyp_pgtable, hyp_addr + PAGE_SIZE,
+					PAGE_SIZE, __pa(stack_page), PAGE_HYP);
+		mutex_unlock(&kvm_hyp_pgd_mutex);
 		if (err) {
 			kvm_err("Cannot map hyp stack\n");
 			goto out_err;
 		}
+
+		/*
+		 * Save the stack PA in nvhe_init_params. This will be needed
+		 * to recreate the stack mapping in protected nVHE mode.
+		 * __hyp_pa() won't do the right thing there, since the stack
+		 * has been mapped in the flexible private VA space.
+		 */
+		params->stack_pa = __pa(stack_page);
+
+		params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
 	}
 
 	for_each_possible_cpu(cpu) {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ccb2847ee2f4..dfdd8c21ed74 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -22,8 +22,8 @@
 
 #include "trace.h"
 
-static struct kvm_pgtable *hyp_pgtable;
-static DEFINE_MUTEX(kvm_hyp_pgd_mutex);
+struct kvm_pgtable *hyp_pgtable;
+DEFINE_MUTEX(kvm_hyp_pgd_mutex);
 
 static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
