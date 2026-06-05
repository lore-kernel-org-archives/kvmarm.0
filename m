Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CE53DCDAC
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649048; cv=fail; b=YfMbPfv2H1/oQHA6asOtAEclzMXJzpoy8h11CP3qXyI1lhYpZustEIemJ3E107+JKRTy+9My0k6J6k+ihkogrZ0wxsCf4egyvmj8A5A7v+CZU4exFRzz24AmjkxfBWkdGHWKRXZYSy90BIbczpD7py6K+9zLG0rW0XZaoOYxK4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649048; c=relaxed/simple;
	bh=xcyoy0B4GHQaQISp2RGTdRoeqNsHKT0OBhDf4kT7h+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sKmDy9UfqzjEcz2vvlhEUnPbrIXtS/Y0GSYgDWrBnWhrrVIwTm/ilIPZj/O7kfiEud6V5E07rw9O079KH3tpFbTPDEmzNAY2fzxmqw7Z+EluskLbOFviQ7R7yFJPZi0D8CMO5ehnhzzqYZ/K0F6+/GJ7MIavBgpsZx++pVjNZUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tFMTxal4; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qCRbdt9L; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tFMTxal4";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qCRbdt9L"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUF1185382;
	Fri, 5 Jun 2026 01:43:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=PXbDP9klCpM4kzndgvzvRlHdyJcudZplryw8ikfqI
	Zs=; b=tFMTxal4pqa7jmx5eUmR/XDmLX8oXolL9noezMWDDCT5skie2LaCqR3A5
	FQtk5FiaAAuZTJhbqjaW2qYhC2mY1TPUUO9KFQkmPs1DUhMBZn6tfhdd6mfPIPB+
	DwpyssyedeXT2h2LuO47wJlYzKy/9ueZXWn2Aw8jay67jPh9NzVZVcDyjeM4mMqS
	hgTKJitrMxf5q6Ea/DXK2ULchREGm1zfz9ViPi/6iMDvReN86RA1D6Kv4OJiCaoe
	+ov9AkC2/Y50is0Jh05w3khAcxouwWunn03qtHyahownjmKtocsIkjAVcNFID83G
	shUIDD9fMuRjgfaArBcpxB8C8087Q==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSJ8KF9SZGZMFrLDGZfNP4sG78VwFsgjwbn/0xE+4VcivQvPFBPVF/A7e2t8GG2VFsep3RiO7PVGRMIuGr4DXup2pXjNqkBWfbX4/4nJj5nwsa+fQAE0hmiM55lFcdUfYMQgXWI37PiTu8AUyUjD3NIfyD0z6xYMDWPBFbU7zxDJpGz5ToCA19vzlnoxoq0IWyPFNeXa1cYBnvbVZaFQ1hRdnM7btgdxh4Vq08btXJWaJMESYviXC13vkVxGHl8UugEtrsTj7FHXuaWobqOEV8y3bNEau74LC+HG0wM0+xxFei2HKOHfWsG2GQ0sS44e12CdXT39dYaJwtCR9SzN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXbDP9klCpM4kzndgvzvRlHdyJcudZplryw8ikfqIZs=;
 b=b++q8nu4Icu6PsX8XZGpb9tr656OXqEz8XlAV4oyxUD2OFnygk+Y+h8Mkj8JuKUpbo61zLvRHZkAyw2QNulogvIgacaM6ALlx5KwGDQbqWGPnhbY+b08fej7wo4JK4iD7lha1paGhjtG0Y8yr6QF6PwbrpI+7HhxaM3gg8qA7sZJkv1bX6SLaG3TsJHyWmrLW58Pbxh41MIqom2Bf+bQjxhjBXbrdck8JNcjbIl4ZsHZsDRG20kMkc2BU0pq8i7GHR/euESzyM7sv5QVJAa6gKZzqkVOcRc4vx6vxZVGc2OPJP7BzDazmv3vz96Q52j90MMKccZLhIL2xC2wdTEPag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXbDP9klCpM4kzndgvzvRlHdyJcudZplryw8ikfqIZs=;
 b=qCRbdt9LXmKMZ3VGnOxDTy5mk/0QSHhCbP6c5HImgA8P/EwQAK17ukONzrjiymnD2OQVYFokt7ytSbu9pnVRLNcoafAbakAVwKPIWiXCsOmIZdjwzNaHuQoXpDaI2vGhecQiSVy906hspNXe9SbzYsFfALCaTV+b8+GnlSWRxBpe6zWJ+00MNXdEGULWsoz2+oUL3VKU8NUf5w9+1hR4FX85DMPIpXeHzHhLSO9VSwzt93gkYUtkibX2W1AkCV4pV4OffdvLRn+buWq9tm9nr7d1BaZzdcMBG0d98P/VSVExXyBi8mVdqMEw4Hiq2DF2+WDRJ3PmHh5MIUQqs8HDiA==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:16 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:16 +0000
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
Subject: [RFC PATCH v2 19/29] target/arm: define sve composite property
Date: Fri,  5 Jun 2026 08:33:48 +0000
Message-ID: <20260605083358.1320563-20-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 92ea7c37-ec83-418d-0172-08dec2de7c78
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gQ6HeEhrBZDA0X0i4kylApmWDSs1wmL1/D/9QMK4Wztx6z4F4wn9jTd20lPYQwca/UMdYWCAee+Y5+B88u3WHJmfC4iU0sQ5ghLJWTa1KWchEG25L6zLuoJZjx3D9dhgPQ1dctjzCWJaY+U2TRD0qKs654GZ9iLtSjltKdUWgh6kfmIogohivGnoRSfCibwbZI+X7S9VT/hASVhM1/vbD5lKsKxliSHvXuS0T+KEpvNXVB5SLtxLUv8zHtw4FehgiNeGqJS24dMkO1plTEK6kFoDwKEviiKHdr2vn3JN9UG2A0S56RjfxNhdhSJVIpE4AmiZLkVlZ2Xs1yDXY4gcg0jzSb7RHgDXIEwZFFywNSnJCVnbjqLhyMi2+21s1gqP0I6t9oZFyXELmMFSDNbF/XMnuf8+lonuBZItFi0XVjJQHkXWGlr+3JhuFSyRTh+DTd4Bj98aiyVtVBRBVDq9pDxvDz7b4sSnpyTdYLhVPDy2P/OCF2rbcgFd+EV6rzmWThncXxMlBrikQ/d1ChjqSyXNkXZJaxvkHwchr3WybNZvCC1Z1kH4WLi7acHyDtg2CsP/SjtLgd0Nw2NxhPFkHe1MOcEF/r/RY1NGJPhi8LBGxkt4WoZeW1HhBV79G8FymWuK1qlaE0hooc9ALSvV1360hvieSOOrN6Z7Y6Rn3DzChOdGpEXDpYt1g/W4Mjnb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qEL4bJKko+1LDABB3qv3giJzzB6qmvHS1YLjlueBKRx63o1XDeDJ9dhTgce0?=
 =?us-ascii?Q?LvMpN3c0aEELPh/U/lYjQv0oit7OnEVGrXPqj3hpMTU97Fbpu3VPqt/ndNGm?=
 =?us-ascii?Q?joyAO9thCeLz5mCB2+/o4knnxHsOnFTQDFpaPgmwC2Ilde7k3aslQhDKop3x?=
 =?us-ascii?Q?jo1y+TGQa+3ONBcZWxSPamys6+BjzC/5+2Ji4n2KbUZGTivfdGkXPspN0g5N?=
 =?us-ascii?Q?kCURlAYQcNd82nCiTqiE8JiGUWFUNlq6Jah2qjQ24mx/Bs8n/STgqLaTaKPi?=
 =?us-ascii?Q?ta1Xim2i72a17Xd8BrLyv+Cz+YXG0RXmAYivZz9C/nAfejpq8RO6TlD24bQw?=
 =?us-ascii?Q?L+P3iZfYxLeSxcfHEMxFwQKqoPBqjHzRVbR+vhmfCK3a4qsZlXzPLToUbakV?=
 =?us-ascii?Q?YStG3Vou6yfzxgZi+vs2jpg7Fb1GbNMxxPpXxssWoYq67RXUkLnLIKDirOmp?=
 =?us-ascii?Q?Q0YQB1CTM0eMPynrole85ZwSLtdx9ksYehBiGUh1ZSq4+541c9DUY5tEsGQp?=
 =?us-ascii?Q?Ts4zb8dWYAJvawPiNmXrABVF9OEDKEW1oGFTSBSm6ujYYMqeOjfKJkgVwE3n?=
 =?us-ascii?Q?WT+uFwsq4BR2N0dA7bUT1LpamAHQlTP4GqjJGq/G9mrr9C5qSm5OhRQVfn2M?=
 =?us-ascii?Q?MSpqR/58uuEMDcwWVwcVoQ/Aa+uo1ceRwYvcrwpenTVe4si5eZleIrhKP0et?=
 =?us-ascii?Q?l4nuO4nRY9LnYrKcNS6uv92QHju/H6i4WHNrds4g1pymrvoVOi43pz2Bupv9?=
 =?us-ascii?Q?r7lO+cCytExKdPkudPd5BJvtx4FBE5N54tQr+D6BEVlv7N/PRG6FWJ6db2la?=
 =?us-ascii?Q?elE/atG+GbP0Uc/DowCDhfvdplN2hYl65a+v1I982IzPO3GcL4J0ELp6Wg3q?=
 =?us-ascii?Q?lEImjft/uOjbCdubII9fUnXBuZOcqcOiqs4I1v0du/yumu/+jPdz1d3duy5Q?=
 =?us-ascii?Q?0lmkETNYfzUULwIuiKHT15nJTkD0K5bB5H7Oxio8afXPsRux9ry4YNjz4DXz?=
 =?us-ascii?Q?7H6fXWzRvBheGEZY4FqDSMHPlHca706VuYBpxgYvZdwXvGYY15wvug6s20k7?=
 =?us-ascii?Q?NYZlQBn98666LoC9MtkykpGyhlqYE7gx7KWqBjrsPh5l253bsn9AZEtNeCpW?=
 =?us-ascii?Q?9nQ1vUSQRbojW7QkFT0xcRavLmpgfy1q6vlB5qOHPEXnHUvtQrnr03egPTNr?=
 =?us-ascii?Q?Mqp6SvswYWpNBeNrBf9suJ7ejavdv/4Mk5cn6hkET7mNB7/n3jEHuV93lefb?=
 =?us-ascii?Q?8xkiSM8eAexc/qj8ee+2TCmmE3+ejzGQV/fPRaogdsO64x+thBpcPkl79FqD?=
 =?us-ascii?Q?4ZGoYSB/Ut5AEDszAmF6yQ/7tXvoo4afmZRV8yjueB8RXPYPUTD1qOvS+qVw?=
 =?us-ascii?Q?PN9qlouL/eCo0zpeN70lYVhTOJYnhKTel4vR4T0Odv0dgPmswMKh1xj+dcv7?=
 =?us-ascii?Q?HFWpa2emZXvqhbx1e01Z3o/+YE2dOc6+1O5PJhPMc2on75PRlaQmn8vIvfkp?=
 =?us-ascii?Q?6InNqfxZ5osimXIGxcZqILpgGHnZpTkbr/NMi1hCnk0vCHBSg2r8eaqm5n1p?=
 =?us-ascii?Q?eHKa5wDyJY+QDnwpC0AKGeiHegSqzNyTnaFH38tLUwN8ZR36g4LYiOywtiW0?=
 =?us-ascii?Q?VRi+Rb5xUEyrketI4Nmo1FvjlRhBGT2+YKT5yEdwew2zYTRKK5MyVzgQdQge?=
 =?us-ascii?Q?Rbw/wrvY4zgV/5qCAYpNrQWakCRoWr9BmjONEJRnAfPmQ1Mja1Vp0ot0zk4J?=
 =?us-ascii?Q?1TzRADigdtpUisoDnTgb+bvb87d+F5U=3D?=
