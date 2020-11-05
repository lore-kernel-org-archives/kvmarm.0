Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29E5C388F7
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:10:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0438F2073A
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gKnYKgmv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0438F2073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 802324B3A3;
	Thu,  5 Nov 2020 04:10:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ynh4O8ZFj4Ab; Thu,  5 Nov 2020 04:10:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6168E4B7D2;
	Thu,  5 Nov 2020 04:10:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7564B3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:10:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2yzRrKGuoTWp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 04:10:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FB94B376
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:10:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604567434;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=K6BoknPtTOPojE/Bxv/VPzRysCNBqoHfThap35OxsDk=;
 b=gKnYKgmvWUqDQHG1tV1lcOTvRmYMe/KEUJs+OiNVHlFuHj6bO6PFbT0P2djDkLQqqbhTsJ
 v6DrDN3NBtQWz1xbRgl0Lm2opjeqqG2Oda+hbRbJHWvPzUAo3JXV87OkgltOptbmfA6ZE1
 qW9Xsrban0iVVzXSV26LOWgoTek29U0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-1_u0HzYHOb2CdWPqHc68LQ-1; Thu, 05 Nov 2020 04:10:32 -0500
X-MC-Unique: 1_u0HzYHOb2CdWPqHc68LQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AEDA18C9F47;
 Thu,  5 Nov 2020 09:10:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.18])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9606B6CE51;
 Thu,  5 Nov 2020 09:10:28 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 2/4] KVM: arm64: Consolidate REG_HIDDEN_GUEST/USER
Date: Thu,  5 Nov 2020 10:10:20 +0100
Message-Id: <20201105091022.15373-3-drjones@redhat.com>
In-Reply-To: <20201105091022.15373-1-drjones@redhat.com>
References: <20201105091022.15373-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, xu910121@sina.com, Dave.Martin@arm.com
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

REG_HIDDEN_GUEST and REG_HIDDEN_USER are always used together.
Consolidate them into a single REG_HIDDEN flag. We can always
add another flag later if some register needs to expose itself
differently to the guest than it does to userspace.

No functional change intended.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++------
 arch/arm64/kvm/sys_regs.h | 18 ++++--------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6ff0c15531ca..1b227f4eb707 100644
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
@@ -1192,7 +1192,7 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	if (vcpu_has_sve(vcpu))
 		return 0;
 
-	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
+	return REG_HIDDEN;
 }
 
 /* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
@@ -2169,7 +2169,7 @@ static void perform_access(struct kvm_vcpu *vcpu,
 	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden_from_guest(vcpu, r)) {
+	if (sysreg_hidden(vcpu, r)) {
 		kvm_inject_undefined(vcpu);
 		return;
 	}
@@ -2668,7 +2668,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return get_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden_from_user(vcpu, r))
+	if (sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user)
@@ -2693,7 +2693,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return set_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden_from_user(vcpu, r))
+	if (sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->set_user)
@@ -2764,7 +2764,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
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
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
