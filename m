Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DA837CAC
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEphZ7FSAyhFA2gyPB5fSFck49IXGee0EHT1BdmiAgY=;
 b=5Ab4Y5tzLAGhgDjLLGh54MhvwGmLAs1NyAVkA4UIK2grMeKrZg1hlmV1TVwfHLz7stzrZtPXP/KVM9hjDUkKnCjoD9BoSXP8/D+EcWMiyE3vDM3S39FsaSpgRmAyWHzccOBRaw7rvQBaKEK8I0REHfDX3Djm9X+ASieBGS/OUtc=
Received: from DU6P191CA0049.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::8) by
 PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.28; Wed, 27 Sep 2023 14:02:39 +0000
Received: from DBAEUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:53e:cafe::58) by DU6P191CA0049.outlook.office365.com
 (2603:10a6:10:53e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Wed, 27 Sep 2023 14:02:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT046.mail.protection.outlook.com (100.127.142.67) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:02:39 +0000
Received: ("Tessian outbound fb5c0777b309:v211"); Wed, 27 Sep 2023 14:02:39 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: fa27c0bf9af9bd5d
X-CR-MTA-TID: 64aa7808
Received: from 2ea7227955ac.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id C42703F0-08CF-4811-87E8-7D027541B34C.1;
	Wed, 27 Sep 2023 14:01:49 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2ea7227955ac.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhY2LWKO9C0VvSLR6ovgW5y7O832Bb3a8WKiXY9XO+tZtQD7bWTiGpkZLfQMuONPwqVl3t1Uaaohnc+yrURC5FspKo4zx9arUz8ltzgYaIfXD+AJtR6zpCUiZA6a330Oj4nosz5s+MSpEo1webgnU2nO7EvLrwoBu8sF087ncNpAoX6V/tKBSuziL4MkeGKnMoZEbz3flI8ERmeVfWubwptH/8Qgdzi3MH4zlLKRw098iMx74S7jUKKq0OnNHPyKilyiua8Q9gmry3ZEsP3ZitkKoz0OaM2kiAWfKrOFyg7dmN58fr43lbMei6jaBsSjCrh0b/marAfbsgKkyArWdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEphZ7FSAyhFA2gyPB5fSFck49IXGee0EHT1BdmiAgY=;
 b=ehHhM1heIzlzjpIs/Uha3TjD1IEgUssuYpWuHfsOa5b5u5nJAuIlKCz8LeJr1nlXYx0J12dl2oZTYGDkFzRCHRbz4ugfzESDkKZYxwssdeLV9DdsQTycOMI1JwXlYo9Qvc9ZTCj+bZgi11cnAJbmbER022U1eW1VGZdYlCBMnPmY804rI1ny+DlxppyB8iUlPO967P4kQA7juhu2E891Lo5oAV48B0O2xsyhfy+4wk0jhtyjHgM/4K3QStLuhbQd6pygBObhvBaVJi1QEwOFJeN4Rc40L0HCWLzyBCyn4t8kKCRnNUllg9RpjOjkNwG9d9S+8HLV476l8OwvHQSNGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEphZ7FSAyhFA2gyPB5fSFck49IXGee0EHT1BdmiAgY=;
 b=5Ab4Y5tzLAGhgDjLLGh54MhvwGmLAs1NyAVkA4UIK2grMeKrZg1hlmV1TVwfHLz7stzrZtPXP/KVM9hjDUkKnCjoD9BoSXP8/D+EcWMiyE3vDM3S39FsaSpgRmAyWHzccOBRaw7rvQBaKEK8I0REHfDX3Djm9X+ASieBGS/OUtc=
Received: from DB9PR05CA0013.eurprd05.prod.outlook.com (2603:10a6:10:1da::18)
 by AS2PR08MB8718.eurprd08.prod.outlook.com (2603:10a6:20b:55e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Wed, 27 Sep
 2023 14:01:47 +0000
Received: from DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:1da:cafe::e7) by DB9PR05CA0013.outlook.office365.com
 (2603:10a6:10:1da::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT051.mail.protection.outlook.com (100.127.142.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:47 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:39 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:38 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:38 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 10/20] arm64: mask out POIndex when modifying a PTE
Date: Wed, 27 Sep 2023 15:01:13 +0100
Message-ID: <20230927140123.5283-11-joey.gouly@arm.com>
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
	DBAEUR03FT051:EE_|AS2PR08MB8718:EE_|DBAEUR03FT046:EE_|PA4PR08MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: 59efb828-399d-4ec0-bec1-08dbbf62692e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 AhozLqvD/pQmxSKeVXhotmDCw+96hsgWioF2MeqpnGubt2mzspKsM9RprcSvKVCF+naCllJlaYBncoVfcj6kPfD1yt8fKpH+d/OEcQ0OyYEmrZBxgSznTdnXtgmtYu5jozqaMXE2OKfPUnuRl9FzL9lhtfP5IGJNh2jDlOZxeYoYkYuSzY5X4HzPnWEqQ7q5gPYCO8wyhfpPR8mdau4tPyH4/7PPwD/dtvSujvNL78lc4fIEf7vSwnarLA/YSdFjEt6CGSy1enWJV06xs5ZEGarT63G2YIWQPmhLPBZYWwzaUnS7Dt7eyR7OwbamkgdDIXGYiV/lSx42TGkcggHegqjzVci7fWVLDKtTUx+tIOHChzOINrqK+AMZcY2uWBw6ne3AOcvsjJeS3REZDB1ZxSjYXQ1Um1ncKHALU1GecvqF7DwZIZxjWWxnmLVKMCT1NVFJuPRzQpv64vHIKTRz5YNJUBQ8SPgR/363AUn7szDrl5tsFlEs3gBgT0lyAt8tKMd3TWjpTN2Vb03gsImSAQkzfjurRM2SW19ya6iziLYuGgQ7mHpEW/b4wKmZ08/5XgKl4242g2vf6HzGdFlZG4h/nsaa0Hv4dHOvqm3IxMc5mrS2SDmEEIs5V1wqEAjP8Fm5XrOVjnEv1pV37QNuC6oEzsbejoDu60ShhTj0R1BWyfcPLKk8QxfIoZy/ku8bkcZkEpMeZFwChtQqSaFHR92Dr9laUnhhQJHyZFOps09WgdzfheMthAreK1a564uM7BQo2oSF6aMEKEC3G5S9FQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(82310400011)(186009)(1800799009)(451199024)(46966006)(40470700004)(36840700001)(40460700003)(44832011)(7696005)(6666004)(70206006)(81166007)(356005)(2616005)(70586007)(6916009)(54906003)(316002)(478600001)(86362001)(36860700001)(47076005)(426003)(336012)(82740400003)(1076003)(83380400001)(26005)(5660300002)(40480700001)(41300700001)(36756003)(4326008)(2906002)(8676002)(8936002)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8718
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b42636de-6186-4c5e-744e-08dbbf6249ec
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v0AIRsKsZK5y1xLx3UbyAl0EdzquEQokjINLb348sWj3GOC57Hh8RZvPMs/5fztA1ILiH7+Gs7jhwxEMU9AcHnB2OrxSMUPTU6E5IJeOyLtWkvJI92bSBAmlJJPkZlwnlguPn1eCIFumMcxGSe77X6tcYZM1LAfXvJm9B+MDCqSCaZQ4lHlTG9009m88PsxpxF/5bnTfCm+La59ffVUsmHxlY3aew6gBK0DPvHgXDvLBuF3SnXEY2MqO56vkx5o+njRQEbAO/mMQC4+erG9l5x3jH7oIGBjMJq+pYHSRLjmBKFbvRP0+dQjyF7quFSmbtBi6tSgR/UG7AwW8QCCdEvQT7aYYDq9rlHDwvwhGejOcJ2Od/kPi6Ago0wupmAQRXAOiqwVqB7JIyipUrARp0ZuYbbRl+K8ThB+yT4iFMpa4JDJ24pIC4XPhd869hMmiiW/4QZXIwVOM3BpKZvKUj/B+GR5owV6JrVtWUEJPqElOd13FDzNQTnwBH6b1MzaeaaRd1Yc0F0I2PtYMXofQLJRuhlmzVpqyXfbcmXhu1rLTWsxU/Uem93iKGy+4rJ00h47BhjucxoKNYX2u+wRmF417TKGDZ4bl1cnheOa9T3lMg4ZD9Dz7s930PbwSe5a7sBSyg5Qzs7ulhPdcTK/aVbQV2R2RnZ3AkcuUKaWM2oJyhxCElBHDqnyAKkte6qvtmJU/HtE7dlgBvG8+vPARDtcdEBzX/CHp+2cTdW1/LMKYZVMM2+n5QYr3NCdmu9OS
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(82310400011)(46966006)(40470700004)(36840700001)(40480700001)(316002)(70586007)(54906003)(70206006)(2906002)(6862004)(4326008)(41300700001)(44832011)(8676002)(8936002)(478600001)(40460700003)(26005)(1076003)(6666004)(36860700001)(5660300002)(47076005)(7696005)(336012)(86362001)(36756003)(426003)(107886003)(2616005)(83380400001)(82740400003)(81166007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:02:39.4491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59efb828-399d-4ec0-bec1-08dbbf62692e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127

When a PTE is modified, the POIndex must be masked off so that it can be modified.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7f7d9b1df4e5..98ccfda05716 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -818,9 +818,10 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 	 * Normal and Normal-Tagged are two different memory types and indices
 	 * in MAIR_EL1. The mask below has to include PTE_ATTRINDX_MASK.
 	 */
-	const pteval_t mask = PTE_USER | PTE_PXN | PTE_UXN | PTE_RDONLY |
+	pteval_t mask = PTE_USER | PTE_PXN | PTE_UXN | PTE_RDONLY |
 			      PTE_PROT_NONE | PTE_VALID | PTE_WRITE | PTE_GP |
-			      PTE_ATTRINDX_MASK;
+			      PTE_ATTRINDX_MASK | PTE_PO_IDX_MASK;
+
 	/* preserve the hardware dirty information */
 	if (pte_hw_dirty(pte))
 		pte = set_pte_bit(pte, __pgprot(PTE_DIRTY));
-- 
2.25.1

