Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238D2C4741F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59F66206DD
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNWoWhiq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59F66206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E788E4B62F;
	Thu, 29 Oct 2020 16:11:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zVSSuEZ+oFt5; Thu, 29 Oct 2020 16:11:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2A14B67D;
	Thu, 29 Oct 2020 16:11:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E36084B5EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mgDaRktviGw7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 16:11:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B10D4B64B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604002282;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pR1vjz+uA3tB2wvyUuGDxtuO+UCYt8yWsxNU7bUHOaw=;
 b=JNWoWhiqthO+uZ/ZMZEauPAAg0oNMd6nAuTQ2lXGVFOyqkBD+NFaxs155HzywCiRmgztrK
 WqfUlAA+8ASvSPppbOBsgPYKdp4bIWORoggX2aM13fOYQRg6EoTUBDi4XSJA8Ig8Y4a1eC
 1N8y0uXRKbbRQr7n2UlNrFdgaiMSsUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-Ra8CBNJ7MaeBtdU0mYhdqQ-1; Thu, 29 Oct 2020 16:11:18 -0400
X-MC-Unique: Ra8CBNJ7MaeBtdU0mYhdqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A995618BA281;
 Thu, 29 Oct 2020 20:11:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3B2AD5C22D;
 Thu, 29 Oct 2020 20:11:15 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/3] KVM: arm64: Remove AA64ZFR0_EL1 accessors
Date: Thu, 29 Oct 2020 21:11:05 +0100
Message-Id: <20201029201105.101910-4-drjones@redhat.com>
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

The AA64ZFR0_EL1 accessors are just the general accessors with
its visibility function open-coded. It also skips the if-else
chain in read_id_reg, but there's no reason not to go there.
Indeed consolidating ID register accessors and removing lines
of code make it worthwhile.

No functional change intended.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 61 +++++++--------------------------------
 1 file changed, 11 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9f6151589460..1ccaa5f3b081 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1197,55 +1197,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN_USER | REG_HIDDEN_GUEST;
 }
 
-/* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
-static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
-{
-	if (!vcpu_has_sve(vcpu))
-		return 0;
-
-	return read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
-}
-
-static bool access_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
-				   struct sys_reg_params *p,
-				   const struct sys_reg_desc *rd)
-{
-	if (p->is_write)
-		return write_to_read_only(vcpu, p, rd);
-
-	p->regval = guest_id_aa64zfr0_el1(vcpu);
-	return true;
-}
-
-static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
-		const struct sys_reg_desc *rd,
-		const struct kvm_one_reg *reg, void __user *uaddr)
-{
-	u64 val;
-
-	val = guest_id_aa64zfr0_el1(vcpu);
-	return reg_to_user(uaddr, &val, reg->id);
-}
-
-static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
-		const struct sys_reg_desc *rd,
-		const struct kvm_one_reg *reg, void __user *uaddr)
-{
-	const u64 id = sys_reg_to_index(rd);
-	int err;
-	u64 val;
-
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
-
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != guest_id_aa64zfr0_el1(vcpu))
-		return -EINVAL;
-
-	return 0;
-}
-
 /*
  * cpufeature ID register user accessors
  *
@@ -1384,6 +1335,16 @@ static bool access_mte_regs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
+	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
+			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+
+	switch (id) {
+	case SYS_ID_AA64ZFR0_EL1:
+		if (!vcpu_has_sve(vcpu))
+			return REG_RAZ_USER | REG_RAZ_GUEST;
+		break;
+	}
+
 	return 0;
 }
 
@@ -1515,7 +1476,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, },
+	ID_SANITISED(ID_AA64ZFR0_EL1),
 	ID_UNALLOCATED(4,5),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
