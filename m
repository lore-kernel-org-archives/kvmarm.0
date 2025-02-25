Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382FE440C
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 00:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740444858; cv=none; b=MqWwoPRzqONALXEgoEELKASTHmAjpGG6GZriVY6skPPZXLsCOi+jkGX8oaNsjepgbyEC/lRv5GU53u3besR50oHtyWN/VVBMmciicTW62rGwXBza9ybzp/Q1yRERrf+58w1SReCry8ahWmB6fJcUgWCYZgXLMvfCoJhstSMwXAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740444858; c=relaxed/simple;
	bh=kn3KSikc4OQ6YMQFjkSXdqIfqtGHl/n7MT62OoYTVNg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sBhrZXMioV+oFT39J2ktMnCdmr9DjO2A3litO/EHjx0+gLrCiE3zqjV9i3idbI8iX9za52aiZYguBjyDABfECP2oGIPNhMI3/c7arevWm0m5UtelY1cRf5xa/BRUnUgHJvWNYm/mCtk0YblsNB1kO2JolV1AI1vbzCIe4oAEzFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=utuZWnCr; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="utuZWnCr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740444855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/uyGg2C6XpYRON4kpdzxQ7BFVLsGm/sKldropUoIp7w=;
	b=utuZWnCrKZU953SzEdqJCLBu7mpDzeIknEBhOnTuNiUHhMC38Ma7tB9+cYvTtWGMQpUZVJ
	XlNHyTEMIMApdxBocpc6CsjRzOXvMEiW8VB/CTAzw3zHuLzXCIGq+p+/SizpnoOuQBUR4n
	hcJ15DqHLeLoqNChnqHkrsPupUpYxkc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 2/5] KVM: arm64: Maintain per-VM copy of implementation ID regs
Date: Mon, 24 Feb 2025 16:53:58 -0800
Message-Id: <20250225005401.679536-3-oliver.upton@linux.dev>
In-Reply-To: <20250225005401.679536-1-oliver.upton@linux.dev>
References: <20250225005401.679536-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Sebastian Ott <sebott@redhat.com>

Get ready to allow changes to the implementation ID registers by
tracking the VM-wide values.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  9 +++++++
 arch/arm64/kvm/sys_regs.c         | 43 ++++++++++++++++---------------
 2 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..bc5e8a5620ac 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -373,6 +373,9 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	u64 midr_el1;
+	u64 revidr_el1;
+	u64 aidr_el1;
 	u64 ctr_el0;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
@@ -1471,6 +1474,12 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 		return &ka->id_regs[IDREG_IDX(reg)];
 	case SYS_CTR_EL0:
 		return &ka->ctr_el0;
+	case SYS_MIDR_EL1:
+		return &ka->midr_el1;
+	case SYS_REVIDR_EL1:
+		return &ka->revidr_el1;
+	case SYS_AIDR_EL1:
+		return &ka->aidr_el1;
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f25a157622e3..de66ffab3a2b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1653,15 +1653,24 @@ static bool is_feature_id_reg(u32 encoding)
  * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
  * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8, which is the range of ID
  * registers KVM maintains on a per-VM basis.
+ *
+ * Additionally, the implementation ID registers and CTR_EL0 are handled as
+ * per-VM registers.
  */
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
-	if (id == SYS_CTR_EL0)
+	switch (id) {
+	case SYS_CTR_EL0:
+	case SYS_MIDR_EL1:
+	case SYS_REVIDR_EL1:
+	case SYS_AIDR_EL1:
 		return true;
+	default:
+		return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+			sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+			sys_reg_CRm(id) < 8);
 
-	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
-		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
-		sys_reg_CRm(id) < 8);
+	}
 }
 
 static inline bool is_vcpu_ftr_id_reg(u32 id)
@@ -2530,36 +2539,27 @@ static void init_imp_id_regs(void)
 	boot_cpu_aidr_val = read_sysreg(aidr_el1);
 }
 
-static int get_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
-			  u64 *val)
+static u64 reset_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	switch (reg_to_encoding(r)) {
 	case SYS_MIDR_EL1:
-		*val = boot_cpu_midr_val;
-		break;
+		return boot_cpu_midr_val;
 	case SYS_REVIDR_EL1:
-		*val = boot_cpu_revidr_val;
-		break;
+		return boot_cpu_revidr_val;
 	case SYS_AIDR_EL1:
-		*val = boot_cpu_aidr_val;
-		break;
+		return boot_cpu_aidr_val;
 	default:
-		WARN_ON_ONCE(1);
-		return -EINVAL;
+		KVM_BUG_ON(1, vcpu->kvm);
+		return 0;
 	}
-
-	return 0;
 }
 
 static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 			  u64 val)
 {
 	u64 expected;
-	int ret;
 
-	ret = get_imp_id_reg(vcpu, r, &expected);
-	if (ret)
-		return ret;
+	expected = read_id_reg(vcpu, r);
 
 	return (expected == val) ? 0 : -EINVAL;
 }
@@ -2567,8 +2567,9 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 #define IMPLEMENTATION_ID(reg) {			\
 	SYS_DESC(SYS_##reg),				\
 	.access = access_imp_id_reg,			\
-	.get_user = get_imp_id_reg,			\
+	.get_user = get_id_reg,				\
 	.set_user = set_imp_id_reg,			\
+	.reset = reset_imp_id_reg,			\
 }
 
 /*
-- 
2.39.5

