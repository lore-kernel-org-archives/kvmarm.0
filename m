Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010052.outbound.protection.outlook.com [52.101.69.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF1D424D6B
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890240; cv=fail; b=hd/htygITuXeO8IyEjtKUl1KRHNQw2MlDvZ4OUhSBPKuX8vPPd4qcslsnQ5+39BBsVY9DR8J0quM+HeZii4aHi9Hf36uIZbiTP8r4gLbd+7R8QW7Lz8J8GIVhTs/jYjIkV4SHMO4Uig4xD22XNblbhp3Jf4FGfPotHq8pw71eDw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890240; c=relaxed/simple;
	bh=YdGr2NGMN1S8B1KHTIr69MklJqpugk9XD3MvYG56jfw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hvBjeo9xHuGaFywvuGMT6jFN4s1s+qFLoz3C+izImTHkMIhU9PdrsHtewlePzM86cKV8wusp7NhuCGXOelF0vN8t7KbJkx1vnwfobX5f/jWbDehmJhOkh8pKVi8knTkdEhz7qbyyMHqYbs7WphA5HK1rByr72kVG1OwOlQ47BQ8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JaQ0ZZK5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JaQ0ZZK5; arc=fail smtp.client-ip=52.101.69.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JaQ0ZZK5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JaQ0ZZK5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UXu/o1bJ/+O6OuR0nOhXHeCw8QUyK0gyRa34dVBF8ZcXqg8VRczEsOfXeB+LGAzrm6JnJzgBa5kS6Y7i3XxFHmOe1IK21XmM33pERyA2pCydnzIqZ+xzgr7Q6/jc9dlYgJ0BPIbrb2wIt5oIKAyO3JFTUZoaV0L+XLXw1dCwe4bMCegaoJk47vNJzBlN03tz0hQJlctV3W24N0Ssbv1PhVJp2uNsGurCwHRWMHhr/UvAXldpaUgIKvTRcv+iYnFhsZgTY+Bc5ZBaT5DBFf7oZOvXJWyznbrFOC4k5lOUS+2YCFWS2XFSnDkbiuFtjXMCV0QrS1xqPLuaCxKtmr+TsA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=rSpAaCb4BhUNHwtU0OX5xqC8hcOadYx/EMjmKicJJNAiQHrgmRa5IBDbWNujjZ9vSIOI9aUUoE8FJYon6tdAlGIF8xj0Px82TVrv8udB0OO10XRw/w6Rnk7FKRd9yzBoBVB2wlEHJBNk1G16ze516NczpLdA9BwTQ7bvQK3AayysJHnzyPhNoCQ8GDli7OpoiwjFIWU2JK5dQuTlx3xo8vGP6McoDXIH16KGgtRjf+D1eATUXgYhVORZlCuIo8HotmMqvJs8lLHRwMGR0kFDeMm0Bgu8WIx6edjvf7xiaz9nbv/yNm09iyLYiKxF+W0P1cY0MCVvR6LRyn1tOEu+rQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=JaQ0ZZK5FAFR1f9IY0PFLPGz04nbFPCePt7iuujZiKITasRtOn6+op9wWitYdnep38VdKuck3XzIIobU83Xg3s9jOVViCzK+NbNfOZGTKtRK4Rtm/9D4WOGMlIZFP0rvNRYYN9bNp6hyNYPGr95uaB52y7Lw/lNyGja1P8nEWFE=
Received: from DUZPR01CA0152.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::27) by PR3PR08MB5849.eurprd08.prod.outlook.com
 (2603:10a6:102:84::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:50:30 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::26) by DUZPR01CA0152.outlook.office365.com
 (2603:10a6:10:4bd::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:50:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:50:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7Lgy95rmmz1VpcCPXqvkM3RB1uYyYa0KxPduYAflOCxzzRkelMTsxOUTPLdlZurNuSKUF8fE4odKDX6lzyJL935c6aOPs2nzuGEBi5Hh5t5PiDvtw9X2CqljAy2mN+/o8dAQJzQK7/zDMG/4QlPw+A2u+fmrJP7t9QKXw5V6RrapQUraAPXYhOdXwXsXu+F3NET5M/irq/5/Vs2O0/Vqz4Z96KlQd/TzpzPeTmnSAoFkXO8znv2GDeSZuezdVYTN0erq4ffhHYYr87NEa24T+2GyM3zOPg/9V+BUDQ4xCiIDjpZIgQlO/8pW5ssYt1fx4iniBr9BUUC6CLkyqYoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=UtG8b6bjoklYg2u4pjVqkfEol/byakvZbgUS5K+cpmkCisLX/7Lsd0E/xD52kzZGiYMQ5IDlF/DqqvAENn9vMCwmxV5/P0lsjjmOexSV1qlCYkxoDqJyDkgoGeCVFPi8e0KUvc34tp9ZrQyxJlM9lOA+Nt4DzFPo2hJg87LoqnlatmG2P3Uf3M/ixI77vghG16acdbaDuUSggrYZCYHHt2qe1FSxlZQsx9tnwktIm45ooZ8SVwla+fWBiB7tT9k5hNbZjcKUijdKMlXgXT2CpUEvaDVdTrBr4ea27IcI9HTEq9BOkKWkSMs0DuA5Bjdb81M0A+fXowyH5YIMdB/wcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=JaQ0ZZK5FAFR1f9IY0PFLPGz04nbFPCePt7iuujZiKITasRtOn6+op9wWitYdnep38VdKuck3XzIIobU83Xg3s9jOVViCzK+NbNfOZGTKtRK4Rtm/9D4WOGMlIZFP0rvNRYYN9bNp6hyNYPGr95uaB52y7Lw/lNyGja1P8nEWFE=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:49:27 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:49:27 +0000
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
Subject: [PATCH v4 04/48] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH v4 04/48] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHdG1oYfYA0sw68zka6so/F5wT7Mw==
Date: Fri, 24 Jul 2026 10:49:26 +0000
Message-ID: <20260724104819.1296803-5-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|DU2PEPF00028D11:EE_|PR3PR08MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: c38c6041-bd9e-4022-134a-08dee97160c4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 Ji7EG9cOegB+QmLEvmGqVr93tyscDFlG6XtVW7ClLyUNxGAxc+ANGCXi7m5QNmoXfzuN//furSbnUTLAnHcBDoC0ZzG2+8ADOwhPLHyMZkrQpSmg4xFH0+DZmSmMlxQAbH7Tziq7ze4ayj/o7pTN30X3cVsT9nJJ+MfOZwYa0Lp+/VHSa0EmzLx3FhFUsbh2vVv1kS8qzNA8FRtIHqOGownqT8AyLRkBiErSV0gxTbaKe1faev+61RVDwX4GQhpGVRGxlfPCTYzNaEhMAq9OfYpSQ4GW5P3Q0F76+Ex2vUjwvNzN5IRUrwyAYBKFrgZddC/rykOtvm/Tp7N8g+BFasXvPSXkJJIm7Fa2m81ysMIOoffz2X4aGMGEH2nUePx58cXcl98eNWTPh9KgSMNGE0XEJgOzlgfXlsMTh/OB3JLZ+0Ushg+/pfjid5fM3bopkfZnJqMmM60T5EMNO0Rmu0R1lcxRCV1V+q2UsbqdS101BFwlpa+6KxXOiVKTCK+MOj3EiXkoboki9mcEyF5Zj5KPKI/xpu+NjxrjkZpB17KL7quEhqksvR9Nui6nFpgYU2TwFCT0sIQa5sOkox9oXSnfe1/HlM+v53ZP5vq7/MKAIlO3MHu4PJE9Qt9a/twiqYng4GrNGjQ9A1mIK/iQzCEAo9Fg/LhbTOXhUd8fBffjoYDxUS4725brxam4WMZzUiyH/ZbXO/bSuNhbGLLQpfLF7AmY6TvAOaZ7Xb0t53g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 UW6OOblVhz2UxH/hOZNtBjYd33h4Gir6Hla5uLjJziJGK26MxSiP0qsGOT3GALJepSKIArFGc1XEdBefKxzYFiLzcFB5SkQQGZc14Q0xXor8rcBRsOP+57dL3BYuKYJovgVBEhJhAeV/z+2r4e1bXEpw6EdPa+zlOrLkQ9H+eS6ED4q/dlC6SUg7kaC3IixI3VmCy0BcP93v2hUcgM3YTvsADHty7xRKVyBOFD8KtBHuRee8DRYUWaG1T/vftM3qcfLzmZPFDLIe8cgDSE61JGlxVh1ob57vM1ULu+D2Aop4bAORcaN4+gG2YIsFObJeF7NMwZ03PV6/qVg/IA47/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	92a3c72a-2b82-48b5-9ba7-08dee9713b5c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|35042699022|376014|14060799003|82310400026|36860700016|1800799024|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Yjx8MdkBZcQwmOq/fZuaXYUktD2N9BhNkqjJvFrVcI+cvUWkil4fosWKbvhc1hdzI29RsiVEW8Deq5xlloRnNw7uAFYh3vsRABGjPTYJyh7zhGvyJn1onc2IQjuAi5WVluXCqFV/cGaXkAloxHKDBOp3WXrBSwoGTCT/sLo+OCArvTspb1P7Pzc9OW0UnudOC0p4qLERm27rHbmbV2WL/C6DEClEssd6LoKfLoWOj6038dZhfFGrtrJAO98q3shpQjtxXkZdRmYgRj03ZzwhIokfr+CEKlXFHrGKH96beN3p1sR/4Oqmpc114iplvRhPAUDvhv83gxSGl3DfjvtXHTtttREZfwS5slDE4Js6R1gn+2hZHBppruudS6TefjlioJrPo2NYR+5KePyGQCr+xr4702+Tl9p5xZ3yXuV4aKs4i9JmHJWNvGdchF0bPAxJ5Zo9h0EjVbVuR0PMSfdcuhCGgvXAPHXyCGj3ci9CbJO99/jW1r3M6FWOSbKmk2yizO6U8mst/jA7PwgD1BVBw6x+7EthixBGHGu0gMo5hH9po5dgOvXqALw1tQAxyUZyoqpucH9iLOZMeuDAGr4CQl0dNR3vLJJ1oRcVE8E8IxbTxwKR3MnsYhtS01witutFCRZrDIivXSF2UrGQ0bK6W7drTYRZNBeRohex1L2XgsWpHTZMjwEaAOeMEJcaM/Jqorqh1iNEIZVTFfa8oTYZrA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(35042699022)(376014)(14060799003)(82310400026)(36860700016)(1800799024)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SxVDoZTx1I6fbDfhosX5J0cd0DuvG3jSxGpX5ZaPzHWwuvYLg7mx7qB7aUJtLb8WkONxkoZ8hAsy7JB2zLS52Dfp1pm+L9w3Sft4jlNuB5OaGSuvcYTcNBkImVM4+/ulHJbCbNc/Hffsd13wxr5cInCfJiGkSm5PnMlD76n43/M0BxuD0OAKYge27JWdkZ1poycMxOypoayIaMtKZdHolHVm8fbAcq6+Scer2gJPaKsagmuoFDPxfNnAmNqU8EK1AMSXiBqcvBp/cMst9Mq0l/96J0Ppsxr9fMU8DaT4lQL9p3WqR7LVnq+DjUvFpw2+KIinLUMI+n5dIYkwWwDjmkoVXh+XII0cwmEfbitUF37T3OEVbe3wjTRuutRgLS9ynP5Y2So0rwZtDtJegsSlZdseViKOGzCBS+w+0Ms8TuZ9i4RWXZoZEMx1o/zAOn0o
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:50:29.6150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c38c6041-bd9e-4022-134a-08dee97160c4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5849

