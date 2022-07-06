Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B1EC43334
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 16:43:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E1164BE96;
	Wed,  6 Jul 2022 12:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vK2u91v5vD3y; Wed,  6 Jul 2022 12:43:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA62D4BE9F;
	Wed,  6 Jul 2022 12:43:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5190C4BEA0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 12:43:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FET4b+HMCTbw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 12:43:14 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B4034BE89
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 12:43:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 87F8A61DA9;
 Wed,  6 Jul 2022 16:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38E9C341CE;
 Wed,  6 Jul 2022 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657125792;
 bh=jDvn5Ncu7RrZEAsiUaZB5MOsATvqSWgwTjaOvfy/gVo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=DK7ozMs0uv85PFqSeaQSoVRZrHYFXt3Ge8KEHX3hpfBvbOpIqjhKNjrfouPU8k4lR
 dNKggCSglEH/YEIoJLCuPnIkNoQ1PJG6r6Ftf+OVO/rksZPqcOhzKlCrnvRJi8N1rE
 XaLnoTQENGmfNHrp2+c0q8/uInsgrIESG+uZQCY3eyXbNaec0PGF4HYhmdY521W6S1
 OU7dvT96ca45tLzwXEsa02xxoP1Y0WendJP2V8zVI4pXwcbfZv7KB0IlJmb5YQMnvu
 JD7ea5E+QXxoYwX7LXHamRIqo1sccNBwN0HEArWiFPuPE0uQ4EDR7sW04g4E4NCImP
 rLBEmNk8K8fyA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o987L-005h9i-3U;
 Wed, 06 Jul 2022 17:43:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/19] KVM: arm64: Reorder handling of invariant sysregs from
 userspace
Date: Wed,  6 Jul 2022 17:42:47 +0100
Message-Id: <20220706164304.1582687-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 schspa@gmail.com, kernel-team@android.com
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
