Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013005.outbound.protection.outlook.com [52.101.83.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6A223A561
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306733; cv=fail; b=ipvWOr04W6jiR96QUTlGpcace/LWRzeKnzoUYeUCjiMsV1LsI+dudq0phUfp//xzQTP619x7xBzmUyk6Pbt7oK3zXOBoB+j4aWqdRlKHcysRIrVT2xYxXUr06NXP+hNHTjgJXdOOhSdBZGlm3ZyvohZITOvJY6JFT5Sv2KN/3ik=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306733; c=relaxed/simple;
	bh=17NR1E3YbC9gkFTxe4eLSERjHXsVFmzGc7DWQneu3Wg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gbm/kZIji7G4dV0EkRgX1dpGgTFPKzt2MZRKY1oQI+xSFnnnJ5fWV4nyyeIi2V8f//ysgDiModBpnIvtEfrTUEMnFFHvec9I/mA4OliV2Gacm3uNaPhGDv44dHaLb6XCoNNf9knYz2EyxP8fPBQ1C3vC38TgkApt1n+ng/mBdCA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MYFIb6tT; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MYFIb6tT; arc=fail smtp.client-ip=52.101.83.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MYFIb6tT";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MYFIb6tT"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=exIdmfCGAbTmiUH7ILyS1fogEpqiXGL4/If7TJBMp5uQTN4gxQdf550XLBiKJFYA0XWphaVSzd3yHu9pxujRgZuMMNKsi+G0ojlsTtNfYSjuucHq/9tp2PKHVFLNOZLgUPyvFGz+AiAoYdApWlkBf+l8GXMjrLbMZFyuGT1+m9i4p/b2y7VCVxnyVffXaGud0QDfVj0jDhvY0486Lx2Uv/rCjfnVp6w3H2PwPnF8LpIlarCPmuWA8qEl4svnPmNKfzuCwE4GQ19NT6w3zmrl18Gs00xT5AyRuuvyvBfV/x3eAzaiM9kpepzK75rfsz6ysEnsptUmxBVMELiPoL+iOw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfIaMSvtbpDVNYKBMQRTgyg/vPi7nII6GQo+IaPqZBo=;
 b=xOuhQ1VCXIv84earC4IuVGMyeSYMwCNobj6sxRF33Xu5Fpi3FlCSgasLeyOqYm9ALTawhXuzMCuOf31FGVIJqtNUwN+/+naLkY8A05v2fsnEJaZT2SlDNPnd1eROqqlez4jlTRyNlGpGOAn7Mg2QFJZLCDOTjiBjx7ltJ1V09N9Zq3/oOimpBD/6GJ20c1lRq1BzyS/V+tcO0tZvoJNaA2ElXEIRQ+kyt+bmgQpDiiHuYaUKxWUKmwIm3WxQs226xPs+4kAgXOlAVOHpPqsEtar4NGUV66JZC2tEq8QwC7+lx5Hj1EwLdSih+a3YXs5hZJZvtUSKijuY4NXkGR2xXQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfIaMSvtbpDVNYKBMQRTgyg/vPi7nII6GQo+IaPqZBo=;
 b=MYFIb6tTellS7GHs9BWhPhuyjbFNj2OFzqLPDm7uyeMbeCDN/Er2036bSXDBdgKmk4tomLMaH6y5m2HMYMwUe7mIQn8jcigndp1Q91T0Ni1iu+4SUFClUM8JmU7RqwpIzcTanGvVgLOLqUsWwHVMkA0fBhBNG2vB6q9q9VGQ2Pw=
Received: from DU6P191CA0017.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::28)
 by AS4PR08MB7952.eurprd08.prod.outlook.com (2603:10a6:20b:580::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:18:42 +0000
Received: from DU2PEPF00028D02.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::a2) by DU6P191CA0017.outlook.office365.com
 (2603:10a6:10:540::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:18:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D02.mail.protection.outlook.com (10.167.242.186) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48
 via Frontend Transport; Mon, 27 Apr 2026 16:18:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IwmlC2G/Orx7XI7iRtcMIDe6luxvhi2bIp0e0VitCfu0mDPgrPC4LSSw1f4roPiNmWX8Z98JU6IamTta4xKPM26wauDchyWDtGtAmFgTAbY3+hgS8oDeuOGdJWNzBEnUc1FlotAYTB2akmuOI2lQgqtItIoD00pC1+N48hGbk5WfhyEdJmpqcWMUJ/x7PR7FNaepIoVr0kWGBUNr4WD1FPbuGIINtnvjTTptzDA3fUwszMYvY5m4tY0zeDOEWHlNCrlGqvVrL4uRR6yVfw22A48SxAWMg+UG4kb/p5jOOrRWMK3tK8c6ogai2quHsd4m4xTRQFe2utDmKCOjtBqnOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfIaMSvtbpDVNYKBMQRTgyg/vPi7nII6GQo+IaPqZBo=;
 b=TUxC0iopsZGgXn5hGcfa68cWVvzCzLFp1ijmVSURqkW2RssPidym9Wd+RNNzEZ2LhMMpWEZlsPw7ikO0t/a9htKw88Q9jfaFUPmhIxkGMLFNWpu+N0LNp9Gjw5iotDCBSOzaHIUesyfVwL+SwR+VtB10uPzIGNsky2oy4rgcHSMF2OowyNJ7i0YkPCBd4VmeFHEjiQVOsKaonL7mS3ndCPk7GoTnSMaWRNnmIOwJ4+Udocw3RJ/ZrQKwp1uhkDJyMh9SbD4OwFIoMxSzRR3eB6D/OSqQgZ6O9WyzBM0iJb4mE6YmyEOIsv8jjyholFWH1vlBvr1C5fhTgEouEnxZBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfIaMSvtbpDVNYKBMQRTgyg/vPi7nII6GQo+IaPqZBo=;
 b=MYFIb6tTellS7GHs9BWhPhuyjbFNj2OFzqLPDm7uyeMbeCDN/Er2036bSXDBdgKmk4tomLMaH6y5m2HMYMwUe7mIQn8jcigndp1Q91T0Ni1iu+4SUFClUM8JmU7RqwpIzcTanGvVgLOLqUsWwHVMkA0fBhBNG2vB6q9q9VGQ2Pw=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:17:39 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:17:39 +0000
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
Subject: [PATCH 34/43] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Topic: [PATCH 34/43] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Index: AQHc1mFeQyoY0VnWikmNvFWx18hT5Q==
Date: Mon, 27 Apr 2026 16:17:39 +0000
Message-ID: <20260427160547.3129448-35-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|DU2PEPF00028D02:EE_|AS4PR08MB7952:EE_
X-MS-Office365-Filtering-Correlation-Id: 76613c25-7ee6-4c25-4a71-08dea478a634
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 6wmvD7E+P3oKuZosTzzq8K4IXwrNQ2daqCkG271aGGiLCrUIOVHNY8e1kZqgjtOVBOX2goiFiPIIBGI+lRNDUr+NlJi7j7pzRCouFDy5Rt5nCQ2XFuK7UogAweZAQwnxsy8lWOBuy7kUNWqXLRRnavhxGiAdx/4nrko6M0hM3laoWELgSZM8tLq3penAG4cv+xWn3N9kQY29Ut/kOjeiG7CD2riC6u+c2QPI0Bqh6ptIzXT5uh84htYbkaw7jGqlw5haIc5nZqfNsu0vDAe3Efyf9f14+76y8+01ik+l746qwvflc74dQjVKouMMH4w8kAIq8sBjcKXrAvDmqbfHhT7+y54HitwqL45ew5nLT/K76FPWm450AR5T0lfhNNak2WADy/3xQyJ1zulqH1z0Omj6ytM7fqyQ/Dea9th+mG2u/l84OvugEWj/YlN5u71hKj3MjHlt+a+3XDRujy3yzAvzAPoqmiwjjClvB/xek2aVuiUeo0tgbWw/+nPw949iDvtFSznODYfEqB8il/yqXpb+Dtiwfvmop1LNSSrGStAVBICwFe1U+ak5pZ7Bp2isHxAzQnwOV94494JEM4ZYvUK4BiOxrHKT1gDnqzEoiBmrhAcVByybi0IXByZn0zxSmE+l28P8py0wYOuZ7NR0kBX7ZUJ0E2w0QrRQHn7hUMSWPI7bzE+z+qkHEVkWWLnkaJk4EuIilO3omHhei+l5ZBXEWFZNM1Gl6S8/ZopC7TJhHdAh/8qw/2bfTdms6RdAI+xxwBy/Mc/9Q1HP7iZErhFzInQaR7qDrGnz2Q7kr6U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 VwaPtF6VBofeV5ob4A2rfLbCf8oWerulhdjorlm4R41jhkqJYlKsSYIYw9ON6MYdYREOuK2xWnDDEogGony8DXO80+Vzfwc/7XeDQHioAUsMnk00/n1K6JctAJqR8llQs+kobByrcNZurPNjuS0DXr+jemBMwJEqSYOKGc7UY3bfPr3AUP+niPIQVdkmoqd4BmvMNOKPQolRwRLoEWC3Hmym/+CqtwUKwWxtrYrmXoAeOViJNcl4/zSuyS/B+BeotN1cdUjN6ta0SJHl9AmF48VdpYg/RmZbm79/tydgagn1zMDPLSwpXwQerS0GvuoD1u1X+hofkNRUl6jb2y4g6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4873d78a-a866-4743-635f-08dea4788085
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700016|82310400026|14060799003|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GvUrEHHd9wbkm2e8Dx72ENw2NLZ/vm8c1G8joepRSx+53TZ1TukENr1p/8SuEOiWADyKSRoEP8m+TDp9nHg7v/6hYajZFt8QdyFBw8DVfO1C8iBi640AwQwukXI1Afp7xBnYL1pMFJHylDjhiFuW1A4Yt6Gwn272cFLMLFxZELzNG3kl8hoGqo0c7BZSi5zDWuI697PsVohg+k6rxjXFv5l08UMcID9ic1TPjJp83nILN5YdsBWBuC+hid9YURQ8VQV1jsgLxktXWyl1wNSj4Zd85lG7cImZmKD5iXezlmG31xK0usGHP7ADj/BstAybu0gOHM0hB/E7t3ks/WzIeujqtVwWwyUp2RySZsRDL9c6izsYBCeRio1IoZJlLYFHdstvCBnUdQP+gwUY6JiCdr0QLCCuZCxpgypm3bc0/OJJQ9YzfVj6TBcCl4PSL5F4kVQdgVrTXPt5a4Vd//m6erk6gmiu2HtY8PSmKfIfifqB2dD7c260KAvRRrA8Zyn5A8XKWvAkatYsl6H3b+fk+9xiF/cCBrM1dDrLZtnL9dnaqjTkTrJu+qdMqRqLT7ScG7qKlReXbWdfzOn6wmvs5r+xC1iFJXHx41+znMQcrCN57333E1dK1Ev9AQ6qXGa/kI1nb16fA7NUreDEyfaIczuIdSPz1xAl1z14/AD6SDxiCK9ho3dTujvQA2INu5VAFyNfgSRjrM4tewTrxQV8v4jELA3V43YibdFYkwBVtKif+ikevpkrD5nehv+ihDKndvRe6NHOwRiC63CVZhyggg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700016)(82310400026)(14060799003)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ibuS5/kZZGR0QwM9T3eoS/1trIHoEmA1Uh5VMScnMbUv/+pqmKQNJxmFcn5iUv0mBTQmY52jgeGC6J3bl4cos52OC8VM+49FqcsD6Qjwe23WpTyTh5CtSWowvVq5OYx8ZJvDkK30rjtczPOfwRv+gYav/FrvedqgORTQE+wvPQV7xth28OtcigCTGCRTPcfU0N/46jDQNZPKatSz0AnC8cdl0B86vJBHYIis+gk9F+Sju+WxsipTcvhnvM/OaYaqnO8MVrrtTw+VT7C6vc/1124YNNyn30d4JA37XfKkeVqdK4vxtHsldaYrgalrkEPDlrAHZUMqJ/9ovRaNV6jqUkDqIKpaehV9TsZn0w3aEZJuQZhJUsim/LqKYOyhK7NH2tua8LlsF8nEKx8/V0hk/k0T3vSDpEt4pq4RIUJap9MucU9kyBGkD9ERYtINDtVQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:18:42.3534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76613c25-7ee6-4c25-4a71-08dea478a634
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D02.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7952

Only a subset of the possible PPIs are exposed to a guest when running
with a vGICv5. First of all, only the architected PPIS are considered
by KVM. Secondly, only a set of those is exposed to a guest - those
corresponding to devices that KVM emulates (timers, PMU) and the GICv5
SW_PPI.

The finalisation of exposed PPIs happens on first vCPU run as this is
the first time when the full set of exposed devices is known. At this
stage a mask is calculated, and this mask is applied to both hide
non-exposed PPI state from the guest and to reduce overhead when
iterating over the PPIs.

As part of introducing support for userspace accesses to the GICv5
system registers it has become apparent that userspace sets of the
GICv5 PPI registers can result in a mismatch between the state exposed
to the guest and what KVM expects to be exposed. Effectively,
userspace can set the Enable, Active, Pending state of PPIs that KVM
has chosen to hide from a guest.

Under the assumption that on a VM restore userspace will set the PPI
state prior to running the vCPU(s) for the first time, rework
vgic_v5_finalize_ppi_state() to not only calculate the mask of exposed
PPIs, but also to clear any state for the non-exposed PPIs. This
ensures that only the state that KVM intends to expose to the guest is
exposed.

Note: If userspace chooses to set the state of PPI registers after
running a vCPU for the first time, then no masking takes place and
that state is directly exposed to a guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c          |  2 +-
 arch/arm64/kvm/vgic/vgic-v5.c | 71 +++++++++++++++++++++++++----------
 include/kvm/arm_vgic.h        |  2 +-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 176cbe8baad30..28dfb6e079ee7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -953,7 +953,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
=20
-	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	ret =3D vgic_v5_finalize_ppi_state(vcpu);
 	if (ret)
 		return ret;
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 38e37a03ac951..3e435a31b463e 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -915,9 +915,10 @@ void vgic_v5_teardown(struct kvm *kvm)
 	vgic_v5_release_vm_id(kvm);
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu0;
+	struct kvm *kvm	=3D vcpu->kvm;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	int i;
=20
 	if (!vgic_is_v5(kvm))
@@ -926,35 +927,65 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	guard(mutex)(&kvm->arch.config_lock);
=20
 	/*
-	 * If SW_PPI has been advertised, then we know we already
-	 * initialised the whole thing, and we can return early. Yes,
-	 * this is pretty hackish as far as state tracking goes...
+	 * Discover the set of PPIs that are exposed to the guest once per VM.
+	 * Once known, apply that mask to each VCPU's restored PPI state as the
+	 * VCPUs are first run.
 	 */
-	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask=
))
-		return 0;
-
-	/* The PPI state for all VCPUs should be the same. Pick the first. */
-	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	if (!test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mas=
k)) {
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+
+		for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+			const u32 intid =3D vgic_v5_make_ppi(i);
+			struct vgic_irq *irq;
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			/* Expose PPIs with an owner or the SW_PPI, only */
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+					__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
+					__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+						     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+				}
+			}
=20
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+			vgic_put_irq(kvm, irq);
+		}
+	}
=20
-	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	/*
+	 * Apply the mask to Enable, Active. Skip pending as that's calculated
+	 * on guest entry.
+	 */
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(cpu_if->vgic_ppi_activer, cpu_if->vgic_ppi_activer,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/* Also update the vgic_irqs */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		bool visible =3D test_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
 		const u32 intid =3D vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
=20
-		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
=20
-		/* Expose PPIs with an owner or the SW_PPI, only */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
-			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
-				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
-				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
-					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			if (!visible) {
+				irq->enabled =3D false;
+				irq->active =3D false;
+				irq->pending_latch =3D false;
+				irq->line_level =3D false;
+			} else {
+				irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+				irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
 			}
 		}
=20
-		vgic_put_irq(vcpu0->kvm, irq);
+		vgic_put_irq(kvm, irq);
 	}
=20
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a47e5c742aac8..778ecc761fe79 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -752,7 +752,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
 void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
--=20
2.34.1
