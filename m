Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011025.outbound.protection.outlook.com [52.101.65.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B553CAE76
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.25
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890347; cv=fail; b=tNCYQdZBYeiCTqAHvoOO9YPdGLeVXRzIUDx6HHcWZp4dTP5wgZyee1e2oq3N4YM/usPs4ZfUFiug7HfMmU5hYWowhQ1zwP6HrwTEahCoBs4aa8DgDmstOjvQz7SX9+ysP+7ex/r4hGj+9Surgxo2XO6c2syWgsfoD/w4WUh3q/8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890347; c=relaxed/simple;
	bh=DABgwSc74Guq0o3jtctIaqZTgRNXsevPxzB4h9VYk8c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M9jzSin0jqwdwB3/vOt46Xh7DZ/RZvSxom3rgGbynRHqW4rrAMGol50E0Lqrlpaef43eW3RU+Az7pr8Pw1YH0QlcmqPw+hiemoWu8w2F1om13X9L+HJJQkOTdfk5kNBuBE3W5aRw3BUaqVzNXrF3DKres4EXsqr7qzM83BlWwKw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jpVt8miB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jpVt8miB; arc=fail smtp.client-ip=52.101.65.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jpVt8miB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jpVt8miB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SDjE34yMP9K6ikS9j49c4/MpANoDSvkIE6Fs4/eUgI+DXA4UKlXFaHlLWXxLVyUNOoIfVu8f3Iz7NUlWqHVv3X5zwza/1EzYsd9EjjtJyedEBlzT/a3FZkb9rSFMLexGFcTEHOsZnZw/YUsMmBqetw757nbXQ9bwSQvHGJkhaI3XxWQxIGRjRohCnOk+01ZehZKMU8YLN621qeidOGXRsw171mmQsjBFnSvbwOvuZMB1wvy40UXCbz5yWT3BbWLh+WCBlQTOkV1liY0f+93V+ZJ7Bi72CzCS0t7eCcA85tExM3g6xvE0O76RyFI9MgfiV/n9FJCJw7e/J8KHBW3PWQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUQeS2D3cWWsZzLSbT2oyyz6xstxCHgodrlMIQXdkYA=;
 b=Q53BwdV7Ih9uJXG/7Z6BoFsfd7tT3CewIa3hHXtN/ag4sXTc87QcDPPD5j6iy+YGFTJuiIDqIc/O4oiGyLaGbmDJeIyOF1h8H7fJAGYBUpEdSHHFJ6CFtVH6zJkGbkzIuH53XifaN9b2GatkRI1OqokroDETOlLWXEjpv3fHTDWCy0cNRolX9LVt0ylTw3CAIETUBAobnNSafRTUagUXssLkFCWwy0Tan0eOZdEaG9kLb20qAeXVgCNQDC0Ox6BsAGSD4bj5kH20m3XfZrr6h7NSYltgeBGqEVkNXxqO4rzAPzcgBm+6wTP/NwTr/sC1uE66cEq+Us/sFkpiB1XYaQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUQeS2D3cWWsZzLSbT2oyyz6xstxCHgodrlMIQXdkYA=;
 b=jpVt8miBpZ+xneL1eNct7TZyIzwont2Ysm1N9hv9Dn3KrcwYc5vsaezJ7Otvy2pUWBzAniBMJl336/qCIOQzLcoUrIFvjJ0c/bVAFmawa49IAZI4KlZFYoOS7X9dmpCHjgz4GroADAgG7YXlHY/P2s00/qodmwkJHb3RqyXOuFA=
Received: from DU2PR04CA0330.eurprd04.prod.outlook.com (2603:10a6:10:2b5::35)
 by VI0PR08MB10826.eurprd08.prod.outlook.com (2603:10a6:800:202::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:52:18 +0000
Received: from DB1PEPF00039232.eurprd03.prod.outlook.com
 (2603:10a6:10:2b5:cafe::70) by DU2PR04CA0330.outlook.office365.com
 (2603:10a6:10:2b5::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:52:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039232.mail.protection.outlook.com (10.167.8.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:52:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qa7Z0XXPh5nwRZg47DrVc4tVtmor6r7geOp6DIAXcqiRlgWfz1qfOuw+PlEdS+s9hLDPV8w+maKcgS1Vx8tNO3xnbozqSm37iOZ0xz4/vfHeg4C/GrDwAWLUWGs1GPUQUnWIRDUUtHOsuet6As9NR8rt+i46SSM2+1P0YP0i9QcebpfINh2Wiyaohm8g3KMJI8azCDB/72jtCpeAikxBFBdOxPit3IEuaVOwALU4gABx2qboPQeOeC38GxpNnlBYNwsSlR3AYKJVNGKRzVml9ugbqzLwm9qklZGNIVH5BeQE6wwcBcz2HT6WHPMPDZKVurNQbXUyBiWsyL6adv6XoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUQeS2D3cWWsZzLSbT2oyyz6xstxCHgodrlMIQXdkYA=;
 b=jBANpHE7xtBGS+rc19+gFnqTGZu2YFvexYQ6YHWP4IKb5c9n0IlcAMhSeosk8trqMEjVeRC4an4bjKJpQp87OwjxQUPvzjF+gFv/M7kZQ5B05ykKXS41GR+iTrPbQiiSAOFErEqBov/I6NgoJzZUi3I4c7zgy3yMTqs77FPS1wmdrSN5fxfY7y2M934AT41Gp9uOocvb3G3ZrxbCwLaXVpFRK7p4ybsL18i+TEyd5q5I7Z2+hjtVK1440xfNHMhMpa1xYthh9dRtTQzc4Pe0LhSsWvefLNAtOJtI85EX6pHfB7eUUeIN6k+ecG38hHasFFuuaMTX6p7diKCNY1DUYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUQeS2D3cWWsZzLSbT2oyyz6xstxCHgodrlMIQXdkYA=;
 b=jpVt8miBpZ+xneL1eNct7TZyIzwont2Ysm1N9hv9Dn3KrcwYc5vsaezJ7Otvy2pUWBzAniBMJl336/qCIOQzLcoUrIFvjJ0c/bVAFmawa49IAZI4KlZFYoOS7X9dmpCHjgz4GroADAgG7YXlHY/P2s00/qodmwkJHb3RqyXOuFA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:51:14 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:51:14 +0000
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
Subject: [PATCH v4 11/48] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
Thread-Topic: [PATCH v4 11/48] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Index: AQHdG1pZtRGjrVc+HkGAEf1erd01SQ==
Date: Fri, 24 Jul 2026 10:51:14 +0000
Message-ID: <20260724104819.1296803-12-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|DB1PEPF00039232:EE_|VI0PR08MB10826:EE_
X-MS-Office365-Filtering-Correlation-Id: da5835df-832a-492b-a85a-08dee971a135
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 B/NA1bVGkdgyDm376kj/R4p1K/I9Wsv+0RzZTuf96XycizZpnJopQWi2T8lJ90aDhrnX1HKEEWBQb+ltY6W2Vo1Irjq0IFyRi4djF/kgCV5fkbhl+adAsi//qRWC1kmAJmjMUkCVW/4+j+zYgz170Aa7y0HdRX0dvYp+48lzUpY8tVDr8XaCaqpFNarxUp7b10r8jxXcnMNwDcLTTLMy9BWlVqKyEGD8gYR8eeByA2Aj6PfevamFFjnP+ijo3TFzOzdmZLKEWUt6I/M+N99KKLgiMqO62sdhIl9nNZqdBhcIztMoZiTQv7X9SQKXMEE521EdpXbi6UkZlWBkOKQtvY2uMxbFTjsd940Q9+daF13D68WgV1jK03Azkz0vG491ipHBScP5LRbJqjqv7GnMVi5oSyjtkLmbizgkM1NoB04nBteJaJ/PdeBFrnJda2xNxiWYv2J5upH/1GYF6li/7CfGr+CWQlZwZ6UtC8VwINDFkRhv1pstD51xAjNNZuFX3qoftQJmPkvKOAeCKbA8/mg2Po4Hif0WmuhWTiBjKtGKy12OpQNvIUxloX0iAUL2QAsZjShRs1h8WL2YoWgNV6rbytcXUxddH9Kv0pFX6LLBNm+aednFuiYcoUITwN3kY/qfLmgAXuPLUfxP5C8tC8ATr9JtFCfdoOeyjbiE0sF8ciIpfBleSEaD16dx9ekfeU24OPE6eeBcDYV9ZSPRjyvV/GcGKW6TVmSuIdMKXL8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TvSm+tefCirq2+HEPgYbMlrgzgEG22onYIhVzj8/uSPZ5Z32+v3pPA+9v/BivneI1C8qYvCsQ+TkN5wIbcWwBZ9uZjt+j2tJSWH+u0X9yKXs0terCmS0ZSsqj6eby4VTOQARiCVjTgVZ1sIVZz2qQQVf5uzc1CI7D8+SBzMKPUnwUt3REiHT/+A1DoVh+sxVuCFFYlsgZYQpFqiMpRJWKSjDp7Bat2cvALzr7d7CapXlhk9ymMYyh/XoXfgpXT6b37GQHth2N4jW5wrVY/y/tBEj4826x0qAtDdQbxUOG8O3xc49GobyftpM0M5dar03VBKrXyWjzXY3rHajb6lS0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3a18e9de-bace-42e0-9791-08dee9717ba3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|35042699022|14060799003|376014|1800799024|3023799007|10067099003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JrRG3Odw1gzULQICwBoTMftqjIoC3Yw4XntiT6ljHhqb0V0alfqyZRTFTKzpPWX1s6q7OLiD9ic9zWZNk7AVbwwPIpfkKS9/8ttPnbuoJL5/mUxhLmOP+zvKK7cqrE/gQQZpiGbezQoY6qiqdajYOVf0IJ40g6JW2Orws/VcfJ/LHuJQA4/K947cK8eUnJnCC2U4WztWeIZioJberQSHcxEjh12boQnvVy6lMAavpqRvZld/gggWGtzN0erMG8bYw35KZh4CvqjPMhS8P/6GedsGkJyh0ubFsSt9EaX8vmrtWYrgcI8fWfhdRpmlNPubdFzLFFsYDrWT/mDZgNTs2ws/cj/psWTQmV3DnYq0AyXQ1lFiChK2BF8Lgu6kzTLO2RwdZFrCQaq1Wn/gGXC/pz+5N4fn+YYhTX4/Ets0Y7kF1xrDpfM35pfz9+QzVPSpGLS/iJT/zfBLwXgIEmuO00CP95OXpOS2Khs2JjoKg16ZH3+xBg/mzqfvRgP6uHtH06TkHtplo5VP+CaKeAq/kI0h5mfFO+sxs9US7rAcT2uP9vI0/aYDTWoqfi37eYXmiSWUA7N9ghsKenLwZEVR91yC8y+z3NEiZGT1zk89DJMXz4nZn9eQ32yr1sJgbt72tvp5X0yP6Dx3W3sSAJsZayij+YDdr9axaSeteV1JedO+OM1NBDYtqMUjz3F4j7l6bEenOceOktG4qwYLlsfu4A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(35042699022)(14060799003)(376014)(1800799024)(3023799007)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ho03bIgzhefLRD3VvMvz6oYh7HrJoerOW9hyP8qdp7k4Bxyp7L46LuYfBcCb3D8NN2O+7x9KE398T4jk/JehRz4rVG1DLqWlGg2T0pGwbPYJbyNVoxesdRBg7ePq0zJeCM0KvLUWC4iAuKhaXy68/VBTAVtyaASgb4MmqkMQyhgflQw3Vo+zwLgDyMAwBuzzYZp/SbaSpWN8UcMWf4CL4/DeASF8oPgD9wL4Y6MbHMOcyG5t4oTjt0nUvZTX7B/NXcZL/oEH/ujlbe6W0F+ES8e3jwxPZknC4WpPcGWx5mKNk1DnXAeJpHWIAZZoz/7GwvwkS4ROIei83Lg/MArnmmiZSRN50y2zbNPHORORMtIhlfYFfrNLKMLmZHCzsN7F60KoE96slAuY10xgJ002e6I3PRt5djyserkd2Ai+qWdNsrZsRtrPjM5eWFLaSTPG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:52:17.7285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da5835df-832a-492b-a85a-08dee971a135
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039232.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10826

GICv5 has rules about which fields of a VMTE (or L1 VMT) may be
directly written by the host once the table is valid. This ensures
that no stale state is cached by the hardware, and provides a clear
interface for making VMs, ISTs, etc, valid.

The hypervisor is responsible for populating the VMTE for a
VM. However, it is not permitted to write the Valid bit (as the VM
table is already valid). Instead, the VM is made valid via an IRS MMIO
Op. The same applies to the ISTs - they must be made valid via the
host IRS.

This commit adds support for:

* Making level 1 VMTs valid (only), allowing for dynamic level 2 array
  allocation.
* Making VMTEs (VMs) valid or invalid
* Making SPI/LPI ISTs valid or invalid for a specific VM

As part of this commit, the following vcpu_affinity-based commands are
plumbed in:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE (and hence VM) valid
        VMTE_MAKE_INVALID - Make a single VMTE (and hence VM) invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

Note: the lack of SPI_VIST_MAKE_INVALID is intentional.

When successfully probing for a GICv5, the VMT is allocated, and is
made valid via the IRS's MMIO interface. Treat failures while
allocating or assigning the VMT as hard GICv5 probe failures. At that
point the IRS VM table state is a prerequisite for vGICv5 operation,
and falling back to the legacy path would leave the host without a
valid GICv5 VM table setup.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  53 +++++---
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic-v5.c        | 195 ++++++++++++++++++++++++++-
 3 files changed, 225 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index aa737972f525c..d5e7923a03359 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -67,6 +67,21 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VMTEL2_LPI_SECTION	2
 #define GICV5_VMTEL2_SPI_SECTION	3
=20
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -502,25 +517,6 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
-/*
- * The following set of forward declarations makes the code layout a *litt=
le*
- * clearer as it lets us keep the IST-related code together.
- */
-static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
-				    unsigned int id_bits,
-				    unsigned int istsz);
-static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
-				unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
-				 unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
-					   unsigned int id_bits,
-					   unsigned int istsz,
-					   unsigned int l2_split);
-static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_spi_ist_free(struct kvm *kvm);
-
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -672,6 +668,18 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
 	return 0;
 }
=20
+phys_addr_t vgic_v5_get_vmt_base(void)
+{
+	phys_addr_t vmt_base;
+
+	if (!vmt_info->two_level)
+		vmt_base =3D virt_to_phys(vmt_info->linear.vmt_base);
+	else
+		vmt_base =3D virt_to_phys(vmt_info->l2.vmt_base);
+
+	return vmt_base;
+}
+
 /*
  * Assign an already allocated IST to the VM by populating the fields in t=
he
  * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
@@ -730,8 +738,13 @@ static int vgic_v5_vmte_assign_ist(struct kvm *kvm, ph=
ys_addr_t ist_base,
 	/* Finally, mark the entry as valid */
 	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
 	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+	if (ret) {
+		WRITE_ONCE(vmte->val[section], 0ULL);
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		return ret;
+	}
=20
-	return ret;
+	return 0;
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index d0b743e8d957a..6b159a7e386cf 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -82,6 +82,7 @@ static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
=20
 int vgic_v5_vmt_allocate(unsigned int max_vpes);
 int vgic_v5_vmt_free(void);
+phys_addr_t vgic_v5_get_vmt_base(void);
=20
 int vgic_v5_allocate_vm_id(struct kvm *kvm);
 void vgic_v5_release_vm_id(struct kvm *kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 7d5a948ab972d..c68ca4f63f3a2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -10,10 +10,14 @@
 #include <linux/irqdomain.h>
=20
 #include "vgic.h"
+#include "vgic-v5-tables.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
 #define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits, phys_addr=
_t vmt_base);
+static int vgic_v5_irs_clear_vmt(void);
+
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
  * ones are, and generate a mask.
@@ -36,11 +40,32 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+/*
+ * The IRS MMIO interface is shared between all VMs, so make sure we don't=
 do
+ * anything stupid!
+ */
+static DEFINE_RAW_SPINLOCK(global_irs_lock);
+
 static u32 irs_readl_relaxed(const u32 reg_offset)
 {
 	return readl_relaxed(irs_caps.irs_base + reg_offset);
 }
=20
+static void irs_writel_relaxed(const u32 val, const u32 reg_offset)
+{
+	writel_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
+static u64 irs_readq_relaxed(const u32 reg_offset)
+{
+	return readq_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void irs_writeq_relaxed(const u64 val, const u32 reg_offset)
+{
+	writeq_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
 static void vgic_v5_irs_extract_vm_caps(const struct gic_kvm_info *info)
 {
 	u64 idr;
@@ -85,6 +110,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -105,13 +131,55 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	vgic_v5_irs_extract_vm_caps(info);
 	vgic_v5_get_implemented_ppis();
=20
+	/*
+	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
+	 * can't use them all.
+	 */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
+						  VGIC_V5_MAX_CPUS);
+
+	/*
+	 * GICv5 requires a set of tables to be allocated in order to manage
+	 * VMs. We allocate them in advance here, which alas means that we
+	 * already have to make a decisions regarding the maximum number of VMs
+	 * we want to run. For now, we match the maximum number offered by the
+	 * hardware, but this might not be a wise choice in the long term.
+	 */
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	if (ret) {
+		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * We've now allocated the VM table, but the host's IRS doesn't know
+	 * about it yet. Provide the base address of the VMT to the IRS, as well
+	 * as the number of ID bits that it covers and the structure used
+	 * (linear/two-level).
+	 */
+	ret =3D vgic_v5_irs_assign_vmt(irs_caps.two_level_vmt_support,
+				     ilog2(irs_caps.max_vms),
+				     vgic_v5_get_vmt_base());
+	if (ret) {
+		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 suppo=
rt\n");
+		if (!vgic_v5_irs_clear_vmt())
+			vgic_v5_vmt_free();
+		return -ENODEV;
+	}
+
 	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
 						  VGIC_V5_MAX_CPUS);
=20
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
-		goto skip_v5;
+		/*
+		 * Don't free the VMT itself if the hardware still has a valid
+		 * pointer to it.
+		 */
+		if (!vgic_v5_irs_clear_vmt())
+			vgic_v5_vmt_free();
+		return -ENODEV;
 	}
=20
 	v5_registered =3D true;
@@ -138,12 +206,13 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (ret) {
 		kvm_err("Cannot register GICv3-legacy KVM device.\n");
-		return ret;
+		/* vGICv5 should still work */
+		return v5_registered ? 0 : ret;
 	}
=20
 	/* We potentially limit the max VCPUs further than we need to here */
 	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  VGIC_V5_MAX_CPUS);
+						  kvm_vgic_global_state.max_gic_vcpus);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
@@ -153,18 +222,136 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VMT_BASER, IRS_VMAP_L2_VM=
TR,
+ * IRS_VMAP_VMR, IRS_VMAP_VPER, IRS_VMAP_VISTR, IRS_VMAP_L2_VISTR.
+ */
+static int vgic_v5_irs_wait_for_vm_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VMT_STATUSR,
+					GICV5_IRS_VMT_STATUSR_IDLE,
+					NULL);
+}
+
+static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
+{
+	int ret;
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	irs_writeq_relaxed(val, offset);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits,
+				  phys_addr_t vmt_base)
+{
+	u64 vmt_baser;
+	u32 vmt_cfgr;
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
+	if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
+		return -EBUSY;
+
+	vmt_cfgr =3D FIELD_PREP(GICV5_IRS_VMT_CFGR_VM_ID_BITS, vm_id_bits);
+	if (two_level)
+		vmt_cfgr |=3D FIELD_PREP(GICV5_IRS_VMT_CFGR_STRUCTURE,
+				       GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL);
+
+	irs_writel_relaxed(vmt_cfgr, GICV5_IRS_VMT_CFGR);
+
+	/* The base address is intentionally only masked and not shifted */
+	vmt_baser =3D FIELD_PREP(GICV5_IRS_VMT_BASER_VALID, true) |
+		    (vmt_base & GICV5_IRS_VMT_BASER_ADDR);
+	irs_writeq_relaxed(vmt_baser, GICV5_IRS_VMT_BASER);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_clear_vmt(void)
+{
+	return vgic_v5_irs_write_vm_mmio_reg(0, GICV5_IRS_VMT_BASER);
+}
+
+static int vgic_v5_irs_vmap_l2_vmt(u16 vm_id)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_L2_VMTR_VM_ID, vm_id) |
+		GICV5_IRS_VMAP_L2_VMTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_L2_VMTR);
+}
+
+static int __vgic_v5_irs_vmap_vm(u16 vm_id, bool unmap)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VMR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VMR_U, unmap) |
+		GICV5_IRS_VMAP_VMR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VMR);
+}
+
+static int vgic_v5_irs_set_vm_valid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, false);
+}
+
+static int vgic_v5_irs_set_vm_invalid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, true);
+}
+
+static int __vgic_v5_irs_update_vist_validity(u16 vm_id, bool spi_ist, boo=
l unmap)
+{
+	u8 type =3D spi_ist ? 0b011 : 0b010;
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VISTR_TYPE, type) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_U, unmap) |
+		GICV5_IRS_VMAP_VISTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VISTR);
+}
+
+static int vgic_v5_irs_set_vist_valid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, false);
+}
+
+/*
+ * LPI ISTs can be invalidated explicitly. SPI ISTs are invalidated by mak=
ing
+ * the VMTE invalid during teardown.
+ */
+static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
+	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
=20
 	switch (*cmd) {
 	case VMT_L2_MAP:
+		return vgic_v5_irs_vmap_l2_vmt(vm->vm_id);
 	case VMTE_MAKE_VALID:
+		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
+		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
 	case SPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, false);
 	case LPI_VIST_MAKE_INVALID:
-		/* Not yet implemented */
+		return vgic_v5_irs_set_vist_invalid(vm->vm_id, false);
 	default:
 		return -EINVAL;
 	}
--=20
2.34.1
