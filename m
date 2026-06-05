Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A173DCDBC
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649059; cv=fail; b=VvtyBgUN7JLowjmkTBPEMD6gBm6jP7Yx7egBlYbcAN3kL/qhxds7V5RXoq1HKj7E//0R1mxAcUHFl3hr8TOf7A9+6JTSDxiUjIWRQbu3fiFw6zW+oBMqdzjJ4Gq7qkPJD3/LsKY7+5ciwoFFu0O/c/r7Dm9e3PLrjhD/z9FeeRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649059; c=relaxed/simple;
	bh=XplFLQPebfV4jaAf08BETiJ0pC07qFNE+NilDkmqpt4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=psLBtZP2Gm/rkiNYV7d+pkkIgC/pl1BhQQ/ph59urXHEjRjOx8iPhe1nboIBtcVEzvfuhbwY0iSdF1CVAR7TolKUyf74B4m3ZskCU2q9YqVYfYwB4D4ZL23uRGkKsFuid1ht0yI472EvGkqyqY2uM8h7p9bZBozhYrPKy6TpsVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=q2mf6hIs; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=npb8t4Om; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="q2mf6hIs";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="npb8t4Om"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLJ854749;
	Fri, 5 Jun 2026 01:43:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=wuDOgc0QT6/jL
	M9A9CpWxid+vxM8EqVQnij8jS3RFF8=; b=q2mf6hIscjaCf+mvRvP93ZfcVOc0y
	aO/km6+ScvC6c8Tx9KwXxyDK3DD7Z/FTjHWptFqJBRh7tql2g1crcFmvE5qrBgkp
	VuiprHvqGJnvZdCnpd24rImzpU/OtuYVOj6RIXBM6HxwxLE/4M5bWxBdEvIFIrA5
	gt95pQ0DF7sZAqMP02WMIzTNkE9YgtWF1YTb6sbOkFuuI2ZeOv7MlBHZD/ri2taN
	1hxmQnPKGv/PsG05My5kXAwima1I71gTmBRkPRJe9fuHT4e8NwaoAT/dGYehKI8q
	WrdjmSMie1knPpQYt4yXc7z35UA0xKEKijqk4AukFRgd/yNTbUamu4H/w==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bez2UvoR4N4Dqz/aRqZGdfzoTEb6uqB1r+gZtDT2ZRfF1qwwUE694jpEbstMA0lEZLCPrtf6ARBw+Ejw/2nRWtDFN9GqRCOhEYTkl3VpDqzeyGlKwaUzv4TttHTyd/PtjQFEz1a1Cr9fADjoEMlvUEUVM3kAdklvC/c7UKAj0jr42eUaJuiBTY/2Y4p7EpBjwx/x0R9rVCjlh6JOb7S33yIdCkkDEEp+eNVzrLfiQmKOM4Jsn7Aj5JdmFLUAScm8yaZV/lZllvzPwKdwhbJIYlhiaXP/opa/rIDsFcEuZ7Y7oSnI79cytWHJYn8sgs6l7VUE6ctv6Cm5lVV2RC9QgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuDOgc0QT6/jLM9A9CpWxid+vxM8EqVQnij8jS3RFF8=;
 b=DDLOpaMpdCwn/ozZc73eeFMIC/xk6n3Nb76wdS3NI0Y/PpLiD76eYiwWkRx1qla4EuEj2a9Fu9jTkiKanyLPm0zMcKP6HUpmK6m1vUzKRFUind3bhjXdf/7wsBjOV+/za8857ZC4Fu7MbETUag6nZ9XM+B+UyHz2y1oRAC0ioj2xLxCIA9qukstmzWaQ7ytYUmrJZlOERGW7tseCpLtS/66GSRZgsGyW9CgbTSfDBL0/tvkICVlhSFNOJPoB+gg2/J8mfuBTi8+Nle9hrtA42Xcv6i0YzY7JLt785aVJB/0qu6ba6/00CXnC7pYYCNDBU4nDmRjxHnERsIXL0WQVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuDOgc0QT6/jLM9A9CpWxid+vxM8EqVQnij8jS3RFF8=;
 b=npb8t4Omp8+UvdkXdnY+EnmczMzvOt8msn70Ss7FykZ8YD7BiJm+FJxy/xsjyFdcTVidlSXlXtJV/QPE00hiQ/ExNIHbAnwDDetrCMaDzBIzxQQR/kZHNEHDn38lMj1XGoeO5SJmd2sVRjRBP3ftql//0tWsOMASDT7k2B2jcbZap4EfDDOodDaExJ5Sa8E2Fn+eMrkWWmk3kZoLwtyOfLRLEIeZFShFmgOxLImt60FZ/Bf9tsZ7gKuAl3jcdkuAKqok9wUQsQ9DnixKhIqLGcQ8Cd2Eh6mj9ldX74fNYussPcI6r7blxTZJR9/retSC/ne5nbc34vBkFNurHqGZIw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:08 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:08 +0000
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
Subject: [RFC PATCH v2 00/29] target/arm: Named CPU models for Arm64 on KVM
Date: Fri,  5 Jun 2026 08:33:29 +0000
Message-ID: <20260605083358.1320563-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
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
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|CO6PR02MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: c82dfbf9-171a-4571-6513-08dec2de77bf
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799007|6133799003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZcqkAW5+eBkReW8RVfuqh18qHL01MTuBg6/VLxzZqHOd9NB95DPb1aeLtWP3qQLLI3hoxZXo0hSKrBKtcWVZVPfJfQUKWOVnRweyxSvsTaiwopNoxJuRDdQ/WablXSCwo87NMR+AMhCXcpnJCTvYCDVnJVKlvwunlGXX9tHRrZEIOaMZqlZYZfjX/U4ZuYHFd6BD0xBV34+f3XWY4o2cvIdaMz0HMVwuXyzYirS/pfQzV/H6i+Xe3NWl1xdAgkif/bylmqaJLvbo5QbImPnt76QevQPhq14wxqdGpMc9MZ+kFLmSUrar9nvwzFE7QUwJ6sLCfmpHY7A+bUDkY35Z3XpnuhKcqm1Z1P53Hj71NvZ1lYrYZRuW4CWGGbOZJNy9PhwehxE9emDgpZm2KGtDYcoZDyZFmzoSmaBguc4MI+kjiF3CbOdlT39f9OhR5t8qhtg2qm0F8aiYIRsTNGKzQ6eMSqz8q3Y/DswDO8QT7Li5qx0D3yOahudWfJoxynA867s9N/jbsSxGFXgwQBeZGJVKOqQGNMyhBYTT5253tKlVuTopcutFY0zYodl3nAKooimKIt3bnpQG8xVNfACxA1IUXI3/X90k0NmEYXDbTXIE6AbI89taI8k3pPvK0hKZ2CbMUl6+kkBJbXbRLeHl/uCeCVj8TxVHcXAsNPofw8UZmaKNZGdH6EXOlH6BNA9oCD8dMnyvnGDTUDoGHEDdkg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799007)(6133799003)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BMLR4quz0kihlBfK9u98/qyoExYHkdA5yYogKhXkv8Zq4OgRT0lX7d0Cyq2w?=
 =?us-ascii?Q?lTGKRxywokAlcty2Gp050FPKh9Ca4M3QlDFxC+GDG1PA+9k8QYoc1JKO6NTd?=
 =?us-ascii?Q?Gm8HYnfDLJ7RiElvdUWHorfonZATdZ3Qp+t6SF4200ydPX3COnrfaRiBZdE8?=
 =?us-ascii?Q?ffdxvgmzUecBIaO0IvD8GHT1stc5rKfPly7XZFwZLaBHfvJ4pGjRhguDWZU/?=
 =?us-ascii?Q?j2qtqDjkZ/kaHJ9g6QQ9NLmG6x754qLky8gp9QhwI5la44p6AtViirY20Qqg?=
 =?us-ascii?Q?EvO6XRV1gFYuFp/tBflBe0v2Rv6Pdkame7dv1Agw15Lhr7RXXpakUMAWGdXN?=
 =?us-ascii?Q?IYpn4Ru4woWjvs8Edm+sfpYwhfGndhWxoLorqZ2Y27KbQcwC+hJERBIRTFXX?=
 =?us-ascii?Q?Vtn8RLI/OUeK/8N+aasl0mMjxolvE0Y3qFEV5b8j2KtRIhfGIc/HsUcsCQZf?=
 =?us-ascii?Q?oSiTR5ir4ikNI+thxeZULzPCW8qYs5aY4pkU1mxnG24Wz8Vm80MiUxpiqMQC?=
 =?us-ascii?Q?PNZYmqaLNN0uryjB2CrOuse9v8iJNSKi/zrOb3bRzLsnazn8U5ZbwQt47Ilf?=
 =?us-ascii?Q?Fej5uxM867a1guzuGMYxeVbzuuQKE0d7yYcK7Lc3K1Mf/MXfFBs74rhKrP8I?=
 =?us-ascii?Q?SViJAWdM3zT1CyDvHp5keYw1vUa5pS329EC2aMyuDJjVk5kY/ZFCUWSeM264?=
 =?us-ascii?Q?4EYCwKlBkWXMQeAvglLhpUG2aH1iluTLpCxh68Zt/zitPcKJ0mjt4SJHWGLK?=
 =?us-ascii?Q?E4+4qtRzdPv/XJbjAbms4da6V9K6AK7w21/r3DVuWSyk70UGtwqLEnd7H4NM?=
 =?us-ascii?Q?zsJ++FKFUu3XCWhrulkgbfwbKBHkIl+Z1R7qmA7XmHgmpFrzPVGSnBHo5QEK?=
 =?us-ascii?Q?Wj5ygLJVPgV8b2RWeNl5aXpijlx0bPecXfji8nayKmLa2ZX8197MAWPnXLxf?=
 =?us-ascii?Q?0+yoOP9gDPiQddZZ46VJ+A0PhrkHwvkrf4g1IKRuAdZleCooPlUjTcSnP2Fu?=
 =?us-ascii?Q?flRhrtchhQ9pry2ZF1hiKMF226Ph9pKAyx4fPqq2RoqPPfFCV1kX1vjv/oNV?=
 =?us-ascii?Q?Va8E03qgcwLNdBS+fkwYtmbpcqMNXIt0/GKb3QkRGUXWZAZEmwkfpPigYbsC?=
 =?us-ascii?Q?dSQJa00wFhkm1xvkyP5z4uGckPnvvZILeOBUpV7zZFVBBenbVCwamnPAFeBi?=
 =?us-ascii?Q?0EI4NyNreCcRBI7zFsHykW/6zevJEs+CufZHmO6H1d7+BmPjuqy5F4LMraOX?=
 =?us-ascii?Q?Z70BHliRtKwtCUcdzz+/LNCgC9IErW4ZkJJM4scVs4EY6SE9VX0SBLtboWdI?=
 =?us-ascii?Q?ypNqaLNpfVY7pYbaq0dSo3W3YNHL1hkNxZMTMH+IzHGXYrWYkGwLmBnzn3Td?=
 =?us-ascii?Q?wkTVZ2tJVek13xhHjTO04uKd8wUjehJdl0vTWhsTLeIF0Zydm4ehQa4VqJd2?=
 =?us-ascii?Q?eoS7saGwkfaLz51yqh6Gn03HNYGsz7gTt3Z5S3UTJNl6ZCKJ7ChhW7SJSOM9?=
 =?us-ascii?Q?2avi8lvUkwfPz1bnHi3hwSJW3jM8r1oho6VmsPbV9V8UrbyNXawXU2r+lmdd?=
 =?us-ascii?Q?y496r9dhQm2wl3JHUicsbTomawLbW/NyCqFvFxOdoqxKq4UvRwAYs+ha6EiD?=
 =?us-ascii?Q?Q2l0F+9m7Eo8ayMmSg/KlgreyJGpZg/jvJPhx/I8uhtnixF0nFpTfNrxXXU2?=
 =?us-ascii?Q?HLimP1w9DuZGncI2MdVvUxF1fmAL7I6tnv6XGcriNEs24uCI6RB7QIA5c1hn?=
 =?us-ascii?Q?pSbHGhKuZosgGfK5SXOdt+MDUzPoNzA=3D?=
