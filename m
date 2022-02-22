Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24D4C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8924C460;
	Wed, 23 Feb 2022 06:02:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gG06irW9yFN6; Wed, 23 Feb 2022 06:02:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9344C496;
	Wed, 23 Feb 2022 06:02:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADCB149B0C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:57:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cgj8a73oTYST for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 11:57:11 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ED4E404B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:57:11 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 k10-20020a056902070a00b0062469b00335so9000490ybt.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=knnzmuohJ2ih2y2NTiUEzUxj92qYLV4FmoYUekHSvUw=;
 b=tazhhxtdUk3rQttzgDm+V0n+dY4v2ZnB4i8xG8ax2HZdSoHAffJo42UTzU3IHvzAqj
 CzDDQtHudJDmOpjvt+NTOxsHiMMcd5AR1KeV4KZ04Anj9Hvg2wo5WdkKx0uhJOAuX1UG
 DMG5h+1UR544FLvyjxNA1/VvkZavi0pxiwKfoHP3qdoBAJ8849pS8kTNoGD5QX5f9/Px
 48yknJpXBRw8xvBSwtZigYe1MGyv8eQBBWwjuMT8BSujAmFufVqRsnYE2LCmZqywZs8i
 wJddWj0UZSrpFMMQpEijc1j/Xch9CqJ1J2YUynBS8lvvuY7OGu4etP9u4qE8wqmUHhIw
 yLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=knnzmuohJ2ih2y2NTiUEzUxj92qYLV4FmoYUekHSvUw=;
 b=pjN8aGg8m0PaIdODXEb5VvdzF5OMSSv/AqiMdf87ZFtYYndyLRFofHbXHyJ607UsO1
 M1W5BHhxjoq4SxNldMGBJvkC2inLBSD9r3Mw3lNkUcUIVr1AYtF9+5ygEFnCVscK822c
 WP/rej4Mj/6EEbvLiHu+Yh5YAmNwizAWvVao/Qe/fKe7TbabBBUr6tNKgN5VZVZrB9F5
 TEh7ZbWEXjeYvTSZ87Hkl6fJ2LbJASoLgPQa+Z4gqHg+h7/YOFxBIzcuzH41F0PwBYEW
 DSxnuS5zIvfZ0/qeJbcMX2ujEXv/Ls6vhQmmSJionX1Uv9BSR5qHrgIMjh29/F2IW7ru
 1fTg==
X-Gm-Message-State: AOAM532xPIzLidkEzeLNcLTsU/HkyaB0KCBSQhQ/Ay1BBtOTYxY0qxuB
 TcFkXVW2jChkHdn/DSO5ebx4s3RgvT3duI2syw==
X-Google-Smtp-Source: ABdhPJxsM9h50TZI3B0JLyBOhiXv0umcrv6dsBugtZNBeZtlKN8O9HTo3L2ie+qpRSFxA92HD2CPBV8kKYkIX9PJAQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a25:4cc1:0:b0:623:ca02:c1e5 with SMTP
 id z184-20020a254cc1000000b00623ca02c1e5mr22952503yba.95.1645549030879; Tue,
 22 Feb 2022 08:57:10 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:05 -0800
In-Reply-To: <20220222165212.2005066-1-kaleshsingh@google.com>
Message-Id: <20220222165212.2005066-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 4/9] KVM: arm64: Add guard pages for pKVM (protected nVHE)
 hypervisor stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Kalesh Singh <kaleshsingh@google.com>,
 surenb@google.com, linux-arm-kernel@lists.infradead.org
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
 arch/arm64/kvm/hyp/nvhe/setup.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 27af337f9fea..69df21320b09 100644
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
+			return PTR_ERR(start);
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
+			return PTR_ERR(start);
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
