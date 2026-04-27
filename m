Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010017.outbound.protection.outlook.com [52.101.84.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C6234D91F
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306298; cv=fail; b=PvJR5mEDhXvPqgpCoi2cxfHfl5EvDbytZU1beXu45XOp1yyR/AwsKwx7lVLgYsGXy9SGx2RlOjot67k1m3o87g79QRmcyeN2AsH4dfnnx2cqhOCfdqNdbNVaGktGDnOLArGI4f8qRYQr4gQIcqZna0W+M+yB0ew4+wRng4KqZ2I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306298; c=relaxed/simple;
	bh=x2WqpPkOfwA7PzYY89pWP8DDbENhrX1JFKh8BKuVRe8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bgSuIpvzdlVaKIBafd8pvPc9dBV93yu/9Jkdd00KLodFhWPWynS3UJvACn6sW3ffz00g343CJGcbgu8bqgQduxDCrWb3X3ZGQYjAaw6VAbYJ6m9Jf+lTY2yE0ylvWDB3VtiqeX9emv+moPr6lvTu+GeMKIo5T2u1Q6M7wxYBtmU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OBTSsgdL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OBTSsgdL; arc=fail smtp.client-ip=52.101.84.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OBTSsgdL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OBTSsgdL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eP6EN5xUfqSTNkzkX4x9mjl0Pg6ZWtFN/4ld5qWWu3NQ3iyWuRiTI0siIBtyp++o+ek/66lVRdWLHbXrtlzl0ErpF4k7Hx6AV/w4gEdEzqVxFt+uqua4j+9JDoT6+XB8NucjYMbLNu3AaeYXQfxNuUZvp2jFKZ4QSxfHRDmNxRHI/toBiFOKkcxkdAZm3LymusJG8ZVt2cMx2VEJ/uBHOed6NeHdHsSa8Boz2UvVGAhKSXVR3mAYMYaptdewg7iK0vJxK2CaSPMBjbDW8FQJgbdkg5K+02vj/F/2H5s2qQeyJaxoMjQ7AudCzqvD4M6toa2FBisDDm7d0JVRxToULg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnPrLu42NsUeuvZ4n9cRW5uGHXfrXYV4R2o2OMkbMIQ=;
 b=fMJAfo/M4BCuQhLIBdUJwnbqfJxXUGlvD9Qnzp66Pos6wlPL5+2i/5UWTpHAR7wiw4fj+ZNrWkLCYeDoptLwxOeKI86w4q0//j/AhIB8o4g1U2gf4l4J6aEXAjlt4+hsaDnOjBUMA2s+ujUKPI3PIRBo1p06QUAIdcgQDoYOHn+Y2BfoyPnGXyr9AYo+FyDRP1hbq1uD9VkkEv1m1diD5ahx2YtWpuOgHwsMKCwG/6Fj0ocRpgqMBF7WU2ScOt/sHONyWLPKSWaxy7KMpPvbcBvXvLTwe+L6hvQotvhyS1Q6uYD36DvGduSAsh2m4jTjGxbQtnpvRjUN6i5aZNuuhA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnPrLu42NsUeuvZ4n9cRW5uGHXfrXYV4R2o2OMkbMIQ=;
 b=OBTSsgdLDwvM4wyySmSGs5ChZRrWTTLlc9ngFmMH84uuYt9YVQNfYZ2WCSnjJpdZmjUbXy4OhVp7UeRXMAILTiYklePge5Yc2lEfrX0iq3IgfxNFaRFdHqLIDoOMtbkD0VSCIgUT1h7u4Dw00pL4PRrRinEGwTJW9fl4uhakTFU=
Received: from DB3PR06CA0013.eurprd06.prod.outlook.com (2603:10a6:8:1::26) by
 DB9PR08MB9489.eurprd08.prod.outlook.com (2603:10a6:10:458::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Mon, 27 Apr 2026 16:11:31 +0000
Received: from DU2PEPF00028D13.eurprd03.prod.outlook.com
 (2603:10a6:8:1:cafe::b7) by DB3PR06CA0013.outlook.office365.com
 (2603:10a6:8:1::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:11:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D13.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48
 via Frontend Transport; Mon, 27 Apr 2026 16:11:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=debRTbG1pqSrytOJ5tw6SCldGqkCIcg6OL4fIp6a4HZi63Eni77V/5njtXYMu9YvWUJECGPsUug77xrp/GNjs08/4Cz7bvGLBZJmqOt6kDIcCecX5IyrhTgMmzkvOw1PRppM/R4Ttw7UDRCeWKZNk1CDnQtG1ysuEBQHYNm1gq6X+SHect/p78RP8iSL+iAo6wq39uRbAZ2wAgX8EyX8bWnWIK6wc5Edlag0VKz2eZw/UwYGQtz96QoURSR5uJey5STKSZ6dtR/99LR+UqC1QkYowtDgRD6JIEuDZs2zGbQPTIhG29S83tSL1l/vuUZiHvJcpecyPdMPocJiJOSeWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnPrLu42NsUeuvZ4n9cRW5uGHXfrXYV4R2o2OMkbMIQ=;
 b=pW8ukaXZrWg4zEnYq3ifKwo6+v0t2UsqUJlGDM5zWPze60CcRAmRzX1WcHN4LOuDOth3InNqzNUri1CPnku6tVhMoIb7DtMCOXkNTj2dc8Y9njbKxliPG6Kpw90QLYB93JLUBpIQlN/rZ1b87HJDVC6GFskcsQwrlapvLdxrxbtMLcIim0Wvd5bw+po45xi7azRbvmjzdWsgm4d8BQZxIzwNvIjtxsvoIQ37W4vgqF0Jvgkt0MwAkyJjmatCp3oZGqYkqc7hCXqh9pMJ2CxOjqI8hFtGGjy0f7NR9wOGRWVyFrz4r7hLKtDux9ijbkYf/MsNBRL/jrnL05sDCibydA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnPrLu42NsUeuvZ4n9cRW5uGHXfrXYV4R2o2OMkbMIQ=;
 b=OBTSsgdLDwvM4wyySmSGs5ChZRrWTTLlc9ngFmMH84uuYt9YVQNfYZ2WCSnjJpdZmjUbXy4OhVp7UeRXMAILTiYklePge5Yc2lEfrX0iq3IgfxNFaRFdHqLIDoOMtbkD0VSCIgUT1h7u4Dw00pL4PRrRinEGwTJW9fl4uhakTFU=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:10:28 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:10:28 +0000
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
Subject: [PATCH 13/43] KVM: arm64: gic-v5: Make VPEs (non-)resident in
 vgic_load/put
Thread-Topic: [PATCH 13/43] KVM: arm64: gic-v5: Make VPEs (non-)resident in
 vgic_load/put
Thread-Index: AQHc1mBdE97Aj4N9FUmhjqBKds0YUA==
Date: Mon, 27 Apr 2026 16:10:28 +0000
Message-ID: <20260427160547.3129448-14-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|DU2PEPF00028D13:EE_|DB9PR08MB9489:EE_
X-MS-Office365-Filtering-Correlation-Id: 89702092-13b5-4440-779f-08dea477a556
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 LDTOfJ013BB3xcA6APtn/wQvhHf97Gi0MakKoRGjYtspZmiiP87WtGZ9V056S0bnqMLdZ2dhAhcspvWw5oiT7eWA16g8KCgk8CjUBZK78S/4cA8KrvOCPQoT32ntvHmWb8hXYeEBHjnNTHs09Xw3+e1ThSkJthAMO5NkVqiRioFw0zcI6SzAA/wQhmetSvPUvt1QUw6ztOHxfNfrkHJf0RapYk5qUfsf9eKEmvNHKgG3GcavQgZKm8onqn2SvjCi/sdqOW4XAcRiJ5IJA1FlvD68G+ZobD+Ff0H0YmG3/RH3wnOhms6yduhtsQmx7jdKrjy9hoRd8bcjt31FZW4816ktERaulUq7txdvjktbAdVA3NzZbzcui8jS2eGJB8euuCIyLez18LAcIORQvEdQIe4/Vu3yZZfFJ+v0F2+ZFoYZ64y3esPm2ANqeARvwMKLFlTeIjxILDwSCBBOMXszwTLpTTv5UUVjzYREaGEGhbrHsfSJIvEyJrNYjBI4HPwbQZyRGIjKyrG4xe/gZ92BTtAa3nWS7R/nk/jg/8URKnMXIKs/nPOHrM+WcX0yd5sZoxsbApnB2RLdOJ1u/5B82gAVZ315BzkunvRL6WFPxUSoXWV4RK2OzpF9U8CKGWqkIubzkDjZ+KZRR5bb8ug4FODxIJ2P28JcWj9ei2ovsNnt3ItBfq4g8+Ef4L7XPlxuvBswdeukJWAfPsyeV3FkDiiTaqhFBgBG/aUM4EMqxKiIOMfH5OiPVtgTzDXNnXNsD069Z61NBAxnDHKKRBuxVy/cUw00ZmfkfdW7Ja/XIAc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 aiFTrRq90ztynENEZNWhbJfryvzKTcGqwKYB41NGIYNVjBCFB1zpuCeqxfGfQZXUambVgKXwytCsYCiTs/3C3M/JjSQ8vuhRvrgyWemESK6gYWeRqaD5er9CVwNAFBC0R5nDKbAtlafw14JI0a7ZX65HERdfJmmBhnPB4lT7wZcVjKjW335LGc3HczQUtXPyaEMet+5bJeTQDiWPSlAPdBusTU3LCq1rH52975QVRV4kU7WxCgvM3sbyy8JcOi7ud/VU0NnU/LjRjUvSqUsYKCQQxUrZSA8tH57NVtujN5zZ9GwoQa96CUT69bpB2OH4BhOQY4XmBfiEctdpx+WI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f5ad0f02-0017-4248-0b5e-08dea4777ff0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ZjjOj8qSXy31OEzfRLm34cZTPSSdw/H0Fs3U/I8wLHNIdi8P8wd5hi0wjla+3lOMxXfk4Sr7C8OfAvRFxnwFX1nxgekYtmI0U8qm7spC3dOdeKHgBw/d9JYe8TPs6UidnbTkySfGIadFfNIWSYKKcPLht5iy8Ay9Pf51srEmWb3Cb8wuJf3l1uYpVXuPty7oAML9g/KBhO3QWf3+ADYH/+1xPyIZbEuFs0mYt5Kcyzzasy9IKcnIN5lCb+sUsSuUcX9TVn37lnQdxJ6byqy2UPJROMr8+1uij6b7jlKPdK8ZMV6kDhwrxnp2ytQb4g7nRJEhNdNyB1h7rIZPJk6PwsuG/jNKWnnILVI1vi5dc6Rje4I7O9J7sNIPsKL0RNT9hIyg/2HbEmzADSTPTTiGmv8qoCXA2qVd4PhU1qwEtOHEvhV7Hpnw0LK0kPhvRWhCuHAlnWy+CPiRd7AbcZ4BGBnA6D+Y6LzkC4exyGFx1Tt27nr1zGGw271xsWHbqU9g5qK39gArKgDsd91QwB9c4UOTEqO1c0YkArdhET97tEhc4QFTP1ZPxcOO2bgB5JXAFvWM4StEDM5ql0F0MHfWSY4P+nZmvocZhHCzlLt26C9wN1cGmy/7eD8XfA2xX9+kHMW6XYvTuT7ahO4YaQLNkXc4LhuHndeywQjAma0hqCl123ewB5iOS+7GcCbHrCV2UkOUSXGtDUL1ebP2XB0igYlrfwhQ9jFNy98uzlV4Fvg6csQkkTjxUJ3ybDhEODf+Rva0UuGe3JzqGu/e9SjRqA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hpipdR5+oShgJDsIhc90k5HggHyy34FL/zPOeiO2/vCNde+gs2vsc7XJo8bBtLnE+QHRvUgKZ5PTRmcitDexWAyWh2mqBTRb5QHQ1zg3JpgfS+/HNlDzHh/NiM3gb2X/wHOdOlPLru45M8gRvb9DG82QHgKbUD4CZfLcikSpDUHRjvx2FfaQSjm3BceX9c/ol5+Mh7MGX339vFSUuIF1NqsGHv+bn03eyxi+lkOvY7Bsv/bfspJhShY8Pd5+QvdvpD3vD75JwdSuCT9HkYqwli4BmJCSTT5W0hC8o6VS/udT0dmuDnL/5xiP5GA7edlYNbXtF8K0DffxMJncok0wpiWfmXp5P7KnfsAlWKHEsMTGpc6jHNv3jbVmmygl9wRadSXc5YFJKBTdt/w7v304FLqH/iQkCzwADaUbUA4z82QTxV6TgpKuv1p6/o/4Q+/T
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:11:31.4103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89702092-13b5-4440-779f-08dea477a556
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9489

Extend vgic_v5_load and vgic_v5_put to make the VPEs resident and
non-resident, respectively. This makes the IRS aware of which VPE is
currently resident, and therefore allows it to perform HPPI selection
for LPIs and SPIs, which would otherwise never be signalled to the
VPE.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 92bb63b6dd6bb..11a1a491b7e0a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1053,6 +1053,8 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe =3D vgic_v5_vpe_id(vcpu);
=20
 	/*
 	 * On the WFI path, vgic_load is called a second time. The first is when
@@ -1065,7 +1067,11 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D true;
+	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
+
+	kvm_call_hyp(__vgic_v5_make_resident, cpu_if);
 }
=20
 void vgic_v5_put(struct kvm_vcpu *vcpu)
@@ -1083,7 +1089,9 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D false;
+	cpu_if->vgic_contextr =3D 0;
+
+	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
 	/* The shadow priority is only updated on entering WFI */
 	if (vcpu_get_flag(vcpu, IN_WFI))
--=20
2.34.1
