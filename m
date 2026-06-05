Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124734B8DE5
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650414; cv=fail; b=duyfvE9m5QwfO3MqMlW70ut7x3fiXpINCZO9YS7MeIIOFIMiQcST1hM8sIk5fMrTR3faeeg4SYi2yRu5/bDfImQesWmQf/TD5GWc/CJ4P0kZFqYI2VZgrpLirHv+yvzuIf8CNe75+HG9vznNs9ohCYuj0t0OKDp8rUgk9GjvMMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650414; c=relaxed/simple;
	bh=Uzq6bk6hmfAwvWRGN2uWp14dyZgIheoXG2tMC1pn91Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qRklbH1RyfVOuuIRnXDr4ZRUhlQhR3Hay0mYCbiYaCSzXmWpe9hseAl7Ue9k3ZX/FAgSPdfcIOz9eS6aXkh/zj8osKBgO5+2rCOLigSM0TKuYuCzeTAIaDzgb+kEdms9fNAQ2eLgkWN1z4GB9B0037P3uUiw+l/zYd5Yrjj9+ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=USw6iNR7; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YzlM3ZOn; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="USw6iNR7";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YzlM3ZOn"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUO1185382;
	Fri, 5 Jun 2026 01:43:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=gNR/6epo3PyDlZabmc6pINGdg7KibeOvbDv9pbwnM
	7Q=; b=USw6iNR7L+3rnnlWajMEocmt1CVl4htdoFCnA3o5+pgacAf8aWFesiMon
	DwBjXGiUruG7iLC7Y8BkmHJDmTOmni8/o8DpQAum/oFEiVlWuVX4zSQ3C24FxSzS
	L9rWr8alBw70yN1x8nC1jfY8g/dqdmy4I+o+AVk9GZATjK4osLeSUhSs0D3Wxa8w
	rp9C+6RwMJWogJJszGpqCe6YLyyl3HdlCtT74Qf45gfWkSjPJqhl0PoJOt7w6VDU
	e40bwZ3RdeDlGOpjNAmUuiadoJoKcsLf96zYulbQPgxjr0buNKjdgzDQE3o+OqtL
	j7Zjsoy0M8hCqlQfcI7/mxASvvrUg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-9
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QAlVeF+BefUcYZrW3GV7l3Ey4+eJLBp8IRwcu5iRrEOh7sQDHOoc8quWPPEAG+LgEFL1KH9Uen/JEM86kP9VQx5rV0dalQFdHgbQ/IvyCpJOs4AeHMQWW+ac+Us1wU1ekRNiIOXzy3/wbq0Vtx8kXrpI49AECRqhM/wVT77fWoyrOmFsxqB+7n2EPInOO/tzqPCvLuKUZnP8RkEbbb1vSzTqvwJ/20gVOoB3Q5NEsi2G9LyI4tUtMCzg1AVpzOMYjyHY4FiE2KuKY+d6xs3LlB6Fc83sYsfthYRMLUzywXHDivmycOa8BuLgQotWDvggU3b7eP99ruM+inNKiJdI5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNR/6epo3PyDlZabmc6pINGdg7KibeOvbDv9pbwnM7Q=;
 b=YJalts+hx4RNntYL2+R9jF18IzkKEGusVZbgdBhYH4vGjhwNjVtnSC2LEJVM++69WPvIvzej2G1/OFSktIyMUp81/exWwpQEgBMCutGqqt3vGbRjkvQm1L9s9RkXZi2dohBr6Cfe0n15v2k/8lwWtuZ7B5czDNOSnOQ7AnGmvn1DLRTox0wOMDmmeX8OghfpxnaXnbRi5N30BBEeq4B0gTWA95LxwYWPhskSKmItD1JcDiawlk/uu196va+C6Ga0VnGnbWNSK6wCd55KUGG2S+9P/NZgJyeKP9AmXlzk43SRxlXHYu0K8n5F7LdpIz0v9USIQ5wyKfufAtd6OSjMaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNR/6epo3PyDlZabmc6pINGdg7KibeOvbDv9pbwnM7Q=;
 b=YzlM3ZOnShViQITiUzrX3TQ+ogMYDRTwjOwHoBe5HGyBefAlzHQa9/0myHFSuhDHSPTJmQbiaw3bZ/ikYC95529NSGFrMAPMn0LBC/2cMAJB6i/q7J9h97AVb7gdjXVil1ImGrwne8lNLdJE2SokQdSuQlp91shXk+uzryou1NEI1EeSZ9AU3FDCea8mTRDfOvVDdbUjGKAvCW9cFpASa7wuLjopIXRGPz4Dv+fmYLb7MsRK4mLsvzIGXxXXi+UgVo9A2ikU5a5XjntvLikDctC10a95m/yhSx4erZ9NfENHlHIlxV318nUJcUiRdTEp6pyoX5GPT4wD+nMflENtjQ==
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
Subject: [RFC PATCH v2 26/29] target/arm: Support exposing cache information for named cpu models
Date: Fri,  5 Jun 2026 08:33:55 +0000
Message-ID: <20260605083358.1320563-27-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 262301b9-aff5-4720-0708-08dec2de7e0c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|6133799003|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JCRlAWMBgOYlVVovFfp1GdeKa5tzOIAvyWaZXxlhViH//CK0myEMBhv74GnSK8SZrN9QdLXwqJ92D8TtxqH+cIrL+Fz5XaB22YPJf4ghTbM5fh4U5/I5bbNIGO+ixLQmct/L76iW8wv7y9f53ERt9efpDGnESEMpkfHj5zpoIRfWN5ZDmamoaW07En6VqZOJDCNSaw6nzqMhBN5zNo7SbpDr7D/hXZAm/Y1wpeq/N/i3adqSI/7Gs4lNGBepn9ZXr9vbyZpkRbYQDZYd80HgZCW7CZs1HQLAIKPXHLmPYmpdXd0dhKFDNkmV6F9pBIwMy2AX313SFexjPXaUAcaZBIiwUsu5dv6JgE+XjCAUjZuhU/a17/itb38f4MhW06R6BSiu1A8Ljc8rqTsBckFqiZDLYSb3//N5DNUKRhllIOZREwPaenqBtOUoBhaiFGsOHAlNGMzxbGRvR8YUccB5TTnkN1xMueKwi8UhrJ2pQFFIgXMJy8wWqoYMBMrz/N/RbI2szgJd6WGMflwVnTjo8EdDmJQGlJxsVpJ8pw51Q6fRlKDhhKC6jHN4q9TWWHYBYn/i6Nrv+ISIucGkmqBl8ko9Unl2JhMVByvzrIl1b3im+UEC05uxKHbukFbSm68EeCgxWSsGMpcIQ6Ukn7ifTLKDOv3PhaurgRRHLcMpg/zNJfxuCj09RYJXlbqfNOw1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(6133799003)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uTg0WLCMYaiePFec7to0b+5vJ/D5P7JN5Knh9or1Y820hGlzYEMoIS5GSiAt?=
 =?us-ascii?Q?t1YFxOPQB0KZ4BolNhQ8YWNmUEOMGgodYu2p/RZARst8G/Fuvn8unz9IWGoT?=
 =?us-ascii?Q?yYdRWudz9fiYlP9EtaZBTkjq2SkjREPchWXIkdkbUjS0KIBaiGq7Wz5Uk47A?=
 =?us-ascii?Q?J2MnCzr13x1w9dkhNuC8JvNaIcQKH+G9cCivR/fdDt5A4OEGbCAo8qlM5k1m?=
 =?us-ascii?Q?4EuDNFxBu6lEy+nVoItL+kHSaj5lkCZoLRALdOZ/eF9dIMuFXHQzveCJiBYM?=
 =?us-ascii?Q?XE88Xy6R/v7QMnWO9V0TiJuDm9xtQjIO+Fe1sKEAekUwK83lOyRnn6iGxu2U?=
 =?us-ascii?Q?X2hiChuChOXaNMVi4dlvvJtbTDYMq4IIf4VNF4a6TqPfSChAPnEWCYfgHV99?=
 =?us-ascii?Q?bYRuqht56suxekXsqXK+ADnxRqb3rXMREnPw0P6UloafQEVIZ1rh6Q5VMeV9?=
 =?us-ascii?Q?UyF6/CZvR7MBoFf6m5JNbi+8cgZiZbkHoHzJhO/aK7SuVAgLbh+ftlaf3AMO?=
 =?us-ascii?Q?dGRJstW8WcrHJ8CReyoKhfHQ2aOb/ffy6UmXKmKBrN7ZzuvbZO7xBWG/lL1o?=
 =?us-ascii?Q?+EFB0V43KSnNaNwxAT6dRwPIzC6ZKXTRjx9tsXD7fJwHcEJyTnwzDreMYp7H?=
 =?us-ascii?Q?9kdBmpOs7HltHokLgGK/fYEUNG/oR/ubtl4DyQgAcE4u73gyhLdT6CUD/Kdt?=
 =?us-ascii?Q?MU/7W/FIarwDL+YEtIfC+rlVnBn7/htxsJHxMw/CAVFY5D8M6BelQutZCRMM?=
 =?us-ascii?Q?dZkvlC8vyoHrxW52v/Na4S1WX6nu//eZA8ZhjwRIyYkHvwhNZtg22HLpjBBq?=
 =?us-ascii?Q?rQPCkIyEklXUvXpE7kJCzHfS6kr9WIBBMHscGYZDCgpEvkry31w3AukN9vC1?=
 =?us-ascii?Q?iWOVnxmHlRF0Exy5dPiyRAXSLBwgBml/C1pxciyeuVFxEte8cvRU/YMTkLcl?=
 =?us-ascii?Q?UGF885BJ8nK28/JfcTxhfWqJTdwus+VJ28qxyeKAsub+xqLC2Oi+O0p1oe7n?=
 =?us-ascii?Q?cQ0UQIOIx/jTV9JTGKXUGagkXtSgzcFm3NVFvLcb2jrBnuMfUxAjOCCIF9mQ?=
 =?us-ascii?Q?/uNZilV/P/CcTB15gT010UE/ArcRq+pdORCxELTOE+QQt/lSfhDYeJw5a0eF?=
 =?us-ascii?Q?w3intNR13l4vRLFr9EliOqqx8WBBACqrMFh500z5BZFK8IGqTzxg0TJaoY87?=
 =?us-ascii?Q?dwvio8GDYLMbmQ8VRtlP/J9D29SRW7uyA72I6w8cx6x9zI9NuooUIefGj69G?=
 =?us-ascii?Q?81VZ51MjuVXN1yqnBpHpi1K7x/Rus1RWldmSRbG/qwMXb7HuxG2E2nk4STdp?=
 =?us-ascii?Q?+8N0MLQYuCmaRN41h+rBsNyGR6dxQbBhj5Ozha0sP2LuaSJQUDcF1aESrzeV?=
 =?us-ascii?Q?+kRTeZ7rPFOpHdHRj9VQqkgv/OILLa8S7PcUfHLKxXEadhykBzbmnurlHckg?=
 =?us-ascii?Q?u73KWMW7Yw1SikTzW4hzHNgbZs+2a1tz/aKqM3CP/tOpStWM8wzSjOdMQ7P6?=
 =?us-ascii?Q?DU5kx8movBmx2Zr5k7qYfbb5tCo0QtMSNfX+BaqAsWGXJhQflDFr+r+7lRE2?=
 =?us-ascii?Q?LvXQo/y2JJWOlwUyo1J4OU06apmU6GUFQAWmvbgbqTSVdiVgp/u2lW4QT9sz?=
 =?us-ascii?Q?y5FRGRRInMiwM8cw3t9mKeISA1pO3GnUsUl8ywQJO6nn7tm0bwXI02trBjGc?=
 =?us-ascii?Q?kVLlqc/uC3DoMeujc+6SefGSaA1aLdIvmQfhgmr5wgmiy3oGwdoOtt5l1RPl?=
 =?us-ascii?Q?K67oBNuazaEbDCnH0+3Lqj8YBUeeDHA=3D?=
