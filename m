Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956D718AFE
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650527; cv=fail; b=BXx7BSZJ3aii57R5Qt5qpFk2wBZs6qbYkHPZrpiDn8DyL0pFupoTi00MaPu/h3oPzDC/FFYtQANTIK+nVoWNUXqzPP37rqOoKbChhYwpsL4HdgoHFdxmV877ICUs+Sz6XfPASFXK869XGdJHLmZ4AfNvkVZsVQuE+1b/gRVbMng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650527; c=relaxed/simple;
	bh=wWHgqIooq5AK6h3PXcC+O4aKfSy2CJo5aBKsQTSOlQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QrkDdeL/0QYq9lqXXiT+oScG3X6r4npb4Pu4g0ZPD8sdi8CP4HTxrZH/4aO0rOytwc0GOsN+zDBi+B0J+JqgNRPoq84R5ikeeL5jQLdeC722+KFvVx8ZbsA8PqcVVYPvRNhGmthivCQP3u90Yur9zAb0Nfqa0sUWoPAp9lTTOBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=G3l4wnk2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mgQZyIkr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="G3l4wnk2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mgQZyIkr"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUR1185382;
	Fri, 5 Jun 2026 01:43:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=4eN5nXJoTKGpnFp/ezkq0RZhikSERKquIwk9Lr4+E
	R0=; b=G3l4wnk2IgdxW/4c0ujMVZlFOojUIe7jE2wHM1csQfymhaWGgd2563iOz
	hTKSYbiD5hOtdZo/XYcT+g5WXiMNZHBHfBA2bc3B2M78XrCYJ7RpglhkRQoklsS2
	9SVeWJ5ePUUGaFB+4Kkacnth7tCjLu7ZvZ2spl+uxCuVQxOs7J/4e0NbKwtRHYtt
	T/1taA/pWXjSg/VQn6PucETZaTarqygtK4onTnaw1xeUpPKSLNcldBxNH70fre9Z
	I0UEykQtd8vPB3YMxiPIfyCnixFrn1RL8JGVr5et+KkOzUpFwRK1lIv6fkZKwR06
	szkq57PdnXQFiYMXSdVtrP4kQbnNw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-10
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SHyuO6xGHhV8tdQ3245MiS90Un6vOqIUf3JBOrikNc6gm+XWnt79OBJkUR5jxN9OaFA3xibGMnVzBjfP5RJyiF3pnop8qcEiw+a9TrqhN88ECtlV5eH2veR/MX2mea+6GFRqecO3CfsPtLX7Ld8bZr5hcuk8THHxmQYjhXr3z5RNEWGyZnU1n7aLGBgz6rPNMJjhaZffGKjUm2Ax1ZLnzoI7zctIIW/sTaY6GeqMhe5FV/cHImdA89KNvqOEsfu+bVcLp41fTFPRqDgHFjEaRB5BvwHJepMujQQYxm9m0dM4qC3Av1tIXXyjdfJkpx5KncHcH/6X9IW11n/BXR8GwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eN5nXJoTKGpnFp/ezkq0RZhikSERKquIwk9Lr4+ER0=;
 b=Odc35ha9ZL93CtyLD3tuzazjBynQv5X2ZXkyVTjEb31saj7md3fWsIqBfWHLv24y7Ad4IHIkbcUq4TVWeegVhS8uGoo+A6arCL8PS9+XO2zIZcoXOyGL8sUJ4SpAzRxOchX+KpobZ1GRI9PJ4d5mkTb8BmqTemjO4XXcxuuO16JpPKM74FlQUHtdbGTuTPL0WSTM0WgQKItHZaKB1GcX28zWr88Gz7Z3C7vt17buGeH70hMgBta8MnFFiYoxBEQcrMSIyJkaacsR/cM2V5pGsFMmfpAzHx0PcJjebNnqwwLqv2Y2vN+M9HYb4Nq3H0WsjcqcUsNWb90enBmNEA9ueQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eN5nXJoTKGpnFp/ezkq0RZhikSERKquIwk9Lr4+ER0=;
 b=mgQZyIkrocghAMOZfYfMoTqa//KC9gDZBQf9UgldvCADsUMbzpZjFb9RWf95tsey03uAmD2jx7AhGgh1QVZLJHiEd2ERlAvjPODiqQebKao1Dk99Td3XV1134LtpcvjkAcSNa8Ch8fcr3ZKG7hG6l8lvjBGT2/+f1mszDqddbfENCFUl2dDwSMRsYl7zlCvoi+/60yJPKC6yUn//sSBvBFZaCxHo604CWXEYhXb/ueZ9XCiRNTDDpXlrS8MK6Yq1ZnNp05Ukb9RYyrMDfZEEA0XhuxHjaRTHT+USuyTpcYCXsQXX4UGsIDeyxZLy3zXwuzfYlwRCDYNg5zPtGdYswg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:21 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:21 +0000
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
Subject: [RFC PATCH v2 27/29] target/arm: Provide default cache hierarchy
Date: Fri,  5 Jun 2026 08:33:56 +0000
Message-ID: <20260605083358.1320563-28-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|MN6PR02MB10630:EE_
X-MS-Office365-Filtering-Correlation-Id: 25ad1e72-d514-4129-ac07-08dec2de7e42
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LHh10VEL5jOeWTis7LMwekloftiJEC4w1d1rPxb1g89kqqvxuzZdRpmE5BKjn/P3i+UwVOdX3uhYGGzCFedSU5Ii5Yx36kvmbqnl345Sn+r5UWu3akSQtWfHl/PFH2UtmIBIzUTX5gQNsD0VI3moEDuUSFaIoK01NvBQs8a+67lOnTSz5AGOBBlQ2vm+XyfffafFxct2zGzeuCWAcwYZcPh8HCP+r7E9wXEvvp5FDgpXyM9VURtEawygJfnWt6+nsWSgXs+vWC0fIEQDZ66XOm5gofWbb3W9qbpDDIw8KIMlXeciDlGilcXDPqhL7iqjrLoUX5FX17UXKEBL9DN6ps2SPDw4vScwRhNBpA4aPOhJWrGLvxI9/+tf1GzxOqIyeisRm+St6/z5+f+dWRfxoO+wxeXPUD/xzQrejvb41X7PcFD3OyXEZd1KUgd7Iz5oi46v5OiHBAwOivjcOYqQtUaLI1myx0/gY/K09CaYq5nmpuItdmtyDdnEIb9pUIrgfNm4GqymjE95h0IgQ5bKQqi07EHQ64AJ+Ua8Jv2x+HmC7sZZTc47PB5bKEqWkfhIXomQxaK/tTu+smLGc5DRw3xX2frNmmwD9YH8p9FkPm1iE//nYaRuWKUuuOIBFcgl6Y4dzHE5zeoCA8vsWqBh/9aL7VnASUZJfZdQ3ZyAADM2TV3BeDZ+UvoJhHoY7VEC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ngJEe4EWuBIyY4/tzBnOFWIjRArYNzlxrMxsn5BPOdxT7hpewvwwCf6mFj/n?=
 =?us-ascii?Q?ePu8VZBLMh3gsLTutBSZdvvWYDcY4wyZVWv6yErLnepSYbMYhvwZ4YJGDcUX?=
 =?us-ascii?Q?+0p8cTKZ501XakZ0ZeHaPooeP1vFuvvt7aTv+iM/nA3HsmwiMQgFANIa27nb?=
 =?us-ascii?Q?6Wc9yCtac4qGv8mBwZjoax4E/sP40gYCaDAUeXw0B72U7EQBgIeg5OiFoVMj?=
 =?us-ascii?Q?TQWcWbuR0o2dcS3dA6qiEm0T/uQDWeeanFtun6wxxpviUJUIYD6Z78xIVw5X?=
 =?us-ascii?Q?F95PvUjWsdcd0+TYuBCiQvCIYRmDCqkH9jlAYqThG6LkmMdfF26Z3Y1mjfzr?=
 =?us-ascii?Q?hHSrwX5R9ttNzcORUztWgmPzrBr/vkQBCUeCQ9iLLS0x2FvtIiTEPSxuOZjk?=
 =?us-ascii?Q?a/rY5yPYLFi5wW9EG7/virifIwlNJp2xcQOF7+7YJ3bMPLnzc7/FS9xTZfMD?=
 =?us-ascii?Q?VKCbY6marYQs1i5k6JorFIFIxLoD0M63PNqVZV3JOOMUFOWRpgJyLuABnp+r?=
 =?us-ascii?Q?d9VFfr/s35iWVwNfOpzjkr7yG3d20kVLtFks6UP0oNFFyH7UnLHwx/oYC9By?=
 =?us-ascii?Q?1lKdTrUwbgirIvaw1wptJgTsq08xVaeiwYK5ecDK8+OHEa1EsraYeUVdUZ73?=
 =?us-ascii?Q?U4ShjBPb4UKCbcCBF9iAEKD4gUhNyPSHEiwlXpc+qQSb1o1mlQlKNFyA17Jy?=
 =?us-ascii?Q?0dS5Y7Gylzw5v0gj1WztZh9Qy6p/JxEHT9ww52ggwVjDQIKxYNb7BmuQEPVt?=
 =?us-ascii?Q?Z88Zswn9vNSh2NfYUxvbOT0SR44z7OFNdU/LuswRVKgxuEE1rjT5tV7tIImf?=
 =?us-ascii?Q?msgPhhqKTUBXq9dfRIp90moPMUhg6Sf7aC6D4A0x2M/Z2SxU5U147pKPz16O?=
 =?us-ascii?Q?/BwGmRDow9q9cKmROo+bX8GALFzwruHSbM5Y7PJkWOsOXgaV9Cd/SkM9NBHh?=
 =?us-ascii?Q?3CC+WF9TxcfgP97E8B4fHRGLiCTaJMWEHMyqWHThe17y4S4LVAGPlecj3Tw8?=
 =?us-ascii?Q?l/enOGSO6LBCKCzBuXQpuh2YaqU5Cdg17VZeCoFbR7/0iCaEfVj1MmUQENtt?=
 =?us-ascii?Q?WRfajCN1mDBCrOv8JU8E/0MmTty/ijvclEl3TGWudwBgpo277Ws/IAuQTrXV?=
 =?us-ascii?Q?0IZ7ikoEq34dN1RwG3kYUNcl9mq5VoJMXdMxVmGR97UbNVgkQFQZZkVCGRoO?=
 =?us-ascii?Q?fbEqap/hv0igLw9YmIxWUiSlS6jz9PtZ+qFlYUe/WCQ7MTdairy+eI7jTwLX?=
 =?us-ascii?Q?aLlJfSfZYvnAQ4bpvrwbSFVmGpIcQz07hI8Ny46TlLmFUo1e1pADazaX6oJw?=
 =?us-ascii?Q?S+PhKYaHPMyjEBZv2YQjxUw65lyZ0YPQ/sYspuF5N3ltgHdR4fC+o0fSFi27?=
 =?us-ascii?Q?eYJxf+8EpzGBXbCfNTW3c5jxJxL3/5nYJEgusmxa7kdAxBYiwXfkclG0YgFv?=
 =?us-ascii?Q?0Jy4kG2r2bQ2Jte2e5tr0y5hcIDbaj9MjKGy9xYzpsKIxelEZpJA03MC+jEi?=
 =?us-ascii?Q?4GXk71vojmz7awMY9Df9kdxnwbw37CZJtoV5fbqyZ+v1PosglldAGBv0Kfe4?=
 =?us-ascii?Q?Q76ez/dJxcs3qDG/gpOvNYrGrYCet9ewmomqs4oDhAiui8a8BVMpNGP2kvOO?=
 =?us-ascii?Q?ozSKrHsE/N93Wq8I1qOtgxIL0PmCB6e9D+O2U8zmqiQgPFb19MMj/m7/nYze?=
 =?us-ascii?Q?KoLzJdhkTginftnKdEO5HgbS0TZotKfMYibgsUhb89drzP+4tHwrZ45oogGX?=
 =?us-ascii?Q?8UFqLELuk3I50C/Wn3L1lluk1X4sLts=3D?=
