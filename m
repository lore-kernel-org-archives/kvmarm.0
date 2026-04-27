Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010057.outbound.protection.outlook.com [52.101.84.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9A734DB46
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306260; cv=fail; b=GYwEnmbG4hJmufN4PPtelDjhw7kndbQBhgqLaP8ClRVx9tfbLvnUm4PRvkNHo6sDsKjn8IO6vxUHUI9fzKjFyHgwcrG8xmSurDKahgUNVdKnf6pg6aG2RsqI5fRGOKFUQrpYDUnuFJCu5AVu0QEiVNSYj+GoZPrufazEEr1t+GQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306260; c=relaxed/simple;
	bh=iF8dVCdhrh0NMG1xo9ZWgXaWshkfSy+tSZrq4QZGkq4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GlMABLIHg6+p3tPRxDC5t/hvTRD1LY4wwFui+PgpeBt2QsuFMVyie1hjWm3G3TRHFRWoeoNKQGpkJb0bcmTPYek9BVp6NbQioBwcA2c6Ta3LUowZU5hnqsvFwsVYbYwKqa+728PnuPIaDv8d+0MW0fo6WdDafuaTSsM3tCip7S4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M0AdeTh4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M0AdeTh4; arc=fail smtp.client-ip=52.101.84.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M0AdeTh4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M0AdeTh4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=o2Ec+g0JEp0H7DtLPiXI2oSf0TQuMOju0XnXgjgFGwNRjODmNKPk2pEaDvH2d7FqJifsYuI9v7dCA6AYym5Q5MXMFr/ULh1RNv5HFOc7OEcdeJpvAKRUfhB1gIFWtKgEQsXCIJkOwBgPThWVAk7dYhO9TPQyvK+BFcVXSpJF60Mrk6BNyWVRC/718YCjNpeqXmwZ91ZXFpRcs+27MWZxMCEaJSSQSYb+Y1bIKxuSpXj0ZqM4bmBkivQcgRuLkiJVMI+bYZ6QNJ2tdMNouwZG1wdLz4cg2x50Cv1b7zQqdPBpbad3Hs6vDcI7nWMI1rxCbT9FlC6ZLVr7R4bHk7MInQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OruXaNy1Asmro9exyrcQK2A+M16A9okcoyC04PRhbxg=;
 b=V1xjWfWD90m9TBFSv1cTjRrzLLNmp1m763bzzndgb1ikRae0CIXLmIfDa2mFWLm1wDbR3bgC9Q5llfgv6CgZ61OHYNxXCIZttjsz2wdlyxA+2KRAs5D5AMNolsHdSG2PASXUTJIT1ddeIKuVj+hEyixYzTkPp9ZyO0VsB9rI6s2eh8yzXI8lzlmVbMebxENvMjxllRALN6V+XFZvmT2LTfQgxWTmQilmHvQ6Vsn5zalnBOZLbhtNd6PQPMxvjQOtsVXkxADLhBpRnigWO36EIt7bFoxMezzsshmXLX8gs3M6LNa6dPganI9McSOrLS0E8cj+LRcDQ0ekrnJNdPsJ/A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OruXaNy1Asmro9exyrcQK2A+M16A9okcoyC04PRhbxg=;
 b=M0AdeTh4wihHTRMUM00As4kC0YofrOVemiQvN0lcFX9FVHLp32bqM3133nKHS1e297pKjGL/yc3qmaUCYfBZD32jH0ErwSFunrDVz5uijVpGJW0hRLJMDV45lgrMtUtgtsKAyKwnRUgyTIzPp07rlFnoOOVkRcOys/Pi6dqJLIU=
Received: from AS9PR06CA0405.eurprd06.prod.outlook.com (2603:10a6:20b:461::35)
 by VI0PR08MB11135.eurprd08.prod.outlook.com (2603:10a6:800:252::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:10:50 +0000
Received: from AM4PEPF00027A64.eurprd04.prod.outlook.com
 (2603:10a6:20b:461:cafe::9b) by AS9PR06CA0405.outlook.office365.com
 (2603:10a6:20b:461::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:10:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A64.mail.protection.outlook.com (10.167.16.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:10:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=USL5U8zFy+9sHhKNmG3m5Lx5+s03tMgNPOK5ZisRAGELv9qngUy0ttgRia9SdExniSvJP7xgRhOn8HVLXIUVHLKlb/PZTXSTH1MTfIVN4Tb429heNcqplBwSvydyFZXe+W6+cAFtgZxAbB1ANBJRk5DRvNTeA34U1Jij2Dv9it2sn0Ea8rtwC4nQcsrehBzVCuD0LCLgWn7XEhl0CqT4plt2vbhxiCGEt52cwdnbwatehbH/3QW7rOkPY0CrF9wj+X6/LCZpB7LVGy7mWyOKG11WFhVRz2H+Agctnyi51VGyYZceJPLcBfkFLgeF8EaO/eA4Px4hTeuELeV3FGf0Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OruXaNy1Asmro9exyrcQK2A+M16A9okcoyC04PRhbxg=;
 b=l7W+IZ/nk7xpTGh0uYdC3yulrVJn1G+c5c41cBVWnccOJhEWpqu9UEzlHBl0AWBdK6VdFp2sBmZnpJ+n5omiPg497OkhFUIxtZukNSSMy6Ha3uVqnxwCEe0vQuLqlALQijQyH8ENwAmdx5AsZUmQBJOsNXbGpRAHHO5BaSBCOimhKfA06HApFKnVu+DHs3TnjrjS+NLiz1W/+fQ2mwOS/O5F2usW4oBV8IOl3bGOVJCK2brgA4uu6gx61OjG6H7wJuj839OshvE9uLqwOr2ltgKFX69njk6c7brzwOwU8DcU467HwZFGtGYfZPXX+6PLBzLMAdzpXvd2QhcdZHhW5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OruXaNy1Asmro9exyrcQK2A+M16A9okcoyC04PRhbxg=;
 b=M0AdeTh4wihHTRMUM00As4kC0YofrOVemiQvN0lcFX9FVHLp32bqM3133nKHS1e297pKjGL/yc3qmaUCYfBZD32jH0ErwSFunrDVz5uijVpGJW0hRLJMDV45lgrMtUtgtsKAyKwnRUgyTIzPp07rlFnoOOVkRcOys/Pi6dqJLIU=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:09:47 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:09:47 +0000
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
Subject: [PATCH 11/43] KVM: arm64: gic-v5: Make VPEs valid in vgic_v5_reset()
Thread-Topic: [PATCH 11/43] KVM: arm64: gic-v5: Make VPEs valid in
 vgic_v5_reset()
Thread-Index: AQHc1mBFVfcFFy+gpUuBzVksi2chFg==
Date: Mon, 27 Apr 2026 16:09:47 +0000
Message-ID: <20260427160547.3129448-12-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|AM4PEPF00027A64:EE_|VI0PR08MB11135:EE_
X-MS-Office365-Filtering-Correlation-Id: 89fa125d-a620-418e-f729-08dea4778cc8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 KLY9RVBNc0y0iNu6azzv1t5q1khQkozRMLk/GcXMPHYHCJMhikwStaMSoHEdZJSDjYaaHxvsd8GS/enEXcEX2chA01m2j3CmGEXU3vq5dYai+9eBlWbNRSbHUNnm6bP71hNCnGi393BU1nQCZrJAxd7qWDb1PXgU4/lojlAt/saoI15BlrSqqFAcwmwLA4WPqjBAy8MhzW0hrgSmRDtfIXEMZcSaouoV0JH++OzLM19fXKXmcVAxqtQo9EC1fk1v4LgEn3GjlzdyVgV7T00DGkQ9KTWruaSZ92R/PjnerM8LQjgKf2lOEKRa3L7UbUTObCr48ilL7+29KQ7IqjvgLzfkEGsMtJjyX0zLXO9apdw9EVpW5siQaUDTPckFqcjxCp5fvo93iBURvwVEz9gPq1gm2qz/B2GzbURq/FpK+lFVRH8qRJKWQhMPpCi44dLNW4TWYhPmEThOLORkFxcVUBC9SMM5R/j7jpgMS8/J/gKngcQoujKH2bx4XCLgD1libN47sWJo7/oqJNNsX1/EP7uW7mLv7A2PxqKDUj6HKNHKbGizzDGlpEB8T9v0CB8f9l2tZsS+2fqMwe/XIYW1VQdenHVVutjL4oLZrh/MlsFCgUenRVpP1OXHZ6M0ZYOLMoSjlYt5PCOGCZWWHMWuqYWK6r9LV0Ba4oM8hcZWe/GDExpKcwFU1eM/SV7DGTKu5S3bs9DOpzVSQyOr4spPznvgsuAzTeWVqF9b3x0RhSoSPWCybO3cIUU12yvuG5og8v9sYOE5FqLYkJxvdwd6tFU0supObgAqaIUZyocca0M=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YYHDD+wS16ABIyvrIpyJoKZNupPAwH4vij0HJ2Nqxjzqf/rPFSoNx5SrUJD2QJ/TrqWnCJVP2pIwOGIBxdGVsnV+BVxfnkDdKqm6eKXL2yZDFyoikSCEsfO73eA/z/ZezsBzVFFiN33knNTwa6GONB415WfrrE1gx/KfU63sr9/qa1YVSW/conLI8CSiPWVcQVCsZKt2YbKEiMdmz+Qzv3MMDqUyR091DRrEyH9jX8e84lIUDxgjPSCLnamaF8lB5NcYLqFTaz/XRMpfjAz8XjCn7UJTr02wwXIRXqsWz3qH2Uu+dbRpUp+5w0/P+L5FzSjbBVprncJr5iy4Uc7pJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e5e2374b-e47a-465f-628f-08dea4776789
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|82310400026|36860700016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nUdI5ArTC9DU4EX8pz44w4R1lVTms5GSynh5PuW/vdxmdwEhXf4Jki1O6v8F5Pjj7nm9nhLuz6MClNRIwTV8YS7bGe34NuPlTy4Y2A0EzMOJNLZ4hJvZcYwr8ZQCTplmZEXHjwzIR3KSBk3yZqoMgInyvdXB1/ofoAt+rSEUtxZc6iwuI34B5eHO4iiHtzfbjEMnOrl3qlGm4pHwEk0zApyEm7RE+4ESaWUVMzqGiLdO1c79pb1SL5Uwf7bg0F+PlFBxoBlUlJnQdfgurwSyPQDWA0RPagj32Z/OVKdx7QjsVYAvWKRsvwW01eUw28k4XBywUWAWqeVZhiDtOJh0mpQdG4tlU/4m5GrJMNFk6ksowx3RBGMsQuI+BMYS9++zRZNs44p/QDIS8fG5iCH1r1cOaAmTZtpnVkaYbinMD8ktRXDqQx4Iw4i/vmtHgQyeEAEBYrewkTgAv0vgWL8/M4HW51qx/XihZp9B9UAk0liBFbT4+X0qqFYdtqxJyQM7F4szOBurhTeJDYkYHqYSEiOrKMFHSCO/z7SeGi+DqvZos9QV72KhRhGOOU8uiNps6Lq0LOpYgFkcq/my5zMoDCh9Zv5cv7+Kgfw82pJbadMQZ+KfHlOVyfrUr/jdzCkQXhPNW7592c5YDWgxiF8EsOdxf22XW4dmQ4BNh9fbTnEVc1a60+pWFfBF8RtEhxsSj0uVLA0wGP3HzquR+DD+QaHLZyxuN3irbBAaS4NgA55pBicpmoZLxhgBqDGH0F3PovLUoLkKosO+tGU0DtalKQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(82310400026)(36860700016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pKXq0pf6cNU8xb2d2j8kXALVNqCNTf4t6VFyLQzUamBES5XvU13wHPMgORd6Hje6m9iyRYyMXgaheoJXzlzt/vethbYBMJCFXg4Gv2Aawc7mH6TKte4aQhYwxz3EimkyFSVugFKf6MGFCNhO1l/5ZY/pG7GZnifHxfueukWjG6iiXTZLMzUUg1GwzO7hENL+XyZrQaHo9zmXCfVe9CrgAlAI3iBsWKPqcTV1qRzZ/yWFzw5XlR4KvgARI2DqGXctNVWeqjfy+O3aUmHb7El7amMr7F83a80zz0M6GBEI/sFFH+/CQmiWsesh3DhxZFy+usc0k2Jq9XL9WDC2KeLH/mf6S5X3gvVrtUaSrf/Oqgna33cQZ1ZQMBNbptHsnzpm9F7ntQ4ovhFlF3xPE74snM3WUhUA9c8Ip/DlkCP1SPG/AvXiwufrJyALObKuQSVr
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:10:50.2339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89fa125d-a620-418e-f729-08dea4778cc8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11135

When resetting VPEs, also mark them as valid in the VM VPE Table. This
is required as it informs the IRS that a specific VPE may be made
resident, and without this the IRS will treat the VPE as invalid.

As part of this change, we also introduce a wrapper around the VPE
doorbells - vgic_v5_send_command(). This takes a struct kvm_vcpu
pointer, and the command to run, and triggers the function bound to
the command via that vcpu's doorbell. This is a convenience function
to simplify the code.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 0649729f6b834..92bb63b6dd6bb 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -518,6 +518,18 @@ static int vgic_v5_irs_vpe_cr0_update(int vm_id, int v=
pe_id, u32 cr0)
 	return 0;
 }
=20
+static int vgic_v5_send_command(struct kvm_vcpu *vcpu,
+				enum gicv5_vcpu_info_cmd_type type)
+{
+	struct gicv5_cmd_info cmd_info;
+
+	if (!vcpu)
+		return -EINVAL;
+
+	cmd_info.cmd_type =3D type;
+	return irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd_info);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
@@ -691,6 +703,8 @@ static void vgic_v5_teardown_per_vm_domain(struct vgic_=
v5_vm *vm)
=20
 void vgic_v5_reset(struct kvm_vcpu *vcpu)
 {
+	int rc;
+
 	/*
 	 * We always present 16-bits of ID space to the guest, irrespective of
 	 * the host allowing more.
@@ -702,6 +716,14 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	 * CPUIF (but potentially fewer in the IRS).
 	 */
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+
+	/* Make the VPE valid in the VPET */
+	rc =3D vgic_v5_send_command(vcpu, VPE_MAKE_VALID);
+	if (rc) {
+		/* We can't continue, so mark the VM as dead */
+		kvm_vm_dead(vcpu->kvm);
+		return;
+	}
 }
=20
 int vgic_v5_init(struct kvm *kvm)
--=20
2.34.1
