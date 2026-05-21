Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013042.outbound.protection.outlook.com [52.101.83.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1703825B0BF
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375492; cv=fail; b=NHV4pjo76mcE03cl1XUESv1pS3IXpzsOEmN1BcAWlxBZ5WxmvAH0IkykpVZ1Jl9/1zE4k/ol/b4nY9h5YZ5/0wOOdlF3s715muNTLwbghO9HjtcQJWT9DgpfForztJJKDcGrvY33b8htuP2bzpBhf++nrWIZXj9+IwSXfgV/aEc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375492; c=relaxed/simple;
	bh=CLggUEZ+fmp2DS56OQmD+Pjx3+W0K3c9eCwN2s6VecI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aVFVfRE/5rrsTzJ68DRLgj1B287DmZNMUupt4qEg1FfMI9RkYU1Z/ShOFP8uHtP8H2asW9mL3fjke678Mv+EXjdaQrDWfIdv+NzFfyM2EWWfYpsLv2s1yOL3iQim1NH7ttOV6fUXgCp8PkUg8bORNWXX6Eo7mIshUfyOlTjElGU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rXe6oW31; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rXe6oW31; arc=fail smtp.client-ip=52.101.83.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rXe6oW31";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rXe6oW31"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lB5SN7zcjn/NLePk0AjCC7WS5g8Wo+3SR/6USOkdyjL3jV6VOWIfkXcXBA7d0u84qlapM3jrBIMkr74/TCWyChU1IbOYya9brFQ2kEdJGfY29h4QHXzL6/8q0z1dD3f7xu6SckvONQXODNLLX8ohWVEye5MMcsDSGKZRbZhaN9Zbl0kWEF4UJkFzp6cAJJu8I8Jn0WC8mWxuJmzL/wTtqTBhJSnff8ZWdrqm7p2EamFrNMgFCdZBP0y2iaO6pXYUAU/G7rDgRNkJeBI1+TRsyvz62NcLevDO0lwDE0ghc8QdLJJD67KtWY/qF/PXDp31RPr5e5lxZv4QzOQtDvGGdQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZcL8iHUpX1TZqeNTv0fyVNp/WsiTKLvpggD3N8ytGk=;
 b=BA0QLnUMuP8/+2bSY4jFTsa5RXmxKzK4VZS/YRUs/rpRYvnWmiNX+67NBWTq1U4m8n3CrKfrU6hrzjW0dPpFa6HlNjSeu3SXxv4Mj1rbu0GFCi2M+Gf1wzt0keK0/cwTJRigYoUbVEgiLm6zXtC8errTIrTs5ys8DWFQ7/r6pPnrLT5tDV2hDdCfLpwBAz0ECzeMc/FSoZdHuN4C3ukC8IscnwRVh6IKg7I/SwJ8pjTjkVv5KYxfhsQ7ZuDCH0/x68rfQhIgbiN3hWzf2SePWUTwDBWGXsOeYd4PDV65ICfkxalMoXLSRWKuJcvatn8ICY7cdk61jZgh7AqlLe+4Dw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZcL8iHUpX1TZqeNTv0fyVNp/WsiTKLvpggD3N8ytGk=;
 b=rXe6oW31L8D5YOSyQm2szOJyTgHJFbafuN38yEU9VVdEyV4CnhZ1O9imKQJqZbwUCyfwYI1La4pl0dxtNc1oICb8LBtX1hEH2cATcqv/ma53hKOumaOXYW7YF4W1xYEIWrQP0Xz7Nr3B1+FkIQuYqJRDVE8QwJNglHCrqIYlHhQ=
Received: from AS4P189CA0026.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::13)
 by VI0PR08MB10488.eurprd08.prod.outlook.com (2603:10a6:800:203::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:58:06 +0000
Received: from AM3PEPF0000A799.eurprd04.prod.outlook.com
 (2603:10a6:20b:5db:cafe::4d) by AS4P189CA0026.outlook.office365.com
 (2603:10a6:20b:5db::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:58:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A799.mail.protection.outlook.com (10.167.16.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:58:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFNJMyBQ3aVoom+AzIAVgMah+6h+qIWHAGeNPjshazF0/apIfqIVyfRY3cCKBNwvQxMaddXeZNaCzrS8diRlEAfKYAWd86cbv3f++SULQ1FKKzNNXZWbaeJUAqGnxaLONIBdA2SmPbSNlusCVcGesNuAPv6vEkrTqy1JmDBZGnX+ZLMebj9H1e6EUbGK9toK/aqi0FeAsT4I0pgSyXNBQXufJ34ePj2Vl/08dVE35jIGlr2kD2j2Qpx0nQRTFTPkDRv/ufKhJV122LM2QzG2JQ9IJ/en2yWT+I3/s9GoWmLAUUiEHP1NLK2EoKPR7P/Z6RknhQlctes72Q49TKjuzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZcL8iHUpX1TZqeNTv0fyVNp/WsiTKLvpggD3N8ytGk=;
 b=LsDlbhy6rH/Q+af8ZhQJvZdlTCh0lPDr/2jo/LIfkgRnyC6+40js09zPyZdj9mT9O7Iq1+6cRHTOQub7uPD7L5ar1Q4s5xKdtBX9j2DPjcrYWbGIpstbN55er1nfG+fY5D+8xXs2fXTFXm7NbivdaU/umOnsscQO+82qHqc/jZaiB0a01aRXTDdNvEfTBt3/C7M6m0tTRtC8twmSKqkgoLirgjW1QRT+Qhd5i3DmYhKrx7m6VEDJeV2zx7cgZtPe4SzUEen5+xlicTzJtdHGhRMIKl7l0TbGjleNNiG33x27wmg6SyNwyzz4E9a/Zz0NrKhElVdREAqYy2R+LJKgNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZcL8iHUpX1TZqeNTv0fyVNp/WsiTKLvpggD3N8ytGk=;
 b=rXe6oW31L8D5YOSyQm2szOJyTgHJFbafuN38yEU9VVdEyV4CnhZ1O9imKQJqZbwUCyfwYI1La4pl0dxtNc1oICb8LBtX1hEH2cATcqv/ma53hKOumaOXYW7YF4W1xYEIWrQP0Xz7Nr3B1+FkIQuYqJRDVE8QwJNglHCrqIYlHhQ=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by PAVPR08MB9209.eurprd08.prod.outlook.com (2603:10a6:102:30a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:57:02 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:57:01 +0000
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
Subject: [PATCH v2 23/39] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Topic: [PATCH v2 23/39] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Thread-Index: AQHc6TIUkYyExMHzTkiKbyylodiFLQ==
Date: Thu, 21 May 2026 14:57:01 +0000
Message-ID: <20260521144846.1899475-24-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|PAVPR08MB9209:EE_|AM3PEPF0000A799:EE_|VI0PR08MB10488:EE_
X-MS-Office365-Filtering-Correlation-Id: c72c6ffd-5f16-4f25-6a17-08deb7495d74
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|56012099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 CmJRKDnqF2hvWG6e7HxNZL18caDFQwggqKb2N5DPjHEb8s3H8Dcf+H8MOEfiSnuIOhz/GI+Sbuz8zGdJlRTP3V807rTxU8lgn8I5v8y6XAyiRzkZtyHggi7+TYqhuUxJgnBfisjL/YHQYl/dfX8KcMB2fzJM+RlvzUIWkxX5qDPvDUTgsf9V4bgrDg6Lgpct1IHBSfUC/b1mEIhcYPGK6ncKMY6Lh6yqTQ4BlMXSJ5/d3GDo9TJwm6xP/Amg8W9H6lXr2j89ZfCT3KF4FJNx9TxdhNAGO4K+t9iySRWXSk5tJCHHr6ab3GI1AhplRMvpFj8X+WjAmkqzfZiTihuDr2JDl3WByTwxz52TBpua3uo5TwyHHTGQ+Zur212WF8jNidLk60dBImIDpHQMTMdcWeKkVgAmgYmO/FTSQmkGFdEarSt8ZygZFUZSQJ7AWFunnZ66qi9GjQeBNIa1gtiX6RbwkppUVpXoBU5W+nkvhA4310kFhuYf3ek2HVwaLxd14HQXlPvlcDhsu5Sw4tNlJA5cyZWPwwxPdF8G1FSq1zScz42YtPE32axBmb/hR91poE/rls38IMbw5f6RqZky2Z+ppc91p+PNf0Sbe4GIXuhn163gvt/ZpGWSOxOm0m9A+0LDyI3FUAq1rEJ2tqmvcDa2hy3B0lIfUeQfA09QCKmbCkqGuAH2MSwU4uR5lbpjtxnTNomxtBfjz/KEC5rA2SsL+xU6eX3Ukc80bNw8Ha15A4us+VhHpe+xaJmkDM5A
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(56012099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bXAJM8EYPsM9x7a+OK0/39RICQh7siuTHM4GVzoUl/toniaYrDkc/GSHRPdeIOnJSuFjNfyh8b0giNNp5NajtvPg7i0kHlxM5DMBY9KWYFEwbQH+lrk4RLcy7sIWualB1zk0+lwsfgmWUW7KtFxGSUUlt9Etg2MMUcKhpCQOvSWxtV5UnT0tA7M1xFRqJuYaS1iLis5y8Piuj9rb/SI4nyx7g5usTg5cl6xMM8XvhEcViDJ48byeeyeaTNZHC3+zZgZYeQzQIQjwHSqRaRnbBaqhVZyj9CR/SD9m8RU2wTXGvHqQ9n1P3ARXibk/CIDl7fwfNjSMFjWSn4cJrLMqvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9209
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fd81c29f-4085-4191-781b-08deb7493726
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|376014|36860700016|14060799003|22082099003|18002099003|56012099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	nXXkCeTFF2q5Zb/RdDyTQlIJyG7oNgFhDqZHwfSHv639IkUlVvqhrKzx1Kq40SMjSRlAqQE1pFD/C0408bnF9cROQKtGpx56BSPMLo5FWgGO9l182n9Ovqz/7sTvTbplIQrrC9pXtZXntGC8QADfVHN1ySh6+8++/N2kGz2TjYH/l/n6K8sWEObbtCZmEUbxZHfvxReOVsq0Sq0ipQ3l/SBTuyhHDFXthHB5civlW06meB+fd5J2ezNWb9as5gnxnbheNxSiXUyERjZ0KixiHAKHZO4u/Vd145SszTDyw5EFr71hz4ULDlR/LNbp/WvO+ojTnUCpHc6yO5iLukR3PJtVCSVkwfc1DfkVrtUQ3d+Ol9GgN/l1zhSyoB4CWRmbdSwCw/MDyvXWsOi3JwJ+LJ1jxJO5ptRNaHliqIYjJgrMB/BlbWoU9Bj73auH9JSk4wfaN3syJToGD3H+g6q2NtU4ivk+1UicoYdENxMy/gjFL/9iQxvGJd63gfPy8nIPchqdz0BrTtmZOCvfI7mtSW8/lRqxgaM+mjVWOnzsWGvp7RDZGl3W5es1i/FyDLJMiV+LRQUBjE8/beX0B8T1DnByzUW39BrXUXpZdV+ysGexRluBiah3TpglbTz3sQXrQ2taiDw0kY+0uz+0iQKZWCFkkIayvbUS2LLolzTlzOhfM0ooExNEhDo9m73XRk6qF+NHvvjAIkQqC7qrZB3r2jHZI9JGn6K+HRDH/eUP8cU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(376014)(36860700016)(14060799003)(22082099003)(18002099003)(56012099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6TsaqhIzLoJTkfvfX8UNnYXrSumEfKHFdrhy/OGkP8WJgY45SLGRwHmnXH3WEaIHfOlFchVYbOenhZAHwTbgyJGbsQ+/6/Fm8nOSIvq0hWDsyTP5wH4W38jAs+Q6MCqJVDO+/LUv+0EY85eocfmfrFctWmtZFUb1DIybfoAkgO1VSxs3dLsXfk4RxwKaQkTw+Y2oC6XCGLpowJ/WJAAP+0g/EQFubzgth1QiVWt3uBogxSqx8FcrOmHmr+9jAu8NA0Nz1fFzTAFpvMs42A7dQ1Iom1arssfCC0Jk1x4A2ErjG8CXD171Rn7kmr3C2z1R3MMiBwsFwDtEoZX+ceQkhDpBBtv/W6tviAGHPmAmE/TsovQtpjLQBHVrFGM/x4DRXl950znwCCTbx0DLay4znagq8pkDhAoCMDhCkr77gTkncjLpTobs7NjV7Yl8wIEY
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:58:06.0748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c72c6ffd-5f16-4f25-6a17-08deb7495d74
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10488

The GICv5 ICH_CONTEXTR_EL2 has the IRICHPPIDIS field, which allows the
hypervisor to enable/disable the HPPI selection for SPIs and
LPIs. This can be used to emulate the guest enabling/disabling the
IRS. Therefore, make the state of this controlled by the IRS enable
state. Thus, SPIs and LPIs can't be delivered to the guest, until it
enables the emulated IRS, which matches the behaviour of the real
hardware.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f481191d72eae..458afdbfe2938 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1043,6 +1043,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
=20
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
+	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
 	u16 vpe =3D vgic_v5_vpe_id(vcpu);
@@ -1059,6 +1060,7 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
 				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
=20
--=20
2.34.1