X-Exchange-RoutingPolicyChecked:
	OMw6XZuAQ9tTrYm47LMbWg6lMgD8QtQLl6106KaKwV42oRQBoEUodY6xjWfCpJutJ3VXwWZVqBEKKJwJI5fTuWMh9Q2K5c40Y4TGVAw+3USE01szf75jeAxdhE5JIA9YVF3H+6AMU/ZVfqjYKv8tOLo8Oe1eK95H7VefTBdtj0x79rkgTgIMDlbO/PF34eFvpGYYXlD5mt7X4XJcd5Up9UIbQ2y3Tes2iBYqjEb7lmpjx1txseDfQC19XRvf0ioswlCZxBsXuootnPN9ZsuZ69ZN1RU0elMVHvu6eDnNjfP5YW3NQzXM3CrFbpikIW0s8hqQmh+Hb2QEoOo4f5ohNw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ad1e72-d514-4129-ac07-08dec2de7e42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:19.1266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjIM+u0phHx7K+ySGCbaCGgWmzp5bKt9KrwpWI2kTHL9I1LM/HVCwMPjHMaSJDurkmmcJNX7HIguNtWFkXXBpfcoBB4ASutj0BKRmPk7iNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXwySXTrA9VcgA
 3zkqmUKnGzm3Y3buIE6+DXSo5rgJrE8Huh5A4Xb0FPAw3OUwOTxFC94PonaYPEPAkqxwnPFKzK3
 ILoQCQmgYLPdulaSn9ueUQACUPzWW7wDuZObJY56mbDFHa3zVG69crsoqMX6mHJTKYRAIsgiH9O
 LimJ/pMVv8SuQLRsu6gDKRGR3oB7UN7Sr3MDArvmLyqPVI0E9U66/Ru4dmZkV8BXgnaYXesfyUT
 fXTH/5S3RA9tfZPsWQFUs2jTykBzJUK+p8t8c+WJu3R5CWG8iHUxbq89z6Sgb4eS+B5HVuUm1pO
 UKfA0+QOGHNqXVGrZePqO0aH0sMMfkw1/26FCCFp2pF+hy21LwBoPLBSXyfKXpya9eoDFTuIFCh
 5UmVTlFK5FTStva2OPHP47vUExlSfh+qBkzaWPk64Js97Zg+A5F8P7f4k7r/epf8rDBE8KD+sxl
 dIelen+z0Eb8lj02hzQ==
