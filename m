Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B723C8728
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237995; cv=fail; b=IfTzr/PXf0YeyN5BsxGLBtoADNRwEZcaXdUhsyjws//Mt2P5JsN/JTUx9XSMiQWU84VL717CrAq1mo4AONgPEXelt362WRycjsPgku0pnfPCIVxbr4QfXNej0gNMpgPtsLpwKp1CQpOqFvYNbrk/O2Aatom/WOxK11W6Nft27Mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237995; c=relaxed/simple;
	bh=XKdaU1Emi7dd6EhtAFIIHzGLZzmtkG73yJcxQmRvB1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X+N92qg2rDhiwrCWwllfvcphjRNdL1B4DOr6LaN8NdEZ36wpz/C8QE3eVIsD1i6A1Lw4aAYOaqb+QprOm3Jh+1zwMMR9yVsEaHr8/2e6ub2/GqPiC+44VDtikeM4OpcmeR9rPcAdOrVoXvu9cUoHCxdYZtILkt3vIcP+HR5VEEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=VH2/pmjt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SSgLdDI2; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="VH2/pmjt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SSgLdDI2"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhu1763910;
	Thu, 16 Jul 2026 14:39:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=iPcIqtbm+gxtoZLi5394cvDU3dNNV45DKiCEzY0vF
	uk=; b=VH2/pmjt4eitsXKIygFUIWLOYrqeUIsGQKV8mlJkaEssfGcJANdrHWyLg
	ssEemBYHb3S4YxbBCmGPITOy1K/kK+zYtR39IFB4Ep9AFjtgN0CbbRhRx7J3D9M4
	jqUPF00xH/mPPXnPBVw+rEhGHMnanuHUe0clBJJeoMd5grTNpYlijP0m67HvtkZ+
	WNbStmrWV6DqV76CnptLqzXr9+f3xM/JM5GHTc8CvDStbitvvwSNGPzIwRGYSWWC
	qT4qAzlrwBQHLAfRfqQfozcrtsyYnS1huOFpxe6z/C1ea8gCbrQSSqOYMxBoLjN0
	jEFoZL3hsYTR+FC2OsZMTygmQ5LpA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-12
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D23Pz3q5b0dK91Dr/yQs0N1oo/XadYX2wTsMDIKHLPxHRUfWTpzd0QVDhvtAgrlOsbKOR3HO4e1rx/AEQpNXd8bvMKO53Mwv4MVzLJWMytRLjve3NrUe5ZEGrnWRHdxxq1Q2VJ+hLp+KlL57vn4TxndTFaA2RcC15WlkqeGLA78CvLBDdKB/7jSHp+0e4W70OS4Edj8/Gr4TgjH2ddJHkjsNcr5SWo1K0+/NHjStz0T52xV6CTuy+PAKDCnpqn1og8Q8ork1KR8P0OGO3O91vYuZaP7sYN/b7Ugf20HSAKgp5NPLcZhtdburoOKXEDm0p27Bos+q3nHF5uQ8UhMBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPcIqtbm+gxtoZLi5394cvDU3dNNV45DKiCEzY0vFuk=;
 b=KJaO44yQmARD2bMZK6n9w/xHpZ41JHKUpiHk97Sz9L51Zc9k80bfpFm9cTU3AjVG8cfeU5I69Y05qiS8pd1QNP0dPhmNT6cWPD0IFMg/qQN3hDyz02jvkAZ0Q8Mi2CFNu0ifmV0ssl1BOD8Z+0b3XqkvTKTS30NcWgaM3690u147vSrpPkbiiIuS5seJnl8WPk4ab9tY7WjSwtJube6qP1RZtA582sWd/PuMCnVVVewVJXqg9A2IIFHGzM9ATIX+6/fOkXOMmgy7C7+DnSYAFoG7OIfOVHNxhhZg/SL1fwc6GMyWxcyIfemLj1mi7LHUU9pfpHmxLrcfT44zx+FLxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPcIqtbm+gxtoZLi5394cvDU3dNNV45DKiCEzY0vFuk=;
 b=SSgLdDI2xIVVjb2HRuyDNygPv7n2FS8iZbSi+q1OxWVqmLx6qZfYfI4L6L/mFEfZO/wE/6yYEZlNGBay6gFmg2RRfMIG+tK4pGO1DeqVAeZZcCl8GTVZbpqzBVGndNzFtdazJE+c8I7cCRT0FzwC0hOy2Pi8L7Z19veVqomEUgSq0MXcvJPujy6RC0C62RVGsEwMC6KIpYj8XSxHtikUHEsFjVmOXdZAl3JEl4WRG+aJLHxhRcrIZYGVbWWBBVxNin6QaY58Uiodb/SBiGwPEeKA3ljlAty+UconkGFxNDNt9aiXxQeswRoKSTmBhuue+Pbh3cXWx8E35FdA/noEcQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:35 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:35 +0000
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
Subject: [RFC PATCH v3 11/19] target/arm: fix sve and pauth finalize for named cpu models
Date: Thu, 16 Jul 2026 21:38:50 +0000
Message-ID: <20260716213858.609699-12-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: b4a2aec5-1644-41d0-eea3-08dee382bb01
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|22082099003|18002099003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	3c50ubuQtQUdnsRy105WSYPaB18oJZKtFajTLaX27jPv/tc9t0y623jxYEq5jQLpfbgMlpD/lExWiHEy32sHpS73evnSGFCBLKFQ9/ikBCicTsQyNwO1CQnvHP7ZZ3eZdaYmd2RG/Tu6v2mSSTP4DDsOHBEPbywfRRKTI/EZraQ+6tZRphD01iOmCyJsYmJbmpvbp8eGOPc2MG/4l7Am4EiB+63AzANnpcCkBRT2LcHG+aBxFHoxjvkIVICwtDQZHBR9r71ymsLrCAMtMVuFiaWfdxd8JST75AokdOyAQTgnjN4HA07rpjoyaYhJHFQ5nr00J2BmfvTr/lw9xBgzA3WKh+EJ+/Q0EzBuYeZxWVJ9oGk5V05MjcBFOJUiOmHruAxs26p48gumErtPwH7T+39Tn+ANnGqkdNINg47ck1p3IUapr8XMGAt9LyuPLoP/lu/LcsL2+iBATQ1Hx8gXVgpoyDlwd2cGBjNKgG3TwVIAYLXu+0pC8D2FmhW/f5e9oTvFjHwMPzC8RM7SDrVVv/bV8s/h6+bjjCqM0zsRXxrhcFQs25xOhy6NNzGz9ubvn3g/hqcG7CdHaKADE0ZiXxTdjXKYDWcOPu0nH+8D6h+M9s6kZerPQrQBA5YaQlbgj8ygYWdaBiNTb9ODSzAPwsf21e7ADpLNy3w2NzeVMAM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zq31EFaPl2thHhH32I/37r66Eyt1tNeQshO4y2iFKmHd0zjvUArTeMCUzzYQ?=
 =?us-ascii?Q?H6Y2U0Eh0nF15a+4FaYFEnHevQVKhvthpYOdRyNhd/oqjLh46kcjQPclBr25?=
 =?us-ascii?Q?HO1n2YiLVbICPe6xIXEgTsLNFcDCkikfsnvbEChYSpiTLJGZfCAGuWbcBwfv?=
 =?us-ascii?Q?mMQ7KzId8FBjLbjioK8cuDIvHFV4g5pgV414NDQYhUP28bb0jksvw3gJohKe?=
 =?us-ascii?Q?xeFo5goBxp71hx9HJ7VxLkPAbKJufKkFQNDrYUMoDZ6sEFjAEpwwvNAqZSvA?=
 =?us-ascii?Q?qy9gJEjzkNOv5uFMUdvzjo1A09+AoulS/xwXACpNQC8xPtZtWurElgQGv3e+?=
 =?us-ascii?Q?1gvyP6o8SkzM+7CtewEewVx5+R2TK+x/Yq97FNDQItI+ym5QN589AyqOb3pA?=
 =?us-ascii?Q?5TtwugfpvlFL5AqvGPvQCsBdNYz+DsCkiKvK0DPrVOCTIB6yZ4UF8k96Whja?=
 =?us-ascii?Q?Qljfu5zb8RHB/awf8aNl1HFqrvSJ7lqNBgAutFzPc+FXmAeRS3RCTlc53jDS?=
 =?us-ascii?Q?uClUfbwak55jaspSsqS804znBrsDDgcZsYDjBbH13F1PiZDMEGxdOS+iKDXi?=
 =?us-ascii?Q?X4xF3LzzsOTahS4qBR7kRhrsow1mEtWDKHMw7EZR7fk0lbNOq3khwcrzv21z?=
 =?us-ascii?Q?ikvSnzqKb44jsEbc4VIdvnZUAh+n27OGtxcIW4yCTDeOzFZRa4F+Aiq7SyxI?=
 =?us-ascii?Q?xTfi7XdSl4/MoS7kEs7jkVtc9rVNPkxmIhUHG4a78608rO/Fzhz9cx3BHSbk?=
 =?us-ascii?Q?71CKNIinkIZ60Q/m5IH/iSTc1gYy1+h+os4gv9+Ul+AKkEJyzsld6NaNejzx?=
 =?us-ascii?Q?Lz0gBDDCMMRJRvmrW7AS+Ms0GfVcXnyUtLQva6L5aht09pawLIcFKFWMuP32?=
 =?us-ascii?Q?k5JjqF0DGDWHZVAdP8gsKM7vhKb4vMustsWvt2XLiyOt/6rbr8BuhmtA05M8?=
 =?us-ascii?Q?CFCI7IiVVH4Og2Du7u9u3hLKUWBcKdPrHJL5ZM/JUCUWip3PkCNUFrS5mLP7?=
 =?us-ascii?Q?F3/pvzbnsLpi7cykRID9nVue3D0LRPBvqahHXI8m3yhgwShxgrZ/khuSN+eT?=
 =?us-ascii?Q?zA3a/gY7oiqKmX/1iPUlzom5F1iuGCr7hv70SgSCglyeWeD/tGMvsd+q0ko8?=
 =?us-ascii?Q?kXHAjMZZcDgYhkIlBB/5gOuiyCvE6NaJVqJksvNpvN8Ln+p/+4rOerMHe786?=
 =?us-ascii?Q?RVZ7OiVEHE9TYkWYcY6rxB8pE7c4pg5BV9BlOwg1alPufTe6adCT8ka9xm70?=
 =?us-ascii?Q?so03XNAi/zTf9LLF71bCCI6t4vNNCqf5XwNIDUuYoqd2VvOKosortkSKohA/?=
 =?us-ascii?Q?qNhOh7aB+EajfZ9X/TeG3cVSyFZKhVr7yoEaYV75b1DBhK/NyIgLv4wPlgYN?=
 =?us-ascii?Q?Qh9wBS3/KT30mdrkEp2pitojgkq8a1XU4J2dKgeMTP950R0XRox2t8Pj8g0D?=
 =?us-ascii?Q?Pz5V5WNkf7q83kQ9mW/3Kb1wvPZ4/0vP7zXWwaVAqetyGEWVU01HRkuvrne1?=
 =?us-ascii?Q?P+jQij5eZsH6hfgeu1ZloYZEzYSl8zbryxxmwURcFcv7hmfzr6176C8k2RT9?=
 =?us-ascii?Q?MSXvmtk5VIUwbgWWdA40Q0qGF4u5Scu+Ghwv6CLRhJTIRthLGfDxrmcPxoif?=
 =?us-ascii?Q?zEYKi/ROuDpk1XWVqShuUlPlk+IM2g11DqNsdQxXr80/Pdb5LojXKG0HkRG3?=
 =?us-ascii?Q?Jq8xeapTcVlT8o+AyJXhKVWNaxFHW3ihLz9sBqO61RNjTHn74TjM5eEUR+iu?=
 =?us-ascii?Q?yNqMJPNGZlPxbCk7jY88hGLCt/8WZHg=3D?=
