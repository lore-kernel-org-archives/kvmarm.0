Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3278476
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71F2C433D2;
	Thu, 12 Jan 2023 19:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673551385;
	bh=B2UGwJzMvIEL5YSulq4rwvpwt8lkvBwkyyycfl48TZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Co0rphiQF+VvnEbDFccrDhvKe5QxKCEDs3s6vmTMDhTg9ShPMTycMq+jDMGoL8xPg
	 rF+bYv8p3TRShlAOsUvvwrLrZ3yQIvohbH1jJIaoLZ1bD7SCTIcaukFpAhRFnILFKG
	 tFtrrDwTG9+zgeRx4yd4XLeaXm10wpo2fMZEV7eyLIj5NzTQi1jY319bTAnKJ+7MfQ
	 d5nP0u7LHscuAFD5xBBXxIyOpCXwRkxgfl7qLYMedBymvXZFpREggphKX/Go/t3Tp5
	 CUuwQLlKn6m6BDrdOvjkT4QKZP39SROBf2lhKwMr7lg88uPS3ZBP/busFMH0vB0sIq
	 S2DKXKYps2pVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pG36y-001IWu-Vw;
	Thu, 12 Jan 2023 19:19:41 +0000
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
Subject: [PATCH v7 15/68] KVM: arm64: nv: Handle HCR_EL2.E2H specially
Date: Thu, 12 Jan 2023 19:18:34 +0000
Message-Id: <20230112191927.1814989-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
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

HCR_EL2.E2H is nasty, as a flip of this bit completely changes the way
we deal with a lot of the state. So when the guest flips this bit
(sysregs are live), do the put/load dance so that we have a consistent
state.

Yes, this is slow. Don't do it.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9a2f4861395..0d1b02701524 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -179,9 +179,24 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		goto memory_write;
 
 	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
+		bool need_put_load;
+
 		if (!is_hyp_ctxt(vcpu))
 			goto memory_write;
 
+		/*
+		 * HCR_EL2.E2H is nasty: it changes the way we interpret a
+		 * lot of the EL2 state, so treat is as a full state
+		 * transition.
+		 */
+		need_put_load = ((reg == HCR_EL2) &&
+				 vcpu_el2_e2h_is_set(vcpu) != !!(val & HCR_E2H));
+
+		if (need_put_load) {
+			preempt_disable();
+			kvm_arch_vcpu_put(vcpu);
+		}
+
 		/*
 		 * Always store a copy of the write to memory to avoid having
 		 * to reverse-translate virtual EL2 system registers for a
@@ -189,6 +204,11 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		 */
 		__vcpu_sys_reg(vcpu, reg) = val;
 
+		if (need_put_load) {
+			kvm_arch_vcpu_load(vcpu, smp_processor_id());
+			preempt_enable();
+		}
+
 		switch (reg) {
 		case ELR_EL2:
 			write_sysreg_el1(val, SYS_ELR);
-- 
2.34.1

