Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6BA37CAC
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0yT6aUiEgqGdFDJIzxPy3xP5u2DH8hDhZ8T2A+NsCo=;
 b=ejgNHPDdMOxcV0sn2YhSvZeF6scd5vWcwHMgPVPim5DJYK3ia1Z/DBDVEwNGImIdGPzdoevaDeHztUTfyvCIyhlAeec6EElSVOluJCT1izxQrm0BcAYpS2aD1EmZSVna47d+GCLO07aWPVX0ylW3+55geKiEvnP9P204apSVBV8=
Received: from AM9P192CA0023.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::28)
 by AS2PR08MB9833.eurprd08.prod.outlook.com (2603:10a6:20b:606::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:02:59 +0000
Received: from AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:21d:cafe::7a) by AM9P192CA0023.outlook.office365.com
 (2603:10a6:20b:21d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:02:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT064.mail.protection.outlook.com (100.127.140.127) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:02:59 +0000
Received: ("Tessian outbound 0ae75d4034ba:v211"); Wed, 27 Sep 2023 14:02:58 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 0ddc445098f639a5
X-CR-MTA-TID: 64aa7808
Received: from 071200549df4.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id C8FCD12E-D95A-4B9E-893C-1E0CD9681332.1;
	Wed, 27 Sep 2023 14:01:51 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 071200549df4.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBBQQLegQn5s6/3e0zRmdlUC9Srmc+hjhNusW2bVJKaPXuhlXV5kRHwdl+xotixHMctBGETyq78oadjPh5ahd4jGbkkdv35bFlC9k0J5j02XS4OQ6+6bs6HMWl1KmpEjuPkBx9Y8GoSJp7FEnaoyCAfOqXAikJMan7Iw1vZgDd2PxtdwcVkNV25RKvGmsNghVdWsmlUwjBganj+gmH1xtpSOvPtGcbTskl9JVpdIK32XxRsijbkZLodHo85/zo6huPWDjRtG2jrue7qSOzCVLAvPWbFl4XPKDUh5japidHw5/kpe+r0vCU/A2TvEMtrKclm39xsHKyO84yspOzX9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0yT6aUiEgqGdFDJIzxPy3xP5u2DH8hDhZ8T2A+NsCo=;
 b=LiFQyQKhwYGOgvwDA1p/kxP4OFlRugzVrdN/18rjYIigyGLW/Z8q1tSMCinR0bXpEQnajK77f/L9bIVf9bXloSMwzEjXbpZ//B2jlLBx1XFuQCWAtH98tMKn7+VnI+X2Maycl2+rU1hbYiY4kKeo8iifuyoQWOljtcudMXcP4IsmpRbbg1rljyHlLDlO9owWK8Dyz20/NJjBMLtmVMaTJlu2NFKxxZjKSrbIImqSSpyqOtn+Ez/dl3UEINZyBKhtwcAtwUMQ10H8YmgGmm/kUxYHdEg5lYddcNiVWceZf3HeF5rPsSgeAeOUYME/lo/K86t84njEmkcy0lUZxYgJXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0yT6aUiEgqGdFDJIzxPy3xP5u2DH8hDhZ8T2A+NsCo=;
 b=ejgNHPDdMOxcV0sn2YhSvZeF6scd5vWcwHMgPVPim5DJYK3ia1Z/DBDVEwNGImIdGPzdoevaDeHztUTfyvCIyhlAeec6EElSVOluJCT1izxQrm0BcAYpS2aD1EmZSVna47d+GCLO07aWPVX0ylW3+55geKiEvnP9P204apSVBV8=
Received: from DUZPR01CA0183.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::21) by AS8PR08MB8085.eurprd08.prod.outlook.com
 (2603:10a6:20b:54a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:01:46 +0000
Received: from DBAEUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4b3:cafe::6f) by DUZPR01CA0183.outlook.office365.com
 (2603:10a6:10:4b3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT047.mail.protection.outlook.com (100.127.143.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:46 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:37 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:37 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:36 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 06/20] KVM: arm64: Save/restore POE registers
Date: Wed, 27 Sep 2023 15:01:09 +0100
Message-ID: <20230927140123.5283-7-joey.gouly@arm.com>
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
	DBAEUR03FT047:EE_|AS8PR08MB8085:EE_|AM7EUR03FT064:EE_|AS2PR08MB9833:EE_
X-MS-Office365-Filtering-Correlation-Id: 5563535a-071a-4f13-a680-08dbbf6274da
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 3dGPBsS+COWkvTcnukDiSEDwQrSEn1OLsk4fQ91fVbT+BNBVnu07rzjXVyYdCEfQq65mvUJrQih9emSd418aQPRlJQefsj/c7yqNcaaHtF+D2m+w452pvztZ0VlbonDWBxlh7BuF2kI9BJkpT7BSMYIcydCjtKFW+z8bI+3PsHkvyibS+SgPgHoE6RUY8YcVcSk2EaPex09QcT1ft6hLU8d3uBxaB37J87FvUYv+AcA8xlCSc1tFeWx4vh23tzWQigClJqWOjndMRqsrOyNk1E9fja9VmI6whW6/rH04qW98XOBgoPqRMPTDAu95MtzzXjDGMKBK3Khrw3wnevyNjJB7EE5joOXpn+6DPTVIWu8DHnDCzHvcKRC2bUe8RrodQUei/mPffNTNwtlDr0avGJU8RCfxIQp3XnJdsJBDdP6etEL690P3q/H1tF/yygZyrTfbLPGovDDR3s/J99bNLntSS6MwEdIslMjZGS1kRZI+Eu+65peuK5sAWVPQpRcfbEyAN5T8QES+cr4LS+cyCWu8DMQ2LngnxDVnsb/QPT/R2rp9JTzfqd7p8b6co/RkQRONpoWsejAscVy06wstXFd57oUdVxW+pFlDrlPwUCCza79TpWf+1LZgdC6xNp6TtyC6f0R92zaI6AgWd7tvh7Wgc6PUVl6ztx0x6HOizA5eAHjykbNVjPMvhbPM5zu0EZZEf2HPtuAR4TewUC+2fqjgB4eV36cb70PyeIgfuQHXvipUrxWmZkH0m4u+I5xYiroNr9NrgvLVsYOg8Vvn0Q==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(451199024)(1800799009)(186009)(82310400011)(36840700001)(40470700004)(46966006)(54906003)(40480700001)(5660300002)(70586007)(70206006)(41300700001)(316002)(6916009)(44832011)(8936002)(8676002)(4326008)(47076005)(2906002)(7416002)(40460700003)(356005)(82740400003)(478600001)(336012)(426003)(26005)(2616005)(1076003)(81166007)(86362001)(36860700001)(6666004)(83380400001)(36756003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8085
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	08b69d6f-54b4-4124-a6a6-08dbbf624949
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gfXTNzPQMYuX6jwksI3VoXpFSi6Fm0diQ+l5QQyc4uabU1y8LSPhPQeNNqpBaR1hLzNR9GY3hMfsPGAV2nisY2+LLw5Nu7bXu/xPGQzFMOyKIiHvgMHDXbMocm0YErEqPPi6FYf6zuvaboJcXwnAUJDlpgJEq5pzKW0nC/IcNFpwRwir+YZ0BD0Wmrj09sA7TqCMpwiPhujJR+h6Pn1UH4jOKlnfU92U4n7JJSlnEydjDEhnVx0mAx3lT+OvtJcevvPemkqPlY34o1Y4mrqW4yAMxiOFRx2AQPRd7E5nmeUy34V3Tf3xL04VpaKjrk+5n6EpkpLbeL9XupjPFm+R6Q+RuTA9VTVZ1alMo0TPdQrGFGpEZJqm2pQA4+zzNU1c20E5Bm97t64z2CM2LsbmcKuZ9jzNCpKARnwMFR8Yy1Ag07atoe0XHNRjbdqc41o2qsFy8a2AZpXNLi/L3kHpEWb0eyCry77FOM5e7AigjPfsC1YeVC1gnk7GMpMocbaeKo4cu0DruQz84dh1xZ34jxyy5uOBASR8VOgRJ3nU1NX0FogDt7dadZ3ONdf5o9Oju66/BR8H0RWjvtRH66ku7k/uB3zgBDIMGNPIvMlcGdxt1YCOJ7PkiH/Ue/NrAGTSrnMrfbduELqpZq2MTxcg0oK4pkx5TRaQ1O/mO2m0lTmw9vwfoncBl/X1IETTbQLtrgTt5QDy86cLrzRumGBQwGlgfgCX4k1wpJzfq9RCYhZ1iCY5FU4ShsM4MXvqGL4n
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(82310400011)(40470700004)(46966006)(36840700001)(336012)(54906003)(40460700003)(40480700001)(5660300002)(316002)(2906002)(41300700001)(8936002)(44832011)(4326008)(36756003)(8676002)(6862004)(86362001)(82740400003)(70586007)(478600001)(47076005)(36860700001)(26005)(2616005)(7696005)(6666004)(426003)(1076003)(70206006)(83380400001)(107886003)(81166007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:02:59.0775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5563535a-071a-4f13-a680-08dbbf6274da
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9833

Define the new system registers that POE introduces and context switch them.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/sys_regs.c         | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee34..205653bc5c2c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -365,6 +365,10 @@ enum vcpu_sysreg {
 	PIR_EL1,       /* Permission Indirection Register 1 (EL1) */
 	PIRE0_EL1,     /*  Permission Indirection Register 0 (EL1) */
 
+	/* Permission Overlay Extension registers */
+	POR_EL1,	/* Permission Overlay Register 1 (EL1) */
+	POR_EL0,	/* Permission Overlay Register 0 (EL0) */
+
 	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..dbaddadd2a1c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2124,6 +2124,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_PIRE0_EL1), access_vm_reg, reset_unknown, PIRE0_EL1 },
 	{ SYS_DESC(SYS_PIR_EL1), access_vm_reg, reset_unknown, PIR_EL1 },
+	{ SYS_DESC(SYS_POR_EL1), access_vm_reg, reset_unknown, POR_EL1 },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
 	{ SYS_DESC(SYS_LORSA_EL1), trap_loregion },
@@ -2203,6 +2204,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
+	{ SYS_DESC(SYS_POR_EL0), access_vm_reg, reset_unknown, POR_EL0 },
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
 	{ SYS_DESC(SYS_TPIDR2_EL0), undef_access },
-- 
2.25.1

