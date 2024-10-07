Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7582E156E4
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323184; cv=none; b=iUINbm3uQCKtGIu+bKUJz3QJFt9sNhgXByNQPdsaqLNg0hOsy5CFnq2CY1t1+u1jmrUep01JcpkGuuOK1Rq7D5LG61OnhiL8lhudqxmNu8YkJp0FQIhgCXMkv4Lwz1jM2WVhnDctm3eRFh3xI4oas4VX8up1zC6q9c78EQItMLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323184; c=relaxed/simple;
	bh=da0yVH5Pan5zrZlpXbNW+6J4hEGsXCta/vY38jUqD+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD7pYjNhbrQcnCyhbS37XpfrvXjpZkpvycExH+B3xNkxNBoV/M3h2XzkGibhlHuWXud0wjrm3Vkm5LwuXn+YFfmNor3OQVlpoCnAcqLlrL52cj5yvWlnQmHwzarjDAbVV5knnvHp40v3mpAHV33MZykRkZ9HLG0Kozh/8sHXJOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EePNM1M3; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EePNM1M3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i4o4thLzBjZkSFqcMpPfFShdMgjKaXATKq0hkoIBUv0=;
	b=EePNM1M33QYFO/HpyhGv5zx9TQg6+41bl7L/JKyXv3HUfiANvfp00QL6bTA08fScDytiRm
	c2aO0y3muzWBDxqPy+Y7MV9uz+rNvvdNKUUPRPGss1ssVFOf/oBJ0LjEdN7zAlk0v7zxtA
	M8oyTVkAX6VK6Ub5hzqo2vqRNtonwZY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 02/17] arm64: sysreg: Migrate MDCR_EL2 definition to table
Date: Mon,  7 Oct 2024 17:45:44 +0000
Message-ID: <20241007174559.1830205-3-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We're about to add some more MDCR_EL2 definitions, may as well migrate
to the new way of the world at this point.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_arm.h | 29 ----------------------------
 arch/arm64/tools/sysreg          | 33 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 109a85ee6910..fb8d15f299a4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -311,35 +311,6 @@
 				 GENMASK(19, 18) |	\
 				 GENMASK(15, 0))
 
-/* Hyp Debug Configuration Register bits */
-#define MDCR_EL2_E2TB_MASK	(UL(0x3))
-#define MDCR_EL2_E2TB_SHIFT	(UL(24))
-#define MDCR_EL2_HPMFZS		(UL(1) << 36)
-#define MDCR_EL2_HPMFZO		(UL(1) << 29)
-#define MDCR_EL2_MTPME		(UL(1) << 28)
-#define MDCR_EL2_TDCC		(UL(1) << 27)
-#define MDCR_EL2_HLP		(UL(1) << 26)
-#define MDCR_EL2_HCCD		(UL(1) << 23)
-#define MDCR_EL2_TTRF		(UL(1) << 19)
-#define MDCR_EL2_HPMD		(UL(1) << 17)
-#define MDCR_EL2_TPMS		(UL(1) << 14)
-#define MDCR_EL2_E2PB_MASK	(UL(0x3))
-#define MDCR_EL2_E2PB_SHIFT	(UL(12))
-#define MDCR_EL2_TDRA		(UL(1) << 11)
-#define MDCR_EL2_TDOSA		(UL(1) << 10)
-#define MDCR_EL2_TDA		(UL(1) << 9)
-#define MDCR_EL2_TDE		(UL(1) << 8)
-#define MDCR_EL2_HPME		(UL(1) << 7)
-#define MDCR_EL2_TPM		(UL(1) << 6)
-#define MDCR_EL2_TPMCR		(UL(1) << 5)
-#define MDCR_EL2_HPMN_MASK	(UL(0x1F))
-#define MDCR_EL2_RES0		(GENMASK(63, 37) |	\
-				 GENMASK(35, 30) |	\
-				 GENMASK(25, 24) |	\
-				 GENMASK(22, 20) |	\
-				 BIT(18) |		\
-				 GENMASK(16, 15))
-
 /*
  * FGT register definitions
  *
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8d637ac4b7c6..0cb381c7e582 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2388,6 +2388,39 @@ Field	1	AFSR1_EL1
 Field	0	AFSR0_EL1
 EndSysregFields
 
+Sysreg MDCR_EL2		3	4	1	1	1
+Res0	63:44
+Field	43	EBWE
+Res0	42
+Field	41:40	PMEE
+Res0	39:37
+Field	36	HPMFZS
+Res0	35:32
+Field	31:30	PMSSE
+Field	29	HPMFZO
+Field	28	MTPME
+Field	27	TDCC
+Field	26	HLP
+Field	25:24	E2TB
+Field	23	HCCD
+Res0	22:20
+Field	19	TTRF
+Res0	18
+Field	17	HPMD
+Res0	16
+Field	15	EnSPM
+Field	14	TPMS
+Field	13:12	E2PB
+Field	11	TDRA
+Field	10	TDOSA
+Field	9	TDA
+Field	8	TDE
+Field	7	HPME
+Field	6	TPM
+Field	5	TPMCR
+Field	4:0	HPMN
+EndSysreg
+
 Sysreg HFGRTR_EL2	3	4	1	1	4
 Fields	HFGxTR_EL2
 EndSysreg
-- 
2.47.0.rc0.187.ge670bccf7e-goog

