Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F86A46AF34
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650527; cv=fail; b=i9pkXbwA9Tto5TebC3jbXQFV0pf9ShSFeDD/k8I++a9DOcJ8rnkbg0ZXIBA1DebTvg7DaKAQqFG8/mcXsZDyl9dfChqUYZXezFbeTErjhhT0kaHhaWS4n22zw8OZgRmywhvqOxIetFc3mXvV0Oii8kyQ7uk4JHdJ+U7/mEXMHvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650527; c=relaxed/simple;
	bh=v27cMwWhdAZV357AuG2Nb7e2/HKhhcG8bgAJPgmjJvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HJTw9NjHXqkmZRWTsgftdRurwNy83EfjN6OADGPQfWqnN3D2ZK9BZQ0bIgYycUpY5D9vZwwX4PBiJNAwHapnXgFqM9TD7oo+C8t4TIr6fYrEuzSyHKnGjt1uld9ExATGOpMIeWXaKumqE+BxB/3zBnk3fydrKZMix9SoPG6+8Kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ThTfjkYK; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wj7LJYXd; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ThTfjkYK";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wj7LJYXd"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLO854749;
	Fri, 5 Jun 2026 01:43:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=pG6UyugB21twHsoVH3Y4Yli8mJE61LevG+jBlrmzJ
	w0=; b=ThTfjkYK3QQglR2DHCmZLoKWynJQSMfCnvqk9xMbNSmzOQ8cS23VRZoG2
	DZAHQ8B1eeTwjD0FUh0K8O73PuIeDrHYFIbzBjFfXJZbgbcylJZPGLWAw2Q2fDkB
	YNsYvljttIBh9ouEcPMWUMvDyoMBmpmysOP9eKJi/A4yBAkovxNLUTk5ECro44D+
	FsIkC4BSBTR2/waEB1vid/QVqmTBovl+EoVQBFZ2qcTBCmsztGyXT6kv+M9Cob/L
	ZNO/Czn4jQV0bWbbIIUaEqOdK2+aFvtUvCS/3Y4iEbEKJ1TVVV4ImPYa9FRCkis7
	wJ6Xg0YrFGIpoTZFKLma0yGVpg8GQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-6
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xhmBjPFZKeA+W8mp5IZ7PagbOBt4H4vnBWzvwtzbLS/TEVu1vCMKnbMvXT45NDay5YVekXOBa6b6IowvU4Y4/M8o7Y59cnsp78lJSG46XkhwFT/7hLBjltTSn5rupRB04Rc3xsZm+pnIO7zfga2JbbC9+6lUM64HAtWK4fuiUigi/fbT642tT9HoY3/+XuF1KplG8jYc4p2Tdy3jqXNEfrcrIRnBLcDrVYi2X2lqIC+vAhSq2U9yeMoG8tXicDtTrN+aOw8EZt9SW0G8XIIvw4nLjSny/aYlySw6lnMbgNIwMn5rlldw6VuYdw4KT02fndMwq+OX4cz37LvgoTq8bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pG6UyugB21twHsoVH3Y4Yli8mJE61LevG+jBlrmzJw0=;
 b=SsA8WzhEQZeWhON77+WQqFs4m585PspPTCDsZV1G8L85ypT3UCb2PHJd1cZml5Wu6pvS0Th95ko/VtxsUqDqyLTRWRlcpN9ERi0UTYVDXnfG2KpOKkOCw7ciqvjpcRNAF1f4rdiPRyRfJtZOZrxduWdA5A6JYwUdfZqlaTBuz8O/rkropmQ0CRZrPJfNSEpZn1wq0FIFq4eO0zrjn7zN4TiCf0ukAbo3CQfw9Qz6n3jlQkPx63cWa6ETz7xFk8cQRDRnymBzPlMWlMhLfIt5Ud8ZcxNY5XvCge20p8E+LUu1ZwuSjGZSDMB3tmhw3tPkCRiU4M6yUxNeSQ8vXrCOhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG6UyugB21twHsoVH3Y4Yli8mJE61LevG+jBlrmzJw0=;
 b=wj7LJYXdMCD9hasYd4Qg7p+IiFSXneWfZWN+ozd6nJGSfSWPRFzx6P/Tn2hhTZD8jFbcan0gG3DDGPU8fmev7XE137B8tNGTd7vPeGWJYX1WTXqCbd0p6wGm7jlEUbHa2z9faP5xOtkyQbaHanEholTrKLVFLms9+Ey5vtTDj9nRCnNaT5S1pYIIHvW9+eXMehURW6sm7Hgi4m/o6pLvqBSQDWsKYxV+NxzPo3nSDTLucvpMMyblpj0kC+14yP6mQ3+qmBUdpg5ZeVVEJRrGh5vudk2edEalLr1rQlivq+xw7uHW0asZ3w9R7hHq8yUMxCkd22w8dPMOyoPZSO9oZg==
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
Subject: [RFC PATCH v2 05/29] target/arm: Replace FIELD() macros with IDREG_FIELD expansion
Date: Fri,  5 Jun 2026 08:33:34 +0000
Message-ID: <20260605083358.1320563-6-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 69699bae-41fe-42cd-1ca3-08dec2de790c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nKQ+Wt8p9nklauK2pUfLGyfkeF2g1H8EtpqCC6Psxji3jKyTqo4P8GCGhjCTbVQ0tdH6e6egXsNe61HMbBRSKJfed0YbunR7C25YdrZ9McpmWKpOgzyuQkemNOoQgXx+FxFXh/6TnF/htREQgOuW7Zl7Mm8d+TJx67q0O6EQMdJuuTQjLBtXpKdqOxVHWUNBGL7Ffo+GkXeM1apyOvTszLo5uLBOn1JZ5UFYhEAjdw9T3nu7ZSZqflw3T2Vj+DXdWJuW6p1OabZq9VyDaKRjH3sqKFSg8hHcwl30Fx6MzCc+ikVlP+HJRVUSMnRc5fjB/k8eSrctm8MkNoMJeo1pmpLzqpmULvDbxBveB22F7T9hlOZQk0piYozg4Z9+IAJNfGDqjYuh+pPnnMIkw2969R7L3FLaPZglnVdLroE1gCq9xsQeCYHMuSmoTyDY7m7UVd+F7+gAwKdCobluy3nhLyv/1TyaukZ9FSurpoDPzAOM86vC85p2F4y7jsnsfESwZTyhFa+mCJtU4iLd/BgrfwXxg6/WqeYw0Tw4eIae39UpXdDGGJpvxf8Pubj0qQprDAFn8rmTsC5tyOXK7CWhp7hsTplt4fh2bcosT8f8CREhi+U97f1sEAQivOAzixBx6Tba7oWa3iG1Z0XA31t4X/BND8HYInryyYkGTtoQnmSy7VKf5f2jTL7aROwQx6X4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H+ok/OTwyH8iMNIRFRiaAk3hlFmwKUfqgB7MfB6HsGRuQiTTW5tIfIHIhhRb?=
 =?us-ascii?Q?jXcOyI/0cF6YYaRNxnv0jFl+IVsrzDDb2KvJSSjduVlVo3pCQ0Zo0cbsg5y2?=
 =?us-ascii?Q?Lku0HtwoOcTSdgNM5CIvS8rPWdEcoj+RAls6mY+LdD/7SYvvyC8Zy2EIDEPk?=
 =?us-ascii?Q?Qj+Cpdnb1fVKyASQzqChKbX1OTIoDfTkDTj03ef5gXsT5PYSQjACvNYWt5ip?=
 =?us-ascii?Q?ccVLKM+6DC3W7ML9Y9OAsdODzGoNcPb1DXS6SRabLOLU3/0l5DX4G4LhlNn/?=
 =?us-ascii?Q?bxf+CKMumdQz5dRrFYZT4A22HNGG49ixSr7R8QY0hYBFgu3HPy/quLCO3U0b?=
 =?us-ascii?Q?32Ryc+V2X4jHxlroOPP5mTYkTERg5TLKSfjNbkfUPD8iNZmmLTGscEL+Z0Qw?=
 =?us-ascii?Q?9tYmmcXWq7gNoOhChjkVljiSphNmVwhqK0nqm/lP83Ik49gD8rV9COeGztI1?=
 =?us-ascii?Q?Agn31onV2S3rNHijjCWDibTvuQ54KTmfRHvFCGGC5dLwLopRbJsUFnyl19MA?=
 =?us-ascii?Q?zRQv56b3FFWR9yLMTpKH84n9JlLvw2aDxjrrqab/gCISbenynl60BYBZhT1i?=
 =?us-ascii?Q?fZdwwN7ukv57pquMFtntDj+/JuE0/gPjOJyY+3R6D7RFwbUshfO6lkAXq9jW?=
 =?us-ascii?Q?AzIsyAUIwgX2lnSIT5SfxG/pQU1Zc30J0nBPIhP8PvIat34jSot7OxTtv5Gx?=
 =?us-ascii?Q?4O+HzLZ+eDu13v2ExxCAulS1LyFDDuuIozMABOnl4Dhnjh92/HsBA+/cJRRw?=
 =?us-ascii?Q?04RTrjck/N6pKoq1+siIKpE9Vi2Y3nBS7s94uULJZh8XCiqsMQ5qV9sqPst5?=
 =?us-ascii?Q?52W7ipEMg6e4zo0q4CklqmAg8gkS3cV7FswDJLeqIXdUD8h5bQhJNrymFSM/?=
 =?us-ascii?Q?uJRjXLaQGz6RQxlTBZDrXjoMJWOw53z/4SKZm5ud9fEOlvB1MZupkjDxgKMi?=
 =?us-ascii?Q?DdV4Kztt8FvYaMqaJzT18mOsH+BwoNxxlG9f5mFxwc+vDmdl9adFqPtV4qOj?=
 =?us-ascii?Q?LakbgGytveAkw/THwDnA61LTXKxpNZg3or9CL5ryuMEAj5tlTkL4F7Lll5mp?=
 =?us-ascii?Q?ncfWG81eCZNi+SjPx/RQrTC+rV8Rl43ftE/jz07dKJejocKyWPO5r1HsOj37?=
 =?us-ascii?Q?7mXocUV2d9mK8BXReVrlQgm6TxQ7QRbpB/KIccsl7MI6AjNhELMT62DsgqoO?=
 =?us-ascii?Q?Fn8bJLfP5LUvoSlH2T76TVrV1XzWOCtSxH2a514huVNe9uU9xcFbDJiglc/j?=
 =?us-ascii?Q?Nvc0Avw7GHYUZEoQzNiXWSUodF3XTtvuyHSz9rETl47jDgF3hUAM+fxzHGIm?=
 =?us-ascii?Q?BE2kXUHleI0/Xd8SllR9ND8amst7eLWTv2icfjtYpWKWtuGzkCEGsQOGz5qh?=
 =?us-ascii?Q?D4/x89TE72ilv6ej7AWcOgDMmv/XJ9g+Q5vYkJWK2tOyc8+K/0pq60aMBT5O?=
 =?us-ascii?Q?/ml3xLUHqKKEyrNlFj/c2AlgsGN6zUR9OsBS1vRmlTvIWCDc65sZOZReVB/J?=
 =?us-ascii?Q?raomzhj71pkWABYIkZOYzi+7/ZP57PocKWsoL4k1GCUdoKurCyie/lt0rFMq?=
 =?us-ascii?Q?aBimgdPBkuHs0PyQd+p6AafKkKN99WAsZBfU4yDX9ve6ePj+KoGmzfYx8itB?=
 =?us-ascii?Q?8RSGz1G4IvFOg1nriXXqMH5UcsakdgE5b3QWM7QSMv+mSCMrcIQ8xCuS+Bmr?=
 =?us-ascii?Q?+UEBFOzsIqz5g2LFJjSBXOPrAEh3XHfi7VgdKPVzstEWudfa9B2zZaKLWHl6?=
 =?us-ascii?Q?FNF72KVPuMgGwWxxIFchMJWKsAKrCJc=3D?=
