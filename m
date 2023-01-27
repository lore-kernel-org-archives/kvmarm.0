Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2065.outbound.protection.outlook.com [40.107.105.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E2D28F0;
	Fri, 27 Jan 2023 11:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3PXBb4SSqTJtAHYbgMwbsFsilPhoJvLJat1+V5pGRk=;
 b=teCllaDYprHB57RNGMDs+MbVsedMgn2+Yw86C637bEdiObkB8PsfAWv+Y+XxPOLH4msvA/gJwPUq702toOWO1xcIZHPnX9Ep2ySWBmFkoYHHikDbtkO0/YgX+9ofJQmHikee+DPXXkc5JdrxMfzk4bxDsYUMbuR6KPzBJaU1dms=
Received: from AM5PR0601CA0069.eurprd06.prod.outlook.com (2603:10a6:206::34)
 by AS2PR08MB9894.eurprd08.prod.outlook.com (2603:10a6:20b:5fc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:13 +0000
Received: from AM7EUR03FT020.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:0:cafe::24) by AM5PR0601CA0069.outlook.office365.com
 (2603:10a6:206::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT020.mail.protection.outlook.com (100.127.140.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:13 +0000
Received: ("Tessian outbound 0d7b2ab0f13d:v132"); Fri, 27 Jan 2023 11:42:13 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f10d6ff2762418f7
X-CR-MTA-TID: 64aa7808
Received: from 4942fa1c6f02.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 92B6480C-80AA-44BC-AC6F-3CA257DF5AB0.1;
	Fri, 27 Jan 2023 11:42:05 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4942fa1c6f02.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwOjveYkIk9iEBPUHRkXVu+3flM8sABzyumrJwn/UEhm2fy4ZgCY73hZMdbaGXA3vukJc112WnmJE/xb6iauiOgAdfDlE0J02SVSEc8jhJZtm+trwsBVIL6FWSXAojCnxaBbqoom2ZyeBc3TI3Ww1rd2ipknyBVRt2QifTNDKGAf1f1RU0A1y7jB87swNw1aiSpwKbYbciGXOKLErKahBGUkgVnt/kVmegW0zY3hJ+hwLfpJdbbHNnXQIXaeCIhi/vPEqS0vLoL/JafN920WoG6Qwl+XVWaDWiBmRWHUpNU3NxGAf9KfgNycr0w+9gQKvAND32W5g4rbsoPiE8rSfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3PXBb4SSqTJtAHYbgMwbsFsilPhoJvLJat1+V5pGRk=;
 b=WoTXprq/EWjq4tC+imzQgrFrp01cxfjYqESgLllb8yeOE3Tr1Tc1Qc2k/l/dUtvWeBS9A/x/ZreI88uGJKQ3z2Upml/voSOmjgGQdLByUFQ8WGjewqUOq5h8YvW7cKU6x216JqE1USezmvnUjsyV07red16I60MAZi+nyJ2ZjHdoJUvAu1hCAmZ//M0ts9lFuXsOIlfSmLpiwZxtqDQ94HeiJCdAjQLYfppxZQIuWH0pudLwU5zg//nTKBXC8l3j4xkBRnen1HjtOvVX8JCJWbzTKsG5SOKOYvqh6zcCu9u1DsN6zmWOtuvPlplb5MmOL3hMMYvBjNsuG2WkXsoqrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3PXBb4SSqTJtAHYbgMwbsFsilPhoJvLJat1+V5pGRk=;
 b=teCllaDYprHB57RNGMDs+MbVsedMgn2+Yw86C637bEdiObkB8PsfAWv+Y+XxPOLH4msvA/gJwPUq702toOWO1xcIZHPnX9Ep2ySWBmFkoYHHikDbtkO0/YgX+9ofJQmHikee+DPXXkc5JdrxMfzk4bxDsYUMbuR6KPzBJaU1dms=
Received: from AM5PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:206:1::23)
 by VE1PR08MB5583.eurprd08.prod.outlook.com (2603:10a6:800:1ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:42:03 +0000
Received: from AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:1:cafe::45) by AM5PR04CA0010.outlook.office365.com
 (2603:10a6:206:1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT005.mail.protection.outlook.com (100.127.140.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.25 via Frontend Transport; Fri, 27 Jan 2023 11:42:02 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:01 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:55 +0000
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
Subject: [RFC kvm-unit-tests 08/27] arm: realm: Realm initialisation
Date: Fri, 27 Jan 2023 11:40:49 +0000
Message-ID: <20230127114108.10025-9-joey.gouly@arm.com>
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
	AM7EUR03FT005:EE_|VE1PR08MB5583:EE_|AM7EUR03FT020:EE_|AS2PR08MB9894:EE_
X-MS-Office365-Filtering-Correlation-Id: e0977e95-b5e7-4c57-2743-08db005b8875
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 l1n7+XZjSyqfW/XOP8i0HXiuC0odLH+5j+ZTSyT9gGkaRekbTisuAFI2rf+E9S3uoxHXu39O2eDwNo/s9tyKbU3QlifTtTLRkOOUmGdDFG/SU/I/4sbm97AbqXWavs1s8WqOWEvo8FNEEM0FeYk7f5QjYjgjprHnS+WPIIhwfRaFx08Sxw16xGBSk3fowbrAF559a6tqdnsLVHkpXY9ylLFzm/XUc/7l5Xe1+gw8HFwK3t0hXpFnPokRwRKYZ6zaOkYH+Ip/BulhaizmSR6qDVJ+l4RVT08QsjR2DRS62T1eQ3KokqmYtQZ5hYOlDnXQIQ0/p02Zh4L5yrR+t0UtyUGvjHgWiGKyeKgOR+E95dmlxWLGeHIJvBIkIdGEVhGoGVW3L2koi/Cgb3FNgFLU8nGRVV6gFU5SE6n7M7zGxyytYYDEUvAdMzas/yezCLpXRaXoFLtj5HAl/ag1qKGr2oBg8zFSZuS470yPT320w1dyFZ71T9uGErO4dn2xHlkvZh6GzL1jTnPgSpriQ4wNRPrflbuFj/nWbJ8PFVWpZtF3suCj70j7OIcKKUlQhhNslcXd+07oBNQh7LvdbzAX+2f8wqWiG/ZODejxg9hz4UPHIVj1RaW6mafvBe206lnAAR8RPPmfv47gnCvtMn2XIzUgVcabcaV3v5jDPRXbVVw3rUcvXkxSLeR2iN6DcFUpUsdpI82wUYCCj+298bv5OyQ0wyWbmeNmCe93ySfTXkR7fVOMQ0ahsG1b2lO2eRWG
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(81166007)(8676002)(36756003)(86362001)(82740400003)(40480700001)(44832011)(2906002)(426003)(4326008)(1076003)(6666004)(7416002)(40460700003)(83380400001)(186003)(41300700001)(26005)(8936002)(5660300002)(478600001)(336012)(70586007)(54906003)(316002)(82310400005)(70206006)(356005)(47076005)(36860700001)(2616005)(110136005)(7696005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5583
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	246d5100-1af4-47aa-93e9-08db005b8239
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OV19SIo4wmd7JptEQ2eoqNDmaVDkA8rnO3j1/C2nBbIx/PZy6H/mAIrVc/z0ELYihXDX4DyDkNliuCm+PzJ7N1Uxo1PkYrnpw3rlSXMcLOe4oF28S2RSwbklWfMD3+1PbXmPX3+LSwkid5AOCi2lvDVa50h/IwmVOj5qOt+0fMlLLU9nFhp9Apzp0yxV6IWi1BYWMHORfo5xVbTWvmLMoo3DuzfuDOrSG6xyBO+QtfMy+e8D5zJF64ttFPgHS/o0CfM6dBt8Y3ImPfS/Hy2fqzYBvxAQ6kWN2vk4dKn945bO2OH9HLc5o7/wRUKFa3aKTnAh3bcYCle7kjRTSq1gUUOf+vYwzsT8yaeQk5TxK/DKUmJRe1H3c+t7m1/8RlrfaNRrhUGJXqSivTen8rDZBXrHv5cdPX1yyydQ9LmxF1/2Hwfj89u9Df1aGR3G3BzaffOekOK3kFCy7KtUziVnjr/erkvRPkAItkgyr52hw4667y8HEGN5OpF6vDqzv7DTgoLlyydOrSVtyRYsvfgPQpomikqp0FUw7flFud5btslRkMJaO6ysfChgwdI/LkRYFWyM1Qz7oUHW45W8j9F0G8tNSie3SZraGLbup1E5Hql6SqACZ8w8+NVVCorN+8+W1Z6YYsGMG4lJv4XR4XMCnBp0bFQ3x7f2+D7eD5opcIaZCboryozFAQ2aFw7nHarBsKPMXmdPXaQC3r01xenrszJyktxNPK0njIFpFjKwPJE=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199018)(40470700004)(46966006)(36840700001)(2906002)(44832011)(36860700001)(336012)(426003)(5660300002)(8936002)(41300700001)(4326008)(478600001)(1076003)(450100002)(26005)(186003)(8676002)(6666004)(107886003)(2616005)(40480700001)(81166007)(82740400003)(83380400001)(47076005)(86362001)(40460700003)(70586007)(70206006)(7696005)(316002)(54906003)(110136005)(82310400005)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:13.3522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0977e95-b5e7-4c57-2743-08db005b8875
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9894

During the boot, run a check for the presence of RMM. If we are Realm,
detect the Realm configuration using RSI and initialise the key parameters.

Also expose a helper to indicate if this is running inside a Realm

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64        |  1 +
 lib/arm/asm/rsi.h         | 16 ++++++++++
 lib/arm/setup.c           |  3 ++
 lib/arm64/asm/processor.h |  8 +++++
 lib/arm64/asm/rsi.h       | 36 +++++++++++++++++++++
 lib/arm64/rsi.c           | 67 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 131 insertions(+)
 create mode 100644 lib/arm/asm/rsi.h
 create mode 100644 lib/arm64/asm/rsi.h
 create mode 100644 lib/arm64/rsi.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 42e18e77..ab557f84 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -24,6 +24,7 @@ cstart.o = $(TEST_DIR)/cstart64.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
+cflatobjs += lib/arm64/rsi.o
 
 OBJDIRS += lib/arm64
 
diff --git a/lib/arm/asm/rsi.h b/lib/arm/asm/rsi.h
new file mode 100644
index 00000000..d1f72c25
--- /dev/null
+++ b/lib/arm/asm/rsi.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __ASMARM_RSI_H_
+#define __ASMARM_RSI_H_
+
+#include <stdbool.h>
+
+static inline bool is_realm(void)
+{
+	return false;
+}
+
+#endif /* __ASMARM_RSI_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 65d98e97..36d4d826 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -24,6 +24,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
+#include <asm/rsi.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 #include <asm/psci.h>
@@ -244,6 +245,8 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	u32 fdt_size;
 	int ret;
 
+	arm_rsi_init();
+
 	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
 	freemem = (void *)(unsigned long)freemem_start;
 
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1c73ba32..320ebaef 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -114,6 +114,14 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
 
+static inline unsigned long get_id_aa64pfr0_el1(void)
+{
+	return read_sysreg(id_aa64pfr0_el1);
+}
+
+#define ID_AA64PFR0_EL1_EL3	(0xf << 12)
+#define ID_AA64PFR0_EL1_EL3_NI	(0x0 << 12)
+
 static inline bool system_supports_granule(size_t granule)
 {
 	u32 shift;
diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
new file mode 100644
index 00000000..8b9b91b2
--- /dev/null
+++ b/lib/arm64/asm/rsi.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __ASMARM64_RSI_H_
+#define __ASMARM64_RSI_H_
+
+#include <stdbool.h>
+
+#include <asm/arm-smccc.h>
+#include <asm/io.h>
+#include <asm/smc-rsi.h>
+
+#define RSI_GRANULE_SIZE	SZ_4K
+
+extern bool rsi_present;
+
+void arm_rsi_init(void);
+
+int rsi_invoke(unsigned int function_id, unsigned long arg0,
+	       unsigned long arg1, unsigned long arg2,
+	       unsigned long arg3, unsigned long arg4,
+	       unsigned long arg5, unsigned long arg6,
+	       unsigned long arg7, unsigned long arg8,
+	       unsigned long arg9, unsigned long arg10,
+	       struct smccc_result *result);
+
+int rsi_get_version(void);
+
+static inline bool is_realm(void)
+{
+	return rsi_present;
+}
+
+#endif /* __ASMARM64_RSI_H_ */
diff --git a/lib/arm64/rsi.c b/lib/arm64/rsi.c
new file mode 100644
index 00000000..23a4e963
--- /dev/null
+++ b/lib/arm64/rsi.c
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#include <libcflat.h>
+
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/rsi.h>
+
+bool rsi_present;
+
+int rsi_invoke(unsigned int function_id, unsigned long arg0,
+	       unsigned long arg1, unsigned long arg2,
+	       unsigned long arg3, unsigned long arg4,
+	       unsigned long arg5, unsigned long arg6,
+	       unsigned long arg7, unsigned long arg8,
+	       unsigned long arg9, unsigned long arg10,
+	       struct smccc_result *result)
+{
+	return arm_smccc_smc(function_id, arg0, arg1, arg2, arg3, arg4, arg5,
+			     arg6, arg7, arg8, arg9, arg10, result);
+}
+
+struct rsi_realm_config __attribute__((aligned(RSI_GRANULE_SIZE))) config;
+
+static unsigned long rsi_get_realm_config(struct rsi_realm_config *cfg)
+{
+	struct smccc_result res;
+
+	rsi_invoke(SMC_RSI_REALM_CONFIG, __virt_to_phys((unsigned long)cfg),
+		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	return res.r0;
+}
+
+int rsi_get_version(void)
+{
+	struct smccc_result res = {};
+	int ret;
+
+	if ((get_id_aa64pfr0_el1() & ID_AA64PFR0_EL1_EL3) == ID_AA64PFR0_EL1_EL3_NI)
+		return -1;
+
+	ret = rsi_invoke(SMC_RSI_ABI_VERSION, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		         &res);
+	if (ret)
+		return ret;
+
+	return res.r0;
+}
+
+void arm_rsi_init(void)
+{
+	if (rsi_get_version() != RSI_ABI_VERSION)
+		return;
+
+	if (rsi_get_realm_config(&config))
+		return;
+
+	rsi_present = true;
+
+	phys_mask_shift = (config.ipa_width - 1);
+	/* Set the upper bit of the IPA as the NS_SHARED pte attribute */
+	prot_ns_shared = (1UL << phys_mask_shift);
+}
-- 
2.17.1