X-Exchange-RoutingPolicyChecked:
	jSZvH0JP7vSJTniseZKpoM4A+yJpynX3lzUMWxy8P4oSEU48x+x4aMHGEP0oe70vPssx0UnH1vNybRNsF52VGjNUXHslbBVnLyATxOJO4APmP8n2BilgEksZ1DT7F1WMfJCeIQaqq/4lp/RCS8ifvIhz2Ijqjydn0yAzVk+LDnmPNemLG5gn+R+OCjRVH0cVeQwNMiaEi5ZeyhzP6S2A1MPBTzheR+tzr8wBRscqODpT+/ObbHpyrWQZXwevtyNZLOpX1WelY+wb7jamtRg6VQTHshcw/lxDp0AM4T+1qa/cEqeyB/i7Q4MHn+R/T/LfkUd1YD/1Qt3YpD4Rb82joQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ea7c37-ec83-418d-0172-08dec2de7c78
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:16.1400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RY77zSEbTl/+JZKgL0cpXOIyGjUWlK0NQhSqsnUdb/qBSlo+4Tvv1TpXJyfx7eySZGCee1vD4mCM+VCuDmv8HKcw2jAqeJkkPA7S6p1Ae9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX0oaexxK7XJNZ
 yfOSqdTGblWEyFi2AYNBrSt/WSaCRJedkPOWK18QeDjGEi7rofBwQ2sQuaSIFlY+MVNgu1Qz6W3
 M0/tPr6gBuIQmmdL7iuP3+XjaSV4KmmUoEwmQImqa+1IsEajga2wxcrlKcIkuXJF19g1pqJJtCM
 AAh1pQoRLeuzTBlQFi5Wd3rtOF79d4LJgbuOnB6GhZWEoJdYcu2ovXDodt3ugqPs7pvRREtQf6l
 F6PEZrIi1jgA9DJH9Lz1KJYLa+jLSKNQkrxv3Li7cqyVW4s7cQePpYXi8tmV4d6bTRmPPLogeRV
 qEmcrYi0wRE+sh+McU8q9ck9HRUqmDPXiU6HewiFZsEhU8S1rUw7rRpRTqSgPMZ6mHHTTKANEKH
 XvxpxsYRJoh9k/w8N6TUdc6+RVpgLh02yrAer9+eleixyWmwHgdgcPRAB0yCgOXU62eu6fm9mrG
 58dRueNXqEWiZWCvTdw==
