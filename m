Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D2F2147F9
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995903; cv=fail; b=EUt38fH4vzspRNwZVfLEbC3P1+zN+NFh67oVTCnsRTVU3NhnnjPGR0X6zywChd/X8iAvcAwSjP00gxnxygxphn+I9qcqKA8wlHSEBOE2HDHhv4ylxPyXqO6oAzAuKk2vrC2d8f5Gf8BaLPqVLFktxGTkOom8eHr9Yt9Uc6DVkNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995903; c=relaxed/simple;
	bh=AETgwQgJbs9iWvBOkWxbvVYBochfs+KlW0reEAPTvbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s2e//wRL/WbsTuM0GvZS42Onw9ZMEzFUXg8zhOAmJ2EQFsQVQJWQj1hQOeeWlaBcxnKyyPhsozLUz/qQkqf5cS/Xi9HAKV8RQCBrTzb7y3J65eJTFIGH7UnzO84hx1kGMPTUvawPvbdEwa3dmZ+q1w12vY9BQX8K6mtFSrGKorM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ylnI691F; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DfaHgp1J; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ylnI691F";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DfaHgp1J"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAflUF774316;
	Mon, 21 Sep 2026 05:33:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=1QkE2ncrQk6eQs5nEd9oT6uG1HxpCiiGZ+Azdxrfd
	/U=; b=ylnI691FzpmI3JJd0OEuWHeTkvP+d+/xueQV6iqwLFpduFFxano6gpHZN
	fH1oCEF+pY1XXqszQ29mJXpSS0kunAKtYrrNsh2dwPdzFXT/kUfwmnL+Hs8eNXFu
	anlr8TqG+LCdo7rpqjGBKlo2N8j86e7wLAXJU6+kJQi0xG+2scdwogMR9ECF6Meh
	FtojF0lWk6mHP23wyXxDM7hQZq0KRrgvW5FRbuInyWxkg3p6gA2v+o56yHtQK3Nv
	sX+UFNog9LQIdRU6ZTqg8qv5pNa8j0GCtSTeMxcTzBxrDdF2sxCaX8IWCuH6e3iU
	IGio8M43qlnLNKe8tNHtR2FQrfsaA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021115.outbound.protection.outlook.com [52.101.57.115])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gsqx831cb-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k18KDiSw3lgWkflc/RiNSuQ2wIDqLamPH0Im+1kRQHEgr0TXqXYn7f2KUcTnp/l4QhW+OTgWARm8OcwuHsArkuNUZcr1+1OPHFzFyxIxOkpDxcIUFCt2+vT+Nm4qB8m5uaX11fp0OSpT/YDFIvtSmFqJZ1E/2eeWiHSeq1ftPlNIma0G2xhq9Kt0GNZwOqk3heBI6MdKgx62zTdKtGY0XXR3bO1p/wvgIKCw2k3RP7HYGj7WUuvhqpNEmmGM/aG3LNbO9JKP9F/Kh+74ER1+FXlI7ZMnC9jGtoCuqlbcy3RdN7Koe4sNnTrGL83hiq/7CbXA5VZEPevQ25NABXSfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QkE2ncrQk6eQs5nEd9oT6uG1HxpCiiGZ+Azdxrfd/U=;
 b=m7ulg7+OKG7ViyCclfyQP6UBOajiJ5iWyTd1YCBvlzMjJ99YBw5OesH0iU+n3XKHL9wj0TC/mNIQzi1pGKTYc7DZFogdv8TOQVRWVOmpdRdcFVP/onqwr5JkgVVOPf4xF+SZEQ8/Kamvcg00ZIczlME/oyCiOiUDfWNrHRM0LE/Lqsh0bAKbNK1/4RyggqMsV0JdKLIY+K5SuhbLj5OyQ21oeUmwOSU7Eg9fMiESX1vKouN6RhOizDpSVTwYC+WvNpCmuS7FVmmk6/OZ81olaHFhDIo7r7DuJiB1P0FmnOdoPwCcB9L13NeGZTSFpdROLWGo4WALDIs0PGLTi+zctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QkE2ncrQk6eQs5nEd9oT6uG1HxpCiiGZ+Azdxrfd/U=;
 b=DfaHgp1JYh1VLSywjQgdFgVCE3g9v/hXnWwOvmH+EUuFpn3AGGi8+fZA03414576R4fOkLrK7Qnixtx2qm4L56Zp5J7hLp2Ool8NIl+SffqU8Zl8BkOTeaIgsdm9MhsZeuXHI/08RuddotnWXmoPO8bokcZul8U04XGIkbbx6ViOrheJpHZblqtUaXMySYkxrM+WatAd/E7MZNrj4Pafm194rwdw69AOf+3hMBedrKIsK623sH3Mu4u6SwNbhEgmBJ2IQgu66OBsWck3kmiRPd+sH5Gaawhah8L90XVZvT6gBe9GsL96ttiSrVTqdPnVRGihtxiDpeQQIFSGdrWNPA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:28 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:28 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        ping@khushitshah.com, sandesh.patel@nutanix.com
