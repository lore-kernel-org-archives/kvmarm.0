Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2088.outbound.protection.outlook.com [40.107.247.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0EF38F8C
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgV4AndAd6/NO9/4ic2BHYdTbhCHHX5oZ2R85t/amgM=;
 b=fBi8yVJbEZXVSIWUHLBgyyGhYw9wiKu9NfRQnbJOT2y1pvRUnexrLxHfNrlyUgxBs3ibPhf4Jn88n5hvhZbc3e2JPben+LA2qjU3uUakRYbOBN/XeILt/TLD0lrwmH7YknCu8fDA4TI4y36g5MFqPHQ0t6qSDhyF9NNSQ6ccCJQ=
Received: from AM5PR0601CA0056.eurprd06.prod.outlook.com (2603:10a6:206::21)
 by GV1PR08MB7986.eurprd08.prod.outlook.com (2603:10a6:150:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:03:54 +0000
Received: from AM7EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:0:cafe::d0) by AM5PR0601CA0056.outlook.office365.com
 (2603:10a6:206::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Wed, 27 Sep 2023 14:03:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT061.mail.protection.outlook.com (100.127.140.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:03:54 +0000
Received: ("Tessian outbound 6d14f3380669:v211"); Wed, 27 Sep 2023 14:03:54 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: e99df280e4da48c5
X-CR-MTA-TID: 64aa7808
Received: from a4cf691621f6.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 41CA881A-83E6-4171-8877-73ABDAA70DAD.1;
	Wed, 27 Sep 2023 14:01:49 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a4cf691621f6.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5w23chlw+WPzhcOxhXesqVNDAly4nIVyV6JkxWWzEUHa7+fz9zJOPrzkygwrWl/4b2FZco1fjBBprZKlym6qu7PJ9Q/WFVdUwF1xBckMNkU8X5Ht7UVEQWKlSnjbaG18fyNPNKPKRN2IcxwncEEDDp2WtlJ+s4SJ4hRIWhQF4ZNJ2ailtlG1beTn66aD7KE+lhDqBvmD3ynfLgYFoJqFodBsqp7GYIWzgqPOtn9pscewE3XuN0ftr2OyCH7WaxEUvuJg9xRS39capA46UDdO6/DUQ75Jd16DahH38qLLxyrw3Kk1rfpBZ8ncffbULMDn0EXZUyXt5mwzliP2tjbnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgV4AndAd6/NO9/4ic2BHYdTbhCHHX5oZ2R85t/amgM=;
 b=HwQ93XZqnHdxMcWP2K/O8OD5y4dkfsUXuB0ETWj+9+CsMz2PwhnFtexztmE2VqZNb3oqG2xSOvILBUHTYCOQcAXadSYlLjPxcrL54uk9fRRkeJiuh+NjM1nprm8Qx/l5dv8ue1ZASBgTFiuy8KbpndB+s7uvbL3K1PgPRj4ZqLuok8aTshrfjt+DEV5HxUc2cFw4USOV7PBJzijwJtyG1vTsmftGDaMJui8hO579vqK/tB3pqc9MRrsrPEYrI0yuH9lIUIYByDKOeNE/9s2jhVLGNmIW9QyO5yKOA+f7FGx85W3JpSRf4jTZgJgI+LjmrhAbMT2Raeam/qEj1G6BBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgV4AndAd6/NO9/4ic2BHYdTbhCHHX5oZ2R85t/amgM=;
 b=fBi8yVJbEZXVSIWUHLBgyyGhYw9wiKu9NfRQnbJOT2y1pvRUnexrLxHfNrlyUgxBs3ibPhf4Jn88n5hvhZbc3e2JPben+LA2qjU3uUakRYbOBN/XeILt/TLD0lrwmH7YknCu8fDA4TI4y36g5MFqPHQ0t6qSDhyF9NNSQ6ccCJQ=
Received: from AM0PR07CA0032.eurprd07.prod.outlook.com (2603:10a6:208:ac::45)
 by DBAPR08MB5655.eurprd08.prod.outlook.com (2603:10a6:10:1ab::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:01:47 +0000
Received: from AM7EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:ac:cafe::ab) by AM0PR07CA0032.outlook.office365.com
 (2603:10a6:208:ac::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT048.mail.protection.outlook.com (100.127.140.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Wed, 27 Sep 2023 14:01:46 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:38 +0000
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
Subject: [PATCH v1 08/20] arm64: add POIndex defines
Date: Wed, 27 Sep 2023 15:01:11 +0100
Message-ID: <20230927140123.5283-9-joey.gouly@arm.com>
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
	AM7EUR03FT048:EE_|DBAPR08MB5655:EE_|AM7EUR03FT061:EE_|GV1PR08MB7986:EE_
X-MS-Office365-Filtering-Correlation-Id: 99c77297-1770-40df-577d-08dbbf6295f6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 EwkC6Zia9l+fdtlOVKrIkAaWhHI9KECKsj0V4v9u+YsodeAjUz6GymS1ERL2soArq1640WpiqTZ7FPHzJDLcIcbwIEr4jakWdrTCwhs5AWterK5RKH65ll+TbLVOuQg4CvAlYelVB4L/pxDyP46hnQL50bYwo4VxAVYui1Pq+S55IEIJe/QhqiiyGew6k6ur17NV9+gq1SUimGTl7Yt+AltQbysB6PF6fgGRKcasBWwg34p3aZcdmo8H7v16TNYoMRnwxhwZykzZ8jb2KpUUCBaiFI6nE3N0Q05LAnwqRVTQviRhFzKNAc3k3GPrj5BJvKg/HvMKq3DO8IbJhQIFSR+f3ZB2S4r9TNHcaVdEssFHZwEFB04s8qup5dHpzSEZNxeTIOAhf0MRmFSd/My0UDTOG+BeWp3tnkAOgCdCpUOL1cZiA4LHU7pRMiZ5ppqHdfYKJOmiRjUNFmYd8fk1VRnq1Kari650hufAfmd7Zx/TCYxQNOTzCq7xju6D7MqeCOB3a0ofSHZtpuhUmfkj8x6XCeAvLNUjQPJw+w7x6ewwLtk2+3gswaanT+OEl+WKzCJa6kiIjx6SeTvAw+Gk/X664AZDmJmk5Gg0X51YYsoCFKlG51A+JAialu4zDkKrBwwI+LW+m9TuZfHWQtS9uG+c0E9xXDBU9kz3E8jbA5BJYA68jUQXWvCnlhq04U8rYjhDocYYRHdePpr+uLka+z3cUznYHXtoE9gi+qW8cFC/vJXnCmjJVUHUndWQ6KOl
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(186009)(82310400011)(1800799009)(451199024)(36840700001)(46966006)(36860700001)(7696005)(6666004)(82740400003)(356005)(81166007)(86362001)(47076005)(36756003)(1076003)(2616005)(40480700001)(26005)(426003)(336012)(2906002)(316002)(7416002)(41300700001)(4744005)(70586007)(54906003)(6916009)(478600001)(4326008)(8936002)(8676002)(5660300002)(70206006)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5655
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f727312f-2a1d-4f94-63f4-08dbbf6249dc
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sIb56YUCbiX499blYVj7kqggazI4pOhN5aJfPvZMyUq4ICs/stjm41G1wIBfUH/+pMHHX54h3+ZrOHe1kCK1u19vQqE0An+L05KPEBnVyUTt4avxieM7RZ8ZS8l140RabvXCthxwC+Gw7r5/pVwsA1+S4peMlma1H+yaOW1YpitDwtpgkGsdW/SLPjPYRqeC35V+XuOzHGEUWB+V/7e0YNW3tj2FjgCn6jNk33dY7yUILNXXImQMwwaKPM8QwhEX7FSuhJ2kFOekVbw9QURqQQdPjKgFoHnZ1GHWa9Ukyu4fywfrBnXOiJon/VAHlKXqf6MCC4Rp3OIaoMsLMUjoNI4kw4sDa/9l8rokrS200ajA//q/BTNJY6KiPHIUWxEvM36KFhq/XZ9qD6iVgB66WUE/PAm6ut57cuSjiPwWLxUPqc/BhJqVpXWFXvUYsescslyJQorFMwlHQNGJWAspWxKHl5leywuMFUPpKFBiGcgs/SQli/0+WgJ0Fk7BOMtkojzag491fP0fAbzw5jIIo+X5KDF+6+Lb/Bx7vlR0g0/Ctal7zo8RZrLdNggIIHcwNW7OkPndaK949agKelhzT+bjMNPciMwzZOdOPxy4JnoBdLtr6ghmPlBSKPDGJ+Z+1xz/oYD+UpJn6CxMVOXzzdAryZiGaO1Dr/YtcothLybi3rkheiQ2ZpgO8ZRTtWeRcsJbIMsTL+UCniE0XJCZnl4jsIaa8XPGMoNpAyK1bKwHv/v9N4iF7r8fk4juFJ6U
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(346002)(136003)(230922051799003)(451199024)(186009)(82310400011)(1800799009)(46966006)(40470700004)(36840700001)(8676002)(41300700001)(54906003)(316002)(4744005)(70206006)(70586007)(40480700001)(8936002)(4326008)(6862004)(2906002)(44832011)(478600001)(40460700003)(6666004)(26005)(7696005)(47076005)(5660300002)(81166007)(36756003)(426003)(1076003)(336012)(36860700001)(86362001)(107886003)(2616005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:03:54.6238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c77297-1770-40df-577d-08dbbf6295f6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7986

The 3-bit POIndex is stored in the PTE at bits 60..62.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index e4944d517c99..fe270fa39110 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -178,6 +178,16 @@
 #define PTE_PI_IDX_2	53	/* PXN */
 #define PTE_PI_IDX_3	54	/* UXN */
 
+/*
+ * POIndex[2:0] encoding (Permission Overlay Extension)
+ */
+#define PTE_PO_IDX_0	(_AT(pteval_t, 1) << 60)
+#define PTE_PO_IDX_1	(_AT(pteval_t, 1) << 61)
+#define PTE_PO_IDX_2	(_AT(pteval_t, 1) << 62)
+
+#define PTE_PO_IDX_MASK		GENMASK_ULL(62, 60)
+
+
 /*
  * Memory Attribute override for Stage-2 (MemAttr[3:0])
  */
-- 
2.25.1

