Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010054.outbound.protection.outlook.com [52.101.84.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5931B82B
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778260142; cv=fail; b=rQCCDXg/4l7EZcPGen0UdjOR/mgSaqbaJnQwl7SlrMskrFjlPSaS6wA7E+wCOebm6F//QQPRS8d57xl1zzGB75iMlA5HFzyMgTa+Bb8BIX5nwGvtrJo+r5Iq95GbMQywrm2iLZwggNpWD0vaH3iMAUTHcR+pD2RWva1Fv5B7Fdk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778260142; c=relaxed/simple;
	bh=/zY7DzvP3enSo4kINftotKroc+hSikEAyM/PJ63TYjU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W/EjTFaInI59F94lsQVMjCdyCWxnO8yKB7y/p2c1ETQmhhiU2sfbTRGhTPLOl6jBo6B6bOJnwAYhV1caGGYu9/myuWKwOIBpPGrrIHHgFdEqo3e2UgzzOMY362PGYs0bC67DsuG6oBbvqrNoAJwM/3u/fUGDI2rlPkO/iRf7DWs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qVBh3nvI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qVBh3nvI; arc=fail smtp.client-ip=52.101.84.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qVBh3nvI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qVBh3nvI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qPg/Djwpc6ybCV08DjhoxPEwR4OymzJRlG2G+oPSJlm9IwKr8DMv1fhWY2qwMlxR4rKO71Qwinwov7BRWZfsYS9+Q7yoSOxL8fwlhC93SDpS7Htq4Z42rVyQk1d8lO8Bw8Io4dkZ1Zgdf+J0btHxeVfsqY12TAFzg59cTAqTCburNlG52xIl7wVziB7BPK9Vg5YH37G5uZm1srDC6+R6JYVQLRvXXa0zl/uKANi5R0qw93Bjui36NxdkbzWbIgxw8E0mHVhzi8SLv4C/NG4CRVn6T5bnkm+q41hUhaLzoZQVwV0r/pZeLi56AOWh4xaNJnj/rEb0ZXGg9zjjJGRI3g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zY7DzvP3enSo4kINftotKroc+hSikEAyM/PJ63TYjU=;
 b=vlmJiAwBXCkRROmtLrfQD3jzhRPWUhNWJgi9V0xveahR3iT/oD9MNuTdcJSm6/N5kqg7TuwaEwoubsfVEMSxvIbLx7+RkZCJVLJhWFCjANpYhVJeJgZhTC0YLVo/VwHWbp73OdUUl5k9F1Lhs12ig5j3MJYDBXrc3p4LCxsrsJevKYpPQQFeesUMWa71dg5Z9qxI4gK9ilDt9NxbGmwOMlSUuH+rnEBn5MLtbuauUjOUgWwo+iNibmovk82lbD8qekjB+T+w1212XwLy0q1zYBlMMMioL89itWlST2zyaVtidBnNAAHuKvhht1fJnqro/uaiy6E3lfeA7uGzqcx+9A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zY7DzvP3enSo4kINftotKroc+hSikEAyM/PJ63TYjU=;
 b=qVBh3nvINnI158c0brvgLCtKNDplH3RNfaSVEru7mOHVn/sNirWQUp5S15IgYCJO7zmAKSGDPPmvo+6uMulC+ARZcmJ2CaUR4TRaJ4kanv64T0sd2o8WxgfQPA28gVHYhBZupXa9QfJCclsP9aNZSlHC6ZQiaZM570R7KaLeYPw=
Received: from AM0P309CA0024.EURP309.PROD.OUTLOOK.COM (2603:10a6:20b:28f::12)
 by DU0PR08MB8953.eurprd08.prod.outlook.com (2603:10a6:10:464::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Fri, 8 May
 2026 17:08:54 +0000
Received: from AM4PEPF00027A63.eurprd04.prod.outlook.com
 (2603:10a6:20b:28f:cafe::7f) by AM0P309CA0024.outlook.office365.com
 (2603:10a6:20b:28f::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.12 via Frontend Transport; Fri,
 8 May 2026 17:08:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A63.mail.protection.outlook.com (10.167.16.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.8
 via Frontend Transport; Fri, 8 May 2026 17:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qt9thjiBcfJ12N6QABh2ebxLKHLNVM+7DA2thg9NuE36E4fTH/A3DqyrKJeQWzici43ABMLXrmIoNNSEX/HmB8nDUYZFM/Lol3CYyqANcgbEU33ms5qWxoF0F3zNXNWVUxeCGXxQkBimXy0SvkgGGDNRhRLaG8qTpBkkll7O6uF4Utpe/ILSuK3jt+wvgiSEamor82s6Frg5n2jV22oGLGQNSFpfr/kpkrHoyk7JhRp7CJIoJe6EEt7KvVdUB+GnlVxgttwoMsSw/pjZUTw4gv2ID6CLW6b8Fg7zrY4tdFTXZyPW4Ic++QuvKOmpq9cMS+fKQxb8CGLFp+I983kAUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zY7DzvP3enSo4kINftotKroc+hSikEAyM/PJ63TYjU=;
 b=b2cHWVKy9HOcKx7w12lVGuwzR1dGB2zA5t6C/1O1YJ1PIbCHac+ZBzcUIxjwSoEMMhXA9xCbj0hqDgm0J1xNG4tGni6eYUtXg/BWRwOU/SzPNbNNL1xJf+o3IdPnr8z2zAyZQUeZ/TRy6jy8zo5aglVlMaKM/l2LRVZoluwiv9TtsQS/BoG/Bp6XTnrwRY1tqi0MSImd5zFgalSZxqDtreksOikmAupnkZE29QnToeDC7avYz60wYM/cYQNvHk14l2qTPlSnobadFJHJQp+r1WLGEewDEAQn+4zcDqGf5JlfIPRDeEj98nHRJX+TpMMOAGGzTyBtoFGhGvQ9ijUtVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zY7DzvP3enSo4kINftotKroc+hSikEAyM/PJ63TYjU=;
 b=qVBh3nvINnI158c0brvgLCtKNDplH3RNfaSVEru7mOHVn/sNirWQUp5S15IgYCJO7zmAKSGDPPmvo+6uMulC+ARZcmJ2CaUR4TRaJ4kanv64T0sd2o8WxgfQPA28gVHYhBZupXa9QfJCclsP9aNZSlHC6ZQiaZM570R7KaLeYPw=
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com (2603:10a6:20b:47::18)
 by PAXPR08MB7552.eurprd08.prod.outlook.com (2603:10a6:102:24f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Fri, 8 May
 2026 17:07:49 +0000
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7]) by AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7%5]) with mapi id 15.20.9891.008; Fri, 8 May 2026
 17:07:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 13/43] KVM: arm64: gic-v5: Make VPEs (non-)resident in
 vgic_load/put
