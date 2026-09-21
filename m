Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D14496D32
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994071; cv=fail; b=G+u+HYRv05C8jllAaruVV46cV503GlD6ngGXdDF9aWGSzGm1g6y/IQpWzmr6N0TnwSruEUxNIm7byXSsi8nVzgORQSjlVSMNA/dv8UiX4o5bZm1Ox2ukmbyrct0qXvd9i6hTN/iXLCtyoE9gurKtKTpZ6XfSRhrKRu+8EauJCpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994071; c=relaxed/simple;
	bh=OKQrD/BXB14vwMVoDOSn9gVwOa4oTWSs4U0aCxNefe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jFAdL8eyDbH+PpveEN66d1F+lAQRWPF0mqmjR/AC4N0k0DwBK0Hg7W2iGGI5fwa8KLyPC8wtq+ChccklBmMNczALXoQ/5ijpHKKT/oU6yOAnkQ3Fk76hi4SLGVAm1SGso0mh1vj4sjthdPo7EJsCfv/Rsfn+mviA8CDLHMfUFXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=X7RZELc4; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GLNyUPG/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="X7RZELc4";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GLNyUPG/"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhVsQ932497;
	Mon, 21 Sep 2026 05:34:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=YfEjphQHkNCktjX6nbNJOFYkfjYMribhezkOvwlAn
	tM=; b=X7RZELc4+hYES9rDJA1Qqbe5xuBYQ9YYnaSwQLnGqXK3jHSsySsm6SEQm
	toOm0bFLo+dxi35wiPscOj8IPWakY9tGeRFYJ0AubHt7c1c4W9RdbtFx0ZwpkzqK
	/poQOqwO6tAEuGCr4AD42rRqq2m3/Zzavt5kWJssb1P1TT0hD8fnqw/k6rvsnBlb
	4KRum9bqTSEYJIJE9hrmOmCBLCpyhMwBhInJNv9RWe+tt5cPP56exm4IayXxIqPC
	eNVke9vSh+v6/i5k+CvaXdIpX3x3+gnrimKsI39Rwu2LPfXqicRdWbb3zePUjsQW
	CPmBpgOH8VU5tgi080QyhnQ1TfkOg==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11020141.outbound.protection.outlook.com [52.101.85.141])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gssxwkcar-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:34:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LaTs6iVaLqin9EenjRcrxw016JoqgrmJeY1iEvwVlWwFGRcf9YAtICbmmq8Mi+LT5bY2LSYy7tvQAtSJDDnyB4YWlGGkN4F5ecjglKRtVPftI0lU0bMYcbY+fmMdlNbqAAK7F7//qYwMKBkuAZzFa74LGj4bqqmUM7b91djJZYdf+/flt8/Y+Z3j1M0mKVFmFt7uT5SPR84EngeGB9wx4P2kmoz8FmQamN7zYjSrj8FT1yUbIv/xYWsrTq1YwlATtcng5fSkDHneuKzSiNqnNO6Ky0uZ6wMGri7eLH13We2QJ1LYB6NxUpXpRy/hXGTSgjif0otWCQIjFMczMeahww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfEjphQHkNCktjX6nbNJOFYkfjYMribhezkOvwlAntM=;
 b=jChp6Uzvmvq+xMyV7fJ5UYq8GcmZwpyt06Ch1e/oO+nV0qM4Lwbrkxk17xbkkA+3wiwXF7u09Xx2AZIX4Hb26BCV9PR9Ff5ojZSnYr0xTqSRlJBEY/KrtJvfHC/XEez/bjNKI9z0x1Ikq5cz29dbQNR7s9BlvnW04gCqOecrZH1rlUobWVF1sqWR20EWNUDRmJLg0Wt1L63/r770nYGd5qHDslAhx4pjtFt2n/hsdw11Douim1Hjqake2CepBqCqTJ0Tiyy3d/AGgULJ+5YIqFareCvQPsjTuFdsRFVKkb52NMwOhukBWud4MWs1iwvGvRt03jxKcblL/Z884jb/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfEjphQHkNCktjX6nbNJOFYkfjYMribhezkOvwlAntM=;
 b=GLNyUPG/mUWxW6TQ4L0G6F8JeoE2EriCjlMl9go/CQ5iL6tjr4cRsC/nL2qRGr1ZJFcgAsPZmryXd9Mmxh7PZSOppcZHMRetCDlY4lHbdDdaB1sHsFkqCNnZ8sEzzf5iY5lRPqL3MiQclxYmF+yWS3lxdEfpch/b3XXKskmxNi1NdNDMcG+BlwVyg4qpoTapIiG6EPISfzFKRypjbPIQ8ok1efngvPH/3OtEVs8dfmBiKUKakRlSh5q1VLtyoC1YmsbvRmORXW9N+dfqZLGG0Pz7zFyor7ZdooFiG8DDzL3XTAZ2aotnIrINceJQLmn2IHasuPIh12AqYRPyc4Sl/w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:27 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:27 +0000
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
Subject: [RFC PATCH v4 07/25] target/arm/kvm: process ID register writeback per field
Date: Mon, 21 Sep 2026 12:32:31 +0000
Message-ID: <20260921123249.1708067-8-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 41651d95-b4cb-4056-8317-08df17dc88fd
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Yi/wV0WVJQy30718bU+CDy2Y0HwwhP1tlvXCB71XIS9pL9fgR898H2OenYJI7DKVSQ4F3vmJo3ZqJuAnh8iEglXPCXoB1SDTRifLMCSj2bQQ1lMcl2r+21K5cWUmTQZBfhzbLC+80WeVpgsCxa4y4mzJzzMXADZkSFz42rXs5yRHkld6izlSlnKqHqxhmXF+l+mFheVsQcmtM1rFjfYAhG7T1VhGVjb2LjV8MdmlpmOCdKDpExQNbJY77CvFfo+w000NA4436UO6w8BmiHM6WHOfiDBvHL6FQgmfJE0bSOwND4fAoUuT8ZWRPTKYEvZoPZfiI7hlPJhvtw8T6KNWSJYi2n4FrMKQ7VMDeQkjmqGIiE5wvHqjV9Mq//votR/TwwWWXM+LJY+4wdgRvF9BgkZ5mfOIzstwD9Lt7tgOkMzdRomuUq11D8DsaYWoaRHY2rdKBN/fUJTZRKB/qeYY5x4RU1kJlqXlNHrhRGCgijvuqPYEI32oSflTTG1yCYMBZaCyi2UR8kkdV2+wrd0ddozy+0JrfszJQvmlWop+Ymp42BxBcR5urzJmQjjJeVstc8F4J6xB1cxaiAxt9+bfEoo4Eg8hP9FByHgm2xknjKLYqbNPdt4cGyDFd3UkylSvO5NaySio6eWs1gkKaoAQ/vlym6P9iUd5FjnTeID7oZE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mD4/xphMCCec3drJrpEf9msIILaCzNFmkksQRzJH6hZYOqRO2Q3nsWa2PSbO?=
 =?us-ascii?Q?4QMntwU4Cd00tRvzBkogTdw10qlPJi9FE8cVLhpeo1Zye+/8ES5JMaJYzbG6?=
 =?us-ascii?Q?01oS/1vjuN6G9LdMrUSE27cRmxoZLBRNFLFmRwPGZHqAqNR3U9jl38H4HrJn?=
 =?us-ascii?Q?5wDQ9YQKbvYMxBwZeB+71ZXrMK3wU2RuDzgCFdzWJmI9YLOxHC+KyhpX2FiR?=
 =?us-ascii?Q?emQ+gnmMJHBdzPqLop3Lf8xzdUQne+5Ip/9cmC0++812VaTx2IhUhS5XwJAW?=
 =?us-ascii?Q?b6LOArTL/wJO4KWZvyA95EE3Tp7MESu2EY+eiEKLo85w38l9sSSfe7kIsCUb?=
 =?us-ascii?Q?JMomg0jrjtTxDqgmLIOoPcX+ftSDGdy5vQdSq30WnF4ynwyxo6sJtAGq0p+w?=
 =?us-ascii?Q?S+22jk/e+dKgUf/4fvodNg/Ojc7eJjxTYkbR/lKja21QbfUmrguQ3P5Q5JNa?=
 =?us-ascii?Q?9M5gNHlMO41gIelzPZ5A+gobIVq96knfQMKOAdGOOePsAMfxYu/DFl6UliOv?=
 =?us-ascii?Q?BIDBbG3GZymxQWd5ugDY+KmnZ5aYeYAKS294hOGtL07wqlfhKJj7CoqHJSwt?=
 =?us-ascii?Q?I6FsMvDaJjmIVDWnv4vg3YKS7Ytn/oUgBZQoRP2Y1vQQydYBCF8LTOZfIads?=
 =?us-ascii?Q?MWsegmp5xdQ6l8FDYxfKTQT6R9qADhnfJ9utl+fUtsHrFqIFouqIxhRXzBvo?=
 =?us-ascii?Q?Pd9aZQGaFFQVw8p7Dvo+v6ZKpkYR329+IenU1mJJGg1oB9B52lmgmdOV53T3?=
 =?us-ascii?Q?8AOXm63P76B7eeUkHT5ZfkzzAFB72Jb2r3pZ3HyDNmedk2w+DkHPYtzO2wVI?=
 =?us-ascii?Q?FSruaUBCUufGI7UqpqiF99QwiHOSINpVlxovl5TCE/m0ojfC/aKnjpXnWSCu?=
 =?us-ascii?Q?CM4+L3B10H1Fgo/TH0ppelbbLIG2k9ASukDHCcwY4BntR99HFVoLqaj+eZIh?=
 =?us-ascii?Q?YEqAr7Rbjm0x/Nqqt5Dz364Iwr020sfCNfA03pen0h5mYWjpQtLK1oisNvOe?=
 =?us-ascii?Q?k/btATQSabhrQ8ip2Zd7GpdMBmkFhM+U9df0qGzZJUy+uK26O2L4b+++KQQR?=
 =?us-ascii?Q?eSy2ISq4E1UOYNVU6T0bLyVVKB6ugSkSb/etgbxUe5hCDyy0vz23QGewAc0V?=
 =?us-ascii?Q?h/Z6BXF0/MXkcE+RkRinuPhXuDv1Zc1bD66aiJtF8gK+49jHa1GSbrvKqdX0?=
 =?us-ascii?Q?bZCmZo8Mq/J5Nx0xlRYjb+dqpgfXE6ygwabbARnS33b3BBQepymlF7vUVC17?=
 =?us-ascii?Q?ewXSjOmIf1A1oqfOxB/IZevWZ/PWaNnNibenVRrj4t4ueDqaQGJCcl/8q4G0?=
 =?us-ascii?Q?Mga94n0AM+QlUsBSaq8xBtnrQwdxfZ50inErc81sElunXGN3vg01dYUzPz/l?=
 =?us-ascii?Q?l5fQwob0CJ/2d0Yw/B8kpwLkyopOhjWgMp7Oh1f/G+x8KWOQ7+QWizCjclGc?=
 =?us-ascii?Q?NrrcSFyZDgClT05e/eCSv498tJyqB3jpcujHI5MI+fEse8YQpxwOewcBxqfx?=
 =?us-ascii?Q?4Bt6xnOsfLt29aseavuHic/F8KtPpXJnwvfCIOZ/bkJ45PVXpbS1GFUZiT+S?=
 =?us-ascii?Q?ddccqI486yWCkcxiJxw5U8/MZBFzSfJsUW9jGoK9TEA4oS98Sj9jnLwC37vv?=
 =?us-ascii?Q?BMqhi9SeInTI77luYSu1+zahxeIOuUjPiu+WrM71IIMWev7Cj9/PK2jsgFnV?=
 =?us-ascii?Q?DizMcz8OhnmjIIXaW5qt1OJYGiFZvXSH+zyaR+ofzqpHVYU/l91lA/3fdHYI?=
 =?us-ascii?Q?CAV0YFc8QW0QBGVeKLhKelbxWabPYio=3D?=
