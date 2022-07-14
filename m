Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E44C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:20:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058794C5A6;
	Thu, 14 Jul 2022 11:20:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J25npbD0kzg4; Thu, 14 Jul 2022 11:20:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBF044C5E8;
	Thu, 14 Jul 2022 11:20:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B59A44C543
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vvdTvrPpNELI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:20:33 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACFDD4C563
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:20:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A13D3B82718;
 Thu, 14 Jul 2022 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29728C341C6;
 Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812030;
 bh=TOS4K//cGp6VnKD99TfdRSJHWQhgh40bPzwH9f3DAro=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qDC9ETXklTvY/I1hHjyQfwUmqngXDa1trido3q/Zk0bqPUY3X/xHEAEe4PY8wydMM
 vmI08zd1sXw4gA4jgvr/emhNy/GnrWGKYaeg+/xWxiJYRD3KnQt7UkDqGy2cIAtAfq
 UAKHvTbakLytpYjSlPiJjqEPGeCmqE73BIO6a6CTwCeOUhjBeyAoLEMm7YRr2ZcKm/
 p+LDu2Xj5jD5pMmTw1AubbgDL0NzP4S1d0xuDl/k4Qt3SBijY5BVmb0hAUPH7y4C8k
 1gOx+25/nqBScGcxtzYjaSJ1Mi1m4TJnhkBb/euFVYODDwgfGuzoS3f3IL22JxmWRN
 wiBmx+KJQxTZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dg-007UVL-28;
 Thu, 14 Jul 2022 16:20:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 02/20] KVM: arm64: Reorder handling of invariant sysregs
 from userspace
Date: Thu, 14 Jul 2022 16:20:06 +0100
Message-Id: <20220714152024.1673368-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
 Oliver Upton <oliver.upton@linux.dev>
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

In order to allow some further refactor of the sysreg helpers,
move the handling of invariant sysreg to occur before we handle
all the other ones.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1f410283c592..9291cb94c2e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2849,6 +2849,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 {
 	const struct sys_reg_desc *r;
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(reg->id, uaddr);
@@ -2856,12 +2857,14 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
 		return -ENOENT;
 
+	err = get_invariant_sys_reg(reg->id, uaddr);
+	if (err != -ENOENT)
+		return err;
+
 	r = index_to_sys_reg_desc(vcpu, reg->id);
-	if (!r)
-		return get_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user)
@@ -2874,6 +2877,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 {
 	const struct sys_reg_desc *r;
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_set(reg->id, uaddr);
@@ -2881,12 +2885,14 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
 		return -ENOENT;
 
+	err = set_invariant_sys_reg(reg->id, uaddr);
+	if (err != -ENOENT)
+		return err;
+
 	r = index_to_sys_reg_desc(vcpu, reg->id);
-	if (!r)
-		return set_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->set_user)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
