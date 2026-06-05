Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2FE4B8DFB
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650468; cv=fail; b=sZwd85PVtqA+ceOze79kxjuav/7A0pzrcdVU8Z4lR3ov6gW+wDLloen3z4EhKrE0SOPOsUlhAAyHDoth8Ph4dgzkaMj1AEIxajbkaHT3QG5h9y9/iEFP1H1JM6vCH6v3xImQIkj3eBTNKCCNRd0TT5+oLq7xV2Dnt3gG9yIDpj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650468; c=relaxed/simple;
	bh=z77CGm4hpp2g3GcRe2t9V/S2tnhUM2ikfhDRVfFxTA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fLE9yO/004A6CZ0KmnsTStuATFuPf1L5cInje8gtuHEhVeL3Qzx2Ic/ESlYAuAJqVAEaN7oBJkwpQgkW4NDHh88HYxSID88eoxqV2D/gI+ocJioQHQp4avhbDKBXI/ygjk3Qvhc1rBcB1jj5LdA8gsX7N2KYbz/6923F06GergM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=21sONRrn; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=s0uUhpZH; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="21sONRrn";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="s0uUhpZH"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556Ocu0889016;
	Fri, 5 Jun 2026 01:43:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=VahbJXWZ8CXjXBIPZl6mk9rlOme758HEDHSR+8Xgm
	1g=; b=21sONRrnZXo8Mbz/Kb595tF46Fw7OcXXDG0DkFL5tHyw2QGKgfJDCBPqG
	d3C2U+FAmTBeeUIonNH6xztTlwDNKX939CHcNdKj1RAf79X0aPvVXpUD474gvaqp
	3WPQhcu28xOiU3hB8zAQPo0SFxXejCbWdAy0lbVnOItxxzBoIOwep6Z5pEZ+hzmF
	YjsUXh55VmhR7iCZ06Dg0qpsYl4sA0tJxIhxIu5IgPOn5XEqoX+4rHlHlGjai4bW
	l5aybVF1ekcK/4J+IeOuozBRbZcUnU4uOHbT5/G6mvt9585nDcu68XDYmXRhdyax
	gVPTIdoOHHLbyt3vAaWC8KCG1lSzw==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021117.outbound.protection.outlook.com [40.107.208.117])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ej5a2fxwg-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0UYRYPCFpV36bU1sj1Hiogr5dH8ETCT0Opc98c5pjbnmxAHIesDBOqQtIHu+0Gl8NkOxz5ClyWIRhu/qskTyGxRsvjkhHN+h1cqf7MRJ/v2zMLSjqqHd1mXOZkQHak1uaOy9+TDnjQ0Nnp/Oblc5Q+OuZGxKxlNyhufH1aTb0Oj+jjIjq6lDrbpj5KVNXaNGsiOFbfFEe7oJyScfK2IsCqeU1gHgVdJh6a01N3J4miEcqfJ3rZh7RWGaQIHz399PkudZYSm/cSobt+BzTtEK6FYUrUU9CIL+vnU09Ros769oGfRfRPUI7BnmFIUIr41HWaGLkx0EB0BesNZjH1TnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VahbJXWZ8CXjXBIPZl6mk9rlOme758HEDHSR+8Xgm1g=;
 b=s+qze8J52S/NQ3uQHRAwJ0X5exhPmhsdaX9vegDgtwzGiEUnDqW50Qg/AETBbLiQV4VDY6sogavb2oLoMMaxEmIpTpBNLTlNewpYxGVUMCg4i1ctQVOe7UcYF0DyotPebDaSytK7tRxz3/SjVR1a03wmb76j1fa5smwese2SDd8/MrtBcdljNw+0Ytvg5/QxFxvdNP4/tHScm1+eWxSnMB4nO/QM1Q06kRAoh86xw8gVX9Z81w5cQbrxat2PSaZlBrlJ8f97YsTDYMm2OYpvjo5AEH6djnN2P7jVm+f+QGYL4hgf6eI4Z/l9l9L+EUG56N1I/0j/qu7l+KXsuEUtFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VahbJXWZ8CXjXBIPZl6mk9rlOme758HEDHSR+8Xgm1g=;
 b=s0uUhpZH4Osha4jQifQQIsmA206bpB00VkcIZeAaxJIqK0a6Jq8yQZtoUTzpMmwDlKlPx69BnGQfp15uzihvEpjlSwr7fT6CyXSMzZnSM2YnYx3FbdLfPqQ+XdRDI0Stb0q0m7Dq0J593B9e6gohTMD9x0mAtV18Snq19DCXTcL93mSfjtao0OpnBdYWn+kB9oaU4TSWugXUM1RvSkQZHD8DaOgk5plzmVsHdKqIgDa/vhz0vXDY2kNsdZ0vibMQqg+65lhau5sxcfbW4yAQPPGh+loJ0fPxe+qQ8NaNoADIRz0xbmVoKh/hc2ALkTKKat+bvcn7qbGH14AR8UFYRg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:14 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:14 +0000
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
Subject: [RFC PATCH v2 14/29] target/arm: Validate cpu->isar.idregs[] before writeback
Date: Fri,  5 Jun 2026 08:33:43 +0000
Message-ID: <20260605083358.1320563-15-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 58968b10-12dd-4ee5-a713-08dec2de7b39
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799007|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lS/RfY0CIngegiy3f2ySdJB+RYGwyZud3laA0puyNuxoXCpRafQ39zfmjQuwvYGDg6uoqqIryTUdxyZrIBtPPnqqJ2tqJ5n3yoetjVsMtSz+DjeYyEVDLf1oThFfvqmL7H/nk/B+ZnU8zGydeWn5phV3NBP/Ko18DRWwEpB/H3XTSr0hWcj/bCgC0VKDRXIpFepcgYcv1GeJO7W5HCo4c0A8V2PhbFvBL80SF58Bx9dn0KH8fU/582+fvVyU/cwwD/W/nGbv8PbvI7hCTeBVyU7QjLO8KW/sOrdKKrdjith+GENaqDGNN+dgUXr9n6cfm/+BWV7BZsZO3x1u8TCYC7SCfpWbCb2VModCDIYXqG1jHOKGCBy1IUEwc/pJx+zyb89abpUwCuKX86MRNlcrFIRRmL5LFmbChcIZHPjQuzoXvx6FPnL4DTrzUwguZ9SXMrXRL5fMZDnK1gWJifzGDDC+0TgWE8ftUFKXWybp8v5ZXEEEKc2jo4FgTcEkmngCaVl+hSG8TFfDJMTnk+IsyEWh3tZBKCQ+vzw5vCoyEQiPfgCie+LIrrWsRloyt3kfCQ+8aOenDqjTCdufNjiy7wgw48ZTf0o1N4yT8uiVDoj+POR8Cp/EdLQmY+6g78UoSaf0MTkLd3oA8Va92WvtviAOUbAwN3hNkNHveIvqe2kO+On1OK+2f7b3YgBtqDLv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ionL5eugrSNTMMQxkCU+Wzd0F8RMdH/ok2WyVIj4IjD5dES2z9vK45zkqmpF?=
 =?us-ascii?Q?VkIqhXcbXXlI3Uk5AHnQSImKiO3/8GCc2Ux4xw8uaWTXOtoSTOx1gFkdazlX?=
 =?us-ascii?Q?m+CV2JsAWcZ3YsFhqYoNVRm7rIqI+/EzWmkH+wV5zoLsVXmv6vs8MjBi5qnY?=
 =?us-ascii?Q?kpuoqhXiM9fxuwldyforq2L+ooMInX3oK6yZPl5+d72tgYRpgpw8ePJy8A3z?=
 =?us-ascii?Q?1Fm+RUpkcCOT9H7WWKzohC5DRJnLSWSm4gDE+JihLNH3XG95T/6/D9slGwbc?=
 =?us-ascii?Q?FO5DV13c4ls+QGsu00LXUusuKFogrZ+XlK4vFykQttv3RrJn8scDGoeJdYVV?=
 =?us-ascii?Q?1Fzqf4L6iRxmJvtssNtiNg4xImHSg4dNlVEcQ5vycU3mj2xcbUvz8Oa69Cdz?=
 =?us-ascii?Q?hDhP4wsWqI58YHTr3KHQ8vNawGDinJ6FwHfC2t9qvgHZCyUubz2KYXokWojM?=
 =?us-ascii?Q?G+8EtrC1HLeZEyEjHe53MsZLsPF5QC0tFM5u8fD0etstzBok8CxQNenR9umw?=
 =?us-ascii?Q?ni77WeQzhRtrenIuYNiDf9++p/zyVf9cTQjVx8N84cz/mqhXJHt6g7DJ0ljk?=
 =?us-ascii?Q?xRyS6PEAFlAURClYjEz5GTd1gaVeU0nJJFBW33o7byEPmhL0mOjR2YUG5FHI?=
 =?us-ascii?Q?P+ILNJbsVBGUfglCmBo/QUicIF6ZxAaQj80rrdXywt/RQj96R2FXKVg3poQb?=
 =?us-ascii?Q?JwhMVI9IHyP43KEpZhO9gIW7bwCqvPNuvBBcUmOUmoex+JG5s6zw2Pq+/Mzz?=
 =?us-ascii?Q?N5KJanuBKUT+MbTXqaB+gfRe+s/40eZnFl8vGI08wz9y4RYPJ0Mp0LOpS0o9?=
 =?us-ascii?Q?OHHJvbxm0PfDCQ8F3UwR7RQ6xRI1VXREVkbmIvyZdO+iWYhigVTj6wVjPwvv?=
 =?us-ascii?Q?nDb08NctjHngV/l62CZx16M259JaFMW6HDMT1wUl9B79n1x6h+YKWwNtpAXR?=
 =?us-ascii?Q?JnO+M/ynTT1KbHO7DzH8/FXF7518DYYfMv28vbsMchg3NNvzJpmIresuRcWe?=
 =?us-ascii?Q?ji2AA1o+fw4n6IFCY/zLGdZpDqxUywqdaEFghpg9iw+lFz+vD7ERKd1+gcrG?=
 =?us-ascii?Q?BD+Nb7rVEYcXeIiI3hU5G8cnGJcu1rBtbuIhvYA4hAy7Uq7B5SBKftvl7MzK?=
 =?us-ascii?Q?CF1HBSMawindDGL9HX6doYNC8Z7yIFixPlIGssqnw1869vL20ORQenidmWip?=
 =?us-ascii?Q?6T0U6nXyFNZCB894kOtd1GM8yjCI/AZMlNKW5zpgIh+D24Q+upSTNgPT3M3A?=
 =?us-ascii?Q?8LBvi/k9Y8tCCbKAi7xu/C+Q69P3djGMtm3UdrDfdiLKK0hTFuG9oGKbf/4v?=
 =?us-ascii?Q?K23VS+gb6DB8pjIKVHcII/jycAP1EcQcvFM6/3T0cY+eku4RtoyI8oYnRkgS?=
 =?us-ascii?Q?CrUJhwV+QBW1ODGA93lpSkilRPDf41qPY4h9anqB/orycUPWnpvNabRgyv7P?=
 =?us-ascii?Q?mWjFVGvtfR4UtEK6GUsWDeXgEkgxffixx+FRnwnxG1SgiIEw0xpbFCrzArJs?=
 =?us-ascii?Q?totx8szEpwVyxysgL2h9zkhVXSfoiblNtVXZve9pZnEAe8o9ygl3yEsdluhP?=
 =?us-ascii?Q?lJg8chHT7F/llhwQNB0KSfMZB0AQ6QbMFoX2IzFD48VuRp1Sir0zmOy0YPWn?=
 =?us-ascii?Q?FpilG/e/0pU5GHiI4zZHPHK3/VnTL1hVfzraMxIbxYU4FhzNlIkP2bbzHEoP?=
 =?us-ascii?Q?HWXXWkZ3hAKrc47X/XCOizXz19iWU9pk5ybkvMJAQ7/sVVjp3XWX1ICubiTX?=
 =?us-ascii?Q?EPXrmDdxmtkbVVS/Hn3zfp5B3z9z9ks=3D?=
