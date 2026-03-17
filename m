Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011000.outbound.protection.outlook.com [52.101.70.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB92D368278
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747796; cv=fail; b=R5C04ZYw5I27ErdaKTt8KwWN+JJVyG+iPl+DvIhsmHYfRa47DMH5U8eZFNrRUGa6gHxzvZ4QxkVPhOnC+RwfrwWoKsdbA6uGH4PkbSW4UfyWQp4VVFs4SKg1F3dhsnuDCyqPrz3SKlD8RctuTjzdHznivvdVvs/2jXfk++YnaL4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747796; c=relaxed/simple;
	bh=Bcs0sWsAvvLzBDIisSrta2WlQ1jegv0OPyJUuMrrBX4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UJaTkc0pC9RktBcp2agj83aEg90MaL5NWNg3FIcrX9pSwbBl+JJsOa9Mk3ZpMkKSf5IuUS2TZgjDd4nf6puRRE1apCGmEbV+oEq2V5N4EKc6Hk4ZzLdGebL/soqImDCWkdImzz+8E7GJBffzZRj4whVfJEja4lRVkChcRbr1RFU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bkGPQg3q; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bkGPQg3q; arc=fail smtp.client-ip=52.101.70.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bkGPQg3q";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bkGPQg3q"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gjsnwo0SBfOK6Ta9+mCatWKd/FGJHCN2zTp2hMBZveErTwzdBMNV30Qxk9q7MX2wrcU0OyojKfI4MhDxyviMJdH5u+3atmq99vOi5B76T3OX71rUwKnhLP+TfYrTRe9BelfYRhYS7iPfwVIn2CV0s4xacYXgrTdTr39L0narCNjxaTEo+7hSC3znkO8ErOY1kfvPmGgANzGQIx0YIgrYQrB8fKVYD6Rgyd2zNhzoyzZ4PUI66cl7GI0aCeo3fbw9MMuVULqfCnsbWPUebZm3pZk/uCiD/XcgLzBecR/6FdGv/JK5/66DZ7y7wzIYB8Pn6A8x+CxFwMYKXSpTuPiRyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJnRvE/TMkcD2Xs7E0IrIJrY+M2jlD+RC07UQw7OkZM=;
 b=SZK9iU5bB1nnKDAJjsgS0aP1r+dgYT/N9d4nCenI1j6QtM4PhkNlmGK/pB3h/g1HeHReqwABa7oMSHUiFmymBQEXNHkmy3WznIJHIhTLOMcCoSS3gg5P6B2zyvJ5LMqkUnvSw3YyOL/6QrJZPl3EQvCU6Dogq/xh/XQkVJPv32qgJ4/C6HS2JnKUje6M01zAkNVPVd9GMdni5+p6q59KrPMwFAw+3JIZ6tP9oNyBcOygr30Q/dAuTP4GqgLZhS/uu/uasXPOoqxbIh4rWjJSS0bXWTHthZoPg6qnbJSsebxisv5gmelmNfC+zNRvHfNookUqD88UEG7v3ge88xySFA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJnRvE/TMkcD2Xs7E0IrIJrY+M2jlD+RC07UQw7OkZM=;
 b=bkGPQg3qmZyu6JBEZ+NNLmNnNoiQZYFlGRdLGBz2+2JAmLqFnABF4TSpwOOY9AM8t4jNK9rQQVXR9hCxoIzS4G3KaAAANPb02064byNuV/R/qJ3IYUbJW05mYi2328u8cr1yabRiX3T/dflmcbOO4nD4cgwh32WUmz1VYiHRcyQ=
Received: from DUZPR01CA0024.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::11) by AM8PR08MB6417.eurprd08.prod.outlook.com
 (2603:10a6:20b:362::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 11:43:07 +0000
Received: from DU6PEPF00009527.eurprd02.prod.outlook.com
 (2603:10a6:10:46b:cafe::b1) by DUZPR01CA0024.outlook.office365.com
 (2603:10a6:10:46b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:43:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009527.mail.protection.outlook.com (10.167.8.8) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17 via
 Frontend Transport; Tue, 17 Mar 2026 11:43:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVBSKAeej/Te1bR32ea+zMl/xrdkDSJnEeOg+ILZYMdlTOycGvnioHeG6LchescRUHX5Ay5rUz1tS/OyMiDAh4ndFomRQlal3MGq7xYB1UDMNuDXWnBUEvPVHOF4Vf94g0BXx1nJs2FXxWN5wNrhvuM+Ce5mEuuZtZLuHPxoTtkijziBnUoNMbdqVjJ+xRQBeVgTRzy2LvPkFQ1JdKYYjd4x/UUlZOCSkMIAxY6SlYYWw6Y3LTy38mq04QtLtsZQu1ylqdpemYOtifMWsIwwfgvBEU46fa9robfiFvK6uj50sDyZHAUK5qwNiGDO5fzTYiac4GCx+8O3mE7qfqx+uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJnRvE/TMkcD2Xs7E0IrIJrY+M2jlD+RC07UQw7OkZM=;
 b=Ve4ui7vGyFSGEOJIvwU7wsSzT6ZklmsYxZmYMzgRheEtQeaSQxq663M1CDhTyP9phYRzaH5OZwRILtLIZam8HnWuieh12lzOOjoRe2klDx2GpmB+NoUj4BV46HSK36AwvN0u6uuSMls8G3kGXFKEp8fhXJqhNRi0nPWPBLC1gIogbzokZuzT8FttBiFsNbIvmTeFjYx1lCThYLp/kVfDqvCwSvWVeijNSbA/J6iDetPdVKdULUH0TuopE095UYsO1rgGlIMGcwkbj77KndxsjCBtLxQRYER4q/PT8K/RIa+lU5hVcsigfx/p/BnL2phkcKKPgE77GA8lVG6vVP7SsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJnRvE/TMkcD2Xs7E0IrIJrY+M2jlD+RC07UQw7OkZM=;
 b=bkGPQg3qmZyu6JBEZ+NNLmNnNoiQZYFlGRdLGBz2+2JAmLqFnABF4TSpwOOY9AM8t4jNK9rQQVXR9hCxoIzS4G3KaAAANPb02064byNuV/R/qJ3IYUbJW05mYi2328u8cr1yabRiX3T/dflmcbOO4nD4cgwh32WUmz1VYiHRcyQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:42:01 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:42:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 08/39] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH v6 08/39] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHctgMRWMURYn+mZE2KixjzXZrf1g==
