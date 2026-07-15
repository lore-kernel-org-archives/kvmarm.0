Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013063.outbound.protection.outlook.com [40.107.159.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA5542BC2C;
	Wed, 15 Jul 2026 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784134709; cv=fail; b=hfwMimwYubaunLqmGG7AnK7NnFZrd0jS+egPKz3jU2ORkUw37u42R7FNdvpbHVwbPh0q5vaWkxcensuzgv9Aau+XceFxfpq3SGV1XEP9+enH3fpfbTE6rM5K8GKK9hClrCftG3FvdFlkQUzNJ2h0M+NA80A3nYJ/Wh4tUzxoFYA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784134709; c=relaxed/simple;
	bh=vPQU29krihSz7BWWSRImrot54GLNS9y+y3gSN3GmbGc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q/mwDHEWnGPpi3UXrwdQ+PQA7ArbgZ3PSxMLqxTmxHq+iqvH9cq86fgDFNyxh9BJXT0jn07bQs5tNCewnNzZJG0HU3S2VvGsRQFJRt04Mi1A/kvBxD0J4SHOJzP+mXLNv7pCXhbWBvdDzq50e9yPHnYDI11Fg0yJix1xjmQqsfg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rOc3ozSw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rOc3ozSw; arc=fail smtp.client-ip=40.107.159.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rOc3ozSw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rOc3ozSw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IJ7ngLUVnWgvimLobcFL07oFiZgOvjki4qOFGtYpJlfOO7wXxgxbBkeOSmKA/yQh0ZGaF3lIq3rtFPRtyIS7fwqB6hNLr5WMwX4QV0f2/CaoKeX/RxFiIl4B4OP1aHT1AefKAQrb1bTEoz+Ix8W1oZzWWzOfYaauKkQklxAwLvjQ7nytHJGoHPWCryUGnI9S98obIfBArqSlvOyXitDxl0XOqEq/8BxY1NWngxsWjeO1pGdacklkuwqODuDnQbACGKTRVBRMs9xKDfKVb1KJMF4hk7TDkmfuNNGFyDE1vdrYuccKHzJblQ/cHdp+9PmULMpxaxNdNVA1czlFkF+Xng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPQU29krihSz7BWWSRImrot54GLNS9y+y3gSN3GmbGc=;
 b=W6I8oga+syai1mNpDUWYOWuMxJ9WGZBqQXMTMJjyjpZoNJDMNEjvs9CYKhmpBzlJWvzBcsYJOVKv/LhgbuZmyJqDhrDuxGhJJn9c1xEwhS9XAlvR6JhmhFM3+Rjtid8BLMbnYAArlrN3j93Ua+xzLzgn04q7dMF1dsbG9AJb6YRpVZvUordmu+QBaJa+8W+Yb78Hgak7js7kLVHtCgD0s3UcgiQBaAishC1McWYdeuwW08hAshsQpmTv2ZU2hT5WsVuZmaCSE9t2o8DC7v9gqPGZVDEczcN1No6Pd7u/Fl1IlYnIIfqCayJoSZVhqAa6xf79yzWGKuGBIph0Du8MzQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPQU29krihSz7BWWSRImrot54GLNS9y+y3gSN3GmbGc=;
 b=rOc3ozSwPkScN7A7vKw8Qta5LfbNG98KgoZr5qv+UnEj7/74Ebw7aX1UGGINi9Qbm5G96+sfYmHC45uc0DzLv0zmWan88Ym+4q1xiNgV/rti7kUwEoY/S03YL0T74Sbrovhw49Vxeil/tbjjCkv0hbcOA7ntQis/YEltwJBEIrc=
Received: from AS4PR09CA0030.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::20)
 by PR3PR08MB5833.eurprd08.prod.outlook.com (2603:10a6:102:81::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 16:58:20 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::37) by AS4PR09CA0030.outlook.office365.com
 (2603:10a6:20b:5d4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.11 via Frontend Transport; Wed,
 15 Jul 2026 16:58:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Wed, 15 Jul 2026 16:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lK1M0s58s7w/3W9VIT/kTw4OaYezePJ627J7QCs1wAaFL8bHfHaCz1DYFPZChrhzCYI54VruhawPGMWukwTW4j4Fztmhdtzyxhf0+65Oh+jb9Rcl6xAwhv+RX7jwiIkl2tpYcZyhSSv7qLseSffBZCN5Fx0P0BsDdUF7CqXHqzIvr8NXMdy/G4pRhShli6SfClmaLOPsR+Qp2mVaoscdfbbvI+JCWyFGI3OwhYFNtR5ERrZ0tTRSrwbXxr4XxiBlXVg8xTP68nOkECFiZz/aFdA7lL+paW6kghUHJoxAe0iBqoYaLjrv7K+03/+SeGnN4dsp8UrFQsxTFlrNQnKk/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPQU29krihSz7BWWSRImrot54GLNS9y+y3gSN3GmbGc=;
 b=vsegUzk/PjPbR8v1cdDq1zjN92ORtQCo9ErUY1HovYhrV6dPdrVx+HMzczWIjL7cPfvQQI8CgFyFaGF3kawjVSleFy0BJjhZzIH/NTf7ubf0xtHpgNkjJzvBAb0uMLTdoZNUKsWqBBrtBvynf9BMPYhXy+ID81SzpzPJkGiV4ulc84GOK9DYwljDzcMDSNzelTx2SHF8LDTGPJQMcFHjkir387/b2C8hqTs5NugcQNx04v3emltm8FvlNNCJ+Sce6ojgw27CfruuglKEFHrj1xHa797DAiQ6WrdYlEaPnOq5GjAUVRSDy35cV/IR5xDWeF4cwlVwUmoBVSSvyWNPCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPQU29krihSz7BWWSRImrot54GLNS9y+y3gSN3GmbGc=;
 b=rOc3ozSwPkScN7A7vKw8Qta5LfbNG98KgoZr5qv+UnEj7/74Ebw7aX1UGGINi9Qbm5G96+sfYmHC45uc0DzLv0zmWan88Ym+4q1xiNgV/rti7kUwEoY/S03YL0T74Sbrovhw49Vxeil/tbjjCkv0hbcOA7ntQis/YEltwJBEIrc=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS8PR08MB8395.eurprd08.prod.outlook.com (2603:10a6:20b:567::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 16:57:17 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:57:17 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 40/40] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Topic: [PATCH v3 40/40] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Index: AQHdCwaGWZyp/UYhi06QbTc/qwOUHLZb/UWAgBLiqYA=
Date: Wed, 15 Jul 2026 16:57:17 +0000
Message-ID: <2d7ed2b8f1eaaca7f27d1e19aa56841f62711606.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-41-sascha.bischoff@arm.com>
	 <20260703163321.8A4391F000E9@smtp.kernel.org>
In-Reply-To: <20260703163321.8A4391F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS8PR08MB8395:EE_|AM4PEPF00027A69:EE_|PR3PR08MB5833:EE_
X-MS-Office365-Filtering-Correlation-Id: 8797b2f5-56b4-4862-5a0d-08dee292464c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|4143699003|56012099006|5023799004|11063799006|10067099003|3023799007|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 ZV6hKe+ZI6/4dl9s6zSr79x9rO9OC/s2xaBJA3iG0G2trpYwaDi30wy/hSD70R7QpKBcvuyfSl0of1xF0PRKlOAvluKJWWPJE73x7BnPvRjL6O2HLci/uLbkQ3XlyLhzx/1fUC5Jsdip9gmUrOms7n8uLJHDdEYE9vp8t2f8BG7r6FddjilNRD5LhNh+89cJ9VV/uTEBKCmB28Tbm2xt4AeAsVHSr/OZic0okl1IA836Is4g7G1CKzFLoqWPRPk037VhEkzHLtTELGSMyIHfzc6fhyeoN3qPdnnmWqsXifj/zqNRmjIJKXF2w/fp/IA0JU8QWRGFRD7k4SINrCN7LnJbfeSE1nT5f0WdPynYkwFboUPEdZVGma4W4fEZn5dxppxZYWhJVkK6Qrr1epkxcc5lQ6Rch6qRlRZ1yOgrltjmcZVnDNJ7txnFNEb6X5qY6tQkwwbHpJd/SMt5uW9NjCUelQ4FqMYhsu3AnBiZzedwZtWCxtzn4OcTt5ZwafEtSMYFS9BRwE310aoP1+wVkozsxbB9IakXN8bjcOMedmj6c1VQFQX3k9VLDpIvCQt0ARWVrap7Ikc/cE47vbnQL9kwx07condvjwHYjGlxneq7/SHnTFdnP1+pndpyI2CXZRXL9hNqdln/YMu67bIRqqO1lzEBwycou11rvlc1EjKTH2lJOQzQH1B81eUJZqu8gNzk4Yd19spraeYeq4uyCukuVi0X8h1qrE0rAVOokgg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(4143699003)(56012099006)(5023799004)(11063799006)(10067099003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AF9F3CD3DE44B45AC730899FD6A490E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 l5gCxAcKqYRj0YXe8DAnecChcGfAlLfM3YJcFEE7Lk9HagtFlgWTBO1S10K1v3XDf3zcZeLlbVbt8iQmyGBllblMTVxZm1ivt4Xs4cjUlaOPSOX4NCazE5QwnV8JBMm6/sVylXqfWcY8AEhpKG35zBR2N9NZ26d8/uKZUdT8xm2GhKw1SJhyoanJpA374INWTTFHdeg8cwWI0M+uun26EgiaoisDLFvQeRyFbtYeAGpMgLYzWqm9bcCXBObYGdBMacM8Gjmyplx/gs+CipYsm7L5GcLeDkXNcIzNzfPpGb9gP6zXkjuJF6sLFGdLFdhetPstXVhmG4B9Gjm804kdyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8395
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d7daa4f1-b9d1-4902-cedf-08dee29220d7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|14060799003|1800799024|23010399003|35042699022|5023799004|11063799006|56012099006|10067099003|4143699003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BbPIkwnult/D1rVX+inEuO0vHLBztvCQhn9jyL0gaWN3KU7dhNPbiY72TH9+lXTOm/Ff0uqYXod89n1yjplk4IrQhbk4Ed2k0V7UA7ANu2/hqpzp/XAklOpK1rq3YxhaylXTKzoq7U8+aOxKYAZhafS7da4CJW9hl24JtRz5HHVEtpUXyjtxuZOSQjaJ9lhona1J7rgqRSgMJ8n+DIyHrysK+iU9/oPOUWVAQk6s7ntVZ84BXDYr9z4kTEjN1+PgnGnxkYq3ajWqiuM7FsyInT+Bv+Yu7BR36x24ArEDJPmKlSnqQvFiRqBx6BAdOrPjnopVnXZpHS2NWRq4zu0P7/r4K+At7ocnmblSDXmbSKTOUR3qDtMMCGS0CbRscOsDgQsj1Q3y0RdAkQI4BZnpn2/coKc3C6Ir1IdtUXErGjMTQurJpg07MErOsaTgS64LQhuEz37CKZeSZ1XoqJNmCwhGrLFMn/DvnkVleGhibBVwPfpFStofBdSIdk9yuVHNFiuG2+D0+VjM98qp+MJWE+H9W6C+6UjTiZ5kky5wbf8k2XKrjK/+J+gyJ5VrtEwhgVgM2zCUXLQdRkZiONss4yqVch8XHF+XmPpq7q9vn81lBdr9cbq458x4Shurg6HugT/LDcmzdLOVVin3eDCydtNwMCQgU45ewYHnY0nt0Dnkob026BYWOIIu/qjcU8Flc0fnGbJDlj7emr+M2UKBXw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(14060799003)(1800799024)(23010399003)(35042699022)(5023799004)(11063799006)(56012099006)(10067099003)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TGcK7JWArnfJ5F0xF0A31YQum3/Tod+cqgFOfS6kBtiL5MNpk/oZkQ+fpAdCls1tjhb+d4wMVH95ZhbZaxZwD7Cr8rNvOhBHrSeVPjtMo+ukloQzPTUsetM91Id+zh2yofd8+5TOqpGuGtb/+ii6JtHRSSf32hEbvOk+wqzcsZoFrlHxvbUqqKnpUoYdEDE+a4xdDJRtxTCyutC3LFljZzdzqAwXfzeaEtmmbl9Nafamigl2v7OfkYH/2JSoqQdXT9HhB2SYtJR4fvQIt1LY+AO8aLnLYXdEA4F3t9buLk42jON6nJDUcMZiksgL3s2WJFtSI67Dp4Y2sdT1k6BdBB+qvjcT74hf8WEPwea+nOvYgn/1Q73xmnwHYZrqYoU0aa6hah+aIMvTNH/jO2UDDfRMpq2TyHr5py4aj/92Tr9lbl6AoDQpUJWESQsKitcH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:58:20.4804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8797b2f5-56b4-4862-5a0d-08dee292464c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5833

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjMzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBDcnVjaWFsIE1NSU8gcmVnaXN0ZXIgcmVzdG9yZSBvcmRlcmluZyBjb25zdHJhaW50cw0K
PiBkZXRhaWxlZCBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgYXJlIG9taXR0ZWQgZnJvbSB0aGUgYWRk
ZWQNCj4gZG9jdW1lbnRhdGlvbiwgd2hpY2ggY2FuIGxlYWQgdG8gZmFpbGVkIGd1ZXN0IHJlc3Rv
cmF0aW9uLg0KPiAtLQ0KPiANCj4gY29tbWl0IDc5ZDhiYzBkYjRiY2NiMGY5N2FiNjg3ZTUyOGU1
NmIwNDU1ZjdhZTMNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBh
cm0uY29tPg0KPiANCj4gRG9jdW1lbnRhdGlvbjogS1ZNOiBBZGQgdGhlIFZHSUN2NSBJUlMgc2F2
ZS9yZXN0b3JlIHNlcXVlbmNlcw0KPiANCj4gVGhpcyBjb21taXQgZG9jdW1lbnRzIHRoZSByZXF1
aXJlZCBzZXF1ZW5jZXMgZm9yIHNhdmluZyBhbmQgcmVzdG9yaW5nDQo+IHRoZSBzdGF0ZSBvZiB0
aGUgdmlydHVhbCBHSUN2NSBJUlMgdG8gYXZvaWQgZmFpbHVyZXMgd2hlbiByZXN0b3JpbmcgYQ0K
PiBndWVzdC4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2
aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNl
cy9hcm0tdmdpYy12NS5yc3QNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2Rldmlj
ZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZp
Y2VzL2FybS12Z2ljLXY1LnJzdA0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArSVJTIFJlc3RvcmUg
U2VxdWVuY2U6DQo+ID4gKy0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICsNCj4gPiArVGhlIGZv
bGxvd2luZyBvcmRlcmluZyBtdXN0IGJlIGZvbGxvd2VkIHdoZW4gcmVzdG9yaW5nIHRoZSB2aXJ0
dWFsDQo+ID4gR0lDdjUgYW5kDQo+ID4gK0lSUzoNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gK2Up
IFJlc3RvcmUgZ3Vlc3QgbWVtb3J5Lg0KPiA+ICtmKSBSZXN0b3JlIHRoZSBJUlMgTU1JTyByZWdp
c3RlciBzdGF0ZSBieSBpc3N1aW5nDQo+ID4gS1ZNX1NFVF9ERVZJQ0VfQVRUUiBvbg0KPiA+ICvC
oMKgIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19SRUdTLiBLVk0gdXNlcyB0aGUgcmVzdG9yZWQN
Cj4gPiBJUlNfSVNUX0NGR1IgYW5kDQo+ID4gK8KgwqAgSVJTX0lTVF9CQVNFUiBzdGF0ZSB0byBh
bGxvY2F0ZSB0aGUgTFBJIElTVCBkdXJpbmcgdGhlDQo+ID4gZm9sbG93aW5nIHN0ZXAuDQo+ID4g
K2cpIFJlc3RvcmUgdGhlIElTVHMgYnkgaXNzdWluZyBLVk1fU0VUX0RFVklDRV9BVFRSIG9uDQo+
IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gVGhlIGNvbW1pdCBtZXNzYWdlIG5vdGVzIHRoYXQg
SVJTX0lEeCByZWdpc3RlcnMgbXVzdCBiZSByZXN0b3JlZA0KPiBmaXJzdCwNCj4gYW5kIHRoYXQg
SVJTX0lTVF9DRkdSIG11c3QgYmUgcmVzdG9yZWQgcHJpb3IgdG8gSVJTX0lTVF9CQVNFUi4gU2hv
dWxkDQo+IHRoZXNlDQo+IGludHJhLWdyb3VwIG9yZGVyaW5nIGNvbnN0cmFpbnRzIGJlIGV4cGxp
Y2l0bHkgbWVudGlvbmVkIGluIHN0ZXAgZj8NCj4gDQo+IFdpdGhvdXQgdGhlc2UgY29uc3RyYWlu
dHMgZG9jdW1lbnRlZCBoZXJlLCB1c2Vyc3BhY2UgaW1wbGVtZW50ZXJzDQo+IG1pZ2h0DQo+IHJl
c3RvcmUgdGhlIE1NSU8gcmVnaXN0ZXJzIGluIGFuIGFyYml0cmFyeSBvciBhZGRyZXNzLXNlcXVl
bnRpYWwNCj4gb3JkZXIsDQo+IHdoaWNoIHRoZSBjb21taXQgbWVzc2FnZSBzdGF0ZXMgd2lsbCBh
bG1vc3QgY2VydGFpbmx5IGZhaWwgdG8gcmVzdG9yZQ0KPiBhIGd1ZXN0DQo+IGNhcGFibGUgb2Yg
aGFuZGxpbmcgaW50ZXJydXB0cyBjb3JyZWN0bHkuDQo+IA0KDQpJJ3ZlIGNsZWFuZWQgdXAgdGhp
cyBkb2N1bWVudGF0aW9uIGEgbGl0dGxlIHRvIG1ha2UgdGhlIGNvbnN0cmFpbnRzDQpjbGVhciwg
c28gaXQgc2hvdWxkIGJlIGNsZWFyZXIgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KVGhhbmtzLA0K
U2FzY2hhDQo=
