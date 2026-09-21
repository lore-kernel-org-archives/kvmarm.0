Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3608A361974
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994073; cv=fail; b=J3ugKO2OJu1Gec+VWbbxQM0040I1bG/Ins2KitClB9+/K+d9WT93vLoWrX/PgEs94p3JE18R3SIAXWxZPGW2fWwOjNInSDl/3WPuXri/u2yW3flCPc1wVowEsC96gr90HASk8U1c7mIcXadZJMx1EFgE6YBznpNfd9bLRZk9SSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994073; c=relaxed/simple;
	bh=0YG/NY8O1S0t1Tjz2ETmb7EvPg8grfixcFZ6eQU2MwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NC0xeFCokzk+56xqUEgxLPOittd6SUtsjZ8r7pQi++HfZog4AipnRwZBM1LpS70d42XBac+vyO1WHJWawczPDy1xr8NFa6OhRclFsoMFTrue+QSPM5IiXfuMeMqZu6bqX10a7qT3bbGrmKlcOww+aJnlmN0A38iflLztw9lDmrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gDi7rDsr; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YFKfQJLR; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gDi7rDsr";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YFKfQJLR"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhVsR932497;
	Mon, 21 Sep 2026 05:34:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=DuGZ+uv447Dn3AnPyvJnYlX2i9NqG0jRwhnwTlGnM
	IE=; b=gDi7rDsrUIsahiJsXHxycNt4RjDD6R29V0thJfCC1+oBSDoM6I7W0Gm2Q
	tstq90r+uFXNMs/aQ+kyAYi9utJAyYfj7fV/kNoxrFhg87r4Q4NOnLus5sbUUSjq
	y6cQwOcjUTzvZk3gR+l3I5FDM9AZSq6Guhh3tH/ikUiE75XYrYDHm6nDd2ZzibpF
	4RB0gzhIuhCAZqMOXhFwDcx0JscoJI1/VUL5uEcKbRAFrvsCChPDdCEqg/hgpKFX
	WJO62peT56BiuchBnjC7oxUDsGYvqRWDtI9GukkgYG595YKc6E1qFHkvNC5Oh2La
	wpyFabOL3NQlGWYcE4qZXLyWW0xfA==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11020141.outbound.protection.outlook.com [52.101.85.141])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gssxwkcar-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:34:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oeww7Hy0RAzOBgQgXrwsSj7k5wj9BdHIXzaecEXkNX9w8L6m20iG+Tc8SgMnAUJJ3ttT4Zm8N+6whI3Hw6YNWJatPyoAvVnNeEUjFMzwAl3YUbhg2oB6lFiKM4jYP9+8bq+SnEDRuFrjqIB922LDEBrUTd2yCjmxVh+IGLBl+v6ZwtT3IdtbNjQo7Q6JS6dLJZI/m5gWMZOCYOE5YYU7nvixwhPWevuCun8wSMEBiETAgJuTOuKSZnyfvdsLdZw4ence4MIiugyQE+7ndP0SzCVWu5YGooOso7di3SkDD2mYy/sKcXlogBE5og6VWdOsA7mQoIXPNtfpziqK/ENjiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DuGZ+uv447Dn3AnPyvJnYlX2i9NqG0jRwhnwTlGnMIE=;
 b=tcvC/0ywmXM7oWTy1CoXq/9+DBfeg+EFsMfjUlpM17j9Jv/vE3v1RzcSVnbrV6A2ZLQGH3yUdPXdWhVsvXK0u8D30k9yKLLm9Y11dYKfRNWweosyMcil4CLwIKBvxmzGUc4JENqdYShFa3oBScB+E7H7F0DxMvgPXEpOJue3skbtK9rg9jn54Nv1n/Lu7AitJzBA3WDUTAfkgI5nBgsXvgR2RfjAx2XAzDKCmv26f14On8KgfHJDQFvfncJlW2gKON3jw+7pR87T5hVNkMfU1nKQrRmtdcuJ7vUNF7HrnVdH6Sk/YWRYi9SrIRE+OVCtN2lLMEXHV1vkv1quZwiPCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DuGZ+uv447Dn3AnPyvJnYlX2i9NqG0jRwhnwTlGnMIE=;
 b=YFKfQJLRWO1+uiAiY43zmMSQ34/6ZxRKfNRXUEXf5RtKl0qQyUTUbpch5vusM2DdY3xeYDB9DCSvjGW8OPe/X+g7RbiJnDsLoOXU4sgk5NOnfKMoscWY+zmtaDRUOb4GA++CGfUW8WM/MASRM6JUIOnX7Y7moRuCLaf/8yHyaOjuszWJzAnK/CByLkSW7ViX1nkfiq4vMlpeuih0ZoEfZXfiUQWfjcv88DR3OanOd/ZrTNv4C7U+yD8iv7YqktqjeNWRMJOx5Cg9SkbUZ2sg/sLElxZhW7ZqeQgum8N7k1VJ2IjgTDB/6QsvbAX5MKw7Nr32G11zov4qr3nTQGeh7w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:32 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:32 +0000
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
Subject: [RFC PATCH v4 13/25] target/arm: add neoverse-v2-v1 named CPU model
Date: Mon, 21 Sep 2026 12:32:37 +0000
Message-ID: <20260921123249.1708067-14-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: c48bfdf8-527a-432c-407e-08df17dc8c16
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|3023799007|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	zPg8wjcM7NXCwmD2+SUBSljavFtoflKxoVDEMg/CdNkrCKbioYWhn04Mym3x5yjZZF6RZX7PpuRx/SBehyiLgMthvmK54WEjkjzKXJuxPo1G4pkkLgOzrJROIHbqD/fHZrJmFZXLFgcfNeF0qcJVfK8jxDmaUa8i5b72ntG1l4TkF0lGCPOe7wl8R3I0wLLli54k8AYvGT4a0jQsLypu/Nsvn5kpTy6LJ5xd562BgJrinja0I9gg+/Fow6KWi+vDECvgQTNUFWD0/uN2izG3ZwqwC5N8LGMJyjgg33zCUMjaNBeEkwwK/e+bNs/nzSL9qio2+LjeCLuEYeZHcCSoEoTD+CjNM2AytDzjbTHldVPDBjvUR3rR/Zyve0aujy4E05HkkOTgA7u6JIEpivVA3XqXtUMUOBUlHeSqCSSYwEWvs4QurCjDxI9X8A+5vgErmHlNqh0VYeOvWasgkv23UJCrYYII5dhOtzkgCTVvc7EoDEKV1dLQrsCMpT9ixahQcEToS7agVq2NNY8c1JDnEj+ldWiabPDeRGOnOCxbExvU82dT66ECY0hoZ/dlNWYdB/jL8x6xc+8p3FI2Q2mFtxbdrImKGD6VuDfKkHKeNQzyOQr4jutLxs2IhEC3pxq6SemtwCjSXKrghUo0kR4b7xFNx5IfcKxV1fNS/5nf/Mg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(3023799007)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QjsbNFmc50Nk+Egr71gPu8Yeu84j/mGX7D5ywcu0nayE7rUYZXkMRqob+DcL?=
 =?us-ascii?Q?b5ZYuRDvY+feZKXesv+Y7E1YrNlZODB4T7ya5MHJQ8e4n2FaPaNx+d+K0qLL?=
 =?us-ascii?Q?/j34XqYAhVWmwm7d+anBuGIYu9Raq/xrWBE9UyyxJx1jARLl7BCOlHHXMvt9?=
 =?us-ascii?Q?U/O79fWs3KIrp1pZWd5HhSDX5J/SakHTh2MAPyhW9mfql/xElbqKEB+eXZFV?=
 =?us-ascii?Q?IH/p+00A1skK3D4xUd8fxPUOP05eWqvCul5xLcxSgEJQz9JCMFNN2aZb7MEG?=
 =?us-ascii?Q?8ZWRvXZJTTOKwMfBiaAtGPBFmIWvu+tozk2PyTD+lgJYsjwVegnlY3owLe3F?=
 =?us-ascii?Q?lNQx0VmSnNmAHpwoG0zLHdZhQCHkEwldNcJlfYFfirUj9pXYsHq986zC7+sY?=
 =?us-ascii?Q?Fp7L67oTZ6i+pZeaCP9oHu+NcSKrzGzoLJQotvk6zX0NOsQL1lipp+G3etxu?=
 =?us-ascii?Q?/xNL4nOEC7GgC4PVjThSYTZNIQ+cvvMv1cwx0SiAf21MEmsDs/Uh4rnfWdWn?=
 =?us-ascii?Q?1d2IdxyAlx965Lo+d32q/8rEY8erDP7M4g5S/8K1LL29q/xpLrxL/BIlZr2H?=
 =?us-ascii?Q?KCZ4m+7mh+kh8SBfgodKCa7mWym+k1m1WxMOzr9s6ml3vw+4x8X0c1p+UjRA?=
 =?us-ascii?Q?vSIcZe5UrSehHXwQ7Va5pJTfzxrj9P7R8eYFWFW1/pzGoAFaJiJPYrzAn7CZ?=
 =?us-ascii?Q?by+RCd/Xcwsd4P9Bv76SkKFjwKJIc2wCUBFao0CAqxvXRemk9q4M92Ewim9C?=
 =?us-ascii?Q?uTgojsioOGlh0c1wkIXIx8aSf9UnrR1cWexcVKgzRpj45xKA1nr0zTB/8r42?=
 =?us-ascii?Q?ezvOLQjrCpKeMAjAUOycJqLJJSb/s44+j2qA73enm6EEV80oP4h9QjgS7QeF?=
 =?us-ascii?Q?bpYcmDPVNidQc8m6YMq1ONYahqfFkBoz3P5ZiUfmJbQK1eYNOrd0MHIl+w1G?=
 =?us-ascii?Q?iAXLvxTVXNg9bTQzQpWm2oJvzY3DVWxUXtK6fnjbbdcKr8udc+C4qTi3B8zc?=
 =?us-ascii?Q?1TiFOh4hdcgNAXtyDgekpBNaQ2e9nzzB/ZldFGZpqVwVDtUrutK816rcL4/4?=
 =?us-ascii?Q?LH3Ajk9Kf05yvGckviY02iMQOqwi/el530yTdfx13Pwu7xJF06tLKwvimpFX?=
 =?us-ascii?Q?O9IvpBxV/NjTggePVgjOVea3MJVFo3rycVcIofi63+GDRryDg3Y48Sh4vU/d?=
 =?us-ascii?Q?R863o8Z1aAAgLwkGPrSQdxdJKLsVyzvEZgVE0swVXUDZXYVoErbqLTUj2yb0?=
 =?us-ascii?Q?X7WY+WyK+GuX+jICajS2yAUGz60Av8YN7jb0frTAmkEFRRG8ohYnI+YnQH3i?=
 =?us-ascii?Q?qbFNXEuEXGu9FBPQT4lh0ZlRcf0QA9ZBEVxLW6QsErjcEJ/70iB2mW4k5pEi?=
 =?us-ascii?Q?jhFWhNX/kl62yIGgLQwUe4zVAz71f/1yuGgaN4pGLdLrFcqhPDiJSlYVA5Al?=
 =?us-ascii?Q?kQh8ZKTP7/y7zf0bQ2eUe0l00pI7KtCp2UeyQd9YAReyPHUJWAYiAwxjofXN?=
 =?us-ascii?Q?nrVV/KQ+f99RaCQZ352gIVTYwrl9OeqzefjmQzCYz9LRyQrC0UtOOAX/fwGl?=
 =?us-ascii?Q?VaF0cvyrTNbCCyXYG61WebOpVuoBz3NALdubCANuVatT//8UzkugmEWJNBxg?=
 =?us-ascii?Q?teJPHZjgISa/WF9BrKlQ86i0XKan+u36CIu1T0g9rdSyURf/HU2eYVfMBWbE?=
 =?us-ascii?Q?BLmLRfYRfnp1p3SyZ3jLYEem0y+8a9Vuu+jhKS2o9Vy6kKBsbrcZbbxz/ZTZ?=
 =?us-ascii?Q?Vmuk9TxVcyHYzjLi9ufwRZrQGTZop3w=3D?=
