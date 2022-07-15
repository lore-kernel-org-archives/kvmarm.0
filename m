Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EBAC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A72084BAF7;
	Fri, 15 Jul 2022 02:11:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 83JFrNqQ8Rt5; Fri, 15 Jul 2022 02:11:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC4DC4BC63;
	Fri, 15 Jul 2022 02:11:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D90E24BC82
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D23z--a85rh6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:27 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49F5C4BC48
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:27 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 i9-20020a258b09000000b0066efe437da6so3288241ybl.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=M+jjLcbVfGFpuFyPmYM6em2hR4mF4qVioAr2e7vX+Xw=;
 b=foYSq5L3M94ew4oJheHVCcZ2sd6WTh+axQJQ3f2I0/KjDrbsDlveUQa36a+4dMUW86
 oAr59yWp3/4fthJGLKbeqP3ToV625tQE1/Zl59UnW6ZgwRejfMF2CeiuIgAxnPKEdOua
 Wom/AcDe7Y1Vs7m9B9yUKDv3XbJABdFnmiRFcsEaHQF6hCWr4TvLrSsy0kbhYg0ecJCY
 1BkjPIw0aCv0o/w1YsTK46SYwcGHpjGTLHy7NN08z1pijZldSS4E9d/h1bdT4iLMAAvp
 BIW0nHEuzPtR74D0IBEy/L6c6MHoCmRGrZgKKOBHl0myQ+Dw11PmBzmEKNu6izs3iIbu
 yVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=M+jjLcbVfGFpuFyPmYM6em2hR4mF4qVioAr2e7vX+Xw=;
 b=GqmTrPO0j2WrmuWrSxse4MQBNPbbfYFJW855+FsKP3MYAnJBc4SF/03SmMZNSDdFiT
 7qPcMv1x7Y+rNdDQHqa1gKE+5QqhoirKZ339FNgW7jntLdLcdDlqO9pKH+DJaen8EstA
 YLw8QAzw4CIgiJmCqHSz6iV0wgPDMKqQYdIeQlndWGqMdme+BD11yfD0XfuckFdQSAny
 ME8TMBMkso7vRODM2JofOxWfW8XuCcEycjsm7nvlVb+pwzYbR00xwFykpVJ5Ub/ucxQu
 dN55iyOkdiU7Jl9yqYhDyS6/R7e/v3jYIaN+MwuBx70ebJ5IXIJNo0wrjJJsR/SDkaG8
 QR/Q==
X-Gm-Message-State: AJIora+3Fgn7uWZinrW0uBDVCxvQN1wsDqfg/lVFZG6LGVXMSAMVvIFB
 LEexw+6y9MQx4F9R117KZ3p//4wpxZ4tcJVooQ==
X-Google-Smtp-Source: AGRyM1sHtVrkbrB5cwuR+qVJGCIV5+KLljaGjEU50/j14j8kkUywTaBTDzCv9+0MBKlLC2xgVIaPgUUyPSHW2bJDFQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:508a:0:b0:66e:570b:52da with SMTP
 id e132-20020a25508a000000b0066e570b52damr12381412ybb.464.1657865486862; Thu,
 14 Jul 2022 23:11:26 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:18 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-10-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 09/18] KVM: arm64: Allocate shared pKVM hyp stacktrace
 buffers
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

In protected nVHE mode the host cannot directly access
hypervisor memory, so we will dump the hypervisor stacktrace
to a shared buffer with the host.

The minimum size do the buffer required, assuming the min frame
size of [x29, x30] (2 * sizeof(long)), is half the combined size of
the hypervisor and overflow stacks plus an additional entry to
delimit the end of the stacktrace.

The stacktrace buffers are used later in the seried to dump the
nVHE hypervisor stacktrace when using protected-mode.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/memory.h      | 7 +++++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 0af70d9abede..28a4893d4b84 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -113,6 +113,13 @@
 
 #define OVERFLOW_STACK_SIZE	SZ_4K
 
+/*
+ * With the minimum frame size of [x29, x30], exactly half the combined
+ * sizes of the hyp and overflow stacks is needed to save the unwinded
+ * stacktrace; plus an additional entry to delimit the end.
+ */
+#define NVHE_STACKTRACE_SIZE	((OVERFLOW_STACK_SIZE + PAGE_SIZE) / 2 + sizeof(long))
+
 /*
  * Alignment of kernel segments (e.g. .text, .data).
  *
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index a3d5b34e1249..69e65b457f1c 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -9,3 +9,7 @@
 
 DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 	__aligned(16);
+
+#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
+#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
