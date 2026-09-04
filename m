Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011004.outbound.protection.outlook.com [52.101.65.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401F03955EE
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522519; cv=fail; b=cSVgjlfZpdp3vvZbzCdpo5uWBAe6dT+7fXR8GASb6Ri0VO/H9u1bTOm6KCbjIFxuY/pVpBS8IimzpC2MYrDb7087fYPekonJLnAE7N4SXmo9ZQbLj2Ga41aPlrTMBIfIarHuTwaV/xDKSiApayg2IL4e74Q1pgdDCsSzlUAPCRI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522519; c=relaxed/simple;
	bh=mcyWcFkMWt2nVz6DDzE1RCCqTezutGO4RvG7OV1u6uI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A9bYuL8wZNV8NtQo3lmVhI/GjyPQnUG2IkjtyN1Z0k2E+8zq++mY3afV1ocJ8YyL6iURvPg7sBaMvXlwSuq3hB1IMB7bUY0z1uNdngIO+WzQCLsC24PHmb8wY39dnXU73CjWHd4kjzH3nfepZPEsSGb3nd1wExCkbOmRRYlqxrU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k41Hsn4V; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k41Hsn4V; arc=fail smtp.client-ip=52.101.65.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k41Hsn4V";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k41Hsn4V"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Qoi7XCW6O/hqz8EuFKN3BSV7WJKpB7owelplG7ijyEiypg4EAymM/R8nOB5zBkH4d3xtvTfJyQF0zbFOT32O759ltS/9HvhSeh1T5tXR0BxP4mgKc7AToklmPdaX5bbwlIvaMT74RWs0Jxv4qRVhx6ff53LbawiqODBr0mGc4yTJBZmWnvRto7sA+vNGlfGWsIHfOP3HiUU0WhobWQu0+vlx5z2sPJWnbkfQ1XYmaE6artFgSEMuRUfcjiCZewSg95nMWMR0x3EbVrp+0sKlQc1r6t+ZkxxSUrYH4RJiZLfjugM80vg8I5SzALzfxYbBZ+tFpWTwgosfBmOPCLFXlQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+mRXYQI3ppqbKL3lnflfvphIaXv57cSo2LKlXgeMSY=;
 b=U/RUg1CVE7I5OylWl3sAR7xd9Orq1MioYg7nDkqblzN6jzIBIsoFP52zFptNZa4gaamWOayw9mCVUhsLBsL4E7SWptOCm82zZ/kCtlJwwmblH4Lw1scHr3XxJnKowYxQCuEWTcqNVyrnHBy5jsvJcaPZdlfowtRqWTt3orxwqU4WAHw9WpYzEGL6TsnH5zA2/ZB4xFdKy4n77rPwOzE6oK7CbbzbM1Jt5iCwm7NetLWfBW/kGEqlwrC/DlEQHfn7QejMMTVCXyqyb0NKKzBGtqt1KSzyk5LPKlem4IuArrMsGn6oH6vLeWTw7reyGmyxL0UZc3t6Qz1MZO3w+9RY9A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+mRXYQI3ppqbKL3lnflfvphIaXv57cSo2LKlXgeMSY=;
 b=k41Hsn4VoLZVezeFXG8bXZtuD2afcBrmRGjVavULkEjnwOhP9FLjPRgwl5odDwbvx6vBOZRdwUgpskvaK5qWyy68fsvpRPv3DfYSBV+/Y589FwSDXUDKqgvyNyCg59MyGzJ9ZaScPLJD1UlSPSyGF3T40oVF9YeH8NoTXJvBBHE=
Received: from AS4P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::11)
 by DBBPR08MB6201.eurprd08.prod.outlook.com (2603:10a6:10:20a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:48:31 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::3f) by AS4P192CA0016.outlook.office365.com
 (2603:10a6:20b:5e1::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:48:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:48:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMhc3PnGOXl+TM6Z7E3i/ZXmEtHOU5ypeOwdwRFz91ExjVI0gWa0iLnEb7MKxKpdPGFQ5YBmjD8Ws6UI/COZKLM6r1UYnTEoqAsNmS3+mdKvyBkI7WIYVCvVMHcp6unXmcQe9iCNpmpBtHOM1CDo0bpgvkKUlMjB9AK0eEMs7qy9DDbXdYey9l00n66tnjD4YmW/IfJa7q7L3YmciG/JhgVGeYqmMcPqjAEhwfLJM8PedZenyRL89DjY6ajF3//4myZcdMRB74d7ytdwPvE2OmhkHTrJZgdfw+uueQJc3JLMWeEymLzXf8oWyaJieb7ynaqbkh/j13JXqjElYeh+ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+mRXYQI3ppqbKL3lnflfvphIaXv57cSo2LKlXgeMSY=;
 b=rnqprqxR3CFES6eBrUcOePfmzkcr66IILOkBLZTHUgWO15WDcpCsM1Gsyo9rSBPGDhlpvssdm05FhuPcSnHm4O+saycSgltJevD51aYvHsY56R9tVAg4rX9BgoptzPH9S2SSLn8XoyVjddE5XCSnDt8tsTFDouu1mwdqNN+CGTT5Z+2fkUzwkjuwgb/p+A5xfctEPETEUY1sLhn0+GhPqaC7itT32jyVSZiXkxqBbUvYdRAG7Sbg0IsdodF0GdAB/a/qSuLjaVqEwVkPiA436aQfCOd3HkRDgXu6RWAFNaxVnLo0mVn4hSNqS5q39I5AqQtFyWC4tb4Dc8tYUgt5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+mRXYQI3ppqbKL3lnflfvphIaXv57cSo2LKlXgeMSY=;
 b=k41Hsn4VoLZVezeFXG8bXZtuD2afcBrmRGjVavULkEjnwOhP9FLjPRgwl5odDwbvx6vBOZRdwUgpskvaK5qWyy68fsvpRPv3DfYSBV+/Y589FwSDXUDKqgvyNyCg59MyGzJ9ZaScPLJD1UlSPSyGF3T40oVF9YeH8NoTXJvBBHE=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:47:59 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:47:59 +0000
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
Subject: [PATCH v6 27/49] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH v6 27/49] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHdPGM7ym2GJ9Cb7US0eHlgCs9DmA==
Date: Fri, 4 Sep 2026 11:47:58 +0000
Message-ID: <20260904113404.4051341-28-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|DB5PEPF00014B8B:EE_|DBBPR08MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: f81e964a-3c36-445d-ebb9-08df0a7a710b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Xwtg/dcT60L3ujoa5tF1OJeo9j8sOKaE3DumfBo7zUFQF0WLsIOLIueht73Fmw6tcVdKtVAlfGVzf8sGGvIE1IxiXNzkYnjSIvFVISmqcz1nLqYU0w1HX1RsU9y0rb4Xejd3s3jF2WST01jQ1k5Sd2Qle8KPdEMi8J0qzVLS8mNa0nk3U69mux/I8fqmdzB1o6Nf2GGdTPat/4YhvsHFyWoo5pso/qY51u7fsQKsRohGZfw/vtwlTDwAJsa9KXC7SfU+zJ177sHAzHSmeEUlr/DE6YNVo33WgLDCcnuiyTYhkxI+15vA9O6pyMvZ0UqaIQZ6pWU7ukf5Gna0gmGv+ogYTyjliPFSNUpYEIG2n/onJ5qJDqBvh6zDj+0YtLpDJO4P6HMlzYrcPcI39UITU7ApQGkJyA8p16RWWmfstyVomhJy02VZHOPyRIZeezL2iQjcM0Ahisb6e7J4e2kZeLJLP4YLdQizsf1Z04KgbNoMc8HYiXSBZX0SXnyEkJT86w44ZOHgqc3F3yq/R4ki7TMl/UhvBF2j/TsKDty7I/ExwM7y2edOvSdReF9FXlU1PNr0xkcq8BiKpKWlP5Fqso4bO+VC5tY/vck4pXMYtPph7imgpjAra80GAdl4fwDWpdjXkLXUXqr6r3MCnpTEDosH6nQK1lvQ0QCavR/ghHv45D8C1zIW7bg4S628Xp9FwQoXyTFiKzrKGsCbxGhQXOUT4q8MloNpeThz3PHtpo8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 NeTuImn8GgiE+X8gXpcdfilmqe8l2D83bwkf79c5Ui38DUw5kkMXYB0k+CjMuvSeb+5IGhOynYoiyROjLluAiwLIdWBluSzFEwMzanjZBdSEkLHjBy0UXdwRhEhXyni+VHCQx53XzGMunaAYWuL+s9LLzm1pT+DJfZng/3a5dBeDSgr50f5ZWLrPZZoMkn4MibwtZz2Y+hxlSd+OAVVxmXHpU9ShpDKNPx/IGlkNxDtEeMt3UME+YTXlkKUB8BcGebrLKXIvyjIgr6GeiPg13s1DkHbhJlUuhu3TT95hoTQyJjy36gJsTtMtxLhL8FkPccC49jmvp4mQcO/A2C3cCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	04af139a-2b91-44ab-4971-08df0a7a5e36
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|23010399003|35042699022|36860700016|1800799024|82310400026|10067099003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	bWIzCAumoBxAAU4IVFhq12OFvmIUUkx0ZRYNYfZ9NcOZtaMlPvzM90+KSIlneW3gaKJMecv1STasVvVEbyR0mpmrfrdIGwri6/cs/megUCMK+XOcYC188OyEH9FPBXm0cahWR+qKF2Wgb7pkfqiwx/uEIu/G3UMFC3s8BvEtOSGOgqigGzQtRHzauM7ZDtNhIIQpA5C7e2xgm11jzLV1EiYCyoGlv40WGjAZOJfe38ik1cdEiPd79fU+laC9kLHL2TYYF634b1abNfECX9jj22iU2eJetYXe/z1HMwQKCm1cdju3aqRfvuqky+lBByxn34m0Y/jkb6Nrm/JqsmKhv4NqVRCX6rg6YR+uiZLAnlVCHRFH6dGd9aP+Aeke0nIRJvsLpSQjErzqbWW8QBlPgzm3bVnfEUFzDLhjK9XJmDMuzT6HK9upJyrQ/5Nv+fV9PXPDL2lzqzxlXNdL/lqRezGbKcN6bR8FH/Nl4jz+BS5pwfOT5hvlq/hS0RJWhR9XevvDdiEFqnJBh/9JvoKu1FKNTo9nVCiXLGlNFft51Qa2sz9Z51/lgVMIZkh44GIvt1NVjx2oNdKbAbixY3RUFfpcc/+BQgjJFVat/ezz9ULD78yhlcxNm+Kmq1gQjquUZqQcilSd9+p3XxXDnSNHIS0bfswSgXfaeplXLCJbDnQ=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(23010399003)(35042699022)(36860700016)(1800799024)(82310400026)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nTUIqMe3bqLFJ5zXydPD++/1swpHp9eo7/w/Agnyj9ozVupKHfUX5XMWVP01arYju0tHwqLMFQteqISj4ewipPEyAvAJbw0b1RlNi8C8/Be95Df8lgTnYqwPX24qeRjBRJDCqNr0hvGCaSI3Lme6i0J7g2UWGnzl0LC7w5mDcj3l6/jRaMRpPd3oQoMovAvi5BIU1ewCw4ix9tNsI6/G1tQ6OS5ZQUpIU+Yqcfj5HUV8v2ai3PRJTTX396/iydK9xqNfFtdPgMTskRZdulXn78ChvIKqu8siYvJv/hagkhSf0bsbNKMWbbrYR1OKVANH3k5a18/ctC6XlXKbf/hwK8f1Jh7ni0+4zH4MJcsKkx4ysrvz55tsF2b3vET0BNUNuqYhcajAYY6ahwTKEzrnZb79G/riVxcDYvbv73trYU3wjqgZxF5+Fnoi9Y/KBREV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:48:30.7630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f81e964a-3c36-445d-ebb9-08df0a7a710b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6201

