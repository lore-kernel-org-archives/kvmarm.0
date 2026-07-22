Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90F947125B;
	Wed, 22 Jul 2026 07:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706178; cv=none; b=nssW7THuR9y8OBpZsTplUH6kLLXoAGqpcKPE0qhU6/HKP8cWSLd2T6fB44QMwD1UWDvOG66bMQEoToWg09eBT/l26Lq1F+I+ZqhHXTGjajqVun+BjP8Wj0ucu2YyghaPyPX5+PwAzF/xjVSfWX5RKqZAmG54yr4zuZ7pv/2Agp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706178; c=relaxed/simple;
	bh=1oI0ojKzOYyrYr2Czs3TgbpYBucGl/eqJ0RhaXxMA7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT8vGHJ6bnIPyOomHKByM2i/gTe63SZOdqxx67USy3qC75aEIOnLbnhThBtVAMZ2A2ShLktH+TvXgZr989960tK27DA/sHEVzoVKwoPzifd9vIJ30uUd6BZWKh8NeCUbE1rvxi05LceVAdwKNExHdnc48I/nzDyQ5jUqO/9834c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9ok6saI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9ok6saI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7986A1F00A3D;
	Wed, 22 Jul 2026 07:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706176;
	bh=L8kxiEOu8cCrGY0sX3QNEyS9vCZ9rmhBCDv3n6ZxaDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9ok6saIM6RQMpbWuXNyP6yv+g1cotflEOG4rZYyvN5JOwU+h7lZntUTtI79Paz6H
	 JkTgUsnXMaiid551kLgy8Cbs4Y/cwibxfc9GaResKZEOyF9U0xexlZ0eSa8gJ0a07Y
	 BiWpZWLR/1mEyRPG9fc2t3oH1tHCK0uWtESz2grBrAc8Z5CouR20Vx2wE8kNrff7VM
	 IVHpJCMvZpVM5Lp8442l3kkKmbrRg5U+4plsEh4daGBqJ2sWghnCOr6TYx2CIviI42
	 aBNyMyt5oNov4w9OAe+JXgdTjfXG6vIRuvgiW5jYj+0afFklslXvmNN1qRueaTr6xy
	 AArhhssPzbNtg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbS-00000007VfN-2WkB;
	Wed, 22 Jul 2026 07:42:54 +0000
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
Subject: [PATCH v3 02/28] arm64: Update ID_AA64MMFR4_EL1 description to 2026-03 JSON release
Date: Wed, 22 Jul 2026 08:42:08 +0100
Message-ID: <20260722074234.3330999-3-maz@kernel.org>
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

ID_AA64MMFR4_EL1 has gained a few fields and enum values in the past
few months, so resync its definition with the 2026-03 JSON release.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7cb61aca3797f..3171c87eb2447 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2386,17 +2386,40 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
-Res0	63:48
-UnsignedEnum	47:44	SRMASK
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
+UnsignedEnum	47:44	SRMASK
+	0b0000	NI
+	0b0001	IMP
+	0b0010	SRMASK2
+EndEnum
+UnsignedEnum	43:40	TLBID
 	0b0000	NI
 	0b0001	IMP
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

