Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA6B3DA5CC
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649039; cv=fail; b=TPE+6sPitIm8DvZFIVuSb4cvmqs7sH5p28AgxvRdpRo/BNw4dJDQteWNdfV1CLFf+Yns07UaE2YIwl11R116Dda/n9SINpeYDJ3WWG9O9bgwwTSZtKLBc7KrO11N9OeuU5TPPC2W8pmb67Hlfhs1KILpBsdItu1QzWA64Eb13Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649039; c=relaxed/simple;
	bh=UEIaGBj8OuSyOZxQUXV3dsP29LfnzG6CTscQzdKnH1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ys1h+ANUHmoUb5XYJ8Grucl5ZBidtdWe+1G2D4LGviarNjGSGYbtXMR4/Pfp/h3jeJDrilntaHsTUfIMet7zli83S4wZpmE0uu7H/vOC7VJs/tPZtPtHEmL9E53g1krDDmZNweUe2bnTZwXK3tsX6UjZgjAnbyUH71z56NbPk0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SQWbr2Ni; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YrVD/CMz; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SQWbr2Ni";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YrVD/CMz"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLN854749;
	Fri, 5 Jun 2026 01:43:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=0WKwP7Lpsh45tUG848o0K+h628ltweK55ISKFj05h
	2c=; b=SQWbr2Ni7pNgGlhj744qvIw6cTBrAT+H60XnDfV2UkRXLypwTIu+norTO
	z30xAVpf9+GAmbpWxN4oru555UdErQZQTMuRdTctCplihXEALLT+3rvQ2Knnqvrw
	WbxXrAzcs7n1EW9UlAcEF/ZKapC6907Ku7w5X7G1aAWagwRBeKoSLkcmj9yWENFd
	EHx4dws9tAsUPpO6Da7/rmxlqou4w2MbfzZ/DBzcA2MuB5TNit6P2+UcHprMfO0d
	1TlGcHO6+CQDlNi0NtVAcNHIRnY+FfOXLG3mpQQB5UefUBP3cdKG+g/m2rPEPk2l
	ZaCSyeEANIulAW8P8TeJP7Tcb2HFg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=arM7CQ3Rtz7xXgzbJw4U648hfCdtnA2kc5E4DHACSkwhLu2KdYqmnaEGB7EE2gzdEcNIZipp7NLTDYoDC454mI/pcdelYLvMdHCzP4UtxxG9t0u1fr77vOnyNgZAv8tYh0v7whK9Lpa9cXfDb1OCG820NIVsv5MrpNozJ1F8XmW7oWmZuPfyZE/RMD5ZR+vziR1VCsFybDRtsKvJPIGugyiHxCrfGRH63ZTkZh01JfYq2pLM/sbl6iqEiGi7BejsDJkyY4HPih/hGOKYQHXwp95EwBbktHebDD1J+yd6lDQQWAEYH+H7/a/08gA6jZ5j7ZicSqwBdICEX52cZ0RD5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0WKwP7Lpsh45tUG848o0K+h628ltweK55ISKFj05h2c=;
 b=q6l/I31jwqVJEV7hc0uUnh6RzjdSlb3KMV14L8jU0Nexs+JWAMDzgwZaQ8+QnV7k26RX7FWPvFfLBJWmw3hH5Xo0llxSM+A2813XsLPBZqm7OOKCA3RHJznJtPVxN74C35bce9PAeDzLInAAd/zDCF3K8omVF4RPjlnnbpe8Hoc6hhR2fLQhBNgBNlaAshYs1ZW9qWIvzBT8DC4C0vdh01ELmq7KIsrLeOB1YldPyXP2JuWYu/nlaHHM2C0okMRnA6PvsU0zaMSk3PIQtcUVgMYQ4j0NKnLjZZbwzb4QUGo2enJfrk5eNoKAd/+dpDM2NDttF8JhLgb8gmSvj6eMYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WKwP7Lpsh45tUG848o0K+h628ltweK55ISKFj05h2c=;
 b=YrVD/CMzRguKKQQA7+cr9OJMDZ8MhojGjtK5TLdDJy5jHbnsZxEsN89BrhFLE1fBoLJLqy62K9gJoAa4hWbOF49D570SS78HegohuH0v4JLdHTScUKQCDShet70JBzx18a/1fN8mCQ4VNEr/ljOo/jBjXCj92hvuWWMQ6dlaullcSwVE/L7ZKAjQYL3xYk2pgMBjYnPY6Mse9cUAP8lqyG3yKFH/R+wDvUdDkCSew3JNKeUCV/wVI2uJTpOk3Vm9q/4PDoG6CoTL0TpNBMdlPNhkT01VgpwTvr/sMdjrLFrK3AzkFKijyJIJ4W1lxLHVNuxSecXfJh3BhQ/Aa4KACQ==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:10 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:10 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Andrea Bolognani <abologna@redhat.com>,
        Jiri Denemark <jdenemar@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Jinqian Yang <yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v2 04/29] target/arm: Generate ARM64 ID registers and field tables
