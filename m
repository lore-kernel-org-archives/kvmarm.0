Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2040.outbound.protection.outlook.com [40.107.22.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EE837CAC
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbrnELc79cTTyl8mSzRLYhNT8sC3fwyI3hxFhzA9Hnk=;
 b=6aQKWRsScIzuVfSjKGLTQmcWu2faaUoQTjPYQnoXbjADikL3RRfMuCtb+7+bEueP7Ju1ZQtGr5SRzkccgiOSR9+Bf2u1lx6JgSiN/uTZRIFqaXr4PunhZVt2DkzaPS4Oul+p270vI7sifIr3KEq2zWvjKegATFFw03WmEkHmmyU=
Received: from AS9PR05CA0038.eurprd05.prod.outlook.com (2603:10a6:20b:489::25)
 by AS4PR08MB7530.eurprd08.prod.outlook.com (2603:10a6:20b:4f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Wed, 27 Sep
 2023 14:03:19 +0000
Received: from AM7EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:489:cafe::c9) by AS9PR05CA0038.outlook.office365.com
 (2603:10a6:20b:489::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:03:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT050.mail.protection.outlook.com (100.127.141.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Wed, 27 Sep 2023 14:03:19 +0000
Received: ("Tessian outbound 0ae75d4034ba:v211"); Wed, 27 Sep 2023 14:03:19 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 2a9f62c7b57c88f0
X-CR-MTA-TID: 64aa7808
Received: from 6692e6f04f1b.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id DB31AE2E-8849-486B-AC68-2C7CE4026BC5.1;
	Wed, 27 Sep 2023 14:01:50 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 6692e6f04f1b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjOUkYPs8AOGRxlPXGIkojfy6ug5wwNgWZ7T/YqxFk495Y6ggR9K7kHGCTZmGbIYW1HhGag/zVqoZq0g3CjSUq1kdjgxxuUXRtHwl8tK5F13WlwDSOowikbZxvj7qd9Wzf3XOZTTRIXxy8KfJ0MAat0yl7I6TOsDikW8CzoeW1GAmYLKd+wz200VToV3B2X1/eDZOIZl4LIzugX6Kc/1XfQmBP+faz3odddFz+kmLYuJolD3f/FFJVE8f4fu0PaHrdkRhPpMiY6+HYqR4K/kWMSWxzwZklBN4zDroYNPI2z6jXcU1tOz4WUeMgsFg8/AWpWKmIeyIEIe5deAWjEJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbrnELc79cTTyl8mSzRLYhNT8sC3fwyI3hxFhzA9Hnk=;
 b=E9UO6GBxo/Q2pCRIolUhyA5uFDcO/sp9tb6gOD4AT9kLw8ULTWIH/CL8zKOLa4eSA2jpZ8yuHy/LrvBjuer6tsCkedtjF+hsHvkKKk1JPzulzhJ/N8aHeXR4zF6ay/mv9FnkMaQegRB9VuK2T2XRM7qUdyZwP/sP5gvHDbamJRdMA/OtjupZ1bSo3lvHU3CJrC7vFObzadwn7GqKZMAGMVZaaLQYz/Lhas2Xv/qUchyPFNX0g2xZTCjBlkfFgRz+wZ54LA+gCqyyzRD9Ic4oD/DZC2G1u9WqOQy/r5XMwSqh563oWY4/9fOOCGHctAs8iU0gnzZG4Sn5ux7A5o7XOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbrnELc79cTTyl8mSzRLYhNT8sC3fwyI3hxFhzA9Hnk=;
 b=6aQKWRsScIzuVfSjKGLTQmcWu2faaUoQTjPYQnoXbjADikL3RRfMuCtb+7+bEueP7Ju1ZQtGr5SRzkccgiOSR9+Bf2u1lx6JgSiN/uTZRIFqaXr4PunhZVt2DkzaPS4Oul+p270vI7sifIr3KEq2zWvjKegATFFw03WmEkHmmyU=
Received: from AM0PR07CA0006.eurprd07.prod.outlook.com (2603:10a6:208:ac::19)
 by DB4PR08MB8053.eurprd08.prod.outlook.com (2603:10a6:10:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 14:01:45 +0000
Received: from AM7EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:208:ac:cafe::6) by AM0PR07CA0006.outlook.office365.com
 (2603:10a6:208:ac::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.19 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT048.mail.protection.outlook.com (100.127.140.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Wed, 27 Sep 2023 14:01:45 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:36 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:35 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 04/20] arm64: disable trapping of POR_EL0 to EL2
Date: Wed, 27 Sep 2023 15:01:07 +0100
Message-ID: <20230927140123.5283-5-joey.gouly@arm.com>
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
	AM7EUR03FT048:EE_|DB4PR08MB8053:EE_|AM7EUR03FT050:EE_|AS4PR08MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: be56eb65-7f56-4bac-d553-08dbbf628109
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 114EbaRsOdDyRGPQNFCG/BIeVUDVOS+O42HUP9oLsTBUuJDfcdQTBiLyYE1fJ3wgMZgX7bsroDT1G7hEmf9SMxRWpD7yEEqGNzn+Ewa/69Vzd2/konOZdPO9ACP8oOhHfnz7YeNdkiS1XysRzCzdke2Tz33qy3cJyGMoZ0Guh7hOH03xseSFGb50yGHouyKJeZC2ibeG7UsFQrsiD8HE8m/Dkz+ymwG4R2cpLo3pXR4nregWDR0mk+Wmy42w3QUQAczyyHeFOs5y6CMowJLX6259JBIIBZMEWQBRCgaSYfbSree1z5gx4DsnQUuO0euNMupU0l0Fgf5O/QA8TyBd0sw5nhY8T6YJrygldatlziDb4rej0/tPMJo6L5nMOEAhBf48iue30OOu85kb9Ro1DnSODjxoJj4Etqsex6S6mEJguyChZ/at39mJfO7Tfj0ZS364USnhotImCHmsEKbuI2h+K4a3JuEsjs+AiedeJyI4r68HeJlIyveoQ5KrjZFyLwwkrDpUNZwDbuydWp0M6xUpW+9VFq+Tyw1wcG7nu/Ng1tTbeMzo9/vopxnjiU9L53fMZDq1Czc7cB4bKCoALsGZT89p6b9rMczn0IUCP+TLtiqZMsnx1RWzHOz6jStoEH5UA+uQxrs18F6bfam8QxM5tKTlLzMaRV8bJ2wccJwSXZ/V6JGsNoysCgZn9+wldRTMBasPdmrU6EaMDX5zuZb54DpNlUThMtPgkzvwU8wXFsoo2XOhgsP579bVcCJQ
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(82310400011)(36840700001)(46966006)(70206006)(40480700001)(54906003)(6916009)(70586007)(2906002)(316002)(7416002)(4326008)(41300700001)(19627235002)(44832011)(8676002)(8936002)(478600001)(1076003)(6666004)(36860700001)(5660300002)(47076005)(7696005)(83380400001)(426003)(356005)(86362001)(336012)(36756003)(2616005)(26005)(82740400003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8053
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM7EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c359938e-8340-4828-5fa0-08dbbf6248f0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r8NMV4uLiDsbD4kdSSAM1yk6QpgYeU0y5to2UpK6a0/IOSxxNiavQGJc3plQZmW/vDxN/ve0iaq4RmupssWL/9WoSaEyXLWet8AWe2x8HwAI4BjUsqcd+XByq/qwaHssMy6gcFiiAE/upqVK1f7vzzmXJsNe8yizBaAvb5whlk0Vz6l2fSyiwLm7A8fCJO3dOZ7oGO/LimLqZ4wr6CFbs901gtrH2Zo3Mv+5HU54SQo9Z1VYvu54Nb1wx4z+raQvsinOmkHZvmOVFT178dtVt8xR0Sgs+GbMnysShkiKffdQZkNiTMceaso0aowgoAaMlrsrb40o70fGIddN0/sVEidDocbAvPbQSZFEMJpF8pUxfZPdap5ysgl6iHShRAGPO0pQ90L5BgQxPRfy/KfgxgYQWWLPUj40Ym4K87eLlLFRr3qNGBXOVHZUJgNkM8uwfFOINoO+O3BNC6lzbJgjoOtHgautHsK9icQKVfeo2BQTB1FyGx0pUA7slev+1vRlyuRNU4Fl2G+zPqqmVmTZX4EJkBP94LD+vM6rDtGG8XKXnEKEO7nhbwY3cEj7P74AxHe3q18ktW+Pk98RnsKgciqPl5ooq4HpagfVfmkRi/3WDyx42GtU9GitLJV8WjopD8wz9nfDZgA5NU+McNE8TXsm5UzXJyktLvoeJyVQLHL45HipdKcjrpkoKEnLTTsd8s8wFWeQgo7dCxMU0ovJ/Sdb3O0p42o02utG0Bw8FI43NH0wUqfcLwceu4drR4LY
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(82310400011)(186009)(1800799009)(451199024)(46966006)(40470700004)(36840700001)(40460700003)(44832011)(7696005)(6666004)(70206006)(81166007)(2616005)(70586007)(54906003)(316002)(478600001)(86362001)(36860700001)(47076005)(19627235002)(426003)(336012)(82740400003)(1076003)(107886003)(83380400001)(26005)(5660300002)(40480700001)(41300700001)(36756003)(6862004)(4326008)(2906002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:03:19.5037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be56eb65-7f56-4bac-d553-08dbbf628109
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7530

Allow EL0 or EL1 to access POR_EL0 without being trapped to EL2.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index b7afaa026842..df5614be4b70 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -184,12 +184,20 @@
 .Lset_pie_fgt_\@:
 	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
 	ubfx	x1, x1, #ID_AA64MMFR3_EL1_S1PIE_SHIFT, #4
-	cbz	x1, .Lset_fgt_\@
+	cbz	x1, .Lset_poe_fgt_\@
 
 	/* Disable trapping of PIR_EL1 / PIRE0_EL1 */
 	orr	x0, x0, #HFGxTR_EL2_nPIR_EL1
 	orr	x0, x0, #HFGxTR_EL2_nPIRE0_EL1
 
+.Lset_poe_fgt_\@:
+	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
+	ubfx	x1, x1, #ID_AA64MMFR3_EL1_S1POE_SHIFT, #4
+	cbz	x1, .Lset_fgt_\@
+
+	/* Disable trapping of POR_EL0 */
+	orr	x0, x0, #HFGxTR_EL2_nPOR_EL0
+
 .Lset_fgt_\@:
 	msr_s	SYS_HFGRTR_EL2, x0
 	msr_s	SYS_HFGWTR_EL2, x0
-- 
2.25.1

