Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7198EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 21:46:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 163874B1D1;
	Wed, 20 Apr 2022 17:46:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2YxSanTIEzC5; Wed, 20 Apr 2022 17:46:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5EFF49B26;
	Wed, 20 Apr 2022 17:46:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E385B49B26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:45:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F0+mgTNYLLuf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 17:45:58 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C96AB40E62
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:45:58 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d11b6259adso26988667b3.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 14:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=lwg1kG8+1/wNbjGSZ2PbJ4ea1sTg4029wAFJD+g5Qi4=;
 b=MMPu74D6gv8xbJTQoLjt4UXwW+FjK1985Y1rOEoSiYg5gcI/zj6BJ7wbII6XHlcPvT
 59BtqlU6lweX8m7XAawj/sGBvGhUoQEMvEoH66ZzG/M6VpOnudkU8Y4wq1Zazhe8YFeG
 VBU9mzPnHlb1w/OgY5JgQnc6KWd3K7yWmcD2S+RRlARxRVWS1VObFH9mAk/7S3g+3Qsz
 YXIIEl1zXt4sfgfpG3aW5xYWQK63b95pfOWsVjGxqQTDcSjvBn9I7rs+x5x2mcwC3zXD
 Pb2zPc5J59jODCdsDLIkvrDpuJGvOo368pyQKea6bgOY8ieTr7QPh3zxQ3jmVVvSVsku
 YaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=lwg1kG8+1/wNbjGSZ2PbJ4ea1sTg4029wAFJD+g5Qi4=;
 b=fj/zyCB44Eyepwwrgo+Xt01GM1XiogqsSimsRMuXFtzCCFtl2EcQC5/zOv3rfr8f5G
 sx5eah5LjN8uVqpRsSUb+XwjMQs077vvQRmKz8f5vvJGOTRrbWIuI59WVoFeoUi4wsrm
 SscPumMmvlHClVwzTSNPhWvA5wR9O4n7WWd1wbXvG3Bl3TGGtXoUkcTTsYvgUxNVnQHh
 sbTIpzQh4Lr7Vko32RCOQirAuETTqZ+HmlDKEGZgN99L2NrEmVl9sGFf5pL99E7B00/v
 QgA+2Hh0p/0HtspeVuGSBEZ4O2/7+lwmfx607NrdtGnffuJm9lNGBV2tWGx+D5BEbRPt
 xd0g==
X-Gm-Message-State: AOAM533jpGKi4q4LXaQ9JZIdGIzbvUTbYtzmP/4lDSm57gdW6Vp+/5kF
 E+LiZWouclo4T6DVzq55vNAmahhknkmsQSTleg==
X-Google-Smtp-Source: ABdhPJwPvA9EBgeORhcNpGmqtT4iVpoccjQSHhBaKdbuYg64D0FqAMR8uclEjMkHcXhbagt529YZzXT1QLlZO+fSMw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:2a20:cec4:8f41:cd6f])
 (user=kaleshsingh job=sendgmr) by 2002:a81:ff06:0:b0:2e6:d7bc:c812 with SMTP
 id k6-20020a81ff06000000b002e6d7bcc812mr22513276ywn.122.1650491158313; Wed,
 20 Apr 2022 14:45:58 -0700 (PDT)
Date: Wed, 20 Apr 2022 14:42:55 -0700
In-Reply-To: <20220420214317.3303360-1-kaleshsingh@google.com>
Message-Id: <20220420214317.3303360-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220420214317.3303360-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v8 4/6] KVM: arm64: Add guard pages for pKVM (protected nVHE)
 hypervisor stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 kernel-team@android.com, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Changbin Du <changbin.du@intel.com>
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
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