X-Exchange-RoutingPolicyChecked:
	Iyh/q/wF8fO3PCItbtqbtE41DAqFhB3nLGgg2OEZUha4B3Lmo3vtuIkebZCm+qiyvkuKvOqkzGb/KGhOxCeczJYfqVlQiyumIpF+JQ4t1Wi/oJqRE47CiLukc2VZygHel9Ghf/ufy3DR/tx5+2HmDto56CC1w8o28DpbsqxIrJp0kwLw+agPfZRmtgesvyZ3zue3j5LJk/gWjrvs9/EbphVPPqVsT9YU0EtzNXRrSsE5iVpiu6J3RRe6gGErAJlAsD6E6NHzGsbaRl6QvQMBzAw0JKefOGtN1LIBvbRbf19yz0YUcw4+Cv2jIFDo7PP7aK/j0DKlcoV8jUK/EVah6w==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58968b10-12dd-4ee5-a713-08dec2de7b39
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:14.1118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDwt39Mf7mKrhOju/Z0AXW1Igo6PCLeyLE2xe8iFIHjynZ2OUr9CnP7k/j6SrkkNDh5C7b70DiREFTs0fGRmVdu1nTgb0kMC54dYJJMx0aw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Authority-Analysis: v=2.4 cv=Mq5iLWae c=1 sm=1 tr=0 ts=6a228c26 cx=c_pps
 a=fJIB0T+C2yAfE4P2TQxPqg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=nl4PRgY3Bpby1YJ86_MA:9
