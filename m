Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA24317163;
	Thu,  2 Jul 2026 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008183; cv=none; b=FFA0b4QWv//QDHIJ7f7Wwv8znv8QKy80CX3oKYod5szr99nEm03w+UWHMjnsESFt5oLOL6Y5LLdge54QSC8ITwmBXAUTG8qNN4w/hEaGqFFgAQIe2/OzANo1+pCg4bzAXSHJCuq03p6QLVdT1lgbOuiKYluGFruOCed0SaoNO1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008183; c=relaxed/simple;
	bh=d92zvrtjdYVKIPYyoHMbEI1BRNw3KSqoH8o18G33Poc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srGjKQPYAjOB5Meg1X5h2AgC/gyV1vGutsejZ6sN9haDlvrJH+aWiWqMQBFzfVSzQ+gsLsRLuUv+NyRc7ZlLITuJsBN/P3GjUtopPof0Et9gFQ9b8rAf4pHRVrRUNPBR4hCOBSct5XdJR3apgNhdpo5Cw0UMG0uq9iFUsuWhICs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBHZsXz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBHZsXz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1011F00A3E;
	Thu,  2 Jul 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008182;
	bh=UV7vo70Q15PKxyHcuqcabZOcjIvoszDm8zYalteT250=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBHZsXz2mrPcvKCNA4yIgk6MMYZxTI6e53pJi2GYsgmQzfEDC7BPl/BB9pfI/baz9
	 QN5gjO1hhWU+OeDwSmg9hUHgM/YSeokmkY0JtnPnJAnldtegNp3z/JigCnY8d0rNsm
	 IdR+bM5OXMcymo9hvTKFVg5zbLSRtTqQSaL8X9lLlWj9uT5WuoJ8ZjgAfWmCgaDRGk
	 5yV0tOzAj39W/5+mZMcznwydxwOWKrA1f4edHjSQZK8l7v/guorS+6f/MNE/2116Nm
	 ECTCWBcPUWHGMXApIqEn50DaB0bm4gTpqlOWdopFp6GBvOzryA03IUdcx/IdQUXH9u
	 hdaKQUmANrNKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsS-00000000ojd-1OTY;
	Thu, 02 Jul 2026 16:03:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 11/28] KVM: arm64: Expose FEAT_NV2p1 to NV guests
Date: Thu,  2 Jul 2026 17:02:31 +0100
Message-ID: <20260702160248.1377250-12-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
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
index dfb96edbdc43c..9972dea42d12a 100644
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
+			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
+			else
+				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
+			val &= ~ID_AA64MMFR4_EL1_E2H0;
 			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
 		}
 		break;
-- 
2.47.3

