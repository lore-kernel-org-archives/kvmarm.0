Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010050.outbound.protection.outlook.com [52.101.229.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C3B3E63B2
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 06:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792390786; cv=fail; b=efDQCIvSgfPIM41noDPDKTc+VCE4lsWjGPi147JsWL353w3UWDyAOMSOufpfNS3m43xORfox3YHurYt/avU6EGJfxnrJSZG8CPcWWz94hDv8AvVCZLXGxFeDgR3dAMxmxmxlH95swyax8Ap9e7BgZwKZ1TPrj+GTNY/VwmnihQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792390786; c=relaxed/simple;
	bh=x4lp3vz7k2dALzsz7Xifh/INIdl4+GWwu/Nhpwcnwpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bziGbrJcqmMXUJ00pl+N5d09x8v3GoFzH9FGTAj2VFh5tBinehI54kBKi8q0M3oAXoIeaWd1sIbqkNWq3zaTaxzg6gCucyyYwYI9zfIRgi/DYmF0wzUXUC0EekcFkzAcIfxVPAujMdOVHCzqFJskAr9qQ7SEotXgjgLwkceApJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=H/uKuep3; arc=fail smtp.client-ip=52.101.229.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="H/uKuep3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H9tseiLn7acK/um7ZSOsz8PyXcVLdBGGMLmKI7l+rJ0k5+Rsf2+FqHYNi5b/rsw8v+bdBJhsQupRwZm3MABxC7jSpYOY/L7Y4+mmaEQwMyWWR3h58ESLX/DbtHudLliziCnL1G2lZAbyY30sOMcK4afYyHEpH12/LeR7XhDgyYFks4dzGeRlOVkpDuThg3L39LPsIJvsCuHbu6whRk/5DHX+rzO+3uFkuJshJoOiZR/5B0tr6dxYKfEWESlikcONdhPKf9ecQrqHAmfdYDq5zzcn/ht4JEo2uQlk8aZ6kA8QvO12Vd5vvR2KQeOaXjOQPVSZLqC4u6SsTatW00RTiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQYtJj9pzuBEu8fqxXANYq6Z7GlZbDsPr4ZK5gqbZOA=;
 b=sP/+LDmSinAVEUK2rRnKHmFYvt/bhH7Gg6BHjuYlWQr6p3F5B4yTGV745EeYPSVv6Zr98dOcg61MNvv781uKMEPLPXlO+GB63+VTZT+orcnOyhyDaUEZDvydZYRrDg04Tma6ZPltFlcnc1w8GuAp2m41sUbmC3xhcbwGBa7wNU8TfWWieHGigfUu3HR28E9jXasvxKV3GIAVUSDfcjbRDCqzsAdV2HPHhqegWZMVMmhA2lZZHHsOIOj+veUdbMyCA1wFRbPasFWFMVu/wD+m55W7vQ+CVd/M/F5yJXXPEqSlEuLTgbhXQXujU/t4Jm4d+EOlCRt6zI5uG0ONcUE4rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQYtJj9pzuBEu8fqxXANYq6Z7GlZbDsPr4ZK5gqbZOA=;
 b=H/uKuep3RMTN00qMNBkm5ycjmsP25k9AZKFyPc4RbMR9odFvy8t310Y3mLpwGwDWv2la0HPAGxO6v5VEkCILtBME9ZkjmoVL/zlrptUZJK1WiAmu3fKXN5bHis9sWKOiaCrGrhw8sgB1meynKMx6ta/Bry6IIocDMBQmb1YwyQko3Ru9p51tasMG0clQamGxq1bfiuc8vyYOyWmedTtcTwcIQs8sKy6s/scF8aF7CfYchBHVY0RIVRiB/4IAoLkhKITQcv+SfXbdUW6vCApFo98jbQ0tapdrs42nWX7s3LS7DWQ7gVt1riKjtqPWDCpCIrhx7A9BV0/No16SilXHPQ==
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com (2603:1096:405:290::6)
 by TYYPR01MB7998.jpnprd01.prod.outlook.com (2603:1096:400:ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Mon, 19 Oct
 2026 06:19:40 +0000
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793]) by TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793%5]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 06:19:40 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Mark Rutland' <mark.rutland@arm.com>
CC: 'Catalin Marinas' <catalin.marinas@arm.com>, 'Will Deacon'
	<will@kernel.org>, 'Jonathan Corbet' <corbet@lwn.net>, 'Shuah Khan'
	<skhan@linuxfoundation.org>, 'Randy Dunlap' <rdunlap@infradead.org>, 'Marc
 Zyngier' <maz@kernel.org>, 'Thomas Gleixner' <tglx@kernel.org>, 'Radu Rendec'
	<radu@rendec.net>, 'Oliver Upton' <oupton@kernel.org>, 'Fuad Tabba'
	<fuad.tabba@linux.dev>, 'Joey Gouly' <joey.gouly@arm.com>, 'Steffen Eiden'
	<seiden@linux.ibm.com>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>, 'Zenghui
 Yu' <yuzenghui@huawei.com>, "Kohei Enju (Fujitsu)" <enju.kohei@fujitsu.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, "'linux-doc@vger.kernel.org'"
	<linux-doc@vger.kernel.org>, "'linux-perf-users@vger.kernel.org'"
	<linux-perf-users@vger.kernel.org>, "'kvmarm@lists.linux.dev'"
	<kvmarm@lists.linux.dev>
