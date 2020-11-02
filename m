Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03C2C4742C
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 16:41:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22FF6223AB
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 16:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RK3T0X4y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22FF6223AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6932C4B470;
	Mon,  2 Nov 2020 11:41:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2ECDqdmfz-V6; Mon,  2 Nov 2020 11:41:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B109F4B415;
	Mon,  2 Nov 2020 11:41:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 581054B3FE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 11:41:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QzBST-RcKMT8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 11:41:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5991A4B3B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 11:41:07 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5229A222BA;
 Mon,  2 Nov 2020 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604335266;
 bh=LbFIUMvh/XxufxroOMxcM/bchWyuyq7+XF1PJEMLgS8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RK3T0X4yVX6/eJyxwqJSid6WzMcZDAf3cmXcoKfJPi6NgeLJym0ciXpl2GqYmzX13
 frNKnTaiQu0EXja4bCZhUFXouIxZYLFGzNE4hzxFfHgRpS8A16fmbD3WV0vp95Kj32
 W9lTB8xqYXH+fIFxQH4BDAkqUSoG2b6/7QNcUVfY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZctE-006jJf-IK; Mon, 02 Nov 2020 16:41:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 01/11] KVM: arm64: Don't adjust PC on SError during SMC trap
Date: Mon,  2 Nov 2020 16:40:35 +0000
Message-Id: <20201102164045.264512-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164045.264512-1-maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com,
 will@kernel.org, mark.rutland@arm.com, qperret@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

On SMC trap, the prefered return address is set to that of the SMC
instruction itself. It is thus wrong to try and roll it back when
an SError occurs while trapping on SMC. It is still necessary on
HVC though, as HVC doesn't cause a trap, and sets ELR to returning
*after* the HVC.

It also became apparent that there is no 16bit encoding for an AArch32
HVC instruction, meaning that the displacement is always 4 bytes,
no matter what the ISA is. Take this opportunity to simplify it.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5d690d60ccad..79a720657c47 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -245,15 +245,15 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		u8 esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
 
 		/*
-		 * HVC/SMC already have an adjusted PC, which we need
-		 * to correct in order to return to after having
-		 * injected the SError.
+		 * HVC already have an adjusted PC, which we need to
+		 * correct in order to return to after having injected
+		 * the SError.
+		 *
+		 * SMC, on the other hand, is *trapped*, meaning its
+		 * preferred return address is the SMC itself.
 		 */
-		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64 ||
-		    esr_ec == ESR_ELx_EC_SMC32 || esr_ec == ESR_ELx_EC_SMC64) {
-			u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
-			*vcpu_pc(vcpu) -= adj;
-		}
+		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
+			*vcpu_pc(vcpu) -= 4;
 
 		return 1;
 	}
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