Date: Fri,  5 Jun 2026 08:33:33 +0000
Message-ID: <20260605083358.1320563-5-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260605083358.1320563-1-khushit.shah@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:510:324::18) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|CO6PR02MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: e53f063c-c18a-44f4-c3b7-08dec2de78db
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Sb40ML1+CTnACH2e7f4MRD5gJty02ZnTFrQa5NpDBPq1KX2DeyAMTelaYhvbaZFNrtLXj/nvb99MvgSsi3/cWYFDN5/BnCtEWpRN1L3obce2YzlQRnVx501L9BCHRtW/7OQcYm6T5PPCvbJrYeGyfZ/dwyTXJgaOhF2JgAbjJKeDZLO6E69sNiCakdK6AJlbFEbBcrnf0CtuIMGToInfqZNqvivsmFvIK8hIvMDd8OVfQJgEionrcUQAvyE0/nfqvyJlQmQ4ky+MB2WhXEyPe27Fa5R9exJUgJiZU3FkdMqYG8J/bt6oNXopjk82eErew+FTyDh+o2DNRvLptz6/pk02v1a/2rOV0/aEY+T7A2uhECWi1hOLMa5rzrbA/43ojNzVCyK+zxH6rB/z4iXzyDzi82/DPRQnRKPLQBpE3IfADfMg0Ojnbej1uOVImRZtPb5+OrWJW10G5W7qexFmuH10qNGNkjrAgKVyD6AnLePjJYnimncqE6Z7zJVXTVA7tfRepmTrQn32sI5yJyw9ku0Qfg1507euRSrqiZTDe3+lfrpYvCITPkAaN5Py8phsfzITDrSdSkd7mo3wqlIFv6KiZdPnI+7aTMDAILe/2Edgxk09R0rFtWV3IF9YIbs/vhVxWVEzYnPQScZb+G5DtD7nElFd5Q6MyTyOdGFGqRqC5EipR0mIwZsJfYRqJrZm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BcXhTCeuOAWwBN1+cm6KP1m4Zwb1z25sPVdD9qkHwyL4BW2DZDil8Rd0Xjp1?=
 =?us-ascii?Q?xKZlRMNzMDqaOkO5oU4Ql2rV4z0elru3vjWJt/bnF+biPIL+RnKVqK2t54S3?=
 =?us-ascii?Q?VLOeyQDVwFFgnEE6emVcJKh4HaYi3L0zbww7SxjRzVjGu63vsprm0r3lIa1j?=
 =?us-ascii?Q?WeZHUnUMEibN3C3NauTUrjEFwHJ540iTLK7TtId31XJHut+4n3dMkt2EJPKW?=
 =?us-ascii?Q?27IRl5PKfOSToY0D5Lk+LGZw+E7Wicd4y3gEDafJ7MJpOPpdQiK7AVM1Qw4G?=
 =?us-ascii?Q?WuP+ioVMqYNgCOLcOOpBBAlH4zt7jbuFva6PjAO9QfpOAfvPZS0IzoHWtX1F?=
 =?us-ascii?Q?Zap0EnkrWrzRaNIQh0QKRPcB/iI4qkqRLUycSNEipQBptSnHO+G+Sfi6RWgc?=
 =?us-ascii?Q?FH7Hj6VqS/hq2gX9tvv5QoS0y4PTMN1a51ny5FFsImx2h+qP2brTGwgmPRRZ?=
 =?us-ascii?Q?McZOtUXScZMya2e2cWgZ0Elrs4Njl+zCXWqi9OpJjL9HEHhZDXznbWMVLuzM?=
 =?us-ascii?Q?6NZl0V5gfELzEIhKagUAxuxbWHD/rF8Xjas5ra7NwMEyLfRF7T5U9FVMzvfC?=
 =?us-ascii?Q?pCNQZdcSw9hhYTfdx/tRa8dcHzKRjRfoqxM7ohfjba36BZzz0rDlvUSeLdmv?=
 =?us-ascii?Q?huYOJ1R4oGTurMaRwItbK3uld4nNXDF0tlhqQvrpIGpMEHqG01tUBvzsWPdH?=
 =?us-ascii?Q?Sc9S8JXnXHqidKBKi1EMa8+SfzBYT3Ub9Um80Wr271I1Hz33qTuAAFm6f8wW?=
 =?us-ascii?Q?F/kihqRklHqjK1mSHboe9uuLp9ZhMQLYcj4/7h3AGX9AkHVs/sKiYPG87La+?=
 =?us-ascii?Q?Ycghu9BVE+ogSBWtbgkaYWeDUImjC8XDb0u755YtONv3oo9ax42vjazS4e5n?=
 =?us-ascii?Q?9ElhTwCiQCya4qzd1Q0cefp+buOM+N5oG4v35dGJcYZbLq8xuS9ErhT6uAaX?=
 =?us-ascii?Q?IuONNqbMByjU7wj4g7IuaCV6uLPns4VzmWFuLaNmAyGwRt8Ggx93BlacRsn7?=
 =?us-ascii?Q?lgASGlvKXjtwVbOf60RAxArbhmowhjJpPETDwDRNpmmY+EKglVwFpcPtFhTS?=
 =?us-ascii?Q?wOGjTwsbi0tr5O+Z9qqhZdW/pHvwhCnq+bXpomG1i/d7WXai8zu8nJ5m84TB?=
 =?us-ascii?Q?3kgB2Jeg3ZqP1vRcNKm94unwIA9kHLUi2vKEDxxgjb6Yhd9s+8VH5uPmEzvN?=
 =?us-ascii?Q?Riz1Q2b9YJSCcYCTsSuoWWhJl7QwhCkTWaPZst6PgsQarcQcK0SjSPh5roIy?=
 =?us-ascii?Q?LRCtskdLtTlfwnIdPN5zmWMGV9dxMc+tIcskz/PlqD2ngLcpP8FjKmueGZeD?=
 =?us-ascii?Q?4IYDmmCzBjLQzX0YiYqaYLxPh96qvDTEPyuTsAg/WYSYiHaD/ASlPfDtlXwZ?=
 =?us-ascii?Q?frAI8WKZBeOrinfcr01KLeaH+HItyozXcNXvrdVThhmXD5DQumRXdiblHtFZ?=
 =?us-ascii?Q?F6mQbPC8qoc/sJ3lRAZITCYlav+X/l+BbFUpu09qlhMmyoCRW0x0nYKjyCqo?=
 =?us-ascii?Q?KG9CvCiAGByVWHWcfs1VWbdt5j6MbAWTr4gX/rrhOLwvfvG973HVA6omuX+0?=
 =?us-ascii?Q?QcZ1PAbXzI6qf6Vm6N5u2Ahk2zSFyqccfAXW0+EfoFj3L6lFfHOT7W2fY1NS?=
 =?us-ascii?Q?sVGgBiQ9eXI5kXgNLytITakkHmzID2o/1ZWS5LBBjjGaVzA/odDHvfckrwp/?=
 =?us-ascii?Q?ahk/5TCU2ZTDHhRfapmN6+InugnFEw1IdSvBSWAx/6p5Ipy6hE4ymlojUYuy?=
 =?us-ascii?Q?FetyhVjJKw2MBUTDBdODKT3UTfZp/Jg=3D?=
