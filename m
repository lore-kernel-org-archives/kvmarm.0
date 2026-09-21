Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473D04973A5
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994035; cv=fail; b=Hd3VaR+x5aCeLkCDq3CRw3ctfg36evy0irLSde1G+HD1sijtEZXOg1u0UUnq1Y6NM12sTU5Ktexze2Uu5cOvddTRhOK/WeyTVdjNab9AlSKMVMYPjjjppixxNAgPbxVyOH91fC+ztR0A/65iN1G4b+s+swHPGxukDL7MFOhDPwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994035; c=relaxed/simple;
	bh=q/rhrzISq9ZtFQa7nU2N734EM4zckUa1q/MTkW1K2ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=svn5MgJtuhyPMKutS9x2225/WzGdzOzPswCqlR4O6mU3DQlD+cPmvmjE0hkkYbeKqPVrMPddjd+/ag6le17iYi/OIgbqtcKqG+mlqbD13ThS4dl4cNpmbswx4thsbBm/z2TXpVUGpZg29lRcsGWBUAZmt6kKyuS07ts4nJkeX0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jzibel37; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oOfNkiF/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jzibel37";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oOfNkiF/"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAiHkf520340;
	Mon, 21 Sep 2026 05:33:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=lecJGAnvOFYQuF9ewe36GTjL35wQQq6E5H2AiTY03
	HE=; b=jzibel37Cb0ypNGuqKPU1olXFSYyAoCyqNDM9j9f4hS9PP/x+dCuE+IrD
	EJP/3owAJoAfZnBp7b68XhLZvFw6GU1iXV5gz/wSxQnWnq1mXVdbRlPGAji0qfG2
	7Vg50/zE7HljlhG6yNh1j7zx6EEgWCyljm+0bY1NWWcFtjVStb7JS7yNFSRBZ2pv
	sXD+dFRwjrNWAz2qRYH3Zcj5mzoLtfvCwYz4hVSSPMRZISqf7sJeWhVKPXipI25S
	2kmN4QAYd0numeCNj1ealZCYI5UG960cutHfH8cQHH+JWSypwRl6HctKvC+BiSh7
	1ryBtLwkD24VBaDbibnYQoq0/frbg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022131.outbound.protection.outlook.com [52.101.43.131])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspqsbhps-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GbEwDS9fU5k/td7P71L9OEZVUWFZGIXoh9Qg/gSMQTyswvRAq4a84irp7weHv2B33TXAZXJ28lpmIOLyTjcITNDF+JIjGTfWa7R16yihbM5bWC7LKN61uksSg5SDb9C8owhBcaSwBeezWVTIhWZVMkYtluVJzF7PG4eA+Eb8y91UJjhpiaKZ0xXfZuFNlRxopTOZcbsPGvaUHCxhAiihK8yK/yeb7gdsipfuDTFLKmEhN23A5RFeABbKZTyfLgR2nplLm4OUuSyt8Dso/u8eBDHKOS9iOWZGZLJrNc5Pwui6uLI37jTCOTF2POK1W+086v95o3RYJwr1OogN6lDN3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lecJGAnvOFYQuF9ewe36GTjL35wQQq6E5H2AiTY03HE=;
 b=mjT4dXUXnW8VnwVsLWJBeibslYjvL6Mxhg/jLptkRz+xIw1xc8hT8fj7ZWnqoSVwZ7MhiS70uXfpcODyYO2ggDBR9b398eqpwi5pGWvLvZmN87IVxDERIA2bqKLIcDh6K6HwHogT0lfyOhx6+WRyomPPRD85fpvNiF2m9zP0LnbmNTeoV23t/dg/PhR6wXbTyDkNk0PZ4RSk3UsKNPan0R0lpAjeLnQ6MugvEUhuB2N/h7O1bCCKIkihEdB/uI4CJYkKNuab05AMXV61RxKJZQtbSC5u1sJS1w2aq7l+r8y6xvThakLdtGGYW1VD1INNsd4T28SQ3dLabtWo8kGzWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lecJGAnvOFYQuF9ewe36GTjL35wQQq6E5H2AiTY03HE=;
 b=oOfNkiF/yqkMDBpZw3+sVU9eQf9OF6J7TxwMPpC1RMu8G21J039qAfhjm2cqW7Jy80gpVlwyQM3OVllraH68JQ5qDhdh8e/704CpmnYcJphWkaprhAFvxUvleb3gMEfTj5sSog1xdjpHgvjf4+dGUIstqXlGyhpLSjjCRoSjH8B8NNqK6/0kXlpAPuN5yNlwdnG5pWqI9KzUmQ98JLYvuxYtcPGb+WagGIspQXCHfk1m2ykzNT57NmydynG0y5z3/WugEjeg68Z/GqQqdXCUSZsorU21tpG7hyUc95ISOr+uj3qNk33SlXATz0+tdSxFLQvZOosdJ6mVqbS32UrInQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:35 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:35 +0000
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
Subject: [RFC PATCH v4 16/25] target/arm: add grace-v1 named CPU model
Date: Mon, 21 Sep 2026 12:32:40 +0000
Message-ID: <20260921123249.1708067-17-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BY5PR02MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: 250b3c2d-af5e-4894-6571-08df17dc8df8
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Ld0LlsReasyME84i9bkEWwS3PM+L/EajUwSx/FhS+gFBT1Zyw22vhQ8PjKp4DYLz9rjsDG4CY6be1PRFBffBl2f/kPNF8jSRZYAuNDBDE+Be12S4qOqbgJrhrurMWTXvY/MKnbyaJ2Dx3uYkurhUOraOQqMqGbU9DbMBRUfd+R/pXJSNPNpMUSXAeESDGzpYro92qXpKAs/tX79YvDZ35WLOXYbL/oMPSXNRekJD2yODtjJFODdpzKH/G1VCMeId1pJp2GeIIzAmtO1qlisE7ZeM+yl9zj/1Pv3BB/kk5/eSupNXchgQh9Iemqk8YiiIEGIc8lZbtGIgX390C++XXOUDUeIQyqhG055biCCpr+zutZ3mD/LjMK1LCVGnU2W5XgCuMJTAICzz6LLB4O7NmdZjx2kGlX7kq/COVo+OLf/dDyCHye9OELkV/7ucT1bxq2fWAbjxshgEncW9Sl3M+L3eaOQ1rHz0fGmh/F4e0a3+Ed/bY5ptnHCZWi3IpsevWMWXKUM7+p/Yn3C2JqrHxeZqSgsytUFegU+CWACwmGnfqkU31zemQpGvMOmDpBS6RnbUKLs2Mx9G4qVsDC8Oy7tDgakFuxoQDuR7F4wnNVXiJeY5odU6h8p0e0VmqCWaN6NGsqIIurIw97Ivhp0KkfjzOnUsRdoTg+RrHRr3L/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uHwUYreuO5rhiJtVQMbC+j7Z1sVj1CY3pcFNiAbzzIjnk85TK6Yk6Legx+dX?=
 =?us-ascii?Q?z17et4fC2eAYsI6MKKT8oTLRtMdcUiPbzQYdeXY6L5nBDR32eeeFjnAy5OZk?=
 =?us-ascii?Q?pPXci+oZ9NWVo2bRZBCciuxgSk/ydS3au8MaGlFs7zutCYLIGL2auc+ss2bB?=
 =?us-ascii?Q?MkH5l42Ta65I1Xdg1oRQvsJJW1joU64aurOwrxYfEOz5BIejI56x3bP+Nf8d?=
 =?us-ascii?Q?4ck0/5mpBaCfVXqzLpYR0wDVtIqM1fOTLR5QL9vXZB38XGP3jvEuWJICZqOQ?=
 =?us-ascii?Q?jdH1VMWCQ/db5HdoWcE/35HDG0x5iU6Ve4UWVsJBQLs5nMs14F1wDB1/6XC4?=
 =?us-ascii?Q?YcX1vYTQARYnjRwMF6huAqN6BP63IxQb7d+RGlP9yewW0zSVBJfQXi57AFAp?=
 =?us-ascii?Q?uTFcOyIQQ78YuFiyjsrfRb+GhE/QcK0HftmGcVT6QbfYFx52+o4ZEA9FJxgb?=
 =?us-ascii?Q?BDi04NmeZ3XaBWZFW9iPTFf8DTWch43OVVz2x7cUudNzXgbbweOqDnPQyzYu?=
 =?us-ascii?Q?9hvMItdeuXBW7zkcAC/fEGeZUHyjUmV5NO02hWWoF9xNaHdeL+SGYM3M8YAq?=
 =?us-ascii?Q?KDgQuh0e74wAnEHKS+y36k6VclmMWOtU3O5w13oABTh1SKcOytWnViAeO+PJ?=
 =?us-ascii?Q?gY+GNaOGT1+99Mn+OFbQ0KCbQlQsEErefKXzd3BBBFTv4fUcen2srVAoqJ6H?=
 =?us-ascii?Q?M+7QwCb25wRkr8roYp3wv9+0pKFOMr8Jx33U1nIzlc6MV4Uz3acOgzork6hQ?=
 =?us-ascii?Q?6P1qH5SKbi2Jo6p562mdc5Xy5BvHeu9NLaWEFP1Rbb3wj8rG8pqrz/ncb7Dv?=
 =?us-ascii?Q?EDsUmH3FbdCDPY4CK0Qq7g6zoYtDYZVk4Ihs0u9Iccy3eeZsetAoUgoy386x?=
 =?us-ascii?Q?KLgO7589DD3hDWVaietcvyvebnOKnFRsbBkoDeL7UGTWhNfMJhBEOxFvuz9B?=
 =?us-ascii?Q?29QKXKXHcjCZe9rTi5KlXX8ovk46+XVrmb8nTVsdrhYVsXKQ9depKDQNO7X5?=
 =?us-ascii?Q?dZDQB8KcXiNGSi4LYw7p8B43Ej6eLn6kqf3edxbqbO4FnWcI7PHZkArrbaSn?=
 =?us-ascii?Q?ccNYFq2rKuHpij0Slpcf9K7KPVNtTCfttcD0xCuj1COh4JHQ28Sgzgk0CoW6?=
 =?us-ascii?Q?GF5K2C0nE+uIgTk8C97BSNzsVrJrMHoom5A/eqi7juVjWeOTkv+GBGr8PA7P?=
 =?us-ascii?Q?k/GqL7ier0SNzflGeHVW0vpsyCjUm3HCAolpx4M5A/WZetkleB5r30+D+R/v?=
 =?us-ascii?Q?PuDKjEA1HPcdnRvPsxGjupB/pZzssf2jzyzfpdTPwjT2hkXMnEp9th0eukH/?=
 =?us-ascii?Q?pEb4PZsZ2WVbeoj+l1Z67FiiWQnkSycNGTAxX+ju+AkHXI6gboM40vvVxAco?=
 =?us-ascii?Q?taGYSORUf5tgWGLYrMEnqw3YEcpGA9+sRw2R5LKhWIyPiEm2WFbO3BZA8UP9?=
 =?us-ascii?Q?fLVGwgVG7gkpncnHFz+CvkWgArHH0X/b6o9u/FSgSIt+0uiCsA3uNqDUSOqw?=
 =?us-ascii?Q?bovWBT5Gnq48FbbHy2vNaIyEmDw/HwTTwKgv8imFiOfSPwmI/F02nv8ODcTC?=
 =?us-ascii?Q?RkN8ePL46YVjr3skYl3mcVLZt1Z4nzK2QMqo+5l3R41FFb09KQWXpx64KL4W?=
 =?us-ascii?Q?tr3umAkXyJYx7gGXxlLAZ1qe4Z+PhHHRuFPunhlW8gjk+z+xVK1VcmD1j/xy?=
 =?us-ascii?Q?/9sqy+pG3/myR6hEt7okTaRb6FVtIrstoz4YFisGaom42c72jYLKuJcbDBFH?=
 =?us-ascii?Q?z/qi+gd8M7tkwWqGmQXI1WJmuRfgXyE=3D?=