Subject: [RFC PATCH v4 09/25] target/arm: introduce named CPU model infrastructure
Date: Mon, 21 Sep 2026 12:32:33 +0000
Message-ID: <20260921123249.1708067-10-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330D.namprd07.prod.outlook.com
 (2603:10b6:518:1::1c) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 18cd3d5f-ec5e-435f-b41d-08df17dc89f6
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|3023799007|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	N8B6Agh1OGlouseKzUlH2TVOdtzRz0Gljb6SwI9L/WM4qaVq9Gw7bow+FE3WeMcgkF4PS8nMihob1dzKNpFGvEJ6sFLLMxXoIhnJpBEE9vy75OzushfO/T0nftIfGfIPhWA1IXpnVUYWiff8TBODgSkH0F1qSEGSaSFKFIMdAdXBC7G9Sq887YdvsEx4VFkOH6ERaFArFl3BClxOwWv0c07/vrjWBGadkU4ayuzy3cTkBSu8yOrepE3RMwGROb3yeHAtv7k+2yOPCX2xfUm7avOQm4MHsFENruOIpYdjlLuz0M+JbZlk+PE3FVHpFvzYk+tJwLf3ekzGI9URng7POKmi1CkbOsawFGkTkbi+aW9LRPksS9nhy78haJ9Y5EQRh3n5humms5L/tDKwQ433k4ZHZhiFUpUwUYl9XF0Y4P4sLzzG5PYazVxlR/P8LWPLdyIgVqCTTVanoc+9x8PIurXXR5WUwDx7vFDc/RLt5MQtUSJd/OYZ8ipo0JqWNOGJ1PnMtPFiYW0JMoh3gEfsAEogb/nVKwkYsPLi2OezOt2k0CZN2td+tzhbCYeGEe4g2w/XLHawojU0AyWN7XFoMsiISbLj9PbqRkzKPHion6o9dMEAlRc6Y+OeJTlz2iTNoT3kHhthgD466xlb1/ti6e3FEz37ehBpIkV5wBw+mFY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(3023799007)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iQ5W9CCU0SphqOkEgg2s5D2op+728H+uRjx929pCIEOEz5Z8psynHNKnRRpx?=
 =?us-ascii?Q?xVTUKZnZ7outVc3JlQBhAl8Iph7zwfXu8RAk3BmODH6fM9uZyKSgm206m7Vx?=
 =?us-ascii?Q?2E9VmdsCyIA/ARSMb6VfTjsalOKmcfR4Tn1+wHJTpXXp/0YXxn1J/1beTiYS?=
 =?us-ascii?Q?9R89qj4YMGOclTKHorwIj3RjSBQPlX+f6etAUyTG9DkWN+SW3AUxWSG/9iak?=
 =?us-ascii?Q?qqga9aBPmBqCLtuM2C4SAXtQnbISsZG25jB8B0IxXYYz5tWNO9W63l0KcI87?=
 =?us-ascii?Q?j3XBchSPZRe1XrZfBvtGq5qJDHIXf5hbUya40QgnpwKerd4GrldFjZUomJmX?=
 =?us-ascii?Q?W7uea/VceszRn3m1YW/yekogq7b2HnbR0aI8ZMV3NFAHV3zQvDzT9TYBn1y8?=
 =?us-ascii?Q?6Ok3OMLb2Cn9aLNPLZnV95FU942SRvCHdPSn2m+r4XVXZzFF+vcKdTuLxrol?=
 =?us-ascii?Q?piOLvtqHUCD+AneUXe8G23SK/mhEboXNYmKmbUCchXJQeR3/4Xk8Pij26IiN?=
 =?us-ascii?Q?dCfiu7aThdyGBX1Pmhoc3HnWyyeiSj70Jb9mq2KYXZXqgdXitFbUZ9NTOQBQ?=
 =?us-ascii?Q?QrawqhcNKsJygyeE5aawBeo9t9jWPGJnwOfeTK+7UBwcWk9Tx4EdWXUMNhaF?=
 =?us-ascii?Q?EmTJKWwfX5kHv43r5mD27afP2tAbqPjBDv24D9S2yHjebhZL/KNvVVdgdKsp?=
 =?us-ascii?Q?4fCjxwu3T6aAakMo3zMhlWWG3/yKPWvizMgzW97HWgDQd05n8SNyr5yn4STf?=
 =?us-ascii?Q?7ptYOGGJy52Z9TIeopRWmArPovgx7oQM8A4autUSg0TeqJOYnsOEg1VRdXWV?=
 =?us-ascii?Q?Kyd6+y/L9HNDWycPSMotBWxBCmve5xyTsUK/EEMewomWa6ZWeNOTavzURZle?=
 =?us-ascii?Q?bkAXP6kUa4e3jR9nd26XJ+1ZoNa+6zKR1/LYYoUuOJmKoWmNm1IyBJG4p27S?=
 =?us-ascii?Q?V/mOUw1mlPrKgNy+MbtPj3LKQFoYZNh7+rPk2fKwX0I749UQL/zQhLWUPMk6?=
 =?us-ascii?Q?ZR6yeqGe0XyuaBp3XcsNCP8AuG2xsyi6b/UPwN+bnUS5wnNMbi1SYY1Dx/zT?=
 =?us-ascii?Q?XqKhU8g3MfAdpSZbl9Wqx9TvFjy2kZG4I/LDkUkgP6Pmf7CV0xNAJeSOqPso?=
 =?us-ascii?Q?fbzand55x7AOM+d92+l1hrEA0FwzD9bwj5+FOcXJIgM3+HHJyU4DW5acqxmT?=
 =?us-ascii?Q?/THnkNVKM+O1f615EjzZaQT+cnmqG4bk2NrKtmZsjk3PQUe1oPb9KFgaMyz3?=
 =?us-ascii?Q?NUFpoyOVPYmnXjoCIIm3V28dERpVSTG4MaWEFukBdBZHnR/DjI8uf4XMaJti?=
 =?us-ascii?Q?cfIK3kt7Pk1EmXYjfcUsEzezwXgvLQy2HFpak2aTrWBN2iSqAxaim3GmMSkp?=
 =?us-ascii?Q?59i9VS4Y4jM7OE54TUW8SJTWU50YW73Nj+3szsPFgeCePZL3cciYe21EL4ou?=
 =?us-ascii?Q?bI7rW4m8bh0mlHYi3KLLwPHvQxuNSQj5Gz8lYbnMSsYe6wsnA6lVryiK2ueh?=
 =?us-ascii?Q?bHjD05C0+di8m4yvcrkghsryhc35GeAHTtmeNfENBVH96YRHFb4vOnXl8GwB?=
 =?us-ascii?Q?p/2EYh8bs7KzPSafHb0ifVt8OnDPdvdp0IuKlkuNRwNI3JjxyRzHRGzLB0gx?=
 =?us-ascii?Q?W6BV9AFnhf8OrtecpJklVDx/BBJDcE6dCXT/JfEkzMk8SbBVTxVAMfruMQEd?=
 =?us-ascii?Q?sjH0EwUKs722dSvZ9O07XPA9YmoNNxSoTnhxKUkkGS6+5oQ9d2cw8yS81aJE?=
 =?us-ascii?Q?3GhpjtTKtDeyI5Ty7KfNon3V2wC39+0=3D?=
