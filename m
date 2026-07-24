Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010057.outbound.protection.outlook.com [52.101.69.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA5842BEAA
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890921; cv=fail; b=gwLB81gupmmhMTACqweKBTLFukGVXN1p0MBSbOv7qneu1qtbyL5OEMmxoIOMEbogiyXXwMA6mEpYNQlLQxnq2/DflWsslCl7+2uP0w2jqM3+T7Pf5aj/ZD1SGJJ6GRASEg4d/z7aMy4RmGsGotPhHc9rEtiRn0lZ958ImXBdSjY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890921; c=relaxed/simple;
	bh=ufPT+/eqNWBoWMN+FXOinK2hhh4KVMNShmCRbUI++1E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sd+t+w+ruuIpGIDQEj+xIOcREtnL/KZlFkCfDB5CvKEWBcFSKTVnOVPl/EMyUv3NSgcAKFTRUVVJWsH9WGSljisr/0vlkQ1CfhI5YR9wucKYQUPQmtOnAeUNo3QwLSVBsNmVzMbnbK8TA7j/gcv/Twn+e6/Eta+AyQ5iIDFauKo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VduixGtO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VduixGtO; arc=fail smtp.client-ip=52.101.69.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VduixGtO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VduixGtO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nu8ZT9KnO4FkH44eznx7gon+1aD3sq2uoP8gHNltxNns+HVj/wsdfKift8MgDtzujHiDmriU+qYIlB2GWHKUGh70oe7Db9DkPAqcqxY6tdDsgTWH/BNrKW0NZ4wzVE3YraEqTCj2W7KTN4U3xyGM4VEs77FqABictIaZb3/f/hCIAiBIBCY8soMJtqeyC1DPxeMGvPRcRr+bVQaY9ufUuCtt5gTudP6TJ+GL9WSpGQ2AdknjK44n9saAMFLFs7uAdF6QAX5BqMCXtxkpu+MoTQLRkTucvzerqVNLzSzVhQbQ1H+WLBjv6uCFSOwj0aYUBMilfYtRvF7022U4jGuj1g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AEfOXRbP5uoLOKITjEfJjqkGarBrPKObXHqdYSoIh04=;
 b=bnC8uazWyBcVx6YmamHsmKAK515w8RpRY+EIY+5gq13j2AGJigS484FNwlvy21kNTmLQRr5O2sgPPhwUj5etA3xV5jBxEQ+LS+RB2BjHs+nrynUYqpjDMmy9E3G8/c2XMThRutMvCeyX7jCX5sMfUnYzZ/WeZHyVzGjqz5AsecZBpNPqKV4dLuRgjuZvRf1m2O/mfBaGjq5ADemqwWZ0vvAobdEvKcfMOVjqEmH88ZkkhUk00TJ35GZslVOxnYIY8NVpY9CImBvJW3WOcB3zDNghLdQ+lkIQKYwDYQn7ckC/hhltodkJdD5a1QMZzbw8cSvmgLnoIapkIrzhLNZYYA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEfOXRbP5uoLOKITjEfJjqkGarBrPKObXHqdYSoIh04=;
 b=VduixGtOLDDh7FJf4guPQpu4SoYCqoABdlsPbuFLvMfUAwXPm4D3dndYRd/DCkmayA6OEJVGCsOsaiiZAtbL6OT5+piOpHlkJ7sScJ08K+0Fw/RoulZid70CJ91Ish7yF7rV9vBgR2JwzthJoI0Ghqh12o7mf61nGXrz+g2JBxA=
Received: from AS4P190CA0050.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:656::12)
 by VE1PR08MB5840.eurprd08.prod.outlook.com (2603:10a6:800:1b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:01:51 +0000
Received: from AMS0EPF00000193.eurprd05.prod.outlook.com
 (2603:10a6:20b:656:cafe::90) by AS4P190CA0050.outlook.office365.com
 (2603:10a6:20b:656::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:01:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000193.mail.protection.outlook.com (10.167.16.212) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTA0C+O7EJ+PFa55XoOtzaKGf7lSHvZqBZ7M0zyKViXcToYv0/tt7Om8vNFI2ow19yg7flFVCMZYhGsu0EkwNYCa66IOFHRioWu4REkdRdF681hMzKhi4BDMZR3U4kYw8bLjyqNf8SWnZzjGhny6CKKnv3JjH1bLaCYq6+M4l8oLuaZy4zMwJwONCrGhFI6uNXUZc8TA12VQI8sbPP+rS6Ar4WcOP59aDGSsJ/tOpQnxyk0VXmXcfGsyh3VOYU96pdNjdlduFWeIROWNbSo5Tb24jk+KxvmDH7P+zv86ta1UI0BRBsSin8pf0B16I43WiwbCxX/2xboc9bC65ZtYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AEfOXRbP5uoLOKITjEfJjqkGarBrPKObXHqdYSoIh04=;
 b=KzBLM1DIbVBGBtER02GeeLZy7MPrwVwc0vntYVP+4uY3mRsG1rK9ALGALbTtbA+wOMDm7ViSmQKfMjzkSMeMTTB5MjVfaDMbNb33Zq/DKCWO+rqHG2lXZgRJQ26e0zWFYPkpHqjyYITF4Wa7WUOJ8mEWVKbbEcok+OxjaS1gdtI2SpH/jiPErQ7Yy6zKzw9DQImOH0UuTYhxxdtcOzrM2F887kj/JFknCrUXZjfxlYZ3RnFoTyws1Met3WakHFe96qzJ2aXdu6337tfSMqCmHeS7W8lHPFIvbKFWbKqsSBZEl2hO8gsP3k3ndqW4XtJLRM7mbCpfEtytJsYiNhPMww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEfOXRbP5uoLOKITjEfJjqkGarBrPKObXHqdYSoIh04=;
 b=VduixGtOLDDh7FJf4guPQpu4SoYCqoABdlsPbuFLvMfUAwXPm4D3dndYRd/DCkmayA6OEJVGCsOsaiiZAtbL6OT5+piOpHlkJ7sScJ08K+0Fw/RoulZid70CJ91Ish7yF7rV9vBgR2JwzthJoI0Ghqh12o7mf61nGXrz+g2JBxA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM8PR08MB5571.eurprd08.prod.outlook.com (2603:10a6:20b:1d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:00:48 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 11:00:47 +0000
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
Subject: [PATCH v4 48/48] KVM: selftests: Add VGICv5 IST save/restore coverage
Thread-Topic: [PATCH v4 48/48] KVM: selftests: Add VGICv5 IST save/restore
 coverage
Thread-Index: AQHdG1uuYXL89DrePkC6d4r/Vizf/Q==
Date: Fri, 24 Jul 2026 11:00:47 +0000
Message-ID: <20260724104819.1296803-49-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|AM8PR08MB5571:EE_|AMS0EPF00000193:EE_|VE1PR08MB5840:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef2251d-3821-4bcd-f037-08dee972f71c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|5023799004|11063799006|6133799003|56012099006|18002099003|22082099003|10067099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 pWMMHSdcH3IlVen9rRLtlhnUOYLwY4xWH7tauZp4GJjZcLroI1Grzuw5iMehBLmUczNs1TtgO4lbNqhmd5GEBbsEBJnCf8d4RnJ+UPe26eQGd4/N/dkz/UXDYs5/XwSNZnu6bBRYrk46pagwOaU6Jt2nYOrStxJdWOamnqGSA2BB9M0YatbQtMlc69ag2EjWTb/v19H4Vj6z/l0UhCj9NrbYDiZQtYzLa6TrlLJ+Nwn6UvA/IJsHLw1ff5NIZ0IbwGWqcSuI94pwfbUSRg3baKOhhhP6dvIXtStXWhfwXUWo6rGowECk748ZEPGmsXcbShKxSUPaiICQZkIMDkze01MsNpV7xwnm/9pvynv4l2jsW+HaRRMEB2zY8167S2YvylQd5MeO+f1BqtVvQQg266Txk6D4R5Uo1TUTVaaIEHYVR5M27VGDyU7RbAMN0fVFeKdQn+v3cBEHtvlE24p7pnxVYhrubUVRz3GZ1xUHzPs6q7o70Hlfp6Zt0BhMkjOirtxqpoFTjkr3jGCMfvG3+QZOuAGoHyw9b94qkq774XPyTI6iIIjN+VA3qiuoGhSX4IQ/pWXxcq2JtYd931A1dNrrH8b87ef1/8m7G/Ygy1BKD226O6Q1P+IZlUift/WbKH6sXz4zzVtkTzGMI3F2k+0Gc54Fw6A5QCMR7+QStyXTTNfUZHCgPuocvXZalg8LVxg94P8S6Lrt2IVTK3uMhWugd3+KtKRqhKju5cNYZGA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(5023799004)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003)(10067099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kOlFoKiDfKVFC3cstb+Pn/0F9xikvEAsDjva0bnoZMrmX0aMMLgp4Q34t/bJ+U9qqCzWwp/lPoe3l/sEMeU5L8vXoK1JtkwYSVYCkBCkUkBJZgMNub8fs3OQlSK4/3vP2OXXo6alW6XBctr7N+r/hKAs3ZaA8CyJ1ySnDUq0q8hrgS952ZPimTkXyeHi1gXwdI1Rvm24PnhTvOQ2ZvIivyXHTzlka6yN4jNwvow3GbCVczLFgsTpoH9Vvk+qV/YRa4b8lTpil1rccktND1Be6qfiozVfeBBE3WJPjJEAqTN9N7PHBfGfLZHAHUXeSnFGh2XMUt1NrszZPtZ3aAxrOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5571
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000193.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b1cdb677-f8ec-42a7-dc29-08dee972d0ee
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|14060799003|36860700016|1800799024|376014|35042699022|6133799003|10067099003|11063799006|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UUIKz1LZqMjZTCA3ACUyvtUT4ty2Cf75EtQW+W6snU3bUgv+BjD77EriaQf9nTVacRPj3OLHysIl+lo+QC4yAm59AAAU90syKHDMdp2uhJ6jYPSTcbOBb4dWFFPHms5tMiugVgtE8L4CL/dl7F6bGx0Zn9UK+/UmD+5JgOGPDAzceKj2Alkxaev1zK3/CvfGtgn+5qiPlRS1E/Lvt2U5VV4IflgKkqx/5XnXNqzGY6psrIwyEmYR1DWq+PsotdWPyY7qkSA7Hr5DgdbRTgWPBuAPC5LS+wLpeB78TQaUM8OplXIRgSVjHylXAxFG3mBSgD7TegvazPMUtfwB10CnN32zX7rbjdDpgiiTXXumBwMORoqj/4hp8w9zyL2jqmuztcgzTg8i0uGugWWD/rA2KSlCrXnZ9YuH6qSd0ICZtMuHaB0mU2pLCb3CdYpGvh7SLFp9Y3xc8ckElqjUEMuK1elBHMjoaxgvYMZ5Cd9cBRGKIAs+o3CODdkJWF4+HpnYlc40lcuSrI0UPm7K1X6PA3JyAj5y1Dhi2PyGDLW/bT7OTFmFmVrFL1cFnQ3zUQelTRXprDeDPy8uehXlEm+MyT6r4lR8wWFi3QOGalCot7+y8WLGT+t2kCYTyvvqVWRYCmG3KWhCr3ZF4+i7WhXPDbxEbvFIR1iY2L6KFMPsOOwjgGx4rwKE88HfIDTxgXDIq/0piczZfm+ALlMzfoy0QA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(14060799003)(36860700016)(1800799024)(376014)(35042699022)(6133799003)(10067099003)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GTvI8BCaUMYn/3Prm2frtdZmSKXFyhvS3809JMzkjm/zJWHPdhxvR0c0NsfG5TRaCNq2EiMBbmJH9Q0mzL53zTV4Lepq5HHNJiSgjcZAxgOx9+KZvkejmy60sE1T5gK5WNFeBy0LbA4VfVV+tY7VgE/7XQ2nAXopRX2gA2F2ev7Os1+jDyOBcjS1WH6AaYjR+4FHYg7ymtontJ/nedbeyq5l10AyqsAKruYqIgF2bPCebRchRn9EPwEC/Sogzfubsm2/f+/ipFlaTF7h5uem3SP97o1InWviOC0pZLo84Bk7CEVbV8ToB3ClsNpwXKXqp/DBnt7pDdtN1x6wyfN28t73hrlhMr/YIKBbQlyPLPl7t9pCEgbIrJgFdkNxOte+fpRli3CA4XXs35RyDZQulkwUMZeWlFdlrXRHnDBk95CeRC2qdSVi1QR0iC5YubV5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:01:51.3623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef2251d-3821-4bcd-f037-08dee972f71c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000193.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5840

Add end-to-end VGICv5 IST save/restore coverage. The earlier IST
attribute test only checks API rejection cases; this test verifies that
interrupt state saved from the ISTs can be restored into a fresh VM
before first run and then consumed by the guest.

Build a source VM that configures SPI and LPI enable, priority and
affinity state from the guest. Inject selected SPIs from userspace, save
the IRS register state, and save both the SPI and LPI IST images through
KVM_DEV_ARM_VGIC_GRP_IST using userspace-provided buffers.

Create a restore VM, verify that IST restore is rejected before the IRS
state has been restored, restore the IRS registers, validate bad or
missing LPI storage, and restore the saved SPI and LPI IST images. Before
running any destination vCPU, save the ISTs again and compare the
re-saved buffers against the original saved buffers so dropped serialized
state fails independently of interrupt delivery.

Finally run the restored guest and check pending and enabled SPI/LPI
state across two VPEs, priority ordering via ICC_PCR_EL1, delivery of an
interrupt that was pending but disabled at save time, and affinity for
interrupts injected after restore.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 449 +++++++++++++++++++-
 1 file changed, 444 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index d022559005ada..05d8be8d75b51 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -25,6 +25,14 @@
 #define VGIC_V5_LPI_IST_SIZE		0x10000
 #define LPI_TEST_TO_VPE1		0
 #define LPI_TEST_TO_VPE0		1
+#define RESTORE_TEST_LPI_PENDING		0
+#define RESTORE_TEST_LPI_ENABLED		1
+#define RESTORE_TEST_SPI_PRIO_HIGH		0
+#define RESTORE_TEST_SPI_PRIO_LOW		1
+#define RESTORE_TEST_SPI_PENDING_DISABLED	2
+#define RESTORE_TEST_SPI_ENABLED		3
+#define VGIC_V5_IST_PRIO_HIGH		0x08
+#define VGIC_V5_IST_PRIO_LOW		0x10
=20
 static u64 max_phys_size;
=20
@@ -40,6 +48,9 @@ struct vm_gic {
 #define GUEST_CMD_IS_READY	13
 #define GUEST_CMD_LPI_SENT	14
 #define GUEST_CMD_LPI_REPLIED	15
+#define GUEST_CMD_IST_SOURCE_READY	16
+#define GUEST_CMD_IST_SPI_INJECT_READY	17
+#define GUEST_CMD_IST_LPI_INJECT_READY	18
=20
 static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
 					       void *lpi_ist, size_t lpi_size)
@@ -55,6 +66,7 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_=
ist, size_t spi_size,
 static u32 spi_line_expected;
 static bool spi_line_level_sensitive;
 static bool lpi_ist_ready;
+static u32 ist_restore_irq_count[VGIC_V5_LPI_NR_VCPUS];
=20
 static u64 gicv5_hwirq(u32 type, u32 intid)
 {
@@ -86,6 +98,27 @@ static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 =
target_vpe)
 	gic_insn(hwirq, CDEN);
 }
=20
+static void gicv5_set_hwirq_priority(u64 hwirq, u32 priority)
+{
+	u64 val;
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDPRI_PRIORITY_MASK, priority);
+	gic_insn(val, CDPRI);
+}
+
+static void gicv5_set_hwirq_affinity(u64 hwirq, u32 target_vpe)
+{
+	u64 val;
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDAFF_IAFFID_MASK, target_vpe);
+	gic_insn(val, CDAFF);
+}
+
+static void gicv5_enable_hwirq(u64 hwirq)
+{
+	gic_insn(hwirq, CDEN);
+}
+
 static void gicv5_enable_spi(u32 spi, u32 target_vpe)
 {
 	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
@@ -191,6 +224,15 @@ static void gicv5_configure_test_lpis(void)
 	gicv5_enable_lpi(LPI_TEST_TO_VPE0, 0);
 }
