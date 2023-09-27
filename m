Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2068.outbound.protection.outlook.com [40.107.21.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AE538F8C
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFEjo2t9rOVduPNAJeqfskeri2ER5SQruQHq8BWJZ6w=;
 b=YBszuH0cAsq/i9GkKK54G7LGt1+ciPk18NcE440w5s1rYJpuFMbQQ2Dhx0rHR2HPilO8YaNatJjQBFtbOdIYDd0IKzASdGHZc/DoZ4Xz/9GGL/f61kvGNgShP81TOB1b6baAjiFB9eJhAxl++moX4LeaT7tIJUcNeTAB9mRkBr8=
Received: from AS8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::24)
 by DU0PR08MB9750.eurprd08.prod.outlook.com (2603:10a6:10:446::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:04:34 +0000
Received: from AM7EUR03FT016.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:31f:cafe::c1) by AS8P189CA0011.outlook.office365.com
 (2603:10a6:20b:31f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:04:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT016.mail.protection.outlook.com (100.127.140.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:04:33 +0000
Received: ("Tessian outbound d219f9a4f5c9:v211"); Wed, 27 Sep 2023 14:04:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 115ef5d33959daa6
X-CR-MTA-TID: 64aa7808
Received: from b618c45c74c0.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id E6CA58FB-CBCF-4860-9E12-600891D4B576.1;
	Wed, 27 Sep 2023 14:01:59 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b618c45c74c0.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlJSBRrQd9zuF0qGFRfJXE4x5iSynws/+DTgoCGPghUf8zA7MlKixoJEJ07jGEREcJkbJSE7RHmk5SX7Jps8YWbsTMPGZY1mwmRcqkwUIWChzuKxeT1bBrC9VK68F4XxJkHaFaW7w/U38FpFLneLB4W0slmFLWP8JrV/LjumirReC4nXs8SgwH7nSvqEhtzKCtIT3elIwtJtpA8W3+EYznoWElI4axybEC88eQuaOMlkpDAyODdW7/7Q0YMpkg//+3TeWqAYuh6C8Cc59Uk/tzmUPIfwpwo4+Gbl7JJHE1MYHXFA9iPoP28w6C3GE4RXxL8kAgjYJchlbv6p36pXpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFEjo2t9rOVduPNAJeqfskeri2ER5SQruQHq8BWJZ6w=;
 b=HuR9MoBSG4WO5/udbccZNmcDRuRPj1tLaYXCGmHfDzjmH4q7LkUYtJjHXBeYLOb2Bg+z3vb2KtG6Tgftbm7f49e5DIVRNr/UqGf/xAg8nJlraURiOJJAxuc69dDDfdiBkOecKxJi63afVqRRHNJsbrn8qOyZfbDqUwX6y7P5SNUOMcDsdpIMEjFOJzaOlweAC58EQj3q6LAswAzTibdGhTXtxfA96mtC4WfZzqrsWPKYptKNZW/Gm1r5ujwbujs5V0vgPPwPn9pLnTXJyS+uwQHytCb0onWiSePYEbJ4gg4n5Yb+QEsCNRtSYiXN0IEknWcBPbYxBHm+zH2kr4pe7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFEjo2t9rOVduPNAJeqfskeri2ER5SQruQHq8BWJZ6w=;
 b=YBszuH0cAsq/i9GkKK54G7LGt1+ciPk18NcE440w5s1rYJpuFMbQQ2Dhx0rHR2HPilO8YaNatJjQBFtbOdIYDd0IKzASdGHZc/DoZ4Xz/9GGL/f61kvGNgShP81TOB1b6baAjiFB9eJhAxl++moX4LeaT7tIJUcNeTAB9mRkBr8=
Received: from AS9P194CA0005.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::13)
 by AS8PR08MB8275.eurprd08.prod.outlook.com (2603:10a6:20b:56f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 27 Sep
 2023 14:01:56 +0000
Received: from AM7EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:46d:cafe::7d) by AS9P194CA0005.outlook.office365.com
 (2603:10a6:20b:46d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT013.mail.protection.outlook.com (100.127.140.191) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:56 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:43 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:42 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:42 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 18/20] kselftest/arm64: move get_header()
Date: Wed, 27 Sep 2023 15:01:21 +0100
Message-ID: <20230927140123.5283-19-joey.gouly@arm.com>
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
	AM7EUR03FT013:EE_|AS8PR08MB8275:EE_|AM7EUR03FT016:EE_|DU0PR08MB9750:EE_
X-MS-Office365-Filtering-Correlation-Id: a115b8c1-deea-45c7-5911-08dbbf62ad5d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 jFDFJ73sw6DGXXsVRdE2jbsvQ66GIiN8BVTv6KPgRx9n5Y4Ecgj9LeeXkb7MeFfka5D6mnTreBUIMhXKa48S2FxVXe5dY0ETh5dAay10vRMCqGVPtN42CBovbNCxOqlGL8rDv9jRPz/TFBMZTShLoxZzq7XZRY2PwztUh7uoIfn7d2hE7wLahlFt2fm3PW30ZDznxAO2+/vXtlHmCT9cpIww9gEBwYJ8uGAN/i9c3TQDjIiN0TPuI2RVLMrpGK8HjacTlNkuJhNdrGyDbLC3f9Vh2nNHYNJs6H5hw5zbC7D0DbEg+isl99hODMo3CgGqKjdi9oRsiR9AfOru9zLKqBHJsrSiGPRYob6iDJUdg2N2NH2+7nVj7Wf6uIapwkQdXxPj7P9Pwrk9qYD6rcOQsTgOSMESi0nVa2PhX4o3E2rSEBLYzPVy5lkT2Cga7nCh+xbbCQ2bOOfT+wsdz/HlsjLdL3mjPPEgv39m/DeVZkepT/JK+FJjwutP61NUOovuZhUBMYtM94sIP6/MiStoVz75RoG9cKDPI5DP6Ct1DmUq0+WpX2QC6KZxRRPlR+MX7n8SlfkWhXg8bI7eQwuHQLuAkZF365ldtJ46sb5Budc7kwxrrEyUBLgeyCHI8H9ct6fMq869vY+gYxtqBwBcKadVES3vm/kC2eHW0msTN8/kvHqeeoqbTaDuEFFtVnJ0fmBS4TCEa1O6dFAFSKjpUtiWBsstWOO4wZoz1e8J8g1sU/hQV7ZVZHYcW7ksHGkBAzNidN4H6OJ/eUYAAtbDZA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(396003)(376002)(230922051799003)(82310400011)(451199024)(1800799009)(186009)(40470700004)(46966006)(36840700001)(6666004)(40460700003)(36860700001)(36756003)(7696005)(82740400003)(356005)(83380400001)(86362001)(81166007)(47076005)(2616005)(426003)(6916009)(316002)(26005)(1076003)(54906003)(70206006)(40480700001)(7416002)(41300700001)(2906002)(70586007)(8936002)(5660300002)(44832011)(8676002)(4326008)(336012)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8275
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT016.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e400a40d-5a52-4a00-a7c2-08dbbf624f53
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GkE1EvuPfVfAF8Swb7R89U9PcHYrShZym/SI8w0Emy4gwgfeuYZikeY5c1QclnahhHOE9Pra8sXPN6usWngFgzQgcH+PKkq7i6cLGR5PalarkuWJ/ANyj/kzBjrpQf2njzaqsRg1R9A4fPZB/mMdF2MABZW8t42oyzyz1O1PylEywoxJ1djSWD0ZR9igXuWGdpnQJURtHpajWz4gIZhcju0UyiQTeQ/XGxJPx5pJmT+QUCAzblPtyhrTLwnsVUkbq9z2Gs61SAEIEWDpfHhP3HBxvpVb6e5ZBjX2UyLK0/IgIXyEDpuVRuEw51illlphr8vvlMCmH05S0F+B+3lU2keQBPKLA/Vlexd1H2fZzvrQgeo87Qzr+TRzYcXYy1/z88CR6DgF9iJxNmEMAHiYj6gN5iolP3gghgznHhjyfZ9Q7fRWJHQVUpyOu6EzX/1Abe1cAHDB/jUr2JsjJ/inuFKNEdhQ/cipSNd7qbW7Edpe+EwF/BfoNIL9N3WaF5ptv5Ny8U6quC3FM7+ZCGCMyaKnvyPjiNbvjZoPjLnQX1gewCWE1KIg5ItJisvIf2EMQ93lz4xrZXPocAz6rh23IUG2e8CQY48N3RXYc6eU0UQ+cd6u2pB7Q8D4LXSuhRJ+iMCIno1NQP2ktd/5oW+9xrYih/2zZJmp/cRIloTXIlJ4PHhdvo5dzpfEN87lyVoe8ZEbWvyyHlcUc3goSst/eCZFVJ0kYH/iWceJlRpbCjFVZ/QSV/HAehtBDqceih/F
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799009)(82310400011)(40470700004)(36840700001)(46966006)(2906002)(36756003)(86362001)(40480700001)(5660300002)(44832011)(26005)(70206006)(54906003)(70586007)(2616005)(336012)(6862004)(107886003)(316002)(1076003)(426003)(41300700001)(478600001)(7696005)(8676002)(4326008)(8936002)(47076005)(40460700003)(82740400003)(6666004)(36860700001)(81166007)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:04:33.8708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a115b8c1-deea-45c7-5911-08dbbf62ad5d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT016.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9750

