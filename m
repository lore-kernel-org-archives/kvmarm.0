Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010056.outbound.protection.outlook.com [52.101.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33CB33067A
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747984; cv=fail; b=Nx0YATgK17N8vfH6APnHWKWMVmDTKWras3Ps/nbIMBdBhoNnn0cMmfGZ5iJJ+eG6SefzdbFO2MjVMIPP15vqIZ2bZsbtjbul5aIQ2PXc2GlYV3l/tJSS27my8mnLVXNNCUK1F3yF8gF/Tv7bSPxPpHq5hYramg+njf+QFVz9ODA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747984; c=relaxed/simple;
	bh=Ag/TYF4X+9mik54Vo4CFDUEkKj43jbvVNOCcJmML+b8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iAZMOP8jDU7on6778b3m6GDzlwUO5fWspYSwT9utTqj7ctgPq10N/0Sy5oqvIxS7jLeBghidCW9BZjCZNCUmeA2GiKTO8sYyL+gaG5Ox2mt/FsjxTzaDY83qGQrZCoU871IEjAH7bkyywnztQI7CGDdjY5J+P6tT4rlrRN3rI+k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O1RceEh8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O1RceEh8; arc=fail smtp.client-ip=52.101.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O1RceEh8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O1RceEh8"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cA9RwdzArsEVIHCPh9TCKUVZWnTVYnATFU4Vdcu1wP1T8fSjquLsDyLi59qY8ZqiBTBl/P0FwhwqsXjjOefRqjGswvDgpdnU4Yghy5fByVODQ2AWVC/FHhY0x7xI4c3ddc7+fqTBPXMXwMyrdDqnjWWt2VJPFoWdDSicMoerTdabsIqKcmjbpTlCFpStKQ5SImNs5iEDDvLH+mSK35sFHtoC6iAfJzcsGHPykHGH5AWeKC/bE8tc+JqV30aaz5vaIOijVZ9wPPTYyUDUm5b+3kC1sTaMLd1fB514KJqfuru+eCw2XcKtU4kRGf8onaD2T0KIgxQaWOEZwC3H4urMBQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6r1OK7kGYblNvcNBs3LkwWRslUgpE0SHIrTKg77CNg0=;
 b=YmR0zF2jBC4liRFkoE1DQ5u3bDuvZz3iabo4OjaXKDG/+zpowtTj0ato52Po/zovPrkwU7F1Sg4153PzkAi2ZE+aEvLcPpGfer8JNGqCVaTZR5eN6mthJ9VqPQaTOcR9Oykwp7UmMt7KYJle0LfBz3Fv/ZpURAzQYUlTunSQeS21d2NXYmIqz8GEiozmOBdxut9UGuLIEaMl1UAE85gG08h4HRLr775a8g85BvAfBjc+g7MQx+eAWjOkuoU1kcsVTpKW/rIhiq4A2WedtyEaPYH1+5ZUM/5dBd6vkPdt5MDf1PXawL50A0wAFRJ462cIBRTFWrib4n5FnKZcFz+0Wg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r1OK7kGYblNvcNBs3LkwWRslUgpE0SHIrTKg77CNg0=;
 b=O1RceEh8uLzllvkQQz9aUOKyBIDQqVcNi8JIz44n0nj88x+ximzgn7q4bmB+4FQUNhSuDYG7/N6HCO85Mzxaf9noYG8Skij6OGNC7xzY8N8u+/Q39djDMhXSoS7pINznKgJxmDE9SYfV3p8RTK5cfPOj7kVc5Sb4hQBgA3TN52Y=
Received: from AM0PR10CA0034.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::14)
 by DU5PR08MB10397.eurprd08.prod.outlook.com (2603:10a6:10:524::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:46:14 +0000
Received: from AMS1EPF0000008D.eurprd05.prod.outlook.com
 (2603:10a6:20b:150:cafe::39) by AM0PR10CA0034.outlook.office365.com
 (2603:10a6:20b:150::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Tue,
 17 Mar 2026 11:45:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000008D.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/my8ywENGpUEs8YCQxQy4xM5ldpv2s5n8uIDQV293xgAzmnlkack51iEQNRTzjd7kY64j1YvtIy+k0+u+BgieWmz94xfC9gvu/EohHOZD1QcJ4IA+gGjkviRJz79310mBToNMJbfv15diKF/zwxTi1d/QJiqWpDpx4aUBIvn7LgC+cWcGAxcT74M10mQGgG8MDrErUaqtKM4BoJtyLm6FsjI0TVTda8/rz4xcgTrKq7FCOte8g1EI+H9g10Q7IocJIXLi4qc3bOUmSyifW0IZ8MHvSSAY9i3tgLs3sQyCcEyieixbYGV5c94Mk4Fr0qE72Wd2jFpLqvG4oIloGBHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6r1OK7kGYblNvcNBs3LkwWRslUgpE0SHIrTKg77CNg0=;
 b=gDq3eQDGRuwQv/n6vYYqW/7+VXofO8Fcf0oCSoPmDN5xf3x9JNC7mouAQ8drxcId8PAClp3lwbWIOXNMMxMFi2h4gU+6WEXdiGgH0cWedFuK2W+M0HeYpmKxURAIJhHcM4LKam7MNbssnfHattfcJaJ2IGVbQWHAfxrYmw2RZGTxyUaQp11XU+OCcJQEc/H0WPPm4drYzrMYSkKukXexJZIVgjG9nn/r6H+/N1aeo0vB5JmcYvmCISKK/hO02U4QCtTzuBlUHEYHCHCkQykX9p9zGX7qsa7rozX7YSqVMcokR/dtDNRdadxcqu03VaZbvP+N6R4QdpeaaNOWAWyQoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r1OK7kGYblNvcNBs3LkwWRslUgpE0SHIrTKg77CNg0=;
 b=O1RceEh8uLzllvkQQz9aUOKyBIDQqVcNi8JIz44n0nj88x+ximzgn7q4bmB+4FQUNhSuDYG7/N6HCO85Mzxaf9noYG8Skij6OGNC7xzY8N8u+/Q39djDMhXSoS7pINznKgJxmDE9SYfV3p8RTK5cfPOj7kVc5Sb4hQBgA3TN52Y=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:45:11 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:45:10 +0000
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
Subject: [PATCH v6 20/39] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v6 20/39] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHctgOCb5M+2yZNxkOtadk2PxXfng==
Date: Tue, 17 Mar 2026 11:45:10 +0000
Message-ID: <20260317113949.2548118-21-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|AMS1EPF0000008D:EE_|DU5PR08MB10397:EE_
X-MS-Office365-Filtering-Correlation-Id: f3fdb615-56c8-4530-8c3d-08de841aca8b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Kyu8AA+7IY/xRmClaJTqFp7PlfZDomw4kP+jn/L2agu9yrDO7MklWT3v/C2XkH+ZwubQ02WpCUF1IO+GvI3Jj5DzJBveP2af1ENcmwM+8hQsF7HceFMr/E1aXfgz7ZVafS23s9JEPkPpzYSVf8nzdKH1kyCGChcL6otb9UdKgVMDK6s3wINYt0Dv+xASlx25QL1N0Ap9DxO7iK4qlBF5bo7vD4UVhGpXYaMYsKz4TFvQmtTP3gqv6paTnENGUt4ScAFa1i5b/1oRGd3it8FpwqOddnfhkNdTjae+xz4fgQRiylNfl1XlR4ByH6mWe7YSqCHp05lCH5qqZRWy+I1FCgAMDxCW91AaQDjmhGFIx13dJK8wVENexE/1xmfTBROt8MzD1riL7IwdE/3A7mqlfXZ7Rhi4BVC1xWynOCBUSsEJf6R5cSq62Z2whX+wkdAblfpPWom/Tv0phYjJ463oybNcFR2Mn8H5rsQxTJM/Nsdpf1Xrfq2BB4v6ZheQ3QN/xtAlWpGIO6wLTlCX/AnNkSQwsidNcwfFUfEgpRn5F/ux8RLRFFsXUxwCRYyGgR0GnaWQu3XKwK1Ns3hspYaWcR3TUMn2yP51949XkkJ4vw1cbg7IvlGNcYrAAeEady17OpS77Qn1sbpxNvkEVsRTVZkQ34epS20wJ9hl9CRPT66WSjh3E43b9jDsImw0FjsJodxyXsDgavadQliRxp5B4dY+Gn8HxbXY89fOF9NxopGtSD2SZFNzj5a/KHgbKzLM+ifd3CaU1OJ8lxSM14e1wZaEyOTFknc37A9dPkTBvsI=
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
 VvsWxpf+DHForOZDZ1iPRFe42njG2Np8UBKoszGpVAk7jDrq/KwuVsEL51oGRdUi0FC7EzjkVdULGViLSVyAilldu05Mhil4zSBdUPUSCJbpBywp+EPTtMMc8ESyOoU/ndfI9uUqTjFgjc/8oDZ5eU/hMDllj9RJo7rMj3lhcRJfjgAWljq8V33YoBpkCLEiTMp4DK/Wwyyj5BgdywmyJhA+nb4iGoxbMG5xRgkDBA5T5IvABr/bvS+DnnPKhAnckLcvQK7cTA2khxwxVH0APRvFsrxoGKMJEDnufo/qMOFTERXMieW71n8F9SQyA+NwbECYah0Hp1Oh+SgWp9UmnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000008D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8751411a-7bba-4e77-8b38-08de841aa523
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|36860700016|35042699022|82310400026|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cG+8oJWKzus34eoGpNovKjYXgyW+zHhiC+y0ugTTnoXq8uvbOUW8Y1Ms3NWi88TbnPU7Ojcoc8yYskZHC37iSyd5Vja6b0YVGrPW8AErPSol7nsU0e9nSLwNTEwN5G5O2ShX48CWNfATUfHksQQ/pvtBzlHN5JiwwgMsZWEe/kW4cSbQz8y2eQc9v3L5dmQYF0uN/PLpmMt4FwjycNFDKWMS3+IJUPYld/9PVcAoZddJ/y0vIXNHfAwCJFtpYSs4ZO4StT38RA9VN2dJ5smrrWWAf4lo9CZYbuRF4pLg+uI60jsCTfHRCUDPLb3r+rx9T7ElJYWghIPoyY8iERh1fqnE4eHrQHjTLplfJsqiPbAtI7VKqY5GIOFLER49G7FYSkuAZcVrb1T4J+/M27ObSa4gm+2ZiPEejsLlR7vCl94mJewMMNd1sJHJFK4ymovtxVKNKNar1t0J8a5wnTLGKhGW3WiagpS+9MsWwmPxXwo4kMVO8ELzrG2OJjW4ngv3tSLhL5Gw3pOZRFw5cW9NCYlzGLj+JapFdmtpHMjfoLLy7z/PhKlOq5Lcm8RlrgzQ40/qlGCxYFKDooNvIGEt231GQgRPMsLHJZ8OvcMqxPsgQjx9jE37kzgoZjltp/Vxk5IBoBtNbi88VBLK8PVV+4YUauM6SYDQ/6y6oSzHGlFvpOvqU2swPjPFKevSsXGNEnLWmMleiOqGwcABOTUrTNgKpCLQbCRGxPnqmtzZ3RXjqP2X6U2HTz66tW/XnlsDg0Hg9aOdJq4CeG8j7vgz7w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(36860700016)(35042699022)(82310400026)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iDBVhuf0UTKSFHGfRmy6BvappQFYBjxm/Yc1QSqFrhIL1hgBBMwojevjrN41LnGYq9GE1vjW/reWvcAlhjCs11rYltMCfCnR6vaUDDjBuoUabBtPjXKjsNsCrCiHAZQRNxZwU098xonKgvq0HSgLvrTwsSBiCRMrjvC5uhofji3jiyEB2atXeYKrhysSNazSKkbZw5hTwxu7Ovir2V2jf2tZap/X9tYhJAbK9kyEnt/7QIvNlk05vQzQvQUBY/4oKp4xl1kSOsZS1Q1dLVWgo9iPnqBmS5e6seF3RPawlBW/JylQOsHzElXs+7w5CHvLZX3goA6jFmt/EgPiQ5gbvX/npocpiF4srDffRZ+oRpYW9+5BOU/ad8OQpDpmtj/oKtkejLRXPLwLJEvQ277D+o9duzFvsv2SvfrPRMFvvsLm5cyhNAuyx0ydK4LvXC5a
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:46:13.4386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fdb615-56c8-4530-8c3d-08de841aca8b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10397

Initialise the private interrupts (PPIs, only) for GICv5. This means
that a GICv5-style intid is generated (which encodes the PPI type in
the top bits) instead of the 0-based index that is used for older
GICs.

Additionally, set all of the GICv5 PPIs to use Level for the handling
mode, with the exception of the SW_PPI which uses Edge. This matches
the architecturally-defined set in the GICv5 specification (the CTIIRQ
handling mode is IMPDEF, so Level has been picked for that).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 95 +++++++++++++++++++++++----------
 1 file changed, 66 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index e1be9c5ada7b3..f8d7d5a895e79 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -250,9 +250,64 @@ int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
+static void vgic_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 ty=
pe)
+{
+	struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+	INIT_LIST_HEAD(&irq->ap_list);
+	raw_spin_lock_init(&irq->irq_lock);
+	irq->vcpu =3D NULL;
+	irq->target_vcpu =3D vcpu;
+	refcount_set(&irq->refcount, 0);
+
+	irq->intid =3D i;
+	if (vgic_irq_is_sgi(i)) {
+		/* SGIs */
+		irq->enabled =3D 1;
+		irq->config =3D VGIC_CONFIG_EDGE;
+	} else {
+		/* PPIs */
+		irq->config =3D VGIC_CONFIG_LEVEL;
+	}
+
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		irq->group =3D 1;
+		irq->mpidr =3D kvm_vcpu_get_mpidr_aff(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		irq->group =3D 0;
+		irq->targets =3D BIT(vcpu->vcpu_id);
+		break;
+	}
+}
+
+static void vgic_v5_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32=
 type)
