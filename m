Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337073C8C7D
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237997; cv=fail; b=pW9KOESt7ViTnwVCorbjDvii7ilmvE442fKAtP41ZZIidnZyvBea7LqKOjbUsZud7XqvVr2FGamZ1ZykhHiE739o756ZScASlz7ld+yEfeoCGS4DAagXVTQCWV/ujdviHBIQjCERuyETP3i6G1v8II1FlK3CuoXL+PSDbfAwuGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237997; c=relaxed/simple;
	bh=/pYRjMMLSXnDay9aRDUKlRlNj0DpYkWLCJ3Vpb0I4ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hQQ1faWoZpk6MQ2JmXHq8HLYaNBKZ89F1/fN8JZwjdVD3hVGzHl4892DcGkZp12fH4c418+8pN+Cd+6wxfJs0Pgei+2NQ6P/YUYRSST83eG0jrLEHAwX3sqFJTFVrCzfeZyJYcxeNFrcP7lEcqRkFITkfud7xRnUg1c9JZPLOnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Eaz8wyyD; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IRHrBAUg; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Eaz8wyyD";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IRHrBAUg"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhp1763910;
	Thu, 16 Jul 2026 14:39:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=/A+Jkz61pM9EqDC1hkDgkKM3zpmOOMCHvPf1FVTDz
	1w=; b=Eaz8wyyDwEsuZbGRy1wVo0Lf+WeuOWtcr5QKZXEZFXHL11KEKGrCt1a/A
	R+NWlIMmIg1T/wwH+IZfj1rkv5GPDIFVPjPGTg8+Jho81Bddiwa3tFk4+CL2yH6Z
	LmvtsFVo+SAn6bbrMEWsGyAdmysZWarPwFomWlGAwb/5GcKIM5llXjQ2RlWekjrM
	OfMzKHIt2QUK4lV+pz9DkXqiCLknjZ3ccsv10S8DHjFQHTOtw1jWtM0jIXccTE0L
	pn+OLmWyZwj/AA8bVLKxTEGZb0mI7FFOpeRtOyathBH9TR6n1XXBrEDl/6ACHnGH
	846Yqgd1+TWBBgcJ8+Es4fkyroHEA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-7
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XoGwfDQslTt2p13I48e7KhYLUj/V5SpjLXyQUsNungqJAvx9EmUvt+5aZikeaINYygEURS+5mvsl/codryvhadsCNZL1hq5CKE4wvwPs1EE3BkaiSUynX/r16kG4inMH4FqJuH8XxS6CuaR7ocfYQBTdpx/wErGKS+OlNbKML0qUTjCP8eJ2ajXIfH98W54pR0jqyCfjO5MJkXeO5U2Q+4z9O04z/xTTBEcNVKrdBSSSEXN8s1Om/0UtbHwoc8rzjC3gxadr48woN0fEtRXu6tdxI27LrLqClVU15t/kVXZPNIIO8HJtCoLN9xB08aqpzu+uZTAP0fFBC/fhB8bB5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/A+Jkz61pM9EqDC1hkDgkKM3zpmOOMCHvPf1FVTDz1w=;
 b=cMCf8g2/ou3AqWzjzUUj4RSo9qFY43AYbH5x/qY/nc0o6I14fhkeQ4jA67mhZAlVLiAo6TvdQRKNI9gxgU18KxcMKYo1NALkvaBi6V8Q6N/GrjqGjfm8aMRHbJMhcXWAG1zUnKrUMNlarf47n3IwZpB+1g3zulYTR92xfaqlsoGWO4g1abgmr9nnr99M2LF3AXNwvVfQyTtm8J7TbhlHmc47WdmYnzkdKzly324lo6gi2UmCJg8ATR2wJlCvjpTIXhbDeC7J+4WaSyiBSppI3htGEjKgb/KMRgT9oQAo476dpsTfzYndiHJaZYOl/kw0xmJa9QmaR6WMnZSfRGSVhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A+Jkz61pM9EqDC1hkDgkKM3zpmOOMCHvPf1FVTDz1w=;
 b=IRHrBAUgYhGw5/HcXqgjmFVaOlkFBJqoAB5dRY+qZivVYJ51DEAwIsSzsgxdNX0KWz5Bx1EZoIU+bHOObmI6fF+znFVknD8vYbVQqWzMr03McMoSw2n6mHi9D8oZznwS9+qVuhwRQlKPUhWtakzAiHJFAdn07raYugsw8OKxS4JjDQBajUjKoJe5WWIk3nhbi2SxNm8WujBmGu1JFFycAVUo4TxvSPiY6F8BrJD/B8hR/LkbDnP7F1xQgKWKbTbFfD+Q3+Vk4m3/HY5+i5gQQVl2QnYOzsy1YcA/9otq2NQW92NtlXDPRgt1VL78Yrom0P1Xd4k1T0YSw+vWjS3/pQ==
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
Subject: [RFC PATCH v3 06/19] target/arm/kvm: Read all ID registers from KVM
Date: Thu, 16 Jul 2026 21:38:45 +0000
Message-ID: <20260716213858.609699-7-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 209ede14-2ac3-4ffe-8bb6-08dee382b8aa
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	Y/fB/mGS/BxvTXA5LA8EZ07vtfgWja28NGn0obxSGfuqqj6D+NUZLrqAH6TtfO96DwpIVKwT7oFROseOwF6q1WrPLPx6xI4xOVBRnVFZUGeawQ/IQpPxSh7CE83n4jk4Vn1RJKZ+j4B8Bpq4vGsNaP3eCKpWcB9HWV8r6A/m9+WB6WrwmKnr0TzEcLHDM0zFAieJiDin6ZPwN9K2SDLzEgi3aImJBFulJA9wMhtWoKXwmuNYeJl1UIQYLlLLBD8gId7+dTPrtFRnaAP62CLkhsOS1HTEbJVPxMO3D/8mcFAW167E8crFaUFtCWVH4GvQ7yRMwwRecs7dLidyovMBi0tBHDLAm64fVpMxOkgOvAa0BDqaSBBJowCetAHuhHySHk1BXq+tccMNny0HWyxqzA48FESV+BvgFvpVyH5mFtjDO0eHzILAksJtxeIDeQ+7fp9pstKKBoqC5nQMTotLotTgXE1wscaP/G5b8tLuPWCLNdUt1tukerDRr3SzY/XjLEIuroSJC7z9x3Vq+/oZyTmVpGxdxUG4Y9LsOL/3bqvwFJPl0p5shmrLlm9yf3n2HgBuU7LaF7Zp9SKMKF1XURGcj6ToUa9XmgLrm21ETOZK/tFP+zcMLJg1YOctufDq+OxgUKiFWs1rN+4EgwLGWLARKavHg4mSwH2lfg5hkwA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4qnPOlJ3Nlr29Gaby5yGZQ+jtTu2Fn3UMGDtv7NqSkaXVzff53fSPC7ZsbtF?=
 =?us-ascii?Q?B4iAZ/48Sc+CkEtz8sCxtz1hP2VBQqWukBlJBfe3Tjd80o841oBrbSNpik96?=
 =?us-ascii?Q?65MUyJXCchuBDJ+GECUlNDQF3DixzQRJc5tS8l1JBa/zRVvsETNrTxsosTgV?=
 =?us-ascii?Q?yIMPJQw4LjqOWzBJjtp92VDdUOCNaeACeQUaU3u4EGpoKVc7DtjgaH8CwADX?=
 =?us-ascii?Q?iV3Fwt1xMeyzmTKNaS9WxWMdTsv8v49t/tfkUNVfyCKUQQngiQXznqFG+gNx?=
 =?us-ascii?Q?QWSDiRWeexUDEjmporVTog/Lp3X9iolRK5XlVMLjshcau8TUMru5SE4OstwW?=
 =?us-ascii?Q?hbAcot7yO3mVKT5gBJdjrXH/UKoX9NNzjNqMv6PeqqG+aYrxErX9eqYgsyt1?=
 =?us-ascii?Q?rfUo4xGkYUWzobjk5RRoebLxbX2GF6r3idJJL4Oi1PY/RquvigXjZA5y+DSl?=
 =?us-ascii?Q?/pwTtj6ohiYNV2xGuwYvRcxCXpCvBEs3I1oBV8eh91dKCHn1CoIfYtRlKmqh?=
 =?us-ascii?Q?SLJqrTZvvaOHOTID34+fGa6bwlMF6fKKFUQay2Xsg2q3okdIGNQBvZ+P+oyi?=
 =?us-ascii?Q?rKX1TUoKT5hwYp5CpTOX3kzDmZjvPUtn9lz0zoCNhzHPUktfCNfaenO57/6B?=
 =?us-ascii?Q?nPeHYnLI2SoI2Dzv8ctM87Ixv/7zijh4pGVBqMoFHK7PRxQYEQOPDtEtWB4T?=
 =?us-ascii?Q?wx/yAHpd8rpMlsHuf4w6EQD+BGfCzKaC9zKcNBubJ0cIT8RBVEKRjNyZbBPj?=
 =?us-ascii?Q?4sfarVGxHUm8axREQgHBpJ6fPkLVmGF5oNYYiPvuMux9IFmERg/ZtbI+8gNB?=
 =?us-ascii?Q?8g/9dKsU4BkME7qBWCzx3fTkhb1Q2TKStX/5sPMRWhLZyAHx2uEUpAaRoGea?=
 =?us-ascii?Q?U9966xkh1TYjWdb3cFH7WYZC0QHt3vfOjGi5MW4IUdbJO67siZsqH3DGK7j3?=
 =?us-ascii?Q?H3FfjnP+QQ4KZxKiMDyag0i7srv0AhAPMBuIjtOTp4kjSqP98om4rjWdnYVl?=
 =?us-ascii?Q?HCiOOme+tIode9YkND9p7maaaZtk6DyoeEEbHd/dQtbbEzj8jKM3kJtqZswu?=
 =?us-ascii?Q?/ZwjfIu/3pjKYGl+TefoPdklwynsD23BvkFZGtHpEhallNGzxLUHfSXAqv6+?=
 =?us-ascii?Q?m4UplMcLMlIL+ioSK1XwIHfMWREsAVwUeHdldNHODdHECRtp5lfqHnMujC0v?=
 =?us-ascii?Q?Ntc9poj38CI/G/Ax1pTItJ5QFqpkEgUqcfl+XnkJz/3nAa//zEEuA8xikhPy?=
 =?us-ascii?Q?gJygB8gtc4NdLTvttVb9tjzfLEPzcL5zSNWjJ/VOZQeXDODF9HHjxC3JMhF6?=
 =?us-ascii?Q?o0O8cF76CGHoAzdtnfeDhctgMIISWrMuzSeAnG7I70r1Mcf3i1GF5yiHL9t/?=
 =?us-ascii?Q?7wCLVSwDepeDqY80ERC++uu93lQ9MZjNX6niHrjV5BmiyxtZBmyppGkNJQXq?=
 =?us-ascii?Q?hPTSv7qxpdp1zt4FprfFgmgqSJcnhGIveJJtLYjkr+ZtqqNUxj4PQ7emwyyO?=
 =?us-ascii?Q?PZeIT+IugQ2arVt4mLZohlKF5BBPrWwmA7MwtWO/7mKRMIJ5ZR3ZD7cWcCJd?=
 =?us-ascii?Q?YIBP8jZUzO3q6reW+oLos5uQ3Ct05UMYHHBGbT5y0eCDKoWFTQZ54f/8OjQ4?=
 =?us-ascii?Q?bEhafkGDLU/olc5FVS9jhhAYtQRYb/YW6a89Kw7w00j+c7BAoRsCnQvh2oOj?=
 =?us-ascii?Q?I60PQ+JUbj4OnIBy3Yw36FKk9+q+QprE+uL9js4X0PcUpOrcE341xe8ZTgkE?=
 =?us-ascii?Q?3HtETMVx0IPFoVDQpTcsJSPyQrtt6W0=3D?=
