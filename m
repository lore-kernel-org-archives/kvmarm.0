Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618A14746CA;
	Wed, 22 Jul 2026 07:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706184; cv=none; b=FNeX5Jq71rkq3jmomBwuYB5vOxzPHK83S2Jzo8zEuHm5TjHq2ppmWZTMg+LMF3UBRQubO/d5QEPwWo+Rh4QylBrbJawC6MfF9r6SEVZDkcbUG920oZt+8xqoGmL1qQyNkPPuhkT3iCuAnd3qNwq8mS2aot+bfwF2YDBEf7GHV1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706184; c=relaxed/simple;
	bh=fK4mBMKmS+elIQo8Ctjjfyv5QelGcP8fxWYQ8yj+j1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKNMAxrAqbBosK7rJdLKh94lpRsK8Gvt1i4ruDahMUD9ejnIUhJ+LBtfj29kT4CEGhvhLH6EMjU18NlMLXFl32rl1/h3ODPVS4Wfu6UoU5bae1995LOFuXzwWRpNUR945PU0xQICM4hA2+J6enq0KwjbCiBpxgogYPox9TR8lqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYR559Cq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYR559Cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41031F0155A;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706182;
	bh=ZwUtkaBfc1/bGDoMdw8wkMEGT7WDFKoW/EX/Xh2aA+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYR559Cq+9PmDBj5i3IMaVxCT3dz5SRrMtWEQVLpWjcZcymRRwRSCWEDAZT1LJWTA
	 ihXqYYfFwHNHAnKZdHAO5BTr62JpieqqbWm41vq5xjftXE7kjgukXRi8/eCI9civVn
	 VJz2I8qqhxnWPLR24aUxFxcV8pgIkZZkKS0RJ4OTuvL/GQH2xkXnUSf2q2ivc2T0i7
	 rHVB+ZLi27SxcblOoJGh/cXGrbvr0LcY65iJLTfTe92xWHx58PTFPCtIE0d2eWmiGS
	 ReXu7QwqPfuoufD2P5XWTVBAJ0NukKpKXhbBArrsWnfN+E5/XiloBFlo4rIwomRdQj
	 dH9mAzvAbuH+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbY-00000007VfN-1PkQ;
	Wed, 22 Jul 2026 07:43:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Date: Wed, 22 Jul 2026 08:42:33 +0100
Message-ID: <20260722074234.3330999-28-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Further enable FEAT_NV3 by making it visible to NV guests.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f646894fec9a9..70d605e60cfb3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1728,7 +1728,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		 * You get EITHER
 		 *
 		 * - FEAT_VHE without FEAT_E2H0
-		 * - FEAT_NV limited to FEAT_NV2(p1)
+		 * - FEAT_NV limited to FEAT_NV2(p1)/NV3
 		 * - HCR_EL2.NV1 being RES0
 		 *
 		 * OR
@@ -1741,7 +1741,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			val = 0;
 		} else {
 			val &= ID_AA64MMFR4_EL1_NV_frac;
-			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+			if (cpus_have_final_cap(ARM64_HAS_NV3))
+				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);
+			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))
 				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
 			else
 				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
-- 
2.47.3

