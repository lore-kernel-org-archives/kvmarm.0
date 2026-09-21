Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7DC3C4563
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995923; cv=fail; b=lzkmsDYKkHN4PRyLYkcpvJN2186dRPHNOk3oQ2Y/GyKtweOANXKQx/TIgsSa8AlzyWRSxxk/wtfkocbkWZXqhN+DD50OfEgKNTNRzLHXzl8Zkmdplpj7KhIqF3wDG93j89X25QA99VvXVY70AI/lyKmqjPR5/PeWvO0xboCcejs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995923; c=relaxed/simple;
	bh=g7u0bHGi8Jw6KEpM1AZs1bn2ll1wo7BBUzpuaWhJ7Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ll5T9E9GijRqg2G8OuUVfAMHrcZ6FKXcfOL9Vpx+kFCyue4cC3yAKimK2Gyzl5Js+D7tB9uULzZnXtaUIPd7vGM8c5951ulU88np7PLusYnVI4Ga1ZSCthJNiMLJmZrTu6lb2c0ujqS1qkCpCS6+czFx3NMXv/51sJu2lNp2jgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mXGmc7xg; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=AsrnypgC; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mXGmc7xg";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="AsrnypgC"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHpD857563;
	Mon, 21 Sep 2026 05:33:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=P6lGiNF8b4KMP2A15Y88Et6A2LCH1KConQNq5GnxH
	MU=; b=mXGmc7xg8BHe6Km7pKFOlBYwVNELlw06stFOyqdBwlunIKvmgOA1mV2Gi
	/xqR9hHWkUicfMnYAlCeFvu1fRvikRtcaJwvirFTTN+Ckwx2v6n1mmUJOQS2JIhc
	AT4NScwfX5XinNQ865kPPUDCuDoyJRR1apPkZRwTKTyDDFL5ba6ebKzh7AtjbI+r
	bsE+qdQXHgy2ztXYU966YLWevqyN4isxmmzkFf9bflT4hPNi3B3NdZtPxC4Xpi9A
	AWaIYwAH61U7RX+GOn5WEiQtBVSGfYXaJnEKfa5mTuzWe63WjXpZgZRu7rHQDTHM
	N/g886UUN1jxLYrBUauT1cbFRwu1Q==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023104.outbound.protection.outlook.com [40.107.201.104])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jnu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OqSp2PGwz7yrKL95bmQPGhlWde7XO6SCAfTbzemaeZae4wdxjKraZ4qwk9HxUIGohvKXeYf/F357Cu16MkanpzwRIJoK21pgcHPL9Bok3c5Y2+KPYlNJI1zbSECqZC93XlM/jROIGDPh21K8KEpBefkfoexPbEqZ7mcVrHnyXU4tWyoMc8Q26Y9Bon1tEM8sIBxo30hAjRbpbLIjz7JxVs1DX3Q/2zwfmnPUy5DOPiAGklXaWpTIqjGuHZirYRLqbbwrccGoxK5vHdGL7FaQcLSKHWt8xNEJiJ4neMg7r6i2XBktG1SFUSctE+N6NWn2YRZjidONL8jaSr4CNBsftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6lGiNF8b4KMP2A15Y88Et6A2LCH1KConQNq5GnxHMU=;
 b=OAZPml9FHty5tdKllqFcv4aZZgq0DjRxF2V+ImgTP6Mhab97gHy5zR9m0fskatdwx+Z5gXUMdfepGFg1HgwPbrlmb9cjV/bGiRrUVIX6bwBWO1m50ob1Bya02m6shzFL7BSIaGgCyvBVxhlApsik04FL+x1Wzt2+hcF7y8m5lqox/YQ9MUxcdW1i5oVjazcNo/YrziIepRttsOGRpmS/CsFTN6XDSL/cWmlxOIwfXdSk87JquPWqAfIz6m0AEk4qFcEc6ciN28aHg17CCwlPQIhFMUvuACtymA98gagWd+8o/8hAnr4hvu9sJcqRKaMDPY271vJt33J/irAa1JSUNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6lGiNF8b4KMP2A15Y88Et6A2LCH1KConQNq5GnxHMU=;
 b=AsrnypgCujVokewBLGN3ktow9A6M7d9LZxlXtMcwmqlUOc7HoAf2nzhrBeXCxm5ByynE4ZeX4inmfIT5NV6CqcSMjjATBJeZXqsx6npzxFwB0oaksVlqo6ssUETstJxKfbxEQqe/wO41cHHcw+5BiT01pVqaaYNn3EqF/+mR9tDHN27diDsCZqxi3gbm5XnYO3J5mdEHzTEw/yMoZkl5hV1hIgHpE8VIAAnSy1LNWzrZnBwqaCoW6rCbc/1S3ApBvXpsKNcslmTpmKxrYs0V+TEgxy5+6ERzXRipCArPE/g5jGvzi1SnhbySwxkXg0V6FEBHeHvNJnE+fSP9JE7ZIw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:23 +0000
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
Subject: [RFC PATCH v4 02/25] target/arm: expose all non-res ID reg fields as properties
Date: Mon, 21 Sep 2026 12:32:26 +0000
Message-ID: <20260921123249.1708067-3-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: f62377a3-06b1-4e4b-98d5-08df17dc8698
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|3023799007|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	HrL6+tzlIw9APLxCjmC5UACg8ffr+J55RgiphEmEW56cuV7yqXJNCDFcg4/fSHmnEnUXYIKERmisflWpIrrbTKonl4zh9NrAsr9K/BYX4VNTBfe+RFzWoLQca18fHiK5bzo0RguEYZOiCW8O8lC1BZr556sRD7zK8yWi7fmLQUFfRi/3zHsJyu3J+xmrMwaiXVtDNrQh8ckSV59BNXZijNL7PHbmZfgOpZYMngIntN+KRcWE43kijmicBTgTTfgkmeZjFskRTSVG5RIOZxplGogxti8YsJt9Ms8+YV+m3hLwgIBFczZqTDbvWRDc6c+Zy/6y4/Ylb/70bfhq+qwQYdbp4/AUpeanygCbgrCfGGS99awz36TJbuj7QnG0wGmRLDVtq3BkjWPamrHJZfqFjY6ILMDvgADD9y/0aRvJv0q9I0AQNjuixyN6zI3hWLDSvH30pULeCRQVrYM6ZlEYSZySPWmRC0sBVGW+jKy7lz+t6R5Enk/UI7dZv09ExKWVnlLw4e/lrWIwuH4Aou3oZB0rYt2pX/ZfRt+5QlhMguKCuq3RrFjxJPjN72lDgQQm8gpiMdCGG10jJeYvRbVgXpF3D2FK4vwZaWd3czqtOA/Aepyak884UDpp6njmlYs/e5tffUWZ8Qegxptfn1pB8cNjD2LUct2vlTB5GJuOH9c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(3023799007)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sN3QEqPJZUXFo76cOKI4XfRJzq5U3Sx1fxUplrAR8/o5vOceOswzVKFeLYmD?=
 =?us-ascii?Q?FJaNr3TbVQ+hkm/0FN8qMUQ5VIMZvdDjJTRHIYJFwTmcilD02i/6jUy2yTF7?=
 =?us-ascii?Q?qYK1+NGXKtWL3rld7mHqA3hbqLHOW77GnfCEWj/8R9Y16yCDNb9vnqF/o5H7?=
 =?us-ascii?Q?i+SqOt5NUISpbZCfUNHDytuwgbd10OrGCAuOvvNaS3CEWm4tKoYU5gCMHTN2?=
 =?us-ascii?Q?6FfEcLpNt5Q9dlRxAij9/wxcJDYf/Gr5hI2VYAKkHX48Q1WjSa8Gj4DpNVRY?=
 =?us-ascii?Q?tNHNqOYAxR+uJ/LRrloWg4PjQTpsVBXH760fOFiPf96v0PfruGics67mXADg?=
 =?us-ascii?Q?PyXJM39QvF++0KSX95KffMJin6UzNxOq8frqC5ZzqKAF6hJfwwRUKWnF1JVz?=
 =?us-ascii?Q?XIS5hRRAvnoJIDZxxqdfAHXy9b36ZUvV/zqTPVDMwUrJy68Ggu737fUW/egw?=
 =?us-ascii?Q?UZTKZ8eq6wiKqa2/DaUtDg/ZSt+MwIfqSAYMP42f33oCuQXqo4Wmsq8YOUrn?=
 =?us-ascii?Q?PK5sdoXg2CQkwhoEbvJqttNFXr5Y3mm6gl/p8SnoTSbhqgc2hwfOas5Zz868?=
 =?us-ascii?Q?h+XSrKpu3qbJioysLLVlQuLuCm4i08u42gtkz0I7QBWx13K1NryPt1TMhWvt?=
 =?us-ascii?Q?XLzveDhKJjmx2w2ytG5MCevG/bjxabcHmFWlOiB1wCcCUqnHbmLVo6Di7QFh?=
 =?us-ascii?Q?kAjS71L2u3GlPrPqq7mk3k6YN4e3DoeGjbsuBHr5I373eXrLGPzZffIzH1XM?=
 =?us-ascii?Q?DvAOP7H9t9CGwXZBTNLILYnk11YIXETsSmZQfKSnIwdKtCIuEKjKdKI1S9SF?=
 =?us-ascii?Q?CseEWnccPGAwN3JukEz19rTQQ7BZgpQCUbO8VLavq0GbpYlDkIrY1fLrtcmZ?=
 =?us-ascii?Q?oLKMMS++gKzFzQ6Z0er+4143aacEJ4/zRN7gQsyiT71RtMNv8KwvnqugVlpC?=
 =?us-ascii?Q?CQPl31ilR4h6drHPvSXu73yy1gpmfEOP2RpRS9IPRcpPN7uiHgKj0L11Sqj1?=
 =?us-ascii?Q?O0itEXMDc6HdXYVc3LSBcUZUhSq4qaPR/M7Nj9veUGm41DwC2g9hXTaSOE7s?=
 =?us-ascii?Q?bliaAEmWbOZn4SsQVy64CeE+t89XSLr+3M9Lv3cx+B0sR+49VJ4DWNyUWqMH?=
 =?us-ascii?Q?PP+dR1Suq0t0ZY8zB0/px+TyAbqYS8yboApwCp/qnJuX2HxF4ROhweX/Lz+R?=
 =?us-ascii?Q?VGnUvTOTQitH5agkY4bow0nJ4HNzFRRgakcBXUEpYum7LKFr8tFeaCwyU+QO?=
 =?us-ascii?Q?dwT6F70IHoipapmuvu3SKEJOkLTppCSZZ6TSu3u94S7eailXIwYa8OVRoTmb?=
 =?us-ascii?Q?wRPwFnVQK52E1EuJTC3HFh22NzoAoIwJWxwUF86f0acmeQvboZhWymMIIAV8?=
 =?us-ascii?Q?pnExbFwaaMgMVUIK+LcaQBi1Fc7+tGxNYSXbWUtbhB8xTFaMb795cXwSNGdx?=
 =?us-ascii?Q?HpA64LlDSQs/Mp87tF11lupC2k/+0yOpd34oCZxydEMOagXmcMRABWY/6iWr?=
 =?us-ascii?Q?JbHSuhT3D2XjqKwilIBVNqS5uYmo54DEtnb8zqaHcp1rgpaibogOUxRNG8ht?=
 =?us-ascii?Q?wFZ3OEMVBLYE7arqrUCbcoKsRtG7QhqYfOtLM3xL2+lC9HbicmNihsWT9eju?=
 =?us-ascii?Q?KVnJJQna9eQVQGyazSo5c0Cw6ALDERLj9WKfE+Nj3UEQyu5tF3zocgZLODAI?=
 =?us-ascii?Q?FYnu2kwIjilhdW522ySffbgtb93sOFFxnJRMLkxQQKO2DiJXR+Pz1jd9gKYd?=
 =?us-ascii?Q?AW5OP2PO5zYEj2QHXZrf/OwGTamDipE=3D?=
