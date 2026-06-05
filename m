Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69493CF679
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650694; cv=fail; b=XUm9P1/qIRDW2iOCsxlowKN0gLyIWBlV9FBmeHhPWd8Ihg3zw4Ps860r3ZxxHpnG+L5LhrDRLQkizawjmVxljCBW3+9oNw0frCYoMp3DaYsAElznXmPAb6PTSIolX3uEgAvZppLYq+XldUHu9ChYmUTY2FTjyVfvu8jCGOmoA1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650694; c=relaxed/simple;
	bh=YjM5F39LaH2p03wz2zsCGOUwKBZipCY1RBRzFcLWu64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TZeNNvNGnn6wTrgQCjW1ecDJ2cwYYj5dykaFQyNHHyZUnHo6xz2qcVxakH9PETsX+5ccxgAUlVhry75vGAKR58qZj45WEGD3h7nDtOkL8Ke/8i+QJ/C4yEkCk5y3oFCgQCt3YeeOGlggzVHMDgx5BkU0Xphhj3eGT69sqzswDR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=U/uNIc2/; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KxRjaoAK; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="U/uNIc2/";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KxRjaoAK"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLZ854749;
	Fri, 5 Jun 2026 01:43:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=knB5ioh0741/ZqakZdt2sAM9KyDHIeG+aG0OEvEXT
	1U=; b=U/uNIc2/J2XavXrk/aFBvj0LctYpARFh9vcpG3b5n8QjkplRkfQ8Xbeg+
	au2+kx4+q5JImNGpnz8ikzk8cALf2F6gC7IOeVwRFNG+HTxEEwOMHO0ygAeQjgK7
	pnbD+5qUvtT2zwjj1O/9ULzRcvxYPtiZPrqpe6+qfjJaMB/U/tL7bp/jlPrBNjmD
	oAhfGm2WHqVGIG/Qjbt+F9nrv5jK+WV9or0zthGhLZih+Hjn2uX3T8Ez5UP8WsL+
	eUL/TIstHqg+uUKmlr6/zh+l2E3vsVTz8G0o0+YcqtfWza3wCTCSjo1l8bQZf/tV
	f8i+C58vGbmvqY/lcqfr/L4rfVTUA==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-14
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q87QuqCFaSUuYp6WU82tpCK80PbHdrX9ve5136mkd0K9W+9f2RpU08WO6ltlBf5s/PcMf7032AYAxV6LLABhXB6xfjJfZIZfDpxh2iCSevi16OSDSUjI9/9BGoXszlWafZ19xRpDhOE7teqGNgmtqyV7hLADVhHbAD8c/73LulFiHZoBFvXvc8T1knRMgbaLxJKiZ+HS0BzcW4nqH8wIUu1UkOcUvZJcww2NFD2RCGolrX/BH/epEV0nn7orxvMo8pa9CZ6e3Mz8F6QXo0qpahCXGRNBsPj8CczbL8uS5IZBY9CWUJcrYTlesFekKINVdIWO0BV0qftB1UQvazNuNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knB5ioh0741/ZqakZdt2sAM9KyDHIeG+aG0OEvEXT1U=;
 b=jehF+8uyxSLkrLOyxZ5Avn1gCszgigg58cvCmOtmkA5llz9805dmF2831cMSmAA4Vseu1UV4TsreFV/nyTcHjRzLQS2VurBK+zKqQQ88SzcX6cFuROj7IHnMBDegtn5dtJ9FgKYvgWQyPnDnVDko1kGR8QGdtfMOdgy9Fz0HuvX+yQT3rsAr2cImQTDM7zybmAWPHQ459kfkp14DbyvFSrIPSIDeQsHqw8gU+eoB/fFjG8EEfo/SA3APjOMLYQ/jLdtnruuIQnaQ92nVHQVuHQvG0pzhM4R7Shf9PYcvkE+PTEpUXhBydr+S4naiyMC7rGVb8zVyz1UN+xX7Objjew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knB5ioh0741/ZqakZdt2sAM9KyDHIeG+aG0OEvEXT1U=;
 b=KxRjaoAKBIcFfzGXTCnExr4Aajk6ZsUd6ZFZY0DilbhEmHrA0oBPpK8D3fM2ulYToKJEMc7R/ILjPkcvFrKyorc/vMtdRVsdMre0L46s5zob1c980fRuIDPh+rzJXAQpWvHN0C/52oQPK0+U6GbI43eQSQSLAOLtX9Hf4ESFrGB9AnariyjV4Br0wPUqjTpaQPlghh6JxHvUeKcAWH5HT6drbZ00CU4zi2/GqcDOVCu9vs2eJ7TvU0p2MNlLl1ByP7lAzmZiw2lmBzVNhRaPKOHHxKrxxypG7PsD/Rq78QKUJDCv04vWCneD8NcsSGDFGj5d0dOhgEfIwu/1jSjXGw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:15 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:14 +0000
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
Subject: [RFC PATCH v2 16/29] target/arm: skip GIC, COPDBG and PMU fields during KVM writeback
Date: Fri,  5 Jun 2026 08:33:45 +0000
Message-ID: <20260605083358.1320563-17-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|CO6PR02MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: 0efac1fe-06cd-4f2d-36d1-08dec2de7bbe
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UiL4CyUKWUYQpok/UgnIVl+GLvZZJ8vs2TRjqh4LbotFTg1J5SdlYT7etzzSEILHxOrdAeBh4yY56p2JEttgG6E9bGLd+zU59ePjkQtWY1QoKtdIfkU37mTqLLlA5ebb3Rt4enZZvp+XynrDA6ekILWaOFR/s23NBW083VuQlKQeLQjDUMwmSrTstKSymNDfe9D12EJL/ezMmEX7DZgQpo3D6QJ1J5fns6Ym782wxA/oZvrfrwNxhX4hJtWfZOSA+adNhTaELy/zrWjdz9GouGTCWUDew50nAbP7VWuhOeRahEIefXJTusTiZaH5FLj7qdgtMu7TbDjO5h8NvBgeN+BJtQm0miCF6wnP7lJK+7yx+wn2i9jHBdXyr8t8rkXg7ZX2UX4/ctj1vzVxXIrQO1WDM6baGjlZI7NpDj8pbwzKVErfIufAHVKqONMRm5PS3QpMawqBObnyPDyukLXP4DYRN9/u3gpUqQ0F27sc2dP7Or1mIaI/yvgVNEor0vBsYLxJPO/1GiG4KyyhQEPFpx1dh16NvvEXYtcRfPyfWAyTbExB1DifNdyIMUVA4DraSMC9evg5jWobrmR2rEbtyHHCde0Ab+g9/zmXspdu+eToOningX+07I7S8Iez+a1lnoKOQsTsJQVlQI6Nvw2sp9EA/0JwS6wBWTTaYBztXpPvVNX7iOxbFZe60S6ww7eZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ezeWO2W0MLN+EeLRMcfF539h9PgltYkpibar4bweuyzEoYCJKtEbWfuLjJq8?=
 =?us-ascii?Q?yp+HJixIReN8CwahnYuZrpbVbfWDHW9su7wzF+g8NbsuKIM5bmt4iTfBAUqp?=
 =?us-ascii?Q?U7rQMGTT72ZqFToyfc1bMcNZ27b3u1S8TwZeEIvpLD8a/mYgVQu9m65wVrHj?=
 =?us-ascii?Q?Km9DwvRj50w1PutXJ+LcWzO3KC+5nrZrGsqIA9HUY+95PWMlroD2aLZhFaok?=
 =?us-ascii?Q?g+nzeWy2UD3YeFUkcebhC+t4SzLDvnd3jHf0kaNiQ+GhGhhgh/bmlaJ2Q7aT?=
 =?us-ascii?Q?1LbJYlO59HEEbe6GVi2JqhuQ9ytdmb6lQg0LfBCSSe5kJo6orQDyQdSv1ZE0?=
 =?us-ascii?Q?Jjo6R6t6IzalE0LMvhECbOS2SWrSh9+xvyQ33X2GtnyuF3rQ5f4IPF/ToS7F?=
 =?us-ascii?Q?oe6hPCBSFhVnK5ZS9fBuUIm8O2Jnmp2xdxh2Tc2Qt6WtYJ4qkFRCEvckIhsQ?=
 =?us-ascii?Q?iU9u843vBBt0ny1RZCBvMOnojg9HJVFBeXkB8Omqlqyzz10sBVCkXTmQvHsl?=
 =?us-ascii?Q?rJJ0/1laznCHFQnrefFBT2FWEcPt+5AlWgQdbXNfuRHAI1GhByc3VJ9h8CNu?=
 =?us-ascii?Q?u/XHYz/CBalVMAXgyU346SKhTnP1v9AZnFWKu/QeAq9j89g0hzSMq1lecotX?=
 =?us-ascii?Q?XK9QVCeo8UKtPonU3vcXlpGXqfhRiKbrnOAc9kvsD48NMtN1snnsAy7r3vWH?=
 =?us-ascii?Q?izsIe1VMDBXYReOJqddxZC/Q3XanTRk6H0c132/tXw147NPua3cBbW61jw1r?=
 =?us-ascii?Q?PfYHuwHxjpDKulZzXy8Iqy3GQIUjdv3OEpvUodXbmF7unSuhvLU2ibEOeRA6?=
 =?us-ascii?Q?boLnhqafLauMOiWlIV4nBUTBjQ5hQ/i5p9WlAc/4nvzWzqXksKlVA8nTLaWI?=
 =?us-ascii?Q?szJ+u/v5H1dYbFPywH7wPp84/2qbe7Sz63wsy8f3YX66ZIRYoRs/tnu1SDpO?=
 =?us-ascii?Q?oWVZwD7pX5vOYyavmjLi+4PqoOuC3wo2332lMdYMtaehC3EATpV3FGEztixY?=
 =?us-ascii?Q?dE9vJ6IWf+UVQ+K0U62kB4Pix0HCw4SWEhotZWZ37O0y/T14ZkKPaP+F6l1Q?=
 =?us-ascii?Q?nErFehpCSze3Psf7nGTLC+/tPYC21DRwZN19HV51pq8pY/bLMsWmPhpFar9o?=
 =?us-ascii?Q?SawnP4xF1xB1pKctu+Uugb9x2Z1LaLO9hFt5EyKIMKYrQkAYLdosL9RzV5qk?=
 =?us-ascii?Q?P0XG9w8xjQMP2DMKxvcr4yxK5n+HlRFEOjwXxC/kKathHJI5Gg4Thaum89hF?=
 =?us-ascii?Q?evEszravWREfezKwGzs3ndCj/yZbn43wz3+UIWOXm0PDUOey0XdZKRY1CwPv?=
 =?us-ascii?Q?kwHs4bAU0PZnyzH06cWLEP7G2mmMjVPnMKvfbAtca2E+Hwekhw+in2JYMjjf?=
 =?us-ascii?Q?uQfCIgB37Rzbi5GxVI8MKryIJmA4VPwrEpaLYTZfzhvn1h5MmxFHrcQ9lTI0?=
 =?us-ascii?Q?6LAtRdtVbtZE/U5036rpeHfeEnr4LY9IlFJarroDvN5WGOcLcnc1DQPjlQle?=
 =?us-ascii?Q?qEGVP2U5LjU9L819r9I7QfmOHCNWAVTlOGBSu72wtbxwL9kyzItwIQ3WES0D?=
 =?us-ascii?Q?bfGQlxRbQAERkH5f7RAN+9KD26DMAcXVLgeOdnHh89GtEW0mZPuWlnizxNgP?=
 =?us-ascii?Q?4CZJaaGuS+Wl4qnwDUQy03Y88jdPgzR6Mv6dmH2jPpGcozrJpsZTlyUbi42w?=
 =?us-ascii?Q?xxbm0bqHevUQkHg53tmePZN1+S9kanr21wFvUVN6zgJCg8uikWe5AcS0BJHA?=
 =?us-ascii?Q?pFPuJAR3NeAMOo0h1iN0REDl/K1rYtQ=3D?=
