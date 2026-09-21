Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6500A49892A
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994040; cv=fail; b=oMVXyhphxSzG/WQgT1/ryd+mmpMrSTOCYSiC+Z+VoKNHblsdSO4DdHH1dwVU51SCV5n5gLaGlSxsjSaxZaUiqzkHkVoFUut6huZmt+VZcvXStyM9SoysYaZKV0sRAROM+t3oQS5Ucib8ae50Yte6KhqXGezJIqxK6cjGv21YScU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994040; c=relaxed/simple;
	bh=PRxXqQ6HEXdeN1i/ZhJ2XnJx7WzJs4uRH2lDxcFN9jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PKHIdq07OwDmXdFBDu9Wz6NCX8kEp8Jg4F0zeS3wnMj92H8wLVbKUs0vtuj2QhfLqiU/qNyqKnQCUT/Zwz0KMqbouqoY49w1h8QP02pStJyoCaDVLVyN5KeKyZG95eksZ4S1cZO+hXfJDJZObLUNt3uAKBQVXqFq6nDTx3RNUjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sOfez5HI; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=R3sp1Twj; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sOfez5HI";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="R3sp1Twj"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAiHkd520340;
	Mon, 21 Sep 2026 05:33:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=L01GFWY2A3KEGs6JhDwuiEz2yT7cbZNlHBFfzyiGx
	z4=; b=sOfez5HI0jSc9khThN/+IgV+KddMev1q9i8pfSR34R8mRahBjzpV5B0+u
	QajR/qzGAaVMWKXzYA4GGRdbOqLhgUz8JSxLMQZ0fXBhM8UO55DourHwPh4Bgjwq
	sZCk1nsUX8dPj5PRwUdB3p5jpMH18DGX7Lq/FfumVeX5HvEcylxAYq7f/6ruejuo
	m7RFrm4tJ+j7W5FLuZLNK684FgEWpxqBtmM8v/GjWmI9a2uyNV3j3woGXPEXfvLG
	7exNRbNSocq8YCTaJbJNFxRi1PWo9g3ZngENU+PNRQKLJKO2pIOYUBzsdVBz5fXx
	LjP5jhYQIX1UxVvIp1j20URWmSp9Q==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022131.outbound.protection.outlook.com [52.101.43.131])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspqsbhps-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uqL3lc4Ywdm7TNnG5GGZwS3HWKukKm+I/7M+33O9HkG6si2ka2+YhZsj0LmSosokUEXR9aILCCRBeZGh1g/FZjBGiaHTT+skZrMpSD0naVIJHu0Z4tTOfmEsc2TtTo0uDUm3P5v5729ppF/FIQf4X+fMUOmfdGMpPkTIk2LisaP1sRf0VEvKx+FAsPLYHTB99gS///aaIG/PHSGxgmMgttX4OtSvwRrVIxVD3jM/jU3BUwgKROiMcn//NQJEVfEkSyql7QEOVBRt9pWkOXyPhCgUUBqBZfw4QBv28EvczVDe4xEFoWdeqFZSdp+6C8uDySUwgJyEa9tQjK3d4PZndQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L01GFWY2A3KEGs6JhDwuiEz2yT7cbZNlHBFfzyiGxz4=;
 b=tLBctNbLRi8imxhwArzluM5uu6ig1GCRObz5mtN/LoX1pyy17POA5cF81KKNgtSORs8NV53HOwU/bJbyVOdcCUJhjUgrp5gnyNKa/7IcdUlYCHQ05h864gCW/kzMpTkngxBzgqiJQqPdsWYexFbW7VsTRkRJBXXfd2f5Ks32pkb6rP4nF0G+Tfj9Y8xY3I4tcR9C8GNuZUclHnCikBdiLZMRlHeO/ljS/BpgzVZrOwWPXbK1YJ+UmF30NxBR8ZEVW3Jbg9CDF977GuFk0RsBUUx3mzR01Jnh7DxEV8xGfoCK2l23eJbOMUiuFib/pYk8IEozdVobYfEFyJZtSjvTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L01GFWY2A3KEGs6JhDwuiEz2yT7cbZNlHBFfzyiGxz4=;
 b=R3sp1TwjyY1iepYu1JKgaYOIUaTyH4STiMaGi9gtvBbT0slmbqlxflzFsH0yFKxJMO3tPW8AbW6nul30hK9ypalACY1cl4Aba+U6/va/stuFfsSNTjdOAcZpew52MIpsCtM32hZUSm1VZqlz4ud0Nm3iORLFSAiRlm2mALXcZHOLkNUAUf4sc4hjN+5Q/gdxBuhTJLOL+rTzko1ytiIGwnDjhQ53qeHAbcWPTPiSqCIOuQ0oaxo01cWuomRjHPexxtYSOVjHkj8ba7DTKvK45W4ugJzqOQFlLeWG/825RQpZWbNX4su1QToroWtfN6vb9ewJwVm8BRs92V86cYss+g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:34 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:33 +0000
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
Subject: [RFC PATCH v4 14/25] target/arm: add neoverse-v2-v2 named CPU model
Date: Mon, 21 Sep 2026 12:32:38 +0000
Message-ID: <20260921123249.1708067-15-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 86364172-7512-4fed-4140-08df17dc8cf7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yrFWsvDlgRsqnkGSvJYN7d2gsml/PWZv93g3zyJ9pBgl9AGJ0wO+Nruy2vjcNLMGo6ErRzCQfSvm6YRaY9CrVM4KjzZQJm223C2T9jEHlLvy2NnU0wEb9I9QUIWfs6ZaRpWM/viyWM/JTgrke7jTMaYIZD0VpIZPQMD1omD9IJ/7Wp244qN6YoSIUqv1vdmiXqKVcMpp6WGIdsS5RAbkeYN7BCfWsUfTLwWnM1c+SaVpymhSz5Sw08qASrbHuj4ekptvXryCbC+AdJ+LCV1ssjh2WacCK/zOe5AUbxvx3tCHU1OM5Yo7jQPV4CpIU3S4MIHJZi0+Aev3+FiYFd/qLWsgxuq/EPD/A35KgQvND6qtCzJhnpYTVPrR2iQLXKJY0ySegDoq5eBM55NPdDq7BTpFnyPnP0sFYseyvlMEweJFgwLvO4kQu9TeVGGtjpncr025WWbVndxQ/cs9XQOt3ZqyfjlFZnHRIgfXg/7aF+Mi5AzWDhIvyIR+ncV/gkWT+K5ToB4vA0oI/FMdHlTdtfRAJ1eVvdflSk+qozmthgOwqPNA0bBlCS4hkEBF1LjD1CUZzceXVsSVWfqKqMSapQYXCd6B9eSIBQQBR5YMUHRy7jlmbPEPrxemNdhw0z/68ePYTZPtXYnKBBJEJ+wMduuV5+HGZL0a61ZeXR2kKrY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aU0jQfdEbzFIcAAICF2iDv8IDou22vZs86jz5zqoJFOBMuBIRKpi2hJ+3A79?=
 =?us-ascii?Q?SRLbPXGDUYKw2EWuO+CR7moG0zsl4elN3jVPirRsvtRAOfLnC4vg1vfB6Gk5?=
 =?us-ascii?Q?zxU5VsklRcvTroJUxpyxPnxCRMitU+9IAyhBwhP1VAGdNvAZC4UA2DpXBZC+?=
 =?us-ascii?Q?GbSYYfgfopIZdsp+q/un/MzZ3PB+Jrt49Z+yNDv7rCGCmyZOKVbinnCXQxrF?=
 =?us-ascii?Q?Qrjgb8X5+9o9Ijj4bH9U2QEBY0V0fiJc9308qvcjHfQelmo9Xe1yhBOIB+MN?=
 =?us-ascii?Q?DqcoFB8M8XLES1cPCds5gFwgxWxtRjMYcz2uA8GyvaJus1V2fNjOIc5y+o9C?=
 =?us-ascii?Q?wuuEAgI9OeAqNPYgy4eCWpkegDKs4PJ7RWolkBvo9nGc7N0GKza/MAh72dgw?=
 =?us-ascii?Q?zTsZWCqRrshl8vYJAGDB/gCO5C6QtcU5VeXpw7sPcNmE/gR/UfOAUZf7fWZw?=
 =?us-ascii?Q?N5rm00NRiUn35+JYhRvZkJhMBdDeFF+kGA2S0zm7NmATMUzylS5IyHlBFmwF?=
 =?us-ascii?Q?c6qAeyY4khtTyEwbvox88pSRwNUS28krU4qA5z+EqLdMLM/Jq2cBq/h8s5ZS?=
 =?us-ascii?Q?BGosd+zZ660MlOx6r86tfIKG9b5QMpn4TkeI3x/3yeme2ymceHWrLe0GOG3s?=
 =?us-ascii?Q?XX3dvpL5a4SJONmT++G4aSlk5dBt6cHKYPQ0qOMMNUMwDbscgs/+fLev/IxQ?=
 =?us-ascii?Q?vGy5MHCn8Ed8rMNkDRVLOLhWOAJfLjV8I/cho/+Eht3IZQpkKn3Zp4d30P3w?=
 =?us-ascii?Q?nemT+H99wgw40idYLLF8RAW6BJLsIUKsve9Goq7s8ZpyPanQzO9cxqVE3sGD?=
 =?us-ascii?Q?lyZPAmsEWlYV7VL8Rpz9OQB7AKHydzC0c2dFSNH8EutdFECQv91kCBApXJ85?=
 =?us-ascii?Q?zqx4jPiZFd4sF8Db3xZ0up1g+wnCLB36rZebuPaWRFX8bmPF8CizMOx3sb2V?=
 =?us-ascii?Q?Vk8YuqxR9KX/dGJaDYr9VxbFT3leVhRLpWtaz6dakXgd7yOqX2FpRu3Vllsk?=
 =?us-ascii?Q?Nt61iUTf2sBD9Pggt/aKzP8TotQw2meCEC/4T0n9c3kfFtfRduwyTrU9oWP9?=
 =?us-ascii?Q?99rmfTzn4D1yK1x4rYs7N0y3FZI6GYpVx/3stjgqdPkRC0sMolCZXYSJCj7C?=
 =?us-ascii?Q?/nk+YSmGKIawKDfIIOnl2yxya0FH/4M9gCXBsIwyIIIvaj65chKjM6UiDGaq?=
 =?us-ascii?Q?MhTEVzfUL9KFX5LjbqSGzP3yL4bL78J/ZRDpqyy9vPg4Y+fZw0yjFqRvq1mk?=
 =?us-ascii?Q?Q1bB+1b0KfeN+WMLnvH6lejaSLDB7NlY3GOAOxmuOK7vaH32xsZBgd/cEDZr?=
 =?us-ascii?Q?TAD6NnLgkludQWXwDeGQbXwwYo9/HMXDZgCq3dVNTSQPdfyRYiwWFfNiI2Dx?=
 =?us-ascii?Q?p+nCDqeBPHPPdQHUUpxup6umlT6Ab9niJ1VedM5UNiCCuqJAFObUX3IxMukE?=
 =?us-ascii?Q?JYix4r1jVwJOQY05NHqJ/vaJJNnw3Hoa+DL8nSf7ltj47T7MIvQdwU1iqHQU?=
 =?us-ascii?Q?YNZ4pyFI41nS4x+cppEA7mQ16EKb7mum/RrOksQypAOjRKAHwgRX1okPgRr1?=
 =?us-ascii?Q?Q3Vw/XUEs0A1HNbOvpZrW6bG21384GrLL/LIWZmSf6T+zBDVwf8lU+LkoDZJ?=
 =?us-ascii?Q?WTPU43J7mN4/7naBxgBtU5s/UfUwR2D2vfaQ0gBWWLNVnr1z5aECSp5ZdSH3?=
 =?us-ascii?Q?wa0agro/6rN3chjDHYNCyaOutxDsCUR66prsFUVpNsJ8Ikkec51TeBQCBT7N?=
 =?us-ascii?Q?yKjkd7AqTw084DVFmWimAZ0orkTuTWs=3D?=
