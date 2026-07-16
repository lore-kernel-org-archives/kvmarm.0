Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F21D3C4B95
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784238007; cv=fail; b=K2emo5pzkH+MTwIuz8b56ZXan5ONn2C8rhgFlnfLJFpnu62F0G9Pi2SGAlRoVpKu61wZwFFz979Fjhb+fXXrEr/WovMJaktptgidI72vSfeZjXZom+H6AeAFkg0tsBIBpkPRRZquogLh9LlkbcCqaKS+tioPk5AGz3ebwQlV5Mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784238007; c=relaxed/simple;
	bh=6AthRJEaTA6CnbtfSGMUcb1HKcwLm6GWqiawuV2HgPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DkWUVquy/WBEqzNo6uSYQWhzTv21/wJBhnpIkMTowU4EK/7yesDlfMzoepSuPOR9fTJOx9wgfAHyPIQ6wQKY6kfv9PJ+vVcU5z81FhLYE3n9Afp4B0C3leg1Pwh1vEogQMDe6ieDJf5ACvtDpcEk7nqJ3XipUNkv6kkIreMcyXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=S7eaXKzV; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=A69aAhef; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="S7eaXKzV";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="A69aAhef"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJtVZq1799773;
	Thu, 16 Jul 2026 14:39:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Bkvuh8Smpk05YDBrcGj0jNXfM3VQ40+Na1Oa8o7B8
	h4=; b=S7eaXKzVVBTFT9LyVIOw3VUDhUkEz7m7RcLQwsTg62sYYSJIVqgHYDvwM
	V+mF3kuN2g6Owh+P6xi75LS8SpDFY9mSo1YBTqLprjK9awzmueYC3hzduDFpgCap
	iVdAj1H5qzJE2Kek9UXpocPOSNlpNEEwHwBeZaGovETXZ1bRl83P5UQffCNipYdM
	97iZMqznp6HM5Ga0u5qFZ8RpAcme/YKZlp+Dq130cL2J8rRjBwDY4cQtqyKrAkh/
	DHZLi6jKx2JxqI7HHMU5kOuWP430vwQlmS5e5oIVhIaxZNICmtez0vY4IPwz8oTm
	ZX5z+rAY8Zj0f2uAfwT9ee6H0HU7Q==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023087.outbound.protection.outlook.com [40.93.196.87])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdxc2x3fg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLNyrvB5C53K+rK4Yg+w+uNvqJkDGqcA2AuD8vemYdU4dku8t4yp5K3TfgCLCHPSTstTvvt8Z48mNQARsC9lvj1vEQdfeNyUExK9KsZFyiJ7FHircMFc81zcK4o3vgLtqVOslHaSde52pjDyb3YLykQH6RnO0sS6oJ7E9DzBoYvlfV3lPECUCmSNUaMSKuZ2/APe2PoeVms6fb4Q4Ttq6dzJa/chXBoH6O/As7C3QhcN9GSZ4ffbP+/pwiXWdVTFXhsLMgSqG07GvgMIPijoM2tO93vk9S/NpJByMFv3HBzmqRzyFeXckEslQpSw7NyPfOY+JmnNVPleKgeYdrUZ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bkvuh8Smpk05YDBrcGj0jNXfM3VQ40+Na1Oa8o7B8h4=;
 b=DTH2aITtQUCMinm//59wOpNNQTX1e1q8pGK/35J3AAoCZd4s6BZcdN1jMGhanzjC+apgOLI/waHSZ6phadmRPCfiItFXaubxe3CVop3zlcI0rdbj9NflVBSrNqB/L2IJJIfiCIJ1ibEjAfBLDQ+unUxDAwkq0dxV+ZJ4jV6GemP6j1HXEzhqn97/mHUFRK9Y5I6ZprBf0XhDcCuMz52yr7SpnWC6J5Sr35UBzGOKDmlp2oChba9UtFBOvifPdweyD7Sqbe08KZNA1BghLgjlZvRsrutBhYct+93R2VifqErPIHu5djTk1bpQutsLwDq/TMsx+20gQ0YSxQDGuO9t8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bkvuh8Smpk05YDBrcGj0jNXfM3VQ40+Na1Oa8o7B8h4=;
 b=A69aAhefEU6PSQdfmJMovmyY5HvOt7PsLQElny7I59Ot6oyDJ6HPs+/ayQ8A9FHr1oE//83br1+zfp41GHnxMc1JydMlVrHxWyqL6+GUqxEylgFIhnV3/an+0i73/3Pg4RMp4KKlyoZwi95Gj5ookt0t7ypeLkjMDEdj1UNvQj/L8Vd5mZLAVTF3wLNGKf9QQRH+z+O99aVSSuGikL5Jxbjf/2YiKrGV2hQSF/eTIqcZFKm6trKEomXjazHY2SB0Xk4K60y5dtI3UXuhR9GxdMWUwWMYDXjpMs47cmH8SiU6FbQtRbORAjY9+EpXdg8oarGG7j0eQ0wreD0s3hcs7A==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:39 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:39 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        prerna.saxena@nutanix.com
