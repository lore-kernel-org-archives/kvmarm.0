Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C920238F8C
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fP0hZBQLW0r5LPMNDw9vkQWBkTgVKFZIvfc9QkLlChM=;
 b=Yrx8MYtKqgv9lvFMg6MENe9rLixHTzZ+HgyngQg4Xu3XO/KXDeB/We1+Z9727+I3RgXDmySuAoquSk8F/fk7MC8hbGS0YLS5LiQs9vYzaUdB+3nklBpY/N1DFOD6PmZPizrtUjSF99GFTUBzNS0Mg18hb8R5/ccQvnyUJvIZcA4=
Received: from AM6P193CA0095.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::36)
 by PAXPR08MB6349.eurprd08.prod.outlook.com (2603:10a6:102:15b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:03:47 +0000
Received: from AM7EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:88:cafe::3e) by AM6P193CA0095.outlook.office365.com
 (2603:10a6:209:88::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:03:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT023.mail.protection.outlook.com (100.127.140.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:03:46 +0000
Received: ("Tessian outbound 0ae75d4034ba:v211"); Wed, 27 Sep 2023 14:03:46 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ae231f9e02a9b0cb
X-CR-MTA-TID: 64aa7808
Received: from 42361384454a.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7EDF8468-9F69-4C21-BA86-2E1A1B912054.1;
	Wed, 27 Sep 2023 14:01:51 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 42361384454a.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPJCUUrZNNyO177ukqeVhbgMpCT3DoTiFQBkauYBSbcsjLQnQgayICGsdIlQh9CKb+DKgkWgpwZwIt0yLDOXkppkkLJQx/iofqdAhPR1AZ//EGi+9Wg/gKpNKJe9KF7eUTVLPWiTPh1xIfussZyc/1q1UlNlaUX2U+PI3IfBysPIEHlorOHNSYqHxBYdqEIjvqM8zuCJXbBU8nlnqtYWZXn0cPetWvL7dnqnYluVAZltr3QcclojYTFcLMn6CN4w3MRAxTN0T9vauLSr/+lowiJJEJMxHSIOjeAkvk9svzXtpdLDt7ILiA1mFTX5ckPpq3Ux0dy9uVIEmrqAC8Q6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fP0hZBQLW0r5LPMNDw9vkQWBkTgVKFZIvfc9QkLlChM=;
 b=N3ZJcDjUd1sbw5LgCA5Ljo9fzFb9wQPxto2aWnel/ldP6MGDO3bPDqAeeWWeq8ZgSDNO1B+bhbwuqz3T5W73VU1JS4OqH/0KgmsC2GI6cjRNAqdtVA/WvZwppwDZPsX8F5DMFtdZZHpOiWssvW3shHI+RDIBrWaiclzYGKfSTvliUCGXrrdNJOFy2PiHS2Sq5KADEEb4+/tsIi2mlYUW+fhBqdG3Dierm+FLAzv//R/Pjuatwb6NNRwSNZaHnMwHSDKcWICNC5t2NHHPhhgCQNdXzVHG0y80o73y04wTFCcxVFrXijvics2EqJbaROiVU095TzAgXVGu9GxJ/tUt+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fP0hZBQLW0r5LPMNDw9vkQWBkTgVKFZIvfc9QkLlChM=;
 b=Yrx8MYtKqgv9lvFMg6MENe9rLixHTzZ+HgyngQg4Xu3XO/KXDeB/We1+Z9727+I3RgXDmySuAoquSk8F/fk7MC8hbGS0YLS5LiQs9vYzaUdB+3nklBpY/N1DFOD6PmZPizrtUjSF99GFTUBzNS0Mg18hb8R5/ccQvnyUJvIZcA4=
Received: from DB9PR05CA0009.eurprd05.prod.outlook.com (2603:10a6:10:1da::14)
 by AS4PR08MB7653.eurprd08.prod.outlook.com (2603:10a6:20b:4cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:01:49 +0000
Received: from DBAEUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:1da:cafe::a3) by DB9PR05CA0009.outlook.office365.com
 (2603:10a6:10:1da::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT051.mail.protection.outlook.com (100.127.142.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:49 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:40 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:40 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:39 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 13/20] arm64: stop using generic mm_hooks.h
Date: Wed, 27 Sep 2023 15:01:16 +0100
Message-ID: <20230927140123.5283-14-joey.gouly@arm.com>
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
	DBAEUR03FT051:EE_|AS4PR08MB7653:EE_|AM7EUR03FT023:EE_|PAXPR08MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb14d11-29d4-48f7-8d22-08dbbf629165
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 du8ahLLIPeC9aWNg18cDj6DAuuvBKq7TIOCwkSO9W6bRQvyJ8x1dUN2enprZH2zUd1C6a5buJDsOSePUj+WJXweB4a+8l7RXJnCGukKSaRGTAhM9QGJSdEOF45cn5vIgmN5UhD08LlZb/jK6gbd+5rAkJv7zwxT/bfHKS3AQwgM1IelX0ckDQPKKQkwKgZ6gL7mmL6E/nv4AMvsbJ+t4zIB8UGfhqF6YWaBP0iNaT6JCPnjHA4EEtkI7WBlU54DrXZI+GgtA6dqLbeOHVrWlrFLjEcuTukEN2i9CCYWQ+3IJzEDEZinhMf+OPXUjXOpueiqW0elFhUfyoGHffJAotL0bzrcyYwvqtH6A0d44dICctd/tlBGe6bQLqTM8c6BO/kspiTD+UKjG4EQHKVckTlUKg6/43vbcnPrtI4AB4kkCbJGUa12I+Zhydz+2fPisjREOABuf9jLhUI2e7peT8BbJBsBk2FfBGUPJVaoeXby+Th/81Z5sQQ0OgW4uiVzkVEJlvLs4h4z3uzDIltD5EMUeogK0/J9/dBz+ufGGCWmvyBvh829lohATA2mJbJjCMDO8+WS2QlgRbWzJbzE0L+w/Dk3Syg7JJe/aSnluf6p1HSf1kwFuS3qWgmO69NT6rZxEeN7sExHW0Jdzo2auSviK9iar04gcpB5OZ1x8Z2sEMDsQ8s3nwiT8T5Q3uCYpThqF5rO/rrU21o+/k7BvUjTCTSU4Tm1+DoX5GTx45V6kfWNxAkvwxmz/oaS4Nly9fK59ysQAr/c5PwqlIYa1aeaiOwoG9Rmv2E8BARRPuHs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(346002)(136003)(230922051799003)(451199024)(186009)(82310400011)(1800799009)(36840700001)(40470700004)(46966006)(54906003)(316002)(70206006)(70586007)(6916009)(7416002)(40480700001)(8676002)(4326008)(41300700001)(8936002)(2906002)(44832011)(478600001)(40460700003)(26005)(6666004)(36860700001)(47076005)(83380400001)(5660300002)(7696005)(81166007)(426003)(2616005)(336012)(36756003)(1076003)(86362001)(82740400003)(356005)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7653
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dce59fe5-efad-4c43-be7a-08dbbf624b62
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4X62gRMfoFNmqiFc5rdrCerSQtGnuDiXlvC8j24m7LKhqLsdCKOnNtF3rNh9vq0qf/st10T+AEkyXU4a72LXgiGYz3pJCzMJzxKmi3t9a7qhhl+UYyri9Y3TgTHSCuKnhgLZPdqJtATL1YXCYpGnJNZsh36SDrI5feZK/9/PDf78DgfFh6Z9WIOuwdrVbv7K7WIZOpmH9GMXMrq5MbPKZLUgwFp3ngICJ+f8gHDYLrsCLxW2n4v7a7ww2FDgBBCGpqGI7EKAWwyymeb4LJBgk4HDS1gytdhpui6MUG6bJ7sfPz48Do2N4IVADNxRB5t5sfo2gzJRL152ZVyUYrH7z8McOB513gaCmgPu5o3ewsHCODxtBn0m7dSzgaVDJr/Nk1UTdAE8G0cM5nBIqaF+Y97Bh71WjgBh/dybF29yZJtIhEfBAdTLyA7NNzMvMYvmm0XDgMSt8Tz/CNb7BDxi4ljClUxqTohw7hSwPOQsClZeJVyuY7WLjCcs4Lyey6+EJx9PHcGzGjGVUz7hvByNYpOl139F63MxOk/tBSb7CZhaOl/W/67dqOwh67xqXBPanyvd1D7/3LG4PN8hAuQ372f4kAUqObjFQ0QqNk6k2TtZiLNNbQa3oH5jEPx2g6mqGTdiB2TvJm7IY0JNv51MmurdpusJdh/beB1OOvkVVc1EFwBoFcHfBBRy3u0f6eOb/Fnr1ck8Gq9WmJ591B+lkTunYeN18ZmDDfup6QstaX5SOD5uZu+ioCz8kROBrhiqpY5GbYqfrJXhPBx3J/gJKw==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(39860400002)(396003)(230922051799003)(186009)(1800799009)(451199024)(82310400011)(46966006)(36840700001)(40470700004)(40460700003)(83380400001)(26005)(7696005)(336012)(82740400003)(2616005)(426003)(70206006)(6666004)(107886003)(478600001)(36860700001)(47076005)(81166007)(44832011)(70586007)(2906002)(54906003)(41300700001)(8676002)(40480700001)(1076003)(86362001)(8936002)(36756003)(6862004)(5660300002)(316002)(4326008)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:03:46.9484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb14d11-29d4-48f7-8d22-08dbbf629165
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6349

These functions will be extended to support pkeys.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/mmu_context.h | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index a6fb325424e7..c0eeed54225e 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -20,7 +20,6 @@
 #include <asm/cpufeature.h>
 #include <asm/daifflags.h>
 #include <asm/proc-fns.h>
-#include <asm-generic/mm_hooks.h>
 #include <asm/cputype.h>
 #include <asm/sysreg.h>
 #include <asm/tlbflush.h>
@@ -209,6 +208,20 @@ init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 	return 0;
 }
 
+static inline int arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
+static inline void arch_unmap(struct mm_struct *mm,
+			unsigned long start, unsigned long end)
+{
+}
+
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 static inline void update_saved_ttbr0(struct task_struct *tsk,
 				      struct mm_struct *mm)
@@ -298,6 +311,12 @@ static inline unsigned long mm_untag_mask(struct mm_struct *mm)
 	return -1UL >> 8;
 }
 
+static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
+		bool write, bool execute, bool foreign)
+{
+	return true;
+}
+
 #include <asm-generic/mmu_context.h>
 
 #endif /* !__ASSEMBLY__ */
-- 
2.25.1

