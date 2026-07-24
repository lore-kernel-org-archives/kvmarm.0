Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011037.outbound.protection.outlook.com [52.101.65.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE3941DDE3
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890285; cv=fail; b=saTxENnAu9We0Z8EaYk3YVmputrwf39WozWqARlyBzrcjBYsvSau1bt9wPYV7CpzzzqBl2F42qM0C8tGZcvuN0Mhh9a0iPFzH8xspugGyuy0648RrQdiMC8oCT+08WOrBr+lPY/EfyvrK+45XEOwSWjIK3XNdqU2kOLNUVQRXYE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890285; c=relaxed/simple;
	bh=vCXt/QjckaFJL+Z8JbjwkwgdZE82FVT1hVZjUa1McQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S/atK/Sluqfi6ATfZ1xZiVt5Dv47houvdD8dVkGChLRQYVt3DXxpBhqEfAc4w4tNis6hxlQzzzfv8743BMyt9Drzvgf6gnpo48R2MeKazn6hAlBHNMz1RwZFDhloBxVk+QygLrOqtXtj75Y8+25bcZKx8QxcgeMzmhu/tfLsg1Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kE82CgwD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kE82CgwD; arc=fail smtp.client-ip=52.101.65.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kE82CgwD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kE82CgwD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qia/8toMotyAcZYd3YybcWWvAIIawinJewKDQgiafCINOyRQjDsXMh+o7fVJqV81FefGIZUjW+rHxz2L7CSj2JFhWkBFaPMsk4KHR3Ihnw9yIVmk7t1bOYHB9UNwbeZVnuH05BFM2dxEhtI3GbOoPA745LvQkeVj5hnDplhGBz+OhokOr3KthsRTADhY1o6eOSN1FtZI5A5yV3hERN99PQHocreU6OssaIvLez0OdEF63tWBSN6SWFmcMtgf64CuK1t6hE6Y3xzNNgD0PFm5XGTbVSLTO7pkbuBVRA1quBzCoXR3BiA9A1zVVQJSkqYO1wDYuIbpPMXdIJF2WvELGQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=tT/C4i+SQgAHbPWyZ4yNQF2TGyv8niw98bgeTtO0Gdnw2mDssQwYh2BSKMD/PrYfdvSqQveR+a9KiAWZu3Y41WQMnTLIg0a0YhPRtDPnipTmFbYGJuWFxc/eFisBxGFtes0cuY3uiIL4Zdyp/YMpQxJhB6Gxpns2DR8d6+YsDb7Fk9IakFYVYDKbBEQTOaYzop/azaTwPa4x7JS5n7RDNc+sBNW68lgjYtRU8UO1QHNGz4PaAn5jvLpJ/SYuRUh06iJOnwm/nUa2U5sPTz2lBictRJNt+oSykqYmArwHjXRj8oLv2SZUoR6D2Dsu3dOTg+MqL9Xeae/UG5Yw5S6OSw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=kE82CgwDxpWm6JQPmzYbtPW2vbHWSlHcDmOOtFO1vogyZ4bI4uA3p5FAGTNTLfmWEZmqDBerjAK67D1hs9Du40RHfoLPP8wsNggppJrK1KvrfBb+U9RQuwgiwiH92+AxnR+dJpkvD6bN4gUjEJ1klsXp3TBY576+nDAXOKkmjvc=
Received: from AS4P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::10)
 by GV1PR08MB11179.eurprd08.prod.outlook.com (2603:10a6:150:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:51:16 +0000
Received: from AM3PEPF0000A78E.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::88) by AS4P192CA0026.outlook.office365.com
 (2603:10a6:20b:5e1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78E.mail.protection.outlook.com (10.167.16.117) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:51:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KRWzuWaDVuLydzbFcf5RxWqLRKIaMHAjbxDxbIDVzOgsHB0yugbD/rQZuVbaFarxzdV0GDzDOseObH3WVn4UaQ+uSXqT9ZFlBGni4q8CqtPcrIn+kMtmXcJJPKaP1tI9v7NmwCv+SEY9O+pP8MSKnqK0+BEnfuiIsyQQYNlBSsQIkJMund3qHM2la8WU9NUrKCDnoI0W6y0XDLJESreLG2TV1weRHHCjvtqq9+WbX6bpxJcaCI08XBmApAkcgfuGHgKR/kZmtoQS9JnuiggkunraGU1a015mpA61WomDKOyzzyYZ+qWprU4PZuVUBXgbg8QFGHTrV3C2MLa2oDidqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=KYU3ez7tv4sOjKd+9L6ENqU9n/cU5o4q1RhfytFb53GeGqMH/bI4gG9VXNuFdmGfF6lGcfeq2OqVhBebjwtLA3Bd+2ojJ4IIVCD8q/aEZM534NoPhqi3U2+NPk89MR9PavHMYDeeKK6w4/9Zdb5/gI+HGIFYpsKPmCaWTVqMZhGslWQZuBCwuXTTYvVjG2s9FGhB/24q38cHR7J18vspahaJIG0b9ZISxAGRv55j+Z1f1ub8p1w7QucY6W46qmyi1mmjaIfUXSiIsYd4zq9dKHxX6qWG3+A//rdPG+vbKL8v9WEB9+cPuTIWoI/zdw6GA3YEXFDEaABPi6Abo7NCuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=kE82CgwDxpWm6JQPmzYbtPW2vbHWSlHcDmOOtFO1vogyZ4bI4uA3p5FAGTNTLfmWEZmqDBerjAK67D1hs9Du40RHfoLPP8wsNggppJrK1KvrfBb+U9RQuwgiwiH92+AxnR+dJpkvD6bN4gUjEJ1klsXp3TBY576+nDAXOKkmjvc=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:50:13 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:50:13 +0000
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
Subject: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps from IRS
 config frame
Thread-Topic: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Thread-Index: AQHdG1o0qOow5djU00KduraRpDffMw==
Date: Fri, 24 Jul 2026 10:50:13 +0000
Message-ID: <20260724104819.1296803-8-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|AM3PEPF0000A78E:EE_|GV1PR08MB11179:EE_
X-MS-Office365-Filtering-Correlation-Id: b5a87c7a-e894-4c78-d830-08dee9717c27
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 fSzfC+B3KwixI3mVBE/3vB6VwSza8G2qIJ3EjGNP810Ztx3ZQlASNt2eW45vIsUyZgkf8lqqbOxFS4kxBRmL4maOaiBYg/UOZOtSbfsdVLa6+GZzJcLIZzV1FNET9j7Lcp7UbrBGhzsZQeP4qPmuP3WS16BvxiEadH1n1TbeF8aXnjOVMvT+a5xY6LEUIzFi3dmo/ZLtLBtBIpa96sgK9JM/dY7uf0/stJ0JJBG9QeXlnpCA1e3YHrDUP7UBySFYMo/NVtgfnOvfpCIhbhi79QSLNbXmLw0X7eAEJi3EhrXFRf69XcNRKhqghigee8rxDUfXPWJkmOaBTSvhthWjZIBva4s6OoEJp2Zvc8WOy6+EWIE6c2m8eO6uzLgUcCoA6iejR7cb9OMVH9XVo7bxW/5bpsCrHoER2pIlwSwVMYmtS35S7ignzsximuPzRNqNIIhFaaxMUM0Z/YWHpJn3KaQF1NpSGjycNfari6KkJQSf1lQ0CGMSMtJ454uBgYkwrGCW4ybLO7TO3aJbbo8zcPCpYtNKL5ugE4ZxlYMMsmcWEitdG2ewv6l1qP1G8pZcaazJotVwEsjdpQeDWsaUVaNvsinKgIam8UdfcRWPJ6uCxie8HPzU7ZBWzD0XtkQju0r3o8MfLGMIqrpv+KgFhG8rACc8MZYhKC3elHEuFU1nbHiYa/hYc8ujQw66NwYZB/xGixari3kYhhw1TX58bm0j/Kk9o+ioXiGWfPVuldE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Tcgyb7IDkee/j+DD+2JI78OD2VODj4PaFrFzLiZHHNmOu/b+29I6IC+Cbo1tWwUlw2z3Ki0yU6wJjLOC/yI4W29hlIhbjxgi08/o6NEdOnmwAf7nl6sViQQHbcl+5VXZw26/UOj2/OADq04PesdhtnPBUFfBJ/R5g+XVP2bmOmSlgK1IX2nY3FTl73hUMrQTEsx3v3ieWYHO6kLK87TXsFsDccCKEBfc5OJ0YLIRGy/v8Dbvif14vJTLuubR6BWTUrCGgxz6tqLbJVJyZ3V8c6zdcCfVahENfQS+PAUNhho4snJ2lf4Wp66WohXqLSWvM+KZIYNpuCNtCojGKUo/AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	33855b17-381f-4cd4-33a7-08dee97156ed
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700016|82310400026|35042699022|23010399003|1800799024|6133799003|11063799006|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Jb1c+Jfyh+gGeDoIDliBzNoshE2QC0Afwm5tVjdQzPAxeRnpu8GAH89ftXwdqK+dXDxXJITNROSm9jtS3zGaPXc79xWXjwgviycQoPN4EbpO6/w0qbvsPEBNir5hbdQUaLqAxDYjNjaAj95Qci5zSInfYJuNrkw0mOxkZf25akE/pbR+v8gyK3HQ2QIX4oudWPBxSlaoPKevT6z7M8joHaRLe6mde8cI5TAgeO3ql2S+fVuhjErAgjVdvXmxu2xhK4LyRN47ILkrHN1sph0ewX/wasWBtn4rQS1P4QdQgpcnvOg+u4u0a1fI5QiXWGpUhsEuqiy4D6C1BM2kF5igfOYBGSJyzmfutcyh79qrI1cAusfxM0TV6YmFNAXl3hMkc8RcfebRjXsKWRVmioWuMRtmcndaQAWTxJhFCs5bZTRRJwBcpYLDQlz0YYrDR/S8Je0cye4KlNmGNXpO2tHec6rjs9CWNUmTFpkFwGCYK5Rr6pbPe9nXVU3HdcC9yBP5UxuP5bBtPK78/QC2C8vkDr4TtB2rHZ/wy3hsoVshvgL/nSHw/m9YNW0sIDgneHdsEDZss2AGA2SRVD9Q1SsrlriSkQdJby5LvsOlZFQtQahQYs8TLbmdQOlz9/FfUP0dp6Kv1xImFeGpkFFXzUZJfRfXYihwSFSqdSNuUIuEgTcs71BRZHGda8tPYjIrPeO293C9tIxqYIualB8uRTFMCw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700016)(82310400026)(35042699022)(23010399003)(1800799024)(6133799003)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i3s/DBsjq2BVTvTB5kTUDyMl+AwrGDLPVTVC35Tg4M4tHlwwJTZVDMlfjQpy0sCtwuIC9SdLh+Us8CcMqDBFQ8mFs0C5vlt8lGEAF5RuIDMXbK9paguhu3p/J7eai1OpvlOTaSVhZCeHcg/NbAUAvcjEhZx2hjUTU90CgwvzVP9eBVFpflfBXC6MBu6g4GcCEQc0qLwH3Bbo3f3MhZoWjP3vFPr5ry+2Ezd/iaMzg5dftPc7qdNNDqauZWuxikqAlZVBsMu2EoE0L+DcrAera7yUhH3IIF4lNlTm0f8Icexhx4xBtMSvaeGuOH/rR5v0otSEixE8qM7qH0+IWqlcq62yiJOz/XemkABULYGZcq98uCy7OoruVNhrAqgSb43c9aZG4hZ6e41uxqP3kKxZrARUgCnBHu77EN0UW6CTmiIclB+y1N6nwywYXFx8pcni
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:51:15.5865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a87c7a-e894-4c78-d830-08dee9717c27
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11179

