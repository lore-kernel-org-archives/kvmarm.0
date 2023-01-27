Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8CD28F0;
	Fri, 27 Jan 2023 11:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0EaVl7U6Q2PCuIAajE8wsA6jxr+3lwL//SWR9QcSOM=;
 b=cjqlq1rZtMcDMTUZRxAc5QNL9pXbuUDa4EYv0HCchCavocC6A3e4pSvvYBgChcG8krMY+ahIomgJ3rZr9xSPej5OfbB8uHduhYLN8X3NRxwVNCt9SV3p88tclvjm4hpCApjpBz9YsUm9sy0PhaNcdDj+L0ekJDNjuCronUqXv/A=
Received: from AM6P191CA0086.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::27)
 by DU0PR08MB9800.eurprd08.prod.outlook.com (2603:10a6:10:443::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:08 +0000
Received: from AM7EUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::5e) by AM6P191CA0086.outlook.office365.com
 (2603:10a6:209:8a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT047.mail.protection.outlook.com (100.127.140.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:42:08 +0000
Received: ("Tessian outbound 3ad958cd7492:v132"); Fri, 27 Jan 2023 11:42:07 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 996d8be9c24d118f
X-CR-MTA-TID: 64aa7808
Received: from f27dfe4e57cf.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id B2F886A4-2F3B-47B0-B71C-5A76E8E5CCC0.1;
	Fri, 27 Jan 2023 11:41:59 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f27dfe4e57cf.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsFuiyLcOAjXuAc2Gk9lDrhLA7vrGNstQ8hhVcGsHS5NytUHPimmr4U7JLyPMPlP3STmO1lldTtv1PzTQU1zRqeD/tgpzZMgqVAFJnEV0wAj6pYXqwP7KhCikG8bhjaRWNZXN2lOUefXV4wzt0FwiQnF1lAjqX/p2LxgPzSIilExnjY9YuY9cHN3JPe1YUUN76EhWaSod02+8CkwyVjq3texIZomXhJuWKHKMGleQfiUkDY5X467nc6hi6GfmvXs6Mruvemdy4+NkD0mGekvJcBwxlYK0K7jDGosVzN5HCyAgj24IT2L0xB/p/1V4iiFe0O1C1Ihm5JXCh2wgbUsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0EaVl7U6Q2PCuIAajE8wsA6jxr+3lwL//SWR9QcSOM=;
 b=Tww42ACJ+XL1uLPNsPRvV3uKtGgPwbZrwoBfqmWyGnm7+GvoQZUiCN8Z9ZfbJNc00hv442hCF0we2EZQBR0gorPQtb9Xn9I81hSu8ekEcnmp+d28REKOrdYIn8s8+vn2cFVebLD4HNND6PiCFL4cS2DSRYXl9Oi8tCDSTqbSuaiO4tG4SAciVmMUj6YeALWd0ev+b4jA13kOIAz9665avJScpHsmPNHX1iTxDgkz0HmXaid4FaOMl8yijeDJus7CItXZK/969hAD7sR857X2jUNenPK3+5DTgJpcvBe4DyO+zcYVAcnyaaYMqjroZUCSOAxUBde5sQi9PFOoCvOiqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0EaVl7U6Q2PCuIAajE8wsA6jxr+3lwL//SWR9QcSOM=;
 b=cjqlq1rZtMcDMTUZRxAc5QNL9pXbuUDa4EYv0HCchCavocC6A3e4pSvvYBgChcG8krMY+ahIomgJ3rZr9xSPej5OfbB8uHduhYLN8X3NRxwVNCt9SV3p88tclvjm4hpCApjpBz9YsUm9sy0PhaNcdDj+L0ekJDNjuCronUqXv/A=
Received: from AS9PR05CA0079.eurprd05.prod.outlook.com (2603:10a6:20b:499::19)
 by DU0PR08MB9797.eurprd08.prod.outlook.com (2603:10a6:10:446::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:56 +0000
Received: from AM7EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:499:cafe::cb) by AS9PR05CA0079.outlook.office365.com
 (2603:10a6:20b:499::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT011.mail.protection.outlook.com (100.127.140.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:41:56 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:55 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:50 +0000
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
Subject: [RFC kvm-unit-tests 07/27] arm: realm: Make uart available before MMU is enabled
Date: Fri, 27 Jan 2023 11:40:48 +0000
Message-ID: <20230127114108.10025-8-joey.gouly@arm.com>
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
	AM7EUR03FT011:EE_|DU0PR08MB9797:EE_|AM7EUR03FT047:EE_|DU0PR08MB9800:EE_
X-MS-Office365-Filtering-Correlation-Id: 772ce651-48a9-4eb7-3e9b-08db005b8556
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 Tvq4CII9rffgM6JmDFn9otSRzZulxa51tR8cXthwkUoTaT5Pkf/PylpIs8UfcsN4LC3NQ1YWmJeLBfNkpfZjc5xDw4593sXWPxrvDiONMpKqp44AqgIQw1HbKWIEURf8SZ8P/gnCPbjWAPDU4jsPa2SiD0g/rBVgAHxLaJyTk1w53AccUlvYrlWMwV7EctqdjXn4GrkuvCWxcg6lerPs0gqxcMWeqRjX+BR6UxpMG/yazshjzZYc3mnH82OJLt/DI8I4XL8147GqfIDOiDI6XEjeuyUvERoBO7htyc0lr9Ej9X7IeFUDFFBV0p5aqouLARjdqN7GaqDORurQJQC0zl9CRavHWCk+s27ur7MoTEaECnVWJdb5JPmJe1uEBsXo8IrXZXDEcRTqWt450zshd+eA1eJz8vhqQ0/iY97+QHjy8M4jZmhL+9cHsoMaTpR+7F80QWsAxw8V9ChsCl2JGZbUBg5iSCDDXh9VRrTj5wTY77dNQiPsWPMCO9br4Ofi/U6535SoYDqssN4BRdkF/U4R06vOfaazhn6fN4m5HXcjJG3GzsXZP72pi8qVWTYkt89xSMNke9X2dmz2SyRVQLJCo/OwoOjUdlGCl7JLqYQuoENCPDR4I2x6Jt0yKNAanlxjKAwoSu75C+Le980yRE3aXjmTvD1qFdn40owd0/9qjGlLougxxLylpwy/9ePjStmDwmJjmuxtDgYD2g4wlN8V5qVnCU8RBu/Oyb1nRGciSmnAUS+FTucfkJrYI74r
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(40470700004)(46966006)(36840700001)(70206006)(4326008)(70586007)(41300700001)(8676002)(83380400001)(54906003)(8936002)(316002)(5660300002)(82740400003)(110136005)(2906002)(81166007)(44832011)(36756003)(40460700003)(40480700001)(356005)(7416002)(36860700001)(47076005)(426003)(7696005)(336012)(478600001)(86362001)(1076003)(26005)(82310400005)(186003)(2616005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9797
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2ac69784-e906-45bb-db95-08db005b7e5d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wmzO8vRZTC99rAr9ZVUK6+fha4RGa6l/AguhX6zuZ8F9XlrOBWuPBNJzBKsEe1QEx3Ovb9eZzOZ2kLWDQ/Q4o2ZGAOfTO7gGKUIBh9ADiqk7WcQKY4rsuav5l+ADraOT8SVxBudpXSZrhTnfjpORCbQ1C7xDkiMbR6brF36ZD+0Rjpmoa4yVIbHpCLhHQxfsvqcf4p3sxHEjOGM0ZBBqg5MFnmT/xiig0NG44fwNndi+it+1KXWihWSbUwdaE9rJCxvcNOmibeLsJ37aFfztdfeL/JQ/7OP6ChYiHZi5I+bAeK6Th8prUBIfqS2eDGnzmxGUzRTfxgEWAUxA5AyfWoE7HThLxy50aXOt9t8N9krUyaiso7mtBOOQjDn7RYFLxOZ9NILrpQwJTQV1GPfijQ4n/0aqHLayKNx1NU5Ghw9FDVY9JA7W4Lewf4wBvKqjmc/Q0CuEjn/FxOVKhC1fp7R+2km7SVkxENfWOSy/o+1PcdBSUXK7Rh0/hi+R8QLbhqJ50q1FHzFmD2452XFXXiGy2SbogNbYogIWmRdPB0Uphla6F082PU2LgJmepMDXrKiv9tjcxsJSpEUyn+Vp5GSI+ByfiirvemIV8r3xIY7L6Drishf1TIxf19pmbuBcmZviFasifkoCIdlITioqSUdA36J5cqQQs7GJGuW/nbN7aA5At8eKddjZhPLcFxntHCnFabROMV+4fUx10BSHhNCQGdNG61c6d+aIhAJhaOE=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(86362001)(81166007)(40460700003)(36756003)(40480700001)(47076005)(7696005)(26005)(316002)(54906003)(110136005)(186003)(1076003)(336012)(2616005)(83380400001)(478600001)(426003)(107886003)(44832011)(2906002)(82740400003)(450100002)(4326008)(8676002)(70206006)(70586007)(8936002)(36860700001)(5660300002)(41300700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:08.1477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 772ce651-48a9-4eb7-3e9b-08db005b8556
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9800

A Realm must access any emulated I/O mappings with the PTE_NS_SHARED bit set.
This is modelled as a PTE attribute, but is actually part of the address.

So, when MMU is disabled, the "physical address" must reflect this bit set. We
access the UART early before the MMU is enabled. So, make sure the UART is
accessed always with the bit set.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/io.c            | 24 +++++++++++++++++++++++-
 lib/arm64/asm/pgtable.h |  5 +++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e1082..f7c6c771 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -15,6 +15,8 @@
 #include <asm/psci.h>
 #include <asm/spinlock.h>
 #include <asm/io.h>
+#include <asm/mmu-api.h>
+#include <asm/pgtable.h>
 
 #include "io.h"
 
@@ -29,6 +31,24 @@ static struct spinlock uart_lock;
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 
+static inline volatile u8 *get_uart_base(void)
+{
+	/*
+	 * The address of the UART base may be different
+	 * based on whether we are running with/without
+	 * MMU enabled.
+	 *
+	 * For realms, we must force to use the shared physical
+	 * alias with MMU disabled, to make sure the I/O can
+	 * be emulated.
+	 * When the MMU is turned ON, the mappings are created
+	 * appropriately.
+	 */
+	if (mmu_enabled())
+		return uart0_base;
+	return (u8 *)arm_shared_phys_alias((void *)uart0_base);
+}
+
 static void uart0_init(void)
 {
 	/*
@@ -81,9 +101,11 @@ void io_init(void)
 
 void puts(const char *s)
 {
+	volatile u8 *uart_base = get_uart_base();
+
 	spin_lock(&uart_lock);
 	while (*s)
-		writeb(*s++, uart0_base);
+		writeb(*s++, uart_base);
 	spin_unlock(&uart_lock);
 }
 
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 5b9f40b0..871c03e9 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -28,6 +28,11 @@ extern unsigned long prot_ns_shared;
 */
 #define PTE_NS_SHARED		(prot_ns_shared)
 
+static inline unsigned long arm_shared_phys_alias(void *addr)
+{
+	return ((unsigned long)addr | PTE_NS_SHARED);
+}
+
 /*
  * Highest possible physical address supported.
  */
-- 
2.17.1

