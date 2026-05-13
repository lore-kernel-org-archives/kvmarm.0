Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3F54CA267
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690081; cv=fail; b=iPzw22H0AAhC6A2hiGqn/JFC9L3Nn+Am/HoWms6WVKAfwjyxHEHRgzBwrv1r9eAtxhdrjagvC+E/fjkH4cxkUxp6d5gyXxvu/zGG3zStatpP6PN9APlKEabTJ2wv13n9OU9rlBka27o3ku8amoP9eiwPcMCeGB2eqom3PADctXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690081; c=relaxed/simple;
	bh=EQKrGI/Se5/4HbzhaxLHeYjGSbJzPjF20uk4GbBcWvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=optXTLGN/9FvxAgkllskbfylnlVJ9C+r0ygJZPYRht3ScJcUhAXoVkaBLVi2y7NO9ukZiePChpbioyzL/WRFlnCE9OLIOBR5Hb4So5rbfPwMbFf1r9g1QOTkeaCp54ynVoBM/x+KTrtVSIbHC8tITbMUJhgS7rVLLgqjMfCQB3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Ea0M0Ndi; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=XdYqZlzT; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Ea0M0Ndi";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="XdYqZlzT"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKgAr2442897;
	Wed, 13 May 2026 09:34:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=eSWNtzO2D9cGJylkx4I3O/eG73/2+KCOKxV/h7JoR
	fo=; b=Ea0M0NdiGUH4G2a/mXZ2nggYhpUfZPwVZ0Kl6JRZ+lF+HC3uWnXRZ7X6h
	5Ud1vVCf/tLroAdiR/INnxEwdMZAoASvA6S+NOGkcES7i01XiqDrOIpUwAekuML5
	Ba6tpuE7bKcRk344ZKFNhvQ57k1nTRTeR6LvtD6G2rrVfRp7nfKyAAoTviJeAaS0
	yuVoPliosZIIA0GXvdCpv37bq0p+RwK+pfr+bgnvH3JKpNMU0Z3X4zpDU3Ab9h/U
	tm08K2QoWgetB+jw2AtCozlEjsPyE8tKGhZ1wOFKw/5jCYf0o+/sGvDLYtnS2YHZ
	FIPPgu9xkHr2qncqxjQlgvCOOw44w==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023118.outbound.protection.outlook.com [40.93.196.118])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nv6x90v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KY+bC0/KSH5EDvlF3U3d2IDJlzt0cb+Lgpri5rb7p3DxGRKgrRiNu4d5WE6OxCPLiLBQ/CvI9rcf8Ab61kxVjNp87Lour5wAXzamSKAzpfbRhIfGMFMcIQ3j+f7dfLh5BximKoTmhJg1sn5YxiA/vPuTjCxQUquphW1dY3soxkP5gFfOmccYJKQBhCHDeQQvoT7IT6BJFUj6OJU9OtKt4+NdLMnJQJCbKPpkdRp3Yn7DIzTxQZfYh6HnOYiX63cj1d87WmjMT0VBl5CDvq1neiNlT19kJidWqUJ4BUJIWYr3TtVUlgXVR5eqmQmAF+K9JX8rQkOEkCUnC3sogxRptw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSWNtzO2D9cGJylkx4I3O/eG73/2+KCOKxV/h7JoRfo=;
 b=SQKkjaTUJaCuD6T9yzmGyNoFldcOqnNNazR4bAtXkdZeKEF0JYeLQkhK5ai/EDhha6e26HCxqzolbtWRhAqlcZWvLkr7QjtzLwQfEyIPy6C4xTGS+o4qk4C8KvQ+GhSvauzGvVDJuv3JgiHrAXBkALgyB0+QtL6rPWtNDI108N/x/QMth91qTI/hI9G4FVQjcjWcAS7S+U5YzbJTSDST7e9H2utZhkeYW2STmyMXM9eEHHbRmxk6BFchpD5YY08ZEgY2tk5tGywrIYE4rbmoKT8EJ9IpacKjm6boskB26dIkiTO67V1FgOUDXAKV04sOMp2wnQOC6BJTk0QtmAzaFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSWNtzO2D9cGJylkx4I3O/eG73/2+KCOKxV/h7JoRfo=;
 b=XdYqZlzTSEWDnUIugwCaOmmZJ2+jpYbgCxB8JHjQuNbvAW00dCMZHaA0eqpKOmjQwgzjfGTNapV01tAkZ2Nu12sjNmZIfIZUVQe/DfOlF+0q0sjxh43FaSNm1wEN69hxkVBK8iDn18WztkRmaZcnCdtZkJY3a2B9+hbtmVasrk/DZaMkrOySd5sQVqX1wndg26i29lpYGJnNkHMJjk5AAp0LPMSqqI+J/XNhTx4SL95dhlnVT1JSzjkZS7zWwHCDjxMkYuvC2zzUgcSPnjXTy7jx6SU4GzOETU6j6RX9ojYkyJbLjwBYA2GIf2jWukFw4kZjQEqiamHoobANdOLF7w==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:30 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:30 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 12/13] target/arm: named_cpu_model: writeback modified ID registers to KVM
