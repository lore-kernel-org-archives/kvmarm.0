Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74BA42F709
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994039; cv=fail; b=DxGOs+5CbgzwGs1ahPjiIHtWMztlYMniG6B3+GJUrwJJK4pW+ovXNQhXEOCsCJKOXRQ37ByrJQDHVDs96/jWA14RoEikTE0PHgoyHgYmwdbZMAnwwWw6adInzWYpypKZA71KahqOlJFHGvk5FYB8XtzWeAwRy3kH18OnZJ0PV50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994039; c=relaxed/simple;
	bh=DKrINPCBkDz3sqVfgmnwfGoAO4ujPInkKRWOPmOOWdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hLTPM8UYGCzrg0y3EVzuInHXp84zDigKfULj8mLrILFPeppvRhyoj11ouiEdoiLyudWH6QKf2dI6NgPS0oEMWjG5oomxZyduj8Bsw6wvPwLOCcafpFi6+EZ2MKXZoJzAFnob3tG89g4FBvRrafKKhV6xj9ZMhwCk+lqFiAgNPIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=XwtZ8mUZ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xjPZvi8j; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="XwtZ8mUZ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xjPZvi8j"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHpI857563;
	Mon, 21 Sep 2026 05:33:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=7pUPrrkJAcvBq2IWSoBsVKqpaKLSTjJcSzstUppI3
	As=; b=XwtZ8mUZ1DrpCtNrZFAdD/CqvnkqkMI/Rl0B1FCevEXpoX6uvITqZZYN1
	XM1411ZZ1LmBjGfanuMzAdjMCQWztbo6QX4csrPCsR2KR/Cg6miTM05xBi4s3jpW
	luw6r4iBb9L/VpolESg025YcqjSwaFP1RntnhfTm74QmDZviDar8wPsAR2N+zDzj
	2fV9ToPPezgiPFsLs7dMrwUWz+c0sdrzmjH4lPQr4s7iQGwnEtHgTFsWDNF/Ogvm
	wBT3t+Olff4xcUtATfIbiWSO6/U/EK6kP+O/DnAU4ByNuzipsHmIhHlT4vs3Mp+n
	trRjQ3uynfEATz+WfUQ8LSlk8ktJA==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023104.outbound.protection.outlook.com [40.107.201.104])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jnu-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fn9kDOMhHkKzNEwSIeblvSRWKv9SV8Fj79Idyk1xa0Gl5qG2hdyIHHkId7yfrKbBrXqL4wPH0kOtPC0UnpyShZ53rasdc4hTEvtq1UVuwI7leBd0lwxy15CBBZQGwqE+lFlL4+rsWrOHLAiCf9v8R359KN3zk5e02TD0ERt4ktE1tY0arNL5lBN4/Gs8HFlCqab5YGoNqknbLhzbRmZt9u9Jcw/jZmiIdrmtB7x61InJVuW79aMitzZY/RRrbQfkhvcWA3tSyZHevAXho44FLxFKyBiAO1A2GIec2nrU1IRv6wDDU+a/dx4oBtPsN/IsVZZ9Vucy3hYic050AbgDpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pUPrrkJAcvBq2IWSoBsVKqpaKLSTjJcSzstUppI3As=;
 b=aSm1702Rnb2RfKpBi37OIf9B2JWzZ74egAUDepHMvgBTBrnPWuXCvcRclglKeHOE7bYE+wJlcahEEFDk8TY4Lu8JeiNwmUElXbqo0jvuXPITgHjjV03F57LxnLTuOgVwyv9j5iQ9kgqrQHDVcaRWDaS+ecMIPcSxnlkz+qf+SMVgXNob0IPNCIkT2ACyFAd2w3SEKJ53z4lh48ByrWC86OIrmjHWKcxdIXeDDO7tYJFCuMLaaADslDB/XtBaQdSg+6G2/mzvaFdsXROBoKtt6f39qQEp1eVJhdBRHK2MTAngCIl8KXPMAGyY1jrgexNLTCrQ781+LgzTGf8B/Py1wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pUPrrkJAcvBq2IWSoBsVKqpaKLSTjJcSzstUppI3As=;
 b=xjPZvi8jFZbhpCiw956O88nzAN7nhl9P38+jWOk+S9NTfpRpIhJm5rhRa1OtgY5Y2ttjqZn5Fwz9PRcPpOBET8FXoF9Tk55oQQj73Osgt8HO0SJjeycz1Uockp7iJZYe5pLim9VP2k9FGra9/Qh965rKdLVaq5N/F+b+pLjGmmfj4lA4SF8mDEG7gTPjXu+362XtYdwBc/qEdbGAsgyS3yWmBi0aMUXXAIOHunM5KOgvAI3hiOf+Na4RXj5lkLcmaquxlI1swBspHh3y0dnH9IWcbUj47J6nEHJ3wHPIZWN/lasKY9jnb91mzfsSMBVHf8y5J5gGR3vWYvmOE6GwRA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:26 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:26 +0000
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
Subject: [RFC PATCH v4 06/25] target/arm/kvm: handle special ID registers when reading from KVM
Date: Mon, 21 Sep 2026 12:32:30 +0000
Message-ID: <20260921123249.1708067-7-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5ca41c97-4247-406f-9c2a-08df17dc8885
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	GQuOz9sMu7tBl4ginAwfrI1kogqWXYLvlgoH3Yv1D8B2JEQsjDBgEqjwhwXOEjOrx4brtX0Q2syk0R4K0l24NCUe5yH2BZr5mtgN6JQzHh5YoKZbCJ7/Eq2nPMpLV5by32PYENXl5y6jQIXfFZpuiCaOQpTMi/OYw73Dbu7UYnbQUX+m1UQn8dAQ10shQtACA5HwFVeRiG+zhr2T3HGQJFSCuS7DQJYeNgo+QWYxBzT24LZyyFAa/6yCEEI5phpji9V9MbmdodhjF9MmO4KZxUBVXWUftZ1Z/d+YRkTZ4YFNT7FvYuIniuo90rtS6gquEscxrq9FCjsBhkiLGPzN0doRapzhabFdA2DGzyYV2szvzLvM/r1o90iXzcOloozLtljor7vWB0E8nIsh4O9U9x8jwDXO57KKYtEA2khR1v02+XDwlrWrU7OSjIECZnq39ZjbHvhqSBWnuTLxGVuc/5OuJk0+1uBRHqTEyR0iC5Iz5tA+jcXGRjG62hCb1ipV8MmRuievzEmwOknMi1p5y58mjEDXp/Kb6EfKyHs5Djc6wRRig249+XiqS46EvS8zTxBHDR/b9c5rp8djdxBH9kryvW/xES3lnGppyQq0GB9FB6QR5oszYYS0h8EC1/AY00Z/GrBTdN5hNfPZw6bkWX+0hhMAvYB9UaIcppZ/i/I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fk8jGzHvwgfqTvq5Wy0hZgIUDtxmLX8MJCCGbO6nBQzMy0HtxBOFwHpz27ri?=
 =?us-ascii?Q?Fsn9Z6r2y/drMWCpPykbgJvyIoHBNfil02j9oT3IbxOC0V+49MWOrfVzioMN?=
 =?us-ascii?Q?w6Y0FCxVMJsh1SgWJV2EQlH2IC2YYLaEI1fr2otUubNTINwgHX+Ue+7IdS7p?=
 =?us-ascii?Q?VuyM277QKBErX67mWMjtMQ9exl9sYLOnFTZ8Np4gDrplbZGChL4kCIizHwan?=
 =?us-ascii?Q?9fRqHtRwKLs0ru4k+CLNQQRKIZVoB5YpPggA/VHTRVWnFNbCni6Vlc1PWzXB?=
 =?us-ascii?Q?636UuIlGyUra5BATqokTJiqi7ARm4Mg4yhk0Y9eebtJBY/t6+ix4ckB3ZPC9?=
 =?us-ascii?Q?ydY4TznyT7JzIIwX3UY69J+Ys2JVZxtFY0fqYDamED5DWjdXV8CZtqEcDtef?=
 =?us-ascii?Q?XVw/FFOSo9mMMUy1nmq7A3ss6u3+uBXjHXhRn6FYcLeAy5d16v96wcUCSE4U?=
 =?us-ascii?Q?m7SDIt1pkRmOTgppTX+6D710zLkjpmMZX0rDRXLgKA/xhPidOegalNczplla?=
 =?us-ascii?Q?JXOETQ2JOTeA3yjPC/mNiIDzvoFdOtOYLgne4pDQ89EggJAsRM8MJcBIYb9w?=
 =?us-ascii?Q?WhKj6APaUuMl4Owa7v2aCq5SfY98/UaWbm5da2oO5lJH+oryKlUMlHrYnMr/?=
 =?us-ascii?Q?SyaBd18GhOL1ydScRvDiFdy1MH9AsNYH1ayU5tv/cVF8x/onFEdbRAzc3jGx?=
 =?us-ascii?Q?O90rUUTTlTk2AQpF9+Kq9hEcdB3euogt+7O70B5M5TwbHg6Qb+fjwcJVkCr4?=
 =?us-ascii?Q?lsAplHnADQqLDsBVn+z6vVe6vAaQkAhd1nF7VN4fxX96P8kclQyLR5e+P0cE?=
 =?us-ascii?Q?Z8spcbrDZ8O60FYIKxUio37sXy90TKs8GvtLQM34jZcs0qFGhbET5RFyV9Zz?=
 =?us-ascii?Q?od8cWp/zI50FKpTC9VXRa9PQyeBnrqhGxrfDwRL4XKBWKVsz1eCK50O4HF3r?=
 =?us-ascii?Q?AOjejLkVhKU10JRfHko3h/YmLOmYsbur+26CyUOyNJY60163VJYyzO+QeC2C?=
 =?us-ascii?Q?eMP/JzgEg3LwpWOrcbJXhyek5ol6QAFfCa+OXLq1vTMXz6ggZnj8T9u4SmtH?=
 =?us-ascii?Q?5d6wZZrRCqcSoAEV15FT8SdmVa1M2BPqqRrsnbYSQ4kvaCQRkd66Fs93fxuK?=
 =?us-ascii?Q?GJyhZVV4x2BjW/OudwU0CnZ6kGAKBxBm/mJPPO3bVpc9YtYjBWmNIA0ENn+L?=
 =?us-ascii?Q?D+6XRJYQrucoClGJuQhvmYj2LuCC5LNHu/szT9lzKy9MmSAiGFhXDtiMszW7?=
 =?us-ascii?Q?87w7+m9IYUeENzz4devil4+kSz+xmTvvCDRr9aeImDBzuwlGVe+dJhSPM8tr?=
 =?us-ascii?Q?qSqVAEysAH+memObxHGtJro6PYZGQcXR46cQyT1IXUl5lwxVurTzBjcB7bm6?=
 =?us-ascii?Q?6sy8Pys2w9vhQGTO3ClqxaUwQBq1/D47WhCYNVXzN2twu7X2pp/9TkSdwKRh?=
 =?us-ascii?Q?nL01eNGYWtLKF66WCqBDdOsqRHU+Ir5Bw1+M3irPmRZZRJqv9u58LMiqLKjv?=
 =?us-ascii?Q?miC9soSAC7k/WFViOGcFP/WGUN7tN55OActdRASAvUfGFRe1xCG680QdfjNp?=
 =?us-ascii?Q?ohAvOa/L8F5q/6CRqIa6tnhxeds0Bfhu50q1R3qbinpXhcOLlIGEftgcwgZW?=
 =?us-ascii?Q?l7DB8LtiL0V659IUPq2m5eGY6dqcQnaIJoCmce+8tDvezKTCArkjfv67xnFU?=
 =?us-ascii?Q?PjtfkMXm91Xur+0ZGlFMFh7XzohoKzVB54Fo4P9OjQ1wldh5FUy/IwqKdZ5A?=
 =?us-ascii?Q?sx+zymLMinDNOhtm94CEgdi83/sj1Lw=3D?=
