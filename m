Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCB9222590
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237993; cv=fail; b=CWsl3S/Cs4LGIz7Z6acYMBPaz89Aq5BKhmAFkKq2Mz+qcFyR/jzP8d2vZCycGjU4vNRk+CyrmTROKXGCI5Nv7b6JoiBQTabmPynOCwpcXSoi0mXXE1jt9TWfVnACUt8Vhj5glPhjCa960J7GSefwf1xv4EG6J3GgTEw/ldPl8n0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237993; c=relaxed/simple;
	bh=M6uKSYMvXS1ndLl2Hk1bh1MPImkbzmrvxZktC75Bkkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kI3sxbW01IyMRFLeojf640H1zazvJASva/armPKTz1RSQBibgEYb8mJiWVX23v+/H7I71334s5eD9nc2NfI49AsDi6z9KahtRTzJX3Spu+2Isz0fKsXc/kZzEbXn4bDVIYNTC3gaMLNUzuea2ao5nVuff0I/pNVXLJTTqp6Uf6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=lXDBAkSF; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ktPIgh54; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="lXDBAkSF";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ktPIgh54"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhx1763910;
	Thu, 16 Jul 2026 14:39:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=l40yKmzpFsOgmksblSn+/sDdXmg8rL/P/2KbeRBl7
	i8=; b=lXDBAkSFkbGNrSZP3r12man8bU8lg6gS0ulr1K0U6Hc25qLRjr5ZAy+iQ
	7qdlmwFJyBayh/7dFdjGv4o7PuGnOUwdk2XM82CI5CLZhHCDM/8XNNWOztlLs5PF
	psRrr/qi1pTNGStUi0r73DcBEmknZTyCwyGubtzU4iykqnODahRuAJT43lSD7IJi
	fkE8s9VHhwQ8jMFN5Zc7/WIjyMjVbRBLbww46aFI8+hTRcfa5SUo7IXwuBu95guR
	0EY2QWbE7sDN3Th/SWgNybIskw+7FmQp0aV8MzCwTxI/uIjHF2Y4kyP0RupONaKT
	ZCg3HjTd6fazRIDiTYGwpkFg5kagw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-15
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u3KZqggxoX5EyfICI+MPSrkAl/eSnB3YZr6ZZ4lLOYQyS0EMeP+B4tmrL8lon04/T5nCkPlDQ/k31+x+updJhpsUiIHYt76XQcyedqNHGxz+GuioQTfUQ3E7MyBF5ePnWFkFRxxmXw159JdcPuohj4I5ufp4ScASen7tXWVIQ2pBOzu5VMpqC22Q2pfg2bknBruXQS2aZh7Ljcw76fw6altkyD+QfB/cvW98oM48u+V/z0ER8xG2K3ie3SAhkgmmut9QXO+w/xfRuwlvsvlIgbfkogQneKtqLiAhW+O2JMi8SJlML1EgqUZsvIHPlyyYx57uKcFV0OuXU0e9zo+M4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l40yKmzpFsOgmksblSn+/sDdXmg8rL/P/2KbeRBl7i8=;
 b=Dz7mV5BccEhbQJQdrgYjh9IxGCk4fqNnAajZ+mYDzTYcdvicNNdX6BPeS/izPRsi1hryYR1H08g1R4EYtSA9HBZnIKGGgfD9D7c+RLaNVb6hVpcSiWTMOm4A0gisK0EV+wy2DyyceQTKaz1dA8WLGtGERgKZlKrITHeGEl7Ukp0uft/lEnsVu0Th6Wv5TTS4aoref8MORfL8F+yctrykZaqNSg8QF0RXIdMALzHAa5P53MN9Lrw5d9y/c/zhc2g8CTnwvIX9GZGRGR7bswk0C8+w2mMNnvfQjsKzfXv/3BWSolA3eYg6ZHH7QawSDDLGFMDvKGamAYPvCtXDynT1vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l40yKmzpFsOgmksblSn+/sDdXmg8rL/P/2KbeRBl7i8=;
 b=ktPIgh54dm6XbOWVQvdUKely1O5+/Mo/fzUdzF28SHAKCm2V+kJB03ehzYln6rLidKOqf7S61sezJ240fEGjaZGnzDBP5NQYu5EUHX0NDke67KMha2TElVgd6HnRAx+C2Tih/Bh2dCMLoU23uAg8RLibWzZqNuvF+k2rnpNl5BWnr1034cqsxbmdLZsPUmueRUfV+b3+6KchqrD3OgYvEmBruhbaH1b+A5eoK+O08fc3GpPzCd3x5OfVNygiV06IXvdSb29ElNL0r/9uRlr4keBkeqmK3mtOjirDEpCJ3wkV8PoxZlJiu9Gt8ZePzTEn4JT27TVJgDfnx0NgbQHOKw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:38 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:38 +0000
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
Subject: [RFC PATCH v3 14/19] target/arm/kvm: compute supported values for ID register fields
Date: Thu, 16 Jul 2026 21:38:53 +0000
Message-ID: <20260716213858.609699-15-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 23e48c58-66c7-4306-1185-08dee382bc8e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|22082099003|18002099003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	6MVI9dUGDreb4pfFqFK/zptPbAFOTYyK31QR/cel3NmRCmnLxMtvJSiCLKKcAIX8tOxIIlRelA4AMSYp7J4MnLXtT03Y1vNzWA6PFR//ua9dGTeAnTpzXcKMzuKU8JflQ6oslBLxVU3Q1Knl7sb7OUGE8C7LLfRjO9Zpy15eogLpZF1j0cJWc1+fq5XLOJT/NqLVSf9G6SPcIbGJLYF5ZOrkh5/c0Hiosg8dlmtLbWLITY+Uj5ayS3uq2INNMWH4dqzPcuRYeYhLIFJs/Y/2kB0e7OzBGqEj7kSf5sZl3uaI9UQxDMO1Q9/LF9bZaoupHFNjXMqjg32xz+fpD/k8P9qWx1pWeZ39vqoFqjvnIGlR3sHirKPfCNNSRE4Ew2ggH3UG3JEO+hJ48os5+JRC6ERYtrks+adMHi2I3I5winX8dQujNDFHM15tH5C/L6j7vrDaEqXwSnWu3n12+gVxAjAAu9b6Krxtm9mobR9C0/TeThZHiptCBfATUGrruQ2KD2Ivqvj5nd0ojTMasGLiWFOa24tWMoou+ujlfIt6iZZ3jyHV5ez5YfY4+rEigVr7lEQOpnUg1dVXQloOt0BqL2MKz6zcp4ue4u1FJr1jl15SN3USVGcLEWZYQ4nCupXPrIj7hxM4CFLe3ZAPM9XZQo8D/+b0OPflFtZKQ8U6e1w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XntrbqSzG7DpwKoTeml7K/Z9HKRiuWTM9VapRDoe+AYZzYvdPH0W80vvdSV3?=
 =?us-ascii?Q?ScyWMFbaGZQMiwzQRFoXbyzbQ8/PW81mp3uyImgGiAzlNyNwdjBv0/S4ZJUT?=
 =?us-ascii?Q?qTwnJ0A/mtk5eGV8e6IRmDJBGHjb1H6KKM/AF4q2IXq8C9hK/Qkcakg8QY/7?=
 =?us-ascii?Q?+A+tpESRwLq5t2Ihl1ToeeDY381eR4dcoW/iZBg/1weroKDQJ5xAYkJTi+ra?=
 =?us-ascii?Q?27mmXFxlZzEiSSYNh/jp0c7WzP/ibNlpLhZ189PZ/wpUD6bmJsnak9070hBl?=
 =?us-ascii?Q?cBbInhCNT5mvvFa42pulik5+fqhaXvvn5Rv2lsggSzyiCK1TCYpk/3W2x7u3?=
 =?us-ascii?Q?cAVS0eeqoilpwYtCQWDd/vN/vrRoWsIQiVidXQoSytJGWZrF1ZP19KtG+kDt?=
 =?us-ascii?Q?kTIWEkfjT7gHZrKLUyK0lcFULM7lKB6XHohZdYmC5zz1M7mP+gihOcPdF2DS?=
 =?us-ascii?Q?0UHUUs7n2GYFduBzEG3nCNfKJssbdZnatPE6EbaNzgn2yFES0+HGI2yDcFmz?=
 =?us-ascii?Q?+RvzYWRfPCDTe7qgeU3CclE9YY4GgyG3kXvejyg5s8wTqbjL3ZiRhIrO04rA?=
 =?us-ascii?Q?Gq1ZQVdxyKd59X4pULlT6gqGuwaKBuM25fwcQdiuzBT8NVRpnOj6vyMVa/6O?=
 =?us-ascii?Q?NBgfrNxHHtGyn/kXpFNLSqF4Xi8aVKXZ0UzlDxrBxlJkW/K4A1IVPuQg1SxD?=
 =?us-ascii?Q?Dy/TFIA414ofkK+lsmchD2rXDEZ0LbopLn5CAUZhTPPEq60OnkijZHI6mQ+a?=
 =?us-ascii?Q?9XumtQLcu5iRkDRatvTCVwhkaCGb053ZTQiPa9KvqOHUbA6P0QOWTCJosJn0?=
 =?us-ascii?Q?xyKnjNyLOPB+J9P/dE+KH2ZY/7nF9x7twwFxPAoeewBZu8cYSw0GwjIeWxv9?=
 =?us-ascii?Q?AJMEmCBSQpz6Ol67JNVnHaP7GcruxVYL0saKJVpEoRqj5hISu9GKOWRj+Btl?=
 =?us-ascii?Q?oQyqKpPlMmSo+F8/a8fggIW4wgYtQk5Qf4ZjUzqcKHZ/DgPkFXo19ZiGkW6y?=
 =?us-ascii?Q?Q+tLAxAfWhPTPd4bPlL6CD2b5J3SJttt1EZkXoEMIJ4tF5Q42yMQtbK1uz6k?=
 =?us-ascii?Q?awvFbp6YcmLctFEjK1RVTHI0LgRU1LBC8wDq7lrK4bE0VKsorHkV8jTHcsOF?=
 =?us-ascii?Q?C4QpRfRhUBpUNsfmoQGb34x2dzKbvV6WCY8NsL2sA8bbmsohp972YxRrRmHL?=
 =?us-ascii?Q?nTuh5kFqHCCw3BTnocDn+u3EBhF7j+33JID0x80rAZ4/JQw1WtMpAVz/i4E4?=
 =?us-ascii?Q?nMJJNdKatholf69veO6mwGOCc1yzugczgRFmulS4eiU1SOQY+pbJKeabd5Zg?=
 =?us-ascii?Q?uohkHsW4dZdE5oEdU6kfQYIytTIfVokRusThN0OAuWEfVxTmMWwbX+8aHMmC?=
 =?us-ascii?Q?T+u5JMupuGBtVmuqvxTTdgU8QkWM9Aa5VfZV03PIsoVLFv+yxzJ+SnsF5Q7T?=
 =?us-ascii?Q?xJuyTajEZNi8z3Rj6FPouD3eeXrqJzCHNF6mC1eVCtgMcvNFgVEw2xx9KcAR?=
 =?us-ascii?Q?mPW9GDPoh2/1gaB2XYlRx2d0yNwgK0zk7Frtz+sbySoUluP/aCZS1sR5q2gs?=
 =?us-ascii?Q?ooeChYyl4wsMKQMEcPawcn8fLYbexF+yQxbKpO2Q/ZujjDgzSA/2F3lwrHNp?=
 =?us-ascii?Q?zs2zK0yBAIwJLzyBi+lm9/kggT8b7ZZQp+A0ZeiKzDxVB46DNl5e1m7SlLk3?=
 =?us-ascii?Q?ldC2mvfCvBQTP5lXdZLJXkQVc+6uy8z8oOr8XPnxToqy+5EKO9qXETldYkTY?=
 =?us-ascii?Q?1gPkIfYLoYmNMo0bLYFH8T8Ue1gjeV8=3D?=
