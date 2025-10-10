Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271854414
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 12:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.86.201.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760100604; cv=fail; b=JPY/C2kYlLoF9I/NIk5md/odB53CfRVF/hRzS5sbaLd99UPHqvwAIsxf29jll/efNR0c3ZvEDUZOwTX2xtiIXhWQhz8qm58hyIF5LDiDPScYpqcox25Zz+0SZ07JIJ1dRJ8ZZboXpRQqtL0qUGMA4eHvsuLjNr44Ljjxo9EAP10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760100604; c=relaxed/simple;
	bh=J87rkzQ/ENwsn1FwZgIlATxmKu12gj8/i7j/sxY8vFg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=raxIdOQno1dTEOROcpx04+ZseQt3ScCTkK0BitiZp8PknMXN0Q08vGFDWSfNMd/0GVhWReQv1c1PXPly/ruO+GCal8NVNODVzYi8mzSCPft9gt2JF/F9I4VlVUWg4Feg+uhGt3wpnNXhFQJANq6Y3M8Sgc2mpTAWfrVuWRp7ixM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=o7hcJOzI; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=hNmgrbfl; arc=fail smtp.client-ip=208.86.201.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="o7hcJOzI";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="hNmgrbfl"
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
	by mx0b-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59AAOKvV004727;
	Fri, 10 Oct 2025 05:49:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=J87rkzQ/ENwsn1FwZgIlATxmKu12gj8/i7j/sxY8vFg=; b=o
	7hcJOzIyW+SXlgRjk45T/TuaV8oPdUQ1kkJrQOPgqPj3LYGktzn9Hp6ojCqNRMnw
	MZVXRg2jnY9QmP/gVPZT3mCRGJkiifl4PEvI9KvCjhWlPTpFMdgpj7PVE1qW1CAx
	NTLk5gzfQQCgs1PnnlSAxZoW8XUC2SudjU6TaYjrOtchbXrxIw3eEf4BJqYWsq2A
	rXVk0EqtUVLCSY92l9BKRapWqdLlnn/STD+9oD/fO6PMD7mNX/AnoD2IAZS0sGex
	8QUi+aTOn+aGYWzkDMAdw6tGzr5+jFzuXIcWqA8fgB8QPoVFqWSZSrlREdD4BetV
	Tgfse0NcxXyVDTPmEV2+A==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022111.outbound.protection.outlook.com [40.107.209.111])
	by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 49nv62t6t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 05:49:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YT/QiEOy9IgDRHaiUFoklk8wDMPzj1CLCKUcTWIaWo4MvzRlD1moHV5JL1Erl1BWYy0fmiEWzQaXyu/z6XG7GrO9ZbvnMaueip9JRk5A2RkSCK8AT44afOzjH/BcrFzNjF4y8JQD4xvLY3xp2Z8JRarYWbyW6zSMsiPmEaBclXg2sQ77UzKX2VD/RgfBgyUOnFjqfBLhoJwUfBG+7waJx/vgPYjXjqb8gejMERP0zmhQykNWS2DKwAKrYluC3oov55lpga1gNiye6UQdjZdRrw53vKh0IFRr7Vh2N8N0X1hQRNYQS/T2IblY/en4QZf3pC9H/N5aFLvzAMTEMlC19A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J87rkzQ/ENwsn1FwZgIlATxmKu12gj8/i7j/sxY8vFg=;
 b=cv15ZDRYkw03C7obYRn2HiFLpB2kTbuEqfAPrJ9CrUravM6obmYfLsBlBYKCPJO364Byusc8/QAHuLfrLRJ93sK17xzQcLj1Mn42fyjqAmQMk3HoKTEfT9dKZLimIxJTKMsFEtisrCWy0pyHimYMt20J7OVGrEIOq/eCaYyAPN+HL6CMcV594RNO/UrWYh0m6E0xikmNcEh8OJW713uJdmgSZC1l6s5vgQzhgArATbji+mtJzdda6XL0m/pTWqcwAATcXoy3Okl6zxbJaVymJoM53z+wRO+rwfCQC4ZnLa5bPoifO2usRvsS72c1QzNsB8gCf6z7KQszy26okIzhLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J87rkzQ/ENwsn1FwZgIlATxmKu12gj8/i7j/sxY8vFg=;
 b=hNmgrbflbSy0IsM1HFDS1tF5LqpBnXFYQrwBHZyyon0COGuGrezBauORjXJ4mOsQSrfbd7L4ND2HvRd81PvmpJcQd95OsRLZOraR1tdlYTxuHmlR///OGb2acRT4CpIQvXz4UZfNuAXvTvpKqEo9JQ1KG6/eNPklT6IZOAw32/E=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by DM6PR07MB8126.namprd07.prod.outlook.com (2603:10b6:5:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 12:49:43 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 12:49:43 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: HCR_EL2 GET_ONE_REG value difference