X-Exchange-RoutingPolicyChecked:
	alZDAS+4O1pij99BuO3xRk/8UCo8ELUtM5EbLUp1rrSjWl96zj64Q4eyAdR/v5HP1E4QBwoCw/pK707N+cpnRAeg/Seg6l0MTCgjirtGa60BUSh/1vxSL0KOlsGaQ4Rw/3FibXKm9Ft6Ofg5eWSzQuBcN3nm6aic3Ks0DwQFbEIzKasplZM3cGqQG/sZmLsYeZMGxWWXSn+mnX+pHExKl5/FGk8eseJ6igILasdn/xDiDUXi/jesY8fawa9E2cEEx9xEcJNpKiQWAqHrpb3Ign4XJOALL/l/EOZMQXGFrlG47puc6Z63dkeb8PA7mlbpc/rgITCu5QntedyYSd17kQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c82dfbf9-171a-4571-6513-08dec2de77bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:08.4637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZD1TNFTo1nbiBJodvQN5edSMj7qPgb9Zsb+j2iTSQ2sHgIETSIidB+SoGeQVcwD4j2S0rbBUdL+UVf0mWb+e2ADXHGLt1SouWUqucpDPfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: 4mn5cf1TMDBLMlGVLJFXb4NYxh2qKPKg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX7AI9XD9zkBMz
 TZIzxDP7RKd4rg9d7TVjFb0ocRloIi5yBg5i79SSaWmW6K+CjLlhsTmpujO31JP3SdmgcB4r7Ym
 sP54ZCYkc66jR/1o1p3QI3HJFDoR3IByJQ3w66+ey6tzYAVTrqETHVRUAuMRU6SdMQJFjjKOIWQ
 sLTz0Fji2RQ6BdeVcE0aclrn6yRAGE1uFo7W5kuNEvab/acBF+4S3dUYoBsXvjsk+JQDyY+nF8F
 lKKmpR2DkhhVHOs7Cf4ocYTebfXkaiRSPEHbvGhdUPX67mSGN3wely73mdNpnLRT5acQ309UlTB
 vGN12rKHn+HMg3lCpTji9q34RB79oV/j+6jdvWmYEzvV78sk6x6a1vVw74QYSVqVREUmXSbbZ/h
 UAG5IMfxf+3FxAkH2RwbO0iLbdAf+ggwp9Ci/vim/AJxlzySe+BDYknOy0vQpGdq5AmFenmg+FI
 TvRR3jDdx8KL+/mQj4Q==
