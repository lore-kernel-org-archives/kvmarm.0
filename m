Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F9E3B71A2;
	Thu, 30 Jul 2026 07:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395456; cv=none; b=q1OHdzIpCzfbxf1nTrJoUlXSpGb1U9obI5zKD07EOukp0puClLjkNTyc1+WjAMAjRXruuJaUYQh2a1ZzyA1ErJWmr0CF/Wz26Wu5ompKRMcclFzeF1oWxV2tZfmiUvQg2pY0O886La0NJfno6u69lo6Y9ym/+9YoFcE/MwQbMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395456; c=relaxed/simple;
	bh=1oI0ojKzOYyrYr2Czs3TgbpYBucGl/eqJ0RhaXxMA7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Syzkr6RjhKaP2KfcDuheHUn5rUH5TNBgWx1IkpEdYvEoy6BrwOGy2ON0jBD+QttpBMA03/2UGNmNGir5vBkxXxBa0GnfH7fBQMmNi26ztnhpWF9JUFkqlLmaGPO/fm1X5EqIZcy+JbsrsjnMjyeoN18NN6Dv0873rA+K7VnvoZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KI7TK0Ix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KI7TK0Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2311F00A3F;
	Thu, 30 Jul 2026 07:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395450;
	bh=L8kxiEOu8cCrGY0sX3QNEyS9vCZ9rmhBCDv3n6ZxaDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KI7TK0IxLnXHXXZ1jHvbnbiwpJ5LGTxheHJ1YdlucfUlutNVRdc5Eg2g74gUuPf2P
	 7IIAVs/+K5gsXtcAXRVLmS9mSC3T1h4kBbd6aK2ElpS3GbV0om2qb3HWLSxAfNi7La
	 P0X7B4uxpowSy1siH27Yk4qLPkX4Kh9sJt/yZa4yoHgS50XoVZm5P9eXbJZLbRY/bn
	 Xruc85PWcZ/pq9WKkXDqxDAud9FHEBfIg6zNFrtpzq43JA27PjcP3KmfCsHjjBWIx9
	 YyuIjueB3XTcpIHO8+9WuwC7tAZv3WoAfCMBtEz8+iiuZbiUHnWehZFECBePtP3GKs
	 aOaO8AHE/J4OQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKum-0000000AOpW-37fK;
	Thu, 30 Jul 2026 07:10:48 +0000
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
Subject: [PATCH v4 02/29] arm64: Update ID_AA64MMFR4_EL1 description to 2026-03 JSON release
Date: Thu, 30 Jul 2026 08:09:55 +0100
Message-ID: <20260730071022.296811-3-maz@kernel.org>
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

