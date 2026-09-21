Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9F7485931
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994039; cv=fail; b=bj5kXDDJjI5G60cHX4HMOPZDg92B8R4GKUmnoWCnNyoy8WiqtuWyxpyaQKHgzOQ/+dBRLXpaHk5wAyP+wKmAcEHt4YmHPKM6BqV6hT1tg4o8aejWz8BgMU2QD6BO8hX7WzTCPykkQSxM395YOGbko5NN7Q13iHXo8CqnS3hLO74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994039; c=relaxed/simple;
	bh=i3Nn9UW7nORvfda0pTuUDhmsEmC4oOZivSgJEPUf9kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KEhc8HWRr7Q8EEE8Gxoy79bkN/CethZCEmj2ueA9Rvyev+rT+LdQAsaCsT1aqSe9J8RWZxsRZJmGnK/3heSXVy2KcqR7WmwmbBUdgVUoWo6GXR9hGWDMQPcmOGViUZS65H4TjvRxwmV4gaaxXDzv+3PMkRK35WIOQdma9wkLLCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YGmku1JS; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rfUY/ZMC; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YGmku1JS";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rfUY/ZMC"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAiHkg520340;
	Mon, 21 Sep 2026 05:33:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=tEC5hr3tAKTD+jXZBwrtYWtBStRzevILe/PpLZJ6P
	3U=; b=YGmku1JSKiUQvjP/FYfS3loVcoVALZRM4DTe/EovAGfKP55GyiQFR5hjE
	QT22xxSHne26MMxuYTQXK99iQ0LWSHA+DmKf0PGynDHeAbowCNUlUgkRrhGE0Mf2
	beIPLkdFaJEOU33ZBzfkGbuDrCM72RtQTye7CDfvbLUr8sW4jc5TagldnQAAbxU7
	xaguu9VU+1aDc+1GfzIjRFKtVfBf/KR4wcFMBtRuCyrhJt3ni+LFW/CSa8+sbUbn
	XfBk3VOeiVb6vjrCWc7lswUcR8ezbQjGBqnkovhZ3kIXsxAiyJwVAkuHZ7tx128s
	emwa+rOtxTYNwpSoUQEmhAQZ2Gegg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022131.outbound.protection.outlook.com [52.101.43.131])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspqsbhps-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZXwAZeMBwgdK9JPDGp2cPRRjxV7dAgHq8jnoiZjdmGi9COtBR4IaMXtilVR8mhYcy0yXUb6AzZBz1vPUlW9f2U5EEUPn1Ah0uCA3m5+WgtgrH144Jlo6HYH+OMiDIIsQ+qJFzy+sKAmGD/wW3w25XVLmkoRbjZfmnb9VzxqWxnV11ElKiWpLKwOm9J+7w1wrzjet7puRpQuNjzvEOGz9f6o5vvlFHZFqER3BBfSJYGvkAkmtbmX5G9ZojnqHiKRG59qMdfTnRVhicZbJ75G3XFh87OWlEBDQ4leuPYy6zPXFvCHCFx6Q2i0i57EE1g5ppiJsbieiO/jS28Gl+UIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEC5hr3tAKTD+jXZBwrtYWtBStRzevILe/PpLZJ6P3U=;
 b=U2TED3O2gqkocCE/PB3/NKDXBWoIEE8fQLlGTg1NFLmxjy5gn90hXP2I9vlYUeYLIWQ+VSUmVL/fGlPn4akE16kgqNiugpn6mEKgjxwTRU29/cEqiaSdn7PjST3k16T8Bh4Plq++72N1H7TI20367sT4qwgcWKoF3ixXjiTq9NqTFvdPIaN97z0G7Dc3gOaekNHHTuKoCWh4SUAzf9Df5EN7OB1k7Rr1OadNxv/hF5pPGSv/zy/OdSRILywkHFjlyF2oooeKBpiNxxwR+ym/M8BwH5KLZoCtLymmNGRllZLum+7lN9rysvzz2qgkQD7dZBvJFBrsFVLegsfR4llfDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEC5hr3tAKTD+jXZBwrtYWtBStRzevILe/PpLZJ6P3U=;
 b=rfUY/ZMC2Fw6DKUA9i2zEW1TIlNQx8znmNUfOGXXHal1BFngZszdxn4OCiImq3cAlymGHfbhAuDCz+U1uxZMH2IqTyTbfWvK5tJRhUng4HRo/iFKLqpMQhQvp6xbJ44q5zY8d4WXXugTgsI/9qwctq9jhHZuT4uYmVV8mDQVQQDkLzs4cHqgagsd5hTl7FS6YBjLixNcoB+k6qYH3M2hQcK7aHkAiRdZ4Fpf0pc7KB7/FJkHIyzCBfx/b7MqHmLP4w+UGtZoXk6QNhGtrPQYmTkG/TQANdQYTpsooZUVt8EUxZ0cLUZLXf7zzifD/fEql9OfU4bEO56oFg6s1CGD2A==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:36 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:36 +0000
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
Subject: [RFC PATCH v4 17/25] target/arm: fail named CPU models on unknown non-zero feature ID regs
Date: Mon, 21 Sep 2026 12:32:41 +0000
Message-ID: <20260921123249.1708067-18-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 08846e41-9f7c-4a82-10f4-08df17dc8e6c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/y8Uh6xnR0SIrbxkIIVt62gukuqE+gKOVRdhmWAIKIwg7OZ9RIzoNPk2a9VhqI1wvLO6IItnW866yG+O+RGkdFDD8fEuAXTpxOdncyd2rRCYrKze5iJyj+R9rSN7Fp7QLR/SY2cfIA8tygX7LM+g9kJiandFKpa63738FArFrXmjN5gE+VD/hs6Xa5g9HS3T9Ra59Su5W7R/71hxETSSGtcVUmBSVXhZek1gTnpMlXWhQQj+JmA2bcmtxW+v7q/j9HydJEGgqvFH9PLm2gEkYLMTI2jknpfA7TtnK4uWt1pkUzKHZemVzjofW3orvW4hlu4ActTF18axTY8TeRvhFuay9rGCMMeQhp50kDYoMib3t4DG1rqnhU195/w2Rfu2EJFs4O181bI/XN3/fdBfNiMVZV3W6U1iXxxyP0vbt0wOK8nWMzP20US5ZIY0nRlWmkXQ+gHj8DRWklpzd9nBA6F9gr71Y/N/XDts4ZmBGX0OIIMR2L4qh9+bEFByQD7p/DrjOBZ4Mzavf3EakaMH5LTQGb0nuSG4kPc+pjwQv6JJ8dKcw3IxdUAF6hr4Kx1UnWbwJgU9pQXvZLr5zXRHTUffqlYel/Wu8c76MhrN7jZa9KrNEqcayFvbGyTlCgelZPp2BZnBtx/CKIOiAnRX8Ne5znubY8SNQxKflyt5TjI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jW1gTRJ6Nxr1Y9/AgmtVGeWSVCIk9du5dKuaj/S05pBePHBSf5YWgLHOSZWS?=
 =?us-ascii?Q?qruS0fj/DWfENGy0JzTxuGOxmVXzwVSyL168E4Qs4bCWagAz3dCmSp7HzAnx?=
 =?us-ascii?Q?8IEIAVvR3+FFNB4h8JMM0rafwj+k09Ujgp1HTnNSBwP26AK5QUaeog175u2V?=
 =?us-ascii?Q?jshAbKdTTv/SmEbkjt2SKDvip6mHkb+Vh02jWiMoAQs1BEKnFLEeO19zEYD6?=
 =?us-ascii?Q?5E+gE22LaSGo7ewsiBYSKJt5AmBf6zk2hoE6zCCEPI6hfuT2hobHh6+RDlbT?=
 =?us-ascii?Q?hfDcO3wF1SNmGZL1axD5YN0yRimpLiQhzcwxKLK+kX+otDIMWl5PcCEkzdQp?=
 =?us-ascii?Q?40we6E3JlvCAlU1GSOcBeYrc7FQiKD9pGQR6ZDAYhUVLjUEX3vBRmWDBYFqK?=
 =?us-ascii?Q?KBxaCGqcqjE2tW0pLz3rq4zRApAH+nk4bndBdXy0s8uQ6DaiA0v8EjO2JBEe?=
 =?us-ascii?Q?3FnItvSeqL/C45uSrKrafA2Av2Uekp1aPFVYoxkJHgYqkrd2w+AO0U9RUvcY?=
 =?us-ascii?Q?LjRpq3t7yzSqd544rNtvl5Q9QqbxAqYx97iuRcQCcVc+Nko/qxwBHz2g9EuG?=
 =?us-ascii?Q?jiwbf6nGTS2nZfFcVqe08R5IAAgvbXAqAUiTG3MQRk9MVghdviw+FGFfcu9t?=
 =?us-ascii?Q?OAr+NMUX4NmecqDg9PNTOI90h9pXQ2XLOXPeWa65hwwe/TVJnisurXFlqyhf?=
 =?us-ascii?Q?rgQp4iTWQCxAIdfZ97Bnc3LB1q+9M/8ipRKYkELNUyObG/ySgobSaBeBxHwK?=
 =?us-ascii?Q?lPNtu7iPIz2nGh0JUkQSgKgXV7lCrCmtDpYLp7adjBhwzbY2xngToQRrAjPj?=
 =?us-ascii?Q?bXZdyxeGmSJF5krU3QQ6D6PGpdweKcIE5vEBSPGY7G75K3wwItQO7H3lb2Ue?=
 =?us-ascii?Q?/Lr+lXafMvFB73IShRtnYqx4L1UvEvb3e8WNBBmDcqUyQI86PCilddnYhf90?=
 =?us-ascii?Q?80z/GEXrEk9d/tSuks2gDlVdtzAJ24dcJ50VkszqPicls24i/kKxppqetMLc?=
 =?us-ascii?Q?Is9DK0N/mkMQ94YMRJJYztPD5VpxUqrgghqze5MzaZusW4RmnEH68wbU/Qnz?=
 =?us-ascii?Q?4XWb7mh/uxMmksGLP+pvbolIwOFJ9/bToRHIXzTnKowjqKgom8LpA4fGxLW0?=
 =?us-ascii?Q?6QdCfNvThIg4DCuJR889ns9LY02ExAOzqbui9OTixVszVMjdsWw18sr5zluU?=
 =?us-ascii?Q?jG7gopaQZhSuop2/6NjHbwU5SdjALyNSqB4Pug1XOPj8U4gvJqWTLaCRKHpI?=
 =?us-ascii?Q?260ImsZf6OW+3QJkGchwvHWS2u4zRohjs6wjGDqzP+0oLhk98GZab1LraCVs?=
 =?us-ascii?Q?1xLQmep/QnVEap6uTPRSIr39P/anh+YWhx5lno3kXintMiJ203Xd/dxA9nM9?=
 =?us-ascii?Q?vJw9AH39Rg3EMO2RsfOWFEAIXyPnbQcWHSkXSDxOSRtw80TcGE8t+paUXnb4?=
 =?us-ascii?Q?AN/zObhuA8YzXESLk47FNjrGpnVwiwZGso0zkysM0IU4zMdCfxsjA6o8qT22?=
 =?us-ascii?Q?ctz2Qdmfkii5ztUH+Z1Xbk3rWR1JcS/MM7XYMhVCk24VJQ5j9kCG2hUGOJ0v?=
 =?us-ascii?Q?pEwrLDITLtTzKktfoETNd1Sal8dTfF1n5kS9rwHVD8TVfdKOkYMgPtB9FT4u?=
 =?us-ascii?Q?fZkEaHqTQAPYsaprmAnwFc2v+fNN3TFDEvgCcTjnabYFfmjkU//Fve7jwB40?=
 =?us-ascii?Q?PBUCUhQ5hgbYVV0gqtRdg+VLP3eKU3ISfX3PXLQE/ZbwSLN8515mf56D98+Q?=
 =?us-ascii?Q?UefEBAyjwxQT3DKyjB7sFA3FUMwrjYQ=3D?=
