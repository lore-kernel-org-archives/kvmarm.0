Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C542D4A2E3A
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650647; cv=fail; b=CcALbReDWHjr6jfHa5aaE7NHhKUjeNZMt+MKw4crLwCwQlMOvZ3rt9PUaiHkG18aAjd0r60NvvHr9JwMaHM4SF8Rsn0xAB7U6oCGglO7aynhsVVveZ5ebgjGaysRa244ZDthFuUCsOa3h9rOnxW6zsqT4wamm3Vhj6kJypKqmpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650647; c=relaxed/simple;
	bh=BDclLJ2OA0McjRS4Oh90uLW2/3E5Pq20aviEpS38x5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KHZfh0PhBJderbQKek1RQOP8Cg6y/zEVWGpp1jScw5ENegRHfwNR8H+ETFLztJOX2fhMUtSddNBOOcL0vpWBHsi1V5/dDPwN7GaqQyHgF0gTAtQ2NpIEt3X7Hm+x29V0DqFiw5yUunRyT0e6bDxCbMxzCEKePTgFJuDN3doqVY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xV8TK8Tl; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=U3n7ENej; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xV8TK8Tl";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="U3n7ENej"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUI1185382;
	Fri, 5 Jun 2026 01:43:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=oo2GEMShnWTRX8Fs9ie7JPPSQYd6SMWqx6ps+iN4H
	GY=; b=xV8TK8Tld5PjzeYclON0bZZWXLffE0y4eNlMbTWKuC/b8TA7WlmXRdqCf
	vsOXikx5DCMnWCoclKS7uhfxN35Pri1tWLCuO4KxkUoYmz/ZkVXfnC02pRMXQYUR
	Xf0QNcWQxjBWsH1pcpfXyf7ik7UFzCkUG/xeFUxJ63vxatYQuy4l9KWt+G5BssTB
	nNeEyqZGWTrcK9SWNNdORpdRZiBnz72fYL7vDc63/WUZyLv1QkoMzLczfARnlXF+
	fhWZTM9ftb7TpvnDLbr4kmd6IbjQybkyb+8AZCeKlvg/z5PVv25DZm5KQHQg3Xot
	SDjh4oygB4qDRWicsh6iGW7SOIVOA==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ePK/nAxlabg8qYd7oYDZkNywjpKBskCd/wRuKO1w/KNs03Ws6IhuPmAWyN+qtGKv6OgCuBdeeFsoC3fviHAitWdHm1is3Vly56G7Z10u4ZPMYHUFwZ34AjTd/dcDtli2m3g4O0JF68bxFw4b2kgoihyUXgqD4lmfkcBGcWcHGuNBMOMKh/8SpEOGbGhaPT+IQLP2/i4sVOEilNviJkyIyZBsRQRU7Vv6/KDJ5f5QpD72qpqsHGTsQpjW+BDRsqlIMQxoHC1mgbBRnUI9Yt57JwcuTJe0711dy0s2unc39M/GjXpiq3IoYZEAA4ZTzjiB7xrDQ6lv8cZBRdCXOV6pcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oo2GEMShnWTRX8Fs9ie7JPPSQYd6SMWqx6ps+iN4HGY=;
 b=iNMrxDx0oiDjS+4EhTT0mw2p8PlsVOopU9zqKRKLIjezS2MJeb15Imuhek1xyJb+dfDlupQOWyF2GOZ724UFhEaBRc77jsKJYhQRYFBk+pT9FYh7gS2Cm9DVKzRanU4oEnIbUC+m4rP2qGsv+uyUk0QVZff9i7Gh9oQEZmewbaLVcrHuUprc/wM9Yw1VDtfFKWB7DtC5DiIweMc3nCHcCT1TZAIYQdYD4jMjHqSFuAY4SV8IyMfY4SrpCoW90hw2rCUuD2cCKAeCZRDQtMHQCSostmug14h51LgPojosSWRyaHONqrNIF3I6akg2wp68qOReNHcPQXUGYV6MhlTx/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oo2GEMShnWTRX8Fs9ie7JPPSQYd6SMWqx6ps+iN4HGY=;
 b=U3n7ENejA8VoAHo/ZFeLFxJmYBoINsfA9K41XydScQrqqcIlv9s0KwvTuEy8JNJtmVrDo8g7hgCySqZ3/pRu5zqlo09HgNgYa/8Y0ZcaH+yY1R/cUap0tKFouLAiOFKs16csaM8jEdjLLvqqVSVOXs0wzbZ+sU0pRzc7/Uz9T6LCLQyeYs4coM4qJNHEOifqIjWwzMy/HnT3HnF2z1L4Q1ajbxTAYZCEC7DuQGbAaNALF0fnPW3lj8VjfiVAVcQtKG9TAst0yMFpv3HFOS9LGFhcCVxJPc+owI9E4uptyanN1wuz3P0Oz6K0wVVSJbrNYyIotN9BXbz8xYDJEd0fVw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:17 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:17 +0000
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
Subject: [RFC PATCH v2 21/29] target/arm/qmp: add named models and properties to cpu-model-expansion
Date: Fri,  5 Jun 2026 08:33:50 +0000
Message-ID: <20260605083358.1320563-22-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: e01b2a0e-5a56-466f-151a-08dec2de7cde
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bSVF629H6QyyCr8XlnnGCle6tarxWHfjZgTwubrhv61fcz/q6zOkNW1+sRkE01Y9ak+YIIoF4K9z8URbkpZM9GXcSQmRGXDxgefJocLie2Mod4Btcq5KA9AU9IKlm1AWlczYtt+6k7nhNGg/+LXlsxctr9gM1P5vZLhK425g4oEaml+DSfQioyIOcUwOIbQ95YElLQGUqpg7ghBy5EA7DsRcEtowoY2D2YrMv5uDAVpHI6dytywcql2Aog7/jOZW9nM5hJvYPByDhX0ICZPGM7fvbmTcmDMkFi2Ck0APjDauz0//zTlnE6wVRhmbjml0GYGmJ9Eu5VBlq4hssozmF37bXJysEXcyoB6s9UaoMHImuC5OUBaWWY9Npb5cKTU41ygx1Jy65hQEHM1tZsz7Ge9frodGCAnYF6KqD64a5SZ7Mth7s0yqcUo85ZoLSv9x44dLNMbRUc5WgIQO6NpSGzAHYlMpxf4lUABxg68+KefBlFkm+ssRJlnwN1hTFy5vYgsTF7Nc5Uqofvx6jOayxB5lpJGpC6fc6siuhLKE+7B60mmt3e9LEbH+73mLkDaAEpRRXzPnVvQyDMxG4uPcGtvz0wKJIACmvm2P2Vj7p8UW/uYNFH0K0FsV0H+xzinXVwl/0JALw0sYxek/hAFiFYRL9plUV43QUt1i+zDFQlClpQA9eo78n9hVqsbtrWV7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LG1hpX0bwRTTt4Wp7/VBdkGFypErWwDQorj1qN7buVLzcBuVS/ybaPEOARVo?=
 =?us-ascii?Q?QogE0s0quBfOO3BWDYHgE/yYN0ujA4vecUFwBjdrlF3ZIrJTwu44lrt2CPxF?=
 =?us-ascii?Q?4MY9Vaj4QxLf1NCNqAujnG5HleGzhWC5yIEOEJIHSGqEDMN4V8ixPKIS+vaN?=
 =?us-ascii?Q?V86zwc7RZPNPnpu3pXQ9wTjk1aI4gY7e4NbFExQihgUra2z33tLYBKKxfQWS?=
 =?us-ascii?Q?gETVyuxGfinlseW9H0J9ZFrrtfi5dneYpZqjx6LmKxOPfQNLYmorUywIGtU1?=
 =?us-ascii?Q?lFQ1KvBjfqJ8JIhsC4DdPCTD/zXoRia+SnALd1eM8oKDLzvlM28RjZnZmlz1?=
 =?us-ascii?Q?5rqzZCxdAonbR3E3SGF5e2ThVha5vAL5OBT/g82AzhRlPsJL+eUmy6GKwzdL?=
 =?us-ascii?Q?AyPVuDNOPO6E1eZdEGU1zTZSwB+QmYTQkGPrhQvKw/uaZJezwf7vAEnKAfFY?=
 =?us-ascii?Q?pW3BuTlLhDVZkuhuwkZsNgo/xHw6I/zP/LVbGnHhaP3hNjXHR9X6yxU53c2S?=
 =?us-ascii?Q?wgyOcV5a4kV0BqimsknyfVxrZtW6lH6NwAvYD274x/sYbVTrOTqyAsUNIqVr?=
 =?us-ascii?Q?nK9UqBoGWt3CAA/S9fXKzouJxUDtggNu9boSIsCMhUInxkT6U3F1nYO2NDPQ?=
 =?us-ascii?Q?aXwnr1wDjGgEJbiYehNvDHkJK3wOnYIOjUe/Y6zs3/vgRPek9paNSeH3M7HP?=
 =?us-ascii?Q?NI2RcP5fGVELI5gvCfUIk68nDQNFOE6TvQ8lKstCCHcHOmaMvJwpCnBaMcLQ?=
 =?us-ascii?Q?IKkWNEATsNGkdx4hopbSASvZZbL1FzZWODV4G4XLV4IVwvI6tEoZJ/qoRl9/?=
 =?us-ascii?Q?DFxTUBtMOLoacc7LhFirJxAx+P7ATRnlEcAKgGwyJSNHXGREoCzhlGLCrXp2?=
 =?us-ascii?Q?5XuTWhPdwx5r9ibDD+p+kmzsmFUbNcDgUZzAFtuBL+PBoFBLwZZBoYJIKYNw?=
 =?us-ascii?Q?hFFagxGvp4CpMk/vBFQvLXpoqxpfMG40Wll9r5YfDZckcoE7ibdaILBDMrjo?=
 =?us-ascii?Q?a+TzW4R9X2dPlrYdi5w3ONC6kPk4GpzW+aJFgGAkXy6w/tUPzhgzjhpwnSK0?=
 =?us-ascii?Q?NZeP+7Qfo5w3Wb4AbKCah7jCBCUqoJzNfOw/K5XPMZ2N5ibghI0ZfaWHwz+x?=
 =?us-ascii?Q?6Pu2z2muGx1Zxf0W4zILGZX0f61pZrSNkWFb2kURHT7VfxDfzgBeZj7cw7M5?=
 =?us-ascii?Q?fEMi8c/WgmsNJg+bJx0+2LvzCK3+R08/FXI7q2p2lCFh2mxx9Z8OWTzAxojF?=
 =?us-ascii?Q?d1TVzcqhe7piyizCKfabnwZLozzePSpEngJmF6fkLcrHil4+OTPxCaF/WkpQ?=
 =?us-ascii?Q?h8CQqJPuusM8e6qYyedZQo0/FvZwYC8CNxah+PnUuD2/dj4XCf463p2Icgmp?=
 =?us-ascii?Q?d0HSOXBn64vH9qu3kG6ZwFCjnqnIyvmEIUSL0Mg3pt6/SfFMa6TRk5ZaHGg+?=
 =?us-ascii?Q?MAWNOx82vh2EgmI6s/3W91j+0ReeeQwwGGoZFj8JUpmF4MFSwWUIuCdq1TPU?=
 =?us-ascii?Q?Afxcj9EYkNCKxor6NGqq1Zkz7LxKmm3nMrz0Ix7SeUA/a3QMuMDpETUU08lU?=
 =?us-ascii?Q?mXDA0rGRyp2jDZu3cV+2h1iNYs3SsC+mQtn8fJ9Xp9T7e2JrnXRZMyvgFjSc?=
 =?us-ascii?Q?fOx4S61/jJDwtD63vTEi8KDeuhU8JqBs2pv/aTrT30dFVVDusfSt19jZlV7g?=
 =?us-ascii?Q?PR/CpsIYkGknM8rhVubFeR/1y1ESNbI6pWZtj0On6uvaVJ8HEo2rYKyzIGqY?=
 =?us-ascii?Q?/PLdZB3yrr7jYu2xb4MHdW817WYq8ss=3D?=
