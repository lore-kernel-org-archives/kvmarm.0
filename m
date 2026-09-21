Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB22B496D3A
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994038; cv=fail; b=fJ4J03FUOi67S7hjgO99Cl4cbO9+gBV/pDmpOjhT5D6JwjGbz0hzopuCpkJRtLFeh3GVoNu8y93PI6nKCb1xIAobQBxX+o/jWBrXfzrrjzhFiSIdy3vq5Ka2BSVaGoT+9ERn1aKrQvjYJ+fwk8TSVQ7+L8sYYp+iXt5PBrgJcJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994038; c=relaxed/simple;
	bh=MWPtSFMzCOkAQMwFoND9QQg0YkU3rz4+W58Bc/8IQk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TcSNUIWnAy8MewKAscFwrMiHCIbvjJrzukHMNCOCGZBdGHL1QsNrcb32lVEp54Cw7FCO9oJf9ooi6VD+KASzN3qVDs1547V9E3V4vuR/zgm7K3FIHAqHRbyBMVbMFUorXOV5dVpy49MskyUxXN903UKLqnxhYXr2oxroxrvacwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aUJzn5O5; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DV09eh5U; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aUJzn5O5";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DV09eh5U"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHpF857563;
	Mon, 21 Sep 2026 05:33:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ihMF2h3XPYoyhKmq9Q/JRE0FqovoxW8rd+4sOdGmu
	nM=; b=aUJzn5O5+W93/Sb7Oau1KgIuwncadJu2nhR6NQYxe75hyNpEqNNvfE5cc
	eBn7DA4PiHX++tXNSb/QtryMrltvcMeUi3t3YyVunlYyTKO4sfX8eUkqLPcETvmm
	mmEkFDsBl2ziQoAhLalrpwCh5ua0ZsT5vT1Rdvk/idEDxSzGGmIZO1W5YijWHhpD
	MtMo3oPiQZ0YaREnaJwVCjACu5QUIaH+RAbuFkFc9kZOr4RI9cA1XG2sXkK2T3ia
	gw9JKGM/x8IDUmj+Q+zLKUaPtYeEdDQb+I6XdNBHTUgx+/N1GVKmJlUhCe2nzjMi
	qIO6bJPYZF3mIxrjA2wnP2iXaOa4A==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023104.outbound.protection.outlook.com [40.107.201.104])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jnu-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VOxWD2L750PVqfi074VTh2LZUJK5aDiLyO+Rhq+VRJNr35wWRECnPaM7Rhh0Xrh64GojJAli0K7vx0iwae2JGe18AcF+np9/4nAMYphHTjrb1SLgubVfDNiFxKH0PXHi1ihIWvFtyIPcq0x56XbbCDKwxD5S7hD5NZFSm8hHmi9S2hQqE+S+UaLdRd4JGGo4ZNGQDS+Aw/MGAoXtYV/vqfn0PMCziIWYjXqb+5mNP3oc16lghcBqkPgMIhzOEGIK7MVAs+xI9TjxhkEV66HSobSleR1jfP0Fp4xiMTH1cQ8Vc07U79GTilBiydZEdR3erKgMue6YyxHg7E9yLs2PjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihMF2h3XPYoyhKmq9Q/JRE0FqovoxW8rd+4sOdGmunM=;
 b=Hxg6E3QI4FEGdNDwoOuJua+SCW65bByF6BG6uYuYkDOefGibmGf2i41Y6ur/K4Lch4fMMIAjSjU4hoU+MICRZsg2sR4Lgh/y/4sBmvxsKeS14JXVLJKRRoEN7Vby2WZzYAAwzu+Jgg60l2a5Pl7o9P5dGfCdPW44npTazU/8vvm3gwMFf3wQ27Dnwg87OnXDgVborIoZmo8a573EAD8JqcGqbwpRiotM/Ctorh2m1I3F5vNBrhJ4oSRG6IYxuUzo27GuxDI3iaM/PHzlHgHmT+VKT9uhXCBvdmu3r0ta7s3kpXGi7viLjpjP+db0LDIL767c4223ptLdrgiB3+BAHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihMF2h3XPYoyhKmq9Q/JRE0FqovoxW8rd+4sOdGmunM=;
 b=DV09eh5UG+O5LM8TIKqWvaGODYgFkCFxUi4lLQSjFfSWafKCvrcfrl7OpeJBZtg64Hlyp92ZmVgA204BDdj7DqODcMzA6OsbwAzw0u/ZwN8ZTUTQZmHn0LDiQv/CeINW89HLfZHOCyh9FtStd7hiG42ShgbetVVHDs+t1c+Mk6kGeZOKHZ2SlVdWg3gKWFciEQpik8bGwTQhKqrckWM+nvxBfWZ+l+Khj3vOViWvilm0ITS5ULw0gwV7VXAdXNNsPseJEYlT+l/bc9v1wgsj/3kirk1Oq4XbcOXcdNgd3WJYbWBm23ubzBzKfK3GCGFQa3mkyW4t08zQ7hSAWa/lTg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:24 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:24 +0000
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
Subject: [RFC PATCH v4 04/25] target/arm/kvm: enable writable implementation ID registers
Date: Mon, 21 Sep 2026 12:32:28 +0000
Message-ID: <20260921123249.1708067-5-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: d7b592e9-be02-44cc-255c-08df17dc8787
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	x5KHxb2OclegclIAymS7L4qrY1dcVP6ZGUWc+t1JFrIjxqOQv/ZvgnMaNyQmfOr+U4XKbApr4dtHsNUOIY+dBsXruYOG4VJHsqOibD5tLaNrcn19hJGPAMoazkO8vYHV4fdcQAJ30oUph7zcnZOqQhzUmONxIEo22s5OoJaWiVKwDxPbZjg+eONfGZnNAqsSKtULOwjJB0GmkbRWpQiJ/PiCP+y0oUtqHGyY6UkM4ZRQXNEoPerFiiKJkweCdgQUfhwMy2r8Tsb4zUij8oVZAU6Ad+ghhfJ87qBXnYYUiBndLjVdSpaxAhFGrKMDhQF8dkXl+XTX88gaGPEY6AiQt9IQcMKyyYn76VGykNDhXIEdjNTvDPUHt3voO///pe8lSSuNVKsWbwYf3thM+6ZnWSh8MfgFy2CWVLW1Rx9BR3bAHAHIHgHQUUI4PqLCxrYkAT47O+kU4xWntJCRjvTGpc3aIJA+eoDiWzI6PxLYUSpvTYGgK9A8lQLCLYiW+explKM/06n6OxP8qbB65WlUuSzBfaXBpzSZSKnYAEiZzfSN1ekxJeSyrq/NJcx7MjYVi4+7tSKuEbXJnWmgOjt09huDjNx9u8Lql5UZgMj3h42cByHFTRxhoolJzTEX/0eJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?roXDa4A0vRGjKyFqRYiEzISaL4qnVLPxq1NsyZYWUvhYzy0T1iYRSu/Mv67B?=
 =?us-ascii?Q?rTOUcFIVRjde9sCAaD8027nPQtQO4UvtUToH/ybxMBSTCxe7JMmXEZm6DPj5?=
 =?us-ascii?Q?BieTDo7NvzbAd/Lyc7nHlf7RL4AGdSjA7101QEJ9SbQ/jAi6SZpGYXLPBlVc?=
 =?us-ascii?Q?LHYmrKTESub7jwLHymFlRuqnHq8axSSEZWMZacOyJofWoFL1jU/0bS5x868Z?=
 =?us-ascii?Q?7UrLmm7YGvjKq4ab9lg/mf6xEJGoSGmdUv2eIJimVQvEwau7bDTUrRAHxGr9?=
 =?us-ascii?Q?mJxJ2+ixm3QBYc/uRxuhbG4dUhMnjYCPHMOzxubMQKNzpOzRu2VGa3Y5It6v?=
 =?us-ascii?Q?wkAHcdxSOoqEv+IROhiYk1prmotHkeoykDERiCoIxL4fK7HfkSvI4RD85Dbo?=
 =?us-ascii?Q?3AmY8FYc/d7o0Q1ZejW5CZYnGzYLdJEJaHtKxs+lcnMJs7mKGTuJ6GGNwy5p?=
 =?us-ascii?Q?4jLoZsrGGXoIynkfah81pmnjF2DGNZ8T1Z4/eKBLf3QKdWNMDKGrGTwW5oSo?=
 =?us-ascii?Q?oL5RGC1m7vtE8dggqMgGLfaVFD4MuPLhfi0/OAA5AZ+rcnhJm01bihjlIUza?=
 =?us-ascii?Q?3e5eY+tIeuiG9qYuZJ25vRH9K3x6N8+Otj3GMhuhGDqegpX6I3hInWWoYlEa?=
 =?us-ascii?Q?Mc6oiAakCqvA3TkX1pgUT19XKg1rBEtzJqGR2PCtGCZRFQM5l6leYPkjGnib?=
 =?us-ascii?Q?/cDmDC+kYntUGvkraK/zu53RqayN+JbRxMP1nDqDXIvm1cFuqHlDF0NcKioS?=
 =?us-ascii?Q?Tuga79Y61nhNx4sF9+upAKwsWoN/g4Sn+b64ooiCe3uBzjqdH3K7wx/bGwG2?=
 =?us-ascii?Q?O9/Q5dE7og/xwpe6nFENdPEEoHYuHIkq50aQUKFXo7w8daMU0++/uGrOOqa1?=
 =?us-ascii?Q?yPeO2I5fmiqWIHMG732dF1F/RI9GIO61B78/TSHaHWMwrdpjD7nRxQF1nPIp?=
 =?us-ascii?Q?5YlHOIAEV3WRLcvlpRqzcfX4m0SYauS2HVzRrkwSpR76KLLswRmGBC/6Qfew?=
 =?us-ascii?Q?RKvgqlbr4Oy7ZU4eH7ta5pdsBhM0Jre7LYFwzmLVTOlZaPdDlQmcrtxSaF7k?=
 =?us-ascii?Q?bMWNjIRsKycXK28cxxGXowJkRrfSxeSd/Q8zTR1/9gyqFD50LCkheeXr84xi?=
 =?us-ascii?Q?pox/s3t/WzDzcjh1GDgNNMujvvCSbjSG3Kgy7y7AREH2lfk4ArvpQQAKxIWG?=
 =?us-ascii?Q?bJUpr1HywqUVnt6nbRA9CO4rIgPyUP6aKjDPKx3qsqfZUb+gwnxnfwaFwyI0?=
 =?us-ascii?Q?BGxr1KF0vDJ4jvY+YV2SjgH3BPA4QtIJd2ax1KrBsUpbzp6Y55FKQ9BYCyC4?=
 =?us-ascii?Q?MyP7A/X/huq5vVKsiqLYs8GLm0NZG2fx81OIgmTM6VIUZpeliOH+joyzZPHJ?=
 =?us-ascii?Q?zyWKqFbKUMxNW/gHzf1kN7UNAs0T95B5tRx6+aI8UjQVMRelmB0XwVOWovQQ?=
 =?us-ascii?Q?j8Phyh4PZ0bj80T9EkWD0ibe5rwrzaDZT/R9oJzy5o0UEaLY5/x3RGb/HKIT?=
 =?us-ascii?Q?aI228xJy2d+hBf51PkeNDzXh+p+k+nrwSIX9800yUD6DFXqc3yLl/5zCqLsI?=
 =?us-ascii?Q?4U0WFImah0djuaJSLzdHyBI5rlsx7jMFi9CvBuKbX0SuaLfyq6dBhRfp0SXF?=
 =?us-ascii?Q?ZI96W6ugoqsqFJ+j/pHPLvBjrED0q8dLrOOsz6L+o3IyHk+fxpwgYGzHzaH8?=
 =?us-ascii?Q?e4gP8plosptN2hq2orFTRwWn9EdI0p1EjLpgFJOXPXoCVu/aMpWB04SCbPyF?=
 =?us-ascii?Q?uHemY/tJ5nMn/BMpXFhXz9iqx7fDo9M=3D?=
