Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15DC48A2CE
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691364; cv=fail; b=gXyrNOzoEpxSH8MuHa3ms/9FXzsi7gkCcz9ixHPKB4W3+rkvgA5PHo/+wx7vBZMIrhCBXFRR+fIW6j+zJ+fMQzezCSYOMIENpFaha23zAzCnd5MuGWh7phSRFxnriAEjbLceOwcnD0brnqLgumotUhfFOyC/E8YhwjdIdWTcKH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691364; c=relaxed/simple;
	bh=SwvV2dW/lWBwt2U2DtPBwvONi5Vs//Z/HSptLp6XPPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H6DhR2y2MQ7+ybNeH1npgqoq875IaM2Y/Zd+Di2/NnZkymB464jz29l9yBzRckvY7VZHNRajoek10HK482khJGl2Nx+gcIotZaK4h+2Urm0ypoEH+NPabc8fQMAVmZOnaAV9dRhF8CUQ/t0DzcAzKq6FTBt/llPebp0ba7WxxaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=m4vd/ABr; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uBrjZDFq; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="m4vd/ABr";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uBrjZDFq"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGLBwm1800865;
	Wed, 13 May 2026 09:34:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=dF59FAlr1ZmMIsYI0C6QG7ApZM0nriDlrpEv0CoNO
	d0=; b=m4vd/ABrFeK+inlVP8yoDDMS2r8k6FYnD6Z+8Ht0vIOumloVwDtDiiEVC
	Xc1peGBCndGZJw69vNpFrUqYAyauXv3+3sAR86eACOW287iCafYceqNrs3UhRFaD
	z2cEdjhRqPa+jDU5v1W56bRMAS3N0hJZfWIYdGZrsdjXginu5MYTi1AziNXzZNEt
	SHsl6+0osGyrPscQOtvVHwhyb/rmeZxD9RbjMm2QcMgqZ8RTak5PH2/dbWwxznbb
	NoePbhk90mdOjqIjYtblkFuO2BATfhfH4rxfrNG3nH+MuqGVEzzUH6MeV7GG3D0h
	5OkgUxo79JNBzZb2s/xJfhxJGXYDQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022077.outbound.protection.outlook.com [40.107.200.77])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nvpx9xr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IE33j+PGQw8qny8rvq0aNSFN2Bs9S4HTUn56NiJH04W4RUZdJSJTlXIif6IDaWW/KRPWTHt1pvw22y6sLqSf53iLQA58Hn+XTFS3TB1a75Q+HBk+tPpqV6HGNnrrqNnDMdunSEGRMPXxy5wjlOGitKlN5tTJj58JUgc5JOCWoympaBZkcx53TO2N6HevDaBC4IYz4jV0yh/lLxdjbf4we4R7FADYCP6Oa94OFuRhbP+0z5OCl5VVZuICraHAdRt+E4r9h7I1jPCf9/OGNu9S1/kXswOYRIY8IBU3Hw+cY+ZxaYUdbIcRZ0S+gEm3Fbr8wzlElmsfax74Y/ljIphGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dF59FAlr1ZmMIsYI0C6QG7ApZM0nriDlrpEv0CoNOd0=;
 b=ZM0o3J51IFFN6SVx31KJWECYVUTMIqqWgektkZ3ISOoSZZ8x66zrf9ONi1lFEF4Nh6rXR9+OH0Leti42g03Mq+1hlQtXL0Sn30PBCqsuolC7CZsvfzzGt73xuhoRk89gGCbSWj5czbBHQuBYZeY6I4KIOdoHcn8a1tnCvXQh1hzmq64rvW17VYoYOFEKsMNLmZIKWNZZokDKWLnRjxAXUGThWrgEC8mdmFwPy3h8ABXS+Z17KzT2pb3um+5/ZMLU1igt2zUwJxUwdBUuzmD3vHhemyOVx2pjRKUUJ6Ia73O2NfoKY/qUhJhPdpUSxyC8YRBwv4SlsOl57R8BsSVlLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dF59FAlr1ZmMIsYI0C6QG7ApZM0nriDlrpEv0CoNOd0=;
 b=uBrjZDFqI0EI5cm/wAm4+KmBXVOfIMy9AAnyaE6WP5JHPb8IYUJhzRXRZ1iM7aOV3oN/5Cq+YjWC2QQhcPy/CpY9uLQ5qBPPbLRf/mm+zrutnj1sUSRFQkRwNV5hneC+uLnyiF+Z9OJbSoRYSQH5Zql8/rDUYMNLut4X+yZWlrONySnG8jaYcFifOm3Np6hs/KObZ70bxdU7sSvX9I7K7+u9DbpWlG61n2jfRX0wXI0Ij0eAoCQepLRiRaNXLxJy1Ii4NUekoGRPd9lU7UfQ0Aj0Th4wMf6nwLWzLzC6f23P3oPffSMXQ+tZ6Gwx+IxYQXwGpgQHliou3RZYFr87iQ==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:17 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:17 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 06/13] target/arm: named_cpu_model: data-structures required for the ARM property layer.
