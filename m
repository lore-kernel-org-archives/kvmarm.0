Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF07374195
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102052; cv=fail; b=DzxZbSFYjkfoaowRPIL6Cb6PrqOkcrrXW5VepMmm2utz00PM5ndwSFrU2kuvfWaHjY9DTZazbh/S3i3Vnd0Q+PIP/KtkSmYVgbErESCrh3bxhqNQY1KfHsYn+zsHDbs5wfo88jFW1Yj2yHdN6oaP6qMMUwR78g9A5/BT6SX6Qoc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102052; c=relaxed/simple;
	bh=g6tvZx1LJgHgXuT3OeDIMZr0dk69sfpSA7Jt8KVwJBQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q0ESiHg/OManvd1CmUnqBim8gFpUGDjEsXmn9H1wYql2Qe93gKUZNjtDnpSz/Yux1S/PZ2DdvSFQZBzqU94KCeGnVN6cSrMlKuv0iBeXqwy1NfTVus34f7Z/TpXLD5OxwK0tw3F6KcKnxrRD2I2Z59VyvdWR/1r8Fq58QT2B52c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=chPBHIJh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=chPBHIJh; arc=fail smtp.client-ip=52.101.70.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="chPBHIJh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="chPBHIJh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Yi2lVS6j3P5/Xx8tuVDn0B5bpPdFeRqkSapPfmoiHzpQOPm9araJD+LB5jwvN/ZjcezvM+SBHJvUc4x3Wo9IBa8+e+iq0b36cdfpBcPnN78sexKPJHrcRL3XHWECMyUd7rGWFdWe40QX9B20TiVCPEgXgTgGvycDncfVHJyCR04GQOEmOIRcdwxJD/BCDeNMIUnweQFRKH34eufk98g6nRoYATI7QVKrlBx4nY/+khcak5iu/uVYap/8qDkyoZ83IQ0lZQSpAY7zX/ns7Q/TOxwm5d53hTkIg5CuFsqOPmu5HPy+9Bk56O9Ld5B7PPN3ve2976xsbfm8xjuCEi3jdw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=gERMjnQkZgugd/+k1CqcbJc3jYFk2tMgWR2iYyiDMk/ATXeYd6+gXgu0yWhIJZhuET6j85DKJzDs8xd0aCNC6L7ubnmy5JpUU+duSufvsp0c6IkWzo2t47xewGq7Pr/IMYxGfgou0lsbfuyBSJ0n7c16l30NCzNxDvd+WoMJ89FMMc2/+5vX+CSKjqwFUf5bZmuQTvs1NjWh6MgON2QHGWGb1PPRYns2P7Zn0lm4HG99MohS0CVBgyyVKxvLec3yj7DK6Wla37EZAf5P4E8qKTlujt9QtthzQH/RLRp/WrK7koZKrSkU1DYqbtnyK096C6BGNHbr0xTiFA/ZqCT66w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=chPBHIJhuzUrBIhl+qNutp93IV58PiS76ecdHeL2Gm3WG7n0kJA42IXIeYfE9d5Kw3StYOCoYaRRdL8iqQv5iggRXwtX9/Y67nkWF/q8ZRFJ6AE72BjRmH6xkZ0Pe+I8UzjH+wE/KbhyARbNpbpmBVuUESFfV7b33xgL197Eywo=