X-Exchange-RoutingPolicyChecked:
	a/BMmaduyX9yco+qt6bx+raFhigQMimazwuVUpGVnPlttqztAgfd3N5CO4LR6jHQ1MJjGNljEjbEAURaD2jeSDsmsYWeUz77Cg7ZRX7vucxH95J5tOVDn5vOoVCUnZke3PCAEt/4EzXeaLw7GJSANaMNpqKXEOBDdow5eOaaEFpySKH9mCQGYSTWqdPJYJMy4IWci5tcDX6fpBvoj49jbhS7K1c/3edJ3c6TEevjCv6axbuwTUh84ze3x4O9eMk4xYPXOPOx1ezrf/XED2A98KICz6Jkd4PRomAkyaPSIyB4B10NktYLBNt3N2kCo223jTDRqvY4622fxvt8aIAj6g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca41c97-4247-406f-9c2a-08df17dc8885
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:26.1688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExKF55E1zFS/q9M1ud+9ezxFFjiQZprEwRmVqJwGzXVwrv0KXTfjK37x8/q6c0NarV3ibdkmwobjs0YwI27OjPcpO/Q+GPF9D+OezmGTCUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab12421 cx=c_pps
 a=0aASrZ1Sr5nz2ag1/hSaPw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=wDKzX89QGrb1tBTQP08A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXxf63FOX9ppVD
 /0gRl0ocUo865ZRFTec9v24ZhCTYCioUUcG1wJtLaY911DCSsFlrwo9bQMAxmiuJOlMO6j7hQPH
 DrQIylF75VsJwv9evpwCeATze02WCdM=