X-Exchange-RoutingPolicyChecked:
	gsl0UnfUKDlRvFvICR0AXRA4KAeGpcPSTnDdXJ3O6MH8cBOU0C3ECLA357LwQFDNPNPTk4EXM3+/BIRaG1DRZUEEIrLtQSNazvmz4ZQW0IdeBU/QuHb468ixX75Awaqjv8s3hPNY943aiNqpgn0vBluO287DqRHVDrQxDIqdtLs0IXt8oQlrvmBTrSHxAc2psI+9gNAgLTxOE/2N6khmhoDdprxq2i6O4dDt9pQiSXu6+9W+eSaaaHkArznQ4oWHBKUyj7HIeQAzWbn0cVpIB8HrD+bgqHcxq65T2fcmRghlfIRjGT3KfuRThjuPfYQLcX74asxYWIw1d/gKsLZwlA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a2aec5-1644-41d0-eea3-08dee382bb01
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:35.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8C6hZSfUU39Fptvr2bpxLOe8p0wwSIzy2rBBtfzEPQQzUVv07/cdS88fTCt78xnlxISCpSNfARxp361ahZTCSJlf+wrSRCi3YMjiJxjSn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXyjIKM5TgPYKk
 OB3g9Xic/SQnDMrCIFhJPvNsJiVrZRi2cQb1SL2vwI4Ii1AD8Da/fChkmtcOx2LMq34tD3nSkW3
 A8dZXa46MvuyG0tXoC4aRcBzMtoNt/ne9+2veeU7pQGPiefjqdliWNydqX1gn2ciEWqMfTFDrFZ
 a0yPu+BxQVXf1j+0FXp9wMsKXlef1cLgddD1UWufGPp/6NfzCJAPw9BgMjne8HyBdvDNuvcGRj2
 vnopZyHfCFxVjM42/vvaSGba3MpmBhkuL0+DKDw7HDu7+I5eRZHO2YYpWSSCU72fvXwhvgtYYyP
 VnxUc7fU7YUTz6tMJoHD5f/iiTW/AcQPbt2C6qQ7xU7poza8ZvzJ0Wy9JgQxfQVG7rFteJOVVd7
 A1wlqqecJPi3oscJ9TgmGImDp14kNpY/wGpTlYWFVsu9AnbIdq2+twO6hg7MtxizPogJ/zV00wt
 KT6t0OQQDMVvgN5/1TQ==