X-Exchange-RoutingPolicyChecked:
	BoPv2be3FGv+WnIHtyZgXFJaZNLJlbokcyGOW6btET2zi4hfgFt/ucElcD5jE/V1girFKIOUt98ddSsD6bCyAtLElljnGFMvAAUx/3lE0Vdz0vluyr1C5qCVB9Oj1BODk6lZdadSwqodcNBBRza70L2BghbrEKmM8YCAuX077CyH+CRXhhqDrs5CkbHD84SAhlkX40R13a4SCzHbdMo+9EUyqKEfgDG2tvi2mfhMBWIqYCPLhJ0kobwJ0PhrnTs0TF5+LORv5/4Dh7zAOgWtFQjT4chRulwqwJeQJ9IJ0HmNHE2I7eHRxOuxinz3Ss90f48WH7SGlcnurgXf1WePDA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18cd3d5f-ec5e-435f-b41d-08df17dc89f6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:28.6107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5N7eyyBbDBR6PJL0tdTohbYPQacN/udIK6yWA9aIqjbxfeo+f2K2z0Sl0A7pN78XT1YA6Zi7iT3c571Poh0ZuTTro2NVDRGE7bVaXoD7VSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=KInPn1Fo c=1 sm=1 tr=0 ts=6ab12423 cx=c_pps
 a=jYOLmuRG9FCngycrw98U6Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22
 a=64Cc0HZtAAAA:8 a=fnMJAXpJH4lpJfH95ukA:9
