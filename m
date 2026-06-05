Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6680447A0AE
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649045; cv=fail; b=J2/z6D/3LtU6/6qcA+AfotZjp3gezDsROX4phDchW9g3aBC2aOYlZhJ9J+191ENObbpvZppoLKIzY0y5eT1SlxICvOjnETzmrVWUhnpyPn7lE1FCJtqBrjubpg9qJI9THGh2S1tO6SxTAuVAd7FMFcVmX/ljKHGHqIir1mb2VQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649045; c=relaxed/simple;
	bh=c7U+hP9XPZukMeaxCIHWXvPaaeFmGEV69qEBhXN1PYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bWXB3AslXZN4eEGHJvpDL8I6U5n320eU19BX0jMCS1RWlZc/G9cz4oGOjm/i5Tb0WWx7+ayO33EtztHfp4OqEYxK7U2YEDdOiRJ6K72pKsACdkpOkhKvG+Nn6/hdBdaU0HQt24bNCgxujiTOjHRwng4FmsFTOIBg9itLVx+ZbIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GQ6IriM9; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kx3Eem3S; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GQ6IriM9";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kx3Eem3S"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUT1185382;
	Fri, 5 Jun 2026 01:43:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=IJvglxOZOgMA2qda+fgowy9ILLCZG8PXnVHeDhPbg
	m4=; b=GQ6IriM9Q8naasoWvury7V3L3GaP2/i+6+PDreULQD6KPe3YSSBYrxqzE
	ATEOaHbdpOKZ+YkqkeKj/u+CAV7Z8snvdZNvVPIBLhr2d2KrTtmNSZDf+BO0fg7Y
	ibl7gTonq0tJBTt9pkxXu1dv0o1uqGqrBrFDtKEmX6JDmPnoXqnXpmcS4DcWSmhF
	VcYFApGwnLbPa3Vao6YnujLEBIrLMqNEfotV57yptMTim8TPC0elfd8XPrK/Bpsg
	ABkgNd9L4135CecU8MDgKDT2vWsZSRRNgzUYLSt92G8/7WPn93/QyNZx7fsozM4V
	pJy2Hbkp4ji2OguvAlnhqzLHSVvOw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-12
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8D3JfiuD3H+5oWQXY7TVwvnHeZFIILKyxPOUApWNtiwkUrnSwr13C8LziI9ID0Fvvec34foFtbCrjIqQYC0Zx584GuRnfIrrodvaTj5LhBTiOzbkLKwDeB6WWHXKHKrV2PHEuv81v+MTx/hkKJ21ytOr7Ae4rRB/XmBZEmy4sfeX7AOjwx0g+Sf99wpqxz/tVbn3j8KMRt1uEerNfd0JRPuRLcssVJXIcgXw7590/hRmeWdZ2b2wv20GGq06MJnKkQe+OEYmCtiKHnQrGpTJt34mcCM9p/45olbo9jB7BvJnlQlTiN650yhHwY9+khr9+9i7Zz17d26ZtZxEy/pnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJvglxOZOgMA2qda+fgowy9ILLCZG8PXnVHeDhPbgm4=;
 b=DZYl3pyU6FmIgnFjCW0azXieEKPXZJQGWdJkd1+gOwev3fL72uWurg8HLxfy2aKkc7475PgmZaEDfrGrsvwWWrE0m+09011UE0HmiZHxBZw9D6W5swMfgPfhCT5UZVY0Zs5bMp0rjYsbQ3gdmTziD6fwFTtLXooBrOzLACr74TXisV3xgkFJdu4X6nui82mrpbg7SCpTLTyK0XAsoylW4IXBKs7HKcw23NP8P8erelQgPiBOri4QAuKy22cDGY951Ek47kU3owqYAGyxC542gFPkWlfhg8K7Y50ylhxT3MXCUTD4I72vUUgZsPwm3I/Bsm3BsFhBlICkgf0gB9Wc+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJvglxOZOgMA2qda+fgowy9ILLCZG8PXnVHeDhPbgm4=;
 b=kx3Eem3Se7tCQMt4Awj9nwyTI+sUB3lhf/NDFkoZB+uhCnx1d6gmzQTJzvrkoeI5GBTWGHcE5Y277OZUT1I99WU1ub9j+N6rId/QPx5pdQFO90zB/Od3sXZ2cZOVi1WoFJsyAJzKj5aQWmtDddrzVOZqBY11/+c3ZU8gS6bVTAf+vQWcYm4unV7y3PD+2taqdYxQirVc+ZoN/BGvOCRiFnG2b9q72TylQFXgtG6uLNSysono5c/Xs4bAFIH+U9SB8jOvNT0OYoYfXO44XUcP7Gi93SKCAt5e566zKtQScgPD897S/VN6fOIl77McBn+gHtpUD/k72cVeDlH1yW8V5A==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:23 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:23 +0000
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
Subject: [RFC PATCH v2 29/29] target/arm/kvm: fix host model writeback when kernel supports EL2
Date: Fri,  5 Jun 2026 08:33:58 +0000
Message-ID: <20260605083358.1320563-30-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 12848bdb-1218-4291-8c82-08dec2de7ee6
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|6133799003|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3o1nvhXxynvumt81CAgneyVKwl/8XkzFjGsJsPsfrFk1MpCutUgwOzKSRFD2kHNx9B+DPMnYbc0OAGcECkxsYOCcv7coKJHNYGKo6vUDnMN5YAZSWF9akaWfWGifJ/1hS9kqzys37V0Ri3l4tUAN6KdWqPM+DOLxfPOxrXwK0Xk/UPi9J72AS43LXwpPcOnNJmsw4zTZmc/9RhWD7tC7agfn1M+6+MeYuGzKIhsR3a/FPbXezlgrG1JfSy+yLtUQM+TtWbOJNNlyXGAcf6ngNLd/V3c6KssRIJpvSeMhL2od4712QufPZ8bz/6Eg82qT6Yw5fE9/CerkosyXD3Kz/ZoTQOBdUfDvxUlUew8fl8A1H5ko9fsDi1bE7B7mJ+e01QmlM5YPO1hjI5ltdOQHcqqXaNljsqY6mjabst9k2PBsMmwxX5CUQ6NZwIT1PkK4HEnvi9vRCTHU/uZQWk+jyeu6eCtFGc0ppi8ApBD9NKUDW8TKONQJv1iEhE4JsN57RXeVjfFxB7NaiVYgfFk1P4Q/MXSDJybxLJjtPufpmrqtAJ69AxCNs0os6C4fGaE9Y0WenZgofJ1ierYsh0lX7rkqivZ5KucouQP6MdGd3Hv3YvIe1mwTue5bY7uzlsu9MsOS1q4GD9L4ItHDpi5GyKiuFcOeqADTZdXcRcpo5/Wgdwg2bPMGaRgSQfwxVBRs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(6133799003)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jFGrbi+ypHeSd7B2fxqOIy1l6b38BOUIBvADBBSmqFDVphlNdFceHqXOfvJB?=
 =?us-ascii?Q?LHpJKNulW2ncNExxnC1L7boliBrWcaqKSjFbhuuEoqIy5OCGtqSD0lLLsr7N?=
 =?us-ascii?Q?yW3H4QY8c5domVqRUj68+Pz9VVRqBjjxikb1PkG3aLp0+yVJegs13O/+rc4r?=
 =?us-ascii?Q?Hf4wY0mMhyaysFdyTfVHGu/zyqm4cRrgQN2X0pDW2StE0UFmTKxFlEAjw92p?=
 =?us-ascii?Q?dgCeZtUtrw1TSnJplbsGRxaXm04diIH6n/aA0nAsnaMy1CaXjWc1eO+pz9f+?=
 =?us-ascii?Q?Hbm4857k18nhoc8j6IIcvoDkHo+2rGsxOas/z6O/r6rrpqD44x9KcxVPyhaV?=
 =?us-ascii?Q?lKM3K0l/cyeRMFd4Yiz7H2hL+X0b/mf1iBJbC/7+Xnjat4eU4jJQOgFqW1Ea?=
 =?us-ascii?Q?uM6Q529jqGphE5K6EnIzgIJ4wqLAAoOt5zlzqERsia0iXjFi1iA7gg+tyMjT?=
 =?us-ascii?Q?zlVUmpf/yIOIddBR6Z/x+a0xpuaRz7Oy7Fr2izRyx/GGD7DIXVY5CcZTBAcP?=
 =?us-ascii?Q?SolkeJf6hP7ELmz5nYrt57whggTuBa4BqZ2mmwu6aOWpn4OWJJFIOaWn396b?=
 =?us-ascii?Q?nBALwfd36cpgE9Pcs6Ntx7LWtjE+08jzongQn9PALsUM6ghFXSC9P0sZ5xSq?=
 =?us-ascii?Q?YnjgTKaAH2vCv0Yj4GOyzLj6OKiqFvt/+IeLqvsxDIOdgx3cYRwEgmfgK0i/?=
 =?us-ascii?Q?2eYsNerATMwz0d25JHXB/3sbhkwzJCMV27QqkCxO8kfvFEUPzRi9Dkwc/1kE?=
 =?us-ascii?Q?k5lyY3/AcTETMSPtxpUoLtkV9TwTin9lV/gZmTBBjSNKKipE4Bu80OVFXZ3z?=
 =?us-ascii?Q?9Tcs2GRiQVeQjtPxRwLdAwViTCmIddcifkPFBkbfPsF3g2zc6FAW1xQ3hi5y?=
 =?us-ascii?Q?85PpX+0HZzxU/5UEArLAB4FyIC0Wahp6OeRUwiL6l5SOKwaRneJz0HrxOfr0?=
 =?us-ascii?Q?ovX3fIWXXM6s7CdMYMR3BUzuO9YGGyTqrX1cLuYbO2QOW1Xj4m1BFSyv7Efe?=
 =?us-ascii?Q?hSNHy7cudh6U4Yn7JPK8yXNOi1VPGBDGAHznF18A2j2u8jjo7hkWVGfkPqlt?=
 =?us-ascii?Q?DhtOq47C87VS9/FuJNMZVFMojq9Sc+ZfhuZAbVCvz9TX+s/Dqr57riYysQVG?=
 =?us-ascii?Q?jaSfHGc5whldkLAJR4iHaUH3A3gGUMrnRCnWivkJdlHkrmz/5Y4mUu1IVx33?=
 =?us-ascii?Q?3StOEq2EAPz/pYQ8fVx6Pnjl/6IVXOE0uUGHULpi3bM7+T4Y/oaqfUZ0iQyg?=
 =?us-ascii?Q?Y2VTUx3S5/S0JaueCb3VACb7PNrRVGpaSo+62SeLOjUQ7xif6ZmAAow9AUAD?=
 =?us-ascii?Q?eEVBahmUncKCNqkAo3PCXw4ex2viuqYdF+wImdRdBKiy+mZ+lXmWNxzJdChl?=
 =?us-ascii?Q?1GCKpbYtIWLppueCpyM5eWrUuWNCzGERXFQOJq9fs8YxqCrXmsTnCKti7XhK?=
 =?us-ascii?Q?dHFLjUv+vk2/p8HgvMkNAkmKWw6CADYevC6BIQU2L/V30eyqo1KLEVlNNCl0?=
 =?us-ascii?Q?/sk2ZFJqxYBeaaHZ0CQgf6dilfKpM6V1BZ5yOm/uIQjGFrpffurqAaBAL52J?=
 =?us-ascii?Q?kygcjiWmD7RGFZJ7Np6iou4g2Y/b5C/6ihTEKQIKeDYVcpc9DEXP0xKx2mK+?=
 =?us-ascii?Q?JtxS7SbhAf3pFAfyj01iYA1Uyst64isgFuM8HKVTTesbxFJUDMxuKiutjVts?=
 =?us-ascii?Q?6AI9+t059on9ems9m7dxz6WcKT/qwldo38ELHK7+qZavCkSNfBIywnJ8qa2S?=
 =?us-ascii?Q?YkzSWTe2rWNjPBKtIJcbBo3GIoocQHk=3D?=
