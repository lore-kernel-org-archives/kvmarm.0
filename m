Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D267497B9B
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994041; cv=fail; b=urvQkb5cpsXFPrM6BlAJqjLZ5g1SrAMOvZOQCZt8tUqUT8f9tR1+MRgfJkY2z7HXUz/xx2/YX2/0vLwCfsTgxH68QUOjgNbxQb8rSj5nKo2/CBNxGTVwcQ7r5IEAQ55TYf3jlsZg7h3bYFBv0GG7vg4AxzxQW/jRHPfaKtAjRec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994041; c=relaxed/simple;
	bh=rHJosd606N/6t7w+mIOsoAJz9wRlRm/jtCUn5FpHDmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VuzqRAxnnNQvbOHRkn7SP4eAtWy2IGWWCCDyCIIllExBRN9u4KFZEk1jCwqc/bnnvGnmxiNMOjzapbvTZ9Uq3j84yxla4+g8gVUBjoFy1fJ5OKAZeluwmUTh7Eso3b0D4bukpGeCP+9k0tQe+6BTUsWdcTv08UjAvGkOwQWUMQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fkBpSbJT; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fjOqmfkP; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fkBpSbJT";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fjOqmfkP"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAiHke520340;
	Mon, 21 Sep 2026 05:33:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=mZ21jKjDe60npy3R0Pt3Jg1g+hcsBOzExrkjaM5yH
	aU=; b=fkBpSbJTecFW6zo4OPgOqh+9CTPnybqu7HIoy0IMpJISqWb+Dv2fG37k/
	Od3yU+vZzPoUVqVNQwn6bGSDedEMoUT4HpYUsFE699V2UurIpHDfUCAGb/TY5Yr3
	MmLTxbzY1hGpLf17eVAs4w2yaPjXE4Qu/X+WOfGnCl9lPky7C/MbYUvyzw+YHbh/
	5IpJhOpblSdaEGW4OH2A8e27FtvXUjNml0b1N/1ZbV4qluIHUXCPYmFl3tNhJNWF
	a7Z9SsH0LmhpCU1RYNVF5sZj6LdLPeKS/c/1/VbJOx+/9HudEwvFcyWEM2SpbYu/
	9qHB0h5YS3bDhmy369eipFX+SCyig==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022131.outbound.protection.outlook.com [52.101.43.131])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspqsbhps-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xiuy6WZ5Fg1Fl0tqCTg0nsZagkt9SMo8/v9rqDT3Y+L9QrbZBRwMTb47hgg73pIeW48XLEK5U1zIBH2+sqg8BqNn8IIwvm9qS4rE05JRcWUc1MG47TAxwyS2X1UcD/6um75uzdGiLs5qdIghf+Hga3CkbCh0w8Hg5yfTgr6byYgbpQ4yRhia7WxmehFXl7xpWx0HcQqZyvEqhdaWGTsPMb5V/zuMMpkrQu6Vp6IwAygY4mtql2mi43HpAFcOWD9s6/76030V/+oFWaA9nHagSBziAvqJ3SfQ3dM9YF8BX80pk69PV+qLyv4V1FydlRGT466DogQx2Il0wMlM2ddnnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZ21jKjDe60npy3R0Pt3Jg1g+hcsBOzExrkjaM5yHaU=;
 b=zJ+0+9lwsQ9L5UmTPD+HWR0wCOH8z47D6tRgHriOYcEgOv6TFh1eHbsT73Yfx3JE0PzUXRRf4r/hAGRz1xRbwizyajeuYItmEN1lup1P8nEjGY1e2EUJ67lzsdQsYeXAqAtp3VcGchJpg1/mcm+qrN8nwLV23H+9ipo+FipON2XT2FJYmSYpp80DP5IOUDD9n9k6zP/EXKqNceVyEWcYSMxPYsBkLRkRxo06dR8/EnG8+hle6CaLDxV660uRoR36+IGkdvKjKuMeL8fM4nEA1/mktPAP2+1ho/Pwzo5LZp6AHDwG5UjfMdxv5SHy66g7wy0l0mxqZEUehTYFpF4AAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZ21jKjDe60npy3R0Pt3Jg1g+hcsBOzExrkjaM5yHaU=;
 b=fjOqmfkP1Nl2Wmnsycdf38Psd/wBlchDzWE5+xbxuSLx9Bh6UI8dmFg5QIMzuZnGLYPzMRlSLRZxOBK5UzxdDVDfCbcl1/CY4QPo2b+v2GD4oImASS3ColgL80mRULyplgB/6X4Dg/P9M1uVOY8FLTDYlvwDTgVj64mgRpEJuLF/krRwuVy0k7W2wWRUHioRyLNz6i6zt5YDWiY9LiIYKDhfMEylBTAFbo7Ja84CPwWCT5GMRbXJ+JNXVhkUk95/eDg8EDe38z9F2ZKbYszdt7Db82wSTFozPc5KXrUs8qXv3h0cnbTi9NYh08eumIrSJUpbwGjm+P+y1YhzaYjcSA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:34 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:34 +0000
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
Subject: [RFC PATCH v4 15/25] target/arm: add graviton4-v1 named CPU model
Date: Mon, 21 Sep 2026 12:32:39 +0000
Message-ID: <20260921123249.1708067-16-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: a50ee468-5245-48a2-9c1d-08df17dc8d72
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qST7DhP61AbOnurXxqGKxRjR8Kd4VIHWa6vWNjphzNQnPKSLflkfAbhn7A0C+FEOmyaADLBgzt7rlJixbwfAxVyf0+H89yEkF0XS1ij4puZaPh3oQBu/PdaiWfEBJEUtXZnNycALfl3ZiG1HCwTZBvUVtJSPQUAfwyjGFYAmpORN4fD+Cw8b2QO9dBAtfv1Z1Mvoq5CAufCzl1JrzrpmK4PR/aRNUHmqQsmzc0ZEFw60F1XVS4Hgtcp4BK302vT+wuiAzvpcdzb61ctal6SnGigRVC9krM14KstXS8cOLEZ9I5kvkqUecoO5pPjfWehczaJUrKGecmYXqrlDky1ovuw8AgUyAZK1vZqFHhiP5KxaxerPYU79TkcAyrmXBKCJVW2MBa2cdG4ZpFkYM+sjzXl6fEYE9Cm4brA4+i2YDfXwX27Jl63s0lXXrP9+71KNCVISTkMBEmLVZ051/oZ3cpqlovmN08+X6e/NsNToC8aSYyfoSDE+sJ0IoKqFtOpq+QIYksJ2NKgkkl+WivZb035uhJeUH60XFgQNS96Pv46UneWpj6PDXG+t2GUceE3MIiX0d141MUuIs8irI+7Y1oukbn8gg4410f0jIBekOmgr0UfTEoWQJAqw5ktzuxEFqO7qNXgr00B+YaOQGh1aWMv5Oagr1NCDOHL/g0Nsmm0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GslQFghfsCqviiDAlQWv8rJfkkCyD0SZZz3VurHXTnZuZlo6VMkBxgKVjNjd?=
 =?us-ascii?Q?BFQTlQr633oAF4AoIF6xCr7KYOtMgMYO8iyXL/QhNj82sLlU2Ao6SvYnLEFk?=
 =?us-ascii?Q?7ke9/clfxgS7gA7UhFSjRriD9KGdDKKyBRCw2FznFqqNFsLCsP1PHhz5BGVd?=
 =?us-ascii?Q?x7bGTdVVzCKPl+socYBpOBv/Uo7bEvGIyPBSBNVa9pAIQ8HWdsM5i1zzVKOD?=
 =?us-ascii?Q?MIhZbw8eVUiWLSNDZB/4nbiGHD4aAiSGVq1rbaeQZK2z1J18RgeKBgTK9Bvt?=
 =?us-ascii?Q?OMecrPloEjIfy708y1Mw6hKvN+Z7d8MlqRMdRkTunDPCT3eaBh5Am7/ajk91?=
 =?us-ascii?Q?x+rQfA3tGet6ukuG0t5vQQFACj5C+kv1u8UAYPH3WAX10BQ2Oq2LbscMNNz3?=
 =?us-ascii?Q?NnJBs0hoZ2leQPvihNr1m3QRh8vpDJWlyUbVB5wv3kI/nNuZjfUCdqDjKhRI?=
 =?us-ascii?Q?va/sNkKn1jazwodfND3KNzhZxN2U2KVZcF+AY2vzucQsqpEm5N5Bxv0Crjgf?=
 =?us-ascii?Q?Jp37Wbv+vhEQhuIBCRqTY/4ZOFF/NoMUsSun5vadcAcBi7/45Op7ZPVbnscI?=
 =?us-ascii?Q?/hd+hMoFDQyRy2Kw5+7lu7yM8/KRAy0ajWYd5bU7XbeeilLk/MqGdJLWHNts?=
 =?us-ascii?Q?mykxzea+8VMQB6vvBSOWbkUZhg4+iLM/Ed7vN5vKHW2gmUBauBqo7wRaD3iJ?=
 =?us-ascii?Q?P+iEEhd3MCSbmG6uYDqnZOxEjjaS1IedUAwFUARG7sfacZNeF7zJ0Yy2ZFz3?=
 =?us-ascii?Q?V94l/G+pscx14yWDqBNeEsAiEbzfqEB+DHiTcem6xxjMmhB9kW8TgX4pYekz?=
 =?us-ascii?Q?VfmAbnJ4853aHJaHHFUxBbHoN9GOq0uu6hjI7NOy35PD6w8/k7ws5JH2MdzN?=
 =?us-ascii?Q?xOTJ7cgCehETK9l1iiE28nHsZMK4ahWgBRzaQX86RkUXhF3r9mg44lus4SML?=
 =?us-ascii?Q?Z8abrBuvfx1nHlrVn0mib8GtjpCKIsN8CAzzgQXRKpGC+Gi6OfuU5GGBSQX7?=
 =?us-ascii?Q?528DZMf+qKL7vRrxsVERrqiOVM5k5jtf1RWIFakgc72pvNvwabqPzkWrW3s4?=
 =?us-ascii?Q?JsR9W5GCjTGpyV+ZlzoCZ3+NSsL14c5UIqYseWEM4ntzYxTKpX3DqTB8x5gl?=
 =?us-ascii?Q?UfTUayZc7Vo4JdGKkQWRwtcPyaN0Rd3h6Q4g6EjJvkgd3ZbbQKruQMteYIV+?=
 =?us-ascii?Q?C4J1QHpicxyIDfxhVZ97uWTsUqwzka2Meiu73ZgBsf1kuxfwwywgu2DDgcPX?=
 =?us-ascii?Q?JXeWapiwiMkpuPzsStsNlaofqaDWpazgqZNdxZotJmVj57EsuJax1k2B0Z62?=
 =?us-ascii?Q?nVAOPRw88y3JJOQ/etxLTdrSdJFF0WSy2H2qpi9vMtukWlzVTTCbNW3bwg58?=
 =?us-ascii?Q?vflqQJdMRdHOyOg1vNrN8pTdm2OjS3CwVO0SXKeexRA9mAI02DaD5pdlJsxh?=
 =?us-ascii?Q?LEEtXNLecoHRhj07yZ/gfONgGEQ14x1MU5eHo2g3jKh/yGRguepR71EuGP5c?=
 =?us-ascii?Q?3RDW1SNgNBuaHV4BccUSpqHFKlpjbO98+MuSwBxF2VK34EQTp0W9JodbTxtx?=
 =?us-ascii?Q?8GjfJBJH3C9CxBmpO8LqKpOqUIRn4IXr53xhQSR1RL0SRRyZdSDSnWzlukZu?=
 =?us-ascii?Q?dWhj8AUKqfsQofyCI0vzaAX0vARSrVLmRCxDMGLSSBgknFLAgCc6smimGTyb?=
 =?us-ascii?Q?+4P1kl8TDlWhLCDJhyrUK+DqHKpUkqkoLNH5MbqfsGwHQIyii/o/hnuYxAfA?=
 =?us-ascii?Q?ZV2opcrEoqVjjttY9Lj9jLgE5CS4NIc=3D?=
