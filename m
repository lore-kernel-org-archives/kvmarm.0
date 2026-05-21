Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013025.outbound.protection.outlook.com [40.107.162.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0368D31283E
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.25
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375620; cv=fail; b=CFCnHEZu7rITD7omZBH5NoCUYKULX8O8i1Ojkm30wTtB2ZGyQMKimQjTgdYuIRsypow5ktwGVARaJ0EzKkJG2BHLMyZP3MxjIsIPj6IvNZidt2SbrcHdu3t97nvoR7J/9OQAGbWQ33TI49raqMK6tlz0918niIbMlAlmxb8Cvyk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375620; c=relaxed/simple;
	bh=wJFSAj7VvUDNYmrAPb0uK+u2pPDKsyNwq7INGBggdzY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ISWRREikQ7B80E32adhKZneAn0dWCM7X8AWhk2tzbDIq2ZiLkK+ljWS+RiG20vqRkJMqLczsT9oENsXUy4QbmkXPu2bhY4y/Zb3l+OB0xmljMqJqQNNCgjJOEx+MwUZkMfY+3P6o81TyPjQjwyxcnMmnXQYGhL3Zfnx470itSHY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JI7XsuoB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JI7XsuoB; arc=fail smtp.client-ip=40.107.162.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JI7XsuoB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JI7XsuoB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=aUyN4sFLtcliU8/jcgDlfrgdH2W/QWh09QDpktIBdpPL92x3oQoJX3Q+uVlPiDHZ8Q4rsV4lvCN0CadBrbB5UWsVeGSaK1HzUBvQaJyybmq0zMVKaBVhZlrJlCzOF0HORzlgewbHJNzWq/bM1QwJibt+2F+wMTTIBwU3vzpNoCALE4K2HULQV9Q3CAj+NsZytRO5JCdEleDPjrBgh7jrD4Y6t0tMVwkm73peCdKHX6bKtZHCXiV49anWi/VxrmfAEQq5qL3EJ/b0dsy3mWx3OsdKXOl2EP/mjQVeCHeH1BJThQnACDH9vgdq7fMiQ1O/RdxvqEGiO57mnfHAGLFugw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmeVbUI1CitYH/t3WYTyvw2MkVdsiO+d2vH+22Cc7sI=;
 b=YcnnftW4dCzl7gMCXtbSfn1LreBCJP6ATFuwnYCQA0FqvWDauzc6DxBIXljkBFArMcdx2Y3IxyHCs+Wp5fDX86YZAb4zi/PjJGfZ0RsHrDBDmZz4ycGQo1r6kf2QMpOXbH/piLQNa3FJ/rnVWE4OUKAvSA78poSgJ2jokqbYz9JEMYyJl1bWa0Uyh6blmDYMXE7Fubb3Ohyl7RyXlQLozkatFedK+MF6+EXptphCbl4H5KvJf1C1McAFm5ozuBDn2s9zc5d5A7N6RR3kciY2fwVhItvctBmt1R7qFD/o6l8iosAf7PCNqBqkvkoVzmp+l1WSE8slxvQnO1K59n7gcw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmeVbUI1CitYH/t3WYTyvw2MkVdsiO+d2vH+22Cc7sI=;
 b=JI7XsuoBGjYeqYqtSm2nb2fTCnI+yKsi3UKDnWafqKgNys0MtTjOdx/X6JTuhtllvLSV4cz2HV5/eAjBTN3Nl39iYGbwdyhWaysMkasEmJHy604N4klgfadG+gQ7dJmjC7ih5ox2S8lWohdmygwkWkJQ7ydF3qU78k1tHS8qpkQ=
Received: from DUZPR01CA0020.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::16) by PA6PR08MB10623.eurprd08.prod.outlook.com
 (2603:10a6:102:3d1::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 15:00:11 +0000
Received: from DU6PEPF0000B61B.eurprd02.prod.outlook.com
 (2603:10a6:10:46b:cafe::80) by DUZPR01CA0020.outlook.office365.com
 (2603:10a6:10:46b::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:00:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61B.mail.protection.outlook.com (10.167.8.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:00:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzIisCVVWNRCPLdUkD/dp8UvGTCZBxoyJqQAK7mRdXfBQqgmVJrgFmBwjdZZson67xgR8fLblVYyAvx8QeLeEE7BQBNkmiLMn7cqSOyBs7x7NeCdnFqJtXVzq8CGmwTluc3IAWNj1KiGoZj94IwiNDOU4OqJEZM2kPB/aK583EFwh7wnfulXcntDKqnDvjNp3ytvD43KU03pxoz4OBQv4h4fL00mA+TFZvYZm0q/KhTOT7BodE6UheRTrHS7ElUjgkWMCrBbDD1YQqMQmF27RCn1khmxMRwLrLNhBEn6wLEKT+oMlJHqt0Xorq6Q1jaS7Qqf2qlY7nYqo6uO3vpOsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmeVbUI1CitYH/t3WYTyvw2MkVdsiO+d2vH+22Cc7sI=;
 b=Vjsdn+w8GOJEQk7aSLykf9lCv6u90g1TdSlQ5NuJEvwvp5oQqbsyA6edjdAx5+Svdb22b2qBr7eL60OCjdwiNftFRyeHr52eiDGv/VBF1hxt8PfLwiTLOpBNPCU+9wFYgaA4XUhQOVo829nvvNF4LQIcFG4bYHqB4G/Daoz8ktEJdzLEgR03jJb1b6hGY2iyVdR1nsb3fcmwfO3Kxizfq7emRrqpmq0xoExFcgML9Dr5y7nESnIuWRR+b+9P4tE0PHpFSpeDDx8qwmmIn/lvFmueFRJV+U+qajj+6nKDB8mJdmbYRfoy6DHmBaMSS4fotWn22AAmx4hiUKWCevvStg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmeVbUI1CitYH/t3WYTyvw2MkVdsiO+d2vH+22Cc7sI=;
 b=JI7XsuoBGjYeqYqtSm2nb2fTCnI+yKsi3UKDnWafqKgNys0MtTjOdx/X6JTuhtllvLSV4cz2HV5/eAjBTN3Nl39iYGbwdyhWaysMkasEmJHy604N4klgfadG+gQ7dJmjC7ih5ox2S8lWohdmygwkWkJQ7ydF3qU78k1tHS8qpkQ=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:59:07 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:59:07 +0000
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
Subject: [PATCH v2 29/39] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH v2 29/39] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHc6TJfvij4giVEkU64zIpTOnoa3A==
Date: Thu, 21 May 2026 14:59:07 +0000
Message-ID: <20260521144846.1899475-30-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|DU6PEPF0000B61B:EE_|PA6PR08MB10623:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c1580f1-8a7a-471f-24e0-08deb749a828
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 tlAA8zkrHPVV1ydiGyzE50iuyQtWG0Q1WO3uuq5U/NaMao4g9MTHGzk5L+If/fePoYfVBW5GrBdx3AZ2YuhUSvtBHE8DJpim3gWFVR2YIYb9mUz+K8XTOdPIvwNh0DDUXDwPXo2zXwX7CiBrpNPt0vo42LOPpB28l9PplIjmWcFlQ8qxh/sODRRc/KoGdzRk5Ps8xyeuTazUzMJejfqKWNTHRldI9P90YTNP1DhPl2VYnTb0kWDpv5w/RsdIs4HVgleIUmH3aBBMoCBevKxf0a0ucSYqtSMbmNWVKUlQ3kii/8KgQgGfHtEOHpqWeCaQrRhrMVEwh5O3Vd4UmdO5fj7YblT3ni+5Puwui8xDU2ClxGm17kXwTtCwmJXC0Gnz/eHrnjbwjt4KdwTZRcpem5IDGEj6Dof+1GdApJjYXueDkVKbA2nkgxkkDziNV26EiqGWYylxjl7qDe88MF8vA9YQ9QeWAnlnzmUbp40YvrpCCMEaoFehU3C0Mc2czBgenz/wOi+NJHk5EpFTJSiBQMoFGnUuCJ12fZr2od7Qb2pmcm/K1xTBtPNhLMkTrzDEl25c1iZB4T/Ad1sVP8wIPfvyeg+IIaDHeKiGDFCpmqeRQISYXfAcSpxUw8f7MSJL5tZ68ttvcR/GcrkWx6QC9YKHCO1fTjIdE/n/WxFIDr7UEQIseasEWzi5IIdmuNRE2JSB5jlVMQAY+oVFXZt4enK7HcPLlItPI6/9Tbi2+R9cFuGq4d+7zAWH1jdmXydT
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(5023799004)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 H4DM27r5zfTvkeVI6xE1EhAa+LcZlIAFwfMb8tyQpbIu2a3Sjnu3a3s8EZ6HhZOrtwHrY+oJSSfpeQdQOj5PAeJQAfUMILzl1LulChju9ODIMg4PyISkezWr++OEhUqCbZbGaM2Pcah3iytY10WKwQS0e9CY9n7rV5+wgGpGhhjBsKrz5m8xP0G1DqdJ1/DTGBUl4NmdI+n7NQxUQwl3/NeIVlSlJ/Jv0ISw3/QMJPXukFL1pQQbJjOuUXAfhHk1wbpEZzg2EFwE9KFB9A1cNKmgrK/2CtWLrBw/tATfWGoy+UGwVOI237W1fVMLYBjnB7VBc7XPd/tE3S9ptf6pLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4f36d82a-edc6-44fa-4f88-08deb749820c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|35042699022|14060799003|1800799024|5023799004|56012099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	hLa1BoeUjyARmOszgzFqNJhsiDVUztBK1JPdSp7N8zPZKzPOXlBbl2KbXfIkfeFoSlNXfWzx0ztPvq7S8ILJw/OvMkO4RYnLoPYJ+ScuGBBmvAe4sRU2VnS77qo+m93ZkrrvLLeK1nDXVr6A66Q/168lU+bVd4HxlEkBSGm3a11UGZV3SNZrP9xIbLGpOptLanzmBRw70x7E6bvq831xK8FWu8eANmmWWJ2imYenXfXXbqr59nuGMuXPHsgDYDITUVKA3IE6bQe14h30liVcSRuCy4lZkhfzhzbdx6+wqSjyNsZjgplblWzss4n51z62qyCDVZYg06bNiNB/Oja9j32kW+DiCXJGI08z3vQ1aDe9EMM2wQALElvEdyznhXptAC5kjoOLO5iLjp+Vnweb1X5Bf5+3c9+Gkh5ewbS1RX6lpevCfYom6OeYE2IFINjlhLwuZtBZ8mmc0MUu9LAKfj6BN8vp+Zyk/O/uefBu06lvXChtLYl7Gvg093cg/wWoOiNtrlp6JTedK4B8ixlykXk1EV1BQpQKlLhmJK7m7W24e8p2KYK4JNI7ajpSiW9b8PU27ZoS2GtDWwkdz8JdXv65R/AevMTJvIxUo82PBbDIQIiXSKjBZIvVmy8HDAL5n0BQEhtrF9g9BIw5Kh2QFzd8iA3WiLVi6oJ0aiCX/M0PuadWoIhM0wL6P2ezwte+n0NIFZ/RSOFKKBrvN83rnu7Gthe2BjqBNpegk2LCXAg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(5023799004)(56012099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XuHHaXvEwC783Iq+jMkyYImvmD6Ajhr0i7QY+QxW5XpytvYoe35erGKv1akvhAafDEazrN+zw288Hj+3VTtBfVcKmvG4j5I6dDct5tqU6lVW/OvEimfzZ4xVh3kXxasfRv1HSkI2C/wL3BPIOT0Uv2QxGpX1lLA6ZhKjDzYgm9TZ4Te34nuOP+sr0rXVxBM9AZRCzZ+q6FkyQsfH/HDVbx7VwmGRGOBxD6Iuj9u6XTR2XPkyvhzKqAIT8d4obmqaE/zWiOHzwCNyRVLe2oIcVsDj92+0eNPpukQP/8/9dmfpwMeYLsrUJDsQ+lnnQw3UFu70e1C7JOSpTuFD4Y54sFHi8TNVcl+McLVVACxs2einJXKykDP8W3MmZ+TND9/pFUG0n7Wy8+jHA/77oCi9H8H6eCeS9uia9YXL5yrexMnOE8KdQm0dUUPs3IW+ueoJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:00:11.3801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1580f1-8a7a-471f-24e0-08deb749a828
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10623

GICv5 SPI lifecycle is handled by the GICv5 hardware once the pending
state has been injected.

This change adds support for injecting and managing SPIs to the core
VGIC code and GICv5 code. First of all, allow GICv5 SPIs to be looked
up by ID via vgic_get_irq(). Previously, only PPIs were supported.

Two irq_ops are used to inject the SPI pending state into the
hardware, and to append the SPI to the VM's global SPI AP list.  The
set_pending_state() irq_op is used to inject the SPI's pending state
into the guest. The queue_irq_unlock irq_op is used to append the SPI
to the SPI AP list - they are not added to a per-VCPU AP list as they
are global to the VM. Also, this would require KVM to track the
affinity of individual interrupts, which would negate much of the
benefit of their lifecycle's being hardware managed.

While the SPIs are on the global AP list, their state is checked on
every vcpu exit, and once they've been consumed they are removed from
the AP list again.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  1 +
 arch/arm64/kvm/vgic/vgic-v5.c     | 93 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        | 28 +++++++---
 arch/arm64/kvm/vgic/vgic.h        |  2 +
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 6739c01277866..6352d17d557e0 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -675,6 +675,7 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 			 * view it is always enabled.
 			 */
 			irq->enabled =3D 1;
+			vgic_v5_set_spi_ops(irq);
 		}
=20
 		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 5684b65fa9389..6e2191620e8d7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1098,6 +1098,99 @@ void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
 	raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
 }
=20
+static bool vgic_v5_set_spi_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	vgic_v5_set_irq_pend(irq->target_vcpu, irq);
+	return true;
+}
+
+/*
+ * Put the SPI on the SPI AP list. No need to kick the VCPU. If it is runn=
ing,
+ * the interrupt will signal at some point, and if not, then a VPE doorbel=
l will
+ * fire (based on the IAFFID the guest has configured).
+ */
+static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+					 struct vgic_irq *irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct vgic_dist *vgic_dist =3D &kvm->arch.vgic;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON(!__irq_is_spi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid))) {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		return false;
+	}
+
+retry:
+	/*
+	 * We're already on the AP list or don't need to be on
+	 * one; nothing more to do.
+	 */
+	if (irq->vcpu) {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		return true;
+	}
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* someone can do stuff here, which we re-check below */
+	raw_spin_lock_irqsave(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+	raw_spin_lock(&irq->irq_lock);
+
+	/*
+	 * We've lost the race; and have already been queued. Unlock
+	 * global AP list, relock IRQ, and retry.
+	 */
+	if (unlikely(irq->vcpu)) {
+		raw_spin_unlock(&irq->irq_lock);
+		raw_spin_unlock_irqrestore(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		goto retry;
+	}
+
+	list_add_tail(&irq->ap_list, &vgic_dist->vgic_v5_spi_ap_list_head);
+
+	/*
+	 * Use the VCPU we've been given as the target VCPU to track
+	 * that we're on an AP list. We're not queued on that VCPU's AP
+	 * list, but in lieu of an AP flag, this will do.
+	 */
+	irq->vcpu =3D irq->target_vcpu;
+
+	raw_spin_unlock(&irq->irq_lock);
+	raw_spin_unlock_irqrestore(&vgic_dist->vgic_v5_spi_ap_list_lock, flags);
+
+	return true;
+}
+
+static const struct irq_ops vgic_v5_spi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_set_spi_pending_state,
+	.queue_irq_unlock =3D vgic_v5_spi_queue_irq_unlock,
+};
+
+void vgic_v5_set_spi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq) || WARN_ON(irq->ops))
+		return;
+
+	irq->ops =3D &vgic_v5_spi_irq_ops;
+}
+
+/* Set the pending state for GICv5 SPIs and LPIs */
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	if (WARN_ON(__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		return;
+
+	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, irq_is_pending(irq),
+		     vcpu->kvm->arch.vgic.gicv5_vm.vm_id);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b35833a4e2bf9..8d5bfec4d26bc 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,19 +86,31 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u=
32 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
-	/* Non-private IRQs are not yet implemented for GICv5 */
-	if (vgic_is_v5(kvm))
-		return NULL;
+	enum kvm_device_type type =3D kvm->arch.vgic.vgic_model;
=20
 	/* SPIs */
-	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
-	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
-		intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRI=
VATE_IRQS);
-		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+	if (__irq_is_spi(type, intid)) {
+		switch (type) {
+		case KVM_DEV_TYPE_ARM_VGIC_V5:
+			intid =3D vgic_v5_get_hwirq_id(intid);
+
+			if (intid >=3D kvm->arch.vgic.nr_spis)
+				return NULL;
+
+			intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
+			return &kvm->arch.vgic.spis[intid];
+		default:
+			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+
+			if (intid < max_intid) {
+				intid =3D array_index_nospec(intid, max_intid);
+				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+			}
+		}
 	}
=20
 	/* LPIs */
-	if (irq_is_lpi(kvm, intid))
+	if (__irq_is_lpi(type, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7eef8ece52dde..b5036170430dd 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,8 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
--=20
2.34.1
