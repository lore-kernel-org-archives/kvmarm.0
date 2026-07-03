Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011055.outbound.protection.outlook.com [40.107.130.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CF32E542C
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094124; cv=fail; b=diFDXvDP1vvAV8rsMSkQLWPxZOMxPqo0tWJpfoybJkCMeKbzsMgQX7NQ3Rvmi2/crGuFdKpYgLjZKJgTWeIij3eta3H/DhXrnAG6ruB+7SD1rkTM9J0enUi6yCi0iulnDq2ieVJCYR2E4COGYgjGT6LmTcRpnNVKnZDbgG4KD+0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094124; c=relaxed/simple;
	bh=vCXt/QjckaFJL+Z8JbjwkwgdZE82FVT1hVZjUa1McQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cMozHwNLQuQNqAYx04CCRxmLBOsoAhVvA1YYdlgQA+LHu/zSKGsQZ+TtPoWHvcmj2fu6zrwYTl0RO/C4vzU1jxVm3I5zx3qv2wmuyXNDKa0BVGyOn5PCcE6aTfoZ+PNQaCtpGB403LWx4VYcD/S/z+8zXJW9FrJfFQ4HtPKFKIo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SbVyZdRM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SbVyZdRM; arc=fail smtp.client-ip=40.107.130.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SbVyZdRM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SbVyZdRM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PkwGJSdERRw4IXDf/LLEIG270go9t7IWEy+++yBkR5GbK843NSNqjxU8faDrXObhWLG81AcWyDKxDygYHG0q9wVBsPyXj049xHxXQN6m+TRmjwyL5D/A6GFRkh3ywhZ4XTYm8gx3Q1ZKF8MIK839+rVNGLZCMlDFT4y//Z8BHnUa8uCPq/aDdJifu3Wxttc/g+6j8AIjS2HRwB4Y8RaMVOiJ7HY++3Sltb3WH92jwi4fSrnY4u9tmSEKH7nBsvq+DXP9Fp8gbh1G3PlM3H6QoYWeCo4rKBSPbPuPHNT5qXgUSRxeeaEoWFekbAhqsGqMExcYC/hIIqSbePlYyLNNWw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=tKJmPG1FriFesqf9QKGEOmeay+nVPDl7wFUOPT/svfPXaywmz41hrV9+wIamgHqEFk88Fshra7iW8N3ef7PmVyzrBC59NufYDl23F2lKyygOxU0P3+437z8WjDn5X+tuwblr6ecawPnCibcp9yxs8VnFyX2DdkTuNzP9zP69ADwAWNJrwlM8jkXBkTUxXjDjaOrUzbNZyjUhHosz11y/LP5PYeaWTxqiEU/62EUXvmgflN4ydK59yCgDIefHefsqJIpCAZ8716B7f5qcVUO8zTFcioeSOuqF8eLQBNqTot1PnIUJ/DDPxpZrrIdFmyajEU4x52supnsZLw2O1+Xe2A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=SbVyZdRMdR33uNhcjYbaf4NexUaK3E/69j6mVcv7bM1IIBSI9O/pCD6FEIAt9YJTNuHQFQM6XNmKfDA6Y+1GKhyMbbppO8NbcpIP00sm1QKtzGqRQdQGQ5h1lBYyf1U5HYr8inkd4/IWNu90RkuTT9i2O3JWpvKrs3R1ccIsecc=
Received: from AS9P250CA0006.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:532::14)
 by AS2PR08MB8406.eurprd08.prod.outlook.com (2603:10a6:20b:559::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:55:11 +0000
Received: from AMS0EPF0000019F.eurprd05.prod.outlook.com
 (2603:10a6:20b:532:cafe::38) by AS9P250CA0006.outlook.office365.com
 (2603:10a6:20b:532::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:55:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019F.mail.protection.outlook.com (10.167.16.251) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:55:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lA05nCK7Ru99xmsEHmNQf2h+3xmiZBHOmtilYEf4C2Asvkx8urJPdP8uj7s2/jQUCFTrXf4J/5iYoWQzI+x1KLkJZEaKDlQ6LSDsK1jnK29OiQs9dmHzOczicbSyVEpRfxw1XKnPTm1DUsk/Xfk0o74Y8iEi8tstiLezkNPXlFw9XD68N8iZ7fdbF7VAQ9Icku1PpPZTIYuAef6Zcbn3z3fBfPloT52g7kYcfKJK5Z62KO0Q8V+/de5lwOIA5tna5B/tmnFv6lj1uDK0zKQKdiYdKZbdsnBF2lSKVis/Q11V2mh4skzLN961547AqQ2s2rEGruu+Qiq4v5AcODPLcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=wbgeU039CBabfrtY1/5JNYc624W0G9D7wXMkHJXdFReEzFIKnLSNoVkV6MW7ye93J7nj0TGgJ05svYEdb/a/Me/CVwtND5M15nWzTnuCVm15zjd+GN/2QOOn5roNv0usrnfJowT2Ef4+4r4eQ6ThPCilpBOHHXvzJFE9pPCPeGk7+f1stBr9QNuNUTZQRahvX7hzY3Egpy1s3ci5fBr+lq2az/uc80QerAxlibqr7YD5oZYIftzmuALomskWzesTFbeXTW647gDBUipWPEQk0vMahgoWdWSkeqMpqZToGiHfGDj9GgJTyhIjKn9ELFbbedrrI0EBoIQgfhLwTi1EBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIAiGauCfgVXxwzeH+BNFflSzVipokwreHiE/f4GW50=;
 b=SbVyZdRMdR33uNhcjYbaf4NexUaK3E/69j6mVcv7bM1IIBSI9O/pCD6FEIAt9YJTNuHQFQM6XNmKfDA6Y+1GKhyMbbppO8NbcpIP00sm1QKtzGqRQdQGQ5h1lBYyf1U5HYr8inkd4/IWNu90RkuTT9i2O3JWpvKrs3R1ccIsecc=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:54:07 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:54:07 +0000
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
Subject: [PATCH v3 07/40] KVM: arm64: gic-v5: Extract host IRS caps from IRS
 config frame
Thread-Topic: [PATCH v3 07/40] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Thread-Index: AQHdCwQuiajye9GWPUGMYs27K2pxDQ==
Date: Fri, 3 Jul 2026 15:54:07 +0000
Message-ID: <20260703154811.3355680-8-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|AMS0EPF0000019F:EE_|AS2PR08MB8406:EE_
X-MS-Office365-Filtering-Correlation-Id: 44be30c4-354e-4dd4-c25e-08ded91b769a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 5FXjFbe0ZgDpmwpp0NjHrjyrJVwxg9vrWZvBqKAg77V+2HGDUIqpi/j1VyGrLBFGeffqfoaSrUqmjUarzW/nqoMEGMul3JgnmN03k5PFJ1sJ54xBlvOyZYitydaCeSe+zMzaCPHr9Jk5NZTdThdBLTMU/44rj+8/vcFm9+crIF9tWCPP/KkXdJg7+JsRh+UtNOhcWMmH0h0gATJGSJMtL6qCKncbLjN6jj6pyfgbbt+IIUduJAIvambsFlPxORTdQ3tdQmzayKZUzRHhv9xoFMTMus75D8pM5n4qTf68Q2n/NWduWTHOdOKii+y3/Ys/dl+6J/30TNUUnVVMDwTabvukXZX1r7KHIPTsyDfFtGh1BuZYxcbaquxoNKnhWXMgz7CvU9LupGcPLf2lC58b0YVDYyD3VgIoUZajAU95WENe4iA130+VtqlZzn/hjYekSeBMTixs2xQhSNjobx2G7cZw5PPT+ania+xzq7VuLTqk8LmzM3QWu8DcnfyQTvznmI/MrL8jcy4oe0C0KlyTVyP4MXAKaKcS5G+ZMuyvsD1PasvUxX7zCACUecWIg7CqbeONHmyYHU8EAARilahwACanUqLwZgj2NySaIiE7O1sxGb2vFND0YClofj8xPPDM1uLcniKbhBdy6Q4U8gJGq6FNCug7fImq0nrpaRdXRb3YJWaKBqblNDUbNFp37kE6UfbLD4XxTaQI5Ij4m1mb2ypTPC5eHh1rJIX2nCNXMzw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gxsI/ncfFURWBy8Ax33UTsVaXZHTb2j24RAKYIHoQQ254VfASEMhVelqwyzvH56IdORC7z6KtItDR8zphHD9V5BGZa9MC2labsylpzFYvFnP9b+UcRGRE3Z1dH6BxQAsMvCN4dZxux6k1rV02c1tP0iwxC0IRageph7Sh8js+hv4GD4b1dtX2vGwP8CmmwP0xjQqRvCXQTQI3MDjEmuqtnvm8vrFDkuy2l66Iw+lH2ILgNbGEItvKvsaBKZJgTBEYmQaS7ISGTv3yEgRFIUebmQXH7ESeJJ8bZ6eWh05vEQDFSqbo5UUYygE91Kd4SP7kYHw9VCzhNhaKfjVsdJ4Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f6768fa8-a8fa-4bf4-79fe-08ded91b50d3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|36860700016|376014|82310400026|23010399003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wo8OUQ44+vQs2s8DonJI67+G6+3LvCd1x4xFbn5Xew3aOjcCSG/0dOlumwqA3id3Rgr09n0itoRFLDYOsNB4BpBmdrm4i3Rj3AttxvurbkyABVhRD9n7ZaATd3fGaDQiddSRNh4nereJ1kdIOFY+0MQGPXFYr/WQUjpM0StrykoKf9Vqol01d7pPNzTurF3cgW2qoWQnvODILT40Db4e5fu0hV1zHw+wb2kJt9R1yJnFoiRUKWujrnzgNmb1cgyRdC3Y6lmin7L25TkmJa9wm9MxgjuXtpH8ykQfF4/YGH5g0A24q6aYvbgzxwNbjaTZ0GWRHX44RlZ5Kw5wmgjLTxmNLpJGZxfQIA83Lg6234BkngEiCHZcOQG/59owYnXenMmy04hw7RErO49fD/PEa3p3Hbbgd9H73WVtuRLZQ0CiOArgrGgPK82biEBvB72xsUD+E3TNriQ/vBImuDJvx1EhVrtrH9DKW9lQD+QI2e0qXD62wXf4Hg2CyOq/OqjAZWsyGO9JPo5CJSluWQG6r3rKTadU+RHQpGDGe/hXbH8p/zZdmNoJpofN9mugEOgHyQn/povPHjMRs1weH9QTn0zN6+QlUad4pPXMxg5oXK6wL2c+SFew4vlysJy3aFAQegb64jm8p5RYK0kam5SNE0SMlSJQYNw9+Zt1ebI32SpaKHJxkIYaXFSoYX3iUSAQQx4XEmcrADrHAheSycOcLQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(36860700016)(376014)(82310400026)(23010399003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KdmE2G5aYz71HR4TdxmGczNGA1AgtRYfW4BW9AAJnKhRP4LszV1Xyl7ZK8RRHCATGke5tzbNisWQxV/W0Rcma7KcZHugULXSkYmvBLMj22kp422daeWlHlcIxB+TyZFcFgkDuBmjVPRv0cmYnR6Ix/E1sDGCVQYqYwgkMmoe061t+Eiw9eDmB5ERdIpquKu5uZZ/abuKk8FGdkgt9krk5ab4iidcKtXFpER0Nw9PZ5Buz2Dplcc163FzmdCRahDrjfxP/ZwnFGtrZoiq/hxRzq4MygS0jaZSVq15BZN+EnVUYEv8yqv29rjrhY/blc1DwlcwEdYhdqe4kD9fEKX54an+pcADCRlu2agsEJG22pKiNkv5dXx2sMajAi/cYFGC0IMeVMXGaCBUp0OtNA9WtxLOC6pwK0eGpVTCiT+35/t8q6HpNWlpqlEcZZbkUvB0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:55:10.9473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44be30c4-354e-4dd4-c25e-08ded91b769a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8406

The host irqchip driver provides KVM with a pointer to an IRS's config
frame, which allows KVM to directly interact with the host's IRS. The
MMIO registers in the config frame are used to configure VMs (in
addition to them being used by the host). The IRS's config frame also
includes a set of ID registers which describe the capabilities that
the IRS has.

Stash the pointer to the config frame, and extract the VM capabilities
(from IRS_IDR3 & IRS_IDR4), as well as the IST
capabilities/requirements (IRS_IDR2) from the IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 46 +++++++++++++++++++++++++++++++++--
 include/kvm/arm_vgic.h        | 26 ++++++++++++++++++++
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d4789ff3e7402..3f7b132110114 100644
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
@@ -34,6 +35,45 @@ static void vgic_v5_get_implemented_ppis(void)
 	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
 }
=20
+static u32 irs_readl_relaxed(const u32 reg_offset)
+{
+	return readl_relaxed(irs_caps.irs_base + reg_offset);
+}
+
+static void vgic_v5_irs_extract_vm_caps(const struct gic_kvm_info *info)
+{
+	u64 idr;
+
+	irs_caps.irs_base =3D info->gicv5_irs.base;
+	irs_caps.non_coherent =3D info->gicv5_irs.non_coherent;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR2);
+
+	/* We skip the LPI field as it only applies to physical LPIs */
+	irs_caps.ist_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, idr);
+	irs_caps.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, id=
r);
+	irs_caps.ist_levels =3D (idr & GICV5_IRS_IDR2_IST_LEVELS);
+	irs_caps.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr);
+	irs_caps.istmd =3D (idr & GICV5_IRS_IDR2_ISTMD);
+	irs_caps.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, idr);
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR3);
+
+	irs_caps.max_vms =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VM_ID_BITS, idr));
+	irs_caps.two_level_vmt_support =3D (idr & GICV5_IRS_IDR3_VMT_LEVELS);
+
+	if (idr & GICV5_IRS_IDR3_VMD)
+		irs_caps.vmd_size =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, idr));
+	else
+		irs_caps.vmd_size =3D 0;
+
+	idr =3D irs_readl_relaxed(GICV5_IRS_IDR4);
+
+	irs_caps.vped_size =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, idr));
+	/* Field stores VPE_ID_BITS - 1 */
+	irs_caps.max_vpes =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, idr) + 1)=
;
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  */
@@ -61,10 +101,12 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		goto skip_v5;
 	}