The host irqchip driver provides KVM with a pointer to an IRS's config
frame, which allows KVM to directly interact with the host's IRS. The
MMIO registers in the config frame are used to configure VMs (in
addition to them being used by the host). The IRS's config frame also
includes a set of ID registers which describe the capabilities that
the IRS has.

Stash the pointer to the config frame, and extract the VM capabilities
(from IRS_IDR3 & IRS_IDR4), as well as the IST
capabilities/requirements (IRS_IDR2) from the IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 46 +++++++++++++++++++++++++++++++++--
 include/kvm/arm_vgic.h        | 26 ++++++++++++++++++++
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d4789ff3e7402..3f7b132110114 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -11,6 +11,7 @@
 #include "vgic.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
@@ -34,6 +35,45 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+static u32 irs_readl_relaxed(const u32 reg_offset)
+{
+	return readl_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void vgic_v5_irs_extract_vm_caps(const struct gic_kvm_info *info)
+{
+	u64 idr;
+
+	irs_caps.irs_base =3D info->gicv5_irs.base;
+	irs_caps.non_coherent =3D info->gicv5_irs.non_coherent;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR2);
+
+	/* We skip the LPI field as it only applies to physical LPIs */
+	irs_caps.ist_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, idr);
+	irs_caps.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, id=
r);
+	irs_caps.ist_levels =3D (idr & GICV5_IRS_IDR2_IST_LEVELS);
+	irs_caps.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr);
+	irs_caps.istmd =3D (idr & GICV5_IRS_IDR2_ISTMD);
+	irs_caps.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, idr);
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR3);
+
+	irs_caps.max_vms =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VM_ID_BITS, idr));
+	irs_caps.two_level_vmt_support =3D (idr & GICV5_IRS_IDR3_VMT_LEVELS);
+
+	if (idr & GICV5_IRS_IDR3_VMD)
+		irs_caps.vmd_size =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, idr));
+	else
+		irs_caps.vmd_size =3D 0;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR4);
+
+	irs_caps.vped_size =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, idr));
+	/* Field stores VPE_ID_BITS - 1 */
+	irs_caps.max_vpes =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, idr) + 1)=
;
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  */
@@ -61,10 +101,12 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
-
+	vgic_v5_irs_extract_vm_caps(info);
 	vgic_v5_get_implemented_ppis();
=20
+	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
+						  VGIC_V5_MAX_CPUS);
+
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fe49fb56dc3c9..8d65a18fefb80 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -182,6 +182,32 @@ struct vgic_global {
 	struct {
 		DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
 	} vgic_v5_ppi_caps;
+
+	/* GICv5 IRS capabilities */
+	struct {
+		/* Base address of the host IRS's CONFIG_FRAME */
+		void __iomem	*irs_base;
+
+		/* IST Caps */
+		u8		ist_id_bits;
+		bool		ist_levels;
+		u8		ist_l2sz;
+		bool		istmd;
+		u8		istmd_sz;
+
+		/* LPI only */
+		u8		min_lpi_id_bits;
+
+		/* VM Table, VPE Table */
+		bool		two_level_vmt_support;
+		u32		max_vms;
+		u32		max_vpes;
+		u16		vmd_size;
+		u16		vped_size;
+
+		/* Is the IRS coherent with us, or not? */
+		bool		non_coherent;
+	} vgic_v5_irs_caps;
 };
=20
 extern struct vgic_global kvm_vgic_global_state;
--=20
2.34.1
