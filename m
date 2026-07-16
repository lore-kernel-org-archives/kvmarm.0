Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336563C8C5E
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237998; cv=fail; b=OlAxbSs7JwIf7U9DQEWvYn5mkdZw426QJdkS+8jST7GXMTwGzBaqWyNH2kxdS5uY4Msgd3RvFbPQtDwMUKGTEaPojZ/5MZ89CzevIhdYFmQazCYLRYFrl5bX3QThF4F3VBuWZ4H9mKa0KtH30Wp3OkQ0/stK4qQh6UuY9fSG/c4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237998; c=relaxed/simple;
	bh=olGan7KyMstV8qIcYziOB7l+eKOyEMZMx/kvO2NldZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AB7+cMSDWrycQNTQ7N5Nb3kYrUXCF2qqLMOmm5BSs0qB4buauGjBnAar8wVloJiBlMZJkqlToxAjEYuIBlcs+m0l0/KJfRjy5DZtL6KAMKZvF1uvgMccCK/STJv+GAhJh3je/Id71cylSbeCBW5l5Ua2vYbw41XM9Mpm9ONyY0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=H04rHcz6; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sQ9nqVhl; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="H04rHcz6";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sQ9nqVhl"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhv1763910;
	Thu, 16 Jul 2026 14:39:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=VMhDcyLwcWYgXwlNQSCNXQ1ej0CSVdQfpxrpdbgme
	0c=; b=H04rHcz6y4sxEYUo26a6dcrmSn2CdaewNfFIGYzV7DFSNoy3S6ZQ4OQls
	8aMy4LspwKrPNQmKXRyOdqGR2X4T2ZAvIUZUmeW+3BUnPjymxtQLuyC3BbdPCo8c
	fjcv8RkvqsszLFJnOzNmEF/oyoki/+jFve5AfQtMTgp4N3Q8KCHxlwGjjHcrAESU
	wKLyTh4DiB5qxUkIB5p1CcAqsLrl5iJmg26lnfMd31aIrRULV2kzLPWsX/4CAYfu
	Tt48i6uxhNySX0BGmZtouivT9XE7mEuVkaDT9Tfpjc4pJ/RrqYlCMQj6+z4N4bGv
	KGW5oinAyHJotwDpGMYY6IYjObytw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-13
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLcdB9v6uS64yg7nsVaeYS8AA+WNVwJWbAFrjYKvmBXbzgNJtbR+O8GtNCxYrMbDlGul5OM01ci1SwbhZtbN74fZJm2fMRIwNJWU726gCdGkKQtBurU9UdulKkSP8ihefyiaCyq/uQ+9JhxKWXmJQbVgpZXQFbm6ow8dIRp4mEpezE8T+Hw+FOfuskEUeNqFCMCUr4VtIDN6n3eYzdclcZzTFJ9PlIe33eLNX+hFLalqKIdl9bcWoASV4pkQhyyqg3PigyPxcjgVt8xL00gOGrNk84aP9t1i8nkTs/YLB8VYnkaQe0sK3zUu74Ylbx75oCEL0pNGSLVh3n6dRzUjYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMhDcyLwcWYgXwlNQSCNXQ1ej0CSVdQfpxrpdbgme0c=;
 b=nqR1YV3Wf0bjaJQNCo+BlrfKFWDs5vs6fQpgF8eW6R22Dd98CECl10/7ejkShw6ZfkkmnXVNVctAN5opvmGuKsuT3GtJdHZ5sUNjV0Ku9ON0IjNWubnojd8WGmF0v0e6uzmbWar6u4toc+OszsZ0EAH9TU6Q2edbp/XpWcL6NkJc2bZiF/eUiAxDHZkYdiYdMWegJHP063bQsfmq2LHDi2vS96SiiDhIzzHsVGRRvRMkcRRq7wc9eq58cvwzTAGjFJidKNtiviPr3SI8A7F5PbkAvaBWIhQ0LeKqUVX6ZVyKuzXmOMdvwyi3wegDKrRT4g+Q5UOWSJoUw7AtHGdOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMhDcyLwcWYgXwlNQSCNXQ1ej0CSVdQfpxrpdbgme0c=;
 b=sQ9nqVhlvULNqRsjHaE0YA3App5pl4fbIWcMQD8MOvpjJZgCkhlAbJovNu3y7X6pdXpeFQX9iOiooCKH8NB/bph3E5A95XMY+9C/hdtj2K42dsXjGEha96DRW0YfGJ+XtlyT4ikASVzb6uvGlAV7OmURvvQhavKjJqlRGox4PLSP/fyx2Bbhd5GTJxm3+QfTPC2b6AkDXhvyIf20vmH3XaunXa4Sply5VpIMqVetgW9sklAaEyArZxGAVIyBeCHxFyAIW4+sXggNNOGrtwqAXiC6/BztZATcTT89go5tEP5TtxBYUJQiLd4czYj0zBYZRa71eqDCozUyo7V4HkqtQQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:36 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:36 +0000
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
Subject: [RFC PATCH v3 12/19] target/arm: Introduce stub files required for qmp support
Date: Thu, 16 Jul 2026 21:38:51 +0000
Message-ID: <20260716213858.609699-13-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: fc6820c7-4404-4410-f382-08dee382bb7a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	N2/+0OQDwWeymWMtmoFX0kFINFKeeyx0LQlq4egw0qO2z2X+38eWLBL7HZzfTLMyhdzJVclwEYbmcV+1tmZbb7U/IvT2qN4Z8+L9OkUp2pdLglPwN9ugyXY6Gz6WFYXDvP8WuTWy+nslnVv8n0kJAhxWy1o0N2ioO6VZJKCs/xk4VtRPr9i1d3LtTX8hB6KkZq9TzOQvXfiqvPJHODnjHIVHA8iT143WwjBxFBz/ZLsVVpNKUEdpyDYwH0JYUuh+xken/1u/WgAVaoi1G1TPR5uZtKcvV8Bf5U+1iEx3tGRHmSV8zA5jqdX1tNtuTBNTiLu6x+yuFdnbIk6Kl33ntYx/XSQz83QiVf7cGRYJc2u9RyFqe4jXMpRX1ajrXDQYCbWHuwrru/00dcLMlt4c0lIyuPrSTACZROCCvXHq+LOJE5rWLPRHLK4lH/6rZcJO47X2W0Q/QrJti0TxsYURwinY3reyvRAE0l126GYO3R25k7u4JcHFeSk6m4cjsGQFlTxGWPiobiWx3sd/2xtUHUQbOLGcKW7iTA/f8OACTf8dhJy0ouaMBCv2+tUWCQU1uCeCsTj0KsWE8HLs8wo0HtefstNbx9bRuP79i5jwcyUBfu1y/wxMxjNRodRWc1UITXlwuxBn+jjzPtNy9yrTuzlmkqwfXLBeIUbkuaG8wVk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?co71M9Pd1k0KPdo+Usbh8TVQ6lUYDZzhdh1yOZ91vjNkugHzBYFmIcF6I42O?=
 =?us-ascii?Q?0sGgsaM1z7+SiMOCfXRm4VFuCzdROTQbNpzAyyFC4KOrphRD8DrnXy5fDwMz?=
 =?us-ascii?Q?tHLhqeVPMzrgix4kq4OHU17QLEA/PjGaUEm9rm7DlFgBbVdG+bcIIJQnzJ31?=
 =?us-ascii?Q?erpnXpep2SXxQiyXzPrMeh2xOiIPvMwwqUOUOrZ6y9OAMCFNCLmZ5avHICmN?=
 =?us-ascii?Q?oHInWuvdxJpw9E5iKdYGGjYGL/V+HE+1DZIMl3+pFM7sj0L4I1GEUHLZNFqB?=
 =?us-ascii?Q?RAm+M6DPV+pqujo3DiBPnFbIBK8T3IMiWBeiezOiQ13sQNV9IVfV5mbMgCBX?=
 =?us-ascii?Q?yy8fta4GlhIiXIKaD+ouQjVPCa1X6JncXjQ9LTjech0xH/QmIy+5xX5g4Bp1?=
 =?us-ascii?Q?zi0/pkVjlKJYZvYfvq7nT5l5GWmf8fcADgckGYwrp04GOgr2dfRm+hpnf+aP?=
 =?us-ascii?Q?qaz3VmStB5MH3EJszyczi5tqNfxYN5ZO6mdwpHcrEImHJTcGLMQUM0iSnUmo?=
 =?us-ascii?Q?BbWjxSn5rQBN0BEJW1FSCVQv68x5nF9LzNGXAktVFdSnUyjmuLf561ky+53C?=
 =?us-ascii?Q?uOAoRNRDWGeL19T6/ZZQ/Ta4ygd9JtXgwJiy5wLzbXjK0f7NQd7cB0BEVU7m?=
 =?us-ascii?Q?xkkChavm0gHNmtIyum+f2sWI0+nJ7o6wqOwhxTpUazf8BW78MbMu+P/puYnt?=
 =?us-ascii?Q?7O8efn8skCBgR8F+yKFL5XcUi0f4LYS2UFRGa6LSDE2e7Ue5v3IHoIs2LSY2?=
 =?us-ascii?Q?D8blFNHDXomhOERzEz4kyYSGxE5YlaLIPea1pG5RbmASHob8fy4e7XCy/Fzk?=
 =?us-ascii?Q?iPTyFw88wVwES4doiUXwMVkQHY0vTnlU9c/+HQ7cfY+FFGV60jPU71Nhc3n5?=
 =?us-ascii?Q?+7uIvAL/X0OURHmFuFISfZsUY9gNab9xLnwwInwicgND/wddH/+ghfhDKL9g?=
 =?us-ascii?Q?wQDjbLdPsXKx+TeB8xbM5ruFBi7ZFY4nljyZgcIETprU4CetJAHxb7oGWV43?=
 =?us-ascii?Q?qLgFB03+1AWIu2dTCM2DEFHuWSwEJecppnujXdpemz6Gtb+lFNclPj8CNvl/?=
 =?us-ascii?Q?2rFSPCegEAP/5+uKiHKZOqBj/SFoaxZCe/A0zN/sd4gEOqiKT/0FWVOew8T7?=
 =?us-ascii?Q?veyScfHzbJcgF5E3vPMB23SCwyPqMbcXZyduBUn17a4kNP0vkX3Lb+lwGByH?=
 =?us-ascii?Q?lPgwFdaYP/ELW+wIpvBm9JyEKwGKXY+Nbl2vzl9L0n90zpIFJS1/xACQoeeB?=
 =?us-ascii?Q?oBo+FkdwuwKEQGZ08wj33mE9ETCWUPpROJIPUhkbI6Hqo9OGImzKQIIOZ3i+?=
 =?us-ascii?Q?oFA+3lXOLYWmwa3SRIIzATmbbDmTa+p4bwNz64pkgVsbDxJBF2U5q8CxBbrb?=
 =?us-ascii?Q?xCv4pCAkeKoZu2uEC5RseBW4xEjwRMNcoVN4vWDvgzUymTM4xESiNDkNQx9n?=
 =?us-ascii?Q?orI3ZW5NWtTHblILtUjmrjo5YfqWDY4bN8j6uhwnv0UQfNAkiKGZzl9V52Ua?=
 =?us-ascii?Q?73aORcjpnpehFSaEGRWT/eB1SRipPbTHY+edxAYF40vkKtESjFyNnjngDkPA?=
 =?us-ascii?Q?CeNkxT4Bu0HM7ezBb9JynMRT+pYA8Z+GvLCDCEAFnSOB0/X5yeSH4v2WU1yt?=
 =?us-ascii?Q?FRaN9GTMjYhRLvvxFMvP4xt0u3Wqh21lC+SdWljVfeUUWtGtxkTkWYqV+hKQ?=
 =?us-ascii?Q?6QBmIMruxrgiv7MMcsMTnCUhOhWN/GJz8vKA69guOSttxNTaDbrulk763nAc?=
 =?us-ascii?Q?0Ok7oX18V7kNVplZBuauoA1SSrlw2L0=3D?=
