Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013062.outbound.protection.outlook.com [40.107.162.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A67230CD82;
	Tue, 11 Aug 2026 14:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786457260; cv=fail; b=JrG4gJ8cFYLeL64Om6rhJXqEuvP1j46epQMXOUUmMtY6UCfP2PNlZRSXMglTi9qALM6r9AnGtHXUW6hq2Zpomiz/HG30Pal0QNI4NWj1mNfg2SdlBUiXII707d88jLdx8zZqreWlevKAcREs+BIqTZBaNjwj2Z/35JNWRC17u0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786457260; c=relaxed/simple;
	bh=Z2mwe/Q98Sp0oKuUcIcefZXOn3EqhvD3F7wxEbvtqfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KhnTszEIIg8aDt5vG6f7FBlcpskrQdN97noVbDzRXrjOLyeOHF5NYQONPJPJH+fj74GIIw7gBgArwTtTFRYuaQrxOX09Wcn3NB7mH7JYS1gnYq3M/WsceB5I68DvMNhgOy9au7LCKXGHbts0D297v43evwj2SqH2xhJ0j9dty5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=r9WOjFVi; arc=fail smtp.client-ip=40.107.162.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="r9WOjFVi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pCtmAEQoQlPEvd8vtJXxxGyhdYdp4lCmWfmZ7nqWxPOS3kf6JnxWY7o07BkvTsloc1W3SpcY6HMJJrEpCETJsKZkVA/0k4MNwpOErPGlx8YqtfM1IdQDrbBqJPTgpvvnOxcRZTq0T3npzqVUXUwpaNf5hAvcz18RdxeHoNRsMIzwoBINO0RGl2+RlLxQ9HOcATNH/BYdc9Uh1PBR+f+IcTC9aV03smje83NVfqxJwR9tziw4aJKOBm4t8+XM8fSgCvh9I3Pdk2NL8u8L1HN58q6h1LlYgSKQ5q6SrLK32Ah/WI2POjBXTGvchwaZn8E/s2TFoARxTFVlNCAydWdxEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FGk1F7Ol8DU2Fe5nPhztgSYUXsCzU2CO96I/vkIRcw=;
 b=DHXdNBbNjW49QJRF1bm4qF7UhtJCUFfxkCTFc41LD0i8E3/SUofsva8CY56FShPIGZz9VdCb1g311eLzlN2Fc7iTn6pa2iKKARAl54qh+5oXFXYLkieKqv9PiwrnztEH4aub9dmrQkSL4AgTXS5AmIFjioGgw8XLuBIomfZwL2enEf5SZxO0UeIL276tSSOYJ8JEq4dOlB1p8LtkXCvt3WDTno3AiFF5X5fDegt6IPLG9yLp1CSVGSb9gsrf9hleV6JECP8FpfeF8smfa00e0XpChmrJRlkiqZ4661uN+7JuzbKMUbsuoVpGi4edQ29f/PZew+3swbXMbkqYDNQQyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FGk1F7Ol8DU2Fe5nPhztgSYUXsCzU2CO96I/vkIRcw=;
 b=r9WOjFViYwozrTAl/vqaXWu1ZYtgxUw8yk66yw4Gpd6dYqzn8r7t8r/BRXAR2p7YqnPyLik1+lo5p5jGMTYMvaUFWGUxProOCmIojBm1jgB5QWe/Ujm/u7aw/ICYWzfSKp9vjY5CggcDPyhfSgtw3qDovJ7NFi+UMRq9UfHia+1bsBjPjmKHqq6i6QqMBnN+CDXYJrSY5WxqDZeuFjiTRyPT2m6adJmJy6G2MrsJj9VnlmLsW3jwEL+680T1vQ/JkfJNLe/v1LQDovhXmSEWJOYBi9ji0OPqVlcu7ZfBnfgOR2gN3uD0uG7U1sqOgfz0qMy9F4Hfv9mNxlSPMyrF3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AM9PR04MB8437.eurprd04.prod.outlook.com (2603:10a6:20b:3dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 14:07:31 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 14:07:30 +0000
Date: Tue, 11 Aug 2026 22:11:22 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>, Frank Li <frank.li@nxp.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	imx@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH v3] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <anstio7LOI4haaUx@shlinux89>
References: <20260803-imx8qm-cache-coherency-v3-1-c518d0da3d3b@nxp.com>
 <20260810145149.GA81453@francesco-nb>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810145149.GA81453@francesco-nb>
X-ClientProxiedBy: SI3PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:295::9) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AM9PR04MB8437:EE_
X-MS-Office365-Filtering-Correlation-Id: c3483fda-f493-4ad4-bc63-08def7b1e1e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|19092799006|366016|11063799006|56012099006|10067099003|6133799003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	iSwp7o+3b2+WCPYGOk6GjoJTUduVQDLdFnBwjjSC+U3zqcCL0bJbw6vqe6v0kJD2Wt25T4JX67wf6r1cnVPphRIEcG8sDmNr5Kt/gaZNRYAGkVga4VUqQ2BGqRCd2AEaLpQeCdkLZl67TiNhfrqhJgZ7Ol597ejLdF6mzjCVLFbFIXdv0nNnHJIllvfKin8qahnVRBcaPpap4Am7/YASVAMjtnqEAGd7sikfozPaKlqJVWK9xATIakms//KosRIVmsBJP02OaqQoNNRX4NSOArwDgo3z6SuZRTcxF6iFdRu0/FPgu1tBSfwqsv1f8phKWdkbe83dCeqsgZX9I0Tivec9/BkBnSyKZJTCXp7IBMjxhxtupOfmVnrRBh29d1OThSjy0duiEszC1iaj4ITjxtr7AqeIuV5UFYkW5IacKRvXNuviMRtg9rqfW06p2IUdtTuyH+06q5aRM9BkIXkVQKFedhWQBoMF/ZZs4I7QS3qFnJGbUQ8Q8d8f9Efy0ltt2bw8DHl/bH+acHhR6gE1Z4YPEs+9kBTTmLux3eaWZ30lXCm+KmCnklNZt8XzZsVhwJgLE0rPLsUnDEsoRDReKamMg+pHgYfElAXsxI5PCrlVTMzpErq7zUmqMT84lW5cgXlbPIwVO6SHmtgN16qVy1t0i5Z8r5tvlm3aHgVEm28=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(19092799006)(366016)(11063799006)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K2WKtWhl8laPCns/4PzzM/oeKqGD49OWJjkC+5PYorPzWck5mj66ykmwGzyM?=
 =?us-ascii?Q?0J/AHHyA5ZLxRaOuuTqqWUndjuFCD2W/AZZ6/DJH1np6sUiO5VOwcmtjvGim?=
 =?us-ascii?Q?YLT4Q+vPu8HBYVouhrvv2bPX9vgnpF3Pkc6fp1rnC1ObYa4o5CzGSYo5b/KT?=
 =?us-ascii?Q?sfZJMFJ4YYhO03fUrjjlrKMOpQq0rRjCwsqA8jQQ0s3IsODcSuNcmr7+wcm4?=
 =?us-ascii?Q?GMV4yYs7bRRs8Jc2taiFDtoskSpHbyno7bdQpMOrIWARxVzIlTipbBTdpiXJ?=
 =?us-ascii?Q?65Huw3g4+rdCy4Foh1JaqVBME3SFocQWi7hIU1dWWFinHd/j7Nvw1sjhAfXN?=
 =?us-ascii?Q?YQMPyrntdbcdGcoUttfRRzteeId4VHpozouJOs0ydwmf3zXSaxnzgzTHC4lw?=
 =?us-ascii?Q?cUmdXZx/7/Vhoq0PzwvrRjP//qeG+R1Dnd9g9vH9sduNBiC81c/tfSnE2zZp?=
 =?us-ascii?Q?l/OSv2J5U87UHMXrxXESCA0PpoCPHMLmZHPGFxwwiegpoM6Oj/TH61tHWDGx?=
 =?us-ascii?Q?o6siZdieq5Ukom6BbyHP8LD92uwNOy4uLxLH7DhH5SczqOG+gE/o/dJui1HG?=
 =?us-ascii?Q?lVKVkvirrW44FxAY4Wi5tfJvBITP+V5TrudAEQswDw58ScMqh7Vtc4LmLfT+?=
 =?us-ascii?Q?pHy0QZmDim0O/tIkdfT1q3ZCNYYYHVUvgMqFXc6OpMrKaUU83wH6BxbLZd1H?=
 =?us-ascii?Q?HanGKDowEgQnUxwSILRFlTg6bLkdm0bl2WlF1uG2ir4r0mLZ5mKjwe0PAxRz?=
 =?us-ascii?Q?eBwRPxlp23vBxe+R5r2K3maUV+ovpsDhi5lfKsG4cjVzsK9ovIFZuYwn7tYw?=
 =?us-ascii?Q?+nUTQFG8MhHMrpiUv3LNlnk01eg9KFu+vnQQY06TxtHlpc0/cbEn3FmOe3cL?=
 =?us-ascii?Q?GPdy0Vko5OveHFoeweXPwBHS1Y9UJV3tlNcusrlRu/v8ehe5j3H2Q9cWoywB?=
 =?us-ascii?Q?2spuFD5PgG9jEikmjsGf5dN7HmETaOMEnPBdrro8zLKKO20ItPwM2BhPvUh5?=
 =?us-ascii?Q?9OoWJFu87bSdbwpax55laxZgA1Uaw4ZB4fqP3Z8jm3vXdFFtTlMLrc+OrP7m?=
 =?us-ascii?Q?s7AMWYLjLYSDqz/7brKFBjwexdlxAhVYiS5xV1JVjZBA8Y8c1zTJ6aBqikUO?=
 =?us-ascii?Q?mq/QSqtSoRAlHU6cS8K4dFnyqkrdL4tS4ogGIaI4XNKLbw2RpL0LuBGHUXvM?=
 =?us-ascii?Q?MjOWlyJXdG1/cZmurKNqbz3CROWV7f2IEr1Oa9gRFHoy04XeIpg2OE53lBsu?=
 =?us-ascii?Q?scdMPysl9lifTmva07sZBqjuUcqq7Tc8vqx64zKRtdjEKjgXNj1hIXjjCsgn?=
 =?us-ascii?Q?roDQev82h/wPqrRHK811c3bcaIeACCD9WXWtoNkbKkuKEDZuWnYs1gY9K6tQ?=
 =?us-ascii?Q?srGW9MyUXWrnzDeKUAzTaOTj+/fKKdsIE5atNdQsCKNLvs7IPrYePdpLP55z?=
 =?us-ascii?Q?BuhWnKspxT4tfw6WC6UM8p7wW/hQ1WIHDHEyRijXSkbnXJYG2nLqx0UuhH0W?=
 =?us-ascii?Q?fF7+xc+82YBVK+XeGljce7u6yYz8eVEsumOAMvcVnJ0pkSFBCuDDJ9j8Ah5m?=
 =?us-ascii?Q?oMJ1jPVsQuOsXfRF2Z/aF1FhOxEVCnKfEnYgmjVKItpiQkJO6mTh6pJHQXaI?=
 =?us-ascii?Q?8ycYLuL/A4MrI0q2COFsG8gUnbvuiVK+jQQw3FmhQPHTe7Qf0uFR4BA+kPGE?=
 =?us-ascii?Q?qKxAVQRum/HuvEg05UCCVt4JGMl0CPE5nLo9SVUQjRI9J57NoOPVA0NCf6E/?=
 =?us-ascii?Q?SN9AfgEhk2RNb5k+eXtrTbWHYRn6FAIJ8VWDRpACSCjG2UFNh2OM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3483fda-f493-4ad4-bc63-08def7b1e1e7
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 14:07:30.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+1D2nGW49Zh9HNPbKSlY+9VHOF8mA9aJO4PrgBp18I9+o0AOY0aKODN90l7DpsRy6rftx6E6gWeChPEXq/7gMd87E2zWvRKPCQYnwtQRtjXTD3oVVZvCkyi7+tOFOrm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8437

Hi Francesco,
On Mon, Aug 10, 2026 at 04:51:49PM +0200, Francesco Dolcini wrote:
>Hello Peng,
>thanks for the patch, very much appreciated.
>
>On Mon, Aug 03, 2026 at 04:54:44PM +0800, Peng Fan (OSS) wrote:
>> From: Peng Fan <peng.fan@nxp.com>
>> 
>> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
>> suffers from a cache coherency issue (ERR050104). The upper bits, above
>> bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
>> have been incorrectly connected. This causes some TLBI and IC
>> maintenance operations exchanged between the A53 and A72 core clusters
>> to be corrupted.
>
>...
>
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index 5db8f0619e4b..4ba68c1f29b2 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -200,6 +202,28 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
>>  	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
>>  }
>>  
>> +#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
>> +static bool
>> +is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
>> +{
>> +	WARN_ON(preemptible());
>> +
>> +	return of_machine_is_compatible("fsl,imx8qm");
>
>fsl,imx8qp is also affected, please adjust

Sure. Let's wait to see more comments for this patch before I post next version.

Thanks
Peng

>
>
>Francesco
>
>
>
