Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013036.outbound.protection.outlook.com [40.107.162.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09A8425891
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890438; cv=fail; b=PSndwXBO26g4IzGuueG45H4C0yqhCIwd2b1QhFBcmhvbToRbFxs8vF1pgyL26oeDQ23ge7uqAhFPDKvdYnA7rlrY2GjAv0oUjg/9NGDplJtFNkcLyiRSx1EiZIyCnO63UJCZ0v5sBVL4DBGuL957EC7oYe5aYZO2+O8mt3gHg3s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890438; c=relaxed/simple;
	bh=hEfLHasqBDRuMGjNpWiTfT8MxQvFBGaaHT+T1uk2PG4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c+SHPPcEt9G86WkiuPCa7dHs76t9wiJ6wkK+la3sI3It5vX2wnqbIgIqdmJ7qIjC5RGzlIkUT8C5EeligEdOB5CfS2AM68dor4XzRHqLzudIJSLhE0wTY5pFIKFxdXGSmUiX91miEj0yIY7zEZ7ccDIXMtLnwqxBIqBJ3qL4uhg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JajPOBQ1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JajPOBQ1; arc=fail smtp.client-ip=40.107.162.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JajPOBQ1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JajPOBQ1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jMpPagqiogTKcVMaJc5ZEPF5vvxnmM/FVOycFa9SPSd9vK6g/4B38ofqxtPIUHH14qDwY8SeZ4tSeA+9xTxfrhYZkF0+rn4dyMcnQ3Np8ReJwwzZyY7PCiupyiX9+MZ+2xGUyNAWbf/+dx9zJrHvuT3kX4TrTemy13M6uhxqkyogYUtFkSZWn/BemmqNGdGOQ+wJlHbme0cNpSMoBJZ5HdCHAoOG0r1i870+2eCz4Wu+wph1b/tng+DTDnpB8/Yv7gDUOFCmp6PtJmrWjFhrOQX6dh96vgSnYuLPqK/441bRAh1xhUn0ZKgA6RZaTIRAiMx7rOfNZVunTs6//itT5A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=PCqJarXUojVvdlBjjD9ERAJanu02wa7krEwIe7uDTigcpQ51E/G7fDjeA2g7KPhH4m24Q04ZGhQuiqZh/Ldn22GTXl5sSZHliGuHwegFMZs8mXprgXsIGg+VYsv9Qf95Hv72SQTV4gEFKW7MXh0zPAU8EBwaphJ8FywLBJxi+ZJGvF7jlkp3olGDnJ2mVf2y0XQpzBDFbqngTxNnVcfOIEg+BTkf2gUI7lL1A6hPpHishDcf8tK944vsEBMZPmAH9IsytIkxSAFjaRQaSuijDTsOtaO6pvTcbKffh3/x70GiavJUt/5f2O1PcWrSFMDwuREXYQTb7qZJSt3HqV77bQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=JajPOBQ1MW9RKAmmcwcbEqiPNRkar+eI7MVhzurKNqPzbZQGDSmva1hk6wEggHR/UKuUwg4Ag0P6Tq0C3/JiDisJs0sGNSZ+Niedi3PlQ49aJlgzHOiBfA6V6E523SY1YlKY+WwMBbKA5dpIKHmMJa7tfHh4f4X1xVkZ0IVnC3g=
Received: from AS4P190CA0046.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:656::29)
 by PAXPR08MB6624.eurprd08.prod.outlook.com (2603:10a6:102:dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:53:51 +0000
Received: from AM4PEPF00027A6C.eurprd04.prod.outlook.com
 (2603:10a6:20b:656:cafe::3f) by AS4P190CA0046.outlook.office365.com
 (2603:10a6:20b:656::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:53:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6C.mail.protection.outlook.com (10.167.16.90) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:53:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1mqSzX5icaJyql+0VdveM0obEW7cCvJwioJtMQiROA8ilTe2/z+swLw6PwKRLv5I3pfnPtLOBo7VqWk6ISDUlRdf6lNgo9qQwVHCgzQ7fSieBt0PGJmWJMVdj/pgd12XHz5aDfLIaI0781BOF1/Z5U3jjlfj+XqabEsM6JNJV2MhxJIP0SRNGOlTMxB96nbU+EH0iAEe6TekaGmdPBf8dNJnCgRngfYLgOADWsU2+rwrDxOerwNePUXBSmSIhsr3sLekWu//Ak6qikJQ3YAwLzPvH9jz1cvVr4pFaVIBb1kSnfhngy6RgWi5EmadsGukaWvXVD01flc7+9puiGlgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=YNp02BXF6tywWVPrGNpkK3MyvEzGjXgaHeMpWsWhyN2G7ASgQI9GHmkky4x5auEhB1E10JApGKGqGNLidhxTb2YEmUNV8V+/b4EwvrMnldsFlebTX6gGaOFZfxaahSJa8thMnXSdeeUveRTK6RaSTvyAj/5mTfQ5mwjQK9jZHis3uSGKJur5K/4m9YpxkWHM5EXJSWVZkOzp4Ago6MZfg4uxyjOoRGgTx7Rckz6Mkviz58YpLO2x2fqFQK4IDNeUUbNnuCVxikxZuFM5X0q87qzTRjsWY0CwXA/CUTXpFcz3waBEGsaiYJbpgv75lL5fF7O7WBS25mbaHHrQAKIzGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=JajPOBQ1MW9RKAmmcwcbEqiPNRkar+eI7MVhzurKNqPzbZQGDSmva1hk6wEggHR/UKuUwg4Ag0P6Tq0C3/JiDisJs0sGNSZ+Niedi3PlQ49aJlgzHOiBfA6V6E523SY1YlKY+WwMBbKA5dpIKHmMJa7tfHh4f4X1xVkZ0IVnC3g=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:52:47 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:52:47 +0000
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
Subject: [PATCH v4 17/48] KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and
 IRS base address
Thread-Topic: [PATCH v4 17/48] KVM: arm64: gic-v5: Introduce struct
 vgic_v5_irs and IRS base address
Thread-Index: AQHdG1qQzzJ9v1ffG06+poz80v8z6A==
Date: Fri, 24 Jul 2026 10:52:47 +0000
Message-ID: <20260724104819.1296803-18-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|AM4PEPF00027A6C:EE_|PAXPR08MB6624:EE_
X-MS-Office365-Filtering-Correlation-Id: 43659daa-58d5-47e9-9926-08dee971d8c2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 h/FviT9Y5uLdSc5N0mb1ThyVoLa+3yMgudoQzsmemWHuEafszoy2Q0xK78SgtMAPc+6Y/hJ/cbR5Fm0w8UkoeGbt7wbNH9UXx8f3QjiyckXNhLvVxz5nygc9Gdk+T86crEgtdY8w8AZIcbkbda2q1mPYdYq8i7j0dR7UUaB7oA0RvnXzIhieFM0GigO2KA34F91D6g2Ivrex3yISWKQqSGTAS0X6FOwhux6xDc/sKHFbbgBsOqZAm+otE0p5sWamE46ZDqTfqQB/5mZrZLdXgLd+IDR9DHUEuq5X2kZzkJWCgdK2lRZNslw8RTQnHluyZrr3T/2+tgdSgF40PHfyq6yo90DuJZDWMn9pRrBpi6YqHmZzgUz45avyC+cBEpZj4mFzDzHFIHIj1AoeLAhM0UaUc+J0qrSb6fWkceDYsO3thO8yHumJzm6kwUzqjuDWdE9msurqDevWcfU+4b5fLfkhDy/hdKzWTxIPInKuaclADSJM/nwNEgEICbi8aDtINuvVMl1SdLcEUP2Qc+Yc5ONRsp2ujWR1bsOGl8cMocU6rfipGGs5srpfLTcv9LnnXRpkJc30mNYbl0LrNcj8/McLB03WSkuVzEwROcPeWciO+oWGTquUI1vXYbzX9l44rGo9rxK24eFDms5eouB3P/ww1uvT5XHOLoEVW9FNJ1uSs3q6gybQB8aOLIRNfIfPXbsre+xzmrd5X51jXPVR2qnVJjycvyKLyxIFFntpGxE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WbiLkYBNVwmHu4pBVQG1vBXO8nOpBy9TfyWJ4HGeJOleLNTc9t4toZXGimmdIKpIEa7rAWpf7ImeOMT1xQ6OItiynlwHLnHQZYK5pdfsBRUsgRMNuO4wrivwm+6YEb2KsvTEPdZLuXGTmWaatn3ZUcenLVpgWtV+v3A+44kiP2JWGuL8zmFiIduK6d62IEz44r9FUtKJgmMNXq2yq51A14GpBJIyQa6TBac8RzxyZzeKL+jt/kveKIm2jmhQBLofAzIxPvK2gmJuJDRTyJ+WfjlgIYRr0B2034P56gttc7VtDWWzjdDxXBtwCqt5dbQcnj5/hH5qvycbrw72PbNjMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9c3906b8-67f8-4eb7-af18-08dee971b2e5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|23010399003|36860700016|14060799003|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cSaf1tJUdNxkG7p8YIc+G8bAJtZinuiTK9/gQOw7RcUQA4NKSlkVgpDXbP1miMjeIBLPoz1TsUAEv2uJhR+p4RkaJ09BIttjK78LcVPzaUgIGkOTcLKy68s3bizcUSd6NPLRk1FhWnil35iMsFI0jjOBokpahm+Nv7gTGCOb0ddvfbhyxsEHxTeHWTIuGRpsIqrMT4tbWAzTwVo8/66z9ci1hivcPDsud/+ZNdaExloLCKdwqPM4r0zGa9tJFKcFryT3ZQ1RctV1pq4FIquC/1XXWKdqiKxLYlUzM3vc/Cx5a6E2cGZZzbqvide2ltOcm9FM8b3lfsVYSjXTs8T4ojehZgObiPIQAAEPZog3Z0zDeBFYe3IgRIRm7/zK4RjeU6DKikV+RvmavBNBgXTkNT1hLqNCeQ0aqMZGgpq6PPXD3/9ZX7o8c7TznsZLEwrnEdF7xwyuVzV6KXHlqS5E9EiRLbgxJDtUBUqCOklsy7UemsTfe9VKfqzruiomyjmBl6cvpiVrD5+i/K5AcY2kQqsuUyyOU6Dslgt2KjZECJTDlj4aSR/df9fDC4nj2dwYfKvLlMvNWyWfn1Vawjpio+COn2hPND2d2BeVGZ6P+BQS69iFcTIl4IlHR7/kQwffkVKSS5VeJEHcs1BTObKl7tVgWCKyKGSDTMUbpPlN6CFUmDsUml91u+CoZzfg7IuAI9yB/vgknnRZ/gRu4nlwtA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(23010399003)(36860700016)(14060799003)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VErxVRwyvdkMLyDpQmhlVUqB2PUXfRVuq4gVkHbSdb0YXFLOTY4hjCl7SY7LJJcAYRoJOM2T3MeXOMqQU+CLZjhCK1QffhzZIsItB67555fguXUysGdiBctQcfTBUDLk6VZAkG2M6CfuETEtCwtxHoTghCYvJsey3UzO4xesmX3tm/N9ANrsqB7mPp1U6nQQ/GoxxOydWolAgme1q1JYEuj5s1TKWVOlmTlVVeYBL08WWRC9OKqK6qGR1oxKO0UnKk1LYQlkKWWtqNfmhpwwM/86pSKdYAfr+gWZ5ZtWMe/T+zCnpAVM27lJyzHkS6HaIthGhDhE+duLsrqrzqlN5SvjINcsVBq7rDHwDbQEWGNfgs97Oy/2b/k1Qu1i18fA1/tmqGuqvqdUNzQd2jOX5sPNKllULpj8ti3s9myhyw5GuXFOMoLkLIspaBUvWtRi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:53:50.9489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43659daa-58d5-47e9-9926-08dee971d8c2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6624

In order to properly emulate the operation of the IRS from KVM, we
require storage for the MMIO register state. This change introduces
struct vgic_v5_irs, and adds a pointer to it to the struct vgic_dist.

This new data structure contains the storage for IRS MMIO state that
is required for emulating the MMIO interface in KVM. This provides
persistent storage, and a way to track data across MMIO writes, e.g.,
selecting an SPI and updating the configuration of it is two MMIO
writes.

Note that only a pointer to the data structure is added to struct
vgic_dist as this new structure is very large, and hence it makes
sense to dynamically allocate it and just provide a pointer to
retrieve it in struct vgic_dist.

In addition to adding a structure to store the MMIO state for the IRS,
we add the base address in GPA space to struct vgic_v5_irs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/kvm/arm_vgic.h | 86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index faecde764fea3..25368c5cda5df 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -409,6 +409,87 @@ struct vgic_v5_vm {
 	bool			vmte_allocated;
 };
=20
+/*** GICv5 ***/
+struct vgic_v5_irs {
+	/* base addresses in guest physical address space: */
+	gpa_t vgic_v5_irs_base;
+
+	struct vgic_io_device iodev;
+	struct kvm_device *dev;
+
+	/* IRS state - used for registers etc */
+	struct {
+		u8 domain;
+		u8 pa_range;
+		bool virt;
+		bool setlpi;
+		bool mec;
+		bool mpam;
+		bool swe;
+		u16 irs_id;
+	} idr0;
+
+	struct {
+		/* PE_CNT is populated from online_vcpus at runtime */
+		u8 priority_bits;
+	} idr1;
+
+	struct {
+		u8 id_bits;
+		u8 min_lpi_id_bits;
+		bool ist_levels;
+		u8 ist_l2sz;
+		bool istmd;
+		u8 istmd_sz;
+	} idr2;
+
+	struct {
+		u32 spi_range;
+	} idr5;
+
+	struct {
+		u32 spi_irs_range;
+	} idr6;
+
+	struct {
+		u32 spi_base;
+	} idr7;
+
+	struct {
+		u8 sh;
+		u8 oc;
+		u8 ic;
+		bool ist_ra;
+		bool ist_wa;
+		bool vmt_ra;
+		bool vpet_ra;
+		bool vmd_ra;
+		bool vmd_wa;
+		bool vped_ra;
+		bool vped_wa;
+	} cr1;
+
+	struct {
+		u32 id;
+	} spi_selr;
+
+	struct {
+		u32 iaffid;
+	} pe_selr;
+
+	struct {
+		u8 lpi_id_bits;
+		u8 l2sz;
+		u8 istsz;
+		bool structure;
+	} ist_cfgr;
+
+	struct {
+		bool valid;
+		u64 addr;
+	} ist_baser;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -486,6 +567,11 @@ struct vgic_dist {
 	 * GICv5 per-VM data.
 	 */
 	struct vgic_v5_vm	gicv5_vm;
+
+	/*
+	 * GICv5 IRS data. Dynamically allocated due to the size.
+	 */
+	struct vgic_v5_irs	*vgic_v5_irs_data;
 };
=20
 struct vgic_v2_cpu_if {
--=20
2.34.1