X-Exchange-RoutingPolicyChecked:
	poUt8sX97Kh8NlqvufWF/8Y9yZHr+1INB3bEweTIADuEAjJujx3I0xbfpsx/6zmiLHZjypOX+VNmA/dVgUiffy5Wvoq4RzRFRABzVEGzV1Xu0UV+I0afZSlAk3Jjy8e1Oqio25SJmUGDIy0FNRzqEe3Sr88u26224rehrDnmxTRrCotsOf2Bn9oU/bSwJ2DrB2NGcO5P260KAHZ7IzM+o+YVJcHMCv0P8sLlD8To/eOAe8Ayzv0QXOuz5cVbqkVLICEWIofeRxkBb9lKdGNLCaiAjwbWoq3xmbb2e4bcn0ymxR1A3b9q3Uu4kK99HhqNCN3WfbfqoiTlMeGd7U8PIQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12848bdb-1218-4291-8c82-08dec2de7ee6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:20.2510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lP9+32Yf2NXVqJwgHi8XetnVJew3e7WnYPJiJbfVg3k4AcysY7qecEXP2rqtNbtRIuQI+KHkjrARtijSN4CNYHqAFfT0FqA/DWPkTHX4CM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXzpndv/IbCbyA
 qn4aHpZfvP4yZfdlM50Ur+vbjAI2ss/9rffVA+IfSEv5g0Up1hip5iPI6KcZDjqAuYtWjDu5EIa
 o2JpciXT5SabZ77tSWp+z5p7eA8CdpXos7PDnq+CdGO9NLjyHFgItDILSz70nqsyuwaFndf4lYX
 Wz+PI647P+WCiAE2FUwrMDtCByKMu4ghFHso7zbiuOgzp9eXdP0/M5qm0XNHtO/UjcjFqbSd8lz
 pcAiYLx342tvZCFt1jA6wsD/uO4+PNEnlE9ZG4LWa2M6HF69UWmZ7vi1gCRF4QlKSL03wsEbWcp
 wkbUwW9GNxw4wcf2I+AFNyaaycI5J69IMFxTVa8yiASaUBfq6yQlTiRRK2sKA1a++TaXEuyHlIe
 1MUqmUMhFkV7jgX+4SbnRLGzhdIrD+DKqzt1lRTBqozAQb469u860UtvU53xH068Ox+0SY4SDtG
 fHVSOcz01X4Xdm96u8A==