X-Exchange-RoutingPolicyChecked:
	P8LVcd4y0TqddbxgAbgobMidL1BTQ1KSIx2Mpqk/k32ESI1ASAkb7pJkeqFRDIJbYnOisAY3GeL+afKm6lJKRhO61gZC1vOpIvlVGOC3o+IenXY+B1NfVIv12xmnDNoWfUS+eipNFtNw6cNKdw2yS9wYQ+sBhL0rfMOTA0tG+HiGdFpJAPFWZot348CgJqd4cIVZ58aTgmKTWFJ+ROsmJjQdxqmkBoWrol+X/qIcB0UOjRFCdh5x+CJ1oRgNTb3A0H68r/pAwbRlEENtrA7tx6iaWVf/RbC04fmI+f7Of2nihfarIm784gP9nTKU+e3ZQY7nLOinqyBpPMtJV/M4xg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41651d95-b4cb-4056-8317-08df17dc88fd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:26.9639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cozRyLA7OvjiVjfD6Gcimbvf768W8Wo8pqWvhaIimSGYpbUN/H6mhMu0IOH/cb8E/8nSShGugeu2eaVALhP400Y8hnNfI62NH796S1VaGUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX9N0O93oDmRXT
 SYg6qdcUIEcWeeLu9blO9mKvushF3gwgiUu99BVw4zx/HCbGZ9FSyPGuCShVyBz/WDQAK6DpJ5e
 Ssz248OfQp/jpIX3By2H7nOsJdU+AU4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX6MFlMqP1eTN9
 F4Il4IWU2axWqL7RYvS1Kr5pGn6I5f8QKlpXuW/ACdL5Rv9tWQo5paP5oStuLJ2XKlmuAuAX5LB
 9Fl6FJE/OK93SjQBmttHva1UKID5NT0LXlEDo3shoVtPaSiIcs4pUv4xRYF1/6OhMHM0cTQfWje
 l2X7ILvws8XLIPQ5yl6pYATKD6KkGSpWs6rmPeDS/sD9ph9bceYmT7Ue5hKo7ikBimjPsmR1imP
 fq27coK/mODjCKNUNTjuIw43AR2z81HK8gIzZAgbxvzUCPHC2xhZLQhPWuyjn6LfFrFB+wUYmzm
 McO/le6jVY73Izy9LEat1G26f/Chka5YJKbjdcdWb7UVAFw+iHOZp0kzG9N6jwGdDTPOyxg3nlJ
 ZwG7arxh6SmQnlMOuFM/e4U/RKOVZ5SfvtaEZ6HFEWYaC7EYlOzDj3BBQ3CP/4/eM+ZVXQ+LKk0
 DSfnDo5H0FgrlKD/1hA==