Complete the set of defined IRS MMIO registers in the GICv5 header
file. Up until now, the set of defined IRS MMIO registers has been
driven by code requirements. However, in order to properly emulate the
IRS MMIO interface in KVM, the full set of IRS MMIO registers needs to
be added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/linux/irqchip/arm-gic-v5.h | 239 +++++++++++++++++++++++++++--
 1 file changed, 230 insertions(+), 9 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 681c5c51207d6..83cfcd056b250 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -62,20 +62,34 @@
 #define GICV5_OUTER_SHARE		0b10
 #define GICV5_INNER_SHARE		0b11
=20
+#define GICV5_AIDR_COMPONENT_IRS	0b00
+#define GICV5_AIDR_COMPONENT_ITS	0b01
+#define GICV5_AIDR_COMPONENT_IWB	0b10
+
+#define GICV5_AIDR_ARCH_MAJ_REV_V5	0
+#define GICV5_AIDR_ARCH_MIN_REV_V0	0
+
 /*
  * IRS registers and tables structures
  */
 #define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
 #define GICV5_IRS_IDR5			0x0014
 #define GICV5_IRS_IDR6			0x0018
 #define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
 #define GICV5_IRS_CR0			0x0080
 #define GICV5_IRS_CR1			0x0084
 #define GICV5_IRS_SYNCR			0x00c0
 #define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
 #define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
 #define GICV5_IRS_SPI_CFGR		0x0114
 #define GICV5_IRS_SPI_STATUSR		0x0118
 #define GICV5_IRS_PE_SELR		0x0140
