Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD10432E60
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101818; cv=fail; b=VWEO2uqmvGCIFL+jcesjDHmT7+DnySjyzF8sBMqGqXPVrXg1h9d5iR0+8mf1yf/U9bpSe1daeJx7seA65/RRlcW4PIiq3NKL49cHmSK7cDOUcvBoqL4HqCHZk/sq5hnCArGplHgSXHzwiHzHJ5etXpiZT2CH+mcNQ9eEwsPDxdg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101818; c=relaxed/simple;
	bh=UHqQenFPpee1ib+TtTZIOIZGUo2cXO24xAZd8jdxpwg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OLQQVMdpXbhF3f+zyh7rwexo95YbMm2ATrw8Ur9PtGaIq5FAQCm15dp6JV2zvitN1ZLShHNttwx+iJVncFDhsd3ejM7rlZDqmD/qp7YLguuDQTFl8gnvTnrd4Nzu91TRUC8j1VU2aEQ15M9vR7Rj4514yku18SXHEwA6g7bfrsU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ImcDqK15; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ImcDqK15; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ImcDqK15";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ImcDqK15"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xWesZc8l5lQHLQG7r8P1Nxpgw+L0LeRXnoOm9Xau6Yte0e/yKxNW8oNV8tXLsCwNSJajR+doE7WRuYO33LqwF47A68udqBk64ZDnl43iSq6M0ivMnKJKnov5UYmNDEJCkFZT1Vfceh8oLijAaaChE/LQBL3lYOeERCUi9yE7iBnVGJ9d6NSyjZZZJSnsCkcaP2Qq6wZ2IRe7aoVRKtKL0qYjL+E0q4/Nnyk8PPfDprwpsLDQixpBkXDhCRiyCy6twmjvViMIwveR/Xid1FS1gmITBDARWVwREYm8ifp5YafnMdSb3huht0SS+ImTaDxkP10BM3TfhRbGCh9w3hu7wg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSTH+kLDIfZppF+XLHdoG0T+/9yX84EvjY1RiEuarno=;
 b=cOgZn84lsg3l0I9JPRsImFIQrDsCPY2JtjoQekbBS7PaKCNsV44f1msHGF0OPNUTYAQUfecHnQS2FKfQa/o2AOplDNlj8klmuPfCTWEfkbJuw5qFQhlZVbGmn+/omF6MjdjjKx7d6tZeUCCLNotbSY890riWIeivc0K1kNfSqhlZ5knSpgAaaiCIubDpQELIayC5m8GkdnIOsZa1wFFSSxGSwIXqLmrMqzvG5VEIqrzBg5+zDZ10e+FYZ8E3e/kml3apJW327rbx6V9iIoqVCd8fatGYK2Q+zPF5JTAv55x+nWWpNBtZ+7IYnKZcA6M0CMn00/DqxIvsi+VQO9gCPw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSTH+kLDIfZppF+XLHdoG0T+/9yX84EvjY1RiEuarno=;
 b=ImcDqK15MDg9zk751A1nzJGu3acyWEF5EBf2sAVR5dcrNuH2YhWcGb3XN7EhIf/WFSnQSP/qqootgR+JvsgjlZuIAk2CbvSI31xOFE1BSJNTWJ+iifdbR5/EPImDCxmssPl82ggEvPdisq+rk+2lRi/JqxjZCmDF6M6xF6jVojs=
