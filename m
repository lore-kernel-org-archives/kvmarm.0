Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazon11010040.outbound.protection.outlook.com [52.101.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBF3231CB0
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 06:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.228.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750746594; cv=fail; b=isk7Olc7rguCBz8rGFJmugfag4IdArdsKRdsmhM2GsJom/XMrgVmw7ukHqf+LhiUyE21uU1hprmUHrBreumngrV0cQgrcYrtqnuFO6bEXFcVt/XTFj3wwT4QZw/+S3s+iw6RgmygvMYVlgvLN6SjFWoVyw5r7PGHhoWu+N40l30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750746594; c=relaxed/simple;
	bh=HMHpNyC8t0xFHsa2gYG+VSveiB9aBT1NVIjrt0ylvjU=;
	h=Message-ID:To:From:Subject:Content-Type:Date:MIME-Version; b=Sc4j5bY3OOuiQMNWZRKhHBKYf7wF26ClpdtVHlAUN0XVUnH0BFHyT1No595AW6cj4IpVEf+rsIabaBsW8yjXSkHd1QJvf0Yf5lJpxCx+9cxt+MTJjK42s9fowCeI2BFEWaPuk7YWb5MTs+ce4NJAOISQMc83nCRZrY8GszdFN3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=lPKXR7y0; arc=fail smtp.client-ip=52.101.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="lPKXR7y0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MoSN8STcMkbHOnGoztk8m7eoHg2D4dbWz4cY7Gt2XGE5JaRDXw82YoPCDQ3qnFeDjRyY7GmttWdkbEUoLSh7HCn9Ksg9AlqXX1aCE0CSCEYyEQqoP8wUvqot66RhSKOswxXA7Zaaq17m+1+azXAZIsN7hVMBbbhp+nw79sY5BrqePrpQarKz1tW/2ANIo7+5bRUcW+g15Q1cue27sNsIeStPvs8+G3uYljHuoRJYTG40Oy7vJiX2SEEKrkNxfILLN8PMtrjBA+ft9V0d7ZQgRaQ72ip6l2DU7wE796BubAXcLH9K/JgKnN3ds48mlcAKqmbMuBvV0aoyRv7+1ld0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ee7eJcBav3b1/n/VzcVEBEbV4mETctuX9hjBZIXzAJI=;
 b=mhSEPAcjncIOxBv9ZEDp59gMCszfRIGLKNs/Oc87mm5VzsEE5lIArpuJFGn/lDcHi3TKmKRCUJXiQwaqGFpvImYesCMZLx+rsIGPuYxZFoa9fL1a1t8knqi1e5WEpSXkTL+WEgeLVYBm7KWr/s/D1DxtPRxCw0y7Wkoudvlm4nH4Rna7Q0kzIebCfbfnczeMP9/+5Tr6LuGJUeylFbqx9MPwK8YJprJM7GxwdRNKlIuIV3fSQpd4asmPNoITRsZCRLy4ojABuH/EqXlAZg5qBCKDBjLM9yNPYp2bA2Lu8pt77xZfHAQWiqs5VPUawl6BCQKr1B+xDlXurAIB5rXTJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ee7eJcBav3b1/n/VzcVEBEbV4mETctuX9hjBZIXzAJI=;
 b=lPKXR7y03Sxqb+UTm7jyZZ8Brhza5LUeC3y3L+OIw5kKKhBzpgvdHZt2ZP76G3SeXAJX4LLDYP3J0B+2AYY+M/vC0HxeeRDCduFnlGZ65+6sDKDK7EKvKs52l9d8JWwR0o/Ji5LLXqgnki3Z6kCPYtWBcx7FhVmLQ18yTbs82bY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11) by TY7PR01MB14554.jpnprd01.prod.outlook.com
 (2603:1096:405:241::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Tue, 24 Jun
 2025 06:29:47 +0000
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11]) by TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11%4]) with mapi id 15.20.8857.026; Tue, 24 Jun 2025
 06:29:47 +0000
Message-ID: <877c11r6sk.wl-kuninori.morimoto.gx@renesas.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] arm64: kvm: trace_handle_exit: use string choices helper
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 24 Jun 2025 06:29:47 +0000
X-ClientProxiedBy: TYCPR01CA0189.jpnprd01.prod.outlook.com
 (2603:1096:400:2b0::14) To TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB10914:EE_|TY7PR01MB14554:EE_