Date: Wed, 13 May 2026 16:33:55 +0000
Message-ID: <20260513163356.3033159-13-shaju.abraham@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:930:1c::30) To PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR02MB10160:EE_|SJ0PR02MB8813:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e6f80a3-60f4-4718-5b85-08deb10d8177
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	jrongxhVcKjd96sOirH+zFeh+tiJyIr8I/iHM1XB3BzM8PmeltEqn6i1MzqgwL+pyIbBuf1ljcm4G5N4+xbxHUp4+i0j8BO5UE1+k1fgHL8Eg0lPm9cJ3JcsD17GbQ31ksCHf1pzJydySsOffm/BRqeoaK5qlyMxqUtiHFZ1PPsH0tBagUJx7VirDJTgK3/IaX2ES5cR3Ypv3rHHZxCwU9z/V0edRTHn4K5DjgXEzOmbwYrT+8V3Ln/NLPwvu6XsXl+fJKlCvX4ZjqUdUelBn/eqwiGwAGmSjlm6c9dJkJtUl2+M0X74ZARdhM7zwAZcPCIdBQ2BxzNcgYJmRdLzYJDUObre5Hia1NGx9yInEJqwAiWSGLPypSUFZjqLZiW8mld1pMzzCbBG7OkaGD120l2vE0HvOlNGdxNZvXkoF80AThNxjjSWlGh3zI7kRDTqO1QbLLPUZMU0+VgNOA1Txf1ku4NiQ3mL1O5Veo4PHlhueUvJPjRlrVGrq1zsqC3TqZ9WW8K3Dj+V3vgrIqzGnF2EuyIphOnnw9Wrlbf2x4IsIGQrLW+FcOXQZu7WIkmyh0LW6fZJsklqul/gQcCOnSTCFLrY0eHzoMgGGndCTeXPLmmWOXJoV0JVMekRb1/Yi0LkDwH0NECtJgi9/qUPrg1l1nlHWlDxqNz7FUtTn4zGA1k2cv8CSV7MBYvHA9IlhVyhBIEReLNKJUCsfp98y1BJ5+k+zX9PxOCH9BaoP0o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003)(3023799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0cxTidyhwtXqliShdIrk2cY5AscdFXI2FhQlHmev1X1vOj1vBmbGUFjuYN8B?=
 =?us-ascii?Q?RnN5Jr8tTNoSgQbrn1/rUjIGS883/EOVgrffrRDTEjukdefUfTUJ6B9vwDPf?=
 =?us-ascii?Q?CRhlZGT5uyXa5yQFIGE/F0Mn0EcSBLAkOo0b3262fj3GWm56pkPdwEC6XjRT?=
 =?us-ascii?Q?3sGOVRYQB1gfsnPmVglyXlZxTCaHhF7RVG/f9/+QdycAmPmRJLRwYraPjUgL?=
 =?us-ascii?Q?xe+Qq/+6W5MfhFeaWUvWSEfgtph0d/Ia4bqxKUXUbTFIksg8mM5xFO0Go5W9?=
 =?us-ascii?Q?n2OIL4/+CPDWw84TdR3R+crAeQjuZ86b+Ze6wnsWTk4wPLHjepGyZVw24T+e?=
 =?us-ascii?Q?2zFNCFyaqCNvpwS3Q0sIPg2VgkT5iqr0O2/cIvltiDWoQXWfzvKTiTqaiNsF?=
 =?us-ascii?Q?UHRfAEwoCuLR2cw0fG19LC0Sz3pGfwc9bQ77lycOqLg04bRmkG0pJfnaKG6T?=
 =?us-ascii?Q?lHN1V71FUdgdZF6tkZf1RmznCIMEr3Q7e0GiiPMY+KEs7uxwkROrskhJwlit?=
 =?us-ascii?Q?hD8983+5egU3dsG2adyYbcmQ68KPoNUYEe7w91pZa3SZUD+nASbC/tTh4wed?=
 =?us-ascii?Q?uX9mnkAFMopEZ7Rpp+JPknxSiM6LB9ptSe2nGK4STWj9WzM7g6ac+wSCpjZE?=
 =?us-ascii?Q?yYHKdC8cFLlmN9QuTiZGBLHHBvtARa7rAM7MLIyDK6E/KWoluY92pRaMi5Q7?=
 =?us-ascii?Q?4G63n0tQvk1pJNU1fb2Y1cdeKQsezpzlOA954RnLTZ+8vhfER4OBIADsPS+V?=
 =?us-ascii?Q?arzjazBn6pTvmRX7P92eqA2TkpThzlESqwhhiwAvh+eywXqkGCaUxZ4iCxbs?=
 =?us-ascii?Q?GLWameVq0A5Fi/AcujKbZo1gtSC63NBSaCiZTe+/Sax0aZlLSKWvjNiY+Eah?=
 =?us-ascii?Q?Wo9eFY28Gh4vmjftaBNgMXwOWQRTWf8xJwz6FM4DrV5xHteyFikLsN/OvHYn?=
 =?us-ascii?Q?TTcnGX+epqEePWO92t+SJ2mTP8jnLARnhhYWEp7jx0OCB4RSfjqEmm5b8xxR?=
 =?us-ascii?Q?QHMW5ubhtRumjdzEWJ6dmbppDF7cx/Z+yAsJGHztrEXm/rVqRczFwpc/1RLT?=
 =?us-ascii?Q?b+uKtneHt+s+ylYawjLL2RejrgKmuLeBRkSZdqRGGYPxf6xA+4je2cIaYv4X?=
 =?us-ascii?Q?TgUGcvJI2RLEfLcVmnNzAddOJe9//BsW+QH3LyPtSNw1tIVgRPkkY2WFIEFk?=
 =?us-ascii?Q?nRpK/ge7qiUqWojlhGdjY1gXlF8sUmXCVt/LguCeR9SskWan4pQ5wchOKznS?=
 =?us-ascii?Q?HL2VuFiIZu+VsvPVO6xv0kf4ofkLRWsL7HjvRp7uHtD6/AtRlbKX+E+QDEGb?=
 =?us-ascii?Q?E7psFBzlX3cX5dEkg25H0mOZm8/Gmzb/Ghl82keMou9r28b2LcbOBasJT6Tl?=
 =?us-ascii?Q?+/+5TyMUViLuOM/3cZqR8MtAlip0Zr1SKFK6PzAYlnYNxSvJhjtKvwZo5PAF?=
 =?us-ascii?Q?FvMbDs4m58NzKvjGT0FL2G2NLed4245Z+i8N6AJ1KUYgXBYFVBv9jFy8+lSt?=
 =?us-ascii?Q?ag2kT21etBzdYTfIXIja46dQ/9vfNkqEf7VkcaR3lBUo/6ywNQJ1oKX5C2mN?=
 =?us-ascii?Q?wllCD2X4xVjeOIuzcJcxJOiIJnJOIP2tCDPj6ymQviU2WINt1EORY7u0+1ey?=
 =?us-ascii?Q?NrAUBRoHGCMf2ntWMn61RNGyb0PwBnXGROLbO/sfo75GR92hdv6WwRWG9Gis?=
 =?us-ascii?Q?jnz3FrLe2xKao/UEEZKPvcCIIpf1AFlK2daglaTlpErsSEbxi9Y1m4z9BeF2?=
 =?us-ascii?Q?5I8D8C0MBgyLlESj1vLJDnm3hhFbGNI=3D?=
X-Exchange-RoutingPolicyChecked:
	pOnHTBAnFN/NIgj41oMAsuEIdDROtINsZhq5EuujmlsGf/Ir1gMgtvKbQ84HPMvVEjER91stLUDrcPYmUl0EoojiD+ztsP/j6hOwBr375xYCc05TwWFXkDfD4HQWARXp9PVlJ/KJTCqwSRYv9em7UaxhpTEVRybtUC+eXFBl8KpPhYwIZ51n68Ps7em4AcL/byhj0TLd99AWmNkextA41tAtH7duxS0XK1RehNR+mlB3swBSH09a+totpjlPKZZK2CrxQYAUeT4HF3l27VR/b7buxb7as/1yFP7m3anFeMkUS/VFCMu5VUXNkb4xWFxYAIiZohU8We9hy42vPaWWuw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6f80a3-60f4-4718-5b85-08deb10d8177
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:29.9664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+tvee2HEnhfQfPfKQPMBCQQcpt+8g4CMPrGX84Kv4Vt9UT0IKnXMiG8hxrZKaJ/5XMfR9Y8WkjxB18B7lizcfIx4L0OCNdtP0SbLsozGGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-ORIG-GUID: yR7C-Ljm3IiRAysimQ9kY0Vcr8amwbE6
X-Authority-Analysis: v=2.4 cv=P7QKQCAu c=1 sm=1 tr=0 ts=6a04a817 cx=c_pps
 a=emGy3M2YSyErp0/4l4UmgA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22
 a=64Cc0HZtAAAA:8 a=0aVVV3pfCXYwIWacCPYA:9
X-Proofpoint-GUID: yR7C-Ljm3IiRAysimQ9kY0Vcr8amwbE6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX4a+c+EvUwUuE
 gDQTE2Gu3zsS65qRnTvUKyz/HlkT6pHGCiwCnmlhP+/YIr8s8uA3dsjD6zfz9kmL6EUcsC0dG0s
 LERW8TMFAlUADBuMjZ/ZWqCcrMppQhtdlSIga5BZBBZKVjkmnlKFtzUyncE+NhGiPRZh7kwfRss
 wmr+lCVjkIXMAxtTpxT1uxbtlj99D+WGXsJ4A5Rm+pBAY8Ea0An2HOPBB5WuLwJT20JpXwivCKB
 MbDHel+iPtziUkw10so/lu2xB3wiwj14g/DO3CeHiynCJtLtbqdeAQzzWONkJVoUjvWyyb8GPeV
 PrJK4swrJ2sdU4T3xsGAFmPNYRLpX+zMMijellq3+rFk/upLnbBgfJGh6LqpcjdDOrq+XHWEMpU
 wDnacrVo0g0IETT1Hf6vv3E60RN6JUaATcapnhQ+g9SOmhgKCeYEIdayxr7YO6s/uooMPi0YTe5
 lzNfTXTMPnVS4t/eRhw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Writeback modified cpu->isar.idregs[] to KVM after the model is realized.
Warn if modified bits are not writable by KVM. To facilitate this,
add writable_mask to ArmIdReg struct and populate it from
KVM_ARM_GET_REG_WRITABLE_MASKS during scratch VM creation.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/cpu-idregs.c |   1 +
 target/arm/cpu-idregs.h |   1 +
 target/arm/kvm.c        | 160 +++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |   1 +
 4 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 5ffdeb5f21..e8988b7392 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -68,6 +68,7 @@
         .name = #reg, \
         .fields = reg##_fields, \
         .fields_count = ARRAY_SIZE(reg##_fields), \
+        .writable_mask = 0, \
     },
 
 ArmIdReg arm_idregs[NUM_ID_IDX] = {
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 0127bc0a95..eb0d8a1280 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -37,6 +37,7 @@ typedef struct ArmIdReg {
     const char *name;
     struct ArmIdRegField *fields;
     uint32_t fields_count;
+    uint64_t writable_mask;
 } ArmIdReg;
 
 /* Map short register names to canonical _EL1/_EL0 IDX values */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7d194ea112..dc64cfbeb6 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -28,6 +28,7 @@
 #include "kvm_arm.h"
 #include "cpu.h"
 #include "cpu-sysregs.h"
+#include "cpu-idregs.h"
 #include "trace.h"
 #include "internals.h"
 #include "hw/pci/pci.h"
@@ -66,6 +67,12 @@ typedef struct ARMHostCPUFeatures {
 
 static ARMHostCPUFeatures arm_host_cpu_features;
 
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) [NAME##_IDX] = #NAME,
+const char * const sysreg_names[NUM_ID_IDX] = {
+#include "cpu-sysregs.h.inc"
+};
+#undef DEF
+
 /**
  * kvm_arm_vcpu_init:
  * @cpu: ARMCPU
@@ -244,6 +251,63 @@ static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf,
     return ret;
 }
 
+static int get_host_cpu_idregs_all(int fd, ARMHostCPUFeatures *ahcf)
+{
+    int err = 0, i;
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        /* Skip registers whose plumbing is not yet added. */
+        if (!arm_idregs[i].name) {
+            continue;
+        }
+
+        err |= get_host_cpu_reg(fd, ahcf, i);
+    }
+    return err;
+}
+
+static int idregs_idx_to_kvm_idx(ARMIDRegisterIdx idx)
+{
+    ARMSysRegs sysreg = id_register_sysreg[idx];
+
+    return KVM_ARM_FEATURE_ID_RANGE_IDX(
+        (sysreg >> CP_REG_ARM64_SYSREG_OP0_SHIFT) & 0x3,
+        (sysreg >> CP_REG_ARM64_SYSREG_OP1_SHIFT) & 0x7,
+        (sysreg >> CP_REG_ARM64_SYSREG_CRN_SHIFT) & 0xf,
+        (sysreg >> CP_REG_ARM64_SYSREG_CRM_SHIFT) & 0xf,
+        (sysreg >> CP_REG_ARM64_SYSREG_OP2_SHIFT) & 0x7);
+}
+
+static int get_writable_id_regs(int vmfd)
+{
+    int cap, ret, i;
+    uint64_t regs[KVM_ARM_FEATURE_ID_RANGE_SIZE] = { 0 };
+    struct reg_mask_range range = {
+        .addr  = (uint64_t)(uintptr_t)regs,
+        .range = KVM_ARM_FEATURE_ID_RANGE,
+    };
+
+    cap = ioctl(vmfd, KVM_CHECK_EXTENSION,
+                KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
+    if (cap <= 0 || !(cap & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
+        return -ENOSYS;
+    }
+
+    ret = ioctl(vmfd, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+    if (ret) {
+        return -errno;
+    }
+
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        int kidx = idregs_idx_to_kvm_idx(i);
+
+        if (kidx < 0 || kidx >= KVM_ARM_FEATURE_ID_RANGE_SIZE) {
+            continue;
+        }
+        arm_idregs[i].writable_mask = regs[kidx];
+    }
+    return 0;
+}
+
 static uint32_t kvm_arm_sve_get_vls(int fd)
 {
     uint64_t vls[KVM_ARM64_SVE_VLS_WORDS];
@@ -455,6 +519,22 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
             arm_host_cpu_features.sve_vq_supported = kvm_arm_sve_get_vls(fd);
         }
     }
+    /*
+     * Try to read all the ID registers. KVM does not yet support it
+     * for all registers, hence ignore the errors.
+     */
+    get_host_cpu_idregs_all(fd, ahcf);
+
+    {
+        int wret = get_writable_id_regs(fdarray[1]);
+        if (wret) {
+            warn_report("KVM_ARM_GET_REG_WRITABLE_MASKS"
+                        "%s: %s",
+                        wret == -ENOSYS ? " unsupported"
+                                        : " failed",
+                        strerror(-wret));
+        }
+    }
 
     kvm_arm_destroy_scratch_host_vcpu(fdarray);
 
@@ -1080,6 +1160,71 @@ void kvm_arm_cpu_pre_save(ARMCPU *cpu)
     }
 }
 