GICv5 SPI lifecycle is handled by the GICv5 hardware once the pending
state has been injected.

This change adds support for injecting SPIs to the core VGIC code and
GICv5 code. First of all, allow GICv5 SPIs to be looked up by ID via
vgic_get_irq(). Previously, only PPIs were supported.

Two irq_ops are used for GICv5 SPI injection. The set_pending_state()
irq_op is used to inject the SPI's pending state into the guest. The
queue_irq_unlock() irq_op releases the IRQ lock without queueing the
SPI on a per-vCPU AP list, as GICv5 does not track in-flight SPI state
in KVM. Tracking the affinity and lifecycle of individual SPIs in
software would negate much of the benefit of their lifecycle being
hardware managed.

Limit injection to the configured per-VM SPI range. Since GICv5 SPI
IDs start at zero, KVM_IRQ_LINE accepts IDs from zero through one less
than the configured number of SPIs, up to 1023. Update the
KVM_IRQ_LINE documentation accordingly.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 Documentation/virt/kvm/api.rst    |  3 ++-
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  1 +
 arch/arm64/kvm/vgic/vgic-v5.c     | 41 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        | 30 +++++++++++++++-------
 arch/arm64/kvm/vgic/vgic.h        |  2 ++
 5 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index e0430cc750c9e..f216a2e6d6872 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -918,7 +918,8 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_SPI:
 	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
