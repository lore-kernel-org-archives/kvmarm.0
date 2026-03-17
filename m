Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010009.outbound.protection.outlook.com [52.101.84.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C533B3C1E
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748262; cv=fail; b=o2GiQwcGdVCqJo7HcpLSJUuQDvB+CYGsFU5Gb5Lr4NKzomTBjuqHXyY4vcKo2W8wB8eMk+EHIxzEKQAvov5FfMX3WNDuIWQyCDnwHk//g3L/vOpjnRRg6Lct0LoDsSIX4WTbG+il/5Tbk+8sjkwjMupOEPQUAmgfaMlzpZHPVsc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748262; c=relaxed/simple;
	bh=iaZhYbyhFLYXbTMBOlo5R+e2mS//m4RsYZIniWWDfuo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RNFTazjHENbHld/psCU0JhDmztXO35O6X03XWY5EkG1Cwuhy7Z5dPr84kbYulAPv2nKuzek63OYF9HwTfFqOnCwbt67Bh7vGvPSwNQ+Lh3Y0k5qtQngZg8HSNtS2ZBKDjJ5jyBWKYb6MzrUIKnqzuOeQR/Kuym0ZwLAdV9ZGEdI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YU0AfNBi; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YU0AfNBi; arc=fail smtp.client-ip=52.101.84.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YU0AfNBi";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YU0AfNBi"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bcbHEWNVZQYKb5kBlKIQDlqCisGkXzmvN8WD05Yn01xC2rHS+LJHQN9PTMV4XVP41godizOFyCLLr40LRr8NoA7otJXdR2LzvWUw9sU/0t5ZHAa6O3bNXasbozdbuBGgJG2pUPzKeyUIzqbg3Bjqyc9iEjO/6RfqoSTa1jH8ZULdNrX+x/sdDZTBcU/69qQ+FHSVDEguO+Aj1dz0+2NE9U5dLVihpWpJ5UGMDAKx0aH+e64G72vJ65JAGA7g01GyPyOmwhLBXIln3wMgc+KTjOMN3jf01fwSjLm/FsD5hiWM4DI860zf8MpwKv7/HLGhGuG768GjWenfnMfF6zc2Fg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=a40ak0UUglvyNDfnnz1ixt3EE8xcV84i13wWV2QTyab5IwlBdEKV+6DTjhsURkN0iGfZSWBKW+ytDl7clQmSQrSgEyDvDDlbQnJaw9+3jSds+sQvF4wUxsF8fgThS5huAc55lBfpVwwCJPFCRrfF+VP6QuHPHwZYBBIfFgAQW0e1W+xyFYLIObEbtQkoMDjreczT95UCPsRb0C4fYA3OURb59dfAJsjWSAmT6N6Sf/FChvKWrQuhLqiUkksQwhvSFnd0M57EextigJBMm9v/fK3alAkwrF9YsZMP/LSsZNUPkaKzGWfRmHhASapZP6ELTquM2PbFP013IOK1Y6iQyA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=YU0AfNBiNfQaxAhg9UHfZl5JdC5ESY7RefO/A9QcIYwEzbz0tY0f7DsNsKCsZuQy2qyFHAZWhB2ccSscvMri/lhV0CFUOWRkdZMexX8EG/EEY0KDADwPPMxoinYN1qY75iu+of9qZH5bocdfpnPvtrHrxa9G+rX3Ft3CCau/R7g=
Received: from AS4P250CA0020.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5e3::9)
 by AS4PR08MB7503.eurprd08.prod.outlook.com (2603:10a6:20b:4e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:50:53 +0000
Received: from AM3PEPF0000A793.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e3:cafe::6f) by AS4P250CA0020.outlook.office365.com
 (2603:10a6:20b:5e3::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:50:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A793.mail.protection.outlook.com (10.167.16.122) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:50:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=de6MHUR7542vrYMun3OzGaVArk9YfP3TkSq893hE3LgWSw1GEZzGohfxgZi6u6nRx64y3ZxSqyzw1ni0iij9g/IojVPR7gKXzg7niUqX7io/i+R8TMcRkEv2UP5LOL5+8uYAljAfEjzLPswsZ0ukdcl8yFJE1/jeG++2FdVJsufdcSCjT+ZZAKbX0ErXOb84eHSHekWwDSUuWh/W1lrdnW3gKf6R3HE5sPsKMkzSdCOPQ5Hn4yRsrG3p4QYPY+U76g2Ch2AsX+IxccX3ntUQ0d9GCfGErir7YDxAKPdNfFUK6g/BrZbEqGiUWhgB0IvBD417KAGHIo/7j19Swu9GOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=FLob4AMaLfnFSTj+YcKTpsCKj4ywyGcVK3Q+7InADp1iTY+bVJuV93UMvQPmbex4mQUm2yF7Wfm9h7eMeowcDHG0rziSFVdtR3wdnpN0V9zhBykG6fpUYaHvrg8hv7VpdmydiUYlvM3QTVLuAh7JiBMXU/FAUb+0/dbKP3XyD2ud8wqE2x/4NyXTUfSWGL0juRth51U1wTaAzYkIdhNJU2YgOdqzB5cBa0xx1qvkret9skghRMbuHto8ZlDixpleCCCt6ePA5ta2Cip8FmKIQDy4qusfXkwVhA4C7ez+u3422D81F1YJfTLfvcZzRsu94pbj6T7PJE9cIToakVcUaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=YU0AfNBiNfQaxAhg9UHfZl5JdC5ESY7RefO/A9QcIYwEzbz0tY0f7DsNsKCsZuQy2qyFHAZWhB2ccSscvMri/lhV0CFUOWRkdZMexX8EG/EEY0KDADwPPMxoinYN1qY75iu+of9qZH5bocdfpnPvtrHrxa9G+rX3Ft3CCau/R7g=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB7674.eurprd08.prod.outlook.com (2603:10a6:10:37d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:49:48 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:49:48 +0000
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
Subject: [PATCH v6 38/39] KVM: arm64: selftests: Introduce a minimal GICv5 PPI
 selftest
Thread-Topic: [PATCH v6 38/39] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Thread-Index: AQHctgQoTYysLgd8ikm9S/XlzhH3qg==
Date: Tue, 17 Mar 2026 11:49:48 +0000
Message-ID: <20260317113949.2548118-39-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DB9PR08MB7674:EE_|AM3PEPF0000A793:EE_|AS4PR08MB7503:EE_
X-MS-Office365-Filtering-Correlation-Id: 01a8880f-3e7a-42d4-c3dc-08de841b719b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 K0VHLXvA8TRw62gVASPGqD4oqdCcUeHUZ6l4jYzUyULgM2zfsj6RpQQC/qZ0bz/UQBOGvcx9UtmzQTe2DiX2CeBhniyAxzc+zfx+Fo6DxwDLVwqZwa3fDPX/JW8VUCLriVa4NErlpGW4acO5I9lVC78txL6bIbzWpM4eGkpnXkvWCN2YwiwRMWEjm5ERns9h8ur56NgZo6BmurFJXgbgf80JlPAzB9kVelWQ4KZnDjHaqlQ/8MHUyZHxE05PxU78IFJMuu6LWyXDBX519B4v80ohJ6O9r6hw4fG1G6wt4ubc1fzVBcaQIyXKyuBd2hftedIiezRW2iHSkRUMk/yHo32ThYp0Dn7T9RYJSmT2n/ys8tteO/yziOA1o/2e+MbWvUgtYaDXKHDrbzT0AptLSSRDw+nD0BXKzuXub5GGYjb4dT+4FMAwBZerE1fkH/HRneBaTvCSgn7LKIUFPG8Gqh7staP0ixmEZDOG44MVWfo/OR8F5cDB2B6DqkvUdvu2FlFHo87o5KFg/MN4Avlg9cBjtKkSZn1/DxIAJA6ZwlqVrabk6yUbwqeNlAcmwJjivzh0ikIuxVj8AZBmp9ojQXjf2L4vNkFVw2xT8KdNLQtubcKTCQTNW1+wbsawUsavhp6geh5DzeYhMwCDhNQ/1EO79SsJkCJUn+g9S7A0/4K60EjNgwou6NJvyrccekcbj5if6g4Nt7+ufnJrYm9imMqc5IfEsO3Nr3yFV+WQnYzazWckKSq4zMZCn2LI+kk4gxuyiSNxmPFZUXhJtKpAzp27r/s473I+/sbXOsQxZWI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bTG/m4R/fBWMCcsMJ31hTwBKNKXXTvKbnqDyhGpXxSewiENkZNFKe1a8i5hFmUxckwyVR9lAKvg7/7LEY58TpXKhBpNGicQeUqly3oZcdjoCuYQOVyUy0srGjeDVVlyNyt4eE4CDn/HkuHK1hptHUYe+J+VThFIHP5GwdqNOhHDG7Na8vPVFYjg0LVR9+zluQPoUvdYD91uo4MqpkFN1uZMB+I8Bj5LqafDl7nyrhcXY5mLsxBpMmsr3KgqvxvpY/ZMnTgfuHAmpKQr5ShogSXGEhaYaUlJes+Iz51DmFSsfu/t3xYve+3CQysJ8ghOrlMaH0zKxN6fazdVP1qq4IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7674
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d5225e20-f7bb-4e77-e12f-08de841b4ad9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|376014|36860700016|35042699022|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kayMF2WRFl+CpbzFnDQG1IdDxVE+4DK+3u2CqiYW049edX9DVpafZz/SzyoFnqgRSUuUtHpYJHv4yt6+KJAdIfBTt5hdCCjBYQ3DUPG97NgD0xMKrxJohJl16r8YegtB/qXtJVMg55YcPF398UbjxeeVHO0BE578Ar5XNpwpP46/6hz0MmPhLCb6k/mtvTQgkkzvC/R9bnkq8URoCl4hWa1fh8X4ILP2ihq73pCIYHEwk8GjOkxNkl0A98/4yMQPNaSul3E82KzsnGEVUaJNPxFUNujteA83yR2NcrhpKwNL8mKs4xbctUHLirxSPitA4jM1IPA/y3xBuFlIZsxJYtIGd2hrUa0CZpKkMtj6O1nxWRrkkuDLzirgirB4a1pGiLZzqMCdV9XL5qR+7XZsV9Oq5mizzXe12kNWkyT7Z4AQwlrv0d6GfiFYrvo79s6fD6e3UdKFLkSHL6G0vaL+bKtN/zTB/O50EXTFitu2k+z9OKBKtNbUA4vzcpS0Nk+pl1dUCnwQFerrcY8kdPIVGRWXeRnWIOQa8P6clOHqQZXVaNYJY0UlaU660Xc1zOikzMwfhV6vLaYaGBo6fDMcHgEeyctZ7ynTj86QJCgOZzJP/Jre0Lq/hLonuwD50rI792veoYgSRk6LIXpcpPfLhirAvIBqeMgwept1CMXj+34L+xd1tcF/+n7KwLHlD1dC1yqQOc1YomWaH22JU3mRHClpOUrvr5V583iX1x941QKVaHuZHXM3tE/tFwGZCyMfCCoK6/PZja/430xenSoCow==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(376014)(36860700016)(35042699022)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DM5nmRVs1MIrCoiN0hStydPqz7SoIniLT3NBnWoHVfqkjKC0XcS9cgj2wU+bIxIBWjRGvPauiBdkMDEK+3wXEQdl9y50vtE1VOzYEMSlJefIC2wriWWR1G4TSwhz5jmp+pn3KNOtomKLJEgaNpYwxhpqZCGaW8U+TaZGcRSP9aGod9tay1zT1b7PsH2JqCxO0YKWVTtAe3CZ3gXEs09/WCnsBVXC2CjGZU6kJWobtNpwzxCkP5L4pZmmdrlBXpFIUbsBhkSiVjy+2aPvQNA/uu+GMUEhuC6H2sZJso5nt9WEJTfHnhJq8NCreE6KAaBO/9a6kfqkR8MfCIv6oDUvZuQH8SK3GpB15vMouyI4Fvljp07ARDJWVVcnllTEi3kp9gQVdDTTHHHwSUUPXX7Gjkt4d49Jbeo3PioHv0eWxTXf8yZRiyu77IPIRMNlOiSu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:50:53.7037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a8880f-3e7a-42d4-c3dc-08de841b719b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7503

This basic selftest creates a vgic_v5 device (if supported), and tests
that one of the PPI interrupts works as expected with a basic
single-vCPU guest.

Upon starting, the guest enables interrupts. That means that it is
initialising all PPIs to have reasonable priorities, but marking them
as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
to receive interrupts. The architected SW_PPI (64) is enabled and
KVM_IRQ_LINE ioctl is used to inject the state into the guest.

The guest's interrupt handler has an explicit WFI in order to ensure
that the guest skips WFI when there are pending and enabled PPI
interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 228 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 150 ++++++++++++
 3 files changed, 379 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index dc68371f76a33..98282acd90407 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -177,6 +177,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_init
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 +=3D arm64/idreg-idst
diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
new file mode 100644
index 0000000000000..3ce6cf37a629f
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <sys/syscall.h>
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+
+#include <arm64/gic_v5.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vgic.h"
+
+#define NR_VCPUS		1
+
+struct vm_gic {
+	struct kvm_vm *vm;
+	int gic_fd;
+	uint32_t gic_dev_type;
+};
+
+static uint64_t max_phys_size;
+
+#define GUEST_CMD_IRQ_CDIA	10
+#define GUEST_CMD_IRQ_DIEOI	11
+#define GUEST_CMD_IS_AWAKE	12
+#define GUEST_CMD_IS_READY	13
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (++count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable the SW_PPI (3) */
+	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	while (1);
+}
+
+
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+static void test_vgic_v5_ppis(uint32_t gic_dev_type)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct ucall uc;
+	u64 user_ppis[2];
+	struct vm_gic v;
+	int ret, i;
+
+	v.gic_dev_type =3D gic_dev_type;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
+
+	vm_init_descriptor_tables(v.vm);
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read out the PPIs that user space is allowed to drive. */
+	kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, &user_ppis);
+
+	/* We should always be able to drive the SW_PPI. */
+	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
+		"SW_PPI is not drivable by userspace");
+
+	while (1) {
+		ret =3D run_vcpu(vcpus[0]);
+
+		switch (get_ucall(vcpus[0], &uc)) {
+		case UCALL_SYNC:
+			/*
+			 * The guest is ready for the next level change. Set
+			 * high if ready, and lower if it has been consumed.
+			 */
+			if (uc.args[1] =3D=3D GUEST_CMD_IS_READY ||
+			    uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI) {
+				u64 irq;
+				bool level =3D uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI ? 0 : 1;
+
+				irq =3D FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, 3);
+				irq |=3D KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
+
+				_kvm_irq_line(v.vm, irq, level);
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
+				pr_info("Guest skipping WFI due to pending IRQ\n");
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
+				pr_info("Guest acknowledged IRQ\n");
+			}
+
+			continue;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	TEST_ASSERT(ret =3D=3D 0, "Failed to test GICv5 PPIs");
+
+	vm_gic_destroy(&v);
+}
+
+/*
+ * Returns 0 if it's possible to create GIC device of a given type (V5).
+ */
+int test_kvm_device(uint32_t gic_dev_type)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	int ret;
+
+	v.vm =3D vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+
+	/* try to create a non existing KVM device */
+	ret =3D __kvm_test_create_device(v.vm, 0);
+	TEST_ASSERT(ret && errno =3D=3D ENODEV, "unsupported device");
+
+	/* trial mode */
+	ret =3D __kvm_test_create_device(v.vm, gic_dev_type);
+	if (ret)
+		return ret;
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	ret =3D __kvm_create_device(v.vm, gic_dev_type);
+	TEST_ASSERT(ret < 0 && errno =3D=3D EEXIST, "create GIC device twice");
+
+	vm_gic_destroy(&v);
+
+	return 0;
+}
+
+void run_tests(uint32_t gic_dev_type)
+{
+	pr_info("Test VGICv5 PPIs\n");
+	test_vgic_v5_ppis(gic_dev_type);
+}
+
+int main(int ac, char **av)
+{
+	int ret;
+	int pa_bits;
+
+	test_disable_default_vgic();
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
+
+	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
+		exit(KSFT_SKIP);
+	}
+
+	pr_info("Running VGIC_V5 tests.\n");
+	run_tests(KVM_DEV_TYPE_ARM_VGIC_V5);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
new file mode 100644
index 0000000000000..eb523d9277cf1
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SELFTESTS_GIC_V5_H
+#define __SELFTESTS_GIC_V5_H
+
+#include <asm/barrier.h>
+#include <asm/sysreg.h>
+
+#include <linux/bitfield.h>
+
+#include "processor.h"
+
+/*
+ * Definitions for GICv5 instructions for the Current Domain
+ */
+#define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
+#define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
+#define GICV5_OP_GIC_CDDIS		sys_insn(1, 0, 12, 1, 0)
+#define GICV5_OP_GIC_CDHM		sys_insn(1, 0, 12, 2, 1)
+#define GICV5_OP_GIC_CDEN		sys_insn(1, 0, 12, 1, 1)
+#define GICV5_OP_GIC_CDEOI		sys_insn(1, 0, 12, 1, 7)
+#define GICV5_OP_GIC_CDPEND		sys_insn(1, 0, 12, 1, 4)
+#define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
+#define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
+#define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
+
+/* Definitions for GIC CDAFF */
+#define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_CDAFF_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDAFF_IRM_MASK	BIT_ULL(28)
+#define GICV5_GIC_CDAFF_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDI */
+#define GICV5_GIC_CDDI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDIS */
+#define GICV5_GIC_CDDIS_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDIS_TYPE(r)		FIELD_GET(GICV5_GIC_CDDIS_TYPE_MASK, r)
+#define GICV5_GIC_CDDIS_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GIC_CDDIS_ID(r)		FIELD_GET(GICV5_GIC_CDDIS_ID_MASK, r)
+
+/* Definitions for GIC CDEN */
+#define GICV5_GIC_CDEN_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDEN_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDHM */
+#define GICV5_GIC_CDHM_HM_MASK		BIT_ULL(32)
+#define GICV5_GIC_CDHM_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDHM_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPEND */
+#define GICV5_GIC_CDPEND_PENDING_MASK	BIT_ULL(32)
+#define GICV5_GIC_CDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPRI */
+#define GICV5_GIC_CDPRI_PRIORITY_MASK	GENMASK_ULL(39, 35)
+#define GICV5_GIC_CDPRI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPRI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDRCFG */
+#define GICV5_GIC_CDRCFG_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDRCFG_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GICR CDIA */
+#define GICV5_GICR_CDIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDIA_VALID(r)	FIELD_GET(GICV5_GICR_CDIA_VALID_MASK, r)
+#define GICV5_GICR_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDIA_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GICR_CDIA_INTID		GENMASK_ULL(31, 0)
+
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
+#define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
+#define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
+
+#define __GIC_BARRIER_INSN(op0, op1, CRn, CRm, op2, Rt)			\
+	__emit_inst(0xd5000000					|	\
+		    sys_insn((op0), (op1), (CRn), (CRm), (op2))	|	\
+		    ((Rt) & 0x1f))
+
+#define GSB_SYS_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 0, 31)
+#define GSB_ACK_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 1, 31)
+
+#define gsb_ack()	asm volatile(GSB_ACK_BARRIER_INSN : : : "memory")
+#define gsb_sys()	asm volatile(GSB_SYS_BARRIER_INSN : : : "memory")
+
+#define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
+
+#define GICV5_IRQ_DEFAULT_PRI 0b10000
+
+#define GICV5_ARCH_PPI_SW_PPI		0x3
+
+void gicv5_ppi_priority_init(void)
+{
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR0=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR2=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR3=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR4=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR5=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR6=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR7=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR8=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR9=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
0_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
1_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
2_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
3_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
4_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
5_EL1);
+
+	/*
+	 * Context syncronization required to make sure system register writes
+	 * effects are synchronised.
+	 */
+	isb();
+}
+
+void gicv5_cpu_disable_interrupts(void)
+{
+	u64 cr0;
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+void gicv5_cpu_enable_interrupts(void)
+{
+	u64 cr0, pcr;
+
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);
+
+	gicv5_ppi_priority_init();
+
+	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_DEFAULT_PRI);
+	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+#endif
--=20
2.34.1