X-Exchange-RoutingPolicyChecked:
	tcg2k4naIhOmBfTIRpc8n/Yq4nk/esbvlfV8yoBMquzZGrIwoZ/pJ4oXBb10WFkno8CVNBgd31ghOJmklYFp8i5GEhiXf/sLfwEcOJlGnBEviq2AwCA8Ey0n+xneGRE8ZV37sl1+H9T0Xh8YLrK0VESjMnVrgJ+HIvuuHL43pDQIoRdUfhLenvptilGneCdmL6K1vt5YbqoOu5EliF7ruhzf6UCKI2jyCrkw3+QYhgOMgNt6GIqP0PX2nuh2ATuTpns038YihzdUxMWLeFcqJv823+zEXbPhWcEkxL+/+DYAGdUxoI05WXDsNREZSiqjRPLt8Pf5ikpltmg7cicikw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48bfdf8-527a-432c-407e-08df17dc8c16
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:32.1468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEiRJD90XvDAsVA2QEy4gA4pTjJxr579RNjxzLnT89AxCc+2dm035NRZpQppOJ1rqoJiUhQOT5u5woIAlxmrZjBCqgr7b2q38zgDiO5MnB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX12GGalSbP0yQ
 vczFyvTEy7Wsgy8Ap+zy4j62th3e8rILGUJB/PlQyvv+RoUPZ8C02Lc0AvVMGvZyUngJYz4ihGH
 Sd17Q+5131AgHaHlFqKdrt/28J0czaY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXx9Oxc+GdOc7d
 e4dbgxWz4JiOcZLQSPIXLvAcndkY5a+d0G+G0BkR2dkuaxS3HDBLAnSitx8l1qsfF05tN8c9p8g
 RZjMjtvQOKS3ZziBDh2I/OIE5IV5FaQiY98f9dRF9blMEou/ROD2+mKlttvhO1F8GFBsvQ7occR
 13LRNVFDdDBkbb7gBA6RbTH2NAZhzfKBl2J4U7Lk7r0CpxJ970ZXVuk30UwuFlenF4BybntmCyL
 7iyUb/zQYC4yv33EXqvCZoZN+drgO9r0NwhAwU1fI1g6poH4bVAZ/QSEhyp0tkERsVqhHtJ8r9c
 OYtZ8utxrx52+5vMGFs/EF+v1DAx13tKkfOONloLijyisENDz6g9Whbso/D1PGakj+tFXCwriWn
 JEH7UK/FSzPcwyK+wtP4IbSiNeQgvU5oNBJwbLQ0U7vrtdR2BGH0FQQ6cLeCRPigranbCITFzpI
 pEC/MrMhoVLN/uCsBVA==
