Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663DB48F01E
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994037; cv=fail; b=Tehs21WSi5ota6r20iggPZ7PJWUa36BLZmkGY6Hqc3vNPiWnLU/zy4uio/IPfV2cOis1Bf25CJRBf0lDKY2EuUIcg2pLeoX6hnh7IlVvO627efk9b23KoGYSEGYcbGbnt4v7LkoR7dI8kV80L5R/Xi75JglxI+WfyZnNynD9tYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994037; c=relaxed/simple;
	bh=Y4hwauu6wvP0hvrETMe4N7eAimV7gf2WADOxd6hR4v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UnSjqYeqK0T4PXZG9RK6pAwPIZhc6FMiuqjjuIkQ32oBnqru/FezYKgRNAb7mV3T0y7LfRx6ltuFGU+Be0byilMydZtWnfZxZjDyxIrQAOw+hikOljUATy4OZB7OE1KFnSyZdlw2e/NTMtEPxMQ5Tlh7d77dLKAmAIMk2D4cu9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=x+HOwtQU; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hCNWb+Fv; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="x+HOwtQU";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hCNWb+Fv"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAiHkh520340;
	Mon, 21 Sep 2026 05:33:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=bEQ2PUeyV28GSDHO3NMCToXidzho92Naq9HxKMTZW
	BE=; b=x+HOwtQUWzf8h/JZzOCP10HIieuJYPWROm6x+OqsD9pTjaMixDjxSZc2m
	iHHf+TOsPPe7jWFtyYRYl9DsOYviQDvbdeohFS/axCvKnhUA9/Y4D4AJ5hKsg+SQ
	9NmPcuBhQgLqcbCwuYSHs0TPdpq/Yo4/eoz4KywqdTLVGHXz1T1HdaiqpHaSBZEF
	QogQN5zvvgfTd7IQJ6sDcNzcipKWRotqs7hHhCQeg8Hh1Sqk9z3B2FpQ8B+BPoaG
	yVMtEkHjhcZ4XUa4brfxKtvOmtPKRUfhrgPflvJoAso3W8UsyA40AWHftKHcjXlJ
	YlQFY5cGypLDQRmBjQEgFjHAHHYuA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022131.outbound.protection.outlook.com [52.101.43.131])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspqsbhps-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SN2b9Fz58xvxv8W7tNZkV1DoZy2i1BXw0fyMcyq8t9OC8VXBBMT24tF/nlB9mR/E8UJdFdZlVuI1Xh7MTYqEdd+vTCYwgu6UCx2c7n3I6/CjWl98Q3dkGVWOsla881vJw2AHViT34GF78kaRaxIpXacXlRHdZdReo6mREFX77tIaGwgg7aF8eoVbuykYq866lnxvsN4DCBca4Ssrqetovro1QQKPLrDGE8qlQ8mUHum4EHc9LHIQoCulZjQcAWP2dMBD8NZGFYi0JmTfx7vxQj1R9AAgXVeYMbbAa8uNukFK6zTuQ8RE518J1OPssN8ekbwW8uv8DyDv5tM5lzcBUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEQ2PUeyV28GSDHO3NMCToXidzho92Naq9HxKMTZWBE=;
 b=OR50OX6Va04egz0TxzJ5dNk/ljYPXV/bgzfanGHf+ikrSShSZdKv9R3vpxX6ysye5zkKO1dDW7cKIcu4YwA9U0NZ5vSGzHwo2ZR96SssdkqTl2kp25qhcp6kRzbWBttbcbgzY5uJqqB1E8lNr+JetPDR4HjDgN3RSRmWqpwayipwdmSaQD6jjeW87wID2MCbaJYvbhGfqMZddR0+UIRGgvYODp4fMHLKGy74Qifxa60xOFMHJ62763f5WYQWRc36o1OV1VjKgJk9hsHQ520i5WMxc3T9aNXnPMEY26KsCC4LUf5kIZpO1FoixlX9X7w3I/tS0I2AQXtn4XylNMmDgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEQ2PUeyV28GSDHO3NMCToXidzho92Naq9HxKMTZWBE=;
 b=hCNWb+FvGCOyyuiDQKZQX5evYnP1teRnlbVpxovNBoeI7HIXFkw+2EHbAE3Y096FXm3f3V/xBXPZySIjgTa4P5cs3tTYwH0LaDbigVhA0oH9hvozTwL8dpLfmDWyccgNHQzxTUzQfg0MPowoPGWoZCrVqs3Xfjw+kKjDJ/y8tnzAcDrp49pPNDo78QkNd2uW37ZGEnRn3MO0JEAlKibAP1cvLFDFNfyjCElGDxKtUTPufzhGi7arzgeax4B5DGOBZlD5v41e58mz2cnlp+odbJD9OtjQu8K6lI4gl/pv1I4AfiEOLefzmXPt2y6dW8D4rZs1WlW8Nz9gwC3H0vMt3g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:36 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:36 +0000
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
Subject: [RFC PATCH v4 18/25] target/arm: add cpu-models-stub.c
Date: Mon, 21 Sep 2026 12:32:42 +0000
Message-ID: <20260921123249.1708067-19-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 18a59724-c72f-4175-ed12-08df17dc8ee1
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	n1hnIimaliyth94r3pp6gx8/GqgUWaWCoWNd2Ie3NXrmX7hUOcGduFttSOGEue91e4uWD+pdftBOYDDGztm4IVfkHPquYbHcuNkvO90wW6gtU+oG49GTfJY2VFYR348oE9m5S0Plt5bDXuOJjtqx1D1z/oefuWtPo+9SUD6T2wS+A54Ew5aXz0NngJeZh0CpX40h32kjTtY+KybViChkJsRItTsWK/Ho7trbIYved7LrODxa3vyKItPzwTmJmgglzjcEnDn2j2MOxbn35jGZ3x3vIwjDVh9BdmIACu5Cm97GjKYOXTOFaoaU488UZUVCGAf2YMfxPIt+W8mFuk3B8RebyJl9fLJVDyBUJ7gVY4gByKFtuoqc/jCFBwJeVtvK9xxo4KdWKnof+MumooLQwGbHzE/c6iHObftE86LMoDrX14B5PCM8YUOjJ74snrsc1MW0QHtOGWPM+2ZTzvkpcZx5Mjo44B2NBA60KKKDGanCTZn81NB6xuEPnMpghCP5gFoDPiRfH/BMkB4KqmWRHxxKkMc+0y6pi2RXQzgcCl7InN5ASiuiw5E6E5hH7Ob1vcWWubFHk3s7OMNTl7r4Aem/wuPQNBkzg8r2oBCCxQIVydd9vZQjuAsULyU1NdNFPMZlebXKrbjp2h5Lud7uICN13vmAIU5eu/TveQxQ2Y4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LfwlirWkhQdt/ObXs4Wog/a4Jf7sBBWIXnXkEspBhGaC1MEvHvxivQMUu6gc?=
 =?us-ascii?Q?46eA5ZF+XpY64nScsPibmaApO8YbvJ8HPjM+4qykmN35fbV2YANWYyIQwwm0?=
 =?us-ascii?Q?3V1oUcVjQFJWmiPD4Oq/NeFwftoh91FPW7x+JjT1lus8CIUqkjwtmBActaWj?=
 =?us-ascii?Q?OGFW4GDKurFoZNOlyMJJ3gvIWNVM07dgGGTM9fx44m3l4DMAwsx66o2HSZgi?=
 =?us-ascii?Q?45Jszwm98yoTCGhRuvBJBjKmoOQ3H58ekvjieuTb6+5OWqyRjDOGSp9UQSe5?=
 =?us-ascii?Q?qby4AFaxXkKhDfSlE+4aZqZU4vf70yHvb/NCAYjDEmen6wXjL0vE630qOCyj?=
 =?us-ascii?Q?oS0D0ZxLQeGsSm+o7ORI7H9DBUKtNcBu8iPVVt94hVZglZCbRJGNibHBALiC?=
 =?us-ascii?Q?0dX4h3xxZGfH11cSRvWReLOwc1v49KgtWSboYL3VvbRBLt5RrAZZ12NGPYHV?=
 =?us-ascii?Q?DVNnMDIA7TVgZa9ZNJQHcgX4MnUaub9FbQqb55fXvqYs88I1rqYO1RkWRHBd?=
 =?us-ascii?Q?XsN3QwATIAvJG0w2QjL7iqfTHe2oEmnDZJv9nVgNkqdPwjiC2qUZKmVz8WDf?=
 =?us-ascii?Q?0BF45veqwAfQNQ9tKBdvoDIgutXN1+KGJJ0MXmWRwbadzQZ8tLNoHopj2yVL?=
 =?us-ascii?Q?fSNbJhraRSMYrswdzK6UJdkJMASH5aoUcEfqdVFtAbSvxVoFVTsc3pqdTC7f?=
 =?us-ascii?Q?lauOf0oe9SVEY0vFY6YTZcOxVKsMRkM2YHGDReP26kS5Dc33RSPELf6mVvb2?=
 =?us-ascii?Q?6hKbvvMjwlNZWxp46k/h2cvj2Yqrf8VrJ0ttwUVKxdPSISJzArDApcr9ASFq?=
 =?us-ascii?Q?9xjZaGafSS/khqEsSxJmlCKOijdyFVrDBWmVQfi8W6pDXzEH/o/D6slrpeIO?=
 =?us-ascii?Q?cJ3Dj3uSJtVwjSRGMit3vnmqmVwlCCCsJbNfifgv6r8GeAGtuAcZw/TkMmrX?=
 =?us-ascii?Q?Ez9Tduq9DqOLy0d533edaw35vm/wN+DH4mE2hjBGwe+UIYNK0PvogabWtgl1?=
 =?us-ascii?Q?FDU/WS4Pbml3qr0O4hvd0xTbRVwFggxAtfDaMD/Sp2+2i1V8rWcS/NGr/2zt?=
 =?us-ascii?Q?QSD6MHvnOU25F+vFsk8xWmViAObBJnMO6OV2Gjb3NjO+3P6cyAOpKEZIPYnG?=
 =?us-ascii?Q?OnbzY0svSDtBGi/OtfofCRZQmbaUGM8hDG/MU+FXOkeQXf7NRxmEH6WVNblJ?=
 =?us-ascii?Q?0BB3AMkR8cAN9oHlvxXZ/ePAifGA6AeNpgMiZmvhq5RLRiQIb7J9XDeFU/lb?=
 =?us-ascii?Q?8lKe4F3U5LNPfPQcKW/dDBz+9n6Ry4d+WeRAuVZjgCMREXOQDnYalbqGx2xC?=
 =?us-ascii?Q?iKLJnsLRKv9gs8xLGi5l9QToFwSOAvjNKgmlJf+tnQhE7dTaufo9JU8MP1od?=
 =?us-ascii?Q?qLPxUFsml/27C4v44HLCNQD/MjqTQ1JES0kVLnrHclZWfc94Fgzl7di6GxZT?=
 =?us-ascii?Q?iR6KK1U5RqTC8Ku+F7tBLlLs3D/bNSe1cjvoogRrxT/iqzCQjxkI3bZAIkqX?=
 =?us-ascii?Q?hrFU50+A5KtDBUtQeb3xQjPI/Xi7AM19RnWcIx80twFWyuwu9dvlEJUk6U+e?=
 =?us-ascii?Q?uQqnMGnrA7RR1uUbWSyteEJO93N1c49pFtvVuCiD6RH5e9Ozw7aO25l1v0YI?=
 =?us-ascii?Q?Al+Q8PhY/Ii3aF/G8+kACaZ6mBIu6X0rFIoImD7V2/sCkcD7gQaUIw6Pe3/d?=
 =?us-ascii?Q?RHSAF0iYh4J63aiY+cC8lyTdBpJmGqrLCCtr17yNl3Kcsso4Aq5Rg737+sy8?=
 =?us-ascii?Q?KS0E5AUcTRttMPhuCIRc9K8koCIjGsw=3D?=
