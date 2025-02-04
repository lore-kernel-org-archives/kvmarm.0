Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798671DFEF
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738678677; cv=fail; b=BCLYEUeDRv+EEcuhOtNp8ms3T432ZuBKQUsGT45jolDFIeBwDoL3cnLFyDacpLbLc5rLu8hbLUmQxraUaKr56M8UUz8gf3g4zUIJQapwYWeUaPldjfGHmsPhsv4CLYsscNbhSi/lGt5ZcA5zO2PVONvOF0df4QK1DS5IFKu+oLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738678677; c=relaxed/simple;
	bh=3d9BALQYeEfn5IaspoKLDkB/EelriABRXcLJ17z1kQ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XVie0ke63bPEdAJMxV9JpqatJDd6dOtVnuI+B155oi2Z231Bgc26PtAY35BR38q2Insvtwzi+cqb52UL8yUIEKcKUIqOzzf7wzu5MRLqLCfm0lngQidWWK8xH5WhyZ9h1pQXZqYxzr6pquz1iQzk6NwugH9KR2XONOPvSK2jwDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=TdGlsIco; arc=fail smtp.client-ip=40.107.20.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="TdGlsIco"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPFbtGvdqy3zTFHVpxEZU+4OjAg/8c+l14b/QGyhEvsTRsY6UY3pP35wCiFtzgcr1sPYPyNbFOV0r6wMKO4S28REmPQboPf5nYpto8jibWjqnQ1rnMjWhOISsjDQ0vTRjm+wXtySd5Hdo7Zug+4eHktu9++LgbTM9Iym7PrpZmm5YRVSgIRuYxf8II+yaHnQfoDwRDyrJ43fWLNQaM/J/ygGKJZv1u1g4nFbKxOq34v0exPdi66mHHRpjwVI1Jfm6XZ1mS9WNSKfXQA0QXwkQkfw41xFw2csl9vqoeIBrtgKcKbv3y0hw6LfQVX/JtwhSwh5C20/JCzqmzh6PAAslg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3d9BALQYeEfn5IaspoKLDkB/EelriABRXcLJ17z1kQ4=;
 b=EZudkp7rK7nJagonb/QGJpyVozW86XcjomOJMc6mSZ0YbQnHs9IpR1BeW/mctLEiJBDnsrR2q1HfvVfKzwKMsF+agSoaO45zv/CwQvv+cuMG2DhJ9OmD5TfTD7o0O3Q3+OcL6bQcv949uarFQ+LC7qTbXGFjbWZSRpFzXzaife6OgABsPKCQFVH2WNleSFloAkmVZ4sM27H7UP5ASbN4Ust2G6jyGkyAiW88C0SKNyi/NmL91E1PiFC9gTcjb8nc/viMzzclij2IHiGGuA9JKjcim4OtucS/FpPsuVJc1RSdOvbnzhp1Rn0NrWtmRnivFhkVeZMO2CfDGYuIeH+6Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3d9BALQYeEfn5IaspoKLDkB/EelriABRXcLJ17z1kQ4=;
 b=TdGlsIcoQPvc1x7i2rgTHslESAJg/1MNf83Q0UdvE0cdjcuoGlufsZJ5+PyD4oy9QfHCV+BVS1F5LhtGcCO5gSOLEpo8Dy/OzohlFhPg53XrDNfgm4gL+YfP8/IDsAMbnkzPCypUc2S38/eBbI9cVyQiBlR9YhHTwbXMvsjfQ+RAeJ8NMAQ7QZFeadfND42HEWYxS68CorYWa+Gi/UyqrqTxMqS1IGzdxBj8ud3ae+x5MHtLNgRiZiyQhyiowAdir7qCETghtWHRzdwXadlNPiKcVBHnRkOj6pWrv29dZ7H5eeQMWcved1pxaGt83GEREsJ0otIVjjAZsrTtGO8B5g==
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com (2603:10a6:20b:5a2::12)
 by DB9PR03MB7676.eurprd03.prod.outlook.com (2603:10a6:10:2c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Tue, 4 Feb
 2025 14:17:52 +0000
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803]) by AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 14:17:52 +0000
From: Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>
To: Marc Zyngier <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Volodymyr Babchuk
	<Volodymyr_Babchuk@epam.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: timer: Correctly handle EL1 timer
 emulation when !FEAT_ECV
