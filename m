Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4893120A5EA
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=208.86.201.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760089930; cv=fail; b=d//I15H29RGjQp+XAZmS9JAyrdAQIPk/Ngdj7TMXjbxbNI4vgIf/LooheJpl/nyN1/iUvuPvEZV9l4c8bHSWG6q3WahuhRwEWv2xnBrPjUNaohv0IMqrhWnIjE6JKo99ByScQsoqayMsBtkWToX3M+2MJgpYpguhsT9BIFNRKOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760089930; c=relaxed/simple;
	bh=h6jE3PQH/x8lm2taAyItp+OSFcrFCr5mBALqeMPka0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sWq3HwVqC5MSxs20MZVXNOAmxA3dB6NbtMrbCHal9cqG3ErZ36S6Ao2Z+i9pLO+WPnUQYlYpQIInjTm8rfANIjqnwb+WQ1ciBIOCrury7yS+7WH9sakuUltjgSsYigTSAZH4gYmXj7CZoIgeUARRnrUI4R+wO0nFchkzx+NFaLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com; spf=pass smtp.mailfrom=cadence.com; dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b=gfhOofB7; dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b=37H26d0G; arc=fail smtp.client-ip=208.86.201.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cadence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cadence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="gfhOofB7";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="37H26d0G"
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
	by mx0b-0014ca01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A3p38m004717;
	Fri, 10 Oct 2025 02:51:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint; bh=h6jE3PQH/x8lm2taAyItp+OSFcrFCr5mBALqeMPka0w=; b=g
	fhOofB77Yc2ziiHJwc1Te7dR9G6z+hZMwfqKDMiIBIEiQaOPXgTDr2Y5Ab/EM2Ek
	lIoIYLm7lYGxTZK9HgOvAIIKJsHpp0DuEbOUx6ExyemYtvUIQWmo/XSC3WZinS9g
	6f21YJsGoQRJ5MufaLJaaX2JXdsVJmmkv/rot+QfoPEe8Vi1GeSl8lSDNTT9eBJ/
	OxqueJvp36CP9Qrr1A6I34LnP5Gdm7eUUA8QL3SMrQb+A4SxrpiR8/bBkr3rCUB7
	/xsA1yAfQjIKWvNesqHFYm48vT5lIWKe7v+w7eAJGjhTukVVIQzyLUHU5vzg0pa5
	2V8SQnepOwY82vlukPzjw==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11020102.outbound.protection.outlook.com [52.101.85.102])
	by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 49nv62sjc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 02:51:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCnTvt54jPiN5LY3cyYPmcGZPH6zQCuNflz6ScP79CIxoJmDDfLwnOibjUCKWTlL9Nfw5r5Nq8ypJYrOsyakDpA2m3zoAK8KydZzyEo5xiJJojGbQ3GFR2E6tdTF3+6+RtPMgWUUVtwx+7JRvEvXXHcuKi5mkPsGpIFtXm+ut6szM/tnqHpzsJRh7jZhxi/iacjHn8wdFESh8kjBg/Gpe5VO/7IqWKyhMQbZAzz8M7gKF8Ti3TMmX84SZZM+GOzWth168J+P6RVEyR64Q1RqNPtaPPswMZ2q0U3p8Xk4Ro/o0Xsq6iJaGcQRcoL8fybTnETmiVWyY2BV/169vcxicg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6jE3PQH/x8lm2taAyItp+OSFcrFCr5mBALqeMPka0w=;
 b=Juydf+Ub0o87bqejuMnccuuqTajzY2XLVSXVCC1/xzXiVB7jJkKHEZ9sLU2Y1/02cYIwpMrv/zLv3HNDiacutb81gMZf0IFF7NjzQVu1UBxwJfkaz0y6DNSw94uNm1BWqX8aY1CUU3IHWaKoUJTchwo8vwW7cjFT0tK8M1wMM8sdcJll913GCTOLnMLBAGw+u6XvPK4nw5W36qm6eHLqEL2W8wzHRPFICNARTBeXqu6QQ6RSePkP3W8pIx4lKgq0Ll9PeYtu5XFpWUqv3BlfjTeVfxYO2fjNkk9oPmFTQOOaHT5XBoyItEM/4KJopEJ2AAg8c1GLNciVtbswJo7gKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6jE3PQH/x8lm2taAyItp+OSFcrFCr5mBALqeMPka0w=;
 b=37H26d0GKz5Xo3NZHRkEvx5Gch7UAhEld4cRYSzQC30hGatxLLySWCxu4ElZ9paPqvebE0QabW2me02/cwPRbrmGAJwGL0ZJPtdnnrmrUBzoOcHrZNo54/AuZ2PSsw/k7ueh0nFr2ZJnepSzF/U0OaL6wYNXR7/ifYaORPlzWmg=
