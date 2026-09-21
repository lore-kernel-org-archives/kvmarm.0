Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B1D49B1F9
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995872; cv=fail; b=eyhzwvqzepOjLzsosaWb/yqKZ9DAuQmgi25RPPjDvJlU6NKmUhfSIS3gmQfhmzYgsb/gSkmGkRptmQ3GsDvPtJSneePzIUnCzoOFWKJPEPVUKf0XSe0KokfzlfIvDD6DV6NKUCn62DCUY+ejxv9mWxwlVapTHAZwRl37TmdzeBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995872; c=relaxed/simple;
	bh=X2CrzQfpDY/OSa6elRKonWw4JZPSu32ld4ZJXQlV7Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M2hz7suwxbAJB+ky9likxUs/rGkgbAvH4KFViDrTs1BG7mVk8epLukadru3WwYpRJYl8+AVvoTklv2kmedfzQnvW/f0MhiVVU9DNzLNiSrg8kskL8uLL94LOeFS9TOsOvN6jLBA346coFKbEICXMiDWfGnRtLbb0Pg+aSPGKwRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oM/DQ3aR; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kYgQjDqD; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oM/DQ3aR";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kYgQjDqD"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAflUI774316;
	Mon, 21 Sep 2026 05:33:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=BOEaJ0taXIUpX/OSmfh8IMUTqrnzuX6hNC4uDiQb4
	QI=; b=oM/DQ3aRLlmHFbkg+Fh0/j0NbZZoPiFCk5cEZSADmt3lihLomdJB1jx9D
	8Myej143Xnm7NlD0sXxGsFHCPr+xIHrTbH1wEHoVlVBpDmEw5nfHzx9HKDk7dwZ3
	suvXRmGt7uPbCL09mDTzkfzXo0x8mdtI2UULN1icV2Fe070GkHYCJilYPsSzHKdu
	aiVEuZpQkIz+yNbEMiJI8djQKEA0WONWnU2gZy3jC68yq23BgWmzf1DLq6X3xVve
	h91UzShdPgP98UhyE3Zs52ebFR7O4ld9IZN9CCWbr0BMkUajBEQuEDc26Vo5pXCD
	KaHaambffN6ECQ8ZsvNIcGFkiiXKA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021115.outbound.protection.outlook.com [52.101.57.115])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gsqx831cb-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doDV6RqUcHJYYuboNaldMFzqWez5du6SUM4Vo+ZL22li2vicfengiNfO6nvPZ6hTmDyDNnDQ+YPUUd9y4KaBiDCCh95HICkKRVD0BW82ps+lnaAum/nD3vMo96zfhMFitI4r9RiPqrZjFRLmFBxkQKxcA4n7jfNZxsuwBLqLEpth3JSWV9qFQy1v9HP7JBiwFoyZ/LYuElgFwOlYWC7BeYc4fyl//ob2G9Tke/ZFIzBknrye5hwxwoa8bOsAsxALnBW3uwKQN0UKKOJVgHuWuv7HjDcHd+JKgjvJgtZ9PCg+nagNDP52DWFJm9XjZHZgMeu7Opb4IBtwhx3nh4N9dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOEaJ0taXIUpX/OSmfh8IMUTqrnzuX6hNC4uDiQb4QI=;
 b=yKH0tgVqqUTcFMhU5jr/xKztogERKWaDKwRcPk7/yDU52phW6CyNBJ6Jevzu6lSndG7aPU/DU/KPfjmckl3TeV+e2A1pqhdJMSrMXcty2lmhmAnWbeJCAezp2CBJijsbmR5wkHrvkSbERApOFXGdQe6GN9MumH9jGAan9Pb12i8CuCGcBugahJLu3+4JiKGxgMZGmG3O0xmslTumP5L+BuFiaXZdum6Ca81fwNbWCAqZGmBb2nSiCsBNPDcDxRfuAppM2+WKzK1ANGxGH18s5cVGsfSMhf1p3Doz576yPvxLbPa6Re/XvzbWFqd8annCnBXzjqptq4bjK5pznH3nTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOEaJ0taXIUpX/OSmfh8IMUTqrnzuX6hNC4uDiQb4QI=;
 b=kYgQjDqDL6w2VUEMXLTFjcLjnPpooeYXYdE+7F7KkSVW17xmNj4qqlHDoWdI3+VXaqe1HUeajTSFU3Z8PeGzra1sB0g+fApcal55DpeVZDYdl3OlwE1nHPp1HPCBbzZ+h1Z7MPSnBxvvQc6PFfHQUvAHUgXrUeQ2Ny8O4jsJCImOg3YNeXVkytFnulQVk8oecypsS+MM3sQlEittxq1AwLb40zC5lQ9kGawabZ+qIKq49A86g2vT0V1dk1B78yYJSpteM6Km8yKN0vX6DmdxhH7vBcDlYaeeXgMQz3wLWVVgQHbkk+cCr817bYuUDlN/89Nml0HcDeNKR6Y53lk4uA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:31 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:31 +0000
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
Subject: [RFC PATCH v4 12/25] target/arm: add arm-v9.0-a-v1 named CPU model
Date: Mon, 21 Sep 2026 12:32:36 +0000
Message-ID: <20260921123249.1708067-13-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7fafe6ea-936b-4ca2-3d4d-08df17dc8b99
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	yy65hyOrgYYIOnxh3/CTCw7bJod4f1iiT4zn8hAJZjhH6moCP8daQ8bycTmZw9tDZKHgGePzurnj2ZY8h4tk5qYJRbRAQ2ghGWhpTlUxgX6AJXof/FyDiyIVEwHLptHtTzYa3+BoXWGvGblv8d2qPp11yol06vXtW5pu83U3hI/y0SiFOP2zPiMF6+RarHkyBq16/RdjmX1J2NN8iDOYuhmGMLeaEseC3zKVIPdlNGW/inUPAKC7jDyGq0AAo8IOohgGJxJYKn+dvBvTsi1v15Zo2OrypfhLpTCgEUy9JoJxDlvqLY3zw91/EVfn9nPg2m+J6OpOwjr+XIDdKmImU+bpFoWvND4pOfL5TiUA6Sutv0iN4V9dT5DTCy2A38YxbfgWrE4HTfvw132GRRIciVD3zKkU8kKj3zPQHNpBnDb628x3Wz8IMhkarVFmepGKDtwUUNDfxHnjPwA6+6vNVuohV4P7tRX3VFH/UidsxRHFlGDtu9UlaC0S1K3gUR8yMaPDJ+vswM6h8BMRaDjQCtdji2bzpI4jGZ7eLSOS+H6vcVWwk2Ul4csYesFbj7go8uZr+mfqfeGeBhdczwlZYMEoczQLfC3WGCi/isNVPSvqrh/FI1qbUBOp9XcC5ojxmzria1Pxb83654bvEfClyL+Hnv8I2P1eUH9HAmaiNiY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K3S+6pIFNzzfWrBm8aSs7wgzJ7oU2Leum6zMfq/8QoEisypx2Lju74Snif0m?=
 =?us-ascii?Q?utPzHodJKasgDW3YRWPnTFphEyKV5q9br6GPzyxoa9fBUoKkaafvGP9jn/9y?=
 =?us-ascii?Q?57UyhVVu6RdGir0JrHOk4WX5co19fb00wFw4qlLS8w7qbUXAB6Sq7c5OXomx?=
 =?us-ascii?Q?XaJKzftoaBDefKFAef91Qs6Z/ZYSxuhzx7fg8d1/trOd0tlGIJvcPRjd3jB+?=
 =?us-ascii?Q?t03eO3sXyn/Hk2G+hRvnxUuRS9uqOga4fRP0GtnMPwsAf4zLPNugRvzh+vGX?=
 =?us-ascii?Q?X31rq8QtR2WoxQQO204ecvqd9L/N/uH1UMVW640ta19GBMSLrZCMlKeyyD9+?=
 =?us-ascii?Q?UaXW7ZG2Hb8TOyx8sjHiJJD7CnEWii1/6MpOiVF7FEuu2iaoaP3oE1GBitNS?=
 =?us-ascii?Q?Fxs4FHRTRGt/5FtBTNSDzic5gxbtV5ss0etRbHQG/MMU2wV2kv8UVc2lLI16?=
 =?us-ascii?Q?1sekF5Qa3LBPABxpbRuyOTi7QycGj1uOeskYDUDnZrUb5HxjtH1hoZHKV2A+?=
 =?us-ascii?Q?okPkCO3rz037CLXLt9RP6ZA3NsSLdcOPy7KwfwAGz2gESoG3O9BkjKcAkFxt?=
 =?us-ascii?Q?lPQ+WZeMIOuHjSdi/87KnnsR14fXF6B0ItIFrxTbJY2CDnuYpJYLiITfAnGF?=
 =?us-ascii?Q?0JW8uifPygYWvREiZXrnbn9NV27aukdTw9D/LxEyAyw0aA6mWL3EFa3CfU79?=
 =?us-ascii?Q?7TjGhBdR/dYjHhA9vSJYBKj3zxn96SZ3XOO6e4RZ6gr4AYZYa9WSVeN+2+s0?=
 =?us-ascii?Q?1wSnoIdVvxKb4bLAmVe6WKkSv7NswpLiT4rMJexA9nTT4nJHowPzC9HPPNFJ?=
 =?us-ascii?Q?ptid5VkKCXc3oSLTcDZyOdmqq9y1iNoc3r3GWnw2pBUa3mzfH5FLTiESgple?=
 =?us-ascii?Q?Np4cVfTQRrtWPlhQcw6hj49BBMXhmbjx7sr7PRVcvdSjX/XWGiZ+xFsz1jK5?=
 =?us-ascii?Q?/+IwzsIKtdYKRv3lWPqA6TOQ1XctzB71gKcruVsytpuygxM+t9vGkJsnYsxq?=
 =?us-ascii?Q?nKMh14vL0eiNmj4VSdorjjxHbRDfxPzL3dH6tD2zPrFE5EMASPYVoY9QNphf?=
 =?us-ascii?Q?kxs4uuJcGSNLIr7tBczP3VsuZr2ekB4hGvkmZiyn5p058UmKO5PSPK/6D+ot?=
 =?us-ascii?Q?yZtdfiy56ROXXgAyjJGp2WCRliNBddC7KpeIkhFLtb7PwfU8ev5DHLIVqmQ8?=
 =?us-ascii?Q?KGQhKwrxFPbK9DAyBPCBRFNQMjURyqaDOBlifmJpd9OmxDFWb+CHG6KoqJ4s?=
 =?us-ascii?Q?pa5cg1JbGw3woooZ+bpMYExwxUT+zPiSx68rx4RVh/ruHHXKDZpg5NiyXsAU?=
 =?us-ascii?Q?q/pxsGAdeTMS6xDxB23gTutwJWkp1xEsiFj8a1XCZOegNKkWQ3Z9iZuFbKM7?=
 =?us-ascii?Q?R8JLWifHFGcUVrkZM4YTAbkIdz0z8/0o3BxtYV7xcZI0YC9EurpL6hkT8B08?=
 =?us-ascii?Q?m/wPraQx5PQPqw7fbLqRNvEPOjcJ1bJuwVPMgHqKsCBkKVwCdlIUEAHc4yCD?=
 =?us-ascii?Q?Qag5pbBOEOJ/TdCNfOtL2uwdEEnAUXb9HlY8kZZEUMOv1sGWnfHELUOnK196?=
 =?us-ascii?Q?a7JXesO1b3a7VqhhQoenYorRrZ5ErQ0fa0guCcRaUMyIRXpiPTC8givYk7BQ?=
 =?us-ascii?Q?7OCjcfNq6ZR/ArI/htM57fODNIL1VVDE4SlQIyMYX1rf/ZVGdouVA+JmPEA/?=
 =?us-ascii?Q?8zXYeMJ6cJqeooibyQ+qdhQPnrTVMsTvUhp/1S5OVLtyX4dczu8gkVnAvIDT?=
 =?us-ascii?Q?KSB/FF+FfkRfB9hmflRf3JS2I4BLKhU=3D?=
