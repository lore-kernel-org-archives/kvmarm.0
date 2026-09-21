Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322513563E8
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995805; cv=fail; b=AFqddRSKk+s0I76WnFKdjXvf0n0wIYV8RF0soVMbv9P0eIlwmb7ljV/QKDooSaI/SnNVqVJeFR9qH0zrDv83U7wFt9q1kcUQClrBg03KX/YeMRp8nFNQSzmcKBY/XboiKEOKS0l2/8Chfo0If+ikDWKbLWYJBV+SYNib4P9AORk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995805; c=relaxed/simple;
	bh=CheDa6AvUiL89PcRlD2rgpTYTbjaanQOYfAlfhlx9QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=brpUp5kf45IMJ2sq48QRNHiVgLQhnXZ8MCU0loAU+1Pt5R5BxqUQsgY/7bSk9QYjaK0q/p+l48X4sfqYDzc2lnXufzOnNGtZE7oGlwl1o4mFlwG3RRRUw2WZ+PJAZxFArZagMDn6m2stxO/XmAUOpHwp72WlCm7/7CMi5sBoasA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=buOCn+ex; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=m+knEgBr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="buOCn+ex";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="m+knEgBr"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAfaiZ685521;
	Mon, 21 Sep 2026 05:33:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=k1cPfr67ixrfZp04B//b0+CWNo2WG54jyUkoNrahS
	z8=; b=buOCn+ex9UbUbjbxKxNoyqFk7T1mTvms+/Sm2OK7HGMY4KSJ31t4qOJt8
	djSzJdU+Je9didfmVYWhLQmzT+u9/kbYwCCH8t4wipOKe0RXtzqYbMImprJQXlqb
	Q4e9XwvhsClwL3/hY0b7cL27SU/PckPZrX7yUN4/GwJZiC3kZunC31qkCbAX+P6X
	cPuenGzWJESPmMLaYQ3eSKTp56GWNRMBufBP+87JtCfGelygU4SZ4jBSIs48LCx9
	ZyqDFcBXa7O8RJAbwT0md7hv96wWqWeA2zBVBVnKLnPATJJOmplYG9UkB3P1eNr0
	9Y0XGr+rI/VDvnkaQVz87eYv5ZnEA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022084.outbound.protection.outlook.com [52.101.48.84])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gsswvtxe8-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BuUnvHgRpGiXUq6XoIaBUea45L8pL356Rpsw4+G5TLDb2A20H41mT8ZDEx+WauK2pm1CXA/gF1SqRygnvMxr3JUSQh8U8EQXHMQlIQiyHrPSHIpZdsWiwlr84amoFBCGiRbV1SCgPpMPtN+kai8/VBlOtmULEPeILjvXcmsCgHvsXiNZl8W2knX5BCR8nKskkByROv8E0VuMUwjCadgtIU72akeVCSJhqS3UB4f4XFkqgnoN1A4UHNroOC3VXe/me537dO2Y+56lbPNyvb2F01n3jv11LhpNxOT16Wz1kNjQNp/HpjrhZktnkVKLFAdKcQC3q+wWdkX5pGq0wI1jyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1cPfr67ixrfZp04B//b0+CWNo2WG54jyUkoNrahSz8=;
 b=ghwsrDmxiyCJGI9vC4yEm9P0DCseJR0YkyhjO0VOGp0tD5kVfdzdW/2QK2+CwEf6XyP5quSw3A6uhTwBbP6GhvB/4XVftVWXAC3necr+CJ6ZPa+rrDPbvGNS10RWp0i8zZEBGHlpp5yxrv1RgdfqctGLzpGnxE4CIjOYBr1M1lsksB2zTPuYJgL1YAByaeq49XpijoKXsiE1XglO9xBGpUBYz21mQ51pRuEHSnWeKqYI5hK4ZRc7UUcCRCGfTBbEiDiJN3wLm2Nhhz/01OHGLOqzM05WQnMPbgKSbaTPsDcthvF17GDEcD/ZxtFjUlHadWN9fAYqSvmw6t2MXWjILw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1cPfr67ixrfZp04B//b0+CWNo2WG54jyUkoNrahSz8=;
 b=m+knEgBrFbSMo9/s6VHvlquf46pRLxBW/B/nIzKL8wOjSywzsRYTgzweY0ZuyflXD/Ckn+k3MmDFXljoX+ZNTjKFN1hMnvxu8ySBr9+ooAGlv4A83xwte2nqAHoeGO+MbMs4Ywun2zpudLo+R5tChZYeFv+g42htpOZINANo+lTNR8Iv11LSNQ1Cbt70x9gnGqy91Wzol7lqfUHwYdujQu9dRxth0RM/suVjg5SonCqHXMcTUj98oIaCw4A1hBL1g3fL78mUhDKXjmRuCDQX4kdxw/l5gig+uA80oU3zF5+lxMnMEQ7xXA6kPzUpJM0W1GYQSEQyt+Bl/YhJKFluVQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:41 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:41 +0000
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
Subject: [RFC PATCH v4 23/25] qmp: add query-cpu-props-info command
Date: Mon, 21 Sep 2026 12:32:47 +0000
Message-ID: <20260921123249.1708067-24-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BY5PR02MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d1c4e86-e091-44e1-a898-08df17dc915d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tAkAwIuCcn2HFWFp85LylDW9NMP4Hc9vryuaL0/d+8KB8bOkuh2K9xpkqK8ghHHX9Dqm3NjaEnT6vN5QkxjlIJEQ/hys/gV2JmSP8R9eMgqGgRpklzsarhEo9Z65Q/C9EqtlKl+GlIyGreS1tY/b59CgWJbSLX4wGdXIyDfvJf90M+1pY0IndmqWOrz+vVU0nFJnCGWvmK7ReF2fEtz7l2vxIpDle5v1rZDfetNt6dUH+FV9J9pyz3IGihmJDajxUuHgCmlvjHMZlaQrENpy0CpYjUl485hpeTmlmV5M6xVRewq6mIK9bC0k1HYqq+vZaHQukEmD8Nou4iBMB4ZKDepf7pQwNaZL5WY/vVOundw23NyCvy2cjGDIL7IhEaCjLtlPJ8yQKB2r0BN1wPogHAhhiBcMbsZTfwRbyG8BETyvf86ONGReZw3JlUgccUGG2H9aapPCPCFupEbvQ/FzokW9VCOUR7d8a/Xj/aNkCLd4V/hJNnJ64GoxYt5pyhX9uPSJxSLqeuX4tsYaLS7g1H+9UKeRvZGtXo+Cg1l78KJ28L9V4wLXcYP9dkUcYEDt/+DD+KAgQDBeFghuDIpMy8RL8Q+fw0yclhonD83uENuJcJ3oK01Mtc/zx6SXvqjgTWxZMLnRxaeoIEMImrklXDCClrnFVD7tdUk6YZWpZYA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r8+8SXBZfhmggWok+O/Vix0gDKPW8ly/lnuCBFrMbdqdqHT11RDzSw1yi+3g?=
 =?us-ascii?Q?kGDYTaZn8d/liueucK7q9ddg0aTBn2fcAVUzNSsjXUFVeCuOY2PC4RXHbkPl?=
 =?us-ascii?Q?zd9pggq4jDQcbxsCKYvR0EkLmRHuxhoS4epWL7cEup64IlvkYIkOMHMSV8kJ?=
 =?us-ascii?Q?u5DnT2KS+Hmau1C7T/g8X+v8pa6bObmToL1aV1+t3o12fRBhT/qoxofNyHVW?=
 =?us-ascii?Q?YNVnSKYeeWJIKtOh63ARDAqQCUroX1PuB1RMBnfQ9B9b9kI+sj3SySmKd2su?=
 =?us-ascii?Q?bjY5SjlqZn8TwVKZ2oGD8vO913OBXvc1y+8q0VZuiUUhy3pfzDB1vteSwjdi?=
 =?us-ascii?Q?xB2cmGMZ31Sopf5X8uk+HJjjgQi3yoyAMi8kkFmSkvcG9Ddr/trwxvBDOuEj?=
 =?us-ascii?Q?6rVH0TCRsCtvHt5+FBz5TyUBnOHTnVBVFNG9mYwe7BEmSXEGGyaBnN/aIuec?=
 =?us-ascii?Q?LEXn++rVw0cWkIVGG33PJ9REFC+K0RowsZRuLLZnyrQAuTW4XJSAsrcUUrpt?=
 =?us-ascii?Q?xXBd4FOr+qdcBE2YRB/nZ0Eq3ZXkQrgk1m/PThD1P7blOcux1wlT9BvYe0nx?=
 =?us-ascii?Q?VoIdA3qrWomM13Gv7tVGhzS8NWBughNTuVG2orKx7fK3N/VrKijA19wyrdn1?=
 =?us-ascii?Q?GAfC6XNLH/QvxNccvbQTWlvG0dZPrkK5iTFfA+aRAaovRbAP+mceeuXkceJs?=
 =?us-ascii?Q?cBI9oKMk6AJ7dnPGtyCvO2I8fObpmwNEcQe2cRuz2coXrSS/xShYL4LcDIN+?=
 =?us-ascii?Q?RwuaexefFe3KhlmHRdXLa5HP0ih0jHnkc+VoZd9BWRfivcVUfsI2uSeh9yQJ?=
 =?us-ascii?Q?vtqm+zgwVWsVi+/aI8PUYebZSgcQIx/+Zg6RW53nPg6OaQlORDe8tlxl9bAz?=
 =?us-ascii?Q?l9PVXD0eSixyUX0DknM+Ep1n8vrWwJAW+AQe2hwT5/F970LvV4T8ybC9Lz18?=
 =?us-ascii?Q?zNQ1jZnt/JOdGFLlTp36RT91yV2WkKAUOw3rpKrn8KlnpM1zVXAnwk+j6aJp?=
 =?us-ascii?Q?bkYqel44eIuvgGb+wnvxHvEonxS6B3ZtzKZBLxlZLjHXsUY/Yqlf+TobzK4T?=
 =?us-ascii?Q?4/DsiLn8SBz37Z79enFMPbZ4eiqE1otKJwEv+ndFb3CJkBYxns97fzNFTLCM?=
 =?us-ascii?Q?vKsC5XkXWw2JO+bZX1KuMbrLHGFKxCrPdZclun+MpriWRZr0+rkrwMedUpo1?=
 =?us-ascii?Q?IslotXUD1iyQQdIpemqAfTpxzG9hFlMHUDWVQHTM2DGuA0OmgphxUoEzjqi6?=
 =?us-ascii?Q?H6PNu8glVuTxvJNaAvwIzWU+72ZanLIaCKO+JpdqwhwIjt3OwKOPtgLqDQZu?=
 =?us-ascii?Q?whsjcJ024PlBD+2DaPjzCd07ArOo8xomx/VTmuwAd86CcNRugNQE4tXrOq2v?=
 =?us-ascii?Q?Q9/lRfmdRxsTyhSPKAZorAcF9z3YaIfnUGRjCU/47lOIiZFbFvqdEnqPvw1W?=
 =?us-ascii?Q?5ym4a5pvuX7KhxXpS22U9zHSuZrOvqt4oR7n7237au6pRlWktJJ7JmkvmqwW?=
 =?us-ascii?Q?aIgG40iovobaH4XCFEQ+214IG/+ofU6177zvPx2oknSbbOncsh29xfbKGjiO?=
 =?us-ascii?Q?wEGUfaXEhZtPcuqZtB4y+NEH/zEV4SFeDnixvvj0YSFhFV//n0jfv2/dchcv?=
 =?us-ascii?Q?ifnJxWgSaoboO+eVxDcc04l85yHAese0IH2hyxKyfh+V9mHsuY2HKY+aV8dS?=
 =?us-ascii?Q?bmoIQq32DdQj4aGLRJwzmJG6aAJHIwVRn7NPAypnTTjBjGRpOByFZaJsHXuO?=
 =?us-ascii?Q?gOrs576+gToDWiYWhcp7OOP1SmEwbWc=3D?=
