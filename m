Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D5255F2C
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994337; cv=fail; b=TtljVQGuSG2o9brMJP3RUptJ5oEwvufuCIeMeFoquC5TVgsBJz9zWCOk/mEVaZpZh6MBsdExXp9tJr2hONB+CdhCdjFdXxiOWlbFIxUy9gBTRe3j9n17F8n60lhr6h3UlyqBLE9jabrMtgksQRk0DjaZnY6OtA5Qkyna1yLLm50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994337; c=relaxed/simple;
	bh=VbxbBzUh3jblqUf4bmMY4JXoPKRU420Qc4Kl0Z5vDaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MGjzCE+aukIoNz4DswDOkRLgmoyZom0SMyjrAP0rRzLXhCXIzdNgxxM1+p6GCxbjHWBgOKzGHthQkedQEqZgaPxvBJHdpWCbocuEtVpXiH3Xa0K8aLuikT2C/0bY3TRmeC+DhEVQ7UwB9CVHmw49/W3P5dogcTaZBY83zuaL3S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=zY228hp/; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wTNrhC0J; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="zY228hp/";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wTNrhC0J"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHpL857563;
	Mon, 21 Sep 2026 05:33:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=lRDRn47KjhOmXOUad9TVQjXA3aB6TkzL7zGvZRc9R
	p4=; b=zY228hp/oRTR27GX2iglhmKRRka/Z/WzFg/VK8tzGnUT1i2Xv5IdvGHkQ
	lmALPQ410aqVZt6lW9WhdBrfOQGCLA+m9H6W71fstHeQtY0iFWnhcN4OJxWdMsnC
	KfABXhdqaO4d8tQmGlitJeULXE5iZ9RQDfm/s4OtR5RzBEKZGap6bD4UsCQZc96M
	xEKdI9TUaRsWHvGYxV4upDCUo4YkuSwiySL6Sm+3+killHg6VkZz4sBVHbRa3rxx
	AjRjk+Znj5mMsUKPuIgam812DzHNpBaIu7/P2hYl6Eo8xeQ8TH7K7FJ1TaAfOAcs
	OMVmsPRvwv8xl0bzXXp25l26xhVJg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021097.outbound.protection.outlook.com [40.107.208.97])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jp9-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URgVu/zGoBBFiYL47K6mPpIS2etyOeTOJ1gWJptq7AnRqVlTPSga+c4UjqcWKIpXu84xmQS95ve/uxsYwmReQoL39uLWW0ZPVaAQL1gSwtIdzvE2kCCyxSok0Yca1AUZ1pBIXErh5l9tSN8XaCCAPI/kCSavYMow8gniJFfb0eCoTuW36WRv9LzsDoLGiGEyNStzaF7chs7L+ZQn6mI864ExNHNybEB7GRrXos+yXUp0lnbM9GEumidIEilL2Ve0R7zBMptZuPUzY/zfVYtgYIklgPSkxswCTujxgMcivRhJD+0iz60WYy/vulI659JMPOlq1SNsU77ZdsrR3S3S1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRDRn47KjhOmXOUad9TVQjXA3aB6TkzL7zGvZRc9Rp4=;
 b=AOxSwQoZWaOLgGf8ISB3gWgFJv0WcBkqwuhbagr8xtBUfJCMFjd2oSNBPBz/f7HDgxrOvzhtUFsOijoZs6ZyKwftPtCX5qIh3a3Y3YWPkJuXxby/oXMJUiGj6msT0nv5L5JzBwgh3rQE+gYt54oBrtLV3Ja63gWdZ0eJJkryzOm7f21SHhg8z+gcmRmtN7dKzJfbJtibJ0HYYE34Il4e1rJ/F8xfLRIeXW8qKql1cikuTY1Mfz4AvPBER74/EigjL7yR+INw9Ijdtw7HHFDATVTSbbs14x0rLJykZS0rUr3C+JnbDHf6pwmzuK9ZIA3tTLDEp09iTjLHnyDPNs0LyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRDRn47KjhOmXOUad9TVQjXA3aB6TkzL7zGvZRc9Rp4=;
 b=wTNrhC0JIX3Xxh+JDWbWCbP41eIPRFB7TMfdwdoBcRRCPIbZIYoDrVSDVswR0DZiy8ppp8Ci4F5uzjVFbvrPdU6mPzH6odPcQGBcftgYrVByzWqPy1OG4Eef0VrfgSa+hr2UnOnM4+TL5UuYJRjLwyCHS3xF2q44TNHHQ4odeb21RUW1mv7vmM5B2tverCL9GoJaR2PBh22SpaECGIjyq9N4k9bf/3OOufpnllbznwM0sm1qEQE1z1TA28f4sRIe8zUBb8xeIxja4xu1QUE1A0GIVkydVxznOu+8bXdrhbuSRYaAF1ytSHLihQrd/Zgh43GdPHtQ94KWHySFkSyerg==
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
Subject: [RFC PATCH v4 25/25] target/arm/qmp: hook blockers in query-cpu-definitions
Date: Mon, 21 Sep 2026 12:32:49 +0000
Message-ID: <20260921123249.1708067-26-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5f2e76a9-66b1-4ab3-a576-08df17dc9246
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ehml6YIbc4COXEdzXQm3XKEumb9HVPXHmdER5vFtDNBR4gW0cecV78MHnS+Y/yhevcixExqnb1U3tOlHO095DxY0pQ1qQ/9eGfpIaCQBWvmBwZiHqREsHpmzQcaoHekV4E6zktK0wwzfIKKcJI/DU74EnR6vfqFuV5DNFwbIKgnBOW7JKoj2JkzHYnV4O3DXUMrfgWFZbBp62lFalPmWy29gzxH3Z3Dxm9S8jY0NA/yuqE7/dF2aFcbznPk13ZeBMTwfw4ly2TJHsJpkBUDQIj2lMjupmfZJhbGQm3NQb9HFRdqPMDJj43KcWMF8Sc6Kg8wlHnD6NEClCI6IAPeI7vBnyVfB40lF97pRrYdtIlmsQ1bg/9CL58yuC9NAjeHl63Fev47ygPTmBJS2Ey7L0ggsBElshDthn2XF+CtiLBJ33qrjIOJ+Vfq3MIRJfgrDRNLCJmvucGNiWi+7V0z+suTUadhWaHuB1OT/gx1d2RPAIJP5tmUXsB1R0u4TBwUGYkVrzDAZ6+KqgSWIjbWqEbfvW8iOPhSblZTNR0+QDc9R3P7kmuNkTd7eO62tavTa2kJqwuNJMb1q8+AKt9FYz1m8qBG/482F2J01H3mICtbiNQgOX6AI+fW2WyDKSrHt7hNojin3LGFr7ZCKbA/EcgWaNkgkBtsh+qT48+y/0T8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Smrbt4n3DeL0FUkVaBb3vGOeo2+NdPjh7gsea53uqDAxp6jCPp4Tqph1tC2q?=
 =?us-ascii?Q?DOwuWFzxZ0eX9AHr672pgCVylvf6OCryrKmU7YzIMSKo6SJkS1ycDUEMD6hB?=
 =?us-ascii?Q?ThG2y1W9cIyDsa8VVPtDEsaTnrIHC4FgE2Kp6kUKzbbejPtx0kcnrA/oqSqw?=
 =?us-ascii?Q?uy8XhgGKOiGYQa6hu+3TiIKGMiUswWbRdar/ppOHFK2J/AtXPfbIMFWfHa/G?=
 =?us-ascii?Q?hPLaGvcrI9RVfI288ipVGm5ejdS9pdXtgPt5Aup4hsJN+BljVierAUr9IJWI?=
 =?us-ascii?Q?3u1f5/WpNnEpP/snAfGETuu6z9je8JqCaUTocfoJ61fR7KRMOHvDhJeESti5?=
 =?us-ascii?Q?Zj1DbM53VvZLkb4sBCI15UGyuz11ALnlbaXxi0wGd+kC3mCKCnvjZOqD0v9j?=
 =?us-ascii?Q?kwdc6MX0N1LskZI2ZTMibhkH7UQSVAMhruoDWW68vmfcHMW4F826nupfJrr6?=
 =?us-ascii?Q?m1xbDsRz92siGk9we6/ZM2ev0C+a+/E9QQseUFb1GmmuftnwjN37pIqu8ikN?=
 =?us-ascii?Q?FVFx3zr9xCq1uu98xoNJzQcY8Yv0a0gql1cVbbvHE7ggvctbF/vPxu6duikj?=
 =?us-ascii?Q?WlS5FzoxAI9A1w4Y9zpYZ87IBU46Nb6fYK11vUBNJrOWMhZVW49fKAPW4Maq?=
 =?us-ascii?Q?VkVN9XlBMwW5PMd42uAMmZZ7QIJxRbFqoWnT4qkbZhNbKzxgWgmMQKQalCAg?=
 =?us-ascii?Q?fwlaXreyv2CSE3a8wyKvazErgO1MHINMXGOcD83FRanDb0VcI4sRWsbvf1NZ?=
 =?us-ascii?Q?HuSxupalEm3CC4GSBuP3kvgoxrPBwq4NvTn2jZ9cyN8VyeCQENDcWDNBaRAZ?=
 =?us-ascii?Q?LWORjlGcj8sdwgKm3o9hYc1s7Hm2BhUF/QSjg6vE2JqIbkYHWmztkyuOCaOl?=
 =?us-ascii?Q?ren5M6reJaOaXam4VSBhwX4wWa7LpIRvKuvyESh0nv42IHlTEYxunCwn6BKY?=
 =?us-ascii?Q?fzTUAiLTLRwp8P1qHDFzo+tjJRPAdHBqW2KXqoLKG/xjsczNzqjCFZm7e0fm?=
 =?us-ascii?Q?Dm1A/7Vxnk2r6uxzTcqcYAgHoODPiHzf4/bYJzUie9QQJxA58znhxaxotLcn?=
 =?us-ascii?Q?rk/8fkhxoAG5OOlmEDWyG8jjglMfSFgP2B3TBAZwcESFKcV4a13fU6606BvH?=
 =?us-ascii?Q?NENOqyTgzU9TpcqdxThytIDQBqBzRMxP3bmKGQ7K2rM8DHwBlI4YyOHLaIfu?=
 =?us-ascii?Q?tybdUAghhIcHElXwSgRo9IjzzpwIs8GydlbUbu+o5rwlkJc6Upkbm/uPs/0u?=
 =?us-ascii?Q?WbyRfv2rdkjf7kwz2WAewfftP+MXKCuVKMJUFJGgH7wz9xhyxzZ1tseYUgte?=
 =?us-ascii?Q?dUZdOJfFe1g91Fc2aL3kwbbQ+qqJiseDW/k3lqese9Y1Q27iLTf7nZoW+/kI?=
 =?us-ascii?Q?0CimY4ynPVfYRsiSAQ55VEv8hz8dHUjz4MqPxUscocOZ8MDM3DRgwnJNbfDP?=
 =?us-ascii?Q?tTveB+IVj2eiMGKzXR4NKBjMa7CFKob9E69LW+Y0vFA4hULJINhgIC+Md71n?=
 =?us-ascii?Q?bWy583WCUjxUn2dBi758Q7eH9qPFgUR02ijQDBh38nl05wEQSpKzbQEux7Es?=
 =?us-ascii?Q?DjY0N4cEZT9lX7cyPoKcTuDkgGYC7P2NFnTY2BmAy8GIhChFdEZJKz85AcgP?=
 =?us-ascii?Q?4M3qjfkpm/iyZfO8w85cOtaHt8oXQX3+o2Qsuh7KNDXzOD2k0OFzwZOB1zZ1?=
 =?us-ascii?Q?sbzrLXv7lS6+Xye0cEE4UYQLroHH1zEj9OtVrQg54B73XwyXx4PlM+BCo1qN?=
 =?us-ascii?Q?AI9uYA/ConyFH0DwU77ZKKydFILQ7/Q=3D?=
