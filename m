Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E761A1B219D
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999575; cv=none; b=r1SC/VDOUEDz3Iu57+VP5vaWbP9GlEnEU4q1s1pC0VKPnlYcyTL/R43zooDi1lruyfuSbMmCg2SL0BPAY7fQz2ySHmgcOczG+vdOxz5fXcnFFSs1A4wg9xZOTVN+6e9e1WIfBBZf9TULxHwHDHj6ltY9jYRF8K8Up01xhKlYKqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999575; c=relaxed/simple;
	bh=CmtghalZQg/PYtal8be/w3dAvPD2QOFJdUOt9xiVFZU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rFaIdGg1Msnq6uISlg9TygxfqKEDTE4BI09zqCO8AxUST3MSblBG1ibiypQmaGltMHpKnm51wP6pm/0DQtMJ+KPdB0mVOr+PyWWQhR9rGdJ+62oKpIXbLblVKQ3XFkpfqBcwQPHaNW9YX0QzZSsqRfIzWQ4b60ozX7TNEMs5bGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB6151007;
	Tue, 15 Oct 2024 06:40:02 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E1813F51B;
	Tue, 15 Oct 2024 06:39:31 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 1/7] arm64/sysreg: Convert existing MPAM sysregs and add the remaining entries
Date: Tue, 15 Oct 2024 14:39:17 +0100
Message-Id: <20241015133923.3910916-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241015133923.3910916-1-joey.gouly@arm.com>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

Move the existing MPAM system register defines from sysreg.h to
tools/sysreg and add the remaining system registers.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  12 ---
 arch/arm64/tools/sysreg         | 161 ++++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9ea97dddefc4..345e81e0d2b3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -542,18 +542,6 @@
 
 #define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
 #define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
-#define SYS_MPAMHCR_EL2			sys_reg(3, 4, 10, 4, 0)
-#define SYS_MPAMVPMV_EL2		sys_reg(3, 4, 10, 4, 1)
-#define SYS_MPAM2_EL2			sys_reg(3, 4, 10, 5, 0)
-#define __SYS__MPAMVPMx_EL2(x)		sys_reg(3, 4, 10, 6, x)
-#define SYS_MPAMVPM0_EL2		__SYS__MPAMVPMx_EL2(0)
-#define SYS_MPAMVPM1_EL2		__SYS__MPAMVPMx_EL2(1)
-#define SYS_MPAMVPM2_EL2		__SYS__MPAMVPMx_EL2(2)
-#define SYS_MPAMVPM3_EL2		__SYS__MPAMVPMx_EL2(3)
-#define SYS_MPAMVPM4_EL2		__SYS__MPAMVPMx_EL2(4)
-#define SYS_MPAMVPM5_EL2		__SYS__MPAMVPMx_EL2(5)
-#define SYS_MPAMVPM6_EL2		__SYS__MPAMVPMx_EL2(6)
-#define SYS_MPAMVPM7_EL2		__SYS__MPAMVPMx_EL2(7)
 
 #define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
 #define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8d637ac4b7c6..05d04a45db65 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2737,6 +2737,126 @@ Field	1	E2SPE
 Field	0	E0HSPE
 EndSysreg
 
