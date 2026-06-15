Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91872DECC2
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 05:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781502319; cv=fail; b=jQIiHl1WgMIbkz0Q+fXcAtuf0cGk8Xf8e+uTI99y++/36q9U7th0sabUgZs+CVQRWhfp9myrbG3DWwKI5GUVnx5ClXUJUW0HCso+PcDZ8raASAvJ9BepkaXitpvZDe9j0QcIE0x9ZhhBvePX77cb0bmHotmdAMxUY2XTEi9vrxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781502319; c=relaxed/simple;
	bh=Ul2R02Wp1ctEhIo/yiq+Iz/98A9Hayc3tNPhnDllAWM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r97lDkfRrkOAtsGWZiddy/cEd6AWXlh4tTpjtwUWKW1w3bYjP8yKdmfRT4pvg+5cHT+JMj/X42wpjUjSoXZf7jEBiTJhqJ4UeRwOcoqRNqndtFWjWZRCrkUCZm2tduxW3lxI7xGPVYccywjftSsIv6tQUeNAUEBttxPR/O+ww1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yzWiWXdx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=g+na/xME; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yzWiWXdx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="g+na/xME"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F1jPJI2203842;
	Sun, 14 Jun 2026 22:45:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Ul2R02Wp1ctEhIo/yiq+Iz/98A9Hayc3tNPhnDllA
	WM=; b=yzWiWXdxmHipct5zqi7mGYBDcq6Amam33DWcoIoSdCUSWXTuyIdKHRtNB
	QWIEm9fGQz0eNFPTZcYltRDGkofb36LCdJ4SFWTsMeb78BDdtt+qwZZ+rpAcHZkv
	SYJL3iYMVUrH+z2/kRrIXSPksQ52T1JS2bZbCsK1+9r+DG8sG727i5ZT3i1ATzAD
	DfA1tZVB/iEgLlnFwBXLR9yEy0N70/8HvT4p0Ltre62ADIbGVFtQIQftamTSTglr
	/q5VSqQ9dAvw2QLzmozesHlnKv5yO8r9VcH7ETcSsv9Q0FGHS0ffV1AAdMdbe6P7
	oxIPAvzlhXDpOnHH6jtMl8tqHKMIQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020108.outbound.protection.outlook.com [40.93.198.108])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4es6rsjndb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 14 Jun 2026 22:45:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wup0l8F31R0iaW3Ftl5mEOBt7TGwJWG3r8FUKORZS+Mzu4WL6yij+w3YetkgAW+LVSYuMii9Ndv8FjtiQyWeHcgxhW6S4aayVR27S0Pkb4dcZh7U6ZavRPmYYczM4yocl2iXJnSa1Cst2DyeLDZEsQNS0nYnWVR0mhb45H8H6ikcRMqb2DlpCDmUCvPrmVHbSXMZaaks8yUVcAurUzIwqm45nPMHw2p8QXolrYce62dczhMX4WroD17zxhB0/Zas8gRYViyOXSNC5WQ/ERvYoq+BGza52SM9fkTOYrF2OGSVK/wZKHTTYRZZY4e1yH3Lqh+vTcijfuWPzayaafjeNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ul2R02Wp1ctEhIo/yiq+Iz/98A9Hayc3tNPhnDllAWM=;
 b=NGqoNEa+Zsnu8HdBxCKoR0HiZdqIVMWPlURfqKvrzHZXgg0/NegHDmqRJzUbRzeH9AIwC5rcUw0H0rpQAwR5L5U+4ZEDGvu2PHbmyvuv6tQDZJITCzh6jypO9EHxQxn1mnRxcmhbin1pAOW+enjO/A6sXU4nBOKjwyRJcUtdEUgce9NXcQdU/ooeoSAaRmLVaoZQHZN8KZdNAvYnc5aXrCnhoX0oqpk+Blhwsayjl7FFSzzOooQWRvQ/lQdjBFLNPB4jpjEsqIje2qDK60rWd1PZxXV8KBghXaNeATqXXgLeAd+1KOmOSMwSZAUqke+DuctMjVeNkI3gFuumWwmUAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ul2R02Wp1ctEhIo/yiq+Iz/98A9Hayc3tNPhnDllAWM=;
 b=g+na/xMEzyoyC1mIyCSBNPzEa4KR8lflZ23MAr/kLIlgDHydZHrKndNVO0djvQ03S5PjtWtES3xNhE3GtxlOGGDMg8/Z/yK+gVvqq1WAUvay1ssQybz4hH2nJIFq/dvs8W5XyGHnUE/fVSQKDMtT3CeE7yQqApT1H1dj04iX6lNq8FGo7UHzNXwuZqMnk5yzg4fkYmdwypuS58Pgy9peManpo/hv0ory9pS0/zkSgw/2S6TS//yja6PhLVm6N8klJ3uip8EZAKls/sKZsiyEFFxX+hcBQ6kXdk4gdMkrTXUe+7Jk1jSH49fmrGLCwL0FOOJztDFOrVYg2C5R43pH9Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA1PR02MB8477.namprd02.prod.outlook.com (2603:10b6:806:1f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 05:45:02 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 05:45:02 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        =?utf-8?B?RGFuaWVsIFAgLiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Andrea
 Bolognani <abologna@redhat.com>,
        Jiri Denemark <jdenemar@redhat.com>, Gavin
 Shan <gshan@redhat.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        Jinqian
 Yang <yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: Re: [RFC PATCH v2 00/29] target/arm: Named CPU models for Arm64 on
 KVM
