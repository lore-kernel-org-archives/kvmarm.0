Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012037.outbound.protection.outlook.com [52.101.66.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B710A2DA76A;
	Fri, 31 Jul 2026 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509283; cv=fail; b=fG2Tuc+nzpKkj3GZ/2loiRk4lbXS86cSSs+ps9Onmw444lacx08JPE8PmCNBIF2UdvL5LNt8mfq01AzyQWLBcjTRe09P2Ek3b8W31M1UnwSkVRcn6jDJ9ALpYV0BV08LbB+51Wuysj27Gt2Zd0sfZDPlDj2SH3z2SDwfr/0xW4I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509283; c=relaxed/simple;
	bh=318kfGqbP1eyzNrGlCQJtF3cx+vkXv/d+MJJeIzUo+c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B+gJmDoQ1g7PzBjwTtS7xU+UQo1CXKJ3C5+HJNNVdSB3h5p0Xwt5t3QAlR+hnUoQH1TRc6rvPVIogVLAgmCEa09fFW9XBLeIWUhTq0b5OmHLFV7MwCA907tWA5plyGWY4hGOxviKDfQ1nrrqiyZ4+Jcqo72EJ0j7cMLI/WsMi74=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AhxMwglk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AhxMwglk; arc=fail smtp.client-ip=52.101.66.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AhxMwglk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AhxMwglk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dEObxjxXck+pzUlWzLOuq8G+3o3+Qq/d4KkfCrbw9+vt8T+OEEGOeK5BszN9i6sXvqKf/xMgRSwguCtHs0kaduQfcbOldx9hsznpil/WiLCIoiRILTtUBylFhslihKOKeN7RPC9R8EEipJX1n0yLLdh0x0rH/AgnSjuXp48zq1I+as5DqML/KcGLnFPIer79epjGsmB1L/1o3ymlodogp4VLnCZ2zCDA8ws+4wTxKqeHWv7Ehj2iid6c7WSGYaUqBaDRIbSUsaWKAfjo+Vw+QkS6wzKzBZdvc1xewjfQzIMerw1e8CMbTifYgQig3hqggMkV8nBwKx3yALRivDXvCA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=318kfGqbP1eyzNrGlCQJtF3cx+vkXv/d+MJJeIzUo+c=;
 b=v84HZylTp70Y/QLTK3yeKV9FJT8JWi2b4ulkVaoiCI0RWaVVNIQVo/ZMYvJTLa7qCgm44qFwoHrTx8XYRdKNqfKr0lk6xNrCbE4wNIsjPW9hffgN9nmWBCbLbowzeUuv0sd2KfB3uNlLxnGwqoLED8GxnxcwbpahPJmARoSF9swmzRK6EwvUc7+KJ1JEfJwnYSA/2jWOJ5o2qj3M9pT14OSOwtYhBab1N4p0ePCsewc8ui0bnI+9sATyAV+pQrq0oHHhhzdBjp8Wca5L8MrRf5xggF7nhLlwzq4pH45J8D47uC3LtAgMaUqmMVre2aRTPVaHdL5AV7gCHtoesnzS1w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=318kfGqbP1eyzNrGlCQJtF3cx+vkXv/d+MJJeIzUo+c=;
 b=AhxMwglk0OaM2KxySeIFpJ3ZhAr+/b+28bGTWrVaTYxs14UITkpPhlN1+OPMexQNpAKY/cjJPGECHyhCVG4sGAgDTc4KgnOniaLnz8x+oFSLPfZw3NIfBU2rN73vgsQoz8kkC0vVtVvo6YlKaQvJ4wrCBSzXTR0EJX4bTxyYS+4=
Received: from AM0PR02CA0140.eurprd02.prod.outlook.com (2603:10a6:20b:28d::7)
 by AS4PR08MB7601.eurprd08.prod.outlook.com (2603:10a6:20b:4ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 14:47:55 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:20b:28d:cafe::32) by AM0PR02CA0140.outlook.office365.com
 (2603:10a6:20b:28d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 14:47:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 14:47:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmZfnR6tTyQFo0UEgwu2cbSqgwYuyG/18b228MZ3pY8WTmIQx+lgOtV1L5dq5nzrIEJbZM3RsvNb6HDx4TNASFldhK+DdlkjwGthePsnBUDBXALxtNXxTvPhZSt+gZfmIvblmJmjKJKU6KXoMXRgZtNX+gRQRBd5e5iv6c5gZzktZZv0+VzREy0JyRcI6uHsCRZGcrkD9lCusH9IO8q5bWgB7kOpVsQmVLLQuG23fwyg7d+TBYGexG2ReiRH/Usn+MmSzcc86PsDTrgQDIumumAQUzCM5xACwxsQSRK2MZro8rw8m/8yMpnPxlVABecf5y2KImga8v6Kl/LFlSvbqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=318kfGqbP1eyzNrGlCQJtF3cx+vkXv/d+MJJeIzUo+c=;
 b=sMnLYLT+PVTxQfAsIGh2acgREDKXW7+dyXhXVAnPFs8o8zH9BWxRXvy7rYcTJZJd/w3EQ4nJFU1AIvssMtDTOR8TCtf3M6muXZvw/XVa7rRzEtIXH0BKj37xaUf7khEtPPlSc22yL4/yEpRs+FRsjHwz9MOpMloCtFXgfNlkydIp5M83JIfG6lDmM+llnzaxcbMr7bUmBLAJFMFFTE2QP5K4+VPVA7uZjpkeW+PGVRBDDSdPeVGj1XxzF9ksDNxsNXyQlM9kzpf8JjG/wDrj+x2Ts7W8V8xEGV9wYrZp9zxy4dsAFSVaS853L50WGkxHzHNfguX/ByJ1NpplOUzqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=318kfGqbP1eyzNrGlCQJtF3cx+vkXv/d+MJJeIzUo+c=;
 b=AhxMwglk0OaM2KxySeIFpJ3ZhAr+/b+28bGTWrVaTYxs14UITkpPhlN1+OPMexQNpAKY/cjJPGECHyhCVG4sGAgDTc4KgnOniaLnz8x+oFSLPfZw3NIfBU2rN73vgsQoz8kkC0vVtVvo6YlKaQvJ4wrCBSzXTR0EJX4bTxyYS+4=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV1PR08MB8036.eurprd08.prod.outlook.com (2603:10a6:150:97::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:46:46 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:46:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 37/48] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Topic: [PATCH v4 37/48] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Thread-Index: AQHdG1tJ9y7uvWmmjU2Dv2AqKuKqfrZ8locAgAspk4A=
Date: Fri, 31 Jul 2026 14:46:46 +0000
Message-ID: <77b24f5a2be800cef56e632a850b10343a209cff.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-38-sascha.bischoff@arm.com>
	 <20260724121906.BC1D71F000E9@smtp.kernel.org>
In-Reply-To: <20260724121906.BC1D71F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV1PR08MB8036:EE_|AM1PEPF000252DE:EE_|AS4PR08MB7601:EE_
X-MS-Office365-Filtering-Correlation-Id: 19f88067-96a9-4ade-910a-08deef12b473
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|38070700021|4143699003|11063799006|56012099006|3023799007|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 tP40pfgTrhr7+MXJvhwCIsuIHVWjaHsKBAh9y7zRqaaekCA6FaUIUzzRadvtdvDx+XrNKYBnb1O+mn6LQ4iV0KGCnGFVX3sR23SzOnWCJ5w7HZHTd10LU1bUWY4LnUk0flg7rc0AG7aaw3l7QKVQeI+fdyXvIFlWv6NSgTxZSvysnkOY9OE5TfzSHdbruh/gOywruRbe5emfWtgDHY6MUKJ3oqcNcJ50fnhfXtSD7zxc5UeoDUSYJZ6Xwd/Xobc3apj3f1bCPUPHxS3urJHDFJkpCaj0TVsVe6Sr78KRjDzrQ41VdzrZ4wa7Wquo+yEckdNhwx9EYrvgRHV3uFZ5iuxWt65xwxuOs8IDp3zHRWk80OPKXg0B6K4cx7qmPGiTz74XlessMVy4DjxqAXP4fbWnThOtPFW/vDOI5Zodsa66uvGaPLsieuJaU144kiOXHqe2yIsKOmOyERpctr/6UtdnweyhBKHVbwiDUfIHR9ctC9tUk4y2LjK7hF6THyzHuMA1rvK6gxOV5K64vu9osgcDarQHAltwOp68Wf+TkgJB77su0DnvFyNYRIW8uA4QvhTKTQDcedq4CmPkIYv4pSrL07HDEvRMEjCZeSu9QOfH5HG2v+gLG7A9arcLxFOA0mqMgM/Q2U7FiiC/x5EPLScuL4+Qihc6xQseyR/9desPZHYMWMCb8IopxWXJyj6ohgUthlKheejgTmQqHID1fUO1znA7rweR3K71wjYtfWM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(38070700021)(4143699003)(11063799006)(56012099006)(3023799007)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <03DBDA518CACE54A9D985D0FBF4BB47F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TsZYmz9IMvDPPttk+w9yRIOcUj8kl+J/SBG9qEpHRhFrD6pM4ZuBbpGKATYmJ5r/7ttYjj8T5AwzEPiYOQjHCcvgG0HdaOgaEfWtiCqfTVQUdZgK8UNpq0QFgW6wM1DuTUtyS0hzUCoTTO7HSbd1P8X7haCMtTuzw7tCcnrWcn8PhAERSLRZquNTeuSMzmaoZ6t+k+NHt0EL0AqnrzI9CEJ70lr51ZNqgjzsYTswGl0RV9okKjMeIZ25NBTe9PJoxA64lyv95rT2ZkjuqxyQzML6qFfF97mdmco1qLBZeNUYz2kDBB6CJxQzqTPGVlTIf+z6qZPVwWaaBj4Ei8AweA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8036
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	753d47f3-4587-4cba-453f-08deef128ba8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|14060799003|23010399003|1800799024|376014|6133799003|3023799007|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7mqZnJw7/ERsiLXLfzGzCE4gzyHvpE7IZUXUJP2OwEqwoy+B47oCzC56XyCI1MSBR770+3jZATnKuAgEKxsEPOYrxJS5xSCHB7xDAU91LGS1kJQR5+z84xhxyoaLCruIFuy+6tyDaM3KbXqFgPZyK1Ogmt66xMkuvsJ0D+MtyzjlnJANNpSpufdqLQvNlY0beoCOhXKyNtt5BJhAc9RseimdxKjsPrURG2WDdlUi2xe89vZjCP2YbPVfURxjX1TPCUK0oYik2S0nMgKSAw9kKG30LPoNp4IoAFKfMqpW7va/KRfYM4VJLOs+KO16SqHaesfWg2FRxpyDgrU35MlbLbDy6m5iIJ7V6/k/U7SAxITwo21ZA9GLkQikeFhrvrdX9q26LSwFiCePWnplsxLyT+lloLQZu80AHrAAreqoRUprHR1aKxSHVX83eUHKfQaDQyVQv5xoLg/kNj/vfuRnC67cI7zDrUYoEWNfWGGP3oHNqYo1JDqGM1r7kNK4TA7mcY3PNFEv+bB23n/1n/YVkb+0LGUFUo94qtETIbD+5TrYFrTKZdDOXEZrhM1cszR6tM7cwprEcr/053kkhaSjVzQT2Ku3I6VplDQlVzHQPERgTTn+5RLglAwq1qTvncl4m9oSsnUQlwZyPgWMCc4A+yXjkrWJbU6HcNvrzTJtBUWY+2mu6jO9xZaku26M8XCzgFY8jbKz2N95BifsWrI6gw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(14060799003)(23010399003)(1800799024)(376014)(6133799003)(3023799007)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vwcJFAvm2AqT7MiCyXWsc7v7p5DaxgX3GtIDi+NOIVgHo3lazTN5uZ4+bFZdFS3cfmxOPv3XPuKwKv/ZvqWgysrHUUEEMAdkElegs78EwG8KkxMCZEg4xTqumDjHGKBiCWxZHc0laEGGRd6LPNTu/uRwdKsnYXAQ5mhOjXg0Xk8Wuv9hfHCHtvpQ4ilN8z+bWQMRSH7HMrU6rXqXOYJtH1hoL77E751mxCiYJNCiVSXRhjkD1I0Fg2govZEAcrLR/h7xr61Jm1VOTj+ku6WHaMWosA8lHELWxO+/BFIxnKhxHYw9yr6nJsj3MF2a2jO5j7EuBupmVzO2tZQHgdgSRl2FHZ0uIf82n5jgKOYxE+8zYVMvN4NP2qGNjS2b4xZUzQDzO62Uoqx4y4l2vTIfwIrmo4jRXK7Up2/Fpw/40qcyx8sgnaIFxiO/9i36wynH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:47:54.8036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f88067-96a9-4ade-910a-08deef12b473
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7601

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjE5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IE5l
dyBpc3N1ZXM6DQo+IC0gW0xvd10gVGhlIGRvY3VtZW50YXRpb24gZm9yIEtWTV9ERVZfQVJNX1ZH
SUNfR1JQX0lSU19SRUdTIG9taXRzDQo+IHRoYXQgd3JpdGVzIHdpbGwgcmV0dXJuIC1FQlVTWSBp
ZiBhIFZDUFUgaGFzIHJ1bi4NCj4gDQo+IFByZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hd
IFNQSSBjb25maWd1cmF0aW9uIChlZGdlL2xldmVsKSBpcyBwZXJtYW5lbnRseSBsb3N0IGR1cmlu
ZyBWTQ0KPiBtaWdyYXRpb24gYmVjYXVzZSBLVk0gaWdub3JlcyB1c2Vyc3BhY2Ugd3JpdGVzIHRv
DQo+IGBHSUNWNV9JUlNfU1BJX0NGR1JgIGFuZCBmYWlscyB0byBzZXJpYWxpemUgdGhlIGNvbmZp
Z3VyYXRpb24gaW50bw0KPiB0aGUgSW50ZXJydXB0IFN0YXRlIFRhYmxlIChJU1QpLg0KPiAtLQ0K
PiANCj4gLS0tIFBhdGNoIFszN106IFtQQVRDSCB2NCAzNy80OF0gRG9jdW1lbnRhdGlvbjogS1ZN
OiBBZGQNCj4gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVJTX1JFR1MgdG8gVkdJQ3Y1IGRvY3MgLS0t
DQo+IGNvbW1pdCA2Yzk3NzZmOWUwNDk2ZWI2YzNlMjZmZTM4NzY3NjRjYzExNDhjYzhhDQo+IEF1
dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IERv
Y3VtZW50YXRpb246IEtWTTogQWRkIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19SRUdTIHRvIFZH
SUN2NSBkb2NzDQo+IA0KPiBEb2N1bWVudCB0aGUgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVJTX1JF
R1MgYXR0cmlidXRlIGdyb3VwIHVzZWQgdG8NCj4gcmVhZCBhbmQgd3JpdGUgdGhlIHZpcnR1YWwg
SVJTJ3MgTU1JTyByZWdpc3RlciBzdGF0ZS4gVGhpcyBwcm92aWRlcyBhDQo+IEdJQ3Y1LXNwZWNp
ZmljIGludGVyZmFjZSBmb3Igc3RhdGUgdGhhdCBpcyBjb25jZXB0dWFsbHkgc2ltaWxhciB0bw0K
PiB0aGUNCj4gVkdJQ3YzIElUUyByZWdpc3RlciBpbnRlcmZhY2UsIGJ1dCB1c2VzIElSUyB0ZXJt
aW5vbG9neSBpbnN0ZWFkIG9mDQo+IElUUy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50
YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiBiL0RvY3VtZW50YXRp
b24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiBpbmRleCA1MGQ4MDMwZTJj
ODA0Li5jNDExZDIxOTVjNmEwIDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9r
dm0vZGV2aWNlcy9hcm0tdmdpYy12NS5yc3QNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQv
a3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gQEAgLTE0OSwzICsxNDksNDEgQEAgR3Jv
dXBzOg0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArwqDCoMKgwqDCoCBGb3IgcmVnaXN0ZXJzIHdp
dGhvdXQgZGVkaWNhdGVkIHVzZXJzcGFjZSBhY2Nlc3NvcnMsIGdldHRpbmcNCj4gPiBvciBzZXR0
aW5nIGENCj4gPiArwqDCoMKgwqDCoCByZWdpc3RlciB1c2VzIHRoZSBzYW1lIGVtdWxhdGVkIE1N
SU8gaGFuZGxlcnMgYXMgZ3Vlc3QNCj4gPiByZWFkcy93cml0ZXMuDQo+ID4gK8KgwqDCoMKgwqAg
RGVkaWNhdGVkIHVzZXJzcGFjZSBhY2Nlc3NvcnMgbWF5IGluc3RlYWQgc2F2ZSBvciByZXN0b3Jl
DQo+ID4gbWlncmF0aW9uIHN0YXRlDQo+ID4gK8KgwqDCoMKgwqAgd2l0aG91dCB0cmlnZ2VyaW5n
IGd1ZXN0LXZpc2libGUgc2lkZSBlZmZlY3RzLiBGb3IgZXhhbXBsZSwNCj4gPiByZXN0b3JpbmcN
Cj4gPiArwqDCoMKgwqDCoCBJUlNfSVNUX0JBU0VSIG9ubHkgcmVzdG9yZXMgdGhlIGVtdWxhdGVk
IHJlZ2lzdGVyIHN0YXRlOyBhbnkNCj4gPiBob3N0IExQSSBJU1QNCj4gPiArwqDCoMKgwqDCoCBh
bGxvY2F0aW9uIGJhc2VkIG9uIHRoZSByZXN0b3JlZCBJUlNfSVNUX0NGR1IgYW5kDQo+ID4gSVJT
X0lTVF9CQVNFUiBzdGF0ZQ0KPiA+ICvCoMKgwqDCoMKgIGhhcHBlbnMgd2hlbiBLVk1fREVWX0FS
TV9WR0lDX0dSUF9JU1QgaXMgcmVzdG9yZWQuDQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IFRo
aXMgaXMgYSBwcmUtZXhpc3RpbmcgaXNzdWUsIGJ1dCBkb2VzIFZNIG1pZ3JhdGlvbiBwZXJtYW5l
bnRseSBsb3NlDQo+IHRoZQ0KPiBlZGdlL2xldmVsIGNvbmZpZ3VyYXRpb24gZm9yIGFsbCBTUElz
IGJlY2F1c2Ugb2YgaG93DQo+IEdJQ1Y1X0lSU19TUElfQ0ZHUiBpcw0KPiBoYW5kbGVkPw0KPiAN
Cj4gVGhlIHVzZXJzcGFjZSB3cml0ZSBhY2Nlc3NvciBleHBsaWNpdGx5IGlnbm9yZXMgd3JpdGVz
IHRvIHRoZSBTUEkNCj4gY29uZmlndXJhdGlvbiByZWdpc3RlciwgbWFraW5nIG1hbnVhbCByZXN0
b3JhdGlvbiBpbXBvc3NpYmxlOg0KDQpOb3BlLiBXZSByZXN0b3JlIHRoZSBJU1RzIHdoaWNoIGV4
cGxpY2l0bHkgY29udGFpbiB0aGlzIGluZm9ybWF0aW9uLiBXZQ0KZXh0cmFjdCBpdCBmcm9tIHRo
ZW0gYXMgcGFydCBvZiByZXN0b3JpbmcgdGhlbS4NCg0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLWlycy12NS5jOnZnaWNfdjVfbW1pb191YWNjZXNzX3dyaXRlX2lycygpIHsNCj4gwqDC
oMKgIC4uLg0KPiAJY2FzZSBHSUNWNV9JUlNfU1BJX0NGR1I6DQo+IAkJYnJlYWs7DQo+IMKgwqDC
oCAuLi4NCj4gfQ0KPiANCj4gQWRkaXRpb25hbGx5LCB0aGUgSVNUIGlzIGNvcGllZCB0byB1c2Vy
c3BhY2UgZGlyZWN0bHkgZnJvbSBoYXJkd2FyZQ0KPiBtZW1vcnkNCj4gd2l0aG91dCBzeW50aGVz
aXppbmcgS1ZNJ3Mgc29mdHdhcmUtdHJhY2tlZCBpcnEtPmNvbmZpZyBpbnRvIHRoZSBITQ0KPiBi
aXQ6DQoNCkJlY2F1c2UgdGhhdCBzaG91bGQgYWxyZWFkeSBiZSBwcmVzZW50IQ0KDQo+IA0KPiBh
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUtdGFibGVzLmM6dmdpY192NV9zYXZlX2xpbmVhcl9p
c3QoKSB7DQo+IMKgwqDCoCAuLi4NCj4gCQloX2lzdGUgPSBSRUFEX09OQ0UoKmhfaXN0ZV9hZGRy
KTsNCj4gCQlyZXQgPSBwdXRfdXNlcihoX2lzdGUsIHVhZGRyKTsNCj4gwqDCoMKgIC4uLg0KPiB9
DQo+IA0KPiBTaW5jZSB0aGUgY29uZmlndXJhdGlvbiBpcyBsb3N0IGR1cmluZyB0aGUgSVNUIHNh
dmUgYW5kIGNhbm5vdCBiZQ0KPiByZXN0b3JlZA0KPiB2aWEgR0lDVjVfSVJTX1NQSV9DRkdSLCBh
cmUgbGV2ZWwtdHJpZ2dlcmVkIGludGVycnVwdHMgcmVzdG9yZWQNCj4gaW5jb3JyZWN0bHkNCj4g
YXMgZWRnZS10cmlnZ2VyZWQ/DQoNCk5vLg0KDQo+IA0KPiA+ICsNCj4gPiArwqAgRXJyb3JzOg0K
PiA+ICsNCj4gPiArwqDCoMKgID09PT09PT3CoA0KPiA+ID09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID4gK8KgwqDCoCAt
RU5YSU/CoMKgIE9mZnNldCBkb2VzIG5vdCBjb3JyZXNwb25kIHRvIGFueSBzdXBwb3J0ZWQgcmVn
aXN0ZXINCj4gPiArwqDCoMKgIC1FRkFVTFTCoCBJbnZhbGlkIHVzZXIgcG9pbnRlciBmb3IgYXR0
ci0+YWRkcg0KPiA+ICvCoMKgwqAgLUVJTlZBTMKgIE9mZnNldCBpcyBub3QgMzItYml0IGFsaWdu
ZWQgZm9yIDMyLWJpdCBNTUlPDQo+ID4gcmVnaXN0ZXJzLCBub3QNCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIDY0LWJpdCBhbGlnbmVkIGZvciA2NC1iaXQgcmVnaXN0ZXJzLCBvciB0aGUg
c3VwcGxpZWQNCj4gPiByZWdpc3Rlcg0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmFs
dWUgaXMgbm90IGNvbXBhdGlibGUgd2l0aCB0aGUgY29uZmlndXJlZCBWR0lDdjUNCj4gPiBJUlMg
c3RhdGUNCj4gPiArwqDCoMKgIC1FQlVTWcKgwqAgVkdJQyBpcyBub3QgaW5pdGlhbGl6ZWQsIG9y
IG9uZSBvciBtb3JlIFZDUFVzIGFyZQ0KPiA+IHJ1bm5pbmcNCj4gPiArwqDCoMKgID09PT09PT3C
oA0KPiA+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09DQo+IA0KPiBbU2V2ZXJpdHk6IExvd10NCj4gRG9lcyB0aGlzIGVycm9y
IGRlc2NyaXB0aW9uIG1pc3MgdGhlIGNhc2Ugd2hlcmUgYSBWQ1BVIGhhcyBhbHJlYWR5DQo+IHJ1
bj8NCj4gDQo+IExvb2tpbmcgYXQgdmdpY192NV9hdHRyX3JlZ3NfYWNjZXNzKCkgaW4gYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLQ0KPiBrdm0tZGV2aWNlLmM6DQo+IA0KPiAJaWYgKGlzX3dyaXRl
ICYmIHZnaWNfdjVfdm1faGFzX3J1bl9vbmNlKGRldi0+a3ZtKSkgew0KPiAJCXJldCA9IC1FQlVT
WTsNCj4gCQlnb3RvIG91dDsNCj4gCX0NCj4gDQo+IFNob3VsZCB0aGUgZG9jdW1lbnRhdGlvbiBh
bHNvIG1lbnRpb24gdGhhdCB3cml0ZXMgYXJlIHJlamVjdGVkIHdpdGggLQ0KPiBFQlVTWQ0KPiBp
ZiBhdHRlbXB0ZWQgYWZ0ZXIgYSBWQ1BVIGhhcyBydW4/DQo+IA0KDQpJJ3ZlIGFkZGVkIHRoYXQg
Y2FzZSBpbnRvIHRoZSBkb2NzLg0KDQpUaGFua3MsDQpTYXNjaGENCg0K
