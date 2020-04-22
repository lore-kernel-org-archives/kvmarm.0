Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC7BC5518E
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7591E21582
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yzuk7mVS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7591E21582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3047E4B185;
	Wed, 22 Apr 2020 08:21:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yBMwpXFkwtox; Wed, 22 Apr 2020 08:21:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D2A54B18D;
	Wed, 22 Apr 2020 08:21:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAB1C4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJeBvdQ2PSCD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 08:21:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B7D14B187
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:16 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9BFA12098B;
 Wed, 22 Apr 2020 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587558075;
 bh=Uhg6Lz8NRpX5GBeKvmPIrvA3kpxFs/g2JI7KzreZ668=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=yzuk7mVSs2Ik7bJISLgrjG4iohIP9KKxbmlzo/rtD9CtWgIsI782EBlDa7rhrxw8l
 xz2GjVbefvEBSRJWIu1NQU5w/Mq3uzvHZ8J4D5MuaKYj7ZojpdDfvVjwpHq9W2Msbw
 x+pwjwLn3SetUJEvMRlMX1X7658TnJ89w/EYbXW4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRE3x-005UI7-VY; Wed, 22 Apr 2020 13:01:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 16/26] KVM: arm64: pauth: Use ctxt_sys_reg() instead of raw
 sys_regs access
Date: Wed, 22 Apr 2020 13:00:40 +0100
Message-Id: <20200422120050.3693593-17-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>
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

Now that we have a wrapper for the sysreg accesses, let's use that
consistently.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index aacfc55de44cb..1feb0eb3174a3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,10 +162,11 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-#define __ptrauth_save_key(regs, key)						\
+
+#define __ptrauth_save_key(ctxt, key)						\
 ({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+	ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = read_sysreg_s(SYS_ ## key ## KEYLO_EL1); \
+	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
 })
 
 /*
@@ -179,11 +180,11 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 	if (vcpu_has_ptrauth(vcpu)) {
 		vcpu_ptrauth_enable(vcpu);
 		ctxt = vcpu->arch.host_cpu_context;
-		__ptrauth_save_key(ctxt->sys_regs, APIA);
-		__ptrauth_save_key(ctxt->sys_regs, APIB);
-		__ptrauth_save_key(ctxt->sys_regs, APDA);
-		__ptrauth_save_key(ctxt->sys_regs, APDB);
-		__ptrauth_save_key(ctxt->sys_regs, APGA);
+		__ptrauth_save_key(ctxt, APIA);
+		__ptrauth_save_key(ctxt, APIB);
+		__ptrauth_save_key(ctxt, APDA);
+		__ptrauth_save_key(ctxt, APDB);
+		__ptrauth_save_key(ctxt, APGA);
 	} else {
 		kvm_inject_undefined(vcpu);
 	}
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
