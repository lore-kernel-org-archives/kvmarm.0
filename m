Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9453642315C
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649048; cv=fail; b=I2pvDfqRw1YgRjTEecEwl1SkER/GSr0j4/Dmbql3S/xCZsYQxku5rYW6x+SyoT2+zRxeLqm8VX0VlJGQDP1zdU2QCq/LpES2DEegzaGKn9gL1WZOpiDtuFTvVE41hZHplVTHsODUFSNUNDE5QgjPOqDYQcODqRkJ124O+MMkGu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649048; c=relaxed/simple;
	bh=47RUJCVt8fXtELJA9g3zgYvnhdtUDwDd3ccfeweQt+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AG8KDxaCW4lUFiK9kqWRPPc/LB+WZVXFxwdM98i24ZY3D/GUWrryVIxkCRxZWFU+cRCel0jWpePr8SHeNT6T5zeIUL40vUtDZ6bieGEP92b22fafUk2P8XyCfxIZ27f4jTVXv3iTumA3H1GIvcnYUkrMRCrGjU0oz+koFiZlxEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=2oSJiM0U; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KjSJjxgZ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="2oSJiM0U";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KjSJjxgZ"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLQ854749;
	Fri, 5 Jun 2026 01:43:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=/mWPfOLfwLy5iDlj9xzb0krJb2BgsQpZjLxKCIuKW
	CI=; b=2oSJiM0U+DUTh4n0dGS1Sa5fPaYmyXjbMALy9FV4JKTLENzuw2SBBHRGE
	Hs20NNROuoNpdEFRnsWVUBQQ2sxAiZpCVr3P6d7ZHPpC2TtdXmHIRZoIjIgZQCMw
	CrE/Rzf0SlVxv3CD5+naCoiTSmFtFHz6uWQHjdmcPmFdZpudoW78RNWXbz2BzeWU
	gezPTANQKU6UlBbzfkqmtMugJFzp3fJjdigQlt1HjyIdGlNu9sY9PUtrBRfociax
	EBT1xs5xAmIGDd0ZqfeXv4PhnA6gJAWRUoBcvq/NhMfJ8MCI72lA/hO4jC5u6xle
	31c0v1ZBHZDsKhIcMeKM8cYBrjFxQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-7
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKVtEzJDIMOq8yjeTZZEGVn1p5UBmaw9aP7qg46yCdi79n+VpKCzpKVmuzhusg08WWDFibMFuQTq0PQ2miL9TRF2q5VFB6d3+tSbG0sdvRqrg98fPiwJa53daaRYJUT9RhgiVH5vMLnL79aNcI8ACxv5N461oCQSvP+FGIlqXWOpVl0GUa37VtLMnjRMqXQmHuwnxHabpw9M80F2YD2mcALx+ulwD55AFmzPEMh2iBURR447hNZCUsTNNxkFgLxvpRNvbC0Fr6vWR6pgGcuVZnPdGAVwTIvAnTrDPmpzUizrw5aChoS6Z+6dIw7IBul0U0etJmdA795PYFHUkB3XUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mWPfOLfwLy5iDlj9xzb0krJb2BgsQpZjLxKCIuKWCI=;
 b=kcs9tmc22zpLMFNZY0A40gopMVkxErgPHcSwt4K4NCkn3cFtZKk0C3vwsDpcBxkvwF5dhcxjv6QG4m8FxB16Cjw7LDhv7fRrUEeXmF7yxoBRUTw0KVAh8DBseDgwFXH5gSHrVMrNgpuljIyeezXb/wqMYNPXyBkpeA3Z6tliQZTWjNy0DP4aDxUQZGxr80iI8QRfC7Orvw1t2tX7VesmrtkfvY4e+U+3W+oyBZm3+GOA69VmupRtcZzEhUVwKExLMxnMbum6XqRz8SMLJSg/ZI7RTJeOgT8eNgeXlkpw3GpUvqo8g33XkYfCDtEAHdSY/usIXv2Mj1NVnlBT/bL+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mWPfOLfwLy5iDlj9xzb0krJb2BgsQpZjLxKCIuKWCI=;
 b=KjSJjxgZ1qqzNIjgNtce5qEtO8J2fb9HvphvnL4m67AONlOOShELWYv+7v3Lxh5V+XDigQkw4ivG80E4bmqrCb+l6vEP6u/9fmlp6ByrAo0A95j4yFWKKs8LRneUcExhvPqwEKA6Ol1ihsSu5KLGPt3K+adIWyLIm2GfIpKmYm1sHJS30v+HMFjlcpy2j01Lva7aU4WKXlpZQFVh4/TR6BOxUePc39Hw/OrA6dcM9esetBREb1uQPohWXOc1KKURY6O4fnnSdX52chjceF6sKLB6krfFPU1pZHp8LEU9WUlLt4XzKBBnMy7T1kVPMKuVsKXR9SLgxEMQUg4iVjrYNw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:11 +0000
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
Subject: [RFC PATCH v2 06/29] target/arm: Introduce data-structures for the ARM property layer
Date: Fri,  5 Jun 2026 08:33:35 +0000
Message-ID: <20260605083358.1320563-7-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: bcdd2995-e8e4-4251-58f7-08dec2de794d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WpTibokNS3HkE3CmFFbkZ81qezu07qGuVxo0LN2TJzEBLlAT312XIfxNr+W8q1pkpVzTFDw0pM49x9Jj5k766R+VJEaa1ZKlf4BorAm/h1LkVNFTLSQdS0vdmdUmIY9ig5gpmHWFntDTrfF9TqbqqWpgISBNp4evDvhQye3s6YPmcvNjcvCiIRDolFNLTKUgf9oGs0Sd3R9DU0rHvswz10WGmOz51J2O6b/ge4lOCbalCgty6GJgjiPOj7ih2Hs1OkPPm74HtuDpqBDa824JUx9cNNK81LZE+o4UNiPWSW1FPi7R6qdp0yh8of06OzBO7IzAuyFd4evTo1aoQ1vvVx8nWLIa6QKzOmvLmLixyU71+3vfQzB2Q8eEJrV1j6fNxi24hRkt3VpYe8V+ZhoHWLiT6qUKlqyddipwuY3NFj5fYnyw5SZOfa6KhvLCXimYWUxQ49nABciUZJ/oOZUh5uS8gJ/28txD8oqafkk7Pz18lp8DOUHnnsiLWl84zWSyzZxEAvHQ0yokJPtJFuunUWrjFPWaTvioCKKsLxOciM9M/AA9N3eYZJ00Cb9JgNFop4EaadZ3FtaqXnDmId7kb4K4mVo9apLgmzcUePsN9Po4uz202x8y6ztEEgaq8YHFj4b1M61c9vrfXJ++wdLahxVlcIfqyPUjmcnLUhPuy7e0QX/tGrAiA4GtgYpYsG5y
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tRrMpVGblHeWOwNfI2gk8Hz64q9TDVvOTMxxIoI353vRcTxbsQ5PoHQsNvqS?=
 =?us-ascii?Q?ZSoQkPO/OV6Fn6qcGgxmjZ0TONG+8f2uliYkdnhbVe3/F9mqjlHuD5ejo101?=
 =?us-ascii?Q?k7uMY4NKOrsz9hvU+yTMGZGOMuCY5IX/3EuhpRWy8eBsxMh861IUG9j8Te8c?=
 =?us-ascii?Q?H82iMXW7cwXtPuX3k6XKRv9FU2GX0Tup+5EsuKnWCvc4WXGYI176MVVowymh?=
 =?us-ascii?Q?otBwNDDTXPnk2hMpce9gPr6THirWydj/dl8KU2/tnAJopFhHw6GQmQ40+nkl?=
 =?us-ascii?Q?k15VUeW7dGqIEyrH7JSgm3cZ5bEwGUr0+pRWHNFEsmPsZl4CIui2ZangahyI?=
 =?us-ascii?Q?uqL9kHAx2wOcJpawzc/ewUTh9tcqmNF3W8wC0ic4fC/BeXRMUXqBFCalOHP7?=
 =?us-ascii?Q?oDPwnnLeIxKQ7fShKxL+9IapGdEnd08wXxrNxBVIfgZOCfgr5m8rGIpxINUQ?=
 =?us-ascii?Q?ZKnftTr0VR5uirp76cHXfPRw7KU13UI5UL2oFgEafIm5bdA1lBp/uumQt48e?=
 =?us-ascii?Q?bHM0u5/KH97fse2LEqy7EhyF5qC8gqCaQdm72mstMCx0z/sILOFl4AOYxXqA?=
 =?us-ascii?Q?Lw5y+426KI5v9UxuKwOsErMVSz0cFuXrT5kuKiYndbbfYZZZYfKqk8j5e4u3?=
 =?us-ascii?Q?d8oLO1LNhG165e218U6IY0XS9Xcs/1Xa/nWKgfoGW9ge0eCutQQ4aKot+Ff/?=
 =?us-ascii?Q?bqbd9pypGrdT8wpadPbnVrrR9Pa90lw8MXPfhI6DInF/AFYIzeXGtTJYfQ5m?=
 =?us-ascii?Q?cfEaGHmZGQb0JZyRPd8RXFFLiwLgLrVIZMgANSZh4ZhH4uEpzegBDCuebMYw?=
 =?us-ascii?Q?KRGYBQQi1B7EkH/Rcy7QUnaExFjXB5ajc6R7WSja3JOVGX0mglekXKx8FEZQ?=
 =?us-ascii?Q?xfEYYwLTX6SlqJiYoOja2hyC8B7Ay8l1DtN5fABALctzC4m5vN8C7Up8wQ8o?=
 =?us-ascii?Q?LiR8Xg0Vka7lhRsOzYJ5CipkexUGnIuLweV6FaN0rwCRI9+L+ExkFStqGhq7?=
 =?us-ascii?Q?0jCeWyVYgwmLwjnQcpbsXNP51oRBKkqsKtc0+azbQCdH3+EEUU/mAxrfMaM4?=
 =?us-ascii?Q?IYFSADDCqgJcpH/RQd8ghXqpBBObxoe46AnXopfsqW+8CSdCBIoQToxXzdYX?=
 =?us-ascii?Q?SBuwxJHjyxrRSZ3wHgpyVPp5oesJRwK9w/Xj0pyIfmODj8Gfwqe+aaWaZl01?=
 =?us-ascii?Q?KsLWaZ0+Q0ibUMv/RY7cETysXr+xyqz3uvtu0exj8lUXCl2+clWkzKqjWxVT?=
 =?us-ascii?Q?frNILf9o+a1XLBlSKSaX5NFStcOJ9n9ZuIczXrru1M44NupXAaxIuzUVEuJS?=
 =?us-ascii?Q?pITBZz4rze/O3gts9PkKHIgR2Kv+WOpQ5uAoaHZc2jIM3lPbpnb5GeqD/+nj?=
 =?us-ascii?Q?aHsoDte9MIKkiL//T2JfVKQgQcin83sbhoIf6OWaZy97AkO5X2Fp8FX7ukO9?=
 =?us-ascii?Q?emLYzSFZfwykHM5R3aih5kqeQ2ob8P380N6wA8C91OmIjAwSpBmntg3byI1h?=
 =?us-ascii?Q?/HkMDuJukE65CUYeOQuoqpZIo1zO90m/Pmvz1CsBDBeAEm1wso7wUb3cIWiS?=
 =?us-ascii?Q?WvRth6pDJH0G2hbwvlgL1u2+EzYs5AsR9694ZFPOrtu/UT6JZ1uLlZRZjKNH?=
 =?us-ascii?Q?RBr7ipPpPa3a981yzgGwSWJoW7A2IBmsyYgWluqTTnhR6NZY17g1X9igVsKx?=
 =?us-ascii?Q?TRS9AfCSfphhyVKxOzs/EXTVnQYFwzVy6hPERUHptUJtIA2N8B/CKj7vQdVj?=
 =?us-ascii?Q?lPt/Ims5XTqtd0nBigptbh7zzTNGEgA=3D?=
