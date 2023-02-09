Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DB1A920
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 18:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8970EC433D2;
	Thu,  9 Feb 2023 18:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675966255;
	bh=bvKB/niBnOc/ZdVNTmvtXUHucGexqrHDsffJo0FAtc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huSAXsO2Wv3N74QsMv5iyqWVl7npB8kYX6xKvrSijYrqLTHoM2vyh41TBb6/llXxS
	 NdRV871PwWkOXw4IDoLONMBH0FNcDZ7ZapC7Vc8x2zRCBXppzUGyxX2jFsr7N0oqzR
	 Dtr4B1CCgGsqj866QnugN2fmHrlb24DCd9NDMomoXrN/0nHPlgFKCVlb4ZO/uta0dr
	 x1GqtuobfMu/b4qnEMYAwMmmUHXKX9mjH3joWp5tk+D3uTrwL7BaRKpy3b916F1+6t
	 xicJ73mtz5IjRq33/KAXAfGKfdZqP4Nut4zFNSWzz82C33JDCecN+UID6qseqS2461
	 LDtAMZXRTm+EQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pQBC5-0093r7-Qe;
	Thu, 09 Feb 2023 17:58:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 16/18] KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
Date: Thu,  9 Feb 2023 17:58:18 +0000
Message-Id: <20230209175820.1939006-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Jintack Lim <jintack.lim@linaro.org>

With HCR_EL2.NV bit set, accesses to EL12 registers in the virtual EL2
trap to EL2. Handle those traps just like we do for EL1 registers.

One exception is CNTKCTL_EL12. We don't trap on CNTKCTL_EL1 for non-VHE
virtual EL2 because we don't have to. However, accessing CNTKCTL_EL12
will trap since it's one of the EL12 registers controlled by HCR_EL2.NV
bit.  Therefore, add a handler for it and don't treat it as a
non-trap-registers when preparing a shadow context.

These registers, being only a view on their EL1 counterpart, are
permanently hidden from userspace.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: EL12_REG(), register visibility]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 55a14c86a455..f5dd4f4eaaf0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1482,6 +1482,26 @@ static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+/*
+ * EL{0,1}2 registers are the EL2 view on an EL0 or EL1 register when
+ * HCR_EL2.E2H==1, and only in the sysreg table for convenience of
+ * handling traps. Given that, they are always hidden from userspace.
+ */
+static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	return REG_HIDDEN_USER;
+}
+
+#define EL12_REG(name, acc, rst, v) {		\
+	SYS_DESC(SYS_##name##_EL12),		\
+	.access = acc,				\
+	.reset = rst,				\
+	.reg = name##_EL1,			\
+	.val = v,				\
+	.visibility = elx2_visibility,		\
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -2031,6 +2051,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 
+	EL12_REG(SCTLR, access_vm_reg, reset_val, 0x00C50078),
+	EL12_REG(CPACR, access_rw, reset_val, 0),
+	EL12_REG(TTBR0, access_vm_reg, reset_unknown, 0),
+	EL12_REG(TTBR1, access_vm_reg, reset_unknown, 0),
+	EL12_REG(TCR, access_vm_reg, reset_val, 0),
+	{ SYS_DESC(SYS_SPSR_EL12), access_spsr},
+	{ SYS_DESC(SYS_ELR_EL12), access_elr},
+	EL12_REG(AFSR0, access_vm_reg, reset_unknown, 0),
+	EL12_REG(AFSR1, access_vm_reg, reset_unknown, 0),
+	EL12_REG(ESR, access_vm_reg, reset_unknown, 0),
+	EL12_REG(FAR, access_vm_reg, reset_unknown, 0),
+	EL12_REG(MAIR, access_vm_reg, reset_unknown, 0),
+	EL12_REG(AMAIR, access_vm_reg, reset_amair_el1, 0),
+	EL12_REG(VBAR, access_rw, reset_val, 0),
+	EL12_REG(CONTEXTIDR, access_vm_reg, reset_val, 0),
+	EL12_REG(CNTKCTL, access_rw, reset_val, 0),
+
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
-- 
2.34.1

