Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013051.outbound.protection.outlook.com [52.101.72.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E231935A952
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306776; cv=fail; b=I0bX1+4j1ihNFFPewfa0e5sv4LELeMl9E8ZyVEZpNwLyAa/75pQUldQqlbpswTe6qiVaJZTyoyf6ddJPG830qqWW8I7imYMYz6kYqm6V66PfGIJ1D/Z/Km1gjxbI7lDC2iAVrNkdOPu39gl43d4u5J20ODMeMXl6pVmMCilK7Dk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306776; c=relaxed/simple;
	bh=Gdhqg4QKPIYZHB+55lwxrDtHvViAoCPJzATJWniAtA8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VEcsP8q+NjRsHwwlBjrWPuY8rPhY60IjkMIaTkGNyxMhwlD9DNn/S0XqiQ4y6Ek5v0IqxuVzrEaIzx/f41kG3AIj+kaqUQGhNI15BHRCVfol0LIkSXqDDT8eTOMhyphLOXaTPVkuG4M1OX1s7JTKoxA+5HrmQksBI5aRSFPLZOc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TZSPzVhU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TZSPzVhU; arc=fail smtp.client-ip=52.101.72.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TZSPzVhU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TZSPzVhU"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ShWTziT2d4CTK3U6ntkEly5IqWls7hA6uTAoDBfuKE9BvLswbjME5Y0mJ/JEUmw0KoQW+C9onjMAvwKwAo8GDB9uHS3+dxnoikpUvmhyKE3BrykhbfMOUn6Npfz4oxr5Yl8aWfvI4IcZrWJh83mis0cnXy4zb+a4l0FiMZmd3yaTnahw2yEnMiDQDkBV6VY3KAbf+mFmLdoEYWCYVNp5SWG1ZSrvZn/kx/hSduSScHWYw4MlulFvbHYe2Wx+4vgBoCPPl5/s+LF6kU7WJJci7AUgtlIsjBrG2xNH8bLohfxB2sbCgzMdKaBD4WtCX7uxnjxT25ijqamClNPgdL5CRQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCTJnUv2G3fLWWtn92sN341UqER5G+D/2X6ww8sMziY=;
 b=VLzA7/JKe6HgaHG2wGdCOfkgeUNb2II/c5sHL6T5VNBU98bGkakGUFAqcKpXtGZOX8eSOS9JFf/DIZ9RzhbgsBykrqSulp/iXlaDs8ZPKrAzaWljNHsfhuGbVIThsy6mEo73WmtsYxnnScoN9etA5zoouhVFf1WVCU9++AQ72DDfw+vMnmvhIZrERqacS2UExIIp2flUlRYsZ2GtijjLxzELE7NshVwlx3Nj1M5JNZyen73NnIqEieWfmD8qNxv5wGVPOfxbLwb+ARyQ+D++c5Gx0gz0NrjVSuUP9sXKuhbhl5aYAnW8pqNl3Xfwwhe/LDJ8nKGP5QY76cTIweLQsw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCTJnUv2G3fLWWtn92sN341UqER5G+D/2X6ww8sMziY=;
 b=TZSPzVhU4gBT3XGmBpkUhr9XaGna0NjQN6RVo0kr8XDi8O4KP2HP6l90qR0dx7fVTkR0Kt45bcor0eKXHhCjm9ekCttIbNr8dgvBGL4NNSJzEBz+2+K6NdlK6z5mfGFYA030mKGXQXKx5hNPwXHASWyJ45015yQTjqUPVTTQ+xg=
Received: from AM0PR02CA0121.eurprd02.prod.outlook.com (2603:10a6:20b:28c::18)
 by DB8PR08MB5466.eurprd08.prod.outlook.com (2603:10a6:10:114::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:19:23 +0000
Received: from DU6PEPF0000B61F.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c:cafe::a2) by AM0PR02CA0121.outlook.office365.com
 (2603:10a6:20b:28c::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:19:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61F.mail.protection.outlook.com (10.167.8.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:19:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w+UV46l1ZA+U254xTKrHcIhQJxzziDx/n6WHhfwpOMn89ZOs1dZf7PVrfbQCOQ8otmayTG96c44FYn7cIXtTooZpWD5Zjl8oUeClb4lz/qCnjzlwGNmNIertxqpvxoysU+Pk/DfdBk8YStxstqOaVCXZXYqp7w0aSGcVyQ8lg4uypqOiRH9XygfKGQgRlDDvNrd5kzSXAtRJ8x2+1rfFL+Yi6ecnrzJG+z8CKl20OX9AlLBDmlvRDN7cOorCvtaHHT7HW9Z2z7O3/ynZDsF0/LbvPqeRy4gNN/vEGmNvGxBYFGw5lyETO8nbWNzsCrytTHS1x61SyA5jKsExZBM9+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCTJnUv2G3fLWWtn92sN341UqER5G+D/2X6ww8sMziY=;
 b=O6h/AbzlknAcAfu1dvli+hQdbjEbDPRMBhwE9DWvQU8KcAQ5r5pO86yyO6C4oxMcEDa/Y3TROiOJfFOOkJcX/iSZpgIByoXAtaHBvS7I9R7h8DVByBaQsL8F1aUHQgtwAKlgOfblgT2pV5xqKgq6XAi8asZkUUtxeAU+O5pkqjSURJx2TBtmbPcgC9gj3cZym4G3Tt+WomwHDXP2CdxIpY46hWGYoNOfvE2J3txq4t/7ZpXvn8K0dzdbCMr2haa92CbSLeTm3MEsnuBBFS9DLxb0aPWqWTJIQ1XJbU03v5aahnwPhgAV0A/qN7r1QJW5kpnu+dtB0KCF3I3onFnpng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCTJnUv2G3fLWWtn92sN341UqER5G+D/2X6ww8sMziY=;
 b=TZSPzVhU4gBT3XGmBpkUhr9XaGna0NjQN6RVo0kr8XDi8O4KP2HP6l90qR0dx7fVTkR0Kt45bcor0eKXHhCjm9ekCttIbNr8dgvBGL4NNSJzEBz+2+K6NdlK6z5mfGFYA030mKGXQXKx5hNPwXHASWyJ45015yQTjqUPVTTQ+xg=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:18:20 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:18:20 +0000
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
Subject: [PATCH 36/43] KVM: arm64: gic-v5: Implement save/restore mechanisms
 for ISTs
Thread-Topic: [PATCH 36/43] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHc1mF2IJ7eOwIpNE6S7FNigW8wBg==
Date: Mon, 27 Apr 2026 16:18:20 +0000
Message-ID: <20260427160547.3129448-37-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|DU6PEPF0000B61F:EE_|DB8PR08MB5466:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6e9b39-f7cc-4f6a-8e9b-08dea478be79
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003|18096099003|11006099003;
X-Microsoft-Antispam-Message-Info-Original:
 K9lP6Eyf+E5PrvNTo0u4/89+4wiCniEv0/JyAARuOc+KjCRTDflk5sn/SVMrTUBV51/6Ahh+5LNaHLzzWg04YmsH4I1EUQ9T9iLW1zp2RHLFWOMZUYHiqiHiIMehYcJDRyK+LxaryQi+tAT+i2WL7JOJBGs/6etzM9hTgSuky4U2GFgKMHRyoXZEhh9LTapL8DfR3VD0bqCJhE6aPTTy/36M/03lc8l7OqxPMSnSOJZMdK3VC6ypIo+Ov/p037SSjmNnN1Y9Pvd0PdJB4KS1kIMFYmFWs10y5owanGTJ3QwTnsDCh1sTz7g1LcQoEELogiM1f1smYOR2iOZTNZDd64JD4t+EXX9VG/hMHBrO2EH3rBGouN5maEvw1ME0a8x/wkRzRgHBbIo1aTTrI+i4L2MkRosexfpIK9jJBHrhtkVIYaFIujOjAkQidST98/AOQfuWYhWLZNCz1EB8sNEBEL2/2ZJBiAQQnDRAdtISlgefxTTBKu+pRnHejL9ZQ7rFY00CRXxI8G+HsFAD6J2BcyBw7tcjg7cR9zivPUW1sC+k/YXEEd/sHw0X0kmPUx0Ga8q3ZP03NGmN3+O3jTgQOdp+OOU6hz3kC5MfjencKWkFtGBUsK7xS3ZgEPqM0GWl8Il6DN9pUakUrlr7l745NRSN3gF2KW9F82CKyiNh27Gm6zH77f3+Qhkyemj04YDyGH8EK3E+DPwW3sMG5JdDQ+ZvJm1nYMSD9584igw+nGyzWxAvrD7skldZy+UweoMvaUtsCTKxUlo5HockdDlIVKyDgi6L2atMgy9VUd4MjRE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003)(18096099003)(11006099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ePWadlGbDmFpAdhm9iXc/bRPlshMI38ru0jw/7HgSVsvQwpxy/OOC0A0tWJvdCDE5oSA9SUH66Z4SXvNxwjIeGWOARLv8b0KcN47Mc+MGUfA2z53nw/j6tEWiFW4yNs8iOOpZClmCG/EHHomRYySh2qOK8IKqUgEAjzZTA0aBwKC3AtLRMsfAxRNRNI2oENoUw7KGyWCU8BTGx02uSu0DvLSN46cuam3IP+ymKH5FVEvOtJat1LbJ0A3vOX/gZT5h7P5h1+nvR725C9+JRcfmLr0gl4YSs6ObXRtj6Nr928u9Y25Xn9KJGe5w7JqeQ2ctEafsfFJt5pOt+9SbPngDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c089cadc-bdff-4b23-adaa-08dea4789902
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003|18096099003|11006099003;
X-Microsoft-Antispam-Message-Info:
	AEl+5nnBCqpLb0jys6cYI0DHH77AobwE8nX0FpswFer5+ou4n54EKrp3/JxthvWLIwHBzYszX5+7y80F4DOnReZNzyXJCCIn4SJ/VLyKUXtSg+4HjXsjI6oJSFnv4olqoc2SrPXPca9rbsi3iu+vdtya3csVVhLYaCQ3u1W1He7zStZrkW3rpywEmJ4MlNN/+WKuiLFliJBcwDoXefcLchFhljri9fNBU3soc2/2oQvVea/S0u5dBdYKLSoI4mQsRvnKrhyOpSnwlDL3qp9r5HcynyQOQ8g4DkNpoWiU7m/hVz8tSHDA1CpRIA6gg7mCxvDARdcn8uUVvDbdv9PtTH+IDFAF0tnFmz03bPgQO+TDfgtgc2eiuiDiLI6I+6yp22N4JngJ4+T67MaIJ9zD84Nu0CRvxprdxKoC5tGvWiJC3l+8fxMcffoQmmcF11Zs7LImgtUM/D/a5bGTvpXJQTIZFoygZONlbQyv0hV37c7L2OsbLfZoTay4JONJqH+iy5axmDn1NlBUnrWePZMzl9H0ybClBkVlras0kH/hsTKH5xc+M38uZdJDCLWfEB8KRb4tQJIzoNqvKCHBIfa7dtq8XFm5f/9LWZrbTWxAfsKaK/0UHSpRNWNtELrKoYQtcdzExlntjEPNKcN1t9jUFdRR+tfxzmRYlh7pjmHN1e64veoP80rBfJhNSrOIt5BdNjLA/3nBnMl1xdgKU4eq63BlRoLAKsMeLZqVpx/xo6pstBINlZJgDeC9hnazBczn0dOzAKAHgMw1v/NsauN86Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003)(18096099003)(11006099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PX/LsrXJ/3wUO7g9Xh+SRy/4wQ2XLgLkms1wgZB9yIcYS8Zn1nDvXXWBZ7YNQ0Vt/Pg6hoftpNWETAT3hi0CusfJrL/W8llLqKJxweRlC0px2R59EStRTjGYvAUmgkFWMixK8+NzsWVzjFvXdjoh/F3TlDNkG+rr0GShZVCGw+VPZafUTCEb5BoX5N3ftNHe5C2wJ/t6/NJMdx0YpNoMifdygiicrlUk56rPUMbqHxioKsnNpzvvKIbuNSCRFWeGv1GL8u/66K5mpDFhtx4p2PT/O3byPpyxOyaYPdEHFMxHpdYBvFahHxdibqjEynCd/kZLz/rQzz+OVNOrmw2XAeVvTzFdrhG3TDxDJPLCH4JWIqDGiOZBouui+k75Qs/l5L3zP0dh4MwOY5Q0yJ19OOsQKAerQW/AH6uvC5ISWWLIvMXe9wvsBPFQi6Qzz2cF
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:19:23.0767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6e9b39-f7cc-4f6a-8e9b-08dea478be79
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5466

When running a GICv5 VM, there are up to two ISTs that must be saved
or restored when migrating a VM.

The SPI IST is allocated by the hypervisor, as the guest presumes the
memory for the SPI state is allocated by the hardware. The LPI IST, on
the other hand, is allocated by the guest in the event that it wishes
to use LPIs. We shadow the guest's LPI IST in KVM, and therefore the
guest's memory is never directly used by the GICv5 hardware. Hence, in
both cases, the in-use ISTs are allocated by the hypervisor.

As there is no guest-allocated memory for the SPI IST, the state of
this must be saved by the VMM. Therefore, the VMM must provide a
memory buffer large enough to store/restore the SPI IST (32-bits per
SPI).

The LPI IST, if present, is stored into guest memory as the guest has
already allocated storage under the assumption that it would be used
by the GIC. Each IST Entry is written back to guest memory (skipping
metadata sections) on a save, or restored from guest memory on a
restore. The guest is only allowed to create a linear IST, so there's
a sufficiently large region of memory that is contiguous in GPA space.

On a save, the VM itself is quiesced using IRS_SAVE_VMR - this ensures
that the hardware has written all interrupt state back to the
ISTs. Following the save operation, the IRS_SAVE_VM_STATUSR is checked
to ensure that the guest has remained quiescent. In the event that it
has not, an error is propagated back to the VMM such that it can retry
the save.

On restore, the VM is first made invalid - it is not allowed to write
to any of the tables while they are valid - and then the SPI and LPI
ISTs are restored (if required) before making the VM valid again. As
part of restoring the ISTs, any pending interrupts are tracked, and
IST pending state is cleared. Once the VM is made valid, these valid
interrupts are made pending again via the GIC VDPEND system
instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 564 ++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  38 ++
 arch/arm64/kvm/vgic/vgic-v5.c        | 183 +++++++++
 arch/arm64/kvm/vgic/vgic.h           |   2 +
 include/linux/irqchip/arm-gic-v5.h   |   7 +
 5 files changed, 791 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 77fc5fb27f30d..8e909100485bf 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -431,6 +431,13 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	if (ret)
 		goto out_fail;
=20
+	/*
+	 * If we are restoring the state of a guest, we need to re-inject any
+	 * IRQs where were pending when the state of the guest was originally
+	 * saved. We use the pending_irqs list for this.
+	 */
+	INIT_LIST_HEAD(&vmi->pending_irqs);
+
 	/* Allocate and assign the VM Descriptor, if required. */
 	if (vmt_info->vmd_size !=3D 0) {
 		vmd =3D kzalloc(vmt_info->vmd_size, GFP_KERNEL);
@@ -547,9 +554,6 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	if (WARN_ON_ONCE(!vmi))
 		goto no_vmi;
=20
-	kfree(vmi->vmd_base);
-	kfree(vmi->vpet_base);
-
 	/* If we have an LPI IST, free it */
 	if (vmi->h_lpi_ist)
 		ret =3D vgic_v5_lpi_ist_free(kvm);
@@ -562,6 +566,19 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	if (ret)
 		return ret;
=20
+	kfree(vmi->vmd_base);
+	kfree(vmi->vpet_base);
+
+	/* Unlikely, but possible. Avoid leaking the memory. */
+	if (!list_empty(&vmi->pending_irqs)) {
+		struct pending_irq *pirq, *tmp;
+
+		list_for_each_entry_safe(pirq, tmp, &vmi->pending_irqs, next) {
+			list_del(&pirq->next);
+			kfree(pirq);
+		}
+	}
+
 	xa_erase(&vm_info, vm_id);
 	kfree(vmi);
=20
@@ -1191,6 +1208,7 @@ int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned i=
nt id_bits)
 	return ret;
 }
=20
+
 /* Free the LPI IST again */
 int vgic_v5_lpi_ist_free(struct kvm *kvm)
 {
@@ -1206,3 +1224,543 @@ int vgic_v5_lpi_ist_free(struct kvm *kvm)
 	else
 		return vgic_v5_two_level_ist_free(kvm, false);
 }
+
+/*
+ * Save the SPI IST to userspace-provided memory.
+ *
+ * Userspace (should have) has provided us with an appropriately sized buf=
fer
+ * that we can dump the SPI IST to. We only need to write out the architec=
ted
+ * 32-bits of the IST, and can skip any and all metadata as that is
+ * implementation specific.
+ *
+ * We only ever allocate linear ISTs for SPIs, so we stride through the IS=
T on
+ * the host (taking metadata into account, i.e., skipping it) and write th=
e
+ * lower 32-bits of each ISTE to the host provided buffer.
+ */
+int vgic_v5_save_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u32 __user *uaddr =3D (u32 __user *)(unsigned long)attr->addr;
+	unsigned int host_id_bits, host_istsz, host_l2sz;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	void *host_ist_base;
+	__le32 h_iste;
+	__le64 tmp;
+	int ret;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -ENXIO;
+
+	host_ist_base =3D vmi->h_spi_ist;
+
+	/* We don't have SPIs, but userspace is trying to save them.  */
+	if (!host_ist_base && attr->addr)
+		return -ENOENT;
+
+	/* We have SPIs but userspace isn't trying to save them. */
+	if (host_ist_base && !attr->addr)
+		return -EINVAL;
+
+	/* No SPIs and no userspace buffer: nothing to do. */
+	if (!host_ist_base && !attr->addr)
+		return 0;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[3]));
+	host_id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	host_istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	host_l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	/* We always use a Linear SPI IST on the host */
+	for (int i =3D 0; i < BIT(host_id_bits); ++i) {
+		/*
+		 * We're explictitly using a void pointer here, and reinterpret
+		 * it as __le64 as we only care about the lower 32 bits of the
+		 * entry, and not the metadata if present. This lets us stride
+		 * through the IST wil skipping the metadata.
+		 */
+		__le32 *h_iste_addr =3D host_ist_base + i * BIT(host_istsz + 2);
+
+		h_iste =3D READ_ONCE(*h_iste_addr);
+		ret =3D put_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		uaddr++;
+	}
+
+	return ret;
+}
+
+/*
+ * Save the LPI IST to guest memory
+ *
+ * When a guest is using LPIs, it has allocated memory for the LPI IST. We=
 don't
+ * let the host's IRQ directly use that memory, and instead reallocate the=
 IST
+ * on the host. However, we're able to use the memory that the guest has
+ * allocated to save the LPI IST. There should be sufficient storage there=
, and
+ * if the guest hasn't done things properly, then that's on the guest - th=
ere's
+ * nothing we can do.
+ *
+ * We only store the lower 32-bits of each host ISTE as the upper bits con=
tain
+ * the metadata, which needs to be explcitly zeroed on restore anyhow.
+ *
+ * This is a bit more complex than for the SPIs. We intentionally don't te=
ll the
+ * guest that it is allowed to create two-level ISTs, so it should have cr=
eated
+ * a linear IST for LPIs. This means that we have a contigious range in GP=
A
+ * space that we can iterate over when writing. HOWEVER, we (KVM) have the
+ * option of allocating a linear IST or a two-level IST. Hence, iteration =
is a
+ * little more complex.
+ */
+int vgic_v5_save_lpi_ist(struct kvm *kvm)
+{
+	unsigned int host_id_bits, host_istsz, host_l2sz;
+	size_t n, l2bits, h_l1_index, h_l2_index;
+	int ret, h_l1_entries, h_l2_entries;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	void *h_l2_ist_base;
+	void *host_ist_base;
+	gpa_t g_entry_addr;
+	__le32 h_iste;
+	__le64 tmp;
+
+	ret =3D vgic_v5_check_vm_id(vm_id);
+	if (ret)
+		return ret;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -ENXIO;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	/* If there is no IST to save, return without error */
+	if (!kvm->arch.vgic.vgic_v5_irs_data->ist_baser.valid &&
+		!FIELD_GET(GICV5_VMTEL2E_VALID, vmte->val[2])) {
+		return 0;
+	}
+
+	/* Host says an LPI IST exists, but we have no backing object. */
+	if (FIELD_GET(GICV5_VMTEL2E_IST_VALID, vmte->val[2]) && !vmi->h_lpi_ist)
+		return -ENXIO;
+
+	if (vmi->h_lpi_ist_structure && !vmi->h_lpi_l2_ists)
+		return -ENXIO;
+
+	/*
+	 * Assumption: the guest IST is Linear. This gives us a simple way to ite=
rate
+	 * over the guest's memory.
+	 *
+	 * Get the base address of the IST in GPA space.
+	 */
+	g_entry_addr =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.addr;
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[2]));
+	host_id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	host_istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	host_l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	/* Linear IST on the host - the simple case */
+	if (!vmi->h_lpi_ist_structure) {
+		h_l2_entries =3D BIT(host_id_bits);
+		host_ist_base =3D vmi->h_lpi_ist;
+
+		for (h_l2_index =3D 0; h_l2_index < h_l2_entries; ++h_l2_index) {
+			__le32 *h_iste_addr =3D host_ist_base + h_l2_index * BIT(host_istsz + 2=
);
+
+			h_iste =3D *h_iste_addr;
+
+			ret =3D vgic_write_guest_lock(kvm, g_entry_addr, &h_iste, sizeof(h_iste=
));
+			if (ret)
+				return ret;
+
+			/* Advance to the next guest entry */
+			g_entry_addr +=3D sizeof(h_iste);
+		}
+	} else {
+		/* And the two level case */
+		n =3D max(2, host_id_bits - ((10 - host_istsz) + (2 * host_l2sz)) + 3 - =
1);
+		l2bits =3D (10 - host_istsz) + (2 * host_l2sz);
+		h_l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+		h_l2_entries =3D BIT(l2bits);
+
+		/* For each L1 ISTE */
+		for (h_l1_index =3D 0; h_l1_index < h_l1_entries; ++h_l1_index) {
+			/*
+			 * We don't do dynamic L2 IST allocation for guest ISTs
+			 * - all of the memory is provisioned up-front to
+			 * simplify the process. If we encounter an invalid L1
+			 * ISTE things have gone wrong!
+			 */
+			if (!FIELD_GET(GICV5_ISTL1E_VALID, vmi->h_lpi_ist[h_l1_index]))
+				return -ENXIO;
+
+			/* If valid, process the L2 table. For each L2 ISTE. */
+			for (h_l2_index =3D 0; h_l2_index < h_l2_entries; ++h_l2_index) {
+
+				h_l2_ist_base =3D vmi->h_lpi_l2_ists[h_l1_index];
+				if (!h_l2_ist_base)
+					return -ENXIO;
+
+				h_iste =3D *(__le32 *)(h_l2_ist_base +
+						     h_l2_index *
+						     BIT(2 + host_l2sz));
+
+				ret =3D vgic_write_guest_lock(kvm, g_entry_addr,
+							    &h_iste, sizeof(h_iste));
+				if (ret)
+					return ret;
+
+				/* Advance to the next guest entry */
+				g_entry_addr +=3D sizeof(__le32);
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Track any SPIs and LPIs where were marked as pending at the point where=
 the
+ * IST was restored.
+ *
+ * Append any previously pending IRQs to the pending list as we need to ma=
rk
+ * them as non-pending when restoring the ISTs. These are then reinjected =
them
+ * using VDPEND prior to running the guest for the first time.
+ */
+static int vgic_v5_track_pending_irq(struct list_head *pending_irqs, u32 i=
ntid,
+				     u32 type)
+{
+	struct pending_irq *pirq;
+
+	pirq =3D kzalloc_obj(*pirq, GFP_KERNEL);
+	if (pirq =3D=3D NULL)
+		return -ENOMEM;
+
+	/* Make it in to a proper GICv5 IntID */
+	pirq->irq =3D FIELD_PREP(GICV5_HWIRQ_TYPE, type) |
+		    FIELD_PREP(GICV5_HWIRQ_ID, intid);
+
+	INIT_LIST_HEAD(&pirq->next);
+	list_add_tail(&pirq->next, pending_irqs);
+
+	return 0;
+}
+
+/*
+ * Process and sanitise each restored ISTE.
+ *
+ * When restoring the ISTs, each ISTE needs to be processed. The HWU field=
 needs
+ * to be explicitly zeroed - it is for hardware usage, and we might well b=
e on
+ * different hardware now, which may use the field differently.
+ *
+ * If interrupts are marked as pending on restore, then they need to be tr=
acked
+ * as such, and the pending state cleared. The alternative would be that t=
he
+ * hardware needs to iterate over the whole IST post restoring, but this w=
ay is
+ * cleaner and ensures that everything is tracked correctly. The pending s=
tate
+ * for each interrupt is restored prior to running the guest for the first=
 time.
+ */
+static int vgic_v5_process_iste(__le32 *iste, struct list_head *pending_ir=
qs,
+				u32 intid, u32 type)
+{
+	__le64 tmp =3D le64_to_cpu(READ_ONCE(*iste));
+	int ret =3D 0;
+
+	/* Clean up the ISTE - Zero the HWU field. */
+	tmp &=3D ~GICV5_ISTL2E_HWU;
+
+	if (FIELD_GET(GICV5_ISTL2E_PENDING, tmp)) {
+		ret =3D vgic_v5_track_pending_irq(pending_irqs, intid, type);
+		if (ret)
+			return ret;
+
+		/* Now that we've tracked it, clear the pending state */
+		tmp &=3D ~GICV5_ISTL2E_PENDING;
+	}
+
+	WRITE_ONCE(*iste, cpu_to_le64(tmp));
+
+	return ret;
+}
+
+/*
+ * Restore the SPI IST from userspace-provided buffer to the host-allocate=
d IST.
+ *
+ * The SPI has previously been saved to userspace-provided memory. Now,
+ * userspace has provided us with a buffer containing the SPI to restore. =
We
+ * need to iterate over this, and restore it to the linear SPI IST allocat=
ed by
+ * the host.
+ */
+int vgic_v5_restore_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u32 __user *uaddr =3D (u32 __user *)(unsigned long)attr->addr;
+	unsigned int host_id_bits, host_istsz, host_l2sz;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	void *host_ist_base;
+	__le32 h_iste;
+	int ret =3D 0;
+	u64 tmp;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -ENXIO;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	host_ist_base =3D vmi->h_spi_ist;
+
+	/* We don't have SPIs, but userspace is trying to restore them.  */
+	if (!host_ist_base && attr->addr)
+		return -ENOENT;
+
+	/* We have SPIs but userspace isn't trying to restore them. */
+	if (host_ist_base && !attr->addr)
+		return -EINVAL;
+
+	/* No SPIs and no userspace buffer: nothing to do. */
+	if (!host_ist_base && !attr->addr)
+		return 0;
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[3]));
+	host_id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	host_istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	host_l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	/*
+	 * The guest's SPI IST is always linear. When the SPI IST is saved, only
+	 * the architected 4 bytes for the ISTE are saved, and metadata is
+	 * not. This means that we can just linearly read the memory provided by
+	 * userspace when restoring the IST. We stride through the
+	 * host-allocated memory using the actual ISTE size, i.e, skipping
+	 * metadata sections, if present.
+	 */
+	for (int i =3D 0; i < BIT(host_id_bits); ++i) {
+		size_t host_iste_size =3D BIT(host_istsz + 2);
+		void *h_iste_addr =3D host_ist_base + i * host_iste_size;
+
+		/* Read the entry from userspace memory */
+		ret =3D get_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		/*
+		 * Clean up the entry (zeroing HWU, pending state) and track if
+		 * the interrupt was pending so that it can be re-injected
+		 * later.
+		 */
+		ret =3D vgic_v5_process_iste(&h_iste, &vmi->pending_irqs,
+					   i, GICV5_HWIRQ_TYPE_SPI);
+		if (ret)
+			return ret;
+
+		/* Finally, write the entry to the host IST, and flush it. */
+		memset(h_iste_addr, 0, host_iste_size);
+		WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+		vgic_v5_clean_inval(h_iste_addr, host_iste_size, true, true);
+
+		/* Advance to the next entry in userspace memory */
+		uaddr++;
+	}
+
+	return ret;
+}
+
+/*
+ * Restore the LPI IST from guest memory to the host-allocated LPI IST.
+ *
+ * We iterate over the guest's memory to read out the saved LPI IST. KVM t=
ells
+ * the guest that it is only allowed to create a linear IST, so the guest =
memory
+ * for the IST should be linear in GPA space.
+ *
+ * The host IST, on the other hand, is allowed to be two-level (but doesn'=
t need
+ * to be). Therefore, some care needs to be taken when restoring the entri=
es to
+ * the host's IST.
+ *
+ * Only the lower 32-bits of each ISTE are restored.
+ */
+int vgic_v5_restore_lpi_ist(struct kvm *kvm)
+{
+	unsigned int host_id_bits, host_istsz, host_l2sz;
+	size_t h_l1_index, h_l2_index, l2bits, n;
+	void *h_l2_ist_base, *host_ist_base;
+	int h_l1_entries, h_l2_entries, ret;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	gpa_t g_entry_addr;
+	__le32 h_iste;
+	__le64 tmp;
+
+	ret =3D vgic_v5_check_vm_id(vm_id);
+	if (ret)
+		return ret;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -ENXIO;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	/* If there is no IST to restore, return without error */
+	if (!kvm->arch.vgic.vgic_v5_irs_data->ist_baser.valid &&
+		!FIELD_GET(GICV5_VMTEL2E_VALID, vmte->val[2])) {
+		return 0;
+	}
+
+	/* Host says an LPI IST exists, but we have no backing object. */
+	if (FIELD_GET(GICV5_VMTEL2E_IST_VALID, vmte->val[2]) && !vmi->h_lpi_ist)
+		return -ENXIO;
+
+	if (!vmi->h_lpi_ist)
+		return -ENXIO;
+
+	if (vmi->h_lpi_ist_structure && !vmi->h_lpi_l2_ists)
+		return -ENXIO;
+
+	/* The GPA of the guest's Linear LPI IST */
+	g_entry_addr =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.addr;
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[2]));
+	host_id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	host_istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	host_l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	/* We have a Linear IST on the host */
+	if (!vmi->h_lpi_ist_structure) {
+		h_l2_entries =3D BIT(host_id_bits);
+		host_ist_base =3D vmi->h_lpi_ist;
+
+		for (h_l2_index =3D 0; h_l2_index < h_l2_entries; ++h_l2_index) {
+			size_t host_iste_size =3D BIT(host_istsz + 2);
+			void *h_iste_addr =3D host_ist_base + h_l2_index * host_iste_size;
+
+			ret =3D kvm_read_guest_lock(kvm, g_entry_addr, &h_iste, sizeof(h_iste))=
;
+			if (ret)
+				return ret;
+
+
+			/* Clear HWU, pending, and track if it WAS pending */
+			ret =3D vgic_v5_process_iste(&h_iste, &vmi->pending_irqs,
+						   h_l2_index, GICV5_HWIRQ_TYPE_LPI);
+			if (ret)
+				return ret;
+
+			/* Restore the entry to the host IST */
+			memset(h_iste_addr, 0, host_iste_size);
+			WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+			vgic_v5_clean_inval(h_iste_addr, host_iste_size, true, true);
+
+			/* Advance to the next guest entry */
+			g_entry_addr +=3D sizeof(h_iste);
+		}
+	} else {
+		/* A two-level host IST - the harder case */
+		n =3D max(2, host_id_bits - ((10 - host_istsz) + (2 * host_l2sz)) + 3 - =
1);
+		l2bits =3D (10 - host_istsz) + (2 * host_l2sz);
+		h_l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+		h_l2_entries =3D BIT(l2bits);
+
+		for (h_l1_index =3D 0; h_l1_index < h_l1_entries; ++h_l1_index) {
+			/*
+			 * If the L1 ISTE is not marked valid, something is
+			 * wrong; we don't do dynamic L2 IST allocation! Give up
+			 * immediately.
+			 */
+			if (!FIELD_GET(GICV5_ISTL1E_VALID, vmi->h_lpi_ist[h_l1_index]))
+				return -ENXIO;
+
+			h_l2_ist_base =3D vmi->h_lpi_l2_ists[h_l1_index];
+
+			for (h_l2_index =3D 0; h_l2_index < h_l2_entries; ++h_l2_index) {
+				size_t host_iste_size =3D BIT(host_istsz + 2);
+				void *h_iste_addr =3D h_l2_ist_base + h_l2_index * host_iste_size;
+
+				/* Read the guest's ISTE */
+				ret =3D kvm_read_guest_lock(kvm, g_entry_addr,
+							  &h_iste, sizeof(h_iste));
+				if (ret)
+					return ret;
+
+				/*
+				 * Clear HWU, pending, and track if it WAS
+				 * pending.
+				 */
+				ret =3D vgic_v5_process_iste(&h_iste, &vmi->pending_irqs,
+							   h_l1_index * h_l2_entries + h_l2_index,
+							   GICV5_HWIRQ_TYPE_LPI);
+				if (ret)
+					return ret;
+
+				/* Write the entry to the host's IST */
+				memset(h_iste_addr, 0, host_iste_size);
+				WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+				vgic_v5_clean_inval(h_iste_addr, host_iste_size, true, true);
+
+				/* Advance to the next guest entry */
+				g_entry_addr +=3D sizeof(h_iste);
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Any previously pending IRQs were made non-pending when restoring guest =
IST
+ * state. Now that we're ready to run, we reinject that pending state for =
each
+ * using VDPEND.
+ */
+int vgic_v5_restore_pending_irqs(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct pending_irq *pirq, *tmp;
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -ENXIO;
+
+	list_for_each_entry_safe(pirq, tmp, &vmi->pending_irqs, next) {
+		kvm_call_hyp(__vgic_v5_vdpend, pirq->irq, 1,
+			     kvm->arch.vgic.gicv5_vm.vm_id);
+
+		list_del(&pirq->next);
+		kfree(pirq);
+	}
+
+	return 0;
+}
+
+/*
+ * Called on restore failure to clean up straggling pending state.
+ */
+void vgic_v5_scrap_pending_irqs(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct pending_irq *pirq, *tmp;
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return;
+
+	list_for_each_entry_safe(pirq, tmp, &vmi->pending_irqs, next) {
+		list_del(&pirq->next);
+		kfree(pirq);
+	}
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 25e1c9fff87b4..23417e68ee24f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -7,6 +7,7 @@
 #define __KVM_ARM_VGICV5_TABLES_H__
=20
 #include <linux/irqchip/arm-gic-v5.h>
+#include <linux/list.h>
=20
 #define VM_ID_BITS_MIN	8
 #define VM_ID_BITS_MAX	16
@@ -68,6 +69,33 @@ typedef __le64 vpe_entry;
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+// L2 IST Entry
+#define GICV5_ISTL2E_PENDING	BIT(0)
+#define GICV5_ISTL2E_ACTIVE	BIT(1)
+#define GICV5_ISTL2E_HM		BIT(2)
+#define GICV5_ISTL2E_ENABLE	BIT(3)
+#define GICV5_ISTL2E_IRM	BIT(4)
+#define GICV5_ISTL2E_HWU	GENMASK(10, 9)
+#define GICV5_ISTL2E_PRIORITY	GENMASK(15, 11)
+#define GICV5_ISTL2E_IAFFID	GENMASK(31, 16)
+
+/*
+ * Save Restore Header Format
+ *
+ * Track what has been saved into the guest's IST. Specifically, we track =
if the
+ * SPI and LPI ISTs have been stored, and the number of ID bits for each. =
This
+ * can be used to figure out where these start and end in the guest's memo=
ry.
+ */
+#define GICV5_SAVE_TABLES_IRS_IST_HEADER_SPI_IST	BIT(0)
+#define GICV5_SAVE_TABLES_IRS_IST_HEADER_SPI_ID_BITS	GENMASK(5, 1)
+#define GICV5_SAVE_TABLES_IRS_IST_HEADER_LPI_IST	BIT(6)
+#define GICV5_SAVE_TABLES_IRS_IST_HEADER_LPI_ID_BITS	GENMASK(11, 7)
+
+struct pending_irq {
+	u32 irq;
+	struct list_head next;
+};
+
 struct vgic_v5_vm_info {
 	void __iomem		*vmd_base;
 	vpe_entry __iomem	*vpet_base;
@@ -79,6 +107,9 @@ struct vgic_v5_vm_info {
 	__le64			*h_lpi_ist;
 	__le64			**h_lpi_l2_ists;
 	__le64			*h_spi_ist;
+
+	/* Tracking of pending interrupts as part of IST restore */
+	struct list_head	pending_irqs;
 };
=20
 struct vgic_v5_vmt {
@@ -171,4 +202,11 @@ void vgic_v5_free_allocated_spi_ist(struct kvm *kvm);
 int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
 int vgic_v5_lpi_ist_free(struct kvm *kvm);
=20
+int vgic_v5_save_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr);
+int vgic_v5_save_lpi_ist(struct kvm *kvm);
+int vgic_v5_restore_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr)=
;
+int vgic_v5_restore_lpi_ist(struct kvm *kvm);
+int vgic_v5_restore_pending_irqs(struct kvm *kvm);
+void vgic_v5_scrap_pending_irqs(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 3e435a31b463e..ff3500a634b62 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -580,6 +580,189 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_da=
ta *data, void *vcpu_info)
 	}
 }
=20
+/*
+ * Wait for completion a write to IRS_SAVE_VMR.
+ */
+static int vgic_v5_irs_wait_for_save_vm_op(void)
+{
+	int ret;
+	u32 statusr;
+
+	ret =3D readl_relaxed_poll_timeout_atomic(
+		irs_base + GICV5_IRS_SAVE_VM_STATUSR, statusr,
+		FIELD_GET(GICV5_IRS_SAVE_VM_STATUSR_IDLE, statusr), 1,
+		USEC_PER_SEC);
+
+	if (ret =3D=3D -ETIMEDOUT) {
+		pr_err_ratelimited("Time out waiting for IRS Save VM Op\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static bool vgic_v5_irs_is_quiesced(u16 vm_id)
+{
+	int err;
+	u64 save_vmr;
+	u32 statusr;
+
+	save_vmr =3D FIELD_PREP(GICV5_IRS_SAVE_VMR_VM_ID, vm_id);
+	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_Q, 1);
+	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_S, 0);
+	irs_writeq_relaxed(save_vmr, GICV5_IRS_SAVE_VMR);
+
+	/* Wait for the operation */
+	err =3D vgic_v5_irs_wait_for_save_vm_op();
+	if (err)
+		return false;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_SAVE_VM_STATUSR);
+
+	return statusr & GICV5_IRS_SAVE_VM_STATUSR_Q;
+}
+
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret =3D 0;
+	u64 save_vmr;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		pr_err("Failed to lock VCPUs");
+		return -EBUSY;
+	}
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	save_vmr =3D FIELD_PREP(GICV5_IRS_SAVE_VMR_VM_ID, vm_id);
+	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_Q, 1);
+	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_S, 1);
+	irs_writeq_relaxed(save_vmr, GICV5_IRS_SAVE_VMR);
+
+	/* Wait for the operation */
+	ret =3D vgic_v5_irs_wait_for_save_vm_op();
+	if (ret) {
+		pr_err("Timed out");
+		goto out_unlock;
+	}
+
+	if (!vgic_v5_irs_is_quiesced(vm_id)) {
+		pr_err("Cannot save; VM not quiesced after IRS_VM_SAVER write\n");
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	/*
+	 * Serialise the SPI IST to the userspace-provided memory (address in
+	 * attr).
+	 */
+	ret =3D vgic_v5_save_spi_ist(kvm, attr);
+	if (ret) {
+		pr_err("Failed to save the SPI IST!");
+		goto out_unlock;
+	}
+
+	if (!vgic_v5_irs_is_quiesced(vm_id)) {
+		pr_err("VM is not quiesed; failed to save IST(s)\n");
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	/* Serialise the LPI IST to the guest's IST */
+	ret =3D vgic_v5_save_lpi_ist(kvm);
+	if (ret) {
+		pr_err("Failed to save the LPI IST!");
+		goto out_unlock;
+	}
+
+	if (!vgic_v5_irs_is_quiesced(vm_id)) {
+		pr_err("VM is not quiesed; failed to save IST(s)\n");
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
)
+{
+	int ret =3D 0;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	/*
+	 * The ISTs should not be written by us while the VM (or IST) is
+	 * valid. In order to safely restore, and make sure that the GIC sees
+	 * the latest and greatest state, make the VM invalid prior to
+	 * restoring.
+	 */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+	if (ret) {
+		/*
+		 * If we go wrong here, things are rather broken. VM is likely
+		 * unrunnable.
+		 */
+		goto out_unlock;
+	}
+
+	/*
+	 * Unserialise the SPI IST from the userspace-provided memory (address
+	 * in attr).
+	 */
+	ret =3D vgic_v5_restore_spi_ist(kvm, attr);
+	if (ret) {
+		pr_err("Failed to restore the SPI IST!");
+		goto out_unlock;
+	}
+
+	/* Unserialise the ISTs from the guest's IST */
+	ret =3D vgic_v5_restore_lpi_ist(kvm);
+	if (ret) {
+		pr_err("Failed to restore the LPI IST!");
+		goto out_unlock;
+	}
+
+	/* ... and make the VM Valid again */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * As part of restoring the ISTs, and previously pending interrupts have
+	 * been tracked and made non-pending. Now that the ISTs have been
+	 * restored, and the VM is valid again, restore the pending interrupts.
+	 */
+	ret =3D vgic_v5_restore_pending_irqs(kvm);
+
+out_unlock:
+	if (ret)
+		vgic_v5_scrap_pending_irqs(kvm);
+
+	mutex_unlock(&kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
 /*
  * This set of irq_chip functions is specific for doorbells.
  */
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 36604f911e089..35eb048b5a0f7 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -387,6 +387,8 @@ int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr);
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 9ea3674a6613b..431aca67f4d5f 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -322,6 +322,13 @@
 #define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
 #define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
=20
+#define GICV5_IRS_SAVE_VMR_VM_ID	GENMASK_ULL(15, 0)
+#define GICV5_IRS_SAVE_VMR_Q		BIT_ULL(62)
+#define GICV5_IRS_SAVE_VMR_S		BIT_ULL(63)
+
+#define GICV5_IRS_SAVE_VM_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SAVE_VM_STATUSR_Q	BIT(1)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
 #define GICV5_IRS_ISTL1E_SIZE		8UL
=20
--=20
2.34.1
