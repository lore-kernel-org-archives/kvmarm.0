Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89E946DFE6
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784650597; cv=none; b=BHu97NJQqtZImrhnO3Qb7Ys1YNfPEMPmZ40QF0UjhBZex7ryE6l4DH2nUDAs0V/Mdf+zBxLZswljlOzSargjbpA/bionH6fQYfX8SLyJQ0hLR4E6UmJgMEh9mOauj+CF+MpoA57zRSbqtXBBUN7q29Dbx8jn+dF0NQQWZXnHRWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784650597; c=relaxed/simple;
	bh=YXT6mHKPZ0iP0KQL37ZrnzNk/pXN8owYCS1IkzbUAFc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qsNJjkNOE+H1yxMRr3vqjOok8Uy1fDwttSZ6DDDCtxVl30YO7a1iaXr0f5l9vEtS3HyhqFhAQ//uQRKwxr6Yj5WyxPygOAWKw+caAYj+5Q1m92YoXvXnKn96mTDo4Ff2WyMj29N+maP9bfX+Km+8xL/5acrT2qKF9Q8+L0lNVQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=krhs0h0y; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="krhs0h0y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784650592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JoSpYNH320RJAnts2pP5+Q3/u6oQENLYblI1/yJFWS4=;
	b=krhs0h0yLC3Ie0R0Zf6VGGryPmFh9clqMEO5lAAo0l3Lnb9I11mLsRJsotld+n4SKWnmuR
	iPxXWv3V8QwDupZdWwx+LE+O1e/HYPTk61yDM+0r1VH9Rxs2CDSAIdKI49aiNOgYI7LKBs
	PRyUy+XJYmyapZqa2QBg2rAyra6wxsY=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Sync SCTLR_EL1 when injecting an exception into a pVM
Date: Tue, 21 Jul 2026 17:16:24 +0100
Message-Id: <20260721161624.3983041-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When pKVM injects a synchronous exception into a protected guest,
enter_exception64() reads SCTLR_EL1 to set the new PSTATE's PAN and
SSBS bits. pKVM refreshes VBAR_EL1 from the live value before injecting
but not SCTLR_EL1, which is untrapped for protected guests, so a guest
that updates it and then traps takes the exception with stale PAN/SSBS.

Sync SCTLR_EL1 alongside VBAR_EL1.

Fixes: 798eb5978700 ("KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef exception")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Changes since v1 [1]:
 - Rebased onto v7.2-rc4; no functional change.

[1] https://lore.kernel.org/all/20260612102347.914994-1-tabba@google.com/

 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index b1411fb541397..8758c68017765 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -257,10 +257,11 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
 
 	/*
-	 * Make sure we have the latest update to VBAR_EL1, as pKVM
-	 * handles traps very early, before sysregs are resync'ed
+	 * Sync VBAR_EL1 and SCTLR_EL1, both read by enter_exception64(),
+	 * as pKVM handles traps before sysregs are resync'ed.
 	 */
 	__vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
+	__vcpu_assign_sys_reg(vcpu, SCTLR_EL1, read_sysreg_el1(SYS_SCTLR));
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
 

base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.39.5

