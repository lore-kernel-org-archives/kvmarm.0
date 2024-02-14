Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54A9537E3
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916715; cv=none; b=p3u8ljvl/yJETBoNlmByffKhSUbg1X34Jc0wNXt7MLnyYcsX7+gFqTksnmgHR6dqI0ibZWqJFoDd0TBvTWKneEtvvCwzmAvpZXpoWvmh3P6nvKIlg5O/1pC1wGgokOXoMohF1/PsK5UIV+v51597jJ0dVpjHNUPgmEa8xIDHTOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916715; c=relaxed/simple;
	bh=EiYLtlyM+BkOfb8dL1ZfPLQrysQ+RYZhPwZ4fT+TTsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iQzz3RsvfS51prKNuL5hzSNyS9haxB8qTufqRv4infKCDWgJcibZg4/mePXV9GZHxfv4z3YZHWa+qzGrgXRUFjTqG4poA9RHzCq92HLbQS4UrxcrH2KW6m6Ilqe6+fMGiT3GxaE2Crn9USTqm71vcgQehpVl/RF5JWCwYaEESt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLG7Wpnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLG7Wpnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874C4C43399;
	Wed, 14 Feb 2024 13:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916715;
	bh=EiYLtlyM+BkOfb8dL1ZfPLQrysQ+RYZhPwZ4fT+TTsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLG7WpnzNgV+kuzMQQ1nhyqTcc6AMtiIpV5QYgA5MpjhYHoFzA/s5Y/6m5tg2zaJQ
	 PYoDe7sSlmuHoCPmogrQQfS29GH1iOELhH2lrwB8qqkXO4IwSIiEEZr5VKNVOimwk+
	 m6gJzgUnqYnwSmepu/eQtQ/oPqFRSLKA5huMkIp9k0jKDq0nGm4MwSPrhz8BtFfCFC
	 hzFdtgu2CgWE1uV29ltccbaYrkjpalCSpPhatkCyEWgDkxMoHDXFvfvpb1y1XtqnxW
	 vqQLt+BIFwI49cOkdGmtpqHsw4YZPDAF8tYYg4BS1hfYmhufOVfkokWpIDfkD01iTF
	 sGxurHeiWR6zg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9l-00394l-JP;
	Wed, 14 Feb 2024 13:18:33 +0000
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
Subject: [PATCH v4 14/26] KVM: arm64: Register AArch64 system register entries with the sysreg xarray
Date: Wed, 14 Feb 2024 13:18:15 +0000
Message-Id: <20240214131827.2856277-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
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

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/emulate-nested.c   | 39 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/sys_regs.c         | 11 ++++++++-
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8cda003d6267..914fd54179bb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1078,6 +1078,9 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
 int __init kvm_sys_reg_table_init(void);
+struct sys_reg_desc;
+int __init populate_sysreg_config(const struct sys_reg_desc *sr,
+				  unsigned int idx);
 int __init populate_nv_trap_config(void);
 
 bool lock_all_vcpus(struct kvm *kvm);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 42f5b4483c80..ddf760b4dda5 100644
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
+#define TC_SRI_BITS	10
 
 union trap_config {
 	u64	val;
@@ -442,7 +444,8 @@ union trap_config {
 		unsigned long	bit:6;		 /* Bit number */
 		unsigned long	pol:1;		 /* Polarity */
 		unsigned long	fgf:TC_FGF_BITS; /* Fine Grained Filter */
-		unsigned long	unused:37;	 /* Unused, should be zero */
+		unsigned long	sri:TC_SRI_BITS; /* SysReg Index */
+		unsigned long	unused:27;	 /* Unused, should be zero */
 		unsigned long	mbz:1;		 /* Must Be Zero */
 	};
 };
@@ -1868,6 +1871,38 @@ int __init populate_nv_trap_config(void)
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
+	if (idx >= (BIT(TC_SRI_BITS) - 1)) {
+		kvm_err("sysreg %s (%d) out of range\n", sr->name, idx);
+		return -EINVAL;
+	}
+
+	encoding = sys_reg(sr->Op0, sr->Op1, sr->CRn, sr->CRm, sr->Op2);
+	tc = get_trap_config(encoding);
+
+	if (tc.sri) {
+		kvm_err("sysreg %s (%d) duplicate entry (%d)\n",
+			sr->name, idx - 1, tc.sri);
+		return -EINVAL;
+	}
+
+	tc.sri = idx + 1;
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
index 57f3d0c53fc3..a410e99f827e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3972,6 +3972,7 @@ int __init kvm_sys_reg_table_init(void)
 	struct sys_reg_params params;
 	bool valid = true;
 	unsigned int i;
+	int ret = 0;
 
 	/* Make sure tables are unique and in order. */
 	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
@@ -3995,5 +3996,13 @@ int __init kvm_sys_reg_table_init(void)
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