X-Exchange-RoutingPolicyChecked:
	gO7lZQXWhtFfaDg4RYbgXyS/8ro/u72BjCrDHMw0ZlDE9Cyq3vnzDfdZ9dAT8RRwS74I0P+RlVsDNKUybUgtDV3+r9e8oQWGhDbpb70I+HiaGTAo8tXN7vgD/g6QQsNKqBE/VEIHSv3hzbym6bPl5iu86x08u0cA0CeMakuJk6UMCvIow8V0P/S0hzpDSiF6PVLVXM96Ecs7SGPcsT519e94hEHkWMWGg2SKhnncyrXj7bD1XbW3ZfnbAxClx0xxJFcC2c0RQGw2PfZmYn8hWrf3mvZzNYwfOoIrui3aXH07b1mdDywmewY/ZrXTDydfK31qBWWPsSsJT+OPaHaaRg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262301b9-aff5-4720-0708-08dec2de7e0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:18.7712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zb0yozI31z9lX1bjocAdpMGgpIeESQNUu/7adBs4Uomc2Nd5c8TriZm3k9wcKUNP9zu6EoZ2BcUOoYHEC8UeZqOenxVn4Sk8xisuMpSV2Ls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX4rf+LbykJs50
 +QJr19AcPbwOpKHgHsutv/8IJAtPD3U3zORiwOhDW8JnhruVMgQjFCFQQJvSRByxsgeQY+Nu3WS
 du4mbgL5H/SzZn6fE8yzS/hxMBqVAvdCCxAxhWYCgaacsCIXKNlJ6ash1Y09DKMSzoTHzWqzTg0
 nWmbSiXlT2LfsrFaAE4gCH+OWUsEclHpmbYN1D2cfY6nPweDCCZhDFoje6TFd3IAmsCMc5s67ur
 ChtzmBCZpJqi32aQpFcPHV2R8/zQ5glosUd/DSQUGx1JpSOe/LMqDnLPhLB1FXN5L4DeGZGzuXV
 Vwm/BRFCah0YDhUIt5GI1VAFysHys5tUesuUwIY2R4B0dLRRiIzgOMCnjljI8iztXVUdd/hqJ3A
 1VzkRl5RbCUJCbQUmVLdPRnPuu6VkS6u2sxYyl4f0OvCQclcGNlSaE2B4O96CQHNSEx8u+LE/+L
 trr9ajGs1vfrzS+aSCA==
