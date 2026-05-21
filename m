Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011034.outbound.protection.outlook.com [52.101.65.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ACA27466A
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779373419; cv=fail; b=naTFwZTWMia+/+ID0OmxXvRNR4OVdqPo7tVoomSrOoJX56jblMsXnd0fZh93zwFJDXkCOXTwiTFEFntDZmFIf7/XUwnuxKzcXH1eD5gQkKz1WzdsQvZXhm18eZManORX99cEJZCfevJF5IknfmAlg8PCYa/4Sg25v5/tsuCGGMY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779373419; c=relaxed/simple;
	bh=Y3m24pw8jraKR2OzIu9WUN0VtDGN1Yqf8ZB1/ad9iuc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D1lTc2+SIt6WBkzs1b4/FWCXVge/IsO7ZvsJuoSDe+0i0P3imRd02vZVP90uSJiGpUfki823PBBTik3qTxWCb/C8Z7KY5d4Gru0EBAeJcIy4hxSNBiFztdKfn+7ROOgfem2QUPisE+mgPvckizMklsTAF3ah6FugHILeE9CweLo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BH2OiLfB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BH2OiLfB; arc=fail smtp.client-ip=52.101.65.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BH2OiLfB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BH2OiLfB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=mALc/v7JnHzHQxD2VkVJap9fQwUw3b6T5wubT6pOTroBE9q3JVgJROUWeSP1LOCPt9yxAnRNpI/rhDnnFQ3O+8ennggIS0rSOiFUzz/Y13Aodc/pfEsaVJ9LM+9DUStMXXifHE/dEv52IgCazyUrS62fEXl2JfslCfagM8VcAMAIbyijukW9MkJxmpx7c5CgZwUr0piI3N2SwhdHKdICVCI8mY3R5rhMb8AdUIDslfFkbh/AdpKipOGuCtTG0SltQyBuJqebQh5uOvlYlXaE0zryTuWKO4l5p/SnPSeG3rT0vcOUPM06unZnAjQnHrozGBD7EdzMzJClivdXNkvqPQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3m24pw8jraKR2OzIu9WUN0VtDGN1Yqf8ZB1/ad9iuc=;
 b=KlPuW2cZI2cxNWPIvzd9s4uAjy1vYd+7VJRX1F7zhGzaXX+SLWhOtmS5s4KNGz/ApGK/Z22QA38NRHL/nQE00cYvGEhXvtxf1QIgc7x6nuMaocKhe8JiBP0hRz5oeAD5eZ6bVGdCD0Dpf4zzsP0GZ316F4ZZd3If0rl0gON+oXF2qGFJXed+ypPDVRzxGIUg4xRp+iw7waUhKK6RK2JDipnqVCpd+Ho2bG92uCLLwdGhsdfEfU3K6MqqNxFaB7HsIOZie+J1Q+F1CrRws3bpV297pBEQIWMm/g/F4n8lUZBJBqwioxQBx0dg8hZjoIJBpHTQuMTZL8rPdfGfKKttEA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3m24pw8jraKR2OzIu9WUN0VtDGN1Yqf8ZB1/ad9iuc=;
 b=BH2OiLfBKbaTE4YPouMTSNvsryRh/AultOq+UolvFukuBBO48TgfQ3GrkE6HFy759JAkgdEZwwCr3XBo9EyZo8fA6HXV+LotcfyS+PqVhkvshYzfDT8lZkb3V5Y/9EVs6j5eEX3RpphbKTg+YnQRirIMV+5o/X5if0N8251YteM=
Received: from DU6P191CA0031.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::10)
 by GV1PR08MB7331.eurprd08.prod.outlook.com (2603:10a6:150:1e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:23:32 +0000
Received: from DB3PEPF0000885A.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::2) by DU6P191CA0031.outlook.office365.com
 (2603:10a6:10:53f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:23:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885A.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:23:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVMjY9HekkES894br5YJDtozbd7sxQZlkboDV1g5DX8iX+Iv7qqpa+AOm0fSihOd3vNX94zqW9OM+sFhh81t7SPQnUbq1vNipTjjHp7ir4Y8dlNYS1oT2psRoJFFKL+zEJxy9S8xrLdrk6KRUbBomtpcslYzjl6R7ztaCR7dp5K1eu4l1zPp1mX2Zk/BLxYPrEYecLcALeEs1Z5pWRItASr7F7t6emLiJOjULFmAdf8m8+Oy5ZRkkpdSISWBDmZy5Cb910Q6AWhtev+9dX8oHtRHtpeukMG9EKdKiEQBXg/v5YCDyde+eBCjayVVemVUo9TygM3nV26VDitkQQp7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3m24pw8jraKR2OzIu9WUN0VtDGN1Yqf8ZB1/ad9iuc=;
 b=Fle3G1xe/KJsmSLi7ymtEZ+8nyNYnN77w4IQZsrr4DCxGyEGewYIhDgdPwxLyxJ/19x/Dd9RM0cMK1JtFdVFI5cJpUTolvlqZlLByBoQ/v56+N7MeW7P+mHrElv5SWNOK/QxNbhE7LOkw6N8rrxhcQ0QqAVQIiQCng+bd+aJiOvbBKIhhYEZIZff9ti5Fl5PrbAD3jd71lI7V56Qsc51yq3CSQhMrkdc6Aylt9a41ZkRtahDwCXtEgt3mWiOGgW/MB8nAq9+fPpYanYoqXFhA5nGoqhkzapst8Wgu5jF1qQfiEf6nboVXT3JmWnh9CEalPGEHvARx15GCWpp++ouuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3m24pw8jraKR2OzIu9WUN0VtDGN1Yqf8ZB1/ad9iuc=;
 b=BH2OiLfBKbaTE4YPouMTSNvsryRh/AultOq+UolvFukuBBO48TgfQ3GrkE6HFy759JAkgdEZwwCr3XBo9EyZo8fA6HXV+LotcfyS+PqVhkvshYzfDT8lZkb3V5Y/9EVs6j5eEX3RpphbKTg+YnQRirIMV+5o/X5if0N8251YteM=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by AMDPR08MB11525.eurprd08.prod.outlook.com (2603:10a6:20b:71a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:22:28 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:22:27 +0000
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
Subject: Re: [PATCH 18/43] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH 18/43] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHc1mCagCdxNLkTJEG77syuWaw5DLYCunGAgBXzTAA=
Date: Thu, 21 May 2026 14:22:27 +0000
Message-ID: <d2843313e23f00844079ccc3f3a6524635b7d2e5.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-19-sascha.bischoff@arm.com>
	 <86pl37xnl8.wl-maz@kernel.org>
In-Reply-To: <86pl37xnl8.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|AMDPR08MB11525:EE_|DB3PEPF0000885A:EE_|GV1PR08MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: 170ae952-013c-41f5-71dd-08deb7448926
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003|5023799004|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 Q7GP/XuB4GcQka8MyZQH7sASDdqPOiOjMNTNyFYANQdYNZ6Ln2p/YgSQ36/EGrgmRN7+rduuC3IPj9apWWMWq9tlQYxVdu6KS7OByLKITclypeLYVzmZw+kPBtqYET6SEJgdMjrI0UhKqxcSmWKlR/lK3Uu1AHtPAvf9Sa4hEqsmsGL48OuD3nP2JnR0KlbXsJBQFToY3MpvNoOX5fnPcr+SC5Z47x0DHrTVeS3eJNhkpXUMEBAz7YrzGWOGWLrw21NmTih70Bl1hM3TxphiUkorGIOZItYmR4QWb8pKNnKlh/m1bmiKtPw4CFiPYhxa7xnAjuk3IBERqjxQ41GT+zMGMD09b/vhOifj03Qnp2WYgVBb2jMUVQLPUmSbF64oDFHYrMs5jKfjfZPDpQMvimlzrsHzz38A+pEGn7TjJFdXLsBkS2OLgFD+C8GZjHrvbHjdN6TyKzh+DbvEgRLzm5iKeUznDbsNVJ6vW4M2isPGGI0ZR6jxJv86EjG/cFLQ2GKTbWVvcAa9iTVAXLLTcOGppAVTnIGbCo5PO3oi5QKpuG589utdLLkCVYm6Cir9PvfvQxN4fhodwpSlRhguHJTgAwUvSjg9RjXh7fo3bFRfgXGakdvQTiBRTjyrXGdG9HaTTOZJZ+P4EAqV8HdnuAdr8Uj/gewihOhzkNN1Oj0gcIFablAGGaDzjyDDbrDRHvZs67PaVsfIG+mVpnT/k/qYrhOUkcqUQ1m4c993SBOb5Z92CXhC7yw4QxYAEn4G
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003)(5023799004)(11063799006)(4143699003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D715ABF5C5EEC4196F63E7A3AB5799E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 a/9Erg3cFiAozrkjOcpWyN0C3b0Exr89YGZSAZCuDoKGAj1HnT9D4B6+HnypPs2sag/620hqUV05OO963BK6FkDbz3IETP8vUtFAwAmZ+NMCfEAE8ohXaRZ02gSdZlsRJN96DexJo+HHFxMSDmybkQooRKDV20TTAy2Vk5xUJeOT48G5oO8KNSeUv+niszslR7vE+YBqd4hK+0zsPys5aODJG0Ycv26ktrfeBARAirVi5uuFhDVlI3BMBOyN1EBqfmZ5LsrWX+LZ/J1M/9UALjnkGV3v67wcA7Jgs69SsFn372Ud1/o9I8tOe3LlAKfq1DAylEe7ijiUvuGx8lH7Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11525
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a5563f84-8a18-47db-f7f8-08deb74462e9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|1800799024|376014|82310400026|35042699022|18002099003|22082099003|56012099003|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	VMdPUZQE0CwQh0wtdt5FMjNUEX2Frfp1vUDRwVlYxdkAw9NJMkacLKEsbB6GNf8mbELqwCtMIsJOACPWJtQqK4bEAJuToin+8pZ+VeFHpEOBKd0hrZbpg1XVnAXEvYxcLkzU5v5UFljCJ8WLnmODn6JU0WqxYXDyElG9Sj5xH5Y8+H3JirgDiYuH19VBvZV/0JCdBNx5PI7P2jQk+dKdYPS+Z/NHfFuMNztNa12JpWLAs3IXQFb0htuB1tSCRP9KMQb0OdNH3iFf6kidrgBlqdTZfhCp8BekCglGXCChuHb94DiBiXjOGsKlgWW6MhPCxHYjizbPCY/0mQzupEJDogVuaV7azMf0RVY0P23cWkq+FBtcT2TjMoWj/AZ56l+hUjap5FqWdayMsTWpsrN6krwa4RlxpOkt4W4bdYLz4HSPzoqWF4fFgPHZuxilFzbRWbkOyAwYouhI/sgqDTSDtqDxJDQMaqXkbr/ErMLY0ArbjNkmwu2VD3p5TLZQ6jSpdqZw5MkMqbE7w24bxbGs2jq7ekUgtCHtR5JB16WxQ7wV8dSRejyu8l1uF31u67hsTafzhQLYcqVKmI1wdlTRyBw0SihqNJmZ4tp83E29TXXlI9JsA17nZtMnjJQRAIzF714ZBB0YiAwJv9W6OWxjcu1LR7aAofpCrvj4NvEDhFq9JXomnV6mv5cN9tJDQDY/0PytpBqNk2BwxXg/B5xNTgfbNx/H4MaMar0g4ui1zgs=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(1800799024)(376014)(82310400026)(35042699022)(18002099003)(22082099003)(56012099003)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H6nSOJnXcpc/iMQL7e1Wmw3CM84QKrMdMnBjEvpRPJqPm17vLXFw8hzD/tyfEh6XVDsHSRBkR8uvIDJajqk3w6uSeIW8pY+pZ+tblWrnIXqJ3uky0ntwspd9xbVLFid/uNSJtiXQAqx5MPQcMwsdbMHhdn+u6X2KLgAlYrKhnkNKf4uFT6VWrZJC4hGxSkHggdQVQ58vEkH2+8MBYYp/GRelfde2yj8OAnBodztncgOMtVYss9qH5b9Zm76FG0BOrOd+v6/OD0sR1ZYAW+Qh9+je7L/C2CvfjJioQO6AG5qy9bb0CBeCCMWLtwHawPVcsw89hFqF9IpvcjG5d0OOrBwf4RvOS9E3/g/psl8y0FK4lIxaVUT/pChuDDdKa4RgNPRGzWQtgLSg1+/BiZHqD+cQJi7Kbx4soZLjdWUOST5X53rBCyt1jUOFXwmEoYiR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:23:31.8819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 170ae952-013c-41f5-71dd-08deb7448926
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7331

T24gVGh1LCAyMDI2LTA1LTA3IGF0IDE2OjEwICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMjcgQXByIDIwMjYgMTc6MTI6MTEgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IENvbXBsZXRlIHRoZSBz
ZXQgb2YgZGVmaW5lZCBJUlMgTU1JTyByZWdpc3RlcnMgaW4gdGhlIEdJQ3Y1IGhlYWRlcg0KPiA+
IGZpbGUuIFVwIHVudGlsIG5vdywgdGhlIHNldCBvZiBkZWZpbmVkIElSUyBNTUlPIHJlZ2lzdGVy
cyBoYXMgYmVlbg0KPiA+IGRyaXZlbiBieSBjb2RlIHJlcXVpcmVtZW50cy4gSG93ZXZlciwgaW4g
b3JkZXIgdG8gcHJvcGVybHkgZW11bGF0ZQ0KPiA+IHRoZQ0KPiA+IElSUyBNTUlPIGludGVyZmFj
ZSBpbiBLVk0sIHRoZSBjb21wbGV0ZSBzZXQgb2YgSVJTIE1NSU8gcmVnaXN0ZXJzDQo+ID4gbmVl
ZHMgdG8gYmUgYWRkZWQuDQo+IA0KPiBJIHJlYWxseSB0aGluayB5b3UgbmVlZCB0byBwaWNrIGEg
cmVnaXN0ZXIgdXBkYXRlICJzdHlsZSIuIEVpdGhlciB5b3UNCj4gYWRkIGFsbCB0aGUgZGVmaW5p
dGlvbnMgaW4gb25lIGdvLCBvciB5b3UgYWRkIHRoZW0gd2l0aCB0aGUgcGF0Y2gNCj4gdGhhdA0K
PiBzdGFydCBtYWtpbmcgdXNlIG9mIGl0Lg0KPiANCj4gTXkgcHJlZmVyZW5jZSBnb2VzIHdpdGgg
dGhlIGZvcm1lci4NCg0KSSd2ZSBnb25lIHdpdGggdGhlIGZvcm1lci4gSW4gbXkgbmV3IHNlcmll
cywgdGhpcyBpcyBvbmUgb2YgdGhlIGZpcnN0DQpjaGFuZ2VzLCBhbmQgSSd2ZSBjb25zb2xpZGF0
ZWQgdGhlIGFkZGl0aW9uIG9mIEdJQ3Y1IHJlZ2lzdGVyDQpkZWZpbml0aW9ucyB0aGVyZS4NCg0K
PiANCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNj
aG9mZkBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+IMKgaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1n
aWMtdjUuaCB8IDEwNQ0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tDQo+ID4gwqAx
IGZpbGUgY2hhbmdlZCwgOTYgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPiANCj4g
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1naWMtdjUuaA0KPiA+IGIv
aW5jbHVkZS9saW51eC9pcnFjaGlwL2FybS1naWMtdjUuaA0KPiA+IGluZGV4IDU0YjU3Mzc4M2Nk
NzUuLjllYTM2NzRhNjYxM2IgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9pcnFjaGlw
L2FybS1naWMtdjUuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvaXJxY2hpcC9hcm0tZ2ljLXY1
LmgNCj4gPiBAQCAtNjIsNiArNjIsMTQgQEANCj4gPiDCoCNkZWZpbmUgR0lDVjVfT1VURVJfU0hB
UkUJCTBiMTANCj4gPiDCoCNkZWZpbmUgR0lDVjVfSU5ORVJfU0hBUkUJCTBiMTENCj4gPiDCoA0K
PiA+ICsjZGVmaW5lIEdJQ1Y1X0FJRFJfQ09NUE9ORU5UX0lSUwkwYjAwDQo+ID4gKyNkZWZpbmUg
R0lDVjVfQUlEUl9DT01QT05FTlRfSVRTCTBiMDENCj4gPiArI2RlZmluZSBHSUNWNV9BSURSX0NP
TVBPTkVOVF9JV0IJMGIxMA0KPiA+ICsNCj4gPiArI2RlZmluZSBHSUNWNV9BSURSX0FSQ0hfTUFK
X1JFVl9WNQkwDQo+ID4gKyNkZWZpbmUgR0lDVjVfQUlEUl9BUkNIX01JTl9SRVZfVjAJMA0KPiA+
ICsjZGVmaW5lIEdJQ1Y1X0lJRFJfSU1QTEVNRU5URVJfQVJNCTB4NDNiDQo+ID4gKw0KPiANCj4g
SSdtIGluIHR3byBtaW5kcyBhYm91dCB0aGlzLiBXZSB1c2VkIHRoZSBzYW1lIGhhY2sgKGFkdmVy
dGlzaW5nIHRoaXMNCj4gYXMgYW4gQVJNIGltcGxlbWVudGF0aW9uKSBmb3IgR0lDdjIvdjMsIGJ1
dCB0aGF0J3MgcmVhbGx5IG5vdCBvbmUuDQo+IA0KPiBBbmQgaW4gYW55IGNhc2UsIHRoZSBBUk0g
ZW5jb2Rpbmcgc2hvdWxkIG5vdCBsZWF2ZSBpbiB0aGlzIGZpbGUgLS0gaXQNCj4gaXMgb25seSB1
c2VkIGZvciB0aGUgS1ZNIGltcGxlbWVudGF0aW9uLCBhbmQgZXZlcnl0aGluZyBlbHNlIHNob3Vs
ZA0KPiBiZQ0KPiBpbXBsZW1lbnRhdGlvbiBhZ25vc3RpYyAodW50aWwgd2UgbmVlZCB0byBpbXBs
ZW1lbnQgYSB3b3JrYXJvdW5kLCBvZg0KPiBjb3Vyc2UuLi4pLg0KDQpUaGlzIHdhcyBhY3R1YWxs
eSBzdGFsZSAtIHRoZSBJUlMgTU1JTyBjb2RlIHVzZWQgS1ZNJ3MgZXhpc3RpbmcNCmRlZmluaXRp
b24sIGFuZCBJJ2QganVzdCBmYWlsZWQgdG8gZHJvcCB0aGlzIGZyb20gdGhlIGhlYWRlci4gQXNp
ZGUNCmZyb20gdGhhdCwgSSd2ZSBsZWZ0IHRoaW5ncyBhcyB0aGV5IGFyZSBmb3IgdGhlIHRpbWUg
YmVpbmcuDQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiAJTS4NCj4g
DQoNCg==
