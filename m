Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2084.outbound.protection.outlook.com [40.107.13.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E08E28EF;
	Fri, 27 Jan 2023 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLaFr9PZgJyXyWlvzCfGtSQ5pj75jGDJirYDuCm7ASI=;
 b=dyuOUwHcjj+uJ/aaLGNjgVEKrEF+ygOPm9yazPHrNevEBS1W0ronX/i7r0eyJMgtFkSzOWo3Wvhe8SxyZV5TMbf4rvzXQv0U+dBVuS/xbjgLjJ3cft+W9LNDnOxjwnEtUB/szudXLJJNd8WPQyEsntmCNxnjHKQ7oSyBjudOEuc=
Received: from DU2PR04CA0073.eurprd04.prod.outlook.com (2603:10a6:10:232::18)
 by DB9PR08MB9636.eurprd08.prod.outlook.com (2603:10a6:10:45c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:43:46 +0000
Received: from DBAEUR03FT010.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:232:cafe::b1) by DU2PR04CA0073.outlook.office365.com
 (2603:10a6:10:232::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT010.mail.protection.outlook.com (100.127.142.78) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:43:46 +0000
Received: ("Tessian outbound b1d3ffe56e73:v132"); Fri, 27 Jan 2023 11:43:46 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d6f7ab49d9999772
X-CR-MTA-TID: 64aa7808
Received: from b2b793b33f45.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 0DCECF22-853B-4E1A-A060-004B8BF11125.1;
	Fri, 27 Jan 2023 11:43:39 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b2b793b33f45.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M78kBIdhCd7aEFQB88Y1HisZSh3zVHVxb1CRKWSMHqrIOHHPYq/4s8pbHXACCQCcfXxlGHQQfRssncR+f5N/h7qigCUJE1sVmkZ0uul4wGkZAA7sG3xHLXCXp3cvg1YBHdjECVlsKEH7vas5W4QHLplqscvr8uz3NR+tAT8X40hLwuHvb2sLzeUPqJ0YC/DQ6fwi4NfRBbPQ1jfKWsJnkSqKuP+1JqU9cml/2QVE7KGBBOtfCtAsjm3ZF5+s+FTWxNQBTy1jEa06OUCnaMR/OnRLBBnDQoiM+asceAIVa2OjNZ7nxhKpW5aEg1WMU3fY0x12SL2md+nthw0DDLUcGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLaFr9PZgJyXyWlvzCfGtSQ5pj75jGDJirYDuCm7ASI=;
 b=Mfiz/6gzm02e7PZeWXFvDAG09cODON5ydgb7iyht2C6mgHKR+TBXeT844tvY3QAhvLnqiLcqM+eEAZcGeP7/+eVc/RGVLkVS/2dN7yhQYYbDKFJgg7YyzaQ9JxslV5IbSYy7YP3ooSbv1Aa88QNEQyGvQmCr9nrat9Q2was/CtdNtxP64JoZK5VFaQQMsdvQlKrEy70ODMgVTLipcMTA4FyI1OPeDBVl3+59NVpwAwSNXaneOikeLPCLnzXONBD0LT28lIUHgwJu969eqQqISXS5orywcqXXBJZrcD0aGCa7/3Lbnvna4epF/1/jHRuYwcDc9xUQZiK7FH4nIfVftw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLaFr9PZgJyXyWlvzCfGtSQ5pj75jGDJirYDuCm7ASI=;
 b=dyuOUwHcjj+uJ/aaLGNjgVEKrEF+ygOPm9yazPHrNevEBS1W0ronX/i7r0eyJMgtFkSzOWo3Wvhe8SxyZV5TMbf4rvzXQv0U+dBVuS/xbjgLjJ3cft+W9LNDnOxjwnEtUB/szudXLJJNd8WPQyEsntmCNxnjHKQ7oSyBjudOEuc=
Received: from DB3PR06CA0029.eurprd06.prod.outlook.com (2603:10a6:8:1::42) by
 AS8PR08MB8274.eurprd08.prod.outlook.com (2603:10a6:20b:536::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23; Fri, 27 Jan 2023 11:43:32 +0000
Received: from DBAEUR03FT062.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:8:1:cafe::91) by DB3PR06CA0029.outlook.office365.com
 (2603:10a6:8:1::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT062.mail.protection.outlook.com (100.127.142.64) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.25 via Frontend Transport; Fri, 27 Jan 2023 11:43:32 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:32 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:43:31 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:26 +0000
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
Subject: [RFC kvm-unit-tests 24/27] arm: realm: Add helpers to decode RSI return codes
Date: Fri, 27 Jan 2023 11:41:05 +0000
Message-ID: <20230127114108.10025-25-joey.gouly@arm.com>
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
	DBAEUR03FT062:EE_|AS8PR08MB8274:EE_|DBAEUR03FT010:EE_|DB9PR08MB9636:EE_
X-MS-Office365-Filtering-Correlation-Id: 380b98eb-6bb9-4b0f-6eee-08db005bc01b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 QVg5TT9odF25czJSLKRkpYcIxQv4Cd6qZYMRahjFc8VBTPM3aeNE94hqVrpbmqPZZvn8m8HabMvp9ZybUSZN4LBk3HOSGF5YxRQPjwBqJoqs/Djiny6TkIqL8YAZ+bUPctPKho+bTySKU/Su9hBr0cUqRgIoD4oWG0LtQKngaeeWXUbBD/WJDmjO5IWf8uJUqMfY8eenhTc4HdAubsat1/wmBFvFfX9L8MkGak3dt6vE4hT14wM4VOJBqhNGyKyOzzZzQm2m/JuaJeG3sHHNHbbYuYv2tq9AdDTb2UR44kvMoFRkWNVW6DJmqMqmK4eUeQmXiO4Em3vYS9hUFwxJf5tTQ1oZg/DMi8QT/CacuJDB3yru6FK9fRu8VgqV5YTav8oyDWBXmubuIKS4+v2Qj9smVEH31WxkuHbnRfQvunV+JKsnUHXswAspgGmifW1vYikUVcH0qyOVVUOsP6ei3e0yz1PAHnRrHu1K0UDm8ciikNFDN4JlqsE07vmEpZyeHjQkvVjh1TlsOL/Yx0EbRGnke5zC3U7SoNFoRDD+mtOKG+/w7Z9CA7sPTD5fgHlg1pGFle1DCgdUcfxZCNZUVBxuwaUlafuJKLMRz3b76iLH/+G8yUKmDIiFyTNdgn3xHCXQ+kBvlKN6cHkRl5fkjzjvEuodbsi22m8meLtyFvr1tfaFeBpCz8SI67nyZPxCo4YUGPkOPY97KeN9jI4XXq6vfQix/pYoaHdFe6OvX7qEFMIZET+/kGvUku6kHvQr
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(41300700001)(8936002)(7416002)(6666004)(5660300002)(36860700001)(83380400001)(336012)(426003)(47076005)(40460700003)(40480700001)(82740400003)(356005)(86362001)(54906003)(316002)(82310400005)(110136005)(36756003)(7696005)(70206006)(81166007)(70586007)(8676002)(4326008)(26005)(186003)(2616005)(478600001)(1076003)(44832011)(2906002)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8274
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	27d06a6a-cd35-4002-4da9-08db005bb783
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cc7/X4Cs3OhkJU68o6Pup/poZw8JDBaBbQGaCp9l1d0XGT9VfGDLxmORdvo/yUxW6TohOBGXX0OsHFUpgxZ7F65NUL4HOpgAalDqbezEF4SRwF4m2+cpX1OwmRXkLrtseX9Lob65iVygv6DnAOu3o6xNQSTyFR38dxrNU4Adne8ulUE5pB604L6/EOK6SON9LPUTq/RKaGgt+Y/KiTZHGFpTa9ChMgxKM4uETTuXCLdj3T8acn146yZ7fnExENfmFw0ycUPseMuOSbu6C/9HB6eIewzP/NgLUaXCzFYzjw62ktjuX4gV75TBbANL/FxPY8nPPzvo2v/jKT7UI0r3sf3Qlqj9HuBgqgA21nef1EzVNdNldZhVAdOJuImJu8DeR2390L6AtlTSulsvgcs1tlU1nEcW0wlhLo6L5XiJj5qGdf2S4GQCwhnXdSO7/+3t99Z68VTD7xOudlVSqpfHRbq+T5STosFySFgXZiYaDlTMgoQPMjsf7W7Ibf0pqan2KdzQWj1Q2U0/dugxwIn/hMDUU6r5ZQDQAUDoQnDhXuogUyZJYfO60NKc4P/Zo4+2T/Q7rxCjJ8u9B1zeYQdLOwFxLUSuX7rJ+m4YTvGDn7HYMywJPhhORCFfMpvrIFLnIWdFucChhtko9GFk35SradH+6eIs3f4cZ3SAWhdeN5VVWseCYH39Q3rwpCBJ1UtIwGiF/zqXg69BK0inZNUKzPzhbuJAfRm7fXfxnzzJsR0=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199018)(36840700001)(46966006)(40470700004)(81166007)(4326008)(36756003)(40480700001)(82310400005)(8676002)(82740400003)(186003)(6666004)(44832011)(2906002)(107886003)(36860700001)(70586007)(5660300002)(54906003)(83380400001)(8936002)(40460700003)(26005)(41300700001)(478600001)(316002)(86362001)(7696005)(336012)(450100002)(1076003)(110136005)(2616005)(47076005)(70206006)(426003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:46.7948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 380b98eb-6bb9-4b0f-6eee-08db005bc01b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9636

From: Suzuki K Poulose <suzuki.poulose@arm.com>

RMM encodes error code and index in the result of an operation.
Add helpers to decode this information for use with the attestation
tests.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm64/asm/rsi.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
index 50bab993..1d01a929 100644
--- a/lib/arm64/asm/rsi.h
+++ b/lib/arm64/asm/rsi.h
@@ -16,6 +16,39 @@
 
 extern bool rsi_present;
 
+/*
+ * Logical representation of return code returned by RMM commands.
+ * Each failure mode of a given command should return a unique return code, so
+ * that the caller can use it to unambiguously identify the failure mode.  To
+ * avoid having a very large list of enumerated values, the return code is
+ * composed of a status which identifies the category of the error (for example,
+ * an address was misaligned), and an index which disambiguates between multiple
+ * similar failure modes (for example, a command may take multiple addresses as
+ * its input; the index identifies _which_ of them was misaligned.)
+ */
+typedef unsigned int status_t;
+typedef struct {
+	status_t status;
+	unsigned int index;
+} return_code_t;
+
+/*
+ * Convenience function for creating a return_code_t.
+ */
+static inline return_code_t make_return_code(unsigned int status,
+					     unsigned int index)
+{
+	return (return_code_t) {status, index};
+}
+
+/*
+ * Unpacks a return code.
+ */
+static inline return_code_t unpack_return_code(unsigned long error_code)
+{
+	return make_return_code(error_code & 0xff, error_code >> 8);
+}
+
 void arm_rsi_init(void);
 
 int rsi_invoke(unsigned int function_id, unsigned long arg0,
-- 
2.17.1

