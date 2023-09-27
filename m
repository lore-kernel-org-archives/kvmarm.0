Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2064.outbound.protection.outlook.com [40.107.22.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDE37CAC
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+hbZSgGHRByh5D4CmkeYpIKsNyQ3KdCY1O6oqp43XI=;
 b=5b9JoG/4HzMQ2+E+aeIMJPHrNlngT+i6Du3lUkRCYZ1wS/5/OknNgPy7VIYjyzajTNpZm8UWu8Iy7EfmLtJ0OqwPr6rH9y6e2fip1MLK+MiOGAOm7qmKiAHJ/f1zQWTDzeMqTriphiPP+X67bZhrCB4daFt12KxNGxPZSPU2BpA=
Received: from AS4P189CA0029.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::20)
 by AM9PR08MB6212.eurprd08.prod.outlook.com (2603:10a6:20b:285::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Wed, 27 Sep
 2023 14:02:53 +0000
Received: from AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:5db:cafe::a1) by AS4P189CA0029.outlook.office365.com
 (2603:10a6:20b:5db::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Wed, 27 Sep 2023 14:02:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT058.mail.protection.outlook.com (100.127.140.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.19 via Frontend Transport; Wed, 27 Sep 2023 14:02:53 +0000
Received: ("Tessian outbound ee9c7f88acf7:v211"); Wed, 27 Sep 2023 14:02:52 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: afe11708d26285a4
X-CR-MTA-TID: 64aa7808
Received: from f9b540775bef.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 72E03827-71FC-44F6-8C41-12197CE46C00.1;
	Wed, 27 Sep 2023 14:01:49 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f9b540775bef.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvBdRzv0bTPcnGqa91J2rOsB3dJDVm0FwYNFcwfRdpNsOdHu+hxbi5Vg+hPA5CNVMFXuaGmcozVr0FAmw4qbEBTmsu93nHD3ibcsCfq5dte/TN1AsbFsDCBxp2XuvFd2bX0DNxFfeI5l9lisbve/8mlRv3CNmS6hWPaOJ0BNXydQHN1nDE3w5l5OEn0bHKJHTPbLPXMD4CxrfcAw94O+SGqEBKNK0Z7YRE3MStIG6vuBeY1vS+ax2Znas+DUMGB0EhNpoNTdnuJfM6l3moX4VTG0szOSPme+GbPzhJ8xmXYZfEoddMIG/lRIFGgdb5vyzo+l6f8HjzKFYEqOwAf2iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+hbZSgGHRByh5D4CmkeYpIKsNyQ3KdCY1O6oqp43XI=;
 b=PYf2bNPLVl/bGvQQyQ63Lr6RHNNEKrFnXfsBK85fGep3KjDC9RW5P9y79IhYD3gIoqjo/oIhQG8wevXxzrKqXwvqxKZfgrRrS2z6+QpztGtJ/1A1Tk3Y2bFD7FdcFyl5h4GBztEq7U0hcKZnIwuavQlvW9FWLH351+GoFG5Hy9i6rZM0tecs0Lm/vDA3kl0St+6nXtoenkG6WO+E33NQon7AfnO9fSftfK28GT80fN7K6oX0gxfrcXc4oAkqo/35V/Wve4X+XVqU3SInNNhw3JyFoRb3GWFHxC6oqOEvOlLLGpr7Dvs1hiappzIuuuwVAj9dybWVTjAKQPsX7yJwNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+hbZSgGHRByh5D4CmkeYpIKsNyQ3KdCY1O6oqp43XI=;
 b=5b9JoG/4HzMQ2+E+aeIMJPHrNlngT+i6Du3lUkRCYZ1wS/5/OknNgPy7VIYjyzajTNpZm8UWu8Iy7EfmLtJ0OqwPr6rH9y6e2fip1MLK+MiOGAOm7qmKiAHJ/f1zQWTDzeMqTriphiPP+X67bZhrCB4daFt12KxNGxPZSPU2BpA=
Received: from AM7PR02CA0025.eurprd02.prod.outlook.com (2603:10a6:20b:100::35)
 by DB3PR08MB8841.eurprd08.prod.outlook.com (2603:10a6:10:43c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22; Wed, 27 Sep
 2023 14:01:47 +0000
Received: from AM7EUR03FT030.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:100:cafe::89) by AM7PR02CA0025.outlook.office365.com
 (2603:10a6:20b:100::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT030.mail.protection.outlook.com (100.127.140.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.19 via Frontend Transport; Wed, 27 Sep 2023 14:01:46 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:38 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:37 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:37 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 07/20] arm64: enable the Permission Overlay Extension for EL0
Date: Wed, 27 Sep 2023 15:01:10 +0100
Message-ID: <20230927140123.5283-8-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230927140123.5283-1-joey.gouly@arm.com>
References: <20230927140123.5283-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM7EUR03FT030:EE_|DB3PR08MB8841:EE_|AM7EUR03FT058:EE_|AM9PR08MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: 150e9e8a-741a-4360-2390-08dbbf62715a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 di3SMZtegmCx2TvUJPRIM7KmphLWNEHLmCl/stFEvahVwdpkAh0d5gho5Boit0UEnqGMf8vmaoVZ1unC+G4sYGoqsUch5hos2cPMGJkb4V3c5jM7IjqOiFBDde1Gqm9bDO1Xq4GB3/XOkrjZcehdoTfW28Qf+qXnmvj66ENWqv0VRcH+Ck+JwM5fUINYrB1G34pXx80Il3VwgQsm8u6YkwYCm6iTAuykY466BMZexUKwf9bCqxD1jvEbfE7s0EIrHzaJmegn4p30ghz2WWRNdwsOcJAHojld2WsQt2L0biGC1ZhFTpUtOpTxlcGY0zXoylPgH/+RpSRvS1oPPjIiNupjH5+iGozNeu6mww94IYxd006Qcxe8d5OUPu5bLgOKp8cqB70Ryd6qmAlv9wOGktyjZqdnGA5T6xErOddN39xgxl7gg1MZEXBLWTXjQJOfN+k1Zs6t85r7kfSVoDfOxXsrpPOy30HsDPQkvzohUY5AF/7elNKa29RDn4TCkBqSRge/XGGxYfb0sCOSJjZ40yKa3xHGveLtQVAXlKMfNcb7wr+hpJAeMyzHIhrBKZEgddHpretJlz/R9tAbFE3s7jkHfPFtaAO6ZpO9EJogTDsLrvtUFHUCxQ0eLD3GHh4odlrXfHjM7+3uRAVMpK5uhGyqKY9YDzoZ8QOgbRTlX7oP0zanKB9dGaCpFH0sGRbX7v99Elx7zk9EP1iuG1Oj7aaMA9fGSFc9gbd9YB86XE4F4x5BYQ0tam7l39ZDRtSX
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(230922051799003)(451199024)(82310400011)(1800799009)(186009)(36840700001)(46966006)(82740400003)(81166007)(356005)(36756003)(86362001)(7696005)(2906002)(478600001)(5660300002)(4326008)(44832011)(6666004)(8676002)(41300700001)(8936002)(40480700001)(70586007)(426003)(2616005)(1076003)(36860700001)(47076005)(316002)(7416002)(6916009)(54906003)(336012)(26005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8841
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9373f7f5-9eb8-4313-1ae7-08dbbf6249e3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SgzY/UKfaUD1D6i+d22sMVgrmtEIohSdo8U6okqyNQO0jwZvUv2zRj0b1/HVdLMu1wX+VgKROta3LpE050sDPIZwxnC6SRdJjRX1vu03RAh9qgfRlL9KWOEEXu+MI7mKreiFl+TuYaT8j3ie7dTt7QFZTBL2qZNLOx+pjXx2GVtL5DNlmq2sLf6lGfQApV4C1BpkJzYxv7KR8NzADnTE1Jj8AgdJBUn6jHRzeZDJRt9Kw098qTuhoY4tru0zKqn+xFuhoyYRmhvLi5USIHMUzBqg/hA2cPCtZjSj1iYcEudPDR78eeKBwM61/8JN9dmO3GZz64Qr/JJ5YO46qufBGvmLiF4wWn0eEIrOXl3cF+RoETSqcMRz7kbJ0lPq+B+tVbsPifvX2v05RfAFCRJLzJP0++3i/MAbx2u+ywpZMuHPfsgNUknRspdaIF8hw6tSbwAPyehV1GaNzSjWZFFeXIiG8XCR8H2fpfORy1QI7zSCv4e39V5XRVcBMhG2sugSNM1K7c8DGQfCFLQT+VaRPCUtT3EBzF2p2obMDjq/DBeaGX0RfpA18IC7zIFgmzvY7IegPUK5sZSG+Vkanhuo6MJzV4fthlqz1xNOd0WFtx2PufzPKyVtA84S78pYx260VF1Eoqkux2w1/2ZcFS+8/4VcGTSKuIUHqwhv/xMcMQk7c0ELFNvyw3exUY/vFHY4AVNcUed/YHW9f1aj8jP7mTIDJarS4pp+BVO4gqAoNmfD0cDY+RovsAooE+BJzAOl
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(39860400002)(376002)(396003)(230922051799003)(82310400011)(1800799009)(186009)(451199024)(36840700001)(46966006)(40470700004)(1076003)(336012)(426003)(2616005)(26005)(478600001)(6666004)(47076005)(107886003)(7696005)(2906002)(8936002)(4326008)(70586007)(8676002)(6862004)(54906003)(70206006)(5660300002)(316002)(41300700001)(44832011)(40460700003)(36860700001)(86362001)(81166007)(36756003)(82740400003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:02:53.1865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 150e9e8a-741a-4360-2390-08dbbf62715a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT058.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6212

Expose a HWCAP and ID_AA64MMFR3_EL1_S1POE to userspace, so they can be used to
check if the CPU supports the feature.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 Documentation/arch/arm64/elf_hwcaps.rst | 3 +++
 arch/arm64/include/asm/hwcap.h          | 1 +
 arch/arm64/include/uapi/asm/hwcap.h     | 1 +
 arch/arm64/kernel/cpufeature.c          | 8 ++++++++
 arch/arm64/kernel/cpuinfo.c             | 1 +
 5 files changed, 14 insertions(+)

diff --git a/Documentation/arch/arm64/elf_hwcaps.rst b/Documentation/arch/arm64/elf_hwcaps.rst
index 76ff9d7398fd..85f6e9babc7f 100644
--- a/Documentation/arch/arm64/elf_hwcaps.rst
+++ b/Documentation/arch/arm64/elf_hwcaps.rst
@@ -308,6 +308,9 @@ HWCAP2_MOPS
 HWCAP2_HBC
     Functionality implied by ID_AA64ISAR2_EL1.BC == 0b0001.
 
+HWCAP2_POE
+    Functionality implied by ID_AA64MMFR3_EL1.S1POE == 0b0001.
+
 4. Unused AT_HWCAP bits
 -----------------------
 
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 521267478d18..196f21b7d11b 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -139,6 +139,7 @@
 #define KERNEL_HWCAP_SME_F16F16		__khwcap2_feature(SME_F16F16)
 #define KERNEL_HWCAP_MOPS		__khwcap2_feature(MOPS)
 #define KERNEL_HWCAP_HBC		__khwcap2_feature(HBC)
+#define KERNEL_HWCAP_POE		__khwcap2_feature(POE)
 
 /*
  * This yields a mask that user programs can use to figure out what
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 53026f45a509..8809ff35d6e4 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -104,5 +104,6 @@
 #define HWCAP2_SME_F16F16	(1UL << 42)
 #define HWCAP2_MOPS		(1UL << 43)
 #define HWCAP2_HBC		(1UL << 44)
+#define HWCAP2_POE		(1UL << 46)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 902885f59396..9b9145fdb208 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -400,6 +400,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1POE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1PIE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_TCRX_SHIFT, 4, 0),
 	ARM64_FTR_END,
@@ -2220,6 +2221,12 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_EL1_MSCEn);
 }
 
+static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
+{
+	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1x_E0POE);
+	sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_E0POE);
+}
+
 /* Internal helper functions to match cpu capability type */
 static bool
 cpucap_late_cpu_optional(const struct arm64_cpu_capabilities *cap)
@@ -2724,6 +2731,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_S1POE,
 		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
 		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_enable_poe,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, S1POE, IMP)
 	},
 	{},
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 98fda8500535..5b44e8ab9ab8 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -127,6 +127,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_SME_F16F16]	= "smef16f16",
 	[KERNEL_HWCAP_MOPS]		= "mops",
 	[KERNEL_HWCAP_HBC]		= "hbc",
+	[KERNEL_HWCAP_POE]		= "poe",
 };
 
 #ifdef CONFIG_COMPAT
-- 
2.25.1

