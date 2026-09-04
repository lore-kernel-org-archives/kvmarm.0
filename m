Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013046.outbound.protection.outlook.com [52.101.72.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC7B339363
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522339; cv=fail; b=ivwmmuQbXbaCDe3tyRd3OXyXvVe0V3NplnBctyG4mnskRLQ+3oN2jxY2RTlGQf64x2WGKl5ENfZ2AeWap6ozYDkF5mbP3bElP0KhT8K823Ye3K8ujLyTfmmEf6NGCRH/ampUyy8MdFB/TAXgooAHhroqwPGzInDkcuyYb0a+JgA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522339; c=relaxed/simple;
	bh=2WScXJtUttXK/MGaDpkDu2P93iy0FiA5niyhz0IiXdo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bvp5VPn8UCtYfWhFZk9z1IOiZSTzp0uyBU/lejyaeK0n9xY/mb/2QbTYaR1cv5Vod+MIRyGWmHlHsiOPEyND52/lUwRqNVVg2ptYWJ/FvExbx+FcY2Xs+4NbJfgzHbDlI3kh8TBff91qTk/X53QnqAo2sZ4aT61XCGllLpa9ZD8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f5APIwOe; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f5APIwOe; arc=fail smtp.client-ip=52.101.72.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f5APIwOe";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f5APIwOe"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kh13a+zPMy4KJGxR5c+Gc3pLphqV3vwEeHh8CCKFITuZlKbquizogyUAe9JY4vP8fEKNBfgpLCvuR3oIaT6jria1bib88AgedjUVzlzp0j0DpjpGYJeF1wWSH0NfLrZsvEIxJeBsohDIc5zkIjzp30mryDKmirAzJl/StQz7zFrJejWTk+C3hdl0S56IHZhrPr5aGXDCZ3LoIKMp34kR8yLvCZ75Qcl6yMUFjWLVc/kKw1OVa+2p8JYfz9T8Sg7AxRNMtL1i0oSPUKPE0AvPz29+jUFzrspBJ1bjsCQCKHl78icZS3sJw9+72OJyLgClfa+2SFY4Vv41tkjygTlGtg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrY9OuL3EWjZciiv4K8MUtFYsnGlmE2m54rcAIhR9x0=;
 b=qB5JmcePToC6kJtYUo0E1Nq27Dz2rgG1APRqxmayWJebSM4Fm57EaVIX9YpxeK+vpkpcRkPfqLlYx43UaKE9X4yYWDa3aMxv8CX68ZRK93TEL+Io/8VPVHUHT/NNHuNRGURR/DFMU1N8HkZe8+IdoqymiH7WpLZP+rea1HzAoOpnhq1k+M3SXQ86oCC9TOSOk/UyMah5Hq4776/KPFojhNt3Vwv5/eE93xVHLgL0FXIoxg9KeNB+wgSHS3jShyxw60kOANgUYlG1n/onSI8H1kuzx+k4OoCC24946+wB+zzjiDNAQXj+mWEDNMBG50pYCI6/EWb2lEM3QCuGhnrigw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrY9OuL3EWjZciiv4K8MUtFYsnGlmE2m54rcAIhR9x0=;
 b=f5APIwOe1vKdGOeqSWi1uI6JxcKHAyLSPCAMGyAXLXvqZquf2GQumed1fHvHOfMqCSo0ZHnAa+Z8FPWCobKRL5Xhd7Ic0ubVDmMm0jIiyEugZmoJaCeXF0LLsu69kuTZAxuiD+0Dw26ycUTtJnZxCIGxsISXBQWFbdwt5zvLhgk=
Received: from DUZPR01CA0120.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::18) by FRWPR08MB11678.eurprd08.prod.outlook.com
 (2603:10a6:d10:1af::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:45:29 +0000
Received: from DB1PEPF000509E2.eurprd03.prod.outlook.com
 (2603:10a6:10:4bc:cafe::2) by DUZPR01CA0120.outlook.office365.com
 (2603:10a6:10:4bc::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:45:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E2.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 11:45:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/gr+S6VDtY6FZ7EXknCo9qukUpveCeTkA2lYaaatuHBZxqW8emuHrsMETsONrcztPV7HUNbz4D3Tavunt4M1YbHOq8G/fpnHKAbWRUGWCWKMns5/lodumXK0YTLB5uh/W8AStif5xSlp2D6/iaajOxC/0iMRQ6DKcNMHGAhjM2tWRYe0L3f+XLXNmUJqqD+Jci9Lxrjx4BCuc8BzriynaqQ3g3+aQbA3l0QCZEQZqJ0pxpRQx/A9e+NUjkOpLenk29CaPBO18Y7JutEKT2oCyS9Oz0rH5aklPJ/0EVCOC3GvO7jURHrcZ+AwSKRU2naIhiP2tP8WFjsVForxHtf4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrY9OuL3EWjZciiv4K8MUtFYsnGlmE2m54rcAIhR9x0=;
 b=LEfpAcrpY7HgA/LXgBvHI+7tRpBt00FatgSRDHL3+X6ucuWwaA5rnL5UOhAozgG6OGvB4ObBjt6mA2razMQIOP5womgbV4decNAu0Ywt+4Wd0OmQyv2pa0d/iH1IqYDg4Dj6KKuoYjIhOwhzZK1ocVcuLnd/gxRAosqaEWiHXGwFlLk4YcNO365q8rTiGpwwDhts2JiC0cx6TxBPsOP2Hu26/lNk6Divk+f5yh5iznDQOtW6EpL+0mCUhggENLpqzPEIgTlSwIVkmzh8/aMp3QkEPIX09XF7bJTNk82gOOj1eG67e7B0E7CTYlTuTAlz4snSENEnFyyhov7Wq4FC5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrY9OuL3EWjZciiv4K8MUtFYsnGlmE2m54rcAIhR9x0=;
 b=f5APIwOe1vKdGOeqSWi1uI6JxcKHAyLSPCAMGyAXLXvqZquf2GQumed1fHvHOfMqCSo0ZHnAa+Z8FPWCobKRL5Xhd7Ic0ubVDmMm0jIiyEugZmoJaCeXF0LLsu69kuTZAxuiD+0Dw26ycUTtJnZxCIGxsISXBQWFbdwt5zvLhgk=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:44:56 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:44:56 +0000
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
Subject: [PATCH v6 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Topic: [PATCH v6 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Index: AQHdPGLOAAp2qxH23U6bJhW8igmkYw==
Date: Fri, 4 Sep 2026 11:44:56 +0000
Message-ID: <20260904113404.4051341-22-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|DB1PEPF000509E2:EE_|FRWPR08MB11678:EE_
X-MS-Office365-Filtering-Correlation-Id: 529d61cf-7be4-4148-b033-08df0a7a04f7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Py0Ve/IgzJ0uYxV4MjI5onVvrwO3i8M66gLHmm1Gj1HtDl0KuFjYJAtKtwGtxW9CoH1+szzYeU9Kx/JFSxiqfmlhgCVdnEkaw90g7xMDML1z21zqx4nGaqX5UaXnxxBrsa6pEMmJS+Oetps5FSO4yFN+IOCKWB0LFv3zDxUl/dAipWTNB4rXU2ZeDRd0gzuQPU3nrPodH0IV3ZdxkPx7JQCqKWqMw9Pw53dlpKszbGYzlfTduw8Nv2fB7uNVO8+PBi1+7CDhp9N7Qq0bBzn5MgD8V7+9mXtjWS4uEaSYceNJ6X2ObSE+gRHazbWmDh8b2ttAFR2bOsh1eLY2FTwWpMvR/bpWvtDc71JY+4nvWwWZ6xQcvUQFCRVXTjJG7pajovVVhK+25/LYuwV6CiFJu16lwqVZf6wxMtzLdpIulyshYpRxklq/TnvhlsASdgCiViF2tvRplT9o57FFZbzZ5froqpv1QO2iyJn1nqqTvzhD4iF5sJEIFZSxlmaXMsHGLOiy6qTApNyzyOxdvZ0Ob9t7PrN3cN/wwCUE2diriZPMe1AX/kQAztypfhQO4K5ayJkeYZK8niEUJvgV6h/FyRXJMDTXwAJ6XZKf/axkLeVwh2Jixmt4b4v7RvF4SWkgHH6EylH+SQ1FSg9b94MfFGm/pEk8hVdgc7zHFtF3ZLi9cO9Uom5k1l8R9fpmhN5vopv2JPhUlXBchcqcqz0eCwWfC38Dn8vyqhS+XZ9GYQ0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 26BnJK4DS0bcohubSQhMDskkrm2cZqLC3pR1t2bnuNjmpupFODLzTOznNTKUeJoLhL9kE/bgIDIhpSBT+sU4Y5ID2okmafE+7xD5vmlbyeSB72BpFPSCBLwXb7C/Eds646WfYTP9031jmzZPkmcOgAJXPfNUIfNpvvEXIeV0QTVaUiY/As7D111d6Foe8ofgVr6q2wrwZYFxPbBRzLgJ/MRO6JtSKc2yCVRusFXbRTqImVG5FgAybcG/hCNsgN81lez4lH1dXjw3F0w3ryaF0HDUAf0UFCSm7KAoGnFW9qRs1t6aqG23kAPXoflxhEk982RUxA5vwQn4n7gTx2ECMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d688647d-3757-4ec6-ba4c-08df0a79f13c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|376014|35042699022|1800799024|23010399003|82310400026|10067099003|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Ou4Ab9yaOpcOTC+0ZOchlhPmXn+Fe1s5onMJpR0jZpyikMgbyz/6WKUI4uOP+vAL6C/0ccCJRQO7Yy8uWjx159IzMqNMdGgWUiHSGtzp2ekc0gq5Hmom3FXqKmIr6oMGoEAqXB5tInaF3zRCoXs6CPZvmEpGWMBbU32WP64FJpxjSW1/wnRoo+wZrz8pONonK4aiWf7KRb6nSTKH5i8u7osOoiM/26wKeOCwWY7BrIuUTxR6piVYNrKeT3mgQm97pnsg+xk4i511VnjvYg1OxCkG6NBMgkyyfqVuS0RIOjzyv1rQqeJQqU4TIBtynN6DnLNYadovxkEnH59HqYIVwlGLbGJKI0SgqRfnBn2l0qPdyU8dUWPlUlTEijMhkGH6zGYIEoNHbjOCJy6RHcEB52ZD8/OF5aM2MdWKAd5rjGIyK4jXuqCfzsRR3uzAyyPwkywmtwzsF5R6t7knzXO/BrYYGo/g74xkUrNgDx6TyePDiTKz5jd/3oMbacvYZFikwPGsGOw8p9OGTEQLQLNQKP1AuLB2SF8M2LBjnWRQA32vmHS+iwQDZgLinQTDvN7TAK9tpB3l65sv1KRNGxSvI9bILqk35RfB7kTLpOMTXbirAe0u3Ce56mz39hUOXjjJi7dPpvoHRcA+l71r6/sUbCihgMqm6SZovuLpLGZG6/g=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(376014)(35042699022)(1800799024)(23010399003)(82310400026)(10067099003)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EsTiSBOS9H6m//Tv7JWtHSqfRNPfb2rcAfYiD5+rflVUArhiGEe9cXT1I9Bm1NQ/gxc8mOEzd3UP92Hho0vZ7UQ1N4i9LUT7dUoR6RmZvGXwX64A5YJXuPgOOiBWFn46tASwaf3JLPeXo9PGZ8ybJnMVZ9uH4c6uZzB6RU4ILtQX9H5MPRetJfvs3PDDP9qIv/ZS4610+Tskqz3ufOVvT6+pyL4TI2xvtdpSBd/fY0lurv1A2MNQR1kNN4CO8Xtucnp1+ki2wUVFTjOZgcdljTNzPV6eb8RTQT8SlssMpulGu0k8GGCT1wCeCDpLOB4kpLXZpnnUn+DNMLDqgg8zXYVW6EhnpM0l3Ch7mRRNV883cTPyD8skob9c7J8SWrGfhLGKYdLMh1tU9bCRBcGR8dO8cgP7ijT1wSA8N+25qV9GMROQZgTzZmSO3U9RXfz8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:45:29.4387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 529d61cf-7be4-4148-b033-08df0a7a04f7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRWPR08MB11678

A virtual GICv5 needs an emulated IRS in addition to the host IRS
state used to back VMTEs, VPEs, and ISTs. Without this, KVM can only
provide the CPU-local PPI state and cannot expose the IRS-backed SPI
and LPI configuration expected by a GICv5 guest.

Allocate the per-VM emulated IRS state when creating a virtual GICv5,
and initialise it from vgic_v5_init(). If userspace has not provided a
number of SPIs, use the GICv5 default of 32. The IRS init path
allocates the SPI state, initialises the virtual IRS register state,
and creates the backing SPI IST when SPIs are present.

Keep the per-VM IRS object alive for the lifetime of the virtual
GICv5.  vgic_v5_teardown() only unwinds resources allocated by
vgic_v5_init(), so failed initialisation can be retried, while
kvm_vgic_dist_destroy() frees the IRS object during final VGIC
destruction.

This gives virtual GICv5s the IRS backing required for SPIs and LPIs,
rather than being limited to PPIs only. Further patches add support
for SPI injection and lifecycle tracking.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c   | 61 ++++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  4 +-
 arch/arm64/kvm/vgic/vgic-v5.c     |  8 +++-
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index ccbeb2f783c49..9b504b02aae03 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -187,29 +187,49 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 			break;
 	}
=20
-	if (ret) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
-			kfree(vgic_cpu->private_irqs);
-			vgic_cpu->private_irqs =3D NULL;
-		}
-
-		kvm->arch.vgic.vgic_model =3D 0;
-		kvm->arch.vgic.in_kernel =3D false;
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_private_irqs;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
-	/*
-	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
-	 * have been initialised at this stage, but will have done so assuming
-	 * that we have an older GIC, meaning that the IntIDs won't be
-	 * correct. We init them again, and this time they will be correct.
-	 */
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		/* Allocate a vIRS for GICv5 systems */
+		kvm->arch.vgic.vgic_v5_irs_data =3D kzalloc_obj(struct vgic_v5_irs,
+							      GFP_KERNEL_ACCOUNT);
+		if (!kvm->arch.vgic.vgic_v5_irs_data) {
+			ret =3D -ENOMEM;
+			goto out_free_private_irqs;
+		}
+
+		/*
+		 * Initialization happens later, for now just explicitly
+		 * disable the device and undef its base address.
+		 */
+		kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base =3D VGIC_ADDR_UNDEF;
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
 		kvm_timer_init_vm(kvm);
+	}
+
+	goto out_unlock;
+
+out_free_private_irqs:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
+
+		kfree(vgic_cpu->private_irqs);
+		vgic_cpu->private_irqs =3D NULL;
+	}
+
+	kvm->arch.vgic.in_kernel =3D false;
+	kvm->arch.vgic.vgic_model =3D 0;
=20
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
@@ -496,6 +516,9 @@ int vgic_init(struct kvm *kvm)
 				return ret;
 		}
 	} else {
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
 		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			return ret;
@@ -545,6 +568,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V5:
 		vgic_v5_teardown(kvm);
+		kfree(dist->vgic_v5_irs_data);
+		dist->vgic_v5_irs_data =3D NULL;
 		break;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 76f5f40ecc1ce..35caf51d88310 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -748,8 +748,8 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 	 * capability.
 	 */
 	if (vgic_v5_irs_ist_id_bits(&irs_caps) < 16)
-		pr_warn("Host IRS supports fewer than 16 ID bits for ISTs (%u)\n",
-			vgic_v5_irs_ist_id_bits(&irs_caps));
+		pr_warn_ratelimited("Host IRS supports fewer than 16 ID bits for ISTs (%=
u)\n",
+				    vgic_v5_irs_ist_id_bits(&irs_caps));
=20
 	irs->idr2.id_bits =3D min(16, vgic_v5_irs_ist_id_bits(&irs_caps));
 	irs->idr2.min_lpi_id_bits =3D vgic_v5_irs_min_lpi_id_bits(&irs_caps);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 5a058ef8fe701..bdf06dbff4231 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -668,7 +668,8 @@ void vgic_v5_teardown(struct kvm *kvm)
=20
 /*
  * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
- * doorbells, allocate VPET and populate for each VPE.
+ * doorbells, allocate VPET and populate for each VPE. Finally, we also in=
it the
+ * vIRS, which means allocating and making the virtual SPI IST valid.
  *
  * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
  * our conduit for communication with the IRS, which means we need to have=
 those
@@ -747,6 +748,11 @@ int vgic_v5_init(struct kvm *kvm)
 			goto err;
 	}
=20
+	/* Init IRS (and alloc SPI IST) */
+	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);
+	if (ret)
+		goto err;
+
 	return 0;
=20
 err:
--=20
2.34.1
