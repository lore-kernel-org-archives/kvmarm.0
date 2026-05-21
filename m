Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013015.outbound.protection.outlook.com [52.101.72.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124C73D6CC7
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372437; cv=fail; b=pe7bYRaElt9p9nQS5KpenGUW8fNmwBNUFSX3Vxqm4vN3IIMexTSmsF42jW0I8bW3J+PXerbQeTBfNlEKrbf8LO+UOL0RNFouZeRxoiLpTbF0AFdJ46aOPEJJ2EqV5/q8yZCPrhAeI4LL59InklcUnZBPN50nLXSIMqdnEYO+WQs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372437; c=relaxed/simple;
	bh=NdTUJ3U/MsEdIcvNfZYGf09upyRCoJJlryzI9RNbpK0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CpZZ7M7LPfBDYXNaRfsLQSTG3NVgrvxhSWE6UI3SrVK3HGZftIjFEMr82X3syTkQuu6GS1cEKB++HUo+Osmf0iWk/tYDy6NyvUwDBMjbrqkVXSAVdivkmjE3QlhYKuTMsHTHNjyvVrUMmYBJf3fI+b3HKP/D3pWlDO/y3cTRTs8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HdW0HEd6; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HdW0HEd6; arc=fail smtp.client-ip=52.101.72.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HdW0HEd6";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HdW0HEd6"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=QufX1GfU4UrN+NwSzlH29M6C6m78PnF7TYGiE6P3BCBB1sImq+UE/hG8bzhAFWF5ZPxJRASexOySKKhI5iEefSAtMTipbrur8avzNW6H40f3Hm0cYuYK4S0JFhSg1SiCVA3s8iTaNngqwFp2403vI//b4DQQqofjJdWmIaCofdNtmZG93gBJsUYulTakHM9gMc4dZSydHTSN23wevfV/Jowd9bHqlg0mL8cxLtZLOh5th7GfEaEtES7X/FOSAQF56u/Z+PHaEjF7+wxni2IQyaIit2W+D0KV9WUZnJryc0YI9haSUnARphdsnbjy4o82rSz4bOYTsZmgz69sANtBKA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdTUJ3U/MsEdIcvNfZYGf09upyRCoJJlryzI9RNbpK0=;
 b=muPOkYhqAkpm3BaBXLWKflm0IHNlEull8YvTITfzcFd8BG4HY9yD1Hghx4qpW6fU4b8Y8XU5Xhqy7FhAcQq4XKdG2m10e52Yec7HAjW78yT3KXHPaQRHqbbKvNZTBRSQZH7/7HM+LtWzrMaj7suJMPrpGGndPLOzTL9DKPjDOEEKON9zhXIqE+Nrqaeeb80i1L3h0OWSriYajt5iAvBFZ8i2tWVbhh0hzzHwTIVRCQTuK8cZawuUw4/y9nf4vnAKdkBhml3Ei/VROnmy7HVk+OmQ7YR8Ss64d2Pkfqvyvi4EB5tL3+xWJn8HobgTem5P4wBRwdx7133Hc+DvDCY31w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdTUJ3U/MsEdIcvNfZYGf09upyRCoJJlryzI9RNbpK0=;
 b=HdW0HEd6aJ9K1qngfTjqc+5Kl73Tbdsb3FSKd+1dhW1npL4Y32QzB/Qv8UWvcja3zVqYHNozriicy7wuaCxi5PrjmohhNRjQDkabGVjJWMuoVuMPNR7ZXu9RoGxcCrJBPNkoEa/V4aPSD8hXYJUdDrgeBuS0f3+iz4ACcqAMxNA=
Received: from DU2PR04CA0152.eurprd04.prod.outlook.com (2603:10a6:10:2b0::7)
 by DB4PR08MB8128.eurprd08.prod.outlook.com (2603:10a6:10:381::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:07:09 +0000
Received: from DB1PEPF000509F9.eurprd02.prod.outlook.com
 (2603:10a6:10:2b0:cafe::a2) by DU2PR04CA0152.outlook.office365.com
 (2603:10a6:10:2b0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:07:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F9.mail.protection.outlook.com (10.167.242.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKqMbD4dQbbyabnaRT+Tjo9eDsA3sZVQZtXt+/D7swLX9mcCJXSZV26XrZGYV5He4tRBSB3hv2efeD/EZzk/Z5xEsvOosGjuLPpk4gZjKeml25D1uHJzVAB0PamkKAzCs/tRk8+zikAKdLKwB8tGT038uta4+OitWgnxp530+otpN4X6TIe6GgXOszhvFZe5rd+pLGs7Q/ep/5TrR96zcI6OUxGHwKxKziW87VXxvIiigkO/JbAIO/rcx4uTbu4P/x5mKiPoy7Qkua6/W3XB7HwMlckq9cTQRlTNTFY31b2aW2tRoW0B4QnrCJ7a+PmDXTbKJ+JZ2sVrXNwu//+aLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdTUJ3U/MsEdIcvNfZYGf09upyRCoJJlryzI9RNbpK0=;
 b=JqnknKEUFe32fnSk6SYmwbjOTjpHZ9bydwcPqRsAGBg99ocRNzrMypd8/S/2u7HcSvm0gr1Yj2XotBMAYi53KzkPGQlTeQFzVYTpGACLhrTp94SPlN26lQBwrCaJ8MXGIJSw5F7H4lH5sgb1H7+UNs4k4zmCuVw/zhbf490HCNI3vsnXcOySlMbb9I7x8oR70meXAoY0zheo8yz8ZNP0Mece+gkxzLzi64lX7hIS/r82vZKc+bpoMRRPyl0NrqQFuUbcyuXMpEm1ZZuLT/nEBeTF7pTpdrPnP1vMr5+6L2BhDbr9JHweevbRCSnPjl7ZUuXB+0AgWQJzXXBH/47Pjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdTUJ3U/MsEdIcvNfZYGf09upyRCoJJlryzI9RNbpK0=;
 b=HdW0HEd6aJ9K1qngfTjqc+5Kl73Tbdsb3FSKd+1dhW1npL4Y32QzB/Qv8UWvcja3zVqYHNozriicy7wuaCxi5PrjmohhNRjQDkabGVjJWMuoVuMPNR7ZXu9RoGxcCrJBPNkoEa/V4aPSD8hXYJUdDrgeBuS0f3+iz4ACcqAMxNA=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by GV2PR08MB8583.eurprd08.prod.outlook.com (2603:10a6:150:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:06:02 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:06:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 14/43] KVM: arm64: gic-v5: Request VPE doorbells when
 going non-resident
Thread-Topic: [PATCH 14/43] KVM: arm64: gic-v5: Request VPE doorbells when
 going non-resident
Thread-Index: AQHc1mBp+fmgF+oM0EKjmOFNVlTr87X3bdUAgCE7UQA=
Date: Thu, 21 May 2026 14:06:01 +0000
Message-ID: <56b2dca58b3ea7a40c25129697d76aa9fd528ef6.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-15-sascha.bischoff@arm.com>
	 <86ecjwzqcr.wl-maz@kernel.org>
In-Reply-To: <86ecjwzqcr.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|GV2PR08MB8583:EE_|DB1PEPF000509F9:EE_|DB4PR08MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dee52be-1b91-42c5-ec6c-08deb7423f3d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|11063799006|5023799004|4143699003|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 UNCU30Tz4lv7hf7dvu6O0gbAWz76c88k2CtRChadbJNIawWs4cgd07XjY7Vo+WAeTCZlpV+W8ncu/KRDMj5QaeA0jsshJF4f7dszdgShT74Yru/R4tmQ5a8peGJaPl4HtITbmEgOQaNTskRVqdFLTcZrebgxuhwv3o4xaG0MXdgGrwRr3EILe19qu6dCkTecjdpDG8wsk/sNdRFsqDmpVgXHQb3Zfdwp5ZOkx3VLU4c7QN0pEBEW0nlATpNlQsyJ2wIFxpPmQCz5AjXSnasSu2d7+utd7ADSzDyv3r7fEkcD+wkxNz+u8Mz6C84rO++rUtW4GBiOsooUPWbixTNb0Vsua2Zb5W/Z4RXBaRybtteKCgcOakwqsD1npU+Iht+ecCpUKIfsCS9Y7rjIqnzf5wzImoOwwuKqGaxsP3Gr1yMVEMptM2qm6Dl7jc8fPc7tLoUqZ5UgwItcgRCgEmR07DZE+9r+9RqxTfg556uNxldcgCHOdX+pFkdFJpIu1nuDX/jcXPSjLEgQ4ojkVdXV9cSz11USiP8pDHhDQP6RLX9pHSMLP982NGDhRTABWgISdzohEffpQS8D6vJ7Qa4AtW5m622Uf8njzMAy/8FpSFHMgUaMQKTfqEvJdS0IGPC/tHeze4UwqNUIXrtN3X2X8VXmMyR9q1J9yrUHQUv9DA0U7jtj+QP0qtl3fsl3MiTwMQIiyuKDQ05A1sH1GdjWOEdj1WQgjkthTsPCGXeO2y8H1vGmbY9hWyccmY+DNTwx
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(11063799006)(5023799004)(4143699003)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0E9DFD5DA79DA43A0051A3250E2D2B9@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bUffvWgItdW4woM3h5JCUdjlua2H+o1qJBSacUdLhCUBP0yRyND2LiK08LSC7TCVwSAWGoOAMGknFMSD3E/TxR+bTAzeLAP8SXGuARzl0uFQ/EU1TbycTcAuxxwgevIcqGemxrF6vxlPnX8AUx1F0UzTyONOmaSVxP1Jo5tUKcTk6c1NHw11X/40+VMU5udPzjMLZgHE/MNgzP0D1K4NBIIwAIk6wm/tNCM2i8SNmptHkNYqpJ5gg5Nm5NzNEjyk0VrpWaELYqFRBIliI6/kMCXy6JcAFqM+fZM2pawZe/sJirsPDZE5XGg2QN+4/KzDsSbvtT0Kl8KnDWan+p/Dgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8583
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a33136fa-a78a-45cc-79cc-08deb742173d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|82310400026|35042699022|376014|36860700016|22082099003|56012099003|18002099003|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	TGdLX/2U/z4wFlDWchRDfcW5tvbu6p78EF/IPUX6i3/LN3K4NQCEoSOidb7+e8oFHLSjWQ/34WDCp/ruvs3peT90XjRxrJqXkNGRfSC8vizCottz4mZjgIQrp8USWtZiMBPpQChjj+hrqRtyOUWKIM6k1fmPkOo0ZGK1pB6hnECbFlvLzRS99ywvrqmw+L9601n0A/cxrRC71mC2CjEK24NGbbSjsFFTy0kw0M4+sBcCl/W93RnmyuHndNipW9ipk0SK08cCGbsC5WvmJdOoFtoOOi+7EiEtSu9ZQsKNslIH+YqE5E/3rpVRyzigI4XStOs1K0YmOAgtvR3L1eMcvu+bvQuEn+fM4QhKRZ1VOKkznDfeSw0lQ1lz8xTfGE67A8vMHBJqY9afCIIbHlp4YVYqNed0Ngc5Rlwm2hE21Srbsi2JSDAVMeZWOoN9gHSCWN0Oxo5bLBPj/JBfGOwRi7EUG//tH0SNXLKj1u0YYlzNzagLcVOVmQ6QN2Tc+RK8jMkTPoN1UzJlcyiEETX5j1qS3gHAgx/AOhwsDONxqfUg18PU98XuLcGLSm9bmfo88Mw3VqbaYrDgc8lovQ7s1GmNn/hq7lM3/+/JHSQKomBfdCP+DupxpU2Hka1i/7u8Yr7IFr5Dh4gewvfIfjknkQUvf4OadvtWMyEWPyrAKS06CzRIoRIbpuPBww0zhcxInE8IjKxy/daFYb9IpvkHuedAD7JKC8viZXvdnxgpJkA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(82310400026)(35042699022)(376014)(36860700016)(22082099003)(56012099003)(18002099003)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	za5h4eGyh0y9ie0SwhsdbX+WkZi3wg+30vEE3he8PoGFF6PwcAL86fNPGwzXdLNAinz/3YLhRyXDVpMlMG6vWypW42to1rXnvc2AD7lioDkcdk1Phzbt3+nXFezuNV4bU/dQ1BniIW/bfLyU5Y31eqpM+E+O3Pkw6WGuD12v/Dge03iAVhf+TaAjFqTG05b1EISxbmWEtZvYow5NlhCscqP1/7+7ARqsuLrPsEZcIUH3m+mcrz29ztwegjgz/uMyyghnTldEQyxTG3n9tvLgztCPnrCoJxMBhciR5iAsjKtIxvXn4nC/EBDIummfk1YbqPkbTPUfyuCtN4Iy4Es5wJxGTxnTWsRpUrI5Ji4eCRRqUtCR8rfM1/qdLtXtlFA3cCpOvzqPqISOuq0DkDVhJ64L79GIfFX7UOihHH359++RkUJ+7mm2qvafNmW7ULZi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:07:08.8837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dee52be-1b91-42c5-ec6c-08deb7423f3d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8128

T24gVGh1LCAyMDI2LTA0LTMwIGF0IDExOjM3ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMjcgQXByIDIwMjYgMTc6MTA6NDkgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFdoZW4gYSBWUEUgaXMg
bWFkZSBub24tcmVzaWRlbnQgYW5kIGlzIGVudGVyaW5nIFdGSSwgYSBkb29yYmVsbA0KPiA+IHNo
b3VsZA0KPiA+IGJlIHJlcXVlc3RlZCBmb3IgdGhlIFZQRS4gVGhpcyBhbGxvd3MgdGhlIFZQRSB0
byBiZSBlYXNpbHkgd29rZW4NCj4gPiBvbmNlDQo+ID4gYW4gU1BJL0xQSSBpbnRlcnJ1cHQgaXMg
cGVuZGluZyBmb3IgaXQuIFRoaXMgaXMgdHJhY2tlZCBieSB0aGUgSVJTLA0KPiA+IHdoaWNoIHdp
bGwgc2lnbmFsIHRoZSBzcGVjaWZpYyBWUEUgZG9vcmJlbGwgZm9yIHRoZSBWUEUgb25jZSBzdWNo
DQo+ID4gYW4NCj4gPiBpbnRlcnJ1cHQgYXJyaXZlcy4NCj4gPiANCj4gPiBSZXF1ZXN0aW5nIGEg
ZG9vcmJlbGwgaW52b2x2ZXMgY2FsY3VsYXRpbmcgdGhlIERCUE0gLSBEb29yQmVsbA0KPiA+IFBy
aW9yaXR5IE1hc2sgLSB3aGljaCBlbnN1cmVzIHRoYXQgdGhlIERCIGlzIG9ubHkgc2lnbmFsbGVk
IGJ5IHRoZQ0KPiA+IGhhcmR3YXJlIGlmIHRoZSBwZW5kaW5nIGludGVycnVwdCBpcyBvZiBzdWZm
aWNpZW50IHByaW9yaXR5LiBUaGlzDQo+ID4gYXZvaWRzIHdha2luZyBhIFZQRSB0aGF0IGNhbid0
IHByb2Nlc3MgdGhlIGluY29taW5nIGludGVycnVwdC4NCj4gPiANCj4gPiBEb29yYmVsbHMgYXJl
IE5PVCByZXF1ZXN0ZWQgaWYgYSBWUEUgaXMgbm90IGVudGVyaW5nIFdGSSBhcyB3ZQ0KPiA+IGV4
cGVjdA0KPiA+IHRvIGVudGVyIGFnYWluIGltbWluZW50bHkuDQo+ID4gDQo+ID4gU2lnbmVkLW9m
Zi1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiAtLS0N
Cj4gPiDCoGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jIHwgMjggKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKykNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gaW5kZXggMTFhMWE0OTFiN2UwYS4u
MmZjNmZhNGRmMDM0ZiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djUuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gQEAgLTEw
NzcsNiArMTA3Nyw5IEBAIHZvaWQgdmdpY192NV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkN
Cj4gPiDCoHZvaWQgdmdpY192NV9wdXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgew0K
PiA+IMKgIHN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0gJnZjcHUtPmFyY2gudmdpY19j
cHUudmdpY192NTsNCj4gPiArIGJvb2wgcmVxX2RiID0gISF2Y3B1X2dldF9mbGFnKHZjcHUsIElO
X1dGSSk7DQo+IA0KPiBEcm9wIHRoZSBzcHVyaW91cyB2YXJpYWJsZSBhbmQgbW92ZSB0aGUgY2hl
Y2sgaW4gdGhlIGlmICgpIHN0YXRlbWVudC4NCj4gVGhpcyBpcyB3YXkgbW9yZSByZWFkYWJsZSB0
aGFuIGRlY2xhcmluZyBhIHZhcmlhYmxlLg0KDQpEb25lLg0KDQo+IA0KPiA+ICsgdTMyIHByaW9y
aXR5X21hc2s7DQo+ID4gKyBpbnQgZGJwbTsNCj4gDQo+IE1vdmUgdGhlc2UgaW4gdGhlIGlubmVy
IGJsb2NrLg0KDQpEb25lLg0KDQo+IA0KPiA+IMKgDQo+ID4gwqAgLyoNCj4gPiDCoCAqIERvIG5v
dGhpbmcgaWYgd2UncmUgbm90IHJlc2lkZW50LiBUaGlzIGNhbiBoYXBwZW4gaW4gdGhlIFdGSQ0K
PiA+IHBhdGgNCj4gPiBAQCAtMTA5MCw2ICsxMDkzLDMxIEBAIHZvaWQgdmdpY192NV9wdXQoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgIGt2bV9jYWxsX2h5cChfX3ZnaWNfdjVfc2F2ZV9h
cHIsIGNwdV9pZik7DQo+ID4gwqANCj4gPiDCoCBjcHVfaWYtPnZnaWNfY29udGV4dHIgPSAwOw0K
PiA+ICsgaWYgKHJlcV9kYikgew0KPiA+ICsgLyoNCj4gPiArICogRmluZCB0aGUgdmlydHVhbCBy
dW5uaW5nIHByaW9yaXR5IGFuZCB1c2UgdGhpcyB0byBjYWxjdWxhdGUNCj4gPiArICogdGhlIGRv
b3JiZWxsIHByaW9yaXR5IG1hc2suIFdlIGNvbWJpbmUgdGhlIGhpZ2hlc3QgYWN0aXZlDQo+ID4g
KyAqIHByaW9yaXR5IGFuZCB0aGUgQ1BVJ3MgcHJpb3JpdHkgbWFzay4gVGhlIGd1ZXN0IGNhbid0
IGhhbmRsZQ0KPiA+ICsgKiBpbnRlcnJ1cHRzIHdpdGggcHJpb3JpdGllcyBsZXNzIHRoYW4gb3Ig
ZXF1YWwgdG8gdGhlIHZpcnR1YWwNCj4gPiArICogcnVubmluZyBwcmlvcml0eSwgc28gdGhlcmUn
cyBsaXRlcmFsbHkgbm8gcG9pbnQgaW4gd2FraW5nIHRoZQ0KPiA+ICsgKiBndWVzdCBmb3IgdGhl
c2UuDQo+ID4gKyAqDQo+ID4gKyAqIFRoZSBwcmlvcml0eSBuZWVkcyB0byBiZSBoaWdoZXIgdGhh
biB0aGUgbWFzayB0byBzaWduYWwsIHNvDQo+ID4gKyAqIHBpY2sgdGhlIG5leHQgaGlnaGVyIHBy
aW9yaXR5IChzdWJ0cmFjdCAxKS4NCj4gPiArICovDQo+ID4gKyBwcmlvcml0eV9tYXNrID0gdmdp
Y192NV9nZXRfZWZmZWN0aXZlX3ByaW9yaXR5X21hc2sodmNwdSk7DQo+ID4gKw0KPiA+ICsgLyog
RG9uJ3QgcmVxdWVzdCBhIGRvb3JiZWxsIGlmIHRoZSBtYXggcHJpb3JpdHkgaXMgbWFza2VkICov
DQo+IA0KPiBUaGlzIGNvbW1lbnQgcmVhZHMgYmFkbHkuIEknZCBzdWdnZXN0IHNvbWV0aGluZyBs
aWtlICJSZXF1ZXN0IGENCj4gZG9vcmJlbGwgKnVubGVzcyogdGhlIHByaW9yaXR5IGlzIDAsIGlu
ZGljYXRpbmcgdGhhdCBubyBpbnRlcnJ1cHQgY2FuDQo+IHdha2UgdGhlIHZjcHUgdXAiLg0KDQpE
b25lLg0KDQo+IA0KPiA+ICsgaWYgKHByaW9yaXR5X21hc2spIHsNCj4gPiArIGRicG0gPSBwcmlv
cml0eV9tYXNrIC0gMTsNCj4gPiArIGNwdV9pZi0+dmdpY19jb250ZXh0ciA9IEZJRUxEX1BSRVAo
SUNIX0NPTlRFWFRSX0VMMl9EQiwgMSkgfA0KPiA+ICsgRklFTERfUFJFUChJQ0hfQ09OVEVYVFJf
RUwyX0RCUE0sIGRicG0pOw0KPiA+ICsgfQ0KPiA+ICsNCj4gPiArIC8qIE1ha2UgdGhlIGRvb3Ji
ZWxsIGFmZmluZSB0byB0aGlzIENQVSAqLw0KPiA+ICsgV0FSTl9PTihpcnFfc2V0X2FmZmluaXR5
KHZnaWNfdjVfdnBlX2RiKHZjcHUpLA0KPiA+ICsgY3B1bWFza19vZihzbXBfcHJvY2Vzc29yX2lk
KCkpKSk7DQo+IA0KPiBSZXBlYXRlZGx5IHNldHRpbmcgdGhlIGFmZmluaXR5IGlzIGxpa2VseSB0
byBiZSBjb3N0bHkuIEl0IG1heSBiZQ0KPiB3b3J0aCBjb21wYXJpbmcgd2l0aCB0aGUgY3VycmVu
dCBhZmZpbml0eSBzb21laG93Lg0KDQpJJ3ZlIGNoYW5nZWQgdGhpcyB0byBjaGVjayB0aGUgYWZm
aW5pdHkgZmlyc3QsIGFuZCB0aGVuIG9ubHkgY2hhbmdlIGl0DQppZiB0aGUgQ1BVIGhhcyBjaGFu
Z2VkIHNpbmNlIGl0IHdhcyBsYXN0IHNldC4NCg0KPiANCj4gPiArIH0NCj4gPiDCoA0KPiA+IMKg
IGt2bV9jYWxsX2h5cChfX3ZnaWNfdjVfbWFrZV9ub25fcmVzaWRlbnQsIGNwdV9pZik7DQo+ID4g
wqANCj4gDQo+IFRoYW5rcywNCj4gDQo+ICBNLg0KPiANCg0KVGhhbmtzLA0KU2FzY2hhDQo=