X-Exchange-RoutingPolicyChecked:
	RLZyQfypVudPdJroo3yDNZJqTwyBZUAhpbofuYWuTmmB8LmbHFBbzwdWSB1DfoK7Rqph4vucpJ1KONyQN0kADE8fQSk7Sevx//8PIm13n3BE4iP4Uq/LMA1YV+l1xPNvlxtwOu+qvP/tMKZXIjpJBdqcmYeOQaVxawI6tRo6yt9zhpCR42YFiYckrKSgLmNT8xqOkkX4rCb7oUZMTenM6w/A8rsAb4887M0hN0gbpNjwLJXKuwJKcH57R0EoYHTG/KtLAeoeyOWqUoRbdp3ePQVeTm4hqQxFT0iF895L2GL1xv2LKSJE1gTufXZQAAoQK+Gd5kjlIa7m1yFLULDN+g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01b2a0e-5a56-466f-151a-08dec2de7cde
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:16.7829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQw5qw9czgE6P9JIhfklrPo/omBzAjqDVeJnJ+i01VqQfzLN1iT1AgEHoO2+/3s2SQJ1ewr79EURf2TnbKpvxQiYGi1AJ5gSPMKLBCp+hAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXyNC9uY4lMMt1
 IVWBVSAFUm2l+vvV+TpdZFKESPb6oDlvo9UEh9ln8q89ipDF0zQi5ofcPffboH/J5VAHn2NhX/J
 DXb39zJVMByWrfDNRUfdJdRLmzM4LnDhbhPiVNVJGcY65spYU0A3+lcRe1PaSOAd9zD2ugyz0Wk
 kZ76i9Xy8pwRdUHEet9iuG42jFwThpbEjjm5G8/MuWq0PpTLXdliGklAxg2kyLgUDW+e7h3viER
 cS2rOUUafpJW9tx9/y4OR3qTtuip68pjY3BVq7aOdbcTOuGTFfGpRAGWqQ3ZDxnx8r9wsCeHzNO
 28PWSWkHK95kSr4JNrLBLers/wNFPWB9F6iOPvUvA3qXmP9t3XNIOJvnOpcoOj4xuzB5PLOd1bB
 ipJoRJi6eVwQWsnLHLMyqLR1GSYI3XjoB43g34XoHgmQNV2JmDemceKnySyLGJwSvCZ2RZYzj8a
 LF3XAEw6cMzfVXQI8Xg==
