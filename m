Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011069.outbound.protection.outlook.com [52.101.65.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ACB3CB544
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890300; cv=fail; b=B5M6n9NFmVJepDF9mwUm9E6hRgPyYH/RSSsV54d/1rbNT+bP5K9j+ZRdGZJK8yeS+csdc6c/3B41uJnyffrgfTs3hJRvLTytRV/t0eKfbLpU5f8nzpKyreHhASIIXDN45vnqMiYzdeKn5yLPllKCNGA0McZiam/Gc2Q0PxDTaF0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890300; c=relaxed/simple;
	bh=CanbdShWeyv/9ZejTPjGwLzkFckVnRfX097s8w9342k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n8cMRgcX01/X/sSrH+99Cujst4FebM693o/42n27EWmyew6EIVQG+4+Ps8gnQqAKlEyR3OacxuuWUguEtbfWa6C9nyshMKxRfuHOnV56uI3s4vB81UogQ/FjZXs2RBXoeNR36nVAyCXfZuAw49aWvyOtu9mBKR10J6GLxMMiPxk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TRKAqSnQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TRKAqSnQ; arc=fail smtp.client-ip=52.101.65.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TRKAqSnQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TRKAqSnQ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vsX/t8jyu+D2oegUzzXC60Mwl657HDLhJJbW38FKyFrytCncQgxM7Aw7SCp48Wjf7ZsBvDlfThnTP5dIyCSoZt9U+FjfOplCWMKG8E44SVtJCZyg/ljbIie6BXx1M/yNQI1RW4rALQBIvMO+II5lE15Q+m4PpJNeXk2V6wCF7zmAyluzJpc1yTDM/1gVRtjslsE9zVltzVBxSOUJY+jDfjosDc7eKnta8rmjojHOwj1xBzZOEUM8zMDnvmuGn/iR+WQpK4520TTvnOofVgPUoUPsVCDLobJ/sLNycqiocxypXY+hP+NMXXflv12r5hasNw9gfrEZ+SajP4M3VO60WQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRyhD+tmyDxFMO1BtvSMqqf5mhL7UNWBqcuEKqjCUYk=;
 b=IFmWk79+pdVZn9Wm0MwmS7tIHSjF7AOkHfpkLPko9QubQbCLNwas36KXtXHzMeWPgtm3u0jrZKOE8xIudBPO50lwoFUR021AM2w+oUlzVueGp1b/LgzK9oXMHM7ROQak60fzH79udhJ02arMskhRb8G2QXuQxAsje1d9nt4rtzESnH+Ivjx6B6NrM+eMhPDzuyK8rCUtiKNgI3pdkjelWoTYCjqDx8UUs7D966qhy+Nlb3aSsmHg/0jG66pZRUeWk2SU1sIAOscakR9IVoJ6tDN2ejJ2y00u5CQBfzV7CZtogxWIFlaD9dTLPWyXixM4uDg/4dJzDbGH6lpyUh0PXQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRyhD+tmyDxFMO1BtvSMqqf5mhL7UNWBqcuEKqjCUYk=;
 b=TRKAqSnQThmR3UpXsszUKfrdlBU8nM1eI5v4/ETp3/7RLNXG0jnGZIfFwPgcKHb+rESvnbx0w4zrZZ3+M3uKD/FQfnrczinoRCKPNuEJr7kiJDwomfIHT6LBUXLH0VsIMCHqtB0ZCKN2ZnXAo/ExJLS0g6knuR0++jeXRYjoD2g=
Received: from AS8P189CA0059.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:458::6)
 by PR3PR08MB5676.eurprd08.prod.outlook.com (2603:10a6:102:82::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:51:31 +0000
Received: from AM3PEPF0000A792.eurprd04.prod.outlook.com
 (2603:10a6:20b:458:cafe::5a) by AS8P189CA0059.outlook.office365.com
 (2603:10a6:20b:458::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:51:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A792.mail.protection.outlook.com (10.167.16.121) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:51:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9qzsgCUEN0JrnGn3PtBr7nsMoA425/yKT9aS+03biDaD01xIvaY4/f9VWI+1GeGINOmYXbTg6WoZ6VFohTCzPGsOJcHh9ETb/MHaOBYpK/zHG01mpScT7B85amc93powk6xZ+zl3Y5IQL08vH2yypG1sVCf22Q8arjPzaDKwvPI/Ca27HsXKFvWvS5jyv/kciPLcpDQESeUH0gYMBTmIGEsjOdci5iHa3mHuRT8vEpw6RB5iQdyi3HUIE5oSXe775Iuxspt9sojfnjBe0NFHrbNPLNtGk28LDcrPVRIKeLJB5PwF5nTZjrwi0u/rwiMB05qV07WdqF7dXF0HUzFhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRyhD+tmyDxFMO1BtvSMqqf5mhL7UNWBqcuEKqjCUYk=;
 b=byu4I7OHm8wloBOWavxp7Bfu3WdX2U2Z8Z3mNU7VHLno+SAJIGGZ5KYQpNeaM6O3aFLu66nDPsI0CcrhYqXIxHH4bc1YaDWn/KJ3T7DQsdWH2SD9KX71mZxDE6htl17zAEnMzEhTbzHEljqPZhxJpmjm56Z4Gxd4Yi9af9GIwq93Hlit73yq9PG9Bq32zR0IojECO3mpfKYeBVstzrKoenKjxyBmvDYh6jFdRjOKb/ynSBGmazbkTg+h6N6rbxHy0ZraYelWCoto9nX0oxxW8WxFXn++JuaSohgVrxXTCCkOOqBgjasBop9NHQGgfRcm7cwJWyQ71yRcu4vc7MrOPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRyhD+tmyDxFMO1BtvSMqqf5mhL7UNWBqcuEKqjCUYk=;
 b=TRKAqSnQThmR3UpXsszUKfrdlBU8nM1eI5v4/ETp3/7RLNXG0jnGZIfFwPgcKHb+rESvnbx0w4zrZZ3+M3uKD/FQfnrczinoRCKPNuEJr7kiJDwomfIHT6LBUXLH0VsIMCHqtB0ZCKN2ZnXAo/ExJLS0g6knuR0++jeXRYjoD2g=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:50:28 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:50:28 +0000
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
Subject: [PATCH v4 08/48] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH v4 08/48] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHdG1o9o4xfPVyRiEiLv1Ols+Ph4g==
Date: Fri, 24 Jul 2026 10:50:28 +0000
Message-ID: <20260724104819.1296803-9-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|AM3PEPF0000A792:EE_|PR3PR08MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b85a096-0531-4c8f-1b4c-08dee971855a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|11063799006|18002099003|22082099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 jTDH672NT1LO/DCdXdFv3gxG+zjXCyRb7Pl62ay76Vdt0eONJzVU3w7+QYP8vtc4+aHT1oXf8pjcg1/Q+Osa340jV2KeqmMcUH/Zfz0L7fOBRi+5HIRNhiRO8k1M5gHZCRg4AIG4bYmOLftfL9dORTGteqVdhdyRGdzuk06VAoAWlxC3kIMhJeqbVY8XXMazePlvPqhfQh+7TB9oyUrbJlO4D+juwmRSWJQh2LVGzrKxNUqeQrmlznWNxJeglsomYxqj5LvFy/rWeMnT0kkDBHv25rrwAS22AnC6Ka43Ev1zFkWWSzdd97elKMUeEwgZ+3HsGt8oxCy4igLuCQKgfjjDtlHUy4eZY144GJD/Uw3M8G4onEmSS3ZiVpZ1ePRr6+SNUwlezqq9FWIABub0FczyRI94cDYHUq2Ln/e+R66rYzGnvCXdvQw5bnt58qLU5AYPY+8AJFFfyL2Y9d4to8jFbwI5MG4EnTDZ+aHwNjuF1iYk4FZaqrhs8vTrW+HdiA9VxvJlTwQGrzQ1i+RWC20GfM3Z0XA8klmBswIpdlpfiRDnvAt7BcpXtTtbi9hlinemw5XV8NBPTSEB7V0/9qyLdRB2mrODMb/xW+o+zskz114RpI9hbWp4jo1pPaZNpK1RIfTXkM/fQL7Ij3USDBYblAFkyrqlGrnbFeRryHYThiRIxmjhFLO4mM42fmlaxEw7CKaWZ84BBo1/ulM7u0c0TkzScdQG8cmzWSMGo9Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 KhOmgOHipvs5cdfHxvjaKx794OjWMWjs+JG1sJbrm1rt44WfnmCeQtYUjfQdAlhUMDFAylS7ByvwQQwGJaC80w0a0uywKUsjJSKKUtEuvCd99X69XOKzxRb58Dz8pfYxlVBuFulnkEqb69mfd+XTdFfLqI6eAl3Pa1cw9oJhljBDA325Dj1jYzjlREB+yY8ImOv+nqJOUljwjdbms8uIXqoXtysiMFp+5lvIB+pICDTbLJtP2I/GeLH2iKd8TXEV7lVdEML7/AhkE7Afm8Zz09kuaCk3sIx3C/Go1cUp/gwYKhyblL3Tv1owqG2HCc8UoDXWgHk0IVSyz9H5mQDIiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A792.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	23cbbc6c-0b96-4abf-759d-08dee9716016
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|35042699022|14060799003|376014|82310400026|10067099003|11063799006|6133799003|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	D4wn5qA4Zd5dj4/5YF9hs7lz47kWGmR7OnX3Ek3v1OJa8ONOHcILw5QiJIRET6NAIxihyPq0Yo7mgj4T4aLblaQZaWr54dYEySWYcyjro7bbKvdJiEkcSoiOpamsg8xfKtCyGIzFZzpxA3HVQx72gPrfeADLaBo4MVhiWnHCznhc9PCWYlk2FxojYq04OPpYj4IJ7aIdMEF9A5de3QKHmaCe4WYR14Juot9IAaW2d3y1GHdBcz4SqPNuYaXZBQNnXveeUPYPdOFRzdkRAt0EhU7em1DVd3+AM5sgfOxC8F3zMeEGtu3eAekIuqkjbDMxxgwoMmANiBSSSSZlgEZf8zxh3HyydM9ihMGSRemhb0W/a0RkpDMi5Xeutwp3xHQ/ty32R2d5zH+WqH00thQFVIcFbAXMsYosqg6RC+M3JVp19WQltP80EZ8O4JDK3cFOo/zBx/szCBXABYbkgKrPWQNyLxUeSvxQHrBWXxdgy0FWSzpdBFepJhSJQ7fi/8ufEGKzGQXO2BfeAqAxVgFFwITmRi3pPeLVtY7WMs3d8tksaH+9fjZsAoaD2zLS4xEm0T8ctsUBvUWEulAZA8AKZwJhH8OK4e6CREAlTVFhc6y+6ZH3DI9tDaC4CHM0gHD33GRweclnfyRVlyL9L0BqSMVaEUMHO/mdFU2Jy8oSubP3DWD6pzP5u6l9xniWGr63wc7C/b1DI3mP25kvfqNH9A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(35042699022)(14060799003)(376014)(82310400026)(10067099003)(11063799006)(6133799003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	evK6j5r+InUTVjeyGtLT5xq09nzbQHo+0YcfinjmZYaq2Ic58PJqIcP1O3tT8WpZx/12aq+Vs5f8C8ebROyzmNO47oYbXoYuDOMRHQBe3Y3dihG0Eeeb2tFm4rS2MXFYBdkrBh2TMRU3K1UIVRZMzvrzFPoFSNMos34pITdWHHSWjNViXCmTDG/2O9gRctixK7b15ZwjkPaDabjTezqArYXYarDqzMlEO1bBvunOMkb8fjYIWOVeQb9Q6VCMD60eVG0d01Rz++jDefnaQc+jJ+2BSnKlP/c0b8/U3UigWAnMMkDdYOqqVX+siy77Y0OzNdng6XcrqnmSD9uu4Y4U7QawWe4GnkovsRPzmUQPrpjOKLxd7qFwUSUH/wN7Ro2/9MkxjD7WO9FPZgCWjt+mxa8vgLIagUJLbzLoipRg1ySmohcXpnh/RGYcltMM2vOk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:51:31.0013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b85a096-0531-4c8f-1b4c-08dee971855a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A792.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5676

VPE doorbells allow the GICv5 hardware to notify KVM when an SPI or LPI
can be signalled to a non-resident VPE. This provides the mechanism used
to wake blocked vcpus once the hardware determines that the interrupt is
eligible to be delivered.

Add support for a per-VM VPE doorbell irq domain. The domain is created
under the GICv5 LPI domain, with one doorbell allocated per VPE. Store
the allocated doorbell base in the VM's GICv5 state so that later
patches can request per-vcpu doorbell IRQs and use them for IRS
commands and wakeups.

Add the per-VPE doorbell state to the GICv5 CPU interface state. The
doorbell IRQ number is populated when the IRQs are requested, and the
db_fired state is used by later patches once doorbell delivery is wired
up.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  18 ++--
 arch/arm64/kvm/vgic/vgic-v5.c      | 139 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |   1 +
 include/kvm/arm_vgic.h             |   4 +
 include/linux/irqchip/arm-gic-v5.h |   2 +
 5 files changed, 158 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 907057881b26a..625d352756fcf 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -492,16 +492,22 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->nr_spis =3D 0;
 	dist->vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
-	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
 			vgic_v3_free_redist_region(kvm, rdreg);
 		INIT_LIST_HEAD(&dist->rd_regions);
-	} else {
-		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	}
=20
-	if (vgic_supports_direct_irqs(kvm))
-		vgic_v4_teardown(kvm);
+		if (vgic_supports_direct_irqs(kvm))
+			vgic_v4_teardown(kvm);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_teardown(kvm);
+		break;
+	}
=20
 	xa_destroy(&dist->lpi_xa);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 3f7b132110114..ebd7c3ede975f 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -7,6 +7,7 @@
