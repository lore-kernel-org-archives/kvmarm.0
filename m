Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3444C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 18:51:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A22FF49F4B;
	Mon,  7 Mar 2022 13:51:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BrGOxzJGtrLf; Mon,  7 Mar 2022 13:51:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AED049F0F;
	Mon,  7 Mar 2022 13:51:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5FA49F0F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:51:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YvBB42dDgmOR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 13:51:54 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C41749EFB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:51:54 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d07ae11462so140150697b3.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 10:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=zd+Pz2hCyohdOr/dxmLz4Gh63tEi7O3x6Rne/mgLJEk=;
 b=YGw1K4bIRd5auwTqZymINsBHkIli4RccZzk4Jm4KA6dGEHBvQ2DZkRbLMuzrXmWA6v
 wJCzEQUUIF+eGpEJ8hv6nwf3Lha6QMIKGx1FK5EEn/ZcEJu0zVQ8bzkc4nj40tDoytCH
 VcGZa0Mjq+KpMF/lKcJV/wTFDar81JQFg+kHt+eu+YW4mWeOrYqrAOBqwQQUei3FQjJR
 J+voN8JFvSSvBwwfv+nH5y0mDzZsARC45NKcXqFzEiQsO4ZB/J6CiEd/epZvdg5l2mV2
 02rHt+WO60nCKAbGjCzA/BCJDOeM5MvBBZvDRQ9mekCrplwHhg/USKkd1U8/hGrNXAkY
 FXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=zd+Pz2hCyohdOr/dxmLz4Gh63tEi7O3x6Rne/mgLJEk=;
 b=bENyETZp+f7fhPgaohy7RHdynmBpUGsu4sp8HA8C8d5bdcsN16ik3RKUH7UdS8IsuD
 NVYZAyL5VxH2mCMo83ntB0PgxD2fP4z2mGQFNupfyp0szc+v7eylJgTNf7dH1v8laB7V
 7Ka7TfoF/MbSSWFC6De9MT/7pBf0x90rBP6no+aBfCwjBXs5tQhhZaxqf0kQ1yArr4qo
 gAgUNnieYJkX/RXh5I/OvjD6aZ1ysVI1K0j4Fao/w50JBIV4V9pTvLiB3db4sS9nii52
 MaAACBX12PinSvOe+vNCPvjxOGRt6QxBE2diVJQPmw1jf0LJy4ZaHkneU9oiHcJtJ3gt
 lJ6Q==
X-Gm-Message-State: AOAM530TQ78KaHeUD0ej65nSsXUysEYklsYOl3OViPbrzgXo2Jow/1lJ
 kVtDLsK8D98uGnehU7fz3SU85W5CYHlG0Z/hRQ==
X-Google-Smtp-Source: ABdhPJwlyi6jAHh/rkaohhtiaZqpeV4EIkMP+HMGa+Uf4dvpDuGYBVdyLkTaivMLbQ5TDo5YhM9lzpuhTr29cWEcnA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dd66:1e7d:1858:4587])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:f0b:0:b0:624:b2f2:cc91 with SMTP
 id x11-20020a5b0f0b000000b00624b2f2cc91mr9033829ybr.324.1646679113524; Mon,
 07 Mar 2022 10:51:53 -0800 (PST)
Date: Mon,  7 Mar 2022 10:49:02 -0800
In-Reply-To: <20220307184935.1704614-1-kaleshsingh@google.com>
Message-Id: <20220307184935.1704614-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v5 4/8] KVM: arm64: Add guard pages for pKVM (protected nVHE)
 hypervisor stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, Stephen Boyd <swboyd@chromium.org>, surenb@google.com,
 Mark Brown <broonie@kernel.org>, Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>
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
index 27af337f9fea..4bec3069b234 100644
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
+		hyp_addr = pkvm_alloc_private_va_range(PAGE_SIZE * 2);
+		if (IS_ERR((void *)hyp_addr))
+			return PTR_ERR((void *)hyp_addr);
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
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