Subject: RE: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
Thread-Topic: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
Thread-Index: AQHdXVVbzJOi/425oUyzsr9T2p9p/LcAE4mAgAADN9CAABKyAIAEOluQ
Date: Mon, 19 Oct 2026 06:19:25 +0000
Deferred-Delivery: Mon, 19 Oct 2026 06:18:41 +0000
Message-ID:
 <TY7PR01MB15746F6C7CF8E021A0FBA5743E5982@TY7PR01MB15746.jpnprd01.prod.outlook.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-3-fc7ede7f9f48@fujitsu.com>
 <atIT0dmeqAXLoThW@J2N7QTR9R3.cambridge.arm.com>
 <OSCPR01MB1573944ED57DC682897594F06E59B2@OSCPR01MB15739.jpnprd01.prod.outlook.com>
 <atImMmlBmOYlY5T2@J2N7QTR9R3.cambridge.arm.com>
In-Reply-To: <atImMmlBmOYlY5T2@J2N7QTR9R3.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=969935b1-c26a-4e1f-90e2-a7a740456de3;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2026-10-19T06:16:17Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Tag=10,
 0, 1, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY7PR01MB15746:EE_|TYYPR01MB7998:EE_
x-ms-office365-filtering-correlation-id: df24a1ae-4703-4b28-b54f-08df2da8f569
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|38070700021|1580799027|6133799003|5023799004|11063799006|22082099003|18002099003|10067099003|4143699003|56012099006;
x-microsoft-antispam-message-info:
 lYCLPfhW09tUtU5G2Jf06T8iKwXx4CwGqt9Ejb0JIU95rsxElTXZMGy9EC7f+CK73Up3Tq29+RhRERj37jqG+tFHstwo2Lhrg8QiQiaTNLoz6U6uBWMsLImTJqSMe08h9xQmoWEZMY1pFUyXDI5DFR+tXpmrfokpDO0pwdLn6g1vsMXr62fMTuYwcVsWsPf7OAxl9qQZytByz1hQo2MAbM1TNvVqUE92SDZczd331yJC+YQiKAEakCHE98XGyC2uGoztbNxaXoPpFHbV2JRFkCA2xuYllhnP97E0nDmShn+4nZGRuUrPCNidaiCg8S/fhjtdL08jGRboK6+PyIyihoVm/aPz17rfMRElpDo9qJAoPCZjCDDX0pqcMB2h3quIqUVivN2ZEv5SYsdeHZvIa5ef5vd0a7Ns47YDiyqCqxNv2uTtLPaYMCvgWQBFSq5mD+rl8lfaslJDWE2Mez2azzdNZkAevz7t/WKxtOPPD2fTzCcX/s7jcb6R3gLUR309D9z3YUIkGUltznsh3lLjMShki9slGMP/MedXnfOaFhh1jY4Iyt/M2fVWnXOZwuAQOfR5C+R3o9EE9INJXcbhpt86RYimHMyjfBNGOPRO964I0ckHbTbHUZB6UaQd0YuiE5cy/Xr5eC1RUUwXpXTYAHMM2qk0KFA9DuDAEaXpK7NmJFphu3Ba+1RfW1tahby7OSmIvNAnmXGTaszxff5pBsz16Hf8tCPSWCoWqQdfn//Lyj3LA5hc3Bmyr/ouBDpg
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7PR01MB15746.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(38070700021)(1580799027)(6133799003)(5023799004)(11063799006)(22082099003)(18002099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?VlhianJXN1FTei9sTlBlMmN5QmQ3TDdGNlY2N1BWRndWM0JiSVJZOW9C?=
 =?iso-2022-jp?B?T1dPV2dhcnEwcVBnUlBHc0ZLbHU0STlzR0Uya0hzNi8rT2RBZVo3ZFV4?=
 =?iso-2022-jp?B?MjFESUJtNExwRGx6TncrRVFTQ1BBUDZVcVJQWm9qNnB0dUlFV2ZONDhY?=
 =?iso-2022-jp?B?V3JBWk5oczhtUXpEcndYMWozL0VxOEZtVnBGSytxRUFXTEd4ODIySjlZ?=
 =?iso-2022-jp?B?MlFXZ1ZNTjlpMU5BSkJ6TitlUk1WZlR1UklTWjdSRlg5N3pXN0JNVDVD?=
 =?iso-2022-jp?B?KzdUWm0vSGxTejFvVXJoSmRvM1pXbEFlclRZZnBTd1NLeEgwM1JTQmFI?=
 =?iso-2022-jp?B?bklQc2tyN29hQUZhV2NoRjZEZ2dsZHA3bzRkY0RCb2cvdHFKWXkvZUlv?=
 =?iso-2022-jp?B?cVN2OEJWY1plUExKZGtweVRkQnhqZklpbWo1ZlJydnZ5ZVdJRmN3WVB3?=
 =?iso-2022-jp?B?YThpa3g1d2Y3Z2E0QUc4TWplMENvZzYwSnZvenBtU1VnaGViRFNMQ0lH?=
 =?iso-2022-jp?B?WFFoTDFuc1h2UWRCVVNlQ2RZUHBBazN2d2IwUnBNZTBNSWdFWE5QN3pF?=
 =?iso-2022-jp?B?L1hTVnpiM1RxQWk5ZEtaV3VKdnQ5dFR1TlZQZUorc0FpUXluYy9pa0lU?=
 =?iso-2022-jp?B?a3U2WkhaOXFiMStSRUFhSXRsQ0NrNUpHT0dXbFFSSDBHcm50Z3U1NWFq?=
 =?iso-2022-jp?B?Um5DRXc2OTRMMWxTRG5WSnhBYTJtM2hsdGIxaDFPOHkzM1BKaThHNWh2?=
 =?iso-2022-jp?B?WE93RmZZUzBEckU5dENScXpXd05EaUtlMnR0VDZOS1EwMFp3eDBQSGJI?=
 =?iso-2022-jp?B?RGE4d2p6Rm9nN0crWDlYQW9iK3dvK2NlVHUrUnhscmxWd2QrY3p5ejhk?=
 =?iso-2022-jp?B?MUh1T2UxQVhPSFdubjFSWVY1MmdMTU52NC9YR0NZYkhHSGtRNHQ0MzdX?=
 =?iso-2022-jp?B?TWpHZnlvTjhvcU9qVFVwLzU4LzRmSXMzYVU5QjVzd0RtWXgrOStONy80?=
 =?iso-2022-jp?B?WkM4cWExaDNNdk9hUEhnVXdCdHhhRGV0eXZIKy9MNWhCSkRSZ3BSZ3VX?=
 =?iso-2022-jp?B?ek9mdldqdVVITVpmRWp3THJQMklRWHJ5MzZ0NHJzU243amJCdGFiZDdI?=
 =?iso-2022-jp?B?cDNzUDlaRmNvSGpsUDFOOGZLOWd5RG54K1RFTDM2YTZ4NVJET3R4cXNT?=
 =?iso-2022-jp?B?dnRJZEdGV09ZZjJWNXBlMFBtTjdHNUNkSVZWQmdWMmFwdHhaWms4WGNs?=
 =?iso-2022-jp?B?eGRqM3FaZENIOWFDWUUxS1IzR2VTaDFEQ2dsbkVCQU9NL2pTS3RrRUVn?=
 =?iso-2022-jp?B?MkpmdGl1UisrSjR0Mml5cklHSXlMb09MTzEvQmI4bi85TjBiQkZjeURk?=
 =?iso-2022-jp?B?c3Y1UDh0UHp1Q3FwTm1UT2FMTC9iQVFaWlVCK2F0Zk8xeXhBNVVSUE1v?=
 =?iso-2022-jp?B?bW1YcUlxRWJWQVdPMkZKdTZIZkNmUU9LbUhEWk4zY2RMTDZ4SVp4VFJW?=
 =?iso-2022-jp?B?QzF4aktQdFg0U2tMZjgxZWRqbUtaU09CbW1vb3hiTFlQbjVEd2VYRUgv?=
 =?iso-2022-jp?B?V1BjQWtuYkhTSVA5VXdBa1JWWlZMb0hwbDJiK3V3RkZVR3hXMWtBRC9I?=
 =?iso-2022-jp?B?SXBndXVvMWh6K0Jqd0VTU2xDajhoRzk0Skl0cTA2VVlLZ3o4L0F1N2ND?=
 =?iso-2022-jp?B?N1dMZWZkTUkwUTNhemQvTVUxMGpqMERvNjl4VktqR1A5TE5mRkZ0QTFO?=
 =?iso-2022-jp?B?Z1g2a0xxQ1o2SmRKeEM1N1Y4TGZmbDJOaE5OQXJtM3UrYTFCVnE5Nk94?=
 =?iso-2022-jp?B?L1ZZSTNUcDFYdlZFc28zVmNjMk9tbHVSWEtGbFdlV3dZMjBzYW9wVXFp?=
 =?iso-2022-jp?B?NGhmS2owdWpUYjV2dW0xUDA1eWMvQ0NJY2Vad1FPa3ZlUGxxanJEb29s?=
 =?iso-2022-jp?B?Z1h3V3d4VmFKcEFyZ1ZpQXhuMGlKVWdKbVAyVys5U25iQ0pSS0hXMWtU?=
 =?iso-2022-jp?B?cnFjSk9WWkZJNC9YeDhRcjZNNGpSR2pURnhraUUrS2hiTTNCNnltZU05?=
 =?iso-2022-jp?B?Vk9udVhVUW5wejRCSnNKMkRub2pCT2h1OU04Uzk2RE5TNXZ3ZlYvbWpN?=
 =?iso-2022-jp?B?U0NCSmhjdnlEZzlMTE1GdTRsRUc0Njl2eFE0MmlOa0c4SFlGY1ZQWno2?=
 =?iso-2022-jp?B?U2RzOGVZWGd5TDh5b1hpbXk1S1pwTUw1Zm1PQ3oxRVdVeEVWQ1J1VDVZ?=
 =?iso-2022-jp?B?UDM3UzhPalNpWmtMWE5NaFBFVGN3LzAyREIxV1pHZVQrQkFmdWhCTjdL?=
 =?iso-2022-jp?B?RGNyUEJOaU1zZ3hUZ2JqeXU0TSs2NkFHNXhoSWJYU29JKzZxdW1Idlh6?=
 =?iso-2022-jp?B?ZkxNaFE3K1BsZ3k5LzFJRkV1SHdZSmV4enNkV2JoQ1l5anUyYzY0c0hO?=
 =?iso-2022-jp?B?Zmw4cTQ0ay84M2dmcmRrSXJSNlpLYWdmVURuRzdRb1QxWWZWMDdMS0hI?=
 =?iso-2022-jp?B?eDN5M25PZ290VWZXR3NTREhjK3Zid08wREJXM2g3OGw3bjFhQmFSZ3hL?=
 =?iso-2022-jp?B?MVkySVFGOD0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	SXy04JchoOmfNp0YEc0XX4zGM5X1AJnhm/rBxj6RcdRkjf+F+O7toESSDSoXUCho/dyexFO6ca5Y47moZ+fsVKHkh8tELwGusrUCHnYGO15a1FMghlinZ5h87EssDZ1xLm4ORQL3d3EXFiAo8OH8H06xLyUA5exj6SR4X9V5VIoc8R4iBDQHzGobpqDhd7GCeyCLm7+w4IImNWZbQznJYUYhuls5PU3cB/XEP8KMiUaeIbauRhAWWGTdh2XhVLXB9iJ//00fj/7RtkfpvxHO+2TXe9nWU8n5Cw0/w2nukmY3igWPlZf56W/8f0fTCFextuqjUma9mFGOhrobm1QtTQ==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY7PR01MB15746.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df24a1ae-4703-4b28-b54f-08df2da8f569
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 06:19:40.4424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LqAtKdOmz3S4uo1z6Zex/Hu9QKhJnaKmlgtgjCflLEyUvkmAKH3F1I1dEuhhOl/SDdc0M4uY+v4LEsFw/OhsXP9P7RwiLi0ScgejtSouqJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB7998

> Subject: Re: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU-MON=
AKA Erratum E#030002
>=20
> On Fri, Oct 16, 2026 at 01:00:13PM +0000, Tomohiro Misono (Fujitsu) wrote=
:
> > > Subject: Re: [PATCH v2 3/4] perf: arm_pmu: Add workaround for FUJITSU=
-MONAKA Erratum E#030002
> > >
> > > On Fri, Oct 16, 2026 at 07:00:47PM +0900, Tomohiro Misono wrote:
> > > > FUJITSU-MONAKA Erratum E#030002 affects FUJITSU-MONAKA CPU.
> > > >
> > > > On affected FUJITSU-MONAKA CPUs, after a PMU event counter is
> > > > stopped at a value just before overflow, an overflow might still
> > > > be incorrectly detected, resulting interrupt storm in some case.
> > > >
> > > > For example, if the following conditions are met:
> > > >   1) Running perf to count an event in user space only
> > > >   2) The event can also occur in kernel space
> > > >   3) The counter value is set just before the overflow
> > > >      (when using the -F option, initial counter value is -1)
> > > >
> > > > when the kernel is about to return to user space after enabling
> > > > the count, an overflow interrupt is incorrectly triggered by an
> > > > event that occurred in kernel space. Since the counter value is
> > > > not updated (correctly), the interrupt handler does nothing and
> > > > returns with the same condition. This leads to another wrong interr=
upt
> > > > and results in an interrupt storm and eventually a softlockup.
> > >
> > > I don't fully understand this.
> > >
> > > Surely the relevant PMOVS{CLR,SET}[n] bit set as if the counter n
> > > overflowed?
> > >
> > > If that bit is set, the handler will certainly do *something*.
> > >
> > > If that bit is not set, the interrupt shouldn't be asserted at all. W=
hen
> > > does it get de-asserted?
> >
> > Sorry, my explanation wasn't clear. The interrupt will be de-asserted
> > as usual.
>=20
> I'm trying to work out which of the following happens due to the
> erratum:
>=20
> (a) When the erratum occurs, the HW sets a bit in PMOVS*. An overflow
>     interrupt is asserted because PMOVS* is non-zero. The overflow
>     handler will see that bit was set in PMOVS*. Clearing PMOVS*
>     de-asserts the interrupt as usual.
>=20
> (b) When the erratum occurs, the HW does not set a bit in PMOVS*, and
>     asserts an overflow interrupt even if PMOVS* is clear.  The overflow
>     handler might not see a bit set in PMOVS*.
>=20
> (c) Something else.
>=20
> Can you pleaes confirm what HW does with PMOVS* when the erratum occurs?
> I assume (a), but you haven't explicitly stated that so far.

I confirmed that HW works as (a). I will update the comments in v3.

>=20
> > The problem is that armpmu_event_set_period() will not update the count=
er
> > value if, for example, the counter is -1. Therefore, false overflow det=
ection will continue.
> > With this patch, armpmu_event_set_period() will force the counter to -6=
 so that
> > false overflow detection won't occur in the kernel, since the maximum e=
vent
> > count at a time is 5.
>=20
> I expected that were this to occur a number of times in quick
> succession, the core perf code would throttle the event, and adjust the
> period.

I didn't see that happen. I'll take a look at the core perf code.

>=20
> I am presumably missing some detail that prevents that.
> I assume you've seen the issue in practice? i.e. you've actucally
> triggered this with the perf tool on real hardware?

Yes, I see this problem on real hardware when using perf with
the -F 99 option or the -c 1 option, specifying counting in user space only=
.

Best Regards,
Tomohiro Misono
