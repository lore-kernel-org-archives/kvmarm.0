Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010018.outbound.protection.outlook.com [52.101.69.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A149B4746BE
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522732; cv=fail; b=YuOhZ9rkwAWDH6Ur5iMx81DDFhpGPfT0fvuzw6Pc+M6N+8/BbNcb8JzwWXPKXKMySBU2XcCB7zppiZGlwBSFkyh5G5z+qmw1jGPPugbXzbs+9m9q3ku/iXd+TuWgUWvA0WY0sgbD1KG7GvxOTTv+QPMXa2mEGnHu/RIsAG8gjyU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522732; c=relaxed/simple;
	bh=nYPyPZudFJRQRWYuLxifcCoMNx+qQcIkH4iAJfd8ixM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TCPuT7mh0RnqyRsLw6XePd0l45xOTnhhCLNg20q5klqD4Kh/t5kBKPGkEkNViWl1/dD7+HcS8nYbTSunLCY/ZHtTnYnnoUkiHzgnoVxi47mwamEdX5Oo4EXL65PRfAjj9jXRypE0Va5UibDThEsrYF1kWsi6tIvxq9f6dNc1Rlg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XrFpvors; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XrFpvors; arc=fail smtp.client-ip=52.101.69.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XrFpvors";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XrFpvors"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TCINO6m4mTT08bhiJeUZjuwmbgMRKChTqM+CfgeQLjlRCHJYDvo0OhdtiKLMx6W8ItVUxh7KSwZNMcC9xy1nOn7cAD99VP1sywGEhOU6s2rrcQagzYpxQqpVkXGMhUbrTi5+QL52zw2Pd2zbHRmcm+AfZ4ZjUWEX00GYIMDl1aZJOqdHh0VqmM6w0eQjr9xQmlhxAiFInQRzTHbMyn7e7dqZFrcME5xD92il8Ms9ggWkq95yWf3dUJwQwZ5IOj98EVKrO3MFE6eKg2+e5ekJwIfbRhcIe5zi1rGC8Dcio77IjSIcff/112uuq/PDXsSipxcPYgINMokNp+zc1d82kw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPYK1OQswQDYn7w2zKJvVCZABeIcMXfS+b/ikG1jvrI=;
 b=IhgB2s4AmHBiRV645DxHC/MsdsWSEyNTK3Lo26UbCtHvQxGuICeIDUzOgYICvje8LL9aDQj7Hiis+fD2VriEvTOPU+4NDtyEiuQYsRS/pajkKQ6gBgsBwWh2s9nvXFARcU7gElPd8XiiZnRJSVWKEQuWgsedcliPEj8BIGBrXSV1+dK/7OILL1FnLZdyu6lRe4uAqhgYlDJJM3hZSd2y6r5QnCQnJMeqVu03EKbPVFI4KukzpvyPcmwNiZT4p+yOVD60pdcgTFxxExLK4Fodfbrw+GDpaRleCOGAVWaMd0gM/K9vA0L5IYForchq+BL3f/54AaGA9Vf/YaeImG+zmQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPYK1OQswQDYn7w2zKJvVCZABeIcMXfS+b/ikG1jvrI=;
 b=XrFpvors2T5MrkBgjII0hO09EZeq1RQjd3Gh8+HiOnede4GgCuJy+BKNpsrhQwFEqo8Jsa82K3fzKh0AbpLOeR1p58vPpVNSVBr6Kz7fBNQXFLV0MdRG0Cku0mtbS0B69gKmEYNWUW/mZrNOYzOZzeonOc+SzFnSghrvtc59cHE=
Received: from DUZPR01CA0009.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::16) by VI0PR08MB10845.eurprd08.prod.outlook.com
 (2603:10a6:800:211::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:52:05 +0000
Received: from DB5PEPF00014B99.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::12) by DUZPR01CA0009.outlook.office365.com
 (2603:10a6:10:3c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:52:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B99.mail.protection.outlook.com (10.167.8.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:52:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TucrZron6FcCNHrHNjtjuQCtJ0aQZleZJz3bQsIy82617zcTrytElUYFgLd0MH/vhMjHcjNBPM0m7peWDMnW/1z4JpsiPNBpT90Sdr9B3ji7JjnsQ6hDezGQROIYm7zAfwzioxZpQNBykH+mPD+6q4KW7kWUCWzpE3h5tuxD/F8NGDQZwDTf0amKqOvSZ2cjnhHgEjDQ6E76Ln2xsdFwuZ7F+o6vlYN4Ipgcme2hqWCocF9gv4E/Cih4KctTdWf8xI9dGw2MVNQBS4QRrqHU9bTevA3Ew8g6fAheoxsO1h7gWMl0WB9JO19HzDDuQsvanXaWUD5PRFhgvWmEIg1row==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPYK1OQswQDYn7w2zKJvVCZABeIcMXfS+b/ikG1jvrI=;
 b=m74Mzyi64kgvIDUmgBlOpUOgNr3jlQ7W5Hzw58HhYVh9X5KrbTgXRh6Y/801zEjb48w/RdoC8uNEd+aM2w7sQ4PR1xWJ3nzq+hqJ99HRAVoxcSKQQlIMEC3PAYQN0A17zgxFAw4NIDoKwTEktuk4DGLQPtI/vEPkQ8hoR/H73eH95gwpBva/xh+ik5juynnstK4YKYiy2Dde3ACeL27teMb11bfw9NwKHjoBXDOb9HcTQEFn1uYI9KNvsih4nPjWgwmqg5gKUrv4CXFt3xDkrQkBgBPLSWbexo2SFj5rVvvt0omr0cWOSl0ZNQF8t0z0hKjNmEvltZOwLdW/X+c74w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPYK1OQswQDYn7w2zKJvVCZABeIcMXfS+b/ikG1jvrI=;
 b=XrFpvors2T5MrkBgjII0hO09EZeq1RQjd3Gh8+HiOnede4GgCuJy+BKNpsrhQwFEqo8Jsa82K3fzKh0AbpLOeR1p58vPpVNSVBr6Kz7fBNQXFLV0MdRG0Cku0mtbS0B69gKmEYNWUW/mZrNOYzOZzeonOc+SzFnSghrvtc59cHE=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:51:33 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:51:33 +0000
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
Subject: [PATCH v6 34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
Thread-Topic: [PATCH v6 34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/restore
 UAPI
Thread-Index: AQHdPGO7lIHY7Mgy2UOfc/vaqC4m7A==
Date: Fri, 4 Sep 2026 11:51:33 +0000
Message-ID: <20260904113404.4051341-35-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|DB5PEPF00014B99:EE_|VI0PR08MB10845:EE_
X-MS-Office365-Filtering-Correlation-Id: 691b70ca-a6d3-453e-5856-08df0a7af109
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 RLN5ENrKlt+rIH3u9/J/YyoQ/mRU39RIPzLT8Fov+AcGDIHJLkYqos0ZLzTESO2GUS9ptvCFoO58lqGavmjB4wIA4c7WScda4+/nvLQBiVKlb3HLf3rzluIH26tPVR1vx0aKTtlx8g9jIcCBEh8dwFEOgrBTqVsHRCqqcTULNz6HIc8A4qXyk2ehGE76xfJAX28BI/qbREHBhID2bpwQ5WAbVs/1Az0XXagTyrMtj8/DqZuVUc7+JfsCXyVwkSxWoLUH3wLOgkUL7XdMKGlY0EGnszTq/GaRtGzajW/i/qRAKi0CRBVwYijZwtWKUESbNrJQzOBllJuLvgThBxKfHUNrnZzemqUKP9KfHGKRIL3QtYyfajFI4zaU/R7712Hr2wS5y/bEjcX2bt2LBzkeJEoSKjueyUZxG3F3gwbQ4BgoPqsUAoPuU9WBMJOsZ1TfShcTWWCtJer0yii5OUM3LiQ0LQfEZ3ZmmkF8UJi9LzQ/Sm7cmck7JWFEXq7zAKSeR0D42xLSMCE5WHuxVAgnd6vi5NfEUcgFNpVmh5EgY84oDR4OUqazykAH56CHprH6z6qBm6Ljk+wCdxtj/Qt69FZ9VYT3Y/oWTpAYQ2H1oB1y+xcYQV9BU3kE+9uNGUWA37l8xsCcUA4kIBKjUTmve5FAEwBm+nFcpCeDXNckaii8rgH9Q6om2WPqGpgf8pdtoPVpS8Bnq4cNwXq6MFmyMYJdBLloCK6gQsyyrsaSnzk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 d1SDgu8vqayGQ58pI7UP885TC7MKdaYK4dqSyYKRfKfzivKgbdHC8eIm4kdCAxiFbjzh2WIIt6MwR6gdj4g6AiCV5e84W6UjsKeeH6Av4mqgsASKeXZGVqKYbcfLqVtZxRRemhrauFohOB4xSbx3P5Ikgidu3QFNNjfvTXG+YgMiFIkHgQC0fEC8nrqtQAOjlLeYRmd2tYwY+SIR173J5tzEcH/zrmKwULBI3j39PzWHwz0Hm3GsZEt/BNtwtobtPti1/C6FoCpMA09JyU7KTYh9ZU8ZnO7C4F6eJLpI6nwlo/KW7oF7ck2jrjKEeYHm4uEQpRI6qDQUIbLovs2TIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c74b470c-74ff-4d6f-2421-08df0a7adde3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|376014|35042699022|23010399003|36860700016|82310400026|10067099003|11063799006|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	3jWAVI5gISuPoBhxLrKnmHs+A3N8DOKT9HNHF9pRkGyUDqzXOm4zuuXyuZyZARCzJVfssS/l9zESF8Z8sr1T6MEdkqRfuoSTm59+tbHKsgoduCiwZwSp5o2rsgURj5QCVjIWGdcDn/rhSqYmQFORIK2AIw7H5iFx6Sa5qgTX/PiXX00/3EUfRbiIm9YR/HbFLOKcWig5QpsxiIaBbSyoQBrhHCgYLXsFzeC+gB1K9cv816WHMuXbThpOJAoxQ/xj38v2BYwMGV0oAQJbNcCGUkostomVHbe0jlCP3fmEK6uECXwcEGNZV/k2vQYUQVWbaDG8+SWJyTckoskyOFB79FMyeta49syt9Af0TbxLqPbm12CpGZPwRYOCxkhvLuh99qAvz1IzKR50/XxDwwgtPWWpwBErQ5NH387CkfqP55cWAv/QI8frlwG2NPTqwM/d2tgVK56YrAUJ3pe1tGVvLD/IuCopIjCQaGoTlDmy2YDi9Ue4Urxp+1duBe+1PQ65lUOk2je+gLNYEBfL4FGyw6GU+KumQQXU+FAB1b+DTzBfm8WxtIR3ZCtbwHhq2sFF5r8HHbbu5S2KE8zy0xrlRrUAWRdXS+ztZaxdOVaUaB+JBLavvKJIBn6koTDXnCJZlr0Hi7NOM63DOWjTiyqKYjjOpcDM0HrnjtTrB3eQQvw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(376014)(35042699022)(23010399003)(36860700016)(82310400026)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EEgJqlfvWk0YfzeYAbltaIxhVEiZSXrUOmmMIlHp5L+v0t/KJp8D7aBocTGp+2L2iDoumS7KD8hl045l1RJWSTJKz87/5mZfp5jzrC8t1yr/vBksdNtNiRbgiG5hexckOkHadoZQohXrhFYJA2UEqnIVtrJV7B21Pa2ptJZPOkALfAcL4H7iHuJUSYY0EMJTL9LBWN0X0Yhx3kPf07vAkb/QWSeMr/FqTxg7HORpFRBXYCMX2QCj/i6STQ8ACycSUvY5pIkxCZtDsIZe4RWXJVmoD6OnIaOFUpU4gl9bm4o/UnNfjpJSvlmMpZm+h1IQMmQHKyqj/6fUzMZn/ThyiePI8inbEkc12X2t7Mqn+Qfhtb/6KplKLsKiHcJnikaKf8hsoHnwBV0pdp90tumeJRA+BsFIo20vbWwEBphPKTOt0/FHDbeajCY8kp5yxWtZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:52:05.5077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 691b70ca-a6d3-453e-5856-08df0a7af109
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B99.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10845

Introduce KVM_DEV_ARM_VGIC_GRP_IST as the VGICv5 device attribute
group used to transfer SPI and LPI IST state between KVM and userspace
during migration.

The group uses struct kvm_vgic_v5_ist as a descriptor for the
userspace-owned SPI and LPI IST buffers. Each buffer contains the
architected 32-bit ISTE state for the corresponding interrupt number
space, while the host IST layout remains private to KVM.

The descriptor is architecture-specific, as it is only the payload of
an ARM VGIC device attribute.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 9 +++++++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 8a023ab54bff9..65ee09bd14636 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -424,6 +424,15 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
+
+struct kvm_vgic_v5_ist {
+	__u64	spi_ist_addr;
+	__u64	spi_ist_size;
+	__u64	lpi_ist_addr;
+	__u64	lpi_ist_size;
+};
+
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 710a0d267347d..9998252ea8ec8 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,15 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
+
+struct kvm_vgic_v5_ist {
+	__u64	spi_ist_addr;
+	__u64	spi_ist_size;
+	__u64	lpi_ist_addr;
+	__u64	lpi_ist_size;
+};
+
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
