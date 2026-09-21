Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0563A49B1F9
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996043; cv=fail; b=QAO5cW7sfSKNWbnc557OX+yllQ3hCoO8XXuTr0/STec1jue1tIZys8ojo+IZq1WA13Qt1L2XeahqrYqHIAbEXCwvZjWvvF7862oXuedy5K2gKO/IdmhhVU68sjNfGy//xx9Bzs5G4mmeq51MwhMyHTIurTM0CB7/viuA28BNm3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996043; c=relaxed/simple;
	bh=LNM5hZnxABD0JTKIORF22pT9wmaoKJviPtRRfLDgb/0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bWeinAMfTbuuU32/KValgRZKmPyZIcKMx0kPhr7Tyn4bqgcKEcRJ576i46AnYeJLJFQiLA5UAJmguXASv2x9AEvBTYFnLjwSwLalGypL26LfTAhzeuWz6t3u5nTrRAfsiRMKBiS3g1hFBw1/88NwQQ2N54lBR/N9EaVew/AFcI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qxsHhah8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=X4UMvaoa; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qxsHhah8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="X4UMvaoa"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHE8857569;
	Mon, 21 Sep 2026 05:33:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=WjtaVH+eKuIf3
	ojvABQMPc2dLR8wokmLbAhnWsTsNFw=; b=qxsHhah8ZsYYRdghS55wt0niXFvKZ
	hjL/1O04sOFa0FTfj8GM1QOSG30s6NHR4Zsg1hsocM3iKB1azPIgWroSmiECK6kd
	CwEhk1tVeFwp7eFSFNj75M5J/wivBbvR3N6Vk8hqr2jnLTPqf2RQWGneZ/WzTFGF
	KVn72F3uBMfWCa13mLyoWFaMpx9g1nOlBJHiyAoc0xhUOySTd5Rm6RcG/rCdZEB8
	jGwJK5x/ZobFfG7gDcZPx1H/1GcDF5aP70YXwzRrj8VjwP/cDUft+SzNNGn1KnfG
	MiLLTZ3NJ/YxfeRe1YPSgYPJ5EH5dglYYSO1FWg75FZf9WXI/ep+erGsg==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023112.outbound.protection.outlook.com [40.107.201.112])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jnb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfonAV0S7EEAAMWyBhuMMsC9eRdigk+UcUU+nl473y533zpkv6hUkPl/53V0i8ZnYbXscAUo+Tc1wR4QLeSZiM45vWh6r/A4ZFSEcv9NdVswUm+r599rczxFfPaq5fvWOtw87FM+DyTCym0hx9HMXzQ+z+OyBCv6yelTEVoyqTBotginQWX1vgKiu2kVUOqNd/NJgnjpBxapwfMQzOSoalXdIcpPHzmqLJT18ckfXx6mWDNHLxcLqyy/P40mnz8PI7xpznlcUSyvsNdLA1J5u9jdH2iZ/PC0+hQR54iAOrNT7PKLB72KUznzPqVrBScIfln+ks93VGHrURS1RuUdwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjtaVH+eKuIf3ojvABQMPc2dLR8wokmLbAhnWsTsNFw=;
 b=J/M7XWbiN49HgnqWNS5OM29wKEl/pi9/IlmzFow9WPB3mddxkFdQfVB0C5QaEWrmgqDKqUg7Zi2VsZw3Ppa9LSLyxMYs1AL6KzwtVP+lnvossHFU8BUFKsUBkRcAwbMhVfjtiqBKjLtq4OSNdmItfczMvhrsR4TSHPsFXDMbr/nWBy+i5Rlo3380x4alFMEsyEHS/R8kOnfgncPUfd19uchXnxpWcPwWtO5+TwROBLwjguzn8Yr/3pu5SKsg5rmhzAMkzrP7jzh/RNbkosRuc7pNz/oJnnuHMccbQsRwMIiHhY/wvxJK61LeMeY+hW3ofJz4yg5TfuKBKRluK+FNBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjtaVH+eKuIf3ojvABQMPc2dLR8wokmLbAhnWsTsNFw=;
 b=X4UMvaoahX6PvmJ8C0LdMEjX9YA1nIL661yP4iWgKJJS+K4FSBHSSK5NuJxgGNn48ubCTIl4ucxO0cLz/Ik4Bk56YVYBd9RGKiMIzHrBfkW4X2SDKqij/qZlX41v8ljwgaPV7lEefUouoLtoOfo1g2KUPm0lCtXh8Nn4zVQRtXGtt835hKABn9DxWpdYU9sjvaSmLdD4aCfCKL+OihgjAj50+TLqasZvZqJuuNs7fweovGqTbHmAgbgmUsvzFWoakGqz3wZ1ogs3W80NMq+tgi8yqi3CrCSLrY6Z16ZTG5G+5gN7dbIxC7mU5R0jWTVXTcK3CNd99M7moO1a0DFdqQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:14 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:14 +0000
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
Subject: [RFC PATCH v4 00/25] named CPU models for Arm64 on KVM
Date: Mon, 21 Sep 2026 12:32:24 +0000
Message-ID: <20260921123249.1708067-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
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
X-MS-Office365-Filtering-Correlation-Id: 47728804-8a38-454d-f90b-08df17dc7f3d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|3023799007|56012099006|5023799004|6133799003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	vKXtK9RADRYHeyWnPoPKi/H28w7YpmUXmka/wzQUkY5PsEGsjup3v1yTmlSgY657MrJuy7yEB7U6T9Ma0v4jM4YDa7RKThx4wUFoVPCQ9XStVgP91vtvXkSNoagp8hsQ9PrKBpNj3QBp3l/wrQomSe95tciXN3iLp5C3GdbCSVHIcCEFqoq6ZXXs94hzdvxUsnz3AZEmvJ7J7uuTfVeFGDe5l7FKqDWmXAqMlKbvPm/TKdV/G1mmzUY25+XjzadE7ifRxFo5NNUpSSw/a9AyBsGuPKuWmrbQCxxjj/28nUsUNlXU97F5e5SnJc4dvXCmp3ah+hFxEhs1C/TL43Q+lFDvyAv035b00VmTso5hQNNVSrutDGIo910gatW1J98ZMk8/1FIjHgnNexnAYz3teqccMjJG5slqisTnCcWxuy8+d+FP+prl3jWNHzPo9BSM1T1dEdLVCVcsRLH5/YWVaWfdNYv16o2c15bc1vuV1LOiTWZxirFkE0yOd/0bbkZYgCuXdhQYZhdBuCZFKeHBRaG1KtfYHtEKTcbdhXneZ34nsmicE+eKbYE3vYKDhuncNPDxsn3B5AP6ycIxnearc4ucGLe4bU+Ak+T1LBRcx/KS9NhiaPremV41ETOplCbw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(3023799007)(56012099006)(5023799004)(6133799003)(18002099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c30Y/KS+k5urzD2bLv+Ggbqe0oIH9MmXH7hSsxplYa7f/5DHM1wQz7f8d0h+?=
 =?us-ascii?Q?J+bRLHUISb1XxoADHIDvyVm7ClZKnRURc5ifL2SrAtVafajdulh3R21K9RfT?=
 =?us-ascii?Q?U+jleIF9uhKvLid4oD8xiHVVV0WzGVDEoqZScthyEsHLq5xUJJcT5+ap2MrC?=
 =?us-ascii?Q?5KXfjkZuIpPwMTfFC5tQuqFJLmkJ5UIaul37a99b5i3tSWbCwuAH8F9R4U67?=
 =?us-ascii?Q?rhZ/bDFswpv9JbH4ZwQ7P7nNEmu0/wESVZrLwDt1txipILI3LQ2Qm2qSwprU?=
 =?us-ascii?Q?3GP1VgQtdu1j2hwFZQCRUyWsAkTBkC/e3G0odoNPDQe34o6WuBxxpN/oICmE?=
 =?us-ascii?Q?ZUmu1A9xKv81T7zch/+AdzOI6yhlwJHj0ts1H2RAq7Ywh40SSutwzvBXTmST?=
 =?us-ascii?Q?O3KkQUNPWtVIjjZa1gqulH/Syk/hU+bWbmscCbkegnG+kXv4+BJddU2HbjU+?=
 =?us-ascii?Q?BoOfrtZWylGx5umPrKmed7HKwXi5dCOFQhC1WPIQVfgfGgITUrMVcEbj1pq4?=
 =?us-ascii?Q?6vAVjSpSkwQgsqMzQWN5AEtt/L+J9znAlx62nVcDRxYWecoqynpuL1ehOAzP?=
 =?us-ascii?Q?l0vFrhAkcZ/oEnutFsIoR0U7Miu/mrkgT8nhpP0YuwdYtDBvPHzUPADk49/o?=
 =?us-ascii?Q?aVdTHVl8bMlv7iEwwY5vjsj/uOVGz3dhRAZfFvbIQZcd0A1NHCm2INHWvr8z?=
 =?us-ascii?Q?JwtpAVsZMrGLWwLCuhHL0c+sB3bHSe2fLgaDi2iTiZCFJVdySM1BwTeq97z/?=
 =?us-ascii?Q?8sgwhelO2CDIcKOKzkBZt8I0klQs04JFJN5VMG+cPBQoazVCE+5zujfkwjMj?=
 =?us-ascii?Q?6JagnbpsZBYeqwJAQIBzT9T+JnmmIqGPgtT0qSgkymFcEK0J2SuJnzlePMTB?=
 =?us-ascii?Q?We+CFUva/64g6MCkrw07m32F6yPueVI+VqpHb78G6h89qL7Rf+yi6zW1CFe5?=
 =?us-ascii?Q?eo/zoiB2VvsUB5Gsrqr+YfeAuvqJsSZLnKOlq4iSMIF+/iQh3SdsrFccYCDS?=
 =?us-ascii?Q?1klZXYP9VN9d9HzWz2IFt5FLl9GnCNzZJKgeozDiZyArNFJPNy+V+p4c6Wxv?=
 =?us-ascii?Q?BUUBNcQqAOFtjUBDoJ1g09gHQFCQaFF3fKUye6MXs21E9tWf5bCiOYINnNUb?=
 =?us-ascii?Q?3B46hd9Aqjpmro8kewVWsPbJh2MC3Mz139vc9zEuae7CkcLI89VWctKhD8Iu?=
 =?us-ascii?Q?Yh8L50ktuMyozC3RRxcDh8vpKvCHmnn9BWWsJEhsXEDwwM1X1Vrboh7uPY1j?=
 =?us-ascii?Q?OHBQAcup9M8GTlY/rFz/mrnPB9xDzpb7vSOsJkLt1+EW/xVixMjb+m+t/7Wd?=
 =?us-ascii?Q?KPMy438Ffkh5oCvARLMgq6EO0QzHNR0/bkI0EC60Egj5eKtdv83W6E7VRGEp?=
 =?us-ascii?Q?/XnjfxfACZRh+c6ANHQbRtPxKZtlXz8sM0opiXSO66NV6qTHxkge9RleG3In?=
 =?us-ascii?Q?nM+qRQId9H0bAWAMBX+/0D1DzL+8xLOAKr8vz7te7obofP8NyUk9Dg6bw2C1?=
 =?us-ascii?Q?PTQYMiyJ6dFNBU0nlmPBz/vyEmHEV3y/KKvJ9QPz1mUW+fTQVsxDy7AZUjET?=
 =?us-ascii?Q?3pJHUQcE+DZ2LNHAMU0BTcso8yjn9KOLYJkFt8FoAIyvYEUPv3U3JgGxjb8W?=
 =?us-ascii?Q?ur09eKjDiycm0Pwadnm/q86K0Wy/bS6JxvIZWjSb5Nop+aaOPqVet9mPgotU?=
 =?us-ascii?Q?m/4KCh0JZ36wbvTnwfjf1cFktbaHk8FF1KcaGdGehS7uLG5LzbGXfcKjNuZT?=
 =?us-ascii?Q?RcFdS7Nu8s2r88pbgaskwnfq5DQ7NCI=3D?=
X-Exchange-RoutingPolicyChecked:
	BlntYi+l/AkH6lKntySiHRZCtvzU/TnM+9EUEbzocq/1l+JKylHSa3pN/rb3+kAAdEacbOtBKPeyJDL8W4ehwM/GpFKFg+C8Z3Yp8U8Nw1JKFgDnAJLy76ER9EV2OyMsPy/Oj5eIlWO0oRHnibOrKYY4yEr4VAfo3ifiLuV7CNMz91gLzYqUYOoQX3Yxgsfw6EXQTEdpPsYZo7/viDAKR0T3D4fb1hIpHkI2e68NfJGul255Zngv1AoHCl3jFcLDM9gcVo9rh1NkAjI/FuzGtLXtfWaZLeZG1ymbK4tQeLsBEKp8ff/+Qb/1QLFaxrkb5/J7U2eOzKcLr++joP5uPA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47728804-8a38-454d-f90b-08df17dc7f3d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:14.3856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +V1Tgd/ChPCJsiCWsriswwjiQeczbgD1c8011FlLyFkp8zHn6Cjwk9XjzdBu5hNapGv8SdovNwal2NIgqNZW7IDO+PG09dVt0oQ6QxLhIe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab1240d cx=c_pps
 a=D36mN1iAOhB4wCSKYjc05A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=1FbX_TXwb31QU-7iG6oA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX6uOk0a7FEJ0N
 yow8n2uvYmU9aJaZopz7zEZrAgtEILDyoOsQ/RrXoVxUbkZGLL1MdteCpfb9IvjZpHRSrBaaHvA
 0QFtvrJvCScLRqLmfZ3XMxGV6Y8pX5k=
X-Proofpoint-GUID: zfJpw42KRotE5qTqBd8jResXiizQTYJb
X-Proofpoint-ORIG-GUID: zfJpw42KRotE5qTqBd8jResXiizQTYJb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX6QirgU+J2+6z
 jZSzWfsdNrfzkfXZqwso/FBo7AS9FNMwKT1KSLQcTlJyV6puWcQ+PoO5r4KoYGuPcMStusSjx8T
 aoZN8+ph+SQY3F2MMXID8LBrr8vma3ttyqIhSdhjLivTi+QKYtUYeRbgVJ2UhkOuclY3J5M6jnF
 OLaN0w2W0CW7/TA/e4t6BhEAVm4gZPt9uE6ws13pgY+erpgF9/+AffBx6L8u97L6+XlL3TtSVel
 OMRj4LtHL1W27NSXrlp+oCJQKElra/zzZReuIIT4XBBeuexx+mAsXxXJH+Bqcwsci9+y60xPRbN
 vOaNYdO3wy+tIM+5Y84bPeABfZyvoul1rUY5HfSPGz0WcmksJI9pK3XcRrVZr2EuR+/7ts9j45u
 FCFjbC0vOAtrzgmektkpPuKMnY1vn/Y2tBNoolGQ50+TkllMLuqIIzWeeGCXGHF9OlqTTPgDV3L
 87oIodg51MhkcTp/HCA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Hi All,

Here is v4 of the RFC for named CPU models on Arm64/KVM.

Background:
=============================================================
Currently QEMU only supports -cpu host/max for KVM on Arm64. This blocks
live migration of VMs between hosts that differ in CPU features.

This RFC proposes hierarchical named models for Arm64 under KVM. A named
model is a strict contract of the CPU features exposed to the guest, so
the same model resolves to the same guest-visible ID registers on any
capable host. Models can be customized further by overriding individual
ID-register fields (e.g. SYSREG_ID_AA64ISAR0_EL1_SHA1=0).

On top of the models, this series adds the QMP introspection support on
Arm that the management layer already depends on for x86:
`query-cpu-definitions` lists the models a host can run and reports
blockers for the ones it cannot, `query-cpu-model-expansion` resolves a
model to its full set of properties, and the new `query-cpu-props-info`
reports the values the host supports for each property. The aim is feature
parity with x86 so existing tooling can consume Arm named models with
little change.

TL;DR examples:
=============================================================
  # Boot a named model
  qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...

  # Named model with ID-register field override
  qemu-system-aarch64 -cpu grace-v1,SYSREG_ID_AA64ISAR0_EL1_SHA1=0 ...

  # -cpu host with ID-register field override
  qemu-system-aarch64 -cpu host,SYSREG_ID_AA64ISAR0_EL1_AES=1 ...

  # query-cpu-model-expansion
        "model": {
            "name": "graviton4-v1",
            "props": {
                "SYSREG_ID_AA64ISAR0_EL1_AES": 2,
                "SYSREG_ID_AA64ISAR0_EL1_SHA1": 1,
                "SYSREG_ID_AA64ISAR0_EL1_SHA2": 2,
                "SYSREG_ID_AA64ISAR1_EL1_APA": 3,
                "SYSREG_ID_AA64PFR0_EL1_SVE": 1,
                "sve": true,
                "sve128": true,
                ...
            }
        }

  # query-cpu-definitions: blockers reporting
        {
            "name": "graviton4-v1",
            "typename": "graviton4-v1-arm-cpu",
            "unavailable-features": [
                "SYSREG_ID_AA64MMFR0_EL1_TGran16_2",
                "SYSREG_ID_AA64MMFR0_EL1_TGran64_2",
                "SYSREG_ID_AA64MMFR0_EL1_TGran4_2",
                "SYSREG_ID_AA64ISAR1_EL1_APA",
                "SYSREG_ID_AA64ISAR0_EL1_SM3",
                "SYSREG_ID_AA64ISAR0_EL1_SM4"
            ],
            "static": false,
            "deprecated": false
        }

  # new query-cpu-props-info: supported values per property
        {
            "name": "SYSREG_ID_AA64ISAR0_EL1_AES",
            "supported-values": [
                { "min": 2, "max": 2 },
                { "min": 1, "max": 1 },
                { "min": 0, "max": 0 }
            ],
            "type": "number"
        },
        {
            "name": "sve",
            "supported-values": [ true, false ],
            "type": "boolean"
        }


The series can be found at:
https://github.com/khushit-shah-nx/qemu/tree/rfc-v4

Changes from v3 -> v4:
    - Rebased on v8 of Eric Auger's customizable AArch64 KVM host-model
      series.
    - Stopped exposing reserved ID-register fields, as suggested by Eric.
    - Converted appropriate warnings to trace events, as suggested by Eric.
    - Split the per-field ID-register writeback refactoring from the
      special-field handling.
    - Each model now has a separate patch containing its final ID-register
      state and architecture references, as suggested by Eric.
    - Removed the non-zero-defaults named model layer, as suggested by Eric.
    - Disabled PMU for named models.
    - Added forward-compatibility: reject a named model when KVM exposes an
     unknown feature ID register with a non-zero value.
    - Split query-cpu-props-info's generic QAPI definition and its
      Arm/KVM implementation.
    - Moved query-cpu-definitions ID-register blocker calculation from
      generic Arm code into the KVM-specific implementation.
    - Dropped the narrow EL2 writeback workaround; this is now handled
      properly by Eric's v9 series.

v3: https://lore.kernel.org/qemu-arm/20260716213858.609699-1-khushit.shah@nutanix.com/

Left out:
    - CNTFRQ_EL0 handling during heterogenous migrations: This is not related
      to named CPU models, will send separate patch for this.
    - SYSREG_ prop and legacy prop interaction/consistency: handled by Eric

Khushit Shah (25):
  target/arm: expose SYSREG_ props for REVIDR_EL1 and AIDR_EL1
  target/arm: expose all non-res ID reg fields as properties
  target/arm: move SYSREG_ prop infra to cpu64.c
  target/arm/kvm: enable writable implementation ID registers
  target/arm/kvm: read all ID registers from KVM
  target/arm/kvm: handle special ID registers when reading from KVM
  target/arm/kvm: process ID register writeback per field
  target/arm/kvm: handle writeback for special ID register fields
  target/arm: introduce named CPU model infrastructure
  target/arm: fix SVE and PAuth finalize for named CPU models
  target/arm: disable PMU support for named CPU models
  target/arm: add arm-v9.0-a-v1 named CPU model
  target/arm: add neoverse-v2-v1 named CPU model
  target/arm: add neoverse-v2-v2 named CPU model
  target/arm: add graviton4-v1 named CPU model
  target/arm: add grace-v1 named CPU model
  target/arm: fail named CPU models on unknown non-zero feature ID regs
  target/arm: add cpu-models-stub.c
  target/arm/qmp: allow named CPU models on cpu-model-expansion
  target/arm/kvm: compute host-supported values for ID register fields
  target/arm: report 0 as supported for ID fields gated by vCPU init
    flags
  target/arm/kvm: add kvm_arm_get_host_isar helper
  qmp: add query-cpu-props-info command
  target/arm/qmp: implement query-cpu-props-info for KVM
  target/arm/qmp: hook blockers in query-cpu-definitions

 docs/system/arm/cpu-features.rst              |  34 +-
 hw/arm/virt.c                                 |   7 +
 qapi/machine.json                             |  82 +++
 .../update-aarch64-cpu-sysreg-properties.py   |   9 +
 stubs/meson.build                             |   1 +
 stubs/qmp-cpu-props-info.c                    |  12 +
 target/arm/arm-qmp-cmds.c                     | 105 ++++
 target/arm/cpu-idregs.c                       |  19 +
 target/arm/cpu-idregs.h                       |   4 +
 target/arm/cpu-idregs.h.inc                   |   2 +
 target/arm/cpu-models-stub.c                  |  18 +
 target/arm/cpu-models.c                       | 536 ++++++++++++++++++
 target/arm/cpu-models.h                       |  38 ++
 target/arm/cpu-sysregs.h                      |   2 +-
 target/arm/cpu64.c                            | 139 ++++-
 target/arm/internals.h                        |   1 +
 target/arm/kvm-stub.c                         |  19 +
 target/arm/kvm.c                              | 521 +++++++++++------
 target/arm/kvm_arm.h                          |  57 +-
 target/arm/meson.build                        |   2 +
 target/arm/trace-events                       |   9 +-
 tests/qtest/qmp-cmd-test.c                    |   1 +
 22 files changed, 1404 insertions(+), 214 deletions(-)
 create mode 100644 stubs/qmp-cpu-props-info.c
 create mode 100644 target/arm/cpu-models-stub.c
 create mode 100644 target/arm/cpu-models.c
 create mode 100644 target/arm/cpu-models.h

-- 
2.52.0

