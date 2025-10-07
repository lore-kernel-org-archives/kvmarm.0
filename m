Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE192DC330
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 12:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.84.65.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759839093; cv=fail; b=aJdmguzyazRRzMtX8+j3ohJiOH1j3IucwFafMRc/Tp99WVDpHQxu18IbTN5DEM3/r9bLrNwp98NrDJXE9a+hIn6LpfbjBVNIL4fnSFOIXk7qyxpxVUf7eJYgYfqn7IN0y44rak2fPfBvTvZyv/oBjhihTaIghT4pR+gM7avRWME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759839093; c=relaxed/simple;
	bh=5ZijK0cMUm8D9lmGDG0c0Xg383E7TI8haVq5JbYPRwk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c2mN41yyVPSpUTf8p7ETAPkkklURJNVyupXIxyhik/U3e6PtPyYtTn4w0Z79ey116OUQt84shEpQEDlzcqhX9rtq4acGMSV4vgxwYBdlWtqZ7LaGoIurtdpqrlLsmLYBNzp80HCMDXuL+Z4D94W6UI8rVGKn9O1onOGQDWTMk+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=IyOaetFM; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=S4B6eJ2k; arc=fail smtp.client-ip=208.84.65.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="IyOaetFM";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="S4B6eJ2k"
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5975v7QC002928;
	Tue, 7 Oct 2025 04:12:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=5ZijK0cMUm8D9lmGDG0c0Xg383E7TI8haVq5JbYPRwk=; b=I
	yOaetFM1kuno5+EqkZEkZdvborRFyz7nr0IIMWuji5MG9iE/lQorzOlmdfLY+wNV
	bR97GCPzNf7gtsxgrJ+IuvpNbUHIcAi3xpDLKjZsnm6t1IV+IALX5Uf3eepjWUSq
	cD/qZoiO13ws6ySQ70IGCMBFVNG3hZM40MgYyQx1fXygeVFgU+MEBHZ+XEKMR86X
	fBAgOz6HIGut8koVgZZ+TWDmIdLjUZolNCNHAiZCv1k10Wbg6rI0cymRxPso5Cf+
	zikXIrD5KIN6RywHPTkmJJqu6+oDH2yrjwiedmeUkm+4bqmPhFTh/hAI9FTLpIoK
	RwtX/Qa4OaqO87l2tcRGg==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022114.outbound.protection.outlook.com [52.101.53.114])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 49m920qce0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 04:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2GpwdwdVjH40sUB0YXmhN0Tnfkd0DMwsV1e3RXhX8Q7E6wP3dfu2R2tReaHwsVkg8aIlNi6+EXEmwKoJIhPKlzrvbeK4srtg/LRfTeA1uxz0uXvY3oHpkCwEXyUCPm7EBNriz12HiretPp3MffMYmQ7Fiap+ge6+acJhCI1jS00UpclcS3CFq4sYpxkxKjvbFLnd74itNrLot3tR5R1f7qaICVvQX3dt2te/DZUPmJnpKBmWjVjUcQOjK5Cq3bzcrHPJHzqvblKkkravMPIxkIgpqXXmkdnHsy8ZISj80b4v6i4PbJ8gpcO5uFy5sU7nigYt4s50g4gd/VnMnHs9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZijK0cMUm8D9lmGDG0c0Xg383E7TI8haVq5JbYPRwk=;
 b=oBRemWObUZTu7dBbOkcQeZvpYR27QcG6mjWqHn/m9jLBpMKPyfS8YKBm73/DG8+ucD6DJXcDFfUNlyfAld8iTZcVTANeQh0twtTu4FDICawZdY4Jh3ATtZQlx5S2/v0UevRF2E7Ss+EufwymZfMczvtmr3+K7niPm3m2fpyIRajWKwNp092fLRkqyvUrLrefz0m4vnF/VHUvNXq2tNrrTvAml8Xk1Xlx2kMxffW/ldXHkEW9cpsR0xfqKygvygMKMJ8DnM2osDqVmOA1A+Hl8AIc4wN/fUpYGrYfKCeLsubAzqLV+jKbP8WFj0mtIewxnRzWAYFyApne217R2o/jSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZijK0cMUm8D9lmGDG0c0Xg383E7TI8haVq5JbYPRwk=;
 b=S4B6eJ2kn23nFTdyE6MjEGLcz4UVKU6P0X8F0s1wT7McPCA6fJQBUdcK1/tIbot5ivoHtWVBxjSzFVhgUNoovWCw2rCAuJRoR0Bj1gJLgmjE9qIlT/BOphSgg9SD7iUl1prpwVG6OptM/OprabHmriEfz9zvKsOywI4KMDGOppo=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by DM6PR07MB6923.namprd07.prod.outlook.com (2603:10b6:5:1e2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Tue, 7 Oct
 2025 11:12:32 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 11:12:31 +0000
From: Jan Kotas <jank@cadence.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>,
        "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
Subject: Re: KVM NV + SVE host OS warning
Thread-Topic: KVM NV + SVE host OS warning
Thread-Index: AQHcLiUKR+wB9cgAPkys8N+jKyIMXLSj98IAgAAI7YCAAAb+gIAAeJmAgBIZ7gA=
Date: Tue, 7 Oct 2025 11:12:31 +0000
Message-ID: <25C5E00D-62BC-4188-8642-21913446B32C@global.cadence.com>
References: <799DD5E5-8BC2-47B3-A919-33429D3FB2F1@global.cadence.com>
 <865xd61tt5.wl-maz@kernel.org>
 <F9556C9F-2671-4EF6-A725-D080C3793A34@global.cadence.com>
 <864isq1r66.wl-maz@kernel.org> <aNXGW8C_S1TbFR9-@linux.dev>
In-Reply-To: <aNXGW8C_S1TbFR9-@linux.dev>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|DM6PR07MB6923:EE_
x-ms-office365-filtering-correlation-id: 2bba9775-bb33-4a01-5954-08de0592690c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TTZwaEJGNFl6ZWFCNWRMYnRERU1JVXNGNGlTUEZlSzhQc2Q1anJFVTh2TjRp?=
 =?utf-8?B?OFp2SVVaSVJLVHk0S0NQQWNpNXExOHBOOHd0di9MMmRNYUZYeDNUQXF3YXM0?=
 =?utf-8?B?YUREckttd2xvZ0M5NkVPcnNFang0ZDV6WVJ5a0dsQ3lSNTVkQUcvRjJBUTNt?=
 =?utf-8?B?cUpEN09taWZ6RG1zYnR3Sm1iU3VxeHc3Zi9VMHV2QmdTNU1rQWttd0JSMzhZ?=
 =?utf-8?B?eGh1WTQrVjRTeTFOTFRFZzF6YURQVDNRY0VYUnJLZ1cyUk90OE9kcFBucXpq?=
 =?utf-8?B?ZGNBUmVsblVOZ2JTVkk4QTlDMFFKYkF0MGJsNUhhcTVVaXdtYmU5eW8zcGRV?=
 =?utf-8?B?Ti9WSVlXazVKY2R2RVhtUVR0TjRIUE0rYWtFZ3BxcktZV1d2RVNDRjUwaEs3?=
 =?utf-8?B?ZkROTHZKVDhBdlVXZU1DZDZNR2NWS3J5L3Y5RGZIdmdqUE5hZzdrY25XQmVT?=
 =?utf-8?B?b0xESXVoamtXakhXcStla2VTZEQ5c2IzTFB0aE15c3BzUW1WMkVDMTIvZFZP?=
 =?utf-8?B?VEJBam5KUWpXc2pqUVNTbkRrZ3ZmaFE0V0RJT0ZNcW5BUXVqa2NBVzNiN1lN?=
 =?utf-8?B?dUdRSlRNdnREczJ3MVNnT0N1Zm1FUE9CVTI5Lzl1NmVQeG4yenZBSWgwNUxx?=
 =?utf-8?B?VUEwWUFDRGhiQ2tvWWx6OUtwQXBoZ1JlcEpGYUhDd2E5bWk1Tm9TZzlCampy?=
 =?utf-8?B?VWRkdlRjZHNyeFIrUjM0OUpuTGE1Z1JBd2N1WjJWaGU5cEZIYkZHaFZJQ2lj?=
 =?utf-8?B?MGMwSUl3emluZGplWVlqMmNFcjgxN24wY3JRSTBsbzV5UFVncG5iekdIdlZI?=
 =?utf-8?B?NjkxTmtCM3BXd1JSSWdjUE5VbUREay9mejJsQUNweElBUkI2NUk3NU90N2Q3?=
 =?utf-8?B?V3VDa2FUbzQwbmd4S3RJVlpYSWhVQ3drTHExTkJCL2drcjNGVzhjT0k0MzRI?=
 =?utf-8?B?NmNZRm9UczJwMUd2YUh3TXRKRHNpclpxMElKNng1aHlTTlVRbkVPY2sxMEt6?=
 =?utf-8?B?TjU1RkNScUtibWY4QzVDMHJ4LzUzUWRBbmRZT3RoUi9IeDlTQXowdXZ5VjFi?=
 =?utf-8?B?UjFmM3c4R29OQXEyS0pES3p0MElLZTBPOU1vSnI0TUZtbzUwdjdXdFN1YUVX?=
 =?utf-8?B?WjRvU3VZVldTSGN2eTQralBhbURuQVR3c1k5SHEvejBodGdUQkMwbW1oVHEw?=
 =?utf-8?B?WXg3S21RYktxRzlQaHZBankzZDlZRmx1cjQzekpYZEowOVRTVExueVAreFRu?=
 =?utf-8?B?Uk1FWTVqR2NkVnJudTZDZDI3NFpNdWpQcVhXbEEwZkdVZHBVcnFLMlpVU0lL?=
 =?utf-8?B?RHF5VEl1MFNhWExuZHhGTHU0SDBmWmRZV3J2djYzcHNUQVJsbDArSktwWU9Y?=
 =?utf-8?B?NUdEMFMyWVJaTThBTkh2NUpwRWdPcEREemRVQ2NJWmM3dG9PU0J6YkJvOTUv?=
 =?utf-8?B?T2NGZXRNV0o4dmlEelp6a01hQTVaOEdIZzBEaWJUUXUyeDB3RUY5R1dXNy9H?=
 =?utf-8?B?WnhzY3NJMzRZdVZ3aGd6WnZLcy9kNEhid0JTb2RhTitDNUk3Nk5BZW5ub1lx?=
 =?utf-8?B?TDhROG5CT3pKZ0VJbmkrUE9EUEdZRFBEOCtVY0M3MkhLdmJXWVNDb0dwWGFY?=
 =?utf-8?B?Snp0ZHpPaS9haThkdlN5bUNENkNZeUdicG42YXJYTUoyQjQ3aFF1TFAvbFVD?=
 =?utf-8?B?VHFtTHNWVENVVkhJZktkZ0lSU25VRWJuQWl3WVlhY0NPUGhXUGVnMEhKMmpP?=
 =?utf-8?B?QXdRNFJBQ2tGVEE0c3c3MXZsT0xuMHZTNEJSYnhDTGVaWXRlR2ZlR0pUamt1?=
 =?utf-8?B?UWJTa0dpRk1lc0dLU1RYOTg3QmtaaXJQME5GNDRSSEdWaXFuZklVbmIrcklU?=
 =?utf-8?B?V3dIU2I5elg3T0xrNEFHMGdPT0hGaTNmOW9qUkxWRkdRZ2IwZk12NStKaU93?=
 =?utf-8?B?OUpjdCtKOVFVZFF0Q3RuUTFZQllBeVBiU1VBKzlrR2R0alJua0k2VHo4Vkt3?=
 =?utf-8?B?djNNeGJKOUh5WXU0Q29COTNmclJId01HLzZIaElSVWQreXpvVU1zOVVtNThI?=
 =?utf-8?Q?Rk5Ph/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WVB0RExydTdOaFVQZkdGUHU3WlJyOTJ0bkpVcWFIYzdjTEdGcVh2dk5XdnRr?=
 =?utf-8?B?N1V0WE1ERFJocTZiWFNjTmQ0U3EzSEZQR01sTWx2VDdKaW8xMWZsWW1pSUJs?=
 =?utf-8?B?MjRoUW9saDByNHlNejF2TTgxdHRNVGZoQ0xZRzY3MmtxM3EvQlZHQjhONVNR?=
 =?utf-8?B?UVdyL1BuNzlMSTY4T1dQekhmdUZRVmkxYkpZUnhwdk13b1piditNMjhnb1dT?=
 =?utf-8?B?aFpncEhubjhSMjNLQ3NTVUZmR1RYcXJ3b2xwWnY3SXU3RVFCRVNDMHFoSzV4?=
 =?utf-8?B?eXVqdVllcG96OXF2ZmFLbGNDTThTMzhNRnRlZmYrTkJxanNXTVJQZnJzVDM0?=
 =?utf-8?B?R25SNjJycVFEWWdKT0JPNENmMzZldGtGVHMwYTczNmFMM0VYK1Q3SU1yZGxl?=
 =?utf-8?B?Y1RFc2xsQmR3a2hicGI0TTg5b1doTVBENjlsa1pGUW05YnJTRStEQVkzdWJw?=
 =?utf-8?B?WjhIZWZQVHRWd0lLT3VUcDh4QkdwMGhVOUlEUzZEdXgzM3JadkxKam96Y0VM?=
 =?utf-8?B?VFRjMytxY2dWeUFTN1dFWXN1Q0pzT1RUek1pUWRUVHA4ZytlT3VOUVlqbzZw?=
 =?utf-8?B?YngvbUJkbFZBYnZNOWI1Um5SOHc3NHlzS1VWS0ZEUkdYYTMydWxZNUFoT0h0?=
 =?utf-8?B?a0FQYzlVUWxOV05nZW5yMU0yeDRYNG94K3FOb2E4ZW8yVXBpSE9VekZuU2ow?=
 =?utf-8?B?OCsxWkZ4aVZGM1VQZldmYkZOaFpKTDc5dGtQRzg0NENVWktRNHE3TDk3dDZm?=
 =?utf-8?B?UUVJMkVRbHBjeUwvbmZZMGFTMWozcVZ0SUY0Z2hSWlRxSGtTSUFwcnNkZnoz?=
 =?utf-8?B?RFRSSERSM05GMWlMeGVUc2ZSN0g3TGx1RVBQOWJWRmZCWTBnWlE2RGMxb05p?=
 =?utf-8?B?RVc1UUZVNkpIalozQ0Y2S3lDM0o2Mkx6dnVFWCtLdHk2Y2FlTElpcmZuTjNl?=
 =?utf-8?B?UDg3UWpHcEErTTY0bCt1NVNTbWt5UERBeCtQSURLb1hLMDUvOHU4c3g1WURq?=
 =?utf-8?B?ZmRnVC9tcjlXR1lEU0cvWDFSZXlabmpWekM0ZkdIbzRGUk1ReDlHcWV5UjNX?=
 =?utf-8?B?a1NTV3lUNXhsMHZ4L3NJV21HY1ZIL1lCWnFKcW1sdDY4K244cHpYdkxTUzA0?=
 =?utf-8?B?UHYvUU5NRG1pTWZRZGJlNG9aTHltZDZ1cDkvQ0cweGQ4V2xCWVkydUxIYVhE?=
 =?utf-8?B?MWVFMnhVb2h0N25MWjhMTmdLc01jaEIwN2Mxbmpkc05vVVVYZmt3RmJSUDVs?=
 =?utf-8?B?VzJvUGFHMjVXV2owdnh1emxqMXhBWXVPbVNteTlNUjdCTUFSM3JLemdvdS9p?=
 =?utf-8?B?TUtJODNhV21iNTRZV3F6TGNySzMvR2tnYkEwMnNNa29MbWRLVERacXBuV1ZU?=
 =?utf-8?B?VDB4SVkxV3p2UHppbEcxTFl0MzNlL0pZZ3FoRTJYdm9XZjh1UnRnNVR4UUNa?=
 =?utf-8?B?U0Uyb05HMkVRMENPcGFlTmYyaS8yVnZvOHA4dWdrQWx6WTZaYzhHd3FlUGhW?=
 =?utf-8?B?cERTRktTem8xMVFObG00WU1xTTlFdldncTJJS2M4WDV6b1QwMDVPUFZQSHVW?=
 =?utf-8?B?eXMvbTR5OUtoMlFGeldOYmJmTStGa2VWcUhLelphWE4vNDRtcThydm1VQW02?=
 =?utf-8?B?dWlGY3J1ckFXczl2Sy9zY3hISmhaQi8zMFJ4MG93V1lJb2M2Qm9jakROa3li?=
 =?utf-8?B?QVNCYklJVnVtWTlKdlVyVm1NcUNvQzQwS3pWZWZjY0U3WjR4cWQrN1ZIN0c4?=
 =?utf-8?B?VlkwMEw3NHltRWxySkE3cmd1OXpnbEJFRHdFM3Qwc2lQUkg5MkZNY3RnbXhW?=
 =?utf-8?B?MFpMQlc3OTg0M3IvY0IwUkxDQ21RUk1DUG1YVjFRbzZUQWx5L3FaT0RlcTBr?=
 =?utf-8?B?MzZLVzZRTHVveW5EUlBnN2llQUZ3aWtBYUoxbWczbmtZWFRycW5xR3ZaN3pY?=
 =?utf-8?B?R0I4YjR1OUlsaEZJNG9XUkF5b3FiMFFoTkVQbFdiRENjQ3JHNytlL1U4WnBQ?=
 =?utf-8?B?OXVhMGJpRmowWFF4QlFRNk90MlZ3ajBqcWFZMFA1SHBxakJDYXpmb1hmR0xG?=
 =?utf-8?B?cWk2SnZkSkg0TldlblY2NHNsaFdMUlBKZ1ZTLzdST3A1NytIUmh4VndiOW54?=
 =?utf-8?B?dkZkSXpWbGF5WHFpQ2pxUkRxUXZwcmpkMjRhenEyeGxXOHV4US9hSHZRQW5h?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0BA7D30A74A31499623967F0A9B55A7@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR07MB9604.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bba9775-bb33-4a01-5954-08de0592690c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2025 11:12:31.8799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V6nwVaM//634eYM1cpPmnhiOSRIzMjhDWMzsQB10Q2BV4f8J0r633PVD+TZ/rEDdWWPuMCNZHJMy3VQzyOjxOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6923
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDA1NCBTYWx0ZWRfXxUlBVYbVuCDT
 2rCOBS8vw0kLZt/3aV9mKoy3aiK36pzkCdWuB77tzM+jc4a7K0oTJ7gr2gE5Rb7aqQ26zcvmkZ+
 9PrKzM/iGpSTCNIGKdOi5rFADJY9uXm1hqLdha2b96lDWw8Efj2348Ww91fIlnhCUMUdjRmfeqj
 m9aQ73heHi8OOMpdzOpzojcUMxoKAHlTawcQpKt1xrX7gN1OB5TUaiYPSIo0JR/HC+e5FcakGnQ
 wibEA7LrncaCKKtgU4cV7ulqUDQ8FsxWSw1pE3lZqwiUprHs63H0ZjLbVBj0cmxUrnomK/JEHav
 0/8qDdo/BLcD3IguyyZ9lrlp9nhxWTqNuMALlbJ5CBxie4HfIWEEhKR65Sp+Ro2QZTH+Kc0h9mZ
 nmImX2nukXzmW9o3icRTjz8A6BFLsg==
X-Proofpoint-ORIG-GUID: zYGUbLGjJ4cS-fVw0cZeI1K5Uo31w759
X-Proofpoint-GUID: zYGUbLGjJ4cS-fVw0cZeI1K5Uo31w759
X-Authority-Analysis: v=2.4 cv=TIZIilla c=1 sm=1 tr=0 ts=68e4f5a6 cx=c_pps
 a=PPij9JC9dsFwf49xmEs+Gw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=Br2UW1UjAAAA:8 a=VwQbUJbxAAAA:8
 a=OMRQQuwwG-1QMcZOJOIA:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2510060054

SGVsbG8sDQoNCkkgd2FzIGZpbmFsbHkgYWJsZSB0byBkbyBzb21lIHZhbGlkYXRpb24sIHNvcnJ5
IGZvciBhIGxvbmcgZGVsYXkuDQoNCkZpcnN0IEkgYXBwbGllZCB0aGUgIkRvbid0IGFkdmFuY2Ug
UEMiIHBhdGNoIG9uIHRvcCBvZiA2LjE2LjkuDQpJdCBmaXhlZCB0aGUgZXJyb3IgbWVzc2FnZSwg
YnV0IHRoZSBHdWVzdCBkaWRu4oCZdCBib290Lg0KSSBkaWRu4oCZdCBkZWJ1ZyBpdCBmdXJ0aGVy
Lg0KDQpUaGVuIEkgYXBwbGllZCBpdCBvbiB0b3Agb2YgNi4xNyBhbG9uZyB3aXRoIE9saXZlcuKA
mXMgc2Vjb25kIHBhdGNoLg0KR3Vlc3QgT1Mgc3RvcHMgYm9vdGluZyBiZWNhdXNlIG9mIGFuIGV4
Y2VwdGlvbiwgd2hlbiBhY2Nlc3NpbmcgWkNSX0VMMi4NCg0KSSBjaGVja2VkIHRoZSBFU1JfRUwy
IHJlZ2lzdGVyIGFuZCBpdCBoYXMgMHg2NjAwMDAwMDoNCg0KQWNjZXNzIHRvIFNWRSBmdW5jdGlv
bmFsaXR5IHRyYXBwZWQgYXMgYSByZXN1bHQgb2YgQ1BBQ1JfRUwxLlpFTiwNCkNQVFJfRUwyLlpF
TiwgQ1BUUl9FTDIuVFosIG9yIENQVFJfRUwzLkVaDQoNCknigJlsbCBjb250aW51ZSB0aGUgZGVi
dWcgdG8gbWFrZSBzdXJlIHRoZSBpc3N1ZSBpcyBub3Qgb24gb3VyIGVuZC4NCg0KDQpSZWdhcmRz
LA0KSmFuDQoNCj4gT24gMjYgU2VwIDIwMjUsIGF0IDAwOjQ2LCBPbGl2ZXIgVXB0b24gPG9saXZl
ci51cHRvbkBsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gRVhURVJOQUwgTUFJTA0KPiANCj4gDQo+
IE9uIFRodSwgU2VwIDI1LCAyMDI1IGF0IDA0OjM1OjEzUE0gKzAxMDAsIE1hcmMgWnluZ2llciB3
cm90ZToNCj4+IE9uIFRodSwgMjUgU2VwIDIwMjUgMTY6MTA6MjIgKzAxMDAsDQo+PiBKYW4gS290
YXMgPGphbmtAY2FkZW5jZS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IEhpIE1hcmMsDQo+Pj4gDQo+
Pj4gVGhhbmsgeW91IGZvciBhIHF1aWNrIHJlc3BvbnNlLg0KPj4+IA0KPj4+PiBPbiAyNSBTZXAg
MjAyNSwgYXQgMTY6MzgsIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+
PiANCj4+Pj4gRVhURVJOQUwgTUFJTA0KPj4+PiANCj4+Pj4gDQo+Pj4+IFsrT2xpdmVyIGZvciB0
aGUgU1ZFIHN0dWZmXQ0KPj4+PiANCj4+Pj4gSGkgSmFuLA0KPj4gDQo+PiBbLi4uXQ0KPj4gDQo+
Pj4+IA0KPj4+PiBJIHdvdWxkIGFsc28gcmVjb21tZW5kIHRvIHVwZGF0ZSB0byA2LjE3IC0tIDYu
MTYgd2FzIHRoZSBmaXJzdCByZWxlYXNlDQo+Pj4+IHdpdGggTlYsIGFuZCB3aGlsZSBpdCBtYXkg
d29yaywgaXQgd2lsbCBhbHNvIGhhdmUgYSBsb3Qgb2YgdWdseSBidWdzLg0KPj4+IA0KPj4+IEkg
d2lsbCB0cnksIGJ1dCBhcyBJIGRvbuKAmXQgb3duIHRoaXMgbWFjaGluZSwgY2hhbmdpbmcga2Vy
bmVscyBtaWdodA0KPj4+IGJl4oCmIGNoYWxsZW5naW5nLg0KPj4gDQo+PiBXZWxsLCB5b3UncmUg
YWxyZWFkeSBwYXNzaW5nIHNvbWV0aGluZyBvbiB0aGUgY29tbWFuZC1saW5lIHRoYXQgaXMNCj4+
IGRvY3VtZW50ZWQgYXMgImV4cGVyaW1lbnRhbCBhbmQgc2hvdWxkIGJlIHVzZWQgd2l0aCBleHRy
ZW1lIGNhdXRpb24iLg0KPj4gQ2hhbmdpbmcgdGhlIGtlcm5lbCBpcyBhIHdhbGsgaW4gdGhlIHBh
cmsgY29tcGFyZWQgdG8gdGhhdCA7LSkuDQo+IA0KPiArMSwgYWxzbyBpdCdkIGJlIGdvb2QgdG8g
a25vdyB3aGF0IHlvdSdyZSBkb2luZyBpbiB0aGUgTDEgYW5kIHRoZSBMMg0KPiB0aGF0IGxlYWRz
IHRvIHRoaXMgYnVnLg0KPiANCj4gSSBqdXN0IHRyaWVkIHRoZSBvcmlnaW5hbCB0ZXN0IHNldHVw
IEkgdXNlZCB3aGVuIGRvaW5nIE5WIFNWRSBhbmQgdGhpbmdzDQo+IGFwcGVhciB0byB3b3JrIChr
dm1hcm0vbmV4dCArIGluaXRyYW1mcyBhdCBMMSArIEwyLCB0ZXN0ZWQgd2l0aA0KPiBzdmUtc3Ry
ZXNzIHNlbGZ0ZXN0KS4NCj4gDQo+Pj4gSWYgdGhlcmXigJlzIGFueXRoaW5nIGVsc2UgSSBjYW4g
cHJvdmlkZSB0byBoZWxwIHRyYWNrIGl0IGRvd24sDQo+Pj4gcGxlYXNlIGxldCBtZSBrbm93Lg0K
Pj4gDQo+PiBUZXN0aW5nIHRoZSBwcm92aWRlZCBwYXRjaCB3b3VsZCBiZSBnb29kIC0tIEkgd291
bGQgaWYgSSBjb3VsZC4NCj4gDQo+IEFsdGhvdWdoIEkgZGlkbid0IHJlcHJvIHRoZSBidWcsIHRo
ZSBwYXRjaCBpdHNlbGYgTEdUTS4NCj4gDQo+IFRoYW5rcywNCj4gT2xpdmVyDQoNCg0K
