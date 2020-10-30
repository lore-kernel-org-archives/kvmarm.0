Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97637C4741F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:55:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F132020739
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:55:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHB3Qqh3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F132020739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BAB4B2E6;
	Fri, 30 Oct 2020 12:55:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d+26TnsS02yN; Fri, 30 Oct 2020 12:55:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 627064B337;
	Fri, 30 Oct 2020 12:55:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F264B28E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:55:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a8Bkvno6sQWn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:55:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F2A14B301
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:55:31 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3808420756;
 Fri, 30 Oct 2020 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076930;
 bh=exFtqjukX2VCvc8Zm33L4Y5eBjgmOnSnxmfGVDjdUQo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kHB3Qqh35wiuxkxZOouLIN/+Ds3Ypy3GPpDXyit0fTlOmJXA+DNUYEtg/FOoj2nfF
 iRnnqzIM/xNzZdSIcNnMDnrU2tUELVw0JbfVsFtf3LhjGXfv4kjJvkwKSXRjbSfJag
 E8C0K3rO4WDqnf/CnkXLbWxDZyW/XaDb1pE/cWAU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXS2-005noK-NH; Fri, 30 Oct 2020 16:40:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 10/12] arm64: cpufeature: reorder cpus_have_{const,
 final}_cap()
Date: Fri, 30 Oct 2020 16:40:15 +0000
Message-Id: <20201030164017.244287-11-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com,
 james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com,
 qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com,
 will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 Qais Yousef <qais.yousef@arm.com>
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

From: Mark Rutland <mark.rutland@arm.com>

In a subsequent patch we'll modify cpus_have_const_cap() to call
cpus_have_final_cap(), and hence we need to define cpus_have_final_cap()
first.

To make subsequent changes easier to follow, this patch reorders the two
without making any other changes.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201026134931.28246-3-mark.rutland@arm.com
---
 arch/arm64/include/asm/cpufeature.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index fba6700b457b..9f671aa0419b 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -428,35 +428,35 @@ static __always_inline bool __cpus_have_const_cap(int num)
 }
 
 /*
- * Test for a capability, possibly with a runtime check.
+ * Test for a capability without a runtime check.
  *
- * Before capabilities are finalized, this behaves as cpus_have_cap().
+ * Before capabilities are finalized, this will BUG().
  * After capabilities are finalized, this is patched to avoid a runtime check.
  *
  * @num must be a compile-time constant.
  */
-static __always_inline bool cpus_have_const_cap(int num)
+static __always_inline bool cpus_have_final_cap(int num)
 {
 	if (system_capabilities_finalized())
 		return __cpus_have_const_cap(num);
 	else
-		return cpus_have_cap(num);
+		BUG();
 }
 
 /*
- * Test for a capability without a runtime check.
+ * Test for a capability, possibly with a runtime check.
  *
- * Before capabilities are finalized, this will BUG().
+ * Before capabilities are finalized, this behaves as cpus_have_cap().
  * After capabilities are finalized, this is patched to avoid a runtime check.
  *
  * @num must be a compile-time constant.
  */
-static __always_inline bool cpus_have_final_cap(int num)
+static __always_inline bool cpus_have_const_cap(int num)
 {
 	if (system_capabilities_finalized())
 		return __cpus_have_const_cap(num);
 	else
-		BUG();
+		return cpus_have_cap(num);
 }
 
 static inline void cpus_set_cap(unsigned int num)
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
