Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012024.outbound.protection.outlook.com [52.101.66.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306C431A56
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101510; cv=fail; b=I3g7sGG7i8jyZgoD5OG+sDdNJtJTyQMNshQCMBedUtGOAd6ygeoHWe947ziNSwn957vXgeBJdyt/i6PkO05R7Q36UAEy6fydtATLZgnFCXPAMgkmwmb3lrbn5CdO3RkNv2rENsgzRcncKSz5es7jv20JTSFdyPLD0VI2lYkYYs4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101510; c=relaxed/simple;
	bh=OPr+nW7WfUP2AtfuWSV7URs5GLppsiHa14uuptUqi30=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zr3rkm+zR0oPg6pX7IxctNZKgVjnZ2Nd4S26ZMOo8JG/bPvNRzc0p5khak3StscHzIqwB9a1QNBxlBRLZL8kPeAMwwo+E89yQAf1JRc+58D4OpbzIFYxA+7P4pUwmt/klE5TlW61jy67hXNgzQNAPb2PBkNpriFqj3NNtHST+OQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ppk/ZFup; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ppk/ZFup; arc=fail smtp.client-ip=52.101.66.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ppk/ZFup";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ppk/ZFup"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TviBDgzFTffF1kd3gqKWDoWOP4kD1kI0Pq5cM0zK4vr6nlXbSgvtIAHYCZyiDRfQP+5QAr9CBIVYDZ3rv5yxdEc+/8ZQlLRF++r+RRLqESd86mK+CATmD1nUfVoqX7qduU6ztLdQVDXUvDeIRsIkrbUXdFI0Hpimp9GE44nuGTT2Jz1DGqmKnSWL18uuSpY9028/QZzC9RIJYXQ6gnN3PQsBdHGVG2xqPkukNI32CH3HIwwy0ahwubPXHwc8GsjcWsj4kCmpDIOmPMt9Ik6tM3ogrhVG8v0F037evMdwk57wuqD4BJnL8T6qEIWpVAbem0qYyFMxvH1mXqvDnxcaHw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFkl3CxAIrxlODNbv4/Y3WnM79ZXnAi09ggoSPumblM=;
 b=Bgi4NCvAWxvdifDEHbmOgXzZPXjWcMZ6Y4jQ08U4PCyNcclhsDIi7VD458K8Svev/59VF69SNZ80WksdX91R24f3B/rZEHXx/IP+9FyOWnzza87iGVYq4eRby9r4VAI8aWBwsx71aLnPUtpNP7h9FOR2gvug8+GI2lpSGu2eJdisfFiPJcP2KxU2mdn2loNnMNQgdOrMwc2BQ00aXaupisbvHezmMJooe7EUVyapa27JHC54vEC+UtLnc3/RizNwANMU66Ppsm9qVBx0zlwDDocs4yyeJwME48+SN4wMxBZ1J5jxae12K/8cFQbJBCyNk3BChMBxKgDBTRnC6tVZOw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFkl3CxAIrxlODNbv4/Y3WnM79ZXnAi09ggoSPumblM=;
 b=ppk/ZFupbJghNGrot7+kyHFoPQI4T9wMDqzm0PFP02t5+LrGh5V5puVrX/i2W63BEasuBuYYX/csOgxq3hQirgmKPL5W6B3mh140u+LWgbvVEerEvXlWZ+CGaCMN3q6C4ZrdJXJkODZUMnoS40kTRT9vMi46hx+e75I/lNm4Ldg=
Received: from DB9PR01CA0028.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::33) by PAVPR08MB9697.eurprd08.prod.outlook.com
 (2603:10a6:102:31c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:18:17 +0000
Received: from DB1PEPF000509E2.eurprd03.prod.outlook.com
 (2603:10a6:10:1d8:cafe::a0) by DB9PR01CA0028.outlook.office365.com
 (2603:10a6:10:1d8::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:18:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E2.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:18:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nuvIS1HixoNRR5SJ/RgjNqYkRw+hJ0ibUPNGMXS+8tPpWMifnWSbV92tEFvQDjc5OcitG4Qaa9uzVMlr+LMvYaTjQ6x94xkkdoEg9RWgv7pBMbcJ0GleKGCbnAnoT58CSd1bYD7JirldVJGGkjp/XR+7RRpHyt8lKct9hwmlEGseDROekYR31l6IjV+mdcsrqTheluB8mDi3+c6xUlpnG2Q00gs63BCbycjSen14/MxQ2tQm2Kw+b3drEJSMWe2Pbl24q+TwhqLPd0uc3cc79cQxRr7BvFjWT82iDl/To7z1zkssLkkEpe7lPvoeHwP7JVBUaHnCB2HWOlFfxA6WQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFkl3CxAIrxlODNbv4/Y3WnM79ZXnAi09ggoSPumblM=;
 b=O0WNyfV6oK3KHJ79pbfdGBKwGYdoYEe2Bp1NmgROTayqXuaYeBpSVfma9Jm0x4a/PH1IsWI2l8iGOyUKxhPFeNj0Thz4g+Ps4HMcP1nunav0VGddFihKZb4k8lVl+XvlLLfWHq0hl8fn7nwGAYNzpaCzwZW3ZGjzcNxn9YZ4RptWN9MVKABpKWHWuukweN2WzFglKU161pNYAPm4eE4323xTS/EA74xlhjsTRrVhSEHdaQL3sGBbf0mgG1huWr1tZ8BE4BsamZQ9Ghkk/Mvm1Fb4zCydl1RvNDqkH8DTmjJ2IBfJZSk+TO56bN59xrzTuFXk8lCq2sq9TA4ZhkUVVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFkl3CxAIrxlODNbv4/Y3WnM79ZXnAi09ggoSPumblM=;
 b=ppk/ZFupbJghNGrot7+kyHFoPQI4T9wMDqzm0PFP02t5+LrGh5V5puVrX/i2W63BEasuBuYYX/csOgxq3hQirgmKPL5W6B3mh140u+LWgbvVEerEvXlWZ+CGaCMN3q6C4ZrdJXJkODZUMnoS40kTRT9vMi46hx+e75I/lNm4Ldg=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:17:41 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:17:41 +0000
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
Subject: [PATCH v5 10/49] KVM: arm64: gic-v5: Introduce guest IST alloc and
 management
Thread-Topic: [PATCH v5 10/49] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Index: AQHdJl5c2Ug0FKBexUSVUO5o+PxFhw==
Date: Fri, 7 Aug 2026 11:17:41 +0000
Message-ID: <20260807111159.429128-11-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|DB1PEPF000509E2:EE_|PAVPR08MB9697:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b8108a0-da5a-45cf-ec79-08def4759404
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 h0lYnafaHbVucKF9GC49Xnr7ikIzwEUHWmbEG+jkBelPrjLoncAbZWSndXCzx70tm0Ft/3dB9iJFp0fv51uaNUKyBawYjq976/JHI/tu9axW8ByLkbH+++uu4+CPjpVNVsLG9yk9+7AGDCgPvq46Z7+l3XouWB8jPrhFK5vvfodC0ySWtrX6TxU5lmLOxFcKcaMJOaG9E8/x3mkGJtVNch1XuVWoGMAENnt54vgQOOTiUWa05os3dGzQV3h4BtuEl/JiwUQyN0NSWzswssVRo5pwWD+w2Yruc5ld8FslkjgyQZvYQzjhQ29AjthXwe/RoYGgr4V9Mv70iKrWgHLn9Dj4Lrj6DlcSxLn3UIloKCgCw8+YG2hG6tpucP41iN3/xUnKX7SCciyazdPu/Uikiqno583AjLfSBycU4OmBPF3gMGAnGG8g3H3d1EoaaH6V2AmufV5lI6xWTanGNz/3dgGtwRIkDmZKcF/bPzCzn8Z6wpytN5Zt+9V+ahIKdB0MZ6air2KLbxKk9Ysw/uS9ukFe3pm4AvtHsazr8/ZwPs/jGbk26fW7nCBcgHJItS4zpWbsknAVAAMRJ5tyKbzOZDPS9D9sCpWqfpRu3YSj8LLGVv0qociHncFqqxMcpsdt3aF+we08/V94OM2D6Ia2hk9iMOf8HSeWS0bKA9kMvbiCMUznUWgt6HwiVUTvIpvmfrkWJlXSEI7CxLbCqelZRlIgiOA5uMCm49AhZpmTPiE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 FFEPRwXlFs1MldhoTAyXyXyBSQ/InUJFp4FMlw7XOIUltWRk0Fn1IHJPyAAb7QVZgiIT3dzHdEx9nvNZombO5Y3xWniIZdoBOOMFWUL8iwDbsUjaOzvPik9Nhjg3x9awmbWRrPiuMH3VjP/JJ1YuidAMW2bKxya4yC1wlorFyGlI1jFlGIOn3cYTY+1ORdMc3Li6lQK+oD+fqR60UCR3pryiu3nOZS0kq5Jr/wCQnuBffKKZWOTEbcP9FpBrD18wMwPF6t4ip8VPP8k8TmRGpSaQtxRnMDEJoZNC899cBvV7VeEIrZOIWo8IRR012HeIVJdp5kMSBcg1tbdtoGUSkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2faf0d4b-3ae7-4843-5deb-08def4757f59
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|35042699022|36860700016|14060799003|1800799024|82310400026|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	uMCLRaGnyBvhHB10S6rpaSo6rYjnoH3ra8FsEULmmw3ApfozIXDB7o02MjL7jBiNdQqK9EB9QU3Gr+Yr9kWt274MjFx2D9B869RQayVx8K9J4W/Xj/5Yni/bW8Atl1m/Vl4UJLBNTeWmbHEEWABXpEBVffDQkJeC9+5dUd7wkgl4j+F/T376ITtc4UPYz8pjZyr6AGfB56F2FjyXDA3SHBJq8TQzTN42s+BfLqwuCbWo/xuMK6R16QZi0w0Zp2VwMALuVWFR9/Jr0n5Zp3YytLXvveJNoySaiiSItbTrhGFq1KLGF4uB0cqL5GOOv3fpkBj5Cmdz2J3U1wSJhU5zeGFvky1oo3OhxEmUYIkhCEFzHmks7PgLeQOos3gVYvvOHh4+A7SJPBODYSA2mMgMXm+FDzvWydNaTmnfOmiks5/OwtsYsFOJ9WTAo+UP2toOE3Pci5V40CMrwcLPL6Wc/P3JLXFgJu7mG8kKK5q4888oQgqFHTQPt2lsjWMwTqpEm1mar2AVlU+/vzyzGOuK+xm86aTohME2mwxIRahn6STrpYVQRmA/a0bI9VfQKf2rR4oT26sOm+wN/yc/tfR07KVL5dVqdXjkAKhbj4FTjPCsVFmU6sJ4F644K7E1BRgX0Wr0x5927s+XH6ijk0dnaVaBVFfFbf7RscoLEZwXyUvm7I9CZctua6Zwbd2wHlRwDMMHbH4rzkpkCJ5PeAWQiQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(35042699022)(36860700016)(14060799003)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pfNqdUBVkxYWPAu7tb8TeJHnOaL5BO7Nso7luJnly20S2DCSXdnxu/hyaZebOecu+o4scp9v7+wP1VPs0TBB7T/l7NcyYo0N6szBDHhfGd87fF4z23uvuc1SVquQPLCOGfhGbEKqesAHQeccfzGvce7JJeXtiLGlvUtQSB4cLbc25ZpD98SrA15K2Ab8jPUYxjx+0QJgk9buVjv0+vsxfRiCdPbwhZwRf5B3ZeExQiiAQ0qft9vjj/4nh1DAq9qX6OM7KkpNJr+NNZskgi7/k8LIy2k0HQ1dnpJJHFdIC4OlprG1uwXlmOiXLEQcF6S84RFisNPza9JLsYlhdzmZLqSSrV4l2krrb6jTuxcTvn8neS+29FJx63QWGM4y9YZxsBbDYjbDGbfEZ/mN8Vg4FPLW2bMdE3HFTU9P6v/i2C8WPj8CKi5bR6VZG/OKaD7n
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:18:16.3770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b8108a0-da5a-45cf-ec79-08def4759404
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9697

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. These ISTs are provided to the
host's IRS via the VMTE.

On a host GICv5 system, SPIs do not require any up-front memory
allocation prior to their use, unlike LPIs which require the OS to
allocate an IST. For a GICv5 guest, the same holds from the guest's
point of view: SPIs should require no explicit memory allocation by
the guest. This means that KVM must provision the memory passed to the
IRS for managing a guest's SPI state.

Introduce the machinery needed to allocate a linear SPI IST. A later
commit will allocate it as part of VM creation, before running the
guest for the first time. The host is responsible for freeing this
memory on guest teardown.

For LPIs, the guest provisions memory for its LPI IST. KVM does not
pass that memory directly to the host IRS. Instead, add support for
allocating a shadow LPI IST and passing that to the IRS through the
VMTE. The LPI IST may be allocated as a two-level structure when
supported and required by the configured LPI ID space, as many more
LPIs are expected than SPIs. The host frees this memory on guest
teardown.

Assigning an IST to a VM requires an IRS operation rather than writing
the Valid bit directly in the VMTE. Extend the doorbell command
interface with the operations needed to make SPI and LPI ISTs valid or
invalid. Together with the existing VMT commands, the command set is:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE, and hence VM, valid
        VMTE_MAKE_INVALID - Make a single VMTE, and hence VM, invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

Once implemented, irq_set_vcpu_affinity() will act as an ioctl-like
interface for issuing commands specific to either a VM or the
particular VPE that the doorbell belongs to. None of these commands
are plumbed through to the host IRS at this stage.

There is intentionally no SPI_VIST_MAKE_INVALID command. The SPI IST
will be allocated as part of VM creation and will remain valid for the
lifetime of the VM. It can be freed after the VMTE has been made
invalid during teardown. The LPI IST, on the other hand, is driven by
the guest, which is free to invalidate and free its LPI IST at any
point.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 551 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  22 ++
 arch/arm64/kvm/vgic/vgic-v5.c        |   3 +
 include/linux/irqchip/arm-gic-v5.h   |   3 +
 4 files changed, 579 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 7252d48431a5a..f088006f39674 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -65,6 +65,14 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+/*
+ * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
+ * the VMTE (0-based). We call this a section here in an attempt to simpli=
fy the
+ * code.
+ */
+#define GICV5_VMTEL2_LPI_SECTION	2
+#define GICV5_VMTEL2_SPI_SECTION	3
+
 /*
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -553,6 +561,25 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
+/*
+ * The following set of forward declarations makes the code layout a *litt=
le*
+ * clearer as it lets us keep the IST-related code together.
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -581,6 +608,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	if (!vmi)
 		goto no_vmi;
=20
+	/* If we have an LPI IST, free it */
+	if (vmi->h_lpi_ist) {
+		ret =3D vgic_v5_lpi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+	vmi->h_lpi_ist =3D NULL;
+
+	/* If we have an SPI IST, free it */
+	if (vmi->h_spi_ist) {
+		ret =3D vgic_v5_spi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+	vmi->h_spi_ist =3D NULL;
+
 	kfree(vmi->vped_base);
 	kfree(vmi->vpet_base);
 	kfree(vmi->vmd_base);
@@ -679,3 +722,511 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
=20
 	return 0;
 }
+
+/*
+ * Assign an already allocated IST to the VM by populating the fields in t=
he
+ * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
+ * if the paths to reach it might be vastly different.
+ */
+static int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
+				   bool two_level, unsigned int id_bits,
+				   unsigned int l2sz, unsigned int istsz,
+				   bool spi_ist)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd;
+	struct vmtl2_entry *vmte;
+	unsigned int section;
+	u64 tmp;
+	int ret;
+
+	/*
+	 * The L2 VMTE comprises four 64-bit "sections", where sections 2 & 3
+	 * describe the LPI and SPI ISTs, respectively. Both the LPI and SPI
+	 * sections have the same layout, and as we are either operating on SPIs
+	 * or LPIs we pick a section of the VMTE to modify up-front.
+	 *
+	 * See the GICv5 EAC0 Specification 11.2.2 for more details about the
+	 * VMTE layout.
+	 */
+	section =3D spi_ist ? GICV5_VMTEL2_SPI_SECTION : GICV5_VMTEL2_LPI_SECTION=
;
+
+	if (ist_base & ~GICV5_VMTEL2E_IST_ADDR) {
+		pr_err_ratelimited("kvm [%i]: IST misaligned: address 0x%llx, mask 0x%ll=
x\n",
+				   task_pid_nr(current), ist_base,
+				   GICV5_VMTEL2E_IST_ADDR);
+		return -EINVAL;
+	}
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_IST_L2SZ, l2sz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ADDR,
+			ist_base >> GICV5_VMTEL2E_IST_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ISTSZ, istsz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ID_BITS, id_bits);
+	if (two_level)
+		tmp |=3D GICV5_VMTEL2E_IST_STRUCTURE;
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		/* Bail if already allocated */
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		if (le64_to_cpu(READ_ONCE(vmte->val[section])) &
+		    GICV5_VMTEL2E_IST_VALID)
+			return -EINVAL;
+
+		WRITE_ONCE(vmte->val[section], cpu_to_le64(tmp));
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	}
+
+	/* Finally, mark the entry as valid */
+	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	return ret;
+}
+
+/*
+ * Allocate a Linear IST - always used for SPIs and potentially LPIs.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz is the FIELD used by GICv5, not the actual size (or log2() =
of the
+ * size).
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits, unsigned int istsz)
+{
+	const size_t n =3D max(5, id_bits + 1 + istsz);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+	u32 l1sz;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	/*
+	 * Allocate the IST. We only have one level, so we just use the L2 ISTE.
+	 */
+	l1sz =3D BIT(n + 1);
+	ist =3D kzalloc(l1sz, GFP_KERNEL_ACCOUNT);
+	if (!ist)
+		return -ENOMEM;
+
+	if (spi_ist) {
+		vmi->h_spi_ist =3D ist;
+	} else {
+		vmi->h_lpi_ist_structure =3D false;
+		vmi->h_lpi_ist =3D ist;
+	}
+
+	vgic_v5_clean_inval(ist, l1sz);
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	const u32 l1_size =3D BIT(n + 1);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	ist =3D kzalloc(l1_size, GFP_KERNEL_ACCOUNT);
+	if (!ist)
+		return -ENOMEM;
+
+	vmi->h_lpi_ist_structure =3D true;
+	vmi->h_lpi_ist =3D ist;
+
+	vgic_v5_clean_inval(ist, l1_size);
+
+	return 0;
+}
+
+/*
+ * Allocate ALL of the second level ISTs for a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec. The l2_size calculation is from section 11.2.3 of the same docume=
nt.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	const size_t l2_size =3D BIT(11 + (2 * l2sz) + 1);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *l2ist;
+	__le64 *l1ist;
+	int index;
+	u64 val;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	l1ist =3D vmi->h_lpi_ist;
+
+	/*
+	 * Allocate the storage for the pointers to the L2 ISTs (used when
+	 * freeing later).
+	 */
+	vmi->h_lpi_l2_ists =3D kzalloc_objs(*vmi->h_lpi_l2_ists, l1_entries,
+					  GFP_KERNEL_ACCOUNT);
+	if (!vmi->h_lpi_l2_ists)
+		return -ENOMEM;
+
+	/* Allocate the L2 IST for each L1 IST entry */
+	for (index =3D 0; index < l1_entries; ++index) {
+		l2ist =3D kzalloc(l2_size, GFP_KERNEL_ACCOUNT);
+		if (!l2ist) {
+			while (--index >=3D 0)
+				kfree(vmi->h_lpi_l2_ists[index]);
+
+			kfree(vmi->h_lpi_l2_ists);
+			vmi->h_lpi_l2_ists =3D NULL;
+
+			return -ENOMEM;
+		}
+
+		/*
+		 * We are not doing on-demand allocation of the L2 ISTs, and are
+		 * instead provisioning the whole IST up front. This means that
+		 * we are able to mark the L2 ISTs as valid in the L1 ISTEs as
+		 * the overall IST is not yet valid.
+		 */
+		val =3D (virt_to_phys(l2ist) & GICV5_ISTL1E_L2_ADDR_MASK) |
+		      GICV5_ISTL1E_VALID;
+		l1ist[index] =3D cpu_to_le64(val);
+
+		vmi->h_lpi_l2_ists[index] =3D l2ist;
+
+		vgic_v5_clean_inval(l2ist, l2_size);
+	}
+
+	/* Handle CMOs for the whole L1 IST in one go */
+	vgic_v5_clean_inval(l1ist, l1_entries * sizeof(*l1ist));
+
+	return 0;
+}
+
+/* Allocate a two-level IST - LPIs, only */
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm, unsigned int i=
d_bits,
+					   unsigned int istsz, unsigned int l2sz)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	int ret;
+
+	/*
+	 * Allocate the L1 IST first, then all of the L2s. Everything
+	 * is preallocated and we do no on-demand IST allocation. This
+	 * is to avoid needing to track if and when the guest is doing
+	 * on-demand IST allocation.
+	 */
+	ret =3D vgic_v5_alloc_l1_ist(kvm, id_bits, istsz, l2sz);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_alloc_l2_ists(kvm, id_bits, istsz, l2sz);
+	if (ret) {
+		/* Free the L1 IST again */
+		vmi =3D xa_load(&vm_info, vm_id);
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D 0;
+
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vgic_v5_free_allocated_lpi_ist(struct vgic_v5_vm_info *vmi,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2sz)
+{
+	if (!vmi->h_lpi_ist_structure) {
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D NULL;
+		return;
+	}
+
+	if (vmi->h_lpi_l2_ists) {
+		const size_t n =3D max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+		const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+		int index;
+
+		for (index =3D 0; index < l1_entries; ++index)
+			kfree(vmi->h_lpi_l2_ists[index]);
+
+		kfree(vmi->h_lpi_l2_ists);
+		vmi->h_lpi_l2_ists =3D NULL;
+	}
+
+	kfree(vmi->h_lpi_ist);
+	vmi->h_lpi_ist =3D NULL;
+}
+
+static void vgic_v5_free_allocated_spi_ist(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return;
+
+	kfree(vmi->h_spi_ist);
+	vmi->h_spi_ist =3D NULL;
+}
+
+/*
+ * Free a Linear IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	struct vgic_v5_vm_info *vmi;
+	int section;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	if (spi) {
+		section =3D GICV5_VMTEL2_SPI_SECTION;
+		vgic_v5_free_allocated_spi_ist(kvm);
+	} else {
+		section =3D GICV5_VMTEL2_LPI_SECTION;
+		vgic_v5_free_allocated_lpi_ist(vmi, 0, 0, 0);
+	}
+
+	/* The VM should be dead here, so we can just zero the VMT section */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vmte->val[section], cpu_to_le64(0));
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	}
+
+	return 0;
+}
+
+/*
+ * Free a Two-Level IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi)
+{
+	unsigned int id_bits, istsz, l2sz;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	u64 tmp;
+	int section;
+
+	/* We don't create two-level SPI ISTs, so freeing is a bad idea! */
+	if (spi)
+		return -EINVAL;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	section =3D GICV5_VMTEL2_LPI_SECTION;
+
+	if (!vmi->h_lpi_ist_structure)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		tmp =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+	}
+
+	id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	/* The VM must be dead, so we can just zero the VMT section */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vmte->val[section], cpu_to_le64(0));
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	}
+
+	return 0;
+}
+
+/* Helper to determine ISTE size based on metadata requirements */
+static unsigned int vgic_v5_ist_istsz(unsigned int id_bits)
+{
+	if (!vgic_v5_irs_istmd(&irs_caps))
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (id_bits >=3D vgic_v5_irs_istmd_sz(&irs_caps))
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+/*
+ * Allocate an IST for SPIs.
+ *
+ * We don't anticipate a large number of SPIs being allocated. Therefore, =
we
+ * always allocate a Linear IST for SPIs. This will need to be revisited s=
hould
+ * that assumption no longer hold.
+ */
+int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	phys_addr_t base_addr;
+	unsigned int istsz;
+	int ret;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vmi->h_spi_ist)
+		return -EBUSY;
+
+	ret =3D vgic_v5_alloc_linear_ist(kvm, true, id_bits, istsz);
+	if (ret)
+		return ret;
+	base_addr =3D virt_to_phys(vmi->h_spi_ist);
+
+	ret =3D vgic_v5_vmte_assign_ist(kvm, base_addr, false, id_bits, 0, istsz,
+				      true);
+	if (ret) {
+		vgic_v5_free_allocated_spi_ist(kvm);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Free the IST for SPIs. Should only happen once the VM is dead.
+ */
+static int vgic_v5_spi_ist_free(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	return vgic_v5_linear_ist_free(kvm, true);
+}
+
+/*
+ * Allocate an IST for LPIs.
+ *
+ * Unlike with SPIs, we anticipate that the guest will allocate a relative=
ly
+ * large number of LPIs. Therefore, while we support doing a linear LPI IS=
T, it
+ * is expected that LPI ISTs will be two-level.
+ */
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	unsigned int istsz, l2sz;
+	phys_addr_t phys_addr;
+	bool two_level;
+	int ret;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vmi->h_lpi_ist)
+		return -EBUSY;
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+	l2sz =3D gicv5_irs_l2_sz(vgic_v5_irs_ist_l2sz(&irs_caps));
+
+	/*
+	 * Determine if we want to create a Linear or a Two-Level IST.
+	 *
+	 * A two-level IST is only required when a single L2 IST cannot cover
+	 * the requested ID space. This depends on the L2 IST size selected for
+	 * the IRS, not PAGE_SIZE. Using PAGE_SIZE here would switch to
+	 * two-level too early when the selected L2 IST is larger than a page,
+	 * and the allocation sizing arithmetic would underflow.
+	 */
+	two_level =3D vgic_v5_irs_ist_levels(&irs_caps) &&
+		id_bits > ((10 - istsz) + (2 * l2sz));
+
+	if (!two_level)
+		ret =3D vgic_v5_alloc_linear_ist(kvm, false /* LPIs, not SPIs */,
+					       id_bits, istsz);
+	else
+		ret =3D vgic_v5_alloc_two_level_lpi_ist(kvm, id_bits, istsz,
+						      l2sz);
+
+	if (ret)
+		return ret;
+
+	phys_addr =3D virt_to_phys(vmi->h_lpi_ist);
+	ret =3D vgic_v5_vmte_assign_ist(kvm, phys_addr, two_level, id_bits, l2sz,
+				      istsz, false);
+	if (ret)
+		vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	return ret;
+}
+
+/* Free the LPI IST again */
+int vgic_v5_lpi_ist_free(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	if (!vmi->h_lpi_ist_structure)
+		return vgic_v5_linear_ist_free(kvm, false);
+	else
+		return vgic_v5_two_level_ist_free(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 962be0c7cd3f6..a711a247cc6be 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -26,6 +26,24 @@ struct vgic_v5_vm_info {
 	vpe_entry __iomem	*vpet_base;
 	void			*vped_base;
 	u8			vpe_id_bits;
+
+	/*
+	 * Both the LPI and SPI ISTs are allocated by the hypervisor. While it
+	 * would be possible to track and access them by iterating over the ISTs
+	 * themselves, it makes more sense to store pointers to the ISTs.
+	 *
+	 * The LPI IST can either be two-level or linear. Hence, we keep track
+	 * of the structure. If it is two-level, we retain pointers to the L1
+	 * IST and to each L2 IST array. If it is linear, we just store the base
+	 * address of the IST array.
+	 *
+	 * The SPI IST is linear, and therefore we just store the base address
+	 * of the SPI IST array.
+	 */
+	bool			h_lpi_ist_structure;
+	__le64			*h_lpi_ist;
+	__le64			**h_lpi_l2_ists;
+	__le64			*h_spi_ist;
 };
=20
 struct vgic_v5_vmt {
@@ -97,4 +115,8 @@ int vgic_v5_vmte_release(struct kvm *kvm);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_free(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4d1d7701ef71d..34f197830611e 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -141,6 +141,9 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_data=
 *data, void *vcpu_info)
 	case VMT_L2_MAP:
 	case VMTE_MAKE_VALID:
 	case VMTE_MAKE_INVALID:
+	case SPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_INVALID:
 		/* Not yet implemented */
 	default:
 		return -EINVAL;
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 27b13bf2c1e2c..74152d22de070 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -659,6 +659,9 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
+	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
+	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
 };
=20
 #endif
--=20
2.34.1
