Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D262D73B5;
	Thu, 30 Jul 2026 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395462; cv=none; b=gL8YXacscRXB+Bdthn1a2jwR19oQwF/ZF1aFiWdmQyRakax4h4+fUXXuw+fVpOpGI/Ycb2HeHpYRF6onNml/CPsZGY1TSMu7e+QOMwgU4YQ92RyT9ZJNt0g1lMV8u4OGnV4+2BlIU33dNkntAXnEIeZEmNuHIBOlxYd0qzms43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395462; c=relaxed/simple;
	bh=lvnC6MOREV15DuIdzyrxDmxBzLoVj0bJ0HkqhMGYXWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFbk4uzoDW3zSTUp+hQ5GleUXn5KLQdYiA5wBmlJvbi4Ee5b9A3v91IBgSjtzA2I5m1TAtPtPNx0UDlYcbDeSZP6pWGoyHHzxPm8NW22sr4lpql2zZjvfo4Q6+uf13vaI4jmrpNUdFNIDj/OasMw1NBTHfgWx0GGveVYXIBkOOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mI0Adkby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mI0Adkby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280351F00A3E;
	Thu, 30 Jul 2026 07:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395451;
	bh=qy3LcChpmVPkZFpX/FyAcZIZ4iiBtn32rR6Vy9EHCMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mI0Adkby1Y5xWOEoa427WveKzE+UPR5ih6RtRlDS2vsCHTOmChHj0iQfLOjhinISW
	 2WmWoGJxe0DXslrDqT/u6Vtv3xmlWaHrdODnPyVuAGlq/147XAVb8y43gRNBQZ0iOV
	 J4PXlDVlNWTB4ZNE2OT7rdGIakGqnq7D/HLBS4fY3S2GhIyDFV7u7PHdIuBMOMEwQa
	 YqGgi4nmD9ESr4OyivWVh2DKbm5okrC36ND6n7OXLxv57KvoySKArI2iZPyr1LjVAD
	 wWiTOu+WdcrMtq/sj2B41oHBHjm0AmqSHE73uuWO1ePM90YpS3oam3nlH0g4pc90iD
	 YxAaHMNUnCxNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKun-0000000AOpW-1jeS;
	Thu, 30 Jul 2026 07:10:49 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 05/29] KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2 sanitisation
Date: Thu, 30 Jul 2026 08:09:58 +0100
Message-ID: <20260730071022.296811-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCRX_EL2.SRMASKEn is a new bit enabling FEAT_SRMASK for a guest.
We don't plan to support it any time soon, but it doesn't hurt to
actively document it, specially as we are going to add more bits
we actually care about.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 1 +
 arch/arm64/tools/sysreg | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 96ddcefc71eb5..c61d62b796023 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -904,6 +904,7 @@ static const DECLARE_FEAT_MAP_FGT(hdfgwtr2_desc, hdfgwtr2_masks,
 
 
 static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
+	NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),
 	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
 	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
 	NEEDS_FEAT(HCRX_EL2_GCSEn, FEAT_GCS),
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 3171c87eb2447..28755f70f0bf0 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4545,7 +4545,9 @@ Fields	ZCR_ELx
 EndSysreg
 
 Sysreg	HCRX_EL2	3	4	1	2	2
-Res0	63:25
+Res0	63:27
+Field	26	SRMASKEn
+Res0	25
 Field	24	PACMEn
 Field	23	EnFPM
 Field	22	GCSEn
-- 
2.47.3

