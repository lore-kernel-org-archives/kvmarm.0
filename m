Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BD1C433DB
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 14:42:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94F4023100
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 14:42:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94F4023100
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C84204B1AF;
	Wed,  6 Jan 2021 09:42:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S-oOr8Wx9jYW; Wed,  6 Jan 2021 09:42:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8A74B1FD;
	Wed,  6 Jan 2021 09:42:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7A04B1A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 09:42:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s9b-6U6u9SBN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 09:42:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03DFF4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 09:42:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7020AD6E;
 Wed,  6 Jan 2021 06:42:24 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FC013F719;
 Wed,  6 Jan 2021 06:42:23 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Use the reg_to_encoding() macro instead of
 sys_reg()
Date: Wed,  6 Jan 2021 14:42:18 +0000
Message-Id: <20210106144218.110665-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
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

The reg_to_encoding() macro is a wrapper over sys_reg() and conveniently
takes a sys_reg_desc or a sys_reg_params argument and returns the 32 bit
register encoding. Use it instead of calling sys_reg() directly.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Patch was created on top of v5.11-rc2 with the patch that removes the
spurious semicolon from reg_to_encoding() [1] applied.

Tested on a rockpro64 with kvm-unit-tests, which exercise the
access_arch_timer() and id_visibility() functions. LORegion registers are
touched by the kernel when booting at EL2, so I couldn't find a test for
that code path, and writing my own seemed like overkill.

[1] https://www.spinics.net/lists/arm-kernel/msg865311.html

 arch/arm64/kvm/sys_regs.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 00c119e8e8d3..048416c5636a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -43,6 +43,10 @@
  * 64bit interface.
  */
 
+#define reg_to_encoding(x)						\
+	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
+		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
+
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
 				 const struct sys_reg_desc *r)
@@ -273,8 +277,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  const struct sys_reg_desc *r)
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
-	u32 sr = sys_reg((u32)r->Op0, (u32)r->Op1,
-			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
 		kvm_inject_undefined(vcpu);
@@ -917,10 +920,6 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
-#define reg_to_encoding(x)						\
-	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
-		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
-
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1016,8 +1015,7 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
-	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
-			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+	u32 id = reg_to_encoding(r);
 	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
 
 	if (id == SYS_ID_AA64PFR0_EL1) {
@@ -1058,8 +1056,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
-	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
-			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+	u32 id = reg_to_encoding(r);
 
 	switch (id) {
 	case SYS_ID_AA64ZFR0_EL1:
-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
