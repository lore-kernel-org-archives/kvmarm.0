Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013003.outbound.protection.outlook.com [40.107.159.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737B9472F6A
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522160; cv=fail; b=O/YWj/Pr9ePiPRFIRczTelgnziDAVjPx1ID3imrbIf6W1liVInYhQpenbAr+WXHzEnKdUZ3enkotr8Tlf2EdUjZcUeaY9nfeXxWWjmiCuaczfEcKKTWx4Gzw6/tDekSR3VKR12vlcfzwvtnhFBMylyNeY+hjJwlM5pW/x3inJQk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522160; c=relaxed/simple;
	bh=J0ewR66rJpdGC3+C/ixptf0Oypc457QK/Ip6L7wmWIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nJz1jGPKw5LxFWtZev+fqjGD937n5Vmkx0LyJ88S4xcqYGwYnBUdKshi3RhZvQ63gKUUkgM7UJ2kyIlR+1kRn6s+JV6ngzEiE6ESyyeSvmI5N125c1jEipMXZWvyQAybGz759GdbFJ8OxfGQxuAJhmWrjS9O/ExzIjlpwNJyLlg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z8DIg5IW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z8DIg5IW; arc=fail smtp.client-ip=40.107.159.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z8DIg5IW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z8DIg5IW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sSw0DHZlJqNf3OVcqyK9VNGhdZywGxeHt16dwD6dbUWgGJNpgveX7N63CKDRV2YXXd9JJPUhW/iuPTq3WDoo3HVZ3YJzgZQ/nVJQkzD98vTAo17wh7GrQiHpnPRG6qHQtiwZvaAmWH/OWZHzCkWiztt0s8FU5yq6JMQ8DXPQJasW9Alw0FLLdkwlKKIfdtR+yLR6ZLvs5bziRdDQy6WHBYBEc22i/1H+6uYoL9AXBckYaqQqdh7zKw6BD+hcVoJOJapYKAJh6mxNgVpOc8Ejfl452+5qUksuPqGrmmw3B2iIVbXKUWJt7q2uvsKLI2E7U1zRwYC20Oi28D89ntGo5g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YFhqOjU7G6ZlD9/CD2c9W6+LhYkCvxAWgSioIMmAYY=;
 b=r2Hct2aLaYAWbnnaCxpdC9bOsZ6ch2Ngpy8aoo4at33J5FX6rrEfoZOeA+qi+6d41pmgdYpyflQeJncb0WkpKssrKTgjtQBV5kDebYAPNx9+fa44KpuMPbgKY7SKufAOiVe95mWA+u7WItCV4tIYMxvRym2nAHQXvMYsuRcOu5e7782XaIKYjaNDT9PAEofA6BFV75SWsLBAGS1w4LyGKQsS1MGjuscyNvTde36iFPoySdkZL2hx8Vyj6vvzHVayJtHP8Q5p0kpLnYhcnh4q9tXgXFOzR+611UTlZ+GouOr8eE3QjaX+T0X3CseoXcXKws1EG92d4sNlMSc5zlBNQw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YFhqOjU7G6ZlD9/CD2c9W6+LhYkCvxAWgSioIMmAYY=;
 b=Z8DIg5IWYFERU33SFrcZBctZAFItefpXW3lUznm+BWG+jENH2fnGzim03px505EuH/HiTVsK5l5gR8Z7pPKkZfUOrzmnuFvnJxRX67Fx6euxGK9C7xh59RZ+wuAuC1drjxpEHtP1Ex6kfa1DmEnYalAf9uT+DwYj4GTcuFFrHWI=
Received: from DUZPR01CA0149.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::25) by PR3PR08MB5754.eurprd08.prod.outlook.com
 (2603:10a6:102:91::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:42:27 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::25) by DUZPR01CA0149.outlook.office365.com
 (2603:10a6:10:4bd::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:42:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:42:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4EYUpVEXMRU8HKMU/A+xEpp1ZF9K2MHqA3g1oThLeq/T0yvyKWq+u0yC6ykAo7Ey6h/oHQQndlGlAFcXFobYNiWcGtAzHQzO+wwR4kbCEeCab0SEGsuINqfnJFWy/qoUeATDGT35k3EC4rt1V3rKMwr5u5lHIKGVaSffP1PQhINvCEV20OIa9SrPgKPdaAPuciYZ20SwmmB1k5PbUle6T3u9b0R62E5iWr20l0S3HstxRduZEJgG8qKuoHKofRsMoUtNzo6sfeIS1vf4P8XtmF3wN8m8x9m43+EdaVZw8NVMRkO9XzIZue11msuB29AtF5zc7jNFU1EZ5r0P8msyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YFhqOjU7G6ZlD9/CD2c9W6+LhYkCvxAWgSioIMmAYY=;
 b=KIulO5sOPE3T6lei1Z/ZCGNhSLqItNT1vDcFv2d8NIZ8IfhHtMxJ/xQeaJVr+Es9+olQokoUFlYGa6yGPPs+KZ1OnudDYY3zB7ow6WUK/BfQzoYiX9XgJyF3yFuIhs2UE7zWGVL6WjKpbItrimEvjfdEHusoeak2Dihgr7D/UbE7oXqmRVFLP81T6WtkoVn1c+O9D3i3HEHJOCCw60lE0JjNoedfzKE/YHQ+LfpWAFDFjng9deXxQA6CYEbN1xo4TrIM2GPXkYltUyyPSqzikByOdTCZhFhZs38mHbbpqQ8yD32c8M9f1DGdV6TbB75P0PptQpV97I7ZRvY1PkgM3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YFhqOjU7G6ZlD9/CD2c9W6+LhYkCvxAWgSioIMmAYY=;
 b=Z8DIg5IWYFERU33SFrcZBctZAFItefpXW3lUznm+BWG+jENH2fnGzim03px505EuH/HiTVsK5l5gR8Z7pPKkZfUOrzmnuFvnJxRX67Fx6euxGK9C7xh59RZ+wuAuC1drjxpEHtP1Ex6kfa1DmEnYalAf9uT+DwYj4GTcuFFrHWI=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:41:54 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:41:54 +0000
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
Subject: [PATCH v6 15/49] KVM: arm64: gic-v5: Add resident/non-resident hyp
 calls
Thread-Topic: [PATCH v6 15/49] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Index: AQHdPGJhPqHwhHpo1Em2ZdhXJibSng==
Date: Fri, 4 Sep 2026 11:41:53 +0000
Message-ID: <20260904113404.4051341-16-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|DU2PEPF00028D01:EE_|PR3PR08MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: daeff0f7-8c4a-499e-3b9b-08df0a799857
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10067099003|11063799006|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 UVX+S/n0WMdsm+E/8llX9vQJw2ZkhMfuNPRofyri7HTlt2nB9EHeCMX/V3HUriso3/eF6a+9xrXbv6rDAuh/hX7xkz68rocf94yb3EzITWBdNOSyy9aK+RaroBi69FFyIWecs5CPDHRrN4FPUehrQS5/oHvER22OmJV93nLgpmZN1+7jQeTWFrmAgANVwhS6TBnivjtNFaKM3rkciX+ZG+1SdWJ5YHtKSVKWtgasWRa6Tg1crT0K7H2wZnlpCxPbFUPzIP19izKXvrZAfIDO7+NN4r4c3hUvpuLsi4Vcbl82JGFfML/A/n3dJSzizZkeixWYgavSJoYv3kyRVTkswqm2LXyI0KBV6Xj7j16nibh/rd3Vc2dQCwnJOmhIQnMSJbtD19S5AsNE5y5qm/0q4Uwj3affca/cqTyVlGM2XcZ/yKXNixatjnCZdUbKLPxbB+UJ7BClr7DmDPVQdjCcFqlIKxIktHxx7lcD+dm80c/x7/oFECkEFbmVOTpPAPBFJofdOIJYYB4vnm+ZT7e0vqhGtVKn8pfg649nvv9N+uARGeJSJjGe6BmrBe0UP/mQni7iC2wyFg6BjdBj3ZW1Q7YMqsoyVEOls/X01ELYFKb+jzCNVE3RP7kumCpYgSU7cjRuFnbWKSfL+C8JQwfQTAyr6wqglym2StlRWBvt9NfDr9LrrqEoiP9reMgj0fIWwfEJb38ijoYE9Lf9VWoNnaFh97Iuw+0BUT1KvxFx8yg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10067099003)(11063799006)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 asv2/oyMjxx73k3/fLoODC0eqP4fOznFPDWBfAQFUBtKwr+Wy2QQZE2SoVlmf4AIbG9dg5AHmoLAWkjOBXs8xHUNpbPjtSTlvMhfKaUMBDoFwB5B3Gk5uQ5GLqmlydaToKO27Q0H4/FzICtiHd1Jqaek0fuAbOL5ayiNDuURBteDiCtNH8DC+vRZ8FhUGGVFUMxtjbxb6BSE2ivNAQhSSq9Qu704GebyPJcl9YfRkEibkpt4xeqgQPSwWfnd2Pnvr74j8npz4b8hPEN5frgI7N/+JCaL7qgKKNRErl55Zs4TuvI6Do7IDmfd12Bc776yeUC1bXdz/eNhfKXh35XAjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f2823d0f-dab5-42aa-b1af-08df0a798485
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|14060799003|1800799024|35042699022|23010399003|376014|18002099003|22082099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	qa7GyKQed3RlXtpB2lpbD6t4+mPwnF96XvMWYZBChznP6mQr+VER2nqLjN9UaY935geBo9X8f0dKZeqgV17w8G9u0Np17x9EIIir472uGxzEKJ8nnffbnLVYTbdynHnMsXipBDyehRJYCBxHERF9bS/jtL5+ZMZRySuiA7VKOnmq2le9Ms9DFcsAB5ap67ZAvHLTRl7hsQgw8XZbpK/TpOdnlKNSEuBf2lOlezpq3EYj7p8mQcrJYImsDibRQhuwoaBBl84vSc1WRA4uiGMb2gZBKwSdolGkppfIdZJQIbhq8hk8inN2Yo0gUjaG625zjFaN8osh2/t1n+pc4X934bkwA31EMW70YJa6FXEAiMgSLpa3kNx8RcE+sizd78lCwFU3ssZTkgE8iInZ0AFe5iTvXbSpD/ZL1H30LgEURkUDW7su85DYQ6Q+6Mmo4EbZ7eKJTstR9bcnLpA4eIvMw4n55I94VwzwvjOp1B0xsASQIqCUaft0y2VrrUaBgDn6AM7/xOTI+SIolgLUn6qUzYw6/OMX8ACkyEb0Pf+Pz0WlKmsbxH/lpL/G53LMfiGAUxSbRNR8Aktwx93MVj0eR7dCWvqzKS3P0lg0we/x67oNYHKsHhT2lmJoJ1yJrbYWqPZMpasAdVQu4dRw0UMGoua1ehG10MXT7IpcWI6DbMA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(14060799003)(1800799024)(35042699022)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uU3wxI2Zm6iFlt4XKycXi8n04XvBN95JthdG+P2SElhtJl9Crdmb/jqsAnW0g4USmLkFPaQbJ5AydP6p1C67Y66kO8rjbuIKOmLlK5bB4s2tzT9gy7dPe4KL0mkcqW1uKf6wFQ5mtVjOoA5MYBKL3GfODBT7JSYjl0NPssnGWK0UdSRbC+DaN09VcozwQFvx40SU4tuCdDy7DdcXk89fFK+FEtEoxjVROsZnSVdPGRONUIXNuPfnvv8DBmWY/QdDmu/arCo7eMrK0WYdoWEh5q2BdzNpvneBAt8YjMDU7xqpX5y+rhEV8bWBTxTnBox2Q2BsdNXOHPKlxkocB+MjfXEl9+axBI9YhdDp3uuQ1IkpTWH61dzatqsiU/qBwHcrRK2pMleKT0rj+1hJW39oMC+QK5G/D4z24Q1AW4UKmlb7I9+L3WAzU5ZmOrigZvwB
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:42:27.1961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: daeff0f7-8c4a-499e-3b9b-08df0a799857
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5754

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
index e5b92ac09e69e..55f7c5c74d1ab 100644
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
index 9a3b92e626adb..cd709eb426b5f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -885,6 +885,26 @@ static void handle___tracing_write_event(struct kvm_cp=
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
@@ -932,6 +952,8 @@ static const hcall_t host_hcall[] =3D {
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
index 5b599821b2da2..d7d6db5014269 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1054,6 +1054,8 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe =3D vgic_v5_vpe_id(vcpu);
=20
 	/*
 	 * On the WFI path, vgic_load is called a second time. The first is when
@@ -1066,7 +1068,15 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
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
@@ -1084,7 +1094,9 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
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
index a00d5151536bd..aadd47c959b98 100644
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