X-Proofpoint-ORIG-GUID: fNrw5skSjmCxnj_hAk9FcbQT8Kkr0pP_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MiBTYWx0ZWRfX8ZZJyD7trAeW
 jWGrrz09Ylgrvu0M8GWoshRoYDQGWV1W++pjxkHrFKuYPN5D9DEPPB9Zt7L6Iniw0vJ8lS3WQNn
 V4DA5p+E121i/9CoFWIb+bUIL2rga3x0gxJLzi5z/apyw+UfwtTlB968P9KtVVGoCyyJ8F1df/1
 Dh0+dYmlpPrdMpZRO0sXXSFCCKhF6kbGodF4p+ahrT5WOGqwuPeD0GxM0J4jCI9MIhAd5PnKSPU
 j4RVrxt1SCIKj/CgnTIqnURuIF8rSFCbO3GhvoiLfsSk5Hz8AMGUkC4vc7Ow4bTaM/MAUiF6IxG
 yffzTXKDYD4WcSPiLsowGYhG6upqi+Z43BdKjO7aWJ0+hOysgnDi9rnlsAXUdQJQs1D5mKcs1v8
 M54DyCCZglHPwBxEFbj5HGJ9IUXhY9TmmdYhkQjUgUv/NgnDT/gKuisPeYfFf8ChGTrDZSnvAMu
 6vB3lQUkJckU6HkLpvg==