X-Exchange-RoutingPolicyChecked:
	qJTk4xBsw6FXcoaJlS46ipb1gDlg0fG4xg/VX0+n8GtVlreZbrmHC9o8a5s+ZPcSXR0M+A+qfS80UlYXEKuzRiO+IOSirwMIYghDDqRBAej//lmTckG4xdn3zgzAmLA8/0GP8SEI40SFty3IEd22dgQCwNMxOr2GU8g1S0enpfBAsninxH3u00wxMzPK7yHyEoA12x3mHrxDMn00cp8MKKc2vOeJqHfvb5EScUA5f2g+kvPRjTe9x+dUdy6r9SjU6FOz2aGZV7o8+vgd5GFcXuiWIHbC4dOq5L3pt98xoFg6GoAOeEK0HDJmwZKTt7e0sCuWvuNud8xlj2BcEy7AFw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efac1fe-06cd-4f2d-36d1-08dec2de7bbe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:14.9331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xptr/U2UgTV8NU+QHRNW7UkFJKi044dLtBE4EuEqyN2SH65OtHX7uSzDuQnXq7ubFb1nhcf1zCg4fcTL+05BHGe0AJnTVgLJ17G4H7edilM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: iCCNvYGxN2pVvz0Jzwi0r_J5C5rAdaqE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX98sk2mtkJgOB
 VZAohQkadrHUupNJPzZ8mSRnWPjdyRYcDYB2Gp0KfUH2pHlb6+DKkFV15V1M/0bO9qmsRRqytbj
 e8tRauMplkPDiQMtA5nifSlL6Z4qrlgJ/D/fj7Kmt5eaUNjgvltTgV6luc5M/fqYp7A0xBztB4c
 k+iy1Luow7W2YdfH09PK8mfT3dymvuOCO7C9EU1KTZsv32QtSVql3L4ZrmdXbsFWGpGrrJdiYje
 uc/Cp9O2nxLXrVoGy+CpSDYzf/81md2GFhyhxbMZwi6COjHEdECNMMmQ1rNGvQCS5jvoUed4Fdv
 dq+3UtjQpVoZJoxJGkElM2FTQlHcJ3+D7/YiMrWrb10iUc6kaWpROZTodxSuyAMnwnhIDYi/iei
 GTNJW+kqiLQRZDS0+IDwWi2lApzUiKfGase+lVEgUDkyheHP3hSUVYJnx95d2zJu5QYjmOUtwk1
 h05Xz/lmYD2rTrlLHiQ==