X-Exchange-RoutingPolicyChecked:
	DN0HyK+Zl3qMCTrcjsYRqRprZ0lZRLV7M+QLckswobkCNNHggMXxY4g7H+0eg+DfaBR+2Fyf4OWLOsmUuVH20n4NAnG16guNO1kp+AMXFuYC2xCZrPlcVxvcJVskxoi8ALmt4iZYm/mbr7F243p4p3ZPfnerOSPnzMvicggzERuxMr5Y/rPCUqOB93Ncm8QZ7Ag/rlJf549lT/zKSLrZ7WUpdZLm1+SfECq/6OXeHv8drDeuMYJAjGdTzy1qCWZhBVs8APaImNwUXm8OWv9yAVujKBXztmmJEOUQ7Et8E4mX3XNDjvj+4GcntpDOYEQsg+m98Kf0OC71w+DtDyuLBA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1c4e86-e091-44e1-a898-08df17dc915d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:40.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: meQ/eAXcIHPxWQz8HRbMwATJyGVDM7qLAJFMcu1U75aOvey/QZVlOfu6/k+lwWDztXdbF0M7yLtBQoq6r+9mb+7J1mv2i0OgPJplIxpWNYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-GUID: m9-HqkCgd9VNOBx-K6-8GRWuPffq_Da3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX14tfmKfSMi/q
 XYr0O1Wk+gFXL1zpPG6dc6iOIIdDYNVn1bqCwYMpXCIwHurPXjRZcNn7uBZqWiHjdDDpROgt4ci
 Y3G5I9YMDKz8W2/a5/vnrnDbhnm+Z3XKc2SUrlRio9QHCnsycnByaZ6IeRllrkBHhQiwg3okGZk
 4gWGVOsj6Fj+O3FmSpvLJJYmBg1Qh56QSHzASY5/AVE7eLWZyhWjCc0O9TbhjnS8TY1YsZ4/ny/
 XY8kNmsL6DV3lHY5Ovb3oKdkNx3Tg4Uxhqh7WO38pfzOyLE2csh34G4Og2PKaHCBJrL7cg0bStI
 OR3bdrgnHBA/dVeruY0CXSVmRDq+EcRvtJVwEEn1ZAJKzbSL1I/OseUq6ROLXD+I29ZWd9RuWWP
 AS42hq3wrhkOcmJV8BCxLEDSIC8lT4j2/amSUf9jf+7D8HEYNORNcXgphpOlBFaFBxYS+OxhETA
 2D2tYmc5MefXCrAQamQ==
