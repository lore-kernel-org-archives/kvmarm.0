Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013035.outbound.protection.outlook.com [40.107.162.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C71B4D991F;
	Wed,  8 Jul 2026 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783522654; cv=fail; b=J0AK1iR9Escck7R7Sm6Vt0SkjnJC1BzDrvzjLZXqFGsIhnfHd8YqLqEAFN4iT+wARfQEwWdOP2zLE2TfWUofY7oYJHfBzAZMbgTSgAFkxG0yCcrKEmZcBOmLUc63QySw8HXhQfsTxVLdQI8E4ozRpPYTeY+j+mXw5iCM5oryjlk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783522654; c=relaxed/simple;
	bh=MV9Z/loWj5l6w5K9/Mh/+MOdrJm+ykIRmtsVlIaqaZs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BbMdZdpgLxt+NA9ithxG2kIPlJd7ipyYwMNQAtPmG3OkYwEhM3Ufek18SkFeuMKtaZb0Nhx0aYk1TCDO0QmRY4vUdKGTQOHr7lL8L9Tvnx3XXyk7T469Efsc46pAgJk+lwjKzhscPtxvZvkX8I6DrINTc+y9Jj0ctuE10XvYstU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lay/tmt/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lay/tmt/; arc=fail smtp.client-ip=40.107.162.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lay/tmt/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lay/tmt/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=r24zQso2Gwts51q8UHt5xrSwTekwHRJ6UgtWqAcgaMPv2VPeKfUJJxMOTufZEcJVjGPzLnU+1es72+utisde8XjYKduDg4YiBCNSkf/bGyKgc+O/rSBGtznnVKK0cFMRPKWL78krpOUEhyiD5+2YJazbF0o6YxYHFnJ2dHRaPudTwKomS8MAF4O6hWL9dj852FrPJ9ORdy9Lh+caTkgOuN4eITi0TmmvJsQseD4PvFsxhxRYM9jhRhIu33TmPSY82RQKx8K3T0V45sJ0HDjuKzbDVKLqeouAKyln3vn0qDAYlkAfGP00w5vO0BFgOAyaaGHn6xkZLAivsyjIyy08lQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MV9Z/loWj5l6w5K9/Mh/+MOdrJm+ykIRmtsVlIaqaZs=;
 b=nGG02x7ukTKtKjf8E+8g2z4YuDv4vpRkQ8BGQ5F4QFnKrmghYTOHrZVqEIS475/tl3Acpoosm1MHtgrH0dg2Mt+UfPaHBnWz/j5Z2CYsc/d//PWGVJZ0VmkpXd35zn3/X3nDqSIIx1CjTdLJ22uAXLUqR0n7zE9Ko3TnK6ceE33FduN4q34MwdAkHUwzTs7Itukc4zhomnjYtigVlN0qikVpyEnp8qZ6v0y9lyKk8kBdMKxAHHnM1S0VvmNc3gE0faxkvHo836wzNoCHrIlrJLqGn/Ec3GX+80hAJ1u9wteCP0csm1s4NHXAKTnvXjJE80kX0/ZlEbs50Dr4AUhgTQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MV9Z/loWj5l6w5K9/Mh/+MOdrJm+ykIRmtsVlIaqaZs=;
 b=lay/tmt/zsPyjwC/gpCaJgzNejiIHRD9uN+KpulV6LrAfb3oAXqVHtWcVmTp55QA2aeqmfJuql87yDtE5Q4UgkCuigU9lATYwj4oEqiNQpjl0YPEfinZN4h2A2l0x2TSwoAuoOQ0gilJ0u5SiK3Z60x1w4c1DmIFGzw5zhSgAEg=
Received: from AS4P189CA0066.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::14)
 by PA4PR08MB6079.eurprd08.prod.outlook.com (2603:10a6:102:ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Wed, 8 Jul
 2026 14:57:29 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:20b:659:cafe::20) by AS4P189CA0066.outlook.office365.com
 (2603:10a6:20b:659::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Wed, 8
 Jul 2026 14:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Wed, 8 Jul 2026 14:57:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=naypv4AVPN2FydmGpMtbcudbnw2nTd6mdyaBoLshEzMvz54VjD0yhi6VNE+dW2k60y94nD8uIh9UyX4Zp3Gi2b4lnj44y0RFL/ZPay3mm0Ha++gLT1fSYj/g3k5ZQdQwm7rxPjwLX50FmZcCuMESruClLVUxCSDVT3Y8ee4YAMCwQ6/aaVYQ5wPLo+Tg2bATayB37Q6R5tpjoNbiu/uCWo6QrUg6ZZIY1MvvcCLBSZ8NARGIB796tbeOmXNL7W0g1u5erZHuASGK85UJ4By7hff4hELbaFSxELM/eHX1KG8+2Fukd6jW+cYZoqUHWRg8nL+6zJOgvitqdMHn/Faa+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MV9Z/loWj5l6w5K9/Mh/+MOdrJm+ykIRmtsVlIaqaZs=;
 b=TZzNN4az+m+cAF9zE5oZhyHC9ACxG2PBSWGCMyjclGG3t78QEpwprXuyw8TLfoat+rPGHgAbO2UiCQhYJPZvEjSqFqa7nEzDihHToagYsy77DqrlFsOm3c5okmRQAVx8dO/kLu+D2EIWyXDL9vAhxkRn9xE2Hv6hS/oVIuJJDodTSlzTBGJULwc0q3K7st0zuJ62SsA830hJlLJF11itgVgtqCe6NGecoqWnEhNLnghdzF/DGi/UQorSL8htrv9VmsHMFfqCkVhKYjzBsoFatwYVBSaxWI5pDyfS4F9K6jCGzyK5rkXGPWZu+41j5GY4p43MRn6uthIH1NOsPQDBVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MV9Z/loWj5l6w5K9/Mh/+MOdrJm+ykIRmtsVlIaqaZs=;
 b=lay/tmt/zsPyjwC/gpCaJgzNejiIHRD9uN+KpulV6LrAfb3oAXqVHtWcVmTp55QA2aeqmfJuql87yDtE5Q4UgkCuigU9lATYwj4oEqiNQpjl0YPEfinZN4h2A2l0x2TSwoAuoOQ0gilJ0u5SiK3Z60x1w4c1DmIFGzw5zhSgAEg=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by FRZPR08MB10926.eurprd08.prod.outlook.com (2603:10a6:d10:13d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 8 Jul 2026
 14:56:26 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 14:56:26 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 14/40] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Topic: [PATCH v3 14/40] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHdCwStHIcIR9elq0qvIufBD8MIy7Zb+66AgAfCLYA=
Date: Wed, 8 Jul 2026 14:56:26 +0000
Message-ID: <83bfe680be3dd3fe6199790de0fea09e02638932.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-15-sascha.bischoff@arm.com>
	 <20260703162738.4DA701F000E9@smtp.kernel.org>
In-Reply-To: <20260703162738.4DA701F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|FRZPR08MB10926:EE_|AM1PEPF000252DE:EE_|PA4PR08MB6079:EE_
X-MS-Office365-Filtering-Correlation-Id: ece00e14-7671-49f1-1676-08dedd013b16
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|11063799006|38070700021|22082099003|6133799003|18002099003|5023799004|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 S4NKy+3hqPUKuU+LPGG6cmj3fCAt3m7ETg7y0A9YNwaF7CePW40b4gyF2QU2XJPQ2oTvjLzG+9dW+pup7HoL5iuS8CZBx+nYQwiLspPNiI76dvW4F1tS9mX3dDZRYw0wkdCZQyuCmFbARcJbtgjNcg9KSuY89TUtHBlNrXredaRsF93uZVrryqZZUrvAx74pItEbSFHMhf3F2yJk06eqv0c7yM9q3BOathBU7nfRA429PShczGfAoh8fSmur53iBRER2IoUDU6vjrzzvwU0Cyzk/ET/TWby1710i2S6sCPam/hW61fR27ZfrNlnXRJfYd4dRBNWGIwk8ITjUImdhLOZ49aaBiKCFGioEmV8cm9qg7oqXuHPbyg2dvSMiyNIRZAYs6nnC0BsUuJZwEQ1Moc55Ty9Jg4Y8rce/78pHdAPUqSrnY1rId9MXV3DhiBJyxWMQ6NEI0qOcwEWd6WTnVlXfdLiORv72dE8WtoodMXNm5oGhBNOxGh4N3lRqILItcm3Y0jdZuHD0DDjwHy/8pn3GeOJiln/l0Zxvzgql1kxNaMSQq2+Fd3mFQQeiFii/T0fx9st+kNmokZegdmKM0ffjDZPKiWgqTDPBSS21taUqxdcoqoWrZQFCOBmu9EEF84l1gvfSeSU6OsTp69gASRBlyIMgvNW9EOr8wCwCF5qb35iWlmLB7NgnMAQdqCZOs1OL6PsZz1B4uCM7kmh0AS0ddyG0V9TFx9cjR+UK22E=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(11063799006)(38070700021)(22082099003)(6133799003)(18002099003)(5023799004)(4143699003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <EACB71F8B4C78C49A047081225D28D2C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 EqCcESvyvA02LrBuAlYNNA9/4X1/Heuw6+8ft7+qycgUDoIyNX7Uw/bWBANOLgxj+6OFVxOCBhD9oIsaYfaKUTDppKxB0UGKV++RZ5rekn6vLJU7oGKY33GWu0UieBInIH2IwAZLZik4Q8Taj+3ezwyjJgcZfH+yTMTvN7B8q6deCsl1bufAeuibgK7jutMZo6SaJS9Hl9IiCDnPWE62h1gHKU0rrvp0cbP1FDygrQE+qHO38dmUTIz+fwF1FYnkEqFhm8Akn7h1Mo8uaJFoovQYsPMGctlwgMhL1BH0jiy0FuTQ021r+cFu8DSgwzr7skmtGsgFgf2ZMEb9eyg2Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB10926
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0e679b6c-fcbf-438d-7d24-08dedd0115e0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|376014|36860700016|23010399003|1800799024|4143699003|56012099006|11063799006|5023799004|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qFbPZB4B3h3hyI6brunjIui8OEHsNSLghwA2uqOmzj89VGeldXIS5bYPn+qa68k4iv9/EIQD0cMIrFirAwVVaXeNqJUVr51GwupXBDyXcGTZg897eJrwNdMS05XAKMKIDD9L484sSLt4yvX1q81yyAYHSGgpwRWZ6GWVbfvlSbCnpA4UhcTnh4USTW2YecXR8YDTGfLhF/7rHLJjgJpBRKYs8MFou3v701FVGNgafA/4y2/HV+Pd/ryvyA55UzKEK66N7vlUGURFCNAg5Zm4PAqdfTDIisZZNQV5ZPBrKJs6Qwsl/aCOsTX+n6iKZVXIPD8EH2UwJhJqBF6aUFbI7456EwFY5Ghnwab2uoNS1SR5f5onuSH4eFuW2eTMg4b/6rFIZ85P50fb4c1q+dmq4tVKG2+YWINCZgdvXe56xU61erREq+x82PBrrLpnLhLqmQ2zmKh0Dz5UMusb89++KJ41TZMLei7HwkBldX+Dh9ogRAsO9CIcBq9UZ+f78bV3pKnkWXKsdP2Nes8J0f9ouvj7TWgdw7CXLtOw0h4gE6hvopVFYcQn1dOmDU6el5YbNww/sxUEGttn2uq9+1IebdkzXxf9t12aOY/+4POoOIMu0bZnYEFXn0ZUzu0r/Dy/YKuocPOUaGaP4ep02ANyFcxEN9SJHO0x45Kbg85dS3R3aAW695tRkNhsdk3dQZ8E2/D1TzGDrqWK9m8/JhQ4aQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(376014)(36860700016)(23010399003)(1800799024)(4143699003)(56012099006)(11063799006)(5023799004)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mIhOLiixI4BJxd4CmHkvk7995TGBLlOYX789UEgGtflYfzWatgvh3/tBaQmxTXjUciMWp3Ow9LTpazweGthArRmP+98wkqt6JihbPdUb628DnmzVtRJbNfxWqNl346lPuCrWBBQk1ylJEJyJHpndLgoLLTzlosSywhbkpQFUGB2gYZ4CCVvWJu9fkgcY9sTWd22JA7/W7v35vtm8ZcW7szXtEAQRH3LXyR+1LlcU8pKFzCHASPUMx6nluzI95+f6eU+zgHGg8W10EX0VU+uUsLJjcmdzFwo1IDrXqm8lZEWvMGOjgTi9o338IgOQT6lGEQEw9MDl6aX6gg3Xdkby7LyLKafep1CDTLzXjK5qgVNjn5B+NrJ1dfpqj9s85K4QkbnL6cSQW48x5WieIi+WYDXco603MznyNvYayBPRa16YkPGk7skXa7+bgO80bllN
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 14:57:28.8259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ece00e14-7671-49f1-1676-08dedd013b16
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6079

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjI3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gRWFybHkgcmV0dXJucyBpbiBgdmdpY192NV90ZWFyZG93bigpYCBvbiBoYXJkd2FyZSBjb21t
YW5kDQo+IGZhaWx1cmUgc2tpcCBzb2Z0d2FyZSBjbGVhbnVwLCBsZWFraW5nIGRvb3JiZWxsIElS
UXMgYW5kIGNhdXNpbmcgYQ0KPiBVc2UtQWZ0ZXItRnJlZSBvZiBWQ1BVIHN0cnVjdHVyZXMuDQo+
IC0tDQo+IA0KPiBjb21taXQgMGU3Y2MyY2M4Mzk3NTEyNzU4OWM2ZGJjZWI5NzdlOWYxYmQ4Mzdh
Mg0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+
IA0KPiBLVk06IGFybTY0OiBnaWMtdjU6IFNldCB1cCBWTVRFcyBhbmQgVlBFIGRvb3JiZWxscw0K
PiANCj4gVGhpcyBjb21taXQgaW50cm9kdWNlcyB0aGUgaW5pdGlhbGl6YXRpb24gYW5kIHRlYXJk
b3duIHBhdGhzIGZvcg0KPiBHSUN2NSBWTSBUYWJsZQ0KPiBFbnRyaWVzIGFuZCBWUEUgZG9vcmJl
bGxzLiBJdCBhbGxvY2F0ZXMgYSBWTSBJRCwgY29uZmlndXJlcyBhIHBlci1WTQ0KPiBkb29yYmVs
bA0KPiBJUlEgZG9tYWluLCBhbmQgY3JlYXRlcyBoYW5kbGVycyBmb3IgbWFuYWdpbmcgZG9vcmJl
bGwgaW50ZXJydXB0cyBwZXINCj4gVkNQVS4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUu
Yw0KPiA+IGluZGV4IDZkN2Q5ZTZlZDlkYmYuLmYxY2MzNjY5NjY2OWQgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjUuYw0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArdm9pZCB2Z2ljX3Y1X3Rl
YXJkb3duKHN0cnVjdCBrdm0gKmt2bSkNCj4gPiArew0KPiA+ICsJc3RydWN0IHZnaWNfZGlzdCAq
ZGlzdCA9ICZrdm0tPmFyY2gudmdpYzsNCj4gPiArCXN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgKnZj
cHUwOw0KPiA+ICsJdW5zaWduZWQgbG9uZyBpOw0KPiA+ICsJaW50IHJjOw0KPiA+ICsNCj4gPiAr
CS8qDQo+ID4gKwkgKiBJZiB0aGUgVk0ncyBJRCBpc24ndCB2YWxpZCwgdGhlbiB3ZSBlaXRoZXIg
ZmFpbGVkIGluaXQNCj4gPiB2ZXJ5IGVhcmx5IG9yDQo+ID4gKwkgKiB3ZSd2ZSBiZWVuIGNhbGxl
ZCBhIHNlY29uZCB0aW1lLiBOb3RoaW5nIHRvIGRvIGhlcmUgaW4NCj4gPiBlaXRoZXIgY2FzZS4N
Cj4gPiArCSAqLw0KPiA+ICsJaWYgKGt2bS0+YXJjaC52Z2ljLmdpY3Y1X3ZtLnZtX2lkID09IFZH
SUNfVjVfVk1fSURfSU5WQUwpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCWlmIChrdm0t
PmFyY2gudmdpYy5naWN2NV92bS52bXRlX2FsbG9jYXRlZCkgew0KPiA+ICsJCS8qIE1ha2UgdGhl
IFZNIGludmFsaWTCoCAqLw0KPiA+ICsJCXZjcHUwID0ga3ZtX2dldF92Y3B1KGt2bSwgMCk7DQo+
ID4gKwkJcmMgPSB2Z2ljX3Y1X3NlbmRfY29tbWFuZCh2Y3B1MCwNCj4gPiBWTVRFX01BS0VfSU5W
QUxJRCk7DQo+ID4gKwkJaWYgKHJjKSB7DQo+ID4gKwkJCWt2bV9lcnIoImNvdWxkIG5vdCBtYWtl
IFZNVEUgaW52YWxpZFxuIik7DQo+ID4gKwkJCXJldHVybjsNCj4gDQo+IFtTZXZlcml0eTogSGln
aF0NCj4gSWYgdGhlIGhhcmR3YXJlIGNvbW1hbmQgZmFpbHMsIHRoaXMgZWFybHkgcmV0dXJuIHNr
aXBzIHRoZSByZXN0IG9mDQo+IHRoZQ0KPiBzb2Z0d2FyZSBjbGVhbnVwIGluY2x1ZGluZyB2Z2lj
X3Y1X2ZyZWVfZG9vcmJlbGxzKCkuIFRoZSBzYW1lIGFwcGxpZXMNCj4gdG8gdGhlDQo+IGVhcmx5
IHJldHVybiBiZWxvdyBpZiB2Z2ljX3Y1X3ZtdGVfcmVsZWFzZSgpIGZhaWxzLg0KPiANCj4gSWYg
dGhpcyBoYXBwZW5zIGR1cmluZyBWTSBkZXN0cnVjdGlvbiwgdGhlIFZDUFUgc3RydWN0dXJlcyB3
aWxsDQo+IGV2ZW50dWFsbHkNCj4gYmUgZnJlZWQuIFNpbmNlIHRoZSBkb29yYmVsbCBJUlFzIGFy
ZSBsZWZ0IGFjdGl2ZSBhbmQgcmVnaXN0ZXJlZCB3aXRoDQo+IHRoZQ0KPiBWQ1BVIHBvaW50ZXJz
LCBjb3VsZCBhIHN1YnNlcXVlbnQgaGFyZHdhcmUgZG9vcmJlbGwgSVJRIGZpcmUgYW5kDQo+IGNh
dXNlDQo+IGRiX2hhbmRsZXIoKSB0byB3cml0ZSB0byB0aGUgZnJlZWQgVkNQVSBwb2ludGVyLCBs
ZWFkaW5nIHRvIGENCj4gdXNlLWFmdGVyLWZyZWU/DQo+IA0KPiBJcyBpdCBwb3NzaWJsZSB0byBj
b250aW51ZSB0ZWFyaW5nIGRvd24gdGhlIHNvZnR3YXJlIHJlc291cmNlcyAobGlrZQ0KPiBmcmVl
aW5nIHRoZSBkb29yYmVsbHMpIGV2ZW4gaWYgdGhlIGhhcmR3YXJlIGludmFsaWRhdGlvbiBvciBy
ZWxlYXNlDQo+IGZhaWxzPw0KDQpSaWdodCwgdGhhdCdzIGFjdHVhbGx5IGEgZ29vZCBwb2ludC4g
SSd2ZSByZXdvcmtlZCB0aGlzIHRvIGFsd2F5cyBmcmVlDQp0aGUgZG9vcmJlbGxzLCBldmVuIGlm
IG90aGVyIGJpdHMgb2YgdGhlIHRlYXJkb3duIGZhaWwuDQoNCkkgaG9wZSB0aGF0IHdlJ3JlIG5l
dmVyIGdvaW5nIHRvIGJlIGluIHRoaXMgc2l0dWF0aW9uIGFzIGl0IGltcGxpZXMNCmJyb2tlbiBo
YXJkd2FyZSwgYnV0IGl0IGlzIGFsd2F5cyBiZXR0ZXIgdG8gbm90IGxlYXZlIGRhbmdsaW5nIHBv
aW50ZXJzDQphcm91bmQuDQoNCj4gDQo+ID4gKwkJfQ0KPiA+ICsNCj4gPiArCQlrdm1fZm9yX2Vh
Y2hfdmNwdShpLCB2Y3B1LCBrdm0pIHsNCj4gPiArCQkJaWYgKHZnaWNfdjVfdm10ZV9mcmVlX3Zw
ZSh2Y3B1KSkNCj4gPiArCQkJCWt2bV9lcnIoIkZhaWxlZCB0byBmcmVlIFZQRVxuIik7DQo+ID4g
KwkJfQ0KPiA+ICsNCj4gPiArCQlpZiAodmdpY192NV92bXRlX3JlbGVhc2Uoa3ZtKSkgew0KPiA+
ICsJCQlrdm1fZXJyKCJGYWlsZWQgdG8gcmVsZWFzZSBWTSAweCV4XG4iLA0KPiA+IGRpc3QtPmdp
Y3Y1X3ZtLnZtX2lkKTsNCj4gPiArCQkJcmV0dXJuOw0KPiA+ICsJCX0NCj4gPiArCX0NCj4gPiAr
DQo+ID4gKwl2Z2ljX3Y1X2ZyZWVfZG9vcmJlbGxzKGt2bSwgYXRvbWljX3JlYWQoJmt2bS0NCj4g
PiA+b25saW5lX3ZjcHVzKSk7DQo+IA0KDQpUaGFua3MsDQpTYXNjaGENCg==
