Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.32
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795511237;
	b=WpsFj8pmJvLikyseqv8juXrbPoJueREAadPo5tI4/o1QBBk7KCYzqF6DHA8pMrX4lIMl
	 ky5XKT3j0UBUezpEk2b1GtqlX2dMz1Jyp+XmXioH85Gf3pyRhFmu+dcRSM3VFl6Fp9REU
	 iGXPef1Jznlq0ThrdF3ewt4KLpepc6X3RU5Kd523LBVZ5eIA5wOiyugfj6u+CFWHmVqhP
	 Huh0fitS5wKuIVXnaWg3jxYhOiryYaDa30PJ6TmL7fcELcKE87DaYnvbZHvsDAre2FuWT
	 8zr8fqJULQW39+FaM8b2SVw4eoysarCi3AIYUT7rFk8WEaKAKZy/xQBsVwtyA+4ZWmQ==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795511237;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 Authentication-Results-Original:x-ms-traffictypediagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 nodisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=XurDSaJFDtCL0Qtr6rT+mbuFXOvKqZ1PTXEZTYAGNgw=;
	b=sl95qDl6lfSpYZ9nf6s404jQ/FNwglWshmt76wsQAqnghNXm1c/2CWxW+ZhiYe5pYtgk
	 O/AgSYLZZL7m2NuEH/FRDkbwQj+hA/1KW8dPT4yq1xN03eYYUUhHFVpfNDzcqQNrx0fYL
	 82p8EgzC/WeunaHkib+7PMlqbvClIXhPCQn1vlaIY+GbW9css6h4b/H4mMY27jqKv9kzm
	 WfOpZTrKkececmDEqjmt4kqhyETMIC+KpHpc8cHwSa+PtcC1LkLmc7Ecyw1flgxopdXSG
	 DroYDJmklxdD1+g/XcOinLgaM7P1rTDtopOujO0iK7fuJ9K59j1/lPl6/Xsq6dbAhDQ==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=OSZwMIBe;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=OSZwMIBe;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.32
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010032.outbound.protection.outlook.com [52.101.69.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68661606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 09:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68661606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=OSZwMIBe;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=OSZwMIBe
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Up5r8MPyodWiPYH7t6ndh/CWhGwtm5DcCSe8n7ZXWsiz/ogmEwqunM2rxkUOA6gD6GXxfdf9O/6xi8+4lXz+/GWNhbQDiUenVLlAxnRue+q2yKsPPLBnWRLtaZp+ha/1ASxhJtzBs62xpF5K5lcmUls3bC/+l24Qb0iNRC4TP96M/x/4ve5QiGFozs8RfNAGyrRwN1WvqyTEgwqANAhAgOp3IFwU8gNlc3ttmkc8e4AcoTOe0XyB3mAxSuSTqzIUHsqVI0+MOTVtIfzUOiCXqPVDQ9RaaTXdGUDRl0VcQ73RBNXKyUYjFWPuXuD6SR2sZKoRv2jhU64we46BQggwmg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XurDSaJFDtCL0Qtr6rT+mbuFXOvKqZ1PTXEZTYAGNgw=;
 b=wRNWsZx+N/k+xv15/pNiNp/WGuoN3EftpXI/jGULwBvNCzcTDHHdti1sb0o0Ry8HWCBxmIr8Hp9C9YHA+IlgBQbSAek3CWuM8M8tMDA1vccD6QDws495+Q79WKOC399M59RInTqMW8ouL5iWqSeh+4U4gPWJ+VFQx1odTkeFWnNw8qsOOOSLCqLyAq2A/IYI60uaQ2Az2MQJKOO6MyDVgKG+nXU2OguY+MKGTL/ljdUQKT2SlfRJNm1qQaVq/JAm6L864P4xzY6JMjejUHF6TwDKTgw/RzxSczL6zVsiX1DLk4ab33vJu9wCzXrZ17IEx+4iwUsAZgrnkbCTpYgjcw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XurDSaJFDtCL0Qtr6rT+mbuFXOvKqZ1PTXEZTYAGNgw=;
 b=OSZwMIBegRNzJH2SPGT02U9Nql68EXgnmu95HzWH0Ygapo5rXw1hp3d/ox4VdfYgc+m10qUNkVJwGQY01lUvkh+XNuTK9izAmJwlHW/k/P/kn7Tcza0G1yQviPIM9DZ/YudsKDDubLg827cjclbT3VoR9sipwXpzn/UH4uvemDQ=
Received: from FR2P281CA0052.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:93::15)
 by AS1PR08MB7513.eurprd08.prod.outlook.com (2603:10a6:20b:480::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 24 Nov
 2026 09:07:12 +0000
Received: from MI3PEPF00008494.eurprd03.prod.outlook.com
 (2603:10a6:d10:93:cafe::6f) by FR2P281CA0052.outlook.office365.com
 (2603:10a6:d10:93::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.5 via Frontend Transport; Tue, 24
 Nov 2026 09:07:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008494.mail.protection.outlook.com (10.167.240.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.5
 via Frontend Transport; Tue, 24 Nov 2026 09:07:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gIo1OEwCfHW7E1nVsQXjlfPva4lJMN5y5F5Wv5w08a9Tv2kNl16UnFOWTNNLVD72phWTQRJWh69bTsB4/CH94OG3rJ8dNVV5LZUhDFkgm6e7nmoHrbLHe9XpcWtuj/Kk+q/Q8y6N9efj7lEl7+RCtOll+wE6g7ShbSuhLOl2vcx1T542YSax4ZUJU95OBvbMqnTRSHR8eVuaqC+0hsQ4brkII/m6Lb/ObfWtG5wd/ry5YzVk6p69aMsNo2xxkw0IULLTwZpT0rU9ezuZhZJe/L6GdwDp9wl/vZp+0PreI/0EJdeqk3Ir8wcgj9Gi40mlHSR4jWzrr39KXn03I7JWDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XurDSaJFDtCL0Qtr6rT+mbuFXOvKqZ1PTXEZTYAGNgw=;
 b=ofldfQcIrm4vUaljro+T9bNwOmPqn93olNgXKdGX0fTWchluoBItjr/Uy4TpVm2v0R1JTSGiSrqb/3RreFk26Xs1nIMG+ULUadcaxezeTZkHQMLaHt+GHI6d/XSyuW+g60D0h61sO1pDR2XiH49VXpZEOCHn7Io2aETfYxG1PWkQjvVcQJcVVpA32GEXqMh0OUToDUucDezCNcwp5VWnaxNDiA9ZlE0Tp+4mOLnKxBdPUPai680i53v94cWyS6g+Qv2AR2/ht8jK/CeRg7USyKblyXwwqvbIQOsdeqBcPiHn7GX5HSs6sWwkWATSbJf+qtaBas2NlsvtxoqvH3KfVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XurDSaJFDtCL0Qtr6rT+mbuFXOvKqZ1PTXEZTYAGNgw=;
 b=OSZwMIBegRNzJH2SPGT02U9Nql68EXgnmu95HzWH0Ygapo5rXw1hp3d/ox4VdfYgc+m10qUNkVJwGQY01lUvkh+XNuTK9izAmJwlHW/k/P/kn7Tcza0G1yQviPIM9DZ/YudsKDDubLg827cjclbT3VoR9sipwXpzn/UH4uvemDQ=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by DU2PR08MB10087.eurprd08.prod.outlook.com (2603:10a6:10:491::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 09:06:33 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 09:06:32 +0000
From: Justin He <Justin.He@arm.com>
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey
 Gouly <Joey.Gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin
 Marinas <Catalin.Marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <Mark.Rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Sascha
 Bischoff <Sascha.Bischoff@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>
Subject: RE: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Thread-Topic: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Thread-Index: AQHde1zAtBC9mmT//0CTNvJgc0eqU7c75woAgAEFy5A=
Date: Tue, 24 Nov 2026 09:06:32 +0000
Message-ID:
 <AS2PR08MB97865A914C46DA0CE54F9197F7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261123150917.2679600-1-justin.he@arm.com>
	<20261123150917.2679600-2-justin.he@arm.com> <86eccbzcqh.wl-maz@kernel.org>
In-Reply-To: <86eccbzcqh.wl-maz@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|DU2PR08MB10087:EE_|MI3PEPF00008494:EE_|AS1PR08MB7513:EE_
X-MS-Office365-Filtering-Correlation-Id: 40ceeec9-9739-4df4-3271-08df4a0a5365
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|38070700021|261102123227099003|261022075727099003|261021121427099003|11063799006|4143699003|56012099006|10067099003|261009223027099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 UzFAFwxzkAgeZZU1L/ra8lx5Vii4oLpQ6mXOlR2gbpkRiqWt31mDZ8Mb4QGD6H6Nmiea/P2DGyhYL5DegH0nMAGTfhhnwyeH9aX79hi8wwRrb2cO0ljwuo9Yxr+9ACS0BkuE/U+wQTQGjFq6GcothEj527kHL6ZHzW+ZoYQX14Gjjkjtr3rl0eGHvl2qKi6XyBJIDhRjDGh3G4jXC0zCSSlSeuS0tV3vdjKtYdpfAZS1BEF77kReRZBQt2Lg2lRNaMbtONABCo2j5PMUwH1feI+eopokaseFdgoFydsASU77X6TYEJeSVY8ICiJaJ7qvLjjjTO3BfXtPMC+RCf/VIrcRJ5TUTRYctd07cx9L8LjBIYyX/2pL9grek/ZtxyeKmQAo68IzXALa3NKwFGOn4MM2KlDpqVOScu/yFunyKrtWGO0h5tqqJQcH9x4c2UJpJBCAFsJSjaVzxvWkXt4e3J9fczfCG9+beeozbBVNRbhL/OpItUxddl4Jw7WMGehYggt/ZMfb5KgJwt//+SNmVOy+7oRhniz4MH3CLJcD8R8BcVm9UyPni1DKyj8n+4M7nJXB6u10L3elcrsIXaZLGF+cD/CeoRd1aW6oM+4958qJ8gOZZ+bFTLKYPcNRn7Cexcnv7hH1S0NpKOg3CPTF5jscZuMbghb8g+Dea2ICTer/LGi7Mj4Bz3xxutKlu1LmAa5aRC0c2jnkaEoMCbh7x6gglRm49g1EstscDr2OfUE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(38070700021)(261102123227099003)(261022075727099003)(261021121427099003)(11063799006)(4143699003)(56012099006)(10067099003)(261009223027099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 eJ0d/5obHVqNPHQCBvshMMxGV7c9PjZe1a7UJ0emd30qCNUPvaUDEMuPp3R0cF98RryvLRNEeqXhpel+1g54A4KJsaItvaWGpPfI8x1MJOPpP2W6HYeHNk0xa+PUtQHtCkojXZUNHPSP0p4RzdsXSkIw8tCq5mlfdhYuBcXbpior7J1x9zAKeK384IkELuVJs+r72sQU/ZVYtCZgyBntkzKwtf6bOA7h3u9DqFcELFd+UtF+6/GjLQzVN/ghAVrC/JD+HK/wK+YxDMudGtBiF6ZN0s/Ve5+UQSq8YlIFyPca6WndKgDu7CKZW/QBtmmICM0bOVaqMm+GYLi52RrB9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10087
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008494.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	17466ea9-a3c2-4be8-8fb0-08df4a0a3c21
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|36860700016|82310400026|1800799024|14060799003|23010399003|7416014|22082099003|6133799003|261102123227099003|18002099003|261022075727099003|11063799006|261021121427099003|4143699003|261009223027099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VUv/K3wckuqezWgRebR2iSdTTLuYxnRkGgTiKEmaKTWSX8/bouLKJg5sLlibZkObRz9xULIfkCHd2TXqT9vDs5hWpsTGT0FbdWrkMOlvQ2RgLo41ZZfKgo/6hlNXXzrlGExMvtxdrxWf6QckZeoQpIt0cylUrR9EmoRR7YKVbIV9K5xYeIRyXko4n3uW4ANDSolEg5+RAKxePHzgj/qX9Wv8/ibs3jwRqdyeFyXOsBctBji6fvp1F2Tu/JAQBFUQQZfM5Gf7YvKBK2jvK0H1ZAWiOdZt7NyXK81EhPM1R2G5bPxGe70EirTacO1zkqENcZC8BAubRbOLQHoigwOAgPD58q+4Dmj2dFOp2tx2DECC9zAD21KU7ZlvDw2U3Tu9+Krh0+CzyzQwZ4auwG6mpbRqTkLTPsgGbSY6amTR5G+Poy60eVyjAhz8hWLuDBa5k6XW+FMao0b050Fa4/Qfp56NcmFtcEfFZT9VuyFAR3D3ijeOy7eBKXF7bPGwFQZLTdRBMC3PPjR2XNYJD/afw8SKJWziuu7eGgx75qGye/HewL3FG5/ZMRX+AEHGGKikviFTsZkoj+Fe8pfCNA3k2gb7sHFytVwie/vPGbnn3EKTaDvEW1xjrKt2ZobGwPLPJVLzAc7lP7CuboT7WksEQWtKoADo3rE67elLj1b9n1TYm+xF7297JKDmJwYphmfH8lWVVJabzbeKx1xRO8nePA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(36860700016)(82310400026)(1800799024)(14060799003)(23010399003)(7416014)(22082099003)(6133799003)(261102123227099003)(18002099003)(261022075727099003)(11063799006)(261021121427099003)(4143699003)(261009223027099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a/v9oePaAxpAh/xEIhbnQrQGjhjFXDRtCGEp9C/eMWkZIVtiwTwQhwrSoe1OidoyyWQPRok0trgY8wT81d5eIVptqWVFxt9DA1UOhel8GZzIE2i+RFpnz2DbgKq5nIaHlEpvjxhmlZNahUbQbDOVJGlToOA9g88TYLe0cY+k69aJDcjfCS3yjMmLc9jmbCrbGqdUOzmnsk6L3M7GOB6GJ5v0misyq45ntGURtCAQ0ICfDk0I2kt6SJ0rypJek9lUC2WKE1WK71caHv9t4UO/Rk5jMBkBgqD9JymsCDi/ZxP0W6+OaEZ+8nxC6IWgqa9AnlDRrgHapflQcn7fZKO0hu51eC0yvDRH0iBuWCB8YkSZa4QwCHLJTHhq+1EsNxZN5M6siSEPIjt8Cjq1D3HuAgpbBwUlb+CZQ4HtUin5oJ2MthnMxwFYkhCw0rOCZNuk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 09:07:11.7473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ceeec9-9739-4df4-3271-08df4a0a5365
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008494.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7513



> -----Original Message-----
[...]
> On Mon, 23 Nov 2026 15:09:15 +0000,
> Jia He <justin.he@arm.com> wrote:
> >
> > KVM_PRE_FAULT_MEMORY calls vcpu_load() as soon as
> KVM_ARM_VCPU_INIT has
> > completed. On arm64, however, kvm->arch.sysreg_masks, the trap
> > configuration, vncr_tlb and nested vGIC state are only set up on the
> > first KVM_RUN in kvm_arch_vcpu_run_pid_change().
>=20
> I think I'm going to queue a patch disabling prefaulting immediately,
> and then we can fix this crap.

I can still reproduce the same vncr_tlb NULL dereference with prefaulting
disabled. On kvmarm/fixes, commit 5651590be08a ("KVM: arm64: Load the vcpu
in KVM_SET_VCPU_EVENTS") added a vcpu_load() call to KVM_SET_VCPU_EVENTS.
A single KVM_SET_VCPU_EVENTS with an all-zero struct kvm_vcpu_events,
issued before the first KVM_RUN, is enough to trigger it.
For v2, I'll build on your patch and use vcpu_has_run_once() to gate the
arch load/put paths for both ioctls.

___=A0
Best Regards,
Jia He (Justin)

