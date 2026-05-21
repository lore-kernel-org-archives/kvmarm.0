Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010035.outbound.protection.outlook.com [52.101.84.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D57383996
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375060; cv=fail; b=PKR8sP1OI/nCQh5Kjw48NcvjByUtjHYYNjBPQdDhJq2GBsXwza2ictGivR/qPaTI/WHBnsWNoLfC+phK3Za85piHlZRwt4cXUtGo8KyOM29LVDjg0EYa4jqndi4xPtG5UKr/5UkCyCJbQUHV8OGiySzLb8ZmcmP68fjaVDhyOk0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375060; c=relaxed/simple;
	bh=eEKZ58LWDqVkQGUOK8T3FDS4kbPyzaLOWyT+ElRBm9k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q3zuerML0Emkfj0/OlhVm+82fqy/GztcUnndH52l2Q4q11SbR8446e1YUWL13ME1Lq1qTZ7M2I8woJLK1SBTXE6Pdd9WGY4H5Br5p7DRajQPXPR90Ja7vGTWZOwdlGqFeFLsU84Bey8mplBUzyonm03R2CjNaYkIGxOm8SAslHs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aCXMZ+YN; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aCXMZ+YN; arc=fail smtp.client-ip=52.101.84.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aCXMZ+YN";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aCXMZ+YN"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=oXknyVOp5kq856ibXI3ZMHuNfKrxgv7TZgZ4XGNMXasWtxXUf5BOdzqkeD7vgpX8BanKYjIQsADhWgZ5dkkkYjF9c+h5QZSoLc2tMzpbLbXxSpsCrYow34w2ArRkpi+QQa/1Xtp90IMbYwVyih93iTLteJkcIPdGiOcsJ+Lr3Yaxn51p1by7NnedYdESd1xupRmhKEKwiQX0tpfN3/4lIVDQMnhLQpjVFWfELBIzlxjm9IiuQzaUPOxYHTNyumt5JWi77zgwLmLkB7WsmDiL/nwxBzQGtw2Vy6QWFLLJ09pgs+UHNiBkJj16tEOHERmItVjKHI8DhHzLNUWL5q1j9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k46j4bhjG8hDUiDJpMwNflgdrnQ/RIRAGC/nr2tmKYQ=;
 b=CY4/IVYAoi7sfa8FVmJHXPxASh1WfvX5RlA/WWdaharv5N5cS7XFeb5pJ1obE//UvRzld4SGgIz6ES6HZuvAj5dJtWkFqTxQ21VVrvJZh0RYMHlvOSs7zvMGBfUHB55YBH7IBo6CBetV292imx90foHGoWVbNWeP+Ln+P8EiCYpIhqh+V8BkkLsBdD4HlBtr9y+Sv1MsdyOrsZkkXwhuvKxVCjCKwye0S6uqiZUxj1RkwmcGxiYDmQKnXTKosiaKJzLPcXJUCAFRkNZU3Q3hAyav7m4wv45MQbIPedA6IUNZkVJszzQW80ihbttgCTOj/yZggcW7RCGEZ8C0H10I0Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k46j4bhjG8hDUiDJpMwNflgdrnQ/RIRAGC/nr2tmKYQ=;
 b=aCXMZ+YNYVPHUrUYtehy9g4KVONeJx0d9+69ktGKeSA3BHq6G8cTHXAFOKa8DxNkw2mHtr2riPAu49A9syvSwSEE+QVBpyEhuVs0yqyvd9lg7xH2dNUU/PRjRtiWcFD0TJb3UbTVb6mr6WfgZj+njEwPxLsXqIZIpy75FsNHrUM=
Received: from DUZPR01CA0256.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::16) by AMDPR08MB11368.eurprd08.prod.outlook.com
 (2603:10a6:20b:71c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:50:52 +0000
Received: from DU6PEPF0000A7E0.eurprd02.prod.outlook.com
 (2603:10a6:10:4b5:cafe::3a) by DUZPR01CA0256.outlook.office365.com
 (2603:10a6:10:4b5::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:50:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E0.mail.protection.outlook.com (10.167.8.39) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:50:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdWkD+nFjUtGigcA0JlOp4jKEu3xCGHoieecMBPWTqdlnYmMRe9jJK6r9uwTV1e6/5FXABSssFuFHyrYmTUMv+AFv3bCH6QBqDB3ZWd3H0IFmjlh2gq8oGHerDgsbsSL+/tkES/nYkxnmq8bd9edLkJjr2j6u1+jYhDASx+EK5IYqbbYirL9t/rNuhYpFa4Mfh8cb6UJhu3/lwNekw7YX7DXmWF17pm5JjQ93j8AFu+FaJQndpwlTME/ilnuUi1ljPJ6GZeGSKHqhztB7Jl1nP9yYBxbbtx24JQQdCWvvlq5tsFK3dkxIJMR3Nf2uedVaoIqnBsLANK+KUdReNQJyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k46j4bhjG8hDUiDJpMwNflgdrnQ/RIRAGC/nr2tmKYQ=;
 b=N9pAIEhoxpy8BnoOrxhB53BFyJ2i5B2YRp94Cduc4TifQ25SEvfru6IHxmtYKd4ZZU9mX69wneIehSHnxSgysKiHLZwZ1J4/JrBzPXcBnlmNNEonLAcGtZ7W6WYaBU1p/i2bVL2Eb6s6lxFvcWWi+FNIpjfQEkOjuf/RgtyBl2Roo7PPbGNI0KtQOWTY6CfY5IZwWyiSAJ/AqeLswtofIhr8YlFoksg9x3p3d5p7jAS+jNoiTnoTlbyGtFjwL+YZV0KdRc+G8Txj4fzQbUZms9an1Xz7OzIGsv7Dy/w7Ne7XLczv+kG0s8b+Istu87JLc+SH1vxl/4YxWFJqhLRJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k46j4bhjG8hDUiDJpMwNflgdrnQ/RIRAGC/nr2tmKYQ=;
 b=aCXMZ+YNYVPHUrUYtehy9g4KVONeJx0d9+69ktGKeSA3BHq6G8cTHXAFOKa8DxNkw2mHtr2riPAu49A9syvSwSEE+QVBpyEhuVs0yqyvd9lg7xH2dNUU/PRjRtiWcFD0TJb3UbTVb6mr6WfgZj+njEwPxLsXqIZIpy75FsNHrUM=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:49:48 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:49:48 +0000
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
Subject: [PATCH v2 02/39] irqchip/gic-v5: Provide OF IRS config frame attrs to
 KVM
Thread-Topic: [PATCH v2 02/39] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHc6TESIsgjQ1qbnUaAfMlOMM8PRw==
Date: Thu, 21 May 2026 14:49:48 +0000
Message-ID: <20260521144846.1899475-3-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|DU6PEPF0000A7E0:EE_|AMDPR08MB11368:EE_
X-MS-Office365-Filtering-Correlation-Id: 35051040-99b4-47f7-6097-08deb7485aa8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 SHk0UvMIgp9ORMBiQYW9BjAqx03JuFCe+yXRYXRT5sdg1jcU0y6XxTKMOTTNKP2X0oc/1IehgGqZ3JO7mwCSSvqaQjt0NGt4LgYA/oah2UBSh7ASA04sdVdoL0+a0FeoXnVg4yURNXChsm+VY6Xh702zsXN2kgCJ8fnOgh0ULplHp/4CmTZ76ikKNJLrejJR39rP6m7rYnb0MoJ6X1quIrpfnP+WhJ0LfiIqNvLE2wn2q9gTIYlUXUx+WKcFT2MYd3EjwCS9gh3duLRlELAS/lroSl6BU9phYf85l6AaG+fTrvkZKC5OQ8MAnAP0iKDZA/YBgQwmt1iyWoeblV2+Ft6By8ky2+g5GoNQKyKv6zrOlE+bdyZqhQWc1h5m1WGz6fCIASBH+6bTshhcyLoNVrd/XUj1TdYzCcXU46V/ZcDX8kOina56sliqbKtJwNw8i64R7WlTOXIN8MpYgLx0MbQcrDi5nt7H1IHqMI3Wvy982j5Vs3LF/6r6aEDK0USzV8p9MYWVlm0Y1TGA3Fixk/iDuQdOIocrKK1YGVS1YW+vYuyE1TP0C3S6Zg7RpJWaBiKNAK1/uzFkTcgCslZ8CUEwBdgM2r+QUDLVASAZ7Bdhg7+enl9cNa/zCXAJKUTvktTBR24qlb6WDGqc87Q9Rt1SOwg+u0sHP5OuMV1IntRfFKqgeiFoOER0Pcym8BXgXJcgRZyOPcrgdcfefsX124DaA2A/A2fUJKtXfAZ+kDu4VuKjxImOljgmJuf2rs5a
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 CYB92ybRmBEhLI9NEyerwB/rb9zSOaC0uvOpWcvNLdB7cX7mCbtbetrr7ew9T3kttKGST49lQH5bJkV/+ZPBn44CfyYhu//xs4BD2yWBgsPK9MVuxW/uV4Yb5GK1V3QulsJ1cj9b9iLwCXBVJW3h3qwuaDS/u2bhchVwsn+f3v5oXc9fyTrxAWemy8UnpiMxzYFc3At8PUhbpOhOeDl3EHiQmVnlXPhFv5XkafAu/aJZe8ziupAK2QKOtBIeNE4F8QzjtqECDTyg68HeRG7ZqMAnpN1CqhfOZ/no6CkSx8EB2arDWo61BwmN63e814GcXdIQj16zyxDYD9000sHKjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E0.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e59c037c-89da-4566-0708-08deb74834fe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|36860700016|82310400026|376014|22082099003|18002099003|56012099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	+x6s631Baqte9D2j3PhswJMJJYOdY4lCpzPHsoQum8AWuyrh8BMxfBoCjrP9c4cY2er/vvrfzFv1HkxXEGV8HZ9y1Dd5T9VbWIAw6/lYEuUyk29iNCs5vuEI7T2NXqPkufgnjbAquZxfM6GuOgdD+xYhPlKWn5pM8ASy1zEAxS8tz4N8Q9sHjsfmjvfaLfEFWWPz9oKkjcdM00yL55JTrOxdtH8v8tH6UatEKQou4ZIvs1nqG/deqUHUsfLN2vPbm49iQ9nhhH1P2QGYQx4CcNMzfgNnT+0ym+1YLkx1hksvZGDTRuhx2A+6tcaL/ygrx7DynaxFRQUyjnB9MlAqE291kxdNX0/1gomXtk2T8as4jua+0mWbzmdKTwAKfobY7Qw1BwdDv4vEoGrNr7eA01TQsSWTb4O+QlsHHxMaNcH4ggU0RshrhTKvdJhyng8zCKjaGbXT+jgChiSLCVFNR/cLcnQLAG69F5/ga/Ul2nPOSrrYxHKggymPmglaMrEbdzzhPEbwbegsUzS9Knd7wn4kkF0IODBDgS9uckR1TeO99x1jMmxFoovOWZ9grTlUvgIGlkalQrIYV29Nqca1gix+VLKpY0VgskdWzQSKOx22j2XQ6oIiLb+Nw9Gtrl+4dBqZE59SPxkiwlpoDQ9XtfU149Rw64fgK6qy+6keZNnEFiOVJy9Pun5thEpkLtfFo2NN9oxiBs9XzzRLPaDoSRV9FYmJNfdNBP29bTA+e/s=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(36860700016)(82310400026)(376014)(22082099003)(18002099003)(56012099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	agUEnL9fvAcLVSy7vKEJ5N72T8c423I/wrsan81IdGbkWZ5SOAan/4Alj6LeYjkH5p74ReIWqEaBsqYQvqTN4Vo2/NRKvDUSeWuwIiunU40ZheFwPidKuA0tgWhBGz+6AKvwH7ncLrY+AYbjPMUzCbiwS9PV61EztGpToh6ZuHB2dB8gxpu6FbM7Sv4o1gYbx5J1wzqmr01HAwcXB/vdZSKNHrc/1kVpUGNgKKrV+pKJyapgAISeKbnqmMW7vLbWRhLCD5HFfLPjsnDGbSiGaUTp3rbTknD98NbC6IxOG5cPzfBr4HEvkgWYLeFwiuQQ1ALsEP5W3hWAtQBJdWXLliVW3GPURVBgSfACsNo4N8/WSIic3Uv7vUDru/Zys/a9d400T9tTX8/uKBv+5RyEGcmGDsMbt5GW8rQ7B6gAU5aQ9cyPX6rp6LGHBv71hwM3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:50:51.8605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35051040-99b4-47f7-6097-08deb7485aa8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E0.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11368

KVM needs to interact with the host IRS in order to, for example, make
VMs or VPEs valid. There are two potential approaches here. Either the
host irqchip driver can provide an interface, or KVM can interact
directly with the host IRS. The latter of these two is chosen as the
set of MMIO registers that KVM needs to interact with is orthogonal to
the set used by the host irqchip driver (with the exception of some of
the read-only IRS_IDRx registers).

Pass KVM a pointer to an IRS config frame - the config frame belonging
to ANY IRS is fine as long as one IRS's config frame is used
consistently - in struct gic_kvm_info. Additionally, include a flag
telling KVM whether the IRS is coherent or non-coherent in order to
make sure that KVM can do the correct cache state management, if
required.

Only OF (Device Tree) is supported with this change. ACPI is not.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c      | 7 +++++--
 drivers/irqchip/irq-gic-v5.c          | 5 +++++
 include/linux/irqchip/arm-gic-v5.h    | 3 +++
 include/linux/irqchip/arm-vgic-info.h | 5 +++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index f3fce0b1e25d9..607e066821b52 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -21,8 +21,6 @@
  */
 #define LPI_ID_BITS_LINEAR		12
=20
-#define IRS_FLAGS_NON_COHERENT		BIT(0)
-
 static DEFINE_PER_CPU_READ_MOSTLY(struct gicv5_irs_chip_data *, per_cpu_ir=
s_data);
 static LIST_HEAD(irs_nodes);
=20
@@ -50,6 +48,11 @@ static void irs_writeq_relaxed(struct gicv5_irs_chip_dat=
a *irs_data,
 	writeq_relaxed(val, irs_data->irs_base + reg_offset);
 }
=20
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void)
+{
+	return per_cpu(per_cpu_irs_data, 0);
+}
+
 /*
  * The polling wait (in gicv5_wait_for_op_s_atomic()) on a GIC register
  * provides the memory barriers (through MMIO accessors)
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 600726b5c0a46..707deabbf2f63 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1128,6 +1128,8 @@ static struct gic_kvm_info gic_v5_kvm_info __initdata=
;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
+
 	/*
 	 * If we don't have native GICv5 virtualisation support, then
 	 * we also don't have FEAT_GCIE_LEGACY - the architecture
@@ -1140,6 +1142,9 @@ static void __init gic_of_setup_kvm_info(struct devic=
e_node *node)
=20
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
+	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
+	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
+
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
=20
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index f78787e654f4c..681c5c51207d6 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -330,6 +330,8 @@ struct gicv5_irs_chip_data {
 	raw_spinlock_t		spi_config_lock;
 };
=20
+#define IRS_FLAGS_NON_COHERENT		BIT(0)
+
 static inline int gicv5_wait_for_op_s_atomic(void __iomem *addr, u32 offse=
t,
 					     const char *reg_s, u32 mask,
 					     u32 *val)
@@ -377,6 +379,7 @@ void __init gicv5_free_lpi_domain(void);
=20
 int gicv5_irs_of_probe(struct device_node *parent);
 int gicv5_irs_acpi_probe(void);
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void);
 void gicv5_irs_remove(void);
 int gicv5_irs_enable(void);
 void gicv5_irs_its_probe(void);
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index 67d9d960273b9..f05370e2debf4 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -38,6 +38,11 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
+	/* GICv5 IRS base */
+	struct {
+		void __iomem	*base;
+		bool		non_coherent;
+	}		gicv5_irs;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1