X-Exchange-RoutingPolicyChecked:
	x98Sp+4K0vXTNkzWATqDRuKyzvLErPjlzby2YNMIqT8DKXSlXaAzaMLZk+caNaX8KAa1TOd5e0VfA9LgMx3+ynqbBcL4DZDg3x4zXapCqT8jN2SxJ3EHmZIGr+ghdfvwsKWE7GS11YwlUI4VJExeUaVkmWgj6qe65zcs/Vt8Vzfktnaq4Z51/pqZS4MV8Kn5U7kIZnEv7tMIVVD8RDL9vaaB6f2xXy8O+SnPORHTPDBtS0Fv56aCXUHc1geNeEwtiKGzbr8NNbwvRVpbP+2Z74Z5626/qeiudgMdAHH/qDpHNyA0QpJrb0OQY35mlvdLqPIO4QjCa/kZsIlGqHNMqg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b592e9-be02-44cc-255c-08df17dc8787
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:24.5116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+12sB6esF+eAPTYvJ9xvMeU+ZZqGrLEwdtIr2vGkduCX21uFm7fVgdsAILC3pQIgbkuOFfQCpUKLozUeMcmMjdo4RR5oS/fEolAx6tyes8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab1241f cx=c_pps
 a=0aASrZ1Sr5nz2ag1/hSaPw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=i7znhvatu4o865_pIWsA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXzZkrabj7CwmY
 7P3LQ5Apic/Jge4GiKkdRNGpyajEidTpkNtpgTZ0Sb4it24xpemJETW3Zv/bVDxLuywYttUgdxH
 HnxLqmy91M+qOBK69FdOEvdRNaci6/8=
