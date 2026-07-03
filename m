Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010051.outbound.protection.outlook.com [52.101.84.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0530D21D3D2
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094790; cv=fail; b=ha+ndvvBWO7bJ9bz2yjZ/P7JOxHKC6z7PU5mTrmcBSqFcBw3OUIstw4VsPObInWtM6C5lIIOdJ43k5i2Opns36Z4Onh2HkP9pMpKtaKA+H6hZybjandaYZqkdbM8OG7Bqw1sdc3VZWnAn96WK9ijIYRuRs21PGN6Gwz4G5UgTcc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094790; c=relaxed/simple;
	bh=EFl7fyBrbOgotvRNzDGzjvGnfDTH1s4D0V+c/bHEvOw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CRegb8yXMLw20t0WIk7exwzuNKZhEKODHyPKjytAgUxxaisJMP0i0piH/eq8UFRNwXKnRQYx5JGjAKiUPSgOEtvG4pgsRhwc78EwY6Kr9NjxbVD5xDioVcrXerhjor5z+hlKeCYU86+c7wF1LvhCcG9h0QCR/PioERI0E5uha4k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BUzbzYSy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BUzbzYSy; arc=fail smtp.client-ip=52.101.84.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BUzbzYSy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BUzbzYSy"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gg7uEpSqnClHJnDeQpfuB71T4sqYrSx+yiPSFQg7V10Bf0Cv/1m/PnuhM4760hjxoj6vi38trKxNSw/aqUEZNkd9eMAKLmqp3TxQ5JPkHKXEigEJAfft9pieslRahVETDhW3AtvFoi/9nj306Ylo377C6Pq/rbzlHzNHJWRIpnYWtvv7hpIW7Q/cE+bKLdNS9irO/nKiJLumw5tIc5hqmio7qjKrvEZS+GjDW1Y2P6rYDpee4DfQvthbtxzX0Y+3e4BXzpw0mDJPCy3Mshfmt5tPS1VwVOUm1ZD7ucXiOAAlp1Zr+epgYkl62ldfHNOb3qiGou+qQonjIQBMRXcP9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMSh3DwtjihO0lSS/wi5DNQ9bfi2mNjVG+3g01/DhqA=;
 b=Xyp7DiQGWIORfG+yz4/LpBk1ZSPX9ouE58bL4imVz1HYkvqElU+9MYVaf988eeyPcK0u7iqWP9h3Iin3sXy65hgixV1L15ER4goZcqeuxdudW6HDL7KiquHLk52PbVwbF/Nfsg0kFuxYvmTsfjdPNo8cfFb0E+nnAzTEBn9v44w71mg9+vmuGWiJSOKtgui6zUBsOoO78nqEG+tNfzd0pf+6iIY6bsD/g4DKCEgkv/Q4yF0yUPRCVwDM5b2P6YW+qwke75vJFHC3VD3O3Iq/z4x13Z7SfYCw/afCsL6rTbyd+BrZj7hRd3kyitK/vp8w6cjnCgCjLRn4xjdcXzjIrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMSh3DwtjihO0lSS/wi5DNQ9bfi2mNjVG+3g01/DhqA=;
 b=BUzbzYSyuDVLe99GnwZ+6AU2no8QRaa7aiStJ6+QTTDbTnDBEwco0bDpLsArEWH2MdwlaoC0ouhO/Kj5BwSMwxEOQd042yRg8dE3iqcCs9MR7Ggy05bm6EBHNWBT8PtL1C7P0OKmMUsZzu+aW+/dV7GhG4e3PeUvRdZZ+V4dvZY=
Received: from AS4P189CA0056.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::26)
 by AS4PR08MB8167.eurprd08.prod.outlook.com (2603:10a6:20b:58e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 16:06:20 +0000
Received: from AMS0EPF000001B7.eurprd05.prod.outlook.com
 (2603:10a6:20b:659:cafe::ad) by AS4P189CA0056.outlook.office365.com
 (2603:10a6:20b:659::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:06:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B7.mail.protection.outlook.com (10.167.16.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:06:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnzOA1rghSs9PeNjeTYqcq169eLMBsr9dsWwoAHsMbpIWfy/5jcTfRjtm7ZShUiSwd0Odte4CSp3qjv+qNci6VfFcIA9GIqlKmAXqTHR8Qx8VGWrdDyBRRGoyIoL+/Nala/R83FSwKZr54FGUZxzUFA9Ng6kxkW1K3S1XPQT03Y7wHRaKii3pXUOOVG306vqcOS6isTN39X5fpbyh3wY1u6H2U0CKmqwPo9IF0v4KEPkd+ewJhDt6Y1wf8TEGFTv99aUd6sIU3eIVs7wOhT6GUrVhh6w+xuES8lg93nCIoioutZMeVuL9Y/Z5L8MjLQ12Ocot1syd4LlCOcefGJTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMSh3DwtjihO0lSS/wi5DNQ9bfi2mNjVG+3g01/DhqA=;
 b=vg/qw/e6/UXNBtl+as7zSzOd10R70VFg1Ev6DrIq9gvVEY27zu7b+NlY3z2PuFmRo001TsjlBkXQLGp/cjmCc53nspPTfiJXy08Sdqav073ENuCTO7Dlj8g5MLyLbmpR/2fREhjX1EHYcbIO9IaBiONuLo7+wt8IeNzFBijbLij+QO3AcN8XGoIOTY1GbzjzpFaaiXM8HvTTXJ7YFsSDrRWaTWJe1Uv6hZ+iONHbDRHnqp/Xhg6n7iaxMPBJO5Y7QkLyzs8+W6Lqf8D07nqpndQPggKmIzUks/BHGiBBEM3RDDM+VB9Asa5FuWWLd86VVSdtD32+Fue5akiiuWukHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMSh3DwtjihO0lSS/wi5DNQ9bfi2mNjVG+3g01/DhqA=;
 b=BUzbzYSyuDVLe99GnwZ+6AU2no8QRaa7aiStJ6+QTTDbTnDBEwco0bDpLsArEWH2MdwlaoC0ouhO/Kj5BwSMwxEOQd042yRg8dE3iqcCs9MR7Ggy05bm6EBHNWBT8PtL1C7P0OKmMUsZzu+aW+/dV7GhG4e3PeUvRdZZ+V4dvZY=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:05:18 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:05:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v3 29/40] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH v3 29/40] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHdCwW90Kp+qzFTMkW+WRqQDKdPjQ==
Date: Fri, 3 Jul 2026 16:05:18 +0000
Message-ID: <20260703154811.3355680-30-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|AMS0EPF000001B7:EE_|AS4PR08MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ee57ec-6fd5-4441-045e-08ded91d05a0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|56012099006|5023799004|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 THXSps3Xy13lqgKXzGZWmeWM1ofDKn2iQIov7F9Xim+abkddWYzzpI8l5Kf3Zt7v/oWw5q7VET69Ry+3qPylQ8lUeUIEQ/uwo3F6h8W3s6bIW6k0hI5jXv+7JfSDTxN25043/bl8MkMOdPQXRD+q+u8mefDtXEaNHKnS0gvg0qTpAbn4E7Li2pb+ZglVe3m8KT3BDLUtglbOp6UYUjnGkR1tc/lkZgZh/NNDzgvJ8f6JM+xdmWXWKINiDIkokoS/sTYAgxbrgtUgd4d60eqjcDAK6ExjtoLtvyEg6rstqJM3vClli2y+lD1tfS8JBLZz/DHh+wAX3oXg6km9MkOy2lGzfgxQ03Ee5p8gGoSI3vAsGFdRIehQoAoUMwZ8mmkA+7XlbeLtI/UonimoLt9i+nuIXt4W3AH9Job2LZonX+u/FKB4RXJfAqkjFyGsinsZHOyYbhB2QJexWWUQpjGVbreKkqHaixhl6sCGOqpBNfRlwS8pGgb9l0eHLQrZsdIyPpCRRIQPl2nmZo1i07aHZE9OanJLg/ZuCWyuq7Kwk+et0KFC/f/twx+DfeIlqO7c+bHm7FqfxpvNJ+ZE3AYw4IgWmyEnwDTLUgEESQy/fSBCCRSE6Ddr8vZYBRU0uj+1KUbfh3/QvT+XB841RIYfoxdwgkjXgKcklWeJ12POtcbEbdxwQFVdf8uSWNiiGC5ClaOkp4HaJTjIFymsQVNhEQbT47M0e4ywP7P7lW4IupY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 KA9RyTznxENvXA944PW3p448b5rnpjhD2raN+KlJV1fQK1mOrm78AaGW0AXcHfzuLV8CMo6SRRZqEOgm7QDrM9mNxF5XmYYFLFFFPij5woblxXhsC8et8AEkEmAGdwjAvPnZCrZv+F9OxrU2AJbLNE0RaaRujxytiO9ay38R/FuwtN3FxC4Bw5LOBHl5vqwXErnyDk/6w6IXEHbxA3qVC/66/DULG9dKMYfhlLr3ZLu9uN/1AwFyiwDilWt9Dfoa5BEknLoOD2Qh2Q5fPMjVsytTU5upu8R+Em7sbXlY2w87F6ebXxcOnL13Wr1lFD+JNKQEBsfNSpkzXTP8GnzSYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3e85d213-dbd3-416c-37e7-08ded91ce075
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|14060799003|35042699022|376014|36860700016|82310400026|1800799024|18002099003|22082099003|11063799006|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	Tmdw4khgqRsk+uskVPP/jfb2KbEd8lQ7LjkAFriE9iuyAegDbS08zK56SMT1zq16bEccVG1U9IalksEhQ8DxAobB6Jl9bAdX3dSF1QWVRON843PLAgHG/sluGY8wktYPURJTeEkeTHqxM5DKNRNctqaYX9MJ+sJozzudBu83bmuz29Au64bzL4evp0zRm+tAYuhBRJBWyuPV+dQR9IlxxbczNsiym7W0V3OLHg2b4S3Y35/u0+ngb+qQaC3qW+fYAmU1y/ze0BAU0WG/OoW4NR47O/6HEBjvOn9mZEs5zjYOC1I+pA3eLLcr34WJJQ9hCun7x60c8OQkPIzd+QezC/y4SmS4INpniks7Lnxe/fNjrnyBa4dAd9cWb1WqCWDrbM2aQnx/m5GaIZL31BDL5Uske5bLI20hpxa9cKCB7d1k63kkVnSQVhDz/jwL3WuFisqniAAVBauE4Y0QSGCKWSznrNykxhK8rStikkF4+ykie2kHvWU6Sz5h5bIeNXVaTJYSOYr+sGq+bpEWE22xxi8s6O+CNewAO2oqm1KOWYl8ZZbsHlgHplste3KHIK8GsAHKHDiU3hHLAJ0mJwRneHWLKTWLWp+wwhBIDFMKdA3UsolPWlIPTb3/DvIG+llkFL1H3PH691xNlICqoaPgILPRrUmwVNkl/Q5Pl3GFGc3P7n9VBAWK+dva/U+ENkUuW6Y0+qmdOLMFQ6th3sGK1g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(14060799003)(35042699022)(376014)(36860700016)(82310400026)(1800799024)(18002099003)(22082099003)(11063799006)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aq9I37uK7Cs7wq/qE2WU2b2FXNMtE5riZwjURhIP5FlHyO/nbQTL6g0gZDI7Y3sj/iEqEYmYYbpjbYsdNmVrZvDvmg5uuJ6LNbgzfvGK82OFZxbnKhSBP5GSp5Aef6y5AAUDqS0werWs3ywcW30hjrfxrTPa4QYd/qOINxekjcJx8UFG2kvhLTrrXsuxMseWpvAFQO+Kg6jQaE80AYDK3SdExfMMy1jXSJ2RwDzqubRaxOGFQMeq2a0JJx/YW6YIxULbv0fTWXeOvBv1HUphMuYehhnHxiphU0H6wkFXepYf1B5B055k/9smYjBQLiY1rJycB8S9Vi3exuFpp1lCPFR7fSyYYp20CLz02dxeiCfu5R5NeJ5p/YWCNnhmJtf8fFFiNZooOEajIP6P3SqABfx7i1jB0v2XPJud4Ymqq7s3v5+xI1MpRwYEbJnq4uqU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:06:20.3915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ee57ec-6fd5-4441-045e-08ded91d05a0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8167

GICv5 SPI lifecycle is handled by the GICv5 hardware once the pending
state has been injected.

This change adds support for injecting and managing SPIs to the core
VGIC code and GICv5 code. First of all, allow GICv5 SPIs to be looked
up by ID via vgic_get_irq(). Previously, only PPIs were supported.

Two irq_ops are used to inject the SPI pending state into the
hardware, and to append the SPI to the VM's global SPI AP list.  The
set_pending_state() irq_op is used to inject the SPI's pending state
into the guest. The queue_irq_unlock irq_op is used to append the SPI
to the SPI AP list - they are not added to a per-VCPU AP list as they
are global to the VM. Also, this would require KVM to track the
affinity of individual interrupts, which would negate much of the
benefit of their lifecycle's being hardware managed.

While the SPIs are on the global AP list, their state is checked on
every vcpu exit, and once they've been consumed they are removed from
the AP list again.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  1 +
 arch/arm64/kvm/vgic/vgic-v5.c     | 93 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        | 28 +++++++---
 arch/arm64/kvm/vgic/vgic.h        |  2 +
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 5f5f5efa8c955..96bf02170caa7 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -672,6 +672,7 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 			 * view it is always enabled.
 			 */
 			irq->enabled =3D 1;
+			vgic_v5_set_spi_ops(irq);
 		}
