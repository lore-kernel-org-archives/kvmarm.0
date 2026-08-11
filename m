Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011048.outbound.protection.outlook.com [52.101.70.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D733A392C21
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786461158; cv=fail; b=Y8RzH87E46LjwOaliC55WkJFUTqB9UOqLzPv12uG0Y4qOVwcYrEciFTczZd3UXIQYyB1P09ktaW6mFJAIyqXFqvriljjW+7gPtZ11JTA9aLGL0Icz4cYdt6joTIrx5NCnGW9KWUhy6gjtyk+F5aYIDRYrGw8AyQs6JZ8kQiSyaw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786461158; c=relaxed/simple;
	bh=7qnLA5jwYRR4sOTTMTV6kH8dvnJR9u+vw1g786dZeMg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jxd1qi22pWwWzJ12Z0VV9OB13AEtxReVwc+Bhk2axQ3b3yyLAe5uO9khKqKbYAUoAbUVE3hHl4vm6my2lBAo+bn9M6fhS5ixMNL+1FdJeiEK+3wHC5IahckLFue+35bEeSEaHbUrcGWK3HbTF4swOTmdSe9nhdTYWgIP9jFT2VE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GnEjXE3X; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GnEjXE3X; arc=fail smtp.client-ip=52.101.70.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GnEjXE3X";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GnEjXE3X"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=a8+grZt3h1bHX87fqa74VRaSVb0iFjUUiWvmEbLgIYTDtZIeOJ0w/l8jQReUHae7YSiEGXixL+/C4fySppoQbd95cHxFIlD4P8JlXC05Hr/6xYpoRtSlmmP253BgrxlwAUywNfKMKOi8N1kxRbgekqIln3ybEtV3I2cYS7imrQcwX+WQ9YJHSx7KrMWlAs4sWsXEUEHOGmjLM17I6ZJ6oRdbv+Kg04xP2RZ9B6yWAim/axp5HPzYgVGV9K1budD39e9KlYXxNvW7hw/T43rW6GNIFBmafP5OuEjP8LIPOBf0sNCxqnCifcyahgYWcHoSPCP3e0N3+XZByDgoJb6rDg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qnLA5jwYRR4sOTTMTV6kH8dvnJR9u+vw1g786dZeMg=;
 b=P54WKnGBVqZ7AwD0Dui310N3hiJNhQmv6cbmHLgELrjHdWDAuTG4iD5qIvQ0LAUHA3ErSS2fQpmL2t5vonTrQlisQJE+slsO9U0oa71SkfrT0PfAjkPX4AaHeHXXZA4IG0YFLKG9seHAlmQIu56gbhhmNwSzDzgUB8ASS7xrt9Zii8SAounVuL4YWuXOMpu5zY2PH1QOy6rqvKPk22HZvn2N5EziGtFQWwtYzenQv3gl08IFSxL2CGCBbYzw4tdhTjs17+DVlE0vZRb31V2Qb1lTFrGMBFOy9vK26vXxXaOu1kwFnMNOjYkgyohrG6/7Fj/Ajyln5Xdi3owNrVcvIQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qnLA5jwYRR4sOTTMTV6kH8dvnJR9u+vw1g786dZeMg=;
 b=GnEjXE3X/cv8LHGXMTTHcTR2EE6Xdpo+Diegg7wOe++vWKlnvz6MX7KOpLk8Ma2jPmjGHbzcGlgXqlsIHR8liokKaRmuxTjldv3TvlURAxkFtZAm9iFAn8W3TBcsvn28pPs6ne5a6H90aLv+MUvGOT/F+3smeVIVAdWM0bzXXLQ=
Received: from AS4P190CA0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::13)
 by AS8PR08MB8300.eurprd08.prod.outlook.com (2603:10a6:20b:56e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 15:12:26 +0000
Received: from AM2PEPF0001C715.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::46) by AS4P190CA0026.outlook.office365.com
 (2603:10a6:20b:5d0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.12 via Frontend Transport; Tue,
 11 Aug 2026 15:12:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C715.mail.protection.outlook.com (10.167.16.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 15:12:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=saSb0anNs+V8d7jhL5Y06/vl9enLDtO/p6mmVjEA7BsKt/DF6TE7tBk//1fHCLx3aDdHfnW9W2ps6GEpJJhpAe17jwrSTE7hSuHyIVPtvMWLQ3/j3nUjq+KvP/q2GR6XYOR35d9vfwgUeosJB4HKXjgWN8vzqYlN1lZ1SVrhOck5sSLjYZJsUx+1tFFIpkH4dvJ5HxEUbGdPQrAN6eCJJiBTm5/haQhUxC2iIEs92JJrauLaf6cU678CqSGFYehpPuVZ6wS4aON6qWMCy7wQ0WKivhxqY9wKM3pHyRxlc7JTQEKD46Lxb0LBpT3ZbWoQYaDuxNcqKuGwBcnaswGLcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qnLA5jwYRR4sOTTMTV6kH8dvnJR9u+vw1g786dZeMg=;
 b=RC1I9B20f6h0eA9nRh6VCnRkosmLqx61CGVUHJ8uKQOVFcpOTIyni85YYxUZLNHmZo7RhUgrxBeHYMRGhMWgP7Dx65FgeFV4iq/66APbkbNjUmHhY0bSMjqv0+aqBj/vZd1CdDrBqKAXbOWLQ1LiKP09h1s7MrCtG5KmhAbLzQCRZeiv6q07I8JOOJwuozl/x/0ezIxbPpFc1CPaYMy8SvuJe6RPTnTi91M43oAhDsp0Bzfsuw8HZ5a25MKkBQpokpoU8OuIhUf3eWUDQtVplNc9NdK1U6Ujj3rSjMeq5UrGJd+TbTYGHF6qVlNicOrKaaZapxI+PuxbPKQNBPCEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qnLA5jwYRR4sOTTMTV6kH8dvnJR9u+vw1g786dZeMg=;
 b=GnEjXE3X/cv8LHGXMTTHcTR2EE6Xdpo+Diegg7wOe++vWKlnvz6MX7KOpLk8Ma2jPmjGHbzcGlgXqlsIHR8liokKaRmuxTjldv3TvlURAxkFtZAm9iFAn8W3TBcsvn28pPs6ne5a6H90aLv+MUvGOT/F+3smeVIVAdWM0bzXXLQ=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV1PR08MB8214.eurprd08.prod.outlook.com (2603:10a6:150:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 15:11:49 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 15:11:49 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH v2 4/4] KVM: arm64: Validate GICv5 timer PPIs before claiming
 ownership
Thread-Topic: [PATCH v2 4/4] KVM: arm64: Validate GICv5 timer PPIs before
 claiming ownership
Thread-Index: AQHdKaO766Ro5fxWskSEm2YT3tsa1g==
Date: Tue, 11 Aug 2026 15:11:48 +0000
Message-ID: <20260811150941.941295-5-sascha.bischoff@arm.com>
References: <20260811150941.941295-1-sascha.bischoff@arm.com>
In-Reply-To: <20260811150941.941295-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV1PR08MB8214:EE_|AM2PEPF0001C715:EE_|AS8PR08MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: d8d5048d-f047-4a39-0ae9-08def7baf3e0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|38070700021|6133799003|10067099003|56012099006|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 9Dzew63HtWx2/C0FRuFQw7sHlQ/y9jpdsX9FutxyfWyB8Cniu1XqEWwrhyPCFIIr+IctNDVyET3/rF0liyd4kZZ8oVCBC3iX5FwhI4WB0+rvNHj/8jA3gMttVgenOBQuUZOIn2KNDfmxnkLBcB3n4WXUdartCALv/aAM181PYZckoI6WGmcqZW1D2A/mXSaAe2Muqh+IpnbcZs2tBq2IDTjpArcbutbiN5WFfuHeMM5PHTzUOAF5ZYvYxAd2q7Uxk16YDpN2R9NMKlCmDMDoX29o1N3O13YPZ+6XtoQFhI2UhJt6xOwPR7LACvqRq2zTZTTQwbfYDKXx6MO9hpxV9FlnCoAO2+Nw/OgJS9r/DNIR/CPpEzSIXUOoXryLNjREWsNsC42k1mWOu7dJsPtVOfZ1vNIpQJl/0U9HKypIs84doqcIibdzbwlqN5rV7qTFUUHvgb2Hs3KzRdXyIQjYy1c5YAsYn7TAe7jSu3php/K6mQGzznDSZCOk0CMln3nhX1E7A0K66Dlb3QHbb854UtQ+4/5sZmGFoD4qTNAU0cTLTSPdzhTFtIOHjliKX8MVmO6TG4goCwbKeMQi/W07tTYZSTpu34G7RRc3apDkqYN7XiI7bvUG/38mqWlLWTzBWHzuYGhh6fAubRNLe7WYB0OQDLNAIUYohJ9BtisLclE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(38070700021)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gXAk0uQa+RRb8bj8HOAP50B6SlBueNXdV+HJmacPuAqP8tSxC3tVy+xwChRDSpA4PbO4oAzh4sNJCx2bmyPQXe6EWkcl35sKmKU8NoLQxYzXNwJzCrcPlEbIVUqozlZwGwHLC3UMqN49TooRaIeqnT5V2ownOnV8OqyPIImyLC0hzNsVZagEVboZTjpAbTELV7I63KHIcJcM2ygw6+FAI04nUmocGhUye77DQn2nL7ZxiQAeFO0vq60gJ303PyTSNngLcI1zwY7DEJCCsq6JQT4Q+oUVb3MfbiNImZw6iW9i31hSGgv+RbXfjJ5m7igtIwZcKJcp8nH5daPonlTbpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8214
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	73149fc4-15ec-407a-d49b-08def7baddd4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|35042699022|36860700016|14060799003|82310400026|1800799024|376014|11063799006|5023799004|56012099006|10067099003|6133799003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	UedeUvAXDQ3xqAEr/ifQ1ZW+AkIipFqowKIqtMfAV83yCEZOqllEpnMpeHPrY+yyN59rcuAP6NFgxMb0b9TZFG39+dmMM31kmfRDEViEa676UlpMaPusmE8y2RVmgF+LSms5Xb/DxiZt0EWtflAjD8mlALHO2tCA76iH9p2/o0iFlWoJFh8sJiBOcWqFF9qv9tYJAPt8lwLh05M7uRWtO62ruIqcePFVrUjDuqNF+htAEzaUAY4t+K0BGHX03R31DTdSm2sU/m1Lyu2RbxhFBBkz2lalxGHI9PZ4N3UZSNjAWKVNfsVI2h8ZXQNCw7nqrZhD9dV/83QRTBBPQmBrQXX6RPT2/5a0C9ZXLIwihrG8+ZGtxqmwdVvlMVXsyLvlPzviUMD6ojpRXdms++s1A2SFfNvct+4f0zxEGWiq0OIRPXppnvO9F3X2SIQsdkAmqTMZyXvDEklvfaaTxDNOZvYgMIIW5jR6FJSCyop8e7p8NcbvBAaChuW/CTSIo1APOUcjJsqAsHxs7gQuUPLMhYtALZFyfz81zlNLrS1Bikdwf6xJJc+iV+shQnMb6BgGAe4JkgBcN/QS8+qpUyOd8EjRsn410v0BsQj6VqSz1aikTqyC6Kg4flwIiusMF2XZn56Y0kbngl3WKAjlFWcvGQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(35042699022)(36860700016)(14060799003)(82310400026)(1800799024)(376014)(11063799006)(5023799004)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	98u7oSbwo3lzLIXF5aelbiA40qXzFnMijV0XUlA2kjM/FvgabbkO/LTrjaqREzQkWtkYIXc2VQf+Q9L0Ne2LHTvt1guiMcT7episSnLPrwGm8KC/amXWw07NYGwT9Zv9FeS8WbfWYJ5BT3NvG3N4okvEY5npOBwFlueGveigIwnYmH2tn3MNWqkprT9ozFK/DFbqS1OJkDeo/nxbl4w43dI3z9Brsqr945SlFFVNWte1zE87+JknLG7qWHj7xcavX9nZcDNsuJK3Hkcz7BjaIQ5y9ofJBMkNwHMpxhZs9fc1vCq8myLz26+x9IGpMPEbSSP3pC+8NGXcFLiXqfKvkPEddD6IHOgqPlpFEsUGpB96gfp0iieHjEnWQPOecRihhJk9hDuJa/pluvStvD0+1F3KYVPWMZ/ugxS/cU8wQFBrex8/ot+BQ8GYCYJgVMMb
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 15:12:25.9762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d5048d-f047-4a39-0ae9-08def7baf3e0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C715.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8300

V2l0aCBHSUN2NSwgdGltZXIgUFBJcyB1c2UgYXJjaGl0ZWN0dXJhbGx5IGRlZmluZWQgSURzLCBh
bmQgdGhlcmVmb3JlDQp3ZSByZXF1aXJlIHVzZXJzcGFjZSB0byB1c2UgdGhlIGFyY2hpdGVjdGVk
IElEcyB0b28uIFdlIHBlcmZvcm0gdGhpcw0KdmFsaWRhdGlvbiBpbiB0aW1lcl9pcnFzX2FyZV92
YWxpZCgpLCB3aGljaCB2YWxpZGF0ZXMgdGhlIGNvbmZpZ3VyZWQNClBQSSBhZnRlciBjbGFpbWlu
ZyBpdCB3aXRoIGt2bV92Z2ljX3NldF9vd25lcigpLiBUaGlzIGlzIG9idmlvdXNseSB0aGUNCndy
b25nIG9yZGVyLCBhbmQgY291bGQgYm90aCByZXN1bHQgaW4gYSBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2UgZm9yDQphbiBJRCA+PSA2NCBhbmQgaW4gYW4gaW5jb3JyZWN0IG93bmVyc2hpcCBjbGFp
bS4NCg0KU3dpdGNoIHRoZSBvcmRlciB0byBmaXJzdCB2YWxpZGF0ZSB0aGUgUFBJIGJlZm9yZSBz
ZXR0aW5nIHRoZQ0Kb3duZXIuIFRoaXMgYm90aCBwcmV2ZW50cyBhbiBpbnZhbGlkIEdJQ3Y1IHRp
bWVyIFBQSSBmcm9tIHJlYWNoaW5nIHRoZQ0KSVJRIGxvb2t1cCwgYW5kIGF2b2lkcyBjbGFpbWlu
ZyBhbiBJUlEgZm9yIGEgdGltZXIgY29uZmlndXJhdGlvbiB0aGF0DQp3aWxsIGJlIHJlamVjdGVk
Lg0KDQpGaXhlczogMDZjODViNThlMGIxICgiS1ZNOiBhcm02NDogTW92ZSBHSUN2NSB0aW1lciBQ
UEkgdmFsaWRhdGlvbiBpbnRvIHRpbWVyX2lycXNfYXJlX3ZhbGlkKCkiKQ0KTGluazogaHR0cHM6
Ly9zYXNoaWtvLmRldi8jL21lc3NhZ2UvMjAyNjA4MTAxMTE2MTQuRERDNzMxRjAwMEU5JTQwc210
cC5rZXJuZWwub3JnDQpTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNj
aG9mZkBhcm0uY29tPg0KLS0tDQogYXJjaC9hcm02NC9rdm0vYXJjaF90aW1lci5jIHwgNSArKyst
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMgYi9hcmNoL2FybTY0L2t2bS9h
cmNoX3RpbWVyLmMNCmluZGV4IDQxNTVmZTg5YjU4YTEuLmFmN2UyODk0Y2Q2OTAgMTAwNjQ0DQot
LS0gYS9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCisrKyBiL2FyY2gvYXJtNjQva3ZtL2Fy
Y2hfdGltZXIuYw0KQEAgLTE1MjksMTMgKzE1MjksMTQgQEAgc3RhdGljIGJvb2wgdGltZXJfaXJx
c19hcmVfdmFsaWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KIA0KIAkJY3R4ID0gdmNwdV9nZXRf
dGltZXIodmNwdSwgaSk7DQogCQlpcnEgPSB0aW1lcl9pcnEoY3R4KTsNCi0JCWlmIChrdm1fdmdp
Y19zZXRfb3duZXIodmNwdSwgaXJxLCBjdHgpKQ0KLQkJCWJyZWFrOw0KIA0KIAkJLyogV2l0aCBH
SUN2NSwgdGhlIGRlZmF1bHQgUFBJIGlzIHdoYXQgeW91IGdldCAtLSBub3RoaW5nIGVsc2UgKi8N
CiAJCWlmICh2Z2ljX2lzX3Y1KHZjcHUtPmt2bSkgJiYgaXJxICE9IGdldF92Z2ljX3BwaSh2Y3B1
LT5rdm0sIGRlZmF1bHRfcHBpW2ldKSkNCiAJCQlicmVhazsNCiANCisJCWlmIChrdm1fdmdpY19z
ZXRfb3duZXIodmNwdSwgaXJxLCBjdHgpKQ0KKwkJCWJyZWFrOw0KKw0KIAkJLyoNCiAJCSAqIFdl
IGtub3cgYnkgY29uc3RydWN0aW9uIHRoYXQgd2Ugb25seSBoYXZlIFBQSXMsIHNvIGFsbCB2YWx1
ZXMNCiAJCSAqIGFyZSBsZXNzIHRoYW4gMzIgZm9yIG5vbi1HSUN2NSBWR0lDcy4gT24gR0lDdjUs
IHRoZXkgYXJlDQotLSANCjIuMzQuMQ0K
