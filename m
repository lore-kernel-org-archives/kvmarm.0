Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6D2808
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77078C433EF;
	Tue, 31 Jan 2023 09:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675158171;
	bh=R9R8lSJiZlGHXpk1NuhDArGYtHjEsAnmxDGWI+EDPbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhJ6P6JM67Dve40ZbjsDCX3n4VeWxLIhE1Op5dPKxfCLP6Vy73CmFdtQIH6lj6FRM
	 7Vkh7l5j+OpRymdDTLQSwglMA4JMX6TEbhKMFeo5lSiYNR1zgkA/yYKTH5IkzjjtiK
	 KL2lN6OBwaj2LmRzP52hbNZQjvle3H1z5gva7gmmbPaWvuhCP7FyPB3ASxWWrzkliJ
	 m+JJljE/UD2EISlC/ShLxo4AVxPRJT3lv5CwDQiepUFSrQoXp+GvKy/2BXatZHk86k
	 1cojyEL2rSlIXpW/iA3a3A9m/0s3DwQTvZ76mINbqag/++5fo3NLXEpBwmcAyIGCzV
	 LZX2kYn8dPHsQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtw-0067U2-5k;
	Tue, 31 Jan 2023 09:26:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 63/69] KVM: arm64: nv: Publish emulated timer interrupt state in the in-memory state
Date: Tue, 31 Jan 2023 09:24:58 +0000
Message-Id: <20230131092504.2880505-64-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With FEAT_NV2, the EL0 timer state is entirely stored in memory,
meaning that the hypervisor can only provide a very poor emulation.

The only thing we can really do is to publish the interrupt state
in the guest view of CNT{P,V}_CTL_EL0, and defer everything else
to the next exit.

Only FEAT_ECV will allow us to fix it, at the cost of extra trapping.

Suggested-by: Chase Conklin <chase.conklin@arm.com>
Suggested-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index cc308310c0a0..f9e98dd5c100 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -450,6 +450,25 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 {
 	int ret;
 
+	/*
+	 * Paper over NV2 brokenness by publishing the interrupt status
+	 * bit. This still results in a poor quality of emulation (guest
+	 * writes will have no effect until the next exit).
+	 *
+	 * But hey, it's fast, right?
+	 */
+	if (vcpu_has_nv2(vcpu) && is_hyp_ctxt(vcpu) &&
+	    (timer_ctx == vcpu_vtimer(vcpu) || timer_ctx == vcpu_ptimer(vcpu))) {
+		u32 ctl = timer_get_ctl(timer_ctx);
+
+		if (new_level)
+			ctl |= ARCH_TIMER_CTRL_IT_STAT;
+		else
+			ctl &= ~ARCH_TIMER_CTRL_IT_STAT;
+
+		timer_set_ctl(timer_ctx, ctl);
+	}
+
 	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
 				   timer_ctx->irq.level);
-- 
2.34.1

