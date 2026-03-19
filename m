Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012008.outbound.protection.outlook.com [52.101.66.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0363E3C42
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935669; cv=fail; b=RK3NpIm3UQBRy0jgtwEDuSrXk/voi9LcytmvY7ylrdDnEY2J/kG2Tleg3ZwQn2YO2mkDWWP2yOG133XATkhTrvIbdOojJlZxyYCHlQedv4b/LapRXDkXs5Z2hnHThmkKgGeyFTGNX/2LDTohdXW4Af3oAdrKUMI9enOSHa/SlLs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935669; c=relaxed/simple;
	bh=tuqiSubjHx1Me9VOEJ8I9ktCQ50N9fmTR/QIH9pZYVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zs9E1BuzX0uUQ78HnDm4J4DFc+K7pxbgYO+hHuRDGIC92Uxfe4RVxKUA/cUp3bN2LFkNvejGfGc8LOdyO6jmw+jShjxpxcTD4j0nQkVVNKUjYEqpXbkLLzCSh67L5ulNXHOLcvy36ZBckIhlYLk7XvVgNPbmNR2dW9Sqm96IfI4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RatG6qLG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RatG6qLG; arc=fail smtp.client-ip=52.101.66.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RatG6qLG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RatG6qLG"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xVypL2cnGFiF3hJwCN+WTUZ/t1ykj36pLgOtdT0iBLTvt7i3EnXcKuBq2tYqlDs/dUoHjPgtVeWNl9erUySBc5AwxA69iCagIT2PY6olsPZ+mcZqEc7uSy6SNVJS3l7E3efjpJmMo/bMKThzJi3tpvDrGtpKjvgUDtJBRiNETg+PLD5/lj3RpExzQJxGQinj/oOdpUxqFmKVbkJIbO7cywy3Q3mCW/b/BjL+n3shkL9XcTa3NbyRjonlv1ZG+Z16/LpKkXnkPLg5DDqLfS/00xJgr2q/3QH2KRpKmqGBLwEUoWfqYL/ddNqImnn9iN0k7yQTl392glsRfyiquuAdCg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRlBBi+LGt7R9N+qowrSvCTMADafs/Thje+w0sbru5I=;
 b=MGIH6ND/2KaVJwD86VoeQzwSkKwZmYFaUFS+es8ZQH/pBALWD8p4cIHRBiwKMtGOlHSB9wyoa4Ft6cZ5wNkJpPeVWajIu8fZLseVFRoCnN970Dbvjx1sSoppn8CTzxeT75K4oF4jDc/xDmHiBtlD1vp4nT4PPkNLv+b1v0BQr75zCXRJrbNr5AWF/jBRLtTsHQGxAWaS8BxHl4VhZ6J+lMkx1D9rkfFVXJEvbyjWk5Jg/W8yAI3A3DYJq4sqB0LfaII+zzCsiIwbz/KpsPpL3Er7na2HEbq4HYklrLhyW2j3X4cKDuCaJncfOdmv6sthSyMA0shVmSHcH+UmA97FPg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRlBBi+LGt7R9N+qowrSvCTMADafs/Thje+w0sbru5I=;
 b=RatG6qLGVAeFQ2m2eNgxfAP90JcXruauljuoCeggQC8cHccaWnJv79ZTQ7LsTNAc6t774G8Yr4CBnEOYdExGaAEYIjyz3GUKnJRIzfatOEnSGVRWug1mWBgldXhrnalC8IOvwVDwPdDC59m/FiHuyJR6X9L2ILWjYzVR+K4HXNw=
Received: from DB9PR02CA0011.eurprd02.prod.outlook.com (2603:10a6:10:1d9::16)
 by AS8PR08MB8491.eurprd08.prod.outlook.com (2603:10a6:20b:566::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:54:24 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:1d9:cafe::9e) by DB9PR02CA0011.outlook.office365.com
 (2603:10a6:10:1d9::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:54:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:54:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FjXI7d9f8tfvWuSRBN+hxCKMdGVLwsDSlts3Ar7hs5SeePd6I0XaX+mHj9zDJVOoQrh/tY0wj+jYlPL41bgREfKUdZ0BfXdsUc7TGXaq0UN+BxCmw/8Mjx2uUHzyy6zNnwASjJstXkb/8BKejPsf2o/XXoIfvu7L2v256ADw2XEqDR3DVQjy+GKM/meeiZWvgrLYeqA+X7T/j9zqVAWDN0yuL4HYmCIMD2dkvCTMjjLE2rDlujOSLx9kr22+uwWjcfjx0v4S4hCQY68lFj1pKURIeikDHzNMjpphPlHWwsMTIILF/LakO1Ts1odNPiGCXEu+YhP5Owg/QyJL4nYREg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRlBBi+LGt7R9N+qowrSvCTMADafs/Thje+w0sbru5I=;
 b=s6AMPHUqK5RdSTiZQDsf59qt58A+QHuz6NSIWtQ3Dc7IY6q2FLArzuqFNxSdV+JcRpXpgdv3t250/9fDkl9vsMiZiqrwZKoEkG9ZopEwp2Dy9avLRuceH5+J5cdOeelXlTJZp0qLYn2v7S/LehR6ktnrAk0JCqyP8nSkXlggBTU6qrAjBy2tlanVN4FF2WT2YxurFyXZ1hAQVDuB4TN49HDnKXM4Ii/8TkChWLf8dGHx0aEhmHwy4z5krpUKiCA1oyaya+k21nXTVOUvT1j9tOdAZ8/0eJgILiHZK+EyYBXNmnxzDdJ0diENk5coY7k/dM1UJfyUc7f8+nogNraNlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRlBBi+LGt7R9N+qowrSvCTMADafs/Thje+w0sbru5I=;
 b=RatG6qLGVAeFQ2m2eNgxfAP90JcXruauljuoCeggQC8cHccaWnJv79ZTQ7LsTNAc6t774G8Yr4CBnEOYdExGaAEYIjyz3GUKnJRIzfatOEnSGVRWug1mWBgldXhrnalC8IOvwVDwPdDC59m/FiHuyJR6X9L2ILWjYzVR+K4HXNw=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:53:21 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:53:21 +0000
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
Subject: [PATCH v7 14/41] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Topic: [PATCH v7 14/41] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Index: AQHct7iDdTX+OzjDsk+/ZEkmBKbw4Q==
Date: Thu, 19 Mar 2026 15:53:21 +0000
Message-ID: <20260319154937.3619520-15-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|DB5PEPF00014B94:EE_|AS8PR08MB8491:EE_
X-MS-Office365-Filtering-Correlation-Id: dafd0588-f419-464f-445c-08de85cfcae4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 uenXmBUrREurIwK9ZKLdkjF0NT/popii36ANQn42v5pdaHOt1oG0rKRONAoVU8RWIezn9MgfdF3UI1vgedZbZO6xCsy80/ajno3yDReN+G54+xgVh9DHqebZLZByDyMt5ptuKcFePph0O72hnqaNZTcIVsFM31fTNaOsATfpfjSB7KCeGaOqJy4kZnQGb0nTpMdWxljmq29+bkT3h3nuCBPJlb9/x7oxrxbUgYNgG/u9DKX/83snDGXovXLZfyF3nw9ePJ5QfYMcpteLu5cmsw1HPaxUYKGk0v7o3AoI40g7OJCUn5sL3m/stkWChQ24S4lQ15KQWUHn2n7bqsSvvSnI0o3SA/FvmCWPetjpUpqgeF6OAuNSIGEmc2iZJ7t7vAsiU2Ruhhdq5Onmggcd0GGc1VbBx035lOXORHh1gf6j4nzY7dMiwuhLRlq1ypHUWgWo0dYufl854+GKlI8xShFp7JkZGztf5P3uYzPnbPc2MzSTeoBbShZwocAp2vfEf31QeRQAASLZHbLopfkmrWS86wf9l3o8j1O7CAwb2IfK2Di8LOpRSEIxikiqwuiE7lhyUuu010ot3d3vWsP+L27DQG+V2biLFCHdmNjWu/hwxfGSuNG43f5ZDW/WNkp+pCsC7dNwp+jVhrDfQzxKmJ+YIKqGfxK2z2zpSCgtUmhs2xbUxqHrmHWg/ncPY1dbYSUmmYaxV3T22AKpzgWWLcpMU48od3zrn8hAbdHwvRq/9DOUK3RWVv0AY2EdGL0yDXUDH7VG4dEb2tj1d3vc7HqEZZUMxTsLYp1vw122Lvs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gPx4pKUzuKtpHWIiElFj8RJfdXRltS6g5tT3IXq7n+ADtBVbbkBfgWzqOw6/zs2DdhDCAP7C4nbRg1BykPjMgJv8a8I83qbWvzwxDxioTsdCkOY9b89R2a8GVFOOUrxzWm+bam7pHP/AVQDwtNVhOJzCTVfC0sv45OFQ/EIociVv9zVqfAfcWLdnp0eVR1+AWAomhCAUoob0S46BVpfXpqlug73IQedrabu4KNfhqPnQLitaFk1wCcQxbnAsQag1mOVIuxKrGIJI6Q/lLHx5uCvlxQ9b0OabkIzQNdHE4Lougp7G1y0UYpxhU330ZurQ9kifwiFFCnvA579bQDtYNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e1d62b9a-2a61-4414-3ba6-08de85cfa58d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|35042699022|376014|1800799024|82310400026|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Gv4wwqfepA0qc9WDH0Y05Q0Am8vnkKIkSNzwTQOIQwX9EIrFAfCHYYs4PmQUUgS2ckNYkAum8edAADVLAMGsktVYhZKhjEAS9iiMp3HJbtZJ2MNsEam66O1U7iRPDtYb253v+J6Itf+BWAC73eplNXtxaDU3Hnuh8Anm7yE3mjENWGE+smuIUmVAriLnr3MokkzV9mADdDJUfv38o2Jux4PtYqJVPrbC3QvVY3W1prrNk3pdIH4Z8MnM5Pkrianwwon3GC5FC9DQZ8ha83UxZzMkxIlMq+5bnBVz4YxVfizM+OiuUeyuU7kwlD3YFhfcV80hSnwuFlv9mL8JMV7HAzqE2gat1RgArgWGK57PeprEaT/GenGrMev340vHRcD6z7fheU45d0urFafWNu5T1EdL2h9sXJrolQTg0l9b3L8AAaiXF0w9smwfiQjmiQ6asP2+1AMIV07o8vYByiuAr4W5nO6iBel44Lm4+reJzPjk7U0ZtgdNQP6TAg+aDoGpqWAdnAeGP7HrJNjl9/kAe9uw3wfdWBPEETDnrc3/aSGwLyt70h74HEmRFpF99+KnR+Hl46qEcwdI0Sy9V18ZpEbetvlkxZU0xMJ1h54j3WaL209w3iobFmfHhDc5c8rQt0M+xuVHvLGjMI+Z9sQFxjrlgbAbc2HwfsoImKya20BGoRQ/EMXuEU3SV3tu3FTz5tzyq+RW4ZfXCV9S4HU1sUHQeZ+AEkB5uTUPdUQaw4M7XAnOzAoZ4AMHIu1vuHUVZIAVlxLFo6EPxzFsV7D9Mg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(35042699022)(376014)(1800799024)(82310400026)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ku/n0WUkWF7MD7JPYQf80Mfk17RPM6mOzoPdBiO8M/QJb9OmR4jS17Conx7XqebWP1L52FnNYKUFBdaiN4t4g3DhNVzmqnELURrVndiHAAsvx3nBxhI2GoL0OrxZsVhqlka59O0EwNGSfaaNg0akM/L7Yu2bM5qYCPPZeQTKdSEBds/e59OJcd1VZ9z37DlUv0eRIMchPXMpBWXNDgRZ9XEWEioZXZd+/jt31PVPvjzKaq/oAinmySZyMzHMG5/luEsDweGLjE0c9IwWGZxZMNXU5NkBUlhZ4LbN6ezfmEeVwpR1eLgoYo5/1GKQnN2p5hdxOBH7q2ljXdx1KNlelhCbgtoQ993O1tfMTaeYreW/tWBfVv8a3pvS3lgSKxarlEBKtOSX8j9DINz2r/eZOURAZh2LKPrsiu6ME7lrUyd2R7xuGXvr7Fjmz93NGiN8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:54:24.0893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dafd0588-f419-464f-445c-08de85cfcae4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8491

GICv5 doesn't provide an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
providing the IAFFID to the guest. A guest access to the
ICC_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
guest accessing the host's ICC_IAFFIDR_EL1.

The virtual IAFFID is provided to the guest when it reads
ICC_IAFFIDR_EL1 (which always traps back to the hypervisor). Writes are
rightly ignored. KVM treats the GICv5 VPEID, the virtual IAFFID, and
the vcpu_id as the same, and so the vcpu_id is returned.

The trapping for the ICC_IAFFIDR_EL1 is always enabled when in a guest
context.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/config.c    | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c  | 16 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h |  5 +++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e4ec1bda8dfcb..bac5f49fdbdef 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1684,6 +1684,14 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |=3D HDFGWTR_EL2_MDSCR_EL1;
 }
=20
+static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+
+	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1705,7 +1713,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	}
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_ich_hfgrtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cd6deaf473159..d4531457ea026 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,21 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
+				const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
+	 * is the same as the VCPU's ID.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IAFFIDR_EL1_IAFFID, vcpu->vcpu_id);
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3405,6 +3420,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2924f8211974..7b7eed69d7973 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -447,6 +447,11 @@ static inline bool kvm_has_gicv3(struct kvm *kvm)
 	return kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP);
 }
=20
+static inline bool kvm_has_gicv5(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, ID_AA64PFR2_EL1, GCIE, IMP);
+}
+
 void vgic_v3_flush_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
--=20
2.34.1
