Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346AD3EBF3B
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779893826; cv=fail; b=uugfPNuCTMbW1KYXweeYCkxtuGE14wETKSZMkkWDyI3OjMj1bX0HvLgdiqpZpfaLm1I7aMb4kjEoUW8wOMN0GIbUtjBnxexRwxhxw1q63NL5gYA17BV3Anb1LwaMcIGv2R2uR7SXSQL5f5R/PDJ3glJv++t+iBVLZle4S9BhGT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779893826; c=relaxed/simple;
	bh=rolhzkfjVNkAfBjwqpFJHl9gu26XJzoYSJKPSZeKSg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ClaK5ISgw/tTUmfVaD7TZIYXZmELcqFQQsRLDxUIhiYKe3mszIAzxSSzQqtbN+lFgsAmzNf24zCz7QQQtRBLeUiXRWUQ/9P2NKAmlcksiXkUvNYEnPO9lsw1RO2Wum9VRLs5Eh+PG/evqMWyLs2C4oTw441vpz2isZULOWf66RI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RetgPlFU; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PssockIJ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RetgPlFU";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PssockIJ"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCs2rP2703537;
	Wed, 27 May 2026 07:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=rolhzkfjVNkAfBjwqpFJHl9gu26XJzoYSJKPSZeKS
	g0=; b=RetgPlFU0xozidrqTd3N6XG+YIEjGYThXTkJ8gMY5hVd3XWDaljRxqATx
	SX8yMgwDxzJ69MDP6ZkCRkTncTz7zqCLd0CExd2g7y4ozVv5kzQWIs3g8p/sHuhz
	iognMqS5mZbFMQFtTl+uV8MZAdHRU+FrN00i8m9FrwDMAmx1Xm/sIVyzBki64NrB
	3VOGXwyGBok/6FA95Xb6TOz/C+K48OphQEWDYvpIq6Wq1kTc73ujRYpES9FV5aVT
	J+TgypQsewhYee2FeKZEGsCw4CXRdflSKJQbGBq1ygtlXo/Caj9FMQNHXDNHnXAS
	eOwYNP5VM448/2yVzcUS7K0ZHXEyg==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021081.outbound.protection.outlook.com [52.101.57.81])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ed82b407n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 07:56:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TCYT9LdIeM5EjxG3vZo4C90YX1ly3AyITsYvXPWJHNHYdT4z+/5NCu/hu9GWF9AhI2QET8cm8LD5+jW/wXBOgpvcEQiPJiBqzaXg19/phZw7/HC9taRlEirKtOMqfkEEtsk6m1Wc7/b5DsqRahaZSWltl56COOcSTnMcvszThY2L9v0+RWUtLo4Wg1GomtA6jViYspiTU1mrQxvgP02N3iV4NEUnvZdH7dCVDRX45Srp354FianF+/5VuncgCISVzBs4MoLjjABJEpUzVT7fwWd1a7drhQfqSPAOLw9ent5B187xNWND0hhtnPwuw0LRjloJShOzASzgdeP+tYBeYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rolhzkfjVNkAfBjwqpFJHl9gu26XJzoYSJKPSZeKSg0=;
 b=XtZ6busAnMZ7AKC1kr0v/Z+0OV6gjiJbnRqg4bNnQPHF5Yt465Ic34xKJA4skrl/Hzjl2YXHb3ZIilZ9x+H7v9t1E3NgzHk8KvDlQpovhcaVlfVlfkrkmi5NSRLiSlW99b4oLyWqmBy0vtR59HjrZDba20ri5RzqtkxrKM0W1M/28obY/lTWh2Rtg8fiosmxGO0R4UkDa1TSxPZeLWid/LB7h7X5vn2yb2bqZyCkr2pD21/dhqWJY8VVc57JLlGEZFyErY3buL8GgxX7WJIdSEbNmg0GYHthjLlkJHAzZ7q7hHByQ0iHmTvbejgrb9sW/4NPtCyyRAc7UTq5hqN41A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rolhzkfjVNkAfBjwqpFJHl9gu26XJzoYSJKPSZeKSg0=;
 b=PssockIJquk9hv7h7FfiZm0OPP5lKmxfA4OxrLQrhzgCojRXuKWe0WK1pyMzQ2VkQIan7OiVIgyC31fKPGErIUTeqF8wMBATKKHh9xK9Z63MStVRQ/liXsLbDdpQlaqqNM1dcM4JB8sDGVjAeO5Ddq3D/VVCCcyKoWStlqdSowD4HltKknE71gqZFjMR58gAt+aUwfP2L0f+QPB2LG69R/rGMfjcF9rFtAlHqF/MYKwGPyCJ/dWAhEALDCxNo3eNWiWuO5+8J5msgiwNvEx9C6KMT5R34f7EeYOUYrg2x1HhI+ujSJAMDLkb7AMeIhYRrTdiVP0C86VglfJZ+yOgdw==
