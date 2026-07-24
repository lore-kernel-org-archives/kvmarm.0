Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012054.outbound.protection.outlook.com [52.101.66.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB1637A82A
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.54
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890827; cv=fail; b=cNu73qKpYcKCu/gzgjXxiy7siu1lNbtuDCNHzSmpfxfzzFm7ffvSAKJANTM5vKf9eR9epF+vs5XzrDDKKgIfB67q2ZXpb0EAFXnG+XM6AZ97joeyTAxEvLPK89pJW0GPE3tHaSkjoii0RU5vlW1YySX5eLkhCdrUHlhqtv+A69o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890827; c=relaxed/simple;
	bh=Cn1dca57KtJMPQGb6pylGVQSPhZGcpmCxnuhXIXP/qc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jdJCBNxkzv1EzIjwyCV0zyNp/u+qZtHcaH6kmCDGRkFEfnxtp7dTU2PvbSHpR8NHMB5+UGz+dMKuHqhseedRcA0UNM9S3k7WDJu+zcxK/m8Rgo/CH1pzA7SLE2ZBKGwlPyK+S1eblZaltYhgErPkARp5BuHyjNe68XCViFZQwwU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nEip9E+d; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nEip9E+d; arc=fail smtp.client-ip=52.101.66.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nEip9E+d";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nEip9E+d"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KuJ+AR4Abn45N0gjXe/c4e2kDDn6WIl7jC2jfLTME5HGUZnEoCG1jfq6/CENpI9oJKI/J54mtEvcFjiEIUXAbbFvhKZwZfc7m6SzFICTfrcBkFG5MQ0kLm+KPOLPDyMDIgng9+aKbzcZyskUoVdaIwStRI3zsQIYjr6AXlucbOzGp7OboSeXzKVdF8H9XBa7XfTskoehvXmWH42+7Ky6QX6tLc+9BaejW/4DIchx1aBflS69UnfSRII4ckT6wDp1SbqLZz6bSp8vZXJfrMzY8EB+L0aIVdlVAkEFmDNb2/Zet7CmQzZSqJeqEQy069C2aT21YYeU8VlF4TYYxpT7ow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCvfcXYJtMjz98Ky2+X3nmwW7vrAwX03ktFiRQvyw6Q=;
 b=ThAn3yyhCca+0TLT/ZZFdo0BFcCWwiHP5Q+btky6L4uN61vmp75x/bbjUaVptXqe71HM84nCEJHaJcwWSxdt2x7Wf/hZwdWsP5NhELgyAB+Bm9OSt7+LZbf+CAuxPUf7iJtKgxEYz/InOfOod9tUQDzU9DzdLgyogWwap4FaMQg6T098Wjy18mPAFthKylz7lzMITUCumPXNzKa8yA2FbIa6zyOmJBcimWwFftATvR44L61o/4/NL6ZZSh5AZSOlSwsKykZqm+IFp1DcguLtUAC9HrV9AUrddf6rCMLIf1F2bYbVCNjPG/ogAiD7XZ1NLXW9xq977tMjFGC24p3YQg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCvfcXYJtMjz98Ky2+X3nmwW7vrAwX03ktFiRQvyw6Q=;
 b=nEip9E+dV5/cLrUYuOHM/v7MCYDYpk+BG+EPoo5TEX6nb9TaEowPQJ/JkXcySuDom0vth0VYENpdkQogSBkOmVDorLLGW/HJ9mj2qgNvDau+Zj9idi6TU7FSJHVdN550f089VHhtvUz0T8qI0D9UYdItbucFl07EJZ30T6sOMk4=
Received: from DU6P191CA0064.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::24)
 by AS2PR08MB9074.eurprd08.prod.outlook.com (2603:10a6:20b:5fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:00:18 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:53e:cafe::1f) by DU6P191CA0064.outlook.office365.com
 (2603:10a6:10:53e::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:00:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:00:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YD3QfRLysPvP/bdCgvdkavmAIWUiYi7DRohoXFshlbd6wKe+rxyslbmTAvtMrmX4kV0jxKuBL2ER2+o9YL7glg5ZYBBhYcdXghmuvPzkHmaRJqmrBNLHiK1+lEkiB1DeiWKkUSqq2X/c0jGi5Y6qObYm2A19LPPhsXAnvLK/isMgkIn1A/Q77YSxyubejh4LXzw8IumIZ2XVGF37+2r2MmhXAg7JO3RJGN7Jb1kG2U0OqJnSDEz52u8mog4s8l1z+KlCtddeTvZK0YRF5Elt0AMcrBxmDbuBDblu5cynMzYSHEL7KJEWSagB23Fas9jdHOR7i7lA0BKkG0bxBN4qpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCvfcXYJtMjz98Ky2+X3nmwW7vrAwX03ktFiRQvyw6Q=;
 b=n32w2ICEbIVZ1olTZINLwFHEdTgE7mS9rXmyOIKPBt3pX68xHaskpywssRl4uQLICEM27cTxZsrM4koe3y+gV39qPwUH8lmgFXCVq7MvlKqhkUVrHrRb3EXnt/EDhY38BX35lxgUPIT/AsLM4TWgna0Y4bzx6TmwsZZTFQQ+uSaNdvwD/CvU9uu5vKFszThcxpw0ReuALt0nuHbDan4OogSgYwh9MVXNS2sFQR8TkqVoFdBwyzU1asG2qkexRd2FHprLr80BIT5WspSmDlumWtWiMF2rfEfOql36CRBcwwlu6JABHnKXG3UWHboq62lCZ1b7KUR1ohVIQ84YKJm0ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCvfcXYJtMjz98Ky2+X3nmwW7vrAwX03ktFiRQvyw6Q=;
 b=nEip9E+dV5/cLrUYuOHM/v7MCYDYpk+BG+EPoo5TEX6nb9TaEowPQJ/JkXcySuDom0vth0VYENpdkQogSBkOmVDorLLGW/HJ9mj2qgNvDau+Zj9idi6TU7FSJHVdN550f089VHhtvUz0T8qI0D9UYdItbucFl07EJZ30T6sOMk4=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:59:14 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:59:14 +0000
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
Subject: [PATCH v4 42/48] KVM: selftests: Add VGICv5 IRS_REGS attribute tests
Thread-Topic: [PATCH v4 42/48] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Thread-Index: AQHdG1t3ostYOtK2AEy0gxJGN9mWHQ==
Date: Fri, 24 Jul 2026 10:59:14 +0000
Message-ID: <20260724104819.1296803-43-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|DB5PEPF00014B94:EE_|AS2PR08MB9074:EE_
X-MS-Office365-Filtering-Correlation-Id: f8b84fb5-342b-477c-1e48-08dee972bf29
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 Y8mfNi4OtMYMJA3n1/oV4R8o6jP5m6U1gW0TW4PjehaGyFFYlCkyQh/AJDZsLzLKJ/viDsejxUM1j1yX4mAOyXfBchC/vtevS56dK5ebo/mV6hWG6MIegUdZdIQFfaG4ZM9gOcXBFItRGHWmkIHEWiHGDUJ46t7akGIv6hb/rYbYKxRS3PDo/2VK0LBlzRKzLFwyvk2kvGXAi9zfrheTG94EFTxyPD0mQb2NBh3n3raWiURnTpyZhHAa1wUijhFjtWBorj3S8efKuygm8GmlJvitpWnx+hsOobv1iwMO2/tE/eSEsEy/L6tKl3tTWQRFDZg1aFTmjZ3SQBy9TTQb11pKAVyW4Ne3QX33y9Mh+kDOuyAbBh/8AgpouBMnfctHYnhJTSNXrICrEzaQCM8C3vTWdv31NhPu/m0jUJ5sL1HNJ1Lg/9AGBX0fIIF4vpKeM/mWOa0Pz9jP6J9i7thbxDeYk2VIhox/RdYiGxQFIUdzP9rT3K+xl5ma8Ek6wPqzlN7qp0coYAIbm1P+yek4SECRxJ41mtSMBRcdAkc/OmKbDl7zB342+6w9t7WUBqKPuXd06ARnhB1xZ/XUjNXTI+U/mbiMhHish5luL4yLzdwOKwIUwQUp8jfRpphE3TnYKWLHmKH8fJD7/AbKvTwSZxieOmoMydOKLCOob1WLXe3xhX1fPaBNI11t9dcQ+KP8zD4/upPeLvyqXbh2k8Jw2AK1LfU5+Bbu2PtZqmvyJsw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 CgJjsEKqi79o0dfLcj/ThTPZm/8zTEKgtJEH1KOqC05Dhk3RSNB1ak/kMbCOmm1IUyMqqLd5HpRthZfnJ4ZT8pJmU+DvhpzySQhRD00YDij4rEAIw/7ZayQyHxnaTScwpyNs7cyHDDCVXZZIGwE003g+Bv1e9F+l0TsdLprL5P0bB14VeVDX2KjhZTVy9QON1+ufm8pVDrn7rte7n70U/MwqC7X7d6EglmjphxCIe+x7q9IR31OzagbpcktHLwPczlYK1Q99oRSw6uUhw/gK5JAUL8CkbC/s4hK86Rp8utspf76iOkpHRhYfue5ViOj3ZzVOdyCpGyV2vLi5svNR1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4bcc7ae8-1776-4528-4ad6-08dee972999f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|14060799003|1800799024|36860700016|35042699022|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	AviDDZJOwM3/jx4X0D9NZOwtTpfm43u8VyHhUGzREm2EstALp+AokigqUCupuL2j+Mp0xIQ+84TjA51/fNfR/LJOe5FtsrLic0irg3C6M3DrEawI6XP0ClDpuPr4VYL96xxXeD5/tv1r40yMVsIUgcZSKkszKUeSrot3Sb0lsKporO/AKkNZMG74bcXsuqJ55XPzJQyF84P9M01B19XK1RUZaqx2DEyAnXNK+V5dJ1Eq+Qp98BrM/cGJC8sUdMqe3ftmAHvquSJycEXBbvonvBD6O0gyXlttZ/S2SlG17ShriuxK5Sc3Op7ZIZ0CvrFXJtvdNH63526rlGgqePexDzB91IgX7LoEhOyNjAe5QvNdQeA+vY5oarWbMfM0bwQ8an6QyCr86Fm9ujPUcK7kkScRScW+ztlY0iIRQpf8GeqCtJYAJhj+cDnQR48K04LwhdB7f7Kucxo2y0hN2RMPaO+NJQuxj6NcmMN4nygvU1JJ/UngM4FJbhOfkvVRRarEYgeAbMDgB4dBDMGBZfmTx54BPIOLuYvn2IYR1JZAi9R+q2U66gufYmDkveCyba6CJDNOljgXgN7d8cErcvDsYIfAxKzKZPCYrESJTVp+4fcGb/CPOK/8WbhmUXRvUk5bpYbkPGscDsePeIZ/5uKnAOl6DJYii854SZYQA9a8bIAw/HqIhdyJf4cCLQCxFCy5rDwOS5A5WGt8fv8fxa0FsQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(14060799003)(1800799024)(36860700016)(35042699022)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	veIAr4JKeg+64EY/kLEOxqDJDCr1sj9/khQGpcyQ/UY+1MF7mL1+CcUbiFsg8SjyUG98Xda8heulVFSlQxFwf2qyF41cAy8x2Up4Pw6/+uMbpIGmkDAQV1ioXX2lcTJ0g2PP5aVdjZRK77eGpwcLKRxb+Im4WJfBfZgvQZgmBpkL2TMmBuzupQUBfTKL/7rsa4LMuowMG6pfvnoVPqw0hCK6Gs6kWfkYmXHXoU+8WIEYulXZpJu7L4HXyV/nq5myaqLXkeSKd5e3qCWSSGR6SLRqpvhbJs+nhTf3zQcC49pI46g7T/TgYft0Vc9st8Upajj+NjGGZw1EuJWe4PP8sFysvEKkrRxsLFy8qCpunMSkMnrD0UJ/yiU8PpWt5/0EzLSr896zAYQhQMq7x7jSAYAEitQLBJmbbBbIkoE7GyXGvDuGd9VUkkaOJmKZuuoH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:00:17.4610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b84fb5-342b-477c-1e48-08dee972bf29
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9074

Add coverage for the VGICv5 IRS_REGS attribute group. Migration needs a
userspace-visible view of the virtual IRS register state, but KVM must
only expose valid registers and must reject state that cannot be restored
safely.

Verify that IRS_REGS is unavailable until an IRS base is configured and
the VGIC is initialized, that all exposed registers can be read and
written back, and that bad offsets, bad alignment and bad userspace
pointers are rejected. Also check ID register restore validation, idle
status register values and IST_BASER restore handling.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 249 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      |  72 +++++
 2 files changed, 321 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 95d74f501ef09..ca03d1cb6a2af 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -109,6 +109,72 @@ static const struct vgic_region_attr gic_v5_irs_region=
 =3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
+struct vgic_irs_reg_attr {
+	const char	*name;
+	u64		attr;
+};
+
+#define IRS_REG(r)						\
+	{							\
+		.name		=3D #r,				\
+		.attr		=3D r,				\
+	}
+
+static const struct vgic_irs_reg_attr gic_v5_irs_regs[] =3D {
+	IRS_REG(GICV5_IRS_IDR0),
+	IRS_REG(GICV5_IRS_IDR1),
+	IRS_REG(GICV5_IRS_IDR2),
+	IRS_REG(GICV5_IRS_IDR3),
+	IRS_REG(GICV5_IRS_IDR4),
+	IRS_REG(GICV5_IRS_IDR5),
+	IRS_REG(GICV5_IRS_IDR6),
+	IRS_REG(GICV5_IRS_IDR7),
+	IRS_REG(GICV5_IRS_IIDR),
+	IRS_REG(GICV5_IRS_AIDR),
+	IRS_REG(GICV5_IRS_CR0),
+	IRS_REG(GICV5_IRS_CR1),
+	IRS_REG(GICV5_IRS_SYNCR),
+	IRS_REG(GICV5_IRS_SYNC_STATUSR),
+	IRS_REG(GICV5_IRS_SPI_VMR),
+	IRS_REG(GICV5_IRS_SPI_SELR),
+	IRS_REG(GICV5_IRS_SPI_DOMAINR),
+	IRS_REG(GICV5_IRS_SPI_RESAMPLER),
+	IRS_REG(GICV5_IRS_SPI_CFGR),
+	IRS_REG(GICV5_IRS_SPI_STATUSR),
+	IRS_REG(GICV5_IRS_PE_SELR),
+	IRS_REG(GICV5_IRS_PE_STATUSR),
+	IRS_REG(GICV5_IRS_PE_CR0),
+	IRS_REG(GICV5_IRS_IST_BASER),
+	IRS_REG(GICV5_IRS_IST_CFGR),
+	IRS_REG(GICV5_IRS_IST_STATUSR),
+	IRS_REG(GICV5_IRS_MAP_L2_ISTR),
+	IRS_REG(GICV5_IRS_VMT_BASER),
+	IRS_REG(GICV5_IRS_VMT_CFGR),
+	IRS_REG(GICV5_IRS_VMT_STATUSR),
+	IRS_REG(GICV5_IRS_VPE_SELR),
+	IRS_REG(GICV5_IRS_VPE_DBR),
+	IRS_REG(GICV5_IRS_VPE_HPPIR),
+	IRS_REG(GICV5_IRS_VPE_CR0),
+	IRS_REG(GICV5_IRS_VPE_STATUSR),
+	IRS_REG(GICV5_IRS_VM_DBR),
+	IRS_REG(GICV5_IRS_VM_SELR),
+	IRS_REG(GICV5_IRS_VM_STATUSR),
+	IRS_REG(GICV5_IRS_VMAP_L2_VMTR),
+	IRS_REG(GICV5_IRS_VMAP_VMR),
+	IRS_REG(GICV5_IRS_VMAP_VISTR),
+	IRS_REG(GICV5_IRS_VMAP_L2_VISTR),
+	IRS_REG(GICV5_IRS_VMAP_VPER),
+	IRS_REG(GICV5_IRS_SAVE_VMR),
+	IRS_REG(GICV5_IRS_SAVE_VM_STATUSR),
+	IRS_REG(GICV5_IRS_MEC_IDR),
+	IRS_REG(GICV5_IRS_MEC_MECID_R),
+	IRS_REG(GICV5_IRS_MPAM_IDR),
+	IRS_REG(GICV5_IRS_MPAM_PARTID_R),
+	IRS_REG(GICV5_IRS_SWERR_STATUSR),
+	IRS_REG(GICV5_IRS_SWERR_SYNDROMER0),
+	IRS_REG(GICV5_IRS_SWERR_SYNDROMER1),
+};
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -285,6 +351,185 @@ static void test_vgic_v5_nr_irqs_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_irs_regs_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 attr, val;
+	int ret, i;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* IRS_REGS attributes can be probed before the IRS base is set. */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+			    GICV5_IRS_IDR0);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+			    GICV5_IRS_IDR0);
+
+	/* IRS_REGS are not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IRS_REGS get before init");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IRS_REGS set before init");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read all supported IRS regs and write the value back. */
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		attr =3D gic_v5_irs_regs[i].attr;
+		ret =3D __kvm_has_device_attr(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS missing %s",
+			    gic_v5_irs_regs[i].name);
+
+		val =3D 0xbad;
+		ret =3D __kvm_device_attr_get(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS get failed for %s",
+			    gic_v5_irs_regs[i].name);
+
+		ret =3D __kvm_device_attr_set(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS set failed for %s",
+			    gic_v5_irs_regs[i].name);
+	}
+
+	/* Check bad offsets */
+	attr =3D 0x10000;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS_REGS accepted bad offse=
t");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS_REGS get bad offset");
+
+	/* Check alignment for 32-bit and 64-bit IRS regs. */
+	attr =3D GICV5_IRS_IDR0 + 2;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unaligne=
d 32-bit attr");
+
+	attr =3D GICV5_IRS_IST_BASER + 4;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unaligne=
d 64-bit attr");
+
+	/* Check bad user pointers */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IRS_REGS get with bad poin=
ter");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IRS_REGS set with bad poin=
ter");
+
+	/* ID restore validation rejects unsupported values. */
+	val =3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM, GICV5_IRS_IDR0_INT_DOM_SECURE)=
;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR0=
 domain");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR0 failed");
