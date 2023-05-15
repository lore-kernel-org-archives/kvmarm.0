Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C9BFBF6
	for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 17:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C08C433EF;
	Mon, 15 May 2023 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684172875;
	bh=OP9zUGwP8iltF698WsVKx5VGN0i7zVhdo+nQClGUotk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuSLCDpB6jh/YKgGRh83X/UMWWBDxdpyAqUkx3FybIjeEzJy0CXbiBt3ZmuWAm5WD
	 qNpd4B56Z3UHAu9ftOUCQ2mLtRLYoALs5tA11NaVKgOECcX9Yz9Sb0Ybq/mc3hcitr
	 Smbh7nVvVGeAIAhRN+uSTS1VWRklLYTn77L2yyVDCa933NktJ1ZxuuoE5d5Ew5wXYT
	 AoXlXPwD6R61d2cNSL1/0U4mkEgFQQmLrlhw5OXLlnlBrAtQUWrQa8emMrcQC4cMG7
	 obzw0fdNtwkNJtGTzWdKdH3qPCwz9a2wPoFWxiw3Q/Jgbn6fSnJ2iysQSi9Z1n2XP+
	 eETzLHSsVYUwg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pyc2i-00FJAF-JN;
	Mon, 15 May 2023 18:31:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 20/59] KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
Date: Mon, 15 May 2023 18:30:24 +0100
Message-Id: <20230515173103.1017669-21-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Jintack Lim <jintack.lim@linaro.org>

For the same reason we trap virtual memory register accesses in virtual
EL2, we trap CPACR_EL1 access too; We allow the virtual EL2 mode to
access EL1 system register state instead of the virtual EL2 one.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +++
 arch/arm64/kvm/sys_regs.c       | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 14880c84678f..8d1a6b007c19 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -68,6 +68,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
+		val |= CPTR_EL2_TCPAC;
+	
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 28b882b79d3e..52d798dbc202 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2065,7 +2065,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
-	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
+	{ SYS_DESC(SYS_CPACR_EL1), access_rw, reset_val, CPACR_EL1, 0 },
 
 	MTE_REG(RGSR_EL1),
 	MTE_REG(GCR_EL1),
-- 
2.34.1

