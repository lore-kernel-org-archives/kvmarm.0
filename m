Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011031.outbound.protection.outlook.com [40.107.130.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8379234D910
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306502; cv=fail; b=pEgoOxZfzx1dm1uHk9AT9Xpi5h4KUBHsi80HQyeDTf2iIYyde9Veh0EuuYe+OemNA8a/JjdiymnSwV/6gDERyxpw24PLiBc5ug2GgzSuk8hIp52iHD6CHVzDaCq6BQsIqHcF8AZsNapjU8AG5W3RBrA5MWv9M1j0R4S30WuV08A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306502; c=relaxed/simple;
	bh=HjJpCg6eQKWx/iRvBFBfjvWIoSjVW88nQfTfZZKH6vs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pczDs55X4bgjRfJJGVNHp7hde5HP1ECyW5vXTb+3t4pVXaI28cLsWJVs3V/sjW8genyCkpcc39VGb7NYV/+BXXQ4/StCiYXoCUVFYk9pTs5ao0GBIjlZnIesbC/ojFtVeq1p/cdx1Gk5i+AarlOYm3SzkHekr6GyrA0juaWNCp0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K1B/gYWk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K1B/gYWk; arc=fail smtp.client-ip=40.107.130.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K1B/gYWk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K1B/gYWk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dzupbkF5VRcuPUFC/+zB15NsVUy7Fa+PjVSKGiejMbokCCih8kfP8KHT6NvwhxU7qJmurH66OS+9YLBBFfuWMuVyfLotsJobn5NzyHbQVM/d3W7LEwUdAkDNaXF2CZ1lS1NHwLs1W9Unhrbz7oloGhF09wGstfp7J7h/5tXOxWqa6Ia77xh41eMb/SdiFbKn7Rdt1pLTOl1LWPSJjF8IKyLdcNYSGdwrUfqnkSE9TzJjlIsAvE7BdIdBJw7yQhzY67ZF0cTTIr/jcGrdIRwREHNYn3ZkooayPtsgY1W9epSGw23+THLhYHP+t3oyqM5RySME1Hn4za4YNXNXryg7mw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJWeL/pc9Da2uztSw7o+mXJDEhb/54xQtF1FWaEqfuY=;
 b=FL4Md9y6qdW+eyNcFQUVHxjD7RCRmFFi3zaw9xSUJ3izvArJ8DZKzAjIzBuTOkEyvYdnpfFFz45LR54Q2m7g9S15ps7xQbgU4XGFW0XX5pSs0LFgMO1ziZn7bil8qfy2i6KjpS7XZex5CkZWUlx/Tikd3eypG0wtX6XG24R/WQZRukz6cfLJyDYe1rLuAGxB5Ahh7IO6ee2/Sx6lN1TyPuU8Ivr5phb9InpYuj3i5Eo8jcEUrK+62Ha5kWmyHi0+IRdSVFLGLaMKuU+N5OlVO1KGwfBWaDinVEgpZLSBh9R94orjB/JwL4AYf8QbVKgu2f6O0oHaWwvexePAlHZMMA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJWeL/pc9Da2uztSw7o+mXJDEhb/54xQtF1FWaEqfuY=;
 b=K1B/gYWkSrttwz+qHeZOeey7Hqfd4U72Jp9TwQqPz5023hfJJ3Oy78VpmjNbR/kyC1EAukLjFTJd0Q9j6iWmCC3s9/0JGWsHt4ftcHoCSBhgFq45NrLD1f6QBx1MfQeWOjpEoJk2sXmSLnXexgpQCqpI9rXGFRdXIK0AgyQ2Img=
Received: from DU6P191CA0040.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::15)
 by AM9PR08MB6705.eurprd08.prod.outlook.com (2603:10a6:20b:300::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:14:56 +0000
Received: from DB1PEPF000509E9.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::ab) by DU6P191CA0040.outlook.office365.com
 (2603:10a6:10:53f::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E9.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48
 via Frontend Transport; Mon, 27 Apr 2026 16:14:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GhM45k8zI3OXw0w6cSxTJ2wJDgp/bOxW3jL1wj56v4N00kKZnnr73LGQBsRIfWV0TqWjFbO5RnKcndQ/fRDsWI4zTD5Pb3v8uUSWw/zD1SlJayOJpRIeq68sMHlAhMdLzKf5uQq1EX79KSeGsB7Tb7cXI33JJRWwFSrX5q3px/ybSYRMjIcnSz7Xvo+L82aWLw04vho/efhNPKqDKShWUwZ71AXw9EGLQUGoPTfgybPFl2LpxhWh/de4vOWTcMfzI8Gw/iYp9XlVARsgcgZtZDvwzDi1Uo5JFNnXCMbS4x8ctFlOTbZzrQ/j8O1S/Js+03Cv/8IFKPoCbcaPZ+VIsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJWeL/pc9Da2uztSw7o+mXJDEhb/54xQtF1FWaEqfuY=;
 b=qgE4cMtMKeq3DgBk5smej9KEUnEc3OhxcVW3o1mwGWYm083SFNSNh+8dVC5W9CdYR7b5yrOQ2GgOEnRc4dlNDhtpEwzz3DmMWxpH23wWycLrqYyjELMQKt9B1/bPo040e9IcksK9nS4IxFwait/10KV5m5T5yR76ZgVo+NZwfnN0ySzOMgSazr2hFmQy/MLC9gUgyGp0DusBmufJC9K5n/GjkQiR1HlfSt8itzEX487oaBHZF4XB6a5CEgjUOr+hfJsVOtqwrc+2U5lFk+Q2cPfLdILHx180wHuFlti91UXlD6rcbSxSCrkDo25r6DcGgX0sEHVxC7RsG8oXDqPbaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJWeL/pc9Da2uztSw7o+mXJDEhb/54xQtF1FWaEqfuY=;
 b=K1B/gYWkSrttwz+qHeZOeey7Hqfd4U72Jp9TwQqPz5023hfJJ3Oy78VpmjNbR/kyC1EAukLjFTJd0Q9j6iWmCC3s9/0JGWsHt4ftcHoCSBhgFq45NrLD1f6QBx1MfQeWOjpEoJk2sXmSLnXexgpQCqpI9rXGFRdXIK0AgyQ2Img=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:13:53 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:13:53 +0000
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
Subject: [PATCH 23/43] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable
 state
Thread-Topic: [PATCH 23/43] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Index: AQHc1mDXS7dsmiad6UeP1cAqPFH1ag==
Date: Mon, 27 Apr 2026 16:13:53 +0000
Message-ID: <20260427160547.3129448-24-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|DB1PEPF000509E9:EE_|AM9PR08MB6705:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d73f26d-f368-4fea-2a0b-08dea4781f9f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 IVKPxGxi91BHBzDmmmcIOZOO5hM6wtD8+NqKouei4tgzitXW2DYAftxIu1v8TptW3njIEtAZgxSIKRmEcj2nnDDVLXYU2VaAtsoDFfYb4nntgkbIPtnTh9UJJfpURQYgNsY/sU7eBqqpBR7/cnkW138/vBLzrTTxyrnpCsGGnhvhwwujWfkAKWx/S7OVJhoeGj0umAIZWYEbQmJ6zO6M3wZnDjP1QCe5itbP1+ISE0DLpwmuUpjXaJELQMKh88cI04UIEGy8wW9tulM+hRqtimZlxxjjvGFc9HBjsTXIOKRqXZCesXOU2KrUP0CWIYdCzr2kKX3TYpZ5joz2dDRRscJ+MhVx8C83qiOn8izsbeM9x2HFIhoC3eLXAe8roUU7iYBC2+cGncIb5x6zepEAeASZpjqXbXzxlAFj9XbYAjLEoKW7xcx8Me3SgEBGwM+7JnR41Y8OCfJAurpTXG/AAbK4Obs7mIz6djP3B9uV++J1p6milZD2AU+rnCc+JZ3So7o8WahmJesoidOoD037QSwtcmKvEJ5AhziC0kKOSFTbhCzPU5246ZJWt6UF581btWcs1CHIjS9BGJdVhVlGQ3ETnnPKvx3WwFjmRJ4e7T54mjyQU8xQtlrrlkOxZfJtY2UKe9Aw3Z5UJXg/atp5OodGOYgEeoxMnsJoBuXBJqzyJGmfo4284PgR2D2GwkR3dfQuF7j+/C6wco2xdV8lRetCotsvs4qYEz9xBFnmqVqE6Zofrti8ui0PH9Vjd8QqFRz7O/+f1CT6V4gJnApR6mykVvLoS857q/KeFAnYKfc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XIp7dpxHLc6uwWTL0ERftEKUimuiAYE8+rgdr3GB7gocQNdDQxZaUEsecTqOZp78Juv6fdv8ybxLAkTrvUxlSYzqL17vm73043ZeufCfoX+lOmBSnGWM1f5giQHQMsdXrWZ9TM4jjv+2V2eRrXF2hvlwEy0A8daKvti3CnlF6xmB2tJV6OqK52kMbxiiXApCgPbT2lSQX44f91kHUoYVRCMbQYBXFq13tfPDPL4krT1c8rtISaRmeZAhL3WK7jukKaHWK2+Lfrvlb3EGBPFWEp8ZKpX1tPT3jxyUliApzhb0hR/kHHTWvBeC68eaCnsy+Us6mKHYMRuT81NlJsj9fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d4aae2cf-9d18-465f-bdcd-08dea477fa25
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|82310400026|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NQ31PoETtXBt/h81A7XAjy4Rlgvr2cPGSlSzziJgWGKeMFEuOGn8zYap968x81Dvir0Ia+WRQ689HpygkIwzEE52RL8CWcJHO1ar8nTS+iwEK7hDumb9EN+YC2zramzAR+WRawM7zFKYc9GDtaTp0CKmwqEMdgkGL8ewRnvxNctOLgwwXR/1HMM+xC1pHxNxxZcMDtxwIE159VJLUKJQwQ1/pfpVgi4oMR2aqIqW2M30L6QnVH4d6/buRjHRaftCLCXz3LGD+RTkJ9kHpPieN0AU8WH4CjoVm6ewEp465QTtlluOsWToun4u9SRJ3ngeu/0TR4AQrIHVktJ6jXRdpJgCFa8RlhmPFn2xCVSFg1L0GapbXSr8FFmpsS2PbDqjGpOd2+7iEoEBNdYLfDdKARbFY0Okln60z6Y1BMbzG9bUhUZK1B5h9+SLJnHPbMxST2bQJxfBIhZJnuudBM95x5TE/GuqTAmSuzWYyQTX3yyXD+A8ejgZKu6kFYTQbk9620yJCF5J8UQ3SV3566l3yLqYT2G5BMHNFAx4Ae3TqgRF4KQcE4vBOZSfcWOuy46cBK1tpX0jUHZJ4HaUlyEZMAq84WxhiGT5Yqy6+rbocxORkiR6zaT/3OzYDR/jvpaqm36LMt22t9+7LsqjAuF5HxuNe0G7+9u0qmwlNEoLlb/qOTtpIudfJEXdCs/EjK+hzj3LFkU3WOnz/AxHUW2qnpXbopcOy6Rgo28DepMcznlyzwl1drmqUkVP+Dq8XYHQUXrfMVic2w+3R5X6NHDPjA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(82310400026)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	u/ca6JLMyY5Tld7ReBBzue56kkSg37AejHAeEEOfCJ7z/DKi3kAIN/D07+Gdfq5bxnccQ8xgvufk2GhQAOaRKx445F8pvqaUpRu6lC9VZyL95q538kTmnF1GeVbOT99cviLCAjKX5fKayR9giLGHqCuCVAj4CscrwSuKRX577nOz/gMLutcYF5ds+lOZNUt/yw9FmJ3DCKtiMj8tijUQ8BOyR0g7k6BobSyb1HZ/5KG1VIDMNKp+NEvhiwZ9FVf7UzfoD4oBRV6PXUo5fV44usDm+qzOdiDW9WUyawPiBgBcn5X6WS+DRIre6D5VNnSc9u5sUFqvsmGL6MrLu7CpwdmlFw1zqPk9G2i5hOk6cjUchZ/lPKhsKn5oxA4DsbIuWlpZK6yVSGYclrtyYoq13PlrUijt0zaBpaTXHlYQGdt5eX9CKbxzK2pRQilF3fkl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:14:56.5761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d73f26d-f368-4fea-2a0b-08dea4781f9f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6705

The GICv5 ICH_CONTEXTR_EL2 has the IRICHPPIDIS field, which allows the
hypervisor to enable/disable the HPPI selection for SPIs and
LPIs. This can be used to emulate the guest enabling/disabling the
IRS. Therefore, make the state of this controlled by the IRS enable
state. Thus, SPIs and LPIs can't be delivered to the guest, until it
enables the emulated IRS, which matches the behaviour of the real
hardware.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 48ffcb2494db3..f12e96bc5fa21 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1191,6 +1191,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
=20
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
+	bool irichppidis =3D !vcpu->kvm->arch.vgic.vgic_v5_irs_data->enabled;
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
 	u16 vpe =3D vgic_v5_vpe_id(vcpu);
@@ -1207,6 +1208,7 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
=20
--=20
2.34.1
