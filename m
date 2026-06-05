Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957723D0C0B
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650527; cv=fail; b=RiefeqKuN3GyCI+Wa/gI8iYCvSfnVPZRHfD5taXkDwa+6wPJa+GtqFkyviwgXFCot2LshN9CRogb6rnhd7Ykhk71J4ppxEvEr50lIWbN3ZJUT7MSzk07r2Tu4swHAHh03UrWqFLRtjKaG+/mSJ1AJDYoEqJmw6mgK14XCPvuKkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650527; c=relaxed/simple;
	bh=FUh08sGbGuugcgzxvewogt8xJJoLsKzIL7Bv+qKi4YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PkTlNpdbF47y8dIPfOFA+zGKwhLcwxzXdY8x1HB6RtaTM+GCo0F0PZ1RVmfkc3vK1dDmXRws87PGbsw6uU+Ib2AxYXXXNPEKSKCHMoLjXMbS0vHf5UllMDqprntqlxQiOYW8+MYQaSrEYcYHbO71WBVGalOC9LVhbNbLcI7Kzzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=WOP9lA6G; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DLRswDWf; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="WOP9lA6G";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DLRswDWf"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUD1185382;
	Fri, 5 Jun 2026 01:43:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=nzvLLCFDcgiv5SzzronNXSYBhL5YYjPD/IO/IYgF6
	F0=; b=WOP9lA6GNDcjGUwP+Vq3Gf38nLB432rO8jebU3Tc+dIOyxtMFVhcs4RtK
	hwXu45UQ7E8hqTLPz4TNoyJRLcGQbgwu25aziTwTJ0uQj+oxx9hZ4QGQP6klm9m3
	BaFG45Tgz+/RtlcYtzA5oV4siwo1SMAQndFcSVafwqEHgbuP5h8iQGOEogquBlsp
	r2wRF2ulWue2EU11eLTesofuaDJ0tcHyfWeM/0aNf8QyKZ1by0JihCnIyfhumEbs
	GQQ66c700TjLDWsVCb1E4qr0iCBz6lev280q3bRhR0w0xiGjizIhvrt2EtzS0aT9
	JIqEXEQkLQ2Z7qaid6Pk9pQvG9thQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHuuAx3d/lztW6jEzQ6zX64y2mwlVmkc1McyTzT+rUq7CoyozngMBgUArGz5KlaedUHjlDHGMME1MfRe9wbhnUO6ZLnpixFCqlBwnWhY3epeQmV4xDqUgIjKCXNUwQsSYLIBBtf01ROuP4E9capA5Z5ilFP9r8kMLSKj6+Q3D/Vt02fbretYXb/TYxkp35HpNQTHd4/vtkZPOZ5xcBqFNHBVdaKna7z8mDp2U2mYFnmKKDoQLtmiEa+rMgbAEkheriRQ8TVYysEILwREHDqRWtyBnUact/h2wPxV+z6KIWbo7ZFU5I+IvdL7eTNeia7lZ45iTHTPAl5xpyT8PGZSZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzvLLCFDcgiv5SzzronNXSYBhL5YYjPD/IO/IYgF6F0=;
 b=PgsZGuEtj1YBhH5Po857rvfL7A8mYmIz2hyfCKb1pv1nWA09MZWhdYzC5mdvCEP8kDWIvPoHDnAM1AK6gyk9OW2b7vOIGLsHJXkaNVLI2THSL9KWYEmdDCMMl9EkRCVkQFBh2TKc8uOhfydhao1IO3TqoapzLZI95kdTKeGR/zh3sApXlNmRIzKX3+e4rwtnBFntx5oDmtQckLU2EgblOKQdnrcEdNTdE3vdZojhIwdHSrcWi+noA8pOcSCQJACdBQWaCckQaY8BDHtbzRkQWaTpAKrUTrPIB/VfFsiGSKzsVp4qBZ3OsGWSGi+BQXnHiuSVmftPJ4P2nFvNChQ+KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzvLLCFDcgiv5SzzronNXSYBhL5YYjPD/IO/IYgF6F0=;
 b=DLRswDWfwK/ZGD74pusYiboQCSFY90lNvd942IcGsOARMqhx1ze8qmWfC2IDcG2sKU6AtrZ8l3lithBf7UXpOstVdS4aU9iHkp4OxcaS6jrRdOvjgqhoFGR+o18kG4R/sug7/wyDRx74d0rlJNVJItz26PwvJwFKq91ZaSKseHmDU7RKcAB0XpcIRKyeKSX9u3ND9hAUS7AqaQvM+APX5krt9P6duw2WSd946sQ+/OxM+vvs6QgHI0QreTku5lURHYeD87PfYb3uMRChddDRBtNsXqVXuBUSHBA8dxAt7a6H1EI0OCpr4wIAaRKt6r/irkLGhUOkSyEwKKPhNVynxA==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:16 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:15 +0000
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
Subject: [RFC PATCH v2 18/29] target/arm: define pauth composite property
Date: Fri,  5 Jun 2026 08:33:47 +0000
Message-ID: <20260605083358.1320563-19-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 35b45724-27ee-49f7-f5a4-08dec2de7c37
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EnLJaLx0bG8kTWIvZmm5T7i/7Bs/e1lnZ+4FEt1Bz8alIaDfa6tGnan/kkJVD9uPiG/49lAUsMRZwo19w26qVCrzRU9GW9EYLMZFo4/CofCKIq4gVX93TkisJeNIVp6KQING2XX+w7likmhzmlGwvH6RKT07p4sUVrCFVWiS8q38YdnHr8ewqN1jhKKSwB9wn0dDP0tgmg9TZbmGsbxGaZKMClZ/hxS/V+TxUs552ioMobQBaV6nurfTgS+crBs8uUqo+XoO08zv/NxrkQflEbOYoEDC+tIfW5fBEWdu9pGg9mXJ2jecbKK60Y8urYN1sdyal7DI7hJCvgRgMrAXiS/TuwoR4pz5BnT6Gtn96Zn/HHxu9OY8ClffqilhNsWZIZpCPPY3pTsmer/nGLHtpb8l+iPYSRVMRTMT2bFLo0yi480PnPlkhER9HzdmqSnUDI2CDgZAmMsjQlvmR3ycAluD8Dr477NYxU0tAzqaGcB7DHq/GzpAJWLbLYCwG4IIzbgFCrX8I3D140mfL5JrzVP69pXbI5gQVbI5VTykK84sW0y2CCf4RjSEkmWSDYZSyypzdON2cOXHjxVXJ63MTp6uA+HKX0FHGsyjFhWoFqgicFjVUTamWz5RSU93JE1k/xsQ5VgYBI9LUOmcTQxDgpPqmglOLeYWl0fc2KHThGBApDfycyruEBOpmGmVP9Lk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EbVfn/nwQrikm1E+ptHfufqsF7Oe0UUwO9Xv7fPGsrtk5rpXhFJO8ugRIwFL?=
 =?us-ascii?Q?wcSFdGKCumjkIpfoPbFib3Quze+MgPtpzIU6CXMhAMD/nxykh4IzmtNjI/lk?=
 =?us-ascii?Q?Bs6G6DwTQ0YtL/oWa7JQG2px4JZCyJIEWOuU33bWuIIYxhPnaPHnWhzBf3/b?=
 =?us-ascii?Q?teM5qx7jV/Qate06eYjo1QA8EEL92EzmjoCCNHLEbZZdeTh9IPdJV5nWyYDR?=
 =?us-ascii?Q?fPpxB4ot5dpY3u5aBYe2pVo7nx7ADP9iqxGukZXVJeZTXtu2Uk5yRuIKE85d?=
 =?us-ascii?Q?dugP/QILoKnWXp+g8vfZcJfE8X94LbgOLmlG17qxU9qgO8pnOQSuduQq7+O/?=
 =?us-ascii?Q?JqVDFF7eSn0jtY0J6YN4TbiWzNBoBLUieLWEQtbEGkOKdd/6gNxGrexSonIj?=
 =?us-ascii?Q?yfZl05SMVgQcOCG7upkLoNT7pSt9e28lXQ7JUtL7+f+wqWfNJOkWT0s67dnu?=
 =?us-ascii?Q?vghl6jc/O1611/5+AUBp816RRn1B/wMmRShYzhcBtiqF4Fl94XMo9ULwN0tQ?=
 =?us-ascii?Q?quBSn1v/DJqjvVxU8ngW7A5UqjhU+pbLNkY3sKtAHbBz3ZPyq7M1+b+ap9WK?=
 =?us-ascii?Q?rnRcJscDjZJ2f6Igc8CSg0Qt0vIgWClci07H0/m8f3F83glSlNQjQM9wCLKJ?=
 =?us-ascii?Q?kARflFwgLMTsCVAK8w2LKdqzi5L1NEwULOTP2cvShPVLQ0MbByd7FbCB9UeJ?=
 =?us-ascii?Q?yHq8isr0scBEVx5NL79H5ie+s58/XgePiF6zXPRIC5TraJMY1DomRdMtVW8b?=
 =?us-ascii?Q?eZd1bvmD+u1k3UOb9VRfFbxgowmJ/z1PUi1zMRqPMuBhk4ENnT362mgcMfA1?=
 =?us-ascii?Q?jw7jnzRSnYIGpJnKQ1pVnEZRYyG0XSuN5wfQs8l0nfX2FoCwDxOd/uoJP1RB?=
 =?us-ascii?Q?aRnHNgfQKnIzdOqK+GE+/DYlYeWyaW7BDROkNY5zZfxp9yI16JR5pB7lncze?=
 =?us-ascii?Q?bv7bNiHi4SEYw0VC0oHXHWA20UJz9H/47FximgnWiyC1+dc0dlmikrT+P66l?=
 =?us-ascii?Q?K9GEjaK9l2G3Pss95vVTuW2W3xGreCALhdIq1JIrNqC5c3Lt6Y92oNcQU01e?=
 =?us-ascii?Q?CVi/WOfQ0ByrcQTCW77UZ8eQsJwiuhheMPCMOLFNxLyxStykA8/238vyXCfL?=
 =?us-ascii?Q?UcR8k3S0BLaR9fQ6KNG6Aqk739N2X1snULyKgNgubfU/tExtmp2Op4iCsaS/?=
 =?us-ascii?Q?LgwdCHPXKFIhxuYpw8jAdKMEa4Z58im323e1rtqDBnPRmA0PFWoo1rhE05YN?=
 =?us-ascii?Q?E7JP8sFRa/aGcTlZeePFDMTCYjw44yNjQuol/74tEIIaXpK/jYpRcvcKqhG/?=
 =?us-ascii?Q?YrmggmXHbogLsXf13M/lceOhdXBmu4jVk+uZxd40gCLdm8TtF9ytJOSG435T?=
 =?us-ascii?Q?QQCFmOF5lBjJ3FDVC0rbsh7zwW94DfvYqWZDz43n9eQA7UZxUivijNkCbEFx?=
 =?us-ascii?Q?kxBQ3pDN8myTxX+i2sWHTbeZsyc9kPjBZ+BAxadmhZwNyiki/BkJC07intOd?=
 =?us-ascii?Q?HhxMJoQKc5HqTT8w9BrQYX1liG/YjSMJ4tKWEhCW4wpI8EJ4edV94PwxtKUy?=
 =?us-ascii?Q?DkTw/0MkQ9HN8LrB9gzCgIurd2YKNwJYq5n+dkWHkQ14eZxpOyIgPc6EtJ1y?=
 =?us-ascii?Q?UdOGHBHEFgCaU75arN4yKApzN/HbmQuObEA5437VTJiSnQu9eYHUcZHBThQ4?=
 =?us-ascii?Q?ZLhCg96qyc1Q/TFh9asZCzRd3/5P7pFSR8nd7mw0lctrO8/FoSkEMuOl5aH0?=
 =?us-ascii?Q?V45zpzWMOP1tWSgehAElGZkjpHRwtE8=3D?=
