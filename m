Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012058.outbound.protection.outlook.com [52.101.66.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CAC44781C;
	Fri,  4 Sep 2026 10:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516119; cv=fail; b=XmoVMvWPotVOu4X3HJtyv7hetEQSTXOttthiNC4oyeBTwgy7ohr4rL1sHu+o/Qa9sp68V38mzdW5X6GWES/Y8UHcbOcF4gAjUTsheHVdJfy67uUqB3ju4P10CRmbpnpJpLQY55OjJ/0VG718VjRtz0zwAIw7qcWDZGt18PvsCBc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516119; c=relaxed/simple;
	bh=gO4cez0LnhCnLJ04foAO7ZDzSJYqq58NS2Y5V9rOKM8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R9IrHp6wWM2/6BG1wnUbfjUtVOdhGXbYyxAF2Hlp9RgploDxKgeN3qtSHoMgtGZAh3jc+PVD+oI5g+CFSGqjt9lzB51dwNs7jvMFpsmoO1sP2txY3JgO4Wct0fOqi/sviijj6y+6n8h8FjCzqs5aWxwHbTob4FZXXacTFH9Kz4Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YxBnszsg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YxBnszsg; arc=fail smtp.client-ip=52.101.66.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YxBnszsg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YxBnszsg"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XbDZ7CRvhIsTh3cXLsrZHCHcin5TqHsNHdiVS2gMhEjiUgB4dDaK7vxnYyGxlDkK/hjM/Z5OEJ6d/aRDmALJwfTbOsrtkHNAHcGTnModsgSW6AVOhduJIKTqDMecbLV3/FRbt1Xuqo1+0RHq8iL9WLvKLtfA/uNzke/E9jgn+B2Xzh5vP3RHeyN2lDma0HryKTqWq5QGo5qB0wWVRYMI0n4mw05bXNV4sdLZZGF85kN19dPsPJjV44bevxtowkdJp3/vfxXGf0AvFglsLWp/BO61R2vDLaG7arNW1jdpijNxhdHTnzPUR9efV1ypH1sVzt0gI91a7CmzM0PtwsX29A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gO4cez0LnhCnLJ04foAO7ZDzSJYqq58NS2Y5V9rOKM8=;
 b=kalpGKX5DwLZjivcuf9RwoRHWeAq8jEcGBeFTVdy/QzBRWxUMU1ECea2jj0KLXhOhQHYAL/VSS6BDgy/A1BIguzcOns30MuOHd7nFKiQZXPSvUbO7HuWIvtJp2GKV+2UpvlupQJKlB3w12sbbMlSo0Wt3IgBVyuwwvkhYeoI+URw/GoqPDvL7VGLTNA0ZuHYvGnJObKlj277BvnxLcf1hXgY7nWzait8srZguesB5H9BnIhbFxbubIDc8sXKPgFYJZxkGeWI//LRlElHb7/EjD7///6y9pZK6zvWZYU7VTFN2O5lqR4wRiSQ5oZI9e/Irw1VFby3z7VF1ioSL4RKmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gO4cez0LnhCnLJ04foAO7ZDzSJYqq58NS2Y5V9rOKM8=;
 b=YxBnszsgsyPJqYSr1CvkUrPqiMroA1Ur4m3Al8sXCVK6oipUUxftr/VjWi3L33Oz9QDri8s5yLx4WV7ukJ8UWG4ukXN5MJYwsZRFs3jmcgTT49JObukUSCWTczibIla+YIm+uQIFB9v6MCRoY68a2EbtCr3OLxd3QlsBE0eTGWs=
Received: from DUZPR01CA0295.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::11) by AS8PR08MB8874.eurprd08.prod.outlook.com
 (2603:10a6:20b:5b8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 10:01:50 +0000
Received: from DU2PEPF00028D13.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::78) by DUZPR01CA0295.outlook.office365.com
 (2603:10a6:10:4b7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 10:01:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D13.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 10:01:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFgxH7RNex5QggSzFOvvEG0qe9U1Ip8TwJ5SxqBMk21VaRu2YJUHFFbTqBCFuBaVmeIvxCfQMAaiFWkszzrcQCyNhdnE5TgCPu9Psa5J/HxKKl+SVbh1dYVj/exV4MirDtZxQkhuLQTacF0JEY3Oty/3UFX0uVT2+SSJDrxE1zSAGjREHLOj71cc8F5dLgKiQ7qSmvNrMc2tXEdfnauV7QhtQWhBjRoHX9UYfYYA7+sdX3svgiHRKEeAIsHiW2zT4wovxf6g6OorBPHFT41/BR3xr28nYGafi1Y1k7IA44pryFjUe818TP/GbJpk0JFPzejVU7b6ilb9gvZuiwg72w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gO4cez0LnhCnLJ04foAO7ZDzSJYqq58NS2Y5V9rOKM8=;
 b=yXKXDGNFdf1z8g8Vnh8XIuNM6Ck0CGdoJQvWhTvcxxGbvumNdqMOETz9gr+IgoHrK9WICb5CyN/WAU099UYw/mYFpcg/RyA+f8mRTCZRlENVB9tOXk8+YrtyWATQ43nXZPNuyLVnftma+VwHnPhlD2v8P6L6m9QCAjHbWOkWhsY9IXOPDw/MIU9J7S/9f1wIDWNSHKZCpnf15dZcvo7aXkHlK7dsOABLec6ZbEAQt/iacVg2D5B7lcpLtkysG9O1HYppQhSMSV5rVzBJ4JWGdmBimbg+DQ3oSVHArs5H5a1OYytZXw34oTyKz2bQVhhs7uc78remcqsLwoY9idjPXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gO4cez0LnhCnLJ04foAO7ZDzSJYqq58NS2Y5V9rOKM8=;
 b=YxBnszsgsyPJqYSr1CvkUrPqiMroA1Ur4m3Al8sXCVK6oipUUxftr/VjWi3L33Oz9QDri8s5yLx4WV7ukJ8UWG4ukXN5MJYwsZRFs3jmcgTT49JObukUSCWTczibIla+YIm+uQIFB9v6MCRoY68a2EbtCr3OLxd3QlsBE0eTGWs=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AM9PR08MB6129.eurprd08.prod.outlook.com (2603:10a6:20b:284::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:01:16 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:01:16 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Topic: [PATCH v5 31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Index: AQHdJl/bwdOcLhb+eE6D0uzpcavykraSxqMAgCuVQoA=
Date: Fri, 4 Sep 2026 10:01:16 +0000
Message-ID: <fce72d871f1f3457c165d5277464a30a1353e060.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-32-sascha.bischoff@arm.com>
	 <20260807162753.3C64C1F000E9@smtp.kernel.org>
In-Reply-To: <20260807162753.3C64C1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AM9PR08MB6129:EE_|DU2PEPF00028D13:EE_|AS8PR08MB8874:EE_
X-MS-Office365-Filtering-Correlation-Id: e1bfc44e-3c71-4625-f9f8-08df0a6b8a22
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|6133799003|4143699003|11063799006|10067099003|5023799004|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 g2V3xymF3BgfhfRRm9iVfJFi3CU1xwVWUcmkgltQLpbqKMg7nLoBv9VaSr73SB775qhwtdXU6+L8mrU6UuF1VMl5Pin7NyGUr5Za9H8/CSg6JgwtAcz8LkfkkVelS0teDryL7YITF8XNyQl5JWVb0P0TnUs+D0ajxLhBVLOZeRryHGb0rmBzyNbJe7Op3T+8mHOUpiQvX/WRyYFfhjtnbFW3Ja1bSC54FRKCNR0+apv4L3NzcA6TuJ68HeN0ghrnTYgGZMGhTshZrtucW0Tt4h0PYqI0cZsm5EsYqNEWHsQO4PCUM7rI/ap9lt5WsCxisylLeUe86DdrYDFjynj4Y0XYPWPM7jgMrRqAFVn7uLawHPejCeQIVR41taIocxcHhboRnNKiBiiJB1gzLC2TG5FPGjWdoOtwrndPLjKTeEfdN58z/j1G5qfmmXtlbc1ruwZoXxAdYvK99PcCCmXhGvGKWp/OSYqGLbQVw74kl+wrwwJMLZYSv4fNNJcev4vn6gkCEKHPz2DWbm8Z3Q5xoqX5ToHLjo1QsGUpVhA3w9Ai7T5ndLKl7qxhg81YKCwFwRlLmxIIKoSakDZ1TpsbHyUfvLOoQOcZi3j9NGjXUgzIpqILY/XYhMQqxMFSHhd2kiy5LiBauY8WFx90lsHKS3TmsiDbc29RT0V8vVBe+pSl+2FfpqOXXg5qS+zM0SsSa3h8YSAp4PCdT7MM0SAstYKH07vflGN97dkkUmZMP0s=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(6133799003)(4143699003)(11063799006)(10067099003)(5023799004)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CA1B66942ED1448AC56541DC1846656@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 K/zW7iTOZINjeubbf83Od6QbrOboFwED+JTLFf/7YshJx8IWfV43iFKDv5t5iMDSQ88pqA6EsDTJQS4uvGWrh/Ezrg2vohWWG0CVfZUVpHQdf/zUJrrak8dYO9ybVS1X78dT82CRztlqTezCVl87ELeh+/eWdpIHdHvNqq/h2rAC/SHPK6hDvKwWhZqhIJkRCTWiu9y+KUU7doy0LQEnNn1LJDFQRN3oIptqwiPtG75LPQAFFdmVAYZvHevGONn86BE72gA2gwmvKvyUFDZhzYqKRrpihhSjwolB8CfzA8f1UtHJWEqZ8Tk7DRRGiqPSn394XDclg5pZZH6Mz0UTqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6129
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9a1f03ab-9413-4cc4-3a50-08df0a6b75eb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700016|35042699022|14060799003|23010399003|6133799003|4143699003|5023799004|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	kmxWa2ThvfAmIQiF2z3TN6rEo2eZMqr+xU/bLbglYV6c9HsmJwEEvmG6s/ykJr2bGycjxnDmPcda2ZkZUl38cyzqySpz9nyjHoBcSRKb+nfdwRVm8oJRrCTQgGajyaZjZeT1InfYaIW5wwyqvjgsMH5vwAMNKU87VJ4azOr7iX8FsbYClY1M3pPUjOQis3QRzoRXgEsNozXm3zh+7q9xQitFVf7CzuJv3QpMIomAxVeRadNz80JTjkZGRRPcWE20yJRFHaCBpYcx42pJ3+NnEAnzxv0PfgqSP4/JvcxhnzpG0LxHBQt4UU5kjSwl7i87vls8ky91dCFu9jQplVk9T33wxn/VDDsjsPbApoBvoQDZCq7SBIGfmdh8JSNSmSoSd3wMJMbcpzX6iwgEvBYxb9F3cekoqQqA0mUA719Og89l1US8QmeI2OQci4OTJXedzy8nFQuaPnMAFXwDE/YgfOmLa4iO58WtgZvZOma9xHQkHfvhiXBumgTw1sGOscNNEdqDVVnclCwN6ZuAw6wm1kf0uUJbfMfeNAMjEY3Esh/LG/7jOdw1hUGZNJ7T35EZ13T3TLwFCvs20EtwOqEBMnlPyvAv4zr6uYRQq8kFkgnYRhZapMOAWLYjB1Pv57I8VjZPv9Z2h2MGofLKXGdgLIe5C25Kjau71tonJhstO8E=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700016)(35042699022)(14060799003)(23010399003)(6133799003)(4143699003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qF0kxm03qk9nurYlSuCCxOlObxrftVsGGosYxS+FgS3E1QH3mAKesan38Z5u8iv8faltX6gckIuCMqwTurYEv3HdT7CAjZPttDWEbqc+kl6O4Vka47C462eXxxDfSOw4p/lihA/hkAQmVHgajfHCO1oBbCBal2pBiIEx75h0mp25+U0PKC4LG9dlvMGwW3nLW9JeLPl3GTOYhgojCTyWi6IbtyJfnTGjX0+BDHRDcFqXSeYiXrI3CKhy5r883qPQn6PKPJ7WOLGq+IQbyzPB/PvtuFnSivOE4sOFWyTCqHxkVt115/sf8/gC7Ii9IrY21GXZEyFWKG5/jA4rKLq2hWZTIm9+zwqxWM3XJzoSh2YH6PFIjOaQQ/jhtJ/j7X5N39f/F1gEUMjS1FbGp+lt5cMjMGm+YpDVt/ocDQM2g6l/vy29mzHLV7EF1c6MJ6ed
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:01:50.3950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1bfc44e-3c71-4625-f9f8-08df0a6b8a22
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8874

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE2OjI3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVGhlIGBnaWNfdjVfaWNjX3JlZ19kZXNjc2AgYXJyYXkgaXMgbm90IHNvcnRlZCBieSBzeXNy
ZWcNCj4gZW5jb2RpbmcsIHdoaWNoIHdpbGwgY2F1c2UgS1ZNIG1vZHVsZSBpbml0aWFsaXphdGlv
biB0byBmYWlsLg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFszMV06IFtQQVRDSCB2NSAzMS80OV0g
S1ZNOiBhcm02NDogZ2ljLXY1OiBBZGQgR0lDdjUgRUwxDQo+IHN5c3JlZyB1c2Vyc3BhY2UgYWNj
ZXNzb3JzIC0tLQ0KPiBjb21taXQgZmM0YmQ5MmY5NDNhNDUxY2Y1NDAwZTllMDFlNzU4MTlkMDJh
ZTYyMw0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+
DQo+IA0KPiBLVk06IGFybTY0OiBnaWMtdjU6IEFkZCBHSUN2NSBFTDEgc3lzcmVnIHVzZXJzcGFj
ZSBhY2Nlc3NvcnMNCj4gDQo+IFRoaXMgY29tbWl0IGFkZHMgZnVuY3Rpb25zIHRvIGhhbmRsZSB1
c2Vyc3BhY2UgcmVhZHMgYW5kIHdyaXRlcyBvZg0KPiB0aGUgR0lDdjUNCj4gRUwxIHN5c3RlbSBy
ZWdpc3RlcnMgdG8gc3VwcG9ydCBWTSBtaWdyYXRpb24uIEl0IHdpcmVzIHRoZXNlDQo+IGFjY2Vz
c29ycyBpbnRvDQo+IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0NQVV9TWVNSRUdTIGFuZCBlbmZvcmNl
cyB0aGF0IHJlZ2lzdGVyIHN0YXRlIGNhbg0KPiBvbmx5DQo+IGJlIHdyaXR0ZW4gYmVmb3JlIGEg
dkNQVSBoYXMgcnVuLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy1z
eXMtcmVnLXY1LmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMtc3lzLXJlZy12NS5jDQo+ID4g
bmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAwLi42YjI1NWVhY2Jm
NjBkDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMtc3lz
LXJlZy12NS5jDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+ICtzdGF0aWMgY29uc3Qgc3RydWN0IHN5
c19yZWdfZGVzYyBnaWNfdjVfaWNjX3JlZ19kZXNjc1tdID0gew0KPiA+ICsJeyBTWVNfREVTQyhT
WVNfSUNDX0lDU1JfRUwxKSwNCj4gPiArCcKgIC5zZXRfdXNlciA9IHNldF9naWNfaWNzciwgLmdl
dF91c2VyID0gZ2V0X2dpY19pY3NyLCB9LA0KPiA+ICsJeyBTWVNfREVTQyhTWVNfSUNDX1BQSV9F
TkFCTEVSMF9FTDEpLA0KPiA+ICsJwqAgLnNldF91c2VyID0gc2V0X2dpY19wcGlfZW5hYmxlciwg
LmdldF91c2VyID0NCj4gPiBnZXRfZ2ljX3BwaV9lbmFibGVyLCB9LA0KPiA+ICsJeyBTWVNfREVT
QyhTWVNfSUNDX1BQSV9FTkFCTEVSMV9FTDEpLA0KPiA+ICsJwqAgLnNldF91c2VyID0gc2V0X2dp
Y19wcGlfZW5hYmxlciwgLmdldF91c2VyID0NCj4gPiBnZXRfZ2ljX3BwaV9lbmFibGVyLCB9LA0K
PiANCj4gWyAuLi4gXQ0KPiANCj4gPiArCXsgU1lTX0RFU0MoU1lTX0lDQ19QUElfUFJJT1JJVFlS
MTRfRUwxKSwNCj4gPiArCcKgIC5zZXRfdXNlciA9IHNldF9naWNfcHBpX3ByaW9yaXR5ciwgLmdl
dF91c2VyID0NCj4gPiBnZXRfZ2ljX3BwaV9wcmlvcml0eXIsIH0sDQo+ID4gKwl7IFNZU19ERVND
KFNZU19JQ0NfUFBJX1BSSU9SSVRZUjE1X0VMMSksDQo+ID4gKwnCoCAuc2V0X3VzZXIgPSBzZXRf
Z2ljX3BwaV9wcmlvcml0eXIsIC5nZXRfdXNlciA9DQo+ID4gZ2V0X2dpY19wcGlfcHJpb3JpdHly
LCB9LA0KPiA+ICsJeyBTWVNfREVTQyhTWVNfSUNDX0FQUl9FTDEpLA0KPiA+ICsJwqAgLnNldF91
c2VyID0gc2V0X2dpY19hcHIsIC5nZXRfdXNlciA9IGdldF9naWNfYXByLCB9LA0KPiA+ICsJeyBT
WVNfREVTQyhTWVNfSUNDX0NSMF9FTDEpLA0KPiA+ICsJwqAgLnNldF91c2VyID0gc2V0X2dpY19j
cjAsIC5nZXRfdXNlciA9IGdldF9naWNfY3IwLCB9LA0KPiA+ICsJeyBTWVNfREVTQyhTWVNfSUND
X1BDUl9FTDEpLA0KPiA+ICsJwqAgLnNldF91c2VyID0gc2V0X2dpY19wY3IsIC5nZXRfdXNlciA9
IGdldF9naWNfcGNyLCB9LA0KPiA+ICt9Ow0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBXaWxs
IHRoaXMgY2F1c2UgS1ZNIG1vZHVsZSBpbml0aWFsaXphdGlvbiB0byBmYWlsPw0KPiANCj4gRHVy
aW5nIGxvYWQsIGNoZWNrX3N5c3JlZ190YWJsZSgpIHZlcmlmaWVzIHRoYXQgdGhlIHN5c19yZWdf
ZGVzYw0KPiBhcnJheXMgYXJlDQo+IHN0cmljdGx5IHNvcnRlZCBieSB0aGVpciBzeXNyZWcgZW5j
b2RpbmcgKE9wMCwgT3AxLCBDUm4sIENSbSwgT3AyKS4NCj4gSWYgdGhleQ0KPiBhcmUgb3V0IG9m
IG9yZGVyLCBjaGVja19zeXNyZWdfdGFibGUoKSByZXR1cm5zIGZhbHNlIGFuZCBjYXVzZXMgdGhl
DQo+IGluaXQgdG8NCj4gZmFpbCB3aXRoIC1FSU5WQUwuDQo+IA0KPiBIZXJlLCBTWVNfSUNDX0FQ
Ul9FTDEsIFNZU19JQ0NfQ1IwX0VMMSwgYW5kIFNZU19JQ0NfUENSX0VMMSAod2hpY2gNCj4gYWxs
IGhhdmUNCj4gQ1JtPTApIGFyZSBwbGFjZWQgYXQgdGhlIGVuZCBvZiB0aGUgYXJyYXkgYWZ0ZXIN
Cj4gU1lTX0lDQ19QUElfUFJJT1JJVFlSMTVfRUwxDQo+ICh3aGljaCBoYXMgQ1JtPTkpLiBBZGRp
dGlvbmFsbHksIFNZU19JQ0NfSUNTUl9FTDEgaXMgcGxhY2VkIGF0IHRoZQ0KPiB2ZXJ5DQo+IGJl
Z2lubmluZyBvZiB0aGUgYXJyYXkuDQo+IA0KPiBEb2VzIHRoaXMgYXJyYXkgbmVlZCB0byBiZSBy
ZW9yZGVyZWQgc3RyaWN0bHkgYnkgZW5jb2Rpbmcgc28gdGhlDQo+IHZhbGlkYXRpb24NCj4gY2hl
Y2tzIHBhc3MgYW5kIHRoZSBiaW5hcnkgc2VhcmNoZXMgd29yayBjb3JyZWN0bHk/DQo+IA0KDQpJ
J20gcmVhbGx5IG5vdCBzdXJlIHdoZXJlIHlvdSdyZSBnZXR0aW5nIHRoaXMgZnJvbS4gVGhleSBh
cmUgaW4gdGhlDQpjb3JyZWN0IG9yZGVyIGFzIGZhciBhcyBJIGNhbiB0ZWxsIChJIG1hZGUgdGhl
IHBvaW50IG9mIGRvaW5nIHRoYXQgd2hlbg0KSSBhZGRlZCB0aGlzIGNvZGUgYmVjYXVzZSBJIGtu
ZXcgdGhhdCBpdCBoYWQgdG8gYmUgaW4gb3JkZXIpLiBJJ3ZlIHJlLQ0KY2hlY2tlZCB0aGVtIGFn
YWluc3QgdGhlaXIgZGVmaW5pdGlvbnMsIGFuZCB0aGV5IGxvb2sgZ29vZC4NCg0KQWxzbywgd2Ug
ZG9uJ3QgZmFpbCB0aGUgaW5pdCB3aGljaCBzdHJvbmdseSBzdWdnZXN0cyB0aGF0IHRoZSBvcmRl
cmluZw0KbXVzdCBiZSBjb3JyZWN0LiBBcyBpbiwgSSd2ZSBidWlsdCBhbmQgcnVuIHRoaXMgY29k
ZSBhbmQgZG9uJ3QgaGl0IHRoZQ0KaW5pdCBmYWlsdXJlIHlvdSByZWZlciB0by4NCg0KSW4gc3Vt
bWFyeTogdGhpcyBpcyBmaW5lIGFzIGl0IGlzOyB3b24ndCBmaXggYXMgdGhlcmUgaXMgbm90aGlu
ZyB0bw0KZml4Lg0KDQpUaGFua3MsDQpTYXNjaGENCg==