X-Exchange-RoutingPolicyChecked:
	cYfF53rZ/5lq7CHHU05OeVUz8GELY7coFs8LXUthE6vyYJ1mI2gGPBZzWW7zLIZRlvAn8yZMsNV/+Q7/aZStAFu64jA5dyf8e9gbwY5V4T7iaq4zLlnCeR8ZzmSrF1BziCQpyo1nDWKwsHpKRh6GPfWUdQ6SluxRrUp+4Wjr6MgcZJec86jb8SuRa9t4lRpRrUAupa5qkK8R9TRiC3kBTE+Y8m0QLjd0VhCgpb0nSm2PPEgbavTHYIFyW81yXDvZVNPWK1zmvjkAGsPlXkUK2TyYyz9ItYmLDcs4qcwWfj1Fgre3gb+yof6fU26XEvDEoxnl0JUpdL+MFnEzbThfGA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcdd2995-e8e4-4251-58f7-08dec2de794d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:10.8558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gF/zQznTzxTrGAv/AJGl+U/Hd1Fhy8aHTmIWmUNmyCbuSni4+OQMT0kma6LE6781ROQZgFXQiyNOQfq9ESBXhIZOTHCtQwTCAb7bxhFd0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: otTpHxoaAoa-gaLdUF5mwZnoLOLaI6cx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX84/CLKNILUcD
 gndEtHCMkE+R3dxEFGaN4WOM2ff41w2EtKOfAKc2wiT0VxNjWQ61AsPSBpTXZamE6nLzchjiUPx
 btkF5QJQB/wa/e0QYKaGP+pRIUU8EbC4QqZWDC79Gg8sCKQnKINMrK4NfY4IF68mnYCNemDC5iP
 sUf2NG+9sVyczknhAC3tSGmMmUK1Mt0NGncQBVk1MS+sJr5d6imCprEYQ7ipuSLSN+O9sPmF22d
 1YlTm+shf5mOyK5gLXxGKdSb8sdFsJKSvEqA3WiXS7NdpUy/y96nkbIssMqP/w/51l+huMpafVV
 4ognjl+KjlqFgw8/FOgB6F7vKXyVyg5USp3oheGi5Iiq2rOj8W+I0O6XcfJcjtFY3Rqyl+1ul6D
 ARQDdAsL8ZO+SiWay7zTsYPBMHyX2F50SizaDqmr+yzW7IarLrxALDnMDN7p0tvkaGbBlMjRgIn
 tjTKzQ7ccx/64/WbSgA==
