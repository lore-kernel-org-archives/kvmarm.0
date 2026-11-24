Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.162.6
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795526359;
	b=fz+ZHuNgig5RREYdgiRXmxauUKx0RGETNBOVnzwSnDFe5qDz+qNoWc7iTBzasrQR5EaA
	 oJWK4TZ6sQuC4s0l+Mrg8cJaGVuXTkWwNcNIZHOsgQbfk8B5D06EZmGjIatEXplPDiNph
	 qNZLnOLLvty2m69McLKslPmJp7V3LxgDUQavqUPiiN6oLmmCksDI8rediEkCvOt2eAgjW
	 7xPwf3hCv8QIzQ/5pX51DZVLs35Uk0WTM+nQvLKhaAzXSOFfRR8Ev5gGm4fARdsTAQqHi
	 c16H4hYr27YAx87pVgCoGxsSb9+09Z2FDs7qku/lzfcfR63+KKEXs6vHER5Zzrw7wZw==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795526359;
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
	bh=ASYyDX6H4ZkERzyPiwkFicibuFqGN6r+wUkl78wZvDk=;
	b=kzEmWpH3GWxIEYjs+bIHelZWe/UqZVwNpcZxUP5umEI/TlsdGtsKm3mP/7WQvXSW/wJy
	 fopbEme4/uGgwb64Q8GZu0PApuQHi7S66VXztPZJHNyu8BqFSjof5EA/38KDuJmk6xySX
	 nKsmAEGRmvTPiDP8HoQyyNDIJ3bwwXF4ahgHm6/Pwt0MUlRpd+EgSFqwuCF7mWI+tB4N0
	 5ZieqILX5aevjYdmnUCybYMeVz15GheNG8ZVYncQnJbyqYRE5TbdmkQ5gClsR/seUOvBG
	 qE6j/T4yvVtHpOyLKSdltOtyLLGEL0Omwgy5gMqucOlXDgwYpUYA307t/jQMY6XrXHA==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Yd1ltbLg;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Yd1ltbLg;
	arc=pass header.oldest-pass=2 smtp.remote-ip=40.107.162.6
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013006.outbound.protection.outlook.com [40.107.162.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3131B606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 13:19:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3131B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Yd1ltbLg;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Yd1ltbLg
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EllD2p/p38BNndR7g7QtlEsapznbNIHCOiBJXv6GeLCdSZJ26j/kWiV06xq9/Atxt/cUIVwkMUixBk0gmy8oXyEZHGS6t3I2zQR0pK8r41KgcTPEyjgz6uPcXE0HIlqdX/sBY/qqUKwF9E9A+oQfuyMXMqqT/RKi3TZ5xY8NzBd+lkdYA2xnDamNG0ydduI8jt04ag6+P5v1w34WpGXUHiSGTnOy7XpvjW8XIhQHt9IyFeqAOkcTVvso2iJ5FpDmsRMxQl7bJtIMbb5ycsfxLOCx+cZzhJpTZu74FTRg/U6LTWtwcyj8gZwRMdyJOFAnFMZ1wIJxDVUTm7ZyKgb7sA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASYyDX6H4ZkERzyPiwkFicibuFqGN6r+wUkl78wZvDk=;
 b=wFk0SN5XvuaGaI6aWV63ioqxSoPOnx/EyapM3z9eeXfgEWMkt5BDUAM5Tn9tarjvZakbf3wXpLN/fRBTWarB+qD4tldgiqh6KzhgpVlUemxiGXUVDpQp/pPNNItZTFGb4P+sMZR2g67ylZZCQe/fwA975anqTdN5Jq/X13AqHoPqV+lq1XOSGTQ7L+1IItXuJBYjn4UVQgNRbtFI5cjJme3BcLV0NRO0ooWbZps69MY2dvpykLOBsn+R1qpd/Bkw3oEcicX1cytV4Io4qi33RMOIj4tqucwVbwZY1rWHqyjHPv9e2S9SoPrGVTwiYzt3Ay0dMeoOVlL+mvpBKvuuRQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASYyDX6H4ZkERzyPiwkFicibuFqGN6r+wUkl78wZvDk=;
 b=Yd1ltbLg/cj2mHQL99VD6yJKNvftQgWA/Couaujd1iHGxghmTfqsHeS75beChwIt1pO0QUXoT4jNpjhQGxiiGC3Av7Tv/Rvg7H0Ze/LbPwywrBzhIb+uZZFZqg8w+DoTuRgDdxNPjASqRh+4DzQQnXH6+4zbtTH/GWV39z97JdI=
Received: from DUZP191CA0029.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f8::17)
 by AS8PR08MB9430.eurprd08.prod.outlook.com (2603:10a6:20b:5ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 13:19:11 +0000
Received: from DB1PEPF000509EC.eurprd03.prod.outlook.com
 (2603:10a6:10:4f8:cafe::31) by DUZP191CA0029.outlook.office365.com
 (2603:10a6:10:4f8::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Tue,
 24 Nov 2026 13:19:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EC.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.5
 via Frontend Transport; Tue, 24 Nov 2026 13:19:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fYX+ilE1g9OV5ODPEZcIuqXQ4Nv+Z+JSgQDLD/RSm3rkzM9Ft3w0pu1dWkCrEdRd+FhdUONuBwJFjiY9VORZO+Ip0znhzQokCpkge3CulbrdDl65JHBkx9IOZ/futdUV9esBGQ9j5bfoiFT6MScWhUZol4kp6na5P2hv+7/fjhDAcm36ao0lgAUc8sRiMtjx5/Py/ZpqBEioUiF4nrSMBqPNXefTENm6Kqvc+VZpsHDLPflXkhDNUhIiw64uBCVkLVAKVHTr9bZsLJ5Wpsf4anBBejCAyXoEZdo65DVrgnemxgWP9hOJ+964Qka2D8j2j7YqgJsW+1JhHhqJQG22iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASYyDX6H4ZkERzyPiwkFicibuFqGN6r+wUkl78wZvDk=;
 b=f6lGV/beQDzzkz5mJdE96xoKt3weaTxM1EUb9oZ2S9djMysaAFCHRw6VW6dKrNwn2ec7kLnbeJIqhuJXz1P+mgjz6Q7/JhZNnNHq3sxrDGbErS9rP2znXGt3Qf7RvURVO1rW+X/eQ3HX9zeoPMnryVVRTVLFXh1wC1pETV8Y1i5jAJv1Ftv0K+E+Iw8QjQSENJRq3F9PMh5UjEXepKzsVQSvCVfKZZh1zJb5o2362EhzFGrzB5luVvhBvDiCsVkWAKM3DvPwwI21STWk6z5nmj/zVRT2eAXwf7RwY+IXqYFvm6at2SZ2SDAgQvGwI38aG+ktUDqbPzTXiCsP5qz+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASYyDX6H4ZkERzyPiwkFicibuFqGN6r+wUkl78wZvDk=;
 b=Yd1ltbLg/cj2mHQL99VD6yJKNvftQgWA/Couaujd1iHGxghmTfqsHeS75beChwIt1pO0QUXoT4jNpjhQGxiiGC3Av7Tv/Rvg7H0Ze/LbPwywrBzhIb+uZZFZqg8w+DoTuRgDdxNPjASqRh+4DzQQnXH6+4zbtTH/GWV39z97JdI=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by GV2PR08MB8097.eurprd08.prod.outlook.com (2603:10a6:150:75::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 13:18:31 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 13:18:31 +0000
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
 Stoakes <ljs@kernel.org>, Dan Carpenter <dan@pereq.eu>
Subject: RE: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Thread-Topic: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Thread-Index: AQHde1zAtBC9mmT//0CTNvJgc0eqU7c75woAgACKa9CAALx7gIAABRQQ
Date: Tue, 24 Nov 2026 13:18:31 +0000
Message-ID:
 <AS2PR08MB9786B94054D2237817356701F7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261123150917.2679600-1-justin.he@arm.com>
	<20261123150917.2679600-2-justin.he@arm.com>	<86eccbzcqh.wl-maz@kernel.org>
	<AS2PR08MB978600ED2150F773D3E1631DF7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
 <868q2iz94w.wl-maz@kernel.org>
In-Reply-To: <868q2iz94w.wl-maz@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|GV2PR08MB8097:EE_|DB1PEPF000509EC:EE_|AS8PR08MB9430:EE_
X-MS-Office365-Filtering-Correlation-Id: e3c5e816-8da6-4372-f386-08df4a2d8720
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|38070700021|10067099003|261009223027099003|4143699003|56012099006|11063799006|261022075727099003|261021135927099003|261022105027099003|261021121427099003|261026140227099003|261026121527099003|261102123227099003|261028144727099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 CSKcRgsxutUiIcFVkxYNJsWRmJjp/MjQRjNsSu2tUet0d167ChRJ/fuU7xn80h07OJo0561JsQhEvCBb1doX/BR35iv7nHhpUiZdHirMCCijAEhhXaeEfkLPaDGvjadCCY/sSWBzEAG0a/64SL4q2OhW5kNGdC/PSmS2FfKYghg+JNMXjtvS/LphkuOvNmhrjzCVpwWqOreFpGOmGfB8N+ABGP5FV9SzKbTeIoTToe/apvrNYkqF7gL8IZmZdqQzblLvNXlh+3/ifgmzRyn/p293gQ3SMLT0la2Z5JrLVntEwN9DWinWVjuFbMRLARuMnrHKKWSVDkPxRUw+IDMkk2mNDKvWqNJMzcM5xGiR/B1c/5Oeg4y43wphUSRJuAzTAjzGw9aCInmRh5jCt7gbyUXpraLj3E6CWvTh2JA6zt02ybE6R88Yaf+5BkMJQYXWRhNFSApiKkezn2Lxc0OovCTeYUAZR+okUL1Wxlt/GeVCQY0YcGsuu6pgMMwOxIYDMYb3oLpXoSQ4rFGTjkEFkeyrowai7kCIbBC5T/UTaQGREgcKB3odmEMZaL59AOytUQ/3mAdQa/jsYhIGyBvBYJLIejcuDgzfy/kpEr9SURIGPleM/Y10LtptsPVHQOZ2wH+3UqYv6kEesMk3JGE2ZNpTKDzisj7TGvyB0nE4FSJHOdSTLlr+PGLfoM8rKtg97zzcCx3CVzvUdVmeIix0Aw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(38070700021)(10067099003)(261009223027099003)(4143699003)(56012099006)(11063799006)(261022075727099003)(261021135927099003)(261022105027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261102123227099003)(261028144727099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
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
 dwF4+Xj5rP+Rq8mvNS21OdIlIjXUNsaZtYTQ8h7OyMlI48huW4hx+1gPWelLZIm+Rrb+uDIIOqAUGGcZqFivNN6Cyqax1ny++ZYdw3e7q/nlFWVZJRiTfCHa1uLJvjShPReEoUnrmrkA4bxI72Gtmn3PTatqxSOgeo/3EraAMbEzs1uYpCHAlkONsu+YHfTpWdbAkMu1/IxQu7F+4Pa4NcS34Pqjn0eIPF+pZWZuiLe53CWYZi0/vCw+4+A9MGxXtsRIPyxZWzsH2JZkitiwdMHyNuwWVBgIM5TPDtL+v7itRA/OjCLfRIH4GogVMeCrtDJYnKSJlcpdzj6CeIfWWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8097
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1118281b-e538-4a7c-8354-08df4a2d6f84
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|82310400026|1800799024|7416014|376014|35042699022|36860700016|22082099003|18002099003|6133799003|261009223027099003|4143699003|10067099003|56012099006|11063799006|261102123227099003|261026140227099003|261028144727099003|261026121527099003|261021135927099003|261021121427099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	OqLY7LXEmU/0CA8njOe6NwHJSJVeDLTZ6MYoc1h0JACXUINXs67HXhwMrX+0BeYtai1fkDPYvyg+c6B0aDkRMNnxC/RrvcvY1RnrsasWSaBl78XgaJOBj+/b4Hyumr3RFG4ifkKEdl8qUxwM/EqGCzk20ipn7ntjGvncIIw1XmYsZ3ZO2+2TBZ8T9habfQqBJhQ1jh/5+qTiDg+WxXFGTMVAu+ymJ/JqO47J0QpLjyCyWgQ+dPIUl+2Ns0/VuIna1cYJWSG4uazS8dbrJJCLTrdq5x8QU/dhV9l5TMKH92jzwJpDd5UBvqzPUGuCstILV3T42nie3+uzE4+OzOjqRTCi3HqU5/h9a0yejFHU1jkfuc8oQSy3jpdcX+t+Owuckeb0luYGWa0zR6lhJaK+H2ui6sa4IxvG3CGa5fxLMLeOS1LMsele8JrZLaX2UK5f1DbKOn/udUerlRd2GfjKwxDx5dYoxxUFP7okbiRWbtSvbYf2ku4qkrJyxD65lxzaO/UZEph8BYq+YhjX7Li/2MrN9jhnC4LMUuMe81mJzxMxSygZmsfOEtfpeVcYalBQHOylz2uQQWzMQL7/iHumDWqYE7EfsCtycFdCkwwoLY6EjJ3I8KvZ8QIHdeJlrfxoQBMP4uMl4ZtY4pfjVUQo9G1qi3orFFp33ldh1hon9f03P+Rko5X/pqY5ACAdFrbb
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(82310400026)(1800799024)(7416014)(376014)(35042699022)(36860700016)(22082099003)(18002099003)(6133799003)(261009223027099003)(4143699003)(10067099003)(56012099006)(11063799006)(261102123227099003)(261026140227099003)(261028144727099003)(261026121527099003)(261021135927099003)(261021121427099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LyS38f4a9OTZBjbDnwnmjmt9T77OjnqtaGXuYGzI3/MDypZKYtR/z8/J2ZKqQsp+iUc/j2VB2s0qhCjtud47YgDLieIOKI3UAQLJ9U/7vwwfc1sVwNuERKNnBtcnglvPXUwVU68Ipgid2X00SdBToK4AfqvzYxUdBEENClGfjKZV6wJ7QHY+I1y8os5qnChgenbBCyRDEvyTeJkgTPEC8122G1p0MpHP7DHMlmNJB5w2KYx+PATlQ5qVAnE1Aznxit5XsDKLs6Euk5enww8CdfmRrZVm0J2CpXXIb/1cKu/SBxkJM7Bm4miHlth2nZXHW3oURFFWnRo4pzD1ZMggQgayjZRz3PYm9zi/DYbzcHNym13Cz6nK169BC8gt6BTqF0srmAaBcm2/HHlkx1HT7AoIQXFl11uulbUPnaxVUNtDn2bH6Vt4py/TACjTvdhy
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 13:19:10.9902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c5e816-8da6-4372-f386-08df4a2d8720
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9430



> -----Original Message-----
[...]
> > > > KVM_PRE_FAULT_MEMORY calls vcpu_load() as soon as
> > > KVM_ARM_VCPU_INIT has
> > > > completed. On arm64, however, kvm->arch.sysreg_masks, the trap
> > > > configuration, vncr_tlb and nested vGIC state are only set up on th=
e
> > > > first KVM_RUN in kvm_arch_vcpu_run_pid_change().
> > >
> > > I think I'm going to queue a patch disabling prefaulting immediately,
> > > and then we can fix this crap.
> > >
> > Fine with me. I'll rebase on top of it and have v2 re-enable
> > pre-faulting together with the load/put change.
>=20
> Don't worry about that. I can fix that myself when applying the
> patches.
>=20

Thanks. I'll leave the pre-fault enable alone in v2.

>=20
> > > > Since kvm_running_vcpu can now be set without VHE state on the CPU,
> use
> > > > host_ctxt->__hyp_running_vcpu in VHE enter_vmid_context() (matching
> > > > nVHE)
> > >
> > > Can you clarify under which circumstances we end-up on the TLB
> > > invalidation path? Simply faulting things in should not result in
> > > invalidation. Unless we end-up with MMU notifiers firing?
> > >
> > I found this by code inspection, not from a failure. A TLBI from a stag=
e-2
> > BBM or an MMU notifier can hit this path during pre-faulting, but befor=
e
> > the first run hw_mmu is canonical, so it makes no difference. As Lorenz=
o
> > said, I'll drop this hunk.
>=20
> vcpu->arch.hw_mmu being the canonical one before the first run doesn't
> hold anymore, since a7602ea542d4e ("KVM: arm64: nv: Initialize hw_mmu
> to NULL for nested vCPUs"), as userspace can configure things for an
> L2, before first run, and bad things happen otherwise.
>=20
> But the observation remains: if an MMU notifier occurs for any reason
> while pre-faulting (likely a concurrent reclaim), we get the "not
> quite loaded" vcpu in enter_vmid_context(). If vcpu->arch.hw_mmu is a
> valid (non-null) pointer, then we will restore whatever is in that
> structure when reaching exit_vmid_context(), and that's not what is
> intended.
>=20
> So I think we need that sort of exclusion. Either we track what is
> actually properly loaded (using __hyp_running_vcpu as you did before,
> or by checking whether the vcpu is in a valid state).
>=20

I'll keep the __hyp_running_vcpu change then. It follows what is
actually loaded on the CPU, and it matches nVHE.

> I think we have a somewhat similar breakage with 5651590be08a6 ("KVM:
> arm64: Load the vcpu in KVM_SET_VCPU_EVENTS"): as vcpu_load() now
> becomes sensitive to vcpu_has_run_once() being true, we can't tell
> anything of the state that is going to be evaluated by the event
> injection helper.
>=20

Agreed. It already crashes: with pre-faulting disabled, an all-zero
KVM_SET_VCPU_EVENTS before the first KVM_RUN triggers the same NULL vncr_tl=
b dereference here.

Instead of rejecting it, we could defer the injection to the first
KVM_RUN, once the state is finalised. I can try that as a separate
patch, if that sounds reasonable to you.


___=A0
Best Regards,
Jia He (Justin)

> We could prevent the non-running injection in KVM_SET_VCPU_EVENTS, but
> that's also a change in the API...
>=20
> 	M.
>=20
> --
> Without deviation from the norm, progress is not possible.
