Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012007.outbound.protection.outlook.com [52.101.66.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74213B38AF
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 13:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569748; cv=fail; b=TGUcxKwGC3fnHbta9/aB7dFknf4J0Bkr+iz0A/EYm4f7NpTVS/ZXNtE42Lvdj99L8+5gxYSN/8KLmRefCTTeWMgYw1j+jztgC8b8urqMQXp24WUgtCzWKWCpx/9P0kZ3eFJ2vxpPigKBBCStEHNcEIbBLn6Z8u6SqlyouT6fCB4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569748; c=relaxed/simple;
	bh=GIvB+wb1YHvvrgSs71r2+3ds+RX+5jXFSiHO+Fdz1Yg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oyvcM9gKQkJH4+/i+J8IJ7MlC8qGdR7n01W6HpxYgTEvHmmzHFqrF2Z+EQPC83tsGjNPMXqzwzHtbW2acD3I7wQx1x0LlHYZn6gT0t0ajx2BVChEhf3v8j/iy+KrbOU6KLjClego5hXNo2Lfb66u6ab9GqafAwC3D2L+PdPi+ng=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j8Bbb3WA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j8Bbb3WA; arc=fail smtp.client-ip=52.101.66.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j8Bbb3WA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j8Bbb3WA"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WV/aOQ5PVoKci/e0nA/PRBRwvqj2uU6Co7tiTHrr9vvtwGvGEKVR8nvlT7fUqY4XBHuxXdJ1bLbL5YCAkyww/wmry0qop3uheNiUHpc6yR4fnBj2Q9zexUXxsn1XHaOTzlnbLRO6NpTMZCaxsUcC5Wu70ajq0WDOvoV/pbPw4r2Vqdt7Prhnqf0UrBoFuJf3iqeYjjlXR6TQA7Lcqj24gAuB5S59jKiJHivxyLPv2h2ibHL44zmNx7uVsSxsBr5uKPSpcIkcUsqu27EEq9Jo9e/Cwj7W5E7cBHigHjfs87PcVfW/cDwFgJgjRuG5QMykK3jRpe2zbISzaYcigDbM7g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIvB+wb1YHvvrgSs71r2+3ds+RX+5jXFSiHO+Fdz1Yg=;
 b=tCr5kzQmYi2Wm8SV1KWb0mOTkXtNwG7ykVSeRa3KgplHSZE/9tPVecekaOe4FqPrHtDEsrizQbAD3FXvDYWdzyyOqz0mJWeosc2TXVof7pK1SIOhk9MaUhJY9p9PnQ7Ovngzk2g2KnLymep5KbiJNHk9u7Ocng+LfaemEACYaPZH5e6dqoE9cKPbY/SHBGN9+1IhhXocGEU8IRakego3r4oLu5ZdXk/g6xWM9P7HAyLvHLCUXEiLp97AcCXlzVecs4mOS5KkIv2hw548kt5isUJkpEip/jK/Q1la9irXGkXsD2e2y20+v3jRiUAAt4J3fa2IVnmsYUbSM1545IULxA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIvB+wb1YHvvrgSs71r2+3ds+RX+5jXFSiHO+Fdz1Yg=;
 b=j8Bbb3WAGXivbggFHFURa7oOwDjRisjUEWkJVNym7wecN+B3IVikmHaCI46m8XVB3qHicmtUXk3JQpmEy691MON0j3/fGTEkPN89C2pHt/BDGsvgkS9zU3r518MioJ9KAqwrBq+ugcMSQLfcU1I1JMT1URvwtG19OMW9eksoVas=
Received: from CWLP123CA0257.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19e::17)
 by AM9PR08MB5876.eurprd08.prod.outlook.com (2603:10a6:20b:2d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Tue, 7 Apr
 2026 13:48:59 +0000
Received: from AMS0EPF000001A2.eurprd05.prod.outlook.com
 (2603:10a6:400:19e:cafe::45) by CWLP123CA0257.outlook.office365.com
 (2603:10a6:400:19e::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.32 via Frontend Transport; Tue,
 7 Apr 2026 13:48:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A2.mail.protection.outlook.com (10.167.16.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.17
 via Frontend Transport; Tue, 7 Apr 2026 13:48:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMZFzHqbEW4kvjoKMaji+Wx7JzKj8qT+ATkQwSufLQBQpNX/xT14JYPekg3x0EJfUlF4i4ZEgN0j8hxEobhnwSv53PyAjc/5l7D16jp983WsTsaEw3EMeO82VMbORvhMf22kKuvxrvophuLaF1kMtH1kixbXUB479moAuNXunkKLMxr+KkyNwkUXoNjb9pVtdrCZB6UvBaQ98axeh4HyCTHCxmEWs1DnmqCNFxVJ5R12jABerFbTKVt4e0iUSZ1x8a7Yqv0Znzep+1P7Zihs/WlgHx7yeP2fKSXzCkWHHh6wTHGxTrI/sF2WABxuy0lHbQYDK585PTBLjGfDrAaDhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIvB+wb1YHvvrgSs71r2+3ds+RX+5jXFSiHO+Fdz1Yg=;
 b=ucyCkHu+NnQTR6DiXLJKApUSe48LBZyU7JfkzZIGUh3erfdrN6ebkTkF4gouI9cOIKUu3HyGR1wjVPQGnV1XV6IjvJTnnp70V2V97lmL9KzrIwWO8534m7+ETxmRCJ+d9OVEamou84WAhPzqAF66Q2Sxof3Lk0geA9QbVC+BTfVuN/9Nxy58bZYXYzjvgnjV1S2aF9rQQnurgvt8xogFvioV94jbxk8H5MDdo8s94Xg2IKnUF4a4oLI2sBKCr1L6L37Vna08i8hZAhS6oc/MBhB9gRtdrbsHJe+eZWCo8dkI5gYlRPYQXOW5d5F8LDFnqp4XezWkSYJbA4VDZfA4QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIvB+wb1YHvvrgSs71r2+3ds+RX+5jXFSiHO+Fdz1Yg=;
 b=j8Bbb3WAGXivbggFHFURa7oOwDjRisjUEWkJVNym7wecN+B3IVikmHaCI46m8XVB3qHicmtUXk3JQpmEy691MON0j3/fGTEkPN89C2pHt/BDGsvgkS9zU3r518MioJ9KAqwrBq+ugcMSQLfcU1I1JMT1URvwtG19OMW9eksoVas=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AM9PR08MB6306.eurprd08.prod.outlook.com (2603:10a6:20b:2d6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Tue, 7 Apr
 2026 13:47:56 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9769.020; Tue, 7 Apr 2026
 13:47:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v7 2/6] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Topic: [PATCH kvmtool v7 2/6] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Index: AQHcuuS/1X18caBLjkChCjpCC7O3e7XTtHyA
Date: Tue, 7 Apr 2026 13:47:56 +0000
Message-ID: <7164d3d0a7f592150acb08804f338b9cb80f9135.camel@arm.com>
References: <20260323164717.2571585-1-andre.przywara@arm.com>
	 <20260323164717.2571585-3-andre.przywara@arm.com>
In-Reply-To: <20260323164717.2571585-3-andre.przywara@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AM9PR08MB6306:EE_|AMS0EPF000001A2:EE_|AM9PR08MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: 72ef101c-5657-4f1a-ea3d-08de94ac6b86
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 HqBVG8FV8XqV15moxA9g5icyuIehtdJZCUW2eLMfB5qk/LKUfr0Q7fTWPK69gym07Ut52QcSygvAVJVBkdnVwEVKGBTslX/LnZCIlWVWIK4hptXEoIWPBJh8Hr1mviw1pN/AP8qVyvJpjvoP3dkr/G1JPrd/rZxXLZnwXpP7yv33AbvRi3FHAn7C941Sk2pAFGjmwNYb6CLJQmROBouf5qIO8HshwJJCuTXhZmge0Jcf194aE0O+POaHi8rw2km7G/TfCdTMVwAgLoiPl/TIwig422Crjlz3hdf89gxoaEiElCJGMS0tT+EixbpEjgWCycF4ki0+kblcZ0DqhsYFDrdHtvoneMLcmDy7V8Qu9To4yVv80vMzi12JUBQd8qOiqonuAKQSHtCVvtL21HhMBC6sN8wkENj/xEjTCdibSkX2nPtTOnCEmD1bh+HUtzG5aNVUgd71mbXvUJOeZiMiKoOhOMktdenjdzEjO037q9jh173PLObadRp0+ZWgAtxZ52mcnfaalolBzYlYdRelC7RdVe5KabuAbLpnCpa57fjHe7Y+BLwrEiJz8BCWCgHWbdbttOI1rW1P1KfM+YCLYQG+BCSaBzT98LRVBMcrELuxyc/kpt+32UI/5uWDjAORoTrpHcKvJsG86Icah+dJZt8NwaoAgjgEg3xTzkF1yL1zgCGgdE9hT+QRuuQQ6A0+YpKwiYMRdlsJxBGOdrZXaj7QQFMVNOVGIb73Csi0W0o/IAzZYCAbiAVT40YQwZajJ15H+MsYpa0QK+fC0yyTDpvpoXci1Sufl2oa/JmM0ZY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <42008E84D16EA646A5012EB9A652D7D1@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AsKtg5J1/VRvU04Fah5HWxne8kHWii958gnHWtAxVAmHcRouW+tOMyfmZzOmosi28lj1115KL1W5IZYcEOY15W6XzRHVYnDzVLg37BH7UCRw8A0qYLKfD+Xs4dnWStXWFYP6a5LSGbV2LLFnvmS9KNX1YjqrR8QR37tLEG/ktT3WMu8nfVU1iyG9bcwQqNqhS+JtTeW6NpswUi/dyfE8ZSodhaKVImYtn/gBjSQP4Wg7fA7hvSCipeCvTK94S6f7XiQgUhI1ugdTT2396jiByQveRF+fHWQBPyaPe0A+DKsLYTk3kquY6REdxr8575uL5I8fSrcDBR/uTpA5n+juqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6306
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9beb7fe6-42e1-4e9e-e368-08de94ac460e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|82310400026|36860700016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	COJWaYQ8fDvDr7U/UWDM96bdGxVYLcjQ5S+lXfmP5HOMt8iiPOu2YikftsHocXkZjEEd7w2a0+Cst0/cpuiHjdAnDK48fU24OXlq2Ke0vIXHSGbh+knCDxtXZYx0Qe8IIMNrk88hvGyZNCdu+7ZqFpLRzKHtmTJCqBj/5+sWKuareDVARUDEACuLQQJKddE5JhZ60T5TnKuQw9Rdg3RXHMMnwCqUObsgYXvqsQg8O9JRSIXCQydniNsWHNlaYBDjawSQRNmQM7Gm3UKYM4RLon7ZMCGfyYDbvPWZNpQpqtZdizhMv9U1btnTuQTBm9h3uQYo3zz/Uo5alBXlzK6s64LL4bAZvXF9H+fPuW3PSHJa4lFeFx7OZra3RHtxRrPXCqTCHPtCZ3DORTsPYdwyTwlBwnpnthrfiWef1PDpCg0gNsYnl0mfzt3piY2wY14Gu03Mn5ZDXnexd33rGKxuEqM7OPSBPChBXUu2ZrCw6i8ndkpTkmVmMikg2l7365f3ivO57QWFNQcnj58QrD4dPJmcvI9iJHuHYzZh45VzJ548vkvrhIPamBlJhYNI2FZbkvlgm5sNPmsG2AiFdTaY6b+3l1d4LniyD3AXr4Fq+9a5OGE5T2d0Tl+SiAWOV2B/4romhl+RffIW9dkK/9C/mEvP3yoXILVFE/BNgo9I6f82RTLQHOHIxPXI89mLqc+VMgmw1bi3ImRwasxOU2KzFdhlUHrsGZILdV1IOPJsenDiRUxnwme2XM4Ax+iAHlUGYoTOI4sGRS8vxtigc2JP+A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(82310400026)(36860700016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	W8E6wKKMgFTlxtMNbh2zI7r/6L+DijiM6LDGkA2Tm3hcXNpdED/ek3tXErAYi5O/VV92f0ZF1LVnMzSlnVGgRGrF+ZTyehjOD02VeHUEU79kXkNYBmbTxdi4iCKj3JztRpXSBwekFmJGAHO3hSf9bWGjZhjYuy0SkvF6mjpNub/470oob+CTNakm39PvQmx0aRkJ7TOWaYdXs9CGLZYqVYUBJGx9HyN0y1jhR7ToeYGLyiEGlUNyFswVKE4oUpXZtw+1vo7eQwxPElupsP4wuu3LsBke4w9bzHdNF+++sXIpPSzSI8X/WcnKEfA+YRJnis7j9JZnPRM35ZW/dPYtH9XBbsdeyk4RPtDJLu9FpnTYH/4/Kd73ihF9SGXMBIh5nZ55b5yQX9s5IOKPX5D8NEWQSjZTMmboltovsOEwDAfGtJ6XD+LkNQ6qohBZ1V5Q
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 13:48:59.1386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ef101c-5657-4f1a-ea3d-08de94ac6b86
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5876

T24gTW9uLCAyMDI2LTAzLTIzIGF0IDE3OjQ3ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gVXNlcyB0aGUgbmV3IFZHSUMgS1ZNIGRldmljZSBhdHRyaWJ1dGUgdG8gc2V0IHRoZSBtYWlu
dGVuYW5jZSBJUlEuDQo+IFRoaXMgaXMgZml4ZWQgdG8gdXNlIFBQSSA5LCBhcyBhIHBsYXRmb3Jt
IGRlY2lzaW9uIG1hZGUgYnkga3ZtdG9vbCwNCj4gbWF0Y2hpbmcgdGhlIFNCU0EgcmVjb21tZW5k
YXRpb24uDQo+IFVzZSB0aGUgb3Bwb3J0dW5pdHkgdG8gcGFzcyB0aGUga3ZtIHBvaW50ZXIgdG8N
Cj4gZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXMoKSwNCj4gYXMgdGhpcyBzaW1wbGlmaWVzIHRoZSBj
YWxsIGFuZCBhbGxvd3MgdXMgYWNjZXNzIHRvIHRoZSBuZXN0ZWRfdmlydA0KPiBjb25maWcgdmFy
aWFibGUgb24gdGhlIHdheS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJlIFByenl3YXJhIDxh
bmRyZS5wcnp5d2FyYUBhcm0uY29tPg0KDQpUaGlzIGxvb2tzIGdvb2QgdG8gbWUgbm93LiBUaGFu
a3MgZm9yIGFkZHJlc3NpbmcgdGhlIGlzc3VlcyENCg0KUmV2aWV3ZWQtYnk6IFNhc2NoYSBCaXNj
aG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IC0t
LQ0KPiDCoGFybTY0L2FybS1jcHUuY8KgwqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0NCj4gwqBhcm02
NC9naWMuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDI5ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tDQo+IMKgYXJtNjQvaW5jbHVkZS9rdm0vZ2ljLmggfMKgIDIgKy0NCj4gwqAzIGZp
bGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvYXJtNjQvYXJtLWNwdS5jIGIvYXJtNjQvYXJtLWNwdS5jDQo+IGluZGV4IDY5YmIy
Y2IyLi4wODQzYWMwNSAxMDA2NDQNCj4gLS0tIGEvYXJtNjQvYXJtLWNwdS5jDQo+ICsrKyBiL2Fy
bTY0L2FybS1jcHUuYw0KPiBAQCAtMTQsNyArMTQsNyBAQCBzdGF0aWMgdm9pZCBnZW5lcmF0ZV9m
ZHRfbm9kZXModm9pZCAqZmR0LCBzdHJ1Y3QNCj4ga3ZtICprdm0pDQo+IMKgew0KPiDCoAlpbnQg
dGltZXJfaW50ZXJydXB0c1s0XSA9IHsxMywgMTQsIDExLCAxMH07DQo+IMKgDQo+IC0JZ2ljX19n
ZW5lcmF0ZV9mZHRfbm9kZXMoZmR0LCBrdm0tPmNmZy5hcmNoLmlycWNoaXApOw0KPiArCWdpY19f
Z2VuZXJhdGVfZmR0X25vZGVzKGZkdCwga3ZtKTsNCj4gwqAJdGltZXJfX2dlbmVyYXRlX2ZkdF9u
b2RlcyhmZHQsIGt2bSwgdGltZXJfaW50ZXJydXB0cyk7DQo+IMKgCXBtdV9fZ2VuZXJhdGVfZmR0
X25vZGVzKGZkdCwga3ZtKTsNCj4gwqB9DQo+IGRpZmYgLS1naXQgYS9hcm02NC9naWMuYyBiL2Fy
bTY0L2dpYy5jDQo+IGluZGV4IGIwZDNhMWFiLi5iMGJlOWU1NyAxMDA2NDQNCj4gLS0tIGEvYXJt
NjQvZ2ljLmMNCj4gKysrIGIvYXJtNjQvZ2ljLmMNCj4gQEAgLTExLDYgKzExLDggQEANCj4gwqAN
Cj4gwqAjZGVmaW5lIElSUUNISVBfR0lDIDANCj4gwqANCj4gKyNkZWZpbmUgR0lDX01BSU5UX0lS
UQk5DQo+ICsNCj4gwqBzdGF0aWMgaW50IGdpY19mZCA9IC0xOw0KPiDCoHN0YXRpYyB1NjQgZ2lj
X3JlZGlzdHNfYmFzZTsNCj4gwqBzdGF0aWMgdTY0IGdpY19yZWRpc3RzX3NpemU7DQo+IEBAIC0z
MDIsMTAgKzMwNCwxNSBAQCBzdGF0aWMgaW50IGdpY19faW5pdF9naWMoc3RydWN0IGt2bSAqa3Zt
KQ0KPiDCoA0KPiDCoAlpbnQgbGluZXMgPSBpcnFfX2dldF9ucl9hbGxvY2F0ZWRfbGluZXMoKTsN
Cj4gwqAJdTMyIG5yX2lycXMgPSBBTElHTihsaW5lcywgMzIpICsgR0lDX1NQSV9JUlFfQkFTRTsN
Cj4gKwl1MzIgbWFpbnRfaXJxID0gR0lDX1BQSV9JUlFfQkFTRSArIEdJQ19NQUlOVF9JUlE7DQo+
IMKgCXN0cnVjdCBrdm1fZGV2aWNlX2F0dHIgbnJfaXJxc19hdHRyID0gew0KPiDCoAkJLmdyb3Vw
CT0gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfTlJfSVJRUywNCj4gwqAJCS5hZGRyCT0gKHU2NCkodW5z
aWduZWQgbG9uZykmbnJfaXJxcywNCj4gwqAJfTsNCj4gKwlzdHJ1Y3Qga3ZtX2RldmljZV9hdHRy
IG1haW50X2lycV9hdHRyID0gew0KPiArCQkuZ3JvdXAJPSBLVk1fREVWX0FSTV9WR0lDX0dSUF9N
QUlOVF9JUlEsDQo+ICsJCS5hZGRyCT0gKHU2NCkodW5zaWduZWQgbG9uZykmbWFpbnRfaXJxLA0K
PiArCX07DQo+IMKgCXN0cnVjdCBrdm1fZGV2aWNlX2F0dHIgdmdpY19pbml0X2F0dHIgPSB7DQo+
IMKgCQkuZ3JvdXAJPSBLVk1fREVWX0FSTV9WR0lDX0dSUF9DVFJMLA0KPiDCoAkJLmF0dHIJPSBL
Vk1fREVWX0FSTV9WR0lDX0NUUkxfSU5JVCwNCj4gQEAgLTMyNSw2ICszMzIsMTYgQEAgc3RhdGlj
IGludCBnaWNfX2luaXRfZ2ljKHN0cnVjdCBrdm0gKmt2bSkNCj4gwqAJCQlyZXR1cm4gcmV0Ow0K
PiDCoAl9DQo+IMKgDQo+ICsJaWYgKGt2bS0+Y2ZnLmFyY2gubmVzdGVkX3ZpcnQpIHsNCj4gKwkJ
cmV0ID0gaW9jdGwoZ2ljX2ZkLCBLVk1fSEFTX0RFVklDRV9BVFRSLA0KPiAmbWFpbnRfaXJxX2F0
dHIpOw0KPiArCQlpZiAoIXJldCkNCj4gKwkJCXJldCA9IGlvY3RsKGdpY19mZCwgS1ZNX1NFVF9E
RVZJQ0VfQVRUUiwNCj4gJm1haW50X2lycV9hdHRyKTsNCj4gKwkJaWYgKHJldCkgew0KPiArCQkJ
cHJfZXJyKCJjb3VsZCBub3Qgc2V0IG1haW50ZW5hbmNlIElSUVxuIik7DQo+ICsJCQlyZXR1cm4g
cmV0Ow0KPiArCQl9DQo+ICsJfQ0KPiArDQo+IMKgCWlycV9fcm91dGluZ19pbml0KGt2bSk7DQo+
IMKgDQo+IMKgCWlmICghaW9jdGwoZ2ljX2ZkLCBLVk1fSEFTX0RFVklDRV9BVFRSLCAmdmdpY19p
bml0X2F0dHIpKSB7DQo+IEBAIC0zNDIsNyArMzU5LDcgQEAgc3RhdGljIGludCBnaWNfX2luaXRf
Z2ljKHN0cnVjdCBrdm0gKmt2bSkNCj4gwqB9DQo+IMKgbGF0ZV9pbml0KGdpY19faW5pdF9naWMp
DQo+IMKgDQo+IC12b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgZW51bSBp
cnFjaGlwX3R5cGUgdHlwZSkNCj4gK3ZvaWQgZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXModm9pZCAq
ZmR0LCBzdHJ1Y3Qga3ZtICprdm0pDQo+IMKgew0KPiDCoAljb25zdCBjaGFyICpjb21wYXRpYmxl
LCAqbXNpX2NvbXBhdGlibGUgPSBOVUxMOw0KPiDCoAl1NjQgbXNpX3Byb3BbMl07DQo+IEBAIC0z
NTAsOCArMzY3LDEyIEBAIHZvaWQgZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXModm9pZCAqZmR0LCBl
bnVtDQo+IGlycWNoaXBfdHlwZSB0eXBlKQ0KPiDCoAkJY3B1X3RvX2ZkdDY0KEFSTV9HSUNfRElT
VF9CQVNFKSwNCj4gY3B1X3RvX2ZkdDY0KEFSTV9HSUNfRElTVF9TSVpFKSwNCj4gwqAJCTAsIDAs
CQkJCS8qIHRvIGJlIGZpbGxlZCAqLw0KPiDCoAl9Ow0KPiArCXUzMiBtYWludF9pcnFbXSA9IHsN
Cj4gKwkJY3B1X3RvX2ZkdDMyKEdJQ19GRFRfSVJRX1RZUEVfUFBJKSwNCj4gY3B1X3RvX2ZkdDMy
KEdJQ19NQUlOVF9JUlEpLA0KPiArCQljcHVfdG9fZmR0MzIoZ2ljX19nZXRfZmR0X2lycV9jcHVt
YXNrKGt2bSkgfA0KPiBJUlFfVFlQRV9MRVZFTF9ISUdIKQ0KPiArCX07DQo+IMKgDQo+IC0Jc3dp
dGNoICh0eXBlKSB7DQo+ICsJc3dpdGNoIChrdm0tPmNmZy5hcmNoLmlycWNoaXApIHsNCj4gwqAJ
Y2FzZSBJUlFDSElQX0dJQ1YyTToNCj4gwqAJCW1zaV9jb21wYXRpYmxlID0gImFybSxnaWMtdjJt
LWZyYW1lIjsNCj4gwqAJCS8qIGZhbGwtdGhyb3VnaCAqLw0KPiBAQCAtMzc3LDYgKzM5OCwxMCBA
QCB2b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgZW51bQ0KPiBpcnFjaGlw
X3R5cGUgdHlwZSkNCj4gwqAJX0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICIjaW50ZXJydXB0
LWNlbGxzIiwNCj4gR0lDX0ZEVF9JUlFfTlVNX0NFTExTKSk7DQo+IMKgCV9GRFQoZmR0X3Byb3Bl
cnR5KGZkdCwgImludGVycnVwdC1jb250cm9sbGVyIiwgTlVMTCwgMCkpOw0KPiDCoAlfRkRUKGZk
dF9wcm9wZXJ0eShmZHQsICJyZWciLCByZWdfcHJvcCwgc2l6ZW9mKHJlZ19wcm9wKSkpOw0KPiAr
CWlmIChrdm0tPmNmZy5hcmNoLm5lc3RlZF92aXJ0KSB7DQo+ICsJCV9GRFQoZmR0X3Byb3BlcnR5
KGZkdCwgImludGVycnVwdHMiLCBtYWludF9pcnEsDQo+ICsJCQkJwqAgc2l6ZW9mKG1haW50X2ly
cSkpKTsNCj4gKwl9DQo+IMKgCV9GRFQoZmR0X3Byb3BlcnR5X2NlbGwoZmR0LCAicGhhbmRsZSIs
IFBIQU5ETEVfR0lDKSk7DQo+IMKgCV9GRFQoZmR0X3Byb3BlcnR5X2NlbGwoZmR0LCAiI2FkZHJl
c3MtY2VsbHMiLCAyKSk7DQo+IMKgCV9GRFQoZmR0X3Byb3BlcnR5X2NlbGwoZmR0LCAiI3NpemUt
Y2VsbHMiLCAyKSk7DQo+IGRpZmYgLS1naXQgYS9hcm02NC9pbmNsdWRlL2t2bS9naWMuaCBiL2Fy
bTY0L2luY2x1ZGUva3ZtL2dpYy5oDQo+IGluZGV4IGFkOGJjYmYyLi44NDkwY2NhNiAxMDA2NDQN
Cj4gLS0tIGEvYXJtNjQvaW5jbHVkZS9rdm0vZ2ljLmgNCj4gKysrIGIvYXJtNjQvaW5jbHVkZS9r
dm0vZ2ljLmgNCj4gQEAgLTM2LDcgKzM2LDcgQEAgc3RydWN0IGt2bTsNCj4gwqBpbnQgZ2ljX19h
bGxvY19pcnFudW0odm9pZCk7DQo+IMKgaW50IGdpY19fY3JlYXRlKHN0cnVjdCBrdm0gKmt2bSwg
ZW51bSBpcnFjaGlwX3R5cGUgdHlwZSk7DQo+IMKgaW50IGdpY19fY3JlYXRlX2dpY3YybV9mcmFt
ZShzdHJ1Y3Qga3ZtICprdm0sIHU2NCBtc2lfZnJhbWVfYWRkcik7DQo+IC12b2lkIGdpY19fZ2Vu
ZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgZW51bSBpcnFjaGlwX3R5cGUgdHlwZSk7DQo+ICt2
b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgc3RydWN0IGt2bSAqa3ZtKTsN
Cj4gwqB1MzIgZ2ljX19nZXRfZmR0X2lycV9jcHVtYXNrKHN0cnVjdCBrdm0gKmt2bSk7DQo+IMKg
DQo+IMKgaW50IGdpY19fYWRkX2lycWZkKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQgaW50IGdz
aSwgaW50DQo+IHRyaWdnZXJfZmQsDQoNCg==
