Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010047.outbound.protection.outlook.com [52.101.84.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90E3D9DA0;
	Wed, 29 Jul 2026 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785345004; cv=fail; b=bAwCvx6aLPQ0r0TbH5Y6uEBbYMm0/0N0Q1UNs7Ras1BXMdCaci3ixvVpWLFZUYuHsB0tcxAiHndZlKQM8f9FiWT5VwdpaECRzC5OvRjSuMkuleV1Yo6q2BKU60v6W6JFFTvQ1YzBH2ce8DwD994QBAGNaaU+YtxheoWUnBK6SDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785345004; c=relaxed/simple;
	bh=rt6xCxcjIQ+Clsux7NBxEUmzd4lY/aIPJgNJsI5hETc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AXRO7ebTOMWIkbl3KnnEVDOhd4FmA8ktTIf6awpkQC5MFBMrJuqsVJiYu5esjRQTjnvJ4MFKrd17/8dEdUwIdHjvletNljZpVayvygSF+vWXqSluWhq16AqHkRsP1slpwwqS6/lwFwh1HhXhSfgHsnig+ybCfKPu9z4AUD1XPFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=qyDRfQE7; arc=fail smtp.client-ip=52.101.84.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="qyDRfQE7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VB9p9Bh9hEns784W/Os7c607qdJTMqSPoSVtPrYRgPi7BTw9TFzQS8iGz/ZB2v5wITK0AY5tMm+Y0Ch6fHgqlf/LT6nBSMna6+OF1elZqBs7dRoB3WWrWSkVvcDQ1Iv1qSyCONRkT6ldLOBX+Xdedqnsh7e6o7hjlZrFkBILaKjvbts78PwOmG2OYk1L+PA0rE5sKesQnNQd6WRajFhR5lMZiJsCJ7Hebza01BstciRMFg/WPA3hvB9bxrQp/Vj0LssW310int1zFXN5YERguZZ5ISx4iOWGQ/jvd74wI3sgFaMucb+wzL/ejCLLXG3ybC90XZt73RuwZyLxNSwR4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rt6xCxcjIQ+Clsux7NBxEUmzd4lY/aIPJgNJsI5hETc=;
 b=pgE5/c8ecwRNBEvTiEyVNL65AjPELbVTgYlQBFwXAnstq9Njq8CfgprUv8HQsDYTqqgOHxFOJkridntaG08N5B0/lBtXyH1yjgITNtQlOHKLOraHpgztDRUkxnXq4xRFLMIsYaru/Z/JBDNJq8WYfrPJmsLps0hgISlPX1rRgYyeH8faKfcmY6LApvYwdvL3kO4EY/iZw7ncNQHCj6o7/LQ6tD+YPYgTTcCnosfjZi+bD3uRw/sBp8oVgcNjzqb0oDYQ/fF+hX12E/ilabrOMiimSCXum3pUhIR2NgWimDl7Q8LVDyZ0uTYPKevHJcDUcLuLDKeauOG36wi0Zb0lyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rt6xCxcjIQ+Clsux7NBxEUmzd4lY/aIPJgNJsI5hETc=;
 b=qyDRfQE7U6ZHSDEkexrEvMmEsQXrC4BSnvV8bAToUyep3wPgkK9Iluuex2JYyrJ0LFcf0n8HVVJL1CWz4SJSjlJ2aNFwwNbLqqKJUE7rWA/r/0+ifk0uOMJxqYz0Y7i7azNRenMrZZWS0qq+DCbjL3WyB+rwL5x6ZKt8ydGFs7uTEV5zu1fpQO2KN5Wes0nfDHWoDy446aZ9APbzGKgV8AM2JCpGMJZhdIjhQqpxUir/JgAuZF3a4jAb9eNhW+LdyjZ8H5C8z8zMCVeC0xQ9tWgh7jwyLSRTAozBFIjbn7/6sl/xoZ5YTkbj6cTAmGCvF60xpg2i7wcSqQGbDQai4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM9PR04MB8923.eurprd04.prod.outlook.com (2603:10a6:20b:40a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 17:09:59 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 17:09:59 +0000
Date: Wed, 29 Jul 2026 12:09:48 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH] arm64: errata: Add NXP iMX8QM workaround for A53 cache
 coherency issue
Message-ID: <amoz3E8Dq8pDq-WP@SMW015318>
References: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-imx8qm-cache-coherency-v1-1-c9864e280437@nxp.com>
X-ClientProxiedBy: PH8PR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:510:2da::33) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM9PR04MB8923:EE_
X-MS-Office365-Filtering-Correlation-Id: a30a30a6-1935-4ab8-fd5c-08deed94388b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|7416014|376014|366016|23010399003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YYsGnajEhFdgoF6cMbUog8hJu8KWw/QEaBOFl5Po5rUyaBK5XL0NLmEJanygsN/3M2UERQ6stQyGSo8gn+0ToDyP/6VINVMGXAAMhVW1HiIg88VnouFUuJfgI89X5AwPJSKmMAzZ8Yq6KzjlIhulLbaL8R9pwkz/bHbD3yBxRB325OISO06vXMCPxmkNiiRNFLDnbg8xYqAEuKrwvWlZvEzjU/tLe5GFFnmL1uXnjsbKagi0hUtzCJ7LfMLADR4Jgzfs2kYn68DHZLAoYvbzNeZ7N2RqOd3fMovJyEBefqnhOk1lVcXSTyg+gLsJOG+wC9ossYbimvTmOuKr0FeR4pDr0Az5pk+QsE+h6KqkkhDXwgEGgq0s9rCK5RxirroeaVeJcDOfoGR58QTRVx3P/sR7rhgUbobGSHY4NuufYyUNzpwprCRSKZvZprIWgv7L0pwQ8MAbLjykejaN2PAfB2NPS3w1xVR/NyerCauL0YTeJ43mqdNc2VAqsaeubElssIJ2/o4gM/yBo1AniJawMMwZM8VYODFD7bIrdq/2qT9qHZyIHJYb4HNL+HaLmJ//6x61tu23I3yHaoHPjwWp9suF1eEod2jy6rbvWUv6+jpIhynEQQyDS48798S5rZC58RlF8FIJ9THnStlsXLFOkxmUcx/8Wj2HK/kNaWPwRoI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(7416014)(376014)(366016)(23010399003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C3Mr6DsVBfLsOiAk4meaUOc/xVfd8Xf88zlhyiHw8IAJepb84wF9qHCerj4w?=
 =?us-ascii?Q?qLtCCRPk1KVRGFYoOyoFRZe2JyaXLnDV0FCEx/uBr23lQDuyzU7X/f+tDs8U?=
 =?us-ascii?Q?uzJEvFj7/YT5sA4cXGM95J1cjD9iFMQqz2t+tjTo+a2xN/MTlE/JavH+rvtK?=
 =?us-ascii?Q?Op70oLFCGs4j7i01uBMPcz5N4fweTeJL6Eicj7ufqL/WZYE1Rz3qG5kVfT1E?=
 =?us-ascii?Q?LMALF5uSqHkMCDnwlE+5m+Owjc53CAHjl/Jm/U7CUytBPZDnp+NixMiOO+hB?=
 =?us-ascii?Q?Pw8qh0+Xk47CzWFegPCQXXR6SBsyNz0ii4ks+GOhsJXzzCD4Q6gmCLhxRYo2?=
 =?us-ascii?Q?1kscmbFdVrYoiQzQFR0OqoWPLJQVHZwVgRdT7sQxB5x3bkav6OhTIpLAeJX9?=
 =?us-ascii?Q?TF+/Le8e0CI8Srec8tXHAI1p0NR7BFs1x13BnT/TRiMbF/zyIjLZpFM43OXW?=
 =?us-ascii?Q?2FiHljBBa8FxiCEEoYSJnynRqgxOWyKAhEzKMXZ2xWL2z/KT6gJn6ltV35Kp?=
 =?us-ascii?Q?vB13oELwHioaM49MAwFdaft8WaRDxtNbrOIvNDdAVuyu17hpLjzNRTELwWnL?=
 =?us-ascii?Q?5Mb6/l+oCe5y6fh/hHuEler4Qca1n6plQE5bARopksjXqh1Nstur1WLaiyNn?=
 =?us-ascii?Q?SUEW+W67rTasd0bwwjqFhR6Bo2X2I58QoGjIanZdjSjRIkdrhVnteES9vXT9?=
 =?us-ascii?Q?DAR92/ny9U2LWZZl945wHaF2UXQgCg0tx/W4JQnpdSBkkBYZSaOg0zay1zUo?=
 =?us-ascii?Q?6+f8h8vklZaSHWomL5NzigFYegPuI6coiEFy+j56nvodlx1SHNVaIOxbi3bY?=
 =?us-ascii?Q?ahO47poOpoG3q1s8o5NE76ARj5XF9q7/2VM2V+q2Nl1/olN3qsfmSKZ8/3BG?=
 =?us-ascii?Q?fEyylaKeypRobTAJJiNVLZhOpU7U5HATzMGZ4xkL6LAcHYgQsXM/ADeeiACP?=
 =?us-ascii?Q?LkTXZWXhGqNSxJFJyGHoi9ghnn9Bu84bHZzjCRCDFpiCzcLhM2+cDfMMwyYY?=
 =?us-ascii?Q?9I0uqx6iVVh4P3amVhb/UMPGh1UiyGoF009v0VfkvTcp/P7H3+qfAJtO8e1h?=
 =?us-ascii?Q?m8sxlQGLQb6HT2v/riK5m8+/B7GugFz1eNKHRC6ypA6x4AD/y7ZRRmgIY442?=
 =?us-ascii?Q?G2B6OaMAovadCfGF5FrhPkxjNtv6SrXlk8+eNPUUYO1STO9590PdX5nWBNRO?=
 =?us-ascii?Q?RNFT1wjKQeHe2A28BGi7kH7Bhs19ml9iLRb3WZHZi6/sjJWgPmRURdVQjBMR?=
 =?us-ascii?Q?bGfQ5Nrv4MJyIA9lD2Usj8WhMBftJ58KLCHPM+SYX73DkSEqS2Hl9UeaFqP/?=
 =?us-ascii?Q?8zU+XV1QhirIqXk+nDP55EVDttUnSa6KNjmX2p5apm/HVWd6tPS0wy2FNNQY?=
 =?us-ascii?Q?s11b7FSdnmk2XvYaA+i51BX0w2DVKkW4l5/FyLjQJa02hP2neHvPhLmb47dM?=
 =?us-ascii?Q?WmVT0lgSZHrU7v+3OHODk4QKyx7LFXNbYvoPk4aVmcKA8HBFaPoQouMN/7Jy?=
 =?us-ascii?Q?LIn/fh3mRa/VdZSi2QG8d4JI30NzzyLmkk1vXlb6Vm34xuprL0X+hDy3Jzh9?=
 =?us-ascii?Q?bfSkNDPGmlMHhYj2iYw2Vnz5WgI+O1m0T+SOLkKuojslUDce3FoJPs5fV3ZU?=
 =?us-ascii?Q?dWXoQfL6TT88d11Cw4mUeFiDto3ZosfnPjjT5JxHOZKDzeJnty63lCZiIJPX?=
 =?us-ascii?Q?AqW8TTGsUoGoKSgXGJd81sT779znhgh7mudwqJtDYYBnmVmCyQZCIH85mE2/?=
 =?us-ascii?Q?5vfUE0+9zFj0lS/CbcU+dtHVFVGCuQRmLroZVkD6gPS7fEEOBvv9?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30a30a6-1935-4ab8-fd5c-08deed94388b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 17:09:59.4470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPZ7qzldXd58xU9xyID5liNm11uS/CPvq8w+SrtWOMvNkE1d+2WLm4alDCNdCNRoULpZaSvhIGQ56RlADB7GgOomC0QFOhJA+BpMbfZqV0WurnIlhnJiUt/tgu8sIk50
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8923

On Wed, Jul 29, 2026 at 11:28:52AM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
>

Thank you for you take over this thread.

Frank