Thread-Topic: [PATCH 13/43] KVM: arm64: gic-v5: Make VPEs (non-)resident in
 vgic_load/put
Thread-Index: AQHc1mBdE97Aj4N9FUmhjqBKds0YULX3ausAgA0CuAA=
Date: Fri, 8 May 2026 17:07:48 +0000
Message-ID: <e78aaca19c90c354552ac34da7c140a87c500c0c.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-14-sascha.bischoff@arm.com>
	 <86fr4czqu5.wl-maz@kernel.org>
In-Reply-To: <86fr4czqu5.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM6PR08MB3399:EE_|PAXPR08MB7552:EE_|AM4PEPF00027A63:EE_|DU0PR08MB8953:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f8eda49-160f-487f-c8fd-08dead247ba5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 +CzbmyARtr4pRgWtfishhfiD/dhQLS18qPuwPKYVEMbo4cHexU3d2zCrCGEnbixsd9uiKXdOW886keOd5SSEtCnoNUFYnU+1Q/eYzlGT430gqzrzmcwtyCeLBXdkoyqzrYa0YbA9cCJqXIgmYOpWBggqs6YQGBEru4Ol0mT1BT+HrOzF3AvdNGp7Vtcd3a6P5XeVo+8PsR+NE9V9ZbmvWrz2xzHwQrpMTnuCAjGWR1QR6OVy0IOhHXsWKQ0hs5sim9rtB/jW13QJCsm8w7Ad+QeAnXM8MaCwDbrMdBfZKinN+IV4Mao7OyYtQiwaEaJSlIEDaKTO4fErUAcDXzfMBEH4OBlHfzDOLtFfRrxIiUmsytatqeNdRqMEjs/MZxmySsxvSB2VMGjuabXWFX7J4M3SxlRzHB09ALQgBOuuRVZSjG4AFojiw/uwr26Gf4k3mI5Bg6gABDofjeTlbVWkcm5/UIdefCWaHHogUKPAcKbw2UDBCxS/cdcnqi4U8R8f8v/AgH2kTLYlDxlrhQtDEYukWec2+n4iKEs89cbuf5nWQR/b+8HTYgso5K8vvMa7iK+Rzb+y/Bz3EnOWxxrDK21MaI9w3WvnMNHJOcN2VAVHWODcUIONR3Ao8inB0F1+vCjNem3JGCEULvl0o3SFf7M7Ha08+AD1lrsRgw9rt9oL5HQAWLvxJdlSLDQus9/oZ1fWRBF9/11qE7Hs7+/ZjgQoszEmrJDfmbcyhOJW91nGTcCBRFWJEOTt4D7t/GlG
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3399.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E990BF85C1DED4EAEAC607017791D9E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 VbXmvi6r7bKMPpFfR2QDrPnx4W52nYc/NIL7twOpkgmTQi2BNTZlKw1ejZ1LEdJbJmaGQIL9KQJAnDD4IPpU3H6dEbr1cyEq/jh4zhHc4kkMobVd40dfe0RrrMnYWx+BUBZIUrXIwOIX5S+iDNaF/CLYmdY+I1r9qHAooNAKXu7ub3x3jWnsf18nmmi7gv0FXiDM6174pCWRcU6plHmfxkEgO5Zn+EaXnA+wbIPhLvI8Ux9thxR5vz8JEVnRlHMmt/BNNAHwrpvP+BRKrTatJoRIlom7yKebWq99MSmlF9CRIUqrl2xkr49XnBPub3/1NeMbcpSZZZyGm0m/f0w+zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7552
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	91fb98bb-ec06-4761-17de-08dead2454f1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|14060799003|35042699022|82310400026|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MdRnbZz3rejma+aWCOKOB6pj3iUcoWknLTLLJ5aiLsWdaZW8o34cnsgNVbswqClvf1Sb716Yg7Vdh/+StYb/IZ84Hbwj57nKgRCgW7La2UyeEsOMKazg5bjlZy/CzVsvPg3AjJKOYntTYHK7dvmc5Re3fBiyr4rocPNCHaz11zGkLkWc1EomIuiZnpnxrJzdO8Sf07aNqjhgw5rmlX0fetWfyQpFxDCu/PBJzi74//q6+9QsNwiSGbpIaL5Co1uJmxAOJcNpBjpUz3HTUpVSDQjaWj4czpkp4/DDTDaohBhBl4KQRCpuuhb3T/m+ofzxYp2DMU/zG7sHnqDBf2NjNDcn0LnOlYLiL8ztj8u8ASj2i0MGiXMQUTSBzrEWsR7zV9j3dJOicCCFAELKhQ1NAmCATAIkIclo8z3zuY8xEPbNzfLKSYJ9uE3roZydOaG3euo5nhL/no0yJv8McG754Bg22HSyChJ7ZQpO31P0dp8H2hQ9Me83hE4Q+ECWZPJ0ZPMyK3m9sYeWDKpYsEBtXppIv/8L+29tXApz5U8nexOA7x+sIwBrpCDFZjFJWz5hHfS0rbTDVUmbjl3s5dGNbe+b/DJ9V5CMxvCFIaCEUNY/YyBO5VVCATV7Jl1YnsVwvxDYcbU859sLOq8cgRwp9sT056c1rmBQ+uL7zgUwsCDaVz/KwDNL2vt5aYqD50yrpiw64TxooWBQfq5r+2DY9qtEJ5Hkq+GTyCKu1005FJU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(14060799003)(35042699022)(82310400026)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	S4+MxfV9POQbSskLVsKDk9yYjKYNivRh/yy9qgGoxXs0YsJHzlKU5847+XbxZTN6K4llyVdQaR30B7C3YPnZ+CbjBK2Y4LnkWYuUDXSTTU564t2qGRYEQwdWDH+2Mzt0xbT97oItS/mWeLrjW0djB3mWCCW0oAoybsfAVtg8pOTiajTsFZAx4PzeMVgK/HIe8djrgXnv1PAxlSiV/nWyQXb5KfvOgzZLMF8dYY8VxAnwmRjLMvlQxgo7ovMeRgQpGSonsxaQppBsmhCBcMJQmVhnHzgN6dnpcJafBqXZn6idZ4zNu4jmsZWM2eDQGmKvMn4MI5WTonhL9ocJV5Oe/Qc3vgeGyvZOuX0YMdQ6qAXxBFWfYsCSgRoqOIsqkR2I9ZsiDLOe0YI6HmgoHrU76AFvPJr42dleTLnRbdsMfyMHu2+5ANfXWzDu3GEE5Ig6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 17:08:53.7132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8eda49-160f-487f-c8fd-08dead247ba5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8953

