Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FF31F61C
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kps3hoRbmyPaRWG7aZnx7NFq6J9Im7o7f7nMifIm3Cs=;
 b=YUbjelT7j98hGIcJig4Q6GhMyVwg78hyZiQD+cX/enyONsao3TgTmcTSW3pTqT+CbxS3v8ubYEV/D0t4JC2fuyJclFEa7uMLYvSWCwhjbMxfxSnBFEv1xRr6WQ2D73PH4KRJBLGnvPi0wn5jeeUsfv16bftP45pyoYSGbn2bL5A=
Received: from AM7PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:20b:130::23)
 by AS4PR08MB7831.eurprd08.prod.outlook.com (2603:10a6:20b:51b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:10:51 +0000
Received: from AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:130:cafe::f0) by AM7PR03CA0013.outlook.office365.com
 (2603:10a6:20b:130::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:10:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT005.mail.protection.outlook.com (100.127.140.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:10:50 +0000
Received: ("Tessian outbound fb5c0777b309:v211"); Wed, 27 Sep 2023 14:10:50 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 98cd8b91356deab0
X-CR-MTA-TID: 64aa7808
Received: from 75ba1caeea87.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id A090ADAC-E753-4495-B990-D4CAD763C3BD.1;
	Wed, 27 Sep 2023 14:01:46 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 75ba1caeea87.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdZ/+AvMxP7sunSaYTQUxOrFA6+msvzjJEDWjQE+HUh/hySKctj8mznGtwLOTL1K47HepF3ehNJREJSQKGExythe7AzLXoCcydYZdV0RQtKkphViCvJfdF7ksdKz0iW70RUeJV+hwUGipUEp1CjmNZuMuzCQcr/5Hb7jrnT/tuh5ObrSxte5hhO1G/KQamZklixp37P9geS88URNg/u8nlvrniKrpA/syG0Io2l44ldHBm9BKPkJKARNXHy0WJViS0UWSKOmSRzoDx2LhIai8qhIdujAuNp8hvE1GuMFoi68Lo1i+XOOJEYJ6CPOb/oKLjdb15Rgl4aPOijY2j5/4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kps3hoRbmyPaRWG7aZnx7NFq6J9Im7o7f7nMifIm3Cs=;
 b=fz9z77D1iWXYMQ3/gQA4F4o6t/WIUOd0VyvdhpQddysDxcWlUn8nJa/2ghDw4rvUyfoClDEE227AvZIWGo11j4p9EtpK1c1e021NZy4NVkR/ImJ/tDnZ5oY95mRA+ohulB+PB3J8okDZ9aZsMS4gx97QD1AkZhesbIwnI/dfHQA6jjIiAB34uSiWZYjhZJCMgbn55S9gjZe1ECZHC+SXK8ZtMlvGguYm429XVGzFx7U/Ma5nzLNV7VU48NFJBNb4/b6Fu4v7HfP1chVOsVndE4by8+bECgYk78mH0uKpRpR7ac5HCynH4lWDalehC684DMBQ71rq8tPrYndj+Qxy9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kps3hoRbmyPaRWG7aZnx7NFq6J9Im7o7f7nMifIm3Cs=;
 b=YUbjelT7j98hGIcJig4Q6GhMyVwg78hyZiQD+cX/enyONsao3TgTmcTSW3pTqT+CbxS3v8ubYEV/D0t4JC2fuyJclFEa7uMLYvSWCwhjbMxfxSnBFEv1xRr6WQ2D73PH4KRJBLGnvPi0wn5jeeUsfv16bftP45pyoYSGbn2bL5A=
Received: from DUZPR01CA0173.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::27) by DB9PR08MB8337.eurprd08.prod.outlook.com
 (2603:10a6:10:3de::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 27 Sep
 2023 14:01:42 +0000
Received: from DBAEUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4b3:cafe::79) by DUZPR01CA0173.outlook.office365.com
 (2603:10a6:10:4b3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT047.mail.protection.outlook.com (100.127.143.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:42 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:42 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:41 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 17/20] arm64: enable POE and PIE to coexist
Date: Wed, 27 Sep 2023 15:01:20 +0100
Message-ID: <20230927140123.5283-18-joey.gouly@arm.com>
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
	DBAEUR03FT047:EE_|DB9PR08MB8337:EE_|AM7EUR03FT005:EE_|AS4PR08MB7831:EE_
X-MS-Office365-Filtering-Correlation-Id: 29118ae4-7d79-4db5-6c57-08dbbf638e11
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 jlLThbYk0gyOLge1Cwuk1IiNadjTOMIcvu9xuz+UxHXN/Deu8r2EbfYPMuXp/LGxRnhMu1l0d2iGWP2xtKFsOBe/3feflRCYHnaZUzJ32UHuqYY/vLpYP+ulP2sTcOFGheT4m9uHZCjUQESFx/W590vFeOSaLfqXIz+OEXM63Nkxu9zljRWNMzDZSfPAc4wodK6gQ3Jm3Eoq/zf6FnJ+TaeQfKWai1yqvUwePqUSk0gNECzXyhRprktvt546TJNL434Ptcpn9hO4y5dsjZx8rRmrVuOttyF1+83F3kDvgjwFXASGYQKvhgki+AbrvlL3/0QBxfZ6pmpPAQdl2VPGd7i/nXPmOLCj6f6ycFLB3J0pp/ptOp7CYOdGsT8Az69aSz0IZLipBYPgdstjzcjmduI/wZ2UWuuqRkdBkssL5pWtzE05mS51IoYKH/1Xv0C9eawVVSZU62ZZ56nGUQiyLmeqvKfnz24sReeEEJHXKxwaM2PXW6g1TZCvDOwX1FGIb3WBbDuP34NRixwC4QZvGYTeZW2mMmPW+8Zqs5D7WnwIsbaipu7tqLjL6bKAF2ftFo2blfoEifvrM8uJ/W7nRhozivAIyp4Pm8QFhElx+bCel/qNe/UdtIIZ45rXYTszkxa4byvxxLFfiK1U1if+R6VUXAz356Zu0ITqiy0sZPMSeTddWEu9qrlJ9IGqNRxRKypVxB+ZMSUTTsYv4JQIrqzl5wwmRXKN2DPOT8iPBg5p3aYJaA7f+zKifwlB4k9XypsSUhdtFW2qGYeH8kALHw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(39860400002)(346002)(230922051799003)(82310400011)(1800799009)(451199024)(186009)(46966006)(40470700004)(36840700001)(5660300002)(44832011)(26005)(40480700001)(6916009)(316002)(41300700001)(1076003)(2906002)(70206006)(7416002)(8676002)(478600001)(4326008)(54906003)(8936002)(70586007)(36860700001)(7696005)(6666004)(40460700003)(36756003)(47076005)(426003)(336012)(81166007)(82740400003)(86362001)(2616005)(83380400001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8337
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bc7bfd5f-c98c-42d4-022a-08dbbf624755
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vos4KvK4EUtW29/cBFLlKFu1axyB/Uk/O1aIhsJbXL7WNeDc5D5py2evfzImcxSwi+2Pq8nSUYMzUIiPUGeN3Icf4H4EcCkMUTogrrGWHwWj3ooxr0M0vA8ymh8kvoVjj9z6g5jgXMJO72PRjzJEaqUKGTRE8A2i1scJMwzHx8EOBRCVdgmYpf8m5AzQ8ocyOwwv2PflGC14ZtwwruCE3NSaAOZ4cvb5gYH1j8EPKLkwhoHiPRs/DMyXPu+2yqFELnkeozituX9UqenDteHzBSb8CJHpAjAqbsTldr6dy/BmZZoWtvSML5h2JC5KvfmTRYHo/M9kBvRUjjUB3CH1UpDI8dc1uzLracNAipJ0uyBOQ7Pv960WMGmpBm1niBRCRD9C17gqB4n/7CzKNPIv79OyIUf+ZXXl8N+a3nsYov1to/Eqwgf3XbEVS6VKbP5dOz2tytaonHcZMBGja16vCdY2L+O25hSSf5bCsNtbWDcyFYFxeFj1gOSpXlf521df4Crzruh8sobyHyZhgNZAtWdIiFPUyYr0/Ddcbchbs9uiA0yKpaBXvbRlb3blXlDcW1hyKzxwx5tu3TO4zDCwgrqn1ohbydLs+D7DKds2jpK51g8ijAyySWQjCrZvItj/n+JwKrTFVuLdpW7aafR/SjQL+0BMOLqF5dtuB2clIry1qa/FnS3W/aO8qZ5vXYHSODHH9eb9jcFiS0wbUSMqxLdYU/MrSswHRB+7+7TjlwGpGLD+v/c/IkXTTC0Onu0y
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(396003)(136003)(230922051799003)(186009)(82310400011)(1800799009)(451199024)(36840700001)(46966006)(40470700004)(2906002)(40460700003)(86362001)(36756003)(7696005)(5660300002)(83380400001)(6666004)(81166007)(82740400003)(47076005)(478600001)(40480700001)(4326008)(8936002)(2616005)(1076003)(107886003)(6862004)(41300700001)(8676002)(44832011)(336012)(26005)(70586007)(70206006)(36860700001)(54906003)(316002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:10:50.8762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29118ae4-7d79-4db5-6c57-08dbbf638e11
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7831

Set the EL0/userspace indirection encodings to be the overlay enabled
variants of the permissions.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index eed814b00a38..06fb944ef252 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -141,10 +141,10 @@ extern bool arm64_use_ng_mappings;
 
 #define PIE_E0	( \
 	PIRx_ELx_PERM(pte_pi_index(_PAGE_EXECONLY),      PIE_X_O) | \
-	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY_EXEC), PIE_RX)  | \
-	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RWX) | \
-	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY),      PIE_R)   | \
-	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED),        PIE_RW))
+	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY_EXEC), PIE_RX_O)  | \
+	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RWX_O) | \
+	PIRx_ELx_PERM(pte_pi_index(_PAGE_READONLY),      PIE_R_O)   | \
+	PIRx_ELx_PERM(pte_pi_index(_PAGE_SHARED),        PIE_RW_O))
 
 #define PIE_E1	( \
 	PIRx_ELx_PERM(pte_pi_index(_PAGE_EXECONLY),      PIE_NONE_O) | \
-- 
2.25.1