Thread-Topic: HCR_EL2 GET_ONE_REG value difference
Thread-Index:
 AQHcOcAYVqsE1KhNtkOoBBTRbaAYVLS7H3+AgAAD9YCAAAsygIAAB8YAgAAQtwCAAA4CAA==
Date: Fri, 10 Oct 2025 12:49:43 +0000
Message-ID: <7867DE4D-41A2-4195-AF98-0055987D4D93@global.cadence.com>
References: <47FBDCE7-F8D8-4071-93D8-E4E494D41F34@global.cadence.com>
 <86ikgnxfl0.wl-maz@kernel.org>
 <2268E166-0EA0-4C9D-B1AF-EEECB48B926B@global.cadence.com>
 <86frbrxd2m.wl-maz@kernel.org>
 <3E1DF662-DD3A-49B4-A67E-55E9658BAF52@global.cadence.com>
 <86ecrbx90j.wl-maz@kernel.org>
In-Reply-To: <86ecrbx90j.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|DM6PR07MB8126:EE_
x-ms-office365-filtering-correlation-id: 3c824238-993b-4bbb-cd6e-08de07fb7c49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WFNFb2g4RkxiMERiSlFnNVJEcCtwVlpFY21LcWdKRUIrd0R2bE0ycVQzTXFV?=
 =?utf-8?B?dWNLZXpPUTE4UWV6T3ArS3c3dDNsRjJZbFdSZEtmbGZPb2xKR2U0TGdPeVhh?=
 =?utf-8?B?czRXWmg3cmxHYmUzMWt3YWRwQnlsZnZ6S0lPMGMvK08xN2FibC9oZjQ2ZnFW?=
 =?utf-8?B?L0FUekVtQXlVZ2dzdTJ0VFdweGJrNWl6Y0IzMnVNa09Tc1FqRDNTQnlUM2NE?=
 =?utf-8?B?MmNhanVUdnQ0VmVOMFNiMkZ5a01hZC9yaXRYanJKVzAybXNQUWcvelQ4UkZx?=
 =?utf-8?B?bW5YT2pZQ1M2OHIwd2FweWpTREt4Nkd5MTZndjF4azQyTldrS1JnbjRZQ2Yx?=
 =?utf-8?B?eUxrQ0hnVEdtQzJOcmw1b1kxNkZ2RHZGdVkzdUNCdTZWNzlwQUFpQUVDYUE4?=
 =?utf-8?B?bUhSQjNad0R2aVEyN05hNk4zRUNzNmFYMFhwVmMwQ2hPYUFPN2J3YUtFQVh1?=
 =?utf-8?B?MElaeEViMHMvSms2ZkRqcUVtdXNmTEJJYWlycU1jWHkxSWZUNlpXZ0hqanlL?=
 =?utf-8?B?OHU2dkxVNUUrbXZDcVlrRGpWSnp1SXROL2NnS21Fc2NNT2pQRnJ3dWpVRFRj?=
 =?utf-8?B?dTZMbW80WGJXa3NiNU84c3NwQkRxdFl5MVdHMlRpV1RzcjJzZ1BySDlrMDZp?=
 =?utf-8?B?MEwxRU8rdDVQQjRnOEw4dGRVRUNHWTEvL3V1T0pIMXhTOU9IYUIyTWlSMVVZ?=
 =?utf-8?B?VHBON01LUFZiZmNONHlUVURxa0VkOUdtc0ZtNlBTZTBISTljaWkyLyt6aktN?=
 =?utf-8?B?dnhLTE5XSk90TllZQ29YTUF3NmI1eGJVNDdQN3NCaStwVmtFcFpQdEpveGRF?=
 =?utf-8?B?UGxPUjlKNGxTSEdLd2dkbkJMK2doYW0rRGVjZWxMWmdJNE93cE5jZ1BCWVor?=
 =?utf-8?B?b1E0aHFPTnBhYlB1TDQrK2tGam9iWDdJQTQ4TVRkSFZlcWZEajk5WlpqR0Ny?=
 =?utf-8?B?N1pkZVF2QU83WktBN1hkYW05SW91bHhZWmgwOEtFTVNoNXFnT3plZzRGbmF6?=
 =?utf-8?B?ZHFoU2FpVkpkNnVPOVFyaXpZYU5hSVpKdituSEhEVUlObUhrUFJVKzR4WGFR?=
 =?utf-8?B?UlRwYk5WeDVQanMxTFc1VmV3MzFWZ3VmVTJibW9Fa0xnMGJKMmViT2lYV2Jo?=
 =?utf-8?B?TmdmTjUxeis3TUQ2SUh5ZVltRWF1VEpRR2ZLWkh5bzY3L2xCZG11d3VRSVlp?=
 =?utf-8?B?eVpuSnRGNTBsVmszbnZWUElSR0JROTNZMi9aYjRrTUgyMXNodUhZZVVhbCs1?=
 =?utf-8?B?Rzk0OEI4Vk9vRjZjYjJlUFpHc0xubW16elAxSUFzSGNYZTdpSVJ1bXA2OXBZ?=
 =?utf-8?B?bWdpVUNkTXFGSFBpWEdETHBrMm9tRk55WnA0RTk3SEswMnhEVnFhall4a0xz?=
 =?utf-8?B?QkwvalUvMHZINFQvb0diTWVlM0VnZ2EwaC9hTTdSb1NoandRQ3k1VlFha1Ex?=
 =?utf-8?B?YkJLT0pNZ1dGOE5udWcvYWRPQ0NNV1VEbmJHc1c3T0c3SW54S0pIRlZqcytx?=
 =?utf-8?B?bkxxOWdQdGNLOUsxOWQySE5yR3VrdWlUU3QyNllYOFBGclhqQW00Zm9ZdjNo?=
 =?utf-8?B?cEVVR21ObHVFS2dIWjF5dTRjd3NnVEorWmJQVGN1OXV4eHZHbVRWNDFvQi9M?=
 =?utf-8?B?NWNZeWRyRi95ODkySDJhaXZPaC9JcytkY2ZtQ0Z4VmNOOG5yK1VaZXZITmJY?=
 =?utf-8?B?VWpkbGlPcVhkSDFPNkZMOEN4R3VSNEtuLzRPeVZQajJ1YVdhWkVPelQzM2VT?=
 =?utf-8?B?Z2tIbUVTL21mUjJRS0I5V2ZENXpkZkh5dE52MHpzdjNOWHU2SEZWZVVFR3Fs?=
 =?utf-8?B?eFhQNHl2UDJPUDIvMFFzT2JGaWM2ZmxsWUFzdjJmSEVyWTNRTWVGZk1VRStP?=
 =?utf-8?B?MmloekRFcW1PYnhkLzFKc3czczBIRWJZbzB2VWRPbUVNK25lSUJ1Vm9FVFV4?=
 =?utf-8?B?SFM3RU83Q1ZWRythc3lxZVc4aXJDVW1PS21va0o3WFZsR2M2TklSMDN4aThR?=
 =?utf-8?B?UGM0V2M0amMyKzhRM1dtQzZTRG9Pd29JaEcxSW5WUDZTbjQ1NmRQQUJDS3I2?=
 =?utf-8?Q?N+2GKC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SmRKMTlmb2grT2EyanlEcUlBaFh0YkF2YjdkZW9iRUVacWNwRlFQTkRLVnRQ?=
 =?utf-8?B?OHNDZHpWZ1QvSlh3RjhLdlVzQ1NDbU1NSWtScXpzZ2VyM2JxR3RMK3NJekhk?=
 =?utf-8?B?c2VJOTFqZTA0bTAxVzAyZnJyTFlDV2NUck9nUVNCaVdZd2FwalJjbUQzeWhY?=
 =?utf-8?B?ZE9tN3B6OFdOSitENFlNQmREazFWRXEyL0NVdHNuVy94ejRPMUJDOFp1Z0dP?=
 =?utf-8?B?YWcrVEJWWmVrajU1cll0b0Y5WDJNN242Njk5OHdqdG0vbDQ3WFBFMDVWWjgz?=
 =?utf-8?B?WndtQytRd3dkNXlEUlp3QkI4ditRazQ4OWN4a2VSYUlUUGZVNnYxSEN5ZlhZ?=
 =?utf-8?B?ZTZ2M1VYeFBEbVhiVmN3Sm9VME8yQ01BaVpSRE1rOWNMMkE2UFRuanlDKzlZ?=
 =?utf-8?B?Z2YyNEpUdlk0UjFMd2FsOVd2ZVc0OHFONi81T3JuTktzS0RYRTBFY0pRVmxH?=
 =?utf-8?B?NWhsVTZTSk1DaHRGTFU1ZFNHR0M3alEvQi9NUzdNTnM3Rk0vb2FTYVFjMGND?=
 =?utf-8?B?MmFRTzdxYjFMZHpER1lxUFZlendmRkZPNEg1Q2VqTjMvQWZhRVhLYW96N2Vv?=
 =?utf-8?B?bHcrSWI3ajFBUXhweEZEeEJuNmNQY2N4UlpCN2xLWWV3djBzVnVlMWFlaEZV?=
 =?utf-8?B?YitKME43dzdUcDY5bm9ydHZyRXMzd1Npalh3bU56SGNJMFFBVU1qSDlzWUtF?=
 =?utf-8?B?N1J1blhtdE9sUDBCcTNKWVltU3R5aGZYeUhpaURMUVdzc0dXczFzcGxObkl0?=
 =?utf-8?B?VnJ3VEJnOGgxcGpSRVFDMzdLVys2S0FCTmZHUTd2RVkwYkk3S3ZENmVYemFK?=
 =?utf-8?B?WEZyUWpRNFBGQ094ZzhuU2NJdzJoSXBqMlVjNEVxb0J3Sm9qcEJBZ3hQTGE4?=
 =?utf-8?B?elBvUjdGN0VXaWlJTmhzUUp2RFB4S0k5UTNEY3AzWFNoVVovR296ZTlRbk0z?=
 =?utf-8?B?Ykx3Y0dzU3pOOHRIUE9Sdnpuc0E4RzZmMFcrTFFKTWpDdEliNmVTdG5xSkV3?=
 =?utf-8?B?WmFndFBXVFZUT1dDdy9IMEZUTXNKa1UrMit6dDBOVEdGQTM5MERTSUJKcHEv?=
 =?utf-8?B?ZjdrNFBSQUk2MWRRMHpMT1hmd0w0L0g4Wk9wbWtSQ2tXazMzS09FSW1qWTN3?=
 =?utf-8?B?UjBFRStBcmRBWEs4MHJidTB4bFBqZXpRZCtPOWhJZHFXYVRLME1yODFERm1C?=
 =?utf-8?B?TEJyQXVWQzZjQ3N0Sk5xYjRzZUR2eGhId0hDT3g2RmYyYTlCYlovWG90V09O?=
 =?utf-8?B?T0ZXK1dnUlBoOEdtUkMvRThxL2lUSWJ3Y0cyci9OYjRvaUtJSUNtWUhkbk44?=
 =?utf-8?B?ZlZzWWNGMHFzejhzTHh4VURienFzL3Qza2s4VUYrTWN3aGJTd2VxTjBrRjF5?=
 =?utf-8?B?eFU4OVc5WThaZnVqMTFVWGpTUDN0VzhVS1lyZHd6NitIcHJmNjRPY2RNWG93?=
 =?utf-8?B?ZXJLTEl0K1JBU3VUMERzRjVlVDdKS1JmbFdwcmErRG53WTVxNlVtQzMzWXNj?=
 =?utf-8?B?cnRHVDdaVWJZSTVYQUJZWSs4OWE2TVJHWDR6c3dJSjRjcjdkRnR4ZzlpOGx5?=
 =?utf-8?B?MERmY0d5NXV3ZlVyTk9NMFFraVVoMy9jYnFOUjhHN2k0cDZ4aWRGOFc2aUZE?=
 =?utf-8?B?dXlFNjJ4Vnlac2NMU1BWclpaRWpHNGNwK0Y3enRXREtURkJIb0RRaDQwRHdr?=
 =?utf-8?B?Z3k2S1lnZWFOWDdrL1V5TVZMWGpQMlFlU3RYMWZ2V3ZrcW9QMGZyWkdSSm1U?=
 =?utf-8?B?elBIWEVJY3VzUDIrVEdyc01MMkhRRVo1TEdFcDcvdElDalFWd2ZaSmJlVW1G?=
 =?utf-8?B?Q0VMOUppS1VGYTRRS0ZlTTEyZFdBQVpUbFNzb2gzYTc2Qy9IdlFlY1BMT3FS?=
 =?utf-8?B?RWxXVWxyWXNSZm90WW41dG5pQkkxSUt1bG9oV3VuejhLOVdNeGp6dXVoK0ZW?=
 =?utf-8?B?WkVIQ01LbEZqZ0hJU2tCYWFPM1RnUVlYbE91U1dWbEpWNFAyNnBJRTlSK1FD?=
 =?utf-8?B?eVl3TkhaYkJWc2FXNTJJOUZwcWYyWVlRMUdMZWx2ajFuSVhIVWU0dElidDY1?=
 =?utf-8?B?NjNZbGhYNFFjZGxGSEp2YTBxdXpTWXBCeEtRaU5XQnREeVEvQTJhdEZ3elY4?=
 =?utf-8?B?Sys2YkVkMFRBZ0Q1bFV3Q3pmTXh2UTFockx3THVRYytIQUFNdWFHU3Z6Y3N2?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A1E2873F98718459E776528B8C3E987@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c824238-993b-4bbb-cd6e-08de07fb7c49
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2025 12:49:43.6377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dZM7gEuNnYYOB5TMQVqIngOM+NTNXc2T2L26ju3U4pcA4+dEWYyyI8UHVx3Pd4Uhl+Vd5VtfXQN0bJXyReNrmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB8126
X-Authority-Analysis: v=2.4 cv=aom/yCZV c=1 sm=1 tr=0 ts=68e900eb cx=c_pps
 a=J7ZdHMUHR0uI/sEcOv84ig==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=S9b1782A2xA5vj2IrUsA:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-ORIG-GUID: nj9BXT0LZSjlg25pqlZDFBlBBuDcrNyv