X-Proofpoint-GUID: 4mywlL7m0SrrXGgC_-e1KGaTMfPm3wN3
X-Proofpoint-ORIG-GUID: 4mywlL7m0SrrXGgC_-e1KGaTMfPm3wN3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX+NK6QuaUM/u3
 YmHMxiddE6WGKAE3IW7/nLvW3oLk/q4ARR13v5PvKC7QUVG5PSnXkwM99jB3ruEVN5RPiwgto4R
 WWwCr50W0ByUr0l+m2jQUHTmm7gsh6YyoxKZnJW75lIruGsR8TktPcJD6VXMcadX+08TnboD8gU
 q641/nq5j339KCVaHVclh3MdsgCWLH+mESBST+/g4HpqvzIy7tEVhE2QHqEOpfaYSrLcPgsptLd
 8QCh+uFwhU0xGjaRom1mUohiJoOwUfkgoiJ6m2Rb/qJF1bHbKjwURDbBdjC17ebPatjwedYeRJi
 /pO09hx/5PV1+BLwDhiCv7Sz51/PATTHr+DayBz5ED3S+mp2TYlABP3JAYGjR1N4DuqqplCw/0d
 moQdBOVvxQQ5i3yF12UGBM6ea/aiqaW+RQ+5r1JSunE8QQ1SHcXAh5ilu7dCYFbjK6N1GaCTk6I
 bC9CxsnoTxdeyAnB9/w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

