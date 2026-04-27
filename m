Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011030.outbound.protection.outlook.com [40.107.130.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44237351C30
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306586; cv=fail; b=DJtiE2PyX8jWhpf/4lZC27/31ivo/VlPLGNuR95mNGuqDHTVq/CROIhjqItnfNChs2cIhrv6Jws+XAw9P94NoEYz2d45WDgA0vAbX2CzOKjZq29a+QrMdWm0DAz3SvAVWdaPRgeRobEEk/0tuoiaQTxVgAA65vOstmf/thG/AuQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306586; c=relaxed/simple;
	bh=AMk4nLbITroCsIrcVhHOr0po7F42UNvOVJvhXs0aUi8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IcjnsQNi+Q5QxlqxUucpwW2StbWBdAyJB6NTp6kSM0NeFVG3M9AZDmFTWPutc/tIeCIbsEsl+CwMGcMCyjwzp3abeOqd/FZ1lz1mTO51/EvBY7SBayh6WOtHOch8bUORE1KiCfOKlRtbfQcN9L4VXEOt6TpjvteCe8GAlPO1Zvw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=poP0jT9/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=poP0jT9/; arc=fail smtp.client-ip=40.107.130.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="poP0jT9/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="poP0jT9/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=F7Vdtpd5lrGBxpJ+jOI+GIQYbycnPH6JJpE1IDwKzctPQPTkN57tBbVaVL5CdjR1jkLX3/jiwETNPXnEzG7lXbRlp1/f4T97AEP5JLFmW6w/g/ACNmyXb3ticzi3gn6DOjKtvQDbyhGfpdFSZLezeSQDFAZwGYYrWsM5ox0jzDfAWKzwp5IjKM2+UbgvNT4B1ARRByNpvVTIZjy5J3pi5HJbj/L2yfFTqd0p6MIup70TX1YfUvCCK1l+JgOjaDdhHJBfBOM6KJ/1eeMOlrPBoIsvQcumSfts8DSnCKLrtnGsni3QQQa2WMfDcknRYTnTg2x7Q/4xj6/xwSrODA5d9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zS7+pfnFbKgHXjjWPjXqcnz6y3OtayKt9PR4YO5EgVM=;
 b=sQMUTVXNklO5QcTgHP4q4v46UIODfHWE/qph8YsNNdg9e2QMAYhRIhjHqhWzhr//OukuJeIx7sUxgF44hUlm7aa/39f9fyV+K1TiZeepxZQPfO2wv9mByydeDMbpY+xoBfJA98fSc4QhJpVp1EtrnzlGfIGmj0CeLKHl5dtroEQFrdmByxMX3aC1f46zQWhZo4w4Mzt/hj2u0+wFm75f+UmVbVJSxrKuEazmkraxLgoH0pL2kWOf9wO/MJKHudq9VaPjOfudVJ4ZqdCPbP2p6TD3wl2q7Te19YY4VSmZVzrpE0Pp6K42hjVlPk0xYJE4otLzK3pt76hZtlC0P+/uUA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zS7+pfnFbKgHXjjWPjXqcnz6y3OtayKt9PR4YO5EgVM=;
 b=poP0jT9/WwEuQMGT984D3Z+EIVOmyzV0xsAA+qoy6jSKd6cgcjeY5K5XBAXaEbtfArXSZNe79oEmu9pkjvtbfFENJb7JbDQaTu5XSJp/BzNrqaMJN8JPlFGSuuZ8X4X1502EDJKr8ggSSXAx2/tIrjbvw2pxrbfXQpO0tpYrDfM=
Received: from AM0PR02CA0170.eurprd02.prod.outlook.com (2603:10a6:20b:28e::7)
 by AS8PR08MB6135.eurprd08.prod.outlook.com (2603:10a6:20b:29f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:16:20 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:20b:28e:cafe::4f) by AM0PR02CA0170.outlook.office365.com
 (2603:10a6:20b:28e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:16:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:16:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tV9UvOl3cIlCtK+qph9486RkXig/BfGUt5m99OoSbGLdH47AFowMlQBTnpvCZi011ChZXKX5SzdTw7YzgOlww5svIEe2e8MVr4GoUSuB+XVSHk16WNQBit1bJdngyMNT+nhNr1N7966SKuCDHbeNOVQUS8+zaUVKvttZe3WIj/SAxjqqd6m9M2413Cynr1Bjvm7y31G9Ydsi1D83+jY43PylHOWP9ilZyi+9YlYhfcd5dVLOvsLrKu2vxxgtp2Rc6UP4DUaOK5g4OwZ6paun0vnI/b8W/UwLzOKyS0TPxkxO4YDPgtm2qSX6NgXhYTmgoZ387CXWeI5RpnUjuCJDLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zS7+pfnFbKgHXjjWPjXqcnz6y3OtayKt9PR4YO5EgVM=;
 b=uN0U4hob54I5X5d8XhzHjSKB5ZIx2yRjjOPl1uU7eLM7eQzijZNUIEcIwlPO18Oeq1VnvoGJnLn+Fap1T2zGsEX38gWdQtTPZqylKaaX09faBQROH/90WUePlGWdbKazwI9C/3JAoIF6VROZuYwVVGYjTQK1DQeSZGsNGSXoXiwBUmqhGglTdaugAKiPLYSLfzRxbpnB9e8FP1sfldDo3Aqtd+L2Dpjnq+Uo6lp0YguB/baBYc275oHgLr2ZzswJ7gqHeQormGdC0eNl66+RUH7Cgv8U+5dDuVS6eBX5WoyB2Z+I1ATuATrfxdqlPNlIsEr2FOfQ+1Yo053CwzJT9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zS7+pfnFbKgHXjjWPjXqcnz6y3OtayKt9PR4YO5EgVM=;
 b=poP0jT9/WwEuQMGT984D3Z+EIVOmyzV0xsAA+qoy6jSKd6cgcjeY5K5XBAXaEbtfArXSZNe79oEmu9pkjvtbfFENJb7JbDQaTu5XSJp/BzNrqaMJN8JPlFGSuuZ8X4X1502EDJKr8ggSSXAx2/tIrjbvw2pxrbfXQpO0tpYrDfM=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:15:16 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:15:15 +0000
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
Subject: [PATCH 27/43] KVM: arm64: selftests: Update vGICv5 selftest to set
 IRS address
Thread-Topic: [PATCH 27/43] KVM: arm64: selftests: Update vGICv5 selftest to
 set IRS address
Thread-Index: AQHc1mEIO43b/uk3qkmHJmGwzE7G/Q==
Date: Mon, 27 Apr 2026 16:15:15 +0000
Message-ID: <20260427160547.3129448-28-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|AMS1EPF00000047:EE_|AS8PR08MB6135:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b39143-52a4-4470-2816-08dea47851b1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 qfA/p9USc1HZKTDmUEz9i7Wf9qHSwVeXWJf/fICXfSvDH8sXzsPQlKN7+vS2/xrTgcqm47gK+BGjChy5j0eZdcGxCUBkzqNUn0kRny5exaZuWfx7uwbF8rbq379XP2gTZXtbQF5YV9nHz8f35NIvj3E3KTgH4ngOi+Qeb74nBAKCH3cknciRspJU09c5pBu4V5Q3rYYkTilmia/kEo/x2gTJPm3UcK69LVqXu8gPesnQLKds6S73C19yCSY10zP17gBAqrLm1RkZQBpwxp3T1peD+dGgC3me/kV4Gqf3j7AuaIY8vh4L0cayGHHZlpVyHdoSH/JIm987s+gc6cWpbisURjMi4RIPqmc7r3ckqTeZHP1c00m2NwRNSz1Gk7MAaxusETowZGkhGE8gmetI2aH/elFLMG9h8yW4aCfaIBpWnuMNgaMeDc70/C9JVQcfQ7RYEowYR6gN42Vx2ICbOkYouqj9vflZDdvTrJuAR7haibb/74FEro0FzRm7dJ6hGWv1l2AtR9asaqFARVNquxYytwEPJkb/F46zO2Cw94qJ9clopNDZk/m3XvO4TiWy4/ZfRuKFd9Tg2LJWA8S3dBbAs+8sb/KifRxjLE/DExjRNiHSyjRsKtD6yWEyOaEhWg+7a5pGcq7/c99vMVD/MfbEFLANkIf32AMXwV1TbW6Ok+kb93UmYQl411WL89ZJWrII+tRxIefbaL3OXPHp8C+k3VQwUV8DjbhV+dr1pVQ7gfpuMm9fgAGk9b94BlyjWL3nHWprhDXywGnuN5dyVC7ldlJ3Gz9gL15+/rs3Nu8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 edx9VNqn6lqP1tZgNIu064RktpYDcrX5p7Z7u8XMgcAWouAPcKlw45ghD52Z+yTP8VYhYYG6kSP9icMcz6SmAEz9ihjBrv+DPfexdv9QXJNJklk2ilbrl9xRTrNtXuN0AWKFxZqy0hBL7rf1zdYLqGzkm4K9v6RBK9Ta28XQKMmL0GXC7d9rzuss3fAyZmi8tuOn99soH5zVxQPTu2+uNq85yvEHwn4j3jbe0gsuJXKbcU09cI7GCez4r7/dZWhiphEL1Zl8z+em16hG0GCMzZi6O7g+Qv5cRNq/zyx45BBD1Cydx9uFDLZo65xjohSEYgfIeTRymapWZRnPZarRfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3289903c-55fd-4961-122f-08dea4782af6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|376014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dI0hbKoEvrjq9slth3kYr6sB0Lw/ZYA2G9Gs2ievheaVPF1xnYhOopGyr9Zk2pe4FBQo+s+etjk8rpzJ1BDGooalCkmDaiFqMc+Cx+V0z1A642ikfvq1J61576NOTdKX76mDUMIkszfdW2wS8LJQ2OxhInt8z1XHpke/3gHsx89F5XuzgHH19AI8IDqASmW6uFIdgLz6EWJtE/fcybgS/RvrD7ptnrYvmm7GLC0hGa+mt4oAtvFsT8xmJcZrE0jWuUPo1dUFv4KdJDEefVAXieJwAlq9UvxOcnaOM91XF9bku9F5vjrCbqrtpd5zFwU4gw+uvcoJEr0UPdmixtyHx24lxMGsM3H62p7K1qvaxHQxCLUzkAZPbciW5LzOpriqGecW4IzvWTkp8GdcgPCUMNdASijgW3IM0xSJmLengia9fbYFQE+2mnnC/0TUSXpxaysiTFHNWyNCAcY/6zwLNMZDclX8WI+yOJ9FMCG75MrvdTTrt9gYQPeJNEdYsvWJu+0uNMu1sLEM6mFBrhB6CwGBpE+vx6Zh823WCfsfAAxGOkTmxSQFm/M06yas/H5MGfU5YW6e8Yiqsn5m2b1JQf1T4frd6kRuaPrfbJA7gEsgmEMAO/vefWcq/EU2x05Yk5eO16tTX0IqA0YZ8/qH4dGIeA1l3SIHY6Kx2OdGumGVEcV9EovWjrd3hDud2sCHaesuxAtjXlPd2aSqkOnIi0ktLHbzD6NkFQBDI++8fLEry4Z6qXrbx+mDNW5MOVja7hyDWie9PBuhfJlWhgpwlw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(376014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WK7qcWm/2Knfd3Cq/LZeriAcImtv6We1kZoWKtZtnuf3XQ2U9UiOohYyBRw3i6uVP95oai6OqiIiOIi+eOJCeHaFPvjctpwOhnz4miy/Ey0ANgijGb3Dq1h0AIkKJ1j0++dx6aEyZcvKpbRyqz3D5sUeLCeJCtx4LzaVQEWAep7P1iRbRZiG7qbM4g/2aTVQoR3zfG+s88mg+MjBeQKtJwV58unPvYfPCAwpQGi7VnNIFZ9zKiITuVdV3MDqbL1xAZvpgkK46CAIpOR5vUoM+yEQcxGknQ90SLImAQPZTf7xfltq9x0iA1fsaT1mYecgGoWmu+FaZHgBL/jiIaD2ZtfHAC9wNkNn/fPQTau4TLDdx5ElAWlsWS45Sd+7xexM/36IpBg5Lsk7cY3Co9oXhstPYlOvVrhZYihVUjsYk6o04Z/3To1qg2iNebLhGul0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:16:20.5826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b39143-52a4-4470-2816-08dea47851b1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6135

This selftest was added before the GICv5 IRS was supported in
KVM. Therefore, there was no address to set, and the specific UAPI
didn't even exist.

Now that the IRS is supported, and the setting of the address is
mandatory, set the address of the emulated IRS in GPA space before
initialising the vgic. Initialising a GICv5 irqchip will fail if the
IRS address has not been set by userspace.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c        | 6 ++++++
 tools/testing/selftests/kvm/include/arm64/gic_v5.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 49c57ea72eaa9..f9df49784a5ca 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -100,6 +100,7 @@ static void test_vgic_v5_ppis(uint32_t gic_dev_type)
 	struct ucall uc;
 	u64 user_ppis[2];
 	struct vm_gic v;
+	uint64_t attr;
 	int ret, i;
=20
 	v.gic_dev_type =3D gic_dev_type;
@@ -116,6 +117,11 @@ static void test_vgic_v5_ppis(uint32_t gic_dev_type)
 	for (i =3D 0; i < NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
=20
+	/* Set the address of the IRS before initialising the GIC */
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index eb523d9277cf1..c388df8f2a2b4 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -10,6 +10,9 @@
=20
 #include "processor.h"
=20
+/* GIC component base address is guest PA space */
+#define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
