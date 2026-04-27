Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011004.outbound.protection.outlook.com [52.101.70.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D154D3446C8
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306566; cv=fail; b=ptefFNwZXoO5QmNAFwzvj5TLGl82kgnfhJ2Hu/Z0L4o3dzxJRnxrxevGZykQE18gIlJOmQ+DIVWrh+t2Hbjb92l6cYp7Px1a2jAVnhZTAX6r3rD3eatr580JjLXA3T8ucfOrWAz/xIUtHKetFaUzSXPfzZsfgcvsDjY8EhusQ1s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306566; c=relaxed/simple;
	bh=e87WAgXk+4Mb4G9yEHojsHNgca+RECOehpQ0oLY3UWk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZECO5UMMggkcMNN4mpzbpFNN+8ZKT5ZmalwqyiE882Bh6Yzj271P069Y7Dwqryr7VpaVrFBqyprytx/+q1+/fAwitKeTjFRWiOAB13Ltqm2VchrZAk6qQ2X+Uxmqt0jQ1EsHxxHDp44BWIE7sR3Q69Ys3fbkZG68Knpw4Jr78Zw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HrxEuqP5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HrxEuqP5; arc=fail smtp.client-ip=52.101.70.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HrxEuqP5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HrxEuqP5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LRa8AR7gXUew/4vumhtKwLh327wLgepHA55PsEG5GCdMb5vb1rp5qIGQ/qu0Zsdtltn2h3CKdRGwjWqMMag9RnKCplHzZ/r+5/NL/TVHkGobXkoHb6tsMjip9dm768EygXH1lkCWGOwR6SvXAG3uHMeY/IGVhCWphM7zmL7oUdRo9PulYbwLKWDfdslLnE5kDp1v9o+lwNASVX5TppvlnYCLuhERtC7lm8SwHUsIb7ZGmovUkMkqv8+aemhfB6f7Us2ODpxpJVUbzlJ1edqIAwh5jIbgavMN1sh7Os/dth7VQWWsA0HpdW3RHzkifOTo+/sBMamv3WLjhcq/n24kFA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5w4jVO0AKfJ3GbNEGJBuw5tPt/xpFMG+BCTUDVZqNE=;
 b=EHO+HJ1VdsP3SYfAYBtTMxXNZexMlvisl7B0F9uvOwiYrZJw9576w4NwAQkQx7O1bpAmvhsulhsbaKYwhz0fSv4ztLXzmyTmAwubt3g/jbuWANqu8VOzhh+FyC7NofBwe/yk/O7mZjroD+eAy3noIasjoKz8xKyIA1BYAFtR9yFQUQK7wn8G10KBHPvd6RYNKjp7uKAIOX4SHrTDXgUJg9pi/NBvT4MxgDU8CgKjABUyZYgsu8/kIWaRh6gFdhbc5QLAyYA2ItjxdkYfky1RV7XM1MzN48CqrEKytoqU8Y6t4us/FQtYHyvlkQ8rWsn//ZliBq440ir82qQGEnB96w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5w4jVO0AKfJ3GbNEGJBuw5tPt/xpFMG+BCTUDVZqNE=;
 b=HrxEuqP5NNEMEb3FrBikTDk2d1LFceqcVCEwzSJ8NU47MQNiZeneHtLpw197DzYnxhNCQIaIHtv8LTQGxphQcKr4EN2P+1SznfQP82dkkTY9oKein7foq6N/XOHqIWelUJabkjoiVRh5yIY0ImzxBFw1jP7ny5iHYbiVqD8PZ6U=
Received: from CWLP123CA0217.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19d::21)
 by DU0PR08MB7543.eurprd08.prod.outlook.com (2603:10a6:10:314::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:15:58 +0000
Received: from AMS0EPF000001B0.eurprd05.prod.outlook.com
 (2603:10a6:400:19d:cafe::67) by CWLP123CA0217.outlook.office365.com
 (2603:10a6:400:19d::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:15:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B0.mail.protection.outlook.com (10.167.16.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:15:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1P8P3B8pR+5zn3BnZMA72AM5u0dyGBBFha8LwagbunTTx3hE9Sx1+IOtAZlQyugOR2EAsO573bGhmDpkVrqVaqb17YEpfeFzbnssLnm5ZSkSgNW5aP+zzQBOyssBwnnP4ogtt6sbPF4If0Z8gvQZpVfctOhba+YGwIfW3MxOfzEBK5CMOmUjxoxEAltprtlDwVYtGj8hUDJUF0cVyy46g2dPVaBCqBfH2K1KvXvgyrAYdXVufmpxbE071AgscqHgqPJ065LzrWCh46kVKak8Y/0gVVpdG5xbxbkJlOe5/N4SoGed7h+2bXhz7S4xFiEIK1RH7aet3Bzem+XYumfWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5w4jVO0AKfJ3GbNEGJBuw5tPt/xpFMG+BCTUDVZqNE=;
 b=I8n8rf+RxaAO5Vb/5RYQBN96UW5UaRXPf9u+5VR2pWs95r8azXBo3d8+RJZd35MabAYq0lcBZRRIwJNE82U881iMsmwrEpz92OtPFbHAg1IZ2QwNv9P9Lxhj7QWARw0Wqd19VTqcDeFUZG4zniqDbIgDk2SUFnzy3C1Hs1xg9Uvkd3X6sT/I0+K0YGGPkVgYfye7y6VfDDWmPHuYEMzJYrIugWiXfTLyK9MLTjejmSVNBazkCg7YyqReAtR0Kt3Ulpt/GX4Ele2lr8WQFNI1jHWG54bTbU88tMpN08phT//ILXeYhFAuLTi3DSzeveU4/wwzV3Bluw5ucVHnipehMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5w4jVO0AKfJ3GbNEGJBuw5tPt/xpFMG+BCTUDVZqNE=;
 b=HrxEuqP5NNEMEb3FrBikTDk2d1LFceqcVCEwzSJ8NU47MQNiZeneHtLpw197DzYnxhNCQIaIHtv8LTQGxphQcKr4EN2P+1SznfQP82dkkTY9oKein7foq6N/XOHqIWelUJabkjoiVRh5yIY0ImzxBFw1jP7ny5iHYbiVqD8PZ6U=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:14:55 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:14:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 26/43] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Topic: [PATCH 26/43] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Index: AQHc1mD85fx6OLoq4UalbeRenPXKUw==
Date: Mon, 27 Apr 2026 16:14:55 +0000
Message-ID: <20260427160547.3129448-27-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|AMS0EPF000001B0:EE_|DU0PR08MB7543:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cb06979-4680-4eb3-1bdd-08dea478443f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 ak/RZguhtvIrkwg+zbLcYn8uq+vgysG8v8i+9v9n8XCzO9iZmgxeZ5AeXQnB5IZJhx/9k8eqEnVObr5lnkBo6qeezsO2AzENDbRt6jNxB6pd0URpYu+0n0toU01ROMyw59Rxg9X5zi+3nwZ5h7p9Ro1xvSXTJ9O0pTGJ23t5WK/Y8xe0UhV32jcTIWyXp69mlkoHKXD0PsU3bS9H+1tY8a9iCxgERFc0ea3zlY8QSQLEItyiUTNLU0sAsas3xp4+nma4GxazTPkdnj+8HSrGxJ9MoTv8J52NhCh7I6EnhzvKXB7j6yPrq0xEBDseo7DP9aCAECiKaNs8cRHDec5a3C+hKUSTW2vP4FZpfqs4YqVH/cUqjVS02Rw2TJ9MGklXzfLpx4oINKdXLigUUfBgrBIoH206NGkalKUEzb+Omv3vOGK0PcfabingcQKr+RVSRZqLpAL29wjxGX/UNzuJitbsSb0NvN0Qm+3Poeyxq33E/W4c+SmWl7mwKUHBjFXPjNSgP9kCPcInLAX0VN8j8xSMx/Z98Hbd9Th6oFl6/JkN4z92S8i8cLPsWOFWCnn9RFkJ8ssf2sY09QBju7Rg/8c8U5Ihi7AoQB7x/evRPxC62ZwVkZCaV3bL/I4kIZaMiRflJJU4mrbXeC01Ck4CV3fsSIu2jH/WHx6EiY8kzmpWjG88kn3FrmzETAPf37RyLkldlgXqZvrkCb3nmrQioOmdBuBUTFa6MUKQLCV/O/lteHkoP7urbdJKWLy6X2uxy8qDF7eHzbjPveUG0QwteQG6QWRMe8CZIEk3XTmD4p4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 cV57EflgBN39oLC85qiSQ3YMp8k13rsQNkD5zm7ETwvEYa29y+SnxvTYycxPw+YpBp9W8L4mX8z7n1paPLPUY+7h6a11xeCcoCqUma33SO+fRmNyqyDPw2kJmuBiRTWH4VrF+WGRBDWuIBstjppcL/tEnABiVyHlA9x+ybG18EAloFbbh5/L9oRWwdOmqLmrnJ67efwufjkU3du2x11NC4fSOk++n4JnrB6EjLpicRrqoimclm9yTEoJsMHvlyv5PZE79vi5PyEll9F78u1Hf0wfu6bCpVZk8+n+K27eV2IHuxQSkYQ7cCBp0Ns/KP1+sNNJnqfp4sPDbXKo9aKFpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B0.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	632592d4-58e2-4aa1-14b4-08dea4781ec5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|14060799003|1800799024|35042699022|82310400026|376014|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	yBYVNQ53i0XJ9sEZ9u1hUb95LqQ2lKR0dhlTXnl4y5qyydIezV+QuWhKJbevMk9aSAeha9mQFjlQY/Z/lfsea2prBdFW12AQhkeZKRDCSBovcSw0000g59RRBRKkkfbDvqOnnPloTrJqNskD3+vhg4y1N13C1Zx8iKyrQ7V3oMM7cKIItNQzfhviypR3uNxZayuxNf+rgJ9Y8ebCs70QrYFHPp4+huRedw7gqLluKRdgmK8+gHSX37/DctmhOWWw34aso0u+kgeEycaeyKqVWQQm/H8EY+uOjaj9+jMUuw2/LhRjeigxzaSDXzZ/6CwbZhFlpcD5Dr4R8oQrcU5K6EWzfFv/5q1zVi9WdJCf02orcoboRRGu7NXgf0Y+BScdMTIIyGT83JLFhnCyu4ulBX4hUgGFhPbeyM22xjsTbK9u5jVBu9WLjF71znU/6eDBQ/+uV6dNrg7sf8f5xmDcPBrrZNQAPgSbjVghDmjSRWqovALxJwn2G9/CWEJCdcJf2x5kNtxaqE7Ql0O6xE/6tZy1uzEOYqnFk1yJXoQF+d+b9NvuQ4MnJbte9RujjUmCzbN2qG7S5rsXYIbYG68HMWG+3e2ExI/2s3ezIVNTPnWbkKIRxi6j32lrosUK9SzADputCjHmIYmAf29oTQR7WkZ3Sz72Zgr3Z98+PGDF06i2toQwgJ4yfxSMrDUmPXcb2e8oQ+eTBu2jrm/2brjzh1l+4NlLwjEiEZMP0FmzvjiXU7yyIlVaXtWd/wvmrbReuDsiroOq6w3n17Uj65Se2g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(30052699003)(14060799003)(1800799024)(35042699022)(82310400026)(376014)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h1LBag1XYG2WSHjMjKy3t4C2qxqHfaTyNmNRTLOGbVSSPzH/BsEdujDJLlrgjOybWhElIRjlPq97lo2x7KaszoH0aqgfBRDjq3mY7V1UhQPUmc7eVDzUNrVGBs0I1COvAhvm1OIhaGVVx9LQ160jY8kB8MONTK3AJNYtDTvUOvgTFdDdZT2CU5b8q/ns0HMNSkR0k+LmNtFFRhaOmFSLLTnt9vqajtTssYJVv836rYxkdUgrK/dXt2C+97wgHkUMpYlsH2GmTPcT15eqoEDqjTRjyt82zKpozHggcRZM0XX01OkZcWEEac50vGmEjcaTo4TGG/rRcZhVvY8onE2M+7gVaFXkAj5uhXUQiTIclHozpAG0U7lrZ1bdSy1BZXQZ0qHkv2tJxm0HDt7q3iZgENeMLrO4YpoJu6qEfLE4NrQrRTWI/v7lvK3SdMdAXUAU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:15:58.0298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb06979-4680-4eb3-1bdd-08dea478443f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B0.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7543

Now that it is possible and required to set the address of the GICv5
IRS in GPA space, update the documentation accordingly. This region
must be 64KByte-aligned, and covers a total range of 128KBytes.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 1985b2d880322..2417eba01830c 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -12,12 +12,28 @@ Only one VGIC instance may be instantiated through this=
 API.  The created VGIC
 will act as the VM interrupt controller, requiring emulated user-space dev=
ices
 to inject interrupts to the VGIC instead of directly to CPUs.
=20
-Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 d=
evice
-only supports PPI interrupts.  These can either be injected from emulated
-in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
-ioctl.
+Creating a guest GICv5 device requires a GICv5 host.  The VGICv5 device su=
pports
+PPI, SPI, and LPI interrupts.  The PPI and SPI interrupts can either be in=
jected
+from emulated in-kernel devices (such as the Arch Timer, or PMU), or via t=
he
+KVM_IRQ_LINE ioctl.  LPIs are not externally injected, but are handled in
+hardware via the LPI IST.  Their pending state is driven directly by the g=
uest.
=20
 Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+   Attributes:
+
+    KVM_VGIC_V5_ADDR_TYPE_IRS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv5 IRS
+      (Interrupt Routing Service) register mappings. Only valid for
+      KVM_DEV_TYPE_ARM_VGIC_V5.  This address needs to be 64K aligned and =
the
+      region covers 128 KByte - the IRS has a CONFIG_FRAME and a SETLPI_FR=
AME,
+      each of which is 64kByte in sized.
+
+      Setting the address of the IRS in GPA space is mandatory for initial=
ising
+      a virtual GICv5 as the IRs is responsible for handling SPIs and
+      LPIs. Failure to set the IRS address prior to initialising the GIC r=
esults
+      in an error.
+
   KVM_DEV_ARM_VGIC_GRP_CTRL
    Attributes:
=20
--=20
2.34.1
