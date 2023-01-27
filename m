Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2050.outbound.protection.outlook.com [40.107.249.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1793C28EF;
	Fri, 27 Jan 2023 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBnCN7QdJ8CYRLAqVvlj5JNGftuZbnrdU6WdPVMigKs=;
 b=knpPzsPz7n9YQw1GOhwwpl0pfhjsJo8wcsjObJRt+swLP6QkNS4mOqTfz1Ef6zrybR00mzl1Vbludz+aa2MlQGAw5zTqh3Pqwt2gojEHWHH54aCAmobhw9Yhk8otUWkVn//lT57+12p1duRNI7VodJdImvIfyKFy52RxZR/1nkY=
Received: from AS9P251CA0021.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:50f::21)
 by AS8PR08MB5909.eurprd08.prod.outlook.com (2603:10a6:20b:297::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:34 +0000
Received: from AM7EUR03FT021.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:50f:cafe::68) by AS9P251CA0021.outlook.office365.com
 (2603:10a6:20b:50f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:34 +0000
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
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:34 +0000
Received: ("Tessian outbound 8038f0863a52:v132"); Fri, 27 Jan 2023 11:42:34 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 989407ff5cb2e6bc
X-CR-MTA-TID: 64aa7808
Received: from 665dd25750ca.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4420A9C3-87BC-4116-98FE-BA2B14E1F1AF.1;
	Fri, 27 Jan 2023 11:42:27 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 665dd25750ca.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv7LIYB2Q253DlqNaBPN04dNmrXUuAlmJAEQEScytcbXm3FAnRzBUm8rJbugP3AUGXky5VFdjdg310U+rY+gLsPhwX7yIb5BLM+2bAlnByWzPUfy+mj0G/WOIx78wHxPTcLh/GWNcc5AYsvMAjftzSD2uNHgycYAFLUlB6oEjnCOBTW9zSIg2oQ58o7J64+KBGqmrTHMwrccZu5eOvItkzceUKu8SJptz+nveoWFmHoBV9svTkuA69XBgBkyTJehmmFutfM1dlFAiF3d/9D9QK1sp0fSoMPYB95KRAE7ljTpkGMiJb146FGbcHVUP/ZVm8XTFzm6d7rIGPapLGXcXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBnCN7QdJ8CYRLAqVvlj5JNGftuZbnrdU6WdPVMigKs=;
 b=Yl+XtsYF3lv8GyMHbSBb+UmW3TCDVO8lzdV3cx1kRmbpYewnN/W+mQ2nN26eoAye+LzEio6I9Xz0yTUe5SWvq65cHvuh95O8HXi/+EHlKvW6JUdLuGeIMp7fn6fK8qdSs1ar60W/CmT6jZgwylHmTKbGKy6yvMePc3Yr+/wZLUlCpp4qKr0emJ+L7O+Zg7qxJXNie/QbGWdvFGM4O6Lp+QbZlHDHgpiC9/msMi8qlBlvSRNjLUwv0P7PQeyIDhLraJoXzMQx+NzHrYE5BPFAwyIyjmNJU3p6EG46BlhtqA9VG5eFPdmrIBvLlZbrd0bJHO20g1brz6864mpIFT+rgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBnCN7QdJ8CYRLAqVvlj5JNGftuZbnrdU6WdPVMigKs=;
 b=knpPzsPz7n9YQw1GOhwwpl0pfhjsJo8wcsjObJRt+swLP6QkNS4mOqTfz1Ef6zrybR00mzl1Vbludz+aa2MlQGAw5zTqh3Pqwt2gojEHWHH54aCAmobhw9Yhk8otUWkVn//lT57+12p1duRNI7VodJdImvIfyKFy52RxZR/1nkY=
Received: from AS9PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:20b:497::31)
 by DU0PR08MB8186.eurprd08.prod.outlook.com (2603:10a6:10:3ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:25 +0000
Received: from AM7EUR03FT035.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:497:cafe::d5) by AS9PR05CA0139.outlook.office365.com
 (2603:10a6:20b:497::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT035.mail.protection.outlook.com (100.127.141.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:25 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:23 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:18 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>
CC: <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Joey Gouly
	<Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini
	<pbonzini@redhat.com>, Quentin Perret <qperret@google.com>, Steven Price
	<steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, "Thomas
 Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>, Zenghui Yu
	<yuzenghui@huawei.com>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 12/27] arm: realm: Add RSI version test
Date: Fri, 27 Jan 2023 11:40:53 +0000
Message-ID: <20230127114108.10025-13-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM7EUR03FT035:EE_|DU0PR08MB8186:EE_|AM7EUR03FT021:EE_|AS8PR08MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ae2905e-9b41-4f07-f8c5-08db005b94e4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 i3s6LwEfWeEBxbNWkoNA4XkHRLRr9m+ioxOaYmnSXfL8p1gjmiPg8dXZ6zipI9g7McSOHvpzd/GoiTX8abKjjrLcsWK9kguA/gHQ43JsWRrBdTm3pXRUNeAC2r1pxYKCVmXyu5U7GpG3RaVG9y/XVKn3gSYsWTEnoz4mK2WXRECtoq9qyaoDldgwuFydMQD5z2BumxRA2qrDJ6u4WdInffULbejT0NjpZ1dkvsc9YAodIRCDOJCVNCn8uKowMykDFrEd5cOirpiW1mZRxRQipi6KxXPRJuuvTIf9LqHWRi7YCJPgaaQsxrwpmR9lqV/3P17E+eLysJwQS5KFFEB5jHRnqh0ArXSUu53qjpo24YU2ZYHnvntmxdRnd6uhoF/L8Osjq1liIPuZqbNtXI46SYVMl1yoEO2HVMJx7iktTcoTqxCuFWDFB157HHjRz5EGLAu0uD6P2h29bdLpRwiXW8M4J1mr2HVPKOBs7qnzqXMWttXgTVsKNkw3cQP7T/1vaF8CxqkRLehBcFjYeapGQEJ2Wuqaj30AdGyTMUDiC3zRtQs1ft/iEiusrEi2qRaxAfd0a7JAAlX/KdjEziPy5MIAgrRSKerOJMp5wxnWxEuSOwyQHz/VHFIlDFdgieS/g4pDDrk67Km51Y1T/D2numYI6onQzU8Lok69OCPcuP07EQgYbKXgug346uGtoFo2sisyBrHMRh0tT29zyzR4+i5bqH0P8X1SlKnn6gBkrlOOzAx2fDvsxbcdCrndhqPA
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(44832011)(7416002)(5660300002)(8936002)(47076005)(426003)(41300700001)(36860700001)(26005)(336012)(478600001)(2616005)(6666004)(186003)(1076003)(82740400003)(83380400001)(70206006)(40460700003)(81166007)(7696005)(86362001)(40480700001)(356005)(4326008)(70586007)(36756003)(82310400005)(8676002)(54906003)(316002)(110136005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8186
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	77adec84-efc2-4db8-853e-08db005b8f81
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XZY424MT1KUAEQHV9W6vohBmgg+Di165eHcfU95Koy+6TjB/RL/TBOqpo+KnQD/tgFzVa0HDH2WVrsCdG5a9qaclry5r5zEjD4m9wa7m78ytn2SK+3QcAc8jhAS1pOo+YFP7+BGUtljE/z7PUSahYKDUpoKDlYbBlLDnN2xTzlLENzJvgQ/K9WdAP9Z4vyhLEdqu7Eso0WvE7WS0/gjc11YTCgzmBWEbpilCnwh8fmGRC7XSRVti3BCrfQ3dIDtewcGGZoySWm26ET17s36cEuoJOANRrJwly5hoy0coMS9PzGKrEZAEp9oUCa5p92q01kpn8RtFy7EsUqmkXTOslHGLHLbzJuTfa7TtF3Pk9lhmMT8aCF4i+xwTqRggYHu5MTcWydjrwOUE9MT6+wT8DNJjzozNUJCh4uMwESvLHHiK0IV9rSHmipVTFO3o/iXonAsgN3ITm6kQjXDkolxIDvCxuTUTyLJMRpaIAHplQkAXmWPtBQMJr4+YVT33av76LdyUnbUyPI3KQ5SEFKqjQHnQpX19JcbPocMtw1LbSg6nuLmXSb6hb5vaP6ip5RUyPUfiZO4ajZLeXvZWL1/LYjPkFGHrtdUaQbiKUUkm6/42fU9jcw6KnqTh6RF1tFjotOpYt1Pe3cH3l7kHgQf2W2V47vwX5su6E2fTkHD1mei1LfX4EO8XWP1aXX8+MhIHixQyFoT+cq9jhbNTZXL+xDpkSNSr+fVMHIc7zkR1F7c=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(40470700004)(46966006)(36840700001)(450100002)(70206006)(4326008)(70586007)(41300700001)(8676002)(83380400001)(54906003)(8936002)(316002)(5660300002)(82740400003)(110136005)(2906002)(81166007)(44832011)(36756003)(40460700003)(40480700001)(36860700001)(47076005)(426003)(7696005)(336012)(478600001)(86362001)(6666004)(107886003)(1076003)(26005)(82310400005)(186003)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:34.2333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae2905e-9b41-4f07-f8c5-08db005b94e4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT021.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5909

Add basic test for checking the RSI version command.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64 |  1 +
 arm/realm-rsi.c    | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |  7 +++++++
 3 files changed, 57 insertions(+)
 create mode 100644 arm/realm-rsi.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index ab557f84..eed77d3a 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -33,6 +33,7 @@ tests = $(TEST_DIR)/timer.flat
 tests += $(TEST_DIR)/micro-bench.flat
 tests += $(TEST_DIR)/cache.flat
 tests += $(TEST_DIR)/debug.flat
+tests += $(TEST_DIR)/realm-rsi.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/realm-rsi.c b/arm/realm-rsi.c
new file mode 100644
index 00000000..d793f305
--- /dev/null
+++ b/arm/realm-rsi.c
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/psci.h>
+#include <alloc_page.h>
+#include <asm/rsi.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+
+static void rsi_test_version(void)
+{
+	int version;
+
+	report_prefix_push("version");
+
+	version = rsi_get_version();
+	if (version < 0) {
+		report(false, "SMC_RSI_ABI_VERSION failed (%d)", version);
+		return;
+	}
+
+	report(version == RSI_ABI_VERSION, "RSI ABI version %u.%u (expected: %u.%u)",
+	       RSI_ABI_VERSION_GET_MAJOR(version),
+	       RSI_ABI_VERSION_GET_MINOR(version),
+	       RSI_ABI_VERSION_GET_MAJOR(RSI_ABI_VERSION),
+	       RSI_ABI_VERSION_GET_MINOR(RSI_ABI_VERSION));
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("rsi");
+
+	if (!is_realm()) {
+		report_skip("Not a realm, skipping tests");
+		goto exit;
+	}
+
+	rsi_test_version();
+exit:
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b558..ce1b5ad9 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -275,3 +275,10 @@ file = debug.flat
 arch = arm64
 extra_params = -append 'ss-migration'
 groups = debug migration
+
+# Realm RSI ABI test
+[realm-rsi]
+file = realm-rsi.flat
+groups = nodefault realms
+accel = kvm
+arch = arm64
-- 
2.17.1