X-Exchange-RoutingPolicyChecked:
	UDJOJfZMwZb24kjc9wLBrvVvmECrUR35ErpMJsb5rOp9CGrBGQCzHvTV7uvVUTnwSgS0BeInpnikmCvJUt+OVxR/KcGmpeT2NpeTqOeobDC6LxPyJaJwHqWzxoZmbd9QG0fUjeet5tx5cSgxtz2wvgP5x3gXlaOzbas+pMkcFY/DgFLt/iZ4Gl6VQqfaoSiQiPg68wyZcVqlr+3XhgI+mOOmB1ZNvrBCSEWkMJs8aYRJxbv4/qclI0wtlHqVwJ13jn4saszDKBkqIA/ApM0RD4EN4Yx2yqQx9eoO1GjU6DXHECZEmghgCSQASr5iQIMEllmaGxX+46fhbIMEjBei2A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86364172-7512-4fed-4140-08df17dc8cf7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:33.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnMxojvQi3vYCp59CGY8OJLUUAnD96XIfE/8FbboOw4cmCHj2gkBrJJmb3vVICwY06sE15e34Mhj6QLDhv1+YI1/YdjCNdofXfAynQJwTQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXyTfgkeMBwZYm
 MPEm+jDEWqbwqrFHb647TIjmkbclVWEwJ1u9XktWWRJ1jqx3zLjOfPLVw0x3ITuoMbqMaRJkbEO
 EN5vaCGhCN+beI8XsvhoHGbTpFcu7SUPvCd9JBjheH58CGQOZmLM7LsM5G4EL/XlxuVXez/MbKQ
 XwnxwpRMZrptjZQQ/cU0SwbD6UJWFGRwndm2CQbohHL1s9MtKWu8orPCkxMMio6+wo2W2+WibyF
 OODH+P/UCy7e2jP1779PS0Wb0oGOWVs1bM0YjNuInLbF6aOYopNi40tebyH6Tm01vkhjJ8D6KsM
 wWAzzB6kwmBJqEZZJQHOQM20rUyhDDA9UVYr8PkF/DXtFhnqdYQ/s/ZGFKymjoEx4Ih5+a2Kozb
 8+Djh3aaFnFha1Gc1i1ps95v5TIqzFNovFp45LRZkx85kD7Boo/UbK4TYOTkYou1rkOR7jEM4sd
 O4fbF4NPz15ztYOpCCw==
