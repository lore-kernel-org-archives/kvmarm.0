Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7348CC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:07:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8364B0ED;
	Mon, 29 Nov 2021 15:07:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kblJcF927SZb; Mon, 29 Nov 2021 15:07:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C7604B1D4;
	Mon, 29 Nov 2021 15:07:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 408CF4B178
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nzkus65o+fxc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:07:08 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E8824B1A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:07 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 48411CE140F;
 Mon, 29 Nov 2021 20:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966E2C53FCD;
 Mon, 29 Nov 2021 20:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216423;
 bh=8Q0UoKsQ1/LEa+qH82lBUBclRYVG/wZJY3gepjlHcJ4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ho/ZRfPVLvxO15GsT0DOBx3SZPHVNE0BpXvmGZGKuILKZ7dwWlw3I9ptBk+wN6vss
 XPp6o3CpuXNbQZ3VAaWPWuOprWFQ0lvctAwZTV79ul4eVZbFmslSZK2PNLZvxYBAyK
 wR4Cvm/xhGbAkkDFGnbX9J5CnD3E464ByC61DraioaLpdBM7T0LkrKqCAcrBEiHsqg
 HDFIBj1lDDAtG4xMAy0ZnciK1lJNZUf11Bjhs9HbwoNWr1uVMAnEZXTciET1ubojkB
 egb1P3qun4F3Po6ez+5rPSKuEqTXFxHEBFD6f5iMGeTLMJtPjKJE1EylsDPSkwA8rV
 6RvsaaqlRvmHA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmr2-008gvR-1t; Mon, 29 Nov 2021 20:02:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 43/69] KVM: arm64: nv: Introduce sys_reg_desc.forward_trap
Date: Mon, 29 Nov 2021 20:01:24 +0000
Message-Id: <20211129200150.351436-44-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

From: Jintack Lim <jintack.lim@linaro.org>

This introduces a function prototype to determine if we need to forward
system instruction traps to the virtual EL2. The implementation of
forward_trap functions for each system instruction will be added in
later patches.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++++++
 arch/arm64/kvm/sys_regs.h | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3922ecc00869..77f07f960d84 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2598,6 +2598,14 @@ static void perform_access(struct kvm_vcpu *vcpu,
 	 */
 	BUG_ON(!r->access);
 
+	/*
+	 * Forward this trap to the virtual EL2 if the guest hypervisor has
+	 * configured to trap the current instruction.
+	 */
+	if (nested_virt_in_use(vcpu) && r->forward_trap
+	    && unlikely(r->forward_trap(vcpu)))
+		return;
+
 	/* Skip instruction if instructed so */
 	if (likely(r->access(vcpu, params, r)))
 		kvm_incr_pc(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index d260c26b1834..267b2f37444c 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -72,6 +72,12 @@ struct sys_reg_desc {
 	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			const struct kvm_one_reg *reg, void __user *uaddr);
 
+	/*
+	 * Forward the trap to the virtual EL2 if the guest hypervisor has
+	 * configured to trap the current instruction.
+	 */
+	bool (*forward_trap)(struct kvm_vcpu *vcpu);
+
 	/* Return mask of REG_* runtime visibility overrides */
 	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