@@ -85,11 +99,51 @@
 #define GICV5_IRS_IST_CFGR		0x0190
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
-
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_IRSID		GENMASK(31, 16)
+#define GICV5_IRS_IDR0_SWE		BIT(12)
+#define GICV5_IRS_IDR0_MPAM		BIT(11)
+#define GICV5_IRS_IDR0_MEC		BIT(10)
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_VIRT_ONE_N	BIT(8)
+#define GICV5_IRS_IDR0_ONE_N		BIT(7)
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
+#define GICV5_IRS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+#define GICV5_IRS_IDR0_INT_DOM_NON_SECURE	0b01
+#define GICV5_IRS_IDR0_INT_DOM_EL3		0b10
+#define GICV5_IRS_IDR0_INT_DOM_REALM		0b11
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
+#define GICV5_IRS_IDR1_PE_CNT		GENMASK(15, 0)
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS_1BITS	0b000
 #define GICV5_IRS_IDR1_PRIORITY_BITS_2BITS	0b001
@@ -105,13 +159,30 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+
+#define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
+#define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
+#define GICV5_IRS_IDR3_VMD_SZ		GENMASK(4, 1)
+#define GICV5_IRS_IDR3_VMD		BIT(0)
+
+#define GICV5_IRS_IDR4_VPE_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR4_VPED_SZ		GENMASK(5, 0)
+
 #define GICV5_IRS_IDR5_SPI_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR6_SPI_IRS_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR7_SPI_BASE		GENMASK(23, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IIDR_PRODUCT_ID	GENMASK(31, 20)