X-Exchange-RoutingPolicyChecked:
	bf0pOsqdSl/7n3KLBFJS8+LuW7Vad64MS+W6GINOeOzJ2yfj0POb/EwvPvjMIA3iQnJQaVUwh5EHZTsiASN99uPVkmiZdzB08+x+FN1Awp6d2/MvMW8Ai+eI1gheIqe0hWsn2TsSQ7bTFgXG8Go544mhD5RK9vEOESrjag18nKlTgMG0Ce5Ci2uhlPcDSNINphjugArKqaqobdffbqjHuiPFQInghrbeCYqbE4G2etMEGkK4qNuW+bRjDazU6hWHVUz357NhGKkNMsYjlSt2Q6TpvIbwvhwP4IwuKz9PFyPNOb/6Qgxi2ZGHk8Gvzsdp1wT0X3Rlz2F3ELE7yt+9Eg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fafe6ea-936b-4ca2-3d4d-08df17dc8b99
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:31.3429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H7LMFsVRSLAdmV75sfJR8fgil78jknB2uR0Wb02+a30VEMcG1SXCnwMT2k5wwhSchZu4d5PpbSKKl6vFWF2lw0oVvgtM/ppX1g0K23ig5lI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=KInPn1Fo c=1 sm=1 tr=0 ts=6ab12424 cx=c_pps
 a=jYOLmuRG9FCngycrw98U6Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22
 a=64Cc0HZtAAAA:8 a=TUthYur4ThMOfVJD-JMA:9
