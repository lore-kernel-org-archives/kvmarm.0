Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11011009.outbound.protection.outlook.com [52.101.125.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39231D63C0
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 06:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.125.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750746586; cv=fail; b=H6xDDRdr/PtDjlmGAoQ+wBGbWSs2PHm9ULzdoGptLXyzgD/bh5+DwwHb0wQjotP79KTlr5DwBUIelGsyN6+Yw4PTrXrIx2N4ZxAnf+bss3Oayz8y8XlxC7pU4CwtYizajsHZBY7JcByRjniMrM6Yx5ua87B0BIJna6leawQCjfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750746586; c=relaxed/simple;
	bh=HYoYbgnAoNlW+KJG96NXhDTlMuSh957TkiTHTshNdyM=;
	h=Message-ID:To:From:Subject:Content-Type:Date:MIME-Version; b=t43GuhOgXy8HaiM1eAViXkPOzFb6qWCuzOofTjFkSwJ1RhQlbmgbr4QIDppV/oylcBSTI6+rs2sN350UvJxsJbfH2QjCmiV+z1d6oWvpr11N71nWN2tGMJ1KnVWU1oqw7Hmo+mLscHz/TKqHzcsNFTstw6YAT+vrWAok61CEvDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=JkAG7xF0; arc=fail smtp.client-ip=52.101.125.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="JkAG7xF0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uSFfyOtm4v99k6gVfFoSloQcbIlRMLjNc1gGJRHWcezNu6EvK70uadJNVC4ZSupoRvQ9RvkENRWvUzJehkL7iz7OwG0+jbXM97Ex7Wvfy9m/SdnEgNos+ZDq9SqBMRZi8rlkByEMuyl97JTbcPI9w5oGxFrTnelTZUd2xN2WYu79kCa7cDqaqB6vREaEJLwmUsRti9zxoKOVFWdglwMJuVkWxGG61p1Legjsyv42rzrGc5Ci9hrUvknsl1AkKvfZhWqhHWwa6JtcGskQpF8coxZR6a72H7MuKK3PlF5DJ6Ggra4vsrLc1DsB/afQrSc6MnUWmv7Qyv6u/ZA+RTPONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjw4w0+sgj0A6gmBQimBiMyPgBKQGRd6+TqRbBWGEGg=;
 b=O9svISlRt0X6sOLUNI5Ocp5z+VNm2RnJoZVQCBlOzI45wSjpaiIjAMjCryS8qu4H00or4ZE57hTrnh1tCCTqffu+cdKcJjrZ6yW3zpg6ZIAUG0/5v3bwHSk9b+Gl7R3P4oZiGvCsPyGruWhuIRqhdOtnEpYuodeBrRtAIlrT9zYD+cJWBtJCz5TIOyvet7fZ6yRAUt1cVzKPWfN+sJG306I5xwUbs1U12s0qP9QKFr7qMnTNMcsZ0l5ffkMl7AxCM4bNb4MQUzRxslBCZcls4fGi8k9fMtWhbXY5W0zOZATGZPUmkvQS44em7n/ALKfz/32bCFLD0ThquAVI0RTcaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjw4w0+sgj0A6gmBQimBiMyPgBKQGRd6+TqRbBWGEGg=;
 b=JkAG7xF0G9jYRx39BBTT7skPXKSuzxpsnVvoOw6gRDWx5Lxa2sQGxhUM68psfCyT+h2WQ4dukDbs19pMtpmzROGO1XHFrHOiyKVYoLOJvlhX6ObmaQ7YRFXjBrj2HSYRLke/a6YPRlO9v854IYjHPLjfzc532LcXw3v9+0pHY04=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11) by TY7PR01MB14554.jpnprd01.prod.outlook.com
 (2603:1096:405:241::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Tue, 24 Jun
 2025 06:29:41 +0000
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11]) by TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11%4]) with mapi id 15.20.8857.026; Tue, 24 Jun 2025
 06:29:41 +0000
