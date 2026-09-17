Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF05A4A4EF4
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 21:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789681377; cv=none; b=uWeFLyevdqnj6rICl79TvMTdl6xBsO1CCRPwyQq5F5G7WLFUZHz1G27KaUUP8NfmpctYcpGdjbihrtCkVdymhmia7kLcN1UAvw793b6mxSx6q5DQIRBSTk5N0brrvJaBbgrqC4SWiLcqbT6dVxaLyPzdjuO7/r2XApd8WdxeBmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789681377; c=relaxed/simple;
	bh=+w+K3RyabmLpuqtKSmYuMaQ4+sQQEcnPLOH8AtHmFDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEmPD9I8b5W5GczgPSqeO0BKBT+289nUym7VofYqzMXzKro75Jb8WubTuHQ1jUn4zQ+0fRDXPxBHGY9GLYphOrNhqEtuZxfWIx2D14wSQWZuRyGyavRjaA4RRMwAYYtwkNx1saF4Xo7qZVuN0GjkeiZ836X6TzOwOEEL4Qi+V0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AilCQqIG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AilCQqIG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 077951596;
	Thu, 17 Sep 2026 14:42:47 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6697A3F7B4;
	Thu, 17 Sep 2026 14:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789681370; bh=+w+K3RyabmLpuqtKSmYuMaQ4+sQQEcnPLOH8AtHmFDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AilCQqIGPWmkwXPA3QPx47V8r7tEAHPf6dVVvrVNYkx0D8kz9embwVVG34yron5qN
	 i2I1lbxJKB8XfOwNPUVVHJHRuisSAzYgvRiSxjzcSJWimFU4NnzWyT/k12IH/WPYIF
	 we4ZZ5Fy8DTuYiwQKCeKalfh4INCHl64X5r41rAM=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	James Clark <james.clark@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Thomas Huth <thuth@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 3/4] KVM: arm64: Reset TCR_EL2 according to guest's E2H mode
Date: Thu, 17 Sep 2026 22:42:13 +0100
Message-ID: <20260917214215.74135-4-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917214215.74135-1-weilin.chang@arm.com>
References: <20260917214215.74135-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

Previously vCPU TCR_EL2's reset value didn't consider TCR_EL2's
different formats based on the value of HCR_EL2.E2H. It always resets to
the E2H == 0 version.

This didn't cause any problem because the bits set in the E2H == 0
version (TCR_EL2_RES1) all reset to UNKNOWN for E2H == 1 per the
architecture.

Still, it's better to fix it. Choose the correct reset value by checking
KVM_ARM_VCPU_HAS_EL2_E2H0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..62c059747fbb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3275,6 +3275,14 @@ static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return vcpu->kvm->arch.nr_pmu_counters;
 }
 
+static u64 reset_tcr_el2(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	__vcpu_assign_sys_reg(vcpu, r->reg,
+			      vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2_E2H0) ?
+			      TCR_EL2_RES1 : VHE_TCR_EL2_RES1);
+	return __vcpu_sys_reg(vcpu, r->reg);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -3853,7 +3861,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
-	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
+	EL2_REG(TCR_EL2, access_rw, reset_tcr_el2, 0),
 	EL2_REG_FILTERED(TCR2_EL2, access_rw, reset_val, TCR2_EL2_RES1,
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
-- 
2.43.0