X-Proofpoint-ORIG-GUID: p0OgSxxZW5nX78PS_CA2-Mih0ezEQt7h
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c2f cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=wgdFg7zr4kieyXFYgvoA:9
X-Proofpoint-GUID: p0OgSxxZW5nX78PS_CA2-Mih0ezEQt7h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce "expose-cache" with newly introduced cache sub-props like
the per level (type, sets, linesize, associativity) and cache attributes
(louis, loc, louu, icb_type, ttypen). Back "expose-cache" by
ARMCPU::cache_exposed.

Add kvm_arm_writeback_ccsidr(), which writesback demux ccsidr values
into cpregs. Which is then written back to KVM.

Additionally, the same cache topology is exposed to the guest through
PPTT/DT cache nodes in virt.c, gated by the expose-cache boolean.

To support this on infra side:
  - Introduce a new prop type ARM_PROP_CUSTOM which mandates custom
    getter/setter and reset for a prop. Required for properties backed
    by CCSIDR bank
  - Add CLIDR_EL1 to cpu-idregs.h.inc. As it is not a part of kernel's
    sysreg file, safe-rules are populated with ANY.
  - Remove FIELD() entries for CLIDR_EL1.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c               |  20 ++-
 target/arm/arm-cpu-props.c  | 272 +++++++++++++++++++++++++++++++++++-
 target/arm/arm-cpu-props.h  |   5 +-
 target/arm/arm-qmp-cmds.c   |   1 +
 target/arm/cpu-features.h   |  11 --
 target/arm/cpu-idregs.h     |   1 +
 target/arm/cpu-idregs.h.inc |  91 ++++++++++++
 target/arm/cpu.h            |   3 +
 target/arm/kvm.c            |  54 +++++++
 9 files changed, 440 insertions(+), 18 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 117033115d..eeb7a6faff 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -337,6 +337,16 @@ unsigned int virt_get_caches(const VirtMachineState *vms, CPUCoreCaches *caches)
     ARMISARegisters *isar = &armcpu->isar;
     uint32_t clidr = GET_IDREG(isar, CLIDR);
 
