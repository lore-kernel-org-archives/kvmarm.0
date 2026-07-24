Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011063.outbound.protection.outlook.com [52.101.70.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1351B3B42C1
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890517; cv=fail; b=ZEmuuGzYK2g3gvDK7Sw/cS22LkRNaRMbyevSR5AXedLGiX4QJkReGVI0pGmspmP58PQbZ+glGle20NPmIgfPMLPHcOTWwvzAqA46WVIViVZOOG7o14/OpWF7Jg6HBdIRkkzL8UXgjV8JlVna91wr/HIrn49I02OJAXEIIAf44+I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890517; c=relaxed/simple;
	bh=U/+xBT/PV6L3pC+VlJ4QF1sjfjKPIe2/8A9QhEQM6PY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bSBGOVd3qAJVF54TCH1z7BBhbxaVUng2jhb1uELkxQp5gtWkUn1tfAQ9HukAqGIL4I1ywb3SgoJ9D6RBhp/eJvk/fe3o2mX4cLoqXmTO+2QBVTA0zi5bphbU0yw6iK5ukf9wpB1vOEI+kqQQXqUreKNGbgd38fu3W4albNmHIBU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oC+epoBd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oC+epoBd; arc=fail smtp.client-ip=52.101.70.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oC+epoBd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oC+epoBd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sUKCIU5oHJSEjqPtWpzIsRiGu9HJbsPphsdRLufnGTIeSJCOiABVk3lDyqMQh/4eTsMnlRc4g+NanDrMixqknT5PA4FbREiJbWnhfpmGlFjFV9XRbQO3nxvRNTrvz2sd2Nzd3UlXDFKI80IiSXzabaFK28Po8ZiyU8eX9qW1FrCaq4EPGfYvtfeDiHr/mbGCe1VzbvT2VKFgh0tQpcgmIBuA7NowsCxlMIUfKiksonYiE7QV+DW1DUiRK2ABkbNrlTCRL7f4E4cqOpxOLvyiwmhTbLIPLpOA8mkq/M1hN8ujb8v7qfZXPfOxi3lw6NNN598LMVh6C25gw+I7J5A5lw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWXR4qEpgcOhAaglgD9ufhaX1bmRsaw9qPPbCe13KBc=;
 b=yGc4phfB4MnGYH66A86V8gyT31P8UdpJ0WI8t+6At4/2Fjjt9NGkdOwN9OfDfoctieGa/2yT2bIvHpOFutUBMEo3+A3wbKd3TXxoUDjBA2CwVICZo/HAnJ1Bl3yW7+0XY0gTtHqdFMtBqjixyhVjEafE5bTa0xjOvxRD2d+pcba5DD+d7Cx5HHXCSXrS5tSD3C1qSNxm5xGkr6k5dr0wDu8I5A8P/K1Rb/A1S5b/4UQZc/oj91cDIaqEdq+yr71BzVMrG9CkvChdZN1aBTkLFDkL82/xg8Tp1E77EHBeGPZ+kFvkBZtQI9g6NK6BD+ELUYa9UsodxebGPcx5hcVqAA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWXR4qEpgcOhAaglgD9ufhaX1bmRsaw9qPPbCe13KBc=;
 b=oC+epoBddi9iswfVy2q0opApiGhIBuraZAiToMTqgKHd6/gi1nJRqe+lUui/kXsf2wEb/C9vI+hOjlVx5H+oAgr/0r5tpRtZf2RMy0JM6LOf6/9qtawClEf50TxR3xFmFQGVFyQrZZt6h46JSDc0Cj5IYbn4FNmclh7fJdwv9Yk=
Received: from DB8PR04CA0015.eurprd04.prod.outlook.com (2603:10a6:10:110::25)
 by DB4PR08MB7959.eurprd08.prod.outlook.com (2603:10a6:10:38e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:55:09 +0000
Received: from DB1PEPF000509E6.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::1b) by DB8PR04CA0015.outlook.office365.com
 (2603:10a6:10:110::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:55:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E6.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Fri, 24 Jul 2026 10:55:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L934RGZW0L4zscVm36bEnJ+9o2QUpT8T3FBD6HZvMnu5Vcy3SwEmmQ/yCjJdasLi+ubC5pM1G5zEtd1VZXbrlmkZWxjI87a8FgTMbIW+dYxCpZcT8SzZU8kvWtwsZX0gtaD8HZl+ps1La7ctgnqLan3ZnaJulSMcAxnsJTzh4QIg/DfdypaAtOZnGCWa15crpy/qrYXuW+BTq2wdEn4sO0V8/xk9zXY/5u1GPGtTyOIxD5fjM5WAYPiTjaBrnxdKRGupD6UQduYdp3MBZvRLE3s+zKxLPKDZVpTqb9GJXF7pxRY5TFnPDFEtET3+TDgD5fwlPeMf06VrUKdr7T8uFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWXR4qEpgcOhAaglgD9ufhaX1bmRsaw9qPPbCe13KBc=;
 b=pNmGxa0CJIyTn3ht/SEZQoOZDv3XGlCNNSWiZOCCcxR7L4JAfjd1Fg7W+YHDmiPh0sk/IgzXhn8A+xYSeqbC4DIA54nrenogi3xqhbXSRhtmXT14ZYgMgGGw8ftgLE4icZZpzMSpMCCIjwAsXSzmcWsRUQUzQ8+bIyxNQ54SshUC5UgIV4a8YZe29SFFLbEsWkHwNdCA0B9HsJyzTWTcl0Pmk2VwLpzeo/tv94NdevqXDjm4og3k7D2uiWZtMPfwbiT2inMs41s60UDbA7N5vndO70KjGWouNPJtVTN9nZTk5PEoi/P/aSo7KfZ1xxKl3Tbp4TJ6iswkSN7XxlcuGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWXR4qEpgcOhAaglgD9ufhaX1bmRsaw9qPPbCe13KBc=;
 b=oC+epoBddi9iswfVy2q0opApiGhIBuraZAiToMTqgKHd6/gi1nJRqe+lUui/kXsf2wEb/C9vI+hOjlVx5H+oAgr/0r5tpRtZf2RMy0JM6LOf6/9qtawClEf50TxR3xFmFQGVFyQrZZt6h46JSDc0Cj5IYbn4FNmclh7fJdwv9Yk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:54:06 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:54:04 +0000
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
Subject: [PATCH v4 22/48] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v4 22/48] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHdG1q+qpbeSOrkREKmE8gEsg+CKA==
Date: Fri, 24 Jul 2026 10:54:04 +0000
Message-ID: <20260724104819.1296803-23-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|DB1PEPF000509E6:EE_|DB4PR08MB7959:EE_
X-MS-Office365-Filtering-Correlation-Id: c5bc84fb-8fb5-4e68-ce5d-08dee9720778
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 vnyF5mgPuFMvE4ggJ7SWp2rfJrpNzjb5YlYfaf2dCu+KbSMlHcD1ZvK+LL0mcBW68bkrj+ZaYcJ4mD94LCX4TXGEWFcABOlOa+1LNMN9u3V8kSQ06yowknaM/WpFRHlM+szopc4Iwa4YLCKUCzGsxk4hc99QzfwfqF0b0Rh5JYBG13d+Tfiatrw7DoODg8mtl9lVKX5u5eGK7aC/ihhc+Zsqv6dE/hN/3Y/ckLg2jjHKzyjU3hvrum6y9i50yoK2P8lkf5w5p5PLLtdlqwVlj7dJPrlIjxng7zoZzF0I0WkyDxIBlU8oT9sJVUAKv5mVsvu8OcnepfsAucmgB/ajYSpo9Mpf8pB4uzzNvuwIXVXwCvSY1a4FDoEgZPGtcuQGf5v3rE2EKn7gPgZrGRXJ2v/Yxn8l//67fu337Q1x6FC+7Ph05WYE7w0g3GxmO5v+/aiYJG3udza6WdAEcvEMwTLrw2lODeXZTYKpQb/zWPNeIEAgL5glzUJYptGv7ZbPDuhdYzYkxYXSq/Cky25p2w8HA56+8lvVgi2XM6PXQNeZGYD7voN1d+wpKz4pox8kftOhhATEd5O/N+gLmDn/pak2F+Jwvr/EPYV1kxptPXfoGds2mtnDmKMlHW79zb0i0gpFNaL7Xf179yWxkavi4V0SAypDlbwuo/Qkenq85mxtFK1V+UdU1Q9PeHgAnDFy/3HhHF6MKO/7tLWVKSvBTXNGo79mwfG0/ryQVTRoKJM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gIsXnG3psUMkfZ7gW+xVyGVLDwxoR4pGpV0ycasWXuOVlWB8QNfHcAr8UX1EX3RU5xGDwwKpco1MjGakFJszwVlJB7/snygoF9JTWLX/C00HGrAk6jX0Dluwk85SPOdG/oCqICVsq5UKIbYEF5+FCrbhNkPsa5FfrIPRZ+Z9yzBVUMgqvXPHQSnY2OmZ+xfoSm+6ZqklF9H7jmxAqXze27GbZYe8zROG8Ur2m0Cl9iUoz36j8CBb6CznCpTSfUL+ugPQLHTbz1oBi7hAWlkfmS/+nKT7H9Uk6JVGT4RqHNXmkc7nBlS2jUki/kfFNgW32OT4SBVZLE4/U8qFZxh05w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9cc1be37-9585-42a8-5cb6-08dee971e0df
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|14060799003|1800799024|23010399003|35042699022|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TZOdH1WTGy75gTvfdCmgp88dpYQ+9RUk1Puk7zQEuebMblVPbVzU5hBCK1bbmCFPK7i8FvcTjoyE3kLCfwbN8N5HI0ANYR9LHlG/m0X8LPBTMrNNbsFyrlPt7CX+diHt+1Q45fmmA5sivw7u1drIBcMFZyB7rGUt56FHWspizAXFofI/xYYerWCyLATyNEZnJ9Jlu6HsMR8S6G3M+AVGQXkgeIB7AGLoGISctm/LGYKguGxqsZ5BQuer0Nzyf2UQdB+hAC/v1cIX/OTSvicDuQD8/wGsP0B0dcgeWg+e9oitgO2f+Isnf4/a4D9dPdoNSvFmYx2Xp2uy73MUe/LqmIbi+iCH1m4GnfY2jZRFPbaF6dF7sm8zsnRXEAdaUE63VqUUMYU5LpRV86rnd2uoapbTipGvqmTlLDs7hxzXX7Qqz+wCV8Xi6eXbVKz1YXwo2CE15j946e5u5Owt8T2uqqhlIXsa9uH/1GQQBOkpTGPCx0jIh4wx6lSlJPJg4abwbQujtn5Jnav/T1/49joNHr/d4hkuxquD7Yi5EHZdhvF51U7fRHk9uW1pqdehTFzY+TgCBuOKk7Ha5QqZub4zLuUhan48cT/S3JFBeMx4wrZigXPMdeAMILEXWHYiXkIX9Nuc2keKE8M8sgWlIVYHQr03i0BIVH6WrUp8T47UlsXa6eNdLpylZw9mTtXVYirRyjdpAq6B6AehiDw0KDiU+Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(14060799003)(1800799024)(23010399003)(35042699022)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w3yKwkNjBjNHpBoyHfGThRBwLo0u5TrbVw4hTa2wJbXHuE4TaGT4skXkFDqs0mok6z3eBFfceLi2ILAPQajqa0rQjQw8uzg3kPW7xypI9LVPlvqEbe8qyzXixaUsmaUnLjI/iyvmRerk4axtBSM2wZ+jdG9pOxSLE5owXB0sfwBEXWZm0ALJbTXaFBrWakkraEMLBaGD5L/zokHgeZ0t9COeGs7hslFelVUTZ8c4l1zbysS6EwTJRydFMB/GXkCfp8HAbzvdt91w+XlpJzKfv//zOoNNy495KYZnaDrmQXjEULCVKmuLggP2f0MRTp3PwDsMF8mqn5WWV03G2TtIdMp2B+uPzyRfTHp44VyUaGudua81/m0fDPezCfnsR+3Rv6qILedkX4yjWa5kUjf7bJ8+5PPFDkST17O+IOGCOpnaWl9/WbzJ0VWB46Wp/uam
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:55:09.2950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5bc84fb-8fb5-4e68-ce5d-08dee9720778
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB7959

Now that we have an emulated IRS, it needs to be registered, which
ensures that guest accesses to the MMIO regions handled by the device
are handled appropriately in KVM. Therefore, as part of
vgic_map_resources, the GICv5 IRS IODEV is registered. If the address
for the IRS is not provided, bail out reporting an error - this is not
a supported config.

As part of this change, expose setting the address of the emulated IRS
via KVM_VGIC_V5_ADDR_TYPE_IRS to userspace. Also allow userspace to set
the number of SPIs handled by the emulated GICv5 implementation, using a
GICv5-specific SPI count rather than the legacy total interrupt count.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  18 ++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 106 ++++++++++++++++++--------
 include/kvm/arm_vgic.h                |   1 +
 3 files changed, 91 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index aa883507d00d1..8a38d91528774 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -657,9 +657,8 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
-	bool needs_dist =3D true;
 	enum vgic_type type;
-	gpa_t dist_base;
+	gpa_t dist_base, irs_base;
 	int ret =3D 0;
=20
 	if (likely(smp_load_acquire(&dist->ready)))
@@ -682,13 +681,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	} else {
 		ret =3D vgic_v5_map_resources(kvm);
 		type =3D VGIC_V5;
-		needs_dist =3D false;
 	}
