Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5F43EC830
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686477; cv=fail; b=kh7NrEJ96H6sR6JYvfjiB1d3Bw6CSVjtynZdejn1Do4rfBI5CWwKDkjtZKmA3H9mBhszPuZR2qMxkHTzHpcvqxlgsww/O+xlqAmb0EsC+JvoMEW2kIEk1WcHjLBTQ20JTcEcjqPgelGLUf8g74kz9x/+p3taS0J3RyudRzTLVSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686477; c=relaxed/simple;
	bh=7LWcU6hEAnOG0Qh5td0SZFcTO5iXSwoTErYkt9xCYsc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JeNCieRO4Ik2TE+ek5iHE+janEJEmP4cKcGE/K/k0dx4bfLF3ZUlSRxxqw1fQyFVBp+Oyw6rGMSdLfVzKeC7xDDjn70Ec4Gvyoocu/cDZiSe7gBoLvjYS6OAwXyyS9kWypQjhPnqTkm2w9u6AZdgx0w6KIwlHI4vibZy2VyOOJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oMhrr3Nu; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ic6KgUAm; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oMhrr3Nu";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ic6KgUAm"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAk8Vq361151;
	Tue, 29 Sep 2026 05:54:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=7LWcU6hEAnOG0Qh5td0SZFcTO5iXSwoTErYkt9xCY
	sc=; b=oMhrr3NuC7xnyh6v7XXJS6Co2hqPxRlE34ITSfUI8Ttnw9eli9WwStGbM
	rGuCvGjwTixUkDdSorWVE0kvXczt9NvVJVer6YIESAHvXLa5axoAAJp8CobZZaQK
	HIpkqgtFVVUo2FeLRAbzUdKcNbYcxvwtaSpI+8yofGSmkWJFlSEsRrrTUSKHCYeh
	C8moaKabOMaxUwpMKGC7iMuHZB9B5mXtH5KG1vWkOU89rPAbk8UfQ85rx99uzwMH
	Aor6jObxzCFjztNBMwIladPxupuOYyPEAs8lxcge3gE7z9tESSM+F264iPGOlYiO
	GbJCQvzZtqM13bbDI/KyCj8TJ8QRQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023124.outbound.protection.outlook.com [40.93.201.124])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4h098sgp41-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 05:54:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=miD/XE00UnO4gq0dD00/zlgTzW40Qfula+qbhhCmH7EirfqFVgc3Uj/x7Ej+Dfm0sV4mrRW9P/Jt/p04+Uo1wZxJTHUGLlZGjBZRuv6VB16wFPH+9gac9RjjvmiBPQaMTFBCKu/FcHvtxNuRdtsF2bnLKe1E6h1vgL4Is55ISrO28rMTR1ZI5+tBLJ/GpejCn6jcJ3caz3eZscuPPPXxF5QFV/J9w6ps7eSl+wFnCef7H0CQRkL8vj4JCwm+NGFlfUzyeToW2En2XwmkVRcEKIt0y2Dyc3BWkiKKlJJmPzC6RoqQYz7HbMDIIuH+WfePCNu1GaL0aIOQZfMJqptcvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LWcU6hEAnOG0Qh5td0SZFcTO5iXSwoTErYkt9xCYsc=;
 b=a3pD5OZXn37RrGrwnuPC8bhXb5aJGgNZiHkYrrj7CvBNaOMrXUohMpct+U/NcnCcu6UKi/nYvA2Im3/r+3anc5XZZZ4InRCqaunssP5fphiohieQTTXJpffNkOf13YP/WngB5oKkhe87d7YyMnWUfWjIQca9nLPr+Ahv0rVsc2anQdKfCH5mWBE+5Jd65aWB8Pyp+u8wrYvdJkK+JBs444UD3nHNPKrZMAazXkiMsbriopbPwheRzThbwlvc4th2LDZt440WsQ/W+jOqgvBjr5H2lGQko+RKfD9gq4wdoLAC3B1/A7fw8s1k7MsQOWp0aVoduqvowtGhv0nhMALnRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LWcU6hEAnOG0Qh5td0SZFcTO5iXSwoTErYkt9xCYsc=;
 b=ic6KgUAmSua+8c5NUb4Iy19+O1sROgua/Q2LVJ+4WvaNzSjLix81xmlW2Nd4dDtAwYPTsM7yPm3Fm9B22egMO62UQKDgOkMsoFlpbXuT8Mfu4cz84jDrBv0qKVeZyeyeP5maBP9jdICBnQpup9IJT4jRlydLbyxZv4mG2BuqBS6LPqrBofe8tTqtbrKEN8B+V5Qml4k0dnq/wARP9rUtvJcQjBaJD2aPfxRDZsre7df0EDhH+LByj5OfhKN06BxQ2c8sonT8UQ4KTGK0OwjNUIYonedSq61YCPjhdl+qO2QRDTPzyFT7i0phC6nfXU9BXucKsnBUCj9sP/qVLW7p3Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by LV9PR02MB11253.namprd02.prod.outlook.com (2603:10b6:408:376::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 12:54:19 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 12:54:19 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>,
        "gshan@redhat.com"
	<gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "armbru@redhat.com"
	<armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        "ping@khushitshah.com" <ping@khushitshah.com>,
        Sandesh Patel
	<sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v4 01/25] target/arm: expose SYSREG_ props for
 REVIDR_EL1 and AIDR_EL1
