Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011015.outbound.protection.outlook.com [40.107.130.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8C0427F8B
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890706; cv=fail; b=PDLdRdgaIU1QVhnQtiwgTq31A/CBpeEdOS3+G64k96KGwTiumfA4+QowlnfpYpUJo2v5O84E3p+FE59aAD+jOnBm725yhtVh7OT8/jQz6U5Q63dCezkwn4hEAYgDeT4CYPxAvCU368L4tUivPUIjsbgv+IKrQNOf4ehM6BVLsIQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890706; c=relaxed/simple;
	bh=Y2ywh+0/9LSvhFF+DALGdh/o1lgabRGRBAdhituYJKc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NCfjBvRO/WdGJ/hWJn+mAMy4UM+y73CuQ24Cz6aTVzZmmzi+3dLWbRf6bn6GwID1y/JEElzzTSBNKh4nxADXlTVItNW5w0PY9wQAF87yQ1Rf7ARpTl6hksLbii2o6ZY9ep85DkkvmhCMCJdsPaDW1Avi/vKpvwNvoGt1EvcY8Cs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bvPsJl6G; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bvPsJl6G; arc=fail smtp.client-ip=40.107.130.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bvPsJl6G";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bvPsJl6G"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VgH4NeZRkf2XWd4vvvOoYIT86arOOCHqOXNgHqSBl8MiY+8U1coqYbooxvTr9NgRhTIGbOD1sxdtjear6mkh67V80pAkJqglbO+xLlAt68OICpMdGDmty9mAGqIIa3uIWAC4gCRmLvAd//V3RKHNLzx7aLiwK5pv9KO0e6gZBmFEJ6z6L6UCQciiRmNujB77Lcc/O0Dk9NBMbY7YN5BtAjv4W8BbnOMBpced9ZQ6D7wqSE9OQUPQXE2uxAikI/JqOc9DSD5LYHoezBILeci2AYLdIKE1CQm8xonia5P2BTM+A0VuUu+ae1owHptkZGqugP3z75Mf25qMmmFWFBnU+Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjjlVX3v0GrT+4/AWD/QVRYg2AyYotu2xYvCLKpT9bU=;
 b=TqPBZcpvhptPz3e2tvIB37vgqVED1YacIKSXo1v31HS4mun83H3OLEdAxqcyOcLi9t5B88iqkta5nf+VHmzZBrfkhHjYboYP1eJsAlUdo+jHj8h5CRNBe5OTlYUn89bY7MciSTpfZsoNYnTsf09Q6bfLZ3S4gAU33GWRvnSdyzcaDI8Eqppxt6KXcDh+2VR/OXJX690ZM26HbULq2tMh2JL3G3S4pG6wg3BbEI08bnj+7Nhw/mfxwhxWnOOTe4RmYt/YmpJOm1NT5Lv7TwzbJsSBIZdHbCOo4xzEd/zAefemd+uSC4+bnrbasxq8aX9TcbNak5UKEifdbs4w/aGq3w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjjlVX3v0GrT+4/AWD/QVRYg2AyYotu2xYvCLKpT9bU=;
 b=bvPsJl6Gi/qJrCBIHMQpW7WPXu5OKJykMyriifr/nlFCazYQTgIDqqVnFWen7rNpJJHtB/yNn0znVgReisqPoIDURKOxwqCaw0WRs3/74jYFpX28XaO7JEEqaH6ZtloWECBwBmpUDD6slNnkHhRQQo1kOTaQ6KFIJxXcaTOjJOg=
Received: from DUZPR01CA0038.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::12) by PAWPR08MB9519.eurprd08.prod.outlook.com
 (2603:10a6:102:2f1::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Fri, 24 Jul
 2026 10:58:13 +0000
Received: from DU6PEPF0000B61E.eurprd02.prod.outlook.com
 (2603:10a6:10:468:cafe::4a) by DUZPR01CA0038.outlook.office365.com
 (2603:10a6:10:468::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:58:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61E.mail.protection.outlook.com (10.167.8.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:58:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yjB4zWTIwQl9tbpcpBrEWQdQYaZbJmDnJFibdiTKRNAqtSu1c+YBkNsuyyLBF8msTczN//HOZhF4QvJScUlIMxaNsvyBBjyUXsvVslbtPdWY3Exp+3NkddNk7Z9hPOfnlWJhsazZyqs6QJoEsR1h9G8UZWJ39Bpobh3dACmw6wvXQ6vn7sWWI5wgFH+r9QsDeLHJQaQKg2qi6sL+/hkMM4RmIi2aWQURAdggXgei5NR5nsyINxzVzQc/oaxnMh54v/gU5ya61efPfd3pgX/a//UxAuNXCTN4CJ8fvi0TAY85rHG/f7PyrxaUd4itrcH8LZZFJoAWyEXcWOrCS0xWbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjjlVX3v0GrT+4/AWD/QVRYg2AyYotu2xYvCLKpT9bU=;
 b=EdDPo8uu7oD090vogxJAbafCTey3y0GktJQZ+sZY+mJHrxE84B5ncZQGhUMZSaTgariL1Z/gkJZYxzLTcAyMUyp+HV1mMXaU75DarHs3eB/0crQhfRneeblQ9YZ64Bup0NB3baeIo2dzXD4hL37/I7XRmeDA2GJs01i9LMvt+/2lWuKN/3RESkWxLnP+lxBHFy3zpOy4FNfYDpBg4gfLmhhXgjOFCZrY4Fz1eohzCbQldwp/kGmlOOrXlZ6gP2q6Kl51ez41u3ECUoVVjt/nGWlyhZF4VMEX0R7WH4CSONoHIFlazxZ54EVFpm1xUnaUKBpQZlT91OJVNDjBi3nysg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjjlVX3v0GrT+4/AWD/QVRYg2AyYotu2xYvCLKpT9bU=;
 b=bvPsJl6Gi/qJrCBIHMQpW7WPXu5OKJykMyriifr/nlFCazYQTgIDqqVnFWen7rNpJJHtB/yNn0znVgReisqPoIDURKOxwqCaw0WRs3/74jYFpX28XaO7JEEqaH6ZtloWECBwBmpUDD6slNnkHhRQQo1kOTaQ6KFIJxXcaTOjJOg=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:57:10 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:57:10 +0000
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
Subject: [PATCH v4 34/48] KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
Thread-Topic: [PATCH v4 34/48] KVM: arm64: gic-v5: Add VGICv5 IST save/restore
 UAPI
Thread-Index: AQHdG1st6ZOC13q6KkSxrYLjad6E8Q==
Date: Fri, 24 Jul 2026 10:57:10 +0000
Message-ID: <20260724104819.1296803-35-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|DU6PEPF0000B61E:EE_|PAWPR08MB9519:EE_
X-MS-Office365-Filtering-Correlation-Id: c90f8cd5-ffea-4822-a936-08dee972750c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 VrGKSid9U4Ur2NkygnZH3Ydw8gEETPZTdgCoR7bYUZYS+knpUpS75ELi1TQ+5hZvc8j1432XO9pmQmK019m2/yJCjrpzTaP9oH4WfdSdqOQG9eYuXGDzFk1LN9Pz4V3lOmp0k10xzap3UdGCaxuMxiTfLJjk85P1Q564/3ryY6Xmex5nRVaD/kEAt/ifUQ16RWNNNhFuy24+6yH1EsBDS2H3uQZtDPmVj4jhxBtrVimzpSkFfQ7bh0SDOWx/K6Am9+9nMMKw8HLIrGRLTUCRHh9Z85104JKDJp5RZq8xowHVQtQlIAynbaevZmKn6MMTguCPB+SmUh1Dv1KYbNlgmwBaHUqgW895jDYoQEYmpc/qZNfkCpbSOfIA9Lu2XnhjjelCVJWf/98nTGbWw2+PD/AWC6gZUJbs1FsN8lMsDxnardGfPij1P5t7g8pDXpGIen25zmXELAygqFm080OAB5G1ruGMIM2QbuWszguilpO45DXMkWiW4SBeuPZMzuwx4BWnvnaLWrcVpKlXZWbilURos1mNXIf0kWzQgnCTYCYosPUmgrP2Akhjne7VtMxm8C0F+OeWekxo/bLAknkBt76ErLBWWXpQ+Hq2HbolTQI563EqFHbfZmNzQ08+5RKZE57qGI2bL0Ew6Wr3sYa0WFHq7F5o24pX+oqrXNNCiX6uhqhpWSCbYLPh9WD1i4so3oVOfWAWN4hNcbUBZ3h63Rlpeqak3Guep45/B26gcK4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 W4rVVBiW3T4IRjNuHK0MbUzQ3zDkabhGYZGLVCxt8YHUKdrIRDCxRqDNzMOqabwRoJxuWaQ8UhzV5SgS9UWF0ifL0MiNX9Fs+npAgi3oS+zJlJAHA5wEFzziWaMy9ASUH+dh7/varJDW2GSsGvgs2+bPQ4Wb4syuKyUjpu51CU3z48SnctAc/O7BetRtL595LUZfG2wl99VUHpqenszWZVK/p+F12vmKMcTBKzmWgdSLxVw+KAKcBqj5uQ7D5ayzvP2OEahHPgI62AWeGA63eBFn+yaa31X0dbxXN9EPYjcGvK9qiF9HJSfoO0hGRFi5TrqhHiBN2mdkASeK11zwxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3ab36e9c-29b2-48d4-6af1-08dee9724fab
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|35042699022|82310400026|23010399003|14060799003|1800799024|18002099003|6133799003|22082099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	e+9zaLp8OksvAxcZ+1r2E5J9H2R30J15teY2Mkvq0gD09Wx3TV5zMf7lJOgikvMickXyR43RmhtpHLeMDl+2DoewhvLcyn3scILRW4VupRQ448t869XArvBzwghUj6lv6Roea5WDYHfYRJkoDn0yAUnvlzKvzMF25Qz2iecc+p2cCy01vWxr4y1+IL1DuiGTN/ms86BvwXTZzpHgx298ex/VnCcp+D/+B3AKX8DsekuWgOyD63UX3IDXKZj41+pn5dx1Z9CI0ysxuUIPeuUcCqnEovCLRPtvK9syTL2ILVe4Q87exOuVLtCDH0zSoCHXLX6sDXJJcmg2N8fzokxblQHVly42AuCXzgP0Fpt4vA/4kqhpiw++gUXlh+jGUZNbf/gSAtzUoiwZE51Eq2Fp4wReLqJ8IbMEb0+fNzpZiAne2CIpw5FCLzcp2TbLLXNg9KcRmLOHpOOgsyaG0TxHoxPenVOkxrnH+0xh33uNWOYu+c6YE0QaaToAC8QeIWru+VrOF21n99btvgdxjMZx4x2HbGG5+xf3jQcv+OlhaNIhcvfyTeNfWdd6asBHjdr//hHZ70qz4ZuZ/pLDQWtpe76eUJIGRxKBEDsQBhToW1/+8hxObQA4wJA9QW0Nx3o0joBa0GhlH7tjZpw+WB+fxM7pTXXya/UhQZ6N/spfQgBGpLfchV5HOmO6dR2rpdBz4SAOqo6EbAh+jcfH2jJ1Fg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(35042699022)(82310400026)(23010399003)(14060799003)(1800799024)(18002099003)(6133799003)(22082099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e0z82C/uRKOHERq4J9ZSakHVr2Y0QSIE2qxOZODVYpkY4dR37tS8Kehu4KEvbj4chA1JSS9jzPq54Xg/+i1kyg/Tfi4IaJG4+2m97638pwJXHi4607jzwIK04YSCZG+7Bm0g05N6J8AQbtBFuOM51Py6z+jGuGeA6Q7x6LSpbZtmsv6d95rJmkXlgih+OHofcg0SdjdRYbaCayuWFPHhvrFzYnVWjxCCRt9A/ekHPMTBhpW3P8M+4tYw9QgzbgkRo9oCnDw9Mb4rqo25IAyURoEUGrHGdYYaVrG9exVu00ineaxOTsf2TxBJ6jOGn8NsWIRdhmdY2pEyZHYIXt4bUVsgkH+MaH6e9FdZLHiuV74GMeMMWHYfVqpwOhddLlrTImgHLL+DjWd3c+T5o5apfqD7FY/eGmGLoIjgoh6GyruAuOc0YtR3s0Cw6fCArEh0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:58:13.1490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c90f8cd5-ffea-4822-a936-08dee972750c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9519

Add the VGICv5 IST device attribute group used by userspace to save
and restore the IRS Interrupt State Tables.

The attribute uses struct kvm_vgic_v5_ist as a descriptor for the
userspace-owned SPI and LPI IST buffers. Each buffer contains the
architected 32-bit ISTE state for the corresponding interrupt number
space, while the host IST layout remains private to KVM.

Also update the tools copy of the arm64 KVM UAPI header.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 1 +
 include/uapi/linux/kvm.h                | 7 +++++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 710a0d267347d..1b9bbeab18a4e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8e..df6356fb45b08 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1191,6 +1191,13 @@ struct kvm_device_attr {
 	__u64	addr;		/* userspace address of attr data */
 };
=20
+struct kvm_vgic_v5_ist {
+	__u64	spi_ist_addr;
+	__u64	spi_ist_size;
+	__u64	lpi_ist_addr;
+	__u64	lpi_ist_size;
+};
+
 #define  KVM_DEV_VFIO_FILE			1
=20
 #define   KVM_DEV_VFIO_FILE_ADD			1
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 710a0d267347d..1b9bbeab18a4e 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