X-Exchange-RoutingPolicyChecked:
	j0xfaCo8EIoOSQWvc5UgHIWgJRNTw4pnB/UnnXaz/bQY/27pdTIedtZIyppB+YgTIHMNymC7Y7FjFO9zCR3fcohO/arDuWH+kAbquFo6Gq28R5GJNoZUQRf1NLXsAvmtKJy6WqB6KGkwHR4iyL8wmX3vxE5EXdyyqPGRAyE263yIHGUASzlHag+lrRkcfbDZjd4SAa1RCKH1gcSwIcf2QjFf9s2bIposDziTlRaliKrgzwjeQwCqUQpSqY4F70U8jd/KqgPIl6242F6XkE0PqEqwkDlys5XFOzhMsltfQdFpHXBxp8ckHy5/1uKRXcXAYLHTq2k6YX5MTT/4CzywWw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69699bae-41fe-42cd-1ca3-08dec2de790c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:10.4383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3Hnbj7gD6+XjW/RU6YLrJvVGSkgWZPNr63YW7RNvfyP+55pcNCEDTMDblHBqPMN/XkcgsfVPBfBfmV8/+3GIJn6nChQl7h2Zzd+x+VJWqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: 3uM6f1P5knaG2pv6VleX74eaF-cwKN0i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX1TGt1KRC2JQM
 MXeC67kEZutbrZjBkiZnGhTDPGOuHzNBPIw2hqNomy7stptEMLvsB8S8bNkWFHcj6YXrX6mBd48
 O4ADA3Cx1spt2UpP4qEPsniYpeLHjO8OJgVfGDlXZFNQ7kM/9GC10WBs6BWOeX2bu4T5b1wZNHq
 hgWGydiP+5R8TYNq1nPuOj5SsqGMJdbVnhPQ5RZVbT5UxvhfHtLopYvfiu6+N6tw6Eqg025QSSR
 GZXsj9gDN1f7yELbzSIGA+N2Qxu5+OXBfqSRih7Ps9wXP1vlzoq97kNog38ZNEcroEwBXdrQtn/
 aBiDsJURLUm8kqeU3S0Cc88iETz7ndQ+ft+ppP/hemdTkSab2Xo065g3itryzn5JIsY3n0PpqYA
 Gr5YMaoobAWjQUH0CHQA/13pht/C3hPJRVXNszoVxS741GtMZ/hD3+N+Wu1M1TuonA3XlIo0k1b
 vTK+wJo2WhpHca8jIXA==