=20
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
-
+	vgic_v5_irs_extract_vm_caps(info);
 	vgic_v5_get_implemented_ppis();
=20
+	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
+						  VGIC_V5_MAX_CPUS);
+
 	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
 	if (ret) {
 		kvm_err("Cannot register GICv5 KVM device.\n");
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fe49fb56dc3c9..8d65a18fefb80 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -182,6 +182,32 @@ struct vgic_global {
 	struct {
 		DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
 	} vgic_v5_ppi_caps;
+
+	/* GICv5 IRS capabilities */
+	struct {
+		/* Base address of the host IRS's CONFIG_FRAME */
+		void __iomem	*irs_base;
+
+		/* IST Caps */
+		u8		ist_id_bits;
+		bool		ist_levels;
+		u8		ist_l2sz;
+		bool		istmd;
+		u8		istmd_sz;
+
+		/* LPI only */
+		u8		min_lpi_id_bits;
+
+		/* VM Table, VPE Table */
+		bool		two_level_vmt_support;
+		u32		max_vms;
+		u32		max_vpes;
+		u16		vmd_size;
+		u16		vped_size;
+
+		/* Is the IRS coherent with us, or not? */
+		bool		non_coherent;
+	} vgic_v5_irs_caps;
 };
=20
 extern struct vgic_global kvm_vgic_global_state;
--=20
2.34.1
