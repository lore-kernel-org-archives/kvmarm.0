Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013067.outbound.protection.outlook.com [40.107.162.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F15D437859
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890845; cv=fail; b=BRkVxQl0cQYqLB/8yN39ICnzTdJPy+Cqr+ghr3aH0Df/dsCXxcJGgNQSCb/GxCfYJHNC/LT7wP5wg+yj1DID5MpC7RXnpJsCkt2+iUN8MJcrlDex1R3C41uhcbENeMuziJJf+pfNCBmT7HE2F7HLkSA/B7B+t66CcbmZudHzjMM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890845; c=relaxed/simple;
	bh=Ko/Ag5SsnXABF5VTIl6jlEORhtzfYzIruVmlu5mtBhY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L0tmKckJ2et/B/XoQw2uP6JYioRtL2/U2oQalzUTYosgUpz9wgdUyZD/xHIxcDJNaGKihYNep/rU+uNIqEjSNOCa8JZ9J4WOSGt375nHFylqIavQV+93KkNkJiuZDPtTsN8n8qXhREQflioK2YgIIyyqvV1sTjpsnQuj4geOEBY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eYi7UXnM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eYi7UXnM; arc=fail smtp.client-ip=40.107.162.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eYi7UXnM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eYi7UXnM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lhpEV/mnlykkQRNajAE4ga5bIAoUXDTVpfBytahCokHIIIAgpHzkqdmzlwts4nE9Mu5fIUq41em1ZN+aB7koFhQBCi13Wwr3RTrJMemRPQoEov7IAKjvXxrfD52UDCyGd/bZTvMQ0mL6yRPPyM+qKc171YVIHBnIGJGQGvg4I1/XxsvbowzYps6tmMwQUqOp7FH0wqY+HiiRpTDL4oiG32BE0dJnxUFP6urSDgVaN7KNn0RECvY3istW0RKbIZx7ZsbEjLpc9VlJzxECSVQ0pK11NrZjSAPH5EF8h/jIPy5aMbYSCdHhDDZggXq+SDM2xblKjMjRqvHYH7tM8mCBWA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWuvF/cIW35TliKCeQtLhP5k68r/+d4MQq+r6RzxJ7g=;
 b=YkOB1jMhD8oUIozVX/cPwyPEIgOj2b8jtf3UeBzktUv7lguWX/KTE1tzncGMGEN/lOBpIVtZe1nm6B2cXDPmtlmBkRJNm8HkwpGk+UbXebr5rgo3pLu/omEgtcjT5cNV/hHV148sf70sWrIjgKuHdyyvzXnJt2BskgwIh0KKG0BF3AnmvGGy4fGTisAaP/UnDXAg2JpRUA3ku2JhTFtbcrSIk90hDAN+790oZXeIKkFVuz5JbW5hMB6kIBtHaZOatINPy35Ehfft1WVylB0OksFOuBpbrf7J9DzdPm6/u7j4S+EF9nh8WP6sMENm90Ym92RfmlRV56wO7768iKNV3A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWuvF/cIW35TliKCeQtLhP5k68r/+d4MQq+r6RzxJ7g=;
 b=eYi7UXnM/tKp2IQD7uAiuuUABwwuTaTF5VX/FqnQ0ArRja9xv8A00XzanbmnBnBdXShyH9cRtovhg7658yEkrI/O0zl8MU31tV9cQyKK/vlvRQuyf7hm+HBhDF2gVHTYrjl5p1fg0hxDilre5QU781GlZ9xEGNTcZZwcllHmcXM=
Received: from DU6P191CA0039.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::13)
 by GVXPR08MB11373.eurprd08.prod.outlook.com (2603:10a6:150:2e5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 11:00:35 +0000
Received: from DB1PEPF000509F9.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::87) by DU6P191CA0039.outlook.office365.com
 (2603:10a6:10:53f::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:00:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F9.mail.protection.outlook.com (10.167.242.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A1TGp7jnoK5lC4hggLNy7M5oBa7k7uIHCP7XgGR3x5zTBF07HrQ7bAYJE3lXsyT+OPtfMUwgIIk2nQfft8nQT5JFpIF6f9w1YD7MNkECGOS7En5ZcyJ41cEte1hJkzl5QyTtdF3UQoVvZtHp6w7Zuh91EgCnA7YJmmjRYynY2w7uLUtMzepVx27Z82hYnRLB6pL219WUzwlw4RvWfaBDcF70xvhnnrijhiSjB4kxJ20xTACe7Q5Bbi8j38U6DJuBF5Lr7W6LvJiaMD3hC3qJ8u3u82lBsONRGrA3A7Ognv9zd8utH+hsaS+0ttV4OtMRettWLbG2S4MJ8iIL/USfIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWuvF/cIW35TliKCeQtLhP5k68r/+d4MQq+r6RzxJ7g=;
 b=ivP2AdiGBvYUAS8pDKxfuf1MDoqULH1DXxOhlwkacbRZX/U6NebyVrOIjPRZE4eHmjo25d9r0Wm/mxO7cS59M7EePsaAoe58Um4bQG6X/A1emyaqYA+qjk/WY9o3OSr21aaqMJF4m+fa98ICIwIQ8r5jedS1oGcY7R6UVPjaDCmRh80oCVPvkRTHGffPYi/DSPBAhw5EDStgwAVNx55RiEq1x8+4n3DZBBPrOZGgGQ0LCuQaYEpWe7aPtnZSSEOKJvwG9o5vmQq2jkkztsc5BmqDwLXJcYWB71Q5HdteA2PIYDqMEwF03Huspsg596uFkOtp11L84vNctHv83oPxYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWuvF/cIW35TliKCeQtLhP5k68r/+d4MQq+r6RzxJ7g=;
 b=eYi7UXnM/tKp2IQD7uAiuuUABwwuTaTF5VX/FqnQ0ArRja9xv8A00XzanbmnBnBdXShyH9cRtovhg7658yEkrI/O0zl8MU31tV9cQyKK/vlvRQuyf7hm+HBhDF2gVHTYrjl5p1fg0hxDilre5QU781GlZ9xEGNTcZZwcllHmcXM=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:59:30 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:59:30 +0000
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
Subject: [PATCH v4 43/48] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Topic: [PATCH v4 43/48] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Index: AQHdG1uAbvb/V4v/xk+bcqQdrVLy3w==
Date: Fri, 24 Jul 2026 10:59:30 +0000
Message-ID: <20260724104819.1296803-44-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|DB1PEPF000509F9:EE_|GVXPR08MB11373:EE_
X-MS-Office365-Filtering-Correlation-Id: 707871ae-b1f6-4ac7-2107-08dee972c98f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 SyZB2pBYCVvUvNYRzdzjtrzwOufESjcWAWFxIslbh0YHPfq7yJw1/161ujUksuyGGQR68UkjreoMxd3YmNR/25634ThvGgXp0cRzZOu6Wrmd8Ep1pl3IprVKJ5MIw2dgOiLDl6mYD/UqhmlhhhqEg1uDu2jHmSNdD8ddDbpVVWpLCisaVP9CN/rlLj0kVHltBfZ7pLdgMvy1noGFxBqQbJzLNZ2iOmh7Vb6Tt+2ceRNcKeFbBsHiePe1QMGGgE1oM1DNVXpKzUfcKHdtwzjDiOYV5EgOJS2b7PnzE/DRhWKxTpP1Ub0H/WHkjLqjwxKN7ckkly7/NUw33c+1dxQPL2ihQs/lkOe8HWm18nA9aeXF/Bxe//bC41UMULR4SITx1cee+iGMR8b+I8b+H/C3XobX7RL1FA79D7ZBiGEWLGTc5B/cct6OFCFu95N4ww+FlGkS0bkCAIiidlI56iE24dBPuWw+VogcvOGB2NAqdLJBRxMnKLHhHsGqJZnrWA1h9NFU531OR6dT6YGczvUH8saQemmDE1D8XkueBt33dO6Xa08BXa36D7umoBpCdfR0SMIXm5Ge0kwA6bz+ApZHpnOih2AMJhBKlQysortAOez2gkAn88XH9W3UXNYxPpJYtZRKXvOYrX7h9Re5hyOtA1eskzmrV43lrBc1jsSLuYw29LhXvQqFzsxU37D7gwysRu577gH8Y7z2rj91npDJ/w5ArpCKVs1AFUBotBa89Wo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 T7M01DNsEcRVhPq9463xw8dDNXCP7djWhlWN6vGeMl7ERzIHaDPjoJ75i7htN5q9l6oGsYX2uxXCGPPI6Zop6JgJMb+3NY2NRwKWPl7hgy/5Udk5KtUzNaPEDgl/kze7asrZofCzVkFGhFJIWUmC2pSJyNQvFVeaBSZzoPezq1S7dmDlaB5qKQqYyB2f/s04ZZkKrl+MuyrNPY0/95GDm+GBoIogZa8QXRcLdgt2oh7LuC+iF99iuNRwm6PMl+fA4DY9BLMBKmjl5kDXEcercNee8MviV4bfIzAhBHpsyygNfaUU+IJNkbrfjCrvUraV2vIbK7JaRg1YhWGkk5TiMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	153f4a95-cbb5-4a75-0915-08dee972a2e5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|23010399003|14060799003|36860700016|82310400026|1800799024|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gsBiw5CC0tlWJvMjMIqjf6O41us7YxHLevZtHewZQbVXmgBPK95QHkoBZ/n7ApXSsr7mDj0BDTl/o8O5QkvyEkt38rp3zW9krlrFDLa9zK+jyoBmv4IWHFy2vg8UnzLl8h46UPi9Q08skOkuKD8QYz0KkULS56/SdPxTMbQvQXhEDt/NW7h0EYYoCk7RBOKclmrDrsanKjZ8DghwFYUyMBQkLyI9PH72Y81FLyp3YXq9iOWYImUHjgkqBqRMPMZRICuFmO74CLo6n0OfcO53FnmS1E9a7rlL8Xc0vQfx/Nf8PcQ9db7DBOL/XcuvBU+3QgUjzxOp0vqllcFLB2twlR8SF4pBvvwSGmtM85aBrh14+CvdpdVumbvOxqhkVg9Wc0Dm/Z4G82y2s6Trc6rrPjz+1qAAIjPXrbC9OFIbiLYHf1NKA2ul4+NPk1xzOlT7KEscw2f2N6omavprXBLw89imiyIPBgywlPoLmSlFP+6MaweFW3CKtHAb1WlXRv2R4I3junVXYviIYVbA5gVbzdyLg2i3SF1pjeQiPufWVTi0R70wbRgam/j/9uPoOVFXcmovu7cNaiuSL17HRBQDsoT0jkor2LA///Q3UDxicDe18RGRf9eravLGGgs1m4riescoTCviVKnZoqc37xrwjkLCtrXGm0z/eXDc/wt5SkHT+nkEbc6VBKLoukmhgjcFASZ0aKoo45tKAddFe2UDgw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(23010399003)(14060799003)(36860700016)(82310400026)(1800799024)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uWYN3PtQ1fIOa5/fgvT4RB3QIgm+vk957/VM6BNSdajRFgVIEgC4bJWq0mbWwlCND3WyZta31nc/noM4mvscalWUhjcJVGde2q+9PPvQvPwpWqW7DqeXwlFugS2ilM0nKkAJ35tbdvYyf7MLw03QPeN4JejAyTFauYT8b1DKAV6K0RC3h1CNYqD9/c3PMYjVAI5NwdZT0F5Gucod6qH+beCq/ZT+Hlmewa97n35i8n2OehawZGqOVTMaGVSB/eaNsK5NFzV8RpyqsP9pbMb7VEVtH9HKxUG0a13H49rSkddMJijF4JF68pv3QD+6unvXphu0rnrbmEd/V33xuOZ0KZIf9glVphcVRuToza1iv0fpRT1oPuMS3h8qg/+S+Pc9vzV52GSm4b7uKGaE3AaEYZPH1IDQMwRENT2ZTMY7IhOHN+LRROURQ2vK5M5LRCmi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:00:34.8798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 707871ae-b1f6-4ac7-2107-08dee972c98f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11373

Add API coverage for the VGICv5 IST attribute group. This does not test
that IST save/restore preserves interrupt state; it only checks the
attribute plumbing and the cases KVM must reject before the end-to-end
restore path can rely on the interface.

Verify that KVM reports the IST attribute group, rejects unknown
attributes, rejects save/restore before initialization, rejects bad
userspace pointers, and rejects IST restore after the VM has run.

Also cover the userspace IST descriptor validation: a VM with SPIs must
provide a SPI IST buffer of the expected size, and LPI storage must not
be supplied when no LPI IST is configured.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 122 ++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index ca03d1cb6a2af..f756dcab26278 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -29,6 +29,17 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
+					       void *lpi_ist, size_t lpi_size)
+{
+	return (struct kvm_vgic_v5_ist) {
+		.spi_ist_addr =3D (uintptr_t)spi_ist,
+		.spi_ist_size =3D spi_size,
+		.lpi_ist_addr =3D (uintptr_t)lpi_ist,
+		.lpi_ist_size =3D lpi_size,
+	};
+}
+
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -530,6 +541,114 @@ static void test_vgic_v5_irs_regs_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_ist_attrs(void)
+{
+	struct kvm_vgic_v5_ist ist_attr;
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u32 spi_ist[VGIC_V5_DEFAULT_NR_SPIS];
+	u64 attr;
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST, 0);
+
+	/* Check non-existing attribute */
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST, 1);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST accepted bad attr");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    1, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST get accepted bad attr")=
;
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    1, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST set accepted bad attr")=
;
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
+	/* IST save/restore is not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST get before init");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST set before init");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* A VM with SPIs must provide a userspace IST descriptor. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted NULL desc=
riptor");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted NULL desc=
riptor");
+
+	/* Check bad userspace IST descriptors. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, (void *)1);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IST get with bad descripto=
r");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, (void *)1);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IST set with bad descripto=
r");
+
+	/* Check missing and incorrectly sized SPI IST buffers. */
+	ist_attr =3D vgic_v5_ist_attr(NULL, 0, NULL, 0);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted missing S=
PI buffer");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist) - sizeof(__u32),
+					 NULL, 0);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted bad SPI s=
ize");
+
+	/* LPI storage must be absent when no LPI IST is configured. */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), spi_ist,
+					 sizeof(__u32));
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted unexpecte=
d LPI buffer");
+
+	vm_gic_destroy(&v);
+
+	/* IST restore is rejected after the VM has run. */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, guest_code);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 VM before IST restore test");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST restore after run");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -652,6 +771,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IRS_REGS attrs\n");
 	test_vgic_v5_irs_regs_attrs();
=20
+	pr_info("Test VGICv5 IST attrs\n");
+	test_vgic_v5_ist_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
