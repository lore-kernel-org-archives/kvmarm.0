Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB123AFB09
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 09:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780911817; cv=fail; b=ooABOmsE3qD3S6SVhv28OZ+wBMS1/8GI0bbm9hL0bgaai4ht/YJDWascrjIxvObIBNniMld92Sif60+21quiixDIlCiaxVKSKQM1y1RIx952IM4PkUaL1wlcEvxW717ULIs9nxoBRxVEeT37+O95TBTmOgauL4/g9kf2TSU+WtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780911817; c=relaxed/simple;
	bh=4FwlUqiG1qwhN5h6RGma5NeoJ+LLPG7VEx2visb5SNA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cZwjhVhmfyM+ka9qURvL6uxFpK9ohO87eDtU0/mFzTmlA6FYFQydEqeiyXzie57cV+1h8yYk7tGhzdaZoJ1K0bCc6ks0sfKN3EU3Jk24lwLpJ07otNHDtMmz9Xxu/xVvlGMFSypnTdqyIqllwUSKC+ybtmqOxjfrIQDJpzVUaPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RsdTYar+; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NqlNRGAV; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RsdTYar+";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NqlNRGAV"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6586RAn21584373;
	Mon, 8 Jun 2026 02:43:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=proofpoint20171006; bh=4F
	wlUqiG1qwhN5h6RGma5NeoJ+LLPG7VEx2visb5SNA=; b=RsdTYar+8CFEw1qEPJ
	MrDGpDInltXH73W+ZgKH1sYpgF1BNkOx75j3DvwzNmF6K9jeV/gwxp3LZkiZ5iB+
	OYQYIgdkGQc3ydmIgvO9wdXSIUK4HYNBql8AbWcwpIS6S5e6sfL5UhBINE98TceR
	k77joMz1BERRgXOeEc7mMbWzAhlrWA/REvWuVEwBO1TdIzkuRwNSgmNqPZO2qLn+
	6lJYNn1QeQo8KYwEitk+6FZF7TjOsvV4eJ68HhZaKu6Vfm06VyjYTYyMn65V3dJr
	y1FmNQPMg71wZL3uhPe7L+R43fCesLFEA+RIPM5ykRiFIQsRJey13ILxJ4ELiV1N
	dC7Q==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022076.outbound.protection.outlook.com [40.93.195.76])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4emfvqb5a2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 08 Jun 2026 02:43:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJC7+tayZeVtqzCXfg5CttqSyLvxVBf85bYTuDZ5Onn+dkzcQezCTobUf+MAWXnY4ujh7C8LWcfkWmmAGmKGgk/NCVglMwPQAMX0C7TWFfoyUps6yghDxHjl62FKjvMIo4vqRVsWa46LWsXIM70vGg8PSXOhEYR7+GIVRpLdpSXSE9sUi7GAZhpKC0VwfI7D1n2EbD5/+W9Mplui3F28G+CgX3knNne93lMNHctH27zzNb4jgFUiqJv3MiQip5HFqhsdTfI4Eydc9FQEGT3Ok5zE0C7m2lNLjJ9f3zdASB7QGBD3IoBiAwyPArTn/oxp6lieq9WiD/W7eGiZ22oClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FwlUqiG1qwhN5h6RGma5NeoJ+LLPG7VEx2visb5SNA=;
 b=GLYsihFy65N4DHMBVVrRicjNVgpoCjxyUAI7yX6T0Wkxdh7kTnhRnGRyVZfFd5P08p65MrI6u/cs2aJ3SnM9q0vhBL0ed2Rr9wBhHKg3/9Mq8zHFlnBxG5Kx3oAefzH5+AKoojylI+1Y5iwOyVDNNyAtr0nRsMkxBdpK9uNwq0N60Am8IvsSLUCa1IJ4mSmL6actnisUamFkw3wUArWK/XC8nQ+CNM01tQizcPQTv6rGclTCdDAh56JaVwPdnshgxFTA7Za/q5x+T3wqmIUV4pI17jmygva+5p9hMXBkfulsgnzSAmi5amjai71TsRp/0kmCTEUZ3/ptSL16o3pDig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FwlUqiG1qwhN5h6RGma5NeoJ+LLPG7VEx2visb5SNA=;
 b=NqlNRGAVO+nZFMwrIr2BBIL2jRkoR7d95gZJKFgc3ofdIVbEHyAyaj2pHYlfhc10Ic93lQwTuTNvg9iAxmjQoPMLueOgSEqS+E0SwZTCJ6FSbA9Lr+jMeYzGv+286vFYFhpqbXubu29olHZU1vve9f0bylx8fbDxCTN3hEpliSNPts/J2Dr4FhLgGvdQwWQRF2L7PlIB3QgI5BnvzefEvV1vzpH78CmgEQzRSUzGP33F3qmrcjH4jCaXj9LV7YEJAQX+SWtwL3tZMwb9IR+IMf3QCFXjJPnxQg5UPgc7xp6sPlRGES9OwL7gmuhVu200/X04ZwA5LUWoeuDQN2hj5w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB9481.namprd02.prod.outlook.com (2603:10b6:8:dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 09:43:17 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 09:43:11 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>,
        "oupton@kernel.org"
	<oupton@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Mark
 Cave-Ayland <mark.caveayland@nutanix.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>
Subject: [RFC] Exposing arm64 ID-register safe_rules semantics to userspace? 
Thread-Topic: [RFC] Exposing arm64 ID-register safe_rules semantics to
 userspace? 
Thread-Index: AQHc9ys44C+DnD6MJkq3ENO+emVc6w==
Date: Mon, 8 Jun 2026 09:43:11 +0000
Message-ID: <B5C9AE36-8181-4A76-905F-3E89B7200215@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB9481:EE_
x-ms-office365-filtering-correlation-id: a4b611a6-4498-4668-1156-08dec5425a98
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|56012099006|6133799003|18002099003|3023799007|38070700021;
x-microsoft-antispam-message-info:
 AhbP83AObmdAfrUaBgX0RVeLv+sXdv/YUMQYLVYz9y8jK2W46naFuuyDTPPOR0B7A9t7fv0qlo0rMQ2Lnhu8fQMO6p7jgwWoUO+T59eJD2phFXxnPXSugzccfYpdCfPnTXpuE9dVjT6Wec60bq3oS0z7cfEwoN4mdQXRcsuhgvxYEBEEyjtQl/BcUJPNeCXPJcs1ib99fbQnR0bZLSnCK7jb+iYZD9TDXsOwn8OQLsY0SO9SSpYCWu4E7bCKiAKGc53AWOCGmHqG1JxFRsxSjcRDhye8LM/N5hi0czlc0eZzFNjSDAJ5X5TqK0xd510IMFeKvXznr2BGenVKOyLkVD3U7Cus6Im95ZBdKzYmIdWglo5rUmiuH01g2rRItzQCeZJKePj2Wn59A6cc8LXWHhZJcrrVHrFgqHCwgaJ0DKh3fd6Cp12RFnSOjFNmbL6YGmnc3/WdywkrUXFi9t4izE0CSNP14TaDbMpgQz4fyAyVgAf6Ci0PBk1V8vM3H9PdNPlp78SR82+VDDtPRSgg8vRaBs1KA4/O7umXiFIR8sOgdClk1qFyC+9Z5bfWMptx6LHztT304z6byMp9/QsmydsU7U7QOF8ebgbaHk6STgGbTWz4otT0PmWfBaOkyAkCSngjztKClOOpg/Rs0yn2B1LJCbfj6pF8rhWMFGUPEMTDgpx7QKn5vX2UqdVHPHsWXLszKawmhWpLA0SXz+FKMw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(56012099006)(6133799003)(18002099003)(3023799007)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?AptWk+FMBVdLgeQ9MLA7fTBveU1BG1JJ1dJxieX4LMmULL2VL+HVFx959KZI?=
 =?us-ascii?Q?0DkwvnCakbtFWSwAVXUdPKqFasv9r1F+B/xLaUoa2xfkPWp8M/eEBhd5EwLY?=
 =?us-ascii?Q?s9OSfOJsY/h8w9vDpIBldfF8K7dkGovcHyxy9qd+GhJwQAmaYesVp1iJErL/?=
 =?us-ascii?Q?+bZDEItv76QayOhGxybKAZPZsVK961S/P45MbMVKCrJmggAYaISuxGznuCzR?=
 =?us-ascii?Q?sZqCFuTAZbGROiIWek8y07l8QlRomzZxzZzG7+G3UdVyrmnWTq/Tw6A13/5S?=
 =?us-ascii?Q?ej4pbU3535NDYoB0A0lOypO+l3+hAY8g2n3HDTC1Ft1ceTxiV+h7JGOec4OG?=
 =?us-ascii?Q?2KAfm3KCSjUmaNmsxB0SoQlyh+AY+kKgDo5nkAuoAQav5DCA45zYcBrGmf5J?=
 =?us-ascii?Q?NWNvoRuFZItcDnQILAUc49XHrsW9D8Vuh4VN7ELBChlRH70U2hi396dyqVDN?=
 =?us-ascii?Q?JqGJScZmEMwX8t6dqWjOgnZXg0NF7QZhZq5z/8o9a7oJuyduRfAcAKj/pgvw?=
 =?us-ascii?Q?2Dc9/q/5Y3bYft/+g8HnjPJwB/1iXnStLufcK9ep/7xcGM0k+jPS0lCK4ElC?=
 =?us-ascii?Q?WATEQ/Dp65Hznq0oluRoknntgezXZKV3pfh63VqpNdcUIaarE4wMhUTz1Ioy?=
 =?us-ascii?Q?iM/nBhKoznpm2ejUdObkjTRq+tPJTG4IrXt2gCzSOc0s8lxRmE+8pA7HcqUq?=
 =?us-ascii?Q?qxfAWfETAm3bI0FwcnpBp3EduqVTQLIHspbS5ipw9NaBAVII9+TBRD9jK3qB?=
 =?us-ascii?Q?si9PHjh6epw2zfff5msTTI8jTFBKMSdzcmYi8lxS3D95Vdy8pzAkaNT6O+Re?=
 =?us-ascii?Q?k6i1JKd7fnBrd06lp17e3qLK6l70owNOVBdWkAAHWuG61GvSUlGeicdF2PmY?=
 =?us-ascii?Q?P+mkLBcnq1iY3LS5k4w/n4ndMCkPa3zfweBC/GA2meiXFcxeIYSg2TR2pucB?=
 =?us-ascii?Q?nShPFs28BwwK73h52x4035tvDnsm4FNQuN8U82T1MtEQfS+I0rYsxpUYLIr1?=
 =?us-ascii?Q?RKXZ50ncc9mfidmWc4fAJ0WDxzHo79vD/uk9+QfEuhVlEs/VGahHB7rA5a8D?=
 =?us-ascii?Q?rysb/069vOVw+BfPP48Anv6wJoyonvj0HKbpxG4TCH4Tzaz6RL6vewiBMD9x?=
 =?us-ascii?Q?DDdLwwW8xMtdyODDAcga/IS9EQYekOqPErZhRSICPawSLh6jumZj101/3YTt?=
 =?us-ascii?Q?33qWKw71AM+dT/bLIn+hMf94DGteQ73KSZWiHyuekPujmTbDRxEkAszfd2dF?=
 =?us-ascii?Q?o1zssdZCvUOKZaSdAY71TgsyL/7YAmbCmWMH1ZYhFyQjDA9VSQU3/Kb1LCU9?=
 =?us-ascii?Q?feOXi3EZIcPUxoPjT6t9v3m3N6QYc9gK60VfuniPSLTf8Lpv/OX2PKO7TSYC?=
 =?us-ascii?Q?gx9spOX3RxYCPzWYIs+M8icm2Q7jfG15ofsvzHsfGCl3oDZHHAzUIoklN3yX?=
 =?us-ascii?Q?aR/i+dbsT89f2Al0/3Ng16EEH2ZHaN8n+xB3++u7byCQGF6Xf+PrXWRzALTJ?=
 =?us-ascii?Q?0og7e/j6+QpHwBObY5PUzXoOEkFSaCMUumGtlNXG6kLT3Ge14gsKXXMPu/KC?=
 =?us-ascii?Q?u3Po1ECIk572dVkh9dYBGkKNIu4bG01XvFJcMGWjt7BifHOo03oXMLqUBC3Y?=
 =?us-ascii?Q?epF2cBkplO+SCGkgyElTw1WR24n2kIa9wSbq/CUAGTtf7gci5NeqcPUqQSEu?=
 =?us-ascii?Q?4ZfAAcpQ0LvT62sOdk4gH4iLGE6vKBPU4tbCH0nNN3nzPZGwDRR44GCJqBcq?=
 =?us-ascii?Q?R2E+tqKeR/fsWRqLDubrsqgpc7GHsgvlyLSDTGexstthuAc/JPpDGdFnsVEV?=
x-ms-exchange-antispam-messagedata-1: t8Z5euywMyNj8WJerehPEOC3c0wLhKbnRmo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E28625F8035DE74791F7A401637745B5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	kVAC1Nqlq1L9vMIWcQ76K2W2vityzcVoTUWNnXSRhMmGcGCFumJwL0vRBGRB/aK9+DsIjl0XkUwaZyqDwcyWw57M+mvEtLDmyd1bItFGiIUs0HVrL4aqbtk+Hn8W+rSM/gg9+TohQjlSLB4BaArheskBkKPN4zE064+nt8pMypj3vVXA2cQ2DCGstBNZHODEYeUWK7DuAhvjtDIaO96w1SAPas0rBLT8XxO1crUnATn6pxRJpo8ET4uFNnpgZCU1lHMYH4/gdC36zLYP6N9JK4z9pCRrHHRs7RjnQrK9RnJXr9CumJFpoLxsjxQ0u+n6SGBrkLUYR94zdFoRco9UXw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b611a6-4498-4668-1156-08dec5425a98
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2026 09:43:11.1244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eOs3iWEu4SVch9cHRfh0Wud6jWlUrFApvFsFKSYVysYB1Yo9TQc/z2FOaBHYXE7AaL/7sMBk6n+iIwHjzejg9HajzHSfteU9UPXgK4IeM4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9481
X-Proofpoint-ORIG-GUID: VCRgS1JZtcueRjS6eMybdA9tS951lQVQ
X-Authority-Analysis: v=2.4 cv=TqjWQjXh c=1 sm=1 tr=0 ts=6a268eb8 cx=c_pps
 a=eCb8aTw/9lghk0zZp47djg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=VwQbUJbxAAAA:8
 a=64Cc0HZtAAAA:8 a=rIj31gNFJ-dq-_at-cIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDA5MCBTYWx0ZWRfXxGEWdnbCdeDH
 JwM4wnj2SJ84mg3kzVgqAFlGprTuSQPQakLIkvAur8qwvipRf3RlUdXoYNGduMjHG3AzlRyi1zX
 H4gUnqRpqxRVWPlHPtTOi95RDGa5oGX3DAYlLwupFphzhuyNBNFnPCJ1f9lGmFKKyN328hU9due
 2kUUquyu7tYSBqCRHHvlfWGpvjkf0XV2J4T3Q6iSAB1jkkE/OeEPGAopyTHTLpMY5ci6R4/AXaL
 qa/zyB7fsDi3RNu/qceva+ptQsonh+u3kE3rejPszPAbDb01nbstd4twJj864OkrO5x+113Ozsh
 46eY9Joc3cegIsclloqoYuErRz/ZcI54AqK39tB6+4ixCqCKDdus2EcckGGPSPFfswv7z/ctoKA
 v13zG8WMENeJmevSXwE1jIjIsysUSMvHE+ydqfwd1zSWJDni4chfRVHfw8lPjfqGjQXiSNQQCqf
 PRNOxCDur+7c59NMYKA==
X-Proofpoint-GUID: VCRgS1JZtcueRjS6eMybdA9tS951lQVQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Hi all,

On KVM_SET_ONE_REG for ID registers, KVM validates the requested
field values against the host's values using the per-field rules
in arm64_ftr_bits[](arch/arm64/kernel/cpufeature.c) (and, some
KVM specific overrides on top);

In our QEMU RFC for named ARM CPU models [1], we use the safe_rules to:
- pre-validate a guest ID register configuration before KVM write back,
- report blockers in QMP query-cpu-definitions for a given named
model,
- enumerate supported values per field for QMP/libvirt/upper layers.

RFC has a hand-maintained copy of safe_rules in QEMU that mirrors
the kernel.

Any advice for VMMs on how to track the safe_rules used by KVM to
validate ID-register field values written by userspace?

There is no API that exposes those rules to VMMs. Until a VMM issues
KVM_SET_ONE_REG, it cannot know whether the requested set of values
will be accepted. On failure, VMM still cannot know the faulting field.

We'd like to know what the right approach is:
- Should there be a KVM ioctl that exposes the safe_rules to
userspace?
Maybe Something like KVM_GET_SAFE_RULE (that takes reg_idx and
start_bit_pos)
or a bulk ioctl like KVM_GET_REG_SAFE_RULES (that returns (reg_idx,
start_bit, width, safe_rule, safe_vals) for all the ID registers?
- Is it acceptable to keep mirroring ftr_bits[] in userspace?
- Or is this simply not meant to be exposed to userspace VMMs?

Happy to prototype whichever direction maintainers prefer.

[1] https://lore.kernel.org/qemu-arm/20260605083358.1320563-1-khushit.shah@=
nutanix.com/T/#m71ce71d5a652edd205e2b5c200cb75292f57c0fc

Warm Regards,
Khushit=