X-Proofpoint-GUID: otTpHxoaAoa-gaLdUF5mwZnoLOLaI6cx
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c22 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=BgGpAQATSyp6DQixMf8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce the data-structures required for the ARM property layer

Initially support 4 types of properties:
- STRING: 1:1 mapping to fields that have architecturally defined
          values. The value names are borrowed from kernel's
          sysreg.
- NUMERIC: 1:1 mapping to fields that have implementation defined
           values like cache line size, debug counters etc...
- BOOLEAN: 1:1 mapping to fields that are 1-bit wide.
- FRACTIONAL: maps two fields, BASE and _FRAC, the valid values
              for the properties must be preset.
              (Example: MPAM, CSV2, NV, etc..)

These data structure will be used by next patch to define ARM
properties.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-props.h | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 target/arm/arm-cpu-props.h

diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
new file mode 100644
index 0000000000..2c9bca9d97
--- /dev/null
+++ b/target/arm/arm-cpu-props.h
@@ -0,0 +1,41 @@
+/*
+ * ARM CPU feature properties.
+ *
+ * User-facing QOM properties that map to fields of the AArch64 ID
+ * registers described in cpu-idregs.inc.h.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef ARM_CPU_PROPS_H
+#define ARM_CPU_PROPS_H
+
+#include "cpu-idregs.h"
+
+typedef enum ArmCpuPropType {
+    ARM_PROP_STRING,
+    ARM_PROP_BOOLEAN,
+    ARM_PROP_NUMERIC,
+    ARM_PROP_FRACTIONAL,
+} ArmCpuPropType;
+
+typedef struct ArmFracVal {
+    const char *name;
+    uint64_t base_val;
+    uint64_t frac_val;
+} ArmFracVal;
+
+typedef struct ArmCpuPropDesc {
+    const char *name;
+    ArmCpuPropType type;
+    union {
+        ArmFieldIdx field;
+        struct {
+            ArmFieldIdx base_field;
+            ArmFieldIdx frac_field;
+            const ArmFracVal *vals;
+        } frac;
+    } u;
+} ArmCpuPropDesc;
+
+#endif
-- 
2.52.0

