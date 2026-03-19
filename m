Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013013.outbound.protection.outlook.com [40.107.162.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63423E8C46
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935457; cv=fail; b=D3reh2JZY+lxZVfCfw4Zqg1a7+s+ye+ukcQZQ9SU9Hzy5ULp43DBn6xdcvBsVthqNaWaWZETQCYBdDt5n2FmgUue3Biw95Uszjep5ztGhgvEqerIba+iAKrwlDn5uEE6B3a/5m333w+yJSrRLzEq/mUOwMC8Qro01+xXmGoTy+k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935457; c=relaxed/simple;
	bh=WIOyblXfzFcatUKY4QqZuYfi57Z1W6r7Ca0GQpAedLw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=svfLLwLtvJh68sXVm0azIJLqtN1Ezgi/AN77Sk4xVbTkLY2h6tqiXiEr6zEDB2IVukN3mEauNc42xn3OmZKVYETze591LBQ3gAKXRGfmvoLhtqVYdDeXfXXouRgKZA8P4IcEXGHXlJnzAs95Jhkn0x7WGSC34co2ukE8C+ehEvk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=USWLpuD6; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=USWLpuD6; arc=fail smtp.client-ip=40.107.162.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="USWLpuD6";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="USWLpuD6"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vROvqp5OFWuXlTJS4gNkuDTEpK6Z3iYc8bIrMaTQWtnFtDUZXaurtAdSpZ2YqPeHw2eQESLluBDyuvROSxM3gbQhB7cTkltdKBXBV8ITCKImcv8gwQqw/fWLaRS16wgSbptfHS+gWY9+M1GZPF1ffzxul4visZdUZzQ4OMG5afidmP6EWP4VsNmgztXFcAvA3Aa/1nJV6mCuzK/+Zs8SYNgQSbCS4uimDDJW5kDeAqndAmXnfjtffwewR1f2MqvYV++CPryUfkPHdho6cNTgwHHi8V+wXmB3Z3Z/dhWfdbIej3UP5z1RZWEJa/DrA7DFxg/B/B/JPKPO7O91VV1/PA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMJISPydXCdxVP07dCnoYM1/L1ShpwN5YrGtkU1sX/4=;
 b=ySeKI5FEC+zCQ5nzkD0lWfY7HvLzQP1EN0DUCP2zWp5po80RhKCEhqiYsK1esdHUdonoTfv7Ne/aa1CSpl9Hzw22DrBxZNA8SCOUthf3y+7hkpZDtOaA2k8R7YKM/kSTbwNGr5O1+jOdveF90eLFxNtp3lki8kVAie9JWA9ySpNRXxN+Wi4xL4LLrjkwCeGUJXKmzeGWjB2odbqWblMTwMqDfGJkvVusuaiJ63fgUbF1VEWdKEiNeXKQBtJScHrsZGYZRP2DqiUYEIPhjr+n4rcgt3X4TPJLDGOrK1XuZy2leVnZcsTj6dAb7UFMeUpgNR1cWTO2ABHvTN03HYRZrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMJISPydXCdxVP07dCnoYM1/L1ShpwN5YrGtkU1sX/4=;
 b=USWLpuD6goAic/KY72pNtuVUWbGuGgN2uRCDnCyZ8Vpn10ZvrvUpCVckGqKkVzzK+3zSrf6n1DLXtUEZOzce2mv9FuUOOnuJJcwL44KG+gRNM+N9jK/1PwwS8hK8O1O5r+He5hlW0VfbUFquNAVYLSvb6H7VPI11UI4GRzEClaI=
Received: from AM0PR02CA0111.eurprd02.prod.outlook.com (2603:10a6:20b:28c::8)
 by AM9PR08MB6036.eurprd08.prod.outlook.com (2603:10a6:20b:2dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:50:48 +0000
Received: from AMS0EPF000001A2.eurprd05.prod.outlook.com
 (2603:10a6:20b:28c:cafe::43) by AM0PR02CA0111.outlook.office365.com
 (2603:10a6:20b:28c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:50:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A2.mail.protection.outlook.com (10.167.16.235) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:50:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deR00kHzs8UmU5X0j9PURge6KCCjpPA7AXoD3DVGNtI2v93Gf/0HrijH1Lb54TgRRTbzwiPd2dWeXM8/+vtpp+3IHWLsjWjkk6GiBp1MkgDT7AA/cWz29XRT6rF3hd2PcBbXk7EiccQ3kQmjxgZnAHWJZXie2/ulTwYH+75ZeM8oaDajLHmY+mQs9sbirJvne9omkS+7gE52fndBWs5Gst6eyMi5afZrftmNCjbxSB50VRYNpgatdWUXVGSyxoUKAlNJB8BzZk3FXYnwIo1iaF0EH7RoaNEmqZ3V6SoEaRGf/0EtzEY1CM+83/oqzrQHN7RxntP8xlMq4Ikv53KbgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMJISPydXCdxVP07dCnoYM1/L1ShpwN5YrGtkU1sX/4=;
 b=R+WUryGZ+ppqjmrfod9YBNfsUy1J5DnOy6I0NBymg7XJOMUc1EQDCKEkvpMEQx8p13vgvQXbfZM+JmzOq3MZrNC4xUxWWEJGbSdasgs3ZDt4r5nrXGe9s+IKGD5Pnbiz34/CGYfFqknlvVWbHAzVY9LBpcDyGRb8K7mrwxF9yIvVBmML+yCbACn6iHQsdl2m/Lm4XayGhit9jSYU//hlMdEO/oXKRSDaoEl3FywlZrGrwLbOeQbIjQUxUSSjd0Knq/hTryy8CMfCG/1bdwNH+5Ux2+wrHb9pf0VG1bFclJJjWyxG2AuWh+c849qSTKQtlOvoa8/ifh0phljfZ+NhTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMJISPydXCdxVP07dCnoYM1/L1ShpwN5YrGtkU1sX/4=;
 b=USWLpuD6goAic/KY72pNtuVUWbGuGgN2uRCDnCyZ8Vpn10ZvrvUpCVckGqKkVzzK+3zSrf6n1DLXtUEZOzce2mv9FuUOOnuJJcwL44KG+gRNM+N9jK/1PwwS8hK8O1O5r+He5hlW0VfbUFquNAVYLSvb6H7VPI11UI4GRzEClaI=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU2PR08MB10185.eurprd08.prod.outlook.com (2603:10a6:10:49e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:49:43 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:49:42 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 00/41] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH v7 00/41] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHct7gAMpPZCq02WEGZlsH9W8mWfQ==
Date: Thu, 19 Mar 2026 15:49:42 +0000
Message-ID: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU2PR08MB10185:EE_|AMS0EPF000001A2:EE_|AM9PR08MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: b035b931-4af9-4fc7-88ef-08de85cf498e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 cU8ew4De82soCKNkmmoV183Bgs2I9BcMPGziDUHHVP1OBcCQ2pUegz4HAXPN/FNp0W2g5DWh+f8mIfXFjijVld7AZysV6z6iqfwIJQN2Zu7EIteRiwS0hmC8JCTFhHM6Hp+At22ZOZOyrzScGVkLr64HtejtRFVMlW9eEN1Q3Y3YKQFBgYPbXVZng5fxHVD1PxWJVjDi45W/QTCVtfpSXTQIZKi0t2FYqSEOpmj545Tuvd6djQw5hW4vpmuOLZWL87eeLic0sI2GoTJxdZvmjdBi7/mR6UtUKjA2jMyLCuL9jXdRfHkxQSaHeWJ3Xhl612OOJtYhsgEJsnH3g7XKiKOchz2suwig1CWRrFNNMBZAH3y5nxn5O6HEVJT65x/Y8Qalndj576ubwViVmI+G6XOs6qkOhj/sNKFhbh89mXnQ3T+C1IWAh9zIqnAjPSc0OqHRlAaPNrng/9wodgxdMtsyH+eKGquZCf8YCGIiTffr5DqxMB4T6oOorMVkqQIxfPBnWWRh482QLOKinPcm+RvefYmJjCzHEt8Kkxa61HqaIeofweUZYgZ/snGwddbJzlVck1fvboxaddhHmHRV3ytTKeGW+BjQ13KTnpne3wBYUXuiFRkIu4jAO9HKuQrZYhiVFuBcwlWzNYWG6yAy4eHhTWJ4D8QL91BVrwj8Tn1Ja76aYYxJ7cfhl2zkowTB/T0YsmSrYbrYSL1l5dTi/8ba1HQ28IP9YoNgeFXaszbYZZmigMs8rkjNbDIaSM9X
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 QxVtgzpY1PzEe4k3PV/f4bEObxcQEPfgDlmrZ2Elh65qnd3HWtS+Y1jtRjVy8tIJThkwuT0zWkyvRUi0QPKzjJg+u19ZpDW+JZdgK6kYA9fbRrsAM8hLn2Sh1AvWxMl5Lz7xMyff0rvW1HLndC/JQtfTSlIhIGT9yLscoAR07zcGNNUBRJHx3izojGIXT6P/vKpKczMzULVaGnyVazYKlHnoD3kOhmu+Fi5e2XrvDpRZt1+mvvmoRWFopCWxytridOXAoHEsUegxu0zG/xfiAy5TLePhuHLiA9aRa6j2uVY+zwK4vwXikWktOgJmcVr4Mh1veXXgM2ijxfI67gxBVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10185
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	36946f5c-03a1-4a10-6866-08de85cf22c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700016|1800799024|376014|14060799003|13003099007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	g003pAmHwM5/mSAPHlY3tUv+82HulxNcYwSuUlCBuxPy1PE1cu5oBptclPzplu2yBtYYSl9U2GyU1J3o1BVI4kkOGhpILP9DS+g9YAifrFzd/+5Eil+EjGrWw1LRxz8Sye6+TVrHpRco7OjZteIROXa19PXTDBqL+2XkcIKFJA2sgR2Rjg/PiuefHfap5rhYKG6aUTg977OOyPHSIri4pHNC9m+nTsXpv3+hfT97e6dcyfOJO7b4PrvdXfroH9HJZm5Epm+jP7AbY7b5mgz42Tl2ddEsLU6ILw7GvlDT8lfMMttElNgrUj8D7a27jXDm2L6+xf2d17isTDuIXKoLSB/p02TkQofJU59XaSwVrUR94vZ2NPUGcuid4x7BRQ/nmVbA6GJrXa0MLzsYB60kaX/R1Yyua3RlebMlu0DNGJFiOMSo0lM1EYYyUxkRqBpVhF3X7AEtVqX7v+VR5jTxh1XCHXGItaYT079+AJwcF2gwD3ooT/bv/WpgNhQWMES1hnVpzQcBpNgRTZEu4N9WFr4bg+Atx15n79gpIH7nTIoKtknBuhIwomeiGiSb2x+Gneu3aqJNmk08qrP4vEPafPwmUE5sZJqjkrBd7dOljdpnsM0Kx6P/C8KzHM660K3DyprOm9Si6d2p0+ti9kjvUZrFQVwEa4zkgcwrS57lkMBYlDifZ73BzHf45rS39z36IP2/r3P+Nsz43MOVNDyjHz21bvbYkZNSvSsxfF7uJ+s=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700016)(1800799024)(376014)(14060799003)(13003099007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FJ5uVQ7ClCyHFCMa8m9d5YTB74ng48gD1DFdQARWmw6J9tSMdv3eOQ93yXV3voGeHxiibIHmLAXSvCL+xBq+bUpv8OcTBgxYikBHV/z7wL7Lg15x4IhqWq/kkcmN09yRM+oh9yTz5PAjVCRJ8C5IMzoK1tPsONpPQTJre5wOV9YFXJ1cVllkY2DTe448/GuAlL804B6o5Intq6nLxwCC5D5Ha9V+ymmlduF41iwDh3hSQQSot7eje/gfelezjb6Nc5S6mQHCJE22kqV7r77iB4MAhjuAXhq8eq4WhPU0rSA890zjNL8Ayt6eMc3MuFLoPjYWQ8uMEwmroBQHDcIiCgJAhXFVj1s71R+dr+xFCg3L5n6c9ofPQD2CtN+07ryX61FRQPdSKhwFz6TbKGPGn1b73S9FLaxrq8rYUTa4epLDDCWXwXyS7Tpgz9FYMkJt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:50:47.0998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b035b931-4af9-4fc7-88ef-08de85cf498e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A2.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6036

This is v7 of the patch series to add the virtual GICv5 [1] device
(vgic_v5). Only PPIs are supported by this initial series, and the
vgic_v5 implementation is restricted to the CPU interface,
only. Further patch series are to follow in due course, and will add
support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.

v1, v2, v3, v4, v5, v6 of this series can be found at [2], [3], [4],
[5], [6], [7], respectively.

Headline changes since v5:

* Moved the arch timer code on GICv5 hosts to use the existing irq
  domain and phys_active mechanism, rather than adding bespoke code to
  directly mask/unmask the physical interrupt. This has been tested
  for GICv5-native and GICv3-on-GICv5 guests.

* Introduced a irq_set_type() handler for GICv5 PPIs to the GICv5 host
  irqchip driver. This is required to be able to layer a domain
  hierarchy onto the PPI domain. The irq_set_type handler checks that
  the trigger mode matches what is reported by the hardware, but
  doesn't actually affect any state as PPIs on GICv5 are not
  configurable.

* Tracked if native GICv5 support was registered or not when probing,
  and now return -ENODEV if neither native GICv5 or legacy GICv3 KVM
  devices were registered. This could happen with pKVM on a system
  that doesn't support FEAT_GCIE_LEGACY, for example. Thanks Joey!

* Cleaned up the code that sets and clears irq_ops.

* Moved vgic_v5_set_ppi_ops() to use the generic irq_ops setter.

* Reworked when irq_ops get set in the arch timer code to minimise the
  call points. This now happens in kvm_timer_vcpu_init(). NOTE: This
  does require the init order of the timer and vcpus to be
  swapped. From what I can tell this is OK, but I am definitely not
  sure.

* General clean-up some some of the commit messages to more accurately
  document the commits.

* Added some Reviewed-by tags - thanks Jonathan!

These changes are based on v7.0-rc4. I have pushed these changes to a
branch that can be found at [8].

Thank you for the feedback.

Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20251212152215.675767-1-sascha.bischoff@arm=
.com/
[3] https://lore.kernel.org/all/20251219155222.1383109-1-sascha.bischoff@ar=
m.com/
[4] https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@ar=
m.com/
[5] https://lore.kernel.org/all/20260128175919.3828384-1-sascha.bischoff@ar=
m.com/
[6] https://lore.kernel.org/all/20260226155515.1164292-1-sascha.bischoff@ar=
m.com/
[7] https://lore.kernel.org/all/20260317113949.2548118-1-sascha.bischoff@ar=
m.com/
[8] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_ppi_support_v7

Sascha Bischoff (41):
  KVM: arm64: vgic-v3: Drop userspace write sanitization for
    ID_AA64PFR0.GIC on GICv5
  KVM: arm64: vgic: Rework vgic_is_v3() and add vgic_host_has_gicvX()
  KVM: arm64: Return early from kvm_finalize_sys_regs() if guest has run
  KVM: arm64: Init vcpu prior to the timers and PMU
  KVM: arm64: vgic: Split out mapping IRQs and setting irq_ops
  arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
  arm64/sysreg: Add GICR CDNMIA encoding
  KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
  KVM: arm64: gic: Introduce interrupt type helpers
  KVM: arm64: gic-v5: Add Arm copyright header
  KVM: arm64: gic-v5: Detect implemented PPIs on boot
  KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
  KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
  KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
  KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1 accesses
  KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
  KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
  KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
  KVM: arm64: gic: Introduce queue_irq_unlock to irq_ops
  KVM: arm64: gic-v5: Implement PPI interrupt injection
  KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
  KVM: arm64: gic-v5: Clear TWI if single task running
  KVM: arm64: gic-v5: Check for pending PPIs
  KVM: arm64: gic-v5: Trap and mask guest ICC_PPI_ENABLERx_EL1 writes
  KVM: arm64: Introduce set_direct_injection irq_op
  KVM: arm64: gic-v5: Implement direct injection of PPIs
  KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
  KVM: arm64: gic-v5: Create and initialise vgic_v5
  KVM: arm64: gic-v5: Initialise ID and priority bits when resetting
    vcpu
  irqchip/gic-v5: Introduce minimal irq_set_type() for PPIs
  KVM: arm64: gic-v5: Enlighten arch timer for GICv5
  KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
  KVM: arm64: gic: Hide GICv5 for protected guests
  KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
  KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
  KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
  KVM: arm64: gic-v5: Probe for GICv5 device
  Documentation: KVM: Introduce documentation for VGICv5
  KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI
  KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
  KVM: arm64: selftests: Add no-vgic-v5 selftest

 Documentation/virt/kvm/api.rst                |   6 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  50 ++
 Documentation/virt/kvm/devices/index.rst      |   1 +
 Documentation/virt/kvm/devices/vcpu.rst       |   5 +-
 arch/arm64/include/asm/el2_setup.h            |   2 +
 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/include/asm/kvm_host.h             |  34 ++
 arch/arm64/include/asm/kvm_hyp.h              |  10 +
 arch/arm64/include/asm/sysreg.h               |   7 +
 arch/arm64/include/asm/vncr_mapping.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/arch_timer.c                   | 112 +++-
 arch/arm64/kvm/arm.c                          |  62 ++-
 arch/arm64/kvm/config.c                       | 123 ++++-
 arch/arm64/kvm/emulate-nested.c               |  68 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  27 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  16 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  15 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               | 166 ++++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/nested.c                       |   5 +
 arch/arm64/kvm/pmu-emul.c                     |  20 +-
 arch/arm64/kvm/sys_regs.c                     | 176 +++++-
 arch/arm64/kvm/vgic/vgic-init.c               | 214 +++++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 107 +++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  40 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 503 +++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    | 173 ++++--
 arch/arm64/kvm/vgic/vgic.h                    |  53 +-
 arch/arm64/tools/sysreg                       | 480 +++++++++++++++++
 drivers/irqchip/irq-gic-v5.c                  |  18 +
 include/kvm/arm_arch_timer.h                  |  11 +-
 include/kvm/arm_pmu.h                         |   5 +-
 include/kvm/arm_vgic.h                        | 191 ++++++-
 include/linux/irqchip/arm-gic-v5.h            |  27 +
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   3 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  | 177 ------
 tools/testing/selftests/kvm/arm64/no-vgic.c   | 297 +++++++++++
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 228 ++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 150 ++++++
 47 files changed, 3217 insertions(+), 391 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c
 delete mode 100644 tools/testing/selftests/kvm/arm64/no-vgic-v3.c
 create mode 100644 tools/testing/selftests/kvm/arm64/no-vgic.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

--=20
2.34.1
