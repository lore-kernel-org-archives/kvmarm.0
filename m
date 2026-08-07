Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011034.outbound.protection.outlook.com [52.101.70.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FBE1A9F97
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102176; cv=fail; b=NXQ/ahgjdTkyYh3bUOk3i2Cx3DUgWVJVJ7M7MT20i8rWXbfF0xkRY7uSQVJyXciS/Ubzx0I7aivdrlHjVlDMQ240RRJ1qfMDGVDgFGXmVZO4RfkQlDFFZoi5IKxFp/HtMLLRNcY/AGXDTbxOpwEcS9Z5vUofRaPn1SVxCg2TPuc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102176; c=relaxed/simple;
	bh=SY97GI+QHMsL3YQZ6QVc8kZWlZlT+/26/oeL8BKyL1A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EXYPE21QnP2JugODjRfljh41FuCmggEIK7tIs2DsePz1JHfcp6GNPH/EAXDyki56qrCo4VB2sJ8Lvs2mloOWkU1guwF0OqhaMQjKM9a3oWgeq4h84SV5z59LrtFtfFkUx/yOcLGW17BZ11dxbaPrTJSoo9VwsRBu46InqK5usBc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cG9jYuTr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cG9jYuTr; arc=fail smtp.client-ip=52.101.70.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cG9jYuTr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cG9jYuTr"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iB5mcHqrib01mIpAj5oBaQi1ZD/ewdTiSRC0/6tMD5crxldxV2KbqYYR+eTAnxH+B3TliMBtUOkB/k/0N9uJQsCekxG4mmQi3Tin+1eMyXNjuzauGgxth3jJ2PNjxa2HAh1Ad12rvG8i1D/j6eNWDhXmbEaU9yR1GTF3Q+Z1PvWMRsepH+vsm89EKCh9qU9mQ28DA1lJPp8M02U4cOJ0VFtkdeJh5uN9CaWVBOBVx4ywLbuWDUsdpswmRgm6vvtHxzZAhLVz+/Ysco1uHvQt0ylb4B+vywDuOsQRXP50Q9Owl0/jeeqdCVYJLYSy0KeFvyC/1RamnQlsBGW3YZ7BJQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1urVDb1tDA9I8EiCV9VbH7rfN6GsJ5ajaVC3kXIlt8=;
 b=jRiqkndjOsJNorx8dvarS4ubM4UTlSmPdjT1rliKs51Pzj7M9yWgVR+7bZ0xy/aVzlJIKDrjCPDr6jeTNZ63X4YWwEAtczTnLweTJexqnAuBbpgGIjQW/jXMbBdBMObyaW8LSzSAcEH1j297JP9xV3quxfFaw8H1vyxdgQThFK4XiAJD6GD8cuqfrZSY13FzXugSzv7ZKXHIOllNwQc2ca8L+AaxPw3P3hHgDMHbjhUEqZwa3P3+Ghwe7PjD6jFsUmEs5/1EuKa885fGtCxssRX6PHqj9svn8+H39nxOtw8LBZdrZyc4piVWFS72Mmx0IJQCQANy9seG2VKpMUQLew==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1urVDb1tDA9I8EiCV9VbH7rfN6GsJ5ajaVC3kXIlt8=;
 b=cG9jYuTrViG2Y9eSKmPRnF9/el/LnCpvcIxfQMi9iVvlrSon9E9XGIjfyj6MPpnj23JqwC1nb7pnyuQiHX2KVb1h/j+9XwQtuqfpBOWhnikI2YXc0S9S5caNa1jmZzn3TQl07nNW3OxT0ZoO1cM0PUeHa/ShHt7ayo56voMvs+Y=
Received: from DU2P251CA0029.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::31)
 by VE1PR08MB5678.eurprd08.prod.outlook.com (2603:10a6:800:1a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:29:27 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:230:cafe::60) by DU2P251CA0029.outlook.office365.com
 (2603:10a6:10:230::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:29:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAeeNF3Q856qyR1HiM9NcAoizqSP3jJi4sqxOAzsJyanQETY3B/20t+k3XYY3qrK5KLuwyVl0c2Qalo/X18lyUP19W0t0DwyPqNzdyTiAXjQewChooMIsYPLTAZ5VJc00a+jUGWYFosPBvkh9r+EcM6pvdq729MUXpVPFViA7XGoDEVUQ6yC+Vg4T67E7iZHIYzfhoX0W2CbOQ6p0tNTTu3h/pL5gEtnjxj+IIv1sHBs4amH9EX99dUR5sXGqFTtuykNQ1cq0x8pm2KeBnHR/iKWteyCTw7rDRNDY0YYdYW1ur4A60PBupamkpv39X31Bt+1NWc/YEAJXdTkq4fSjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1urVDb1tDA9I8EiCV9VbH7rfN6GsJ5ajaVC3kXIlt8=;
 b=gmSD1sGGgUVfM1jLmJph5+7YEdFEaotXtlMUhrUBFSRhHzC33Y7oRcXcFwBtetMRIsEl77gVema8mBKSFweugqjG0Tz+pJEkBXM/3yAJPdpard979W0JkwnsdRq1WbWAX6r3Ag1qkwACMZjKmaNiHG8m1nwdJiDm6XHHIB/Unvv5LvivVZ3bcfbqfLtvwcfjFTijfykQNApAryooJawSr1yfV9P+v3uOXu6WcAmhgUOfxE6yGOcBWXK4LuhNMHD3xwauPxQdtKmdEQkgNK/Ll0MbqG9cXeEq/WNBPyJJh5LBn4ofLYEhQ9SHnntVpBWaHXFdr+/nC9F7K7iYdgJk6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1urVDb1tDA9I8EiCV9VbH7rfN6GsJ5ajaVC3kXIlt8=;
 b=cG9jYuTrViG2Y9eSKmPRnF9/el/LnCpvcIxfQMi9iVvlrSon9E9XGIjfyj6MPpnj23JqwC1nb7pnyuQiHX2KVb1h/j+9XwQtuqfpBOWhnikI2YXc0S9S5caNa1jmZzn3TQl07nNW3OxT0ZoO1cM0PUeHa/ShHt7ayo56voMvs+Y=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:28:54 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:28:54 +0000
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
Subject: [PATCH v5 32/49] KVM: arm64: gic-v5: Handle userspace accesses to IRS
 MMIO region
Thread-Topic: [PATCH v5 32/49] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Thread-Index: AQHdJl/tk5nB4HQSnU+G1FOibCjzEw==
Date: Fri, 7 Aug 2026 11:28:54 +0000
Message-ID: <20260807111159.429128-33-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|DB1PEPF0003922F:EE_|VE1PR08MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f39075c-11fb-4755-a767-08def4772384
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 QVF4eO0+jI8PKdYcbsVQKxtJERILdiOnsy38P3yHi+Hy85J9mwjOzW4GLMwHsgnCz6CYZ9k+tWy9DZ2AAUK4FG+4/aR/4qO5TxzrZbjKugYBo1QdJuVNiG9QooV+JboPyhd/3q7VrR20QQZZF7tIHsh5O21aOxLtBKEd82t7SYIy0djYMsujQArPeSJ/5sJk1XTlacrTMODwn8ECTt99V7M+enzN96oKpg9pMev9OGcu2PDKU0SZBugMOZdEYKyRoSc0FHqAfizJD+dMINCnAd9n3wRQamlRuDXtYupiLhEoT7MrONT5CUegTso6SXU7UfExqsMpmV8/5bNrHjvAeT1mw3P5hKjbN93wuUYYftnaN9HnZBiKnFrSJmIa4b6yjwDE7dTGcs9HyDyQRfazSOjcyEXP+eHpbYF620+bLR1Jk7va4eWEQSyjih9EOHnPDMInu+0SuvPbJoqv/eRMi+kwtx/RZntLab25NSGAJB3lmijJT8jGZGdycM9YQD0NHPfAv60H50hn0aLGF/USnoE5vM4X9L9QbWoBVkYHbQUllODWJEAPhevfG5USAfDRwl0wl86D/ad2zC9sPqpdq63p/MNKdWkYnT8F1B6olgej36svrzaElkiY7YXBM/3dnQantp6AXqxRFWjUIFUuCjC/UosUqVPpn1PdEMNgfd2s0AUrR2csT/L4Bal+X+KIhZTUE03L58mUEGp3MOvBWXhvZ596xAmUFWRTgpW7Too=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 pzWb5t5h+kQTjNoWocI8p1bE/b6qGhPsyBTsJKkO0JXhT+nbozuoDD+LrverYnmpczMiadQCNEPap7g8fyTTGXKXYHOdLX3hwFwVXnub2mYcKqEB5IiQkCBjjIQEiIG6yQMGKvU3yxt/Sez1hoANNInnHiMAB6Z2OiwRZ5lprjWdOZ3kfXs/Pja1eq9LmRSs74rmd4+y25cd1CpxfUL7b24d08Q9pUX9OFf9vFevMtOgiJG65qeaT+BZAXCDulPMmEkI/X7Cy+etmFO5PbJOT8MuWOJRHpFTYJgMTqZsDVfYOx1ixaChtJgPe2qgbusaujX+xN/oSys4TV2P/i7hLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8c2f6dba-3fbf-45a3-6972-08def4771013
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|82310400026|36860700016|14060799003|1800799024|376014|30052699003|11063799006|6133799003|10067099003|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q5IP0dgERsDoo4dKdrvjRQVr4so7IAYbMX89RwSsNitvoAgXxGeC1QnqI1b5geM0MVNe3BZzgMPMjT+0mEZN45plpF4+LjJ2Csp/a7ghL6Ajcj9VCtbbjfqRNzmX19nVspmcFmYyRp/tDVOPE4/amSVH8AztydeEqWbjGD18loTGHwNU7cdyfUk5KjrP/dkJ2xj26oN7gQ6mtgxkv5TyCcm+GVz6FO9RAOv9EqGaVmcCdQ9/c3stmpPIwM7NkM6Eoe2+NcroQaDs/tmBUMPYjaMSqQSlSlF/Y0K/aHlxxUbpbKbxvShQRcJzrLcbCCShY92h0XAoJ+r4iLIiBHIXYZscVrjgUEqL0Cs3T9G/d0d81Z1H+Pg3FbGhOgiYXVfMdWSw7+y8fKn1bjG1ZOd958jLqM3O31JIWX1wBRPUM+2iHcrWO3zWeyhg1tXiN8bj+naTo0fCPW//JPlEvlrGeIFGSBIZ7ZX6tjaqoYyiJ9ih5DtUBLjGS9mpyL0dCWDaBPI64bNnwr5TNH4pryF8415ETLfOHlnxeZux9fA6NJmk+PqHuayFajyhh/CMha4ztskmxCTzY75WnDTcHw5/yyej/Wq5LTioVprygcXRwmxPZLMey4nALVeiPNmcGXAtSrEiIV631pRd1JRvT/oIu28xQ/myTQqSOh7Ta/cZ1TU6h1Iy86KNg2KQ0b2zBXQTRouNtrNVKUCf7DMoNtFwaQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(82310400026)(36860700016)(14060799003)(1800799024)(376014)(30052699003)(11063799006)(6133799003)(10067099003)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	I49BPVKA1/nJAhnKPsbjUvp0/BcGlEjtExKJ9dycsz8xFrkz+G7s+UFKi8bjFzhjM7tnCoughkQ5vt0Z4XPuVX+UZ9G13ETqJYQH4cuNIM4Q8nv1UPOudQsmEl45ovZZ80htFpixAdfgrkVZnTQntyqvHAxSG03JU8yilIq+4xenRuMk1L7X3qcu7FdEn+R3mjIrw4GHTlKgTHh+dDh+ljsdWmmVAb2LXVPcHsUDl97NnLXq/w9I7rWaMLg5AA7ZTgx+9pmOF5lF1RqtqcUcTQFkBnJVE3hL7/+UeBWkbWnJK9GbHF+I8HovlmkVmTHKjijIXAPZxRNEO5442/VADVFbuymNu5vYvUC7amND4LrF60FeGauhbdEUVKBuINbIg9DKYVJwBsXa/zgbZhmVsro3VgaspHsvjjgfSSm63lf/c1cVmFPzw8UiRWsO4uZS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:29:26.6245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f39075c-11fb-4755-a767-08def4772384
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5678

As part of saving and restoring the state of a GICv5-based system,
userspace must save and restore the IRS MMIO registers. These include
important information such as the guest IST configuration, and KVM
must present consistent state to the guest after migration.

Introduce KVM_DEV_ARM_VGIC_GRP_IRS_REGS and provide accessors to read
and write the virtual IRS register state. This is modelled on the
GICv3 ITS register interface, as the migration requirements are
broadly the same.

Reuse the guest MMIO handlers where userspace and guest accesses have
the same semantics. Add userspace-specific handling where restoring a
register image must not trigger the operation associated with a guest
MMIO write.

Validate restored ID register fields against the capabilities KVM and
the host can support. Restore the emulated IST configuration without
allocating or freeing a host IST, and report operation status
registers as idle. Accept writes to IRS_SPI_CFGR, IRS_IIDR, and
IRS_AIDR without changing their state, allowing userspace to replay
the values it previously read.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c       | 447 ++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  55 ++-
 arch/arm64/kvm/vgic/vgic.h              |   4 +
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 5 files changed, 423 insertions(+), 85 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 095046c7959fa..212066b8d7ed5 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -400,12 +400,70 @@ static unsigned long vgic_v5_mmio_read_irs_ist(struct=
 kvm_vcpu *vcpu,
 	return value;
 }
=20
+static bool vgic_v5_ist_baser_matches(const struct vgic_v5_irs *irs,
+				      unsigned long val)
+{
+	u64 addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		   << GICV5_IRS_IST_BASER_ADDR_SHIFT;
+	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+
+	return irs->ist_baser.addr =3D=3D addr && irs->ist_baser.valid =3D=3D val=
id;
+}
+
+static void vgic_v5_update_irs_ist_baser(struct vgic_v5_irs *irs,
+					 unsigned long val)
+{
+	irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+}
+
+static int vgic_v5_write_irs_ist_baser(struct kvm_vcpu *vcpu, unsigned lon=
g val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	int rc;
+
+	/* The address cannot be changed while the IST is valid. */
+	if (irs->ist_baser.valid && valid)
+		return 0;
+
+	/* Valid -> Invalid */
+	if (irs->ist_baser.valid && !valid) {
+		/* Make the LPI IST invalid and then ... */
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+		if (rc)
+			return rc;
+
+		vgic_v5_update_irs_ist_baser(irs, val);
+
+		/*
+		 * ... reflect that in the emulated BASER before freeing the
+		 * host IST. If the free fails, the guest-visible valid bit
+		 * still matches the hardware state.
+		 */
+		return vgic_v5_lpi_ist_free(vcpu->kvm);
+	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+		if (!vgic_v5_ist_cfgr_valid(irs))
+			return -EINVAL;
+
+		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);
+		if (rc)
+			return rc;
+	}
+
+	/* Now that we've handled the edges, update the valid bit and addr */
+	vgic_v5_update_irs_ist_baser(irs, val);
+
+	return 0;
+}
+
 static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
 				       unsigned int len, unsigned long val)
 {
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
=20
 	switch (offset) {
 	case GICV5_IRS_IST_CFGR:
@@ -420,85 +478,222 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vc=
pu *vcpu, gpa_t addr,
 		}
 		return;
 	case GICV5_IRS_IST_BASER: {
-		bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock)
+			vgic_v5_write_irs_ist_baser(vcpu, val);
+		return;
+	}
+	default:
+		return;
+	}
+}
=20
-		guard(mutex)(&vcpu->kvm->arch.config_lock);
+static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
+							  gpa_t addr,
+							  unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
=20
-		/* The address cannot be changed while the IST is valid. */
-		if (irs->ist_baser.valid && valid)
-			return;
+	switch (offset) {
+	case GICV5_IRS_SYNC_STATUSR:
+		return GICV5_IRS_SYNC_STATUSR_IDLE;
+	case GICV5_IRS_SPI_STATUSR:
+		return GICV5_IRS_SPI_STATUSR_IDLE;
+	case GICV5_IRS_PE_STATUSR:
+		return GICV5_IRS_PE_STATUSR_IDLE;
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	default:
+		return 0;
+	}
+}
=20
-		/* Valid -> Invalid */
-		if (irs->ist_baser.valid && !valid) {
-			/* Make the LPI IST invalid and then ... */
-			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
-				break;
+static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t add=
r,
+					  unsigned int len, unsigned long val)
+{
+	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
+	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
+	size_t offset =3D addr & (SZ_64K - 1);
=20
-			/*
-			 * ... free the host IST if we successfully marked the
-			 * IST as invalid. Frankly, if we failed to make the
-			 * guest's IST as invalid, we're cooked because it means
-			 * that the IRS may still be using the memory that we
-			 * want to free. Hence, we leave it allocated and skip
-			 * the clearing of valid bit in the baser.
-			 */
-			vgic_v5_lpi_ist_free(vcpu->kvm);
-		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
-			if (!vgic_v5_ist_cfgr_valid(irs))
-				break;
+	/*
+	 * The following registers are ONLY settable via uaccesses. The guest
+	 * cannot write them!
+	 */
=20
-			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
-				break;
-		}
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		if (FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val) !=3D
+		    GICV5_IRS_IDR0_INT_DOM_NON_SECURE)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR0_VIRT) ||
+		    (val & GICV5_IRS_IDR0_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_VIRT_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_SETLPI) ||
+		    (val & GICV5_IRS_IDR0_MEC) ||
+		    (val & GICV5_IRS_IDR0_MPAM) ||
+		    (val & GICV5_IRS_IDR0_SWE))
+			return -EINVAL;
+
+		irs_data->idr0.domain =3D FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val);
+		irs_data->idr0.pa_range =3D FIELD_GET(GICV5_IRS_IDR0_PA_RANGE, val);
+		irs_data->idr0.virt =3D !!(val & GICV5_IRS_IDR0_VIRT);
+		irs_data->idr0.setlpi =3D !!(val & GICV5_IRS_IDR0_SETLPI);
+		irs_data->idr0.mec =3D !!(val & GICV5_IRS_IDR0_MEC);
+		irs_data->idr0.mpam =3D !!(val & GICV5_IRS_IDR0_MPAM);
+		irs_data->idr0.swe =3D !!(val & GICV5_IRS_IDR0_SWE);
+		irs_data->idr0.irs_id =3D FIELD_GET(GICV5_IRS_IDR0_IRSID, val);
+		break;
+	case GICV5_IRS_IDR1: {
+		unsigned int iaffid_bits, priority_bits;
+		u8 vpe_id_bits;
=20
-		/* Now that we've handled the edges, update the valid bit and addr */
-		irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
-		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
-			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+		/* Ignore writes to PE_CNT as this is populated from num vcpus */
+		iaffid_bits =3D FIELD_GET(GICV5_IRS_IDR1_IAFFID_BITS, val);
+		priority_bits =3D FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, val);
=20
-		return;
+		/* IAFFID_BITS is derived from the VMTE and encoded as N - 1. */
+		vpe_id_bits =3D vgic_v5_vmte_vpe_id_bits(vcpu);
+		if (iaffid_bits !=3D vpe_id_bits - 1)
+			return -EINVAL;
+
+		if (priority_bits > gicv5_global_data.irs_pri_bits - 1)
+			return -EINVAL;
+
+		irs_data->idr1.priority_bits =3D priority_bits;
+		break;
 	}