+	val |=3D GICV5_IRS_IDR0_SETLPI;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unsuppor=
ted IDR0");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR1, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR1 failed");
+	val |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, 0x7);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR1, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR1=
");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR2, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR2=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR5, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR5 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR5, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR5=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR6, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR6 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR6, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR6=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR7, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR7 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR7, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR7=
");
+
+	/* Status registers read as idle through userspace accessors. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_SYNC_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_SYNC_STATUSR_IDLE,
+		    "GICv5 IRS_REGS SYNC_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_SPI_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_SPI_STATUSR_IDLE,
+		    "GICv5 IRS_REGS SPI_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_PE_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_PE_STATUSR_IDLE,
+		    "GICv5 IRS_REGS PE_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_IST_STATUSR_IDLE,
+		    "GICv5 IRS_REGS IST_STATUSR is not idle");
+
+	/* Userspace restore of IST_BASER updates state without allocating ISTs. =
*/
+	val =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+			 GICV5_IRS_CONFIG_BASE_GPA >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+	val |=3D GICV5_IRS_IST_BASER_VALID;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS failed to restore IST_BASER");
+
+	attr =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &attr);
+	TEST_ASSERT(!ret && attr =3D=3D val, "GICv5 IRS_REGS IST_BASER restore mi=
smatch");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -404,6 +649,10 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 NR_IRQS attrs\n");
 	test_vgic_v5_nr_irqs_attrs();