=20
+static void gicv5_set_pcr(u32 priority)
+{
+	u64 pcr;
+
+	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, priority);
+	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
+	isb();
+}
+
 static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -321,6 +363,11 @@ static void guest_lpi_irq_handler(struct ex_regs *regs=
)
 	GUEST_DONE();
 }
=20
+static void guest_unexpected_irq_handler(struct ex_regs *regs)
+{
+	GUEST_FAIL("Unexpected IRQ");
+}
+
 static void guest_lpi_code(void)
 {
 	u32 vcpu_id =3D guest_get_vcpuid();
@@ -351,6 +398,165 @@ static void guest_lpi_code(void)
 		wfi();
 }
=20
+static void restore_test_setup_hwirq(u64 hwirq, u32 target_vpe,
+				     u32 priority, bool enable)
+{
+	gicv5_set_hwirq_priority(hwirq, priority);
+	gicv5_set_hwirq_affinity(hwirq, target_vpe);
+
+	if (enable)
+		gicv5_enable_hwirq(hwirq);
+}
+
+/*
+ * The source VM configures SPI and LPI state for the IST save/restore tes=
t.
+ * It leaves interrupts disabled, allowing userspace to save the state bef=
ore
+ * the restore VM enables interrupts and checks delivery.
+ */
+static void guest_ist_source_code(void)
+{
+	local_irq_disable();
+
+	gicv5_enable_irs();
+	gicv5_configure_lpi_ist();
+
+	restore_test_setup_hwirq(gicv5_lpi_hwirq(RESTORE_TEST_LPI_PENDING),
+				 1, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_lpi_hwirq(RESTORE_TEST_LPI_ENABLED),
+				 1, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_HIGH),
+				 0, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_LOW),
+				 0, VGIC_V5_IST_PRIO_LOW, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_ENABLED),
+				 0, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_PENDING_DISABLE=
D),
+				 0, VGIC_V5_IST_PRIO_HIGH, false);
+
+	gicv5_send_lpi(RESTORE_TEST_LPI_PENDING);
+
+	GUEST_SYNC(GUEST_CMD_IST_SOURCE_READY);
+
+	while (1)
+		wfi();
+}
+
+/*
+ * This is the restore VM for the IST save/restore test. The IRS regs and =
ISTs
+ * have been restored before this code runs. Based on which VPE is running=
, a
+ * different set of interrupts is expected. We check that we get what we
+ * expected before terminating the test.
+ *
+ * The expected interrupts for VPE0 are:
+ * - High-priority SPI, pending and enabled before save.
+ * - Low-priority SPI, pending and enabled before save. This is only deliv=
ered
+ *   after the guest lowers the masked priority via ICC_PCR_EL1.
+ * - SPI that was pending but disabled before save. This is only delivered
+ *   after the guest enables it after restore.
+ * - SPI that was enabled but not pending before save. Userspace injects t=
his
+ *   after restore to check that the enable state and affinity were restor=
ed.
+ *
+ * The expected interrupts for VPE1 are:
+ * - LPI that was pending and enabled before save.
+ * - LPI that was enabled but not pending before save. The guest injects t=
his
+ *   after restore to check that the enable state and affinity were restor=
ed.
+ */
+static void guest_ist_restore_irq_handler(struct ex_regs *regs)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+	u32 count =3D ist_restore_irq_count[vcpu_id];
+	u64 hwirq, expected_hwirq =3D 0;
+	u64 ia;
+
+	ia =3D gicr_insn(CDIA);
+	if (!GICV5_GICR_CDIA_VALID(ia))
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	if (!vcpu_id) {
+		switch (count) {
+		case 0:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_HIGH);
+			break;
+		case 1:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_LOW);
+			break;
+		case 2:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_PENDING_DISABLED);
+			break;
+		case 3:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_ENABLED);
+			break;
+		default:
+			GUEST_FAIL("Unexpected VPE0 IST restore interrupt");
+		}
+	} else {
+		switch (count) {
+		case 0:
+			expected_hwirq =3D gicv5_lpi_hwirq(RESTORE_TEST_LPI_PENDING);
+			break;
+		case 1:
+			expected_hwirq =3D gicv5_lpi_hwirq(RESTORE_TEST_LPI_ENABLED);
+			break;
+		default:
+			GUEST_FAIL("Unexpected VPE1 IST restore interrupt");
+		}
+	}
+
+	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+	ist_restore_irq_count[vcpu_id]++;
+
+	if (!vcpu_id) {
+		switch (count) {
+		case 0:
+			gicv5_set_pcr(VGIC_V5_IST_PRIO_LOW);
+			break;
+		case 1:
+			gicv5_enable_hwirq(
+				gicv5_spi_hwirq(RESTORE_TEST_SPI_PENDING_DISABLED));
+			break;
+		case 2:
+			GUEST_SYNC(GUEST_CMD_IST_SPI_INJECT_READY);
+			break;
+		case 3:
+			GUEST_DONE();
+		}
+	} else {
+		switch (count) {
+		case 0:
+			gicv5_send_lpi(RESTORE_TEST_LPI_ENABLED);
+			GUEST_SYNC(GUEST_CMD_IST_LPI_INJECT_READY);
+			break;
+		case 1:
+			GUEST_DONE();
+		}
+	}
+}
+
+static void guest_ist_restore_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+
+	if (!guest_get_vcpuid())
+		gicv5_set_pcr(VGIC_V5_IST_PRIO_HIGH);
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	local_irq_enable();
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -421,8 +627,10 @@ static void vgic_v5_spi_line_vm_create(struct vm_gic *=
v,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
=20
-static void vgic_v5_lpi_vm_create(struct vm_gic *v,
-				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+static void vgic_v5_lpi_ist_vm_create(struct vm_gic *v,
+				      struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS],
+				      void (*guest_code)(void),
+				      void (*irq_handler)(struct ex_regs *))
 {
 	unsigned int nr_lpi_ist_pages;
 	u64 attr;
@@ -433,13 +641,13 @@ static void vgic_v5_lpi_vm_create(struct vm_gic *v,
 	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
=20
 	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++) {
-		vcpus[i] =3D vm_vcpu_add(v->vm, i, guest_lpi_code);
+		vcpus[i] =3D vm_vcpu_add(v->vm, i, guest_code);
 		TEST_ASSERT(vcpus[i], "Failed to create vCPU");
 	}
=20
 	vm_init_descriptor_tables(v->vm);
 	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
-				     guest_lpi_irq_handler);
+				     irq_handler);
=20
 	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
