Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0264EC38A29
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB0DE20644
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFMFUepT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB0DE20644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C1C4B26F;
	Tue, 14 Apr 2020 17:31:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jEqRW7vEBmLc; Tue, 14 Apr 2020 17:31:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4911F4B1D8;
	Tue, 14 Apr 2020 17:31:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 754FD4B23B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uz4hNFS6RfAv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 17:31:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EA0D4B231
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:44 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BDBBC2076B;
 Tue, 14 Apr 2020 21:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586899903;
 bh=+4zzU2fuJ9s9+cU9NhMA4XEGvV70Ry3qcTYCVF/73gw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PFMFUepTALEYUPqJXI/PzspEAX4Pv39fFv/FXh0r88qaYB0hLf1esUplItP5A4JOw
 4EezN0pOI2paWuXZj7UuomuNpYnE5R0311Na6W8nQfCz4E+2zs2RmutkgKwRMDQjDP
 rM1Et8rMdPVTGoY3YFsP/xzC3b3vBAVNRmOxQHmA=
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 8/8] arm64: cpufeature: Add an overview comment for the
 cpufeature framework
Date: Tue, 14 Apr 2020 22:31:14 +0100
Message-Id: <20200414213114.2378-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414213114.2378-1-will@kernel.org>
References: <20200414213114.2378-1-will@kernel.org>
MIME-Version: 1.0
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
 kernel-team@android.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Now that Suzuki isn't within throwing distance, I thought I'd better add
a rough overview comment to cpufeature.c so that it doesn't take me days
to remember how it works next time.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 680a453ca8c4..421ca99dc8fc 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3,6 +3,49 @@
  * Contains CPU feature definitions
  *
  * Copyright (C) 2015 ARM Ltd.
+ *
+ * A note for the weary kernel hacker: the code here is confusing and hard to
+ * follow! That's partly because it's solving a nasty problem, but also because
+ * there's a little bit of over-abstraction that tends to obscure what's going
+ * on behind a maze of helper functions and macros.
+ *
+ * The basic problem is that hardware folks have started gluing together CPUs
+ * with distinct architectural features; in some cases even creating SoCs where
+ * user-visible instructions are available only on a subset of the available
+ * cores. We try to address this by snapshotting the feature registers of the
+ * boot CPU and comparing these with the feature registers of each secondary
+ * CPU when bringing them up. If there is a mismatch, then we update the
+ * snapshot state to indicate the lowest-common denominator of the feature,
+ * known as the "safe" value. This snapshot state can be queried to view the
+ * "sanitised" value of a feature register.
+ *
+ * The sanitised register values are used to decide which capabilities we
+ * have in the system. These may be in the form of traditional "hwcaps"
+ * advertised to userspace or internal "cpucaps" which are used to configure
+ * things like alternative patching and static keys. While a feature mismatch
+ * may result in a TAINT_CPU_OUT_OF_SPEC kernel taint, a capability mismatch
+ * may prevent a CPU from being onlined at all.
+ *
+ * Some implementation details worth remembering:
+ *
+ * - Mismatched features are *always* sanitised to a "safe" value, which
+ *   usually indicates that the feature is not supported.
+ *
+ * - A mismatched feature marked with FTR_STRICT will cause a "SANITY CHECK"
+ *   warning when onlining an offending CPU and the kernel will be tainted
+ *   with TAINT_CPU_OUT_OF_SPEC.
+ *
+ * - Features marked as FTR_VISIBLE have their sanitised value visible to
+ *   userspace. FTR_VISIBLE features in registers that are only visible
+ *   to EL0 by trapping *must* have a corresponding HWCAP so that late
+ *   onlining of CPUs cannot lead to features disappearing at runtime.
+ *
+ * - A "feature" is typically a 4-bit register field. A "capability" is the
+ *   high-level description derived from the sanitised field value.
+ *
+ * - Read the Arm ARM (DDI 0487F.a) section D13.1.3 ("Principles of the ID
+ *   scheme for fields in ID registers") to understand when feature fields
+ *   may be signed or unsigned (FTR_SIGNED and FTR_UNSIGNED accordingly).
  */
 
 #define pr_fmt(fmt) "CPU features: " fmt
-- 
2.26.0.110.g2183baf09c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