X-Proofpoint-GUID: 3uM6f1P5knaG2pv6VleX74eaF-cwKN0i
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c21 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=avvmcv_isQaNTVs95NMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Replace the existing FIELD() macro with the newly introduced
IDREG_FIELD() macro to remove duplication.

All definitions for TCG remains the same.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-features.h | 235 +++-----------------------------------
 1 file changed, 19 insertions(+), 216 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 4e44245a8b..e162bdff9b 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -50,14 +50,6 @@ FIELD(CCSIDR_EL1, LINESIZE, 0, 3)
 FIELD(CCSIDR_EL1, ASSOCIATIVITY, 3, 10)
 FIELD(CCSIDR_EL1, NUMSETS, 13, 15)
 
-FIELD(CTR_EL0,  IMINLINE, 0, 4)
-FIELD(CTR_EL0,  L1IP, 14, 2)
-FIELD(CTR_EL0,  DMINLINE, 16, 4)
-FIELD(CTR_EL0,  ERG, 20, 4)
-FIELD(CTR_EL0,  CWG, 24, 4)
-FIELD(CTR_EL0,  IDC, 28, 1)
-FIELD(CTR_EL0,  DIC, 29, 1)
-FIELD(CTR_EL0,  TMINLINE, 32, 6)
 
 FIELD(MIDR_EL1, REVISION, 0, 4)
 FIELD(MIDR_EL1, PARTNUM, 4, 12)