X-Proofpoint-ORIG-GUID: OgeCy8lc17gy3FS5PTa4K0XX8qibiEa7
X-Proofpoint-GUID: OgeCy8lc17gy3FS5PTa4K0XX8qibiEa7
X-Authority-Analysis: v=2.4 cv=fphJ914f c=1 sm=1 tr=0 ts=6ab12446 cx=c_pps
 a=g/OBtAqTw1pRpVLcEUWRsQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=PhR9yq4GYvPAogIgPbwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Now that all ID register fields are exposed as properties, refactor
kvm_arm_writable_idregs_to_cpreg_list() as
kvm_arm_write_idregs_to_cpreg_list() and process each field
individually. kvm_arm_writable_idregs_to_cpreg_list() assumed that
only writable fields were exposed as SYSREG_ properties.

Copy only fields advertised as writable by KVM instead of replacing the
whole register. For registers absent from the KVM cpreg list, compare
the requested value against the host value captured during probing.

Return an error when a non-writable field differs from the host value,
failing vCPU init.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.c | 13 +++++++
 target/arm/cpu-idregs.h |  2 ++
 target/arm/kvm.c        | 79 +++++++++++++++++++++++++++++++++--------
 target/arm/trace-events |  2 +-
 4 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 199d593153..d58b8ed063 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -7,6 +7,7 @@
  *  SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include "qemu/osdep.h"