+#define GICV5_IRS_IIDR_VARIANT		GENMASK(19, 16)
+#define GICV5_IRS_IIDR_REVISION		GENMASK(15, 12)
+#define GICV5_IRS_IIDR_IMPLEMENTER	GENMASK(11, 0)
+
+#define GICV5_IRS_AIDR_COMPONENT	GENMASK(11, 8)
+#define GICV5_IRS_AIDR_ARCHMAJORREV	GENMASK(7, 4)
+#define GICV5_IRS_AIDR_ARCHMINORREV	GENMASK(3, 0)
=20
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
@@ -134,21 +205,39 @@
=20
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
=20
-#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
-#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_VMR_VIRT		BIT_ULL(63)
+#define GICV5_IRS_SPI_VMR_VM_ID		GENMASK_ULL(15, 0)
=20
 #define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
=20
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN	GENMASK(1, 0)
+
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_SECURE	0b00
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE	0b01
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_EL3	0b10
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_REALM	0b11
+
+#define GICV5_IRS_SPI_RESAMPLER_ID	GENMASK(23, 0)
+
 #define GICV5_IRS_SPI_CFGR_TM		BIT(0)
=20
+#define GICV5_IRS_SPI_CFGR_TM_EDGE	0b0
+#define GICV5_IRS_SPI_CFGR_TM_LEVEL	0b1
+
+#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_PE_SELR_IAFFID	GENMASK(15, 0)
=20
+#define GICV5_IRS_PE_STATUSR_ONLINE	BIT(2)
 #define GICV5_IRS_PE_STATUSR_V		BIT(1)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_PE_CR0_DPS		BIT(0)
