Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD4F3C5856
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237993; cv=fail; b=MB4p4Pknoi4MaR25WOaZ0L0GNh3zp8SwPcbpftAYc3pPVDfg28FcpSiRF7TrjKpg2rlxsKHAQM+1/jrcdXoOdTXIzsv9IwEY0aqz7rtCDErv7a1Bd6i5CDSYQaQsQhgO9qUwvhweAk487+kF8GZ9xacuj+ki+Z7bqXKI0Pq7mXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237993; c=relaxed/simple;
	bh=PhrhKqDYfbWXyPnyHPWDRFjqjFCFTuU938huEWwkOI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oywRbTJl6p8eCis2OpHlw+XJTPzWQwnoMvjDG0o7pDQ81fNEy+qWZc2AhI4HRMTU+R8XdaskjFj2/FMPAF7i1XyksVfXPhndpDBWk3F8Gm1CtOhVX9LMewyx9DUfEKEtLQOt+r1Xz8bXFZVKFCeIaBexxH/IEXC8m9jGebhxHGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=W31InYLn; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MWwE5vS7; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="W31InYLn";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MWwE5vS7"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhk1763910;
	Thu, 16 Jul 2026 14:39:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=WUaL4fQjodm13B7bXBr9+5hJ+WRfVgk2LSsQ3TYc4
	fk=; b=W31InYLneNvbMnhUr0UfrENtEdUI2VZWB6/QFe3Alv1FJwGpCJp36ENs+
	k8ukfsZRzuQwdnWVxEYCUc6ifpsuzLVBJWWLm3tdQsUAjpehh2weA1zB1nsD1LRP
	0RdzUnOzBmwfyj8DmipZ9b0JMb9GUMtDXVpc98Z7GGynEcZlegTx2NbXpZJnpZ4/
	bnpdyYy6G8s0PzofxTkC2iPRXjqJ5xS7eNrwGwplepkJ494qHPGQ4+qr9Hp8xNKK
	7/3N9NiQr7UR0t/4cm9rtYPqQ283FcBgjtOiesJ6jv8Q8BsHjzr1Rwy/fB9yt7Xt
	l9u61fuIqib9w7OItRvc5GEp5lyIw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5glpijjaWrE7dipTaqs3y9/S3+BlTCWyKCkpORPZQQJMHh3SGbH1+FX97aN0NxF09qDzs277w4t9BT+xaPPMim2ddFvdEgP4DJmZIhEMI2PxWUwB9024eVsWjYopQI6t5RwHPYYge3MiqwJgrcvi3xrWX3OCix4m7ZgNOOVTOJ8P0M1zk9ZRiYawyb7/PK3LBHOuNXwHbHCF0PIgXv/PxMkM3IRvIDqjp0iVufq/sNnDOtbDRID0uWQ6CHXHQQNl4QWdr8zOfHEQGSvgRibqthMPaUEvRFyDPznXVIJPFDVve9OayxAGKLk/UB8njH7ffzU+kmvQpnLHw0Ireu09g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUaL4fQjodm13B7bXBr9+5hJ+WRfVgk2LSsQ3TYc4fk=;
 b=tk8tqTUTxxua1ojC8icBOEGcM2zTeUOLowlVavjWbLNycAb6X7sdrO3TM90VDJBtRx7B/NIdsuiSKFGTdS0Jv2WxT5kmyKhbkfykMkci8dun1K28EpnC32b4lkOSv60xuiRWAZqk4evqibeQfb0xiJ8bDPVKvDqeGxQ+cRfb3z4uo4ucE8Iz87DIHIYRk0vMOvjiHDEXIa/drGy65+4T8fgYhzS2ndYi4K+W63jNl5tOzwm8JKlW31P/XoTJE162kMOXVHjg1J0S2g+p5WiBJXCbyOCO4X/ujtHW1rP/eoaHfYny9wk7rsaLQ0LyFN+ayU+LSSCd4cGiM4/1VzvSUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUaL4fQjodm13B7bXBr9+5hJ+WRfVgk2LSsQ3TYc4fk=;
 b=MWwE5vS7vaUeT8k3G+fVK7Q3AasL8mIFVNS+4mq9KCJW0BK7HDvkKrsDHIY6y0MikAZnznbe/8IlCbch/ZFsOMig8LzxXBIedRh6hT2eOEWXdfSFGhjTLOUDI9u2rD0Z5PDEgM7AW3l4hISfASR1PKpHlXfDAoh3PpquMEVKlEZ6KPmDFQyXnEvi1S+mjpoPGbL5cLQKcwx7BFaDNqvL+mGLa2GKSd7IG983oLMzwTAmr7XvVvGmE3mGSjkRC0+RG5edKcaiZuF48+LELNxApZgQ9L2Tnrkq0iGOXwLMmzqU/tMrzUJ3cKSrUyECIcv70DRJvHDMLXuZEKiirBPgJQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:27 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:27 +0000
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
Subject: [RFC PATCH v3 01/19] target/arm/sysreg: regenerate cpu-sysregs.h.inc
Date: Thu, 16 Jul 2026 21:38:40 +0000
Message-ID: <20260716213858.609699-2-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: ea55fedc-391b-4a49-6ef4-08dee382b629
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	QlfYDDlxBNn2yot15h+rqdvq1YyZbW376Yn8Cg/mWWcNwCsOlFMDSzTDMI++z2TVKs8gxzyQ2gMoArwFz0izWnSevHmOGHmmyEzB5V8GS7NaXa3EVwlad6rJI7s14ZXIou07fKTEmfHkFWS4DfnNQ1I04PbsVdjA7/acZUzXx7tD3gNTZnQajLwCUdzJqE7ZZRaSCYLlLh8Xkmti4VzAqy5sTdSAwh2S9qV342Nqk1QA/59Xnp1QDc2iwm03xEkm5gz8PpWVcvpGF45v8psCmRlBXnuYMng9IRB9TyQm5s14dgRdrTteqCeV3cGu8Wf7Xm+mG9GrsiY6s9Rz14inwBqZ6U+38kmD9PKIBDdPVo20XrTXPmdXD3UskGbes1rqzwPfngXD82CMnrelHPjRvySaouahUOAnkgERPGy6Vz68FI69Rq7wMnCH+a4/J03UAPtb5UBGK+oX0a2vJMOl9Dlu38dnd0PVsVN+YByfjxjOtWVyFQB9FoPvTN9ALz3znlP31F9USQcbQCIA28nj7D6PhAwhuGl5k8npiz4bA3Anu8wpPTD2M5Gm66Wg7ir3r3GI24siGvbFcS7loocSUL3NnTkVZ8xW0Ky0xdCjGurFfsAKFMCU8DDuALvS1DqAy7lhyShVFY0nd+HcMnI5nGrnBFmO85U3HwLsA2SwAJY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0de5V2bwvvP06u3QToGTg3M5zLk1B5EmbhXcr01kFjTV1DCHrtWrCloJvU8/?=
 =?us-ascii?Q?ZfB0aoMLohF4pw3gdgKO4su5bwyzfWDWsVgPUpwhl0VlTaI/KgfWSI4xjP6h?=
 =?us-ascii?Q?II2/6Z0RvS1aULnxXkOb/OqBBLUn+zRZahz/jiq8osnQuhH+tbLeZdeR/z/d?=
 =?us-ascii?Q?ukEdSdcDY0DaXb8drS9zC/PDVh8EJVOSKunWgdxj2YZHKbXdLZvJSEGLk7tO?=
 =?us-ascii?Q?0Cc0Nw0K59qDIGkQz3potyt05bMg3goxtAA275wFVb8FgiY0YOL+9ZjlIy0z?=
 =?us-ascii?Q?/NjLRnoSOhHI7jdsHm4hQoXKuIX2gsvQfxGgXwfY/9XHkgmjY/GeLA+l28qj?=
 =?us-ascii?Q?KHDEtsJ+g72Pmu1XYV4Y+qwYBKp1dmji2l+TwBhqnJQZwi2b0DsZ+Vx1r2xz?=
 =?us-ascii?Q?E7UVfR+RNUz77lP4fYRnn60oaN0SH0wR7oag4cMnFIsXkyohRjwNif9ZCDx8?=
 =?us-ascii?Q?xf42kXfh5JfsGhg19+qoIe/Pg2rxRFXkP6lQPrGBZjcgeP1quKwEiuOMDKzn?=
 =?us-ascii?Q?1WGnMlvMbmhCz690xSWgbPRPzd4dpL1ZZai43wiRyUwsIklDE6vUSkjNtUuu?=
 =?us-ascii?Q?TVj7lU4y2yLo5haPUpY5XD8cbXyUV1k2VA+sui4SqXi49ivbvNCh+wBQVv4W?=
 =?us-ascii?Q?RnObRWSIMvRgZ4cX9Yo5iOtytp/uiV1DDZhd2aGLv66+JMok2ks1QIVsvm3P?=
 =?us-ascii?Q?khj1QC4WOYHlbxue9rw7fpy1by4+jI0pqFmReyMu/qraUGrhlEVAh7EqphNK?=
 =?us-ascii?Q?d0TFD64U0MMx11Z4/IJeh7Puo6kIbT383tzbbTTZ/+OuRF3UWXjc5fcfN/M/?=
 =?us-ascii?Q?q9CnuWDZN+k0y8/yCZicFcIvG9AgI+gbLscMOC70LYnepy8vHie0cKlFKZdG?=
 =?us-ascii?Q?XtjiMNzTdKRh7liRa0Ukk/0LW5JhY+EUyx7DCvfupi20zYvWI+wHDbmth7Pg?=
 =?us-ascii?Q?ygmO0At7klf+bacTH0tbwtbOLFFQZxja0HIxbfw7fa8rm3UYbSDF+rCuRc/i?=
 =?us-ascii?Q?OZIAS+0V1ac0yyrU3OeF7gLRbEFOsXE/2U975aRrsTPuL21mozwrk8EG7Hic?=
 =?us-ascii?Q?iZLW0lu3oq+rX5HoPuRx2/8qigRBvHPrO/kwUPYnqUudfIcQ+QKHymNK6Q1j?=
 =?us-ascii?Q?YBEsj7dbwqhRbJPs/FUeU0rTL9JpwWiJUUjRENfXpglfvZt57ls/aStS097Z?=
 =?us-ascii?Q?ehOtLWaCCSs9daOkvMswUjn4LP25GnozcL5IqbSbD5v6L7QTWvLPLOYgCMXQ?=
 =?us-ascii?Q?GRm+XXH85QLjBKFjawOza5p9Bsmrgz5b4nysw0DPVVHbsRESn1pm2kOzf00T?=
 =?us-ascii?Q?iKH3EEINy6ehwpeVLcNvthE1puPsKrQkicjdJ5S6bj48W0z9/dZK7Y/hQSLa?=
 =?us-ascii?Q?6Qu1jdU3yYdLvClIgh32ZG/pmJQpZVktRSWtIkZaPgr2Y8+5ugyD6s2OPKgW?=
 =?us-ascii?Q?Hh0L/swX6b2hg3q7zHsNL81iggXOjlTm+6Rnyb2OnGYc+Lf7euAIf46Wm0X2?=
 =?us-ascii?Q?0GOggQzgheOFW+uRGN2B9VcrHhSvjJEkLwd1gVlmny3Yx9kNdMSzy6EtyT0+?=
 =?us-ascii?Q?1yA/Znfb1oqjLOT+2tfL/bUNA+sG+yFCq1MWw/AAKLXXx+wgdVLt1Y62c4yj?=
 =?us-ascii?Q?NtTWfqxygioft2OpDGisDHAJ+Q+qPZpStZbXTbeB9DB+vM/mJRKQ2PXNJ9Ac?=
 =?us-ascii?Q?xw3wgR+ll5XZpFpr4t41sEU3u03Gf4NZq8zJtQ32DvnZ6lmQv1fx3TQcBLEv?=
 =?us-ascii?Q?IP/kaF2wrdPe8rQTed/hTWZgeU4bINM=3D?=
