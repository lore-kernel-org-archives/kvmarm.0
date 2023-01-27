Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2083.outbound.protection.outlook.com [40.107.22.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2B628EF;
	Fri, 27 Jan 2023 11:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5Ov8UacraSFcK4tBbryQ4GhcjU0UFGydGtdRDc/yk8=;
 b=H1mbAO0JWyIuRp45Odg3qfVfwOnblw/CCrAC+s3Ds+QRtOUN2BERE0aBVozwV1qxwpSIyy7mSd4lRQM0yngu2LmN9RmJRmtYW38kIjL04Myy/HlUDFOwy4HgQ/opcuu+nb3wDVnUMUXL6fnSieeSRXaBvLS8SC5mOiIFEpMTPIM=
Received: from DU2PR04CA0316.eurprd04.prod.outlook.com (2603:10a6:10:2b5::21)
 by AS8PR08MB6214.eurprd08.prod.outlook.com (2603:10a6:20b:29f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:41 +0000
Received: from DBAEUR03FT004.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:2b5:cafe::2f) by DU2PR04CA0316.outlook.office365.com
 (2603:10a6:10:2b5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT004.mail.protection.outlook.com (100.127.142.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:41 +0000
Received: ("Tessian outbound 6e565e48ed4a:v132"); Fri, 27 Jan 2023 11:42:41 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 777ec3250e38b21b
X-CR-MTA-TID: 64aa7808
Received: from df16ff2c3f36.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 525DFB33-F18D-4234-B437-F18678B6C84F.1;
	Fri, 27 Jan 2023 11:42:34 +0000
Received: from EUR02-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id df16ff2c3f36.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uo5lSDVOx3t7Y8y8msRL73p01q83AHzaBILaGaO51ydjjhWvC/vD2KxUaTxL304UzM98kgG8FjatzoBuzZCyG17ZlidG3a3+Djq9n4Y7w+LNzTHF3vE43RNn0OhELZiUopnOLD74kpHmV4DYOIwb32u/G2rEfhFd9/u9pN+u3lH+NQhExn5rX235otvNUh4K0qpVdlsfWOnudLOa9LF0lr1Z3vrzHIn68uPTbFKAglC7hZKVCvimJTSN/0lQ0fYqstVhf1enJ5Ab5fRrqZer/ClQOjZLLQ6e718SNga7Uc2fs1gQV3fVJ/II7gJDDUJlLhbTF24kKplNfD8+m7yoKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5Ov8UacraSFcK4tBbryQ4GhcjU0UFGydGtdRDc/yk8=;
 b=BOJ/SjvJLzoNmhokB2jIHzhBXHnP5Tqo2H0LaAjkCzcTVOMnSWTzDVP/yOOZCyFjQ+tXxurNgXfg0Kl2q/kzkO5CfiYKYI8OS+Gx/yL8JHm5H4XDu8oDhzwv9e/CYvBiF7kmcgoHYrZ4p+/+hyHD36xUGBNFr5sU6uCdDJS60d9NORpGOaEls6U1sxiAmZf3HiBFokin9fmpH8dgt99mN9ive1ehPBu/Zx2vyGCzo/M/BEfc/eitUCN9xFBwLXm6HGWnZzdLqeCKxJ6RnLeQUBH/ZIZiQWNItcHmtQuQDHrkhzVtbx8tbm3JAUTFlBeIG/88i2oA+9p8QL0y52kJGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5Ov8UacraSFcK4tBbryQ4GhcjU0UFGydGtdRDc/yk8=;
 b=H1mbAO0JWyIuRp45Odg3qfVfwOnblw/CCrAC+s3Ds+QRtOUN2BERE0aBVozwV1qxwpSIyy7mSd4lRQM0yngu2LmN9RmJRmtYW38kIjL04Myy/HlUDFOwy4HgQ/opcuu+nb3wDVnUMUXL6fnSieeSRXaBvLS8SC5mOiIFEpMTPIM=
Received: from AS8P189CA0016.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::7)
 by DU0PR08MB7567.eurprd08.prod.outlook.com (2603:10a6:10:317::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:42:30 +0000
Received: from AM7EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:31f:cafe::ab) by AS8P189CA0016.outlook.office365.com
 (2603:10a6:20b:31f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT056.mail.protection.outlook.com (100.127.140.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:30 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:29 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:24 +0000
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
Subject: [RFC kvm-unit-tests 13/27] arm: selftest: realm: skip pabt test when running in a realm
Date: Fri, 27 Jan 2023 11:40:54 +0000
Message-ID: <20230127114108.10025-14-joey.gouly@arm.com>
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
	AM7EUR03FT056:EE_|DU0PR08MB7567:EE_|DBAEUR03FT004:EE_|AS8PR08MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c2bbc97-77cf-42cf-a8f7-08db005b994d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 GM+2rLl8SvWoCrMdjKGsxxMJjukxumKihhfsqUwk2q/dogQIvCbwcId3KUu92gsTFnipgdSAG2Gr6u6moEcm1PzPShkshQUjeV1aDak0AfBHUDOVOgROWpKGd9NzunRTWai9Ayqk9ya6qABdtnjMIxfvLF3lSlbMkIf20cSVfMArM5+/BhRvQSfcCsodcxVuieNDAkWQGcoCwoN7q8CsyEbFq8OvLlcFQi4618CD6si/llK0Evq9OhgsbsPjXOQwHZrhUsN9AxRIUMsZWwjd7ZaDPo0g9ppDESHcHi+IBPeukjvNScPfcQ1zROSJY8le1FZuhlBmGzl8P2qcssy7MHelBBD1w76p8i7XjWPhf83dsheRpWFeWmA9iXRq3wS5dxEpHoMDTExYyYvmiwEfmwAXffqEO0utPRnDEyYvZGJM+eKBbW5DkmQwNroWbRcM1f9PWBdGhfRXKgobc98qrBPcr0ZVl7PDjzP1ggf31qiol45RnZua8+47chk2rKgLcStgTPEKuiSqwo4dcag9wKNBDlsVfa0R9unD2KGpzQrOGwSsWiMSpQXbPsE8ak8WuSe/gnvXZUcVfrzRC1x1LCcNEt2t9LTI6DNgj4KRrKIKEhhz3e+S3Kh9KkLfcBVBbgXEI7maMvnel2oFGcC3t8xUtbkTfSEiG5sqWgTNpZNSh10htU0r6EmNZUoohNqDfebb30P4kor05r0TuKOm3DJTuvemodMAWJakULA//Y50n6eHQjcl/9d6t0gfu87V
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(186003)(8936002)(4326008)(70586007)(5660300002)(70206006)(8676002)(2616005)(316002)(81166007)(426003)(40480700001)(41300700001)(110136005)(36860700001)(7696005)(1076003)(6666004)(356005)(2906002)(82310400005)(44832011)(4744005)(40460700003)(82740400003)(36756003)(7416002)(47076005)(478600001)(336012)(86362001)(54906003)(26005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7567
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	34a0317f-0b2c-4df5-e67e-08db005b9290
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZT2djVOQQIFIf2iZJsJ6WbRAYkVVuwu2zMg4TiDKZYdSbZysqPEttUIqzjkfmpzj+Ezvikg7SUWfa9q42FwoCLpgzDpbK/CtRiZCkgQR/zePJLn0kzcZkIFPu9dWqws186H/2Gw1Bp3V7UCqBzX4RUzurVQePX739xZwUoosv54yCykwkIbNNs5csjfpo5Jz3iHG9F8WTjJkFyo6p/mfgYMdsVt52rf7yTUAl4jdRLRgzaX41MCJI8cgCUpQRRtigQm7+XY+VJcPFu+VC0WoqgZbDcYkrFz2YWjUO05gHAf+UQGRPjifgjqjlF0bFTV744rXGSKf4Fqu1ijxi3PI/JYlxQ+FboPBTEOdb2pusyvti/NQMpShxPFnn06OcIdcpi1Mw0EumZ9B3DPwKJDT2KdRNbxlELDwbQ9dSL3x5pUfEmf6acEslCw68BQ84gk2A9/CUr2EOq4r/L5WEkHFNenPz/TYgDK9EWcZoxWXThXnjQP0opVd76ulH+Ud57v8DOTm197TMe3izeVrc/0fqCKQ1834qsD0eh4DZwKqg4mgJzAngb0xYkyvXrnbvOAI+BNpfNlgh9UGMHRfyfZKNQh6cKPERq3pT3mlQVskTokpIugE5S1xq1dHowpsevBRwP+oePo6GQJhCjc0krTk09wrywmdbdKIMl80o+OWZYTBs7APhUbimHiD9I4mx6VQHHtq2g1HH2sXXS6eghcJkwB6WXfFGWxjo2Zqn4TiFEg=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199018)(36840700001)(46966006)(40470700004)(47076005)(2616005)(426003)(4744005)(44832011)(5660300002)(2906002)(36756003)(6666004)(86362001)(7696005)(26005)(40460700003)(186003)(70206006)(70586007)(1076003)(107886003)(478600001)(82740400003)(81166007)(336012)(40480700001)(316002)(54906003)(110136005)(8676002)(82310400005)(8936002)(36860700001)(41300700001)(450100002)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:41.6303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2bbc97-77cf-42cf-a8f7-08db005b994d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6214

From: Alexandru Elisei <alexandru.elisei@arm.com>

The realm manager treats instruction aborts as fatal errors, skip this
test.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/selftest.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index 6f825add..174f2ebc 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -18,6 +18,7 @@
 #include <asm/smp.h>
 #include <asm/mmu.h>
 #include <asm/barrier.h>
+#include <asm/rsi.h>
 
 static cpumask_t ready, valid;
 
@@ -392,11 +393,17 @@ static void check_vectors(void *arg __unused)
 					  user_psci_system_off);
 #endif
 	} else {
+		if (is_realm()) {
+			report_skip("pabt test not supported in a realm");
+			goto out;
+		}
+
 		if (!check_pabt_init())
 			report_skip("Couldn't guess an invalid physical address");
 		else
 			report(check_pabt(), "pabt");
 	}
+out:
 	exit(report_summary());
 }
 
-- 
2.17.1