X-Exchange-RoutingPolicyChecked:
	Nst61Hw8XSHZY+ZYlrl0Dh6l+Umwe/FTkh/7p2dlxswpjJLd89M6YCVQHkLp7mNmYyYFslvEJEwYETl+g3LKyfTaJ7VwAnGyvcW2OEiEn7Djo8jqsGG3GJPLxueNlHVZbMrKviTyaYh2Qtx96P0oXggH+Cj40eBfe8O2j24LNN0d7drRhyElf44sh8xEDNjbbnr6W0YE7kNJj10Rjbz3SNUK1q0UgTHRie5FT8Y1zuU+TE4xMHMY9pMzEZ/ShEs/Qt28QkuSDmT+1fo1FQo8DZFc6qoAkP6YHrMt8xIG4aVFkYSrmZ1mJU/F9XMPVWO7y8KeiyE7me9dL/opwm9s7w==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a50ee468-5245-48a2-9c1d-08df17dc8d72
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:34.4707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKt3udgsX0HpeyrRCd4aPNoxswPXtN1Vng5P8l9VEzjkWRT/IunkBxrpLRHioEIPpwfSQuUyWwUvuVwoB7iXQw4wiKJOHQ6vDV2uibpF3F4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX98ba38c3IXol
 PsperAnhDni64PhWaZdCfmcsN7bEiJo/kobznWRPTxVnXYzeKP9QaXyAd+241N7QLgCEetvI4Vd
 97maF8ygKcKO3OvtC0yxwgNdCSI7IWKQGZnqxyqrzkFWK4lNny17e8zQqiB1BlcmQbrG+GLNXoD
 OwSy7HOBpihrqeQ2pJD/YJNKO4RhTu0sPm//vS7wZcN7kC3lxgE/lAsCEcOKrtf4gqZ0ucbuz98
 j9af8BLbGEvCqU29FQAlPM17I9GUJFoZ0h+zQtNQtadA6WDykQqbrf7VhC/UmtxG5cjBzhyBrkh
 XinI72nC9F769dsqycyLviwH8TxV0x2dy3kRbUKLtJ0prVx57qZX0XoDOB0OfHB3z9rwAsKcjcl
 baAQhLmNRSOw1w6NqQyTfFUg1wbv5dyJp4ai1w0VgwWdIIq8VDOPmzXXr5xY2eOlYLzQ0pZmt5/
 5QhjxjZvnisY0oCo+4Q==
