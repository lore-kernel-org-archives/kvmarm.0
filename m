Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011016.outbound.protection.outlook.com [52.101.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48637700F
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748279; cv=fail; b=Xr+sLo2n7e8wHytthI6cQ+xfsJVsUUOvSsew8b+d1Z/bHvvAywQOqUMxSgvixzM0WgLrN+JGNg4cCFkJ3Cjt8OWZhiAb5yDE9OnubGYqUn8TmDn2ccSLmLwx/bSBbWlUEaHo2DaSaeA3SyDJXsbGTVjzFEAC8LnmBOQOsElJEeE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748279; c=relaxed/simple;
	bh=mvLFyD8kY1v6nw4PbRIGbBYYYHzM20xTJz+J44CJa34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fyp/auD9BXqveAcKdINZNTOLhjpamLO1If5hBrdf6OQHRiUNxqUfQ0hrnM4jKOTu1KOPCfG1JNJ9NRnoSeU5f95AsUJmFdSgeK6Hfku0PZRk5IIJ7kVkDeDfumjO6AK87vW/vsDSzACdBiD20Cm+4ZzDg0Ymm58k1zVECT4QP8k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N3AQEAXd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N3AQEAXd; arc=fail smtp.client-ip=52.101.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N3AQEAXd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N3AQEAXd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hKbyUrlGh4B2uTR/IUpamNHkf7yiBAbVJ/AdTRpuPdE3uy+MtqRNZvPrr2D0W3LjzdwqFjCTcWyTy59plTEPufDsADYDsttgZmfvZXBRUkbufPbITx8VBPLI773/kPMV19AsB9+jM300hi1s4UtiSprRkaAWlUNcGErO+PNU7AX5x51NrWqunnbN1nG138cIKiXsSgCRcwU6yI5XHpEO5E0o4FuavReMqvtDM7DU9cEPomiibe7sP1+ZI1tGUofo84vwZURPeovUd1bxvp1b3AXWx4FGzjtcs2mBYT+Tkc4E8JFi3HrB4SVEwaZm6jNf34p68/CPKqhmzPt7iX50Kw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=VAXDBb1ex6NLe/gP3/iPjXfFgsq6cckxMGHDcBr2TKcsP9C9W/yw62NnVBnsyn+J/QLSdwr7CbOY1yz+gyD52BrMEENbQ8p42xME4JhIjgHb6If5HrE0eRBvuRpKY4a5biKIXHxdrroh6EiJCVuChDaT1OepOiYBeTnDtlN45Uh0s1j8e/CL1oD5ctrxNESFxibngISyF0EpiuSqzJ9erDfn8z6aJMQwmGr+wzDlEY5TXtL6lRfSg4CIv1P+0Kf3iis/mDnmATsJsBBz15DPlZz578U+8Hsvole5n8S+CERUv63/6pevaiEcqW9Nm2Vnt6G4IBUENSn5UupDyQMYcQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=N3AQEAXdGrIhPP3iSEfezOjPzxMf8NCKYVMFqwTf1TkrDw2TJEutUZ6WeS8Ca9kHwkuFOj6eOM++TVcjTtS8bP3jrM5Yyzu6rCsbnO0M3sqaC6rh1AfaYu+DJfTnSzjxg7+OnoRVJ+/kJlZG1baUhrTqMRIForLhGPPBtfSLVuQ=
Received: from AS9PR06CA0631.eurprd06.prod.outlook.com (2603:10a6:20b:46f::19)
 by AS8PR08MB10141.eurprd08.prod.outlook.com (2603:10a6:20b:631::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:51:08 +0000
Received: from AM3PEPF00009BA1.eurprd04.prod.outlook.com
 (2603:10a6:20b:46f:cafe::f6) by AS9PR06CA0631.outlook.office365.com
 (2603:10a6:20b:46f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:50:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA1.mail.protection.outlook.com (10.167.16.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:51:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V9LlvOJp05ZkUU31rrhvsuhxpIACYRBD18bJoiDaI+zU5Mwp3m/7ZqUP8JxLLZXj3m2FrDAffFB33zZGg1Bvxzz9zQvvrM5WBuspqRiDh2G9yMxPfRr9HsyaJXpks1z35McZX7gQAEMkSHCNfOUYcUQnpfbDM2yVvzY0iymbpVMFTZf/t7+Py+5z5Be99jlr9aXTXFERXRVMRLcgL4bCEA4BSg7nGjprvVuvEVCsXnp6R2VHFC4zLVCNFFqv4yecP2idnYkruVulf+sKoqM4N9U2hpqpgDjv74nXf1KJuMiSiNkImZgOcs9HOOmnsYlbt7KtoMVcCvbhtcUqghG5eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=nPy5eGC3zfxVgsK5OBF5Ot+GDDjFpxQPA6fdm88mdT1BW81Wl/R+M3YQljQREz+lUCA0RKVdFiE3ax+d6NOmssbN1CaDrsfupT30zFQmkvJrpJXtbOqbZ69t8nWohLsZz0xxWKBq9kmNAyCR5W6KypKHkyrItsjgX7DbRyqjIaTLU/+NDg63rMJp5A+N1m5Bkh9GH+mgPmsfTu8RODlKyfzOUDPuNBnzKDFkDWVpFx4COqny636heXzZv2fvsGgH98QHiWIym2g8MDJjqZsFyBlZNo3sQa+h/AyX8RluiNc33IurjNhAc8dwQhqJtR3GTBMajdfYQjtKC8/fH9p+rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bAgLK+iVZ8sD5m+lrL3DSajGkpYgh/q0QlHDW4ALr8=;
 b=N3AQEAXdGrIhPP3iSEfezOjPzxMf8NCKYVMFqwTf1TkrDw2TJEutUZ6WeS8Ca9kHwkuFOj6eOM++TVcjTtS8bP3jrM5Yyzu6rCsbnO0M3sqaC6rh1AfaYu+DJfTnSzjxg7+OnoRVJ+/kJlZG1baUhrTqMRIForLhGPPBtfSLVuQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB7674.eurprd08.prod.outlook.com (2603:10a6:10:37d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:50:04 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:50:04 +0000
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
Subject: [PATCH v6 39/39] KVM: arm64: selftests: Add no-vgic-v5 selftest
Thread-Topic: [PATCH v6 39/39] KVM: arm64: selftests: Add no-vgic-v5 selftest
Thread-Index: AQHctgQxL6dkYdEW+EGlAhOhZ+c0Uw==
Date: Tue, 17 Mar 2026 11:50:04 +0000
Message-ID: <20260317113949.2548118-40-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DB9PR08MB7674:EE_|AM3PEPF00009BA1:EE_|AS8PR08MB10141:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b9012a3-af2e-4f7b-ee9d-08de841b7a4d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 awyt+w9iuhe5Bxu8xJHTPRpgta6jZF+SH3JAP0dHtLRc/FYhy4kO2Oi2MbHXgOBLRuspJUavliUdPJZET3urJRBKVr6wvj3M7eMLM5Iutg4jR70VWTEndB9cI5GG++4l1FZInTHELtGGeucySE09pw7sNEVJJEv2wCtpw2eCNoYT4q29AZyX+5HHRzlczi9g0wky5WfYEq8rY18aKI6WDNIhQYDhu1SNAi8obrBToxO7T7aedQ2gVrzy/sCMQZwwqeMGs05xvsx6eVykO70TW/Dp/cXlIl9H3lBjRwEHMlBXWS3Qr487HbsjEwRFEYFlzKngF9nN5b2GSbG1fgx4EVXCetRr5zOIKGqXpm92ExBQkh41UuHzn2p3OjNA7pBU4kdLL4hyxAiblswCHL61lV1wBZwDJPZMplyrPuUikOCsEwkg/nW44Fu109sDbsg6sGLY2NZVuHvHOzYEFPKdqMREEcGaQ8mq2oDi7+F5CO5AwoaqG+suSvXN5VCi4L1smi/v3DLZZZWm2408MTFxAMzM3+B+TrukGewl+pmj07XwwO4Yn2F9FTRwET/GoDiXjlJJ2Tlo+rnCtHT1xoNEm65DXbe6lSljyKGoz0GNZGLALvkygxP2yf8gRwaog4BQF1aMeNklr+m4tmGido24eKJIIPCKFYWmSg5y1f3SgNJRjxbIqiAYQ267xeUW//ipbypecgKPRoiWXsPHsZxn0rRtRbA4rJbcqxjHaq64y7xFfvmL6nNMAr1VvyKywZ+wP5nYVEuDs81KirM5ulfcVQwS5zIEMMbhl1s1oEeZt4Q=
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
 KfM1gPQBvrt86JmCkHyTJYaBPhcrIMZEJ0Ni7q53uYTqavKXlQBVFSI/O8kuXPAPC7VFQdYJgaQEgy+/BmtUy/fGubgaiUYMvlHMubGo9zSDALc+Ofx+yg2VDWezIFyrtx2fH+pkfZzA9awrVkm8iX0PvKe8ogW7RXeYAFeKBWhoYjSXyBOYhmUjqhIhXp+6Kn5qTvGkwDmshWGNEFlTiWYOvR0XfxXLWAJ12gcWpXBlNXSl8V/bzjS4IV75sNzfmxjrH2s0vBq8qmXvzmvHrA6dGwsybWa2wug6Skfj4aoVR+MqzS7lvIKNd1BfAmupe37R9/Vv2k+DsIvLWQl2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7674
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	622667d3-2263-412c-fda8-08de841b540b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|35042699022|36860700016|1800799024|14060799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8OHdDSfjdIkDXI1D4CNPkKIO7o74YS1GT//5zDmKX3ji8NiC+cWeuodOnZU5iPoAtaS7tSWw1dpiwe2VDZuFxbuKdRffIvZAPVynn7b/c4sjgANvGl0G8Bq8jxSFS1EKAoiMGu2oU55eOceOoPtChHjno1iMMSUCve3PFroySqe6U3Nka37luj5YhhMenJab3KSeAbMt/jndFfIGQAa8kSRlobyJbgrJIgMUXiaJsCQB9JKLAanvUX4ejRhsTyQCgpuNye8NmU5g+0rwqRedr7RVNncVtTwvjXRBMiHm4/bLTWK2YwkC9vVjsS3wHGbC+fH7WC0tNuqMfCABVIbvLG6CunnBt1528xvV/XgVxRPq8MZvNwVLdTidFov7WyqCAa/R6Nj51pLQKPndpXMwQLnTnNv/MW+O3XO4anBp5ALC5lxK4SGdce4LW5mRs6ap42iuDiH+D9g20NlZC7ypxdMTp86GRQ80YxdqIQkrhz5I8T/EMzwjTiXkwV9Yqd5PMXqhxzCzxGMOnirn3XLyC1u/xotOFs/9OffRpUacrCLIbRSVRVxf9yTszduyNLYm4xfjwiZ1AKuAjIY1C5l3hAil58P8t11hHCCUhXyYz88lzXMR9jS+R0kn0B8vkB5QYAOLIVP+v0tZTB2fCWI70xgYhNsgapmmRgxvgvvngaNoevnbSBglJ73ymZTDACzoUqps7iGVaT13d0MsqM6wv4AZygFTt50woGtOZqcqCBB03z6Zl3NNYa+qXgbnw/nreWN21tbv6+15yM2j2OK4VQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(35042699022)(36860700016)(1800799024)(14060799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8HA7tpPyZlojOd2+6CqFQ6gxt0VO2OzM4dSBG+SWurQh7ZP43AKZf8EBl+/EgKlgrfTPc0jZVdeNPTJTRbtT6o2n/JEl6rTzwCz24LkJIIk/9P8K3DpBYxeVAkvHaXdNCry6vKnIQxK2HnreWplMSIP8UyKQWVbBnQCYl/QkG9PlB4RY1xYNsEshgqx3BF8G77CYP1MZuAKRLUiURfF483guwqlo0X60h0gcHeeT1z/mDOStPHg65FKg6TChlJgGvU1DXMHD35IsVJSIvlW8IEh8wjEEz5rTwBvr4LFFKolbH9cr3yWjruwCl0yxh19/Nlgk3BQzPscP5b65vZggZQU0j1GLTtNI32xYvyxq/e9iteT7owWBvDw9+5IgPUDTdVE/rE7XTMdQp5wlKJ1KSv2WsbQZc1OmfJ4DvTjFcPFjEWtNMF6tAI4T+dfKDPtJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:51:08.3072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9012a3-af2e-4f7b-ee9d-08de841b7a4d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10141

Now that GICv5 is supported, it is important to check that all of the
GICv5 register state is hidden from a guest that doesn't create a
vGICv5.

Rename the no-vgic-v3 selftest to no-vgic, and extend it to check
GICv5 system registers too.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  | 177 -----------
 tools/testing/selftests/kvm/arm64/no-vgic.c   | 297 ++++++++++++++++++
 3 files changed, 298 insertions(+), 178 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/arm64/no-vgic-v3.c
 create mode 100644 tools/testing/selftests/kvm/arm64/no-vgic.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index 98282acd90407..98da9fa4b8b70 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -179,7 +179,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
-TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
+TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic
 TEST_GEN_PROGS_arm64 +=3D arm64/idreg-idst
 TEST_GEN_PROGS_arm64 +=3D arm64/kvm-uuid
 TEST_GEN_PROGS_arm64 +=3D access_tracking_perf_test
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c b/tools/testing=
/selftests/kvm/arm64/no-vgic-v3.c
deleted file mode 100644
index 152c34776981a..0000000000000
--- a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
+++ /dev/null
@@ -1,177 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-// Check that, on a GICv3 system, not configuring GICv3 correctly
-// results in all of the sysregs generating an UNDEF exception.
-
-#include <test_util.h>
-#include <kvm_util.h>
-#include <processor.h>
-
-static volatile bool handled;
-
-#define __check_sr_read(r)					\
-	({							\
-		uint64_t val;					\
-								\
-		handled =3D false;				\
-		dsb(sy);					\
-		val =3D read_sysreg_s(SYS_ ## r);			\
-		val;						\
-	})
-
-#define __check_sr_write(r)					\
-	do {							\
-		handled =3D false;				\
-		dsb(sy);					\
-		write_sysreg_s(0, SYS_ ## r);			\
-		isb();						\
-	} while(0)
-
-/* Fatal checks */
-#define check_sr_read(r)					\
-	do {							\
-		__check_sr_read(r);				\
-		__GUEST_ASSERT(handled, #r " no read trap");	\
-	} while(0)
-
-#define check_sr_write(r)					\
-	do {							\
-		__check_sr_write(r);				\
-		__GUEST_ASSERT(handled, #r " no write trap");	\
-	} while(0)
-
-#define check_sr_rw(r)				\
-	do {					\
-		check_sr_read(r);		\
-		check_sr_write(r);		\
-	} while(0)
-
-static void guest_code(void)
-{
-	uint64_t val;
-
-	/*
-	 * Check that we advertise that ID_AA64PFR0_EL1.GIC =3D=3D 0, having
-	 * hidden the feature at runtime without any other userspace action.
-	 */
-	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR0_EL1_GIC,
-				 read_sysreg(id_aa64pfr0_el1)) =3D=3D 0,
-		       "GICv3 wrongly advertised");
-
-	/*
-	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
-	 * Note that we happily access all the APxRn registers without
-	 * checking their existance, as all we want to see is a failure.
-	 */
-	check_sr_rw(ICC_PMR_EL1);
-	check_sr_read(ICC_IAR0_EL1);
-	check_sr_write(ICC_EOIR0_EL1);
-	check_sr_rw(ICC_HPPIR0_EL1);
-	check_sr_rw(ICC_BPR0_EL1);
-	check_sr_rw(ICC_AP0R0_EL1);
-	check_sr_rw(ICC_AP0R1_EL1);
-	check_sr_rw(ICC_AP0R2_EL1);
-	check_sr_rw(ICC_AP0R3_EL1);
-	check_sr_rw(ICC_AP1R0_EL1);
-	check_sr_rw(ICC_AP1R1_EL1);
-	check_sr_rw(ICC_AP1R2_EL1);
-	check_sr_rw(ICC_AP1R3_EL1);
-	check_sr_write(ICC_DIR_EL1);
-	check_sr_read(ICC_RPR_EL1);
-	check_sr_write(ICC_SGI1R_EL1);
-	check_sr_write(ICC_ASGI1R_EL1);
-	check_sr_write(ICC_SGI0R_EL1);
-	check_sr_read(ICC_IAR1_EL1);
-	check_sr_write(ICC_EOIR1_EL1);
-	check_sr_rw(ICC_HPPIR1_EL1);
-	check_sr_rw(ICC_BPR1_EL1);
-	check_sr_rw(ICC_CTLR_EL1);
-	check_sr_rw(ICC_IGRPEN0_EL1);
-	check_sr_rw(ICC_IGRPEN1_EL1);
-
-	/*
-	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
-	 * be RAO/WI. Engage in non-fatal accesses, starting with a
-	 * write of 0 to try and disable SRE, and let's see if it
-	 * sticks.
-	 */
-	__check_sr_write(ICC_SRE_EL1);
-	if (!handled)
-		GUEST_PRINTF("ICC_SRE_EL1 write not trapping (OK)\n");
-
-	val =3D __check_sr_read(ICC_SRE_EL1);
-	if (!handled) {
-		__GUEST_ASSERT((val & BIT(0)),
-			       "ICC_SRE_EL1 not trapped but ICC_SRE_EL1.SRE not set\n");
-		GUEST_PRINTF("ICC_SRE_EL1 read not trapping (OK)\n");
-	}
-
-	GUEST_DONE();
-}
-
-static void guest_undef_handler(struct ex_regs *regs)
-{
-	/* Success, we've gracefully exploded! */
-	handled =3D true;
-	regs->pc +=3D 4;
-}
-
-static void test_run_vcpu(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	do {
-		vcpu_run(vcpu);
-
-		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT(uc);
-			break;
-		case UCALL_PRINTF:
-			printf("%s", uc.buffer);
-			break;
-		case UCALL_DONE:
-			break;
-		default:
-			TEST_FAIL("Unknown ucall %lu", uc.cmd);
-		}
-	} while (uc.cmd !=3D UCALL_DONE);
-}
-
-static void test_guest_no_gicv3(void)
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-
-	/* Create a VM without a GICv3 */
-	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
-
-	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vcpu);
-
-	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
-
-	test_run_vcpu(vcpu);
-
-	kvm_vm_free(vm);
-}
-
-int main(int argc, char *argv[])
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-	uint64_t pfr0;
-
-	test_disable_default_vgic();
-
-	vm =3D vm_create_with_one_vcpu(&vcpu, NULL);
-	pfr0 =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
-	__TEST_REQUIRE(FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr0),
-		       "GICv3 not supported.");
-	kvm_vm_free(vm);
-
-	test_guest_no_gicv3();
-
-	return 0;
-}
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic.c b/tools/testing/se=
lftests/kvm/arm64/no-vgic.c
new file mode 100644
index 0000000000000..b14686ef17d12
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/no-vgic.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Check that, on a GICv3-capable system (GICv3 native, or GICv5 with
+// FEAT_GCIE_LEGACY), not configuring GICv3 correctly results in all
+// of the sysregs generating an UNDEF exception. Do the same for GICv5
+// on a GICv5 host.
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#include <arm64/gic_v5.h>
+
+static volatile bool handled;
+
+#define __check_sr_read(r)					\
+	({							\
+		uint64_t val;					\
+								\
+		handled =3D false;				\
+		dsb(sy);					\
+		val =3D read_sysreg_s(SYS_ ## r);			\
+		val;						\
+	})
+
+#define __check_sr_write(r)					\
+	do {							\
+		handled =3D false;				\
+		dsb(sy);					\
+		write_sysreg_s(0, SYS_ ## r);			\
+		isb();						\
+	} while (0)
+
+#define __check_gicv5_gicr_op(r)				\
+	({							\
+		uint64_t val;					\
+								\
+		handled =3D false;				\
+		dsb(sy);					\
+		val =3D read_sysreg_s(GICV5_OP_GICR_ ## r);	\
+		val;						\
+	})
+
+#define __check_gicv5_gic_op(r)					\
+	do {							\
+		handled =3D false;				\
+		dsb(sy);					\
+		write_sysreg_s(0, GICV5_OP_GIC_ ## r);		\
+		isb();						\
+	} while (0)
+
+/* Fatal checks */
+#define check_sr_read(r)					\
+	do {							\
+		__check_sr_read(r);				\
+		__GUEST_ASSERT(handled, #r " no read trap");	\
+	} while (0)
+
+#define check_sr_write(r)					\
+	do {							\
+		__check_sr_write(r);				\
+		__GUEST_ASSERT(handled, #r " no write trap");	\
+	} while (0)
+
+#define check_sr_rw(r)				\
+	do {					\
+		check_sr_read(r);		\
+		check_sr_write(r);		\
+	} while (0)
+
+#define check_gicv5_gicr_op(r)					\
+	do {							\
+		__check_gicv5_gicr_op(r);			\
+		__GUEST_ASSERT(handled, #r " no read trap");	\
+	} while (0)
+
+#define check_gicv5_gic_op(r)					\
+	do {							\
+		__check_gicv5_gic_op(r);			\
+		__GUEST_ASSERT(handled, #r " no write trap");	\
+	} while (0)
+
+static void guest_code_gicv3(void)
+{
+	uint64_t val;
+
+	/*
+	 * Check that we advertise that ID_AA64PFR0_EL1.GIC =3D=3D 0, having
+	 * hidden the feature at runtime without any other userspace action.
+	 */
+	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR0_EL1_GIC,
+				 read_sysreg(id_aa64pfr0_el1)) =3D=3D 0,
+		       "GICv3 wrongly advertised");
+
+	/*
+	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
+	 * Note that we happily access all the APxRn registers without
+	 * checking their existence, as all we want to see is a failure.
+	 */
+	check_sr_rw(ICC_PMR_EL1);
+	check_sr_read(ICC_IAR0_EL1);
+	check_sr_write(ICC_EOIR0_EL1);
+	check_sr_rw(ICC_HPPIR0_EL1);
+	check_sr_rw(ICC_BPR0_EL1);
+	check_sr_rw(ICC_AP0R0_EL1);
+	check_sr_rw(ICC_AP0R1_EL1);
+	check_sr_rw(ICC_AP0R2_EL1);
+	check_sr_rw(ICC_AP0R3_EL1);
+	check_sr_rw(ICC_AP1R0_EL1);
+	check_sr_rw(ICC_AP1R1_EL1);
+	check_sr_rw(ICC_AP1R2_EL1);
+	check_sr_rw(ICC_AP1R3_EL1);
+	check_sr_write(ICC_DIR_EL1);
+	check_sr_read(ICC_RPR_EL1);
+	check_sr_write(ICC_SGI1R_EL1);
+	check_sr_write(ICC_ASGI1R_EL1);
+	check_sr_write(ICC_SGI0R_EL1);
+	check_sr_read(ICC_IAR1_EL1);
+	check_sr_write(ICC_EOIR1_EL1);
+	check_sr_rw(ICC_HPPIR1_EL1);
+	check_sr_rw(ICC_BPR1_EL1);
+	check_sr_rw(ICC_CTLR_EL1);
+	check_sr_rw(ICC_IGRPEN0_EL1);
+	check_sr_rw(ICC_IGRPEN1_EL1);
+
+	/*
+	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
+	 * be RAO/WI. Engage in non-fatal accesses, starting with a
+	 * write of 0 to try and disable SRE, and let's see if it
+	 * sticks.
+	 */
+	__check_sr_write(ICC_SRE_EL1);
+	if (!handled)
+		GUEST_PRINTF("ICC_SRE_EL1 write not trapping (OK)\n");
+
+	val =3D __check_sr_read(ICC_SRE_EL1);
+	if (!handled) {
+		__GUEST_ASSERT((val & BIT(0)),
+			       "ICC_SRE_EL1 not trapped but ICC_SRE_EL1.SRE not set\n");
+		GUEST_PRINTF("ICC_SRE_EL1 read not trapping (OK)\n");
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_code_gicv5(void)
+{
+	/*
+	 * Check that we advertise that ID_AA64PFR2_EL1.GCIE =3D=3D 0, having
+	 * hidden the feature at runtime without any other userspace action.
+	 */
+	__GUEST_ASSERT(FIELD_GET(ID_AA64PFR2_EL1_GCIE,
+				 read_sysreg_s(SYS_ID_AA64PFR2_EL1)) =3D=3D 0,
+		       "GICv5 wrongly advertised");
+
+	/*
+	 * Try all GICv5 instructions, and fail if we don't get an UNDEF.
+	 */
+	check_gicv5_gic_op(CDAFF);
+	check_gicv5_gic_op(CDDI);
+	check_gicv5_gic_op(CDDIS);
+	check_gicv5_gic_op(CDEOI);
+	check_gicv5_gic_op(CDHM);
+	check_gicv5_gic_op(CDPEND);
+	check_gicv5_gic_op(CDPRI);
+	check_gicv5_gic_op(CDRCFG);
+	check_gicv5_gicr_op(CDIA);
+	check_gicv5_gicr_op(CDNMIA);
+
+	/* Check General System Register acccesses */
+	check_sr_rw(ICC_APR_EL1);
+	check_sr_rw(ICC_CR0_EL1);
+	check_sr_read(ICC_HPPIR_EL1);
+	check_sr_read(ICC_IAFFIDR_EL1);
+	check_sr_rw(ICC_ICSR_EL1);
+	check_sr_read(ICC_IDR0_EL1);
+	check_sr_rw(ICC_PCR_EL1);
+
+	/* Check PPI System Register accessess */
+	check_sr_rw(ICC_PPI_CACTIVER0_EL1);
+	check_sr_rw(ICC_PPI_CACTIVER1_EL1);
+	check_sr_rw(ICC_PPI_SACTIVER0_EL1);
+	check_sr_rw(ICC_PPI_SACTIVER1_EL1);
+	check_sr_rw(ICC_PPI_CPENDR0_EL1);
+	check_sr_rw(ICC_PPI_CPENDR1_EL1);
+	check_sr_rw(ICC_PPI_SPENDR0_EL1);
+	check_sr_rw(ICC_PPI_SPENDR1_EL1);
+	check_sr_rw(ICC_PPI_ENABLER0_EL1);
+	check_sr_rw(ICC_PPI_ENABLER1_EL1);
+	check_sr_read(ICC_PPI_HMR0_EL1);
+	check_sr_read(ICC_PPI_HMR1_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR0_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR1_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR2_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR3_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR4_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR5_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR6_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR7_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR8_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR9_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR10_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR11_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR12_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR13_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR14_EL1);
+	check_sr_rw(ICC_PPI_PRIORITYR15_EL1);
+
+	GUEST_DONE();
+}
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	/* Success, we've gracefully exploded! */
+	handled =3D true;
+	regs->pc +=3D 4;
+}
+
+static void test_run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	do {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			printf("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	} while (uc.cmd !=3D UCALL_DONE);
+}
+
+static void test_guest_no_vgic(void *guest_code)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Create a VM without a GIC */
+	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
+
+	test_run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	bool has_v3, has_v5;
+	uint64_t pfr;
+
+	test_disable_default_vgic();
+
+	vm =3D vm_create_with_one_vcpu(&vcpu, NULL);
+
+	pfr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
+	has_v3 =3D !!FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr);
+
+	pfr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR2_EL1));
+	has_v5 =3D !!FIELD_GET(ID_AA64PFR2_EL1_GCIE, pfr);
+
+	kvm_vm_free(vm);
+
+	__TEST_REQUIRE(has_v3 || has_v5,
+		       "Neither GICv3 nor GICv5 supported.");
+
+	if (has_v3) {
+		pr_info("Testing no-vgic-v3\n");
+		test_guest_no_vgic(guest_code_gicv3);
+	} else {
+		pr_info("No GICv3 support: skipping no-vgic-v3 test\n");
+	}
+
+	if (has_v5) {
+		pr_info("Testing no-vgic-v5\n");
+		test_guest_no_vgic(guest_code_gicv5);
+	} else {
+		pr_info("No GICv5 support: skipping no-vgic-v5 test\n");
+	}
+
+	return 0;
+}
--=20
2.34.1
