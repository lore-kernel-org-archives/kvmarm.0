Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0ECC6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 13 Sep 2022 09:44:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5614BC28;
	Tue, 13 Sep 2022 05:44:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 33LiA58f4jBv; Tue, 13 Sep 2022 05:44:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 708754BBB6;
	Tue, 13 Sep 2022 05:44:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D53FD4BBE1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 05:44:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z0PW6aukSMmD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 05:44:55 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D88214BBB2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 05:44:54 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663062293;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X3uLK2B33Vs/uryalTDkiauADuUaETuEfrZIlg4V3Ns=;
 b=ckXWX5AL/It5RYFysV7OZrXlgigjIqbIu21xOQj/GvbNZOTtW8xsDqq8e/mqKudBmkoslO
 dt2qMzyCjcwfmX8PP4G0ZPxx8Eqp6GBAS+Bx/XOU5MeS7ZzvAxwuJkY+/zwnlgWk4oLDZk
 GzBOh1FHPrhYvMnlvQOKewklfeGJfLE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v3 1/7] KVM: arm64: Use visibility hook to treat ID regs as RAZ
Date: Tue, 13 Sep 2022 09:44:34 +0000
Message-Id: <20220913094441.3957645-2-oliver.upton@linux.dev>
In-Reply-To: <20220913094441.3957645-1-oliver.upton@linux.dev>
References: <20220913094441.3957645-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The generic id reg accessors already handle RAZ registers by way of the
visibility hook. Add a visibility hook that returns REG_RAZ
unconditionally and throw out the RAZ specific accessors.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3234f50b8c4b..e18efb9211f0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1145,6 +1145,12 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *r)
+{
+	return REG_RAZ;
+}
+
 /* cpufeature ID register access trap handlers */
 
 static bool __access_id_reg(struct kvm_vcpu *vcpu,
@@ -1168,13 +1174,6 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, raz);
 }
 
-static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
-			      struct sys_reg_params *p,
-			      const struct sys_reg_desc *r)
-{
-	return __access_id_reg(vcpu, p, r, true);
-}
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1262,12 +1261,6 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return __set_id_reg(vcpu, rd, val, raz);
 }
 
-static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-			  u64 val)
-{
-	return __set_id_reg(vcpu, rd, val, true);
-}
-
 static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		       u64 *val)
 {
@@ -1374,9 +1367,10 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
  */
 #define ID_UNALLOCATED(crm, op2) {			\
 	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
-	.access = access_raz_id_reg,			\
-	.get_user = get_raz_reg,			\
-	.set_user = set_raz_id_reg,			\
+	.access = access_id_reg,			\
+	.get_user = get_id_reg,				\
+	.set_user = set_id_reg,				\
+	.visibility = raz_visibility			\
 }
 
 /*
@@ -1386,9 +1380,10 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
  */
 #define ID_HIDDEN(name) {			\
 	SYS_DESC(SYS_##name),			\
-	.access = access_raz_id_reg,		\
-	.get_user = get_raz_reg,		\
-	.set_user = set_raz_id_reg,		\
+	.access = access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = raz_visibility,		\
 }
 
 /*
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