X-Exchange-RoutingPolicyChecked:
	xwm8xhBtabnuAlFx1l4m1ptXoFhkniA17+ImHXJgpEfoJFuodU60GKmCKrdfYACr22O6Yqg7GlU1YW4WRz5wcglVlSdZnMWa7OvfJgNrd8zw3Cy0tWnnXUbNhrsEZs+aMbb1hddojqbnBG7PRiJX6R9czoxnAQPGOxScfFHrkoxBe45P2iX25jLmV9KhIMdlVXBT7r/uUl7hNoPbOtnAe+ynEDxejVTBogkvYZ3w0ML/Oi9/7TUjrFvV8nbI7XQnuyEmjcYWO1W5lhXos+3DXH/HPSK+gWY99BqkTWTMEPIWfDiLz3s0Q1n2PAhNVWts01MS99X4YofJR+DKDwuHNw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2e76a9-66b1-4ab3-a576-08df17dc9246
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:42.5481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyljEmNdO7cFMdb5xiU2cQKCxJpK0HvmY/rJJTHdiUEYQ+O7Fklf4s6EhM2zYhJaEYzl6BqWqZMDhxM8kwHmgyvseP2HZGvze3KOEA6i50o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR02MB11945
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab12428 cx=c_pps
 a=HfG1oWozJQbQxD3IkfRzFg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=7l7nGPkXPwBlwO1dnCAA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXyG5m1ugi+kIO
 CyI3HHIm6cCzxrn1/0BQLAM4aGWd01s//sYJwMlWpPeAAr+d0nHtsF5MTQl3Lxq7+v+3i3vzlaM
 qDV3ANsXFcWOSctgNhgMQtY7VhuZX3U=
