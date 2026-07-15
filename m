Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011070.outbound.protection.outlook.com [52.101.65.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114D53B42C7;
	Wed, 15 Jul 2026 16:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784133335; cv=fail; b=Csar0+3WrFVO0tEjq1Wqu2zdMgahl838lDOuW43Tue80gjt3bDt7H5vLbett1mpn0B/Ut8BVb5rB51NkfKwSdMG4KaG/07VDwFMprgTWd+cLb+kOOTNd1k5GK42KAecIrI/h9Uh44yELZByWqVFdtreMemHuIYaVeKgVdj9YNmU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784133335; c=relaxed/simple;
	bh=ghRyVKVQIuTLtwmwAVYuBpoUvPqUio/N8N8VAgFXJBs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D5aH+nyHIaY+AFygr9Xy8oUlHuUDF8eJkqm56clSbI0LAV8wjKQNnwRY7jee9vchrlpWCfK3a2x7VnsmsoUeBJynAPQQdqex1/s5YQQx4QsSmSG7z7lfkuli9nkMbbAO0HaToM7BSrRRrZdsEziPfLnoZP2Wv/ZNqaXurtCo7dk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=maLas/sk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=maLas/sk; arc=fail smtp.client-ip=52.101.65.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="maLas/sk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="maLas/sk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ykbyrk0h/cT3FgcFoeloBeYwuKP1gyzGDV4NrlaGBPKYXJ7vfGqBjVxAV4jOUvGwm8QZzhBJ8vxEht/LMZwbxRZSaqwhRb4m+C+AN/vJvPnTMWIEvQ8anqB2nasaJRsiG5d162ULuAlflIXDJgmEenLgaym/ogAJE/S8PZb7h88xgiJGFFX7J7UkTaBOIE+FsH9SKC0DWce9+1gBqu3LTLe4YAYEj8Lb1MFW8NBb3/vEgb4hkYrCICu1wOYvFFMTIY8Z66AeHaOCQzfWF6pC5bCREdlkXcmbdCufME52hu8GCYFR/eD7+1q6pjeX0XLeTQ6RLxDTpUi/iB56ly1FRw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghRyVKVQIuTLtwmwAVYuBpoUvPqUio/N8N8VAgFXJBs=;
 b=PMyT4n/5PS3Ot+a0CK+Pm9M4yLrmO+vBCJz15Hz7CWR1GPq4ni5JBlhRKvIM09px0gCfm2CXzz0ogCYyiBEL+jiwXUtoTO+6lE3HB+kz4xcpkeCJIQ2/2JkFS0MDPpdNhu3JbM565TywhgR44mPXp5hehO5EZtDzkfl1SsXARTQp/WnZs9yC6MtyMbWvld8ICUENrC1wKZtqs6w8f/QmRq2fZL4SkHH2Nl2EWZKVvkd0GMgR/4rFoc9rL7uwa7E4K6TMuu5mwA6uxD/AJzzJsIuVEJUDWWPh8rDbKFDxWjdpJFBTYXwTZBDYWFpvSPmxCYQK/iCOTnrfqEv2fb3GlA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghRyVKVQIuTLtwmwAVYuBpoUvPqUio/N8N8VAgFXJBs=;
 b=maLas/skaTuKsYOLj79n2YGP3Ke/DRw3RgZXOpvIkyVWtfphjiTRW7p3bpzLSubrJEe2szTLLhv+MPfiy6htZr73B/EczpgsAV87V3h9yucg4tStvYBIlNlVRaojwVOhxc98aLHBjWILgFBIeOmXZdMBAs9/daPNr0xpG/1NiUA=
Received: from AS9PR06CA0753.eurprd06.prod.outlook.com (2603:10a6:20b:484::9)
 by AS8PR08MB5879.eurprd08.prod.outlook.com (2603:10a6:20b:293::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Wed, 15 Jul
 2026 16:35:26 +0000
Received: from AM4PEPF00027A62.eurprd04.prod.outlook.com
 (2603:10a6:20b:484:cafe::26) by AS9PR06CA0753.outlook.office365.com
 (2603:10a6:20b:484::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Wed,
 15 Jul 2026 16:35:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A62.mail.protection.outlook.com (10.167.16.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Wed, 15 Jul 2026 16:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=koNH0ID+o5eMHWGTeYPRX8nCYtRUNDVxi6WCO0jQrIMtWmcgOTsWJvk6ddi9ZhlU7KqJ+nvlKKQ/Hwm4WExr65MyqR4FDEm0nxkeNDZ0K6gNu7yHqf74l0xSRIgAjxa3tUrHI5dl3mvFyND8hkugVNmsz0QeKQ2Aw8D5W46u5xl1JHtLFuCaXpB+/fb/EJ0J7c24snKG/mgQkoRtaNDkPIDTeEis89XBiQfnRaBmHRs4BGZkPeWhhR/rAz5rvnmjiiDABYDgmLVLA0PuoG3oMAuUhoet1WqDFd3Ga+k3b0KuwwPXvS8nUUtu5uLoWlPL304xmxZqIFuPfu7IAZmS9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghRyVKVQIuTLtwmwAVYuBpoUvPqUio/N8N8VAgFXJBs=;
 b=OXzhkAYfKHyYtF5o2keIavaG2oGG9RdH3OuAxOzfzlboWEqLxasSSXNPns+zcTR23xDXMkvPEDtJZbk66uhK/rbXYmPN+WyTPCuaLXPQA8SQyFFYRkTvMZxHxch09r6tqiGDxt7s9EbnnFlSrN9EZOOrd2/qU2Id/wg5g6+ji1qUjtNTaRk4JjgmjcsyIm2vBnhv9x7a99tqnNbVn+Ym/DavdLH6VA4pPGdN8WsSWHDAsgjLBifjwmE2fLtV/NZQNBYQMH01hzVMHaPJMDvOJmYUTrcJWqrzsxtROxThXLkEgqPXK5HSGaOrm17e2elKUcpp2MtQYFhUO7z/hUOrqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghRyVKVQIuTLtwmwAVYuBpoUvPqUio/N8N8VAgFXJBs=;
 b=maLas/skaTuKsYOLj79n2YGP3Ke/DRw3RgZXOpvIkyVWtfphjiTRW7p3bpzLSubrJEe2szTLLhv+MPfiy6htZr73B/EczpgsAV87V3h9yucg4tStvYBIlNlVRaojwVOhxc98aLHBjWILgFBIeOmXZdMBAs9/daPNr0xpG/1NiUA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV1PR08MB10840.eurprd08.prod.outlook.com (2603:10a6:150:160::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Wed, 15 Jul
 2026 16:34:21 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:34:20 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 35/40] KVM: arm64: gic-v5: Add CoreSight MMIO regs to
 IRS
Thread-Topic: [PATCH v3 35/40] KVM: arm64: gic-v5: Add CoreSight MMIO regs to
 IRS
Thread-Index: AQHdCwYrVcyZMgeIn0GYMvKA+miVSbZb/34AgBLaCAA=
Date: Wed, 15 Jul 2026 16:34:20 +0000
Message-ID: <200e6920d2ba99a872951ad226c49fe88afede23.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-36-sascha.bischoff@arm.com>
	 <20260703164119.2A84B1F000E9@smtp.kernel.org>
In-Reply-To: <20260703164119.2A84B1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV1PR08MB10840:EE_|AM4PEPF00027A62:EE_|AS8PR08MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: a50528d7-1cee-4b35-5e04-08dee28f131a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|4143699003|6133799003|56012099006|11063799006|10067099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 RUFGqIXf6Qar2MoMlfZsJTstQFgKRMYH/gwN9vY6IoZD2kUrRNs5ffh9l/++8o900A1Z3166cf5IMh3wqbSw3LoYDRMXTET62V9/ev1ZNDuOB5hXQn+818DVkxH+jz46vcYaOLpWcwjwVoePlF6CExSIXGGaXDL0ucDzChSzIcc0u89WOvWJmMlqPkRjNli8uVzmxwhuChoCxUtsqGMmAKbBOPYeyDhAVkgCmmPbP5whAKr2CgsfPlUvjW9ZkHCyX8KEF6oOfz9GyyHotcfRsd4A1oQ5R/WA99GQfQ8Jygp+loErRI1JDFd67RGijjLd+3qzCIF2tXsE89pUr7eQTBtSh0Pq0mfZLX5y336fBc/jg63bNeCYyWBkpUGvXfq020ZMt8SyK8u2CwysmOpRoxa+0PLD0Ft6XHnZDYddr2cyn+xUzgFlJoVoHhHdoYVNIaZqV4Gv4ajI/xhUqUP244y7Q4Q4q84/YTh6HVlvdMRc/aADR13ZHo27cPe0pQUXvQRnISXlckE3/5+yRrV3qf2uYM711bf8GDXliEIGXCWxZDotTF+89aBdA8yN5tYvkCavMkHSGIPoM+1oWFk+UJoiue7SjMkOOcnNAsvRUeMaV3iFMYyf38TZStv0xXJ4J3ayczvs2I3brOao/KUJMoHr1UY0zE7+S48XHmlk9IjVC4djNTo4wwJb7aqP9JMkyTgwkgirf2QyeRaD/8/3Mb03W8yut1iBbi2k1Yjbhok=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(6133799003)(56012099006)(11063799006)(10067099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <246B25A045C6E24DAC43387A61287B93@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 qpjXSfpsAOD5TlWtBnVGWIGiYKeKFuYauRu3tQXFeBkoqBACN5FyK2n1HMPVe6Cj/V2SjZo1eYW/1NseJ6GdWK3F9icueFhWk4cxG6rMXGt3BXg8cJcclaXaYT7b4pB5Zy4D6ESpHkaCR/IlM8/4cFpU7LIdnE5lhd/EpEwHtWvHCkbiHqeIdcm4xzabPi9i8iUDd1cB2GFyHFw+Lig7zGdVPG+zAIqmg4r7KyXEKyb/QhN754Xmy9aQeBDzUlSvpr9gybEcl3Ue2kU42qvMf1BCasIUNcU+v8DU2QGl18BNtbTdqxqoMQHtu7kzkIn0xBPx/h6bgw1UF3JD79Rtgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10840
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A62.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fced1b43-df9b-48cb-845f-08dee28eec37
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|376014|14060799003|36860700016|35042699022|6133799003|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u9wIXA0QHtxiJTFseRU6MptFEBaFip5x3dbxluQ1ctWchzliQVexibH2/ttXGCuHUS6iLrkA9Yww3N2hV/7LgHRsXl8MVCVnGrP8N8eHywxQj2vWehuPiKCSSTOlZmD1aOBP6doCPjKiapY+0vCm+RNAEJufAP5pZUOmfyeHdY6PVu8l/thn7PNUn4CoSbRtHIiVKlS0mIyN8MChSoS7VGlkpVOkmTKr9NZN+kWDxHUIjZ7rBUmkKCV8tZk42U+n/xzWOgsSDOcSG8IhL25qCJQPXAQZCKSris98KUxMv+ftXNExAQLjMyLi79W1shdGxSQxcXZ9GdCECJ0JcMIhsvLkFw2Kat0ilv8Ej4436NsA72O+Kg0ooIEv6BxXVjlG4khzzhe7r3P/GaW98V7fBaDZfECizN+iwgQPMk9OTCHRBrtp27wxBl/ZZYE6zh2qxzW3B0M3VEtzTBEwgWhXEge12g0SRxgWN49qKdj1gBg3kStono9ykDyX7v1BF1KqeFAWqgl37Z0sTF3uwUEQmV/1oqFc0SiYBeNCQbHh+ZiGD9X8Iok8paJIbNuoyZJdXn7nsZxoY6FYcrETeSM+ZGV1VeOgvOdgEiEt/+pf8W+p1+XGyUcPLjIpNtjZm0jaWIp+W0Hp43LZe8UmBU6WKwiIf0HA8HScImNSnwCvq26d9NV4vzRt/0hEhU4KoMxuB3HssWbBjve3zLqDwljyTg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(376014)(14060799003)(36860700016)(35042699022)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/wuVLOI7oV+M52MYUBBfNk0e0G/Csz+uWwvT9RkVZSQQ4GoEyozdUyLdRbscaeOtlDFx+NksvCOd4aHpe3rFvj4s2ssjOmJpi+cncOl0/g3UJlEW1H2XorbQocQ1eqBb98JA/rI4GKyXB85Qr4wMpufDtKoAoRo1aG+S1WFE5QO2JF7GzjX545X8bstJEIGzZZ/IAE2q4Cyc0jiQEQJk8di1GY+IkLlvdLHkBhQJVizlFrg/dzIOcdtiBy504LPDRx8fknsRRhhTNayRo7MZr06h335CbmbiJgm1y2jJ5xDbas+jx8BlongG5mHVOI660nApor9f7BSgWX3Y0M+W8Utr1Fj57k8k1bGe8zdKwa14LguxaI9UIDlaxMHz0z5H7xMW0yvRRciuvNIhDKMGFqN3MZX6I2U1WlmbOn5TNtgSh7mp5HQvZNjYyf+bf2NL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:35:26.0913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a50528d7-1cee-4b35-5e04-08dee28f131a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A62.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5879

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjQxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBNaXNzaW5nIE1NSU8gcmVnaXN0ZXIgZGVzY3JpcHRvcnMgZm9yIHRoZSBzZWNvbmQgNjRL
Qg0KPiBmcmFtZSBvZiB0aGUgR0lDdjUgSVJTLg0KPiAtLQ0KPiANCj4gY29tbWl0IDE1YmQyZjk5
NWY2ZTkzMzBlOGFhYjk5ZWU0MjEyYTg4MmI1NTRhMTcNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hv
ZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBB
ZGQgQ29yZVNpZ2h0IE1NSU8gcmVncyB0byBJUlMNCj4gwqDCoMKgIA0KPiBUaGlzIGNvbW1pdCBl
eHBvc2VzIHRoZSBDb3JlU2lnaHQgaWRlbnRpZmljYXRpb24gcmVnaXN0ZXJzIGluIHRoZQ0KPiBl
bXVsYXRlZA0KPiBHSUN2NSBJUlMgTU1JTyByZWdpb24uIEl0IHJldHVybnMgdGhlIGFyY2hpdGVj
dHVyYWwgaWRlbnRpZmljYXRpb24NCj4gdmFsdWVzIG9uDQo+IHJlYWRzIGFuZCBpZ25vcmVzIHdy
aXRlcy4NCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJzLXY1
LmMNCj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJzLXY1LmMNCj4gaW5kZXggMWQ2M2Nm
ZTcwNGZkYS4uMTdiZTc3NmI0YTJiOSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLWlycy12NS5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnMtdjUu
Yw0KPiBAQCAtNDY1LDYgKzQ2NSw0MyBAQCBzdGF0aWMgdm9pZCB2Z2ljX3Y1X21taW9fd3JpdGVf
aXJzX2lzdChzdHJ1Y3QNCj4ga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGFkZHIsDQo+IMKgCX0NCj4g
wqB9DQo+IMKgDQo+ID4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIHZnaWNfdjVfY29yZXNpZ2h0X3Jl
YWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+ICsJCQkJCcKgwqDCoCBncGFfdCBhZGRyLCB1
bnNpZ25lZA0KPiA+IGludCBsZW4pDQo+ID4gK3sNCj4gPiArCWNvbnN0IHNpemVfdCBvZmZzZXQg
PSBhZGRyICYgKFNaXzY0SyAtIDEpOw0KPiANCj4gW1NldmVyaXR5OiBNZWRpdW1dDQo+IFRoZSBo
YW5kbGVyIG1hc2tzIHRoZSBhZGRyZXNzIHRvIHN1cHBvcnQgYm90aCA2NEtCIGZyYW1lcywgYnV0
IGlzIGl0DQo+IHBvc3NpYmxlDQo+IHRoYXQgYWNjZXNzZXMgdG8gdGhlIHNlY29uZCBmcmFtZSB3
aWxsIG5ldmVyIGFjdHVhbGx5IHJlYWNoIHRoaXMNCj4gZnVuY3Rpb24/DQoNCkJlbGlldmUgaXQg
b3Igbm90LCB0aGF0IGlzIHRoZSBpbnRlbnQhIE9ubHkgYWNjZXNzIGZyb20gdGhlIGZpcnN0IGZy
YW1lDQpzaG91bGQuDQoNCj4gDQo+IFRoZSBLVk0gTU1JTyBkaXNwYXRjaGVyIHJlbGllcyBvbiB0
aGUgdmdpY192NV9pcnNfcmVnaXN0ZXJzIGFycmF5DQo+IGJlbG93IHRvDQo+IGZpbmQgdGhlIGFw
cHJvcHJpYXRlIGhhbmRsZXIuIElmIHRoZSBkZXNjcmlwdG9ycyBmb3IgdGhlIHNlY29uZCBmcmFt
ZQ0KPiBhcmUNCj4gbWlzc2luZyBmcm9tIHRoZSBhcnJheSwgdGhlIGRpc3BhdGNoZXIgd2lsbCBy
ZWplY3QgdGhlIGFjY2VzcyBhbmQNCj4gcmV0dXJuIDANCj4gYmVmb3JlIGV2ZXIgY2FsbGluZyB0
aGlzIGhhbmRsZXIuDQoNCll1cC4gQnkgZGVzaWduLg0KDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiBA
QCAtNzc2LDYgKzgxMyw0NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHZnaWNfcmVnaXN0ZXJfcmVn
aW9uDQo+IHZnaWNfdjVfaXJzX3JlZ2lzdGVyc1tdID0gew0KPiDCoAlSRUdJU1RFUl9ERVNDX1dJ
VEhfTEVOR1RIKEdJQ1Y1X0lSU19TV0VSUl9TWU5EUk9NRVIxLA0KPiDCoAkJCQnCoCB2Z2ljX21t
aW9fcmVhZF9yYXosDQo+IHZnaWNfbW1pb193cml0ZV93aSwgOCwNCj4gwqAJCQkJwqAgVkdJQ19B
Q0NFU1NfNjRiaXQpLA0KPiA+ICsNCj4gPiArCS8qIENvcmVTaWdodCBpZGVudGlmaWNhdGlvbiBy
ZWdpc3RlcnMgKi8NCj4gPiArCVJFR0lTVEVSX0RFU0NfV0lUSF9MRU5HVEgoR0lDVjVfQ09SRVNJ
R0hUX0RFVkFSQ0gsDQo+ID4gKwkJCQnCoCB2Z2ljX3Y1X2NvcmVzaWdodF9yZWFkLA0KPiA+IHZn
aWNfbW1pb193cml0ZV93aSwgNCwNCj4gPiArCQkJCcKgIFZHSUNfQUNDRVNTXzMyYml0KSwNCj4g
DQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBEb2VzIHRoaXMgYXJyYXkgbmVlZCBleHBsaWNpdCBk
ZXNjcmlwdG9ycyBmb3IgdGhlIHNlY29uZCA2NEtCIGZyYW1lPw0KDQpOby4gVGhleSBhcmUgb25s
eSBpbiB0aGUgSVJTX0NPTkZJR19GUkFNRS4gV2UgcmVzZXJ2ZSB0d28gNjRLQiBmcmFtZXMNCmZv
ciB0aGUgSVJTIGFzIGl0IGNhbiB0ZWNobmljYWxseSBoYXZlIGEgSVJTX1NFVExQSV9GUkFNRS4g
V2UgZG9uJ3QNCmV4cGVjdCBhbnkgYWNjZXNzZXMgdG8gdGhlIHNlY29uZCBmcmFtZSwgaG93ZXZl
ciwgYW5kIHRoZXJlZm9yZSBkb24ndA0KZW11bGF0ZSBhbnkgTU1JTyByZWdpc3RlciBhY2Nlc3Nl
cyB0byB0aGF0IHJlZ2lvbi4gTW9yZW92ZXIsIGFzIHBlciB0aGUNCkdJQ3Y1IHNwZWMsIG9ubHkg
dGhlIElSU19DT05GSUdfRlJBTUUgaGFzIHRoZXNlIENvcmVTaWdodCByZWdpc3RlcnMuDQoNCj4g
DQo+IFNpbmNlIHZnaWNfdjVfaXJzX3JlZ2lzdGVycyBvbmx5IGNvbnRhaW5zIGRlc2NyaXB0b3Jz
IGZvciB0aGUgZmlyc3QNCj4gZnJhbWUncw0KPiBDb3JlU2lnaHQgcmVnaXN0ZXJzLCBhIGd1ZXN0
IHJlYWRpbmcgZnJvbSB0aGUgc2Vjb25kIGZyYW1lIA0KPiAoZS5nLiwgU1pfNjRLICsgR0lDVjVf
Q09SRVNJR0hUX0RFVkFSQ0gpIHdpbGwgbm90IG1hdGNoIGFueSBlbnRyeQ0KPiBkdXJpbmcgdGhl
DQo+IHNlYXJjaCBpbiB2Z2ljX2ZpbmRfbW1pb19yZWdpb24oKS4NCj4gDQo+IFdpbGwgdGhpcyBj
YXVzZSB0aGUgZGlzcGF0Y2hlciB0byB0cmVhdCB0aGUgc2Vjb25kIGZyYW1lIGFjY2VzcyBhcw0K
PiB1bmhhbmRsZWQNCj4gYW5kIHJldHVybiAwLCBsZWF2aW5nIHRoZSBtYXNraW5nIGxvZ2ljIGlu
IHZnaWNfdjVfY29yZXNpZ2h0X3JlYWQoKQ0KPiBhcyBkZWFkDQo+IGNvZGU/DQoNClRoZXkgYXJl
IG5vdCBkZWFkIGNvZGUuIFRoZXkgYXJlIHVzZWQgZm9yIHRoZSBmaXJzdCBmcmFtZS4NCg0KPiAN
Cj4gPiArCVJFR0lTVEVSX0RFU0NfV0lUSF9MRU5HVEgoR0lDVjVfQ09SRVNJR0hUX1BJRFI0LA0K
PiA+ICsJCQkJwqAgdmdpY192NV9jb3Jlc2lnaHRfcmVhZCwNCj4gPiB2Z2ljX21taW9fd3JpdGVf
d2ksIDQsDQo+ID4gKwkJCQnCoCBWR0lDX0FDQ0VTU18zMmJpdCksDQo+IA0KPiBbIC4uLiBdDQo+
IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
