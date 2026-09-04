Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013055.outbound.protection.outlook.com [52.101.72.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6C746F4B3;
	Fri,  4 Sep 2026 10:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518324; cv=fail; b=J2Hl4ty/lvJmDgiW1ABObNh6V6zqZSp2+jeFZbtXyzq/y42R9VKEU6yrMGoXba0YREWuyD7Ox7sX/+ZmuQNV2judj+DZb+I/ArA8Cuee/pFiGyJw9lSR4Uks+pjt49XC+r4k1Pn7/PX23DVoFpwjpQqgVCz/PtBq8x0YkgmgA8U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518324; c=relaxed/simple;
	bh=RcCnvBBqB2bFnfzoTSEWVKvNPuG13vBqzVySPM6r5o0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kvOxQC2EwHjN3qkhgMOcHeAj13e327N1r1t7M8AerWBOIJAGploQk4Ae0Fv9b52o8QqpMZ7Cpg1yZkQXE4vsDqrH1bV+vYxSHewITxEexf+rrDk+aBE+vtnvTN5fiOkAtm2u3+S29N1n8F2bfhK838DSeNLyesv1/AAvOtSYbts=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PONUP7Tz; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PONUP7Tz; arc=fail smtp.client-ip=52.101.72.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PONUP7Tz";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PONUP7Tz"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MFd68JuMpDpXb6KQQNrgeoPSESiDWhzI69ET0pYN5YZ/OdloxrCpYUHs27AJSksh4uI+2P8X93EgneYgohTYnYvdodY5tlLhgnonRmiL/wGTrqfNIf8qged9Hvwn2OvtsTEOFSA0h6Q8hwW+lSvEc8gjA4TSRq29H0WukILacDaVPJZnQXkSZAN7wuutY4M1IshszY1l+d7j6Jyo6veXAujoPthEqwB5qFv1VeOd2xyHe2dAKtJYDRmqTa7JLa6gLavi7sS3v+R+emCPqfFbuC1C7R4KTX86EhCNwCyyY5gc/zBZrPve3N7B1CO/vJwqhM5kN+qMJjdESOGfgwofPg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcCnvBBqB2bFnfzoTSEWVKvNPuG13vBqzVySPM6r5o0=;
 b=V3jcvCbby5nBe0U1zYxagxrV1aT1EBkjila/FsHu3EMdiXKN1btiIhalvvO0wDUxbRBkl24qR6Yb8goPjGeXxEu25p3elpN9i5OGxOmwFeHRvt49+7tVk1kawfcf87myKwZaoVI8FbArikK/mRIRA0DdRghDJm6LKEg1gEQldRalko1zUssD9vBwXJ2fysiR9nAyuI7pS1EaRxiTELHmRW92XN8J5hmzdhtFypeTlNJHIUu4XTr++YqEIkgQHjZtKAWnmPNoH1hcz6P2vBYfZd+p2+L5H+X58+cMcu+JzYS709B+FKYBcEHUsJdvKpJNxrFFQWsQQt3HXhkBZFQctA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcCnvBBqB2bFnfzoTSEWVKvNPuG13vBqzVySPM6r5o0=;
 b=PONUP7TzD0zwIl4zR5/aj/5Agy+QxrWd5j5aofb3QTOf2DW141p+IFxaR5lRkzMA745rJWnVweTN+UnMw7Q+eT0RfiR7amW+17TwstjpoCgrmJjAWqwxSedl/r7fLZCsUOFZXHXpiYAs0YRLdPeRqX2trvT+apIjXUOB5fJ2zdA=
Received: from DUZPR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::11) by DB9PR08MB8228.eurprd08.prod.outlook.com
 (2603:10a6:10:37f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:38:34 +0000
Received: from DB1PEPF00050A01.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::5e) by DUZPR01CA0155.outlook.office365.com
 (2603:10a6:10:4bd::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 10:38:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A01.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sd/IP6cyQd4kBgBFCvcKxL9But+u7mkUiPAN07lAo23JrZe7O4qdoe930Pu12ReFHiBUup4rG/s57BYURn0ltLKlzm7UUWmzMBooE8Hub2GZPuKESdNOPC6P+Yne7Sp4KhVlTujnHZPHbAtbycyR/FMNbsg2xjVaWcv4bu9k5hT+G9aIJM08KsCCk/piRp3BADLoR6ec3DEyVbzfhkBfoJHhKPT+5uHjIzvpaH85F6/NRdH1YQkPVYTq9iRzRfu9HJ6D3+i73W+H7EcU6bNfeHK2fV3QCO6yhwuyeKK+uwpEfwsgbUKlzR5KRxK1OvbRx68k4emjOpyofjCfdkxNng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcCnvBBqB2bFnfzoTSEWVKvNPuG13vBqzVySPM6r5o0=;
 b=y6eXhA6qllaeIga+UPDhByCh2IQgwZvIT0nSudLnQSX1+5xdy+a+4gDobx07dN69n+a7ehV5HaA6wUxGQLG5JzgsoJNZ3iI259DPdQk7XjGcLFviQ4L3RWIan9yBZneVO0VmHxCuPG1TjpI8iPR9SClBN+pkNisDiIDzgX5TmQus0WuF0ASB7vWCt1boQzsaFlRZoYSuiNCrZzJXWZkDXxanXSdJ0sAjQXAPbh40AnO2WhsjZwDhtFjgS7DALLYQzmQR9JIiVdJTdcELBERHs/b/bwbXYEcrBnjM5qwDO7YKpC319awvvdgOLo18S91VLUMXgHG5CM3YE09B4b4yKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcCnvBBqB2bFnfzoTSEWVKvNPuG13vBqzVySPM6r5o0=;
 b=PONUP7TzD0zwIl4zR5/aj/5Agy+QxrWd5j5aofb3QTOf2DW141p+IFxaR5lRkzMA745rJWnVweTN+UnMw7Q+eT0RfiR7amW+17TwstjpoCgrmJjAWqwxSedl/r7fLZCsUOFZXHXpiYAs0YRLdPeRqX2trvT+apIjXUOB5fJ2zdA=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DU0PR08MB9848.eurprd08.prod.outlook.com (2603:10a6:10:443::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:38:00 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:38:00 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Thread-Topic: [PATCH v5 42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Thread-Index: AQHdJmCjdpfJzq7xTUeqlknPK0qwf7aS1IyAgCuRm4A=
Date: Fri, 4 Sep 2026 10:38:00 +0000
Message-ID: <dbc4a6c5dc7e3107870e82ba9a7bddb910d1118e.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-43-sascha.bischoff@arm.com>
	 <20260807171742.295DA1F000E9@smtp.kernel.org>
In-Reply-To: <20260807171742.295DA1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DU0PR08MB9848:EE_|DB1PEPF00050A01:EE_|DB9PR08MB8228:EE_
X-MS-Office365-Filtering-Correlation-Id: c3fc7431-09d0-4be6-79c5-08df0a70ab55
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|22082099003|18002099003|56012099006|38070700021|10067099003|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 uV0sTmJR3vuCw8r7rmE/DX7E6aAprnRe+itWUsY1Ua7SN8/eCkFf64561J60R0q3Fluz1LuplwhtZhrFy1hb/4oW3PaztTe1PW9aUZO2LZouk9BvQUi96m3QwR6jN9qwLSz+izZvKWYAXfHyb0wCpIDSdPzJlkaSisVyyiBSsrkF/w5Ikp66sKYL8kxZNGYceJ4xTBcRbhS6zysQQv9KboDypT5wByM+dCbaY+Lap4NX1hvuFErbhPcLiEsAXNqX85pcOLB0DOrefXxxkGmtw3Ys8ruTsoiezkEcYE/3zE2kVwcuWcq6Eun3nh6YD6qkNT9maBt07gb+PxPaPKGYr3uptnV46brMl8h/1cl6GeEKtf6sSz8fHgssB6ciphau2ziSJDgjHqecuo4dcXchrNxNsECqsFAjz//ZNXkAGuoNciGkow5u/n0GN0VXCFWlaYE2tlKsRBbbGJ3eB9lSj7C3Tlw0+7ejzh3A1FqRkXOV5S7tA9FFQ0ZbQHHi009sSKccHgrIgTLgfmoRHZr11E0wFFwDGDA85WWEq07G2qJxfufwbQADITukzUVj1hkqo2NF9t/7CF1tNGoLJgfQ7c8+1VGGx8mhISvpexaTCyScXkmnGRFFmgkU/nt1KTrTrkZmceEeVK/eFvBDWeX4i8kCiE4JO7BgAjJJIz9UT8DchEn1UwNkQS3cJBAZYlt4wBpLQobYxbXoB3y1/ME/g8W/XDK5pgRdEboiZQCb7ng=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(22082099003)(18002099003)(56012099006)(38070700021)(10067099003)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E6B8275B4CDCF4BA45C81C2FF09D8AC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 VM6GrbhCIjiifzKezvpt0OELVJQ5n5X7Hu2lHtt0vdmqV7QA/VhNZA+orXeR2jeqgu0qIHuH2M6AFOxDG6qawfXGfnmvYJF0yol6fOK2rPc4f8B0oAMtpai3Ahg+L2TF//CDtmBOwH1l7RqXXhBAwk8Og08m+pOXgbon5dHbZxdX3OG7zvpuGM6e86fPNM6keY0Z9APVh0tvAarmg6ASzb+UeBbRPwZkQdtQR6To1otIlbFrDS2l7jCHRZZIm+CLsLbsDT7o78L3QpA7kya4rrxXN7Vbr9aPLNfoiCIP/xkSoglNIUrfUz4YKECvO/m1rZCwiaItwbUS5vY/aJXH4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9848
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7888e7f0-bf55-4132-4f01-08df0a7097a1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|376014|1800799024|82310400026|23010399003|4143699003|11063799006|6133799003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WSL62cP6+1Tpr06g8wm6TW1E06sm2He98onwXVjww92R/IB9fF6IMu8mg42kQOIGG0yN4LgthlsCqvkbDINFKfnAtVbYlfzY/2PPL620eWzacVg1DcYP2p2h6tvZBEbUIoLuvhKfy57AFikhybVLp5gCX+RiGOYha7jkODB3Da/q/7EdoGr39OZRm7/P4T3tEfV0T4GQmeFtqUsfUt0TCAN2MrJPrbFXLw7dD0NpB2nR7+QCaEOPN7WWgD3hOnIyaz6LC/rehrEzUqMndhO8huid3f77ndrRmKWDLQLHQdatkaVYnKHKTiJe8md0kDhsG2sWWmGh3+SOpHccpu6ptuvERFoEBlU2ku1e+ycY7h1Is0mHXwWiLYkBGcg+KW5vfD0mzW6GrCYVlZxNK+ZCADuDyEpdYjQcWZZ3WBUPqxIYb+cTYCytPEFeNoVtP0/rI7O1lML79gKJrrPw7Q/x74NHZnOtAmTLrlSIsLffxrjhhn2ondQ0/AQY+RQe24S8ICRdKrSaIT6YypUzgNpjub9GLgaBAa6ingng4oQx0PV/SUiuuOTppEBVPwYRGw7oW/sj1y2Owua5/3R3hjwlfm5G4aIItapUhBFlZwGaJXGZxSuMKtwlVgSONHUBBRatL6gAJxN5QUlJfkOmXKM+EQCYlWN/TTm+Yln54nkQVU8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(376014)(1800799024)(82310400026)(23010399003)(4143699003)(11063799006)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t4mnuaqfcEDOwUAdIVMPupXcf7qCESnZz31RSlPnEOq7T6cVr52KvPpcLWCUTKoCNZC30XV349w0fSjf45eWvs8S3ddLt9CfS5czJdlROnSUql91dfb2jlvjdIcc+uCpU+HtSOFpX6nkL7TSXAbQXYzeZ0SOja8k3/3Pprn+kMmuU9zSmJ6OPKEmig3sYTUdkQUtr94MHrZuDBJrbORfc0/EabRQrtmvvpbFd5cVW1sdP7QZ5zBiLtVQSJb4wqlPYPmecg90hZmBdBhbvJ17zsLYcClLh5l5kyJRRALXeSjqK8uVRniylqvR9bKsixzLlOVerwz8Xft7v1/4z3RZO/9c0iRaxznFK7KVIGuOgIUPkn3v77Gy/IU/KAcIPos+9s5AD2QDwUZwNQTX+0MmORiWtGgkVDHIUW+1hpunllGzSvOqGeYWDz2FKQwoLIMC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:38:33.5920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3fc7431-09d0-4be6-79c5-08df0a70ab55
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8228

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE3OjE3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBUaGUgc2VsZnRlc3QgZm9yIHZhbGlkYXRpbmcgYEdJQ1Y1X0lSU19JRFIwYCBkb21haW4N
Cj4gcmVqZWN0aW9uIGFzc2lnbnMgYSBjb21wbGV0ZWx5IHplcm9lZCB2YWx1ZSB0byBgdmFsYCBp
bnN0ZWFkIG9mDQo+IG1vZGlmeWluZyB0aGUgZXhpc3RpbmcgcmVnaXN0ZXIgdmFsdWUsIG1ha2lu
ZyB0aGUgdGVzdCBpbmVmZmVjdGl2ZS4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNDJdOiBbUEFU
Q0ggdjUgNDIvNDldIEtWTTogc2VsZnRlc3RzOiBBZGQgVkdJQ3Y1IElSU19SRUdTDQo+IGF0dHJp
YnV0ZSB0ZXN0cyAtLS0NCj4gY29tbWl0IDExZmNiZWY5ZTc5OTU2ZjIwMDMwZjFhOTNjMGVlYWJh
NDQzNzVhZDgNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0u
Y29tPg0KPiANCj4gS1ZNOiBzZWxmdGVzdHM6IEFkZCBWR0lDdjUgSVJTX1JFR1MgYXR0cmlidXRl
IHRlc3RzDQo+IMKgwqDCoCANCj4gVGhpcyBjb21taXQgYWRkcyB0ZXN0IGNvdmVyYWdlIGZvciB0
aGUgVkdJQ3Y1IElSU19SRUdTIGF0dHJpYnV0ZQ0KPiBncm91cC4NCj4gSXQgdmVyaWZpZXMgdGhh
dCBLVk0gcHJvcGVybHkgZXhwb3NlcyB2YWxpZCByZWdpc3RlcnMgYW5kIHJlamVjdHMNCj4gaW52
YWxpZCBpbnB1dHMsIGJhZCBvZmZzZXRzLCBvciBpbmNvcnJlY3QgYWxpZ25tZW50Lg0KPiANCj4g
PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUu
Yw0KPiA+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+
IGluZGV4IGY0YzBkMmMwMDNiYjQuLjU0ZmExMzkwNjk5MGIgMTAwNjQ0DQo+ID4gLS0tIGEvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+ICsrKyBiL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hcm02NC92Z2ljX3Y1LmMNCj4gDQo+IFsgLi4uIF0NCj4g
DQo+ID4gQEAgLTI3Miw2ICszNDAsMTg5IEBAIHN0YXRpYyB2b2lkIHRlc3RfdmdpY192NV9ucl9p
cnFzX2F0dHJzKHZvaWQpDQo+ID4gwqANCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgdm9p
ZCB0ZXN0X3ZnaWNfdjVfaXJzX3JlZ3NfYXR0cnModm9pZCkNCj4gPiArew0KPiANCj4gWyAuLi4g
XQ0KPiANCj4gPiArCS8qIElEIHJlc3RvcmUgdmFsaWRhdGlvbiByZWplY3RzIHVuc3VwcG9ydGVk
IHZhbHVlcy4gKi8NCj4gPiArCXZhbCA9IEZJRUxEX1BSRVAoR0lDVjVfSVJTX0lEUjBfSU5UX0RP
TSwNCj4gPiBHSUNWNV9JUlNfSURSMF9JTlRfRE9NX1NFQ1VSRSk7DQo+ID4gKwlyZXQgPSBfX2t2
bV9kZXZpY2VfYXR0cl9zZXQodi5naWNfZmQsDQo+ID4gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVJT
X1JFR1MsDQo+ID4gKwkJCQnCoMKgwqAgR0lDVjVfSVJTX0lEUjAsICZ2YWwpOw0KPiA+ICsJVEVT
VF9BU1NFUlQocmV0ICYmIGVycm5vID09IEVJTlZBTCwgIkdJQ3Y1IElSU19SRUdTDQo+ID4gYWNj
ZXB0ZWQgYmFkIElEUjAgZG9tYWluIik7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gV2ls
bCB0aGlzIHRlc3QgZWZmZWN0aXZlbHkgY2hlY2sgdGhlIElOVF9ET00gZmllbGQgcmVqZWN0aW9u
Pw0KPiANCj4gU2luY2UgdmFsIGlzIGFzc2lnbmVkIGRpcmVjdGx5IHJhdGhlciB0aGFuIG1vZGlm
eWluZyBhIHZhbGlkIHJlYWQNCj4gdmFsdWUgKGxpa2UNCj4gdGhlIFNFVExQSSB0ZXN0IGJlbG93
IGl0KSwgYW5kIHNpbmNlIEdJQ1Y1X0lSU19JRFIwX0lOVF9ET01fU0VDVVJFIGlzDQo+IDAsDQo+
IHZhbCBpcyBldmFsdWF0ZWQgYXMgMC4gDQo+IA0KPiBUaGUga2VybmVsIHdpbGwgbGlrZWx5IHJl
amVjdCBJRFIwID0gMCBkdWUgdG8gb3RoZXIgbWlzbWF0Y2hlZCBmaWVsZHMNCj4gKHN1Y2gNCj4g
YXMgdmVyc2lvbiBudW1iZXJzIG9yIGZlYXR1cmUgYml0cyksIG1ha2luZyB0aGlzIHRlc3QgcGFz
cyBldmVuIGlmDQo+IHRoZSBrZXJuZWwNCj4gZmFpbHMgdG8gdmFsaWRhdGUgdGhlIElOVF9ET00g
ZmllbGQgc3BlY2lmaWNhbGx5Lg0KPiANCj4gQ291bGQgdGhpcyBiZSB1cGRhdGVkIHRvIHJlYWQg
dGhlIGV4aXN0aW5nIElEUjAgdmFsdWUgYW5kIG1vZGlmeSBpdHMNCj4gSU5UX0RPTQ0KPiBmaWVs
ZCBiZWZvcmUgY2FsbGluZyBfX2t2bV9kZXZpY2VfYXR0cl9zZXQ/DQoNCkdvb2QgcG9pbnQuIEEg
emVybyB2YWx1ZSBjdXJyZW50bHkgaXMgcmVqZWN0ZWQgc3BlY2lmaWNhbGx5IGJlY2F1c2UgaXQN
CnNlbGVjdHMgdGhlIFNlY3VyZSBkb21haW4sIGJ1dCBwcmVzZXJ2aW5nIHRoZSBvdGhlciBJRFIw
IGZpZWxkcyBtYWtlcw0KdGhlIHRlc3TigJlzIGludGVudCBjbGVhcmVyIGFuZCBzaG91bGQgYmUg
bW9yZSBmdXR1cmUtcHJvb2YuIEnigJl2ZSBjaGFuZ2VkDQp0aGUgdGVzdCB0byByZWFkIElEUjAg
YW5kIG1vZGlmeSBvbmx5IHRoZSBJTlRfRE9NIGZpZWxkIGl0c2VsZi4NCg0KPiANCj4gPiArDQo+
ID4gKwlyZXQgPSBfX2t2bV9kZXZpY2VfYXR0cl9nZXQodi5naWNfZmQsDQo+ID4gS1ZNX0RFVl9B
Uk1fVkdJQ19HUlBfSVJTX1JFR1MsDQo+ID4gKwkJCQnCoMKgwqAgR0lDVjVfSVJTX0lEUjAsICZ2
YWwpOw0KPiA+ICsJVEVTVF9BU1NFUlQoIXJldCwgIkdJQ3Y1IElSU19SRUdTIGdldCBJRFIwIGZh
aWxlZCIpOw0KPiA+ICsJdmFsIHw9IEdJQ1Y1X0lSU19JRFIwX1NFVExQSTsNCj4gPiArCXJldCA9
IF9fa3ZtX2RldmljZV9hdHRyX3NldCh2LmdpY19mZCwNCj4gPiBLVk1fREVWX0FSTV9WR0lDX0dS
UF9JUlNfUkVHUywNCj4gPiArCQkJCcKgwqDCoCBHSUNWNV9JUlNfSURSMCwgJnZhbCk7DQo+ID4g
KwlURVNUX0FTU0VSVChyZXQgJiYgZXJybm8gPT0gRUlOVkFMLCAiR0lDdjUgSVJTX1JFR1MNCj4g
PiBhY2NlcHRlZCB1bnN1cHBvcnRlZCBJRFIwIik7DQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
