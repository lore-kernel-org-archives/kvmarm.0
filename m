Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C440C17
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954740; cv=none; b=TJUUqVlzyRppbG7IF/VXkqE2S3d4X7QQkbBacD35ftkpe+k8dLebkV6uhPiSRQjhGIiFUP8KyOE/nU/eFILH/RRHHSigkX2tTH5fIMmNmlVjeGiQXVjt9yWTnChZS9zBQrqVK8tOXR9wn0qhUzygi80Tf3tsClzouas7/AgO1Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954740; c=relaxed/simple;
	bh=vnTg5ddvKH7ipD3l9ynT2DfFJPz15UYnSDJE0dciOOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EEqZzSSlP5mf72hzeL+X+IuxvF0Fm462TFgAtgPGAOA62hgh/O1K05u2cHB0s8VXJAP08kIRS5DY2fuvolLnwiYi9pjVd3havO3PM52OD6euDXzrZY6OEJ64cNpgKvPSYVB9ub7sqONUAi9HgDBRl+YMrRBJwmGyNR3ZE5EU2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmZFf+4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmZFf+4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220A9C43399;
	Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954740;
	bh=vnTg5ddvKH7ipD3l9ynT2DfFJPz15UYnSDJE0dciOOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmZFf+4pky3if0IVGuqBuC7wQlUe0hYdgcB+YhevywRm5lATJmB1EU7VWD7Bu4fpG
	 ecmr/BWFm9zzFX9rjAcbGHSEr13LBY6miQVsIKHRSQuyMWXhKsnK7HA6a1op4LvQNc
	 49tfemcx6VRLJXM55v0Ry82VfpYV5ZYxFnNPTJnou60yr3+e6OwWve65MKj76sLw0W
	 qFRBBbirW6Q3tCvW6+xTwe+zfwUFoX7bqYH1e2t8U7WPr4P3Ho2ZuLfk1kBFQiqtOv
	 zfYAFfZjFZt/SrSNBNTSGJaws6XWHZ6trRcV0FGuLIT6TaWJB9hOJi+SsTAX3PVYrl
	 IUcPL2LD2MEFg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l0-00DjkQ-8U;
	Mon, 22 Jan 2024 20:18:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 14/25] KVM: arm64: Register AArch64 system register entries with the sysreg xarray
Date: Mon, 22 Jan 2024 20:18:41 +0000
Message-Id: <20240122201852.262057-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to reduce the number of lookups that we have to perform
when handling a sysreg, register each AArch64 sysreg descriptor
with the global xarray. The index of the descriptor is stored
as a 10 bit field in the data word.

Subsequent patches will retrieve and use the stored index.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/emulate-nested.c   | 39 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/sys_regs.c         | 11 ++++++++-
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe35c59214ad..e7a6219f2929 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1083,6 +1083,9 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
 int __init kvm_sys_reg_table_init(void);
+struct sys_reg_desc;
+int __init populate_sysreg_config(const struct sys_reg_desc *sr,
+				  unsigned int idx);
 int __init populate_nv_trap_config(void);
 
 bool lock_all_vcpus(struct kvm *kvm);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 59622636b723..342d43b66fda 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -427,12 +427,14 @@ static const complex_condition_check ccc[] = {
  * [19:14]	bit number in the FGT register (6 bits)
  * [20]		trap polarity (1 bit)
  * [25:21]	FG filter (5 bits)
- * [62:26]	Unused (37 bits)
+ * [35:26]	Main SysReg table index (10 bits)
+ * [62:36]	Unused (27 bits)
  * [63]		RES0 - Must be zero, as lost on insertion in the xarray
  */
 #define TC_CGT_BITS	10
 #define TC_FGT_BITS	4
 #define TC_FGF_BITS	5
+#define TC_MSR_BITS	10
 
 union trap_config {
 	u64	val;
@@ -442,7 +444,8 @@ union trap_config {
 		unsigned long	bit:6;		 /* Bit number */
 		unsigned long	pol:1;		 /* Polarity */
 		unsigned long	fgf:TC_FGF_BITS; /* Fine Grained Filter */
-		unsigned long	unused:37;	 /* Unused, should be zero */
+		unsigned long	msr:TC_MSR_BITS; /* Main SysReg index */
+		unsigned long	unused:27;	 /* Unused, should be zero */
 		unsigned long	mbz:1;		 /* Must Be Zero */
 	};
 };
@@ -1862,6 +1865,38 @@ int __init populate_nv_trap_config(void)
 	return ret;
 }
 
+int __init populate_sysreg_config(const struct sys_reg_desc *sr,
+				  unsigned int idx)
+{
+	union trap_config tc;
+	u32 encoding;
+	void *ret;
+
+	/*
+	 * 0 is a valid value for the index, but not for the storage.
+	 * We'll store (idx+1), so check against an offset'd limit.
+	 */
+	if (idx >= (BIT(TC_MSR_BITS) - 1)) {
+		kvm_err("sysreg %s (%d) out of range\n", sr->name, idx);
+		return -EINVAL;
+	}
+
+	encoding = sys_reg(sr->Op0, sr->Op1, sr->CRn, sr->CRm, sr->Op2);
+	tc = get_trap_config(encoding);
+
+	if (tc.msr) {
+		kvm_err("sysreg %s (%d) duplicate entry (%d)\n",
+			sr->name, idx - 1, tc.msr);
+		return -EINVAL;
+	}
+
+	tc.msr = idx + 1;
+	ret = xa_store(&sr_forward_xa, encoding,
+		       xa_mk_value(tc.val), GFP_KERNEL);
+
+	return xa_err(ret);
+}
+
 static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
 					 const struct trap_bits *tb)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 77cd818c23b0..65319193e443 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3974,6 +3974,7 @@ int __init kvm_sys_reg_table_init(void)
 	struct sys_reg_params params;
 	bool valid = true;
 	unsigned int i;
+	int ret = 0;
 
 	/* Make sure tables are unique and in order. */
 	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
@@ -3997,5 +3998,13 @@ int __init kvm_sys_reg_table_init(void)
 	if (!first_idreg)
 		return -EINVAL;
 
-	return populate_nv_trap_config();
+	ret = populate_nv_trap_config();
+
+	for (i = 0; !ret && i < ARRAY_SIZE(sys_reg_descs); i++)
+		ret = populate_sysreg_config(sys_reg_descs + i, i);
+
+	for (i = 0; !ret && i < ARRAY_SIZE(sys_insn_descs); i++)
+		ret = populate_sysreg_config(sys_insn_descs + i, i);
+
+	return ret;
 }
-- 
2.39.2

