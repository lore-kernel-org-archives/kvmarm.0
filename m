Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011006.outbound.protection.outlook.com [52.101.70.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51654429013
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890887; cv=fail; b=ZcOldP6TvJ0UKQu4MKzUCOjZj/5GqIVKbnDgVl+47YmmxjF7sEylOvnA9fr1oPF4wdAjY7GIQMnQsrpXndFfjRqjqzFMncIEbXZw5KrM9PlKtw0kRx6s61+AlRsgNb95D2LbAJ1eI8klLuggal7GYsUAJQqARfY1OKhJeatPXZs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890887; c=relaxed/simple;
	bh=pbwP1ssCyrmd17L6Ro97/dBaEV5tzYzd0Ep4bmVU034=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DDSMSIKkOSur2PgrnFNCfC09VdBQj8IQTlDeFSo9e+6f10Qndw7HO6hFTnkiAySM8Ii1xb59ml8fgVES5lwN0N/ovnSlhHMnorCDhJ8SUwshicoKbevdgIWEkOWTMqz8EwrKQ6s7uPZsXCQyHZyFOXzOMTtFwMKzgkpj51M/KJ0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OFE6IABL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OFE6IABL; arc=fail smtp.client-ip=52.101.70.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OFE6IABL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OFE6IABL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dn/TSOwOcj/Q/MMZGKDB52o3bcsjT+gx7Y+kfGiyPt+6CRrQQ2M7HkstI0cgP/jtX4+aIaMpRNNyFh6Eo7LifdC/q4l/chNBy4cf08C+wUTZz5kai2PmE/WdRV8JtCQZaVBr4ioNelaDnf8BpbgdPyIB8/RzRal2j+yaVNpKwNrO0amHiWOUIxyixOJDmdyl++NQy4MauQ88m+nE09Ob5RZ44z4cxueKKC+sJVYS2CxQgA2ggBEY4gVDvMOWAU/xPY4mVo94dmCWnq+Eas61wmtZVN5EijSu/64simqlDiif9zh/5+Ulb4YTMeEzEetc2niHaSKVpeD1m+jjYVPLJA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7YmpKA07Xg7uHHEKfJR82mT0EzZC90lhXebZODJ8sw=;
 b=X2Y0ZhXiq0dWdBgWQ5MXQgX+kMM2H1n+O4NvYzim6KA/WAzf+YCXVTdioMNuc61C8Fd+bock7UfSWaItS0K1WHFvT7Hd/Uq07hZxqsHo7wArTswdOhmN36KyphWuXLROYFZl5Zqf1jIJoqnmluZJ5aBjHxn6bonzpawPG83gmcbwCMxo7dcGuCVXFhB6jTWXMpwPO5QgKebAKLh8NwTo0Glg0tA/F2w78yK9zWHYNp9Ok6DVxj6jR5nL4TiMFsSfn9DAWYn/IMeGi8Ab6GJlmZkZXmSlfIU0bTFYoycHahpjM38q/kKmGcsb1gqVR6F6whel3BVxZUfkyrEyhNF9BQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7YmpKA07Xg7uHHEKfJR82mT0EzZC90lhXebZODJ8sw=;
 b=OFE6IABLy72e5RuLY9ynGQqyBImXA36q04PtlwI7+8A7Wo8+bPMr+6kUI5RNwOggkCSCiUoO4WMslYYRioYdrrKHQ6PxpmrgWvZqqHTU49q/zGQPprpPfHv5xAZVAG/gs4eGX630/If+8/mw5EMKQE8cLUGGViP4FDZlGWHqgdk=
Received: from DUZPR01CA0034.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::10) by DB3PR08MB8915.eurprd08.prod.outlook.com
 (2603:10a6:10:43d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:01:19 +0000
Received: from DB1PEPF000509F4.eurprd02.prod.outlook.com
 (2603:10a6:10:468:cafe::4e) by DUZPR01CA0034.outlook.office365.com
 (2603:10a6:10:468::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:01:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F4.mail.protection.outlook.com (10.167.242.150) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:01:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r5mwiEep7ytH2RknoeIDuIjfUre+NZaLWZ/yguj5vIrYW/isn8VPSElSh/I3QNXJcYH2B5DZsAYjjjpP08PKapszlw87kbYmDpH0v9MuU31s3f/M1LKPr1N71H+4gscui85ioZKtQrG/1SqQANRgJajcvcRqaIlxXu0ssV6Bu6nAabvKq6+HLNVPW+s+0RNXAg8c275ntttc9f7XqK0x/mQYJCg6bFsXCOgp2TfHs7fqH2RyKe8WpYzbd7S60rulVq1npb4/EvDkkOBLHeuCg7C/gKRpkrJ0nUzh/f5tEtqX7gOuZzpJDxpIpYB/dNGh/ofzx6nv/KRbz0snG4Krmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7YmpKA07Xg7uHHEKfJR82mT0EzZC90lhXebZODJ8sw=;
 b=xjhhhWElv3YezNmQUbRCavQ7Iohcp5O99vKRGLEjS2v6m4t5VBua0ldaaOZfvtjUHqRHNUfEHJDcU5TUZD1TelRMp5+/ZNgpw23lu/LLMhQn+a52cJIVAv4LD2CngKKmb8MvBV/4Xg9UGP+TcUwb5kR1dEmgDd9xDyOZ5tcAV4FABl6sK2DoQyddE5yqdukKvCZa2FsQ1ERX1cj3u64U0fPJi93vj5T8B2ZHDS1fifpBZCvDMN13nQEwD0obe9GpxDlEv7hTyEHcBnNTJ9Tyh+Zpg1TpkvsJ6LIld62Odpmfa7JIsJNeufLOl3U2VQmcP8XOBkfYaARACP7NV0MIjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7YmpKA07Xg7uHHEKfJR82mT0EzZC90lhXebZODJ8sw=;
 b=OFE6IABLy72e5RuLY9ynGQqyBImXA36q04PtlwI7+8A7Wo8+bPMr+6kUI5RNwOggkCSCiUoO4WMslYYRioYdrrKHQ6PxpmrgWvZqqHTU49q/zGQPprpPfHv5xAZVAG/gs4eGX630/If+8/mw5EMKQE8cLUGGViP4FDZlGWHqgdk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM8PR08MB5571.eurprd08.prod.outlook.com (2603:10a6:20b:1d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:00:16 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 11:00:16 +0000
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
Subject: [PATCH v4 46/48] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Topic: [PATCH v4 46/48] KVM: selftests: Add VGICv5 SPI injection tests
Thread-Index: AQHdG1uc6R7Gov/4FkmMzX4dR4IH+Q==
Date: Fri, 24 Jul 2026 11:00:16 +0000
Message-ID: <20260724104819.1296803-47-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|AM8PR08MB5571:EE_|DB1PEPF000509F4:EE_|DB3PR08MB8915:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f7c57a4-b823-4daa-4139-08dee972e40f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|11063799006|6133799003|56012099006|18002099003|22082099003|10067099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 wVIwTQOirjlU2P5fP6+9w4GfdQtn63PURbWXXqTwfhktGnNXld7IKj9n6Fee78pxfyk0aCLrVigEay7KMcZkuNBtAkFR9+6fcQvPKEGXPbPMOkwb0bK7at/2OjAG5oi4bfY+Kdff0iB5U66bxSfDFehnAcMlq52TWDCTnlf7xh9b7nSvDYGkcljxq7eoPh9Wop0QruKR/2PoUHnctrg3tEbQEYaGdOULyvyv+Qjy2v70hDvSaPIOSrbrwsm8pdirpzLOVeHzGWBlapdnR7ValdtcrjRMIeFcO2j581dujKPbjSzR2tEQ6fePucwawNY+wL3Zt3rgBa6+2xCcusTY7DfhiwpMO11i6ocv+tc/SOiSr7Pd660mQVVIRRrY0wnssjdgbizpMNCntatLHES1ZKayCk+Z/9twsx3ouB3UVxv9PGfvqsqWP1dM+cC0WkV5rIuSjbqMC1HWt5KzmN7irSc/Ml1RDSXc0tDKEMwPGfg29bldQyN0EClc6VHmqps+v/HPgas20sbYlkbmGK9As++mnYyn9zQQ/a+94YBuEfQOlxSdy5rJgf53Ej+RnPA5lu58RmBncHW5P1ylO5T8HSEaimlZI4feAApAm4Tw1F4gffDtkeqKtR438JhI6gxu5B61baSIxy4WfSdxv/MOJW8lQ1Im7eHNEfj4SvDDifzo5d/7PZ9A3o9A2DgEm+6gEVIlD9aUiJFd7yew7c2hoX+mXYHiKlEvvM+C1lhdkjc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003)(10067099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 FzdWlxn37aGHFyikC1XaIwj4TsfjRO9poXOgQmMAg46MgVAaTy7deFuZg9XtSTkUz8CRfjlp+l5vtcUCX7IjTMkURqQz8alkGO7rJLN0gLsZXCjCEFpMegfxdVA6skydeu78PuViNzCd07C39JmR9LypjiIN3mjF4rpi2/6+bjLXlL091CmZ3ZzcuU1N4dTH9/DrnlEYsl5Zp5GxJMdmK6SDecJ+7AS3DT53r0kg5b6p+qh9R0P9XZ7Vsc/Tw/Xo074CSbvcHJDJ7srq+j6g0H1qJ5qwWv9zyVrmEdsrkWUX+LtHxoxZ3+TjdTlTw4lULdnRDS1om5XBxY1YrGoKAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5571
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7b18dec3-c488-4cb9-9c3b-08dee972be84
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|14060799003|82310400026|376014|35042699022|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0XvJYScgl1H5lmIqutyBvR3egLeMwbP10kcwzRIM6XUmDTZ7USz9KWJJRm7COJRLsScwws+f/ALD9iDoITHav1sZ2vpIj96e49hSC5UCz2irY64Y0b/x2FHX7qtF3muMxrmuCBURWSHYMDZK+j4Pa3zfmVXg11MaP7VrWeUbqc11RpVOXCm9imrrizx6SbOwjO7WN/TvW45fPIidbiPSIxoN36QIuQLjybyUfXooPiHReiPLkiYjZFRpaqDa1K6qbi7Hr+ikpZ+SV4agpTQg6gvAkMcakvIZsI34rTWXk+OnzH94wmhkD7HeGe6rfHeQRYeSVckGDTfnVjhOQnoHwEXO1g6QEqXn02ns0QjqFGkICp5PvvZRY1eTBklTnMbrBMnStSzM8r30hpAV3di7O/s2wQtf9h9uQkCcxqDzHHcC4LT/jamsRhx7rZzBMsrXWL5ZFtRkygrMq74/H91leCl/X5c3BCnf7/YO0qrqToqeJ1Allv3dhtkyag2iJUmsSWKQtVThJyeyfmo19xumxtkJrZNu+HU4lR7CcjyT+zJBVOkOHaepGYkZQFO+zlZy3S0PA9cuYC+SJWAo+vOPke9in+HlVCuUqsvuTtPNMGF2BtipBj24psWCKb9WppzwvDfqcHahaufNDorbbmoQ8DcRlUUfOVuQIIngXKKzcuaN+4/NLax5Zyp3ThnU0e7BMMg1GFneSfpZ0myqUS+iRg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(14060799003)(82310400026)(376014)(35042699022)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kSpZadKZIx2FAZskfMzuITMkBrbP6rfZYRIh4h/cLjH02UuJIynogsRU1/vuoLjINn07we17JuZrC3hwMLzQlEl6vNou8esfWHJYo3eveN+f4sOfArx4psPcodxo9XM9lVh1FHfELptGm9z5nF0m4ofgkm94zsBRG7KTGexQDIvC6M1fI5kFJEULrJF7EsYZBjESsp/8YOJbHXWF5lQ8wAySaSjWx1X6Whp2P/lgI+OHXUzVT77+eLrkKxWvgCY0N4m9Oa/heaRtdLR+FpawBLyspIFuRMkTHxLvcBfGdylJqmD+MRxKNtmRAiJ3lTnejMQh9LZcPfSnYNUJTvGGCoeJhwbpmGv0oZdWXt8dis4XFHdsfA6LMfBlUkX1uO5+iLJ0aO2aTWtUlpOJW/UJED/5Or+6SJEcSaCVQIF7XcmoVMvrglOHMs12NokGKG63
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:01:19.3720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7c57a4-b823-4daa-4139-08dee972e40f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8915

Add VGICv5 SPI delivery coverage through KVM_IRQ_LINE. SPIs are
configured through the virtual IRS and delivered through the GICv5 CPU
interface, so the test needs to exercise both the userspace injection
path and the guest-side IRS programming path.

Map the virtual IRS into the guest, enable the IRS, configure SPI
trigger mode and target VPE from the guest, and check delivery of a
default SPI and the last SPI in a larger configured range. Also verify
that invalid SPI numbers are rejected, that lowering an edge-triggered
SPI after it is pending does not recall it, and that level-sensitive
SPIs are delivered.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 259 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  11 +
 2 files changed, 265 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 22ae726b17be8..cec994a77c993 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -16,6 +16,9 @@
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(16)
+#define VGIC_V5_TEST_NR_SPIS		64
+#define VGIC_V5_IRS_SIZE		0x20000
+#define VGIC_V5_IRS_WAIT_RETRIES	1000000
=20
 static u64 max_phys_size;
=20
@@ -41,7 +44,71 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi=
_ist, size_t spi_size,
 	};
 }
=20
-static void guest_irq_handler(struct ex_regs *regs)
+static u32 spi_line_expected;
+static bool spi_line_level_sensitive;
+
+static u64 gicv5_spi_hwirq(u32 spi)
+{
+	return FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI) |
+	       FIELD_PREP(GICV5_HWIRQ_ID, spi);
+}
+
+static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 target_vpe)
+{
+	u64 val;
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDPRI_PRIORITY_MASK,
+				 GICV5_IRQ_DEFAULT_PRI);
+	gic_insn(val, CDPRI);
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDAFF_IAFFID_MASK, target_vpe);
+	gic_insn(val, CDAFF);
+
+	gic_insn(hwirq, CDEN);
+}
+
+static void gicv5_enable_spi(u32 spi, u32 target_vpe)
+{
+	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
+}
+
+static void gicv5_wait_for_irs_idle(u32 reg, u32 idle)
+{
+	int i;
+
+	for (i =3D 0; i < VGIC_V5_IRS_WAIT_RETRIES; i++) {
+		if (readl(GICV5_IRS_CONFIG_BASE_GVA + reg) & idle)
+			return;
+
+		cpu_relax();
+	}
+
+	GUEST_FAIL("IRS operation did not become idle");
+}
+
+static void gicv5_configure_spi(u32 spi, bool level)
+{
+	u32 val;
+
+	val =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, spi);
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_SPI_SELR);
+	gicv5_wait_for_irs_idle(GICV5_IRS_SPI_STATUSR,
+				GICV5_IRS_SPI_STATUSR_IDLE);
+
+	val =3D level ? GICV5_IRS_SPI_CFGR_TM : 0;
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_SPI_CFGR);
+	gicv5_wait_for_irs_idle(GICV5_IRS_SPI_STATUSR,
+				GICV5_IRS_SPI_STATUSR_IDLE);
+}
+
+static void gicv5_enable_irs(void)
+{
+	writel(GICV5_IRS_CR0_IRSEN,
+	       GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_CR0);
+	gicv5_wait_for_irs_idle(GICV5_IRS_CR0, GICV5_IRS_CR0_IDLE);
+}
+
+static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
 	u32 hwirq;