Received: from SN7PR07MB9604.namprd07.prod.outlook.com (2603:10b6:806:2af::13)
 by LV8PR07MB10070.namprd07.prod.outlook.com (2603:10b6:408:1e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 09:51:52 +0000
Received: from SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a]) by SN7PR07MB9604.namprd07.prod.outlook.com
 ([fe80::3db6:f5eb:b1c3:999a%5]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 09:51:52 +0000
From: Jan Kotas <jank@cadence.com>
To: Marc Zyngier <maz@kernel.org>
CC: Jan Kotas <jank@cadence.com>, Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: HCR_EL2 GET_ONE_REG value difference
Thread-Topic: HCR_EL2 GET_ONE_REG value difference
Thread-Index: AQHcOcAYVqsE1KhNtkOoBBTRbaAYVLS7H3+AgAAD9YA=
Date: Fri, 10 Oct 2025 09:51:52 +0000
Message-ID: <2268E166-0EA0-4C9D-B1AF-EEECB48B926B@global.cadence.com>
References: <47FBDCE7-F8D8-4071-93D8-E4E494D41F34@global.cadence.com>
 <86ikgnxfl0.wl-maz@kernel.org>
In-Reply-To: <86ikgnxfl0.wl-maz@kernel.org>
Accept-Language: en-US, pl-PL
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR07MB9604:EE_|LV8PR07MB10070:EE_
x-ms-office365-filtering-correlation-id: 200726ac-ba0e-4428-b3e0-08de07e2a39b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZnduNFlvOHRka0ZkcEZKdjdja0p4aWZkZDZPZXZwVld5aFpDRE1Da3FKK2Fm?=
 =?utf-8?B?QUNqZ3V6NHJWZDZTVDRTb0xEb0hGbCtVTWNZTGlzRVFNSEZFQ0FPd3AzTG45?=
 =?utf-8?B?aUxTTXBDWGxydVA4UUhENzU0b29qSVFFbTRWL0NyYzgzc0FCSkFGeDZEN2Zv?=
 =?utf-8?B?Q2FoUjRGanh4VXVZNXVmSllkeW8xTUIvcWlhLzd5ZTY5SEZQN3l4K2p6anFx?=
 =?utf-8?B?bi9OR3RmSG1ydnVESm03eWpsU1JvMVJaWWpRWWtTMEMwL2lxOWRmdXFHcGs3?=
 =?utf-8?B?V1VjUHVuT0VXd2YwTGY1bnBtMHpWd0Jvcm1oc2RDbXdsNWlURnVaU29mNFVW?=
 =?utf-8?B?ZDlhKzA1WHZkVDFObXFhWkZNY0V3WlBLTHlPaDY0NVRsV2pVOWtpU2EvZnpV?=
 =?utf-8?B?Tm5aNnBJMVR2UUxwU3NPT2VuUGljVm42Um44aVpTaGFmbU1zNEZwNnhtckpW?=
 =?utf-8?B?ZHpnTTZ5dGpXUW8rOGVPSlJPVExpYzBMeDEwNXdvbWd0a3FnNy9QSFFyZU5x?=
 =?utf-8?B?YklPM3VWcU9JWFV3RmVpMmF3dE1hUmg0aFArT1AzUnVOOU8xSVg2d3lSQkZ2?=
 =?utf-8?B?WDJmN0dOaGFlL053QzRaS0lGQnhKQnQvVVE3SC9SRUQvMFVzOVV0TC9SOU0w?=
 =?utf-8?B?cWhCMXR6UGtUbWE1cW5EeTBOZ3BvS1ZwTDRyVUpvdko0dXFBY3NibEl4NGNC?=
 =?utf-8?B?aWhTZXU3VzZ6dnB6MExWNkpLTVpFQXo5TFhmZDBtNkNyMlhlT2VubFJNRkEz?=
 =?utf-8?B?Nk0yak1Zc0cwLzVPbjNETFVRVmp3S0tiRGJQb0w3VEtSZmNNMVZ0SkZJUGkw?=
 =?utf-8?B?Rmt1MXNlNHUrRHRFNDJBOUg1WnVQMmRSeDVBT1JNRnIwOFgvcE8zVS91ZU9n?=
 =?utf-8?B?RXdMMkpqT01rNk9XYitXNkxCelNhdHFOK3RtZHBpWndCR254YlFGSGFKaXA1?=
 =?utf-8?B?M0ZNMnRNTDRhcDU1K1FFYmVyUE5KNDR1cEs4aHVIeDlDcDVycmNzYUpTcEt5?=
 =?utf-8?B?UWtSVE9GektQekZWaUNnYzlOUWkvTVBOai8vejNnRE82TVNWQmNaNzlIUlhX?=
 =?utf-8?B?YWU5bEtkNnRYSzc1MkZkaHQyUzFvZHI5OEdqelNtVWFoZWVqK2MydnpEcEts?=
 =?utf-8?B?QWYxWXYzeEJPd1RqdmdwWmhvWC81bEtBcXFuVlBGWWxabWtldFp3M0VSK3lJ?=
 =?utf-8?B?UWdodU1uMDVJb3kycjFmeUk4Z3dXNGVZNG1tQ3Bwd1VZTTJkTG5kT29TZE9w?=
 =?utf-8?B?R00yUEtZZjg3eXJRenA1RmdLalZhaUVvZVhDb05KZWRkZURITTdrVnZ4SDRM?=
 =?utf-8?B?ZG1DZlNDRi81WGF1aGphYS90eWZuNG9CekE5QnhvaklMbml0dmZwWGdOUVlK?=
 =?utf-8?B?WDNVUmt0WjJ4S2J2MzZicFQrSjJsemtqYkUrVzU5Y3JuUE52Q1gvNzNsQlpa?=
 =?utf-8?B?aHNIWE50RVpTU2NpN3JCOFZsRkxybzgvWE5UcEVMUm5pUHhiRWpPYllYQy9i?=
 =?utf-8?B?M3RFZTZsdWlWaW90aTFCSyttOWJ6dUpiTGN4NjZ4WkY2UnhzWXdxcFh6ZFo1?=
 =?utf-8?B?Mmk5ZzIwRm9NdGpNT3k1RnNrdWFHYkg2M0JLWGp0YWZqSTJERUM0bWF4NjVJ?=
 =?utf-8?B?UTZ3ZmtheTJGZXM2Z1hnK2dyQWY4ZVptOXg3bmFJYk02bXROczZhZGQxU2JD?=
 =?utf-8?B?cGZuajcwQUNua1g1cnVtUmQ2UlJxVEtadDJQbVpBWVUwQ215ZUZleStSb2tZ?=
 =?utf-8?B?QnNIU1pmWjVVOVVQclVHUERjTytnMEpRb3dXUGpyYkpFelVrN0ZsRTJrdlBE?=
 =?utf-8?B?eFd4TFJaY2dQb3EyaXFpZlpZZG9zR010RnNUaDVka3FSK2grT3A2RmVuNW9T?=
 =?utf-8?B?WTRjTnN3emxHTG4rOFZOanR2cFhYT3VKem1ERTFZNko3R0pRUlA1M05tSVFY?=
 =?utf-8?B?b2VKajl6Q2c4R0dES2RzK3pxNWV1R2t2NkVJa0ZXeDM0MUZqZGNlYTdkZUhS?=
 =?utf-8?B?MWlsWWFJNlhuL0NnMkZvU3dYc05Pd3hNVHhkbDBOQUh6WE5DTUV6ckVXVkU2?=
 =?utf-8?Q?u6qc5F?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR07MB9604.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjQzTFNTKyt2d2pzbk9MRWlkL0d3VllXNldvR3ExZTBTZWdDRmtVWFVBMU1r?=
 =?utf-8?B?SHBxYTJoTmZrMndvRk9wcCtNVEZHc0JjRnQra0pCM2QyY0Y0OS9sUXREa0Ru?=
 =?utf-8?B?Qm5HalZDNm9wczhRTGFkaXFvL2QvS3pOR3RoSWNtWFR5dFFnSFlodnRRNGlU?=
 =?utf-8?B?OUs3WlBMRVBFT0NRVUlJaGV6Qy9yTjBMaSt6Z3BDQjR2blhKazVVbEFTNkhw?=
 =?utf-8?B?bS9HY1VWR3J1Q1VDdXhUckFuQWs2ajZzeWFMdkh6TUpMQmtSejRoaHBNeWwv?=
 =?utf-8?B?bEd0QUJPTWlJNGtZRjdyYVRvVlRsa3BselZSZlhBYUNRa3RSdU91bFo3Z3hQ?=
 =?utf-8?B?MkExaXozdzNmK1lnUThlVmhwRDd0MXlROENLQ2hlenJOS3FVUncyVXpqSmE2?=
 =?utf-8?B?MjVSdTI4VnpadGt2MnlvdnlOYmxRVTlFd25KbnR2dU9rTmVqelB5cHBoN3JU?=
 =?utf-8?B?cVpqWmF0TndyeXdBSjZkc3lQQnk4b2NXUmZrc2M5czk3c3RiNUJJdC96WlZT?=
 =?utf-8?B?cDlhVWFsOU9ZSmRsRTNkSWkwNGxTTnpOOG80d3ozOSt2ZG5zYUxOT0ZyeHZK?=
 =?utf-8?B?cEQrM3hTVEgwdUZuU3hTTVBuSDZqaVgyb0ZFWDJqcmhnTDUzMW5adEN2em0r?=
 =?utf-8?B?YzR0SXJoWEZsV3VvRXF3RTk3dll6TFR2Nk9RQk5DWTB5aHcwUkdNb21rcC92?=
 =?utf-8?B?clp0S1JpL1RCNjJlVzFrdXVwUFBzNzhRcENvQm5KNnBTaWdQRHVqOXNvVVdM?=
 =?utf-8?B?NTd2VG5tQVdNSDJuWFhkYTFaZDFJR0lGMG8wbVVsRE1Tb0liVkxySjZCS3lq?=
 =?utf-8?B?TDhzTktLREJ1Y1FYb2pBUTFxQlB2c2V0dGp1QWxjMFNMWk83czJlWmQ0TUxm?=
 =?utf-8?B?cnU5MWE0OVJJa3FRUTNoQ0h0R05EQ3owVDhEQi82YnFkaUNrcXV4dGRGTGYx?=
 =?utf-8?B?NmJTdlZ3RC9tSjE3TThMSjhMRHpBUFp5WTNteU1SUEhnUFFpblQzME1pTjNF?=
 =?utf-8?B?eHprRXJhTXFJVk04VzZwQWNqR1I5NzdUcldBR3hBMkswUCszZ3FwTGFEVE1q?=
 =?utf-8?B?RmdsUkprcE5PM1hTOVJHS08wdE5jTFErS1BGZXpIYktnMEpXTVdkLzBoQnBs?=
 =?utf-8?B?TXoycUJlOU1YZURROHE1dS9hK1RFcEJKWHBiRjlHL0pUdlZZTFZTY0Y0aGRM?=
 =?utf-8?B?MFVQQ2ZDem1HM3ZYSWZlKzU3aWl1ZFhXZmNHY2xvRjhFcEFVdDAyVFczTWlm?=
 =?utf-8?B?Ykt0Mm83ak44bis1aktBaU9vcEE4aENVYTgzclpvL3ZUYjFhK2pnd29KZ2NF?=
 =?utf-8?B?aHllaUc1MnN5KzlNUWR1Ylp3YkE4d2hmRmhUNHk2TmNNaVcwUEU1TnRydWk3?=
 =?utf-8?B?TFJKb21OL3ExMUcxa3NqdkoyREoxVjRwRkxMdks1YVM5M3N1M1pqTlc2MllS?=
 =?utf-8?B?NURwR3lsZWdjR0dSR1RZb2NyeTlsb2pBSEo2aDBXc2RhT0NuYmxaOHRpMUhl?=
 =?utf-8?B?WGJsSXN5dzM3c000YXZZS3R3aWRmdFJKYUdlcVZ1cG9Nb003Vml6eS9veXlP?=
 =?utf-8?B?K29iczhYT0NubitKNUdGd1NHT2oxOFErS2d0K3hHb0VncVlCaHlYNUFIbExh?=
 =?utf-8?B?ZzhnQmFUeTBxQlUrWWFnQnVROXVDellVUXZrSDIzdkt0NmRaZlFSWmtWcC8w?=
 =?utf-8?B?ekd2aXVSdjZ1clVqSnpkTzdSVFhwS1pZbHBLYUJVU3pzQytVV3E0UFN0R2x2?=
 =?utf-8?B?bUFBQzFJUSs3MmpwMTRIOWs0ZjE0K3FIRERXWlE0RHNVWUErYWIxUXo1QVU1?=
 =?utf-8?B?ejFOMmdQQmxCamZYSW9ZRXJjdEVwQzYrTDNJd2g0TGt6a3poR1M3anlHVm9z?=
 =?utf-8?B?TEtmNzBPT2tBOTVQRGQrZThCSUlHeVlycG9nUC93ZHcxdGJiT20zVGxNZ0lT?=
 =?utf-8?B?TWg5TDNVRDdTcUtnZkxVa240U0YrRkJMaU9Lc3YwQWUzZ0xvV1FoM09CRHJ0?=
 =?utf-8?B?ZUpSKzhaOGJGdWRoS2U5OTQ0Z1RkSUZ6Ymh0UVN6Y3hHWmlFZVlhVXR0cWtp?=
 =?utf-8?B?eDAwVUE4bDBhdGl4dlE1WFoyTFZQaFp3S0ZKSVVGVXJSWjJKZnZ3SFhZclNs?=
 =?utf-8?B?YktzQVNpSGFZMUVSUDFOSDRxajdGODVNNzg1MUg5cE94U1BDYk5VRTltUm1H?=
 =?utf-8?B?c2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25EDF2BFA394DE4DBFEAAE4911D1195A@namprd07.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 200726ac-ba0e-4428-b3e0-08de07e2a39b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2025 09:51:52.1507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: glegVw3zyCmBjiXajlfRQzxqAdQD9vZHXZJbVYIbJm+Pja5eqGsEZVWfIULQF50kggy3OgpQH9Hkr7Cs6fo0tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR07MB10070
X-Authority-Analysis: v=2.4 cv=aom/yCZV c=1 sm=1 tr=0 ts=68e8d73b cx=c_pps
 a=/HvL1LX/IhLcM0VBVohJhQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=Zpq2whiEiuAA:10 a=VwQbUJbxAAAA:8 a=Br2UW1UjAAAA:8
 a=0RkxlGvoEn2Dvz_ijz8A:9 a=QEXdDO2ut3YA:10 a=WmXOPjafLNExVIMTj843:22
 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-ORIG-GUID: cj2MsWDfSsP5cKl-bxewPwpPjQS8HQeF
X-Proofpoint-GUID: cj2MsWDfSsP5cKl-bxewPwpPjQS8HQeF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXx8GkO27HV1jQ
 EKoCJZTQTQKZ+Dl++gj0Sa8TSVw/OdJt5oO+rR7Rh8eOAMiXfKaWYlVUV5PdNifr6UxzYhi6WOb
 ECKXG947PdyajeoYLH/hq9uW26ewjkpPA3nc9BiQY2Snv6/oi1Ldvl8AowcPn2kOc6Tucxx/0TP
 aY+MrvQWbvnCjkQUnN1PopHpU7N2cM5jy5FHhW6PJeicvul/Ym3piID7FbW0vwy0uLPe0RJFr7q
 mP5I9G46uGj32c6kDzN4bWqYwnGjIocDZFh8Cwt6zhU0Fc8Fv8aL5l79Ndz2mZCD+/x4ocIWaKi
 heXhoQQLxL+8e6u9vzKjdvFf+kGp3GvS7e5Llr7iCP2QMyWcpu11BDE99kq0LsxCOZb6ehIGpvM
 h5I0t5XawSt4/nryimczgjiQbjR0kw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121

DQo+IE9uIDEwIE9jdCAyMDI1LCBhdCAxMTozNywgTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+IA0KPiBFWFRFUk5BTCBNQUlMDQo+IA0KPiANCj4gT24gRnJpLCAxMCBPY3Qg
MjAyNSAwOTozMDoxMiArMDEwMCwNCj4gSmFuIEtvdGFzIDxqYW5rQGNhZGVuY2UuY29tPiB3cm90
ZToNCj4+IA0KPj4gSGVsbG8sDQo+PiANCj4+IER1cmluZyBOViBkZWJ1Z2dpbmcgSSBub3RpY2Vk
IGEgZGlmZmVyZW5jZSBpbiBIQ1JfRUwyIHZhbHVlLg0KPj4gDQo+PiBUaGUgdmFsdWUgSSBnZXQg
ZnJvbSBhY2Nlc3NpbmcgdGhpcyByZWdpc3RlciwgdXNpbmcgS1ZNX0dFVF9PTkVfUkVHOg0KPj4g
MHgzMDQ4MDAwMDAwMA0KPiANCj4gVGhlc2UgYml0cyBhcmUgQVBJLCBBUEssIEUySCwgUlcuDQo+
IA0KPiBXaGVuIGRpZCB5b3UgYWNjZXNzIHRoaXM/IEFmdGVyIHRoZSB2Y3B1IGhhcyBydW4/IEJl
Zm9yZSBpdCBoYXMgcnVuPw0KPiBXaGF0IE5WIGNvbmZpZ3VyYXRpb24gZGlkIHlvdSB1c2U/DQoN
CkhpIE1hcmMsDQoNCkkgd2FudGVkIHRvIHJlcHJvZHVjZSB0aGUgY29uZGl0aW9ucyB3aGVuIEkg
b2JzZXJ2ZWQgaXQuDQoNCkkgcnVuIHRoZSBndWVzdCB3aXRob3V0IHRoZSBpbXByb3ZlZCBFTDIg
ZGV0ZWN0aW9uLA0Kd2hpY2ggd2FzIHBvc3RlZCB5ZXN0ZXJkYXksIGluIFZIRSBtb2RlLiANCkni
gJltIGludmVzdGlnYXRpbmcgdGhlIHBsYWNlIGF0IHdoaWNoIEUySCBkZXRlY3Rpb24gaGFwcGVu
cywNCmp1c3QgYmVmb3JlIGFuIGV4Y2VwdGlvbiBvbiBaQ1JfRUwyLg0KDQo+IA0KPj4gDQo+PiBI
b3dldmVyLCBYMSB2YWx1ZSBhZnRlciBleGVjdXRpbmcgbXJzIHgxLCBoY3JfZWwyIGluIGd1ZXN0
Og0KPj4gMHgxMDAwMzAwODAwMDAwMDANCj4gDQo+IFlvdSBoYXZlIEFUQSwgQVBJLCBBUEssIFJX
LiBJcyB0aGF0IHRoZSAqb25seSogdGhpbmcgdGhhdCBoYXMgcnVuIGluDQo+IHlvdXIgZ3Vlc3Q/
DQoNCkkganVzdCBib290ZWQgdGhlIGtlcm5lbCBkaXJlY3RseSB3aXRob3V0IEUySDAuDQoNCj4g
DQo+PiBJIGFjY2VzcyBib3RoIG9mIHRoZXNlIGF0IHRoZSBzYW1lIHBsYWNlLg0KPiANCj4gImF0
IHRoZSBzYW1lIHBsYWNlIj8gV2hhdCBkbyB5b3UgbWVhbj8gT25lIGlzIGFjY2Vzc2VkIGZyb20g
aG9zdA0KPiB1c2Vyc3BhY2UsIGFuZCB0aGUgb3RoZXIgZnJvbSB0aGUgZ3Vlc3QuIEhvdyBjYW4g
dGhhdCBiZSB0aGUgc2FtZQ0KPiBwbGFjZT8NCg0KQnkgdGhlIHNhbWUgcGxhY2UgSSBtZWFuIHRo
ZSBzYW1lIEtWTV9FWElULg0KV2l0aG91dCByZXN1bWluZyB2Q1BVcywgYXQgdGhlIHNhbWUgUEMu
DQoNCj4gDQo+PiBJIGdldCB0aGUgbGlzdCBvZiBhdmFpbGFibGUgcmVnaXN0ZXJzIGZyb20gS1ZN
X0dFVF9SRUdfTElTVC4NCj4+IA0KPj4gSSBkb3VibGUgY2hlY2tlZCBteSBlbmNvZGluZywgYW5k
IGl0IHNlZW1zIHRvIGJlIGNvcnJlY3QuDQo+PiBIQ1JfRUwyIDMsIDQsIDEsIDEsIDANCj4+IA0K
Pj4gSSBjYW4gY2hlY2sgb3RoZXIgcmVnaXN0ZXJzLCBidXQgSSBmaXJzdCB3YW50ZWQgdG8gY2hl
Y2ssIGlmIHRoaXMgZXhwZWN0ZWQ/DQo+PiBJcyB0aGVyZSBzb21ldGhpbmcgSeKAmW0gbWlzc2lu
Zywgd2hlbiBhY2Nlc3NpbmcgZW11bGF0ZWQgcmVnaXN0ZXJzPw0KPiANCj4gQ291bGQgeW91IHBs
ZWFzZSBzdGFydCBieSBjbGFyaWZ5aW5nIHdoYXQgeW91IGFyZSBkb2luZz8NCg0KSSBwbGFjZWQg
YSBIVyBicmVha3BvaW50IGF0IHRoZSBNUlMgaW5zdHJ1Y3Rpb24uDQpJIGRpZCBhIHNpbmdsZSBz
dGVwLCBhbmQgdGhlbiBJIGNoZWNrZWQgWDEgYW5kIEhDUl9FTDIgdmFsdWVzLg0KQnkgY2FsbGlu
ZyBHRVRfT05FX1JFRyBvbiBib3RoLCBJIHNlZSBkaWZmZXJlbnQgdmFsdWVzLg0KDQpSZWdhcmRz
LA0KSmFuDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IE0uDQo+IA0KPiAtLSANCj4gV2l0aG91dCBk
ZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jlc3MgaXMgbm90IHBvc3NpYmxlLg0KPiANCg0K