X-Exchange-RoutingPolicyChecked:
	pUlu8qLqM8NdJUZMdV3YGoDkavzfGGUjKRXNttlx5LZpzd9szs8C8ere2Szqny5HJ+lX8dBKf/KVHNkGybraU3+PG9ifN2DQ1lL9bqwMcxZyHfdlmeDeE7CKAXP7VaikI0XtUUqJY/JmMncYzseuETl2wg2PM7bT1tmGCRYaqA1yexMqvkx6QGuM5RkTziXzkqPKhtZRKAzwaqK8J+7Q2Q612wYbVmsK3HCRm/Zx8356VSRz9SrOMfvnFSkTEdUm6TVUJlxnOKkFuJxD2qdzhvmAo7wGzFz+UFs57UKiymkLO1/qIIUvOqGrjW9xkDbDRP6OzNaSrcUgrhBPxfDDtQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b45724-27ee-49f7-f5a4-08dec2de7c37
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:15.7194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSLIKHZh0NgxIGGU5ys8Exocfjt5Yk+83KQaL4DpXkvUy1GbX3zW4To4UfOPpbsB8I05ipwzIETQfgjKrlBHqHvOCMJEM/mjtRedRLy7U+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXx+4W5l/1wHMC
 omaPEQRe816vd0Jl2zMwR6hR9pKLZULd3GJOqakHvPhqcqX3cwM2bM5A2aON5iv1Ay1uTI3du1Z
 uMLL96mf+SiCOX80KWi0s15/JN1Li1sIV+okR7YaNjvfAgBTZd3lnPIgZ6brqE83Q57L7kePe5x
 FpF3YKsNiw86koUqeeeY3L4Yg4O2qxybeO7iaLHQMwHpuYuQBCU8VFglpqhAuPjf3JVOhTJDP/Y
 VwXox4k5x6QuIyOcgoRz4RS5aqYszaLeyecgdbhlGYdcYxeHRpkQHtA2ww2kR6FZgpNdzccFtNQ
 9uIMxj3qRKDVzkY6CBx0qwp4ez2omr1KGaxK3h+blkPHAeL2GOVmpITEiHYlVBKleGNjTtDSf3o
 PtAfcXYiW1BWDqPMhFtLgPELUVE0bgfZvK0Fk7Wk/ABPgp5PEr+Esjaeiaixh9pd6LWPzk8YCwj
 9ULYHq7Ze0eDUJjeO3Q==