X-Exchange-RoutingPolicyChecked:
	C4OjvPlL8VYe4aKvcwNODv/udO6auiolygXCCdW3bR1/Dy0RTM3JiBbumpF6kpLzlSFR/RntNgqqeXVjX+GDCVmhu4BG9HWbLP/jPK27WpTI9eY2o0HvQRDXgDRgHjn3dJFguYwWg7Gt0aKAB7xPe4cmWA/gMww5KkeCvWXn/CqshZ6vAH7UzKGrvZosBVFLz8yBzsHz83NJQD7D2LDkZMDJiGsoiqNej8LqStpzixTw1GUVLpAElpt1coCRkKX6BtX5ttOT8UKm9hsyoR59SkOifXXw9AP4HGIkQvs1Zf1Qcmy0wa/EyTuiMAJnzuAffQAIcMjfxTFIYEATTUZfyQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 209ede14-2ac3-4ffe-8bb6-08dee382b8aa
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:31.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OoWoQc+WqxxLa9yEpoVHdOXAI4x6KNSacb2qaw1MAhSnHXcKmVoc6TtPblL0G0teYE1fQw51exw1sZahsSRpTuyZollBvi11sBlqVJ48+k8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX5MmT9lnIan2Y
 BcmL4XpV/QatZ2yC0eMQg7z+IEeeAo/xTm7XSfLutTc0NBuQ+7bOMMHro6Eo9YEUPBX3yCftWFN
 YGIw49NcS7X7jDFXGkC79LfnxNn6mX2B9R2IrbKIgDXa4Iish7xdJyaGaz/MFhIWCuDKSShnCQh
 Hkq+/8NlS5ETJchr3DJ9uoNoy84Q/G4y7CZKCkQ+ZnLrv3jR+tJxJsaXCHia2xyQQkMizHRSj/8
 mjvFOWKAh1/1LVVopdV2+1q02Ii4wZnQwYPCwJysPKQWiDVbMc46kaspfC4uivPuq//+fb2U2WX
 2yYbndWdgPtA3Fr73TKw4qbwtitWicTjajPMA576TFWW8yBkbDywiMVtNLtf5i5cUjhs2RfQaHJ
 lp8s1ePykI5XbGek2SsbASnkNn9HC8e2fH1zoNJ+T2AEVDaLvfWnQ/uWTH67Q4ZaGQZcHgby2Lb
 cWb6lTZT5MofCCXX8+w==
