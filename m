Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013003.outbound.protection.outlook.com [40.107.159.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AD6285CAA
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375564; cv=fail; b=ii9porDb3JGz4KDDMlmzTvOC0Ix0PiMvucUvwDheBddt9IjCtgCGALRA0LS/DbOYRqCNDuL4LI4ux+Tw339L9Aw6+VdtlehqLS00KWipNH020PEf4dPspeMsyGZLYLwKu7xktcSthO1jEoNJ25nPM6QfHz4Ygixxrhe14Q9eu+w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375564; c=relaxed/simple;
	bh=PkxHFtgIFsAgtHvkHQxi2vitBC3y+QCGo/2BXtV67Nw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iPjhcu5jb01jLhQ1ndc3wTQpH/Tn4/iq1g/vJb9DC2s+1KD0kAR+f2ySmjqcit+9HFp+gxzDRGwbTpAsfwbn3uwow3rTaaNEbLdNaI1nsZ8zM2MiIe1/uVC7GGQKS9BwR1afiOWgEA9CeKivOiRtHFR42K1YhJe55brBz6IQYnM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G47NGSK/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G47NGSK/; arc=fail smtp.client-ip=40.107.159.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G47NGSK/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G47NGSK/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=y4Gm6ztaH0p2yCZ6NgimbezIqvUPfDQINxjrCRAJIjguhknU8VW6rjuzlWbVUurBooqh4LzrGmocd5aaWtC9K2z3dWKAX15Li+v0Gu4OfYdWY3qpXu9UYGyTN3HqIF7f0ljFfTM6yGuwKQgBvpb9HnwTmU5rKvxhqGtBqRf2drq2MARwS++QcSgsg8qZjwT5SviCffUoP5F62wptKaexBMlAtLEJVaIHt3qmNj6uLVn+LHteXDNVqP7hwnzkasDavglM5siVjrOEKVgbNUkQd1I4s8aDQRyPAy271L7LG/bZs/FeS3SseS6hD7YK6gS87n7TecMbrvqIVtULJkZqWg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BznU6SShDrIq+kmfrcCQRgnSOBiFFtSBPoMmORG9iBE=;
 b=IXsJV2H3nq3oneozQpr2GOSp0TsJXv6HV20S2lw8Lkgs4q0Vq0Q2EKHFxKB1BNeBTAsOBlyXmfHs+hS1CEeIFTwm6A94pUm19TTCq5g21acsqIZqNO95wgnjKB0nE3N2I5Wl1aLLW/BXmXptduqSZhlr8r7fQk9kK5XIXaKCzZKuVuu1owlwftmU+UsTKRpe1nrSlh+RH0ooP2guEAPx5zv16xinwjKpFqEp0KjqYXvBTTF/+Pqap0ZOL+b58/27sZ6szj1zslQnLg9qrHfoaOsTPcDucV6DKqVGZYIknj4yqX+rYejyRf0Lx7U2JyWkFk9uB7SiVl6OQG2SbnbadQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BznU6SShDrIq+kmfrcCQRgnSOBiFFtSBPoMmORG9iBE=;
 b=G47NGSK/xSjbZL0Rdvhz4Qcm+sdjdldKsihlOAQLznHLjvnH+avJVEagm9KpG6JvlxBINFwSkwvvNQoyCf2/Fqrj6b4cfPKeiVTsweA7ewzl/2RLorvhxEybHRgxeRnZz4P3uMqxJp6Z2IQ1tVY1NeZUXqrQ1ln2pbDsd65Whl0=
Received: from CWLP265CA0452.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b7::6)
 by GVXPR08MB10764.eurprd08.prod.outlook.com (2603:10a6:150:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:59:10 +0000
Received: from AMS0EPF000001B5.eurprd05.prod.outlook.com
 (2603:10a6:400:1b7:cafe::28) by CWLP265CA0452.outlook.office365.com
 (2603:10a6:400:1b7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:59:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B5.mail.protection.outlook.com (10.167.16.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:59:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NaLrcMyvryaelRWK7f8nxZcJgnX5GSLf9LFqeS3HreNhPVTrV7SqoIPYm9MLLEhtwwtHTpLiL9ZxDVne2gfckCa2KjTqJfhCCUk7G6+CzZbM3oa9tWxmLb4QxPndZJ+ja8pRxBmtdUsZzRsfyp/POamBsRcjX+PdDHUK3lf3hJUuh2AkSti6CZGphrYhwqLxAzhK6zklxyymo5AsW2MYZDRsiPYg91q5YrBxByxpPcUWts4DODnIcdWR1gKSawb5P89IrIRHxTCcspMONeRPjJRxiPoNy7zzUXE7MyqcN664kJiDwfoAdAWgeiTUSebbtAe8n4UsZwjwG4I8QvAWJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BznU6SShDrIq+kmfrcCQRgnSOBiFFtSBPoMmORG9iBE=;
 b=UwyrtffpYXaG2iWzKtGgHPKXL5zyJYCGHV28ivWlnMQw7vdIrA8SawkcSEKe/GsY9ev4er0nK22x2Ky81sVttiNW/vfPrMY0MQo//KanoqivnwMKpfFkS3IqThATeT0tKsHI3bKdVnbO7yfU1pjXrsAq5vY3d45/OH1IZstJe2vZSSYBv1+OYaVxi5wEZV6yLPk1gvgyOmfC5Z3DYv5gk7vhSHK6dL0pQTM7Qh4EaiBN9czSGnQKazaXMzNuCZtR3yn0jgLcSJ5sEvlvHxfZ1DfXho850J7p8r59MEwvG7x2gnWK6s2ys8QfefzZ3PWtcphDDI6TMo5W6Pg5+V9whQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BznU6SShDrIq+kmfrcCQRgnSOBiFFtSBPoMmORG9iBE=;
 b=G47NGSK/xSjbZL0Rdvhz4Qcm+sdjdldKsihlOAQLznHLjvnH+avJVEagm9KpG6JvlxBINFwSkwvvNQoyCf2/Fqrj6b4cfPKeiVTsweA7ewzl/2RLorvhxEybHRgxeRnZz4P3uMqxJp6Z2IQ1tVY1NeZUXqrQ1ln2pbDsd65Whl0=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by PAVPR08MB9209.eurprd08.prod.outlook.com (2603:10a6:102:30a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:58:05 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:58:05 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 26/39] KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG
 hyp calls
Thread-Topic: [PATCH v2 26/39] KVM: arm64: gic-v5: Add GIC VDPEND and GIC
 VDRCFG hyp calls
Thread-Index: AQHc6TI6cYFI3LplT0CmGu1eC3vk9g==
Date: Thu, 21 May 2026 14:58:05 +0000
Message-ID: <20260521144846.1899475-27-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|PAVPR08MB9209:EE_|AMS0EPF000001B5:EE_|GVXPR08MB10764:EE_
X-MS-Office365-Filtering-Correlation-Id: 76a7abda-82d4-4cb8-a6d9-08deb749838d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|3023799007|38070700021|56012099003|22082099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 ZKawP+8BjSFVwcT2RNwdWweU6oMCGcThlfGkWrPa0OXFbdMFni0SgcoLHe4CTwDpnVWK0PCxiL4lT9lJlkOdcDJFgpGO/wVDrPfoGAEMapwyU92JtsT5p8Cx4CSqwX1CCK9bmWr78mD3hm1HOzo7mXdC6DdPVmrEO+eVUzBuTlxRLmCBYo8w+ygv2bRe1tRWVuUS3+WHUoaCTyxNI3QlUudAk8tYR0yD0ZAmkk4Z4Pb1Os2iO4PXlUmuH2k6zNX3KnJIiZVDOs+OHcRf+/vg453RZbrjXVUfZw8VrQjnyTGvCJNPkd1qrXXfWYu//w3Q1f9LmZtFtJusM7EYk8jjVcztNJ/IsA3jMczlqeBnpS9U/emoE2u5wfOS6os4Mf0XhDzrO9HGM1JvNfeheSFBf7eN2kS2cGkJQfiVXuVTiePXrHiu0HVEYcbV9EKlolktZFxQFkKNRyj+LGVhy1bOAuvIi0ACbHHX9AsDdcroNVnSLGug9KMVSJeldP0enZTBBKXIigwww1l4wJtG3lGnpY9sNOmhWQQZ8y27NCmvdt90cbG62xd2gVZMASJ/bk7ifmDLGcWlQr1blhpw2VKBjcIQv6xoYSr/Je75hw1gPNd5GLn240VAWbeZxIb5+RG4koGBYCu7sEaMnKY96fZu545FgY7CYx7WLXvyaiogyUuIhi5FNQIXpxEnIX+0zwDOGlOWsBR6ShOyyLOfL60gtvJZX99W7Mxjqh5aIjj+77xaLrZBhfUgpveJFHjCamWw
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3023799007)(38070700021)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TbUGTVdjCU0AXNwMKH30lZ/9RxCJBvJ/CgEixFUvO0dgaBi8zqjfpA2WVSq/IoVI6CihlRjDZaMm+oAej/dESFQd4ffrUC6wp3bjlhp/z6uMcMnfxXe5wG3g9KCRBD4s36UEP7/o6YBV2CXPBoGPC4EsJfJW8HUq8aZXyb1qUlNJ0LehsuckRohct84btIeiFkwgxNCtPYD826PS6cSl0esFSID4FxCqLa5MnHG3KXJLA+yGLppyGxWhjF9wbaUha8qlVIIFZAusqOC4P3GJsIKXCcoJkgchYPllhkcknM7vmSyLkwsTVEI5C+bTbxMXww+rR9Hofld73+0qB8OzyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9209
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5c930af1-e605-40d8-f4cb-08deb7495d3d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|35042699022|14060799003|1800799024|3023799007|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	NMt4SqyYMXsBs39ZWY+V9QhI89ehU1s7CdPqjXIMOsrSJ4VJZ42LIj5i9bYyR6Wx6+srfD8FpIzDhC1MT63or0+LGyoDFkI7rUQDHlrsFRGCXB/vqwhr+DhA06TMor1N1iN71rG3BFzrDsjqjnRzmvuozajatPS5x+8F3P7UkBC3wPp7jnLDFk9pCvwA0XWEPi2VfcNZsa5WH7iHNo4qeFER2vXvoVzzUFA5ta6sMilSiBBZpguXjgoBiKQ5tVL+K2ClQ/U0spJK7tbExqiiWnOumdZbmo2deP8UmJU+0RQtNrJq7iGu2+a7S55ouN//6PJfoYUst8bmpONuEZwZZ5d13K9PzVqmZHfFXHUisb3AkRt+WQM+9whw5+oOj+06pFVBHCNux5DH6Ksq5SPxU9sarnOD3QjaZCpE5jubTA0Zbb/ehv0eBpHns/zGm1Rk5FyPaBwL0xDCvdA9vcToN1RvcnKH7yCEWRf+QMEXo2T9HLde2hnzPWHutsOSrLvmt1Sn8plk0gfLITQtgHj/EPZ7KUlRbCfEQajxnG19uCVIcccaBiKpt6bcxtdKEkPQI3gWV7SvPeVlR48cLF0D4OA7KH6KaWqc/jvY88ynTUp79QOXiDWw22JuGgOxtOZ/IhzZ3tzn6S+y1jzR60aEVg60nbYoyI12iH2RusMpYQrCactjGi859sljpbfo1GfhrHZmmoCMfP3FbQv4MP5HL0ARrppOinimYz0TYoGxosg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(3023799007)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	scFkAlgYU6Lp41ddE4olhgBaxPWoChA0M6EtI3HDX1LWFckpxZogP5fwDZWj90RwPdsyP4XWt7HRuSwOM9/dDnySeVGV28FhKpjP9Ek2hPZ7ydQKnuNN/l34Nh1YXGc3VUkiCSr/JTLFgyxP7WE5QUFWc4sTzd19CFQ5vr/431mifcKUawuXCzYBsrjgvZriEHB7gDNQ0qp5ckqQmv1oI7P2XGgi4Uj5HJCOT8Uk9XQs5RIvQSqeQM3wqrFtaNKxfeWFB82eh17Rah2e4whygZPYR03tAjrBbSaD1drUeKWN9/8r5kwSIExILzRuQkyGCcDmj2DXrH3vKrW/bDoZ4FkkcoaBGQ0xhWeh2FXg8/Rjro6Mqds9mE0R1q9Gn3SveOPaRjKqWByhd2/LaLaPvTY+eBsqS85ZiMGWH2d6yfWaSBZfkJ2ZBH0v8k2FALNN
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:59:09.9851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76a7abda-82d4-4cb8-a6d9-08deb749838d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10764

With PPIs, their state is injected via the ICH_PPI_x_EL2 system
registers. For SPIs and LPIs, there are no such registers as these
would limit the number of interrupts significantly. Instead, SPI and
LPI pending state can be managed from the hypervisor using the GIC
VDPEND instruction. This provides a way to set an SPI or LPI for a VM
as pending or non-pending, i.e., to inject interrupts into a guest.

At times, it is important to detect when there is an interrupt that
has been "consumed" by the guest (deactivated). For PPIs, it was
possible to do this via the ICH_PPI_x_EL2 registers, but for SPIs and
LPIs this needs to be done using the GIC VDRCFG instruction. This, in
combination with a read of the ICC_ICSR_EL1, allows the hypervisor to
query the state of any valid SPIs/LPIs for a guest.

These system instructions are only executable from EL2, and therefore
they must be wrapped in hypercalls for NVHE/hVHE configurations. In
the case of the GIC VDRCFG, this hypercall also does the read of the
ICSR to ensure that it snapshots the correct state. Not doing this
could result in reading incorrect state from the ICSR as there is no
guarantee that someone else didn't sneak in meanwhile.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 20 ++++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index d9ff9c2999aa7..38a4ba998076c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdpend,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdrcfg,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 5f9184276b04e..20aeb29a4adf1 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,8 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if);
 void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm);
+u64 __vgic_v5_vdrcfg(u32 intid);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 555275736fa77..9d3f968c316e7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -700,6 +700,22 @@ static void handle___vgic_v5_restore_vmcr_apr(struct k=
vm_cpu_context *host_ctxt)
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
=20
+static void handle___vgic_v5_vdpend(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+	DECLARE_REG(bool, pending, host_ctxt, 2);
+	DECLARE_REG(u16, vm, host_ctxt, 3);
+
+	__vgic_v5_vdpend(intid, pending, vm);
+}
+
+static void handle___vgic_v5_vdrcfg(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) =3D __vgic_v5_vdrcfg(intid);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -735,6 +751,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_make_resident),
 	HANDLE_FUNC(__vgic_v5_make_non_resident),
+	HANDLE_FUNC(__vgic_v5_vdpend),
+	HANDLE_FUNC(__vgic_v5_vdrcfg),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 46992a6c2cacb..c50e6ae93ba3f 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -149,3 +149,23 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cp=
u_if)
 {
 	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
 }
+
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MASK)=
;
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
+	gic_insn(value, VDPEND);
+}
+
+u64 __vgic_v5_vdrcfg(u32 intid)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDRCFG_ID_MASK | GICV5_GIC_VDRCFG_TYPE_MASK)=
;
+	gic_insn(value, VDRCFG);
+	isb();
+	return read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
--=20
2.34.1