Date: Wed, 13 May 2026 16:33:49 +0000
Message-ID: <20260513163356.3033159-7-shaju.abraham@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: ee8604c9-1817-4b3a-3ff4-08deb10d7a07
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	yPKS0TM5sl3khS+21i8LXjx2S2pDtJKN32zxSZw87xDxefxIwu0Wmy9h2m+UUw+odjNyN9TwTZrqh8KbXTLtsyc+GCvi0Bl3my6R39fDxgaFRRkY0cHWo7ing2/QnzVSbhy69ZRO9kH84j18IZ5VpRuiWZC99FQLxBIuIRH24yNcwsGp1mrs0fJVVuazc/+UaQ+9+Ie7bsyiNTcLuacRElDeuXAh1KJU2ucSOWKKDnSgDog/ViN95qwybXoHE66/RuzXofSAGmr4s/6GxbHMtn2F0HfKe45zykmDNpxNMAWIgb7Zhp9q0luimNKZuST7xQGUlgdjoJ/kRp3wUy/DTOGAbBHSZoMNsA/QfDTB3oiLHgEMGxWBoYtxtj/KAGRYLrcBMxsOyXVV18lSBM9wuHirqjSub5Fuq0NTGAfeAGVrdlQnO9yvo85ylYBX3N6ZC0o11DBt4ROy6ljzoNmImOHt0321B7dewrH7BMKO7SdHjhpCC+v76/MTClODOeOcIWmenWeuRZ4ekKypYwDYKe0nTkUfXFdx7/G6+jPrCIwijTaxa7FYuz77DVxYwW7ocxpkYiPNusNIoiA2ArdGnUz6NUQKkLysZauEJpKRVri3f8dpPq8st2fMw8DI6nYQgMoHkXKVKt1skEroW+/OuR4Qhf76NrtRcQGGKGwfQDFhmsPsn2MNLkaoYRpwK7cEweT7ilT0fNJU9O8vojhq8iKbbm/a89WdV3zR/2dnpk8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2FucXer86mEgeRYT907XbBpKmfNFdPaWAyDCR9cCMoyR3ZX7g058drB5fUGM?=
 =?us-ascii?Q?Hj4NNdWwWeAhQFU/ku7g3acYAP5ZeR1rVP9jJCyGpv5Fap2MM73QhuOZApDt?=
 =?us-ascii?Q?fpWT9DDJWVW5ZaD/eptJWac/bx7sQgBJVdbanJFte3ocA1Wc7QJCZjwV2xKY?=
 =?us-ascii?Q?NaN8qVDAqflOyOZp6vMTrJmH/NA5nH7h6XA9DR/E8DH9bx1URRZ1EGvBU38I?=
 =?us-ascii?Q?hxa0hM9H8dxdZPmUmUXquSPkMfBg3bcatcDonB4PTEA42/EUqCz9WbmqRVHI?=
 =?us-ascii?Q?TdTah8YcCz0846Z+7fJXt3DdNPCYmk4Ytu2a9740KZMPaw7HxGiwyLh5ANj+?=
 =?us-ascii?Q?V4+9ihk6+lEWR3HXvvpnrwaLguiwMoTS3cytYGVAeHJRxXy24EjuND4wC6ik?=
 =?us-ascii?Q?Rm3qSleH4HUwkpdxz8HTVI40xQDjm5Htfit4mz31dYk1M0rK9xXPMZWiavuk?=
 =?us-ascii?Q?aKhR+HybmtDW3E1mJbWps7EmcHjPki/Yzb4OEFcWKNYrkPDlMoriC9GgA3g3?=
 =?us-ascii?Q?gWTPn+pwz3IVQqKwAohLSU6YpKc/85HebEzJbmaAcCn9JCa0MTPunektEWS1?=
 =?us-ascii?Q?uZhox1qsRiko6laNiVPcCyGhZReWz0MkyBAQECyNhmMn3yPQUYK2JakQ3xYK?=
 =?us-ascii?Q?tnvdDDX1/9/zrKcls3bQk2ui5YUdu2D3C5ZkEwJ9fAjKb2JTiLkWcArQp0H6?=
 =?us-ascii?Q?t7odwsqDXHO1m4Z1UihqB2yHcFJoN3edwi2IbLOpp/jdftBBp7vTDYpOWwd5?=
 =?us-ascii?Q?eiHsxNiiw2Uv00b7tHZOwqiosgkVTWBnpdum1yJXrwHkpgDl/aV0O8YxsN5+?=
 =?us-ascii?Q?1TelxGTgw/hgYxkwwU7WV21G/uHGw2kwJmlYBafzfZlrDQ76gjHMvkaUuP3g?=
 =?us-ascii?Q?YYRGGRRMCQMeg1hoaj85M9ETfQydN6ffd9UbNMP6moArA+J7n1lx1l9F9Ffk?=
 =?us-ascii?Q?3J2FQAsI0x4raxM284miHaN/mcF/oNBQG8flp5nIgThYZYNlwt0y2wluS3Ox?=
 =?us-ascii?Q?B6k7G3xvInDard4QUd18R47k1oMZqGjuiuu7KqhKwdgfAibKCwRRAVgKHHOR?=
 =?us-ascii?Q?CS/2cxXK4xbzzS42gSjjzM+pPSTrorZbnu2G/uoPOmEFBqGix1HxxppwkFfE?=
 =?us-ascii?Q?cGGml0MOFLeaoqlC71TACwefU4MUXuP5D0daOKS+BXTtpN07hrd8QD+KN2kG?=
 =?us-ascii?Q?U6MeKHe4H/ZN+BLrObNChFG90XKCxnH4RvmEZNnEFTU6lrAwkFm8YRr6kf6Z?=
 =?us-ascii?Q?IlIcDNoPEr0YEx0RjMrA2YBIiHRzinmLVaJIg7y94IFUXM5aHkM+6EpljOCP?=
 =?us-ascii?Q?/Uj1yZk92rAsYlu35ZPXavbtH+n6qVUIGbehzi2rbF6z3pPzGE1N468cfvwq?=
 =?us-ascii?Q?SaRgY09pJM4yM4dzFrvEshtG6AF1BR6EVvDsAekpSSqWRWV11O1ezqEtf679?=
 =?us-ascii?Q?2GUoJ83/Dlwq8aQR3wmXkh6Cuo1PTPUqxh97Tft5vuBDsquuB23LP4nttbjB?=
 =?us-ascii?Q?ANgD8d9AWpAO54UAWaXceQ8GIGRKHq+qXD2xSUeYPPZs60obuwhm+V1xoUiB?=
 =?us-ascii?Q?j5rYHwwI4FH8y6kR11cx/QweHk1b9peqxSkne58yRZI02FLJsP3qIyR7m5UX?=
 =?us-ascii?Q?gHzHrCUFeDARBXax+qYKoUlA1mHYt/tqzaVBvnFxpx47vhruKKxAI10JTvJm?=
 =?us-ascii?Q?JgG6YHtbj1ua2SKy66FcPcgLuj9DMwNAuqFskZ2WglivXrSVM6TVLDU+yP8x?=
 =?us-ascii?Q?SFE2bzFSmb96+9Sn7hhWNcfBa4RGQtM=3D?=
