Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD38730C368;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008184; cv=none; b=M5xc0llzlftzhlULkHRerd6diKmAMJPTpFWitvwWj7h7lVIlFs32W7p0Fr3DbUDljrrjzjhGAvX5uGpmef3DdR19YmUXh8C423cieFzpmHtVqQs7k9HS2R8JQO/FnlLzrh2w9u691Cbb++Wg3gAcS6mmZPAUP4zXLCUs9gYKB/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008184; c=relaxed/simple;
	bh=ui3PF0NVnK7+uZ0A+8DW3YSe55ny2ujVTZwmCcEX9R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWQxUGEvAJFZTKav8jClXy6v3SULFuLoV0DU1rd2gq3fVOwcCnVeBMnhK/ZYWIpyyhu6LCq7rIszl/89tI8ITEFXI2oejrvUFElALra99ueUbKgpoIplxkia8ikMBX1L0mHe7WOp04yLgahD8H3HrptlHnsRDI9FbY1B5Uv4wC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2C0r3fA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2C0r3fA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1E41F00AC4;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008180;
	bh=Gz1SCcBQk1uT9BfitccY1PXQbFj9e4s1uC4Oikj/pOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2C0r3fAS3FhJF4PK/tP21s8cSFukJF/jxm22ybu32OyeIwDEaQBaHkjCjE8wL7BY
	 191x7uYfKZV5z1HrG+hpgOTHH5iuQoe39/ekivkmiOKvg+L5FSTNmW4urNAJEJtNBr
	 XRuR6eYvMK8fUE5MmXPR3HdqHoo6/j9tohcDH3rJEHNk4Mn5GgO1Rk3RxQR6+EfbRz
	 dxmy1yZ6foMY0C8b8naFI0LGAYXoAhElUvWQlgmi50A8N2qdhtON1rb+d7GI0d4kJm
	 Yv5JH03wLdL/78nROpw94VDWfPq/ZxeWcj5ET4nOp4oCpH6ceKcs7k2e1nNb7FwJZo
	 8LHby5gD1y8sw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsR-00000000ojd-0Wpb;
	Thu, 02 Jul 2026 16:02:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 05/28] KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2 sanitisation
Date: Thu,  2 Jul 2026 17:02:25 +0100
Message-ID: <20260702160248.1377250-6-maz@kernel.org>
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
index 16d8148dc3f12..8d5e4aacf49c4 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -904,6 +904,7 @@ static const DECLARE_FEAT_MAP_FGT(hdfgwtr2_desc, hdfgwtr2_masks,
 
 
 static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
+	NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),
 	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
 	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
 	NEEDS_FEAT(HCRX_EL2_GCSEn, FEAT_GCS),
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 32e2f9856768b..c6e8117a6f9cd 100644
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