@@ -455,7 +663,10 @@ static void vgic_v5_lpi_vm_create(struct vm_gic *v,
 				    VGIC_V5_LPI_IST_BASE_GPA,
 				    VGIC_V5_LPI_MEMSLOT,
 				    nr_lpi_ist_pages, 0);
-	/* Map the IST at VA =3D=3D IPA so the guest can program the same BASER. =
*/
+	/*
+	 * Map the IST at VA =3D=3D IPA so the guest can program the same BASER
+	 * address.
+	 */
 	virt_map(v->vm, VGIC_V5_LPI_IST_BASE_GPA,
 		 VGIC_V5_LPI_IST_BASE_GPA, nr_lpi_ist_pages);
=20
@@ -463,6 +674,21 @@ static void vgic_v5_lpi_vm_create(struct vm_gic *v,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
=20
+static void vgic_v5_lpi_vm_create(struct vm_gic *v,
+				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+{
+	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_lpi_code,
+				  guest_lpi_irq_handler);
+}
+
+static void vgic_v5_ist_restore_vm_create(struct vm_gic *v,
+					  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS],
+					  void (*guest_code)(void),
+					  void (*irq_handler)(struct ex_regs *))
+{
+	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_code, irq_handler);
+}
+
 static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
 				      bool level_sensitive,
 				      bool lower_before_run)