+Sysreg	MPAMHCR_EL2	3	4	10	4	0
+Res0	63:32
+Field	31	TRAP_MPAMIDR_EL1
+Res0	30:9
+Field	8	GSTAPP_PLK
+Res0	7:2
+Field	1	EL1_VPMEN
+Field	0	EL0_VPMEN
+EndSysreg
+
+Sysreg	MPAMVPMV_EL2	3	4	10	4	1
+Res0	63:32
+Field	31	VPM_V31
+Field	30	VPM_V30
+Field	29	VPM_V29
+Field	28	VPM_V28
+Field	27	VPM_V27
+Field	26	VPM_V26
+Field	25	VPM_V25
+Field	24	VPM_V24
+Field	23	VPM_V23
+Field	22	VPM_V22
+Field	21	VPM_V21
+Field	20	VPM_V20
+Field	19	VPM_V19
+Field	18	VPM_V18
+Field	17	VPM_V17
+Field	16	VPM_V16
+Field	15	VPM_V15
+Field	14	VPM_V14
+Field	13	VPM_V13
+Field	12	VPM_V12
+Field	11	VPM_V11
+Field	10	VPM_V10
+Field	9	VPM_V9
+Field	8	VPM_V8
+Field	7	VPM_V7
+Field	6	VPM_V6
+Field	5	VPM_V5
+Field	4	VPM_V4
+Field	3	VPM_V3
+Field	2	VPM_V2
+Field	1	VPM_V1
+Field	0	VPM_V0
+EndSysreg
+
+Sysreg	MPAM2_EL2	3	4	10	5	0
+Field	63	MPAMEN
+Res0	62:59
+Field	58	TIDR
+Res0	57
+Field	56	ALTSP_HFC
+Field	55	ALTSP_EL2
+Field	54	ALTSP_FRCD
+Res0	53:51
+Field	50	EnMPAMSM
+Field	49	TRAPMPAM0EL1
+Field	48	TRAPMPAM1EL1
+Field	47:40	PMG_D
+Field	39:32	PMG_I
+Field	31:16	PARTID_D
+Field	15:0	PARTID_I
+EndSysreg
+
+Sysreg	MPAMVPM0_EL2	3	4	10	6	0
+Field	63:48	PhyPARTID3
+Field	47:32	PhyPARTID2
+Field	31:16	PhyPARTID1
+Field	15:0	PhyPARTID0
+EndSysreg
+
+Sysreg	MPAMVPM1_EL2	3	4	10	6	1
+Field	63:48	PhyPARTID7
+Field	47:32	PhyPARTID6
+Field	31:16	PhyPARTID5
+Field	15:0	PhyPARTID4
+EndSysreg
+
+Sysreg	MPAMVPM2_EL2	3	4	10	6	2
+Field	63:48	PhyPARTID11
+Field	47:32	PhyPARTID10
+Field	31:16	PhyPARTID9
+Field	15:0	PhyPARTID8
+EndSysreg
+
+Sysreg	MPAMVPM3_EL2	3	4	10	6	3
+Field	63:48	PhyPARTID15
+Field	47:32	PhyPARTID14
+Field	31:16	PhyPARTID13
+Field	15:0	PhyPARTID12
+EndSysreg
+
+Sysreg	MPAMVPM4_EL2	3	4	10	6	4
+Field	63:48	PhyPARTID19
+Field	47:32	PhyPARTID18
+Field	31:16	PhyPARTID17
+Field	15:0	PhyPARTID16
+EndSysreg
+
+Sysreg	MPAMVPM5_EL2	3	4	10	6	5
+Field	63:48	PhyPARTID23
+Field	47:32	PhyPARTID22
+Field	31:16	PhyPARTID21
+Field	15:0	PhyPARTID20
+EndSysreg
+
+Sysreg	MPAMVPM6_EL2	3	4	10	6	6
+Field	63:48	PhyPARTID27
+Field	47:32	PhyPARTID26
+Field	31:16	PhyPARTID25
+Field	15:0	PhyPARTID24
+EndSysreg
+
+Sysreg	MPAMVPM7_EL2	3	4	10	6	7
+Field	63:48	PhyPARTID31
+Field	47:32	PhyPARTID30
+Field	31:16	PhyPARTID29
+Field	15:0	PhyPARTID28
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
@@ -2769,6 +2889,10 @@ Sysreg	FAR_EL12	3	5	6	0	0
 Field	63:0	ADDR
 EndSysreg
 
+Sysreg	MPAM1_EL12	3	5	10	5	0
+Fields	MPAM1_ELx
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL12	3	5	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
@@ -2941,6 +3065,22 @@ Res0	1
 Field	0	EN
 EndSysreg
 
+Sysreg	MPAMIDR_EL1	3	0	10	4	4
+Res0	63:62
+Field	61	HAS_SDEFLT
+Field	60	HAS_FORCE_NS
+Field	59	SP4
+Field	58	HAS_TIDR
+Field	57	HAS_ALTSP
+Res0	56:40
+Field	39:32	PMG_MAX
+Res0	31:21
+Field	20:18	VPMR_MAX
+Field	17	HAS_HCR
+Res0	16
+Field	15:0	PARTID_MAX
+EndSysreg
+
 Sysreg	LORID_EL1	3	0	10	4	7
 Res0	63:24
 Field	23:16	LD
@@ -2948,6 +3088,27 @@ Res0	15:8
 Field	7:0	LR
 EndSysreg
 
+Sysreg	MPAM1_EL1	3	0	10	5	0
+Field	63	MPAMEN
+Res0	62:61
+Field	60 FORCED_NS
+Res0	59:55
+Field	54	ALTSP_FRCD
+Res0	53:48
+Field	47:40	PMG_D
+Field	39:32	PMG_I
+Field	31:16	PARTID_D
+Field	15:0	PARTID_I
+EndSysreg
+
+Sysreg	MPAM0_EL1	3	0	10	5	1
+Res0	63:48
+Field	47:40	PMG_D
+Field	39:32	PMG_I
+Field	31:16	PARTID_D
+Field	15:0	PARTID_I
+EndSysreg
+
 Sysreg	ISR_EL1	3	0	12	1	0
 Res0	63:11
 Field	10	IS
-- 
2.25.1