X-Proofpoint-ORIG-GUID: OTI67p7ho0Dq2NSHe2R-JdP5MV4fEEGY
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c28 cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=wDSBecT5HbJQFDkPd9kA:9
X-Proofpoint-GUID: OTI67p7ho0Dq2NSHe2R-JdP5MV4fEEGY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Define sve composite property for named cpu model. The sub-property
list contains: feat_SVE, hw_prop_SVEVer, feat_SVE_AES, feat_SVE_ELTPERM,
feat_SVE_BITPERM, feat_SVE_BFLOAT16, feat_SVE_B16B16, feat_SVE_SHA3,
feat_SVE_SM4, feat_SVE_I8MM, feat_SVE_F16MM, feat_SVE_F32MM,
feat_SVE_F64MM and sve* QEMU vector-length toggles.

Also add appropiate sve composite model values for neoverse-v1-v1,
neoverse-v2-v1 and grace-v1.

In cpu64.c mandate a SVE vector length if named cpu model enables SVE.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models.c | 35 +++++++++++++++++++++++++++++++++++
 target/arm/arm-cpu-props.c  | 25 +++++++++++++++++++++++++
 target/arm/cpu64.c          | 14 +++++++++++++-
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 1fe20b7d6e..8a725a0c26 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -90,6 +90,14 @@ static const ArmModelPropValue neoverse_v1_v1_pauth_props[] = {
     MODEL_PROP_END,
 };
 
