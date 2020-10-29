Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562ABC4742C
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A31CF20720
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pqpsj0zA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A31CF20720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 015674B60F;
	Thu, 29 Oct 2020 16:11:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qwDprEuRES61; Thu, 29 Oct 2020 16:11:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1164B62E;
	Thu, 29 Oct 2020 16:11:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EB614B659
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxQdPWH+OxuJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 16:11:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56D274B60F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604002278;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YV/JAUULy63odP5jr2zTVmEpjhjM3tgKp/yHYcJYAH8=;
 b=Pqpsj0zANFcGhXof5fRRXyltvRsB3PHgXPtDOGN/li5/s8ywHSuIR7tmA76zLusxaFllIf
 uah47MOzjfX0qwGPIl/meJBR+0DTb5N6E/Dj+CETlKn8h4244+VUZqMhCigs41b9VJO8If
 gVgJ52pneEwTUGQD2gykBM8ylpfy7Bk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-Vh8yy48ePtiBk6aDgrxTkQ-1; Thu, 29 Oct 2020 16:11:16 -0400
X-MC-Unique: Vh8yy48ePtiBk6aDgrxTkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0B0C18BA280;
 Thu, 29 Oct 2020 20:11:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 615145C22D;
 Thu, 29 Oct 2020 20:11:13 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/3] KVM: arm64: Check RAZ visibility in ID register accessors
Date: Thu, 29 Oct 2020 21:11:04 +0100
Message-Id: <20201029201105.101910-3-drjones@redhat.com>
In-Reply-To: <20201029201105.101910-1-drjones@redhat.com>
References: <20201029201105.101910-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

The instruction encodings of ID registers are preallocated. Until an
encoding is assigned a purpose the register is RAZ. KVM's general ID
register accessor functions already support both paths, RAZ or not.
If for each ID register we can determine if it's RAZ or not, then all
ID registers can build on the general functions. The register visibility
function allows us to check whether a register should be completely
hidden or not, extending it to also report when the register should
be RAZ or not allows us to use it for ID registers as well.

No functional change intended.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++++++++++++---
 arch/arm64/kvm/sys_regs.h | 20 ++++++++++++++++++++
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d24e66ee59b3..9f6151589460 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1171,7 +1171,9 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	return __access_id_reg(vcpu, p, r, false);
+	bool raz = sysreg_raz_from_guest(vcpu, r);
+
+	return __access_id_reg(vcpu, p, r, raz);
 }
 
 static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
@@ -1283,13 +1285,17 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(vcpu, rd, uaddr, false);
+	bool raz = sysreg_raz_from_user(vcpu, rd);
+
+	return __get_id_reg(vcpu, rd, uaddr, raz);
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(vcpu, rd, uaddr, false);
+	bool raz = sysreg_raz_from_user(vcpu, rd);
+
+	return __set_id_reg(vcpu, rd, uaddr, raz);
 }
 
 static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1375,12 +1381,19 @@ static bool access_mte_regs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return false;
 }
 
+static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *r)
+{
+	return 0;
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
 }
 
 /*
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5a6fc30f5989..d5add36c130a 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -61,6 +61,8 @@ struct sys_reg_desc {
 
 #define REG_HIDDEN_USER		(1 << 0) /* hidden from userspace ioctls */
 #define REG_HIDDEN_GUEST	(1 << 1) /* hidden from guest */
+#define REG_RAZ_USER		(1 << 2) /* RAZ from userspace ioctls */
+#define REG_RAZ_GUEST		(1 << 3) /* RAZ from guest */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -129,6 +131,24 @@ static inline bool sysreg_hidden_from_user(const struct kvm_vcpu *vcpu,
 	return r->visibility(vcpu, r) & REG_HIDDEN_USER;
 }
 
+static inline bool sysreg_raz_from_guest(const struct kvm_vcpu *vcpu,
+					 const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_RAZ_GUEST;
+}
+
+static inline bool sysreg_raz_from_user(const struct kvm_vcpu *vcpu,
+					const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_RAZ_USER;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