+/* same as kvm_arm_get_cpreg_ptr() but can return NULL. */
+static uint64_t *kvm_arm_find_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
+{
+    uint64_t *res;
+
+    res = bsearch(&regidx, cpu->cpreg_indexes, cpu->cpreg_array_len,
+                  sizeof(uint64_t), compare_u64);
+    if (!res) {
+        return NULL;
+    }
+    return &cpu->cpreg_values[res - cpu->cpreg_indexes];
+}
+
+static void kvm_arm_writeback_idregs(ARMCPU *cpu)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        uint64_t kvm_reg = idregs_sysreg_to_kvm_reg(id_register_sysreg[i]);
+        uint64_t *cpreg = kvm_arm_find_cpreg_ptr(cpu, kvm_reg);
+        const char *name = arm_idregs[i].name;
+        uint64_t writable_mask, previous, desired, diff;
+
+        if (!cpreg) {
+            warn_report("KVM does not expose ID register slot %d "
+                        "(kvm_reg=0x%" PRIx64 "), %s; skipping writeback",
+                        i, kvm_reg, sysreg_names[i]);
+            continue;
+        }
+
+        if (!name) {
+            /* No field table, don't push back. */
+            warn_report("ID register slot %d "
+                        "(kvm_reg=0x%" PRIx64 "), %s: "
+                        "no field table in cpu-idregs.inc.h",
+                        i, kvm_reg, sysreg_names[i]);
+            continue;
+        }
+
+        writable_mask = arm_idregs[i].writable_mask;
+        previous = *cpreg;
+        desired = cpu->isar.idregs[i];
+        diff = previous ^ desired;
+
+        if (!diff) {
+            continue;
+        }
+
+        if (diff & ~writable_mask) {
+            warn_report("%s: non-writable bits differ: "
+                        "kvm=0x%016" PRIx64
+                        " desired=0x%016" PRIx64
+                        " diff=0x%016" PRIx64
+                        " writable=0x%016" PRIx64,
+                        name, previous, desired,
+                        diff & ~writable_mask,
+                        writable_mask);
+        }
+
+        if (diff & writable_mask) {
+            *cpreg = (previous & ~writable_mask) |
+                     (desired & writable_mask);
+            trace_kvm_arm_writeback_idreg(name, previous, *cpreg);
+        }
+    }
+}
+
 bool kvm_arm_cpu_post_load(ARMCPU *cpu)
 {
     if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
@@ -1116,6 +1261,10 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
         fprintf(stderr, "write_kvmstate_to_list failed\n");
         abort();
     }
+
+    /* Re-apply named-model ID register overrides after KVM_ARM_VCPU_INIT. */
+    kvm_arm_writeback_idregs(cpu);
+
     /*
      * Sync the reset values also into the CPUState. This is necessary
      * because the next thing we do will be a kvm_arch_put_registers()
@@ -2051,7 +2200,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
-    return kvm_arm_init_cpreg_list(cpu);
+    ret = kvm_arm_init_cpreg_list(cpu);
+    if (ret) {
+        return ret;
+    }
+
+    /* Apply named-model ID register overrides on top of KVM's defaults. */
+    kvm_arm_writeback_idregs(cpu);
+    write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
+
+    return 0;
 }
 
 int kvm_arch_destroy_vcpu(CPUState *cs)
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8502fb3265..975236b24f 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,6 +13,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+kvm_arm_writeback_idreg(const char *name, uint64_t previous, uint64_t desired) "%s overwrite 0x%"PRIx64" with 0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.52.0