X-Proofpoint-ORIG-GUID: zbliRuSpNeTQVal3zXwBZZ9KogKH7A0q
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c33 cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=15h_muFj-VbmxBcijCsA:9
X-Proofpoint-GUID: zbliRuSpNeTQVal3zXwBZZ9KogKH7A0q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

kvm_arm_get_host_cpu_features() probes the host by spinning up a
scratch vCPU and reading its ID registers. When the host kernel
advertises nested virtualization, the scratch is created with
KVM_ARM_VCPU_HAS_EL2, which makes the kernel run limit_nv_id_reg()
on that vCPU and force several fields (e.g. ID_AA64MMFR4_EL1.NV_frac,
parts of ID_AA64DFR0_EL1) to values that match KVM's nested-virt
capabilities rather than the raw host.

If the actual vCPU is later created without EL2 (e.g. -machine
virt,virtualization=off), the EL2-on values cached above no longer
match what the kernel exposes for the real vCPU and ID-register
writeback fails.

Fix this by caching two host views, one probed with EL2 and one
without, and selecting the appropriate view at every use site.
For -cpu host (and -cpu max) without EL2 we additionally rebase
cpu->isar.idregs[] from the EL2-on view it was initialized with
onto the EL2-off view via kvm_arm_rebase_host_idregs(), so each
field that the user has not explicitly touched picks up the value
that the real vCPU will actually see.

