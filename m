Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C94C4741F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80907221EB
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1rJ6cnNW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80907221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FC94B4F0;
	Fri, 30 Oct 2020 12:40:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HF5uB51AASb7; Fri, 30 Oct 2020 12:40:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F654B5B5;
	Fri, 30 Oct 2020 12:40:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE204B54C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 69Xu+3B5xS4R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:40:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC3EF4B35A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BF6E120724;
 Fri, 30 Oct 2020 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076031;
 bh=OoL8wFiBGkmFWNmwb8QRh22k0yf0eXlE0e1LfiW3ud4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1rJ6cnNW7TMucvL6kaHJNUY5p661XpKIV1uZBiZJ5gfG9fBerUySQkzNJ2OGfjR5C
 +CXG+Y7Ji3g93Gd+zIST+z+W6iq/I7OmKXYPDubY3WZNKsp4+06JWmTKG3cQBnVkMQ
 jhl1MxZWv3cfsQDott+cyBzfmVRHrcAsQBwsf8tg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXS1-005noK-0n; Fri, 30 Oct 2020 16:40:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 09/12] KVM: arm64: Factor out is_{vhe,nvhe}_hyp_code()
Date: Fri, 30 Oct 2020 16:40:14 +0000
Message-Id: <20201030164017.244287-10-maz@kernel.org>
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

Currently has_vhe() detects whether it is being compiled for VHE/NVHE
hyp code based on preprocessor definitions, and uses this knowledge to
avoid redundant runtime checks.

There are other cases where we'd like to use this knowledge, so let's
factor the preprocessor checks out into separate helpers.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201026134931.28246-2-mark.rutland@arm.com
---
 arch/arm64/include/asm/virt.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 09977acc007d..300be14ba77b 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -83,16 +83,27 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
+static __always_inline bool is_vhe_hyp_code(void)
+{
+	/* Only defined for code run in VHE hyp context */
+	return __is_defined(__KVM_VHE_HYPERVISOR__);
+}
+
+static __always_inline bool is_nvhe_hyp_code(void)
+{
+	/* Only defined for code run in NVHE hyp context */
+	return __is_defined(__KVM_NVHE_HYPERVISOR__);
+}
+
 static __always_inline bool has_vhe(void)
 {
 	/*
-	 * The following macros are defined for code specic to VHE/nVHE.
-	 * If has_vhe() is inlined into those compilation units, it can
-	 * be determined statically. Otherwise fall back to caps.
+	 * Code only run in VHE/NVHE hyp context can assume VHE is present or
+	 * absent. Otherwise fall back to caps.
 	 */
-	if (__is_defined(__KVM_VHE_HYPERVISOR__))
+	if (is_vhe_hyp_code())
 		return true;
-	else if (__is_defined(__KVM_NVHE_HYPERVISOR__))
+	else if (is_nvhe_hyp_code())
 		return false;
 	else
 		return cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN);
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