X-Proofpoint-GUID: 4mn5cf1TMDBLMlGVLJFXb4NYxh2qKPKg
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c1e cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=fLdaxw7juexdDmRFceMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Hi All,

This is the v2 RFC of the Named CPU models support for Arm64 in QEMU.
v2 implements all of Planned items that were mentioned in v1.
v1 link: https://lore.kernel.org/qemu-arm/20260513163356.3033159-1-shaju.abraham@nutanix.com/

Background:
=============================================================
Currently QEMU only support -cpu host/max for KVM on Arm64. This disables
live migration of VMs between hosts that differ in CPU features.

This RFC proposes hierarchical named models for Arm64 under KVM, this
provides strict contract of CPU features that will be exposed to the guest
for a given named model. Models can be customized further with feature
properties (like feat_AES=off, pauth=on, sve=off, etc...). 

The design has three layers: an ARM ID-register field table (single
source of truth for fields, safe-rules, defaults, arch-defined values); a
property layer on top (single-field, fractional, and composite properties);
and a hierarchical named-model layer that picks values for those properties
with parent-chain inheritance.

The series also implements QMP commands that lets the management layer query
which models a host can run, what each model resolves to, and which feature
values the host supports.

Relationship with "customizable host model" series:
============================================================
This RFC overlaps with customizable host model series [1]. The two series
solve different parts of the same problem: [1] provides the lower layer
(per-field SYSREG_<REG>_<FIELD> u64 properties on -cpu host,
writable-mask probing, ID-register writeback).

