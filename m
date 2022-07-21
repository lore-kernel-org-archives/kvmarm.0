Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32223C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDA1C4D95B;
	Thu, 21 Jul 2022 01:58:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id we3VqZ9v5boP; Thu, 21 Jul 2022 01:57:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23FE44DA56;
	Thu, 21 Jul 2022 01:57:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A69114D8AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BYiZt4awEckt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:56 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 397614DA60
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:56 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31e89d6bea7so1689867b3.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=u41gNE0FUbf7I3uSk1ZkD04WPUp+bNk6nI13lr3U2+M=;
 b=i1tLJHy55BRGUf2MhpeshQfHaz/P1U4sh5WTYlffK6cPwsShsTLAksunpx9WSWUvs5
 0fBONE5OQ8WLDH14mRl37wS68j0C0oAC6uZ1XsgBylepMqzx7WahUDqDnXxVi+WKAQgk
 AGgIzVBp+61lUYk8JBGfQfLraTDIS5jAl16lRQ4X4qh6yJdvw659R1ORQW0392UXcd0h
 6imC0n6wD6C8G8hOnTkHRmVOn7smO1yJg/wy15kFY1cs8By/B9dxEChbyAn0iA8Wy+pe
 gktmUvnnmFtVre61mdH5Uu3H353FeoBmcg7MXZPAV9ovEHqwu/oerxbpmHYhpA/EMRPc
 Xyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=u41gNE0FUbf7I3uSk1ZkD04WPUp+bNk6nI13lr3U2+M=;
 b=bkWA8bxHdrTmUvTp9t2BhMifvBdB/qseiSnXk31adCPEtVJVUO0ookL2befQ31bXi5
 XqYQQjNnRVP1SK4QQ7hBNLDfvmjyC/9uqhgtKyIoc1E7ytnJQ3fYIAvamA+ElINZrCCD
 CkQN5jPPOUzdl1V6YNyqOdbJ8bWkwfj/7/KZ5LEJI18vSeLKZRUOFtloIfrDv0XZDaPE
 44LH9c8l4UWpXX5cXHiPayJlGW8+QHk8gtBOrBTKp2mKw/eB5Nvk0VBuQwbgNP1T+JJh
 H1UzQedtnIJXtsh1QlNpc6K4y8Jvl+jHsdSkp3U0yTNhCHnkSYetzLjOfaZwggm4bvob
 hx0w==
X-Gm-Message-State: AJIora+v/rN9kKk5wXd0iU1ONds5gmdegPb7DV3GjBbb7XMo+yg8kJJg
 UHsQ2RfhWeYGk1SRFDuSgbp7wqnB7YkSBznIgw==
X-Google-Smtp-Source: AGRyM1uvMhMsMnmREMTDtB8EyA11iiDGNnM5EU/vVjV/cfBEZrOG6zJ3oBHMRQm5wTLQpoQkhzUqzuOm5KQq0n22Og==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a25:a1a9:0:b0:66f:8387:d3e1 with SMTP
 id a38-20020a25a1a9000000b0066f8387d3e1mr37333703ybi.547.1658383075762; Wed,
 20 Jul 2022 22:57:55 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:20 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-10-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 09/17] KVM: arm64: Allocate shared pKVM hyp stacktrace
 buffers
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
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

The minimum size for the buffer required, assuming the min frame
size of [x29, x30] (2 * sizeof(long)), is half the combined size of
the hypervisor and overflow stacks plus an additional entry to
delimit the end of the stacktrace.

The stacktrace buffers are used later in the seried to dump the
nVHE hypervisor stacktrace when using protected-mode.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Fix typo in commit text, per Marc

 arch/arm64/include/asm/memory.h      | 8 ++++++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 0af70d9abede..cab80a9a4086 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -113,6 +113,14 @@
 
 #define OVERFLOW_STACK_SIZE	SZ_4K
 
+/*
+ * With the minimum frame size of [x29, x30], exactly half the combined
+ * sizes of the hyp and overflow stacks is the maximum size needed to
+ * save the unwinded stacktrace; plus an additional entry to delimit the
+ * end.
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