Date: Tue, 17 Mar 2026 11:42:01 +0000
Message-ID: <20260317113949.2548118-9-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|DU6PEPF00009527:EE_|AM8PR08MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e7c994-cc2b-4d86-c587-08de841a5b5b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 McL3vsooAIfEronF+Q91g6S3lOrbBg7u/GBPOo3TEKO+ywn25L8mw208L4e0GjNf95empyvUHKUSKA8kUJEC/O5HRwKogMtuQUF1ziDbgMQR46CowmEe/ihLuu0pYBsCya+XxVf1ZyB63YCH5c3vN6rdk3pqG16pGp2aWR4lCpCIj5V4dvFRLkPessko/ihyVwqtLnp3/BwE/F1jJMzPuzwPAwsOpQG6XfYv3v4c5jvs3lhsMjtIhjmfXcILoy340GJrMR/CW3aysq9C1sdVvxy81kPxvvZH9NkLsWh45Ii7Z5eg58jQVXDxONWnpvcK9BZjUZ4WJjwDBIhwxx3Oh+iSH/3MuYYnYcK43BzY7bUVc+F203B5GOvPdc3y8FuiR9gh9Q7GoffCrbAyoYU6LTHVME11su5+3uw6OCWYnb+uONs3+Gxe0zRrfgqv2ONs4jAi8kwWBWujzHZbqxAaJykxqr8tNijAEL092wVS9Wq9xlkmTlrc/2FTXVIqZ0A4T/vPYmdaEbjXJi9DRhZ6uXqBmqKRfyGDtHtrfvztTPUJe4H2jrEgYquRgrIJcbLifNZ0GUbQjbVNNsCcskIPRvI8BM3gFsHcWIeppMOO/mDqRcraKRoKDfTbmeqdK88XgLESc+5P+VMRR0SLViu98VsAPS/GDQcqzjZIME+msiMCXLehcef1TDq4gmH7q8+OpmXHA4IMnmgrM+g1UfsoWhBwF1UnQ3ATsrEF56LiYA8LHkUcgC2lWp7fej9nSP8ZdMIhG2S7w40QCaM+/uJnoCz2EqfoHo/OdkKaWGCpRY4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gVsgGGwSS187R8cZPc++SIMgXGwyA1sYB/Y4nVwLFJJx/E2FdRbpZR1y3OddFBR+MrPFxiet4yhXHe3OX5gsOrCXNGri701s4dPQb07MLcLO7Y1x3Jka7z2DBU1vV8X3vHAinsw3O0AUeki/64DXMvwEW0bsZWN707IxwDrYIKYEcbOjLGv1xi1/OObw0EtteyUSTujKwZnSdjmsHaXF1pHDhs/VB9eywobQA4LWDVu6jUWVKf0ibFg0rkm2I2PdpHXJU2BWeUcUEBg9ajec5CecJNQw7yGSFb30wStd3dt/sdMKJoR14fvnKPnXm03iaWBcAy7ay1LsUPpyisM2sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3b7a8331-5b4c-4ac4-24d0-08de841a344d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|376014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u7LTDiiubeDwoy8ETSXWJ4uWfby1+9DCOa4SO5r0OHaqF1/UXMS+AdBghIW2P/1G7jCAcvj06xC+59SVPnu0+6+x0hU2AZT0LjCqOMe0x6FTXdbCvSfjdjxUteLdEDlYrdM9C+D+fNHkSyGDnPZEeP34ua45u0A+abBVjEAtoe2j7vYxHrQkgn0lZtFIhTMkI9nD6SmblvbzZV7DRqbpEm1fiHudr4czQ08NSSA/FfvdhcQCx1N1M+AgRZ7D7UhI23DhdOonXuX+W2fFss1Rlb3I6l2SGoydpe3KTEZH0KV6sRjzxE8gZD7jYjbdNdIE3WJnPLmf6X4JI4DloVX0J/fOq/WYLko3rFcM4G2npCQoneWoDgAsNfwTXI1RJ6i07PWFfI63Yk4NPkkFf/mLjFQ1qBmyJNh8xFWRrvcbfAizJ3H/6bgKGJbZwhQfKQAn5e2AwvqQoQrCC1AjrZRYgKNO+d1Va0B7P/gGwQeDQfrcl7QyckerCwdVynzAK8KsLQoIEyoOCSYdd01+N9zZMzGRnRKbdsb/jlE9WucSW2I12DOc6SjOt3tZbnVzus2HM/0yG8m6VuyWIDIn/ejDNtOXESLDt9YUtF1ii0IrzdijzfVjC2g77vCQje51hjPlJ7IPU9bfrtiCahajnqJriWsOWItmilCEjNXmujJAkVcsveqB0qpgyUTdBRoKlD8YVhYjM3U+PVaSR8Hr/hf5E7s+mJM6SsHkLkp/QHCymJRX3Q/AmHxNPREPXQdSsCL9sZ1YXbgy+v5NGMmnXN2TQg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(376014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kGT3yMvBVRtS5AD32fn7O22tih2dzeJBsBIZJSc3ZlWGVVx+r0VfIXm0zEFyCDzW+xZPiDWSQB0Y0hU/uin+FFOippua9dtvMda4vaVI3z0S+BeNvzazGwLZGWaNEajZ+ZB9At0+jAdfXBiRdVGDtr1iN0PAY1zjNBd2BxeZn05Rra8PdhRFOzeZk2HvRgc2aKnZbXjaBc8fIw791+FlypNFMhc7f/qamfgAIN+7BDWFgsnjXpmOK0M8CVmDUTajTTc2sBOdI5a2UVMMUkjVJejWUOuUEckmOUUL84f4f7Mzy8dm23LL+0/gOfXibTDbM9AZM+kpDfLsT6uCRPCpO6yjZghOqGS4qgG2SRWe5Olm5+O/0CY7ppNf1JcNOzrHbgMRtWG8jdSdu7326uIJpn1OuOMitvYDhQleXraGvCoASr0WgVca5SU7Z6NRdKLt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:43:06.8754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e7c994-cc2b-4d86-c587-08de841a5b5b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6417

GICv5 has moved from using interrupt ranges for different interrupt
types to using some of the upper bits of the interrupt ID to denote
the interrupt type. This is not compatible with older GICs (which rely
on ranges of interrupts to determine the type), and hence a set of
helpers is introduced. These helpers take a struct kvm*, and use the
vgic model to determine how to interpret the interrupt ID.

Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
helper is introduced to determine if an interrupt is private - SGIs
and PPIs for older GICs, and PPIs only for GICv5.

Additionally, vgic_is_v5() is introduced (which unsurpisingly returns
true when running a GICv5 guest), and the existing vgic_is_v3() check
is moved from vgic.h to arm_vgic.h (to live alongside the vgic_is_v5()
one), and has been converted into a macro.

The helpers are plumbed into the core vgic code, as well as the Arch
Timer and PMU code.

There should be no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c           |   2 +-
 arch/arm64/kvm/pmu-emul.c             |   7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |   2 +-
 arch/arm64/kvm/vgic/vgic.c            |  14 ++--
 arch/arm64/kvm/vgic/vgic.h            |   5 --
 include/kvm/arm_vgic.h                | 102 ++++++++++++++++++++++++--
 6 files changed, 110 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 1f536dd5978d4..53312b88c342d 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1609,7 +1609,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	if (get_user(irq, uaddr))
 		return -EFAULT;
=20
-	if (!(irq_is_ppi(irq)))
+	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
 	mutex_lock(&vcpu->kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 93cc9bbb5cecd..41a3c5dc2bcac 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,7 +939,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		 * number against the dimensions of the vgic and make sure
 		 * it's valid.
 		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+		if (!irq_is_ppi(vcpu->kvm, irq) &&
+		    !vgic_valid_spi(vcpu->kvm, irq))
 			return -EINVAL;
 	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
 		   return -EINVAL;
@@ -991,7 +992,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
=20
-		if (irq_is_ppi(irq)) {
+		if (irq_is_ppi(vcpu->kvm, irq)) {
 			if (vcpu->arch.pmu.irq_num !=3D irq)
 				return false;
 		} else {
@@ -1142,7 +1143,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 			return -EFAULT;
=20
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
 			return -EINVAL;
=20
 		if (!pmu_irq_is_valid(kvm, irq))
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 3d1a776b716d7..b12ba99a423e5 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		if (vgic_initialized(dev->kvm))
 			return -EBUSY;
=20
-		if (!irq_is_ppi(val))
+		if (!irq_is_ppi(dev->kvm, val))
 			return -EINVAL;
=20
 		dev->kvm->arch.vgic.mi_intid =3D val;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e37c640d74bcf..d95fbf20002f4 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	}
=20
 	/* LPIs */
-	if (intid >=3D VGIC_MIN_LPI)
+	if (irq_is_lpi(kvm, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
@@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *d=
ist, struct vgic_irq *irq
=20
 static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *=
irq)
 {
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return false;
=20
 	return refcount_dec_and_test(&irq->refcount);
@@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq=
)
 	 * Acquire/release it early on lockdep kernels to make locking issues
 	 * in rare release paths a bit more obvious.
 	 */
-	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >=3D VGIC_MIN_LPI) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
=20
@@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
=20
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		if (irq->intid >=3D VGIC_MIN_LPI) {
+		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
 			list_del(&irq->ap_list);
 			irq->vcpu =3D NULL;
@@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	if (ret)
 		return ret;
=20
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
=20
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
=20
-	if (intid < VGIC_NR_PRIVATE_IRQS)
+	if (irq_is_private(kvm, intid))
 		irq =3D vgic_get_vcpu_irq(vcpu, intid);
 	else
 		irq =3D vgic_get_irq(kvm, intid);
@@ -711,7 +711,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned =
int intid, void *owner)
 		return -EAGAIN;
=20
 	/* SGIs and LPIs cannot be wired up to any device */
-	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
=20
 	irq =3D vgic_get_vcpu_irq(vcpu, intid);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0bb8fa10bb4ef..f2924f8211974 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -454,11 +454,6 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
-static inline bool vgic_is_v3(struct kvm *kvm)
-{
-	return kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3;
-}
-
 static inline bool vgic_host_has_gicv3(void)
 {
 	/*
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 46262d1433bca..b8011b395796d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
=20
 #include <linux/irqchip/arm-gic-v4.h>
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
@@ -31,9 +32,88 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
-#define irq_is_ppi(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVAT=
E_IRQS)
-#define irq_is_spi(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
-			 (irq) <=3D VGIC_MAX_SPI)
+#define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
+
+#define __irq_is_sgi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D false;					\
+			break;						\
+		default:						\
+			__ret  =3D (i) < VGIC_NR_SGIS;			\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_ppi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_PPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D VGIC_NR_SGIS;			\
+			__ret &=3D (i) < VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_spi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_SPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) <=3D VGIC_MAX_SPI;			\
+			__ret &=3D (i) >=3D VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_lpi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_LPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D 8192;				\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define irq_is_sgi(k, i) __irq_is_sgi((k)->arch.vgic.vgic_model, i)
+#define irq_is_ppi(k, i) __irq_is_ppi((k)->arch.vgic.vgic_model, i)
+#define irq_is_spi(k, i) __irq_is_spi((k)->arch.vgic.vgic_model, i)
+#define irq_is_lpi(k, i) __irq_is_lpi((k)->arch.vgic.vgic_model, i)
+
+#define irq_is_private(k, i) (irq_is_ppi(k, i) || irq_is_sgi(k, i))
+
+#define vgic_v5_get_hwirq_id(x) FIELD_GET(GICV5_HWIRQ_ID, (x))
+#define vgic_v5_set_hwirq_id(x) FIELD_PREP(GICV5_HWIRQ_ID, (x))
+
+#define __vgic_v5_set_type(t) (FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TY=
PE_##t))
+#define vgic_v5_make_ppi(x) (__vgic_v5_set_type(PPI) | vgic_v5_set_hwirq_i=
d(x))
+#define vgic_v5_make_spi(x) (__vgic_v5_set_type(SPI) | vgic_v5_set_hwirq_i=
d(x))
+#define vgic_v5_make_lpi(x) (__vgic_v5_set_type(LPI) | vgic_v5_set_hwirq_i=
d(x))
+
+#define __vgic_is_v(k, v) ((k)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_A=
RM_VGIC_V##v)
+#define vgic_is_v3(k) (__vgic_is_v(k, 3))
+#define vgic_is_v5(k) (__vgic_is_v(k, 5))
=20
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -417,8 +497,20 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
=20
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
-			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+#define vgic_valid_spi(k, i)						\
+	({								\
+		bool __ret =3D irq_is_spi(k, i);				\
+									\
+		switch ((k)->arch.vgic.vgic_model) {			\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret &=3D FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis; \
+			break;						\
+		default:						\
+			__ret &=3D (i) < ((k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS); \
+		}							\
+									\
+		__ret;							\
+	})
=20
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
--=20
2.34.1
