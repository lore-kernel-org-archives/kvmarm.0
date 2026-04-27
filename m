Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011070.outbound.protection.outlook.com [52.101.65.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A8A3396F4
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306423; cv=fail; b=nLpwqnkmVGfJgc2kgAYFlM39htNJ/dU9/qq2hLqSvhXtm+c23mtnFEGCYel/8NyVPTmnAbcnCSivF1TV8rQaUhccSojnpP086GOTse+YJn1kR3JC+OKmpwZAeha4Cqy6pstCvg+j33H+KilfGbEjqmXmHUjQhvd+RBY12gusl2Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306423; c=relaxed/simple;
	bh=x2hGfDu3CwnlXQFgpD9AFsfI2APS7ItbAWVWJmky3F0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MNUyxygpiEgp2PyPW/1rJ+wRDKOHlQ8Zhiq0o8KYsXbbymezouTsx2RrtOy32jMOf6qVeQlbqxLyxCB/VpBdPp9Zi9ZM/BH4yxq2+4fTtOvkxKHkifwuKocHcarvLQxmKK2xwYlHKzMc5RXZOjrYeLQEog5wsRbcImZZvIEOpAE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GaFWRM4c; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GaFWRM4c; arc=fail smtp.client-ip=52.101.65.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GaFWRM4c";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GaFWRM4c"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Aqik37o8zkdhVouIs8I7xQu80PmkAfVF9IoZ3jPoIASMHAkdMkSH2OUIbUVJ9BUO+fSWLEGvh1TlEp0XztZrQLR26khw9eiy1OT8VGUZ26nTEZIFagEmb12JdV9rCKm6rbyUmp1AoZajb/Ngc3nwI4yx/aLJMgKI51u+KFhzFQim8E0UkKC5BFtievTj6a5K63qyhg12a9/Wk36A5SUG2cxR6Kr+XP9S+o37ja8gCO4inb4hpVqaPBsYbZTz6MwX2Gqqt133E3Pl6v9PmzPPv/lkkXy8EWcxAjZgCywXS6EFU5Kn3DE1JZNaQwTcPnkBY/Q/f6Gdqcs01APJlh+nPQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwtCtJ39hYHeOa/hSBjEsxgyaxvXd+fRQpiJCp+umc8=;
 b=ZbmvlxnRwysfQjtAjqJ9RQ0UjvIPLCyZ2aKfa97kP5kvDkQLmMpgPNBpMWGBbWiouXv6V3ktpzQbNSrDS8iD4hTgsqDLZ2b6EfacJmuWdmUGxyXEd0Ufk33DnGrIWtwB2/wacp6GXIq3WtK1EZCHTUKAAqfXUjS1s5Gi7zB793tOuT7WkXbOZjxV2GxpyglQamo82lc0+ey34izp4nWqWypqjX/eFD+WMzWRcd0bTyT6ZQ+PjW3dNdfYwPCGKtB+Ec0jv7zFoQd11oYvzfGgopl2mCSFTccghDMNceN5ak7CAi0l29Hshg1AeoaOazzNaOpG5TlfzXOVc9I41qF66A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwtCtJ39hYHeOa/hSBjEsxgyaxvXd+fRQpiJCp+umc8=;
 b=GaFWRM4c6wPI3sLDvtkTpFpygjasBlMv1NPw6uDhggegqXMHk1TDtllCu2nojneIbTfE/0fXjb0pvuzPbQCXM917hz/CzXPgPlge6u5eYMEjx8VgeCoVReJTvWgKvXDoOhbCh6L3GyGO4F1K5B1qvifaI2EyiG9Z04rUvKX7RDk=
Received: from AS9PR06CA0280.eurprd06.prod.outlook.com (2603:10a6:20b:45a::17)
 by GV2PR08MB11882.eurprd08.prod.outlook.com (2603:10a6:150:344::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:13:35 +0000
Received: from DB5PEPF00014B91.eurprd02.prod.outlook.com
 (2603:10a6:20b:45a:cafe::e2) by AS9PR06CA0280.outlook.office365.com
 (2603:10a6:20b:45a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:13:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B91.mail.protection.outlook.com (10.167.8.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:13:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHqHvJN7KDGQvTyOoNOGdj5TqLeSQ6+Fnz7cDEQaSy9C4k+KZLGXcq2A9LxV5vOKnEdxbmBA8PjjIbtcP6Sf1AcsGE+RmHu5RKpK1aBx/oaSRQ/qQd4/3ullxgwjnjT4dNNTHyiQaaBZOLQmjxxkNsCSQvM+7BOhK06d7KOTD2aS79PwxfcX0pL1+TAIZThF6cO5mqvn/MJjovGTg6N6TFninMTQae+wwTi4wvmSJVTPgGmD8IEWx+P8do7vMG9ertACIKOcnsl4Duk/GUQw7CewsB8q16VUanbcnIcOHY4ixw0jzofA2TAn5R3DL53l6RHhZa7XN74zmWsUAusH6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwtCtJ39hYHeOa/hSBjEsxgyaxvXd+fRQpiJCp+umc8=;
 b=e2YQ5IoS0iCyhBhzzsNxtyFu5kc9Rbei6P0ewh4vV1KPEd9PotHcZx/bc5Q4oxoHp0aBvIb+qfbssOrg4PqD6N2NyLHkwo1z2+2TCZ1rdO7v7vSwblT0PNMfgjDtKWcnzvmuX8xscgWCbn9RM+sop9Cdxgu7DSvfwQGtsqhif1WJavHIS+b4sLzJEPCvQLTceDNuJQF2+jvE/Xwl3WEBshytM0ZU+HZzmaElyHgsSoyKtpESbbMXmFa9NnZowYwYaAjtqoalonP65T4tFprOtL7dRXbva9n2iburHb4LrOoch9eoXJr/0H9o79RoZR+dogNpVaV376ecZLSg052+CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwtCtJ39hYHeOa/hSBjEsxgyaxvXd+fRQpiJCp+umc8=;
 b=GaFWRM4c6wPI3sLDvtkTpFpygjasBlMv1NPw6uDhggegqXMHk1TDtllCu2nojneIbTfE/0fXjb0pvuzPbQCXM917hz/CzXPgPlge6u5eYMEjx8VgeCoVReJTvWgKvXDoOhbCh6L3GyGO4F1K5B1qvifaI2EyiG9Z04rUvKX7RDk=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:12:32 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:12:32 +0000
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
Subject: [PATCH 19/43] KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and
 IRS base address
Thread-Topic: [PATCH 19/43] KVM: arm64: gic-v5: Introduce struct vgic_v5_irs
 and IRS base address
Thread-Index: AQHc1mCmyFg3B/LM40OMPIspO9GUSg==
Date: Mon, 27 Apr 2026 16:12:31 +0000
Message-ID: <20260427160547.3129448-20-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|DB5PEPF00014B91:EE_|GV2PR08MB11882:EE_
X-MS-Office365-Filtering-Correlation-Id: 381e55cc-fb2c-4118-36da-08dea477eece
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 01Zr2i/L4HJ3g2K9XVTJJakvx5DDwb2HIF0H2Er/92iR9IRoOT/N1FJCt8wPitpIPdc7T1c0GHuf6iSIB3CChIsdz054kqmxhDO3F4gILO5ZghBF+2MicVKElGO2xXLAlckpSs2QKSCndVEbm39AfRir0+MHpY5qqq448FCvXD2euw3G5qEBejM/2C45337z7aWUnGKExDdeqfTGmnhloj7MMkgQIDvwd66rRp2QGUYqJks59ChR5KRHwWEsFWIb+IiuxNQ+U2U8pqEe48R6EDn7R/IJy/ER+SijX6qJpRgJqh1lUGYUlheS6nLFdMAyFImSLZCtIaUWMpoEWytwjJPyl66LQowZrqp82Uhc/xLpR1xCE/DsQka26X2LCoYoygS8DT0TLotDZKeZSGsZpSAA3kIiYFZzyOPMIUFvLVjajfuC+5xaXqUpM3s3v2RCzHqeX3W1G4XFE7IgLQtGjPk1BFgA80dqO560kIikalwFBMdeVrdiT4urJt1Y17MVDN8JSyrIFIbo+fpowdh6w6d7ovq7mzdFPgXAquglFEzbG7Cx2wgYYOfVYeDlxSDrVKyg7/8U8tHrgLcrtMXn4FyCVj0kuppDMKsQd7GHqS5Lu0EB0qj50bCttCgoXzmWINukWaHj/yyvd/zbZb5PlmUE9nz0OUuRRUV5/oVgnYZ8qQ3HnpsH9XZ+qIJ2U4pT7t6Zc9G4WZMHoltAp2JB/JO4klQmAbyddow6NwxwygoaYUcdJTx8QisqfrYtk6vM38/wZqAr4tzwp0K+4+9yCskr1wlLgzE/I4kqUEwH7vI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gHHnzCF/uYzYN7G7xIgeZBVuId4ZQznvNm0HZdZawAyB3GxeCt8t8F2ZQnDHWr2sUrw0a6rIXYjGj6B4Q3E6yzxCjG3pN2md9SWzob03m+X4pUIrehEf+LX9Hq2zNURqGoRBSovj37xFaKEFLRHQ2Je2siKI9KCpSgTMO5MYI4l8Sm2a/VXDtlExFRy5i9CUeR009nLbwPjrlIaSBfePVKUyNtAk3veooPU3Z23mQqb7raAjrf8xU+p1XJRbQB0vzrJGzbVsJfBvdEDk1X8r/Sfhzx2BXn/8CTjYCR2f6yvg+gtFEv5SiwRv0/ragBIdBj7ky9kpwTzUvJA9jgCPAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c787fc01-57c0-4e22-6eec-08dea477c960
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|82310400026|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FfuMVjg03OAN5CPcHE4rp8d2ZaUozAAW8Xpv4Yvt/UMBFB/Xesxw6WPXFwTY8IJeYZ+Z6I05DnjKB0YyQKzwQoU/cr+M0RG0FWENSZAuc3YZh/xjpRxn6LYXmdSiB06t1H7bmQC1mB2/f1Wo5ZPdZxDBRPZuy06vs37gQIujMAe8+bf7aatlNzTnn4mElKk1j3LcA1+XCaDHB62M+hwhu9KF8GJC+PPGxbQ0BVDgLl746hQwgMPqUjTCOPV8Z4mR5A/RFOGjM7XfjnBiOl6X4ZRYlKsq3D7oyL72dnTm9x5IO6dN5d2wq9wUkzMU9xpyW9eYiwEzhhVpwdjv5zdrnmM2kLoNvZwN2Oy7TjufI6W06Ixtx3Z4dXkyNbJtpHvV/aN7FCoPl1GmxfE6yBX44wKQqYFUu3xA+8+ml+MAtkMRGV5IL0Ps0rtpTtvHeibBBg64cmr4xlzc884Bg2GknBdyY2MDOaUDEEImJZ33ks7V3wTTcEJuFr8NFkM8S2unCxM1/DgiukNzls1QyCiIBvH+JF/wa29N0WdEgOp/bYlUTSxkQNwVY/0Lfc9UOx4VDAwbe/aaZQrWcXpDQ9yBSYxn/Dl/UPf7SYqX7d4khiDQwWDi0YOFOVwFKDoFa+ArhvHKdUtG0k05AiXUpexcx+YsfOjrzRLnf9cUdx0/+RuwP88hDwM2zB7GjgLCWhNxBtI2/TyaXUmmqbo2zWM53r4P16U91cWLg5I9JM/4Uw2zI7qEvbV+htHEyG2CXn7JzZypsln2t3oaAPTmVBvbRw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(82310400026)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	07Z5+RCmYA8E/t7fF4VcTy3CGpWzLM6BHEYvjaGVF287OJ4h2IiirGaZ7+r8IyebYaAeKjxAT//PM8EDYu5oexq8yBkCncwQPxxewasRuSDsksTPsY94Wbq68gFjdv4yQr+/0D31U23+dk0N6KuXTdkqX4DdtGq6690l0OGE5D7Ptkdm2sRsGjDgB5LZ2ko54LL5DIccM0OFPu3n2qKbGaYX8KnmA/d6Ul+x1otP957xgVD3vMgBkmYku7Iskhnm07OeHd3Ehi71/Bn+e73+keajwI5WkQ/RARBFXmWHS9R1cGfmIh4I9LJs3dYBHd+VQ3S3+sS9v7psINXhiTMeavBoMoE8gZEtFY11jeEYypNahjA0vbNO5Vd++/ZPDm/OKnjkLQkKYSx3ibK9HBDFSZ5MAwKxakNt7UkbzLHpBcWf5JDIyUkMlmISRCWSE/8G
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:13:34.6764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 381e55cc-fb2c-4118-36da-08dea477eece
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11882

In order to properly emulate the operation of the IRS from KVM, we
require storage for the MMIO register state. This change introduces
struct vgic_v5_irs, and adds a pointer to it to the struct vgic_dist.

This new data structure contains the storage for IRS MMIO state that
is required for emulating the MMIO interface in KVM. This provides
persistent storage, and a way to track data across MMIO writes, e.g.,
selecting an SPI and updating the configuration of it is two MMIO
writes.

Note that only a pointer to the data structure is added to struct
vgic_dist as this new structure is very large, and hence it makes
sense to dynamically allocate it and just provide a pointer to
retrieve it in struct vgic_dist.

In addition to adding a structure to store the MMIO state for the IRS,
we add the base address in GPA space to struct vgic_dist.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/kvm/arm_vgic.h | 89 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 0bcbc751593cc..d8f416f1f46a1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -376,6 +376,90 @@ struct vgic_v5_vm {
 	bool			vmte_allocated;
 };
=20
+/*** GICv5 ***/
+struct vgic_v5_irs {
+	/* base addresses in guest physical address space: */
+	gpa_t vgic_v5_irs_base;
+
+	bool enabled;
+	struct vgic_io_device iodev;
+	struct kvm_device *dev;
+
+	/* IRS state - used for registers etc */
+	struct irs_idr0 {
+		u8 domain;
+		u8 pa_range;
+		bool virt;
+		bool one_of_n;
+		bool virt_one_of_n;
+		bool setlpi;
+		bool mec;
+		bool mpam;
+		bool swe;
+		u16 irs_id;
+	} idr0;
+
+	struct irs_idr1 {
+		/* num_pes is populated from online_vcpus at runtime */
+		u8 priority_bits;
+	} idr1;
+
+	struct irs_idr2 {
+		u8 id_bits;
+		u8 min_lpi_id_bits;
+		bool ist_levels;
+		u8 ist_l2sz;
+		bool istmd;
+		u8 istmd_sz;
+	} idr2;
+
+	struct irs_idr5 {
+		u32 spi_range;
+	} idr5;
+
+	struct irs_idr6 {
+		u32 spi_irs_range;
+	} idr6;
+
+	struct irs_idr7 {
+		u32 spi_base;
+	} idr7;
+
+	struct irs_cr1 {
+		u8 sh;
+		u8 oc;
+		u8 ic;
+		bool ist_ra;
+		bool ist_wa;
+		bool vmt_ra;
+		bool vpet_ra;
+		bool vmd_ra;
+		bool vmd_wa;
+		bool vped_ra;
+		bool vped_wa;
+	} cr1;
+
+	struct irs_spi_selr {
+		u32 id;
+	} spi_selr;
+
+	struct irs_pe_selr {
+		u32 iaffid;
+	} pe_selr;
+
+	struct irs_ist_cfgr {
+		u8 lpi_id_bits;
+		u8 l2sz;
+		u8 istsz;
+		bool structure;
+	} ist_cfgr;
+
+	struct irs_ist_baser {
+		bool valid;
+		u64 addr;
+	} ist_baser;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -453,6 +537,11 @@ struct vgic_dist {
 	 * GICv5 per-VM data.
 	 */
 	struct vgic_v5_vm	gicv5_vm;
+
+	/*
+	 * GICv5 IRS data. Dynamically allocated due to the size.
+	 */
+	struct vgic_v5_irs	*vgic_v5_irs_data;
 };
=20
 struct vgic_v2_cpu_if {
--=20
2.34.1
