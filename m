Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012009.outbound.protection.outlook.com [52.101.66.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB522D8768
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855337; cv=fail; b=jN9Lm6I/S8NdIT2i6oTbAQqNIYyiwyZZNu0+jPMEBbm5Uh8Y0yIyncDhTKvxEybTgxmtK7beNvyvMKoLFEdv7Xg+QMGSy2u47jUT1cIyjaCwI27AvO+7whvoYJUT3fqaW7OfzjWeop92O6yEc6W/w/eflKlkw99ZQI7/BeHyNfs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855337; c=relaxed/simple;
	bh=p+ZJDy3hOoVDmZpJVDqSQMjGO/E5xqOIHf20oPt/Rz4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M4iRkC6pGWsDeHOXyPArP8K/Di08Lfk/NbdVIBjMcgdGsfV9XYBPenx6ph6dT7D81/k7DYLdE2je1SqqDNVKEOWfE0/8cbah6nnbB1Y0R+hXS3igP6uKUEUQw1gr48xeM12jW/aWyBQnoDgii3a+8ChI8w+9Qi42jG9IDSqAU8U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QM9nzadf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QM9nzadf; arc=fail smtp.client-ip=52.101.66.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QM9nzadf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QM9nzadf"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZCbqpL7VZeFj2ZdqhIA5q6Au9Ae6SxckfJ0+G1HAvny5qHR3WBXfRjjQe3z6lrwwUnjLMpGLqtNKIwybWfmud1PyUZgDD2QzmHznwEts42UTk517Ayh4UwNFn51zOOWuxrlxSgi54xM8car4Vve22/eKJIsMTjFj2A/IqaUdS+j1hMpdTrs354QBi6pJOajFuSrk8PqR3d5visJSuxNDnFrKqpn9LO0l0OyzYM6z8BAVef/kt0AT4P4RuMh45+ouHMd2yUYnS+mhahlOruYOr8ZC+ilXYWEJW1n6BgQdZkU9XO0IWJGajf93LD0+4jKTf2+A+SO1N9zEvewIaOvG7g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+ZJDy3hOoVDmZpJVDqSQMjGO/E5xqOIHf20oPt/Rz4=;
 b=f8fCCbHbC34ZIxi6lu5s3meG/t7kavnD95RFdQV94DOL2sSnPWMuq0H7SXjIaloR6epIPbO6AbQ8rWWqArI6c4G+wTS4WWWba15i0d54APBFDRvvRjnnXACWsCVWL5J2CXYd2b/f1l8ybS0p1ROYYACJfBMiQ121gvyyAkdWKzI539YRZw7EePrRsaLqPFNjfoR4vmKj4yx7hYYQkUT82STwKsEUILNCPy7GmNB/wxBYYaUgGtKQuJWuUg/DyDmz8BhWVO+8sPbcrGnJb6pBJ5ATuX2Gg9I5nw5i3iyR81CwxIvF8qPa1MkVfZrEZYhavv8SHmXBNzwKgAUm5UrwRg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+ZJDy3hOoVDmZpJVDqSQMjGO/E5xqOIHf20oPt/Rz4=;
 b=QM9nzadfGClwVpOdv2yz9e4j1SvNawKVlQZjGxRCd9NuvB/ovEkDk44mEHa+9fiYPn1npPfd6GMtchsYCMWC+i/kGiUJtiDBaYwNFCKi8gJSpGG/Hpxh/nUy2TX+eykQa6zdXLmbbUXDOBXDAlwaWrk1o1ZVr1sJg1z+dKG4eNs=
Received: from DUZPR01CA0314.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::21) by AMDPR08MB11527.eurprd08.prod.outlook.com
 (2603:10a6:20b:716::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 17:35:30 +0000
Received: from DB3PEPF00008859.eurprd02.prod.outlook.com
 (2603:10a6:10:4ba:cafe::75) by DUZPR01CA0314.outlook.office365.com
 (2603:10a6:10:4ba::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Wed,
 18 Mar 2026 17:35:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF00008859.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Wed, 18 Mar 2026 17:35:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u5JQf9nvk/e8CwaK5wseGyk8P8HTapK3AzBWzE50o18l2p/wbJAMq9b/FiPSmmyOT0Hj+D+0uPfIzyaCZxHr9tbNLftYpXWjFmXYSdP5klCaEgC+hO3XakOFeFpeE0X2O8zAsDikV8k1/0VYQQJcGJ8QHSkLhyVsEQFNsM+9IDzbaMVtB78chUyjwwYgWJkcKq1dxlPUlAir5fotytSYyiZG9OWEAqHf0nngCFgIF+xF7k3GNnd6Xe2bvTcCLD+Q3FaJ5T8V2V0VtMlqQhH0ppqU1NlPmea86DPSNEv63DnkpDG0yjpWkTyKOyon4k24wrNJPiTUpmpCXh8fPtszKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+ZJDy3hOoVDmZpJVDqSQMjGO/E5xqOIHf20oPt/Rz4=;
 b=PsHfron//rvko8ZMdIwCRJ/FpCvB8VozzjnXA6kIZ5ub4JZHGurT9ZRNpSGlplcbm1/lxzafc6VvZeT8kBD8F1lpQ+DX2357oERsz3a3E/6ogZ81Q+oltXDHkGEdSTp3AwyKF693l7l3qqNuRSgj0fXK+rEq+APT+urjbi2TNMVWzRZ43yaITW4C8hDbPNcWJLrXeg/ulYJ9Lo0pDR4tKHTL8Wq2H0o+4kMtFkszlJizwjVfsqPJO6SPHMPFEdWWrugtXivZkzhTA1rsgunaz+bP2DTW4Rka/Adt/c0qzKnhS69pkcRMwmXrSeHwZ/OwNcR5MvWjP9qy91AAOSbzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+ZJDy3hOoVDmZpJVDqSQMjGO/E5xqOIHf20oPt/Rz4=;
 b=QM9nzadfGClwVpOdv2yz9e4j1SvNawKVlQZjGxRCd9NuvB/ovEkDk44mEHa+9fiYPn1npPfd6GMtchsYCMWC+i/kGiUJtiDBaYwNFCKi8gJSpGG/Hpxh/nUy2TX+eykQa6zdXLmbbUXDOBXDAlwaWrk1o1ZVr1sJg1z+dKG4eNs=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU0PR08MB8729.eurprd08.prod.outlook.com (2603:10a6:10:403::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 17:34:27 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 17:34:27 +0000
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
Subject: Re: [PATCH v6 20/39] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v6 20/39] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHctgOCb5M+2yZNxkOtadk2PxXfnrWy7hIAgAGg1QA=
Date: Wed, 18 Mar 2026 17:34:26 +0000
Message-ID: <775a13817c26dbe2798aeb5067e7d818f7bb826c.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	 <20260317113949.2548118-21-sascha.bischoff@arm.com>
	 <86h5qe5rwn.wl-maz@kernel.org>
In-Reply-To: <86h5qe5rwn.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU0PR08MB8729:EE_|DB3PEPF00008859:EE_|AMDPR08MB11527:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ed6021-27aa-47a6-3c8e-08de8514bffd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 EUxLxH4zzriDELrenKJDKWr2c0AJ4XTa2JXnP6o/ANmeELfseTqjgYq73kkoySKI8d+gsi17NLRvOYmwbeY/XrrPrWSclhKdintoDhaT2h/jBJ1cqe76+2yXTW/8625L8/m9KVZ6nLg1lzQqDfKZtGuwPppWEoha7IzwhHBKrp0o79R6VbdHEZrcByC+9tsGK7ocuAVwXcDW6zGUZBq3OpHC3AdOANI6PaRAsALHJ+ZJ0FDeuTU2aX0qtKVVpwb4hYV4yb6jktlxtaT+yU61isQD1HDRDKDhcZH7n/P9SIBB5SxPFNDtE75Ue2ScubLND+7vpo142btxMwN7PMykhFhLZVV+cNCseRBsVHQLPJNVAQnGNJsmnRKFwra8HCyEsEQsWLVNyS819udI/qmSNLhtqLGa/sunxaZCxrWuOOKDvF7l22V7fma5yJMMg0Ua1FWZJiENuqK4Do2+wt3UJssHm08KJPQCHgqOIGfVnTjcQhcrHrhHMdAtEdK81SJ5UzU6dT9620gvjnNGYDzs2ijrauNc3b2YVgCpOnDBJGDJwTZRrp0VIVX9aMDd1EOJ/2gWWEcOfufEz6VmQRJ2ajCjjPxQyW7vJcn9JIvSUwI17aaYWFXmE2iQ1OIBnj1w1W823pxSlbxnS31/68odK5SimpUrxOj8ND2QpsDwWnS4T3Aoa5El0bbbUROtBfSMhsen7qt5el2PNu3KlZy0cyTYQEdJimTWGjauAEkITmmZznl0s6mUx7rZC7DjztmezzeegA5SEs8o5g36Q39AMlVOljob/q0OGtsR1n/7J+k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E81937F36342842B6EB999ACA6C65A3@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZiHFJnJaXmnOuHqDOirDG8jZ4dLmQfIvreVbmju0yrI1sstJHACxBoJrFex2kUXZdTf3S7OlsLVn0e/yn9AYvuYp/fq00/1MsfBezdwfb3MeSXJsu4NbO06kOZ9iOhKIlNw9MbAYqBu5oosf6ApKWhs0FTvHbhv+l1LjvhSV8oFrNarYeumrSStpGx7jsecEjARNm0TtkIT+Sh4MzYSBw5WrJQ0PjRYxZLAYks1duuHSQlLYmyuXHnxghbH2JCPmYwqjCLZLtA6QRNUQwP0nTyvE7kh9iEZRyqkpIt/awReGxWqYyV7KV2DNmX6SBmzePvWqi0lOIYuLaT5F910IhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ea64ead6-f2c5-40af-b846-08de85149a65
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|1800799024|36860700016|82310400026|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MQsC+jnMaQhBuucj5c7f1NE3SNnZX7MWxjSkuFlowSojOT5bimaZjxJ15pcN8AevWp4qZjSqNyKzc2TGY6eNDmuQNSgQqFKQrGzbJxejsEdAt9IvS/KrJOqQHyx4DA0OkamG0YVj8KPl6QDhYQXr16oWbwpayjvvpk1MQ+bA5/A44Nw2dBQFL0nQ20bD/3EXlopsOV8tNCHw+05KxtOwrmgVuH27DfByTHDqM0iLayRrZOzQIMIZXVVApMbOiKPmraug7sOWjg0y0/Adb0d9n44Q30Iyvyhapj3GDuUUTPGuTyHjn9fE4977AhwTruOHwIKVJUJZACU8pmLMgG8xxFQu8lP+TQSAz8A/WKCGt/8kYZSoLF6WjbJ7wqrJXZy9fkdsemgTbR8oR+m4gWWnHDFkhhMNxTHMlp/PfM3xPsRIAGDOwmqYckCOTJlXrn7bkEJfi8122iq2LNCYvhR6U4WsnC5QCtVnu+cbG7+mdRZugc2YyA+gV6cA21G4H23/OhVDhBc2zH1rPhY6NHq1Z9P8WTSIJHJbdvWmUMkNT+i0MqqsyMN9MXM/EQJjoto4puB6GBAlGnOm7GyQBVEXrnpSXqptXiUQI5J9cDPYVCL5SAIG8CgbFLqnuW7pHVeVMRdLeN/8psUzcRss3Pqdu1bmHLYhSfL009Bd6EjlrIFnj5CDKyD68FnUaUsZ4y+Frzp5HLs+QZqxE/YBwGv8aMzF4TcYvxAfYufqZ0XtCeS7T1NfoF2jnWhGsmKMBjgGaxF5DmK87oIIiXib7J6iIw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(1800799024)(36860700016)(82310400026)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CWztXxuDbM7YkcwE9egtRrM+/8z0zSG291GDSDWZhhyU0zpbyUEG5qGsJCC8Tl87cs0PUaL5dsFZyScDGQ5JvbwzhwyNm9p4zvNd6UFALxSLHpidkz/lCS+UaRYhabQlv/PoaqMVS3V8Y4YfsQlsgOHbEcJg51AO5nkzmSaxelDE6uG9zvoGIIhkENGSQaMQvhw+w7MPSlLfGMPuE/rQc9pU0TjZ39Pag2EYWoJOXUoHkh/dl0UXdZLyEqn2Y4FGbdEIJIdQeGEyW5goJV8PQ33fNW9o7FlbuVP31EBKcL6dIJ7I4poERdbF2d0aQGYXm5DXcco+KS8mpc7TDTD83nQdtPRUaMgn88TiaEWVHlodWs2jGW803DjndYRSljx+CMS+E313634TxOP5FC/5xGejZBA+pD0tadFqVrAkia+zGo19nUdUAXbjRMLVIjiq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 17:35:29.8947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ed6021-27aa-47a6-3c8e-08de8514bffd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11527

T24gVHVlLCAyMDI2LTAzLTE3IGF0IDE2OjQyICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgMTcgTWFyIDIwMjYgMTE6NDU6MTAgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEluaXRpYWxpc2UgdGhl
IHByaXZhdGUgaW50ZXJydXB0cyAoUFBJcywgb25seSkgZm9yIEdJQ3Y1LiBUaGlzDQo+ID4gbWVh
bnMNCj4gPiB0aGF0IGEgR0lDdjUtc3R5bGUgaW50aWQgaXMgZ2VuZXJhdGVkICh3aGljaCBlbmNv
ZGVzIHRoZSBQUEkgdHlwZQ0KPiA+IGluDQo+ID4gdGhlIHRvcCBiaXRzKSBpbnN0ZWFkIG9mIHRo
ZSAwLWJhc2VkIGluZGV4IHRoYXQgaXMgdXNlZCBmb3Igb2xkZXINCj4gPiBHSUNzLg0KPiA+IA0K
PiA+IEFkZGl0aW9uYWxseSwgc2V0IGFsbCBvZiB0aGUgR0lDdjUgUFBJcyB0byB1c2UgTGV2ZWwg
Zm9yIHRoZQ0KPiA+IGhhbmRsaW5nDQo+ID4gbW9kZSwgd2l0aCB0aGUgZXhjZXB0aW9uIG9mIHRo
ZSBTV19QUEkgd2hpY2ggdXNlcyBFZGdlLiBUaGlzDQo+ID4gbWF0Y2hlcw0KPiA+IHRoZSBhcmNo
aXRlY3R1cmFsbHktZGVmaW5lZCBzZXQgaW4gdGhlIEdJQ3Y1IHNwZWNpZmljYXRpb24gKHRoZQ0K
PiA+IENUSUlSUQ0KPiA+IGhhbmRsaW5nIG1vZGUgaXMgSU1QREVGLCBzbyBMZXZlbCBoYXMgYmVl
biBwaWNrZWQgZm9yIHRoYXQpLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNj
aG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFu
IENhbWVyb24gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMgfCA5NSArKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLQ0KPiA+IC0tLS0NCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA2NiBpbnNlcnRpb25zKCsp
LCAyOSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLWluaXQuYw0KPiA+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYw0K
PiA+IGluZGV4IGUxYmU5YzVhZGE3YjMuLmY4ZDdkNWE4OTVlNzkgMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy1pbml0LmMNCj4gPiBAQCAtMjUwLDkgKzI1MCw2NCBAQCBpbnQga3ZtX3ZnaWNf
dmNwdV9udl9pbml0KHN0cnVjdCBrdm1fdmNwdQ0KPiA+ICp2Y3B1KQ0KPiA+IMKgCXJldHVybiBy
ZXQ7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArc3RhdGljIHZvaWQgdmdpY19hbGxvY2F0ZV9wcml2
YXRlX2lycShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludA0KPiA+IGksIHUzMiB0eXBlKQ0KPiA+
ICt7DQo+ID4gKwlzdHJ1Y3QgdmdpY19pcnEgKmlycSA9ICZ2Y3B1LQ0KPiA+ID5hcmNoLnZnaWNf
Y3B1LnByaXZhdGVfaXJxc1tpXTsNCj4gPiArDQo+ID4gKwlJTklUX0xJU1RfSEVBRCgmaXJxLT5h
cF9saXN0KTsNCj4gPiArCXJhd19zcGluX2xvY2tfaW5pdCgmaXJxLT5pcnFfbG9jayk7DQo+ID4g
KwlpcnEtPnZjcHUgPSBOVUxMOw0KPiA+ICsJaXJxLT50YXJnZXRfdmNwdSA9IHZjcHU7DQo+ID4g
KwlyZWZjb3VudF9zZXQoJmlycS0+cmVmY291bnQsIDApOw0KPiA+ICsNCj4gPiArCWlycS0+aW50
aWQgPSBpOw0KPiA+ICsJaWYgKHZnaWNfaXJxX2lzX3NnaShpKSkgew0KPiA+ICsJCS8qIFNHSXMg
Ki8NCj4gPiArCQlpcnEtPmVuYWJsZWQgPSAxOw0KPiA+ICsJCWlycS0+Y29uZmlnID0gVkdJQ19D
T05GSUdfRURHRTsNCj4gPiArCX0gZWxzZSB7DQo+ID4gKwkJLyogUFBJcyAqLw0KPiA+ICsJCWly
cS0+Y29uZmlnID0gVkdJQ19DT05GSUdfTEVWRUw7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJc3dp
dGNoICh0eXBlKSB7DQo+ID4gKwljYXNlIEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMzoNCj4gPiAr
CQlpcnEtPmdyb3VwID0gMTsNCj4gPiArCQlpcnEtPm1waWRyID0ga3ZtX3ZjcHVfZ2V0X21waWRy
X2FmZih2Y3B1KTsNCj4gPiArCQlicmVhazsNCj4gPiArCWNhc2UgS1ZNX0RFVl9UWVBFX0FSTV9W
R0lDX1YyOg0KPiA+ICsJCWlycS0+Z3JvdXAgPSAwOw0KPiA+ICsJCWlycS0+dGFyZ2V0cyA9IEJJ
VCh2Y3B1LT52Y3B1X2lkKTsNCj4gPiArCQlicmVhazsNCj4gPiArCX0NCj4gPiArfQ0KPiA+ICsN
Cj4gPiArc3RhdGljIHZvaWQgdmdpY192NV9hbGxvY2F0ZV9wcml2YXRlX2lycShzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsDQo+ID4gaW50IGksIHUzMiB0eXBlKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qg
dmdpY19pcnEgKmlycSA9ICZ2Y3B1LQ0KPiA+ID5hcmNoLnZnaWNfY3B1LnByaXZhdGVfaXJxc1tp
XTsNCj4gPiArDQo+ID4gKwlJTklUX0xJU1RfSEVBRCgmaXJxLT5hcF9saXN0KTsNCj4gPiArCXJh
d19zcGluX2xvY2tfaW5pdCgmaXJxLT5pcnFfbG9jayk7DQo+ID4gKwlpcnEtPnZjcHUgPSBOVUxM
Ow0KPiA+ICsJaXJxLT50YXJnZXRfdmNwdSA9IHZjcHU7DQo+ID4gKwlyZWZjb3VudF9zZXQoJmly
cS0+cmVmY291bnQsIDApOw0KPiA+ICsNCj4gPiArCWlycS0+aW50aWQgPSB2Z2ljX3Y1X21ha2Vf
cHBpKGkpOw0KPiA+ICsNCj4gPiArCS8qIFRoZSBvbmx5IEVkZ2UgYXJjaGl0ZWN0ZWQgUFBJIGlz
IHRoZSBTV19QUEkgKi8NCj4gPiArCWlmIChpID09IEdJQ1Y1X0FSQ0hfUFBJX1NXX1BQSSkNCj4g
PiArCQlpcnEtPmNvbmZpZyA9IFZHSUNfQ09ORklHX0VER0U7DQo+ID4gKwllbHNlDQo+ID4gKwkJ
aXJxLT5jb25maWcgPSBWR0lDX0NPTkZJR19MRVZFTDsNCj4gPiArDQo+ID4gKwkvKiBSZWdpc3Rl
ciB0aGUgR0lDdjUtc3BlY2lmaWMgUFBJIG9wcyAqLw0KPiA+ICsJdmdpY192NV9zZXRfcHBpX29w
cyhpcnEpOw0KPiANCj4gSSdkIGRlZmluaXRlbHkgZXhwZWN0IHRoaXMgdG8gdXNlIHRoZSBnZW5l
cmljIGFjY2Vzc29yIGluc3RlYWQgb2YNCj4gc29tZXRoaW5nIHY1LXNwZWNpZmljLg0KDQpJIHRo
aW5rIGl0IGlzIGNsZWFuZXIgdG8gdXNlIGEgaGVscGVyIGhlcmUsIGFzIG90aGVyd2lzZSB3ZSBu
ZWVkIHRvDQpleHBvc2UgdGhlIGluc3RhbmNlIG9mIHN0cnVjdCBpcnFfb3BzIG91dHNpZGUgb2Yg
dGhlIHZnaWMtdjUgY29kZS4NCldlJ3JlIGFscmVhZHkgaGFuZGxpbmcgYSBzcGVjaWFsIGNhc2Ug
Zm9yIHZnaWMtdjUgaGVyZS4NCg0KR2l2ZW4gbXkgcmVzcG9uc2UgdG8gdGhlIHByZXZpb3VzIHBh
dGNoLCB0aGlzIGNvZGUgd291bGQgYmUgY2hhbmdlZA0Kd2l0aDoNCg0KZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCmIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2lj
LWluaXQuYw0KaW5kZXggZjhkN2Q1YTg5NWU3OS4uZTAzNjZlOGMxNDRkNSAxMDA2NDQNCi0tLSBh
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCisrKyBiL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy1pbml0LmMNCkBAIC0yODUsNiArMjg1LDcgQEAgc3RhdGljIHZvaWQgdmdpY19hbGxv
Y2F0ZV9wcml2YXRlX2lycShzdHJ1Y3QNCmt2bV92Y3B1ICp2Y3B1LCBpbnQgaSwgdTMyIHR5cGUp
DQogc3RhdGljIHZvaWQgdmdpY192NV9hbGxvY2F0ZV9wcml2YXRlX2lycShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIGludCBpLA0KdTMyIHR5cGUpDQogew0KICAgICAgICBzdHJ1Y3QgdmdpY19pcnEg
KmlycSA9ICZ2Y3B1LT5hcmNoLnZnaWNfY3B1LnByaXZhdGVfaXJxc1tpXTsNCisgICAgICAgdTMy
IGludGlkID0gdmdpY192NV9tYWtlX3BwaShpKTsNCiANCiAgICAgICAgSU5JVF9MSVNUX0hFQUQo
JmlycS0+YXBfbGlzdCk7DQogICAgICAgIHJhd19zcGluX2xvY2tfaW5pdCgmaXJxLT5pcnFfbG9j
ayk7DQpAQCAtMjkyLDcgKzI5Myw3IEBAIHN0YXRpYyB2b2lkIHZnaWNfdjVfYWxsb2NhdGVfcHJp
dmF0ZV9pcnEoc3RydWN0DQprdm1fdmNwdSAqdmNwdSwgaW50IGksIHUzMiB0eXBlKQ0KICAgICAg
ICBpcnEtPnRhcmdldF92Y3B1ID0gdmNwdTsNCiAgICAgICAgcmVmY291bnRfc2V0KCZpcnEtPnJl
ZmNvdW50LCAwKTsNCiANCi0gICAgICAgaXJxLT5pbnRpZCA9IHZnaWNfdjVfbWFrZV9wcGkoaSk7
DQorICAgICAgIGlycS0+aW50aWQgPSBpbnRpZDsNCiANCiAgICAgICAgLyogVGhlIG9ubHkgRWRn
ZSBhcmNoaXRlY3RlZCBQUEkgaXMgdGhlIFNXX1BQSSAqLw0KICAgICAgICBpZiAoaSA9PSBHSUNW
NV9BUkNIX1BQSV9TV19QUEkpDQpAQCAtMzAxLDcgKzMwMiw3IEBAIHN0YXRpYyB2b2lkIHZnaWNf
djVfYWxsb2NhdGVfcHJpdmF0ZV9pcnEoc3RydWN0DQprdm1fdmNwdSAqdmNwdSwgaW50IGksIHUz
MiB0eXBlKQ0KICAgICAgICAgICAgICAgIGlycS0+Y29uZmlnID0gVkdJQ19DT05GSUdfTEVWRUw7
DQogDQogICAgICAgIC8qIFJlZ2lzdGVyIHRoZSBHSUN2NS1zcGVjaWZpYyBQUEkgb3BzICovDQot
ICAgICAgIHZnaWNfdjVfc2V0X3BwaV9vcHMoaXJxKTsNCisgICAgICAgdmdpY192NV9zZXRfcHBp
X29wcyh2Y3B1LCBpbnRpZCk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgdmdpY19hbGxvY2F0ZV9wcml2
YXRlX2lycXNfbG9ja2VkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCnUzMiB0eXBlKQ0KDQpUaGFu
a3MsDQpTYXNjaGENCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=