X-Proofpoint-ORIG-GUID: 0zqSoyVmZF7U9HfSZe2hdpiZSSPQL6Mf
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX37Dt+x4DgCW5
 LTfRWsJUxykECNCcLICMfbYj85q/P6aCheaR4TZ9b5rnKBSLjSBKvrVYXrOxRZkyYP+CIPV/yDZ
 U2v80D6zTR4BZBNlobaqvK5Q6z3b4A4=
X-Proofpoint-GUID: 0zqSoyVmZF7U9HfSZe2hdpiZSSPQL6Mf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX7QAO2GI7vv+x
 lJ+oktEEzG+Q0cf0TLTq4SvmABsxK/TjrZ4iB8C9X6CrgwCuUIckaWIO+nQiwFCcXdBOOaTv7do
 mYse1sr4gMXIGq7C6kZUDNsXnPbyR2aQxsUoiPpitlvjYuEkX6D7VeMxgIMBPlEZMm43PWRSWpO
 iCt3R3qdVhf/EXIWWTFZH5udaiFOQX3+cG0CkQeBPoAuP6UExMPvJ9Xp5G5yRV6FElxgPjE9zyw
 dmLsABMeHbCFvqJe8STQLeJLWMyO39gLYXaTOYjQGCqQ2F8+KDQ1AZQw5+Wss5acbgV5J8N+Q3j
 /vwhz0cW4QsOl643E6+HPsQDKJanQr1EbMY56Q7xrG2b/1MwhLECmmf5qJG3H8pUWyntjDtDSsL
 LBdIwn59e1NjPqUKj7xONfRWj8olBj6BT0UlEU+zx33vbt7LLayWiktq7eiLu9HtaGLCk+D5gDT
 vnaXsNxCt+ISjwDxlkA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add a KVM-only named CPU model for the Armv9.0-A baseline, following
