Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012007.outbound.protection.outlook.com [52.101.66.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1D3AEF5A;
	Fri, 31 Jul 2026 09:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489687; cv=fail; b=ETWJ/7FFmMJHysIgv+V1RprVfEp3EUlo6oxuZmnJB2OrSbM/44QlZKbOuHLlKD8VdWUrcEt0NI/0nSqrzSBYSOpTBZcsOR4jGRekH9SZwQMxKPMahuGhHlS+IRJQ/7eFV48wwgo1CbEAy8hoAFqxEFikPoYBZpRSuU2OiS2Rsv4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489687; c=relaxed/simple;
	bh=ZP7bfP/qRQ5XMVOuUU7pmaIYW1blf/xaSEwL1WPLkQQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CTSCJUCM78EsmSyaud6lUBQKw3V6IyUhi1djQXJIueHOKs5gPart3l6pcHhVFQDpsT3qRP88ey1+7a5RfC0sH1kVxmYMtMF994DxGHffMTe2pQmnE2/S53bQF7WZObT3Sk8WjDr33RLGPSw6bMKSuJ9Y8+frdmyoLa7mbi86bIE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q5sqNxUB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q5sqNxUB; arc=fail smtp.client-ip=52.101.66.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q5sqNxUB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q5sqNxUB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Mt9Ie/0ww7d8PPCVGy7TQsDylxrAjtH7ZBzkpjde1ZnBnDOaZMNUqWGLcRBLQjaCH1P0KQiA1jPHQ89GnMKQx/Ba0sAJwsvspyhSgqOitVd6PxpagBe5bIqELtos74q3f4/rlvCFo6JVyGr/V3c4Z1OUgtDmCFyKHeMlbU6Jpyq9cukJPh9U/Q4lDyu4qnTWkPhaxGlq7NuuOCv0DBjNk4GXmRkMHEX+oQwh14RuAmfhOfoMnxZW4/PbVEcTVC+PznuzicnxvPd2l8x/v0T75TLrvoP4DE4bOi/lNefn3IhqcMyIcl64PDsM02hfNKj9ObiJ0SEBFKDfvqP2BnKsQQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZP7bfP/qRQ5XMVOuUU7pmaIYW1blf/xaSEwL1WPLkQQ=;
 b=DXj3HcSrR+RjWDys9pj+XJHFBY59XAn3vPuV/VZALLYTEAaOJsAawxlaZ8kj1FgXH8mAPaU6e9zaKP8NdFPikra5A+I7W7B0eyDuNoDgw7X5pwSw3PXNsAiDVuA3b2G7tCLo2Xt48q/P7lq57AICQm9utMV02QCtRKi/1rCY0S/e+w4EbeZteO6Day7nqSP1tKnLENy0Igq1qAGkbkUa5HQmmFixuXsA/wRqzr1cybM5wbZxceploTDbr36gV//hwUIqwGl7FBg2S/IPWtp5hXR/6cOA5D1+/G7w30d7Zl5iWAjgaVYhAzd+toCF3lgcXDJVNGOcZq6duiqfaIZsAA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZP7bfP/qRQ5XMVOuUU7pmaIYW1blf/xaSEwL1WPLkQQ=;
 b=Q5sqNxUBr3wCkmOUSgZKQ7plgtUyJD5Dn4RnNpgH5ONuFy4X28oZUZ9PUSIIlTRNDlXev0Vd5U5tMtBo7AaE5ck6PNql/1vmzvNFd6Url660rFNM9glXG+WsXiiUQYSlGcSQ+eAXWyagmjn6nYqe6/wuuAPaTn2u6VH7zDUGQQk=
Received: from AS4P195CA0037.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::26)
 by DB9PR08MB8291.eurprd08.prod.outlook.com (2603:10a6:10:3dd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:21:22 +0000
Received: from AM2PEPF0001C714.eurprd05.prod.outlook.com
 (2603:10a6:20b:65a:cafe::3d) by AS4P195CA0037.outlook.office365.com
 (2603:10a6:20b:65a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 09:21:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C714.mail.protection.outlook.com (10.167.16.184) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 09:21:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ynDLDSxxh2GfIT5dy3U6RDmCHf05uNUy5GAdqQbHfgtlXX6tWInpKXU/bcpKd09ggtm3Fw+n1LaIHC+aHUDI21nfWASLTxN99d455PJcK4lvspwNvbZSCi3Gh1XM90cZENpWWmTmaqInxj21Ype5fwMOS0OHCMszEbkSKBfyo2MdZSW1wjnNjJVMgMG35l6VgDRApm7uBz7HVuMzpG2zotYGF6vHC3Un9whyMttUgULQUXNhs/XtmRhCpGGt2ZlsirRJGWilRoryhrIOZAYRoGhUhAo2NKH6PNvjrUqihSJZ3YmXoNpbhie2h2lgfj40t+wYuoouquhDUxvLG05TTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZP7bfP/qRQ5XMVOuUU7pmaIYW1blf/xaSEwL1WPLkQQ=;
 b=ko3izlLMPUg1rcqLGYMYJ+S1S0B1jFBtZGzNaWEkbrqblptz3W5spT8tF8x04ni1lvEjk5l3Agj9d2GfJHbkXiOGEzouw8GUlj8Dt/e1Xo8DuOwwnTjeTAiTkr8dNsPmHGecFwZUbqQyPeyJWKegF10oDJ8VBUpFn1qoKUKZgWVzsHLL9x4NA+8d6b9P4q8B1s+E0Nko5zAeOSWYw0bK34rbwUTpap+alZbLaY99uJW0BcpsT1CZHG487CssOds1rDVB6KObWCuCQ6i2/5bN3t5SDl4GpMdOv5WSkEaGObHuhUB1yrjIg0JksXy1yFD3keJiX0beThRohB4KwWLkzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZP7bfP/qRQ5XMVOuUU7pmaIYW1blf/xaSEwL1WPLkQQ=;
 b=Q5sqNxUBr3wCkmOUSgZKQ7plgtUyJD5Dn4RnNpgH5ONuFy4X28oZUZ9PUSIIlTRNDlXev0Vd5U5tMtBo7AaE5ck6PNql/1vmzvNFd6Url660rFNM9glXG+WsXiiUQYSlGcSQ+eAXWyagmjn6nYqe6/wuuAPaTn2u6VH7zDUGQQk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA6PR08MB10768.eurprd08.prod.outlook.com (2603:10a6:102:3d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 09:20:20 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 09:20:20 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 01/48] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Topic: [PATCH v4 01/48] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Index: AQHdG1n96hE/bI9FdUeQWTh8i0lV/LZ8hm6AgAreeoA=
Date: Fri, 31 Jul 2026 09:20:20 +0000
Message-ID: <c04f49444fee99aa47ebf56d58c5af72054a829b.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-2-sascha.bischoff@arm.com>
	 <20260724112128.3A0D81F000E9@smtp.kernel.org>
In-Reply-To: <20260724112128.3A0D81F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PA6PR08MB10768:EE_|AM2PEPF0001C714:EE_|DB9PR08MB8291:EE_
X-MS-Office365-Filtering-Correlation-Id: f9529ac9-62c9-4f52-19c6-08deeee516aa
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|5023799004|4143699003|11063799006|56012099006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 haDqtNlfbmjJ1sP3wOiSFEfpIt4IZ+RK2nn9STFi9jzNUeNjgy/u9t/gi4xTfdXOrnJWoO6W5rIFlzPu8/Jo2PM/tSAz83Gf7FWh7KdJNRxLH90ZxGUg5jE8wHCt9tqemb4i1X+JY9vDo30BZW2IEbNB1PHPUqB5PPpaZ0SDETfamcDp8aFyYkntJMSdVnHDq8WaEmwf5ugekv0s9rPaxUrIl0Ldbu32RtQiP8AZhU3kLPw5+S65p/ffWtF13fzTbjoKbgsaprRkiga1FyRdylXyB1WeyMLFEDQ07r+1zam9f8Am8A2FsaMa0VNu0ULO7QhKAMC5s6R1Brk8sGRqAD+6YzsF2q67VRtRMrZlgZtsGMoBMZZvIu4uQLcPbdC+n1U5tz0Nm26pmsEGbPvLLTkdEAbU+CDzkRfT1hgDqIWu9TiGB2R+8onHKnyOQusg6HNxoUpw8PLdzj8t9FeRQRH6czOG2vWjC2u9wCQOgbJtXz7/oNmtwjyLEny0YbtvKChlu5KCP310mCK1HHD+xRSWd1wFL7P8GHCDjZOxEkvr+UUC4qZNphazQBo2KzlGO2UMzMoY/3BIVf5rYunZtUEiJG3UUuSd23Mrj4m/od/gs79L7zA+6nFkDssRY9LUlxn21tOcWIRobRZULU2ocQfupT6Bn0O5Dtuem8vecZciiqbipcduUPJ1RgoNUjf+AWiEbYVUXsD7OxDWh/sVsJ6gaAI99+KsK7ENcnOVUiY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(56012099006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA89D5BCE7C23D42A63DBCBB0984ED47@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 PopFQboNnk0ljZbYgrPj/EfCxwbcb7SwCQ4R1DgKrNcbGTgGeNSvA4oqRiomdQHaUtFOJtawOEdhFS8pLg0H1OwSDIjaFMD7TJU1mBTa1UQ80w55mBf1Kzp5u4nhgMETpoQ0ubBkNOAwkDRwuZvc42npxDv6LeyjKo0+tmzdnmb94VclgQgM4po3YAzxCrgSRLPpP+Az4HpFwAuRaRXD2J+I+qdJW5zdFsH05vhhHSlt2dVilO7c/wRcJSzkoepCgm4gJABFGc8tTEeyXeDLDGmkgjD29VE5zQvCqpXeZ7SAiMnWyjNb+kipxOcVeeyX0genfhMQ+F8/dt2l4Ed03A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10768
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8d56bfa7-d88a-4de1-11e9-08deeee4f15f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|35042699022|14060799003|23010399003|36860700016|4143699003|6133799003|5023799004|11063799006|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	dqEDsd2LTXs0ANZf6aNkS0d24nTDud6lC1UH316bagd9I1wPAGtiT5Ch1hEIe95CNORz1vDUdeDkhCM+fMIOKhKCZgmECGVxwrgk7olCt5UTBIIXnU20sq/5iqP4QO8M37OtLmcqFGlLJo/DYZfTLdHoYtm2sgegWuUeHc5rBOHAP8wsBRA1ycvozc9rMxvGDdiGvTgOO4oQlVNSGL4kWJonlUv9aTSZhxnSSrMXNNGBI6j6pc2zrr3qfwHDaqHvEIYcYrJca0+zsLYcFSmf4RFR8PSgaFQ2BVcxfEOd1n/F+k64wrjl7zeWIBTCBCmzXv0uCn8xvKj9fltNuXzgxoANQv6Q/W6fvwxHyVLmQ6OnQoZ0hwqgTVoVipIYiAOGD9TN2tNHEWikBNFdfS0CbH2xCysjslNKziLFVdAqWc3pIg04C0GKamN3mqDkrsAfBVCWnIlQqLVU+okVA3X/SoztLd0Zpi94PYMxoy3J0q3ViGPezsFjhMFOSpBe3BPl/N4nQOeru88+ezcU6SNvKEWicUgUXGCir5DTgS2o5MdafaWCEWneSaB/uNLGotyWRUJS91r3Oam5xdUEs9DwV/4Bopa9sNYKBQoAGMAH1vhCR3Cj+dyzOYqpNo6WnBufg0p27R/3eKwkNMs1sdYh/OQuDEyrtFOKZPh0+Q6HRc1QukUsxPGXDg2x/MHaGmMaiGgB14/r6k0B1rrGmX8RMw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(35042699022)(14060799003)(23010399003)(36860700016)(4143699003)(6133799003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/u4WLl0K8pt+2+s0BJS3LRmG6ltF6NhOQRxPL4mqjIBWFxRVvVYqB4HevYHGZ7al1PGlgOfLwkmfbDGGNDWjDZ8phri5XcUEqoYZmpQ1zRDz8AVeR2fYNeydgEPeM6g71LPgDz/Rwamk55RjgXeezBZBG5Bw8+yr4BaQFDINFAWpmfBQuqWKxL3aAIsw6kM84wAXQSJd9dvQXvY9OwuWFdaoj4wVIQykWSEztppyAitUxXl8uBQp8saNqh+9fK4DfQ6UHKTBc62yLsrDi95kn8ALq9i59opMEaLeLYoXuvP/0hvp9/braft+K2xKTlelK91WFiqLUJ4VwHzHyGDOV7itXRnt/FfmNwqrRyaIKkaE9vU9i3QbMWTjRID8rYKcdsSAtLkOjpoWa77GVEG0zQUHXCKKqv4mqgeVWQqwWyQHaH3ev7uGsSS7BWw5RVK2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 09:21:22.7328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9529ac9-62c9-4f52-19c6-08deeee516aa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8291

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjIxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBFeHBvc2luZyBhIGxhdGVudCBtZW1vcnkgbGVhayBvZiBgZ2ljX2t2bV9pbmZvYCBpbiBL
Vk0ncw0KPiBpbml0aWFsaXphdGlvbiBlcnJvciBwYXRoIHdoZW4gYSByZXF1aXJlZCBtYWludGVu
YW5jZSBJUlEgaXMgYWJzZW50DQo+IG9uIEdJQ3Y1IGxlZ2FjeS1jYXBhYmxlIHN5c3RlbXMuDQo+
IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzFdOiBbUEFUQ0ggdjQgMDEvNDhdIGlycWNoaXAvZ2ljLXY1
OiBBbGxvdyBLVk0gc2V0dXANCj4gd2l0aG91dCBhIG1haW50ZW5hbmNlIElSUSAtLS0NCj4gY29t
bWl0IDRhMWM2ZTUxMDhjYWFkZGY4YzQ5MmY0OGFjNGNiNDU2OGFiNjBjNTINCj4gQXV0aG9yOiBT
YXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gaXJxY2hpcC9n
aWMtdjU6IEFsbG93IEtWTSBzZXR1cCB3aXRob3V0IGEgbWFpbnRlbmFuY2UgSVJRDQo+IA0KPiBU
aGlzIGNvbW1pdCBtb2RpZmllcyB0aGUgR0lDdjUgaW5pdGlhbGl6YXRpb24gdG8gbm8gbG9uZ2Vy
IHJlamVjdCBLVk0NCj4gc2V0dXANCj4gc29sZWx5IGR1ZSB0byBhIG1pc3NpbmcgbWFpbnRlbmFu
Y2UgaW50ZXJydXB0LiBJbnN0ZWFkLCBpdCBkZWxlZ2F0ZXMNCj4gdGhpcw0KPiB2YWxpZGF0aW9u
IHRvIEtWTSBieSBwYXNzaW5nIGEgc3BlY2lmaWMgY29uZmlndXJhdGlvbiBmbGFnIGJhc2VkIG9u
DQo+IGxlZ2FjeQ0KPiBzdXBwb3J0IGNhcGFiaWxpdGllcy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMgYi9kcml2ZXJzL2lycWNoaXAvaXJxLQ0KPiA+
IGdpYy12NS5jDQo+ID4gaW5kZXggZTlkMTc5NTIzNWE2Ni4uYzA0NTIzYTQzOGNlZSAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jDQo+ID4gKysrIGIvZHJpdmVy
cy9pcnFjaGlwL2lycS1naWMtdjUuYw0KPiA+IEBAIC0xMTQzLDEwICsxMTQzLDE4IEBAIHN0YXRp
YyB2b2lkIF9faW5pdA0KPiA+IGdpY19vZl9zZXR1cF9rdm1faW5mbyhzdHJ1Y3QgZGV2aWNlX25v
ZGUgKm5vZGUpDQo+ID4gwqAJLyogR0lDIFZpcnR1YWwgQ1BVIGludGVyZmFjZSBtYWludGVuYW5j
ZSBpbnRlcnJ1cHQgKi8NCj4gPiDCoAlnaWNfdjVfa3ZtX2luZm8ubm9fbWFpbnRfaXJxX21hc2sg
PSBmYWxzZTsNCj4gPiDCoAlnaWNfdjVfa3ZtX2luZm8ubWFpbnRfaXJxID0gaXJxX29mX3BhcnNl
X2FuZF9tYXAobm9kZSwgMCk7DQo+ID4gLQlpZiAoIWdpY192NV9rdm1faW5mby5tYWludF9pcnEp
IHsNCj4gPiAtCQlwcl93YXJuKCJjYW5ub3QgZmluZCBHSUN2NSB2aXJ0dWFsIENQVSBpbnRlcmZh
Y2UNCj4gPiBtYWludGVuYW5jZSBpbnRlcnJ1cHRcbiIpOw0KPiA+IC0JCXJldHVybjsNCj4gPiAt
CX0NCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogV2UgcmVxdWlyZSBhbiBNSSBpZiB3ZSBoYXZl
IGxlZ2FjeSBzdXBwb3J0LCBidXQgZG9uJ3QsDQo+ID4gb3RoZXJ3aXNlLg0KPiA+ICsJICogR2l2
ZW4gdGhhdCB0aGVyZSdzIGFuIGV4aXN0aW5nIGZsYWcgdG8gY29udmV5IHRoYXQgYW4NCj4gPiBN
SSBpc24ndA0KPiA+ICsJICogbmVlZGVkLCB3ZSAoYWIpdXNlIGl0IHRvIHRlbGwgS1ZNIHRoYXQg
dGhlIE1JIGlzbid0DQo+ID4gbmVlZGVkIGlmIHdlDQo+ID4gKwkgKiBkb24ndCBzdXBwb3J0IGxl
Z2FjeS4NCj4gPiArCSAqDQo+ID4gKwkgKiBUaGUgY2hlY2sgZm9yIEFSTTY0X0hBU19HSUNWNV9M
RUdBQ1kgZXhwbGljaXRseSBkb2Vzbid0DQo+ID4gdXNlDQo+ID4gKwkgKiBjcHVzX2hhdmVfZmlu
YWxfY2FwKCkgaGVyZSBhcyB3ZSBydW4gdG9vIGVhcmx5Lg0KPiA+ICsJICovDQo+ID4gKwlpZiAo
IWNwdXNfaGF2ZV9jYXAoQVJNNjRfSEFTX0dJQ1Y1X0xFR0FDWSkgJiYNCj4gPiAhZ2ljX3Y1X2t2
bV9pbmZvLm1haW50X2lycSkNCj4gPiArCQlnaWNfdjVfa3ZtX2luZm8ubm9fbWFpbnRfaXJxX21h
c2sgPSB0cnVlOw0KPiA+IMKgDQo+ID4gwqAJdmdpY19zZXRfa3ZtX2luZm8oJmdpY192NV9rdm1f
aW5mbyk7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gQnkgcmVtb3ZpbmcgdGhlIGVhcmx5
IHJldHVybiBoZXJlLCBkb2VzIHRoaXMgZXhwb3NlIGEgbWVtb3J5IGxlYWsgaW4NCj4gS1ZNJ3MN
Cj4gaW5pdGlhbGl6YXRpb24gZXJyb3IgcGF0aD8NCj4gDQo+IElmIGEgc3lzdGVtIGhhcyBBUk02
NF9IQVNfR0lDVjVfTEVHQUNZIHN1cHBvcnQgYnV0IHRoZSBtYWludGVuYW5jZQ0KPiBpbnRlcnJ1
cHQNCj4gaXMgbWlzc2luZywgd2Ugbm93IHBhc3Mgbm9fbWFpbnRfaXJxX21hc2sgPSBmYWxzZSBh
bmQgbWFpbnRfaXJxID0gMA0KPiB0bw0KPiB2Z2ljX3NldF9rdm1faW5mbygpIGluIGRyaXZlcnMv
aXJxY2hpcC9pcnEtZ2ljLQ0KPiB2NS5jOmdpY19vZl9zZXR1cF9rdm1faW5mbygpLg0KPiANCj4g
V2hlbiB0aGlzIGNvbmZpZ3VyYXRpb24gcmVhY2hlcyBLVk06DQo+IA0KPiBhcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtaW5pdC5jOmt2bV92Z2ljX2h5cF9pbml0KCkgew0KPiDCoMKgwqAgLi4uDQo+
IMKgwqDCoCBpZiAoaGFzX21hc2sgJiYgIWdpY19rdm1faW5mby0+bWFpbnRfaXJxKSB7DQo+IMKg
wqDCoMKgwqDCoMKgIGt2bV9lcnIoIk5vIHZnaWMgbWFpbnRlbmFuY2UgaXJxXG4iKTsNCj4gwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIC1FTlhJTzsNCj4gwqDCoMKgIH0NCj4gwqDCoMKgIC4uLg0KPiB9
DQo+IA0KPiBJdCBsb29rcyBsaWtlIGt2bV92Z2ljX2h5cF9pbml0KCkgcmV0dXJucyAtRU5YSU8g
d2l0aG91dCBmcmVlaW5nIHRoZQ0KPiBkeW5hbWljYWxseSBhbGxvY2F0ZWQgZ2ljX2t2bV9pbmZv
IHN0cnVjdHVyZSwgY2F1c2luZyBhIG1lbW9yeSBsZWFrLg0KDQpXZSd2ZSBwcmV2aW91c2x5IGRp
c2N1c3NlZCB0aGlzIGV4YWN0IGlzc3VlIGFzIHlvdSByYWlzZWQgaXQgbGFzdCB0aW1lLg0KVGhp
cyBpcyB0aGUgd2F5IHRoYXQgdGhlIGV4aXN0aW5nIGNvZGUgd29ya3MgZm9yIGEgR0lDdjMgc3lz
dGVtIHRvby4NCkZvciB0aGUgdGltZSBiZWluZyB0aGlzIGlzIGZpbmUuIEkgaW50ZW5kIG9uIHBv
c3RpbmcgYSBmb2xsb3cgdXAgcGF0Y2gNCmF0IHNvbWUgcG9pbnQgdG8gY2xlYW4gdGhpbmdzIHVw
LCBidXQgdGhhdCBpcyBub3QgaW5jbHVkZWQgd2l0aCB0aGlzDQpzZXJpZXMgYXMgaXQgc2ltcGx5
IGRvZXMgbm90IGJlbG9uZyBoZXJlLg0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gPiDCoH0N
Cj4gDQoNCg==
