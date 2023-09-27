Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2087.outbound.protection.outlook.com [40.107.20.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB75338BAF
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EZ1h56U3Pd2J5S/cTwJhPAkArNSg9poTD89fXTBttQ=;
 b=PcIZAMbv/1oaJ/Sd5k7DtzsuyaKfZSOb/zIbn9YdTlZlVrWDWgmllX/W10O3TnDXX2nVXDPm+kvppGmJFX4A2oW7rkvZPfkQBW874lgEoftFjsbFeNUryB1xm6U7Mw92DtGJLisp4QPDjEcR9PbbTo7JtK2u/66tsyR3vnMLm3U=
Received: from AM0PR10CA0052.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::32)
 by AM0PR08MB5458.eurprd08.prod.outlook.com (2603:10a6:208:185::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Wed, 27 Sep
 2023 14:14:07 +0000
Received: from AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:150:cafe::e) by AM0PR10CA0052.outlook.office365.com
 (2603:10a6:20b:150::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Wed, 27 Sep 2023 14:14:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT011.mail.protection.outlook.com (100.127.140.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:14:06 +0000
Received: ("Tessian outbound fb5c0777b309:v211"); Wed, 27 Sep 2023 14:14:06 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5c7d011b31144c9b
X-CR-MTA-TID: 64aa7808
Received: from 1f8463df0fb9.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 09F6A995-E659-44B6-8F53-F4424E982B04.1;
	Wed, 27 Sep 2023 14:01:46 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1f8463df0fb9.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmN7cLEGyr+e0yUJADg3O5Pbth0v9izAYNNyxFNcjFgkHEX1mqu6t1+9HTjaj6j3Sc+7xHEHqMhVHAkvXI9BZ5UNKu4k6tVdk5rJiesR2KjQCMixPpi4VZwNsIu7ZGhOoDiONg+wZ2z4Jrd4p3m98cgKE5+gaClPJqFt0kitTS0P2VZuIJg9X8chxVAGQxRAP7cWF9TJM/Lode348dJ6hTid/wHxAo1fca5K5TSBuynrI4bhbIdk+k+hA6ouEov2ip+ShDYR/PgCnbXHtwUZRJKfjxvdX7HlmwMliVXjcgNpesC351acufnHFBW0nmTdX70WWoXfLtdoiwcWqjHH5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EZ1h56U3Pd2J5S/cTwJhPAkArNSg9poTD89fXTBttQ=;
 b=AnGYt2ecbgLGevgkiQoUWvArpmcdiTWwA0wcbtXUJIcK+CDjgD9l6whxmJyHi6y4mpnCXgLL+74ytIPmiRS8ZrTwpUPelPtG3e56ekxIWF3uVjLTAivIFpvaUBgp/DuU7jgVK5Axc6yWSUQZpWjmUzJ+HQCgKdCZHRZ19LMQo42SLUUTFRwdUKjguXAxiWuLijny9uIKHG+yn0mfT4X6kWaHjHWaiShTvmSC9q+QZsvCCvRKyUWtuUwQoTxpF3hRmde1aPAehUFPJqITadK41fenB6JAIhflDmqUBVNFPCZE94C/LHH7lbuAgA5iZo/xiM0gxowrAcRZTyHblEkkiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EZ1h56U3Pd2J5S/cTwJhPAkArNSg9poTD89fXTBttQ=;
 b=PcIZAMbv/1oaJ/Sd5k7DtzsuyaKfZSOb/zIbn9YdTlZlVrWDWgmllX/W10O3TnDXX2nVXDPm+kvppGmJFX4A2oW7rkvZPfkQBW874lgEoftFjsbFeNUryB1xm6U7Mw92DtGJLisp4QPDjEcR9PbbTo7JtK2u/66tsyR3vnMLm3U=
Received: from AS9PR07CA0060.eurprd07.prod.outlook.com (2603:10a6:20b:46b::31)
 by AS2PR08MB8879.eurprd08.prod.outlook.com (2603:10a6:20b:5f6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:01:44 +0000
Received: from AM7EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:46b:cafe::a9) by AS9PR07CA0060.outlook.office365.com
 (2603:10a6:20b:46b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT007.mail.protection.outlook.com (100.127.140.242) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:44 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:35 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:34 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 02/20] arm64/sysreg: update CPACR_EL1 register
Date: Wed, 27 Sep 2023 15:01:05 +0100
Message-ID: <20230927140123.5283-3-joey.gouly@arm.com>
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
	AM7EUR03FT007:EE_|AS2PR08MB8879:EE_|AM7EUR03FT011:EE_|AM0PR08MB5458:EE_
X-MS-Office365-Filtering-Correlation-Id: dc35d002-1282-4c92-bf68-08dbbf64028e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 I/ukxFs4CReOD/a+C3+XI40Euu4Ux3/cPdcq04dsaSlDpFXxyemJgCt/apV1XRlfNawwq/W5psNX3/DEIPDEYsb/fgMb6gLQ/8yXwJs2g7dllbaTIjvuMgMz2bX0dko84OKeCGumoEZBeAPcWfXBRHxALLtfrFUQfTP5iLUpgT0Gu3MkqHkzj/vXDKub7NaMp6O1Lqq4JXdu+n2hXs7Okf8OktL6x9KhMTIEV8ypQeH1AZkJ6Wi70YIvS+Hs0NYPmm6BcyHIQUWZXMZmU1WxL4rm+eudFZ2GM850DHPym2s/narlKSGLB+fIL+bkGaBlauuV0L17yxdITzWbKJv/zCW7o4SafkKVe+49ZwkWaFdNJyWANVuUeo5Dk6tlVynUW5UlGLaaNsYjaZB9R/8X4qNaq+gtxrQpXN2lwmNeFFeYZB0nyJIKOHtlLkSxRRW3zuRmD3HhmaKxQyW2KX/QA6Eirm8ruKgTs19a7tIVi9KTEjOzMDgUNEOuEjOARLYQfqE788dlCTH8beZOvYzwJ8RPBQXFtfDvA+xR/jdNIBhdd+cOhpiuqvOunmDwNkU7JgBCFvzS4ubnZ33SouP7fkJXiLwKZeTl4vSPcdoQJr/kMBd2dvrs5Dc6i7jL1vLya/BCckvfZhCAM5HFFH7Yph8+mnt2SP0f0GgODENDRIO8fZyH/L0fcRDLfHkYUFNrhZUz8EVg4u9+UjT2hBP5sZKUIGZyhAS5yqnWeu/aKwCXt3ZEL3lhoZb7Ke3o5yGCnXzYABx1LaBpt0PAgkRoFQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(39860400002)(376002)(230922051799003)(451199024)(82310400011)(186009)(1800799009)(46966006)(36840700001)(40470700004)(86362001)(36756003)(40480700001)(6666004)(5660300002)(26005)(54906003)(70586007)(426003)(2616005)(1076003)(70206006)(336012)(6916009)(478600001)(8936002)(44832011)(4326008)(41300700001)(7696005)(316002)(8676002)(2906002)(47076005)(40460700003)(82740400003)(356005)(81166007)(36860700001)(15650500001)(83380400001)(7416002)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8879
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3eab67e6-b0ce-41f4-6dc2-08dbbf624863
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Yx7HV/hCqbhYuAhvIFmtHBWqbpi4gTUCzunTvr68jyb/N3MYg+XEExTupnw7Ump0Cnmsu3xtpssw8ORVKRhaLpsOYt1heiyXPCVDC0DM/Aj1+Gl03B0n90+z7PWhvdJr/IimaamoI8nWjoBPA+cAzyUHOVyrjbzwCDACu+kGnHPBPTetYh+HbpUVRdqDHmygZ1rJnPDvQNunPuu5z3jt6fOmtuaLByGseDkvY4Qs+GOggsfCfiz3f1lOAQ3TSXYPGdWVwTvtVcB+bThiwTS+TiQ5vH2HZyEehuEyUUhbgXL52UbiSHYxXPkgiZroPdfkBkHXwU3BuMtq1WEBdv6Wrr+m/fBeGYrIWNNhWx5Gw2DqIZNt0k1oWP+x/TunH+/P989fx6xel34RDAzOVptYV7GOv/4PeWOW2NhwYrHg9RKmseg0D1yZEdruUoUSHXE8VgaZP+TKWdAHlOpRVVaWpoHZpJPPN/gQMYtiyWiV4hs+eFLJlYdkmG/A6N9EKHHt4zW+uRfEc+fKy8ziUXO9MRtldp3NTdcC4Hr8cc+WsOT03lrc1KGKhmMKrTCvtLuNJPt2qiZtRbgNJK98Edl0VqubN0Je5N4k4idh39b50sG/f/9tvGr+x1syp5nyS24SiXxlbrXiWXpYVNjjVT2ywsDWrvYxSUHnNiJwMineBwU2Y9k79X45uPbm6uCOm50SX3XOCok7GNc3q8SfX2PoUtj0ul4geVdZcWeAvGRSqLJFUXMIj4bKvVycySrQyvul
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(346002)(136003)(230922051799003)(451199024)(186009)(1800799009)(82310400011)(40470700004)(36840700001)(46966006)(82740400003)(7696005)(6666004)(26005)(81166007)(426003)(336012)(70586007)(70206006)(86362001)(40480700001)(478600001)(36860700001)(107886003)(83380400001)(1076003)(47076005)(2616005)(54906003)(40460700003)(8676002)(6862004)(44832011)(41300700001)(8936002)(15650500001)(4326008)(36756003)(316002)(5660300002)(4744005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:14:06.3132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc35d002-1282-4c92-bf68-08dbbf64028e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5458

Add E0POE bit that traps accesses to POR_EL0 from EL0.
Updated according to DDI0601 2023-03.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/tools/sysreg | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 20f7dd25c221..a728176786cf 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1741,7 +1741,8 @@ Field	0	M
 EndSysreg
 
 SysregFields	CPACR_ELx
-Res0	63:29
+Res0	63:30
+Field	29	E0POE
 Field	28	TTA
 Res0	27:26
 Field	25:24	SMEN
-- 
2.25.1