DDI0487 revision M.c. The property list is the architecture-mandated
ID-register field view.

Pointer authentication is omitted because a v9.0-A core may implement
any PAuth algorithm.

Named models start from a zeroed ID-register view, so features whose
"not implemented" encoding is non-zero (for example TGran64=0xF,
DoubleLock=0xF) are set explicitly.

The model is not realizable on its own; implementation-defined fields
such as CTR_EL0.{CWG,ERG} and ID_AA64DFR0_EL1.CTX_CMPs still have to be
supplied on the command line. However, this provides a useful baseline
for upcoming reference core models.

Final ID register state requested from KVM for "arm-v9.0-a-v1":
[  0] AIDR_EL1                 = 0x0000000000000000
[  1] CLIDR_EL1                = 0x0000000000000000
[  2] CTR_EL0                  = 0x0000000080008000
[  3] DCZID_EL0                = 0x0000000000000000
[  4] GMID_EL1                 = 0x0000000000000000
[  5] ID_AA64AFR0_EL1          = 0x0000000000000000
[  6] ID_AA64AFR1_EL1          = 0x0000000000000000
[  7] ID_AA64DFR0_EL1          = 0x000000f000000009
[  8] ID_AA64DFR1_EL1          = 0x0000000000000000
[  9] ID_AA64DFR2_EL1          = 0x0000000000000000
[ 10] ID_AA64FPFR0_EL1         = 0x0000000000000000
[ 11] ID_AA64ISAR0_EL1         = 0x0221100010210000
[ 12] ID_AA64ISAR1_EL1         = 0x0000011100211002
[ 13] ID_AA64ISAR2_EL1         = 0x0000000000000000
[ 14] ID_AA64ISAR3_EL1         = 0x0000000000000000
[ 15] ID_AA64MMFR0_EL1         = 0x000001110f000000
[ 16] ID_AA64MMFR1_EL1         = 0x0000000000211000
[ 17] ID_AA64MMFR2_EL1         = 0x1001001100000011
[ 18] ID_AA64MMFR3_EL1         = 0x0000000000000000
[ 19] ID_AA64MMFR4_EL1         = 0x000000000f000000
[ 20] ID_AA64PFR0_EL1          = 0x1101000010110011
[ 21] ID_AA64PFR1_EL1          = 0x0000000000000001
[ 22] ID_AA64PFR2_EL1          = 0x0000000000000000
[ 23] ID_AA64SMFR0_EL1         = 0x0000000000000000
[ 24] ID_AA64ZFR0_EL1          = 0x0000000000000000
[ 25] ID_AFR0_EL1              = 0x0000000000000000
[ 26] ID_DFR0_EL1              = 0x0000000000000000
[ 27] ID_DFR1_EL1              = 0x0000000000000000
[ 28] ID_ISAR0_EL1             = 0x0000000000000000
[ 29] ID_ISAR1_EL1             = 0x0000000000000000
[ 30] ID_ISAR2_EL1             = 0x0000000000000000
[ 31] ID_ISAR3_EL1             = 0x0000000000000000
[ 32] ID_ISAR4_EL1             = 0x0000000000000000
[ 33] ID_ISAR5_EL1             = 0x0000000000000000
[ 34] ID_ISAR6_EL1             = 0x0000000000000000
[ 35] ID_MMFR0_EL1             = 0x0000000000000000
[ 36] ID_MMFR1_EL1             = 0x0000000000000000
[ 37] ID_MMFR2_EL1             = 0x0000000000000000
[ 38] ID_MMFR3_EL1             = 0x0000000000000000
[ 39] ID_MMFR4_EL1             = 0x0000000000000000
[ 40] ID_MMFR5_EL1             = 0x0000000000000000
[ 41] ID_PFR0_EL1              = 0x0000000000000000
[ 42] ID_PFR1_EL1              = 0x0000000000000000
[ 43] ID_PFR2_EL1              = 0x0000000000000000
[ 44] MIDR_EL1                 = 0x0000000000000000
[ 45] MPIDR_EL1                = 0x0000000080000000
[ 46] MVFR0_EL1                = 0x0000000000000000
[ 47] MVFR1_EL1                = 0x0000000000000000
[ 48] MVFR2_EL1                = 0x0000000000000000
[ 49] REVIDR_EL1               = 0x0000000000000000
[ 50] SMIDR_EL1                = 0x0000000000000000

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c           |  3 ++
 target/arm/cpu-models.c | 75 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index e7a56e37f7..01381ab5e7 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4144,6 +4144,9 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-n2")));
     }