This series adds the layers above that, like:
hierarchical named CPU models, default-from-zero baselines, fractional and
composite properties for named models (sve, pauth, expose-cache),
property/value names, and QMP introspection (blockers via safe-rule
validation, supported values, new query-arm-cpu-props-info). This series
also fixes the host-supports-Nested-Virtualziation-while-qemu-booted-without-it
writeback case [2] that surfaces once [1]'s writeback lands.

Long term plan is to rebase this series on top of [1]. Few difficulties
in that will be augmenting the ID regs fields table with safe rules and
default values, which Eric correctly mentioned in [1] that it cannot
be inferred from Registers.json.

For property names and values we have no strong preference,
<SYSREG>_<REG>_<FIELD> with uint64 values or "feat_*" properties with
string values (SYSREG_ID_AA64ISAR0_AES=2/feat_AES="pmull").

[1]: https://lore.kernel.org/qemu-arm/20260519132905.145643-1-eric.auger@redhat.com/
[2]: See patch 29 of this series.

TL;DR examples:
  # Boot with Grace
  qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...

  # Grace with a feature disabled
  qemu-system-aarch64 -cpu grace-v1,feat_SHA1=off ...

  # Host passthrough with individual feature control
  qemu-system-aarch64 -cpu host,feat_AES=aes ...

  # named CPU model with composite properties
  qemu-system-aarch64 -cpu grace-v1,pauth=off,sve=on ...

  # QMP -cpu host query-cpu-model-expansion:
        "model": {
            "name": "host",
            "props": {
                "cpu_partnum": 3407,
                "feat_SM4": "on",
                "feat_SM3": "on",
                ....
            }
        }

    # QMP -cpu graviton3-v1 query-cpu-model-expansion:
        "model": {
            "name": "graviton3-v1",
            "props": {
                "cpu_partnum": 3392,
                "feat_SM4": "on",
                "feat_SM3": "on",
                "feat_RNDR": "on",
                ....
            }
        }

    # QMP query-cpu-definitions (on Grace host) (blockers for graviton3-v1):
        {
            "name": "grace-v1",
            "typename": "grace-v1-arm-cpu",
            "static": false,
            "deprecated": false
        },
        {
            "name": "graviton3-v1",
            "typename": "graviton3-v1-arm-cpu",
            "unavailable-features": [
                "hw_prop_TGRAN4_2",
                "hw_prop_TGRAN64_2",
                "hw_prop_TGRAN16_2",
                "hw_prop_APA",
                "feat_RNDR"
            ],
            "static": false,
            "deprecated": false
        },
        ....

    # new QMP query-arm-cpu-props-info (on Grace host):
        {
            "name": "feat_SHA1",
            "type": "boolean",
            "supported-values": [
                "on",
                "off"
            ]
        },
        {
            "name": "feat_AES",
            "type": "string",
            "supported-values": [
                "off",
                "aes",
                "pmull"
            ]
        },
        ....

