Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22D0C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 20:05:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B91C4B0D0;
	Fri,  8 Apr 2022 16:05:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id shbBwuEgOeTa; Fri,  8 Apr 2022 16:05:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6857B4B0D6;
	Fri,  8 Apr 2022 16:05:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C9AE4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:05:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8WVkoSYkNRux for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 16:05:55 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7741A4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:05:55 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b65-20020a25e444000000b0063dd00480f8so7561006ybh.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 13:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=pAGqEnG2raRkXveZrBOcJyHPFm0QVTMkhlJQFJA6T34=;
 b=fkf7yOt+xD7tPoLc32dR2/1ousTpprVrbdor4w8WJ28DKGW7L4u8ZSraUcycc4uKIx
 qIhFw4XjsCzjNrsqJZ7FDiR7kbhNdo9HlrECBWIGZQYEgklkOp6x/7lnhjh2nr7AkBsn
 C9IsV/kKQ4A+DEBXdbfdSnSJyDQG963lgzXVwwu0RFUrvvAINdb93EZG4Rz+364uJ/kC
 ffGjkLkbzJNk2CmRiYuzdfRe8LxLAzd8qX96szw4FY/GsE2/kqQg4DTyfouy123yi6Fo
 3nuCQkMf/4aVhDA2jSGy/I52QR0VqL1WXxHhBpkGiKplOyrniE2sXUjiMpHULw7lt5t0
 KcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=pAGqEnG2raRkXveZrBOcJyHPFm0QVTMkhlJQFJA6T34=;
 b=KAWx1IJ1wk4kW9pd1iB5AFfw81JcHxapVJqtzAx7jViZEH5CF8Zpe4GiSH18jS70wE
 cMx0oZvQwLlfDwL/PrLTfJhF6654HulBq7svyaQnhoc10iysjt5BprCLiyQjN00WED6Q
 VQXmLuVNK/SNGf44P3Hpe1u3e9Tk34zuDoHKZ2LRY9pTYGukw6wDlM9hH/kVXG+ZIj06
 fY3MI4BF9xtMpAH1xj/87AlWc2HwfTopBBouDdWnckqduOH4M1Jr+heLr2jWXtUj6dG9
 jcVhzd1ISVh+Ix1o5yeGt31DbfentJRErUEVfffH9zjFry5PhqH7nai/fDtU3e26aeaC
 GRUw==
X-Gm-Message-State: AOAM532DbZb3Gvdc17csGBeMMqXZMVcIvF6B433LPgaPrVKj5rm6gcQ3
 /WhhWAcXQlRiygrdCvV1HZBoe9Pj89YsiEM9ag==
X-Google-Smtp-Source: ABdhPJw+e7eRfTOjt8ij1JblVkRTOiDGCo90TudLPv3hs+v+1VcmuHXfi9c5ryQLjBORNvuZhqGkr3+gBULrWSkxcA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f0ed:c8a:dab7:ecc2])
 (user=kaleshsingh job=sendgmr) by 2002:a25:ae1c:0:b0:63d:4d85:acdc with SMTP
 id a28-20020a25ae1c000000b0063d4d85acdcmr15047111ybj.435.1649448355076; Fri,
 08 Apr 2022 13:05:55 -0700 (PDT)
Date: Fri,  8 Apr 2022 13:03:27 -0700
In-Reply-To: <20220408200349.1529080-1-kaleshsingh@google.com>
Message-Id: <20220408200349.1529080-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v7 4/6] KVM: arm64: Add guard pages for pKVM (protected nVHE)
 hypervisor stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, Andrew Walbran <qwandor@google.com>,
 will@kernel.org, maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Nathan Chancellor <nathan@kernel.org>, Changbin Du <changbin.du@intel.com>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com
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
for overflow detection (implemented in a subsequent patch in the series)

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v7:
  - Add Fuad's Reviewed-by and Tested-by tags.

Changes in v6:
  - Update call to pkvm_alloc_private_va_range() (return val and params)

Changes in v5:
  - Use a single allocation for stack and guard pages to ensure they
    are contiguous, per Marc

Changes in v4:
  - Replace IS_ERR_OR_NULL check with IS_ERR check now that
    pkvm_alloc_private_va_range() returns an error for null
    pointer, per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark


 arch/arm64/kvm/hyp/nvhe/setup.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 27af337f9fea..e8d4ea2fcfa0 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -99,17 +99,42 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 		return ret;
 
 	for (i = 0; i < hyp_nr_cpus; i++) {
+		struct kvm_nvhe_init_params *params = per_cpu_ptr(&kvm_init_params, i);
+		unsigned long hyp_addr;
+
 		start = (void *)kern_hyp_va(per_cpu_base[i]);
 		end = start + PAGE_ALIGN(hyp_percpu_size);
 		ret = pkvm_create_mappings(start, end, PAGE_HYP);
 		if (ret)
 			return ret;
 
-		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va;
-		start = end - PAGE_SIZE;
-		ret = pkvm_create_mappings(start, end, PAGE_HYP);
+		/*
+		 * Allocate a contiguous HYP private VA range for the stack
+		 * and guard page. The allocation is also aligned based on
+		 * the order of its size.
+		 */
+		ret = pkvm_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
+		if (ret)
+			return ret;
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
+		hyp_spin_lock(&pkvm_pgd_lock);
+		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, hyp_addr + PAGE_SIZE,
+					PAGE_SIZE, params->stack_pa, PAGE_HYP);
+		hyp_spin_unlock(&pkvm_pgd_lock);
 		if (ret)
 			return ret;
+
+		/* Update stack_hyp_va to end of the stack's private VA range */
+		params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
 	}
 
 	/*
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