+	case GICV5_IRS_IDR2:
+		/* We always support LPIs */
+		if (!(val & GICV5_IRS_IDR2_LPI))
+			return -EINVAL;
+
+		/* We only support LPIs with linear, non-metadata guest ISTs */
+		if (val & GICV5_IRS_IDR2_IST_LEVELS)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR2_ISTMD) ||
+		    FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val))
+			return -EINVAL;
+
+		/* We can't present more bits than we have support for in HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) >
+		    vgic_v5_irs_ist_id_bits(&irs_caps))
+			return -EINVAL;
+
+		/* Min LPI ID bits must be greater than or equal to the HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) <
+		    vgic_v5_irs_min_lpi_id_bits(&irs_caps))
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) >
+		    FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val))
+			return -EINVAL;
+
+		irs_data->idr2.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val);
+		irs_data->idr2.istmd =3D !!(val & GICV5_IRS_IDR2_ISTMD);
+		irs_data->idr2.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, val);
+		irs_data->idr2.ist_levels =3D !!(val & GICV5_IRS_IDR2_IST_LEVELS);
+		irs_data->idr2.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_B=
ITS, val);
+		irs_data->idr2.id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val);
+		break;
+	case GICV5_IRS_IDR5:
+		if (FIELD_GET(GICV5_IRS_IDR5_SPI_RANGE, val) !=3D irs_data->idr5.spi_ran=
ge)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR6:
+		if (FIELD_GET(GICV5_IRS_IDR6_SPI_IRS_RANGE, val) !=3D irs_data->idr6.spi=
_irs_range)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR7:
+		if (FIELD_GET(GICV5_IRS_IDR7_SPI_BASE, val) !=3D irs_data->idr7.spi_base=
)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IST_BASER:
+		if (irs_data->ist_baser.valid &&
+		    !vgic_v5_ist_baser_matches(irs_data, val))
+			return -EINVAL;
+
+		vgic_v5_update_irs_ist_baser(irs_data, val);
+		break;
+	case GICV5_IRS_IST_CFGR:
+		irs_data->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_B=
ITS, val);
+		irs_data->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+		irs_data->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+		irs_data->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+		break;
+	case GICV5_IRS_CR0:
+		vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		break;
+	case GICV5_IRS_IIDR:
+		fallthrough;
+	case GICV5_IRS_AIDR:
+		break;
 	default:
-		return;
+		return -EINVAL;
 	}
+
+	return 0;
 }
=20
 static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
 	/*
 	 * This is the IRS_CONFIG_FRAME.
 	 */
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_v5_mmio_write_irs_misc, 4,
-				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_CR0,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_v5_mmio_write_irs_misc, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SYNC_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
@@ -506,35 +701,50 @@ static const struct vgic_register_region vgic_v5_irs_=
registers[] =3D {
 				  vgic_v5_mmio_write_irs_spi, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
-				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_CFGR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_v5_mmio_write_irs_spi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_STATUSR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR,
+				  vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_PE_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 8,
-				  VGIC_ACCESS_64bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
-				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_BASER,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 8,
+					  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_CFGR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_STATUSR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
=20
@@ -764,3 +974,90 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int=
 nr_spis)
