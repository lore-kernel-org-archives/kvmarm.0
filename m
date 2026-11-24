Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.84.23
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795484603;
	b=1SuNJM0nBjC7BG0crhWtKCgWmJ6+6p/AcKTolHhADWh6G0FL2f1ECfqxgQQ51qbhR4Gj
	 UXnnCOeevpYy3CnkvO0EenkUiSudAjtrXPLAT+vHzfsO77I5t/Jt9nFJz+O1FR8PQCzPj
	 0zoaqenPOdz2GiYloGb1a7lmSuNUbU89TUCxr0Ipzvf+7itM0xsowimRyhlGElswtXtl0
	 hzKhd0JxymE7I57jUAN7jowoscrcj30s3zalDmQheMVTX9KaoyCQ1mNDj5fuwKM6BbRsm
	 hvjAC8X+wnQqgG+uzB/snk2V1TyNuV7aUJGnc+zf6+C9O/UJTALwAjvHiyeBS7uJG5w==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795484603;
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
	bh=+OfxTU0F9WhDQCF8cCpgV3eT66r30xdLJnuaQvm36lA=;
	b=KFHlMN3GvM2DO4dZu4HPQEBJHzcQcH/sTZjnTsGrsIxb/ZfI2GzX4iw4b56SRIZYXWl0
	 5S+ZRF3q+WdDJ2VYJh8kQoW2lpnmig9KXjLJVclmNPz0F+3zmth4yBE0gu6gQlbbftbOI
	 UZCQXqaasL4H5dQJLarzh4IXyjH7qu/XZM53SRdOwEUebHj2c+F3oDpzoutR2FzN9vqxt
	 0Xvrjecjyyn8F5ITZVXgPAcRaqqNnXqfN7OVhtr4c6tgU6w2tWWYm9I+5emrTaOWCXbEY
	 rXDia+ms5oDXur+4FHupBqt+OT3WSEHxiwbffLCiy0i7VYTAjpLMpJpkH9C8aCc3zdA==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=MojHjn0H;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=MojHjn0H;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.84.23
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010023.outbound.protection.outlook.com [52.101.84.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD6B606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 01:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BD6B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=MojHjn0H;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=MojHjn0H
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jdhB3eSRNeEOajlEnRoeOBFP9cVWZ9vLt5nVNkTPo6WcHCMPlxQNeWl/Tbd5AVT3NSDiyau+FNyELR0x6WfmmgqZheW4Fyevu/WGM4vukg9Lp9FCZ7iJOalUoegnTjfkiUzIKZQaNySsjUZ+kR2ArZ2H0IcDDqzT8KYESNTRfURb5RhPjDRpSo56lDZx+Tzu7aFcxKlhgMHpov2I079NECoX5PulsurG/XmzEE4GYQLHuA5nTJtlwSvZxHzXqOx4q3DEiMckirJzcHKWMXZsQxKX3fNWxDsyko9cbfSX7wF4twgBsd/IUX8r6+dgyGf0UJjuFjJcuakWtp4PAGdYoA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OfxTU0F9WhDQCF8cCpgV3eT66r30xdLJnuaQvm36lA=;
 b=Yco0D1JRZjahY877dFkvfmQnz3SIzMvk5sEEelEiRMf+4G5bsu3c6PHJElJBuT5ocoyZd7F7CjFIIG74GkIVs9BA3YhWv9oi036l7/wDSYSmY5JkUsRrd0z71L1uw80mVE4KVSJ40Q46RwWwjGacD22wgTzzTZMBKgSCyfM+ZgI+ueSPEOfzBvlfOid0SEvjbJ63n7zXDKCvi89h/a0a6hl9CHr/p+9PX+OziKk0nuKcC+jheckuzSMfpktmwx3BADJy0me7H7NCQzmhpPNAaeJP2Q+j/4j3JmqMBehBro7Wg7cHC/aH4XhQSRtTi7vwzKzpS6Gkv9ppuIPQxrDrOg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OfxTU0F9WhDQCF8cCpgV3eT66r30xdLJnuaQvm36lA=;
 b=MojHjn0HIavRUofodc8xSWnoZNo3MWfFxHkfA2ChD5YGSps2pIQ0o6XAuOiep0FCuE/P4parxtV54DKFVzGj+Zv1K0UKb1bbUgz9qs7zLyUHG3o685z8luTfqx/IxqHUgJiueWHk+OGkm354KJ7BczuAjRyOWbK9/+VICKZTQPg=
Received: from OS6P279CA0008.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:30::9) by
 DU0PR08MB8495.eurprd08.prod.outlook.com (2603:10a6:10:404::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.14; Tue, 24 Nov 2026 01:43:17 +0000
Received: from CPH1EPF0000051A.eurprd04.prod.outlook.com
 (2603:10a6:e10:30:cafe::51) by OS6P279CA0008.outlook.office365.com
 (2603:10a6:e10:30::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Tue,
 24 Nov 2026 01:43:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF0000051A.mail.protection.outlook.com (10.167.241.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.3
 via Frontend Transport; Tue, 24 Nov 2026 01:43:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHPp30NgrwSHNOeZzWVZdw3EH2fEAp4ogcg37rxZ5rPpKet5BbLn+A2CF9sjc2pLHvhKft4JvTCMpsSwHGlDHFD3H1/K74RhvvZs1VCD7SWRX6wAmWILTWJK64zz8o7IBoHP5PZm1sbDLOEUYzRyfs5evkChytouivzzMepuz3n+gfgCfXAWl+RTMTMUyZDBHsMoWKbWTiyuRBGJ5L2X0AMS1C/67Oe5r3CZWNZ1AZt1d1HISs1sqkmW2fp+t0G6zYU5X8dABLS6zOskADd5deC9+Fc0pnvwXU5DXzje7p1hGUUFFPjWEpRs3O2xLUJBXns5d7PnpFt+NdEuT3/pRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OfxTU0F9WhDQCF8cCpgV3eT66r30xdLJnuaQvm36lA=;
 b=brHhjBbui6ei2DsH+sehJps9eO5yH2U0VIuCLA11IFospEKO5f2PpegS585HzoswS3e1EOY2Ybt1AO8a3dDj7zOxO7ctXtCNCkFtqbWrruH0eYl0JsAqBPJLu7kdg+UkaDCuonRZh/oXIylM59X2vXPzxgLAQPOHrvqBrQQnch541vULLn6dRN4H8QknuennoSsXnGnUz45lsJgU103I/55Sp0nfCqH4WkQ0CH7g/RZlSTSmJCM5sP1A0OuvaPKPTkdaMeYx2kh3AgQbj7kmqKjtwQbsENMS4w2txW3vkv5vqnJeWAXprL79YHSnE8ENmhkHlxeRM0KN2HjoJ7Nliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OfxTU0F9WhDQCF8cCpgV3eT66r30xdLJnuaQvm36lA=;
 b=MojHjn0HIavRUofodc8xSWnoZNo3MWfFxHkfA2ChD5YGSps2pIQ0o6XAuOiep0FCuE/P4parxtV54DKFVzGj+Zv1K0UKb1bbUgz9qs7zLyUHG3o685z8luTfqx/IxqHUgJiueWHk+OGkm354KJ7BczuAjRyOWbK9/+VICKZTQPg=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by AS8PR08MB9072.eurprd08.prod.outlook.com (2603:10a6:20b:5c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 01:42:42 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 01:42:42 +0000
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
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [PATCH 2/3] KVM: arm64: nv: Don't request or attempt L1 VNCR
 mapping without vncr_tlb
Thread-Topic: [PATCH 2/3] KVM: arm64: nv: Don't request or attempt L1 VNCR
 mapping without vncr_tlb
Thread-Index: AQHde1zGBYkDnXd0PECWl1ojk9sLurc767UAgACG5SA=
Date: Tue, 24 Nov 2026 01:42:42 +0000
Message-ID:
 <AS2PR08MB97860AD10162A11B52229A44F7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261123150917.2679600-1-justin.he@arm.com>
	<20261123150917.2679600-3-justin.he@arm.com> <86cxrvzbyn.wl-maz@kernel.org>
In-Reply-To: <86cxrvzbyn.wl-maz@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|AS8PR08MB9072:EE_|CPH1EPF0000051A:EE_|DU0PR08MB8495:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bfcce44-5bfa-447b-abee-08df49cc4f84
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|38070700021|261102123227099003|10067099003|261021123027099003|56012099006|11063799006|4143699003|261026121527099003|261021121427099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 J/KH1gyCY4Wq1sPtv/rIgXOCGCSNWhcT06frMypuoZEAykR55AkseoE1gZ+AYotJmPVCQX/BE317TcxG1rPOAomdRaQWxFxGTNed23ZaiLSQQ2L35BHclmMmeVma2ACAHNo2mmkEfUnSCehOi/3Ob526hUvcv6xhqwQZg0irIdrKTDbn0y5G6rPRUxh/hAM6QPFhzRdCkljwVEHSTrxOC7yooPkjZimJU6512tTrJ7LkDhwYi4tezbZ6LgNsAZIB8B7PC6OwH6EmUDG5wO50ube+O753ymbBFg6aA2dBo88+vp5/IVmGJQPRt73pDFfpUmWUFAZEY4xvcpMO6NgyTcyiv9ZfYl701CmmhA9VzwJkXB7wmS1r6Fw+0zxtdOWJ6YO9b3OOY2Bfq928BQ490CBnKp8bMj+8ZEF3OBVY8ZQI39ygqzitK6XpP7kx3k8qTARRRYktpF5VgbUU+8KQhiGYNSMk+ukqPCRqU752WzaFTJ9k30KjB5YkrK0qkFUXoFa048F2XJbas+GSU3V1eBbAsEvmqpaYasghxmFhb2vw/Odlp4k8veSw5LajcGGZqbHCUx5hHQMZf8JX326G1xTILW2eABsx+HTj2AlO5w1Zx33K7sPoWhhewGd5ugJ4hUBFtBIrFJuGDRPGij9mDlOCk4g4d8872T1WmR8+VObWRq7Lqh/VUAQQLnKz2pqOVnqqxTD0PwPP2Dd86yfARB1yTVbrGOBPXJBs1j26yrg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(38070700021)(261102123227099003)(10067099003)(261021123027099003)(56012099006)(11063799006)(4143699003)(261026121527099003)(261021121427099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
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
 VtJNyp8iYa6lZsKwfHLPblufKmv23HZ6BFf1+7fo5SdLKBj8FVNFwdoWXqLhIPugbcF6n5Q/T1xfVEQgZQXf+fjqjEYXeGXjAW/Kx2ty4Om/fHPVwFqwmR8eHzAqXglyUBWNXEBl5YpPey3GX5Hko+GbIDqSSlEwUt4XFKCgUFJ1NxKYvAiWWB6q8o2zeR+OfwReqxLF21xdzstjgHYLfX7jVOgitXMBlGJ0WguxVztQ1zIlHIxl2MTtg1o87+2Pm9ZgSIczxIerOKRiLQornspVnPrUugua/i5gb9WjXeiAVm16D5eYuDG/fY+L2aGM7ryo4Al/AYHu9FO1ahwaww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9072
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF0000051A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c2a35d7f-d287-4fb8-a425-08df49cc3b46
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|35042699022|7416014|23010399003|36860700016|82310400026|10067099003|4143699003|11063799006|261021121427099003|56012099006|261021123027099003|261102123227099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4nILW1SRTbS8Opwu8SK2cZp0x1Ly15Qtledfu/l4Eh8a29uUnoso8K+YaLe7Qcvo7KjwwZVrbvicERJqx0lXCiGfcPEB4/9Qfy7+ZbOV5QC6BA09aEbS/PelMaHNH/sDRk2KgkPKkwLy6C5wzPpWL5FQ07V0cIiZMgT4KGRugResfuTeBGrGBe7jb/U+VwcUAphszbsahqGnTFmLX6xp1BffDzYKbeK8/hUV255dOpBz6NDNwLAubDSZEPNfVcQqxd9prWWnm4JCgTmQIOiHD/4b7KCWZdMZrdVcflphAqT20ydrwBEpS+Yj22wgW6O+75mWnPoZIAMBy2y5UcRAOd5m9tGG49OZcMkgDqhOuQazwxI6ApPxDCXNIX3fy2oxyr7C4BuV8gBbuWVB8V9iwV6naYO9+WCTx4jeVXbZB2n9qtWou7OTojOh9V48pK7miPBNMXLIcvf3mAVMZy0Te2dF+ErMxv6AW88Y6klxl1OFMTg4P0ZDw8fRXwb2OyX6NgzErZZ5CjUnpP2ltUB3zC6ZawXDNOyad0ETtvNI5Uzvc3WmzTdcHxGWaSHd+QgelhoH8NGTSsRme0guUH2q4iTY6ewPxc/asKRGhFcA79kOlfGgFwVu5BHuFLwd+dvFUWQ/PTqtZiNRv4IBZCQ9PvfwP8bKhXA4TxTj8BCoy92uswmhI77U+ugKazRROs7yxd23F49lKEg8Jn9LFYfeuw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(35042699022)(7416014)(23010399003)(36860700016)(82310400026)(10067099003)(4143699003)(11063799006)(261021121427099003)(56012099006)(261021123027099003)(261102123227099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mk/Wyh8duP0ixz6Wsbx/E9Vzg4hMgFEezA/5szG8q9A27nPEM3Ju6a/lAm4Ri5Ieh5c6h0khLDCwtPjc0ZHDbqNMGk9Cupbg95j2m0jDU+TcCwoJRxSA26UqqwD2xN+sIChQUb6DQaWMYreulPH2oVt+7KYPDmUWlcHLWnnfWplj1EzY1sjTHDEO0q4cv5oIX5p4WQqYk0ysoZfOxLyO8Rfw12VByNm6vAEgKIWplWC/B1Qshz45KF4z+9sb8AsGNb9JteUcHEeUdclGIMuQuxslGKh72w4w5bAy8/PJHNnW0p7tRvihmincQ31Zi4OcIhKwhkxWpINjk1niPbRYlNbwNoOYvWxPl4ZGCdCAqpUnU8MK/nhI/2yuByhlClxlYCsW1toB6yzGQgElCkpEDm2tMd3u4hIHgH+vp3tW7kECVYMGF/yS07m45vrbtsoW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 01:43:16.4698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bfcce44-5bfa-447b-abee-08df49cc4f84
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF0000051A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8495



> -----Original Message-----
[...]
> On Mon, 23 Nov 2026 15:09:16 +0000,
> Jia He <justin.he@arm.com> wrote:
> >
> > vcpu->arch.vncr_tlb is only allocated when ID_AA64MMFR4_EL1.NV_frac
> > advertises FEAT_NV2. When NV_frac is cleared to 0 (or E2H0 is selected)=
,
> > vncr_tlb is NULL for the lifetime of the vCPU.
> >
> > Don't set KVM_REQ_MAP_L1_VNCR_EL2 in kvm_vcpu_load_hw_mmu()
> when
> > vncr_tlb is NULL. The only other place that sets this request is
> > kvm_translate_vncr(), which only runs on a FEAT_NV2 VNCR abort. Warn
> and
> > return early in kvm_map_l1_vncr() if vt is NULL before disabling
> > preemption and taking kvm->mmu_lock.
> >
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> >  arch/arm64/kvm/nested.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 4d83281a7a28..2f52c128f3a7 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -979,7 +979,8 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu
> *vcpu)
> >  				vcpu->arch.hw_mmu =3D
> get_s2_mmu_nested(vcpu);
> >  		}
> >
> > -		if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV)
> > +		if (vcpu->arch.vncr_tlb &&
> > +		    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV))
> >  			kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2,
> vcpu);
>=20
> How do we even get here? Now that you have short-circuited the vcpu
> state loading, I can't see how this code is reachable before we've
> actually initialised the relevant state.
>=20
> What am I missing?
>=20
> >  	}
> >  }
> > @@ -1761,6 +1762,9 @@ static void kvm_map_l1_vncr(struct kvm_vcpu
> *vcpu)
> >  	struct vncr_tlb *vt =3D vcpu->arch.vncr_tlb;
> >  	pgprot_t prot;
> >
> > +	if (WARN_ON_ONCE(!vt))
> > +		return;
> > +
>=20
> I don't think we want this. Either the code is rock solid, and the
> warning pointless, or we have terrible problems, and I really want to
> see the kernel exploding, specially given that NV is still an
> experimental feature.
>=20
Agreed. I'll drop this patch in v2. Patch 2/3 was only meant as a defensive=
 check,
and patch 1/3 should be sufficient.

Thanks,
Jia He (Justin)