X-Proofpoint-GUID: fNrw5skSjmCxnj_hAk9FcbQT8Kkr0pP_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Before writing cpu->isar.idregs[] back to KVM, validate that every field
satisfies its declared safe-rule against the host isar->idregs[] view.
This catches values that would be unsafe to expose on the current host
(e.g. claiming a higher feature level than the host actually supports).

Introduce arm_idregs_validate_safe_rule(), which iterates over every
field defined in cpu-idregs.h.inc and checks the model value against
the host value accoiding to the field's ArmIdRegSafeRule. If the
requested value is invalid, error out, while also mentioning the
related property.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-props.c | 14 +++++++++
 target/arm/arm-cpu-props.h |  1 +
 target/arm/cpu-idregs.c    | 64 ++++++++++++++++++++++++++++++++++++++
 target/arm/cpu-idregs.h    | 10 ++++++
 target/arm/kvm.c           |  7 +++++
 5 files changed, 96 insertions(+)

diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index d5900c0e23..3a02079ff2 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -486,3 +486,17 @@ const ArmCpuPropDesc *get_arm_cpu_props(void)
 {
     return arm_cpu_props;
 }
+
+const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field)
+{
+    for (const ArmCpuPropDesc *p = arm_cpu_props; p->name; p++) {
+        if (p->type != ARM_PROP_FRACTIONAL && p->u.field == field) {
+            return p;
+        } else if (p->type == ARM_PROP_FRACTIONAL &&
+                   (p->u.frac.base_field == field
+                    || p->u.frac.frac_field == field)) {
+            return p;
+        }
+    }
+    return NULL;
+}
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index 9ba3f4c100..36ca39d1a7 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -45,5 +45,6 @@ typedef struct ArmCpuPropDesc {
 void arm_add_cpu_props(Object *obj);
 
 const ArmCpuPropDesc *get_arm_cpu_props(void);
+const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field);
 
 #endif
diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 591ca54e39..84e1d8d9f1 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -12,6 +12,7 @@
 #include "cpu-sysregs.h"
 #include "qemu/error-report.h"
 #include "qapi/error.h"
+#include "arm-cpu-props.h"
 
 /*
  * Generate an array of architecturely defined values for each field
@@ -243,3 +244,66 @@ void arm_idregs_reset_to_defaults(ARMCPU *cpu)
         }
     }
 }
+
+bool arm_field_check_val_safe(ArmFieldIdx field, uint64_t val,
+                              const ARMISARegisters *host_isar)
+{
+    const ArmIdRegField *f = arm_get_field_desc(field);
+    uint64_t host_val;
+
+    arm_idreg_field_read(host_isar, f->idx, &host_val);
+    switch (f->safe_rule) {
+    case IDREG_SAFE_LOWER:
+        return val <= host_val;
+    case IDREG_SAFE_HIGHER:
+        return val >= host_val;
+    case IDREG_SAFE_HIGHER_OR_ZERO:
+        return val >= host_val || val == 0;
+    case IDREG_SAFE_SIGNED_LOWER:
+        return sextract64(val, 0, f->length) <=
+                sextract64(host_val, 0, f->length);
+    case IDREG_SAFE_EXACT:
+        return val == host_val || val == f->default_val;
+    case IDREG_SAFE_ANY:
+        return true;
+    default:
+        return false;
+    }
+    return false;
+}
+
+bool arm_idregs_validate_safe_rule(ARMCPU *cpu,
+                                   const ARMISARegisters *host_isar,
+                                   Error **errp)
+{
+    const ArmIdRegField *err_field = NULL;
+
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        const ArmIdReg *reg = &arm_idregs[i];
+        if (!reg->name) {
+            continue;
+        }
+
+        for (uint32_t j = 0; j < reg->fields_count; j++) {
+            uint64_t val;
+            const ArmIdRegField *f = &reg->fields[j];
+            arm_idreg_field_read(&cpu->isar, f->idx, &val);
+            if (!arm_field_check_val_safe(f->idx, val, host_isar)) {
+                err_field = f;
+                error_setg(errp, "value %" PRIu64 " is not safe for field"
+                           " %s.%s", val, reg->name, f->name);
+                goto ret;
+            }
+        }
+    }
+ret:
+    if (err_field) {
+        const ArmCpuPropDesc *prop = arm_prop_for_field(err_field->idx);
+        if (prop) {
+            error_prepend(errp, "Property %s: ", prop->name);
+        }
+        return false;
+    }
+
+    return true;
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 1389005099..c2ee82597e 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -86,4 +86,14 @@ bool arm_arch_val_from_name(ArmFieldIdx field, const char *name,
 bool arm_field_is_idreg_any(ArmFieldIdx field);
 void arm_idreg_field_reset_to_default(ARMCPU *cpu, ArmFieldIdx field);
 void arm_idregs_reset_to_defaults(ARMCPU *cpu);
+
+/*
+ * Validate the ID registers values against safe values tags with host vals
+ */
+bool arm_idregs_validate_safe_rule(ARMCPU *cpu,
+    const ARMISARegisters *host_isar,
+    Error **errp);
+bool arm_field_check_val_safe(ArmFieldIdx field, uint64_t val,
+    const ARMISARegisters *host_isar);
+
 #endif /* CPU_IDREGS_H */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 288b5ebe85..46d5532061 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2118,6 +2118,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
     uint64_t psciver;
+    Error *err = NULL;
 
     if (cpu->kvm_target == QEMU_KVM_ARM_TARGET_NONE) {
         error_report("KVM is not supported for this guest CPU type");
@@ -2212,6 +2213,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
         return ret;
     }
 
+    /* validate the cpu->isar.idregs[] against the host's isar.idregs[]*/
+    if (!arm_idregs_validate_safe_rule(cpu, &arm_host_cpu_features.isar, &err)) {
+        error_report_err(err);
+        return -EINVAL;
+    }
+
     /* Apply named-model ID register overrides on top of KVM's defaults. */
     kvm_arm_writeback_idregs(cpu);
     write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
-- 
2.52.0

