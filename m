Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013044.outbound.protection.outlook.com [40.107.162.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0338477293
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522068; cv=fail; b=S4GHGBGkIPvrKgMntEFEveNU/a4Ae5gcC/gSWjNLHxml5uKOW5xgbSXyobO6uwGi2j95aGPoIzTNmmYkShN8lOR/iBJdWv4QTPIPfBWvU/2DHYJe+2vnERfHgkiYAzHezx9vHOpjgv3J17dZiO1lyRLmi8wvxHUnZP5qBa4rdDY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522068; c=relaxed/simple;
	bh=aBlro2IAzEiDXK66CjZNKFD0Qq/YKpONC4c3KEZ9SFM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OLgCAZyULcR3ccW/84FfuexocobnSU0UaGVtgJN9F27+DiF8wsgMsmOgav9S/0L0V59r7xonTgdEViqjYyEAa+ww/WhirFdCz2M6ndFJc3GLaGEYBfEiSreg/gzasZT+A2/SqDdnjbSnwqhn6/C2KO6TEJV4IQQZ3X0itxlk9a8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ghj9GElE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ghj9GElE; arc=fail smtp.client-ip=40.107.162.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ghj9GElE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ghj9GElE"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IUHI0n040glyZ3RlKO/K4vOzVcvXvqZG8RQHmleDsO9JUTXFhCAtQTidl4aVore0AgV9ci7++R0lKAHeXds8tPOF8B05VikMcBUQDQElY4vE4XTQqs2MJQiPNA9CtbQkxqx4KpysD6GEPnDGs8Yz4cDjNYMwzvxepO6qmPIJVrCvByW7Xk8Tj9YE1dRMyGfumQqufNjO9u14aLAAehR36Sm7oiq0vmDBcQ8N9sAMyXuwTIN0HOydnrBf2Z8cP71CzOXz8avDb+5kYXWnrtAP7Bb0wr8yXDjtIyykhziAnSu9VB2olFxzTlFt9NxxmkZ1UrgXU23N5KJtEC0KFXeL3Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5QnjXV4MhtbzCOnTVgQEswneyv3soV6RWPxgtdkUFo=;
 b=tg9FEtn8aoaw8zdlJ5UVN/kFvIIxpR4fCJltrrGWGUr2AcpYlMHNsOPHGlC+90F6YWczhf93qGGoE1p64Dmvc0GZW/qMDkACM/ZPoth6Q5QHX4rEted3FHiORWfPcaQuGK3ctSmIBq3F+g+/IMahiLTEHRBtEkepR7+yrTLx3y69VKn079umrWXHN2PLbP3oLe9qQQJWeyMNPo5otZg8DlXye2BTNxLDzKI7xcT1N68b2RAahDyd3HyS5u4UuZZHABi5G6Z+qvlC3UaguzocZNB7tna1tbsQKipWBqqgZ2Kdv7uA3LdxTt/otF1jWYqPI8CxXoNbHQAzrO1fJDNesA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5QnjXV4MhtbzCOnTVgQEswneyv3soV6RWPxgtdkUFo=;
 b=ghj9GElEsVv5+8GbvkZkvf6PYt8U/uby8pshF4MhcDTatDm8wuXlVINjoI9GY5sZkaNxQFfOk0+ol0XDiec6S9ylY0iUchPD+I1noC2auMDbc2/kjJ1X78gXVAgCO2c2ow3XcJVawiEzx0K+MEjnLaZqSQDmZfDlqS3m+NAv3ig=
Received: from DB9PR06CA0011.eurprd06.prod.outlook.com (2603:10a6:10:1db::16)
 by AS8PR08MB6695.eurprd08.prod.outlook.com (2603:10a6:20b:399::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:40:59 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::71) by DB9PR06CA0011.outlook.office365.com
 (2603:10a6:10:1db::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:40:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 11:40:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CsPSfysMscrRU2I72Nf4xyOtYC106G2VkKVBKePJF9SRwrP+HXuEhwBkQLvwa2F466zFerep6guf3Jfk4GyBiJwWwAHeX0dJVs2vJtfFUDv/UY8go2boFwzhHgUdZxa2VHcccZKaX076j6Zxly/XvPTCz38IHdayGYsoXCaRcWEuZBhY443YVK5auejiNSFDZfLpyOtuGqBAYGrVcbqzY1hrp6MMu9p738TyJXXDcskIVOJwkKplqdOvtNM6WV5P3iAJ5VHmeJLvm6PlrQBCWyiPle7PyTEXW5GzwId4qnLt938bY6EqlcscqPU2sqGmSea1MVf0HuZpy9Uxrj7M7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5QnjXV4MhtbzCOnTVgQEswneyv3soV6RWPxgtdkUFo=;
 b=dezDS5sm+TEIOoLnFPpxGhxowCwCJeaPLT0b2Fi69WqI3WjH+YEz8ZihphYE/bN+JjBfvLsrpxKnsPm5f6cfocU7eCcID80MUYGXD8OM4D3bCI+pQ3MCH6/yQNE73I/bg+8VQnZrRYfxK2jA0ev+00NLvHf7A1XOK1+ZaA2npoAfDUeEJq7l9i5mg7IX0CluHMykGyxp7LUcvGxDpPd0LhqI84mcp4aEeaNdVnEJCuunCm2rXP0R9/UoUqQMUykM8xxxTW6YJfENNn9RaGbJPz5OewyzYqaXozDdHQWjU8B5VEJovurPqN6XgMjdWT/g93uEsDsGRXF1uCoZ/2RgGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5QnjXV4MhtbzCOnTVgQEswneyv3soV6RWPxgtdkUFo=;
 b=ghj9GElEsVv5+8GbvkZkvf6PYt8U/uby8pshF4MhcDTatDm8wuXlVINjoI9GY5sZkaNxQFfOk0+ol0XDiec6S9ylY0iUchPD+I1noC2auMDbc2/kjJ1X78gXVAgCO2c2ow3XcJVawiEzx0K+MEjnLaZqSQDmZfDlqS3m+NAv3ig=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:40:22 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:40:22 +0000
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
Subject: [PATCH v6 12/49] KVM: arm64: vgic: Enforce model-specific vCPU limits
Thread-Topic: [PATCH v6 12/49] KVM: arm64: vgic: Enforce model-specific vCPU
 limits
Thread-Index: AQHdPGIr4/8qLgAsXkiG7nImAM6hKw==
Date: Fri, 4 Sep 2026 11:40:22 +0000
Message-ID: <20260904113404.4051341-13-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|DB1PEPF0003922F:EE_|AS8PR08MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 96ed3142-f348-49b1-d902-08df0a7963a5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|3023799007|11063799006|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 ZdoAIj/slTb8v5BNEFr2KRS/ZXzFkym0lBZcdNvjRM9J4crJOZ4B5p5p+DqSkGCylDN20C7CWN8q+mI0b3G4CIAOe0gaVk4SNmmsRH+KNHKEdSK5pZ97j2A8VigLaJMtJ2az/RxP4u5JFdafUSbXRlzzEDQUP3L3NOBuCEopwHwyAWF0HypHGno+6XbAXTJNACsA4F5UJWZv+BDpeZMrxDwtlqk1+5OPn6DvEZnbrsfc/CuooOS1kHNNUZUuDO53FuubOt2iC2gQQZ8PHFqQmnsRq1ejPngIIp2HGeqmGyldU/CaNsJfjWwdoQKbPOqW2vDMGjNKmKJJmEfKjevbO2Q8swxkiXGuK+E4R0BOLnMTfBxahSqz+3oG8tYSni4bz3uIM5Dx1m5BWFqqvaw8UfvYLjPIeVIftTGHT4LzwLlZoKljJKBepW4vQt7TpRbaQYvjYch3SGcMAyreroimN3Tm0UgOWs10rQLfzHz6tfKHb/zz4tdqbDRhTYGjPHlZJo7jrYhok8gzAjYGwgJZKLD2AbPna4CD3wIRfc20bTk5ukm/pwDh/+Lv1rrAER1TH1vgEQintfoCrkggRlaRwaZ7XDIWjh3uNlW1afbpTf5lslbzlp243jnsn4+n5N2SlS1Ct3fOHuxIKKRKHCmsGDiRIzda72pUfa9pPchJsvl/6F7MaMkR5jhURGgdUvBzZ2W/G4nq8/dQ8gRNWeBMwdP1kXyd7qLM+uTJwZ2pCXU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(3023799007)(11063799006)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 tmI6zrMDZZYtrS1bqlloyq0gXfzbm722a20LV2+J0bAzYWEEQTJNkzJ2GXHa6T1NhGIY37iC40qF7SEVJ6SG2esJck3WIacv8sND6L7txkM+xKWUIQM0NVmZdtS4EGkRJEnIdkWAEBICk+UbXdF95M19w8rD1Zl6r5WlHZkuLfttz70hJzPNrKUnfGLJ0qMBozvxQz2u3fhoV6ssRRKN604SYH6nMdTT/VnnPLOawldkkvQ/0Rz/So2hSSYvqJoCpCINIeCMFTBUT6IdM7OmdLDXfsFOMyuFkwOYeFrtLZTJOxLdjIzvcKWmp732W0F7EH561a/X5tpoKjiOhS6Yzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d1871505-fd5e-43e0-034e-08df0a794e2a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|376014|23010399003|82310400026|1800799024|36860700016|13003099007|6133799003|22082099003|18002099003|56012099006|11063799006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	wF2Hh1X3FAhGA2d7rAa8uDoDHrwufEacRK9iAPxtkra2te8yCoP62/rdbUpyp+ce1ULOIcQwyT1kC8osNERuohEaRUP5hkEc8sHP7v5iHpnP8wYfWFjHPd09JtFFHAdgd3Wl/Ebabql4u1sE8MEr8aBtZ5TBSgK3RdGHoMOkL1YBiOECsxTso1q0x9PAEBLgagVrpV855ws7wXMYQP2oSFIZZoRQ6JQxxmbgMUvmeut+17qQMlXWKb8QYVaCUF9lWuU4c0WM1pwpZpE3FbAeOhTP8PtIr5v3qgNxUNvJ7SF0+BXSl+OYW46X8b7eWN+MF9Fn7sYIbe/hkadin736vAbQ6y9euWLVi/kQ75smSHXSVYt9iEnJHi1Nkqpp9lm/nXjs5urYGKiDmICIUnb3lttV/kKIuQ7CpeUMxJXLIEMq5+79Ss4+IhaEdIBp9s0ujEPbV0vPcq2l+Cps526Ynnk+02Ww0VEnyVsoaHRJ5D7RaDyZTPmBOtxk7LVWiukAHfr3kaPaQwrLq+/zSoXA6dPfTXPH85jputO20F5J35JERh0A3xb8OwM8MBscWEpTAIjjIEC9576wahRxkE40Ly8qQRt9nCw1dUBiA/9upgQmLK0kJdmSthCVrrRBbmuTIKPNTeH2FeeG5OgPJZd0QEtyu/2AvPW4ShF3eFdzvxw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(13003099007)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WH7/WNll6Ac4sLcOZOt/txniM+kj50X4XiXyUIhHtTGLKeda29aDP/hK8effi+VN7PupoQxsVN3stbokC0rQlU5ePSyJNFgnFcZ1MJhVTGmggieCA8wYkoenazJTXC5asrAbJafYypcQNGsvHvPB6G/5wWwMwAW+vkLaZ1ZhaA7k2Cf62Hp7+rQauNtfIH/wJfZtqZPnl+0cYjgHoXs+WUoV4gNYmmgGnFHPcMuBCZPDQze8IvPaQyvn1gDdzpeEBxdHoDDj3jZD9pjL1iNd8WXcSJ7Zn89Ql/SG3sDJoT+Z6Bepj5Gd8lB90pJEyIgJo71kNqsQlFVu3fB3KFXHWIjOG3Sl9CdokIiaKgj/EAJzrpxsKR2yqkGKOuC+ewPAgBCFODp0vZa43h+gyh8F3TSVctOracaMWZzVs1oIusqMzWAtldR60ia2XQdNtpQq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:40:58.7883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ed3142-f348-49b1-d902-08df0a7963a5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6695

A GICv5 host with FEAT_GCIE_LEGACY can expose either a native vGICv5
or a vGICv3 device. These models do not necessarily have the same vCPU
limit: the native GICv5 limit is probed from the IRS VPE capacity,
while the GICv3 limit remains the fixed KVM vGICv3 limit.

Keep the IRS-derived limit separately for vGICv5 creation. The
pre-VGIC KVM_CAP_MAX_VCPUS value continues to expose the largest limit
among the still-selectable models, and kvm_vgic_create() clamps the VM
to the limit of the VGIC model userspace actually selected.

Userspace can create vCPUs before creating a VGIC. Hence, checking
only the number of existing vCPUs after reducing the limit is not
sufficient. For example, a single vCPU with ID 500 passes the GICv2
count limit even though GICv2 can represent only eight target
CPUs. The GICv2 code subsequently uses the vCPU ID in target and SGI
source masks, leading to shifts beyond the width of the operand.

GICv5 has a similar requirement because the userspace-provided vcpu_id
is used as the index into the VPET. This means that the vcpu_id also
represents the IAFFID for a VPE, and therefore is visible to the
guest.

After selecting the model-specific limit, validate every existing vCPU
ID against it. KVM_CREATE_VCPU already enforces the same limit for
vCPUs created after the VGIC, making the result independent of
creation order.

Link: https://lore.kernel.org/r/20260807133051.15D381F000E9@smtp.kernel.org
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 49 ++++++++++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-v5.c   | 16 ++++++-----
 include/kvm/arm_vgic.h          | 16 ++++++++---
 3 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index d5e05d9794076..ccbeb2f783c49 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -129,13 +129,30 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	}
 	ret =3D 0;
=20
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
-	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
-		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
-				     kvm_vgic_global_state.max_gic_vcpus);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->max_vcpus =3D kvm_vgic_global_state.max_gicv5_vcpus;
+		break;
+	}
+
+	/*
+	 * KVM_CREATE_VCPU enforces the model-specific limit if the VGIC has
+	 * already been created. Apply the same limit to any existing vCPUs so
+	 * that the result does not depend on the order in which userspace
+	 * creates them.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->vcpu_id >=3D kvm->max_vcpus) {
+			ret =3D -E2BIG;
+			goto out_unlock;
+		}
+	}
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -399,15 +416,27 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
=20
-	/*
-	 * If we are creating a VCPU with a GICv3 we must also register the
-	 * KVM io device for the redistributor that belongs to this VCPU.
-	 */
-	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		/*
+		 * If we are creating a VCPU with a GICv3 we must also register
+		 * the KVM io device for the redistributor that belongs to this
+		 * VCPU.
+		 */
 		mutex_lock(&vcpu->kvm->slots_lock);
 		ret =3D vgic_register_redist_iodev(vcpu);
 		mutex_unlock(&vcpu->kvm->slots_lock);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		/*
+		 * Ensure that it is possible to represent the
+		 * userspace-allocated vcpu_id in the hardware-limited (or
+		 * KVM-capped) VPE table used by GICv5.
+		 */
+		if (vcpu->vcpu_id >=3D kvm_vgic_global_state.max_gicv5_vcpus)
+			return -EINVAL;
 	}
