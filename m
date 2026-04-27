Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011063.outbound.protection.outlook.com [52.101.70.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA2A3115AF
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306277; cv=fail; b=bvZwUdBF1PCifGRA8cVtUdguey28o451i3O6Y+Zup7PjQWFGD4pnBBXulxUNRaFTiwDTygm195C5vvhwqFRzjE7Bqud1smAJWQpcAY5m7faewBfa/J1uZn//4jZvTRpGgSP7fx4Jwdwr4RysUCiDmjHmgtry8mOFzXrW9gXYOq8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306277; c=relaxed/simple;
	bh=aYbighwkGoDq+k93X5Lq99S4kn/veQdnnKGQa0iPGpY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y2zM5DiECK3LHGOwD84oX8JhpaKtLsusGCuqZN5db6WVnJ2/aCfKNGr3NHnQKYYijVw1RjyoggkXxHDHJ8NEOBAwWP4bOV2Jj0nB8nRoyEnDzhIQML+tXJhltlu6wQ1/QgoXZfnMF4NG+JyXos1P0jKfsfDJvEbSb7vcpFHq0BQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kjnZnWX4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kjnZnWX4; arc=fail smtp.client-ip=52.101.70.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kjnZnWX4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kjnZnWX4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BHwxX0yujV1dvEwkZeqrfv9b599qbWdh9+VupUVaw2tI8i4QrTgny4tj6AwDNzPK6159e8oV2tVr3xfYLz8GNcp9CSEkHTp0ZFgNZW8h8N9Gyc3Q4nUvE5gGjG8JQqfNuTIyO29np7PoAVUYUb4VJ9BxFB0FaIl2MyVxvgKA/DCMXYvm/rb7OhA0wriKxwnYO6GPfZxQ2utDf0FCJA/sW6XIZnFJBUiNt6MwiVD3CMW2ulacKXnz/XBOsWHkNaocp8Mz9cFAWX/3sypJ1IPzlgwxwMpvLNtrag+/61byQVWCzjG+kZmse5ozFyStpNmt3DEt+rQh9wzSxhlIU2Dq7A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXlGUZgofW2UanwwUXQLELOXOn65x01ysrRoTJF6giQ=;
 b=FmjUvHbcytvHEfEl8wVPbs5Bj5L16XZT10EmHAEmOm9TvwCkxuij3SQtHrOX6WPMfPBUhAlLDrDxiacCt9d55iTMEVzR3cqlHliwW72e6LBTNU52dmQvmQB2gwNEIEino6haujbMi1009wuh1Y4n/1J9/8YyhOlgkdxBOQYLr1P4vnMB+rJ6NC9pJYXjuqIrRT5CM594ohlNtZTN3+yRhCciM/qlsr8m0Dws/YgA4d4EKlcZ22a2vAapMBIb12k+c5hMPobJBRvuxxeY15kgZefgvMHC4ao5fBFHfBmPsxBE5Ki8zglxZhxkq7i/CEgor5Hr9u/yHr5ARDa/a4AFdQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXlGUZgofW2UanwwUXQLELOXOn65x01ysrRoTJF6giQ=;
 b=kjnZnWX4XDnQ47gywghp1V72UJvET3Wh/dJ9GRBqpSGIK+a0ntDcoYrLsxmNRVKC+2Dk2WL+4wKzFffGrgG8ey3HoeC55o5kdr0fK/4pdau7hxDJoUlTk1aXOtXUJmdTmdPhd0/z5pCRa1qdRvhCiCzDQVRgZEtcPYxAozMzpJI=
Received: from AS9PR06CA0272.eurprd06.prod.outlook.com (2603:10a6:20b:45a::10)
 by AS8PR08MB7744.eurprd08.prod.outlook.com (2603:10a6:20b:508::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:11:11 +0000
Received: from DB5PEPF00014B96.eurprd02.prod.outlook.com
 (2603:10a6:20b:45a:cafe::8b) by AS9PR06CA0272.outlook.office365.com
 (2603:10a6:20b:45a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:11:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B96.mail.protection.outlook.com (10.167.8.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:11:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4YYx6Dutt7v7J7L2FY7LOKnmhl2L8E7Y1lZk2Y/r8vQyQCmiKIDdI2Mg2o6p5gaD6xUaY0MJkjqt8Zc+UKT7/hLM//c2EtW20Hgu99zAVgk0tpVduQIwkS2ZtnpygIkSqqZhDmkpJRRFWNf99VZ4d7zTMksKBQQY9LfBgfzTjfMSnExX39WAGDGpvNtXQPwH5FzRvql/PJqWpZ4dlYPIRpJ6MRUVDt2WnzeGzBhiooyB8tj1OY2+Pz0cODB6ddS5uuwdpqTGwSOwGM6V6xt9Kqk3HzJwD+FyYfQpic0PXwDhI9WBv/mMxsta7KCCEpNx8EK56KnHA85FahpOOwnNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXlGUZgofW2UanwwUXQLELOXOn65x01ysrRoTJF6giQ=;
 b=AGhiUJx94xF4wWa7e7m1bkiGbQp037piv7VNdaQ5uAmDFskNjRzj4IOpMHPoPp2Ipg7XN9fLxpVpv52m8/WBMV83fZdPd4DBRwk3bUcgKYSB2Nz2Lho7gb/fwO+EVOwdax4hHDODuYm4sLHDtEXYj3iK+zSBd7rNbggXKvUAO+rJuChLHqDqwSaUQDEbgvpv9JuPZepsW+XjVQfkhKjmsmptAv5zPRKT6SQjIoriIs1ycecQYvR1Mpyn2Nt+nmXhuX2hQ/QCtSv/HNrEGJaNMQ2JAWcQGXk7g718KpNq4MsdLlrOdEvmbXI8BjqMCN70/x+Cb4oekoICTN4kUK8R8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXlGUZgofW2UanwwUXQLELOXOn65x01ysrRoTJF6giQ=;
 b=kjnZnWX4XDnQ47gywghp1V72UJvET3Wh/dJ9GRBqpSGIK+a0ntDcoYrLsxmNRVKC+2Dk2WL+4wKzFffGrgG8ey3HoeC55o5kdr0fK/4pdau7hxDJoUlTk1aXOtXUJmdTmdPhd0/z5pCRa1qdRvhCiCzDQVRgZEtcPYxAozMzpJI=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:10:08 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:10:08 +0000
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
Subject: [PATCH 12/43] KVM: arm64: gic-v5: Clear db_fired flag before making
 VPE non-resident
Thread-Topic: [PATCH 12/43] KVM: arm64: gic-v5: Clear db_fired flag before
 making VPE non-resident
Thread-Index: AQHc1mBR3F6bqvo86E+pwMkt9LHsoA==
Date: Mon, 27 Apr 2026 16:10:08 +0000
Message-ID: <20260427160547.3129448-13-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|DB5PEPF00014B96:EE_|AS8PR08MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 3069fe98-493b-4492-8e7f-08dea477990f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 oHMFXYtIjc81DHTCwleE1LUtz+MVWqIlC7sCksXwA+DMxivufgYT2lcWT9TWrZDcx7N01b5TAeW0ffpFWhNMRyRZlQDYA0cdEzLWSjd/Zx4kV2euMcaAb6JQsDjJMpXm9ayELBsGXlp2JeiRVQjP0KPbCVPN6pHeRxQv0lBb4m3kbN1nbVt/67FrfNzSYy789AdIyf8QpDfX2xz9B8mvt737c8CLpj8SGX2gn6BWpc4u05AnaRkKypxDfN0fvFa5gkapJu61u5MeFfXb52qrxVOpnIIK+J2HteoQFBS+VTm/rMBDxn3kl7biqQwLBSuxhtHKMj2C8fo8RPgPx1LPAmfqO5pxaJE+cwxAMTy6+gViI0Wl/IjFpkv5ti9sXyP1NRG9OMd2HkHheDSJfvdnSQF8bLOwrFCdGsk7XX32fbppd9Csbqc7cN53SJbiPKUdV7KIw3naKheYbIYIZCX5D+eyFuGcxFeeP12NIYdc2JERaprhGH139gwUwQHtc6kyqZv7fehdMl2nDEHLuaoVQiPh+HH7EbXt7GwjnW4yYxsSkc1sx5JtmKkQTtyIp4zrxADe5EmtUSgyGjiW9bjJ+vKpgaio/gci6ORaduP8vpPgRj43RLkzl2Jw84C+Zftvrlqt4i03wwnmW9Ccbjpu3GTgvYi/E9btHYnejXhS7qKN71W6V9BCHVsj0T5OhVD/B2ZS0Ch9kxW4GhcjB6pqV+mS77Zj+N4qRU3W+W4JptsyDuujvKXnqoNXSZTxixQsyGk4kRTqm5aH82/kyVUpJSTlVavAHf53QSi8jXxSFMo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 rnaB4V90yhGfv5h1G7H2xsA1YuvGWv1iaCwxhGfcxDSRVFenyuGBvUeCZwSecAxl3DdESLcoaouCQwyibq1lmiH6G/81TL67xckA2E/kIHwrh/8aTdVn2h3LLX1Br0uKC58bPRZrkZ74u216cf9jcqIvdNIaer0uXRc2GZbPadzCWgnnC8njLS3HHCseON5WHI1jytcy0AmSmRBQVZiVMxUaQIu29cbnAqhozty5tYyJPRUzdzahmHDbKHvrMasR2PoDsCs/mBcgm6IuOwpZXc5DXDHc2YF5H/CvPvPHw46PMj2bBi5zXkL4JKbk7QfTFO8J5I/tSp0VpmX/oaW0dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f5333578-6801-4cec-0e8a-08dea47773b6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|376014|1800799024|82310400026|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	otb8msPteihQFiJ5HFtN92RB81KlBRlSq5DmWZRM3IjxWXHsGnoDsKaFZ5Z5o2sekQIgHes3IoyhjEK6n8ceV0ftk/ykHhE0AVdnWXRk+iiM3vLotb5TCrW92qDTQIier0+R27wlIKJdszlAAY9ecYfxaUN0r9OVd3v6cbaRCoenxNxed9PFQqKB0dBQrR/SSlK1wvY1olK6cKcmbLwQyMZKqWdB53PJ9afoFVT49GkiFd+8KcmUjoXFTZzlFQrQ641IIV3hZ/0Ngm/og3Gipm3Vi+Vc20eO3u3EfkFesHoHelQkiNFz2Ir5txo6Yq5BMsCdn0ZLr2JEbPyN0CUWKmOZIb31atCtinXZiq3ozl8pAiNO8+pMqGSZG0AL2bJGp2O/Ry9yIN0UmcpkkZhUljs6o1Jo829pUiHBzfgh0wRPoWsJl+/Hd6NjIePvCCpPD9YJICyD32AJXqSWD7YiQIxbJJ3DY5Ho+eLyg4OM7eH33FYKHz4RnpeChfqOGdvHzcYa9DKaHoq5tBUFsgyOZcJ7rsnAQibvEPr+zyOw/2TUbLOlny1hTQoW2qMvT3cDjqGCyBhA7ESYkAxVz+r6yLIKJZSr/IWyubCVjAs2BJdNIS3y8LliWXK/ZiWB3yqd+YzFwFi+tabyfd1AZlHQsEHzJkJtrZRHcC1ve/FoDqVRDlW1EfWMkUCNl9LYIooQ6GrxLDoo+alNmD+Je2mgmoFi7GpYuejV60D95QPFX6m2Fhps9w9KrPb3rYwO0+M20g14vt4ghJoBr8alc+GwEg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(376014)(1800799024)(82310400026)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lgdDKws0DEKq0GXXk5XbNYnMBHvBoIE3lEO0CjrrOdN9+L48C+zC39ywQWhGqvy8vD7dTVOE1RLOrqKp+smU4UP8KTtUwEFPQt16YNs73dZaKsJyvHr137NaUXxgLxwdfJcncEl8uV2aXZ40PLicTeelxKNOCb2uMjA+zWEt0WKCWy0q5soYJWs8zNkeaQ+tUrvVZfhmGvYFHZ2OGRS+zlQ5LbhJbqogSjiEsR0w3gY8Mot/i/4EKDseZ86ImHhwEqNHynaUid7CgamJcXHd3kKZa4pG8RsVgm4lmUHKnv0vS/u+2rjoov7DHOV6WwsL+C+fKjuzgJ+VstdBgH/xinOINFXjsk3v0V30c9i9ADRRa77Fa+JAKIaFlOD7WRDAQrqmJvA9sl9bLitN4dkddUsrImJbcP8C3lwV6ilxUOZPoMLtPGhS0kjPbLeXwthC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:11:10.8125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3069fe98-493b-4492-8e7f-08dea477990f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7744

The GICv5 VPE doorbells are used to notify KVM that a non-resident VPE
has an interrupt to handle. We use the db_fired flag to track this,
and therefore need to ensure that the flag is cleared once it has been
consumed.

Explicitly set the db_fired flag to false before making a VPE
non-resident as any state is stale at this stage. This also ensures
that any incoming doorbells, if requested, will be observed.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v5-sr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 04c5846b9abac..d27fe2911df3f 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -22,6 +22,15 @@ void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_=
if)
=20
 void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
 {
+	/*
+	 * Clear the db_fired state to ensure that we're ready for the next
+	 * doorbell when it is requested. If a doorbell firing caused us to
+	 * enter the guest, then we've already consumed that state at this
+	 * point, so this is safe to clear. Use WRITE_ONCE() to ensure we're not
+	 * racing with the doorbell firing and setting the state true again.
+	 */
+	WRITE_ONCE(cpu_if->gicv5_vpe.db_fired, false);
+
 	/*
 	 * Make as non-resident before actually making non-resident. Avoids race
 	 * with doorbell arriving.
--=20
2.34.1
