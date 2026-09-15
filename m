Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013045.outbound.protection.outlook.com [52.101.72.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73384A3D53;
	Tue, 15 Sep 2026 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484328; cv=fail; b=ufkGXEdI7rTJ75r2b6axwScyWcIOD2PL4yQOEp8yT2dhVd+zkwsj39ELNFGHEBOF62NX26W6vCKr3nMDB2RNQlwA1nSTbMMZOnbi2W7qG/v59fW7bACkSWqOBo8r+rQX0MSuXza6Xo6JpwsawYb8QaT/SBjwZr0Up8z5ydug5NE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484328; c=relaxed/simple;
	bh=cLCLbLAEIro526ipZ0IrcLVpCURdBfJ9YdaycP6+uhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UmQ0d4IpINolAbbmaE1F21+MsLwTmazrnrZqhC/zLtKP0WeyKfWC2vW6k+Y5H+Lt6kgJb1fJSxjZlBlvlQMmaQDeO9hXuRVRBnloE+wnlLEbSCf4KRDvdEbfgKSfcE/OSIFcFhLjnWY8IHevzuyzLmD9MYwTih8bg1AZzgspLlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=PS9MZL5G; arc=fail smtp.client-ip=52.101.72.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="PS9MZL5G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pwi6Fn3/qOYJNqWm+FgUgZb5CdI5uwcnhLjg0h3JEOQFGJYCKw1nIU2cacAE5zOFiFAOCUdhhUsswRn8HA7U+NBmDUEU1wYTH9zfF6tiEa/3eYz5jjW4pCB1iTWmnK03oSpk9qej/7l2lnf6s05axGrzFILm1oFniSK2dfvMGpOR9kR0WjswZjLhrc9baAnayzC0VQuBH6L0DIAp5OXgEado8qAm30G3ghevwny7BaUkUohwtG5PB8e3NIkyAo4PB/pqjTJ08GWzAqwp+sj+PPgi1bt5hh4qnsX3agpGUuA9IUdDrrMZ4thE8K/dc9cMJKNvTsPg5Ngq8LSGuEc/DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLCLbLAEIro526ipZ0IrcLVpCURdBfJ9YdaycP6+uhw=;
 b=TPsopI1yO1gCnoaQglKCqd7Qb3vRwBxxS1koFv7IIXbn/uJ9/8JIYCygq5j6gERlGxYFj/+NWmEFXNJ5dMNxxDqZvECTgW1n8nA6Yo3Mfr0X8AHCfDbfDQLllu2wHahKILigVeizInQiqbr5+Mb4yRfci9Bw1kLpBhAN/i1muBfODGh7JoEun5mn7+NeeAR5/swqmnHOX6Fk1YbSg93BhGMXd+YnZHYSGj6CtTgUuobasDOx4mfudSQCCVgDqZDDy2GPDXdX5hmguCeqT/8t3JdfNKtRc/R/3rauoGzygbJ/wpCBrkfjgMi9cJ8yWVr1ygbaA7398a6xNO7Y6V7fqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLCLbLAEIro526ipZ0IrcLVpCURdBfJ9YdaycP6+uhw=;
 b=PS9MZL5Glk9kb6NF6fMapQSERrxW0DwgdY+x5ocyowuY4qZxGxCcHCFDe3hH2bCDObTS6xe38HxVo5wM89bm0XoaQpF7eEE3BSr8ahfzFydAV7fE3L7EMEuMac/rVZayVO4U8FLXXcKEXJpJrw9bXNOp8qDo7BXy5Wyp+E0905Aotk7y0nGGpGDHuRa7CqKXZeJuNyxnCrr/C1vS3ZGDUT2MqLB4wXeVPs3yTdHye7BoBqes7eR/IdEa5yLjpBikVwCUT7UBITRYBM5wxDEz0awJmiBl7aiRXT5EwKPhTbW0qgqaXV1ZEZwJtVYH3gmBSGrNfEhc+j1W9fJdigUuiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AM7PR04MB6949.eurprd04.prod.outlook.com (2603:10a6:20b:102::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Tue, 15 Sep
 2026 14:58:38 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.008; Tue, 15 Sep 2026
 14:58:38 +0000
Date: Tue, 15 Sep 2026 23:02:54 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: "Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <aqleHm4stDi3Pt//@shlinux89>
References: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
X-ClientProxiedBy: MA5P287CA0244.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ae::10) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AM7PR04MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: 252eb8ce-e3ad-40ec-9557-08df1339d2ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|7416014|366016|23010399003|1800799024|921020|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sKAHHW+hNyD5oK6b+x2WuKZ42J7OB6wsS3X09emBnTYaXCnJ6kUeXsjyyOp3mJWXQAiq5U7ufPedvzhR8kNzGOC+bg3BAJDKAehT5Fr47n9OfLvM9sZAaBqDC0AhwkhIAZ5InfNj4x2VWqGGdf4j5t9giCW9L+u9K07C+rMyTKhMx/6GFSD6I59avweKreQ4XE7VgZYPFRrdPgrFTouWQGrAtfdZQCs4t0ISaLxtuiGGt/pvVUj9cEWTJNa1b4ht8V2aN9aD7pzfb/W67cI//R1aXcz0BirGn0XXvUzxyLIhEx88ho+gxmFZURnNpqZnGlEywtut6pHtl7qX4cEYhYvW6B96W9IUkcWebYHpYWw1s0DFmY3BYgOGzasUTRMeFe1CFxWUzOgDGdNYGjAOOzledntV23SRb9pwflF3niv5x458GdlUDlgKbuAmO/RMN1YvqLFknSCsiGFJBulEUM7a07cQabtqq5l8kAkJ7ZNTa/2pvyJNzSXnCYSFWnNYN184GtlVJucg8QmSNgKtDL03+r1PTyGKv6v8GvxiYw9x9sRHYFhquO6jn0OR8j5LkMWHnEKai+/lzITLQ8Mu4pQ/sb2CXsRazSRRxLVkD4BcLZVlVAHYTC2PlHnjc3HB4spLZGeBLCFXYCdsw9f8KoZbi5d8o5aQVlBPCH0oM2oaWzm9MZ6uSANtq07Ow82MdSLg3zVSPwoCVFiCdYCZaA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mvl03sm/In3pEbpMWFrX4p+d98EBy5AOu91CxhbL7B02cJlmON4AA/IEyHsU?=
 =?us-ascii?Q?oB74Ug9GCE+8wiXNWcvEVjkLsbaQbG/bkXQz7iiINJZzED6u68BuqUTyhoz5?=
 =?us-ascii?Q?wi5BqBDXJCGlTm/LLf9n/HsXaXhDD2RpvIBOU16s2pOJVQP83HVueEm4ae9+?=
 =?us-ascii?Q?9YfrGrerk84oLrbBvyGhOKoVJoIcFBtIRmeub1TBtfxpbavpDz/APU0j6zT3?=
 =?us-ascii?Q?Zn0zsqTPj2Vgtnaw+VDEhvTzXXaTDOLCYRucKpTQi71OJcIadf+0ZqmIzTRJ?=
 =?us-ascii?Q?9+WOgRULVaPBqiQkId2LjsCJow9sdFetePyW5xZBiBnB720onAfsuhNj9ai5?=
 =?us-ascii?Q?33OaxCuFx+HbsSk6JtMZndRmKbwnMauy87vKmDatdfcIZLwskTuggrINuwml?=
 =?us-ascii?Q?eoNAeAg/WbVy3YrMxc3djM77rKR6b5WbjocyHKRVBlUBRFL2d7br6ax0KPrT?=
 =?us-ascii?Q?QuMmpct2TWS+pvbCYBo66qZcvNW26Eg8i0WPipO6kxSmLtGyka9H/KWTFj66?=
 =?us-ascii?Q?QcOagBONOu9sDvSValE3VRkTwy/ZenwUPJFqEwFuj/eI/RFsYPVF4R0H2rIY?=
 =?us-ascii?Q?g1kt8CihGEONiLP/b8hYc7IRB9WdMnRlN3Ns3aK+zz4pwqqrJ1uwaCJb6jss?=
 =?us-ascii?Q?QCulKPkn+OcZ53QyugLJg8B9TUNEsGShXhRzhj2/CR098AibeeYmG70hc5ex?=
 =?us-ascii?Q?o9ohW/PuD2k4fZBhp87VYxonT0vmo8SoLNuT4dcjFn6C+nzt7Hc73ZZEMUZi?=
 =?us-ascii?Q?wYXlhDFK4Svtl85YG+MUi4H4RoXZfZat8X59t3hLdNqYQTzzWeWcH67yUeKb?=
 =?us-ascii?Q?u8qEnBE8HZzGckNxyB3W8mz8Zpomn/gAucsSQ9VO6tnczvsp3+eaescX17Wu?=
 =?us-ascii?Q?cE+NZ2GREd+rCUnZe81Dgt4cwP7HIgoPOOIzHdytZAOU1D0WtrRd+/5jqdsS?=
 =?us-ascii?Q?XdPCgyhdyFBMLi/suX0fusY7pjbG1IhPdLrpt2soqF4/6yR78IBQoH6leRO+?=
 =?us-ascii?Q?RZ2XZCvHzUfpwNsdw1w2VCSbc+MfKBBOR12zWP4UcedHDF+5NH8nETyzh6aW?=
 =?us-ascii?Q?PQN7Di+bq72AvR4Xz2h01dHi6oWtWrS/aSg0vMwbEffSLZ5BWLf5mg41jMkI?=
 =?us-ascii?Q?SQSIKa+ymYo9hvV73tLBtsfn6f0bAcNMzdVC/5H+oKej+7Z9X8JQROZOmAEa?=
 =?us-ascii?Q?/The9pIcNZjQIQ/0lsuhUh8LynJGOXRcKY1paZ9NNLNBMQSQOC7SPh1rVjey?=
 =?us-ascii?Q?VE/4KiphL+ABKXjUjcHK+WvnbTIBNLP0IqMiDWrN+dQ6sxVwbzgFFrVhSsYZ?=
 =?us-ascii?Q?pcHu7YKUTz1Vrap5bzxch6TR+zvgPvlrTuQbS5e5FWg0aFGXJRNSY90jSHla?=
 =?us-ascii?Q?cRYHqecRk+qcMDES2Cr6S2CkX2rIKV/YJw+80w9qh1PZ+mXpmX7lGOpnlRFn?=
 =?us-ascii?Q?WrqTmYb2DGn7bYndotBhEJx7/Zo63Xf58fv2WeWhR5zsNMnWnczwggMEPgTh?=
 =?us-ascii?Q?/e0nDMSdd9ZY+H64vg0+cAKoMOb5PFU4hsRlR3/0pqfajFJuOaY3NNsuKrYm?=
 =?us-ascii?Q?YuHYMSyzOzZyUUcY4Nrv0dKFWFmETfpYnm1LM986egpNx1EiIwFviZ3OrViO?=
 =?us-ascii?Q?nXFqfv4yt7TtModUKRPjxX7tHN1tnXL/5owYtuQEASOgqbovTWvlS9COA9GH?=
 =?us-ascii?Q?a0OHcCdsgmEADu8GtQntsKPEpGyJOnDi91LwnN4UibRI3OSxXrrrEVkPd5Zw?=
 =?us-ascii?Q?jkHBFNp6kqE3p58zJBP36oUi4l6TzV+Sqk16DoHEwav7YFJ0InUI?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252eb8ce-e3ad-40ec-9557-08df1339d2ef
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:58:38.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NG7gtRa9YbSrH3i/KtU/403wsgKvbNZFBLQLApkE2YG0IM/OHkNiqkwhhhOUucp7L7fpTH2IT5V5ciOQziXe+QsghcOKsUXhAR12j4UvYsoNhbcJeqArme9QnJ4RmLcj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6949

Hi All,

On Mon, Aug 24, 2026 at 12:02:04PM +0800, Peng Fan (OSS) wrote:
>From: Peng Fan <peng.fan@nxp.com>
>
>According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
>suffers from a cache coherency issue (ERR050104). The upper bits, above
>bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
>have been incorrectly connected. This causes some TLBI and IC
>maintenance operations exchanged between the A53 and A72 core clusters
>to be corrupted.
>

Any comments?

Thanks,
Peng
