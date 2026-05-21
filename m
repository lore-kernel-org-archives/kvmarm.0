Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011016.outbound.protection.outlook.com [52.101.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A325C368D5B
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375268; cv=fail; b=eVKMkMOQs4nL+ESt5cMcNN7eVjwJFP0tfcLd5+llRYNqUvcLk42tBhSCUailLSdPB3SMfsHkW7J+QIggSaBepS2edq9aRAe9VNgS0qBrVDgh2ZH7WHyABVODMb6ZJZPYpAyYK2+huAXbSt7fGQ9hxQ70WCeA6WbnNFmKxRBwnRo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375268; c=relaxed/simple;
	bh=oVMdU7OviJW468MGH1u1aG85jFe+z2Ba4i189BeY6co=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tBBvYH9KDw7VylwAWVZOpt41L7OEfzDqQz88KMsLiw36DWOfy1V23rH7U3kL3Mt9+42I5pEwiShwnSGNKOtMetCwBTDKz+tCD3gPBQY9TGoSVY2FIAJrXwLsjRX/+3D6FqtNqolKfVPRBZhBBlkf4EVNgkVXfscqhU7TF3Vyg9o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IVUEr0Of; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IVUEr0Of; arc=fail smtp.client-ip=52.101.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IVUEr0Of";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IVUEr0Of"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=mDh7Bued/em1tLs4V3H255o4cW83n0xigmkWJEE/j0T0myA2UF3BogQ1inH9BktL+qN4H4HEK0Cyv/j9RRrXoO1POpAUGGvJJZa3+B6ISI9E/nqMd1idwih75coX/uI4NwE4wpwgAADdq0S8Y6mfiwua/0+gw1EHrSnfy+YQ2cW6jH5uSW/IOcPjydPBzB0pwRFgdz7bGTYQhvNf1YVdxv9n4KnhatuS54b/r1ldBrhYyUf9fkTowIwicoG98+qWt5aEZc/7uJC97hr+7HqoRZzPMA0UXi4b6lnVRwVHuaqEWRm0dZpOcYGOa2ZVkpsdEuByYn8nI0WJQP6ktmGk0Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VhoYWpZvNfyvFBCXg2UWrCCM43ZaZ815GXDsRXSS5s=;
 b=nvqG3lXYbpQrfUn+g6k2w0hoP0Vh+UlDbGN2NhAJbkzdmOISkCUlM+aR9wPFbiUWRvdQSUkDK5YuCi9WBpCmgep9dCjq/KG9tqbiWqZ5JZ6ZuMLviq+d0dyIMHeC9WAQWu8iXwEz7jpcOYjGBoTiz8qf1fAu6p533fMi6wIcqlfj1fSheo1MoWyPL0AQCqgIlXUTUVBO7h7OHj+QQMUURAUmjwq0XqBQvc7nNB0UH86ULHGj9sKujJKC2wbbMxLNU2zMJ0OqiGYFvPcsh3+rktY9tL1fh1ryTkk4OhBzliojWaGM+SOupYXHSiiAdmfjfYeJMEceAlATpG5DJxvm+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VhoYWpZvNfyvFBCXg2UWrCCM43ZaZ815GXDsRXSS5s=;
 b=IVUEr0Ofu7WEGs+z8AQrA1PWM81dVL29DKqm7ui8kk8S/7kXhUbwoj80ySX5YKkWYPAHc7YLtVELoHQPp31JZgeG303zMkDBCo3kFdizgGPDnr5Rbp5W59MriO6P8HUEkaWU7DEqRmB7jG2Wq/NslmvaioUfq5i2ympQ64V8CDY=
Received: from DUZPR01CA0124.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::7) by DB4PR08MB9216.eurprd08.prod.outlook.com
 (2603:10a6:10:3f8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:54:18 +0000
Received: from DB5PEPF00014B96.eurprd02.prod.outlook.com
 (2603:10a6:10:4bc:cafe::c1) by DUZPR01CA0124.outlook.office365.com
 (2603:10a6:10:4bc::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:54:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B96.mail.protection.outlook.com (10.167.8.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:54:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciOJ/AiYREaASAPChjdjYb17qHD8p3pgbwCdDaaEJP+nXxBi7Xp+IX7bsnRwcX1njqQ5PjGdQCrlrrRBzWfLD05N7+xAetS+RM2e1zCg3PRJJbG5FIL7/4hL+KQEdy1kyqZIG+KX1MuEG+hi51Jy2oX6eO04U1L4MYrvUYrhJhSwpt2IhuVUoepMkFpSxtPUnN2k1uZX5BLNkIIOq+B69yUVI/I2u28TsP0clpC3/94djW37c/z5NDg07QDUwVgFphPU2RuR9R/jeFkOpWqS/2xBttMjp857U1Jf6RRHIrGLbi1H+X5OMslSiuD2s6lspClH3H4Y42wB7uCq7r9znQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VhoYWpZvNfyvFBCXg2UWrCCM43ZaZ815GXDsRXSS5s=;
 b=i2AUEFCvut6vRs8UNeRPv098/2c2pIxLeAoLUuuxSIRA2dpgprg5mh5QAxfBNYhnu/NOL+TQakPcV/LUEF+Z50LIeMMb5w4EtBKFljgoNw3gp9/0aeh481IEB6MfMzhSI7rPMXirZ3COinEkGUWL9OLkWdKcEHGZ9tPi9114qBcW01wAlWK5324gVokGiIXdZriZwZyDn1e7pzOFObUqRwg8Ug7thBSIMooHTjPcHNtaT66qEgZ63pGOhDrJggoiclcODtQa5Ix1U/spyLjupxHYvvKDIxRZzzaMQuxr0piOGtvtJ9BqQNdraLOhBeRmxLp2/jJfyfrAPUJYrFKhMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VhoYWpZvNfyvFBCXg2UWrCCM43ZaZ815GXDsRXSS5s=;
 b=IVUEr0Ofu7WEGs+z8AQrA1PWM81dVL29DKqm7ui8kk8S/7kXhUbwoj80ySX5YKkWYPAHc7YLtVELoHQPp31JZgeG303zMkDBCo3kFdizgGPDnr5Rbp5W59MriO6P8HUEkaWU7DEqRmB7jG2Wq/NslmvaioUfq5i2ympQ64V8CDY=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:53:15 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:53:15 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 12/39] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Topic: [PATCH v2 12/39] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Thread-Index: AQHc6TGNTzFRISrTLUeidLtNDw/c3Q==
Date: Thu, 21 May 2026 14:53:14 +0000
Message-ID: <20260521144846.1899475-13-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|DB5PEPF00014B96:EE_|DB4PR08MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ed88dcb-55cb-4413-1392-08deb748d56f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 kxIqN0jQmdfsuDYJ+6BuAaUGM6lxB71wl8bGdRFRZT2DzAkl6wgqMr4/S9f27cDRojyLWqEgMDw6LUtFvtjQi4rJ2MrZjzlP0fR6IIxHGnPo65NYOc9l85Jxsu5cLGSe5E22tnyFcuWGrlRpQzb4hDvcmzz7h1ENnIjvg9gIXYOp5gRTOdsuujqIWCcg3YGhaKE9wJg6du4++6jM+6iLg0JWhpMViimlwCiG6l3+g8WBCGAlpDNVM5hkIMYg/Ykf4gkFJ3MC82UGRBe4ggYTZJzHcy5bYtkMstAE5q0npPWNqes0JAyDxQgEF/TwlqILvMB3nvF7pKPXyN8b9zThDMq7d9kCTzNKGMjVxOVb2LT2r0K/P/JHFkVwPjuXHqyaUUH0J0I2zqOCME02un+jlUXm574xCPIcZQQgxv99XyQ5cJNX5xmAAUYtAeEGruiUjsGnp1lADXLadFc9dIlbW1G5UXopDZfQ0REliuxXnbth9eQnjZsi8V8WZHR6KF6MU/b+o5TfJIQTfH/BRTapGfkBujJmDE5lySEh+4NToj2UUZQFOwLNOlLW1ea+rBwADvYvGKRuUR55zk4G/Ukb3yIxfNFSFjbG0TgPGcJ3irbkoLz6mRhRg19nVhkYUs9i4vqvUrLeHeOLfXtTnsDXqhZ1RNlOakwbDVx+zaNgOskxovX/cjufj+THtpkOWDMHL6cKHfinAgLx6Cstsh9xT49QoyyGdEqvAe9KTJlXX9iABshffujHHboKinpwKYPs
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 g8BW8fiPKwqtbsxsMQOjsHckxi2nj4pTe/HGr+0Z/UU31IEqp6xl+n/pAKxqgqA+3ttmD7kLmlgR8mG8gGzgJ2UwxYZRBMRJ3CtpVusFyM9bcmKJgSeUaRecXMge3rQI9xA7y3T6WJlaJz4J1RP3UsJZwZhhJe6QwG9VXBRwSNJAsoILriU2FgkS78k98ZJeLm+tWip3jxXOiyBuWFjWUZDSIXly995gxPVMBZQO8VY3QDK9xauf8GdlPvDo4Ev/XFZkmcv+BcnlIlI0Ua2gNGmy0vZ0FIbOOL/NhQoPFxohdWiCG9w00+ADCJWz/DUbi1Xya4N071+e1fva9fPiHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c311b3be-d5cf-42f0-a270-08deb748aff5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|1800799024|376014|82310400026|35042699022|6133799003|18002099003|22082099003|56012099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	4nh4KmrcXCDnrgm1WblxnqcnNGeGYBg1gPFvM0fuwmoanm2UEAcjkKnkTKLOE3+98QxjOlSXhhAHuBKByb2vg/Zey2TjKbmQFBFcTmNbrrpW+NXtg+60VlSwZBO1nB72f4S159tVL0N0ESf+EoXQmOIiotxVq4af2Zgxx54rBdolvF60OU3ukJk+rNzk3jVT3wJuZF36Oj13A2X4/J/r2BQSCvvdtGiXjscF9Q6q5Vz00rdZhsS05do4XfZrj/eSTKxTY0T+Z2JM07ZRK3E8xyremU5TBpmOmPct/Imi2Gm6v7US/v0A/rpY6qfVAj+xTAV56xKRbygbvFetjF7VMU6eSnQS0g3BpgefizjOOgMkMl4i1srEHp9xdKXWKr8yPjjmVWZvfZ6HiYViT63p3o18m3CZ8tMyT6FcvH/b7XEYPlsfZPgOmDQCvIOf6yiFndAQH8hecpDvFYgNZazXDKN/oVi4Sw39luGatBliHcim2uHDXIiAy+BY3rvuqJWEmshkqiJ8cRN97eYEUPIn8RhK3ENx/WqqfJpIflTUvHC0VbsSVM87+3zh5rVN7AEwTUkcNfaqdmxreY95K5hKt07JiYhtmNtR8bHuiV+zJDCsrYr0OICOGJRfVBioqXqOM5p0kI1Fmxmzq6797K5AcXMQwX07jZCwhW2AvbIE0HaPukFfn715q9pY7vnSsJwRnj/Rql5qIRBuySQe591dG72EjewnDZkePu5m8LSNZUw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(1800799024)(376014)(82310400026)(35042699022)(6133799003)(18002099003)(22082099003)(56012099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Heu9rlu6a14cFLjS6RpPujXa9PFLkRlZaVcIDLrpQdKre5XBuTD8v0Ld1EbCgJDpCc/s8fjBlfheLvGa/+l0IyCkS5fmtvQ9Y3w9ZyLZWpnJ3YGchohkXXHbc0V3gGyy57n2RT36dvarymgjnbE5gEyqfD6RNUAkVq1cEJrKqQzKgvi9mKUcG3A667mLN8oX9YXs2j7BfXB4XrPZusjxX6z8JatqvOWd41FXJg42C0VQOo8fQV8yM49CRfBzeCOEyb4nXpYVvd5yQ6TpD3WZItqvjqcjuMkckiv9LzExf5ua0IDe7nJxawD7otKDyIhpxSluTFIqEv2d6pHKStNyUIWG7evehE+CaCE0cva8lpLmmAfzyzgjAqD70TVDnRfb2cmnvVzKkdXWbblURmYX2CouIOG95Ia9rT8S3TqgBUEIil91L91t81JwXAcvipPX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:54:17.8449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed88dcb-55cb-4413-1392-08deb748d56f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9216

A GICv5 host with FEAT_GCIE_LEGACY can expose both a native vGICv5 or
a vGICv3 device. These models do not necessarily have the same vCPU
limit: the native GICv5 limit is probed from the IRS VPE capacity,
while the GICv3 limit remains the fixed KVM vGICv3 limit.

Keep the IRS-derived limit separately for vGICv5 creation. The
pre-VGIC KVM_CAP_MAX_VCPUS value continues to expose the largest limit
among the still-selectable models, and kvm_vgic_create() clamps the VM
to the limit of the VGIC model userspace actually selected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 14 +++++++++-----
 arch/arm64/kvm/vgic/vgic-v5.c   | 19 +++++++++----------
 include/kvm/arm_vgic.h          | 16 ++++++++++++----
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 079a57c2b18f6..94632fd90b728 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -129,13 +129,17 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
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
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f9578c2a634a4..909cef5f31afa 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -110,7 +110,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+	kvm_vgic_global_state.max_gic_vcpus =3D 0;
+	kvm_vgic_global_state.max_gicv5_vcpus =3D 0;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -135,8 +136,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
 	 * can't use them all.
 	 */
-	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
-						  VGIC_V5_MAX_CPUS);
+	kvm_vgic_global_state.max_gicv5_vcpus =3D min(irs_caps.max_vpes,
+						    VGIC_V5_MAX_CPUS);
=20
 	/*
 	 * GICv5 requires a set of tables to be allocated in order to manage
@@ -145,7 +146,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	 * we want to run. For now, we match the maximum number offered by the
 	 * hardware, but this might not be a wise choice in the long term.
 	 */
-	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gicv5_vcpus);
 	if (ret) {
 		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
 		return -ENODEV;
@@ -166,9 +167,6 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return -ENODEV;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
-						  VGIC_V5_MAX_CPUS);
-
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
@@ -178,6 +176,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
=20
 	v5_registered =3D true;
+	kvm_vgic_global_state.max_gic_vcpus =3D
+		kvm_vgic_global_state.max_gicv5_vcpus;
 	kvm_info("GCIE system register CPU interface\n");
=20
 skip_v5:
@@ -205,9 +205,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
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
index ba32cd71fe0a7..6f736094a0e7e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -157,9 +157,16 @@ struct vgic_global {
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
@@ -635,10 +642,11 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
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