=20
 		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 20ae7daf4c451..ceab71c2412bd 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1113,6 +1113,99 @@ void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
 	raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
 }
=20
+static bool vgic_v5_set_spi_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	vgic_v5_set_irq_pend(irq->target_vcpu, irq);
+	return true;
+}
+
+/*
+ * Put the SPI on the SPI AP list. No need to kick the VCPU. If it is runn=
ing,
+ * the interrupt will signal at some point, and if not, then a VPE doorbel=
l will
+ * fire (based on the IAFFID the guest has configured).
+ */
+static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+					 struct vgic_irq *irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct vgic_dist *vgic_dist =3D &kvm->arch.vgic;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON(!__irq_is_spi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid))) {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		return false;
+	}
+
+retry:
+	/*
+	 * We're already on the AP list or don't need to be on
+	 * one; nothing more to do.
+	 */
+	if (irq->vcpu) {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		return true;
+	}
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* someone can do stuff here, which we re-check below */
+	raw_spin_lock_irqsave(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+	raw_spin_lock(&irq->irq_lock);
+
+	/*
+	 * We've lost the race; and have already been queued. Unlock
+	 * global AP list, relock IRQ, and retry.
+	 */
+	if (unlikely(irq->vcpu)) {
+		raw_spin_unlock(&irq->irq_lock);
+		raw_spin_unlock_irqrestore(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		goto retry;
+	}
+
+	list_add_tail(&irq->ap_list, &vgic_dist->vgic_v5_spi_ap_list_head);
+
+	/*
+	 * Use the VCPU we've been given as the target VCPU to track
+	 * that we're on an AP list. We're not queued on that VCPU's AP
+	 * list, but in lieu of an AP flag, this will do.
+	 */
+	irq->vcpu =3D irq->target_vcpu;
+
+	raw_spin_unlock(&irq->irq_lock);
+	raw_spin_unlock_irqrestore(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+
+	return true;
+}
+
+static const struct irq_ops vgic_v5_spi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_set_spi_pending_state,
+	.queue_irq_unlock =3D vgic_v5_spi_queue_irq_unlock,
+};
+
+void vgic_v5_set_spi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq) || WARN_ON(irq->ops))
+		return;
+
+	irq->ops =3D &vgic_v5_spi_irq_ops;
+}
+
+/* Set the pending state for GICv5 SPIs and LPIs */
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	if (WARN_ON(__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		return;
+
+	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, irq_is_pending(irq),
+		     vcpu->kvm->arch.vgic.gicv5_vm.vm_id);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index ee7fc0c7104e6..26f9ff7700429 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,19 +86,31 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u=
32 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
-	/* Non-private IRQs are not yet implemented for GICv5 */
-	if (vgic_is_v5(kvm))
-		return NULL;
+	enum kvm_device_type type =3D kvm->arch.vgic.vgic_model;
=20
 	/* SPIs */
-	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
-	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
-		intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRI=
VATE_IRQS);
-		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+	if (__irq_is_spi(type, intid)) {
+		switch (type) {
+		case KVM_DEV_TYPE_ARM_VGIC_V5:
+			intid =3D vgic_v5_get_hwirq_id(intid);
+
+			if (intid >=3D kvm->arch.vgic.nr_spis)
+				return NULL;
+
+			intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
+			return &kvm->arch.vgic.spis[intid];
+		default: {
+			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+
+			if (intid < max_intid) {
+				intid =3D array_index_nospec(intid, max_intid);
+				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+			}
+		}}
 	}
=20
 	/* LPIs */
-	if (irq_is_lpi(kvm, intid))
+	if (__irq_is_lpi(type, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7eef8ece52dde..b5036170430dd 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,8 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
--=20
2.34.1