X-Proofpoint-GUID: HKesBllUhlx-5k52Eq96uUG-rwoipC3v
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX5/zLsyatyVcx
 82F1vJM4J5L1yqO9h5138mtw3K56bkxKT1aOHCpxlJqImJwd6vuzivKRvLi4At+zpT6R2cuIUwn
 HDUeZvt5pxGPQ+mIT0DhyrOC+MpbKEE=
X-Proofpoint-ORIG-GUID: HKesBllUhlx-5k52Eq96uUG-rwoipC3v
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f9c cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=eaKVySaVM5pmrxNhKe0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Named models provide authoritative ID-register values, so don't derive
SVE vector lengths or pauth fields from the host; require explicit SVE
lengths and leave the model's pauth fields intact.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu64.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index cdad0fc46d..44dd9acf80 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -38,6 +38,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpu-idregs.h"
+#include "arm-cpu-models.h"
 #include "trace.h"
 
 /* convert between <register>_IDX and SYS_<register> */
@@ -134,6 +135,20 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
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
+                error_setg(errp,
+                           "Named CPU models with SVE must set vector lengths");
+                return;
+            }
+        }
+
         if (kvm_enabled()) {
             /* Disabling a supported length disables all larger lengths. */
             tmp = vq_init & vq_supported;
@@ -556,6 +571,20 @@ void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
     ARMISARegisters *isar = &cpu->isar;
     uint64_t isar1, isar2;
 
+    /*
+     * For named CPU models the model props write the authoritative
+     * APA/API/APA3/GPA/GPI/GPA3 values directly into cpu->isar, so do not
+     * override them here. Since other code relies on cpu->prop_pauth,
+     * mirror the resulting pauth state into prop_pauth.
+     */
+    {
+        ARMCPUClass *acc = ARM_CPU_GET_CLASS(cpu);
+        if (acc->info && arm_find_model(acc->info->name)) {
+            cpu->prop_pauth = cpu_isar_feature(aa64_pauth, cpu);
+            return;
+        }
+    }
+
     /*
      * These properties enable or disable Pauth as a whole, or change
      * the pauth algorithm, but do not change the set of features that
-- 
2.52.0

