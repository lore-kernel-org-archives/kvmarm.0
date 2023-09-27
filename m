Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BC1F61C
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTujE6C4o9fP3xJ3TBrlqjM0PbAdtvHNtHcbgQKobec=;
 b=I4OShfGTjYEhuIIeUH7XOVnlRvMTsACqRxV/ODYoDPY28UIpgKtvQ/MJss3Sl2VWyjD4GKTsz5CJaMwViDtEoU4iTx+Jc8y0XXNWvmnrwTSEk/1KCTo+Geih6MYCyDgXphU0bM69aZ3zxbofpyMPT47MGC0wdvnIslaJUmRcXmM=
Received: from DUZPR01CA0140.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::23) by AM9PR08MB6306.eurprd08.prod.outlook.com
 (2603:10a6:20b:2d6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Wed, 27 Sep
 2023 14:09:21 +0000
Received: from DBAEUR03FT062.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4bd:cafe::b0) by DUZPR01CA0140.outlook.office365.com
 (2603:10a6:10:4bd::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.35 via Frontend
 Transport; Wed, 27 Sep 2023 14:09:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT062.mail.protection.outlook.com (100.127.142.64) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Wed, 27 Sep 2023 14:09:21 +0000
Received: ("Tessian outbound fdf44c93bd44:v211"); Wed, 27 Sep 2023 14:09:21 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5194c23cd01585db
X-CR-MTA-TID: 64aa7808
Received: from 76efac2a2930.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id E0103E0C-B819-4DFB-A3EF-E6E3CBA8C1E1.1;
	Wed, 27 Sep 2023 14:01:49 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 76efac2a2930.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 27 Sep 2023 14:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFy1futKXqxz/S8Vg45hRUNQYgYCWa7DtG18WDbTyhCasylGq0vNqpjUB/5BaKw4StGlGqjeOy6WGqf/cOeaUcAzO8hLMgd9B88S46DZ7baK5iL9HeiYJ1XJu9D3BA+q8Gl6qdYMJB8JwY5jyq7myUt2QZJr0nlUenwekCy/qUwStOM7pPiG4AurTKTSrrbhLO510d1N7i36tKcAcj03OTNzwJ+8nEe4+IReONh6TumtqXMQuQZSHe/TpYYNhHEOvIQ7IFG3Uzr4qCCDL837+CvQCrGSkVV60sMzDQFTUY7K+g42jBDz0gMf8rJx/U4qnwr2tp+YC2XDlDfNc/rcpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTujE6C4o9fP3xJ3TBrlqjM0PbAdtvHNtHcbgQKobec=;
 b=YAEFnByvEGmdQ9wWoj7OCFXkcko3WAYc0NXuQwFNJ7epWZ/tkhHucNgxjZAIOYGubRFRqmZm6tL+pXX+zajZdQ3SMB9NX0+GKfVeM97Mhpm879S015ts5jv3Y8pxDiDBI7IWf8vB0QZdMAhmu/ZeL4B+dwjW0xG596XBGz3+2ZI1cNPEBB+foP0t1N6kHBO807wpUDXhgsrWeXmiGJ2hZoL+fgcAQlom0rtCgvI9CsIbxTLJOuUQE/oG3Kk/yzvVKMQHk+BNlQ9txao6XT0CbdQ5CATDDCOlkrKtf58BLMY/DBSyn02v8qIU2dI4b4GdjiujvltfFqBNgEbfBILshw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTujE6C4o9fP3xJ3TBrlqjM0PbAdtvHNtHcbgQKobec=;
 b=I4OShfGTjYEhuIIeUH7XOVnlRvMTsACqRxV/ODYoDPY28UIpgKtvQ/MJss3Sl2VWyjD4GKTsz5CJaMwViDtEoU4iTx+Jc8y0XXNWvmnrwTSEk/1KCTo+Geih6MYCyDgXphU0bM69aZ3zxbofpyMPT47MGC0wdvnIslaJUmRcXmM=
Received: from AS9PR07CA0050.eurprd07.prod.outlook.com (2603:10a6:20b:46b::8)
 by PAXPR08MB6509.eurprd08.prod.outlook.com (2603:10a6:102:12e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.33; Wed, 27 Sep
 2023 14:01:46 +0000
Received: from AM7EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:46b:cafe::2) by AS9PR07CA0050.outlook.office365.com
 (2603:10a6:20b:46b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT007.mail.protection.outlook.com (100.127.140.242) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Wed, 27 Sep 2023 14:01:45 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:37 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 27 Sep
 2023 14:01:36 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.27 via Frontend
 Transport; Wed, 27 Sep 2023 14:01:36 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <nd@arm.com>, <akpm@linux-foundation.org>, <aneesh.kumar@linux.ibm.com>,
	<catalin.marinas@arm.com>, <dave.hansen@linux.intel.com>,
	<joey.gouly@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<shuah@kernel.org>, <will@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v1 05/20] arm64: context switch POR_EL0 register
Date: Wed, 27 Sep 2023 15:01:08 +0100
Message-ID: <20230927140123.5283-6-joey.gouly@arm.com>
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
	AM7EUR03FT007:EE_|PAXPR08MB6509:EE_|DBAEUR03FT062:EE_|AM9PR08MB6306:EE_
X-MS-Office365-Filtering-Correlation-Id: 79680418-fb10-4081-d2ff-08dbbf635896
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 kDcq2hUktXztxGEKJqlbLMdAt+6vkr+0IH1NXK5/eTeOohFtmudmma609vrOf5Fx3I1S51cTxk5FCqtIh9azBDziZTb48ZRnBAQNgu4vwf9NoDgt5j7G0AEon1KyK6MUCvaYvnFqKfXsywwFqvnYea0snQ2PBnm6LmEbGQssv82R+4K6jsy7sXJYPdM9qcy3+NjwjTNHfRqs/U9M1GXY2M4rOuIK0LH+E6T1tQVBlEPH7gLVD7K7wVvNx4oRxGXmyY0h1yV4Xw2db66KzvuwW/94P0KZsanmfCXGabU2C08oonTz3eQjCSl95+DBY+GBAnCKXbpFI0oO3ovyTjNk37Loz3zS+xkUMciXuFnvMYlxxshsElB0K7yPn9onKhlaHfk2UgLlG1qhtI2oacohhjYKkLkT/x8kTmoq32RFaNcbv4TnoxAt/X583p8pfwizkU9bjuAUsO0iBwwXYpO7gx4/Tpr9dOG5GbI5zQjgsnJp6qUgcPq0OY619iI7Sw8Ly/iYj55yI5j89JKnckzpBf0jVFOEWcG8+EmE7NkVhcOo3Uzax20Ja7GoGUaAiG4zeV693H/guByWo6FbwyGN6ngDeS7L8BEKAE8MaiTzUYdb0GHkiWkU/zG6qsAJ4K+ws206ANXwGv8lFqFLOhEQG9KecrUIWi2B5C5xAC5MKmRIWIpH49H5pzyYmLf3ujCc7y2AaIMQb1ikDJ0FdoXqt50C1F4IoDpBjcqSTIyycUJN2WVDJGQO0YAr3Ap/0/KalY4gHbBLW8wXRhrFqbYpXg==
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(136003)(396003)(230922051799003)(82310400011)(1800799009)(451199024)(186009)(46966006)(36840700001)(40470700004)(2616005)(82740400003)(44832011)(47076005)(356005)(7696005)(5660300002)(81166007)(6666004)(26005)(41300700001)(36756003)(7416002)(478600001)(70206006)(70586007)(36860700001)(86362001)(2906002)(83380400001)(1076003)(6916009)(316002)(40460700003)(426003)(336012)(8936002)(40480700001)(54906003)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6509
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT062.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	621c8472-b200-4e10-387b-08dbbf624935
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4vIWgK28hC89hxW4bmvTHYruWjTSsR358MeAx5i4GC2bNx7GYsEd1mmEpLCQerNvNd8cxE5NF06PT3mUcyqt3/J/iLm5+Cg8Pdjyl+kAxekAxIhlUo1oYaus88c2Mf1j3lQvC1HFi3ys5+UpVlZ7BJoupzjEuxzFO1rNTCDwIUuMuK5GXKy/iavSbgy9KTYL3M6FpVJf8dtd5vRsmdrKMogka0eQz24ArwsrEHOgmZYOotImAcu1VYoY7r/Za3RO1XjRUseEioPP+TshnAfy67zTHfaA32iwG3lkD4Wh86iBfb02kCt9cgxMehKNvD3TLA+PxqG/hpn9HhGlraNN7FtWVvqEnz+q/NzXrMmapZZNgIJQZ8R/VgAZDqa7eJOaNf5w14GQr45OhbmWdmCJuqZdwxkm5wwNdxtAaBiTXbbJjD6GURoN1blZRgyDfXp5lkVV5N4dTX+SQHdAkriWYMuAvr1XyraO+vrXxu+QICaWcdqX5N4Qs08h6BqBjS071NwWcN27c5wv/zDb5+9bDugVt+3FAO75Hf1tOUy3BS6RXpK3Hagxj3AjAQvc4rR8c+lBL8gVVuGrHrnqeoUJycrPo8VYYVWjYpvM48sKXLiwCpHU7GvYsMil48wsly/hy6dVk7z6ldlakgEULPiRTaYof8Qf+DoPILIrt7siWuJCNpFzTpJicMAxAx5g/w5dJaTpIIQ9tcR3NaWElRReqhvHe9nawaTtkfVFe6fsQWWTazMQaSLLJPlCvD1fa9Xs
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(396003)(376002)(230922051799003)(451199024)(186009)(82310400011)(1800799009)(46966006)(36840700001)(40470700004)(40480700001)(81166007)(7696005)(82740400003)(26005)(1076003)(40460700003)(2616005)(107886003)(44832011)(5660300002)(4326008)(6862004)(8676002)(8936002)(86362001)(2906002)(36756003)(316002)(41300700001)(70206006)(70586007)(54906003)(6666004)(478600001)(47076005)(36860700001)(426003)(83380400001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 14:09:21.1691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79680418-fb10-4081-d2ff-08dbbf635896
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT062.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6306

POR_EL0 is a register that can be modified by userspace directly,
so it must be context switched.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/include/asm/sysreg.h    |  3 +++
 arch/arm64/kernel/process.c        | 16 ++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index e5bc54522e71..b3ad719c2d0c 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -179,6 +179,7 @@ struct thread_struct {
 	u64			sctlr_user;
 	u64			svcr;
 	u64			tpidr2_el0;
+	u64			por_el0;
 };
 
 static inline unsigned int thread_get_vl(struct thread_struct *thread,
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index cc2d61fd45c3..0dc8ee423af4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1007,6 +1007,9 @@
 #define POE_RXW		UL(0x7)
 #define POE_MASK	UL(0xf)
 
+/* Initial value for Permission Overlay Extension for EL0 */
+#define POR_EL0_INIT	UL(0x7)
+
 #define ARM64_FEATURE_FIELD_BITS	4
 
 /* Defined for compatibility only, do not add new users. */
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0fcc4eb1a7ab..d33f9717bfcd 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -271,12 +271,19 @@ static void flush_tagged_addr_state(void)
 		clear_thread_flag(TIF_TAGGED_ADDR);
 }
 
+static void flush_poe(void)
+{
+	if (cpus_have_final_cap(ARM64_HAS_S1POE))
+		write_sysreg_s(POR_EL0_INIT, SYS_POR_EL0);
+}
+
 void flush_thread(void)
 {
 	fpsimd_flush_thread();
 	tls_thread_flush();
 	flush_ptrace_hw_breakpoint(current);
 	flush_tagged_addr_state();
+	flush_poe();
 }
 
 void arch_release_task_struct(struct task_struct *tsk)
@@ -498,6 +505,14 @@ static void erratum_1418040_new_exec(void)
 	preempt_enable();
 }
 
+static void permission_overlay_switch(struct task_struct *next)
+{
+	if (alternative_has_cap_unlikely(ARM64_HAS_S1POE)) {
+		current->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);
+		write_sysreg_s(next->thread.por_el0, SYS_POR_EL0);
+	}
+}
+
 /*
  * __switch_to() checks current->thread.sctlr_user as an optimisation. Therefore
  * this function must be called with preemption disabled and the update to
@@ -533,6 +548,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	ssbs_thread_switch(next);
 	erratum_1418040_thread_switch(next);
 	ptrauth_thread_switch_user(next);
+	permission_overlay_switch(next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
-- 
2.25.1

