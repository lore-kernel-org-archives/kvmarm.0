Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013046.outbound.protection.outlook.com [40.107.162.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358664A5C40;
	Tue, 15 Sep 2026 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484409; cv=fail; b=HKgip2p3RTapqdFNHlM0zYXCPt06ZlSZJFtqVUHd9vizm3jU0GWVODe1rh0Ercdx0DH8ociMUigK/aqQfebDFH1PeMcgeyaTjoC+W74XLwUvTbDj7NAXeCiNZnmlAS58kjzzrkGGi2Xk7KUta0gMhgPD80iXQ/tZsdLRzg+i+BU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484409; c=relaxed/simple;
	bh=0auyx2lomwVaKSUdkWpp9e70rH04UgFgvJo3SwDTofo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NnjtXL2zcJ9uWz9k0GaEbmQnlMwrR+9EroQQuVjFcfd/D1dujM+tSgjSHebIPlWXpalo9TmLEicJyAD6AKkwEZeHzu2wLV73aLIPUIGL1TW8IboZZQVm80WtASdEC7ifsxChfNZTbgBUY93UEHmBDxzulcK0p0rG4QbDvcWESRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ISnungqP; arc=fail smtp.client-ip=40.107.162.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ISnungqP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqikUiFoxbzivzIt7yw5+NVInruII5NrnLIoVOveKB+yNN9MeoFVj06FiqswGhKDcbRW0nOpGh5kVdHMl6APfJFM5UktGQih/s1y1Oba0vYsSUidiRpQWvLlIRx+Z7KK/ef9JYyJpjABTZ1KhmigkQvBlyo9gCTr1CG1yx9mhzgVQT54Qui2CsR9pAJvKM5+E8VIcyXomblRHECzEUYyWeBpfViFkgYVm3MgQPmxFwGey4hE9ZURSg2kh5MD2hqdvjmwCA1KqczOFwrrgkGNUUvIKs66m3Fl71pcCfDZr+YHK4sc+1qXipbm8zbBRH/NLVVT57BTOEhm/hF2oONfMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVpqtsG2pYRd+xtzPatxWn7lVqcg2FxLxNjHxUCO+sM=;
 b=yYWNOGENf6PU8ufrYMHSvO/NP8i5B/MzOa0swVvPkBozaF5TTjL64UZmKuLc2icSfxSbMXXJu2s3akQoPSyTXQMhyLadiWNIxNz0IdgDm3d9JT/qCbhh2dZSWWbvBjWQ+jZkoUoUV4oCwSjfG323PHaj17ct4c5jrH4u5aq0UDyhUoFNZJB+8SNY8uvaNx9fF2isIbpe18KV5abYof6tOt4uTFJ3/kF4AH/k/raQgdnYY5PiWQTQ27LNf61+7vkMEfLF/+CZRJa0NpythEbt1spzcGn/KmiNs8jRKLKHQuBIzeeqAa5C4znF8D9OAc8waRr/p46NgWU6X3A2MG4FNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVpqtsG2pYRd+xtzPatxWn7lVqcg2FxLxNjHxUCO+sM=;
 b=ISnungqPzCgBYfAagNqBO9cPC5L94zy8/2S4vvP7dR/tKrAftpKz2B09KZAn40R6/o8mu+HrxI/yXNfxPwyGVmbmAt1sfRNG4wvo9ReEKlkbayfRL5WoAIBfrUTO/K+VYNdFgEyRrmW4SAo33Ht7IHD6XEqqnTzbfymtTdCT0QIDSeNgkVCU0aCMI4ZSwtRKucnoOyW33+EGehZLHfHWsgLMnFPQB1dXlNLmriV2e5/Q10r6ozOblwcQ/rxUC8bdN5vxkqvmHdoEXOTVGDyAS9qJpnYYKRDvQjukY/GTLNkKR/EJmbD36v2zjusP5IYjEDjBKFzabndyvdUFobdokg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by DU2PR04MB8966.eurprd04.prod.outlook.com (2603:10a6:10:2e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 15:00:02 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.008; Tue, 15 Sep 2026
 15:00:01 +0000
Date: Tue, 15 Sep 2026 23:04:18 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Franz Schnyder <fra.schnyder@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <aqlecgN0A53h6LGb@shlinux89>
References: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
 <f5nfbi2lmc73wtxxmzs4damrjtd67p4eb4p2zy5ssqrc3wohne@cjcxqua5dps6>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5nfbi2lmc73wtxxmzs4damrjtd67p4eb4p2zy5ssqrc3wohne@cjcxqua5dps6>
X-ClientProxiedBy: MA5P287CA0325.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:222::17) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|DU2PR04MB8966:EE_
X-MS-Office365-Filtering-Correlation-Id: 5333b091-44e5-4af6-b136-08df133a0483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|19092799006|1800799024|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	YhDK1J33TYy+Ou8mOJZnOvl1CffnOzF/fat9EhJJ8iOe36HJOb5WcF1j1dAexS+OApad7PkJ/OXWDpIYWI8fJPMdllY4h8dgbAObeFmzWsjDKnXZjiA+Ia2HhtDDraLWeFanQ3UhL7892KQKXk+XJ/0iZp0t7j3Q6eWjG5Y+ByZMCQpiESaJSYvQwjcHNmoPgJTBtO52xuiPqCRUxCqnlOYFaiPGri1c5kmCVuDzkrtVU43F/BJxk1tqdSP2Egwxhq9AiScN2NBGU2D8m6EniAvM7DbK5IkMHdyUKaq0z9CDngTSTnCtedfLbU+JVQ1A22Zkhxkdbh8LTwG7gbyTqg7xNelMQ1kzzAtF1VWEFvI9ZgmzvJcX40m5zq4liOJSS+bpWX7lWD46z6nFIRTfPubdEQSoDeaR5dcFOLT2TazO4AmQLOpUF5Soe/R7Itv3enHXSMUxdk4PQJDfeLK+UJ2pc6xRTdK3GgdvpUG8PFHgb6H33/sDer90Jeor5JygXzCYf1zlZpVcyDRZ2FxLDoFkl1MQBqan37F94o0/FQF0uouy5E7Wa6D/aKgLmQ5xnGPA/wZSRDYJwZxeH4thYdDEPrlr6Y46ImOtrj93Kgbu2KMaLFHOXbLAMSProdk2fGDjhAvs03yZ8IYqYDOYnlFiMKsl5IxnCVqeWYI+rZc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(19092799006)(1800799024)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ViwHQPqZfHPpTjwUarAtSSLHc7wYSbeTXtMn5/7qseH3EUI+65mymmn+Vd6G?=
 =?us-ascii?Q?w8nQMwhNpKTFno0FH/94AQThbH4OfrqGTyVr/eShd0lKCpqR0csIx3iGNWEE?=
 =?us-ascii?Q?XO+P0kgPoydG5Erm9V83zGwSQJDNT5R+M1W/H30SatdcuYYqWeD8oKoFQKOb?=
 =?us-ascii?Q?2/eikYTqf0LcNnmjg6W0EzRKhyDEaYBWaj7KxhmyesyFKrnczIjSr7+wqOem?=
 =?us-ascii?Q?t+jGHcQyRaC3xX4lIgDnGtUc4A41GGqzBkDATbAd18wavJaaVCn9TBOcrBP7?=
 =?us-ascii?Q?GSrdklWxtXvd0Xb3XIi+xS0L43a9RvNzTcgi0OSAl5ApQnykQk8Lej2R8HK/?=
 =?us-ascii?Q?B88rZfjtGEHRqxUBEjRwNZsXDNt5v4AiHV0Pm17BLnz9qU1eG27RDB6TVBK7?=
 =?us-ascii?Q?deZouw1ayEL9DANXO6eu9ZBPeST6PZTDjD2sXqgehjlu7Y0rmzau6ZdRa8s+?=
 =?us-ascii?Q?Fq2j42nvbAq32oGxIqAnAXjxyJ2F2rixvzYsnoE/6TiHwxp0rii4m2a8lVz8?=
 =?us-ascii?Q?+HxPtxWZip/lNdGOR0tHF3bYt9Kd/MtXJNNBj1kT7iehVrjM00bEeXpkvsw/?=
 =?us-ascii?Q?+9GzyQRTw/Lh9gTYI9+IZ2rhaiPtXcSK3jkQm+2xTW3gmdgTWdjF6GL+5lY4?=
 =?us-ascii?Q?SEmZ4dPEF52vbUYR/SJIQXWCf46ng+eCmbAyjtRcOfF5tFGaZwp1oa+iC09r?=
 =?us-ascii?Q?IqB8wWUEJXnIyWkH5Wqyx+d3FPghk//E8weFVluFLlMS1DusRgiiHjJ+q8B0?=
 =?us-ascii?Q?6S/3q3BIYzY4bac8ccTX1JMRsqvj3yxi37zdva4KIZn2MqJmAzsPN1Svv6nY?=
 =?us-ascii?Q?aaiOo4e/gZsL9amUnhesiKfCGQkCJ/UBZ+jBf5OpJZDsDVwveYnbdlugtJ2e?=
 =?us-ascii?Q?gsA7aTeb6BeaNdc+aKygWwVzABYYmT6YrrpTLpmlIuKJtDfQiK87nDcW1obT?=
 =?us-ascii?Q?3KjZlV42RateVc6pKojTuGyddCZF4BsQpvJb18DUvhzdVDPBsqMAp9l46nBI?=
 =?us-ascii?Q?Lj5jE8J25U+sX+sFdDcf82gEo3ScM41yHDoovtqQciDcFyA6ePJCZPmiqU9I?=
 =?us-ascii?Q?XGtMfS2Ysy18zh1bm/YkDFHDoJfAxA0nf4nXv8yDIMq52EkvchEhDOauwPGd?=
 =?us-ascii?Q?1QCyzhxpYcH4JX/uJDIyYpsjI9n2TirtjVT96PM1hNrJt8HmofOOv62xWGgG?=
 =?us-ascii?Q?gl6lVZK/BY+pTglXSVpyUYL/HR+fg1GNIBzylHFiuujGW+wKCXUkZ6Wge3wN?=
 =?us-ascii?Q?SsVPa6ZRT2ZcsnPW0aiXfjTSftWt3rTIxrzZ8Dvez4purfVPyJ4/MazhNIeW?=
 =?us-ascii?Q?LKM1cZOh0Kz0LNqsBkPziLbPcPxvwp/YO2LrWdJ+E1GFQNsegm0pp2CuKJIb?=
 =?us-ascii?Q?uRe+lT1ZQL/WLIgSzppDsXG+8LJwmFm1hy25lcur01L0s6/FkdyclSw6Xoov?=
 =?us-ascii?Q?EHGZ+hPrEHpOzcYSNXFfhkgAQfQNY4LixcfCJbIf92IVqPitUOTlr5pyzA2O?=
 =?us-ascii?Q?4qzz0z89zsh75iBIpDOu4O70XQ1CktQveYoo8OcMfK6IFiGkI++9iY4htp4V?=
 =?us-ascii?Q?HnjpxCQ9rPGDy2VhBBQUYgvquxcd3sKv6a8KjFrknGiPUA1Wx+Af5XQohF0d?=
 =?us-ascii?Q?pTXks1ZM1vpoVKrgdhUNyHa82aZwBTjzLNG/kDmRh1edG0g8ID8XNC5gpWdZ?=
 =?us-ascii?Q?tqLCJnnPZP1PiITSU5H0aylhD8kCJoOpeCz+FSN7NZRGWO8+NqpjXazg7DxL?=
 =?us-ascii?Q?EkwUTByoca/AvKp5dnd4lz1YOnK9kHZVTMPYfZ1O4ld/GqvzElT0?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5333b091-44e5-4af6-b136-08df133a0483
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:00:01.5869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjiBizCqw5gBypb1dmwwfTSGhneCx+27R8YdvgNTBS3W0BujjhBlyVd/CqU/lmLIz/vICH2P2cG1qKDfDivNINNjwiFxacQGOHYzKw27JJXvRDlA0IAb73edXIHWzebC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8966

On Tue, Aug 25, 2026 at 09:06:31AM +0200, Franz Schnyder wrote:
>On Mon, Aug 24, 2026 at 12:02:04PM +0800, Peng Fan (OSS) wrote:
>> From: Peng Fan <peng.fan@nxp.com>
>> 
>> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
>> suffers from a cache coherency issue (ERR050104). The upper bits, above
>> bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
>> have been incorrectly connected. This causes some TLBI and IC
>> maintenance operations exchanged between the A53 and A72 core clusters
>> to be corrupted.
>> 
>> The workaround requires:
>> 
>>   - Downgrading targeted TLBI operations to broadcast-all variants.
>>     Instead of patching the low-level __TLBI_1 macro (which interferes
>>     with the REPEAT_TLBI workaround and causes excessive over-
>>     invalidation), redirect high-level TLB flush functions
>>     (flush_tlb_mm, __do_flush_tlb_range, flush_tlb_kernel_range,
>>     __flush_tlb_kernel_pgtable) to use VMALLE1IS via static key checks.
>> 
>>   - Upgrading IC IVAU to IC IALLUIS for both kernel (via ALTERNATIVE in
>>     invalidate_icache_by_line) and EL0 userspace (via trap-and-upgrade
>>     in user_cache_maint_handler with SCTLR_EL1.UCI=0).
>> 
>>   - Disabling KVM since correct TLB maintenance cannot be guaranteed
>>     for guests.
>> 
>>   - No need to touch SMMU Broadcast TLB Maintenance (BTM) since i.MX8QM
>>     does not support broadcast TLB.
>> 
>> SoC detection uses devicetree compatible string "fsl,imx8qm" or
>> "fsl,imx8qp" since the boot CPU MIDR_EL1 (0x410fd034) and AIDR_EL1 (0)
>> are not unique to this SoC.
>> 
>> [1] https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf
>
>Hi Peng,
>
>I tested this on our HW and the random crashes that occured when both
>the A72 and A53 clusters were enabled no longer happen.
>
>Tested-by: Franz Schnyder <franz.schnyder@toradex.com> # Toradex Apalis iMX8QM

Hi Franz,

Thanks a lot for testing this patch.

Thanks,
Peng

>
>Thanks
>
>Franz
>
>