X-Exchange-RoutingPolicyChecked:
	kWLxKH//hokm+vvfqa5QR7X+u7bswAhnKtlHHFbKcWmoNlwEPhpuNdkYcD6IkwI92C/skEboLWudsArfNfMxAdTqrYsOkeMeOiw+N9EkpwVfrZXqSvY0Oxp2fOIt+9IezymhljHxpCZPxy2uZjh/gLbM8Rx6eNqHH1F6nXQWma7ugA7+HGLETE73chwm9oIni42/xBYbF5O6BwKnuND9kb9HvsbGkpS1mAl8p1a0D7MnSlR1Kg2oB64jC84CylJoSkGZ2AedaAWD/yBnOxVYWDU9emRpNR2xkGXZPuCG8swCMVD/b5BcPV2GIMIIVT2AK6Vi7llwWmVEbWql3L5ssw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53f063c-c18a-44f4-c3b7-08dec2de78db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:10.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XM92uLy4OAOqaC+WdHtTSZ79qMtQ1i6/Tt8RyqKljW+kULSDNhO6DIqwd3YuDF1QyM831PvpMmquYuBXk9M6fFp6SWhIMrK95FVnswmHkCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: mFcvnf1PG37fCEU46EEarModPZBdFN6r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX/laKBTPex3J2
 akyP0a3uEINsRKuRx155rMmHgFji1SskUcAuB3O2nvVg3AXuggD4DqG0P+fvq59Ted5NeVAacVj
 30NDd+wotLtrEMPfY9vz/s8aUmA/RZHopi42L04Bist8XJKk4efozwoLbqufUkIm4WXGgOuw5jP
 euY4mASGexgCxcypoeIlI98YrKo+svD1TiSJSpmT225wkDraoNCoiLIibz3SgzE/dkRRuTP0IXL
 KHLjBHkVQnPMmm4vFuB0AfmLIAYS59pClLsu7AF5IXjJcAT3N9leFe9K3YlOu/ptI0pqdC7GEKX
 iaiFC/FUsHcwngujbiI/1QM8QXH1n/y3RMipGDkCL2rVrkcgtwI5ecJxD73PsF4/BtOmElpJeJ0
 qeId13RLFrnqj1aZl+ziRhm4ShDLPvD1nCbKGjkUwQ0MkM33O5da6E1zifVJXsAEHVFaw9YfyoU
 B9HCC4b+Pjyg+0KTZ8A==