@@ -514,6 +740,15 @@ static void vgic_v5_run_spi_line_test(u32 nr_spis, u32=
 expected_spi,
 	vm_gic_destroy(&v);
 }
=20
+static void vgic_v5_expect_sync(struct kvm_vcpu *vcpu, u64 cmd,
+				const char *msg)
+{
+	struct ucall uc;
+
+	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC && uc.args[1] =3D=3D c=
md,
+		    "%s", msg);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -639,6 +874,52 @@ static const struct vgic_sysreg_attr gic_v5_cpu_sysreg=
s[] =3D {
 	SR(SYS_ICC_PCR_EL1),
 };
=20
+static void vgic_v5_save_irs_regs(struct vm_gic *v, u64 *regs)
+{
+	int ret, i;
+
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		ret =3D __kvm_device_attr_get(v->gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    gic_v5_irs_regs[i].attr,
+					    &regs[i]);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS save failed for %s",
+			    gic_v5_irs_regs[i].name);
+	}
+}
+
+static void vgic_v5_restore_irs_regs(struct vm_gic *v, u64 *regs)
+{
+	int ret, i;
+
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		ret =3D __kvm_device_attr_set(v->gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    gic_v5_irs_regs[i].attr,
+					    &regs[i]);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS restore failed for %s",
+			    gic_v5_irs_regs[i].name);
+	}
+}
+
+static u64 vgic_v5_saved_irs_reg(u64 *regs, u64 attr)
+{
+	for (int i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		if (gic_v5_irs_regs[i].attr =3D=3D attr)
+			return regs[i];
+	}
+
+	TEST_FAIL("GICv5 IRS register 0x%lx was not saved", attr);
+}
+
+static size_t vgic_v5_lpi_ist_state_size(u64 *irs_regs)
+{
+	u64 cfgr =3D vgic_v5_saved_irs_reg(irs_regs, GICV5_IRS_IST_CFGR);
+	u32 lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS, cfgr);
+
+	return BIT(lpi_id_bits) * sizeof(__u32);
+}
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -1413,6 +1694,161 @@ static void test_vgic_v5_lpis(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_ist_save_restore(void)
+{
+	static u32 lpi_ist[VGIC_V5_LPI_IST_SIZE / sizeof(u32)];
+	static u32 lpi_ist_resave[VGIC_V5_LPI_IST_SIZE / sizeof(u32)];
+	static u32 spi_ist[VGIC_V5_DEFAULT_NR_SPIS];
+	static u32 spi_ist_resave[VGIC_V5_DEFAULT_NR_SPIS];
+	static u64 irs_regs[ARRAY_SIZE(gic_v5_irs_regs)];
+	struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS];
+	struct kvm_vgic_v5_ist ist_attr;
+	struct vm_gic src, dst;
+	size_t lpi_ist_size;
+	int ret;
+
+	memset(ist_restore_irq_count, 0, sizeof(ist_restore_irq_count));
+
+	vgic_v5_ist_restore_vm_create(&src, vcpus, guest_ist_source_code,
+				      guest_unexpected_irq_handler);
+
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IST save source VM");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_IST_SOURCE_READY,
+			    "GICv5 IST source guest did not become ready");
+
+	/*
+	 * The guest configured enable/priority/affinity state. Make selected
+	 * SPIs pending from userspace so the SPI IST save path sees them.
+	 */
+	vgic_v5_spi_line(src.vm, RESTORE_TEST_SPI_PRIO_HIGH, 1);
+	vgic_v5_spi_line(src.vm, RESTORE_TEST_SPI_PRIO_LOW, 1);
+	vgic_v5_spi_line(src.vm, RESTORE_TEST_SPI_PENDING_DISABLED, 1);
+
+	vgic_v5_save_irs_regs(&src, irs_regs);
+	lpi_ist_size =3D vgic_v5_lpi_ist_state_size(irs_regs);
+
+	/*
+	 * VCPU0 has configured the initial state. KVM must reject missing or
+	 * incorrectly sized LPI storage before accepting the complete IST image.
+	 */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_get(src.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST save accepted missing =
LPI buffer");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size - sizeof(__u32));
+	ret =3D __kvm_device_attr_get(src.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST save accepted bad LPI =
size");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size);
+	ret =3D __kvm_device_attr_get(src.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(!ret, "GICv5 IST save failed");
+
+	vm_gic_destroy(&src);
+
+	/* Create the guest that we are restoring state into */
+	memset(ist_restore_irq_count, 0, sizeof(ist_restore_irq_count));
+	vgic_v5_ist_restore_vm_create(&dst, vcpus, guest_ist_restore_code,
+				      guest_ist_restore_irq_handler);
+	sync_global_to_guest(dst.vm, ist_restore_irq_count);
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size);
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST restore before IRS sta=
te");
+
+	vgic_v5_restore_irs_regs(&dst, irs_regs);
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST restore accepted missi=
ng LPI buffer");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size - sizeof(__u32));
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST restore accepted bad L=
PI size");
+
+	/* Restore the VMM-owned SPI and LPI IST images. */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size);
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(!ret, "GICv5 IST restore failed");
+
+	/*
+	 * Re-save the restored IST image before the destination VM runs, so a
+	 * dropped serialized field fails independently of later interrupt
+	 * delivery.
+	 */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist_resave, sizeof(spi_ist_resave),
+				     lpi_ist_resave, lpi_ist_size);
+	ret =3D __kvm_device_attr_get(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(!ret, "GICv5 IST re-save failed");
+	TEST_ASSERT(!memcmp(spi_ist, spi_ist_resave, sizeof(spi_ist)),
+		    "GICv5 SPI IST state changed across restore");
+	TEST_ASSERT(!memcmp(lpi_ist, lpi_ist_resave, lpi_ist_size),
+		    "GICv5 LPI IST state changed across restore");
+
+	/*
+	 * At this stage, the guest's IST state should match what was saved. Run
+	 * each vcpu once to let it enable interrupts, etc.
+	 */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IST restore vCPU0");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_IS_READY,
+			    "GICv5 IST restore vCPU0 did not become ready");
+
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IST restore vCPU1");
+	vgic_v5_expect_sync(vcpus[1], GUEST_CMD_IS_READY,
+			    "GICv5 IST restore vCPU1 did not become ready");
+
+	/*
+	 * VPE0 consumes two pending SPIs in restored priority order, then
+	 * enables a restored pending-but-disabled SPI.
+	 */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to consume restored GICv5 SPIs");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_IST_SPI_INJECT_READY,
+			    "GICv5 IST restore vCPU0 did not consume restored SPIs");
+
+	/*
+	 * This SPI was enabled before save, but not pending.  Inject it after
+	 * restore to prove enable, priority and affinity were restored.
+	 */
+	vgic_v5_spi_line(dst.vm, RESTORE_TEST_SPI_ENABLED, 1);
+
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to consume post-restore GICv5 SPI");
+	TEST_ASSERT(get_ucall(vcpus[0], NULL) =3D=3D UCALL_DONE,
+		    "GICv5 IST restore vCPU0 did not complete");
+
+	/*
+	 * VPE1 consumes a restored pending LPI, then pends another LPI that
+	 * was enabled before save but not pending.
+	 */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to consume restored GICv5 LPI");
+	vgic_v5_expect_sync(vcpus[1], GUEST_CMD_IST_LPI_INJECT_READY,
+			    "GICv5 IST restore vCPU1 did not consume restored LPI");
+
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to consume post-restore GICv5 LPI");
+	TEST_ASSERT(get_ucall(vcpus[1], NULL) =3D=3D UCALL_DONE,
+		    "GICv5 IST restore vCPU1 did not complete");
+
+	vm_gic_destroy(&dst);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -1470,6 +1906,9 @@ void run_tests(u32 gic_dev_type)
=20
 	pr_info("Test VGICv5 LPIs\n");
 	test_vgic_v5_lpis();
+
+	pr_info("Test VGICv5 IST save/restore\n");
+	test_vgic_v5_ist_save_restore();
 }
=20
 int main(int ac, char **av)
--=20
2.34.1