X-Exchange-RoutingPolicyChecked:
	VmCDwf5VGiY2tTsOqzEomzu0+eubZ7XrPJ99kb64rze+y/FKnG94QtFbr1uY4VZC3aHPgBv+7kCMrSuKeQZ+jCNV/oH46yBOjOyfwn7SS+ZTKktiV4c33kzr2c6t7qe7PBY8J8ePzaaIirHiT8vQPDRXVA5CcIUc9QqIxbilhzjkmfY2H6DKUN0zvH8Vie8wl/pHldcsSuBCr7Gixbp1UIvqrgMQwbcNbFeo5r7mr7LUhZzPvELYb7jjsQrQgHbXqfQp4jQFnYVTnOaRapJT4ov5LgklfFbdj9TGzetLqmjluLe0N4nR3z+twV7P69mG+U8u/mb+MBI88NQa/QgHAw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a59724-c72f-4175-ed12-08df17dc8ee1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:36.8639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Y8CeH/P10TCQ3WZtJbbmah8x+JoauC1gyMU+vIhAtRm8FCOwIZB4Asi6pVu0cIP9O73CbxnSCRfQyAWqDCLq7jU0gU2YyfvcmOJ05OhFuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX9ztnaaMPjZ8g
 hAdU0qKRNAFuEIprzATrmCrd+uZC1M1yqdZYAK6p3dPjGpcc6IHU787Za2Bi8f8tfqEcowg3al4
 7rTaHFclpXXTGU86QqmZcOdXGxzrnKSYVcCJqWeGVvOKXp7pnHZB7rkesryMK4xeuutj0IYE89D
 jOIPijpT3IrNFJSyvmAHFpGgYRiCOwaaj0MwojHIyihjPDlcHCr34mmDfz2g1Dwq+Swjbuc+4Ki
 HFA9KU3w03A+7XA+JEsKuNvZjTxZWs1YXGwnRf55gL/03Z7EKRtTLPbV8ilunX8c7h+Gp0C1Iws
 0wVfjgYgBjdKjmdNuzsHWXKdId7cjdAA3UFPjeCAyn51bkKCZPQ7MCO3jteQWf8YVYH5y452jYj
 0jEAQG3weWmTNNTpl7DNzJC5nftpBCa+VjIfCsYWJlS1DsrxF/mMbPbsPf2wyhjfCF2ZTYHH6mz
 2YhParrpHdni35CyBVw==
