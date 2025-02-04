Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA9E212B36
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 14:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738678266; cv=fail; b=bsj8+9LJa9/mH7hwVaUSEXiLZkk2NP9f7NUWDcF7N118WKjqqPbpdbrbgEiaLj/L8xv0gWooHhC9ChtnwNSWE/UJIIOhO1N0ulwv/EohvXrkDLBwGPFgf6HGpZY9D9F90fLeh84YppRkMcCTIi5XD5Ncj/+dntuvI9QOWgSEvr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738678266; c=relaxed/simple;
	bh=hjykvtfPCBTn5yC0aRLHAo/q7C7vodCfud4xCwWCXpM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CWWnVD07WrAjhqolbF8u+bM1EAAmTxFyyizz4endKztsZVBfrDbTOHMoXgUzBVk0JN9bT7bEbnNrkdNKVgmZI73k1FhIN7f8lP7SvlZ/GdGfwczFunrL5Pmx/io4wCOvRU/zcj0+KlT+DWniI8I7Amu2p53EeDF9Q5qAe2hRGX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=OXx9GcAb; arc=fail smtp.client-ip=40.107.21.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="OXx9GcAb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tj4km9dUq+X6syuVzLJ6q/Sxr6oXGoVGmw+acYTtTjDf/xMkDvEZYrqYb0GVFQ8k3VfLsiBRnU48LEKw9zdL2XYQ3ZZXwUS0tBH3SvKE81fyhmsoDpto0BsvyNEc4Ou19W1iYl65tSk8vbTgKGYPKfHaAvCaSt9ZHaggkqhAp3OIFXX0n9NmIVVKjxzXdsz/Bvl4XdiDp/zKBxVmHyDjG+JFP9PA5f0m4szCU8owqoDWlW5np9M3kuIstJpToArxaEWD8uuZcjyPA3dOGfZdb9WNAbKhOCitTvWWQ0/du3sv4EJ0eM+oH5bVBrxJmBNLgW6w8owXuXF3I1eddHRN6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjykvtfPCBTn5yC0aRLHAo/q7C7vodCfud4xCwWCXpM=;
 b=FLVgQnpfAyStbkfJCrktQwnRwE8Egw6gSzJpTlr2ZmAPKgCsy/OCu5E6gFVdWu9CNxxOtvWUThcvpjCrjoOGnZsUyY/S2h5FHJQLaDezfBwgqK/x7dSy99TPZxqmGEbxKMeBLDAXiw67mPnvFSxweetbj9/5mms4YWG8dwbMCpOSlCfdXqh8URR/6nsEcNjIHN4XgEdlOvSktme2dBC37HmKIdW/KCn0zA61dL/AJgYLaWtlfyWYkFHwmNr64NHPMRiN3HZUo8ZZ/KKTJm/xzroxNHaYSpeQ28M8JCpzJ6D9EzLmqyybtbxaXC7Xr3bCch/G4b0YR0b8yIIKdtkkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjykvtfPCBTn5yC0aRLHAo/q7C7vodCfud4xCwWCXpM=;
 b=OXx9GcAbS1oFDeHcVkECzksqMbRt7RR+gIBWb6C/a14rl9xA3MynskV7cpln8n9smoPqaxFh99OzLPa68tk/pVIxOLNAJhVzxjRqHwjYrtGbVAHAoF/HyVd1DQ4AREFZh2JhzqOIBZwrAeZ8UPU8+zM8g6+x3pRUJxr6f2M2gW1y/AFTRycAkNWEyDh+reWsAN4G1ZKNEdKqmH53Vjch/6K2kMNZEdYXQEy+Bb3PSQKJVKWoePBFDjXSw5SfQ+Pjqx6LwGAng1vpV3BXCsQqb3J1pt/m8iAdXxPE28vD3HZyfzsdr3kEahWOjwi/oP0hdn7dN6eVWC5V9KBQgubZsg==
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com (2603:10a6:20b:5a2::12)
 by DU0PR03MB8413.eurprd03.prod.outlook.com (2603:10a6:10:3bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Tue, 4 Feb
 2025 14:11:00 +0000
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803]) by AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 14:11:00 +0000
From: Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>
To: Marc Zyngier <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Volodymyr Babchuk
	<Volodymyr_Babchuk@epam.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/3] KVM: arm64: timer: Correctly handle EL1 timer
 emulation when !FEAT_ECV