X-Proofpoint-ORIG-GUID: RaWDpuGmJk0MWte1UtT_ZTBgSUiSeEVO
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX+Za2r10EGyZ2
 jok/pfsneqCzlMtxf1xoZivvQ3d6HoHRONDmpsQmC/tGFWdv7DERhYixCf4pCvl6ToRcU8Z+5Hm
 GBZco7EoTjSiIXspt5UDTaBOrMIiXg4=
X-Proofpoint-GUID: RaWDpuGmJk0MWte1UtT_ZTBgSUiSeEVO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX2tjD4SiZHUZF
 vlE5y1FVo7eAxfQCZYgttYoIFmQxnEPOc7ccP02ZGgjLTAthOA3oXrqiAkOq3ePugUvMAn/NQfH
 KKFXnd+Xu2Uw4+REmp1ShcpfOPxdLqxdn66bDmtLL019d+awrG5+aQkHPO0Gu1nbFUTzsQ5m4ay
 wl0PW41it00b1LbqgZw+PmciC7Zz4QebqYHWOUIrOBX5Ve9/mkQZyQ5lQf4Qin/H+X87gO0ea33
 ViuA/ZpO20NZlJgZg7n3v67hBndeCS+tPssFRxudKkD/ECFVYJf4kczmO8hTDd71QNVS49Yf68j
 bsgQuySSkLKqAZa/EyqB2o1cKF+Wphv5MvmcBFThDAbbQyp4UWravLD9SpaSqIGVtEoVWOt1ijj
 eJCeP8v6tp7Nr/1V/MvGv9ojIj5Azl6yMKcZ9DWfgZnnOAWN7E2O5SlPoUBXROVLjoS8auKVD42
 eThpGwSv9UMI+OPrGJg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add scaffolding for named CPU models on Arm on top of the property
layer. A model is a list of (property, value) overrides plus an
optional parent; a child inherits its parent's property values and may
override them.

Instance init steps:
    - host feature discovery.
    - zero out isar.idregs[] and restore RES1 fields.
    - install SYSREG_ and sve* properties.
    - walk the parent chain root-first and apply each level's
      properties.