X-Exchange-RoutingPolicyChecked:
	ce0k2wHUfXFSLI3G+0Efy2BabAEwgoYTeRth8wNGmCGQ4D7LN+36WHaLeR6k14QPSqc204P19q2D6eJu96J/s4BubdukzwKyuPUU7KTJ2Tsug+wE0Uvzn1UHKIk1FlIXcWhSMQt9Z9w88VwhR4wEzSU2tRZHKyoPFm3bsDmanJgelEcM/l/Bb7tEzBVlzOtwVTJRcOuDzr6nF+5CqixP6dmZcWwpNDrTk4rTxcGsDYDbVC1ka6Od8wAbj2zF5zXpc/ZDgD3Mn3HQn94TASWaXbOqFvC6qy9Qx5wCpM+M4XnHfPQ1A4TvqOaFs5Rjrtcqj5hGI7cnxBVPVm+s/hy8bQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08846e41-9f7c-4a82-10f4-08df17dc8e6c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:36.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UiAUvYkl1LlTxd31V88n/LXhGu0hhl878Qw7vAJqNUF10EW9dqP4i+VutmtmsrqCtE8OVp3d2BvzaE+jozEDkvA1QB0yi9ICFGAVpGh9UMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXyIwkQQiMliYw
 26YSGb+3hcTp6x9OhJdB3EL8C1wTWmIQqLJ/4PtvXV2t6G+UgwB6YPjrPS0mhQjL9YyKgBocrjI
 hkCIv0A5UvAcwajjQA2+t8IRsSAlVIN4wb2SYOsUquTsd8t73RdDLGUcyws4vYl2FKcGpKjC1Ab
 WPkJSv/xakQ2Gv952VWV82tVOWBSY7WDakmNmcHjlbM8UkWOleAe3eHNl1y1NVY4cWdIactPJlA
 a501p8yv9qF7W6QnqxhqAuXRDlTSZRsV0Q46UdkTdrM2/lWGUqBvh21EHKR0Uc2q+OWVKlVxnIo
 v9V5C5oaxsFagS4HfB22k1xiJLTwerxvIBfeTPS88m8Ha3thf5JDVGmO1yYZ0ebOkPpsHdfN23L
 +DHCsuypiPHOL/vGlg75XnUBfVnLaXkrYB4KJuO+hhu2PwgEfDgt/ICE28hkp0p8UtqKQV5D26n
 39mMFgDyNdZbuU3NEyg==
