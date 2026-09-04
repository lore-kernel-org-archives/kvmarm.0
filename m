Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013049.outbound.protection.outlook.com [40.107.162.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1398433939D
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522281; cv=fail; b=Kq8DxLq/tGdfC0So0aabd09NRk1WDV7HL7C1Z5KD7AXjqYLTfte+4SN87ncP0IRByNi56+xKrv9MCFzuq6mkBSWN5uwCoKi//FKQiiV/8GVXgaxwVBCubbRbatekXnUacsx/g1UYG3Nr/Da9COGnQn846zyaJBVF+RCSut38bhw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522281; c=relaxed/simple;
	bh=mLSEKOFIVQgProFWUp+yVbDorguFE1NOtvOCet4v7A8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DH2MwksIrekxxyiaUDO0CXgbTLYKpros2d5PBwlftZSAzNQKTNgiXjivkukb17lhtTZYRqE7uX4vPwMYrS2JVZmAsolAGRHIf8Ya1kooJvvqa4G1AMZv/DiEpK0j1CL53T3VvqmRzY6q1YlUaDosUbsNP96o/tvecvoCf7He5Fs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KRfEljpi; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KRfEljpi; arc=fail smtp.client-ip=40.107.162.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KRfEljpi";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KRfEljpi"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=t5Yggz/1evLMMKkANUr/gjieWzKd6WY4QCu4MS6emK9xzjKyKrNhWuCoRELQtJQ7JQYC6vaKIkTZioRMNXKMAGUKuBbFzDxcvVVRo/62pRh9vJiTh3Y7c5sUsNMGQ6zQokHI0seANYRyj/BiiYI9l2I99aKaTCYeEjjXm34p7n/sMRpzLSezXTa9qAj0raD2enHn7rLWxBzvif5IYBt5nr8eWjPFneG5xAc6adTxbl1xTj4Sfetvjp8sHtoe19w7P3XMLfZbmejaNIZlQyVaqCdMBztKUhjSu8acW6gkBwpgTx0WjlU1zdahCzVuA8YZR6RgiE/zs7ubgsWUd9rIBw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FQ0HFjhjnMDb72ISnm7T2X7DcaXkUspM5GjKe554n8=;
 b=yP73GLOJqPeyzm49xi7ESQk4MvvLEuEXoB0XEhsB4Y5fVnzwXR4BOPXPc+5+ysLpkus4WkWyYuUMfqprv3C83yhS8YlABdZ6VoYk8bJEpZ6uU+sXH8JVog+YIsfGjgn1RHwNBqSk7ciLObAIfD7x3KfSCYuNuHre2jUsotqVYx9IQJvWS9M/YetUt/pM7bq40x0LDEfHHp2ZwOiC5OoJw7ggvxuk19xl2dNfhOYYBuWlxgQ2tHpsdz2nw0tluWPecUAs0S6yhioF4ti1MFwmRU1HMQQ+m+rjH6/tZgT7AvTZNNypLwb0dLxbeXFV5rT2n5IZM8LwjF432DNZOqfTRA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FQ0HFjhjnMDb72ISnm7T2X7DcaXkUspM5GjKe554n8=;
 b=KRfEljpicY65uk7Iy70yFNIr2lTgIW8WVU2hEheb3X20KohDoYdchz2pFFk1XEt8UL4sQFORmJ21Yw2jfbk9zFBF4ZAVgXgq4NVHy9WibwycrUyhWso4Js3rCNSKpZvjyg+yEGP3nF4xyOHn1X9UvteQQT92kin+mr9lx1zkQCI=
Received: from MI3PEPF00004E9D.ITAP293.PROD.OUTLOOK.COM (2603:10a6:298:1::454)
 by AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:44:32 +0000
Received: from MI3PEPF00008486.eurprd02.prod.outlook.com (2603:10a6:298:1::45)
 by MI3PEPF00004E9D.outlook.office365.com (2603:10a6:298:1::454) with
 Microsoft SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id
 15.21.382.12 via Frontend Transport; Fri, 4 Sep 2026 11:44:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008486.mail.protection.outlook.com (10.167.240.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:44:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpJfzmxFpJnBQGiqR2JM19uNIhl7l8RDyZphY2NYaOTZx9Aq5tFtRaGtHMbSt5QZI3J3eg21fQGbqZDa390uV1otmkGYFkeTXShIIS7+WM8OKV2uX/mognz4MrecqxP/1XJwZ8/rSX4VPL6//ZVcNIWoKKxfPO8MSTspKqLNsy9plh2cEq1p5RAjj5bQgBMGDcBGqUw62jOhxp4Ce941291tTccR41wdVEgua8SSlcgivH1rEiyM/tC2xi8wBw852CcA8OcfsYj4A7XgXM4zLj4bvtCt5IE05gKSj1EVv7ThJ1I1YKNPd7VVE2NH8leVdjhNzK73l+7Gk+3ePBk6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FQ0HFjhjnMDb72ISnm7T2X7DcaXkUspM5GjKe554n8=;
 b=usdI7ce4DlCcKQC4nNMpShQzmWpMI9KYcuicQMSUqd1bgXQhcgVE/EPS+WlClOliBS/DxqbGwoCUBtznbIz5emzfiet8m5Btjdwo2botk4IXAL6z9bVZ0M+aSSbov2ePjf7em50JxwOAJn1W0hMFbu3B4ruV8UUYhPkXuiXM2DWsEsFN5tqXzokZ/4C82V/A0RXsXQCg7+tDDMW1tf6iImaqiTDShle+5p+CE5+IkvGtHK98u1ZvA6YJq4CO5hjVUcUWTCunPDsOflMAfez4K17QrI0M0l6NTzZeoUhglUhVjJgvEa2gyoLFc4HDGWQ3jg/M29LZebGN1AbCC1aBjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FQ0HFjhjnMDb72ISnm7T2X7DcaXkUspM5GjKe554n8=;
 b=KRfEljpicY65uk7Iy70yFNIr2lTgIW8WVU2hEheb3X20KohDoYdchz2pFFk1XEt8UL4sQFORmJ21Yw2jfbk9zFBF4ZAVgXgq4NVHy9WibwycrUyhWso4Js3rCNSKpZvjyg+yEGP3nF4xyOHn1X9UvteQQT92kin+mr9lx1zkQCI=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:43:58 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:43:55 +0000
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
Subject: [PATCH v6 19/49] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to
 UAPI
Thread-Topic: [PATCH v6 19/49] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Index: AQHdPGKqR3SeB8NvGki/tQ4OQaar5Q==
Date: Fri, 4 Sep 2026 11:43:55 +0000
Message-ID: <20260904113404.4051341-20-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|MI3PEPF00008486:EE_|AS4PR08MB8241:EE_
X-MS-Office365-Filtering-Correlation-Id: f943f685-f53c-4af0-7671-08df0a79e26c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 ZoKpGMQ6TLuUJplYJ6hgnTkLwdArQCYi4+hvvcoYvYbnx8wCcfDeKdOT6AYGzsGrZbETGOC7oy/HkjVqNTL14oiFemIAmWugfSpJfsEIceRZe4PakmKhUZTZ2NPelna7u7oBIJCFEns7av85XKLHFR2+gH4/eN3jpxsBD5jRC0FI8KsljfbToIfUbhgiJiBZMspLi2E3+sQbVDBrBE//04Q6AewJ0QWs3VxeGTeXomSXxhFSRbmCi1rAOxn39Hg2TDaHO3evBJmO5Jjz/7l6MXvRKfIa7UNZIbSm7gJQ3XDtLVPuxrr95P8Kz2ZfANtclvcxv12Cl22dUtAr7q7U3jEz3Ojjfa/JbUgVmZ6jCdLs7sEdfXTaRZhqiM5cvYKem7XAuCArjJP/GRxVdFP/E5HmYD1E19WxgYCcw2ysPoSFY21FL61CVEYka8jqvWFnV6FJVlXPzvQ7uMnGPLuU+zcsgneB0QSfFjT5ghj5hvQkFrwdX9s2pO8WcWUDOITMpvWZH7FdRe9Ed+HbH2hPNi/3azdnfDA82gk/8da918PduSJJmkaRwnTyNrhqyKKKqxC66CldrUSWRl6aBLConipE9Cnqisuwqx7LF2EVLaL14A9r7gnBKefZ+vwcwmQyeqsRgVWwKOXGm4QsU4Vekm4TMPV3Ey6FowTMcHn7vA1pRNGo0ea7Sgik24+DYpccL7+eUhZBDXE0wgmuD483wGlR/pxUiLBvdaeZBo2HdCw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZFDUaqj4kfh3VHDKVSJDZwSLny8kFZ0yrS382qtzndXoGzS9Ys8Lr9RQZI7tySYqz14ULZaxGJs79QgkJ5niZhEdGUnsWTlAyYv2fInCHc0nE78UkLBSzcOEDxjVqecwMQOa077o6BKN85/zTyWcGX6XE2AbBeobyQuAm321RynJrNwrvFn0fjaqSIfBcBNp9qm36T3WB4sLODlaQl/RWxQtydV2kOjzyFeA+KLikbdW8KC12dXkLYMXCopj1hzRvpGiSuhSUnsqI49W65anjDybDPt+3PlXLaK7R2r6Id1Af/5pXDa3JVXDfjE5A8nYa3J2ck7pg3EpqqB+obADaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008486.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8bcde13a-df5d-4685-8466-08df0a79cce7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|14060799003|35042699022|82310400026|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	naAhTYa6OjNPd1FZgWXsLmYDiTwRiUFGGb4ckkfLt3uJUH5gfvvGLO7/IaF7Zdu6gKfDePylft8juvdwilCUgzTs1/gdelNmlcCkplvU5pJFrHMD3facu/7GCQGxiqhlN23yC7Qaftuh+pcdp6cA3fo6cuYRkW8n4aGyQbvy/l3L+IJwoIXCJFtgWCmpaPcp/ioJQrscCt6S8i2YKrFH4vuA8tWzABE6nCxeja7fZNFQnzk1PWxQy4zonvVgeuNMt0KNQ1Nq03IFDtdcmxD9enI934BhcGKvwDK5qXOr+5wKxkz8VW9eFLUxvRnCC5p0zTVYXM15QxafbqGOeRGFKIi/hX+vJqaCxqZT38D74GIQ0DEQ94Egn92MQmba7NjxfV8OdkC60mVvP4c6OIyZeZZr41FtvzvsjAB5brAhgzU121lcY1VOZidkK04bkr0bYgeTGfWdT3/Zm97YLY92awi2ZhxzA+DCfxB+vSALxJu9HyAPhJ3lqqlk53ObWGchrVVfX16gkuSWtc7W3LlJCdTnNY412xA/4ZMuMeSz0jwxArg0itvD5/cm1M4UdgRNYPDfp3yCGO4tiB9Ir3JVBksP34Bq39Z7BmH1qnFPnv5h+WblVtOq3rGvNESrbOJqrjjR4ZNbKjMkJdZ48mulybPV3QJEB5vDvZuq5xIn6jo=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(14060799003)(35042699022)(82310400026)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yYDTywh5BtxTTmLxVEnfd/IZwYfk/yImTV5EY3y6RKkkABOpS2lurvR3ZDR5pwZZhpBdS25571rxHV+/qM6QHlJEI2LbWf1pnFAECt1B4cY+cmGkhyA0UqG2gmiB9dhcqpW3s8MdXU4M/g99lMQmfq42qJYw8/mzt1K3CsR6aJo6OCG8GuO+WSZw0mjpoBVNpBPody3OrJZWxd7IEMJpTvIJa8FwkO/w/gSx5Drzj5XtvScWjJPrExhUtGly4uWK7YCB9VMPPu1djFK4Kc1FO88oYaDYC6R0To3NYP1kwQslz9vazdrY6SBjZD1PYOyna+15Fqu39Nt7RVKoqY2vuN6cTsVgcpAgFDhavSPhfPRwgttXrYKqZyspeRMhJaISmeCK6Tb7tFsUQyRrpBfdflDNXuSgbQQ2EolWAXNX9SlHGY6glAFAttlHat1rZJ1f
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:44:31.4272
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f943f685-f53c-4af0-7671-08df0a79e26c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008486.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8241

Define the UAPI address type used by userspace to describe the
location of the emulated IRS in guest physical address space, together
with the size reserved for that region.

As per the GICv5 specification, the IRS has one CONFIG_FRAME and
optionally one SETLPI_FRAME per interrupt domain. Within a KVM VM we
are only concerned with one interrupt domain. Each of these frames is
64kB in size, so reserve 2x64kB of contiguous memory in the GPA space
for a GICv5 IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 5 +++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 019e5e3d892e6..00cafa118a733 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
--=20
2.34.1
