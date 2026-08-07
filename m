Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A2641A785
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101413; cv=fail; b=sBrihikL7FAHdo8Codewjb5VEI4GuEsklPzw82hAYFsustiLmUGGJu2a62tOkSNn0xtq1fV6r4Iv0rOmQDgZFCgiEs9ujubuInZ7VS2O01vzu60P815gAHkkKC1+2TwJVYUjWzJYCER6SSlUJxEzCtckwybUwS3ZqnuML7f0yws=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101413; c=relaxed/simple;
	bh=QQ3X9QIUE+8hYlWdERCb89fuzgaxm/XMb2vY1sqmUL4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qOQnu0q3x63maDSoR3WIEArAReSfN72n9vOkzxFPXmjnFn+mGteLqnV4oYW4vpe/dcCUdnjQYCkJUziyYZTJGmVbc5CJbtLeW7UOL/KQjDHraBu3esDvUApxGjKg7BnsjWr8SYVWWqdWgp03qpPlR4ISnBXTAQpuGMKPiSFJIF0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L01tNESp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L01tNESp; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L01tNESp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L01tNESp"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=s1SeQY3E7B08iOhh9RTnnFoXgG2zFckFZO+cLu7f+2C72+JC2Oxq+uk7WBgUW1UoKbkaPH6oMJMbWQt6DdfYq5IThqTG4/8kEURkcauG0rL6mu2CX9IZrQXwJkrJJDeOBBotI9wPURbMovkT8Bmp9n8mVThbB5hWexP5JWyNmopl2x7k40IBGh0uoiqLJmPgy+4FczXtfb+jLecjQ/HsRgOZO0/iSM4uHemKFZXygX0irvwwAm2O+f+Go7W34mDXQjnV4FMwFEP2DEtbYGG3Vi1RJoMlr0HRTgbTiAY/UP/ycEO2Ay5hG4e9Q3szbWnfthOwTzHd6v16wIih+g0s8w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQxAiXHawCH0kWuq8+7AG7WJV6brUj3w72MBKV7Zz0M=;
 b=eUaY27FeatwVnYzqbzD+yHyHHHdFYS4ucVzi3PeBDSXmEUTsGbcK27qPHRT9doEoaJmO5AegbO2UXVyjiNql7gsjA0Uvq4yCEhYD6sdyk1y2rPXQm9iECcqWmXxgFlQGnvOz1ogMgUToCL+7CN23D6r/TCWgreqiMArekRIA6IYW+GSiBHUQMYNVXdCXaj/0RCevjtP/S3xG01zNIdHozenSFNvlzZhlus4zyYtHr/dzV2dNPpuyLvMeY6FWjrwVb3IEjzbY6Cq9h7OIaEzgxKAC6Oz94gvHryBnpbojfM/yzBj+co1RI4dPrePdnhOp3nva1gwvbgoLq0Fcy/S6EA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQxAiXHawCH0kWuq8+7AG7WJV6brUj3w72MBKV7Zz0M=;
 b=L01tNESp0eCz5c+h990p2dlhzJ03Dyi53dJEZ/DF/b23up3SQyBpE2SGpUH3/B+Z1Sqg82PVc9byKfZyglPQkahD8gYBxU4mm9Wak5VMS3clvPDba3YvGw52M4pkkTzG2pJN3fEPrtAmH99V/Qnt5tYBpuNa8fIZToGthkjlXi8=
