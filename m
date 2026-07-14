Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD0B43FD16;
	Tue, 14 Jul 2026 09:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020615; cv=none; b=VIoVt+0ymGOoOIbbGnq+UHvHfaFs6NPekcuTtTMWcwwGQwHDFArkdaHB6pxVw9f6M4E92cyQqnKhBNVFYG9Mq9qYIr5Kc6IgcYTXuQzqVNCmdnKNk8c8H0nNAMdZriaQS6+1a2ZofU2kq3LTip52LN+AxQ+CSAYEVJjslfpNDus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020615; c=relaxed/simple;
	bh=1a6g0FUNYjctw5B94xyjRpZGAbx7YJm1TxMbIoRmB4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekVX62+L6JEQ10zLg1LYuH7cJJ/HSesbfsVDPLr2h62PlbGsmVrVsdko95jXKuKBiRjr1k1CNWRTU8M+mZaP7C0ooKqtDcTpTT0/ti9LIu+aT1Rvqiioy97xVsfVZsQlqKUd18mHl5WSOxDEkZ70dFsegH5SX/lDWofzmU4fO4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPPhm3ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPPhm3ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523911F00A3F;
	Tue, 14 Jul 2026 09:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020613;
	bh=xvfRoiVVXMz5ozRg++qNQ5fER4Qs3LDX4/NpXBs7HWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPPhm3ipRTn9UEcw0D+gG6VXh5CQPmHZHJQBYnTTvRp3URDCgWHgd006TGZv4kV//
	 wXnmn9YxLyegZnXQuhUvqGd4//5N7lx4rtK9kFGBKiszOeURKmIhCpj6tZ2TJ+yyx8
	 J14UvC57im1+VA14FLOoXOYUHpY+Bnqlhjg6k+D4EZUnecI3BpzhmbUr1vEbYFzcWl
	 XE+WzBu5bTgW7j9P/kpH9qeJ5TZdeDmrCZIekOt6iULyHoLzaxSu/yQEAmAsakOjzq
	 LE+mz13BA9WePowK+REWSru3oM7kEbbK/4TLLISgI6NdPKd4i+SFORe+yo5j4FAxIQ
	 cFwi8Ay/WS7Ww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFz-00000004ny1-2f9H;
	Tue, 14 Jul 2026 09:16:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 22/28] KVM: arm64: Add routing for NVHCR_EL2 trap
Date: Tue, 14 Jul 2026 10:16:35 +0100
Message-ID: <20260714091641.1970822-23-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

NVHCR_EL2 accesses from EL1 are taken to EL2 when HCRX_EL2.NVTGE==0
and HCR_EL2.NV==1. Describe this in the exception routing tables.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b7f3d86a94031..625604019fb32 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -136,6 +136,8 @@ enum cgt_group_id {
 	CGT_CPTR_TTA,
 	CGT_MDCR_HPMN,
 
+	CGT_HCR_NV_HCRX_nNVTGE,
+
 	/* Must be last */
 	__NR_CGT_GROUP_IDS__
 };
@@ -588,6 +590,15 @@ static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
 	return BEHAVE_HANDLE_LOCALLY;
 }
 
+static enum trap_behaviour check_hcr_nv_hcrx_nnvtge(struct kvm_vcpu *vcpu)
+{
+	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
+	    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE))
+		return BEHAVE_FORWARD_RW;
+
+	return BEHAVE_HANDLE_LOCALLY;
+}
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
@@ -598,6 +609,7 @@ static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1NVVCT, check_cnthctl_el1nvvct),
 	CCC(CGT_CPTR_TTA, check_cptr_tta),
 	CCC(CGT_MDCR_HPMN, check_mdcr_hpmn),
+	CCC(CGT_HCR_NV_HCRX_nNVTGE, check_hcr_nv_hcrx_nnvtge),
 };
 
 /*
@@ -853,6 +865,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_SCTLR2_EL2,		CGT_HCR_NV),
 	SR_RANGE_TRAP(SYS_HCR_EL2,
 		      SYS_HCRX_EL2,	CGT_HCR_NV),
+	SR_TRAP(SYS_NVHCR_EL2,		CGT_HCR_NV_HCRX_nNVTGE),
 	SR_TRAP(SYS_SMPRIMAP_EL2,	CGT_HCR_NV),
 	SR_TRAP(SYS_SMCR_EL2,		CGT_HCR_NV),
 	SR_RANGE_TRAP(SYS_TTBR0_EL2,
-- 
2.47.3