X-Authority-Analysis: v=2.4 cv=E9BYNqdl c=1 sm=1 tr=0 ts=6ab12421 cx=c_pps
 a=WiodiXt0wH02q4ozJLtFAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22
 a=64Cc0HZtAAAA:8 a=6kWvz9PVh7Z8NVP_MmYA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX3w5HU+ZShEzA
 zgXA0Opy5QGgKtF3Rtyg/zH7/hEklrQsN4rQr8sKQoX4fDLkI8paWzZ06FpBy7lIoAt/LbINDkB
 I7jwD1ygE6UCFz58q7tn0KWG2rJ9DTM=
X-Proofpoint-GUID: 9MN9MxNVG7030VSOSRtnIEiF7XisKA4s
X-Proofpoint-ORIG-GUID: 9MN9MxNVG7030VSOSRtnIEiF7XisKA4s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Named CPU models zero the ID registers QEMU knows about and then apply
SYSREG_ properties. However, the host and KVM might expose ID
registers that QEMU does not know about yet. In this scenario, named
CPU models might
leak host features to the guest.

Part of the problem can be addressed because the Arm Architecture
Reference Manual specifies that unused encodings in the space (op1==0,
CRn==0, CRm=={2-7}) may be treated as RES0. This range includes all
ID_AA64* registers.