Thread-Topic: [RFC PATCH v4 01/25] target/arm: expose SYSREG_ props for
 REVIDR_EL1 and AIDR_EL1
Thread-Index: AQHdScVjwNHWLvA4PEqgcddc6r/CULbcW8iAgAkz5gA=
Date: Tue, 29 Sep 2026 12:54:18 +0000
Message-ID: <092534EC-547A-4A66-A092-22798198383B@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-2-khushit.shah@nutanix.com>
 <59aff568-9101-4f0a-ae62-61a32b8c1935@redhat.com>
In-Reply-To: <59aff568-9101-4f0a-ae62-61a32b8c1935@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|LV9PR02MB11253:EE_
x-ms-office365-filtering-correlation-id: c02de04e-6cae-4e9e-80b8-08df1e28c69c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|56012099006|38070700021|6133799003|10067099003|260925022911599003|260925021911599003|260925021311599003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 mCeBLcFqbW3QSh12KlrrbrCZ+UxyNcQhI9deoVaCTHAHesDzUgkIgc4WkfZm4b5DEEX3UasCvo1TmuwdWRMLiX5x2clBqm+g+r/E6+aalfqXif4Vl+YfyA5rvu5pmtFieTfrO1ZUdu10j6uO5GU0bwGsPUlOGnY7NJfITdrvAzL2plkuvgdYtpTnLc6GmESDsBPI26aDXhgrNxbQ5S3SgoyL74ddYULPw99Hwff1dsSr2Pv+BHPxVxp6M6PrrCIBYhAqdDuub6nE/jDwZXxm/fhZhYB7XPk190QVEHsAeYxY210NfcDQPNKiaUPLOWzaziSqXbPl/RJRAn9nUKwfVVschZY0iwsE1zt1G1lrVtINLh5inyWLUJUhn8nadwXsSGc0VVNTKyA87tqb+i05yT4WUHE4FajFoxpn1rvjDeZlyaV1OOXdihdcD3+vwXHAIKMuhBoxBpXkO7xb5cLA/oPU7R7MwX0lJ5n9A+P+p0iB18/l2j7gFZoRKFjaXOaQ4oyM+zYB+cTNaCWQm5ZQbFzD220/S0ZpDg7cSaLAyBCrPIPMdW2XMYfLPW3Oln2E1q2N3ppmiI/XsVuw2rwyuLF925M8EsEiMgiP4slx2EY0SF4GYr4i9PaC5z9WrmBcDQmu/tenCpvaEmZ6C/ytCuQ/l1zgzjaCtmdtxs3X/I+dXmmkkW84cP+AuGFnc0dCyn/k7JdMWd1bJpUEXNv+qzgXCXC6r4qKQLQhMk3Ckgk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(56012099006)(38070700021)(6133799003)(10067099003)(260925022911599003)(260925021911599003)(260925021311599003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M1BFQVRtU2VJQXVDUlFhZ01GRUFnOEdpL2d5M3ZwSDN4enRkajllUWlpK2t2?=
 =?utf-8?B?UWRwMUVIa1NpZGh4Z2tEUmt4MFhYSUQyUVRwS3lhNDRCa1VhSHljZnI2aElv?=
 =?utf-8?B?SEhFWlV0VWtEUjJhWVZYQWtjcVBqZWlWNS9rNnpzbGhxcnVSeGxyc3R3MSt3?=
 =?utf-8?B?RHJBKzBodStGMDJQM3FoTS9YWVhwUkI2UmVjY2lRbnRMajRaZmFNR3NKUkRQ?=
 =?utf-8?B?NVM5bytFR0RLc29yckM1TERaMEhnbnJ4M0FCUDdkUTRnNHZFNTVmeC92aDEz?=
 =?utf-8?B?UVNkVnNqNlhkSE1Qa0tCeTBCWGhlRUNKWHc5cktGVk54ZzdjTTBVZUI1bXBk?=
 =?utf-8?B?V2hLS0pwaGhwRXRpbDJiUnoxRXVHR01aU3YyVTI3MmhGSkdrNE1xdnFZWXJT?=
 =?utf-8?B?V1VNVWhCMGVCSWJ1STZIZWhFNENsZ3FxV3VjNGpLcnNjdUJLYTBvSy9KbzlG?=
 =?utf-8?B?cmxWR0FQN2x1RlZDMWJnUThQVHVPMlZaTm1SNU02anV0dEZadkVPWTZmekU0?=
 =?utf-8?B?WGlHRXRWZ09PV0NLZkRvVWtVQjRGSFk3NHpkTDljU0s4WXkwNDljbEhleE9M?=
 =?utf-8?B?ckRQdi9qVGdaTFg2TXI3UkxFUW5YOHQ3OUhKMkI1NVBVM1ltSW1DRGhzTUIr?=
 =?utf-8?B?YXRZcjJxOXNvYW5ReGd2THg4MGVIaVJqc0VPSklOMmpURzQwaXpHN29rQVZQ?=
 =?utf-8?B?ZmdmSlVYOUEyMC9KQlJrb2RXMldtVkNtdGx3cGlpSzh5end0MVF1TytFRWN4?=
 =?utf-8?B?cjlSYlhWM1ZHMlRtbThwc2o1RGpmNk85Y1hEMGxJTmpBWWUxRkNNem1tenZl?=
 =?utf-8?B?WTlhcS9CYk1JK3pzUHhkeWZHMEc0T1FXbVJSZDlCM0p2WUQ4bXlPamRGTHU2?=
 =?utf-8?B?WURqbTJQRytWVGswdGt4ekFlcFhPNHRHWHQ0UStzemsrWHNNa05qOEFkbFBZ?=
 =?utf-8?B?dktuTFk1bXJrdmc0OGgrcCt6U1RJWVZOYzlRRnhTSWtOMzU3VnZGdHNqSnNq?=
 =?utf-8?B?YVJaTHhEWnhwU09kSU83cmw4QWlFT2w0eVlGSDdDOEpORXFxSUxrdFUxZUhG?=
 =?utf-8?B?WW1TaDNkM25HalRvTW40UzRIcG5HT01jeXNZcFB6eEVVQ29CZ01NNktvQTky?=
 =?utf-8?B?Zmc4Zy9rTGtaNUU4TFJ3WlhCVzVhamdPdlV1ZDFuK2YxSG15VXcrbWpoVi8x?=
 =?utf-8?B?V3JyZndyY0FwdWFsNGZlaEFyT2gvVThvK3YwVk4rY0pOMER4Wnh6L3RQbkF4?=
 =?utf-8?B?eDBIYmk1alQwMWNWczV1QWl1L2FxNUlSKzlrb3BBNkJENWZxK2hQYU9pYzIy?=
 =?utf-8?B?U2s0aHlBSit5cFJVUHEvdCtHNFN3VGIwd0MvMnV1T0RLRUluU3pPeXV2YzJJ?=
 =?utf-8?B?cjBxUVFtNGwwbHFWeXBodG9wQnhydHRabnVhM3Q1NytjYjI4M2xCS1BhZEhq?=
 =?utf-8?B?QXkvR0VRYXZrTEl6ZFRHTHAydElua3l4OHB3QURXd0ZpeTFNTFRmOFp3UUZM?=
 =?utf-8?B?UVRBWDYyeUFhbmpyNWhTZG9TcUtVMms0S2cxV0FpL2JnNVVkam1LaWlMRTVK?=
 =?utf-8?B?NXhMYUN4eVEyMU5TVXpmd1RWRzluYXByenkreFltWEVsUUowdFplWlBqenhj?=
 =?utf-8?B?YnQ2K1U4cFVHNzl2a0tGVWVXZllWZEszSU5mb1ZXN2VRM245QS95dklnb2h1?=
 =?utf-8?B?R3F0cFByYWNsNlFicVhQRmR5QmVhYUpPK1FoYW8zTnhpS3NPdEg3Snd5VUFD?=
 =?utf-8?B?UFNxSjM5Rk9rMU83SVF3UWYxT2hYYVQzRHRmVkdiQ0E5MDRuWmxpQks0cXhr?=
 =?utf-8?B?OG54UWFnaG82bG9ENjlUZzNTOTVWcVZUaHQ2ekF1bzhxTVU0bDRFQ2RwUVNy?=
 =?utf-8?B?SmRlRDFmakVCTUZrK1RJYkVSYWZxQ25Nb1JzMm5PWm41ZkhkaDFzdFZiUWly?=
 =?utf-8?B?WDZBYzB3eUdhZStUS3A1N0U0TUhxcFZSRUhjQmgxMVlBVnNIYW0rcUVxL2x4?=
 =?utf-8?B?dkNKcll3c1dqa2d2UVIvWVlWdnN5bkFTb093a29CZzE2a2VjdmJ6c1Y4c0g0?=
 =?utf-8?B?Z3pRbldZYWFtNHV4Y0JubU5lSkF1V3QzQ2lraG1FRFlkRlNCS0dES1ZmY3lI?=
 =?utf-8?B?Y2E3UHlUOFFybEoyd3FDQ3VqSFExdnBRcU5EMHFsS3pPb0U0d2htN0ZxNWNJ?=
 =?utf-8?B?K1BnSXdBSi93U0VoYmVXaWwvU0QrMnRyL0JXTytqekh2MUwrbW9yckg0VVFT?=
 =?utf-8?B?NEFwcU1QNUpFd3JITmlzRkpYYWRaaWxoU3hsYnV0TXVidmhheW5DZkRPaXRI?=
 =?utf-8?B?QXptMENpWHlMWUlhSjN6Z1RkSTBDWnhWbXFKY2lIMDhTbnNyTmozdllYb2d2?=
 =?utf-8?Q?s/pVM04pSTZUt40M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <790E13FD98632E4BA722077AAE815D17@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	2UHwvmYle4zY/M0aDrzgjTlvMkDSk4SqTBZAmIzjITP+it3Zmts2h84WNUyHCZta1mE6Z5Hcs7g1gvnnfevbmRDSih0jOmJjVR0rOg/rK9JLkGJKAutlLb8H4cbIfQNCvln1ScOTBzcCz8khJQNXSzyExvARcIsmtUJJ2fXRKtQAiZK3jGKbFp/2I/wHUed+j6cPKohf+iUIuCgN93jx+eKwSmBzobyUvvEFI+4y51i5YgVPLawg6rItz6KTXNDoHIJprTCk9yLHfdHZPGdV4y2OTjthTPvcOR/gs/HoD4422JzV0qSdj2T6TloGgbjV5h8WygFrbH8gmLVMFV8v/Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02de04e-6cae-4e9e-80b8-08df1e28c69c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2026 12:54:18.9482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hdvrJf6VsuQ4zYY31C90/o1amJyi3esECarv4QLZaCuwr3cLKuRbGstWVWG7W/zLLtJJ64GsJjXlOKmfHKMoMwhx7V9mR8wCLTz79j3gp/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR02MB11253
X-Authority-Analysis: v=2.4 cv=O6CsLx9W c=1 sm=1 tr=0 ts=6abbb4fd cx=c_pps
 a=3zFA2TB6y+4Z7TVRdmCe4w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=hgsfZH-v2Wzl1BjqRzcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: sRKjXgXuDR1_KBKq_37c4_hlkfOsCxfJ
X-Proofpoint-GUID: sRKjXgXuDR1_KBKq_37c4_hlkfOsCxfJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1MSBTYWx0ZWRfXy1aGLjhGhMuh
 JYyFczrAT6M7yaZRbrAg+LAT7qcyRCLneEsA3kxX/oYLy/rU1cdl2LYkwZ18x26BRJOibPOD80w
 OpFxYL2MszAWWlsWbuvATVwyClCIMDbaKRRbUOX9Nu7FpPOwsNUtWVg+ULb0jogXVXRr4zOScH/
 IqOhBosp5tnpLDCisEhoTgoOyHqNC9o9lGUTGcwJBuiMKZd0hkEmuYbgBEibeYAXAQz9r2Nrkpv
 udo/Rx8MsApWUHdu+Cofn8XLRTKLeSjHxHWuNR8HikQbUNvw0M01qMc2YEUM2h+R3CCwyxfxChr
 w7gCsCU2oyoN9es5uArEXp6XRBaqTpysHoD30+yLcmmYtNrSWaWo6JaNDOBsscjCC4HL8ZumXif
 axOU2GI8V7F56BBwi8WUhv4P8f8ZqKR6cvvZ4ObBfH+A/IHzVESBJGTnLWuJWhwcAhcCH/MvlG0
 owWfLaS24TRzI7ICXvQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1MSBTYWx0ZWRfXxvLyEoYjNdZP
 NMLTc8qmLwx1jyY5IKbPn8DpTRuG2aLHvfstkB7CUpJw49i0IdErFln8WVBJqnYfpWMeb/r+vyq
 IkY5JknlfaB4FuqvQxSd+lWZIhozTmE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjMgU2VwIDIwMjYsIGF0IDk6NTLigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDkvMjEvMjYgMjozMiBQTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gUkVWSURSX0VMMSBh
bmQgQUlEUl9FTDEgYXJlIGltcGxlbWVudGF0aW9uLWRlZmluZWQgYW5kIGhhdmUgbm8gbmFtZWQN
Cj4+IGZpZWxkcyBpbiBSZWdpc3RlcnMuanNvbi4NCj4+IA0KPj4gRW1pdCBkdW1teSBWQUwgZmll
bGRzIGNvdmVyaW5nIHRoZSBmdWxsIHJlZ2lzdGVyIGZvciB0aGVzZSByZWdpc3RlcnMNCj4+IGlu
IHNjcmlwdHMvdXBkYXRlLWFhcmNoNjQtY3B1LXN5c3JlZy1wcm9wZXJ0aWVzLnB5LCB0aGVuIHJl
bW92ZSB0aGUNCj4+IHNwZWNpYWwgY2FzZSBmb3IgdGhlc2UgaW4ga3ZtX2FybV9leHBvc2VfaWRy
ZWdfcHJvcGVydGllcygpLCBleHBvc2luZw0KPj4gdGhlbSBhcyBTWVNSRUdfIHByb3BzLg0KPj4g
DQo+PiBTaWduZWQtb2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNv
bT4NCj4+IC0tLQ0KPj4gc2NyaXB0cy91cGRhdGUtYWFyY2g2NC1jcHUtc3lzcmVnLXByb3BlcnRp
ZXMucHkgfCAgOSArKysrKysrKysNCj4+IHRhcmdldC9hcm0vY3B1LWlkcmVncy5oLmluYyAgICAg
ICAgICAgICAgICAgICAgIHwgIDIgKysNCj4+IHRhcmdldC9hcm0va3ZtLmMgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgMTAgKy0tLS0tLS0tLQ0KPj4gMyBmaWxlcyBjaGFuZ2VkLCAx
MiBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvc2Ny
aXB0cy91cGRhdGUtYWFyY2g2NC1jcHUtc3lzcmVnLXByb3BlcnRpZXMucHkgYi9zY3JpcHRzL3Vw
ZGF0ZS1hYXJjaDY0LWNwdS1zeXNyZWctcHJvcGVydGllcy5weQ0KPj4gaW5kZXggMGI0ZTRkM2Uw
Yy4uMjI2OTA2MzQwOCAxMDA2NDQNCj4+IC0tLSBhL3NjcmlwdHMvdXBkYXRlLWFhcmNoNjQtY3B1
LXN5c3JlZy1wcm9wZXJ0aWVzLnB5DQo+PiArKysgYi9zY3JpcHRzL3VwZGF0ZS1hYXJjaDY0LWNw
dS1zeXNyZWctcHJvcGVydGllcy5weQ0KPj4gQEAgLTI0Niw2ICsyNDYsMTUgQEAgZGVmIGdlbmVy
YXRlX3N5c3JlZ19wcm9wZXJ0aWVzX2Zyb21fcmVnaXN0ZXJzX2pzb24oaWRfcmVnX25hbWVzLCBy
YXdfanNvbl9wYXRoKToNCj4+ICAgICAgICAgIyBTb3J0IGRlY3JlYXNpbmcgbHNicw0KPj4gICAg
ICAgICBzb3J0ZWRfZmllbGRzID0gc29ydGVkKHVuaXF1ZV9maWVsZHMuaXRlbXMoKSwNCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBrZXk9bGFtYmRhIHg6IHhbMV1bJ2xzYiddLCBy
ZXZlcnNlPVRydWUpDQo+PiArICAgICAgICBpZiBsZW4oc29ydGVkX2ZpZWxkcykgPT0gMDoNCj4+
ICsgICAgICAgICAgICAjIEZvciBjYXNlcyBsaWtlIFJFVklEUl9FTDEsIGFkZCBhIGR1bW15IGZp
ZWxkIGNvdmVyaW5nIHRoZQ0KPj4gKyAgICAgICAgICAgICMgZnVsbCByZWdpc3Rlci4NCj4+ICsg
ICAgICAgICAgICBzb3J0ZWRfZmllbGRzLmFwcGVuZCgoJ1ZBTCcsIHsNCj4gdGhvdWdoIEkgdGhp
bmsgaXQgaXMgaW1wb3J0YW50IHRoZSBwcm9wZXJ0eSBuYW1lIHN0YXlzIFNZU1JFR19SRVZJRFJf
RUwxDQo+IGFuZCBub3QgU1lTUkVHX1JFVklEUl9FTDFfVkFMIHNvIEkgZ3Vlc3Mgd2UgbmVlZCBl
aXRoZXIgYSBwcm9wZXJ0eSBhbGlhcw0KPiBvciBhIHNwZWNpYWwgaGFuZGxpbmcgZm9yIHRob3Nl
IHJlZ3MgKGJldHRlciBhcyBhbGlhcyB3ZXJlIG5vdCByZWFsbHkNCj4gbWVhbnQgZm9yIHRoYXQg
cHVycG9zZSBJIHRoaW5rKS4NCg0KRG9uZSwgdGhlIHByb3BlcnR5IG5hbWVzIHdpbGwgbm93IGJl
IFNZU1JFR19SRVZJRFJfRUwxL1NZU1JFR19BSURSX0VMMSANCg0KVGhhbmtzLA0KS2h1c2hpdA0K
PiANCj4gRXJpYw0KPj4gKyAgICAgICAgICAgICAgICAnbHNiJzogMCwNCj4+ICsgICAgICAgICAg
ICAgICAgJ21zYic6IDYzLA0KPj4gKyAgICAgICAgICAgICAgICAnd2lkdGgnOiA2NCwNCj4+ICsg
ICAgICAgICAgICAgICAgJ2VudW1zJzogW10NCj4+ICsgICAgICAgICAgICB9KSkNCj4+IA0KPj4g
ICAgICAgICBmb3IgdW5pcXVlX2tleSwgYml0cyBpbiBzb3J0ZWRfZmllbGRzOg0KPj4gICAgICAg
ICAgICAgZW51bXNfbGlzdCA9IGJpdHMuZ2V0KCdlbnVtcycsIFtdKQ0KPj4gZGlmZiAtLWdpdCBh
L3RhcmdldC9hcm0vY3B1LWlkcmVncy5oLmluYyBiL3RhcmdldC9hcm0vY3B1LWlkcmVncy5oLmlu
Yw0KPj4gaW5kZXggYzdlOTNjNDhiNy4uYmM1MjExMjQzMCAxMDA2NDQNCj4+IC0tLSBhL3Rhcmdl
dC9hcm0vY3B1LWlkcmVncy5oLmluYw0KPj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmgu
aW5jDQo+PiBAQCAtMTIsNiArMTIsNyBAQA0KPj4gLyogSURSRUdfRU5EKFJFRykgKi8NCj4+IA0K
Pj4gSURSRUdfU1RBUlQoQUlEUl9FTDEpDQo+PiArICAgIElEUkVHX0ZJRUxEKEFJRFJfRUwxLCBW
QUwsIDAsIDY0KQ0KPj4gSURSRUdfRU5EKEFJRFJfRUwxKQ0KPj4gDQo+PiBJRFJFR19TVEFSVChD
TElEUl9FTDEpDQo+PiBAQCAtMjQzOCw2ICsyNDM5LDcgQEAgSURSRUdfU1RBUlQoTVZGUjJfRUwx
KQ0KPj4gSURSRUdfRU5EKE1WRlIyX0VMMSkNCj4+IA0KPj4gSURSRUdfU1RBUlQoUkVWSURSX0VM
MSkNCj4+ICsgICAgSURSRUdfRklFTEQoUkVWSURSX0VMMSwgVkFMLCAwLCA2NCkNCj4+IElEUkVH
X0VORChSRVZJRFJfRUwxKQ0KPj4gDQo+PiBJRFJFR19TVEFSVChTTUlEUl9FTDEpDQo+PiBkaWZm
IC0tZ2l0IGEvdGFyZ2V0L2FybS9rdm0uYyBiL3RhcmdldC9hcm0va3ZtLmMNCj4+IGluZGV4IGUz
YTBkYzA3ZGUuLjhhODIzZDAzMjQgMTAwNjQ0DQo+PiAtLS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+
PiArKysgYi90YXJnZXQvYXJtL2t2bS5jDQo+PiBAQCAtNTU0LDE1ICs1NTQsNyBAQCB2b2lkIGt2
bV9hcm1fZXhwb3NlX2lkcmVnX3Byb3BlcnRpZXMoQVJNQ1BVICpjcHUsIEFSTTY0U3lzUmVnICpy
ZWdzKQ0KPj4gICAgICAgICBBUk02NFN5c1JlZyAqc3lzcmVnZGVzYyA9ICZyZWdzW2ldOw0KPj4g
DQo+PiAgICAgICAgIGlmIChzeXNyZWdkZXNjLT53cml0YWJsZV9tYXNrKSB7DQo+PiAtICAgICAg
ICAgICAgLyoNCj4+IC0gICAgICAgICAgICAgKiBzcGVjaWFsIGNhc2UgUkVWSURSX0VMMSBhbmQg
QUlEUl9FTDEgd2hpY2ggYXJlIHdyaXRhYmxlIGJ1dA0KPj4gLSAgICAgICAgICAgICAqIGRvIG5v
dCBleHBvc2UgbmFtZWQgZmllbGRzLiBUaGV5IHdpbGwgbmVlZCB0byBiZSBoYW5kbGVkDQo+PiAt
ICAgICAgICAgICAgICogc2VwYXJhdGVseQ0KPj4gLSAgICAgICAgICAgICAqLw0KPj4gLSAgICAg
ICAgICAgIGlmIChzdHJjbXAoc3lzcmVnZGVzYy0+bmFtZSwgIlJFVklEUl9FTDEiKSAmJg0KPj4g
LSAgICAgICAgICAgICAgICBzdHJjbXAoc3lzcmVnZGVzYy0+bmFtZSwgIkFJRFJfRUwxIikpIHsN
Cj4+IC0gICAgICAgICAgICAgICAgZGVjb2RlX2lkcmVnX3dyaXRlbWFwKG9iaiwgc3lzcmVnZGVz
Yyk7DQo+PiAtICAgICAgICAgICAgfQ0KPj4gKyAgICAgICAgICAgIGRlY29kZV9pZHJlZ193cml0
ZW1hcChvYmosIHN5c3JlZ2Rlc2MpOw0KPj4gICAgICAgICB9DQo+PiAgICAgfQ0KPj4gfQ0KPiAN
Cg0K