Received: from DUZPR01CA0059.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::13) by DBBPR08MB5961.eurprd08.prod.outlook.com
 (2603:10a6:10:203::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:23:25 +0000
Received: from DB1PEPF00039230.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::1f) by DUZPR01CA0059.outlook.office365.com
 (2603:10a6:10:469::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039230.mail.protection.outlook.com (10.167.8.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:23:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAXbSkF5RU7i830Nrsv26CZnjhJgu25Xt6pTQrBOdLA78Zd/7xR+EoVtkn7NQtxcSPlvZs4G7MyB56vDSm+3fcdgYU5Qow4phRysiIkBS26+ISDzfhMKr81SB4KqtnW64dKDQATG1eK5ESEG78cHZ2allL5rYafGzK72StY1UJJzgXnamI405WS8dFIkaGb7OTdzhHAkxQIrdk8OEQWeakurOUvif/wWebcN64G8XkMpC7gr9i+shB9c0d6OtuhxxBLR/FUXIutxRj1wNZG7RnP9+02eMcbIL9gYxqC0pwjcaGhIhKmo2Gzr4nvyyRXHRu0+/QXN2gj5KMKUBL0G5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSTH+kLDIfZppF+XLHdoG0T+/9yX84EvjY1RiEuarno=;
 b=fv93ntnWJqonnHFYYE85Ui4ddO79P/JireLYm9Qw/XfWiDC2DxncQErcKIn2oEOjMnnqIHGwPw+ut72BQ9TYIokvvbxs+eE5Ya46Sw6KeUuy2gIFXYvTPCbgksesTXx1Vw+7iY4743puxGkIM8ko0q4QZtlJJ9NbXm+R8IQSlV/Yitmz2msQs8DQb8/MeSLvOKR/EowpJNhsLgCmQnZpe32EyoumtguW33yFwW3HEDkK7PM1zzP9wJd95epj7YQMqfat9d73WuGxVWq3zkL7iL8KsJeWz8Us+9EcpuKZcYcHlETN2N1MeYIoTpab8yEXr8cecN6WQ76sH8wC6lc1xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSTH+kLDIfZppF+XLHdoG0T+/9yX84EvjY1RiEuarno=;
 b=ImcDqK15MDg9zk751A1nzJGu3acyWEF5EBf2sAVR5dcrNuH2YhWcGb3XN7EhIf/WFSnQSP/qqootgR+JvsgjlZuIAk2CbvSI31xOFE1BSJNTWJ+iifdbR5/EPImDCxmssPl82ggEvPdisq+rk+2lRi/JqxjZCmDF6M6xF6jVojs=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB9PR08MB6729.eurprd08.prod.outlook.com (2603:10a6:10:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:22:47 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:22:47 +0000
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
Subject: [PATCH v5 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Topic: [PATCH v5 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Thread-Index: AQHdJl8SqSXvsSoqhkOSdrxgmJaLAg==
Date: Fri, 7 Aug 2026 11:22:47 +0000
Message-ID: <20260807111159.429128-21-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DB9PR08MB6729:EE_|DB1PEPF00039230:EE_|DBBPR08MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 83f7b957-08ab-4afc-ec07-08def4764bdc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|18002099003|22082099003|38070700021|6133799003|10067099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 gF/xMGL9Cp8dBSWqbJmUMGl8IrrXqlMV7QkPY0M4tmeu6SBSfOqHz8m9xAh9ma4UqSpXqa3h43Z9aO/b49UrB/Q+Vwdnp802F+G3absM4bwiSy3A154ZJQND9cnSLh6sqoMJEsuAst4t1Uui7WW3gFS6yXKGoHc66N46Gg0H21XM+OMEbgg3gfFZ4vGE3lBFzoc0xuCbBQqH8tj4BQDq/NXZyZwcbgGwcpfF+UsfLC3kR+DGwNf2wlq0j0hGoR5h701cTBFTdFfP9M67PycloP1ZFC/YxV1bvvKj/26rhhbcTbk9ZAWkc0Smb/jPvc8HXiAvn2P/Co7A68czM58BR6Kzyria2ggr6mdN83H1XPHDDDHhlCOfnObdkMuSE9UQFqUqEbVTLJjFMLFqLxuypjEoPQv2wZzPggE2DDW4ZyEiGOrw9MVudOnG1c5BnzYn7Uevrkvmy5tou7s0HgIKXRbTv0X4GR1Cv0sYi/U0SUucYm9q86r/HRcc9N+YzPLzo7lGD7sz5IDzBYfEHfCzBSRSMgX2155XHGFi7xL4yhw6xleXOtP2V7H6y6+3grErSwYiT+1Fr0czgtJYMZ6pl2g/VZoPR3uiWrjivL3l5H55xJDdzdY/TA7/YSP3z89AdBcLw4Jy1tVWuJkqf1er73oGeXKFuK9fToKIdo6Dz1mlVcgqCfGX17QEivLoRLN+RRewb9z3I9u7W9sCu8qQ+qSaJVQV6NwesQj1y6pLanI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(18002099003)(22082099003)(38070700021)(6133799003)(10067099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 eHNU2+HajF+ZO0tUhmOyJb+wlG4Bi+Dr4I5Ydfty4chx/EcvKCZpSI7o35OmoM4p3PJKWAhDe1i58/bjYCnByme8WmdwgbFIQPnkMAEL71owOY4aRXx1/rg1/I9f9wxxtYq1+vA2HxjCp4wG1V/Q46Wz1bZl97nU8H2AqteQLg1RI7RCykb8ZON5z98tvJSlxUuSi5b7zogs4aR5iRo95hPaw+6GuDjD8KAFYTMv6N5HXBcV8pk8CjfNnot4VL64NZ4ytZbawxe1b22+EeIseJQZAji2BI7Ju/eNhbg5T7s5Igwj1ubX6mKAbUeHwWdG1Ligg5rTJD9EwiDo31h4og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7d24fb51-a08e-4b6c-a3f3-08def4763550
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|82310400026|36860700016|14060799003|1800799024|376014|11063799006|5023799004|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/DlVymjZ7dF44xKwQwnoU4wzilojTVdaagDv3pScILWncUvz1+7f6faju6AqL5S7c2cj95kG7J9yHv5oN2kXsXdEmbcrV7xTeV+gq1Z4HrnRg6FCWxYyka2Dlw5VU7p/hd3llc8zlVkXEmhLcSkp55hzTRn1nH4LAecUDH1Ke5unTnrw6eVFziKJMlfNev9we1l3Y6pkQ0IeFgJpqM9S5V29jwplPdrsTUKUpXUblAr+ZoHmU1uxiizUMD9wYcYe+3NL/7hZvIJqf8j5faltTAMOx9q+fU4Nc3OLo2Qtz1TR9iwRvQ1oZB/OZUagThPnMhF3cAVoKqR0G7vSlWEIyjCK8eLaxFOaoqeaKDGowtKoowAjOYI5pBD2n2OpR8pAWt8uhq8uKsc4Fwv/uyLKRft0s55ToCa3KNon3OZSBbr/qosoVGANec2eEs7Pon/l1e48irlTE5y9cvUZ3YmO2ehJTE0gn7K/9ChzaMXgH6VWG7zbcYM1WkNVn5NjujPnq9c4lcX+SvQmhoQo2g98tvJsMuB381xyvG3y41f60sJYmF0MrEHMGdzt08cRrGWikdzZ2uwq8HoQSZRLU9iiU4ewO52qLby75VUry8TjPV+EBl3WfIpZpqd50LSczGn37V0VfN23fGeAPfBe+3fx43XC+PvGVGzONAYOrr1oZZXBCgYEDVWim5T3AkYJoZmqhUnwwOgWvrZ2R0CFPb6ZiA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(82310400026)(36860700016)(14060799003)(1800799024)(376014)(11063799006)(5023799004)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BTtrBgYmtIoVFWoHLlrPtz3ahNKheXMWRkMHZU5W2vliZlRcKiuItVJGwTWyI04VHoe63VqIkGIyeRCXY8yu9C7hfE9/tXCS2rLmBG9wOjKpAOcznJA9VQMoYp8U99l96QEueyaR9pRgliWyANEFvW6+wluxtD3DKj+ICUaekGkpD+6BQndwWiRSJ5dI++fODt0nPeVEIHkOZ2MAVrhWVUCbdXwwyLWaiCmh0MY8KfUONXIhWR2nOKoehOXKJ5gA1p2SfKVW6grQP8k/UNxXTMbwY47wCVyv3Zx50y6vjmIv1ZB+xtlP54HRlEM4LLicg8S7OpwWQuBwK67PwC14Cfo8lYz4lezg1iZGD1LwXtfR6mkWcVgJBCPfUT0iRMftQ7HJPRSstf4vTqP+WFJ1I5UGmoVrZxSD2viKLm5qBAoCiI/xFZ0saXTWrUNz7VBx
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:23:24.8073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f7b957-08ab-4afc-ec07-08def4764bdc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5961

In order to properly support GICv5-based VMs in KVM, emulate the
CONFIG_FRAME for a virtual IRS. This emulation needs to handle guest
accesses to the MMIO region and mimic the behaviour of a real IRS.

Introduce an IODEV for the GICv5 IRS and an associated initialisation
function that sets up the SPIs and initial IRS state. The MMIO
emulation allows the guest to query the IRS_IDx registers, manipulate
SPIs, configure ISTs, and so forth.

The emulation tracks selector state across MMIO accesses. For example,
a guest writes IRS_PE_SELR to select a PE by IAFFID. This is the VPE
ID for a VM, but the guest does not know this. If the guest reads
IRS_PE_STATUSR, KVM checks whether that IAFFID selects a valid VPE and
sets the V bit accordingly. IRS_PE_CR0 is accepted as write-ignored
because KVM does not support 1-of-N routing.

The same selector and status register model is exposed for SPIs.

Track the state of IRS_CR0.IRSEN and introduce KVM_REQ_RELOAD_GICv5 to
reload the GICv5 context of running vCPUs when it changes. Only make
the request when the enable state changes, avoiding unnecessary IPIs
for writes that leave it unchanged.

The LPI IST requires KVM to perform actions on behalf of the guest.
Treat changes to IRS_IST_BASER.Valid as the lifetime of the guest's
IST. On an Invalid-to-Valid transition, validate IRS_IST_CFGR,
allocate a shadow host IST, and assign it to the physical IRS through
the VMTE. On a Valid-to-Invalid transition, invalidate and free the
host IST. Ignore guest address changes while the BASER remains valid,
and prevent changes to IRS_IST_CFGR during that time.

As far as the guest is concerned, the IST memory it provided is being
used by the hardware, but the physical IRS uses the host shadow IST
instead.

This change provides the core IRS IODEV and MMIO emulation, but does
not plumb the device into the rest of KVM yet. The CoreSight
identification registers are added separately.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/arm.c                 |   8 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c    | 765 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  16 +
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic.h           |   2 +
 include/kvm/arm_vgic.h               |   1 +
 8 files changed, 795 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index bae2c4f92ef5c..b04dcc9a73c28 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -55,6 +55,7 @@
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
+#define KVM_REQ_RELOAD_GICv5		KVM_ARCH_REQ(12)
=20
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |=
 \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 431de9b145ca1..92dda57c08766 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9a6c72a186727..908a058314117 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1151,6 +1151,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu=
)
 			preempt_enable();
 		}
=20
+		if (kvm_check_request(KVM_REQ_RELOAD_GICv5, vcpu)) {
+			/* The IRS enable bit was changed */
+			preempt_disable();
+			vgic_v5_put(vcpu);
+			vgic_v5_load(vcpu);
+			preempt_enable();
+		}
+
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
 			kvm_vcpu_reload_pmu(vcpu);
=20
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
new file mode 100644
index 0000000000000..c6280795ab551
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -0,0 +1,765 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 ARM Limited, All Rights Reserved.
+ */
+#include <linux/bitops.h>
+#include <linux/bsearch.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_dist *vgic_v5_get_vgic(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.vgic;
+}
+
+static struct vgic_v5_irs *vgic_v5_get_irs(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vgic.vgic_v5_irs_data;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_misc(struct kvm_vcpu *vcpu,
+						gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct kvm_vcpu *target_vcpu;
+	u8 vpe_id_bits;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		value =3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM, irs->idr0.domain);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_PA_RANGE, irs->idr0.pa_range);
+		if (irs->idr0.virt)
+			value |=3D GICV5_IRS_IDR0_VIRT;
+		if (irs->idr0.setlpi)
+			value |=3D GICV5_IRS_IDR0_SETLPI;
+		if (irs->idr0.mec)
+			value |=3D GICV5_IRS_IDR0_MEC;
+		if (irs->idr0.mpam)
+			value |=3D GICV5_IRS_IDR0_MPAM;
+		if (irs->idr0.swe)
+			value |=3D GICV5_IRS_IDR0_SWE;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_IRSID, irs->idr0.irs_id);
+		break;
+	case GICV5_IRS_IDR1:
+		value =3D FIELD_PREP(GICV5_IRS_IDR1_PE_CNT,
+				   atomic_read(&vcpu->kvm->online_vcpus));
+		/*
+		 * IRS_IDR1 encodes IAFFID_BITS as N - 1.
+		 */
+		vpe_id_bits =3D vgic_v5_vmte_vpe_id_bits(vcpu);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vpe_id_bits - 1);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, irs->idr1.priority_b=
its);
+		break;
+	case GICV5_IRS_IDR2:
+		value =3D FIELD_PREP(GICV5_IRS_IDR2_ISTMD_SZ, irs->idr2.istmd_sz);
+		if (irs->idr2.istmd)
+			value |=3D GICV5_IRS_IDR2_ISTMD;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_IST_L2SZ, irs->idr2.ist_l2sz);
+		if (irs->idr2.ist_levels)
+			value |=3D GICV5_IRS_IDR2_IST_LEVELS;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, irs->idr2.min_lpi_=
id_bits);
+		value |=3D GICV5_IRS_IDR2_LPI;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_ID_BITS, irs->idr2.id_bits);
+		break;
+	case GICV5_IRS_IDR5:
+		value =3D FIELD_PREP(GICV5_IRS_IDR5_SPI_RANGE, irs->idr5.spi_range);
+		break;
+	case GICV5_IRS_IDR6:
+		value =3D FIELD_PREP(GICV5_IRS_IDR6_SPI_IRS_RANGE, irs->idr6.spi_irs_ran=
ge);
+		break;
+	case GICV5_IRS_IDR7:
+		value =3D FIELD_PREP(GICV5_IRS_IDR7_SPI_BASE, irs->idr7.spi_base);
+		break;
+	case GICV5_IRS_IIDR:
+		/* Revision, Variant, ProductID are implementation defined */
+		value =3D FIELD_PREP(GICV5_IRS_IIDR_PRODUCT_ID, PRODUCT_ID_KVM);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_VARIANT, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_REVISION, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_IMPLEMENTER, IMPLEMENTER_ARM);
+		break;
+	case GICV5_IRS_AIDR:
+		value =3D FIELD_PREP(GICV5_IRS_AIDR_COMPONENT,
+				   GICV5_AIDR_COMPONENT_IRS);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMAJORREV,
+				    GICV5_AIDR_ARCH_MAJ_REV_V5);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMINORREV,
+				    GICV5_AIDR_ARCH_MIN_REV_V0);
+		break;
+	case GICV5_IRS_CR0:
+		/*
+		 * The IRS is ALWAYS idle as we handle things instantaneously
+		 * from a guest's viewpoint.
+		 */
+		value =3D GICV5_IRS_CR0_IDLE;
+		if (READ_ONCE(vcpu->kvm->arch.vgic.enabled))
+			value |=3D GICV5_IRS_CR0_IRSEN;
+		break;
+	case GICV5_IRS_CR1:
+		if (irs->cr1.vped_wa)
+			value |=3D GICV5_IRS_CR1_VPED_WA;
+		if (irs->cr1.vped_ra)
+			value |=3D GICV5_IRS_CR1_VPED_RA;
+		if (irs->cr1.vmd_wa)
+			value |=3D GICV5_IRS_CR1_VMD_WA;
+		if (irs->cr1.vmd_ra)
+			value |=3D GICV5_IRS_CR1_VMD_RA;
+		if (irs->cr1.vpet_ra)
+			value |=3D GICV5_IRS_CR1_VPET_RA;
+		if (irs->cr1.vmt_ra)
+			value |=3D GICV5_IRS_CR1_VMT_RA;
+		if (irs->cr1.ist_wa)
+			value |=3D GICV5_IRS_CR1_IST_WA;
+		if (irs->cr1.ist_ra)
+			value |=3D GICV5_IRS_CR1_IST_RA;
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_IC, irs->cr1.ic);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_OC, irs->cr1.oc);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_SH, irs->cr1.sh);
+		break;
+	case GICV5_IRS_SYNC_STATUSR:
+		value =3D GICV5_IRS_SYNC_STATUSR_IDLE;
+		break;
+	case GICV5_IRS_PE_SELR:
+		value =3D FIELD_PREP(GICV5_IRS_PE_SELR_IAFFID,
+				   READ_ONCE(irs->pe_selr.iaffid));
+		break;
+	case GICV5_IRS_PE_STATUSR:
+		/* We assume that the PE is Online if present. Always IDLE too */
+		value =3D GICV5_IRS_PE_STATUSR_IDLE;
+
+		/* Set ONLINE and V if IAFFID selects a present PE */
+		if (kvm_get_vcpu_by_id(vcpu->kvm,
+				       READ_ONCE(irs->pe_selr.iaffid))) {
+			value |=3D GICV5_IRS_PE_STATUSR_ONLINE;
+			value |=3D GICV5_IRS_PE_STATUSR_V;
+		}
+		break;
+	case GICV5_IRS_PE_CR0: {
+		u32 iaffid =3D READ_ONCE(irs->pe_selr.iaffid);
+
+		/*
+		 * Make sure that we are doing something reasonable first.
+		 * Remember, the IAFFID is the same as the VPE_ID
+		 */
+		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, iaffid);
+		if (!target_vcpu) {
+			kvm_debug("Guest programmed invalid IAFFID (0x%x) into the IRS_PE_SELR\=
n",
+				  iaffid);
+			break;
+		}
+
+		value =3D GICV5_IRS_PE_CR0_DPS;
+		break;
+	}
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_misc(struct kvm_vcpu *vcpu, gpa_t addr,
+					unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_IRS_CR0:
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock) {
+			bool was_enabled =3D vgic->enabled;
+
+			WRITE_ONCE(vgic->enabled, !!(val & GICV5_IRS_CR0_IRSEN));
+
+			/* Reload other vCPUs on an edge */
+			if (was_enabled !=3D !!(val & GICV5_IRS_CR0_IRSEN))
+				kvm_make_all_cpus_request(vcpu->kvm,
+							  KVM_REQ_RELOAD_GICv5);
+		}
+		return;
+	case GICV5_IRS_CR1:
+		irs->cr1.sh =3D FIELD_GET(GICV5_IRS_CR1_SH, val);
+		irs->cr1.oc =3D FIELD_GET(GICV5_IRS_CR1_OC, val);
+		irs->cr1.ic =3D FIELD_GET(GICV5_IRS_CR1_IC, val);
+		irs->cr1.ist_ra =3D !!(val & GICV5_IRS_CR1_IST_RA);
+		irs->cr1.ist_wa =3D !!(val & GICV5_IRS_CR1_IST_WA);
+		irs->cr1.vmt_ra =3D !!(val & GICV5_IRS_CR1_VMT_RA);
+		irs->cr1.vpet_ra =3D !!(val & GICV5_IRS_CR1_VPET_RA);
+		irs->cr1.vmd_ra =3D !!(val & GICV5_IRS_CR1_VMD_RA);
+		irs->cr1.vmd_wa =3D !!(val & GICV5_IRS_CR1_VMD_WA);
+		irs->cr1.vped_ra =3D !!(val & GICV5_IRS_CR1_VPED_RA);
+		irs->cr1.vped_wa =3D !!(val & GICV5_IRS_CR1_VPED_WA);
+		return;
+	case GICV5_IRS_PE_SELR:
+		WRITE_ONCE(irs->pe_selr.iaffid,
+			   FIELD_GET(GICV5_IRS_PE_SELR_IAFFID, val));
+		return;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * We actually have nothing to do here as we don't support
+		 * 1-of-N routing. The only thing that the guest can correctly
+		 * write here is 0x1. However, there's no way to fault if it
+		 * writes something else. This is effectively a WI in our case,
+		 * but we keep it here for the purposes of documenting it.
+		 */
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_is_spi_selr_valid(struct vgic_v5_irs *irs, u32 id)
+{
+	/* Invalid - we don't have any SPIs at all */
+	if (irs->idr5.spi_range =3D=3D 0)
+		return false;
+
+	/* Invalid - we don't have any on this IRS */
+	if (irs->idr6.spi_irs_range =3D=3D 0)
+		return false;
+
+	/* Invalid - ID is less than min */
+	if (id < irs->idr7.spi_base)
+		return false;
+
+	/* Invalid - ID is greater than max */
+	if (id >=3D (irs->idr7.spi_base + irs->idr6.spi_irs_range))
+		return false;
+
+	return true;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_spi(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		/* Return whatever was last written */
+		value =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, READ_ONCE(irs->spi_selr.id))=
;
+		break;
+	case GICV5_IRS_SPI_STATUSR:
+		/* We assume that we can always claim to be idle */
+		value =3D GICV5_IRS_SPI_STATUSR_IDLE;
+		if (vgic_v5_is_spi_selr_valid(irs, READ_ONCE(irs->spi_selr.id)))
+			value |=3D GICV5_IRS_SPI_STATUSR_V;
+		break;
+	case GICV5_IRS_SPI_DOMAINR:
+		value =3D FIELD_PREP(GICV5_IRS_SPI_DOMAINR_DOMAIN,
+				   GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE);
+		break;
+	case GICV5_IRS_SPI_CFGR: {
+		u32 id =3D READ_ONCE(irs->spi_selr.id);
+
+		if (!vgic_v5_is_spi_selr_valid(irs, id)) {
+			/* Fault with IRS_SPI_SELR; return 0*/
+			value =3D 0;
+			break;
+		}
+
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(id));
+		if (!irq) {
+			kvm_debug_ratelimited("Guest trying to access SPI not backed by KVM\n")=
;
+			value =3D 0;
+			break;
+		}
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+				value =3D GICV5_IRS_SPI_CFGR_TM;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		break;
+	}
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_spi(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		WRITE_ONCE(irs->spi_selr.id,
+			   FIELD_GET(GICV5_IRS_SPI_SELR_ID, val));
+		return;
+	case GICV5_IRS_SPI_CFGR: {
+		u32 id =3D READ_ONCE(irs->spi_selr.id);
+
+		if (!vgic_v5_is_spi_selr_valid(irs, id))
+			return;
+
+		/*
+		 * Find KVM's representation of the interrupt - we need to make
+		 * sure that KVM's view agrees with the guest's, else interrupt
+		 * injection won't work properly for level-triggered interrupts
+		 * (we fail to handle the clearing of the pending state if KVM
+		 * thinks that the interrupt is edge-triggered, which is the
+		 * default.)
+		 */
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(id));
+		if (!irq)
+			return;
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (val & GICV5_IRS_SPI_CFGR_TM)
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			else
+				irq->config =3D VGIC_CONFIG_EDGE;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_ist_cfgr_valid(struct vgic_v5_irs *irs)
+{
+	unsigned int expected_istsz;
+
+	if (irs->ist_cfgr.lpi_id_bits < irs->idr2.min_lpi_id_bits ||
+	    irs->ist_cfgr.lpi_id_bits > irs->idr2.id_bits)
+		return false;
+
+	if (!irs->idr2.istmd)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_4;
+	else if (irs->ist_cfgr.lpi_id_bits >=3D irs->idr2.istmd_sz)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_16;
+	else
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_8;
+
+	if (irs->ist_cfgr.istsz !=3D expected_istsz)
+		return false;
+
+	if (irs->ist_cfgr.structure && !irs->idr2.ist_levels)
+		return false;
+
+	if (!irs->ist_cfgr.structure)
+		return true;
+
+	return irs->ist_cfgr.l2sz =3D=3D irs->idr2.ist_l2sz;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_ist(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	case GICV5_IRS_IST_CFGR:
+		if (irs->ist_cfgr.structure)
+			value |=3D GICV5_IRS_IST_CFGR_STRUCTURE;
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, irs->ist_cfgr.istsz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_L2SZ, irs->ist_cfgr.l2sz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, irs->ist_cfgr.lpi_=
id_bits);
+		break;
+	case GICV5_IRS_IST_BASER:
+		value =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+				   irs->ist_baser.addr >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+		if (irs->ist_baser.valid)
+			value |=3D GICV5_IRS_IST_BASER_VALID;
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+
+	switch (offset) {
+	case GICV5_IRS_IST_CFGR:
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock) {
+			if (irs->ist_baser.valid)
+				return;
+
+			irs->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS,=
 val);
+			irs->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+			irs->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+			irs->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+		}
+		return;
+	case GICV5_IRS_IST_BASER: {
+		bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+
+		guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+		/* The address cannot be changed while the IST is valid. */
+		if (irs->ist_baser.valid && valid)
+			return;
+
+		/* Valid -> Invalid */
+		if (irs->ist_baser.valid && !valid) {
+			/* Make the LPI IST invalid and then ... */
+			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
+				break;
+
+			/*
+			 * ... free the host IST if we successfully marked the
+			 * IST as invalid. Frankly, if we failed to make the
+			 * guest's IST as invalid, we're cooked because it means
+			 * that the IRS may still be using the memory that we
+			 * want to free. Hence, we leave it allocated and skip
+			 * the clearing of valid bit in the baser.
+			 */
+			vgic_v5_lpi_ist_free(vcpu->kvm);
+		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+			if (!vgic_v5_ist_cfgr_valid(irs))
+				break;
+
+			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
+				break;
+		}
+
+		/* Now that we've handled the edges, update the valid bit and addr */
+		irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
+	/*
+	 * This is the IRS_CONFIG_FRAME.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_SELR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
+				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
+				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/*
+	 * The following registers are only for running VMs. They are not yet
+	 * supported as we don't currently support nested, so expose them as
+	 * read-as-zero/write-ignored.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_BASER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_CFGR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_HPPIR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_CR0, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VMTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VPER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/* MEC, MPAM, SWERR - all unimplemented */
+
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_MECID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_PARTID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER0,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+};
+
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
+{
+	dev->regions =3D vgic_v5_irs_registers;
+	dev->nr_regions =3D ARRAY_SIZE(vgic_v5_irs_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	/* We represent both of the IRS frames back to back, so this is 128K */
+	return KVM_VGIC_V5_IRS_SIZE;
+}
+
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address)
+{
+	struct vgic_io_device *io_device =3D &kvm->arch.vgic.vgic_v5_irs_data->io=
dev;
+	unsigned int len;
+
+	/*
+	 * Design choice: Force MMIO region to be 64k aligned. Simplifies
+	 * pulling out registers.
+	 */
+	if (!IS_ALIGNED(irs_base_address, SZ_64K))
+		return -EINVAL;
+
+	len =3D vgic_v5_init_irs_iodev(io_device);
+
+	io_device->base_addr =3D irs_base_address;
+	io_device->iodev_type =3D IODEV_GICV5_IRS;
+	io_device->redist_vcpu =3D NULL;
+
+	return kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, irs_base_address, len,
+				       &io_device->dev);
+}
+
+/**
+ * kvm_vgic_v5_irs_init: initialize the IRS data structures
+ * @kvm: kvm struct pointer
+ * @nr_spis: number of spis, frozen by caller
+ */
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis)
+{
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct vgic_v5_irs *irs =3D dist->vgic_v5_irs_data;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	size_t nr_spi_bits;
+	u64 mmfr0;
+	int ret, i;
+
+	/*
+	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
+	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
+	 * is 4 bytes in size (or larger if metadata storage is required), so 16
+	 * entries would be enough for alignment. We require userspace to
+	 * provide at least 32 SPIs, so we always meet alignment requirements.
+	 */
+	if (nr_spis) {
+		dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
+				     GFP_KERNEL_ACCOUNT);
+		if (!dist->spis)
+			return -ENOMEM;
+
+		/*
+		 * In the following code we do not take the irq struct lock since
+		 * no other action on irq structs can happen while the VGIC is
+		 * not initialized yet.
+		 */
+		for (i =3D 0; i < nr_spis; i++) {
+			struct vgic_irq *irq =3D &dist->spis[i];
+
+			irq->intid =3D vgic_v5_make_spi(i);
+			INIT_LIST_HEAD(&irq->ap_list);
+			raw_spin_lock_init(&irq->irq_lock);
+			irq->vcpu =3D NULL;
+			irq->target_vcpu =3D vcpu0;
+			refcount_set(&irq->refcount, 0);
+			/*
+			 * The guest controls the enable state, and again it is
+			 * directly handled by the hardware. From our point of
+			 * view it is always enabled.
+			 */
+			irq->enabled =3D 1;
+		}
+
+		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
+
+		ret =3D vgic_v5_spi_ist_alloc(kvm, nr_spi_bits);
+		if (ret) {
+			kfree(dist->spis);
+			dist->spis =3D NULL;
+			return ret;
+		}
+	}
+
+	/* Set sane initial state for the IRS MMIO registers */
+
+	irs->idr0.domain =3D GICV5_IRS_IDR0_INT_DOM_NON_SECURE;
+
+	mmfr0 =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	irs->idr0.pa_range =3D cpuid_feature_extract_unsigned_field(mmfr0,
+								  ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	irs->idr0.virt =3D 0;
+	irs->idr0.setlpi =3D 0;
+	irs->idr0.mec =3D 0;
+	irs->idr0.mpam =3D 0;
+	irs->idr0.swe =3D 0;
+	irs->idr0.irs_id =3D 0;
+
+	irs->idr1.priority_bits =3D gicv5_global_data.irs_pri_bits - 1;
+
+	/*
+	 * Support 16-bits of ID space for the IRS. This should be sufficient
+	 * for most applications, and the CPUIF is guaranteed to have at least
+	 * 16-bits of ID space support (we actually present 16-bits there, even
+	 * if the hardware supports more). Warn if the hardware doesn't support
+	 * 16 bits, and use the smaller value. YMMV!
+	 *
+	 * As for the minimum number of ID bits, we match the hardware's
+	 * capability.
+	 */
+	if (vgic_v5_irs_ist_id_bits(&irs_caps) < 16)
+		pr_warn("Host IRS supports fewer than 16 ID bits for ISTs (%u)\n",
+			vgic_v5_irs_ist_id_bits(&irs_caps));
+
+	irs->idr2.id_bits =3D min(16, vgic_v5_irs_ist_id_bits(&irs_caps));
+	irs->idr2.min_lpi_id_bits =3D vgic_v5_irs_min_lpi_id_bits(&irs_caps);
+
+	/* Only allow the guest to create Linear ISTs - simplifies Save/Restore *=
/
+	irs->idr2.ist_levels =3D 0;
+	irs->idr2.ist_l2sz =3D GICV5_IRS_IST_CFGR_L2SZ_4K;
+	irs->idr2.istmd =3D 0;
+	irs->idr2.istmd_sz =3D 0;
+
+	/* We have a single IRS, only. All SPIs reside here! */
+	irs->idr5.spi_range =3D nr_spis;
+	irs->idr6.spi_irs_range =3D nr_spis;
+	irs->idr7.spi_base =3D 0;
+
+	irs->cr1.sh =3D 0;
+	irs->cr1.oc =3D 0;
+	irs->cr1.ic =3D 0;
+	irs->cr1.ist_ra =3D 0;
+	irs->cr1.ist_wa =3D 0;
+	irs->cr1.vmt_ra =3D 0;
+	irs->cr1.vpet_ra =3D 0;
+	irs->cr1.vmd_ra =3D 0;
+	irs->cr1.vmd_wa =3D 0;
+	irs->cr1.vped_ra =3D 0;
+	irs->cr1.vped_wa =3D 0;
+
+	irs->spi_selr.id =3D -1;
+
+	irs->pe_selr.iaffid =3D -1;
+
+	irs->ist_cfgr.lpi_id_bits =3D 0;
+	irs->ist_cfgr.l2sz =3D 0;
+	irs->ist_cfgr.istsz =3D 0;
+	irs->ist_cfgr.structure =3D 0;
+
+	irs->ist_baser.valid =3D 0;
+	irs->ist_baser.addr =3D 0;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index b143f15fd7d47..fa2ced036f7cd 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -642,6 +642,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * Provide a way for the IRS MMIO emulation to correctly populate the numb=
er of
+ * IAFFID bits (which correspond to our vpe_id_bits.
+ */
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return 0;
+
+	return vmi->vpe_id_bits;
+}
+
 /* Provide the preallocated VPE descriptor to the hardware via the VPE Tab=
le. */
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 38b6f5269a2aa..e28d39d59f7fb 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -113,6 +113,7 @@ void vgic_v5_release_vm_id(struct kvm *kvm);
=20
 int vgic_v5_vmte_init(struct kvm *kvm);
 int vgic_v5_vmte_release(struct kvm *kvm);
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2f5fdc3211d7..282278e4a6c19 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
@@ -378,6 +379,7 @@ void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgi=
c_vmcr *vmcr);
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index da15570b11292..81a1f33b051a2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -40,6 +40,7 @@
  * in KVM for now. At a future stage, this can be bumped up to 128, if req=
uired.
  */
 #define VGIC_V5_NR_PRIVATE_IRQS	64
+#define VGIC_V5_DEFAULT_NR_SPIS	32
=20
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
--=20
2.34.1
