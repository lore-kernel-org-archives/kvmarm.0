Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2119.outbound.protection.outlook.com [40.107.237.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0ED2DFA58
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744732029; cv=fail; b=Zdw8hudCm+7LyDVCF45kjPj64O8mueB7a+BPtfMj6s0oprxp17rmsUmjL0gaKRlMjFvDwmFkEZS/uvyRxtzTCB3zWYv8fvQrrLxj79uzc/C1s/mwMP/ErGIJUVqI2IlhHbzp+ByyIqy0xqcXFRXqZoUkAj9Z4SuNlyKeqejYdTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744732029; c=relaxed/simple;
	bh=Agn1oRt56eyFkj/cv2y4NYCtgWLFPLPa1uOOFcmQfmU=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=q6+lL532M42CN01SXpz5fKJILgowMzpHNx6fYlxJgV9G3zNo/hOhQqUEE6IMhAakqW/H7mNjUFy1xizVSI5WSM/pqR7CaSYoCbhRv3FVhBp5rpdiwZ9No/dTmQrZI4upiuRTIKla4vWsnSQ/Kf/ytJA1Nyz8NZZavPHXVapGN2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=jO4Yf1d/; arc=fail smtp.client-ip=40.107.237.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="jO4Yf1d/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5Mlui/lIh71ziDI7etplN9yE+PzHh/RXLqOMrj1VOit5rk0e9gygNlJsX1AMjaagmaREN463vtilqX8dA0TH6qE6Efxq5/rOUtfXqOBAYYLi/2P1vX0qZ+5SZo2Uvp3z/z19YBwCkqq/VddwYG5BknTFmJUrTTImboAed997xKCgnNKjs8b4O301t0dHjfRk8LPxhWrP4kdw/GFnRsmnvwzwlmLUewAaQW6HkWkj8m8X7Jyxy1SelFNFLPlqcCgFgSLnqxBJ3U3P/bkEf5UIlL23NO611O75UMKZ32n+MdrJitEYm6gDT34LLw07YS5EKQuvO87rtk3pnUfHBnqFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4SHDrEGkBGVKxY18NN/v8RHYOOS0aKcHFwDmx85btM=;
 b=rIGrJN2KS4UC9DUVMDYHikoVheBaiQCe1TpQAOrS2MyDGvyqr+hbUxoalOnA2mUrc3ihN458ig9YFjjStYNi/zrX2s52xST3UhwMbnw3jE7dxDaNKM0okqLRTnN1ZHfZWB+kPN6+1JlSxCjQWFEYmDy+/GrkQ213CnWvohIhyU5SovpwxQYBGb/qKeznXlRe5YrS+uGp1mcRqUWZT09FFIwhND35HxTMI05e4nwRGd74tKHPxKyJdavvV/f3IgPpqxV4FjHf8txwU6sO1X9NWilKPxVrWVmtyHXA4ANe5qA2Ferw5EtFHX1dkidh6rYEypj8aZjWTScMPtms/Iv+5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4SHDrEGkBGVKxY18NN/v8RHYOOS0aKcHFwDmx85btM=;
 b=jO4Yf1d/GmWQeds5LfO5mIdJM9xliSl4TfRo6yB4sDv5bJ2SWgzCgek31u9rqV0rFXE/qlzpPLwkh2qI/ynimdA7YFapm/XZE6u3hn9KN4OE1BHxn4CrEhUlwJp6fWb7Tse0JfbuiSIgfQkv3dCE8hJrYnLE9X3/5e4nKgNqdU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 BL3PR01MB7099.prod.exchangelabs.com (2603:10b6:208:33a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.35; Tue, 15 Apr 2025 15:47:02 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 15:47:01 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: fix config.hcr used uninitialized in __kvm_at_s1e01_fast
Date: Tue, 15 Apr 2025 08:46:55 -0700
Message-ID: <20250415154656.1698522-1-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.48.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:930:16::12) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|BL3PR01MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0f4995-75dd-414a-1a76-08dd7c34c35d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|52116014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6hjLCTU86keVn0SeEdQzkPZVUD+3Rm+sHfwaXxIxaqdm4WTc0YvW3WcEpnf5?=
 =?us-ascii?Q?x9q15/6cFgVjrF8UUKowU5Pkhp6YJjuKaqctPRWBGA8aiWeTqsozhwkyg+dK?=
 =?us-ascii?Q?QkJgfa8XEm8kIVllTo8Q8hAys25CqLkMsmqunB1UCkq8GwPYkbgIbEnYLlem?=
 =?us-ascii?Q?QR/znmbRRHQwfJZhMcJNx9gYYyamOgj7VM/EQjizJIGpIv8IDUbnf+0LgyPY?=
 =?us-ascii?Q?VsVw4NBwpGv2VWf1kPlwWzpYubtLp1f9Ng/ehBnG8+SNpXXvobtAdv/PBIXR?=
 =?us-ascii?Q?QbaBjZB5QL6XsATCvZzN13Ty9BAJH2OcjgtKIx+/JjFdx7GNmReyQqOlhnCJ?=
 =?us-ascii?Q?lMQEF0c+qhoDZI7DJXMTZi0PgfFM8pD/kQTZJ8n+oZX6uxq+jaypcPHubTUy?=
 =?us-ascii?Q?Em3tfla+pnAtm766DBPryiI1zLE4kDVTUrBu+nfyaGYvNDfqUm5rFZvkrcZM?=
 =?us-ascii?Q?b71vI9NbDXX6YQOOVwyFwGuaqPJn7z/MJQDJZHU9AqKzaxkU/0P8kLz2MHZ2?=
 =?us-ascii?Q?cxBa/LiSr9jK7CQ8iG49Ck94nYVwoDjA7gz0zQSBSqs1CNBfTtuAUE+NXLT5?=
 =?us-ascii?Q?WWDdrnDPESKD8RLJc0PTpSkb3F0Ab0L2+7f3J5nfHH6LfVybWdI8qf91w7Tw?=
 =?us-ascii?Q?gtE2aC+7oew8X5MEyKXSremekRNjQ8noaJ3Sa1STvNclcTBLXXg+9YdOIH/+?=
 =?us-ascii?Q?00NJwJLPazsXOgdCzWXsdcioQ7zTDPWfopzPvgrZn92naFUHuNnDqpT2cfQF?=
 =?us-ascii?Q?QbCZhJayEkPRQTaZBcxRhfYnMAQBQwlfJjmVlqkb5uY6oDA/7FYsPNQzIhR3?=
 =?us-ascii?Q?OFe9cBNIpsdi5X9RwXuH4mV2/jUb9AIhZUUe8Vlvris5HyEhoilvDOJs/vI4?=
 =?us-ascii?Q?hqRz2kE12c6ofJdR/CMVHRDB9YZt6+JTUEpwy9DtvhySRvWTk/kMaxDLkUox?=
 =?us-ascii?Q?hySRTCFHb7hUwo+l/Rg6d9GQnk+7ha58AT0FJ1cwvXFb2O73ujd5mQ5kfMSr?=
 =?us-ascii?Q?dOOAtlj1xIvZ360CMFyOC8uiz8dVgRPeZu7jxCLrpZ03y3Yw09XkjjpXZjVL?=
 =?us-ascii?Q?jjYJEAwQq7P6oyVpntlGikdzwXRTBdiCcBMGu0vGV4/XpGxdREiC7gDvyOOH?=
 =?us-ascii?Q?GPOhrEdeeWJKOM2ds4qI/aBuF56E46SKffjumCFscwHvQKuHl+wPqtDqQ0JS?=
 =?us-ascii?Q?bs4uATXKsiesEo/sp8vf/gEWXQMuDvk7V5Uov+6rq2VLs67bLX7Mn2N7qaIc?=
 =?us-ascii?Q?gC1ut/vmuwpw5RnPsl2zrFsHqFaJ2pPLkPw86qfblntgF3iVGHSr+PkyiAxf?=
 =?us-ascii?Q?ZLn3nu5G7rE9djnU2tDajxB0AvpodRfwplxDhDs/0jZ4capOnVPgk1uD6SZ+?=
 =?us-ascii?Q?kjOAVj9PzFnLtO/8xyKhXOv4M8p6yunD2wKSI8Q7Wc5nIOn+UWRGlT5l2E63?=
 =?us-ascii?Q?jIjtsTZsnT/0LEk3vsZjE9ZIdr43efTUKlmGw0Apd/cQVGYE6cHeImWo+jjV?=
 =?us-ascii?Q?7NmIhLG9f6bTQ2E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(52116014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7HDZeKti7Ox48jhp0dBShmeeRE84rA+dBiIvTqgPo9riz58+4/UFULIGWsQ9?=
 =?us-ascii?Q?Cpp63Q1zWiQqyOoVisnH669dyRdLqtxmChP0iS+dQ9/TmkoMuZPCHSMa0Tuk?=
 =?us-ascii?Q?Wx0FIKzIGHeQze1Mhe1S17YXnJHrh+78eSWnwixTFpGLvBaH+ABP/gBQ9E/+?=
 =?us-ascii?Q?UWiN7mrYUJf4PNyqIaI76p9wNf0HsEDBcElnjnJ1mRykOZKXy4q+hEcM8hGL?=
 =?us-ascii?Q?KQ7Tfpe8AOhVgVJt6BYXNVdCV1LiGXpcWokkOMwUmAyWkHYgaSeoIGHx5RWh?=
 =?us-ascii?Q?Cw7h30+59jn9Z/OOdSB2C1jxtvtFhSdDv9iBD3gzGShx3ANs13F8i96ve9Dp?=
 =?us-ascii?Q?xPFwm5UWkKkcrF0J4C3hs97K4gYRWtEO4gTnmrpmSts1/zMRB6ZGz73AVmna?=
 =?us-ascii?Q?k9tRA9v/r4XT9RbhcSg0z2ci+DswVu5aJh/uSx2Gd+vyZiTsfjBZ5VmYahaV?=
 =?us-ascii?Q?1y19F1b43AHWBC7PBryTlvhwOJQSo3Ts4P8JMR+0CVPwXIZhmiAz7pWIIhyf?=
 =?us-ascii?Q?WudwFkkde0I3zc25G89/8t7ySMZcamaC5kVpvLcfk2LMb1rU/RYoKX2grl+u?=
 =?us-ascii?Q?YeVGBYpfZ7iBcKR+d3KUOEm3KNU6SUwVHfdwTrqwQGMI8HadBWs5onyn/V1F?=
 =?us-ascii?Q?DqXmiKImDj1N0ZEtPtfVHGH3IFdeuRYVFyOQzJ8ecJqhWiLbbQPQjyTvNneG?=
 =?us-ascii?Q?W5N6cBIW3pX84rbMeudtNlOZgehkhW7jW98GBe0PAVzlINvw6rfs/JftzbW7?=
 =?us-ascii?Q?sMHglXrY2i5O3O75b0+Cjva1Ss/QTQOn6UuXXlKvsL5VHPMsAmMhwOEI8kOi?=
 =?us-ascii?Q?21iFGitN8hEnLmHahuD/OT33dbQIQzyKjeUWA/PzYTs0VT2AaTgFsXTi2ayK?=
 =?us-ascii?Q?xVIHQ3HfjltpGeumJMma3O6ImKJmutAQvcoCYBTN6VuPELEZBKIJyyKMIbfM?=
 =?us-ascii?Q?mpnJbj2heoKNdqzM7r0AyZZCZOXiFE4ati2pJ4hCj2CgWpXYVGPU2jVAxdL2?=
 =?us-ascii?Q?mBT/kJnl+yzWMIY2LBDImb5U8zA59b5yfUEvBI0i7ISaHawopFh9ImQe5iGj?=
 =?us-ascii?Q?hYytFBZp21vcjI2DL/PGoPIu7VVRG6+6iPiRDplankePorT1cpAlNslAvttB?=
 =?us-ascii?Q?pm2gwd24/4qd6zAqViIAMbQ3fGIF4z3tSUISXGTGxOeivk5I63xJdih+kk+j?=
 =?us-ascii?Q?+d0g3YIzpWcKDzJDs5qw42DGwz4qYFu5xtlGQrwFLuyyK4CBLGwAlby//Dhn?=
 =?us-ascii?Q?E3zOpaV8iGocFWAIAaYxJTspOOX62pWKbg0IUMF9vMIKy0sFrLmDLaMBJ/Ut?=
 =?us-ascii?Q?M/kISQrE0K03f8+kZjftbyM1fPb5rJWrURmFnhnP74MFKKxWM1r01rOS3F3l?=
 =?us-ascii?Q?iPm4TCrvqd2IfQ3iGjgcEb/QCyhPR1RzyIkmatD97bHjEvV9zn1dSd8lZ7uK?=
 =?us-ascii?Q?mbwyu6zk3aBMZ4g9LX8SDwRSQbQNvq/i+7aDIXbMhza7gWymFS072bcqQNAZ?=
 =?us-ascii?Q?bAexlbD49aklVc6R5xGl1pbHjQAEE1rRYhT9IFNcBuxBfdsWLScumWEbs9V7?=
 =?us-ascii?Q?5amyoMIpRrlRBh4Gsmp6NvGjeXJuZUQKdsqmN43tloxcMYHxz4wJlxjckH5p?=
 =?us-ascii?Q?0VBpYhtd4MLeaTmbIfjhZmI=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0f4995-75dd-414a-1a76-08dd7c34c35d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 15:47:01.6630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHy3bw3QdQlpNAgs6l7UMHqK4q6GIE4yO27KzhrPNPpqg4BQL+lo3e9+MX+2BC3j4YKbsWTB7LwNnvDjjGzNZ54/bEMN7DmKuDMAph8G5UFK29uEDfvHpIahSu2t0txc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB7099

In the skip_mmu_switch case, config.hcr was used uninitialized. On my
machine that caused garbage to be written to HCR_EL2 and then the CPU
got stuck at the synchronous exception handler. Also, the restore of
HCR_EL2 was missing at the end of the function in the same case.

In skip_mmu_switch case, initialize config.hcr with HCR_HOST_VHE_FLAGS.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
---
 arch/arm64/kvm/at.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f74a66ce3064b..ff4b06ce661af 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1233,8 +1233,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 * the right one (as we trapped from vEL2). If not, save the
 	 * full MMU context.
 	 */
-	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
+		config.hcr = read_sysreg(hcr_el2);
 		goto skip_mmu_switch;
+	}
 
 	/*
 	 * Obtaining the S2 MMU for a L2 is horribly racy, and we may not
@@ -1299,7 +1301,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	if (!fail)
 		par = read_sysreg_par();
 
-	if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
+		write_sysreg(config.hcr, hcr_el2);
+	else
 		__mmu_config_restore(&config);
 
 	return par;
-- 
2.48.1