Corner case: the rebase compares the post-init field value against
the EL2-on host value to decide whether the user set it. If the
user directly or indirectly set field X=i and the EL2-on view also
reports feat_X=i but the EL2-off view reports feat_X=j, the rebase
cannot distinguish "user asked for i" from "inherited i from host" and
will overwrite with j. This only affects -cpu host/max without EL2
on NV enabled kernels where the user-requested value happens to match
the EL2-on host view, so we avoid the complexity of user set values
tracking and accept the loss here.

Named models are not affected with the issue as they already start
with default-zeroed view.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models.c | 10 +++-
 target/arm/arm-qmp-cmds.c   |  2 +-
 target/arm/cpu64.c          |  2 +-
 target/arm/kvm-stub.c       |  4 +-
 target/arm/kvm.c            | 98 ++++++++++++++++++++++++++++++-------
 target/arm/kvm_arm.h        |  5 +-
 6 files changed, 96 insertions(+), 25 deletions(-)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index d38293cfb2..0fc30b72ed 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -548,7 +548,12 @@ static void arm_named_cpu_initfn(Object *obj)
         return;
     }
 
-    kvm_arm_set_cpu_features_from_host(cpu);
+    /*
+     * Start with the host view without EL2.
+     * If nested virt is needed user must provide values for all the
+     * blockers.
+     */
+    kvm_arm_set_cpu_features_from_host(cpu, false);
     if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         return;
     }