=20
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
+#include <linux/irqdomain.h>
=20
 #include "vgic.h"
=20
@@ -152,6 +153,134 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * This set of irq_chip functions is specific for doorbells.
+ */
+static const struct irq_chip vgic_v5_db_irq_chip =3D {
+	.name =3D "GICv5-DB",
+	.irq_mask =3D irq_chip_mask_parent,
+	.irq_unmask =3D irq_chip_unmask_parent,
+	.irq_eoi =3D irq_chip_eoi_parent,
+	.irq_set_affinity =3D irq_chip_set_affinity_parent,
+	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
+	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
+		 IRQCHIP_MASK_ON_SUSPEND,
+};
+
+static void vgic_v5_irq_db_domain_free(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+
+	for (i =3D 0; i < nr_irqs; i++) {
+		struct irq_data *d =3D irq_domain_get_irq_data(domain, virq + i);
+
+		irq_set_handler(virq + i, NULL);
+		irq_domain_reset_irq_data(d);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int vgic_v5_irq_db_domain_alloc(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs,
+				       void *arg)
+{
+	const struct irq_chip *chip =3D &vgic_v5_db_irq_chip;
+	struct vgic_v5_vm *vm =3D arg;
+	struct irq_data *irqd;
+	int ret;
+
+	if (!vm) {
+		kvm_err("invalid parameter for doorbell irq allocation\n");
+		return -EINVAL;
+	}
+
+	ret =3D irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
+	if (ret)
+		return ret;
+
+	for (int i =3D 0; i < nr_irqs; i++) {
+		irq_domain_set_hwirq_and_chip(domain, virq + i, i, chip,
+					      domain->host_data);
+		irqd =3D irq_desc_get_irq_data(irq_to_desc(virq + i));
+		irqd_set_single_target(irqd);
+	}
+
+	return 0;
+}
+
+static const struct irq_domain_ops vgic_v5_irq_db_domain_ops =3D {
+	.alloc =3D vgic_v5_irq_db_domain_alloc,
+	.free =3D vgic_v5_irq_db_domain_free,
+};
+
+static int vgic_v5_create_per_vm_domain(struct kvm *kvm)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	int id =3D task_pid_nr(current);
+	int ret, db_virq =3D 0;
+
+	if (!gicv5_global_data.lpi_domain) {
+		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
+		return -ENODEV;
+	}
+
+	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);
+	if (!vm->fwnode)
+		return -ENOMEM;
+
+	/*
+	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
+	 * doorbells. We know how many doorbells we have, and therefore we
+	 * create a linear domain.
+	 */
+	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
+						 0, nr_vcpus, vm->fwnode,
+						 &vgic_v5_irq_db_domain_ops, vm);
+	if (!vm->domain) {
+		ret =3D -ENOMEM;
+		goto err;
+	}
+
+	db_virq =3D irq_domain_alloc_irqs(vm->domain, nr_vcpus, NUMA_NO_NODE, vm)=
;
+	if (db_virq <=3D 0) {
+		ret =3D db_virq;
+		goto err;
+	}
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D db_virq;
+
+	return 0;
+
+err:
+	if (db_virq > 0)
+		irq_domain_free_irqs(db_virq, nr_vcpus);
+	if (vm->domain)
+		irq_domain_remove(vm->domain);
+	if (vm->fwnode)
+		irq_domain_free_fwnode(vm->fwnode);
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D 0;
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+
+	return ret;
+}
+
+static void vgic_v5_teardown_per_vm_domain(struct vgic_v5_vm *vm)
+{
+	if (!vm->domain)
+		return;
+
+	irq_domain_remove(vm->domain);
+	irq_domain_free_fwnode(vm->fwnode);
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+}
+
 void vgic_v5_reset(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -167,10 +296,16 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
 }
=20
+void vgic_v5_teardown(struct kvm *kvm)
+{
+	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long idx;
+	int ret;
=20
 	if (vgic_initialized(kvm))
 		return 0;
@@ -182,6 +317,10 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		return ret;
+
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f45f7e3ec4d6e..f2f5fdc3211d7 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8d65a18fefb80..bff2b7c896d55 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -392,6 +392,10 @@ struct vgic_v5_vm {
 	 * convenient way to do that).
 	 */
 	DECLARE_BITMAP(vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS);
+
+	struct fwnode_handle	*fwnode;
+	struct irq_domain	*domain;
+	int			vpe_db_base;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 83cfcd056b250..21c8a69f99bb6 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -613,6 +613,8 @@ void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
 struct gicv5_vpe {
+	int			db;
+	bool			db_fired;
 	bool			resident;
 };
=20
--=20
2.34.1
