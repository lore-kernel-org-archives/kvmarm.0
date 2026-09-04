Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010030.outbound.protection.outlook.com [52.101.69.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7699A46F4BE
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523072; cv=fail; b=fbIF4yLeBgIP2C52tzKNuozkklEteyIsO9NzowyvsPIoApNJ1OuOM/XwjuyrZk9jkHf/JjAglnX2bIydFUCMzSMBiTKp8yB0cvwhTD2BTGB5Y4Wgf2aRm85VqwaZX4uB5DkjL5XZnY/30TnIhxaEf32rCx0CQmap272TlTf9mgk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523072; c=relaxed/simple;
	bh=3RI9yuQ5X1bZ8zdGg3mHrUrPIc+rOr/m3DXBNrdtTRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eUg5tiTCKV5hB1WQsEuklkmVNXK5JwJxPXiOWe0eN6KYL7KuQGIwWTaH5KIOOZBIodJGaHb2DjwJNIKmbpaOkoXxcuwe+P8qM7v0PWoR6kwflZo2y3s7YcAfz5QlcUIlmZ8w5kxJofZjldGqJ0lfTRzFXjrO8k2mr3LmUEU+5rY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=psrAp3iL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=psrAp3iL; arc=fail smtp.client-ip=52.101.69.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="psrAp3iL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="psrAp3iL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BTtmYpxE/F0i/bMMfmck3JqVa8RDTeyPaawS/dEeYzq4HbqZxGtDps5NGHKebmFJAO30FThhwAsDZQ8iHvu5JmLDuQCAuSbVchAYz2yzcnlTwJXjP4ORl/sptcoFy+g41XpFj7ozHpYWh9udKd+CydoXOEJttaQfrwpdiQ3JukS9Jh4d77n4tQianh3S5popMB2wokkNqBue4xVez6VLSl/NEzEvaWxVLKJUKQ07XdSYRKeiEl2ohQsEJxHnYVxvudVGf0NW5cG0rhzWefBPB1Mq4QsC8QPlf29xkpMmLVS0IeIRPTypJux+ZVp/bwBA/fPreojLJpOJkuZOxCiUqQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2JNyE5vdgRdcLiq7MbxM5E/6VJ1jSzAPzf1/unqfpI=;
 b=Xfy32u7RVLjYv3VAmM5cm8E9J/obZNvHaXtKOC/wCHL7q273vhmmyzvCpj9By9N2w1/b11MAQ2y09HEHxVKZ0o/yI2mQCPOul87syScAjcEywVDnbYXFqrWq7qH+RkolBWdvnYNoMMlA/8m+dwNgt0T0QLOLP4sAO9eu69CIQ7P4rRzVQLXtNq/hTb9ABBDK7X/1r2t88LQNyfM3K3HPj0lTmq5u6+LILBIWi9eoI5Tsq+K7O+2v4iv0052/wV6On++HPpGqb1aRuORvFAPY0DFhD/2MUz2pawt5mHh0UG2WtbG8DXLIb//E3NoAPPmfxj9P2TKvrooiqjGLd77uZw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2JNyE5vdgRdcLiq7MbxM5E/6VJ1jSzAPzf1/unqfpI=;
 b=psrAp3iLwGyMoy2vX77tERoSeNvdTzWEb06G1wjHlr43fhd7Q+yKUqvx22DhKnHIrn7edYFgovFViVk//xLqZApUiQyxpzf8UvEU4iZuNAF+cr0sVNh/zzbteucHC1z7vesoJ9imKLg1qf4rrKUx3/Jxw05FN2BO7g1ivDD6gqs=
Received: from OS6P279CA0129.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:3b::11)
 by PAVPR08MB9063.eurprd08.prod.outlook.com (2603:10a6:102:32c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:57:42 +0000
Received: from CPH1EPF0000051A.eurprd04.prod.outlook.com
 (2603:10a6:e10:3b:cafe::88) by OS6P279CA0129.outlook.office365.com
 (2603:10a6:e10:3b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:57:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF0000051A.mail.protection.outlook.com (10.167.241.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:57:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ql26Mm/Xl4BSWTSaA4MT3KCg3TFhPvcGTG88RCVMcIGgMQ3Qs0wNaIpR6ii/mkFPEFnlMGhBTTee27iItdHkfkdJc3GOHb6PLxCTQAndEHkdV75+NAWpndf9mfaKn7gR0n8oAZvBq8zZmrT9+XNS6aFfouLB9bHNP8NvEvEitl+Gne79YzqOY9tlhANhPAYkDQk5bqcPg5x7Olsj5RVGFCroTbN49mqE8DY7rhdxtPRnCEp+aERAcCVFT4h+p+q1vNf5ce5LoF3Urc5+tQkpTe/TQHah8YFqOtcVlS4m3ZgwXF5ES6W3/SfsIwp3ETBj2/8FcE09GiqH7a3h7ZE3ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2JNyE5vdgRdcLiq7MbxM5E/6VJ1jSzAPzf1/unqfpI=;
 b=mFWlnCIS9+f6DKdf285S/Dut5xzXnzV8VrnoXYpoL0RSBTNRaKg2DArVIKMlv/6ZC+7J/+w/12etiNrdW6FWMxEBWnA6hYPZao8jYil8qvQT8kMqDGWkpO2aiBQ/shOjcXY+BmuLz4Q0UVsyz+JztbSTqzXK5IHvXdWnVnxhLoIBMQ1/mAcr6sl0J2AxdAfRIw+KUV7l4QyGa3sxceBiqgzp2PVb5UdBxAys6n1LYrak1bw8Nrxd8TdzwUAjPcxDQJJbFgLwF0j4SVJ+0f0OiYgowopHh7fKf8q0SGvVdxgCupivETwM7d/XgVfk1eWSf/ObnCTORFxz9Rh43aDv8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2JNyE5vdgRdcLiq7MbxM5E/6VJ1jSzAPzf1/unqfpI=;
 b=psrAp3iLwGyMoy2vX77tERoSeNvdTzWEb06G1wjHlr43fhd7Q+yKUqvx22DhKnHIrn7edYFgovFViVk//xLqZApUiQyxpzf8UvEU4iZuNAF+cr0sVNh/zzbteucHC1z7vesoJ9imKLg1qf4rrKUx3/Jxw05FN2BO7g1ivDD6gqs=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:57:09 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:57:09 +0000
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
Subject: [PATCH v6 45/49] KVM: selftests: Add VGICv5 CPU sysreg attribute
 tests
Thread-Topic: [PATCH v6 45/49] KVM: selftests: Add VGICv5 CPU sysreg attribute
 tests
Thread-Index: AQHdPGSDEn80ovAAoUqoBt91wzanpA==
Date: Fri, 4 Sep 2026 11:57:08 +0000
Message-ID: <20260904113404.4051341-46-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|CPH1EPF0000051A:EE_|PAVPR08MB9063:EE_
X-MS-Office365-Filtering-Correlation-Id: d91d4169-a61e-42fa-eab3-08df0a7bb979
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 1y/mPUGxvqHTmmIKnwfp5h9cdDh+e/PmFisM1IsUEipBNchE1kPP5u8YVkPS7Ih5DmEowfACn14tE2SYE+b45J2LkCorEmkZG0B9m1pnq0n3nXgZzEwmk7r/2R2yRdYbYaxQxR8TfFEiPBda9Xt1vKW/DmZnRzCTR/Uc0vfyqm8jdlsQYRhgx0d9d1pZfOwZGkzys/iT1tZ9O923u68XoHuGKkfI/8K1t4wP53isr2gAV+6hfAFYUtLL3yWkXXBU6VDFF1f2y6x0vLYaEmLpfYRZshGoHYhgwXIOmr/XYNJmikgCBTe7/Bk4Pc4Mb2iyPEgwMsDCJNsESGoxDfKMCj4MtT73nXBL25IEuC6JSPsbTO+fjgdwLxdjL1CS1nWrovSXil5F9Hhp0KLfd8afjMVLpuhU+OOjrysFmnVaElAuZbVHZcKZ3sWOBnZmSDhyYB38YoGZHoDRhi0nn/gys4FdnUY2MJaacLgkRhRdWjN/9UUJ7RYEuXO3nUji/+dUHLhaDuqz59WvbHBSrq0EVxDeWsc9YTeAM0Me4v+Dn97dAfig0kKQ7ihyO3NSfJ+4xu13O7qxfy0LQnGPrYR7KuDSGLeR1Z3/vAIsCGRgDYUXlREd2++iMvuepkkdAHMrk6H0SfiXx+a6zycuyJcd9i0h7FRi1iA9kXP1rO5N/xBZiDSD+2Puk+MeIQrnsALWsHz+ONqd3k+uPXSAnrN8CgAhvtPiaNx05fgr2Lt7kqM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 yaXUbLpLbtGad878Bw/KDiy3dCM06O+yxAAJoLyuenrd3z6QZ05DdK7cGn8UQK8qJZEzWxH+pdtoAXD7mcILEYNl6l+WLuWlSx01RiqZTc2dN/czdrBYaOr9BNYqajhysEa8DpEo6WwhClYBHsHvrHOmdFi4IXhYcd8GZNAuQ+/oiJxDv9/pvMNA6+s6DMSOtNeLfk7OzVg8W8KEfouHZZyJ/KVg4gb9v7VAVi7XwCxaj7EMFWDUzbAoDTaMlMd547E3q5MSOLeJ1stgGuSQEb6AwvulKOCfUYo0YcOiVoo1qCT2bbGocONYlfpmOC/iNwQMRmyvTrZqKXFKubHJHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF0000051A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0d07aeae-5399-461d-3936-08df0a7ba5d9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|35042699022|1800799024|14060799003|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pevEJKAm9AIUPtq2idnv0O2JNu7uufB7hS681zO4baPx6TlNUUrbrjNb1SfSD1dBSKZYG0RcYmpwc0/ZUg5sbJr/bqMortf/2oUMCcnIKXdeYyccEV7lf1+528xZzxc5cr6YG+by4OvlcOZvqtLsj5TyihlLae2w/VgTH2E19fOTHcIwyufrGzCN0jWO0YiRRXsFJbp3qFdynYxV2uRvHPXU3U8QucZfmFu/IHodaIhDGqtYdjfvkhCHnlMw2ndtuZWeMDdq75DqRtW8grtvAFYFIiD+S4DFEHtOrWSnbLHC2rYil+pdL6uBOCAcin+dd5/aqy/KVwcbXvSyj0YgY+0PqtGP2hWHMOoi1WAWL16TW5tA/D+u2E1KCWTXoZK3nnuLseAE3s2fe6Cuj4smEMFjFZl3x4C39j9CTlrbsokGN4GzT1ug+7X2ehWGIjuVQB+dPkw3bwtqTOyzijqbEIheOF7bz1J3R6/+ilYVsYOdMNCSr6xox+eycG7RmHfnGW97mvjS3tPNF8kfDBYipYgB3oDsy7ai63lVYiMj/IOeQeQyLtmD8zfLNzetRNIzehTIYFwOx54k9p6dELatFda5BO53C7X3V1HdQqaHFtnptb1Jo4TSzdbgpfmq+X7eqPP1wWl6y4biplOxyqltW9MvMeyvlNli7pqhgPQXTDI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(35042699022)(1800799024)(14060799003)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PP26KWJdKgUXQyT34ScrQSnw9qS1x21DgLZZCbVrMFfxb+TqP3mOX917MQJwNDLNNb6ww0AMZzQol6QalB4+5QkrgmSP4bqA2JRIlk8vADPzw9lBtTPi830o8bqRuuKhTD3hcIVN8f8xdKk0xux5Nqc72NokNQzONbfuDNq66diVqkIg4N1Cjk3ERuN5Z8aPPMIP3SVBKtaBIwGMrK/hIklqcP1NxL4KZuNLOeAYIMqDUrOmbd0MWWe/f7iZHdvaILKFVf+LuX/HhaZJEebZ2ifrQB888urd++tEnzhXaEbYjN+HDb/VsfZ0XtHOH2BpT5N2qZAhG1DXQcfYch+5rOBoJI+n35LXTbTezU60TzJonRTpFbmjFsUeeWvmRsQekWJaUE5ksyBJlMpImTqkP42IWBsNIWsspBnasETa+dRr7+f1qL43XMuc7MTS/Nwj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:57:41.7309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d91d4169-a61e-42fa-eab3-08df0a7bb979
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF0000051A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9063

Add coverage for the VGICv5 CPU_SYSREGS attribute group. The
vCPU-local CPU interface registers are part of the VGICv5 userspace
ABI, so KVM must expose the supported registers and reject invalid
register or vCPU selectors.

Verify that CPU_SYSREGS access is rejected before VGIC initialization,
that all exposed VGICv5 CPU interface registers can be read and
written back, and that unsupported sysregs, invalid MPIDRs and bad
userspace pointers are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 137 ++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index ca574bd45ff0d..f294e58f6b50d 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -135,11 +135,29 @@ static const struct vgic_region_attr gic_v5_irs_regio=
n =3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
+struct vgic_sysreg_attr {
+	const char	*name;
+	u32		encoding;
+};
+
 struct vgic_irs_reg_attr {
 	const char	*name;
 	u64		attr;
 };
=20
+#define PACK_SR(r)						\
+	((sys_reg_Op0(r) << 14) |				\
+	 (sys_reg_Op1(r) << 11) |				\
+	 (sys_reg_CRn(r) << 7) |				\
+	 (sys_reg_CRm(r) << 3) |				\
+	 (sys_reg_Op2(r)))
+
+#define SR(r)							\
+	{							\
+		.name		=3D #r,				\
+		.encoding	=3D r,				\
+	}
+
 #define IRS_REG(r)						\
 	{							\
 		.name		=3D #r,				\
@@ -201,6 +219,35 @@ static const struct vgic_irs_reg_attr gic_v5_irs_regs[=
] =3D {
 	IRS_REG(GICV5_IRS_SWERR_SYNDROMER1),
 };
=20
+static const struct vgic_sysreg_attr gic_v5_cpu_sysregs[] =3D {
+	SR(SYS_ICC_ICSR_EL1),
+	SR(SYS_ICC_PPI_ENABLER0_EL1),
+	SR(SYS_ICC_PPI_ENABLER1_EL1),
+	SR(SYS_ICC_PPI_SACTIVER0_EL1),
+	SR(SYS_ICC_PPI_SACTIVER1_EL1),
+	SR(SYS_ICC_PPI_SPENDR0_EL1),
+	SR(SYS_ICC_PPI_SPENDR1_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR0_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR1_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR2_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR3_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR4_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR5_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR6_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR7_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR8_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR9_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR10_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR11_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR12_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR13_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR14_EL1),
+	SR(SYS_ICC_PPI_PRIORITYR15_EL1),
+	SR(SYS_ICC_APR_EL1),
+	SR(SYS_ICC_CR0_EL1),
+	SR(SYS_ICC_PCR_EL1),
+};
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -708,6 +755,93 @@ static void test_vgic_v5_userspace_ppis_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_cpu_sysreg_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 attr, val;
+	int ret, i;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* Check existing group/attribute */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1);
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS, attr);
+
+	/* CPU sysregs are not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 CPU_SYSREGS get before init=
");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 CPU_SYSREGS set before init=
");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read all exposed CPU sysregs and write the value back. */
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_cpu_sysregs); i++) {
+		attr =3D PACK_SR(gic_v5_cpu_sysregs[i].encoding);
+		ret =3D __kvm_has_device_attr(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS missing %s",
+			    gic_v5_cpu_sysregs[i].name);
+
+		val =3D 0xbad;
+		ret =3D __kvm_device_attr_get(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS get failed for %s",
+			    gic_v5_cpu_sysregs[i].name);
+
+		ret =3D __kvm_device_attr_set(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 CPU_SYSREGS set failed for %s",
+			    gic_v5_cpu_sysregs[i].name);
+	}
+
+	/* Check non existent GICv3 sysreg */
+	attr =3D PACK_SR(SYS_ICC_CTLR_EL1);
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 CPU_SYSREGS accepted bad sy=
sreg");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D ENOENT, "GICv5 CPU_SYSREGS get bad sysreg=
");
+
+	/* Check non existing vCPU */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1) |
+	       (1ULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT);
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 CPU_SYSREGS accepted bad M=
PIDR");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 CPU_SYSREGS get bad MPIDR"=
);
+
+	/* Check bad user pointers */
+	attr =3D PACK_SR(SYS_ICC_CR0_EL1);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 CPU_SYSREGS get with bad p=
ointer");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
+				    attr, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 CPU_SYSREGS set with bad p=
ointer");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -850,6 +984,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 userspace PPI attrs\n");
 	test_vgic_v5_userspace_ppis_attrs();
=20
+	pr_info("Test VGICv5 CPU sysreg attrs\n");
+	test_vgic_v5_cpu_sysreg_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
