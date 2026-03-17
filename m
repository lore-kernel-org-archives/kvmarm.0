Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013058.outbound.protection.outlook.com [40.107.162.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C033AE6FE
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747873; cv=fail; b=gXuUaZgSLl1NoDZYuTkhHXd/D//VmlxPCf+zEy8FDrzNH9XlYpF2ZY5hJO5fNMWCNpyb1ao6BhjmO+li7UJv0mKpHWHcBtLaqLGmlMD9gz6vUX5wYswCE7WKokbkHrPwKNh8QJ9ZgEkzGLKTI350Xp8qrmo82hEs7AfFAkgIOT0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747873; c=relaxed/simple;
	bh=vZfvSJdJVO/J79RuexdkEm2g8OcuQQnwSKOoI4iL08E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=btGisHo4PskY44sdC1/9wHkxx//EFX6Z3wHhicfKvp5sm8/NCAAsI8caif7wsT9TW1pne2ief4KBG+Ja3UqPiclceD1U7JGSfesA6WI6QmfnFy+1WkWShfg2btXU7rjyOnb3sX33I95AoMiJPoUosh8aLp6DyAa8AgfoJvN24LQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aAsAMstK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aAsAMstK; arc=fail smtp.client-ip=40.107.162.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aAsAMstK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aAsAMstK"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Vs9t/pzt5G4cvIa60Se4HhB9XNuKNXdd+hAWXUpjjVw8oXZVZtSgOe0TG+rAqM3/v8wt3ag9WDC8uMD0dRPOqTk1pybdOrxEK4TVY9BYV03obxPBmQtraKvMXEjz7K0BHgwZ/FCccZ+PqVZYB32X0pA8n4vemiQEU1fof372FIw8mQnHeD7jACAmRd9rrDgwYSYiurivqRNyn0TrZACJLpDCDx/7hCLHWWSsfV7dyR79hrx390KrQhm//hYN4omDevmlAT3vQ1gh7KhIWsFJIdRhi/oj0/ZgRli8FjYf64N64SeMtn8J8l7EQS1YMvqdwbqn2UoUtK8ivs1WuUCsYA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gV1fr7xDKilelrHlz0WNlmXL6vI+udY3zF/K8JMbtk=;
 b=uR7vjaNIKeEgCD7xLS+8yFiANNrCtQA10LMDivhvVFz2AmvWv04F+BqGMuiAQXTpOfjmZtHOt9KPkWFqwIpODbFtS11xqmSclIvGuQBYmDnwKzVb7bi8mPbXoK1olP//NNXZC8OjsNjakRpQNuwPbdNUOWVphmM1dbdvAwZiZehAgYBGXhJxHltnyTp4Lw3VG/0hJD1JJwP1I4f/G6asPi0vhBSmHtaFx2PcW/0ozIOIfrcbg3AJ8OeEyz9b5PpCGOQRdZqm25emXdmjQLzrMIs52/hruMc3KIIey1ZhsqWDqKI3sBmUVF3jHOpij2STMlYDPBD1NYJ7aABGraeB3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gV1fr7xDKilelrHlz0WNlmXL6vI+udY3zF/K8JMbtk=;
 b=aAsAMstKeD2wnIu0E8phB20iTDaICqcpG4/UBSoPApjPXkpaTXLnVQ2RLrXpb8eHR8qm+K+6NhctkpLdqZ4JzyLoD7WAGwJDLdc2xgAzP6HZCFATbKP+ccEdM6/KNmvLuXaI01P3ZbnicfxvqGlnhv/GU4uFjIc0sylAxx2hqC8=
Received: from PA7P264CA0225.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:374::8)
 by DB3PR08MB9010.eurprd08.prod.outlook.com (2603:10a6:10:42b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 11:44:23 +0000
Received: from AM4PEPF00025F9B.EURPRD83.prod.outlook.com
 (2603:10a6:102:374:cafe::72) by PA7P264CA0225.outlook.office365.com
 (2603:10a6:102:374::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:44:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9B.mail.protection.outlook.com (10.167.16.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0
 via Frontend Transport; Tue, 17 Mar 2026 11:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGqLanUjfaZFgnjZvl7UnAxUI16YLtBOZb8RDank9ff0SR1/6Ndo45DjNBFkBLLdPRbPpL041BKXsJNDChsb7Y+aZiAFw/Az/9eVSCgFBTCAA5l/pEt+oDgxDicH13YVkzubXOXwxsa5Y2pjs68o6906fshHStTUWvaYJf9b9C3WOEjtr0ECk+2UFGKgnAzwTum3SgsSJaAI367OwiCBBLeCN3U1gjWvkYvNsHWkexv4CsDQGekD7eQt2QF1UUmGn9FM4X8QEHZm2Mfwhr36GbHMF+GJcUKgSUL6qOcnQbw+T4QKgld1aE703AheeNhPzwcEb1LkL582OQps0jV82w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gV1fr7xDKilelrHlz0WNlmXL6vI+udY3zF/K8JMbtk=;
 b=UimEiMadVm5TOOd0xrGtDTaQsGU3PNVsB8xccPNJnOHHnvgbxoEEiZgBOq4f3HMAwVru47vQ3NjXh6xQKiErJGXy8AChK8PhTIaR22/BFh/yiK3fUGiAG6jRXwAcnBM5PSIjtg7+zdvkdYPXVC0Awj9MuSl4fy7Ji6Li55hj/pKc7oRsNbwH4i37dCog/Mbd9e8s4VmCh4iiPC081zKhg3wv9sfwMhsK2Qozf326F+BDcE39dnT+FrQlJm022wk/3cwWWmL+TLtwjp9AytrogAKDcQT/jKsQsUkm1G5LxJaYZbV9tSLvsDozcnDUKD7VX5wyJBIIepGRa62+iA9pIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gV1fr7xDKilelrHlz0WNlmXL6vI+udY3zF/K8JMbtk=;
 b=aAsAMstKeD2wnIu0E8phB20iTDaICqcpG4/UBSoPApjPXkpaTXLnVQ2RLrXpb8eHR8qm+K+6NhctkpLdqZ4JzyLoD7WAGwJDLdc2xgAzP6HZCFATbKP+ccEdM6/KNmvLuXaI01P3ZbnicfxvqGlnhv/GU4uFjIc0sylAxx2hqC8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:43:19 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:43:18 +0000
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
Subject: [PATCH v6 13/39] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Topic: [PATCH v6 13/39] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Index: AQHctgM/TiGSt7C0J0WxG8weR71NEQ==
Date: Tue, 17 Mar 2026 11:43:18 +0000
Message-ID: <20260317113949.2548118-14-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AM4PEPF00025F9B:EE_|DB3PR08MB9010:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b553ee7-ce79-4c89-db96-08de841a88aa
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 SxdhOQNCjZ0x5b1LJ9wglRrbGr2X+1jRs9VZq4Lx36+BQu5ONvDzhM+4WqP4V0xDXZWyTo3vJWXXcFV/e+CMG84N8wRS4m2k3zKw+Jn/qP9YfB4xG6wvd5YqyJTuWCqitoz6/TTMU7dhfE32vs3QYYxwMbnKklYr8rJPoym+rIivUTBHtaxl6ZMWSYVsvVET9HWcjV8iywpx+HHS+H+m0HHZ+Ju5KCeoJkO+ZhpxDxIGBDl9XzZAEPtlyBQbohyKkzu+IpUIL0qth3O0XqGIonY6DITZugpAfUpzwm5LG/CaK1H5fVWAC180UdZfm8PXEiyoEdIh7BtqJvQfE3zIJBUaOWP0wpaGm15p0hbVgBTVAbAFoaaipsW7vla4eyg3zd0NQN1pfByXpVjvRDOG9QirI5b1y4QgtYH/v5c7ubIOvMScILmkn2H6Ke6mX+M/rM4q/gBbfdZRQgRJsimpjck3nfuSB5E0CxOe7uLdHTT/gXgumVSGHS33jXz1iBCv4drtYayH6t/6ZjCqumFUbhOeweDf8LJsW4QT7zlvCa6bRhslgYS1WouFu/lyRQ/tF0es0+TmN2jzLW+kllK6FTWU5Nz6WIhW3nxUw2rO2wiqfqIJ8Z+fMw/SMT6vhC8yRbdrd9irDmDNX0HCPic8TNewkmC01+Bd2UXO4OCtuyOgJRt5ACY0mW+dggMZWL8WCOXATMLEWjqzH0ojDvLUiL0HKD68EYPsGcFYub7Y8KFzir7V23BDYTAhFh4/RKGBOnCd1Yo9+yx9tcgMVy70nlvBury/sqRLpVHgJvJ2S2Y=
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
 FRlcmLgba4WYTackFeSlHboKPltgk03vqKRIwV7Cf7SnoVEq+FS36IBJcRFuRAI90SW6XWl1dOW9MJm3lRfFvZmKxCmWZOKNk1+bL6coT5lr3kpuzCNuwInU/5yIrtf7wfzdEgDx8esBvaKGcTBldvHXjVL1W4r78818PBdxf0OSOeo39JfgKMrjvHz+d/zqUtiYVyqWhlZ4M6/6kgmXncs46Sdr7f0SckjG21elY+yVs+1Qiys1MY+UR2YD6xKRlc38tS47UQFoYElwqI1z060wXDne7TjUZwDDbEV14lqGYaYYKrwoHcthJxjTj4T8JyKAjJcluCX9Yi/WuIVUJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cd105083-4e08-4dc9-d3cf-08de841a6274
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|14060799003|35042699022|82310400026|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/eNYrwkPWkItBrlQhjAZamvVuptAsWLfWPCByw32HK8QmlMvC3eFd5j05Bc8U74Y/dZkPHsO63GRfhbdp7xkfKb+QtJZOiPbComX+B2VWxI/7ekiHT4OgJDK60nenGgR+GntD5xUV7pGJKWc90FVinxMcbkwJChZoRYQpRkfeHU7tvJhjSuTrtwvhUmcriA9W8tLseqNZRzDOePfScUEUr8fNRxZ/YXoc38/YYCjhhvrHzLJagAGnIqkiWSpHnYCg+DfueKWMzmLtR5DPP2V2T2g34gHJz4tzbPTObSORB7iPXjebD7ZGm3WV5NZ2lZQ51xPvG77mHeA2lxo1gCn3ROSfKzLw9eNAt++1e+icuSoveu+Li6qhBF6sQiLmqCLA9QymJHyXbhkEhUw5ju1lH90wYoq8WmUBDgh8so6DkZ5UEWDjtOzeHNwwVE91BEKV6d0InqUnuhtZnWnN3oZ148ncIRecgDflTVF/dnNrpaKFnZ2EMUzauk7cK2Gqy/QE8DzYNlZ3WXvUAT+1K622bSFbtdEKYLz+fif2girmV2AGL9gw4ouoU6E/cbKfxITl1cGnC+8pKIo7F/CoCn+wTiB0XPfVJOQm9h7tvgZjML/obVWKoVJ4Sl5LbN0ih9FDdKi48BFEmq+TnwfZXIk0yVzZ6qSPvRf6geJxR9ZWmak3UlLk635D+EeBSqbxqm2TlYAYPGP594SR4YnTVrN7kYBNPU+j3ibcdhNqBUvZXRa9WuslMcse8weusJAvFs1kSNlwtLO0nKM9gJuyCvzXA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(14060799003)(35042699022)(82310400026)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2gV4UFEt13oh+IpvxwKhq+cBCee3dJZrtz7PpGRGapkKdvAlNso2/MiQ+mDcN+bvy2CAh0RF9fY4kGaxVWiULoLQ6NJJUi/rPf9a14Mp0iReudDFN1z3Gl6Sr9epCr1WVo/WJOkS1j9glWS9GQ93uvAdbfBFxjBFL1B859cLjBARBHoBL5p3OXteiK9aK7uQa5/OuCCv5aMSucRsuqZkDPUT+F9uUsWYSR6kEqo9Yj6JefvceXdx2gbb7LgFUhkLeoOtU0reorWNGpL7TfnC5bmuoEhNneeZpVv/IEizaZh2g97qBPqiWr1IVUI0SvgPENciOJZAl/ZV8E4yOm5OZ5uKNj5SJlU1xsoR4ylbKIsegS0QNmWeizYsmGi22gH6wk4vKVEordTT7/9gnqYyuzG0/W33RgmqAoA7zJySyA5tsOJbStZqWJH73n5DOd6n
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:44:22.9157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b553ee7-ce79-4c89-db96-08de841a88aa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9010

GICv5 doesn't provide an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
providing the IAFFID to the guest. A guest access to the
ICC_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
guest accessing the host's ICC_IAFFIDR_EL1.

The virtual IAFFID is provided to the guest when it reads
ICC_IAFFIDR_EL1 (which always traps back to the hypervisor). Writes are
rightly ignored. KVM treats the GICv5 VPEID, the virtual IAFFID, and
the vcpu_id as the same, and so the vcpu_id is returned.

The trapping for the ICC_IAFFIDR_EL1 is always enabled when in a guest
context.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c    | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c  | 16 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h |  5 +++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e4ec1bda8dfcb..bac5f49fdbdef 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1684,6 +1684,14 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |=3D HDFGWTR_EL2_MDSCR_EL1;
 }
=20
+static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+
+	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1705,7 +1713,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	}
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_ich_hfgrtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cd6deaf473159..d4531457ea026 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,21 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
+				const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
+	 * is the same as the VCPU's ID.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IAFFIDR_EL1_IAFFID, vcpu->vcpu_id);
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3405,6 +3420,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2924f8211974..7b7eed69d7973 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -447,6 +447,11 @@ static inline bool kvm_has_gicv3(struct kvm *kvm)
 	return kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP);
 }
=20
+static inline bool kvm_has_gicv5(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, ID_AA64PFR2_EL1, GCIE, IMP);
+}
+
 void vgic_v3_flush_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
--=20
2.34.1
