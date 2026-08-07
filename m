Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010050.outbound.protection.outlook.com [52.101.69.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE8234B669
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101658; cv=fail; b=COwJef90x6Tf1KKP66v4rDtYAazqsHI9A1uMAZjEqZIcsoXB7O9X6s1LC9e3c2ak47964gJ8/CyMutq+XxoR/vHRplc9SeCAr9XG07LLlCrBI3UPW/TZSEc4H6y0ypuWhGwxbLVeSLLuQPolISpO7j0bJue7mqYzuSLxf0Jpri0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101658; c=relaxed/simple;
	bh=NLMbws0p7hyDFjICKDEmwidgeEC169eWn+uVAXQztAQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OEDpKJeoeR30gVQKOOgf5zcwfVyONy4ft4Ng9aT80ix3n1dLUQa8Razc3FJ07qFuxK4pI2GNMpWIxg/65tUv4eYXUW5gfbfqkW25NKVWHgCJw02hznvUYb1FtrCELMhqGrflc3RXL/SKXJfUEXccCpX+o8h+y2JL/pX1q7CLJ90=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YX9aDAsh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YX9aDAsh; arc=fail smtp.client-ip=52.101.69.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YX9aDAsh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YX9aDAsh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eWS0R031L+QKF56ujuDYI3KoCN4S+qCOsB0G5gC3hdYsJzMUM8dLauTLXwmXLBRy5oHRsHqe/wpxxJb0FYCXnaARNWsGklMViskMW/D86J6A+tmfhqaOglE1YFaxk/yVEazHpZV2539/pK24rYmGr7kYOVRtswBihYhEwy5fECP/Xxn2hvL7t7TswJg6Jo8G0IiAMo4iwWz46dVyeHH4ch5Wfs19h7Idveh2e+yA4cxHpol1TBI6WrdqBX8wN/Ofc1DzJktWHjV69hPGdGbth7JeKRCjL7sqtKa/BNG21E1+HSNlhLNvEwVUU8IImLgb9dpeGG6946BeKmDYzoLI2g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sow7ZLB5qtyxMof6CPcmdIY5mN4IB0T0K9JZQ5Oa5ug=;
 b=NAOmDK+HDfKXRDzE33/2wo48F77z2980+FrHTNB8utJcomUqRDRMhjS0/wI0sxt2ilGCt+bC75j0sTdee/hfELKWVMfycrt0kr6MbgFT5qY09DG/ZWVj8GDEn5QrARdpug2DdHubKqDmkQMK/nlHCDP9bNTe2ig/J763U7bglyhk+oAw1xzyCyItE3miJyVvsIJrGbbYsvdwnwk9JNZ70Js1QRYgQp0Q+x4zKcVVXxZFuSx0eSYqEZ1viutmxl2bzq9J+WNCoNcgXyl4NrCjbKgDKbU3mr4uqll6wYzM5Odco1ORfUYdl+sI+bHf8dgswUQuwJ3xBXjliRaFtvmA0A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sow7ZLB5qtyxMof6CPcmdIY5mN4IB0T0K9JZQ5Oa5ug=;
 b=YX9aDAshXuWvTv1IaftEPgQbvL1DVn+tzmva7ZIBPSeAFvV3dwQB2Q0j4H7SzLespYtN4l33JneHjGwdWgfJYUKOfK3IRvYy74svpzzo8dxld1v0+St+2+X/uDtcVdQzbn597GVnnPAxk6STjYdzIjQMUWMZ5S6aSMX8s6UivIs=
Received: from DB9PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:10:1da::17)
 by AS8PR08MB7888.eurprd08.prod.outlook.com (2603:10a6:20b:52f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:20:47 +0000
Received: from DB1PEPF000509F0.eurprd03.prod.outlook.com
 (2603:10a6:10:1da:cafe::a0) by DB9PR05CA0012.outlook.office365.com
 (2603:10a6:10:1da::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:20:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F0.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:20:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRD7UGAdnO2EhbHCoQYBGiw0WYYe3tzre+zDxNJ+9W1LmUtQjbrabKAY3XvL8OrNCRD+H3mHP6YfXfSD8YcxzWDgO8NHWB9t2unFZVWI0tyqgdoZAb0VtXRjiNN1EckoxOpY8Tn5r7SQMlVXJDUnq3DkgPDQFvaib9aXkSypGUqGyi+rwrDMkVnNk1p9Dg2DyakPpLPU+/fB+HetNdoUDYJF9L6MQAwbikPkz/1nRUujZNz3HuOZ/5P9WeZwdsiNvjFfptjwo2y97bNAaByWQrmGzWpfbxJhin7bDxd+h9tMecnQCszt/EMkaezan4Kgd4c1Y/k+vcLJPCVaHIJUIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sow7ZLB5qtyxMof6CPcmdIY5mN4IB0T0K9JZQ5Oa5ug=;
 b=u2mRinI8N98toCTsNer3kKIIuGAdkZOtKGk9Lqkaq09R2d9EBLE8qDT4ycbvCHRxwNcvay7bcKDONQ6NFFkuQinYM8DlZPgPHQ4RlqQwOwC+89RGNJLKpVp2brZ5a2+xS3Z5C44njxBaVILQcGI76hXUhlbWbvgUwOPnxVY3Vn3nS5FOo3mVwtokeflRc6XRKp1uCsHXMoJcCFN3jPING3hlduPrdIU1pKyHrL3szxmc762fZngcfmW7Q+Rw5R+cvB1H86/so8GI83HawRPxBOfnr5hUm6phmCiHDZtDdpkUQkNBnS3+IxnZjmRDrcvig555jGQLbhY173YZKcU2Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sow7ZLB5qtyxMof6CPcmdIY5mN4IB0T0K9JZQ5Oa5ug=;
 b=YX9aDAshXuWvTv1IaftEPgQbvL1DVn+tzmva7ZIBPSeAFvV3dwQB2Q0j4H7SzLespYtN4l33JneHjGwdWgfJYUKOfK3IRvYy74svpzzo8dxld1v0+St+2+X/uDtcVdQzbn597GVnnPAxk6STjYdzIjQMUWMZ5S6aSMX8s6UivIs=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:20:14 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:20:14 +0000
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
Subject: [PATCH v5 15/49] KVM: arm64: gic-v5: Add resident/non-resident hyp
 calls
Thread-Topic: [PATCH v5 15/49] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Index: AQHdJl63VEcs5wG2l0iE5ni4Fweu+Q==
Date: Fri, 7 Aug 2026 11:20:14 +0000
Message-ID: <20260807111159.429128-16-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|DB1PEPF000509F0:EE_|AS8PR08MB7888:EE_
X-MS-Office365-Filtering-Correlation-Id: a3893db0-b327-494f-1d9d-08def475ee14
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Oyo6NsMaNKFK5UTgdsfVylXlKpdFJ3lVwutsiafqfaXxWbt4tq+ph4oaamvL1prNtcsxL1SFpEp9W/Bia++07ttWS2udB5xiwFuXWSl3IQTJF6b0o4e5XOhE0yDw/cgejqz6XUZMXtbzcuRrptOdQ6lvsHHKaoHhmtTSBSkhINnvwMEpE39oju+MmENytgACP9Q3wwOaqlhRjV1QlVatY3KiMlJN3TA8dphy9kfP3KeZFEGCPMK3zAxWdmTkLTjUIh/EYHww88MkzffKm+krKbK2VjKw0mqmwHpm8sIn0PSoqQaewbIlL7A58Kl8jrm3kGi2sEL8uLhksZT+40v49UIc0DNJTSwi1nU5AcYTZ+fTxRfC0I5ktave6YQX64moB8CHFEmILoEY/uzUNMFOkRERoQgGLObgKok9SsXi1pnUk72xdTMsLxPZ2q5CvW4fBVoON4PTzhKQERpBRCBdx4rJ80zp1B3ApqDBPlhcTAN2PsrsEzwUvsWyzlaIrduKben/zU9M8CnXbLZJO8hARXAHx/vzNEcGpoH8ypVjwllB2OkDyoesz0cPApo2D7v+15AC6MytpuYNdEOflZgSIzSxY1B+vn/6vDo7UefvzhDlhBUdBXrnEEQUzUVd3/zM7U2T2ZGH94Iptu8BzUU6kFwIPH7F8o+FNBNzZ+ovwMteWZW0eRm+FmK1pPPKv9ULAyYgjOyxoAmoRp3qGYNVibkahxQ0dl60f3KeGT0wzN0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 r5iJMuu1J/aPjNgFC2gsiPddDa28A09dTdGEETQ5lNipwBGJGlPg0bn7YexsUje0SSMDBWf3xO42167T+CLFdMii5Wx4yjYPwCt0ZOKV+H/Aed1o64EZEXK41wrwRzSuXYBqgPgavJRPWB0DYjt7qk2niHWM+iCxm3eZ2empF5NLYT1ASlEKTzuSy/PE/4bESrA6ePU0oTnDyodGOmcjX+Lfb2BNve3Op4YmvGuK/S+ypMMf/i11PRzmvnq8ps+PiJxOvAbah05UN+D05czLleUOkP8TayYk7K/9xx+15pNKFXj1sK/VvA8CBPz7HUiDZJQWVLPtgzs6CLeicb5j8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c6ff9d82-acc9-4fd8-4ff2-08def475da47
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|82310400026|35042699022|1800799024|36860700016|376014|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	YDd2Y7T7QRsdVS5TYyAxMvz2VeDzGvzUhWnwVyH+e6JEPl81AQ0q5sWRV1bpVqfnMUVGDrtCbnDOnG4yWBg284K26DeWZWjOm0AabrQSdiPNFuj14nUBiFA0yLt0sjwNfxvQsEr18I7KltD31PS9c4ItaNkjVIAn8w6+6NUFWcUaQmE601SKZNVEOEtx4e9/6uoWlbTKMZUTxk9bHQh8Crs354e19XUAXifXat/sFP2eqG7yExaiE69ehURU/2aBhvXXHTDyOX/pGoqW2VaSwEAVnCuM9qbXFZf1JBPzbtoh93/aQqaq3D4UgPwNhqnulgRlnb+J5hxXhcvlM4E53DA7JI3hHY29+BgXccneME2KYIg9Vd/Ec8gIKv0TIy4iZuFJZnWnfAWfV0+TYrzB/WyatlKNrFZsiSZv9id1KEJKdgyuL/2cR+bz24iCdJ6qFkLYy+lBn9A4uGLIGR5ksY5v2V75bGyV+ToGmFiQwpDCz3oQjmShAuHMdoy06x2x4+xYsF7osgF8j8tAzcw6VgpYLD7VHcgn41xoPIEsgLeRbtACudAIXPbDnfIEuXzOcf3GZGKC8oCllGGpFofiTn1eo01NCrFrggW63LRW3F85LKPG1YPEYqlrUB0dvBBo6adKfZrM/NaxPIUjW0FTAIJcOBl82QrX9FGgeQwhkWbJZJrpzGkxDC0iZ28NWI9A8BIVN8Wj/R5AL7YrollGhA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DmAa7w7vUNQZTN7nDfMpC9RAza1DWKeR9/YHcUPoG3TCxnA1e/O4jHEbTu0Y4EpLaF4iviWI0lUVq/ur3TCsy/rJ86bjv4LRaCs2kiWmHe3xCpq23OzN0e/93MpPcq4KLYhxtNT4e7uHeJ/pKlM/R2/JXOKY9IeYmxy5mjeDmCApT3fJ6J1CZwHgIqsd5BMj5WNb+KD3O5HdoArvtJfLo8+M8ty7hIep7WXajsWym8yHPzHrLX9vQoUz6NvfAXa6gyM8P4YHT4wpd5obO4G65E4Z2CsrLIKYCDfncSFVxbHg84t2eb3NtaYh9JQh8kj8LKp+94DlmSYwLK6AcwAAqSj7xiyqv3vUp34brn+BMscNBRYd0Q3IElHp2KDJYC2VUkiFL82hVU01w6CA9SY9KRMBm/I4rX/BqTK1RjI2Viq16XTo79IHU9Jbmeb3CiG+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:20:47.4726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3893db0-b327-494f-1d9d-08def475ee14
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7888

GICv5 introduces the concept of VPE residency - a VPE can be either
resident or non-resident. When the VPE is resident, the IRS is allowed
to select interrupts that target that VPE (or the VM) as the HPPI
(Highest Priority Pending Interrupt). As the IRS handles both SPIs and
LPIs, these will only be picked as the IRS's HPPI when a VPE is
resident.

A GICv5 VPE is made resident by writing ICH_CONTEXTR_EL2 with
ICH_CONTEXTR_EL2.V set, together with valid VM and VPE IDs. This
informs the IRS that a specific VPE is running, and that it can begin
HPPI selection for that VPE. Making a VPE non-resident (by making the
ICH_CONTEXTR_EL2 invalid) informs the IRS that the VPE is no longer
running, and it stops HPPI selection for it.

This change introduces two new hyp calls - one to make a VPE resident
and its counterpart to make a VPE non-resident. As part of making a
VPE resident, the resulting ICH_CONTEXTR_EL2.F bit is checked to catch
residency faults. Such a fault indicates a broken VM/VPE setup, so
warn and mark the VM dead.

Both of these new hypercalls are explicitly no-ops with pKVM as we
currently don't support the combination of GICv5 and pKVM.

Furthermore, this change extends vgic_v5_load() and vgic_v5_put() to
make the VPEs resident and non-resident, respectively. Hence, the VPE
is considered resident for the entire load-to-put interval.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 26 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 16 ++++++++++++++--
 include/kvm/arm_vgic.h             |  3 +++
 6 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index 043495f7fc78b..d9ff9c2999aa7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 4974492744cc8..8fcbbff719cce 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -88,6 +88,8 @@ void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *c=
pu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
 /* GICv5 */
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
 /* No hypercalls for the following */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index d3df96ed8ba42..7fdcc6bb6f594 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -691,6 +691,26 @@ static void handle___tracing_write_event(struct kvm_cp=
u_context *host_ctxt)
 	trace_selftest(id);
 }
=20
+static void handle___vgic_v5_make_resident(struct kvm_cpu_context *host_ct=
xt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
+	__vgic_v5_make_resident(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_make_non_resident(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
+	__vgic_v5_make_non_resident(kern_hyp_va(cpu_if));
+}
+
 static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
@@ -738,6 +758,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__tracing_write_event),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v5_make_resident),
+	HANDLE_FUNC(__vgic_v5_make_non_resident),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 6d69dfe89a96c..f064045a31aee 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -7,6 +7,32 @@
=20
 #include <asm/kvm_hyp.h>
=20
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+
+	/* Catch any faults */
+	cpu_if->vgic_contextr =3D read_sysreg_s(SYS_ICH_CONTEXTR_EL2);
+	if (!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr))
+		return;
+
+	cpu_if->gicv5_vpe.resident =3D true;
+}
+
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	/*
+	 * Make as non-resident before actually making non-resident. Avoids race
+	 * with doorbell arriving.
+	 */
+	cpu_if->gicv5_vpe.resident =3D false;
+	dsb(st);
+
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+}
+
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
 {
 	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f15a8309d7a93..c36ae9e07ae26 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1058,6 +1058,8 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe =3D vgic_v5_vpe_id(vcpu);
=20
 	/*
 	 * On the WFI path, vgic_load is called a second time. The first is when
@@ -1070,7 +1072,15 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D true;
+	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
+
+	kvm_call_hyp(__vgic_v5_make_resident, cpu_if);
+
+	/* Failed to make the VPE resident? Bang! */
+	if (WARN_ON(!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr)))
+		kvm_vm_dead(vcpu->kvm);
 }
=20
 void vgic_v5_put(struct kvm_vcpu *vcpu)
@@ -1088,7 +1098,9 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D false;
+	cpu_if->vgic_contextr =3D 0;
+
+	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
 	/* The shadow priority is only updated on entering WFI */
 	if (vcpu_get_flag(vcpu, IN_WFI))
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7fece54ff0925..9d509cb90ab22 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -525,6 +525,9 @@ struct vgic_v5_cpu_if {
 	 */
 	u64	vgic_icsr;
=20
+	/* The contextr used to make VPEs resident and non-resident */
+	u64	vgic_contextr;
+
 	struct gicv5_vpe gicv5_vpe;
 };
=20
--=20
2.34.1
