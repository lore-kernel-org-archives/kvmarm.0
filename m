Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D654772B6;
	Fri,  4 Sep 2026 10:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518762; cv=fail; b=bAHawpx8W3qI9jI/Uqc43j5AzAS5HCdUG4Ykq7tibIt+gHfgZlhUZjGMOEwHYO55FVWtS34/6/FUnsOWfmkT1Rd7XJZV+vIi1pWv5zBulg9VaX7GTSrWUjfT/VohDWfl4Go1NFQ51jOZNt8ud0+d0UD7qleyUm6YfTYsUq6QVpI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518762; c=relaxed/simple;
	bh=8zUq7XjZByRm3RUfE2UZ+O5m8HpABhU7wTm8dlAYKcs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=df5GGtF5lgmwtYyhYkvIv+9rlxhKF4eSNA/wD6m2qSRS79196KV/bpe4PeY9vxdgowUcPD5NVqA6CC9t91a9CSJGxi1RbxIXtGbUxo7feS2pjvODfKUQtld9q6w8qvIINoZJKyzv3sBU/8TjQ+LIJoXwVCRotR8HMwkjaz/EDVI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DuCc9zWP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DuCc9zWP; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DuCc9zWP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DuCc9zWP"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Zh18JAAKt0HJ009mcwDgYO90rU0pmsZleZY/m1z3dgOj+ZkxImRgscoaStt4eI1lsyA+HUKc2TfBTYFrv9K/RGgW8rdf7SDzjVFqbaACadn6fLZq2IMGkI6oqdTeLfH7BoOplwum8esK2ntHyjvesRDDvHw8EZEJNk3+yNIdQbol6ar5dSW02S2WkI7j0tz9OO/2W75q0KuvNhQT89chzgpCEYvQfUYnvBEDTdMmp8ZOEcXAvzA5iU7ijYSZ+cKfADCVlZwvU8vA38Aejj3tSBxBBWazOG/dR8xwOmcM9/PjMVDrwKk9X6K0Lvpt6S/fyyrsyyBsTpAQcI5EV/mRpw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zUq7XjZByRm3RUfE2UZ+O5m8HpABhU7wTm8dlAYKcs=;
 b=EFJjyjP6Kf3+adyKFkP196W1e7bkLZv0wgpjheTDBtTqxoJ2MlE2sIRuKcBUzpZpLhSgkIFgGkpvsW2/FUTJpiY+a/p3XOEBrAPWqVeFqt1GM83w1DuUhEu4vITc4jGvd2oCdnBBkIbSkIhanb/we2F0/8/HDkbz9yfIMdr0UgD9FfecMPTc31xwV6LjMmqLcMbxGiDy9IwKTCuEgQMdlCJ27M4o5+uOTyt4+pswO/rsd3IxAdxwGnIq8kXInc2/aIzB1otcl9ENnssvBROReurJVuU2UPXpZBK4tqhcxOai6IpheljeX2fP0PbxCEc8tjDyoJgJo9mJCkyfMdGcyg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zUq7XjZByRm3RUfE2UZ+O5m8HpABhU7wTm8dlAYKcs=;
 b=DuCc9zWPU8EmdTni1eRjlkuKV1pdKtUdO77xvxE3ScL9gx53AaHaNtGfP/nDiOxvgE02zqNHaHWi301NjcD3CcDDTaGcuMzTKWj9J/hMMwL5VOw0lbv0FY89EikPFdA1/ofrwAhJRtbAGqVR7G1dXRePT+GJNqEEetTyiExYjaA=