@@ -97,6 +164,49 @@ static void guest_code(void)
 	while (1);
 }
=20
+static void guest_spi_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	GUEST_ASSERT_EQ(hwirq, gicv5_spi_hwirq(READ_ONCE(spi_line_expected)));
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_DONE();
+}
+
+static void guest_spi_line_code(void)
+{
+	local_irq_disable();
+
+	gicv5_enable_irs();
+	gicv5_cpu_enable_interrupts();
+	gicv5_configure_spi(READ_ONCE(spi_line_expected),
+			    READ_ONCE(spi_line_level_sensitive));
+	gicv5_enable_spi(READ_ONCE(spi_line_expected), 0);
+
+	local_irq_enable();
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -109,6 +219,17 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
=20
+static void vgic_v5_map_irs(struct kvm_vm *vm)
+{
+	unsigned int nr_irs_pages;
+
+	nr_irs_pages =3D vm_calc_num_guest_pages(vm->mode, VGIC_V5_IRS_SIZE);
+
+	/* Map the IRS at VA =3D=3D IPA so guest MMIO writes hit the IRS IODEV. *=
/
+	virt_map(vm, GICV5_IRS_CONFIG_BASE_GPA,
+		 GICV5_IRS_CONFIG_BASE_GPA, nr_irs_pages);
+}
+
 static u32 vgic_v5_irq_line_payload(u32 type, u32 num)
 {
 	return (type << KVM_ARM_IRQ_TYPE_SHIFT) |
@@ -120,6 +241,93 @@ static int __vgic_v5_irq_line(struct kvm_vm *vm, u32 t=
ype, u32 num, int level)
 	return _kvm_irq_line(vm, vgic_v5_irq_line_payload(type, num), level);
 }
=20
+static void vgic_v5_spi_line(struct kvm_vm *vm, u32 spi, int level)
+{
+	int ret =3D __vgic_v5_irq_line(vm, KVM_ARM_IRQ_TYPE_SPI, spi, level);
+
+	TEST_ASSERT(!ret, "KVM_IRQ_LINE failed for SPI %u level %d",
+		    spi, level);
+}
+
+static void vgic_v5_spi_line_vm_create(struct vm_gic *v,
+				       struct kvm_vcpu **vcpu,
+				       u32 nr_spis)
+{
+	u64 attr;
+
+	v->gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v->vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
+	*vcpu =3D vm_vcpu_add(v->vm, 0, guest_spi_line_code);
+	TEST_ASSERT(*vcpu, "Failed to create vCPU");
+
+	vm_init_descriptor_tables(v->vm);
+	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
+				     guest_spi_irq_handler);
+	vcpu_init_descriptor_tables(*vcpu);
+
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0,
+			    &nr_spis);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v->vm);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+}
+
+static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
+				      bool level_sensitive,
+				      bool lower_before_run)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	struct ucall uc;
+	int ret;
+
+	spi_line_expected =3D expected_spi;
+	spi_line_level_sensitive =3D level_sensitive;
+
+	vgic_v5_spi_line_vm_create(&v, &vcpu, nr_spis);
+
+	sync_global_to_guest(v.vm, spi_line_expected);
+	sync_global_to_guest(v.vm, spi_line_level_sensitive);
+
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IRQ_LINE VM");
+	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 IRQ_LINE guest did not become ready");
+
+	vgic_v5_spi_line(v.vm, expected_spi, 1);
+	/*
+	 * For edge-triggered SPIs, a following low transition must be ignored:
+	 * once the edge has made the SPI pending, it cannot be recalled. This
+	 * allows us to test that.
+	 */
+	if (lower_before_run)
+		vgic_v5_spi_line(v.vm, expected_spi, 0);
+
+	while (1) {
+		ret =3D run_vcpu(vcpu);
+		TEST_ASSERT(!ret, "Failed to run GICv5 IRQ_LINE VM");
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	vm_gic_destroy(&v);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -854,7 +1062,8 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
=20
 	vm_init_descriptor_tables(v.vm);
-	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT,
+				     guest_ppi_irq_handler);
=20
 	for (i =3D 0; i < NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
@@ -910,9 +1119,9 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
=20
 				kvm_irq_line(v.vm, irq, level);
 			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
-				pr_info("Guest skipping WFI due to pending IRQ\n");
+				pr_debug("Guest skipping WFI due to pending IRQ\n");
 			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
-				pr_info("Guest acknowledged IRQ\n");
+				pr_debug("Guest acknowledged IRQ\n");
 			}
=20
 			continue;
@@ -932,6 +1141,44 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_spis(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	int ret;
+
+	/* Default NR_IRQS exposes 32 SPIs, numbered 0..31 in KVM_IRQ_LINE. */
+	vgic_v5_spi_line_vm_create(&v, &vcpu, VGIC_V5_DEFAULT_NR_SPIS);
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_SPI,
+				 VGIC_V5_DEFAULT_NR_SPIS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted first invalid SPI=
");
+
+	vm_gic_destroy(&v);
+
+	/* Basic SPI injection through KVM_IRQ_LINE. */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 0, false, false);
+
+	/* The last valid SPI for a configured NR_IRQS is injectable. */
+	vgic_v5_run_spi_line_test(VGIC_V5_TEST_NR_SPIS,
+				  VGIC_V5_TEST_NR_SPIS - 1, false, false);
+
+	vgic_v5_spi_line_vm_create(&v, &vcpu, VGIC_V5_TEST_NR_SPIS);
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_SPI,
+				 VGIC_V5_TEST_NR_SPIS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted configured invali=
d SPI");
+	vm_gic_destroy(&v);
+
+	/*
+	 * Edge SPIs remain pending after the line is lowered.  The low
+	 * transition is injected before the guest runs and must be ignored:
+	 * once an edge interrupt is pending, lowering the line cannot recall it.
+	 */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 1, false, true);
+
+	/* Level SPIs can be raised and delivered through KVM_IRQ_LINE. */
+	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 2, true, false);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -981,9 +1228,11 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 CPU sysreg attrs\n");
 	test_vgic_v5_cpu_sysreg_attrs();
=20
-
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
+
+	pr_info("Test VGICv5 SPIs\n");
+	test_vgic_v5_spis();
 }
=20
 int main(int ac, char **av)
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 0ad6dcc3d510b..091d9dbd3c01d 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -12,6 +12,7 @@
=20
 /* GIC component base address is guest PA space */
 #define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
+#define GICV5_IRS_CONFIG_BASE_GVA	((volatile void *)GICV5_IRS_CONFIG_BASE_=
GPA)
=20
 #define GICV5_IRS_SIZE			0x20000
 #define GICV5_IRS_ALIGN			0x10000
@@ -79,6 +80,12 @@
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
=20
+#define GICV5_IRS_CR0_IDLE		BIT(1)
+#define GICV5_IRS_CR0_IRSEN		BIT(0)
+
+#define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
+#define GICV5_IRS_SPI_CFGR_TM		BIT(0)
+
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
 #define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
@@ -155,6 +162,10 @@
 #define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
=20
+#define GICV5_HWIRQ_TYPE		GENMASK_ULL(31, 29)
+#define GICV5_HWIRQ_ID			GENMASK_ULL(23, 0)
+#define GICV5_HWIRQ_TYPE_SPI		0x3
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
