Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013071.outbound.protection.outlook.com [40.107.159.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEB643FD2B;
	Fri,  4 Sep 2026 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514281; cv=fail; b=X3U8Ci0j9PqZ3SYkSQTACUp7nBixzzM+2nxrshFxM2CnQQnKc2FcUGaAJw/qY8BwsfUu+6kCxC3hruoMnlfPgXWX8ccQEdIkLIpda0hPyjAmWkvqU2u0jF+8H/JYPuWRWch0T/Bne97HNZSZSPDOiWqVN54QRy02xwkPdDEyVZQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514281; c=relaxed/simple;
	bh=H/LNTr5f10BscF2AQ8VtrlGi9T16O6rw5SnAqsEXiRo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EHCFhUvN1rLEAkpkLGqvgcTAPnaAOOPN/zfyWyjyYFsKnZ2ajsbcmAzPQlgyr2GC6Uuq7yX91FMbve5gc40SSjz/6LGCoch+pf5xtaMGVPEJQ0QmTJHVQMlYh7OnyQatejcrgCegUNp58Mu5WE6GSKe/KjDj9a6nVY4YQZZnafY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n7epjTKX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n7epjTKX; arc=fail smtp.client-ip=40.107.159.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n7epjTKX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n7epjTKX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Lj+dSJfjTJjZhXqMFYWOdz/C9cvGAVipKby6Fhnj+ZCO72UXKlM7Hb1694lfWlWV0YVVt266eWQD0SvNlAVO5untlgO6D/6hulZQM10Pl+EkgkuZmTi7uJCC1zdNaj2fydQ8y0NjAkP9IoKsrVxXnM7sWZ93Dk1Jo+CIL8Y6dxw1AgmwevFPTq/amDRJKr3hKvQyBmCm7Umhsajbo0hW25ZPg+W9FrP+1XqwDS9N5sdHlOaX++IJsI6fywwtbuUAFEiScnwjZ0C5PBz0tHAHKT+mjR0iwN8i2CuAEiuFtKIKB8eKqWU9+/7Z7g32A1k6tX0iEjdVGtUkok0lHG2maQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/LNTr5f10BscF2AQ8VtrlGi9T16O6rw5SnAqsEXiRo=;
 b=odcV8Z1iSCmlnwiQ3VaLt1inv7mQQbMrgq1/+6S5kg62x5jC5fmwCLafBTJQENzwO+fX1cLSR6QK8KJXvK3GG7xufWAR/aOKEn+3MXujaJQmas4+4gjjmaWs02lEUFHjDechEEjwjQVHABalLrSbKZ8L+qzDbM8KWl3T/Y9IQp3d29bZH6X93b2A33FshpzB92aprTZ6pvFYPqCGc7eRHbrDnyq2SLDmdVg7r0INj9BL8x0MB03rB/6HRGbRKVygbdVT/qwHrwopbNEuyxlAlgVeZ21QVFve/ttgF2ZAeXM+WfezqKVGlWW1qFlyUtqFDu36t3T6CJvc/g8BIPS0Dg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/LNTr5f10BscF2AQ8VtrlGi9T16O6rw5SnAqsEXiRo=;
 b=n7epjTKXQS4B3sFKvpOv6hdtYPgjiG+W6U7zv9CtIeDZrnUEdozSqySgqYeDS1l7iuNRJVoqgHox9fGZDcf41fNMHZyY85abc2eH3paqr3BVQIn8U3SePzNe/4NhdZkB329IafptPQA46DJzYzssir58sf0r8oPp+7dHybOMGks=
Received: from AS4P189CA0008.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::9)
 by GVXPR08MB11096.eurprd08.prod.outlook.com (2603:10a6:150:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:31:14 +0000
Received: from AMS1EPF0000008E.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::69) by AS4P189CA0008.outlook.office365.com
 (2603:10a6:20b:5d7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 09:31:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000008E.mail.protection.outlook.com (10.167.242.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 09:31:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJ+nfbC70gjLQRDJBHeyoVsZsUiNLe7ZiBd4ArrYyX+xZIf+yqaeOYlJEFOIiqIeGR6y1AthwlSYmslHGdXQja08TuihJIA6x0oJzGHaziKAPOvSgkz0sLxpNPehy9knVQoIY96hF/yeFUCWg0xH2F6Cko3ft4wgupPXocnrggxQOWHiwXXyN0UOe1BdrYYKvrje/iY2fgb5/kcUw1So0UjyeWca6HyO3v6TfIGT198OfNI58eOBlHiy9LxrtWS9qjDc8oovA2v7TeTjG/XKXo8eaMCkx76b3ChHleMhY6DVO6I69Z3ffKqUoMVnrZN2wAt8jxJsl1kkN2t1vhi4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/LNTr5f10BscF2AQ8VtrlGi9T16O6rw5SnAqsEXiRo=;
 b=tvAfN7MzuzZeSl03Uxq6HdJrgnHVPyQtWHxyLUFmH1SqRfgm97qZwbSEzeFx/MIFfOcFl7EBqHSzhUtDiso2RNXTmwRnC96ylfSAyYLF2DYPnClKE+M2LUxTp8N+a6Ap7oO60mfphUwbhdHhsw6ywCAICnwgrC87eHt7nI29IiF/4kU4imcAJcg1qjkzu5nhm45GD6YGVcSz0+JHx1rg6wIDF2ORosMnA7IoMQaQGL0kvAFOwPYCTQCdxUPS4W30m4j+CfCTqOBYfQ4HuXh1Q+BeJVaafHU3GjGp+7SCFzvIes0bkAIZ2TmnkrTDXnZUZY78q+04xvK52MBik+GV6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/LNTr5f10BscF2AQ8VtrlGi9T16O6rw5SnAqsEXiRo=;
 b=n7epjTKXQS4B3sFKvpOv6hdtYPgjiG+W6U7zv9CtIeDZrnUEdozSqySgqYeDS1l7iuNRJVoqgHox9fGZDcf41fNMHZyY85abc2eH3paqr3BVQIn8U3SePzNe/4NhdZkB329IafptPQA46DJzYzssir58sf0r8oPp+7dHybOMGks=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by ZR6PR08MB999854.eurprd08.prod.outlook.com (2603:10a6:910:d6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:30:42 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 09:30:42 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 28/49] Documentation: KVM: Extend VGICv5 device
 attribute docs
Thread-Topic: [PATCH v5 28/49] Documentation: KVM: Extend VGICv5 device
 attribute docs
Thread-Index: AQHdJl+k7Mijqf0J0Ee2xAkN9DYeM7aStjUAgCudJoA=
Date: Fri, 4 Sep 2026 09:30:42 +0000
Message-ID: <f236e5782639b43cc8fbbdc896bb07f3f354d0ad.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-29-sascha.bischoff@arm.com>
	 <20260807152904.EF92D1F00A3A@smtp.kernel.org>
In-Reply-To: <20260807152904.EF92D1F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|ZR6PR08MB999854:EE_|AMS1EPF0000008E:EE_|GVXPR08MB11096:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bee932b-6223-4742-532b-08df0a6743a1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|38070700021|6133799003|18002099003|10067099003|11063799006|4143699003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 /ANlUt+mtDEgAg/vzMpPHPJ7FJE6e7T1fDua8dum2uc8FXM5QUo7ZXtmwa3hn3kaOtn6JOH20NH2pLot717hIDPC0zuc3Lv/M30AvhFXRMZPA9gDvMRVPpeSh5n8X3hq+gu6/PVj3e/HDkh9AVa6MOp2DF/3z/8SZS8SZcvTTWGmTN2IYxN5JGVpzVC+josFCzh0yOkfZEFnX9vdTGo6LS9jO59qS/AHeXquGa6C6sb4Up/d7M2Eu8URWqhibeU6iOzxT1FMbdYMS4ddsf7OnS1uhhyHEaXttn5x91LM7MQSL4mn6IUTRsng0HjZJqesEdjVj8BM/l25UbKzc1fbtKA3HbR62ofrIy4yQp8S4WFwnoiBB7p7ANVKtlo29753S0YRV0qabQUmmno5UnGfyGuMIEZcxz+M7XdU9w78dZnNc4VERzBdWkJtvyICD5vwX/ttruk5dCAl7CgvcKuRl4JlajCLffvLOSvKnKr/M3GMKjP6+efPade6SciXb8+v9ydDpQ+Vl0wHgkZJhHz5Cm30ZEWf49JcmZO0mGcA6PF6KRkY9xp8XtDglc7LNSt9VMZ0pNL2GYhHTPEQSgXLfEmIuVyJfUKY+XVG0spG9rxaxcG4DE7sKgRNACMCeglnWxQt2nbxZ8BCux+rppTWJ+4NP1wmLpOVUm68rIkFsiwo47UDgD6RhPJj0AFw8QdHO3fRCxVQ+kJ3rAi/Vi0R+CjxN7aw+PG01LK8spEpfdY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(38070700021)(6133799003)(18002099003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D74EA6B183A284CA9389872377B1611@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 CjGeyqwMtNuNleR0P3wGKi/cMX9av8BJmeJvcOk6QQYCiX8acn7HflxZwekc5UdSRdQbntBXq2fer8DpRo59TduoLMUZHQ+tBk5XdIrem28oP5KJAi5wnbpsISXKzVujZgtBWsdKbmhM/hyh/uZrHeKdQ8i3ilsO44NU1sEdZzRAc1md7E+rJIk+hd5TtRRhOzmNGBVJTvGowWb+nraM8QSz2hLpH1+kOyYLXPlHnnVysjnGUjzmQOi9qVSKPE8lULgiwyhGzsznYHQqW1daRa8IB7KM5a7+MI1OCY9ZdgeR47pFYJPu5TfOwnzRgDEoPXvQ8WC76/uezuHGDDx5jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR08MB999854
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000008E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a5ecba55-fc70-44d3-a320-08df0a6730ad
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|35042699022|14060799003|23010399003|82310400026|36860700016|56012099006|10067099003|11063799006|6133799003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/RpjzAi1Zs2kSgOLmb3LZwF4bdq8nwaICM4IOrc5mlBgX5edVCANdKsYCCZ6K3erCJK4F6D+rBzGdELUXmnO7uBGOaAiWNdbpKOWwrDUCLY+3KprBkWfJ/km5bpGrh+6Y430MZ48C1UhoTzkCJBib0lZJDpIGCM0yekXDYSf05B6t4cFyvs73qS4kmaI09max9SvSWbdRcn/yP+O6E8k+s+oHZsDwlLKVI4iDwSPogpxURf54UzXxR2UQEfaf+7yn2f2K07Cn1fNe54VnDxto2rLFZEHIFyd0SH8APXmziKFjgeMnrMmqx7a3ITCrrnAnX78ho878bn49icnQhYESCAbbv4pDBfrn26mffDr57IM2o9xg0Efh6RcjgEpeGs+OxJM2PN6jGGz1XRi7/7VVltrLgmD3z8Lg6ohnL3O5+WFXs1Vmk7gMXUxZyCNHie/we8DT2WGR/HtqM/nSu53b/ADY5VwSQLOO3txgebYzblU3ZPKIbgeqIkCtAi2q+B57GGxcaKdgpb5mL+7eLieXsdBXQ09H+EVgW0yhE71rjQ2JCjPisKjbAArywRWBt8aets1Kih+Le0BILLuLJgQIli8zO9Te99//Fph9QBGFQLikzDNpI+qGiZWoRViaWP0slnlptFbo3zvk0p6fbxRfXNdPb+G8tJCW9gK+Rfpejc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(35042699022)(14060799003)(23010399003)(82310400026)(36860700016)(56012099006)(10067099003)(11063799006)(6133799003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d97NP+EsoidBrWeQRygTzvR6+3y91ldO5Lfyv8duCgzFn1UwGiiifUYIgmP9bo1/kPUkg7n+W3a8XzWhUNdtDPe4agZVhKIRfKdJZt2gsnvJY+LsTs0qrFmiWmP2uQBaBcr1npgmJHYIAEsIbdijRe0Tdhyv4Aa27bbIf67utt/e2ohgYfwKsyTM4wmVB0k+4Rza8X332P7zLvST3Wg21pqhCEAifr444KLXGFcFHMf3lJUZO6uLqR7RfSvjaNd6UQQ8CdSBwAykx1/aA9q51v6y+8I1yNgSw9M+0GsQ8yi81cL2i3Fs7bMaEkCcfmzo2toIGlus0sxQdZ84lZEiskbRhPTJrjv8UiQcLISUH35lHcyDFP1uRVZPKfy5q1ldxUUvg9Qn8DvOUHlGqWRAiKvF+aOuIZuyorS+bcubPrJFraEkUAY4T2lnHw718KVz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 09:31:14.1559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bee932b-6223-4742-532b-08df0a6743a1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11096

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE1OjI5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBSZXVzaW5nIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX05SX0lSUVMgd2l0aCBjb25mbGljdGlu
Zw0KPiBzZW1hbnRpY3MgZm9yIFZHSUN2NSBjcmVhdGVzIGEgVUFQSSBpbmNvbnNpc3RlbmN5IHRo
YXQgYnJlYWtzIGdlbmVyaWMNCj4gVk1NIGluaXRpYWxpemF0aW9uLg0KPiAtLQ0KPiANCj4gLS0t
IFBhdGNoIFsyOF06IFtQQVRDSCB2NSAyOC80OV0gRG9jdW1lbnRhdGlvbjogS1ZNOiBFeHRlbmQg
VkdJQ3Y1DQo+IGRldmljZSBhdHRyaWJ1dGUgZG9jcyAtLS0NCj4gY29tbWl0IGIyOWI1NGI1Yzcw
MGI5ZDNjMmY0NzhlMGNhOGE0OWNjM2NlZjI5YTcNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYg
PFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gRG9jdW1lbnRhdGlvbjogS1ZNOiBFeHRl
bmQgVkdJQ3Y1IGRldmljZSBhdHRyaWJ1dGUgZG9jcw0KPiANCj4gVGhpcyBjb21taXQgdXBkYXRl
cyB0aGUgVkdJQ3Y1IGRvY3VtZW50YXRpb24gdG8gY292ZXIgUFBJLCBTUEksIGFuZA0KPiBMUEkN
Cj4gaW50ZXJydXB0cy4gSXQgZG9jdW1lbnRzIHRoZSBHSUN2NSBJUlMgYWRkcmVzcyBhdHRyaWJ1
dGUgYW5kIGl0cyBHUEENCj4gbGF5b3V0LA0KPiBhcyB3ZWxsIGFzIGEgR0lDdjUtc3BlY2lmaWMg
aW50ZXJwcmV0YXRpb24gb2YgdGhlDQo+IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX05SX0lSUVMNCj4g
YXR0cmlidXRlLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9k
ZXZpY2VzL2FybS12Z2ljLXY1LnJzdA0KPiA+IGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZp
Y2VzL2FybS12Z2ljLXY1LnJzdA0KPiA+IGluZGV4IDcwYjkxNjI3NTVjN2UuLmM3ODJlYTRkNDYw
OWMgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2VzL2FybS12
Z2ljLXY1LnJzdA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0t
dmdpYy12NS5yc3QNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gK8KgIEtWTV9ERVZfQVJNX1ZHSUNf
R1JQX05SX0lSUVMNCj4gPiArwqDCoCBBdHRyaWJ1dGVzOg0KPiA+ICsNCj4gPiArwqDCoMKgIEEg
dmFsdWUgZGVzY3JpYmluZyB0aGUgbnVtYmVyIG9mIFNQSXMgZm9yIHRoaXMgR0lDIGluc3RhbmNl
Lg0KPiA+IFRoaXMgaXMNCj4gPiArwqDCoMKgIEdJQ3Y1LXNwZWNpZmljOiB1bmxpa2UgR0lDdjIv
djMsIHRoZSB2YWx1ZSBkb2VzIG5vdCBpbmNsdWRlDQo+ID4gU0dJcyBvciBQUElzLg0KPiANCj4g
W1NldmVyaXR5OiBNZWRpdW1dDQo+IERvZXMgcmV1c2luZyB0aGUgS1ZNX0RFVl9BUk1fVkdJQ19H
UlBfTlJfSVJRUyBhdHRyaWJ1dGUgd2l0aA0KPiBjb25mbGljdGluZw0KPiBzZW1hbnRpY3MgZm9y
IFZHSUN2NSBjcmVhdGUgYSBVQVBJIGluY29uc2lzdGVuY3kgdGhhdCBicmVha3MgZ2VuZXJpYw0K
PiBWTU0NCj4gaW5pdGlhbGl6YXRpb24/DQoNClRoZXkgYXJlIGRpZmZlcmVudCBHSUNzIHdpdGgg
ZGlmZmVyZW50IGxpbWl0YXRpb25zLiBUaGVyZSdzIG5vIHdheSB0bw0KY29uc29saWRhdGUgdGhv
c2UgdHdvIHZpZXdzIGhlcmUuIEdJQ3YzIGhhcyAxNiBTR0lzLCB0aGVuIDE2IFBQSXMsIHRoZW4N
CmEgbnVtYmVyIG9mIFNQSXMsIGFsbCB3aGlsZSB1c2luZyByYW5nZS1iYXNlZCBpbnRlcnJ1cHQg
dHlwZXMuIEdJQ3Y1DQpoYXMgc2VwYXJhdGUgIm5hbWVzcGFjZXMiIGZvciB0aGUgZGlmZmVyZW50
IGludGVycnVwdCB0eXBlcyBzbyB0aGV5IGFyZQ0Kbm90IHNlcXVlbnRpYWwuDQoNCkZvciBub24t
R0lDdjUgR0lDcywgaXQgbWFrZXMgc2Vuc2UgdG8gaW5jbHVkZSB0aGUgU0dJcyBhbmQgUFBJcyBp
biB0aGUNCmNvdW50IGFzIHRoZXkgZWZmZWN0aXZlbHkgc2hpZnQgdGhlIGJhc2UgaW5kZXggb2Yg
U1BJcyBieSAzMi4gRm9yDQpHSUN2NSwgdGhhdCdzIGp1c3Qgbm90IGEgdGhpbmcsIGFuZCBpdCB3
b3VsZCBiZSBzdHJhbmdlIHRvIG1hbmRhdGUgdGhhdA0KdGhlIDEyOCBwb3RlbnRpYWwgUFBJcyBh
cmUgaW5jbHVkZWQgaW4gdGhpcyBjb3VudC4NCg0KPiANCj4gVk1NcyB0aGF0IHVzZSBzaGFyZWQs
IGdlbmVyaWMgR0lDIGluaXRpYWxpemF0aW9uIGNvZGUgd2lsbCBsaWtlbHkNCj4gcGFzcw0KPiBu
dW1fc3BpcyArIDMyICh0aGUgc3RhbmRhcmQgZm9yIEdJQ3YyL3YzKSB0byB0aGlzIGF0dHJpYnV0
ZS4gV2lsbA0KPiB0aGlzDQo+IGNhdXNlIHRoZW0gdG8gaW5jb3JyZWN0bHkgcHJvdmlzaW9uIHRo
ZSBudW1iZXIgb2YgSVJRcyBmb3IgVkdJQ3Y1LA0KPiBlaXRoZXINCj4gYWxsb2NhdGluZyBhbiB1
bmludGVuZGVkIG51bWJlciBvZiBTUElzIG9yIGZhaWxpbmcgaW5pdGlhbGl6YXRpb24NCj4gZW50
aXJlbHkNCj4gaWYgdGhlIHZhbHVlIGV4Y2VlZHMgdGhlIEdJQ3Y1IFNQSSBsaW1pdD8NCg0KVGhh
dCdzIGZpbmUuIFRoZSBWTU0gTkVFRFMgdG8gYmUgYXdhcmUgdGhhdCBhIGRpZmZlcmVudCBHSUMg
aXMgYmVpbmcNCnVzZWQgYW5kIHRoYXQgaXQgY29tZXMgd2l0aCBhIGRpZmZlcmVudCBzZXQgb2Yg
cmVxdWlyZW1lbnRzLiBJdCBjYW4ndA0KanVzdCBibGluZGx5IHRyZWF0IEdJQ3Y1IHRoZSBzYW1l
IGFzIG90aGVyIEdJQ3MuDQoNCj4gDQo+ID4gK8KgwqDCoCBUaGUgdmFsdWUgcmFuZ2VzIGZyb20g
MzIgdG8gS1ZNJ3MgVkdJQ3Y1IG1heGltdW0gb2YgMTAyNCBTUElzLA0KPiA+IGluDQo+ID4gK8Kg
wqDCoCBpbmNyZW1lbnRzIG9mIDMyLiBJZiB1c2Vyc3BhY2UgZG9lcyBub3Qgc2V0IHRoaXMgYXR0
cmlidXRlLA0KPiA+IEtWTSB1c2VzIDMyDQo+ID4gK8KgwqDCoCBTUElzIGJ5IGRlZmF1bHQuDQo+
ID4gKw0KPiA+ICvCoMKgwqAga3ZtX2RldmljZV9hdHRyLmFkZHIgcG9pbnRzIHRvIGEgX191MzIg
dmFsdWUuDQo+IA0KPiBbIC4uLiBdDQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
