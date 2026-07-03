Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011003.outbound.protection.outlook.com [40.107.130.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B0C2C0F81
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093997; cv=fail; b=U2MAPW0egoJfOrY4p+xQG4D5LbzViycH3vUZq+2W0vcKLCiNI3ancKl33Ptekt5NDu649kqgFewp6gBHuPcoD325iO8hJYH9AN3S/0mdzFTMxysb6SrBr1NDZHCcc6Sh+tESTUe3QrJZKCXJM8Y4F6fmu4NwAuQOxPgLmfQGvZk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093997; c=relaxed/simple;
	bh=9yIjGQ346hbrDyI4HC81vnC72QMLrjpy3krcB0NkgMs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ejEdtE9f6/z/vAbHHteGmCy9P35s9oup++GFMH/0LoJXOaxaIeQuYTsnUJIwuUuLXBXJIFlhRRQlz17pYNmasyBEUJyup3D8EN66KA8v5JzC8z/+SGSxar0XI7DJ1o3Q7GeY6d1WhiXvzsXs9IVLt4S+2fGlaA6eSeauXuY8vbk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZUvNbjlu; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZUvNbjlu; arc=fail smtp.client-ip=40.107.130.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZUvNbjlu";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZUvNbjlu"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=l6j8AALYmilA3+C1tM7pac5pTnT5lziYJYmOyOoo2M8UcE57Fw2rqAxv4y7tZhAJWylXeMOzsvQXLMepO/ToC5Vse2vgsuscNwVqez7F8zT5ZrBmYBxhQEJ8zRG8ysH6N9C/qR/p6/kLt67uNHnY7nudLtcmNpZ+gk1vawGpd/pVrsmTXFcE2IkwVdlZ3Ls6DyQQhjMB0k5KdvqTKoiwt5MGZhU5o55f3aDWNiM1LcWjgAss4b2g3IYZbKkvBdJ1N3JCH1fORrq4636ARWsoaPq0KSb19KosSa8aOb8dNPwv0ow9LmwrdH64rFcJdTXFWQWjiJbD/MthRduLVnvFOQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=LBHLgK+wLiazyrtKBQNpkPlltnWW1Ov4ZL2t+qITKOPVHot6a0BQPmSjRhkdJUUvvjV9ewaxmQ79UUG4+UGNPh+PdLCIQV5fqxA3rjKONb3m8y1StZIsrnc1fuIQmcumvnPnBDmR6C18djwh967G/hh9AB+HVGeP62MiHFVhet0j6ZZcyuQQa4fax5dQYQFgCGFZv79tGnJXRHYK2w/v7EBCsY+h5BlEdOXTwrQQcjiNFruDK4I/qHwpz+yTEcWkjbLL9sa6HzB2YsJ9aAoTPCBsbchtr6F9ubcyI0HWvlYxPSV09xf9+IQLvGHcMzFAKnsH1ZCjB3Y4+tnS8QOpzQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=ZUvNbjlutwWd2bEY3zoniHdfvAOkE0XBLMPCAqg1Ymr7NszCsKhi11yTjYwVKtv42xfxjEkggaPCbPskPcS/7I6kZsHBwk4KRTOxA4x1kT2YW46XGss2tPmIKDUPQ2GAmxtfdNUPGGI7mGa9RHmA6+9nnxI8fVoFQeeadQPqngY=
Received: from AM0PR10CA0004.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::14)
 by DB4PR08MB8125.eurprd08.prod.outlook.com (2603:10a6:10:384::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 15:53:11 +0000
Received: from AMS0EPF00000198.eurprd05.prod.outlook.com
 (2603:10a6:208:17c:cafe::2b) by AM0PR10CA0004.outlook.office365.com
 (2603:10a6:208:17c::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:53:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000198.mail.protection.outlook.com (10.167.16.244) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:53:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pVy+fO9n2J4WK3kTUbliUjpxPc5F44YwszNrxNSAHXwRd1hNA//SN1Al10rAHJ/QbyWa4XmHuZHayVA9Ux/BXQnw3omlkiYbPNx6y3HgaXsRfxZfl2At27eu0DfqdpNfwk3dtMUOOF8D8KObVs1ivkRp8Q39sqtKLPBE70/olYC6dJDY1/I5+5J07rJN6ak6Ft3Bpy+hAe0Z0XBAgLnPnJniPMtecL/dJ8KBlLUzk0Z+CMQ15oB2HHKFLJamD97uKwBMLSce5MW71p30MnojA8lI5tzHxHT0PXaHedEVX28gJtXR2ZK3D1sYyHqdtn32dKuPceHFHUaRbqqE974RCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=G3jbKLM3uXLtyBQX+JHurg7pVfLNQ8RLiqKO+/U0My+UrgTmjcQFNnkG/zVooJ9iAYdwEJe/NiGEz89UaUPMmjUJ8oB1sAp1/nBY+A02kFlcsnzrWNZxC89dm2V0vf/hWQR2PdWGltXQj+pqUZ+E8SJbofkq0gNw3Ow7F5L3Lu0MOffeC4gMzL0tOguJofWDpp7dNQVezW2PTsTBZlmTg9cMc55N/Hxp4TJr7vlChTtouMFQwH5LGDqgaXbvQT+OaMXovYr9q0HIRLYQSzLYAc0NLY3SOUhnbuSa+DoxU65jKS0LGbM0mlrODGdSjNn7HbvdP4L+DZT2ndnDJJ17uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxhdDegUSmw1z13pXcAvSedhwEEu7+p2rpwzEdS1pE0=;
 b=ZUvNbjlutwWd2bEY3zoniHdfvAOkE0XBLMPCAqg1Ymr7NszCsKhi11yTjYwVKtv42xfxjEkggaPCbPskPcS/7I6kZsHBwk4KRTOxA4x1kT2YW46XGss2tPmIKDUPQ2GAmxtfdNUPGGI7mGa9RHmA6+9nnxI8fVoFQeeadQPqngY=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:52:05 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:52:05 +0000
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
Subject: [PATCH v3 03/40] irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
Thread-Topic: [PATCH v3 03/40] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdCwPlDE8YZUL+N0Oy+Ih6l8Wdjg==
Date: Fri, 3 Jul 2026 15:52:05 +0000
Message-ID: <20260703154811.3355680-4-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|AMS0EPF00000198:EE_|DB4PR08MB8125:EE_
X-MS-Office365-Filtering-Correlation-Id: 57371768-383b-4df9-934a-08ded91b2efa
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|3023799007|56012099006|5023799004|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 uX9sYC3UcAPSluEf28XLPumuZkhs4Pd56ySM1xmL/IoFuEaqTBwElB3qKRF28HpHNLcMb4icQOwIxJ/voEIIjv/ro3IY65ScDi3TdGGxqiqcoiZq+ZDCgizLEOrGY+JYi8xygKLFayrprtoS5+hl8mlikqkcFMprG6xUIB+ARxk3QBt9y68ZxcrhGAvTsfkBL/rjyDPE41jkyQmbGEczsHMC4owOfYFcjAO5kX5184S879h6KrAZ7JHI570E5402ko7XXVZXsxK7+8d6QsuQujvQhunokNFpUXTEmQbpzzV1iB4ijoitN9nxl0y0Q6SquNYaU25Mld+1dl6ZsP5SZDVW1PC4F4q+V3tu+fZ8ylP7jxuine42MhsVpbMl9UZJoi7sNc839f/as6s4mzWyYM4ziR05uPG2+1ckq5xgCXwzbcqeJ5P+0Rg9RAiDhXStscpzkx63GDdb+G4yMfeTXmqUfkCe1RRQYSnNfVoPtBVUw9speRw4Z0HJI09Y5BG2xlQVuzSE6YqtZARQRKBDTj0LpzuYeEn6NdI9N8egIz72lD7C6EHY41GoeWgIiWLxfppE6tlt+3NGWwB4dugl0pT7ni9Mip1oFk+9NyrZuL3i2z9CZ23kLOuP2/VpbIbv1U3rxeTXmA5mFnijW5aEz7IrJ0JyfG9L4FNEmMf+CxqsNOfHGjPDmZAfx9VB9FWt1iejpVDT5f8qaECVabXlz2H9RMnNKqakRGK2+g/fsmo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(3023799007)(56012099006)(5023799004)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Hp0f1Fgu6E4racGnfLTALWTEtKkGdysb4w3rF7eio7Dvc8EluURw6DyvEWrdIMse+yEhnUESDdjYdoRXUVDbj97aRwtX83K3k+AaP+Xf0g4rlvOYinrS4Ee2quxSYklKziiyiWePT0CYNwaAc8N4Y6eLltEAzRzohDNYp1RfvgHg3Zj4FIdrHIBp1bwUS0edFEgMlXDH1xsIfPtiHJCJlqi3uXlNYo4vwuVpUDbT3VGiJJegoQQgGrt6C3y0fYRaypn1QEC+V278v3c3jsdNTRX75CqUHydJLTUJRMwCyvIYYQy6FypG/WbQunni0zxsSshYj09qPfMlk9G81HcROA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c1d03360-5fc1-4f6a-7f22-08ded91b082a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|376014|23010399003|36860700016|82310400026|22082099003|18002099003|3023799007|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	NtxWsjNk8WmZz/w4UQ57vMImPlAGrhZdsyXqWn0mZMiqxszz+y+Fo5lntLEM2mTdLJ//iIaV4FrZ1zrIhnnBTA9sZ/6p31+6ZW9jKbC50kARmvOoQEuboX4IKQP7+KfFR+C+9l4bMFTssagPXY4G5p+hWjhCXJzMME7feN3v3WBHnefleP3RYhiJd5YxLQ9ynOOG/J+mhfgvDozkKRNR0vrgQv8nB5afgUpPe9K6rJ7kOkO7GpUqm1etyDY5JwubVzqmzfT13C1xDD6H7fEQWt209R9I4D7T+MrOgJNp/2HEEqdGb287of3GXDgntHDDcsIpA9F68i+VJ56wRm7J0K3SbmM+k96DXHDfI/izzokYurOwrUrb6LmiU2m5ncADVk+H5pRIx+aaIs7ahitYHr0P+ScmGrADaHo/y2Iyg8+gWURTwHpe3QsDTCTknRonMb720Qc5oOCXgXIJm0Sv94jy0hcEM/h36y6a9NOVrBOp6oudSMVXCMAzQWtTUt2dVpwXs6O8lKPcgsbS1TON8KqzzCg3q0hB5yJpHo+rMnS1/q6+eGrMT3WZ1s1S5oKcKdBHhmI4X3sj/ZByqESvJiNNkNTk0Gah8sZ8q51eEvrffBhs0ZeCdmwYN8RK7zcgfTjvp+RVfplzVwkcEKrKdb81gYjE6jAWnMtmHnJLgeJhdpomulOgsQdVLXNpMHxsx4/49PijOq74jVdgzfvL1w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(376014)(23010399003)(36860700016)(82310400026)(22082099003)(18002099003)(3023799007)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/jccixbP4BoMUbl0yQve2+7Mk2FiemEXHBNax7SixQ6E7tCPkW9BtsXTo8l/JFoMw6bT6WxG1ZDSQiREaAZLg1fV2491POdDw2tFaMWleNB2nA/9Jfmkx5fLG1tvV2h8SfZWi3dkpHBE42xTQlwa0PxrQsQfLyNXvl7Y0pZwrbJg7toJ7ou0+ZcLSZ7s9IoH2avZwA8gOYz6MkxJUh6sW0EXOJbSTGNcrMoy5V8BVl4I5gar06RfQCWLohlR3kzuOUBy18hGRQwgDxr4l5Rda1+BU1IMs3xqn2/djzGTLI3+I7go9vt9vdGxXOtlVO8XW7fiJRtBVMxrTUvSrXQ7ayxcS3DYVJGf9+jmh9sRFZ9Gt9a8iURt+DrDTMc3jnXB/Jn/NC2oQPiiaqI1WiYog2gRR8e5pq+16WYFM1sfYerDviINTaO7/fu3wM0CRawH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:53:10.7660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57371768-383b-4df9-934a-08ded91b2efa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8125

Device-tree based GICv5 probing already passes the IRS details and
maintenance interrupt to KVM, but the ACPI path only initialises the
irqchip and installs the ACPI IRQ model. As a result, KVM never sees
the GICv5 host information required to probe the vGIC on ACPI systems.

Add the ACPI equivalent of the DT KVM setup. Parse the MADT GICC
entries for the maintenance interrupt, require all relevant entries to
agree, register the interrupt as a GICv5 PPI-encoded GSI, and pass the
resulting IRQ together with the IRS base and coherency information to
KVM. Native GICv5 does not require a maintenance interrupt unless the
legacy GICv3-compatible CPU interface is present, so preserve the
existing no-maintenance-IRQ handling for that case.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 100 +++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e7a7aedcfaf78..0d90675fb319b 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1126,7 +1126,7 @@ static void gicv5_set_cpuif_idbits(void)
 #ifdef CONFIG_KVM
 static struct gic_kvm_info gic_v5_kvm_info __initdata;
=20
-static void __init gic_of_setup_kvm_info(struct device_node *node)
+static void __init gic_setup_kvm_info(unsigned int maint_irq)
 {
 	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
=20
@@ -1137,17 +1137,19 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	 */
 	if (!gicv5_global_data.virt_capable) {
 		pr_info("GIC implementation is not virtualization capable\n");
-		return;
+		goto out_dispose_maint_irq;
 	}
=20
-	gic_v5_kvm_info.type =3D GIC_V5;
+	if (WARN_ON(!irs_data))
+		goto out_dispose_maint_irq;
=20
+	gic_v5_kvm_info.type =3D GIC_V5;
 	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
 	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
-	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
+	gic_v5_kvm_info.maint_irq =3D maint_irq;
=20
 	/*
 	 * We require an MI if we have legacy support, but don't, otherwise.
@@ -1162,11 +1164,100 @@ static void __init gic_of_setup_kvm_info(struct de=
vice_node *node)
 		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
+	return;
+
+out_dispose_maint_irq:
+	irq_dispose_mapping(maint_irq);
+}
+
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	/* GIC Virtual CPU interface maintenance interrupt */
+	gic_setup_kvm_info(irq_of_parse_and_map(node, 0));
+}
+
+#ifdef CONFIG_ACPI
+struct gicv5_acpi_kvm_info {
+	u32 maint_irq;
+	int maint_irq_mode;
+};
+
+static struct gicv5_acpi_kvm_info acpi_v5_kvm_info __initdata;
+
+static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_header=
s *header,
+						const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *gicc =3D
+		(struct acpi_madt_generic_interrupt *)header;
+	static int first_madt =3D true;
+	int maint_irq_mode;
+
+	if (!(gicc->flags &
+	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
+		return 0;
+
+	maint_irq_mode =3D (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+			 ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+
+	if (first_madt) {
+		first_madt =3D false;
+
+		acpi_v5_kvm_info.maint_irq =3D gicc->vgic_interrupt;
+		acpi_v5_kvm_info.maint_irq_mode =3D maint_irq_mode;
+		return 0;
+	}
+
+	/* The maintenance interrupt must be the same for every GICC entry. */
+	if (acpi_v5_kvm_info.maint_irq !=3D gicc->vgic_interrupt ||
+	    acpi_v5_kvm_info.maint_irq_mode !=3D maint_irq_mode)
+		return -EINVAL;
+
+	return 0;
+}
+
+static bool __init gic_acpi_collect_virt_info(void)
+{
+	int count;
+
+	count =3D acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				      gic_acpi_parse_virt_madt_gicc, 0);
+
+	return count > 0;
+}
+
+static void __init gic_acpi_setup_kvm_info(void)
+{
+	unsigned int maint_irq =3D 0;
+	int irq;
+
+	if (!gic_acpi_collect_virt_info()) {
+		pr_warn("Unable to get hardware information used for virtualization\n");
+		return;
+	}
+
+	if (acpi_v5_kvm_info.maint_irq) {
+		irq =3D acpi_register_gsi(NULL, acpi_v5_kvm_info.maint_irq,
+					acpi_v5_kvm_info.maint_irq_mode,
+					ACPI_ACTIVE_HIGH);
+		if (irq > 0)
+			maint_irq =3D irq;
+		else
+			pr_warn("Failed to register GSI for GICv5 maintenance IRQ\n");
+	}
+
+	gic_setup_kvm_info(maint_irq);
 }
+#endif
 #else
 static inline void __init gic_of_setup_kvm_info(struct device_node *node)
 {
 }
+
+#ifdef CONFIG_ACPI
+static inline void __init gic_acpi_setup_kvm_info(void)
+{
+}
+#endif
 #endif // CONFIG_KVM
=20
 static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
@@ -1265,6 +1356,7 @@ static int __init gic_acpi_init(union acpi_subtable_h=
eaders *header, const unsig
 		goto out_irs;
=20
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC_V5, gic_v5_get_gsi_domain_id);
+	gic_acpi_setup_kvm_info();
=20
 	return 0;
=20
--=20
2.34.1