+    /*
+     * under KVM only expose caches when cache_exposed is true.
+     * Without cache_exposed, default view of KVM is in CLIDR_EL1:
+     * 1 line, 1 set, 1 way level 1 unified cache. skip setting up
+     * caches in this case.
+     */
+    if (kvm_enabled() && !armcpu->cache_exposed) {
+        return 0;
+    }
+
     for (int cache_level = 1; cache_level <= CLIDR_CTYPE_MAX_CACHE_LEVEL;
          cache_level++) {
         uint8_t ctype =
@@ -654,9 +664,9 @@ static void fdt_add_cpu_nodes(VirtMachineState *vms)
     bool cache_created = false;
     bool cache_at_topo_level;
 
-    num_cache = virt_get_caches(vms, caches);
+    num_cache = virt_get_caches(vms, caches); /* 0 if caches are not exposed */
 
-    if (mc->smp_props.has_caches &&
+    if (num_cache > 0  && mc->smp_props.has_caches &&
         partial_cache_description(ms, num_cache)) {
         error_setg(&error_fatal, "Missing cache description");
         return;
@@ -758,7 +768,7 @@ static void fdt_add_cpu_nodes(VirtMachineState *vms)
             /* This assumes socket as the highest topological level. */
             socket_offset = 0;
             cluster_offset = 0;
-            cache_at_topo_level =
+            cache_at_topo_level = (num_cache > 0) &&
                 machine_find_lowest_level_cache_at_topo_level(ms,
                     &bottom_node,
                     CPU_TOPOLOGY_LEVEL_SOCKET);
@@ -793,7 +803,7 @@ static void fdt_add_cpu_nodes(VirtMachineState *vms)
             bottom_cluster = top_cluster;
             cluster_offset = socket_offset;
             core_offset = 0;
-            cache_at_topo_level =
+            cache_at_topo_level = (num_cache > 0) &&
                 machine_find_lowest_level_cache_at_topo_level(ms,
                     &bottom_cluster,
                     CPU_TOPOLOGY_LEVEL_CLUSTER);
@@ -828,7 +838,7 @@ static void fdt_add_cpu_nodes(VirtMachineState *vms)
         if (core_id != last_core) {
             bottom_core = top_core;
             core_offset = cluster_offset;
-            cache_at_topo_level =
+            cache_at_topo_level = (num_cache > 0) &&
                 machine_find_lowest_level_cache_at_topo_level(ms,
                     &bottom_core,
                     CPU_TOPOLOGY_LEVEL_CORE);
diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index dab7786622..44f21de1c5 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -12,6 +12,7 @@
 #include "qemu/typedefs.h"
 #include "qom/object.h"
 #include "cpu.h"
+#include "cpu-features.h"
 #include "arm-cpu-props.h"
 #include "cpu-idregs.h"
 #include "arm-cpu-models.h"
@@ -53,6 +54,13 @@
       .get = _get,                                                       \
       .set = _set }
 
+#define ARM_CUSTOM_PROP(prop_name, _custom_type, _get, _set, _reset)     \
+    { .name = (prop_name), .type = ARM_PROP_CUSTOM,                      \
+      .u.custom_type = (_custom_type),                                   \
+      .get = _get,                                                       \
+      .set = _set,                                                       \
+      .reset = _reset }
+
 static void arm_composite_set_internal(ARMCPU *cpu,
                                        const ArmCpuPropDesc *p,
                                        bool val,
@@ -77,6 +85,139 @@ static void pauth_set(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
     cpu->prop_pauth = val;
 }
 
+/*
+ * Bank index in cpu->ccsidr[]: (level - 1) * 2 | InD.
+ */
+#define CACHE_BANK(level, is_icache) (((level) - 1) * 2 | !!(is_icache))
+
+/*
+ * CCSIDR_EL1 field accessors. The legacy and CCIDX encodings live at
+ * different bit positions; KVM forces legacy encodings, so use that.
+ */
+static void ccsidr_sets_get(ARMCPU *cpu, int level, bool is_icache,
+                            Visitor *v, const char *name, Error **errp)
+{
+    uint64_t r = cpu->ccsidr[CACHE_BANK(level, is_icache)];
+    uint64_t val = FIELD_EX64(r, CCSIDR_EL1, NUMSETS) + 1;
+
+    if (val == 1) {
+        val = 0;
+    }
+
+    visit_type_uint64(v, name, &val, errp);
+}
+
+static void ccsidr_sets_set(ARMCPU *cpu, int level, bool is_icache,
+                            Visitor *v, const char *name, Error **errp)
+{
+    uint64_t val;
+    uint64_t *r;
+
+    if (!visit_type_uint64(v, name, &val, errp)) {
+        return;
+    }
+    r = &cpu->ccsidr[CACHE_BANK(level, is_icache)];
+
+    assert(val > 0);
+
+    *r = FIELD_DP64(*r, CCSIDR_EL1, NUMSETS, val - 1);
+}
+
+static void ccsidr_associativity_get(ARMCPU *cpu, int level, bool is_icache,
+                                     Visitor *v, const char *name,
+                                     Error **errp)
+{
+    uint64_t r = cpu->ccsidr[CACHE_BANK(level, is_icache)];
+    uint64_t val = FIELD_EX64(r, CCSIDR_EL1, ASSOCIATIVITY) + 1;
+
+    visit_type_uint64(v, name, &val, errp);
+}
+
+static void ccsidr_associativity_set(ARMCPU *cpu, int level, bool is_icache,
+                                     Visitor *v, const char *name,
+                                     Error **errp)
+{
+    uint64_t val;
+    uint64_t *r;
+
+    if (!visit_type_uint64(v, name, &val, errp)) {
+        return;
+    }
+    r = &cpu->ccsidr[CACHE_BANK(level, is_icache)];
+
+    assert(val > 0);
+
+    *r = FIELD_DP64(*r, CCSIDR_EL1, ASSOCIATIVITY, val - 1);
+}
+
+static void ccsidr_linesize_get(ARMCPU *cpu, int level, bool is_icache,
+                                Visitor *v, const char *name, Error **errp)
+{
+    uint64_t r = cpu->ccsidr[CACHE_BANK(level, is_icache)];
+    uint64_t enc = FIELD_EX64(r, CCSIDR_EL1, LINESIZE);
+    uint64_t val = 1ULL << (enc + 4);
+    visit_type_uint64(v, name, &val, errp);
+}
+
+static void ccsidr_linesize_set(ARMCPU *cpu, int level, bool is_icache,
+                                Visitor *v, const char *name, Error **errp)
+{
+    uint64_t val;
+    uint64_t enc;
+    uint64_t *r;
+
+    if (!visit_type_uint64(v, name, &val, errp)) {
+        return;
+    }
+    /* Linesize is encoded as log2(bytes) - 4. */
+    enc = ctz64(val) - 4;
+    r = &cpu->ccsidr[CACHE_BANK(level, is_icache)];
+    *r = FIELD_DP64(*r, CCSIDR_EL1, LINESIZE, enc);
+}
+
+static void ccsidr_sets_reset(ARMCPU *cpu, int level, bool is_icache)
+{
+    uint64_t *r = &cpu->ccsidr[CACHE_BANK(level, is_icache)];
+    *r = FIELD_DP64(*r, CCSIDR_EL1, NUMSETS, 0);
+}
+
+static void ccsidr_associativity_reset(ARMCPU *cpu, int level, bool is_icache)
+{
+    uint64_t *r = &cpu->ccsidr[CACHE_BANK(level, is_icache)];
+    *r = FIELD_DP64(*r, CCSIDR_EL1, ASSOCIATIVITY, 0);
+}
+
+static void ccsidr_linesize_reset(ARMCPU *cpu, int level, bool is_icache)
+{
+    uint64_t *r = &cpu->ccsidr[CACHE_BANK(level, is_icache)];
+    *r = FIELD_DP64(*r, CCSIDR_EL1, LINESIZE, 0);
+}
+
+/*
+ * Generate the per-prop  ccsidr_*_{get,set,reset}.
+ */
+#define CACHE_PROP_FNS(NAME, LVL, IC, FIELD)                                \
+    static void cache_##NAME##_##FIELD##_get(ARMCPU *cpu, Visitor *v,       \
+                                             const char *name, Error **errp)\
+    { ccsidr_##FIELD##_get(cpu, (LVL), (IC), v, name, errp); }              \
+    static void cache_##NAME##_##FIELD##_set(ARMCPU *cpu, Visitor *v,       \
+                                             const char *name, Error **errp)\
+    { ccsidr_##FIELD##_set(cpu, (LVL), (IC), v, name, errp); }              \
+    static void cache_##NAME##_##FIELD##_reset(ARMCPU *cpu,                 \
+                                               const char *name,            \
+                                               Error **errp)                \
+    { ccsidr_##FIELD##_reset(cpu, (LVL), (IC)); }
+
+#define CACHE_PROP_FNS_ALL(NAME, LVL, IC) \
+    CACHE_PROP_FNS(NAME, LVL, IC, sets)   \
+    CACHE_PROP_FNS(NAME, LVL, IC, associativity) \
+    CACHE_PROP_FNS(NAME, LVL, IC, linesize)
+
+CACHE_PROP_FNS_ALL(lvl1_dcache, 1, false)
+CACHE_PROP_FNS_ALL(lvl1_icache, 1, true)
+CACHE_PROP_FNS_ALL(lvl2,        2, false)
+CACHE_PROP_FNS_ALL(lvl3,        3, false)
+
 const ArmFracVal csv2_frac_vals[] = {
     { "0.0", 0, 0 },
     { "1.0", 1, 0 },
@@ -286,6 +427,66 @@ const ArmCpuPropDesc arm_cpu_props[] = {
     ARM_SINGLE_FIELD_PROP("cpu_revidr", NUMERIC, REVIDR, VAL),
     ARM_SINGLE_FIELD_PROP("cpu_aidr", NUMERIC, AIDR, VAL),
 
+    ARM_SINGLE_FIELD_PROP("cache_lvl1_type", STRING, CLIDR_EL1, CTYPE1),
+    ARM_SINGLE_FIELD_PROP("cache_lvl2_type", STRING, CLIDR_EL1, CTYPE2),
+    ARM_SINGLE_FIELD_PROP("cache_lvl3_type", STRING, CLIDR_EL1, CTYPE3),
+    ARM_SINGLE_FIELD_PROP("cache_louis", NUMERIC, CLIDR_EL1, LOUIS),
+    ARM_SINGLE_FIELD_PROP("cache_loc", NUMERIC, CLIDR_EL1, LOC),
+    ARM_SINGLE_FIELD_PROP("cache_louu", NUMERIC, CLIDR_EL1, LOUU),
+    ARM_SINGLE_FIELD_PROP("cache_icb_type", STRING, CLIDR_EL1, ICB),
+    ARM_SINGLE_FIELD_PROP("cache_ttypen", NUMERIC, CLIDR_EL1, TTYPEN),
+
+    ARM_CUSTOM_PROP("cache_lvl1_icache_sets", "number",
+                    cache_lvl1_icache_sets_get,
+                    cache_lvl1_icache_sets_set,
+                    cache_lvl1_icache_sets_reset),
+    ARM_CUSTOM_PROP("cache_lvl1_dcache_sets", "number",
+                    cache_lvl1_dcache_sets_get,
+                    cache_lvl1_dcache_sets_set,
+                    cache_lvl1_dcache_sets_reset),
+    ARM_CUSTOM_PROP("cache_lvl2_sets", "number",
+                    cache_lvl2_sets_get,
+                    cache_lvl2_sets_set,
+                    cache_lvl2_sets_reset),
+    ARM_CUSTOM_PROP("cache_lvl3_sets", "number",
+                    cache_lvl3_sets_get,
+                    cache_lvl3_sets_set,
+                    cache_lvl3_sets_reset),
+
+    ARM_CUSTOM_PROP("cache_lvl1_icache_associativity", "number",
+                    cache_lvl1_icache_associativity_get,
+                    cache_lvl1_icache_associativity_set,
+                    cache_lvl1_icache_associativity_reset),
+    ARM_CUSTOM_PROP("cache_lvl1_dcache_associativity", "number",
+                    cache_lvl1_dcache_associativity_get,
+                    cache_lvl1_dcache_associativity_set,
+                    cache_lvl1_dcache_associativity_reset),
+    ARM_CUSTOM_PROP("cache_lvl2_associativity", "number",
+                    cache_lvl2_associativity_get,
+                    cache_lvl2_associativity_set,
+                    cache_lvl2_associativity_reset),
+    ARM_CUSTOM_PROP("cache_lvl3_associativity", "number",
+                    cache_lvl3_associativity_get,
+                    cache_lvl3_associativity_set,
+                    cache_lvl3_associativity_reset),
+
+    ARM_CUSTOM_PROP("cache_lvl1_icache_linesize", "number",
+                    cache_lvl1_icache_linesize_get,
+                    cache_lvl1_icache_linesize_set,
+                    cache_lvl1_icache_linesize_reset),
+    ARM_CUSTOM_PROP("cache_lvl1_dcache_linesize", "number",
+                    cache_lvl1_dcache_linesize_get,
+                    cache_lvl1_dcache_linesize_set,
+                    cache_lvl1_dcache_linesize_reset),
+    ARM_CUSTOM_PROP("cache_lvl2_linesize", "number",
+                    cache_lvl2_linesize_get,
+                    cache_lvl2_linesize_set,
+                    cache_lvl2_linesize_reset),
+    ARM_CUSTOM_PROP("cache_lvl3_linesize", "number",
+                    cache_lvl3_linesize_get,
+                    cache_lvl3_linesize_set,
+                    cache_lvl3_linesize_reset),
+
     /* Fractional properties */
     ARM_FRAC_PROP("feat_CSV2", ID_AA64PFR0, CSV2, ID_AA64PFR1, CSV2_FRAC, csv2_frac_vals),
     ARM_FRAC_PROP("feat_MPAM", ID_AA64PFR0, MPAM, ID_AA64PFR1, MPAM_FRAC, mpam_frac_vals),
@@ -314,6 +515,21 @@ static const char *sve_sub_props[] = {
     NULL
 };
 
+static const char *expose_cache_sub_props[] = {
+    "cache_lvl1_icache_sets", "cache_lvl1_dcache_sets",
+    "cache_lvl1_icache_associativity", "cache_lvl1_dcache_associativity",
+    "cache_lvl1_icache_linesize", "cache_lvl1_dcache_linesize",
+    "cache_lvl1_type",
+    "cache_lvl2_sets", "cache_lvl2_associativity",
+    "cache_lvl2_linesize", "cache_lvl2_type",
+    "cache_lvl3_sets", "cache_lvl3_associativity",
+    "cache_lvl3_linesize", "cache_lvl3_type",
+
+    "cache_icb_type", "cache_ttypen",
+    "cache_louis", "cache_loc", "cache_louu",
+    NULL
+};
+
 static void pauth_get(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
 {
     uint64_t apa, api, apa3;
@@ -338,9 +554,35 @@ static void sve_get(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
     visit_type_bool(v, name, &sve_enabled, errp);
 }
 
+static void expose_cache_get(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
+{
+    visit_type_bool(v, name, &cpu->cache_exposed, errp);
+}
+
+static void expose_cache_set(ARMCPU *cpu, Visitor *v, const char *name,
+                             Error **errp)
+{
+    bool val;
+
+    ERRP_GUARD();
+
+    if (!visit_type_bool(v, name, &val, errp)) {
+        return;
+    }
+
+    arm_composite_set_internal(cpu, arm_find_prop(name), val, name, errp);
+    if (*errp) {
+        error_prepend(errp, "Property '%s': ", name);
+    }
+
+    cpu->cache_exposed = val;
+}
+
 const ArmCpuPropDesc arm_composite_props[] = {
     ARM_COMPOSITE_PROP_GS("pauth", pauth_sub_props, pauth_get, pauth_set),
     ARM_COMPOSITE_PROP("sve", sve_sub_props, sve_get),
+    ARM_COMPOSITE_PROP_GS("expose-cache", expose_cache_sub_props,
+                          expose_cache_get, expose_cache_set),
     { .name = NULL }
 };
 
@@ -448,6 +690,11 @@ static void arm_cpu_prop_get(Object *obj, Visitor *v, const char *name,
     case ARM_PROP_COMPOSITE:
         /* Composite features must have a custom getter */
         g_assert_not_reached();
+        break;
+    case ARM_PROP_CUSTOM:
+        /* Custom getter should be passed. */
+        g_assert_not_reached();
+        break;
     }
 }
 
@@ -541,6 +788,11 @@ static void arm_prop_set_default(ARMCPU *cpu, const char *name, Error **errp)
         return;
     }
 
+    if (p->reset) {
+        p->reset(cpu, name, errp);
+        return;
+    }
+
     switch (p->type) {
     case ARM_PROP_STRING:
     case ARM_PROP_BOOLEAN:
@@ -554,6 +806,10 @@ static void arm_prop_set_default(ARMCPU *cpu, const char *name, Error **errp)
     case ARM_PROP_COMPOSITE:
         object_property_set_bool(OBJECT(cpu), p->name, false, errp);
         break;
+    case ARM_PROP_CUSTOM:
+        /* Custom default resetter should be implemetend. */
+        g_assert_not_reached();
+        break;
     default:
         g_assert_not_reached();
     }
@@ -669,6 +925,10 @@ static void arm_cpu_prop_set(Object *obj, Visitor *v, const char *name,
     case ARM_PROP_COMPOSITE:
         arm_composite_set(cpu, p, v, name, errp);
         break;
+    case ARM_PROP_CUSTOM:
+        /* Custom setter should be passed. */
+        g_assert_not_reached();
+        break;
     }
 }
 
@@ -689,6 +949,9 @@ void arm_add_cpu_props(Object *obj)
         case ARM_PROP_NUMERIC:
             type = "number";
             break;
+        case ARM_PROP_CUSTOM:
+            type = p->u.custom_type;
+            break;
         default:
             g_assert_not_reached();
         }
@@ -802,7 +1065,14 @@ void arm_prop_append_supported_values(const ArmCpuPropDesc *prop,
         }
         break;
     }
-
+    case ARM_PROP_COMPOSITE: {
+        /* not supported for composites */
+        break;
+    }
+    case ARM_PROP_CUSTOM: {
+        /* not supported for custom props */
+        break;
+    }
     default:
         g_assert_not_reached();
     }
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index 264a8a71de..55333de858 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -20,7 +20,8 @@ typedef enum ArmCpuPropType {
     ARM_PROP_BOOLEAN,
     ARM_PROP_NUMERIC,
     ARM_PROP_FRACTIONAL,
-    ARM_PROP_COMPOSITE
+    ARM_PROP_COMPOSITE,
+    ARM_PROP_CUSTOM
 } ArmCpuPropType;
 
 typedef struct ArmFracVal {
@@ -40,10 +41,12 @@ typedef struct ArmCpuPropDesc {
             const ArmFracVal *vals;
         } frac;
         const char **comp_sub_props;
+        const char *custom_type;
     } u;
 
     void (*get)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
     void (*set)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
+    void (*reset)(ARMCPU *cpu, const char *name, Error **errp);
 } ArmCpuPropDesc;
 
 const ArmCpuPropDesc *get_arm_cpu_props(void);
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 9b7eea7fea..e13dfeb357 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -87,6 +87,7 @@ CpuPropInfoList *qmp_query_arm_cpu_props_info(Error **errp)
                                    pdesc->type == ARM_PROP_BOOLEAN ? "boolean" :
                                    pdesc->type == ARM_PROP_NUMERIC ? "number" :
                                    pdesc->type == ARM_PROP_FRACTIONAL ? "string" :
+                                   pdesc->type == ARM_PROP_CUSTOM ? pdesc->u.custom_type :
                                    "unknown");
 
         sv = qlist_new();
diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index e162bdff9b..c3aec21f5c 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -28,17 +28,6 @@
 /*
  * System register ID fields.
  */
-FIELD(CLIDR_EL1, CTYPE1, 0, 3)
-FIELD(CLIDR_EL1, CTYPE2, 3, 3)
-FIELD(CLIDR_EL1, CTYPE3, 6, 3)
-FIELD(CLIDR_EL1, CTYPE4, 9, 3)
-FIELD(CLIDR_EL1, CTYPE5, 12, 3)
-FIELD(CLIDR_EL1, CTYPE6, 15, 3)
-FIELD(CLIDR_EL1, CTYPE7, 18, 3)
-FIELD(CLIDR_EL1, LOUIS, 21, 3)
-FIELD(CLIDR_EL1, LOC, 24, 3)
-FIELD(CLIDR_EL1, LOUU, 27, 3)
-FIELD(CLIDR_EL1, ICB, 30, 3)
 
 /* When FEAT_CCIDX is implemented */
 FIELD(CCSIDR_EL1, CCIDX_LINESIZE, 0, 3)
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index c4f039f690..c1c334291a 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -18,6 +18,7 @@ typedef enum ArmIdRegSafeRule {
 
 #define DCZID_EL0_EL1_IDX         DCZID_EL0_IDX
 #define CTR_EL0_EL1_IDX           CTR_EL0_IDX
+#define CLIDR_EL1_EL1_IDX         CLIDR_EL1_IDX
 
 /* ArmFieldIdx: per-field enum generated from cpu-idregs.h.inc */
 #define IDREG_START(reg)
diff --git a/target/arm/cpu-idregs.h.inc b/target/arm/cpu-idregs.h.inc
index 7e2bbf256d..05bf7fe96a 100644
--- a/target/arm/cpu-idregs.h.inc
+++ b/target/arm/cpu-idregs.h.inc
@@ -1547,6 +1547,97 @@ IDREG_FIELD_END(ID_AA64AFR1, VAL)
 
 IDREG_END(ID_AA64AFR1_EL1)
 
+/* CLIDR_EL1 */
+IDREG_START(CLIDR_EL1)
+IDREG_FIELD_START(CLIDR_EL1, CTYPE1,    0,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "no-cache")
+IDREG_FIELD_ARCH_VAL(0b001, "i-cache-only")
+IDREG_FIELD_ARCH_VAL(0b010, "d-cache-only")
+IDREG_FIELD_ARCH_VAL(0b011, "separate-i-d-cache")
+IDREG_FIELD_ARCH_VAL(0b100, "unified-cache")
+IDREG_FIELD_END(CLIDR_EL1, CTYPE1)
+
+IDREG_FIELD_START(CLIDR_EL1, CTYPE2,    3,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "no-cache")
+IDREG_FIELD_ARCH_VAL(0b001, "i-cache-only")
+IDREG_FIELD_ARCH_VAL(0b010, "d-cache-only")
+IDREG_FIELD_ARCH_VAL(0b011, "separate-i-d-cache")
+IDREG_FIELD_ARCH_VAL(0b100, "unified-cache")
+IDREG_FIELD_END(CLIDR_EL1, CTYPE2)
+
+IDREG_FIELD_START(CLIDR_EL1, CTYPE3,    6,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "no-cache")
+IDREG_FIELD_ARCH_VAL(0b001, "i-cache-only")
+IDREG_FIELD_ARCH_VAL(0b010, "d-cache-only")
+IDREG_FIELD_ARCH_VAL(0b011, "separate-i-d-cache")
+IDREG_FIELD_ARCH_VAL(0b100, "unified-cache")
+IDREG_FIELD_END(CLIDR_EL1, CTYPE3)
+
+IDREG_FIELD_START(CLIDR_EL1, CTYPE4,    9,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "no-cache")
+IDREG_FIELD_ARCH_VAL(0b001, "i-cache-only")
+IDREG_FIELD_ARCH_VAL(0b010, "d-cache-only")
+IDREG_FIELD_ARCH_VAL(0b011, "separate-i-d-cache")
+IDREG_FIELD_ARCH_VAL(0b100, "unified-cache")
+IDREG_FIELD_END(CLIDR_EL1, CTYPE4)
+
+IDREG_FIELD_START(CLIDR_EL1, CTYPE5,   12,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "no-cache")
+IDREG_FIELD_ARCH_VAL(0b001, "i-cache-only")
+IDREG_FIELD_ARCH_VAL(0b010, "d-cache-only")
+IDREG_FIELD_ARCH_VAL(0b011, "separate-i-d-cache")
+IDREG_FIELD_ARCH_VAL(0b100, "unified-cache")
+IDREG_FIELD_END(CLIDR_EL1, CTYPE5)
+
+IDREG_FIELD_START(CLIDR_EL1, CTYPE6,   15,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "no-cache")
+IDREG_FIELD_ARCH_VAL(0b001, "i-cache-only")
+IDREG_FIELD_ARCH_VAL(0b010, "d-cache-only")
+IDREG_FIELD_ARCH_VAL(0b011, "separate-i-d-cache")
+IDREG_FIELD_ARCH_VAL(0b100, "unified-cache")
+IDREG_FIELD_END(CLIDR_EL1, CTYPE6)
+
+IDREG_FIELD_START(CLIDR_EL1, CTYPE7,   18,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "no-cache")
+IDREG_FIELD_ARCH_VAL(0b001, "i-cache-only")
+IDREG_FIELD_ARCH_VAL(0b010, "d-cache-only")
+IDREG_FIELD_ARCH_VAL(0b011, "separate-i-d-cache")
+IDREG_FIELD_ARCH_VAL(0b100, "unified-cache")
+IDREG_FIELD_END(CLIDR_EL1, CTYPE7)
+
+IDREG_FIELD_START(CLIDR_EL1, LOUIS,    21,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL_ANY
+IDREG_FIELD_END(CLIDR_EL1, LOUIS)
+
+IDREG_FIELD_START(CLIDR_EL1, LOC,      24,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL_ANY
+IDREG_FIELD_END(CLIDR_EL1, LOC)
+
+IDREG_FIELD_START(CLIDR_EL1, LOUU,     27,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL_ANY
+IDREG_FIELD_END(CLIDR_EL1, LOUU)
+
+IDREG_FIELD_START(CLIDR_EL1, ICB,      30,  3, ANY,  0)
+IDREG_FIELD_ARCH_VAL(0b000, "unknown")
+IDREG_FIELD_ARCH_VAL(0b001, "l1")
+IDREG_FIELD_ARCH_VAL(0b010, "l2")
+IDREG_FIELD_ARCH_VAL(0b011, "l3")
+IDREG_FIELD_ARCH_VAL(0b100, "l4")
+IDREG_FIELD_ARCH_VAL(0b101, "l5")
+IDREG_FIELD_ARCH_VAL(0b110, "l6")
+IDREG_FIELD_ARCH_VAL(0b111, "l7")
+IDREG_FIELD_END(CLIDR_EL1, ICB)
+
+IDREG_FIELD_START(CLIDR_EL1, TTYPEN,   33, 14, ANY,  0)
+IDREG_FIELD_ARCH_VAL_ANY
+IDREG_FIELD_END(CLIDR_EL1, TTYPEN)
+
+IDREG_FIELD_START(CLIDR_EL1, RES0_47,  47, 17, EXACT,  0)
+IDREG_FIELD_ARCH_VAL(0, NULL)
+IDREG_FIELD_END(CLIDR_EL1, RES0_47)
+
+IDREG_END(CLIDR_EL1)
+
 /* AArch32 ID registers */
 
 /*  ID_PFR0_EL1  */
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index a0a1d7fbe3..5dab74412f 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1189,6 +1189,9 @@ struct ArchCPU {
 
     /* Generic timer counter frequency, in Hz */
     uint64_t gt_cntfrq_hz;
+
+    /* QOM property to indicate if the cache is exposed */
+    bool cache_exposed;
 };
 
 typedef struct ARMCPUInfo {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b4544f3514..984c7fd256 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1197,6 +1197,48 @@ static uint64_t *kvm_arm_find_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
     return &cpu->cpreg_values[res - cpu->cpreg_indexes];
 }
 
+#define CSSELR_MAX 14
+
+/*
+ * Push the model-configured CCSIDR_EL1 values stored in cpu->ccsidr[] into
+ * the cpreg list, so the subsequent write_list_to_kvmstate() pass actually
+ * issues KVM_SET_ONE_REG for the matching KVM_REG_ARM_DEMUX_ID_CCSIDR
+ * registers.
+ */
+static void kvm_arm_writeback_ccsidr(ARMCPU *cpu)
+{
+    if (!cpu->cache_exposed) {
+        return;
+    }
+
+    QEMU_BUILD_BUG_ON(ARRAY_SIZE(cpu->ccsidr) < CSSELR_MAX);
+
+    for (uint32_t csselr = 0; csselr < CSSELR_MAX; csselr++) {
+        uint64_t regidx = KVM_REG_ARM64
+                        | KVM_REG_SIZE_U32
+                        | KVM_REG_ARM_DEMUX
+                        | KVM_REG_ARM_DEMUX_ID_CCSIDR
+                        | csselr;
+        uint64_t *cpreg = kvm_arm_find_cpreg_ptr(cpu, regidx);
+
+        if (cpu->ccsidr[csselr] == 0) {
+            continue;
+        }
+
+        if (!cpreg) {
+            /* This kernel doesn't expose this CSSELR slot; skip. */
+            error_report("KVM does not expose CSSELR slot %d", csselr);
+            continue;
+        }
+
+        /*
+         * cpu->ccsidr[] is u64. The DEMUX ABI only takes the low 32 bits,
+         * matching the legacy CCSIDR encoding, which KVM enforces.
+         */
+        *cpreg = (uint32_t)cpu->ccsidr[csselr];
+    }
+}
+
 static void kvm_arm_writeback_idregs(ARMCPU *cpu)
 {
     for (int i = 0; i < NUM_ID_IDX; i++) {
@@ -1205,6 +1247,14 @@ static void kvm_arm_writeback_idregs(ARMCPU *cpu)
         const char *name = arm_idregs[i].name;
         uint64_t writable_mask, previous, desired, diff;
 
+        if (i == CLIDR_EL1_IDX && !cpu->cache_exposed) {
+            /*
+             * CLIDR is not exposed to KVM when cache_exposed is false.
+             * Continue with the whatever view KVM provides.
+             */
+            continue;
+        }
+
         if (!cpreg) {
             warn_report("KVM does not expose ID register slot %d "
                         "(kvm_reg=0x%" PRIx64 "), %s; skipping writeback",
@@ -1270,6 +1320,10 @@ static void kvm_arm_writeback_idregs(ARMCPU *cpu)
             trace_kvm_arm_writeback_idreg(name, previous, *cpreg);
         }
     }
+
+    if (cpu->cache_exposed) {
+        kvm_arm_writeback_ccsidr(cpu);
+    }
 }
 
 bool kvm_arm_cpu_post_load(ARMCPU *cpu)
-- 
2.52.0

