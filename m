Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010002.outbound.protection.outlook.com [52.101.84.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D326341DDE0
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101534; cv=fail; b=afU1HIP5sOX0NXpZnGD6oDI7dTVAut6hzECIizkx7oBO9W2WjJp7k04HDPUmiD26jZ/zCxZwX7jl0pbNLokfVLE/H4nOmWBXLrY0evFSFm/Nj1d+iUXoQdUwr/ePnb1a6j4NeODrK+KoYwuAJavQs8waxD9zXgte0ZhHBTNRY4o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101534; c=relaxed/simple;
	bh=Fpjft+Di3fSGfnOD7OrDSVs7sEX8H0YRVtpXaz0pI8M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dwMDN6KIWZAW9eiQnYe6kvttMZRQjJi5+UUxXCs789dR0/mV8aAq6i0AjrD+9GW3d74bGJFhQeD3fnvyIhkMg0vwVvfztkvjf2Qe5/VPDTxTFt/Yu3T1kZz94n67hmQXt9FcqCPbxI6SO/sXqbo8bFAW7qxsqa29prVAnvUDdXE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dtIGydae; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dtIGydae; arc=fail smtp.client-ip=52.101.84.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dtIGydae";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dtIGydae"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PeIKrsgPiIkqJkDdItPBIypktDyGgE2ZUhFrWHH4k5wd3di7dBQTcBbxvhe3Epw/LcziTBsHldh96+WM7ROoae0hHNfufsOes9bvxH+EqSPSbdHkJwUa59rc1JZiN0cya/WTgPoE1C7i8u+d8gYsSrwbOEzL+WIDxoDOfdwV/raq7ddWMvgen7nKT1VbJpPEQ/xW/4SMD2mk92+8vdjptTM9hH/dpngM6q78/l3PbSur63lV4nExSORchQIh0abirrNVrjZGezd6wYQ2QoI6oNkvaZKTLZz45Gn43TV5TknKzZ2p/gkEv+Z8kItBxorE0/X/EmJh4QRzKF7SN3epIA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jgMZrr/RZ3cgoqMe1xE+oQWDmiDAFXK2OI6pdeayuA=;
 b=lp+n8q8SYWJH7gtwKp/KHwyLBgUaV588SNH9UHGjAvsyDoFQeyj2/jgavh67GoiwYMHUOOtD6qzTqW6ZODSlTYCeTazqq0dY9BZK87KIKzTVfGZt5TEfoCBgd83pAOWuQJrXOLvppjtwPcdXHdGD1rX1NXRIj7CiwSGIfTj/7oBf+ejpmAglBdug8YKs8Xsd3C5cpVGheUt3+GQ9uNAHPdq+ZRvMERyncbw23FQmBoj6vb1lVtglPzXbo5eiEjBD/uhh4DDdNEoLMIIkueFj/KkZX9ValgIs2b5kSQ5eZ4cBBJKUNA66gYDOX6IiDu+RhLblmOPLywvgoKOyx6Ri4g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jgMZrr/RZ3cgoqMe1xE+oQWDmiDAFXK2OI6pdeayuA=;
 b=dtIGydaen2fdq7optkAL0/SW+VI73MLagD9/69Rnb6wgNz4ViEsZ+1XvZIWenUVN62PQPm3WYAl1PV8cecppGTbS9aBiq/+29Ql6b/s+dokZ44+VK7084RyxL/tQcTmuwE379/cDAgHnVr0VezFAYh0iKuii13OKedIMB1rUOWg=
Received: from DUZPR01CA0113.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::6) by AS8PR08MB6280.eurprd08.prod.outlook.com
 (2603:10a6:20b:29b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:18:46 +0000
Received: from DB5PEPF00014B98.eurprd02.prod.outlook.com
 (2603:10a6:10:4bb:cafe::83) by DUZPR01CA0113.outlook.office365.com
 (2603:10a6:10:4bb::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:18:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B98.mail.protection.outlook.com (10.167.8.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:18:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OvWknu0EAX+dSH1CguckuQRpfhK1UoFY2YY9ETBkkVWAv+Pq4BOgsDrXtBhtUIK9Nvi7oWzO2lQGPM3Ay8yYJyfF5fyMPaOrTR+qlKDB7dR/qkplukBe7AVOvhO9fOb1Ll/2ml1p2j5/F1w5vYp3QiFRRnZruQJ9/yMzZNiRVwuil8WG0+T86DyhUSKSpv8f3ph+nae44NrvSeKjbu395s0FpA1S9Mz4StfSEVtQPPiRKE/8aIU7F4GU0UFaWitnHn2f5+hA8pv3SD+IrGWJity0D7k3h6CrMMWDCU2R5SwciK8MIGishItWH4jEUQC7+MymsPZ5spNsiap1Ne7+2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jgMZrr/RZ3cgoqMe1xE+oQWDmiDAFXK2OI6pdeayuA=;
 b=hpYHatXOBYJyYJs+CN6dGDWdPFWor2g+JcZroYa534sgkNLNBc0XjX9EjneX16QL9GGS7KEjnS0P8gv2nCIfsSeqogecsO23ogT/h19oGbEd9bo53RpV2vv7CdhSm0XBDA3a/mkPaGQLobrnW+1gsiry7QmWz9aYN0l4QPNzqiCFf8tk3VF4uHbj/M8eDPkv+oavK6x0zVIjmQqXkL6lNpA6YImHP5kstJajsViiY2xJbsr35tI6PG5ItdJFfvycesVCijOrzgMzyfSX2Jv6khJxmcEJaZ4AJPLIO7YrWbimIo1qioz0LAW0P4VymlBPuNXTm6uPZsifuCVZ9CwARA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jgMZrr/RZ3cgoqMe1xE+oQWDmiDAFXK2OI6pdeayuA=;
 b=dtIGydaen2fdq7optkAL0/SW+VI73MLagD9/69Rnb6wgNz4ViEsZ+1XvZIWenUVN62PQPm3WYAl1PV8cecppGTbS9aBiq/+29Ql6b/s+dokZ44+VK7084RyxL/tQcTmuwE379/cDAgHnVr0VezFAYh0iKuii13OKedIMB1rUOWg=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:18:12 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:18:12 +0000
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
Subject: [PATCH v5 11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
Thread-Topic: [PATCH v5 11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Index: AQHdJl5v342qm+k4UkKlb4rwvhCWtw==
Date: Fri, 7 Aug 2026 11:18:12 +0000
Message-ID: <20260807111159.429128-12-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|DB5PEPF00014B98:EE_|AS8PR08MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: e25b7e6f-86ec-4b3b-9fd5-08def475a592
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 0HJ0TWJYaYa1FWMxYug2rbJmDZhrWUpZjvzkoUcMyFrjxq00HLpCT8GlM/59UQ8Q3Ux/wX0pIVPG7cn5LrVjyjOjd/if4WS0ZhEtKlAE99OU1Odbded4Ex8Cd9ONFB0p3LPtYJBONy0E/0oD+Ir3NDdd6oYHjCoQ2Ql245+5NO3xlEfD5qwcDpEaoXjt1UcRCMyMNNOHsyO6rkt3+OFQScnLHzOWEK0vJYTbTpomIztw2ZLrjfOhCBPMiyiQ61Umqn0eoaT5G2jjV/kHw9kRKV/IiulPBjAinmNgd0NV2fdhaqu4LSCtbPlrhUV3tNkyr89z1YBYjGMma2rgLr0Ave+TmUgcREJ3EC0DeSBCSCwLYv41nCYM3W61cSt1FPdrhSBcb0Q/lk2CAJFS1vTEnSNV5ksi6IQeZrrA+pYliPjTfGYU4u8celDx/BTdypPb2RX0DgdBNZVDxFH1pRenSHrKGk9my8X1VTvMvkcKXNnNS1WC4fWGHImAd6RUGadCLoMbMifQWXHKLxkF8BFdKXplrsIetX0snWqMCr/irhie9fw7IT2/s94J2Rl8l0iUefO8k0U5jxCXCKiAyVK6a8KjDUjoKIrUoNIw6IiXdIBze1Yxv5VSpdiqrrQrvC7VtQD1gTUj0IWedOt+O43Ka2RqcLLe8ECawMEHMjCwV/bWkYJcZLuYi0Y71MCShanIB5FDooLUPjMAlBYYddnXK4+IZGIKcUXb4XzF6vgW6O8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BssGdtZJUP1nvDbcZT3IgUDEknvko5zkl2Ik0HCUjvYUVF++natorM8vrYNymzhyIQ0DV2fTcvBd52AXItGT4I6GAdEtBnsPjd2BpXvnTPGb5CqTU3JpusKEz9fOleXmg1yy4Jm6ZknlMkLdhvnmJDP5hIN4gkFRIw0HjJT7nnr3AZ+U2HMAzLvn8Nln3p125L8Ywso2oB6235q842Y9GIJy/RDchw3vTBMkeezON88GpeMpVfjHcg1VU73mtOtkcAkQwVH8pKmLJPIRPhFY3hx2qZdgwQqjid1vwzc7qU/bcW/ImpsVL73254fPF23ABT6KG5K2bGrL90OOq9Z+vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	09a52302-5d70-491d-a6f1-08def475917d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|35042699022|36860700016|23010399003|82310400026|18002099003|22082099003|6133799003|11063799006|10067099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	c1lDzKYx4wrd9rUuayukQ3cyp83MBz+oUEcU7Mhsqax+DQGG2hB3SGX62Bw38Po8tuTKpuyWEiJa55Rp24lfGXAdH8B+SJycaIQVU0+NETF/jJe20xxKRfC0cSXt4EyOUMipc6J3UNLwQFuNih4XEKglPaMpLTQ36p6E8dwC7jdc+dEgp4zUxMlL6OS+TQBvRNSNbVFnTBR7cKVuFb67Emxooc/3Tyfqdmj+Y7tROO4dGt8PVNuvKDS4mnej2cTrdH0C/XWJqDNB2owRJ6P3RWql9TsKWARfd2OrK3DxVT+qhzNdJ0kejJFu8go6JgrM1aFIuq84O4QEs1DbA+rwHdcr+ltzw2mBLtn64dHu5hvCKvo9AxYSHCambtdxC9i90KiIYgUDKK9q+ha5TAEDNeGngGX18j3c07eoTBKdN9EsKiJHgJCyEG5RtUwyqIrWC0cdS+zikO5/FwhUnckZWT5Rzks3pQ4ToYH36BttdFTx1cO+WWBH+OxPaz6DOxJeN5D3nmi924vVBLZLM/Vv9qdbsOjKSah75MEBd8wLdsaQqzmBGW4WYBpTffEFRBQc8si8AbE+sF2NnK4R4w4psTiyPdCVBmzOsZTWw7iD3jaezy/GGvVIinacbtasA1Y4RR875jvg4uBrqlRmxWp3bH8BUh861mqtF5fT/CmuJHPAd0o4HebVDux6QaJJ+CdR+X/2h3p7eLQgIJG/psMqoQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(35042699022)(36860700016)(23010399003)(82310400026)(18002099003)(22082099003)(6133799003)(11063799006)(10067099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bO8LFZ83348BfudYKb2aCnPthtoYQGCbsaT2zy5p95RMXcVugKzjlCDRboIZzpv71WpWKJISZANwTKQJaQ4Mf36UJkMpKNalhezZfCE2c9Bm0e+ovHm6nWhOy1IjT9DIGnMVYbjWUOD7IyvCGxsApeWITbgiibb00QzUTNMhW1ej3hwBa+Lq4CAjD7XrXW2aMWD/LqYOlWWhx5a7vfiY565SVEImLFIbArVIqdgik6gf7YsGoAC+sJk1mbS+cWiAwuHdoFgSbpQQPK7+KgoO942RZX62AC49vPZYtSvJlD2YlpA7TFmFkYms0ifLlMpD912ycQ+SQThC3GQtTEiEFO3QBqRejFqBNTg7QifgvkFoacdQ0Z4iVjMaDkjpu4Y9ZJGAOpfIiAo05pMToLVScXYPh8C3+B7/oC4+RawURLUM1gUpvDfu0QIXMUYBTuNX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:18:45.8303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e25b7e6f-86ec-4b3b-9fd5-08def475a592
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6280

GICv5 has rules about which fields of a VMTE (or L1 VMT) may be
directly written by the host once the table is valid. This ensures
that no stale state is cached by the hardware, and provides a clear
interface for making VMs, ISTs, etc. valid.

The hypervisor is responsible for populating the VMTE for a VM.
However, it is not permitted to write the Valid bit, as the VM table
is already valid. Instead, the VM is made valid via an IRS MMIO
operation. The same applies to the ISTs: they must be made valid via
the host IRS.

This commit adds support for:

* Making level 1 VMTs valid, allowing for dynamic level 2 array
  allocation
* Making VMTEs, and hence VMs, valid or invalid
* Making SPI ISTs valid, and LPI ISTs valid or invalid, for a specific
  VM

As part of this commit, the following vcpu_affinity-based commands are
plumbed in:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE, and hence VM, valid
        VMTE_MAKE_INVALID - Make a single VMTE, and hence VM, invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

The lack of SPI_VIST_MAKE_INVALID is intentional.

When successfully probing for a GICv5, allocate the VMT and make it
valid through the IRS MMIO interface. Treat failures while allocating
or assigning the VMT as hard GICv5 probe failures. At that point the
IRS VM table state is a prerequisite for vGICv5 operation, and falling
back to the legacy path would leave the host without a valid GICv5 VM
table setup.

Conversely, if vGICv5 registration succeeds but registration of the
optional legacy vGICv3 device fails, retain the working vGICv5 device
rather than failing the entire probe.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  56 +++++---
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic-v5.c        | 192 ++++++++++++++++++++++++++-
 3 files changed, 225 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index f088006f39674..b143f15fd7d47 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -73,6 +73,21 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VMTEL2_LPI_SECTION	2
 #define GICV5_VMTEL2_SPI_SECTION	3
=20
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -561,25 +576,6 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
-/*
- * The following set of forward declarations makes the code layout a *litt=
le*
- * clearer as it lets us keep the IST-related code together.
- */
-static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
-				    unsigned int id_bits,
-				    unsigned int istsz);
-static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
-				unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
-				 unsigned int istsz, unsigned int l2_split);
-static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
-					   unsigned int id_bits,
-					   unsigned int istsz,
-					   unsigned int l2_split);
-static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
-static int vgic_v5_spi_ist_free(struct kvm *kvm);
-
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -723,6 +719,18 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
 	return 0;
 }
=20
+phys_addr_t vgic_v5_get_vmt_base(void)
+{
+	phys_addr_t vmt_base;
+
+	if (!vmt_info->two_level)
+		vmt_base =3D virt_to_phys(vmt_info->linear.vmt_base);
+	else
+		vmt_base =3D virt_to_phys(vmt_info->l2.vmt_base);
+
+	return vmt_base;
+}
+
 /*
  * Assign an already allocated IST to the VM by populating the fields in t=
he
  * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
@@ -785,8 +793,16 @@ static int vgic_v5_vmte_assign_ist(struct kvm *kvm, ph=
ys_addr_t ist_base,
 	/* Finally, mark the entry as valid */
 	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
 	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+	if (ret) {
+		scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+			WRITE_ONCE(vmte->val[section], 0ULL);
+			vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		}
=20
-	return ret;
+		return ret;
+	}
+
+	return 0;
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index a711a247cc6be..38b6f5269a2aa 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -106,6 +106,7 @@ extern raw_spinlock_t vgic_v5_irs_lock;
=20
 int vgic_v5_vmt_allocate(unsigned int max_vpes);
 int vgic_v5_vmt_free(void);
+phys_addr_t vgic_v5_get_vmt_base(void);
=20
 int vgic_v5_allocate_vm_id(struct kvm *kvm);
 void vgic_v5_release_vm_id(struct kvm *kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 34f197830611e..89d39b287a615 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -16,6 +16,9 @@
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
 #define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits, phys_addr=
_t vmt_base);
+static int vgic_v5_irs_clear_vmt(void);
+
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
  * ones are, and generate a mask.
@@ -43,6 +46,21 @@ static u32 irs_readl_relaxed(const u32 reg_offset)
 	return readl_relaxed(irs_caps.irs_base + reg_offset);
 }
