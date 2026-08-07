Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011034.outbound.protection.outlook.com [40.107.130.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC5E43304D
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101201; cv=fail; b=XRTKn2HY56zbe7++mkk96Tze6HIXEVzTi2LKFbsIKTnByNb/gX1ecKw22yXtjMtLUtJIPVqO6tyEfnHvtyxThgVWDMWSFter7LJogoUOSr7hLUvjVMcjPEKh0ErW21BHenPMUg6QcxR/PTDND4PNtLxzyaOqnimkZJRWBf/IoIs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101201; c=relaxed/simple;
	bh=j4r1BIfgUux0qHfZII4ey9KV24X0jJL9zDxLKE7spfc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GAce9xHLvzcYezy9HMSMSCvCqr1YSVeWpB/IAsBQcDYAeN2piOl0fceqPQmujyf8tTaT5MKjlPQ/0zAJHg+4O/HHBMToYOF+04rgxGzF5A0cdN4SivJGbCKdFUR81MmP1Ldqabqa6xoSxrD2RyVPRsW2da7pbX9lRcLMcfqUA44=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l9Kg233K; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l9Kg233K; arc=fail smtp.client-ip=40.107.130.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l9Kg233K";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l9Kg233K"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BwC6j44/l7TCTBAas+93DECd8YMKwsT2KuKXgKAd1FCmZWAHQFRTExo6IGYYHTK4CygYG1+Pw2czgIYmnYfMTCOhrLjjSGEwO+KNM0rUViyCsUpHeROeI9LTyckgX9IZV7rM2l486fNULWM0iNyvSdUejJhC2bgNugVjKXEpfZSi5sSiBORngpLb87sc4Dl8GCFb3g/9y8ScBXGNKUjozEnIE9f2Ad3+zgMRNeI0Tvq+Y1n462oz6tGz5cBlPYyVqA/XDfgNWfGc9Mp6QMlrqutGsgQ6lwafM/GEipvpAkpyBQ1kUiSMHcCL/nBAk9cie/LAsy8wonEiKpi6sx6awA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BqRJcGtFE0jnchBpgqygjBOtIQPPyAbdeof+4AzzgA=;
 b=sp2mk5Q1vgi5d614by+LUFpSZYaMZt8DtJ6GK0C50eJiaMM0p36ghP+8kQAU1MdFGhgifgycl0Ru92YZjBg74UJ9yg1mHng2hpZAKH5Q/IwXoDZVpS+uEhwabYf2TzpKMWitWWbaGcirHmupUEY0ZslkZfm/5Ka1/Lk7pW4NpbKy+IR0XEjIlp7Eh6YvHpYQbWBBuH4rhE9NrwwjoJifGVUD9njX1X+lj2NH+RH2ghGthNhJJT79Bv48R4mthfGqN8gmqDcahVviyG+eW5fQv+BxWIW1vZpAkXUnp5I0tOcbuK66up0tH2Vi0XslxSO5nZpNibuQw7Pfgs0ApbB9yw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BqRJcGtFE0jnchBpgqygjBOtIQPPyAbdeof+4AzzgA=;
 b=l9Kg233K1y66K8sWxOamcpUenXVR0dEj3KJVCQRaJexJP0t8JsICeUPL8kKOwYU43//QQLtu3tg+CKN7W0hh3uLSW3nBc4iff0EkiKqXZjBwBKRVJxyOEgJWPVfYOhbxNpBiN0BgDrvR1Mr6hviC5UlfafAYOXu406itV1aIrrI=
Received: from DU2P250CA0010.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::15)
 by GV2PR08MB9302.eurprd08.prod.outlook.com (2603:10a6:150:d4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:13:12 +0000
Received: from DB1PEPF00039231.eurprd03.prod.outlook.com
 (2603:10a6:10:231:cafe::6b) by DU2P250CA0010.outlook.office365.com
 (2603:10a6:10:231::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:13:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039231.mail.protection.outlook.com (10.167.8.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:13:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etLrS3CMrvZkDTNFNdxvwLAE36/OePoby9pBNTVlM2i5Z4RRwcnGqVXrA7PTOipoExoURbZuAdmowHGKs4yMMus5Ah7vP411rjwc5T/1uI9DSoXAz8mo3GQXh6eb0n0pEevwUvwaWgbGAfF7N7pLk6NmDNTUSfQilcg2rhI+f0aylTK5oqIDwL90wNpXmJqMIQyWxxUTnZBX2Uymmlh7h1hn7PUTkCnfENxXbkhOnNH9rqbMWPW7I+tIAST6PY9g7SwBDCjpzxIqoZnsd4GsoruOTOQ0z/nDMcEHJ02FhqIT2arp+/UWWNjS14cbthsUo3zjjtr73lXrjyI9zi+kEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BqRJcGtFE0jnchBpgqygjBOtIQPPyAbdeof+4AzzgA=;
 b=teIOqVaXECl/YAGzq8f/9VdlimvgQz/Pt6ZK3kM47cFdsHJve2ZV6tJ7qnMlua+UF5yEkZCBqXLXmuV4i52i+Qk+2s255NvE2fH9Oz54sLH4zM3H49No57WEq9ghL3NRbh4IKJFEzMeajAXSM1I9McfEK4w3ZfsWSi7+c85L3SZtVhft0bynsSiOrH3fPq0HxeeCDeE7vCrFGaw5OQ3AhC9z5dnWnn7WddJIKw2DOhIXVuQ6iA5Ynd4atmN4FQQgMaIOwygob1Q1wbAdlEVSCXe2+zYRUZEcjD2rWLHyZop/cxTDD8xk5287ZXAmpP3DEVuGI77HawWLRFs55b/UBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BqRJcGtFE0jnchBpgqygjBOtIQPPyAbdeof+4AzzgA=;
 b=l9Kg233K1y66K8sWxOamcpUenXVR0dEj3KJVCQRaJexJP0t8JsICeUPL8kKOwYU43//QQLtu3tg+CKN7W0hh3uLSW3nBc4iff0EkiKqXZjBwBKRVJxyOEgJWPVfYOhbxNpBiN0BgDrvR1Mr6hviC5UlfafAYOXu406itV1aIrrI=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB11562.eurprd08.prod.outlook.com (2603:10a6:150:2d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:12:36 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:12:35 +0000
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
Subject: [PATCH v5 00/49] KVM: arm64: Add GICv5 IRS support
Thread-Topic: [PATCH v5 00/49] KVM: arm64: Add GICv5 IRS support
Thread-Index: AQHdJl2m4vRLAxRV10GQ5hp2Nq8IaQ==
Date: Fri, 7 Aug 2026 11:12:35 +0000
Message-ID: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|GV2PR08MB11562:EE_|DB1PEPF00039231:EE_|GV2PR08MB9302:EE_
X-MS-Office365-Filtering-Correlation-Id: 0820b46c-2e36-4051-950c-08def474de35
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|11063799006|56012099006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 QPbwMc/hKgpyqpGNlqJFFEYGlyXIlisQohoDubp/nKKosN0DwDSmfa+/NTf0YchWWwyMDIDRzuaJG8bfvx9O+vMwaeHbnhjY5BXrc2QuzkMn+VXxzC2/W9SIcvtxtCAgFiqIdiIrBs9C1Rkwz/K551kR1i+bsUpmVgV7Bp8LBjKbJebokiPVTd0OvDyJk16Se2Vpv/lmVxiO/zg5zVrpsFM63CXh/0gXDrgSZjatru8EfW46o/ps2Ils8Z+UC/oUMo+cJhU36XpEkUCDmbttPB0RGoyTucZSjAPdOaqbIPEeRB1D4zh7bzuvut5I+2Occ2YMh9rSp5J4M+aH0PtRZNpKTPmh3dL01EXgRclFTjkcHRW1++/TusfWr0CRDPjOiSk1Ni0eQmNvNupuSEtPEW/IgLSB1JBr7VoPg8ze5KzP/5NVWcwXVyypqedS/KortgRPLqNFi+CdJBc+BLkyczDbQWzr53NFUQNAdxUvoemUDKchfjLNxpVRhVPXUJY6VikltRcP7JSxbwNoPGG3wnamqDWYjfR8zEETA4SqvwvFrr2XT1XjnlHpWNmUpUgzXbnR9jbdt0MqaZZ7MKoHHI4t5PbDKreSLYNvQZnhWypZETj9H4Ul1Tc/U1fXPvvnR26crhnZZ7LWjYL1oYxQX4vRSlIhQ2BjOOKUP4JmkEqtMjy6EGSdYu4kA4RTKCuEubKi2K0VvahcxOY0/aqr4MA/t2jgXFY8/Uini+PP8K8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(11063799006)(56012099006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 H0CF6VAB2+sOFTrHTk2LYa9iDLPdxiW6zgl9Isuw9WQ7tnUBhXCwUKMR0SzMnD6bdVAFve/oTQh1q06JzSwMHkUD8UmIzyJ6/9/g8D4UrN5+e+Ia0aUje6k2CInNKrjnYtFR1I0WEoP0GxVraxkqZ+ALQr8NTewOE6eVw6H6inKbFCNQxIY+a+RDO2YqwGCdtucIf/NxUMgFt9m5gH/3GTKXO8VwsUR37tcIiOXItDYUJI7uVi3VKK1DST9Ii6JlzkyCOHRdN0YiSqAC39nid/e6zgp3s21e5KlaqZhM1Uu1ln3C9rqB3fMbr8pOTECxg6uZkwszWogCf92MHQ+bHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11562
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d57ee2ec-385b-490b-6a0f-08def474c8f5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|35042699022|36860700016|14060799003|1800799024|82310400026|13003099007|6133799003|10067099003|11063799006|56012099006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	mb8RTD0gez1xeKXnzYpVerwNHeajczXqGJOmAu+C22qnEQypuCo2Bb9lj5n44PF/mNO+4skG/T7kqQor/lcMnp6fvFsluIQNgnWaBwRHW6MMTTfTihsskAxKa/ddimpvSzQKwN+EqvyvK2l5e0BJEWFhIXTyt53XUtPx78WceyHqWkU7INQ57AVi2H0izP0plSKo/rz62Ka4He0YFPyXWyTzpB8xlvpULcLkw1RVkFE6qRjAHJFBjpVfoiX/G2vPG3B821xFTcFXBwf8VWHz54rys67qdfiuNe4mY8k6PimvdX+nSuv9RxskjWvD2BsvbnY8IZZiUoZgbQKFDqzt4c1gBwk25tMUr4Enmb2rjNIu4jHQQCUJ0/mC5bet0Bi9k7ZXGfyUlHUmpCBISgZQRcL/LqctoJiwd//Bw3xQ033UH7TFQa7b/ZtFkU4T5cD6tCOdUp1dWWSqYPdA+pawlxMsxvhIPpolZdEBc4x8Dbv3CsDeqVZ2dQfw2n4I/K6AdZFoyO4SNDezvi0o7Q7e7JHqT6fAOAfReeHFgN7+cAfmGuAO02tLpfaOdecWAjpUro4h3q7Zwi/x/F6RXd/K7rXAY3MCNGQHOLvt+Jkgls80TwWBdSWqL8bfvRQFzvaU7FYz1kAZZLv0NVlnT4Axgd1zBHCBQboEJCd3QcYCwtjRYclwwt+t4knvWD7nxamKogNg1lCl5KVPaR4k95PTKQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(35042699022)(36860700016)(14060799003)(1800799024)(82310400026)(13003099007)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WmYbyPBGP/MYkhpgMgl27M75de1he5U89qLa9WIsIgpL7qE3RehDR3W68GlL0JLqX8qnN1Bjf4LblIu5ArF3AnFKffKh17AauetCZfZWqFmTCnfzW3bx9QDndzFlSpO6HOikDuREXYvJIeQpzt97OEx8kA3tA7yi0HOeFyir0d5/JyQqH3bVU7VaKzQrGU1g1MxLMwK+8YAMDCa52iLrVgIVkg2P3ylh4Lhh1PO+XB3jT1hM7LSA8oYnqJ89izDZswP8rBQ2kLGjf0UqtxUDB+slmP36fe7LsWsRyJ1jBF47T/Yhjn91kJm0OtmxalhHMnTL8QzzRs5Bf4n6gNO8z6QDpvjDhDVXVCoKjZIfxD6MFhkUVAblnBsslGYbzrLBRcZFrRs732LQhucL/3/kDOCS/wUEJw81rLsfAE2A82YHf0JFMHyUtxa4YYV63f9E
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:13:11.3522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0820b46c-2e36-4051-950c-08def474de35
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9302

Hi all,

This series builds on the initial vGICv5 support [1] and adds support
for the GICv5 IRS, as described by the GICv5 (EAC0) specification [2].
With this, a GICv5 guest is no longer restricted to PPIs, and can make
use of SPIs and LPIs as well.

With SPIs and LPIs available, this series makes it possible to boot a
full Linux guest on the Arm FVP model [3], using the setup described in
Lorenzo's GICv5 Linux software enablement guide [4]. In addition, GICv5
IPIs are typically implemented as LPIs, so LPI support is what makes
guests with more than one vCPU possible.

The corresponding kvmtool changes are available separately [5]. With
these changes, `--irqchip=3Dgicv5` works now. The `--irqchip=3Dgicv5-its`
configuration does not work with this series, as ITS/MSI support is not
included here.

The IRS is created as part of the vgic-v5 device, and is not a separate
KVM device. This is because implementing the CPU interface alone would
limit a guest to a single vCPU and PPIs only. Hence, the IRS is bundled
into the VGIC, much like the distributor for GICv3.

The series adds the host-side plumbing needed for KVM to interact with
the physical IRS, including VM and VPE table management, VPE residency,
and VPE doorbells. It also adds an emulated IRS MMIO interface for the
guest, together with the UAPI needed for userspace to configure the IRS
address and to save/restore the IRS and IST state.

The main pieces are:

* Host IRS capability discovery and configuration frame plumbing.

* Allocation and management of the GICv5 VM table, VPE table, VMTEs,
  VPEs, and host-backed guest IST storage.

* VPE residency and doorbell handling, allowing the IRS to select SPIs
  and LPIs for resident VPEs and wake non-resident VPEs when required.

* Emulation of the GICv5 IRS MMIO CONFIG_FRAME for guests.
  Virtualisation, MPAM, MEC, and SWERR are not supported and are
  RAZ/WI.

* SPI injection support using GIC VDPEND. Once injected, the GICv5
  hardware manages the SPI lifecycle.

* Save/restore support for GICv5 EL1 system registers, IRS MMIO state,
  and guest ISTs. SPI and LPI IST state is transferred through
  userspace-owned buffers using KVM_DEV_ARM_VGIC_GRP_IST.

* Documentation for the new VGICv5 IRS userspace interfaces and the
  required save/restore ordering.

* Selftests for the UAPI components, the PPI, SPI, and LPI support, and
  save/restore.

This series keeps SPI, LPI, and save/restore support together
intentionally. SPI and LPI support are needed to run realistic guests,
while the save/restore interface is included at the same time so that the
new userspace ABI is complete from the point it is exposed: userspace
should not be able to create VGICv5 state that it cannot also migrate.

The IST migration selftest restores state into a separate VM, re-saves
the SPI and LPI IST images before the destination runs, and compares
them byte-for-byte with the source images. It also validates restored IRS
MMIO state through SPI/LPI delivery, priority, enable, and affinity
behavior.

LPIs are explicitly driven by the guest through the IRS/IST state. This
series does not add direct LPI injection support, MSI support, or GICv5
ITS emulation.

These changes are based on v7.2-rc6. I've pushed the full set of changes
to a branch at [6].

Changes since v4 [7]:

* Rebased onto v7.2-rc6 and addressed review feedback from Marc and
  Fuad, together with the Sashiko AI reports for v4. Thanks all!

* Aligned ACPI maintenance-interrupt discovery with GICv3. Broken MADT
  descriptions now produce FW_BUG warnings rather than preventing KVM
  initialisation, and the interrupt is always registered as
  level-sensitive.

* Reworked host IRS capability discovery to cache raw IRS_IDR2,
  IRS_IDR3, and IRS_IDR4 values and derive their fields through
  accessors. This avoids tying future EL2 code to the decoded layout
  of kvm_vgic_global_state.

* Hardened hardware-shared table handling for non-coherent IRS
  implementations. IRS operations and CPU table accesses now share a
  lock, VPET, VMD and VPED allocations are rounded up to whole cache
  lines, descriptors are initialised before publication, and VMT
  configuration waits for the IRS to become idle.

* Fixed sparse vCPU ID handling. The VPET and architectural VPE ID now
  use the userspace-provided vcpu_id, while doorbells and VPED storage
  use the dense internal vcpu_idx. IDs outside the available VPE ID
  space are rejected.

* Limited virtual GICv5 implementations to 1024 SPIs so that the
  physically contiguous per-SPI state allocation remains within
  KMALLOC_MAX_SIZE. The common IRQ routing table accommodates 1024
  pins, while route validation retains the existing 988-pin limit for
  GICv2 and GICv3.

* Tightened LPI IST lifetime and migration rules. Guest Valid-to-Valid
  IRS_IST_BASER writes can no longer change the address, and once a
  host LPI IST exists, userspace may replay but not alter
  IRS_IST_BASER or IRS_IST_CFGR. LPI IST saves also require the VMTE ID
  width to match IRS_IST_CFGR. The IST migration descriptor has moved
  into the arm64-specific UAPI header.

* Hardened IRS and doorbell operation. GICv5 probing now fails without
  a host LPI domain, commands require a valid doorbell IRQ, running
  vCPUs are reloaded only on IRSEN transitions, and WFI doorbells are
  requested only while the virtual IRS is enabled.

* The resident, non-resident, and VDPEND nVHE handlers are explicit
  no-ops under pKVM. This matches the fix by Fuad for the
  already-upstreamed GICv5 hypercalls [8].

* Expanded the selftests to cover the 1024-SPI boundary, live IST
  register restrictions, sparse vCPU IDs, and rejection of vCPU IDs
  outside the GICv5 VPE ID space.

Thanks for taking the time to look at these changes!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@ar=
m.com/
[2] https://developer.arm.com/documentation/aes0070/latest
[3] https://developer.arm.com/documentation/108086/latest
[4] https://linaro.atlassian.net/wiki/x/CQAF-wY
[5] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.=
com/
[6] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support_=
v5
[7] https://lore.kernel.org/all/20260724104819.1296803-1-sascha.bischoff@ar=
m.com/
[8] https://lore.kernel.org/all/20260806100256.371164-1-fuad.tabba@linux.de=
v/

Sascha Bischoff (49):
  irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
  irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
  irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
  KVM: arm64: gic-v5: Define remaining IRS MMIO registers
  arm64/sysreg: Add GICv5 GIC VDPEND encoding
  arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
  KVM: arm64: gic-v5: Cache host IRS ID registers
  KVM: arm64: gic-v5: Add VPE doorbell domain
  KVM: arm64: gic-v5: Create and manage VM and VPE tables
  KVM: arm64: gic-v5: Introduce guest IST alloc and management
  KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
  KVM: arm64: gic-v5: Keep GICv5 vCPU limit model-specific
  KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
  KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
  KVM: arm64: gic-v5: Add resident/non-resident hyp calls
  KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
  KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
  KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
  KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
  KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
  KVM: arm64: gic-v5: Initialise per-VM IRS state
  KVM: arm64: gic-v5: Register the IRS IODEV
  KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
  KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
  KVM: arm64: gic-v5: Add GIC VDPEND hyp call
  KVM: arm64: gic: Introduce set_pending_state() to irq_ops
  KVM: arm64: gic-v5: Support SPI injection
  Documentation: KVM: Extend VGICv5 device attribute docs
  KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
  KVM: arm64: gic-v5: Mask per-vCPU PPI state in
    vgic_v5_finalize_ppi_state()
  KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
  KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
  KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
  KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
  KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
  Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
    VGICv5
  Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
  Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
  Documentation: KVM: Add the VGICv5 IRS save/restore sequences
  KVM: selftests: Add VGICv5 IRS address attribute tests
  KVM: selftests: Add VGICv5 NR_IRQS attribute tests
  KVM: selftests: Add VGICv5 IRS_REGS attribute tests
  KVM: selftests: Add VGICv5 IST attribute tests
  KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
  KVM: selftests: Add VGICv5 CPU sysreg attribute tests
  KVM: selftests: Add VGICv5 SPI injection tests
  KVM: selftests: Add VGICv5 LPI delivery tests
  KVM: selftests: Add VGICv5 IST save/restore coverage
  KVM: selftests: Add VGICv5 sparse vCPU IDs test

 Documentation/virt/kvm/api.rst                |    3 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  271 ++-
 arch/arm64/include/asm/kvm_asm.h              |    3 +
 arch/arm64/include/asm/kvm_host.h             |    1 +
 arch/arm64/include/asm/kvm_hyp.h              |    3 +
 arch/arm64/include/asm/sysreg.h               |   13 +-
 arch/arm64/include/uapi/asm/kvm.h             |   15 +
 arch/arm64/kvm/Makefile                       |    3 +-
 arch/arm64/kvm/arm.c                          |   10 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   35 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               |   45 +
 arch/arm64/kvm/sys_regs.c                     |    6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c              |  519 +++++
 arch/arm64/kvm/vgic/vgic-init.c               |  150 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   18 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1184 ++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  270 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
 arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1860 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h          |  140 ++
 arch/arm64/kvm/vgic/vgic-v5.c                 | 1139 +++++++++-
 arch/arm64/kvm/vgic/vgic.c                    |   37 +-
 arch/arm64/kvm/vgic/vgic.h                    |   21 +
 arch/arm64/tools/sysreg                       |    4 +-
 drivers/irqchip/irq-gic-v5-irs.c              |   19 +-
 drivers/irqchip/irq-gic-v5.c                  |  112 +-
 include/kvm/arm_vgic.h                        |  210 +-
 include/linux/irqchip/arm-gic-v5.h            |  256 ++-
 include/linux/irqchip/arm-vgic-info.h         |    5 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   15 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 1931 ++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  105 +
 33 files changed, 8208 insertions(+), 203 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

--=20
2.34.1