X-Proofpoint-GUID: 9MISnTVUJCxp8e6jxTCUZ_FZDiazxY2F
X-Proofpoint-ORIG-GUID: 9MISnTVUJCxp8e6jxTCUZ_FZDiazxY2F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXxIgE/GnCWV8n
 xr+/Ax3Lj+gpQQXt8PuApmpV3gZi8NgJVjXI71Rf8autlnWHUby3F1M+kgFcbS6Wc12UEoumxeJ
 tINgR1t/i4kwsu75GVmteu1G6fijQ3QhCMoWuFdpROt80+SeGwCAnWcKCpEM8zaZE1PaKIU0zUK
 snxZEDwiqGA1aYwlcZXE6U3t1kSAXXeKB8C+8rfi8YKXmy3jQpxpX/ugizVdMH5GHK4eK9fy+Re
 inVhVycYW+V/yfZjGjp0eTolMVAtZqbAi6bakogEQTwDS4li9ar5TOIDXwYE1CAuBwye8/FDaO7
 3qxAa+dbkXeSVK4EDzpp7W+vbv3fhtj8LTsgAuqxRqY23puiPaMY7Xf/HUs4l6FWO8PI9VaAIRp
 o3ggoGCIwsiLS4rAvPdy1oCfeeQjJirnO95XWmGWfYhjSiSfVcx2SNO7BS5O2gQwmdtLdWgnqY5
 Nt49GW6U/vH1X95KW1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Report blockers for named CPU models in query-cpu-definitions.