X-Exchange-RoutingPolicyChecked:
	UOcE8d+8hnyPsuRA4w2v3YNEqEHFa8dNCPg0CW39YyqyeXQmFoCj507n3F82YpkdBpVYp67aX9SY4TLyO0URV8sPcSY562qxOBzZ3+ktzMRGM2H5F+gZ4PGBVNNOF585EZyx+VFuPjmzDSeUcNDvO9qi8pGXbhhAshleNTuiusZS2so69iHQp7Q+XpANqkw0GBjSc3ozZGx9aFxge7rsUAsf6BJooTibusrWfw+OHwm7Ali/LGcsJ5HqC0e0Y2hy1M3fNvMTuRssuwq47ZbdLMlGhCMPpyVLg50m77yWiczkNumHoqjVrKN6yiFIhqNjQWDk/4XjL6aIFtwmVFp+zQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250b3c2d-af5e-4894-6571-08df17dc8df8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:35.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OX3p5QuvO0/bujd7CRmwdR+pE/pAREHXqaKG7+cb5qi6tNdbrK4aRnlCb67Eb/PJLMPAGXx7gyjTS33sW/sPFaMLvwLFfJGHvVimEfesuno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX3ZCDnB9lCAGs
 FFmc1K8BE4hqAXI6yMINHbEAeNHP8vQ8e9dw7n+qKMvqFLaH39HfckljhIkermqPApcMTbjFMJW
 SRir7+npb/44whLko31V23A4ERPXQn7haWU7dhVGyZRIKzXrs/CyFutkcfEBe596cjyBuY5qs/f
 jPkCYlm9u8lkOAOXWplW7AP48DCu8gqTFrC5l3TQCk28wZQ/Ck0YjV32nMSrn1x+Y8yohquXF0p
 eWjtCw5bZ3u6TEzqmkRPOUusePzjsTvD/B2WivVlqNs/bNmVVkKlAZpZUbxEz+wHDQaeEWEIe1Y
 T9kam8d9U+4NKMsQyr/QhsbndVuqoqdBHKp9eR+2ImMH9w4yaHD76KZOydJ+tqKwlrsPGbPzPDz
 56XEAb4mwYC0JgSs/TDvseLpJETByOVzh+0Ih/HzAT4DZZ4eBRfyp6/MlLIGQRZQrbjoI8fj7om
 IQlSZXdKoyIK+jUXN1w==