X-Authority-Analysis: v=2.4 cv=E9BYNqdl c=1 sm=1 tr=0 ts=6ab12422 cx=c_pps
 a=WiodiXt0wH02q4ozJLtFAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22
 a=64Cc0HZtAAAA:8 a=zld6iL6FPamXMVRW9-4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX4STSRkK94c+t
 oQlpf+JcBGCdcl5TmHSskok6+1awnXq9e6fQ6UfloT5CLlHZx9Sq9eeBAEjlNEbHUxp/8VyQgji
 Y04px2PAaO51cHkBUT8LJBQd4rCQwxk=
X-Proofpoint-GUID: A0azfTJLJ-gWcVP-vUHTyrkLVOmuYU5O
X-Proofpoint-ORIG-GUID: A0azfTJLJ-gWcVP-vUHTyrkLVOmuYU5O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add cpu-models-stub.c, which will be required to add QMP support.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-models-stub.c | 13 +++++++++++++
 target/arm/meson.build       |  1 +
 2 files changed, 14 insertions(+)
 create mode 100644 target/arm/cpu-models-stub.c

diff --git a/target/arm/cpu-models-stub.c b/target/arm/cpu-models-stub.c
new file mode 100644
index 0000000000..48f712d648
--- /dev/null
+++ b/target/arm/cpu-models-stub.c
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM named CPU model stubs.
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "cpu-models.h"
+
+
+const ArmNamedCpuModel *arm_find_model(const char *name)
+{
+    return NULL;
+}
diff --git a/target/arm/meson.build b/target/arm/meson.build
index dd28146c52..5c056fc440 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -42,6 +42,7 @@ arm_stubs_ss.add(files(
   'gicv5-stubs.c',
   'kvm-stub.c',
   'tcg-stubs.c',
+  'cpu-models-stub.c'
 ))
 arm_user_ss.add(files(
   'el2-stubs.c',
-- 
2.52.0