Efficiently do this by validating the realized ID register values
against the host values. sveNNNN properties need special handling
because they are not stored in ID registers.

This way, we need not instantiate each model to check if it can be
realized on the host, and we also get granular information about the ID
register fields blocking realization.

Introduce arm_cpu_class_check_missing_features() and
kvm_arm_idregs_get_blockers() to achieve this.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-qmp-cmds.c    | 12 +++++++++
 target/arm/cpu-models-stub.c |  5 ++++
 target/arm/cpu-models.c      | 35 +++++++++++++++++++++++++
 target/arm/cpu-models.h      |  2 ++
 target/arm/kvm.c             | 50 ++++++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h         | 13 ++++++++++
 6 files changed, 117 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index ba488d5c01..d837ec6653 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -379,6 +379,18 @@ static void arm_cpu_add_definition(gpointer data, gpointer user_data)
     info->name = cpu_model_from_type(typename);
     info->q_typename = g_strdup(typename);
 
+    /* calculate blockers */
+    if (kvm_enabled()
+            && !g_str_equal(info->name, "host")
+            && !g_str_equal(info->name, "max")
+            && arm_find_model(info->name) != NULL) {
+        arm_cpu_class_check_missing_features(ARM_CPU_CLASS(oc),
+                                    &info->unavailable_features);
+        if (info->unavailable_features) {
+            info->has_unavailable_features = true;
+        }
+    }
+
     QAPI_LIST_PREPEND(*cpu_list, info);
 }
 
diff --git a/target/arm/cpu-models-stub.c b/target/arm/cpu-models-stub.c
index 48f712d648..2d1be49e0a 100644
--- a/target/arm/cpu-models-stub.c
+++ b/target/arm/cpu-models-stub.c
@@ -11,3 +11,8 @@ const ArmNamedCpuModel *arm_find_model(const char *name)
 {
     return NULL;
 }