X-Authority-Analysis: v=2.4 cv=E9BYNqdl c=1 sm=1 tr=0 ts=6ab12421 cx=c_pps
 a=WiodiXt0wH02q4ozJLtFAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22
 a=64Cc0HZtAAAA:8 a=irvVlNVXBIsn0KuwmqQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX+UtxjYMPKXEr
 8Y5jeZjYTnXGuAyJE1rloXKCAZ4IAe8gUWcabtWtupVfwzM/IwWQoJC+bJO5FEE4ZWbpnq8Srl9
 NMI0EU3IJnm7I6qlJG31QycSMQ6XEb0=
X-Proofpoint-GUID: 1hKUesYxLB4VDu1X1IB8kPDorf3ULvKk
X-Proofpoint-ORIG-GUID: 1hKUesYxLB4VDu1X1IB8kPDorf3ULvKk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add a KVM-only named CPU model for NVIDIA Grace, inheriting from
neoverse-v2-v1. Because there is no public Grace TRM, this model is
based on ID register dumps from actual Grace systems, which appear to
implement Neoverse V2 r0p0 with the SoC crypto opt-ins enabled.

The extra properties are SM3/SM4, SHA1/SHA2/SHA3/PMULL, the matching
SVE AES/SHA3/SM4 bits, and CTR_EL0.DIC.