Thread-Topic: [RFC PATCH v2 00/29] target/arm: Named CPU models for Arm64 on
 KVM
Thread-Index: AQHc9MdVRvXFbjY0DkWSELHetR/yS7Y7DC+AgAQebYA=
Date: Mon, 15 Jun 2026 05:45:02 +0000
Message-ID: <C0A0943B-12A4-40CF-97E6-BF272A61AC36@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
 <eb5f98a0-1fc4-4a5a-839f-8bc3afc44165@redhat.com>
In-Reply-To: <eb5f98a0-1fc4-4a5a-839f-8bc3afc44165@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA1PR02MB8477:EE_
x-ms-office365-filtering-correlation-id: 58e7417b-021d-430f-faa0-08decaa13ea4
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|38070700021|18002099003|22082099003|56012099006|4143699003;
x-microsoft-antispam-message-info:
 O2hbPCHL5vUfjBY/3C8nm4FWEGSzxinENaN2iI2VOPlTtAc6tDIa91MeXDceUPUkoZv5qnjdtmlaOOvHTdvUDaMeK8iTdKeixvPrlULZRT/KeImhc7GOE/4eUM86nsADcpWRDgAiSCF52ztPyoewCXd6yHTyzS5hiS2SSr2WnuGz2OgTDBqFjB8vIhhvIfMTsTuh9nM91LStw0hzYjAqJ53GR06SduPCfqpjcexMiQmeedgEeP1UKU8IY3dMxSuRLm881Xt8FFCeYKew4qvaP60bc/t2dcbik9VNP8AAZBHsRTTRFV0gtHt9FpvbTQ73RP4xJb1LVSu6eIiSlXqWt3vKVG0j9CJRy17+stOjqdujVX5pVXYn/cdr+cRj/qUAAWc9tarj4oPFxhXjFCgO0q8px2iJficy59kMrRGU9LE7ThOcnFbu1Qjui1oSD0Klr9Y3nA/uelCdvIKlShjdJ9tHUlnY8bPaTURJGIiKvaTlYY6Hz3OHv6dIaMFduDo9zmGcnUQlQ0ESmKmazC6c0JenJ9c3siOBbYNfAriQV5RhHK6VOQTeiDogH8LTuHvFmmXjx7QgsZwBYaXf3VfDpyiKBGxMxMjgscIRb3wIuKUE1vN3Rw0oBwHoJooPFlmhEjsOJXIQOir0K9xH1YSSTkSAvGMPZ+QLsjx9I9tj0wky9C5RQTkfWaMCnaYPzkxd39dAohTzs2UcpzXiPR+t3cJz+VQw9uauvSl7p20j10OiMZRoGAor4A+3NXvqVwYT
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(38070700021)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q2U4WUxKQStDRW5wOUFiUmtRZnpvb2w3ZDRaTGZaOW5ENHNnYWxwUEdaSktO?=
 =?utf-8?B?aFUrd2JLNG92TGtkWC83QjNXOWxoTGhNYWpGUkhZcFh5Z25ZbHFGKzhxZS9n?=
 =?utf-8?B?Q0JMMkZuZnJnRFhYbkNIZmZndkJ6MWt3aXhneGttNDJsZHZVbkdQREY0RldW?=
 =?utf-8?B?S1E1VkYxSksrTnFWRUx4dzZLM3ZVZjFNQlFFRU5RbGcrUmF1eDd4RmtpWU12?=
 =?utf-8?B?aWloamwwcFNVN0FOWC9mbFR5bnpCdldVdDYwNXJ0UXdLT2EvU2NzNHFOKy9p?=
 =?utf-8?B?Uis4WHdGZ3ArT2F1V1FTRFRsV2JLN0pmbHRwWDZoSDRkbVhJRUtNLy9Zakp5?=
 =?utf-8?B?MUxWM3lheU1rZ1YwT1ptVmgzUzIrWEdnVnFqempzVTU3cisyc2NrdzBtZEJ0?=
 =?utf-8?B?Ui9vQzJjc04xZ3ovbGFZUFVtS1plYzdZbEsrUnhZRXc5VlpKZjg5QjFmVHE5?=
 =?utf-8?B?UElUQlpnRzE3SU1nV2lSQ1NvNDJRaDNBRTJJMHUxY2NDejhhUnFMckZqZERY?=
 =?utf-8?B?QkxHeUVmK0JDV2dSYUhFNTdMVTU0dWIzQlZUeXErejBPSmRWem0xd29Fdkgz?=
 =?utf-8?B?UlNuS2tJV3JGdFg1RmtNSW5QcStVRCtFdUtXdWpsbVBJSVNYcVVEQmZaSC81?=
 =?utf-8?B?VjFTV1pxeTBlczN5SjFnaG9pd2s3OEJxeXBHSkVTSW5TSHNEWkN0RDFEOXFN?=
 =?utf-8?B?a2VXUHNoYW9kNDQ1eGg4MFhhbWZ4QmkxN3lzTHhyU0wrMkJoclFTNWtNU2Ni?=
 =?utf-8?B?WG5JVVFJanJFSjh1aGd1akxVUXlNdHFkZTY3cFo5QzFCMXhyZFBmZGF0c25N?=
 =?utf-8?B?Tzg3STFiT3lnZkdXeXM3RVd5VCtzSHgrKzNnS3BFMHo2Z05WS3ZuZ3ZjeWUz?=
 =?utf-8?B?a1EwNjNnNWtJK2FQMVFRT1JBQ1NxMzNQTGVXdDNBNE1remdDRUdza3JSbjJl?=
 =?utf-8?B?SEhmK0dpd0V1ZURXU21VU3h0eUxrMFhNSjV2VzdoZEh2UmFPT3dwWDJnNStR?=
 =?utf-8?B?eWx3ZDB4WDVTSWlLa3pKU0thcSt4dVB3S1A2Z1NsTDVnSm1oaXk4Ry9IcmZH?=
 =?utf-8?B?U0tHYndwZE9NS0xXZkpGNkZXbHhWaXF2bHordUQyZnNGb1R0aDVRSWRDZTlL?=
 =?utf-8?B?czduVWxkMW9jMXN3ZkptT1ZXTmNhY0JRNUVKekJQZ1M3c1JsZkJFa3VoTjZD?=
 =?utf-8?B?dUIxcWJsaWRlRU9KdHJiekd3Z1FoL2QweCtjQ1ZCeldtOFBGZ2lUT0hNbzBa?=
 =?utf-8?B?ekVraFpoQkd5d0N1ZUwyV3p4VnJqcDZrSG54cEV0QmRDR2h3aHJ0dExJRCtW?=
 =?utf-8?B?TlRhM2kyRGVZOUErR2NxeXpTaUZ5enBoWWV0ZGlXQXN6Rm9wUGI1NU40Y012?=
 =?utf-8?B?WW04ZmFWWnh6OG5xcXdBUTZiR0RPSlAwWmo1VU5EZi9HelB2bnlxZEtnVDFk?=
 =?utf-8?B?L014NHJRZExYVTdRVmZBMDZtcnJhcWpucGFCWTM4aU9PUHdDREU4Y0taS2FV?=
 =?utf-8?B?UzY3Vk9LZWVzZ0tTVzdRYU1tbmdXVGR1djZtRjV0VHVnTTEzbG54aGxteG1L?=
 =?utf-8?B?Z29HWWMzRUU1Y2NwSCsxWFYxUE9uMm9sMnJjcnpSOGpYUUUvMjlLeFNKaWZp?=
 =?utf-8?B?Ujh3UE5ub25GRXduZTlUanZ3VjM5L1ZUeXo1WUdSdU9ldk02Q08zUG5rMXE2?=
 =?utf-8?B?YVhVdzNUbXA5bGIxZG9qMEVueExuNnp0VUtES1dFa2oweTVocVJBTEdSU2xx?=
 =?utf-8?B?czlGSUZRTCtnZzVjNy9MMHFnOHp5Qk9pSlQ3dGZJRTh5eHVycXFSblFYSzZD?=
 =?utf-8?B?dktBM2U5Yjdobk5FeXR0WWJDVVYzSTlmMWtOLzlRYy9wekdTUXczT3ZHR29y?=
 =?utf-8?B?NGlqUEVzcmFxbDdiWWUyRGNXc0JrV0paemNYMVpPbVR6a1Z1RWU2VVZRRzd2?=
 =?utf-8?B?QngrN0RKSk9QN3ZtSVIrUmk5T25zdURrQzRJWHhhNS9IK1luM29aMHBjd1BT?=
 =?utf-8?B?ck9FUTlwZEg4R1Q4dTRDNkZWMUluMFphTmNwbCtWSnVHMXhNNGZ5Zmx5ZzlW?=
 =?utf-8?B?blZKY2VKSHlabG83RGRUOVhETHcxa0Q4VGxocHJ1ekZVVzhFWGEvTElvQmlq?=
 =?utf-8?B?K3ZIWG1UMFR5ZlBVUDYxOHJTUXFvdjBhdzlBVlkvaENLQXNjTzc4aWJoeDZs?=
 =?utf-8?B?SWc4bjU2M20xUmJEVHhOTm9ncjVIcUdiSHFkcHc4UE1kNFgyTmVxMWR2TU92?=
 =?utf-8?B?UE1sMzFUMzNDWWhBMEFjb2Z1TkN3cWtwSkVySkxXb1N1K3ZXTDJ5WXhiM1pM?=
 =?utf-8?B?U2RQajNrYStUbXU2YU1iWjkwbWxrZ2dMT05NNjZRa0dhSTNzaE45ZUxodVBE?=
 =?utf-8?Q?hOVQ8xWamuE6OwGQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DA9DD83C61AF945A0DE04515AD320FE@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	EroaLm/eMrrEGPaaEUFggaqO9QQ6nq38N+ekWU2iRVpoiuBpPKXmNkK0y7jQFotbhc+VJQ4SJxUdlx+KVpViJlIzFiwv3JC4ZBVeRcxGBEIItZQuZfSzn3grXuHMYOJHyxrhibrbCmEfsefFVYgahVeq23iT9sjA1vGOPWe0+V/2jG+qrmUYH26pdBycuYWg9peKWuRLErmoARhrfVSkwMqbQ5uyOuuKDyMkJW6xoX8DW0ovauqOz3X+mxOVzZXsjBJ360oiweJTbf7WUxUbb8xWkt2P8kAR8Wgpv+NA/PFqb82BNh1n4GCP4/ldpTsT81Ly1N+zPW4OILxZ2sff4g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e7417b-021d-430f-faa0-08decaa13ea4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2026 05:45:02.2270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nQBstr44VeS1DmwkIwkuv53TyTTgHYCLyiG+hIokcylHhxhngGFg1ZbRigr0dQlvNC+eK/fD2ArocwiUk1pUp36KH2JzZ+vJNHPaqjpxM1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8477