X-Authority-Analysis: v=2.4 cv=E9BYNqdl c=1 sm=1 tr=0 ts=6ab12420 cx=c_pps
 a=WiodiXt0wH02q4ozJLtFAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22
 a=64Cc0HZtAAAA:8 a=aUUaiw9hmEWJd_nZoTAA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX7KWeXrhCvbtO
 fn4XDz1t5X+UKyBlAEnMXZtqc4mvHpXSWoQ1GV4HEYR+/iCiAX8VuzoROWo9VvnC/zmihMsI7/g
 rQESi8FWQ51dhJNNhXIRsItSXjtKt94=
X-Proofpoint-GUID: ONpa2itiZZ_6zc6XiCX7YG2NBmnU8eoV
X-Proofpoint-ORIG-GUID: ONpa2itiZZ_6zc6XiCX7YG2NBmnU8eoV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add a KVM-only named CPU model for AWS Graviton4, inheriting from
neoverse-v2-v2. Because there is no public Graviton4 TRM, this model is
based on ID register dumps from actual Graviton4 systems, which appear
to implement Neoverse V2 r0p1 with the SoC crypto and RNDR opt-ins
enabled.

The extra properties are FEAT_RNG, SHA1/SHA2/SHA3/PMULL, the matching
SVE AES/SHA3 bits, and CTR_EL0.DIC.

