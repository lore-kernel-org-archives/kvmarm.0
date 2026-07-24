Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013026.outbound.protection.outlook.com [52.101.72.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BE741DE15
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890376; cv=fail; b=bDMvO+sv6gH7fo7IPATmgwDGF581VvVi1ll0QRb7BSRicn6q8u/rZQK7nRRHn4/gvE/Jr16OT+nUSDhzqSyo1v7MQa5NdlkAKFfh14Otu0jqnSxvwzwZ49pUMWh47Bh5Gaul+lCqdyt85h8HuW/qxOmhOmruJyyjdqy0IiDRLXk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890376; c=relaxed/simple;
	bh=sDM7+o72tF2vjz+YMAOLu29HStPrZUlKy0Rc5Mi0rqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AnKGw6DpIrB1/wFn3I9PfyOulkueOsjT429uIvsuSkatFyLTSVkCMWMQ1nWzgt8sdbby/sk3/tP2ttLFhon4/uSTRtBbkZHBztvZu0m6MQQDHhImWp2TCLdWQuZNqwMlOOTavw9PvX0GI0uBNIzFmdlEtXox0R7d6WpVapohdKQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aYgXpkfe; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aYgXpkfe; arc=fail smtp.client-ip=52.101.72.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aYgXpkfe";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aYgXpkfe"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ku0cBxmE3rL6RGW4eI0vvxyWaTc5OuMKFNvPI/WixQSss5c8V8D+zoCX9LmyQp6P/4ivWUB7b6uGyPae9FI3LBN0di7byb5uwtzn2KBwE5EbQHKs2G1iQ2hg69leZtblcHNsgJL3IHB6bajO34Mwpg9DqO/UiDEguMVwP8LEKa8lXI3FzrRmbIn5C4T/QPdeM+JwcK+9VgS4ppjqbbCqz7gfDxEGpP4kS8HNNgVXsWk6442h7N1nRSKpbVIv2Y2ZOd9GYsTu/5Lm86QlxrqgUhDU18WwnbmZtOlt4ifmAkK6QC0Z8xe3s7pOYI+G3hin+fjgAfwkWtWmhjO+8Phq3w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DyGaHh2EhMlxY6YwurC0I0JwG87er0D0EyCH4wRKH2U=;
 b=q3ySfh9CvIopqRHgqHN+q8cdAiXfW0jvxM8p4xmb7TQYCZXHpJIZf+WsZI/ckTsZ+bseAeS+JlQYZMBbJeHkKlFD/XsYLzUg1ZDXBq1cCw4hHSAjfezEHIMY18X2RkNC46w+WBnUVpxQ2NlFSR14PiNsHrOAvA3wT0fL+eFKD8Uk4ei6Ia4aY/Cudu/erOE88DT0thrpnhhrlcsL8gobosrltXOEkXqRb8BKn96gG+v5iNmwZ6yQeT0h4SPGOsdJuSE0G8JxAil/8WuF5iSD/nv1OL2Yal6Xk9WHsRVavNns63EYX4ItXVRgx5uOtWUiVreAoZ1t6T9e8Ii8mz64KA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyGaHh2EhMlxY6YwurC0I0JwG87er0D0EyCH4wRKH2U=;
 b=aYgXpkfeCiAUupW1lQdhAR1OX0l4/A/VKieW6ijmd5cSvUcLkkgXd+/alNrd32iP+kxNtTo4dvdp/d1HFGuspNeerk4lL6DqA3VGB/nxB9jDTfgqfDnwjOdDCztoPNvT65FOE01SGAcbhFzLLiaCpxiYqAarMJbByLuW+mEhpL4=
Received: from DU2PR04CA0307.eurprd04.prod.outlook.com (2603:10a6:10:2b5::12)
 by GV1PR08MB10792.eurprd08.prod.outlook.com (2603:10a6:150:160::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:52:48 +0000
Received: from DB5PEPF00014B9C.eurprd02.prod.outlook.com
 (2603:10a6:10:2b5:cafe::74) by DU2PR04CA0307.outlook.office365.com
 (2603:10a6:10:2b5::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:52:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9C.mail.protection.outlook.com (10.167.8.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:52:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aNguQ2GS/IpHUALB1x9McRfInrNqD27gB0JeMOFNoAlZ54LUaWHe9ikIDTU+395DZ2s2SDib02+yJTKWnOekDNXzYAlXPBLBAOYMqSffk30NswttSY0DJ+E/Qc4NlpGimWC9cKeMmCcGFX94fcsVx6qzuUFCm59juge2PRj9WemP8IY9hZjIU5E8agg0gZeO2sRP3cj5jVLM2EVxrpZt8HEiTjuccqBEmq2Fm0yydG+87GBNWV+n+UAEeJhwLDmIbd0NY/LJ/jvG7Dhoxt4eXuu4xxcdXfc/O5olkhXTwo+yomUF/IZa7zBXh8uEjJIrjznFZs81Vgg4YRemqNLCGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DyGaHh2EhMlxY6YwurC0I0JwG87er0D0EyCH4wRKH2U=;
 b=xb2nHgesM2l38I+m5JzxR81XFOTipr0RfIFXcbYVa/LmsL2wDuQ8Uo9f+BwJRYSCkwFt27vF9Ak5iL9ZQ8WOJISiWMMWzhT8oP82DznXmfzlltYvbGg46iraSDVifoxgLLmKYSdd7/UHPDjVVETUhUsQUtoasCC0aJTfl7N7hMkG+eaRfZVfHb50K4QWm4swq3w4jN53fWxKp41CuM20/8AZcUPo6dezepAGOdJfMJ2CcudbHQgt0mtYLuPyUn1rEFon25G3Os3jffejsdFGZ7O/hfah98WsV7VCEILLXqrfdYsYCM6peI55oOBwQGHysVMvq/prKX6MryK3REAOPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyGaHh2EhMlxY6YwurC0I0JwG87er0D0EyCH4wRKH2U=;
 b=aYgXpkfeCiAUupW1lQdhAR1OX0l4/A/VKieW6ijmd5cSvUcLkkgXd+/alNrd32iP+kxNtTo4dvdp/d1HFGuspNeerk4lL6DqA3VGB/nxB9jDTfgqfDnwjOdDCztoPNvT65FOE01SGAcbhFzLLiaCpxiYqAarMJbByLuW+mEhpL4=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:51:45 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:51:45 +0000
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
Subject: [PATCH v4 13/48] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH v4 13/48] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHdG1prTfwW7SxZLEyhzC0oDYFuRg==
Date: Fri, 24 Jul 2026 10:51:45 +0000
Message-ID: <20260724104819.1296803-14-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|DB5PEPF00014B9C:EE_|GV1PR08MB10792:EE_
X-MS-Office365-Filtering-Correlation-Id: 51a36604-d66c-46ff-dcb9-08dee971b397
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 0v1yu3eKEk004nHpXi67f+nk8OvflEW3yDGz4UXvPJfwvYdJXVFdHJ7f8kx89FHNArKzHIYDkC/SoypWhgRaprmm/xqw00uQhwcOCPIrnlx4AAVqQeIXjZZKG5jN7oeXdvhy4j8TtxcwTJs2BdCtRjJcoC01yyZRreKgQq+AqeCenNa6V5oYZ6GSPaU0XVC20WbfYPxeb7sUTPO6nGuKH5wheGEOKFeIXeksTZASEhW9EfG4YZA6aYQlKD05svh5fS4yfFDDGfGhUNEjA/xC17Vf92f1axMnunqpdC3jdrzg/5LWfU8/5gjtCaywsFVeOH0WnDT2lAcshWnVqHhRaofcyb16mqJ0cKxnCk1LtDKR712U2HN8IC+69O42ezO9EGVb07NFVHVa1ksIl/5w2nCkbH+VmmMZqxH0JNF+eLBmEqvIpeFlb1dMcg1g+5nc1oEQOH6bd0YJI/qLyhZszeMYOVK5VEzWDf1QQa9UXAR4HEY4wXnaZfyN9jogVuJvucDONEwdZ9imygTKyQ5opSCyT1rf9ls2c75iDLbgADF0r0edpEKQU2mZ/VB7BB5jspTDtTyZUXii8F8XBph6B8Mt/v92T8G2GrbY0Q/rIZvTt3hTYIMFYFuzr414JnNykdPceHAiq5vKg6oCxOi3gfGeJ/K/PeK79YYMKc9Db+LUWwYdH2ofIaaqjw2rS++RM/v3sc3U1GcH0RXQrOhr4n1gAe/HWcbrQXykv0o/DqA=
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
 KwctWlDhDUz9gLj5HNMggd7phHlP3viDXjLXdVao/ZRXGQ7QoHkdXzbRRrUkOUDTkTCgiCH4BGlEbLXV3h4XjbhMNRigY5g5mVQlLT4xBDddwe52OaXm1onVEdpb6wIMB/8qfRJkVlNCToqqnEAaBC+5BJ36FGYhlmYakcixgr8bgPgdbQelSV2M18dqNMWFAarGetLOignC9tJdWj/DtPlS3n+ZhovUpjxvMWXVchHRW40mcO7rSaVXUZ6KZd/Y0saA4jacblHzR63JhiGMmlpDifEbV5otF+0/tNn1t+ow5qC3uly+0kI3XdPS5BGdRoz3Uk3jrFdFWbKh7xm4QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5afcd5d9-b67f-4fa5-8418-08dee9718df7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|1800799024|23010399003|376014|82310400026|35042699022|3023799007|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pa3bbf93tBSY7wiZ+6EFxcbIdaNcwoni9V8zjmzExg+c5PmEG6bjUZ74m7y02VglTtlIbP101SpMMUZPhWQ0AxXyNBg52bpQNXVYmEz991a3epiqiqL3wtlk8VKkkatFJiWoe1fJ32K4CmudIdbTIwegcQY+1oZs8+WUzYOZrq5uk0+8EQ4GRL5RulnOex6lVotQe7EfcdBTBJb+Kjy6QOZNhgKAkRYc2ueZhX+Uc1zgABPpPPTa3YX0aiaxBUM8k+tL4Rqw4SssP4NZEwUN7av7Cb69F/HBILAudSwpwsXLuO0ZzfM5sMTsbtR/huu9SK4w+Nn5hEz1N5wQuiAd5xO1aUmQSaBgVSJSvbVXcUCN0O6iBW96zaK6M9RYDMzkhuHyMFfXCCynqbRyBPUVJt5QLTWInOI9OWUCSeMo9nA9wJaCmTA5RoHHUitvYinTkyOoUvAXGXn1To30li1JHch+7Aur4MqXY8WNA/yRFPNnooobZwSrhWUwBZRZH0OMKoAyW+lMcClDO1j6xfY1Wxv+593LqZtJfZ/YN/gMGU7a+CvZtOAKFWrTPiAt3pS4i93kJBWDu/kYzZQ/5WfY+SsWyXnEGRXTDys9g5Is5nXaYK0KwiE1aB2MSy7eOiy/Fwncl3XwgQBpeDTioG03RGWCNXgjrjN3N/ibJwGGEyYKNw7Wt45aJN4TxnUujpb0p9iB4bQKnnbL/1ov0/Nu9Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(1800799024)(23010399003)(376014)(82310400026)(35042699022)(3023799007)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tzRWhPFiivFl5Klp/NOhQCMYwmGmFZlE/syfNs5Pfphj+qKIeRKINsBMkzZ4Y7McaY2esoT0UqN0Im2B6+6pszf/IoD1uhy7uUBNgDuj9smrvBQb1ZrCiBdAMq5w8+HEpoyt2surrR3RaVHSTO1qx9ZnWbRGRDfnB9zVj4Ims5pE5d+SwWvk4kNtFh4M3jCyMwhT91PzpJh3Vp5nGmGy5AKLYVS981CKoj/iwtyGCayhOfQ3RaZA9+0z7lqD/+1A9SvPIXVqy2SgDmM2fiIOIHmohOMVoldv7y7rrxEJOcdrghbcJI4s85oVct/YITqJu3bjSg1XDlkb4K7yW+/jvDRkytADWgcX3SYs5SuCy96pFAhahkEarkCVn2VHZlRw2cV0IoerEQjEV53df+v5Y1AJaHVfQ+TZ/IkApHSno6efymxAJqI++bz7F4bJVaK5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:52:48.5630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a36604-d66c-46ff-dcb9-08dee971b397
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10792

Introduce interfaces to make VPEs valid, and to configure them, via
the host's IRS. As with the other valid bits in the GICv5 VM tables,
VPEs cannot be made valid directly, and instead are made valid via an
IRS MMIO Op.

Additionally, some of the VPE configuration takes place via the IRS
MMIO interface too (via the IRS_VPE_CR0, IRS_VPE_DBR). VPE doorbells
are, for example, configured via this interface.

The existing VPE-doorbell-based commands are extended with:

        VPE_MAKE_VALID - Make the VPE valid in the VPET

Note: There is no VPE_MAKE_INVALID as VPEs are only made invalid on
teardown, at which point the whole VMTE is marked as invalid. Hence,
it is not required.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 84 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h |  1 +
 2 files changed, 85 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 21252bd11d96f..826c2284a1453 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -233,6 +233,18 @@ static int vgic_v5_irs_wait_for_vm_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VPE_SELR, IRS_VPE_DBR,
+ * IRS_VPE_CR0.
+ */
+static int vgic_v5_irs_wait_for_vpe_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VPE_STATUSR,
+					GICV5_IRS_VPE_STATUSR_IDLE,
+					NULL);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -333,10 +345,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bo=
ol spi_ist)
 	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
 }
