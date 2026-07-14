Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023C43E9FB;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020613; cv=none; b=GspsnTUd36dX7mZZ4ef/h425BKlv7NA64UOzA9D6Zt6vBANxzI6exJsCQhMgDx9QBm3ICfVk+/eh3OVQo6iV4jbQWdJsnKejiiLTIDL5K/IyOKiEdnq4y9oUJD8xuVJUqDIbOp2xgaXWzZ7mOWY2RqpT7UUXgdiM3DL/NNR48z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020613; c=relaxed/simple;
	bh=9NbUIFOuQGhPmdmTQ518VoxJ7RJNQ2KTV36YNQscAVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bc0a3tAH80ZKMXsYRS3cMPVtxiPqPKhxwRNUPyL3naKShr6vBUjBplg7uufYr6Sx+cvqLMbUCvcoESq6N4ON8Us3GKv/ksDH5jWzQ0PyWsHAOqdKH3n8OsbcWbkPhHKT9wa+3vMoGWwGoT/omQwmwYpt3rv74h4RibNHfugw5rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i06AkM5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i06AkM5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054D11F00AC4;
	Tue, 14 Jul 2026 09:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020611;
	bh=07dRYKXgRyU3x0X5on17tlJ7LESqf7TzRfpEcaCKSac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i06AkM5WjMzdYA3MuLaaRZCOy7iPwtjy9QRrzjThhRYCxQNjbqKA6WDTBnje1TbtA
	 wwlB/BGabziv6rgHSCk2DuOdC07tOq6h34lxMmvUGiZCSdY8N7l07K6uCUY0G2qMFV
	 8UvpaJrud6ZEEjOUrlgH9IvcgIGwwFt2yiqkJozFp5XUwmnS6YsxdoiO1aZHtzoCTg
	 7vngTV3sayHob3wsCYtHInL2u/Dzmg+d8NhThEeph7J3SCshuOgAYppAEFxggrhvah
	 mcAidXMCln7JheNulkPbVYbY26I7tIPQ3bxVLx5/aLM6/6oKhvWo6aiwbGAz+OUBFy
	 ysoVd1U50fTyQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFx-00000004ny1-1E8Q;
	Tue, 14 Jul 2026 09:16:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 11/28] KVM: arm64: Expose FEAT_NV2p1 to NV guests
Date: Tue, 14 Jul 2026 10:16:24 +0100
Message-ID: <20260714091641.1970822-12-maz@kernel.org>
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

Since NV2p1 is reducing the number of traps, it is valuable to expose
it to NV guests. Do so.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43c..35a1c42ad3f84 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1728,7 +1728,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		 * You get EITHER
 		 *
 		 * - FEAT_VHE without FEAT_E2H0
-		 * - FEAT_NV limited to FEAT_NV2
+		 * - FEAT_NV limited to FEAT_NV2(p1)
 		 * - HCR_EL2.NV1 being RES0
 		 *
 		 * OR
@@ -1740,7 +1740,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
 			val = 0;
 		} else {
-			val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
+			val &= ID_AA64MMFR4_EL1_NV_frac;
+			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
+			else
+				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
 			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
 		}
 		break;
-- 
2.47.3

