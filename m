Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12E73C8717
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237995; cv=fail; b=W040uAuCAwq+4wBcCjQ4jpX5jxd9wUZTe+q4XwdVQ3BBpaczuR1Lk8H1lu9FXmaODZeekXk91dDQtT06so4gDp/2ckk0Uq7sMFTANUOhb7dKJThacI0iQKz0OGFTSDUtm/QK11ROvdzAuQXp15jengJrcc4LrAD3ra0oHIUTpqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237995; c=relaxed/simple;
	bh=r0cbJ4919f3hpE4ur49EhfZvnRKCEsd6mUyL9BFBT4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jcLe2tga/Vo7cHDCaPGNIyFC2Gmd/rCQ+WcBlWEsbF9ItCL1jhu0HtIA19dZDKWR5IVWFI5hguDGebehOcdA0MXve3HoAmL1CqpO3Ab8lE/VIqzMBpXUEiaZZcIItkr6g/7pY/slWILoqvEybRnd94ZgRD+j0TX02YRbrD4hFJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=EgXPwkmc; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FUhVQksY; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="EgXPwkmc";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FUhVQksY"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZho1763910;
	Thu, 16 Jul 2026 14:39:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=g9u+fqbpF7yk8k5adr45TG9jD3xD95QlJWbDqABRw
	aw=; b=EgXPwkmcTCUAeD4dW4HX8riB1IrEbixD/oqXPqQ7vV9L+nbv7b530BJpl
	VcsROfEIXyWQtqV4n9SBr80NcMKJjhOee+VYzv/HVK1orLa+YkNecGcTVtuoMVmF
	BOnGuunw0tb36Q7HEI4JuYNBGHaM+tW27Umjd6YjZA2obYcJc8O2nXKMhM8huK/2
	GnzxXYbTYCtaFs6KE3E/c7bjQINtfVbLrm3caWBAXbVyjfXnwARuUKuivmcwG+Re
	9r8mpPKizzcyA1WpYQmKuihSWDa3sSsSoeQUdrMPW/u/9ItIFJIJevjR+poZuAEU
	VyTlGBxkAVXsWVcYcozFVLKoKqx3A==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-6
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UGXtBtd25HrEbd5Mf2tU1htWrvrPjFDAkpEq3Hy7NbQHLKOYmI1n9CNg3GC71oxq47Av4mUBm5WQqeG3+edY1dFM3LEGQVMQphDzwAi8SPUhP/NQnEIj37UoWiEM0M5lW9DAUKEADHP0BiYdv0J2b8RleU0Kj0T2Xpjw5WDgiTsiR8PIfuvmH+/pu37jhuVJGPNUS4XQ+93wuSAOZByNQtG5qqoabvw8zuPEt7t9/pxykdx0jxhtLvu5kJzVoHVibr+OQSaFqimFhERCAwnhytvaAlbaKo4ing4uXVbRoPa8mQ4phYV2Kj9djWn1Cl7YMOyyigD30ThcdPA1wUUM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9u+fqbpF7yk8k5adr45TG9jD3xD95QlJWbDqABRwaw=;
 b=UmS2iBjh+5bpL8pAOmcXHSzcKn7A0AAES9wkLwVlPYTDjI7q27rC2QlSnAPQuY2q9r07fXvN6BctxCkVNkbeiZ+aGhxqqL6IKNLY/acW/bODlFUtYP04JlcynjbWqHbP8eFfq77fu+AuW99dO4J1FJE/0Odcbq5SLZZNoYQsrxi+SBB5O/uYPE4jShkgXf97YOXBwF/4okvBRkIUn6qOG8qX5n0aOO2yUvM8GAmPniaq8XGjMVtl3RwpoUURzonJhVOGkaOpdXeC09OiSQazFleQImk3gqsOowLZpaZ6IkqjwpxHlcAGq2sS0lhjq1WTMsoE1N800NGI860bsJh25A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9u+fqbpF7yk8k5adr45TG9jD3xD95QlJWbDqABRwaw=;
 b=FUhVQksYNGnplV3m6wRYnL4ri70hkd+PCZxmiNDWjMYPdLWMJhlFv2Bmu7Eg9MFrgJj6qIRzO3MujO/2DzcKsAPyskgB9G9kl+8k36qMU08nG5tVSO3wMuMFDkc4Q+t6yp98bn+fC8hEEuxJoREUmhwmipviLNBjCEVCG0dBcHHpms6Kiv3eRtTT8T3yFvEM/KXfgFzWaUwTljp+JvkeL/kF7K8UC0bs/O/l7Bqfyu25xbDiIEb6hstoZ5Mm+b+DLxmFwhNZoY2WZFxwcL2G7hQjcTirK5xTY40VY9BTqodWaZJZrRoYEBuaVH/0O8/4G4OB4PlHFMKwQGmBx5pU6g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:31 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:31 +0000
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
Subject: [RFC PATCH v3 05/19] target/arm/kvm: enable writable implementation ID registers
Date: Thu, 16 Jul 2026 21:38:44 +0000
Message-ID: <20260716213858.609699-6-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0285c0cc-d768-44f1-3131-08dee382b835
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	zL6wrMyKr2MWDx0XNd/pMMvPC7fasx9hvoMXZ0zeM6NussUVt0DMb8cjScLL6jJItXMxuGB2fOjYztuPIj9owTSAGm9bEYzYBaQ/dY6DuDPDk9YpZsJVC0nJNhvmbokY5c6U+6eqUnNq/qarZlOlwhspjrdg4ERHK/HJLH0UqGCoh7xkhgqsb0VbRcKB5ZtcIUUYabD1nQeXPN+nZe3BvR8BEutg0Zi+ImN4480LhnRwkET1c3c/CNonzWICgVjX16c2c5FggRDsLpmcKKo99x8MnZ7qxzH/QgGEGwBC5pTNv+3Pi/kRwI24fnnlOM3B5w3L6n3YA/NG+KotOR3ThZOEmkMpnaexp0yQ15RTTSuTCLCCdl0C59WCxbrtLbJYYqYSsuP/c5QbcRvv+DzLV2cO04j4VJbW7xN1QWZK7d9vj3vwCmaec9yliMPyd6TB1mY/CHBDXrRZqrKPzzZP4sRkyrcIZYNMNaaisXsQNthRAYOlERe+i1DMLdlLgWvf3hnGaDxPdqebhEkh/lHCI/+Eo6eViJCs/CQTDVpcQUc1p8w2hMvX5nd/jjlS8UMxgAUXq3wF7ZwMU9OluG7EHinaaWttUBkRUhhBbDfx/tdICmjP0SX6obKarHSbvzcnWVesclBg3WRBCVgQSzCq6AFkEDGbCX+uAyw9bQcKaZg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k/EMYjCz/JcZIykV5Lkolewi8wpYw+dJ2LBYU58WJzuilH1Dg2ktIeD+qBtP?=
 =?us-ascii?Q?qPDEPwZCPhengi4625yzZ+O7UAfrngwTEy3zdjsHMAff15DRpqGKRawNlgnh?=
 =?us-ascii?Q?rNDtKwHhOkiHIUHa+GQeKoux7FEIHdLCfeptbS3q9l1z8qmR4MQi+EYQJyu7?=
 =?us-ascii?Q?wD9R36umi+rhyeuZLS7Cn/EjKzFvZR2jIfFbC08mW8FVVcngNh07kjdLOo2u?=
 =?us-ascii?Q?iOlg85+AYKYbeoG7fPs/TpSC0mwyKdNLAjpjdk96xXmcIp3p3leaSEyg49c1?=
 =?us-ascii?Q?KVqk3DFiukdz4hOc8j8x6mNSvO+clfYhj/k6w9qWCRQhBVRBAa3S/268gdOG?=
 =?us-ascii?Q?a7bqPNJQxJVoqCHmPhlcdMNPpxDnfkLZRgIczNCXrSNV7DZeIuI0uwpNkCzF?=
 =?us-ascii?Q?ZPI4XSZYM7/cV39hghbUfVBO3fEmjoXf6ikfu2Jl0dYjtIEnBc/W1fxvtJ1s?=
 =?us-ascii?Q?Km19jNvTj8+78EmpmqVPRRFmwVeKs9aehuaYAh2kwNu1ery7Tt/LYqPusoqo?=
 =?us-ascii?Q?DavspSDS3fkQ4MJkKJbGdPAW/7pUeXw2u6wtP2qDboMQgj59H3B+2Ndk3x/w?=
 =?us-ascii?Q?2Sokz1AzVVh/swHh8I3sBoS+SNUm4QTYh5aWJIA4ql4f9FXh5nu80uZe2L0+?=
 =?us-ascii?Q?RIfoDpYUrM2HUuycedLHUBupXVZsd960Kj8Wp7ImlXfdswkfU7/sEKNywux4?=
 =?us-ascii?Q?kmOr0hJz1JyQoinf4CcqMUIg/9nuwGUDfYbxE0NcoFrsf77/aipNkfEBSh48?=
 =?us-ascii?Q?WlyH0v+omCF4n/IvF5SIU4ZTkKfl8SjzhN01fFnGQ+NZlOaZaarNDMovoGLr?=
 =?us-ascii?Q?wdXhZBze9bZeVn/zqBO0kBYvIYvQPWB/yDoYlAEyGOsnDMga/azFPuiKqAVU?=
 =?us-ascii?Q?ro840tH8I7pwLHeTZCBor0MwabsfvB6jRekYGwpFsV+vYdeY6XEx6ZWZfyaK?=
 =?us-ascii?Q?FfDysJBUw/80KrGTwLd4SlSVBmNQ3e91h0lEzhZAchriPiwfpQi3PkTvPZSy?=
 =?us-ascii?Q?c777S1tpn8aMIqjS3SDTfAMVUu43a3lcViTE708CH99mxsznjmtIr0VbNWdb?=
 =?us-ascii?Q?UZZqXxfhqQtKgd8mXp+6VsX6FF1gcMbQpkf3KIrzlU5Ur9ESnhDtWQLY4uGd?=
 =?us-ascii?Q?RzXpjcCsN3MMoVOoA60i170F3ghe8dvQNOmTXLWNTzyoFSNUU8PTCCzr8jw4?=
 =?us-ascii?Q?RPWBOWAi0FDUrmabElG11jyok2LLSinW08wApkDUK6wcYURt18WoW70gsaHs?=
 =?us-ascii?Q?rN5xrujx3G5VaS6KmVtS0C9w3Qc5dbL/6CNslkA+YGZOxQkJYTQ0oL3pIilv?=
 =?us-ascii?Q?ZHCnpnF2y/WJ8S/T0Afzlmwg9/P16I3GAAhBacmynuOuKAVxgJR8t/hMfPDr?=
 =?us-ascii?Q?WV+Vwq171ArGBamYafbtizm/U2hQe6LGGC9DlKD5VLCtdsCgZPd6AwfwrOnx?=
 =?us-ascii?Q?hnAS+2/pYmDgW3O9zUwEtumiQzjrD8wB1xEQYBDQGEaa7W5m5Wn2Ku9d776C?=
 =?us-ascii?Q?3vpBO+7Cx+W6dz/BXsPWHeg/aPkVDv+3EnfPZsBjLL3phGrwS092zI3N4uDy?=
 =?us-ascii?Q?9VkU7xShqh46WY5ojHFp5BqmTCsnuUziZ9tuP1Sputy7aTp/zCUXhqeyqKCn?=
 =?us-ascii?Q?3fz6nPWumJfkyibwNoEq/J2KOXy2RTA8PHJxBmkzTtuUJn9l2v4oryeGeOpJ?=
 =?us-ascii?Q?kbo18vWWuUmg573vvKTwMphw4m6Zwo2iIQHtnDSXjSMWQSkEEPLL7EkjLjPu?=
 =?us-ascii?Q?QyfAbebLd1oBuiE8dZpftqAteg5BNvw=3D?=