=20
 	if (ret)
 		goto out;
=20
-	if (needs_dist) {
+	if (type !=3D VGIC_V5) {
 		dist_base =3D dist->vgic_dist_base;
 		mutex_unlock(&kvm->arch.config_lock);
=20
@@ -698,7 +696,19 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 			goto out_slots;
 		}
 	} else {
+		irs_base =3D dist->vgic_v5_irs_data->vgic_v5_irs_base;
 		mutex_unlock(&kvm->arch.config_lock);
+
+		if (IS_VGIC_ADDR_UNDEF(irs_base)) {
+			ret =3D -ENXIO;
+			goto out_slots;
+		}
+
+		ret =3D vgic_v5_register_irs_iodev(kvm, irs_base);
+		if (ret) {
+			kvm_err("Unable to register VGIC IRS MMIO regions\n");
+			goto out_slots;
+		}
 	}
=20
 	smp_store_release(&dist->ready, true);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 90be99443df3b..8c2c6886af4e3 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -181,6 +181,14 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_d=
evice_attr *attr, bool wri
 		addr |=3D (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
 		goto out;
 	}
+	case KVM_VGIC_V5_ADDR_TYPE_IRS:
+		r =3D vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V5);
+		if (r)
+			break;
+		addr_ptr =3D &vgic->vgic_v5_irs_data->vgic_v5_irs_base;
+		alignment =3D SZ_64K;
+		size =3D KVM_VGIC_V5_IRS_SIZE;
+		break;
 	default:
 		r =3D -ENODEV;
 	}
