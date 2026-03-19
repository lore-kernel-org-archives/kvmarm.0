Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013027.outbound.protection.outlook.com [40.107.162.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92B03ED5A9
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936075; cv=fail; b=oelQZCSO8/WCcqCcL5jgkyV6RTZiVqcK1Yrgu3mGcDxSMFpTzAJF43nmJixHnTPzWT57NQUAmm8Geh1e5MU2K1Z8yVAn6rYYXPDNvbOvO93MRYAez1Kdj976KxElcPA2k9Lzw/rd1T54+lg0oquhguVxPcXs2EAc0LLf19XFM/o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936075; c=relaxed/simple;
	bh=iaZhYbyhFLYXbTMBOlo5R+e2mS//m4RsYZIniWWDfuo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DRK2trjpppvL3Cbt696OeULQfGkOWRHS79aRfh/vOjAbGDvu8oBTCbUo1XEs1kOX8+Vb9QFIsxIaDDsRZ0fwJhjkSNJIW6puhAJiuHO5B9nAL3ehJijZTl95TlsP2Xjzohi8/nP9DZdg0I8Z1AKfUmoqgx/W/fKN/wBlo5jb128=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kTURFA58; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kTURFA58; arc=fail smtp.client-ip=40.107.162.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kTURFA58";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kTURFA58"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IfJCGI86vFEoeN/uSp5qUH0B24m8XXkoAdxX8f0aJg2LVBzwl2+N5PgVym3bvfdj+xtya8cLQ9b39w3I2LsqGpPf/84+pA0feaa/e2AKPsEMWAGhBrREVLUcjYLkpgArl9SlGGCdbrRmgmPT/NwTW8wUWqhkbr+FhXb0y5Rd8ihjpbNN6T3u3i7j3QvFn6x+8M+GPuo+60wAk9qBcSetjD5gD2Fux8flbiyoOtDgCCOJNXF4xAJ6JDfc3UnoGKkW7ByZv87ztUNnDJVuJEmeeADvFYQjo06rdfsljATzl5u6QYN4aFCu9lytKM3Rg33BdCgSRKzqwpg5qbv/dRUkAw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=aTboiDb7T9ncmhHF0nLbGmUr9Uxe7RencT6rDD7bQLFlYr85JaBxMilF86Gl3iSI/Hb0NbzfdJdzXhIR9gSqMQasGS3tBJA5kQ2A5KjFrd7WWfoErU8/bUmQArXeZ4XVleNO6zfixbSYVEeWivXyiItpdF6yGlPUfaHJfd9VZdUTTI1ivVi5QCLplZexi3fSsh3Ohqb2AzYSZRulL1bns19oSKutZzh4N5ZaUl1fF4nbeMgZ5DPxV36F0Nceh076WFeOfSzAQere24ctPoOTxPM/x/1QhbioghZ/NwzzMyDgMNGHEPzS0veHBcBiTErVtGmGfxWMky3fG0WW9eBEIQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=kTURFA58IFD60mzMJBkcA8XCWjjHEiHfvYDDJs+cWYCq3v0C8ew6e9SLzwqblGqcjh+NJIFYTLzFdiVaALinLs8mgV8dwc7BnXksfq0YqmvzxCODtM6yF7JQFi2LktqYmM/G6RWiMay20bzFaQIhPrIpYoAFu/0KP5d4EQVH6G8=
Received: from DU2PR04CA0220.eurprd04.prod.outlook.com (2603:10a6:10:2b1::15)
 by VI1PR08MB10008.eurprd08.prod.outlook.com (2603:10a6:800:1cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 16:01:10 +0000
Received: from DU2PEPF00028D0A.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::ff) by DU2PR04CA0220.outlook.office365.com
 (2603:10a6:10:2b1::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 16:01:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0A.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 16:01:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CGBC0lD0z2F996Ok6WJAMEvl2SCtfxVNvvJbVSM0N+wqoXln4YdTzew2Y/ea7VkC/IEihQ6cXUo+go2RgE3W84kExcF4BlIm74YeB1thi49k1RXRUpP1H6+I6kE7Q7KCgxhZ2rdw1RRkdu1waycpfvB5wqZCf+w8YFtc8Tv0TdjIJBQc1ayBDPmp1wILjpXPtqSVzKTLeaQURJPOuRWi3TBSGEIz+6KqPUzg5Bfk0119Lxwiecdr2lfZ/L5fy5KTbV/A/adbO11iwp/VBVG0K+6lvblA82ct3UFpmiO2xJ3L3/B5HaLGFCxl6zi9Exar+0jNiQO+zBEQDnPoV5eMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=I4YqKk93Vn0JKNp4xEt4SqbvIJcgRKMcMbpvqifIORvaBO3Uk2fzC80fK7lsfj5e1oaNercgzt7a/MFhsq4dDkBsLvRlqlBDwR0xnW7jUfGLFhEX5CnsD8yD0YEQcfFij96vpEzdvPvPbNrKuX7enD4+evx3QpIYVnuccrB6/TaSivzQvfTxEEm5pyLdDzfBWfdsRTgAzTA1Goql1krPTgYXeixcN6xzcFbMYUYMJ2CNkJllFs1RnqT3AOmuSodPJWVHrrUjhPFrv+WYDv0744n/OIeSbhK7w+aezidXzJr18R6nUcsKo3whcJDyrbza/gicZPsLt+vC+WDeLWNjdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ8tm35sTZNb24uGqpMbJdvuSTguUThm373XykTLvlY=;
 b=kTURFA58IFD60mzMJBkcA8XCWjjHEiHfvYDDJs+cWYCq3v0C8ew6e9SLzwqblGqcjh+NJIFYTLzFdiVaALinLs8mgV8dwc7BnXksfq0YqmvzxCODtM6yF7JQFi2LktqYmM/G6RWiMay20bzFaQIhPrIpYoAFu/0KP5d4EQVH6G8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB9414.eurprd08.prod.outlook.com (2603:10a6:20b:596::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Thu, 19 Mar
 2026 16:00:06 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 16:00:06 +0000
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
Subject: [PATCH v7 40/41] KVM: arm64: selftests: Introduce a minimal GICv5 PPI
 selftest
Thread-Topic: [PATCH v7 40/41] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Thread-Index: AQHct7l0Qto5nxK82UClhGz+zNtm3Q==
Date: Thu, 19 Mar 2026 16:00:06 +0000
Message-ID: <20260319154937.3619520-41-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|AS2PR08MB9414:EE_|DU2PEPF00028D0A:EE_|VI1PR08MB10008:EE_
X-MS-Office365-Filtering-Correlation-Id: ea435351-2f93-468b-312b-08de85d0bca2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 P851hn3cHeNn7r/Eucdp8oQQ1cbWgzLzolAXsxGXH2PVzNqLtDBA2iS50XhlJZbrf8CS4QSWhUNkTarfVude0E9mFJIpxWe3/su3/9N/0IrpamOUZRrRdVru9+87YfVzF2JveOR45aNaPK4hvuqd/qlNeVN9dV6C3b/pU9j+fwe40ZTMvFz76oGubpG/OAjdYAuI/+iCEXJFtlmW1xZLmX2Db2DJzMD8i+6bHFgdv7H6PvVsQAng/j75tMNn62JH374oIlTh6p+6frzB3T+vWIfzBG7tuVsEUi+C5f1WbLohHjiTNdHEMVq8HJaJk3db3hSSnVGZat+bp5cBClNUP1zY5ZfROHZhNDa2ymOSwxLpM17Qi009fO1wVQO+s0cWTMlRzFzv0ZVBFYfnZAHm8iUVgiq3GMZ9Oi63VxGK60glgRpmoGv1tp8huJ4Ujppfs7G9ZRhbTajHyULCqqdgC66TDn63yUy5kxbKfVG2Jy8KcC49WfrErN6TPSuX45aIknL/2CE9zyeZAJS70re0bF+uNChdGYpzUFUZsMf7hN4a4QJ2PfoLb/RTEG6xwfyIpU5BnFuWRqD4Pr5M/JH4hva/hkd1OFYbqv/3C/Bw4YcwIKJHi0pqoP+SuBDJuLXPmBwe5oJskpIHv6FBVn3/71xTb25S52BjRCUT2nLKmxp0asyZnAQE14V/e3zdGRJrK16ert41xK8TTc2Pu2/hOdHfqkUtdGy1SF9HWgwHeNs22jOkGlQ24GZxxiSO6gVD9olNrQ1j9Nqmrl6MB6d5OGLTFHlIEG+NBel1e9Ar+LA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AFueeUMu0toUPdsdqvGNVfgaNj0FatoBHSi97OKzDPT8rwGNiHYl1Ks8jRTBwelJBJ5E/6YXyhIkh+7JajNNxJ2jZ4mCxdVup91yt0Xy6h8HW+Yu/WsWg2P0hJD1FWGqK62kHbyb3zdoKnE2XOeYFceQcU0zBL78Ch+KrvY4BaCQNETWRSyPSt+dTp0ta0NgUFwk6Km/3uF6UB3g3UdT8rnyDI3vmZOxo1NPXhSXo6vVlNZEAtLFNRqgisZyAkf2gSwORA77MZPwBNiiwcQn43X/civFB14QXhp1NFMVPJujrtizP2Qc4LaRtCuzTGZsmcb5SQjpwmkp7d0g1mDsLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9414
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0A.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1799ac2a-b7e2-4d7c-f18a-08de85d096d0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|14060799003|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DVRPW2ihhFpTP6ZlV+wCkZWjeMlSYq51cyn7kpB3mEBX/BVEHDRZ/cWqUV4P1HHXkt9gwsaeO1NamXgGPI1DV21HBCLd6d6Ou/60Qrz91r0xOOsUukaTNF4De0PCH7HmfN4ZBcuz2zLRSM+wOlG1y6NEH66xQeo8ufmrynS/8lItta2OOC7SUEz9HF6rOsAQxAIZbTQ5NxlGH9VYeyDmJ1tCH144OgorCD6gKzZPrJmOYgKRQajOPbIsJhHUeu64CeOAztV0q5T3ZPAAxGhgixpM8J0ls7eqgIYhkbScPueb/OK0GxlsQwfX7au60RuJjmIicVAMyCukvVyXbLv/uNvx2epAAkafY4grupNb5MpcyoaoclB5tQ9urTe3VNdUx8x6qzmxmCxEnsdcjl8IiOVwwacq+EvoubqR0GsnLUcw6TqlFb2jW66xpSA6MC8TkHx1MhhfyMWa2CbrNLL2ETBABZ6sEyiXsRQwNwAufeKTWdvHZumCJOiX6blIU3GJ1uXizDxrtFXn0ED+y7eRV+cWgbNGZdrtlzmFFYv1XJ8icBlJrzpAV3/9pzm6mVix1XHvhO6kx1LFdwf1r1gOfkRoguyru+64baPbv2S1pPVpzzWuPATqifhLv8n9/tck54ABh2OkafTDoST6m/gkNULzNPu5af3oT9vXor7YNuMNZwYFanm2Vzc3SvE5kVXkjbCcLXyQyjGM5ptLNjVp3TDwXgkFjMxhN+8t664iJlUFdNoS03TLORVzBXnpVP73N4vsiSYrKghfI5BFxZMX4w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EF5gIdiXZNd8f8qOUoACju3g3U2LzbeGe7e+/qezjJ4zz441F/Oz3ciDUJf5vdsq9tJvWgFpvpcCKXexYmq9/kCJxXBSXqD5DIcHwuKHA8/9ALjTRn6D0uxo8iZ9vWrSBtsICnUPQyZ59T1rGdbi+lKrrgu2fW2GiCDNmCfwECZMK3fq2xhHOEo6Y+ZhBi7aeFyvuaSUeZZOq9WFOuj1qWGnnebN8VvdStQrFCAhTR0JxVWQ0l48OzOpeit2HffElSlyrhebmeS3FSTssojriBUWq4TRQQfFc2VoWw7M9MgEkDzB0iQdsNf5EjxVXWQSryluYI48UNaMH5iC2yz4Wu5tJaOnLtlMbLjrWzaKpNXNUtDfU8XZA+WHv6TYVTk1DwlDTAHQBU0MpAFZj7fOp3tOnEEeWQPLH5zsqzgO2XM7mi6RnvrceB2HYPmdrGA2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:01:09.6539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea435351-2f93-468b-312b-08de85d0bca2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0A.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10008

This basic selftest creates a vgic_v5 device (if supported), and tests
that one of the PPI interrupts works as expected with a basic
single-vCPU guest.

Upon starting, the guest enables interrupts. That means that it is
initialising all PPIs to have reasonable priorities, but marking them
as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
to receive interrupts. The architected SW_PPI (64) is enabled and
KVM_IRQ_LINE ioctl is used to inject the state into the guest.

The guest's interrupt handler has an explicit WFI in order to ensure
that the guest skips WFI when there are pending and enabled PPI
interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 228 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 150 ++++++++++++
 3 files changed, 379 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index dc68371f76a33..98282acd90407 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -177,6 +177,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_init
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 +=3D arm64/idreg-idst
diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
new file mode 100644
index 0000000000000..3ce6cf37a629f
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <sys/syscall.h>
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+
+#include <arm64/gic_v5.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vgic.h"
+
+#define NR_VCPUS		1
+
+struct vm_gic {
+	struct kvm_vm *vm;
+	int gic_fd;
+	uint32_t gic_dev_type;
+};
+
+static uint64_t max_phys_size;
+
+#define GUEST_CMD_IRQ_CDIA	10
+#define GUEST_CMD_IRQ_DIEOI	11
+#define GUEST_CMD_IS_AWAKE	12
+#define GUEST_CMD_IS_READY	13
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (++count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable the SW_PPI (3) */
+	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	while (1);
+}
+
+
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+static void test_vgic_v5_ppis(uint32_t gic_dev_type)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct ucall uc;
+	u64 user_ppis[2];
+	struct vm_gic v;
+	int ret, i;
+
+	v.gic_dev_type =3D gic_dev_type;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
+
+	vm_init_descriptor_tables(v.vm);
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read out the PPIs that user space is allowed to drive. */
+	kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, &user_ppis);
+
+	/* We should always be able to drive the SW_PPI. */
+	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
+		"SW_PPI is not drivable by userspace");
+
+	while (1) {
+		ret =3D run_vcpu(vcpus[0]);
+
+		switch (get_ucall(vcpus[0], &uc)) {
+		case UCALL_SYNC:
+			/*
+			 * The guest is ready for the next level change. Set
+			 * high if ready, and lower if it has been consumed.
+			 */
+			if (uc.args[1] =3D=3D GUEST_CMD_IS_READY ||
+			    uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI) {
+				u64 irq;
+				bool level =3D uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI ? 0 : 1;
+
+				irq =3D FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, 3);
+				irq |=3D KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
+
+				_kvm_irq_line(v.vm, irq, level);
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
+				pr_info("Guest skipping WFI due to pending IRQ\n");
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
+				pr_info("Guest acknowledged IRQ\n");
+			}
+
+			continue;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	TEST_ASSERT(ret =3D=3D 0, "Failed to test GICv5 PPIs");
+
+	vm_gic_destroy(&v);
+}
+
+/*
+ * Returns 0 if it's possible to create GIC device of a given type (V5).
+ */
+int test_kvm_device(uint32_t gic_dev_type)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	int ret;
+
+	v.vm =3D vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+
+	/* try to create a non existing KVM device */
+	ret =3D __kvm_test_create_device(v.vm, 0);
+	TEST_ASSERT(ret && errno =3D=3D ENODEV, "unsupported device");
+
+	/* trial mode */
+	ret =3D __kvm_test_create_device(v.vm, gic_dev_type);
+	if (ret)
+		return ret;
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	ret =3D __kvm_create_device(v.vm, gic_dev_type);
+	TEST_ASSERT(ret < 0 && errno =3D=3D EEXIST, "create GIC device twice");
+
+	vm_gic_destroy(&v);
+
+	return 0;
+}
+
+void run_tests(uint32_t gic_dev_type)
+{
+	pr_info("Test VGICv5 PPIs\n");
+	test_vgic_v5_ppis(gic_dev_type);
+}
+
+int main(int ac, char **av)
+{
+	int ret;
+	int pa_bits;
+
+	test_disable_default_vgic();
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
+
+	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
+		exit(KSFT_SKIP);
+	}
+
+	pr_info("Running VGIC_V5 tests.\n");
+	run_tests(KVM_DEV_TYPE_ARM_VGIC_V5);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
new file mode 100644
index 0000000000000..eb523d9277cf1
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SELFTESTS_GIC_V5_H
+#define __SELFTESTS_GIC_V5_H
+
+#include <asm/barrier.h>
+#include <asm/sysreg.h>
+
+#include <linux/bitfield.h>
+
+#include "processor.h"
+
+/*
+ * Definitions for GICv5 instructions for the Current Domain
+ */
+#define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
+#define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
+#define GICV5_OP_GIC_CDDIS		sys_insn(1, 0, 12, 1, 0)
+#define GICV5_OP_GIC_CDHM		sys_insn(1, 0, 12, 2, 1)
+#define GICV5_OP_GIC_CDEN		sys_insn(1, 0, 12, 1, 1)
+#define GICV5_OP_GIC_CDEOI		sys_insn(1, 0, 12, 1, 7)
+#define GICV5_OP_GIC_CDPEND		sys_insn(1, 0, 12, 1, 4)
+#define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
+#define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
+#define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
+
+/* Definitions for GIC CDAFF */
+#define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_CDAFF_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDAFF_IRM_MASK	BIT_ULL(28)
+#define GICV5_GIC_CDAFF_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDI */
+#define GICV5_GIC_CDDI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDIS */
+#define GICV5_GIC_CDDIS_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDIS_TYPE(r)		FIELD_GET(GICV5_GIC_CDDIS_TYPE_MASK, r)
+#define GICV5_GIC_CDDIS_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GIC_CDDIS_ID(r)		FIELD_GET(GICV5_GIC_CDDIS_ID_MASK, r)
+
+/* Definitions for GIC CDEN */
+#define GICV5_GIC_CDEN_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDEN_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDHM */
+#define GICV5_GIC_CDHM_HM_MASK		BIT_ULL(32)
+#define GICV5_GIC_CDHM_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDHM_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPEND */
+#define GICV5_GIC_CDPEND_PENDING_MASK	BIT_ULL(32)
+#define GICV5_GIC_CDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPRI */
+#define GICV5_GIC_CDPRI_PRIORITY_MASK	GENMASK_ULL(39, 35)
+#define GICV5_GIC_CDPRI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPRI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDRCFG */
+#define GICV5_GIC_CDRCFG_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDRCFG_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GICR CDIA */
+#define GICV5_GICR_CDIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDIA_VALID(r)	FIELD_GET(GICV5_GICR_CDIA_VALID_MASK, r)
+#define GICV5_GICR_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDIA_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GICR_CDIA_INTID		GENMASK_ULL(31, 0)
+
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
+#define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
+#define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
+
+#define __GIC_BARRIER_INSN(op0, op1, CRn, CRm, op2, Rt)			\
+	__emit_inst(0xd5000000					|	\
+		    sys_insn((op0), (op1), (CRn), (CRm), (op2))	|	\
+		    ((Rt) & 0x1f))
+
+#define GSB_SYS_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 0, 31)
+#define GSB_ACK_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 1, 31)
+
+#define gsb_ack()	asm volatile(GSB_ACK_BARRIER_INSN : : : "memory")
+#define gsb_sys()	asm volatile(GSB_SYS_BARRIER_INSN : : : "memory")
+
+#define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
+
+#define GICV5_IRQ_DEFAULT_PRI 0b10000
+
+#define GICV5_ARCH_PPI_SW_PPI		0x3
+
+void gicv5_ppi_priority_init(void)
+{
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR0=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR2=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR3=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR4=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR5=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR6=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR7=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR8=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR9=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
0_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
1_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
2_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
3_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
4_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
5_EL1);
+
+	/*
+	 * Context syncronization required to make sure system register writes
+	 * effects are synchronised.
+	 */
+	isb();
+}
+
+void gicv5_cpu_disable_interrupts(void)
+{
+	u64 cr0;
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+void gicv5_cpu_enable_interrupts(void)
+{
+	u64 cr0, pcr;
+
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);
+
+	gicv5_ppi_priority_init();
+
+	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_DEFAULT_PRI);
+	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+#endif
--=20
2.34.1
