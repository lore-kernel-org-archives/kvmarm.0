Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013060.outbound.protection.outlook.com [52.101.72.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71E142A168;
	Fri, 31 Jul 2026 13:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503810; cv=fail; b=PeQ3F0IXNwWpR7NT9QDX1os5aMDsFJy3RSwrT1mIdURxN/W0cFf9mQrfe52Mp+T+3qAMcn4ToLDMwptxy0zITDATZWsbiZO1g0b7phVbW4aS1f7KiyUZWgWK2tYrl3cx8vuqQq4PneSzpnCho7egrM9ioBScb+rfbq8Ssk5hUeA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503810; c=relaxed/simple;
	bh=+DhtO8A9ygewpxPiChM84UzrpoS+iWkk2PcaUKHt4wY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FrPiNDwntscL4vnUYL5nKMnCmZ3zCnGSuutLsHD+UOwm7AoLjfSMjC+oIyJsJYtOyaTNUVKpjYwqfejpb3VwymqVqp/YqQ9Q7sf1K6Lg0Pe2oFtN2pzllp1z8aD+6LCCxPnf26UeZ5w62sQKc1QxwPAcx/qIoPhCm/jI+rlT3Ak=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UyGotaIz; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UyGotaIz; arc=fail smtp.client-ip=52.101.72.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UyGotaIz";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UyGotaIz"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=V6hfrXAjt2gBdt+ViIxGQbm+0nmD0T/CN6ZYpN55rFPPz4mTB1dABGvZEQpaMM8jwouwkD06acS8VcOFyLvGeABZdcCTXpQDgH6K6zqDwzZKMXsU0UdRzOx8SXO/xy8GtGjYdkOvfd350QcnD6c9/+qciA2+iuPV/9r+9Edf8dtQOIr7dmHD0GGRQM4rYfzwmAXLa28VxWjeYgVeroHKaqCU4gqWboY6xQbHxITAQQwz1hxf0cSEmHSBouh20tXV3cwMkRX+6GrTTjcFkLqqDLEp401PJp35H0ZOATyDACC16NAGJsoz/6r26spzWgwcazA7160CBYzwLwrsmedVyw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DhtO8A9ygewpxPiChM84UzrpoS+iWkk2PcaUKHt4wY=;
 b=SZIN9m2DMZGotxdfZwkk2fPpVEd+WuCM2jgQz3qRfq59rTBDGXw3QIcE66cPemtDGdjsWkwqlL7bvaZmglySUchEOfdRn7l+z8Z/YDU7iZxpaL7GJwjuuQvRhOSlbbzgYMkZR1//8kd4VzuL4K/eqDj3Lf9Z8j3or62ATcP4zx6c1GE8yg9N29djDyON0CwuHXSEaOp2yiP5m5Is+27zfnM2VvKmWT1oZg6KTNFcFDectB2PpcYLLMGQ3dQ3H43zX+jBIjmna2W/D4J+wpqR0Yi4MUr6MxD/aqX7SHof/nEyC0mrqpCZ9OQiWiRvDiMUILaceowOBZn3SkHzg3OvfA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DhtO8A9ygewpxPiChM84UzrpoS+iWkk2PcaUKHt4wY=;
 b=UyGotaIzRiNDYOdQU050yvPYP/heMsvPW2fEj4hAzfvBEnhvik5WEHQyuc2bWmAQm032U5E4jcDUvDXpfrLgbu5T/kUB4VQhV/RquW8H1tA1JOjnSFtKOlersJXA+lsXpPHCqppQf2+03Uur71eobcuGu+34MiT4ovFDwSb8hSs=
Received: from DUZPR01CA0092.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::27) by AS1PR08MB7658.eurprd08.prod.outlook.com
 (2603:10a6:20b:479::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Fri, 31 Jul
 2026 13:16:40 +0000
Received: from DB1PEPF000509E9.eurprd03.prod.outlook.com
 (2603:10a6:10:4bb:cafe::14) by DUZPR01CA0092.outlook.office365.com
 (2603:10a6:10:4bb::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 13:16:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E9.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 13:16:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JcYW/t99ne+yNvA/Jw90uXAiRcs0MVVsKgeAdNql2yUUA8ZP6NjlsFUkWqzZuGhWE4IAT9kC4/5ODBUr4LU93z6RUEbphWqlzquoYWLU8HOwGsbm82ZcKP0BRrL0m6DczQL1NXQfnhCoFUIKKsV/2M6zHTThuOnXT2pIK71am9hvCOA0AgLM18LugfBuj2KP6sYGhdj7QUpRYsUbj3URxe7v5oZWk9kElyzYBBIkF05GiJ4nrUWVGrtOjZdIE0FRJ5tpU8RH5y1K/HZoIzpuxZctC2fsEsHoD85M7/RP58/KmO6YQSS3xigklG0AgTrwttW+u4jC44JQwlDHyESZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DhtO8A9ygewpxPiChM84UzrpoS+iWkk2PcaUKHt4wY=;
 b=LEQfycXps6SdhFkoQvNL1yqmyIBxkSAFTPoGhcYuB3eu2GFNsDldJk4Ocx8Gjr8GsDAiE0U4rQXOrIbxSqigg5K6/IzGw0IQ3/kUyafpg+FPYgAfCZZOsDjI8wjNZOoy5O15dwkXa+uVT8Vjk58MS5nPVg/ZfF/gj4/azRmCxz1ABaArYzg3JfKjhiH4c4aEP8eWELHFU5qDj86qEqVS7WmCtcjH59Mhfw7RX2zQGGFGTbS8nGyT+Peo0LcISklXPPNMgrQhLnTiK7ZAUVBbQm3PKOjX62/XcGZ7IU+eDcUTGIREqhoeIkyYHKbSKJ3I3IZr3XH1UMxx7E+Cvz7FKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DhtO8A9ygewpxPiChM84UzrpoS+iWkk2PcaUKHt4wY=;
 b=UyGotaIzRiNDYOdQU050yvPYP/heMsvPW2fEj4hAzfvBEnhvik5WEHQyuc2bWmAQm032U5E4jcDUvDXpfrLgbu5T/kUB4VQhV/RquW8H1tA1JOjnSFtKOlersJXA+lsXpPHCqppQf2+03Uur71eobcuGu+34MiT4ovFDwSb8hSs=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10400.eurprd08.prod.outlook.com (2603:10a6:10:521::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:15:36 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:15:36 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 13/48] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH v4 13/48] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHdG1prTfwW7SxZLEyhzC0oDYFuRrZ8hpIAgAsgEYA=
Date: Fri, 31 Jul 2026 13:15:36 +0000
Message-ID: <27869aee57f4e17e5af830241f1190d4388b450b.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-14-sascha.bischoff@arm.com>
	 <20260724112159.4DE1A1F000E9@smtp.kernel.org>
In-Reply-To: <20260724112159.4DE1A1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10400:EE_|DB1PEPF000509E9:EE_|AS1PR08MB7658:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a9f387e-1b95-4150-272f-08deef05f54b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|38070700021|3023799007|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 htffpEkYyvcW7uLBjJ06KAgUtvgct/bjtdgcQ3N1FQnRMyZO286VYQfIXfu97c6KiNZ8aIF83315k29KxWMgruPj0gE7IJ6EvYnt+ZkfWa9JdwS7QXYtOLutZvwhndR3WOXpxFMJrVYQFCrB/807VBn+d8NotSAnyfL3H8iPp3uePl3MWpIVOTXibY9cOQ81P+1BQADW7R+e/DoVdIgLTooCLPq/AYc8TAszCl9BzeW8GQr9JD49iv9sMoFvk4C3KTBsmV23A4VGOb3rYpcWid5gtNkZppsdOdxbX/eL/Zd572rHG5YXkaPDikYjLkzjtrgw9ceNtdTDli8vAbLNS6vaFMxDfLahEJ4Cy1Nnl6j30+kSsxUfNivtYfnqvLGsK+VIKrZCBKmIbm5U1x08hnTvkOP/enA+rR5t8YjhZuaZ/4j+y1WhGelcMDmld2DFWQvWg8VMUfi2yU3fR+iWn0to7nmAHeK76x/CbbwiONjLF/4o7+aEWT57zL/OvcmvmBOoWK9dzRrcfAgVpAG+w3m3w7l91SMiro2nt0I/eOqfDcHOS6cOD9F5MYwz3h6pRLAQv0nqMaNHi5BSiZ39vzsdxwEduGwUPWPKx9EdMVFUW9OpWXbrn8CHU4bIoPUjEQUfrFb104KyjjA84eRFrvSCeVcphM5EQQkbTXnv8Ee487oXjJytGG6MVQDIS5ChfoKISuw0V6er3TI9AJy4lyvOwOVSCplY4ZK6067ZvM8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(38070700021)(3023799007)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E06443F04A4C7C4791759B5225D7654F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 garcDcto4djQwZMeEO99XFhwiw1YfsSWh8CtpL43d++9gTrqoIUKNLKDEZ4SdH89VlQ3rJFgLiJs9BUAx2A54OzUNx80lwljpRCMUpmj/qDq0zBW2N2M06O4bb3nCYPuJhHJXCI7aUeDCY/EHra4kLZAq4U65ktRK1iFm35spZA07LM83ALcRBqUjZ4f44bfdXc8RHujJJna/7RtuQEn5QWX9A/1pUC4wAacixgYyQNOTeKjqpNVQlPqpq6sSkdj9GIiEOTnWKun9lYsE0h3v1n0gWBBfXsPn1qEH//wHPxYNlyzKd6ocorR3qGVVTU3SteQG2VwY5IS1EkHQMXFRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10400
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b54db5e2-f93d-4104-45f1-08deef05cf5a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|36860700016|82310400026|376014|23010399003|18002099003|22082099003|3023799007|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	W4QfYyqv0gLMd5qYHgNJm7oVp6n9oVF9CKQQqVNaJ4L5SDUOC4aMppTGiKdOmOXWDoVL9iPVABo1MeiotB3Y0SV3XBWYYNhjUXV7dwLlCSo9THgIX5lMNq4hsfk7aTUZqft6Ak/ZjlFUmClk8uqaFrqtZqK5KDSIpL4hoRd93lvS2eOI5qQHFjxtSnHpv0AgP32JTk+Nj7JrrTrt6OUOQC6dQGggZiZ/RVerILEsLE5y6G/kG0ZFJpL3UKJB3YPWUZR8A4IqPRAYqIS4ReWZIMj3KWtUtIF2IfhD5JYYTDrsmYev0lBicPaOtVO3KvtZ7VI5/EOQT49U2QCVqIVuPKQn1911RUjjRKT6TSZaDWq/yO7eRsNVlw4ATjAI5Y1EWFTMpT3XM4onnEhL8IPXRcl1FmXJiltHxqIry0lebBNY64ikW2XZd35CwuHAAgmQBfEhGQwdjZyA4jIyJOdI+WdTYUxJoq5PJPWN5rfOXtRFtlorb+Y+y69GPIGb+Rr9giUZK7BewIIYkATeLNFOjs4tIWFMSOoIc2uKekIjv2HxjYioeRVVnHcOuy+FYquu8I4zQueRGOBx5xXhFqGX4wbY0Uvhr2wxkOa0KVSPK25k0TXwchyFpyPDM08NUjMG5HaFhNHGC/2X4QqWEFfcvuEdmmdH5uhY/l4piA8H1YyQ8j9YPeCCy8xhVZnVNaF66QBbKbLD79+K7SF8EZrZ4g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(36860700016)(82310400026)(376014)(23010399003)(18002099003)(22082099003)(3023799007)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vm8aME35QnMt2Z99s+N1dDscQ4CDf22GuY89L/2YAAuPLwIDmS4g7+iAwHKCpnxUJGCxNFzOpUbnpfWqNSUwYwFSk3q6OF+kX6XzG4TWoK/i0jeKzasXEg8obM5nh3/Q6HpXIj9H4p6gO8wvP+2OKmjQ39JBXdgfTD9SWjMJFLocW+MzZqdOjo0cgzOY/ncKf6RC660nvZlmdbX9yHA7wh+cXJ07Kg+xTEj8gdv6B9Ai0jSDw4ZoBRFHGVRhtSFEO/dfA/z+ILFu+Q0KS1FQWd2uXcXL2XaOZA/Ui40MGIao8n4w/W/Q7Q7wL6VlV3Olv0M9aBRHUOk51pR4qVvKf/LJEguqmCMMQM/tYgEIUAnN6znWsSYxReDGRZ1pqOjKM6T85Xn3HIBjof7Vx4mUdgRHRnixn7zcJS+yTFZCxpkGcxq2hf7JabaPG4NYGwaO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:16:40.1283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9f387e-1b95-4150-272f-08deef05f54b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7658

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjIxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gTWlzc2luZyBSRVFfREIgKFJlcXVlc3QgRG9vcmJlbGwpIGZsYWcgd2hlbiBjb25maWd1cmlu
ZyB0aGUNCj4gVlBFIGRvb3JiZWxsLCBjb250cmFkaWN0aW5nIHRoZSBleHBsaWNpdCBpbnRlbnQg
dG8gZm9yY2UgZG9vcmJlbGwNCj4gZ2VuZXJhdGlvbi4NCj4gLSBbSGlnaF0gTWlzc2luZyBWUEUg
ZW5naW5lIGlkbGUgY2hlY2sgYXQgdGhlIGJlZ2lubmluZyBvZg0KPiBgdmdpY192NV9pcnNfc2V0
X3VwX3ZwZWAsIHJpc2tpbmcgY29tbWFuZCBjb3JydXB0aW9uIGlmIHRoZSBlbmdpbmUgaXMNCj4g
YnVzeS4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMTNdOiBbUEFUQ0ggdjQgMTMvNDhdIEtWTTog
YXJtNjQ6IGdpYy12NTogSW1wbGVtZW50IFZQRQ0KPiBJUlMgTU1JTyBPcHMgLS0tDQo+IGNvbW1p
dCA5MjE4MjA4MjEwNWVmYzcyMDBmNTU0ZjhiNTM3MzJkODBlM2VhNzExDQo+IEF1dGhvcjogU2Fz
Y2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogYXJtNjQ6
IGdpYy12NTogSW1wbGVtZW50IFZQRSBJUlMgTU1JTyBPcHMNCj4gDQo+IFRoaXMgY29tbWl0IGlu
dHJvZHVjZXMgaW50ZXJmYWNlcyB0byB2YWxpZGF0ZSBhbmQgY29uZmlndXJlIFZQRXMgdmlhDQo+
IHRoZQ0KPiBob3N0J3MgSVJTLiBJdCBleHRlbmRzIHRoZSBleGlzdGluZyBkb29yYmVsbC1iYXNl
ZCBjb21tYW5kcyBieSBhZGRpbmcNCj4gVlBFX01BS0VfVkFMSUQuDQo+IA0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRleCAyMTI1MmJkMTFkOTZmLi44MjZjMjI4NGExNDUzIDEw
MDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysrIGIv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gQEAg
LTMzMywxMCArMzQ1LDczIEBAIHN0YXRpYyBpbnQgdmdpY192NV9pcnNfc2V0X3Zpc3RfaW52YWxp
ZCh1MTYNCj4gPiB2bV9pZCwgYm9vbCBzcGlfaXN0KQ0KPiA+IMKgCXJldHVybiBfX3ZnaWNfdjVf
aXJzX3VwZGF0ZV92aXN0X3ZhbGlkaXR5KHZtX2lkLCBzcGlfaXN0LA0KPiA+IHRydWUpOw0KPiA+
IMKgfQ0KPiA+IMKgDQo+ID4gK3N0YXRpYyBpbnQgdmdpY192NV9pcnNfc2V0X3VwX3ZwZSh1MTYg
dm1faWQsIHUxNiB2cGVfaWQsDQo+ID4gKwkJCQnCoCBpcnFfaHdfbnVtYmVyX3QgZGJfaHdpcnEp
DQo+ID4gK3sNCj4gPiArCXU2NCB2bWFwX3ZwZXIsIGRiciwgc2VscjsNCj4gPiArCXUzMiBzdGF0
dXNyLCBjcjA7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCWd1YXJkKHJhd19zcGlubG9j
a19pcnFzYXZlKSgmZ2xvYmFsX2lyc19sb2NrKTsNCj4gPiArDQo+ID4gKwkvKiBNYWtlIHN1cmUg
dGhhdCB3ZSBhcmUgaWRsZSB0byBiZWdpbiB3aXRoICovDQo+ID4gKwlyZXQgPSB2Z2ljX3Y1X2ly
c193YWl0X2Zvcl92bV9vcCgpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0K
PiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBEb2VzIHRoaXMgY29kZSBhbHNvIG5lZWQgdG8gdmVy
aWZ5IHRoYXQgdGhlIFZQRSBlbmdpbmUgaXMgaWRsZT8NCg0KTm8uIElmIGl0IGlzIGJ1c3kgd2hl
biB3ZSBnZXQgaGVyZSB0aGFuIHRoaW5ncyBoYXZlIGFscmVhZHkgZ29uZSB3cm9uZw0KZWxzZXdo
ZXJlLiBXZSdsbCB0cnkgYW5kIGRvIHNvbWV0aGluZywgYW5kIGxpa2VseSB3aWxsIHJlbWFpbiBi
dXN5DQp1bnRpbCB3ZSB0aW1lIG91dCBhbmQgcmV0dXJuIGFuIGVycm9yLiBBZ2Fpbi4NCg0KPiAN
Cj4gSWYgYSBwcmV2aW91cyBvcGVyYXRpb24gdGltZWQgb3V0IGFuZCByZXR1cm5lZCBhbiBlcnJv
ciwgdGhlIGZ1bmN0aW9uDQo+IGNvdWxkIGV4aXQgZWFybHkgYW5kIGxlYXZlIHRoZSBoYXJkd2Fy
ZSBlbmdpbmUgYnVzeS4gV2hlbiBjYWxsZWQNCj4gYWdhaW4NCj4gZm9yIHRoZSBuZXh0IFZQRSwg
dGhlIFZNIGVuZ2luZSBjaGVjayBhYm92ZSB3b3VsZCBwYXNzLCBidXQgd3JpdGluZw0KPiB0bw0K
PiBHSUNWNV9JUlNfVlBFX1NFTFIgYmVsb3cgY291bGQgY29ycnVwdCB0aGUgY29tbWFuZCBpZiB0
aGUgVlBFIGVuZ2luZQ0KPiBpcw0KPiBzdGlsbCBidXN5Lg0KDQpJZiBhIHByZXZpb3VzIG9wZXJh
dGlvbiB0aW1lZCBvdXQsIHRoZW4gdGhhdCdzIGxpa2VseSBhIGhhcmR3YXJlIGJ1Zw0KdGhhdCBj
YXVzZWQgaXQuIFRoaW5ncyB3b3VsZCBhbHJlYWR5IGJlIHJhdGhlciBicm9rZW4uDQoNCj4gDQo+
ID4gKw0KPiA+ICsJLyogTWFyayB0aGUgVlBFIGFzIHZhbGlkICovDQo+ID4gKwl2bWFwX3ZwZXIg
PSBGSUVMRF9QUkVQKEdJQ1Y1X0lSU19WTUFQX1ZQRVJfVlBFX0lELCB2cGVfaWQpDQo+ID4gfA0K
PiA+ICsJCcKgwqDCoCBGSUVMRF9QUkVQKEdJQ1Y1X0lSU19WTUFQX1ZQRVJfVk1fSUQsIHZtX2lk
KSB8DQo+ID4gKwkJwqDCoMKgIEdJQ1Y1X0lSU19WTUFQX1ZQRVJfTTsNCj4gPiArCWlyc193cml0
ZXFfcmVsYXhlZCh2bWFwX3ZwZXIsIEdJQ1Y1X0lSU19WTUFQX1ZQRVIpOw0KPiANCj4gWyAuLi4g
XQ0KPiANCj4gPiArCS8qDQo+ID4gKwkgKiBUaGUgVlBFIGhhcyBub3QgeWV0IHJ1bi4gVGhlcmVm
b3JlLCBtYWtlIHN1cmUgdGhhdCBhbGwNCj4gPiBpbnRlcnJ1cHRzDQo+ID4gKwkgKiB3aWxsIGdl
bmVyYXRlIGEgZG9vcmJlbGwuDQo+ID4gKwkgKi8NCj4gPiArCWRiciA9IEZJRUxEX1BSRVAoR0lD
VjVfSVJTX1ZQRV9EQlJfSU5USUQsIGRiX2h3aXJxKSB8DQo+ID4gKwnCoMKgwqDCoMKgIEdJQ1Y1
X0lSU19WUEVfREJSX0RCVjsNCj4gPiArCWlyc193cml0ZXFfcmVsYXhlZChkYnIsIEdJQ1Y1X0lS
U19WUEVfREJSKTsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gSXMgdGhlIEdJQ1Y1X0lSU19W
UEVfREJSX1JFUV9EQiBmbGFnIG1pc3NpbmcgaGVyZT8NCj4gDQo+IFRoZSBjb21tZW50IGV4cGxp
Y2l0bHkgc3RhdGVzIHRoZSBpbnRlbnQgaXMgdG8gZW5zdXJlIGFsbCBpbnRlcnJ1cHRzDQo+IHdp
bGwNCj4gZ2VuZXJhdGUgYSBkb29yYmVsbC4gV2l0aG91dCB0aGUgcmVxdWVzdCBkb29yYmVsbCBm
bGFnLCBjb3VsZCB0aGUgR0lDDQo+IGhhcmR3YXJlDQo+IGZhaWwgdG8gZ2VuZXJhdGUgZG9vcmJl
bGxzIGZvciBpbnRlcnJ1cHRzIHRoYXQgYmVjb21lIHBlbmRpbmcgYmVmb3JlDQo+IHRoZSBWUEUN
Cj4gZmlyc3QgcnVucz8NCj4gDQoNCk5vLiBUaGUgcmVxdWVzdCBkb29yYmVsbCBmbGFnIGlzIHRo
ZXJlIHRvIHJlcXVlc3QgYSBkb29yYmVsbCwgTk9UIHRvDQpjb25maWd1cmUgaXQuIEluIG5vcm1h
bCBvcGVyYXRpb24sIGRvb3JiZWxscyBhcmUgcmVxdWVzdGVkIHZpYSB0aGUNCklDSF9DT05URVhU
Ul9FTDIgd2hlbiBtYWtpbmcgYSBWUEUgbm9uLXJlc2lkZW50IChhbmQgd2hlbiBzYWlkIFZQRSBp
cw0KZW50ZXJpbmcgV0ZJKS4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCg==
