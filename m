Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013035.outbound.protection.outlook.com [40.107.162.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9581A34A3A2
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747766; cv=fail; b=FqiaSvxqnz0gDkPmOmFvSL9uNeCGc7MIzf+ybcQ5SFNOapeQ3Ywq/CD1qjliurlGXTghd5UPblJSo47/uSV9aHdozABQmdgf9xuLmBBHrOGMgTJPWNFxRH8OwLicLpb7+xdrnkYbh133tqBS51hCvscwFte5/Yp8k4tOm6DSLRA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747766; c=relaxed/simple;
	bh=+KBjkRPkU1zI3s8Hio3H1SewMKkzcBm1UX3ngKu7Hlo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iyct0n8DMsf2ggft1P8Op7//MTvjW7TMAbdiDSJocitQ1s9RhtDiGdOxVc1FsTCDYBicmS8VKcJsjiRWx0BbkjZQqGSEsCmgyXalPrNvZLhTgrsr/MPfoidxm2NXVR4FJ3NDEVEOpMc5+nxvDP2llWWlxXPCJb8GjCFZ5HOmfxU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B3w0YAvX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B3w0YAvX; arc=fail smtp.client-ip=40.107.162.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B3w0YAvX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B3w0YAvX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JrMcAH/qvUyu1+tfgVjBGDQZ1a1mFMJQWYxxF5/fnNiWcM9sqOkvP8ktz+72DwCOonz1EORXdSaD5GujGX3SKQd4LAk3mOTJ7WK74K9VclELs0H7ynvTGUrIyvRJ0/j1s9x2+w1cduDm/I8LmGUGJBQFbVzqDYD3xS6Xvuis/RXU1FEUq9oul4jHmAuWQGf5ppneGK94GZuP/BklO/pT1eviUs5A0YBkXLyZJhgLDdlJqVxw65nyxg2wZDQmW2Tn6jEBDDvJmU/t5QByWtUHwXO6mn0hsvV7eFfd/uW5bfKqaCOZ4G4TwTPhfjqyF+C2uEK/OAIPLhCSzx86PjfQEg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=PNVZ2EnAtGLbEapB0AtCqrT/hXygQcSn4hnbf1ZLR9plL/VjFOEkB9hRzA2mrFcI+0M3992kw75OWiKhPa0BvQQiisQiPHFj1ZS0nQJUwHRnCTjL5FeDqb/l5/GS0a8LqKH06Dvrl4RzsGCwIn12S8k/lLuL5TPezVuq9p4/9IutR2Bnq01CnCfecsI8ItCkj42BPoo6D+QSNcm0YC6fXl08VjlsDI2ZRyVeSl5FcyUzsF8HH8CttoFXwlsmaIsZ2QS3YiS/b++mia2Qr+76R3m8KN3PIWygHJV0ezlTl0w2G8ClLEG/Vsms/Fp/b84TtGn3CeV4fvksFXmEYFioeg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=B3w0YAvXGADs8cLEv7p9PU6+x9v1l7iwA+FI5+kRGwF7b+9cQHfK/SyKDDOtlrX5kEZB1crFIBymjiXj7GFPBBkjRstvmir8M208ZHdAjtrZH2Pu9/Xs7LYK+mZAffTaCLRxNVI2VjjAkCjir1I0ex1UcLSZy0T0oFgx6DkpZ9A=
Received: from AS4P250CA0001.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::6)
 by AM9PR08MB5940.eurprd08.prod.outlook.com (2603:10a6:20b:281::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 11:42:37 +0000
Received: from AM1PEPF000252DF.eurprd07.prod.outlook.com
 (2603:10a6:20b:5df:cafe::b0) by AS4P250CA0001.outlook.office365.com
 (2603:10a6:20b:5df::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:42:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DF.mail.protection.outlook.com (10.167.16.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:42:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oexGyiTMl5bQaVllVAImix6VsPpUq/7nj331bKAVzm7VSn7w1ask1zrKNvjLw33fJEMo2gZcQYPzM+XQaw5+wpHyRvO1y74Xg4iwTAf/2Xo/6UWNUQTFXBgvN2AFK2zhBl79skHN3g/NUSaV0twhxx8b4c2Yeh2gwpKp4kDI9WTR/pfikXHhM2KlVOg1wiLzNi6rnsOKGDLmLDw4Mxu8Ku5o4nNeGiS+zv+3BIme2aRS37CPa4SiFW6dyIgmiSzJTsQSWZMFiwvPBzGE+/Tm5fgJwrvYbMOFvvBT3/w0oPjoPuzlIZ8eDO1bYc8ywgzIXLBImFGfJMwo0Uj1mEhDzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=mToAo1i8+nJuX1zsIbWo9PQCnfb/MO5ph1SLGrd+4ksbP0OV3ICfFyhunDDqsMv/iJRCJGdQQJqPOslGEEM1RcEK5NMWGQcntc0HpkcI2MzEQLMoS+Y1ihJVVPvhYYIVKN0SCnq1H0X/3MX/r4pS6rkHdk7+EFYFIkLheCLU8rVso4QFwkgk3h7+qQpN9xd1M0VDVI8vwDXMEEfDHXG7pBB7NJoxOnlmZr+qhzBEvIYGB3+YoBqGL7Gcr039sXGDoyOLJwqC4eP6gsRA40hnsYsc5EDflT0sm4t15/Y+hKVUPXLhQcE0i3MghWe/yE3pGat4c7lBKGQdfGM8XKx2nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=B3w0YAvXGADs8cLEv7p9PU6+x9v1l7iwA+FI5+kRGwF7b+9cQHfK/SyKDDOtlrX5kEZB1crFIBymjiXj7GFPBBkjRstvmir8M208ZHdAjtrZH2Pu9/Xs7LYK+mZAffTaCLRxNVI2VjjAkCjir1I0ex1UcLSZy0T0oFgx6DkpZ9A=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:41:30 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:41:30 +0000
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
Subject: [PATCH v6 06/39] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Topic: [PATCH v6 06/39] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Index: AQHctgL/4LsF194y302Jt3LvKJg8BA==
Date: Tue, 17 Mar 2026 11:41:30 +0000
Message-ID: <20260317113949.2548118-7-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AM1PEPF000252DF:EE_|AM9PR08MB5940:EE_
X-MS-Office365-Filtering-Correlation-Id: 449f9076-5e04-464c-13a9-08de841a496b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 J3nINJsGmRkgcIQ+m+nPFJKoAq8Y0zw+6iiU6bB1XIwHQ96Fss1CugoDvR0FqBzADz/gZUxywWpiuxUniyBrE912GyzRvV1Sxp7Nv39uR3MH3R6nktMziamYq+vdplOinK2uUN3RfESoaOxw5hgVBdaHE2wCkWTPtUBfKdkiXYhL7pZpuoz2tyo4WIMpqeVO2kZt9u0lgEkl9OHuYowsaK+UhwoTjZXKwW9JlM8gBJibqGxiZKp3F4s+VaKZEkcjK1dj0MgvVs+Zd2YIKYeMAZt4hEySh4zF1ey53uLC5tz6aRK+DAt/uVqtmF8lmKk6P1+wPxGgDYe6CnzDlXXE9BGpEqqnprVk3J3YSWJjS8MSPxe8l1ZkHs/3+72W91lDU76nd/fMI/bWfM+JGzVi2Ih0D9qdYcF1jxue0/dkjPNrWDAwvQmeb2Z1TV/VVOPBjSLQaoOsxY7DMdccFOgjdCq8rs1FErb/Xz1317AYQmp3wwvPutQToQ5Ekn4cfYKX6qvFuyacRBqmT28rSiN/40Tu9M/f6Ot/5HO8r0bjb/qy0X+EL1xIwTTlDIdjuPQvqAHzL2pgxFjLMEozhGGy6wL5v2MzFjKe6Q2hTuT6M29K9W+5MkUOs90C0p8rpi1Y/KUNYpa9hxkGpx1PhreqXqwRK2mmP26cLD/8TY8v2IFo5Hr/rOHt/1Txnffa/xlerDu9YHHdGKE7T6NI+X/GJjuFzoyy0lv+bjdN6XoGAlb63u3XbLUTl1KE1f+U1UzPqRTQkPZBvEjXMqratRUAx4qBHqFNmTTTVdFZ49/mybk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 EXOxczIZ2uz6gar+ZgwXRc1KUoN7wJVSHowMnUeBEdrA9kfPICXCUd0RaFs3AydkpBwlt7yRXWb2iiy/877mAiBfdW+bPaM2xR3LmLrhIUZBwOhlRPEP9XJPrgZ5yZEht6Mu2uDaownO+pm4FFjm1s3kfBVWnKkzuUq13wYph6812WeQSbO+FqGHo0d7qU0oNbMcd9wr7N9/1EeSDjaNnZEFhG4BbyDw+Jo20KQjEvQiJFxplpH8HNOiWxrtZeVkPXY7ZxJ4bgIQYVety/xYcn2Hci9dEssQwEfShwHRW8GR2nYtb7bmlPM9Y5GL2p25ztIft9ifnJIAUZh8CDHCZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9fa30342-25a0-46de-3341-08de841a21df
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|82310400026|36860700016|1800799024|35042699022|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cZ1O6N6vgkkfLvP0aSxrfnQMnt1RugVNxOyIv4D5h7eLpGvdvai0gl4LNbGfo+RL5pUM7IK/QRpN5+1c7RQ+jl/yijL4p7BKGKuZrsgDc+F+Ey9HPwLtf25o2hqAjciunCf47RFm5PaSbQ3HpTmMw7CP30+CcV7TW+5r9mBfxfSJdyxOFq7UWYGd9aIweJEYjm0wXaJDZt7njTvVjc36Vz8wmUknZYG3XToqTFgi1fjnbGIzibWjbrvw7pCWPawtJttydU3E6TMuIJ+gCBHpdbBlw4EUilwrEPYjbLB+BQKPuYKR0EbWSilxhaf4XAFP54LS0FWkkItdHsabwUKmdAFnJzq+XTZW/HyLKkp2KzJbLLPuomoPFeZCpmgJHKc8I7yCVNcxE7uqoBQTLM8BVLI+/pBd9bBPNcNwyeh7kot1Pws32fTr4bmBNd3sEFPUa7pOO9Ga2qCyAPJYn2YBSD5LxdGZTYFESzND+yUovuiQEzaQa0UXuRv84wdegHyT+LW3+nGsWt48xfeh/Nrl73Kb2dcDCTPbxgzIWb/gNXmoFCJvikhCLL59FvoSuUEy6yVig4sEvObJKTIiEzltaowTIuKO+a4BiaZhjOZIw1/i8h0inWuXP5ohr6ZlBbzpQWauny/760NVj91OM5e+K06palt3pxIJBvbTbdpTtlrHYdcocYp/iUf9tWrfNdvPxGmvwHbiRwqlL9piDHs4GW36pdSTvTwGGTmgG1+zMXNquI4uYjksszFcXlVN7xJBlgyUmIFi9H9BPSHmt/hc0A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(82310400026)(36860700016)(1800799024)(35042699022)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bclPlR9weDJG1lI5YLTqF5bCXGz76ObmW77CghDNTeit4rZgWHP8dJOQqYU9fKu4N4aSPga+ezwrPYWFUTJEXkV0qTDczwqeBPvUetIbF3nY5jrPScRh76BiaRlnnIDIvyEWJk4xJjmsr95jZg4cGpEoEsePAyC7cmTLBoqY8BURmW7EOLbOJUwJ6YdaEfLaSotINpgpYEsY4hwU60hcKigzyLMBZswTbnm8bg/3P9VblRSxxthPbmyO5inFe5x4JKy/E+s6oWA4n4ubBYnEXh4u1dkIJqMaiJ1loTYX4nZ1qK8CCInAxPv4vM0gRQ97leRk+KsQm14akfkPBdbCN3pMZKcV5khZIekdeTgf8N53zEuskTQ0cIXNRsrM8fY6RATJ67Qb/SW8fPuVygi2ZnCLAiHY4PQTvqqyLONEspOn1BOMa7UwiURjqSmpnvlJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:42:36.8002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 449f9076-5e04-464c-13a9-08de841a496b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5940

The encoding for the GICR CDNMIA system instruction is thus far unused
(and shall remain unused for the time being). However, in order to
plumb the FGTs into KVM correctly, KVM needs to be made aware of the
encoding of this system instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index f4436ecc630cd..938cdb248f83c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1052,6 +1052,7 @@
 #define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
 #define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
 #define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
=20
 /* Definitions for GIC CDAFF */
 #define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
@@ -1098,6 +1099,12 @@
 #define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
=20
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
