Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C70453A7
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zzh60FMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EC2C433CB;
	Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698054893;
	bh=+38V8T0qT/p5lQfiPTXv5D5xyeD3ZAkMCW8SLUtYzGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zzh60FMh7MicH3tTIxeXQGKpZzj9i6BMHilHGm9sr1seHU5j6Glcs9H8N36Tt0byu
	 sCY+fuabhTTIw0Sdku0PLWP2DFb33pVZX8O6MQRmmPrF8P3iFbfRND8J4NUm48BNBD
	 HZMG4c+btGJ1IKx4b5o/I7j/Pze6T48LJEJrrEV9T0My5JTtFqffb88uahe2gk0/s7
	 eE4558VotfSUzui0qbYkUWttdxZf/5xgZeakYNMmKp4i6cF9c3NG3srFPwt8MPlsuC
	 tzXJGFand0o8xj4To9lW3SQ0qNoJgr/Ah7q2WY+6JDORMzzgl21T9NheWAzMvFQF6I
	 JWJvWuSIIp9rg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qure7-006nPT-60;
	Mon, 23 Oct 2023 10:54:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@redhat.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/5] arm64: Add missing _EL2 encodings
Date: Mon, 23 Oct 2023 10:54:41 +0100
Message-Id: <20231023095444.1587322-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231023095444.1587322-1-maz@kernel.org>
References: <20231023095444.1587322-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com, miguel.luis@oracle.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Miguel Luis <miguel.luis@oracle.com>

Some _EL2 encodings are missing. Add them.

Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
[maz: dropped secure encodings]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231016111743.30331-3-miguel.luis@oracle.com
---
 arch/arm64/include/asm/sysreg.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ba5db50effec..4a20a7dc5bc4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -270,6 +270,8 @@
 /* ETM */
 #define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
 
+#define SYS_BRBCR_EL2			sys_reg(2, 4, 9, 0, 0)
+
 #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
 #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
 #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
@@ -484,6 +486,7 @@
 
 #define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
 #define SYS_ACTLR_EL2			sys_reg(3, 4, 1, 0, 1)
+#define SYS_SCTLR2_EL2			sys_reg(3, 4, 1, 0, 3)
 #define SYS_HCR_EL2			sys_reg(3, 4, 1, 1, 0)
 #define SYS_MDCR_EL2			sys_reg(3, 4, 1, 1, 1)
 #define SYS_CPTR_EL2			sys_reg(3, 4, 1, 1, 2)
@@ -497,6 +500,7 @@
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
+#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
@@ -514,6 +518,18 @@
 
 #define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
 #define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
+#define SYS_MPAMHCR_EL2			sys_reg(3, 4, 10, 4, 0)
+#define SYS_MPAMVPMV_EL2		sys_reg(3, 4, 10, 4, 1)
+#define SYS_MPAM2_EL2			sys_reg(3, 4, 10, 5, 0)
+#define __SYS__MPAMVPMx_EL2(x)		sys_reg(3, 4, 10, 6, x)
+#define SYS_MPAMVPM0_EL2		__SYS__MPAMVPMx_EL2(0)
+#define SYS_MPAMVPM1_EL2		__SYS__MPAMVPMx_EL2(1)
+#define SYS_MPAMVPM2_EL2		__SYS__MPAMVPMx_EL2(2)
+#define SYS_MPAMVPM3_EL2		__SYS__MPAMVPMx_EL2(3)
+#define SYS_MPAMVPM4_EL2		__SYS__MPAMVPMx_EL2(4)
+#define SYS_MPAMVPM5_EL2		__SYS__MPAMVPMx_EL2(5)
+#define SYS_MPAMVPM6_EL2		__SYS__MPAMVPMx_EL2(6)
+#define SYS_MPAMVPM7_EL2		__SYS__MPAMVPMx_EL2(7)
 
 #define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
 #define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
@@ -562,9 +578,23 @@
 
 #define SYS_CONTEXTIDR_EL2		sys_reg(3, 4, 13, 0, 1)
 #define SYS_TPIDR_EL2			sys_reg(3, 4, 13, 0, 2)
+#define SYS_SCXTNUM_EL2			sys_reg(3, 4, 13, 0, 7)
+
+#define __AMEV_op2(m)			(m & 0x7)
+#define __AMEV_CRm(n, m)		(n | ((m & 0x8) >> 3))
+#define __SYS__AMEVCNTVOFF0n_EL2(m)	sys_reg(3, 4, 13, __AMEV_CRm(0x8, m), __AMEV_op2(m))
+#define SYS_AMEVCNTVOFF0n_EL2(m)	__SYS__AMEVCNTVOFF0n_EL2(m)
+#define __SYS__AMEVCNTVOFF1n_EL2(m)	sys_reg(3, 4, 13, __AMEV_CRm(0xA, m), __AMEV_op2(m))
+#define SYS_AMEVCNTVOFF1n_EL2(m)	__SYS__AMEVCNTVOFF1n_EL2(m)
 
 #define SYS_CNTVOFF_EL2			sys_reg(3, 4, 14, 0, 3)
 #define SYS_CNTHCTL_EL2			sys_reg(3, 4, 14, 1, 0)
+#define SYS_CNTHP_TVAL_EL2		sys_reg(3, 4, 14, 2, 0)
+#define SYS_CNTHP_CTL_EL2		sys_reg(3, 4, 14, 2, 1)
+#define SYS_CNTHP_CVAL_EL2		sys_reg(3, 4, 14, 2, 2)
+#define SYS_CNTHV_TVAL_EL2		sys_reg(3, 4, 14, 3, 0)
+#define SYS_CNTHV_CTL_EL2		sys_reg(3, 4, 14, 3, 1)
+#define SYS_CNTHV_CVAL_EL2		sys_reg(3, 4, 14, 3, 2)
 
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
-- 
2.39.2