=20
+static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_id,
+				  irq_hw_number_t db_hwirq)
+{
+	u64 vmap_vper, dbr, selr;
+	u32 statusr, cr0;
+	int ret;
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VPE as valid */
+	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
+		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
+		    GICV5_IRS_VMAP_VPER_M;
+	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
+
+	/* Wait for the VPE to be marked valid in the VPET */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       GICV5_IRS_VPE_SELR_S;
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return -EINVAL;
+
+	/* Set targeted only routing (disable 1ofN vPE selection) */
+	cr0 =3D GICV5_IRS_VPE_CR0_DPS;
+	irs_writel_relaxed(cr0, GICV5_IRS_VPE_CR0);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	/*
+	 * The VPE has not yet run. Therefore, make sure that all interrupts
+	 * will generate a doorbell.
+	 */
+	dbr =3D FIELD_PREP(GICV5_IRS_VPE_DBR_INTID, db_hwirq) |
+	      GICV5_IRS_VPE_DBR_DBV;
+	irs_writeq_relaxed(dbr, GICV5_IRS_VPE_DBR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+	/* Our VPE ID is the index within the doorbell domain */
+	u16 vpe_id =3D data->hwirq;
=20
 	switch (*cmd) {
 	case VMT_L2_MAP:
@@ -345,6 +420,15 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
+	case VPE_MAKE_VALID:
+		/*
+		 * We need the actual LPI ID which lives in the top-most parent
+		 * domain. This hwirq won't include the type (LPI) but that's
+		 * not required for the IRS_VPE_DBR.
+		 */
+		while (data->parent_data)
+			data =3D data->parent_data;
+		return vgic_v5_irs_set_up_vpe(vm->vm_id, vpe_id, data->hwirq);
 	case SPI_VIST_MAKE_VALID:
 		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 74152d22de070..8b6c497d3b590 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -659,6 +659,7 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	VPE_MAKE_VALID,		/* No corresponding invalid */
 	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
 	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
 	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
--=20
2.34.1