X-Proofpoint-ORIG-GUID: BMAJwub-L38XYRdeZSefpvC0YZRHgpgn
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c27 cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=84awLtjXEynXEqeMRz0A:9
X-Proofpoint-GUID: BMAJwub-L38XYRdeZSefpvC0YZRHgpgn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Define pauth composite property for named cpu model. Define a
custom getter which checks whether any PAuth algo is present.
The sub property list covers all six PAuth fields.

Add appropriate pauth composite model values for neoverse-v1-v1
and neoverse-v2-v1.

In arm_cpu_pauth_finalize(), return early if cpu is an instance of
named cpu model, as the authoritative ID regs fields values are provided
by the model in that case.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models.c | 14 +++++++
 target/arm/arm-cpu-props.c  | 76 +++++++++++++++++++++++++++++++++----
 target/arm/arm-cpu-props.h  |  2 +
 target/arm/cpu64.c          | 16 ++++++++
 4 files changed, 101 insertions(+), 7 deletions(-)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 4b19049205..1fe20b7d6e 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -84,6 +84,12 @@ static const ArmModelPropValue armv8_4_a_v1_props[] = {
     MODEL_PROP_END,
 };
 
+static const ArmModelPropValue neoverse_v1_v1_pauth_props[] = {
+    MODEL_PROP("hw_prop_APA", STR, "pauth2"),
+    MODEL_PROP("hw_prop_GPA", STR, "on"),
+    MODEL_PROP_END,
+};
+
 static const ArmModelPropValue neoverse_v1_v1_props[] = {
     MODEL_PROP("cpu_implementer", NUM, 0x41),
     MODEL_PROP("cpu_variant", NUM, 0x1),
@@ -146,6 +152,7 @@ static const ArmModelPropValue neoverse_v1_v1_props[] = {
     MODEL_PROP("hw_prop_CWG", NUM, 4),
 
     MODEL_PROP("hw_prop_BS", NUM, 0x4),
+    MODEL_PROP_COMP("pauth", true, neoverse_v1_v1_pauth_props),
 
     MODEL_PROP_END,
 };
@@ -197,6 +204,12 @@ static const ArmModelPropValue armv9_0_a_v1_props[] = {
 };
 
 
+static const ArmModelPropValue neoverse_v2_v1_pauth_props[] = {
+    MODEL_PROP("hw_prop_APA", STR, "fpaccombine"),
+    MODEL_PROP("hw_prop_GPA", STR, "on"),
+    MODEL_PROP_END,
+};
+
 static const ArmModelPropValue neoverse_v2_v1_props[] = {
     MODEL_PROP("cpu_implementer", NUM, 0x41),
     MODEL_PROP("cpu_variant", NUM, 0x0),
@@ -257,6 +270,7 @@ static const ArmModelPropValue neoverse_v2_v1_props[] = {
     MODEL_PROP("hw_prop_CWG", NUM, 4),
 
     MODEL_PROP("hw_prop_BS", NUM, 0x4),
+    MODEL_PROP_COMP("pauth", true, neoverse_v2_v1_pauth_props),
 
     MODEL_PROP_END,
 };
diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index 5e876aa768..11f45523a0 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -51,6 +51,30 @@
       .get = _get,                                                       \
       .set = _set }
 
+static void arm_composite_set_internal(ARMCPU *cpu,
+                                       const ArmCpuPropDesc *p,
+                                       bool val,
+                                       const char *name,
+                                       Error **errp);
+
+static void pauth_set(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
+{
+    bool val;
+    ERRP_GUARD();
+
+    if (!visit_type_bool(v, name, &val, errp)) {
+        return;
+    }
+
+    arm_composite_set_internal(cpu, arm_find_prop(name), val, name, errp);
+    if (*errp) {
+        error_prepend(errp, "Property '%s': ", name);
+        return;
+    }
+
+    cpu->prop_pauth = val;
+}
+
 const ArmFracVal csv2_frac_vals[] = {
     { "0.0", 0, 0 },
     { "1.0", 1, 0 },
@@ -268,11 +292,32 @@ const ArmCpuPropDesc arm_cpu_props[] = {
     { .name = NULL }
 };
 
+static const char *pauth_sub_props[] = {
+    "hw_prop_APA", "hw_prop_API", "hw_prop_APA3",
+    "hw_prop_GPA", "hw_prop_GPI", "hw_prop_GPA3",
+    NULL
+};
+
+static void pauth_get(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
+{
+    uint64_t apa, api, apa3;
+    bool pauth = false;
+
+    arm_idreg_field_read(&cpu->isar, ARM_FIELD_IDX(ID_AA64ISAR1, APA),  &apa);
+    arm_idreg_field_read(&cpu->isar, ARM_FIELD_IDX(ID_AA64ISAR1, API),  &api);
+    arm_idreg_field_read(&cpu->isar, ARM_FIELD_IDX(ID_AA64ISAR2, APA3), &apa3);
+
+    pauth = apa != 0 || api != 0 || apa3 != 0;
+
+    visit_type_bool(v, name, &pauth, errp);
+}
+
 const ArmCpuPropDesc arm_composite_props[] = {
+    ARM_COMPOSITE_PROP_GS("pauth", pauth_sub_props, pauth_get, pauth_set),
     { .name = NULL }
 };
 
-static const ArmCpuPropDesc *arm_find_prop(const char *name)
+const ArmCpuPropDesc *arm_find_prop(const char *name)
 {
     const ArmCpuPropDesc *p;
     for (p = arm_cpu_props; p->name; p++) {
@@ -499,10 +544,12 @@ arm_model_prop_find_by_name(const ArmModelPropValue *props, const char *name)
     return NULL;
 }
 
-static void arm_composite_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
-                              Visitor *v, const char *name, Error **errp)
+static void arm_composite_set_internal(ARMCPU *cpu,
+                                       const ArmCpuPropDesc *p,
+                                       bool val,
+                                       const char *name,
+                                       Error **errp)
 {
-    bool val;
     const ArmModelPropValue *model_sub_props;
     const char **sub_props;
     ERRP_GUARD();
@@ -514,9 +561,6 @@ static void arm_composite_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
     }
 
     sub_props = p->u.comp_sub_props;
-    if (!visit_type_bool(v, name, &val, errp)) {
-        return;
-    }
 
     if (val) {
         for (const char **sub_prop = sub_props; *sub_prop; sub_prop++) {
@@ -552,6 +596,24 @@ static void arm_composite_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
     }
 }
 
+static void arm_composite_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                              Visitor *v, const char *name, Error **errp)
+{
+    bool val;
+    ERRP_GUARD();
+
+    if (!visit_type_bool(v, name, &val, errp)) {
+        return;
+    }
+
+    arm_composite_set_internal(cpu, p, val, name, errp);
+
+    if (*errp) {
+        error_prepend(errp, "Property '%s': ", name);
+        return;
+    }
+}
+
 static void arm_cpu_prop_set(Object *obj, Visitor *v, const char *name,
                              void *opaque, Error **errp)
 {
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index 392a0391d6..a108dee1a4 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -48,6 +48,8 @@ typedef struct ArmCpuPropDesc {
 const ArmCpuPropDesc *get_arm_cpu_props(void);
 const ArmCpuPropDesc *get_arm_composite_props(void);
 
+const ArmCpuPropDesc *arm_find_prop(const char *name);
+
 void arm_add_cpu_props(Object *obj);
 void arm_add_composite_props(Object *obj);
 const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field);
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 0300f8677f..d326b3220a 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -38,6 +38,8 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "arm-cpu-props.h"
+#include "arm-cpu-models.h"
+
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
     [NAME##_IDX] = SYS_##NAME,
@@ -554,6 +556,20 @@ void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
     ARMISARegisters *isar = &cpu->isar;
     uint64_t isar1, isar2;
 
+    /*
+     * For named CPU models, the model props (and the composite "pauth"
+     * setter) write the authoritative APA/API/APA3/GPA/GPI/GPA3
+     * directly into cpu->isar. Lets not override them.
+     */
+    {
+        ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
+        if (acc->info
+            && arm_find_model(acc->info->name)) {
+            return;
+        }
+    }
+
+
     /*
      * These properties enable or disable Pauth as a whole, or change
      * the pauth algorithm, but do not change the set of features that
-- 
2.52.0