+{
+	struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+	INIT_LIST_HEAD(&irq->ap_list);
+	raw_spin_lock_init(&irq->irq_lock);
+	irq->vcpu =3D NULL;
+	irq->target_vcpu =3D vcpu;
+	refcount_set(&irq->refcount, 0);
+
+	irq->intid =3D vgic_v5_make_ppi(i);
+
+	/* The only Edge architected PPI is the SW_PPI */
+	if (i =3D=3D GICV5_ARCH_PPI_SW_PPI)
+		irq->config =3D VGIC_CONFIG_EDGE;
+	else
+		irq->config =3D VGIC_CONFIG_LEVEL;
+
+	/* Register the GICv5-specific PPI ops */
+	vgic_v5_set_ppi_ops(irq);
+}
+
 static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 ty=
pe)
 {
 	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
+	u32 num_private_irqs;
 	int i;
=20
 	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
@@ -260,8 +315,13 @@ static int vgic_allocate_private_irqs_locked(struct kv=
m_vcpu *vcpu, u32 type)
 	if (vgic_cpu->private_irqs)
 		return 0;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		num_private_irqs =3D VGIC_V5_NR_PRIVATE_IRQS;
+	else
+		num_private_irqs =3D VGIC_NR_PRIVATE_IRQS;
+
 	vgic_cpu->private_irqs =3D kzalloc_objs(struct vgic_irq,
-					      VGIC_NR_PRIVATE_IRQS,
+					      num_private_irqs,
 					      GFP_KERNEL_ACCOUNT);
=20
 	if (!vgic_cpu->private_irqs)
@@ -271,34 +331,11 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
 	 */
-	for (i =3D 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
-		struct vgic_irq *irq =3D &vgic_cpu->private_irqs[i];
-
-		INIT_LIST_HEAD(&irq->ap_list);
-		raw_spin_lock_init(&irq->irq_lock);
-		irq->intid =3D i;
-		irq->vcpu =3D NULL;
-		irq->target_vcpu =3D vcpu;
-		refcount_set(&irq->refcount, 0);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled =3D 1;
-			irq->config =3D VGIC_CONFIG_EDGE;
-		} else {
-			/* PPIs */
-			irq->config =3D VGIC_CONFIG_LEVEL;
-		}
-
-		switch (type) {
-		case KVM_DEV_TYPE_ARM_VGIC_V3:
-			irq->group =3D 1;
-			irq->mpidr =3D kvm_vcpu_get_mpidr_aff(vcpu);
-			break;
-		case KVM_DEV_TYPE_ARM_VGIC_V2:
-			irq->group =3D 0;
-			irq->targets =3D BIT(vcpu->vcpu_id);
-			break;
-		}
+	for (i =3D 0; i < num_private_irqs; i++) {
+		if (vgic_is_v5(vcpu->kvm))
+			vgic_v5_allocate_private_irq(vcpu, i, type);
+		else
+			vgic_allocate_private_irq(vcpu, i, type);
 	}
=20
 	return 0;
--=20
2.34.1
