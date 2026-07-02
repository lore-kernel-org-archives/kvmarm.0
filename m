Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF9D3382DA;
	Thu,  2 Jul 2026 16:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008187; cv=none; b=cu99ulETwRK8hUY74Z+dgy2p8CZrbYDpS8WqYuTdUrZbXofIqEDCqAwJ6kSIhb/ObTtyOcobsQqpN2EMbmyBdACHdgoXDuUAMKlWYan0NWqkGLlGKv8hkJWUmcEJENmtV9/HpOz2rgbGEZLTFDWRe+fZZDIYyT/Syw4GS49kT7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008187; c=relaxed/simple;
	bh=+/9ue/7tMYSC7YuO2WdvQ6ZslpU/l3i0eSfNG8ZZlp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP/dXVFJYdBUffc8nwDBrlLsdrc7q2Pz5lekyXbQDYBvdZ17iQlodKtxaxgY0yDNxi6HC8T7YdhF/56Re/tv65j/vStqBv+CyPSagN3HiePfYRmNwZi5x/v+YC/U21yFogyFMqHwv9B6mNpeERamOx4v9n49YNWgEraeiJuukYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTXFoo6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTXFoo6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EFC1F0156A;
	Thu,  2 Jul 2026 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008185;
	bh=uitPE3YZ82V7uRyv8yldMkwgClqFe0DQvFTN5NyfsiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTXFoo6xmxtosrUf+QPhnEHxOlvAyECtAiA9mMI/I6z2IdyZ7Jqp29nrJrNavXuo3
	 e779vVH1o+HgvwmOBh151KoXTf/l4Ln1MdMaTO35vmMgODLNksB7FpNHyn+sJHKTjU
	 EkZA+CUA4enr69BujdvDePK8Yiq64NQOhi9Zc5DlpFpJKAdRAxrJyBuEQ4FPDHYmU+
	 NxYJSl2Rmeh7RY6ezrkWFt8fhJ3JHLiWH98j/oOaRC0kbR+4p01B5tzCnnmW9cPWst
	 1kMwEfuMcgoY3n1CM4yYy8958SkrmhMawEvuGAS1XoJxf0Hu+Oat5pyP4XnAA6LLwg
	 bdXAnPj1sMBug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsV-00000000ojd-2Z6n;
	Thu, 02 Jul 2026 16:03:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Date: Thu,  2 Jul 2026 17:02:47 +0100
Message-ID: <20260702160248.1377250-28-maz@kernel.org>
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

Further enable FEAT_NV3 by making it visible to NV guests.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c9bf04944f9cb..64c8fb82fadf6 100644
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
@@ -1740,7 +1740,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
 			val = 0;
 		} else {
-			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+			if (cpus_have_final_cap(ARM64_HAS_NV3))
+				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);
+			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))
 				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
 			else
 				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
-- 
2.47.3