Changes since v1:
  - Added `query-cpu-definitions` and `query-cpu-model-expansion` QMP
    support for named models and accompanying properties.
  - Introduced `query-arm-cpu-props-info` QMP command that returns
    list of all newly supported properties for -cpu host, and its supported
    values.
  - Add composite properties for named models which acts as master "on"/"off"
    switches for features that compose of broader range of ID registers
    fields like pauth and sve.
  - Added `expose-cache` composite with other cache related properties to
    allow named models to expose cache information to the guest.
  - Cache the host isar view with and without EL2 support, and make
    -cpu host with writeback work on host kernel that supports
    virtualization.
  - Validate the cpu->isar.idregs before writing back to KVM to catch early
    errors.
  - Properties and models are now defined in file rather than using .h.inc 
    files.

Tested on NVIDIA Grace and AWS Graviton3 hosts (6.18); booted grace-v1,
graviton3-v1, neoverse-v2-v1, neoverse-v1-v1, and -cpu host with per-feature
overrides.

Plans for v3:
  - Some documentation and unit tests.
  - More properties based on what more the latest kernel supports.
  - pmu composite property.
  - Trying to rebase on top of [1].
  - Splitting this huge series into 3-4 sub series.

Warm Regards,
Khushit, Shaju

Khushit Shah (20):
  target/arm: Introduce data-structures for the ARM property layer
  target/arm: Add all ARM64 properties to host model
  target/arm: Add Nvidia Grace named model
  target/arm/kvm: enable writable implementation ID registers
  target/aarm: Validate cpu->isar.idregs[] before writeback
  target/arm/kvm: handle DCZID_EL0 specially
  target/arm: skip GIC, COPDBG and PMU fields during KVM writeback
  target/arm: Add composite property type to model definitions
  target/arm: define pauth composite property
  target/arm: define sve composite property
  target/arm: Introduce stub files required for qmp support
  target/arm/qmp: add named models and properties to cpu-model-expansion
  target/arm/kvm: introduce kvm_arm_get_host_isar helper
  target/arm/qmp: add query-arm-cpu-props-info
  target/arm: Report "off" for ID fields gated by vCPU init flags
  target/arm/qmp: hook blockers in query-cpu-definitions
  target/arm: Support exposing cache information for named cpu models
  target/arm: Provide default cache hierarchy
  target/arm: supported-values and blockers for CCSIDR cache properties
  target/arm/kvm: fix host model writeback when kernel supports EL2