X-Proofpoint-GUID: RzRPIMb211a3u-L7IDHeAX-Gnu8EJbrF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX1KtNU1nsrD3m
 5D0yDQnjpgwnZCs53qk+HHaN/yCzLw+vRyrYrwftsg1C7I+GGIuvFFc6xqQWSlnio9JsC0mKIOd
 sjGpG7eJxJcFpa89WZIud6c78jvLrFc=
X-Proofpoint-ORIG-GUID: RzRPIMb211a3u-L7IDHeAX-Gnu8EJbrF
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f97 cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=MjXts2-mBpChFlE4YxYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Try to read all the ID registers from KVM. KVM may return ENOENT, for
ID registers it does not support reading from userspace. Ignore those
registers. As this list is small, in future we may anyway want to
handle those register specially.

We want to do this so that we can expose more or less complete
host feature view to management stack, as for migration, we want both
writable and non-writable ID registers to match.

Also remove the unused 'cpu' args throughout the call-chain.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 63b3727e05..42ff731f6e 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -292,14 +292,14 @@ static int kvm_feature_idx_to_idregs_idx(int kidx)
 }
 
 /*
- * get_host_cpu_idregs: Read all the writable ID reg host values
+ * get_host_cpu_idregs: Read all the ID reg host values
  *
- * Need to be called once the writable mask has been populated
- * Note we may want to read all the known id regs but some of them are not
- * writable and return an error, hence the choice of reading only those which
- * are writable. Those are also readable!
+ * We currently try to read all the registers. If the read fails with
+ * ENOENT (KVM does not identify the ID register) ignore it.
+ * Some of the registers that errored with ENOENT will anyway need special
+ * handling.
  */