Subject: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Date: Thu, 16 Jul 2026 21:38:55 +0000
Message-ID: <20260716213858.609699-17-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260716213858.609699-1-khushit.shah@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:510:325::28) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SA2PR02MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: 528e22fc-02be-4163-e440-08dee382bd6f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	18prWD/h7hPiIt2PvOo1KrtUNUN+eXM9tkdFf+y7iH9pb8uRX80OUo8j5hd6F1p2YJ6FrpbemeOs0unsuEhwTTdjnZY4BzO1WkxP6OxvIlchqIKeU/LRsYkBn1msZBeRqezzg0JVrhnVtUR35gwfruRp/GQ0S6n+8WBkb2FkZdCaFLYEP/ppFECcQt+LOWkE6Q50lrWK+cpHAIY0LyhsbvEQ4bV5L0HOQOPv75RjsC3fGblKe41GWIro3dRc8OIBbkkC/lO+vEK7a59HV4j9v9C9hfjnmAS7DgdashXY/nT/wVeQEIsB2P9L3V+06K6YcT0EcxPJWTJBeOexzDWwlXxYMUz82zHAShOad4/vCIyE8BDu0Xjdf3snUz5iGLWoeIh0zEUxvdVhAR5bUQ64mJ7Jlaf4iSl3/nGwrq4vdQ03+HbhGVWQegBRPM3jGyS4y7NarTl3OcllUzvPXYEmGDNzZPQ3CuRnnnGZFDH6N+EujAPhwekp7IMFpk34iYmVAA+orMPwSIpcLpT/S4zVy6sd+yoBBLiFaP4m1WsYt+35oJWHYfsFjiI0R/D21ElFLK/QEoYhG4CxcFadirNg2L3YLuzU11Ko1JpriSq2XEQq15FhXmHRM1hUZIja1nssE0wQO8FfoTEjJBZliHCyik1FycER7//0jg3+jqHwKnI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?arTMGGDFqwFYoYkPaGGzBF/fpBdG77MomseoCzMiduzl0Aa8pfJ2KqTEUmqO?=
 =?us-ascii?Q?/ARqOhPhIHgTtQjiv20v/z1KIzCaFC0MxgtUyqShuf+sYGo31j7XS5xqS+XI?=
 =?us-ascii?Q?XynxDVV986bHuJNbDsQXYoX9FuamAtAQCJJeWYD38zc03Jm8kfsv7iCW29hE?=
 =?us-ascii?Q?TJANunH7qN5xq0gxHhxaAxSRICcBqJytzvl1WV3wzdZnKqzo/sj/QbKB3RyS?=
 =?us-ascii?Q?LpCuUkcH7O2OvdAskXGdtwd69g0sxK/zCHE1/XWcBhAAyV97Utlya8QOvquX?=
 =?us-ascii?Q?zdzrlCV6sYEb25EVm+sy47RuUWRCPIpY8M3GD6Zs4gX8SE9ZfcNlJkyfCkRd?=
 =?us-ascii?Q?5ABaIeIsiFnAB8FuJKj3z4bAuworhFb181X5B7bnx7jKtj8VmhDrA5euyaIK?=
 =?us-ascii?Q?Hf/5UZiOWx3Qz3ij5DuodFxKJJ6myExZhOrXwakEcleSZnF0/GZEDjoVsubj?=
 =?us-ascii?Q?Bv5jgjJMLJAurEHru1aAA7wOE0PfzHgu7ktI5t6ud0LotuoQ5uZAkScaQ64O?=
 =?us-ascii?Q?tQ7OWgCnNwkAwinJO7yr2AUzvXF+TnRbvRog76R37N+v1allGDu7zqhFe767?=
 =?us-ascii?Q?2bbFP8ADH1JdHhUY03+hwsBwAjOleiPNG+90v8QeUMXAA5MJbKnGjh8R4n0P?=
 =?us-ascii?Q?NrLCf7tFfPFp26n33LMbbdFCdzQk0AHuAH7h02RRrtVHGprUdTC1a96W9eGA?=
 =?us-ascii?Q?cwdKhvkiQy2+O8CSqzgPGsXJR7Kr1ZR/s6zh9OR+6M/eickF/lBObU0iFc1r?=
 =?us-ascii?Q?UJ9xf6T0BhSUDVlrXgUDS4dTcXnaJPxNgdTC+HxOcX22aM8Su/DJicrK6xQ5?=
 =?us-ascii?Q?Qq0PsjPdQaI5Q4+V21019dH0borGIsSFM6Sb0uoQkxWRWldMJvAWXm3HHHdB?=
 =?us-ascii?Q?S/EereiZNJ+snEHzlaBU++UIcF60SxRAeRg470i5G3QLwdKcjvthNFAEUQr6?=
 =?us-ascii?Q?kbSQl7IMo2Qqeg8elweRcLpiERi5aiD452CnVy8iyq5j+uMy5PVNZMf1Xqri?=
 =?us-ascii?Q?QB4sAJb1eOLvfH389H1swyJHnM0WrEyFGjoh6vfzj9X7614juxpR5ADLmVIK?=
 =?us-ascii?Q?8NqNvWCIoTcIyYj1m0d//RVSW/XrM8bDDa22BpuADG1rz9XffyYEvvDg/3UN?=
 =?us-ascii?Q?nYH7ZAoAY0qGMSKpTnnV2G2oPgksLMBBx7vJ9Cl+j9Nyc45ky7yARn7kik/w?=
 =?us-ascii?Q?vPlfziRbXpIwbqlPHVYdCFKeyNHO4bp+GyxB1KZeoipEXMl8fPD7zesQgG/x?=
 =?us-ascii?Q?bFT+/z+TMTxcPRnSPTcCw5phoCSJck/kZIJQ73pkBqe2JxpoB0PQD7JJSyqC?=
 =?us-ascii?Q?lVSUTem2byMmuMr+i7CLFh6Tm3KmYZ2x6m/rOrNNnrRiAoFgIlvgpHGoSYJI?=
 =?us-ascii?Q?9ZorbeF74awHL8arQOkyHL3tYpvZifjur66prqQ04LZwwI1k1A1KElF6TEfC?=
 =?us-ascii?Q?FgJqa5z4C8mHKsQjvG0ovq2j/UTsrcOgRn7VREO3SD8PDjPG3MzVYqadLm2x?=
 =?us-ascii?Q?cHXQsauxJCk578w04Qi5hbM5ej92Ij+VbTvwvpMpOgfVeiegUdQEiL1989l1?=
 =?us-ascii?Q?FR/8TxYf7EHJYso6dpHNf9MDm/qatF6eQDQEjryiZ4OynbSw9Dq+gaXSi289?=
 =?us-ascii?Q?jJJ82ILjzeg72uR3Br9RjxdCOcVpKvc+tRJGWohb6T3XtJV6BhNmjvckvFpf?=
 =?us-ascii?Q?tWqUpU6XGXHaOQa+pSX/wD7v4iHPqeppMHUnMhKrXtGvQvrTd3ojo8D2eqYF?=
 =?us-ascii?Q?nr/v1ZEYheK5TFU0Y7E2Zav0pmsNDOE=3D?=