The generic KVM_GET_ONE_REG loop cannot read a handful of ID registers,
so handle them specially:

- DCZID_EL0: No fine-grained trap exists, hence not tracked by KVM.
  It is EL0-readable, so read it directly with MRS.

- SMIDR_EL1: KVM does not currently support SME, so skip it.

- GMID_EL1: not in KVM's sys_reg_descs[] and, being an EL1 register,
  cannot be read from userspace either. The guest reads the raw host
  value; this is a genuine miss when MTE is enabled.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index d9d0623a2a..07df6626d4 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -349,14 +349,38 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
         int ret;
 
         reg = &ahcf->isar.idregs[i];
-        ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
-        if (ret) {
-            if (errno == ENOENT) {
-                trace_get_host_cpu_idreg_not_found(sysregdesc->name);
-            } else {
-                error_report("%s error reading value of host %s register"
-                            " (%m)", __func__, sysregdesc->name);
-                err = ret;
+        switch (i) {
+        case DCZID_EL0_IDX:
+            /*
+             * DCZID_EL0 is not in KVM's sys_reg_descs[], so
+             * KVM_GET_ONE_REG will fail. Read it directly from
+             * hardware since KVM can't trap guest reads of it.
+             */
+            asm volatile("mrs %0, DCZID_EL0" : "=r" (*reg));
+            break;
+        case SMIDR_EL1_IDX:
+            /*
+             * As SME is not yet supported by KVM, ignore reading SMIDR_EL1
+             */
+             break;
+        case GMID_EL1_IDX:
+            /*
+             * GMID_EL1 is not in KVM's sys_reg_descs[] and guest reads
+             * the raw host value. But as it is an EL1 register, we cannot
+             * read it directly. This is a genuine miss when MTE is
+             * enabled for the guest.
+             */
+            break;
+        default:
+            ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
+            if (ret) {
+                if (errno == ENOENT) {
+                    trace_get_host_cpu_idreg_not_found(sysregdesc->name);
+                } else {
+                    error_report("%s error reading value of host %s register"
+                                " (%m)", __func__, sysregdesc->name);
+                    err = ret;
+                }
             }
         }
         trace_get_host_cpu_idregs(sysregdesc->name, *reg);
-- 
2.52.0

