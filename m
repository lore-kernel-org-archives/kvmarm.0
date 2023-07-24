Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E4A6AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:37 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c83284edf0eso4684755276.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202316; x=1690807116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=psvsYVSFp54YZxDJhUls2ygk6CpJChJRGAPyn8rKvmI=;
        b=MhTEtSAqfxc4+e20GES/Zun/i1kSmyiRXH5mmo/prDGxKaxTLX20kKOdjQ42GRfeca
         bxB0nWrRrXxqCwH88Z3f1D+DPgyptr8OjbxufaPhUyC8KKXmUr/bePsYPXVrNkm4mtdN
         pCXA516IeqYFBCZ1SuSLT+0+sONSOOcdBr4kzPFOy7LGJqjxE6+o0xdrCZjnkY91o+2w
         00QTcGqDZdUWcaw8lzBxRFN9RPCqOXnTXULPFNXNzqPb52b78HtxFeOxdTQWI+Z71FBV
         bGvhla5vv+abfhQU/uPaUseOZ1SdqBZ41perCbZbLk0kMMg1/noGPlNCKVxPhoB3JgE9
         FX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202316; x=1690807116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psvsYVSFp54YZxDJhUls2ygk6CpJChJRGAPyn8rKvmI=;
        b=fFTMq1YmBmuSnkWvmnFBpfMrjmVa5KYw8MsXpVdkVux9K8AliQPRJZ+dRIvV+CBCQG
         ACs2GC2fmj481T5/K0nzFFEt6ZN7lXAeTFGwUA6xI8XCkFpHtQ/mvJzRpZTVdCl/STQW
         KDGYuUc+LLy49XNGsoEJQ58mMbRkURV3rshYF0VQrgqGgZi/9BlXmwhyixDSoKzkbIKr
         z6ISQDbH3FC0skkMhi3McNoOUyJX1SZUYR85x7ziYKLVXSCL6AxD1WeCStq/ItcFR5DC
         5N/tD1Z8zuxFQl3aEksQgSbTX69tT/h1ZugFXa73Cjx2e4VjHP0AVV/5KPFoaxAj9oCV
         mobA==
X-Gm-Message-State: ABy/qLaFt1NGjIsjIWt3p2YWkP/XjcayvUk6q16klFHLjNxYJpbek0Zq
	bQNllzdXhNT4Ti5jBWiZbtc8wdgF9fC9mD7V1CeM3hQvIzog5qD5lVhXXfJ6eWefumOXlt0vEZm
	YMH8sO9zBJVv7vtl2/8BJKFQ1Yj4x34n4nHzEhkTUCeuffxdWZYx5aPR3sI4=
X-Google-Smtp-Source: APBJJlEa6jgM1XvkjeuEG+qoqMTACGx/rBuBeQclJMjtOmiDQ6ZetrI06SLPXpbKulHujvpyIMzIdTcf5Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:3354:0:b0:d0f:bcfe:bc74 with SMTP id
 z81-20020a253354000000b00d0fbcfebc74mr19419ybz.9.1690202316205; Mon, 24 Jul
 2023 05:38:36 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:23 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-3-tabba@google.com>
Subject: [PATCH v3 1/7] KVM: arm64: Factor out code for checking (h)VHE mode
 into a macro
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The code for checking whether the kernel is in (h)VHE mode is
repeated, and will be needed again in future patches. Factor it
out in a macro.

No functional change intended.
No change in emitted assembly code intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 8e5ffb58f83e..16d3bafa715d 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -31,6 +31,13 @@
 .Lskip_hcrx_\@:
 .endm
 
+/* Check if running in host at EL2 mode, i.e., (h)VHE. Jump to fail if not. */
+.macro __check_hvhe fail, tmp
+	mrs	\tmp, hcr_el2
+	and	\tmp, \tmp, #HCR_E2H
+	cbz	\tmp, \fail
+.endm
+
 /*
  * Allow Non-secure EL1 and EL0 to access physical timer and counter.
  * This is not necessary for VHE, since the host kernel runs in EL2,
@@ -43,9 +50,7 @@
  */
 .macro __init_el2_timers
 	mov	x0, #3				// Enable EL1 physical timers
-	mrs	x1, hcr_el2
-	and	x1, x1, #HCR_E2H
-	cbz	x1, .LnVHE_\@
+	__check_hvhe .LnVHE_\@, x1
 	lsl	x0, x0, #10
 .LnVHE_\@:
 	msr	cnthctl_el2, x0
@@ -139,9 +144,7 @@
 
 /* Coprocessor traps */
 .macro __init_el2_cptr
-	mrs	x1, hcr_el2
-	and	x1, x1, #HCR_E2H
-	cbz	x1, .LnVHE_\@
+	__check_hvhe .LnVHE_\@, x1
 	mov	x0, #(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
 	b	.Lset_cptr_\@
 .LnVHE_\@:
@@ -269,9 +272,7 @@
 
 .Linit_sve_\@:	/* SVE register access */
 	mrs	x0, cptr_el2			// Disable SVE traps
-	mrs	x1, hcr_el2
-	and	x1, x1, #HCR_E2H
-	cbz	x1, .Lcptr_nvhe_\@
+	__check_hvhe .Lcptr_nvhe_\@, x1
 
 	// VHE case
 	orr	x0, x0, #(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
-- 
2.41.0.487.g6d72f3e995-goog

