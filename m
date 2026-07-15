Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010033.outbound.protection.outlook.com [52.101.84.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08D23A8743;
	Wed, 15 Jul 2026 16:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784133929; cv=fail; b=s5DnPyvQH8YjBWoa7JEdBITBswv6CMmh24Tbs3VcYKSoJO8472Ti3q68pjmRiVCBr/t4l3zyVQ+HWp6UAe8jFvX04o9jtff1Px8BFUmUjvcFV52cCBNHbRBMO9pg9Z6Tcgx6KpRRx7H5ADpWjU2HqvoCjxFrf8MrCRn5ts43ahQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784133929; c=relaxed/simple;
	bh=SKuFUgB+dwbsremb+15FkU/MgMSO5tQJ5/t7ujJuHUk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p4vOsfRlxQqfwVldMjuLPeh9IelYTMNUAbOqApc9TMvptgkQmG4ybdCiNgzY0SMW5Gou4zYEr9dgwXY9+BxXa3Oi40hvCD90WYkIG7vefnd1iR42wV6F/FyUP9qwzpOs1LQ5gvaSJLjqpwqwc+gL2c/NkR+Aa1M/2k0iEB3LTwU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pi4+7qoP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pi4+7qoP; arc=fail smtp.client-ip=52.101.84.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pi4+7qoP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pi4+7qoP"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iPJRPothuVFLvsADVJYfPUcvrVt36FwFtvT2XTOBPlFww6KMo25Ko7ycSSPv2vyhKevoAywyDVXCPHKvZ20pJrF+HGHSzxZ7HLSHElo4Ot2aQOPrkw14by1Pf4zemDFnTz9i8xJs1irZGrU3Fm2w88HoTAtZblcUyk13AX1XRhh05K2Zml3mtfviRio12NgdKJRIE9XBHN8s3jutNc7Z/DLIcrNzUmqe3TeOAGPnZS2opeHR8Z95PfHNLWeTFTUlaDU4LXJ0I/zIWqIXoYEqWCZ/rqQH3DWbZ/8OZMDW9JsNMkIvdnPS7h70bBuA7XaR847OuOplZrDybNHy5Ndh1g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKuFUgB+dwbsremb+15FkU/MgMSO5tQJ5/t7ujJuHUk=;
 b=x8T0sNb/WA9sJ5/Ca8tw2J1lJ3aVen2qyQUqxV9CycIZxfQ9DUnws+kwM3gCJzYobTuaRHeRQ2FrH5zn8+9obvmaprRzEw/42ZM3eknfO5fqvEGxNlmt+ZKI+EviYOKFzbGPKQfWtGGyVCxC/A3ez691AP0+9lPbiv4Vyjg2920XHq/xztWZZqlHMbWcqjFNi3oypuMWelYx10nZGlK1iBB15VKyxfYmLwtz6ROsud6KgtjZMfkGNF7Yky8Zg/G5cxyRJWYcXm93DV7TQGkVr+spSwI0MxXCOCWXWOnF6iBlOZWrb7NTDxpAFw1LLzl5ptiSfCJO6cQk9eINBAEMhQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKuFUgB+dwbsremb+15FkU/MgMSO5tQJ5/t7ujJuHUk=;
 b=Pi4+7qoPb+/46sdHQ2dyYJYHZ81dy1lU5x4HPW5i4k+BHypIRlg3FeaqnAvu7B2vGT0qew58JKnaDM7DfFeHOsf8wQm+YgUyI8qe0y/B0/gej3oDEoVeXX2vk1RUOTF7ADm86RIj5zrGCQZfd6ut5VRLJXlHOBq8kMakRgQhhAo=
Received: from AM0P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::28)
 by PAWPR08MB10118.eurprd08.prod.outlook.com (2603:10a6:102:368::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Wed, 15 Jul
 2026 16:45:22 +0000
Received: from AMS0EPF00000196.eurprd05.prod.outlook.com
 (2603:10a6:208:190:cafe::28) by AM0P190CA0018.outlook.office365.com
 (2603:10a6:208:190::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.11 via Frontend Transport; Wed,
 15 Jul 2026 16:45:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000196.mail.protection.outlook.com (10.167.16.217) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Wed, 15 Jul 2026 16:45:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TK00RIzLwia4txGRNdqWUWKPIVnyRGoict9OP+6ruFmMAeGU9bBgdqFCwITLyhNJI25H0UcNJAVGob0CyyLpcW2kuE3Q77Tgl/+P++QS6doOWUVpeTS7V/HESF8m2XH7n1Ve+nYf1+U6SootMjIEjsTpJIoSeyIeQRamPeBLO/b4qrTGv5DvdVMp7n8aunIL2VfdAktLeL8gAYYqp4w++zWHR1+MIJIRRjWPlcsXhOnIhJ/ip2mkimBvXD1ZIRLAHqMMbybM+hfOmYhNJZF6WXLHQAwvZ3Gxd3P7kMEx8wCmdiiZ7O5Uz9C1dZO3oRWliRGJPTU56L34x9HFI4kXJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKuFUgB+dwbsremb+15FkU/MgMSO5tQJ5/t7ujJuHUk=;
 b=Pe59+XV/8PdCQ71C5iqfjV5YP6aW9t15JUxpzG0mZJVk43xMBgaWxgaJtnGtx6pegDV6ulqDxMkV/EQdQni53Ug+x/H01uTklxmbKciKjjvXNzyVRmUKN5Mo2hg5nKIfW3tG4fysIsROYdWyxDFWEv/fKgmMTkdr+c15AQcXe5+kah/P4Ur30FRpKEdvIhsvtNugiCum843V0tfHucVabTZDyHgb3ytt9nZ99ATFhMXbeBp/X8g4/xJAihMLUyk8BOxogzH1PIq1AR9Ahv5HPcxt6DPDEndqiSqaKmILTzTm/cPLUXv9ljVVT1KZl/e8THwwyWqQMuSnQ7mifF7LKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKuFUgB+dwbsremb+15FkU/MgMSO5tQJ5/t7ujJuHUk=;
 b=Pi4+7qoPb+/46sdHQ2dyYJYHZ81dy1lU5x4HPW5i4k+BHypIRlg3FeaqnAvu7B2vGT0qew58JKnaDM7DfFeHOsf8wQm+YgUyI8qe0y/B0/gej3oDEoVeXX2vk1RUOTF7ADm86RIj5zrGCQZfd6ut5VRLJXlHOBq8kMakRgQhhAo=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by VI1PR08MB10173.eurprd08.prod.outlook.com (2603:10a6:800:1cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 16:44:18 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:44:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 38/40] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Topic: [PATCH v3 38/40] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHdCwZi3HeNsrhRrU+q0Er854iNQLZb/oCAgBLdzYA=
Date: Wed, 15 Jul 2026 16:44:18 +0000
Message-ID: <4a3f324097884c37c896b37816a3c115ec5714ed.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-39-sascha.bischoff@arm.com>
	 <20260703163746.A56551F000E9@smtp.kernel.org>
In-Reply-To: <20260703163746.A56551F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|VI1PR08MB10173:EE_|AMS0EPF00000196:EE_|PAWPR08MB10118:EE_
X-MS-Office365-Filtering-Correlation-Id: f9d2e36e-f479-40a3-eee8-08dee290768a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 /0F2I8mzi6Ut3c0nmS34ZET39eXBPlH0zBG/tbJ5zclHbn1iJzIYfbuaEPTjAGVPT8YYg0RE/6p50+g1nkOwK90+ujHLSuhMJ76+dKvYPhQVvhaRaacwdiACft+7/XtkzHvxN4cmZEDfm9HFYikcgxSJ1oDqJ5ek/mjuqdEFwHHfkggv68BwouUGMEJ4bzycyh9LUF4DlrgM/drD6pdkMEhFlmZTwIC67d15APSFl3oNoW0ylETpt6siAl/TdJZ2SruX7ofNecFHxMjVacG7g1CqT9YQznc946SiysofA1ZfgIpF0NF/ZAcZVLlq5LJRXDDD3uDyjMKBR7Xm1rMLRtSnliBGizF5GvOEnqw6ZCzFmu/7+rVR2HHrczlKYdr+zVhOBJQeqyuiL+VjeGTYvc4lVSSkK0l3AE3Ip2ITS8LuqgkEbqLMxmM8TqWnjWYhbBZhQhBuseEjjIz8KGIz1zQyoYv4kDM1wSXrVpdzcpmgx2+trpQmpXhAhFmLKtIs+KfpO4zCuwDi0fsAv+6umskcviWakiFoTFTzJRSDpfQUMXJgD6TXxvBp7oBaflRlZt94rOqlcvjV87gjxphsltkfm8PxHvwmmp+jaJo5tzGuldIMZhoKmOWx0/rPevlbDGaA0X2SwuxfzAKEyIKMwB/0WLmdkqAgMfTI/NJJ6TIZoRW3RCNoXJSKWgjk89lz7Ya5BHf3eg91IQzOvX5jQvYCES1uspNFbZnD7eZB6Xk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <898F84B9E3BDA84DA174D15FF59E47D0@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WP9oyq1n0kJtcImGgczgcD5++rV8Z4CP2TzStbB5hwRFcHQx7EdvP/XCkNTB0jrzdhMRPsZ32LsX7P0OUE/DYUotgV1YZzSVHX+habvSNMHOJ8XdvvBWn0TMWMPvUu4pxece5OmctO6gV9brL1uswy9oyJpUdJH+Wb9KzKgUK5vw9cfF0iy8CtUUZjnUt04/f8F1sFO+tk2FR6bax2YZDxR5ImJSz4BKQnEpA9asu6jGLnPzsb7ZXbnovk0oRwJoBM+SiLxtISyxzT6Br/71NbSG0eVIFsgwzKA/anjNL/8yNrRcijM2szaKr8meEgzF0+kvXdxu1KIW4zf0s/T6Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10173
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4b02b026-600b-4c4c-0f40-08dee290502f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|14060799003|1800799024|36860700016|82310400026|11063799006|4143699003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	zZMiaIiVwvUnrTm67nXz5C1EpmLLwUmqjQDkD+QHJlfHiNvHrqTZ4uccLp7xro7yAVzwul9yMB92K6cXQTCbKIGUTKvprn6I+LcE0OkFbgP7DqkDyo91jdowNtFCVqaOU/uc/pV6t2W5o8p0OjICeuxrio9N6WOm+vrTJ++Zeli4EuXzWcH22U48b5hQkJdjDCvR2WNRUur+oY5f2xJLMLGpls8vD3V8iymAFyg5NMAh64yB+/0VRfc7WwlB+7IKsPA022vma+8eAhQfQPqiJHC3lRkTTAh8u9dUAe1CoOzN4+UKVy0GRZ4a2ceRzvsPJZCOCvVwuX/FJQzN2bywp61LcdSJ6kigUPybpXizpKDJV+Rrtk5MAef82DKmd64rzLs5AjvwkHAopZ5LPDGRz3XtQB5HLLNy+nSkXbQhYXer7Vu8LIYjzBALmXe8dWBsKZ1lAv88KsS8VMJNXXh3MsKO7Iu3k3D2dSZp1tuWHg8U3hfAI6HMVDYXTxM5gzep7bZPGOyt01KI67jjIrmWREfzZ7SMoBoeVldPRK3efMqTxCFIQm4rr7sLnlYshnHHX5di2oInqZUEyiXqteYvujp820ua329OLOK+Z4bCipvzhkKoM/zZpNcNPGAT/69cOSv8LKzqDcPeBynFxZsQu3N4mot8Z+6TtODiCUH3zW/mHgxNN1fW/60LjA2VUf62qMArcAnG/rikpCmQzOfwow==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(14060799003)(1800799024)(36860700016)(82310400026)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tE1M8DQA8L3bulUMCUYOMfnFgoW65DrDyKd4Z+kSWVAUPpK9njUQjegi/j0oSb7rVKBuezf5PKzRMae7w2Dl+ZYEj8uNvJegXGSZlqZyQsKSGVjKVZawIvOJoKnK24AzQGMaJrQuOqv/4xY6Hl/zqG03zTKGHE8xy5NWUVJSw9kod3VR7Lp2QgrtXKvquvc8JakOgVs5SIy1vCOi3Or7FVZroyB9m2u7/qx8qy88stN1wU4FU6Ob365Rn8uZO2GQJH4G2g93azYf5dD1nE3+v1QeLhCEWuHL62b2apOOUIbQu+h8AmRHeLqXTb6SbFdi39hmnUQ4/ZAgbNMM6x3GMXMfM/s23gy/Amev1KZRdBkVIo3HtBAN7pNzZGXkgQjLu5T8jtuAh4TfDDxdH3zJ1nng07o6gMhOL80DVfj+aI4Zii8op6Y6MGWmugIq1rJM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:45:22.4153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d2e36e-f479-40a3-eee8-08dee290768a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000196.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10118

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjM3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTG93
XSBUaGUgZG9jdW1lbnRhdGlvbiBmb3IgdGhlIC1FSU5WQUwgZXJyb3IgY29uZGl0aW9uIGlzDQo+
IGluY29tcGxldGUsIG1pc3NpbmcgdmFsaWRhdGlvbiBmYWlsdXJlcyBhbmQgdW5pbml0aWFsaXpl
ZCBWQ1BVDQo+IGNvbmRpdGlvbnMuDQo+IC0gW0xvd10gVGhlIGRvY3VtZW50YXRpb24gaW5jb3Jy
ZWN0bHkgbGlzdHMgSVJTX0lEUjMgYW5kIElSU19JRFI0IGFzDQo+IGV4Y2VwdGlvbnMgdG8gdGhl
IHJ1bGUgdGhhdCB3cml0ZXMgdG8gcmVhZC1vbmx5IHJlZ2lzdGVycyBhcmUNCj4gaWdub3JlZC4N
Cj4gLS0NCj4gDQo+IGNvbW1pdCBkYTk2ZWIzODkzYTRjOTVhNDQ5YjIxM2VkZTRkNTEwNmViMTdh
NWEzDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4N
Cj4gDQo+IERvY3VtZW50YXRpb246IEtWTTogQWRkIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19S
RUdTIHRvIFZHSUN2NSBkb2NzDQo+IA0KPiBEb2N1bWVudCB0aGUgS1ZNX0RFVl9BUk1fVkdJQ19H
UlBfSVJTX1JFR1MgYXR0cmlidXRlIGdyb3VwIHVzZWQgdG8NCj4gcmVhZCBhbmQgd3JpdGUgdGhl
IHZpcnR1YWwgSVJTJ3MgTU1JTyByZWdpc3RlciBzdGF0ZS4gVGhpcyBwcm92aWRlcyBhDQo+IEdJ
Q3Y1LXNwZWNpZmljIGludGVyZmFjZSBmb3Igc3RhdGUgdGhhdCBpcyBjb25jZXB0dWFsbHkgc2lt
aWxhciB0bw0KPiB0aGUNCj4gVkdJQ3YzIElUUyByZWdpc3RlciBpbnRlcmZhY2UsIGJ1dCB1c2Vz
IElSUyB0ZXJtaW5vbG9neSBpbnN0ZWFkIG9mDQo+IElUUy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiBiL0Rv
Y3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiBpbmRleCBl
MjA0NWIwOWYyN2QwLi4yMTdhMWVjZmJkYzVmIDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRp
b24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiArKysgYi9Eb2N1bWVudGF0
aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gQEAgLTE0MSwzICsxNDEs
MzkgQEAgR3JvdXBzOg0KPiA+IMKgwqDCoMKgIElDQ19DUjBfRUwxDQo+ID4gwqDCoMKgwqAgSUND
X1BDUl9FTDENCj4gPiDCoMKgwqDCoCA9PT09PT09PT09PT09PT09PT09PT09PcKgDQo+ID4gPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IA0KPiBb
IC4uLiBdDQo+IA0KPiA+ICvCoMKgwqDCoMKgIFdyaXRlcyB0byByZWFkLW9ubHkgcmVnaXN0ZXJz
IGFyZSBpZ25vcmVkIGJ5IHRoZSBrZXJuZWwNCj4gPiBleGNlcHQgZm9yOg0KPiA+ICsNCj4gPiAr
wqDCoMKgwqDCoCAtIElSU19JRFIwIC0gSVJTX0lEUjIgYW5kIElSU19JRFI1IC0gSVJTX0lEUjc6
IFRoZXNlIGFyZQ0KPiA+IHNhbml0eSBjaGVja2VkIHRvDQo+ID4gK8KgwqDCoMKgwqDCoMKgIGVu
c3VyZSB0aGF0IHRoZXkgbWF0Y2ggYSBzYW5lIGNvbmZpZy4NCj4gPiArwqDCoMKgwqDCoCAtIElS
U19JRFIzIGFuZCBJUlNfSURSNDogVGhlc2UgYXJlIFJBWi9XSSBhcyBuZXN0ZWQNCj4gPiB2aXJ0
dWFsaXphdGlvbiBpcyBub3QNCj4gPiArwqDCoMKgwqDCoMKgwqAgc3VwcG9ydGVkLg0KPiANCj4g
W1NldmVyaXR5OiBMb3ddDQo+IFRoaXMgaXNuJ3QgYSBidWcsIGJ1dCBpcyBpdCBjb3JyZWN0IHRv
IGxpc3QgSVJTX0lEUjMgYW5kIElSU19JRFI0IGFzDQo+IGV4Y2VwdGlvbnMgdG8gdGhlIHJ1bGUg
dGhhdCB3cml0ZXMgdG8gcmVhZC1vbmx5IHJlZ2lzdGVycyBhcmUNCj4gaWdub3JlZD8NCj4gDQo+
IFNpbmNlIFJBWi9XSSBtZWFucyB3cml0ZS1pZ25vcmVkLCBzaG91bGRuJ3QgdGhleSBqdXN0IGZh
bGwgdW5kZXIgdGhlDQo+IGdlbmVyYWwNCj4gcnVsZSByYXRoZXIgdGhhbiBiZWluZyBsaXN0ZWQg
YXMgYW4gZXhjZXB0aW9uPw0KDQpSaWdodCwgSSB3YXMganVzdCB0cnlpbmcgdG8gZXhwbGljaXRs
eSBjYWxsIG91dCB0aGF0IHdlIGRvbid0IGN1cnJlbnRseQ0Kc3VwcG9ydCB0aG9zZS4gSSd2ZSBy
ZS13cml0dGVuIHRoaXMgYXM6DQoNCiAgIFdyaXRlcyB0byByZWFkLW9ubHkgcmVnaXN0ZXJzIGFy
ZSBpZ25vcmVkIGJ5IHRoZSBrZXJuZWwgZXhjZXB0IGZvcg0KICAgSVJTX0lEUjAgLSBJUlNfSURS
MiBhbmQgSVJTX0lEUjUgLSBJUlNfSURSNywgd2hpY2ggYXJlIHNhbml0eSBjaGVja2VkDQogICB0
byBlbnN1cmUgdGhhdCB0aGV5IG1hdGNoIGEgc2FuZSBjb25maWcuDQoNCiAgIElSU19JRFIzIGFu
ZCBJUlNfSURSNCBhcmUgUkFaL1dJLCBhcyBuZXN0ZWQgdmlydHVhbGl6YXRpb24gaXMgbm90DQog
ICBzdXBwb3J0ZWQuDQoNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gK8KgIEVycm9yczoNCj4gPiAr
DQo+ID4gK8KgwqDCoCA9PT09PT09wqANCj4gPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA+ICvCoMKgwqAgLUVOWElP
wqDCoCBPZmZzZXQgZG9lcyBub3QgY29ycmVzcG9uZCB0byBhbnkgc3VwcG9ydGVkIHJlZ2lzdGVy
DQo+ID4gK8KgwqDCoCAtRUZBVUxUwqAgSW52YWxpZCB1c2VyIHBvaW50ZXIgZm9yIGF0dHItPmFk
ZHINCj4gPiArwqDCoMKgIC1FSU5WQUzCoCBPZmZzZXQgaXMgbm90IDMyLWJpdCBhbGlnbmVkIGZv
ciAzMi1iaXQgTU1JTw0KPiA+IHJlZ2lzdGVycywgb3Igbm90DQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCA2NC1iaXQgYWxpZ25lZCBmb3IgNjQtYml0IHJlZ2lzdGVycw0KPiANCj4gW1Nl
dmVyaXR5OiBMb3ddDQo+IFRoaXMgaXNuJ3QgYSBidWcsIGJ1dCBpcyB0aGUgZGVzY3JpcHRpb24g
Zm9yIC1FSU5WQUwgZnVsbHkgY29tcGxldGU/DQo+IA0KPiBEb2VzIHRoZSBrZXJuZWwgYWxzbyBy
ZXR1cm4gLUVJTlZBTCBmb3IgdmFsaWRhdGlvbiBmYWlsdXJlcyBvbiB0aGUNCj4gc2FuaXR5LWNo
ZWNrZWQgcmVnaXN0ZXJzIG1lbnRpb25lZCBhYm92ZSwgb3IgaWYgdXNlcnNwYWNlIGF0dGVtcHRz
IHRvDQo+IGNvbmZpZ3VyZSB0aGUgSVJTIGJlZm9yZSBhbnkgVkNQVXMgYXJlIGNyZWF0ZWQ/DQo+
IA0KPiA+ICvCoMKgwqAgLUVCVVNZwqDCoCBWR0lDIGlzIG5vdCBpbml0aWFsaXplZCwgb3Igb25l
IG9yIG1vcmUgVkNQVXMgYXJlDQo+ID4gcnVubmluZw0KPiA+ICvCoMKgwqAgPT09PT09PcKgDQo+
ID4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCj4gDQpJJ3ZlIGV4dGVuZGVkIGl0IHRvIGluY2x1ZGUgdGhhdCBjYXNlIHRv
by4NCg0KVGhhbmtzLA0KU2FzY2hhDQo=
