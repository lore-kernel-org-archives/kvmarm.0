Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40223C7DE8
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237999; cv=fail; b=ULJvZJygEn9vGpcHjYe0jHGdEP5Y4/awZCwFLsZuWUFhPjB4HixWEFZbT9+/6IX4m/PsdHp4KvATccYxlaKEGahlYFiCBvyi6AEpX/tSx6ajjW4y/teY4CcMH33ufwDKTurKIHKS/bz76QbBLtSSu7jgtYwTjIpTvfqLjQcjoGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237999; c=relaxed/simple;
	bh=KGgM5xJHxMezUVbab93StMy4S+559pYjHQ3OY4fLG+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O0kDtc5IfXKls71XggKNF5EyH2D5xbIMyAZmZT3WA4UYBAT0t5mkT3Aqj21s/78KWZujoBxy5RAH6hyyuLccLx+WCrrDmmfd+eG2DmmPxhx+UXsDSZ2ejwELPUu23cGfZqE94nGX7Um3M9tITocydcTBfBtaG501qn0V/EGy1S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PQMtKptc; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uau3LVto; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PQMtKptc";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uau3LVto"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrUwD1796534;
	Thu, 16 Jul 2026 14:39:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=9sXnPdBvjQ5BwWsZ1rkam1PrQ1bL8BnjGZgxT6FYC
	PY=; b=PQMtKptc+X/ZYLvmUeGwUQBO8UBiMae6EhZkhXZADP0VHIUUHEE28LgzW
	4LXDo4JDW7gU3nx8TA+xJftHvQsux6AGfNPOzGkbcPpAEaAyYhUyNBF02knVVpp9
	wOmg62jhgRkJlO6cx2ZeGxs4KaUc67jZmQbDN2nFpQG+Q8X8bHCNkkHUSx4Y4FN7
	BJoC3v7XdfMEK0IVGyPu918+LKNHDiLMcgXd3oMX+cUdda5zQ+m0SwnGqx/6U+AZ
	2wQHxT5tMdxXQaNF0sgFEq1NNclB8K3g4As8R/yzJc3ez3OcWM0en0TwFtAotpoi
	K6ulMQqq0/8gX57w7ZP8s4SPEfaug==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022136.outbound.protection.outlook.com [52.101.53.136])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fejrfb79p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yt6P8l8a7L1Uz03dPxfgs/7erj20jLxvIk4QV6RONDMVX/+tTJCAXb5s+D6yiA8rRMRwu3HigETlbLP/GRIhG5iEkpn83ixbgW0DzjNQ3084DITK6bGXwGmZ5J+FsNg8J8GEAuJRlh8Q39tqwMQOdow/G3J1GqpDb9vIbl6tyMooYGACMdLlpGnnvfLoDMS9ZluohxNF8fX0Mmj+QvlE21WztvGKfFWfqvLFzLuuVXqFGNwTJ0IEcIAIqm9RD5uWsdPLPRW/KZm53w1FBXdt+l9GgADRZZ99BWrBcP8EcEdrNoZuIsAMJNaH66WThcph4ADAcRN3Rg8LKs15d0aXTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sXnPdBvjQ5BwWsZ1rkam1PrQ1bL8BnjGZgxT6FYCPY=;
 b=qw8ht1M1IyWf4mD/hQ4uW/EAlb36q4S95xAF3EmYXAYbnEeZqLChGZwv6CEpdrg6KyLd7Uy0ps8nD62oDu6R+P3aJWxugQBt0gRD9tUFX9bA43SEmwqiTW8TPagX9vDwRmx21OzlpDD5MrMbOojqRU5ZMse+slvtiNb7DStYoschZXt/g+67dfN8HnO0b7o8ZPLNRqz/K0SNbM8ojMn3KVKpN2AruM4c/E6lH+0Ahw9tzQHIDg3XCYXikCLBnY6oc/eBrsBOHLzuae2+UFNJFa0aiiPT4qTbNhp77/zSlwttQXt64HjpVloM5AZdwl6OlKt18eg6bKu+gRWR+fICbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sXnPdBvjQ5BwWsZ1rkam1PrQ1bL8BnjGZgxT6FYCPY=;
 b=uau3LVtogvReUnYGh/Rt7bA2XMkV/FuXpjOe1OQJi/vwRdrq8yi/HpdLMupvdy6f78FdHgwsN5UECaa8apgCxgwIMomkBW/kQS7+DtoE3wknp+qSRSWU0k2aQ4/nRPQ44mwMMmUHNlccQBY8uWviQtvvvScRyfBfD4GvtTtrQwEVjm0KAJHgZnc3ZF7jkRsjMOgTS+7qpSlT00gDe7yLGFx8+lkbTx4wc2b6ko5rV4//sihdSNiJLtGTWWF34np199FZ0dxflQIx/bZHa0O8MwixNpAJ4K4SxmeefQkukN24ylx4fDPy4nfLxDxGlVN3LLkLDLcCK06rY70fXWK2Ow==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BN0PR02MB8255.namprd02.prod.outlook.com (2603:10b6:408:156::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:40 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:40 +0000
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
Subject: [RFC PATCH v3 17/19] target/arm: Report 0 as supported for ID fields gated by vCPU init flags
Date: Thu, 16 Jul 2026 21:38:56 +0000
Message-ID: <20260716213858.609699-18-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BN0PR02MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: 6465b1c4-82a9-4592-bcff-08dee382bde4
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|56012099006|6133799003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	aylUIlOCvkGlql+fyP35jHHK3UJtm8oyTRIsBhTZoatBb9WRNKt6hJvC6wfFd66K6xcKpXHoMredqeLyV5qv7LUa9iWkogYQPSHbxE3kTrWhQMeohdrIdGdKiVQECphgYDQ0rjj5wnxa3mz3jO5BrEnfbiz83qMp7ZkNwsXfNdZyI8+5dbONKJAwwFLIzLXKDfHy0pzw9cdBvL/FI3PBO29pRLg5Yh2OSPYIS7k7ketNfZr02oqr7qXfqygMslel3WwrN6d2ENWYj3kf/upEq73kZRUENd6rrQpPi8F2tUwoRR/6ZLFCIoxPJ/PxjyCPMh8i530MMllgphbxxXwt1Tiojkvicc0LmpZqs+FjBGHaLR88q8EmtEYfzQTML1NDS1DPnXOYS66rFxKhE8Ug3SI/bYzJtzDEnUS6b0oZnNMx3EPPaF+1/Qn2W5Jqu5FsaxAreK0WzP5B+SAgWa/gsq3nI5Ix0brHic0oTediw8p9ECtSLd7LAbHCXiAikW4VCgvPEO4FspC2KWd3wyLAJcNcmdnDaPqScPD4TnM8ut16u0z53v7JogSWiHBNKhcEG/4CYTrBhkdMh7D3XX1IkVXROk3bb+7udc6qK/HNUNsXMutw8DA2rgmZwVZGvZXfu+EIRk4UfDH4k4bTF8wS2uxtezHI9L6XMhgasmYbVT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(56012099006)(6133799003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X+DoqvVGd7tbKsWPenfbr7cI5T8AuOnotPwSI6mu0cXI75ul1cdIy5MPGMzf?=
 =?us-ascii?Q?5it98yPYxFkd73mwMXvdMYgR2JlGqdmXV5Ics845ujXVywRldAJ0UDRnoR8/?=
 =?us-ascii?Q?dfyayl52iIpDOO9kQS2tsYHoAR5KbpEb2R5zR06chNc57ienXwzboQlvdBdm?=
 =?us-ascii?Q?VXIVYLU6gvCfY372T1H4KXqLEODP/ItVVy17IViKT3mCvc/AV/ioOsQ7phbv?=
 =?us-ascii?Q?Y+fom4M0ZE5r7lv+n3q2v/Q0cMcvRLMCcEFY4vq3A9FMnU5XYvxZg07Jihzt?=
 =?us-ascii?Q?p2OGr/VoUKebN4bXBi0aNmysIV/SndqOJB0a1zlZ0f2I7fCO8kT+hjN3w9wP?=
 =?us-ascii?Q?/LJbjXVtIrDpxcmcPsk/EbRvHT6/iHc/W509L15I+4Y/2CmtGjhyxpxTuwYZ?=
 =?us-ascii?Q?Hp1HV6TVYEofgtIVT1caCpPN8cG2jfHuNV/iZUjDdPHJ3umT5mOlPlN75kBI?=
 =?us-ascii?Q?9pQd7co89QWj0fzn5u6zllJv/gi6TUxVRamLw78lWVjYpJKXovmvgQUU0J7q?=
 =?us-ascii?Q?DLmITgSSEAZ+O3XgQ0J6g8nkhuY2evWZQ8Rxi7JCVIMjtWYYEWJGoRcvWCns?=
 =?us-ascii?Q?VnangSFBHh4aZE3ku/rdCWkm/YOz5iHC0xF4+E3VrLWuhpWzmXNNVdp32OJt?=
 =?us-ascii?Q?r+VnNCHvjkULs1B+C59NWo0WKINTTZNOsisxcXf3L9bKh340YaKPCfydE85l?=
 =?us-ascii?Q?cZa79Isl+hcOYubmoVb0Ga2JPCDzk7xCdr17DXb2bEQSP7hSOxeELmuI8ltP?=
 =?us-ascii?Q?BBB6Zhh9Hqp53pdeJdSt2JyQGip59MPMEyACkHnWtk/im3XIjFOMqSMSb3OH?=
 =?us-ascii?Q?qXddzKDK5Nc8btVAo/kqp5wLDhrDsxYsv6ncMh2NAZWGczFI4dIWBi7cfDPH?=
 =?us-ascii?Q?WN1kRQCMWXHPuW8bTMdz+VhzJxtldXOwsYZt7topCVab/Gv+DcMMEjHeYOBW?=
 =?us-ascii?Q?YJ4NfhSJdnqAQeB73NQigpkvdFrJycVbednOuykuY7MvKxUHBAZH1ka467/c?=
 =?us-ascii?Q?eCVxgrUEo9rwVzu43pyt9n87zpCwCq3XoQglEgteNk055tA7DMViX4t9BtY5?=
 =?us-ascii?Q?4ip6lpqiIzeyz9sWeY7J0HMhsZ/LKb+dIyjlpIGw2rXeUOLZ3R+swc31SVMp?=
 =?us-ascii?Q?4O7AR3kukl3gQOmVBpgU8l/KH3c16epnDzpi6p2HLXSgnHk1LYWB1Utpd+gi?=
 =?us-ascii?Q?Gttmu/d7T+qJpbswC80L8wa+vnAG7TwTCTz7qIcAVRYh1iihl0R/c6sBDrp3?=
 =?us-ascii?Q?k9NXpfRMsbj01TahxaXowDs3qprlG00NDFrJHjpAifi2ocs1MeU4JkqjlO/H?=
 =?us-ascii?Q?4ftupGPPJEmrzZWuf0ES5eLqS5Cb4CIklIdJw5lTPR7Qak6zD1qCHh2tg9OZ?=
 =?us-ascii?Q?SlPa6NU7SKqR3B248SFp4YYrtYUsTnrbS6fqPdvVHIUwpXFXWEF0j2DgYmfy?=
 =?us-ascii?Q?LcoEVXnVClle5Y925yKKR/fYldANC+VaROSDDFarkFKWPYNeuIswCfUmlg67?=
 =?us-ascii?Q?dRzArGTaUJIEwyyaQ1nHXbAeuoNALwiZULH/hTlMaey3boLVoITlwzgR+hww?=
 =?us-ascii?Q?9DxAcBjnBfNxgDsLZMBskiad7TeYlTEK6OK5YhjdTWYlvdAXgQcnPkHPRrsc?=
 =?us-ascii?Q?nVgGpcl9C04aqNWDKDnthP6UEyJl5mh+yC5ac2KoBDfFKSXkDursuZwiEot/?=
 =?us-ascii?Q?DmC/An97B9FEy7qviZ4fFYkcciXFDXrfjM2EAxVw4USVX9b61YZnBigI9rTS?=
 =?us-ascii?Q?dog4p3tROZVMI2L1ttDJCkTqJ8fx8io=3D?=
X-Exchange-RoutingPolicyChecked:
	mRv62I1htFlshzU28d4xu23GZTs9t9ZaaMAQwWYRlxRIxZhPNj7bdGCkqp7qCZjRAq06jqlggFz5a0//NEiI1+bynaTld/PNTEPYaDoLQ0ByEIPxJY1i8aRDyTIIZYKRdAUD6DpUce3ADk1gPb9Q0irnlxY51ZlCqeETLR/AqTGlj1LhkIL5IxBYHDuvG1/rER86moqUnnmWiMvLisabePsAfklHUjUGuqL5e1Iwi6Bqoa9v92ZAE3uCgncBJXLAOqv4ssXgrVpCu/qUBOHl2xlU7IjuRRt1FUBB4bvoXVMcrF2dX+tysmDt9/jjxR00vxQFpOLYt2jn53I2uM3h3Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6465b1c4-82a9-4592-bcff-08dee382bde4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:40.5422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bc+7VleXrGWT32DDbosl0T00LwzESU3QUoNaF77xeXQu0uTAKNW+wJRFGHk6cNFeYl0fUbCIV+GYQNFCKHQBJu2WOjF/IECJz4nh5GaAleE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8255
X-Proofpoint-GUID: QPBrySl2Y_VPvrxC3rnL45-uw-tM8qt4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX/chvlV+kDUqf
 c2mFsNWV7e45t5eMwEmghogYbmVYaUkZlfL0LxfBaAxw3rCgGvjmTaHwGr9AREkMNg5CTM1A1gh
 DU3DmepwzbH924BgrXNTVG7pDieMOgwA3QvrCdnIaHLIBFhZ3JpiT+eLPNlVHOWJ8qr3djLtvNW
 52jC4A+VGBF6Uh5FK99IlIb4cUSgpWQNnhDj5+d7Kqr7wjaUzHIzw1dlVPvz4+laFuxWWpS2Mou
 HccqhAxuY5J6Gd/g2imQha+lPq6JJ43RMHslyUNc75zWEnqsi2AzUtwyOqVNFvGjZqwKyIIT+cK
 VPlmVtQOnUefwnD56bKxCL3laR8lNXp9sv12Pke+TemboHQNeXlPhTb6MbaKsJ4RRKQEeV0EL4Z
 te13CkUuMAK6d6d4uhZkhnyV5rTfKD6lNe8jvQcfUZ9aGd92BsYMFEaay2kBx7MgLwV80F7caPY
 Ee9AaciMN+UOoIlsRfg==
X-Authority-Analysis: v=2.4 cv=d4HFDxjE c=1 sm=1 tr=0 ts=6a594f9e cx=c_pps
 a=wT4O3adra3cfqKKwvhZ7sQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22
 a=64Cc0HZtAAAA:8 a=AgFlfPbjf6SEF9yYaDIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX9aJljOOzM57w
 9P7G9QTXSnA8Qr7JblBDfhdHHIINWueWU6H/DdKGSMJ83whfwocepqglIC9e6+KXFNp7qw+sTjE
 3kEVznAlEF1pr8vQdEPeTbO4AAKuwgQ=
X-Proofpoint-ORIG-GUID: QPBrySl2Y_VPvrxC3rnL45-uw-tM8qt4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

When QEMU queries supported CPU properties via KVM, it uses a scratch
vCPU initialized with all host-supported features (like SVE and PAuth).

KVM exposes the corresponding ID register fields (e.g.,
ID_AA64ISAR1_EL1.APA) as read-only, the supported values only shows the
enabled host value (e.g., 5) and omits 0. This will lead into falsely
flagging a model as blocked as the features can be masked by not
passing those flags. For these fields, even if KVM reports them as
non-writable, we explicitly append "0" to the list of supported values
if the host value is non-zero.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 042d5fe804..ce77758c87 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1292,6 +1292,24 @@ static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
     g_array_append_val(ranges, r);
 }
 