X-Exchange-RoutingPolicyChecked:
	DFHVvoiSNDyGIlRbfMVZt29smeAVXveib/TDIPop6qz0n6kasTwsqqyhPSeRWd0yAK7F8sGPLbga15Dh9i5IaDrnn9gbTj8y8BsPqdEAo1r7wTbFu3vQe5sUoI3kTH7B4TxAF+PrnXXl4dP6vSW91nAS2ezYpQlyNeAw6hn430RN6hVFMb06bORkP1m2gtZtO2ElBVxvfEkv4PteCBscRaVJQValfnFax/n9Yrz6gxLvkRMeTEpyrfbacsdGYWlVHRhxDgxd5aVJT2CjF5GbYLjR3S8RNktuCjv7hMepHnOJNePn7UBLPWr5gbqPUVFSfsi9d8zt1LXfDKM27yfLlA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528e22fc-02be-4163-e440-08dee382bd6f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:39.7947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VOmT0anwUU9czkTEZfdq/JLTagS08XP74zQtrLu1lHNiFEzgl14ttxMYIjsJ8Frqf78NM6SoNVoTEK87X7AeGYAXNhlg3acGlH21Guq21wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX5sYnWX979IqH
 ymj5e5HJxLblU6qojw58skVH2a4HDb6T5pyj4dMjAgxb5ahBPQ19a4aU9rbimsNbtntVeRqtocE
 N/iThZVRc5NmAGIbtsThRjyBQKOSPwRBTs8X/VGmrotoDG2cTjcm7FFp6tkYY8krTfv1vo/Hk2v
 ssbawZ1OLc3G2prALv1vZlaXKSvrcJkFgwFn3mMAOChtw32xsECriZjfWogMlLhnvvRs+llnEA3
 mM4VEC9vzFe8qaZhXOybMuZ28OGwLKCLRMJXNR6Zp3TtRaydtIcpUMKCiWYRkHhuBDMnNqSaaEH
 EGxyIj+TwSZJlJZv85SYI81+EksjLweAPSQ8RHufikk3d3gPmKRzYvoPh8ozm+CP+Y2Uq2s3hLO
 RTJsNNrzY7aWI0QR2zOhub5MvBNcB2xvTkjTgxJuAZ/UGIOXPe26x60F+9S218Zo3ErP0+Q6IQV
 qfZsdbF+W+QvvAiF5+A==