X-Exchange-RoutingPolicyChecked:
	R/WB08/HCJEgAWoWLVSs1TavIdkbravbTFHwXBkQmgfyz6NJhe/GHjao2y+SHGmZaBMiGIT0JQjDq8hQL4wVUP9Zhjn6Mp3GL59emQW/QqgbtSAZ1aKp6POHFej/JtBQ71SBrgrSMMMIdzqlwfZu/gX6wZWNgUu0F6QDdSDpbv0bUiRM901NlRR2qo1LTLVGHPumEfwFTpQ2f+BJ0PEj2k3gaobO+RntBlhQO1H13ViISc3vTunHlxwVnU998RadvPFb8+23GLgfIBfoO0eqXfYITmFHsqxdzAGhTPRC83WV6q/XSwfrIo4uTZIMbXSbokwW2p/bV3KfoBBCNArYqw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6820c7-4404-4410-f382-08dee382bb7a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:36.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8w+iF17VT+1v+7O/5oly/3CVBJaqtrq33REe6cpHte7HBmQtQelx7Tj8VM5tLTsufnqPVhhMzNvf2pDzIbv1LfGvsYbLiqNCS5xb3u9LNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX7UOCDVQhGCxA
 qJlSbw/O0s3UCypM770iZfQcCFDwQ83tbJT6TZY4WUF74D08aJhp1xyD27zDcMWVYnHaUXcMF1F
 3D7fJL2M2FuJNrFf0zse5cZW0wR+1BG771RYBcfe/PunnPLqq3R3e8c6xkeCCC1HW2yGGffUKWi
 EW6JvW8AeeGjbFmvxIZhaFI8HWJNAPFluGKNbJTQPQFfsGd+28/B81CDNfjOLPKsK1qsfnv3LaG
 MHf7kx/yv574cvxxwYaSVpic352olay4t+SMduJMJLgkFmhUSWkRrOqb+PCU1OkPMRZyU0ryfuH
 uNleBi263U1j/5oYTJgZYpfFfY0ps96FC6GxHXceeT3f700sUCOweIWkE1pR0UJebJtb/HbGQYk
 FiHRLrgTXJwyiiPCADRsYyzsfPJyEsTKSGiCdJb9VUCWEFFmqYvUpihe1g8Ke/ahW9lfHwrE7f9
 E8nHiA7YRBV2K9T7Xbg==
