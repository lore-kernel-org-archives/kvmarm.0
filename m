Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363CA53BA
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:34 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-577323ba3d5so89497287b3.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202314; x=1690807114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=psvsYVSFp54YZxDJhUls2ygk6CpJChJRGAPyn8rKvmI=;
        b=ujGBcvf2MauSmQzO2bzT+4DCNU3irP1u2BaUZPTr/8Iert63Ea2nu5OmZXhjPwA4yZ
         h9BPTeHwuztVBslW3vuf1wQF8PdLzZf5UMs3umrCFsSMzVW+UBCvNhwFb0hjIcjDUzSO
         J/6W16VJUUUC/oBHPHVV+t+ls8ymJ3d4hO2e5GrbimQG9YbcejU8LQaolxF0Om6BbnE9
         tQlhF3fgiBEKBb6VcOwjxjuSIb3uvQhqEO2UYrf79CQO4oNPtZmylchd9cHMkSIK8kJs
         OjlLSmkJZxkx2WMeAo7Jmj1G+VOnvw7Pzi/ke7AZIZ1LEHdA3xXsj4jop0Ii9wF2lQCC
         5fUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202314; x=1690807114;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psvsYVSFp54YZxDJhUls2ygk6CpJChJRGAPyn8rKvmI=;
        b=GSCu7VWqH/bwUHo9NSydLZNjVhPN60F3u+qLiP+nzozI4GfOn5cVZ3oIG4bD7ayXI6
         ndXz91btOrwdGeE01zmrLLs5zTmxNS6BpNKSASBnrO8XYKJ7mb1iHxnBLMCfwdFvi+di
         c3dRChhzD9Zr4sGYVL/5EEPnnDjAqY9Lq1ogy42oRCNT7/hj1IxzGpQZqxfj5LsMGfYC
         FfsPRITxmMRnfpb2PfCnFbiWFKuKWmvhupzUF4/G6deBiPRsQi9mljXFlCcj/QtfszWh
         yul/6TAGxZ1+1WdHM7eTrKQgrI06Xizju0+hkasNgHOWjjIukkoiW/fpYuaOnOnrYjZU
         rnFQ==
X-Gm-Message-State: ABy/qLa6ZMjBqUJHE4kyJSy7VulPPk+spc8KroXxRKfvHqWkm8mHEUKv
	jE8gn2gX85BCVdqiHhi/Zk1pt8wzIOVCN9EqjRAp5zGld/+rQCsIjxHKAViKRprDdSZJkbnQuZd
	l9hnoRrgDo7oXhERmmUUdYNq/JjAWbvfkaqpRQVEQxsc13wGBe8EQvTjaMgE=
X-Google-Smtp-Source: APBJJlEK+qTJJtKp58a1/gru/G3QS3SEpo6HXhkIYJJ/O+5K9gkfdGNaQrhgQyi530MhOxpqq8L5pyB/8w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:c9c3:0:b0:d00:f564:509b with SMTP id
 z186-20020a25c9c3000000b00d00f564509bmr106888ybf.1.1690202313776; Mon, 24 Jul
 2023 05:38:33 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:22 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-2-tabba@google.com>
Subject: [PATCH v3 1/7] KVM: arm64: Factor out code for checking E2H into a macro
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