Put this function in the header so that it can be used by other tests, without
needing to link to testcases.c.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 .../arm64/signal/testcases/testcases.c        | 23 -------------------
 .../arm64/signal/testcases/testcases.h        | 23 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
index 9f580b55b388..fe950b6bca6b 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
@@ -6,29 +6,6 @@
 
 #include "testcases.h"
 
-struct _aarch64_ctx *get_header(struct _aarch64_ctx *head, uint32_t magic,
-				size_t resv_sz, size_t *offset)
-{
-	size_t offs = 0;
-	struct _aarch64_ctx *found = NULL;
-
-	if (!head || resv_sz < HDR_SZ)
-		return found;
-
-	while (offs <= resv_sz - HDR_SZ &&
-	       head->magic != magic && head->magic) {
-		offs += head->size;
-		head = GET_RESV_NEXT_HEAD(head);
-	}
-	if (head->magic == magic) {
-		found = head;
-		if (offset)
-			*offset = offs;
-	}
-
-	return found;
-}
-
 bool validate_extra_context(struct extra_context *extra, char **err,
 			    void **extra_data, size_t *extra_size)
 {
diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.h b/tools/testing/selftests/arm64/signal/testcases/testcases.h
index a08ab0d6207a..c9bd18e7c538 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.h
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.h
@@ -88,7 +88,28 @@ struct fake_sigframe {
 bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err);
 
 struct _aarch64_ctx *get_header(struct _aarch64_ctx *head, uint32_t magic,
-				size_t resv_sz, size_t *offset);
+				size_t resv_sz, size_t *offset)
+{
+	size_t offs = 0;
+	struct _aarch64_ctx *found = NULL;
+
+	if (!head || resv_sz < HDR_SZ)
+		return found;
+
+	while (offs <= resv_sz - HDR_SZ &&
+	       head->magic != magic && head->magic) {
+		offs += head->size;
+		head = GET_RESV_NEXT_HEAD(head);
+	}
+	if (head->magic == magic) {
+		found = head;
+		if (offset)
+			*offset = offs;
+	}
+
+	return found;
+}
+
 
 static inline struct _aarch64_ctx *get_terminator(struct _aarch64_ctx *head,
 						  size_t resv_sz,
-- 
2.25.1

