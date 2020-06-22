Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65428C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 08:07:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DE69207C3
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 08:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1QcwT2Ld"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DE69207C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB694B08C;
	Mon, 22 Jun 2020 04:07:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dk29VwGqHuKN; Mon, 22 Jun 2020 04:07:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8A04B0DC;
	Mon, 22 Jun 2020 04:06:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B864B0AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 04:06:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J9n8f7KFy0Qf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 04:06:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 804624B0B7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 04:06:56 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B5C78208B8;
 Mon, 22 Jun 2020 08:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592813215;
 bh=4nG2b3jaPjznFD/NfnCd4lwrsEBsRWemjhTf0Sa8kGs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1QcwT2LdGzYbQ4WrK2MAJLcBXxUUtmRWcG/BcBlXrB5Mvkxx801VfvZrkGMekCGcf
 volfud8JcHtQ/+STXSZyMbFz9TmEYHYEfUyACVmDGEnDUSGdJ+M/4lpAUtpH66otp+
 fsBWeoDh8Cnk6z2LswTAEdyDUK58WWPvm2Pvt610=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jnHTi-005FG8-9V; Mon, 22 Jun 2020 09:06:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Date: Mon, 22 Jun 2020 09:06:43 +0100
Message-Id: <20200622080643.171651-6-maz@kernel.org>
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

We currently decide to execute the PtrAuth save/restore code based
on a set of branches that evaluate as (ARM64_HAS_ADDRESS_AUTH_ARCH ||
ARM64_HAS_ADDRESS_AUTH_IMP_DEF). This can be easily replaced by
a much simpler test as the ARM64_HAS_ADDRESS_AUTH capability is
exactly this expression.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_ptrauth.h | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index f1830173fa9e..7a72508a841b 100644
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
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
 	b	1000f
 alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	1001f
-alternative_else_nop_endif
-1000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 1001f
+	cbz	\reg1, 1000f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
-1001:
+1000:
 .endm
 
 .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
-alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
+alternative_if_not ARM64_HAS_ADDRESS_AUTH
 	b	2000f
 alternative_else_nop_endif
-alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
-	b	2001f
-alternative_else_nop_endif
-2000:
 	mrs	\reg1, hcr_el2
 	and	\reg1, \reg1, #(HCR_API | HCR_APK)
-	cbz	\reg1, 2001f
+	cbz	\reg1, 2000f
 	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_save_state	\reg1, \reg2, \reg3
 	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
 	ptrauth_restore_state	\reg1, \reg2, \reg3
 	isb
-2001:
+2000:
 .endm
 
 #else /* !CONFIG_ARM64_PTR_AUTH */
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
