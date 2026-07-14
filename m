Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515D32DB7BD;
	Tue, 14 Jul 2026 09:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020610; cv=none; b=Vff+DZdJTYTL6j/vyxGXjP2lper1UvhasGnpKUJI+5997FeEX31iUHtWgOqsqOLgRVaTSMpleImjOmTG5ZsiHpsmVEKOR6Lw/D6BFsnMO/HRlulWIZGJeVEhbOjsavmXQQx7W46sszIEAmYZEbLthLN2rGk+jxl61H/bejik9oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020610; c=relaxed/simple;
	bh=xsXV9MWbxPw9K7shC81x/Rrri9wc0wvaH7floDeCMN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPA0Yw5FmSy3KgE25VRiw9fUjAfwQvFXcenglyqLthwFmNTRIaD6ejKch+rl9e3LFzkEtY+/wPuOvdz8Qo6Xvo98IK8kOaIoXL4PcsyXCE+aGvQjJzrIHNLW4Rf2mHJ3f9h26wLCg3iKV5CdLIdHMPWcY8JcjX8CiLADY42hgMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YXonML+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXonML+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C72E1F00A3E;
	Tue, 14 Jul 2026 09:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020609;
	bh=coVcvglA4gi9EbFO8pV//jEU/rmnn0BkIq6bsE7KnOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXonML+69M6Lo/2qQ55q3v3DhqedEtzEh+YqRqZqiF0MO5qvIUTnM/mtR6muyyPXX
	 Pg7bnMBvzk+NGiqEUhYUyiJgcaQCaqzIJ4B7SJTUmzAJCo4Lv3hDe7+mborssy5arR
	 GmtwtXycKlkDTcLJdv7ecvXSVKb26mS+cJ1mGjq/9zXyT19ZvwjuT6L4+L+VXVeeJF
	 4/aMUy9uhY1bu9FdJCpFMiit9LpQsW0oLCt499opX+OSGIhUs19fkPfrn6xUJF7Bfw
	 oKt8sVSLFkmmjzXU3MxKYt2oQ6n27EnMOCeorJYwwclxSodAicBF0ReEcYh7Y6CdAO
	 av2SFxgkHyXzg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFv-00000004ny1-1fap;
	Tue, 14 Jul 2026 09:16:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 02/28] arm64: Update ID_AA64MMFR4_EL1 description to 2026-03 JSON release
Date: Tue, 14 Jul 2026 10:16:15 +0100
Message-ID: <20260714091641.1970822-3-maz@kernel.org>
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

ID_AA64MMFR4_EL1 has gained a few fields and enum values in the past
few months, so resync its definition with the 2026-03 JSON release.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index bc1788b1662b7..32e2f9856768b 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2386,17 +2386,40 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
-Res0	63:48
+UnsignedEnum	63:60	MTEFGT
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	59:56	SCRX
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	55:52	TEV
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	51:48	TPS
+	0b0000	VAL_0000
+	0b0001	VAL_0001
+	0b0010	VAL_0010
+EndEnum
 UnsignedEnum	47:44	SRMASK
 	0b0000	NI
 	0b0001	IMP
+	0b0010	SRMASK2
+EndEnum
+UnsignedEnum	43:40	TLBID
+	0b0000	NI
+	0b0001	IMP
 EndEnum
-Res0	43:40
 UnsignedEnum	39:36	E3DSE
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Res0	35:32
+UnsignedEnum	35:32	EAESR
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 UnsignedEnum	31:28	RMEGDI
 	0b0000	NI
 	0b0001	IMP
@@ -2410,6 +2433,7 @@ UnsignedEnum	23:20	NV_frac
 	0b0000	NV_NV2
 	0b0001	NV2_ONLY
 	0b0010	NV2P1
+	0b0011	NV3
 EndEnum
 UnsignedEnum	19:16	FGWTE3
 	0b0000	NI
-- 
2.47.3

