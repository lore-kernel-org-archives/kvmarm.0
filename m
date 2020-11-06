Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C99C2D0A3
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 942FD2222B
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfH1oejj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 942FD2222B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F804B8B1;
	Fri,  6 Nov 2020 11:44:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ts5CPkBMnJ3m; Fri,  6 Nov 2020 11:44:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B7A44B8C2;
	Fri,  6 Nov 2020 11:44:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FF594B8BC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7S4r4fH-FvIJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 11:44:40 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 257114B8B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:40 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3036522202;
 Fri,  6 Nov 2020 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604681079;
 bh=4nxo98F1ri7FBCul54hzxH5bJE7AoVp784/dlvDWj18=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=QfH1oejjMxWbH7yFeFEqfBF+e5gKfG76n3Py3NRJUBH10OhtfdlKZAn+ffkQApYNj
 yqfZKVl0eCyScIiBEFEBvUk2rcDbpMocIq83q1MyhrQX8AR57hzjf+ilkolQpe3umw
 Cpe1Ac30yhi0O3Zoe0ObN90+CwqPGUXPs81X0mJk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kb4qr-008FYW-CK; Fri, 06 Nov 2020 16:44:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/5] KVM: arm64: Consolidate REG_HIDDEN_GUEST/USER
Date: Fri,  6 Nov 2020 16:44:14 +0000
Message-Id: <20201106164416.326787-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
References: <20201106164416.326787-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com,
 eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com,
 dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
 linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
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

From: Andrew Jones <drjones@redhat.com>

REG_HIDDEN_GUEST and REG_HIDDEN_USER are always used together.
Consolidate them into a single REG_HIDDEN flag. We can always
add another flag later if some register needs to expose itself
differently to the guest than it does to userspace.

No functional change intended.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201105091022.15373-3-drjones@redhat.com
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++------
 arch/arm64/kvm/sys_regs.h | 18 ++++--------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3af306e6b9cd..26a285127620 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1069,7 +1069,7 @@ static bool trap_ptrauth(struct kvm_vcpu *vcpu,
 static unsigned int ptrauth_visibility(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd)
 {
-	return vcpu_has_ptrauth(vcpu) ? 0 : REG_HIDDEN_USER | REG_HIDDEN_GUEST;
+	return vcpu_has_ptrauth(vcpu) ? 0 : REG_HIDDEN;
 }
 
 #define __PTRAUTH_KEY(k)						\
@@ -1190,7 +1190,7 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	if (vcpu_has_sve(vcpu))
 		return 0;
 
-	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
+	return REG_HIDDEN;
 }
 
 /* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
@@ -2153,7 +2153,7 @@ static void perform_access(struct kvm_vcpu *vcpu,
 	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden_from_guest(vcpu, r)) {
+	if (sysreg_hidden(vcpu, r)) {
 		kvm_inject_undefined(vcpu);
 		return;
 	}
@@ -2652,7 +2652,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return get_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden_from_user(vcpu, r))
+	if (sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user)
@@ -2677,7 +2677,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return set_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden_from_user(vcpu, r))
+	if (sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->set_user)
@@ -2748,7 +2748,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
-	if (sysreg_hidden_from_user(vcpu, rd))
+	if (sysreg_hidden(vcpu, rd))
 		return 0;
 
 	if (!copy_reg_to_user(rd, uind))
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5a6fc30f5989..2641b2ee6a91 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -59,8 +59,7 @@ struct sys_reg_desc {
 				   const struct sys_reg_desc *rd);
 };
 
-#define REG_HIDDEN_USER		(1 << 0) /* hidden from userspace ioctls */
-#define REG_HIDDEN_GUEST	(1 << 1) /* hidden from guest */
+#define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -111,22 +110,13 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	__vcpu_sys_reg(vcpu, r->reg) = r->val;
 }
 
-static inline bool sysreg_hidden_from_guest(const struct kvm_vcpu *vcpu,
-					    const struct sys_reg_desc *r)
-{
-	if (likely(!r->visibility))
-		return false;
-
-	return r->visibility(vcpu, r) & REG_HIDDEN_GUEST;
-}
-
-static inline bool sysreg_hidden_from_user(const struct kvm_vcpu *vcpu,
-					   const struct sys_reg_desc *r)
+static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r)
 {
 	if (likely(!r->visibility))
 		return false;
 
-	return r->visibility(vcpu, r) & REG_HIDDEN_USER;
+	return r->visibility(vcpu, r) & REG_HIDDEN;
 }
 
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
