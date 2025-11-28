Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF531F9F47
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764324631; cv=none; b=Du2wJOqLYcsUirUyhI/jBv44eu7sVsNfjFkXOPAxgnS/jyXytqnS15PcbrEL7YgugV/GvI5IYGbAr/gh2+TDOGior08f2h2ltJEmZtZen7x8aiIwLcYQpwsUZE2y5kShTzgKzOMqVhPHx3zJpgpSO4daKMGRiF4C0YPi4bFNRQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764324631; c=relaxed/simple;
	bh=hWjsOL3OkWbnWxF09vdb+hf56ys7V9sVl+5ZFrPrfwo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZPQxIhkC/2n8fwQcb43uLRngJAfi6Ug219PA0G6HPoSroLz591CP061sYWfM2cLJLvswKEbPr2Ei8kD6G34tIAvo3xKhXbd24gPb85ia48sa7execqwtk5dBb2Ggg8BAnPvlkPi+g/WKDMeDLwhNMoh3L+N2ltash+rbJszSgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82EB9176A;
	Fri, 28 Nov 2025 02:10:21 -0800 (PST)
Received: from e140010.arm.com (unknown [10.57.90.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 216383F73B;
	Fri, 28 Nov 2025 02:10:18 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 2/4] KVM: arm64: at: Use correct HA bit in TCR_EL2 when regime is EL2
Date: Fri, 28 Nov 2025 10:09:44 +0000
Message-ID: <20251128100946.74210-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251128100946.74210-1-alexandru.elisei@arm.com>
References: <20251128100946.74210-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to ARM DDI 0487L.b, the HA bit in TCR_EL2 when the translation
regime is EL2 (or !ELIsInHost(EL2)) is bit 21, not 39.

Fixes: c59ca4b5b0c3 ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 1 +
 arch/arm64/kvm/at.c              | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..e500600e4b9b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -111,6 +111,7 @@
 #define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_HPD		(1 << 24)
+#define TCR_EL2_HA		(1 << 21)
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
 #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index d25fef0f66e2..6d41a95f6c60 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -346,7 +346,9 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
 
-	wi->ha = tcr & TCR_HA;
+	wi->ha = (wi->regime == TR_EL2 ?
+		  FIELD_GET(TCR_EL2_HA, tcr) :
+		  FIELD_GET(TCR_HA, tcr));
 
 	return 0;
 
-- 
2.43.0

