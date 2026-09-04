Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C406347F77E
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522584; cv=fail; b=dVo/YRQdbLBqNtGYwQCDJhMNl35ibQL4lnMSE0UKCK6mNWMWVXicVGEvU3vgmA0IVjOsiwcM+WEiqkRJ99hMcMxJSSMlTWqQkVuOcCRNjogCSeRtTo89177jbYtgpzURYsfPPyi46AATmn3d+r/b73/znOXofDHDWlNRJhIxwnA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522584; c=relaxed/simple;
	bh=M7cuoF6Fcy/YWmAY/AQia2G8vxfCrErFB9aBwunzclI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k+k984Ie/TzwEIY82FZleI7xEIqHCyPZnQHLKL6Wt9z7E5O0qdD2Et3iYP4lYcI1xFT/pfukx1kdHaiWBqq52F7NqcdOpe6vKk16QbH/4rCVEIOvNHs/sNfq+qkujPH5nMQqRs78JxLcG4UEC4CVqS2c49rY7kD45odhZp8W6OA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TlyJXpCB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TlyJXpCB; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TlyJXpCB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TlyJXpCB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OrZG3Ox7/8kkne8t65KzxpZ24FYZVF4eI0MHuJp12fd0K55Vv4ez00JvToFsBgYX2CDF7HPGng8mucnRrjK72soWnJ/EDt+ch1Gr/Hm1b01ErvP4546JktBBo5WiybwTUw7UNJLtIIo28x41Q5oFMk5D0kjLoY+4JG2S6GUgufJ6ofxbkldAnHE3rbYo103JznRs3M5qvahUFfJ7l8NS8UP4hKtuh/E09NHFvBeSURj6Dz1ITSITK1dgNmvnrzk/sK2CO+PXjNE+hZ1pG7fwAtxwwmwft5k+0NVuTV8Uv1adwYoG/9YYQl3K6FhHwfImWFHntcsBaY196ARXqS5AIA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=yazjHBVTq9GY1BXV9yL49/xtVAShbYfzc3vdECdFotYfkIBpN/L4uQqG4WluXj7no80G+0FJVawWEPDLhlgCjZCeVQ3DOaeq3z+Ql17pPYU+kD1qkGmn9Um9hEtIRHDh22fo5mNAUnoyi1kNaI2LrcQuUKHDPtJ5sbkQW0wuWLp3J/AAZTj6pRqqHfCh7I89YJPiwARqwyvEDQkTBxcf5wwS58BLGHaeKbit0k1n+K+SwW8DvhoYwEibHrbZtJDz/4RIQn5JNEKKfyZHL42rw4zJohfDJMvi0pbKq+sb3/LQ71DPyEWqskwqohqr9UfOiU4fLs8WQRSnRi+l0MOxqw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=TlyJXpCBt6/bRroudoHktdxYgDPBClKkMX1fekAhi+0nurgg0SAisPexjwODYmm3jPmMbHRfL0mdyLpYarRdKjnvFk/nzbiyucfZs2hwUclgzLmScs3IpiqxdGrq4x654kqiBotY6V6ilJJ1E98uafyzvd8gn6QpSSctjLtPhBk=
