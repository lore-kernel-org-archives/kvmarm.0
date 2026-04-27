Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013029.outbound.protection.outlook.com [40.107.162.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15B335C1B0
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306888; cv=fail; b=T6fMu52sQ2Bs+yyzo0UHbQ3Jkulf6kVf98+ouKIbd8DnR5yJ6PffuzzF5oZXsOcgYiXwx/yr40g06oH13l39QkW+zJRj8lL0ENGkg494CyI3sLTMOZSEvsBggqyecF12bzyJO8lUtawlZCaFjlOlfssL7ZO0Hf68DxT0BZ0/Z1Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306888; c=relaxed/simple;
	bh=NpG9AQNFVzEVPjH7TunU3WlzurJXRQoIyAOINvq0b8g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dUJIDyWvXOXSKJzf3mCYnX2ONay8noG0YN8Ts9vG3vDG2VNRxzWPhJmf5XdZ30qmj5t/ks0D3Z6Lm6LxkvmXwizDLeWhGujBydKGxLjOY1gE1t8Sxz0/+TIX0wn5oOcntNEcr8eS2fZMZjgBHc5ixKP66Cb5gvVMHqGleKvrFiY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PsQZjREY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PsQZjREY; arc=fail smtp.client-ip=40.107.162.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PsQZjREY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PsQZjREY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=y3OJkMfutD025swIo6IG4KWh4MRvMYtK/09bf9u4YEw8ETiMDodh213wOp+8RmXCcCNSLbwuedVtH3fiu3/lXO8AsCOp6uUBlIJlZnJaUqFrcymTZiX8fzV+eQqXTREY8e5La8fwiUMcJLI1kIP4zE/6LhfNsa+bz+N+LcBcdzSystFGlefjdLsKtZVBZ8IYzUZjeb4d/QResFV9nz7pnAZUJtZneROpYhq15ZgDtyWmbIa8YZRtKFbDKJfMWAey1T6RM9EI+XALEN34lgjz7QLp8zrfLFhdhabVirm/eWDrXE6WBixDW86xjI+U65n5rNrr3V+MAMnQ/xtzE50I0w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NyzJWaBRD2RYhP6Oq0T+saJYh2ZT08BG2lJxXqejgZw=;
 b=rqZ0GoSSHsGQ8WrmB8dgwmTmPbPWH0roFly+H9vnIYIuIDT2hkmXM7BKf9YNMGv+UgF7lcEfI5X2pZqlDLJT5s55Y8OznxHPXa6m4xstQKk/yaY6UOkkohJTZOimu5vTqTGCpv/VGj5tPlNiGK/dLzaRkof0NM03r+JfG3GfaD00EqiY9XCWAsxY5x/oNwdnDFT9pOKqvguIIEw1rw1mnmMoyoqZP5PvNEtVwSGgTY9Bky3bxqAJhlJWp053F6yZH2sqsDYEb6ipfiV5VWcs3YsG/gYCHgXLShDCFWXGaYdqRnsOKiYdUhFekKJKLUFk63IsjvFfGNaiSs3d+MkRew==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyzJWaBRD2RYhP6Oq0T+saJYh2ZT08BG2lJxXqejgZw=;
 b=PsQZjREYpX0hNtSyp1M191Ytkk2k5L+OUcZmSAO850h3AWX+j0QHRw2ZImwxZdfxtqO+pV1B2U/AdXqtBjsT0/d0sIlCjxwgih+/i6PtGKeUDDcMzCN7gj3J+3+zZeqTxBp05grB6syrXbiCMU29AmsaREaKAhxYxXqu2h3REkU=
Received: from AM6PR04CA0016.eurprd04.prod.outlook.com (2603:10a6:20b:92::29)
 by PAWPR08MB9006.eurprd08.prod.outlook.com (2603:10a6:102:33f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:21:20 +0000
Received: from AM4PEPF00027A65.eurprd04.prod.outlook.com
 (2603:10a6:20b:92:cafe::8f) by AM6PR04CA0016.outlook.office365.com
 (2603:10a6:20b:92::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A65.mail.protection.outlook.com (10.167.16.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:21:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xW4uUYVAJn/e9yQR9cnHefYIB8YTl5Nln/Ruc1bLJqLLqca/TVB0xhUM2FTIdGhk4TNOO4wLueiX3uMRswi7e5GnT1e3/5VXN/AIBxCrhO6uhfPXT1GwLyzlVE8uqFY86uqLNqObwmcnX5XStIXcCgFAxcyLC2UwvKgTTZI/LsxdE8LJDZWUZ3yuvL2Ij9hWBNJ3D5Lgd9B4gSYtCfcixkNM0mBXy0chPs/hJelxgN9tv3jDOyw1vgjPENvMBTDGD4nnTCLEosPGjwEhgQUH5/mOweMromJsX437+kuZvT6/p4N/6F2QhO1X2lEv7b9jARujX7HYT50S8LZIGJdWeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NyzJWaBRD2RYhP6Oq0T+saJYh2ZT08BG2lJxXqejgZw=;
 b=NMZryDpmuPGFcIvdjhqLqveQ43HM7fsJHxAMkIX1Fwe6WMqSikUvM5osz4MwE6eBOcRMv3vZRwlJtZWrsQ8rlQSItN7QUutRjc3fpx/o/F1Fomsrm/GXzvPWVLj0AVMDufSdapJMe2Jc3bpMgAu97j3fP/NzYJmt5eMWdJfiUPnXsHBZwjD6PNckf1ci69TzGKszoxbfq2qU72PmQUy4MJRS4MUJPxd+QPmju0JkOoOaBXD7294gFJ8jw2MAlYCtD7SrDJVkGGw2Dusql+VSzSvL2g5PXeZfqzj4m4nnbQd2xy+Rpi3dskfK1SnKfR7Nt5Lae7vpBEYskImAp955nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyzJWaBRD2RYhP6Oq0T+saJYh2ZT08BG2lJxXqejgZw=;
 b=PsQZjREYpX0hNtSyp1M191Ytkk2k5L+OUcZmSAO850h3AWX+j0QHRw2ZImwxZdfxtqO+pV1B2U/AdXqtBjsT0/d0sIlCjxwgih+/i6PtGKeUDDcMzCN7gj3J+3+zZeqTxBp05grB6syrXbiCMU29AmsaREaKAhxYxXqu2h3REkU=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by DB8PR08MB5307.eurprd08.prod.outlook.com (2603:10a6:10:114::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:20:16 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:20:16 +0000
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
Subject: [PATCH 41/43] Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS
 to VGICv5 docs
Thread-Topic: [PATCH 41/43] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHc1mG7CJ8auYJigkavGHttPckVVA==
Date: Mon, 27 Apr 2026 16:20:16 +0000
Message-ID: <20260427160547.3129448-42-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|DB8PR08MB5307:EE_|AM4PEPF00027A65:EE_|PAWPR08MB9006:EE_
X-MS-Office365-Filtering-Correlation-Id: 84c16ada-b178-4216-11e4-08dea4790431
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 QfZ3amrKgAlFES3Q4KY1iQpcNNVBOlrj/Id1FY9zzdhYNQPJNuZMISDGcjZSwcIiHZPfheSAhlfrMXQlU8MWKsGdOEDHMneyBQiMzM7VFPKq3/hYrg+SKObzqbnNrKyrKGmxDqt38afG1+dLVba9JPCrFUazJkYOVSYgxCVaDmhBfrcJcZr8Ssx1GgaiVLh0sCoRzjH2G7eGS7MGYBij9awhfgYYflNyFqAqPMR50Pl9lYSk7VkNLyvUv6ewvvTiQ38Abll2cVBKUBaBMSF6FxitO5RgGHrC7FWsNACuzAQHPb+TI6PsOpeGlSQXNWPuVpxvGGtTpzzWk6Qr4qOV/yankVjqeUsydCSUe4VQBGpH+AjFT1GTICzYr0CuuPDLPIMSuIDxA27cvsShUYcslQFk4+7uMTdZXblKgiVkRffdJ+LqbZsYgVuuTZMBeSv2dDXSlH0i+3NMQo+CSuvterXf8rMOwe70R1IXfzBwR9pE2olv9XpmAeFKiwBYLsNGd4n1Nzl16Y6oGvzdJ9eQP8wV6FCanf15YgwPVZsxdMrQazKLg3s6KaDwoBavhO/W/Xy+WukoQRt0vd/kI34xy/MfOL8ejV4ulvlHRpvVSMDrVOcdfZn8ORQUVLje23nFk03ZrbFKiwnASSebopcMnZoKlFRgcwT4N5Oh+ri34m2eOOvHXycZi3U4RiccEfiySPjSAnzllwwZtLF+bSaxEIwXK2/+9h++maXA6SovoRvwu1iMDXdDNqSSVhPb5/J+bGrfj+iIvUIu7kSM3ftp287qmOh592huj4X75svZRSY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 m2ZvfawjbvKDUkpaeyqCqgfQlyVvXTs6gi0LblTg6KMvZrN8q4wCWuz7Q5NbPhudVosdIh5QFP2XD6kFPyb6J17rHb8YvtgUOfFCrD1CYp75B3iiAL7Kakm9DLIJLg26JLzHyTSywk8+HysB9J2U9vtAZU9fuyrli3qpLDTweeKZLrGDfi/2s7O2QwS5gA7qc/4btgCb0IeG9FlIPc9UxRNE7PayvfNbAZRlme7T8kXqtacInV7UT+NGj56EXXptYS5uLf0+OLk6lsdVqNRfYLOJNos+w06dRHy8NFXfsBwww9wJDisAEza3qVwKCeCaCmR5cHo17p790ZyVxkLPIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5307
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	09cedb61-3c0d-449a-0beb-08dea478de73
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	C0Zypgo+gvjWOJhkebov6Atooc8/84Zb8HnO79UfdvdFv6Kj21OzIV+JdJe9O0MPuN2lILGZWgUGYBDSusQ917Tj4DmJVq8z2EIFr95yPOSTCb5FA06mlEBDLA8uqNI4L1m0XWdA8bQl/e1f/0BfVubsfXtlh7Vx7Bbko7/BWCD8YM1ebfwZzyASO8DAHzFSNCg2O3PEUUUd95EV3Psocmi0KUz4JBTrVZw21UV7Fn+VhRXMs0Y6EHs9CLnHfeqVboV/gPNkLB08dDxRhHCjOfR7PD+opo3HHchnFlOCpsOR+NS069sHmDgS1juLKp9EyBwEo+rVlrlzplSL2pMwvMr6x3T2NN1yj8R+/K2gAOBKfPdomD1C0urpChjXmdTkUi8UFJJlotsYlfD3OfleXg9Y/Shw3gID0lR7xGjQ3nxEG2NYeWtRqs4QHFQG+vbkE4OTw1pSDDUebsqFgWDqbIOXHyNQnXnn983dqutiyLRoYjO3qf1OAdM357aoYrL9kz9jVfFpy+GRXCSpkDYFFHrgxBB3UdK4tbSqbikGxnztlqSNlwnjmWAHmyUFDxi33mu6/oiOvKYmcPc7iCutnXgk6wF4mQt3A7A0uYCAdmI1aNDV1SmkD+W7eIaf9YB9GLHmhESvpfnvr+tGV2nQ7e6yvMKZWBYHTZiFfV82p/YZezvDnQMOONYc64D7iTLtE2fwHC7e3VWFQW67Gh97UtOlAJ8nm1uBnnxtWLIXvVIJrgJxUqSQP84kP9dDy+2G3r5O4+PFx3uxA2KeuftGRA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gjjz5L/snRKU+A7tpynBMbCByLwZViRsZAl8U2/+/l9HPQ+ZYAR8hgAhRLK/ydtVDt+L/O4JmW/whRTcv1Yvfb+eARULeoPxDpuiH4wVDp73DDtH15a/JrDvLx9jEfAid0zWNVvxE3A8KbxKUTu27/OGY8aWZYeEerXKCt1f36WxJoibTV1e9wCFVHtGJKToIGrQEHvUWbZAP2mBQQT8DvGyoCMPHmZGsmiTASUEqqiWaFV8ZM6n7grlL6kZYcnVIS3uyfS2FicGkxqfHUxqSr4fp0l/aQ1FpSq7Ce0pVGzx09L53q0DJI8LREjT7FhOOipb5NcoOhV3R5XXQg4NsZjRZNPhDMeA+uRgEFEszR4OpPvt4GBvatP5NQiTNb95EgODGf2Pu8Ox+vDfSXw081kWKwCXuFR/AXAEKBj7m9/wXmfFT8na6aM5dBUBlsdz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:21:20.0577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c16ada-b178-4216-11e4-08dea4790431
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9006

Add documentation for the KVM_DEV_ARM_VGIC_GRP_IRS_REGS ioctl used to
read/write the virtual IRS's MMIO register state. This is the same
interface as is already present for handling a VGICv3's ITS, but hiding
behind a different, more appropriately named ioctl (that doesn't
contain ITS, but instead contains IRS).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 46ede907f2b32..9fc6afe16154a 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -130,3 +130,34 @@ Groups:
     ICC_CR0_EL1
     ICC_PCR_EL1
     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IRS_REGS
+    Attributes:
+      The attr field of kvm_device_attr encodes the offset of the IRS regi=
ster,
+      relative to the IRS CONFIG_FRAME base address. This is the address t=
hat
+      was provided via KVM_VGIC_V5_ADDR_TYPE_IRS when creating VGICv5 in t=
he
+      first place.
+
+      kvm_device_attr.addr points to a __u64 value whatever the width
+      of the addressed register (32/64 bits). 64 bit registers can only
+      be accessed with full length.
+
+      Writes to read-only registers are ignored by the kernel except for:
+
+      - IRS_IDR0 - IRS_IDR2 and IRS_IDR5 - IRS_IDR7: These are sanity chec=
ked to
+        ensure that they match a sane config.
+      - IRS_IDR3 and IRS_IDR4: These are RAZ/WI as nested virtualization i=
s not
+        supported.
+
+      For other registers, getting or setting a register has the same
+      effect as reading/writing the register on real hardware.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   Offset does not correspond to any supported register
+    -EFAULT  Invalid user pointer for attr->addr
+    -EINVAL  Offset is not 64-bit aligned for 32-bit MMIO registers, or 64=
-bit
+             aligned for 64-bit registers
+    -EBUSY   one or more VCPUS are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
