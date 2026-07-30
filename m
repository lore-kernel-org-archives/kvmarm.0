Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013030.outbound.protection.outlook.com [40.107.159.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3193859EF
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427667; cv=fail; b=e4RxMnuZ1ACx9XugJYHUFuxFtNTQsWPI6MBEOWD9K99bbTeXfF34lixgrPEPJGyAVKNAEUMZpqVr/dxXJmoaGbEhYSA9ipwGPj9IyCZskiNM2M37dHKM4UTuYBxdenrYhwbK5GEzKT8z9ONmpd3iHknyR6WwyckkQnQKMDbD+4Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427667; c=relaxed/simple;
	bh=G8QafRVAMLM30fZ4qgWMfkOHFVxwozlj6YXJEPKO8TE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rvulLjmCTh3MBipS8g76PCx5yYD0xpc04Q5XS0YGaN+k5RnVqt7IsoVQLk5IeDmvFLLJ//uLtvMjNkEsHipzUpkosZqQwMqBUnZSHl8I0sbpG6jjPf2QD5AhALJrAG6pJW//Et3X4qvBaUTQPi9c1Vy9c7IGUPkMYApOn3sD2tk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=II/5HNiX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=II/5HNiX; arc=fail smtp.client-ip=40.107.159.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="II/5HNiX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="II/5HNiX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KgnsE4rD8rkADiGJNaQjjZvur0ZRTMC5UsxGj5QiXV445CWla5bOqheNGmw9EOSXBrbl9Hm1Xbq7uljMey9cPhday2j33HrzfZyCLBy5hOTdJ9bncF1V3gDVowNjUbyT1UCt67n5msbPsykyaet8/ge9PK3iSXL3917BSI0ABt/R+qrerRm6HMBnsJA8hyTje8VoF3XOqdONCmvUUATTmzyFcoS5r8OO29Ef2pZPu9AdM7HCNbhKP7Aj8WhHrSFVRf0TqskmGrN+pP98xDXJDrqW8WJb8q6EPUsSnxCQP7Zcrt0Wik1r7jJ/99mXuUNkgalhxQmjxCZ/BL408d7IBg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8QafRVAMLM30fZ4qgWMfkOHFVxwozlj6YXJEPKO8TE=;
 b=lJxnNvPiH3J9wGYP1JNlkgxIJE6NoIH8pmc7p2tY3teOmx6jAKhdG/dn2/rqiYD/EHCu25/dspUFvggOzHFu1OQY+5BR33H3LccXAg0dQp01udKVpYROh79d5slpaoWY/beAgD6R/opEtKj9Nq/hxEIRjXWxdZevjnvijMa7POInvU96n3HYDUw+pyQ0lLkBT0saPCoiL9px0lq5VV6POdiu8QDNNiw05Q+Fb9blPoiIOCgdOhrEt9qexX91vx+tOKsIlJ+MezUSJFbjQRpcs/Aj3O4OCw7OBPEFh4Jl+bawAaLsjoCEl0nokZmNvgXwcJzvnL/9nKRycO5vuf5ckQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8QafRVAMLM30fZ4qgWMfkOHFVxwozlj6YXJEPKO8TE=;
 b=II/5HNiXStZTAD4RA02ioPemGdFmaq/OmaLUopBlf1sUsoZk1kH3o95qLMTfNx1nyxrGoiM09++fAUSoGWf7Lay5zIql+6VkZjg3gmCa+FeQ9mhSkbhWp6T5N/xtU6YNKjHDbzK2vStS2F/eT1IZBM4Rj/oRypo4StK6Mq/UPro=
Received: from DU6P191CA0052.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::12)
 by GV2PR08MB9231.eurprd08.prod.outlook.com (2603:10a6:150:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Thu, 30 Jul
 2026 16:07:35 +0000
Received: from DB3PEPF0000885F.eurprd02.prod.outlook.com
 (2603:10a6:10:53e:cafe::a9) by DU6P191CA0052.outlook.office365.com
 (2603:10a6:10:53e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 16:07:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885F.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Thu, 30 Jul 2026 16:07:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5FlNfcC3r7Y9tMvd74AQjcQDEtLVSchKh9nhY8gFyW+rPW1VESDg7J6I2BL8YdvxTptC4JgDiQ1u4AKhbOW1WZQ6wgKYIOy+EiOnSX8Q2sbeAUT8jxE8zJPtAHCQY542peVLEzpEAlU0YQ5l/W9SWpy5OxJ8W5B1IZnpS+kufj1w7JQ8hjLMnPPxVYMFowwWFcDeLaFPlET9vjKXw0A+YSnvJGvbL7ylZ7q9bRjn5XKniULKh7nI0rA9sTC4IX2uMW+jiH0Ovp7PdI+ylvKLIxedU2Nvrcta+6vKyNj1J0VT0jSUj1+FjN5DAXR9YHcajgSvSKJfl0xIwYekUtVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8QafRVAMLM30fZ4qgWMfkOHFVxwozlj6YXJEPKO8TE=;
 b=k+m+toZnRVIjaeX4IesLXopRrW2tU8yp7u05SNQcVe+tRwaCPwKquABrLsN92ckooiA3ucu/5RN7V6kBgZVQXLJQJKpVdWNpobNluc/WRbw06nxJKrUUHMsWFCn2fVtk1gKgb7HfYey7Jo+WYSDfu8YeK8ZhHqo0VG2vxywdM9el5xLKr1o2wvJKDkxlRtrtzMDEUCylUfCrN7ZR9gfuJlZHASfSbCJH3Mr7XfIMfgjbwhVz+ZIpD8hS8N8O734cdbWrc5ZwdFe+r2KGBq522kGZ7LgLNaNJ2wEliSCXHYec46vTIb9N+hqISkRA4rQm8jrvESmqtZ42KlIrpoqvqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8QafRVAMLM30fZ4qgWMfkOHFVxwozlj6YXJEPKO8TE=;
 b=II/5HNiXStZTAD4RA02ioPemGdFmaq/OmaLUopBlf1sUsoZk1kH3o95qLMTfNx1nyxrGoiM09++fAUSoGWf7Lay5zIql+6VkZjg3gmCa+FeQ9mhSkbhWp6T5N/xtU6YNKjHDbzK2vStS2F/eT1IZBM4Rj/oRypo4StK6Mq/UPro=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GVXPR08MB10861.eurprd08.prod.outlook.com (2603:10a6:150:154::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 16:06:31 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 16:06:30 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v4 20/48] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Topic: [PATCH v4 20/48] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Thread-Index: AQHdG1qr81fnqAQPDUuFIBDOFj3KQLaBtosAgASNgQA=
Date: Thu, 30 Jul 2026 16:06:29 +0000
Message-ID: <5e61a041a45e84a3894d467045dc8741dda2a9c5.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-21-sascha.bischoff@arm.com>
	 <CA+EHjTxtSGHO__O6V+Km+3f5ASJepA=5cVHs8BdjJoLbRwbLpg@mail.gmail.com>
In-Reply-To:
 <CA+EHjTxtSGHO__O6V+Km+3f5ASJepA=5cVHs8BdjJoLbRwbLpg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GVXPR08MB10861:EE_|DB3PEPF0000885F:EE_|GV2PR08MB9231:EE_
X-MS-Office365-Filtering-Correlation-Id: 667f2e0f-0056-489b-36e0-08deee54ab22
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|38070700021|56012099006|4143699003|11063799006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 2QdAb0vuuFszqUn/mjKYWpGmIfu0BNk+X4HcWO4fJnUHEpUKF3YGech3FHeCn6h/xo2Zse6c00WTbekwnAflcqi3+pmFTv98lCu9wmuxGx0TnwwNgSy+E6JJeDC/YHS4ATwLdZ2NWGu4pRiz8MRBGaZ9z09ab4164tu53xssgzHP0jhiyVtbgxgHzWth5dNrXyz5ur5rJ0UlJ/0nvT2qN1XksdOZbKUL8iZf5U233Lbst5TRuHXxlI8O3+T0PM2KydxnNmFE+pcEyDMTHj3vMtve72ip1MV6Ds2ZF+J1SYmYV+jW7Mr/SKzQjSCVEScpFTYDb7EiBQI0CUmr9BujHDq1WMLmLQW6wkueF2rtFthEgVY8f7YxnHUypZsikA1pCgA9x7t34M+59u/2yRe3YhpLvmvhGbyTJn99jeUu2F+IuHcMnMPTAnAcq0MLqK7hWqYCdqArUvZQbR0LBQ6hYjUb/bIkMXEf9GaWGNyE4TGg1boCYzYiTfGAuQCmFA7CkgmKYMfisM4buk1VpWEjAUpIKxNX+mlu35JEFcydeiJPOTO4ufZy9s5yJURJ5+bq3pnja4lV+ujliEEfVXegkOX3TduM7hl8rEe8qo/LI4GWWk7KQcrMsVGUdP1VEfVF/Z/79WUG6wZE5Fxfq2uSP7+BltZ9p0d9b8NfW/l3oHdKgpg2a/gtF5QSvw6dUlvIPB2eBt+nPwIg0xIrM9ZVVfbH9L4f7Xl4sM9QB0bTxUs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(38070700021)(56012099006)(4143699003)(11063799006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E2B4623A75E384ABAD272125A5441E8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 moV4jS9T7ijHCwS/uEN6QFzEK/kT9Hhv6Fzme7bodYjP+9dbkOKVZ5Z5WSYwCJM2bMt3iJsVFdN2zb3J6AKu9TxvZrBJ1TcAkHXR1+fnN+xfha/yQiGZPP+73NQQiQdtL3C+39+c/rK0DjZTsTXw9XhYgR61iVK14U7+37YFbjkhrlSjC1e9wVmLPkxtVj1IwFwXn0NP7K8UepYh4Y4KiMUZ2dNrnzMjHXtUgEUsWu3PlNM8WbelTUMnb+RiwahDSz1YbLH1eMCQgzsoc2x9Zau+3lBnx4dKdHqDd0ma+OdEwawPxWUFgXLyaYDxuZ0iSbnMnav4Ksi8cg1vtwXH/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10861
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bd3854b2-fb11-4dbc-2acd-08deee548498
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|35042699022|1800799024|376014|23010399003|14060799003|13003099007|10067099003|18002099003|11063799006|22082099003|56012099006|4143699003|3023799007;
X-Microsoft-Antispam-Message-Info:
	vY3J8jiLkLiMX5kDhFR6MzH+AJQwqET80MgDSFWbVjEiEYiB9S0Djt6brK//9QXwuUnvmXKrqkGlgXHnZq9nz2mmDjYE8zoqAanACQlBQ4KTeJ2AndH8+r/Y8kJjAPIBqrXRjLBwfcIn6xhAERjuxF/cvQmms6ohdIlup0GKcWgx52nSiksSWDUp+LhrdYxQomfuS5J58m++Lo3UHBCWbO8Ic9WbGiVeU0ukk5MJDXPjRBI7ru3VTPGR3soYWZf6B+r/BZBaPB1LATfQ0+VRa0OgOyWi3lyn3wB9cSvkuxlRnvZ/FejEyNrJePkM3n6rSbK7D2fN/+V78na7U9GlbWhJf7q47t16pPtCiteFRk6/qDfYkyWsLUq/hSEd/Y+shtXjYIbp8jNvgMdGj+P7QTuWs6xSx1a2Q8h0PrK+1eqNwftJFHNbPRtntIEupDoe0U8f8zJe1wKBq6cMC+AmnNg1CrKIlJS2OT2LTyUMwqO7BJwiTkO3l3TyRCURgay3yd+RoTrzyWPsOXY1Jp+HoR6fM/YJf9qr2uxUZmq3iEtt959gjMiV4wQD1bkG+A5W5kjakagJU1fNgtNKE3GTSKb//z5GCOec6Naj6P7BoUeNsM7ts9ctI0p3euo6VcM6TExCQKgukFrpEAWPeCkDiwrFBa+7B/s0ik2eOkPMWmWNQCqg80tJdWuIPX77MgYZT53sRathuqk4/clKTydEkQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(35042699022)(1800799024)(376014)(23010399003)(14060799003)(13003099007)(10067099003)(18002099003)(11063799006)(22082099003)(56012099006)(4143699003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JNrrMeYzga1FCXMRrGBsT9V7qa0p5L+wLrWlxXZW4hxmnJrKo/VHpBe2AUk+FJS2kt5cxsbg5bm4F0y8a1sNFwxCvw5CWSmSYSuHOqZ/1U99NQCj5QPXkzuUBmJAiqs4r4mzqhuYRVgWCj07+tfRfbUbrkQU4nOLlKXjVvlYQc8FmdQkRXcJx5v+NeoL3p7GLaZMm2QHyyr44KMYeeibvF5fwGaBGU5z31/azM3cdueBFlNILOajFFnrH/CLCEeLkWmUHbp0m9ITRhwFqIlvG5ObNTNOHsVw43mDuFut9nGo4KO62x6EH/ttzyUsY54IYKfTVzPhwjxejfNAs4NGgX9WNn1+57HglrN2yhNkkHcg/cRIHPAf/CnKRxwLiS/Uv/T+aVRllY/z/K84vXV7m22bXKqNiQGwwVnO7XuXEVoLNbRh755TqSH5wBUfM/a0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 16:07:34.7907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 667f2e0f-0056-489b-36e0-08deee54ab22
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9231

SGkgRnVhZCwNCg0KT24gTW9uLCAyMDI2LTA3LTI3IGF0IDE5OjM0ICswMTAwLCBGdWFkIFRhYmJh
IHdyb3RlOg0KPiBIaSBTYXNjaGEsDQo+IA0KPiBPbiBGcmksIDI0IEp1bCAyMDI2IGF0IDExOjU0
LCBTYXNjaGEgQmlzY2hvZmYNCj4gPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPiB3cm90ZToNCj4g
Li4uDQo+IA0KPiA+ICvCoMKgwqDCoMKgwqAgY2FzZSBHSUNWNV9JUlNfSURSMToNCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2YWx1ZSA9IEZJRUxEX1BSRVAoR0lDVjVfSVJTX0lE
UjFfUEVfQ05ULA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXRvbWljX3JlYWQoJnZjcHUtPmt2bS0NCj4gPiA+
b25saW5lX3ZjcHVzKSk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyoNCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogSVJTX0lEUjEgZW5jb2RlcyBJQUZG
SURfQklUUyBhcyBOIC0gMS4NCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICov
DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdnBlX2lkX2JpdHMgPSB2Z2ljX3Y1
X3ZtdGVfdnBlX2lkX2JpdHModmNwdSk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdmFsdWUgfD0gRklFTERfUFJFUChHSUNWNV9JUlNfSURSMV9JQUZGSURfQklUUywNCj4gPiB2
cGVfaWRfYml0cyAtIDEpOw0KPiANCj4gSSB0aGluayB0aGUgYWR2ZXJ0aXNlZCBJQUZGSUQgd2lk
dGggbWlnaHQgbm90IGNvdmVyIHRoZSBJQUZGSURzIEtWTQ0KPiBoYW5kcyBvdXQuDQo+IA0KPiB2
Z2ljX3Y1X3ZtdGVfdnBlX2lkX2JpdHMoKSBzaXplcyB0aGUgVlBFIElEIHNwYWNlIGZyb20gdGhl
IHZDUFUNCj4gY291bnQsDQo+IGJ1dCB0aGUgSUFGRklEIGEgZ3Vlc3QgcmVhZHMgZnJvbSBJQ0Nf
SUFGRklEUl9FTDEgaXMgdmNwdV9pZCwgd2hpY2gNCj4gdXNlcnNwYWNlIHBpY2tzLiBUd28gdkNQ
VXMgY3JlYXRlZCB3aXRoIElEcyAwIGFuZCAzMDAgZ2l2ZSBhbg0KPiBJQUZGSURfQklUUyBvZiBv
bmUgaW1wbGVtZW50ZWQgYml0LCB3aXRoIHRoZSBzZWNvbmQgdkNQVSByZXBvcnRpbmcNCj4gMzAw
LiBJIGNvdWxkIG5vdCBmaW5kIGFueXRoaW5nIGluIHRoZSBzcGVjIHJlcXVpcmluZyB0aGUgcmVw
b3J0ZWQNCj4gSUFGRklEIHRvIGZpdCB0aGUgYWR2ZXJ0aXNlZCB3aWR0aCwgYnV0IHRvIGJlIHN1
ZmZpY2llbnQgdG8gaWRlbnRpZnkNCj4gZXZlcnkgUEUgaW4gdGhlIHN5c3RlbSBpZiBteSByZWFk
IGlzIGNvcnJlY3QuDQoNCkJyb2FkbHksIEkgdGhpbmsgdGhhdCB0aGUgcnVsZXMgeW91J3JlIGVm
ZmVjdGl2ZWx5IGxvb2tpbmcgZm9yIGluIHRoZQ0KQS5hIHNwZWMgWzFdIGFyZSBSX0pLWUdOIGFu
ZCBTX1dWWUxDOg0KDQpSX0pLWUdODQogICBXaGVuIHRoZSBBZmZpbml0eSBvZiBhbiBpbnRlcnJ1
cHQgaXMgY29uZmlndXJlZCBieSB0aGUgR0lDIDxkb21haW4+QUZGLA0KICAgPFh0PiBpbnN0cnVj
dGlvbiBhbmQgdGhlIElSTSBmaWVsZCBjb25maWd1cmVzIHRoZSBpbnRlcnJ1cHQgdG8gYmUNCiAg
IFRhcmdldGVkLCBhbGwgb2YgdGhlIGZvbGxvd2luZyBhcmUgdHJ1ZToNCiAgICAgICogRm9yIGEg
UGh5c2ljYWwgSW50ZXJydXB0IERvbWFpbiwgdGhlIElBRkZJRCBmaWVsZCBzcGVjaWZpZXMgdGhl
IFBFDQogICAgICB3aXRoIHRoZSBjb3JyZXNwb25kaW5nIGludGVycnVwdCBBZmZpbml0eSBJRC4N
CiAgICAgICogRm9yIHRoZSBWaXJ0dWFsIEludGVycnVwdCBEb21haW4sIHRoZSBJQUZGSUQgZmll
bGQgc3BlY2lmaWVzIHRoZSBWUEUNCiAgICAgIGluIHRoZSBWTSB1c2luZyB0aGUgY29ycmVzcG9u
ZGluZyBWUEUgSUQuDQoNClNfV1ZZTEMNCiAgIEFybSBleHBlY3RzIHRoYXQgSHlwZXJ2aXNvciBz
b2Z0d2FyZSBlbXVsYXRlcyBhIHZpcnR1YWwgR0lDdjUNCiAgIGltcGxlbWVudGF0aW9uIHdoZXJl
IHRoZSBlbXVsYXRlZCBJQ0NfSUFGRklEUl9FTDEuSUFGRklEIHZhbHVlIGlzIHRoZQ0KICAgVlBF
IElEIG9mIHRoZSBjb3JyZXNwb25kaW5nIFZQRS4gVGhpcyBtZWFucyB0aGF0IHRvIHNvZnR3YXJl
IHJ1bm5pbmcgaW4NCiAgIGEgVk0sIGNvbmZpZ3VyaW5nIHRoZSBBZmZpbml0eSBvZiBhIHZpcnR1
YWwgaW50ZXJydXB0IHVzaW5nIHRoZQ0KICAgdmlydHVhbGl6ZWQgSUNDX0lBRkZJRFJfRUwxLklB
RkZJRCB2YWx1ZSB3aWxsIGhhdmUgdGhlIGRlc2lyZWQgZWZmZWN0Lg0KDQpUaGVyZSBhcmUgc29t
ZSB1cGNvbWluZyBzcGVjIGNsYXJpZmljYXRpb25zIGhlcmUgd2hpY2ggZXhwbGljaXRseSBzdGF0
ZQ0KdGhhdCB0aGUgVlBFX0lEX0JJVFMgZmllbGQgaW4gdGhlIFZNVEUgaXMgdXNlZCBhcyB0aGUg
bGltaXQgZm9yIHZpcnR1YWwNCklBRkZJRCBiaXRzLiBIZW5jZSwgd2UgbmVlZCB0byBjb252ZXkg
dGhlIHNhbWUgbGltaXQgaGVyZSB0byBtYWtlIGl0DQpjbGVhciB0byB0aGUgZ3Vlc3QgdGhhdCB1
cHBlciBiaXRzIG1pZ2h0IGJlIGlnbm9yZWQgb3IgdGhhdCB0aGUgSUFGRklEDQptaWdodCBiZSB0
cmVhdGVkIGFzIGludmFsaWQgaWYgdGhvc2UgYXJlIG5vbi16ZXJvLg0KDQpDb21pbmcgdG8gdGhl
IGlzc3VlIHlvdSd2ZSBtZW50aW9uZWQ7IHlvdSBhcmUgcmlnaHQuIFRoZSBlbGVwaGFudCBpbg0K
dGhlIHJvb20gaXMgdGhhdCBJJ3ZlIGJlZW4gdXNpbmcgdmNwdV9pZHggdG8gaW5kZXggaW50byB0
aGUgVlBFVC4gVGhhdCwNCmFsYXMsIGFzc3VtZXMgdGhhdCB1c2Vyc3BhY2UgaXMgbmljZSBhbmQg
YWxsb2NhdGVzIGNvbnRpZ3VvdXMsDQppbmNyZW1lbnRhbCBJRHMgd2hpY2gganVzdCBzbyBoYXBw
ZW4gbWF0Y2ggS1ZNJ3MgaW50ZXJuYWwsIG5vbi1zcGFyc2UNCnJlcHJlc2VudGF0aW9uIGluIHZj
cHVfaWR4LiBOb3Qgb25seSB3YXMgdGhpcyBhIHJlYWxseSBiYWQgYXNzdW1wdGlvbg0Kb24gbXkg
cGFydCwgYnV0IGl0IHdvdWxkIGFsc28gaGF2ZSBtZWFudCB0aGF0IHRoZSBJQUZGSUQgdXNlZCBi
eSB0aGUNCmd1ZXN0IGRpZG4ndCBhbHdheXMgbWF0Y2ggdGhlIElELg0KDQpJJ3ZlIHJld29ya2Vk
IHRoZSBjb2RlIHRvIGRvIHRoZSBmb2xsb3dpbmc6DQoNCjEuIEFsd2F5cyB1c2UgdmNwdS0+dmNw
dV9pZCBhcyB0aGUgR0lDdjUgVlBFIElELiBUaGlzIG1lYW5zIHRoYXQgdGhlDQp1c2Vyc3BhY2Ut
cGlja2VkIElEIGlzIHVzZWQgdG8gaW5kZXggaW50byB0aGUgdGFibGUuIFRoaXMgdGhlbiBhbHNv
DQptZWFucyB0aGF0IHRoZSBJQUZGSUQgdXNlZCBieSB0aGUgZ3Vlc3QgbWF0Y2hlcyB3aGF0IHVz
ZXJzcGFjZSBoYXMNCmNob3Nlbi4gQXMgYW4gYXNpZGUsIHRoZSBlbXVsYXRpb24gb2YgZ3Vlc3Qg
YWNjZXNzZXMgdG8gSUNDX0lBRkZJRFJfRUwxDQp3YXMgYWxyZWFkeSByZXR1cm5pbmcgdmNwdV9p
ZCBhbmQgbm90IHZjcHVfaWR4LiBBIGZvcm1lciBidWc7IG5vdyBhDQpjb252ZW5pZW50IGZlYXR1
cmUuDQoNCjIuIFVwZGF0ZWQgdGhlIFZQRVQgc2l6aW5nIGNvZGUgdG8gYWxsb3cgZm9yIGEgc3Bh
cnNlIHNldCBvZiBWUEUgSURzLg0KV2Ugbm93IGl0ZXJhdGUgb3ZlciBhbGwgdkNQVXMgb24gdkdJ
Q3Y1IGluaXQsIGZpbmQgdGhlIG1heCBJRCwgYW5kIHVzZQ0KdGhpcyAocm91bmRlZCB1cCB0byB0
aGUgbmV4dCBwb3dlciBvZiAyKSBmb3IgVlBFVCBzaXppbmcuIFVudXNlZA0KaW5kZXhlcyB3aXRo
aW4gdGhpcyB0YWJsZSByZW1haW4gaW52YWxpZCwgZG9uJ3QgZ2V0IGEgVlBFIERlc2NyaXB0b3Is
DQphbmQgY2Fubm90IGJlIG1hZGUgcmVzaWRlbnQuIFRoZSBvbmx5IHZhbGlkIFZQRXMgaW4gdGhl
IFZQRVQgYXJlIHRob3NlDQppbmRleGVkIGJ5IHZjcHUtPnZjcHVfaWQuDQoNClllcywgdGhpcyB3
YXN0ZXMgc29tZSBtZW1vcnksIGJ1dCBpZiB1c2Vyc3BhY2Ugd2FudHMgdG8gcGljayBJRHMNCnBv
b3JseSwgdGhlcmUncyBsaXR0bGUgd2UgY2FuIGRvIGhlcmUuIEluIHRoZSB3b3JzdCBjYXNlLCB3
aGVyZSB3ZSBoYXZlDQpvbmUgVlBFIHdpdGggSUQgMjU2LTUxMSAod2UgY2FwIHRvIGF0IG1vc3Qg
NTEyIFZQRXMgcGVyIEdJQ3Y1IFZNIGluDQpLVk0pLCB3ZSdkIGNvbnN1bWUgNEtCIGZvciB0aGUg
VlBFVCBvZiB3aGljaCB3ZSB1c2UgOCBieXRlcyAoaS5lLiwgb25lDQplbnRyeSkuDQoNCjMuIEFk
ZGVkIGluIGNvZGUgdG8gcmVqZWN0IHZHSUN2NSBjcmVhdGlvbiBpZiB0aGVyZSBhcmUgYWxyZWFk
eSB2Q1BVcw0KcHJlc2VudCBhbmQgdGhleSBoYXZlIElEcyB0aGF0IGNhbm5vdCBiZSByZXByZXNl
bnRlZC4NCg0KNC4gQWRkZWQgaW4gY29kZSB0byByZWplY3QgdkNQVSBjcmVhdGlvbiBwb3N0LXZH
SUN2NSBjcmVhdGlvbiBpZiB0aGUgSUQNCmlzIG91dCBvZiByYW5nZSBmb3IgdGhlIGdpdmVuIGhh
cmR3YXJlLg0KDQo1LiBBZGRlZCBpbiBhIHNlbGYgdGVzdCBmb3Igc3BhcnNlIHZDUFUgSURzIHdp
dGggR0lDdjUuIEhlbmNlLCBJJ3ZlIGdvdA0Kc29tZSBjb25maWRlbmNlIGluIHRoaXMgcmV3b3Jr
Lg0KDQpXaXRoIHRob3NlIGNoYW5nZXMsIHVzZXJzcGFjZSBpcyBub3cgYWJsZSB0byBjcmVhdGUg
dkNQVXMgaW4gYW55IG9yZGVyDQp3aXRoIGFueSAoaW4gcmFuZ2UpIElEcy4gQXMgYW4gYXNpZGUs
IEtWTSBhbHJlYWR5IGhhcyBhIGR1cGxpY2F0ZSB2Q1BVDQpJRCBjaGVjayBzbyBzaG91bGQgcmVq
ZWN0IGFueSBkdXBsaWNhdGVzLCBzbyB3ZSBzaG91bGQgbmV2ZXIgYmUgaW4gdGhlDQpzaXR1YXRp
b24gd2hlcmUgd2UgaGF2ZSB0d28gdkNQVXMgdGhhdCB1c2UgdGhlIHNhbWUgSUQgYW5kIGhlbmNl
IFZQRS4NCg0KSSBob3BlIHRoaXMgYWRkcmVzc2VzIHlvdXIgaXNzdWUhIEl0IHdhcyBtb3JlIGFu
IGFuIGFkdmVudHVyZSB0aGFuIEknZA0KZXhwZWN0ZWQsIGJ1dCB3ZSdyZSBkZWZpbml0ZWx5IGlu
IGEgYmV0dGVyIHBsYWNlIG5vdy4NCg0KPiANCj4gQ2hlZXJzLA0KPiAvZnVhZA0KDQpUaGFua3Ms
DQpTYXNjaGENCg0KWzFdIGh0dHBzOi8vc3VwcG9ydC5hcm0uY29tL2RvY3VtZW50YXRpb24vMTEx
NzAxL2xhdGVzdA0K
