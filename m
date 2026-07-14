Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B7243F4D7;
	Tue, 14 Jul 2026 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020616; cv=none; b=NrCNvrSCewhUaaHazzhAL5YegnvKPyijR+287v6WmaBAj6qkCv0iWjFpfjWyPA6wVXgQ3qKso/LiZYBA8Pu18YCudrg0HEeFnjweA2IKevPizIN+HXQ+qZsIUKXrf7s4pWBZMX4tutoytVNsdCMeCwdLbz6n2MFzXNI0n3RluHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020616; c=relaxed/simple;
	bh=fK4mBMKmS+elIQo8Ctjjfyv5QelGcP8fxWYQ8yj+j1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTQMWhABxo9Cb8tPpA0zL2F3AwIADYxxq0ibHF7Sk3VlN4b104ZjUm/MZqHwG13WEFYRJ7Bz6Az6mDzC7/iU+CjRZ1wuaSG9DSKQOV5A7nHZur6oBlMddHmH3YrEALVZ5bYFXcE1IQRXTppQhgqTVR0j5e9F6cwfFbkx6KMHsao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Noo4crIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Noo4crIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5BD1F00ACA;
	Tue, 14 Jul 2026 09:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020614;
	bh=ZwUtkaBfc1/bGDoMdw8wkMEGT7WDFKoW/EX/Xh2aA+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Noo4crISgwy+f8EI22NzQCVBOdZfRfcckn/W/Muv3K9XkA4OaUCIaEQHLr1+zfbIh
	 7aX65kA7xSYhvuH8lm28w/m3x3vDIzBwdkQZRwRi0JMpLrdWWFbG+aGNgO8D1Lz+aC
	 8VfiKWhmFpIfBqaJpp8T9KT9SxLH0A5k0htE26lRY7m54v0uJ87lQnmMlRtTtogl2H
	 WLV9G3Efv4xcPJRzhJz9TtJW92ZUUsRYLcMT6iw7dRzmtEi74qAqRvgPATneubi6tn
	 2Ru9cAgR5gRzXCF048YGvnl/i6CdB+TF3adAWDtxbzqulFCKvD9NpWh9oWDPDBRtEA
	 nYwLowMcfuRWQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZG0-00000004ny1-329E;
	Tue, 14 Jul 2026 09:16:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Date: Tue, 14 Jul 2026 10:16:40 +0100
Message-ID: <20260714091641.1970822-28-maz@kernel.org>
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

