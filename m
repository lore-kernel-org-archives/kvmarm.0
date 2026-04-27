Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012016.outbound.protection.outlook.com [52.101.66.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7448F351C02
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306641; cv=fail; b=UzwEleif0qEFHJi9N8lccti5Fv3a3RduKDv1pbYD9Q+l9e0LQ+panD2wRbL9J/OIFMDgZBCwaODRxNZEJvyDtyGcapaOCoKF/M4V2fGu6bNl6g9pmge9GQkTKTpqX6hRCYC2Met+or1k8gBd8I/Rn2oXkTpZW0YxGa2ExnDo1kY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306641; c=relaxed/simple;
	bh=7cS+Ze6uVnBJuzTh4LOgxHMuzse+lwmOFCCt7HlMuV0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d86HyLNpHrihgAGfa3X/On7YuZQnw3vSv8eoDcA0HPYscTYN5UGOtTQe7cg7Q3wVMhsvdFA6T+AUigHek6+bb+Bs/fqIAdypTucBKgeC4v6tmFO3erRQfi/EKBwY4F0jRaYIP+uZ5nbMoO2wsnKo5qiz9HgR5+GAzyPyvPL6NHc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VyPM/FY/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VyPM/FY/; arc=fail smtp.client-ip=52.101.66.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VyPM/FY/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VyPM/FY/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=l8wIW7/pMJ+HBNSW+b2DYdDTe1ztS4ln6SHdi7bokVY5fnn8hR/6LDSeU42pjn0NshnIx+qBzCQgrpopcq5muFDJXzWxBs9kVIFz+D4bFn9TLV1cvr42MXSsqecUm1MZY1836s9mDEYjgyxWl5QYIo/5qoiU61RAANfwJ+5xMZ+qKahizM8lyk5RDqCoHR30SJVndSC2aN/eFi9WZQe9Up3pRCJadQdmktlw1FVZRRuGgl+uXeoALUsQ+ogUHwssNurhfOLVGs1f1KkqiCj34S9oMv2wo2DPmDFL/Dah1Dpm0j1L65j/LE1RMJp6H36QVWt5S0jRmmOermjDR7s90w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2/0uvAyIvtRMlsATL8LOHCAdqkHo3wOWsSzqMywHz8=;
 b=LRHIcVizd8BMq//4tupjcbi2j82vBTS87gI8/webaRR8eUK/nT2U8qjnm8xwYzPs0/Q887hJv1hNLCM2Bz0PwQfRLO5UyTSc/rJOzVpmJLsXS1uqqoDLx+/fZ42DsEYxjEYzcJ6asBD03iZhabkHmBsMT+FPGEaM+T5Z2C8CUmvvp5+0B17YDBiRgBRQrQUkjv/bWjRLX7nASudabahjIpxfg4ZndlDVq+tRGNYq5bnIWE1zzV5Ga8GVuzTMmlpWHJmnppmvCZDvlP6PT/S9Nql2eq7LvQr5pt0jiCoFlltRlNiq5BbNrqvql3WmHY9NMsJTkgz/S4JQtcY9dQg07w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2/0uvAyIvtRMlsATL8LOHCAdqkHo3wOWsSzqMywHz8=;
 b=VyPM/FY/1I/N/ZPT6kq1TqdHOlpErxzqVKJIL05MHHDWuDaKJt46rhgRvhwo0xZGKgR6q9+MLaKqgDsITEN07bbx90BXTGnIWHKGJJ5B8XASBJjO2UGZ1kQ5YcoX/spNjoEtwad+q5CH+c6z22zKfom8LD6h32S1p3mUTrVjwgU=
Received: from AS9PR04CA0113.eurprd04.prod.outlook.com (2603:10a6:20b:531::18)
 by AS4PR08MB8141.eurprd08.prod.outlook.com (2603:10a6:20b:58c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:17:13 +0000
Received: from AM2PEPF0001C714.eurprd05.prod.outlook.com
 (2603:10a6:20b:531:cafe::ad) by AS9PR04CA0113.outlook.office365.com
 (2603:10a6:20b:531::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:17:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C714.mail.protection.outlook.com (10.167.16.184) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:17:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZeSFtBipg5T+WeysRjj6vULwJqgqLnbr+fI2f3/HsDNJxhiq9+Neb1ddLDNG4tYGoIiGwsUZE+aNddqYCpZPEIturMOaZkvqW0nsHNnnlEz8UAR9g098zJYwPSFO0mQsJee/ahQwG5vG4aMv+AA8NXqg2hJW+VqZe6s2oTxHHKPNZbbHRIC/Hc+vavn2YR1U5Hi/DHRkF7atjLgCGPLshPjkZWVKDnH49udJ+dpKBjs+YWMJH1Bqipxncu5MNHFip0q2qMnZzcdxcbuZ2AqINYD/b+u3BhNXHI5x8tZjVVx1F55dP6t42bfT2nLEJvxZTPHJUq4rMTilUYRvlWl4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2/0uvAyIvtRMlsATL8LOHCAdqkHo3wOWsSzqMywHz8=;
 b=MSWcSO8fCt8rbykr4TxqArH/YybzRzUpdBvFtwqrFnP6zjIGic2uhZs1fIjGvNHcaZJUkHWIC4q/5GEDQ4k0OAB6/JHtO+ZcoGtfjJhaXV1nFmg8IWpO2UhXuzKTQpBrzB2+/2e1mqDGbD9r6SOGi99sAMsD3Wf22JnPKJWqNbBhFffKiH1a9dIV9U4btY7Q0BQTSVM21HlOKyEqsyjLz53tMIjCCpMkHJ6zPNDqjfnTXbsQ75GODkw2Hm0J77ryGynp4tKJqvBFETNj38PFj23DalwymwIWAE8VK6IFoKczq6n314XX1nLy1DoSpQMYUuGb58TdRJeftqKZbZxpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2/0uvAyIvtRMlsATL8LOHCAdqkHo3wOWsSzqMywHz8=;
 b=VyPM/FY/1I/N/ZPT6kq1TqdHOlpErxzqVKJIL05MHHDWuDaKJt46rhgRvhwo0xZGKgR6q9+MLaKqgDsITEN07bbx90BXTGnIWHKGJJ5B8XASBJjO2UGZ1kQ5YcoX/spNjoEtwad+q5CH+c6z22zKfom8LD6h32S1p3mUTrVjwgU=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:15:56 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:15:56 +0000
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
Subject: [PATCH 29/43] KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG hyp
 calls
Thread-Topic: [PATCH 29/43] KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG
 hyp calls
Thread-Index: AQHc1mEgz4c16YDstUmTIly9d6H9AA==
Date: Mon, 27 Apr 2026 16:15:56 +0000
Message-ID: <20260427160547.3129448-30-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|AM2PEPF0001C714:EE_|AS4PR08MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: da2d6f65-913b-4645-77c7-08dea4787148
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 p2puKlqZecBrwYkLKqH0LXUP1AfeMZdgG7BokrjLQGFTqn2dNMhzcjt00587mng5E72A8LNsEQ+DJpMZuVpApipDO84s1CcRMzedtRFtkR2W/B206Ow317Q7DONpZJk4T0TYYfCia5gmxP2VJ2fovwAuSZ3by7aTw7FHQt3ZUKJoJPrZUDZ/kcVk7ALk0oQYg3IPnpx8q/HFn6G/uNYEdc/RLqyGgKX3RAPTSy/AqyLeU3eFZI1j+zZZZKNSDbXp4a1/n3z5SUpVQvFE5uv/e4VGP9ccxou2007KpRSUf+hpds7WYs+EkWKzS5df5FdoSTgQ0tuKfjntGK0zrsJn68aZ7L9itezuBvLCcTCV1ad9Zzjg66Kp/Xwi+Ex0jiHpX1fY1VMKxyr6SGDQ8fvXY98TNXruLd0WsmuwT4Dvk1+jl2eFzdLupiovfMyhdY2bT+HGsA0wlgtwhuDaC91HYb01SaDCPk9vnf1pwvm+dkuarmFgTGz3jzk3G40MriTn179/VxtwIodnkmDt6Lt+MZm9JIv1wLYLCNOxmjXK8xDHyc3bd1GyNoMCW0QaiOIVRfCpbgBu8Nnicl6njY5htpdy9FDSj9exi0VHdGkT/fbKVhudjIXpID8qjlASpMmSCqozz54MM3KuCr1xFb35u5SENZKlfWL8F+ukJFjG+O68Mg6UVVN9fM/w1f8l3b5j9FfiZMxih5x+Ex+CBSJPTwmz+2r6jjzvBpEdF2Q5oTBYJEfxDQNReRK24J5i0h9cFFmPjqqjaPYYUVx3V62h80U2i6wA37dCyJ2YUNrsRJg=
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
 ro4VXIkddJvkfPhHI340rajgFTECQfQ8O6PyU/Hw3flpr1XXLzKBieFybv6deDHPqOvohr1WxRAnv7FEgQDiKXq03mGUzthvou3V6dd4OrfrJw6FKSXWA5GdHB4llrKlQqSg+V1KbPdsWcYni25C8HFN3t8JjAm+Uoz+lxQgReQBWFkz2vVLDDJBvZgvX2N8oHFJh2OeqIaCbwMAYegQPXt9HuYCLdv04zLa//e0SfmakmDcStqwtgg7RAxZVVnoN+EAgnBKgmd2D2CHh3yFfXtFBpEpxUK5Gce1ok8xmnegCRTBQctTZvBn0De2zPC+0aAMSegQmtf1NfCgsDd5oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	734b1d95-3653-452c-3e9e-08dea4784360
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|82310400026|36860700016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FP0ObmcYEZfn0/ebgJ6cglje23BwtdSEpAr7oWorF8dptoRdx7GbGZa2l8iLhKw02Ss67JmHcQLdAwzHXUDX/nxrh7khV82Wq1SdY6MTLWVyMANXs1sKQ9nU5fHH9Qwnvu3gwnVpadjD6UlbA5E8281hdlZ2GgxsbHf/sJRlxn5CniFeRNfO9ND7TE7F6hPEBwwVhOAc0e4XLxOL34nAzl+ijSwnOHnYEUOM9plFBjYVsnw31U1Xy55jDBerV3crIYHD6yGInWZcerI2hXfzPeuCbqxHppEQG81ccpGP0UKnYLVS5pGF4vytVgQrZEgXI43LMiJoVBlTuQfagSS7yjIyPw7M1/egMB8mmlSge76h21oOVNqg9IJQRfxSwmvcPe3aZQnHkS+JJLLayZkgCXgMKYCztXaIs7R6qPdN6d8KXdZmtj3n4oBfHWJyjNjX5qs7EsrkAChlkNXaz12DJ+z1t7D3u2kP/zIRjJvDWNJnSUMgqqIM6hSd26oG0XHBJFXhNtYP7Y9QTmlJCMQhoVzmrGS8XY+fh5/4u9lyaAttvtZDFe77qlF5qVEMUMFbEqZvd7iOOeDS/olNoeYAAglKeUeTcQNqKBLJc4FTeYALw7plDVJMvXzdx/BXgSYTvu2CSt+KRkXeEvG9wASbl5ZHUvN1a+qp1WsqUzLqvcTzFmfbTQFSAuyHTG8nUMoYVre8SHKzEg8enktSqx28RC3q1bTleAsoowvNV9lZZb0LRg17se7Nin4GfhYPpoiv1QTj9SIugJj7Jofe6UZP6w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(82310400026)(36860700016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vcL31CmljpRPRn8fo8Xkzh/altB4zLK/p+UeVelBoShk5tMhmfgPENe6eLvwDNToe7lHza7gdZnyo1/WULuBpgWZAIYyHmrRD4e8UK5oioXWhRBddMYg+FM3LPo6qtj5ciA4HseXX6RNacMzXOZwrgzyRjGoLMCMLGSxQFqcfnnILjG3I/a+Ppz6Ow3bIPeFihXz8MjviLagSUH6z2PTO/MZGi4Etnf/Pbyy4n/l/FwnctPYOLf5zgoopdRZRmA9T8VqcuYla/hdaXxRX2BFbZlNyuroLkvcHp+t2ZT3vwve+iKRBzGvtr2/0XUfVqfDRfZuXURzJZos6z9NLDkOhQUHpnOF0ygWWDRJMGS7PK8K8CEWZDHSqshp26DT8KSywiRkDvXX6MFokwczlI4N15ovql9GwY/nzf/iwVRqpMx1XwYOXEptiP1Ki9FkClqX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:17:13.5639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da2d6f65-913b-4645-77c7-08dea4787148
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C714.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8141

With PPIs, their state is injected via the ICH_PPI_x_EL2 system
registers. For SPIs and LPIs, there are no such registers as these
would limit the number of interrupts significantly. Instead, SPI and
LPI pending state can be managed from the hypervisor using the GIC
VDPEND instruction. This provides a way to set an SPI or LPI for a VM
as pending or non-pending, i.e., to inject interrupts into a guest.

At times, it is important to detect when there is an interrupt that
has been "consumed" by the guest (deactivated). For PPIs, it was
possible to do this via the ICH_PPI_x_EL2 registers, but for SPIs and
LPIs this needs to be done using the GIC VDRCFG instruction. This, in
combination with a read of the ICC_ICSR_EL1, allows the hypervisor to
query the state of any valid SPIs/LPIs for a guest.

These system instructions are only executable from EL2, and therefore
they must be wrapped in hypercalls for NVHE/hVHE configurations. In
the case of the GIC VDRCFG, this hypercall also does the read of the
ICSR to ensure that it snapshots the correct state. Not doing this
could result in reading incorrect state from the ICSR as there is no
guarantee that someone else didn't sneak in meanwhile.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 20 ++++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index 8c69f1f4de534..453fc063eb61b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdpend,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdrcfg,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 5f9184276b04e..20aeb29a4adf1 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,8 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if);
 void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm);
+u64 __vgic_v5_vdrcfg(u32 intid);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index 804a9ffdc8594..5c4dc2e71fcbe 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -699,6 +699,22 @@ static void handle___vgic_v5_restore_vmcr_apr(struct k=
vm_cpu_context *host_ctxt)
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
=20
+static void handle___vgic_v5_vdpend(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+	DECLARE_REG(bool, pending, host_ctxt, 2);
+	DECLARE_REG(u16, vm, host_ctxt, 3);
+
+	__vgic_v5_vdpend(intid, pending, vm);
+}
+
+static void handle___vgic_v5_vdrcfg(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) =3D __vgic_v5_vdrcfg(intid);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -726,6 +742,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_make_resident),
 	HANDLE_FUNC(__vgic_v5_make_non_resident),
+	HANDLE_FUNC(__vgic_v5_vdpend),
+	HANDLE_FUNC(__vgic_v5_vdrcfg),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index d27fe2911df3f..05090f5a0d9b6 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -148,3 +148,23 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cp=
u_if)
 {
 	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
 }
+
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MASK)=
;
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
+	gic_insn(value, VDPEND);
+}
+
+u64 __vgic_v5_vdrcfg(u32 intid)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDRCFG_ID_MASK | GICV5_GIC_VDRCFG_TYPE_MASK)=
;
+	gic_insn(value, VDRCFG);
+	isb();
+	return read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
--=20
2.34.1
