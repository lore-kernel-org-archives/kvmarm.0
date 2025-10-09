Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3452EAB8C
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.84.65.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760020918; cv=fail; b=WEqpvMu14nqaklYJuhztFMfYyOnDtCwcV0Qku6tPwU3V0YchyuYfUYQltD7Y5fz8LnfxbFcSTaLnKtdQ+un/29jTGMdYiZAdZiD8WPSGCA9v6mU6Cxa0cQunDrMz9TAboxDoIEtQDxJQxYLL4iUrJBwxnWP40PTrHAwK5eRwERk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760020918; c=relaxed/simple;
	bh=Rq2mctpQSP1DrHCAbcRP10pLqaMSNEBuMWHdCSCYlTE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a8Elt/NwtLZYBCzojGK1wFwgDE9BED38ZlTFOyBm8cq+U2OACSn26w6sW2BkQCgJnk3EN/YDpXBtpajDI+F9+XVonE0BG6BP8cND+TVMdZwOQQwI9EbPKZJ7iUzMcTtQLnML5xUT1YakJ08JIC3tgkR+z+WAqut/iPHJeCzgZEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=GcnJQKy1; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=JwSF0nOh; arc=fail smtp.client-ip=208.84.65.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="GcnJQKy1";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="JwSF0nOh"
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5997xBOP020444;
	Thu, 9 Oct 2025 07:41:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=Rq2mctpQSP1DrHCAbcRP10pLqaMSNEBuMWHdCSCYlTE=; b=G
	cnJQKy1sHIkxX8+sA8DR7j2Siyq2AwZx9JPuIQmtzR2M0JuRzV9jmijXDihit60L
	A8ccypantdctWft/vejzkv9K3vv8f+gQj7KbUpzETr7nKJrtY6uduEX2R2cyaNUE
	altdes/K8JPHTHm39pfSDJD7BeE1kYU+Vvzal/lc/FS/YkaAYLjVh4wY4MDxOhSL
	evOJxKqcvBCeAhh8xvywSEMl+JvGENf1sioSOX6Iquxag9Qs3AhaIY4Qib35S6dF
	6LTHD7TYhQlZ+yqDjQzqAKIAQerBgK14yiHJqqTMko7Nbpby5rVSL/+rv5aFzmaI
	0d8vfu1PnYPW1zAaXvoXA==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022110.outbound.protection.outlook.com [52.101.53.110])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 49nv5yw3sa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 07:41:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQ28HlThiGeefyQM5ARJZNMeMJodblLrovbGYSiNgVgz3uFbdzllymSUQDSOfuqJMccxLo3lQERNUj2tWLucdUneZonhagM78Vo600ZCZ73G5/RzFb/zeY1qELBswEuzDz0QWBXeLVUPQSGQ428yXirPnwhIcDgiimuUJxSdpeeiiyiR9U1AVSCGEf68oiOY8KpFEZJduAg2llH9l/vQDawupyry2fT5gePHByv3A+5tlsVDUymhV7E32O+KQlg5ImyHePwgCqYKR8eseKrl6cHh9Uj7RSKk+on+eiCBUvRoHNa8IQQYa9UY3ulNWjn4IPKWZ+N5hosHarkAexwQKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rq2mctpQSP1DrHCAbcRP10pLqaMSNEBuMWHdCSCYlTE=;
 b=EBMa0lPC42YK+rmfYC+mPad/Bzn46uoXsiS9bciCmJw7Iqal79dHL5T2J5BtbovKyxJ30JRrfKwmkPLINygYtGIncgMDYDIsJFC8xz3wVM/wS6BpCffNIZasHI5CbH7/qHHcggUx7BtNtQus6yn2fIYxIow882Hmb1zYB97U7u27T84l6VOglVYBjLhrGTbth6vwCwMGMOblKk6BiQ3QwxvsiTqUZrLGbdlmT0+u9ko5XYIxAbjqFtxcxWAEDTZLybolOz5kk/Aam+i3bouQ/YfBC74fvrdsyXIQE1ZRgvkaF2W28xWt201p6Itm6cjIvybyOlPwSxknPQBB8LFwwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rq2mctpQSP1DrHCAbcRP10pLqaMSNEBuMWHdCSCYlTE=;
 b=JwSF0nOhcxMufB6u8QKTNq/ihzDpC4sosXsLZIuo/M3mC2/KDgKf4lWKgtx0v4k/pnqY9HiOJBjn8KNhTf5rKGl50MA/KfeLZ7yKLC/F0GVEg4ylO3fmtTcd9MS3u2RE4mpRdh16qrCm/pEDR3E5ZuU+M5wptd57X+S0AiUnjF8=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by DS7PR07MB7686.namprd07.prod.outlook.com (2603:10b6:5:2d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.14; Thu, 9 Oct
 2025 14:41:28 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 14:41:28 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index:
 AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YCAAAb+gIAAeJmAgBIZ7gCAAM0NAIAAdwsAgAAP94CAACEnAIAABOgAgAAlOYCAAB0sAIAAG7mAgAFgAgCAACbNgA==
Date: Thu, 9 Oct 2025 14:41:28 +0000
Message-ID: <1BD0A29B-E20A-4BA9-A916-8B975813503C@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org> <aNXGW8C_S1TbFR9-@linux.dev>
 <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
 <aOWhlvC1kROWfMSv@linux.dev>
 <1271032F-41BB-4896-AAED-8660D5459E7D@global.cadence.com>
 <E2FD1CD0-AE1F-4F9C-86FF-D576C212832B@global.cadence.com>
 <864is9zqs9.wl-maz@kernel.org>
 <677A529C-B3D7-4BD1-BEED-D8414D961BBD@global.cadence.com>
 <86zfa1y58i.wl-maz@kernel.org>
 <15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com>
 <86y0plxvt4.wl-maz@kernel.org> <86wm54xo1r.wl-maz@kernel.org>
In-Reply-To: <86wm54xo1r.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|DS7PR07MB7686:EE_
x-ms-office365-filtering-correlation-id: 676e186c-57f1-4fb4-f663-08de0741ee52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Zo6xm30GE9SmHKypVOXBwesfc4AznzhTCiWKVud4zcbpDoDC8L9/3sGOxeDU?=
 =?us-ascii?Q?3S/gfojDC8w+LLjBgMxC+BMC2g/xb8U4m/8wpdvc4A8hf1OVY/Pg2j8NO2mp?=
 =?us-ascii?Q?GCPzxKE44+haOc9aeYpFjLmoOHY62o48LofcwRCWoLcA2IbQLCPkhiDNYOEZ?=
 =?us-ascii?Q?9iHR5g3/QxyLrX0P1cpUAe0jmsvVy1f5/qyLD34mTWiRQfBL1BTHnVnZaYpF?=
 =?us-ascii?Q?dQv/GUnGU4kjp5nFutn/HW/Yii9GBG6zn6d3LHqG5jeKVTQnnSakXnV/G0yG?=
 =?us-ascii?Q?I6v1KpoKrWMKMg8OpzM3MFZ3E40VE4rgzMTJG93DyEOhBRSD5sJ93OIkalzk?=
 =?us-ascii?Q?iT+nssh+DaHJdGWo5T7fnQMyW6trJiVbJ3PyPSpx2iW9vE9SHwOGynJiPRn7?=
 =?us-ascii?Q?8+YARygaFNeEiO5EgYFlq3sv8qxfASCtbNk6MhZ17MXV2EypKzT84UAkg+rx?=
 =?us-ascii?Q?LYKHAA+wnJDIYy+MqP98S4Kk9XDB0qNw1dRKmSxUj25MacaWT8DhWxkMpC7X?=
 =?us-ascii?Q?uKMIRy3s1dlDtuFgWJSgd9k8BtWrn6XQnRH08YmWRomfdP5A5/E+wu0Th/a8?=
 =?us-ascii?Q?LAksUtaUjAB7HFVRAWA+LzMDoAagox3rWxyMRv8wqx+VWfRMqZa1p7pMUng0?=
 =?us-ascii?Q?y2UKfdYrRAVpJkCaLNTiXbeWVUNzux7ZjENqwTvr5MWqrY38qqhRaDCWEeCO?=
 =?us-ascii?Q?5cytZpeohviCoiJ4jo6DwuKEXSo8T10xh96fHYvsDdo2P0lrW2IT6ZAdvZD+?=
 =?us-ascii?Q?LY1tSA8GMwM4jMTD0ZBDqkc2U6MocNbBb2GthQj0Xqojxnvy2H7BIgVV+kXw?=
 =?us-ascii?Q?soa1saNhPl9HSyfTs2MLGUzpWRq/t7JOO9rU/xEWQ0hyydAkeTkxR6g+j53r?=
 =?us-ascii?Q?n7/kOj0oVNhpP+GyqkpBmZmU1KL3xsQpcub5HP8fV5R9+JzlZWWbprW/cyYI?=
 =?us-ascii?Q?6i2srKPRI0j6zaDUc1Pvjalri67z7RYao22SZIKHn9D3JIBxq8BgST3RchyI?=
 =?us-ascii?Q?7LG6YLoQuMLUMdS6i4jknHBAI6dhLOFNruP9wEYKZf9uGQNQYR9XHoR5ru6c?=
 =?us-ascii?Q?7WunHi5/fZWgrTicdb7VsUC4vMRVt4CG3FZS0WtN0xbyqB8Agzj+IT6IX2dD?=
 =?us-ascii?Q?7B2Lj3kBCHG6tVeRZZWxdPqkTbxRNfDF18MjxWJv3bG7j2Y+so6leU98wA2F?=
 =?us-ascii?Q?LTVyZ5hcD1O3v+hnDpYYTyKU0DrhEBuWap+gcKxOw++xHY6/1QuerKxRCYz+?=
 =?us-ascii?Q?z+KSO/obwZbCCBBg2yB4F2ij6mrIKgYsYH9h8Xsdy9kndofg/nNRW/LkVHpK?=
 =?us-ascii?Q?nCpujYaMrcwCXjxHu7bqhaso6r2mg9xKD5ytHWhRqcx0gQdbo0Inz4HhxYnl?=
 =?us-ascii?Q?56BUQoHK+7kT7UCRst4rKejftBXwHAL1yrDMm7mvrVpJS/KAnn/sAPXFttk3?=
 =?us-ascii?Q?aMfS3rq4HFv64fPoouY1U2B5P5iDoHB0TmqQW1FJfqo8vrj++Pnsk9pBqTee?=
 =?us-ascii?Q?An07OhYV1YvMNDJh4GY/HHPWab8Acn3Onizq?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?eH3JlEXjjMDqpz9EDH/g+voSs/3TA61nyEDHe0LKOjPtTCrKAqk7La47Hgb4?=
 =?us-ascii?Q?b3Nlxq8Uq22ahqardZTsjmO4dvl27mxM0AdZ07jwWyaxHhG8vRtRKk1NBWf2?=
 =?us-ascii?Q?y9mlFtLsVUy6ve6WEdkx86S3syJvEci31rkafyRUXt8ZyXfxIuPk/HP98zyF?=
 =?us-ascii?Q?lfXxrgQM7T598hVzwwL7XSbebTkMu4MnP2AUQtVYz9f1LzcLO8IB//ogHAWE?=
 =?us-ascii?Q?ceovwni8MitY+AqyKgB1LVG/L/+wUtk7iTFheNe2Jr4rvsntRxpLESArPFwG?=
 =?us-ascii?Q?rLXK45InvXh9ypUCEhNa+rlBB54KA1pIOmj6QCSqG/DPuUvUN4b3yMGvFl2z?=
 =?us-ascii?Q?IdpUFKKvNh3yOgnqc992TeHdQ7GJ2o0fIcqRXN8jieMgpQ3g6tDRA4rMvESx?=
 =?us-ascii?Q?84ef2UGKd/3VXkJ6B9Kq6OmGTyZpIaNamkp/RshsvktAghqDQ9ubB8T7xgbl?=
 =?us-ascii?Q?vhnNhkddj18zYdSWqJRKWImodmvDigHOb2QXEFv0KA3opZlZGUn47bhtSI9Q?=
 =?us-ascii?Q?sMsPzzmlpAeS0/lr6IL0lxG1AxBj/X5/w4Qrqseszo6kwbqfSWGdb8uJPTHl?=
 =?us-ascii?Q?rDuqHiYZV3yaJgpnJY7d+QoMRc0pDoR1NTz4yRHn/OMNTOYuXmie7aHL0BRb?=
 =?us-ascii?Q?+zYFji+UGZPTs8t3+bpuAzZKf0iRgvlGrERw8PmiBYgpxMmYzlw0gCQaUfiJ?=
 =?us-ascii?Q?1ueM1Yoa/A4qwDE5QcQ/vzvB8yPS9X1Tsv4qEv43Zf0CmEld8ewio6wG+y35?=
 =?us-ascii?Q?voJ5asUBjZuiyy1e3UBJe9AjGiUD+Oqz4210B8JyRaLnsAF8BUpRPpAU26tO?=
 =?us-ascii?Q?TTZRzQ1MfC/00A+lSYPHnDcG6uyMwy0bo5EUr1z6lpk3DFiqmTbJPD2VywuP?=
 =?us-ascii?Q?/rheT1Ha0NLqrSMZC5xH75AKPScIOH5d7V0+2fPxpvOeZdaa1Bc6a8EPOfp0?=
 =?us-ascii?Q?niJFABNnqatV+YHp0h61sqnp6sGEyyExy0+PDJC7Xkct+ug8TwmnSszQpGnv?=
 =?us-ascii?Q?h+B9kAGZvH8R68XXKihdFedRblqYcEUbBZtLdZ1cnYPqbEJ0adPVfS1p3bBf?=
 =?us-ascii?Q?XM4VO1aQ5nbuR/bXSCy0xRRpjD9GK2FbWxPoWKWrKD7CapIluZeFRBGugW9K?=
 =?us-ascii?Q?rQfJXkp1IsTFSMAJ6puko9YSetI2AEsaNxt+4AiGsm+4GA2wP3n5jYEtFHGk?=
 =?us-ascii?Q?rTwCAChgsTUfaYuMXSooWKEqJqM5ef0aJddPMuJ5ZdLtkH27CFmm4RztZhTn?=
 =?us-ascii?Q?7FoxxsxD2wV/WclobxbVP5BFxPDQUSswRgjfHOxg/BRKyzu9K8ojuSXdN4+q?=
 =?us-ascii?Q?+opLqYTliwkoTSfccskegJiP5NfbI/Qum72UoC9PkhBIGblUg03pCKdCCy0U?=
 =?us-ascii?Q?pQft4XK0Kc3ATFV3i+cg0uHKEO1o7RTJgPqsSeTGgPeoW6VjlcMMEUEkmHSO?=
 =?us-ascii?Q?Efjnj71pl2mltU77xGraKyrNG+fZOhG+aabk8Idp/bQ21YMEQD+aJIHWk5UX?=
 =?us-ascii?Q?KtiKv0UrNU/Jxtkg+Y8pePQU7SfkZ7J4BT8qvCBcjyhYuWdPuv0Eqh5ivJtq?=
 =?us-ascii?Q?td8CkzzOtIZTFIMvFbF7Ph2jIT3lD0FKXhSm+SML8zMALftRzNwjIJbmFULN?=
 =?us-ascii?Q?TA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4CCD9418EF40B44682475D10A82AF31F@namprd07.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR07MB9604.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676e186c-57f1-4fb4-f663-08de0741ee52
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2025 14:41:28.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cFo/hAeWTgJZGBihwyWFmjcfeNosT8jqtBnCr77xCdmF0RsyzsiJ72aIH6WWqN4Tzu7lOwoz1Zib6e8ZZR8wPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR07MB7686
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX8zdSGV++Wt2b
 gPDgrmj4Y8vC7k0N8FwQvQT5AyjPvAVYXxaUWBX4TVdeJtUjprBB/+Z/zBEebsb+4lM7Ft7t48U
 znXyYY+c+v3mPaBJun4b9PAXv8+c5tJBBaI6szQV5XP31cxfsXdfazCodsuAGPdfZUfqd6fouCj
 p/ofblPLyXtl1kIwvjH8RMBrLGIUTpVxV4hAQB0/sKN/aZidUKwHvFkHtvOWn5Prak1Gqh010rU
 tyueKPVpuHgok9p5LskHxAKzy9aQEuCkYhvpxnGWkzx+D/wFPteGFWspbd8+D5JcPGk+Gq4EA0+
 MxQyX5wJ0MV/sFBibtTpO4NTDjpU/OGa74E5SsxaWzt4I+KlyFJQZx15T2GCjssiSwVsvqMbC42
 uOelTPQtJW5ADKJkAhbruW3psQ5zIQ==
X-Authority-Analysis: v=2.4 cv=VuQuwu2n c=1 sm=1 tr=0 ts=68e7c99b cx=c_pps
 a=E5lcl6OKqxSDDTEGn4Qc9w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=TGxUv9D1QFn8bBFIqKAA:9 a=CjuIK1q_8ugA:10 a=WmXOPjafLNExVIMTj843:22
X-Proofpoint-ORIG-GUID: AOMPG8yd3gazbxl8muGXe8qabmE7JJX5
X-Proofpoint-GUID: AOMPG8yd3gazbxl8muGXe8qabmE7JJX5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121



> On 9 Oct 2025, at 14:22, Marc Zyngier <maz@kernel.org> wrote:
>=20
> EXTERNAL MAIL
>=20
>=20
> On Wed, 08 Oct 2025 16:22:31 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
>>=20
>> On Wed, 08 Oct 2025 14:43:29 +0100,
>> Jan Kotas <jank@cadence.com> wrote:
>>>>>=20
>>>>> Is it possible to trap/emulate HCR_EL2, and make sure E2H is always 1=
,
>>>>> in cases when only KVM_ARM_VCPU_HAS_EL2 is set?
>>>>> Would that help?
>>>>=20
>>>> There are no traps for HCR_EL2.
>>>>=20
>>>>> As a test, I tried forcing this bit before running VCPUs, but
>>>>> reading it via MRS got a value without it being set.
>>>>=20
>>>> Where did you read that from?
>>>=20
>>> I checked the X1 register, after: mrs x1, hcr_el2 in __check_hvhe.
>>=20
>> That's too late. At this point, the write to HCR_EL2 will have already
>> occurred,
>>=20
>>>=20
>>>=20
>>>> If you apply the following change to your guest, does it start
>>>> behaving?
>>>>=20
>>>> M.
>>>>=20
>>>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/a=
sm/el2_setup.h
>>>> index 46033027510cc..392c9f4016f2e 100644
>>>> --- a/arch/arm64/include/asm/el2_setup.h
>>>> +++ b/arch/arm64/include/asm/el2_setup.h
>>>> @@ -34,7 +34,7 @@
>>>> mrs_s x1, SYS_ID_AA64MMFR4_EL1
>>>> sbfx x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDT=
H
>>>> cmp x1, #0
>>>> - b.ge .LnVHE_\@
>>>> +// b.ge .LnVHE_\@
>>>>=20
>>>> orr x0, x0, #HCR_E2H
>>>> .LnVHE_\@:
>>>>=20
>>>=20
>>> With this change Guest OS starts the boot process.
>>>=20
>>> [ 0.000000] CPU features: detected: Virtualization Host Extensions
>>> [ 6.998696] SMP: Total of 4 processors activated.
>>> [ 7.257045] CPU: All CPU(s) started at EL2
>>> [ 185.781062] SVE: maximum available vector length 16 bytes per vector
>>> [ 186.104159] SVE: default vector length 16 bytes per vector
>>=20
>> Great. That confirms my suspicion that we cannot advertise VHE on CPUs
>> that do not have FEAT_FGT. Oh well. I'll post a patch to forbid VHE
>> guests on these machines.
>=20
> As an alternative, and in an effort to keep at least VHE guests
> running on V2 (and other machines suffering from the same situation),
> I have posted a potential workaround at [1] for the guest to reliably
> detect the situation.
>=20
> Could you please test it with your setup and report whether this
> allows you to boot a VHE guest? You will need to patch the guest.
>=20
> Note that this still won't let you recursively virtualise EL2 (the HW
> can do it, but KVM in the guest doesn't know it), but that's better
> than nothing.

Thanks Marc,
I tried it in my Guest, on top of 6.17.0. It seems to be working.


Without HAS_EL2_E2H0:
CPU features: detected: Virtualization Host Extensions
CPU: All CPU(s) started at EL2
kvm [1]: VHE mode initialized successfully


With HAS_EL2_E2H0:
CPU: All CPU(s) started at EL2
kvm [1]: Hyp nVHE mode initialized successfully

In both cases SVE is also initialized properly.

Thanks,
Jan

>=20
> Thanks,
>=20
> M.
>=20
> [1] https://urldefense.com/v3/__https://lore.kernel.org/r/20251009121239.=
29370-1-maz@kernel.org__;!!EHscmS1ygiU1lA!CSDHrEzxKt79BarWMdScZJ0yCSntOw-6r=
DX_3Xz6ic8fKw0huyf-Gu3y6C84cPTu-4Zu1KUk$
>=20
> --=20
> Without deviation from the norm, progress is not possible.