=20
 	return 0;
 }
+
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
+{
+	const struct vgic_register_region *region;
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	gpa_t addr, offset;
+	int ret, align;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+	addr =3D reg_attr.addr;
+
+	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
+		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
+
+	offset =3D attr->attr;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	if (offset & align)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Access the IRS MMIO Regs. Relevant locks have been taken by the calling=
 code.
+ */
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write)
+{
+	const struct vgic_register_region *region;
+	gpa_t addr, offset;
+	unsigned int len;
+	int align, ret =3D 0;
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit IRS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers. We therefore only
+	 * support 32-bit accesses to 32-bit-wide registers.
+	 */
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	len =3D region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (offset & align)
+		return -EINVAL;
+
+	addr =3D dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base + offset;
+
+	if (is_write) {
+		if (region->uaccess_write)
+			ret =3D region->uaccess_write(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len, *reg);
+		else
+			region->write(kvm_get_vcpu(dev->kvm, 0), addr, len, *reg);
+	} else {
+		if (region->uaccess_read)
+			*reg =3D region->uaccess_read(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len);
+		else
+			*reg =3D region->read(kvm_get_vcpu(dev->kvm, 0), addr, len);
+	}
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 599ab4efc1db5..f1f1fcb08161f 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -786,6 +786,9 @@ int vgic_v5_parse_attr(struct kvm_device *dev, struct k=
vm_device_attr *attr,
 		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
 		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		reg_attr->vcpu =3D kvm_get_vcpu(dev->kvm, 0);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -831,8 +834,11 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 				    struct kvm_device_attr *attr,
 				    bool is_write)
 {
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
 	struct vgic_reg_attr reg_attr;
 	struct kvm_vcpu *vcpu;
+	bool uaccess;
+	u64 val;
 	int ret;
=20
 	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
@@ -841,6 +847,22 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
=20
 	vcpu =3D reg_attr.vcpu;
=20
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/* Sysregs uaccess is performed by the sysreg handling code */
+		uaccess =3D false;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	default:
+		uaccess =3D true;
+	}
+
+	if (uaccess && is_write) {
+		if (get_user(val, uaddr))
+			return -EFAULT;
+	}
+
 	mutex_lock(&dev->kvm->lock);
=20
 	if (kvm_trylock_all_vcpus(dev->kvm)) {
@@ -864,6 +886,18 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		/*
+		 * The IRS registers are a mixture of 32-bit and 64-bit
+		 * registers. Internally, we always perform the correctly sized
+		 * access, but the UAPI is defined in such a way that we are
+		 * always provided a __u64 by userspace. When userspace writes,
+		 * the upper 32-bits are ignored for 32-bit accesses, and on a
+		 * read any 32-bit accesses are written back to user memory
+		 * using the full 64-bits.
+		 */
+		ret =3D vgic_v5_irs_attr_regs_access(dev, attr, &val, is_write);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
@@ -874,6 +908,9 @@ static int vgic_v5_attr_regs_access(struct kvm_device *=
dev,
 	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
=20
+	if (!ret && uaccess && !is_write)
+		ret =3D put_user(val, uaddr);
+
 	return ret;
 }
=20
@@ -883,6 +920,8 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -909,6 +948,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -940,16 +981,10 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		struct vgic_reg_attr reg_attr;
-		int ret;
-
-		ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
-		if (ret)
-			return ret;
-
-		return vgic_v5_has_cpu_sysregs_attr(reg_attr.vcpu, attr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v5_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4f9ded224d613..7536e9a13086e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -389,6 +389,10 @@ int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write);
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