Received: from SA1PR02MB8851.namprd02.prod.outlook.com (2603:10b6:806:1f6::16)
 by BL3PR02MB8282.namprd02.prod.outlook.com (2603:10b6:208:345::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 14:55:58 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::e3ae:d2b1:462c:2047]) by SA1PR02MB8851.namprd02.prod.outlook.com
 ([fe80::e3ae:d2b1:462c:2047%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 14:55:57 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 10/18] target/arm/cpu64: Retrieve writable ID reg map
 in aarch64_host_initfn()
Thread-Topic: [PATCH v5 10/18] target/arm/cpu64: Retrieve writable ID reg map
 in aarch64_host_initfn()
Thread-Index: AQHc55OvO0I032px70q0Gpky88EsL7YiAlwA
Date: Wed, 27 May 2026 14:54:56 +0000
Message-ID: <5A95F33A-5FAA-4292-A8AA-9AA20B508A13@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-11-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-11-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR02MB8851:EE_|BL3PR02MB8282:EE_
x-ms-office365-filtering-correlation-id: 185279a6-1954-4c6b-eab2-08debc000f3c
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|22082099003|18002099003|56012099006|4143699003;
x-microsoft-antispam-message-info:
 MbLnIvXF2xfIMqdCAzUTnYktlJCMAtYShVANpAJf7OaJfSuZHGx3Xu72Av0AGQ6QXqYZgjcAT8nlniYiltG68DyNTeLptJYr2E/JSXUA/bCw4F2JERzBFTh1/3tLkI41IoFA0jBy4D2iHtSaZe+R9nf5howku8VXHh+U519NI7v6yYjP/Vb9efXYYafe/5xcmCp6Rhlmv3HEHN1BS71WrnuDGAzKVeWezNMOi9kFfkMv4/9CvlfAlsHeadsWqtF2+QIium2flcdhlArwrSUo+aa1A3iXPjEF8oKHdbV50/i/F0C4JY/AoymCxoImaWRS0WedPp9NVF70GOGC/rIIwjAiyRe89IWAwFhjY2Vt9Knxq+nGAWNfp2q6RicJ0tuSNBn0tB5nw9HwM1fLI9efEjaYsf3AoiZfxqDRgSjvOADkPa0IIiTfQ7deHqnP34ZI0isZwQ+aexQ59xWO3Mf2GiZeAP9v1UT/nPehiZNVDIvNW4+d0RpWCdNoqYDaNdsP12Ri1x6aLJHUAzeBweC36+WwOLU5yRzBafZWFx+QuOCFUcE/NIbIXN0wkRwPjTxN4aCK41WGIOFCwrgkBYnzxvy2a+36bgq3luAyDzv01ue3Z1Pk5icgm9zq9yvPgZshpvh+BtU1GiJ45VSfEHHmOMavNAGtd1LB69qGDMSJFkDbwvKkTVuEUVnP2ZC6CZYX330LrIQcVRQKqTI5k8Im0Qi5/lDUvUjmsKh7jqu8rPD3a73PfBGGwTBT3daEdGNo
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8851.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bzVQejhMSjU5dkoyQitiUHN1V3hHd25ESTFUZXZHdnhCc0VJSlRQV1dFaGd4?=
 =?utf-8?B?eEFJQ0FjT1k5UDRJeEtCaU1FajBsWHhta3lmT2hvZnNoSDk5OS9pWml1eU9W?=
 =?utf-8?B?b2wxcW9TZFdQT2R4MFN6VytCbUNKK2hXQTc3MTZlTjh2QlhVZEg1K0doaVVG?=
 =?utf-8?B?TFFITkc1bTlxTXV1Vy9EMUFrbUxxZVdoTm95ZlFjTlM2LzF2NURvNmhUK2dQ?=
 =?utf-8?B?cmFYSDdDdFZrRnNXc2FMbUZTT2FaYzBadXpxMXQzaC9IankyUEZHR2MwZUo0?=
 =?utf-8?B?b0lBZW8wRkNZR3ZneVoyTFVKbkh1R093dXZ1TXIxOG5XU0R5c0pxWXprR2th?=
 =?utf-8?B?TGQ5MnR3MWluM2IwSENWb3FwU29RZHUvbG5BZFB1bFRxZnA4cFlDOHIwd1pY?=
 =?utf-8?B?R1YrV1lhZkJiRzhuMTBub0FHY3dyNWFBVGQrUXA3VEZEZ2tVekdJZGt4VEJV?=
 =?utf-8?B?dzBJM1NTM3dsRGNvcEZ6c2JLKzVObzZ5WmRSbndzVXFMcktQVVRGWk0zQURU?=
 =?utf-8?B?MjIyZm02SVlKNHRrZHdsM0hraUt4VW9DemFSMjBVcEphbU54Q3o2Y0t6Nm5r?=
 =?utf-8?B?MGZzcjNKc0xTWTg1NFI3cWpZSTNscXVXNDBGOWVweUJxZ3RLRnNOWUN6ZXV3?=
 =?utf-8?B?U29sekhXL0I4VnFqeTA0YTVQRmhTK3BJZVliTFdaOXk1aTdGSnpMQTQrSEMr?=
 =?utf-8?B?Vk5NTmFrMUxjWmxjUnV1c1Rhc2M1OFNaVXBmVjBLTXF6SngvU1F0aFYwL0hw?=
 =?utf-8?B?Zk9qV0VjN2JMekxMRjVWSzlGYS9jWnFESU1MRVJ6NXFoSHBtWFVrWTZGYnYy?=
 =?utf-8?B?bDhjdXEvUUYwOVNCUHJ2NTYyMVVWaGx3bHBjQXNlNmVabjcvSDNxTUlwTURh?=
 =?utf-8?B?SS83V3ZpY2d1QjhvWTB0VFpZcTlQWDBsMnUyNTVzZS9JdDBNNGx1T1BFNjVa?=
 =?utf-8?B?aUU2aGZsci85NW5Db2p0NFZjOFhYRW0yUjR1YTREZXlHbUV4ODZkYVlEbVBK?=
 =?utf-8?B?dkJNMVFkSVFUMW1sSVpWRXJab1BNS3hJS25lNlRYVk5EeWZxVEUwNm5WNVlS?=
 =?utf-8?B?cHZ6T0FVdkEwV3B2eGFacFVOVHpPSjRoYzJuUTBFZFNVZGYrdjF1N3FtMEhT?=
 =?utf-8?B?eFo4UnY1c1ZlbGlwUnRQVVpENGRFemNZeE1mM3VCWGtoOGd6b0tTL2czY1pq?=
 =?utf-8?B?R0pELzJSeFZWVi9sK3ZWSTdpc3BaR1Fpd085T1hGN3ByaHFOZmZJR24zeS9J?=
 =?utf-8?B?NzdESVVqN0ZaYTVrYXhPMEVvT2xWYmplSSt5UnAvWFdZMzBLa3dpTjQ1M3I3?=
 =?utf-8?B?WURpelVzcC8vWFRKOHo1UWN6U1J4QU4xUGpWRVZnVmVKcXNKZzlLRTkvU3kx?=
 =?utf-8?B?UG5OSUpGUi9IZnF6YXdRbkIzZm5DcjQ4WEkzL1FTNS8ySW9lWjQvamNnanl3?=
 =?utf-8?B?OG40MnJaNlNuL1dMZEwxb0o1OTVwOWtQK0d5RTRkekkySmp0MTByMDBzS1RY?=
 =?utf-8?B?SGxWaE5WMGdNYy91TjJ2a0RwZ3FvejVERkViNktiT1dmMVFjYldWdjlHRXpn?=
 =?utf-8?B?SUxsakh4clphWHNZbjd4Y20zM2hBbXErVU93SlRLcG1DRm81dWhOZG5aMEFS?=
 =?utf-8?B?MHFSck5xQ2g3cTlLK1BQUVd3UDJNZ3dVQzFiYUtGNlZ6aTJvYkhYbFZ0YThq?=
 =?utf-8?B?MFp4dmtwOGI5ek9iUjRoK2VFOXpsbVI5VU9CaVB6RGpmZ2JyTit4QmNpYkZv?=
 =?utf-8?B?UW1aWitLOUtwT0NjQmowTkF5ZGZZWS83WEhZRTFoQ0dCb2dSYzNPQitKRlZS?=
 =?utf-8?B?Y0tKT0p5RCs0eWlxOVRGeG9vWWtRNGNIM01hM1FUVm9EY3pMTUlZZGZod0Zx?=
 =?utf-8?B?V3luZE5MazMyeFlKRE1PdE5BVmJYMWFoQlBNZ2V4aEVwZWlpamNCKzFiOWtn?=
 =?utf-8?B?MzN1MW56OVNBV1lkc1R6ZXlrazMyYzdTRmt6S013TkRFZjA1VWlNQ1ZXWlRO?=
 =?utf-8?B?OWxta3prclFPcEI5Z3ZPTUhnbU9BTkQwVGE1bHFUakEvNDBmSFRCa1dpR1A1?=
 =?utf-8?B?Rmg3U2ZJZFNCb0YzUGh3OThPRmpocktrenlOT3N3VVJnbjBRMVBjSncyRVVF?=
 =?utf-8?B?MnJZOUZsQnZsL2gwQWdnR3YzREFJcWJLQlBKWGpGc3U4c3NIcWpKR0hKNnZn?=
 =?utf-8?B?bFZEWnpTMDhHRGFvR0ppOFhpNm5XNURxOE4va29xWjYxV1F1QVBaTUh5RHhZ?=
 =?utf-8?B?MHZGdjBjS3lvNkRkV2RudlRlUzErOVd4dzFpc2tGOUIwWTlTYVIxVmcyU0tz?=
 =?utf-8?B?MEhlcUJ4TkxkZEhvekh3VGtEK21la2trRVZsQ0pRWXJqQTltZHl4VSswMVdm?=
 =?utf-8?Q?qIo1LlQ0Zvwg/scE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD04A61C1A56824ABA04A3785787B09E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	d10+PNe0iYa+cDQM8lJ4f4yRawSpFfGDIVYcZxgzB9FGAfRYnuXpWI/IZfjQhwRoCWWA2Mb5JTyIRdT1kMtCidV6zizJ4Z88qFn5B+GOnFgQesYF5GYkyI9j62AvXrBqcmD0wCQdibVJuzw5AjfwUOOhmWT6DO2hbhcUnE/3bf0M0j4YT3Dcv/9H1sqSZJh9pNLIyTy+qpq1c3l8/aWw7pPF1eDGvYUpWr+Zzsm1119zERX4kk2Fg8OG96up1vxHmeeifolhEdxbp0lXArUvuRVaOz+fGiJ4zz5hieNq6HAZHZ+mV/34t3YS9BVg4GNsG8Cbv/3KnowcTNIm6PkQHg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8851.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185279a6-1954-4c6b-eab2-08debc000f3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 14:54:56.3270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LjZX9VLbCQx/cZOfnxnt1W1/cLvfhh51u6xv20FZhCwg3ICbggo2sd/bW4hY0NclG/nej45fJ7IHbYaMJtqVZZ9ESyXxVoowUifVay6FOe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8282
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0NyBTYWx0ZWRfX0iF4niiY0Ngs
 zSp25XQrAA7pfMs91znnzYs3T8F1TAIManP19twMjqYzpV+ZBBIsQjIaW1f6EMIg3HKMozZuVfZ
 RGGDL3gqfOlk9U07cq7oIkBA7kMrRL4ka4LimslCOhuhrdzkPU3A8H4T8Na/2LB/c7YztE6IrRX
 1MF9+wreXFdvFz9skLojLspHrFTf/6a5Sm2MgZ5DdbVypZj01wjGr1BNyhvG2XhwzbzLi4JmFrd
 MCyeu3o2Z3pfMsXdqiR57aU4dlZz9ne4nmWNr5unYJ/T4kOCAH30qwevzUTX0Mq3EkPQMSXd1Ff
 sw6rvazcUvKImX3rUSyzd04CqrdO6S77Y42Ds84ixskWd2A8aBnSRGl7aU9QRNiJwq0CL5Hb0IR
 4lUaJEnc1Hrohqj3uQ+ddB4xjJ8hlf0bi79Et7qFJnmIIsV+JyUxLYomKHzVeYdTgl6wQRrQL7E
 SFv9SB3hpV+mq512M0w==
X-Proofpoint-GUID: ng5dUdwHCzTLr2Qw3mH6uG1nynF11sNp
X-Proofpoint-ORIG-GUID: ng5dUdwHCzTLr2Qw3mH6uG1nynF11sNp
X-Authority-Analysis: v=2.4 cv=E9j9Y6dl c=1 sm=1 tr=0 ts=6a170600 cx=c_pps
 a=oLfmZVzqrkQADya5iaUDoQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22 a=20KFwNOVAAAA:8
 a=vU5hh_NNnXIeG67eN0YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTkgTWF5IDIwMjYsIGF0IDY6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICsNCj4gKyAgICBjcHUtPndyaXRhYmxlX21hcCA9
IGdfbmV3KHVpbnQ2NF90LCBLVk1fQVJNX0ZFQVRVUkVfSURfUkFOR0VfU0laRSk7DQo+ICsNCj4g
KyAgICByZXQgPSBrdm1fYXJtX2dldF93cml0YWJsZV9pZF9yZWdzKGNwdS0+d3JpdGFibGVfbWFw
KTsNCj4gKyAgICBpZiAocmV0KSB7DQo+ICsgICAgICAgIGdfZnJlZShjcHUtPndyaXRhYmxlX21h
cCk7DQo+ICsgICAgICAgIGNwdS0+d3JpdGFibGVfbWFwID0gTlVMTDsNCj4gKyAgICB9DQoNCkkg
ZmVlbCBpdCBzaG91bGQgbm90IGJlIGluIEFSTUNQVSBzdGF0ZS4gVGhlIGlzIGEgS1ZNIHByb3Bl
cnR5LCB3aGljaCBkb2VzIG5vdA0KY2hhbmdlIGZvciBhIGdpdmVuIGtlcm5lbCB2ZXJzaW9uLg0K
DQpXYXJtIFJlZ2FyZHMsDQpLaHVzaGl0