T24gVGh1LCAyMDI2LTA0LTMwIGF0IDExOjI2ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMjcgQXByIDIwMjYgMTc6MTA6MjggKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEV4dGVuZCB2Z2ljX3Y1
X2xvYWQgYW5kIHZnaWNfdjVfcHV0IHRvIG1ha2UgdGhlIFZQRXMgcmVzaWRlbnQgYW5kDQo+ID4g
bm9uLXJlc2lkZW50LCByZXNwZWN0aXZlbHkuIFRoaXMgbWFrZXMgdGhlIElSUyBhd2FyZSBvZiB3
aGljaCBWUEUNCj4gPiBpcw0KPiA+IGN1cnJlbnRseSByZXNpZGVudCwgYW5kIHRoZXJlZm9yZSBh
bGxvd3MgaXQgdG8gcGVyZm9ybSBIUFBJDQo+ID4gc2VsZWN0aW9uDQo+ID4gZm9yIExQSXMgYW5k
IFNQSXMsIHdoaWNoIHdvdWxkIG90aGVyd2lzZSBuZXZlciBiZSBzaWduYWxsZWQgdG8gdGhlDQo+
ID4gVlBFLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hh
LmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjUuYyB8IDEyICsrKysrKysrKystLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUu
Yw0KPiA+IGluZGV4IDkyYmI2M2I2ZGQ2YmIuLjExYTFhNDkxYjdlMGEgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IEBAIC0xMDUzLDYgKzEwNTMsOCBAQCB2b2lkIHZnaWNfdjVf
Zmx1c2hfcHBpX3N0YXRlKHN0cnVjdCBrdm1fdmNwdQ0KPiA+ICp2Y3B1KQ0KPiA+IMKgdm9pZCB2
Z2ljX3Y1X2xvYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgew0KPiA+IMKgCXN0cnVj
dCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0gJnZjcHUtDQo+ID4gPmFyY2gudmdpY19jcHUudmdp
Y192NTsNCj4gPiArCXUxNiB2bSA9IHZnaWNfdjVfdm1faWQodmNwdS0+a3ZtKTsNCj4gPiArCXUx
NiB2cGUgPSB2Z2ljX3Y1X3ZwZV9pZCh2Y3B1KTsNCj4gPiDCoA0KPiA+IMKgCS8qDQo+ID4gwqAJ
ICogT24gdGhlIFdGSSBwYXRoLCB2Z2ljX2xvYWQgaXMgY2FsbGVkIGEgc2Vjb25kIHRpbWUuIFRo
ZQ0KPiA+IGZpcnN0IGlzIHdoZW4NCj4gPiBAQCAtMTA2NSw3ICsxMDY3LDExIEBAIHZvaWQgdmdp
Y192NV9sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoA0KPiA+IMKgCWt2bV9jYWxs
X2h5cChfX3ZnaWNfdjVfcmVzdG9yZV92bWNyX2FwciwgY3B1X2lmKTsNCj4gPiDCoA0KPiA+IC0J
Y3B1X2lmLT5naWN2NV92cGUucmVzaWRlbnQgPSB0cnVlOw0KPiA+ICsJY3B1X2lmLT52Z2ljX2Nv
bnRleHRyID0gRklFTERfUFJFUChJQ0hfQ09OVEVYVFJfRUwyX1YsDQo+ID4gdHJ1ZSkgfA0KPiA+
ICsJCQkJRklFTERfUFJFUChJQ0hfQ09OVEVYVFJfRUwyX1ZQRSwNCj4gPiB2cGUpIHwNCj4gPiAr
CQkJCUZJRUxEX1BSRVAoSUNIX0NPTlRFWFRSX0VMMl9WTSwNCj4gPiB2bSk7DQo+ID4gKw0KPiA+
ICsJa3ZtX2NhbGxfaHlwKF9fdmdpY192NV9tYWtlX3Jlc2lkZW50LCBjcHVfaWYpOw0KPiA+IMKg
fQ0KPiA+IMKgDQo+ID4gwqB2b2lkIHZnaWNfdjVfcHV0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkN
Cj4gPiBAQCAtMTA4Myw3ICsxMDg5LDkgQEAgdm9pZCB2Z2ljX3Y1X3B1dChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQo+ID4gwqANCj4gPiDCoAlrdm1fY2FsbF9oeXAoX192Z2ljX3Y1X3NhdmVfYXBy
LCBjcHVfaWYpOw0KPiA+IMKgDQo+ID4gLQljcHVfaWYtPmdpY3Y1X3ZwZS5yZXNpZGVudCA9IGZh
bHNlOw0KPiA+ICsJY3B1X2lmLT52Z2ljX2NvbnRleHRyID0gMDsNCj4gPiArDQo+ID4gKwlrdm1f
Y2FsbF9oeXAoX192Z2ljX3Y1X21ha2Vfbm9uX3Jlc2lkZW50LCBjcHVfaWYpOw0KPiA+IMKgDQo+
ID4gwqAJLyogVGhlIHNoYWRvdyBwcmlvcml0eSBpcyBvbmx5IHVwZGF0ZWQgb24gZW50ZXJpbmcg
V0ZJICovDQo+ID4gwqAJaWYgKHZjcHVfZ2V0X2ZsYWcodmNwdSwgSU5fV0ZJKSkNCj4gDQo+IFNo
b3VsZCB0aGlzIHBhdGNoIGJlIGZvbGRlZCBpbiBwYXRjaCAjMz8gVGhleSBzZWVtIHRvIG92ZXJs
YXAgaW4NCj4gbWFqb3INCj4gd2F5cy4NCg0KWWVhaCwgYWdyZWVkLiBJJ3ZlIG1lcmdlZCAjMyBh
bmQgIzEzIHRvZ2V0aGVyLg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiAJTS4NCj4gDQoNClRoYW5r
cywNClNhc2NoYQ0K