X-Proofpoint-GUID: nj9BXT0LZSjlg25pqlZDFBlBBuDcrNyv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX47OVzwo0zBzp
 fny74FlfygRKVpK5Rif6EmeswitwrsIMhVuloQKt8PuJavUfa/kO7YOHJ/0/siKD2lsdetEm/yp
 QaFXnSWlwXcoyxbEWeivQ8Ltp4HgtpnU3DELGjwBxQ93uPjsnlzNFATLhTKgLKrgD9nq88hELlL
 FjscOQ4TcT7spaLvkitiadIBlSKdnalx4LRytTBOdXnvsoLQ8QGPMhqOMP32I5ExFs8a3bXaRvh
 E4kR2yqKWtrN8frRiMMYO7EoX/uCqcA3sH/dQnGynC929OuyLJ9Evp5p5XjQJdE9uOzXGD1EqyK
 BtGEHZ6AZZ4G2OynwFPI6J5BJGlyg4YcSRdX8w4Vm29mlcI1Lsj3TKaaYs7XhfAbHUxcX2Z+mb8
 8uaWAyX7QdACyd3TWHIEQAU8WmVTdA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121

DQoNCj4gT24gMTAgT2N0IDIwMjUsIGF0IDEzOjU5LCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPiB3cm90ZToNCj4gDQo+IEVYVEVSTkFMIE1BSUwNCj4gDQo+IA0KPiBPbiBGcmksIDEwIE9j
dCAyMDI1IDExOjU5OjQ1ICswMTAwLA0KPiBKYW4gS290YXMgPGphbmtAY2FkZW5jZS5jb20+IHdy
b3RlOg0KPj4gDQo+PiANCj4+PiBPbiAxMCBPY3QgMjAyNSwgYXQgMTI6MzEsIE1hcmMgWnluZ2ll
ciA8bWF6QGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+IEVYVEVSTkFMIE1BSUwNCj4+PiAN
Cj4+PiANCj4+PiBPbiBGcmksIDEwIE9jdCAyMDI1IDEwOjUxOjUyICswMTAwLA0KPj4+IEphbiBL
b3RhcyA8amFua0BjYWRlbmNlLmNvbT4gd3JvdGU6DQo+Pj4+IA0KPj4+PiANCj4+Pj4+IE9uIDEw
IE9jdCAyMDI1LCBhdCAxMTozNywgTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4gd3JvdGU6
DQo+Pj4+PiANCj4+Pj4+IEVYVEVSTkFMIE1BSUwNCj4+Pj4+IA0KPj4+Pj4gDQo+Pj4+PiBPbiBG
cmksIDEwIE9jdCAyMDI1IDA5OjMwOjEyICswMTAwLA0KPj4+Pj4gSmFuIEtvdGFzIDxqYW5rQGNh
ZGVuY2UuY29tPiB3cm90ZToNCj4+Pj4+PiANCj4+Pj4+PiBIZWxsbywNCj4+Pj4+PiANCj4+Pj4+
PiBEdXJpbmcgTlYgZGVidWdnaW5nIEkgbm90aWNlZCBhIGRpZmZlcmVuY2UgaW4gSENSX0VMMiB2
YWx1ZS4NCj4+Pj4+PiANCj4+Pj4+PiBUaGUgdmFsdWUgSSBnZXQgZnJvbSBhY2Nlc3NpbmcgdGhp
cyByZWdpc3RlciwgdXNpbmcgS1ZNX0dFVF9PTkVfUkVHOg0KPj4+Pj4+IDB4MzA0ODAwMDAwMDAN
Cj4+Pj4+IA0KPj4+Pj4gVGhlc2UgYml0cyBhcmUgQVBJLCBBUEssIEUySCwgUlcuDQo+Pj4+PiAN
Cj4+Pj4+IFdoZW4gZGlkIHlvdSBhY2Nlc3MgdGhpcz8gQWZ0ZXIgdGhlIHZjcHUgaGFzIHJ1bj8g
QmVmb3JlIGl0IGhhcyBydW4/DQo+Pj4+PiBXaGF0IE5WIGNvbmZpZ3VyYXRpb24gZGlkIHlvdSB1
c2U/DQo+Pj4+IA0KPj4+PiBIaSBNYXJjLA0KPj4+PiANCj4+Pj4gSSB3YW50ZWQgdG8gcmVwcm9k
dWNlIHRoZSBjb25kaXRpb25zIHdoZW4gSSBvYnNlcnZlZCBpdC4NCj4+Pj4gDQo+Pj4+IEkgcnVu
IHRoZSBndWVzdCB3aXRob3V0IHRoZSBpbXByb3ZlZCBFTDIgZGV0ZWN0aW9uLA0KPj4+PiB3aGlj
aCB3YXMgcG9zdGVkIHllc3RlcmRheSwgaW4gVkhFIG1vZGUuIA0KPj4+PiBJ4oCZbSBpbnZlc3Rp
Z2F0aW5nIHRoZSBwbGFjZSBhdCB3aGljaCBFMkggZGV0ZWN0aW9uIGhhcHBlbnMsDQo+Pj4+IGp1
c3QgYmVmb3JlIGFuIGV4Y2VwdGlvbiBvbiBaQ1JfRUwyLg0KPj4+PiANCj4+Pj4+IA0KPj4+Pj4+
IA0KPj4+Pj4+IEhvd2V2ZXIsIFgxIHZhbHVlIGFmdGVyIGV4ZWN1dGluZyBtcnMgeDEsIGhjcl9l
bDIgaW4gZ3Vlc3Q6DQo+Pj4+Pj4gMHgxMDAwMzAwODAwMDAwMDANCj4+Pj4+IA0KPj4+Pj4gWW91
IGhhdmUgQVRBLCBBUEksIEFQSywgUlcuIElzIHRoYXQgdGhlICpvbmx5KiB0aGluZyB0aGF0IGhh
cyBydW4gaW4NCj4+Pj4+IHlvdXIgZ3Vlc3Q/DQo+Pj4+IA0KPj4+PiBJIGp1c3QgYm9vdGVkIHRo
ZSBrZXJuZWwgZGlyZWN0bHkgd2l0aG91dCBFMkgwLg0KPj4+PiANCj4+Pj4+IA0KPj4+Pj4+IEkg
YWNjZXNzIGJvdGggb2YgdGhlc2UgYXQgdGhlIHNhbWUgcGxhY2UuDQo+Pj4+PiANCj4+Pj4+ICJh
dCB0aGUgc2FtZSBwbGFjZSI/IFdoYXQgZG8geW91IG1lYW4/IE9uZSBpcyBhY2Nlc3NlZCBmcm9t
IGhvc3QNCj4+Pj4+IHVzZXJzcGFjZSwgYW5kIHRoZSBvdGhlciBmcm9tIHRoZSBndWVzdC4gSG93
IGNhbiB0aGF0IGJlIHRoZSBzYW1lDQo+Pj4+PiBwbGFjZT8NCj4+Pj4gDQo+Pj4+IEJ5IHRoZSBz
YW1lIHBsYWNlIEkgbWVhbiB0aGUgc2FtZSBLVk1fRVhJVC4NCj4+Pj4gV2l0aG91dCByZXN1bWlu
ZyB2Q1BVcywgYXQgdGhlIHNhbWUgUEMuDQo+Pj4+IA0KPj4+Pj4gDQo+Pj4+Pj4gSSBnZXQgdGhl
IGxpc3Qgb2YgYXZhaWxhYmxlIHJlZ2lzdGVycyBmcm9tIEtWTV9HRVRfUkVHX0xJU1QuDQo+Pj4+
Pj4gDQo+Pj4+Pj4gSSBkb3VibGUgY2hlY2tlZCBteSBlbmNvZGluZywgYW5kIGl0IHNlZW1zIHRv
IGJlIGNvcnJlY3QuDQo+Pj4+Pj4gSENSX0VMMiAzLCA0LCAxLCAxLCAwDQo+Pj4+Pj4gDQo+Pj4+
Pj4gSSBjYW4gY2hlY2sgb3RoZXIgcmVnaXN0ZXJzLCBidXQgSSBmaXJzdCB3YW50ZWQgdG8gY2hl
Y2ssIGlmIHRoaXMgZXhwZWN0ZWQ/DQo+Pj4+Pj4gSXMgdGhlcmUgc29tZXRoaW5nIEnigJltIG1p
c3NpbmcsIHdoZW4gYWNjZXNzaW5nIGVtdWxhdGVkIHJlZ2lzdGVycz8NCj4+Pj4+IA0KPj4+Pj4g
Q291bGQgeW91IHBsZWFzZSBzdGFydCBieSBjbGFyaWZ5aW5nIHdoYXQgeW91IGFyZSBkb2luZz8N
Cj4+Pj4gDQo+Pj4+IEkgcGxhY2VkIGEgSFcgYnJlYWtwb2ludCBhdCB0aGUgTVJTIGluc3RydWN0
aW9uLg0KPj4+PiBJIGRpZCBhIHNpbmdsZSBzdGVwLCBhbmQgdGhlbiBJIGNoZWNrZWQgWDEgYW5k
IEhDUl9FTDIgdmFsdWVzLg0KPj4+PiBCeSBjYWxsaW5nIEdFVF9PTkVfUkVHIG9uIGJvdGgsIEkg
c2VlIGRpZmZlcmVudCB2YWx1ZXMuDQo+Pj4gDQo+Pj4gSSdtIHZlcnkgc3VycHJpc2VkIHRoYXQg
ZGVidWcgYWN0dWFsbHkgd29ya3MsIGJ1dCBoZXksIG1heWJlIEkgc2hvdWxkDQo+Pj4gYWRtaXQg
dGhhdCBtaXJhY2xlcyBjYW4gaGFwcGVuLi4uIDstKQ0KPj4gDQo+PiBHcmVhdCwgSSBnYXZlIHNv
bWUgcG9zaXRpdmUgZmVlZGJhY2sgZm9yIG9uY2UuIDopDQo+IA0KPiBIZXksIHRoZXJlJ3Mgbm8g
YmFkIGZlZWRiYWNrLCBhbmQgeW91ciBjb250cmlidXRpb24gaXMgZ3JlYXRseQ0KPiBhcHByZWNp
YXRlZC4NCj4gDQo+PiANCj4+PiBUaGUgZ3Vlc3QgY2FuIHdyaXRlIHdoYXRldmVyIGl0IHdhbnRz
IHRvIHRoZSBIQ1JfRUwyIHJlZ2lzdGVyLiBUaGF0J3MNCj4+PiBqdXN0IGEgNjRiaXQgY2h1bmsg
b2YgbWVtb3J5LCBhbmQgaWYgaXQgd2FudHMgdG8gd3JpdGUgUGkgdG8gaXQsIGl0DQo+Pj4gY2Fu
LiBOb3RoaW5nIHRoZSBndWVzdCB3cml0ZXMgdGhlcmUgd2lsbCBoYXZlIGFueSBlZmZlY3QgYXMg
bG9uZyBhcyBpdA0KPj4+IGRvZXNuJ3QgRVJFVCB0byBFTDEgYW55d2F5Lg0KPj4+IA0KPj4+IFdo
YXQgR0VUX09ORV9SRUcgcmV0dXJucyBpcyB0aGUgKnNhbml0aXNlZCogdmlldyBvZiB0aGF0IHJl
Z2lzdGVyLA0KPj4+IGFmdGVyIGhhdmluZyBhcHBsaWVkIFJFUzAgYW5kIFJFUzEgbWFza3MsIGFz
IHdlbGwgYXMgdGhlIGNvbnN0cmFpbnRzDQo+Pj4gdGhhdCBhcmUgc3BlY2lmaWMgdG8geW91ciBl
eGFjdCBjb25maWd1cmF0aW9uLg0KPj4+IA0KPj4+IFNpbmNlIHlvdSBhcmUgcnVubmluZyB3aXRo
b3V0IHRoZSBwYXRjaCB0aGF0IG1ha2VzIHRoZSB0d28gdmlld3MNCj4+PiBjb25zaXN0ZW50LCB5
b3VyIGtlcm5lbCBpcyBwcm9iYWJseSB0YWtpbmcgdGhlIHdyb25nIHBhdGgsIGFuZA0KPj4+IGNv
bmZpZ3VyaW5nIGJpdHMgdGhhdCBoYXZlIG5vIG1lYW5pbmcgaW4gdGhhdCBjb25maWd1cmF0aW9u
IGFuZA0KPj4+IHJlc3VsdGluZyBpbiwgYW1vbmdzdCBvdGhlciB0aGluZ3MsIEUySCBhcHBlYXJp
bmcgdG8gYmUgMCB3aGlsZQ0KPj4+IEdFVF9PTkVfUkVHIGNsZWFybHkgdGVsbHMgeW91IGl0IGlz
IDEuDQo+PiANCj4+IEkgZ290IGEgZmVlbGluZyBpdCB3aWxsIGJlIHNvbWV0aGluZyBsaWtlIHRo
aXMuDQo+PiANCj4+IE1heWJlIGl0IHdvdWxkIGJlIHVzZWZ1bCB0byBoYXZlIGEgY2FwYWJpbGl0
eS9mbGFnDQo+PiBmb3IgR0VUX09ORV9SRUcgdG8gZ2V0IG5vbi1zYW5pdGl6ZWQgdmFsdWVzPw0K
PiANCj4gR0VUX09ORV9SRUcgaXMgdGhlIHNhdmUvcmVzdG9yZSBpbnRlcmZhY2UuIEl0IGlzIHRo
ZXJlIHRvIHByZXNlbnQNCj4gYXJjaGl0ZWN0dXJhbGx5IGNvcnJlY3QgaW5mb3JtYXRpb24gdGhh
dCBjYW4gYmUgcmVzdG9yZWQgdG8gYW5vdGhlcg0KPiBtYWNoaW5lLiBIYXZpbmcgbm9uLXNhbml0
aXNlZCBpbmZvcm1hdGlvbiB3b3VsZCBwb3RlbnRpYWxseSBwcmV2ZW50DQo+IHRoYXQuDQo+IA0K
Pj4gT3IgYSB3YXkgZm9yIGEgVk1NIHRvIGFjY2VzcyB0aGUgcmF3IE5WMiBtZW1vcnk/DQo+IA0K
PiBUaGUgd2hvbGUgcG9pbnQgb2YgdGhpcyBzYW5pdGlzYXRpb24gaXMgdGhhdCB0aGVyZSBzaG91
bGQgYmUgbm8gd2F5IHRvDQo+IG9idGFpbiBiYWQgZGF0YSBmcm9tIHdpdGhpbiBLVk0sIGV2ZW4g
aWYgdGhlIGd1ZXN0IG1lc3NlcyB0aGluZ3MgdXAuDQo+IEFsc28sIHNlZSBiZWxvdy4NCj4gDQo+
PiBJ4oCZbSBqdXN0IHdvbmRlcmluZywgaWYgR3Vlc3QgZG9lcyBzb21ldGhpbmcgdW5leHBlY3Rl
ZCwNCj4+IGRlYnVnZ2luZyBpdCwgbWF5IGJlIGhhcmRlciwgaWYgYSB1c2VyIHNlZXMgZGlmZmVy
ZW50IHN0dWZmIHRoYW4gU1cuDQo+IA0KPiBUaGlzIHNvcnQgb2YgcHJvYmxlbXMgZXhpc3RzIG9u
IHJlYWwgSFcgYWxyZWFkeS4gSWYgYSBiaXQgaXMgUkVTMSBpbg0KPiB0aGUgYXJjaGl0ZWN0dXJl
LCBpdCBkb2Vzbid0IG1lYW4gdGhhdCB0aGlzIGJpdCBpcyBhbHdheXMgMS4gSXQgbWVhbnMNCj4g
aXQgaXMgaW50ZXJwcmV0ZWQgYXMgMSBieSB0aGUgSFcsIGJ1dCB0aGUgYml0IGNvdWxkIGJlIHNl
dCB0byBhbnkNCj4gdmFsdWUgYW5kIHJlYWQgYXMgc3VjaC4NCj4gDQo+IEFuZCB0aGF0J3MgZXhh
Y3RseSB3aGF0IHdlIGhhdmUgaGVyZS4gU1cgd3JpdGVzIDAgdG8gRTJILCBhbmQgdGhhdCdzDQo+
IHdoYXQgeW91IHJlYWQgZnJvbSB0aGUgcmVnaXN0ZXIgaW4gdGhlIGNvbnRleHQgb2YgdGhlIGd1
ZXN0IGl0c2VsZi4NCj4gQnV0IEdFVF9PTkVfUkVHIHNob3dzIHlvdSBob3cgdGhlICJIVyIgaW50
ZXJwcmV0cyB0aGlzIGJpdCwgYW5kIHRoYXQNCj4gaXMgd2hlcmUgaGF2aW5nIHRoZSB0d28gdmll
d3MgaXMgYWN0dWFsbHkgdmFsdWFibGU6IGRpZmZlcmVudCB2YWx1ZXMNCj4gYXJlIGxpa2VseSB0
byByZXN1bHQgaW4gZGlmZmVyZW50IGJlaGF2aW91cnMuIEtWTSBnaXZlcyB5b3UgdGhlIHRvb2wN
Cj4gdG8gc2VlIHdoYXQgYm90aCB0aGUgZ3Vlc3QgcHJvZ3JhbXMgKGRlYnVnIG9yIGFjY2VzcyB0
byB0aGUgR1BSIHVzaW5nDQo+IEdFVF9PTkVfUkVHKSwgYW5kIGhvdyBLVk0gaW50ZXJwcmV0IHRo
ZSBwcm9ncmFtbWVkIHZhbHVlIChhY2Nlc3MgdG8NCj4gSENSX0VMMiB1c2luZyBHRVRfT05FX1JF
RykuDQo+IA0KPiBHaXZlbiB0aGF0LCBteSB0YWtlIGlzIHRoYXQgd2hhdCB3ZSBoYXZlIHRvZGF5
IGlzIG5vdCBvbmx5IGNvcnJlY3QsDQo+IGJ1dCBhY3R1YWxseSB0aGUgZGVzaXJhYmxlIGJlaGF2
aW91ci4NCg0KRnJvbSB0aGlzIHBvaW50IG9mIHZpZXcsIEkgYWdyZWUgYXMgd2VsbC4NCg0KQW5k
IGFzIHlvdSBzYWlkLCBpdCBhbGxvd3MgdXMgdG8gY29tcGFyZSB3aGF0IHRoZSBIVyBhY3R1YWxs
eSBkb2VzLA0KYW5kIHdoYXQgdGhlIEd1ZXN0IG1heSB0cnkgdG8gZG8uIEl0IGNvdWxkIGJlIGEg
bmVhdCBkZWJ1ZyBmZWF0dXJlLg0KTWF5YmUgaXQgd291bGQgYmUgd29ydGggYWRkaW5nIGEgbm90
ZSBhYm91dCBzYW5pdGl6YXRpb24gdG8ga2VybmVsIGRvY3M/DQoNClRoYW5rcyBmb3IgdGFraW5n
IHRoZSB0aW1lIHRvIHJlc3BvbmQuDQpJdCBhbHNvIGhlbHBlZCBtZSB0byBydWxlIG91dCBidWdz
IGluIG91ciBWTU0gaW1wbGVtZW50YXRpb24uDQoNClJlZ2FyZHMsDQpKYW4NCg0KPiBUaGFua3Ms
DQo+IA0KPiBNLg0KPiANCj4gLS0gDQo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0s
IHByb2dyZXNzIGlzIG5vdCBwb3NzaWJsZS4NCg0KDQo=