X-Proofpoint-GUID: iCCNvYGxN2pVvz0Jzwi0r_J5C5rAdaqE
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c27 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=X31tx7l4y37eYe5q7xUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

A few ID register fields must be skipped both during writeback to KVM
and during safe-rule validation:

-  ID_AA64PFR0.GIC and ID_PFR1.GIC are owned by KVM's vGIC device:
   when QEMU creates KVM_DEV_TYPE_ARM_VGIC_V3, the kernel sets GIC=IMP
   in the VM's ID registers. named CPU model should not tamper with this
   field. Hence, skip this fields during writeback and during
   validation.
-  Skip ID_DFR0.PMU when the field is not writable on the host, since
   KVM populates it even for AArch64-only guests but does not expose it
   as writable.
 - ID_AA64DFR0_EL1.DebugVer (COPDBG) is always skipped because KVM
   refuses writes of 0. Without this, realizing a model that does not
   support AArch32 guests on a host that does support them fails.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.c | 47 +++++++++++++++++++++++++++++++++++++++++
 target/arm/cpu-idregs.h |  8 +++++++
 target/arm/kvm.c        | 23 ++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 84e1d8d9f1..91bb899571 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -307,3 +307,50 @@ ret:
 
     return true;
 }
+
+bool arm_field_is_writable(ArmFieldIdx field)
+{
+    uint64_t field_mask = arm_get_field_mask(field);
+
+    return (arm_idregs[ARM_FIELD_REG(field)].writable_mask & field_mask)
+           == field_mask;
+}
+
+bool arm_field_skip_writeback_always(ArmFieldIdx field)
+{
+    /*
+     * GIC is handled gic-version property, and the values are fabricated
+     * by KVM when the device is created. Skip writeback always.
+     *
+     * KVM does not allow writing 0 to COPDBG, this leads to an error
+     * when trying to boot model on hosts that supports Aarch32.
+     * So, skip writeback always for COPDBG for now.
+     */
+    return field == ARM_FIELD_ID_AA64PFR0_GIC
+            || field == ARM_FIELD_ID_PFR1_GIC
+            || field == ARM_FIELD_ID_DFR0_COPDBG;
+}
+
+bool arm_field_skip_writeback_if_not_writable(ArmFieldIdx field)
+{
+    /*
+     * Even for an AArch64 guest, KVM writes ARM_FIELD_ID_DFR0_PMU.
+     * Furthermore, they are not exposed as writable fields on fully
+     * AArch64 hosts. So, we skip writing them back to KVM if the field
+     * is not writable on host.
+     */
+    return field == ARM_FIELD_ID_DFR0_PMU;
+}
+
+uint64_t arm_get_field_mask(ArmFieldIdx field)
+{
+    uint64_t field_mask;
+
+    if (ARM_FIELD_LENGTH(field) == 64) {
+        field_mask = UINT64_MAX;
+    } else {
+        field_mask = ((1ULL << ARM_FIELD_LENGTH(field)) - 1)
+                          << ARM_FIELD_SHIFT(field);
+    }
+    return field_mask;
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index c2ee82597e..51cc5ec341 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -96,4 +96,12 @@ bool arm_idregs_validate_safe_rule(ARMCPU *cpu,
 bool arm_field_check_val_safe(ArmFieldIdx field, uint64_t val,
     const ARMISARegisters *host_isar);
 
+bool arm_field_is_writable(ArmFieldIdx field);
+
+bool arm_field_skip_writeback_always(ArmFieldIdx field);
+
+bool arm_field_skip_writeback_if_not_writable(ArmFieldIdx field);
+
+uint64_t arm_get_field_mask(ArmFieldIdx field);
+
 #endif /* CPU_IDREGS_H */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index a12fa7571f..cf6087d337 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1225,6 +1225,29 @@ static void kvm_arm_writeback_idregs(ARMCPU *cpu)
             continue;
         }
 
+        /*
+         * Skips fields not to be written back.
+         */
+        for (int j = 0; j < arm_idregs[i].fields_count; j++) {
+            ArmFieldIdx field = arm_idregs[i].fields[j].idx;
+
+            if (arm_field_skip_writeback_always(field)) {
+                diff &= ~arm_get_field_mask(field);
+                writable_mask &= ~arm_get_field_mask(field);
+                continue;
+            }
+
+            if (arm_field_is_writable(field)) {
+                continue;
+            }
+
+            if (arm_field_skip_writeback_if_not_writable(field)) {
+                diff &= ~arm_get_field_mask(field);
+                writable_mask &= ~arm_get_field_mask(field);
+                continue;
+            }
+        }
+
         if (diff & ~writable_mask) {
             warn_report("%s: non-writable bits differ: "
                         "kvm=0x%016" PRIx64
-- 
2.52.0

