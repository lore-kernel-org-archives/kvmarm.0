Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010052.outbound.protection.outlook.com [52.101.84.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB1734CFAB
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306381; cv=fail; b=d5wF9x2jfIm6kZvXPU8i2x4U0lKaTeuvnIE0QtKl8EuDDLqi2JuTO+K0IVno3mJYwmgnW/j3orXf9ZHh3VHKh81GQKbc4bteRbGnZiVNxxQ/mZZ4o7UKd/E6qQnRgjLauE2eJoSfx1MBFBUU9FKPoBrAKov7MVat7ljLvpuNBJg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306381; c=relaxed/simple;
	bh=357lOa1UsHLZE/dP5NG4hd2MyF4c1jBAKAVlESonEUg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BuPOxWu6M68t5XgEFSADO3frUMTnSukwsze1dyaOgaxj47g+9pE6fDAF6nUdS2cbaDGtqu5fQjmH/+R1Jlb6XycoQSilCTfb7Qy32iqEF+v3qGRvFfJoogVXVvlpf54aBTQcw22rI1AayP/0cBDVAbWb9RO3+hDCgbaz6o/Lh/s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eVQ/8OED; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eVQ/8OED; arc=fail smtp.client-ip=52.101.84.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eVQ/8OED";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eVQ/8OED"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sZOlpQLXwgnRCJDU3QV/jGK6q/gDOyrEbmuIJIzGjN0/L1eaXaJZzTrV1vs35FE8aFBBed8IHOOVG3+qFkE8ZjXGMlce/ncSht+vASHUk4Ouvz6mKWz/njlG/JXb9laKnq6QXAcouaCobQPpRIQbhqO+s0bxVF5qIbAPddJ36983dpIp5KHmrtb23Jqfq9u0qzaTNLBE1GL1lD4ll+qM1uH5liHzQPA0ZsVKnPfrJlVKU1bogPup35psqyDeM8l6DqpcXIjYX0/nrrNRk9LJotWkaOLoM5BianeLP6jr4+wJSSDOB5w9ncIFSZMDCXEQI2wpdIlQMyY6y2jn1xqpVQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BioTeMu4AYPO9O9fPUW4dKCncFee0WiuPl6PakUbIhA=;
 b=GtmAaVeDauzSp5I99qQ6ZAY4z9yAOpZ3R6CsqpGmedajuuJJ6kB9aI+2cXIVnYfXknUawcp5P2/GePDSsVlZvGugyoT5wJUi+IHlow95xYnMKLdVHbwt323xZcv36R6cokVIMXzsMfUaLciNT3rAtOVhTfuqGBWaKGyAfMvPS1L829HEqyFiXGO95ARkdgG1O5PetaSNLP/yuHHgPj3Qgf5amqCrUYmBmIJNx8REBZ8aH1bM8DAHYPVQCVCk1WXlfJr4C/zMh1/3jL4+iSX08HjR3sc4BbJFLz/477UIh4CjW2klP5sLcQZjI+NXnT3XEIa2+uimlD8gNtH3CYbnDQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BioTeMu4AYPO9O9fPUW4dKCncFee0WiuPl6PakUbIhA=;
 b=eVQ/8OEDG/mAqW5fFmTQS93br1orZMeGOYkAKJYTNEUkd1ktnI4Xc7vTk4/IYZJ0Vxzar9p9FqGi+SYHo3tITWyw8cEWIDDF5DzELw2iw3s1naKuLIKKO+9tsTfyEyX196NdDTr2hDyroCSy2rW2zOJJ4V9RVsiRTZJA029jMvE=
Received: from CWLP265CA0396.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d6::15)
 by DB3PR08MB8818.eurprd08.prod.outlook.com (2603:10a6:10:434::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:12:55 +0000
Received: from AMS0EPF000001A7.eurprd05.prod.outlook.com
 (2603:10a6:400:1d6:cafe::f5) by CWLP265CA0396.outlook.office365.com
 (2603:10a6:400:1d6::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:12:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A7.mail.protection.outlook.com (10.167.16.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:12:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWSMZnSY3x8WQODT2M7LrGHbmUL7EFZX4vKKKL+fN/rCHb72UDceFJ/6N5076Anz0PDKHu/SP993oaNsTK5fSBIXyrCMrIZdcD5bXnxaN4bMq8BRLB1t9lRYvQJZz7UYkZzLIjBo9ADOYaIPl1c/TVeHmKDYXkKYER+8hl4jZtLdQV2LwVNMBLp1F2UDP0TH5VcE7k1NNYTjsIPXJyEyJHP4vDaD6D1igaKc/A+7bcPNLAlFXBuB8PeTleD+WXL5fUXEeqvBDakJyV1i77UyPWYhlkIe5YdjGcF8qyDuhvVaRj+6ScoPmXE8cr/lbv4apK6nKI+aqg7CHvGhngsjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BioTeMu4AYPO9O9fPUW4dKCncFee0WiuPl6PakUbIhA=;
 b=uvxS8syhnKIeZWPUWJqwjgKD7rTWVcCxQWNo252KPziqVhTkW2TVLCAEtShJJpuuRRFGRbIJl7/5mcZ4em2rjuwqTD20dUyW9kEOeMjNV0Jn9tUP5nlLRwYzG+KXQrC440RrjQIRgKF2Gs91EKM+iBh2ulnB2LPUfGBX0erWj5UCTau43Cw153Y9+QtgO5xU7M3P/3VZ8vhfdS74CXcrHw808I1izO5Lv+hE/DOTfq39g41+6xAIWXpGV30HPMkhCJmko+iiL9K1kN3kxlnsdv6hz0bKhN3YlS76Qk8hQPF7yyWqWns4HUt/+IEaael/5v4wEZwjCXjumwYvKeT0GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BioTeMu4AYPO9O9fPUW4dKCncFee0WiuPl6PakUbIhA=;
 b=eVQ/8OEDG/mAqW5fFmTQS93br1orZMeGOYkAKJYTNEUkd1ktnI4Xc7vTk4/IYZJ0Vxzar9p9FqGi+SYHo3tITWyw8cEWIDDF5DzELw2iw3s1naKuLIKKO+9tsTfyEyX196NdDTr2hDyroCSy2rW2zOJJ4V9RVsiRTZJA029jMvE=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:11:51 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:11:50 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 17/43] KVM: arm64: gic-v5: Enable VPE DBs on VPE reset and
 disable on teardown
Thread-Topic: [PATCH 17/43] KVM: arm64: gic-v5: Enable VPE DBs on VPE reset
 and disable on teardown
Thread-Index: AQHc1mCO6WZjLSSAYEGzsoV6jlitxQ==
Date: Mon, 27 Apr 2026 16:11:50 +0000
Message-ID: <20260427160547.3129448-18-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|AMS0EPF000001A7:EE_|DB3PR08MB8818:EE_
X-MS-Office365-Filtering-Correlation-Id: 42418ac2-cb4e-4733-5f7c-08dea477d792
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 enjyLBhiQ6J9HyIdT6eBaWPJPANuSc/wqT3Ngvd86/xOuQlUgnCAMGpTiT0KcHWUnz/DTi0I8xzQDaoF4RFVyogS6YT2wcxJEbFJAXnPQeBnY+RGzQCdACqO+zdZu5GW6JqO87Va6FbRFiyfGIkZ98rb47wq5MLqRnbKENJg9XqrjVTjYBMWoke2qiAp+xD5L9sCOUEH4XYuhCz5Q6IIkD0RasQFy9Ck5gm4AGSaxATtm99oft2TqChmN00lgw98jdPFgWRfk1phpbd7U+lw+k0hSDiYifXfmMOUa+D5ZRBR0x4kIipXFqW7/y7YZgEkX5zekElh6ClK/zA2gueHo221pss2r9K36xtnfoOx3KfAAA5eLvpcRo41GGYFWHb2yy/LnVxEYWK3SkPGDRIfZVz9+SDbV0H9hdEF8aawicJgRB8dPhtxeHFw6gsa/Kx58wpl4V/VCAbxXCAe5GjbD8Vf4XjXlOdvxmwTyGcA+nImewjqMYFPwz0u4SDEztcP1FZEHoad5Mre3WxsoyCu4HybBMN+XQj+9jma5bLSCjz9hyTS0fOpZYbztHOagWm1FHQ6VFK3R2Qq4DUuOVzcu0Myh/IxBxrLnSegEPRHbQoVTKkCBEIKegb/tfhk1zsFMBExDAQgxstERVmKb28twkpzX6p8OtnJW3WK3kiS6OzgJj4UFvGZmidyUPuWLsfn2VcqQ0GW2u6d7v6H1mjxpABdMK0b8XUZL5xW4Ux0EPJkih2snwnAducyMkYWbUPLTrn5oaVIlio1vM9161hVY9J3K1EZrqAj5LSTpe2RzVQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 aC7RTpHyJMIYWpuSdZbh41huxBbUXvIxl32sRhUDwmUWTyfejKfdDncib5T72YckEtiiteCvPYh6iQQZSrBl6s76/yzSuZBx14ZQ7Fhnv2SN7fyMH2dSBtMBr7X1nT7va5xzJ4t/uQlUUNwa4WB5RfvyPZFQFmcJ3kAxVbsR0nxQYRdasGcUDTpEFRkMF0+PxjVP3J+G5RXrkcj/mxiTq/+N23m980Z/+iXc3u+TKq8Jq0Q77xgk45z2vR5MZI/Aa1YnXsSJDCgTzAf83037vWwNrnxd7+VbZthZMmB/n8FX89x5jTINpGsXgdxO8M4K2+yScIJEv/OdKzo0ZweiOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eac6beaf-7547-487c-19b0-08dea477b0e7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|14060799003|36860700016|35042699022|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	QVPsjPmnYlZRfGhW3tfAfQcEt4Ec1Hlr87bMf5xtwj7EPzWLxwtFEAPesmAVSmIKF68YMdJ0xedKhdjFMuKHc7Z9YdjGi9Sq4nJBxYbg/n9NrmD0yHigVyafuLGDMvl3oHaQtFcpWtXDWPsy/qXxX1aGy6wUZhVAOfRtszCfBJS9uIOTpp0Hw0tIfcqDiRD7JWsICFpgpgB+TNSiZ3jgjsbskOmtM6nLMZRAqYXiV1qi8ZlQFL5OR+oqaukKqd2zQ8/CNUGzmWOBUYr2XGwanDS834dh/90X31MVP9dD15DuSvWIG6X97qX/gpnVM0X04q2mx7cCGgdztiilQFOE7iKyaWA+HdcgEjjT16aTytK6ABwSG37n5r65fIts8WE0+TOxlG8saLNURnLBi7fmOLCJHVpXTo2J1bpzR0v/PPBazB+um9m6I+TQ4W1JWjuzwCH0KHxU4B4faUk/MSs99nINnT+8gY7FZLDKJhGjDxkERQnhmnTpbi+3GcmD9KEmCndkatIki4fn3QD9SCLlljpzdAS7PlX5mRBaTZbRqpVfBqQxQq9hkMFqseX9Nd7AMjVGHXd3PSPBsIztPV1XMecI65ol38ZJ7bf06zhc+a11yhXpU4MlFoxW7clpEl48xsw3vhIIkFkMx+C7/5Nhw6clvRtnvxVysd5btCKIiUTJu/nS1QzgUQ78YK/sSxy0cQxxgaPXLM3sh9f/N8Bl38x81eL/7fCQTKw5rTuSleF+XfY/O3rIAQ4g0h37DyTTritRRXU98VWcG1yad15aQw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(14060799003)(36860700016)(35042699022)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0BSjNm9LSH6SWr/3BmnYVbXhhSypi1QPGIuGN9Cn5uyXgpIN8qgALi1IvhzSXL99hOjiAw1nHdt7idYlKD3T5mZaqgqeaf8kFLCY1oGzy/iW0pQuUfEAABxtjJsDbVim1WoK0VaiH7gwa3fGjs63nnZ1tM7mVI5QdeS4jBiWli7LiYhK/0jXq46ZXBlXS+OCob566n50KZA5pqtFIAM4YsolU4y3h2UJVJjCy6MhKVDX6h4b8fl3nz8V55SCqEeHZ5PCfXG+3FctH32wALZH1WMlQGS8GKtsGjwXdT1LpG8wIOT9B6HoXipxNMz3hjfk/0y2VAoT7CY+M/innbjqj19LYQTooPpu4wXE6TqK2PKY1LurUZ+fQMmnVr6Mn5iB4nqlj5hdSb8FOZtNteIZdqbDcKVFmjSgsFj67o/vRiMqlp/0qXrLCSjqR+3BQJzT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:12:55.6988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42418ac2-cb4e-4733-5f7c-08dea477d792
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8818

Ensure that each VPE doorbell is enabled on the host prior to running
the guest by enabling it as part of vgic_v5_reset(). Add a function to
disable it again as part of VM teardown, vgic_v5_disable_vcpu(), which
also frees the IRQ again.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 9347bc6895223..48ffcb2494db3 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -736,6 +736,31 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 		kvm_vm_dead(vcpu->kvm);
 		return;
 	}
+
+	enable_irq(vgic_v5_vpe_db(vcpu));
+}
+
+static void vgic_v5_disable_vcpu(struct kvm_vcpu *vcpu)
+{
+	int virq =3D vgic_v5_vpe_db(vcpu);
+
+	if (!vcpu->kvm->arch.vgic.gicv5_vm.domain)
+		return;
+
+	if (!virq)
+		return;
+
+	/*
+	 * We are called in the vgic_v5_teardown path. We no longer need the
+	 * doorbell virqs.
+	 */
+	disable_irq(virq);
+
+	/* Free the doorbell irq (counter-part to request_irq)*/
+	free_irq(virq, vcpu);
+
+	/* Remove the irq from the domain too */
+	irq_domain_free_irqs(virq, 1);
 }
=20
 int vgic_v5_map_resources(struct kvm *kvm)
@@ -875,6 +900,10 @@ void vgic_v5_teardown(struct kvm *kvm)
 			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
 	}
=20
+	/* Goodbye doorbells */
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		vgic_v5_disable_vcpu(vcpu);
+
 	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
=20
 	vgic_v5_release_vm_id(kvm);
--=20
2.34.1