Shaju Abraham (9):
  target/arm: named_cpu_model: define containers for ID registers and
    fields
  target/arm: Add ID Register field descriptions in cpu-idregs.h.inc
  target/arm: Add MIDR, REVIDR, AIDR and extra ID regs to cpu-sysregs
  target/arm: Generate ARM64 ID registers and field tables
  target/arm: Replace FIELD() macros with IDREG_FIELD expansion
  target/arm: Define ARM properties
  target/arm: Add ID register field helper functions
  target/arm: Add named cpu model infra + graviton3 named model
  target/arm/kvm: Writeback modified ID registers to KVM

 hw/arm/virt.c                    |   28 +-
 qapi/misc-arm.json               |   41 +
 stubs/qmp-arm-gic.c              |    6 +
 target/arm/arm-cpu-models-stub.c |   18 +
 target/arm/arm-cpu-models.c      |  620 ++++++++++
 target/arm/arm-cpu-models.h      |   49 +
 target/arm/arm-cpu-props-stub.c  |   36 +
 target/arm/arm-cpu-props.c       | 1212 +++++++++++++++++++
 target/arm/arm-cpu-props.h       |   70 ++
 target/arm/arm-qmp-cmds.c        |  128 +-
 target/arm/cpu-features.h        |  246 +---
 target/arm/cpu-idregs.c          |  508 ++++++++
 target/arm/cpu-idregs.h          |  119 ++
 target/arm/cpu-idregs.h.inc      | 1898 ++++++++++++++++++++++++++++++
 target/arm/cpu-sysregs.h.inc     |    5 +
 target/arm/cpu.h                 |    3 +
 target/arm/cpu64.c               |   31 +-
 target/arm/kvm-stub.c            |    7 +-
 target/arm/kvm.c                 |  356 +++++-
 target/arm/kvm_arm.h             |    7 +-
 target/arm/meson.build           |   11 +-
 target/arm/trace-events          |    1 +
 22 files changed, 5148 insertions(+), 252 deletions(-)
 create mode 100644 target/arm/arm-cpu-models-stub.c
 create mode 100644 target/arm/arm-cpu-models.c
 create mode 100644 target/arm/arm-cpu-models.h
 create mode 100644 target/arm/arm-cpu-props-stub.c
 create mode 100644 target/arm/arm-cpu-props.c
 create mode 100644 target/arm/arm-cpu-props.h
 create mode 100644 target/arm/cpu-idregs.c
 create mode 100644 target/arm/cpu-idregs.h
 create mode 100644 target/arm/cpu-idregs.h.inc

-- 
2.52.0