Thread-Topic: [PATCH 2/3] KVM: arm64: timer: Correctly handle EL1 timer
 emulation when !FEAT_ECV
Thread-Index: AQHbcaAooelTFY18DE2dHhL8CAmbPbM3OfkA
Date: Tue, 4 Feb 2025 14:10:59 +0000
Message-ID: <f0377538-885b-411f-9572-95429c0fe58c@epam.com>
References: <20250128161721.3279927-1-maz@kernel.org>
 <20250128161721.3279927-3-maz@kernel.org>
In-Reply-To: <20250128161721.3279927-3-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR03MB9438:EE_|DU0PR03MB8413:EE_
x-ms-office365-filtering-correlation-id: c486f7b4-7f83-4b44-a2d7-08dd4525bfe6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dXYzRHhORXRBc0RIeFB2VVh6UlE1VjhMbjZnWXZJUzVtWHA0NzRMZlJGcFZi?=
 =?utf-8?B?MU1aSk9pMlpiY0VWTnR3TVFUOTJNdlpCb2R1N0FMRG10SnpaaElUbG1VZUVk?=
 =?utf-8?B?cjU5NjBucng3RWJUTkw3NlFIWjJxN0ZPUUZiNFpHYmRLM2dnN2hWRTJrcWFS?=
 =?utf-8?B?MmZ5cXJ6MmxpMTNjV1lBWmR2YjYvTTJGaUlzVHY0UWtodFo4QlBxdjZkRkVW?=
 =?utf-8?B?VUxLbkFqU3QwSUNSQThFM0JMT0pIMWdvMnYwSXJxTjM3T3RSa1FHdTRTNk5K?=
 =?utf-8?B?N1VyR1o3MzA1WkxSS3c3TWVtZHNqY3RzNDdlMmcvaW1vSTUzSmNFNmtOVENx?=
 =?utf-8?B?aExDK2JvOG9yOXpqa0hJeTFGT0VnVkRzcWZvdldHMGFYcmJOcUxsMjFMc0Q0?=
 =?utf-8?B?cmNPOU05cFF6MDVMNnlOQmh0bkx0WUxNMGdjQjRDVU44Q1Z4UlJGRUU2eWNo?=
 =?utf-8?B?bG5VZDM0NlpzNVVMbDhkWUJvOUNua29IZ0V4RGtSM2F2dDI1OGY2OExtNTkz?=
 =?utf-8?B?VU03TVM3R1lOeG1Sc1cxZGh6QVBsRlgrMk9uNG9WVm1rTVdjTkFKZEZXb1BH?=
 =?utf-8?B?TURJRmd1N1ZrN2ZKWFRDNFBBYjV2L1F2RGwvbGI3MWg4clQyRlRha1ZjWGUx?=
 =?utf-8?B?bVJrL1d6SWdNb1lyQVVkZ3R1T3lzVUpZNm82RkRxVGtQQ09tSVZrcUFlcmk5?=
 =?utf-8?B?MnhGOXVyM0poY1VKVXlCRk9qaThCNVk3d1N0YlNMYml6MzErYzBpY1hJdTFM?=
 =?utf-8?B?eGtTWGZJZ2lGaXdrQU9XZHhBZG4vaEdtTTdNbmYvcVQ5V0Q2ZHk3anc2TDBj?=
 =?utf-8?B?ckFCTzJ0RjFtbDRNQmZBZ1pQbnQzM2Q1THJQWHVvY0ltWTc2a2IrcURCSHAw?=
 =?utf-8?B?SVMxaFBGNEI4NVdXZnRwOWlveEx2TlN1eUlmN3pKVlNyWXZLV0lSemNUNCt1?=
 =?utf-8?B?eWhBQWxKR295Q2t5b1V4eGVLQzUvdXlNVDJiY1kyNlFEdUtsU3Fxa2FmbUli?=
 =?utf-8?B?OTRZeGlsNzhsTjFmK2lnTHRndzVGblBSSzUxNGwxUU56QWZRQ3BISXFOVWhG?=
 =?utf-8?B?M09pQmtqVXh2SnFmUFEyanZJbGluNHNmMVphL1R2MVpYVlZXaWlrdUdZK1gz?=
 =?utf-8?B?V05iNHltTWVOTTR1T0V4NkNDSWM3YnUxOUFjSVovRlF6ZHRwRStjWDFsY1Fk?=
 =?utf-8?B?R2MzelRiZzdpWWNXaFlqSXhoVm9tbWUwbTB6RDg2bHlTWmtQeFl2eDd3bTJN?=
 =?utf-8?B?YUtWT0JWNkhBKzNIM2dZSWdQeElKa0plUjAvY1p3cmVFTUFESGpGeFZZa2Nu?=
 =?utf-8?B?TUZVYkY0eTlEclV1RTdPRGZyZjhRblJlZWVKQmhFMkNHM3VHQ2VtOGRNbEF5?=
 =?utf-8?B?TkEwV0Q2bTlJQWo4WDJYQkphMjNEaTlBaHQ2dE05N2dhbWw0QU91V1lkazZW?=
 =?utf-8?B?eWt2Z2VOTjdXajBwSkZMUWFMdFFSZGJzNnpmNEwveXJOREt0M1Z6elhFQUJK?=
 =?utf-8?B?S0JtSGViNXZTaERaVGJWd1lrSngwSTNWVm80bk9wVWxRVFVIRnpuSmpibjFz?=
 =?utf-8?B?Y0JtZysvMUJTTkdiKzFseURpcFlIUEwyTVRoVkd6d29SUVRmU0tQUjQzOEVQ?=
 =?utf-8?B?QVAyWWpZVkFJRkhYQnhPL3dybTdmcGNNZ2FrbG1GOENEWWR5d2htZU8vZ1pZ?=
 =?utf-8?B?R3QzTzBacUpqNFFycDBZaXZVYkRXajJDRUNWai85OXdqcGZsdWFtVW5MOEtm?=
 =?utf-8?B?NUV3NW1WaTJacFluRjRITzZhTytTb3hESytIOFlwNnZPNFIyRUtaTXRRV2JE?=
 =?utf-8?B?QVl6N2R2enlDTTRUQVJCWTlWUzJ4bDcybm1PdEVaMndnRzBIb3NHdnpzRTYx?=
 =?utf-8?B?Q0I0S3k5NXIrQThQUGswanJGOTNtVkZVVEk2dmkydU5JUEE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB9438.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T3hHQnpIbnJLdTB4ZVlGTlUyM05pUzUwbnJFaUNUZ2o3eXVjdW12eGkrTkw3?=
 =?utf-8?B?bVRTSTFTSFJIY3dROHhZUTdvdHdKeHFUM0R6ZmZDdmh1MnNjTmRwais4emhr?=
 =?utf-8?B?TXQvTnB4bUx4dTczOEd5ZDVPYXRadzdEVGdZaDZ1dysrcEVhRXlRVVhRQVVM?=
 =?utf-8?B?SENROVBWdGh0eXYyS0hybWxtMGhHQy94YXlhTzVoYXgzbHRENUVYUzlkMlFG?=
 =?utf-8?B?dkhiSDdkVHg3OXg2cGNrZ2I0dWhIaStpcUorSUdhUzZzRFN4bjFkWlgxdDFi?=
 =?utf-8?B?d0liTmFLSS9UOE5VUFY3cnFQdW9vemM0b2Nzd0dOMEVSaHJIMG1na0E3NGpK?=
 =?utf-8?B?NndPdmMzUnFOVFc4YjlyNHQ4aUg2eEtTSC9oNkxUcXFOei81UHhuNThyQUZk?=
 =?utf-8?B?ZEErVEtHL1dBNWtVWnF2dnVHREFDSGZNb0I3cjZxU0h3NFNaR0hVZklrSEU5?=
 =?utf-8?B?MFZYZVF6OHVDUUNsTDExM0V6Z0hPRkpQTlBjTGp3clkrcXVGS1dXeVF0WFFl?=
 =?utf-8?B?alFkUzF0RnA1cU1MNlpQS1g0c0Qxb0dvYlVOTE9ZK242ZC9WeXJWNW9hSUF5?=
 =?utf-8?B?TzZFSmRvODU5QWlpVldGcFpmYzJGQ0FtWkRobUt4N0p0VU5qYzY4UWFTclpL?=
 =?utf-8?B?UWxXaDJiWnNFRjZrQUZzb0YwdHdWdENTWmRlcGgyeWRMbXZsLzFPRVJON29I?=
 =?utf-8?B?TzdpTkxzMm00Q3V0dEovblhGdzc1bldOMVFXVTNzckcyU2U0NkNBZUR3VE5k?=
 =?utf-8?B?NFZCOE1Gc0trd1RwNVQ2NERwdmxXM0tqa2VCN2JiMmpId3RtS2RvYjMxS1Mz?=
 =?utf-8?B?ajZMcFVnUHNkVlp5c0IrVDQza0k4L1B6bzE5OURqaXlrRjNrWUJ6T0dBcnFn?=
 =?utf-8?B?SW15YWw1VWdpd3RQU2JwVDBYOWNhcVBzNXZNdGhTajNyZHExVm9uNkNiVjdC?=
 =?utf-8?B?SEtsM3grdVhjc0tsOG5TanZNdkpQV0V6c2h6cW52TElHT0hXN2drVmhDbUxX?=
 =?utf-8?B?U2diU2VXTTBKTE5EZFpWYldXQlZrcEpKYjdYWXdpcXJCV1RoSno1TU42Mys2?=
 =?utf-8?B?Ukp3VHFzVUhXTWVGcVljcmRqTThHbVcrUlJjWk9yOXRPZHR0dG9DUEdmSnNR?=
 =?utf-8?B?NnF1TEVNZExyRlNZMzJjZnFSMGthVkNGNUtQT2dubTlGb1cvWTFuRGd2dGY0?=
 =?utf-8?B?VXNLdnA4VzNmNUo2a0NIb3B1Q3dYaUF1WEZETndPcEhVa1ZUY3M0c3V6d21s?=
 =?utf-8?B?S0tFMVkyd3o3Qi9VS0dldzI1UkJpclM2V000bnNtWjB0SDRDOW5WV2xGTGVw?=
 =?utf-8?B?OVNIODJKL05jYWdDemhJQ2w5aUNHcVVjNHVDVnRlUkxXZmdSb3pKc2tBaytx?=
 =?utf-8?B?UXVlTEtxTDVmbWVHMjlxV0dwY0xxMDZmcnRsczVIbVR2WDc0MFpESDVGUzQ3?=
 =?utf-8?B?blNEQTVaRlZLNVc5ZVdYSVIwbXlDemIyRlNMVUZvTFQ3TlIzcWJSUXVWMmow?=
 =?utf-8?B?S3dDc1ovY05TcUU4U25IcWttcGllbXE1ZWdWUTJTbUxGVEFkWkI1YndTZVlo?=
 =?utf-8?B?MUF1cjNpWmQrTjZGZlVBcjZBa3FHbWh2Wm9FWTJsWFg1NEpySUtCekFwZkU1?=
 =?utf-8?B?WVc5QkdmZFU4YUNVeFNEVHlpRVBiRnFYQUhjRTJTSUIxcVZKTjQ2ZkFKYkE5?=
 =?utf-8?B?am4rRjdqcGRBSDVKNllUcFNSMVJuUy91WmVETW53SFdFZ0l5VDFWVHcwQWhI?=
 =?utf-8?B?cG54bXcyT0pGQVlaLzlBc25uYTAyTUVGS0hWUGo5OFZ6Nmo1b0piWCtwU1FL?=
 =?utf-8?B?eE5iVVZsMUVQWU9scnkyOS9TUjBQKzVSWlFzSS94OVJrb0c1bU9VSnhpRkhl?=
 =?utf-8?B?R1ZJaUJPY04yMS83cE8vVTNBaTBWTnhnbi85c2FFbnFidi9qQ0p2Si8wbXpW?=
 =?utf-8?B?V2JlV0dyUGRmbDJwdFFrZDJiUmJVbWlBejBRT0hWM1ptVmg5RmxGUFJzd1VJ?=
 =?utf-8?B?WDVTdDlNSWtUR2xXYzdnVkdsRi9ESXhiTzBkME04SGZXT3VBQmNxNTNuaGdL?=
 =?utf-8?B?Qzlzd3RReGQ1STkxaVoxeGNPb1JiZmtTMXU4V2FvemhGMDhhYkhVdDkxZ0RX?=
 =?utf-8?B?SE81eUVlb3FySnRTS212MlV4SEt6Q1psdUZHd3E2R1lFU3NDb3A4Q0I2Z240?=
 =?utf-8?B?Wnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9817832006C4B140BBB81DE5214818EA@eurprd03.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c486f7b4-7f83-4b44-a2d7-08dd4525bfe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2025 14:10:59.1685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h+1ulm8bDajeR9qwT8OnAziTn2AnDFiFQuEuQvDQ1ED6zl21TYGzqSiL8vZw+i4GOA6Au/yJnuE6CCJPJJR10SmktaZPWttnPmJV7B9C4dI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8413