This assumes that each property is idempotent. `pauth` is intentionally
not installed because the model's ID register view is authoritative
and can be configured through SYSREG_ properties.

No models are defined yet.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-models.c | 191 ++++++++++++++++++++++++++++++++++++++++
 target/arm/cpu-models.h |  36 ++++++++
 target/arm/meson.build  |   1 +
 3 files changed, 228 insertions(+)
 create mode 100644 target/arm/cpu-models.c
 create mode 100644 target/arm/cpu-models.h

diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
new file mode 100644
index 0000000000..fed3197186
--- /dev/null
+++ b/target/arm/cpu-models.c
@@ -0,0 +1,191 @@
+/*
+ * ARM named CPU models.
+ *
+ * Each model is defined as an array of MODEL_PROP macros, listing only
+ * the properties that DIFFER from the parent model.
+ *
+ * Initialization starts with a zeroed idregs[] array.
+ *
+ * During initialization, the parent chain is walked root-first and every
+ * level's properties are applied via QOM, so the leaf's values naturally
+ * override its ancestors.
+ *
+ * Assumptions:
+ *     - All named CPU model properties are idempotent.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "system/kvm.h"
+#include "cpu.h"
+#include "internals.h"
+#include "kvm_arm.h"
+#include "cpu-idregs.h"
+#include "cpu-models.h"
+
+#define MODEL_PROP_FIELD_STR  str
+#define MODEL_PROP_FIELD_BOOL b
+#define MODEL_PROP_FIELD_NUM  num
+
+#define MODEL_PROP(_name, _type, _value) \
+    { .name = (_name), .type = ARM_MODEL_PROP_##_type, \
+      .u.MODEL_PROP_FIELD_##_type = (_value) }
+
+#define MODEL_PROP_END  { .name = NULL }
+
+/* Maximum parent-chain depth for named CPU models. */
+#define ARM_NAMED_CPU_MODEL_MAX_DEPTH 16
+
+static const ArmNamedCpuModel arm_cpu_models[] = {
+    {NULL, NULL, NULL}
+};
+
+const ArmNamedCpuModel *arm_find_model(const char *name)
+{
+    for (size_t i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
+        if (!arm_cpu_models[i].name) {
+            break;
+        }
+
+        if (g_str_equal(arm_cpu_models[i].name, name)) {
+            return &arm_cpu_models[i];
+        }
+    }
+    return NULL;
+}
+
+void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
+                           Error **errp)
+{
+    const ArmModelPropValue *pv;
+    ERRP_GUARD();
+
+    for (pv = props; pv->name; pv++) {
+        switch (pv->type) {
+        case ARM_MODEL_PROP_BOOL:
+            object_property_set_bool(obj, pv->name, pv->u.b, errp);
+            break;
+        case ARM_MODEL_PROP_NUM:
+            object_property_set_uint(obj, pv->name, pv->u.num, errp);
+            break;
+        default:
+            g_assert_not_reached();
+        }
+
+        if (*errp) {
+            error_prepend(errp, "property '%s': ", pv->name);
+            return;
+        }
+    }
+}
+
+void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
+                             Error **errp)
+{
+    const ArmNamedCpuModel *cur, *parent;
+    const ArmNamedCpuModel *chain[ARM_NAMED_CPU_MODEL_MAX_DEPTH];
+    size_t depth = 0;
+
+    for (cur = model; cur; ) {
+        if (depth >= ARRAY_SIZE(chain)) {
+            error_setg(errp, "model '%s': parent chain too deep", model->name);
+            return;
+        }
+        chain[depth++] = cur;
+
+        if (!cur->parent) {
+            break;
+        }
+        parent = arm_find_model(cur->parent);
+        if (!parent) {
+            error_setg(errp, "model '%s': unknown parent '%s'", cur->name,
+                cur->parent);
+            return;
+        }
+        cur = parent;
+    }
+
+    while (depth--) {
+        arm_apply_model_props(obj, chain[depth]->props, errp);
+        if (*errp) {
+            return;
+        }
+    }
+}
+
+static void reset_res1_fields(ARMCPU *cpu)
+{
+    for (size_t i = 0; i < NUM_ID_IDX; i++) {
+        for (size_t j = 0; j < arm64_id_regs[i].fields_count; j++) {
+            if (strcmp(arm64_id_regs[i].fields[j].name, "RES1") == 0) {
+                cpu->isar.idregs[i] = deposit64(cpu->isar.idregs[i],
+                    arm64_id_regs[i].fields[j].shift,
+                    arm64_id_regs[i].fields[j].length,
+                    MAKE_64BIT_MASK(0, arm64_id_regs[i].fields[j].length));
+            }
+        }
+    }
+}
+
+static void arm_named_cpu_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
+    const ArmNamedCpuModel *model = arm_find_model(acc->info->name);
+
+    if (!model) {
+        error_report("'%s' CPU model entry not found",
+                     acc->info->name);
+        return;
+    }
+
+    if (!kvm_enabled()) {
+        error_report("'%s' CPU model requires KVM (-accel kvm)",
+                     acc->info->name);
+        return;
+    }
+
+    kvm_arm_set_cpu_features_from_host(cpu);
+    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
+        return;
+    }
+
+    /* 1.a Reset ID regs to 0 */
+    memset(cpu->isar.idregs, 0, sizeof(cpu->isar.idregs));
+
+    /* 1.b Properly set RES1 fields. */
+    reset_res1_fields(cpu);
+
+    /* 2. Add sveNNNN and SYSREG_ properties */
+    aarch64_add_sve_properties(obj);
+    aarch64_add_idregs_properties(obj);
+
+    /* 3. Realize the model chain. */
+    arm_realize_model_chain(obj, model, &error_abort);
+}
+
+void arm_register_named_cpu_models(void)
+{
+    static ARMCPUInfo *arm_named_cpu_infos;
+    size_t i, n = ARRAY_SIZE(arm_cpu_models);
+
+    if (!n) {
+        return;
+    }
+
+    arm_named_cpu_infos = g_new0(ARMCPUInfo, n);
+    for (i = 0; i < n; i++) {
+        if (!arm_cpu_models[i].name) {
+            break;
+        }
+
+        arm_named_cpu_infos[i].name = arm_cpu_models[i].name;
+        arm_named_cpu_infos[i].initfn = arm_named_cpu_initfn;
+        arm_cpu_register(&arm_named_cpu_infos[i]);
+    }
+}
+
+type_init(arm_register_named_cpu_models)
diff --git a/target/arm/cpu-models.h b/target/arm/cpu-models.h
new file mode 100644
index 0000000000..144778744e
--- /dev/null
+++ b/target/arm/cpu-models.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef ARM_CPU_MODELS_H
+#define ARM_CPU_MODELS_H
+
+#include "qapi/error.h"
+#include "qom/object.h"
+
+typedef enum ArmModelPropType {
+    ARM_MODEL_PROP_BOOL,
+    ARM_MODEL_PROP_NUM,
+} ArmModelPropType;
+
+typedef struct ArmModelPropValue {
+    const char *name;
+    ArmModelPropType type;
+    union {
+        bool b;
+        uint64_t num;
+    } u;
+} ArmModelPropValue;
+
+typedef struct ArmNamedCpuModel {
+    const char *name;
+    const char *parent;
+    const ArmModelPropValue *props;
+} ArmNamedCpuModel;
+
+void arm_register_named_cpu_models(void);
+
+const ArmNamedCpuModel *arm_find_model(const char *name);
+void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
+                           Error **errp);
+void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
+                             Error **errp);
+
+#endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 384d90c530..dd28146c52 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -32,6 +32,7 @@ arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
   'cpu-idregs.c',
 ))
+arm_system_ss.add(when: 'TARGET_AARCH64', if_true: files('cpu-models.c'))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-- 
2.52.0

