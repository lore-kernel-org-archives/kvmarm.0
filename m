Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011038.outbound.protection.outlook.com [40.107.130.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D10426436
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890191; cv=fail; b=A/Od5nrbpqoKR+Ppp6Z/ILPcqlsms1y6ls/zI5HQmKYznOYH/+1pbLBBxZS5fxv6JlotNcLU9Bfq2tG5uzk+LuKu3tS2ajXKOWG4IZT+hTx5PCdpPGE70+gkTX7WGNFjmx5bHqc7enAKa1NF71VkUgJM6Cus6Jh6Np70elXnKH0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890191; c=relaxed/simple;
	bh=V9MNNa7cvJCEXOoD1vnyxSmHmBRsM43aXmQv/hryv84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CzMnihGkkR8H/77D8y2KzBzfmZ+zm5253wc+zPqBuyYz1Cr5KZWNzeu4tRn1Q+b63+5IycF9abwNFthlHtz1kI+mCjDPb7SdurH6fwuVIkUSsAdqLE0aiAI/SsCKyxBaZwdCbp1y+ErErD29eh90dQ4ozMzVBl6CtF/0PybOo3o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PmjEU6Ow; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PmjEU6Ow; arc=fail smtp.client-ip=40.107.130.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PmjEU6Ow";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PmjEU6Ow"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=s21GIohWOI57BA9J4F0/N5vkDQGlvNRIgyIEVlz9G3QH2Tk2vgFAUetRdpyjO2d7dezGchmfuQTpVGPaPb3HQiVQhwMDR//UONJxPAYwRgjczw6x69e+IKsLwWzP1w9Yzz5n+fe8xjHBL6KyRGDX8G9IOElZryfc7HQlH7xb6oFfCxWoV3mUmrszvyx67YQEuBhgOfTz16Yx0V/LXFgi+T8TP5dv6DCE9qA29dvD8CA2Bt4QC8xC+s7reEVaTtFQKRIhxu5MqHpvH3miRzO6yhhYayv/fNewJMNmKTwvvdtS1t0EWvwyJ95gt3RPrPZnc07itfA5ekUhNDQER5Vesw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=fQzjb7QlOa36ehkDxId+AkLWkiJ/z+hcY7QbhgU8f7GEa36iA7LdTCDbfAyTXJ1+g4nMV4PRm7+D+e57oLXWJooS0PP9wcKgMGzUOfhcGYxSK1mlEkNUgwIBMi154RmqL+M2kg8NQgijoMpOfHlODC3Vwi8vrV9ZTT77ejaVIWB/NDtGWfkDRi8YmTZIBvazr9hDHImIrc87SPgG7EyN3MR3Mktc3/9eYldRcd+wEp6GtNiaPOFZrz4jVM2GsDLpauNgFduffxdwFq0RUUQTIT1EOxMIbqxwUa9OUeH3xzL93AE2KMNO/uawt8zuU87lU7CWIcfhBnwyWPr96LFKaA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=PmjEU6Owp1Nvig5b/NIMCXWL0OQIb3o+HohJYqkYcKFmAgaPEgv0kqnKoU0EIMKnbt6xKHdy3lQ5yilXCui1mvKbWMi8fVKv9Oj5gGghHjKJUVYdJomIE52e1UyQUa+pLnwSfXNUfj8CEhSY2wZ45MWu+14YihEOfXzwYSnVaRI=
Received: from DU7P190CA0002.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::30)
 by GVXPR08MB11743.eurprd08.prod.outlook.com (2603:10a6:150:334::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:49:43 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:550:cafe::75) by DU7P190CA0002.outlook.office365.com
 (2603:10a6:10:550::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:49:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Fri, 24 Jul 2026 10:49:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEOd3k5jlK0wA7CEI4Ekd8vNDkXeq43nkTRgTK5Q1UBTV8XmvyyaESENDxNPhoNIZnlTGvNBYYdsYwrTUZxZbPSNuxqSvSgyLizIsHGd4W+eR2cmZ447usbdPZ/JZVXslCboYSH+JeTK08ZX4cqzegpfQ6ttun0ND80Rje5h3/udNBjHpCXbqd+QT+ad9C6RX/opJOLU+FKiEA0Ys7Yei7eFF2r4nqWJk3bh/uw6F84Q0gUrvGkgbDDJnpp03RASSheLnAplYx03H8q0HJrb2VtqtphDjEirWTfJyabeuSMZMm+6xFccS8CEpCVG9rH7fBEcJlbVQo9F9aPg/pL8tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=aWw/haQXnUUPIpCv4N1Slibj+i2FuIb8oRgyA4PMCrEEe1otyJjcb1FdImsEvI1vkhFBQIwu0nMimlnD8a3yGLnkGlHybNhLjA+36hKfoQxuZSSSZ63kQ0IpwlhniZdTCRpWBkjxA24S9d07ygrYUuUGa/cQWYvWBWndEMm8yOdzzXvwznJwi2dV3g0OEwJ48rqwWblRlVqBiK6j+bsWuJo7bScDfex2w8icRoOkjEXnTPArsXeC+nsdSKJdihP6VJhP6T8Lk+3dpyJx0jW6KbhSHRHEhfGaD4SaZ9kW2ZCxESL1XBdU8Sp3g7tKNqvZ7JRAymhVO9cCbmlVOcxTWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=PmjEU6Owp1Nvig5b/NIMCXWL0OQIb3o+HohJYqkYcKFmAgaPEgv0kqnKoU0EIMKnbt6xKHdy3lQ5yilXCui1mvKbWMi8fVKv9Oj5gGghHjKJUVYdJomIE52e1UyQUa+pLnwSfXNUfj8CEhSY2wZ45MWu+14YihEOfXzwYSnVaRI=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:48:40 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:48:40 +0000
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
Subject: [PATCH v4 01/48] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Topic: [PATCH v4 01/48] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Index: AQHdG1n96hE/bI9FdUeQWTh8i0lV/A==
Date: Fri, 24 Jul 2026 10:48:40 +0000
Message-ID: <20260724104819.1296803-2-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|DB1PEPF0003922F:EE_|GVXPR08MB11743:EE_
X-MS-Office365-Filtering-Correlation-Id: b920b964-3a4a-4554-5ecc-08dee9714515
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|56012099006|5023799004|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 lzVKN8OAgvIM5Q8eNq6HNh9rP/UmwSQQ62bk/fWZMHThZnpA5tXVRCRKsYi3MILeQ/Y0fSNRw2cU2bWLrBqchaeWOYFTQHfW5PPH5HbOV+0n4mvELJT2RIqKxRFtu1YPDC2+IigiyyuVSR91Nq/2bAA2apnz9a98CiOkO61zmjynnmU9UcQIUwthY+kVOrqSIaCiggoYOEKdnWcNwTtpzUzDqCAm2bniD0CZFBFeuwiFz45xHOt5ELqkapYGQW5ht229B/nSI14HUuwGTN98SqSqBgFxtfVGa/reaIzTn7fNiz74xOzbhOCNLl9HDjIqIjqCViq3DW0Au48M9bDLX4T+5HU23TRQBe20UG4ai32ajifJ+d0D51ZQsoDZGYuFD4zYdF4lVmmRcmDAEM+4+XnfBiSCxSCl5hwr7rySBgFuyG1NOiDKw8xTYiq1OrJZXnbFnL1TQdBloXEIrE0qCr0MOM4KMg59VlLhscznZOQmh2aIkelhNEYA8T3Xu1nsHpYPYItlR7sQL0CwK4eMVhlu59PFpuKU8jlGPXwKXF3k01RED7yXfvconGz723DEnmkoQIgTgArgFfyV6ois/Juu/Cb0Ms8LBnrUbJ3cBan7PuARCOCdzGxJoya6TOmZLk/eMW7bTr1o+1WF9tvfH+gxlmZ/6ia9d0SrQU6gD2IkmnQemqjgrlKMBA+bkg9SUGikefLOZtR8dMa1bREEgwxAJ+zn8q0wh/ZIon5MotI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 E4H00l35eJzx/bATOr5l/evjeDxBcII0ifC7V9TQMCA62uigSswot1zINRANtE7mQSSsVvxYgByGkyqKLdQJ34vLxB8y9i+l8RAJ7c8IwLHGu5zX6sMpLnz15nyRKJt8mLgZ749EcxdHFQcVKmFkQyAP7VSOS49tYK/dTP6/G88FSwgZAQ8UeBwUrortHDaD2K4b1dW6IGJotEU6tsdcvSuym5VPgc5FovakhGaloqERq1GhnIqEXkPfGs6Rv/KMiFHpFWLO8xzVxPaKbIpE2vhySXYKoGrb/gVRSVtvDWuMk0ET+1qoP8JB36CLZ6ZxvmXycvae6WwPlmuKtQKPFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	16da406e-57b2-4faa-7d23-08dee9711fca
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|82310400026|1800799024|35042699022|36860700016|23010399003|22082099003|18002099003|10067099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	TExPYvg+ALk4efiUZlk1pysq3IvpICNZSOxewDQQizH10S9oUulMGvt8SMxhxNCfVXYN0zflyuvsvRLHFHNn0tDymdWO7CFGOX8hrWDZ1ZzkWq5gET2Op4t5gp7cEOT9D13j5H5KCAfqtKxsVtAg2RbdycfcOzdNzi6a7sza5k8gVMdY+YROlsLKH+NFiS1RAA019sCFBSUMSx49crptv0K2t1LWsVhFIn6MYbZrQtlREblIC3tdr6ANvmKDlQflOMtTStOfKL3YxpnpH5MTG5su1sTu55d7NGJMIxxCkU3uxDDgKvH44Fp3AslHiXYZOdmA+9mcn2j45Q28CCcDIFJ4oOHn5ZvSuLjNUiPr0GSKtpYQzdBuGBsncThh3bn9vD9ZktX3HxcXZHwii7CQrs5eVxRdK/bt9Kwuxhi4Cg8bgTs6zGDxZqYaq9bZYJT0Y1MAggO3Bz9zYu96oukG8c+wqDh1VLrfq2LTxxVH2uLKcfiDSKxhZdBaMoOBXPis+Jm0Q66dO8AiYsMXpLxkHfq0csq0bAiTnZyoG3NOSU0ZR06bsRxvooQ3gCpckpaTy6yYSxN7gDLEiZXNQifh3k4mPf47SlJd5800Tp15iwB+ws4Zl1iWGQI1dYPMM9i3jj7W9q4XQ1aZe5H5Jd9gDm8G38e423o30AZWsK2/Fr/5d/QTgNZHOcGF4kJr6jKPwFEMJRD19RTWUwRCy3HWUQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(82310400026)(1800799024)(35042699022)(36860700016)(23010399003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QIrDrx73/ZVjISXUXvjqx2mf0IEoBqndD0thMmJmfm+sFCRfuAZWz9EcSNKqqezv+ggxCv/HFQW01fqOsKl6yIICUgFapYGiPccy/LEIgsIK/zbUAS1taPtkia5drcSRn3lR9WCPoHuPK6qA9ZzHs95JPBnm4oC4v5WXLUvZ8cNVp2XqO5hFz7aXavepgNKFx4K1E43dOd0g+f40n7Q3Ppv5usHPKYEJbxxegRE+fcBbAu6cv8Vz1Ks7myBANAmld/IXkNkD9LtiylcSECZBg36dGjaFaygUEXWGXyoXqeFx5wjhyEvh9Z5jX8Mf/B9gxxsF1bHIVzGLxUf7uaSW+cl2u+UxW96ZQ0KM8xZ7urColGP/33BKFWzux0uNVKxZem2clHko5oQDjox+QjCtvg8cYTHxl/Y7+aCJXrfgQyocOLu1YHL0wRdHEzFbez60
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:49:43.1797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b920b964-3a4a-4554-5ecc-08dee9714515
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11743

GICv5 does not require a virtual CPU interface maintenance interrupt
for native GCIE operation. The interrupt is only needed when
FEAT_GCIE_LEGACY is present, as the legacy GICv3 interface still
relies on maintenance IRQ delivery.

Stop rejecting KVM setup solely because the maintenance interrupt is
absent. Parse the interrupt if present, but if none is described and
the system does not advertise FEAT_GCIE_LEGACY, tell KVM that no
maintenance interrupt is required.

This lets native GICv5 KVM support be registered on systems that do
not provide a maintenance interrupt, while requiring a maintenance
interrupt for GICv3-capable systems.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e9d1795235a66..c04523a438cee 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1143,10 +1143,18 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
-	if (!gic_v5_kvm_info.maint_irq) {
-		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt\n=
");
-		return;
-	}
+
+	/*
+	 * We require an MI if we have legacy support, but don't, otherwise.
+	 * Given that there's an existing flag to convey that an MI isn't
+	 * needed, we (ab)use it to tell KVM that the MI isn't needed if we
+	 * don't support legacy.
+	 *
+	 * The check for ARM64_HAS_GICV5_LEGACY explicitly doesn't use
+	 * cpus_have_final_cap() here as we run too early.
+	 */
+	if (!cpus_have_cap(ARM64_HAS_GICV5_LEGACY) && !gic_v5_kvm_info.maint_irq)
+		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
 }
--=20
2.34.1
