Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013068.outbound.protection.outlook.com [40.107.159.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69162470EA7
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102211; cv=fail; b=sFCO8cKRK24IkPXCZPDZWyCWkd8YNqEbcU7rRF3sN/HwpGjIBUOqjDQIB7Xeu7bHE5ArjwyJP+TLJ2Ea3vd1/zKcD9c77rZ+fcZ0hKy6tEwLWvXx9MZHIuzQjtdBoXk7Ril3ZeOiZ50NY2XaM+977pD2YUrbk+nRq9zeGYf+1v4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102211; c=relaxed/simple;
	bh=RllbsGUCmpK8xZXEcO259kyd5aHVOCjbCwFPJmPkX8o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tN56uU02DlbiXsxgBHZzikCg9g0JKsk3E+S0hAHRxZR8F3wHgsY5fktQ9cUIMWwkRtImBO8WiOlKR5840gjN2B2jaoyiY7Z1HT4CuOv7kAlr69HIx+oQZMiZ2m/I450b6nnMGNMyctN4MeHt6EPbwZYoLhSfKqrO5iVocn8eDbA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p2x9Q2aX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p2x9Q2aX; arc=fail smtp.client-ip=40.107.159.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p2x9Q2aX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p2x9Q2aX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xF/O9yxhY+oWDb6nOnnaHdWJU55iaIXdA0A9GqLngYyvMC52GPzWi9vkX1XXQFcXyUgQZSurGLdOcP/u4Wf0RsiMM4jQGMg7IV7//mIRjqtgTQ8dTcw5TNUKm/yclSxfcFzjGEOiPvLnTiCLVqhdv8HvPQ+1unIbSBnQOWKbSGWir0tPJ9/x9eU+KLzp5iocmCq5BduWxhJ+Me1OSAJXzAR00pkEam8sClvbLjfGpkofESFlXq01hlvleA47WR37YxfJGIfxcWTY7BEDJbI2l6XR0QkPY4Ot/L3zZdUhsbNcooVKM9K4vJkSQ4GfwGWXr+1NFLftMg9lKsn3jZiVDw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZmttryLdjf/OL8X+ycS4YxPj+njujj1VgPTMCWUSvk=;
 b=Tz9WNk/FTh7ZtBjE0UcZXrFp2OHfr/PaymCXKegHIqGybDPFD8OdBTXt036b4fjXEfq4EMzgUqtFnYadbypcBKIBblS28vNXfxmdgtD7GKNq3y3gOLriCemLaizf+GjxAD6yo57ojaYUQ/yGwHKRlXURSMlOyMQ1ZpiRZ2FWx2OHpqRbth7sapJrtjKIwCTNh7MSl8x9+QLl0BZOccrAzzF51yBvGXSfot4baPERqZ+ZXjhtdbeeVTLAaWDLYwmDUtfnAtMVoyXJ2ZzcNFS28xBLuk5NDvVHKnhm2C2xvVATdyxolhtxei4MbI+xydU7Jwguww2hi6NnvtM1XXyEkw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZmttryLdjf/OL8X+ycS4YxPj+njujj1VgPTMCWUSvk=;
 b=p2x9Q2aXlxYPcaTKjFyUKLzh56XE8z/IPSQbj82tWdpnlmdYD7dqw+8IU5NS1S6J5AXYCS+efxMc/1hrEQ9iVjvmbeYsWFk9NP0HtWwRgL/jlRZOUIk7p3CVyUCWWBUVSe2f9TR9he6XT1hMfHSv1nThH1H6Az+BxvEQ47RmVPs=
Received: from DU2PR04CA0062.eurprd04.prod.outlook.com (2603:10a6:10:232::7)
 by DU0PR08MB7881.eurprd08.prod.outlook.com (2603:10a6:10:3b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:29:58 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:232:cafe::8a) by DU2PR04CA0062.outlook.office365.com
 (2603:10a6:10:232::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:29:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:29:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoAM4iUaeLtUYrW1Re/s8d7Dvh9mrrYegeV3hS76Sr8sKUUIAXHoXVwByh1vSLlsZqkc/FzKzlCGb292D2hp1hxMYBboqOyG60xaxlOJb0Eb0ZSRkPwOn5vW5SbRyBzPca7VAGAsv/nw7qjhhhql7VUBor0rzXBrTSlqad7V1zonZmxTLDAHPbYaLv/ZQiZhWb7wdEbCr7k80pyQmFDkJ8wZKg2JhDGGbCBOBfQHeYeUkH3b8kZu7W/f5q96nvWzxV7hclM1IWJWjr5fpHDIBr6ot7MkWHpMi2XOVzHVibkZewktk9bRlzeX4PZDgRyS1yEkLaHOGKB+cbs9mgWeow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZmttryLdjf/OL8X+ycS4YxPj+njujj1VgPTMCWUSvk=;
 b=APqGguAxAKUI0D0MbOymN+eM1dNdeAwynZHP4Wdvhy4qGhYZtI5srTg9s/zhtIB+r3jr5Avc9kimcis2nFhR2q0U+UGcY94Ss9RUwsnQOP2FaTIdlRv6mrVA3cbe92kl11w+8FFHBWGU4DW71/23C6K9ikDdkULMtizCD3W5WOd3H2L7OLBkHGCu+p0mPSG3Vm/Du3sPn1pgKqniWbTwdqO2q4gGdZKTG4Rr13sm2oM+1PmiZaipdaWJUNuZKaatSB6NzsA4wUwJp8pXNdUHh3gNQYO6ycRAYTprghLsZQnef+JSQpxNwaXDXtlfrUSrWPt43lOY/i+/p0yzfoF0MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZmttryLdjf/OL8X+ycS4YxPj+njujj1VgPTMCWUSvk=;
 b=p2x9Q2aXlxYPcaTKjFyUKLzh56XE8z/IPSQbj82tWdpnlmdYD7dqw+8IU5NS1S6J5AXYCS+efxMc/1hrEQ9iVjvmbeYsWFk9NP0HtWwRgL/jlRZOUIk7p3CVyUCWWBUVSe2f9TR9he6XT1hMfHSv1nThH1H6Az+BxvEQ47RmVPs=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:29:25 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:29:24 +0000
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
Subject: [PATCH v5 33/49] KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
Thread-Topic: [PATCH v5 33/49] KVM: arm64: gic-v5: Add CoreSight MMIO regs to
 IRS
Thread-Index: AQHdJl//WYe3Vq3DOkWvJK1qj6IQhg==
Date: Fri, 7 Aug 2026 11:29:24 +0000
Message-ID: <20260807111159.429128-34-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|DU2PEPF00028D12:EE_|DU0PR08MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 7089e818-9bec-40a3-d959-08def477367a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 ercsM02I4PKd3k3QmH9rsziL/+LeCx3pOe0hAibMbrOy/j8CklkQxF8N+uiaCYSDkPLMOJvGNNnWS5m1+hMqkPevXPZdtYYkvOzi0fytr/saUciTWMOc2t1UVgkvdyL9/p5oJIY8nb53bh49PBs5+DnPIiYMnYuQQH2vuIqSrOglo4LFFus7a68USwkFsSpgn9RY5kdX40LjHg05vBZsPOE78rqhgkEwcLpVRQ/jRmN+m2gs4EaXlCEYY+HVWVN+4YFjzHwWySVNlER97nxOeUuFx8nLVXjFEyaqK4/GS516EBtFas6zjyPAqX/xmjCiMvTzyPHyfVu2D9IXJRlZ4yhR/IsvIVV4KzLfsYGYaymkyOZ2jY8/XNs9gC5P7MqE2C6ZFNcWzP3EDlC1bleV8cXQ9LHrnOlwOZkGEFMKsgFuoZcdQ71wSwtpbs1I75frXYJHZDPuEOcE3SxGjPoDu1/oTfYmJSnEEBZBWWJjsHcJB8Qu4rfK2BthkyYE7n5zuERj21nSzdfIhKGdpU91hveSLLZr6D6DxhPooc8SUL9pPQWbnd8YGUwOfIBTWhMWNMx97k7cbgg3r/c2YlT2Sbqf3qmIF3FSJXR7/krkfygS4qep0/ziyfVm+Y6gu/powkoE9pBHpO85UMK0fwwZPpnz2YwdKMYWWVg6OsD+2TCD9NdoLF/RcDThUBWao2bTy9MG4bMdJZCEtaawksCrBm9bAC4YG0VgBmKspNmejHw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 g584Jm6BdypPDyBQiPo6rSQcsPDAz5BYnVJEe/WL60kcDvkizYFUeumPKEZctmIabeJomOB5OP5lLxnpmcRTp26eiKETkyqW/MNiEfMMEtFLYbGkj+XAsfxgh6b+lUa6k2r6Z2ChpowjwODaAi+Fk7Ne21Xz8CCvs8SmZ538ksp1ZVI2etPWIzCxeVS+8gu4wm2YfvEvEwBSSQO+BwUSBDZjmc3LoNQbsZYCcyhLUAT/F61PhlFlXfGt/GDIPLGM5e5L2RfL2GDocTJOJZD+MTAm+qTfndT2Y7w0HErRdWWwQErekvilEI4bv10vza3ea2M966FcIfYe+NJXwOSbWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f8beb678-2771-45fd-dbc3-08def477224a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|35042699022|36860700016|23010399003|82310400026|22082099003|18002099003|6133799003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	OJ89YfvqF/zZK4ie2b1bKW5FhkmusnnILz7zGEe+J1U0uKEQLfoY7bHV2LxVlnyoZHtzhabW/nwWOdDgOYHh/NtqPqbChkrCbaFd2IQ4B6QUUVG1UiVEpWSKAYMnZeakPs0zdJMcqgK7EwGbbnMsVwAYBMS/+nzMFeaP4SEK1EDTF6tCUcgmAwroXxrt7JP4rVDU+bHI2G26ZpNNdRacKGfnkx403UzTg+hwjIX6KWDYnm3WuWD0xbTVCaJtvEvVwXuqiDOrIDU1SQnfq63Pa0d7PL9kP6uhUkIYVRBp3PlbMkXdyNZBOoFLAr3HD726UUowK/6tMzfBIo0YkiP+QgVDTFCEXMAOy/9cpnOdEAmYEW6nA1QmvCt5dICn/Cq1ivxw4/LEBpAuGIQqe6wpbzuwrLIsFxgfQVQ74mJNXaAkEh9B6JONivu9GtY+xI3GjhmlW6agDaofysUUzf5UU6Fw1C2DbTj0nF3ASVupvz29ReQwNrmG6wK2WkyuuYY5Y56xFDs72DG8KIPMvbLGj2DgeaXotY15lU3afW/MeuGW+2p0cuyRPqimc+VqLXon+uBwE3/PpZJOPqJ4qcEMURKa6vF7XAaOkCZDUgeKhCfVaojMMapkvw5JekBbA8Ob5za+7Ml/Yme1fUmfBz4n/vkwJKaUoTUFUrqB2Awpi4aQOKhXAdyfdFQkMCKfTQ/sAnvn3FGKCLCOXGa2sg6CwA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(35042699022)(36860700016)(23010399003)(82310400026)(22082099003)(18002099003)(6133799003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Bt2QYIcyUCnLFPeqesF6uUq5p3iCagsuKh2Pe9/bBjYv1lrIl5vakBCHyg6SNhF/gczKBI/r1zfAAbvwxtlDQRIICDbydpK0JRdQWaHpmMFfRIFzmK8L0buW4+4NjQmOdHg0Us50IOTevHuQT8m7iOo8ePaErbDZB0t1K4oB9AetHexDpvg8wn+jui8JS4+b+b5zuO5eoqM6ynFMPMAam1fjn/uHZqYvxVI7EaNrU/Qtuc83JjxyFMSuWH2tbP67Dormpx+e1xEymB+QhqQ1NwBej5j/uelKGaxFG89/14Aq5xHQnJTSwhVhrdmpK6fnp5YTyJwUezvwjVLnlNzqZKLWEkf21+P4RGvj4xdHcuH1wOUot8caD4eL52YUmXKbG4K8GVFDeV+naVUSJ0rtNqfIM6mD85tACAq3+XbrDDx29yJtVEzQCHgfucOPyaka
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:29:58.4521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7089e818-9bec-40a3-d959-08def477367a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7881

Expose the CoreSight identification registers in the emulated GICv5
IRS MMIO region. These registers are read-only from the guest's point
of view, so return the architectural identification values and ignore
writes.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c | 78 +++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 212066b8d7ed5..22f8ce3b7c83a 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -487,6 +487,43 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu=
 *vcpu, gpa_t addr,
 	}
 }
=20
+static unsigned long vgic_v5_coresight_read(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_CORESIGHT_DEVARCH:
+		return GICV5_CORESIGHT_DEVARCH_VAL;
+	case GICV5_CORESIGHT_PIDR4:
+		return GICV5_CORESIGHT_PIDR4_JEP106_CONT;
+	case GICV5_CORESIGHT_PIDR5:
+		return GICV5_CORESIGHT_PIDR5_RES0;
+	case GICV5_CORESIGHT_PIDR6:
+		return GICV5_CORESIGHT_PIDR6_RES0;
+	case GICV5_CORESIGHT_PIDR7:
+		return GICV5_CORESIGHT_PIDR7_RES0;
+	case GICV5_CORESIGHT_PIDR0:
+		return GICV5_CORESIGHT_PIDR0_PART_0;
+	case GICV5_CORESIGHT_PIDR1:
+		return GICV5_CORESIGHT_PIDR1_DES_0_PART_1;
+	case GICV5_CORESIGHT_PIDR2:
+		return GICV5_CORESIGHT_PIDR2_DES_1;
+	case GICV5_CORESIGHT_PIDR3:
+		return GICV5_CORESIGHT_PIDR3_REVAND_CMOD;
+	case GICV5_CORESIGHT_CIDR0:
+		return GICV5_CORESIGHT_CIDR0_VAL;
+	case GICV5_CORESIGHT_CIDR1:
+		return GICV5_CORESIGHT_CIDR1_VAL;
+	case GICV5_CORESIGHT_CIDR2:
+		return GICV5_CORESIGHT_CIDR2_VAL;
+	case GICV5_CORESIGHT_CIDR3:
+		return GICV5_CORESIGHT_CIDR3_VAL;
+	default:
+		return 0;
+	}
+}
+
 static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
 							  gpa_t addr,
 							  unsigned int len)
@@ -808,6 +845,47 @@ static const struct vgic_register_region vgic_v5_irs_r=
egisters[] =3D {
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
 				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
+
+	/* CoreSight identification registers */
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_DEVARCH,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR4,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR5,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR6,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR7,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR0,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR1,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR2,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_CIDR3,
+				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
 };
=20
 unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
--=20
2.34.1