X-Exchange-RoutingPolicyChecked:
	z8o07EDFG3PDLJMU7AEzxkw07EOIYsoC1NE8hQKRz47h6ps787YPfmOqnI53luIATxvLBG3LZ4xe5/YP++8ZYAq43Qt3KJVpSx16eyTwtZRWEVlkDr22OW+q1oBGEFQ8e7UAE9r9ZQ7k4mYndp1NbxrNwiu4zGJKR5knWvGF1zPVj0HxGHk1GE6YBz8791w+AO1oPEKdQ+mOaxFIgseAzp6z/VU4O6J5HP1T74Z9Xo441nUDeyui1yZFaPrnPUhkDA2PuGlp7BNj42c0YF+rSTVtjQCDdm+kOyDciQ7ACqJ8AoC9wp2SfIhqahJgYg0Ab8cjUAyPVyS3PcwhO/bGfg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f62377a3-06b1-4e4b-98d5-08df17dc8698
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:22.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpyKJCBn664JURcw1j2hv5Lt6BS46V6SuSZ2bM4lb+SNPlRC7jpVdMmE/6yiQggmhYyZ5oFlijs/yytbm6WbmbOjN/LYF4R4pfG8uiu6XCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab1241c cx=c_pps
 a=0aASrZ1Sr5nz2ag1/hSaPw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=uJmLQrER0_B39NjpmJgA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX5vd1F1COeREo
 wExZPF8JmOTQfv2HW0hldlMpLqqWx76up6oIEuAEuxn28yaU3d4mXEBDNXz7VKyyhznNRGFl/+6
 3VxrcgSYrlU5pxIG+3omcgCiCcyhPNo=
