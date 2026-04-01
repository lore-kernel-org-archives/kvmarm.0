Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011036.outbound.protection.outlook.com [52.101.70.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D78739B951
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775060589; cv=fail; b=NUv6eOSoODHNGPV8f+W/GUqfIGsbZN2QcUtAfs102vNKYHpqfx6vHMgKbrUqzhz0yJENeMiGqzBRwvO4UB3HI684sjh6U0vD5bai2GvQs/hWV7JA+cnR4e7m+TSEdLexMC2P+VV2tdQqT2eUIObmoHTCPMe/RLj/nlKPEAnXYGs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775060589; c=relaxed/simple;
	bh=5l/g/0CfSRc1e7WOW9M9XSTkZ7SjTd9hmWN57npOxb4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=No94ct/E21WWBjNwtSsxbFPJrNLp3Sm/tqsW0KQWOALpLpzuRbEfT69jL8OH+qJPvv04M1f1CL6C7aI2frv51ITmanobzy8+ACHLp/GFbByVsxXPsmlC/ObppSNr5M8Ce1xZEWTY4I+nK0MOkxVpwL9zwutKPxCHEmNYtQgnFRE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qTTEsHU1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qTTEsHU1; arc=fail smtp.client-ip=52.101.70.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qTTEsHU1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qTTEsHU1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NbcY03Cgjh0O/TBlNEaWt56aPrf4aHk2PhO1tRP2KcpRALngyEzWpMgBNO9smH6VJQENaMEGBkTmPYvsa7ldZNirzeik0uYpBFnmWJCWqEa3lLbULSPLyOINSN1xXOL1Fr9nFHD13o64OlabLqyeqhbLQjGbitlyrECHn1ENhuVNK1d3gvPzm7y2eo935ZVr6W0yxf79MvlviPurivWDMfzCPN8yUd7bCF2YoM3ML6Ve1WdSLNmSYS/2bXhpmM+ktT2g0chyPzhU7wcEQ79+dZ8r7O9po4rdqhKYs2a2tq+k0QCrHPJEsr/vpAAqsPYTUnHCKA/S4ih14rDDhRIJrA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IV5Af936hUwI51CMAETSccI5Fp94i9wAOweF0aeOhE=;
 b=ArcSoV8Il6E6kvqO837njzrLMIx9Yx3h8+/hcz3c8IQsmVzViHu0l93RXWTOEb95o0dUai4gmhzWsXsGgmErAt3YqSt55Pv00VZqXeiHHz+749mk5oZoxwBh1gehX8nJtIoHIGd/nTBxMZs0tEcfBBA5pQ9WPAzFqOVkUze7/cGqMoGVyky7D5FKy7EYvjK7HL1vN115a5V29O01Dn25MMB6UNry4xNXShK+f/hacmNY1APuZOre9aqyn0ofLVV2fHO9R8M7MDIEI5QAUKqVLqLRKiU7fl56gJil0DTBgiDAwwBGahJ89v7G18+FEvgb99fm1vvfrlutLJucTP59BQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IV5Af936hUwI51CMAETSccI5Fp94i9wAOweF0aeOhE=;
 b=qTTEsHU1PuBQ3tzpXzZnt6NSz9XuIGdAlKng4+ModD8LK+uXZhtOiKBFPiVsU7nLFJhrROwWZZcQ4t8d/lufDPyQrS5gKnAfyR6z+qIAKX7erDEIiQAaVjwBgo7uuYuQwWL3Rpd71K6tEEvzBYxoKNUE1qcHoYh0SmYwS7IihSw=
Received: from DU2PR04CA0328.eurprd04.prod.outlook.com (2603:10a6:10:2b5::33)
 by PAWPR08MB8912.eurprd08.prod.outlook.com (2603:10a6:102:33d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 16:23:01 +0000
Received: from DB5PEPF00014B95.eurprd02.prod.outlook.com
 (2603:10a6:10:2b5:cafe::79) by DU2PR04CA0328.outlook.office365.com
 (2603:10a6:10:2b5::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.30 via Frontend Transport; Wed,
 1 Apr 2026 16:23:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B95.mail.protection.outlook.com (10.167.8.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.17
 via Frontend Transport; Wed, 1 Apr 2026 16:23:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ds7XSQiZWzwbXLu6PU4m+S48F/dG1MjENBzFqwYfIlDBQofdirOgsaaSyR0ZI3Q19T4fr5ydoAGTywf2/ewH/jfit5OsCLjtbZC5KYeOIv2ctFHpw3mU42G1lpTvo0EslSpyj+JiO3mmX/aOXU64Y1HAJkJs/mi0xV1vwotiptng3SEiEjMXk0w3mvuNVrng9WDW5YGOvhjEWQgOJT9q7JNC3L3rS3VCWaOyo2n/xmyOAz97OoTSkLWGBqi7aO/aPinlLa0mif96jsKHcQeh58Z/saYz/j6E/zaA5WgeQJRWY8Nw3C3AXjN76Xkyq5ICslWSF1rOUg0BFs9zacX1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IV5Af936hUwI51CMAETSccI5Fp94i9wAOweF0aeOhE=;
 b=DYF3gCi/LEzoyzk7V5BLgNu6WUP6aKJ9SPd6pWt02osFKMkh7t/zpDdhFRl3sG5UtFpmGsdnZVoXqcNGAesgmX5Pgcfw+SkPnhHSHdjJLDF656Heviz3jHujv3hZgUfroOvw4vdKe/qLdtNEojON6tE7bF8rUSY1TZjWpmn3GrvQBtCLjGO8giBY6PWZfWefYLClp8SSgA9XwHA/aoDwVhzQiASbvW57RcyTG+x7RVkxVPyeFR7mOGhhicelc7zHcsE7W/y236d59wY46SnzB7olkm3Fe8KZ3ifbTSY1p/FMK5Z02dUime7UoxLDzSJRCnIQJF/PWIr/dE2KoMM/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IV5Af936hUwI51CMAETSccI5Fp94i9wAOweF0aeOhE=;
 b=qTTEsHU1PuBQ3tzpXzZnt6NSz9XuIGdAlKng4+ModD8LK+uXZhtOiKBFPiVsU7nLFJhrROwWZZcQ4t8d/lufDPyQrS5gKnAfyR6z+qIAKX7erDEIiQAaVjwBgo7uuYuQwWL3Rpd71K6tEEvzBYxoKNUE1qcHoYh0SmYwS7IihSw=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI0PR08MB11646.eurprd08.prod.outlook.com (2603:10a6:800:308::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 16:21:58 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 16:21:57 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "broonie@kernel.org"
	<broonie@kernel.org>
Subject: [PATCH] KVM: arm64: vgic-v5: Fold PPI state for all exposed PPIs
Thread-Topic: [PATCH] KVM: arm64: vgic-v5: Fold PPI state for all exposed PPIs
Thread-Index: AQHcwfOpGfOoVj9MZkKxsX8ZIufonQ==
Date: Wed, 1 Apr 2026 16:21:57 +0000
Message-ID: <20260401162152.932243-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|VI0PR08MB11646:EE_|DB5PEPF00014B95:EE_|PAWPR08MB8912:EE_
X-MS-Office365-Filtering-Correlation-Id: c25339d8-b0b3-4890-0a92-08de900af1f6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 VfFzdN9JbMaZc1q+gXrRZaE7J3B96HhVVTPPO5Lsy/tq92d9T6CGehkdpmWYu6o0DcL2euyzTVKWNzIIbvd8lHFOk9SoMRVaZU9iDEq4XotHpyBiTdzsdttmqXXOpM4hMOZD2hcZUMzjiImRTEwIZ0ZzS2xVUkUo/MrC1QifYQbybQzypMIvozGWq5lq6FzVOrqJ4M4U+ioQgFbtb97GsULOdUy3VrokMWBq69iexn2r6iRnL2bVIF0Y3H343NecH/IZlPL9hbSRnW3pzKhF+/AMzeffQupdDKtobgcjTpMsE01ZnT/TSOL+buhRMtgkmbbjQ60VoHykuNecvGpe383aUcrI/f28OQldBcPSR6dBAcOcB8TOD83BzpnIE0W+mxNq7g7iEZjSSlLgTY13SjWULKS+fryngYuNCWDrc9XNCe0xFg9FI5XCfB9/y1H175BlTJkxbi0DEi4KrFSMa041UHvyvDUU3HZ3Y3UijZiQpVm9gtSOZ3nU4hHtpfl4+EiL7TmLCaffbekZmy3/qScXwtqYVAb9yevr04C9pZZFzoAO1rDL9BzMjcS2GipGq4qxmZNg/rwbxxmS70XTvq95szIir6FSZBSLF8u5nYyaD2O5aGZU4gOEG7eFrsVUP/cEq505z1ZuTMyPqP6uQzSym+RNShmdFVOW5GpB2OeW0x5jHhAniX9gDaw0tpR9qVBElebpSo6obeG1DYpawzXeoGzFOvf5fXp5UeFPM8OuU1A7sOHUd39F+n/wIaZVTJhuRfVw3TJpuJh1fsjMXWQ/ea8WwjE2ZQowjkg9+bQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 IxqDr40YLB0l6IxYT6BDc7W83jK0TQZHqyaHO8yncE2c99hw6Q8rrM7sBtc5ifL8BH95TI2NfQ6S1NYKbD3wTX3le7UWtTpMLyNvE28oxD9j1SLEfENqfTQgn0Z8p5guI05XmrqYYPWC9n4YF2qwm6W/v+G2Mv7R36bioBOLWbE/wOhFmWPiQNPcaQM3i1Vdwkl9f6jzi3dHqq6/oTvIb6tgW0gKdoz9/vUZzxJgPE1eP1f8r/+JEvKNNcpKcBY7MFRoGnrOVt0Sp8i/0ICuZqVTcMo863So3+acRgjcAgxu8AmRvdAdk74p6SOagnz4RRPEPu1KY6qeAz4J6RChBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11646
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d7c8b113-c6e1-4570-71db-08de900acbee
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|36860700016|35042699022|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eP8M7o9vFpzW7CR1ZWMfCouJXKQ4CLgceoAGo0vyfbEBPhfCw3IE62ej1ADZMoxKsr0xOpKQHAJ0hq7zT1+NLnsRnijxSMv3o0icJzQfNWK0riOcIdhEKX5b8yNGL/OmvqZpHHvhDdY8IYHU6VGk4MGbQ7EVwweitTEFDhF/V4eOPVVaYp1ICwmQh/bEh7ujln3GMvueV4MWuUCZCV14+rR3GVw3d/WzPQAq2tw+gUpYzfbg7v5ATVr6dbmzjATePu3FDqD2zM8EN32hjXws17mH570S6B1UxYiQdbo3jENlArBm1yMABVQ0Q2qTG2QmYTaxVkPASUx9OXB0jEbu6S5T5xdZayyn0m9rNJkOlaCoMU8igHFCmuzTN7NGAGO2VBONx9oB0Y+SS2gOvXpKAm2ZqXfc0i8U47JFFmISQibJ7pgskX1REa6amfNTc/pS4ZMVwIm8aJ2Vw31LCKjLaucQ0rNbNeTnql5YGECZr5mZxXON4W+UKxfNwhYXvpEmMXj481n4wkSYxvRRta4rMemvSIVGyx/NKhVAx3igXRojzmcvqVdsu4ihzlANfGRklviswSxbJbJMQoW1irQkbtLfWisgCjcCecga+8lFjl9RnRUNPORHLwHiFJcH3mmWW1ZxFx0WRR0UXAnclVDr59a7sCwV5PCFJfJDP181UEILx/2D9pu42U39Sl+tvaUmmEPvmmBUdzlX64T/PTxiNIhARyB35uqHxVU8pbSz6JomSehbcVS6msAtzsPhMkVRu4B75lFjU7G4+54ZGMkeUg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(36860700016)(35042699022)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PhhXLQTxgXBHJ1WDjmMv8tASEEqfoLUTrPg8omQmxDGnKncWozsTUwgU7ZQOyQrmPOHnOHd/k8x7kxZ+d4gCAauAXmMZYqH8umuoX28sUk2wsXptqLkeIQ2GRGjQouPuyUgJTBAn2acFMxVpavzAzTnuzLtFaZfvDCH463z9dqhxVC3iq0WH3IuZJ7vyCXdDN3mbrO9dh3xYk9usgY58wxluIDrKnRVEVSYNiYN0KOTSqX9D6vLfSLx4MteTYAVzhlD2IxOfgoDHYzSqQ7E3sZIPphN7906kneR6oZWYW5ak6clHyV2OB5BVCI+UcYeUjKSSq1EC/iIu+oZc0B+DBuWzulg405WzxUE3BMws7s16CSnMD1w3yrlMbeBehtzeF3KQCD6BFZcUOCSQHILxzyKNNI/x+8upvDMazkEJ7LgYZmz+4IRZpGTO4gbk0uQz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 16:23:01.5464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c25339d8-b0b3-4890-0a92-08de900af1f6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8912

GICv5 supports up to 128 PPIs, which would introduce a large amount of
overhead if all of them were actively tracked. Rather than keeping
track of all 128 potential PPIs, we instead only consider the set of
architected PPIs (the first 64). Moreover, we further reduce that set
by only exposing a subset of the PPIs to a guest. In practice, this
means that only 4 PPIs are typically exposed to a guest - the SW_PPI,
PMUIRQ, and the timers.

When folding the PPI state, changed bits in the active or pending were
used to choose which state to sync back. However, this breaks badly
for Edge interrupts when exiting the guest before it has consumed the
edge. There is no change in pending state detected, and the edge is
lost forever.

Given the reduced set of PPIs exposed to the guest, and the issues
around tracking the edges, drop the tracking of changed state, and
instead iterate over the limited subset of PPIs exposed to the guest
directly.

This change drops the second copy of the PPI pending state used for
detecting edges in the pending state, and reworks
vgic_v5_fold_ppi_state() to iterate over the VM's PPI mask instead.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  9 +--------
 arch/arm64/kvm/hyp/vgic-v5-sr.c   |  6 +++---
 arch/arm64/kvm/vgic/vgic-v5.c     | 28 +++++-----------------------
 3 files changed, 9 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index a7dc0aac3b934..729bd32207fa6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -803,14 +803,7 @@ struct kvm_host_data {
=20
 	/* PPI state tracking for GICv5-based guests */
 	struct {
-		/*
-		 * For tracking the PPI pending state, we need both the entry
-		 * state and exit state to correctly detect edges as it is
-		 * possible that an interrupt has been injected in software in
-		 * the interim.
-		 */
-		DECLARE_BITMAP(pendr_entry, VGIC_V5_NR_PRIVATE_IRQS);
-		DECLARE_BITMAP(pendr_exit, VGIC_V5_NR_PRIVATE_IRQS);
+		DECLARE_BITMAP(pendr, VGIC_V5_NR_PRIVATE_IRQS);
=20
 		/* The saved state of the regs when leaving the guest */
 		DECLARE_BITMAP(activer_exit, VGIC_V5_NR_PRIVATE_IRQS);
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 2c4304ffa9f33..47e6bcd437029 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -37,7 +37,7 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
=20
 	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
 		     read_sysreg_s(SYS_ICH_PPI_ACTIVER0_EL2), 0, 64);
-	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
+	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr,
 		     read_sysreg_s(SYS_ICH_PPI_PENDR0_EL2), 0, 64);
=20
 	cpu_if->vgic_ppi_priorityr[0] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR0_EL=
2);
@@ -52,7 +52,7 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
 	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 128) {
 		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
 			     read_sysreg_s(SYS_ICH_PPI_ACTIVER1_EL2), 64, 64);
-		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr_exit,
+		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr,
 			     read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2), 64, 64);
=20
 		cpu_if->vgic_ppi_priorityr[8] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_E=
L2);
@@ -87,7 +87,7 @@ void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *c=
pu_if)
 		       SYS_ICH_PPI_ENABLER0_EL2);