Thread-Topic: [PATCH v2 2/3] KVM: arm64: timer: Correctly handle EL1 timer
 emulation when !FEAT_ECV
Thread-Index: AQHbdvQSgsfFSKxblUOgjC98tgG6LrM3MT2A
Date: Tue, 4 Feb 2025 14:17:52 +0000
Message-ID: <581a9200-236a-4460-8aa4-030d8e239c03@epam.com>
References: <20250204110050.150560-1-maz@kernel.org>
 <20250204110050.150560-3-maz@kernel.org>
In-Reply-To: <20250204110050.150560-3-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR03MB9438:EE_|DB9PR03MB7676:EE_
x-ms-office365-filtering-correlation-id: 077b8125-39de-4b4f-da34-08dd4526b648
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ci96amk2c2pJUnFXazZ3Y1RDakJyOTVPUWZlVUJta01CTFdtaHgrMWNxWncw?=
 =?utf-8?B?NWNQY1dzV2o1aDQwS3lSRkMxbC9TWkZ4Y1NrTTkwRnEvWlcyd0FrNGlDMUpX?=
 =?utf-8?B?NTNXNGx2UkdyYzZnZEhsN21EeEJGN1RhWHQ4Wnh3QVpkZmFsbDhpS0d5cVQ0?=
 =?utf-8?B?UjV6MGVtQ1VXY0J1aHpQbWNRanBsc2xvT2lLRnVTb1dramRJVlJXeklqdE1m?=
 =?utf-8?B?V1dHRW1UbHQxcUg5blA2K043L3UzNy9taHdZSVhMMDFIaExRaUNCdFJseXNv?=
 =?utf-8?B?NGNpbmhmeHN5VmdJWUZPWXlVQUpmYkVQYkV3Q0Foc0pKc0haN2thd0p4VzQw?=
 =?utf-8?B?akpYYXRKQ1VKa1FMWTg3bC9Ic2x0czY1STZxRGFZbEtrVS9QNDVpY2MvSnYx?=
 =?utf-8?B?ZHh5U2c3dWQyQmw4UTBvN2JaTEhWRkFDdmg3Qit5M3JiN01LLytHbjJFTXhi?=
 =?utf-8?B?SHBaVTMzUHFvMitoaEpFbHFaSHBpOGwzSlROTWVGV1RMblIzRGp0elRlREIy?=
 =?utf-8?B?WXNEMDdmVGlNSjhtbmw5dDRpaFBwK0Yvc0FJMnJWbmdWYmVNN3RvbjYyem1o?=
 =?utf-8?B?V3ZrOTdMRktIa0txdnJ0S0xQVXFVaUY0MWVwNklDNHVJNW5QK0h2RkVjcUJI?=
 =?utf-8?B?eWRNbXVmYWJzT3hGT1MzVE5PVVp1SVF4K1FuTENyU21lVEd5Nk1TNnc5aktl?=
 =?utf-8?B?T25qVCt0cVhsSElNS3FmbjdSMjBOMDdOVU1yY1VXS3VtaWNsak0waFBtdTF4?=
 =?utf-8?B?WjBQcEhzWVQrenZZNHBuQTZaWHNtYnhpRXZJeTNsZ0dGck5TVjVDUGNzYXRu?=
 =?utf-8?B?RVAzaTIvdUhoeFdMenI5QVhleThDSHUxWTgremJld2NGSU0wMWk2Y1lrU0Qz?=
 =?utf-8?B?RDgyVERTR0RNdjhiNjZUMTl2bTlRdUh6cFpubWtibncyQ3ZudTlZV2pNWkx3?=
 =?utf-8?B?Q3U3clUwbklNTTF5NW11UnVFNzVubzBsby9OZGVab0tnNHoxcW1IeWdoNGJ2?=
 =?utf-8?B?TEMwL1IzUGFqNWtwRy9nV3dzVXNlNG5YeWhkQXd3ZzNad3BCZytOeFkrZ1ln?=
 =?utf-8?B?bjc1eW9TbWFzS3dxVzFyNkJNaTdwODBHK1BmWTZOQ0hhcDQwWk5oajRKb2pW?=
 =?utf-8?B?bVFXdU8rdnBhcHhCQ2ZNU3hJQ00wcmhycGtPNG01aVV4UE52RFVTTi8yU0gx?=
 =?utf-8?B?MnZpTlQ0NXdpcGlZb1FqMVF5OXl4aDB5ZzB1Z21yQW4zYmFMbWlMMlRTWXgw?=
 =?utf-8?B?bVRTSGNBMlFkZzlzZHRUbGhaYkttZ21OWFZ1OGZTTUEvMExYcUpFRWdSOHFq?=
 =?utf-8?B?MzI3dzdsSk1PM1IvMXJkTHdGZjhmem9vMk9wTjJHQmZjb1pFYjZjeDdWdUZn?=
 =?utf-8?B?ODd2VEE2ZThKTDFja282azN3ZHZKVFdkVjNiSVhEV3BzaFVSWjEvYzBMRGVk?=
 =?utf-8?B?a0lWM0FocWg3S0dJeUlyM3M3NFFzTVAxVFJLM2g5a0NCdTBESk85UVB4NXdC?=
 =?utf-8?B?UU9INTBDMnc0a0o0d1FzUk9oQXJDWWVzRWxQZ083YTFRaEUrbXU0RmlJcm1B?=
 =?utf-8?B?S0NQNXpZeTRrR3NkNTY4RHVJeGNJUFdRemU2YVNkQ0c0SnVKZ1ZOU2k4bEZw?=
 =?utf-8?B?TlBDVWdBSzFZZFNKNlpuTVIwQ1JobW1ZWWE1elRNdlhreWxEY2ZySDlqdkVh?=
 =?utf-8?B?cUZmZTZlOStNRjZPd29leU5vaW9MM284WFN1ZTVsZEhUajZtZCt3UFVvV25C?=
 =?utf-8?B?aHR5QURXcDFwVnRiR0tGR3R5VEtqN3BMWVJvY2xKTDk0Mk1sTjZ3UndsamhF?=
 =?utf-8?B?S3EzWHJyc2F2MUlSZWtzSzRwUXFkUWo1dWJrQ2tDRlpGTE9iRFdNelU2TG1U?=
 =?utf-8?B?QTVTa2xSdVBaTUxjUG5yNWh1TThqY2VTL1hQNlh5N21MVVE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB9438.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RkNJdjIxS1RndmNxK1d6aS9ka1BFbElsSG15R1pyTUVjcFZCZVhoZlRQVzVB?=
 =?utf-8?B?VWJFYjdFbnhoNmVXRkE4eG5wcDJCYlZ6N3NWT3ZmenhKTml2VVNnVDlNQlYr?=
 =?utf-8?B?eGxVMFRXSUkwb2lEdEYyVXcrY2tOQ29hSTZDZmIxUTRqVGppS0xDbHU3Z3k5?=
 =?utf-8?B?bGRWdGhSOEUzTk9uK0NFYjRLbkMxYnpyK053Y3VWYWt5bW5UZmprV0lSOUVI?=
 =?utf-8?B?M1JXV3ExTTk3UEFhU1UzczFDc1ZFZzZkV2tXd1BHZnFYdHd5ZDBsaHlESEd0?=
 =?utf-8?B?Ryt4YndZL1JVT0E3T2J2Ylk2cUdhVWN6TVFkU0VMUjA1SjN6eXdka1I1bkh0?=
 =?utf-8?B?Q2h4VktDdDVVbW9CTTVqaWxTMWVHaHM3ajZMekZUTVlzcW5EMVlxTU1WYU1Z?=
 =?utf-8?B?cWZqVVRRb2drQ3gwQWxpV3JSajNFTmVyTFM4M3hqMlJ4djdIaFNldG1DYy8y?=
 =?utf-8?B?WGt2ajVnK1BhckJJR1AzMWI1TFBrLzhTSlhTNVRPTXlZQTNhMUhzOGo3V0lq?=
 =?utf-8?B?UlVlamR4SkZveEtPT01NT2JrWW00WFFqY1gvUzVxeDNGdTZicStmVGtaeFZW?=
 =?utf-8?B?WTVhWUNJSTh3MzNnMFBLaGE3NjJpWWhORG1YQkd0cDJYYzkzVkowT0VoRzBK?=
 =?utf-8?B?TE9Vdk54MVhFSWRDcGQxc2JlTDdpeTNWUVlHdTV5VHc2NnZWRUFzU3U1R243?=
 =?utf-8?B?cloybHdJbG9EelpZTyt3bFBqNmFadnNYeXNmNXJBVFJXZTJFTHh0ZVhKQ0tH?=
 =?utf-8?B?eHRXbDRhckNWcGdqT0ZWaTlXTW5DbTRnMzVBWEh0ZGtzWWpCK3JNYm5jSWR2?=
 =?utf-8?B?MFJITERCMis0UU9JWjVhcjUwR1VmcUF5NEgxSlFaVjYzLzlDa0tHZ2JQaVBD?=
 =?utf-8?B?eTJEYkpiOHFxZEhyRnNPdmF3c1JPaHJkSWtEN29tbHZ5cWMvYW80M2lVeDkz?=
 =?utf-8?B?WUhEcXA5NE45NVhiQlpGcnU1a1AycENZbXFIZFA0TkhVVktvTU9JRHFXZkhs?=
 =?utf-8?B?T2g4Q00zQ09YM0tXV3JsWXY0UGtBajBZd1pNMlB0RHpzWnNpRFl4Q2s5eE1h?=
 =?utf-8?B?NExvSCs4cTlWWnRvL1ZTcURrUlVyK3lYMm5uaG1uTTR4QVpOM1FBQnR5VmMx?=
 =?utf-8?B?ZXlEOHRUaWJyaEdtTkNwMFJZbUUrQ0ovVEVOZDJteXFJd3NxMmplbWxFMGZo?=
 =?utf-8?B?TmNZNFhjWldlUi95N05tL0RxYjBjTXNGK2hzMGk2N28vTzlERHFhaEFOQjZR?=
 =?utf-8?B?Mm40Q1ZEdTN6NUMwMGNBck56QlN3RnY4WmdiRUJSQnl0d2d1L0VHaHZ6YjFQ?=
 =?utf-8?B?RFZoM2pyUXYyTHRCZysxbFV1TURrQmpla2pRT2FIbFVHTnQrdzlmM0hNYTRs?=
 =?utf-8?B?aXliaG9pakhiT2F2YWFPa0tnWXpkQXZkY1UzbVc3bU43QURpR3RZOFlQNjdj?=
 =?utf-8?B?bDA5V1JsNWtpVk5XVHZGSnlBVHFiSzZoejl3UWhTV2RtTmtWSnlpcEVHZnFl?=
 =?utf-8?B?dHlzbC9NSDBVUW4wY0xUS2NxcVhmc2djT0N0VlVRK1VVTnhVU3Y5WjBZRXpU?=
 =?utf-8?B?RDZRU0t6UEgxaEhLM2RCN2JFOFllYnZWeS9GTG5abHY0dU1CMC9SUVFzK3gz?=
 =?utf-8?B?VGNRVUVlVnpUcHFlb0dzemRDc2J1dEw5MWxBMFdCU2tLTVZtU05RUjR2d2dO?=
 =?utf-8?B?NS9GZzNQM1NURVNUdUxYbjRjZ1djbTRlaWtYVEwzV29qWGtXQitCQlBCSkJX?=
 =?utf-8?B?dWlBN05RMGV4OTlNeFU1RVRtVDdyeFlRUHFzT2hFWTVSamlycWxVNXRvbGZQ?=
 =?utf-8?B?S0UvcU1oL3ovNVJvNlowZTFYUG1ja3F3dkZSZkoxR1ZUaHp0MGxjV1JrOFpu?=
 =?utf-8?B?ZUpzQ1VFQ3V2M2RwR09jMlJnWGlCSm90cHFoejFTbTQvaTA4RjdWbkdUOC93?=
 =?utf-8?B?SExHZ09IckcrUnVJTHlEd25Ra0J2WjUvOFhPK2dqejNtRkczRHN4SHZ0cnYz?=
 =?utf-8?B?cHRjcWxCeXFPQk5XRXYwVWhkaXdzbVJrMndHUUdXV2paSmpLVE5la3czcXlL?=
 =?utf-8?B?c0c2RnVUb0haMGhWMzB5TFRTQnRxLzd4TjJCMi85c1h1WlFJWktmenkySTI5?=
 =?utf-8?B?ZzFqbis1SVlaOXp3bmx2UU9vVDdjVk1jMEE3TjFkdkdQSXNlRGUvU0gvVFVx?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <862CD6DBD7E775469F03A58C251F0D54@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB9438.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077b8125-39de-4b4f-da34-08dd4526b648
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2025 14:17:52.5268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPXULCHYGMvG/86T80TbU+dFjcpbfgeTxhCdkznxGvsixkd8uXWslxuLG8O067hsUDuBrv5A2WWJT57TWjKtfnMqfwX3i8iM53XqjFxNXgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7676

