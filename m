Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD4492E40
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994043; cv=fail; b=cX7kqr2y3S9zIjubWk26LCmjH+BLb/kmpL60Ks9GNxN1GmwWSSStG9PhNfDqYkr8WMjQFaAcQwi7MKqaE+wW/ejpen0TKXo/YlEeF5BMzBGg4MZaO1fM5SjaElIUARKgEjwsyYoePtvujaVlYbTSldaXJKlpsJ9piz+PwokewVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994043; c=relaxed/simple;
	bh=ixdV6P4AgfSCJBfLd8peGdQlHK5Fvt/sV+0+NwjDfwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HAFTGTz/v6bYWKXboRCkPl+5+Vly9Wns+SuP70oCYWTQg5iu3G0NPm2g52iKbOWoc+TpypyGPgPMwVNeNkCunziE349VabZOsWORUF7XV92g+wZrC3Ncana1e+P7uRHWWfDnXuwKMq85oamTKcGMaRaSexWcOfEMdmV72TAAB+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=19pPmyP7; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pJuyX7p7; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="19pPmyP7";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pJuyX7p7"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHpK857563;
	Mon, 21 Sep 2026 05:33:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Zc6dX/+YCGzIFzB+wb+DUr+pA+BnML60wi9csamxI
	X8=; b=19pPmyP7cwniHefub6S9kT/H9sstepsl8lkpEhduIVEYG4sx7XRYBFcTJ
	tP5lA+dBb0hfWnzaqwuRdn65NWsZeyZv4EBKxNfIsSygjebZF//mZuMUoMLuPImX
	HaJecoQ4qbkH6QnpdKAcaXzCIkZQyHqLMZaVpvQUncxsN0JQWxG/Ow/regKIOWrp
	izJ3dEvn+azEO79AX/cpUkik/iH39xwlBFg+Efpsz9NMQaENm5d0qs6eEGTcFBNC
	EmBE13KfHmDmhf/ApKuafO7Zl3yqLWj7gC2czd6vZwuxgDjeLotKoslB8PkNoEhc
	ya+4zaEykvhtWpptge3T9zeGHNLAA==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021097.outbound.protection.outlook.com [40.107.208.97])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jp9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qngJ1HYV+Hcyn6xB3h4mKtIZWB+pf0OkQpaIL0EWSYYOUBxEMiZXhsXFZ8AaJdJKGmJOzJwqlF3u0UJ87zww8mnJNmoYyjgv0dLXHKg6JviyTU16ct1wXB6KVJnjqkoUdWxCHHKIfLsSUNr8GSUU6uucDmd32dfHjLDYZchq7GX2vm3tRrFOU+WjU58urArwAqS9zyCN+CzfpMMYHE/aCGMQa2AsIEuSChHeFnO5BAYqtkdfwZak3etQ9a9Mv3PwdEYO7BrlIy/7wthK7VBN7Fhhwr10Jge9KmELO9njZvjUwZfBTa/OXmj3DtoZJP1wEPn5uflNKA6asYSRc0qDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zc6dX/+YCGzIFzB+wb+DUr+pA+BnML60wi9csamxIX8=;
 b=UhSOsT817rkAcVzhVBzH2CnZw+0VpXCjH2sq57P6nWrY/uIRmMS0lDBeqxwZFV4guViA9oFDIY+C+yUELLWbd8bnzR0ZJo2MtcJx7k5yP19uxHmHw8BeNq2azQ4BSWGOxoc+Q4p2BDrCg1ed8ghPANZlluCcqH3+BfCsrU2VVsN0fi2cWRToPpkr7dFuPXxfBLaJ7W8GH8w4e7bhD10ZOO/VqcBhjmMpeQ8ril2dv4UMqZyWD5xQJWp3gAoeu8/1l6qQoqsjxDxpm5wKr/TRIX/fDjaaiRluBoeDNmR3xlsGKmc6Y1Esvyic5kZX4Gfkd0ysiWkDT0OKWXJmBwW9tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zc6dX/+YCGzIFzB+wb+DUr+pA+BnML60wi9csamxIX8=;
 b=pJuyX7p760uR4Q4aHVC8zX2tI5gVgIMlwloeNQhMdH25cxmb9VypjTd53suKJYXMYvPVMbQQHUIPd+ZWbfAcWNPV+U3LoKbtJXUJa6F49zlNbJNm5z8wLVQDhJwaoxVREDZkSUJcf6pIfwt3Cf2uVzYKfKNBEKMYKtYxeu3U1cHnNnXQ6TlmY+7h7ymSgjYOKokebcxSvm9PnnSg1YYoskKFxVOZNB1Dnm3gyLTcYNYK+NWqxWp3P2AehJ9Ep/dlUuagW/WwbHZR/p8eGdG3qHEFtpFZcvRAmQPSuAMSM65yohRvihrolyqqF94u+42gUxHnyd+2+2/TZVqgzP4xgw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SAWPR02MB11945.namprd02.prod.outlook.com (2603:10b6:806:55f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:42 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:42 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        ping@khushitshah.com, sandesh.patel@nutanix.com
Subject: [RFC PATCH v4 24/25] target/arm/qmp: implement query-cpu-props-info for KVM
Date: Mon, 21 Sep 2026 12:32:48 +0000
Message-ID: <20260921123249.1708067-25-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330D.namprd07.prod.outlook.com
 (2603:10b6:518:1::1c) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SAWPR02MB11945:EE_
X-MS-Office365-Filtering-Correlation-Id: d6b502aa-c84d-433e-8774-08df17dc91d1
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	5UbAgG25TJxwo5vQwrElULt1160M9cabwDhBHBbEjUfOVQRtuf0bCWQrTUPCsincxcZUPcs+DfywBg3LiSS1Iile9AP8BFYflMIwkD5kSFKMmAKAYYJgQ89Iu/+ei5pMODPdSDSMBxvmZV8tAWjA1TM0wbyQa9YHNC1M6c7JT4I/+7f2+stYCxzarhHKwKuJHfcOiwdiQ5R14wXwm+lQV1X7LRygMR/Ua7cdJF460oCUX5y6aL6vWk8klw7goL2ML2iP3UMX30nhL/noFhop6Le1mDYDqi28GqYyrZbuhZT61WHLOOqim1S7WgLj7tN8VGwf+aSCMz67W2sgpnEJ7a4uLTLPv4u9DKOjV2Kr+dmRAVV41VNBaeFySLIhjRxlj5IE7KexjfLH3D4hPv1MKn0mS6xeEQtXU0C+Hx5mhrRSo+0g6VUWSCVSbYOTZ5rdRHYN4n6xyO//jkI3562GobKXZGHYMIXfvI3q1skoXTbamJPCYGN3GBkCqHw7vQoGyJOGmSgSVAPXvwJjQ3FA0jglEBEaUIIFS58h6fofupx2dx/fVTLEEWFb/rYlRfJCwXisYrS2qdA/oyImiYAddhVdVpN3uLTs7kAed02++Htn9ClH5G15r8McJZjhXU9MF9ToNvcZ1JgQsiza8QHQwbzrVroFJbWG1r7fqwLom18=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7tlH/pZCMWR1TCHuLHDxxXDvTYXbqUReGFJTb2WbgJl1XfkjU253UnvkGoPd?=
 =?us-ascii?Q?ddtPjB+JpFbtRMj5I/1roswL+AkscOVMqoT1QQNebRWIF8V34Ir4TXBuO6I7?=
 =?us-ascii?Q?Zhktg1StBNjhUL4ykKfB/Ezxlx8MAOPePutPFOJ0gH2V1147lKsc4AZShDzb?=
 =?us-ascii?Q?D2WxT1I2JNN0D1GikAXjHNUmO7TPncRbhot6nhY1hAakxLMFY/kLGMB/zva+?=
 =?us-ascii?Q?W+xtjbVXwJrFLaLRYzkm/zL/HgsTYtOQj2B99EbwQnl3NwGYs8ya1GDxYxeE?=
 =?us-ascii?Q?LO45Iyj5S20EUuF+ioVo2eUSBHZA82x5P4NmcVJGj1TL0HL4+/qYxJFcJb0G?=
 =?us-ascii?Q?pp5ApvS1tOMbOLkczZhvaOpWUVhJjFcVgDXwPalR3Uz9uiUipacGxsEhV6Ng?=
 =?us-ascii?Q?LNbML8TRXR+BISs3IUmY9WkdYT6DBSWu00J6wctzLqb6qNwZaQFhqs1AGZSN?=
 =?us-ascii?Q?OhmK1JwHWbiE78jrcm+QF4d4CnPevZAxJukpVR8RJ6gEYrqAmIUeDcV1SKPk?=
 =?us-ascii?Q?WHPSqp+jEUjCi8OCpJTSkm/Bx8oBtpXjLrvX2W0Q9aD05MfEKhZmc8jd+hbg?=
 =?us-ascii?Q?ffWdPzQ9jAmNpVIOQHaRtpsNH8Ht3buvk3pdRnOvvwLoY3MIPFMRuPfxwmPG?=
 =?us-ascii?Q?LX1Hs9iudsXfwG6PWo5g/JM/qtL1uGBHyQHGLlIakUboIcOBsuCKRVmNsVWs?=
 =?us-ascii?Q?zdekJCf6Ie3I1z0Iw40hjLWeWtq1QhpUQykp76MuEQlgcxUuBg3wBmDOu5y9?=
 =?us-ascii?Q?vqzbGThIWnAIa2H2k2WZbJ/e/k0J2NdyIz4XJkKmmQ3D0xaZltiXiHXWsgoU?=
 =?us-ascii?Q?qY3LdM7yp+crcKUH8H1yn4UEQAnqmRq38ktcWZ1UqW4NyF9y35MzlTGYT+WC?=
 =?us-ascii?Q?X7O/hbts2PW04Uds5KeWPDPGtZatQnZlwm5k04UwU92IXDFqNl5ynj6DYFP8?=
 =?us-ascii?Q?7MdnVqzF+Y1wUhNws8rYy0yrFp99qoSGtJAEuSjgJt6vjt7VHaqWkZ5/Qowe?=
 =?us-ascii?Q?EHhm3mUxvvE6RNmyDiE3TA5AmcHunMMMdzuqUG3wT+wD8kDAd8ko2Eq82d05?=
 =?us-ascii?Q?zPhjlyumeerPX9CGNVriEWlTg1iJl/pXaCWPPGDMc7Ct+jpACIGUbTi62CXW?=
 =?us-ascii?Q?lrP/RftP97441h18o1NVFUwOLtcxfJloVToYS6xiDd1nKJdlxeWYvPYNvyh2?=
 =?us-ascii?Q?Y4//BEa+Ozw5BK0sYLUFpeGM/idSItlehj/IcpPlSdYyD8cv899OrsL8ByeU?=
 =?us-ascii?Q?UNsk+ICqSSz/eWg0zZNInQTohUsXcCXdAvhihZBMxgf1zYaFHUZFST+eipJq?=
 =?us-ascii?Q?DSbK8QsBuKAgbnhKwbKhSsCR5WsYKtmsXIZbou5wMEBu0wFBeZv/lBlrqA5q?=
 =?us-ascii?Q?lysfM+1V5WVedwd4h7zNutTNcsU2xqAgNp7Ss7+3l2TO6J0YnEkQvTGHzGAx?=
 =?us-ascii?Q?atFT/8zpyshq58Gk0qWGnROlwrdB/DzpfWsZiS15fvc/FZo0UJkMtaQwFHQq?=
 =?us-ascii?Q?0f7Xzm/tRCGmKgO+mxPPjX9WD2fKPyFvhHRsb3i1CQYIqv52KnT0hBZ7jCCH?=
 =?us-ascii?Q?3Uwoeudtqcg63EIaUjhoE4bW06G5F1FbKjoo3iJz9c97mX7T9Ce94fN71oCZ?=
 =?us-ascii?Q?WBxyDXbKyRU6DezNNmwUwinPTNaiA1fvYGq/2m5+RU8fe2L65zX4LIZx8hK/?=
 =?us-ascii?Q?kUUxtnnMN8pTRRGIxPpwpUk19bWIqa+gZGbO3VqZeYbBCiqhy+/82B6NCsd8?=
 =?us-ascii?Q?z6ZNAHrpETMyyMo2r0EvPuuT3BGXIpY=3D?=
X-Exchange-RoutingPolicyChecked:
	ElhOYsk3HV8dCNmQRlWFCqbH9xYtbQwxS0yVqNWWQDo2gyVDlTTbGuPRoeORX9Rl4b8NvbzngvU0tNwIlaKUe5z3A6eMFOtmlCsrROerCRxFZGa2KUThF668BKC7c/u9iS0duxr3qXtOZX63UHaowKFYJbxjoZJVfWOAV9xB9HN4dTkM2JKSEmXK+iY4xCw67lLSU0mqIvdtKWmKIZi5mM20HiaCtmXjl+5llFPkkPMmN19+zHZbwGe+Mnj0rhoTHlE/irxCKI32uEcMyozw9dXW7LDud7yoyFYdlxjf+doHsCxDCYu3FjV7Cg3HpBY2OD7pAuPDrvROr/9fAGY0gg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b502aa-c84d-433e-8774-08df17dc91d1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:41.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36I/OIheEpXE5jXwnzss+aLw82y3SGt2OnJEky1bzaCaLHwLs2lBavdFhwoV0emSK1N7T5dlk1vQ+l7e/nm4tJ/nMm5AkfKMHhY0DN2xKAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR02MB11945
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab12427 cx=c_pps
 a=HfG1oWozJQbQxD3IkfRzFg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=R2yoBtOzyJ_eo7SXKFUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX19NhVwv4Gdmb
 pgGB8NXmHllznqctMZCFFWLDiiA6ZHLGfzA2t/hriTFbSW6eDv7KQDWnBRkL536K3R3KDsvhlz2
 JfvSl4IEf/LSakjQZ84CDV0Jl3o7MX0=
X-Proofpoint-GUID: tmVyTIiKpO6s5bJV2IgIN9XIgRT3-FqR
X-Proofpoint-ORIG-GUID: tmVyTIiKpO6s5bJV2IgIN9XIgRT3-FqR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX4TBBuUnaf95M
 UCLR9rkO2MpHR6ltAuTEIcr25oIKW39uLlSeuJ+qShb9M+71hzROTXmeCY/kGhTJ0DjAMsgGezz
 BYMegBvOS1fSlue3ExYzauTGUMtl7WZeBCuam/U2viFWEs6mkMTHHPtnnbHqnh/tGtKIPa6Esds
 9Nd4dh5u+zCqU6pKQfSFS6pvx6j931N4IwjXnoRTh+jf8WXKZCgB1HWkdf/tcKcQynFvlnEJ6Bt
 4l6VRlFaoY6ULB/E66MKfT9/LropBdJHsHJjnBxAbAhqqksi94M9BTn4aTADuPijtZ3+zG5g0wZ
 8Ipgr4D7oJezsIp04WJmsZyI94wOYlDzXOoObCxWHb8YR04KyiXhFoc1ZTRQjHLGBge/ZaehIW0
 olG5ewQ7AcuxqiQCFt/i0V0lPfmlnCRdNhNtOGEO1n/XMO5KdjPiGdQt6RpCCfRxQe+ou8pTsqa
 /1u+JcZ56TGGkW0hJrw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Implement query-cpu-props-info for ARM64/KVM by creating and finalizing
a temporary "host" CPU object and then walking its QOM properties.

For numeric SYSREG_ properties, report the host-supported value ranges
computed by kvm_arm_field_get_supported_values(). For boolean
properties, report false as always supported and true as supported when
the QOM property value is true.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-qmp-cmds.c | 84 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 0940285af1..ba488d5c01 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -84,6 +84,90 @@ static const char *cpu_model_advertised_features[] = {
     NULL
 };
 
+CpuPropertyInfoList *qmp_query_cpu_props_info(Error **errp)
+{
+    CpuPropertyInfoList *head = NULL;
+    const ARMISARegisters *host_isar;
+    ObjectPropertyIterator iter;
+    ObjectProperty *prop;
+    Error *err = NULL;
+    ObjectClass *oc;
+    Object *obj;
+
+    if (!kvm_enabled()) {
+        error_setg(errp, "query-cpu-props-info requires KVM");
+        return NULL;
+    }
+
+    oc = cpu_class_by_name(TYPE_ARM_CPU, "host");
+    if (!oc) {
+        error_setg(errp, "The 'host' CPU type is not available");
+        return NULL;
+    }
+
+    host_isar = kvm_arm_get_host_isar();
+
+    /* Spin up a scratch "host" vCPU object and walk its QOM properties. */
+    obj = object_new_with_class(oc);
+    arm_cpu_finalize_features(ARM_CPU(obj), &err);
+    if (err) {
+        error_propagate(errp, err);
+        object_unref(obj);
+        return NULL;
+    }
+
+    object_property_iter_init(&iter, obj);
+    while ((prop = object_property_iter_next(&iter))) {
+        CpuPropertyInfo *info;
+
+        if (g_str_has_prefix(prop->name, "SYSREG_")) {
+            const ARM64SysRegField *field = prop->opaque;
+            CpuPropertyValueRangeList *ranges = NULL;
+            ArmFieldValueSet *vs = NULL;
+
+            info = g_new0(CpuPropertyInfo, 1);
+            info->name = g_strdup(prop->name);
+            info->type = CPU_PROPERTY_TYPE_NUMBER;
+
+            kvm_arm_field_get_supported_values(field, host_isar, &vs);
+            for (size_t k = 0; k < vs->n_ranges; k++) {
+                CpuPropertyValueRange *r = g_new0(CpuPropertyValueRange, 1);
+                r->min = vs->ranges[k].min;
+                r->max = vs->ranges[k].max;
+                QAPI_LIST_PREPEND(ranges, r);
+            }
+            info->u.number.supported_values = ranges;
+
+            g_free(vs->ranges);
+            g_free(vs);
+        } else if (g_strv_contains(cpu_model_advertised_features, prop->name)) {
+            bool cur = object_property_get_bool(obj, prop->name, &error_abort);
+            boolList *values = NULL;
+
+            info = g_new0(CpuPropertyInfo, 1);
+            info->name = g_strdup(prop->name);
+            info->type = CPU_PROPERTY_TYPE_BOOLEAN;
+
+            /*
+             * "off" is always supported. "on" is only supported when the
+             * host already has the feature enabled.
+             */
+            QAPI_LIST_PREPEND(values, false);
+            if (cur) {
+                QAPI_LIST_PREPEND(values, true);
+            }
+            info->u.boolean.supported_values = values;
+        } else {
+            continue;
+        }
+
+        QAPI_LIST_PREPEND(head, info);
+    }
+
+    object_unref(obj);
+    return head;
+}
+
 CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
                                                      CpuModelInfo *model,
                                                      Error **errp)
-- 
2.52.0