X-Proofpoint-GUID: 3V4cla5NtvF-q2HUagsPBwz7xDTecgt9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXztKP6NVx+EAo
 AlKJYpl82Hi37g5FEb4YBNMyBnQWRVLrkjmpXJhG1Csx7zzuY6EN2dWWnjc6akjRCqGikA/4QT3
 GYKn1HUdcJZJd2TPSGZx6L26lRLKSvQ=
X-Proofpoint-ORIG-GUID: 3V4cla5NtvF-q2HUagsPBwz7xDTecgt9
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f9d cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=OFCXbkOoVZKaM_sWDjYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add arm-cpu-models-stub.c, which will be required to add qmp support.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models-stub.c | 13 +++++++++++++
 target/arm/meson.build           |  3 ++-
 2 files changed, 15 insertions(+), 1 deletion(-)
 create mode 100644 target/arm/arm-cpu-models-stub.c

diff --git a/target/arm/arm-cpu-models-stub.c b/target/arm/arm-cpu-models-stub.c
new file mode 100644
index 0000000000..0481f0f946
--- /dev/null
+++ b/target/arm/arm-cpu-models-stub.c
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM named CPU model definitions - stub implementation.
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "arm-cpu-models.h"
+
+
+const ArmNamedCpuModel *arm_find_model(const char *name)
+{
+    return NULL;
+}
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 72eed1bcc6..d7b4cdc5c8 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -21,7 +21,8 @@ arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
   'cpu-idregs.c',
 ))
-arm_system_ss.add(when: 'TARGET_AARCH64', if_true: files('arm-cpu-models.c'))
+arm_system_ss.add(when: 'TARGET_AARCH64', if_true: files('arm-cpu-models.c'),
+                  if_false: files('arm-cpu-models-stub.c'))
 arm_system_ss.add(when: 'CONFIG_KVM',
                   if_true: files('hyp_gdbstub.c',
                                  'kvm.c'))
-- 
2.52.0

