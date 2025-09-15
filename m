Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010043.outbound.protection.outlook.com [52.101.69.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBD2F361F
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 09:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757927761; cv=fail; b=pb10HBhoPcbLOVM8t0XO8DLkcIhZRinyEt3GDamwgz8HZzrevf14lb4RPMWpedtbvQvIlUeHhuNy5QLEBUoiuj1SmbJUTYq1iWs6FRMRsujSIsOZooiALAJ+WXzLNHNNUe/1Y3XJmdh6WWCxngHCbIQC0Bm3pjh2i8isUxvUlDk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757927761; c=relaxed/simple;
	bh=yA2eIvFXjmdcE20Ft8ycRON0rCbbmjoTmTQz7vqOIDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZJJegs4iHWk8TscuytJW24CccxGh1KAEPIWGJcO7YmC2OioCUeREDvSGpMaRpjFYlZAGRF+exx3kuxqkQaKDsVcxyh9cx7RDQr2AFD/MVwrqWeVh217Xrky/PpW0ZZdb1Mb7OlnaTGePo/64ibY1fSxuQJ5dvKIf5rLgw7xKRRY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dd8a982o; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dd8a982o; arc=fail smtp.client-ip=52.101.69.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dd8a982o";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dd8a982o"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=P2w8O1CCGRx8L9kHEzd2qoZ2T53qJXPcwpODlePiwKVz828lzKrgKXTHZOZOUeBLzajAdNQ2JGHVMRlE2Ioj2GWrMha/Io55n42f9cz4It+GlSETIbci57/IxzKGOpuO1FVnC4m8iDZe70aB0D/AlM76e1Dw+AumTuSl6llbvfequ+98oYeriWJ6sAH0DXFancKi1pXzP43aRpjg7JMEwcWkZ9bAuHkPvP6G2sxZgyo7MxblK4ASz/cxYBEmUbeOxGF5xlORUVntyLAEaFU78WR5eCC7vr6gGlaWsckXauiRexFfZe7WNk6HvWhJXGRiu01L1wnGfq29fZXP9T//yg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bv4U9N8ca50Fup2DSLqdw8fumfR9Qd4KkkhSNIMWS8k=;
 b=f/bWKy+ZeNW5otWcYWGZhwuf3UcoZhZUsKUC1qA7Rs5/cKOd+gvtIMYFahn/2TnLToKyH/wLMOJlgNu0wCGfD50cK9KLhTqJjktcLQIFLU2IJq0j1Yq+yQnRlRrG8FQ2xHA6RidWsiGH4ydSl9s1tX+6/XEe70JnejGICN3zD28T9sOBvreoPZMHJIP8UtUCe/n6NoagYu3/z3Ut0xUJpUSRZZtMUZvyY4Uwb64s5uSpXnauVtTZ0cnp9XLfEkJXXqEi1+3e38xXHF+zJnYUNjS5wNF2N+CD7ysyKnSoPydPCCIhwB5sXet1M4KLWMat8mEkl3PcASQISxrGhh7XvA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv4U9N8ca50Fup2DSLqdw8fumfR9Qd4KkkhSNIMWS8k=;
 b=Dd8a982oOUb/6wHUput2MNRBSF6+STQunC/n3rXCGGf4V8zeGdm8L6LixFsVJhIHrnM5QUgaTwV69x3YZr9SqeCgM9UZvvwYccnGdKRWA1B4VuMy18tH56PlByT2gkROp65geA0nFouQRWW6yMuwJWF8DDcVGoJ4e5mB2T5Pux0=
Received: from AS4P250CA0026.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5e3::14)
 by DB4PR08MB9141.eurprd08.prod.outlook.com (2603:10a6:10:3ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 09:15:54 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e3:cafe::8f) by AS4P250CA0026.outlook.office365.com
 (2603:10a6:20b:5e3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Mon,
 15 Sep 2025 09:15:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Mon, 15 Sep 2025 09:15:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZdJMHTiM8bKsJd6xpHw/6nV2qWddWFhXv0wV1PCsphYAJ4cYtKzK2MajO//aWFdteLT9a7IN9pBCMinJle/y2hqdVfemyylsWtQQmKj6T4vUttVwc65gP+xSPje6gy14AFx8YCBYu03QreEaFaqRG3J4zN6bBOHhKNF3oyi/4ToRmm/qzmX8FF7UTA4ngqnFxn7F76wQhdMEYaK6pYPYrK+RKPschgLZb6joGw5hTtTXnjU8/EzETpJKm3/7PLe4w34aEJgtZTiNSsI81AhQyVC6kEi/ub7KuOrL1tIJTZv4vb3Y84h6fLeFOlZoZToJeCBpoNAER5OwXweEMyBFog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bv4U9N8ca50Fup2DSLqdw8fumfR9Qd4KkkhSNIMWS8k=;
 b=d0ZTLfPtJbLfIIIneCP3x67QubfwRD5K8FB5LZJvB2HcKpHtcY7cTG6uEoEpRp2Aumlqv35rTSjoC+aFIXDdEraiALBqcfCjkgjuDOivk5yti/RjswZKf6EkEymTbf3Qy7bWKqncRQBbIJ2wVKNmwIL4liY/8c1o2nuCediZNM1L6JJHNgGaMGrYHwDDosqNrpIR4NBw+ivzE0C2NECbHdjgS9wZitKrgS50tW1XPOp9hGSvgNfeDET13JrbyhcLXnyX27Z9X9EkYxie2FpVFbC7WWGAsmkfzw2oBQ+3YIgaBY4UA4JLSbfOZjeP3xoGSVyOCvY1OyI9/mXkkETNbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv4U9N8ca50Fup2DSLqdw8fumfR9Qd4KkkhSNIMWS8k=;
 b=Dd8a982oOUb/6wHUput2MNRBSF6+STQunC/n3rXCGGf4V8zeGdm8L6LixFsVJhIHrnM5QUgaTwV69x3YZr9SqeCgM9UZvvwYccnGdKRWA1B4VuMy18tH56PlByT2gkROp65geA0nFouQRWW6yMuwJWF8DDcVGoJ4e5mB2T5Pux0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB7510.eurprd08.prod.outlook.com
 (2603:10a6:10:301::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 09:15:19 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 09:15:19 +0000
Date: Mon, 15 Sep 2025 10:15:15 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 6/6] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMfZI2VVV5zEsTna@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-7-yeoreum.yun@arm.com>
 <aMLpMBWtHDI9sPHK@willie-the-truck>
 <aMRVWRldi0wJqBpD@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRVWRldi0wJqBpD@arm.com>
X-ClientProxiedBy: LO2P123CA0038.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::26)
 To GV1PR08MB10521.eurprd08.prod.outlook.com (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB7510:EE_|AM3PEPF00009B9D:EE_|DB4PR08MB9141:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b5bbd3-a3f6-411c-5197-08ddf438791e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?TcPRdvmaisqNNRtBsGdvBRSK8d0GkT6jGRA2bPGS5T0WDuyFZJVraB3FA/Um?=
 =?us-ascii?Q?7a3F/zGBD8rhVfkkbecgEI4PUHLMbuZyp6O/hKcWScE6krfhiaBWKFweCS6I?=
 =?us-ascii?Q?rWlq1/W3ygZl1e04r6wF6rDicOOpM1X/pwoXec3uZzkgFvZVlrLk/icFuPg0?=
 =?us-ascii?Q?xX53HeCcdB072ml6QMczf5Sy3n4yKD1xspqt9QhLu395eug+my5HWva6RFlD?=
 =?us-ascii?Q?dCFePy3lqoysMhcgbj6lVPfxZB3pKk6J3McpDLqpJsNe8scy0zfx7cDU4d7b?=
 =?us-ascii?Q?/y4cOMuSdsT88Uyu+nvkA/vyvxQ77sGpy/d6dCQiP2OflKSgWiVb5qt244Tk?=
 =?us-ascii?Q?GtJq/+ry58wBiD7yoLcYaQOyhI6TA/jK6W4Ubcr9KhbcmN9OizQcD19rzrRg?=
 =?us-ascii?Q?6K98O78v7n1C6dldrTCLL4Idnf1mvqs2ZFVcqYX64J6Ek4YqWOq4KciR2aUg?=
 =?us-ascii?Q?6D5GPIGoqPFTp4PmtWZrzeP9ur1Fm24jebRQuDKp+TZY77oVOttJNA5ZMM/+?=
 =?us-ascii?Q?Ryj+3xHFTVFEP1dQcXpkwzxnIhXt+BEM9i1IJUesGLsFhD1mXmdBJH8JDXSP?=
 =?us-ascii?Q?3jplqAcO4mfTgP9d/N6yXNyhGnGqDu5BQtWukI6K1RJHCHbr/6zeV3ogTv/F?=
 =?us-ascii?Q?Frb0x4H/PYeLg58aErf/zPmzb0TGXmJXR575kFtC20bA0NuD/g06GGlqRNwo?=
 =?us-ascii?Q?lVpLlR94Ysc5XgTMBE+FwyDTJvfZNhvXPkl9JcleI4GYYJ4SiNg+ibQLGa0U?=
 =?us-ascii?Q?hSdUWwVp2Gx+m5maySHQwf2L3iGNaZbWeLJPdiftdPmNFoafw88jzFKDSjeE?=
 =?us-ascii?Q?8IeeEDlgtm5EV/zj4JOsS5/za/OEjkSgZaH5JfXy5Fv0XlEtoao3/6FOKANi?=
 =?us-ascii?Q?wSKrecBYj0DFkfX14gVubB2rL7S3O7xuKxRGqB/UIJniDrsEH83W5lUdXSwR?=
 =?us-ascii?Q?w15IZN7FO+YSL4Ac2080EzWzi12Rfo6epr1DTJpWsV5hLRx38k1xYPSq/K7D?=
 =?us-ascii?Q?6UL0YSr3QQN0bbDnOapcmqepzG8GYmHNgHGEVDNWvKcqg8bnt/wWA65OMH8j?=
 =?us-ascii?Q?aIKoYmGVCsba/g82oBogvXunXaUEFAIwTaf6C0VuCCfpV4ieNVoC2nFAinED?=
 =?us-ascii?Q?mIyDTdMenxbjRsP28ojxrme4Mdn+AB48tkhyKHbrwKdHT7i9C5uhJ6k6aXBp?=
 =?us-ascii?Q?eZaNULxdO4EUIRrmWGsnISQaWBwLIlb4BZ0FjJ9UKfwjqDVja9s+ijNKrPyJ?=
 =?us-ascii?Q?Hhz59mvjNfsRFYo4Dp0pMbKwpgYfroVQhcP+ae7U0pFcXdeZZnlMHe1zMWK8?=
 =?us-ascii?Q?fM6d4xorM3XFtQoIaueRAWE6nxdO+X0cPs8gayns6z5caZqteyOwLydCvQZV?=
 =?us-ascii?Q?Whzdix7JRPmXn/KCYA6AeBCspFWZxOrUOzW8Laf5JZ3QCvjqpOtSaoDOmj0h?=
 =?us-ascii?Q?WU87UNZx3+A=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7510
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b24f6735-9520-4c6f-49c2-08ddf43863c9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|14060799003|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dKBsYBuKWmX/+z7d9d3wAaXsiA9y+ap6MOgbzSyHnudMOuaJA/wkLiUk4iUt?=
 =?us-ascii?Q?EchdCaXtt0fnhR7RKpVedwflsoD1NeacvsqVlSiXbIbl6uCtApmWK8vyFDno?=
 =?us-ascii?Q?StVBgCqPUSETnF0Z2y/bhr9OuF6ME+7VC5DuRppkWOdOM3ESGPTilaLCYQ6Z?=
 =?us-ascii?Q?IdEvcXZOLYr3f40FU8bfNM0H5f39JcXkWTNAOTH1/pO2dC0cSYRJkI+u20ww?=
 =?us-ascii?Q?MCRaYH0j5gLYT6+gruafEVFvSmByzGQ1cwMv+BpszZ++AM1o5kdDjQ+DIIpj?=
 =?us-ascii?Q?nX+NsnvOszDTQGIewuucLELzjdjpNlAxWInq+4fHuc+RdbDSeRbvBwgTpdPl?=
 =?us-ascii?Q?fBjk7T8qWHnl6v0hdiEjuKKEH6wu8f7u567o0/d95a8y3PtKUeKqjlf2axdB?=
 =?us-ascii?Q?3d5xwsYXDWG7k66kS4h+bt0nUzGo7/924pNKHZxUGRH8g4X1PB17oflIROVS?=
 =?us-ascii?Q?xj9bZASiEfPVg+hGRDEuNVAZYJhFkwOfccrDz4OPlS0E/TxAejq7z2fjzBQB?=
 =?us-ascii?Q?uU8Vzz4S5IremgyIePVwajXslMHHbhEJdo1jxWTdOpY4o+d7rQmxFJyCaeId?=
 =?us-ascii?Q?tz+QEV/QpGNKmvUhr69NHmuIYZNO7meXhl9RM8jaJcYfs3uZu7UZbkbc7aii?=
 =?us-ascii?Q?Fn+yYASu+Zh3XA7Yzxn7erIIonFx33+CYOaTBWpQDegmy6g4zpdt2ipVjCeH?=
 =?us-ascii?Q?Tr6SV+sMHny9/DRuAm6qYYke8qPMD9FDhE3lx4s5vfvPjk7sKVdCfsNLGr8A?=
 =?us-ascii?Q?2UR8hJvNAZadGVcHbOu9GEG186UcGA2phZNXwn4pWa+eFepj12i5yV5u4c3P?=
 =?us-ascii?Q?Vb111iVqlrUqjHoN/1tLEcPrvlYv7HjW+UijK5UAt1yEnme4ZggRob7MaJnt?=
 =?us-ascii?Q?ucyELRgo/DIsyDEv/qzGaaqa+wf23B1aIZCryCIAQwfD21CMxozbWoSqFcUe?=
 =?us-ascii?Q?9mrqhoU1Um42jas7aPiZNJzYzDbDMgjMypVrakuZSLRb6WLlWS1Yux+W5+Ma?=
 =?us-ascii?Q?6jsWoThws10afaMKpvPhmlAuT+bo0sfGb+GFysRq4G9R+G52aE5gXrgEr/7u?=
 =?us-ascii?Q?x35wIEp+d5ssSNf/0stNMkZWULSYLecYgRQNoXfJAFlh6CpV0QVWAckjbfYb?=
 =?us-ascii?Q?eE/dJk90hBB/roq1YOANDyss2BuCZ2nvZPr1FHusURAYFZfDM8nRjs2AblGa?=
 =?us-ascii?Q?VwtcNXCdBwZyQHSlDttHqEhcqqB8hN0k+XfUMMSCcIqTKFA326Il5YIKmNRq?=
 =?us-ascii?Q?JL/mCBibLCq4zuvPrrszYeQyeclHbk1FulmlLjR4ZHW39oWPKy9FoBl01w6A?=
 =?us-ascii?Q?MlpVloQIfTqn6ORxFOp4f+jdYduCSexAvLB7zwleSd/hLb+AOUT8gzoM4kiM?=
 =?us-ascii?Q?Ukbv3qGlYYvfSlij81fY91Hqc3xEFUtju7calS0/u02PZlMxwqwmm6pMJ3cu?=
 =?us-ascii?Q?2UneVJLaJ9kPlc+gxyLHPnpgHr+ubZJgAMBALq8wL1Zi/wv3OPGEiLJnrZcu?=
 =?us-ascii?Q?H7tPh1P8xIgzdoqEPPxOmhEYWOuoXoHoQJAF?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(14060799003)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:15:54.2855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b5bbd3-a3f6-411c-5197-08ddf438791e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9141

Hi,

> On Thu, Sep 11, 2025 at 04:22:24PM +0100, Will Deacon wrote:
> > On Sat, Aug 16, 2025 at 04:19:29PM +0100, Yeoreum Yun wrote:
> > > +static __always_inline int
> > > +__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
> > > +{
> > > +	unsigned int loops = LLSC_MAX_LOOPS;
> > > +	int ret, oldval, tmp;
> > > +
> > > +	uaccess_ttbr0_enable();
> > > +	/*
> > > +	 * there are no ldteor/stteor instructions...
> > > +	 */
> >
> > *sigh*
> >
> > Were these new instructions not added with futex in mind?
>
> I guess it was _most_ of the futex.
>
> > I wonder whether CAS would be better than exclusives for xor...
>
> I was first thinking we could share some of the code with
> __futex_cmpxchg() but...
>
> > > +static __always_inline int
> > > +__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > > +{
> > > +	int ret = 0;
> > > +	unsigned int loops = LLSC_MAX_LOOPS;
> > > +	u32 val, tmp;
> > > +
> > > +	uaccess_ttbr0_enable();
> > > +	/*
> > > +	 * cas{al}t doesn't support word size...
> > > +	 */
> >
> > What about just aligning down and doing a 64-bit cas in that case?
>
> I think it gets more complicated. Here we get the oldval from the
> caller, so no need to do a read. With CAS, we'd need to read the full
> 64-bit, replace half of it with oldval and newval just to be able to do
> the operation. On top of this, we need to check which half of the 64-bit
> value. I think it to hairy for little benefit.

Agree. also the unrelated to change for other 32 bit can make
a failure futex atomic operation.

So, I'll keep the llsc method even using lsui for cmpxchg and eor.

Thanks!
--
Sincerely,
Yeoreum Yun