-	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
+	       in-kernel GICv5: SPI, irq_id between 0 and the configured
+	       number of SPIs minus one (1023 maximum)
 - KVM_ARM_IRQ_TYPE_PPI:
 	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
 	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 35caf51d88310..06d2deb770a6d 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -708,6 +708,7 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 			 * view it is always enabled.
 			 */
 			irq->enabled =3D 1;
+			vgic_v5_set_spi_ops(irq);
 		}
=20
 		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 5a5abf51d4ddd..d8f106384c6e9 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1057,6 +1057,47 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 		    VGIC_V5_NR_PRIVATE_IRQS);
 }
=20
+static bool vgic_v5_set_spi_pending_state(struct kvm_vcpu *vcpu,
+					  struct vgic_irq *irq)
+{
+	vgic_v5_set_irq_pend(irq->target_vcpu, irq);
+	return true;
+}
+
+static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+					 struct vgic_irq *irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	lockdep_assert_held(&irq->irq_lock);
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	return true;
+}
+
+static const struct irq_ops vgic_v5_spi_irq_ops =3D {
+	.set_pending_state =3D vgic_v5_set_spi_pending_state,
+	.queue_irq_unlock =3D vgic_v5_spi_queue_irq_unlock,
+};
+
+void vgic_v5_set_spi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq) || WARN_ON(irq->ops))
+		return;
+
+	irq->ops =3D &vgic_v5_spi_irq_ops;
+}
+
+/* Set the pending state for GICv5 SPIs and LPIs */
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	if (WARN_ON(__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		return;
+
+	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, irq_is_pending(irq),
+		     vcpu->kvm->arch.vgic.gicv5_vm.vm_id);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !READ_ONCE(vcpu->kvm->arch.vgic.enabled);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index fc88024ca3a5c..62d273946c318 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,20 +86,32 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u=
32 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
-	/* Non-private IRQs are not yet implemented for GICv5 */
-	if (vgic_is_v5(kvm))
-		return NULL;
+	enum kvm_device_type type =3D kvm->arch.vgic.vgic_model;
=20
 	/* SPIs */
-	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
-	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
-		intid -=3D VGIC_NR_PRIVATE_IRQS;
-		intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
-		return &kvm->arch.vgic.spis[intid];
+	if (__irq_is_spi(type, intid)) {
+		switch (type) {
+		case KVM_DEV_TYPE_ARM_VGIC_V5:
+			intid =3D vgic_v5_get_hwirq_id(intid);
+
+			if (intid >=3D kvm->arch.vgic.nr_spis)
+				return NULL;
+
+			intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
+			return &kvm->arch.vgic.spis[intid];
+		default: {
+			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+
+			if (intid < max_intid) {
+				intid -=3D VGIC_NR_PRIVATE_IRQS;
+				intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
+				return &kvm->arch.vgic.spis[intid];
+			}
+		}}
 	}
=20
 	/* LPIs */
-	if (irq_is_lpi(kvm, intid))
+	if (__irq_is_lpi(type, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index da682092c658e..7b4ec72bcd02d 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -387,6 +387,8 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
+void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
--=20
2.34.1