X-Proofpoint-ORIG-GUID: m9-HqkCgd9VNOBx-K6-8GRWuPffq_Da3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX/N4qu3GkPtmU
 Vl2A43F85VWJb/zR/jJ+RVqDSte/GJyuGK2TynYFmgm0DiQ6sRWI/+tBGrOvdTliQYFuFqPx5nx
 agn01bKX6oktROBx45TSrZiC+ZDI5As=
X-Authority-Analysis: v=2.4 cv=J8g/fwnS c=1 sm=1 tr=0 ts=6ab12428 cx=c_pps
 a=fn/DPt3lPG6OhtMeQbTPHg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=ttUzrGzlu7rhztxTIxsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce the 'query-cpu-props-info' QMP command. For each CPU model
property, it reports the type (boolean or number) and the set of values
supported under the active accelerator and host.

This helps the management stack to discover which values are supported
for a given CPU property. This is especially important for non-boolean
properties, where knowing that the host has value 'x' does not
inherently reveal the full range of valid values supported on the host.
For example, an Arm host with CTR_EL0.L1Ip=3 (PIPT) also allows 2
(VIPT) but a host with CTR_EL0.L1Ip=2 does not allow CTR_EL0.L1Ip=3
for a guest.

For numerical properties, the supported values are expressed as a list
of inclusive {min, max} ranges. For boolean properties, they are
represented as a list of true/false values.