X-Proofpoint-GUID: XXk4ctmf5atuOa7c-fOAhjbaMzK_nA1m
X-Proofpoint-ORIG-GUID: XXk4ctmf5atuOa7c-fOAhjbaMzK_nA1m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXwecr9wbo2bOr
 qo2CUFMEdoqZCJCeGO7mhTQ5AS+KQJ3U4lDXUtvo7V85hE49nZINOegHkwrTJGaWgp8QXyTKOMU
 DDXq6Lgp02qMlLILR9GBerJ/n8JmIgGfS8GFkj9eMN4ZVbNIa+m46evgY1xMh4mj/ZfyEVtm2/7
 Oe5uXCJvm9hV2lHHtDqZqCfdr3aJRhNY3MjL+CdWLBlGSG9w648CNkEr9OdiDLBT8Vcz7cManVs
 w6VUf//NbSc3tFuLt1U5j+frN1FfPweZz3vk8DRQhMsBr/8VgkDGa/5yKSpTI+VZnoHB2XqsIvs
 WMHJA/nP2Ilxn6ibohjxAIAw2+Dak+Pty+P/o5ydMWl+Zw4Vuohb5sHj0/pTURaoLrMy6oyyXzM
 NWXHlu+EQCqXgHI8vrQMAAsz7swwQhV3LuBDEWnraKJdgmJ9wTqOG04EUBltkerybqc3cMxLtHf
 bSHf6Tn+vBQ+Bya8crQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Upcoming named CPU model layer will require exposing all the ID register
