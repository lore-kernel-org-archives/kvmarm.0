Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B022E7F2A
	for <kvmarm@lists.linux.dev>; Thu,  3 Jul 2025 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751551085; cv=none; b=uQtd3ECXzudfMh/ofwbymdXd8yhXnPGnfzHHq2glFCxRD6VbXFBwWc0b9I7kiviQ2Mqx6apOag4Z6UqvSn832ImzXR+2X9yEemSIA4o/QV7qa8JjGnitCvC/YHnZlNtctXzSp+LzFp9lHPgf1UVl7DT/P5k17/hpcXhJOq7UC2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751551085; c=relaxed/simple;
	bh=cqKWaRaRxWF6y8mCDtNPMHZhHWKzACmDdS7NSuDGNlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCRzTK8U0AP7yAB1fVW45uEoaef4biwQ6jGvRRwQ1wEoIUiUiQu1jSqC5yDINHvKCdJ78ilEn24N7Ime6zORW0z4Ze73L7HFo8+Y+GqpyhlxpeVyAWNHAjMo7pdyJjSqlP/KnLgbT2Vzksw+56lkuOpL0vzc2qs9lb4qADl+L5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24F081655;
	Thu,  3 Jul 2025 06:57:49 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D8D7B3F63F;
	Thu,  3 Jul 2025 06:58:00 -0700 (PDT)
From: Ben Horgan <ben.horgan@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	linux-kernel@vger.kernel.org
Cc: james.morse@arm.com,
	Ben Horgan <ben.horgan@arm.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN
Date: Thu,  3 Jul 2025 14:57:28 +0100
Message-ID: <20250703135729.1807517-2-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250703135729.1807517-1-ben.horgan@arm.com>
References: <20250703135729.1807517-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, u64_replace_bits() was used to no effect as the return value
was ignored. Convert to u64p_replace_bits() so the value is updated in
place.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Fixes: efff9dd2fee7 ("KVM: arm64: Handle out-of-bound write to MDCR_EL2.HPMN")
Cc: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..c20bd6f21e60 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2624,7 +2624,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	 */
 	if (hpmn > vcpu->kvm->arch.nr_pmu_counters) {
 		hpmn = vcpu->kvm->arch.nr_pmu_counters;
-		u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
+		u64p_replace_bits(&val, hpmn, MDCR_EL2_HPMN);
 	}
 
 	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
-- 
2.43.0

