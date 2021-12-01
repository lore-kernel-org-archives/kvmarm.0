Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFC7C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 12:04:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16C824B1AA;
	Wed,  1 Dec 2021 07:04:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dgj5xEB2g20T; Wed,  1 Dec 2021 07:04:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EFCC4B21A;
	Wed,  1 Dec 2021 07:04:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4AC84B1F8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 07:04:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cwcG8NooiI5H for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 07:04:48 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83D204B1E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 07:04:48 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 29452B81E6A;
 Wed,  1 Dec 2021 12:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72751C58321;
 Wed,  1 Dec 2021 12:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638360284;
 bh=mGMA0LdI86boJc0KzjqubEoj0yuCdbIywxvtvcR4UZQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=KBVpPhPnx4WCCeo8UdKJkpMJ1uU1UI/jjwkKwL0olZVAxBn0+6pNJ53yZM2TvYzaE
 b1N2LmKsqSNyIG8ODMFs3AK/XTutaWZj/oZ1XSG/bfLDsjWOk1gG3qI96O1VQHpp3v
 dA8goNAYUOlB3z/t3cxvvQWBEbsNhpoeJV+fzeY4szG/6jpFJO5lB7t3WVJiGY+TAR
 pb5cZe2YNKupZRSLyjAEyzuTIG3cll4MT2zSoWlyf75x8aUJbibFmXBLvJpcQb3KtV
 RAljay7YQ0kFwJTJgxL+HQ6e0XllS8jhmoU16JDKfGZEV2QKzM5uSLvK4aGu9Iurmi
 tnY5zg9BBBtZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1msOLq-0097Ab-Jh; Wed, 01 Dec 2021 12:04:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 6/6] arm64/fpsimd: Document the use of TIF_FOREIGN_FPSTATE
 by KVM
Date: Wed,  1 Dec 2021 12:04:36 +0000
Message-Id: <20211201120436.389756-7-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201120436.389756-1-maz@kernel.org>
References: <20211201120436.389756-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com,
 will@kernel.org, broonie@kernel.org, yuzenghui@huawei.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>, broonie@kernel.org
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

The bit of documentation that talks about TIF_FOREIGN_FPSTATE
does not mention the ungodly tricks that KVM plays with this flag.

Try and document this for the posterity.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index fa244c426f61..6fb361e8bed8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -78,7 +78,11 @@
  * indicate whether or not the userland FPSIMD state of the current task is
  * present in the registers. The flag is set unless the FPSIMD registers of this
  * CPU currently contain the most recent userland FPSIMD state of the current
- * task.
+ * task. If the task is behaving as a VMM, then this is will be managed by
+ * KVM which will clear it to indicate that the vcpu FPSIMD state is currently
+ * loaded on the CPU, allowing the state to be saved if a FPSIMD-aware
+ * softirq kicks in. Upon vcpu_put(), KVM will save the vcpu FP state and
+ * flag the register state as invalid.
  *
  * In order to allow softirq handlers to use FPSIMD, kernel_neon_begin() may
  * save the task's FPSIMD context back to task_struct from softirq context.
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