@@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *de=
v,
 		if (get_user(val, uaddr))
 			return -EFAULT;
=20
-		/*
-		 * We require:
-		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
-		 * - at most 1024 interrupts
-		 * - a multiple of 32 interrupts
-		 */
-		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
-		    val > VGIC_MAX_RESERVED ||
-		    (val & 31))
-			return -EINVAL;
+		if (!vgic_is_v5(dev->kvm)) {
+			/*
+			 * We require:
+			 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
+			 * - at most 1024 interrupts
+			 * - a multiple of 32 interrupts
+			 */
+			if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
+			    val > VGIC_MAX_RESERVED || (val & 31))
+				return -EINVAL;
=20
-		mutex_lock(&dev->kvm->arch.config_lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
=20
-		/*
-		 * Either userspace has already configured NR_IRQS or
-		 * the vgic has already been initialized and vgic_init()
-		 * supplied a default amount of SPIs.
-		 */
-		if (dev->kvm->arch.vgic.nr_spis)
-			ret =3D -EBUSY;
-		else
-			dev->kvm->arch.vgic.nr_spis =3D
-				val - VGIC_NR_PRIVATE_IRQS;
+			/*
+			 * Either userspace has already configured NR_IRQS or
+			 * the vgic has already been initialized and vgic_init()
+			 * supplied a default amount of SPIs.
+			 */
+			if (dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D
+					val - VGIC_NR_PRIVATE_IRQS;
=20
-		mutex_unlock(&dev->kvm->arch.config_lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		} else {
+			/*
+			 * GICv5 reports a number of SPIs, not a total number of
+			 * interrupts. Require a multiple of 32 SPIs.
+			 */
+			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
+			    val > VGIC_V5_MAX_NR_SPIS ||
+			    (val & 31))
+				return -EINVAL;
+
+			mutex_lock(&dev->kvm->arch.config_lock);
+			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D val;
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		}
=20
 		return ret;
 	}