The command and its return types (CpuPropertyType, CpuPropertyInfo and
friends) are defined in qapi/machine.json rather than an Arm-specific
schema, since the concept applies to other targets (e.g. x86, RISC-V)
too. Targets that do not implement it return an error.
(The following commit implements the command for Arm KVM.)

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 qapi/machine.json          | 82 ++++++++++++++++++++++++++++++++++++++
 stubs/meson.build          |  1 +
 stubs/qmp-cpu-props-info.c | 12 ++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 4 files changed, 96 insertions(+)
 create mode 100644 stubs/qmp-cpu-props-info.c

diff --git a/qapi/machine.json b/qapi/machine.json
index 2d63c1bac3..6e65bdad86 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -2291,3 +2291,85 @@
 # Since: 1.2
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'] }
+
+##
+# @CpuPropertyType:
+#
+# The type of a CPU model property.
+#
+# @boolean: the property is of type boolean.
+#
+# @number: the property is of type unsigned integer.
+#
+# Since: 11.2
+##
+{ 'enum': 'CpuPropertyType',
+  'data': [ 'boolean', 'number' ] }
+
+##
+# @CpuPropertyValueRange:
+#
+# An inclusive range of numeric values supported for the property.
+#
+# @min: the lowest supported value.
+#
+# @max: the highest supported value.
+#
+# Since: 11.2
+##
+{ 'struct': 'CpuPropertyValueRange',
+  'data': { 'min': 'uint64', 'max': 'uint64' } }
+
+##
+# @CpuPropertyInfoBoolean:
+#
+# @supported-values: list of boolean values supported for the
+#     property.
+#
+# Since: 11.2
+##
+{ 'struct': 'CpuPropertyInfoBoolean',
+  'data': { 'supported-values': ['bool'] } }
+
+##
+# @CpuPropertyInfoNumber:
+#
+# @supported-values: list of numeric value ranges supported
+#     for the property.
+#
+# Since: 11.2
+##
+{ 'struct': 'CpuPropertyInfoNumber',
+  'data': { 'supported-values': ['CpuPropertyValueRange'] } }
+
+##
+# @CpuPropertyInfo:
+#
+# Information about a single CPU model property, including the values
+# the host/accelerator supports for it.
+#
+# @name: the name of the property.
+#
+# @type: the type of the property, which selects the layout of
+#     @supported-values.
+#
+# Since: 11.2
+##
+{ 'union': 'CpuPropertyInfo',
+  'base': { 'name': 'str',
+            'type': 'CpuPropertyType' },
+  'discriminator': 'type',
+  'data': { 'boolean': 'CpuPropertyInfoBoolean',
+            'number': 'CpuPropertyInfoNumber' } }
+
+##
+# @query-cpu-props-info:
+#
+# Return information about the CPU model properties.  For each
+# property it reports the values supported under the active
+# accelerator and host.
+#
+# Since: 11.2
+##
+{ 'command': 'query-cpu-props-info',
+  'returns': ['CpuPropertyInfo'] }
diff --git a/stubs/meson.build b/stubs/meson.build
index 3b2f2680b1..3bb4028bab 100644
--- a/stubs/meson.build
+++ b/stubs/meson.build
@@ -83,6 +83,7 @@ if have_system
   stub_ss.add(files('qmp-i386-sgx.c'))
   stub_ss.add(files('qmp-i386-xen.c'))
   stub_ss.add(files('qmp-cpu.c'))
+  stub_ss.add(files('qmp-cpu-props-info.c'))
   stub_ss.add(files('qmp-cpu-s390x.c'))
   stub_ss.add(files('qmp-cpu-s390x-kvm.c'))
   stub_ss.add(files('hmp-cmd-info_mem.c'))
diff --git a/stubs/qmp-cpu-props-info.c b/stubs/qmp-cpu-props-info.c
new file mode 100644
index 0000000000..36b0530b98
--- /dev/null
+++ b/stubs/qmp-cpu-props-info.c
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qapi/qapi-commands-machine.h"
+
+CpuPropertyInfoList *
+qmp_query_cpu_props_info(Error **errp)
+{
+    error_setg(errp, "query-cpu-props-info not supported on this target");
+    return NULL;
+}
diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
index 279a8f5614..2c25dbd8cb 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -100,6 +100,7 @@ static bool query_is_ignored(const char *cmd)
         "add-fd",
         /* Success depends on target arch: */
         "query-cpu-definitions",  /* arm, i386, ppc, s390x */
+        "query-cpu-props-info", /* arm + kvm */
         "query-gic-capabilities", /* arm */
         "query-s390x-cpu-polarization", /* s390x */
         /* Success depends on target-specific build configuration: */
-- 
2.52.0

