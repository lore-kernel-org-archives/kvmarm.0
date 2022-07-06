Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9FFC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 16:43:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86E1B4BEA0;
	Wed,  6 Jul 2022 12:43:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lIgW0mwrdqNt; Wed,  6 Jul 2022 12:43:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 774994BE8B;
	Wed,  6 Jul 2022 12:43:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D723B4BE99
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 12:43:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hw8xV9QpXGTC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 12:43:15 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B260F4BEAC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 12:43:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6EFAEB81E2B;
 Wed,  6 Jul 2022 16:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D4FC341CA;
 Wed,  6 Jul 2022 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657125793;
 bh=GdLG/XaB8d/eJSmonaDoVgKiTzmews1UlhysHlpleWQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VtmRlShZrNJd9Uyu8c5JDwdMopnIlC74b9cZS/+llHywevclgDV7ZfLcJa21pxlEP
 ukGGzbiyeNozQDbNEDUitfGKGdHwft/xZhox1jiPnsbGHP1TAttJn+LhO5JsuRLH7V
 a/fWRwiu+tcDJyLFz4Kfgz8SA10RvcbdGc1kZXl3kxH39mgeC40GFTsp0c19o9UhUl
 z2AbxDB34STm6JQJA5nSYnO+L2CIdlh23Y76FwVOWSNVYkf5fXVoKds2uHxyp72wBO
 87zEXr8VI5BIRE65+2q/BFMmnn0fWRPZbGjNjzu2tC0DRkNr0m4CkzlmHD56GMMmCQ
 HrXUfZepXns/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o987L-005h9i-Fi;
 Wed, 06 Jul 2022 17:43:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/19] KVM: arm64: Push checks for 64bit registers into the
 low-level accessors
Date: Wed,  6 Jul 2022 17:42:49 +0100
Message-Id: <20220706164304.1582687-5-maz@kernel.org>
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

Make sure the check occurs on every paths where we can pick
a sysreg from userspace, including the GICv3 paths.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0fbdb21a3600..89e7eddea937 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2656,6 +2656,10 @@ const struct sys_reg_desc *get_reg_by_id(u64 id,
 {
 	struct sys_reg_params params;
 
+	/* 64 bit is the only way */
+	if (KVM_REG_SIZE(id) != sizeof(__u64))
+		return NULL;
+
 	if (!index_to_params(id, &params))
 		return NULL;
 
@@ -2871,9 +2875,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_get(reg->id, uaddr);
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
-		return -ENOENT;
-
 	err = get_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
 		return err;
@@ -2906,9 +2907,6 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
 		return demux_c15_set(reg->id, uaddr);
 
-	if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
-		return -ENOENT;
-
 	err = set_invariant_sys_reg(reg->id, uaddr);
 	if (err != -ENOENT)
 		return err;
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