X-Proofpoint-ORIG-GUID: NR0XkjS7q7JMC6n6U_vi5ucCDEAUhwf8
X-Proofpoint-GUID: NR0XkjS7q7JMC6n6U_vi5ucCDEAUhwf8
X-Authority-Analysis: v=2.4 cv=dNCWXuZb c=1 sm=1 tr=0 ts=6a594fa1 cx=c_pps
 a=DH6uOP27q4GouF/df79YRQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=sta4Dyo3lDpbMaF2dm0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX0yN9NJM9t6Jr
 MwM3FzAD7WaLRBr8qEaSdVWWgbjJ2n2pUKIE8WmWxagW38Av3lWuqMYvGzAVWs4xeZexwe51xr1
 6Y/ItQSjFI4TV+sW4eOInaDCXOsuZ/M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce the 'query-cpu-props-info' QMP command. For CPU model
properties it reports the type (boolean or number) and the set of values
supported under the active accelerator and host.

For numbers the supported values are expressed as a list of inclusive
{min, max} ranges; for booleans as the list of allowed true/false
values.

The command and its return types (CpuPropertyType, CpuPropertyInfo and
friends) are defined in qapi/machine.json rather than an Arm-specific
schema, since the concept applies to other targets (e.g. x86, riscv)
too. Target that do not implement it return an error.

