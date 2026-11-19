Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.74.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795077220;
	b=Nxt8sOUDfAjDLbHZCtAYAtz+FK5HE1jKqRi/TaiHfeHx8Nzha7cGK1GBapP/ISDUptaE
	 u2e+M80B7J5erOt3UsCfkJ0zPkuIgrjFqj9DAj23TA53xHDzgoyEgOgGrF6fH1IyBji6+
	 4LnRRcabdEdNMrstKB1dErSUR0VT9qjClI0So1DnTB4fv4Mb/Y8x+ebk4oc5k47TsE8JX
	 zvtF6f86CTGvr4MW+ns28zUMJXuY7sxqJhmyTZ3fYmGTbELXGTlio3c78n64egJ9XyF8b
	 mS+/Mtnu7DBE5PPZiJBNCxOMoxdyF/98ARmlu/zM/Q6VJ0g6rmq2f7N0jwi7IPPjeVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077220;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Deferred-Delivery:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ttm0gDuIKrA3Sg1LDmojVPqASUe8+Og0gkkEN7Hwod4=;
	b=SeBKHodHZgq4ZDnfXCO2M6O8Npj2V98BebC7Sef2TbKxGyiUOAM4zsCsCgMVaW1z7sva
	 u0ljtuufboy3jsVkOeFxTks90gz3s+lAiyxcbju432m9HPTO+XwOKL8eJPcuVScJb1Q6R
	 mjFWryHDWV6RoM1PzyjlMAbDNDpDVZVOXeZnu4M4Lh49EmE0jXxPHL51WLp/7M4ydZ9uD
	 NjpJ2YRtXZw0YZK5L849UDN114GLkzespIGdpd2sFj3oCai9o+Ctgl05G3eLKFO2nAE2k
	 nH8DTm80+TmQpiFZ2qO80JRDAvL8WjdYtDz8gslBhb2+VTq1XYkUIVKXOuFgpPc5HAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=ZCbJ07Gd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.74.67
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011067.outbound.protection.outlook.com [40.107.74.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC08606A324
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 08:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FC08606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=selector1 header.b=ZCbJ07Gd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jXxz1tNu8ms8gr3E4xXautFuMjiaRPDlkGBCfvtFFgb3SZtHYcm3eQMr1J7rsrZQaOmusd+ZyYC6jjB0N+TRrvO3kA3dT0j9Ccpb3DyhU8AVyMm9qVMjGW1evJrxau6Bl1Dhq4tH7ybwwogqqrW8TcuWD28ekG84Bupn3Ga90XDR9oMjYci7zs5/bDmwRtLbMj2Y5oe0DqgFAkrbhUZcsXNUslq7vVnPPysrV8Biqcis9F5v1u843hRSed0oITIKQMiyXyZZLWcsTVscM1NI2GemO2JAhopVmXZjlZlmo+geqUGeTicICcy6rs42wiM7w1nxYg4DBstARC1eZRPIhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttm0gDuIKrA3Sg1LDmojVPqASUe8+Og0gkkEN7Hwod4=;
 b=lh8iLWjJ6aDToqFuj9Aov/DaGOZdwLDriZ+SqTfCdYNK9ds+VqjhbzWQs4D+oCUMggv3yetpOyBbap50y015dTyvlbUTF9hStsC8G+Nx6EmpI87ey8ppaOhHqtS2KXqNoeRSWHT4ApBnsnwGJBz5HPK/TqPMd+6IuGIg7YXJWnOaExx1gl5GVEos74HcJYQXi+m5bbG65BIvjoBWKxmBipcstfUPxAtjdQgh/PdMKRWMGoG7uyNMtzyxIP0v8HTBaGPenYKGc2G1+h4rY+mbRGia74sPbWM2vEqFzjG40blTrui41kgamPaZ4J8aY/j1tkQBjOMxfcviZ509ZvoWww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttm0gDuIKrA3Sg1LDmojVPqASUe8+Og0gkkEN7Hwod4=;
 b=ZCbJ07GdGr93hknyfiEdeIFdlkxKprOAFJibCaqwFkMQJJxXVhBoccw5FulqA/1m7SvYALMhHapwQdSo1UTweHa85B94LzIYosZ2+lMFfLdKBllCoJKz/zk2Klg7raqRQl0phVX0m0pWkOkHom1GJWI4iFor5Tl1o636SHIojsw0z69VogYwnSq16VX3HtNd9K0pnIEVrBTpv/hACwpm7lUnpyhdPkqCzgYrJukKnQfZv/snFGHgpil7dXBm9jtLteSgImPs4yKJa5GNbrrMOgJu4wdbzVxu+uKYvSdgVCm6Zx2EjoMLzv06krqVMvsfCSPQZyMVbOZLTFH1Btxrpg==
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com (2603:1096:405:290::6)
 by TYCPR01MB10335.jpnprd01.prod.outlook.com (2603:1096:400:243::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 08:33:36 +0000
Received: from TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793]) by TY7PR01MB15746.jpnprd01.prod.outlook.com
 ([fe80::bc79:d427:b0a9:a793%5]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 08:33:36 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Marc Zyngier' <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Radu
 Rendec <radu@rendec.net>, Oliver Upton <oupton@kernel.org>, Fuad Tabba
	<fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, "Kohei Enju (Fujitsu)" <enju.kohei@fujitsu.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
Subject: RE: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA
 Erratum E#030001
Thread-Topic: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for
 FUJITSU-MONAKA Erratum E#030001
Thread-Index: AQHdXVVYZhIvVbstSUigINbLGWcO0LcADluAgAAMrgCANSF8kA==
Date: Thu, 19 Nov 2026 08:33:17 +0000
Deferred-Delivery: Thu, 19 Nov 2026 08:33:17 +0000
Message-ID:
 <TY7PR01MB15746879988FA46744145AE1CE5792@TY7PR01MB15746.jpnprd01.prod.outlook.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
	<20261016-monaka-fix-for-upstream-v2-2-fc7ede7f9f48@fujitsu.com>
	<atIPeT7SLSLjQIcl@J2N7QTR9R3.cambridge.arm.com>
 <86bj8t257n.wl-maz@kernel.org>
In-Reply-To: <86bj8t257n.wl-maz@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=5106d246-5fa0-4806-a8db-e8e1a1b6061b;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2026-11-19T07:57:25Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Tag=10,
 0, 1, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY7PR01MB15746:EE_|TYCPR01MB10335:EE_
x-ms-office365-filtering-correlation-id: a03f50df-a043-4152-864e-08df4617cdcf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|22082099003|18002099003|3023799007|1580799027|11063799006|4143699003|5023799004|56012099006|10067099003|261026140227099003|261026121527099003|261028144727099003|261022105027099003|261021121427099003|261022075727099003|261102123227099003|38070700021;
x-microsoft-antispam-message-info:
 dJO1qvsUWwA8MeKRNt1VdhwCSAMeDMuM2fhjCfgziaGQI6jBcSgaDfafB9GuJc52wCkM1IpNAwylTvHakpRA4BLlyVdjO0EAIc+gbph8Xu1ySa0OPne9mp4Yvuqh4qHeiu3nE84HIr1mWEHSstPMK2W0eKIs++B3zlcMmt88E+cgLmfj/wCCoMng9z+JSYnbbVk6ozrtKXPzLJiEYLq8skqaFxgVpTxDQ9eQc8MBpKk0Sj3RCk5xdYuGZ2Ms4Y21K6+91+0D1k7PWpyUKzg0cQtaSzpGWcRySqyDIq45NqeLC4rJL+9HR2F7by5a7eoqRro+3uJmxscxr+UIrTH0+HfAgsaRuWN95fotL8wjg35HVn/cBKVCdKPl9+s2YtH5NPOHkCSWWRnzuWmMP2bE/E/KJqYbDiKbABssGsx8YXdnbCjkQwavjVx7AYcM6E0KVaTcKe5M8OB5BGQ7cCu4dRlq4BPPN6sk7hIS3XklkHBbN3+gxsUJDxIleDEg5phVUNlm0u2kpDDT6b8KSWwdDTAMuW/O2zLELUljNCSs2i1bgbRhNjVdEEYLQEJiTdoCkZ4+O5UXaX6zgnBOlyl0F3evoq2I33NP1OaoIbYIgISUGQX1US8MF7A4V38aev+Gcw04IaKnTPskPYQSls94XWCsGcYMbnbDCKNELeXtAmJTf13deIaqbwBxGihAhKWzVACtsiCf+VOeDV7x8LHGksKeKiS80pKaaoNurzgxjqUKdN5upUGdJl8F4wpuZvNG
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7PR01MB15746.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(3023799007)(1580799027)(11063799006)(4143699003)(5023799004)(56012099006)(10067099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261021121427099003)(261022075727099003)(261102123227099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?RktEU09qUXlIdndMaVE2S3dneUV6OGFMTHlqSmllQWQxek9RY1ljMTUw?=
 =?iso-2022-jp?B?Ukc0ZmV4WWRxRk5MdEh5SVRJUGlWa0wvaXh2L2hFTlpFcU1POTdIL0x6?=
 =?iso-2022-jp?B?bXZVazR5aTVJbzRpSUI0b0txY3NKWC9pcGJKcHlKWDViYVB2R1g0NENj?=
 =?iso-2022-jp?B?b2twS1pjand1eUJqeStTMHVzT2FWNHRYYk4yVUgwTDkxVyt0ZlV6UXpv?=
 =?iso-2022-jp?B?K1Y4WWhaSXM2UlVJRFZqY0lMaW1laGJ6NlIvMWdqWC9LcTVIb0dmdmFl?=
 =?iso-2022-jp?B?MnBQNHdwWlA0RnZnVndONjJPbU9jR25UVTYxV2ZON0UydkdaZjNHTzJ5?=
 =?iso-2022-jp?B?b25KTGJhc0ltTTJSdjJhR3hwb0RaRm1MV1p0UUFHMUZGS3JLelZYUzFt?=
 =?iso-2022-jp?B?UHk3c2Fwd1J2bDFzeVBTTGtITDVwdjFJZ1JHOXg5MTRRZ2xsK0x3c2Fo?=
 =?iso-2022-jp?B?dmhzTm5zYkFObExzcDJ4SlZBajlvdTErM2FJY25ac2tMMnRFZWdBTmpS?=
 =?iso-2022-jp?B?VmwxMTQwZzhsRnd4NE45eEpxM0hEUzg5T3RpdDRPSlgweTUxRmxkMklp?=
 =?iso-2022-jp?B?U0dES2NtSHcvSUhZYjJvVjcyNnVuUlprR25qVUl2VTRwaERoMllreWJG?=
 =?iso-2022-jp?B?ZnpMV3RpdzNMV0MwL1h4Y08weFIxYnFwQkp1R1IxSW1tNW5nRFE5UHNi?=
 =?iso-2022-jp?B?ZnNQNUo4Sk51ZWxZSlVuRU9nb2xSVEJqYVVsenp6VUttVmxzVS91YWtV?=
 =?iso-2022-jp?B?eVVMTG1BM25qc1dURHB2Q294V0gzUmp0YmVJOGNZSG9ZRnpwYmhSU3Rz?=
 =?iso-2022-jp?B?c2ZlR1ZtdE5aRHArKzY2dHZxVStUSzc5NVNEOFJRamZURU9UVjZISDJ6?=
 =?iso-2022-jp?B?UlpWRW1yUSt1RUtSK3dsOVVhQVFIWDNOMnJPVFpQQjU3eFdGc1ZyN2ht?=
 =?iso-2022-jp?B?THh6WEVoVkRCK0VHZ0FQTTREZlpsZTI2SkJ2ZGRmeEdLYkRIK25WMmVx?=
 =?iso-2022-jp?B?VU9pV040bmZPaHlsZHFaZ1R3UlF1NTNwcmJ4VTRIRGNxQmFYMFlQSWIx?=
 =?iso-2022-jp?B?Y2xKZXdKT082dTBtL2lnbG12Rit1aEhFSG1NN1hEWFpuS2ZUeGpITnM2?=
 =?iso-2022-jp?B?RXFsQVZrWmcwYVU4d2cxVkpCKzFXOFdtTnVISUNMekZBNFRGdUl1ZUlE?=
 =?iso-2022-jp?B?RUR5SVNEa2ltZjFUVUFBU3Z4L3d4aEhmbi9YTUI0U2Vubm1RK0wxMmVG?=
 =?iso-2022-jp?B?MUk2MGFWZ2MxVnozQTZhdUgreHYrUEdrZ25PaDBacFBnSTFQU2t4M1FK?=
 =?iso-2022-jp?B?QU82NW5ibDdEVDRyUmFyelpOWjRQRW5XalU1aFlMekttQVM4WG9WSHE3?=
 =?iso-2022-jp?B?RXYrWWJEMDRTRHJZYWc5TU51ZWVIZnVhQXRaaWRGM0svNW1oNzhnT0xM?=
 =?iso-2022-jp?B?bTMrMWJFcUhlbXRyOGt5all4R1BveXJqb3pla1Vpc0x6SGhaeDZ4U1dU?=
 =?iso-2022-jp?B?YzRjb01lNGhmZyt4L0ovY21lb1FQWjVncEdUc2I0YnVLbUFISDQ5ek1C?=
 =?iso-2022-jp?B?U0lTNFk1NXR0NGxETUpFUEFRTlhYYVBYaEJEMUJyNFZzU3ZJekxrblBp?=
 =?iso-2022-jp?B?ci96alJOejAzTE9Cc24yNHNDdW0reVd2dCtTL2VxWG1pbzdBbHZjbENK?=
 =?iso-2022-jp?B?aDcwS2M5SEJ1a0tsMXhYUUwvR2tmT1J0ZEszcGtDNnpIbUJWUSt6elA0?=
 =?iso-2022-jp?B?b3hFSEVWczNTWk5jVXlDQktXWnRTazk1YjdxRWVxbHZCd2hBdVZJOVY1?=
 =?iso-2022-jp?B?SUl3aFhBWTNGbnJJbW1aR1RhK3oxa3BEU3hSK3RReGpZRzhPU2RaMDRV?=
 =?iso-2022-jp?B?MXYxOEpjcTYzcGJHb1BjeFBSQTdPYWZmQU5sRDNTYVY4S1FDUmVxN0pn?=
 =?iso-2022-jp?B?QXp6OG1vQ21kNVBSbUF5UElxUlJwVlRNelpMODZyTWRkeDNYQTRyRWFh?=
 =?iso-2022-jp?B?WXpBR0pLeUdxTlBKWHBVUVRneHNNSS9RK21HUGZZdng3cTlBbnBVcStC?=
 =?iso-2022-jp?B?eHl5YkE3eVpIaWszMEt1Zm9Qb1NnVkErRWNEejFVWTB0U2NvVS9lTVBL?=
 =?iso-2022-jp?B?SXVhckRtZUVhTGVId3JLcGg2Y2luMHBiYU9OSmdUa0xPa1BvMTI0ZGFk?=
 =?iso-2022-jp?B?Q0t2dWdlRjZ4VVZnNkJycXlucFlzemdxeWZ1dkFKdUhzdm1PNnd5NFFn?=
 =?iso-2022-jp?B?QXFIaGpKQnZPd1p5L1U4RFlSb2pXSFhrM2ZEZkdCQUpsa3IxK09pUjJU?=
 =?iso-2022-jp?B?ZDlwSVJaVHY4a3MrMHRwODBkRFI3Ukp4RkNZeWYxd1YvYkpPcU5TYmRZ?=
 =?iso-2022-jp?B?bG8yM2MyODJCVXhNQlIzcVRZVEtmbytQbXYveldzTlJ6RHR5MzNGVzJB?=
 =?iso-2022-jp?B?clFZMllZamNUMFRhbTBhSTJSaWRoMTVyUGRaWGp1Q0c1aDVnUnFuQXJi?=
 =?iso-2022-jp?B?L1Y5dWkzVWJNcG82WEdnSlplOExpM0o4OUVUbVVaNlEvNVRreGRDZUkr?=
 =?iso-2022-jp?B?NERCL3Y3Zz0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	3al62UTYG7QHy/PJeSO4tWnIY/kSt/vUUMgeVZUaQclPHb0vKjR1eCIvRu9r4affa91R6kGxY22FF7s/BaPsbnrZnTzPAAtOoPn+OxqHbXhl7TeOHLSTMyPjm7j0tBDrgGgMP8rhybra6+OeykdnwAt2l9cxh5OzTltSpSu3wQ9FZ9x1a+eDIcY/J07IbG56J2AYBc1rLv8TWq2DKfIiXuaNgbbeF47aJdWY0bSQZTZ4ODoxAJN+f0a5KW8rOQjuMqiDdEozyDVH30Dm1qXvP81v7H4Rk2c9Bu44rnvG3MWHhMzawSwXq3SREzR9d218iZubib4ab6TxhnqnXRjujg==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY7PR01MB15746.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a03f50df-a043-4152-864e-08df4617cdcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 08:33:36.0713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LfIY7iN6tkrfj1uqqsHMY7gFB1dE1SXzcvPuuuwiYBYGyVG5YhL3lp9laH5uS+wEvgchfna3syB/DF0yYFGjAy+QoSqw1a8YWBZ5D0pH44E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10335

> Subject: Re: [PATCH v2 2/4] arm64: tlb: Add tlbi workaround for FUJITSU-M=
ONAKA Erratum E#030001
>=20
> On Fri, 16 Oct 2026 12:50:17 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > On Fri, Oct 16, 2026 at 07:00:46PM +0900, Tomohiro Misono wrote:
> > > FUJITSU-MONAKA Erratum E#030001 affects FUJITSU-MONAKA CPU
> > > when using TLBI range operations.
> > >
> > > On affected FUJITSU-MONAKA CPUs, range-based TLBI operations
> > > targeting a VA or IPA may fail to invalidate TLB entries when
> > > addr[34:29] =3D=3D all 1 && addr[28:0] =3D=3D 0 for 512MB mappings.
> > > The affected instructions are:
> > >   RVA[L]E{1,2,3}*, RVAA[L]E1*, and RIPAS2[L]E1*.
> > >
> > > Work around the erratum by issuing additional non-range
> > > TLBI instructions corresponding to the affected VA or IPA
> > > range-based TLBI operations.
> > >
> > > Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>
> >
> > As Will and I suggested last time, we'd prefer to disable range
> > operations on these parts (and ensure that the relevant ID field is
> > hidden from KVM guests).
> >
> > Regardless of whether eventually accept the approach you propose here,
> > we first need something simple to backport to stable trees (as I assume
> > you'll want to run standard Linux distributions on this hardware). The
> > TLB invalidation code has changed a lot over time, and I don't think
> > it's practical or sensible to backport this patch.
> >
> > As a first step, I think we should simply disable the use of range
> > operations on these parts, and ensure that KVM hides the relevant ID
> > field. After that, we can consider optimizing the workaround, as you
> > propose here.
> >
> > Marc, does that align with your expectations?
>=20
> Yes. I'd rather we start with a clean slate so that an unsuspecting
> guest cannot get things wrong because it doesn't know about the
> erratum. Anything else is icing on the cake that is not desirable at
> this stage.
>=20
> > Is there an existing pattern to follow for hiding the ID field?
>=20
> Ideally, TLBI_RANGE would be removed from the ID_AA64ISAR0_EL1 copy
> that the kernel has, and KVM would simply inherit this. I'm not sure
> we have a good way to do that other than doing horrible things with
> the override masks.
>=20
> Otherwise, something as simple as forcing the ID_AA64ISAR0_EL1 reset
> value in sys_regs.c would work.

It seems this approach is simpler so I will implement this in v3.
Thanks for the suggestion.

Regards,
Tomohiro Misono
