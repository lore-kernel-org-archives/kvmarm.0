Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010012.outbound.protection.outlook.com [52.101.84.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ABD3B2FF7;
	Wed, 15 Jul 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132981; cv=fail; b=ue1JdqaHI2taR6xvWvLTmNIeP3yu7+f5DRwrMxI1bnagz8Ye8sPNWs+Rsaj7c2ELPWoLMGZvsp1MHDlHzxEohXFy/TBfiiMsOJmmAppLo/pfruSCKMpuwwY1oSnu8TDxaJSy1KOC/lSfsfAhencqmQA1MfVdWBOUwpvDbGyfrfQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132981; c=relaxed/simple;
	bh=LDP8mB5Zpugn7FgTe+ERUQPRoXiLz+wamSEyrNC67L0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DvBEhLuZvyS8cbUKWyjXE1814YI1f3Xz3JCYD5NDPYHTsrAv/vw1sYU2m+vrWTpE8+x7635AWy3C3A5SyN40h7nxoceAwxxwbcZ6cir9EH6tSfMCQjkYy7wMaBsUhyK+jRkIrsVtvfcXhzX5+rQPYs78q84NoM5q5ywzhqoBjB8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fKpBjQX+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fKpBjQX+; arc=fail smtp.client-ip=52.101.84.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fKpBjQX+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fKpBjQX+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VnYZidNjakWa2Q8XYtP/Yi++sQzFmTn9CgSlvctynLgzeo8B5tvyiZs5p+tcxgIOS+n31QDBTKd5Pmbf3x29TVg0A09ADhkqFWh6M1SWENm017G4XnvnZA8GszWOdhwE3tNJCRSSQkST38KBAcKf/IWgw2zacMJb9gCBNVxtpN9fXbG0IHNvyd9l8kE0q/hASi5yGM6O0cMi9GzX7XDKWbjBnu9nMUfb7WBKlH28G0DXjNRt6Ysi0g41HuaAtlN6fsMGUeCcNd1IhSq6Vjv8Q82y6yLUbRGcrkMgd447yaV93za6znEsvqIFII4+S2/ZF90C8+AdGHau4iMc/RDrAg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDP8mB5Zpugn7FgTe+ERUQPRoXiLz+wamSEyrNC67L0=;
 b=WLL35Nkfn7uJNxugO/e6w2RW0z4hOa0aPXRzubum6uHW2VQzPPC7wEXPhUcu3oUzvPTOQ3f5zaqU4nVxyKMJ4zC2P+dnI5qZkrumRbUbNsSa72SJw5Eb1CXZ5eSyTIWvCVXLPWySDeBns/fFBtEpeJJztL2BUcpfOI677KWOKJIrDlAbUMpalMsA48wATxqNozhFnQ1Ou620+U39AWeccoeOTB7nBp9uvLuWfR7ldRvchNi9WHC9Ix3Dk7Mv4cmU3llzsJxXiVV+bOws+5PyDjPv8h3nuRFelTQWVJZo6oDIYZ3Rrll1/8ysdJD10JS0e3f7V4iQH4XO6SAhWN+i9Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDP8mB5Zpugn7FgTe+ERUQPRoXiLz+wamSEyrNC67L0=;
 b=fKpBjQX+To+iH+4G5DVuhYROAvYa+tbIHJTs5mG1gscACDexbjqOCvxtc0/K4gvgiyg8w8etIkueQYP5K+uijTN8wXmGqTzXSQsfjPe2A76HLz7s2gGwDHNZq+MGQMXDx8OdkQJqUURrCGwcsWMSk7RcVTEIg3gHzSv6QprOzQk=
Received: from DUZPR01CA0023.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::17) by DU0PR08MB9701.eurprd08.prod.outlook.com
 (2603:10a6:10:447::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 16:29:34 +0000
Received: from DB3PEPF00008859.eurprd02.prod.outlook.com
 (2603:10a6:10:46b:cafe::a0) by DUZPR01CA0023.outlook.office365.com
 (2603:10a6:10:46b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.11 via Frontend Transport; Wed,
 15 Jul 2026 16:29:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF00008859.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Wed, 15 Jul 2026 16:29:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtJ1Cj4VGSv043/4xzq6RTEr4JLVlgup5Z8ipNRmydblGJn08p8uU4NjX+i5y/OUnRVQgymZotAnGAQZSDQVNpNB/Z4rexgnxHlGtPJmQ/BKhbajRhdGngCqwGBu5EsucDji1HVTSt+XELiTqIXjcKCE5Gszsw5WQqU38kdkwFr2tEz9XkJupyG9Kla9/ecMGAB60bPGT/rRKVtTkka/TAJ72YVGJE4oolFAu1Nw5ueSs04bR8uexaMTmJhmfpVLbYP2YlAo265EDq+yPmg41mG9nFkN3rUMT8+PHa5hflK1w3VBHYDZDjbvajVqsviUrzvU9V07jVMA5lF37HDO9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDP8mB5Zpugn7FgTe+ERUQPRoXiLz+wamSEyrNC67L0=;
 b=A8d62GwyPN7oXGCPeMsavgIg4Ej1FFluTtk79JJ3KRXCYV7Ep2xjq8jAAI6SGuo0Ad2Pe2P/K4jINtS9bDZjQicsrOj180bCh5clBpaygik4ppe4dqbRoBMfNvP6+oRl1tFKy4Ivh/hskOMeJLbDYrpADC7TldKp+fBGL2KrUXTKVZ0N8HLpUnu5DILxI7k8tSuylWUZzzTb6YXRfkmeJ0FfAl+Mf/EHNDvKIp52J2WvzNVPBaZy51FkBfQl4UAQoDUwEQvSLEiZ+k5y76X0F85LYmj7RUj4nSapI2GeCT/wCZM0rcUyJ+CVmP9jw25At0Yyhw24+wZhgsle7P6/EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDP8mB5Zpugn7FgTe+ERUQPRoXiLz+wamSEyrNC67L0=;
 b=fKpBjQX+To+iH+4G5DVuhYROAvYa+tbIHJTs5mG1gscACDexbjqOCvxtc0/K4gvgiyg8w8etIkueQYP5K+uijTN8wXmGqTzXSQsfjPe2A76HLz7s2gGwDHNZq+MGQMXDx8OdkQJqUURrCGwcsWMSk7RcVTEIg3gHzSv6QprOzQk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS1PR08MB7611.eurprd08.prod.outlook.com (2603:10a6:20b:476::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 16:28:30 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:28:30 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 30/40] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Topic: [PATCH v3 30/40] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Index: AQHdCwXQrf9JFcJS5kaawpGuGjiecrZb+7qAgBLcKoA=
Date: Wed, 15 Jul 2026 16:28:30 +0000
Message-ID: <5920e6c4baeefdedf2b9080ed75b36c64411b6c7.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-31-sascha.bischoff@arm.com>
	 <20260703162749.E9DF41F000E9@smtp.kernel.org>
In-Reply-To: <20260703162749.E9DF41F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS1PR08MB7611:EE_|DB3PEPF00008859:EE_|DU0PR08MB9701:EE_
X-MS-Office365-Filtering-Correlation-Id: cb267330-c20f-4c25-a018-08dee28e411c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|22082099003|18002099003|6133799003|10067099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 EgLyDkF2xfjK1bOK0oXJOcd9kpMTqavVTV1bb991gDZX4hDaoAUGmamdvl46zBdcGYhuSUugvhVlhfXQynZLeSNWsQqlagO2pRGqdTrZiMeca2aCYBU06h2JytM+8kbOpmFhSKMkGH2O+zYL76uPxaB2eZIpahclv+z7l38/HBUnbFxeMIgcvH1GiMaBxK8jkrMv2McYLJkfrQadEupNdwVExbFiV0pFbl+sqOApqhX0WCfyPaKt452tF3vXah1xPbI79g/2wh4OIHSdss/D2p8DR3VinHHFWQhPCVfycny6f4u+2Orv1FmidVCWqXSziOa+RAEVgeWnVm2u/tUtjXCEIqIwRWu2WAlvXE7EVPuZVO8Urpol1Sx29N56rJKCOD9XoasRUWqxNJ5z3h+fZDkXCxhfLgq73eb1pqwFUVPCIOcSEMM8sQ1P9OLWEcp1w2n5XO7bXSZBgkVXNEgbYTDV1azfOx076zjnKDCNNc2L+0HSgF6W0jKtD6D3BLn+WYQ5KteJBmOwXCeDzV+70NLZWc9PRrQqUCQ2HMglQYgQ4sa5HSffVaGedXiGs/LqWUP6c/VfjkeMV7AxlVlHL+vNiEBqI0uhtfrei6hUtW3cUwWZePtHK8h5oCUNbuv3WSGgUvTiZOs+4ZQQTEhKd5UedMIvTyvSdVRxS/RXqB+BrLjWXckwoxnSAWeT7+d5/fDxA+te01cL3HSgZnFMhXjcFNok5ZafRCtU6+IleWg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9F5C7E5C10BAD408988A0DDF6F44F18@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 IfBlUnC10O4qIsMIXeqEM826AlO+rNPBud71JanscajpzoOaGKrfqo5W0/kUKz2TJ1BzgIb3KhkYJG3NBzJcUB4vFbQGf+l6TV4wCA5cQJb0OpHwxSKNOQ8H6rLQBtKyjbHfoo4QxuehwCBDBDaj1THQ/M2/Wqs7DOYYt44Q+oBWzlV3vrSH40SvIQqlBjoZDFGfBTb4EAJsVSKFX8lxO2zRaPKqj1JPeHbtwaPbWg/BfG2xdkM92UlWL3V/MuzBsQ3Zx2DX2S/VBlvWzLGjorlZkENsF60pbYYkwYreYaU6ecpAHocmMUaLXGtYbXqMh22PxdeevUSuWXRCJvNq7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7611
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	912a5f51-5772-4c49-7acb-08dee28e1b5a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|14060799003|376014|35042699022|23010399003|6133799003|10067099003|4143699003|18002099003|56012099006|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	MmXz6trDs3Ad0n4T+rlAajYaryix+NXWA9naj8zKUwu5nuFF5jcBs6SDWcf8pqxhKu2NhBHsDtMs5LsbCNK1W9y4qO4Yl9+NIz8IXefR5HWVfwSSLH0vPk1mo4/SO+SxQiBqhobtNlKNmP3e1KLP+Ws7WLpdxxA/BLUy/+BKU7/RhJ0g9UPb1CNhr29/4voOt58ejRac/31/sJOcatHl1bwOgpzYigS80Iw3/z2KMPDTo0KbvtfcZp1nz3QX/YJGKzmqvzAd5v0GlrOF5ZnKx8XfBOXTAbzMEI2oDOcaNscTiHyW5qR9kwZkBgF3EFzptw0NYfqjWAPyNbIKxI4ylGoASrLRZVS2Ii6I8hz/xFJvqYsEknIK1zYqIQo9+WiNFaj9Y7o0GtGyslOs/bo+kYY+f/7bw/TzyCVFvuL3unMOf9wI13JWD4/CTf9TJFpS1mdPOowwBekEUH9jN/kANQfqYwntfb+ei/Zfag3RsSnlqTsT9q2MhyKYo+HoNi9/YHB/ivXk3+qMTFtQa6tA2syVCCcR8kWssPXN3R+b4o7NFok/lzEHo/i/3RzSSo0BSIjbxo8rywcHnBXVnZ+x7W+/z3B5IWxbaydqcrDzlO/hkCFOkhGnQb0njaMffz8o0jVEYbsMwOTCbO2IUuipnIl8fp6bDlssy4ZlS8ZwnJ/xFb+ciMsL4bmKzKDfSP3wLQfe4G4Qx7GG7FIp+82Qiw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(14060799003)(376014)(35042699022)(23010399003)(6133799003)(10067099003)(4143699003)(18002099003)(56012099006)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ytQnop5Jo9SjdLDewYjUPOELCzAhOUKFr0wsoMkYzH+mUtrxEx0s5hXQJnAu9MdnmNypk6Ebso7r9QI8wsVOW4nwzLKVF+wjRdYJQTUMPjitIlmW5qGYsWoG4EnUQLFAAW3CLWfCiZ9QYrqvJLWuFgL000enIT7bwoJV5PBp7KZHian0+rM+u/lLjsmb+PY3pNtaZNeqZ2U73osf0pplDjtpPmFNcFZIQg2axmbam4U7+1patIQeAVvAHT8gPtpYxvQ5roHiRMcIKthR40ojkmDuO8JyAYALU/otubDmeX1Eig5M5I20GipqSvzh7fVApORWF4e87hLpx/DUhr2P+3Z0H5YCHbnl62MKgPErs+cn8snlWXToLozrW4AHup0YLmINxJDrDFDkCnDdhyAO70luYAb6mTOvTpZyx+eKdmAVWiFYRwI19WYvSb68QRv1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:29:33.7829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb267330-c20f-4c25-a018-08dee28e411c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9701

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjI3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBUaGUgY29tbWl0IG1lc3NhZ2UgZmFpbHMgdG8gbWVudGlvbiB0aGUgZG9jdW1lbnRhdGlv
bg0KPiBhZGRlZCBmb3IgYEtWTV9ERVZfQVJNX1ZHSUNfR1JQX05SX0lSUVNgLg0KPiAtLQ0KPiAN
Cj4gY29tbWl0IDkyNDQzYjQ1ODNmMmQ5MWQyM2IxYTc2YWNjZjRhM2ZiYjZlZThjODQNCj4gQXV0
aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gRG9j
dW1lbnRhdGlvbjogS1ZNOiBFeHRlbmQgVkdJQ3Y1IGRvY3MgZm9yIEtWTV9WR0lDX1Y1X0FERFJf
VFlQRV9JUlMNCj4gDQo+IFRoaXMgY29tbWl0IHVwZGF0ZXMgdGhlIFZHSUN2NSBkb2N1bWVudGF0
aW9uIHRvIHNwZWNpZnkgdGhlIEdQQSBzcGFjZQ0KPiByZXF1aXJlbWVudHMgZm9yIHRoZSBHSUN2
NSBJUlMuIEl0IGFsc28gZXhwYW5kcyB0aGUgc3VwcG9ydGVkDQo+IGludGVycnVwdA0KPiB0eXBl
cyBhbmQgYWRkcyBkb2N1bWVudGF0aW9uIGZvciB0aGUgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfTlJf
SVJRUw0KPiBncm91cC4NCj4gDQo+ID4gTm93IHRoYXQgaXQgaXMgcG9zc2libGUgYW5kIHJlcXVp
cmVkIHRvIHNldCB0aGUgYWRkcmVzcyBvZiB0aGUNCj4gPiBHSUN2NQ0KPiA+IElSUyBpbiBHUEEg
c3BhY2UsIHVwZGF0ZSB0aGUgZG9jdW1lbnRhdGlvbiBhY2NvcmRpbmdseS4gVGhpcyByZWdpb24N
Cj4gPiBtdXN0IGJlIDY0S0J5dGUtYWxpZ25lZCwgYW5kIGNvdmVycyBhIHRvdGFsIHJhbmdlIG9m
IDEyOEtCeXRlcy4NCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBJcyB0aGUgY29tbWl0IGRl
c2NyaXB0aW9uIG1pc3Npbmcgc29tZSBjb250ZXh0PyBUaGUgbWVzc2FnZSBmb2N1c2VzDQo+IGVu
dGlyZWx5DQo+IG9uIEtWTV9WR0lDX1Y1X0FERFJfVFlQRV9JUlMsIGJ1dCB0aGUgcGF0Y2ggYWxz
byBpbnRyb2R1Y2VzIHRoZQ0KPiBmb2xsb3dpbmcNCj4gZG9jdW1lbnRhdGlvbiBibG9jayBmb3Ig
S1ZNX0RFVl9BUk1fVkdJQ19HUlBfTlJfSVJRUzoNCg0KSSd2ZSB1cGRhdGVkIHRoZSBjb21taXQg
c3ViamVjdCBhbmQgbWVzc2FnZSB0byBtb3JlIGFjY3VyYXRlbHkgcmVmbGVjdA0KdGhlIGRvY3Vt
ZW50YXRpb24gdXBkYXRlcyBiZWluZyBtYWRlOkRvY3VtZW50YXRpb246DQoNCktWTTogRXh0ZW5k
IFZHSUN2NSBkZXZpY2UgYXR0cmlidXRlIGRvY3MNCg0KRG9jdW1lbnQgdGhlIEdJQ3Y1IElSUyBh
ZGRyZXNzIGF0dHJpYnV0ZSBhbmQgaXRzIEdQQSBsYXlvdXQNCnJlcXVpcmVtZW50cy4gVGhlIElS
UyByZWdpb24gbXVzdCBiZSA2NEsgYWxpZ25lZCBhbmQgY292ZXJzIGEgMTI4Sw0KcmFuZ2UuDQoN
CkFsc28gZG9jdW1lbnQgdGhlIEdJQ3Y1LXNwZWNpZmljIGludGVycHJldGF0aW9uIG9mDQpLVk1f
REVWX0FSTV9WR0lDX0dSUF9OUl9JUlFTLiBVbmxpa2UgR0lDdjIvdjMsIHRoZSB2YWx1ZSBkZXNj
cmliZXMNCm9ubHkgdGhlIG51bWJlciBvZiBTUElzIGV4cG9zZWQgYnkgdGhlIElSUyBhbmQgZG9l
cyBub3QgaW5jbHVkZSBTR0lzDQpvciBQUElzLiAgVGhlIHN1cHBvcnRlZCByYW5nZSBzdGFydHMg
YXQgMzIgU1BJcywgaXMgY29uZmlndXJlZCBpbg0KbXVsdGlwbGVzIG9mIDMyLCBhbmQgZGVmYXVs
dHMgdG8gMzIgd2hlbiB1c2Vyc3BhY2UgbGVhdmVzIGl0IHVuc2V0Lg0KDQo+IA0KPiA+IGRpZmYg
LS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+
ID4gYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4g
aW5kZXggNzBiOTE2Mjc1NWM3ZS4uNWM2MzIzZDgyZjc4NCAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1
bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gKysrIGIvRG9j
dW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2VzL2FybS12Z2ljLXY1LnJzdA0KPiBbIC4uLiBdDQo+
ID4gK8KgIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX05SX0lSUVMNCj4gPiArwqDCoCBBdHRyaWJ1dGVz
Og0KPiA+ICsNCj4gPiArwqDCoMKgIEEgdmFsdWUgZGVzY3JpYmluZyB0aGUgbnVtYmVyIG9mIFNQ
SXMgZm9yIHRoaXMgR0lDIGluc3RhbmNlLg0KPiA+IFRoaXMgaXMNCj4gPiArwqDCoMKgIEdJQ3Y1
LXNwZWNpZmljOiB1bmxpa2UgR0lDdjIvdjMsIHRoZSB2YWx1ZSBkb2VzIG5vdCBpbmNsdWRlDQo+
ID4gU0dJcyBvciBQUElzLg0KPiA+ICvCoMKgwqAgVGhlIHZhbHVlIHJhbmdlcyBmcm9tIDMyIHRv
IHRoZSBtYXhpbXVtIHZhbHVlIHJlcG9ydGVkIGJ5DQo+ID4gK8KgwqDCoCBHSUNWNV9JUlNfSURS
NS5TUElfUkFOR0UsIGluIGluY3JlbWVudHMgb2YgMzIuIElmIHVzZXJzcGFjZQ0KPiA+IGRvZXMg
bm90IHNldA0KPiA+ICvCoMKgwqAgdGhpcyBhdHRyaWJ1dGUsIEtWTSB1c2VzIDMyIFNQSXMgYnkg
ZGVmYXVsdC4NCj4gDQo+IENvdWxkIHRoZSBjb21taXQgbWVzc2FnZSBiZSBleHBhbmRlZCB0byBh
Y2N1cmF0ZWx5IGRlc2NyaWJlIHRoZSBmdWxsDQo+IHNjb3BlDQo+IG9mIHRoZSBkb2N1bWVudGF0
aW9uIGNoYW5nZXM/DQoNClRoYW5rcywNClNhc2NoYQ0KDQo=