Received: from AS4P189CA0053.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:659::17)
 by DBAPR08MB5624.eurprd08.prod.outlook.com (2603:10a6:10:1a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:27:24 +0000
Received: from DU6PEPF0000B61B.eurprd02.prod.outlook.com
 (2603:10a6:20b:659:cafe::83) by AS4P189CA0053.outlook.office365.com
 (2603:10a6:20b:659::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:27:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61B.mail.protection.outlook.com (10.167.8.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:27:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODttZ0ncHl5FDaeD5fCcGE+52YK3uymj1mEw/himdMFmaOdc24ANKxls2WF/I+A/VsmXIMMbGV4wJMP2LhvfaqtVPPbulsLFyH2wDyQlXR5UDkSj6OI1Jm07wOjsKSUNnDAOBHt/Qip2IDDuKjaGdta2/Dk5pBTsBNDcX1zrdywikKy+u7jpRtR0WEomwAkr6PTZ/TXgRwnLzNyMBHBJXRSSFYHwH27ei8BAtD9FN4JJy+x5lTg4dJmfGKDGHI+BhfaQmKFz2BQr7e9GSgwWRmF3fY905K2OHkAjv4C4AyPHyq20288XqfJ4qCLjBZwsYp6tkT5gLunwZ0zgHm8UOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=bhZBI7Kh7joEnpMNrqJG/DkpNDUeX2lPyn0toPsQ2OZfU7PU2MFQfRNApxWs+CctuJHAwJh3eGo6qZA3zbXCKZlgfFa9JJTykB1FmkhGkDX6jIwfOKD6jQnSBZ0iZL6mAUlYaxDVznJpiORQ+f1eA4hiKo7+tOK+xOYbeajcf0vCKCXiMJLtyEiD6Kt54lR7wrMDoc/+Gx/5pVQuZ8APY8zLJTUTgarqvT7E/+MafyeThtgURCDbCyWKD3ZiJLMqQWbblv5xJocVnWpMPo0FbEVBsrCsqemR2GjR6l9TIG/v8qtVHTGZdUKX5ieXrWNNMyQQwICWtdUXKqgYwxlx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsdTGTewjnmgrcwCrYlFdpOtIaWTJyBAbNfKF6AhI0E=;
 b=chPBHIJhuzUrBIhl+qNutp93IV58PiS76ecdHeL2Gm3WG7n0kJA42IXIeYfE9d5Kw3StYOCoYaRRdL8iqQv5iggRXwtX9/Y67nkWF/q8ZRFJ6AE72BjRmH6xkZ0Pe+I8UzjH+wE/KbhyARbNpbpmBVuUESFfV7b33xgL197Eywo=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by PAVPR08MB9724.eurprd08.prod.outlook.com (2603:10a6:102:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 11:26:51 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:26:51 +0000
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
Subject: [PATCH v5 28/49] Documentation: KVM: Extend VGICv5 device attribute
 docs
Thread-Topic: [PATCH v5 28/49] Documentation: KVM: Extend VGICv5 device
 attribute docs
Thread-Index: AQHdJl+k7Mijqf0J0Ee2xAkN9DYeMw==
Date: Fri, 7 Aug 2026 11:26:51 +0000
Message-ID: <20260807111159.429128-29-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|PAVPR08MB9724:EE_|DU6PEPF0000B61B:EE_|DBAPR08MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e9099e-9f31-446c-381d-08def476da9e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 H2bxeWBOa0eDX/XOlgOS2Za9zxBzdFfYxSIn+d4RtuyIQtI3ZHz/kevWhsOWKe/gC4E2MYFaRV7W6+19RxXQVx4b9fugeF9NTYfShwUA2qPZgf0xQoxxwNaR5HWaalIDGTU11ovidA6wPVn3pW28OlhLX9qRATgGxsPL1V2l0mTlfshQBs7Trg20VliVfqFQcQRfhi5Mx8YRdGKwb1qGH4MSvLfhUZDEdb0LRt3Zk3zZKdT+m8HUDSrMUG4plkXhTOsPZsyhWJaubT7qIfFpfb4k3NuOvwkXYiv504y02KEQ6qTz6aSFNcIVsf1Gb2Pm41cyYyY6Xk+pqgXevAozTk75+cSy2gEhxPOuFyVbER0i0wKeR+rMv2A05rNfAJQj0O+vjbIiXcTGxpLePXp7ab1nn75FX82mme99tyDqpdTRp9G/zb5dGyfNKI4cmEMjVfna3IX1yWSu1FzaeE310MHgy/p201N8RuFtGRDiX0kctt5wrvE21Cs8StTeNkyiII8S6ieoEccOrfD72SJ57AAbPidNxDjSMeIfbg+q+u30KpFver3Zq5V4fms52kfcpwE2WVdaA6ssZMZZp4I18CXn/0hgiNHjW78orpoNnwaDcVXAK1e5z1EBPyYZDG/SBUW17ZiHpTtvqbr1heI5nl6+dCW251o6WHkjSP7Dgl+y4LJkP4yVgi0j+3g2Gqa6iwd619VU33L9l2AMFscT8BAo4+C1WROw9l5pqRlFPkg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YXLtn7+L8u7q18IOI0gls9+zpd+HXk80xl0RPl7Ai0xBCaoe/ObasV8QiljtMfLFvCu62ga6GLaFb+H6PkrEayIVj09vRjA4V1WSHbnYW+bm6apXsqhIAvhj1RXPLKHZ49hGZa5DpF1oULP+2Bk1kMZhTkLWjM2N0qOLplpGjPpZCw9BEGEPT8xnS5XkS5pU8xaOn/7bn6q9MRqdZFWTXgx9J16sc/7GtA5I5KyoRFNfgB8AtmVbHAjRBOh+bkwIjpWkrmQ0+QI8hDehkoi4eRC4gO9RNqujbq4bC9QuOBD222FoMv5Yntsu0b0aA/BzyeoIMKTdzsfq3VMQOkiTzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2e6024df-9555-4a74-a304-08def476c70b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|30052699003|82310400026|376014|35042699022|23010399003|36860700016|18002099003|22082099003|11063799006|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	QbXP6J/HlnXFwMAwerUwHsgM1UN97SUTk4X50MRQayyG9rXjppvoZN1U5k0wUxzoa8X7vlKxWtjT3n2A9XVUOgC/zVWcalC6oha8nVeuM6Tvwjs/mwWZEvuNNG51m8nF1kpDIueqThRDLjcRRBzu1HBfnX48cxUOFe4BGWQ6gOBci0Gb/qFbq6eTjyIh8Q79hSNiaWwi7FGo24SpGfY/LeWzOLC+MuGkw3W/jS6iZDH7ef99O8JBGaG/TRM5UjUJV2mDu3l/WQd4nGzR7AE9MQpm6lBe7GN+M79uZi6r3+cdaqL/B4sar52Y43k3rd3lYRv4ROsDTKW3P9zrmybTCW5X4MVAY7hYTIIR1R37PTAMwOO4S28fU2vkcVEyhI2+zoWmGrVdmlWE0yOczUqNYFqihyQZY2JZ99TpD50HfEHYphZ9C6fViXR4Gohv8ObNHHDRCLijcdVjcuJZPv3SFejbmQBZXpe7CfFKfMZ6L74QPMHb1wV2va24cgsORz/UOvqPc5MUP5j2UtA7vns/scwvCEx37UXNwxzH5BskK+mYA2hfv6BBlECdS6K42aGFp/yi9ez1fCpn+8XS9MvSINxEe+XHyDWp/k04P0U3234pvWwEnqYRsO1u+iE4O/NxLYRGPS4yqYSnXPZ0Q5i9IYW1K4Z8YlnBrvY4ckP0tXyjwn/hAgDij0IVYicvJbZYz7EcJwRFNW5GqowNOchLrA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(30052699003)(82310400026)(376014)(35042699022)(23010399003)(36860700016)(18002099003)(22082099003)(11063799006)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3ICer6NG2N6LpVOSXWWl2vSWGuzhgNZSNqUPpHU9iBKzhymKm//dgrWHznp+mmJJ16dkh60GosJrHcBzLe+H3KPXMaDwK1XMPP32ckggQGEg30L9WWc797nzUQPjlI4tx+H6SmNQ6E4l5sDig0Z+Ua1f1UEY9Lwry361g+v7GDhg6vOlHvF+y1FpsTdb9kar/UYTS5w3tR4tXDt4ELKH70fk/js3XIoK5LpY21RfqkdlUYjQdhW/lTwghtWK0UeZAfFqW/X0KIOhSXYsk+ZsFPWg+7TIqVun4sAq0Df737Qqw+5NfBdzeqz4QqhzzYc3SLp/dN7GGer5I/qAiv2dbD/EcIEzulgSCoOmWr5cWnv0D9BDDCp2siYugRZkdPmmRdyIPWbCB6Dc4LQO09tXYJyUcnHsinydyKsIUhohUjxlBRqSmZerIS2qtDAXW0xL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:27:24.3325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e9099e-9f31-446c-381d-08def476da9e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5624

The VGICv5 documentation still describes the device as supporting PPIs
only. Update the overview to cover PPI, SPI, and LPI interrupts.  PPIs
and SPIs can be injected by in-kernel devices or through KVM_IRQ_LINE,
while LPI pending state is driven by the guest and handled in hardware
through the LPI IST.

Document the GICv5 IRS address attribute and its GPA layout
requirements. The IRS region must be 64K aligned and covers a 128K
range.

Also document the GICv5-specific interpretation of
KVM_DEV_ARM_VGIC_GRP_NR_IRQS. Unlike GICv2 and GICv3, the value
describes only the number of SPIs exposed by the IRS and does not
include SGIs or PPIs. The supported range is 32 through 1024 SPIs in
multiples of 32, and defaults to 32 when userspace leaves it unset.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 70b9162755c7e..c782ea4d4609c 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -12,12 +12,39 @@ Only one VGIC instance may be instantiated through this=
 API.  The created VGIC
 will act as the VM interrupt controller, requiring emulated user-space dev=
ices
 to inject interrupts to the VGIC instead of directly to CPUs.
=20
-Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 d=
evice
-only supports PPI interrupts.  These can either be injected from emulated
-in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
-ioctl.
+Creating a guest GICv5 device requires a GICv5 host.  The VGICv5 device su=
pports
+PPI, SPI, and LPI interrupts.  The PPI and SPI interrupts can either be in=
jected
+from emulated in-kernel devices (such as the Arch Timer, or PMU), or via t=
he
+KVM_IRQ_LINE ioctl.  LPIs are not externally injected, but are handled in
+hardware via the LPI IST.  Their pending state is driven directly by the g=
uest.
=20
 Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+   Attributes:
+
+    KVM_VGIC_V5_ADDR_TYPE_IRS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv5 IRS
+      (Interrupt Routing Service) register mappings. Only valid for
+      KVM_DEV_TYPE_ARM_VGIC_V5.  This address needs to be 64K aligned and =
the
+      region covers 128 KByte - the IRS has a CONFIG_FRAME and a SETLPI_FR=
AME,
+      each of which is 64 KBytes in size.
+
+      Setting the address of the IRS in GPA space is mandatory before VGIC
+      resources are mapped, as the IRS is responsible for handling SPIs an=
d
+      LPIs. Failure to set the IRS address before the first vCPU run resul=
ts in
+      an error.
+
+  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
+   Attributes:
+
+    A value describing the number of SPIs for this GIC instance. This is
+    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or PP=
Is.
+    The value ranges from 32 to KVM's VGICv5 maximum of 1024 SPIs, in
+    increments of 32. If userspace does not set this attribute, KVM uses 3=
2
+    SPIs by default.
+
+    kvm_device_attr.addr points to a __u32 value.
+
   KVM_DEV_ARM_VGIC_GRP_CTRL
    Attributes:
=20
--=20
2.34.1
