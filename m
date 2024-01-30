Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC8B71B50
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647550; cv=none; b=DnhTgSr9fkXQJ04RFWkgGpQdSZ5zK9qj36v1fkLDpvQ2bqZYRt/EtRLdIodpAtPq7HRvccBiMzNqXJg+U+xmF9OAWY6JbTH6iwvKlkAFP+Qqrrzyk9R08wUcMMV016XAAn2CxHssj+C8reR5l+6okjWjrVfnzWV/IPiHUoXg2mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647550; c=relaxed/simple;
	bh=kkTtFQBCidaSqd2ytOnVK9FgRjoyzbq4OytuNCRdmhA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fy9DzWiErsVV3VWLVLbzIc10QmgtKFCXVGxtJanerL05FW1B2ETfoMQRcH96JHXUHpS7rvlYe7+Dc/fQXGQKYnDH/h7oiNyXCEsBaYW0tWy9QMcIC5nnMKagoaBoikTbIPK/G6yXoSzhjs7ldD49MnzSKQyrwrxjFgckcEx4OFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohXJNFhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohXJNFhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9CBC43394;
	Tue, 30 Jan 2024 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647550;
	bh=kkTtFQBCidaSqd2ytOnVK9FgRjoyzbq4OytuNCRdmhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohXJNFhFig+S9x8hxYuIL9dN47ySxhUFqwVIbwvQ9GpQXmijYpGFqzUzX3LL4cHcs
	 RLwPqsqJUPk0rBGxJ4dq7AVb/TywLuTmLwJ26AeRIFGqNP9LU+5m0ND7sJOs1OCtme
	 fd1LFvDlGvSY/caKcKKWfTvM2Zr1h+XQAnkL9Yz0qK6Hdbr1nApGb1qhF4yKRERxQw
	 i0hNJHzcjLkJ4uFpOZHOg6pB/gn/Zx7FxJ6j0+PEITdoIWnc7vDr8N8JgDCe1tGW8o
	 EdytuED0FDQJjy4ltz09saj1qr9e5+eH+MnFNWsrtgz5zyX5CO0i9j/sRisLET+blH
	 +VO/4kVnszoKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzM-00GNsE-0W;
	Tue, 30 Jan 2024 20:45:48 +0000
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
Subject: [PATCH v2 16/25] KVM: arm64: Rename __check_nv_sr_forward() to triage_sysreg_trap()
Date: Tue, 30 Jan 2024 20:45:23 +0000
Message-Id: <20240130204533.693853-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
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

__check_nv_sr_forward() is not specific to NV anymore, and does
a lot more. Rename it to triage_sysreg_trap(), making it plain
that its role is to handle where an exception is to be handled.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 1 -
 arch/arm64/kvm/emulate-nested.c     | 2 +-
 arch/arm64/kvm/sys_regs.c           | 2 +-
 arch/arm64/kvm/sys_regs.h           | 2 ++
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 68465f87d308..c77d795556e1 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -60,7 +60,6 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
-extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_idx);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 5aeaa688755f..4f2a32a8f247 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2007,7 +2007,7 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
 	return !(kvm_get_sysreg_res0(kvm, sr) & BIT(tc.bit));
 }
 
-bool __check_nv_sr_forward(struct kvm_vcpu *vcpu, int *sr_index)
+bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 {
 	union trap_config tc;
 	enum trap_behaviour b;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bc076ef8440b..938df5dc3684 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3482,7 +3482,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 
-	if (__check_nv_sr_forward(vcpu, &sr_idx))
+	if (triage_sysreg_trap(vcpu, &sr_idx))
 		return 1;
 
 	params = esr_sys64_to_params(esr);
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index c65c129b3500..997eea21ba2a 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -233,6 +233,8 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 			 const struct sys_reg_desc table[], unsigned int num);
 
+bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
+
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
-- 
2.39.2