X-Exchange-RoutingPolicyChecked:
	S9bfwSjBs/TOy3tWc+2D4nqrxPb2u734Y2tCAQQutIcP2FjF07Mdkx9pdUyI9XYfl2xsmhYSKFKlbFLxYbCZQUabAjSi9NMMjzLewmeBo8i2GXb81ijhZYeqRc6YOz/osnzlGv58jxNtaKc4BJrMyIka+wfAGWBtfFiIEByPjTrNX6DZT1TTHq8fT2XFeR7fCJl6QotI6+RCc6dJ62+N+MIVV6PmOeWwTq4BsBJfYxIjLnIiUeOcH5Btsqx0Ml7HEyhvWrtb0YnE1ORQAxqzLu1Q1W6Bf2hapyKOUI4gy4VUZF7NbHbokh1N7Uvm6VtQvVdNW776OZ4MjGP1Yc4SfQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e48c58-66c7-4306-1185-08dee382bc8e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:38.3014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BxymFdOOBKmOgjz3ZtQjTl7p6Wuktd/Yr+Yvx7DeEoMNTi6+7EHcMCTxXpbiHvqNvG9A1/TMbHlcvySecQ5QSEAqBNDGkve79w1fYYAlLAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXw9WifxsCGxQo
 AncthxjSPpYDuUiV+F81cl1lvQrqjmZsHPm+T05dJr4boVXb280nVLgBhcozknOg2L5mtCuTWhz
 2/jEufMv4roEfkOOg56j3FosR9HHKuJ4Z9250VrqU39GtE4WFUduBy3wjhyfXL3hMUQzaTPbbvQ
 fAOSdWdHPnB9vjfngKkfYjIlhOksQa/IYjcRSEb8raeftaBk9/sGuG6Vtzm/WmG82edy8QprEqw
 wpcsnPDlJLMrv+0gCVFtpeU+gijvMdCAQuXsNfBrvMIglh4GTSIbX04OZBRN0r8JsuI7+ttfvTk
 hxFnnCc82eHow1kbPb5PSzuZl0FnjGXlz2d4TVze9VDXPasa9lJSe5PXdfERNIpXOqaVJqS0hQv
 QCtCTJjfimFx3nIw2zQiH6CxXvhZ94d/hOZSir7nNSl9+m19SoypPymMz19bViRrw/GNqsQjNId
 5rhE4aDhnMoPicXRuiA==
