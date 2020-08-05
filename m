Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B40BC433E1
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DFD022CAD
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRHZNbIP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DFD022CAD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DACC44B397;
	Wed,  5 Aug 2020 13:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TKG2NqIrrWmM; Wed,  5 Aug 2020 13:57:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F050B4B587;
	Wed,  5 Aug 2020 13:57:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E75334B397
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iSKmqOLGGCss for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 13:57:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 677C14B56C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 85E9122CBB;
 Wed,  5 Aug 2020 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596650237;
 bh=SsItzmgNSUJmbU2ivN3tQvkpomzT92B3KJRadAxB4FM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eRHZNbIPt+QywYxWJXmgi5qQTsm0ZEBXwWhf0Zhoog44OKuVGLY5QohJbXrDn4mBe
 H54ylpMsTikcPbcadEY61BoG3egxb91uctvvh4aazBuZZ1H36q3YyKGmzl8Crv7C95
 5nVqqKvd+4A4SdToplX2JpP8k+wNkP9V39quwxu8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3NfA-0004w9-3y; Wed, 05 Aug 2020 18:57:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 05/56] KVM: arm64: Simplify PtrAuth alternative patching
Date: Wed,  5 Aug 2020 18:56:09 +0100
Message-Id: <20200805175700.62775-6-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

We currently decide to execute the PtrAuth save/restore code based
on a set of branches that evaluate as (ARM64_HAS_ADDRESS_AUTH_ARCH ||
ARM64_HAS_ADDRESS_AUTH_IMP_DEF). This can be easily replaced by
a much simpler test as the ARM64_HAS_ADDRESS_AUTH capability is
exactly this expression.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_ptrauth.h | 30 ++++++++++------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index f1830173fa9e..0ddf98c3ba9f 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -61,44 +61,36 @@
 
 /*
  * Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros will
- * check for the presence of one of the cpufeature flag
- * ARM64_HAS_ADDRESS_AUTH_ARCH or ARM64_HAS_ADDRESS_AUTH_IMP_DEF and
+ * check for the presence ARM64_HAS_ADDRESS_AUTH, which is defined as
+ * (ARM64_HAS_ADDRESS_AUTH_ARCH || ARM64_HAS_ADDRESS_AUTH_IMP_DEF) and
  * then proceed ahead with the save/restore of Pointer Authentication
- * key registers.
+ * key registers if enabled for the guest.
  */
 .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
-alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
-	b	1000f
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
+	b	.L__skip_switch\@
 alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	1001f
-alternative_else_nop_endif
-1000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 1001f
+	cbz	\reg1, .L__skip_switch\@
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
-1001:
+.L__skip_switch\@:
 .endm
 
 .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
-alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
-	b	2000f
-alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	2001f
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
+	b	.L__skip_switch\@
 alternative_else_nop_endif
-2000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 2001f
+	cbz	\reg1, .L__skip_switch\@
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_save_state	\reg1, \reg2, \reg3
 	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
 	isb
-2001:
+.L__skip_switch\@:
 .endm
 
 #else /* !CONFIG_ARM64_PTR_AUTH */
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