X-Exchange-RoutingPolicyChecked:
	ZN992BByGWDSMtuo3A378He6doEgfQQXwXNtmkJrrmg/OjRcmh0OHkh9VeTuOYOUBir0awBPUb7+4bLYgV+3Elxrw9wEj2WSfvLUh5jy3HWkorEVHUW/qcLJPEhjUtuqMRojyUTeHtY5qnJfA9maHELvQCGr9NzkHqu1GK9vxOlwJdakjJW4piOB/9xU0nEPopUYdwY73AaPtPGkfX8hpGASbnrBY7g1pC16W8yIIHpBefTS9mltlnvO6KN+vb2sInFCk3RaJt8KohmQ9qG1CRnhDmEWFcwNa5fzmRIKDqdGNee4Lle8y/GL9hRW2igt/R0Zp8fXRG121htndX5ZLA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8604c9-1817-4b3a-3ff4-08deb10d7a07
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:17.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIQJkxgxLTVICFBf34u2ew6M2M133Q6ih8X7zZ536cRUUmKyGR2McL6pLi8nPvPgy/3IrIXPjZ7Uy6+YK+bd69AV5UhQ+3693X9lQiJpjqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-ORIG-GUID: fMwOIIcFc2x2MTvLM-vldG7WI9PoCV7e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX9/RlT2W671Fb
 4GVBm90OKG5WLwJmWKFaXM3N22d6fUDIZQ8SUZlQ8SXGAwxkVXve5llFyGr+N347+iGLC6n8KeT
 z7XX/lH9iaXtrUCTvUKgJZxZzhNJJMfvHPZ8uqEObok/UhbEfVTc71huLo34hARW41OsW9kFpxh
 Iu3xn6VCT5pcU0FaN7mMJV8d4ZCiHrbtL6rHtaYrKV0L4K2D3d7Rzu+z/uOahbUUCHgJ+Ek/pyb
 9xeMJ0bcgDvcEd3CRvZc6SpAP/cucIjw3ihMDlcQXBoNKN1tsGUIzItyy7KxhHhwYyiT5/sZ9CU
 tgn45+0Wvo8fKA5WvAVI26W6Zq1utI4aLJM7iu+BA1kvcroMHtX8dvB56aFs7YWlWJ/EYLsFNnd
 VqxNnIvIJ+SIcfc4mDCKeEjMapqUihChIcsKMnmdm9cbBXJVF/lfRskTSeXNL1E999uzsLmGh4+
 QQv8ebi3w332ckINpBQ==