Final ID register state requested from KVM for "grace-v1":
[  0] AIDR_EL1                 = 0x0000000000000000
[  1] CLIDR_EL1                = 0x0000000000000000
[  2] CTR_EL0                  = 0x00000000b444c004
[  3] DCZID_EL0                = 0x0000000000000004
[  4] GMID_EL1                 = 0x0000000000000000
[  5] ID_AA64AFR0_EL1          = 0x0000000000000000
[  6] ID_AA64AFR1_EL1          = 0x0000000000000000
[  7] ID_AA64DFR0_EL1          = 0x000000f010305009
[  8] ID_AA64DFR1_EL1          = 0x0000000000000000
[  9] ID_AA64DFR2_EL1          = 0x0000000000000000
[ 10] ID_AA64FPFR0_EL1         = 0x0000000000000000
[ 11] ID_AA64ISAR0_EL1         = 0x0221111110212120
[ 12] ID_AA64ISAR1_EL1         = 0x0011111101211052
[ 13] ID_AA64ISAR2_EL1         = 0x0000000000000000
[ 14] ID_AA64ISAR3_EL1         = 0x0000000000000000
[ 15] ID_AA64MMFR0_EL1         = 0x0000011100101125
[ 16] ID_AA64MMFR1_EL1         = 0x0000000010312122
[ 17] ID_AA64MMFR2_EL1         = 0x1221011110001011
[ 18] ID_AA64MMFR3_EL1         = 0x0000000000000000
[ 19] ID_AA64MMFR4_EL1         = 0x0000000000000000
[ 20] ID_AA64PFR0_EL1          = 0x1101000120110011
[ 21] ID_AA64PFR1_EL1          = 0x0000000000000021
[ 22] ID_AA64PFR2_EL1          = 0x0000000000000000
[ 23] ID_AA64SMFR0_EL1         = 0x0000000000000000
[ 24] ID_AA64ZFR0_EL1          = 0x0000110100110021
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
[ 44] MIDR_EL1                 = 0x00000000410fd4f0
[ 45] MPIDR_EL1                = 0x0000000080000000
[ 46] MVFR0_EL1                = 0x0000000000000000
[ 47] MVFR1_EL1                = 0x0000000000000000
[ 48] MVFR2_EL1                = 0x0000000000000000
[ 49] REVIDR_EL1               = 0x0000000000000000
[ 50] SMIDR_EL1                = 0x0000000000000000

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c           |  1 +
 target/arm/cpu-models.c | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index e514d167cd..d5ff7cf29d 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4149,6 +4149,7 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v2")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton4-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("grace-v1")));
     }
     if (target_aarch64()) {
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a53")));
diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index 1a8913e619..4e92909755 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -18,6 +18,7 @@
  *   neoverse-v2-v1 (r0p0)
  *     neoverse-v2-v2 (r0p1)
  *       graviton4-v1
+ *     grace-v1
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
@@ -225,6 +226,27 @@ static const ArmModelPropValue neoverse_v2_v2_props[] = {
     MODEL_PROP_END,
 };
 
+/* Based on neoverse-v2-v1, with opt-in cryptographic features. */
+static const ArmModelPropValue grace_v1_props[] = {
+    /* ID_AA64ISAR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM4", NUM, 1), /* FEAT_SM4 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM3", NUM, 1), /* FEAT_SM3 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA3", NUM, 1), /* FEAT_SHA3 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA2", NUM, 2), /* FEAT_SHA256 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA1", NUM, 1), /* FEAT_SHA1 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_AES", NUM, 2), /* FEAT_PMULL */
+
+    /* ID_AA64ZFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_AES", NUM, 2), /* FEAT_SVE_PMULL128 */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_SHA3", NUM, 1), /* FEAT_SVE_SHA3 */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_SM4", NUM, 1), /* FEAT_SVE_SM4 */
+
+    /* CTR_EL0 */
+    MODEL_PROP("SYSREG_CTR_EL0_DIC", NUM, 1),
+
+    MODEL_PROP_END,
+};
+
 /* Based on neoverse-v2-v2, with opt-in cryptographic features and RNDR. */
 static const ArmModelPropValue graviton4_v1_props[] = {
     /* ID_AA64ISAR0_EL1 */
@@ -249,6 +271,7 @@ static const ArmNamedCpuModel arm_cpu_models[] = {
     {"neoverse-v2-v1", "arm-v9.0-a-v1", neoverse_v2_v1_props},
     {"neoverse-v2-v2", "neoverse-v2-v1", neoverse_v2_v2_props},
     {"graviton4-v1", "neoverse-v2-v2", graviton4_v1_props},
+    {"grace-v1", "neoverse-v2-v1", grace_v1_props},
     {NULL, NULL, NULL}
 };
 
-- 
2.52.0

