Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37084C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 09:28:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C918249F4B;
	Fri, 11 Feb 2022 04:28:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qKPUqQAnG3vm; Fri, 11 Feb 2022 04:28:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9445749F5A;
	Fri, 11 Feb 2022 04:28:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47FD749F53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:43:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RpJyaq+Z6Anv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 17:43:25 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A35949F4B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:43:25 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 b187-20020a251bc4000000b0061e15c5024fso14888356ybb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=2CtdKKtWqmoQwaNtCKVnEnSlCVes5hG5Of9ZJoRSPvY=;
 b=nf4mRr3ZycGHhBqUZ+8DH8ok/Qz5Vau89sI8kQL6TBzahsS+36PcxWkEHapQEi57zC
 CGZbN1pSxbTcmxo4AB+1siE6sFbVo2nb0UNYy50fVpf34U/KaE2hkYTprUDL4Nb7cEx7
 eOnLgbr0qMZnT6YgUCkRnP6o+xccxEE8H2B8bDpfPqwt3rT5owKtKDyzxlxoreRzy07y
 MzXYO5kYEYUKhF9/9jypyALGVa3urJxqTXcX0FAUfDebx61o/y7NyiNP7UOwQhkI7CzS
 luqBAqd7jIqdj7/5zwZd4zwMLB9kJDCIHLmkKLXY+xR7ATa7MbmSjWRxP0IbgVTg4WA9
 yOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=2CtdKKtWqmoQwaNtCKVnEnSlCVes5hG5Of9ZJoRSPvY=;
 b=Y9KGKeRrJRfzjEU1Pav1vkagm28I1tLtxm3d1qvCNUWZ+8mhu3yo9Drl/pAtbr3h03
 rmvWf9Mr8rQaz1gfpOSLXT5kOHc4yuzhh6IReYZUpXJDYS6FlYE4RnZS+FEKjKIIOrvp
 k9uso5Am77yWcZDOrPpv9TqvAD60JUHMgWX3Lj87G89xdHxd+PqeBi4SYT1GC4uDFSoi
 5kpeRh3Pnyk0RI2R6mI0tvDMD4XNcX/X+UljOfH3MsRGn3xbGrPfJzRq6aQRBfDfCbHk
 zVG99aVRKm29OVCeSchlME+fvUbS6IexfLL46G+4h4RPZxQtpBwZeALUPLet3y+IZZBC
 rJsQ==
X-Gm-Message-State: AOAM530Dw84pRninMY19qKkGDOmk80dhH3plIagJ+jfpWI3LUoXH2fmU
 Rqv7WpIde/az/+fKeSX7iqMUrOhjjX0GIAZjpg==
X-Google-Smtp-Source: ABdhPJwyMEA3/vPtnC5hrjc0C911vwYkTGYEzvGOgFv+0i9iJplYrKuXB9UfmBJoHZPA2fyRMmEXZHP0MgIOdqb77g==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:8f02:232:ad86:2ab2])
 (user=kaleshsingh job=sendgmr) by 2002:a81:60c3:: with SMTP id
 u186mr9342666ywb.26.1644533004795; Thu, 10 Feb 2022 14:43:24 -0800 (PST)
Date: Thu, 10 Feb 2022 14:41:42 -0800
In-Reply-To: <20220210224220.4076151-1-kaleshsingh@google.com>
Message-Id: <20220210224220.4076151-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220210224220.4076151-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH 1/7] KVM: arm64: Map the stack pages in the 'private' range
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 11 Feb 2022 04:28:10 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, surenb@google.com,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

From: Quentin Perret <qperret@google.com>

In preparation for introducing guard pages for the stacks, map them
in the 'private' range of the EL2 VA space in which the VA to PA
relation is flexible when running in protected mode.

Signed-off-by: Quentin Perret <qperret@google.com>
[Kalesh - Refactor, add comments, resolve conflicts,
          use  __pkvm_create_private_mapping()]
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 27af337f9fea..99e178cf4249 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -105,11 +105,19 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 		if (ret)
 			return ret;
 
-		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va;
+		/* Map stack pages in the 'private' VA range */
+		end = (void *)__hyp_pa(per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va);
 		start = end - PAGE_SIZE;
-		ret = pkvm_create_mappings(start, end, PAGE_HYP);
-		if (ret)
-			return ret;
+		start = (void *)__pkvm_create_private_mapping((phys_addr_t)start,
+					PAGE_SIZE, PAGE_HYP);
+		if (IS_ERR_OR_NULL(start))
+			return PTR_ERR(start);
+		end = start + PAGE_SIZE;
+		/*
+		 * Update stack_hyp_va to the end of the stack page's
+		 * allocated 'private' VA range.
+		 */
+		per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va = (unsigned long) end;
 	}
 
 	/*
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
