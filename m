Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA42CA9EAF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 12:25:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C12F32166E
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 12:25:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C12F32166E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A32F4A597;
	Thu, 24 Oct 2019 08:25:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xBaGP2FKK9fU; Thu, 24 Oct 2019 08:25:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 216C44A8EB;
	Thu, 24 Oct 2019 08:25:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBE174A591
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 06:28:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pB0Hk4GLDfmL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 06:28:08 -0400 (EDT)
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
 [47.88.44.36])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B6A14A651
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 06:28:07 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R561e4; CH=green; DM=||false|;
 FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01422; MF=shannon.zhao@linux.alibaba.com;
 NM=1; PH=DS; RN=8; SR=0; TI=SMTPD_---0Tg2bjwt_1571912873; 
Received: from localhost(mailfrom:shannon.zhao@linux.alibaba.com
 fp:SMTPD_---0Tg2bjwt_1571912873) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 24 Oct 2019 18:27:54 +0800
From: Shannon Zhao <shannon.zhao@linux.alibaba.com>
To: kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, christoffer.dall@arm.com
Subject: [PATCH RFC 6/7] KVM: arm/arm64: Move target table register into
 register table init function
Date: Thu, 24 Oct 2019 18:27:49 +0800
Message-Id: <1571912870-18471-7-git-send-email-shannon.zhao@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
References: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
X-Mailman-Approved-At: Thu, 24 Oct 2019 08:25:09 -0400
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This prepares for making kvm arm compile as a module.

Signed-off-by: Shannon Zhao <shannon.zhao@linux.alibaba.com>
---
 arch/arm/kvm/coproc.c                | 3 +++
 arch/arm/kvm/coproc.h                | 3 +++
 arch/arm/kvm/coproc_a15.c            | 4 +---
 arch/arm/kvm/coproc_a7.c             | 4 +---
 arch/arm64/kvm/sys_regs.c            | 1 +
 arch/arm64/kvm/sys_regs.h            | 2 ++
 arch/arm64/kvm/sys_regs_generic_v8.c | 5 +----
 7 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 07745ee..58e48b1 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -1404,6 +1404,9 @@ void kvm_coproc_table_init(void)
 {
 	unsigned int i;
 
+	coproc_a7_init();
+	coproc_a15_init();
+
 	/* Make sure tables are unique and in order. */
 	BUG_ON(check_reg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
 	BUG_ON(check_reg_table(invariant_cp15, ARRAY_SIZE(invariant_cp15)));
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
index 637065b..592118c 100644
--- a/arch/arm/kvm/coproc.h
+++ b/arch/arm/kvm/coproc.h
@@ -127,4 +127,7 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
 		   const struct coproc_params *p,
 		   const struct coproc_reg *r);
 
+void coproc_a7_init(void);
+void coproc_a15_init(void);
+
 #endif /* __ARM_KVM_COPROC_LOCAL_H__ */
diff --git a/arch/arm/kvm/coproc_a15.c b/arch/arm/kvm/coproc_a15.c
index 36bf154..ece74b2f 100644
--- a/arch/arm/kvm/coproc_a15.c
+++ b/arch/arm/kvm/coproc_a15.c
@@ -31,9 +31,7 @@
 	.num = ARRAY_SIZE(a15_regs),
 };
 
-static int __init coproc_a15_init(void)
+void coproc_a15_init(void)
 {
 	kvm_register_target_coproc_table(&a15_target_table);
-	return 0;
 }
-late_initcall(coproc_a15_init);
diff --git a/arch/arm/kvm/coproc_a7.c b/arch/arm/kvm/coproc_a7.c
index 40f643e..74616f5 100644
--- a/arch/arm/kvm/coproc_a7.c
+++ b/arch/arm/kvm/coproc_a7.c
@@ -34,9 +34,7 @@
 	.num = ARRAY_SIZE(a7_regs),
 };
 
-static int __init coproc_a7_init(void)
+void coproc_a7_init(void)
 {
 	kvm_register_target_coproc_table(&a7_target_table);
-	return 0;
 }
-late_initcall(coproc_a7_init);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2071260..9dd164d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2738,6 +2738,7 @@ void kvm_sys_reg_table_init(void)
 	unsigned int i;
 	struct sys_reg_desc clidr;
 
+	sys_reg_genericv8_init();
 	/* Make sure tables are unique and in order. */
 	BUG_ON(check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs)));
 	BUG_ON(check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs)));
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9bca031..f11cb63 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -140,6 +140,8 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  const struct sys_reg_desc table[],
 					  unsigned int num);
 
+void sys_reg_genericv8_init(void);
+
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
 #define CRn(_x)		.CRn = _x
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 2b4a3e2..3e4bacd 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -61,7 +61,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	},
 };
 
-static int __init sys_reg_genericv8_init(void)
+void sys_reg_genericv8_init(void)
 {
 	unsigned int i;
 
@@ -81,7 +81,4 @@ static int __init sys_reg_genericv8_init(void)
 					  &genericv8_target_table);
 	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_GENERIC_V8,
 					  &genericv8_target_table);
-
-	return 0;
 }
-late_initcall(sys_reg_genericv8_init);
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