=20
-#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
=20
 #define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
 #define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
@@ -166,15 +255,111 @@
 #define GICV5_IRS_IST_CFGR_L2SZ_16K	0b01
 #define GICV5_IRS_IST_CFGR_L2SZ_64K	0b10
=20
-#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
-#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
+#define GICV5_IRS_VMT_BASER_ADDR	GENMASK_ULL(55, 3)
+#define GICV5_IRS_VMT_BASER_ADDR_SHIFT	3ULL
+#define GICV5_IRS_VMT_BASER_VALID	BIT_ULL(0)
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL	0b1
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_LINEAR	0b0
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_VMT_CFGR_VM_ID_BITS	GENMASK(4, 0)
+
+#define GICV5_IRS_VMT_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VPE_SELR_S		BIT_ULL(63)
+#define GICV5_IRS_VPE_SELR_VPE_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VPE_SELR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VPE_DBR_DBV		BIT_ULL(63)
+#define GICV5_IRS_VPE_DBR_REQ_DB	BIT_ULL(62)
+#define GICV5_IRS_VPE_DBR_DBPM		GENMASK_ULL(36, 32)
+#define GICV5_IRS_VPE_DBR_INTID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_HPPIR_HPPIV	BIT_ULL(32)
+#define GICV5_IRS_VPE_HPPIR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VPE_HPPIR_ID		GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_CR0_DPS		BIT(0)
+
+#define GICV5_IRS_VPE_STATUSR_V		BIT(1)
+#define GICV5_IRS_VPE_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VM_DBR_EN		BIT_ULL(63)
+#define GICV5_IRS_VM_DBR_VPE_ID		GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VM_SELR_VM_ID		GENMASK(15, 0)
+
+#define GICV5_IRS_VM_STATUSR_V		BIT(1)
+#define GICV5_IRS_VM_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VMR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VMR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VMR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VISTR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VISTR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
+
+#define GICV5_IRS_VMAP_L2_VISTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_L2_VISTR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VMAP_L2_VISTR_ID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VMAP_VPER_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SAVE_VMR_VM_ID	GENMASK_ULL(15, 0)
+#define GICV5_IRS_SAVE_VMR_Q		BIT_ULL(62)
+#define GICV5_IRS_SAVE_VMR_S		BIT_ULL(63)
+
+#define GICV5_IRS_SAVE_VM_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SAVE_VM_STATUSR_Q	BIT(1)
+
+#define GICV5_IRS_MEC_IDR_MECIDSIZE	GENMASK(3, 0)
+
+#define GICV5_IRS_MEC_MECID_R_MECID	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_IDR_HAS_MPAM_SP	BIT(24)
+#define GICV5_IRS_MPAM_IDR_PMG_MAX	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_IDR_PARTID_MAX	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_PARTID_R_IDLE	BIT(31)
+#define GICV5_IRS_MPAM_PARTID_R_MPAM_SP	GENMASK(25, 24)
+#define GICV5_IRS_MPAM_PARTID_R_PMG	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_PARTID_R_PARTID	GENMASK(15, 0)
+
+#define GICV5_IRS_SWERR_STATUSR_IMP_EC	GENMASK_ULL(31, 24)
+#define GICV5_IRS_SWERR_STATUSR_EC	GENMASK_ULL(23, 16)
+#define GICV5_IRS_SWERR_STATUSR_OF	BIT_ULL(3)
+#define GICV5_IRS_SWERR_STATUSR_S1V	BIT_ULL(2)
+#define GICV5_IRS_SWERR_STATUSR_S0V	BIT_ULL(1)
+#define GICV5_IRS_SWERR_STATUSR_V	BIT_ULL(0)
+
+#define GICV5_IRS_SWERR_SYNDROMER0_VIRTUAL	BIT_ULL(63)
+#define GICV5_IRS_SWERR_SYNDROMER0_TYPE		GENMASK_ULL(62, 60)
+#define GICV5_IRS_SWERR_SYNDROMER0_ID		GENMASK_ULL(55, 32)
+#define GICV5_IRS_SWERR_SYNDROMER0_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SWERR_SYNDROMER1_ADDR	GENMASK_ULL(55, 3)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
+#define GICV5_IRS_ISTL1E_SIZE		8UL
=20
 #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