X-MS-Office365-Filtering-Correlation-Id: c0e4b69d-9166-4f27-f8f5-08ddb2e88422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?idHBrJ/3g+k/YQbqGE2puwQfV8H5aBpzS9vUlVt2LGFiJCqTdFZeNsjCtBeq?=
 =?us-ascii?Q?wHQ6ngjy+eld8f2TTPJobN/sWk1920BD3b7mWC3XsIGOGxqLady3DSJ+mA1c?=
 =?us-ascii?Q?Ktx8wwwqvUkGmpAet3Cxx13bfwYi9/m1FOJ9kIEWLbmMOHNNATRe5j2GNuoi?=
 =?us-ascii?Q?eK/+uah933gmNukyGoCTcqJLV3HB0cuRxSiOT1hauASYtgLalkSsKe5ODjzh?=
 =?us-ascii?Q?6O4USXQr1tpJFsjwavZ5Fp31OOKS2eLWHFpQ6zOwjZIkVyAXv76ba1tWku+t?=
 =?us-ascii?Q?OFr9XZLxa2ovfM90iaNjaAevJgWwdjNSOf8PAdIPmM989E3fBw4CkIHp4qQv?=
 =?us-ascii?Q?d6L6EOxwv4dUW7kS0r2fAqli49br/ya+5h4+GKnQTO1271sOL2O8skyX93Aa?=
 =?us-ascii?Q?IkdTH1iqmMltnQzdNebvcRW374qVjoDwXm1rgnNNtMXrJ9ryLYPaF7aB2qMJ?=
 =?us-ascii?Q?DKLKnb7y/9fiyzzuA/z+TfCbGxSTkXFF1F/RlCPcWwcs1yi1bABIfFrKnHrJ?=
 =?us-ascii?Q?Q9+DlQ6bIvfATpRAW4BdPQIkd5/HlDH2VsTE5lNX8ar9WbIxYpRHewxh/bg/?=
 =?us-ascii?Q?Rx0Wt7NulRZVs2TKfAEhcM8zrr//h6Yc+FOMzU+O9c+WF8QM/cfg0WaIlvRT?=
 =?us-ascii?Q?RdLDaLt6dc+H9HbIPr/nuJcwBSF9lzbyr4Gp8FoFu5THMrtmh0M0bdX/zpG/?=
 =?us-ascii?Q?fQh98AkGOA3psaj9iyBPQUn/D//DLcZMJszsP6K4nT5GiwbJ4ytn5cDxc4i3?=
 =?us-ascii?Q?w6LTlsZX9dob9TTLWew+ygtMDI3MaMcrCBh6uYc6PJuIs1uA2Zx5Ypfo5z0e?=
 =?us-ascii?Q?M6J4UxQ+qeflsqCl7lscsUJbrTyipfzRpMyznv+FEbFXH41V74BoBoPDyo6h?=
 =?us-ascii?Q?CwdKI0jR25obqV4k2XBmhi1viXti45JdABEW6WSF6Cs3TVrV5UFfxbnLh4Rt?=
 =?us-ascii?Q?GOLTnXeLGZwoGMs1Bs974N2ERapc+0699IOIqObATvU9VA66tB4Uf9E1j8ij?=
 =?us-ascii?Q?HN+qvoT5/x3HA0uu2U5lSYFmiqsHFI4gV+GxgxXujU8Lbxk/4CMa+uYdOwpU?=
 =?us-ascii?Q?fs13vA0aCSRLDd/s3iJPIQ1EHVapONkP9lpu8Qr6Yd68QYS0VOBpQnORx7vi?=
 =?us-ascii?Q?WEU7/HHwBGxV0tFgNH6llu03xGUl1OxZI63QW3dYz0c0kvNDltpJUnH8ogNX?=
 =?us-ascii?Q?qNTDztoDeImUsmJmZwyAkqKwRQ2Fndl6OccISd7ONEVVJgiwb3Dd1GVVofqZ?=
 =?us-ascii?Q?hD1A/zB+96DqGvsu0rg9ZXNpm8ZmrmtqcqvTHuF3GT9YZ7edv76viCFWwdcG?=
 =?us-ascii?Q?WYtYwq7P29j7i8FebJUIE29kjfMkSUXzNsskAis8nFCWevzdpsbiym+icbI0?=
 =?us-ascii?Q?cfIanivIIt3uX4OghcWWuMstQAcUe7AMBhbHiNbhieEWePGuTJPDmieEvrhb?=
 =?us-ascii?Q?xNSth11eZoXGDNEVoX3BOoQrM+xCe0QdTJbLrAOJ0Z+5IfAwc4lUkA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10914.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zstIdsTTTvCWlOrs24Q/t9AP3VOe6t/evmCzUQ/ksUt8cOJBZLD4PcSdrp1E?=
 =?us-ascii?Q?TepnXKKEQB1X6OK8vMd73WABzbpj1yF+OL9vLxKa6VrfiHvMVQ8ioGqhhpB7?=
 =?us-ascii?Q?s64diZYCyrNBj6q6V3fBH5K8+U+llAWbnSQO/moxAsOIHtZBL76PozRdc+kN?=
 =?us-ascii?Q?ZQWKKflb/XwYjs9xQvj1YxyWn4+jcUQ9+IhpiSHErb6mNJr+hu1VIfPC68OP?=
 =?us-ascii?Q?zvt/iyjdVxuzt63sZMF38W0ozyxxcX+6imExy35EPEjEiMbL6i+C6Of19CgB?=
 =?us-ascii?Q?oTEBHg1KekOib38qISz4+WvSiqZgfT5S+aTAhX49QaGNFr4BKp14oqh8WbL7?=
 =?us-ascii?Q?Kko2LClO2xouuIr1NJk71HtYbVV/zyg1yryEnDwWarC0/KzqFEkbuQv6aJ6g?=
 =?us-ascii?Q?j9od3RNciCC6r7i01mbHfsHn1znQvyj9WIygZqUhsCpSvUlz1pGQsmMdPnUE?=
 =?us-ascii?Q?gT8GXB7u8FIiTxKVTuR9MRFc34qGaSpj6/99rvDf3otF1eM3EsFehSYyygqI?=
 =?us-ascii?Q?MVAuU4EJJ5pNMfS0Tn0wVlnCj5TJXejf5ZQIeCr5+Xy5atKDpLCLLed3rJka?=
 =?us-ascii?Q?PeYwIuxBJuK+jbszB3EnYr9ARwRpJPjw2CXYRsza2ypn3rDEqfIA05fIQL/u?=
 =?us-ascii?Q?J4pUAMchb6NXV/LHykboMtgaWkIZqnPqc12zLj863DKcvQSPBCLLPyMrEwfV?=
 =?us-ascii?Q?7s0eenr0up/3AgFv4pG/fq97ojHry7FOF8PC/+zOwqPvjtTSXCHxypIfB7kY?=
 =?us-ascii?Q?1YwQxsaVXDP/RGo5v5uLr9l657pRb3LgjZ5wzhoZPrxjxUYhk80ujl/X5h/c?=
 =?us-ascii?Q?DFJGAITJLwDKKSj/CZOicZUKdsS8gCFoYzg75ePXQfkYUbjBpJRtE1qUEReK?=
 =?us-ascii?Q?L7YykSIGba9tyI0IoMU/et49O/JRlvTABGA4eCCnxcVyk+krEAZgCB7mL+bs?=
 =?us-ascii?Q?Fmn2VWUuDhIuv4YykAOVJUjKmWF7a0slENovOPnPdZi5bu/VnhHN32QwMlaM?=
 =?us-ascii?Q?XFfAqRgXQqawzK17zTwMbinpzXMrJNbETaHVTL8fmraZ3ufgN8S/Lqur1OVh?=
 =?us-ascii?Q?E9u2J7l6GiVFcHx4iKLJnGsubSZMMdsywtrvJFrPkBOWMaFYKzBvNbdEL3Fy?=
 =?us-ascii?Q?hw6GoZkatgAf4CjZ2GVySzqiQDGZQStv3bwJdFKna22q+H8DeDpT9Ev2gvy0?=
 =?us-ascii?Q?PeFeTbtULbH1stsPz4PIMviOZP+wCXRn/KzLR278+Ki68WhPmUhJcSWKuiis?=
 =?us-ascii?Q?a1OfDczDS9Xbddp0kuM5bcyJRUaybGmdRsdiEKdpLspC2xSF5/2P9rUAlNkL?=
 =?us-ascii?Q?i0e1Gve7K0lAUFjhod5v/9rzxezi0a8scFN9CW9eG5fu9QQZQnpg/BaTBZbd?=
 =?us-ascii?Q?QLFjnefudtvAyuiF6cOcLVdzFFYz4rArOKqk3fEw1x9MsVVxyEGQKT+zsN5F?=
 =?us-ascii?Q?adrFyTzVplapLIcPEhMuL3DiWZSDH6I5hXbB1jeTrARitTKXxpZFoLLuDp75?=
 =?us-ascii?Q?a2duqMznaCiawNBnZlVcG0NKDu/di0f5rRMOp1MLlTA2brWHt27LUjtn2K8P?=
 =?us-ascii?Q?dsqILXvuBS2ASLmsKLSgW9taduw9BuV/7JfVgYAK0+/1AaCYmA1GInYiLQQZ?=
 =?us-ascii?Q?wSqXRqGGJ3YHdurUaHZz8yw=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e4b69d-9166-4f27-f8f5-08ddb2e88422
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 06:29:47.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cc8pNs57bNYLaNV+WFFM4wEJx+oNH2fjUrum8BG40grRjx5e4O8TqtwpC1qmKeEnswBnHK6LpZhK789LFdw2KjqWja22OuPQUDoLihNwYecIPLIofSSlBStzr6jXUHAr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY7PR01MB14554

We can use string choices helper, let's use it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 arch/arm64/kvm/trace_handle_exit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/trace_handle_exit.h b/arch/arm64/kvm/trace_handle_exit.h
index f85415db7713..a7ab9a3bbed0 100644
--- a/arch/arm64/kvm/trace_handle_exit.h
+++ b/arch/arm64/kvm/trace_handle_exit.h
@@ -113,7 +113,7 @@ TRACE_EVENT(kvm_sys_access,
 		  __entry->vcpu_pc, __entry->name ?: "UNKN",
 		  __entry->Op0, __entry->Op1, __entry->CRn,
 		  __entry->CRm, __entry->Op2,
-		  __entry->is_write ? "write" : "read")
+		  str_write_read(__entry->is_write))
 );
 
 TRACE_EVENT(kvm_set_guest_debug,
-- 
2.43.0