Received: from AM8P191CA0018.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::23)
 by DU0PR08MB8709.eurprd08.prod.outlook.com (2603:10a6:10:403::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:16:42 +0000
Received: from AMS1EPF00000040.eurprd04.prod.outlook.com
 (2603:10a6:20b:21a:cafe::92) by AM8P191CA0018.outlook.office365.com
 (2603:10a6:20b:21a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:16:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000040.mail.protection.outlook.com (10.167.16.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:16:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZCY+qv8MZEtXnFU+xD374zo+53BTXEtX5BQx4mvxS/KOTko/cRTgyPt+QZqtS6NFI0MO51xVaFQbXn5zm9gidC8j90wwnbaZVFMR7qAWuOSDQLIsryqbQnV5hn/PhWKYUDEjotxx/IgRxDpleK1DnHG7TTM2DnzSJuAZqb7OqwlQq1n2UE9SbkbJZzYRCkg5NN4fMquG7pDeh83xMMlfjxakhL/ypgXUsYjq9gyZcXurwIbpFoOt5H0OyYo7xcpqc9/6FLRd1hGBXbeXdm/sr4N7eEyu3aFXSgyxPgwep7RaXsaahfETNfFDxgNcvf22/CUwZK/BWxgYdRAYjo9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQxAiXHawCH0kWuq8+7AG7WJV6brUj3w72MBKV7Zz0M=;
 b=sQRwvFePQzgS5lcpkcSOM3PMhQgS5fEwwAevmZq5x4RR0rjnCsUrx4pzB+oT0DR9kryV4DolXepMe85TK/37KtY19asiea+oX+jw2xj9gRytY204r8Tncmfz2sRa2HePDS6rfgxUX7ZJVjQ+ibKYWGX4Q5sTdxu4/99GPVLGPf4hyFlbZAhyp4gJI7FEY3RyEiFgd1F05KSs/5reZnM/x9ED+ByFY6mHyLsNpLrSDn8VPkvyGQbgskzsFSjc+uKT1YqCO55F/Qw8tkvFmexdExlJEZIC52aEXM67IMGuVRAUIgdVXo0/pBaiXfUjFRLFiPm11SuK6kjR4E5kLKwrww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQxAiXHawCH0kWuq8+7AG7WJV6brUj3w72MBKV7Zz0M=;
 b=L01tNESp0eCz5c+h990p2dlhzJ03Dyi53dJEZ/DF/b23up3SQyBpE2SGpUH3/B+Z1Sqg82PVc9byKfZyglPQkahD8gYBxU4mm9Wak5VMS3clvPDba3YvGw52M4pkkTzG2pJN3fEPrtAmH99V/Qnt5tYBpuNa8fIZToGthkjlXi8=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB8PR08MB5356.eurprd08.prod.outlook.com (2603:10a6:10:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:16:10 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:16:10 +0000
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
Subject: [PATCH v5 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Topic: [PATCH v5 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Index: AQHdJl4mE3ixBMiMxk6G5aqxys8umg==
Date: Fri, 7 Aug 2026 11:16:09 +0000
Message-ID: <20260807111159.429128-8-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DB8PR08MB5356:EE_|AMS1EPF00000040:EE_|DU0PR08MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d1c890-ef07-4990-65c0-08def4755c10
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|11063799006|10067099003|6133799003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 BzOzuEM7UkUNajWn+hG5uWa2ZfcRvHiDr/sagtQuIgbDwxgR6BkiEoPYnbwqPyMPsP7TDVi7boZ0qbRpZEpTTZ1ZM4nDmOEQSzkPPkxM3/63EXOTgAvyzECoQ0QSUu9ZepehvWc9fde11AuDsIljDsNq649cDK9EsmMR+qpPVODwfdl0R4eSZGL/b0HzgtTPKpw2Ue941TVm035IncjZC55J6O0Z75tVbhaL923l7A+Y3AC49LUdr5RevfTDFMVQe0AnWUaA8Jsc/KYinKW+u516rIYxKHW42C859SresAuBjDZA3DUjgVWWazd3noPodFnQ7voNHvQUPKg0wgpL7hoZREPj62eBUXmG+jxCp+++34/Gt2fN1TcYbXRHqaELuI6qPcd7bjMFkhEUSRpsfhA4Bk7nqutyVOLduypA5p1NKA48S+kBkIT7fTJ6sozaYYmExvN6Q7K0f46Xkl05BxEe7/RjJ739ESY6U26Jzjf+gZNTTFyWIj1il8Or+DSVMWZN8hF0tipFRdzJkXpq2Q4i7duY2hFsZoO7PVGkwPODy4olHTI33ZTpUnAxrf/byY36WPSsCpLOKepyHgiu5t9AfqhbQJZIeeDqt1H/nzbycLN99dnzUAY+noYCgDLuEGfspddS2u54vkxtNMQehejOvqlkrSApvbcB5zqLR+CUN7buwn7LBKphQSxoJvgl5IylVyiXnWYzy+TkPi/eH3Gv68ezj4bsCJvzqgwsOg0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YrUfQ6xO6km/MwrN3+at+XRH8zb76KEMdv0A8+h5efIUJh/dYY0o5KsAkj5QqaRKPZjTqoFTIx6knphftB+al77BD+hPsEitQ6Mh0zVVXJpQujAOlFqTS46iuYHyrc6yMmJV/KK0GswiD6PoiCP9d5pV6nDhQaJ5Yurdx6o6RTk5FwzlbF2iZONavuUoCOBHugrJKK7a4GbrE4USdAr3EQmtaywqyD/DNdZBGzuLpnWJOpnclKtTaxgwjU4MDqDPABfPjWaqEgsgTMKty2Kv+ZCtP7JdE3/TQvLhQtq1GqVNsTMX12jqdpypgPswus+uxHuy4TLq6gWFgvL2SuMq/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5356
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000040.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	40c19e5f-2c41-4226-183b-08def4754898
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|23010399003|36860700016|1800799024|82310400026|376014|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ht4NMKttQpyLXHd5EDsj9uAKRh6Bsk8drER3S60zCv8DMbstx4ERAxe818dm68pvru9ZR+bSygCVDuGrqH3Qx6IwwEW4YoyuJVjNykiCyLSuCAFGWxcqxud7yxVlT2YAsyj8/UJnrrdabHs5A2FqXVcu+Ox3nahlcCD89ot/g2z35kewcYvy9+Gt1VYFb/zt8eY/0w9p7OwE+2+izJ9eQqbJSCg9/1tnwqIwMDYSGvlwNLygd/+Vum3cgvwSm9wba2eC7SfvfDvFQft4T/fBoLfWsNWCkF2oBVDvE/Mdi9BzADbNz4gzqutX3tJlS7yiaRSp/hwfvUR2tw2LQSwoMUmgRl0qaR5q64FEkawtLVjbiLcJxw6HuSh/0pAJaTEBbq22WDp6WczzYjhcmuwvb9/492kov6k95FBhTocyN0MPjY/vVMTBPEjgMA1mpYYZyIE6G1t1yh090UrvixLHtmZ7A6107wBGiEx9HC7e5n8b3cGEAYc+45zADKFEWX4fNiEqbhNtR5P16dNv9gYgfi9JYCoj4q6dl41ZJdAbDp+xjA8tMBIvau9qsLd+3mjiq2h9OIebsFO+kmHvWqHVGS6oEz/Jay2kMrKyqYsJw/TLLrvRPMqx0C8ROnzY+EANY+NTwEBYWR87vbZpK7Ha3Yz8XB/Vw9pvXMOqeT7tzhTalOn+f7Fyb27cv6jugHlKGsYOEN+HET70Mpfhxf6dlQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zdOLa6zYKQ2kjnN/1+Gma17J4jDVWAxulmX1lQp6pLE+YBK7apwfoq/ePRqYVdquUeqGfCjIYXjoXKtULDXaygT1Dgn24BVjpEsYVjCmpzivSMM5mzcZgntO7Mi5ygEms8mpJrhuvc3B0goxyUtg+yEvM5PSmzcl+XtymmqeVm874H+auFP4rLLNkY6sabrNxAqtuhbINOV+WWNNxMqCkH7SpJH5YtdCYpa+KxAFTdzPC17vZhTFULTKwHoDHloptHcwCU8q9G44x6oQBDlTvIBEQuGRJaNHYsV9xQysiNfiBXZvDD/RRK5LlLPleyVyZ9ZKtiHsjFEJr2BCbl9j9mqQ9ZzzjQd8jHZfJhghaFviJzmK6nGii0jQNAJpmR17IqiXItBpZBuEl1L4XWg++3rMWj8OkcTT/k2/Oj6siF8G/0ggceVGyTOS55BQhRo9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:16:42.5017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d1c890-ef07-4990-65c0-08def4755c10
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8709

KVM needs access to the host IRS configuration frame to configure
virtual-machine resources. The frame ID registers describe the
capabilities available to KVM.

Cache IRS_IDR2, IRS_IDR3, and IRS_IDR4 rather than extracting their
individual fields into kvm_vgic_global_state. Accessor helpers derive
the required capabilities from the cached registers.

Use the cached IRS_IDR4 VPE capacity to limit the maximum number of
vCPUs, while retaining VGIC_V5_MAX_CPUS as KVM's own upper bound.

Keeping the raw register values lets KVM adjust the exposed
capabilities when needed, as is done for ICH_VTR_EL2, and avoids tying
future EL2 code to the layout of kvm_vgic_global_state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 22 +++++++++-
 include/kvm/arm_vgic.h        | 75 +++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d4789ff3e7402..41ca2098ecb73 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -11,6 +11,7 @@
 #include "vgic.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
=20
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
@@ -34,6 +35,21 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+static u32 irs_readl_relaxed(const u32 reg_offset)
+{
+	return readl_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void vgic_v5_irs_cache_id_regs(const struct gic_kvm_info *info)
+{
+	irs_caps.irs_base =3D info->gicv5_irs.base;
+	irs_caps.non_coherent =3D info->gicv5_irs.non_coherent;
+
+	irs_caps.idr2 =3D irs_readl_relaxed(GICV5_IRS_IDR2);
+	irs_caps.idr3 =3D irs_readl_relaxed(GICV5_IRS_IDR3);
+	irs_caps.idr4 =3D irs_readl_relaxed(GICV5_IRS_IDR4);
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  */
@@ -61,10 +77,12 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
-
+	vgic_v5_irs_cache_id_regs(info);
 	vgic_v5_get_implemented_ppis();
=20
+	kvm_vgic_global_state.max_gic_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_cap=
s),
+						  VGIC_V5_MAX_CPUS);
+
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index cefddc9c621de..62ecb525557b6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -130,6 +130,19 @@ enum vgic_type {
 	VGIC_V5,		/* Newer, fancier GICv5 */
 };
=20
+struct vgic_v5_irs_caps {
+	/* Base address of the host IRS's CONFIG_FRAME */
+	void __iomem	*irs_base;
+
+	/* Raw host IRS ID registers */
+	u32		idr2;
+	u32		idr3;
+	u32		idr4;
+
+	/* Is the IRS coherent with us, or not? */
+	bool		non_coherent;
+};
+
 /* same for all guests, as depending only on the _host's_ GIC model */
 struct vgic_global {
 	/* type of the host GIC */
@@ -182,6 +195,9 @@ struct vgic_global {
 	struct {
 		DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
 	} vgic_v5_ppi_caps;
+
+	/* GICv5 IRS capabilities */
+	struct vgic_v5_irs_caps vgic_v5_irs_caps;
 };
=20
 extern struct vgic_global kvm_vgic_global_state;
@@ -627,6 +643,65 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+static inline u8 vgic_v5_irs_ist_id_bits(const struct vgic_v5_irs_caps *ca=
ps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_ID_BITS, caps->idr2);
+}
+
+static inline u8 vgic_v5_irs_min_lpi_id_bits(const struct vgic_v5_irs_caps=
 *caps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, caps->idr2);
+}
+
+static inline bool vgic_v5_irs_ist_levels(const struct vgic_v5_irs_caps *c=
aps)
+{
+	return !!(caps->idr2 & GICV5_IRS_IDR2_IST_LEVELS);
+}
+
+static inline u8 vgic_v5_irs_ist_l2sz(const struct vgic_v5_irs_caps *caps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, caps->idr2);
+}
+
+static inline bool vgic_v5_irs_istmd(const struct vgic_v5_irs_caps *caps)
+{
+	return !!(caps->idr2 & GICV5_IRS_IDR2_ISTMD);
+}
+
+static inline u8 vgic_v5_irs_istmd_sz(const struct vgic_v5_irs_caps *caps)
+{
+	return FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, caps->idr2);
+}
+
+static inline u32 vgic_v5_irs_max_vms(const struct vgic_v5_irs_caps *caps)
+{
+	return BIT(FIELD_GET(GICV5_IRS_IDR3_VM_ID_BITS, caps->idr3));
+}
+
+static inline bool vgic_v5_irs_two_level_vmt_support(const struct vgic_v5_=
irs_caps *caps)
+{
+	return !!(caps->idr3 & GICV5_IRS_IDR3_VMT_LEVELS);
+}
+
+static inline u16 vgic_v5_irs_vmd_size(const struct vgic_v5_irs_caps *caps=
)
+{
+	if (!(caps->idr3 & GICV5_IRS_IDR3_VMD))
+		return 0;
+
+	return BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, caps->idr3));
+}
+
+static inline u16 vgic_v5_irs_vped_size(const struct vgic_v5_irs_caps *cap=
s)
+{
+	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, caps->idr4));
+}
+
+static inline u32 vgic_v5_irs_max_vpes(const struct vgic_v5_irs_caps *caps=
)
+{
+	/* Field stores VPE_ID_BITS - 1 */
+	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, caps->idr4) + 1);
+}
+
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
--=20
2.34.1
