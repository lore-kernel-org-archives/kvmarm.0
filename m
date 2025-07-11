Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E31EA7CE;
	Fri, 11 Jul 2025 07:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752218879; cv=none; b=YdAXktf2GZ08jOmEizWz1hWvFuteV7gqifGkct/MWiomNjSQT38Huv31XTRQcMA98BDZ8JdZ57FCpX2KVQXg5EB7o63lIwzFv8maGGHRXiClfw4kez7yddF4KmPrIj0Bh4JO/jR6WUeOXCnrDoNP69JOlm/6Zj8b9W6hiBA/0gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752218879; c=relaxed/simple;
	bh=1j6zpFS1DVxWS1hxIV2/OdRNBhbPf+kJqE3FRm4cKC4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rvpvbsq1DapEPCK/2UH3aIEHCKXFplVaM+WxwjdSdd+TP2UxYZqv6mLNW3JLyAe+JUZ1LkLe4mD36Vq4useAErbDg0FGTyChe9geU4W6jEzN9BdAPffjQDSdeGwRDJys0UMXG1hWBk61CTAhPh5heisYpJKwqQ3dCtPyEjWrvKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0OLdVU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0OLdVU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0814C4CEED;
	Fri, 11 Jul 2025 07:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752218877;
	bh=1j6zpFS1DVxWS1hxIV2/OdRNBhbPf+kJqE3FRm4cKC4=;
	h=From:To:Cc:Subject:Date:From;
	b=d0OLdVU4WW5AyI7Qx0K6WV7vTsCe8RYod5bHaEglGd68ShyZuQBsiCZKJbvDq8fG5
	 /3rgIEMyKy/WVzx8LSE8c6JPNA9uwUr0p6mu7IKoGE7CalIEjtnquG9JmrjiXlGJde
	 4kGmdSSbclD4AHFyAjRqLLHVDZI35/MEDvivwPaDcZo16v1dqpKqcBLNYnuz+iU8Gz
	 W1JiLAd+rki6nEXs4bOzc1J8ppdazvdGKhfan6USczkBV8AqEMm4ETus9uh1Uihc7n
	 O4xSnlwpG6n9H64HA3voGAMTgvH1zLlPva4hY+BUuS/jcbsaT+Lkq0lUN2GlxzfQJg
	 WigyTZS+XaRaQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	James Morse <james.morse@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: fix u64_replace_bits() usage
Date: Fri, 11 Jul 2025 09:27:47 +0200
Message-Id: <20250711072752.2781647-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

u64_replace_bits() returns a modified word but does not actually modify
its argument, as pointed out by this new warning:

arch/arm64/kvm/sys_regs.c: In function 'access_mdcr':
arch/arm64/kvm/sys_regs.c:2654:17: error: ignoring return value of 'u64_replace_bits' declared with attribute 'warn_unused_result' [-Werror=unused-result]
 2654 |                 u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);

The intention here must have been to update 'val', so do that instead.

Fixes: efff9dd2fee7 ("KVM: arm64: Handle out-of-bound write to MDCR_EL2.HPMN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33aa4f5071b8..793fb19bebd6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2651,7 +2651,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	 */
 	if (hpmn > vcpu->kvm->arch.nr_pmu_counters) {
 		hpmn = vcpu->kvm->arch.nr_pmu_counters;
-		u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
+		val = u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
 	}
 
 	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
-- 
2.39.5

