Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582EEC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 08:07:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11D40208DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 08:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXVeq1uz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11D40208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6214B0C2;
	Mon, 22 Jun 2020 04:07:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4fK5Xw3Oo5rz; Mon, 22 Jun 2020 04:07:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2334B0D9;
	Mon, 22 Jun 2020 04:06:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7E294B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 04:06:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x8+op0Oj2Y6W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 04:06:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F408B4B0A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 04:06:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 32614208E4;
 Mon, 22 Jun 2020 08:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592813215;
 bh=cbHNqMTWM4XBTi8BcgqQ/MZT1LZ7/GYxlwpP7QQrJWc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nXVeq1uzLb1InSQd9SQIgO2gDFMzaM4rSkl14YkRnlhT1Z4QORqUGIGuItwEnO5nc
 M9MnLrET5AxRbgUwg+Z9F5p5BeN39NOTMzsmJtggb0/Yz7bHkvkiO6BXHohUf0aK+z
 yeg/uPP6zCcSDhcVg3TS+RSvr0PePDXqUNkNf4Mg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jnHTh-005FG8-Nu; Mon, 22 Jun 2020 09:06:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 4/5] KVM: arm64: Check HCR_EL2 instead of shadow copy to
 swap PtrAuth registers
Date: Mon, 22 Jun 2020 09:06:42 +0100
Message-Id: <20200622080643.171651-5-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622080643.171651-1-maz@kernel.org>
References: <20200622080643.171651-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com,
 ascull@google.com, Dave.Martin@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Dave Martin <Dave.Martin@arm.com>
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

When save/restoring PtrAuth registers between host and guest, it is
pretty useless to fetch the in-memory state, while we have the right
state in the HCR_EL2 system register. Use that instead.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_ptrauth.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index 6301813dcace..f1830173fa9e 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -74,7 +74,7 @@ alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
 	b	1001f
 alternative_else_nop_endif
 1000:
-	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
+	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
 	cbz	\reg1, 1001f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
@@ -90,7 +90,7 @@ alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
 	b	2001f
 alternative_else_nop_endif
 2000:
-	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
+	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
 	cbz	\reg1, 2001f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
