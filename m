Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013062.outbound.protection.outlook.com [52.101.72.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795C03D47B2
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890797; cv=fail; b=B5PGDaA0D/fKuw/mz0NS8EJxIPoW3yb4gssLhH/E2CNB+4H8ayF8fLqiT0orTbX1hYlGZEKNeHZ2L4QlqJEUj1AkcLD5grH3Tb7a6p6gzH9YRGsNPQLuk9uKKQCE0aO4lKay6eDENHxhdKZXtuCa/ImarHjmZ0c4OVWKZsXj6vI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890797; c=relaxed/simple;
	bh=/+e/AkaWRpTPwjW23BgYy4Cq7NK+gW6+V/aNpVnxgVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VwKQyYvpChKFrwgSHtzjtTK8w37cO3zbcIeRjJ8o0k3Itw76Lr43/3dMmxkRmOZSbpSqp6P5lmYF/fktdJgWsAcvYxX2ZNDHOfpXSOSebFV+SOYCKYnEvK3VrUk739EK/qn61GLqeFjDvp0m317uxBaZbqifY/ib09tdO3ZJVTo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=crhwRxiC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=crhwRxiC; arc=fail smtp.client-ip=52.101.72.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="crhwRxiC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="crhwRxiC"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=C/bgN7/eGGEZrUt49zbjd3+Kn0P/eWhyWD5eB4azeNUtA62xYDDrYdc07iT8JYAl7dSBdWvnBR7+fN/T0zOPprHOXyqw+11YrfxKPOimJb9noitew5/XbV0t3HvVq75gGTnDgG7jNSQID/k6Q5yEjRJVxsGKmSRX7DeuLc8iVmvp7cIqpqcP0dfnd84a271VCf+CFawfyhBEbakQdV620zg67iCvSEUQUT1ulG+ZyMcBxMTSSF2fefufyKKdjXB055Rmzek5g3urvSFm1rwLKXWUWCwBLD8eLAqWrTlUkdjOIzQg4Svkw6H8BmOxPwXO24koujWvRsSLFh5RpiELUQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=JJEBgThwC803Tir3nN6P3hfWf1hNNTic+Y/2ZqqdTtvi/QzC4rVVkfKQUniEVjgIsG8CwnaJoP6cIW3nY4ywFOrOvD/v+q8mr6+QQli7osgEnQB4aogfCLt4CsK12CBSyLThDn8FcKgFnIfE/aKkEfqF8DrvNIzzkMZWNqXD1fvejDqstTeJvs4/gkuWZixd7jnvrvlvoCU6brWe9ulzmhewlSNw0W1jTOPvDVQH7nF7kwAF7JIC/pLEn9xyN/HI5VuMmw57FTKErMq1+sKym9m6vO/08wDlfQjVp3gLaVQIQXS2S8QDGZY37zdlYxHYJ9Lm/UjberEvnUfK1AutdA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=crhwRxiCUVAGfK5PGN59yU3XAFDtxU7PnhQyDDh4Brjywy6ppmW8LKRuX9OB2HzKpzY2XqJlVlQtDBQVdqpNy3qCns2GGNj3dIT9WPsVikMqp5s8LwxUTqr7fRDb3GCnM4V+YNeR9D6RBu1ybewU78NYF3xlJhLbHwjpnEB6y7s=
Received: from AS9PR07CA0031.eurprd07.prod.outlook.com (2603:10a6:20b:46b::33)
 by AM8PR08MB6514.eurprd08.prod.outlook.com (2603:10a6:20b:36b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:59:48 +0000
Received: from AMS1EPF00000090.eurprd05.prod.outlook.com
 (2603:10a6:20b:46b:cafe::2e) by AS9PR07CA0031.outlook.office365.com
 (2603:10a6:20b:46b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.4 via Frontend Transport; Fri, 24
 Jul 2026 10:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000090.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:59:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kAxOmkdmoG5++3Niq9wggwc+Lx5d1UYWtU8YsdooBM3b1A4RMM3qIsvln3CHUWicNtDecdV1CMnVkjSzdYlGCRS6HePmzknyIhGE09Yg8pvbE7v8M7XteoB5NrB8iHStDs3ELD9Ar14XWB1TuRrjwM3OA1odUMEhkD08dPbK4zbFt0A7v9uZPhii3ZlSX54HG8EWh42Ea2E7rY83i9DmMajilR1lyz8E3Rg3778RCQBiqSFf2B3KH/4TR51CLe8F9bZpkwWZucT43mfQhtfZnZU6GsVdJQmYxlUhCP+jcVG0NIInjxPXe1vg+uAyarSUGUbrFCwx/2FmQECgLo1gpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=og6kWPJj3+NeDYLnAAcu442RZkSKw0lVSmgV3MhyHpmzDShwKvuUlIRKsuKgKlMRclZsAVtH3mg3EFlspsvB0AQ4Z+wYuVK21X/+bi9Xf6gYTikJkzr3EzCSgiHOPa9fB3rihs/QFyu74suurshEA4Q3w0KHJSZ9zFmanM7S0tlAtE9ZjHFNbk/exmDSCjvK2cCHUUi6de/Zjlpa/mYlu7pHsQAYK7z5Ynou/R8ph3ja9Q5L40srDSUYJmK7b3sNiK+BGnTChcIOkc449De+3av3B73s6A6w9Ad3c/BRHxX50y/6WlNB1fMiyqrNV/1EuMZlyHev3tH8qpgb5Xd3Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0V2cFbey9tp/MZ4Fys1o9v8hc6ZxpVgavABz32KqqQ=;
 b=crhwRxiCUVAGfK5PGN59yU3XAFDtxU7PnhQyDDh4Brjywy6ppmW8LKRuX9OB2HzKpzY2XqJlVlQtDBQVdqpNy3qCns2GGNj3dIT9WPsVikMqp5s8LwxUTqr7fRDb3GCnM4V+YNeR9D6RBu1ybewU78NYF3xlJhLbHwjpnEB6y7s=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:58:43 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:58:43 +0000
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
Subject: [PATCH v4 40/48] KVM: selftests: Add VGICv5 IRS address attribute
 tests
Thread-Topic: [PATCH v4 40/48] KVM: selftests: Add VGICv5 IRS address
 attribute tests
Thread-Index: AQHdG1tk2tgIlJzDVEyZ5FbSRKrHfg==
Date: Fri, 24 Jul 2026 10:58:43 +0000
Message-ID: <20260724104819.1296803-41-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AMS1EPF00000090:EE_|AM8PR08MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aa83615-26fe-412a-3262-08dee972acbf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 PmQ8FSTctKkMnpWZg+DT/CuQuIY6/i65s/bl/foAmiXR88q6esHIPma8+OzPxnV9PQtyj4NluxO8oRLGNucOEm8jOk0tFlyzq7rNrKI03m1TPGwTOGLhT2J0WqIeK1mVbW7KqvKRJ3hfOux0qpxOiEmldcsdIrY67+zaTJ8TcWhy9JdvFGGQGBy0Ho37zbXlGDCoI9bQMr+FeY27ortwqJ7Fy35mjw45P4OZTFRGoJIcCMAXMiab7G45JNstJMAcmNsXmhIDVovmSSJxbkyK0Ots/3ulhv9DrQcvlhZMx+QEW0DqOpo/J5J53sVHKHTz9CcYqyGLfAwGzT2lBDBiLP11wyYvc0X+LWryXgTmiIbOV87q7w8d4JuQCIe4CYB7GzTfSlW+ndxXQHf9x5pAsDnCUF1WeHQKqf3H4xy40EFswfSK3r9vh12D7RbOs2QhCc02wjAQjuIlLa1I8Zz9uM7upsFEoEnm8HOG/Dq6qNdG03bWu/G0s6Kjv5fspgSDtv1Hjvv2ZNHMQYqtKUz62zQXDqmbaGHng9sJDs9DI4Y3lLrKBD8AMgwlsl37hMCPS0nnbEvDJQN+8rHaLsoAaqZkXZq6XqlwMrjoFtBadyacyOGBlYUR6PvxJlhe9uOe8KLHln9xOA4pnlb5eJWHJkvE4i0XKkDnrqcMfws4gNXUjmMen2KxLolmjsN01+3bU6/FGVGko4M/Mzdh0vzjzN1BJq9KIeQJZ0fBHJfFMf8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YweMoRiPbFahWwuRFGyhucSUZ3oARevAKN8jlF96U5PJwuWloegvwWwA+N/Ecx3F2NrElcS6c6LHZTjOBdOzWuzrMeitdrIQLS5xFi9l9cDOFe3BTRkNw2Suyu94TAsqyEpXCAOKs0kr+/uuGkxcBR87nkin67s+1JWDasZO9dNF2JQJjf0XLRYYVuXViOd6MnT+HRUBG4MMvy2mtumEM9xo5oes0JdsuInbGJUS1LmBm2HWssxtKb5u6/CBWKLvKZuNbzsImslfd3/VkjKJd4xmNvVPoaiVKd1pQaFBnINmxxbUR61Rs3RdgwOtGi9bmY5eA6JhzkG5WNqv90QzeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c9f5332f-c0c1-4a45-9c1e-08dee9728744
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|35042699022|14060799003|1800799024|82310400026|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	71reDDo7couHTMP7GHu5RT9WSTnQ36tTJhRavBMaGmAxAN6EpMSyDHMoiyphvLyAbi0YLFZIOPZqsOOu4ufjr3th8o64nzvsIbmqhL6WwWupQxHILfqGMRN87ZVCsGYih5/uI5fRVTOM8iInAxN2ppYfzPf9X7YcW8c6iBBWlb8ILV9trYL6FtGhd1DKLt1kiNMQIr5Q9OxtcG2tfrdsNvsDboleysd26g10h+ZhsU45yShOQbfa/Zw+wJ7fgflTaO5i5rMzda/i2UPu/AtXIFUkCEg5QC6UdO1qArHMTT9QW5k1lBBW8Ke/V8ga2a30OzVM0HRS2meUe7jwwYsW1CPpBifjruNy7kSLWbWxYCFIpHn/DqI2FnPTCGk5dliJVD4RYhn1Z4DzMeLqvV4JubF6W+WHtjgqjQ7M6lBJVuzRlUwMHIStySRHtQMlWrgzkHkxrTsobTzBsgAfE/BV/Lhkhra4PPkofFFnXMeU3Ex38+YGsn/AU9V5sOmvjIk75C40c/MwQOLbcYlL77WeJtlxukmtk3yYOCTm08qVmBfGVvDzR0ChRuZp55DpE0u9nFWFAxiSd0XVsd4Hh6bMns+H4g9uvGlU1h5zMpIuxRjlNmhtFybeKEpKtZXl1VIP6Qw6C9WzPlAt2BJ1rOXZWB/Ya61M8uz3Jf/J4FeAMxInEIJHA1Qr7ewjVdrle1oeK7NpfHdoUmjNP4F4XF/FhQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(82310400026)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IULgFnD0TWVUbrXX/BgTZcyp479XaT5FiVqKJq1cWiMgbgT44FaYbrU8xguB/DcsA5xD9fBKVNLOPYfJo971Zg5eHApLPEdFul1H2x1llU6vwTfzxCTxcuBDdlWyZuZgC89DbGaaeMBamK9SUVcRgKTFEs4kf2B03dT94MzpwPXSigxRE3nGpEQNVBBObjo0hsCVsWh328o7H3uO9q+idrCePXZu2JyjogGNSvrmyv52C97RWIOZO1up/NPYnJ8fALbVg5Olh3k7+9N6XP2llP62cVoJHnlZzFwvOnqhJ6O5Prn6qqZVCuSYp7LqmxqhwbYO/txCnsNXzYdP5c4rhgFnIkbbeIUe2XRF9MqN1AF6q6ReLDX2QBSFQg7sOTlxFcR9lc2jbTbJ7lCL7lZvF2WxeO25ucQQKA91RJmayseBGMIBcuh3NOB86/e7LbMG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:59:46.5939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa83615-26fe-412a-3262-08dee972acbf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6514

Add coverage for the VGICv5 IRS address attribute. The address is the
base of the guest-visible MMIO region used to configure the virtual
IRS, so userspace must provide a valid base address before the VM can
run.

Verify that KVM reports the attribute, returns VGIC_ADDR_UNDEF before
it is configured, rejects misaligned and out-of-IPA-range addresses,
accepts a valid base, rejects a second base, and fails vCPU entry if
the VGIC is initialized without an IRS address.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 121 ++++++++++++++++--
 .../selftests/kvm/include/arm64/gic_v5.h      |   3 +
 2 files changed, 110 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 19039a8940568..51ea2fe7141ad 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -14,6 +14,8 @@
=20
 #define NR_VCPUS		1
=20
+static u64 max_phys_size;
+
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
@@ -25,6 +27,104 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+struct vgic_region_attr {
+	u64 attr;
+	u64 size;
+	u64 alignment;
+};
+
+static const struct vgic_region_attr gic_v5_irs_region =3D {
+	.attr =3D KVM_VGIC_V5_ADDR_TYPE_IRS,
+	.size =3D GICV5_IRS_SIZE,
+	.alignment =3D GICV5_IRS_ALIGN,
+};
+
+static void test_vgic_v5_create(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 addr;
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+
+	/* Check existing group/attributes */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, gic_v5_irs_regio=
n.attr);
+
+	/* check non existing attribute */
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "attribute not supported");
+
+	/* get IRS base address before setting*/
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret && addr =3D=3D (-1ULL), "GICv5 IRS returns VGIC_ADDR_UND=
EF");
+
+	/* misaligned IRS address settings */
+	addr =3D gic_v5_irs_region.alignment / 0x10;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GIC IRS base not aligned");
+
+	/* out of range address */
+	addr =3D max_phys_size;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D E2BIG, "IRS address beyond IPA limit");
+
+	/* Space for half an IRS (an IRS is: 2 * irs.alignment). */
+	addr =3D max_phys_size - gic_v5_irs_region.alignment;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D E2BIG,
+			"half of the IRS is beyond IPA limit");
+
+	/* set IRS base address @0x0*/
+	addr =3D 0x00000;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret, "GICv5 IRS base correctly set");
+
+	/* get IRS base address */
+	addr =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(!ret && addr =3D=3D 0, "GICv5 IRS base correctly set");
+
+	/* Attempt to create a second IRS region */
+	addr =3D 0xE0000;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS, &addr);
+	TEST_ASSERT(ret && errno =3D=3D EEXIST, "GICv5 IRS base set again");
+
+	vm_gic_destroy(&v);
+
+	/* Try running a VM without ever setting the IRS base addr */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS base not set");
+
+	vm_gic_destroy(&v);
+}
+
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -81,19 +181,6 @@ static void guest_code(void)
 	while (1);
 }
=20
-
-/* we don't want to assert on run execution, hence that helper */
-static int run_vcpu(struct kvm_vcpu *vcpu)
-{
-	return __vcpu_run(vcpu) ? -errno : 0;
-}
-
-static void vm_gic_destroy(struct vm_gic *v)
-{
-	close(v->gic_fd);
-	kvm_vm_free(v->vm);
-}
-
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -207,13 +294,19 @@ int test_kvm_device(u32 gic_dev_type)
=20
 void run_tests(u32 gic_dev_type)
 {
+	pr_info("Test VGICv5 Creation & Setup\n");
+	test_vgic_v5_create();
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
 }
=20
 int main(int ac, char **av)
 {
-	int ret;
+	int pa_bits, ret;
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
=20
 	test_disable_default_vgic();
=20
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index c388df8f2a2b4..41b698b3952f3 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -13,6 +13,9 @@
 /* GIC component base address is guest PA space */
 #define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
=20
+#define GICV5_IRS_SIZE			0x20000
+#define GICV5_IRS_ALIGN			0x10000
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
