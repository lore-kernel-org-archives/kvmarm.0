Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010068.outbound.protection.outlook.com [52.101.229.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B4417AE1D
	for <kvmarm@lists.linux.dev>; Fri, 18 Jul 2025 01:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752803431; cv=fail; b=R7v9o81PGqMGkwe0UcKH/tflC+IZ+I/KayrQXDsHnrLM3VPi379A8O6Ccjp2yYIgLlK0jelVS9/rfLpVvl1HvAFqjA7qeN/MLWNB05Yf6zp3QmVn/5TDKtlSrYIpRcZoOepu57ydY2o+cwEOqKfH9go5CXUZbzInreT/nJ/BUI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752803431; c=relaxed/simple;
	bh=HYoYbgnAoNlW+KJG96NXhDTlMuSh957TkiTHTshNdyM=;
	h=Message-ID:To:From:Subject:Content-Type:Date:MIME-Version; b=Az04pJm+dq4q4bYf6iwX7fXNXjkPfRL1bGjjwGpbjP0SPd/uvmxpqcGrUh3sVI51L7wZOZLqUlHsJyJyp/vncuRMlxtxi3GCFiI3jXvOVmHcICzo1739RRCiIIDAjE6q8rB4kbD53Vc/aZxEUAAIPKE30FpydFrZQDikNmENNGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=jn3eXHJ5; arc=fail smtp.client-ip=52.101.229.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="jn3eXHJ5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrQrbMtuJ8YFTOLg2SagCjTATRVDNLTTwRBzOcUZXJCWsVHKo6kf/A7X8joFO3OoiETSLKYPmji+NA5aa9zlUjPWatPcGcP+Ex1jNoytzcPwikcRyY62uuLE/yeBbpBdHC0hcm59knEIQ0XjIrJajvgpHStP8P4VhdkgROb4qjbM1cOI8Z6HqZzJLGZsQJ8myDNvjEYKRcj4aDJEAjX5sBjt8ykZAVbg7fh0MeDbMMeSL9dIDEG65JgmM6EpopsfNBhGebqdDHlzQSA0upA6MZSOPDohE/xUM+JDbrlljnDtvXLeFU6JM5EwmCaBfj58pnPNRLT/r3o9kyjREYF5tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjw4w0+sgj0A6gmBQimBiMyPgBKQGRd6+TqRbBWGEGg=;
 b=RBAV+AX+lyu/AH+RFNPEhia9KG7wT9YV7+XpxqSK6QNN3AyoXg1fi6EiNO0/WqelP5Uiku/W45kTEwubKnshWd9JfAw6VCGgi7T8m2PrFfZLCwIbvPH1CcvZLab/lxUIHhR+VNE7uhNVe4oBfpZrxzpu3GQNiQmv4D+YVWe9SVCW5x8+kH5/cuqoGnrBJKhS9I1Rutf6l33onAlNPQydwSc+HKWeYPHAntvvqc7u+eq3hN34kLRg9g39dGxEljLZI1j5sh1JuGJDA8uszM6eXygZpZRGwWrawNolwBZe+8EyUNnuR+pGaV9h9WxsbuZgxUCH5vyZJKQFFY1lbuxZ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjw4w0+sgj0A6gmBQimBiMyPgBKQGRd6+TqRbBWGEGg=;
 b=jn3eXHJ5xa13BKTDqF7ImpEWpvCLaQf1F0ii668fhM5uDv9RzhwzJFt0s8Oj4kDqnviwHfaJ0yBUC1x/61ZX0WOjraSy+pXfZp7XK/mKK5d1g7W95zCpUB/57U41NADXGwwDGjgj5EU0EuU7zfNIdBIR/sznc3rMLb/V1myl/Hw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11) by TYRPR01MB12514.jpnprd01.prod.outlook.com
 (2603:1096:405:1aa::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Fri, 18 Jul
 2025 01:50:25 +0000
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11]) by TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11%5]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 01:50:24 +0000
Message-ID: <87pldy5ktb.wl-kuninori.morimoto.gx@renesas.com>
To: rmk+kernel@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [resend][PATCH 1/2] arm64: kvm: sys_regs: use string choices helper
Content-Type: text/plain; charset=US-ASCII
Date: Fri, 18 Jul 2025 01:50:24 +0000
X-ClientProxiedBy: TYCP301CA0034.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:380::14) To TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB10914:EE_|TYRPR01MB12514:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a7663da-4f38-4c1f-a933-08ddc59d7698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|7416014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ApH34bCezLOAaB80/eaVHVPXNn6eCMBrPpUZp0ZBJd4Pha37eJ7OZuZrnfkf?=
 =?us-ascii?Q?Xy/CoAOVpqDpgOzYNyyWcAe220oFOTOu5wmsbBSpq9KrohP4dapSYoZoKCI+?=
 =?us-ascii?Q?VPccvjUBsZAi2+YMlpT4cUoJznIysPbed2ruM0kajjhjPhrmYF2B1DPc35+V?=
 =?us-ascii?Q?6tZ//TjIGg0NjHJFsCBSbph1xad2Tyk9rG22wUQibiFlDdUwqD4Xa+MiyPmc?=
 =?us-ascii?Q?8DyCcKXdBsitg9o6xPFE390eEb9GHaUnDDQ2d3iNNB1Kv5u6X6cQVzcnGMRc?=
 =?us-ascii?Q?cvBQjxmXwESsv88+zCswLys/eqLMBn7nt0VoFv2UtLwZ7bPQHb1m4NvkSgm+?=
 =?us-ascii?Q?uAt8kfwVtOyFGaH8V4YZsT3hTWdoF1UYi+hm3gqPOSlCwc3VfSEfsEiqHXSe?=
 =?us-ascii?Q?fl6yqEpRSvjZqz4Lvtko2nJUPWaxp/4HHJDdK28c5paikHdIoeHFsElvLDqc?=
 =?us-ascii?Q?/y4h6X1TUCSPQwjmWNuwhtBoGsE5HNZYOWUQaC/XyJRb5Biini0vi/+oTssL?=
 =?us-ascii?Q?QF8RqTHTyTqGmTC3U63ABmmwOuRiXXegzWbnSl3jZ58rM27N//laj3ih6IC8?=
 =?us-ascii?Q?f/C1P/a3A3QjF4Q5GkqWFglGPSLjy3RgVFPCJ+FVse5UjsdQ8FmiVI+4jnfd?=
 =?us-ascii?Q?zcZto1/46PjCiZDzP/oW141lCNPLPok7GnrD/l+8TlNfRm8XVrWVBTJZzjDG?=
 =?us-ascii?Q?K/yjt3VMfBzDkvq/pA3kTIHHAJ4tQa/6PTdIDLaBh4bXgMH0kJUCp9rOoVZm?=
 =?us-ascii?Q?j9yCl7yqq4PYV8f3opB+sQRZrfgeYsGUvzeyyjSg2mGlMMUY9eCcLiMzvW7s?=
 =?us-ascii?Q?BCgvRjyqjzBFexyPZi51ezyzdpU4+wNaE3uKfch1/YN2va0xYI1KMqaczsWT?=
 =?us-ascii?Q?fYIrG0DcW2Sh0XdwlBS5cNUFbdUaYcEp5YMsQHhRKUy485v07dPa2LWg54g0?=
 =?us-ascii?Q?FyapMxiyjJxJJsumma2x/u3PhIHvVLPnEaT2qhdddCPxLM3SrWDBi9dJ05kv?=
 =?us-ascii?Q?B1nK4G3VKwE/tQnPiyBzo9y0qGCmjRNISRrCH0V23hEBr/EcNPT/zb4uklMx?=
 =?us-ascii?Q?qvBrw2In8NN2RKsRZbI0/ckWOSzcxxbRAtyUYVoqc8CkS7JZpnM348inu3Nc?=
 =?us-ascii?Q?4KHCE5DQe2w0ZOeGiWYkHyjlyEOQpw0/hduvyXBdyDRD5ExO1iVgpMTa0FRf?=
 =?us-ascii?Q?qyrrV1SDGpqI3NlyHiNrrIJ47e34u6I8CyNWREIoeCnZ16duR8wP5Alzz5Rf?=
 =?us-ascii?Q?xUn8O3pPbB8BmbbV6zzXXeNpMMrY9VsQ1+wFOCeGRtYJnzYOCYhCGDVlE7VU?=
 =?us-ascii?Q?yfm4bl0grld544az3oH3q6vsYVg2WQ0kQAM1PdaNhg7o1wu126ZL0gMdNA/f?=
 =?us-ascii?Q?4ewXbtbnE/OT7XMqTHSaC+/ca53VM9P9qd91+vpDCdRf8hfNV5Ji+96Lni86?=
 =?us-ascii?Q?dz3Q4K88AjMyHtzdH4TBmzha7FI5VZeK8F0cYmj7q9BB/KUT5+NIwE+WbJ39?=
 =?us-ascii?Q?w7+kxhq9dT7YnBs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10914.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(7416014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FGx8TXemMi2f2nf9o0wKKz8grGFFDbbN82uRVAbZnqqEvx8mzJ0AHDQIEJew?=
 =?us-ascii?Q?815yvptcu1T6VX+QD7aKZSFPChhxwiy4bGmgEyd2tH+/yqpIkMBHxtxHkIBq?=
 =?us-ascii?Q?q72F26fQnuHFNHHsTLIn5CZXEOruSH8KHQ4eBzZIdI0FAJqzZ163cxvxB1No?=
 =?us-ascii?Q?A7BWOW21S0fLcqOmhTBhZW5CiZPbm25qd2EBiJkeSNvWf4WDCfqqJ2hCAV7e?=
 =?us-ascii?Q?m/AhnWMcjxWHKpu1rPa+d9WzlO7RmhuUFuWVrzmQ/WOXMau3Z0bUQ/Sgtc+6?=
 =?us-ascii?Q?V8uGiCKtfbELtFgGRGGXayuKwVbBmnmMEXMOJC1EIgatu2bRoIBDu8ZZbbx5?=
 =?us-ascii?Q?rKi61ReCr//XHfNKmQfKDzXlbPFOsdFIgRdfxxOEE6J3a1pH68DzhMQxDDRe?=
 =?us-ascii?Q?izk6pGR3RiLREFw+tz1iDgAC5hQ6/w/B/blV5YQAQVEJ4NuLR8Tiy0m27Rtq?=
 =?us-ascii?Q?E1YdEnwHDDTIiOzYSd35FdYYEATqB2Z2FS2E3ozKolWJqImJfqG+jwgtd4XW?=
 =?us-ascii?Q?FNSzX1OD16mpgNIZ36z9SrzksIV8VbWCHV+HvmdoGqJIBn9acBEgRHEWZ+7c?=
 =?us-ascii?Q?iqqO7kmBHl7xXOR86hnTn1t+09Gwm517wFzIry9/fnYhA+nNs0WpApzfKuj2?=
 =?us-ascii?Q?OloalFTbHo/62hTPCWSBaBy7niO/ZFwqtylkvYy6Vak3qhZo3dDM/XpcLJ2i?=
 =?us-ascii?Q?QnaEGuXYXORzs7nZo1WhuCri7fKCBa89c0Nm7KjT3cCv51dAkClGN6ERbwMS?=
 =?us-ascii?Q?BSSpKsk70aRJsXUyMEVO6P7eS+oQwbanofh+14hw2pxQ1h4TsvB4S/+Ccwv8?=
 =?us-ascii?Q?FG1Zxz8V8GwA/gTLtHjNpu/C8hm+qoIkLyagqz/qs8XQB6KbqBhGVB5fLOj0?=
 =?us-ascii?Q?f5JtIre+QWssLL2UITsIf7VYcDsuyksowxf5M6DWM/lBRPKPbqu81LUj+nIH?=
 =?us-ascii?Q?BRsBK/zXqauPnghpE1WSzuhy2q5M1K3JkQPZ/p+bnwS5Xp6E4j7V0MTikk9G?=
 =?us-ascii?Q?/R2/0zda8KRJIQAR61W0rt6xgWXTUxr2t4AUkPPo8MF6scl+My7qzAdNIeon?=
 =?us-ascii?Q?LV12VHJouIgF07jBmg0zbRYB3ZaIxEuVZ5hsXDNaEVUiUQrnqUjtyu6uBOD3?=
 =?us-ascii?Q?/5OTlxclU4x4nCpO805dsjbKhYQPAy2lEFgTeEQNhul4ZF18bMmsx+cPk5M+?=
 =?us-ascii?Q?8HLsREf+lYLMX7YOrvvKUQiNKTGz13waIkeo2I9AeMh6JuoGLHjzm0stw6zo?=
 =?us-ascii?Q?9Tyis6jV0NWim1UjF3j7JBlLWGOvXT4ZVFmoI98ZhbFKPrK0rgwd8sDVcTqc?=
 =?us-ascii?Q?6yWJ4LbRJxQQrsNSNApqDN1OZMxbFqQq4PJjZQhzxVT16oPJsQozQBMf2NRR?=
 =?us-ascii?Q?IXPyxmeVwLDqaM6zs6bCmTelstFkkmomXhfxh6VMaJwxorbcEMkdRMRLPAj6?=
 =?us-ascii?Q?o/G7OLh+Yj8rYpQBsdeRovyca1NpeTxbGZ1a1nbR6MKCHgfrxbK9a6nxhbxt?=
 =?us-ascii?Q?GTrn9ydIM6Rhr1Lxa8KLTooaB4X/J5/aFhd2Vwi3NsjM9wbnito3FgGcTrDV?=
 =?us-ascii?Q?pJq8hZkm8RdND/L1KwbSFDKKVAcuv2GaA/O8Rv5U1yuxW3IQ+O7rbyVAJXmY?=
 =?us-ascii?Q?ysOucRPi1kEalgIyKHqH7Is=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7663da-4f38-4c1f-a933-08ddc59d7698
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 01:50:24.8522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jU5KECZP7RDepkV3WryD0J3uYkakWxAqU7QW5Dl6fzOcHElOyVoJBcw1b6IdCLC1qoF5EJc+75S58uoFs/bsMUDbpL94ffvsCf2cI/gnuh2g0+ca8Qtujqx098gPll81
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB12514

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

