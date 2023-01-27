Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2083.outbound.protection.outlook.com [40.107.7.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D1C28F0;
	Fri, 27 Jan 2023 11:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5FjfwVBwygdym6y9NRMbHUpKfxtgFRoaRFzE5MRdEU=;
 b=Tt10Z9AiMTuspdx2UP4vvMiLSmh4VEYMyAb6f4d2A72z25BwfPKgjkDWCeMgNeGrChe2vWWJRinOLi1QLNjD51mTot1LmBuGOhBnSAzOuII7Cf//025xE0CBYUODBS5k0edmT+x2p25VOnVsTFeLQDSTUQhJEx9HdsfeyrzXioQ=
Received: from AM6PR04CA0036.eurprd04.prod.outlook.com (2603:10a6:20b:92::49)
 by VE1PR08MB5648.eurprd08.prod.outlook.com (2603:10a6:800:1af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:43:10 +0000
Received: from AM7EUR03FT037.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:92:cafe::36) by AM6PR04CA0036.outlook.office365.com
 (2603:10a6:20b:92::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT037.mail.protection.outlook.com (100.127.140.225) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:43:10 +0000
Received: ("Tessian outbound 333ca28169fa:v132"); Fri, 27 Jan 2023 11:43:10 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: a621d2503924eac8
X-CR-MTA-TID: 64aa7808
Received: from 3299abcf3b4b.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 42734D87-1B4B-4381-83A8-ADEC2DFE4D1A.1;
	Fri, 27 Jan 2023 11:43:03 +0000
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 3299abcf3b4b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:43:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsmAqhDZiXsMXpqd4Q0hBQF4ro3nNV6riWhArRUSojKMpy+uZy52rPJAgtszX5kTMIPuKhZPX1tdvHmm0iwbQSC5QVjiwKR07ULdsbcs3bE3Q46sedDnTsIS5Q4qwEfSvmX97Jf/AhYKpcDv7wDEWuBzszPCkhKCXGYs1WVfEZwRjCcj3BNEM95DqC9pymNwPqrrRxr8z63xOamcNoYpBGWUDLXzGre+AglatzUMA1CApePzEoGNNvUmR+JfULlNw5twCFsQ6erXdNt4BppWzHvSThZWZ3mBMn9Lb6vbxopa9/kkyRHQm9Zx4tGbVRhiUn2x5JaZLz4G3IfsUaZOtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5FjfwVBwygdym6y9NRMbHUpKfxtgFRoaRFzE5MRdEU=;
 b=nH7Hw+IIwyJt5incNgS/++pKEOzQq4biCIolq9m2npGu82fym8Zw7bInkLzzMo7vr/oprI5fV1mttr+fyNTEo6dPlb/a3Vkl0yw09fsuSh7PG0US0B2xt9UCWn4FGfFwVvPJw01pYiRudtBXSTUGsN60zQ99wI8q29/sjQ4YB1PL+CTESIZLbsBuwcDoTgKGdZ8sFSn1ZuY8krqWdxz2U0sslaa/X5lnIcOxvfCrudHdVsH69vZaXe1XB6JsOwxccDQ2Gt3Y499P2M+ud8oTaJDvkaWj1Dz9CHaiUS11oa0GgVkx658vQ8YuFrBAKPP0Ahax/Zl24eUzxnVKpHEYlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5FjfwVBwygdym6y9NRMbHUpKfxtgFRoaRFzE5MRdEU=;
 b=Tt10Z9AiMTuspdx2UP4vvMiLSmh4VEYMyAb6f4d2A72z25BwfPKgjkDWCeMgNeGrChe2vWWJRinOLi1QLNjD51mTot1LmBuGOhBnSAzOuII7Cf//025xE0CBYUODBS5k0edmT+x2p25VOnVsTFeLQDSTUQhJEx9HdsfeyrzXioQ=
Received: from AM6PR10CA0044.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::21)
 by AS8PR08MB8160.eurprd08.prod.outlook.com (2603:10a6:20b:561::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:42:59 +0000
Received: from AM7EUR03FT006.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:80:cafe::a1) by AM6PR10CA0044.outlook.office365.com
 (2603:10a6:209:80::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT006.mail.protection.outlook.com (100.127.141.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:58 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:57 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:52 +0000
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
Subject: [RFC kvm-unit-tests 18/27] arm: gic-v3-its: Use shared pages wherever needed
Date: Fri, 27 Jan 2023 11:40:59 +0000
Message-ID: <20230127114108.10025-19-joey.gouly@arm.com>
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
	AM7EUR03FT006:EE_|AS8PR08MB8160:EE_|AM7EUR03FT037:EE_|VE1PR08MB5648:EE_
X-MS-Office365-Filtering-Correlation-Id: c11e6358-e282-42df-16f0-08db005baa5e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 Y6Na1gYNSfIFPFmAAsVTq4EsI/YhfrpjuUunJU4DpofTTnlFerHTlwpDNDwbw4jekRyCVkGX+En2c5OxxhiNeMtRCcqdguZeW5MP6LkUCprTRs3J/8JxAzOZZrq8EfNkx5oeI772L/Nba9tDaiZfQ/op+3jeuZ1plOqAS+k/xP6cQqDfnNb97EgsKtzRIfm3Hxjx4FlcFOr+jqB+Rybr9lizg/X5NwzAOf9LSmIIN7K+5KhN1fmcdcXvGX/9AdOiz/o69lYSOTNx98wk+8aTtOUwKJzBaWR+iKZRWaqQYWA7rRyT8guFDrynSXCv0CPJfS/hjaVCJl0CdS3C27zpBHMCJCUnz1iTdJ7fq8zWqQ6x2m7SgfeGNVVvSb+CFQXX5qsQmwGepr6nIyvIm70LpJ4zIT4Dj3eS5b/kyc8p8cQPxXm+kcAuzebk+sccGWcZXQVoJDt2biGOlhAVLlJ3RMy01Vrj0zJo/PLPokNC1a/jYStb9yxH/2Uv1TOzmgRpxFqqkdggUyQvKNn06UTwhG26I3YKimZOGBvh6v2P8keeQk5oAcc4FWbUW+Iw7aF23PNtJmWwVX3KOblnWEHI4YCl21Z42ynwNMs/Lef3bygERH4ic6XhO+9F3VG3RMw0s0p7p/fkOjbicFKJMqdb2szAp3TxPoZM4a4UAtRANjzLmUZS0e4lMxyFSKg8FePBTVvnQsEDPrXNI2wRT0AHw8Dzl5XDpiMahQOJTvOU0QZIEoml92UQj0oVe9JlPTNs
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(41300700001)(70206006)(26005)(186003)(356005)(70586007)(8936002)(8676002)(83380400001)(5660300002)(44832011)(1076003)(7416002)(81166007)(478600001)(36756003)(2616005)(36860700001)(47076005)(426003)(54906003)(110136005)(7696005)(86362001)(336012)(82310400005)(40480700001)(4326008)(40460700003)(2906002)(316002)(82740400003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8160
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5d224b18-d083-4de9-1107-08db005ba39f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9ZHdz0BnTYZryzwbuGcsG6PrHANa65z+rmFzK/dEvC9iw3Xm28okciJZZs02UEo0HQiJQINfjkZHAIVq6AFRjitiKkN7htxjy4F7GePE5pA00Q24VkpXStPom6MnZc7PojCDMnMc/XJhdq477ixSKso0KF3pRhb1CLxZglsKpK5FlcfXg7l1eznhemoDpVy483Rj23HFDsHq615s2vMTIHRDmvwxgFkyNJ0DRjIHF29SWazx1RB7Ke7pjHg3i+MWi0/8pckllwhHPO3qu5bSRdE43850MuSBckr4ZNk5XtojXBv/CZjNPL+SHTnxUlHfZFUVXeK242sVEqL3vcaSXoYybP3WvfQZN6v0TpiTtEsccoS2ejZzkWI8CzKYk3ZAsik3gSSoRsCjm7MrIGA3qtz6QXu2OrwtBQJBwuSMbKz5ERcBPrGrRoO9KGPB5hKWpKVGA0Ji8H/Zmhoq0as8HKLib6sQtI9myo7y9DXDSZxpwPk/qBV1OpHtD/WepG/y8/zHtrqf6u3YZalORURjkP3H59ZttovLtrWU8Ffr38czReU+B8yWhNYa06WPMvZHe8dvBxoNnT37BH1nWUKPLx6XgDFgQGjbbGXQ5tngtDMF7aGlA4j3Qv4i28JphBfPlBQcoYwo98lglSaI55aAvjXJ6nNvP3/Z7mDu+P04UjwBUHHjJ7MbCRU7JM1oL8rvzP4ZQJAs747ssI3mvIAOOeAgLxZ6iDG6ov8Psh3R9zQ=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199018)(46966006)(36840700001)(40470700004)(1076003)(478600001)(186003)(26005)(4326008)(8676002)(107886003)(70586007)(70206006)(7696005)(336012)(450100002)(82310400005)(41300700001)(2616005)(426003)(47076005)(83380400001)(2906002)(86362001)(54906003)(110136005)(8936002)(81166007)(40460700003)(36756003)(36860700001)(82740400003)(44832011)(40480700001)(5660300002)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:10.2436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c11e6358-e282-42df-16f0-08db005baa5e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5648

From: Suzuki K Poulose <suzuki.poulose@arm.com>

GICv3-ITS is emulated by the host and thus we should allocate shared pages for
access by the host. Make sure the allocations are shared.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/gic-v3.c       | 6 ++++--
 lib/arm64/gic-v3-its.c | 6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index 2f7870ab..813cd5a6 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -171,7 +171,9 @@ void gicv3_lpi_alloc_tables(void)
 	u64 prop_val;
 	int cpu;
 
-	gicv3_data.lpi_prop = alloc_pages(order);
+	assert(gicv3_redist_base());
+
+	gicv3_data.lpi_prop = alloc_pages_shared(order);
 
 	/* ID bits = 13, ie. up to 14b LPI INTID */
 	prop_val = (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
@@ -186,7 +188,7 @@ void gicv3_lpi_alloc_tables(void)
 
 		writeq(prop_val, ptr + GICR_PROPBASER);
 
-		gicv3_data.lpi_pend[cpu] = alloc_pages(order);
+		gicv3_data.lpi_pend[cpu] = alloc_pages_shared(order);
 		pend_val = (u64)(virt_to_phys(gicv3_data.lpi_pend[cpu]));
 		writeq(pend_val, ptr + GICR_PENDBASER);
 	}
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index 2c69cfda..07dbeb81 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -54,7 +54,7 @@ static void its_baser_alloc_table(struct its_baser *baser, size_t size)
 	void *reg_addr = gicv3_its_base() + GITS_BASER + baser->index * 8;
 	u64 val = readq(reg_addr);
 
-	baser->table_addr = alloc_pages(order);
+	baser->table_addr = alloc_pages_shared(order);
 
 	val |= virt_to_phys(baser->table_addr) | GITS_BASER_VALID;
 
@@ -70,7 +70,7 @@ static void its_cmd_queue_init(void)
 	unsigned long order = get_order(SZ_64K >> PAGE_SHIFT);
 	u64 cbaser;
 
-	its_data.cmd_base = alloc_pages(order);
+	its_data.cmd_base = alloc_pages_shared(order);
 
 	cbaser = virt_to_phys(its_data.cmd_base) | (SZ_64K / SZ_4K - 1) | GITS_CBASER_VALID;
 
@@ -123,7 +123,7 @@ struct its_device *its_create_device(u32 device_id, int nr_ites)
 	new->nr_ites = nr_ites;
 
 	n = (its_data.typer.ite_size * nr_ites) >> PAGE_SHIFT;
-	new->itt = alloc_pages(get_order(n));
+	new->itt = alloc_pages_shared(get_order(n));
 
 	its_data.nr_devices++;
 	return new;
-- 
2.17.1

