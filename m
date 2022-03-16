Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF42FC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 12:51:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F38D49E57;
	Wed, 16 Mar 2022 08:51:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R90udyjG0cNP; Wed, 16 Mar 2022 08:51:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 002FF40C31;
	Wed, 16 Mar 2022 08:51:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0CD40431
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 08:51:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4oX6LGz6HsNr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 08:51:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E8324024F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 08:51:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647435096;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=BIa7cfo5fEM6CaHHPP1qBZSRTB/aU8vsbEXFPomBkQ4=;
 b=SGtM1AepjLOYcpMPxmekyqSrhmp14iBO26nZYFge6pUypORyEE1c3+ZaRALMnA/lcjCgQT
 GkM5XspF55e/4vPROD6Vmctb+7Mp5D5cS+LiKqSQUPotxA/y8N7fH0WSMR1DyrwKzpB0vH
 zHqCIFWDYH9lqrwiE+BoKcu2UA6xfmY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-oIQHFQ96PwKHLXKuEPYTGQ-1; Wed, 16 Mar 2022 08:51:33 -0400
X-MC-Unique: oIQHFQ96PwKHLXKuEPYTGQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4700B29ABA2D;
 Wed, 16 Mar 2022 12:51:32 +0000 (UTC)
Received: from gator.home (unknown [10.40.193.57])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1796740D2820;
 Wed, 16 Mar 2022 12:51:30 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: selftests: get-reg-list: Add KVM_REG_ARM_FW_REG(3)
Date: Wed, 16 Mar 2022 13:51:29 +0100
Message-Id: <20220316125129.392128-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org
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

When testing a kernel with commit a5905d6af492 ("KVM: arm64:
Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated")
get-reg-list output

vregs: Number blessed registers:   234
vregs: Number registers:           238

vregs: There are 1 new registers.
Consider adding them to the blessed reg list with the following lines:

	KVM_REG_ARM_FW_REG(3),

vregs: PASS
...

That output inspired two changes: 1) add the new register to the
blessed list and 2) explain why "Number registers" is actually four
larger than "Number blessed registers" (on the system used for
testing), even though only one register is being stated as new.
The reason is that some registers are host dependent and they get
filtered out when comparing with the blessed list. The system
used for the test apparently had three filtered registers.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index f769fc6cd927..7efe918ded9e 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -503,8 +503,13 @@ static void run_test(struct vcpu_config *c)
 		++missing_regs;
 
 	if (new_regs || missing_regs) {
+		n = 0;
+		for_each_reg_filtered(i)
+			++n;
+
 		printf("%s: Number blessed registers: %5lld\n", config_name(c), blessed_n);
-		printf("%s: Number registers:         %5lld\n", config_name(c), reg_list->n);
+		printf("%s: Number registers:         %5lld (includes %lld filtered registers)\n",
+		       config_name(c), reg_list->n, reg_list->n - n);
 	}
 
 	if (new_regs) {
@@ -683,9 +688,10 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[4]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpsr),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpcr),
-	KVM_REG_ARM_FW_REG(0),
-	KVM_REG_ARM_FW_REG(1),
-	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_REG(0),		/* KVM_REG_ARM_PSCI_VERSION */
+	KVM_REG_ARM_FW_REG(1),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1 */
+	KVM_REG_ARM_FW_REG(2),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2 */
+	KVM_REG_ARM_FW_REG(3),		/* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3 */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