The Arm/KVM implementation spins up a scratch "host" vCPU object,
walks its QOM properties: SYSREG_ ID-register fields become 'number'
properties whose ranges come from arm_field_get_supported_values(),
and the advertised feature toggles become 'boolean' properties.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 qapi/machine.json          | 87 ++++++++++++++++++++++++++++++++++++
 stubs/meson.build          |  1 +
 stubs/qmp-cpu-props-info.c | 12 +++++
 target/arm/arm-qmp-cmds.c  | 90 ++++++++++++++++++++++++++++++++++++++
 target/arm/kvm-stub.c      |  7 +++
 5 files changed, 197 insertions(+)
 create mode 100644 stubs/qmp-cpu-props-info.c

diff --git a/qapi/machine.json b/qapi/machine.json
index 685e4e29b8..362efe4c50 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -2251,3 +2251,90 @@
 # Since: 1.2
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'] }
+
+##
+# @CpuPropertyType:
+#
+# The type of a CPU model property value.
+#
+# @boolean: the property is an on/off toggle.
+#
+# @number: the property is an unsigned integer.
+#
+# Since: 11.1
+##
+{ 'enum': 'CpuPropertyType',
+  'data': [ 'boolean', 'number' ] }
+
+##
+# @CpuPropertyValueRange:
+#
+# An inclusive range of numeric values supported for a property.
+#
+# @min: the lowest supported value.
+#
+# @max: the highest supported value.
+#
+# Since: 11.1
+##
+{ 'struct': 'CpuPropertyValueRange',
+  'data': { 'min': 'uint64', 'max': 'uint64' } }
+
+##
+# @CpuPropertyInfoBoolean:
+#
+# @supported-values: the boolean values the host supports for this
+#     property (a subset of {true, false}).
+#
+# Since: 11.1
+##
+{ 'struct': 'CpuPropertyInfoBoolean',
+  'data': { 'supported-values': ['bool'] } }
+
+##
+# @CpuPropertyInfoNumber:
+#
+# @supported-values: the set of value ranges the host supports for
+#     this property.
+#
+# Since: 11.1
+##
+{ 'struct': 'CpuPropertyInfoNumber',
+  'data': { 'supported-values': ['CpuPropertyValueRange'] } }
+
+##
+# @CpuPropertyInfo:
+#
+# Information about a single CPU model property, including the values
+# the current host supports for it.
+#
+# @name: the name of the property.
+#
+# @type: the type of the property, which selects the layout of
+#     @supported-values.
+#
+# Since: 11.1
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
+# .. note:: This command is currently only implemented on Arm (and
+#    KVM accel); all other configurations return an error.  The schema
+#    is architecture-agnostic so other targets and accelerators can
+#    implement it in the future.
+#
+# Since: 11.1
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
index 0000000000..f0301a1179
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
+    error_setg(errp, "CPU model properties are not supported on this target");
+    return NULL;
+}
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index bdf46c823a..457cc3edf3 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -81,6 +81,96 @@ static const char *cpu_model_advertised_features[] = {
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
+    /*
+     * Spin up a scratch "host" vCPU object and walk its QOM properties.
+     * This gives us the exact set we want to expose: the SYSREG_ ID-register
+     * properties and the advertised feature properties, along with their
+     * values for the host.
+     */
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
+            /* The SYSREG_ property stashes its field descriptor as opaque. */
+            const ARM64SysRegField *field = prop->opaque;
+            ArmFieldValueSet *vs = NULL;
+            CpuPropertyValueRangeList *ranges = NULL;
+
+            info = g_new0(CpuPropertyInfo, 1);
+            info->name = g_strdup(prop->name);
+            info->type = CPU_PROPERTY_TYPE_NUMBER;
+
+            arm_field_get_supported_values(field, host_isar, &vs);
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
+             * "off" is always achievable. "on" is only supported when the
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
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index dd683beaaf..d19c53927d 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -124,3 +124,10 @@ const ARMISARegisters *kvm_arm_get_host_isar(void)
 {
     return NULL;
 }
+
+void arm_field_get_supported_values(const ARM64SysRegField *field,
+                                    const ARMISARegisters *host_isar,
+                                    ArmFieldValueSet **value_set)
+{
+    g_assert_not_reached();
+}
-- 
2.52.0

