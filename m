Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010043.outbound.protection.outlook.com [52.101.84.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C484B42AF81
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102514; cv=fail; b=PEdJi6uW2YMM5uQF7YiTdMAL7n/5FBcp4SBeJmcXhDY5zfpnSa7LbDh/JlWjoilNReyCiMKIkQVnYbgwENqhKThO9XScQ78OsoysprXB9zMVibN9ziHbd4F73W+mzH8u89wa2UWTDBOqvUHdGERtbBPhNG/8y9XYeKrX5F4DhPQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102514; c=relaxed/simple;
	bh=zTBaEZDtjBtq49ZUJWYwHmANow7W5kbZQNU0ddoqiN8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YUYpUO3W3Ad3cIdrGnWEPL7kYKrJdsw1ozYyNKKABwX+AMXVsV4DH1VLVcRikpqwgTA2LvruzTgKKFvSsU9J82BZ3mwmKs6HTpT1HO2LYcWGnGUnqWG0tIwFDda401iXK7agZH9uaZRNr9pSkCeLkbHu1kE5StJ3iT3RrH47CDw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h4NDhBf2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h4NDhBf2; arc=fail smtp.client-ip=52.101.84.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h4NDhBf2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h4NDhBf2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=L7HwxnIDOzQll+sbB7xzGjBqQVzp9QfNOb6EOLLK2sl6Fjcil4q0NOf331Ruo8ET4SvtPlejr2QqBbcfbAbrVPzt7xB81OgaBqr0h98ov1YMvQyBk33Y+9QP6i7ytf5fEU6mseFs08axCPdBNePD7ISQKlvs5Hzk1Muwb8lb+Og0OeaBCfX1EXjgKMDKbwiCOkfNbSL0t5ibdJqYvLaLydxXBHj1b9Ln5lN9d0GUsrSaK/Shwqhh9z2dOqYZhpwlregkeFu57jeR2Slktnmlztb0+O8dcjnMr4pyntXMtQXq8+GfQoroQSo+IG7fbdVPgbEA/H0/dq/cX/oOKdwJ2w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltAlb6S8U9sGHR7UNXjN8d7xlLT2YRuzjVwqvHXxdXs=;
 b=GfwvtwLwAnS+iUr5Bis7ad012Ri/K/eeal8AYLQFg+mVvzjHwZ0dJEyMXDQ41w5ZVyIPIrtgRDIFdJQHWbOCiB//b3KUtAmoYYN9ylK713lwu5COm62UgjL+IIzUX3/GVpacrx0R48cD1xDXqHpWleYqw5lqrcaWdJBfeil+efgFhFz4Jwadl5xmpgbghs22LxEHvUIpyPZMzALJL1LT8S5ZYutq0ztXc61SCzmXVWuHRJm7j+Tsd+/fCGsNLscJ37cjFj2L2tp7+ur3zZ2cNmBykZzXyqbrGQsj7gBv9Ij5JvOhliXeNFoygUeDIeiyUPP/GA5g/RkITIRsvb57tQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ltAlb6S8U9sGHR7UNXjN8d7xlLT2YRuzjVwqvHXxdXs=;
 b=h4NDhBf29bARUhhNP5aG2X76wtEVmk4saRpW4TNjWh5EnY/G6yymcqBRz1czaeXgQNGkbb3/ek7O2IPIplrhQ3ZNvhKwSuLBuBwS0+q89ghqGw+WyCDXmKQ+SUcft3bVAOC98958d8HJzvEO+89IV6xZ1yO+s9u9Bf4BS2e1AkY=
Received: from AS4P190CA0003.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5de::8)
 by VI0PR08MB11043.eurprd08.prod.outlook.com (2603:10a6:800:250::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:35:03 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:20b:5de:cafe::43) by AS4P190CA0003.outlook.office365.com
 (2603:10a6:20b:5de::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:35:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:35:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R8goZy1eu6wOsEu0GIGlWKIPJg1Ncm6o67yhRTCAXQZLo3CSBCayC0q3U9zZniF7RzuIAZEFb1L0TKErph9toKVO4QTigAjJ0ygSLYl80yWCFkg9qEFuGOArV3kbVTEAEd004PlZ9KOugrc0W68Ad1SksyConuWpeHdLEEXO80VviM8e6kwq7Rwb0Wu449YkWdmiRdLUsR37g6EY7sdoMDsSOEfiityD8UVg5P8LDeW5LNOfwqXMPt+Dp8aD+4Kcy4k6KkSkKq7LhjCNvP+uUcauE82DFYmoFLPbDIOy3ecsu/cXI7jeq1VaHLuVVU1hll8lS51CUL0fI8tYfUzQqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltAlb6S8U9sGHR7UNXjN8d7xlLT2YRuzjVwqvHXxdXs=;
 b=xF7J+6bftMeHIpd4x8JdY7y/wltMVZ2FNLgJh/PlhAvyXpjTrqgwpLo69FP0pDGx+vHelq1ykk8evvSk0rpVZ8jVe2HIs5/mfJ/KeLokgwPl/f9+nL59Hu7D20tYrEhYv7bRx8LsoMnH75BUat7aEh8A3pn9Tw4kkj/Xi0Pv89t5BIwvBnlDvvO1Lz2nXSiqQmMxaZyZLecSJXJdflw3Hd6Kb/v6fp/KQq+gEnS3uWgKIMCbLimJxKPDuYZpM/m0wV8/WUrd0bc+YfnU3VYfmvmEB72v+JNDbnRJZwJkuX/7OQ/el04YjsteVw7BMF2ULQ1JnYeUFHv3cPPZWRM4wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ltAlb6S8U9sGHR7UNXjN8d7xlLT2YRuzjVwqvHXxdXs=;
 b=h4NDhBf29bARUhhNP5aG2X76wtEVmk4saRpW4TNjWh5EnY/G6yymcqBRz1czaeXgQNGkbb3/ek7O2IPIplrhQ3ZNvhKwSuLBuBwS0+q89ghqGw+WyCDXmKQ+SUcft3bVAOC98958d8HJzvEO+89IV6xZ1yO+s9u9Bf4BS2e1AkY=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DBBPR08MB10793.eurprd08.prod.outlook.com (2603:10a6:10:53d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:34:30 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:34:30 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 43/49] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Topic: [PATCH v5 43/49] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Index: AQHdJmC2Y/buMyzCwkGJyNAFYsbMpA==
Date: Fri, 7 Aug 2026 11:34:30 +0000
Message-ID: <20260807111159.429128-44-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DBBPR08MB10793:EE_|AM1PEPF000252DE:EE_|VI0PR08MB11043:EE_
X-MS-Office365-Filtering-Correlation-Id: 906d8f8e-dfe3-4e65-2d6e-08def477ec23
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 xEkGR0l+0TEDZ8tNoZYdGHTrf1xW7RGZCLKOkiPtPtAnRt/RTefHqryFkQyv8nF307n5Jrh6tOGZ9LrIX3+15tNdjKz+EFqEJnaRAO7itgBCSzIKphEW20oW5E94G5d6V4Gv1Vo274XUEqpJTVtcap7MTw1Sx9m1svRPDAb7DIxfRNiVD8OQv74ESLYo58BuGF4rIw38NDuDQwkLlitaUNCSQDdsTS6GXXXHAGWnJSuuyejfrTXVKeFS1Ttzzq7gtHIqmXmZDWK4J3CaFAz48EQgP5C5zrtWruY71egysFI6ud0ado7wKMIbdd27Yx2cBWCaEa9544gNNJGWkl1o9ws50FfJbNcb2YrTxHnpxSErtZctp3Xv2vCtKTSmiokqvEWAe2N1cKqm7hMcZrXu7oTOx1WiaB9mUD6omFjUj8o5Q+ms4jiFvFvPB2iWev8H41hA5T4hb6s1pgvKd0/488nBk4MECE52soB2k7G+fRf05w1ZM+gbFkzDBEz94+AzkgXCIpULG6Mb+MyXDyEJdQeWCHWAzQ2pcQzlTqLEs2w0ZvUFHSraP/MV6mYEzryMBVeoW4vDCijZNXuX+USfycfmRRLjCOg/A+hDMgWX9X8Nebv70cqj51FHyCuq40hP36DB2bMOBr9NfyHEeal5Pap/XdhBD3lQwt7FMhGiC+yOJROlsLqdsVAl/74sVIhZVaLaPHV1hmMWP+pFnxCtizbSA17HKkZiKluzEZq1+04=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Zfb0k61RvcVg4jsVZdiKFjzWFiTF0rEn5TqBnd+JP2Cstzints1zv7b+qjzPplLqsC4SGeWEP5PX1iMV9svQuGbkcijApjYofcZAboH2eqDY2eG5UiDbnmwK3rlHBsbs6+jxv+39JlSMez4yzmtP25kyzDC5/oagJwS+QBx9kC0DRdg8eaOEr3AelkBgB2RUAbd14kwI0VBWWf+V/Nna6q6AF8xvB5lrHAPCA/E5ottxgNox9XBX/t5048/DIvbUqLKIDutVhxBKMDLO9ax2SEV8v3qCaIIdM4cpu43fQsl2evOSG3wvV7Cq2DjXo3/cIjlVSBvEkiMDgxNOwrULCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10793
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eed0959f-fbe8-4d69-5f36-08def477d8ab
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|82310400026|36860700016|14060799003|1800799024|376014|11063799006|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JooMEoL5psMYXU1DKqINHCDxOcISusWch+8YFTDkwnjW4I/gj19t8z67NhhYMWrd2EQ08jisQLRUp/eAcfiRdhaqzOAZExJubM7AaWFMJgbTvJqlxML9VJ+5oP3cZtNpBprlkPUYGNUi3Q+BlUq/oqCiOnzR1rt+So7QJZjcMOiybDDOy0JA/flKGMgeuIrGkNyAhRV0pSEaDDcmCfQeEJu3VdhAHci4jKaxIAGGCfL9EHHMsPl2qdSKBDVSdQIKO378nt1+ufbyxEhS4s0gtHpSeL6s9xiiAr2sdEQbiLP7+r91sNzpYGt89whyDnTXnja3W/zc0LxsLehuEh9WCVcOt+z3vUJm7GVGWDibmWymeDYF1lKwdZTIn5SIuScD3vZ8miN8y1kAY/e+U75XT2ODakBQ2pnHacI/Fs0UiO+7eJkBUTf6eY2YPSLXQok8JIDBrrg9EuA1pb07IDkRrF/dv4ciXOxMZk2v42JtaIytGGlVQvj1H7/axzziJs4PYq3pndeWUdl/bB2SvOw6UPGajX5nGW9SKC47xeRnvvH/nPv5p7SL8HWHF2nIy5wxNrtqmC+GAyCZL9AeaMVNzwPLIuW6oJRmTaDVKwfiaBJcxUE3UtV7vZdia71Wddko4lef4yuqosYDpnqxggWwZs10nsKG4EpeUoZOq1dy0VB4vs2v5axfoc59vx1k6FrYJ9YxzRIMO6CJUIpaU0btVQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(82310400026)(36860700016)(14060799003)(1800799024)(376014)(11063799006)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WfYzwxtwEkUOv4/pJ1sF24fkPYsMb7pcJzcx5bZeKjWJ2Xbf9g41W4/1PsBT/Wru23njD25m+7tHiidLYndXNuYs5kQH6u9Pk8xI3aJSnmINPVnQ5A9bvNYVlX4dE747tKJ/RiBECLIKY4UJnXg7yA7PiNdcpwCamI0PV4QDbCWYRCy6ctWvJAZ9pEnejLPfBNhgbyBuxwswiy4o3H8V+dJ6ADCqoITxAg9fCYoeMvz8pcV/aXKL9DXQ/mjXWF2d/PVfsy5JrrCc1uhTpleJ4De9hsv8xi0bnlFaLfBP1ytY2IzAb/nQNKApl0O58OPI5Sy4pCSNDXxS+fOnANzy5S6gQZrd5cLD/HGgUrR28Z7tr1JwP+xZEm10jtBsTBMzrZ/rChYJCi6vWO4TOBGVr0bki6Omf1tcZt5H/Ji7NyFbGvvY/sv3967ksvHvt30C
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:35:03.2164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 906d8f8e-dfe3-4e65-2d6e-08def477ec23
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11043

Add API coverage for the VGICv5 IST attribute group. This does not
test that IST save/restore preserves interrupt state; it only checks
the attribute plumbing and the cases KVM must reject before the
end-to-end restore path can rely on the interface.

Verify that KVM reports the IST attribute group, rejects unknown
attributes, rejects save/restore before initialization, rejects bad
userspace pointers, and rejects IST restore after the VM has run.

Also cover the userspace IST descriptor validation: a VM with SPIs
must provide a SPI IST buffer of the expected size, and LPI storage
must not be supplied when no LPI IST is configured.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 122 ++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 54fa13906990b..e053b01bb5be3 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -31,6 +31,17 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
+					       void *lpi_ist, size_t lpi_size)
+{
+	return (struct kvm_vgic_v5_ist) {
+		.spi_ist_addr =3D (uintptr_t)spi_ist,
+		.spi_ist_size =3D spi_size,
+		.lpi_ist_addr =3D (uintptr_t)lpi_ist,
+		.lpi_ist_size =3D lpi_size,
+	};
+}
+
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -523,6 +534,114 @@ static void test_vgic_v5_irs_regs_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_ist_attrs(void)
+{
+	struct kvm_vgic_v5_ist ist_attr;
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u32 spi_ist[VGIC_V5_DEFAULT_NR_SPIS];
+	u64 attr;
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST, 0);
+
+	/* Check non-existing attribute */
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST, 1);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST accepted bad attr");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    1, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST get accepted bad attr")=
;
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    1, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST set accepted bad attr")=
;
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
+	/* IST save/restore is not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST get before init");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST set before init");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* A VM with SPIs must provide a userspace IST descriptor. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted NULL desc=
riptor");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted NULL desc=
riptor");
+
+	/* Check bad userspace IST descriptors. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, (void *)1);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IST get with bad descripto=
r");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, (void *)1);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IST set with bad descripto=
r");
+
+	/* Check missing and incorrectly sized SPI IST buffers. */
+	ist_attr =3D vgic_v5_ist_attr(NULL, 0, NULL, 0);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted missing S=
PI buffer");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist) - sizeof(__u32),
+					 NULL, 0);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted bad SPI s=
ize");
+
+	/* LPI storage must be absent when no LPI IST is configured. */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), spi_ist,
+					 sizeof(__u32));
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted unexpecte=
d LPI buffer");
+
+	vm_gic_destroy(&v);
+
+	/* IST restore is rejected after the VM has run. */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, guest_code);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 VM before IST restore test");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST restore after run");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -645,6 +764,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IRS_REGS attrs\n");
 	test_vgic_v5_irs_regs_attrs();
=20
+	pr_info("Test VGICv5 IST attrs\n");
+	test_vgic_v5_ist_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