+    if (kvm_enabled() && target_aarch64()) {
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9.0-a-v1")));
+    }
     if (target_aarch64()) {
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a53")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a57")));
diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index 153ee10ae6..7394dd358e 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -39,7 +39,82 @@
 /* Maximum parent-chain depth for named CPU models. */
 #define ARM_NAMED_CPU_MODEL_MAX_DEPTH 16
 
+/* Arm-v9.0-a mandatory features. */
+static const ArmModelPropValue arm_v9_0_a_v1_props[] = {
+    /* ID_AA64PFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL0", NUM, 1), /* only FEAT_AA64EL0 (Armv9.0) */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL1", NUM, 1), /* only FEAT_AA64EL1 (Armv9.0) */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 1), /* FEAT_RAS (Armv8.2) */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_DIT", NUM, 1), /* FEAT_DIT (Armv8.4) */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV2", NUM, 1), /* FEAT_CSV2 (Armv8.5) */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV3", NUM, 1), /* FEAT_CSV3 (Armv8.5) */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 1), /* FEAT_FP16 */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 1), /* FEAT_FP16 */
+
+    /* ID_AA64PFR1_EL1 */
+    /* KVM zeroes out these field when MTE is not enabled. */
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_MTE_frac", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_BT", NUM, 1), /* FEAT_BTI (Armv8.5) */
+
+    /* ID_AA64MMFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0xF), /* not mandatory */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0), /* 4K granular support */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 1), /* not mandatory */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 1), /* not mandatory */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 1), /* not mandatory */
+
+    /* ID_AA64DFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DebugVer", NUM, 9), /* FEAT_Debugv8p4 (Armv8.4) */
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DoubleLock", NUM, 0xF), /* not implemented */
+    /* no PMU for named models */
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_PMUVer", NUM, 0),
+
+    /* CTR_EL0 */
+    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 2), /* FEAT_IVIPT: VIPT cache impl. */
+
+    /* ID_AA64MMFR4_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0xF), /* FEAT_E2H0 not mandatory */
+
+    /* ID_AA64ISAR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_CRC32", NUM, 1), /* FEAT_CRC32 (Armv8.1) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_Atomic", NUM, 2), /* FEAT_LSE (Armv8.1) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TS", NUM, 2), /* FEAT_FlagM2 (Armv9.0 & FP) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TLB", NUM, 2), /* FEAT_TLBIRANGE (Armv8.4) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RDM", NUM, 1), /* FEAT_RDM (Armv9.0 & FP) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_DP", NUM, 1), /* FEAT_DotProd (Armv9.0 & FP) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_FHM", NUM, 1), /* FEAT_FHM (Armv9.0 & FP) */
+
+    /* ID_AA64ISAR1_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_LRCPC", NUM, 2), /* FEAT_LRCPC2 (Armv8.4) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FRINTTS", NUM, 1), /* FEAT_FRINTTS (v9.0 & FP) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FCMA", NUM, 1), /* FEAT_FCMA (Armv9.0 & FP) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_JSCVT", NUM, 1), /* FEAT_JSCVT (Armv9.0 & FP) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DPB", NUM, 2), /* FEAT_DPB2 (Armv8.5) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_SB", NUM, 1), /* FEAT_SB (Armv8.5) */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_SPECRES", NUM, 1), /* FEAT_SPECRES (Armv8.5) */
+    /*
+     * FEAT_PAuth is mandated by Armv8.3 but is excluded here as reference
+     * core can choose to implement any PAuth algorithm (APA/API/APA3).
+     */
+
+    /* ID_AA64MMFR1_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 1), /* FEAT_HPDS (Armv8.1) */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_LO", NUM, 1), /* FEAT_LOR (Armv8.1) */
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_PAN", NUM, 2), /* FEAT_PAN2 (Armv8.2) */
+
+    /* ID_AA64MMFR2_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_UAO", NUM, 1), /* FEAT_UAO (Armv8.2) */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_CnP", NUM, 1), /* FEAT_TTCNP (Armv8.2) */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_TTL", NUM, 1), /* FEAT_TTL (Armv8.4) */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_AT", NUM, 1), /* FEAT_LSE2 (Armv8.4) */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_IDS", NUM, 1), /* FEAT_IDST (Armv8.4) */
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_E0PD", NUM, 1), /* FEAT_E0PD (Armv8.5) */
+
+    MODEL_PROP_END,
+};
+
 static const ArmNamedCpuModel arm_cpu_models[] = {
+    {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
     {NULL, NULL, NULL}
 };
 
-- 
2.52.0

