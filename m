Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013060.outbound.protection.outlook.com [40.107.159.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA3942CB01;
	Fri, 31 Jul 2026 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785507742; cv=fail; b=b5eCatyo/YSShtVLo+ikuJtb0OyOo862ALGo7Eh+yuWgLrSOlHgeXGK4ursg6XhBNDZQ14NkHL1q/g6cImT5ebOv1fXKtHeEHPFro+7saQE+RCBwpyKUkBapok3HsgRqpkkV9m2IbCs0VZ/GJZ4Q3EBwN1LTsE2BzgjUI8Upscg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785507742; c=relaxed/simple;
	bh=2F8OoK7v2f3GrTgkCpvs87Jpslt3vFfInHmzser+Cw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uhZljKdSRPxkIakDqHv+/UJ+gMFRRXYtMrKO5o4YmunwHA9BlgAT90FRpUiSKqXwfFaO8nWe/9yHDnpCQnBZnKdXgEkr0Z7gJYf2NVMezvj8OnIexyj5u0QBw6EnZFVQSEMqumcoJUPut9MRIMW0pWGsdzgkpMCPDSt1+QtBfFc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ck61Lx0e; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ck61Lx0e; arc=fail smtp.client-ip=40.107.159.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ck61Lx0e";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ck61Lx0e"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=npSs7DwBmq624g7ybJM21ZroGdqxSABv/k97IB6Lf1r7CeAjmPQdeutVAm9WYiulIeH6/BLgdfyW5O798qyXy8VEDjCoNPwBeRhcQeFymGEEOjtsaijIKAfCXlZ7BFCyLZm1WqoBI+EOabRjq9Z+AGef6JT2S6fRIT+oitpKIF6NdBKug6K/OtKkXUPCMhQ9r5SueQC6Xx0wahGkA/FcW6dXu5jKNjxrUJtZNLA2Ytw5YjVk6iDuEnB8qH9u9TwCuyttp7RNpOX4luAi+QMeDRb+NTqPD7YacGEdDybNqjOrCdggqRkVI7wnDnG0ui+xjxfnz4ibA6QqwX9fl5tSdA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2F8OoK7v2f3GrTgkCpvs87Jpslt3vFfInHmzser+Cw8=;
 b=LR6vatrj6rgNWTB2+kEpD5aa9Kja61pYgUrjXL9iyQrqcRiASFEDN0SdwfPH/6S2KvDrQ8oGbqMIpLcowVtBkN87Jni60IxYYziAZ7qw39hbWKftOrL+QDDeyKARcbWEgdmBrFwXYh2T2JmvHdqKBcBsQYfV7CFRk/2K5/e/B4wIh2PEJycy8LiNQ8zHcI+/Onq8CciYwjV1ywaKhtVM0K/HBqzbhZp/kU01FgeMFu+jhxXe9atZm4/NUEI4o2W7FWS1aHY09ydkDqdXuwp/xvcy26MCM1spa7FMz/jkx+peuG3ioYs3FKLapuYWyJyM5rfBXzaBngEDQTVkD3vmyQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2F8OoK7v2f3GrTgkCpvs87Jpslt3vFfInHmzser+Cw8=;
 b=Ck61Lx0ehyTwq3MavZh1G/Yx6KYVvumQFso/5CQ6GVU4bRiIDqqZauY9gdA0jbyOrJ2G6au9F+6ubvdtlJm77Uco8b6kU+RZqUgLYfK67aE/QXHP7MwlRMXyLjQ51Tg4UhEbM2I4dAcHepb3vHvXk/zVVd6UAaHsAm34mG0e4M0=
Received: from AM0PR02CA0115.eurprd02.prod.outlook.com (2603:10a6:20b:28c::12)
 by VI0PR08MB11081.eurprd08.prod.outlook.com (2603:10a6:800:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:22:11 +0000
Received: from AMS1EPF0000004C.eurprd04.prod.outlook.com
 (2603:10a6:20b:28c:cafe::2b) by AM0PR02CA0115.outlook.office365.com
 (2603:10a6:20b:28c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 14:22:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004C.mail.protection.outlook.com (10.167.16.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 14:22:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/7s1ygsmLgFQ/B+D6nBI8MQKUZNu2XFF5KN1oAD0nKix8HStDAqn6/mJ2cq7g1rxigojeG+e9PvOsVeWrVRJITaGG7TSTy81smAPk0JvMs8EO8CjVEKj0QJ5M0k+YkA2sesuJuHKMcKeKMLuBm6QLooCZlqerk42ScAMooNOaBwgP0rvOudgAEeyh5t89Ql509UqHAXChDmole8+zBMWkhruLM/CFVinhSNr8sdL1XAuUSOrXsl5clDL0iscAzWpjH61dMfy6EwTokTnyTLz6rcA7+QSnaSAYi5O+zRytf1rCn9y35h/7r8CsmZdSidaEseXz8bEn5ah2Qp3VxIWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2F8OoK7v2f3GrTgkCpvs87Jpslt3vFfInHmzser+Cw8=;
 b=nAnFeCYONigd4jd4w1aRlKPYNhAKfB/1mxIZAqhQ8t1F1xCW6KorZmfnuLIIxUkMboq7TulsWWAgUmJ/sOpW6zIPQq/ruVESpr2XJEAumDha6yElzTrrmYGSl4tR2hMMoe/mFkyRnFfK+jOAiQd1cFTp6FPiVv8bFprKkImV2pg91aZGzsIlQHsHFP0Pjt36QHZa6/wXQMger/wcbSv4DXXZVIXtC/SAt5Rtiky5Zs5rrAkaoc7ncdnFFWVkhIDsDU7brq8g9/t0i4sK7gbInZcB8JWIiuWvM9bY1mgQQa0WW/u8dh4U/eUE+uiTckxUkSAaMwVLU5cBFjriESxp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2F8OoK7v2f3GrTgkCpvs87Jpslt3vFfInHmzser+Cw8=;
 b=Ck61Lx0ehyTwq3MavZh1G/Yx6KYVvumQFso/5CQ6GVU4bRiIDqqZauY9gdA0jbyOrJ2G6au9F+6ubvdtlJm77Uco8b6kU+RZqUgLYfK67aE/QXHP7MwlRMXyLjQ51Tg4UhEbM2I4dAcHepb3vHvXk/zVVd6UAaHsAm34mG0e4M0=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM0PR08MB11259.eurprd08.prod.outlook.com (2603:10a6:20b:6fc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 14:21:08 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:21:08 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 30/48] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Topic: [PATCH v4 30/48] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Index: AQHdG1sINndSYDiiUkegoFapvxqoarZ8jwCAgAsp8YA=
Date: Fri, 31 Jul 2026 14:21:08 +0000
Message-ID: <db0f40e80bf79ae2a6a1c052779d92ba2e7e3c5e.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-31-sascha.bischoff@arm.com>
	 <20260724115209.F0AFE1F000E9@smtp.kernel.org>
In-Reply-To: <20260724115209.F0AFE1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM0PR08MB11259:EE_|AMS1EPF0000004C:EE_|VI0PR08MB11081:EE_
X-MS-Office365-Filtering-Correlation-Id: 87203334-ccdf-41a2-78c9-08deef0f1c03
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|38070700021|56012099006|11063799006|5023799004|4143699003|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 GKJB3gvNydGrHEIOB0+zSgbSwoTGo+eTPV/k2HM1Rd1QLFij+aDBAhRWjdAzq4Fq/VSVNPvIcUrxzC/Ab/VOEsWx8rVpwOeMNxVk1Qfpk7Y2HG6I0v3t0vHZ6Otz+dpkJeda4Wy7NvZWC2J3eVqwGS5eXFtWCVJTRauXUSPgv1DF36xG7SUu7SXUGROMjuTn1241wU13Td7RIZTHHPX6cTA4u/ZM0uzS7NurN9q0GN7MwRn3YId9DW6NUPcJzm+7c2ph/8YnlkGWTRDedqO4rsN5/FFV0wODVVVSzo6avm0YB6CqsI8GS/xZo1aFiiVGK39J2SdT5cMxc0Ph96EZOhJUImTkd4MriUG5kWr9mgkiwVGZnYv8f1FmX0MLeTTJXMKcpAWLMnXd8x45TWPBvi63YdMZkktOC0EgLTXrf/vio0ERbkQIm2ke9r/9CnzCaUNZ7cjgi+7qUFMIMzyp1+TsXPQ0HOg7mFyackF+MGAlVYb8/oRPj1nbioIGne2We4XS5NVIIKD6ZxQb6gHs877AuWPXyu7Jov0W3OO/r8poEkMaW+dN8sQwl+zYIyKZs7vqU6tK5MKzQkCIjMYxRipG1NwfcCDAGmG7yfM48h27pl0kdH0djuGMPnI+KZToga3geYCy7LyFgIlcQpwUjyp6yi+CHjVss1eyBKAV5IASb6nvoDvwXZ3om0l0WkQNBBEBVOrAo+jyV4+Q2XneHgjuHh+A0QCSOxN53KmyQ6g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(38070700021)(56012099006)(11063799006)(5023799004)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF847228B4EAE54FAB433B8842AFF6DE@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 VmwyfGJ0SrRadKO9Bf7A+fSdhE+ExCmMZO9UIKRBvc93tse8pHYkvithlNryE3KARZXh2Jx/EuK/Fl6gVP9njH4GyW4Q5TWs3FRAvN4bntHNoU1lZjip+/a+5h6P6UfQCeEmwK4xjK4Zk0S5HEwqlfihqwao+AEr86mGXhuhcnibTy4evLdjQdWS2Oni125qzggLtci0g285k9z4dGttM0SyinCddckrkULpco2KNzBY6ZCk9E0bWNF1GiK8rSeqtj0OtMS75l923L4c5IJIdxaC/5nb6PbXeUP/v7GZRMwyhKHQxEMEmroYYOODAyPe9WavpgvCf9YD6KZSES34hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11259
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	650f61ec-dadf-4061-65cc-08deef0ef6db
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|376014|82310400026|23010399003|36860700016|4143699003|10067099003|6133799003|5023799004|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OJX3eU2mpspwRkl1Bnp1m5rJfxYy4GuGxRTPaUea5cALZl+Cet4/cTTf4vacAE9FSvW/YQuNwnZrWcmBBO8tq2iyktvIzGXexs6mc5oMU0P7r24mgAcNHc5zefVAq95MKJlWsK0Ghd2krAEw3up0UfPaW6amkqEfdD0srldEPVmSlB17cZ5YzSLfkwvVx7s+9ulLsoTguRtdGP8JylDzG+ReQBgHVhBOaxWpQFDPJMtoNK7lgyAvdKH+n18FnoNAhZcgZk0BWOI/EZ6Sffhjj7NyLdDoVV8wygf3xmKobEgeE3qRdrS3ay8p9wvri2OzoRQEVKMxxm2k0DdfqREB+5ysqskUZMXQ1cDy6G9iISY5hky8GDzJqx9v1Uv4DTf1ePZBKYyOw87MCMy2t8yz9apPhlqy7ogG4eXvQcj/XgbCwjt0vccitAg3pDE47DuXi8crE6JOURddbWg3YjKaWRFI1R38MUSDerZbcOWz2csQa7zQSlRIhcaMJnTotPTzwaKIrMvafRS7DWALHVPpG6TcvZrtgpx66gxaprNcwehOvxtRhm2AKHvqDGC79Ki2WvB1xFVxrPFkhPa2UloHfbJAQdQpFQHLfGLWh45tvQpDMikCCKzrE1WJF5RhoxaCujScBOUrFNM1N+O8UgV0ZLVikLvJh3NG6YemB2LhBjD09jww0X3o8h1Y5pTUJr7PPtp6Tosgkc28QaesmOZ8uQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(376014)(82310400026)(23010399003)(36860700016)(4143699003)(10067099003)(6133799003)(5023799004)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NfP2ylpYbWJCoXrwbbar2KF1c0SBdhATtosNTePhom+vJ7l60SNSJNvqK57UnX76mbnT3u6xy2nZnxQMUp01vlzAZn0QFPnAuKbZj4ImUVOqnxYAnGvaMWaxQIDZwqARZZfQv1RfUEbeTpy+lhl6QT5fGq7jIuEb04vIbWyHA3oWgVu66tXyRqcYDgpIEMnb/BXFVpxt+exSYF6dDdFLKJDlU5eX3NLCKn6FraO76FGAAwTb1H8LwKjRFlzNLOBwH+c3K96Rd/EYkQkKAQs6FN/In3sKrbfMtagmlz3Qsr87qNHPIEgNxxesnTeGrlcJXVVQQYZeLxpS2txMQCE4M2FI/bzWt0lCX4Ck5VtkldC8SzIjRNjCNo45sD9zeGn4qNCpRDmBXjWsCMo4TP+Uh+oCJxAKrPdPBRcUufJox98szy5Ruh9zddazvLLTNLDu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:22:10.5772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87203334-ccdf-41a2-78c9-08deef0f1c03
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11081

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjUyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IE5l
dyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIFJlc3RvcmVkIGFjdGl2ZSBzb2Z0d2FyZS1tYW5hZ2VkIFBQ
SXMgYXJlIG5vdCBxdWV1ZWQgdG8gdGhlDQo+IGFwX2xpc3QsIGxlYWRpbmcgdG8gbG9zdCBpbnRl
cnJ1cHRzIG9uIFZNIHJlc3RvcmUuDQo+IA0KPiBQcmUtZXhpc3RpbmcgaXNzdWVzOg0KPiAtIFtI
aWdoXSBEYXRhIHJhY2Ugb24gdGhlIGdsb2JhbCBgdmdpY19wcGlfbWFza2Agd2hlbiBgU1dfUFBJ
YCBpcyBub3QNCj4gaW1wbGVtZW50ZWQgaW4gaGFyZHdhcmUsIGxlYWRpbmcgdG8gZ3Vlc3Qgc3Rh
dGUgY29ycnVwdGlvbi4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMzBdOiBbUEFUQ0ggdjQgMzAv
NDhdIEtWTTogYXJtNjQ6IGdpYy12NTogTWFzayBwZXItdmNwdQ0KPiBQUEkgc3RhdGUgaW4gdmdp
Y192NV9maW5hbGl6ZV9wcGlfc3RhdGUoKSAtLS0NCj4gY29tbWl0IDA0YTk0MDdlZDM2MDVjYzM5
M2Q3ZGNlNDU0NTZmMTdjOWUxZmMyYzMNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2No
YS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBNYXNrIHBlci12
Y3B1IFBQSSBzdGF0ZSBpbg0KPiB2Z2ljX3Y1X2ZpbmFsaXplX3BwaV9zdGF0ZSgpDQo+IA0KPiBU
aGlzIGNvbW1pdCByZXdvcmtzIHZnaWNfdjVfZmluYWxpemVfcHBpX3N0YXRlKCkgdG8gZGlzY292
ZXIgZXhwb3NlZA0KPiBQUElzIGFuZA0KPiBtYXNrIG5vbi1leHBvc2VkIFBQSSBzdGF0ZSB3aGVu
IFZDUFVzIGFyZSBmaXJzdCBydW4uIEl0IGNsZWFycyBzdGF0ZQ0KPiBmb3INCj4gbm9uLWV4cG9z
ZWQgUFBJcyB0byBlbnN1cmUgb25seSB0aGUgaW50ZW5kZWQgc3RhdGUgaXMgZXhwb3NlZCB0byB0
aGUNCj4gZ3Vlc3QNCj4gYWZ0ZXIgdXNlcnNwYWNlIHJlc3RvcmVzIHRoZSBzdGF0ZS4NCj4gDQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IDA0MzkyYjY4NmMyZTIuLjZhZjEy
NjRlZDIzNzEgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMN
Cj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiBbIC4uLiBdDQo+ID4g
QEAgLTc5NSwzNSArNzk2LDY1IEBAIGludCB2Z2ljX3Y1X2ZpbmFsaXplX3BwaV9zdGF0ZShzdHJ1
Y3Qga3ZtDQo+ID4gKmt2bSkNCj4gPiDCoAlndWFyZChtdXRleCkoJmt2bS0+YXJjaC5jb25maWdf
bG9jayk7DQo+ID4gwqANCj4gPiDCoAkvKg0KPiA+IC0JICogSWYgU1dfUFBJIGhhcyBiZWVuIGFk
dmVydGlzZWQsIHRoZW4gd2Uga25vdyB3ZSBhbHJlYWR5DQo+ID4gLQkgKiBpbml0aWFsaXNlZCB0
aGUgd2hvbGUgdGhpbmcsIGFuZCB3ZSBjYW4gcmV0dXJuIGVhcmx5Lg0KPiA+IFllcywNCj4gPiAt
CSAqIHRoaXMgaXMgcHJldHR5IGhhY2tpc2ggYXMgZmFyIGFzIHN0YXRlIHRyYWNraW5nIGdvZXMu
Li4NCj4gPiArCSAqIERpc2NvdmVyIHRoZSBzZXQgb2YgUFBJcyB0aGF0IGFyZSBleHBvc2VkIHRv
IHRoZSBndWVzdA0KPiA+IG9uY2UgcGVyIFZNLg0KPiA+ICsJICogT25jZSBrbm93biwgYXBwbHkg
dGhhdCBtYXNrIHRvIGVhY2ggVkNQVSdzIHJlc3RvcmVkIFBQSQ0KPiA+IHN0YXRlIGFzIHRoZQ0K
PiA+ICsJICogVkNQVXMgYXJlIGZpcnN0IHJ1bi4NCj4gPiDCoAkgKi8NCj4gPiAtCWlmICh0ZXN0
X2JpdChHSUNWNV9BUkNIX1BQSV9TV19QUEksIGt2bS0NCj4gPiA+YXJjaC52Z2ljLmdpY3Y1X3Zt
LnZnaWNfcHBpX21hc2spKQ0KPiA+IC0JCXJldHVybiAwOw0KPiA+IC0NCj4gPiAtCS8qIFRoZSBQ
UEkgc3RhdGUgZm9yIGFsbCBWQ1BVcyBzaG91bGQgYmUgdGhlIHNhbWUuIFBpY2sNCj4gPiB0aGUg
Zmlyc3QuICovDQo+ID4gLQl2Y3B1MCA9IGt2bV9nZXRfdmNwdShrdm0sIDApOw0KPiA+ICsJaWYg
KCF0ZXN0X2JpdChHSUNWNV9BUkNIX1BQSV9TV19QUEksIGt2bS0NCj4gPiA+YXJjaC52Z2ljLmdp
Y3Y1X3ZtLnZnaWNfcHBpX21hc2spKSB7DQo+ID4gKwkJYml0bWFwX3plcm8oa3ZtLT5hcmNoLnZn
aWMuZ2ljdjVfdm0udmdpY19wcGlfbWFzaywNCj4gPiArCQkJwqDCoMKgIFZHSUNfVjVfTlJfUFJJ
VkFURV9JUlFTKTsNCj4gPiArCQliaXRtYXBfemVybyhrdm0tPmFyY2gudmdpYy5naWN2NV92bS52
Z2ljX3BwaV9obXIsDQo+ID4gKwkJCcKgwqDCoCBWR0lDX1Y1X05SX1BSSVZBVEVfSVJRUyk7DQo+
IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IFRoaXMgaXMgYSBwcmUtZXhpc3RpbmcgaXNzdWUsIGJ1
dCBkb2VzIHRoaXMgY29uZGl0aW9uYWwgaW4NCj4gdmdpY192NV9maW5hbGl6ZV9wcGlfc3RhdGUo
KSBjcmVhdGUgYSBkYXRhIHJhY2Ugb24gdGhlIGdsb2JhbA0KPiB2Z2ljX3BwaV9tYXNrDQo+IGlm
IHRoZSBTV19QUEkgZmVhdHVyZSBpcyBub3QgaW1wbGVtZW50ZWQgaW4gaGFyZHdhcmU/DQoNCkZy
b20gdGhlIEEuYSBHSUN2NSBzcGVjOg0KDQpSX01TV0ZCDQpXaGVuIEZFQVRfR0NJRSBpcyBpbXBs
ZW1lbnRlZCwgUFBJIDMgKFNXX1BQSSkgaXMgaW1wbGVtZW50ZWQuDQoNClNvLCBpZiB3ZSBoYXZl
IEdJQ3Y1LCB3ZSBoYXZlIHRoZSBTV19QUEkuIE5vIHF1ZXN0aW9uLg0KDQo+IA0KPiBJbiBhIG11
bHRpLVZDUFUgVk0gYm9vdGluZyBvbiBHSUN2NSBoYXJkd2FyZSB3aXRob3V0IHRoZSBvcHRpb25h
bA0KPiBTV19QUEkNCj4gZmVhdHVyZSwgd2hlbiBhIHN1YnNlcXVlbnQgVkNQVSBydW5zIGZvciB0
aGUgZmlyc3QgdGltZSwgdGhpcyB0ZXN0DQo+IHdpbGwNCj4gZXZhbHVhdGUgdG8gZmFsc2UgYmVj
YXVzZSB0aGUgYml0IHdhcyBuZXZlciBzZXQuDQo+IA0KPiBUaGlzIHNlZW1zIHRvIGNhdXNlIHRo
ZSBnbG9iYWwgbWFzayB0byBiZSBjbGVhcmVkIHZpYSBiaXRtYXBfemVybygpDQo+IHdoaWxlDQo+
IGVhcmxpZXIgVkNQVXMgbWlnaHQgYWxyZWFkeSBiZSBydW5uaW5nIGluIHRoZSBndWVzdC4gQ291
bGQgdGhpcyBsZWFkDQo+IHRvIGENCj4gdHJhbnNpZW50bHkgemVyb2VkIHZnaWNfcHBpX21hc2sg
ZHVyaW5nIHN5c3JlZyBhY2Nlc3NlcyBhbmQgc2lsZW50bHkNCj4gZHJvcHBlZA0KPiBpbnRlcnJ1
cHRzIGZvciBlbXVsYXRlZCBkZXZpY2VzIGxpa2UgdGltZXJzPw0KPiANCj4gPiArDQo+ID4gKwkJ
Zm9yX2VhY2hfc2V0X2JpdChpLCBwcGlfY2Fwcy5pbXBsX3BwaV9tYXNrLA0KPiA+IFZHSUNfVjVf
TlJfUFJJVkFURV9JUlFTKSB7DQo+IFsgLi4uIF0NCj4gPiArCS8qIEFsc28gdXBkYXRlIHRoZSB2
Z2ljX2lycXMgKi8NCj4gPiArCWZvciAoaSA9IDA7IGkgPCBWR0lDX1Y1X05SX1BSSVZBVEVfSVJR
UzsgaSsrKSB7DQo+ID4gKwkJYm9vbCB2aXNpYmxlID0gdGVzdF9iaXQoaSwga3ZtLQ0KPiA+ID5h
cmNoLnZnaWMuZ2ljdjVfdm0udmdpY19wcGlfbWFzayk7DQo+ID4gwqAJCWNvbnN0IHUzMiBpbnRp
ZCA9IHZnaWNfdjVfbWFrZV9wcGkoaSk7DQo+ID4gwqAJCXN0cnVjdCB2Z2ljX2lycSAqaXJxOw0K
PiA+IMKgDQo+ID4gLQkJaXJxID0gdmdpY19nZXRfdmNwdV9pcnEodmNwdTAsIGludGlkKTsNCj4g
PiArCQlpcnEgPSB2Z2ljX2dldF92Y3B1X2lycSh2Y3B1LCBpbnRpZCk7DQo+ID4gwqANCj4gPiAt
CQkvKiBFeHBvc2UgUFBJcyB3aXRoIGFuIG93bmVyIG9yIHRoZSBTV19QUEksIG9ubHkNCj4gPiAq
Lw0KPiA+IMKgCQlzY29wZWRfZ3VhcmQocmF3X3NwaW5sb2NrX2lycXNhdmUsICZpcnEtPmlycV9s
b2NrKQ0KPiA+IHsNCj4gPiAtCQkJaWYgKGlycS0+b3duZXIgfHwgaSA9PQ0KPiA+IEdJQ1Y1X0FS
Q0hfUFBJX1NXX1BQSSkgew0KPiA+IC0JCQkJX19zZXRfYml0KGksIGt2bS0NCj4gPiA+YXJjaC52
Z2ljLmdpY3Y1X3ZtLnZnaWNfcHBpX21hc2spOw0KPiA+IC0JCQkJX19hc3NpZ25fYml0KGksIGt2
bS0NCj4gPiA+YXJjaC52Z2ljLmdpY3Y1X3ZtLnZnaWNfcHBpX2htciwNCj4gPiAtCQkJCQnCoMKg
wqDCoCBpcnEtPmNvbmZpZyA9PQ0KPiA+IFZHSUNfQ09ORklHX0xFVkVMKTsNCj4gPiArCQkJaWYg
KCF2aXNpYmxlKSB7DQo+ID4gKwkJCQlpcnEtPmVuYWJsZWQgPSBmYWxzZTsNCj4gPiArCQkJCWly
cS0+YWN0aXZlID0gZmFsc2U7DQo+ID4gKwkJCQlpcnEtPnBlbmRpbmdfbGF0Y2ggPSBmYWxzZTsN
Cj4gPiArCQkJCWlycS0+bGluZV9sZXZlbCA9IGZhbHNlOw0KPiA+ICsJCQl9IGVsc2Ugew0KPiA+
ICsJCQkJaXJxLT5lbmFibGVkID0gdGVzdF9iaXQoaSwgY3B1X2lmLQ0KPiA+ID52Z2ljX3BwaV9l
bmFibGVyKTsNCj4gPiArCQkJCWlycS0+YWN0aXZlID0gdGVzdF9iaXQoaSwgY3B1X2lmLQ0KPiA+
ID52Z2ljX3BwaV9hY3RpdmVyKTsNCj4gPiDCoAkJCX0NCj4gPiDCoAkJfQ0KPiANCj4gW1NldmVy
aXR5OiBIaWdoXQ0KPiBJcyBpdCBzYWZlIHRvIGRpcmVjdGx5IHNldCBpcnEtPmFjdGl2ZSBoZXJl
IHdpdGhvdXQgcXVldWVpbmcgdGhlDQo+IGludGVycnVwdD8NCj4gDQo+IFdoZW4gcmVzdG9yaW5n
IGEgVk0gd2l0aCBhY3RpdmUgc29mdHdhcmUtbWFuYWdlZCBQUElzIChsaWtlIHRoZSBQTVUNCj4g
b3IgdGltZXJzKSwNCj4gd2UgbXV0YXRlIGlycS0+YWN0aXZlIGluc2lkZSB0aGUgbG9jayBpbg0K
PiB2Z2ljX3Y1X2ZpbmFsaXplX3BwaV9zdGF0ZSgpLCBidXQgd2UNCj4gZG9uJ3Qgc2VlbSB0byBp
bnZva2UgdGhlIGNvcnJlc3BvbmRpbmcgcXVldWVpbmcgbWFjaGluZXJ5Lg0KPiANCj4gV2l0aG91
dCBlbnF1ZXVpbmcgdGhlIElSUSBvbnRvIHRoZSBWQ1BVJ3MgYXBfbGlzdCwgd29uJ3QgdGhpcyBj
YXVzZQ0KPiB0aGUNCj4gaW50ZXJydXB0IHRvIGJlIGludmlzaWJsZSB0byB0aGUgaW5qZWN0aW9u
IHBhdGggYW5kIGdldCBsb3N0IG9uIFZNDQo+IHJlc3RvcmU/DQoNCk5vLCBiZWNhdXNlIHdlIGFs
d2F5cyBjb25zaWRlciBhbGwgUFBJcyAodGhhdCB3ZSBpbnRlbmQgdG8gZXhwb3NlIHRvDQp0aGUg
Z3Vlc3QpLiBXZSBkb24ndCBoYXZlIGFuIEFQIGxpc3QgYXQgYWxsIGZvciBQUElzIG9uIEdJQ3Y1
Lg0KDQo+IA0KPiA+IMKgDQo+ID4gLQkJdmdpY19wdXRfaXJxKHZjcHUwLT5rdm0sIGlycSk7DQo+
ID4gKwkJdmdpY19wdXRfaXJxKGt2bSwgaXJxKTsNCj4gPiDCoAl9DQo+IA0KDQpUaGFua3MsDQpT
YXNjaGENCg==
