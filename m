Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011008.outbound.protection.outlook.com [52.101.65.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415292C11CF
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855162; cv=fail; b=M7Q8Q4a5qhdKArJRTdaMBKYBFItKtJe9n/CHuFxtseiiji04f9w0BDkRQsI7FC9AUBKR6/Up0wv0aDDDvrC9L3Javz9krgCUh8sjanj97lxVvHKOwxHiVj5qLufVSYIZUGEPREVVFaRR6UptFqSYBFoMELcIzj/6niaYCK7I9qY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855162; c=relaxed/simple;
	bh=F0JpwHHeS0xgLK/VOZ/4ZJdqfllsADUIqtjnzcM8PwE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s8QpbaBAIcZoPRoYMcHXfD37vUOx75Q9fko/+bAraAbebCiQp9ybX7gwSUOYGR6A2JBB0SRlTxHBDeIQuER9gWJP5fyZmGnCoQ60yIssoXzDagrbA4VFZFsW7Q0D1geMZ0OsqF0OzyyTXsWFAjIuo3enGEXUKZGX5jtA9UQ4zUs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GZjs76BK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GZjs76BK; arc=fail smtp.client-ip=52.101.65.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GZjs76BK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GZjs76BK"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sKdsGw7ogOGSe74WDsJakmhjI34SC9nZpXXfzAbe+FoV3zv+4Xh+idx2h2rAHXZNHaDVHxa52bixyEwHspW6FFRGFqSU2+jUAF7sKx5CWvCCp0MnL17mmdpt9ABgnnT7BRaXFZSxZMAHulIPJ8WukbJ4fmSO6+14+6a7v+0cZ9A55pSRwH3RBBYjPEXLRJpLWxkMVmZIkvT1tJ394TB42wVHvvlWpTGgLSarTnrb6LBZk20tvr9yts0xy3g5/Wz9x9eRhvPFpc85AC6NpiOiN71Jd3zgjxFmA38iz2UGVrKyDohc5eXYD6c/RQdIAbKWIqEaZ24zhef8j6i7IkcNaw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0JpwHHeS0xgLK/VOZ/4ZJdqfllsADUIqtjnzcM8PwE=;
 b=VCBYWZ+g6K2Ta/Ja4xqQ7iijQL82HUBAouDXSRWaxL7MxMk5zHCZk27YOlhuNFOh+KdEuV4KEsqDTU0nEIap/f/A+xIl0JBJZK6Vb3fncL34s6pHzlJyipHfqWVsw1xjazIt0bRiNwqa0zc1phriz3c5JODei/0jGLWM6otkYqBXlLqkF6rUhUp8B9DZhSgqACD4jFPZ02WdFqcISfWwAc1idiprFe8Au6njzrSLCxQD2rLwGuRRaLyqNSyIBD4Iqly4MyW6xZE5IKPFPqJTm3HBlnfIEv5zzhOwbNentBbesVt/XokDisWfoQIHma4999TaGi6VpfF9Drw89nI8PA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0JpwHHeS0xgLK/VOZ/4ZJdqfllsADUIqtjnzcM8PwE=;
 b=GZjs76BKPprxJZFKdBzv1pulLODFRAbj1EozWK4TyXMwlieUBzxUi9RR4++5j7OGXvwxq9lqmTZXro1BdIXcDK40ZWI0xwd28CiDEGWJDcpIah1LMFUCoT+Jd/ufvxObOceZjUgzFLdPUfeTQdQRSY6/emvT4PfIrp9SPZqg/xg=
Received: from AS4P189CA0015.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::19)
 by GVXPR08MB11534.eurprd08.prod.outlook.com (2603:10a6:150:2c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 17:32:36 +0000
Received: from AMS1EPF0000008F.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::7f) by AS4P189CA0015.outlook.office365.com
 (2603:10a6:20b:5d7::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Wed,
 18 Mar 2026 17:32:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000008F.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Wed, 18 Mar 2026 17:32:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+qzzib+WC64k2So/COCiHZDf4/aBfApv1SkgFJq5iZAaKmQ9LGVWhr8AYa5m/UYbthoO2dVz/y23JcmazlULK91bmkFV3CCkmdFSd1a1dB3QE/PM1DhiIf3LuNuma54SBO04FolFsOOVlxI4bQrVemceN+sX+quGHDhMDhkMbuvoQvP68Qzb9EKfqf7e1EmS7ee6XyQd8CTnIOM3ms5RaOq4XMiJsp/j3fN/f7otv4k5HMnlDWAfwgO4iUQX2dgfxKwk1ck63WODTuwnmc/l9feLRwIDHqkaZHTP6M580lW7SV0y/FPJkaUlVCMg4mjbav/dpKIsh6QZmj/IdHetg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0JpwHHeS0xgLK/VOZ/4ZJdqfllsADUIqtjnzcM8PwE=;
 b=tIG2DO6SpGeAL2MP5wNshNwFFnBJ1KxBgdw2lrzC7qnC3iwrX1mmI4MTotIKeO4J2GK5Q2ts0YzYMupRfUbGLIQrfZIJmJi0JlkqsWnVOo7ZD7ANwe2D6uwlmAGKTjL0QEyj2eOzt+X91b3+CDPOMTRNVF4eyBf+6XmgIXi9BmxB3+uA4NYYKZzneMhKup7bx7z4HYBqcPqNz7/gn+kpzSwTv0//NSmXBfpn3Wp2ngRgX4IpdlS4FPgNYDHkFzQVBU8ViMro5WYqANQLFZdwKrxt71Fd1XhElz+CpZRR3APr/LBBVYN3YDf4wQt2KTIsBeU+zva9keisGNj2b0KxiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0JpwHHeS0xgLK/VOZ/4ZJdqfllsADUIqtjnzcM8PwE=;
 b=GZjs76BKPprxJZFKdBzv1pulLODFRAbj1EozWK4TyXMwlieUBzxUi9RR4++5j7OGXvwxq9lqmTZXro1BdIXcDK40ZWI0xwd28CiDEGWJDcpIah1LMFUCoT+Jd/ufvxObOceZjUgzFLdPUfeTQdQRSY6/emvT4PfIrp9SPZqg/xg=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10567.eurprd08.prod.outlook.com (2603:10a6:102:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 18 Mar
 2026 17:31:32 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 17:31:31 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v6 19/39] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Topic: [PATCH v6 19/39] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHctgN5AlkAt3mpbkWVXDlYxX9LXrWy6vWAgAGjIoA=
Date: Wed, 18 Mar 2026 17:31:31 +0000
Message-ID: <cb4d0804b253595bb6d95847ef1628ed1f0c0b80.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	 <20260317113949.2548118-20-sascha.bischoff@arm.com>
	 <86ikau5sf8.wl-maz@kernel.org>
In-Reply-To: <86ikau5sf8.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA6PR08MB10567:EE_|AMS1EPF0000008F:EE_|GVXPR08MB11534:EE_
X-MS-Office365-Filtering-Correlation-Id: 11c5e7fd-4e9b-42a5-8bc3-08de85145804
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Kg72S+ClE0I8UM7su7LKDQMSmITqukfv9FHXOJx6to6kSI+vh0hE1exiuV9ACrKjvPajrXVezcNvPEB5Cp1g9in4yDcUT5AueY9GK2NW9iW/SHHVfuRgK/eoaN7q71+w9Cq0PJHs0aI8dgFc5ONp0BQ8DxUc3YVltLROEwB20Sb+rFD4NS5A7LndGTZHiEoMlHs3u6eYyoQ1pxfFHFHNd5tD6HrkgEgrErdJVLkGvdg/eVPaNzMTb+X7BvYd18N06C23vuR21TTtZfZKNsTy8cik+c8LP0vjsR2bFoUMw2uGUNtCxC9mXNZ4Blw+xKYpVlJeRy3QFr9xeHHwbucDzqCfknKPZ3BpWBXGGtLq9orM4LjfBFahWgyN2BIlP1fEfO2vnY9lkEHSZaiC6vlxp6Y9m8nqpwDpwXF/cVVLjLKfWeyPUm2jrAws3mM1aZ5U2ZWaBFMPKS5aT6diDDAH5WJbquXMmYeD5wmPxk46D4ivDoErKq9aJ3Q+w3ROwbYYbOtk2qTFZWzl/mJN3aZk8k0lwUO9uW8QTJAAEWlh/t4XxF4/FX8Ylv96czUqb/ULLVlGKnTZolkInTBasARDmZ3wPz9c2m+QOy63K2LAYonha15GazNmFMYEKQD62rhI99zCxvGx8qS6ez3g/MGpAy9Y4usXPXe7bHVPvpGhl9qAM8RoQDvvsuV4OBCikrZyaY40BXT0UCzr/qBOrKw26KsYgEOPBL2vgbdfzSZHmDl2KduDWDFYoD6ziEfOSRBnIVRK7GNa8hY5kQNvjMKgwhmOoXh0LoKmFUuYHBhkVvw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0A16E9B0075884A8A723F78E0B2EFA7@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 rFjPDmjq02BVeIiuxaU60t82HFDxC5af3Ed6Y6wvDGgv4kbTGT9BJh7qEAq1Uhn/PdMWinrnzxlAOOmHdNfypoPGcl6rgiFclI4AjDfvc7mvmOHBHv8Pfy/m7gaVkm7vTORv7V6P711RoOtFGCAtW58fCFwyU+d2nmsGXubjQN8imo/ZS+a/1OxDYQF+UVJ3Xi0QfXw40c0quNEzeaeeNtbT4889v/TF+MdjlpppK9h6Xk0yN4TmFCi2R3ArNThJL22jmrgJ5zMHcZUSCk4xZBwTkBSmtfSjlgFKHNd/tDoBBx06fR/oaM0BcHt+YmMqNmGX3xh3J5NPPfaFoMWUFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10567
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000008F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d1cdfd0a-c0f1-422d-5a16-08de85143210
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|376014|36860700016|35042699022|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GWLeXI2D0DwaJbntjwgq1fEOPJZTz3cMgjfFwHOWqkY73S6+epsorPhf9PxQItugJiVe3C09LU5ptVvw7exaAJ9k0YwuNvErYmonrRP8NRD/OS+wEhvaD6KFT8U3Pv5HKKpJm18DQXbB7Bda4KamV9PWEJAaDOAkHybi0EYMPDEznUQWN7hpF3a4R3ph8IciivT56cBfK1od0ZKtiKqSOl6LSGPB4TwKf1jTn4bcQJNyPj975wIKwnCPMVJdX0+5FVqKDKhrGeLC1vPpIlJCB0n5Kr0X9k5hOC/DPs5A1sIvX8jzpzbe/MXDLOsYiFLvhumk2Fk4Ttvm/cBo06quvqQzYp7FsIMNS3ZqaCVLkUxfDnDcyjc6qwgCIdQT4WwAM9j47rZ91U5hhj/YvNs3atJGhJhVknkNT6Jc9YSipnT7d3e6F9crBEPiziRuK4VyzL6qavC4c7hQCYm5B+M68qZg3TpHrC0KeLGS5GfmwbLi1aBBIXXb7jXtlP1rQFtt9WZFWvKN1FmQ/Z1Hk6mVvoUFP8RPXE4IvQjYOiPkUmDVRbgHvcB3XKOy/70anKrrD48QXBfAMJtyg0dmgkGBosHc2B1EAu0WSVs9cltipeH7c6dnGD76P8shxtpgdazMnJhURWh2F+LqqUpeJWnaDyFfd/r81iS1+c/ShUwOSss2qaBHKPSEkChAT/MEa+NpyKbfWUOnnaN2VjC8qQHTUFq1LnBNCEq1D1g6gROl6zKC8pXA13HN8sRSWHyDbB9aDSljs/e4LUOeyff8w1dDzg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(376014)(36860700016)(35042699022)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PyJx0NzuV3bdQ50mNQWM7qvic8aEOr66xGdTMijXfezew62vPzxub9IXMkL/cUJEL3blb+P6bUhm3OA/q2gTsy+2GzF0algWFuwgeZeHjbEapL2U53TzGPdG3WtVw4f1NXo3f+X7D3HummoETVTw94yBh6SCsgJMihDn2vp4JZ5WWxrP57CjivLYBTKxQJAhjs6aUymdew8HFTkL+2FlV4PSL45lL2SH2CTmt+kwrgoTlujSGyRW6oJi5w2yxMJfeK9lUqgfIsrd/dZJ3bW8sqf/jq+h1L4mkdSXKrQvIF54+MPALLn4xcZErvJaueaPJ9i27vZ6Y6IstpBIlN0DirXMSudkyl/90s8xFUDZxnQGzjeIbMKrp+oajNmo6lMeEnCmw2pHC/JJ0AIQILylcwGViBp8skpK+wgnqPb4kSw1KXXmZALRYaYQU0me1i5S
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 17:32:35.4552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c5e7fd-4e9b-42a5-8bc3-08de85145804
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11534

T24gVHVlLCAyMDI2LTAzLTE3IGF0IDE2OjMxICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgMTcgTWFyIDIwMjYgMTE6NDQ6NTUgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoaXMgY2hhbmdlIGlu
dHJvZHVjZXMgaW50ZXJydXB0IGluamVjdGlvbiBmb3IgUFBJcyBmb3IgR0lDdjUtYmFzZWQNCj4g
PiBndWVzdHMuDQo+ID4gDQo+ID4gVGhlIGxpZmVjeWNsZSBvZiBQUElzIGlzIGxhcmdlbHkgbWFu
YWdlZCBieSB0aGUgaGFyZHdhcmUgZm9yIGENCj4gPiBHSUN2NQ0KPiA+IHN5c3RlbS4gVGhlIGh5
cGVydmlzb3IgaW5qZWN0cyBwZW5kaW5nIHN0YXRlIGludG8gdGhlIGd1ZXN0IGJ5DQo+ID4gdXNp
bmcNCj4gPiB0aGUgSUNIX1BQSV9QRU5EUnhfRUwyIHJlZ2lzdGVycy4gVGhlc2UgYXJlIHVzZWQg
YnkgdGhlIGhhcmR3YXJlIHRvDQo+ID4gcGljayBhIEhpZ2hlc3QgUHJpb3JpdHkgUGVuZGluZyBJ
bnRlcnJ1cHQgKEhQUEkpIGZvciB0aGUgZ3Vlc3QNCj4gPiBiYXNlZA0KPiA+IG9uIHRoZSBlbmFi
bGUgc3RhdGUgb2YgZWFjaCBpbmRpdmlkdWFsIGludGVycnVwdC4gVGhlIGVuYWJsZSBzdGF0ZQ0K
PiA+IGFuZA0KPiA+IHByaW9yaXR5IGZvciBlYWNoIGludGVycnVwdCBhcmUgcHJvdmlkZWQgYnkg
dGhlIGd1ZXN0IGl0c2VsZg0KPiA+ICh0aHJvdWdoDQo+ID4gd3JpdGVzIHRvIHRoZSBQUEkgcmVn
aXN0ZXJzKS4NCj4gPiANCj4gPiBXaGVuIERpcmVjdCBWaXJ0dWFsIEludGVycnVwdCAoRFZJKSBp
cyBzZXQgZm9yIGEgcGFydGljdWxhciBQUEksDQo+ID4gdGhlDQo+ID4gaHlwZXJ2aXNvciBpcyBl
dmVuIGFibGUgdG8gc2tpcCB0aGUgaW5qZWN0aW9uIG9mIHRoZSBwZW5kaW5nIHN0YXRlDQo+ID4g
YWx0b2dldGhlciAtIGl0IGFsbCBoYXBwZW5zIGluIGhhcmR3YXJlLg0KPiA+IA0KPiA+IFRoZSBy
ZXN1bHQgb2YgdGhlIGFib3ZlIGlzIHRoYXQgbm8gQVAgbGlzdHMgYXJlIHJlcXVpcmVkIGZvciBH
SUN2NSwNCj4gPiB1bmxpa2UgZm9yIG9sZGVyIEdJQ3MuIEluc3RlYWQsIGZvciBQUElzIHRoZSBJ
Q0hfUFBJXyogcmVnaXN0ZXJzDQo+ID4gZnVsZmlsIHRoZSBzYW1lIHB1cnBvc2UgZm9yIGFsbCAx
MjggUFBJcy4gSGVuY2UsIGFzIGxvbmcgYXMgdGhlDQo+ID4gSUNIX1BQSV8qIHJlZ2lzdGVycyBh
cmUgcG9wdWxhdGVkIHByaW9yIHRvIGd1ZXN0IGVudHJ5LCBhbmQgbWVyZ2VkDQo+ID4gYmFjayBp
bnRvIHRoZSBLVk0gc2hhZG93IHN0YXRlIG9uIGV4aXQsIHRoZSBQUEkgc3RhdGUgaXMgcHJlc2Vy
dmVkLA0KPiA+IGFuZCBpbnRlcnJ1cHRzIGNhbiBiZSBpbmplY3RlZC4NCj4gPiANCj4gPiBXaGVu
IGluamVjdGluZyB0aGUgc3RhdGUgb2YgYSBQUEkgdGhlIHN0YXRlIGlzIG1lcmdlZCBpbnRvIHRo
ZQ0KPiA+IFBQSS1zcGVjaWZpYyB2Z2ljX2lycSBzdHJ1Y3R1cmUuIFRoZSBQUElzIGFyZSBtYWRl
IHBlbmRpbmcgdmlhIHRoZQ0KPiA+IElDSF9QUElfUEVORFJ4X0VMMiByZWdpc3RlcnMsIHRoZSB2
YWx1ZSBvZiB3aGljaCBpcyBnZW5lcmF0ZWQgZnJvbQ0KPiA+IHRoZQ0KPiA+IHZnaWNfaXJxIHN0
cnVjdHVyZXMgZm9yIGVhY2ggUFBJIGV4cG9zZWQgb24gZ3Vlc3QgZW50cnkuIFRoZQ0KPiA+IHF1
ZXVlX2lycV91bmxvY2soKSBpcnFfb3AgaXMgcmVxdWlyZWQgdG8ga2ljayB0aGUgdkNQVSB0byBl
bnN1cmUNCj4gPiB0aGF0DQo+ID4gaXQgc2VlbXMgdGhlIG5ldyBzdGF0ZS4gVGhlIHJlc3VsdCBp
cyB0aGF0IG5vIEFQIGxpc3RzIGFyZSB1c2VkIGZvcg0KPiA+IHByaXZhdGUgaW50ZXJydXB0cyBv
biBHSUN2NS4NCj4gPiANCj4gPiBQcmlvciB0byBlbnRlcmluZyB0aGUgZ3Vlc3QsIHZnaWNfdjVf
Zmx1c2hfcHBpX3N0YXRlKCkgaXMgY2FsbGVkDQo+ID4gZnJvbQ0KPiA+IGt2bV92Z2ljX2ZsdXNo
X2h3c3RhdGUoKS4gVGhpcyBnZW5lcmF0ZXMgdGhlIHBlbmRpbmcgc3RhdGUgdG8NCj4gPiBpbmpl
Y3QNCj4gPiBpbnRvIHRoZSBndWVzdCwgYW5kIHNuYXBzaG90cyBpdCAodHdpY2UgLSBhbiBlbnRy
eSBhbmQgYW4gZXhpdA0KPiA+IGNvcHkpDQo+ID4gaW4gb3JkZXIgdG8gdHJhY2sgYW55IGNoYW5n
ZXMuIFRoZXNlIGNoYW5nZXMgY2FuIGNvbWUgZnJvbSBhIGd1ZXN0DQo+ID4gY29uc3VtaW5nIGFu
IGludGVycnVwdCBvciBmcm9tIGEgZ3Vlc3QgbWFraW5nIGFuIEVkZ2UtdHJpZ2dlcmVkDQo+ID4g
aW50ZXJydXB0IHBlbmRpbmcuDQo+ID4gDQo+ID4gV2hlbiByZXR1cm5pbmcgZnJvbSBydW5uaW5n
IGEgZ3Vlc3QsIHRoZSBndWVzdCdzIFBQSSBzdGF0ZSBpcw0KPiA+IG1lcmdlZA0KPiA+IGJhY2sg
aW50byBLVk0ncyB2Z2ljX2lycSBzdGF0ZSBpbiB2Z2ljX3Y1X21lcmdlX3BwaV9zdGF0ZSgpIGZy
b20NCj4gPiBrdm1fdmdpY19zeW5jX2h3c3RhdGUoKS4gVGhlIEVuYWJsZSBhbmQgQWN0aXZlIHN0
YXRlIGlzIHN5bmNlZCBiYWNrDQo+ID4gZm9yDQo+ID4gYWxsIFBQSXMsIGFuZCB0aGUgcGVuZGlu
ZyBzdGF0ZSBpcyBzeW5jZWQgYmFjayBmb3IgRWRnZSBQUElzIChMZXZlbA0KPiA+IGlzDQo+ID4g
ZHJpdmVuIGRpcmVjdGx5IGJ5IHRoZSBkZXZpY2VzIGdlbmVyYXRpbmcgc2FpZCBsZXZlbHMpLiBU
aGUNCj4gPiBpbmNvbWluZw0KPiA+IHBlbmRpbmcgc3RhdGUgZnJvbSB0aGUgZ3Vlc3QgaXMgbWVy
Z2VkIHdpdGggS1ZNJ3Mgc2hhZG93IHN0YXRlIHRvDQo+ID4gYXZvaWQgbG9zaW5nIGFueSBpbmNv
bWluZyBpbnRlcnJ1cHRzLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNjaG9m
ZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFuIENh
bWVyb24gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jIHwgMTQzDQo+ID4gKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmPCoMKgwqAgfMKg
IDQxICsrKysrKysrLS0NCj4gPiDCoGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5owqDCoMKgIHzC
oCAyNSArKystLS0NCj4gPiDCoDMgZmlsZXMgY2hhbmdlZCwgMTk0IGluc2VydGlvbnMoKyksIDE1
IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjUuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBpbmRl
eCAwN2Y0MTZmYmM0YmM4Li5lMDgwZmNlNjFkYzM1IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2lj
LXY1LmMNCj4gPiBAQCAtMTIyLDYgKzEyMiwxNDkgQEAgaW50IHZnaWNfdjVfZmluYWxpemVfcHBp
X3N0YXRlKHN0cnVjdCBrdm0NCj4gPiAqa3ZtKQ0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0K
PiA+IMKgDQo+ID4gKy8qDQo+ID4gKyAqIEZvciBHSUN2NSwgdGhlIFBQSXMgYXJlIG1vc3RseSBk
aXJlY3RseSBtYW5hZ2VkIGJ5IHRoZQ0KPiA+IGhhcmR3YXJlLiBXZSAodGhlDQo+ID4gKyAqIGh5
cGVydmlzb3IpIGhhbmRsZSB0aGUgcGVuZGluZywgYWN0aXZlLCBlbmFibGUgc3RhdGUNCj4gPiBz
YXZlL3Jlc3RvcmUsIGJ1dCBkb24ndA0KPiA+ICsgKiBuZWVkIHRoZSBQUElzIHRvIGJlIHF1ZXVl
ZCBvbiBhIHBlci1WQ1BVIEFQIGxpc3QuIFRoZXJlZm9yZSwNCj4gPiBzYW5pdHkgY2hlY2sgdGhl
DQo+ID4gKyAqIHN0YXRlLCB1bmxvY2ssIGFuZCByZXR1cm4uDQo+ID4gKyAqLw0KPiA+ICtzdGF0
aWMgYm9vbCB2Z2ljX3Y1X3BwaV9xdWV1ZV9pcnFfdW5sb2NrKHN0cnVjdCBrdm0gKmt2bSwgc3Ry
dWN0DQo+ID4gdmdpY19pcnEgKmlycSwNCj4gPiArCQkJCQkgdW5zaWduZWQgbG9uZyBmbGFncykN
Cj4gPiArCV9fcmVsZWFzZXMoJmlycS0+aXJxX2xvY2spDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBr
dm1fdmNwdSAqdmNwdTsNCj4gPiArDQo+ID4gKwlsb2NrZGVwX2Fzc2VydF9oZWxkKCZpcnEtPmly
cV9sb2NrKTsNCj4gPiArDQo+ID4gKwlpZiAoV0FSTl9PTl9PTkNFKCFfX2lycV9pc19wcGkoS1ZN
X0RFVl9UWVBFX0FSTV9WR0lDX1Y1LA0KPiA+IGlycS0+aW50aWQpKSkNCj4gPiArCQlnb3RvIG91
dF91bmxvY2tfZmFpbDsNCj4gPiArDQo+ID4gKwl2Y3B1ID0gaXJxLT50YXJnZXRfdmNwdTsNCj4g
PiArCWlmIChXQVJOX09OX09OQ0UoIXZjcHUpKQ0KPiA+ICsJCWdvdG8gb3V0X3VubG9ja19mYWls
Ow0KPiA+ICsNCj4gPiArCXJhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKCZpcnEtPmlycV9sb2Nr
LCBmbGFncyk7DQo+ID4gKw0KPiA+ICsJLyogRGlyZWN0bHkga2ljayB0aGUgdGFyZ2V0IFZDUFUg
dG8gbWFrZSBzdXJlIGl0IHNlZXMgdGhlDQo+ID4gSVJRICovDQo+ID4gKwlrdm1fbWFrZV9yZXF1
ZXN0KEtWTV9SRVFfSVJRX1BFTkRJTkcsIHZjcHUpOw0KPiA+ICsJa3ZtX3ZjcHVfa2ljayh2Y3B1
KTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gdHJ1ZTsNCj4gPiArDQo+ID4gK291dF91bmxvY2tfZmFp
bDoNCj4gPiArCXJhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKCZpcnEtPmlycV9sb2NrLCBmbGFn
cyk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIGZhbHNlOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0
aWMgc3RydWN0IGlycV9vcHMgdmdpY192NV9wcGlfaXJxX29wcyA9IHsNCj4gPiArCS5xdWV1ZV9p
cnFfdW5sb2NrID0gdmdpY192NV9wcGlfcXVldWVfaXJxX3VubG9jaywNCj4gPiArfTsNCj4gPiAr
DQo+ID4gK3ZvaWQgdmdpY192NV9zZXRfcHBpX29wcyhzdHJ1Y3QgdmdpY19pcnEgKmlycSkNCj4g
PiArew0KPiA+ICsJaWYgKFdBUk5fT04oIWlycSkpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4g
PiArCWd1YXJkKHJhd19zcGlubG9ja19pcnFzYXZlKSgmaXJxLT5pcnFfbG9jayk7DQo+ID4gKw0K
PiA+ICsJaWYgKCFXQVJOX09OKGlycS0+b3BzKSkNCj4gPiArCQlpcnEtPm9wcyA9ICZ2Z2ljX3Y1
X3BwaV9pcnFfb3BzOw0KPiA+ICt9DQo+IA0KPiBXaHkgaXNuJ3QgdGhpcyBhIGNhbGwgdG8ga3Zt
X3ZnaWNfc2V0X2lycV9vcHMoKT8gSXQgZmVlbHMgdmVyeSBvZGQgdG8NCj4gaGF2ZSB0d28gd2F5
cyB0byBkbyB0aGUgc2FtZSB0aGluZy4NCg0KQWJzb2x1dGVseSBubyBnb29kIHJlYXNvbiBub3Qg
dG8gZG8gdGhhdC4gVGhpcyBuZWVkcyB0byBkcm9wIHRoZSB0YWtpbmcNCm9mIHRoZSBsb2NrIHRv
IGF2b2lkIGRvdWJsZSBsb2NraW5nLCBvZiBjb3Vyc2UsIGJ1dCBpdCBtYWtlcyBzZW5zZS4NCg0K
SSB0aGluayB0aGlzIGJlY29tZXM6DQoNCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjUuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy0NCnY1LmMNCmluZGV4IGUwODBm
Y2U2MWRjMzUuLmE2NmU4YmMxY2EyNTYgMTAwNjQ0DQotLS0gYS9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjUuYw0KKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCkBAIC0xNjEs
MTUgKzE2MSw5IEBAIHN0YXRpYyBzdHJ1Y3QgaXJxX29wcyB2Z2ljX3Y1X3BwaV9pcnFfb3BzID0g
ew0KICAgICAgICAucXVldWVfaXJxX3VubG9jayA9IHZnaWNfdjVfcHBpX3F1ZXVlX2lycV91bmxv
Y2ssDQogfTsNCiANCi12b2lkIHZnaWNfdjVfc2V0X3BwaV9vcHMoc3RydWN0IHZnaWNfaXJxICpp
cnEpDQordm9pZCB2Z2ljX3Y1X3NldF9wcGlfb3BzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMy
IHZpbnRpZCkNCiB7DQotICAgICAgIGlmIChXQVJOX09OKCFpcnEpKQ0KLSAgICAgICAgICAgICAg
IHJldHVybjsNCi0NCi0gICAgICAgZ3VhcmQocmF3X3NwaW5sb2NrX2lycXNhdmUpKCZpcnEtPmly
cV9sb2NrKTsNCi0NCi0gICAgICAgaWYgKCFXQVJOX09OKGlycS0+b3BzKSkNCi0gICAgICAgICAg
ICAgICBpcnEtPm9wcyA9ICZ2Z2ljX3Y1X3BwaV9pcnFfb3BzOw0KKyAgICAgICBrdm1fdmdpY19z
ZXRfaXJxX29wcyh2Y3B1LCB2aW50aWQsICZ2Z2ljX3Y1X3BwaV9pcnFfb3BzKTsNCiB9DQogDQog
LyoNCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuaCBiL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy5oDQppbmRleCBlZjRlM2ZiNzE1OWRkLi5kOTBhZjY3NmQ1ZDA2IDEwMDY0
NA0KLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCisrKyBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5oDQpAQCAtMzY0LDcgKzM2NCw3IEBAIHZvaWQgdmdpY19kZWJ1Z19pbml0KHN0
cnVjdCBrdm0gKmt2bSk7DQogdm9pZCB2Z2ljX2RlYnVnX2Rlc3Ryb3koc3RydWN0IGt2bSAqa3Zt
KTsNCiANCiBpbnQgdmdpY192NV9wcm9iZShjb25zdCBzdHJ1Y3QgZ2ljX2t2bV9pbmZvICppbmZv
KTsNCi12b2lkIHZnaWNfdjVfc2V0X3BwaV9vcHMoc3RydWN0IHZnaWNfaXJxICppcnEpOw0KK3Zv
aWQgdmdpY192NV9zZXRfcHBpX29wcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiB2aW50aWQp
Ow0KIHZvaWQgdmdpY192NV9mbHVzaF9wcGlfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsN
CiB2b2lkIHZnaWNfdjVfZm9sZF9wcGlfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCiB2
b2lkIHZnaWNfdjVfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KDQpUaGFua3MsDQpTYXNj
aGENCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=