X-Authority-Analysis: v=2.4 cv=CoKPtH4D c=1 sm=1 tr=0 ts=6a2f9160 cx=c_pps
 a=xBjimuHwEfEqBgrQ/0X4iQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22 a=NEAV23lmAAAA:8
 a=20KFwNOVAAAA:8 a=0W5uWVHbTmimw_G1Mz0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA1NyBTYWx0ZWRfXw04RU+tVSV62
 biMD2PsMLrwVTlktP6o9kTIuLpFYO74NdxOXZ8nz6umRBt6F9MICC0CzzEvLgM5Iyry7C25Qot0
 rxCaso0IFBsve4h0RocbXkiYOwplDq3hhy1CtbgrMI3q9xJ4ffWEUEvx1yzsnXnEJngrNOY5hCY
 oyJA6pCqBIWcnTxlM+onD3gyDteceO/O7CecZbgttjDd3dDwITH5Zx+r/zQ5euBPkuAfOuJpD3f
 oL3aCfaRksQOvburnw/scXxhNucB23AL8S4LiRRZX9/YrRIHhgA3NCWgkJgwAVhZkRWQKSOcPjZ
 5D1afoJOnU9xN0f+O/Vxhrb+cWICF1nRG9L7gVZrzzrvnyTHGEMd/uOj0c8f7GfNUxyKUFNWgMs
 DseAdcbfTc9DAY0XDvvib7aRB/7hgCcBG1DlXlaWc2Gvrb3z9neFrEEOhnVLCSBEeyN32esk0xS
 D1a2WD+g8hjbvbSlgMg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA1NyBTYWx0ZWRfXxs84ZzyZ64Zm
 YT1beCg9Yt5S2PjJXiC7s6omvRJ43c6D5iRLM25uBokIR+n02irM6ObnzTbZegHnvGKp7XhskIw
 rsbjj+D0eMn70W3egj73pOdFUI3Rv6A=
X-Proofpoint-GUID: D4--CtsLL9ZIH2GualieXcYKLn4GtA-3
X-Proofpoint-ORIG-GUID: D4--CtsLL9ZIH2GualieXcYKLn4GtA-3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTIgSnVuIDIwMjYsIGF0IDg6MjDigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IFBsZWFzZSBjb3VsZCB5b3Ugc2hhcmUgYSBicmFu
Y2guIFRoaXMgZmFpbHMgdG8gYXBwbHkgb24gbWFpbmxpbmUgZHVlIHRvDQo+IHJlY2VudCBjaGFu
Z2VzDQoNCg0KSGVyZSBpcyB0aGUgdjIgYnJhbmNoOg0KaHR0cHM6Ly9naXRodWIuY29tL2todXNo
aXQtc2hhaC1ueC9xZW11L3RyZWUvdXBzdHJlYW0tY2hlY2tvdXQtMg0KDQpQbGVhc2UgZG8gbGV0
IG1lIGtub3cgaWYgeW91IGFsc28gd2FudCB2MSBicmFuY2guDQoNCldhcm0gUmVnYXJkcywNCkto
dXNoaXQNCg0K
