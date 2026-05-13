Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0E54C9576
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690093; cv=fail; b=uRiNkqLd2pDS5Vj6lWSKbYMS4J/VWx7di2Kns+ln2hy2TV/ErIi3yOKNi9nE0iKJXJNzuV+wn/96N9jIq1JkfUlUd2dHOAgN1npNCqYDUXusWhD4vSD8chHGI4SSFEPHhGf8fQZmkyopYszAOJtxMu/4cCwXqu4rPxS0DeYXzCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690093; c=relaxed/simple;
	bh=fEdtSB5sx3w+au1jhbeBjQKcL/nXW3Pl4HxQ3ivb/wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DuCNm6H5ltrdqI9RL+I0rfO5JTDhH6/5MlUABt5Nf2uEGFqqQXbNGjGzLs7ThecqNDvk9LBdlczb+/EvcQiZN3SWUiW1sY+xANfBTHpa8g/tHHggcHDMwG9VRjv0YGDYohA3z68dkmz9EWfMnu+3ZDeCe7zqYLEmwzRcy4hRSWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=prXIhkw/; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TZc041Tl; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="prXIhkw/";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TZc041Tl"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKvem2443069;
	Wed, 13 May 2026 09:34:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=yYRoHBgTKlzLw
	yduYLvJ7rzsLRR7sR8DTkLfZSHzcgo=; b=prXIhkw/0d3+VAv5BMgjBYx8+jVuB
	i3zT+4D1EZcBfmJeb5/+UkQQ1k5ejpVq+co+LCjk7fP8tL+PKQ0FPOxGEFAQyo+Y
	JSdM/iPfP0y5bUtuYb9xofi5iz04E85mcd29q3yMu0b2vYBLdm6MTeLBwFv6Cibp
	UYbjCNcwojToJpEF4fgPPUOcyT8TChnIiJ1v0fsbdKPdtMViaRRDrytPZSyjXBHY
	WnGGysQWnYUgwuXPl0ZnEed/Yn/JGxokvcNt5cMivloEfgXs+Pc1PeWxwmHymn19
	+8dJf93B9qMhOUf4tkQmAQEDgXS3LcNPTGWMsGWc85eE9P87/kDT0Gnsg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020081.outbound.protection.outlook.com [52.101.193.81])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nv6x8yf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nO3+JMb/Tb5odOKBFqLrmJVf8p/rcAbl/NGeVuOknkec1luQfYdOu2IUhzEdwvePK7eq+gOeno2Vd89nCnhxXNLbXpmaBpGDHM+FXlg+aaBdgH9dHuljbbqfhnjJqYGXXxYXpvwtCJOfGtgt4B6dl13lzF33q+/D8QMmqR0W8NVFtyoJ/rDN8ipvFm9CTQpIXAE1y/MTApHs34woi0ev+Hd0TGIWPptohgM8GeHd7BHnD+HuvqB43boSlNDrmIzbNKaLZcJQFfaRVHAGGRMG9Np9lTg/G08SriTZqRwDcOfYJr2kKXdDg2uLwzv2QDseECEN9hzEaLmDtUfdQHeqqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYRoHBgTKlzLwyduYLvJ7rzsLRR7sR8DTkLfZSHzcgo=;
 b=dXiJBXruweEmoZCuQOiwnNCvoqk5eKZBPF9LNdxA6SPzVuOBfGBJDiRvABYfP9Schsrn5NXX3P4S7iWTS09F2OP26skIrHf2/HIjhQ9nrIL04ol3Ri3CYska4XyN4YzruYr/08/rB88+1YGP3hY1r9Lfse6zY6eVs/z5Y7daI0hwk4D4TvL7+MJj0sI9klpDGdPNBwx/g8ysUTrXAlPinNejpr8OjkmJRFOzoiOGviWbsXb8qzBu3SCugxmNnyLgsfD7sIsePeZFySOB6M3YHeZhPwF8ujD8cNObAF3k2OYDhq4aRyLw66mBuxkjc9cQG5E40fC3EO2mx7hpKhwiOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYRoHBgTKlzLwyduYLvJ7rzsLRR7sR8DTkLfZSHzcgo=;
 b=TZc041TlOegXaEgXPhcweB9KGomSSaXoYalzgUyWqn5A/A7QQmm3SqqlXuq23gxZ3rCbQuNdhXUguGICHFk7Z4owjIsgWzo1Pe/cBEqGaYbVbTmnk4sHiJFBM/immW5JukaIx56octn1U7nqVoBQlcMLLqMQR3dJogn1GmEFJrWFppf7Gtw2ZjGmKlo0eSEp1Wy9jHLE+NrsxRAx0y6xHosjUqw03U8y//I72+Sb6e8E3kdAca3IklLB5h8sQItdYpe7W8MNaCVD4eHFF7LTBoON7iAbXY9er0U6dDeUXty/cK9eKrwTvXPJVfLvqXdFJP5xvG1fUjgs23l6PAN1gA==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by CH3PR02MB9564.namprd02.prod.outlook.com
 (2603:10b6:610:120::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 16:34:06 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:06 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>
Subject: [RFC PATCH v1 00/13] named CPU models for ARM64 on KVM
Date: Wed, 13 May 2026 16:33:43 +0000
Message-ID: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: PH7PR02MB10160:EE_|CH3PR02MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f9e65ac-ee69-44d8-5818-08deb10d7348
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|921020|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	wOxLR2DRRSyWSXESIUAKgcaUfLWOVSYvAyIEsXrrfSO+xs/q37eAOCKKBDiIDhGmP0J2nshkb022hadV/o+a2yJLGYVGlTNw7cfW8wJqrKVESi2TVyKRJg+Gp+4jRo24f2OuGsu5b6jg+IuA7SToQ17JnvJ3M3NmoLxXJscl2/wRBm2hUDhKJkSmFI23w/wQNuTpnTR8MutPCfRxBN1VQKxxIFkaKYNeB9LYiTRG+q/b8U01OG7tk5Rvu7A4O+Zm7Fs7x8XPWjNx9T5BwZBe1RgD7ySfeI6+XC2Qlxjr6+/6GVnHuemiwrD9ogea6bM4s9gtHo/1mth6dWeJSzoByDC/Oisv/Qz02RyV5uyPb5zNCkv/1K0cwVnZ0VLVvVuFaeYNF/8DZDcdwC8vQkYOCHktbgPhNPhIPgE2HQgNQ2Ii+yZE2msiD1i0Z+5oRGNNhUjbPbTViJINowKf/HqD73m1PtzLSouJDMJNefJB1Csmp7cmMDYBWUcAfPlwF0bBHe390u6mWKOjQKb3LRZRWN79FHBxWRCwQKtgpr+cdFeFMZO9TaH5wkVa1IN/XFvFymQKT2J0EJmqxrwW7S8xt0LVzBMDTJU6ZjYE5Zm5QmJYot19JGds2YPQaEx/82ywLNDFhHJgJ+K4I63x2sV+f8XVykQ8mgYAchIM1H/bHbHyzdM+XMkbt6nGWqIQ20OPmvSv0jcnr5O6xW1MWDl1jEfKV+PVwFxpDWjFH2OZdV2Ea2ADwQ0QaBW8xI6+O2+4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(921020)(56012099003)(3023799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?96VCwLnewk1Ypy1qTd1ifREdXicF4c81fpLmc4DudAUavYJ+f11pY3ZzG/sm?=
 =?us-ascii?Q?tDm99X9QqU2BQ5XTWkFu7+GgVVUI3hKL1H0y/oqJpNIesYb2ehLKA0aDrzNd?=
 =?us-ascii?Q?7L3pOopiRmXQ382ImOPCNHTLjxWcUM9hzZ+cp6l2fAaySGW4XZV4K9Lcxf9k?=
 =?us-ascii?Q?1uOn/fLuad7FmpIgzCggricFPQ/e2nCueuvHd4XkjRMSIRn75zoipg8yKkY+?=
 =?us-ascii?Q?y/JgUXQ1Oqu0TycrgeqXkIOEqLPFyHFtQKmLoqzL1HZeLXXuUtR3hVqlqUaj?=
 =?us-ascii?Q?f4ZSEGMemlppjnMv//qO/RCsqn2T6V0qGyLnnF4JN1XK6xqSWogoOSCkJMcX?=
 =?us-ascii?Q?o0Pjo0G7HwIMbUX1z2VW0VokJKfvWm10ZsYjDYY/Gy9jMTUCLlx7SLgiNHpS?=
 =?us-ascii?Q?Vbw0A+rin+7WrO3fVp1L/hztSOl83b5GHAx/lc1t5FNeI6e4DJiI6q/bMRYX?=
 =?us-ascii?Q?IDEbb33zOUgcOeUrMzYHHLCjnojTgpTwX9BnHKa/SRGftfSK4CVcAoWO3vkH?=
 =?us-ascii?Q?LFuKP6U7Z5thFblAD/10W+0T+mkiUWBB6aE9xg2NVftgWhz+qEs7vIkPNbBB?=
 =?us-ascii?Q?+7h5xgSnOWe5F5xBeeKDxC1VgwWaAQrrPq1vlZ/2kF+zs9ywvto5FrR6S4LJ?=
 =?us-ascii?Q?EDkJNAHZ/kyBt+MtJ7I8Mjn2XVDXT0wgfXSbYrjiz4Kz7oQ2M5QgFY+MIyJC?=
 =?us-ascii?Q?t+Kh8gaY8Uc4dsmomYlw9vU55VsUGeqDudK46k7KOiDOyACCBZERXptZzyFZ?=
 =?us-ascii?Q?OGjEhTFNHjHuQTRm+ABx3wvV8B6nKWB2uEDoNJVdqn9mxVeV0ikEfkoFZTU4?=
 =?us-ascii?Q?FCJavlGEGB3DfIA/gTsASh9zwOycjnLHrhG59AmqjOV9ttj2h7dz3w2Zyp2U?=
 =?us-ascii?Q?ZU2L7azrKNjyf8Oh8lMA+N1gbmj83nQ3igOCTaVscw0muZUf/d/m11y4bBWu?=
 =?us-ascii?Q?47ztKzL1BGIj5zxtx4uRSvPzvMUiAC/zrHKBGLxlG4u8DQBHtt5uvgXNnldx?=
 =?us-ascii?Q?rt1jh55pT6pnyeAPg445lFUGpDNNLO6LERKwmN+8X8RfSG/CezJs1uwhZZOU?=
 =?us-ascii?Q?n3lbAlT2v/j8vWMFBinN8o79JDm0dZCmJmWYJK1n7WyqmVm3XwF6oZZImw1n?=
 =?us-ascii?Q?CIGVueeqJyWg+NdPLgZYg5W7tvZbnDH4RitFfsONZxg3bmTpjuhfmk1hVh3T?=
 =?us-ascii?Q?u7AjzFG9Keyl9+n8urvbcAhEH7W35AESpvdyTnOoG/P1W9Z5dQ4DlYafVHru?=
 =?us-ascii?Q?VDgWv0kOHhgDfH7YLgV3D+FBYvf8oY4mPGzuanwLCKkosjZZdtL9djY/5jHE?=
 =?us-ascii?Q?qqqeQWnAHkmRUvxCtu11ltDf6smavhhccXHtTrFITN+sKa37tgAxQIesrz6S?=
 =?us-ascii?Q?fEypygdaL1y7VOGP7NMzvuOZkVKTW1W7ZWEXBeqV6p6KSnXipe2zCYH0Mbdv?=
 =?us-ascii?Q?WDC7N9r+INPXp1DLjkVBRxrD6LpDwnGlahPQoHuzr+wu2Yu/hQnYHi7RDFKA?=
 =?us-ascii?Q?Nybx+XdILdCqhEnMKEt+gO8RKs/X/HhM6j59TDyrr4GO1tEvzlaFgiTV9RgX?=
 =?us-ascii?Q?7QaIXnkTGpGY13rhAGCRtJpCMdRj7yuNHm0B3pVJzSPfeZBaTXutISJpOCJx?=
 =?us-ascii?Q?z62ZA9lotfQAZXVfPVsk2NzbBh2E3WAN1AkgsGzPT0Lekl3L31lAXRVmY8Fl?=
 =?us-ascii?Q?TOj+k8xeRjrNiJmDchvoTIOHdAm+O9l+S3kY0a01yh29fl7iYOruNSdNa5dD?=
 =?us-ascii?Q?C2ZCseIWWHlgCGmuBt5opVbFApMTufw=3D?=
X-Exchange-RoutingPolicyChecked:
	hm5YSNQm9XU6viLcWyJsRYuOyG5BpsatLU9l4QLGSOj+3EzMLzKN/T9c5mXvJmlSysToVuGhiylMcjIxdTrE6HK1zXbpa97zj27T+jEjlpMlLLkKSbGRpciTVwQc8+rwWOV1asJvUxRdls1J+F9ZFID9yH4T+6SYDwDR93XmkLFCvYuUz3LIkKQsZ3APTeh9Z2PIwfjMlpBi5BpDH0uoapwYATseQA4m3ge18zZwe+RSdJ0b8SI/bYBu08EkX0ORYBg/E2055zzri233lEkhgSCvrsEm7fnZGl2Df95ZLaiFky2jfE91nZx0C0E3vHaONzqCa0EBoMwdx8U1TwZHLw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9e65ac-ee69-44d8-5818-08deb10d7348
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:06.1557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/FRi/dJcqLWTMOe9oHpGmKBXcnbhyaQVLRmLIvmDRHcxeTuGalouRJovCpattA/b53+DbialjLfqi/bvcaXpIXQslukurWfSMJWnjg8LiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9564
X-Proofpoint-ORIG-GUID: OAc2w5S-ur-iUOv7Xd44cZOIqXp7jyjw
X-Authority-Analysis: v=2.4 cv=P7QKQCAu c=1 sm=1 tr=0 ts=6a04a800 cx=c_pps
 a=6CsdduS81u+lxnadr1BEog==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=CtIQ0sTlcfwyWDQDvTIA:9
X-Proofpoint-GUID: OAc2w5S-ur-iUOv7Xd44cZOIqXp7jyjw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX5u0GRSU/dWrE
 /JjuScJ1RDXV+fHtTGwEDkrcMl6TfrSFH0vhB0OSLWezPSjhGzh8lBFhxu6nhgh3kDZ1n4/47Lv
 QPLq61+Bz5zyHWiKwtlmOyaBVYFLouWG21fDI5tYDc5VQPqTaqT/JasAZ/4ctiTNFqJpbQPjfQz
 7KKDjuVnwjoPNWuxUDfGaew+O6KRgh2pJ5sgSCYMJHg/PdYfrclNVys/F2sQdFtD3llZSgJWwTd
 9Ee+0CwSx0MLuJ4SXdBrqOGt75gCXtzuhfBfF0V1eBtjQYL004UnkSJzbjqlYUjeyb/fdRKZEua
 uqbff1aLBGCK8mD4o5ouoE/687JiTpMZD3yjnWqiAkDoZRNrNBg9KSsf47Oc6ZN8Xv3QNwUZt51
 2mNI8N1YVz9/KG99e+t93ADOP2josQxFjirjQQRpuzhegeek0Ft793AS7iB6HYj6a4WZ8Ce03iD
 OyzTRWpSx0/4pgcTvZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Hi All,

This RFC introduces "named" CPU models for ARM64 KVM guests. This
is foundational for cross-host live migration and management-stack
control over individual CPU features exposed to the guest.

TL;DR Examples:
  # Boot with Grace CPU model
  qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...

  # Grace with a feature disabled
  qemu-system-aarch64 -cpu grace-v1,feat_SHA1=off ...

  # Host passthrough with individual feature control
  qemu-system-aarch64 -cpu host,feat_AES=aes ...

  # Neoverse v2 on Grace.
  qemu-system-aarch64 -cpu neoverse-v2-v1

  # Migration from Grace to Graviton3 (TBD)
  qemu-system-aarch64 -cpu neoverse-v1-v1 ...

Relationship with Auger/Huck's customizable host model [1]:
We have been working on this series in parallel with [1]. Eric Auger and
Cornelia Huck's series [1] exposes raw SYSREG_<REG>_<FIELD> uint64
properties on -cpu host, providing the essential low-level knobs for ID
register customization. This RFC builds on the same KVM capability
and can be layered on top of [1]:
  - Human-readable property names: feat_AES=pmull instead of
    SYSREG_ID_AA64ISAR0_EL1_AES=2, with arch-defined named values
    validated at set time.
  - Default values and forward compatibility: CPU models start from a
    known-zero baseline rather than the host view, so new fields/registers
    introduced in future kernels do not silently leak into existing models.
  - Named CPU models with hierarchical inheritance: grace-v1,
    neoverse-v2-v1, etc.

The two series can coexist; this series can be rebased on top of [1].

[1] https://lore.kernel.org/qemu-devel/20260503073541.790215-1-eric.auger@redhat.com/

Problems with defining "named" CPU models for ARM64 KVM guests:
  * Features are not single CPUID bits. They are mostly multi-bit fields
    encoding version/level instead of just presence. A single field encodes
	multiple ARM ARM defined features (FEAT_s) at different thresholds.
  * KVM does not allow all registers and fields to be modified for a guest.
    Some fields KVM does not virtualise at all (SME) or only support host
	values (BRPs, CWG, etc.). This is evolving and differs between kernel
	versions.
  * ARM does not have a single natural granularity for CPU models unlike
    x86. ARM has architecture, reference core and SoC levels each becoming
	more granular.
  * ARM has dozens of vendors and it will be tricky to maintain models for
    all of them.
  * Previous designs started from the host values and then subtracted
    undesirable features. This is not forward-compatible; the design
    should work when a new ID register or field is introduced.

With the above problems in mind, the design has 3 layers:

1. ARM ID Register Field Table:
   - This layer maintains all architecturally defined ID registers and
     ID register fields. It includes:
		* Field name
		* Field shift
		* Field length
		* Safe-value tag: LOWER, HIGHER, HIGHER_OR_ZERO, SIGNED_LOWER,
						  EXACT, ANY
			This will be used to validate user-provided values during
			CPU realization time against the host's value. I.e., if the
			host only supports "aes", a CPU model that sets "pmull"
			should be rejected.
		* Default value: The value to which the field is reset. This gives
			CPU models a clean cpu.isar.idregs[] baseline instead of the
			host view provided by the kernel, as in previous designs.
			This also complements the forward-compatibility story. Given
			the "default" values, higher levels need not worry about new
			fields/registers being introduced.
		* Architecturally defined named values like "off", "aes", "pmull",
			etc.
		* These values are derived from the kernel's ftr_bits array and
		  tools/sysreg file.
    E.g:

     IDREG_START(ID_AA64ISAR0)
     IDREG_FIELD_START(ID_AA64ISAR0, AES, 4, 4, LOWER, 0)
     IDREG_FIELD_ARCH_VAL(0b0000, "off")
     IDREG_FIELD_ARCH_VAL(0b0001, "aes")
     IDREG_FIELD_ARCH_VAL(0b0010, "pmull")
     IDREG_FIELD_END(ID_AA64ISAR0, AES)
	 ....
	 IDREG_END(ID_AA64ISAR0)

   - This layer is the single source of truth for ARM64 ID registers.
     The default values and safe-value tags are manually derived from the
	 kernel's ftr_bits array. Other boilerplate and arch-defined values are
	 script-generated.

   - AArch32 ID registers are added with a single field so they can be
     zeroed out on hosts that support AArch32.

   - This layer also defines helpers for higher layers to extract and
     manipulate ID register fields.
       * arm_idregs_reset_to_defaults(): Reset all ID registers to their
	     default values.
	   * arm_idreg_field_read/write(): Read the value of an ID register
	     field.
	   * arm_arch_val_name/from_name(): Look up the arch-defined name for
	     a numeric field value.
	   * ...

	- This layer creates the following tables using X-macro expansion:
	   * arm_idregs[]: Array of ID register descriptors.
	   * arm_field_locs[]: Array of field location descriptors.
	        (fieldIDx -> registerIndex, fieldIndex)
	   * ...

    - The ArmIdReg struct also includes a writable_mask to track which
      bits are writable by KVM. This is populated at runtime during
      scratch VM creation, and is further used to validate that only
      the writable bits are modified by the CPU model.

2. ARM Properties Layer:
   A small property layer on top of the ID Register Field table is defined.
   This series defines two types of properties with plans for one more
   in the future:
      - Single field properties: These represent ARM FEAT_X features
	    that correspond to a single ID register field. Example: feat_AES,
	    feat_SHA2, etc.

		The property name is set as "feat_<FieldName>" and possible values
		are the arch-defined named values. This can be further categorized
		into:
			* STRING: multi-bit fields (>=2 bits) with arch-defined named
			          values, example: feat_AES, feat_SHA2, etc.
			* BOOLEAN: 1-bit fields only (true/false)
			          example: hw_prop_IDC, hw_prop_DIC, etc.
			* NUMERIC: IDREG_ANY fields with no named values (raw integer)
			          example: hw_prop_BS, hw_prop_DZP, etc.

		String property values are validated against the arch-defined named
		values.

		ID register fields that are not covered by single field properties
		are also exposed as a property named hw_prop_FieldName. These are
		usually implementation-defined values like cache geometry, debug
		counter widths, etc. (CTR_EL0.*, DCZID_EL0.*, etc.)
		Example: hw_prop_BS, hw_prop_DZP, etc.

		Single field properties are defined as:

		ARM_PROP("prop_name", type, reg, field)
		Example:
		ARM_PROP("feat_AES", STRING, ID_AA64ISAR0, AES)

		* Validation based on safe-value tags is yet to be implemented.

     - Fractional properties: These represent ARM FEAT_X features that
	    use two fields (base + frac) across registers. Example: feat_CSV2,
	    feat_MPAM, etc.

		The property name is set as "feat_<BaseFieldName>" and possible
		values are the arch-defined string values like "0.0", "1.0", "1.1",
		etc.

		Fractional properties are defined as:
		ARM_FRACTIONAL_PROP("prop_name", base_reg, base_field, frac_reg, frac_field)
		Example:
		ARM_FRACTIONAL_PROP("feat_CSV2", ID_AA64PFR0, CSV2, ID_AA64PFR1, CSV2_FRAC)


		When a fractional property is set, both the base field and frac
		field values are set to the corresponding values.
		E.g: feat_CSV2=1.1 will set ID_AA64PFR0.CSV2=1 and ID_AA64PFR1.CSV2_FRAC=1.

	- Composite properties (planned for v2):
	   These will act as master boolean switches that control a list of
	   fields. Example: pauth, sve, etc. Setting sve=on with a named model
	   will set all the SVE-related fields (ID_AA64ZFR0_EL1.*) along with
	   sveNNN vector-length. Similarly, setting pauth=on will set APA, GPA,
	   API, GPA3, GPI, GPA3 fields based on the named model.

	- cpu_revision, cpu_partnum, etc. properties are introduced to expose
	  MIDR, REVIDR, AIDR fields.

	Exceptions to the property naming are made for ID_AA64PFR0_EL1.ELx
	fields, which are named elx_mode.

	This series defines over 130 single field properties plus 4
	fractional properties. All properties work with -cpu host also.

	All properties change the cpu.isar.idregs[] values which are later
	written back to KVM at the end of kvm_arch_init_vcpu().

	* The arch-defined named values and property names can be iterated
	  until they make sense.

3. ARM CPU Model Hierarchy:

A small named model layer is defined on top of the properties. An ARM named
CPU model defines a list of property values and a parent model. A child
model naturally inherits all the properties from its parent and can
override them when needed.

The initial model hierarchy shipped here is:
    kvm-base-v1                  KVM-imposed quirks
      arm-v8_4-a-v1              ARMv8.4-A architectural mandate
          neoverse-v1-v1         Neoverse V1
		    graviton3-v1         AWS Graviton3
		arm-v9_0-a-v1            ARMv9.0-A architectural deltas on top of ARM-v8_4-a-v1
          neoverse-v2-v1         Neoverse V2
            grace-v1             NVIDIA Grace

(kvm-base-v1 and arm-vX are not meant to be realizable unless the
 user provides values for implementation-defined fields)

So for example, grace-v1 defines Crypto fields and CTR_EL0.IDC/DIC on top
of neoverse-v2-v1, which leaves those fields vendor-configurable.

The hierarchy reflects a deliberate trade-off:
  - Architecture-level models (arm-v8_4-a-v1) maximize migration
    compatibility but lack implementation-defined values.
  - Reference-core models (neoverse-v2-v1) enable migration across
    SoCs sharing the same core design.
  - SoC models (grace-v1) expose the full hardware feature set but
    limit migration to hosts with the same SoC.

At model realization time,
    1. a clean slate of cpu.isar.idregs[] is created using
	   arm_idregs_reset_to_defaults().
	2. Then, a model's full parent-chain is walked and all properties are
	   applied in order from parent to child.
	3. Finally, kvm_arm_writeback_idregs() compares the model's desired
	   ID-register values against the host-provided cpreg snapshot and
	   writes back the writable bits, warning on any non-writable difference.

Models will follow a monotonic versioning convention (grace-v1, grace-v2,
...) mirroring x86's scheme.

* Please take the CPU model property values with a grain of salt.
  They are added based on what the guest-visible values are with "host"
  model on available hardware.

Benefits of this design:
	- General benefits that come with properties and named CPU models,
	  like cross-host live migration, management-stack control over
	  feature exposure, etc.
	- Forward compatibility: when a new ID register or field is
	  introduced, CPU models need not change; during realization they
	  will be populated with the default values. Only ID register/field
	  information needs to be added to the field table.
	- As CPU models are hierarchical, defining a new model is much easier.
	- The property names and values are self-documenting.

NOTE: ~2200 of the ~3300 added lines are declarative (field table,
model definitions, properties, etc.)

Tested with KVM on an NVIDIA Grace host.

Relationship with existing code base:
 - It does not change any TCG-based code paths.
 - For KVM host passthrough it just adds property support.
 - Does not change any existing properties or other code paths.
 - Can layer on top of the SYSREG_ property series [1].

Planned Follow-ups:
    - Composite properties with handling of sve, pauth for named models.
    - CLIDR_EL1 and CCSIDR_EL1 handling.
	- Safe-value based validation logic.
	- QMP commands like query-cpu-model-expansion are not hooked yet.
	  Blockers and supported values (calculated using safe-value tags
	  and runtime KVM writable masks) will be reported through them.
	  E.g. libvirt could report:
	    <property name='feat_AES' type='string' value='pmull'
	              supports='off,aes,pmull'/>
	  and:
	    <cpu type='kvm' name='nvidia-grace-v1'
			typename='arm-nvidia-grace-v1-arm-cpu' usable='no'>
	      <blocker name='feat_AES'/>
	    </cpu>

	- DCZID_EL0 handling.

Out of Scope:
	- Inter-feature dependencies like FP <--> AdvSIMD, SM3 <--> SM4, etc.

Appendix: KVM Non-writable fields (kernel 6.18):

These fields pass the host value through to the guest unmodified on
6.18; trying to override them get a warning from kvm_arm_writeback_idregs()
and the slot retains the host value:

   #   Field                       #   Field
  ---  -----------------------    ---  -----------------------
   1   ID_AA64PFR0.FP              10  ID_AA64MMFR2.NV
   2   ID_AA64PFR0.AdvSIMD         11  ID_AA64MMFR2.CCIDX
   3   ID_AA64MMFR0.ASIDBITS       12  ID_AA64MMFR4.E2H0
   4   ID_AA64MMFR1.XNX            13  ID_AA64DFR0.CTX_CMPs
   5   ID_AA64MMFR1.VH             14  ID_AA64DFR0.BRPs
   6   ID_AA64MMFR1.VMIDBits       15  CTR_EL0.CWG
   7   ID_AA64MMFR2.EVT            16  CTR_EL0.ERG
   8   ID_AA64MMFR2.FWB            17  DCZID_EL0.*
   9   ID_AA64MMFR2.IDS

This list shifts with the kernel version. The runtime probe via
KVM_ARM_GET_REG_WRITABLE_MASKS is authoritative.

Warm Regards,
 Shaju, Khushit

Khushit Shah (1):
  target/arm/kvm: enable writable implementation ID registers

Shaju Abraham (12):
  target/arm: named_cpu_model: define containers for ID registers and
    fields
  target/arm: named_cpu_model: Add ID Register Fields
  target/arm: named_cpu_model: initialise additional sysregs
  target/arm: named_cpu_model: generate tables for Arm64 ID registers
    and fields
  target/arm: named_cpu_model: replace FIELD macro with IDREG_FIELD
  target/arm: named_cpu_model: data-structures required for the ARM
    property layer.
  target/arm: named_cpu_model: define ARM properties
  target/arm: named_cpu_model: generate arm_cpu_props[] table
  target/arm: named_cpu_model: Add ID register field helper functions
  target/arm: named_cpu_model: Register Arm64 properties for host model
  target/arm: named_cpu_model: introduce named CPU models for selected
    CPUs
  target/arm: named_cpu_model: writeback modified ID registers to KVM

 hw/arm/virt.c                   |    8 +
 target/arm/arm-cpu-frac.inc.h   |   34 +
 target/arm/arm-cpu-models.c     |  214 ++++
 target/arm/arm-cpu-models.h     |   43 +
 target/arm/arm-cpu-props.c      |  259 +++++
 target/arm/arm-cpu-props.h      |   36 +
 target/arm/arm-cpu-props.inc.h  |  180 ++++
 target/arm/arm-v8_4-a-v1.inc.h  |   22 +
 target/arm/arm-v9_0-a-v1.inc.h  |   28 +
 target/arm/cpu-features.h       |  232 +----
 target/arm/cpu-idregs.c         |  232 +++++
 target/arm/cpu-idregs.h         |  132 +++
 target/arm/cpu-idregs.h.inc     | 1724 +++++++++++++++++++++++++++++++
 target/arm/cpu-sysregs.h.inc    |    5 +
 target/arm/cpu64.c              |    3 +-
 target/arm/grace-v1.inc.h       |   17 +
 target/arm/graviton3-v1.inc.h   |   16 +
 target/arm/kvm-base-v1.inc.h    |   13 +
 target/arm/kvm.c                |  167 ++-
 target/arm/meson.build          |    7 +-
 target/arm/neoverse-v1-v1.inc.h |   64 ++
 target/arm/neoverse-v2-v1.inc.h |   64 ++
 target/arm/trace-events         |    1 +
 23 files changed, 3284 insertions(+), 217 deletions(-)
 create mode 100644 target/arm/arm-cpu-frac.inc.h
 create mode 100644 target/arm/arm-cpu-models.c
 create mode 100644 target/arm/arm-cpu-models.h
 create mode 100644 target/arm/arm-cpu-props.c
 create mode 100644 target/arm/arm-cpu-props.h
 create mode 100644 target/arm/arm-cpu-props.inc.h
 create mode 100644 target/arm/arm-v8_4-a-v1.inc.h
 create mode 100644 target/arm/arm-v9_0-a-v1.inc.h
 create mode 100644 target/arm/cpu-idregs.c
 create mode 100644 target/arm/cpu-idregs.h
 create mode 100644 target/arm/cpu-idregs.h.inc
 create mode 100644 target/arm/grace-v1.inc.h
 create mode 100644 target/arm/graviton3-v1.inc.h
 create mode 100644 target/arm/kvm-base-v1.inc.h
 create mode 100644 target/arm/neoverse-v1-v1.inc.h
 create mode 100644 target/arm/neoverse-v2-v1.inc.h

--
2.52.0