Final ID register state requested from KVM for "graviton4-v1":
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
[ 11] ID_AA64ISAR0_EL1         = 0x1221100110212120
[ 12] ID_AA64ISAR1_EL1         = 0x0011111101211052
[ 13] ID_AA64ISAR2_EL1         = 0x0000000000000000
[ 14] ID_AA64ISAR3_EL1         = 0x0000000000000000
[ 15] ID_AA64MMFR0_EL1         = 0x0000011100101125
[ 16] ID_AA64MMFR1_EL1         = 0x1000000010312122
[ 17] ID_AA64MMFR2_EL1         = 0x1221011110001011
[ 18] ID_AA64MMFR3_EL1         = 0x0000000000000000
[ 19] ID_AA64MMFR4_EL1         = 0x0000000000000000
[ 20] ID_AA64PFR0_EL1          = 0x1101000120110011
[ 21] ID_AA64PFR1_EL1          = 0x0000000000000021
[ 22] ID_AA64PFR2_EL1          = 0x0000000000000000
[ 23] ID_AA64SMFR0_EL1         = 0x0000000000000000
[ 24] ID_AA64ZFR0_EL1          = 0x0000100100110021
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
[ 44] MIDR_EL1                 = 0x00000000410fd4f1
[ 45] MPIDR_EL1                = 0x0000000080000000
[ 46] MVFR0_EL1                = 0x0000000000000000
[ 47] MVFR1_EL1                = 0x0000000000000000
[ 48] MVFR2_EL1                = 0x0000000000000000
[ 49] REVIDR_EL1               = 0x0000000000000000
[ 50] SMIDR_EL1                = 0x0000000000000000

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c           |  1 +
 target/arm/cpu-models.c | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 90e818690c..e514d167cd 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4148,6 +4148,7 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9.0-a-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v2")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton4-v1")));
     }
     if (target_aarch64()) {
         g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a53")));
diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index af60924953..1a8913e619 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -17,6 +17,7 @@
  * arm-v9.0-a-v1
  *   neoverse-v2-v1 (r0p0)
  *     neoverse-v2-v2 (r0p1)
+ *       graviton4-v1
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
@@ -224,10 +225,30 @@ static const ArmModelPropValue neoverse_v2_v2_props[] = {
     MODEL_PROP_END,
 };
 
+/* Based on neoverse-v2-v2, with opt-in cryptographic features and RNDR. */
+static const ArmModelPropValue graviton4_v1_props[] = {
+    /* ID_AA64ISAR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RNDR", NUM, 1), /* FEAT_RNDR */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA3", NUM, 1), /* FEAT_SHA3 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA2", NUM, 2), /* FEAT_SHA256 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA1", NUM, 1), /* FEAT_SHA1 */
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_AES", NUM, 2), /* FEAT_PMULL */
+
+    /* ID_AA64ZFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_AES", NUM, 2), /* FEAT_SVE_PMULL128 */
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_SHA3", NUM, 1), /* FEAT_SVE_SHA3 */
+
+    /* CTR_EL0 */
+    MODEL_PROP("SYSREG_CTR_EL0_DIC", NUM, 1),
+
+    MODEL_PROP_END,
+};
+
 static const ArmNamedCpuModel arm_cpu_models[] = {
     {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
     {"neoverse-v2-v1", "arm-v9.0-a-v1", neoverse_v2_v1_props},
     {"neoverse-v2-v2", "neoverse-v2-v1", neoverse_v2_v2_props},
+    {"graviton4-v1", "neoverse-v2-v2", graviton4_v1_props},
     {NULL, NULL, NULL}
 };
 
-- 
2.52.0

