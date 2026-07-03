Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010017.outbound.protection.outlook.com [52.101.69.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F221D433E84
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094241; cv=fail; b=C8IGg0JTqgpOMVPyJF9n0YPrEwWQ/kM/yNx1jwaE3lHJ8rAkpyEWEkAQA71cUpHJbN59mIFN78qUPTpvFRRHqSnh/n/ZY8Z09u2iwtcg7i/eOVjD/DccALl6jYdcU86KBXlQhbvhVc0qEZesgl5X7nQNRtqoIUTWcjEU9uRfxPU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094241; c=relaxed/simple;
	bh=dRcPqLQrE9a+8t0KuiyYw47GjVeijzU4IB060pAxxwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gTzuKnL0rAAeZrcOb18edv/kvYaqIGqS0rfnXQITxXokFqz4gkVwzIud4LPNTs+liDWDmb38kCpWHL+CA6mdOscNW7mrt0+dmou7TGoUsx1bSFtwxhibPucaayOll6ohyBNCUirdrVyPaJnVWae+q7GcyAscLvvE0uwSXOrbkfA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l7G03n0L; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l7G03n0L; arc=fail smtp.client-ip=52.101.69.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l7G03n0L";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l7G03n0L"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HKM3grjh6206z3+bgO1HmyJQhrrCEUALG9TXicrafGF0b0FdLVGLitSt5QPIMkJsz5rIiD6WVwrKYOExiLtA1Hl5xWNeRAxheCQYr/bPGnZtYGKn0Ca5VX1hbPYqH8mrHykK02ndVj8fW+Gvyew2VawZqgxHptGAm/GlNl+73+b6HyEwqETkHZl38MT4LC96O2WBQ0+xK/trkRwNnbaOu/0QdGSDLKximMQE5c91Fwb17ou34RvgSiXQ67JjA578xPLQL2IC3LWBgaxfAwUZrEdRg0eLV/7UtI29s+fhF0bpg20lyH01afUWfw7kJnKyVzy0lKcWzdVqzXZPhoa9ZA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mP23FGUqnSbhzQYAlqb/iY6Df0Bt8Z8QyCGQMIZwtU=;
 b=aPllhw3TncpKFENWV+KBRfUPHtuiuO5z1pVGXQOolBC7nkH2TLp6iNCvH7p3UoPA4rq4FeOBsSWXh+wHQHO0AG+5rbWWtWRup9UfmNATrtOeKlNmEX8evjXPgcWpsToVeXpwn0Nb60/CVmzCqY+Mn481mFzeUGbkteDhRVJ0W0uIDRWySLcxEbnfjTaitJYzqj6IbRWRFzuPMZLPiOxrgBa/D45pxU0OrMFXCmZmg53EFpKy1KUTwXdvJIwP2JaH9wNvC5oBzfnAAB9SeaIuK0uDTUl457d1GmQejMPHpkg3SPblU1g6NNHhSsgMHTTKnkLMAsJek3Xmz6NWADIsMw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mP23FGUqnSbhzQYAlqb/iY6Df0Bt8Z8QyCGQMIZwtU=;
 b=l7G03n0LBH4EljxrMIV/dnzjK75y1LPXtq6pD3F/03an+6w+2OKCfTXdbVN1ZJRuDOW/HTHYa7x1BZH34B6saqHFh5oaIn8866MCcBZsd2nmtQFcyk+JtDINXnTed6n6QwUNC8f7aHLK+RmN/yEzdRnH0CmvSXfmLNZXNXIZfVo=
Received: from DU7PR01CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::17) by DU0PR08MB7691.eurprd08.prod.outlook.com
 (2603:10a6:10:3a5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 15:57:11 +0000
Received: from DB5PEPF00014B8A.eurprd02.prod.outlook.com
 (2603:10a6:10:50e:cafe::12) by DU7PR01CA0048.outlook.office365.com
 (2603:10a6:10:50e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:57:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8A.mail.protection.outlook.com (10.167.8.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:57:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOyqEP4I148JEaTIn3YlB4zXQmWgcFSvcIozE5h/z5bSlxn1mog2H7F8M9H/PnUVrC6Hp0hh5YFY1yDHIrFYgqT4wZySYHH2U7eIr+e5d+EussTOY6a1N1OgTR+0NShiyZc+yeD/l6N77I9g45eWrV2KNn+NvCG1r4cmlztmTuMblwV3K/VECruGXeCpNCdACCc1GHcAs8wG0WBEWHhryCnckH43dT+kajfRHwgiYBDx0vOZaIZYGU70A1/3I5cRbdPPCYGWvkvzHx1UNtHqWXmFAskVpz3pf0reJvviIXI2pDCsmzsPSs6VvUtb0x+Z98lXUeRm8YT5hTaBQwDWQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mP23FGUqnSbhzQYAlqb/iY6Df0Bt8Z8QyCGQMIZwtU=;
 b=tREu6SJNwB2TO4twLeWsBH5ErbBt70InENjF1iRPLVEPkS2CuxFQvXNusGjeNOiUeZEyli25KbVjY0VCds1c8qqmRw0PuSrSKBDexVzamiwtR1jgOjqSIlS8eekH+GnVcIuZhKa+75CKPM4l8NkBs2HZFVTzb2K8q1qjyAftzIkWQfuzobLJeDnzPqKkryG9MSFOLVSFaSenz4k2OiEMerbfXQwFVGlj9Lzxu3yVdTUZe4sdVooTnn4vMhfL6FhSAAjhz92YTO211SG0oTxTmALdj62QAxtZN7tYiuWExMh9yIY5XMmOnbGIDK4xDROJkV1Lx+FHJWfjAszk8qu6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mP23FGUqnSbhzQYAlqb/iY6Df0Bt8Z8QyCGQMIZwtU=;
 b=l7G03n0LBH4EljxrMIV/dnzjK75y1LPXtq6pD3F/03an+6w+2OKCfTXdbVN1ZJRuDOW/HTHYa7x1BZH34B6saqHFh5oaIn8866MCcBZsd2nmtQFcyk+JtDINXnTed6n6QwUNC8f7aHLK+RmN/yEzdRnH0CmvSXfmLNZXNXIZfVo=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:56:09 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:56:09 +0000
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
Subject: [PATCH v3 11/40] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
Thread-Topic: [PATCH v3 11/40] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO
 Ops
Thread-Index: AQHdCwR2mumTBChLrEC56eoT9oUBuQ==
Date: Fri, 3 Jul 2026 15:56:09 +0000
Message-ID: <20260703154811.3355680-12-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|DB5PEPF00014B8A:EE_|DU0PR08MB7691:EE_
X-MS-Office365-Filtering-Correlation-Id: dd0d9b7d-bc86-41a4-9885-08ded91bbe86
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|3023799007|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 FH8HzBI9nYiI7IvePYwWNYr6K2852KO8BpggOPvi270t20EsLqKCtlO3B+B/dHue1cMmnV32147V83GJfNahsooHfQEH8MjmryugW/lpanIexazTlBnH8AbdVhZ8EvCvUXf/B8OzCTwRXoDnScCvJfnh3JRIBSdtxCjuoaqt+NrD6IIY+ATgNE/fgKpcnVdEGnPEFKoBu355CUsTa8rqtfweUfGEaqZ83M5JznFAcwcldHjHRAl555xpNJoGe57DmJKr92JonrMMXArtjE5w+IV1ODXGyREwOPcGEpsZDAFMmQD5GlWO1rSVqBVSDplVEhBbEt6MhEUJloJ8/28GFx6bkX/6MKfJzU3QcsUU5edv2qj+DwtvtAhv8X6a12YkBL9FmhYHJC0rOGug2Bmjz/pp3RyVBpB5qQoSWkTEmIO6X5mk1RD+DGfkx0mQ+lUje8fzUq8buigxSeDwdx3t4Y9trhXv1ZX26JN0zFhjkzrrFwOmlU/hJ0d7+SEqYH7RzT8TT858tr9Zn0s2FsV/PlOeCIrVM0oXq1mNWstt+B7pN87BkHkTuadRXEzppEE74aPRfbIp25JSsS+8xdsFdSQ3PaybUCOuC1+cAfLPleSrb3DEOWHQCiHUeXg6Xt+5Jw4MIHSBR6Ump46JFioMXT14L5+YGK4huWF8h0HMi+RZo1EDP/+EuVAVnOGl3KzW2rrmRxUSi65GaGxuSaWw+/zbVKS/IEDxlENaEYXQz0w=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(3023799007)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 iCD7ahbcQu6IqxZtHyqxi9sPlmDp16G/IZLkH9jJWIteGX1nMrzfnORuSXej682e398gPQWQUal3Ry87oMqXjKqny5VA1Eer9jYPMqbakZABWGU7zKpSU2Ndrwi9mehYBTXSeTbmOUEaPHlUYwNwoPOD4qCSRIu5pbdFHUmklDf+qy+DmDLFrdQQgrUYpIBVXzOG7IVfk+kjtUOWLAiDfJFumcCInqXkfxxxeU5yaeAUYTE9mnT9RZV+1ea6Nz/NSfxGK8FvtmF/Yb/FJL4PziDIQxFPCB2mUaGGCNLh9A+N4y0T2FJYU+usiKIZIuofHqW8TNGHXXUqnYeDM3YbJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ea2bb3bf-4e36-4398-35cc-08ded91b9967
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|14060799003|376014|82310400026|1800799024|23010399003|11063799006|56012099006|3023799007|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	j8m52YY+IP3zJLX5iplcO5cos7uatCGbtk9rHpxpnTLREhvlyEZPHVypnf+B5E7lghOMEp7RgZ+npgRy2oSmhUyXC+V4WqHu/taaRM4is6Z/uzQ0J1D+/V52Nrix2UXRBx+7G4mIBzol/T9zMQ5zpSPDLzm8DbthS3wVNzVoE7dicXFnFohecebrF5VmxHLqmIeA/D7Pv51l2hc6+okcAtAkb7UWFnQyRva7FIXTdvxu1yJJ8BBN6PMzbWukHNz4VWKvMuUjCLne5Oq4PO37HQ0wo0eUq+U1sKMORGHF9RP3v63VNmwGP6IpolM0gDAGmc8BT2h5L7sWRmNmaOMfP0x9OXLVk/O6maR3RewCKxm3nfiqnvsA/Jn4Tu4mls7q0nVhbgDxD64MO8IWBEnPGvkrY5WWCapVkdNG9+KZcKFzVnRykaVoNu+4lxGAVlzhEQ2ICuM2dtAEecEhKOJ2AsQj/5+5N756P4Z49rlPUnhvjReqQYkGSXWzOgNVejAn+1YjvwSHD4Zvi8mP9/9EyhHq+Cvyj5aPACUsMQQbWiH/+A1xhyVBGG+CxYmoe2t2LIkE7TmJ+bLzHnATxP6IBeKTBmbsYegD1VE+bYchAReNSkLNpus/2pkKk8JBN3wMpWSebDAsJNw7hnuNX4FjuWdXinOrrf+rf0+F/pZ98uKqtbALHi3//d2jl+stFspT0UeVG+aczghnsj3ng9WKpw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(14060799003)(376014)(82310400026)(1800799024)(23010399003)(11063799006)(56012099006)(3023799007)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BrvykFnD0U7laHFAq3a2Ej0TMZWBnsB89X5PQz1I8ki1Co7efsBWRXir4WEx8GEu5/k3dUbOUUt5dyGA29yAD3iQdhuNz5z5v9cQRYWRHeb0K0bZeE3yZe5Jx1ufLfndN8pGH/0A/8gseFCWzyKqteVqdJNpjFsb27ehENZx/vjKA3+vph8RGKBXCzkRgx5rRvii6bL89BD50OdMU7Frbzu94Yna5CbrClmTHu+5P0UTuF4M33FybE16bWahnH1Lop1e1XdqTHiNjM9uun7yzTW8gpdqi0jP2lnKfFztHJo1d7VoiVs1WsjYmQmXoBrm1UdMvDLG/3j9qGE815N8a+85gwxkCKfYTrkfj1q+Ltw3/E8funRSGQzsg+7y5WexjntPtxjPouemPI3F3tP/Di4p/b1XO+ZtE3j865rt5iAK4H3rzQNG9uM4TKqIe6V7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:57:11.5894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd0d9b7d-bc86-41a4-9885-08ded91bbe86
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7691

GICv5 has rules about which fields of a VMTE (or L1 VMT) may be
directly written by the host once the table is valid. This ensures
that no stale state is cached by the hardware, and provides a clear
interface for making VMs, ISTs, etc, valid.

The hypervisor is responsible for populating the VMTE for a
VM. However, it is not permitted to write the Valid bit (as the VM
table is already valid). Instead, the VM is made valid via an IRS MMIO
Op. The same applies to the ISTs - they must be made valid via the
host IRS.

This commit adds support for:

* Making level 1 VMTs valid (only), allowing for dynamic level 2 array
  allocation.
* Making VMTEs (VMs) valid or invalid
* Making SPI/LPI ISTs valid or invalid for a specific VM

As part of this commit, the following vcpu_affinity-based commands are
plumbed in:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE (and hence VM) valid
        VMTE_MAKE_INVALID - Make a single VMTE (and hence VM) invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

Note: the lack of SPI_VIST_MAKE_INVALID is intentional.

When successfully probing for a GICv5, the VMT is allocated, and is
made valid via the IRS's MMIO interface. Treat failures while
allocating or assigning the VMT as hard GICv5 probe failures. At that
point the IRS VM table state is a prerequisite for vGICv5 operation,
and falling back to the legacy path would leave the host without a
valid GICv5 VM table setup. Later failures can only fall back once the
IRS VMT state has been successfully cleared.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  53 +++++---
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic-v5.c        | 194 ++++++++++++++++++++++++++-
 3 files changed, 224 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 79b305d2d5097..ce269ae7ff6f7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -67,6 +67,21 @@ static DEFINE_XARRAY(vm_info);
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
@@ -503,25 +518,6 @@ int vgic_v5_vmte_init(struct kvm *kvm)
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
@@ -671,6 +667,18 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
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
@@ -729,8 +737,13 @@ static int vgic_v5_vmte_assign_ist(struct kvm *kvm, ph=
ys_addr_t ist_base,
 	/* Finally, mark the entry as valid */
 	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
 	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+	if (ret) {
+		WRITE_ONCE(vmte->val[section], 0ULL);
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		return ret;
+	}
=20
-	return ret;
+	return 0;
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index d0b743e8d957a..6b159a7e386cf 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -82,6 +82,7 @@ static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
=20
 int vgic_v5_vmt_allocate(unsigned int max_vpes);
 int vgic_v5_vmt_free(void);
+phys_addr_t vgic_v5_get_vmt_base(void);
=20
 int vgic_v5_allocate_vm_id(struct kvm *kvm);
 void vgic_v5_release_vm_id(struct kvm *kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 02d5e383a87ed..14adc82b65828 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -10,10 +10,14 @@
 #include <linux/irqdomain.h>
=20
 #include "vgic.h"
+#include "vgic-v5-tables.h"
=20
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
@@ -36,11 +40,32 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+/*
+ * The IRS MMIO interface is shared between all VMs, so make sure we don't=
 do
+ * anything stupid!
+ */
+static DEFINE_RAW_SPINLOCK(global_irs_lock);
+
 static u32 irs_readl_relaxed(const u32 reg_offset)
 {
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
 static void vgic_v5_irs_extract_vm_caps(const struct gic_kvm_info *info)
 {
 	u64 idr;
@@ -85,6 +110,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	int ret;
=20
 	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -105,13 +131,54 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	vgic_v5_irs_extract_vm_caps(info);
 	vgic_v5_get_implemented_ppis();
=20
+	/*
+	 * Even if the HW supports more per-VM vCPUs, artificially cap as we
+	 * can't use them all.
+	 */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
+						  VGIC_V5_MAX_CPUS);
+
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
+	ret =3D vgic_v5_irs_assign_vmt(irs_caps.two_level_vmt_support,
+				     ilog2(irs_caps.max_vms),
+				     vgic_v5_get_vmt_base());
+	if (ret) {
+		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 suppo=
rt\n");
+		vgic_v5_vmt_free();
+		return -ENODEV;
+	}
+
 	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
 						  VGIC_V5_MAX_CPUS);
=20
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
@@ -138,12 +205,13 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
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
@@ -153,18 +221,136 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
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
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
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
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
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