X-Authority-Analysis: v=2.4 cv=E9BYNqdl c=1 sm=1 tr=0 ts=6ab12420 cx=c_pps
 a=WiodiXt0wH02q4ozJLtFAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22
 a=64Cc0HZtAAAA:8 a=G8GmB4WXMLr-IX6zuRoA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX/iqZXuYrzQqU
 2qV4RSqIqp2pv7t0etC0ooIOT0DF30WDi3qXaGCM5Y6UBBopl4Z3FozusPSMAHCETOyTQhMjzIT
 vbihCMe6EFDiz9JGEW87zuEmrfjGtJ8=
X-Proofpoint-GUID: CYQblLNSaQXY4StORWqMsjyztgmF6NfF
X-Proofpoint-ORIG-GUID: CYQblLNSaQXY4StORWqMsjyztgmF6NfF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add a KVM-only named CPU model for Neoverse V2 r0p1 (TRM 102375),
inheriting from neoverse-v2-v1 (r0p0).

r0p1 only changes MIDR_EL1.Revision and adds FEAT_ECBHB
(ID_AA64MMFR1_EL1.ECBHB).

Final ID register state requested from KVM for "neoverse-v2-v2":
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
[ 16] ID_AA64MMFR1_EL1         = 0x1000000010312122
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
[ 44] MIDR_EL1                 = 0x00000000410fd4f1
[ 45] MPIDR_EL1                = 0x0000000080000000
[ 46] MVFR0_EL1                = 0x0000000000000000
[ 47] MVFR1_EL1                = 0x0000000000000000
[ 48] MVFR2_EL1                = 0x0000000000000000
[ 49] REVIDR_EL1               = 0x0000000000000000
[ 50] SMIDR_EL1                = 0x0000000000000000

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c           |  1 +
 target/arm/cpu-models.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index f5a8ea1145..90e818690c 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4147,6 +4147,7 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
     if (kvm_enabled() && target_aarch64()) {
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9.0-a-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v2")));
     }
     if (target_aarch64()) {
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a53")));
diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index 2de67f353b..af60924953 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -16,6 +16,7 @@
  * Current Hierarchy:
  * arm-v9.0-a-v1
  *   neoverse-v2-v1 (r0p0)
+ *     neoverse-v2-v2 (r0p1)
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
@@ -212,9 +213,21 @@ static const ArmModelPropValue neoverse_v2_v1_props[] = {
     MODEL_PROP_END
 };
 
+/* Neoverse V2 CPU model (TRM 102375, r0p1), inherits from neoverse-v2-v1. */
+static const ArmModelPropValue neoverse_v2_v2_props[] = {
+    /* MIDR_EL1 */
+    MODEL_PROP("SYSREG_MIDR_EL1_Revision", NUM, 0x1), /* r0p1 */
+
+    /* ID_AA64MMFR1_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_ECBHB", NUM, 1), /* FEAT_ECBHB */
+
+    MODEL_PROP_END,
+};
+
 static const ArmNamedCpuModel arm_cpu_models[] = {
     {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
     {"neoverse-v2-v1", "arm-v9.0-a-v1", neoverse_v2_v1_props},
+    {"neoverse-v2-v2", "neoverse-v2-v1", neoverse_v2_v2_props},
     {NULL, NULL, NULL}
 };
 
-- 
2.52.0