Error out if KVM returns a non-zero value for a register in the above
space which QEMU does not know about yet.

get_sysreg_idx() now returns -1 for encodings that are not known ID
registers, and kvm_arm_read_sys_reg64() exposes a KVM GET_ONE_REG
read for this probe.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-models.c  | 74 ++++++++++++++++++++++++++++++++++++++++
 target/arm/cpu-sysregs.h |  2 +-
 target/arm/cpu64.c       |  3 +-
 target/arm/kvm-stub.c    |  7 ++++
 target/arm/kvm.c         |  7 ++++
 target/arm/kvm_arm.h     | 12 +++++++
 6 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index 4e92909755..855eb5ee6b 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -362,6 +362,78 @@ static void reset_res1_fields(ARMCPU *cpu)
     }
 }
 
+/*
+ * From ARM ARM:
+ *
+ *     For unused encodings in the part of the space that has op1==0 and
+ *     CRm=={2-7}, direct reads that are not trapped behave as Reserved,
+ *     RES0 to ensure correct behavior if the encodings are used for ID
+ *     registers in the future.
+ *
+ * It includes every ID_AA64* register.
+ *
+ * For named CPU models, we can check if any of the unknown ID registers
+ * that fall into this space is non-zero on the host. If so, the named CPU
+ * model leaks those host features. Error out in such case.
+ *
+ * We cannot do the same for the remaining Feature ID space (op1==0 and
+ * CRm==0, or op1=={1,3}). Unused encodings there are UNDEFINED. The
+ * implemented registers in that space (MIDR_EL1, CTR_EL0, DCZID_EL0,
+ * CCSIDR_EL1, ...) are identification or cache geometry.
+ */
+static void arm_named_cpu_zero_unknown_feature_ids(ARMCPU *cpu, Error **errp)
+{
+    uint32_t init_features0 = 0;
+    static bool checked;
+    uint32_t target;
+    int fdarray[3];
+    int crm, op2;
+    int fd;
+
+    if (checked) {
+        return;
+    }
+
+    if (!kvm_arm_create_scratch_max_host_vcpu(fdarray, &init_features0,
+                                              &target, errp)) {
+        return;
+    }
+
+    fd = fdarray[2];
+    for (crm = 2; crm <= 7; crm++) {
+        for (op2 = 0; op2 <= 7; op2++) {
+            uint64_t val = 0;
+            int ret;
+
+            if (get_sysreg_idx(ENCODE_ID_REG(3, 0, 0, crm, op2)) != -1) {
+                continue;
+            }
+
+            ret = kvm_arm_read_sys_reg64(fd, &val, 3, 0, 0, crm, op2);
+            if (ret) {
+                continue;
+            }
+
+            /*
+             * TODO: if this encoding is writable, try to write 0?
+             */
+            if (val) {
+                error_setg(errp,
+                           "unknown Feature ID register "
+                           "(op0=3, op1=0, CRn=0, CRm=%d, op2=%d) "
+                           "reads as 0x%" PRIx64 " on the host; named CPU "
+                           "models cannot hide it",
+                           crm, op2, val);
+                kvm_arm_destroy_scratch_host_vcpu(fdarray);
+                return;
+            }
+        }
+    }
+
+    kvm_arm_destroy_scratch_host_vcpu(fdarray);
+    checked = true;
+}
+
 static void arm_named_cpu_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -401,6 +473,8 @@ static void arm_named_cpu_initfn(Object *obj)
 
     /* 3. Realize the model chain. */
     arm_realize_model_chain(obj, model, &error_abort);
