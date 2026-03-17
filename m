Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011059.outbound.protection.outlook.com [40.107.130.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059A4347511
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748167; cv=fail; b=e9dxe2RqD7piVv5NXLGXPocbE8Pw+LAiexwqghf3ntT5YOIukzE+G7lLyJABnmxO4Fzf9Q1RBEDmKQph/IDTSBbp7q1Kgz5/W4D1z2xfI/OABCAtbzZYxUGXZxz9Gn1t4+q2gRYt4jKOgBm/tbMD0YCX1N6w2SyEA3MKp1rwE1I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748167; c=relaxed/simple;
	bh=8+M8WULq8f3gu0ziHrvllhJJxoG+HZqYtKV6aN2xPBo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CxeBUFvnaNSR5gARDBi0Lpb6eEb1ow3z7baObxyDKlSjzFQ5H96SlGR+xrqAIMzmot1oMqxZOjxIa8yuAr9Z12RS3kuBkxPVvMKL4PyaMCAJGO2XWrJoporLtcCipMWgDhSCbS1q394DQHYPirIKgA97tz4wNxNVRyA1wHECyDc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EDf96Gpc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EDf96Gpc; arc=fail smtp.client-ip=40.107.130.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EDf96Gpc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EDf96Gpc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GQqMKFklE5hF+LWmP1kHGPJ6Ozjm82ZyP5joHe6jlsyHcocSRKpqRSmKHQOqdqC8waoNJX3Yfg+5oRN3B2UvesACQURTt56fcchfg/doT9FXizidks4buoAZzDCmP/21Ax4Y1xDcyUCB+deYsGVzK2wt5dDCDB4Wnd1evWzeV+mo4tQ3qV6Oz8BY651xwfqdrWWQZ4nXXCsspyCWEV46N1cHNCl5K2CYPG/PV8Ww6MyZSvTLOkoj2gdAyxgIQ4qjy/j29ZGcxYjzSpJST8DDagV4NkoMT9FnHuEsWK9Wqwtq74o0/5Ov69SgelIeozURSid+i7LVcLmtezqlS02Kyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=dHQh/fAXMFkhBgT4ljufTgwhCdOE0jxqIDPFTOs/UvSqr6kwB7ULhhjiryX/xgEOLk/9Z5GkkD78XJq5rOitv3ABV6EZTSlRlFb7q3UUcugawudIISLivyDch+aHALuapMpwS1v+3e+STK2MyLdNBamwdA1IIjAfaTuVCTqsks0GGkc7vs78YuEGfxhlHKAxnAt+liWmYn1eaVpTvgX5HXLq/u/m2a1FRtKBUhFSrrEFOaGp3i5aztIzCmKOoUoC/dhw1qGXu4a9GF0swAdMQqq6lWD9E0e4mPXhkmA9E9/JAOTnmdkaCX4NryuNZyBa/B95zDtU11Ex+RPazGCFsw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=EDf96Gpcawuv0r1HBhHygvlj/CnC+5vTxcOKplr7uAUD0f3H9fuys/VaCCw9TjIQu8n2rc+nfTxylEz5eYP5cXtDzPPmDfRRYBJ7ehBGgY+x3uRTji+nTQW55UdbFmQVG/Ks6+dcdFIIPeljNTv9ixddqv1n8YRB21UA1G1wO+A=
Received: from AS9PR04CA0094.eurprd04.prod.outlook.com (2603:10a6:20b:50e::23)
 by AM7PR08MB5303.eurprd08.prod.outlook.com (2603:10a6:20b:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 11:49:21 +0000
Received: from AM4PEPF00025F95.EURPRD83.prod.outlook.com
 (2603:10a6:20b:50e:cafe::4) by AS9PR04CA0094.outlook.office365.com
 (2603:10a6:20b:50e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.19 via Frontend Transport; Tue,
 17 Mar 2026 11:49:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F95.mail.protection.outlook.com (10.167.16.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0 via
 Frontend Transport; Tue, 17 Mar 2026 11:49:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O5HGQVUmmhkY+rH2Qm0YRUrJnPqUtq5HTGoUguCXiEKz0cNrCF2jmTdqTrLX9sTpY65GmD/3QaGdjGN688omJTfpsdAhriDGINKvOM4leEiadNjix6oj8hiVodoEjQawfJbAQKxsph6jrQNGm9pFGuo9bRWNKQMAq5fu59OOGKRjm+TM4DOiuwMCRKMNmeaumfvvOBoKPzRrkkpcQfFQM/slyILZI7lkiSCp+fDaQxmjhvA1KJsgM+xzs/ZB+H5PTsoqOziz9LrhGPMEPq9Q2DuAHP41DSv6DJllm0SkpAkLWKe/wdApPvJajTM9Zr2gLW97nq/B5yL4OiKWunQSKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=eSRpIZqrZJcYd3T+im9xzl8l6yJe0f7IJdD3mt4DtZC7Jck1AVMFsHI6xHg5iVUXvRcWom/c49yVNw8LckSA16I1ux7/PJa+zNUsdC/vS8B7k3L0DpE+M59hm1PNyoSYeJXqY8++IvKzUBE+yUTx7wHeHpHNmgJtjQ3R7loKc5dhsISk6HQZfbXCVimcD8Zr5AKH8jBDGaG1bZsKMPbA84+NqZrq5dInaeNh4ze2oGSBmN6bJYAaHHVkak2f7OXKfeES03uamwfASPfV+QT3NJTC/own9a4J1y/zueZ5qvZThqnDX3JUYhmOrni6HaGWrLbOBPNQKDROEnTDB/Qljw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=EDf96Gpcawuv0r1HBhHygvlj/CnC+5vTxcOKplr7uAUD0f3H9fuys/VaCCw9TjIQu8n2rc+nfTxylEz5eYP5cXtDzPPmDfRRYBJ7ehBGgY+x3uRTji+nTQW55UdbFmQVG/Ks6+dcdFIIPeljNTv9ixddqv1n8YRB21UA1G1wO+A=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:48:16 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:48:16 +0000
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
Subject: [PATCH v6 32/39] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5
 guests
Thread-Topic: [PATCH v6 32/39] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV
 GICv5 guests
Thread-Index: AQHctgPxtUXEvE3580mYSgqM1wsqwQ==
Date: Tue, 17 Mar 2026 11:48:16 +0000
Message-ID: <20260317113949.2548118-33-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|AM4PEPF00025F95:EE_|AM7PR08MB5303:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c2bf37-d9b5-4c4f-aee7-08de841b3a0d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 aAUSzTTBSlfrVtUJAu2wsIJ2CT3yARQeJjeWx38FSLWBDaASybURgPxCHm80wwW+BE9h8jEyziYuXhs+TMXfsBmv5vWl0aGhK/38kv3O18ewJNWtuQJCfBIEqLm5NkhLlOpCABRstBmPmphu3ufSqbPu6MAemIijscCvMKOsLoJEpTwSM1mjrmmuovo/Ol5K+cmepqWuF2nF+EyH8uYgW82pbCAJaOLYS9PZnypNWZjaeSIDLRfVDCz3LY94V+8eCMidjDMLMm7AjII3tr6L8fNBcRak+t+VqNh3NIYFmBz6K8EYIzeBmXV5VYWJgBal0CUKZWLCilmKjLiCbmhRSfvWpfayzw3IcsDq5QZUG/L7Lk9I2Q5Cy30CNuXr+Mp0lPcjAmf8C9cs4uXzozDwg9zGEo/e+Zzb3Xlk4C0ycYjQntkNFTtVW5LVYKBikm/npUC1ysfJ0aBD2YbU6oHBhQGy19ibWHKJA6/aJtTFcGM0VEy0e4NiCWYyHs9AEYjFvNUNHzPz24z4u7m0lJ+S5mvJjr9p6HeDXlkka5dSrROG8LSmEXF4eo6FKvBGHbE3opV05E0VYVd7m1bqNp/ZgB1A8aPl+xFKYTptjoO5QWk2imnqIb7IbVN0UV0K4R3pGMHfVQ23EhE6llFlDmpDeQ28qL02unwJU9igkVpuDWJO1nww3Cr7wq0diGoxWRyECpNKhrpcfTW9kzUEohz4pVicwfH1hwewbrXsueeVcPCw0UwanF91rWvHX/iXd40J8mRJClx+rEAlfUJBH8sRISNfW509pUZhAQ1WD9W1Vwo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 iLHy0YPbd61GWUuZW2+CR3VVOcyXZ5ctt7dD2PMzPoC9q7qOAXZXMN9fz+u34r3QWCRqruVsgQndSTIgt3lVOXGWmWXvBqU9lndetrnc22nN+MI1PSFFA7vd1YPHbgQe/Vrs92shpRxNzUNxJ5nkFU1SopFYdhDadfLlxkI0AQ8rGp2lqOjqDQNwrT3u19MYvTMpW3dx9BcaPdcuy3A2NGiJJYGRwL2bLlw5Tv62vhD+cutM4jTOhRTYBpOX8RpQN7pQH4k8RZuuIV0TYwHPivW9MS0f69OO76k/sSCQdBZuMBa7QiqvIB8K6+2QjaMPxBR5naM38xc11IqIPxX94Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9095a16f-122c-434d-fc59-08de841b139a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|36860700016|82310400026|376014|14060799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	d23cY+UiZXoMa3fznmMHvWQLrFUWcNRcWO8CEujbc0QHb4T8AeXlrSJKEEegPBdjEiIUGVayB5u7jDgajMzbQEw6eIGkybMtO57O9k7cGKH50lHFg7QPwUpjdbT/kfhJXSRoZiDBXMCWLQO9rHtRu4P+Bsxs1ekJGuDH3oWWEphck2JO25g0qx3BLTF13Kt98mt6frfpbRtM6yJC9sK/JNMXJgg/3b/Xx/vyCUqLSCKbRMP4xssmw1c4lu4aMfkE4JIgxim9zJgaLaNaW8/Zz/LYuEPsrWkQ6/NckkfbRpo4mTlQKiT9p/r1rzqIPT1+xJ9o9wt/qHb7eRhQ7bsAX/MkWXBwzhprQgCopomA8M1ya94XMK8s/YINR66PQmO7IGL6F+Wbs6mxWdt4Xw2b1zXI+kR/nLXPxArK7IBUUzKBsDuZueeIZiQacT1qGPbF7mvn96vluVzpRuWfQ4xjTzC4FtS9WXj0AzaSxgmbI5R9NEbgRrFCQDSU+6vmVUEXtqz35S1ZLI6g7maBvBpsn6kwOW1qYsuknkfUEuH/OrdMEcq1qmzO3DpwXpjB0Gztud8IgdYBZ5VjXQ5thQRLtphotaBPJP1+RDb6dPreqRfWbNViBiGpj1HPvCpvXSPVQz1B+gHochR9iVh9EzQLivFHl2h5nA+UT8vnSYvAA6gDEP1ue8vPh6omlsJ2qcSNMm97PUWTymAdlIDKdEv/8p4X+G+Xregi656/tkzVicyb4Ed4bcH8NqQyT2krCJdFrA+wN5+4v14T7HplhVB/OQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(36860700016)(82310400026)(376014)(14060799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	O+Jtrta1rcknE239x+AFPZfRM7iIN0UjCegChVGIVKIvp0yG6Fq4v8hLdXzvvUm5GQt/oyYz98moMkMMNe919eKo0PPF81OmY1OzzOc8yt0xmy2gdWcQP1gg275wH1XMQFRphqTz/uTMDeGfGIGK1LZIUHd2swOTD5xjl/UDG/EXJgGr4QduzQYPabOsttWExdmHpdMgr+b81vE3IJkRvmZCa5xr99xIl3TE1MU+hPNCsi4znIPEA8jK+vHf97jOufYDwSfKIEmRnELmY8MZSeFOI7oPtQSXuSKtTlFQOlvMgYn3f+rlAAe2R0FTAj5Eslv1rYkYDj1+dV8/teec/4BLkXgG13t2aPca/WHGtRjXRiPXC/NQ0/4T4t3clz1+pFyeblmQOzp3IGfCaDM1ahFyDHxSJR0mLsXtPreiZumtJZvsGaIngvdy1WutHPM6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:49:20.5201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c2bf37-d9b5-4c4f-aee7-08de841b3a0d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5303

Currently, NV guests are not supported with GICv5. Therefore, make
sure that FEAT_GCIE is always hidden from such guests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2c43097248b21..efd5d21c7ac75 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1558,6 +1558,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 va=
l)
 			 ID_AA64PFR1_EL1_MTE);
 		break;
=20
+	case SYS_ID_AA64PFR2_EL1:
+		/* GICv5 is not yet supported for NV */
+		val &=3D ~ID_AA64PFR2_EL1_GCIE;
+		break;
+
 	case SYS_ID_AA64MMFR0_EL1:
 		/* Hide ExS, Secure Memory */
 		val &=3D ~(ID_AA64MMFR0_EL1_EXS		|
--=20
2.34.1