@@ -189,219 +181,30 @@ FIELD(ID_PFR1, VIRTUALIZATION, 12, 4)
 FIELD(ID_PFR1, GENTIMER, 16, 4)
 FIELD(ID_PFR1, SEC_FRAC, 20, 4)
 FIELD(ID_PFR1, VIRT_FRAC, 24, 4)
-FIELD(ID_PFR1, GIC, 28, 4)
 
 FIELD(ID_PFR2, CSV3, 0, 4)
 FIELD(ID_PFR2, SSBS, 4, 4)
 FIELD(ID_PFR2, RAS_FRAC, 8, 4)
 
-FIELD(ID_AA64ISAR0, AES, 4, 4)
-FIELD(ID_AA64ISAR0, SHA1, 8, 4)
-FIELD(ID_AA64ISAR0, SHA2, 12, 4)
-FIELD(ID_AA64ISAR0, CRC32, 16, 4)
-FIELD(ID_AA64ISAR0, ATOMIC, 20, 4)
-FIELD(ID_AA64ISAR0, TME, 24, 4)
-FIELD(ID_AA64ISAR0, RDM, 28, 4)
-FIELD(ID_AA64ISAR0, SHA3, 32, 4)
-FIELD(ID_AA64ISAR0, SM3, 36, 4)
-FIELD(ID_AA64ISAR0, SM4, 40, 4)
-FIELD(ID_AA64ISAR0, DP, 44, 4)
-FIELD(ID_AA64ISAR0, FHM, 48, 4)
-FIELD(ID_AA64ISAR0, TS, 52, 4)
-FIELD(ID_AA64ISAR0, TLB, 56, 4)
-FIELD(ID_AA64ISAR0, RNDR, 60, 4)
-
-FIELD(ID_AA64ISAR1, DPB, 0, 4)
-FIELD(ID_AA64ISAR1, APA, 4, 4)
-FIELD(ID_AA64ISAR1, API, 8, 4)
-FIELD(ID_AA64ISAR1, JSCVT, 12, 4)
-FIELD(ID_AA64ISAR1, FCMA, 16, 4)
-FIELD(ID_AA64ISAR1, LRCPC, 20, 4)
-FIELD(ID_AA64ISAR1, GPA, 24, 4)
-FIELD(ID_AA64ISAR1, GPI, 28, 4)
-FIELD(ID_AA64ISAR1, FRINTTS, 32, 4)
-FIELD(ID_AA64ISAR1, SB, 36, 4)
-FIELD(ID_AA64ISAR1, SPECRES, 40, 4)
-FIELD(ID_AA64ISAR1, BF16, 44, 4)
-FIELD(ID_AA64ISAR1, DGH, 48, 4)
-FIELD(ID_AA64ISAR1, I8MM, 52, 4)
-FIELD(ID_AA64ISAR1, XS, 56, 4)
-FIELD(ID_AA64ISAR1, LS64, 60, 4)
-
-FIELD(ID_AA64ISAR2, WFXT, 0, 4)
-FIELD(ID_AA64ISAR2, RPRES, 4, 4)
-FIELD(ID_AA64ISAR2, GPA3, 8, 4)
-FIELD(ID_AA64ISAR2, APA3, 12, 4)
-FIELD(ID_AA64ISAR2, MOPS, 16, 4)
-FIELD(ID_AA64ISAR2, BC, 20, 4)
-FIELD(ID_AA64ISAR2, PAC_FRAC, 24, 4)
-FIELD(ID_AA64ISAR2, CLRBHB, 28, 4)
-FIELD(ID_AA64ISAR2, SYSREG_128, 32, 4)
-FIELD(ID_AA64ISAR2, SYSINSTR_128, 36, 4)
-FIELD(ID_AA64ISAR2, PRFMSLC, 40, 4)
-FIELD(ID_AA64ISAR2, RPRFM, 48, 4)
-FIELD(ID_AA64ISAR2, CSSC, 52, 4)
-FIELD(ID_AA64ISAR2, LUT, 56, 4)
-FIELD(ID_AA64ISAR2, ATS1A, 60, 4)
-
-FIELD(ID_AA64PFR0, EL0, 0, 4)
-FIELD(ID_AA64PFR0, EL1, 4, 4)
-FIELD(ID_AA64PFR0, EL2, 8, 4)
-FIELD(ID_AA64PFR0, EL3, 12, 4)
-FIELD(ID_AA64PFR0, FP, 16, 4)
-FIELD(ID_AA64PFR0, ADVSIMD, 20, 4)
-FIELD(ID_AA64PFR0, GIC, 24, 4)
-FIELD(ID_AA64PFR0, RAS, 28, 4)
-FIELD(ID_AA64PFR0, SVE, 32, 4)
-FIELD(ID_AA64PFR0, SEL2, 36, 4)
-FIELD(ID_AA64PFR0, MPAM, 40, 4)
-FIELD(ID_AA64PFR0, AMU, 44, 4)
-FIELD(ID_AA64PFR0, DIT, 48, 4)
-FIELD(ID_AA64PFR0, RME, 52, 4)
-FIELD(ID_AA64PFR0, CSV2, 56, 4)
-FIELD(ID_AA64PFR0, CSV3, 60, 4)
-
-FIELD(ID_AA64PFR1, BT, 0, 4)
-FIELD(ID_AA64PFR1, SSBS, 4, 4)
-FIELD(ID_AA64PFR1, MTE, 8, 4)
-FIELD(ID_AA64PFR1, RAS_FRAC, 12, 4)
-FIELD(ID_AA64PFR1, MPAM_FRAC, 16, 4)
-FIELD(ID_AA64PFR1, SME, 24, 4)
-FIELD(ID_AA64PFR1, RNDR_TRAP, 28, 4)
-FIELD(ID_AA64PFR1, CSV2_FRAC, 32, 4)
-FIELD(ID_AA64PFR1, NMI, 36, 4)
-FIELD(ID_AA64PFR1, MTE_FRAC, 40, 4)
-FIELD(ID_AA64PFR1, GCS, 44, 4)
-FIELD(ID_AA64PFR1, THE, 48, 4)
-FIELD(ID_AA64PFR1, MTEX, 52, 4)
-FIELD(ID_AA64PFR1, DF2, 56, 4)
-FIELD(ID_AA64PFR1, PFAR, 60, 4)
-
-FIELD(ID_AA64PFR2, MTEPERM, 0, 4)
-FIELD(ID_AA64PFR2, MTESTOREONLY, 4, 4)
-FIELD(ID_AA64PFR2, MTEFAR, 8, 4)
-FIELD(ID_AA64PFR2, GCIE, 12, 4)
-FIELD(ID_AA64PFR2, FPMR, 32, 4)
-
-FIELD(ID_AA64MMFR0, PARANGE, 0, 4)
-FIELD(ID_AA64MMFR0, ASIDBITS, 4, 4)
-FIELD(ID_AA64MMFR0, BIGEND, 8, 4)
-FIELD(ID_AA64MMFR0, SNSMEM, 12, 4)
-FIELD(ID_AA64MMFR0, BIGENDEL0, 16, 4)
-FIELD(ID_AA64MMFR0, TGRAN16, 20, 4)
-FIELD(ID_AA64MMFR0, TGRAN64, 24, 4)
-FIELD(ID_AA64MMFR0, TGRAN4, 28, 4)
-FIELD(ID_AA64MMFR0, TGRAN16_2, 32, 4)
-FIELD(ID_AA64MMFR0, TGRAN64_2, 36, 4)
-FIELD(ID_AA64MMFR0, TGRAN4_2, 40, 4)
-FIELD(ID_AA64MMFR0, EXS, 44, 4)
-FIELD(ID_AA64MMFR0, FGT, 56, 4)
-FIELD(ID_AA64MMFR0, ECV, 60, 4)
-
-FIELD(ID_AA64MMFR1, HAFDBS, 0, 4)
-FIELD(ID_AA64MMFR1, VMIDBITS, 4, 4)
-FIELD(ID_AA64MMFR1, VH, 8, 4)
-FIELD(ID_AA64MMFR1, HPDS, 12, 4)
-FIELD(ID_AA64MMFR1, LO, 16, 4)
-FIELD(ID_AA64MMFR1, PAN, 20, 4)
-FIELD(ID_AA64MMFR1, SPECSEI, 24, 4)
-FIELD(ID_AA64MMFR1, XNX, 28, 4)
-FIELD(ID_AA64MMFR1, TWED, 32, 4)
-FIELD(ID_AA64MMFR1, ETS, 36, 4)
-FIELD(ID_AA64MMFR1, HCX, 40, 4)
-FIELD(ID_AA64MMFR1, AFP, 44, 4)
-FIELD(ID_AA64MMFR1, NTLBPA, 48, 4)
-FIELD(ID_AA64MMFR1, TIDCP1, 52, 4)
-FIELD(ID_AA64MMFR1, CMOW, 56, 4)
-FIELD(ID_AA64MMFR1, ECBHB, 60, 4)
-
-FIELD(ID_AA64MMFR2, CNP, 0, 4)
-FIELD(ID_AA64MMFR2, UAO, 4, 4)
-FIELD(ID_AA64MMFR2, LSM, 8, 4)
-FIELD(ID_AA64MMFR2, IESB, 12, 4)
-FIELD(ID_AA64MMFR2, VARANGE, 16, 4)
-FIELD(ID_AA64MMFR2, CCIDX, 20, 4)
-FIELD(ID_AA64MMFR2, NV, 24, 4)
-FIELD(ID_AA64MMFR2, ST, 28, 4)
-FIELD(ID_AA64MMFR2, AT, 32, 4)
-FIELD(ID_AA64MMFR2, IDS, 36, 4)
-FIELD(ID_AA64MMFR2, FWB, 40, 4)
-FIELD(ID_AA64MMFR2, TTL, 48, 4)
-FIELD(ID_AA64MMFR2, BBM, 52, 4)
-FIELD(ID_AA64MMFR2, EVT, 56, 4)
-FIELD(ID_AA64MMFR2, E0PD, 60, 4)
-
-FIELD(ID_AA64MMFR3, TCRX, 0, 4)
-FIELD(ID_AA64MMFR3, SCTLRX, 4, 4)
-FIELD(ID_AA64MMFR3, S1PIE, 8, 4)
-FIELD(ID_AA64MMFR3, S2PIE, 12, 4)
-FIELD(ID_AA64MMFR3, S1POE, 16, 4)
-FIELD(ID_AA64MMFR3, S2POE, 20, 4)
-FIELD(ID_AA64MMFR3, AIE, 24, 4)
-FIELD(ID_AA64MMFR3, MEC, 28, 4)
-FIELD(ID_AA64MMFR3, D128, 32, 4)
-FIELD(ID_AA64MMFR3, D128_2, 36, 4)
-FIELD(ID_AA64MMFR3, SNERR, 40, 4)
-FIELD(ID_AA64MMFR3, ANERR, 44, 4)
-FIELD(ID_AA64MMFR3, SDERR, 52, 4)
-FIELD(ID_AA64MMFR3, ADERR, 56, 4)
-FIELD(ID_AA64MMFR3, SPEC_FPACC, 60, 4)
-
-FIELD(ID_AA64MMFR4, POPS, 0, 4)
-FIELD(ID_AA64MMFR4, EIESB, 4, 4)
-FIELD(ID_AA64MMFR4, ASID2, 8, 4)
-FIELD(ID_AA64MMFR4, HACDBS, 12, 4)
-FIELD(ID_AA64MMFR4, FGWTE3, 16, 4)
-FIELD(ID_AA64MMFR4, NV_FRAC, 20, 4)
-FIELD(ID_AA64MMFR4, E2H0, 24, 4)
-FIELD(ID_AA64MMFR4, RMEGDI, 28, 4)
-FIELD(ID_AA64MMFR4, E3DSE, 36, 4)
-FIELD(ID_AA64MMFR4, SRMASK, 44, 4)
-
-FIELD(ID_AA64DFR0, DEBUGVER, 0, 4)
-FIELD(ID_AA64DFR0, TRACEVER, 4, 4)
-FIELD(ID_AA64DFR0, PMUVER, 8, 4)
-FIELD(ID_AA64DFR0, BRPS, 12, 4)
-FIELD(ID_AA64DFR0, PMSS, 16, 4)
-FIELD(ID_AA64DFR0, WRPS, 20, 4)
-FIELD(ID_AA64DFR0, SEBEP, 24, 4)
-FIELD(ID_AA64DFR0, CTX_CMPS, 28, 4)
-FIELD(ID_AA64DFR0, PMSVER, 32, 4)
-FIELD(ID_AA64DFR0, DOUBLELOCK, 36, 4)
-FIELD(ID_AA64DFR0, TRACEFILT, 40, 4)
-FIELD(ID_AA64DFR0, TRACEBUFFER, 44, 4)
-FIELD(ID_AA64DFR0, MTPMU, 48, 4)
-FIELD(ID_AA64DFR0, BRBE, 52, 4)
-FIELD(ID_AA64DFR0, EXTTRCBUFF, 56, 4)
-FIELD(ID_AA64DFR0, HPMN0, 60, 4)
-
-FIELD(ID_AA64ZFR0, SVEVER, 0, 4)
-FIELD(ID_AA64ZFR0, AES, 4, 4)
-FIELD(ID_AA64ZFR0, ELTPERM, 12, 4)
-FIELD(ID_AA64ZFR0, BITPERM, 16, 4)
-FIELD(ID_AA64ZFR0, BFLOAT16, 20, 4)
-FIELD(ID_AA64ZFR0, B16B16, 24, 4)
-FIELD(ID_AA64ZFR0, SHA3, 32, 4)
-FIELD(ID_AA64ZFR0, SM4, 40, 4)
-FIELD(ID_AA64ZFR0, I8MM, 44, 4)
-FIELD(ID_AA64ZFR0, F16MM, 48, 4)
-FIELD(ID_AA64ZFR0, F32MM, 52, 4)
-FIELD(ID_AA64ZFR0, F64MM, 56, 4)
-
-FIELD(ID_AA64SMFR0, F32F32, 32, 1)
-FIELD(ID_AA64SMFR0, BI32I32, 33, 1)
-FIELD(ID_AA64SMFR0, B16F32, 34, 1)
-FIELD(ID_AA64SMFR0, F16F32, 35, 1)
-FIELD(ID_AA64SMFR0, I8I32, 36, 4)
-FIELD(ID_AA64SMFR0, F16F16, 42, 1)
-FIELD(ID_AA64SMFR0, B16B16, 43, 1)
-FIELD(ID_AA64SMFR0, I16I32, 44, 4)
-FIELD(ID_AA64SMFR0, F64F64, 48, 1)
-FIELD(ID_AA64SMFR0, I16I64, 52, 4)
-FIELD(ID_AA64SMFR0, SMEVER, 56, 4)
-FIELD(ID_AA64SMFR0, FA64, 63, 1)
-
-FIELD(ID_DFR0, COPDBG, 0, 4)
+/*
+ * Expand FIELD() declarations for every ID register field listed in
+ * cpu-idregs.h.inc .
+ */
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD_ARCH_VAL(v, n)
+#define IDREG_FIELD_ARCH_VAL_ANY
+#define IDREG_FIELD_END(reg, field)
+#define IDREG_FIELD_START(reg, field, _shift, _length, safe, defval) \
+    FIELD(reg, field, _shift, _length)
+#include "cpu-idregs.h.inc"
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL_ANY
+#undef IDREG_FIELD_ARCH_VAL
+#undef IDREG_END
+#undef IDREG_START
+
 FIELD(ID_DFR0, COPSDBG, 4, 4)
 FIELD(ID_DFR0, MMAPDBG, 8, 4)
 FIELD(ID_DFR0, COPTRC, 12, 4)
-- 
2.52.0