fields as properties.

Furthermore, this exposes the host values of all ID register fields
to the management stack, which can use them to infer migration
compatibility constraints between different hosts.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 docs/system/arm/cpu-features.rst | 34 +++++++--------
 target/arm/cpu64.c               |  2 +-
 target/arm/kvm.c                 | 71 +++++++-------------------------
 target/arm/trace-events          |  2 -
 4 files changed, 31 insertions(+), 78 deletions(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 3a07a87bc3..62bb2bd999 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -34,17 +34,15 @@ running guests in AArch32.
 CPU features that are inherently specific to KVM are
 prefixed with "kvm-" and are described in "KVM VCPU Features".
 
-2. Additionally, the ``host`` CPU model on KVM allows to configure optional
-CPU features via the corresponding ID registers. The host kernel allows
-to write a subset of ID register fields. The host model exposes
-properties for each writable ID register field. Those options are named
-SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those used in the
-ARM Architecture Reference Manual. Their availability depend on the host
-capability to let the userspace write those fields. Values set with those
-properties override the initial values retrieved from the host. They are
-written back to KVM and the eventual value applied by KVM depends on whether
-the value is sanitized or not by the host kernel. Then those field values
-are likely to be overriden again by legacy CPU options which apply at the end.
+2. Additionally, the ``host`` CPU model on KVM allows configuring optional
+CPU features through the corresponding ID registers. The host model exposes
+properties for every non-reserved ID register field known to QEMU. Those
+properties are named SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those
+used in the Arm Architecture Reference Manual. Values set with those
+properties override the initial values retrieved from the host. Whether a
+value that differs from the host value can be applied depends on KVM support
+and any field-specific handling in QEMU. Legacy CPU options applied later may
+override those field values.
 
 CPU Feature Probing
 ===================
@@ -534,12 +532,10 @@ Note that this is currently only supported under KVM, and with the
 Querying available ID register fields
 -------------------------------------
 
-QEMU will create properties for all ID register fields that are
-reported as being writable by the kernel, and that are known to the
-QEMU instance. Therefore, the same QEMU binary may expose different
-properties when run under a different kernel.
+QEMU creates properties for all non-reserved ID register fields known to
+the QEMU instance.
 
-To find out all available writable ID register fields, use the
+To find out all available ID register fields, use the
 ``query-cpu-model-expansion`` QMP command::
 
   (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
@@ -554,8 +550,10 @@ To find out all available writable ID register fields, use the
    "SYSREG_ID_AA64ISAR0_EL1_DP": 1, (...)
    }}}}
 
