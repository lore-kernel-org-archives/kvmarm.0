Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025FB2FD68E
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 10:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764324642; cv=none; b=BWHYX+OHPgMRdi1+QecJbGw+91CxVbBibE9qWa3xY/xXAun8J1bpr+97eC6Pggqa7IyvPbXZEVUksm2roEdzcBpyQkksFod2nwcLpOW/IM9dlLYzpDVD1kS42/mRoDCd9LiuVf0Y1aWV8nNfwRfJ/08pNPCAu0/BP8IGjRu9iH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764324642; c=relaxed/simple;
	bh=v/8gfKQ4KVCaGW4eLXeixdBd9jv0HuPT4/YjK16F444=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMzXRty0IzKqkNbZ5VNR1R9GJYZ+IxnLx3Mgpxm1z5ENf3uR8RP979kOQAUUUouzCW2w0VQHRpk4URboqEFMlIn/80TO9dMk76zV3y0Am3s+NcoMSaFtqLAfbYRv92nOxeSwunamx+3W46pVAVigv/GKIMQQRrxHTivWpeRttPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08B5B1A2D;
	Fri, 28 Nov 2025 02:10:33 -0800 (PST)
Received: from e140010.arm.com (unknown [10.57.90.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F08213F73B;
	Fri, 28 Nov 2025 02:10:35 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 4/4] KVM: arm64: at: Update AF on software walk only if VM has FEAT_HAFDBS
Date: Fri, 28 Nov 2025 10:09:46 +0000
Message-ID: <20251128100946.74210-5-alexandru.elisei@arm.com>
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

A guest can write 1 to TCR_ELx.HA, making the KVM software walker update
the access flag in a table descriptor even if FEAT_HAFDBS is not present.
Avoid this by making wi->ha depend on FEAT_HAFDBS being enabled in the VM,
similar to how the software walker treats FEAT_HPDS.

This is not needed for VTCR_EL2.HA, since a guest will always write to
the in-memory copy of the register, where the HA bit is masked (set to
0) by KVM if the VM doesn't have FEAT_HAFDBS.

Fixes: c59ca4b5b0c3 ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/at.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 6d41a95f6c60..53bf70126f81 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -346,7 +346,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
 
-	wi->ha = (wi->regime == TR_EL2 ?
+	wi->ha  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, AF);
+	wi->ha &= (wi->regime == TR_EL2 ?
 		  FIELD_GET(TCR_EL2_HA, tcr) :
 		  FIELD_GET(TCR_HA, tcr));
 
-- 
2.43.0