@@ -574,7 +579,8 @@ void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
         goto out;
     }
 
-    host_isar = kvm_arm_get_host_isar();
+    /* Use the host view without EL2 to calculate blockers. */
+    host_isar = kvm_arm_get_host_isar(false);
 
     if (cpu_isar_feature(aa64_sve, cpu)) {
         arm_cpu_sve_finalize(cpu, &err);
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index e13dfeb357..844bc84720 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -92,7 +92,7 @@ CpuPropInfoList *qmp_query_arm_cpu_props_info(Error **errp)
 
         sv = qlist_new();
         arm_prop_append_supported_values(pdesc,
-                                         kvm_arm_get_host_isar(),
+                                         kvm_arm_get_host_isar(false),
                                          sv);
 
         prop_info->supported_values = QOBJECT(sv);
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 2fa5b4d9da..bad0b1f9f9 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -889,7 +889,7 @@ static void aarch64_host_initfn(Object *obj)
 
 #if defined(CONFIG_KVM)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
-    kvm_arm_set_cpu_features_from_host(cpu);
+    kvm_arm_set_cpu_features_from_host(cpu, true);
     aarch64_add_sve_properties(obj);
     arm_add_cpu_props(obj);
 #elif defined(CONFIG_HVF)
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index dd683beaaf..98f41818ba 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -45,7 +45,7 @@ bool kvm_arm_el2_supported(void)
 /*
  * These functions should never actually be called without KVM support.
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2)
 {
     g_assert_not_reached();
 }
@@ -120,7 +120,7 @@ char *kvm_print_register_name(uint64_t regidx)
     g_assert_not_reached();
 }
 
-const ARMISARegisters *kvm_arm_get_host_isar(void)
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2)
 {
     return NULL;
 }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 984c7fd256..3dbc2b5f1b 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -65,7 +65,7 @@ typedef struct ARMHostCPUFeatures {
     const char *dtb_compatible;
 } ARMHostCPUFeatures;
 
-static ARMHostCPUFeatures arm_host_cpu_features;
+static ARMHostCPUFeatures arm_host_cpu_features[2];
 
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2) [NAME##_IDX] = #NAME,
 const char * const sysreg_names[NUM_ID_IDX] = {
@@ -349,7 +349,7 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
 }
 
-static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf, bool with_el2)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -389,7 +389,7 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
      * Ask for EL2 if supported.
      */
     el2_supported = kvm_arm_el2_supported();
-    if (el2_supported) {
+    if (el2_supported && with_el2) {
         init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
 
@@ -528,7 +528,7 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
             err |= get_host_cpu_reg(fd, ahcf, ID_AA64ZFR0_EL1_IDX);
 
             /* Read the set of supported vector lengths. */
-            arm_host_cpu_features.sve_vq_supported = kvm_arm_sve_get_vls(fd);
+            ahcf->sve_vq_supported = kvm_arm_sve_get_vls(fd);
         }
     }
     /*
@@ -536,7 +536,6 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
      * for all registers, hence ignore the errors.
      */
     get_host_cpu_idregs_all(fd, ahcf);
-
     {
         int wret = get_writable_id_regs(fdarray[1]);
         if (wret) {
@@ -572,15 +571,15 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     ahcf->features = features;
 }
 
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2)
 {
     CPUARMState *env = &cpu->env;
 
-    if (!arm_host_cpu_features.dtb_compatible) {
-        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+    if (!arm_host_cpu_features[with_el2].dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features[with_el2], with_el2);
     }
 
-    cpu->kvm_target = arm_host_cpu_features.target;
+    cpu->kvm_target = arm_host_cpu_features[with_el2].target;
 
     if (cpu->kvm_target == QEMU_KVM_ARM_TARGET_NONE) {
         /*
@@ -591,15 +590,18 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
         return;
     }
 
-    cpu->dtb_compatible = arm_host_cpu_features.dtb_compatible;
-    cpu->isar = arm_host_cpu_features.isar;
-    cpu->sve_vq.supported = arm_host_cpu_features.sve_vq_supported;
-    env->features = arm_host_cpu_features.features;
+    cpu->dtb_compatible = arm_host_cpu_features[with_el2].dtb_compatible;
+    cpu->isar = arm_host_cpu_features[with_el2].isar;
+    cpu->sve_vq.supported = arm_host_cpu_features[with_el2].sve_vq_supported;
+    env->features = arm_host_cpu_features[with_el2].features;
 }
 
-const ARMISARegisters *kvm_arm_get_host_isar(void)
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2)
 {
-    return &arm_host_cpu_features.isar;
+    if (!arm_host_cpu_features[with_el2].dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features[with_el2], with_el2);
+    }
+    return &arm_host_cpu_features[with_el2].isar;
 }
 
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
@@ -2187,6 +2189,52 @@ bool kvm_arm_mte_supported(void)
     return kvm_check_extension(kvm_state, KVM_CAP_ARM_MTE);
 }
 
+/*
+ * Rebase cpu->isar.idregs[] on top of new_isar given the initial_isar.
+ *
+ * For fields in cpu->isar.idregs[] that are same as initial_isar, update
+ * the field with the new_isar values.
+ */
+static void kvm_arm_rebase_host_idregs(ARMCPU *cpu,
+                                       const ARMISARegisters *new_isar,
+                                       const ARMISARegisters *initial_isar)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ArmIdReg *idreg = &arm_idregs[i];
+
+        for (int j = 0; j < idreg->fields_count; j++) {
+            ArmIdRegField *field = &idreg->fields[j];
+            uint64_t idreg_val;
+            uint64_t initial_val;
+            uint64_t new_val;
+
+            arm_idreg_field_read(&cpu->isar, field->idx,
+                &idreg_val);
+            arm_idreg_field_read(initial_isar, field->idx,
+                &initial_val);
+            arm_idreg_field_read(new_isar, field->idx,
+                &new_val);
+
+            if (idreg_val == initial_val && new_val != idreg_val) {
+                /* The cpu->isar.idregs[]'s field val is same as
+                 * intial_isar.idregs[]'s field val, which was used to
+                 * initialise it. Hence, override it with the new_isar[]
+                 * value. User might have explicitly asked for some value
+                 * which matched the host value without EL2 in this case,
+                 * that value is lost. As rebase is needed in very specific
+                 * case, we avoid that complication.
+                 */
+                arm_idreg_field_write(cpu, field->idx, new_val,
+                    &error_abort);
+
+                warn_report("KVM ID %s.%s value changed from 0x%016"
+                             PRIx64 " to 0x%016" PRIx64,
+                             idreg->name, field->name, idreg_val, new_val);
+            }
+        }
+    }
+}
+
 QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
 
 static int kvm_arm_sve_set_vls(ARMCPU *cpu)
@@ -2307,8 +2355,24 @@ int kvm_arch_init_vcpu(CPUState *cs)
         return ret;
     }
 