+
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
+{
+    return;
+}
diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index 855eb5ee6b..9591b6dbfc 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -477,6 +477,41 @@ static void arm_named_cpu_initfn(Object *obj)
     arm_named_cpu_zero_unknown_feature_ids(cpu, &error_abort);
 }
 
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
+{
+    Error *err = NULL;
+    Object *obj = object_new_with_class(OBJECT_CLASS(acc));
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    if (!kvm_enabled() || !arm_find_model(acc->info->name)) {
+        goto out;
+    }
+
+    if (cpu_isar_feature(aa64_sve, cpu)) {
+        aarch64_cpu_sve_finalize(cpu, &err);
+        if (err) {
+            error_free(err);
+            err = NULL;
+            uint32_t host_vq_map = cpu->sve_vq.supported;
+            uint32_t model_vq_map = cpu->sve_vq.map;
+
+            if ((model_vq_map & host_vq_map) != model_vq_map) {
+                for (int vq = 1; vq <= ARM_MAX_VQ; vq++) {
+                    uint32_t vq_bit = (1 << (vq - 1));
+                    if ((model_vq_map & vq_bit) && !(host_vq_map & vq_bit)) {
+                        QAPI_LIST_PREPEND(*blockers,
+                            g_strdup_printf("sve%d", vq * 128));
+                    }
+                }
+            }
+        }
+    }
+
+    kvm_arm_idregs_get_blockers(cpu, kvm_arm_get_host_isar(), blockers);
+out:
+    object_unref(obj);
+}
+
 void arm_register_named_cpu_models(void)
 {
     static ARMCPUInfo *arm_named_cpu_infos;
diff --git a/target/arm/cpu-models.h b/target/arm/cpu-models.h
index 144778744e..41bb15d928 100644
--- a/target/arm/cpu-models.h
+++ b/target/arm/cpu-models.h
@@ -4,6 +4,7 @@
 
 #include "qapi/error.h"
 #include "qom/object.h"
+#include "cpu.h"
 
 typedef enum ArmModelPropType {
     ARM_MODEL_PROP_BOOL,
@@ -32,5 +33,6 @@ void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
                            Error **errp);
 void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
                              Error **errp);
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers);
 
 #endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index bb74f8c274..ca3da80262 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1485,6 +1485,56 @@ arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
     return field_matches(field, ID_DFR0_EL1_IDX, "PerfMon");
 }
 
+void kvm_arm_idregs_get_blockers(ARMCPU *cpu,
+                                 const ARMISARegisters *host_isar,
+                                 strList **blockers)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *reg = &arm64_id_regs[i];
+
+        if (!reg->name) {
+            continue;
+        }
+
+        for (uint32_t j = 0; j < reg->fields_count; j++) {
+            const ARM64SysRegField *field = &reg->fields[j];
+            ArmFieldValueSet *vs = NULL;
+            bool supported = false;
+            uint64_t model_val;
+
+            /* Not a blocker if the field is never written back to KVM. */
+            if (arm_field_skip_writeback_always(field) ||
+                (!arm_field_is_writable(field) &&
+                 arm_field_skip_writeback_if_not_writable(field))) {
+                continue;
+            }
+
+            model_val = extract64(cpu->isar.idregs[field->index],
+                                  field->shift, field->length);
+
+            /*
+             * If the field is written back, make sure a "supported" value
+             * is requested.
+             */
+            kvm_arm_field_get_supported_values(field, host_isar, &vs);
+            for (size_t k = 0; k < vs->n_ranges; k++) {
+                if (model_val >= vs->ranges[k].min &&
+                    model_val <= vs->ranges[k].max) {
+                    supported = true;
+                    break;
+                }
+            }
+            g_free(vs->ranges);
+            g_free(vs);
+
+            if (!supported) {
+                QAPI_LIST_PREPEND(*blockers,
+                    g_strdup_printf("SYSREG_%s_%s", reg->name, field->name));
+            }
+        }
+    }
+}
+
 /*
  * Copy writable ID reg fields from isar.idregs[] into the KVM cpreg list,
  * so the subsequent write_list_to_kvmstate() pushes them to KVM.
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index ab01ce8665..59832d8063 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -205,6 +205,19 @@ void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
                                         const ARMISARegisters *host_isar,
                                         ArmFieldValueSet **value_set);
 
+/**
+ * kvm_arm_idregs_get_blockers:
+ * @cpu: ARMCPU
+ * @host_isar: The host ISAR registers
+ * @blockers: The list of blockers
+ *
+ * Get the list of "blockers" in @cpu's idregs state for the given
+ * @host_isar.
+ */
+void kvm_arm_idregs_get_blockers(ARMCPU *cpu,
+                                 const ARMISARegisters *host_isar,
+                                 strList **blockers);
+
 /**
  * kvm_arm_steal_time_finalize:
  * @cpu: ARMCPU for which to finalize kvm-steal-time
-- 
2.52.0