X-Proofpoint-GUID: uN_qjWufsfTXJaxx_ryfN2ZYx7ICdyJN
X-Proofpoint-ORIG-GUID: uN_qjWufsfTXJaxx_ryfN2ZYx7ICdyJN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX5S6n/BuezK2z
 quxIROAff/3/1i3bDWiufZQSVRfZai2J39QleKIt546yiGdsTND/E4/HYbOwJMWac7vZZnXxDnV
 c7zXU+hnSoCX1tonwOyu4C36ezBjEQJakXb7iwYXG6jslQSfGOz1Fx3QqzVelUS0ToizpNXoJMy
 2KA3hAkQAbe90DWFg9muIVsPQvFacO4/xAB9YaOi2nXolj97yQO8/Go85IY3wcBQQWIo+umjk42
 sACzqaIofJVx4lCTPQ+nV3GMPfeiY336tnalzDJTe2J5WggnMxGpYegwQ46roRW9x9FrhzAzEEB
 0PrCO6426X4MTXL/Myffr2fsErkZ6A8sg/Hep0EVYjyuoPiXFFS6ITAotBc5uQ1/+RbiYmIdzxw
 mNYc1HiV4YdonlSgHjPzxFNRt78qu9naUBSgg0qrf/MflJZ3nxeCd2pID27iGoQhonHak2gwoLE
 z6yaEVtnqCmGO87BUzQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Enable KVM_CAP_ARM_WRITABLE_IMP_ID_REGS if the host kernel supports it.
This allows QEMU to write implementation-defined ID registers (MIDR,
REVIDR) so that named CPU models can present the intended values to the
guest instead of the host value.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>

-------
Guest errata management will require Shameer's RFC as a prerequisite:
https://lore.kernel.org/qemu-devel/B789DAF5-F8F9-444C-B0FF-4CA0081AFDED@nutanix.com/
---
 target/arm/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index d5155a3706..f8d349a461 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -808,6 +808,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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