+static const ArmModelPropValue neoverse_v1_v1_sve_props[] = {
+    MODEL_PROP("feat_SVE", STR, "on"),
+    MODEL_PROP("feat_SVE_BFLOAT16", STR, "on"),
+    MODEL_PROP("feat_SVE_I8MM", STR, "on"),
+    MODEL_PROP("sve128", BOOL, true),
+    MODEL_PROP_END,
+};
+
 static const ArmModelPropValue neoverse_v1_v1_props[] = {
     MODEL_PROP("cpu_implementer", NUM, 0x41),
     MODEL_PROP("cpu_variant", NUM, 0x1),
@@ -153,6 +161,7 @@ static const ArmModelPropValue neoverse_v1_v1_props[] = {
 
     MODEL_PROP("hw_prop_BS", NUM, 0x4),
     MODEL_PROP_COMP("pauth", true, neoverse_v1_v1_pauth_props),
+    MODEL_PROP_COMP("sve", true, neoverse_v1_v1_sve_props),
 
     MODEL_PROP_END,
 };
@@ -210,6 +219,16 @@ static const ArmModelPropValue neoverse_v2_v1_pauth_props[] = {
     MODEL_PROP_END,
 };
 
+static const ArmModelPropValue neoverse_v2_v1_sve_props[] = {
+    MODEL_PROP("feat_SVE", STR, "on"),
+    MODEL_PROP("hw_prop_SVEVer", STR, "sve2"),
+    MODEL_PROP("feat_SVE_BFLOAT16", STR, "on"),
+    MODEL_PROP("feat_SVE_BITPERM", STR, "on"),
+    MODEL_PROP("feat_SVE_I8MM", STR, "on"),
+    MODEL_PROP("sve128", BOOL, true),
+    MODEL_PROP_END,
+};
+
 static const ArmModelPropValue neoverse_v2_v1_props[] = {
     MODEL_PROP("cpu_implementer", NUM, 0x41),
     MODEL_PROP("cpu_variant", NUM, 0x0),
@@ -271,10 +290,25 @@ static const ArmModelPropValue neoverse_v2_v1_props[] = {
 
     MODEL_PROP("hw_prop_BS", NUM, 0x4),
     MODEL_PROP_COMP("pauth", true, neoverse_v2_v1_pauth_props),
+    MODEL_PROP_COMP("sve", true, neoverse_v2_v1_sve_props),
 
     MODEL_PROP_END,
 };
 
+static const ArmModelPropValue grace_v1_sve_props[] = {
+    MODEL_PROP("feat_SVE", STR, "on"),
+    MODEL_PROP("hw_prop_SVEVer", STR, "sve2"),
+    MODEL_PROP("feat_SVE_BFLOAT16", STR, "on"),
+    MODEL_PROP("feat_SVE_BITPERM", STR, "on"),
+    MODEL_PROP("feat_SVE_I8MM", STR, "on"),
+    MODEL_PROP("sve128", BOOL, true),
+
+    /* Grace SVE crypto adds */
+    MODEL_PROP("feat_SVE_AES", STR, "pmull128"),
+    MODEL_PROP("feat_SVE_SHA3", STR, "on"),
+    MODEL_PROP("feat_SVE_SM4", STR, "on"),
+    MODEL_PROP_END,
+};
 
 static const ArmModelPropValue grace_v1_props[] = {
     MODEL_PROP("cpu_revision", NUM, 0x0),
@@ -290,6 +324,7 @@ static const ArmModelPropValue grace_v1_props[] = {
     MODEL_PROP("hw_prop_DIC", BOOL, true),
 
     MODEL_PROP("cpu_revidr", NUM, 1),
+    MODEL_PROP_COMP("sve", true, grace_v1_sve_props),
 
     MODEL_PROP_END,
 };
diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index 11f45523a0..94672040c5 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -298,6 +298,20 @@ static const char *pauth_sub_props[] = {
     NULL
 };
 
+static const char *sve_sub_props[] = {
+    "feat_SVE", "hw_prop_SVEVer", "feat_SVE_AES",
+    "feat_SVE_ELTPERM", "feat_SVE_BITPERM",
+    "feat_SVE_BFLOAT16", "feat_SVE_B16B16",
+    "feat_SVE_SHA3", "feat_SVE_SM4", "feat_SVE_I8MM",
+    "feat_SVE_F16MM", "feat_SVE_F32MM", "feat_SVE_F64MM",
+    /* QEMU vector-length toggles */
+    "sve128", "sve256", "sve384", "sve512",
+    "sve640", "sve768", "sve896", "sve1024",
+    "sve1152", "sve1280", "sve1408", "sve1536",
+    "sve1664", "sve1792", "sve1920", "sve2048",
+    NULL
+};
+
 static void pauth_get(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
 {
     uint64_t apa, api, apa3;
@@ -312,8 +326,19 @@ static void pauth_get(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
     visit_type_bool(v, name, &pauth, errp);
 }
 
+static void sve_get(ARMCPU *cpu, Visitor *v, const char *name, Error **errp)
+{
+    uint64_t sve;
+    bool sve_enabled = false;
+
+    arm_idreg_field_read(&cpu->isar, ARM_FIELD_IDX(ID_AA64PFR0, SVE), &sve);
+    sve_enabled = sve != 0;
+    visit_type_bool(v, name, &sve_enabled, errp);
+}
+
 const ArmCpuPropDesc arm_composite_props[] = {
     ARM_COMPOSITE_PROP_GS("pauth", pauth_sub_props, pauth_get, pauth_set),
+    ARM_COMPOSITE_PROP("sve", sve_sub_props, sve_get),
     { .name = NULL }
 };
 
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index d326b3220a..2fa5b4d9da 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -134,6 +134,19 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
             return;
         }
 
+        /*
+         * If SVE is enabled but no vector lengths are specified, we must not
+         * default to the host's supported lengths for named CPU models, as
+         * this breaks live migration.
+         */
+        {
+            ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
+            if (acc->info && arm_find_model(acc->info->name)) {
+                error_setg(errp, "Named CPU models with SVE must set vector lengths");
+                return;
+            }
+        }
+
         if (kvm_enabled()) {
             /* Disabling a supported length disables all larger lengths. */
             tmp = vq_init & vq_supported;
@@ -569,7 +582,6 @@ void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
         }
     }
 
-
     /*
      * These properties enable or disable Pauth as a whole, or change
      * the pauth algorithm, but do not change the set of features that
-- 
2.52.0