=20
+	pr_info("Test VGICv5 IRS_REGS attrs\n");
+	test_vgic_v5_irs_regs_attrs();
+
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 41b698b3952f3..0ad6dcc3d510b 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -16,6 +16,78 @@
 #define GICV5_IRS_SIZE			0x20000
 #define GICV5_IRS_ALIGN			0x10000
=20
+/*
+ * IRS register offsets. Keep this selftest copy scoped to the offsets and
+ * fields exercised by the userspace API tests.
+ */
+#define GICV5_IRS_IDR0			0x0000
+#define GICV5_IRS_IDR1			0x0004
+#define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
+#define GICV5_IRS_IDR5			0x0014
+#define GICV5_IRS_IDR6			0x0018
+#define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
+#define GICV5_IRS_CR0			0x0080
+#define GICV5_IRS_CR1			0x0084
+#define GICV5_IRS_SYNCR			0x00c0
+#define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
+#define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
+#define GICV5_IRS_SPI_CFGR		0x0114
+#define GICV5_IRS_SPI_STATUSR		0x0118
+#define GICV5_IRS_PE_SELR		0x0140
+#define GICV5_IRS_PE_STATUSR		0x0144
+#define GICV5_IRS_PE_CR0		0x0148
+#define GICV5_IRS_IST_BASER		0x0180
+#define GICV5_IRS_IST_CFGR		0x0190
+#define GICV5_IRS_IST_STATUSR		0x0194
+#define GICV5_IRS_MAP_L2_ISTR		0x01c0
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+
+#define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
+
+#define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