X-Exchange-RoutingPolicyChecked:
	bmwIsd62FMdq2keSgjdA98ldaiAkrAXgqkitGXrxUlXv5Hyr8/+4ghlAoNWHP/BKJ08jKPB6afTnrTvk2OX8Cz7cCl8c/wCrWL485zU1zBrNzi7fqrQqVSLHDsWph4W/BIewZxhkZQQCSb+eBgFENbSH8to9FfohxOGf5cwcg9h34y6iEmQhYjsvgv+EG9oE07wsfMf4+cAaYldKpVWRym8PBhAU+n2bKbLHZoQjZay2Y9B37B76USel8iZvONdtp18ovY5eMCm256QJYgIUBOf0vFUux5h4UpCakPb7NeYIhBh8K/1z2dNa7eUjR/56Dov+drAGRLnDTDIpDfICzw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea55fedc-391b-4a49-6ef4-08dee382b629
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:27.6315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haqnln94GPlYdRXS1HHEM+W8PfCKtZxurF6CL3lqc/1vk0KD5qnfingCVEoXz7GCIcWQUPI6/Qf1nodtYNGCKefjy95Eo2Ek8uwn6qV8IU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX5MTUdkW5ZGqR
 mvM9ns76XXbhkb/nDQtIrRr3S3RgHjznwbyIb3nrLHHLLYe+hUozVVKPj/5YW/nqX1E9NafWDxA
 6BdZx+rbqHSBz0NlROPtJGiPaopvtUnmN5vs8ZQEZoQNMtl2wBRertAJH4h+pD8OENsTlCS3ys8
 1mt8wwFzWxBZjxfHwn4s+U9O0SKawtgitGtdYx/XD85OOAOckyRbaAy4xPIw0eU9XJJPsyBVwqr
 Uuk6X+Sor528ksEF5TE2TG8d7Czq/ZyIKfvFgPeEdamEqyCTQx7CSy6ERpV1Z24TgixEgww0Epz
 +Ld7aOtYdIVg+z4FYqd3IigCKoKgE4HChkVRHDF9IElyoShWCsA+oqaq7lKZOMZ+p43b4sXS65+
 aeZX3HtcKMv33F8e9evPCsSA1er6OL89xxUsfc3p8pVJB928xdmvao/TNtub5fr0m4q+O+hV/kM
 NCNME2vN9jcd1ZT9+KQ==
X-Proofpoint-GUID: Uhe_ukFgIxE2s2_6ZkoZi4oTp1oMfGhI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX+9m1Dxhml+jx
 SyfcHFQQU5D8116uBO+kN777GPDfdKyoztaenHCO+hhoIywD28C+75DfwVxPp72za8CRHL0N05O
 jubd5ez2Lo4G3F/yzvVm4PwY95Cu2yU=
X-Proofpoint-ORIG-GUID: Uhe_ukFgIxE2s2_6ZkoZi4oTp1oMfGhI
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f93 cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=vBEc4jnpDwqIhEWvTNgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-sysregs.h.inc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index 05f558610b..2188cd7be0 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -19,6 +19,7 @@ DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
 DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
 DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
 DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
+DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
 DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
 DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
 DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
-- 
2.52.0

