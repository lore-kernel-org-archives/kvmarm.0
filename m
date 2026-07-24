Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012050.outbound.protection.outlook.com [52.101.66.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD6C424D59
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890322; cv=fail; b=JtXR/9y6ieJIRFoc765xsLwzs46rffo1ykBqLkih5A6Sm5WTnkn5k4W+gpOy0ldv3IwSQfowOsIubjw9D7dANAyVILAi+RMgodTMJ4GU8OFr4fkWicIrNH98X1igEUXs8cyjrBO8pe93mGXMgyQBE0FD44+lQrvRf2mUcDBxetQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890322; c=relaxed/simple;
	bh=7sFAjPz/tMH82uyJqZjWfUUmw/LPBqOsZLNPFQOVjB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IMDI5QR1AvkjHIt0PnHVo0T5+bxpvZJ/lUQNyKn9++PQsEvmQqQObfjZ8nt2N1IiUYR2aT+ZZn1KS82kIWQWsf5HVqJoqmWIisRUve1WI4ynJcSHS4VDIWfqcEYuGNFYAX40eRfDXuqQa0hmLDZ5oniI3MjZRWZccRc2HUsDJe0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ctRBFINL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ctRBFINL; arc=fail smtp.client-ip=52.101.66.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ctRBFINL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ctRBFINL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Q8O3q3e8hD/Smk3eT5ZoxRrf49kMx7Nr8AkuEnPeYg4bYJTFQpofKAI6T462EJAVqsJM6mp008SIblp/2af1NorX3w6o690X2BMxRNkeql0YIuzv9pKGGG1gb/DMzNEMRZGNmGxawLACcnJnc8sqyhqF/yfnJBwlkvLereFN25nZJnvDsyfPjc2hFJLSbGKaooSsP88O4JUFyBAZruPJmHXJsh9zRnaDebD0ssMfFeZdRbdnp7VRh6A1cWhyiIIA6yhCMI5xITlcX7Qudf80acTmeMNYTbaTutmyG05U6zsA8KPpRj02jetzXgCgF/zFtKD8NmbPuig5VxqlQxET5w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJa/ShFfYs2j/osZVK8C8gGJyHs7rwvAd33U++Okwqo=;
 b=vnruqIUBYNAbd6ZrW6AbVKUoX0yiO5SbGqS1SGOTaz/m9n0n4reYhc/EHiRqLdUJ0d/CVXZJclBb7W3dArfy8PFXAaegwjklFShnHz8MB9KAwD9dUTpjboOfTLDj/B8wgEEZBov/LNtHqqQzCIDNFlQt7LUaNBWyUJYo6+skqYwaxeNAeb3NcW21TwIh9zP9Xrrp2N69TTkcSgWKW9SOrtg0dwWXC1C4HdHITu2mKVEIj4j1JmfHIagIELIEIlILPQX0m1Vu6Wph4CtCVMgTxQT9TXJsi6rLR9SDFGXXDWv9M/y3s9c5SwIh0qG4XT0NOE6AtfPiW9WIlCMafttQvw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJa/ShFfYs2j/osZVK8C8gGJyHs7rwvAd33U++Okwqo=;
 b=ctRBFINL48CCkrkCLadj3WTXvsqMUXG+THuFYK5kEs0ylStvOTAHGCfdcWAuzqNQkx5CT6Hp+c/5GBSMJvqfUnV2aKtaI3+UqGgrRq3qWMYcs7y8oVRTonHVhCqFck+9wDOuHIIZEMWgQhgNREFIbrehfbenP9pz6Cpu5S8y4RY=
Received: from DU2PR04CA0054.eurprd04.prod.outlook.com (2603:10a6:10:234::29)
 by MI3PR08MB11934.eurprd08.prod.outlook.com (2603:10a6:290:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:51:51 +0000
Received: from DU2PEPF00028D0D.eurprd03.prod.outlook.com
 (2603:10a6:10:234:cafe::c) by DU2PR04CA0054.outlook.office365.com
 (2603:10a6:10:234::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:51:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0D.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Fri, 24 Jul 2026 10:51:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGUbVPqCHf7RZFdD2lDyTJYAnbL0pzAbLw/93+2RYJUuVQawmzYFrdMpNwnJzhFTw8++ex8ozEHas3zO6o/dTpYlZh4jdohbf6vpgrPF2XdJj7dwHb2yQCDKtyIpQWv6CGwLamBb53AzFPvxBOJhus20fgj/w30Xb0zD1lSobKabU/JDh2wRhz8kU2xfI0YX1StgCMS8XXRk3tjey0hq9nLENHPS839oLZQcX5Zo7hcBX0IGPvuFks1nSeRA/CqP+ENieMf8D+k9uflu9505LgUhr1YaOZznAXivMkYeqgB85pvcOSHYUUtu50rYrVX0rA9BHvhIA0cXHMx1feY98A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJa/ShFfYs2j/osZVK8C8gGJyHs7rwvAd33U++Okwqo=;
 b=vnts2Lt7cTKO3lSH7ljKNY3PPQyioEP8tuc/24hX9rBmkZyYVe90WOtnJBoRm3ut7kYvTRuSYzld8az2ik4FxL+yNOGqZHS2CzoG+/dixKu0SQTdWZHKiq0HytGCKFGd6ejEOjf+q+QPF2dEjZn70RsRL2zcxVnAAGTsmFcQQ9T1gXZgwgVDnj2aF5YJ1WLQ5j8mAe6wV24A272COvmkohRE1eE/D1ChbUo+HzM8P8xd/gRWIqmidx4KIowz0gthxZDi+raSO83DrUAtc9asshhVAyomxZSJ50zQfJ4bu0QU9aVqsz6TM2Bw8g43M2u2O/ORGhE1p60Vz2eG8OFIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJa/ShFfYs2j/osZVK8C8gGJyHs7rwvAd33U++Okwqo=;
 b=ctRBFINL48CCkrkCLadj3WTXvsqMUXG+THuFYK5kEs0ylStvOTAHGCfdcWAuzqNQkx5CT6Hp+c/5GBSMJvqfUnV2aKtaI3+UqGgrRq3qWMYcs7y8oVRTonHVhCqFck+9wDOuHIIZEMWgQhgNREFIbrehfbenP9pz6Cpu5S8y4RY=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:50:44 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:50:44 +0000
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
Subject: [PATCH v4 09/48] KVM: arm64: gic-v5: Create and manage VM and VPE
 tables
Thread-Topic: [PATCH v4 09/48] KVM: arm64: gic-v5: Create and manage VM and
 VPE tables
Thread-Index: AQHdG1pGkZ/rYLJAtkGvle0+dM0tNw==
Date: Fri, 24 Jul 2026 10:50:43 +0000
Message-ID: <20260724104819.1296803-10-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|DU2PEPF00028D0D:EE_|MI3PR08MB11934:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e4c00d2-aa37-48f8-0dad-08dee9719126
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|5023799004|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 D6SB4ymiuKauXhuuDdjQSFMBzDPhWyVeYCFkCGxIbGK4GSa6TQySHuoFokxXVcgnpPmBx3JesEJ6f7q4B1JWnMqrfUN7ayoBYY2f7CAH68ykCcIYiHZzXy6OZSZbfau6X7w6t2OcKzIKRTr2+DRnsy07aZMDT/EIV98hY5ZeIXtyAu+6ZUYexJRPjB7SZaI52ORH9HhgJ/BJRjnmJJSu82axmiqxxMMb72GXqYYFxBZdrITJayEFHBKcVsObUyd/w9vKm1lPDfsth/qjbM8vIl31T3vDl/Koqhwqa2kulPj3swtc/vlhy3RDxoOAFX7Q2iNQhnRo/Gw7JBrj8xCfxBXNMD0mkjcWuP6IgD++X5OPxJeqMTF9Zp9MhqGS/1vothHfAnDehlybAGbd6A7nWAXw+msekit/LbT1eDqJ0yjkXhhJALLgaujgRgQ1JH0LrNVCrobsZNcvvAFdZI9L5VTWdQJ6jvOcyqziDY3dljbg7RRVU/7hrbrtgSuHU2Yn/DncVWWukKfGhWZVID8jf0IJRu1sO47g7bbT8hcV+RsBPqiE89pU75KvuycTvYBB55iMUPFnddfQgRRC98wyIFAV0Ag0E03peWzGiPY1InqaJrGgC2M7XyYaOn6pZHZfoLXh9GuoZ8IvWlfpanYiTfVd7WNBBiGRq1l+cz5Vt/6PsdTSL4Pe4oWqp2oDCnVhI9dPGFoyODCw7UwAtWTd7bwP8fbiIzzaTNDS4dfd0EE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YRzdcZ2xImFW342yI5btH9ORmYmyOgmAJksWAUk8mrFmvkmiR5lWLwSp/P4iKbsa5qWaA3HIILYrCycRz7iuB9/U/aJo6vdTiGdQhEeW9U/rrD7BwBayWLghQaSXROFtaZxxicH/Wi5Nzmv/aMcWEkNPzjob/q6IJm9SUGjf2eeTyO6dAggYxXP7UYQUhvMS6X+WR8bdxM/J93YSy6sRPIPPs7Gh+vmo2+XaVuHDFbLzbTzzSbQXuiTlSZ1xMScREr1ybBSql4aPGPi+DaNI9IRstMqn4pzKDwsBZx42MszGzm0p9zvodCoMW1lJyYIwHIy7T+8AG9R2lQdh6SdnZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c54d067c-9605-43c7-78f0-08dee9716944
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|23010399003|1800799024|36860700016|376014|11063799006|56012099006|5023799004|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	oKW+ztLUvheB4I5Htrze4qpwPM2oxkB55M/jdgqOWQu1ThVCZZfDhfu+DcJca/lQYmPwOm+6bC0R0aKajvsk+r725EcDo1J01xjFnJgY4WOITnivs1Xc1vvdKLYLBmBYk4sSXnmwnPxfTh81uzWr4XXNEu4Sfkp3MGI2LXbGawGE7k2+NGaT/De5myWynPFUO89XZDiS8lOdBhqOXPsCqZakCuAUFam01m4DWn+dcNEr33eeJ9lTd2b0w4auPJQsfE+WQxyY409y4hw5rYuQq1cuVNT+UqHFQJPIzDBdDInDue73h8M1A3Glq3VlVXgnbfAFKS87sREnTLsf7IN3vtr/iGwEnRw1QtGqQxSRzpP6mZRYnl9xyYelU9Ifx05+6HCpTzuaDZCvETDhqunDc1mIholT4HPCOgD+WvBuBScGTVuk5JasCYgxxK+n9L43DWW06AtJTk6FTNePjADi6oBpw9CjLe4VziyV19VocNYrNmfD/5Y7zrxf3hdLKFLOGUQahzQbFTXLa5vyQmYed4lFuzCZltUyMT/KcPqtgxiZMOokI9V8UY1IPvFtm6q9ABERfKEJp8o7BiYow9p1zj8V/x60QRyEmlmX5nFfWrQI48VU8aS0bvWZrL4YBPACSsLyopP1dU8rXIMIpgxcZen8wzq1NTN7Qzo9zkTMWhOwZGsoNNKOSbAiyUGLc3tfyUXzkl4le83bYSAev/St9g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(23010399003)(1800799024)(36860700016)(376014)(11063799006)(56012099006)(5023799004)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2xjKCKvM5UW1DlwVOzCDHE8f2vTTgaM7U3q2dRJQGACEm0qDs7ADTerxIZQvy6vek+mx+mLK2Ir9euBPILjknIaNibH46NFuxk8yyjsyZWQqspzIYS42+vQ3HDV2hoUPKzvgJdwTg2Iwa3w6dq4kF0+W/RLZ4xDeM7v7Fo3ONd+syTXB7EOuGbHcJGueFWH1XnTb2ULTflLE98F53gVozspQMBdnrvdsCGJMizvubKmBZwABfLp1NAyqZelv94YnthMdFEvJVczZOzbAU0tmw9fniqQlEyymvyc4Tbd6Mb2xZzGM5IdVNdoX6qDAEWHYPOqKU/jDzfBteZJpPfE4efo2stJWkisZRSrMreH9iaYSUGVjef2FruQIZUfNlo6fcw2akDHauiNpVDEOF+PWXF1dEfxtS/GgQFsa44wyYMKjMTZRNPHUo3kr3f47PU6J
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:51:50.7829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4c00d2-aa37-48f8-0dad-08dee9719126
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI3PR08MB11934

GICv5 uses a set of in-memory tables to track and manage VM
state. These must be allocated by the hypervisor, and provided to the
IRS to use.

The VMT (Virtual Machine Table) is a linear or two level table
comprising VMT Entries (VMTE). Each VMTE describes the state for a
single VM. This state includes things such as the SPI and LPI IST
configuration (coming in a future commit), an implementation-defined
VM Descriptor, and a VPE Table (VPET).

The VPET contains one entry per VPE belonging to a VM, and is used to
mark a VPE as valid, as well as providing the address of an
implementation-defined VPE Descriptor, which is used by the hardware
to track and manage VPE state.

This commit adds support for allocating the VMT, and managing the
VMTEs. The VMTEs can be initialised or released for re-use. Allocation
and tracking of unused VMTEs is handled with an IDA.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c      |   2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 630 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  76 ++++
 arch/arm64/kvm/vgic/vgic-v5.c        |  15 +
 drivers/irqchip/irq-gic-v5-irs.c     |  12 +-
 include/kvm/arm_vgic.h               |   4 +
 include/linux/irqchip/arm-gic-v5.h   |  14 +-
 8 files changed, 745 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c1..431de9b145ca1 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 625d352756fcf..079a57c2b18f6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -154,6 +154,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
 	}
=20
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
new file mode 100644
index 0000000000000..22cd03e0f1963
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -0,0 +1,630 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#include <kvm/arm_vgic.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_v5_vmt *vmt_info;
+/* Serialises lazy installation of shared second-level VMTs. */
+static DEFINE_MUTEX(vmt_l2_lock);
+static DEFINE_XARRAY(vm_info);
+
+/* Level 1 Virtual Machine Table Entry */
+#define GICV5_VMTEL1E_VALID		BIT_ULL(0)
+/* Note that there is no shift for the address by design */
+#define GICV5_VMTEL1E_L2_ADDR		GENMASK(51, 12)
+
+#define GICV5_VMTEL2E_SIZE		32ULL
+/* An L2 table (two-level VMT) is ALWAYS 4kB! */
+#define GICV5_VMT_L2_TABLE_SIZE		4096ULL
+#define GICV5_VMT_L2_TABLE_ENTRIES	(GICV5_VMT_L2_TABLE_SIZE / GICV5_VMTEL2=
E_SIZE)
+
+/*
+ * As the L2 VMTE is a large data structure, we are splitting it into 4 pa=
rts.
+ * We only mask and shift WITHIN each part for simplicity.
+ */
+/* First 64-bit chunk */
+#define GICV5_VMTEL2E_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_VMD_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VMD_ADDR		GENMASK_ULL(55, 3)
+/* Second 64-bit chunk */
+#define GICV5_VMTEL2E_VPET_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VPET_ADDR		GENMASK_ULL(55, 3)
+#define GICV5_VMTEL2E_VPE_ID_BITS	GENMASK_ULL(63, 59)
+/* Third & fourth 64-bit chunks (the encodings are the same for each) */
+#define GICV5_VMTEL2E_IST_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_IST_L2SZ		GENMASK_ULL(2, 1)
+#define GICV5_VMTEL2E_IST_ADDR_SHIFT	6ULL
+#define GICV5_VMTEL2E_IST_ADDR		GENMASK_ULL(55, 6)
+#define GICV5_VMTEL2E_IST_ISTSZ		GENMASK_ULL(57, 56)
+#define GICV5_VMTEL2E_IST_STRUCTURE	BIT_ULL(58)
+#define GICV5_VMTEL2E_IST_ID_BITS	GENMASK_ULL(63, 59)
+
+/* Virtual PE Table Entry */
+#define GICV5_VPE_VALID			BIT_ULL(0)
+/* Note that there is no shift for the address by design. */
+#define GICV5_VPED_ADDR_SHIFT		3ULL
+#define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
+
+/*
+ * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
+ * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
+ * manage our cached data explicitly.
+ *
+ * This helper is used to handle both coherent and non-coherent IRSes, and
+ * handles all combinations of cleaning and invalidating to the PoC.
+ */
+static void vgic_v5_clean_inval(void *va, size_t size)
+{
+	unsigned long base =3D (unsigned long)va;
+
+	dsb(ishst);
+
+	if (kvm_vgic_global_state.vgic_v5_irs_caps.non_coherent)
+		dcache_clean_inval_poc(base, base + size);
+}
+
+/*
+ * Create a linear VM Table. Directly using the number of entries supplied=
 as
+ * the size of an L2 VMTE (32 bytes) guarantees that our allocation is ali=
gned per
+ * the GICv5 requirements for the IRS_VMT_BASER.
+ */
+static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
+{
+	vmt_info->linear.vmt_base =3D kzalloc_objs(*vmt_info->linear.vmt_base,
+						 num_entries);
+	if (!vmt_info->linear.vmt_base)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(vmt_info->linear.vmt_base,
+			    num_entries * sizeof(struct vmtl2_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level VM table. The second-level VM t=
ables
+ * are allocated on demand (by vgic_v5_alloc_l2_vmt()).
+ */
+static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
+{
+	/*
+	 * Each L2 VMT array is always 4k-sized (covering 128 VMs). This is
+	 * mandated by the GICv5 specification (GICv5 EAC0 Specification rule
+	 * D_LSPBK). Hence, round up the number of entries to be at least 128
+	 * (or the next highest power of two as we give the HW the number of VM
+	 * ID bits).
+	 */
+	if (num_entries < GICV5_VMT_L2_TABLE_ENTRIES)
+		num_entries =3D GICV5_VMT_L2_TABLE_ENTRIES;
+	num_entries =3D roundup_pow_of_two(num_entries);
+
+	vmt_info->l2.num_l1_ents =3D (num_entries / GICV5_VMT_L2_TABLE_ENTRIES);
+	vmt_info->l2.vmt_base =3D kzalloc_objs(*vmt_info->l2.vmt_base,
+					     vmt_info->l2.num_l1_ents);
+	if (!vmt_info->l2.vmt_base)
+		return -ENOMEM;
+
+	vmt_info->l2.l2ptrs =3D kzalloc_objs(*vmt_info->l2.l2ptrs,
+					   vmt_info->l2.num_l1_ents,
+					   GFP_KERNEL);
+	if (!vmt_info->l2.l2ptrs) {
+		kfree(vmt_info->l2.vmt_base);
+		return -ENOMEM;
+	}
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base,
+			    vmt_info->l2.num_l1_ents * sizeof(vmtl1_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate a second level VMT, if required. This can be called eagerly, a=
nd
+ * will only perform the allocation if required.
+ */
+static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd =3D VMT_L2_MAP;
+	struct vmtl2_entry *l2_table;
+	unsigned int l1_index;
+	int ret;
+
+	/* Nothing to do if we have linear tables! */
+	if (!vmt_info->two_level)
+		return 0;
+
+	if (vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return -EINVAL;
+
+	/*
+	 * We have 4k-sized L2 tables - this is mandated by the spec for
+	 * two-level VMTs (GICv5 EAC0 Specification rule D_LSPBK). This means
+	 * that we have 128 entries per L1 VMTE.
+	 */
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+
+	guard(mutex)(&vmt_l2_lock);
+
+	/* Already valid? Great! */
+	if (vmt_info->l2.l2ptrs[l1_index])
+		return 0;
+
+	l2_table =3D kzalloc_objs(*l2_table, GICV5_VMT_L2_TABLE_ENTRIES);
+	if (!l2_table)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(l2_table, GICV5_VMT_L2_TABLE_SIZE);
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+			    sizeof(vmtl1_entry));
+
+	WRITE_ONCE(vmt_info->l2.vmt_base[l1_index],
+		   cpu_to_le64(virt_to_phys(l2_table)));
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+			    sizeof(vmtl1_entry));
+
+	/*
+	 * VMAP in the L2 VMT via the IRS. We use any of the VM's CPUs as a
+	 * conduit for interacting with the host's IRS. In the current case,
+	 * this lets us resolve the VM ID to pass to the hardware.
+	 */
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	/* We've failed to make the L2 VMT valid - things are very broken! */
+	if (ret) {
+		/* Remove the pointer from L1 table */
+		WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], 0);
+
+		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+				    sizeof(vmtl1_entry));
+
+		kfree(l2_table);
+
+		return ret;
+	}
+
+	vmt_info->l2.l2ptrs[l1_index] =3D l2_table;
+
+	return 0;
+}
+
+/*
+ * Allocate the top-level VMT. This can either be linear or two-level.
+ */
+int vgic_v5_vmt_allocate(unsigned int max_vpes)
+{
+	int ret;
+
+	/* Allocate the tracking structure */
+	vmt_info =3D kzalloc_obj(*vmt_info, GFP_KERNEL);
+	if (!vmt_info)
+		return -ENOMEM;
+
+	ida_init(&vmt_info->vm_id_ida);
+	vmt_info->max_vpes =3D max_vpes;
+	vmt_info->vmd_size =3D irs_caps.vmd_size;
+	vmt_info->vped_size =3D irs_caps.vped_size;
+	vmt_info->two_level =3D irs_caps.two_level_vmt_support;
+	vmt_info->num_entries =3D irs_caps.max_vms;
+
+	if (vmt_info->two_level)
+		ret =3D vgic_v5_alloc_vmt_two_level(vmt_info->num_entries);
+	else
+		ret =3D vgic_v5_alloc_vmt_linear(vmt_info->num_entries);
+
+	/* If anything failed, free our tracking structure before returning */
+	if (ret) {
+		kfree(vmt_info);
+		vmt_info =3D NULL;
+	}
+
+	return ret;
+}
+
+/*
+ * Free the VMT and associated tracking structures. This isn't strictly ex=
pected
+ * to be called in general operation, but instead exists for completeness.
+ */
+int vgic_v5_vmt_free(void)
+{
+	if (!vmt_info)
+		return 0;
+
+	if (!vmt_info->two_level) {
+		kfree(vmt_info->linear.vmt_base);
+	} else {
+		/* Free the L2 tables; kfree(NULL) is safe */
+		for (int i =3D 0; i < vmt_info->l2.num_l1_ents; ++i)
+			kfree(vmt_info->l2.l2ptrs[i]);
+		kfree(vmt_info->l2.l2ptrs);
+
+		/* And now free the L1 table */
+		kfree(vmt_info->l2.vmt_base);
+	}
+
+	ida_destroy(&vmt_info->vm_id_ida);
+	kfree(vmt_info);
+	vmt_info =3D NULL;
+
+	return 0;
+}
+
+/*
+ * Look up a VMT Entry by VM ID.
+ */
+static struct vmtl2_entry *vgic_v5_get_l2_vmte(u32 vm_id)
+{
+	unsigned int l1_index, l2_index;
+	struct vmtl2_entry *l2_table;
+
+	if (vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return ERR_PTR(-EINVAL);
+
+	if (!vmt_info->two_level)
+		return &vmt_info->linear.vmt_base[vm_id];
+
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+	l2_index =3D vm_id % GICV5_VMT_L2_TABLE_ENTRIES;
+
+	if (l1_index >=3D vmt_info->l2.num_l1_ents)
+		return ERR_PTR(-E2BIG);
+
+	if (!vmt_info->l2.l2ptrs[l1_index])
+		return ERR_PTR(-EINVAL);
+
+	l2_table =3D vmt_info->l2.l2ptrs[l1_index];
+	return &l2_table[l2_index];
+}
+
+/*
+ * Zero a VMT Entry, and flush & invalidate to the PoC, if required.
+ */
+static int vgic_v5_reset_vmte(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/*
+	 * The VMT is normal memory shared with the IRS. Invalidate before
+	 * rewriting the entry so that cacheline-granular maintenance cannot
+	 * later push stale data for neighbouring IRS-visible state back to
+	 * memory.
+	 */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	/*
+	 * Prevent the compiler from eliding the individual VMTE
+	 * stores. Ordering and visibility to the IRS are provided by the
+	 * surrounding cache maintenance and command protocol, not by
+	 * WRITE_ONCE().
+	 *
+	 * The same compiler-access constraint applies to READ_ONCE() users in
+	 * this file: when inspecting IRS-visible table entries, read the field
+	 * exactly once and prevent the compiler from reusing, merging or
+	 * tearing the access. Coherency and freshness for non-coherent IRSes
+	 * still come from the surrounding cache maintenance.
+	 */
+	WRITE_ONCE(vmte->val[0], cpu_to_le64(0ULL));
+	WRITE_ONCE(vmte->val[1], cpu_to_le64(0ULL));
+	WRITE_ONCE(vmte->val[2], cpu_to_le64(0ULL));
+	WRITE_ONCE(vmte->val[3], cpu_to_le64(0ULL));
+
+	/* And make our write visible to the IRS (if non-coherent) */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/*
+ * Use the IDA to allocate a new VM ID, and track it in the gicv5_vm data
+ * structure. If we're out of VM IDs, the IDA catches that, and we return =
the
+ * error (-ENOSPC). If we've previously allocated a VM ID, we catch that t=
oo and
+ * return -EBUSY.
+ */
+int vgic_v5_allocate_vm_id(struct kvm *kvm)
+{
+	int id;
+
+	if (kvm->arch.vgic.gicv5_vm.vm_id !=3D VGIC_V5_VM_ID_INVAL)
+		return -EBUSY;
+
+	id =3D ida_alloc_max(&vmt_info->vm_id_ida, vmt_info->num_entries - 1u,
+			   GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	kvm->arch.vgic.gicv5_vm.vm_id =3D id;
+
+	return 0;
+}
+
+/*
+ * Release the VM ID to allow it to be reallocated in the future.
+ */
+void vgic_v5_release_vm_id(struct kvm *kvm)
+{
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	ida_free(&vmt_info->vm_id_ida, kvm->arch.vgic.gicv5_vm.vm_id);
+	kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
+}
+
+/*
+ * Initialise an entry in the VMT based on the index of the VM.
+ *
+ * Note: We don't mark the VMTE as valid as this needs to be done by
+ * the hardware.
+ */
+int vgic_v5_vmte_init(struct kvm *kvm)
+{
+	int nr_cpus =3D atomic_read(&kvm->online_vcpus);
+	struct vgic_v5_vm_info *vmi =3D NULL;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	void **vped_ptrs =3D NULL;
+	vpe_entry *vpet =3D NULL;
+	void *vmd =3D NULL;
+	int ret;
+	u64 tmp;
+
+	if (nr_cpus > vmt_info->max_vpes)
+		return -E2BIG;
+
+	/*
+	 * If we're using two-level VMTs, L2 is allocated on demand. For linear
+	 * VMTs, this is a NOP.
+	 */
+	ret =3D vgic_v5_alloc_l2_vmt(kvm);
+	if (ret)
+		return ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* If the entry is already valid, something went wrong */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+		return -EINVAL;
+
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	vmi =3D kzalloc_obj(*vmi);
+	if (!vmi) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	ret =3D xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);
+	if (ret)
+		goto out_fail;
+
+	/* Allocate and assign the VM Descriptor, if required. */
+	if (vmt_info->vmd_size !=3D 0) {
+		vmd =3D kzalloc(vmt_info->vmd_size, GFP_KERNEL);
+		if (!vmd) {
+			ret =3D -ENOMEM;
+			goto out_fail;
+		}
+
+		/* Stash the VA so we can free it later */
+		vmi->vmd_base =3D vmd;
+
+		tmp =3D FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
+				 virt_to_phys(vmd) >> GICV5_VMTEL2E_VMD_ADDR_SHIFT);
+		WRITE_ONCE(vmte->val[0], cpu_to_le64(tmp));
+	}
+
+	/*
+	 * Allocate and assign the VPE Table. Round up the number of CPUs to a
+	 * whole power of two as we cannot describe non-powers-of-two in the
+	 * VMTE field as it conveys the number of ID bits used and not the
+	 * number of vPEs. IRS_IDR1.IAFFID_BITS is encoded as N - 1, so expose
+	 * at least one VPE ID bit even for a single-vCPU VM to keep the views
+	 * consistent.
+	 */
+	nr_cpus =3D max(2UL, roundup_pow_of_two(nr_cpus));
+	vmi->vpe_id_bits =3D fls(nr_cpus) - 1;
+
+	vpet =3D kzalloc_objs(*vpet, nr_cpus);
+	if (!vpet) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	/* Stash the VA so we can free it later */
+	vmi->vpet_base =3D vpet;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_VPET_ADDR,
+			 virt_to_phys(vpet) >> GICV5_VMTEL2E_VPET_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
+	WRITE_ONCE(vmte->val[1], cpu_to_le64(tmp));
+
+	vped_ptrs =3D kzalloc_objs(*vped_ptrs, nr_cpus, GFP_KERNEL);
+	if (!vped_ptrs) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+	vmi->vped_ptrs =3D vped_ptrs;
+
+	if (vmd)
+		vgic_v5_clean_inval(vmd, vmt_info->vmd_size);
+	vgic_v5_clean_inval(vpet, sizeof(*vpet) * nr_cpus);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D true;
+
+	return 0;
+
+out_fail:
+	/* kfree(NULL) is safe so we can just kfree() at leisure */
+	kfree(vmd);
+	kfree(vpet);
+	kfree(vped_ptrs);
+	if (vmi)
+		xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+	vgic_v5_reset_vmte(kvm);
+
+	return ret;
+}
+
+/*
+ * Release the VMT Entry, freeing up any allocated data structures before
+ * zeroing the VMTE.
+ *
+ * The VMTE must be marked as invalid before it is released.
+ */
+int vgic_v5_vmte_release(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	int ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* Reject if the VMTE has not been marked as invalid! */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+		return -EINVAL;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		goto no_vmi;
+
+	for (int i =3D 0; i < BIT(vmi->vpe_id_bits); i++)
+		kfree(vmi->vped_ptrs[i]);
+	kfree(vmi->vped_ptrs);
+	kfree(vmi->vpet_base);
+	kfree(vmi->vmd_base);
+
+	xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+no_vmi:
+	/*
+	 * If we didn't get far enough into allocating a VMTE to create the VM
+	 * info structure, then we just zero the VMTE and move on. There's
+	 * nothing else we can realistically do here.
+	 */
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D false;
+
+	return 0;
+}
+
+/*
+ * Allocate a VPE descriptor and provide it to the hardware via the VPE Ta=
ble.
+ */
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	vpe_entry tmp, *vpet_base;
+	void *vped;
+
+	/* Make sure we're not over what the hardware supports */
+	if (vpe_id >=3D vmt_info->max_vpes)
+		return -E2BIG;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+
+	/* If the VPETE for this CPU is already valid we've gone wrong */
+	vgic_v5_clean_inval(&vpet_base[vpe_id], sizeof(*vpet_base));
+	if (le64_to_cpu(READ_ONCE(vpet_base[vpe_id])) & GICV5_VPE_VALID)
+		return -EBUSY;
+
+	/* Alloc VPE Descriptor. Only used by IRS. */
+	vped =3D kzalloc(vmt_info->vped_size, GFP_KERNEL);
+	if (!vped)
+		return -ENOMEM;
+
+	vmi->vped_ptrs[vpe_id] =3D vped;
+
+	tmp =3D FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR=
_SHIFT);
+	WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
+
+	vgic_v5_clean_inval(vped, vmt_info->vped_size);
+	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+
+	return 0;
+}
+
+/*
+ * Free the memory allocated for the VPE descriptor.
+ */
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	vpe_entry *vpet_base;
+	void *vped;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+		return -EBUSY;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+	WRITE_ONCE(vpet_base[vpe_id], 0ULL);
+
+	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+
+	/* Free VPE Descriptor. Only used by IRS. */
+	vped =3D vmi->vped_ptrs[vpe_id];
+	vmi->vped_ptrs[vpe_id] =3D NULL;
+	kfree(vped);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
new file mode 100644
index 0000000000000..b763dc3a60e3a
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#ifndef __KVM_ARM_VGICV5_TABLES_H__
+#define __KVM_ARM_VGICV5_TABLES_H__
+
+#include <linux/idr.h>
+#include <linux/irqchip/arm-gic-v5.h>
+
+/* Level 1 Virtual Machine Table Entry */
+typedef __le64 vmtl1_entry;
+
+/* Level 2 Virtual Machine Table Entry */
+struct vmtl2_entry {
+	__le64 val[4];
+};
+
+/* Virtual PE Table Entry */
+typedef __le64 vpe_entry;
+
+struct vgic_v5_vm_info {
+	void __iomem		*vmd_base;
+	vpe_entry __iomem	*vpet_base;
+	void __iomem		**vped_ptrs;
+	u8			vpe_id_bits;
+};
+
+struct vgic_v5_vmt {
+	union {
+		struct {
+			struct vmtl2_entry *vmt_base;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			vmtl1_entry *vmt_base;
+			struct vmtl2_entry **l2ptrs;
+			unsigned int num_l1_ents;
+		} l2;
+	};
+	bool		two_level;
+	unsigned int	num_entries;
+	unsigned int	max_vpes;
+	size_t		vmd_size;
+	size_t		vped_size;
+	struct ida	vm_id_ida;
+};
+
+static inline u32 vgic_v5_vm_id(struct kvm *kvm)
+{
+	return kvm->arch.vgic.gicv5_vm.vm_id;
+}
+
+static inline u16 vgic_v5_vpe_id(struct kvm_vcpu *vcpu)
+{
+	return vcpu->vcpu_idx;
+}
+
+static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db;
+}
+
+int vgic_v5_vmt_allocate(unsigned int max_vpes);
+int vgic_v5_vmt_free(void);
+
+int vgic_v5_allocate_vm_id(struct kvm *kvm);
+void vgic_v5_release_vm_id(struct kvm *kvm);
+
+int vgic_v5_vmte_init(struct kvm *kvm);
+int vgic_v5_vmte_release(struct kvm *kvm);
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index ebd7c3ede975f..995606e0c3a39 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -153,6 +153,20 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
+{
+	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+
+	switch (*cmd) {
+	case VMT_L2_MAP:
+	case VMTE_MAKE_VALID:
+	case VMTE_MAKE_INVALID:
+		/* Not yet implemented */
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * This set of irq_chip functions is specific for doorbells.
  */
@@ -164,6 +178,7 @@ static const struct irq_chip vgic_v5_db_irq_chip =3D {
 	.irq_set_affinity =3D irq_chip_set_affinity_parent,
 	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
 	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.irq_set_vcpu_affinity =3D vgic_v5_db_set_vcpu_affinity,
 	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
 		 IRQCHIP_MASK_ON_SUSPEND,
 };
diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index 607e066821b52..70502b07ec8d7 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -269,24 +269,24 @@ int gicv5_irs_iste_alloc(const u32 lpi)
  * itself is not supported) again serves to make it easier to find physica=
lly
  * contiguous blocks of memory.
  */
-static unsigned int gicv5_irs_l2_sz(u32 idr2)
+unsigned int gicv5_irs_l2_sz(u32 l2sz)
 {
 	switch (PAGE_SIZE) {
 	case SZ_64K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_64K;
 		fallthrough;
 	case SZ_4K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_4K;
 		fallthrough;
 	case SZ_16K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_16K;
 		break;
 	}
=20
-	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 		return GICV5_IRS_IST_CFGR_L2SZ_4K;
=20
 	return GICV5_IRS_IST_CFGR_L2SZ_64K;
@@ -334,7 +334,7 @@ static int __init gicv5_irs_init_ist(struct gicv5_irs_c=
hip_data *irs_data)
 	lpi_id_bits =3D min(lpi_id_bits, gicv5_global_data.cpuif_id_bits);
=20
 	if (two_levels)
-		l2sz =3D gicv5_irs_l2_sz(idr2);
+		l2sz =3D gicv5_irs_l2_sz(FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr2));
=20
 	istmd =3D !!FIELD_GET(GICV5_IRS_IDR2_ISTMD, idr2);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bff2b7c896d55..ba32cd71fe0a7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -374,6 +374,8 @@ struct vgic_redist_region {
 	struct list_head list;
 };
=20
+#define VGIC_V5_VM_ID_INVAL		(-1)
+
 struct vgic_v5_vm {
 	/*
 	 * We only expose a subset of PPIs to the guest. This subset is a
@@ -396,6 +398,8 @@ struct vgic_v5_vm {
 	struct fwnode_handle	*fwnode;
 	struct irq_domain	*domain;
 	int			vpe_db_base;
+	u32			vm_id;
+	bool			vmte_allocated;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 21c8a69f99bb6..27b13bf2c1e2c 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -159,9 +159,9 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(0), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(1), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(2), (r))
=20
 #define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
 #define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
@@ -609,6 +609,7 @@ int gicv5_irs_cpu_to_iaffid(int cpu_id, u16 *iaffid);
 struct gicv5_irs_chip_data *gicv5_irs_lookup_by_spi_id(u32 spi_id);
 int gicv5_spi_irq_set_type(struct irq_data *d, unsigned int type);
 int gicv5_irs_iste_alloc(u32 lpi);
+unsigned int gicv5_irs_l2_sz(u32 l2sz);
 void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
@@ -653,4 +654,11 @@ void gicv5_deinit_lpis(void);
=20
 void __init gicv5_its_of_probe(struct device_node *parent);
 void __init gicv5_its_acpi_probe(void);
+
+enum gicv5_vcpu_cmd {
+	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
+	VMTE_MAKE_VALID,	/* Make the VMTE valid */
+	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+};
+
 #endif
--=20
2.34.1
