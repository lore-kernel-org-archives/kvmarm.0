Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012012.outbound.protection.outlook.com [52.103.14.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBF8393DE6;
	Wed, 23 Sep 2026 18:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.14.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188612; cv=fail; b=msDB5K33uLN7cnzoujFHJ94kYAIJYbNujgfCHw88Eur++s/1eSZu8qEOXxlaZklUME2k3xMU+Yol56tFe/dlVzQ+WptKBAZmr8ciIOSziA4IziQ9oLWzPogROnu1FAGZFaR/WL7qsK/cs0QCzAPQbPuOItzWlUEpRFiiV98y26k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188612; c=relaxed/simple;
	bh=azluML+L/THkKQd0Bo22pEK1BeWUUaGMc56rYHaWyeQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rJKPeVycBCd7g9+b7WaiRsU9MWEerM/X71yVApK+eyTV7D9Hh5YPiA8Mz+YUg9ww6GONmUoIZcQbr0fY6ahVz1YD3GYq4z99ch9qRFv3zlgIkEUeTZcHg3T8ErXl+V1LPfhi9I+MJ9AVSGb0ZnjJ5jJWyTK0zMroHq927PlQ1iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Tq0+BtKV; arc=fail smtp.client-ip=52.103.14.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Tq0+BtKV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0lOEUBNjOfRAPwT1ujf3YBo1DdL8Is2qCPniCavHKbw9iT/Bn+29Ihrxjccv0NMiPXIpivmKXygWGrfSqJaem753sfBhNCDU9ojnRJCrLTMRbWtcOt1+8eCcmMl6pA1Y0ADKRhUerIRcfV4miZzw5Pwu0aAN05f9phPRyhd53z79RHM8EY6yMgf2gGwD9dIlTyc2PEZwwzDxkpeavlRXZTx/qgyL6P5ZlfryntxEGO6R9Cfe7TQY+p4/fGGrglZAury6MdQGM/em7PFYmXCpTttej7u4p8bsZTrrXKCHm93mbBHhyLf358F7Ko/tITus8mgf/cnCuhOigrQHp2enA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azluML+L/THkKQd0Bo22pEK1BeWUUaGMc56rYHaWyeQ=;
 b=fxNnJj0lJYiL1bSYHurt/BC4FFRowbrS5Rzvbd0piZNTia0bE2XSd9mEQjt9z2sFgBxP1DfT04DQrMRYPtDOErdywo5l3cfQSr2BdlKi+XNMbygW8sEoNCTzjF1Z/puCJkGy665aRT62msDLdzFFTxJM2pzrsrXSTo32HZoCZJLWLkxRBubgW9gabhZ00Aso9T9pMnHV/AKFR3Fq2tVzx26vkcY4IFVHXbamD2EP7J7WduPzCQcBY3kYBeYKpw34OWflLa6Tz8/medQmpqPojOdsWuAa+0GOW5M+CpHYiip5/iMrKo/R/Qr4KEZCut2qnuOH6lDaN3G9QteckXEqgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azluML+L/THkKQd0Bo22pEK1BeWUUaGMc56rYHaWyeQ=;
 b=Tq0+BtKVhsC+i2XXRLaod0YLFT2rXQnuwDchpUJ3964gA1qFrb3BEAEsGeLNWiKy+zvJVLA5ylKz0H5S8vlvtSk5dp5muw8ne/ouY4DLH9RGIPHOS3VIG9lkxIIlULTyA3YEkJ1rUHTTpYuL2n1QafnTorfVx/n0jt8H/GoRhokbpEs4zXYQroisAXUnEE5RYSjvvVAnAhjfJavJhsHv0NIKojUYwKlXHn7GBYHYbdGjiAWIqmOoE+m+fcG/mrRH7IXBKDVJbRljjiur9lyadDsx+5kA9pr05TV7CMI87vHqsTneHCpRUq3dnw2NFpMqrusZls8IMI1SXl5vpsEG4Q==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by BL3PR02MB8186.namprd02.prod.outlook.com (2603:10b6:208:339::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 18:36:46 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%5]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 18:36:46 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Kameron Carr <kameroncarr@linux.microsoft.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Michael Kelley
	<mhklinux@outlook.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>, Joerg Roedel
	<joro@8bytes.org>, Marc Zyngier <maz@kernel.org>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Steven Price
	<steven.price@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Thomas Gleixner <tglx@kernel.org>, Will
 Deacon <will@kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Thread-Topic: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Thread-Index:
 AQItt+sf4ibi8Dao6KrPcVgruF+ONwI+uxT+AmeiYiACor7ERwGgpMoeAdaSfxICc2LzjwKbJ9sTAiUWR5oCj2EHzbWXZrwAgAAjsVA=
Date: Wed, 23 Sep 2026 18:36:46 +0000
Message-ID:
 <SN6PR02MB4157EF24550B893D2109B138D4822@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org> <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org> <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org> <arOspFxWZ1DjgcAr@arm.com>
 <20260923130611.GF1540250@ziepe.ca> <yq5atsng10b2.fsf@kernel.org>
 <20260923152124.GG1540250@ziepe.ca>
 <5cbe0bde-47d8-41ca-b244-bc0329d0d066@linux.microsoft.com>
In-Reply-To: <5cbe0bde-47d8-41ca-b244-bc0329d0d066@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|BL3PR02MB8186:EE_
x-ms-office365-filtering-correlation-id: 39b3be55-86da-4a84-9cd8-08df19a19f50
x-microsoft-antispam:
 BCL:0;ARA:14566002|55001999006|24021099003|41001999006|37011999003|15080799012|13091999003|8060799015|8062599012|51005399006|19110799012|31061999003|25010399006|4140399003|40105399003|12091999003|1602099012|10035399007|2607281247196008|102099032|3412199025|440099028|4302099013|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?bUVaQUdTUGxzdG51azEwSVRacTFtZmkxWGozeVRmVHhrYXVVb2R4VDhyUXE4?=
 =?utf-8?B?eGR1eElKY0pUb1ZsczdlR05uRkxmSU1VUDZVUW4vdVFqUDJKTHdEK0M5eUJL?=
 =?utf-8?B?cFpiWXk4aUFndjFOd3ExdmFmbHA1Z3lXYmdBbmtVR0J3VWQyZ09zaUEwZmVO?=
 =?utf-8?B?MUR3YmRVSk85a2MvVC9wWkRacG5XYUd0bXRJWml6eXFkZEtZVUVOYTViZStT?=
 =?utf-8?B?ZE5mcDZDNytnYUtaSENxWmcyRlJOSHNyVHpBajR5TTMyVWgwZXBhWHZSdXJw?=
 =?utf-8?B?aHErZG1MMzBNMVdmYlhOUVBITno1NGl2T0FxZ0tjazBJMjV1b2lEOHB5TkZt?=
 =?utf-8?B?dkZ0YXZDUVZsbHZabVVvbzVzaGlMSFUvUGIyZVJyaEh5Yjl0bW5rM3NYQy9Z?=
 =?utf-8?B?SDdUU0dveEloS2M0aHhLcmVHbmUzNUo0V2JMQlhYcWdvSW1saGY0R05IQ0ww?=
 =?utf-8?B?cXF4WnUyZVNZOTJ0UlJRekZuYy80VHIwcUgzYUl2dWtYSE50b0JiVFdsZXlQ?=
 =?utf-8?B?Yy8rdC9RRmhlQ1Jqb1VXRnFvR01LdXR5Y1BiWWh5Y2s1MlpySGlIOFNOd3My?=
 =?utf-8?B?YnIwK1dDTVJKRVZ1eDNGek4vUjZGUC9qWkcyZGlhRTZkYmJyclFjd3hkclpi?=
 =?utf-8?B?OG9HSWFWT2tLaUpjZ2pWeEIzYm1FYS95dlhFQVNqdHBFbGxxZzQ4N3RvUSsv?=
 =?utf-8?B?VEtMeG1zVENzK3liU1MrbWlHVnVlNnowMy9saUFWTFY0NkRBajF2cllldXFi?=
 =?utf-8?B?QVBjdXpUZkhqZ0MzRmZEVFdmQS9BQmplOHpxRXJFcmNYTENqTEQ1VFFDM3RF?=
 =?utf-8?B?UmxQUmp1ZDJ4Uk9VTlIwTGJRVUZjeGpIQ3dUMkhoTTZEL2xhRUdkTSs4aUd0?=
 =?utf-8?B?MU15Vnk4cUswdFNOeTAvYll1WnJKU1RDNXNZSEFxUlU4VUcyalBOZjlmSVJ4?=
 =?utf-8?B?Q3FvcC9VVTlXamJvaExYY0N1ZlNUSnRmQzdLRXIyUmZEWmdONHhWSG01VmFS?=
 =?utf-8?B?VkVoNlJQeTNiR1kzYVVIVGpHTWhUNXhpVStlbWloYmFSM2l4Q1BycXJjcmta?=
 =?utf-8?B?NG5jbnlVSUtydnZ6N1BvVVNSNjdnQld0T3VGbTRtdEZiQ0UwSWtuQ3RUV05K?=
 =?utf-8?B?elgza0ZKTHYrOHgwZFFIbkFDODByMEhZaS90TEZQaEg2NEhFdlI4dEFYbVNR?=
 =?utf-8?B?dzFlRHNxTHdmL29jc3Q1cXhMZi9pSTkreE0wSWJHVDhPaEtYaUN3OFN6NlZZ?=
 =?utf-8?B?QjQ3MFdXbm1Va2JyRHZzcStaSm1UKzhWT21EZnROcWdGMjdIMEpMT3VVUStL?=
 =?utf-8?B?V2g3Q2pWQnRZVjFtQmVxRFBvLzE4cHlPMmZ6Z2Z0V1VmSTYxbkhGN2lrZWxO?=
 =?utf-8?B?MzBLSUJyQml5VHMwYVBmbU5FdENWNVQxK1FQVmc0VHdwb1FFNFFqS2pHL3Nm?=
 =?utf-8?B?dEZ5eGtRN1FxQU0wTW1aKzFzbzYxWWdXTTc4THcxWG03T1NoK0FwUTBoOGtF?=
 =?utf-8?B?dFRHV1hkRWVhRWlVZ1pqaDFPSUNNSTB3SWpUQ0hoK1V3bVFkRTJCdC96bzdm?=
 =?utf-8?Q?rnopPl9Uh7xS/a1gzbcSlfIJ8=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUVFNXhvaXlFRDJEYWVyWnppMjFsQmNtR0tuWFVYNndLbW13WFVpNVRMWUM0?=
 =?utf-8?B?akZma1FEZFFpMnZteXcrdGoyYU1TcFo3cGplbGlPV1gyQmRSRStFMDlMQ00x?=
 =?utf-8?B?ejRxQUx6VlF2Z2JCSjVwaUFLUzBLSUJPRUpJdU9UT2pQanRDeEZ6STJWeVpK?=
 =?utf-8?B?ZU1GL1dEc0gxRmdIVnNTTkpyTDZTMDc3WWtUeDdmZXM1endRbGxhL1haMVZt?=
 =?utf-8?B?YWpHdWU2bG1BcURCMFFtREhvVWg1U3dkTm1md0NQT1Q5YVk0SGNMM0UzZzJN?=
 =?utf-8?B?OElMU0ZGUWY3K2J0M0lucVdRVkI0M01XdU5KQlRMeHhXQlI2Y1c1aXRJclZN?=
 =?utf-8?B?Q0dxNFVycDRwOC8yK3AwcGRPazlycjA3akpBbmF6ak4yNDFwZ3VYYUo2ekpn?=
 =?utf-8?B?MWFyajIwd2Q0VzlYVkRPeWFtYVZMNm8wcDRESmludkYyR08zS0xyWkhjOFZs?=
 =?utf-8?B?aUxIOHZwMDdvOUFCTzlSZkZlOXVuMDR5aEpFY0pDVG9HQ0xGWW1GSjRyZThJ?=
 =?utf-8?B?Q0loN3ZUbUNBV3VzMlRENDJVUFYxMEZZbmt2dzRIc000VlBHaldlSXFMQU5G?=
 =?utf-8?B?bFhGWjR1bW03bjZhL3h1azNoUTF5b2xXTTlkb1IrM1RTV29YMk5DZU9NOExw?=
 =?utf-8?B?MG16OWNkOTdZSjh0NDBMTG1id1JybWR2SUhMais5NUlDTlJhdDhidlJ3OVdX?=
 =?utf-8?B?VEFyTHlYWUpIU0dMOFRmQ0E4SWNDdXY4NnlBUjlGWFJudkRuTlBVeDMwcHdk?=
 =?utf-8?B?cVdXcXBPZml4SDJ0ZGc0RXhlVzFPcUhwK29mTTJob1J1MWVsTTVZd2FycmZU?=
 =?utf-8?B?YmRWcEp5amFLaEphREErenZMQmtIUlRSNmJkc1c0QllkS1RBQng5eXlEQVl4?=
 =?utf-8?B?ZnpBMU56U3p0cE56MFNZQTVCVkFGdm91NHBVMGppUW13Um5WYURBVW8yWngr?=
 =?utf-8?B?aGZLS0MrYjlORzhqNzBuTTBFR1E2NzBDUG1QK0YwVkxsSGtmWWprallRaHV2?=
 =?utf-8?B?eFZUczZZV09OVE0rbDZtZUMzWlFaSFBjK1RMeGJWT2pGTHo2MURiYjY1c3Vt?=
 =?utf-8?B?N0V0VFBmYXpaZVFHY0EwNFJzQ2FvRUExVWZ5NWhBUWUvQkducWZvNHVFVGxX?=
 =?utf-8?B?dnhUY0xNNGlYOGdTZGxsWmFrTXJldjBsNTYxNzlBU1BGRjYwOE5oaUZHSHRQ?=
 =?utf-8?B?djJORmRpM2IwWDBrQnVENis0OXNscUNNRjFsbEFaNEFvbE5GTkxKNVZIajJv?=
 =?utf-8?B?NGNrMWpKekxDMzEzMzhpQ0VDMy80U0hoWlZOcmYrR01KYTA5Ri9JODF2eDVS?=
 =?utf-8?B?V1U4UHV3dVBlL2tBRXgxbkdhSUticlV2VDlXQmkvNTZudzQ3QzJDZXZwbGI4?=
 =?utf-8?B?M2VDa0RzNTMzVVYzSnZxWXBEakc3d3BLMGoyQnh1bW9nU1RiRG4vVzB5a044?=
 =?utf-8?B?Q3FyNzhZczJVWDNNblp2RzZqUGNwbStJbGdpQ3pOMGRWZGZ3cUgvVTJKNXNY?=
 =?utf-8?B?UmE1RGgrcmszcnhvcVVQM1pDWUZhUjB5aVcrSlRFMDFSejM1NWlJcExWTWFX?=
 =?utf-8?B?ZDY4SnVZTUl1U3JpQzJjWlJldXJtRkZZbGFablZjWXdLOERWQklwSCtBQ3hV?=
 =?utf-8?B?VjBvQ3ZhUm1EVzhBT2Q2TEplNEs1eXU4ekVvRGhFQW1xMnE3YUpGUFdmUlY2?=
 =?utf-8?B?Y0hNblVhakFMS3ZSVXJobU9GWTlvdGF4NWJOMHdFR3BpSGk3a29yUHR0NG14?=
 =?utf-8?B?NEZpay8zWlgyWGZZeDNyTkdnZ1ZnaWJ0M2VIYXdJZXluT2ZmMHl5dHE3aHFT?=
 =?utf-8?Q?0kzFefncJnrL0/AhQvOSEbT+zsB5ReUMibdFE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b3be55-86da-4a84-9cd8-08df19a19f50
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2026 18:36:46.2697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8186

RnJvbTogS2FtZXJvbiBDYXJyIDxrYW1lcm9uY2FyckBsaW51eC5taWNyb3NvZnQuY29tPiBTZW50
OiBXZWRuZXNkYXksIFNlcHRlbWJlciAyMywgMjAyNiA5OjI5IEFNDQo+IA0KPiBPbiA5LzIzLzIw
MjYgODoyMSBBTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+IE9uIFdlZCwgU2VwIDIzLCAy
MDI2IGF0IDA4OjI4OjU3UE0gKzA1MzAsIEFuZWVzaCBLdW1hciBLLlYgd3JvdGU6DQo+ID4NCj4g
Pj4gSSdtIGFsc28gY29uc2lkZXJpbmcgcmVxdWlyaW5nIHRoZSBhZGRyZXNzIHBhc3NlZCB0byBj
Y19tYWtlX3NoYXJlZCgpIHRvDQo+ID4+IGJlIGluIHRoZSBsaW5lYXIgbWFwLiBUaGlzIGlzIGN1
cnJlbnRseSByZXF1aXJlZCBieSBib3RoIFREWCBhbmQgQ0NBLA0KPiA+PiB3aGlsZSBBTUQgU05Q
IGFwcGVhcnMgdG8gc3VwcG9ydCB2bWFsbG9jIGFkZHJlc3Nlcy4gVGhlIG9ubHkgdXNlciBvZg0K
PiA+PiB0aGF0IHZtYWxsb2Mgc3VwcG9ydCBpcyBIeXBlci1WIFZNQnVzIEdQQURMIHNldHVwDQo+
ID4+ICh2bWJ1c19lc3RhYmxpc2hfZ3BhZGwoKSkuIEhvdyBzaG91bGQgdGhlIGdlbmVyaWMgQ29D
byBzaGFyZWQtbWVtb3J5DQo+ID4+IGFsbG9jYXRvciBoYW5kbGUgdGhpcz8NCj4gPg0KPiA+IHZt
YnVzX2VzdGFibGlzaF9ncGFkbCgpIGlzIHRoZSB0aGUgc2FtZSB3cm9uZyBhYnN0cmFjdGlvbiBh
cyB0aGUgYXJjaA0KPiA+IGNvZGUuIEdldCByaWQgb2YgaXQgYW5kIHVzZSB2bWJ1c19lc3RhYmxp
c2hfZ3BhZGxfY2FsbGVyX2RlY3J5cHRlZCgpOg0KPiA+DQo+ID4gCQlwZGF0YS0+cmVjdl9idWYg
PSB2emFsbG9jKFJFQ1ZfQlVGRkVSX1NJWkUpOw0KPiA+IAkJaWYgKCFwZGF0YS0+cmVjdl9idWYp
IHsNCj4gPiAJCQlyZXQgPSAtRU5PTUVNOw0KPiA+IAkJCWdvdG8gZmFpbF9mcmVlX3Jpbmc7DQo+
ID4gCQl9DQo+ID4NCj4gPiAJCXJldCA9IHZtYnVzX2VzdGFibGlzaF9ncGFkbChjaGFubmVsLCBw
ZGF0YS0+cmVjdl9idWYsDQo+ID4gCQkJCQkgICAgUkVDVl9CVUZGRVJfU0laRSwgJnBkYXRhLT5y
ZWN2X2dwYWRsKTsNCj4gPg0KPiA+DQo+ID4gU28geW91IG1hZGUgYW4gYWxsb2NhdG9yIHRoYXQg
cmV0dXJucyBmb2xpb3MsIG5vdyB5b3UganVzdCBuZWVkIHRvDQo+ID4gdXNlIHRoYXQgYWxsb2Nh
dG9yIHRvIGltcGxlbWVudCBhIGt2emFsbG9jIHdyYXBwZXIuIEFSTSBjYW4gY2FsbCB2bWFwDQo+
ID4gb24gZGVjcnlwdGVkIG1lbW9yeSB3aXRoIHBncHJvdF9kZWNyeXB0ZWQoKSwgcmlnaHQ/DQo+
ID4NCj4gPiBPciBtYXliZSB0aGlzIGNhbiB1c2Ugdm1idXNfYWxsb2NfYnVmZmVyKCksIGl0IGFs
cmVhZHkgZG9lcyBpdC4NCj4gDQo+IE1pY2hhZWwgS2VsbGV5IHJlY2VudGx5IHByb3Bvc2VkIFsx
XSBtb3ZpbmcgYWxsIHJpbmcgYnVmZmVyIGFsbG9jYXRpb25zDQo+IHRvIHVzZSB2bWJ1c19hbGxv
Y19idWZmZXIoKS4gSWYgd2UgbW92ZSBmb3J3YXJkIHdpdGggdGhpcywgaXQgc2hvdWxkDQo+IHJl
bW92ZSB0aGUgZGVwZW5kZW5jeSBvbiB2bWFsbG9jIHN1cHBvcnQuDQoNCkkgdGhpbmsgd2UncmUg
YWxyZWFkeSB0aGVyZSBvbiByZW1vdmluZyB0aGUgSHlwZXItViBkZXBlbmRlbmN5IG9uDQp2bWFs
bG9jKCkgc3VwcG9ydC4gVGhlIG9ubHkgdm1hbGxvYydlZCBidWZmZXJzIHBhc3NlZCB0bw0Kdm1i
dXNfZXN0YWJsaXNoX2dwYWRsKCkgd2VyZSB0aGUgc2VuZCBhbmQgcmVjZWl2ZSBidWZmZXJzIGlu
IG5ldHZzYywNCmFuZCBLYW1lcm9uJ3MgYWNjZXB0ZWQgcGF0Y2ggc2V0IGFscmVhZHkgY2hhbmdl
cyB0aG9zZSB0byB1c2UgdGhlIG5ldw0Kdm1idXNfYWxsb2NfYnVmZmVyKCkuDQoNClRvZGF5LCB0
aGUgcmluZyBidWZmZXJzIGFyZSBhbGxvY2F0ZWQgYnkgYWxsb2NfcGFnZXMoKSBhbmQgc28gYXJl
IGluIHRoZSBsaW5lYXINCm1hcC4gVGhlIG9yaWdpbmFsIFsxXSBpcyBhIHByb3Bvc2FsIHRvIHVz
ZSB2bWFsbG9jKCkgd2hlbiB0aGVyZSdzIGFuDQphbGxvY19wYWdlcygpIGZhaWx1cmUgZm9yIGhp
Z2gtb3JkZXIgcmVxdWVzdHMgZHVlIG1lbW9yeSBmcmFnbWVudGF0aW9uLg0KVGhhdCB3b3VsZCBo
YXZlIHJlaW5zdGF0ZWQgYSBkZXBlbmRlbmN5IG9uIHZtYWxsb2MnZWQgYnVmZmVycywgd2hpY2gN
CmlzIHRoZSB3cm9uZyBkaXJlY3Rpb24gdG8gZ28uIEkgcHJvcG9zZWQgdGhhdCB2bWJ1c19hbGxv
Y19idWZmZXIoKQ0KYmUgdXNlZCBpbnN0ZWFkIGFzIHRoZSB3YXkgdG8gYXZvaWQgaGlnaC1vcmRl
ciBhbGxvY2F0aW9uIGZhaWx1cmVzLg0KDQpNaWNoYWVsDQoNCj4gDQo+IA0KPiBbMV0gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1NONlBSMDJNQjQxNTdCNzFDQUMxNDMzQjA0QjkyQjcwMEQ0
ODMyQFNONlBSMDJNQjQxNTcubmFtcHJkMDIucHJvZC5vdXRsb29rLmNvbS8NCj4gDQo+IEthbWVy
b24NCg0K