-static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
+static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
 {
     int err = 0;
     int i;
@@ -310,26 +310,26 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
         uint64_t *reg;
         int ret;
 
-        if (!sysregdesc->writable_mask) {
-            continue;
-        }
-
         reg = &ahcf->isar.idregs[i];
         ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
-        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
         if (ret) {
-            error_report("%s error reading value of host %s register (%m)",
-                         __func__, sysregdesc->name);
-
-            err = ret;
+            if (errno == ENOENT) {
+                warn_report("%s error reading value of host %s register "
+                                "(ENOENT)", __func__, sysregdesc->name);
+            } else {
+                error_report("%s error reading value of host %s register"
+                            " (%m)", __func__, sysregdesc->name);
+                err = ret;
+            }
         }
+        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
     }
     return err;
 }
 
 
 static void
-kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
+kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -415,8 +415,8 @@ kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
-        /* Make sure all writable ID reg values are initialized */
-        err |= get_host_cpu_idregs(cpu, fd, ahcf);
+        /* Try to read all the ID registers */
+        err |= get_host_cpu_idregs(fd, ahcf);
 
         /*
          * temporarily override the CLIDR_EL1 value since some host values
@@ -595,7 +595,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     g_free(writable_map);
 
     if (!arm_host_cpu_features.dtb_compatible) {
-        kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features);
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
     }
 
     cpu->kvm_target = arm_host_cpu_features.target;
-- 
2.52.0

