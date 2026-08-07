Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013041.outbound.protection.outlook.com [40.107.162.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9359B46EC7C
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101324; cv=fail; b=Yi0flE6aE6kS1AC425fxebjhmDvcaosGo8IKt5ObAob3ESLSvIjltjYDN3HKgcOaMPP/dcA/GIHssghwE2Bd9ybO+yNhIi1Qg7h6EIvUSNwDkzxIyC1HegJ/6GJqn1LklneIp5hn36Q5kKcge7Ozp7Vgfz1NxPx6XLjzZ/Pv8uA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101324; c=relaxed/simple;
	bh=YdGr2NGMN1S8B1KHTIr69MklJqpugk9XD3MvYG56jfw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=irE+pu78n863eYgYo7CKYfcA/y6o3xgr/MUxtqAK5DbRTdOSLkQ3a4a046UCobrgIpXKTmcBXApRt/9gSQkBTLych8UdBxIuktrfblOoXtmVve0BNw3DXivJIHd58PSq4cU/fDvFJLYH8/R2GY6MOD6xFagYHoSdF0xbc1Jcz1c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DjCLDV0s; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DjCLDV0s; arc=fail smtp.client-ip=40.107.162.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DjCLDV0s";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DjCLDV0s"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=X56dCGLuOnXey5tlBpff59K4Q5hQRdS8pSMN4e9vcdhnlZoGgQf5WBRunbaj0vxwTVzIuGY3htiTEDy+v7rb+h+WYh50UOzS7ELxyeYUiB1Vkb6pER3dzsKRq9SDAsvb7bnolOdkeJ8hqiu/ECzJOZtPS8Qy/K9uJKRPF7jkoq6LgUrBHJRCMPRGrHF5g8GwnG4sJve76DLzjg/x4RZHP5mIQTZOgGga6KcOfjDNgyxvUkXtSVtU+D0AZ8+OEO+uszqydcfqXw1p9KikoMEQ4ef/6D+d4D+vjU2EXOgYiDn1TOZyp492Zkz3JeIJCZR9TWB0gxs/NOKnD4tHpIkdpA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=yoX1XmprPudkCQqTCKQI77WXl/9RYAx18bf7gprPqDQGzcMkV/zQrUuoCskJL26LWRT1ohANOIupZM0Wgbg/+ds3T/ePzl4u7NbtrwIh5AfBOo4LU3iRD3VY0I3YTM92VVqmPznwhwJRmAoIEVWQFe18Lvbnqa5wUYjDddfG3qbQYbu0NtgNfIGEE9swH26hXu7YPDP3qmfttHMEYDA8T1TpizKlACw0U1Xc8jh1mrAFSa5nSkqR13q8Z1D9agCgyyuhuX6bf6Ddk7aZRF0N2fPq3teO/RvkVaSP4UdjqNw2sdxHOFgV2euqlMmPavOUOD2Tmwxi899R9JkMJUXgKw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=DjCLDV0sDOicGrThVl5VMdH8+ZlJ+bI3x7YriCQ7QKyWRPsBfUlo6nD6OUV/oYK5+4EAqDK089+Zzf5IvPaPWgt3/qVvIpG9acYDd5P3w9usoHgppJHzSATKPEjcsZejyAWBw2P4SzK56gfj0rYD58dg2pPtS4t0cTM6c75osLI=
Received: from AS9PR06CA0727.eurprd06.prod.outlook.com (2603:10a6:20b:487::9)
 by GV1PR08MB10752.eurprd08.prod.outlook.com (2603:10a6:150:15e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:15:11 +0000
Received: from AMS0EPF000001AD.eurprd05.prod.outlook.com
 (2603:10a6:20b:487:cafe::2d) by AS9PR06CA0727.outlook.office365.com
 (2603:10a6:20b:487::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:15:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AD.mail.protection.outlook.com (10.167.16.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:15:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NwGZsIXTrk71e/+qSE42YE4y/TDCppd2VeJfQAYco9zxi/Y7mrsAesycafCPEG3YRoLDa0CrmgGfrA4jSgiURcT279Ylj3gwlzrtjSJGlXa+yJokxDRvqNaISESVn7f9FxAziA7jQl5vhHULxWmOFp2H1mzsSbcqegThpVfy5+lrcIeTIPY61UX/vTpkRhApl1gfc6PFRgGi4CweT7HW4G3qoGhQZ4OoVrTGBl+eJWZ50bbEFKeRNs7vyk6Ns6TuaP0Yqvjr1C/RNlDYRbKG9YLspeBxmHhjGvYm/HJQsmz0StkPN0I3FQEMYdADGlSidCQseHJkxZcpTIfPKcv4NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=QJxxmNozRrwx44GGj2G4qSH3gz8QBkl+8lbLhx64OjPzlxbgtWhdjKKQ5KU6t7PrhWvjNal96jhXKjmMJt2EzbfGTMGlK7RSveHGa43r36MDfW0VnMOySHulwP87IqPm4UkhsFzwbcSAPpQDEXpGiktyCmmEgWeiYqh8KnVNbxHQz/b48DY96w4bq40EJm4gXUX4WFviLS9mZGQT2nShLMvNBSfyenAy7zEzRcKS0k01jNKeS1j6OHqoDJ8JgOyqDzA2rLzqt2pZulCMnunbgWW90FG8ETzTnW66mk4vz6dR2RWcxY+ZithFlfZ3xHsngTc2xBRdSErGxC9c+unK2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RfLzFwP4PpBHoZM1v8LwtAW7nl981OoTdtKXWiw+b0=;
 b=DjCLDV0sDOicGrThVl5VMdH8+ZlJ+bI3x7YriCQ7QKyWRPsBfUlo6nD6OUV/oYK5+4EAqDK089+Zzf5IvPaPWgt3/qVvIpG9acYDd5P3w9usoHgppJHzSATKPEjcsZejyAWBw2P4SzK56gfj0rYD58dg2pPtS4t0cTM6c75osLI=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB11562.eurprd08.prod.outlook.com (2603:10a6:150:2d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:14:38 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:14:38 +0000
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
Subject: [PATCH v5 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH v5 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHdJl3vkq+RMpA+RkGrCzQaxX6g2Q==
Date: Fri, 7 Aug 2026 11:14:37 +0000
Message-ID: <20260807111159.429128-5-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB11562:EE_|AMS0EPF000001AD:EE_|GV1PR08MB10752:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ae577af-55d8-4780-819f-08def475257e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|11063799006|56012099006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 qkjDOrxcl/VuOE/z+wnVvcxbdhstGH44XxplqxGqitHkAEG5ychoPnfFS8H7sXfGAZR/+ld+Q8rLwPALjkpRTIEXxTUq5IFio6nkuVpWhY1eojQFo3EyG4yOpsfcXilXMYlIIVsVH3nqDZkHrLq5EXkr1PULbLcO579XcuidMhXTOetfqwKzpr5biP9KkN4421SHoZcM5bNiFsgsG5/aUSmdDu6LmtoARAaY9eQ54Oz/lirdMF4SYcXc9xZSsjSuTKYu3OuWHhrI2iIdkRdnXh38VBTimd0+BJClI5GPN1/5LXDWddht3wk9GjzWg3M2G/nD0gOOSRrN50jWOLJO2HLvHmdT55yAd3VzjA+MBwbT0+j3hJ5jBDnwepNUDD06lfByXLwavxg6ruabHfvRl+ApCD7EWp/y05RpDE91WSHo2MTNkzr60w9BLDqIhCDuA6ZGD+9GIQ41wOZ2zL6CgMud9hIQZusY59w+MS17Hx3HyAO7w+v6gDLYfe+4G9bs0M/LKhcHSvtahE1NEzmauwLJXFZcuYzVZpr5Oww/N7RrxkXFLdkwaTLBhZz3yKfQ4Fe1EmQaBQHTR29tUk4I2Iw3hl0xShjLmZpAL1xp9EUvjS9s/7k2kt7Gp7lDgciQf9jDGqeFP3H6ygnAfnAO+xtxWoXbAH+9l4a/GYBKd3YmZ0x8FKhrQEbQlueitfcsiegj1z2RAYECFg8dSSP4WH+LwX4EZ6cz7NXCa/Ubeg8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 UIybS3Z9FKw0aOGWnsRTA1tNfVPjseCOC2/GF2+HKNLF1KOQhf/NVeU1cW3d2EY9627gg8OQcITR658T18o19ml1+rj5Ar32JpDIAm57KWWVDTEEUAKiHgzoAL/GItv1FfSToNQ9oByvURIivKgvRujOYUFfuafUYLpsK3tEbtrIG/sfpPpl5B7HYqIDgFCtKv/jwP/7SDNoOZVbbHXZf9Z88zFu0jZLNaa3omz9ECKVo7w4auPDumj7xQsnBJTElHdzs6q4sbJvFT+a+QTKl8YQY6CdFsUVMDF4iRm2picNMlEYxmVK2nZNJR+aTPcKZzz86ESW57kHLtfXTwFKfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11562
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	76daa92c-3c61-4762-0b2f-08def47511ce
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|35042699022|14060799003|36860700016|1800799024|82310400026|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dFl6J3ZBwWw1pTwz6Rd+Kocn4H7Dbducgbf3O+5T724n7oSrmaJCJ9eXTmV2NXGIBB0IXaRw/hmp2jpMZKp3yJVVC4+XvrGWHlTMzPTRR8GGY5m55BUjPaQIMKvZg8iJ65lYjGUG3YVGX1/KmRIMFrS0v/fndeC2UAKLjrqzyiak4VidF5lkYqgNfjUrLw1GiCH4Gx6GLc6yUsZ7Rk/jJfr+mxCiQ7rnOocxgtDCjBO3GyAOANiWGd5zNuWMmHMIUWRmm9uvTnkfmTSD1GWmQZJcu4AOHWJo2r08NU/JLmDddUgpODPifthWvEOwzjF+FOFxoOiUiEcRb2ePv/k/4Bch7d0TWdZfHZH/PcS+icc2Wm97yMIm6TzvF30ir7Dbtrisav0HovonGiRmU1H79VBPNNtjxeCUXNlMvKjv3WHJmeUoi0eo6DeJcyvC6ygfvw8Rxai/T4Tssz8iv42hkB/azxoqEGtqFTziZHioIoSRO8uBlLc/iZQyVhVcmvAeySGyT5bUfSjvQylOmOeNxLY8j+QQEl2f+Nq4LrNQpH9GgSpTCBjIMxx7anylNYJuu65JU0+JXGt/AwFGFv+i3JwVneWLwEIZxr69AD0a4UZ1BdxUqXJTdn8MFnNYRz96XJgyEOlwF9i728/yOiq7yiw4me3KT8kxivN3GR2cSmtjM2e7PajuyjnFKD4kuSWM7sXPev/leuUZ9kd9fkBYKg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i9hlXIbBx2sUkYf1XFKcDugt5MuTZc3+JQwZKoUAJtDfbWgCB0DpFjfpN0Mun+kFznF2+0YmWRSCgGmkzSsHKl1uVmsPJ1pUdyAI3ZDCFaZlyAekSmPC3TIeplkgMfx4xEycm8S+yrSVBCCHblUrPkUvGYUIxO1ELfw3knQ8NIqTW9h8yagVJJEttCVvUSdCVbyKlDFX6VFCsIzESRe0hWb1fbwCuD0Wjaa568STRjuI+gxuytRCLrTwv8ev1v8CBQ6GhDD6Dr0Zj7zn71QsD9vHVj5g6TUBM+Gkgu1nxYrKFyel15JLnF1wibrhQoXYg9H5rfhstfB/FgYRqJNvgq2ncX4l3YjPywVD7ly9P3kChK0BLARblT3ZAgircT16BeSCJ35Bc8BRNp+2n1kCGF4GW+9YzkFM7jNQzNyX69bLkqpjzAK7ylCZzI0uuN+0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:15:10.9076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae577af-55d8-4780-819f-08def475257e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10752

Complete the set of defined IRS MMIO registers in the GICv5 header
file. Up until now, the set of defined IRS MMIO registers has been
driven by code requirements. However, in order to properly emulate the
IRS MMIO interface in KVM, the full set of IRS MMIO registers needs to
be added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/linux/irqchip/arm-gic-v5.h | 239 +++++++++++++++++++++++++++--
 1 file changed, 230 insertions(+), 9 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 681c5c51207d6..83cfcd056b250 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -62,20 +62,34 @@
 #define GICV5_OUTER_SHARE		0b10
 #define GICV5_INNER_SHARE		0b11
=20
+#define GICV5_AIDR_COMPONENT_IRS	0b00
+#define GICV5_AIDR_COMPONENT_ITS	0b01
+#define GICV5_AIDR_COMPONENT_IWB	0b10
+
+#define GICV5_AIDR_ARCH_MAJ_REV_V5	0
+#define GICV5_AIDR_ARCH_MIN_REV_V0	0
+
 /*
  * IRS registers and tables structures
  */
 #define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
 #define GICV5_IRS_IDR5			0x0014
 #define GICV5_IRS_IDR6			0x0018
 #define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
 #define GICV5_IRS_CR0			0x0080
 #define GICV5_IRS_CR1			0x0084
 #define GICV5_IRS_SYNCR			0x00c0
 #define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
 #define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
 #define GICV5_IRS_SPI_CFGR		0x0114
 #define GICV5_IRS_SPI_STATUSR		0x0118
 #define GICV5_IRS_PE_SELR		0x0140
@@ -85,11 +99,51 @@
 #define GICV5_IRS_IST_CFGR		0x0190
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
-
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_IRSID		GENMASK(31, 16)
+#define GICV5_IRS_IDR0_SWE		BIT(12)
+#define GICV5_IRS_IDR0_MPAM		BIT(11)
+#define GICV5_IRS_IDR0_MEC		BIT(10)
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_VIRT_ONE_N	BIT(8)
+#define GICV5_IRS_IDR0_ONE_N		BIT(7)
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
+#define GICV5_IRS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+#define GICV5_IRS_IDR0_INT_DOM_NON_SECURE	0b01
+#define GICV5_IRS_IDR0_INT_DOM_EL3		0b10
+#define GICV5_IRS_IDR0_INT_DOM_REALM		0b11
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
+#define GICV5_IRS_IDR1_PE_CNT		GENMASK(15, 0)
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS_1BITS	0b000
 #define GICV5_IRS_IDR1_PRIORITY_BITS_2BITS	0b001
@@ -105,13 +159,30 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+
+#define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
+#define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
+#define GICV5_IRS_IDR3_VMD_SZ		GENMASK(4, 1)
+#define GICV5_IRS_IDR3_VMD		BIT(0)
+
+#define GICV5_IRS_IDR4_VPE_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR4_VPED_SZ		GENMASK(5, 0)
+
 #define GICV5_IRS_IDR5_SPI_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR6_SPI_IRS_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR7_SPI_BASE		GENMASK(23, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IIDR_PRODUCT_ID	GENMASK(31, 20)
+#define GICV5_IRS_IIDR_VARIANT		GENMASK(19, 16)
+#define GICV5_IRS_IIDR_REVISION		GENMASK(15, 12)
+#define GICV5_IRS_IIDR_IMPLEMENTER	GENMASK(11, 0)
+
+#define GICV5_IRS_AIDR_COMPONENT	GENMASK(11, 8)
+#define GICV5_IRS_AIDR_ARCHMAJORREV	GENMASK(7, 4)
+#define GICV5_IRS_AIDR_ARCHMINORREV	GENMASK(3, 0)
=20
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
@@ -134,21 +205,39 @@
=20
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
=20
-#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
-#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_VMR_VIRT		BIT_ULL(63)
+#define GICV5_IRS_SPI_VMR_VM_ID		GENMASK_ULL(15, 0)
=20
 #define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
=20
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN	GENMASK(1, 0)
+
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_SECURE	0b00
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE	0b01
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_EL3	0b10
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_REALM	0b11
+
+#define GICV5_IRS_SPI_RESAMPLER_ID	GENMASK(23, 0)
+
 #define GICV5_IRS_SPI_CFGR_TM		BIT(0)
=20
+#define GICV5_IRS_SPI_CFGR_TM_EDGE	0b0
+#define GICV5_IRS_SPI_CFGR_TM_LEVEL	0b1
+
+#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_PE_SELR_IAFFID	GENMASK(15, 0)
=20
+#define GICV5_IRS_PE_STATUSR_ONLINE	BIT(2)
 #define GICV5_IRS_PE_STATUSR_V		BIT(1)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_PE_CR0_DPS		BIT(0)
=20
-#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
=20
 #define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
 #define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
@@ -166,15 +255,111 @@
 #define GICV5_IRS_IST_CFGR_L2SZ_16K	0b01
 #define GICV5_IRS_IST_CFGR_L2SZ_64K	0b10
=20
-#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
-#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
+#define GICV5_IRS_VMT_BASER_ADDR	GENMASK_ULL(55, 3)
+#define GICV5_IRS_VMT_BASER_ADDR_SHIFT	3ULL
+#define GICV5_IRS_VMT_BASER_VALID	BIT_ULL(0)
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL	0b1
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_LINEAR	0b0
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_VMT_CFGR_VM_ID_BITS	GENMASK(4, 0)
+
+#define GICV5_IRS_VMT_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VPE_SELR_S		BIT_ULL(63)
+#define GICV5_IRS_VPE_SELR_VPE_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VPE_SELR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VPE_DBR_DBV		BIT_ULL(63)
+#define GICV5_IRS_VPE_DBR_REQ_DB	BIT_ULL(62)
+#define GICV5_IRS_VPE_DBR_DBPM		GENMASK_ULL(36, 32)
+#define GICV5_IRS_VPE_DBR_INTID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_HPPIR_HPPIV	BIT_ULL(32)
+#define GICV5_IRS_VPE_HPPIR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VPE_HPPIR_ID		GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_CR0_DPS		BIT(0)
+
+#define GICV5_IRS_VPE_STATUSR_V		BIT(1)
+#define GICV5_IRS_VPE_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VM_DBR_EN		BIT_ULL(63)
+#define GICV5_IRS_VM_DBR_VPE_ID		GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VM_SELR_VM_ID		GENMASK(15, 0)
+
+#define GICV5_IRS_VM_STATUSR_V		BIT(1)
+#define GICV5_IRS_VM_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VMR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VMR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VMR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VISTR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VISTR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
+
+#define GICV5_IRS_VMAP_L2_VISTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_L2_VISTR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VMAP_L2_VISTR_ID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VMAP_VPER_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SAVE_VMR_VM_ID	GENMASK_ULL(15, 0)
+#define GICV5_IRS_SAVE_VMR_Q		BIT_ULL(62)
+#define GICV5_IRS_SAVE_VMR_S		BIT_ULL(63)
+
+#define GICV5_IRS_SAVE_VM_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SAVE_VM_STATUSR_Q	BIT(1)
+
+#define GICV5_IRS_MEC_IDR_MECIDSIZE	GENMASK(3, 0)
+
+#define GICV5_IRS_MEC_MECID_R_MECID	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_IDR_HAS_MPAM_SP	BIT(24)
+#define GICV5_IRS_MPAM_IDR_PMG_MAX	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_IDR_PARTID_MAX	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_PARTID_R_IDLE	BIT(31)
+#define GICV5_IRS_MPAM_PARTID_R_MPAM_SP	GENMASK(25, 24)
+#define GICV5_IRS_MPAM_PARTID_R_PMG	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_PARTID_R_PARTID	GENMASK(15, 0)
+
+#define GICV5_IRS_SWERR_STATUSR_IMP_EC	GENMASK_ULL(31, 24)
+#define GICV5_IRS_SWERR_STATUSR_EC	GENMASK_ULL(23, 16)
+#define GICV5_IRS_SWERR_STATUSR_OF	BIT_ULL(3)
+#define GICV5_IRS_SWERR_STATUSR_S1V	BIT_ULL(2)
+#define GICV5_IRS_SWERR_STATUSR_S0V	BIT_ULL(1)
+#define GICV5_IRS_SWERR_STATUSR_V	BIT_ULL(0)
+
+#define GICV5_IRS_SWERR_SYNDROMER0_VIRTUAL	BIT_ULL(63)
+#define GICV5_IRS_SWERR_SYNDROMER0_TYPE		GENMASK_ULL(62, 60)
+#define GICV5_IRS_SWERR_SYNDROMER0_ID		GENMASK_ULL(55, 32)
+#define GICV5_IRS_SWERR_SYNDROMER0_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SWERR_SYNDROMER1_ADDR	GENMASK_ULL(55, 3)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
+#define GICV5_IRS_ISTL1E_SIZE		8UL
=20
 #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
=20
+#define GICV5_IRS_SETLPIR		0x0000
+#define GICV5_IRS_SETLPIR_ID		GENMASK(23, 0)
+
 /*
  * ITS registers and tables structures
  */
@@ -296,6 +481,42 @@
 #define GICV5_GSI_IWB_FRAME_ID			GENMASK(28, 16)
 #define GICV5_GSI_IWB_WIRE			GENMASK(15, 0)
=20
+/*
+ * CoreSight identification registers - ordered by increasing offset.
+ */
+#define GICV5_CORESIGHT_DEVARCH		0xffbc
+#define GICV5_CORESIGHT_PIDR4		0xffd0
+#define GICV5_CORESIGHT_PIDR5		0xffd4
+#define GICV5_CORESIGHT_PIDR6		0xffd8
+#define GICV5_CORESIGHT_PIDR7		0xffdc
+#define GICV5_CORESIGHT_PIDR0		0xffe0
+#define GICV5_CORESIGHT_PIDR1		0xffe4
+#define GICV5_CORESIGHT_PIDR2		0xffe8
+#define GICV5_CORESIGHT_PIDR3		0xffec
+#define GICV5_CORESIGHT_CIDR0		0xfff0
+#define GICV5_CORESIGHT_CIDR1		0xfff4
+#define GICV5_CORESIGHT_CIDR2		0xfff8
+#define GICV5_CORESIGHT_CIDR3		0xfffc
+
+#define GICV5_CORESIGHT_DEVARCH_VAL			\
+	(FIELD_PREP(GENMASK(31, 21), 0x23b) |		\
+	 BIT(20) |					\
+	 0x5a19)
+
+#define GICV5_CORESIGHT_PIDR4_JEP106_CONT	0x04
+#define GICV5_CORESIGHT_PIDR5_RES0		0x00
+#define GICV5_CORESIGHT_PIDR6_RES0		0x00
+#define GICV5_CORESIGHT_PIDR7_RES0		0x00
+#define GICV5_CORESIGHT_PIDR0_PART_0		0x4b
+#define GICV5_CORESIGHT_PIDR1_DES_0_PART_1	0xb0
+#define GICV5_CORESIGHT_PIDR2_DES_1		0x0b
+#define GICV5_CORESIGHT_PIDR3_REVAND_CMOD	0x00
+
+#define GICV5_CORESIGHT_CIDR0_VAL		0x0d
+#define GICV5_CORESIGHT_CIDR1_VAL		0xf0
+#define GICV5_CORESIGHT_CIDR2_VAL		0x05
+#define GICV5_CORESIGHT_CIDR3_VAL		0xb1
+
 /*
  * Global Data structures and functions
  */
--=20
2.34.1