X-Proofpoint-GUID: bu5V4dZU4Md101aBbc-1kVaooStgif84
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX4L/3BG28p6FR
 k9L6qPu6006gwwcP4TBT7hvGW4xUqZfwhTvMY1MU4IvHN7BcCir36ztERk63yuJBBjsMDdz4acp
 ZyonjcG14vhNvueE7OppKd3xElAZLrY=
X-Proofpoint-ORIG-GUID: bu5V4dZU4Md101aBbc-1kVaooStgif84
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f9e cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=OCaCFsDeaxsKZUiNNdYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add arm_field_get_supported_values() which, for a given ID register
field, builds the set of values KVM allows it to take on the live host.

Non-writable fields are pinned to the host value. Writable fields follow
their per field constraints. This function likely needs change when
KVM starts exposing a new writable field that is not lower-safe, hence,
the special handling of TGranX_2/SpecSEI/L1Ip/MIDR/REVIDR/AIDR.

Cross-field constraints are not modelled; for example ID_AA64ZFR0_EL1
is gated by SVE. Reproducing every inter-field dependency in QEMU
would only duplicate KVM's logic and drift out of sync with it.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c     | 99 ++++++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h | 26 ++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c38b99cfce..8f452f9570 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1262,6 +1262,105 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+static bool arm_field_is_signed(const ARM64SysRegField *field)
+{
+    return field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4")    ||
+           field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64")   ||
+           field_matches(field, ID_MMFR0_EL1_IDX, "InnerShr")      ||
+           field_matches(field, ID_MMFR0_EL1_IDX, "OuterShr")      ||
+           field_matches(field, ID_AA64DFR0_EL1_IDX, "DoubleLock") ||
+           field_matches(field, ID_AA64DFR0_EL1_IDX, "PMUVer")     ||
+           field_matches(field, ID_DFR0_EL1_IDX, "PerfMon")        ||
+           field_matches(field, ID_AA64PFR1_EL1_IDX, "MTE_frac")   ||
+           field_matches(field, ID_AA64MMFR4_EL1_IDX, "E2H0")      ||
+           field_matches(field, ID_DFR1_EL1_IDX, "MTPMU")          ||
+           field_matches(field, ID_AA64PFR0_EL1_IDX, "FP")         ||
+           field_matches(field, ID_AA64PFR0_EL1_IDX, "AdvSIMD");
+}
+
+static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
+{
+    ArmFieldRange r = { .min = min, .max = max };
+    g_array_append_val(ranges, r);
+}
+
+void arm_field_get_supported_values(const ARM64SysRegField *field,
+                                    const ARMISARegisters *host_isar,
+                                    ArmFieldValueSet **value_set)
+{
+    bool is_signed = arm_field_is_signed(field);
+    uint64_t host = extract64(host_isar->idregs[field->index],
+                              field->shift, field->length);
+    GArray *ranges = g_array_new(false, false, sizeof(ArmFieldRange));
+
+    /* A non-writable field can only ever hold the host value. */
+    if (!arm_field_is_writable(field)) {
+        ranges_add(ranges, host, host);
+        goto done;
+    }
+
+    if (field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4_2")  ||
+        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran16_2") ||
+        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64_2")) {
+        /* Either support the host value or the "off" value */
+        ranges_add(ranges, host, host);
+        if (host != 1) { /* 1 = "off" */
+            ranges_add(ranges, 1, 1);
+        }
+    } else if (field_matches(field, CTR_EL0_IDX, "L1Ip")) {
+        /* Only safe to downgrade to VIPT, other values are reserved. */
+        ranges_add(ranges, host, host);
+        if (host != 2) { /* 2 = "VIPT" */
+            ranges_add(ranges, 2, 2);
+        }
+    } else if (field_matches(field, ID_AA64MMFR1_EL1_IDX, "SpecSEI") ||
+               field_matches(field, ID_MMFR4_EL1_IDX, "SpecSEI")) {
+        /* It is safe to upgrade SpecSEI to 1, other values are reserved. */
+        ranges_add(ranges, host, host);
+        if (host != 1) {
+            ranges_add(ranges, 1, 1);
+        }
+    } else if (field->index == MIDR_EL1_IDX ||
+               field->index == REVIDR_EL1_IDX ||
+               field->index == AIDR_EL1_IDX) {
+        /*
+         * No restriction on value that can be set for implementation ID
+         * registers fields.
+         */
+        uint64_t max = 0;
+        if (field->length == 64) {
+            max = ~0ULL;
+        } else {
+            max = (1ULL << field->length) - 1;
+        }
+        ranges_add(ranges, 0, max);
+    } else {
+        /*
+         * After handling the special cases, other writable fields are
+         * either lower-safe or signed lower-safe.
+         */
+        if (field->arch_vals_count) {
+            for (uint32_t i = 0; i < field->arch_vals_count; i++) {
+                uint64_t av = field->arch_vals[i].value;
+                int64_t v = is_signed ?
+                    sextract64(av, 0, field->length) : (int64_t)av;
+                int64_t hv = is_signed ?
+                    sextract64(host, 0, field->length) : (int64_t)host;
+                if (v <= hv) {
+                    ranges_add(ranges, av, av);
+                }
+            }
+        } else {
+            g_assert(!is_signed); /* No signed field with no arch vals */
+            ranges_add(ranges, 0, host);
+        }
+    }
+done:
+    *value_set = g_new0(ArmFieldValueSet, 1);
+    (*value_set)->n_ranges = ranges->len;
+    (*value_set)->ranges = (ArmFieldRange *)g_array_free(ranges, false);
+}
+
 static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
 {
     /*
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 133a026036..9f15c91c4e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -143,6 +143,32 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
 
 typedef struct ARM64SysReg ARM64SysReg;
+typedef struct ARM64SysRegField ARM64SysRegField;
+typedef struct ARMISARegisters ARMISARegisters;
+
+typedef struct ArmFieldRange {
+    uint64_t min;
+    uint64_t max;
+} ArmFieldRange;
+
+typedef struct ArmFieldValueSet {
+    ArmFieldRange *ranges;
+    size_t n_ranges;
+} ArmFieldValueSet;
+
+/**
+ * arm_field_get_supported_values:
+ * @field: The field to get the supported values for
+ * @host_isar: The host ISAR registers
+ * @value_set: The set of supported values for the @field
+ *
+ * Will be allocated and filled in with the supported values for the @field
+ * based on the host_isar and whether the field is writable or not.
+ * The caller must free the value_set.
+ */
+void arm_field_get_supported_values(const ARM64SysRegField *field,
+                                    const ARMISARegisters *host_isar,
+                                    ArmFieldValueSet **value_set);
 
 /**
  * kvm_arm_steal_time_finalize:
-- 
2.52.0