X-Proofpoint-ORIG-GUID: ZTXj8BrASxULHb5UWyyUAYoF0opme4pU
X-Proofpoint-GUID: ZTXj8BrASxULHb5UWyyUAYoF0opme4pU
X-Authority-Analysis: v=2.4 cv=fphJ914f c=1 sm=1 tr=0 ts=6ab12446 cx=c_pps
 a=g/OBtAqTw1pRpVLcEUWRsQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=4bRBiY6PqUU1wEVE5PwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add a KVM-only named CPU model for Neoverse V2 (TRM 102375, r0p0),
inheriting from arm-v9.0-a-v1. The property list is the subset of the
TRM that KVM can virtualize for a non-nested guest.

EL2, EL3, and SEL2 are left unimplemented. AMU, MPAM, SPE, TRF, and
similar features are omitted because KVM does not virtualize them. SoC
crypto opt-ins
are left unimplemented. PMU stays disabled for named models.

Some fields that a non-EL2 guest does not use (VH, EVT, S2FWB, E2H0) are
still pinned to the TRM value because KVM does not allow userspace to
lower them.

Final ID register state requested from KVM for "neoverse-v2-v1":
[  0] AIDR_EL1                 = 0x0000000000000000
[  1] CLIDR_EL1                = 0x0000000000000000
[  2] CTR_EL0                  = 0x000000009444c004
[  3] DCZID_EL0                = 0x0000000000000004
[  4] GMID_EL1                 = 0x0000000000000000
[  5] ID_AA64AFR0_EL1          = 0x0000000000000000
[  6] ID_AA64AFR1_EL1          = 0x0000000000000000
[  7] ID_AA64DFR0_EL1          = 0x000000f010305009
[  8] ID_AA64DFR1_EL1          = 0x0000000000000000
[  9] ID_AA64DFR2_EL1          = 0x0000000000000000
[ 10] ID_AA64FPFR0_EL1         = 0x0000000000000000
[ 11] ID_AA64ISAR0_EL1         = 0x0221100010210000
[ 12] ID_AA64ISAR1_EL1         = 0x0011111101211052
[ 13] ID_AA64ISAR2_EL1         = 0x0000000000000000
[ 14] ID_AA64ISAR3_EL1         = 0x0000000000000000
[ 15] ID_AA64MMFR0_EL1         = 0x0000011100101125
[ 16] ID_AA64MMFR1_EL1         = 0x0000000010312122
[ 17] ID_AA64MMFR2_EL1         = 0x1221011110001011
[ 18] ID_AA64MMFR3_EL1         = 0x0000000000000000
[ 19] ID_AA64MMFR4_EL1         = 0x0000000000000000
[ 20] ID_AA64PFR0_EL1          = 0x1101000120110011
[ 21] ID_AA64PFR1_EL1          = 0x0000000000000021
[ 22] ID_AA64PFR2_EL1          = 0x0000000000000000
[ 23] ID_AA64SMFR0_EL1         = 0x0000000000000000
[ 24] ID_AA64ZFR0_EL1          = 0x0000100000110001
[ 25] ID_AFR0_EL1              = 0x0000000000000000
[ 26] ID_DFR0_EL1              = 0x0000000000000000
[ 27] ID_DFR1_EL1              = 0x0000000000000000
[ 28] ID_ISAR0_EL1             = 0x0000000000000000
[ 29] ID_ISAR1_EL1             = 0x0000000000000000
[ 30] ID_ISAR2_EL1             = 0x0000000000000000
[ 31] ID_ISAR3_EL1             = 0x0000000000000000
[ 32] ID_ISAR4_EL1             = 0x0000000000000000
[ 33] ID_ISAR5_EL1             = 0x0000000000000000
[ 34] ID_ISAR6_EL1             = 0x0000000000000000
[ 35] ID_MMFR0_EL1             = 0x0000000000000000
[ 36] ID_MMFR1_EL1             = 0x0000000000000000
[ 37] ID_MMFR2_EL1             = 0x0000000000000000
[ 38] ID_MMFR3_EL1             = 0x0000000000000000
[ 39] ID_MMFR4_EL1             = 0x0000000000000000
[ 40] ID_MMFR5_EL1             = 0x0000000000000000
[ 41] ID_PFR0_EL1              = 0x0000000000000000
[ 42] ID_PFR1_EL1              = 0x0000000000000000
[ 43] ID_PFR2_EL1              = 0x0000000000000000
[ 44] MIDR_EL1                 = 0x00000000410fd4f0
[ 45] MPIDR_EL1                = 0x0000000080000000
[ 46] MVFR0_EL1                = 0x0000000000000000
[ 47] MVFR1_EL1                = 0x0000000000000000
[ 48] MVFR2_EL1                = 0x0000000000000000
[ 49] REVIDR_EL1               = 0x0000000000000000
[ 50] SMIDR_EL1                = 0x0000000000000000

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c           |   1 +
 target/arm/cpu-models.c | 100 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 01381ab5e7..f5a8ea1145 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4146,6 +4146,7 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
     }
     if (kvm_enabled() && target_aarch64()) {
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9.0-a-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
     }
     if (target_aarch64()) {
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a53")));
diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index 7394dd358e..2de67f353b 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -13,6 +13,9 @@
  * Assumptions:
  *     - All named CPU model properties are idempotent.
  *
+ * Current Hierarchy:
+ * arm-v9.0-a-v1
+ *   neoverse-v2-v1 (r0p0)
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
@@ -113,8 +116,105 @@ static const ArmModelPropValue arm_v9_0_a_v1_props[] = {
     MODEL_PROP_END,
 };
 
+/* Neoverse V2 CPU model (TRM 102375, r0p0), inherits from arm-v9.0-a-v1. */
+static const ArmModelPropValue neoverse_v2_v1_props[] = {
+    /* MIDR_EL1 */
+    MODEL_PROP("SYSREG_MIDR_EL1_Implementer", NUM, 0x41), /* ARM */
+    MODEL_PROP("SYSREG_MIDR_EL1_Variant", NUM, 0x0), /* r0p0*/
+    MODEL_PROP("SYSREG_MIDR_EL1_Architecture", NUM, 0xF),
+    MODEL_PROP("SYSREG_MIDR_EL1_Revision", NUM, 0x0), /* r0p0 */
+    MODEL_PROP("SYSREG_MIDR_EL1_PartNum", NUM, 0xD4F), /* Neoverse V2 */
+
+    /* ID_AA64PFR0_EL1 */
+    /* Neoverse V2 implements CSV2.2 but CSV2 is capped to 1.0 by KVM */
+    /* AMU and MPAM are not supported by KVM */
+    /* SEL2 is left not implemented for non-virtualized VM */
+    /* EL2 and EL3 are not implemented for non-virtualized VM */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_SVE", NUM, 1), /* FEAT_SVE */
+    MODEL_PROP("sve128", BOOL, true),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 2), /* override; FEAT_RASv1p1 */
+
+    /* ID_AA64PFR1_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_SSBS", NUM, 2), /* FEAT_SSBS2 */
+
+    /* ID_AA64ZFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_I8MM", NUM, 1), /* FEAT_I8MM */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_BF16", NUM, 1), /* FEAT_BF16 */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_BitPerm", NUM, 1), /* FEAT_SVE_BitPerm */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_SVEver", NUM, 1), /* FEAT_SVE2 */
+    /* Other ID_AA64ZFR0_EL1 fields are SoC opt-ins */
+
+    /* ID_AA64DFR0_EL1 */
+    /* KVM does not virtualize FEAT_TRBE, FEAT_TRF, or FEAT_SPE. */
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_CTX_CMPs", NUM, 1), /* 2 context-aware BPs */
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_WRPs", NUM, 3), /* 4 watchpoints */
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_BRPs", NUM, 5), /* 6 breakpoints */
+
+    /* ID_AA64ISAR0_EL1 */
+    /* Many fields are SoC opt-ins; no mandatory overrides from Armv9.0-a-v1 */
+
+    /* ID_AA64ISAR1_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_I8MM", NUM, 1), /* FEAT_I8MM */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DGH", NUM, 1), /* FEAT_DGH */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_BF16", NUM, 1), /* FEAT_BF16 */
+    /* FEAT_PAuth2, QARMA5 is implemented */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_GPA", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_APA", NUM, 5),
+
+    /* ID_AA64MMFR0_EL1 */
+    /* Keep stage-2 translations unimplemented for non-virtualized guests */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0), /* supported */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16", NUM, 1), /* supported */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_SNSMem", NUM, 1), /* supported */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_BigEnd", NUM, 1), /* supported */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_ASIDBits", NUM, 2), /* 16 bits ASID */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_PARange", NUM, 5), /* 48 bits PA Range */
+
+    /* ID_AA64MMFR1_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_XNX", NUM, 1), /* FEAT_XNX */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_PAN", NUM, 3), /* override; FEAT_PAN3 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VMIDBits", NUM, 2), /* 16 bits */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HAFDBS", NUM, 2), /* FEAT_HAFDBS */
+    /*
+     * VHE is not needed for non-virtualized guests, but KVM does not
+     * support writing to it.
+     */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VH", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 2), /* override; FEAT_HPDS */
+
+    /* ID_AA64MMFR2_EL1 */
+    /*
+     * FEAT_EVT, FEAT_S2FWB not needed for non-virtualized guests, but KVM
+     * does not support writing to them.
+     */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_EVT", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_BBM", NUM, 2), /* FEAT_BBM2 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_FWB", NUM, 1), /* FEAT_S2FWB */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_ST", NUM, 1), /* FEAT_TTST */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_IESB", NUM, 1), /* FEAT_IESB */
+    /* FEAT_CCIDX not virtualized by KVM */
+    /* FEAT_NV not presented for non-virtualized guests */
+
+    /* ID_AA64MMFR4_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0), /* override; FEAT_E2H0 */
+
+    /* CTR_EL0 */
+    MODEL_PROP("SYSREG_CTR_EL0_IDC", NUM, 1),
+    MODEL_PROP("SYSREG_CTR_EL0_CWG", NUM, 4), /* Cache-writeback granule */
+    MODEL_PROP("SYSREG_CTR_EL0_ERG", NUM, 4),
+    MODEL_PROP("SYSREG_CTR_EL0_DminLine", NUM, 4), /* 64 bytes */
+    MODEL_PROP("SYSREG_CTR_EL0_IminLine", NUM, 4), /* 64 bytes */
+    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 3), /* PIPT */
+
+    /* DCZID_EL0 */
+    MODEL_PROP("SYSREG_DCZID_EL0_BS", NUM, 4), /* 64 bytes */
+
+    MODEL_PROP_END
+};
+
 static const ArmNamedCpuModel arm_cpu_models[] = {
     {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
+    {"neoverse-v2-v1", "arm-v9.0-a-v1", neoverse_v2_v1_props},
     {NULL, NULL, NULL}
 };
 
-- 
2.52.0