X-Authority-Analysis: v=2.4 cv=TuXWQjXh c=1 sm=1 tr=0 ts=6a04a80c cx=c_pps
 a=zTBNYDxB24c+L2bFQgZTuw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=Vihx4mBza3j37xkBvAUA:9
X-Proofpoint-GUID: fMwOIIcFc2x2MTvLM-vldG7WI9PoCV7e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce data-structures required for the ARM property layer. There are
four classes of properties:
    STRING: Multi-bit fields with arch-defined named values, such as
            ("off", "aes", "pmull", ...).
    BOOLEAN: 1-bit fields.
    NUMERIC: Numeric values like cache geometry, debug counter widths, etc.
    FRACTIONAL: Paired (base, frac) fields exposed as a single "M.F" string
          (e.g., CSV2/CSV2_FRAC, MPAM/MPAM_FRAC, RAS/RAS_FRAC, NV/NV_FRAC).

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/arm-cpu-props.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 target/arm/arm-cpu-props.h

diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
new file mode 100644
index 0000000000..1dc3786ea9
--- /dev/null
+++ b/target/arm/arm-cpu-props.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * ARM CPU feature properties.
+ *
+ * User-facing QOM properties that map to fields of the AArch64 ID
+ * registers described in cpu-idregs.inc.h.
+ *
+ */
+
+#ifndef ARM_CPU_PROPS_H
+#define ARM_CPU_PROPS_H
+
+#include "cpu-idregs.h"
+
+typedef enum ArmCpuPropType {
+    ARM_PROP_STRING,
+    ARM_PROP_BOOLEAN,
+    ARM_PROP_NUMERIC,
+    ARM_PROP_FRACTIONAL,
+} ArmCpuPropType;
+
+typedef struct ArmFracVal {
+    const char *name;
+    uint64_t base_val;
+    uint64_t frac_val;
+} ArmFracVal;
+
+typedef struct ArmCpuPropDesc {
+    const char *name;
+    ArmCpuPropType type;
+    ArmFieldIdx base_field;
+    ArmFieldIdx frac_field;
+    const ArmFracVal *vals;
+} ArmCpuPropDesc;
+
+#endif
-- 
2.52.0