+
+    arm_named_cpu_zero_unknown_feature_ids(cpu, &error_abort);
 }
 
 void arm_register_named_cpu_models(void)
diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
index 7877a3b06a..d48b44705f 100644
--- a/target/arm/cpu-sysregs.h
+++ b/target/arm/cpu-sysregs.h
@@ -37,6 +37,6 @@ typedef enum ARMSysRegs {
 
 extern const uint32_t id_register_sysreg[NUM_ID_IDX];
 
-int get_sysreg_idx(ARMSysRegs sysreg);
+int get_sysreg_idx(ARMSysRegs sysreg); /* -1 if @sysreg is not a known ID register */
 
 #endif /* ARM_CPU_SYSREGS_H */
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index a0114b0fa2..3cc698d65a 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -57,8 +57,9 @@ int get_sysreg_idx(ARMSysRegs sysreg)
 {
     switch (sysreg) {
 #include "cpu-sysregs.h.inc"
+    default:
+        return -1;
     }
-    g_assert_not_reached();
 }
 
 #undef DEF
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index eae2e1ec2c..d263adc921 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -50,6 +50,13 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     g_assert_not_reached();
 }
 
+int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
+                           uint8_t op0, uint8_t op1,
+                           uint8_t crn, uint8_t crm, uint8_t op2)
+{
+    g_assert_not_reached();
+}
+
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
     g_assert_not_reached();
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 70d9a07580..6f704c0509 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -263,6 +263,13 @@ static int read_sys_reg64(int fd, uint64_t *pret, uint64_t id)
     return ioctl(fd, KVM_GET_ONE_REG, &idreg);
 }
 
+int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
+                           uint8_t op0, uint8_t op1,
+                           uint8_t crn, uint8_t crm, uint8_t op2)
+{
+    return read_sys_reg64(fd, val, ARM64_SYS_REG(op0, op1, crn, crm, op2));
+}
+
 static uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
 {
     return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 997120966f..4e563fab96 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -154,6 +154,18 @@ bool kvm_arm_create_scratch_max_host_vcpu(int *fdarray,
  */
 void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
 
+/**
+ * kvm_arm_read_sys_reg64:
+ * @fd: vCPU fd
+ * @val: filled with the register value on success
+ * @op0/@op1/@crn/@crm/@op2: System ID register encoding
+ *
+ * Returns: 0 on success, -1 on failure.
+ */
+int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
+                           uint8_t op0, uint8_t op1,
+                           uint8_t crn, uint8_t crm, uint8_t op2);
+
 /**
  * kvm_arm_add_vcpu_properties:
  * @cpu: The CPU object to add the properties to
-- 
2.52.0