-If a certain field in an ID register does not show up in this list, it
-is not writable with the specific host kernel.
+The presence of a property does not imply that every value is supported.
+Non-writable fields must retain their host value, while writable fields are
+limited to the values supported by KVM. A configuration requesting an
+unsupported value is rejected.
 
 A note on compatibility
 -----------------------
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index e04062e848..3d522bf20d 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -809,7 +809,7 @@ void aarch64_host_initfn(Object *obj)
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
 
-    /* generate SYSREG properties according to writable masks */
+    /* generate SYSREG properties */
     kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
 
 #elif defined(CONFIG_HVF)
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8a823d0324..2f6c090e43 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -365,19 +365,6 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
     return err;
 }
 
-static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
-{
-    for (int f = 0; f < reg->fields_count; f++) {
-        struct ARM64SysRegField *field = &reg->fields[f];
-        int upper = field->shift + field->length - 1;
-
-        if (i >= field->shift && i <= upper) {
-            return field;
-        }
-    }
-    return NULL;
-}
-
 bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
                                   void *opaque, Error **errp)
 {
@@ -493,69 +480,39 @@ static void get_sysreg_prop(Object *obj, Visitor *v,
     trace_get_sysreg_prop(name, value);
 }
 
-/*
- * decode_idreg_writemap: Generate props for writable fields
- *
- * @obj: CPU object
- * @reg: description of the sysreg
- */
-static int
-decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
+static void
+add_idreg_field_properties(Object *obj, ARM64SysReg *reg)
 {
-    uint64_t map = reg->writable_mask;
-    int i = ctz64(map);
     int nb_sysreg_props = 0;
 
-    while (map) {
-        ARM64SysRegField *field = get_field(i, reg);
-        int lower, upper;
-        char *prop_name;
-        uint64_t field_mask;
-
-        if (!field) {
-            warn_report("%s bit %d of %s is writable but no named field "
-                        "in target/arm/cpu-idregs.h.inc",
-                        __func__, i, reg->name);
-            map =  map & ~BIT_ULL(i);
-            i = ctz64(map);
-            continue;
-        }
-        lower = field->shift;
-        upper = field->shift + field->length - 1;
-
-        /* Sanity check the field is not a reserved field */
-        if (strstr(field->name, "RES0") || strstr(field->name, "RES1") ||
-            strstr(field->name, "RAZ")) {
-            trace_unexpected_writable_reserved_field(reg->name, field->name,
-                                                     lower, upper);
+    for (int i = 0; i < reg->fields_count; i++) {
+        ARM64SysRegField *field = &reg->fields[i];
+
+        /* skip reserved fields */
+        if (g_str_equal(field->name, "RES0") ||
+            g_str_equal(field->name, "RES1") ||
+            g_str_equal(field->name, "RAZ")) {
             continue;
         }
-        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
-        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
+
+        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
+                                          field->name);
         object_property_add(obj, prop_name, "uint64",
                             get_sysreg_prop, set_sysreg_prop, NULL, field);
         g_free(prop_name);
         nb_sysreg_props++;
-
-        field_mask = MAKE_64BIT_MASK(lower, field->length);
-        map = map & ~field_mask;
-        i = ctz64(map);
     }
+
     trace_nb_sysreg_props(reg->name, nb_sysreg_props);
-    return 0;
 }
 
-/* analyze the writable mask and generate properties for writable fields */
 void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
 {
     Object *obj = OBJECT(cpu);
 
     for (int i = 0; i < NUM_ID_IDX; i++) {
         ARM64SysReg *sysregdesc = &regs[i];
-
-        if (sysregdesc->writable_mask) {
-            decode_idreg_writemap(obj, sysregdesc);
-        }
+        add_idreg_field_properties(obj, sysregdesc);
     }
 }
 
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 71a2f5770c..7696a8ed40 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,11 +15,9 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
 kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
-decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
 get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
 set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
 nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
-unexpected_writable_reserved_field(const char *reg_name, const char *field_name, int lower, int upper) "Unexpected writable reserved field: %s.%s [%d,%d], skip it ..."
 kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
 
 # cpu.c
-- 
2.52.0