X-Proofpoint-GUID: mFcvnf1PG37fCEU46EEarModPZBdFN6r
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c21 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=hOrA-tRr8AhjEMyW9QMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Include cpu-idregs.h.inc multiple times with different definitions for
the X-macros. This will generate tables for all Arm64 ID registers and
their fields and their architecturally defined values. These tables
will be consumed by the property layer in future patches.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.c | 125 ++++++++++++++++++++++++++++++++++++++++
 target/arm/cpu-idregs.h |  38 +++++++++++-
 target/arm/meson.build  |   3 +-
 3 files changed, 164 insertions(+), 2 deletions(-)
 create mode 100644 target/arm/cpu-idregs.c

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
new file mode 100644
index 0000000000..81661dfca5
--- /dev/null
+++ b/target/arm/cpu-idregs.c
@@ -0,0 +1,125 @@
+/*
+ * ARM ID register field table.
+ *
+ * Builds the per-id-register field descriptor arrays and the global
+ * arm_idregs[] table.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "cpu-idregs.h"
+#include "cpu-sysregs.h"
+/*
+ * Generate an array of architecturely defined values for each field
+ * in arch-value format
+ */
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval) \
+    static const ArmIdRegArchVal reg##_##field##_arch_vals[] = {
+#define IDREG_FIELD_ARCH_VAL(v, n) { (v), (n) },
+#define IDREG_FIELD_ARCH_VAL_ANY   { 0xffffffffUL, NULL },
+#define IDREG_FIELD_END(reg, field) \
+    };
+#include "cpu-idregs.h.inc"
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_END
+/* generate an array of per-register ArmIdRegField[] descriptors */
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+#define IDREG_START(reg) \
+    static ArmIdRegField reg##_fields[] = {
+
+#define IDREG_END(reg) \
+    };
+
+#define IDREG_FIELD_START(reg, field, _shift, _length, safe, defval)  \
+    {                                                                 \
+        .idx = ARM_FIELD_IDX(reg, field),                             \
+        .name = #field,                                               \
+        .shift = (_shift),                                            \
+        .length = (_length),                                          \
+        .safe_rule = IDREG_SAFE_##safe,                               \
+        .default_val = (defval),                                      \
+        .arch_vals = (ArmIdRegArchVal *)reg##_##field##_arch_vals,    \
+        .arch_vals_count = ARRAY_SIZE(reg##_##field##_arch_vals),     \
+    },
+#include "cpu-idregs.h.inc"
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_END
+
+/* generate an array of top level ID registers */
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval)
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+
+#define IDREG_START(reg) \
+    [reg##_IDX] = { \
+        .name = #reg, \
+        .fields = reg##_fields, \
+        .fields_count = ARRAY_SIZE(reg##_fields), \
+    },
+
+ArmIdReg arm_idregs[NUM_ID_IDX] = {
+#include "cpu-idregs.h.inc"
+};
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_END
+
+
+/* Per-register field position enums (0..N-1 inside each register). */
+#define IDREG_START(reg) enum {
+#define IDREG_END(reg)   reg##_FIELD_POS__MAX };
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval) \
+    reg##_FIELD_POS_##field,
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+
+#include "cpu-idregs.h.inc"
+
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_START
+#undef IDREG_END
+#undef IDREG_START
+
+/* Flat ArmFieldIdx -> {reg, field slot, shift, length}. */
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, _shift, _length, safe, defval) \
+    [ARM_FIELD_##reg##_##field] = {                                  \
+        .reg_idx = reg##_EL1_IDX,                                    \
+        .field_idx = reg##_FIELD_POS_##field,                        \
+        .shift = (_shift),                                           \
+        .length = (_length),                                         \
+    },
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+
+const ArmIdRegFieldLoc arm_field_locs[ARM_FIELD__MAX] = {
+#include "cpu-idregs.h.inc"
+};
+
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_START
+#undef IDREG_END
+#undef IDREG_START
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 514ec39106..37a87e6d0b 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -16,12 +16,48 @@ typedef enum ArmIdRegSafeRule {
     IDREG_SAFE_ANY,
 } ArmIdRegSafeRule;
 
