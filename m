Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB613C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 869704C002;
	Thu, 24 Feb 2022 05:36:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jQR-rLePmi90; Thu, 24 Feb 2022 05:36:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6634C042;
	Thu, 24 Feb 2022 05:36:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9174BE54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:19:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uuphRWrexi2T for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:19:18 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B6344BE36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:19:18 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 s11-20020a255e0b000000b0062277953037so872285ybb.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=Sc96glvxYslSfkQXo+KXiEGMpwz7KGQFqK1SBX4eD7A=;
 b=B8lXlAgDd0kVzKodKmL9JcM1dcJSITQumRTkFniujZawZDAhk4wZn+DpIQLhUYO/ch
 /iD4fAJgbvRXUaHirgctgj7pLUQblkrrsAEJMibl5VJvqZTLUgl49dAk/yK8WdVz6O83
 u40dS8aCwVHlq3RLEMzMPcZbJLQzQK8GbGi9dh9cBMwbfhbfitEzE3/zjkDAaPEfZ/kf
 tG4sTtq9tpZQfTqmU+TA7/OqoQH7nrxa151lCTPVRM1WDtWmB9kRigE239E2/Tc9/Jqz
 41uBcTKbyjiUJdTcleBYvwYHxaKNIGvnY6iTRF8DBO069ux3kEvruXCti9dxa2D7yM4V
 im7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=Sc96glvxYslSfkQXo+KXiEGMpwz7KGQFqK1SBX4eD7A=;
 b=QfeS6PpGBZououwK7xNDLNTwlQBH0bvdVrM3E+UBobbGj1YG31oEpYvFtU+sYTX74k
 upZKaXnlV1Q2rv+Y0HwjMnFuDuLQHbMdffi/Y4+ZMlvpfexcZVy2Ni7F4twa2E7OZHYV
 PTb1SEZhoIvkezBy9RyHwi9CnUe9kBK/g/CMxDuolhb13Gy3JKWQxiuGz+KeEqkoEebV
 MiQdgtf7cmuGmRzHK0GdtEMngK+M3OrnunQnWZvvYjidbRTBogECJeFSRrvLYvD181zA
 bfyIb0M8AOgJbwBaADFN9JoxAIEZQS1TevVdAIK1rwI9/g/2wCDzypKozDYD2Iu+zYQb
 tNaw==
X-Gm-Message-State: AOAM533hvPovZZpia1p/lHcIuH+GnOra/e+sZQZuDJY85aNysEsqasjO
 eMjeIdoLD1rA9V4it4Q9tMbhaow2sNvKtLJ8/g==
X-Google-Smtp-Source: ABdhPJzBUzrWz/IzDAYDQ8eab8JhoYZDYi700gxVQBn86Vj1XDP4YQZMrJTSKaYcX0VoNCNeGZXoRp+1Cxz/wmOKKw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d449:0:b0:619:c1f1:928b with SMTP
 id m70-20020a25d449000000b00619c1f1928bmr968656ybf.19.1645679957716; Wed, 23
 Feb 2022 21:19:17 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:39 -0800
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
Message-Id: <20220224051439.640768-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 4/8] KVM: arm64: Add guard pages for pKVM (protected nVHE)
 hypervisor stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Thu, 24 Feb 2022 05:36:21 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Kalesh Singh <kaleshsingh@google.com>, surenb@google.com,
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

Maps the stack pages in the flexible private VA range and allocates
guard pages below the stack as unbacked VA space. The stack is aligned
to twice its size to aid overflow detection (implemented in a subsequent
patch in the series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

 arch/arm64/kvm/hyp/nvhe/setup.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 27af337f9fea..5f3a4002f9c5 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -105,11 +105,28 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 		if (ret)
 			return ret;
 
-		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va;
+		/*
+		 * Private mappings are allocated upwards from __io_map_base
+		 * so allocate the guard page first then the stack.
+		 */
+		start = (void *)pkvm_alloc_private_va_range(PAGE_SIZE, PAGE_SIZE);
+		if (IS_ERR_OR_NULL(start))
+			return start ? PTR_ERR(start) : -ENOMEM;
+
+		/*
+		 * The stack is aligned to twice its size to facilitate overflow
+		 * detection.
+		 */
+		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_pa;
 		start = end - PAGE_SIZE;
-		ret = pkvm_create_mappings(start, end, PAGE_HYP);
-		if (ret)
-			return ret;
+		start = (void *)__pkvm_create_private_mapping((phys_addr_t)start,
+					PAGE_SIZE, PAGE_SIZE * 2, PAGE_HYP);
+		if (IS_ERR_OR_NULL(start))
+			return start ? PTR_ERR(start) : -ENOMEM;
+		end = start + PAGE_SIZE;
+
+		/* Update stack_hyp_va to end of the stack's private VA range */
+		per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va = (unsigned long) end;
 	}
 
 	/*
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