Message-ID: <878qlhr6sr.wl-kuninori.morimoto.gx@renesas.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] arm64: kvm: sys_regs: use string choices helper
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 24 Jun 2025 06:29:40 +0000
X-ClientProxiedBy: TYCP286CA0119.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::18) To TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB10914:EE_|TY7PR01MB14554:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9f2bae-36a7-4e42-7073-08ddb2e88031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kq/HjvcWOQMYIOhIdkjIxWfaQzZLgjutcHh8b4guM5J8lUTHRuy8fAmMlB/c?=
 =?us-ascii?Q?mQgug8ohlxgAuGwYruthKWkCsKOudibzHJD85yp4puDa+4LFYaX6RPWpyEz1?=
 =?us-ascii?Q?COceyShywqSgVvDe/l2QfKGFoBkfo+kKGBasdZEsW5DJiVPKMAlEcc6fcqwE?=
 =?us-ascii?Q?UEu2Tgw26cOoRUCM+PLjnsu5349CbiJau5SHP4CS0/fgYtB240QzvEbahlpC?=
 =?us-ascii?Q?xf0j3pZi1CBMj3m9CjXOdbFJBskPdKCJH+TZua1MbQoJLvIjIadbxOxO0Lhr?=
 =?us-ascii?Q?F6UkQ8fvBh4DvSlGFkrZXRDbWaTOksTXqqMQzvaiPpRncz1cs6t+vItLevFN?=
 =?us-ascii?Q?HvUVKgxcaEX44sBTxNiC9IkOFBDPKFBF+bbxv5syGPgirezirzqg7traNKaL?=
 =?us-ascii?Q?bdMww0tWP+8nAz1yxlh84ohH3W/EYNp90kuXS+KvDTWQJu42fLJchSXGrdjy?=
 =?us-ascii?Q?DvmBBoM2KjOb4HdjppByZxFY5QWZwrE9udiPFdky0L/qzxjV1grtU6w2lHFh?=
 =?us-ascii?Q?cPF3QZI7gi/l8RXJc3eXKwxHHiTo5pmFwiLT2b68DuaJipTiPz30p7gnJCMW?=
 =?us-ascii?Q?ncWsHcNfq86ROaJmyvdtqE35Be81e7Wospl5O9elxOjJRbeZx+R8pER696m1?=
 =?us-ascii?Q?ZWFaBctUHsvpvjXNrQeBmg1TdPJ0UcEB3HB3SCIbx3d9egrFCpMlRgMKlMwi?=
 =?us-ascii?Q?hJYY98VaXNxPUKbulihF2asuRK09E19LFPLmen83Lv6drrDq8n5iUaiwu4oS?=
 =?us-ascii?Q?/Lhy/ASGcQY3oYsmn8f9WdTSqxKyEeeUrsDBJKgVwwJSSKIlfp7DPCf/3C+r?=
 =?us-ascii?Q?l+k08fhgfXkGDvDovShxXSM/kUqqBy9736y8SNGf80tsPfMYLuSLsNefCBcr?=
 =?us-ascii?Q?mzlmBktFR5MWn/1wwNo4VrCZvmgTQCjWtU286VIA4JVST67KMZfKI4LYgI+P?=
 =?us-ascii?Q?xkJqGhdFNcpn473xhAoPc+5ERIgYt/CPStIZdPkCMgW+WHIkbt2lZgohjULx?=
 =?us-ascii?Q?89SIt78cszu1qprq/CLxJ91dFvoXJPPcq7PO9+FEJawTBuWFpU+R/iEgWNF7?=
 =?us-ascii?Q?atEpRGZ7KoHwTF9CmeD8eSC50YfqPjiGsSPfQq6sJIvZgtEw2/++BiRlAZ3O?=
 =?us-ascii?Q?yc8/qevwFqJdZ0K4wnfXrN60vBDUD2ZIDO0wmRlaDm21M02M+NY5t+KqNg3x?=
 =?us-ascii?Q?Zl4MkTrcdkVLDOXDodhH53p9m0aysHUZl711RB1xckaRoHzlRtvshhUneOId?=
 =?us-ascii?Q?nhxFh2Y+VRdkSxdk7hA2b8iSVn+Lep/eth2pGM0vUEn9ZjVPvi+xwdGwwqB9?=
 =?us-ascii?Q?GZhFIOkNJqMdb/btaDDKP2291NhWpaaPoFbDFLI3FaJQJJCR0clopyZVN/gg?=
 =?us-ascii?Q?XlZbwfHNT8Kz82WvSUUtF9H9w8fZ0zZ1ATEe+8BXXWjh7imcKAlxJ7zKc9Cr?=
 =?us-ascii?Q?gcGTEj9zeNZywZdB+5t9CCiENzEVwPbAeESd3Y+biNhD57+4T3iFoA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10914.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ExE5APNXlfGrToAeDrFWFLkTpAo5g0jXWytC2bCzCIz9/yXcPMH7bYrO5DdX?=
 =?us-ascii?Q?qQj6BsnOrw2gLjK7ErVGLelRp512wo6NUPgpxahWlfofmbZLljwo0SLS7XnN?=
 =?us-ascii?Q?Py9Gugj6gVQnOYZX8KPvJhr1BYs7gKEhEn/fT1VREPq5opuIJg/DxOqgBlq7?=
 =?us-ascii?Q?HPZPXjl4DiGM7sXlusePFOCy7WD9kfvV6gbwr6ckBNB8gpfP/4WqHdpGBeuO?=
 =?us-ascii?Q?ddCEnWu/6sYd3I6JyLgPWGMA7LTgnII+JWtOOq48QezT3yRxJjqfVOLnKZyR?=
 =?us-ascii?Q?Lk2YunOVOa7SGXF5//FZBqlOCsJmB9dmFPqZfyTnVS/NXjp4Z663bRP3OZNq?=
 =?us-ascii?Q?X0EKx44dE2DrEB53QlcLB2h6dHptUxi5evkjdxDSZWhKCMMzHbTh/fLkXpCF?=
 =?us-ascii?Q?r7NEZyhoH0YFavsrQWX/nAr/+aWexXuueaAbIpGOqiAS5a7HdzRuOslBcSPK?=
 =?us-ascii?Q?On+JoGXt3C6jYqquIdnbUIbjUqKNrIeXM+m1+Gp4bP7riHmVe//2V4jHc3ae?=
 =?us-ascii?Q?DlCgquhtTeWTwoL1PpadYCtUfbISfyj4N65iwFEWzM5g6iG+gdmXnrBII2Ko?=
 =?us-ascii?Q?CWY6BfVeAltCq1d53hVEe/Q/ja/LfTppAfoN4g+AYdIl0Wkzq5RMJsj8bpWP?=
 =?us-ascii?Q?S4KXfkEP7g87zpCrCIG6mXWAdTGT9Exg5Zmv/MXv3zG0l1OVLZOr0/KkvE/p?=
 =?us-ascii?Q?TlnOZsW6lbGrs+05a2PU+rPQqljacYWKqjcahCoHMF6rvGPK4l9PeJDkDzQY?=
 =?us-ascii?Q?XILZcBzXiG0FZteNFC5psLJg6NBvcdjrcsN8ZiQwN8fi3m35YEiyEYotf1sM?=
 =?us-ascii?Q?LFycedi3R1ij6RgDT5QO7ClLljrm050XRizJkDh8+nqvC6hFRk+Dk7RN0gdv?=
 =?us-ascii?Q?Ykhs3rg+znEiGpx1BVcrkNN1nAV/W5fSfTMwPzRiNqn9CqErbV5CBU5jbair?=
 =?us-ascii?Q?wyRKrqULZYRlNLnk7QUa4E6995ByVANnQal3ZBQ4zRuQw0i9BbEifuguYawb?=
 =?us-ascii?Q?/tlYf7xVUPPWs13GOtvty2jEAD0oqxjVdrqmNFhuKGyHy6mWQOVxMvri25fJ?=
 =?us-ascii?Q?a/pqO2e5vmdMLogG87YfLFh9NLq1edMhD5unc7BNnJPdqdeolV24puX0c3wt?=
 =?us-ascii?Q?AROygMXdDIg/R0pi/2j9PzEeP5QuhKG4ZG05jqYZ2SD78qZvj6v+OZTPTy0C?=
 =?us-ascii?Q?lvH45N6tX/mUFHitksmQfGiCF+vw+Sq7YvA7I4qItUIQp0sLVqqNTNZbZVzX?=
 =?us-ascii?Q?6r6MnZTkGDyioXhfqHcuF5WUEFAns5fE+wO6xCvsiThEvRdEmVaDqBQA7QvK?=
 =?us-ascii?Q?kEnMFjfy/w0JNEOp1vEZjPYeFE9Fa6q4SFVPR287myn1mhcIPOQ8lrnP2AIQ?=
 =?us-ascii?Q?Lzu5Yof00yK0yA8F3ltUB0PCGj0XF3rmn2Db8ZQkMzwvsBob/y9pF6A0bXu3?=
 =?us-ascii?Q?dj26ZHwLFYg9rTVKDqfo6BC7IO9kxjGSTGv6YILCipBwIwCUg9Iyj4jC96u+?=
 =?us-ascii?Q?MWh+t4oQT80RVQB1DhPN9vsbD9Wn3TeIi46WBCyry9xzYgcjV9QDnJU5ZqSm?=
 =?us-ascii?Q?EhQQtppBcBrRhRUy7L/U3B1apnyj5HVzv3MlFS3sao79Z5aDCYRJeJ5xthcT?=
 =?us-ascii?Q?4Yn0CNWNTKzXF0nAEptMvaM=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9f2bae-36a7-4e42-7073-08ddb2e88031
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 06:29:41.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VrTcEEC9jCb6fywwHDWHzeBs4YSB36BS3va9t5Z2IES9yZwQEZ684Ihgc5yMXufMD4oXIgiDDuanXi0Sxmb2kavF4jf4C2KnOHMUilyI0t0bKGcWIf6lWomulEbmBRcv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY7PR01MB14554

We can use string choices helper, let's use it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 arch/arm64/kvm/sys_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..c131d6b0d35b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4475,7 +4475,7 @@ static bool kvm_esr_cp10_id_to_sys64(u64 esr, struct sys_reg_params *params)
 		return true;
 
 	kvm_pr_unimpl("Unhandled cp10 register %s: %u\n",
-		      params->is_write ? "write" : "read", reg_id);
+		      str_write_read(params->is_write), reg_id);
 	return false;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index ef97d9fc67cc..317abc490368 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -108,7 +108,7 @@ inline void print_sys_reg_msg(const struct sys_reg_params *p,
 	/* Look, we even formatted it for you to paste into the table! */
 	kvm_pr_unimpl("%pV { Op0(%2u), Op1(%2u), CRn(%2u), CRm(%2u), Op2(%2u), func_%s },\n",
 		      &(struct va_format){ fmt, &va },
-		      p->Op0, p->Op1, p->CRn, p->CRm, p->Op2, p->is_write ? "write" : "read");
+		      p->Op0, p->Op1, p->CRn, p->CRm, p->Op2, str_write_read(p->is_write));
 	va_end(va);
 }
 
-- 
2.43.0