+#define DCZID_EL0_EL1_IDX         DCZID_EL0_IDX
+#define CTR_EL0_EL1_IDX           CTR_EL0_IDX
+
+/* ArmFieldIdx: per-field enum generated from cpu-idregs.h.inc */
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_START(reg, field, shift, length, safe, defval) \
+    ARM_FIELD_##reg##_##field,
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+typedef enum ArmFieldIdx {
+#include "cpu-idregs.h.inc"
+    ARM_FIELD__MAX,
+} ArmFieldIdx;
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_FIELD_START
+#undef IDREG_END
+#undef IDREG_START
+
+typedef struct ArmIdRegFieldLoc {
+    ARMIDRegisterIdx reg_idx;
+    uint16_t field_idx;
+    uint8_t shift;
+    uint8_t length;
+} ArmIdRegFieldLoc;
+extern const ArmIdRegFieldLoc arm_field_locs[ARM_FIELD__MAX];
+#define ARM_FIELD_REG(idx)       (arm_field_locs[(idx)].reg_idx)
+#define ARM_FIELD_REG_FIELD(idx) (arm_field_locs[(idx)].field_idx)
+#define ARM_FIELD_SHIFT(idx)     (arm_field_locs[(idx)].shift)
+#define ARM_FIELD_LENGTH(idx)    (arm_field_locs[(idx)].length)
+#define ARM_FIELD_IDX(reg, field) ARM_FIELD_##reg##_##field
+
 typedef struct ArmIdRegArchVal {
     uint64_t value;
     const char *name;
 } ArmIdRegArchVal;
 
 typedef struct ArmIdRegField {
+    ArmFieldIdx idx;
     const char *name;
     uint32_t shift;
     uint32_t length;
@@ -37,5 +73,5 @@ typedef struct ArmIdReg {
     uint32_t fields_count;
 } ArmIdReg;
 
-
+extern ArmIdReg arm_idregs[NUM_ID_IDX];
 #endif /* CPU_IDREGS_H */
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 4723f9f170..be4361fbfd 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -10,7 +10,8 @@ arm_user_ss.add(files('gdbstub.c'))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
-  'gdbstub64.c'
+  'gdbstub64.c',
+  'cpu-idregs.c',
 ))
 
 arm_common_ss.add(files(
-- 
2.52.0

