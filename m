Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED98928E8;
	Fri, 27 Jan 2023 11:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8sHXFvJ6444qJbO+o+cXMiU4CBVfbUwsWai7SxWeag=;
 b=e2/XbBfwNMmUC+Gvs3Wymu04s11GLUMlFwKiOOj+FVgYOrxAOc4oPahAtcQZyXyrwz66h1VM19w5PB4IY5GR9hcUKwiNVjneldF+I/quaF+Wvp0e+A8frRNpELBIeKkfFX/tkyKuSjn27NrZfV/vMoIZ0ucA4Q3gdAfbbP858rw=
Received: from DUZPR01CA0161.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::18) by DU0PR08MB9156.eurprd08.prod.outlook.com
 (2603:10a6:10:417::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:49 +0000
Received: from DBAEUR03FT045.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4bd:cafe::b) by DUZPR01CA0161.outlook.office365.com
 (2603:10a6:10:4bd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.35 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT045.mail.protection.outlook.com (100.127.142.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:41:49 +0000
Received: ("Tessian outbound b1d3ffe56e73:v132"); Fri, 27 Jan 2023 11:41:49 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5a31f9a9640e9a99
X-CR-MTA-TID: 64aa7808
Received: from e0b838b7eec7.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id D13009A3-622D-449A-8551-F371553DB98C.1;
	Fri, 27 Jan 2023 11:41:43 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e0b838b7eec7.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjvLzw4zXix/ilBq/8OWJaaTOJO7yDqbyWC0mE9TbIh4A9sapAQ3gTbGKjPOn8ZrhuWZjRR7+rj5SjDCUa1Ij+MMNWCZS77KnY6kgAGGqbitqrAW3JCpubkMIwRrtrHFlPbtd7IReb3v0C6OaZ0h3enY0QM8M0Xi0/uOruFE9vhdw1aWoxUbSCty4H6BZn+U05hH2qmJjz0YS6BW4yxO2CsLFExWgDjElx73a+7v3S8nWnCaMSGOZlYDj1WBtQNpkiGDE1hktqQOuaBweRhfGkxl78cd5vnj0uq+FLCmkWTDhSYPSWolxumZq393Uvt51Fh1Z3Hq4mIfg8WPfka9qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8sHXFvJ6444qJbO+o+cXMiU4CBVfbUwsWai7SxWeag=;
 b=SCIM5fz38RRTNTo6ZMTieMSqAFm2fBqQCKoNo9JtpGcV3T7k3YtWfMYr+mkoA9IOI5A3aqMGbuRnGLjtThpAlTnR/WIM2vGV41xow7TpPFQFVKqpueP1HOWG7NrquAAjaM1nL4k5kMog7njTfSYc+8WzburuLKXOKWOi7iBJNR7ITHfkdiSCD/Op41C85B714C6yMvZ2LUWtjGxzM13d7r0jyY5oLPxkqV+vKlodlRkoE9pKTlj3eh66n/NMhSergh5jZfPebBxJMjBupXTjcFounTomCu5bd355F9gQJ1Gvp4PIij6q4lkJ3TVMT9T/i36Nu4/VP1muoUoU63gRDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8sHXFvJ6444qJbO+o+cXMiU4CBVfbUwsWai7SxWeag=;
 b=e2/XbBfwNMmUC+Gvs3Wymu04s11GLUMlFwKiOOj+FVgYOrxAOc4oPahAtcQZyXyrwz66h1VM19w5PB4IY5GR9hcUKwiNVjneldF+I/quaF+Wvp0e+A8frRNpELBIeKkfFX/tkyKuSjn27NrZfV/vMoIZ0ucA4Q3gdAfbbP858rw=
Received: from AS8P251CA0019.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::22)
 by PAWPR08MB10240.eurprd08.prod.outlook.com (2603:10a6:102:366::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:41:40 +0000
Received: from AM7EUR03FT040.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2f2:cafe::fa) by AS8P251CA0019.outlook.office365.com
 (2603:10a6:20b:2f2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT040.mail.protection.outlook.com (100.127.140.128) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:41:39 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:38 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:33 +0000
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
Subject: [RFC kvm-unit-tests 04/27] arm: Make physical address mask dynamic
Date: Fri, 27 Jan 2023 11:40:45 +0000
Message-ID: <20230127114108.10025-5-joey.gouly@arm.com>
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
	AM7EUR03FT040:EE_|PAWPR08MB10240:EE_|DBAEUR03FT045:EE_|DU0PR08MB9156:EE_
X-MS-Office365-Filtering-Correlation-Id: bc48fc46-dc52-4a1b-88c6-08db005b7a69
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 NcAY6Ey9UNYkbzeWzIE9gX9s1ZThcug6XtKJ7XfSFzseZChi/OGbtRq2tFle65O1/3evqnnN43m3cX+2h5aXjdpZSZ1IOdOYRmqAYrgQbBCgUXc5wjbm8Dhlng2+NQQseedy5aozC/hWE+QD70AC4nVM3/FGsr8TUPfR+UWeZTMCcHPYgVIQ5vrW/+DAJupUNXnmpJN/+6TlRIGU7hHxf//ymKeOOBeVPDjZxO0RCuUou0FFMOFprMnlTJQGBLgQHHaP69JBFcDNvdEpSHEyj+grkGCN8iLLyN8XEmrwJBV2X51Y43Vk1iIkGtO0Jcgu9pu/o6c7q5zlst1Jr27W3iBTUYW1qayLOSOi3m4hvcGaEpSxqbNXLN8ErgzNSMd4ao7u96Gmp1oJUHuW4rzy3pjdEqa+0Z4ae6s5SJv2UMEYKhPgNyrK1lRIpE5UCFVEdpEi30wdKVx+MJXshf7CndXyNfcmRDrwfIgK4OClzVK2QgZG1LYvVR6y0cu/Qip8l7gyuzZL1Ru4SFBRlp9gQwy9mY/qIN4pcsyQ0Yt9l41pfOaUks9N3BwP5iVJcAxaBQDGhkyCqXa10InpzKOy7eV90SgZzUByezuEToJdkScG/GFczUMM8cPMb0rnTI3orNBzYoAdZcZVGlADO363bOoRL2zNLQ95m3SFnrvFZxX2bvQ8qOcoAHiA9TOQRIehTkh1Sz9uKvbjc9tYmXLXG2qbQIuEIrMRKWXF7t9Bxz0uFL7y4GPc6xbO27RA47gO
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(336012)(82740400003)(110136005)(426003)(26005)(8936002)(478600001)(7696005)(86362001)(41300700001)(356005)(7416002)(36756003)(2616005)(40480700001)(81166007)(82310400005)(44832011)(4326008)(40460700003)(1076003)(186003)(54906003)(70206006)(5660300002)(316002)(8676002)(6666004)(47076005)(2906002)(70586007)(83380400001)(36860700001)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10240
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT045.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c5e6b6b8-f472-4473-700f-08db005b742d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WByjGQ5XhPnGbQEo9VkKSTzZvBNn+jdfaPsnXwDCQXgvMEVCVmidIOXDEA/6+uzim9XwPqly+nenmsowOLsLuTTjQAeBbTMLWK+jBgw/taPg+Nu5w197OM2au8cQKIHYjOsgiV60jL8votUDiJ7Qwe9N53QwFVy+nNhrNg/3G/smRYCR2ZfY5tuM2Jy0SlJ5HPfVZw7GPB3JcEms5gJJ+cyKtIJT05CFCOa5o6GmEriaDqFrEwuf5LFyDawJAgtIcYK7NESC0K5V3d2j52mqJxOCGH6hG7EU2ulZStD/uYc7FeSD1NRsJW7JWfUGHaslfvuGOr6N69LZQOlfBykHv+qn11ICwDN9XJe3KMVPVjVSc4kdmAzYVZSOe8pujtrMZ8PWaYdkhXgbXsHMNt1DABRewtOJjkCxy99xWJ8+0Yq692YsnnSbwN8HPNyrG90d8ZWmSi7cODOSBQWwBqF25mlxMrhuO6k7zBtWXz0iyobWeagYD5UjOowg8YaA99uYUeFok79S2cEB4Dj2p/d1+EoUthpqwF7BbaVoPB2TrTJCWU10bEhRXSpd1zsuvxIojyVDSBPtMc/dyVEpGjBnogr8aWZ/3QmvwlqH+YEOEpLLL1KifouYR8jITTT7whX1OhD5ih1Psu6SHtbUrT4EzeON4nuEf2DBsYVDGXA5fu1HXECwbEgQRUZooFqr0L5dFOW8SDQ6fILiKtvkIVZQpejDvlLesQIzb14EWLGPZ3k=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(41300700001)(70206006)(26005)(186003)(70586007)(8936002)(8676002)(450100002)(83380400001)(5660300002)(6666004)(44832011)(107886003)(1076003)(81166007)(478600001)(36756003)(2616005)(36860700001)(47076005)(426003)(54906003)(110136005)(7696005)(86362001)(336012)(82310400005)(40480700001)(4326008)(40460700003)(2906002)(316002)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:41:49.8349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc48fc46-dc52-4a1b-88c6-08db005b7a69
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT045.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9156

We are about to add Realm support where the physical address width may be known
via RSI. Make the Physical Address mask dynamic, so that it can be adjusted
to the limit for the realm. This will be required for making pages shared, as
we introduce the "sharing" attribute as the top bit of the IPA.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/mmu.c                 | 2 ++
 lib/arm/setup.c               | 1 +
 lib/arm64/asm/pgtable-hwdef.h | 6 ------
 lib/arm64/asm/pgtable.h       | 9 +++++++++
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index e1a72fe4..acaf5614 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -22,6 +22,8 @@
 
 pgd_t *mmu_idmap;
 
+unsigned long phys_mask_shift = 48;
+
 /* CPU 0 starts with disabled MMU */
 static cpumask_t mmu_enabled_cpumask;
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index bcdf0d78..81052a3d 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -22,6 +22,7 @@
 #include <asm/thread_info.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 8c41fe12..ac95550b 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -115,12 +115,6 @@
 #define PTE_ATTRINDX(t)		(_AT(pteval_t, (t)) << 2)
 #define PTE_ATTRINDX_MASK	(_AT(pteval_t, 7) << 2)
 
-/*
- * Highest possible physical address supported.
- */
-#define PHYS_MASK_SHIFT		(48)
-#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
-
 /*
  * TCR flags.
  */
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index bfb8a993..22ce64f0 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -21,6 +21,15 @@
 
 #include <linux/compiler.h>
 
+extern unsigned long prot_ns_shared;
+/*
+ * Highest possible physical address supported.
+ */
+extern unsigned long phys_mask_shift;
+#define PHYS_MASK_SHIFT		(phys_mask_shift)
+#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+
+
 /*
  * We can convert va <=> pa page table addresses with simple casts
  * because we always allocate their pages with alloc_page(), and
-- 
2.17.1

