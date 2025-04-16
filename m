Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2128.outbound.protection.outlook.com [40.107.93.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2418224A04B
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 23:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744847292; cv=fail; b=EJkofGh2lETXj5iB0oQnyxPWo7pSIAfvFdxbbzAjzLx/dZxx1AdqWSdPFjL7l4oRvCrj9g7qmhK8x90eoqk/Ugn5VRMa1kamCyNSrMn62YjrxponUddofOSBbm3gXFtXCuVwildMVwHOPwPRIz9W3ri6fb4MqO7SIHUC2PH7r0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744847292; c=relaxed/simple;
	bh=iHGJbUy2lPX4RaMCY8H9ce0snTS7ckrtm3R+QC+MhAM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=bKrM6gmXy0zxbW48+6cKBzBiqj+42iwUBWCcqVRHAF4+0zfafW4HMHfuOKqzAqT7dY2+geVNcTr5/wEBUb6EsJ6GbPM2KSoShzT2aUlRHry2VJq2//0l/j/gkSb/3rOhGZmEErzsURuKFHsZI8DA2HGOYQUaZTCY/6AKxyS8Jnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=ZArVtwS2; arc=fail smtp.client-ip=40.107.93.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="ZArVtwS2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aqS9g42YkMJzewpCTXjQpFvA+lYW9UP5r5dA0J05IAd/zUTUVLxYdYSCMI9pf7E2WfjDx/R1beQNq0K0CiKGhsq98RYlg7gekf/asrrYQReWQEgv86FPSd5vOkHueRTY3cHJ8LglbCFobBbB0Ku7OC51v1WMa1a4o/F1iGD640d4P4Rgpx6V96EIbrj87oJ+b1locTSV4d9f96/sNcE1D+6c5pTSMNCGMUYmlhLVumBBEByhVUsBtkQJaJ7xYvxJWbAQFza6gihLNwxQLVaqYn7Y8XoBPHRoCGypw+fgLok7Nj4WCIxIRE1EwMfz5ywlMlplTTzlqjhQZ/6eZ8J+Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+l3Lvykqt+wLAVH8LpyeonpAsUGR1w9iGz5bP4jrFw=;
 b=caah8ftErmAnHxyM7OMg2GGFziPx+j4kVfU1lGiOHf6xeU82xwZLCM6P3e399Ln/0UVAWrk1so+0C4rkVuBpC29FqLH1viYJviv7fQFs22HMbpA5F+qpf3X+OxPN4EY0JLT+K0QHynRSzUuu7cFX7lEfBYzD8zxBOzZChIYNNoLcXsaNpE2SwO3Klo2vZc0ADf1+liZYGtS1RcUzUsntz7xcecduaXULcs10RHalnf/NN5to7YuRD+EbyWxfUjyFRM+Nuhsj/mnNyQczdTkyXiaNh4+Kn/fhH1Igq5w5OtrQ4GEA4mWFbuQC+N3zvPuP6Nsy5rUisuYiDenf46YVkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+l3Lvykqt+wLAVH8LpyeonpAsUGR1w9iGz5bP4jrFw=;
 b=ZArVtwS2tOlW5/bVYc8iXm+ZMoaiNcvEdsYL7YaUHQ6jqp+gFRd8HLL6eynMPPmFBx38xHZMBdRSMUK6lZn1ZLZJCt1K6d7pCbI067GXW3P0M7KSvF4ezgDVUxxbIp0SSK8f+t96X2vhHsyamDSzVtqAHG1f/Mvezl4z8lr0sus=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 CO1PR01MB9009.prod.exchangelabs.com (2603:10b6:303:275::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.22; Wed, 16 Apr 2025 23:48:08 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 23:48:08 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas
 <catalin.marinas@arm.com>, James Clark <james.clark@linaro.org>, James
 Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Mark Brown <broonie@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, "Rob Herring
 (Arm)" <robh@kernel.org>, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu <shiqiliu@hust.edu.cn>,
 Will Deacon <will@kernel.org>, Yicong Yang <yangyicong@hisilicon.com>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
In-Reply-To: <86y0w0k2c7.wl-maz@kernel.org>
References: <20250415154711.1698544-1-scott@os.amperecomputing.com>
 <20250415154711.1698544-2-scott@os.amperecomputing.com>
 <Z_6SKjdvje1Lpeo3@linux.dev>
 <864iypgjjc.fsf@scott-ph-mail.amperecomputing.com>
 <86y0w0k2c7.wl-maz@kernel.org>
Date: Wed, 16 Apr 2025 16:06:36 -0700
Message-ID: <86mscfyadf.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: CY5PR15CA0247.namprd15.prod.outlook.com
 (2603:10b6:930:66::22) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|CO1PR01MB9009:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f85bf48-0a32-4d9e-fb29-08dd7d4123e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|7416014|376014|1800799024|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rX5nV4n/6KLR85X7GemJVoookAk0q6c5NSg7sl/Npc8QjlbV30Gmyc3KRZjX?=
 =?us-ascii?Q?ONcTwC9NLRlc2rOTfcg9/KBlu3s4hWVGu8uGoPEAebbcpqVvg0f0MBbijzAZ?=
 =?us-ascii?Q?CmK0g16I4XVg98/ZfvU7QVBSRDIJ8xU1qJlela9EHk7jueJKSP1AH5IHaSZz?=
 =?us-ascii?Q?dv00Da7DoB3KCoqAm4wAj9ehFy1E7luGZCySpS01ii8gIqlAIE3KpJ+omowd?=
 =?us-ascii?Q?bNeTQx1+/HlYlgQg/lc2WE4QIomwu+qrm/kXZmoE2DWSyi0EPOcB/yBnQjHS?=
 =?us-ascii?Q?BPfrFxWH34pGkOz29dgO0ypAcnVPJlgLxe9TaIVVY6Syxu5ZRMEO5Kox2Vci?=
 =?us-ascii?Q?sWxTjdz/CwSUDYLiSx9Dk0nPN5WK7+1FDSf7FTR8N7XMiHq+oUfBSMUD2TjV?=
 =?us-ascii?Q?t97O1yFBnHzcnN5xEbDauxnJbmrCpDqVWeofW5j8vHjesef96CZUdQsNM/r8?=
 =?us-ascii?Q?7Qs1x2gmJtiKDQCEv7FfShLIQunN6J1MIGJEqX1YEggAS1RkOphe7cnD0DtD?=
 =?us-ascii?Q?cpEfPsMBahqVQG7G1tN+7+lZiqys4hjG2BLxfWXQUiqgCNJJF8jrEH+e86JS?=
 =?us-ascii?Q?Dqpm6b8Yq77tYBzBNTTrE2gaDDwqyIc/MAif7VuCT8BLbpMyh/Je+TZt3Af+?=
 =?us-ascii?Q?tbGGh2AZu+q6O3xx7O2+C/+Vgdsf2yjUtLgI5qU+ShMhjSzpGf4fDUvkGAZ2?=
 =?us-ascii?Q?9S2gcNJhm3UF7n3Aq1QSXy/mAK0rebdgKvgAJ2QvXkvO/DMJ96ghXsgrlWu4?=
 =?us-ascii?Q?SG/Obz1pu8+f2DL0s3CCcNf2D4OPA5WBXK+Quw/on0E0TgZFHhdL8regCBrF?=
 =?us-ascii?Q?I2Vm2EE8S7h7vTAOvpDP7Gk71bsqrwuCdeCVgvZZtOPPYIzVV050L0bG9lJM?=
 =?us-ascii?Q?R/c1Yg63g5Eqz+NojZJOyLgdSXvnkAMLZy27sqW7YeZivAOd2oVnt8lcInKW?=
 =?us-ascii?Q?v2zpgx2ZLdzFd6nIoL3gCvgNc6ZJ+CAW+71BL6075bsuWeMXkwYE50O38UPH?=
 =?us-ascii?Q?XjYPyySL2PX/y62wnCZ8vMGYTL+3BBP6aqtoIDYV2oxovGi25aFyWl4BfUlo?=
 =?us-ascii?Q?9j/wIOQkn/kjoEBbDsaurjXmEfRVBS/XZdvQCAxSKfWRnI4cPgAhl1zxrul0?=
 =?us-ascii?Q?hZxTzZVsQ9TY576eWN5oobly58v4zilTOqGm0RFuFdOfGA8Es3LosAJ15D3e?=
 =?us-ascii?Q?eJsqf1Rim5y0Ms/aKxwGA6kMjt8d3JKzUeIxFk7AVvndsbUhptwTjXt23qVm?=
 =?us-ascii?Q?uZwnPVNyC7N+yq98LvuVH8Ez+UVlqT89f10LZxaZ/PRueUthWJWevFVEQX0n?=
 =?us-ascii?Q?M+IfIQZpHUvhvzzR6D9voxGDK1y79NZg21PYXaQemE1AHz0LHVCaaK07LJAS?=
 =?us-ascii?Q?JQPmAtKXapEc/JZflP0nTxYnqKjStIxA4Uzism8svyT8Gowmp0/r0hBy8zVx?=
 =?us-ascii?Q?ZC8k5Vc0cYFdpbW1yvB4POWNkRut1Y3oGrdn3VvUyb5fZjqDDV4ypw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(7416014)(376014)(1800799024)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QzyzC7y3ku4V8zyHrsiJAr5A7Dn+p0+yVw7Gd9h8vuaAninIHu9ohyF+wtf2?=
 =?us-ascii?Q?Uxtcm87ON+tQ9eXDyFbrDU4NQpkCgvwRg4T7EDC6zisu2HD/xNcyAX5Vth0P?=
 =?us-ascii?Q?0guu3dQmgkjBh24gChhyTr1WtP5RUkwf5Sr9dwss01FpDlbUOMsXk1iursTd?=
 =?us-ascii?Q?cwgjxf7GYKPgsFqL2dcGdWXUl7LXsbJO5NwtpNxKHpZGQ7dpZfRGiZEfACan?=
 =?us-ascii?Q?mVEGgKJxY46TTstniQt6hcb+iAAPp7jlevx0wsl4N5HvFUNDCDew8SWfXtHX?=
 =?us-ascii?Q?OaQ3qPSwL3E47IuyQY/GYM6C5CY1maHXrYSI8h6r1nTvSMSSGLa07SqGGt3s?=
 =?us-ascii?Q?KamsVWljSDKmB9t8Kx+bIMTQBy7MbgxohYZCWS2A9U2weznrfOkHOqG4SxBI?=
 =?us-ascii?Q?xP7G26Ttyz75Kb3uzVF/cPI5LsDcBjc4wfb20cTRGdocsWljafwOMvYdlE83?=
 =?us-ascii?Q?KKf4dANbSQjS3rF/OTJvQKET0cYFvuggZHdFKv9CYpEVzB5BIH2YOoXGnjzi?=
 =?us-ascii?Q?aH5qZFyiXllH6S+iWnoO4ByaQhGBtyALOy3IS4/KEt63/mTwNGMqZmp4LKom?=
 =?us-ascii?Q?6qWeEVx8CPH9ZbE64PlkRRNmBp+TTErDvAoAoJ1cmE0HvGnZ0uU6fSGU/nT/?=
 =?us-ascii?Q?IIqiGT0kofYiKWR/V1c9J3pUMI13cYvhOyHlUi1VBvprCzlmEHCczgtbBL4z?=
 =?us-ascii?Q?JBgrKnmh4FMX9xEoidKXXKWYdEeUT+aj/cwWyvdJlAC0WJvGGoCigVkURMgr?=
 =?us-ascii?Q?dNgcf+lhZn7x3ojb/Q1bmdki/oRRAqhkNtENEXv30jlkqQ3+H/V6YSty8vCC?=
 =?us-ascii?Q?Y3IHjurfqNe3jaRPVrfolneyGhX6Vog5CDg+Newj+Q26bwrHhuCUewbtY2iu?=
 =?us-ascii?Q?BoAqZhxAJ6HKFJ7qERevcuhVGJvNlFh/sYrxFz5EzVSDePTO6wSTkv2yS2z2?=
 =?us-ascii?Q?JTJCJ2dkPooEDGl9nhgiiKnB04dkDzGK8qHg3bIqveum9bcWtt0pAQJKaCt0?=
 =?us-ascii?Q?AObuae+6Wf+p7EAH6v5ZzCC9hbSzG8kqvSK37iSqsdkCc8YVmq51DTdyFVzJ?=
 =?us-ascii?Q?VK8v9laZtcn4Lgn8rGYouVm4m9OGAsdtY3/o2Q65RA/yDjvulrI6I49IzvEi?=
 =?us-ascii?Q?8IZcX9B7gSWLhwCjL9kdkwkx1yP3IkOQNU8MLqpuoVnAhKdlR7iIogelFMaw?=
 =?us-ascii?Q?zKTN/X5AFwsUqPl0IDYLYBQz4ZHyIi7L5uO694raM8/J6qaf5qrEMgKQEquq?=
 =?us-ascii?Q?gJcIEbRuTuahrIAIYZF8XjP9gzIHRJ2IDbl85KeymuaK9T08jaEAazGerdjj?=
 =?us-ascii?Q?g2lw7iH2RBsPJvVGKteVRTwv1prK51CajtevTXsaZiyVoJ3vFKcpoQQOcmtf?=
 =?us-ascii?Q?abYCy/GDa8m1x+6fg6etoUCbSfP7o3CkA5mLjgnLio75mnoxUCelYMEO42OQ?=
 =?us-ascii?Q?WrY2WA5eo9rA7ImR0Rd/yWFzkPyG17xgEGhCFGGZuRpHaagdfX5aILT64+nZ?=
 =?us-ascii?Q?umGik5MaA+RtE/DyPadNUDYng/rlsX/xnu+ZyixxdLtNoqalE3ZNpxOd/HC3?=
 =?us-ascii?Q?9PGF/SkvUnPTvS8ofCXPeyHkdcDfagu0ERhP4egqPagexFSckGtfTuvWBxkM?=
 =?us-ascii?Q?TLZUUPKX40KKDKSuaN84aN8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f85bf48-0a32-4d9e-fb29-08dd7d4123e1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 23:48:08.6168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mq/aEcpkm4Y7DBtLqOS5DSc/bNpFoR55T2bAkO1trkLJUnoRYENrRWoIjRI/Y+tc/1F8WcTAzexwn6meKyCNKYcQnOosY9CIyiwhws45y6u5QCQA28vC8TaabI3RoP1P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB9009

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 15 Apr 2025 23:13:43 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> Marc Zyngier <maz@kernel.org> writes:
>> 
>> > On Tue, 15 Apr 2025 16:47:11 +0100,
>> > If the write to HCR_EL2 can corrupt translations, what guarantees that
>> > such write placed on a page boundary (therefore requiring another TLB
>> > lookup to continue in sequence) will be able to get to the ISB?
>> 
>> Hi Marc, I understand now from the core team that an ISB on another page
>> will be ok as the problem is on the data side only.
>
> Are you guaranteed that a younger data access can't be hoisted up and
> affect things similarly? I don't see anything that would prevent this.

Yes that's my understanding, that the younger instructions
(mis-speculated or not) can't have their window for corruption of a
translation line up with the store to HCR due to the ISB.