@@ -299,9 +324,14 @@ static int vgic_get_common_attr(struct kvm_device *dev=
,
 		return (r =3D=3D -ENODEV) ? -ENXIO : r;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr =3D (u32 __user *)(long)attr->addr;
-
-		r =3D put_user(dev->kvm->arch.vgic.nr_spis +
-			     VGIC_NR_PRIVATE_IRQS, uaddr);
+		/* Older GICs */
+		if (!vgic_is_v5(dev->kvm)) {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis +
+					     VGIC_NR_PRIVATE_IRQS,
+				     uaddr);
+		} else {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis, uaddr);
+		}
 		break;
 	}
 	}
@@ -748,21 +778,25 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_set_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
=20
+	return vgic_set_common_attr(dev, attr);
 }
=20
 static int vgic_v5_get_attr(struct kvm_device *dev,
@@ -770,21 +804,26 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_get_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
+
+	return vgic_get_common_attr(dev, attr);
 }
=20
 static int vgic_v5_has_attr(struct kvm_device *dev,
@@ -792,15 +831,22 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V5_ADDR_TYPE_IRS:
+			return 0;
+		}
+		return -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return 0;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 		default:
 			return -ENXIO;
 		}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 143e75743da86..af926f9384b65 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -41,6 +41,7 @@
  */
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
+#define VGIC_V5_MAX_NR_SPIS	BIT(16)
=20
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
--=20
2.34.1
