Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F371F9F47
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 10:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764324637; cv=none; b=SOGpJDPMevDCuYeJeVa/V/kTbRzE9BP9BPffFA09L5kBHqqJCfEypdTOa1XpjwpNxnNVSmykkJtrA1t9Ie68SwguB4xOg62FRckSStx4po4bLYJtvHrYH5VZJVSSYu3w55VTfLvj82H0YjSPySm0qYSHmyJn1wLXlcesk/ZllI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764324637; c=relaxed/simple;
	bh=vYZQJ9p2EN+apTBkkhAPbJxpB9lpA2MqPUR9NOBvm7s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ze/UCLnzy5F6b7Zgghoyh/FxoZljH/DBiqrT/lDo+HXmuuA09H+KvP/B4QXjdXZRFhrYUfF0jZisM/X1yW300TGv8ezigZqK0wi9OUSj+f3vo0bUcGJNMkmP6RURD42wXIyBoZsPCyVT+mmBZcq4m/PoIqMK3GREENPHNDWKzZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F14991A25;
	Fri, 28 Nov 2025 02:10:27 -0800 (PST)
Received: from e140010.arm.com (unknown [10.57.90.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC18A3F73B;
	Fri, 28 Nov 2025 02:10:29 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 3/4] KVM: arm64: nv: Don't mask VTCR_EL2.HA if FEAT_HAFDBS is present
Date: Fri, 28 Nov 2025 10:09:45 +0000
Message-ID: <20251128100946.74210-4-alexandru.elisei@arm.com>
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

Commit 39db933ba67f ("KVM: arm64: nv: Implement HW access flag management
in stage-2 SW PTW") added support for hardware updates to the access flag
to stage 2 if the feature is available to the virtual machine, but forgot
to remove the VTCR_EL2.HA bit from the res0 mask for the register. Remove
it from the mask to allow the VM to use the feature.

Fixes: 39db933ba67f ("KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 911fc99ed99d..7a34163f6c68 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1719,7 +1719,9 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
 
 	/* VTCR_EL2 */
-	res0 = GENMASK(63, 32) | GENMASK(30, 20);
+	res0 = GENMASK(63, 32) | GENMASK(30, 22) | BIT(20);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, HAFDBS, AF))
+		res0 |= VTCR_EL2_HA;
 	res1 = BIT(31);
 	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
 
-- 
2.43.0

