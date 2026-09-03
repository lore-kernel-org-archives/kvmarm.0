Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013035.outbound.protection.outlook.com [40.107.162.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F74B66F0;
	Thu,  3 Sep 2026 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788446099; cv=fail; b=XBShTZ4deGHUYcKRPtxzgR/Z0Lg7RyZlmAktnSCUeNhP8JUg5HMlrOTZxYm5XsIbrzy6k3WTrirx3zwoJgptwlL9Zjj8idXgRQClyIgDPCeaEb9Z2Qp3S4z0/FoBqR3EkwQa2XmvoK0+xtojWB4gvE9p/CodvGavffpV8FMXsCw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788446099; c=relaxed/simple;
	bh=0DS+K/M/PHzk4sBydblanGK2cHyAYoxU84CKlLlR/0Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PzH+LsT21N8E9w8A29XuL9GnrrR9UoWoJdZWfwAt2qQo5EcPYg2KygoIvsOer0ZBKKFf9sSaAwP5gfp733BBP5iHQvCmH2ewedQzLEnQ3tvvk1sa/fKpH/94oMaCtG0ZpDXvkmk9m9a9hB8ZWMkkAptf5CH8NtOoB+h3VlnlHEk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DcVt1BDW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DcVt1BDW; arc=fail smtp.client-ip=40.107.162.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DcVt1BDW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DcVt1BDW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eYE6DFyjba9mSxNzmHhpSHIGtxTIn7EBhHH7D+CH1JKHhinxAtbznFBe4aouQjv6itleM4DE/0gkJctr7Xj7g6ux4iRUDtdLacAhPX41mD4oxo6oAtvNYIz1ltd2NNt3QGcgGaGQUqxi45qrPbfXVrnqSe62bZjNTo8aNxdjszbIlSRToHS/kBt/vK0Jsdj9CioCbnFxcZPUl2WCX1W5Fcmwbq8+0OoSdBYMdcs3hoiIFwM+m+9+is2mFWFo0KFbtF2l4nBYxTfNitteYBe9A8ahFwLKSVicbLqakW7CzTL1JCJ+X3RWJrIrPDO/++vg4OS8MP2ONQ2x6AdNYYob5Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DS+K/M/PHzk4sBydblanGK2cHyAYoxU84CKlLlR/0Y=;
 b=JDirA21hMyRCeByusG3NEL1cCWP/r2aXhf++XzfI22tIalgD1iZZ4279YmsSnj+Ryrzs3E7H8ch3GEb5rAqHarM7GlYzPhArZfX+OFRzYj43tQRI07NqQ6K93/aEcFyQHH/hbTDsTjxOsi7Wtw9znJG3x0+HREQB8YSVlcu7oUct4URDQ37Aods9wfXZBVFewCN4aCUOIe+NhohxPSr+ShNw/VSj01/+86OwloJ4om6oYgG24x8ubCdwOCXhzn0kgz1ai+ErfHerksrJACfjmWgiY5kVQU4s+pZbMycqyPa9VfQO5Q+L0BzyTSvAfRHqACF9miwzIc+vGPNNGXQ2Dw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DS+K/M/PHzk4sBydblanGK2cHyAYoxU84CKlLlR/0Y=;
 b=DcVt1BDW6vtMBnW5C5t+dFd3+xhWS9HjliK+X46wVZ+c4KhlU1QGJ56DlcouWUj/Sy4lvjssFsrDsNVA1OGFf0KBHHDfDCNe8v0SwzEQZuvz4IVeVwSfhBFr25R8Cfytw7G0I9uvTAQ7wECHwZkDaqlrSnF036jsVDd16fL2Oic=
Received: from AM0PR02CA0167.eurprd02.prod.outlook.com (2603:10a6:20b:28d::34)
 by DB9PR08MB8484.eurprd08.prod.outlook.com (2603:10a6:10:3d4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:34:37 +0000
Received: from AMS1EPF0000008E.eurprd05.prod.outlook.com
 (2603:10a6:20b:28d:cafe::62) by AM0PR02CA0167.outlook.office365.com
 (2603:10a6:20b:28d::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Thu, 3
 Sep 2026 14:34:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000008E.mail.protection.outlook.com (10.167.242.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Thu, 3 Sep 2026 14:34:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWdWf/C4JkH8aYWWoWXRIuqJk06sFCMq1xULw+8teKrYtE+SteacNf0u7k7iiIfA95eIGbGGgSxFbsTKaR4JJHOJyRiGbL6xJxDF1V22BwHMO0RHm1cF3O4QSpV277Te7Q80fVlekhYFR5tCUO7PW6soHckc1ICfmCdet7FCyJJ9PKZE1gdKJhJ3rFNbjxVOd4CEafhiL7vJ7QPiu0JiW/aLEfDSt758hxoid/EKeYelhbfmWzGMm/SoMkK6H/9/uyJ7O7S0aKNbM7dGLmWSfcuiwYNaIBj+SEl3rVYgnwIRIV2d1LE9NVzuopibwuRpiTg5IB2Ecl1c7oSh5SsvMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DS+K/M/PHzk4sBydblanGK2cHyAYoxU84CKlLlR/0Y=;
 b=Ri1ANukUwMU611cs0GDmchbjUoVhJ+UPxhFejAc6CUXjpUpHj9wGm8H/Yt4EEhzx9Pg2uRdr9BbwECveacmkoQIoaUZY0bdGXdTCdX5ag9iBXZJrfCQ2i06xhr27HkmrPUkzL8JMsLE/A1UooN5Us1W5GyAdfEk40NbioPOL/I2/dShxKiCf790K7yTzeRd7otNhiTKFOCNZOI73xOT+x6ddlrWlGLfQp+t/FDiZgHNCeXyIKv6Y2aHi5sFpxrLY3TZWqkV7gX7VgMvsoVCKzilc7lTP5LXMCo4OaJ7cwNoj6wxi/FPtE9LubBxO2s0kkoyS/iwYz+d19A72RKagzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DS+K/M/PHzk4sBydblanGK2cHyAYoxU84CKlLlR/0Y=;
 b=DcVt1BDW6vtMBnW5C5t+dFd3+xhWS9HjliK+X46wVZ+c4KhlU1QGJ56DlcouWUj/Sy4lvjssFsrDsNVA1OGFf0KBHHDfDCNe8v0SwzEQZuvz4IVeVwSfhBFr25R8Cfytw7G0I9uvTAQ7wECHwZkDaqlrSnF036jsVDd16fL2Oic=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS8PR08MB10069.eurprd08.prod.outlook.com (2603:10a6:20b:636::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:34:03 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 14:34:03 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH v5 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHdJl3vkq+RMpA+RkGrCzQaxX6g2baSfXoAgCqYUoA=
Date: Thu, 3 Sep 2026 14:34:03 +0000
Message-ID: <f3d56620d713e6dfd6d832fa99a26b419dbe6fe9.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-5-sascha.bischoff@arm.com>
	 <20260807120559.38F7A1F000E9@smtp.kernel.org>
In-Reply-To: <20260807120559.38F7A1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS8PR08MB10069:EE_|AMS1EPF0000008E:EE_|DB9PR08MB8484:EE_
X-MS-Office365-Filtering-Correlation-Id: 0093a180-d93f-41e0-cee4-08df09c87b13
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|38070700021|4143699003|11063799006|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 nSTOHjIpRjiH5vv+EV8DGZs0mLTPiBxpMjbKplttdJnTwO5tPdEn9KWQ0MKJYvWnt2ryPBl5JZNq6SRDRGiZStvfYjE/A4QsRxvlUKdm19z/XuY6sZk4gt56nufjLFFesXsK4VNMAcJF/eBBonaBXWD5ZjaCYCHb9NYxh4Z46jwDLGp8sOpCFuUFFXTp1DzU1spara3h99DRHa8GbwTezKoNSEz4+6z3hva2VDXtDn5dBJwOKgXioKOYHye+Bwuflwub47iGe9FXmbhTkEYGqCOBunRiPEKvh35CrP8gYRihpKqRTpYybnZRKxMxNUAox7QzlS5u1D7EC2+q5e6te3rmKxxh4aN3aQgCm7S7BTyxtALt/Uu6kR5d4//7zVz4Pwo4/RnZH3buEiK4sGNJmtjRu4t+n0/ngfucnz21qh9y9xffMPUxCfCD+ITfxvicMxZhe8zlGEk/n5NOpN1we24UDjNV0KrkFZLb1TA5h3ZXtilfRuhlLSV7jIcHHOzUMICHCc4/b+n3LVUjKLbiVDa0zwXM1BSi6furC9FjgJ61Vjxf28/wx9HDSnf+GsYcXzP3BbXZ58BtBnx+8fGL+FvycTMSI7S4Gso2VnCOxNbsbcZYV2bFKhQ5DMkpjgJW4mEURJ2Y5Wr1GETWVHqDCvtea+ki/K5hahSRxtavPHv0vGykg81M7ImtfrMcWoAhQAM9Ok0rHEJsCmpV6A+H0ppmsEFImLrndyugf/t1aXg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(38070700021)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B859594372077488A53821E0CF1B430@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 w5AXsqZ4JN/tCqn2gg0jf7z9oxHpUC6zgZww2b8sf88yyTw86FrriPiWx2r8Jx+iBOJyZlm5Ife4ZjwKJaYjtUbumjNQBfXXYIUBWjB1mp0epzgij5sOcO0pxF7CmO9KsdD1HZxfOGtvLCbsfvY3JAP0HYElGS61BFBqvKjpEZWX6cvr1T0Bv6laSBJJ3UTr/w8mxyKtV+C1kWY81CFmOWu8Y+qNVF4XUnFaAKGKRyCJAioVQvBcXxDw3kyzLRx5whQ6Km2L3cT/W5gegMEW8K4N3wwMVgTZ2dtiur1s0S+LK33FtCtmHjPRa417zSouMTW2Ibu6sXwoTUC7Bm1fpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10069
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000008E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e6a470ba-bd77-4f0a-c92f-08df09c86700
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|376014|23010399003|36860700016|14060799003|22082099003|18002099003|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	wwY2W5/37i56zF8maysvq65rptYRtwFB8rdAzgAISQbGrTsYOnITObtkPKcqyc14rpnllifi8LuWH6rnrocW7jt2fV8f56P+OpXaYo2hJ/o/TeFfN4+VKG0oMl1devlpNAOkJJQhcIbCU1eJta6FLoRSVv+SGpFy14TKG5LSNLFjx84xH3Pnr7b4mH75Ml/2649EFlrofeVOEPlx0XesGTGTMOYJkeGcSewgvzRWiuJofvM+PldsJTMbu2K0q7IKn57g8zgg3rClVqTgbiWrrRmN7Cgvmpj8jKuG7397/E6KASkdEpmyZPkuRzBzUI74bO+SMKtPTESClemLwNB7KC+gReymBdrxphAiTVAOnNSvdm9buDGhd42ZmKD9u9Pb/C2QH8mCJJy3HDXT/eG9qv2Zpoxr1O1AACOAiRcI1HMV9O1bjc4dGDBVhesDSZccy956sq15SOOeaMLg9yvDZnspY91b6vIWh6ywA3qUdc+GFMTxM/j4A/H+KgdLdrvTdM+H5V8R9VtXmfajp4aAH4n+kmJ9FKFY4jJuiA7q1SGmHkGpC1jfc3HFlq83yMTlz/VeYa7HOApqrH7kVwLdvcUHt8vVykIrkTUstFH23Yy8rWrGhpyGb8rzbFJ8u4tSWYel7mCaYaDGkIlTehgjvwPjs8Uu7Uto58pq1aFOdWk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(376014)(23010399003)(36860700016)(14060799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GXv7XPVhbXgBf3tmr01gvC0Am+sUPtnBF0sR+HTlV3eLBDD1lNaIIkMXWuzDcA7BuCgRrL1VTQs3Z3O5k3s7NACTXQg+FMsQOzaCbx7OPb0BYRH+KLM17TxHyC4TGZigs+8NGUS4VJz72eAW3at1J+GSDuI7b0LJMF75mPXkm5uJ00ogzavKjtlRKx7/pyuR3L+6tO4QHBMft1S8S/S7zPpq9pBAhZXSEhgSIJP0dKcDWuDypVa5T393ekxoX+mBoNAC502PXPjp2p2u5XKzY6R7m3KM67kp0aH42k93ovz3/ODlHHhI0JKRj2odpvVzMYG6Bd1fVhkTqr+20FoCo3Lbaxmt0P2ARDfMR7f/J+2eGBHoo0Q/HKe1ayrSkvBr2p6Wxpxf7AazotUHKIRwnm2K4ZJS8bHlTG2CRTxj2hOPtlxvWAT7HZHyay3kiSwa
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 14:34:37.1910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0093a180-d93f-41e0-cee4-08df09c87b13
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8484

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDEyOjA1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gYEdJQ1Y1X0lSU19TRVRMUElSYCBpcyBpbmNvcnJlY3RseSBkZWZpbmVkIHdpdGggYW4gb2Zm
c2V0IG9mDQo+IGAweDAwMDBgLCB3aGljaCBhbGlhc2VzIHRoZSByZWFkLW9ubHkgYEdJQ1Y1X0lS
U19JRFIwYCByZWdpc3Rlci4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNF06IFtQQVRDSCB2NSAw
NC80OV0gS1ZNOiBhcm02NDogZ2ljLXY1OiBEZWZpbmUgcmVtYWluaW5nDQo+IElSUyBNTUlPIHJl
Z2lzdGVycyAtLS0NCj4gY29tbWl0IDRlNTM1MzY5MmIyNjc3NjRhYmVkOTZjODEyNGMzYWViYzE5
NGQ5Y2YNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29t
Pg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBEZWZpbmUgcmVtYWluaW5nIElSUyBNTUlPIHJl
Z2lzdGVycw0KPiANCj4gQ29tcGxldGUgdGhlIHNldCBvZiBkZWZpbmVkIElSUyBNTUlPIHJlZ2lz
dGVycyBpbiB0aGUgR0lDdjUgaGVhZGVyDQo+IGZpbGUuDQo+IFVwIHVudGlsIG5vdywgdGhlIHNl
dCBvZiBkZWZpbmVkIElSUyBNTUlPIHJlZ2lzdGVycyBoYXMgYmVlbiBkcml2ZW4NCj4gYnkNCj4g
Y29kZSByZXF1aXJlbWVudHMuIEhvd2V2ZXIsIGluIG9yZGVyIHRvIHByb3Blcmx5IGVtdWxhdGUg
dGhlIElSUyBNTUlPDQo+IGludGVyZmFjZSBpbiBLVk0sIHRoZSBmdWxsIHNldCBvZiBJUlMgTU1J
TyByZWdpc3RlcnMgbmVlZHMgdG8gYmUNCj4gYWRkZWQuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oDQo+ID4gYi9pbmNsdWRlL2xpbnV4L2ly
cWNoaXAvYXJtLWdpYy12NS5oDQo+ID4gaW5kZXggNjgxYzVjNTEyMDdkNi4uODNjZmNkMDU2YjI1
MCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2lycWNoaXAvYXJtLWdpYy12NS5oDQo+
ID4gKysrIGIvaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1naWMtdjUuaA0KPiA+IEBAIC02Miwy
MCArNjIsMzQgQEANCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gwqAvKg0KPiA+IMKgICogSVJTIHJl
Z2lzdGVycyBhbmQgdGFibGVzIHN0cnVjdHVyZXMNCj4gPiDCoCAqLw0KPiA+IMKgI2RlZmluZSBH
SUNWNV9JUlNfSURSMAkJCTB4MDAwMA0KPiA+IMKgI2RlZmluZSBHSUNWNV9JUlNfSURSMQkJCTB4
MDAwNA0KPiA+IMKgI2RlZmluZSBHSUNWNV9JUlNfSURSMgkJCTB4MDAwOA0KPiANCj4gWyAuLi4g
XQ0KPiANCj4gPiBAQCAtMTY2LDE1ICsyNTUsMTExIEBADQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+
IMKgI2RlZmluZSBHSUNWNV9JU1RMMUVfVkFMSUQJCUJJVF9VTEwoMCkNCj4gPiArI2RlZmluZSBH
SUNWNV9JUlNfSVNUTDFFX1NJWkUJCThVTA0KPiA+IMKgDQo+ID4gwqAjZGVmaW5lIEdJQ1Y1X0lT
VEwxRV9MMl9BRERSX01BU0sJR0VOTUFTS19VTEwoNTUsIDEyKQ0KPiA+IMKgDQo+ID4gKyNkZWZp
bmUgR0lDVjVfSVJTX1NFVExQSVIJCTB4MDAwMA0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBJ
cyBHSUNWNV9JUlNfU0VUTFBJUiBkZWZpbmVkIHdpdGggdGhlIGNvcnJlY3Qgb2Zmc2V0IGhlcmU/
DQoNClllcy4gSXQgaXMgYXQgb2Zmc2V0IDAgaW50byB0aGUgU0VUTFBJIGZyYW1lLCB3aGljaCBp
biBvdXINCmltcGxlbWVudGF0aW9uIGhhcHBlbnMgdG8gZm9sbG93IHRoZSBDT05GSUdfRlJBTUUu
IFRoZSBvZmZzZXQgaXMNCmNvcnJlY3QgZm9yIHRoZSBmcmFtZSB0aGUgcmVnaXN0ZXIgaXMgaW4u
DQoNCj4gDQo+IFRoaXMgYWxpYXNlcyB0aGUgcmVhZC1vbmx5IEdJQ1Y1X0lSU19JRFIwIHJlZ2lz
dGVyIGRlZmluZWQgZWFybGllciBhdA0KPiAweDAwMDAuDQoNCkV4Y2VwdCB0aGF0IHRoZSBvZmZz
ZXQgaXMgYXBwbGllZCB0byBhIGRpZmZlcmVudCBiYXNlIGFkZHJlc3MsIHNvIHRoaXMNCmlzIHBl
cmZlY3RseSBmaW5lLg0KDQo+IA0KPiBJZiBLVk0gaW1wbGVtZW50cyB0aGUgSVJTIE1NSU8gZW11
bGF0b3IgZXhwZWN0aW5nIGd1ZXN0IHdyaXRlcyB0byB0aGUNCj4gU0VUTFBJUg0KPiByZWdpc3Rl
ciBhdCBvZmZzZXQgMHgwMDAwLCB3aWxsIGd1ZXN0cyBhdHRlbXB0aW5nIHRvIHVzZSB0aGUgY29y
cmVjdA0KPiBhcmNoaXRlY3R1cmFsIG9mZnNldCBmb3IgU0VUTFBJUiBmYWlsPw0KDQpOby4NCg0K
PiANCj4gQ291bGQgd3JpdGVzIHRvIDB4MDAwMCBhbHNvIGludGVyZmVyZSB3aXRoIElEUjAgZW11
bGF0aW9uLA0KPiBwb3RlbnRpYWxseQ0KPiBicmVha2luZyBMUEkgZ2VuZXJhdGlvbiB2aWEgdGhl
IElSUyBpbiB2aXJ0dWFsIG1hY2hpbmVzPw0KPiANCj4gPiArI2RlZmluZSBHSUNWNV9JUlNfU0VU
TFBJUl9JRAkJR0VOTUFTSygyMywgMCkNCj4gPiArDQo+ID4gwqAvKg0KPiA+IMKgICogSVRTIHJl
Z2lzdGVycyBhbmQgdGFibGVzIHN0cnVjdHVyZXMNCj4gPiDCoCAqLw0KPiANCg0KVGhhbmtzLA0K
U2FzY2hhDQo=
