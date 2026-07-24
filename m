Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011045.outbound.protection.outlook.com [40.107.130.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E873E438022
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890812; cv=fail; b=YU0x3BsUlyf+pp9LyUR9tRAB3itEOR7qXgnhn/JoxRJiuGqxLQz50DAwk47wBLTGDjP9MgCrT9oef9HbHD8gtXohhXVDKcPsMGXKDczz1utnz167vuzscjXRs5S55oFlprpujmShT1LTHoYId0fRImX7vrAUxADQNov7ZRGZbCI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890812; c=relaxed/simple;
	bh=J0HBfKyOXrNbhXUSL+TC61cGnGJJGYVmBw8X5ctN26w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qQ6DrG3ZIwKAaZlpsqf1fPMgyhzGkCMM+rmRKIax5KsfViUOb9hSglBzTJRl/5JspMMA+wBVRf9tmLBo0PyQEHKfHocDMKyGQioL3cKnDMfI+pxwyb2vsy9ooBg+S7hSgEGF/I9t1iZrBUzZAWYN5equEZVBV5PdgN5eq5dtcY0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BpGFmvC9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BpGFmvC9; arc=fail smtp.client-ip=40.107.130.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BpGFmvC9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BpGFmvC9"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=W0v4zyP5csA+LVMdG59ySmI9YKz12Q/CE66Bfclj3/Ggt1U0hcOiTBl8Yv8TnvC4osJjEPo/AfNCA/ADVBYLxuyIeUoZUbS65LO7XVUHWkD0aWb1mjSyQcBxE3G65jwLdH4oJBvN93pLmAvRD7V6KcFCZY9kdL++Q26lc4/LUp5bFp5NTb9jM4b8t9inXM2Ev8A2DsPwQZKxdDVwdHx1c8r/lsjyHGB0dIfbBmX13Rlix4RM69nWYCOdRU+6QwrahudoyT7zakTUgfmf4x/mYlfid5wl0oPK4J0CznQNpWjHxkzsdznXgo+cqCUDjDO6QHdRU8hafg92vZRB6uyt+w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H47L0E3rc84bl+smnT0SEg1p7CwCc+6fAzEq1YI7Lzg=;
 b=xOW3XsaS0L1nKvt03sx4JeAGeWlJjldpyMg4k+opMzf1Cwd17PKdYQkjv/V7zITa0jvyQYqDBIi8T3haBWw6duiM6CphwJ6i47lvk1ps7Et6gfIysKlby8BdX8pAI0sp1xbnycxX1CkPN65oUK3OXdE17W6Si4hqKiYIqZhIYgA15KlXbc1Bl6VPC9+wzm0X42fFY0kxh0pFY3lmXaQU1YoO7+0VKDJ1nGwSQdo3ofrZ9KRN2W7vVUeVFolD3nf46nsEj8eWk3bg6sBLlqb31XZpgxZkfxTZ0y5V0CcBO1sgxLuZEXXhUyBZrvo4IMtzxBMv97qYNbYzoor4QrdRdg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H47L0E3rc84bl+smnT0SEg1p7CwCc+6fAzEq1YI7Lzg=;
 b=BpGFmvC9u57Mb+8PLSQZE7u2n/gHmiSK1V1RU2anVbOBhy2kwvHb7nii4kRQ0m4DJLO9unIA92rDF/h0L+kFKhswE7pDacpdcGrXqp1oNjyjJPldCTKqqnu0xpMnJ1Awf+d+O4sqMAwzXLWJKNQDBTg98L/zSVmWEvLJiQklE6g=
Received: from AM0P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::39)
 by AM0PR08MB11780.eurprd08.prod.outlook.com (2603:10a6:20b:744::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Fri, 24 Jul
 2026 11:00:02 +0000
Received: from AMS1EPF0000004B.eurprd04.prod.outlook.com
 (2603:10a6:208:190:cafe::17) by AM0P190CA0029.outlook.office365.com
 (2603:10a6:208:190::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:00:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004B.mail.protection.outlook.com (10.167.16.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:00:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upQvgnQNMwBxv2BLCa2+R5bIL0JPtyCIlbHgFV06hxccKuBHUzbubPBDz3lrdgreX9H9VLIX3LG/igZmPNxvF31rMy9jTlh5170r+q19A1iuxY8pf9YxNsBMShOl/LxfrtqVCZli/GYoeTjwpFbpaHoN9exbvtB7rD1I6wy1fU8UCDPR6otDueOrb7zVSmNsacos3fbzXcfT6rlN50Wn1wwaA/ba3ghJXaph+pzh8u4TpR6L9wQjG8Vz4f9LbDFj1qdkeK/5kwvO2W74wRSgz5w88fw52znFPBV82sWca+MW6YadwJ05ENTXDmur46z98ZzfRbn5nkRKCshmuJ+RFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H47L0E3rc84bl+smnT0SEg1p7CwCc+6fAzEq1YI7Lzg=;
 b=DJF7zgJdOXTpJjd5h0ZEXWx99+naTh5pR/PMMtosiJw3laWnLZ60vh/26QaFJ6pmceHfmEKuFGubK8p13TgjOOaOEFaNuyDxwAKB7BZHSkB6Ic56vF1UP8UTqzXe9zzDTwtfUikL5HVjANHr34KFVS5PEITPfjoXEGJQpa4kOPN00r/dMnlGzrMY6ga11kyZl83FGNmZbyHTSZoL9R0rkOfwaHzIoYpxVn2aJw7U+ShZr09Iec/nP+UJ+g/vyVgyaMgSG4K0h/QjL1hPKVdfrvMqVOrIi1tZptQss5c0LTlYiDkJZCD4vWzzhiDXwm41q+t0QQ1+EbiAgA7wlAtCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H47L0E3rc84bl+smnT0SEg1p7CwCc+6fAzEq1YI7Lzg=;
 b=BpGFmvC9u57Mb+8PLSQZE7u2n/gHmiSK1V1RU2anVbOBhy2kwvHb7nii4kRQ0m4DJLO9unIA92rDF/h0L+kFKhswE7pDacpdcGrXqp1oNjyjJPldCTKqqnu0xpMnJ1Awf+d+O4sqMAwzXLWJKNQDBTg98L/zSVmWEvLJiQklE6g=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:58:59 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:58:59 +0000
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
Subject: [PATCH v4 41/48] KVM: selftests: Add VGICv5 NR_IRQS attribute tests
Thread-Topic: [PATCH v4 41/48] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Thread-Index: AQHdG1tttDEzstl/NEyfUZegvM8dUg==
Date: Fri, 24 Jul 2026 10:58:59 +0000
Message-ID: <20260724104819.1296803-42-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AMS1EPF0000004B:EE_|AM0PR08MB11780:EE_
X-MS-Office365-Filtering-Correlation-Id: 4223fbd3-a63b-4191-7f83-08dee972b5da
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 YJV+8Uw7HuJS8Ofsk2/aLdr7hwAQwKf2Im/EsCmcxfOqYyRMArQm8oHz3JTNIZ46ERFbNETVWlTCikw0DbVfgExzyltkb+bmvb8lBoczXowGlHPprkNRIn6PwQzhipgk2ZMsFlHm3LtfPWf+1KT/zJgLVvPBA4ls14HPY03+8Lrra+p4MHCHssOWbDQvAh1/E/DEotExMzlQ0O5t2paNpaJ1v8THoSwZM2GhOoVrdb4o0DVViDuM/+A0TFWKWmaj8GV83zGYA+6EkJsE3dxEmezcjd17J4ts/5A39sbuLCUfOGXmzIEAeWEKgBJhfPTLivl+H67SB2o/MMNss3e7pxIBE/0Uz6jyBEOVisRM/lJdjtJCRP05YnwGDWFt0tPqvicT+3kgcwv7T9oZ8QO3vxFryIEUogMXLyzuYjNHxtVcRtGTdNt2+I97tv5i+D4bz9xTS8A+mhPSghHMppNHSHs3XHgmYd/T4+wH6aPYrIv/7sv2AHjxNF/I0iSLGsPRnIZkWhY/Yc8I0N43Dl4bA+uUzL4jZjXVRprkts6CDfqVruBYFsqu9WuINDnBRxkznghtPREEfVurnhaI9ta6pa+7W7pb+kIu1Ke3JU5dXT0SMOUku94VQhgBHW+pUlqdCYw9Aj4cH2xED5g2DhFKCWC3aGyamkZ63h7fPE+UEzTVEZUZpWNZEU4wntAfKVPTEDZvTEQ6ciubd9xC5o0O+7karrm38DvjkWb0jOJT1zA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XvZftKjCB0JYV9xt2+diIv9997kynZ08Ng9sTn7EbfElwyV1fJaSIm3dgErRnkRYl4tKGKkEU7/FAd1jjS7bt6daTF0+j4Axli15B2kVjoTOT18e7gA9tkvZz5NXAQYOc59adxDFryyDAxVz1oRw2RHPNwM3EuokRjLFWenSHH8aSwBYRPya3p6gdClJ9e+NIH+TQEMTop4fwb7ktlwBvHzZLy/VIj6RCYROFfIoy4navZMNwx6EeVwtIQOEoYylkU160sk/DxMLhLWb5jCkmmP25CB7v82uIOsOIFm3soa+QK7M6WIropKLhX5TkoYilanf+dbGUuExX87Bvj38Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	28466ab3-614f-483e-dfc0-08dee972906a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|14060799003|376014|30052699003|1800799024|35042699022|11063799006|56012099006|10067099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2DJbRBqLBusERjsRtzpQNfqbmvfOUXI4EKbtHU2oHCwcYjsg41Ql34qXUoGQFM42fIzxJ/3xBK6T+bFpDgOeYT25VioEC+rq3diaB461o4MsavPXr2TynfV4E6nnUouM0PvM67tv+PpEgrfrrUH83QYQOfjMl+IWmpKrv7JXxE5p+4JBhIq/DUMeWy0ymKCZLROmHqSSnc31e8aTVh8ZwVTc2s+LlJhseIKkc5OQKgtRtvpNmwzXs8sBPwyZ17WgFYTGqH5u4931ArwWwPfAgAFBX+sQV+uzY/rWkF4HcK4UhVMkJWG8/X9CnCviWObxlVeftHBaPjj50k7K9eyYYds8vvU1s6ptu4Lv9HWRuEBqZMS0OkabUJENDLked0vYk7uvhCRQAwJmdfkGlTFFW69yUo8uZoUGA0Btt1sDcVJTvSaJGcF/didAlO6wMGyl+1Ujqp0rW+2NTMQ6RQ6HaVmGYGfmaEhyZRldclS2AZRdA0YFtFI7uprW4FEczpuTZWuiyYQgjWOOj7I6kNdmOZHRlKBhNWf71fQzY9TaVkMrEuiFxUye558O95CjrIjLgvrTdE7hHYqTuGa2KzTGau7l9v6yV1fn0qLx5WP0aiP279JNTh+Zp6ui0DyJnuZ6nStpEw+voJa6oz7xVEETGR3ok57D3q3h6UbL4JPZcl5X6q621qRYT+Zu7NI7UBXqfxKSGO5QnS6ZOwzs+IHW9g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(14060799003)(376014)(30052699003)(1800799024)(35042699022)(11063799006)(56012099006)(10067099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2ned3XVOiKL4LonEnL6vi9RkweG5Gj0HzD3vuvczNvJu0EaQYFoj49qqa2tkSMGxgtZeM7/wiCXMaWmujeyVqLRHA8q7DTcwGOuaPabV5QzaQzv1zGae0jcfipDPL+ae79ZEjGP0KZ6AcahqzG+vyqrav8jofVgF1QsYl1ONU4gETlZNonRyZiOjYmkn/bmNdpbVqKxXBrLGOLIpBIUpahYRq/hLgcGva9B8wjEoaT7oRVj2rmGckwXghefR2wHYNFshBaj9gRQmHwaYECDuw7qUV2avn/IRLPYQcakRogtaksKLdEKXFdFkFUtplY/jQVDCKrhsF+zNTPIwp+36urbbN3SWntgKuwSH1NgsyQ6JiSXARdivXUthqRHbzuw0NZ+nihi60kKKnt0WfaYRzFv6UMKVGxsPRx4BOPqDbI3/mh7jb26hb/hNJf0bCeL+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:00:01.8165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4223fbd3-a63b-4191-7f83-08dee972b5da
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11780

Add coverage for the VGICv5 NR_IRQS attribute. VGICv5 exposes a
userspace-selectable SPI count, and KVM must reject values that cannot
be represented by the virtual IRS or that would change the interrupt
layout after it has been fixed.

Verify that the attribute defaults to zero before initialization,
rejects too few SPIs (less than 32), non-32-aligned counts and values
beyond the maximum SPI range, accepts a valid custom count, reports
the selected count, selects the default count at init time, and
rejects changes after initialization or after the VM has run.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 195 +++++++++++++++-----
 1 file changed, 151 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 51ea2fe7141ad..95d74f501ef09 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,6 +13,8 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_DEFAULT_NR_SPIS	32
+#define VGIC_V5_MAX_NR_SPIS	BIT(16)
=20
 static u64 max_phys_size;
=20
@@ -27,6 +29,62 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (++count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable the SW_PPI (3) */
+	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	while (1);
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -51,7 +109,7 @@ static const struct vgic_region_attr gic_v5_irs_region =
=3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
-static void test_vgic_v5_create(void)
+static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct vm_gic v;
@@ -125,60 +183,106 @@ static void test_vgic_v5_create(void)
 	vm_gic_destroy(&v);
 }
=20
-static void guest_irq_handler(struct ex_regs *regs)
+static void test_vgic_v5_nr_irqs_attrs(void)
 {
-	bool valid;
-	u32 hwirq;
-	u64 ia;
-	static int count;
-
-	/*
-	 * We have pending interrupts. Should never actually enter WFI
-	 * here!
-	 */
-	wfi();
-	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
-
-	ia =3D gicr_insn(CDIA);
-	valid =3D GICV5_GICR_CDIA_VALID(ia);
-
-	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	uint64_t attr;
+	u32 nr_irqs;
+	int ret;
=20
-	if (!valid)
-		return;
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
=20
-	gsb_ack();
-	isb();
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0);
+
+	/* Before userspace sets NR_IRQS, no SPI count has been selected. */
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D 0, "GICv5 NR_IRQS defaults to 0 before=
 init");
+
+	/* Too few SPIs */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS - 1;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS below minimum");
+
+	/* Not a multiple of 32 */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS + 1;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS not 32-aligned");
+
+	/* Larger than KVM's supported VGICv5 SPI count */
+	nr_irqs =3D VGIC_V5_MAX_NR_SPIS + 1;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS above maximum");
+
+	/* Valid custom SPI count */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS * 2;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret, "GICv5 NR_IRQS accepts valid custom SPI count");
+
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D VGIC_V5_DEFAULT_NR_SPIS * 2,
+		    "GICv5 NR_IRQS returns SPI count only");
+
+	/* A second successful configuration attempt must be rejected. */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set twice");
=20
-	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+	vm_gic_destroy(&v);
=20
-	gic_insn(hwirq, CDDI);
-	gic_insn(0, CDEOI);
+	/* If userspace does not set NR_IRQS, init selects the default. */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
-	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D VGIC_V5_DEFAULT_NR_SPIS,
+		    "GICv5 NR_IRQS defaults to 32 SPIs after init");
=20
-	if (++count >=3D 2)
-		GUEST_DONE();
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS * 2;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set after init");
=20
-	/* Ask for the next interrupt to be injected */
-	GUEST_SYNC(GUEST_CMD_IS_READY);
-}
+	vm_gic_destroy(&v);
=20
-static void guest_code(void)
-{
-	local_irq_disable();
+	/* NR_IRQS must remain immutable after the VM has run. */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, guest_code);
=20
-	gicv5_cpu_enable_interrupts();
-	local_irq_enable();
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
-	/* Enable the SW_PPI (3) */
-	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 VM before NR_IRQS test");
=20
-	/* Ask for the first interrupt to be injected */
-	GUEST_SYNC(GUEST_CMD_IS_READY);
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS * 2;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set after run");
=20
-	/* Loop forever waiting for interrupts */
-	while (1);
+	vm_gic_destroy(&v);
 }
=20
 static void test_vgic_v5_ppis(u32 gic_dev_type)
@@ -294,8 +398,11 @@ int test_kvm_device(u32 gic_dev_type)
=20
 void run_tests(u32 gic_dev_type)
 {
-	pr_info("Test VGICv5 Creation & Setup\n");
-	test_vgic_v5_create();
+	pr_info("Test VGICv5 address attrs\n");
+	test_vgic_v5_addr_attrs();
+
+	pr_info("Test VGICv5 NR_IRQS attrs\n");
+	test_vgic_v5_nr_irqs_attrs();
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
