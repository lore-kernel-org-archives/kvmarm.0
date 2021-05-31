Return-Path: <SRS0=K5Hb=K2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043E4C47082
	for <kvmarm@archiver.kernel.org>; Mon, 31 May 2021 10:34:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B4A36124B
	for <kvmarm@archiver.kernel.org>; Mon, 31 May 2021 10:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B4A36124B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A16402DB;
	Mon, 31 May 2021 06:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id neXVY-Ph6JrL; Mon, 31 May 2021 06:34:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4EC040825;
	Mon, 31 May 2021 06:34:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5418A4075E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 May 2021 06:34:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2OEXzpb6WBoo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 May 2021 06:34:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 196A3406DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 May 2021 06:34:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622457251;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0vWlpLeqe+h7IWNv7jE/nVWyaS5tVXhak42tjTLyHuE=;
 b=PwEJaKS9yRFGNcgmGNYR/BgK/Bfmz146ClFevM3PkNhuOvNSWmjM3h5lwILeVrddqcZsuX
 kn77O5Lvbo9sIrnrAhrze1DAvsO+ZJY73svDXX6bXDq8mRScJRkZVPDyQUHRnBEATVn7Id
 B5EKUVsppzEdvoMKNyF6zH7IrfgNjuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-3qjLcSZ6NUWiwyF1jCpIrg-1; Mon, 31 May 2021 06:34:10 -0400
X-MC-Unique: 3qjLcSZ6NUWiwyF1jCpIrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9843A8005AD;
 Mon, 31 May 2021 10:34:09 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.195.13])
 by smtp.corp.redhat.com (Postfix) with ESMTP id F28905D9CD;
 Mon, 31 May 2021 10:34:01 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 5/5] KVM: arm64: selftests: get-reg-list: Split base and
 pmu registers
Date: Mon, 31 May 2021 12:33:44 +0200
Message-Id: <20210531103344.29325-6-drjones@redhat.com>
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, pbonzini@redhat.com
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

Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
userspace when not available") the get-reg-list* tests have been
failing with

  ...
  ... There are 74 missing registers.
  The following lines are missing registers:
  ...

where the 74 missing registers are all PMU registers. This isn't a
bug in KVM that the selftest found, even though it's true that a
KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
flag, but still expecting the PMU registers to be in the reg-list,
would suddenly no longer have their expectations met. In that case,
the expectations were wrong, though, so that KVM userspace needs to
be fixed, and so does this selftest. The fix for this selftest is to
pull the PMU registers out of the base register sublist into their
own sublist and then create new, pmu-enabled vcpu configs which can
be tested.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index b46b8a1fdc0c..a16c8f05366c 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -637,7 +637,7 @@ int main(int ac, char **av)
  * The current blessed list was primed with the output of kernel version
  * v4.15 with --core-reg-fixup and then later updated with new registers.
  *
- * The blessed list is up to date with kernel version v5.10-rc5
+ * The blessed list is up to date with kernel version v5.13-rc3
  */
 static __u64 base_regs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
@@ -829,8 +829,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
 	ARM64_SYS_REG(3, 0, 6, 0, 0),	/* FAR_EL1 */
 	ARM64_SYS_REG(3, 0, 7, 4, 0),	/* PAR_EL1 */
-	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
-	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
 	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
@@ -839,6 +837,16 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
 	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
+	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
+	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
+	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
+	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
+	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
+};
+
+static __u64 pmu_regs[] = {
+	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
+	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
 	ARM64_SYS_REG(3, 3, 9, 12, 0),	/* PMCR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 1),	/* PMCNTENSET_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 2),	/* PMCNTENCLR_EL0 */
@@ -848,8 +856,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 3, 9, 13, 0),	/* PMCCNTR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 14, 0),	/* PMUSERENR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 14, 3),	/* PMOVSSET_EL0 */
-	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
-	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 8, 0),
 	ARM64_SYS_REG(3, 3, 14, 8, 1),
 	ARM64_SYS_REG(3, 3, 14, 8, 2),
@@ -913,9 +919,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 3, 14, 15, 5),
 	ARM64_SYS_REG(3, 3, 14, 15, 6),
 	ARM64_SYS_REG(3, 3, 14, 15, 7),	/* PMCCFILTR_EL0 */
-	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
-	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
-	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
 };
 
 static __u64 vregs[] = {
@@ -1015,6 +1018,8 @@ static __u64 sve_rejects_set[] = {
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
 	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
+#define PMU_SUBLIST \
+	{ "pmu", .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
 #define SVE_SUBLIST \
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
@@ -1027,6 +1032,14 @@ static struct vcpu_config vregs_config = {
 	{0},
 	},
 };
+static struct vcpu_config vregs_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
 static struct vcpu_config sve_config = {
 	.sublists = {
 	BASE_SUBLIST,
@@ -1034,9 +1047,19 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+static struct vcpu_config sve_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	SVE_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
 
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
+	&vregs_pmu_config,
 	&sve_config,
+	&sve_pmu_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
