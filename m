Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E8FC388F9
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 18:50:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 275AA2231B
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 18:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iU7KTyqL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 275AA2231B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 885774B572;
	Mon,  2 Nov 2020 13:50:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Vbe2rtVK5aP; Mon,  2 Nov 2020 13:50:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61EBA4B57F;
	Mon,  2 Nov 2020 13:50:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590A24B569
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 13:50:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LVnHjB2q4AsD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 13:50:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EAEE4B470
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 13:50:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604343049;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JRf1xOKgn0goc+SouTbEfPnLoxz4w2j5CEirLYQVL8s=;
 b=iU7KTyqLY2+Fx8YBVh/GEGm7cnBLG2ENwPIzwGkBiZXonE5KBIrSV0of1mAk5kA/tMaip5
 ssVfHQrarxr2spJWBIkKYmIwQU11grJe7TbkUeLgPdxKdzpobJ2fZ4eiYpdTn3OGUauelM
 hCtlAuOrdqMAcPR++0PKAgJCl+8+v1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-louAPBsvOsSOhdsmtnxlgg-1; Mon, 02 Nov 2020 13:50:45 -0500
X-MC-Unique: louAPBsvOsSOhdsmtnxlgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5F4980364D;
 Mon,  2 Nov 2020 18:50:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 649805C5DE;
 Mon,  2 Nov 2020 18:50:43 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/3] KVM: arm64: Check RAZ visibility in ID register
 accessors
Date: Mon,  2 Nov 2020 19:50:36 +0100
Message-Id: <20201102185037.49248-3-drjones@redhat.com>
In-Reply-To: <20201102185037.49248-1-drjones@redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
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
 arch/arm64/kvm/sys_regs.h | 10 ++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6ff0c15531ca..b8822a20b1ea 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1153,6 +1153,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *r)
+{
+	return 0;
+}
+
 /* cpufeature ID register access trap handlers */
 
 static bool __access_id_reg(struct kvm_vcpu *vcpu,
@@ -1171,7 +1177,9 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	return __access_id_reg(vcpu, p, r, false);
+	bool raz = sysreg_visible_as_raz(vcpu, r);
+
+	return __access_id_reg(vcpu, p, r, raz);
 }
 
 static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
@@ -1283,13 +1291,17 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(vcpu, rd, uaddr, false);
+	bool raz = sysreg_visible_as_raz(vcpu, rd);
+
+	return __get_id_reg(vcpu, rd, uaddr, raz);
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(vcpu, rd, uaddr, false);
+	bool raz = sysreg_visible_as_raz(vcpu, rd);
+
+	return __set_id_reg(vcpu, rd, uaddr, raz);
 }
 
 static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1381,6 +1393,7 @@ static bool access_mte_regs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	.access	= access_id_reg,		\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
 }
 
 /*
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5a6fc30f5989..9d3ef7cfa116 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -61,6 +61,7 @@ struct sys_reg_desc {
 
 #define REG_HIDDEN_USER		(1 << 0) /* hidden from userspace ioctls */
 #define REG_HIDDEN_GUEST	(1 << 1) /* hidden from guest */
+#define REG_RAZ			(1 << 2) /* RAZ from userspace ioctls and guest */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -129,6 +130,15 @@ static inline bool sysreg_hidden_from_user(const struct kvm_vcpu *vcpu,
 	return r->visibility(vcpu, r) & REG_HIDDEN_USER;
 }
 
+static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
+					 const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_RAZ;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
