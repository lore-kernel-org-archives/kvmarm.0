Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010006.outbound.protection.outlook.com [52.101.69.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624612ED870
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094732; cv=fail; b=uIOi2ONIwwku1u2b3TxP41tUDEIyB61dH1Q5yAt/Dpv6UzaBeVFMK9ULGmJG+P6U+Lg+iHG9Lwc8EmFITCpMM8abj84Viphs1zV72m/+M6Iy1FPR9x/sDeu3aY29eIq3avqwbfcUEqtiVPTw1e6gK5XpGf6f3BtQM63ZeNJe1oQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094732; c=relaxed/simple;
	bh=OYZQHVg400XN26sqOG9l9AwQh7+KzDLWp72H+6Drdsg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U5cYz5/hsd6sodtXUaHq+e9KSYEFZckAZYsBfeTN9rqTPiSoKquY7BsQ1kXpRgjry61WE7mC/bl2fZdMkgaNkfJpjxa2zNgopSmODTGwNxm6Nf7OmZzCn1pPguAsbF7XYjsYd2CBjzxubYR4/xFsuxOuvRZUy64de6fQrgN60Mg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PWUFdv1j; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PWUFdv1j; arc=fail smtp.client-ip=52.101.69.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PWUFdv1j";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PWUFdv1j"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ea0Yk3jq59SX7cYA2JjOSXCq51jOSk7luIylEdam7o391Qsh4QNKQYs10EGOzVJ8l5JLliR6/isVsDirnp2yngZHEZgM4wOkP0+ChNcpOkBmJUd9iwYNyPkXx/3ND4FBVkGOlbT4fTn/41wMcD0ntbJkAyoUG84eF5cFsv2TMpxKcqcnVy5wxZTSpa09WNTv8+yrZ6vx5Y/sWDg3lFpqOhkxhrbKc7yflxFoV/shXz2bGwgfKBln9hBepMNSkifKqJCf48X/NtOuFDLe/qk1NdDbXXa8SJXi23N6lEss6mZcPuswS0U1H75Z9Jco/fRPsPtgFPAE3ycti7nwaSe05Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJXPhOAKhV0AyrE6RSIIE8nbUDwjYHeisxFCtBwl1Og=;
 b=DUeOzqzd1RwzU3+i0IBVoWotsnvsdCt6rQ6xVyyTo5Iqp7L4IJkoGokQImeElfgGmavhAtrMLV2xAGeAaZ3p5mOYe/+QNO45hpQIvX1TgpmQeMekPriJ+DXCMlbWqPl5D+DBJXw2iFxmMjQDxHNR84wXcKQ2Ke21qyi7vJpejEoL4H4act93eSDL/d+oa3F0zJ9MyKjisJp90s+P3nAOBvXsBg5SsF1xqYLONV/eGnh2V8jg921TCh2AhRcGXj5GY2TOepHM7NdpbzZYJH46Wt+TLMyF5NqRSO2esUEGjIwCQ/cPtu7K6ZX5n1W1An2jby6LmpdaaaWqKdkoLF57HQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJXPhOAKhV0AyrE6RSIIE8nbUDwjYHeisxFCtBwl1Og=;
 b=PWUFdv1jJVoEdHZiSmrGcq6Bt5SmjvvCDvRYgGfTluafvqpD8vSJuMBS+FqOtTHJQkLsJC5g9G9f38gG6mtsdkY1g3OuRQByaDYOgrlDHTYhPlJa33LQ+YikOy1WTG9+wGXmr4utKdxD98LFZICp0f8KOEBwgJ4kIPo/BcjCSH4=
Received: from AM0P190CA0013.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::23)
 by GV1PR08MB10643.eurprd08.prod.outlook.com (2603:10a6:150:169::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:05:19 +0000
Received: from AMS1EPF00000049.eurprd04.prod.outlook.com
 (2603:10a6:208:190:cafe::c) by AM0P190CA0013.outlook.office365.com
 (2603:10a6:208:190::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:05:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000049.mail.protection.outlook.com (10.167.16.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:05:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pc5CnFMiPPz7SPwugzFaUP2okMx9d0g2wYZWglSZtzx8HcPK13jRV3e9L7PGQJJD4XYHZnftkA3MB7ott3ccvk0Z2a560dIk9dspr1V+K7ymactr7lRMcoro7ninyecPLDtBVnkiNSYfaDwXETpWohyhIDUrcras9SxG94KUbefvxByiBpJMCr7X03Ro31HPjjNfariGJ+6Bex8R2DuWvVEu2EzOPoSBdL3HRC3iQI++wZ12DRBVkYwPrKGxx4IDjxK6aqE0q5ufEt2fGSOjXp4ZerSohn+bsgu1POFstDjVR2OWfRPk3lDIpRXsE5/Fwi2+RRl9HF5y6H+7NY+wMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJXPhOAKhV0AyrE6RSIIE8nbUDwjYHeisxFCtBwl1Og=;
 b=hTulxSKp1X6l2cDFa2k4vg+OFmdnPD9ZCcA6kgJVV9Swj/wJyHk8e3juD6kqVlVcpuMBBfrcLA+duv3iDR43cdI+zgf/A5iA1p0Fc4SIioW+4eIiGmfMWJDhjxzF4FCg1xI7YvulneWlbORQt860nV3jG9F1nJagxzppFQSJaSduMM5jFUffDgJUL7lAJh2Un8uvx55y/JfZbhz/8ThjVZa7Nr/svZMvYFfZmGfSt3c+Q41mAJxjVi+J7fwZzU9SfIAMjAKijRCJeRUtbwihvom30YqbvpskoZ4lg6YjDXGf+VgO5M1trV+Y4AL7IJv5mMntJqUuXSVzF9Xr7Jhk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJXPhOAKhV0AyrE6RSIIE8nbUDwjYHeisxFCtBwl1Og=;
 b=PWUFdv1jJVoEdHZiSmrGcq6Bt5SmjvvCDvRYgGfTluafvqpD8vSJuMBS+FqOtTHJQkLsJC5g9G9f38gG6mtsdkY1g3OuRQByaDYOgrlDHTYhPlJa33LQ+YikOy1WTG9+wGXmr4utKdxD98LFZICp0f8KOEBwgJ4kIPo/BcjCSH4=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:04:17 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:04:17 +0000
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
Subject: [PATCH v3 27/40] KVM: arm64: gic-v5: Track SPI state for in-flight
 SPIs
Thread-Topic: [PATCH v3 27/40] KVM: arm64: gic-v5: Track SPI state for
 in-flight SPIs
Thread-Index: AQHdCwWZkCP3nWVP5EqWIWg3Go4KYw==
Date: Fri, 3 Jul 2026 16:04:16 +0000
Message-ID: <20260703154811.3355680-28-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|AMS1EPF00000049:EE_|GV1PR08MB10643:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d7cdb3f-fed9-4946-c5e7-08ded91ce145
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|6133799003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 wU3rjo28sX3EydorbYZw+3Vn/ypIGLfzxyUpz1CGvFdNvGXIuPb5t5e9o9pIqHthQHCoA1lJ4MstJKQdAiRKxbErFqCGrPCs04IWXVBVjZEBoOpf66Z2j1NHaXHQFhPDDJpycV4azGHF0p0Tq9gkOedtoLr5Vfl6IKboRKDBn8u2RBdvPGNXCbb+nteaZwOUZIhUQ5Y3i1ALUOSMo++lYKmOZqsaAmrItPa2tSaRDt4u8/ZamM5AqUcn5Zz+01eGuZcoZto4vh8cxnOO7Ru38LZ5uYqMxdOsnO0+0vVOCLyvjnspO/wD6M7kQlnZGE67y1XjpF3wtVN2SqRRmIKrq4vEK7bQhB0uzVPptmNNXYBNuc7MxCK1RQEyb42MKpa4BMOPgQkNrKDlQs6b4HeotWJRU5QsSxpibdYbeKU63Zn9k69mUOjlNBpD+hdbS8KbJhS+nr76kZKoGeKWnGu8nlrhUUMkUTaip5DrOJqO9cl+eTnVbN8fDpyHRGizKPSUlY4azpP7mErAkBiTq4UATrSzNZ+E17ajrdH8mnj2vTAvK1Jlxdb24r2t191+P6h0TrbFVV41D5sx9sH4UCGFQNM+l5KMhlW0nw5LpdujRzQ1nCSProc+Snh2RmyNfOUM6c69+CSRMnaXOCltniDL+0OuLbQS5i0X9BJN1VIIfHGbNraYi9jWiKh2Z+a5/yVxy2iWTc0xZ1W4j10v/qnOytWUlMVRr8ApF257h7BCMjE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZmvWm7GblfG7jmgE0+WNGj2Tru/UCdQZAX9Xu72FGVVnpMlCW77GIbRSHPzJrHaFm/hFmrgAuIhFJDI7MlZ4DSIw4acWdgari/kuMAM5JA6e735jwenRGJH6I7erB8ULiK/CgfH6y+M+52GVXkFxrC+GmbvnGUk/zFK7PMiiuk9O1uSyDa3JE0gOCQeyYNN3WU7wy9fdjU718PMrJztY52yoP/dMgHzcux5knpGiaSKj9VazSU9I8fRuJNH4kFuZXqo9bcOgqNQ4+znygnhAqr2w7AEw6Y50LtEHMv/OkYeONraL02Pm2vqWMGdSH2oSuYOeCbRGl0jG781x8OeHfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f831fdd6-8aa7-4321-0a06-08ded91cbbf6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|36860700016|14060799003|376014|35042699022|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	TbDqQCHiPC+iuRbg+lH2LbS67HglJux/f3nW1FcYRITX8Q/FrWHENE/5c/REC+fwymWDLMYNPqepnwYB9RVWtbb9+R2irnZ/S8ita+581q0BeuvZU8zC34a12OycYZLOT88JwG/RkAM9amoxDEMq3Oax7PB2B+ZLdMCxzv/WV1zLPgZDzREvIScHh8O2pDtvl25muldyGsunplGzMAagumRndJpSofSmi5qEp4ueeXHIBSn7vfJ2wWmow5/3gK5IEIlZw+sygQwlvgQ6M2eXvIpIsWEN+u86Z2P5xVhE786BCSgTxq19Hzfna8kbzih2242TytZLtlsHlZ332BOxUE0bea0gDO4t47SzCHEenVe5U+Otix79bioJR+oTV6e6yGIXpZRN75xqqCRDj+/FTYtOd77hCAWklTYSkUybOo2UWE/s3pFV8Cq2yXGIag+SoAGDG71uFfSJbUPs3+X0h8zfOZHOEAvBkPhxAbKW47ENF2vI3yPQEJ1RQ9cITflRdqlzzi/5/uKAgVc7/3FFIqgznk0R9XW9IMwAjB51owuW3dNA7zqOS02cGaAcbpNEsRMHlT8UXjMLv5+jwV0g9aJ+I1jp4l9+NfZDfu3b4+28O9Dnu2CLX4aOpfCaiINOUzA6WSkl3HsKg3RGTBASuNvRyQPSykhvndE/zxKmQop0aPTl77w+/Xd/Z5cdULFRBoe9bmiJ6HvkuHoCLQfxDQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(36860700016)(14060799003)(376014)(35042699022)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DHcxhChbFCaZWAMHYTF7LHeBddvXwVdT1gx9kKJZUSWH2abWA8j1xUusOWQO+CIfcvbOiYwx9O+sRL3St3dicaIAnNweV3tGPSNw+IBGmiend//iM/R8CibojqjtmTFSyhnvelvNxkHKMxu4jvHQqbUz9TYbP6HuHVQqPY4Rd0QmfBG1egBVbGtbvpkiGfPkFgU3YpgCvY6tbSiI4y/u46TtbmK1otpnPKN6udeg1SNlYnbTdwcgxvBMcGUk3YAPCaH9m17GvxDmtRzq7pUiQptv+ABUeBfZbbw2mjGDfC7EtGA6Z4Fa+0v4hcwbdrWwABmTbSrz0UDIHNaHilPaRaKV2HfceS58/vdt5NKbozFclEZwCyfVokgd3y7e7e36T1iUfuQGlUbKiSo+LjO8y75uSext9zuGRq1K06XvlEtPPIPW5Jcn7s3aUPNk3OS1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:05:19.3918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7cdb3f-fed9-4946-c5e7-08ded91ce145
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10643

GICv5 interrupt state is largely managed by the hardware
itself. However, it is possible to register a notifier for the
deactivation of an SPI, and hence KVM is required to track when such
an SPI has been consumed by the guest in order to trigger the
notifier. This allows the code that registered the notifier to be
informed when an SPI has been consumed and deactivated by a guest, and
that the guest is ready to receive the next interrupt, if required.

As part of folding interrupt state for GICv5, which until now just
included PPIs, check the SPI state.  For each in-flight SPI (an SPI
that is on the VM's SPI AP list), use GIC VDRCFG to retrieve the state
of the SPI, and track the active and pending states to determine when
the SPI has been deactivated by the guest. This needs to happen on
*every* vcpu exit for *all* vcpus belonging to the VM whenever any SPI
is in flight. When no SPIs are in flight, no SPI state is queried.

When an SPI deactivation is detected, kvm_notify_acked_irq() is called
which triggers any registered notifiers for the SPI (and is a NOP,
otherwise). Additionally, the SPI itself is popped off the AP list.

NOTE: there is currently no way to query if an SPI has a notification
requirement or not. This could be optimised by introducing that and
only tracking the state of SPIs that actually have notifiers attached.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 59 ++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c    |  2 +-
 arch/arm64/kvm/vgic/vgic.h    |  2 +-
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index ffb0500a4c9a7..20ae7daf4c451 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -984,7 +984,7 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
  */
-void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+static void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	unsigned long *activer, *pendr;
@@ -1056,6 +1056,63 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 		    VGIC_V5_NR_PRIVATE_IRQS);
 }
=20
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_dist *vgic_dist =3D &vcpu->kvm->arch.vgic;
+	struct vgic_irq *irq;
+
+	/* Sync back the guest PPI state to the KVM shadow state */
+	vgic_v5_fold_ppi_state(vcpu);
+
+	/*
+	 * For SPIs, which are on the global AP list, we synchronise their state
+	 * with the hardware state. If they have been deactivated, immediately
+	 * pop them off the list. The notifier is called without the SPI AP list
+	 * lock held to avoid deadlocks.
+	 */
+retry:
+	raw_spin_lock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+	list_for_each_entry(irq, &vgic_dist->vgic_v5_spi_ap_list_head, ap_list) {
+		bool pending;
+		u32 intid;
+		u64 icsr;
+
+		raw_spin_lock(&irq->irq_lock);
+
+		icsr =3D kvm_call_hyp_ret(__vgic_v5_vdrcfg, irq->intid);
+
+		irq->active =3D !!FIELD_GET(ICC_ICSR_EL1_Active, icsr);
+		pending =3D !!FIELD_GET(ICC_ICSR_EL1_Pending, icsr);
+
+		if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+			irq->pending_latch =3D pending;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(pending || irq->active))
+			irq->pending_latch =3D false;
+
+		/* Deactivated? */
+		if (!irq->active && !pending && !irq_is_pending(irq)) {
+			/* Use raw SPI index without type for the GSI */
+			intid =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid);
+
+			/* And we're done with this SPI */
+			list_del(&irq->ap_list);
+			irq->vcpu =3D NULL;
+
+			raw_spin_unlock(&irq->irq_lock);
+			raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+
+			kvm_notify_acked_irq(vcpu->kvm, 0, intid);
+			vgic_put_irq(vcpu->kvm, irq);
+
+			goto retry;
+		}
+
+		raw_spin_unlock(&irq->irq_lock);
+	}
+	raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 169a8664322d0..8b15938464ab9 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -853,7 +853,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
 	if (vgic_is_v5(vcpu->kvm)) {
-		vgic_v5_fold_ppi_state(vcpu);
+		vgic_v5_fold_irq_state(vcpu);
 		return;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 282278e4a6c19..7eef8ece52dde 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -372,7 +372,7 @@ int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
-void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
--=20
2.34.1