X-Exchange-RoutingPolicyChecked:
	VGKMwPQhRvTl+Zf79K324EbPlYkiqD0+5hafvW6al+ej9Hw3RpN8UkSm1o6scNbZgyC4fJlt1TfwO3IcoWUVKUCwbJ/4aIAPeIPcIu3T9vSrSMNOmA9RtN75YnLJxcBTbr7+n5PS6WVwlYnqiQxQU0uDL8gtKFnNh2JaUaoyAQGn2cxiV/diEod0sNiW5/2wfyjfhSPbxuUMZbDS/IcOjytB34sWxWpl1gI1dsVTc8G6e2uZabPKPEZV1Iu1qXxERh/SQdTsJv6NcUZyGrF312cUdhvEiBGqp0RvRYw6iBNREQ8p92FYpEkOPDoEkRFE6eOREXh4qKLDa1eYM0L8yw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0285c0cc-d768-44f1-3131-08dee382b835
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:31.0316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGPqJvsmVY0CrrxuNN1KDL30RVQdhRmSW+UariAVTeeW2hoY7VjiYNL2X3JM6iueZwQJSUsU97wuJLdbkbEY9P3N9m67FcuSX0K0vlJGsPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX9lWg/bvuj72n
 S78rx5Fd6GKCHdtA1fOy4TfB5Nzw2zJuu3y3GmU4922RuYae1Kok16wnWyqH8qk1c72dVcsZGxB
 kHmcds1185WLQNmH3B0atikUnwxLB/US7ADSoT+DwFRR+7msWdR/SWwFRAlxZaBuK7f0Nfkg6qa
 oLVk4D0/D6QJQMVOH07QSvvkBcpSUD4jQpfP1lbsEwg/Yx95nr2x93bUsBEb4ZvDsszd9TDfDb5
 7fRRVUqOxjKGMkT23eWjKAGl5wPNjPIguRFx5IYmowp8dOtQ7GoSACTQK6ldME544HK2LoJrKUG
 jUd1FAKASebfTD4QIK2gCVcdLwZMW3dHgq1FHgoS5Ek6LNFVy4qx1JXFFYhPm0+Lqoj79JeryVB
 MrBot13sfdSKi0TNs29OK9/GfUdtJgMjEmK3vTi2CIEROgKaJKoKQ4/7R9Pp9w72vpoGJfK3tU8
 qr8xE2E0t7ZTwdEfs6w==
X-Proofpoint-GUID: 1KBWOwwUFKbu0O7PHXSGl-BrbG6vLIam
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXwDxjEfZmotd3
 yB7BqbtPw2txDgDJKEvl/VDFSFpXjdPB7QY6nVoMYwOVJlIR20SSo2+3gn2oWeSwtyG6xKR2OuG
 RBXLVGazVQmkpG64xzKQKOZ1OwjwAn8=
X-Proofpoint-ORIG-GUID: 1KBWOwwUFKbu0O7PHXSGl-BrbG6vLIam
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f96 cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=zu2ZhKAq3Qwx2YJsANoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Enable KVM_CAP_ARM_WRITABLE_IMP_ID_REGS if the host kernel supports it.
This allows QEMU to write implementation-defined ID registers (MIDR,
REVIDR) so that named CPU models can present the correct values to the
guest instead of inheriting the host's identity.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 76583db3f0..63b3727e05 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -741,6 +741,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (kvm_check_extension(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS)) {
+        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0)) {
+            error_report("Failed to enable "
+                         "KVM_CAP_ARM_WRITABLE_IMP_ID_REGS cap");
+        }
+    }
+
     if (s->kvm_eager_split_size) {
         uint32_t sizes;
 
-- 
2.52.0

