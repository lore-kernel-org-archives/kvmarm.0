Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013066.outbound.protection.outlook.com [52.101.72.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7EB306B3D;
	Wed, 15 Jul 2026 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784133187; cv=fail; b=W3fEHMchL/QUKgrEavyulRrqT+Z4riNS1zWY/+FwbXNBUZqbR6vVb45pLl37RcyixPKzprsycdXWYN54Sal1oi9oQOcHwaRz7GxOUUG3FYe4s+xfXftcnw6SudfuoUsOrDBobUTLTAAa8xRmwYRKbF74//ZLdI5tjkSSNMdNdZE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784133187; c=relaxed/simple;
	bh=Gk9M+DpimvSXmK49cYSqfZf00sSX6l2NlB+97SjhmBU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J/viD8Htinrj6GYRJkE5F2JHYK2RHfs/OfZR4/W96v4bq0HDSb2S0JsnZWpnCbkPktJVvUTZhySx6H/OSghdBEFwuQXbRobWzd8nJQpWzMuqsYNsja1UWh3dsoK+StRmsfcEMosWB0vGahx/ar5liBLnUH9Kwp9aPx6T9sJBrsY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AckoFTmx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AckoFTmx; arc=fail smtp.client-ip=52.101.72.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AckoFTmx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AckoFTmx"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VP76gQess/69RgDOLD/+VxyRMgAMN9P9oGW6melIr2ZdkWPN3bafFLLKkjE1DQnIdna7yBtRY4Fw5DB4/KCnxrcSwM9UvvsT5t9mdU+jbIQB2w8AkXbvBJ0S1zNPrWPxN/TOOPNm+FV/51U5s3ZZMRiOHrRGUWR0iZVgt6rJ4cgr3aMF6YFfCc1iFVoa+rE62LhSAhv2YVKjUSFuadEkO3/9O9jL4omymxDJx1D99LxE5kF4vJF4kNcO59q7bjGgj6AIgmq8Z76okgkgMC+yXLkEkkxWYN4pF0/SBmWrRI9y/gqof5YyGNWcyu540zgoMiCYgLAPQ1gsy6Wx/K0bhQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gk9M+DpimvSXmK49cYSqfZf00sSX6l2NlB+97SjhmBU=;
 b=l6crTPewGJgXPXj/C4ZQna2FcBMQvDWK+4Zq4JuaZcnhTMLKpzfiJeD9tXU6JxC+8WRDXjuNPiqSFbuAD2hOKnSF7W3/b2iSKrCXMRB30hDxoXYC4KGsVRIwLXXTesExbnWOs3so0dYaUyhQaQECIB0pqnNnrywOhAi+kNZX8Y6RVQEYAIUpJkoiIj1vQPFPhp3GzIC0ndHKgJyiedDLmKH4VpE/XYPjUHwvC7ARncwwEBmYUMq1c4atcN+mYaySzkD36+jokMpjnRRM0TUvdBg9Kza+npCvdDplL7/DwvfMCc0MftPtaUeA8rEWGBNXN7kVC6H3wPt3n4do2i1OlQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gk9M+DpimvSXmK49cYSqfZf00sSX6l2NlB+97SjhmBU=;
 b=AckoFTmxJ/scovVoKD8Um/Hma+VKYbN9K1lQa42jPlbBfuUtAAeOWO6Zo5fizifcpvpuIja61/O/xDRV1LBpkmKC0eeUQHfogC2Rv6r8oHCY4GZP41CNJ0WacVBUsx5e3RMWiGyWBUD2JIoobf6wDClKMlhA8TEwxY0s5my1WKM=
Received: from AS9PR01CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:542::13) by AS8PR08MB6600.eurprd08.prod.outlook.com
 (2603:10a6:20b:33e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.20; Wed, 15 Jul
 2026 16:32:58 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:542:cafe::16) by AS9PR01CA0032.outlook.office365.com
 (2603:10a6:20b:542::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Wed,
 15 Jul 2026 16:32:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Wed, 15 Jul 2026 16:32:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CVqqnDbF2xH0dTT50eQTGYmZwlEJXvuZWUj2+ANN7wQ0P4tUQgIh+0MgYYwMLLQRwT8qxEEFJJjYjVmRwkaU3NA5cFt5xvO1M0u1q3mhmfsDxH+sw7fL2qhEjS8hjzcgugm5nfaJ/mSksFN5ZXl8DZcQceWeA34a8HHAeO8hitxW3d+r1wu9gfTr4dna7wuDbcN/LFfEkXZkfLYoAo2S2j1qDHavaq6LMUYqELCvJ5F7H2e6BR1jAAya51+OK73CVOHu1TTvmU/X1un6JtWiPQxAk7olufztM276LPCU+j33+V44RMLZZskwd5hLaw4YMSXPem5TrqwjNe53flWksg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gk9M+DpimvSXmK49cYSqfZf00sSX6l2NlB+97SjhmBU=;
 b=LEo4UDyFi7+tbWcAR11lLgx8+YK6GuQ1I/HwIBDyscKgJPooZMlRgR3RHfUB549McGSWF35qVTS3aVwCgEgBYuAcW98Z4CMirNIJ1kwfPzkTLHuEi2/49yPIyZ7bZrZ4AqwofA4NrU3NDqRbUQFHWuEKy1yDVe0ifaLXSyUTjWoeAz9dZ/ecg6b+HWZUHWHGKNM5yoa2p0moTnckIROeklakVtwkdE/06MNy5ruep1y/EnSqouERM/1bRABALOLP8sg6513bO+MEFK6z1qqqj/2hz/B+S5q5j3iE/DdX4KuHkXsA+ErDuKe5utQ/K7b1dbIRh4XHUQLNHXyA5lt39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gk9M+DpimvSXmK49cYSqfZf00sSX6l2NlB+97SjhmBU=;
 b=AckoFTmxJ/scovVoKD8Um/Hma+VKYbN9K1lQa42jPlbBfuUtAAeOWO6Zo5fizifcpvpuIja61/O/xDRV1LBpkmKC0eeUQHfogC2Rv6r8oHCY4GZP41CNJ0WacVBUsx5e3RMWiGyWBUD2JIoobf6wDClKMlhA8TEwxY0s5my1WKM=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS1PR08MB7611.eurprd08.prod.outlook.com (2603:10a6:20b:476::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 16:31:56 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 16:31:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 31/40] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Topic: [PATCH v3 31/40] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHdCwXilgWQ+uY8G0KjXbBPtg8WHrZb/hOAgBLaxoA=
Date: Wed, 15 Jul 2026 16:31:55 +0000
Message-ID: <d5220f5b615fca6e0e7d808dd60a08fde27e4469.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-32-sascha.bischoff@arm.com>
	 <20260703163614.9A19A1F000E9@smtp.kernel.org>
In-Reply-To: <20260703163614.9A19A1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS1PR08MB7611:EE_|AM1PEPF000252E1:EE_|AS8PR08MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: ca7ab97f-0d01-4315-7d38-08dee28ebb39
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|22082099003|18002099003|6133799003|10067099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 OLsPJRvdYUsAC+v14KSvNczjkLatrY9j9OoR/SlWjuMVWSWm1xWOnFMwfDuFMmxrrjs867KafyvrFpq24d8lu/otIGLzxUDYejig9pMJhwu7h2yMBbtNIXgWXeeK+dbjqs2a+hq75/wS9g0uAjUh+nHisZno1zQ2YLQGeO6BIx790urWirgP7JLZCrW/ir/S1ckuorFue3502406heCD1gkdNLOKiPALiIK+OVQdvNPiarZbyQOmxgxY7krI0fcKnzHVUyl3prWnnrQFj7mevkQS/LdjAf1eW7ziCa2NmeZMZZFjNTUFNH6ThzAM+vc+Py5W/4vOMjABCbZzgYCJTiYKE8SaZTYp8s1/vKTFdWPPfMBM98nRm52imCMWETopDHPKB0hUu0+54QVB6idX4hIVhV2U1C9kf5Ue3xB0aaOxmbjpd+MMyyfZ9BKDsBrAUYnS2OcL6aniJlK1Uy7cNIQlPbZzxJ8YYiS0WSGGO5R/+noOnF5g/6HkDEXaOOXKR0x6h8aCFDgSIGs1fyA3DOrstvxcXQgMKRQSeghYtU34zFu/5GbeQWaXox9YL+lGWteVQ2htqsdIzAS0DUzTiBdFUNtQPBX7UNln6QPXhfyvCPFhLG6cqkRPkC4+yigWkHqmAcU4g/9NpHb9MmkHDjTWECM9EUVPEY8ukdFU2ZynZ+84IML7gLs9jl3WUb7V4hb7EeaGc2otSbIcEzD8oMECVguO6+RwQRPtn2ee7mg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD0DA86B3FA37A4EAEA9AA4923A590C3@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 PPoXaCi33pawm8E5JRrz2udI05wYB2vRqvSofw/GMndViRs9PP85d+JDOmWeHOrpReMUslbYFgzDFCoOqaGrS30tdRwBs7wATbyGvTHlNAcAsbKbEGum3LgMUNE+Gt8iKV06ey3MbM/z5oJetBOJY63TvqKaVBtkWE9HYFJr2qZLX1xIL8zcfOLSuMAjuQvsgLwA2ROqhwBr0x+k+vr/I6dJZiogWn0yoo1EWtGRPDrwM4/dj/Xuikm6pN+CLQBLc4fQJaHY+3q2aho4tRgonS7gLeDEt3iIHfoNW1lqNwt8ofyANEZ44Bsf8cpwgKyJNrr15nqvrnDULLKH2f6t6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7611
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c7bab51f-d080-4a53-b6c7-08dee28e95c3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|82310400026|35042699022|1800799024|14060799003|10067099003|18002099003|22082099003|11063799006|4143699003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	dh4eDD8hu3ptWpRahbWxa02aBMgr2elt27Fk2W+SaSGPfZkiwQM7zpv71pACk3L+HGHVS3pa/sCkCcU4Q36cyXhoa139Lkcoca97ti5Injlg99OgGoHswYD90dcmw1lV6bBV844ILuwETIlidOyOrto/g3v3BxiCliUFg5L6udOjsxnuIyCt0f0RITxkc2KnjpHlHQprs6n3awOnH8Zx/xbICreG3yu6xPx1dFY8WfSOk3KQ2MSMVnI5KF8cPWNpnD22bJFak1OGewnj3jdg7AOe62/Du8t7fQ6cDarmT4RnepNg8rCZQk/7ufAFgiewHLiliE4cxcnnt0YpzIav3q4fFSROZgIO9dHXujXnVicztJq/+SUPnxEgHdswVVOJE/EDN91WpQO8/IkDf+Tb9YGhmG+wD2kMV03CTwwUNEpRPJ1TIsMbfrzxUBV84PXRWCztIMw4jRvM36RB9uLzk+0lby7RopFsFTmOZv5zJcuIaKsgdTZoBLRH01vF02DaqTIByjUau/iMDjCF4VYYDey06XtWELYPWUPZN0os0/RIM4AP6aCV/nDigLpGkElFE5FA5DZrl3SzBLGUAWLcu+7xawbXD+i/hiYkqquIkyJBbLr+PQsbcOMUeZ8uLXGdDorS2AH3STT+l+FNNwwR/hcFK9yN+ayE5HZg+LZNCaJFOozENMPG1bx9IAS3yF5XYPFsPMS5ftVZF6WoJ30hUQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(82310400026)(35042699022)(1800799024)(14060799003)(10067099003)(18002099003)(22082099003)(11063799006)(4143699003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ku/7ZLeezrf1VGt4ZQJ+bCxVCYWESV5azot5Ods4IiN3DaRIi4B/fZWaOi/oLm5iX5e6J7VyW/0oFDjvTsCDzCijhrlaOiNCvWLOyTyNm6PKb9vyCXqEr1719MFzvrz+JH0OdV0N5zGgk9dx91mj1FgSFpoiTpe/dX6Sov9MhDP1cjfEkJ0m4mSB8mcb+ZL7yx0zOUvwr7L7y6d65DxjvN+KdM4aTHRziw6GVxTInfUUrUyCgaFUileTEDXcvXekSe/mEriINmYuIs5kk/KR+ihb9uSx+0vKXzSllkeHbDQ9aV/HIu7WRW9PmgpRwEmjNtPknW4nh5K24hltx45Zzrs2YfsZL9mP5mt1XoRgh85DDtq5mafstUrLPKujGckbmVnTfTssFugrRDV6hP592t4hD10HXlfW9ZhTNVD2pWjp1nuzvKOmUvtRcSN5+Xp3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 16:32:58.6553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7ab97f-0d01-4315-7d38-08dee28ebb39
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6600

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjM2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbQ3Jp
dGljYWxdIFRoZSBpcnFjaGlwIHBpbiB2YWxpZGF0aW9uIHVzZXMgdGhlIGR5bmFtaWNhbGx5DQo+
IGNvbmZpZ3VyYWJsZSBgbnJfc3Bpc2Agd2l0aG91dCBjYXBwaW5nIGl0IHRvIGBLVk1fSVJRQ0hJ
UF9OVU1fUElOU2AsDQo+IGFsbG93aW5nIHVzZXJzcGFjZSB0byB0cmlnZ2VyIGEgaGVhcCBidWZm
ZXIgb3ZlcmZsb3cgaW4NCj4gYHNldHVwX3JvdXRpbmdfZW50cnkoKWAuDQo+IC0tDQo+IA0KPiBj
b21taXQgZDQzM2ZhYzMwYmY0NzAwYTkwN2Y4NzI5NWI3NThkZGZmMWYzNmI3Yw0KPiBBdXRob3I6
IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFy
bTY0OiBnaWMtdjU6IEFkZCBHSUN2NSBTUEkgaW5qZWN0aW9uIHRvIGlycWZkDQo+IA0KPiBUaGlz
IGNvbW1pdCB1cGRhdGVzIHZnaWNfaXJxZmRfc2V0X2lycSgpIHRvIHRyYW5zbGF0ZSBpcnFjaGlw
IHBpbnMNCj4gaW50bw0KPiBHSUN2NSBTUEkgSW50SURzIGJlZm9yZSBpbmplY3Rpb24uIEl0IGFs
c28gbW9kaWZpZXMgdGhlIElSUUNISVAgcm91dGUNCj4gdmFsaWRhdGlvbiB0byB1c2UgdGhlIGNv
bmZpZ3VyZWQgU1BJIGNvdW50IGZvciBHSUN2NS4NCj4gDQo+ID4gQWxzbyBhZGp1c3QgSVJRQ0hJ
UCByb3V0ZSB2YWxpZGF0aW9uIGZvciBHSUN2NTogdXNlIHRoZSBjb25maWd1cmVkDQo+ID4gU1BJ
DQo+ID4gY291bnQsIGZhbGwgYmFjayB0byB0aGUgZGVmYXVsdCBTUEkgY291bnQgYmVmb3JlIFZH
SUMgaW5pdCwgYW5kIGNhcA0KPiA+IHRoZSBhY2NlcHRlZCBwaW4gcmFuZ2UgdG8gdGhlIGdlbmVy
aWMgaXJxIHJvdXRpbmcgdGFibGUgc2l6ZS4NCj4gDQo+IFRoZSBjb21taXQgbWVzc2FnZSBzdGF0
ZXMgdGhhdCB0aGUgY29kZSBjYXBzIHRoZSBhY2NlcHRlZCBwaW4gcmFuZ2UNCj4gdG8gdGhlDQo+
IGdlbmVyaWMgaXJxIHJvdXRpbmcgdGFibGUgc2l6ZSwgYnV0IGl0IGFwcGVhcnMgdG8gdXNlIHRo
ZSBjb25maWd1cmVkDQo+IFNQSSBjb3VudA0KPiBkaXJlY3RseSBpbnN0ZWFkIG9mIGNhcHBpbmcg
aXQuDQoNCkkndmUgdXBkYXRlZCB0aGlzLiBHaXZlbiB0aGF0IHRoZSByb3V0aW5nIHRhYmxlcyBh
cmUgZGlzdGluY3QgZnJvbSB0aGUNCm51bWJlciBvZiBTUElzIGluIHVzZSBieSBhIHNwZWNpZmlj
IFZNLCBJJ3ZlIG1vdmVkIHRvIHVzaW5nIG9ubHkNCktWTV9JUlFDSElQX05VTV9QSU5TIGFzIHRo
ZSBsaW1pdCwgYW5kIGhhdmUgcmVtb3ZlZCB0aGUgZHluYW1pYyBHSUN2NQ0KbGltaXQgaGVyZSBh
bHRvZ2V0aGVyLg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtaXJxZmQuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycWZkLmMNCj4gPiAt
LS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJxZmQuYw0KPiA+ICsrKyBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy1pcnFmZC5jDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+IEBAIC00NSwx
NSArNTAsMjEgQEAgaW50IGt2bV9zZXRfcm91dGluZ19lbnRyeShzdHJ1Y3Qga3ZtICprdm0sDQo+
ID4gwqAJCQnCoCBzdHJ1Y3Qga3ZtX2tlcm5lbF9pcnFfcm91dGluZ19lbnRyeSAqZSwNCj4gPiDC
oAkJCcKgIGNvbnN0IHN0cnVjdCBrdm1faXJxX3JvdXRpbmdfZW50cnkgKnVlKQ0KPiA+IMKgew0K
PiA+ICsJdW5zaWduZWQgaW50IG5yX3BpbnM7DQo+ID4gwqAJaW50IHIgPSAtRUlOVkFMOw0KPiA+
IMKgDQo+ID4gKwlpZiAodmdpY19pc192NShrdm0pKQ0KPiA+ICsJCW5yX3BpbnMgPSBrdm0tPmFy
Y2gudmdpYy5ucl9zcGlzOw0KPiA+ICsJZWxzZQ0KPiA+ICsJCW5yX3BpbnMgPSBLVk1fSVJRQ0hJ
UF9OVU1fUElOUzsNCj4gPiArDQo+ID4gwqAJc3dpdGNoICh1ZS0+dHlwZSkgew0KPiA+IMKgCWNh
c2UgS1ZNX0lSUV9ST1VUSU5HX0lSUUNISVA6DQo+ID4gwqAJCWUtPnNldCA9IHZnaWNfaXJxZmRf
c2V0X2lycTsNCj4gPiDCoAkJZS0+aXJxY2hpcC5pcnFjaGlwID0gdWUtPnUuaXJxY2hpcC5pcnFj
aGlwOw0KPiA+IMKgCQllLT5pcnFjaGlwLnBpbiA9IHVlLT51LmlycWNoaXAucGluOw0KPiA+IC0J
CWlmICgoZS0+aXJxY2hpcC5waW4gPj0gS1ZNX0lSUUNISVBfTlVNX1BJTlMpIHx8DQo+ID4gLQkJ
wqDCoMKgIChlLT5pcnFjaGlwLmlycWNoaXAgPj0gS1ZNX05SX0lSUUNISVBTKSkNCj4gPiArCQlp
ZiAoZS0+aXJxY2hpcC5waW4gPj0gbnJfcGlucyB8fA0KPiA+ICsJCcKgwqDCoCBlLT5pcnFjaGlw
LmlycWNoaXAgPj0gS1ZNX05SX0lSUUNISVBTKQ0KPiANCj4gW1NldmVyaXR5OiBDcml0aWNhbF0N
Cj4gRG9lcyB0aGlzIGFsbG93IGFuIG91dC1vZi1ib3VuZHMgYXJyYXkgd3JpdGUgaWYgdXNlcnNw
YWNlIGNvbmZpZ3VyZXMNCj4gYQ0KPiBHSUN2NSBWTSB3aXRoIGFuIG5yX3NwaXMgdmFsdWUgbGFy
Z2VyIHRoYW4gS1ZNX0lSUUNISVBfTlVNX1BJTlM/DQo+IA0KPiBJZiBucl9waW5zIGNhbiBleGNl
ZWQgS1ZNX0lSUUNISVBfTlVNX1BJTlMsIHRoZSByZWxheGVkIGJvdW5kcyBjaGVjaw0KPiBoZXJl
IGFsbG93cyBlLT5pcnFjaGlwLnBpbiB0byBiZSBsYXJnZXIgdGhhbiB0aGUgc2l6ZSBvZiB0aGUg
cm91dGluZw0KPiB0YWJsZSBhcnJheS4NCj4gDQo+IFRoZSBjYWxsZXIgc2V0dXBfcm91dGluZ19l
bnRyeSgpIHVzZXMgdGhpcyBwaW4gdmFsdWUgdG8gaW5kZXgNCj4gZGlyZWN0bHkNCj4gaW50byB0
aGUgcnQtPmNoaXAgYXJyYXk6DQo+IA0KPiB2aXJ0L2t2bS9pcnFjaGlwLmM6c2V0dXBfcm91dGlu
Z19lbnRyeSgpIHsNCj4gwqDCoMKgIC4uLg0KPiDCoMKgwqAgciA9IGt2bV9zZXRfcm91dGluZ19l
bnRyeShrdm0sIGUsIHVlKTsNCj4gwqDCoMKgIGlmIChyKQ0KPiDCoMKgwqDCoMKgwqDCoCBnb3Rv
IG91dDsNCj4gwqDCoMKgIC4uLg0KPiDCoMKgwqAgcnQtPmNoaXBbZS0+aXJxY2hpcC5pcnFjaGlw
XVtlLT5pcnFjaGlwLnBpbl0gPSBlLT5nc2k7DQo+IMKgwqDCoCAuLi4NCj4gfQ0KPiANCj4gU2lu
Y2UgS1ZNX0lSUUNISVBfTlVNX1BJTlMgZGVmaW5lcyB0aGUgc2l6ZSBvZiB0aGUgc2Vjb25kIGRp
bWVuc2lvbg0KPiBvZg0KPiBydC0+Y2hpcCwgd2lsbCBhIGxhcmdlIGUtPmlycWNoaXAucGluIHdy
aXRlIHRoZSBhdHRhY2tlci1jb250cm9sbGVkDQo+IGUtPmdzaQ0KPiB2YWx1ZSBwYXN0IHRoZSBl
bmQgb2YgdGhlIGFycmF5IGFuZCBjb3JydXB0IHRoZSBrZXJuZWwgaGVhcD8NCj4gDQoNCk5vdyB0
aGF0IEkndmUgcmV3b3JrZWQgdGhpcyB0byB1c2UgdGhlIHNpZGUgb2YgdGhlIHJvdXRpbmcgdGFi
bGUgaXRzZWxmDQphcyB0aGUgbGltaXQsIHRoYXQgaXNzdWUgc2hvdWxkIGJlIHJlc29sdmVkLg0K
DQo+ID4gwqAJCQlnb3RvIG91dDsNCj4gPiDCoAkJYnJlYWs7DQo+ID4gwqAJY2FzZSBLVk1fSVJR
X1JPVVRJTkdfTVNJOg0KPiANCg0KVGhhbmtzLA0KU2FzY2hhDQo=
