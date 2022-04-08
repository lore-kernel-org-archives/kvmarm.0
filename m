Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB124C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 20:05:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 812B84B0D0;
	Fri,  8 Apr 2022 16:05:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IVfjH474hClJ; Fri,  8 Apr 2022 16:05:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AE174B216;
	Fri,  8 Apr 2022 16:05:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F8E4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:05:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xL9R+uGYW7wv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 16:05:29 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87E594B0D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:05:29 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2eb5d4fbd54so84981217b3.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 13:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=29m9VxVlX1cygVbwxroxIUp2tBTU4nq34nZ2FiozReE=;
 b=nUBtx/VHP2Ru1W903kJ1uH9fsTWHYrvlrk43uEvSrOUU8HseqVNL2SYQIi710T8ljb
 aYibGOQhj+PCP3vWdV30uKckypkUslNCAcXRsvrlANH0jurvO8/B6/BwhwRxWCB8Zmmm
 hG+B7YA2puFsn7Vd/oT9bPbN8OnqMwMQ0aynYGDQP+ikL48lOxOXeMSGaoP72HQCdhjU
 LjpmVYxi7G6FNtjwN396olmJs1SlupqJqEiTNHYoGZgI0fOgokkg91s9gjROKaVimFnE
 7Vr/iaDyx1XOLjbTz5XxB0dY02K7Iwrww0o5s99vFzR9KU3MhOlRnqR8CEVZ5XYLfFfH
 Iq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=29m9VxVlX1cygVbwxroxIUp2tBTU4nq34nZ2FiozReE=;
 b=ueXBIvCSKvVRk2JmNWn4EXSnuwtWjqh/Ffoppsfx8YB2iSRIeE2gASGUQzABgGR2rb
 HyRjDEERtkOrWnI6zOuV3OMgsm5GMUzedzYwuU3xMrheChUO83ExXSbfqZx4f5ql3dRy
 CWEV6vyWcEol5p0lX4txmR2fd3xHdgcHdkToZsxK+d36mUkM9qMkGLl70oWyQXYGdtOF
 YsV+18SMASUCxFPMFBtBkk5EovvPVgCeO10B/5fini5kBYuOLLbA/5oSCcf5OaYERL0i
 tQ+tOn3/6gCCTFEoAQj+Pkuv3vwxCpPtGXlpJy0y0+xHOhp586vM4tMHCtrIRR3MoBzs
 fTQg==
X-Gm-Message-State: AOAM532caS9iykbO6MID2RiHvGQl3y8XBXJKXuvhMcExuwHfevUUBs6q
 pkLjHvGnxSAW//noobzBJSX12f8GqV39dx6TIA==
X-Google-Smtp-Source: ABdhPJxPvXyZJz5yABmprIe2Wi2nZxdszLJ8/RPz1xA9zPm4kfJwjfF5pqyZVXur4gF7wDginbdQwTmFbuL9N8LYpg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f0ed:c8a:dab7:ecc2])
 (user=kaleshsingh job=sendgmr) by 2002:a25:8551:0:b0:62c:2928:6f06 with SMTP
 id f17-20020a258551000000b0062c29286f06mr15147786ybn.586.1649448328922; Fri,
 08 Apr 2022 13:05:28 -0700 (PDT)
Date: Fri,  8 Apr 2022 13:03:26 -0700
In-Reply-To: <20220408200349.1529080-1-kaleshsingh@google.com>
Message-Id: <20220408200349.1529080-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v7 3/6] KVM: arm64: Add guard pages for KVM nVHE hypervisor
 stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org, maz@kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 Changbin Du <changbin.du@intel.com>, linux-arm-kernel@lists.infradead.org,
 surenb@google.com, kvmarm@lists.cs.columbia.edu
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
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v7:
  - Add Fuad's Reviewed-by and Tested-by tags.

Changes in v6:
  - Update call to hyp_alloc_private_va_range() (return val and params)

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
 arch/arm64/kvm/arm.c             | 39 +++++++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c             |  4 ++--
 4 files changed, 42 insertions(+), 5 deletions(-)

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
index a50cbb5ba402..b805316c4866 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -117,6 +117,9 @@ alternative_cb_end
 #include <asm/mmu_context.h>
 #include <asm/kvm_host.h>
 
+extern struct kvm_pgtable *hyp_pgtable;
+extern struct mutex kvm_hyp_pgd_mutex;
+
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_layout(void);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..5687c0175151 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1483,7 +1483,6 @@ static void cpu_prepare_hyp_mode(int cpu)
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
 
-	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
 	params->pgd_pa = kvm_mmu_get_httbr();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
@@ -1933,14 +1932,48 @@ static int init_hyp_mode(void)
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
+		err = hyp_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
+		if (err) {
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
index 3d3efea4e991..a54f00bd06cc 100644
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