SGVsbG8sIE1hcmMuDQoNCk9uIDIvNC8yNSAxMzowMCwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPiBC
b3RoIFdlaS1MaW4gQ2hhbmcgYW5kIFZvbG9keW15ciBCYWJjaHVrIHJlcG9ydCB0aGF0IHRoZSB3
YXkgd2UNCj4gaGFuZGxlIHRoZSBlbXVsYXRpb24gb2YgRUwxIHRpbWVycyB3aXRoIE5WIGlzIGNv
bXBsZXRlbHkgd3JvbmcsDQo+IHNwZWNpYWxseSBpbiB0aGUgY2FzZSBvZiBIQ1JfRUwyLkUySD09
MC4NCj4NCj4gVGhlcmUgYXJlIHRocmVlIHByb2JsZW1zIGluIGFib3V0IGFzIG1hbnkgbGluZXMg
b2YgY29kZToNCj4NCj4gLSBXaXRoIEUySD09MCwgdGhlIEVMMSB0aW1lcnMgYXJlIG92ZXJ3cml0
dGVuIHdpdGggdGhlIEVMMSBzdGF0ZSwNCj4gICAgd2hpbGUgdGhleSBzaG91bGQgYWN0dWFsbHkg
Y29udGFpbiB0aGUgRUwyIHN0YXRlIChhcyBwZXIgdGhlIHRpbWVyDQo+ICAgIG1hcCkNCj4NCj4g
LSBXaXRoIEUySD09MSwgd2UgcnVuIHRoZSBmdWxsIEVMMSB0aW1lciBlbXVsYXRpb24gZXZlbiB3
aGVuIEVDVg0KPiAgICBpcyBwcmVzZW50LCBoaWRpbmcgYSBidWcgaW4gdGltZXJfZW11bGF0ZSgp
IChzZWUgcHJldmlvdXMgcGF0Y2gpDQo+DQo+IC0gVGhlIGNvbW1lbnRzIGFyZSBhY3RpdmVseSBt
aXNsZWFkaW5nLCBhbmQgc2F5IGFsbCB0aGUgd3JvbmcgdGhpbmdzLg0KPg0KPiBUaGlzIGlzIG9u
bHkgYXR0cmlidXRhYmxlIHRvIHRoZSBjb2RlIGhhdmluZyBiZWVuIGluaXRpYWxseSB3cml0dGVu
DQo+IGZvciBGRUFUX05WLCBoYWNrZWQgdXAgdG8gaGFuZGxlIEZFQVRfTlYyICppbiBwYXJhbGxl
bCosIGFuZCB2YWd1ZWx5DQo+IGhhY2tlZCBhZ2FpbiB0byBiZSBGRUFUX05WMiBvbmx5LiBPaCwg
YW5kIHlvdXJzIHRydWx5IGJlaW5nIGEgZ29sZA0KPiBwbGF0ZWQgaWRpb3QuDQo+DQo+IFRoZSBm
aXggaXMgb2J2aW91czoganVzdCBkZWxldGUgbW9zdCBvZiB0aGUgRTJIPT0wIGNvZGUsIGhhdmUg
YSB1bmlmaWVkDQo+IGhhbmRsaW5nIG9mIHRoZSB0aW1lcnMgKGJlY2F1c2UgdGhleSByZWFsbHkg
YXJlIEUySCBhZ25vc3RpYyksIGFuZA0KPiBtYWtlIHN1cmUgd2UgZG9uJ3QgZXhlY3V0ZSBhbnkg
b2YgdGhhdCB3aGVuIEZFQVRfRUNWIGlzIHByZXNlbnQuDQo+DQo+IEZpeGVzOiA0YmFkMzA2OGNm
YTlmICgiS1ZNOiBhcm02NDogbnY6IFN5bmMgbmVzdGVkIHRpbWVyIHN0YXRlIHdpdGggRkVBVF9O
VjIiKQ0KPiBSZXBvcnRlZC1ieTogV2VpLUxpbiBDaGFuZyA8cjA5OTIyMTE3QGNzaWUubnR1LmVk
dS50dz4NCj4gUmVwb3J0ZWQtYnk6IFZvbG9keW15ciBCYWJjaHVrIDxWb2xvZHlteXJfQmFiY2h1
a0BlcGFtLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9y
Zz4NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci9mcWlxZmp6d3BnYnpkdG91dTJw
d3FsdTdsbGhuZjVsbXk0aHp2NXZvNnBoNHYzdnlsc0BqZGNmeTNmampjNWsNCj4gTGluazogaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci84N2ZybDUxdHNlLmZzZkBlcGFtLmNvbQ0KDQoNClRlc3Rl
ZC1ieTogRG15dHJvIFRlcmxldHNreWkgPGRteXRyb190ZXJsZXRza3lpQGVwYW0uY29tPg0KDQoN
Cj4gLS0tDQo+ICAgYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jIHwgMzAgKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyks
IDIwIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vYXJjaF90
aW1lci5jIGIvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+IGluZGV4IDAzNWU0M2Y1ZDRm
OWEuLmU1OTgzNmUwMjYwY2YgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGlt
ZXIuYw0KPiArKysgYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gQEAgLTk3NCwzMSAr
OTc0LDIxIEBAIHZvaWQga3ZtX3RpbWVyX3N5bmNfbmVzdGVkKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkNCj4gICAJICogd2hpY2ggYWxsb3dzIHRyYXBwaW5nIG9mIHRoZSB0aW1lciByZWdpc3RlcnMg
ZXZlbiB3aXRoIE5WMi4NCj4gICAJICogU3RpbGwsIHRoaXMgaXMgc3RpbGwgd29yc2UgdGhhbiBG
RUFUX05WIG9uIGl0cyBvd24uIE1laC4NCj4gICAJICovDQo+IC0JaWYgKCF2Y3B1X2VsMl9lMmhf
aXNfc2V0KHZjcHUpKSB7DQo+IC0JCWlmIChjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0X0hBU19F
Q1YpKQ0KPiAtCQkJcmV0dXJuOw0KPiAtDQo+IC0JCS8qDQo+IC0JCSAqIEEgbm9uLVZIRSBndWVz
dCBoeXBlcnZpc29yIGRvZXNuJ3QgaGF2ZSBhbnkgZGlyZWN0IGFjY2Vzcw0KPiAtCQkgKiB0byBp
dHMgdGltZXJzOiB0aGUgRUwyIHJlZ2lzdGVycyB0cmFwIChhbmQgdGhlIEhXIGlzDQo+IC0JCSAq
IGZ1bGx5IGVtdWxhdGVkKSwgd2hpbGUgdGhlIEVMMCByZWdpc3RlcnMgYWNjZXNzIG1lbW9yeQ0K
PiAtCQkgKiBkZXNwaXRlIHRoZSBhY2Nlc3MgYmVpbmcgbm90aW9uYWxseSBkaXJlY3QuIEJvby4N
Cj4gLQkJICoNCj4gLQkJICogV2UgdXBkYXRlIHRoZSBoYXJkd2FyZSB0aW1lciByZWdpc3RlcnMg
d2l0aCB0aGUNCj4gLQkJICogbGF0ZXN0IHZhbHVlIHdyaXR0ZW4gYnkgdGhlIGd1ZXN0IHRvIHRo
ZSBWTkNSIHBhZ2UNCj4gLQkJICogYW5kIGxldCB0aGUgaGFyZHdhcmUgdGFrZSBjYXJlIG9mIHRo
ZSByZXN0Lg0KPiAtCQkgKi8NCj4gLQkJd3JpdGVfc3lzcmVnX2VsMChfX3ZjcHVfc3lzX3JlZyh2
Y3B1LCBDTlRWX0NUTF9FTDApLCAgU1lTX0NOVFZfQ1RMKTsNCj4gLQkJd3JpdGVfc3lzcmVnX2Vs
MChfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBDTlRWX0NWQUxfRUwwKSwgU1lTX0NOVFZfQ1ZBTCk7DQo+
IC0JCXdyaXRlX3N5c3JlZ19lbDAoX192Y3B1X3N5c19yZWcodmNwdSwgQ05UUF9DVExfRUwwKSwg
IFNZU19DTlRQX0NUTCk7DQo+IC0JCXdyaXRlX3N5c3JlZ19lbDAoX192Y3B1X3N5c19yZWcodmNw
dSwgQ05UUF9DVkFMX0VMMCksIFNZU19DTlRQX0NWQUwpOw0KPiAtCX0gZWxzZSB7DQo+ICsJaWYg
KCFjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0X0hBU19FQ1YpKSB7DQo+ICAgCQkvKg0KPiAgIAkJ
ICogRm9yIGEgVkhFIGd1ZXN0IGh5cGVydmlzb3IsIHRoZSBFTDIgc3RhdGUgaXMgZGlyZWN0bHkN
Cj4gLQkJICogc3RvcmVkIGluIHRoZSBob3N0IEVMMSB0aW1lcnMsIHdoaWxlIHRoZSBlbXVsYXRl
ZCBFTDANCj4gKwkJICogc3RvcmVkIGluIHRoZSBob3N0IEVMMSB0aW1lcnMsIHdoaWxlIHRoZSBl
bXVsYXRlZCBFTDENCj4gICAJCSAqIHN0YXRlIGlzIHN0b3JlZCBpbiB0aGUgVk5DUiBwYWdlLiBU
aGUgbGF0dGVyIGNvdWxkIGhhdmUNCj4gICAJCSAqIGJlZW4gdXBkYXRlZCBiZWhpbmQgb3VyIGJh
Y2ssIGFuZCB3ZSBtdXN0IHJlc2V0IHRoZQ0KPiAgIAkJICogZW11bGF0aW9uIG9mIHRoZSB0aW1l
cnMuDQo+ICsJCSAqDQo+ICsJCSAqIEEgbm9uLVZIRSBndWVzdCBoeXBlcnZpc29yIGRvZXNuJ3Qg
aGF2ZSBhbnkgZGlyZWN0IGFjY2Vzcw0KPiArCQkgKiB0byBpdHMgdGltZXJzOiB0aGUgRUwyIHJl
Z2lzdGVycyB0cmFwIGRlc3BpdGUgYmVpbmcNCj4gKwkJICogbm90aW9uYWxseSBkaXJlY3QgKHdl
IHVzZSB0aGUgRUwxIEhXLCBhcyBmb3IgVkhFKSwgd2hpbGUNCj4gKwkJICogdGhlIEVMMSByZWdp
c3RlcnMgYWNjZXNzIG1lbW9yeS4NCj4gKwkJICoNCj4gKwkJICogSW4gYm90aCBjYXNlcywgcHJv
Y2VzcyB0aGUgZW11bGF0ZWQgdGltZXJzIG9uIGVhY2ggZ3Vlc3QNCj4gKwkJICogZXhpdC4gQm9v
Lg0KPiAgIAkJICovDQo+ICAgCQlzdHJ1Y3QgdGltZXJfbWFwIG1hcDsNCj4gICAJCWdldF90aW1l
cl9tYXAodmNwdSwgJm1hcCk7
