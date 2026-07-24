Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012042.outbound.protection.outlook.com [52.101.66.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AA142AFA7
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890749; cv=fail; b=AjKrTLC4IwjnLEKFrJd+Vh+mlYVM/MjqDjIvHUlOoQCmuW16LQ0UxY82/ciIKFnp0v9T804CicXvt0sl+5oUUytG081ykKqz0HfiHwerP2W0DKJUl2wHOQbtUCXf3HN3W+0QsGMumxAs5uzgPGt68LYWVshAG7TWw52g2/x0OnA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890749; c=relaxed/simple;
	bh=bncYLHIuEEuNfi89Kg1blltwdz85LsQdRZTaU5OooIE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IMqxgWJs3B/WvxBp8yTnAkzps3urbrZQvCx1iUXT73BpVxw86DmsSbiShpJzaD1M/4hES9IJRecXZcmrEyFXNsOnPHsVZ4t5TmRbUECu5l6Z6Bd+Zh3zSkpsuGyVts4U9916xtrsS7Z3dB/BSMOxUAcJbilEppnWUdlneZwFPEg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VC9xW332; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VC9xW332; arc=fail smtp.client-ip=52.101.66.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VC9xW332";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VC9xW332"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hoZ7tzcTQ0Bog1yNFuTicaNBlmSxJFdpuOhWdQHvkzqoDCejM942RlmMdQ/Ec3Tc6iiSTHs/HFePuZg25PAJRMmNm2KBdejowA6s5jqJuffSEPix/bhJaRPKv97Ih0n1cKTSZWMmluRxI6QruCHvOfjQxrkiGmbckQATVTviuhJOej0ihLRbUUbVPOn03nEr2qIIhDwlXpn2u8wYpQ1YGiH3Pn3/LXPdfJxBAVz0oSrO/1UVbJ8Oi2r7Ci5TcfWYvGktitDUkDgidAC+75bYxglheFffwWqRVniKT2oBQJgX5Y9w7IrtqIzpTwqvBTWuiszMlRhM5U73V7blTIN6MA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKQNA5+F09B2cwXHtPfrVB/KluvmgKFbW86lVjEImLg=;
 b=AhPDqkN/16TDdmi7GLCo+C9H3tz+KqoNruYjlXawRY+UpsEMuHAzlIddAJtbhGkBQLBqAt1Ik1W1/P7EeLVXjH1td8xkVN+XKoUZKg9VP9JdbuuMzB09gf8NF52UTyi8VD8RqMl/wmBUpiAB8wkE1CVT6Q2mYASomyzzsmN9qbOuNgTCDX2BrQRXQ5fpvXImJzJ4VCpjIOeTcI8Pya/HZIgcVq1fap7frNGdWzLlcBmqLsc4Js+SRx90A1MLQe6W0mlXSfwXPwbV5uQW7qu71pY/cYyrH7ZwBvIUpyGwoPcvdjRaPtwDuhiUntiCxO3J/eGcdtaRwQIeeoQjuit3ng==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKQNA5+F09B2cwXHtPfrVB/KluvmgKFbW86lVjEImLg=;
 b=VC9xW33210KH3JlcaEUE+vz46CF39BudTo0kwRnv+2ZTtOx2cMez3McVnYNlb7Ta9X9lFcTTfnaEg5J5ugwyEOiq7DMxmAivyH3XMKdqvZyeIZLLw+hfUc9fVrPjuA9zZx4xNXBxlX+BFZEGbAvPHI+gxXKMFkCcMolT6r+9o1w=
Received: from DUZPR01CA0017.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::8) by DBAPR08MB5845.eurprd08.prod.outlook.com
 (2603:10a6:10:1a5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:59:00 +0000
Received: from DU6PEPF0000B621.eurprd02.prod.outlook.com
 (2603:10a6:10:46b:cafe::79) by DUZPR01CA0017.outlook.office365.com
 (2603:10a6:10:46b::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:59:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B621.mail.protection.outlook.com (10.167.8.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:59:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5ZJCZNThtMW0SWsqaNpoD2S1WQzqR7eMfVHHen3GJCU9av7SUFHVQ5U3Iz3xrW4kkk8BPpeU4qgreIVKmt1UEzQZMg9sjkvi965g3eGje31rKKyJ9Ezl56LWD6QrJ8+IPSVyCeWUzMTZuI7zAu6zRdAhJfYK0h+WecsvVmgx++k7ZieEUC1OJWR1oqiKhOcTLS+7FqXwDDK9X/WfS8MfC55l2kI4c2UJI96S+Kswn6WZBei8hX29MHqDJhMurJ7MvH0JLKqwVLR9RmAddiTTwMWEuVgbebS0Rdj77sqnnAHlFGp3s+cz+UMfHhwCBUlZVgWvKF0ENlfNxjIvmXWGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKQNA5+F09B2cwXHtPfrVB/KluvmgKFbW86lVjEImLg=;
 b=F16tYLf1YLB3M2EEbKi6hW/dyd0fzviH0kP4MO5A87VyVZT0HypFN7I8KdM7QEcWjgQIaWepKtYObUuz1/F6EmvX9kJFnxsTXmVfaH4+FNZ034kigutXIz8P84cfNtpzouxVljjmsQhrs51Mb//hz2N1uWRvtTKJeP3DXVdSzuFuOhP5DfkX8XiuM080F+IQUUL4phHYI5DQfNfa8D2bHm3IyiO67hPNcqYXCmHm9bmjyiy7O4KPuZaB44qh6TYu5IfnI6ib+AhnWdGLYzJxZJXyEoWCLWSSiCqI1KjYP9yijc41MxaDuVM/b4n8BSwQFUUKRRjaxERSfinD2YY1uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKQNA5+F09B2cwXHtPfrVB/KluvmgKFbW86lVjEImLg=;
 b=VC9xW33210KH3JlcaEUE+vz46CF39BudTo0kwRnv+2ZTtOx2cMez3McVnYNlb7Ta9X9lFcTTfnaEg5J5ugwyEOiq7DMxmAivyH3XMKdqvZyeIZLLw+hfUc9fVrPjuA9zZx4xNXBxlX+BFZEGbAvPHI+gxXKMFkCcMolT6r+9o1w=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:57:57 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:57:57 +0000
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
Subject: [PATCH v4 37/48] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Topic: [PATCH v4 37/48] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHdG1tJ9y7uvWmmjU2Dv2AqKuKqfg==
Date: Fri, 24 Jul 2026 10:57:57 +0000
Message-ID: <20260724104819.1296803-38-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|DU6PEPF0000B621:EE_|DBAPR08MB5845:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f0aa82-65d0-4512-6e67-08dee972911f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 Yq2btxWbQh8jHUNNkBMJS1CkQIUcBbTnOH23VFSosIpJQo7IPTSgMuAFb7zdboqo2V3HA+xPBU5gwTxtsC3AniigmUx3YpvyMrAYeAtihjPs+x9YU/+4HavY/1YiIW4NHLe5h4d3yNiT37xTu5HpOA8ry28wJdsKcU9DP0uasP5qmbO+uyH7speemko9DDRDwMSWXmCYvvPaLxCwsZhSMhkYv044kwhYOVR65qLbadiq5WvzJ9dlEzzJkoQNNldy7alV+RZQf3rj+n/zFZvvm2QQ41F5aAVA5pjD+MSU1MT/EnTgxQp5dSQI/Rv42aCrP0OWROGzNo9pWXSu8lkSUNGbbrV4H7/F8YxDKSYJnSAGJbGRuvx/sc0P28BzaV3L5Hju9jUUtYRuCqWIRLyJgB225wFoFMajxfqDZtmt9GR7PXkeYsI6cqbkCzNPoTBU75xY23j3zfYrqijZBpy9Mmk6gxPZn40B4uTHBpNWj9Vt/8WTE+GJtpjmE3F/9GZkMC5MlRsoz3fu9qhA4rX/SS4Lc3HcGWldkMLZM2Z69YnMJLRF+CNoAnNYF8BeMRyO01JM5ZNfWYbPpNn45xtnAvlEv2H25+57zdfzGCy7BnggB320rnvtsMKtxg5ZsQyuW+8w7WEaIOQHe/x6rq88UWoZjgxg7kZusSLF38pZtt8y3ztwqpP/S87KEMT9peBfMZ/GCop4t8ATDBaP9L7zqg9dH/35n0Bu2J9p/7lm6MQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 HiP+LmmlNU4E5b+y2kTbU6e8Xr0QOT6iZ681suFId0+tofJm9Ao8ulzA0ViJForUhSjONnqXjz4CxXPZN/lhE6CLRxxWxqsRxCxaS9/mYOWOJComaOkRDajcK4JbQ4905Zc8zTtIGQt6C+GUl4TDdGXHpLbZo7gSJm8pITNZsKqzXh+RUS80AdLdKUj+iyMtV843j9fVibDTSgRXGqG4UlIZ5w/dlJo0bNtVuPdRtqPTvJOo76Wr6D3IzHbJ5b939Y0Uy6Vb83zbi9uM4Qy820N34hdnqMqt3WrsKRokQPq17y4iH5wG92I/0rsFSZSEHd8NXgJw7t+E7bzgR1oUHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e3bf71a1-31a5-4109-17eb-08dee9726b99
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|35042699022|14060799003|1800799024|82310400026|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DX+i1WCTYIL4TZAj5XpUQRVa6aamPEYjVGkbPnvpEldm23O/cyqH1bMPLYfsnhL1M9HfLbu31EKjDdL9pgcg1ewMcl0I80M+dIxg6LsZgw9Y9K3PlaaabMWsKpzTO3jf86twq/34nMzLcU0KSwTjoTV1DlVwGCzvWARCXoobv2kqYLM13E97jyydvMno/bW0v9hLC36OpLA5RTuphLxFEncTLPg+2XuDu12yg+vL6fjUCpWwdWBF511xR65oTwJwDgjmBMfD2+xftIg6H8gUy/8gVokiqhA4x04jIO/T6AnoWyWWZsiC4cvLHUDUYmTg0HB3kcgM1PQZkMngwTmJ/LE2G35DALbPBxrkXOq1QCE9W18V5ZZDB2dhWHAXkgV7Cc77uVlCGSwdrnxuwr1Rp4rbMlqJl87dIJJ7tRzU5LMLF8tTt8RLUokjrWgVF9n36/wtScCN4ceG1tUwGsFBbiZ2Hb6S/B9Iwy4E7q/AJH9hySEYa00SJ5bEUdozdEs2nioI8SxVSQ145cToBzucrTvfA670hJgGOabMEPBdun8x0GE4pDe5wLV+NvQ+YC7iSamBDuxA96sMjGHJruAE4zaZXFDYdqmou0v0KlWmgZzPBd4MHIar/DiIDiDy54aIv6b6yoOFXavXZKaSnQ53npp6UIpWw26HTSWY4sHQ7BYcADUahCmXfn1KeQKjHFNuT8WudIzujimqf2eluVK/5Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(82310400026)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V4oObB/2z5hXTvcslpHNSUbL/p3KT+OX8k78iwXX6OG/58RPABMyNobyICecweAW7+g/fZoFDUXwIcMKBGb8EkSsX11bOYl4ZOEfW/F3p0acKg4djk07kInkA0gu24WMcRYH7KqL+gbSz1D8/Ft0M6cCyPTyvpE7jzbldXdCrJVhIKX9t36zbHudmcNP9oBcf5eQUKIlwe6VdyS9vvm5xu7Gf/Vkkc4zQYjMI4+Zxxjudn/8l/9BX8oXrg+4ECzqeyMwMUi+eNfRd2xIl63HlQtA40fgKozzmJacvkiNkBbpTfw3r92nDhOklDlj+kl1lI83UczeNYp3XymCp0kn2RMoBBVmRTrhJaQxMSQ6cQt0yUV/0+ECopqH1v9fqrkmKye41SCNprr7v3tLrd6Zp2voKQrOCl/EwYuI2oHTYod9liMhx2cFHE2T0HNeLHdG
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:59:00.2425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f0aa82-65d0-4512-6e67-08dee972911f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5845

Document the KVM_DEV_ARM_VGIC_GRP_IRS_REGS attribute group used to
read and write the virtual IRS's MMIO register state. This provides a
GICv5-specific interface for state that is conceptually similar to the
VGICv3 ITS register interface, but uses IRS terminology instead of ITS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 50d8030e2c804..c411d2195c6a0 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -149,3 +149,41 @@ Groups:
     -EBUSY   VCPU is running, or write attempted after a VCPU has run
     -EINVAL  Invalid mpidr or register value supplied
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+
+KVM_DEV_ARM_VGIC_GRP_IRS_REGS
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
+      Writes to read-only registers are ignored by the kernel except for
+      IRS_IDR0 - IRS_IDR2 and IRS_IDR5 - IRS_IDR7, which are sanity checke=
d to
+      ensure that they match a sane config.
+
+      IRS_IDR3 and IRS_IDR4 are RAZ/WI, as nested virtualization is not
+      supported.
+
+      For registers without dedicated userspace accessors, getting or sett=
ing a
+      register uses the same emulated MMIO handlers as guest reads/writes.
+      Dedicated userspace accessors may instead save or restore migration =
state
+      without triggering guest-visible side effects. For example, restorin=
g
+      IRS_IST_BASER only restores the emulated register state; any host LP=
I IST
+      allocation based on the restored IRS_IST_CFGR and IRS_IST_BASER stat=
e
+      happens when KVM_DEV_ARM_VGIC_GRP_IST is restored.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   Offset does not correspond to any supported register
+    -EFAULT  Invalid user pointer for attr->addr
+    -EINVAL  Offset is not 32-bit aligned for 32-bit MMIO registers, not
+             64-bit aligned for 64-bit registers, or the supplied register
+             value is not compatible with the configured VGICv5 IRS state
+    -EBUSY   VGIC is not initialized, or one or more VCPUs are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