=20
 	/* Update the pending state of the NON-DVI'd PPIs, only */
-	bitmap_andnot(pendr, host_data_ptr(vgic_v5_ppi_state)->pendr_entry,
+	bitmap_andnot(pendr, host_data_ptr(vgic_v5_ppi_state)->pendr,
 		      cpu_if->vgic_ppi_dvir, VGIC_V5_NR_PRIVATE_IRQS);
 	write_sysreg_s(bitmap_read(pendr, 0, 64), SYS_ICH_PPI_PENDR0_EL2);
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 8680a8354db9d..fdd39ea7f83ec 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -385,24 +385,14 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
-	DECLARE_BITMAP(changed_active, VGIC_V5_NR_PRIVATE_IRQS);
-	DECLARE_BITMAP(changed_pending, VGIC_V5_NR_PRIVATE_IRQS);
-	DECLARE_BITMAP(changed_bits, VGIC_V5_NR_PRIVATE_IRQS);
-	unsigned long *activer, *pendr_entry, *pendr;
+	unsigned long *activer, *pendr;
 	int i;
=20
 	activer =3D host_data_ptr(vgic_v5_ppi_state)->activer_exit;
-	pendr_entry =3D host_data_ptr(vgic_v5_ppi_state)->pendr_entry;
-	pendr =3D host_data_ptr(vgic_v5_ppi_state)->pendr_exit;
+	pendr =3D host_data_ptr(vgic_v5_ppi_state)->pendr;
=20
-	bitmap_xor(changed_active, cpu_if->vgic_ppi_activer, activer,
-		   VGIC_V5_NR_PRIVATE_IRQS);
-	bitmap_xor(changed_pending, pendr_entry, pendr,
-		   VGIC_V5_NR_PRIVATE_IRQS);
-	bitmap_or(changed_bits, changed_active, changed_pending,
-		  VGIC_V5_NR_PRIVATE_IRQS);
-
-	for_each_set_bit(i, changed_bits, VGIC_V5_NR_PRIVATE_IRQS) {
+	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			 VGIC_V5_NR_PRIVATE_IRQS) {
 		u32 intid =3D vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
=20
@@ -462,15 +452,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 	 * incoming changes are merged with the outgoing changes on the return
 	 * path.
 	 */
-	bitmap_copy(host_data_ptr(vgic_v5_ppi_state)->pendr_entry, pendr,
-		    VGIC_V5_NR_PRIVATE_IRQS);
-
-	/*
-	 * Make sure that we can correctly detect "edges" in the PPI
-	 * state. There's a path where we never actually enter the guest, and
-	 * failure to do this risks losing pending state
-	 */
-	bitmap_copy(host_data_ptr(vgic_v5_ppi_state)->pendr_exit, pendr,
+	bitmap_copy(host_data_ptr(vgic_v5_ppi_state)->pendr, pendr,
 		    VGIC_V5_NR_PRIVATE_IRQS);
 }
=20
--=20
2.34.1