+
 	return ret;
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 3d8f17301567a..e1571d1788a60 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -80,7 +80,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+	kvm_vgic_global_state.max_gic_vcpus =3D 0;
+	kvm_vgic_global_state.max_gicv5_vcpus =3D 0;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -105,8 +106,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
 	 * can't use them all.
 	 */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_cap=
s),
-						  VGIC_V5_MAX_CPUS);
+	kvm_vgic_global_state.max_gicv5_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_c=
aps),
+						    VGIC_V5_MAX_CPUS);
=20
 	/*
 	 * GICv5 requires a set of tables to be allocated in order to manage
@@ -115,7 +116,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * we want to run. For now, we match the maximum number offered by the
 	 * hardware, but this might not be a wise choice in the long term.
 	 */
-	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gicv5_vcpus);
 	if (ret) {
 		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
 		return -ENODEV;
@@ -150,6 +151,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
=20
 	v5_registered =3D true;
+	kvm_vgic_global_state.max_gic_vcpus =3D
+		kvm_vgic_global_state.max_gicv5_vcpus;
 	kvm_info("GCIE system register CPU interface\n");
=20
 skip_v5:
@@ -175,9 +178,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return v5_registered ? 0 : ret;
 	}
=20
-	/* We potentially limit the max VCPUs further than we need to here */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  kvm_vgic_global_state.max_gic_vcpus);
+	kvm_vgic_global_state.max_gic_vcpus =3D max(kvm_vgic_global_state.max_gic=
_vcpus,
+						  VGIC_V3_MAX_CPUS);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3ec3f7e1b88b4..593145760812f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -172,9 +172,16 @@ struct vgic_global {
 	/* Maintenance IRQ number */
 	unsigned int		maint_irq;
=20
-	/* maximum number of VCPUs allowed (GICv2 limits us to 8) */
+	/*
+	 * Maximum number of VCPUs exposed before userspace has selected a
+	 * VGIC model. Individual VGIC models can impose a lower limit
+	 * (GICv2 limits us to 8).
+	 */
 	int			max_gic_vcpus;
=20
+	/* Maximum number of VCPUs allowed for a GICv5 VM. */
+	int			max_gicv5_vcpus;
+
 	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
 	bool			can_emulate_gicv2;
=20
@@ -622,10 +629,11 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu);
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group=
1);
=20
 /**
- * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
+ * kvm_vgic_get_max_vcpus - Get the pre-VGIC-selection VCPU limit
  *
- * The host's GIC naturally limits the maximum amount of VCPUs a guest
- * can use.
+ * Userspace can query KVM_CAP_MAX_VCPUS before selecting a VGIC model, so
+ * expose the highest model-specific limit and let kvm_vgic_create() enfor=
ce
+ * the selected model's actual limit.
  */
 static inline int kvm_vgic_get_max_vcpus(void)
 {
--=20
2.34.1