X-Proofpoint-ORIG-GUID: oQlxP60YWOffHUUoZn_F2LtJrzRU-PAl
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c2a cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=MBHIvbmV4fGAtTtWFm0A:9
X-Proofpoint-GUID: oQlxP60YWOffHUUoZn_F2LtJrzRU-PAl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Update qmp_query_cpu_model_expansion() to include and process the new
arm_cpu_props and composite properties under KVM. Also, allow expansion
of the new named CPU models themselves.

Process named model properties separately from standard advertised
features to avoid double processing of properties like sve/pauth.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-qmp-cmds.c | 71 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 83ec95c290..7cb74b4b8d 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -32,6 +32,8 @@
 #include "qobject/qdict.h"
 #include "qom/qom-qobject.h"
 #include "cpu.h"
+#include "arm-cpu-props.h"
+#include "arm-cpu-models.h"
 
 static GICCapability *gic_cap_new(int version)
 {
@@ -89,6 +91,7 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
     ObjectClass *oc;
     Object *obj;
     const char *name;
+    bool named_model = (arm_find_model(model->name) != NULL);
     int i;
 
     if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
@@ -101,6 +104,11 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         return NULL;
     }
 
+    if (!kvm_enabled() && named_model) {
+        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
+        return NULL;
+    }
+
     oc = cpu_class_by_name(TYPE_ARM_CPU, model->name);
     if (!oc) {
         error_setg(errp, "The CPU type '%s' is not a recognized ARM CPU type",
@@ -114,6 +122,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         if (!strcmp(model->name, "host") || !strcmp(model->name, "max")) {
             /* These are kvmarm's recommended cpu types */
             supported = true;
+        } else if (named_model) {
+            supported = true;
         } else if (current_machine->cpu_type) {
             const char *cpu_type = current_machine->cpu_type;
             int len = strlen(cpu_type) - strlen(ARM_CPU_TYPE_SUFFIX);
@@ -148,12 +158,38 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         i = 0;
         while ((name = cpu_model_advertised_features[i++]) != NULL) {
             if (qdict_get(qdict_in, name)) {
+                if (named_model && arm_find_prop(name)) {
+                    /*
+                     * For named model prop; the processing is done later.
+                     * for -cpu host this does not double process as the
+                     * arm_cpu_props are distinct from
+                     * cpu_model_advertised_features.
+                     */
+                    continue;
+                }
                 if (!object_property_set(obj, name, visitor, &err)) {
                     break;
                 }
             }
         }
 
+        if (kvm_enabled()) {
+            /* Set properties in order of model->props definition */
+            const QDictEntry *entry;
+            for (entry = qdict_first(qdict_in);
+                 entry; entry = qdict_next(qdict_in, entry)) {
+                const char *nm = qdict_entry_key(entry);
+
+                if (!arm_find_prop(nm)) {
+                    continue;
+                }
+
+                if (!object_property_set(obj, nm, visitor, &err)) {
+                    break;
+                }
+            }
+        }
+
         if (!err) {
             visit_check_struct(visitor, &err);
         }
@@ -180,7 +216,7 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
     i = 0;
     while ((name = cpu_model_advertised_features[i++]) != NULL) {
         ObjectProperty *prop = object_property_find(obj, name);
-        if (prop) {
+        if (prop && !(named_model && arm_find_prop(name))) {
             QObject *value;
 
             assert(prop->get);
@@ -190,6 +226,39 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         }
     }
 
+    if (kvm_enabled()) {
+        const ArmCpuPropDesc *props = get_arm_cpu_props();
+        for (i = 0; props[i].name; i++) {
+            ObjectProperty *prop = object_property_find(obj, props[i].name);
+
+            if (prop) {
+                QObject *value;
+
+                assert(prop->get);
+                value = object_property_get_qobject(obj, props[i].name,
+                                                    &error_abort);
+                qdict_put_obj(qdict_out, props[i].name, value);
+            }
+        }
+
+        if (named_model) {
+
+            const ArmCpuPropDesc *composite_props = get_arm_composite_props();
+            for (i = 0; composite_props[i].name; i++) {
+                ObjectProperty *prop = object_property_find(obj, composite_props[i].name);
+
+                if (prop) {
+                    QObject *value;
+
+                    assert(prop->get);
+                    value = object_property_get_qobject(obj, composite_props[i].name,
+                                                        &error_abort);
+                    qdict_put_obj(qdict_out, composite_props[i].name, value);
+                }
+            }
+        }
+    }
+
     if (!qdict_size(qdict_out)) {
         qobject_unref(qdict_out);
     } else {
-- 
2.52.0