=20
+static void irs_writel_relaxed(const u32 val, const u32 reg_offset)
+{
+	writel_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
+static u64 irs_readq_relaxed(const u32 reg_offset)
+{
+	return readq_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void irs_writeq_relaxed(const u64 val, const u32 reg_offset)
+{
+	writeq_relaxed(val, irs_caps.irs_base + reg_offset);
+}
+
 static void vgic_v5_irs_cache_id_regs(const struct gic_kvm_info *info)
 {
 	irs_caps.irs_base =3D info->gicv5_irs.base;
@@ -63,6 +81,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -83,13 +102,52 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	vgic_v5_irs_cache_id_regs(info);
 	vgic_v5_get_implemented_ppis();
=20
+	/*
+	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
+	 * can't use them all.
+	 */
 	kvm_vgic_global_state.max_gic_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_cap=
s),
 						  VGIC_V5_MAX_CPUS);
=20
+	/*
+	 * GICv5 requires a set of tables to be allocated in order to manage
+	 * VMs. We allocate them in advance here, which alas means that we
+	 * already have to make a decisions regarding the maximum number of VMs
+	 * we want to run. For now, we match the maximum number offered by the
+	 * hardware, but this might not be a wise choice in the long term.
+	 */
+	ret =3D vgic_v5_vmt_allocate(kvm_vgic_global_state.max_gic_vcpus);
+	if (ret) {
+		kvm_err("Failed to allocate the GICv5 VM tables; no GICv5 support\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * We've now allocated the VM table, but the host's IRS doesn't know
+	 * about it yet. Provide the base address of the VMT to the IRS, as well
+	 * as the number of ID bits that it covers and the structure used
+	 * (linear/two-level).
+	 */
+	ret =3D vgic_v5_irs_assign_vmt(vgic_v5_irs_two_level_vmt_support(&irs_cap=
s),
+				     ilog2(vgic_v5_irs_max_vms(&irs_caps)),
+				     vgic_v5_get_vmt_base());
+	if (ret) {
+		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 suppo=
rt\n");
+		if (!vgic_v5_irs_clear_vmt())
+			vgic_v5_vmt_free();
+		return -ENODEV;
+	}
+
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
-		goto skip_v5;
+		/*
+		 * Don't free the VMT itself if the hardware still has a valid
+		 * pointer to it.
+		 */
+		if (!vgic_v5_irs_clear_vmt())
+			vgic_v5_vmt_free();
+		return -ENODEV;
 	}
=20
 	v5_registered =3D true;
@@ -116,12 +174,13 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (ret) {
 		kvm_err("Cannot register GICv3-legacy KVM device.\n");
-		return ret;
+		/* vGICv5 should still work */
+		return v5_registered ? 0 : ret;
 	}
=20
 	/* We potentially limit the max VCPUs further than we need to here */
 	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
-						  VGIC_V5_MAX_CPUS);
+						  kvm_vgic_global_state.max_gic_vcpus);
=20
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
@@ -131,20 +190,145 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VMT_BASER, IRS_VMAP_L2_VM=
TR,
+ * IRS_VMAP_VMR, IRS_VMAP_VPER, IRS_VMAP_VISTR, IRS_VMAP_L2_VISTR.
+ */
+static int vgic_v5_irs_wait_for_vm_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VMT_STATUSR,
+					GICV5_IRS_VMT_STATUSR_IDLE,
+					NULL);
+}
+
+static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
+{
+	int ret;
+
+	lockdep_assert_held(&vgic_v5_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	irs_writeq_relaxed(val, offset);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits,
+				  phys_addr_t vmt_base)
+{
+	u64 vmt_baser;
+	u32 vmt_cfgr;
+	int ret;
+
+	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
+
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
+	if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
+		return -EBUSY;
+
+	vmt_cfgr =3D FIELD_PREP(GICV5_IRS_VMT_CFGR_VM_ID_BITS, vm_id_bits);
+	if (two_level)
+		vmt_cfgr |=3D FIELD_PREP(GICV5_IRS_VMT_CFGR_STRUCTURE,
+				       GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL);
+
+	irs_writel_relaxed(vmt_cfgr, GICV5_IRS_VMT_CFGR);
+
+	/* The base address is intentionally only masked and not shifted */
+	vmt_baser =3D FIELD_PREP(GICV5_IRS_VMT_BASER_VALID, true) |
+		    (vmt_base & GICV5_IRS_VMT_BASER_ADDR);
+	irs_writeq_relaxed(vmt_baser, GICV5_IRS_VMT_BASER);
+
+	return vgic_v5_irs_wait_for_vm_op();
+}
+
+static int vgic_v5_irs_clear_vmt(void)
+{
+	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
+
+	return vgic_v5_irs_write_vm_mmio_reg(0, GICV5_IRS_VMT_BASER);
+}
+
+static int vgic_v5_irs_vmap_l2_vmt(u16 vm_id)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_L2_VMTR_VM_ID, vm_id) |
+		GICV5_IRS_VMAP_L2_VMTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_L2_VMTR);
+}
+
+static int __vgic_v5_irs_vmap_vm(u16 vm_id, bool unmap)
+{
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VMR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VMR_U, unmap) |
+		GICV5_IRS_VMAP_VMR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VMR);
+}
+
+static int vgic_v5_irs_set_vm_valid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, false);
+}
+
+static int vgic_v5_irs_set_vm_invalid(u16 vm_id)
+{
+	return __vgic_v5_irs_vmap_vm(vm_id, true);
+}
+
+static int __vgic_v5_irs_update_vist_validity(u16 vm_id, bool spi_ist, boo=
l unmap)
+{
+	u8 type =3D spi_ist ? 0b011 : 0b010;
+	u64 val =3D FIELD_PREP(GICV5_IRS_VMAP_VISTR_TYPE, type) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_VM_ID, vm_id) |
+		FIELD_PREP(GICV5_IRS_VMAP_VISTR_U, unmap) |
+		GICV5_IRS_VMAP_VISTR_M;
+
+	return vgic_v5_irs_write_vm_mmio_reg(val, GICV5_IRS_VMAP_VISTR);
+}
+
+static int vgic_v5_irs_set_vist_valid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, false);
+}
+
+/*
+ * LPI ISTs can be invalidated explicitly. SPI ISTs are invalidated by mak=
ing
+ * the VMTE invalid during teardown.
+ */
+static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bool spi_ist)
+{
+	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
+	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
=20
 	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
=20
 	switch (*cmd) {
 	case VMT_L2_MAP:
+		return vgic_v5_irs_vmap_l2_vmt(vm->vm_id);
 	case VMTE_MAKE_VALID:
+		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
+		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
 	case SPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
+		return vgic_v5_irs_set_vist_valid(vm->vm_id, false);
 	case LPI_VIST_MAKE_INVALID:
-		/* Not yet implemented */
+		return vgic_v5_irs_set_vist_invalid(vm->vm_id, false);
 	default:
 		return -EINVAL;
 	}
--=20
2.34.1