SGVsbG8sIE1hcmMuDQoNCk9uIDEvMjgvMjUgMTg6MTcsIE1hcmMgWnluZ2llciB3cm90ZToNCj4g
Qm90aCBXZWktTGluIENoYW5nIGFuZCBWb2xvZHlteXIgQmFiY2h1ayByZXBvcnQgdGhhdCB0aGUg
d2F5IHdlDQo+IGhhbmRsZSB0aGUgZW11bGF0aW9uIG9mIEVMMSB0aW1lcnMgd2l0aCBOViBpcyBj
b21wbGV0ZWx5IHdyb25nLA0KPiBzcGVjaWFsbHkgaW4gdGhlIGNhc2Ugb2YgSENSX0VMMi5FMkg9
PTAuDQo+DQo+IFRoZXJlIGFyZSB0aHJlZSBwcm9ibGVtcyBpbiBhYm91dCBhcyBtYW55IGxpbmVz
IG9mIGNvZGU6DQo+DQo+IC0gV2l0aCBFMkg9PTAsIHRoZSBFTDEgdGltZXJzIGFyZSBvdmVyd3Jp
dHRlbiB3aXRoIHRoZSBFTDEgc3RhdGUsDQo+ICAgIHdoaWxlIHRoZXkgc2hvdWxkIGFjdHVhbGx5
IGNvbnRhaW4gdGhlIEVMMiBzdGF0ZSAoYXMgcGVyIHRoZSB0aW1lcg0KPiAgICBtYXApDQo+DQo+
IC0gV2l0aCBFMkg9PTEsIHdlIHJ1biB0aGUgZnVsbCBFTDEgdGltZXIgZW11bGF0aW9uIGV2ZW4g
d2hlbiBFQ1YNCj4gICAgaXMgcHJlc2VudCwgaGlkaW5nIGEgYnVnIGluIHRpbWVyX2VtdWxhdGUo
KSAoc2VlIHByZXZpb3VzIHBhdGNoKQ0KPg0KPiAtIFRoZSBjb21tZW50cyBhcmUgYWN0aXZlbHkg
bWlzbGVhZGluZywgYW5kIHNheSBhbGwgdGhlIHdyb25nIHRoaW5ncy4NCj4NCj4gVGhpcyBpcyBv
bmx5IGF0dHJpYnV0YWJsZSB0byB0aGUgY29kZSBoYXZpbmcgYmVlbiBpbml0aWFsbHkgd3JpdHRl
bg0KPiBmb3IgRkVBVF9OViwgaGFja2VkIHVwIHRvIGhhbmRsZSBGRUFUX05WMiAqaW4gcGFyYWxs
ZWwqLCBhbmQgdmFndWVseQ0KPiBoYWNrZWQgYWdhaW4gdG8gYmUgRkVBVF9OVjIgb25seS4gT2gs
IGFuZCB5b3VycyB0cnVseSBiZWluZyBhIGdvbGQNCj4gcGxhdGVkIGlkaW90Lg0KPg0KPiBUaGUg
Zml4IGlzIG9idmlvdXM6IGp1c3QgZGVsZXRlIG1vc3Qgb2YgdGhlIEUySD09MCBjb2RlLCBoYXZl
IGEgdW5pZmllZA0KPiBoYW5kbGluZyBvZiB0aGUgdGltZXJzIChiZWNhdXNlIHRoZXkgcmVhbGx5
IGFyZSBFMkggYWdub3N0aWMpLCBhbmQNCj4gbWFrZSBzdXJlIHdlIGRvbid0IGV4ZWN1dGUgYW55
IG9mIHRoYXQgd2hlbiBGRUFUX0VDViBpcyBwcmVzZW50Lg0KPg0KPiBGaXhlczogNGJhZDMwNjhj
ZmE5ZiAoIktWTTogYXJtNjQ6IG52OiBTeW5jIG5lc3RlZCB0aW1lciBzdGF0ZSB3aXRoIEZFQVRf
TlYyIikNCj4gUmVwb3J0ZWQtYnk6IFdlaS1MaW4gQ2hhbmcgPHIwOTkyMjExN0Bjc2llLm50dS5l
ZHUudHc+DQo+IFJlcG9ydGVkLWJ5OiBWb2xvZHlteXIgQmFiY2h1ayA8Vm9sb2R5bXlyX0JhYmNo
dWtAZXBhbS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+DQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvZnFpcWZqendwZ2J6ZHRvdXUy
cHdxbHU3bGxobmY1bG15NGh6djV2bzZwaDR2M3Z5bHNAamRjZnkzZmpqYzVrDQo+IExpbms6IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvODdmcmw1MXRzZS5mc2ZAZXBhbS5jb20NCg0KDQpUZXN0
ZWQtYnk6IERteXRybyBUZXJsZXRza3lpIDxkbXl0cm9fdGVybGV0c2t5aUBlcGFtLmNvbT4NCg0K
DQo+IC0tLQ0KPiAgIGFyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYyB8IDMwICsrKysrKysrKyst
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCsp
LCAyMCBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FyY2hf
dGltZXIuYyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KPiBpbmRleCAwMzVlNDNmNWQ0
ZjlhLi5lNTk4MzZlMDI2MGNmIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9hcmNoX3Rp
bWVyLmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jDQo+IEBAIC05NzQsMzEg
Kzk3NCwyMSBAQCB2b2lkIGt2bV90aW1lcl9zeW5jX25lc3RlZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpDQo+ICAgCSAqIHdoaWNoIGFsbG93cyB0cmFwcGluZyBvZiB0aGUgdGltZXIgcmVnaXN0ZXJz
IGV2ZW4gd2l0aCBOVjIuDQo+ICAgCSAqIFN0aWxsLCB0aGlzIGlzIHN0aWxsIHdvcnNlIHRoYW4g
RkVBVF9OViBvbiBpdHMgb3duLiBNZWguDQo+ICAgCSAqLw0KPiAtCWlmICghdmNwdV9lbDJfZTJo
X2lzX3NldCh2Y3B1KSkgew0KPiAtCQlpZiAoY3B1c19oYXZlX2ZpbmFsX2NhcChBUk02NF9IQVNf
RUNWKSkNCj4gLQkJCXJldHVybjsNCj4gLQ0KPiAtCQkvKg0KPiAtCQkgKiBBIG5vbi1WSEUgZ3Vl
c3QgaHlwZXJ2aXNvciBkb2Vzbid0IGhhdmUgYW55IGRpcmVjdCBhY2Nlc3MNCj4gLQkJICogdG8g
aXRzIHRpbWVyczogdGhlIEVMMiByZWdpc3RlcnMgdHJhcCAoYW5kIHRoZSBIVyBpcw0KPiAtCQkg
KiBmdWxseSBlbXVsYXRlZCksIHdoaWxlIHRoZSBFTDAgcmVnaXN0ZXJzIGFjY2VzcyBtZW1vcnkN
Cj4gLQkJICogZGVzcGl0ZSB0aGUgYWNjZXNzIGJlaW5nIG5vdGlvbmFsbHkgZGlyZWN0LiBCb28u
DQo+IC0JCSAqDQo+IC0JCSAqIFdlIHVwZGF0ZSB0aGUgaGFyZHdhcmUgdGltZXIgcmVnaXN0ZXJz
IHdpdGggdGhlDQo+IC0JCSAqIGxhdGVzdCB2YWx1ZSB3cml0dGVuIGJ5IHRoZSBndWVzdCB0byB0
aGUgVk5DUiBwYWdlDQo+IC0JCSAqIGFuZCBsZXQgdGhlIGhhcmR3YXJlIHRha2UgY2FyZSBvZiB0
aGUgcmVzdC4NCj4gLQkJICovDQo+IC0JCXdyaXRlX3N5c3JlZ19lbDAoX192Y3B1X3N5c19yZWco
dmNwdSwgQ05UVl9DVExfRUwwKSwgIFNZU19DTlRWX0NUTCk7DQo+IC0JCXdyaXRlX3N5c3JlZ19l
bDAoX192Y3B1X3N5c19yZWcodmNwdSwgQ05UVl9DVkFMX0VMMCksIFNZU19DTlRWX0NWQUwpOw0K
PiAtCQl3cml0ZV9zeXNyZWdfZWwwKF9fdmNwdV9zeXNfcmVnKHZjcHUsIENOVFBfQ1RMX0VMMCks
ICBTWVNfQ05UUF9DVEwpOw0KPiAtCQl3cml0ZV9zeXNyZWdfZWwwKF9fdmNwdV9zeXNfcmVnKHZj
cHUsIENOVFBfQ1ZBTF9FTDApLCBTWVNfQ05UUF9DVkFMKTsNCj4gLQl9IGVsc2Ugew0KPiArCWlm
ICghY3B1c19oYXZlX2ZpbmFsX2NhcChBUk02NF9IQVNfRUNWKSkgew0KPiAgIAkJLyoNCj4gICAJ
CSAqIEZvciBhIFZIRSBndWVzdCBoeXBlcnZpc29yLCB0aGUgRUwyIHN0YXRlIGlzIGRpcmVjdGx5
DQo+IC0JCSAqIHN0b3JlZCBpbiB0aGUgaG9zdCBFTDEgdGltZXJzLCB3aGlsZSB0aGUgZW11bGF0
ZWQgRUwwDQo+ICsJCSAqIHN0b3JlZCBpbiB0aGUgaG9zdCBFTDEgdGltZXJzLCB3aGlsZSB0aGUg
ZW11bGF0ZWQgRUwxDQo+ICAgCQkgKiBzdGF0ZSBpcyBzdG9yZWQgaW4gdGhlIFZOQ1IgcGFnZS4g
VGhlIGxhdHRlciBjb3VsZCBoYXZlDQo+ICAgCQkgKiBiZWVuIHVwZGF0ZWQgYmVoaW5kIG91ciBi
YWNrLCBhbmQgd2UgbXVzdCByZXNldCB0aGUNCj4gICAJCSAqIGVtdWxhdGlvbiBvZiB0aGUgdGlt
ZXJzLg0KPiArCQkgKg0KPiArCQkgKiBBIG5vbi1WSEUgZ3Vlc3QgaHlwZXJ2aXNvciBkb2Vzbid0
IGhhdmUgYW55IGRpcmVjdCBhY2Nlc3MNCj4gKwkJICogdG8gaXRzIHRpbWVyczogdGhlIEVMMiBy
ZWdpc3RlcnMgdHJhcCBkZXNwaXRlIGJlaW5nDQo+ICsJCSAqIG5vdGlvbmFsbHkgZGlyZWN0ICh3
ZSB1c2UgdGhlIEVMMSBIVywgYXMgZm9yIFZIRSksIHdoaWxlDQo+ICsJCSAqIHRoZSBFTDEgcmVn
aXN0ZXJzIGFjY2VzcyBtZW1vcnkuDQo+ICsJCSAqDQo+ICsJCSAqIEluIGJvdGggY2FzZXMsIHBy
b2Nlc3MgdGhlIGVtdWxhdGVkIHRpbWVycyBvbiBlYWNoIGd1ZXN0DQo+ICsJCSAqIGV4aXQuIEJv
by4NCj4gICAJCSAqLw0KPiAgIAkJc3RydWN0IHRpbWVyX21hcCBtYXA7DQo+ICAgCQlnZXRfdGlt
ZXJfbWFwKHZjcHUsICZtYXApOw==
