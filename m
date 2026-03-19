Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013053.outbound.protection.outlook.com [40.107.162.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A243ECBFE
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935841; cv=fail; b=DerSpngEiJqyAGWEBXPhJFiuXkWU8n1tGtpJ0O5ilT2/wE+RU2QlBopfCVlCKKGj+5S7ZgDLZoXWH62ESNpgioE0tcPtv4Tti+8fYKqbYCelGXQAntJZHUk7AI6vXKJ3XRs1oVrdO70j8dZkvXBMubonHIF4t9adrxdBm8ZcBlg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935841; c=relaxed/simple;
	bh=UVWlQwwC1R854bqnGEU9Ro4ctCWU5wfuxRRLnh8QBL4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aIOIfLgpEKls7BkVp8933DoaiIpkUcYRN3AdUJUpj69MA0gkClcHvYfq3JCmkXCby9LKe/hfpWjnYKIXGYMna7RMF7A9l6HrEWa1vd7Poj5aOtSRRPc/Bg9MKTkDxNaF+L0kKxwLiLFRQnTNGzHIdyemTqhiczFDCam/n2ER7d0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BJ+gmtIc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BJ+gmtIc; arc=fail smtp.client-ip=40.107.162.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BJ+gmtIc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BJ+gmtIc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TvvOl5gmPsXNabdERx9ygc2G8vd+cSBE/OWzQKYBl66qgzv4Mz7RRGKMCvaCUQSiDWSbiUHaMv7nMRS+iUSG9xGbLWZRqEyC9Wc91yIPikoK4dG9XZPMP2mFkSn8FpxMIddzywlcKUc3aKesn/9gnlVXNVnDtPnB7BKDMS9lERx+OrFekjsiAjtYVfjtWQqq6LqKpRFv6RrD7TeswNplLC6RAvXnkVWvJjT2aTH3LrF6njEk7PzXgSFvOKFsSfJW/BhwK0Os+3lzxxWdj3rA4ZwlHXLQn5RKXWC89zU5sDA7nUJE7SX8UZJTFRDwMRqLsG+iFhGV1yFNOKndVBDOFA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nh8L3ZlbV2rO8wo4KdiSdlNzMYNkCaSh1PPMYIDsJAE=;
 b=euv8uKifISV08GdkT4pSuBnW70Wg8spwGabobSL7MtmSPztApypjfXQS30R2awIbaCIHbMfsmzT7yPopBZqsLBp6mrs2/sRCQbQrZrdAHH6Z3momgI0nmi25O+pwdyKK2DqfoKCwWqkfrumwIpcdQ3kotQDjkgspZ3vLPwYCbqHEw3QLWkSgaMG3nI5pSDTC3aiKESYURVkDglt4yoJa8GfspSlL8r3e3tDHQdsVV5hT1K+3jdbRxUbpaxses4HcsSsP8/yDHS83lFqv3s0LCNhlj8x2T7c5QcHli6fC4kbblFmwLwKABGUmiCF6+6aCZ6wrRf5waPNPtLpKGTRJMw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh8L3ZlbV2rO8wo4KdiSdlNzMYNkCaSh1PPMYIDsJAE=;
 b=BJ+gmtIcOfnnKWrdxQc6bUkUcb23yVy/NoLH3YUthrSlzynNFLIF1YxMLA/IjUhrTBzlLejty6ez7VX5Vgp96XaE4GRgUfFl5uEv7EMG4Q4TuZWqzHZJNAzPaDEnVIyNrK7EsnEeosAsWWDtmMkhJryxKZQkea3dBpJUHrYP9jI=
Received: from AS9PR04CA0170.eurprd04.prod.outlook.com (2603:10a6:20b:530::14)
 by DB9PR08MB6700.eurprd08.prod.outlook.com (2603:10a6:10:2a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:57:16 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:530:cafe::9) by AS9PR04CA0170.outlook.office365.com
 (2603:10a6:20b:530::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:57:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:57:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=taDULOkLV31OMY9KkWbLT5IsbRJEBoEy8CVHKWnsZ4OBf0KDGzR5f6MAHA3siUOe7vGkE0OpUb4DACEn8uOXlZ4uhQrjzuxu0x0FUM+6M924YVVNxknsPd9Ez1Bx7PALUgB6L0HuhSLXGVYvHxIkNMiulPPdFJwDZZOF/jbmiId1tlRW0qPq0OoeZxbXN6cS2kyvjmz8p9QkH1guSlzDb04Ke2Q6/zpHgA7WvaKhstSoOrQQqK4EL33zE1s4zSTU18GnBzY0VtpltpcXf3xuCIivbTFM8Ux0hZRryroKzZkUGWnLavol5Wvq9a0JXR3Q/TcvmUpN8+VjvA6deFvn3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nh8L3ZlbV2rO8wo4KdiSdlNzMYNkCaSh1PPMYIDsJAE=;
 b=GLAgqU30smQdimS/0V6R+ZNbUKgr+BBbV9lE0NvH1fkZ/Zim3y4x/HriNGbK+ibmn7FJ6CdGjeID5otIutWEAaBwUMVwWL4c6UjfT/HwsXUj0bMv7gPulioQHLdV2wL3HX9IoLkMlc5OhrnEPCsNGelyDiKuzEYlCn697UIjMjDqXo2KBw0LQ8xk+BIJExnhEbWeMdWeRNMKKKL2Whd86Kz6HKcvcr6q2kqetzdpiSvcFyfs+sZFckR2KSlay6tfuD9OEMmTmu1twkW9ZaSX9c7hwJv/Zzih/d0jJx+fEBs1gOs3p4472Uj6tQ8ahMiLElK96Zti5xWDXSlrnf/doQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh8L3ZlbV2rO8wo4KdiSdlNzMYNkCaSh1PPMYIDsJAE=;
 b=BJ+gmtIcOfnnKWrdxQc6bUkUcb23yVy/NoLH3YUthrSlzynNFLIF1YxMLA/IjUhrTBzlLejty6ez7VX5Vgp96XaE4GRgUfFl5uEv7EMG4Q4TuZWqzHZJNAzPaDEnVIyNrK7EsnEeosAsWWDtmMkhJryxKZQkea3dBpJUHrYP9jI=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8345.eurprd08.prod.outlook.com (2603:10a6:10:40b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:56:13 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:56:13 +0000
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
Subject: [PATCH v7 25/41] KVM: arm64: Introduce set_direct_injection irq_op
Thread-Topic: [PATCH v7 25/41] KVM: arm64: Introduce set_direct_injection
 irq_op
Thread-Index: AQHct7jpsQ4rTI676Eis1+XOPDnaCQ==
Date: Thu, 19 Mar 2026 15:56:12 +0000
Message-ID: <20260319154937.3619520-26-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU0PR08MB8345:EE_|AM4PEPF00027A69:EE_|DB9PR08MB6700:EE_
X-MS-Office365-Filtering-Correlation-Id: 5898a589-89f4-4658-072a-08de85d0316e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 r6/0iROKIzeQ4NChQQ510fWnAkXaE0AyMrVfWozrRXRRubTJxXeHL2ueecRqC4/b0ceDwJhW8T/X6Jh/Q14hVnW/mxHpJxtnjcVRR8mBH/cWR/ST0QKgSGbUAwK/Or3etJvrelo1eBhEbrDlxfoNwlOI0tiGAw1zzukAc1tI/B9Q1vPdOGBnVBWl6gOVWjwDX4h6Wn9oUiUgbuXxajukBVDaH3SIxTUM7ntzs9d6JFfBxJHzg8g26ASszq048y1uajshBbA0CbOl1UyZqH/urs6Wu1idZDZkA+CvFXppVaVq+Jueo9KrQQxsYKxFfVd0CpsQPAw/IA0WX4ed0Xlcs/nf077/bXrJVRKui58OBE9kAmoCFYVKhko/IB+/uXQ82ih+AAi7b1fSXDNJparG18cfuHEHiXnSbnkOK99HwC/+wDjrupHpjl643eqgvZCQl7af1VWNjmQioTf42p6wk+BLhH31Ghi5VVFjGajVaM+Pz+7/mezw2Mg9uLs1GpzTnS0FNL+rjEbIi1FQP4kvwiDpGe9qlvqwVksLdjId1AGbxL9PTO6vx6fS3Y6l7tPHeaj8RjA2/b4Mj4RfeLEDMcAYfDHrvdp9M3LHsmuCLi26ipFwMvdgLOyxfK8GWvp34qOg0zIbISDfpx5yRDjuMWMoY4ZNPdyeFCOsBqN3ULBGNO7ewNy/rnI6fJVPVpUIbjtcKH19pwpkIQMPQmazuqZItVhE9Yq56/+wEH8urK3KlbplSsnNqpIT4brSRVsiMYLvJo1Nki+99fbAG9h9PJ2Ybxg6t/1K3GLMrRBmaS4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AL57RSa45AgyztMTyjKWvFqAZ92PxSZ86bJeGCLXMW6Ck9ai1Rvga91O0NnLWQu9igJRaHDn57Q6ARA5yLwnmXAc4vLhkPsmKVSq5hh3v24rHgubVozevoV9auDBJ1ceRj2SR8iQ5nBgDvpBjWQ+CAT02EG0VLLdh3eIJfepBzTAq9sjidZBrpkLTsICYUtW9+byC8i0tSn2LP8c9bY9WVctIynEWVshu7XSAm4qkYhCOJeTiqlrOryx4mj6B9+h9ALtNRPyu7/7qpwR/ZRwGSTEniiFZ8T2LSFaWABD78V/US00wKniYf9xX98hsvlLFaHER0QssvmWA9uMlBFyWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8345
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	472218b9-54b6-4981-f28d-08de85d00bbf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|14060799003|36860700016|35042699022|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QtLEv88+Q+NejWn2rtTn8BkS/vB3OFLyom1oIBxFMOo0ouQvOG2/EWJ7anh+VmkLWHfFUIgWlN89sppmiQIXgx64OvJiI9/HQKcKfQUGNOfYBUxA9oEKUCYdY4T3Zzg3Vxk7PSE35ZMMviph1cuh/Pb8MzldQ9RoPioeX7+G0dZl7Urz3vDOjLLRCGbNwWfMb3GGa4hEZ2G/dpiosQvQmAI8OJYgBURh9p/BNJnEx5WaL4KWBwWGbnzM/YA5nVox6Wio92q3g3S4eFp+ghgtOCdZ+dAdGW6lPBWEy8vUe+suXlHqIgAAMqJ+kLTb1IN6QiYXI8d2plW0rm1UT4DhsDKUWn8Mwdh3plo9M/RmeuV/yN2p6gCCwgDDXOgHJj9YNo1ljw7SXrw9YGGGvcJIf6MZaa95CFbFYYeOi5KDpqQePdxFJPahVXO2iZF1l+JC4OiBZQgMMIcJRfsaG1u6uCkkbLeu6ccwMkivxreEhCN3+az1h1L7jvhJr8t0NlRq0gQV2wRqZoWy9BqzuNr5I6kpJbySXDeL6/0KXOUUF4Gg+ljH+mbb1v+j/OR1bA+QR9pcDpX/plFuDiTsTdPdNGU39xY/roNGgVIfUTnZ64yw67NdbYTMiTiJ5+wt+0fjBW3Jp4B94ux0RLzBkVERAEcnY5cl53M5+NK+tg1jepMUomPT6dMiZ0m9FAvCWvItW8peQ8ydAZ0byJmHIk0GRcHBQqWEO6JXMvex1N4Vj483sUJMVqaWhVshoLXakSNZyD3x3nAM/JsP99j2giegxQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(14060799003)(36860700016)(35042699022)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jnnAPMP/0nIf5GaXsSRgaCR5GENsKRe1cNj3MqcJYiWRbtPR9yDNnfnq9tBkqRiKJ0akm7GA/c54dWIWiYhVJ/dCQruZ9uT17ciWXmbIT2p9PpqZLxaPTIwaCRS4PBkCU9cGbl/bPe8gfu/61ceS7ossPFA9EPpzUvpUAKS4gOOdT+eCrcQOwMSJiWHfLGpFeXMkHgXu8QhK46ZA0mr0HldHrlrJ+OIK7S4lp0TRs4IqKb5jGNyRsxwYiXwE1DOxbevRTYqvoSIIeLzNZwuqLL4Np1069pT/byOiXzWHPmiwmdbEnb9HnG8MXIBvZh0699O6vUqN+8ATtCW0HoNPFI6zYzYjz5GuwHnG2uDYfuG3Nt9QdUP/5/2Eio7fVYfemsDyntGbtt/S7/MWHUErhgpkU60C1CLh+6Hp+QcyoxfbE/O2eM94bLwujd0Wspow
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:57:16.1184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5898a589-89f4-4658-072a-08de85d0316e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6700

GICv5 adds support for directly injected PPIs. The mechanism for
setting this up is GICv5 specific, so rather than adding
GICv5-specific code to the common vgic code, we introduce a new
irq_op.

This new irq_op is intended to be used to enable or disable direct
injection for interrupts that support it. As it is an irq_op, it has
no effect unless explicitly populated in the irq_ops structure for a
particular interrupt.  The usage is demonstracted in the subsequent
change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 7 +++++++
 include/kvm/arm_vgic.h     | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d9ca5509147a9..9ac0ff60aa8a5 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -608,12 +608,19 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, st=
ruct vgic_irq *irq,
 	irq->hw =3D true;
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
+
+	if (irq->ops && irq->ops->set_direct_injection)
+		irq->ops->set_direct_injection(vcpu, irq, true);
+
 	return 0;
 }
=20
 /* @irq->irq_lock must be held */
 static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
+	if (irq->ops && irq->ops->set_direct_injection)
+		irq->ops->set_direct_injection(irq->target_vcpu, irq, false);
+
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e9797c5dbbf0c..a28cf765f3eb5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -215,6 +215,13 @@ struct irq_ops {
 	 */
 	bool (*queue_irq_unlock)(struct kvm *kvm, struct vgic_irq *irq,
 				unsigned long flags) __releases(&irq->irq_lock);
+
+	/*
+	 * Callback function pointer to either enable or disable direct
+	 * injection for a mapped interrupt.
+	 */
+	void (*set_direct_injection)(struct kvm_vcpu *vcpu,
+				     struct vgic_irq *irq, bool direct);
 };
=20
 struct vgic_irq {
--=20
2.34.1
