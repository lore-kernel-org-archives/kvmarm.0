Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012016.outbound.protection.outlook.com [52.101.66.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC0A370ACA
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097279; cv=fail; b=jcRQ2pPWw32FNFqzzDgoqKNsH8Ogyh5/BZP9a8fMbGUlhyo6V+cEeCdBfCR58aKx+VJJcHnDeSge7fW8c2A4ba7d/SPRHtNWVYLdKtCxSWTeo1p0ozrGtejg0Sd3YlHU/5gkUohjcLZhzaLssGVmTjCTEJD8PCpV9lPDofMgguc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097279; c=relaxed/simple;
	bh=V9nffilbycpaMymRp+pWtOsMW9w4IIdU1SsqST240f4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mn5GC2AIb6nkpDi8H9FJq0BMcr6DB0k5YQBcyFer2B2BU7/fWfAu4ZZDrvb/5u4FYGUSn8ZQXnnA27maER64YQv38gRzZ8NxRfE/aZdRc1wkWfbTdRkYL5vn//HlHZLPJFyJInlcNoXpCp/PtpYxWnz7PZuy69ijhpNW4fqeLok=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kfOm4CTZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kfOm4CTZ; arc=fail smtp.client-ip=52.101.66.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kfOm4CTZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kfOm4CTZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=o+NQTdjpsVNYwsWr0Xm/2eT1cTxXzhUQ+NmKGH9dwLy47Qa+5foz7IQz4tSrSkymEkQRkO/DX8nsIJCx+vWZFiHrZxNR8LrXbidTLYdLT5Bi0/NzQGvdM4adjnw2fS/vGzy3UAUPESknXHhkIDxL+8M61YlPFksTpp9Mz3sWvaffzmgOEZ3W7ogcy10532y6iTAH7ak+3IUuWbrid0EWOEF2ZAgtm9cKcFHTWS7DtFkk8lgbJcvTfWk7BT6M3lcHkpbQNY34r9FtFmzeWdf8hK2uVGaGz5bHH/OPEE7ud8T44PCsvzme8zIE4KJtbf6d3UPKruoJMDofmdFvFmcJ3w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9nffilbycpaMymRp+pWtOsMW9w4IIdU1SsqST240f4=;
 b=QfgsB0sTn8H+e2GE/tC4Cmbxr/sy07lrlp16tKEZ9dBcSh5g+3cOuIQTK6Mgzi2xBuM/J55tJcLbFTRR6L+x9kjvXMFuurhsS+eQ56cTr+kG0ZDvFBMkAx5z8iOQEyEJC7vs8p9Rh2wPr7bbA7KuJNeZh61h3K10ogBIVJxLHTsY5claqrxV/no224WQV/iAr0NEVaOECtb/MAzUm7hP0JW6TPNjf4TfaAqkoZ8z3em3HLyduDt8sVJlpDmYbQwKTxLr4nw9gRW0nfk053YnIIxPwMgZASR1FcHcZxDGsppK7WyYyymEevnwwuv/w0rljigSgj4Iw+uTjH2XTmQK2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9nffilbycpaMymRp+pWtOsMW9w4IIdU1SsqST240f4=;
 b=kfOm4CTZ5+IT4zWYDkBjWSdrvIewyWuLJTNySp/v0tN4T9VtJXlT2ve7oEUGH3Ur3V4uzU3/c06SU8rDpSx+X7/dM4qorhZh5Fc1pTjY2wbUF3NCGfwxMl4gMA0jFdXMUolIgw4wUQQzrEUBR5isx1QS9QWRrwnfLg9WAAhnT3k=
Received: from DUZPR01CA0138.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::14) by DB5PR08MB10287.eurprd08.prod.outlook.com
 (2603:10a6:10:4a5::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Fri, 7 Aug
 2026 10:07:49 +0000
Received: from DU2PEPF00028D02.eurprd03.prod.outlook.com
 (2603:10a6:10:4bc:cafe::3a) by DUZPR01CA0138.outlook.office365.com
 (2603:10a6:10:4bc::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 10:07:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D02.mail.protection.outlook.com (10.167.242.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 10:07:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBmXzz2aNtDXKsQTTkJTA8DcUt+EnOZk4gO1ZuoYFELMpJg5RQbAHWvGfhWzvwd5aAyjotnK2Wd4wRX7frnAv6V3XEJOC+yFHK0MqQnoQaqtMLt2BsKkW7DJDaBfLN70I/wTGBWidcHrjTI+njkuevI+FvyXup5+XBej47tLHoCg7WyUzSfECNrPa4IvsRgustah16ncHZ4GLh6WG03c7w9PgVGp+mwiM//ZJCHZ8KoYb1WOiq6SFBhUZYIT+0zVZstI4fvRRGCO51HCdoCgLQOpHAYkgnreUcAof58qiSfHFwZ3BiiAq6fc/Egjp70fBIYTfShM2oAj0G+ThBHtGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9nffilbycpaMymRp+pWtOsMW9w4IIdU1SsqST240f4=;
 b=O2CuuF7C50zWQsNFWcd3XZXPvUWztUKoohOqIAM7zNS0RqfCUT42J/SXiTQW030NTBBef6XPRTKMQAJpyp+HkEyhWR7MR4uFXht5eqk18DE1mNuAE8wndevD1w/gQJD3rh+t0E5yznDRQ52rBpA+IXwWaLiMplFZm7eIGI1NVk4DOfQDJbbLEQ8270IRRiyhOyxUQN74VRiuWwx6xbi3VfE6SfsvQlrLU2vV8irsmX+88sGeWmNGdNHDWoID+Sk8cPHEs9tq4n2WKsa1CyUiDjuztUoHGqo1COCd2KtvdQLLKfifoe5in23bGaaplFzJOF3LlqpE86o3DozQ3zXexw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9nffilbycpaMymRp+pWtOsMW9w4IIdU1SsqST240f4=;
 b=kfOm4CTZ5+IT4zWYDkBjWSdrvIewyWuLJTNySp/v0tN4T9VtJXlT2ve7oEUGH3Ur3V4uzU3/c06SU8rDpSx+X7/dM4qorhZh5Fc1pTjY2wbUF3NCGfwxMl4gMA0jFdXMUolIgw4wUQQzrEUBR5isx1QS9QWRrwnfLg9WAAhnT3k=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AM0PR08MB5347.eurprd08.prod.outlook.com (2603:10a6:208:17f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 10:07:16 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 10:07:16 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>, "maz@kernel.org"
	<maz@kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: Joey Gouly <Joey.Gouly@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"will@kernel.org" <will@kernel.org>, Catalin Marinas
	<Catalin.Marinas@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH v1 0/4] KVM: arm64: Fix unguarded GICv5 CPU interface
 accesses
Thread-Topic: [PATCH v1 0/4] KVM: arm64: Fix unguarded GICv5 CPU interface
 accesses
Thread-Index: AQHdJYrmok1Sz+/toUe98yDC8YIE5raSXfWA
Date: Fri, 7 Aug 2026 10:07:16 +0000
Message-ID: <8cbdfb61e4ceb8f82c9837cdc317afd12eb40492.camel@arm.com>
References: <20260806100256.371164-1-fuad.tabba@linux.dev>
In-Reply-To: <20260806100256.371164-1-fuad.tabba@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AM0PR08MB5347:EE_|DU2PEPF00028D02:EE_|DB5PR08MB10287:EE_
X-MS-Office365-Filtering-Correlation-Id: 82ffea84-0475-49be-a92d-08def46bbc35
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|11063799006|56012099006|4133799003|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 4MZfDpCKZIAzvoj7+saJpbagS0dWFPLR2VFEhOzJPQNxOy1OA41lHJsebTRzdh9M9bz/n0iLlSEo0PoK/HmW8+rXvbcLwPpe+adEJBT5E7LlyyIJSMVfH7x+oya82OIRDoy5qvQEBtGSniMsD9mGqByg+DzfYdyces6Vq15nyYrf6MG2pFykUnGPhiohNQGQgFNuBtTkCkvK+9fGwvR+tUyNaZJr1VnmlGwGkm7GtwYoq3DoP/OJatwvepr96WQv9HGIlA/cOHd6KPu7A0jb70dmZ1pbrz7rrPEJsR6JtrOcvtBtIXjKhsI8wwNVsdLwJXXAQn999G9Ux9MPlaSSMIhSyfNRC0kfin4qoyo8WM3wOxYm6AiMuIqGCqZArwrMluaDUFOq9oLfjgNVVfALl5WRIE5Czuqa4jAvM++BqazMgyPHGF3xxjTaNZOipPhCiZcLeJaEjnrBlW40TEyAIWEATKMe4rESmfdp2t2YYL/ZXceRv2v+Yyt3GNUkWypRSZIG/6mYLaFpk5lPB1WaZRYAng7/Cp6D2N9IjazXKZI5jRGikXkL99pjEtnYRRN7aCA71MpZBn6Lk9TXGCNib9zFmdEu73gkRzpN1GSIpjz4e6u6fZNSf/sleEdDrFcX3oA44mG9Bo8Akz1Uj8XTrOyxupalMnV18ArP7wmII3XPTnRzw6+qv4lB4mlFIO+IksZanI3+0ui1f2JB57FKBIGIQyGDIZmgvstCF6hEQlM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(4133799003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A01298B0D3EC641A030770A1FB32A12@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kAqo1ulkisICNsH0qpNfrG4XUc9LnjjQXkvvwmC/Bkh2rcl2SJIB8qbqVaTsJxVFX7TSv7WdCIXQk8JQThV/7bcqxPAlAVGjKhGFUVVsCwpyEcwxx5oq/QGyRI6WHkNpa7XdgPzAKG+TAnmc4yxlQr7Uo8hQJma71Zg954T9dJVjR1duPcP67tTQAfnk0bzUbgbfKTAJZcABZ9z0fqGnx6B+BOqZznDhNbybqC+9t5Ry6v3wR8IM3tjzaDJks1zF0Yw/Eh/aUb65AW+lRJ/ky/1HZmnhGmKtQeFo4lK7FV1PK3n24Fl9oyoRVEUt4txjwlrShPD6B1CO07ETuY8Zrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5347
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	df01bb71-a27b-462c-86f6-08def46ba8b7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|35042699022|14060799003|376014|23010399003|82310400026|11063799006|56012099006|10067099003|18002099003|22082099003|4133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	cbwgG4HnfmqvRiZpQHeyKWZOkI4h0+6XsuYuyHXbRUsUeBDaCf1jBIrPgGUwtqWPasOVuKVdvwiHsBmmeQJB8ky6G/K9Hb7L8Cz2yZBI7KR8CHuO0wPPPzY7R+G7t7445O3L1AR5Ad8rVUeaxXV+QxZDOuEZRyoJFU55B/WuKMtsN9yx9mK6wD1hMblslGh3kWPDxgMjBFsTso7RV7ki+ku4ijSbe0V/SmgSJk3YwDhAhV2Nva8Qua0oZtRwUrhb3AQ6M8lS6hEyKdWZ25hcuup0jPyBDMvPX/L5izUF2TevIGNWsud0ZsSAZL7GLkSCUxpsHZyeKIPPrfwObDeg7YyhWnQJdCrlvNDSD5NXAl5PDbXlcPZT9AaCG3Zz853i7IbWuEV7sNCA6do2nMqKFBxQoV4AxKcdRwLeeN2KaAs2CXlqIdGVUpIwpp8cJWZJQWKJt0WShvdsHrZqW8MAXmMaLGSg+u6TW+Hl2OhApmvR7/W3hL8HLvZ8G5nW70QPIOJAyN+y/yRwo+W+bEk9VpH76/9EChEJ7GSjL7rfVuqZiEwunKr2CTsc9fjt0NbQHzViDtY870Cdkfp4UqFaQONMyeWqTyB0dIwLHyAcAh8UeLtFfPifkimvdl/jJKiCyesM2Iup4G0ULiH6TH29uAR5CLB5XS1puCCiW7RxS9fLfIGMzRKu0rEM6oVGD78YaG83qCQkrCeWCbxefgN5Ag==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(35042699022)(14060799003)(376014)(23010399003)(82310400026)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(4133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nfjATfOXvQYtKenBCcq4g9IfHEHbQyWJ/576eWQsrkE47E7w4ZgVMpyzWZgIgU9+T2WuivRr86Z7g30Af+R286DNNiUGtydXB38shvhzjrm6IoPOaXHSaPxpmBtFpf7eHBllTU7AiGx437j3mjETOqActjAoFemWPjxhuOMEgwVKfQt8tzE8MhOjs+Ojn3pMxVyhzYT7mE81RTPd7MWE4ibRsOC/yOUp+9jp5A/DsJYMGnTG7ol/t75IPpqn94B6rHBohgcU6DOrPfORUNKWDYeLC+MHVIys/nhkLwHbBLBX1FbpUuQP38fi1qKUOyGIszW4GfjMGCWYeIlDj9uRk7SYy9PV1ROeIH8iWlruZavySDo+6n71uB/RFnHSj9VtGJMmLh9xq1gXLwSLRpuaVqWtcSg18mvQlYo+j7ixeqChCZgKfOaOPdCN+Ez/odkz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 10:07:48.8371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ffea84-0475-49be-a92d-08def46bbc35
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10287

SGkgRnVhZCwNCk9uIFRodSwgMjAyNi0wOC0wNiBhdCAxMTowMiArMDEwMCwgRnVhZCBUYWJiYSB3
cm90ZToNCj4gSGkgZm9sa3MsDQo+IA0KPiBUaGlzIHNlcmllcyBzdG9wcyBLVk0gcmVhY2hpbmcg
R0lDdjUgQ1BVIGludGVyZmFjZSByZWdpc3RlcnMgb24NCj4gaGFyZHdhcmUNCj4gdGhhdCBkb2Vz
IG5vdCBpbXBsZW1lbnQgdGhlbSwgaW4gdGhyZWUgcGxhY2VzIHdpdGggbm8gZ3VhcmQuDQoNClRo
YW5rIHlvdSBmb3IgZml4aW5nIG15IG1lc3MhDQoNCkknZCBuYWl2ZWx5IGFzc3VtZWQgdGhhdCBp
ZiB3ZSBkb24ndCBhbGxvdyBhIHZHSUN2NSB0byBiZSBpbml0aWFsaXNlZCwNCnRoZW4gd2UnZCBu
b3QgYmUgZ29pbmcgZG93biB0aGVzZSBwYXRocy4gT2J2aW91c2x5LCB0aGF0IGRvZXNuJ3QgcXVp
dGUNCmZpdCB3aXRoIHRoZSBwS1ZNIG1vZGVsLg0KDQo+IFVuZGVyIHBLVk0gdGhlIGZpcnN0IHR3
byBhcmUgcmVhY2hhYmxlIGZyb20gYW4gdW50cnVzdGVkIGhvc3QuIEVMMg0KPiBjb3BpZXMgdmdp
Y19tb2RlbCBvdXQgb2YgdGhlIGhvc3QncyBzdHJ1Y3Qga3ZtIHdpdGhvdXQgdmFsaWRhdGluZyBp
dCwNCj4gYW5kIHRoZSBuVkhFIHdvcmxkIHN3aXRjaCBkaXNwYXRjaGVzIG9uIHRoYXQgZmllbGQg
d2l0aCBubyBjcHVjYXANCj4gZ3VhcmQsIHNvIGEgaG9zdCB3cml0aW5nIEtWTV9ERVZfVFlQRV9B
Uk1fVkdJQ19WNSBzdGVlcnMgRUwyIGludG8NCj4gSUNDX0lDU1JfRUwxIGFuZCB0aGUgSUNIX1BQ
SV8qIHJlZ2lzdGVycy4gU2VwYXJhdGVseSwNCj4gX192Z2ljX3Y1X3NhdmVfYXByDQo+IGFuZCBf
X3ZnaWNfdjVfcmVzdG9yZV92bWNyX2FwciBzaXQgaW4gdGhlIGh5cGVyY2FsbCBiYW5kIHRoZQ0K
PiBkZS1wcml2aWxlZ2VkIGhvc3QgbWF5IHN0aWxsIGNhbGwsIGFuZCBwS1ZNIG5ldmVyIHJlZ2lz
dGVycyBhIEdJQ3Y1DQo+IHZnaWMsIHNvIG5laXRoZXIgaGFzIGEgdmFsaWQgY2FsbGVyIGluIHBy
b3RlY3RlZCBtb2RlLiBXaXRob3V0DQo+IEZFQVRfR0NJRSB0aG9zZSByZWdpc3RlcnMgYXJlIFVO
REVGSU5FRCBhdCBFTDIsIHNvIGVpdGhlciBwYXRoIHBhbmljcw0KPiB0aGUgaHlwZXJ2aXNvci4g
Qm90aCBuZWVkIGEgY29tcHJvbWlzZWQgaG9zdCBrZXJuZWwgcmF0aGVyIHRoYW4gaG9zdA0KPiB1
c2Vyc3BhY2UsIHNvIHRoaXMgaXMgaGFyZGVuaW5nIGFuZCBub3QgYSBndWVzdC1yZWFjaGFibGUg
aG9sZS4NCj4gDQo+IEkgaGFkIHNhaWQgdGhlc2UgcGF0aHMgd2VyZSB1bnJlYWNoYWJsZSB1bmRl
ciBwS1ZNIGJlY2F1c2UNCj4gdmdpY192NV9wcm9iZSgpIHNraXBzIEdJQ3Y1IHJlZ2lzdHJhdGlv
biBpbiBwcm90ZWN0ZWQgbW9kZSBbMV0uIFRoYXQNCj4gd2FzDQo+IHdyb25nLiBUaGUgc2tpcCBp
cyBob3N0LXNpZGUgb25seSwgYW5kIGRvZXMgbm90IGNvbnN0cmFpbiB3aGF0IGENCj4gbWFsaWNp
b3VzIGhvc3QgY2FuIGNhbGwuDQoNClllYWgsIHRoaXMgaXMgcHJlY2lzZWx5IHdoYXQgSSdkIGdv
dHRlbiB3cm9uZyBpbiBteSBtZW50YWwgbW9kZWwuIEknbGwNCnRyeSBhbmQgYmVhciB0aGlzIGlu
IG1pbmQgZ29pbmcgZm9yd2FyZC4NCg0KPiANCj4gVGhlIHRoaXJkIG9uZSBpcyBub3QgcEtWTS4g
Y2FuX2FjY2Vzc192Z2ljX2Zyb21fa2VybmVsKCkgZXhjbHVkZXMNCj4gb25seQ0KPiB0aGUgR0lD
djMgc3lzdGVtIHJlZ2lzdGVyIGludGVyZmFjZSwgc28gb24gYSBuYXRpdmUgR0lDdjUgc3lzdGVt
DQo+IHdpdGhvdXQgRkVBVF9HQ0lFX0xFR0FDWSB0aGUga2VybmVsIHJlYWNoZXMgRUwyLW9ubHkg
cmVnaXN0ZXJzIGZyb20NCj4gRUwxDQo+IHVuZGVyIG5WSEUsIGFuZCB0aGUgd29ybGQgc3dpdGNo
IGRvZXMgdGhlIHNhbWUgd29yayBhdCBFTDIgYW55d2F5Lg0KPiANCj4gVGhlIGxhc3QgcGF0Y2gg
ZHJvcHMgdGhlIFZHSUN2MyByZWZlcmVuY2UgZnJvbSB0d28gblZIRSB3b3JsZCBzd2l0Y2gNCj4g
Y29tbWVudHMgdGhhdCBjb3ZlciBHSUN2NSB0b28uIE5vIGZ1bmN0aW9uYWwgY2hhbmdlLg0KPiAN
Cj4gVGVzdGVkIG9uIFFFTVUuIEkgYWxzbyBjaGVja2VkIHRoZSBmaXJzdCBvbmUgd2l0aCBhIGxv
Y2FsIGhvc3QgcGF0Y2gNCj4gdGhhdCBoYW5kcyBFTDIgYSBHSUN2NSBtb2RlbDogaXQgcGFuaWNz
IGF0IF9fdmdpY192NV9yZXN0b3JlX3N0YXRlDQo+IGJlZm9yZSB0aGUgc2VyaWVzIGFuZCBib290
cyBjbGVhbmx5IGFmdGVyLg0KPiANCj4gQmFzZWQgb24gTGludXggNy4yLXJjNiAoMDc1Yjc0ODQx
YmQwMCkuIEl0IGFsc28gYXBwbGllcyBjbGVhbmx5IHRvDQo+IGt2bWFybS9uZXh0IGFuZCBrdm1h
cm0vZml4ZXMuDQo+IA0KPiBJIHJlYWxseSBzaG91bGQgc3RvcCBsb29raW5nIGF0IHRoZSBHSUMs
IGJ1dCBJIHdvbid0IGJlIGFibGUgdG8NCj4gYW55dGltZQ0KPiBzb29uIEknbSBhZnJhaWQuLi4N
Cg0KWW91IGFuZCBtZSBib3RoIQ0KDQpUaGVzZSB0aHJlZSBsb29rIGdvb2QgdG8gbWU6DQoNCiAg
S1ZNOiBhcm02NDogUmVqZWN0IHRoZSBHSUN2NSBDUFUgaW50ZXJmYWNlIGh5cGVyY2FsbHMgdW5k
ZXIgcEtWTQ0KICBLVk06IGFybTY0OiB2Z2ljOiBEbyBub3QgYWNjZXNzIHRoZSBHSUN2NSBDUFUg
aW50ZXJmYWNlIGZyb20gRUwxDQogIEtWTTogYXJtNjQ6IEZpeCBzdGFsZSBWR0lDdjMgY29tbWVu
dHMgaW4gdGhlIG5WSEUgd29ybGQgc3dpdGNoDQoNCkhlbmNlLCBmb3IgdGhvc2UgdGhyZWU6DQpS
ZXZpZXdlZC1ieTogU2FzY2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCg0K
SSd2ZSBsZWZ0IGEgcXVlc3Rpb24gb24geW91ciBmaXJzdCBwYXRjaC4NCg0KVGhhbmtzLA0KU2Fz
Y2hhDQoNCj4gDQo+IENoZWVycywNCj4gL2Z1YWQNCj4gDQo+IFsxXQ0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9hbGwvQ0ElMkJFSGpUeUdVTG1WQ2d5b3lhM2JYRzRnUmowT1lGRTFnbkpMaE5F
Nmt2Q3JaRnRYeVFAbWFpbC5nbWFpbC5jb20vDQo+IA0KPiBGdWFkIFRhYmJhICg0KToNCj4gwqAg
S1ZNOiBhcm02NDogVmFsaWRhdGUgdGhlIGhvc3QtcHJvdmlkZWQgdmdpYyBtb2RlbCBpbiBwS1ZN
DQo+IMKgIEtWTTogYXJtNjQ6IFJlamVjdCB0aGUgR0lDdjUgQ1BVIGludGVyZmFjZSBoeXBlcmNh
bGxzIHVuZGVyIHBLVk0NCj4gwqAgS1ZNOiBhcm02NDogdmdpYzogRG8gbm90IGFjY2VzcyB0aGUg
R0lDdjUgQ1BVIGludGVyZmFjZSBmcm9tIEVMMQ0KPiDCoCBLVk06IGFybTY0OiBGaXggc3RhbGUg
VkdJQ3YzIGNvbW1lbnRzIGluIHRoZSBuVkhFIHdvcmxkIHN3aXRjaA0KPiANCj4gwqBhcmNoL2Fy
bTY0L2t2bS9oeXAvbnZoZS9oeXAtbWFpbi5jIHzCoCA2ICsrKysrKw0KPiDCoGFyY2gvYXJtNjQv
a3ZtL2h5cC9udmhlL3Brdm0uY8KgwqDCoMKgIHwgMTYgKysrKysrKysrKysrKystLQ0KPiDCoGFy
Y2gvYXJtNjQva3ZtL2h5cC9udmhlL3N3aXRjaC5jwqDCoCB8wqAgNCArKy0tDQo+IMKgYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLmPCoMKgwqDCoMKgwqDCoMKgIHwgMTIgKysrKysrKystLS0tDQo+
IMKgNCBmaWxlcyBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiAN
Cj4gDQo+IGJhc2UtY29tbWl0OiAwNzViNzQ4NDFiZDAwNjVhM2JkYTM0NDA4NzNjNzQ3OTM4ZTY5
YjY4DQoNCg==
