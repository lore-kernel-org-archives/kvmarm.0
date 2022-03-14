Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00F0C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 20:04:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4432A404CD;
	Mon, 14 Mar 2022 16:04:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vSQ8cIce2ds4; Mon, 14 Mar 2022 16:04:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 031A149EB2;
	Mon, 14 Mar 2022 16:04:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E09A5404CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:04:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F7H9AuPHtBbc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 16:04:33 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8A2249EB2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:04:33 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 o70-20020a25d749000000b006291c691122so14822942ybg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 13:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=wcrKUjLTdB/HMJdpeOMPENhm20Kul5UdkQa5+z1O4C4=;
 b=ly66flbISMQbhQBRlyU0Ey6SFlvMFzMx+MCgdnpmKL7gbVZVnWJLeZ+eBkxab3u2uQ
 /BAPbfsTDdal7NC9tiorOpcTnS1SPCwqZUI5C63IE+zdaccPQGfmYSxoacTwGxFep/2p
 sYVB6HiHODgLOoNDiEG83gzblrNaMgs4O6zNyjkLeAiPKK3DV/bg6YbvMdHsVKlKv7KY
 550C2M5Wqi0qqi2+Rf5QnAcPMwneFdc65JXbl6PhmeS78GfP9FQWcDKMbAEnn8H1+9ZJ
 SCEW87y7rwuaOAGH1aDA7RKYVL+X6hcCfbwXAskLXQyF15WTxFS95qoyIpo7yUBKpcK4
 iU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=wcrKUjLTdB/HMJdpeOMPENhm20Kul5UdkQa5+z1O4C4=;
 b=Jp9nS+ECv6kV3mYqxWS19mFSqRSsUQKDS9HuskygD/GvWyiu8s+u8BcoQ32fZGy/8C
 zw+vWI0l69FgnpnjNbMBjIqFpPpkcRYOjEt1gHdfA5TQJ6wv2taidEzmYOc/QBQ5rFuK
 ZaeO+hZIIATpGeqnuVTn1uPUdg1ZGDyh2soK+Q1iqNQ6G2M8fd0ju+I25+wGwGUTbwl2
 ONXa4WJNadWURuqmgtiIYfp5C9wgQipOldv6sROMs9Vu03H9WwFcXDMllHQdtuetgAMP
 DANXNGEmxmPtmUqQQzUVs3jadhmctBP3qpwYjtHRMp00Lf5cx/FHUR0RMNjgNrDCUCJq
 yZ8A==
X-Gm-Message-State: AOAM532Gw7CR51Korz9/u7hpKlaVlkoJohFOI1KO7B+bUjBGP6s8s9U5
 d8PFwGzqZjUDOXy4GEfTb9EMfpzdeHRFt3u4rA==
X-Google-Smtp-Source: ABdhPJzCQjLXyp0zrSq0fPr0qCvgIfWkpLUI1kq/oOWycXP2KR703/KzwXb0OI2paMiDufMo2S2nH7jF9T3m4zbQpw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:500a:9ac2:e73e:69e3])
 (user=kaleshsingh job=sendgmr) by 2002:a81:9c4c:0:b0:2dc:ba4:4ee with SMTP id
 n12-20020a819c4c000000b002dc0ba404eemr20662044ywa.248.1647288273266; Mon, 14
 Mar 2022 13:04:33 -0700 (PDT)
Date: Mon, 14 Mar 2022 13:01:13 -0700
In-Reply-To: <20220314200148.2695206-1-kaleshsingh@google.com>
Message-Id: <20220314200148.2695206-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 4/8] KVM: arm64: Add guard pages for pKVM (protected nVHE)
 hypervisor stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 surenb@google.com
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
---

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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
