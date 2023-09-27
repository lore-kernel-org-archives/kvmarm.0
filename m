Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2083.outbound.protection.outlook.com [40.107.105.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2128938F8C
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2cZerk0+6PXu1NQWIxDK5yc5JLsqWJDlqir/wW190w=;
 b=DuPWyC+ug+6tqqtcb8FyQi8GHmTo1s1UweQoatj3oAhKNBWGyl+ipcGO6RS36xEnKqZLicwMcwlZw0RK6Jfktmy758ICHgojuXA9C+qr45yfiG1CRGcujMlrtgdiqgMnYanhkjE0ZprJWcYHjKgdmaANTp8wokHTl6YOHyyjOjE=
Received: from AM6P191CA0026.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::39)
 by DU2PR08MB10301.eurprd08.prod.outlook.com (2603:10a6:10:494::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:03:43 +0000
Received: from AM7EUR03FT021.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8b:cafe::6f) by AM6P191CA0026.outlook.office365.com
 (2603:10a6:209:8b::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:03:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT021.mail.protection.outlook.com (100.127.140.243) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:03:43 +0000
Received: ("Tessian outbound fdf44c93bd44:v211"); Wed, 27 Sep 2023 14:03:43 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 165230e19496bd7d
X-CR-MTA-TID: 64aa7808
Received: from 5a43b32ff89b.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 0353F5BC-0A9D-49A8-802B-8FD8647BE74C.1;
	Wed, 27 Sep 2023 14:01:50 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 5a43b32ff89b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyMOyLxc3/M99D4ocLz7hhZsCLEte+wOfVYlu3KgNOJOFnAYxlMXICEGAb475HqzLKcj4KqzAohuL3PRxU2j0DZpVV4ms2e0MFTL2y7ReKBzOkYw7Xu3Gp7KxFrF03qiSxISk+K8YFbUr+lTs8PSIIzSUJL9YlgHVKfznqV15/iglRChgQalmvLvQ2o4TGholbgtmyt+qNoEfS52AjTehoAeXdkCYzXT1kecGhfRO3qmF8mIQyxEqMjSqtd5qCs5leoSrSpHeltBt56rd4PfrI3yQiJZoyx1uzyPuTyenRXb0OiSFlCAJvmhbNlzbpB+6bt39t21GIR9Ltaf65I2gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2cZerk0+6PXu1NQWIxDK5yc5JLsqWJDlqir/wW190w=;
 b=QzHdZCI2mHe54jBuhsei15S8FyEycsFLy72ODB/vb4lIc9aHQxkJLqW6TY0l3aO67XGkOc4f21thY2BPLqHE1QEnH14EzM7bDryokh5zWhuyet77uNa7Q2xN17Hhg2LFS9i/FK6P+7y23rrhxdZRRscz2MVgci1/NjPmhc4jiOQnQz+R1uXG+vPJV7I1H8t6z3QZZZQr7rrWnqHWoMsxL1zcVy1/lgiKS3UmPDz67xS0XlmfsDNfdX6/R/lOldXUxR7IY7Mx0cHkL0wh0SOJ9zc43gftQwTQ6VzmpQOjmMmW3FdOVt2GoRYF2quUXJUnaEwjnFI+6OMLRPN74g4OKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2cZerk0+6PXu1NQWIxDK5yc5JLsqWJDlqir/wW190w=;
 b=DuPWyC+ug+6tqqtcb8FyQi8GHmTo1s1UweQoatj3oAhKNBWGyl+ipcGO6RS36xEnKqZLicwMcwlZw0RK6Jfktmy758ICHgojuXA9C+qr45yfiG1CRGcujMlrtgdiqgMnYanhkjE0ZprJWcYHjKgdmaANTp8wokHTl6YOHyyjOjE=
Received: from AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20)
 by PAVPR08MB9064.eurprd08.prod.outlook.com (2603:10a6:102:2ff::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22; Wed, 27 Sep
 2023 14:01:45 +0000
Received: from AM7EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:ac:cafe::6) by AM0PR07CA0007.outlook.office365.com
 (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT048.mail.protection.outlook.com (100.127.140.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Wed, 27 Sep 2023 14:01:45 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:35 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:35 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 03/20] arm64: cpufeature: add Permission Overlay Extension cpucap
Date: Wed, 27 Sep 2023 15:01:06 +0100
Message-ID: <20230927140123.5283-4-joey.gouly@arm.com>
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
	AM7EUR03FT048:EE_|PAVPR08MB9064:EE_|AM7EUR03FT021:EE_|DU2PR08MB10301:EE_
X-MS-Office365-Filtering-Correlation-Id: 595823d7-c94d-4e2a-3866-08dbbf628f69
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 bcIwrLxeAPxfQ7Aryh5mE/7MMrmd+rDvgdNHXSsh7YFgpJNd3bcZdGkmaZfsP0kxDSr4a4kAXoQE/20slaL1r6ueTSPEf7cmbxwE7W0fynlLc+Hz11SK9TDwkpsWhH9WEbjYTSEVwM6dsYH52ENgFq930i3Ae0uYhEXSlisIWYCb7u+9p4RQrUzVHMl4x8sQ/mMHVosSnn4zihVJWqSunJgmj4PzfkVtZgntF8TJiZ2ZAmtQyUOwr0hT1IRg0cgZug8J/NvFMBSPiDPzFiWFhrNB6ViJX32RSRv5HL7JMp8YqD7uWnB0Xu3QTRcF5pKYHp22Ryzoe3899FCs+CMHDmkTErxY0cWBlsas9bPJZQClGRczRsVgRYSeJBVdzEFvaC5dcP5T8zW6+e11MdiOeNayTokU/ikvdppGtdYl4brCkxSJHBBOdoSsSXTQqdQQHnS237wL889Y6PPoq10+wEaeAJbayhAhIVkXY2q4s/6JB5vNunPnB21PqYO+t6+qk7iRKvRsX1T/zlkAvTbHt64xZFnAh7XaukwSPlU6OoAze9lsNLSHiO3LtXRyx3O3K1m4QVyDHGwxEhdVCJmedSrQ6TUeV87L1yPvJ1M0N8Cx21legOgqIHVkqmEHWracjVI17aqaNXnhg3YtkgHHKGxyj4GwyvZrLWNKqsRVTMtTHavCEYnGwm6OPAZIwT6w29TdXS91CJQViS9sa3BTZaQgPij7hAniF3izpzy+kr4V+Rxm3TmzD9/4l5wfPt1Z04bxOHa9yUIAco3fMromRA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(396003)(376002)(230922051799003)(1800799009)(186009)(451199024)(82310400011)(40470700004)(46966006)(36840700001)(40460700003)(2906002)(1076003)(7696005)(86362001)(36756003)(6666004)(2616005)(478600001)(426003)(336012)(26005)(40480700001)(47076005)(41300700001)(44832011)(36860700001)(8936002)(8676002)(4326008)(316002)(6916009)(54906003)(5660300002)(70586007)(70206006)(7416002)(81166007)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9064
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	94c6da0f-addd-45cb-c5f8-08dbbf6248b4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gEmY00Q/07J+Q1TUN/TfGLbFge/BW6vizS5wIzbakPfPrCNtoTOHA2g5b4VeaUYpY3MwB78dp8w6sBJJdBUglZXjrKf3HZ6Vn2AZWSC5wt5boQ/UwpNZlBkqMVXHnTP5bwTqpDl6VoLlXpo6RvcUunEBBmLDL4AQ7S9X7668Y3TDCaXdgpcvRAq/2jAbjIiOSjgdh4RTS5MutjGIpiAY3ZV450dHP1ESpaUDvFC4dh3PbOH0v9IWHLXf42LwH+wggRQjuviDf63+9hX+q9Q0l0A86XYX+iuhrfNQ0LMltG7WfxgK5NU8+zOO5jrLbJcmU8+LL/+0ul38vTLxLiLmj2Yr9cr9t8Z0PsOWv3GfZ6i8KC4S/cn/8Aj+86rOYsjyOMAqnvniZ+JK7Y1KkBaeUU79im7rFJYlpKUnVx90o/W70zFIAsG25+ANH4G03K+51LeEbvRjuuKmyrYhrbXoWLIq7pUUSYPd+Tpk40BkLWI1QgvGuBitN2mJdT+oYuOA3y154fBLika+A69Fmn9W3Jx+1jKzbBdwYU+cWteUclcSZdgbdX/q0VKhTlmq4Zi6U8jDgZ6KHdP4941yrhLKFhV3svpgzQtzxgUiqv2KvPp4aJq2UOF5Uspyp7PfeZZrkcRF7X4Pzf24aIYeYXNCa8ZOGFjUMNxjifLwNkzKOYS/zJgBdGh+vYILQDNcHumcPAWjhdviG7NON6dlGhrwquaj4YrlmW3iYJd1V1HpO3A=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(346002)(39860400002)(376002)(230922051799003)(82310400011)(186009)(1800799009)(451199024)(40470700004)(46966006)(36840700001)(316002)(5660300002)(44832011)(8676002)(8936002)(36860700001)(40480700001)(4326008)(41300700001)(54906003)(6862004)(70586007)(70206006)(40460700003)(2906002)(81166007)(2616005)(7696005)(36756003)(478600001)(47076005)(26005)(107886003)(86362001)(426003)(1076003)(336012)(82740400003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:03:43.5232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 595823d7-c94d-4e2a-3866-08dbbf628f69
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10301

This indicates if the system supports POE. This is a CPUCAP_BOOT_CPU_FEATURE
as the boot CPU will enable POE if it has it, so secondary CPUs must also
have this feature.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 444a73c2e638..902885f59396 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2719,6 +2719,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
 	},
+	{
+		.desc = "Stage-1 Permission Overlay Extension (S1POE)",
+		.capability = ARM64_HAS_S1POE,
+		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, S1POE, IMP)
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index c3f06fdef609..b8348e40f6d9 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -43,6 +43,7 @@ HAS_NO_FPSIMD
 HAS_NO_HW_PREFETCH
 HAS_PAN
 HAS_S1PIE
+HAS_S1POE
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
-- 
2.25.1