Received: from AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17)
 by AS2PR08MB8952.eurprd08.prod.outlook.com (2603:10a6:20b:5fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:49:37 +0000
Received: from AM4PEPF00027A5E.eurprd04.prod.outlook.com
 (2603:10a6:20b:21d:cafe::53) by AM9P192CA0012.outlook.office365.com
 (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:49:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5E.mail.protection.outlook.com (10.167.16.72) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:49:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q6Zl6JvG7uO8+XVxs8Hry1Y4wmYqEm3VrqcXjXbSALMULogyRyAMc4gKbx3zCY+NuOfbzUU+nLGvo0i3lSsOJBgSL6lc+nU7AjeN8KOfa8qClQBBrd16o/q4qgkopqYcoJwQEhv7LXoyEjEmLaN84qQBx98/4uSlVNY3cDhpjzo3eh2IG+ItrRWB7NTu/awuVY8p3jw1WFbSaRSNXtfkBEf3SRIM7uEe4RLSfwuNmm4UsGiYlMMWL5yOP7ikinIUJe8ek/BIiY7fxFuKI3wWS7dFhrEg6wv9mKJhrZtoyOuBML9gkDUI21uGpbReIwX73swIPlDnuDQM3/zbPbaJdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=oeuH2eGgEuSCWvo01QKhcdcoh0hf/tQG/4T5dF5i0OaBbgRiisdOYG5/NoDaOgPnZWk+Y5S9Yge8ZCRPHE9+yO5ywvMZLzwcP4BfRuNqR/T0PHcOmb3jS8U3ht3FezifjyBkHZHZFFLjm15jh6vWHlU8SDVAtI2I+MbaYT0HWkusYDon+79ABRDliOborh9hC1uhdF6wA9PL8YsaDv7QTSbPIks49BijuivTNXzxi/94tY0CeEmMyrLasPrtjDXp8NtJBmk6SSPc7zPsAjBoKZfwtalGUCxaLicbNLtzwTz1A0JAsaFzGXfQkqu4twzRGdIs+qgoTJYp5xVjDaqqyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mV/fYt8z9inTjQLtumcwP+TrD7h7rhP6cqR8OiFEl9k=;
 b=TlyJXpCBt6/bRroudoHktdxYgDPBClKkMX1fekAhi+0nurgg0SAisPexjwODYmm3jPmMbHRfL0mdyLpYarRdKjnvFk/nzbiyucfZs2hwUclgzLmScs3IpiqxdGrq4x654kqiBotY6V6ilJJ1E98uafyzvd8gn6QpSSctjLtPhBk=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:49:02 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:49:01 +0000
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
Subject: [PATCH v6 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
Thread-Topic: [PATCH v6 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHdPGNgd2ji4vgISES1CwHq4qGJgA==
Date: Fri, 4 Sep 2026 11:49:01 +0000
Message-ID: <20260904113404.4051341-30-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|AM4PEPF00027A5E:EE_|AS2PR08MB8952:EE_
X-MS-Office365-Filtering-Correlation-Id: 313e7504-8f1d-4710-6fee-08df0a7a96b7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 7xu3i+/dhOh5hSvVTxsq7K87HKHQQCQGMUIRPC6KbiyV6iQR8WQ8lVrqJipdjvEfs2cbWyot7vXcLH/RovmSgpSgUP/RzdP5T/eC8iYTBLPPfK8sviN7AxP/GhOHKELnE+445c5S/UKKTkueTuDZfv2k0I15KMDdPzM8oPHpuHiBF3UUgmYgXyo7Q6iBFuNzXWR1jHxDlUYOvM2SALg3YM/wTli6eiLUblqHslrjDfhj+Ti1eWZlOz/UjB2xYcdQy7ecBs3AWeMyWQ/f00vyCPLF+uLRxh5MeIrHjV+PH424B0d1uUliSD/9e/5JRp1HkOb5AAiVYQgoSB2fI8/guYvMHzMh1S2jVjlYWpRt1rTWrYSD1FpkeyVNDEdhA+KBfl3ShaKR8DBRrF/S0lWrlHdcS++Ie9hMJC7p7azQkoF04oVAur1JFv94cV/ZW3paTETmidh7unl/dwV6gfFuE2ZwUZzfKtr48MOETgLExv+bp6O+8IT9xWeQ7qlWLVZS438/bLBZfp0aHvtOWg5WGayAHsDpTv2iO39tOm3Dg4YIAAjIdC8CFks4qiWfIfQ5czBU2HL56D6L8WTfP/W0QyioS4A9/QlA247SXEJRrv9fDw7fwQu7PE5M3lrbz+bv8nDNMmJge9Fnxqs+K+IiXvIFHo0hn+wo98WNp5Yc/UVlYqn8R/xq3MQUo2/FPu7bqZLYdl0d1IG68Ficaq2ROQ==
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
 BlhJ37ERd4AlsUTp4WGYoK1UVKRMFoSvHgRc2esz6mUIY65tpyFB2PpdMyOYKlslOKATY7q2bOIL70YkNUa5rsByutSSAoNGfMGnL5ycN8bH8RiqqwJIdm+h8sW7VrBUKj96msy8cr9VetBLz7313ZmnJiJTOXjrgR/I8VrxGARtnlyRqcf5dPhGJ/vt3hoFxC6gqtw4zc9R9Hj8y4vc6QeakWF9+FXDvXGrMLd8Vjt13DMdeomaVDuNtciI57oeItItrhaDmk/Oq9DdGf6p1zT/NQ9kuB//0bz/yv9tTKc+yxsXl54djNrXoCu7u8UE3sfS7JznRKwBYjxqUXvtVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	24bf0745-d733-4443-91f8-08df0a7a834a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|36860700016|35042699022|23010399003|376014|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QeBSIMQGjHiFQxXT7H4c0K/Vjz2vJ8sIXAecs/mBmMpUBsT1r14yVR6g17RLECOHr5zG2NEpMcZQO07+jkzzsY+KMJvBtrtnanNdCGJyMV5186cw5LewM5ZG/eozdkY6+7zs0cy+KhfaVx8CzcAKQ7M1cjeRytzDfsfDFwjq6UV6y2xEupPgmCcRDhyQ7RtGDBQsnUQeKw2+v5TrHP7859A2jin9/BQ0UDVxpVwGd6GhkxSzUzx11+ld3VYX5ZPv/zWmf+mljDR9wAarUpH7+vxaU32PjY7EWzC8qoKFpf+Bzi2VTBtsSKoC9cXIbM22rI1bQ2aCY8NpccDSVepujW8Zlj6tp8z3nGD1SyOybzwuGDbWac4bXzusJ0wWNB+HocMIDbIDMDgCOB42r48XqLjJpHNuAl/k2N6zbBfRhZB6hNlR136/IGj+3cyHmI9FK2PaklT/VpYCCmAbKz9/x6EFRZMSU+1/ck3PkcPONgXQsdpqnR7CAJ6PYn+3+OTrHSPTttMe8ucw7D7k0IzRbodausWeRoUPbwp1KknB1dKqgIkiG1JQ1xhtgCSSlTOwihn83KCYi0RdR0RRtGStWs5WeTpmyt1sEWpr2yjikxywR+jBc53fNJjzL43gRLkCvQuhYXh7AwCk/FOLwc9OTToFIS/LSXkMuIyr8qbEv/w=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(36860700016)(35042699022)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oN8cG+MKKlc/ti5wIYq9hyPpc05rhwrdSn77dw05yRfAngBSvhVkF9Sx9hPR137iIvdkt7NG3WeIAQSZGraZPdvlPL/I9Or3Y2Ue8WzK/MASKCfwruykObVV+zFOZSNTRAFjL6KuL4bnBlcQIM3Lh+yC8BFnyeJ2z6XxUaB72UvSHXivAhocvtieNRgIBOSEXc4dvCWv90B4rKKqvsEYN1qE7gw1HwL0PlKjY5vL1OhglWEAt22j0O083r2ltolWcu3OnDO6SYATqcJ3TpmBrtaKMl57RYJv7IsZx7EpwocQRq2g0V67oVlwuksR/4zSVfCkOQQnCQgKM1xpSeOQLlATVCdPWa2WGwusKsdjkSevo4trtw0hxBZcW71P5GMfQ2Qi2dxOwniuYExu3BJf0JGmJiG+J7Q9JQgR1vYJ8dTEKk9KhIK75P9KNY5V9bi2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:49:33.9853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 313e7504-8f1d-4710-6fee-08df0a7a96b7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8952

Now that there is support for GICv5 SPIs in KVM, update
vgic_irqfd_set_irq() to translate irqchip pins into GICv5 SPI IntIDs
before injecting them.

Validate IRQCHIP route pins against the GIC model. GICv2 and GICv3
only support 988 pins for SPIs 32 through 1019, while KVM supports up
to 1024 GICv5 SPI pins. The common routing table is sized for the
largest supported range.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-ir=
qfd.c
index 19a1094536e6a..ee1a1b214f03c 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -19,9 +19,14 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_rout=
ing_entry *e,
 			struct kvm *kvm, int irq_source_id,
 			int level, bool line_status)
 {
-	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	unsigned int spi_id;
 	int ret;
=20
+	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		spi_id =3D vgic_v5_make_spi(e->irqchip.pin);
+	else
+		spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
=20
@@ -45,6 +50,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
+	/*
+	 * The common routing table reserves enough entries for all GICv5 SPI
+	 * pins. KVM limits GICv5 to 1024 SPI pins, while GICv2 and GICv3
+	 * only support SPIs 32..1019, leaving 988 pins.
+	 */
+	unsigned int max_irqchip_pins =3D vgic_is_v5(kvm) ?
+		VGIC_V5_MAX_NR_SPIS : VGIC_MAX_SPI - VGIC_NR_PRIVATE_IRQS + 1;
 	int r =3D -EINVAL;
=20
 	switch (ue->type) {
@@ -52,8 +64,8 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->set =3D vgic_irqfd_set_irq;
 		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
 		e->irqchip.pin =3D ue->u.irqchip.pin;
-		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
-		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
+		if (e->irqchip.pin >=3D max_irqchip_pins ||
+		    e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS)
 			goto out;
 		break;
 	case KVM_IRQ_ROUTING_MSI:
--=20
2.34.1
