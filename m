Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010023.outbound.protection.outlook.com [52.101.69.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C0C3FE34D;
	Tue,  7 Jul 2026 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783428562; cv=fail; b=fM59XA1cuSx60GSNtsNT33HWb1mfZhVPL4bQ5n36aE86hGX6m9Z9fc4GOCTiZ1j05dFcf/WIekkaUbQnUcIUsn+cp2Wbz+ZqQLgaslXV1kpbsw3FeLa/G8euCbm0AwDg6v/iX4RilWdfkAxUPCiNRPFQ2Ip4PRapI5qWvBEz8sg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783428562; c=relaxed/simple;
	bh=6+XgLQ+rzn3naGBeJWDbUNs1T6NvrX+vEMLtMNYPJ18=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fnKB3oNuAPyG8kXufw6PgrjqT9lp9KyPaTrITmYJkxZo8FwLePOyOp+mGBcVHdgn5Z2S9V3QEvILyDJx1/frYZKDDyHazA0NIpO+jBoWUo/9BmCBBozVUCt+823JxOBmesuCO6arvHfSPIVnFyjEgiXl+NpbTW3TzfNVQMk6zzw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mXGgP5MQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mXGgP5MQ; arc=fail smtp.client-ip=52.101.69.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mXGgP5MQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mXGgP5MQ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HRmTXqIYEgPbHwvRefzIRPHLtBeN7aaNEP8Mr5d3bHREth2aRniqVTGfFDPQF+4qUtjkTbWjWF5WE4HnAiA4IecqiV+MRkuyLlzq1tP/oHkt7mmvaaKbCIop9PtIfJvVu6HG0YAOttmZX/G1TVvOcKYxJ78nIdUx5IZWQlH0qEg5FiIorry10p5+umdqOs0Amqc+q2eK6dZFCNEyOc7t+Qc5Z8cX9RbhQtmn4j4LbWFYZTSugs9FYsje1fiLgPFd1T0/iDcXpX4e0AGBOvJfEhX/XijvlFCRQFwQHr5VHPcPAxoWCALqNGDN9zBoe4oyK7tr11r8rgdN/mu3NjjvxA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+XgLQ+rzn3naGBeJWDbUNs1T6NvrX+vEMLtMNYPJ18=;
 b=BkQ/y3AoxNRpXxMTIgvBgV+Wyv0GSfbZgRRYt4zOF6ZeFfS/OKV8pMrvWWmj46up1F8sk+7t6xdH9A/6XNh3oReT5GI9Kz2cqgqKzEfqVIWWz/PYyptRnYM+MbQiBg2FM66mQSJColasPnA3BqpjZzSc1AsT/neVlJC8BtEYCcPwoShCNIvtKzbCFTQpJfMZIzLTjGhMpU30YtHO+WyUmoVzJ5rQRZBub8To+rLN3Qc5jQ0N+pNZ5bfmaIJv+069eyCVi4Mng02GSAEn4WA6BtAjKL2gIZAnrZV2ptasJ10V//bnC9vl0yEnypsu1xBG0KakhWlIlNg+MHnJwaa93Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+XgLQ+rzn3naGBeJWDbUNs1T6NvrX+vEMLtMNYPJ18=;
 b=mXGgP5MQTEVGdPDhTGLKBm1iWi0htD60gZenx0iR5PqBAlbkinYrQfDR1Jk9QqA/tca5suloPZOczp3ygmE5qQpelmVhQM1/pJqCrqwNJqfAL9TKa13UjDfBiLWeYIY+ZLEeti9LI+cKa5tPcrrvjYos1R71VPIlOvrhSVlO9MY=
Received: from AM8P190CA0019.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::24)
 by GV1PR08MB8107.eurprd08.prod.outlook.com (2603:10a6:150:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 12:49:15 +0000
Received: from AMS0EPF0000019B.eurprd05.prod.outlook.com
 (2603:10a6:20b:219:cafe::1b) by AM8P190CA0019.outlook.office365.com
 (2603:10a6:20b:219::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Tue, 7
 Jul 2026 12:49:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019B.mail.protection.outlook.com (10.167.16.247) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Tue, 7 Jul 2026 12:49:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Au8NjOHZM0RLhuzVFfTt6x/Ssuu0ykfzi7vw+jeYaKrnoESvCWptaNRpUcO46I9nzUB6bU4/erw+3uLGJp3pbk2bIyNiGezhr70s2cx4OB+/Qi335a747lhnz2rKSOH0rHnQEO/UXsaSG23Uo7CzOSf22BsTXF7/P1kSZX9/nEzaA74fYAnUI3ns2b8MFP2o2p2H2+4Xz7qkC5sV8lEXrAfhAx3U41iGyeGF1z4UDvWPuIopwEXekvsBSlgNfL0zrZo8OAeKrpw3FEgVscoMfd9Bp1HSrwXS2h/vZVYgwOg3VqSp8+a8dYUyMMASpYHoQpTZrmDqa2V6Au9V3APzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+XgLQ+rzn3naGBeJWDbUNs1T6NvrX+vEMLtMNYPJ18=;
 b=uXTcMsfeoWFOWDhrE9bBgLh2FZGuCThyjV5aBDR794oaM2ztS3YK+BKW+qb1L3ARzx+jWNWB5Ofbyn4upx8aLfGMrHJ1A1Z71pQE0pBIQD4KMu01uInWFfU9cQ+KmcbO1G8qeYe1VN2qztXx2N8Qwko/yhR+MEOgvyXZZUnadMHWrc2xFcP1QuwW9DtDHOHsivCOdyaMO8wdAmhK2PGlLb3FCBAtDZODwu+RZRuiwXgbppDAh7H9NYsb1rRqbTaO0hvq5zJ0pH7zHyL4fS680QVkhQQn/VlhZybQV0cWIhwhQA6RKeMos+LNRO0WQ/IajgNa90r8tnNRu7MRsB9A7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+XgLQ+rzn3naGBeJWDbUNs1T6NvrX+vEMLtMNYPJ18=;
 b=mXGgP5MQTEVGdPDhTGLKBm1iWi0htD60gZenx0iR5PqBAlbkinYrQfDR1Jk9QqA/tca5suloPZOczp3ygmE5qQpelmVhQM1/pJqCrqwNJqfAL9TKa13UjDfBiLWeYIY+ZLEeti9LI+cKa5tPcrrvjYos1R71VPIlOvrhSVlO9MY=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by VI1PR08MB9959.eurprd08.prod.outlook.com (2603:10a6:800:1c1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 12:48:11 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 12:48:11 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 02/40] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Topic: [PATCH v3 02/40] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHdCwPSLq3RWHtf/EuaIRHep+J9WLZb+rOAgAYM/gA=
Date: Tue, 7 Jul 2026 12:48:11 +0000
Message-ID: <d47e114053cb15bb91d15dd81885876cc3cbd525.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-3-sascha.bischoff@arm.com>
	 <20260703162406.564F81F000E9@smtp.kernel.org>
In-Reply-To: <20260703162406.564F81F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|VI1PR08MB9959:EE_|AMS0EPF0000019B:EE_|GV1PR08MB8107:EE_
X-MS-Office365-Filtering-Correlation-Id: 3982a7c4-77df-459c-14ec-08dedc262713
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|38070700021|22082099003|18002099003|4143699003|11063799006|56012099006|6133799003|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 elmsJ37ctBCZ1x6LdcFgjMGOFbSxbstmnOBOCJ3N5pchTasEjorOlSZif9Fu+fj2caQmrcZK/U7k+/98H/9mZsGAuK5JrfSrDxc0AMd2qIelvNNO94YbZ3hhARMmTodvVHPBA4Pkz3N/eEqsonRP5kKonW0mvj4EpORJdCixAMoy2qQURfuHBKYWwTYXUldOFLjOyiX07hsuLenjmK6/gYXgqeGUkPQgkdMhnmrwem3afTBiB2Zn/B0I9XPVP3mMdTcSkkUcHwexJo/UeuQ9EDeeRUrM5VWdbfyLto6FtzeSois6OkrFKtIqBKLIpaz5OYouv8fftP75EK5VSuPvGO8qAb8qV/QvQIw92X2mtNH93u8Ie056sfnGOhWd8ahley1ROk+fmFhER4LrSx2xt9hePvoyVxY9qKITnMobQyqSJRnN0CGI4EpqYunf05awq5DfahV2bJ3VY4eNi6FO1aQV/D4WBGDIwd5JaIUpMe3GD88bCT89H3WCnLfJsvMz9T/e6XkVZtAYC6fmdGhX1CNRGEuuekmgbzVHBG5SejAly/F9JtKLjY6kHDvqfMFK8wgZAdkq4K5PJHs63DLEImUOYr1T7oQwSKMs/YrIVlbhnewO5J2MgG6EHyTnUfLbZ75e99HPkI+fqKdURnnqBgqOFHJPCiXxWptYLGRu+cw3Ozfksv7+FzQYAFMqwEuRPA/7/t3ajXoaW86PFm1OEQVPvtpxrLe/rQcXn0jGuV4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(38070700021)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(6133799003)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E24B7CE263D906499EA0BED288B8C953@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 EKWsdK/bQ75JI5reMT/kB+BH4azWXr/wn63d1XvnJPxWq2+ocvbsUP+GIxiHzWLQkSvsBNgZfQAcDClZNpXkA6BE4wyCR0T4bLP4Kpna92us+eZ0VECwHWpLs8a3efsoIaxZqFEIxP0I94iP/yxvxFO2SZ/V03RuLNmtGBNQYDDH2FKua3069ud7ZZYRJexPSt+MvfZOrFEscmcnOQOY3Q67AOsfyEkN+NGJ1WY/Nldzt2b9H9fd8UvJ1KsRN9Fv7AjVygEp/61iyoHrgH0RXf7o7lMP5dgHLLdMG07JqZV1P8n64S88Rw78hGuuiuUn1gUphbFERf+34M0ck6gs3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB9959
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019B.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	715c4f41-101e-4f88-a8df-08dedc2600b3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|23010399003|376014|36860700016|82310400026|22082099003|18002099003|6133799003|11063799006|5023799004|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Hy3Z7qyo3QTpQytjHoxOWl8LZmnB9tn2i67NZQjMqj7P/A5M5wIJaAkLvYirzKevOu7DRZhmCQ7jzXprLOsTomuY9YiXJ+FnfpwR6Q6UjSgO2LAhPeP8zLQIxO6qY23sT+1RliEkN8b2N14BByZ3J/rCqBXMySHdExGHs78+33eYkXyzMs2Vz300xUGe7/7oOCYR96EBDB5eTiUdGRU7VYLhH7PPpanSlAXodPlvABTjmLL0pHbgxwD7XCe/O6Egb4Y0ZnFaPo5W8JcxurU+NHUVGKtIrFG4miTzznpPiYzZ7LfioSlzKJtgt9DAgtCwZHvpeJfMECnG2WjbL9dcpGzQfYfDE85dly41vgTcp8QFvZBLFi9V0xekj3JMfnbcGXnQYPbbw6NpQl3utyMpPc03mr7smZU911FeCUfK4ex8fpEqA/a2NiPcZ1uRc92dOaDFcxtqL5xRmAALQv+2IAUXocp6Xvbr8f2u9xn2QPfBcPVT8FbcuMSeqtMr/veynEsU8kImg3WS0BJFcZb/Hf9h1G9EgtF8QOU+91hEAJBKSaayLfGWXf3lr8f/M//TVQGO+uOrJy0+FD2BZs2SVm1o+WWl9SdiiADGXG37EdiaVeYE46FSI3WrIJkXCWRmz+55XFPnzfNm8q4TviltsTSSmdzrA9i68lyKzARZ7KS1KiQW9xw/gxI0cctIwrMgnLifBy0R9jA1l+7bXkGucQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(23010399003)(376014)(36860700016)(82310400026)(22082099003)(18002099003)(6133799003)(11063799006)(5023799004)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9VrgcGIwfJEG5yZHZNalpv7T9tWBpaVelZYkrahtJ/LlJuBxNXpXo3EF6B1ZnFKUFWwkmIeNlNrAVULDS4wj1Jr6Lea7VhsIaGtVIzoTH9ccicBAvrT0G92xwTTX2AML0+dWmeFl/gJbz91kK2OGBH3zTZwmGJB9FB4GsCYzYAUhh0d0QOibL1ZQ+5z6rR4TsmLKiDjGzLoN4Mh6WMnkrfUFI+NcETj6doki1UlkaEDVYa1BiBwScgdjvMUvpbcBq7nxUH/giM8tYQVN3K4qhuZPkYHQ887ltfras6ilXV5zqDFursgv0+IuKffHM7CQmf9cKmF/QbpG1dW5OqERT8E0+JD+W1wmMs8EOQ/4ZmIE0+KhtmZL55CuiypFkUB2oGrX5kTLNZNXdwOsR6SSW9CS9AGlwIhhSjyctc/lvybUCJ89JZ210q7E0L6nEhXt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 12:49:15.4768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3982a7c4-77df-459c-14ec-08dedc262713
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019B.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8107

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjI0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIEZhaWxpbmcgdG8gaW5pdGlhbGl6ZSBhbiBJ
UlMgbGVhdmVzIGRhbmdsaW5nIHBvaW50ZXJzIGluIHRoZQ0KPiBgcGVyX2NwdV9pcnNfZGF0YWAg
YXJyYXksIGNhdXNpbmcgYSBVc2UtQWZ0ZXItRnJlZSBvbiBzdWJzZXF1ZW50DQo+IGFjY2Vzc2Vz
Lg0KPiAtLQ0KPiANCj4gY29tbWl0IDJlNGM4MWFhNDdhYjUyMTZkY2QzMzcxZDNlNmZmMzU3Y2Iw
YTc2ZTYNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29t
Pg0KPiANCj4gaXJxY2hpcC9naWMtdjU6IFByb3ZpZGUgT0YgSVJTIGNvbmZpZyBmcmFtZSBhdHRy
cyB0byBLVk0NCj4gDQo+IFRoaXMgY29tbWl0IHBhc3NlcyBhIHBvaW50ZXIgdG8gYW4gSVJTIGNv
bmZpZyBmcmFtZSB0byBLVk0gc28gaXQgY2FuDQo+IGludGVyYWN0DQo+IHdpdGggdGhlIGhvc3Qg
SVJTIGRpcmVjdGx5LiBJdCBhZGRzIGEgbmV3IGZ1bmN0aW9uIHRvIHJldHJpZXZlIHRoZQ0KPiBj
aGlwIGRhdGENCj4gYW5kIHBvcHVsYXRlcyB0aGUgZ2ljX3Y1X2t2bV9pbmZvIHN0cnVjdHVyZSB3
aXRoIHRoZSBJUlMgYmFzZSBhZGRyZXNzDQo+IGFuZA0KPiBjb2hlcmVuY3kgZmxhZy4NCj4gDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LWlycy5jDQo+ID4gYi9k
cml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiA+IGluZGV4IGYzZmNlMGIxZTI1ZDku
LjYwN2UwNjY4MjFiNTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMt
djUtaXJzLmMNCj4gPiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS1pcnMuYw0KPiBb
IC4uLiBdDQo+ID4gQEAgLTUwLDYgKzQ4LDExIEBAIHN0YXRpYyB2b2lkIGlyc193cml0ZXFfcmVs
YXhlZChzdHJ1Y3QNCj4gPiBnaWN2NV9pcnNfY2hpcF9kYXRhICppcnNfZGF0YSwNCj4gPiDCoAl3
cml0ZXFfcmVsYXhlZCh2YWwsIGlyc19kYXRhLT5pcnNfYmFzZSArIHJlZ19vZmZzZXQpOw0KPiA+
IMKgfQ0KPiA+IMKgDQo+ID4gK3N0cnVjdCBnaWN2NV9pcnNfY2hpcF9kYXRhICpnaWN2NV9pcnNf
Z2V0X2NoaXBfZGF0YSh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gcGVyX2NwdShwZXJfY3B1
X2lyc19kYXRhLCAwKTsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gVGhpcyBpc24ndCBhIGJ1
ZyBpbnRyb2R1Y2VkIGJ5IHRoaXMgcGF0Y2gsIGJ1dCBjYW4gYWNjZXNzaW5nDQo+IHBlcl9jcHVf
aXJzX2RhdGENCj4gaGVyZSByZXN1bHQgaW4gYSB1c2UtYWZ0ZXItZnJlZT8NCj4gDQo+IElmIGFu
IElSUyBmYWlscyBpbml0aWFsaXphdGlvbiAoZm9yIGV4YW1wbGUsIGR1ZSB0byBtaXNzaW5nIExQ
SQ0KPiBzdXBwb3J0DQo+IGNoZWNrZWQgaW4gZ2ljdjVfaXJzX2luaXQoKSksIHRoZSBkcml2ZXIg
ZnJlZXMgaXJzX2RhdGEgb24gdGhlIGVycm9yDQo+IHBhdGgNCj4gaW4gZ2ljdjVfaXJzX29mX2lu
aXQoKToNCj4gDQo+IMKgwqDCoCBrZnJlZShpcnNfZGF0YSk7DQo+IA0KPiBIb3dldmVyLCBnaWN2
NV9pcnNfb2ZfaW5pdF9hZmZpbml0eSgpIGhhcyBhbHJlYWR5IHBvcHVsYXRlZA0KPiBwZXJfY3B1
X2lyc19kYXRhDQo+IGZvciB0aGUgYXNzb2NpYXRlZCBDUFVzIHByaW9yIHRvIHRoZSBmYWlsdXJl
Og0KPiANCj4gwqDCoMKgIHBlcl9jcHUocGVyX2NwdV9pcnNfZGF0YSwgY3B1KSA9IGlyc19kYXRh
Ow0KPiANCj4gSWYgYW5vdGhlciBJUlMgb24gdGhlIHN5c3RlbSBpbml0aWFsaXplcyBzdWNjZXNz
ZnVsbHksDQo+IGdpY3Y1X2lyc19vZl9wcm9iZSgpDQo+IHN1Y2NlZWRzLsKgDQoNCkFsYXMsIHRo
YXQgd291bGQgaW5kZWVkIGNhdXNlIHRoaW5ncyB0byBnbyBiYW5nIG9uIGEgbXVsdGktSVJTIHN5
c3RlbQ0Kd2hlbiB0aGF0IGlzIGRlcmVmZXJlbmNlZC4NCg0KPiBXaGVuIHRoZSBDUFVzIGFzc29j
aWF0ZWQgd2l0aCB0aGUgZmFpbGVkIElSUyBzdGFydCB1cCwNCj4gZ2ljdjVfc3RhcnRpbmdfY3B1
KCkgaW52b2tlcyBnaWN2NV9pcnNfcmVnaXN0ZXJfY3B1KCksIHdoaWNoDQo+IHVuY29uZGl0aW9u
YWxseQ0KPiBkZXJlZmVyZW5jZXMgdGhlIGRhbmdsaW5nIHBvaW50ZXIgZnJvbSBwZXJfY3B1X2ly
c19kYXRhOg0KPiANCj4gwqDCoMKgIGlyc193cml0ZWxfcmVsYXhlZChpcnNfZGF0YSwgc2Vsciwg
R0lDVjVfSVJTX1BFX1NFTFIpOw0KPiANCj4gU2luY2UgdGhpcyBwYXRjaCBleHBvc2VzIHBlcl9j
cHVfaXJzX2RhdGEgdG8gS1ZNLCBLVk0gY291bGQgYWxzbw0KPiByZWNlaXZlIGFuZA0KPiBkZXJl
ZmVyZW5jZSB0aGlzIGRhbmdsaW5nIHBvaW50ZXIuIERvZXMgdGhlIGVycm9yIHBhdGggbmVlZCB0
byBjbGVhcg0KPiB0aGUNCj4gcGVyLUNQVSBwb2ludGVycyBiZWZvcmUgZnJlZWluZyBpcnNfZGF0
YT8NCj4gDQo+ID4gK30NCj4gPiArDQo+IA0KDQpJJ2xsIHBvc3QgYSBmaXgtdXAgZm9yIHRoaXMu
IFdlIGRlZmluaXRlbHkgd2FudCB0byB0ZWFyIGRvd24gYW55IHN0YWxlDQpwZXItY3B1IHBvaW50
ZXJzIG9uIGJvdGggSVJTIGluaXQgZmFpbHVyZSBhbmQgYWN0dWFsbHkgYXMgcGFydCBvZg0KZ2lj
djVfaXJzX3JlbW92ZSgpLiBXZSBhbHJlYWR5IGZhaWwgZ2ljdjVfc3RhcnRpbmdfY3B1KCkgaWYg
dGhlDQppcnNfZGF0YSBwb2ludGVyIGlzIE5VTEwgLSB3ZSBqdXN0IG5lZWQgdG8gbWFrZSBzdXJl
IGl0IGlzIGluIGZhY3QNCk5VTEwuDQoNClRoYW5rcywNClNhc2NoYQ0K