-    /* validate the cpu->isar.idregs[] against the host's isar.idregs[]*/
-    if (!arm_idregs_validate_safe_rule(cpu, &arm_host_cpu_features.isar, &err)) {
+    /* For -cpu host/max, rebase the idregs[] on top of cpregs[] */
+    if ((object_dynamic_cast(OBJECT(cpu), TYPE_ARM_HOST_CPU)
+        || object_dynamic_cast(OBJECT(cpu), TYPE_ARM_MAX_CPU))
+        && !cpu->has_el2
+        && kvm_arm_el2_supported()) {
+        /* scratch vCPU is created with EL2-enabled for -cpu host */
+        kvm_arm_rebase_host_idregs(cpu,
+                          kvm_arm_get_host_isar(false),
+                      kvm_arm_get_host_isar(true));
+    }
+
+    /*
+     * validate the cpu->isar.idregs[] against the ahcf->isar.idregs[],
+     * select ahcf based on the cpu->has_el2
+     */
+    if (!arm_idregs_validate_safe_rule(cpu,
+                             kvm_arm_get_host_isar(cpu->has_el2),
+                                  &err)) {
         error_report_err(err);
         return -EINVAL;
     }
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 750dbe1ef4..538f87e69e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -129,11 +129,12 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
 /**
  * kvm_arm_set_cpu_features_from_host:
  * @cpu: ARMCPU to set the features for
+ * @with_el2: probe the host with the EL2-enabled scratch vCPU view
  *
  * Set up the ARMCPU struct fields up to match the information probed
  * from the host CPU.
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2);
 
 /**
  * kvm_arm_add_vcpu_properties:
@@ -231,7 +232,7 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
 void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
 
-const ARMISARegisters *kvm_arm_get_host_isar(void);
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2);
 
 void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
 
-- 
2.52.0

