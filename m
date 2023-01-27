Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2070.outbound.protection.outlook.com [40.107.105.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623DA28E8;
	Fri, 27 Jan 2023 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYzPSw73nqKSU8OhYrjVNXKg3dYyCW6HR+r91vpgRZI=;
 b=0rcSzAS2O6vh2ccQf3/wOqkjhAtByy4jyA8gm56RXovtyCCrbszOgILf+u6LLRBIt72b4UNw4zd1wEnNG8U4e6XK6OmHf3Vf/5IxGswe21OfFQ0RP+C30kMRfxkztrZ2JqMhmjSbl+TO0trFyz7XpI4S54fQhZTSiCZxuQIWOpA=
Received: from AM5P194CA0002.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::12)
 by AS4PR08MB7688.eurprd08.prod.outlook.com (2603:10a6:20b:507::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:42:03 +0000
Received: from AM7EUR03FT028.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:8f:cafe::52) by AM5P194CA0002.outlook.office365.com
 (2603:10a6:203:8f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT028.mail.protection.outlook.com (100.127.140.192) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Fri, 27 Jan 2023 11:42:02 +0000
Received: ("Tessian outbound 8038f0863a52:v132"); Fri, 27 Jan 2023 11:42:02 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 77784d72f3ea9004
X-CR-MTA-TID: 64aa7808
Received: from 44e899167353.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id D44DE00C-0BF8-454E-8529-A3E63B0D0CC9.1;
	Fri, 27 Jan 2023 11:41:55 +0000
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 44e899167353.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEn2RLLbP5bpOeUfueR5cKF8j6ftxy5Ug9egrz5aQZHzQvxbnY4iIy6KomwH7yOr/iSWe6jx6adBgUURJNVXQnjtxXr/Ago1fjjB/mj1n3SZkgc8pgsGC6hoTs5lX5oPNAn2RnMsuaTm0tYv7dnHTncQhA+DVMmRKxgIaBv4aFp4clexqQxoEYQ1+O4yfv/rf06NUuNm4z48ZSM9csv2xAohukEMGEGWGSbRg19CmerMrTKJHsBQj3hw0NLrUpoCAKWkqOlUER1B7LnomJoLoh6SoI9jR9rZBqQcNB2TfCmTgC3hz3Kr9Kj3Igt19TRHr+MYRiUquvGWK/QEQCItwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYzPSw73nqKSU8OhYrjVNXKg3dYyCW6HR+r91vpgRZI=;
 b=UpCxtzJC0O2vfYDfs43Lk8uQ6TAGWeooYG417tkxmDfLTURjrAvOoYWZOqlC367l21+Sljsh70I2pICZljDuPNKApF5o1Jh8MHl0V6VahQPSGWZogAG7IeRvncsHzw7FkfQEY70Y9pY9O19WfNVWfF/f8pCswiCG5Z7CFuTZq2F+6I9PYJXVTUZc5jR/uvcKJt8n55DQ9pVbTWv28JIh1deZKOlN+6U2MK0V4mhPeIez8vl3Jbe9E2wU+bii1j9yimVpEZn4sbiZKIudfEZ+4N+wJtaL6PTn2LKlk61U5gX7RHc3Rgtj36ahzOIA40oqd9UHvwiTbouOxcwkVdCbzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYzPSw73nqKSU8OhYrjVNXKg3dYyCW6HR+r91vpgRZI=;
 b=0rcSzAS2O6vh2ccQf3/wOqkjhAtByy4jyA8gm56RXovtyCCrbszOgILf+u6LLRBIt72b4UNw4zd1wEnNG8U4e6XK6OmHf3Vf/5IxGswe21OfFQ0RP+C30kMRfxkztrZ2JqMhmjSbl+TO0trFyz7XpI4S54fQhZTSiCZxuQIWOpA=
Received: from DU2P251CA0003.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::13)
 by PAXPR08MB7491.eurprd08.prod.outlook.com (2603:10a6:102:2b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 11:41:50 +0000
Received: from DBAEUR03FT024.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:230:cafe::86) by DU2P251CA0003.outlook.office365.com
 (2603:10a6:10:230::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT024.mail.protection.outlook.com (100.127.142.163) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:41:50 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:50 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:49 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:44 +0000
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
Subject: [RFC kvm-unit-tests 06/27] arm: Move io_init after vm initialization
Date: Fri, 27 Jan 2023 11:40:47 +0000
Message-ID: <20230127114108.10025-7-joey.gouly@arm.com>
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
	DBAEUR03FT024:EE_|PAXPR08MB7491:EE_|AM7EUR03FT028:EE_|AS4PR08MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a38bdb-c76e-4914-6bca-08db005b8233
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 hhxDnclshnX25RNw37UaJ6Bq5plaxqtvfEi/qSoa/Tim7E0yWsug7K/p0omEoD40wA2Br0iQ6bD5JHfoCbo46PI1vHkZeRFBorN9wl2sG8+08+AVL+W1AcXUZLVlTe+qkeJCaP48cJp5gbY2qmnbAE3kbCfTGZh2HRMRr4j4zsEQifRG6o7zoM7/qJ2B/rpNB5gh17nRDhs7jbdyswjqI2CInQJyVRoWJR1W6DCbVY5PrDY/im5t2lasVyDIyxevpfz8rUwwhE9Y2JDpGqVSepkCBZBH2Mtz4cVoKFoDL8vzADx08hH/ZOwI1s9D0Fu5Jm2kc786lR3GQiIYTC7ixPX4Hxwa22tFMSMyel1fahDELJk88K0QoCQTtGt1baKQd5pqB+O8COt1Dbqbvxbd9aDG6ZHzsUJcOuqBC+f/xwfuBWE21+uzI0i35EqK1Wi9YnWwS1ip1uB0u0lf0Oif1OFMZB4h57fBwIukdSlzJL9alutczRM/89VlpYQPyZ+e9RUd+bd0L6LkxAu177v9evodF1lf60u+D2mrDezP+1/l9lpgVeuxaAC0oVTdJbB786rogMCiaCcWED1AfkKxTcT6S5CtQ6cqvmu3CPAjOaJ+4XJBG3ZIrtT/6lwZZ2AxZ2rgIMp2QxMFCCxsGJ8CwVaiVH02wDhEhNpPFFJT+KpTJVv1Dnj+t36iNoe9abjFBKdOGunXmp3AFMW7Wp+UORQd7NLavVZi+dVvTKyC0H4Txy1YCatsB2Gq3wEsom41
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(44832011)(7416002)(2906002)(40480700001)(82310400005)(36756003)(110136005)(47076005)(426003)(7696005)(54906003)(83380400001)(186003)(1076003)(40460700003)(336012)(26005)(2616005)(478600001)(86362001)(70586007)(70206006)(81166007)(356005)(8676002)(8936002)(5660300002)(4326008)(41300700001)(316002)(36860700001)(82740400003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7491
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a6b2f3e3-fb2e-496a-00cb-08db005b7ae3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rfIUaz2B/hjTtHQD2ArnqWacdq1IsuLTw5gjxdHg55dfFnUMaxal7lCK6BGDszo+NjuHgomKGr70u1Gd7QriTS49IXtesuVVLLYsyWqEmc1MScECRimDDloiavcUJZbYPYPKPp/A0bzg8B9GfrO8psZER8yNhvjRsXD2HQzOSWgKATI7WoJzKqemgHh0SpxBMV3ubEAtfGNcGH4KEMfOXO6pgmANlthj8vZpzwi9xOOeH1tERUUETLfl52gZ8F7P1ueqN1EcwsBcDRxAH6xkt/i5ppnI3kV/HlxVCBMEQsB3ROvF9tCPrBOpQ8ENM4TiYVXBRpeID0U9oMng/cLlCKTO80jiJs5O7mMn5vGZKattA3p1YMHT/bBWbqar4/vBom7GckIaeDSqINeWCv/tY6QWNZJSwd81dVDxUn0pOIAZueoGeB5CCZm9BkJmUl+xT09udo55JkkI9pGTjn+rAEV9EMy1mIv4fyV+XrOLegcvVcQ90P/wjRqy3l20ICndCxI58CJwqo9uPeuMq6l4UWFYJGPZfyhAUpfTSmq1dTXQozlgkFCD8bFAmmaNgZdqGWb5NN6/g+EDO7L+QI6Sk8Oy83n+oerKPZ/aD5/nqw/YDk2oPJ+qtnQsip8K0LmV4dbQ9+O17Bf1s1MCbaWUnL/HVk/HI3kT7XhRX2NlFxxJLBKyeod6X+IvKyPRqh04SLCsUJVElFcupqGAiIxJhyiBBOX8SVUQdhnzaRVJ138=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199018)(46966006)(36840700001)(40470700004)(107886003)(1076003)(5660300002)(82740400003)(40460700003)(26005)(186003)(81166007)(8936002)(41300700001)(83380400001)(2906002)(336012)(44832011)(2616005)(7696005)(478600001)(36860700001)(450100002)(426003)(70586007)(4326008)(82310400005)(86362001)(316002)(40480700001)(36756003)(47076005)(8676002)(110136005)(54906003)(70206006)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:42:02.8707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a38bdb-c76e-4914-6bca-08db005b8233
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7688

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

To create shared pages, the NS_SHARED bit must be written into the
idmap. Before VM initializations, idmap hasn't necessarily been created.
To write shared pages, access must be done on a IPA with the NS_SHARED
bit. When the stage-1 MMU is enabled, that bit is set in the PTE. But
when the stage-1 MMU is disabled, then the realm must write to the IPA
with NS_SHARED directly.

To avoid changing the whole virtio infrastructure to support pre-MMU in
a realm, move the IO initialization after MMU enablement.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 81052a3d..65d98e97 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -274,9 +274,6 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	/* cpu_init must be called before thread_info_init */
 	thread_info_init(current_thread_info(), 0);
 
-	/* mem_init must be called before io_init */
-	io_init();
-
 	timer_save_state();
 
 	ret = dt_get_bootargs(&bootargs);
@@ -292,4 +289,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 
 	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		setup_vm();
+
+	/* mem_init and setup_vm must be called before io_init */
+	io_init();
 }
-- 
2.17.1

