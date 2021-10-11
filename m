Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F3AC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 10:57:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D10D560EB4
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 10:57:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D10D560EB4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E63D4B11E;
	Mon, 11 Oct 2021 06:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l-1ckxdyYaOu; Mon, 11 Oct 2021 06:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F9D4B0E1;
	Mon, 11 Oct 2021 06:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3224B0A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 06:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZYkcNU891NMp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 06:57:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 234A94B0B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 06:57:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C682BED1;
 Mon, 11 Oct 2021 03:57:18 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A8B53F66F;
 Mon, 11 Oct 2021 03:57:17 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 drjones@redhat.com
Subject: [PATCH v2 3/3] KVM: arm64: Replace get_raz_id_reg() with get_raz_reg()
Date: Mon, 11 Oct 2021 11:58:40 +0100
Message-Id: <20211011105840.155815-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011105840.155815-1-alexandru.elisei@arm.com>
References: <20211011105840.155815-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Reading a RAZ ID register isn't different from reading any other RAZ
register, so get rid of get_raz_id_reg() and replace it with get_raz_reg(),
which does the same thing, but does it without going through two layers of
indirection.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1be827740f87..3aff06aafd0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1273,12 +1273,6 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return __set_id_reg(vcpu, rd, uaddr, raz);
 }
 
-static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-			  const struct kvm_one_reg *reg, void __user *uaddr)
-{
-	return __get_id_reg(vcpu, rd, uaddr, true);
-}
-
 static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			  const struct kvm_one_reg *reg, void __user *uaddr)
 {
@@ -1402,7 +1396,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 #define ID_UNALLOCATED(crm, op2) {			\
 	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
 	.access = access_raz_id_reg,			\
-	.get_user = get_raz_id_reg,			\
+	.get_user = get_raz_reg,			\
 	.set_user = set_raz_id_reg,			\
 }
 
@@ -1414,7 +1408,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 #define ID_HIDDEN(name) {			\
 	SYS_DESC(SYS_##name),			\
 	.access = access_raz_id_reg,		\
-	.get_user = get_raz_id_reg,		\
+	.get_user = get_raz_reg,		\
 	.set_user = set_raz_id_reg,		\
 }
 
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
