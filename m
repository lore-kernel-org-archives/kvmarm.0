Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010057.outbound.protection.outlook.com [52.101.84.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6A2241CA2
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843202; cv=fail; b=tgMImUyxCQEQBJiOv6FlOJNb3cJLkhABl9iXfcGlnhuOtx5D8cp5Se75zJu2Fh7+6GaKL+zvbAYNGMHtBK5En1EbGcBrOSg3w0ZOEFeGpK5es521osw/Z9UAyagWjroQeJBmwTTVY77wgdVSpaj9biqXYTIEAEqlT+WtDS3NWT8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843202; c=relaxed/simple;
	bh=Rn+It3U6fDbfs1AbCpsM0h3HFLOotGI89DVukEhGVt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EecuyQLyenR2kEgZ1xAoB9VMKlsQj/Z8gKgm/FyWIGHiAt+BIwMz+/o3yQUaGV3vcYGMZYKgUSmJUjdXcOBbnLRYTJkTUyOKIMc9YGSstBRZG/ZoNmHOaanO5oJqxwzvMgGKvP7nmFJbmWKOmYMaoQK8r7P7sOzK0eSm23mFYWQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fhJn7h8l; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fhJn7h8l; arc=fail smtp.client-ip=52.101.84.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fhJn7h8l";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fhJn7h8l"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lMzAem0VyeBBRZaqtUCzG5mR9w7vc/isRR67PYM2HdnyJnuzL62Kgeo+oga79LdNtouMz+9cAa7VELWvqIuqJgAFFVsBzGvXi/L2yvKGQw1YM1Zi8CtYkqrCr+a8tXH8xQ0TaOH75sYOSwlPWtvqRHx/xjwYFyab8WtPzrwtXYzkLE1nlDubrUyL93KiZvuaJ7fg7dngoaXJF8wGmbC2StYRwM9kLgbVRBX6mzuc0vwGoCm3wYkVxMhGOxA6UgkTvmX+XKmQhybkz83PZvuUrabnVHdoeMfevoswOikIdvnHAwGNKWufytzdq7t9dCs/BIMdyHUL7WXcKnxYsey8kw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3k+P3HtTFx6TKudEOBGfXZcHZsz9nCMkJLENvkQhY68=;
 b=w61yDcH0/k3oKWpgQeQPPqtnrB8Y2IBYXy06d1N7rzpq0PxBlgvi4bZkC3unDhl477Ak7+XjdiRvzlwYcvW2BTFm/gvDXMAOlFg4bfSg8SZtQpqBrl8QcEZh8Cy4BLRHzKh5j463ZNHw7llfOuwo5KXa1KL42CXzLzgOidQR9ZeP6Pb+Q4KsVh48g2s5tw3rmRCThb+zWK5FclcjVQi5SRuiqp6iL2LwZBM3a+HEzvg6FY89w3Sv9vzFd0OTJ7SGcSaQ19NRC03IHkfz5LzN1sGPKJtxJHeWL9/2Q2foMDsCZZ9+6rhs0nGq44Gtd/mu3q+4uttpMrDRPETfb1OPgg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=immunant.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3k+P3HtTFx6TKudEOBGfXZcHZsz9nCMkJLENvkQhY68=;
 b=fhJn7h8lECDpWGcpX2y/EJbtca3nUv9+1yzRQdM02nMnsOY0fq/hc+yqAYtnyuwt2Pi79MNKLBI80GpFawT5kOKmRIrmN0NvH2qAC0ufFx75HSbBo7GRMv3Wr5NK/FSICY6lkJv6QO8buMCnLgst1L+wU5YrlQQZDr5a3Qufm04=
Received: from DUZPR01CA0178.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::20) by AS2PR08MB9497.eurprd08.prod.outlook.com
 (2603:10a6:20b:60f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.20; Thu, 30 Oct
 2025 16:53:13 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:10:4b3:cafe::9d) by DUZPR01CA0178.outlook.office365.com
 (2603:10a6:10:4b3::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.14 via Frontend Transport; Thu,
 30 Oct 2025 16:53:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.10
 via Frontend Transport; Thu, 30 Oct 2025 16:53:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxZKzvpQ++wHjzFHUPc/F3wv/KOH/gzma8/j5Ft32aQgxp5H7zcza65aWndxiHy/rfapGnRG/eUOgiC+O8SdTnDGszSUKK55AALNVo5Okzr8KNj/tWot4SCNd/1IorOIJg4pSCPUApnGEy34CrPcxKgtvP4LG8ie2wVw3gAds0fz3Z0qVSOOHRTMdz3SPvRrF5V0IxxLyIcCWMnu+Qrk52u1wdOD9Yucqak6rnLd1WcKQfYwt500RMIS6yWMtgIv+QX7NEUPD6I+fB4tOnmPVUtVG8LAVil341FoUabO2m983iDnRrZcrgiSTkdXT/ealpsy+APnagCArx10O9297w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3k+P3HtTFx6TKudEOBGfXZcHZsz9nCMkJLENvkQhY68=;
 b=GJzX9qUz6OWrRzvEgvdQs10v+uXvTaJx4Fll5ZTrcn1s4I8mpnTSHvOPDPi0EPdCkUEHOhEE9cj5WpY79byEAViyA+znrg3d/1rJextPFahfgpz8OaknS1VjCeplFpL+3FCeY4MOD9fZqWPlbkxf7LUp9EnjX5Yt0Jp2N0Lip9b6wIOzFZjdYaWnqNiWLLLpQSKOJZFR9ddwI78Nv4NrRkkXrQ6Srq7qxbFF1X1q2pu0H/yCzycxmr+TCmYbPALLnv4ppnZUNGDDrvtaI52x2wsF4FjrLiD15dB3/v3qfLG1LLFmnOOd/bSp2ouDMuWIs+XnoBxzPN/vZAPCx5cWvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3k+P3HtTFx6TKudEOBGfXZcHZsz9nCMkJLENvkQhY68=;
 b=fhJn7h8lECDpWGcpX2y/EJbtca3nUv9+1yzRQdM02nMnsOY0fq/hc+yqAYtnyuwt2Pi79MNKLBI80GpFawT5kOKmRIrmN0NvH2qAC0ufFx75HSbBo7GRMv3Wr5NK/FSICY6lkJv6QO8buMCnLgst1L+wU5YrlQQZDr5a3Qufm04=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU0PR08MB8044.eurprd08.prod.outlook.com
 (2603:10a6:10:3e8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.20; Thu, 30 Oct
 2025 16:52:39 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 16:52:38 +0000
Date: Thu, 30 Oct 2025 16:52:35 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Per Larsen <perl@immunant.com>
Cc: perlarsen@google.com, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	Armelle Laine <armellel@google.com>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host
 handler
Message-ID: <aQOX06LzMlMm9o67@e129823.arm.com>
References: <20251030-host-direct-messages-v1-0-463e57871c8f@google.com>
 <20251030-host-direct-messages-v1-1-463e57871c8f@google.com>
 <aQNsrjceYM3RvY0e@e129823.arm.com>
 <fb69e006-8460-4a5d-a19e-28bdec10434d@immunant.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb69e006-8460-4a5d-a19e-28bdec10434d@immunant.com>
X-ClientProxiedBy: LO4P123CA0068.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::19) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU0PR08MB8044:EE_|DB1PEPF000509F1:EE_|AS2PR08MB9497:EE_
X-MS-Office365-Filtering-Correlation-Id: fc8c7249-2012-478a-3817-08de17d4d029
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?W0AW4Q9ILE3wN89G0RXv/aC0afQ0RR9braNZCLDJ6wiFX/YhmBRDEXL48b0g?=
 =?us-ascii?Q?DZ/PWhrOvtSSifUUvJiKJkfZ1I2VaxzTykXM6HuOSx7KqKi8SHhjaeCxVC1k?=
 =?us-ascii?Q?YyhD4PA7sU4jYRkKR7nPXFYLOktPV8Mdq3dYtBu4Z/aFjs/2Wc8HNY3ywrW0?=
 =?us-ascii?Q?zDhEJEWRkh1tqg31o60Ta4p5pzXAOsBZHkSyjMKz5IUUxNlVRPdpeMnkJGN+?=
 =?us-ascii?Q?i663juX/swVJpc3RdythVAnhQmjAtwVMO7u9ibr56ibRtj1P4n0p8oIzE7RM?=
 =?us-ascii?Q?+yN5DVecl7Zz8FWtXWzDoKtG4ENePU6DuV0gBEBFCUM3SPzgiFnKVRBrXgiM?=
 =?us-ascii?Q?YvtC1gJpy3n39L4PzqwMeGW8cxxuJDlZEtitUvsqeXn48QgWumNA71OrAr+p?=
 =?us-ascii?Q?DdyI/O+5h0PvYrMX5wXlC2f2MB8ECJqp+qvL7PkbN2kZaC9mu64s8cUlfUcr?=
 =?us-ascii?Q?5AtVAwgZakXrcChk69Vgp2bArzpRKmkMD0S7CDEcfBjTHDmCIrFjz8gWCVSO?=
 =?us-ascii?Q?7aSJvRpYK9KuPTLBBVs7470HyW676KH6/CMrrnIfRMoKkwZlZkQh1OUW4Qtf?=
 =?us-ascii?Q?zrEmXYHn2EOWUJR33vmDNLJFWaMd78C540V+4l6ZyKdJm3WSJrTv0G7DWrgD?=
 =?us-ascii?Q?/W+sVNaLhWpSN0fGGCgLWekxbIsueA5u5uyERWLv1mcTGcxhI5BQkMjHTRHj?=
 =?us-ascii?Q?dqJiVm8SHd/wdbKzdcPmEBVlJgJUzKiEw/vWOj/LxrFIREPzZCQb8z9Oonfo?=
 =?us-ascii?Q?sQoscaDNc6nVcbcJs02RY0rB+8VpI5xLMH4bhQhOJtyioxx3sqHU0+Xi9XsV?=
 =?us-ascii?Q?w7fqGTYATD+crwAlokGexx3CpN5L1sGKuGUibXNQDqBPlfDp2gw+ZykmG1C6?=
 =?us-ascii?Q?RcX5zPjVdIkKmf8GeWe14H8yoFkCt8oxfp1vmzCz2H+Pn7tFOTgmvno6bHKN?=
 =?us-ascii?Q?BWZkYh2X+25ZM/J1CLFw5nD1WT6UwHegiBqWMBA6P/6k9YH+6hEuYWjaUWFd?=
 =?us-ascii?Q?k2ddBadypJz8er5f0tuqihOuqgMQLPk7a325lcqxjEi66Qk2JpjjymNho+RA?=
 =?us-ascii?Q?aUXnotYdYA0GqSsCXQxb6qAnQh8p7IsVHipjxB3Tm2iGSepcj3Z6VsXXkEYw?=
 =?us-ascii?Q?oieI2wH0nAkKDUjrwQv8B9cHAq2f875TI9eOgn/bQOiVHkR8N1Af3lsrkzlC?=
 =?us-ascii?Q?EjBRGP03Qs3eFcKDkqy82Yxjb9KJv/sOIBpLNDZ6l/w0lUqOYwpjBYKBWX2/?=
 =?us-ascii?Q?/4unEAx5HCm3NWn7hGSZ86MeILigZw9MbZztAYXSoj66G6NtEi5YChW6yiC5?=
 =?us-ascii?Q?3IJVrnxsFQ7j1G6KZsXvRPYXv7vd5xxZH+Mt0bnPhdHllB6x+lkev+wnSN4u?=
 =?us-ascii?Q?WiR1+DaJ+m6hlSxpFiz6msb3q8HV4CLJHTUtk7WUIyLcHqZWnQ=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8044
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	84546348-5b73-42bc-9279-08de17d4bbd0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|14060799003|376014|82310400026|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WMtd+cCqANDH7+XpzcktLIZ8AZ2Txkxov5NkEtCQGT3K41JO+lageXFE9RXx?=
 =?us-ascii?Q?nvCymM2BAaf5dsFjHX9J10SuIE/7nrd5zT62++QcEqfD4/DLN/cShaq/r1JR?=
 =?us-ascii?Q?7idikZMl4W57aMq91gqS14WDEFhOT5WbAz4RIv2DQCjK7cLAPfO7Z99yHPoi?=
 =?us-ascii?Q?Ng5BlmH+bfNnjj6TzP6DFGq7pRZRX5UHnMVLAOHqiRgln1gCGr7tm18qAj0g?=
 =?us-ascii?Q?WEH5prTP66zFNgybr8gtIQwLQXD3nOniGxHomGCZHyPaZTWkOBZYlvyetI2w?=
 =?us-ascii?Q?xnYYPKX29oo5Dzrh/lhM/SmFTuwuGX7B6Nwb7y0QxFDWxacPRPZTOy/DmYrW?=
 =?us-ascii?Q?Q6hpGjoutN6NC8HQoT2pnGI46rdlacJqUyHs2lx5ka9vlpW/4TCa4CcG0wqf?=
 =?us-ascii?Q?geSoRJ2TOc17KBMOcL/IKn7y0s3F0m3T8NQn67Bqq4FUnNJxFnGuFhrYkq8R?=
 =?us-ascii?Q?mv31PimeTKkZyCM1yFI/rYNZbFhlRl2AQrNfVKXqXBm5NqdTnLi7SlfbU7o9?=
 =?us-ascii?Q?wBSKp9vl6avFXBLIhiXc0Wp49Nf1eQ8NbRdzjgajpcru1ZsTjHjyBy6hPKxx?=
 =?us-ascii?Q?p6IZOCOOK2V6Q19wUjwQX1yoiivHm1ifzjDBqeAD/9+jiKTF/NfHFKuYwEzw?=
 =?us-ascii?Q?hOYEvVAwzgexjpZ7qURNrzaNZQS6Ct8CBwd+SGkaBcy67DVhxtn0mZm1G093?=
 =?us-ascii?Q?D9ZrKI8ML9o2XG6mo4SX8xHGJjGuzNuBmQO3MokZKRUwGz34aY7AF/vKz+VS?=
 =?us-ascii?Q?oNx48qZOSO6u3a6gyH/c1heRCqpc6up/Qcj9v+Jcq2Rj6Qgoc+RkoahFpr1B?=
 =?us-ascii?Q?wCHtz2/IOkaYO2upbXjcIiOSMw+sTPERSAoCEPUoxJYqACAr5QR7syzSnNuF?=
 =?us-ascii?Q?g7JvNqMUo6L5carMgU880LPTReFhpYvlX7ZmTw8DtUsxwa6MDGyQxxRwKfba?=
 =?us-ascii?Q?OJFVXfKTROqi+IGDjR/gR/+OkcB/PNCjn3JXsFEBEFgKKJG4SiB8A0B6f5/K?=
 =?us-ascii?Q?rqeJxhhGnVIeSGtw1D2NcoMp3M873ROLynMUYKd6xdkmyu2cyAWupyWiznI/?=
 =?us-ascii?Q?odYJ8/bpqUATBPgHYQO1fuq+xvVsfP1aXIfaflal8phEgZt+XAcr8uZmVua7?=
 =?us-ascii?Q?DfcV4BLOnDPqn6he2+gy9r7spLA6j41bm/UjtCZ9XpedGp9LoD3VHr6kjO4Z?=
 =?us-ascii?Q?HQ8DmiCfDipu/GSgDNAxLA0jNA6uvXU+ywW983VX+GdUHnag/1aMohbScMp3?=
 =?us-ascii?Q?LGlg6HhDxC2mLsHJh4bJggVCAgFt4Z4Gx+wMQzH9Ku1GSNF9QVtv4dxy787X?=
 =?us-ascii?Q?DVG6Ble68lCgwNjUkFO4l+R6vc/gWMLITouqWmzivihjVUNbYuCvAYJgQ/jo?=
 =?us-ascii?Q?o1mU5llkiyqjDVbKuaJTE1Q235wEj1OepNSOZsJYStuJUhYQrlHooa5q3VVp?=
 =?us-ascii?Q?6AhCoCaG1OHKLK9IAh1C4OGufwh6bjvXW8soIJjK3zKqidxffy4x1bMqWRRJ?=
 =?us-ascii?Q?z1a+yOSAzP2zHWiH93fU7/PKmFou8NqNbiv/?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(14060799003)(376014)(82310400026)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 16:53:12.4808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8c7249-2012-478a-3817-08de17d4d029
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9497

Hi,

> >
> > >
> > > Allow direct messages to be forwarded from the host.
> > >
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > Signed-off-by: Per Larsen <perlarsen@google.com>
> > > ---
> > >   arch/arm64/kvm/hyp/nvhe/ffa.c | 16 ++++++++++++++++
> > >   1 file changed, 16 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > index 4e16f9b96f637599873b16148c6e40cf1210aa3e..191dcb301cca3986758fb6a49f15f1799de9f1d1 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -857,6 +857,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
> > >   	hyp_spin_unlock(&host_buffers.lock);
> > >   }
> > >
> > > +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> > > +			      struct kvm_cpu_context *ctxt,
> > > +			      u64 vm_handle)
> > > +{
> > > +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> > > +
> > > +	arm_smccc_1_2_smc(args, res);
> > > +}
> > > +
> >
> > TBH, I don't have a strong comment for this but, I'm not sure why
> > it is necessary.
> > Since it calls just "smc" with the passed argments,
> > I think it can be handled by default_smc_handler() without adding this
> > function but return the ture for DIRECT MSG2 in ffa_call_support().
> >
> > Am I missing something?
> Calling `do_ffa_direct_msg` from the host ffa proxy ensures that the caller
> has negotiated a FF-A version with the hypervisor first. In turn,
> this means that `ffa_call_support` can use the negotiated version to decide
> whether to proxy this interface or not.
>
> Moreover, `kvm_host_ffa_handler` currently proxies host FF-A calls. Android
> also proxies FF-A calls from guest VMs via a similar function:
> `kvm_guest_ffa_handler` so this function avoids duplication if/when adding a
> guest proxy. This function is also where one would check FFA IDs before
> forwarding messages (to prevent spoofing). You can see the downstream
> implementation here
> https://android-review.googlesource.com/c/kernel/common/+/3422040.

Thanks for sharing and clarification.

[...]

Thanks.

--
Sincerely,
Yeoreum Yun