Received: from DUZPR01CA0113.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::6) by GV2PR08MB8389.eurprd08.prod.outlook.com
 (2603:10a6:150:c3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:45:53 +0000
Received: from DU2PEPF0001E9C2.eurprd03.prod.outlook.com
 (2603:10a6:10:4bb:cafe::46) by DUZPR01CA0113.outlook.office365.com
 (2603:10a6:10:4bb::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 10:45:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C2.mail.protection.outlook.com (10.167.8.71) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8 via
 Frontend Transport; Fri, 4 Sep 2026 10:45:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jKigVBMUvMWcvq8ZUArwHYliPIKe5czim94FY1ShoPhnY04oz8w5JvVZk35ity/6ZxJAeUmZt7Z6P/qABUNFwwR9FnfzVbpfwFGg0/AC7nNnYigNZjAtYW1/h541tv7CWi8bdkoBZsx9+/ZE3OP9bHUneLzz5VT6nxjN0rHetJDeM953y8qu/Q2vJ/0Pza6IWbRaLPill94dLvF5RPpO+Dn3x84zHZjsVn/K+EntM7YJFF8K20MgtOJX7fVeOEBJ9tEB7wvAFYAZtIMWvOxmMwZDU2A5JQix4gAPg/AGrQQv2Q4PqvWpdXjHXljJ2m36jygsGTm1r6w69O0qgOcudw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zUq7XjZByRm3RUfE2UZ+O5m8HpABhU7wTm8dlAYKcs=;
 b=AYEwLqD74ZJSwNnwfy4Z0l6+8gHKRUvh+olugGqUTuwaq70J2WZJ13gNHeZWlBbyI8QulhSkfSKc03KZ6jABOzK5sxvI807Ed/7q2OBi0xrX2zOFvAWP4UMVTbfo0INQLcY3iT58+5H/Pdw8lyt0CLT+TD6bxqlO3EbYL2ujGmWKMJryLFxAw6225XHweYqLc10wK200pxvhvbXc9fTuvPsGXV7icMPDmGUOrHx6e9ItVWT+3crYtcZIXDO+xyJeM8ndSlymhdrnJ8FqXmS5VB3FjuQIBZCOKokHHyD/upNkBoBPob44P1F9oGAtXLkZnYyo1GoNjqVKtcbyPrNs8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zUq7XjZByRm3RUfE2UZ+O5m8HpABhU7wTm8dlAYKcs=;
 b=DuCc9zWPU8EmdTni1eRjlkuKV1pdKtUdO77xvxE3ScL9gx53AaHaNtGfP/nDiOxvgE02zqNHaHWi301NjcD3CcDDTaGcuMzTKWj9J/hMMwL5VOw0lbv0FY89EikPFdA1/ofrwAhJRtbAGqVR7G1dXRePT+GJNqEEetTyiExYjaA=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DU0PR08MB8471.eurprd08.prod.outlook.com (2603:10a6:10:405::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:45:21 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:45:20 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 43/49] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Topic: [PATCH v5 43/49] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Index: AQHdJmC2Y/buMyzCwkGJyNAFYsbMpLaS1YaAgCuSrYA=
Date: Fri, 4 Sep 2026 10:45:20 +0000
Message-ID: <27e221504029314920510daf6e02dd49851a4327.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-44-sascha.bischoff@arm.com>
	 <20260807172111.9ACBF1F000E9@smtp.kernel.org>
In-Reply-To: <20260807172111.9ACBF1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DU0PR08MB8471:EE_|DU2PEPF0001E9C2:EE_|GV2PR08MB8389:EE_
X-MS-Office365-Filtering-Correlation-Id: e776f5f4-c3f3-447f-0859-08df0a71b190
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|6133799003|18002099003|22082099003|38070700021|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 VmlQy4c1eq6RsZ3JLoYjTeO2Pet2KbFfnu2e158cClMGFbjYV6Gl2eezWrGQP/CWSldZT/OreGbhGX0e6fmihv+T0mE2hOTdzRDWAwmXcDlcIzC4KSCHTbf2FF/TLncsoQVtbBQd2OR9AV4bCm2wK64dEhB75TMV4eVsrEc2tqeJHVwYBKL1fxNxyJXwa39JKL68MAFXbGIceV38J4wpmOEvukN8NWCRb+uZiEBf20sU1PY4t+odSno/LkQQEoDYJB7bdEqVuRjZ7AOo4LnC7r8vJJJ4jJXX0Eg77H6hEvMhlj8eUIbgl7Z8XGn8lfmiXXhbux6Ux0VG58Hk3iA/YQVe5eiFDpbB5jab4FkAXtpbiu7yg6emD/kRc5QKniJU41ihH+EPB5CI0+99S84daGDbbXXXlDXS1LkYDJZRxv75P6uOj5Cl6URgQSPxfps5lYuV972Fuhmi0ZJncwUkSdI1pjpuEgBGKrIYaDWwaVRBDg1pvmZyTWZ3rHxr8yLX6coHa7ej64wEa20rFlnkhAnafd+iSqf/f6HgBphDAMa0zle+1Y9NAAwqqOyWQwpaHlqQ0F1Y168wM6LC5Xfl52o+8prxqZ80TdhW+W/ZrJhJPcwleaJeobb34qIiMfk0MF+3VRlVyyItohOwYFF3Hb2tXAnNZVtO+bERZ03SfVCi5HTpJL31Zm+8ikLejFhnRgyBufSqfIsXaWiCTdocy54PBNM6up5KBe0Fn8An0IM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(6133799003)(18002099003)(22082099003)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D8776225720D04E8E92A6925611C2F1@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kYI56YdMlS8bOJftRU8c/rM9LPhMc/5iLPjFUgvJ1VuMcJp9KkDw6bbhNXcbhZUXTAPGvBLA6p9RQoa1eSzN7eKtcf7gRZRtR2OgKHbUtgSXyoqrPSubbr5fOgnCjj4J1sRijSOo1wWIepw44vWqyZCQcETdyPddJMjqvVqXU0u6eewZbH3gT+KI8S4HrsoCchNkBrVciNBiRbW76FkSpG7cEiq883ePmIdOP53t1AD9+M5d4YClMeryVYomQv57e5iEA2gap1awmAsk3qMoJiYAn7ZopUh6/1m6W9jDrkAPVAvz3TvzDbdbWb1YEjHzDG57tSER8Dpi2Ic8Rus/Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8471
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	942e1f65-9630-4a11-8e73-08df0a719e0c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|376014|35042699022|23010399003|82310400026|36860700016|22082099003|10067099003|56012099006|11063799006|4143699003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	fZaKqJJpdDkkduBkwspeCisJveGQM2S7dgyNdg0PVxndBO6K58+/MO0ncgJmr0vD3OuLm5IDulp+FYrgMAaozCMNuoZAXg7m6BYwsy3IbldanL99jiMWZ0JOCCyigNU3VAzJ2dTELGWSPrbbeLrNVXSbKx4pEoJQAt9HO1ho02DV6oCMyCaDC28nTtlgQfC3DZaT5qVwvMqIY5G0z02ug2g1rouyF6QyFt3dR2QQEZwyew5S8Mu990a7CwGNo1tPkyGxD+JamWQb3UAmUAVS7J4GRMfD61JIMbn2mT5rTFD+5Pea4jiCoxu2ZvYLau0gInXmLmsZhY1xnktuoMl6oXfckC6cNiV5Pf8TdlccbioQVGcuXJpRWhVMf41p5xCLihWqloUKgchehoi0M3e+c7gYtJLCUTErQz7SHs4elKiZsBthbA89ELCGFnCra3JHtiqQZr8HTQiY421bKQ1dl3UiIJCqEbPw3O94fNSmCMrByJLCRdj0OnLEleafic17x76XwPTDJAiqqqCMWdTpdO6YxrtNg2zr5RxpdLE/CjWxSjsugrReoE0K8YHYB3212agTcSAJ6uCpgDuv5FOaXRuAo7zDScRRpj+5mLNHmiuo8FTXbPf2WIq7fq38QG7WZ03xZS/RP83n5LoXpMpGeuVtzrZfqhqSOm8Yai6dwx0=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(376014)(35042699022)(23010399003)(82310400026)(36860700016)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6kJx3oQPUXNAUgTpDQJGGeBviKcxKVjdS7AmsCmh9AyGlEvcXOCqs3uahOtURhhUcM3V/UiinUWu2y+/d5K0+HxNoiw8MuiMdssdLovfrYiOg29XDQceK8ihf3sOh4PKwLwjfhvOngTqXfrp/1RVG/Tu1F1TRvBohN3Pk6BPEfVAv5vvkbHKqbsAAH5AmNEB8jCsZh2vUHRkzy9q8QrsENfYZSaSBWNrSexMZnMT3KDaqb+mtn5GR3sVpENOXamfcsO2Rh57fb+L33Z3Ij4guVw/UweO40s94SRNE8LTIV6ql/cj0vPcWkUoqVKO2Zpm+duIt4qe7Vu6/tCHnihBqilswQ5Z2dT70IEIGs6yMAGe18fe/6Jl3wajYOkp9E+bk3bv3v8L6A+9Tc327BF+nwHeZZRoUiG4qdvcZAwgQYIBjbXx0qBPJrleev4R+SW/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:45:53.5429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e776f5f4-c3f3-447f-0859-08df0a71b190
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8389

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE3OjIxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBJbmNvbXBsZXRlIHRlc3QgY292ZXJhZ2UgZm9yIFZHSUN2NSBJU1QgYXR0cmlidXRlDQo+
IHZhbGlkYXRpb24NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNDNdOiBbUEFUQ0ggdjUgNDMvNDld
IEtWTTogc2VsZnRlc3RzOiBBZGQgVkdJQ3Y1IElTVA0KPiBhdHRyaWJ1dGUgdGVzdHMgLS0tDQo+
IGNvbW1pdCA5YmE2ZDY3MzgxNjUwNzYzZDUwYzIxODIzM2RlOTg3MTFkMTUzMDRmDQo+IEF1dGhv
cjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTog
c2VsZnRlc3RzOiBBZGQgVkdJQ3Y1IElTVCBhdHRyaWJ1dGUgdGVzdHMNCj4gDQo+IFRoaXMgY29t
bWl0IGFkZHMgc2VsZnRlc3RzIGZvciB0aGUgVkdJQ3Y1IElTVCBhdHRyaWJ1dGUgZ3JvdXAuIEl0
DQo+IHZlcmlmaWVzDQo+IHRoYXQgS1ZNIHJlcG9ydHMgdGhlIGF0dHJpYnV0ZSBncm91cCBjb3Jy
ZWN0bHkgYW5kIHJlamVjdHMgaW52YWxpZA0KPiBvcGVyYXRpb25zLA0KPiBzdWNoIGFzIG91dC1v
Zi1vcmRlciBzYXZlL3Jlc3RvcmUgYXR0ZW1wdHMgYW5kIGJhZGx5IHNpemVkIElTVA0KPiBidWZm
ZXJzLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2Fy
bTY0L3ZnaWNfdjUuYw0KPiA+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3Zn
aWNfdjUuYw0KPiA+IGluZGV4IDU0ZmExMzkwNjk5MGIuLmUwNTNiMDFiYjViZTMgMTAwNjQ0DQo+
ID4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+
ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hcm02NC92Z2ljX3Y1LmMNCj4gDQo+
IFsgLi4uIF0NCj4gDQo+ID4gQEAgLTUyMyw2ICs1MzQsMTE0IEBAIHN0YXRpYyB2b2lkIHRlc3Rf
dmdpY192NV9pcnNfcmVnc19hdHRycyh2b2lkKQ0KPiA+IMKgCXZtX2dpY19kZXN0cm95KCZ2KTsN
Cj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgdm9pZCB0ZXN0X3ZnaWNfdjVfaXN0X2F0dHJz
KHZvaWQpDQo+ID4gK3sNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gKwkvKiBDaGVjayBtaXNzaW5n
IGFuZCBpbmNvcnJlY3RseSBzaXplZCBTUEkgSVNUIGJ1ZmZlcnMuICovDQo+ID4gKwlpc3RfYXR0
ciA9IHZnaWNfdjVfaXN0X2F0dHIoTlVMTCwgMCwgTlVMTCwgMCk7DQo+ID4gKwlyZXQgPSBfX2t2
bV9kZXZpY2VfYXR0cl9nZXQodi5naWNfZmQsDQo+ID4gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVNU
LA0KPiA+ICsJCQkJwqDCoMKgIDAsICZpc3RfYXR0cik7DQo+ID4gKwlURVNUX0FTU0VSVChyZXQg
JiYgZXJybm8gPT0gRUlOVkFMLCAiR0lDdjUgSVNUIGdldA0KPiA+IGFjY2VwdGVkIG1pc3Npbmcg
U1BJIGJ1ZmZlciIpOw0KPiA+ICsNCj4gPiArCWlzdF9hdHRyID0gdmdpY192NV9pc3RfYXR0cihz
cGlfaXN0LCBzaXplb2Yoc3BpX2lzdCkgLQ0KPiA+IHNpemVvZihfX3UzMiksDQo+ID4gKwkJCQkJ
IE5VTEwsIDApOw0KPiA+ICsJcmV0ID0gX19rdm1fZGV2aWNlX2F0dHJfc2V0KHYuZ2ljX2ZkLA0K
PiA+IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lTVCwNCj4gPiArCQkJCcKgwqDCoCAwLCAmaXN0X2F0
dHIpOw0KPiA+ICsJVEVTVF9BU1NFUlQocmV0ICYmIGVycm5vID09IEVJTlZBTCwgIkdJQ3Y1IElT
VCBzZXQNCj4gPiBhY2NlcHRlZCBiYWQgU1BJIHNpemUiKTsNCj4gDQo+IFtTZXZlcml0eTogTWVk
aXVtXQ0KPiBEb2VzIHRoaXMgdGVzdCBsZWF2ZSBjb3ZlcmFnZSBnYXBzIGZvciB0aGUgc2V0L2dl
dCBwYXRocz8gRm9yIHRoZQ0KPiBtaXNzaW5nDQo+IFNQSSBidWZmZXIsIHRoZSB0ZXN0IG9ubHkg
Y2hlY2tzIF9fa3ZtX2RldmljZV9hdHRyX2dldCgpLCBidXQNCj4gbmVnbGVjdHMNCj4gX19rdm1f
ZGV2aWNlX2F0dHJfc2V0KCkuIFNpbWlsYXJseSwgZm9yIHRoZSBpbmNvcnJlY3RseSBzaXplZCBT
UEkNCj4gYnVmZmVyLA0KPiBpdCBjaGVja3MgX19rdm1fZGV2aWNlX2F0dHJfc2V0KCkgYnV0IG5v
dCBfX2t2bV9kZXZpY2VfYXR0cl9nZXQoKS4gDQo+IA0KPiBXb3VsZCBpdCBtYWtlIHNlbnNlIHRv
IHRlc3QgYm90aCB0aGUgZ2V0IGFuZCBzZXQgcGF0aHMgZm9yIHRoZXNlDQo+IHZhbGlkYXRpb24N
Cj4gY2hlY2tzLCBzaW1pbGFyIHRvIGhvdyB0aGUgTlVMTCBkZXNjcmlwdG9yIGNoZWNrcyB3ZXJl
IGhhbmRsZWQNCj4gZWFybGllcj8NCg0KQm90aCBzYXZlIGFuZCByZXN0b3JlIHVzZSB0aGUgc2Ft
ZSB2Z2ljX3Y1X2NvcHlfaXN0X2F0dHIoKSBhbmQNCnZnaWNfdjVfdmFsaWRhdGVfaXN0X2F0dHIo
KSBoZWxwZXJzLCBzbyB0aGUgZXhpc3RpbmcgdGVzdHMgY29sbGVjdGl2ZWx5DQpjb3ZlciB0aGVz
ZSBjYXNlcy4gSG93ZXZlciwgY2hlY2tpbmcgZWFjaCBjYXNlIHRocm91Z2ggYm90aCBwYXRocw0K
cHJvdmlkZXMgYmV0dGVyIHByb3RlY3Rpb24gYWdhaW5zdCBlaXRoZXIgY2FsbGVyIGJ5cGFzc2lu
ZyB0aGUgY29tbW9uDQp2YWxpZGF0aW9uIGluIHRoZSBmdXR1cmUuIEnigJl2ZSBhZGRlZCB0aGUg
YWRkaXRpb25hbCBnZXQvc2V0IGNhc2VzLg0KDQo+IA0KPiA+ICsNCj4gPiArCS8qIExQSSBzdG9y
YWdlIG11c3QgYmUgYWJzZW50IHdoZW4gbm8gTFBJIElTVCBpcw0KPiA+IGNvbmZpZ3VyZWQuICov
DQo+ID4gKwlpc3RfYXR0ciA9IHZnaWNfdjVfaXN0X2F0dHIoc3BpX2lzdCwgc2l6ZW9mKHNwaV9p
c3QpLA0KPiA+IHNwaV9pc3QsDQo+ID4gKwkJCQkJIHNpemVvZihfX3UzMikpOw0KPiA+ICsJcmV0
ID0gX19rdm1fZGV2aWNlX2F0dHJfZ2V0KHYuZ2ljX2ZkLA0KPiA+IEtWTV9ERVZfQVJNX1ZHSUNf
R1JQX0lTVCwNCj4gPiArCQkJCcKgwqDCoCAwLCAmaXN0X2F0dHIpOw0KPiA+ICsJVEVTVF9BU1NF
UlQocmV0ICYmIGVycm5vID09IEVJTlZBTCwgIkdJQ3Y1IElTVCBnZXQNCj4gPiBhY2NlcHRlZCB1
bmV4cGVjdGVkIExQSSBidWZmZXIiKTsNCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBJcyB0
aGlzIHRlc3QgbWlzc2luZyB0aGUgY29ycmVzcG9uZGluZyBjaGVjayBmb3IgdGhlIHNldCBwYXRo
PyBBcw0KPiB3aXRoIHRoZQ0KPiBTUEkgYnVmZmVyIHRlc3RzIGFib3ZlLCBpdCBvbmx5IHZhbGlk
YXRlcyB0aGF0DQo+IF9fa3ZtX2RldmljZV9hdHRyX2dldCgpDQo+IHJlamVjdHMgdGhlIHVuZXhw
ZWN0ZWQgTFBJIGJ1ZmZlciwgYnV0IGRvZXMgbm90IGNoZWNrIGlmDQo+IF9fa3ZtX2RldmljZV9h
dHRyX3NldCgpIGNvcnJlY3RseSByZWplY3RzIGl0IGFzIHdlbGwuDQo+IA0KDQpBcyBhYm92ZS4N
Cg0KVGhhbmtzLA0KU2FzY2hhDQoNCg==