+/*
+ * Some fields are reported as non-writable by KVM but can still be
+ * disabled by not requesting the corresponding vCPU init feature flag
+ * (SVE, pauth). The supported values are derived from a scratch vCPU
+ * whose init flags may differ from the real vCPU, so for these fields
+ * "off" (0) is a supported value in addition to the host value.
+ */
+static bool arm_field_off_via_vcpu_flags(const ARM64SysRegField *field)
+{
+    return field_matches(field, ID_AA64PFR0_EL1_IDX, "SVE")   ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "APA")  ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "API")  ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "GPA")  ||
+           field_matches(field, ID_AA64ISAR1_EL1_IDX, "GPI")  ||
+           field_matches(field, ID_AA64ISAR2_EL1_IDX, "APA3") ||
+           field_matches(field, ID_AA64ISAR2_EL1_IDX, "GPA3");
+}
+
 void arm_field_get_supported_values(const ARM64SysRegField *field,
                                     const ARMISARegisters *host_isar,
                                     ArmFieldValueSet **value_set)
@@ -1304,6 +1322,13 @@ void arm_field_get_supported_values(const ARM64SysRegField *field,
     /* A non-writable field can only ever hold the host value. */
     if (!arm_field_is_writable(field)) {
         ranges_add(ranges, host, host);
+        /*
+         * ...unless it is one of the fields that can still be turned off
+         * via vCPU init flags, in which case "off" (0) is also supported.
+         */
+        if (host != 0 && arm_field_off_via_vcpu_flags(field)) {
+            ranges_add(ranges, 0, 0);
+        }
         goto done;
     }
 
-- 
2.52.0