=20
+#define GICV5_IRS_SETLPIR		0x0000
+#define GICV5_IRS_SETLPIR_ID		GENMASK(23, 0)
+
 /*
  * ITS registers and tables structures
  */
@@ -296,6 +481,42 @@
 #define GICV5_GSI_IWB_FRAME_ID			GENMASK(28, 16)
 #define GICV5_GSI_IWB_WIRE			GENMASK(15, 0)
=20
+/*
+ * CoreSight identification registers - ordered by increasing offset.
+ */
+#define GICV5_CORESIGHT_DEVARCH		0xffbc
+#define GICV5_CORESIGHT_PIDR4		0xffd0
+#define GICV5_CORESIGHT_PIDR5		0xffd4
+#define GICV5_CORESIGHT_PIDR6		0xffd8
+#define GICV5_CORESIGHT_PIDR7		0xffdc
+#define GICV5_CORESIGHT_PIDR0		0xffe0
+#define GICV5_CORESIGHT_PIDR1		0xffe4
+#define GICV5_CORESIGHT_PIDR2		0xffe8
+#define GICV5_CORESIGHT_PIDR3		0xffec
+#define GICV5_CORESIGHT_CIDR0		0xfff0
+#define GICV5_CORESIGHT_CIDR1		0xfff4
+#define GICV5_CORESIGHT_CIDR2		0xfff8
+#define GICV5_CORESIGHT_CIDR3		0xfffc
+
+#define GICV5_CORESIGHT_DEVARCH_VAL			\
+	(FIELD_PREP(GENMASK(31, 21), 0x23b) |		\
+	 BIT(20) |					\
+	 0x5a19)
+
+#define GICV5_CORESIGHT_PIDR4_JEP106_CONT	0x04
+#define GICV5_CORESIGHT_PIDR5_RES0		0x00
+#define GICV5_CORESIGHT_PIDR6_RES0		0x00
+#define GICV5_CORESIGHT_PIDR7_RES0		0x00
+#define GICV5_CORESIGHT_PIDR0_PART_0		0x4b
+#define GICV5_CORESIGHT_PIDR1_DES_0_PART_1	0xb0
+#define GICV5_CORESIGHT_PIDR2_DES_1		0x0b
+#define GICV5_CORESIGHT_PIDR3_REVAND_CMOD	0x00
+
+#define GICV5_CORESIGHT_CIDR0_VAL		0x0d
+#define GICV5_CORESIGHT_CIDR1_VAL		0xf0
+#define GICV5_CORESIGHT_CIDR2_VAL		0x05
+#define GICV5_CORESIGHT_CIDR3_VAL		0xb1
+
 /*
  * Global Data structures and functions
  */
--=20
2.34.1