X-Proofpoint-ORIG-GUID: qIGAG-vqrSlG759WXXwRNR2iPHUrK5g3
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c31 cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=8U3q0NyPIHcyVLjXBGEA:9
X-Proofpoint-GUID: qIGAG-vqrSlG759WXXwRNR2iPHUrK5g3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Default cache-hierarchy into kvm-base-v1, hence every model inherits
a cache topology.

Topology:
  L1:  separate-i-d, 4-way x 256 sets x 64B  = 64 KiB each
  L2:  unified,      8-way x 2048 sets x 64B = 1 MiB
  L3:  unified,      12-way x 8192 sets x 64B = 6 MiB

CLIDR_EL1 fields are set to match the geometry:
  LoC=3, LoUIS=LoUU=1, ICB=unknown, TTYPEN=0.

Whether to keep them on as default is another question to tackle some
another time.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models.c | 46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 3eafa0efc5..5f59650c81 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -46,6 +46,50 @@
 
 #define MODEL_PROP_END  { .name = NULL }
 
+/*
+ * Expose a default three-level cache hierarchy.
+ * No justifications on the topology or the values.
+ *
+ * L1: separate-i-d-cache, 4-way, 64B, 256 sets: 64KiB
+ * L2: unified-cache, 8-way, 64B, 2048 sets: 1MiB
+ * L3: unified-cache, 12-way, 64B, 8192 sets: 6MiB
+ *
+ * Louis: 1
+ * Loc: 3
+ * Louu: 1
+ * Icb: unknown (not specified)
+ * Ttypen: 0
+ */
+static const ArmModelPropValue default_expose_cache_props[] = {
+    MODEL_PROP("cache_lvl1_type", STR, "separate-i-d-cache"),
+    MODEL_PROP("cache_lvl1_icache_linesize", NUM, 64),
+    MODEL_PROP("cache_lvl1_icache_associativity", NUM, 4),
+    MODEL_PROP("cache_lvl1_icache_sets", NUM, 256),
+
+    MODEL_PROP("cache_lvl1_dcache_linesize", NUM, 64),
+    MODEL_PROP("cache_lvl1_dcache_associativity", NUM, 4),
+    MODEL_PROP("cache_lvl1_dcache_sets", NUM, 256),
+
+    MODEL_PROP("cache_lvl2_type", STR, "unified-cache"),
+    MODEL_PROP("cache_lvl2_linesize", NUM, 64),
+    MODEL_PROP("cache_lvl2_associativity", NUM, 8),
+    MODEL_PROP("cache_lvl2_sets", NUM, 2048),
+
+    MODEL_PROP("cache_lvl3_type", STR, "unified-cache"),
+    MODEL_PROP("cache_lvl3_linesize", NUM, 64),
+    MODEL_PROP("cache_lvl3_associativity", NUM, 12),
+    MODEL_PROP("cache_lvl3_sets", NUM, 8192),
+
+    /* Only set/way based guest operations will care about this. */
+    MODEL_PROP("cache_louis", NUM, 1),
+    MODEL_PROP("cache_loc", NUM, 3), /* Can we safely set to 1 for performance? */
+    MODEL_PROP("cache_louu", NUM, 1),
+    MODEL_PROP("cache_icb_type", STR, "unknown"),
+    MODEL_PROP("cache_ttypen", NUM, 0),
+
+    MODEL_PROP_END,
+};
+
 static const ArmModelPropValue kvm_base_v1_props[] = {
     MODEL_PROP("el0_mode", STR, "aarch64"),
     MODEL_PROP("el1_mode", STR, "aarch64"),
@@ -57,6 +101,8 @@ static const ArmModelPropValue kvm_base_v1_props[] = {
     MODEL_PROP("feat_MTE_FRAC", STR, "async"),
     MODEL_PROP("hw_prop_CCIDX", STR, "32"),
 
+    MODEL_PROP_COMP("expose-cache", true, default_expose_cache_props),
+
     MODEL_PROP_END,
 };
 
-- 
2.52.0