+#include "qemu/bitops.h"
 #include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "cpu.h"
@@ -94,3 +95,15 @@ ARM64SysReg arm64_id_regs[NUM_ID_IDX] = {
 #include "cpu-idregs.h.inc"
 };
 
+uint64_t arm_get_field_mask(const ARM64SysRegField *field)
+{
+    return MAKE_64BIT_MASK(field->shift, field->length);
+}
+
+bool arm_field_is_writable(const ARM64SysRegField *field)
+{
+    uint64_t field_mask = arm_get_field_mask(field);
+
+    return (arm64_id_regs[field->index].writable_mask & field_mask)
+           == field_mask;
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 98c7a7518f..aab1a79db1 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -33,4 +33,6 @@ typedef struct ARM64SysReg {
  */
 extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
 
+uint64_t arm_get_field_mask(const ARM64SysRegField *field);
+bool arm_field_is_writable(const ARM64SysRegField *field);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 07df6626d4..2d94b3a884 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1006,6 +1006,16 @@ static uint64_t *kvm_arm_get_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
     return &cpu->cpreg_values[res - cpu->cpreg_indexes];
 }
 
+/* Like kvm_arm_get_cpreg_ptr, but returns NULL if the register is not found. */
+static uint64_t *kvm_arm_find_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
+{
+    uint64_t *res;
+    res = bsearch(&regidx, cpu->cpreg_indexes, cpu->cpreg_array_len,
+                  sizeof(uint64_t), compare_u64);
+
+    return res ? &cpu->cpreg_values[res - cpu->cpreg_indexes] : NULL;
+}
+
 /**
  * kvm_arm_reg_syncs_via_cpreg_list:
  * @regidx: KVM register index
@@ -1308,31 +1318,67 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
 }
 
 /*
- * Copy writable ID regs from isar.idregs[] to cpreg_list
- * in case their value differs from the original init cpreg value
+ * Copy writable ID reg fields from isar.idregs[] into the KVM cpreg list,
+ * so the subsequent write_list_to_kvmstate() pushes them to KVM.
+ * Only writable fields are copied.
+ * Returns -1 if any vCPU's ID reg value differs from the host value and the
+ * field is not writable.
  */
-static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
+static int kvm_arm_write_idregs_to_cpreg_list(ARMCPU *cpu)
 {
     for (int i = 0; i < NUM_ID_IDX; i++) {
         ARM64SysReg *sysregdesc = &arm64_id_regs[i];
         ARMSysRegs sysreg = id_register_sysreg[i];
-        uint64_t previous, new;
+        uint64_t writable_mask = sysregdesc->writable_mask;
+        uint64_t desired = cpu->isar.idregs[i];
+        uint64_t previous, updated;
         uint64_t *cpreg;
 
-        if (!sysregdesc->writable_mask) {
+        cpreg = kvm_arm_find_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
+        /*
+         * Registers such as DCZID_EL0 are not exposed through the cpreg
+         * list and are therefore not writable. Use the host value
+         * snapshotted at probe time as the reference to check the vCPU ID
+         * regs have the same value.
+         */
+        previous = cpreg ? *cpreg : arm_host_cpu_features.isar.idregs[i];
+
+        if (previous == desired) {
             continue;
         }
 
-        cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
-        previous = *cpreg;
-        new = cpu->isar.idregs[i];
+        for (int j = 0; j < sysregdesc->fields_count; j++) {
+            const ARM64SysRegField *field = &sysregdesc->fields[j];
+            uint64_t field_mask = arm_get_field_mask(field);
+            uint64_t prev_val = previous & field_mask;
+            uint64_t new_val = desired & field_mask;
+
+            if (prev_val == new_val) {
+                continue;
+            }
+
+            if (!arm_field_is_writable(field)) {
+                error_report("%s.%s is not writable: host=0x%" PRIx64
+                             ", requested=0x%" PRIx64,
+                             sysregdesc->name, field->name,
+                             prev_val >> field->shift, new_val >> field->shift);
+                return -1;
+            }
+        }
+
+        if (!cpreg || !writable_mask) {
+            continue;
+        }
 
-        if (previous != new) {
-            *cpreg = new;
-            trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
-                                                        previous, new);
-         }
+        updated = (previous & ~writable_mask) | (desired & writable_mask);
+        if (updated != previous) {
+            *cpreg = updated;
+            trace_kvm_arm_write_idregs_to_cpreg_list(sysregdesc->name,
+                                                        previous, updated);
+        }
     }
+
+    return 0;
 }
 
 void kvm_arm_reset_vcpu(ARMCPU *cpu)
@@ -2293,8 +2339,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (ret) {
         return ret;
     }
-    /* overwrite writable ID regs with their updated property values */
-    kvm_arm_writable_idregs_to_cpreg_list(cpu);
+    /* overwrite ID reg fields with their updated property values */
+    ret = kvm_arm_write_idregs_to_cpreg_list(cpu);
+    if (ret) {
+        return ret;
+    }
     ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
     if (!ret) {
         return -1;
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 2bb7766f7f..7b54e34ad9 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,7 +15,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
 get_host_cpu_idreg_not_found(const char *name) "host %s register not readable from KVM"
-kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
+kvm_arm_write_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
 kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
 
 # cpu64.c
-- 
2.52.0

